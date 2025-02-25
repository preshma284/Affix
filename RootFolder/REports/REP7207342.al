report 7207342 "Generate Purchase Journal"
{


    CaptionML = ENU = 'Generate Purchase Journal', ESP = 'Generar Dia.Neces.Compra';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.")
                                 WHERE("Job Type" = FILTER(<> 'Deviations'), "Blocked" = CONST(" "));
            ;
            DataItem("DPU"; "Expected Time Unit Data")
            {

                DataItemTableView = SORTING("Entry No.")
                                 WHERE("Piecework Code" = FILTER(<> ''), "Performed" = CONST(false));


                RequestFilterFields = "Expected Date";
                DataItemLink = "Job No." = FIELD("No."),
                            "Budget Code" = FIELD("Current Piecework Budget");
                trigger OnPreDataItem();
                BEGIN
                    IF NOT Job."Management By Production Unit" THEN
                        CurrReport.BREAK;

                    IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN  //JAV 26/09/22: - QB 1.11.03 En estudios no verificar presupuesto actual, es la propia versi¢n
                        DPU.SETRANGE(DPU."Budget Code", Job."Current Piecework Budget");

                    IF DPU.ISEMPTY THEN
                        ERROR('No hay datos de fechas para calcular');

                    PurchaseJournalLine.RESET;
                    PurchaseJournalLine.SETRANGE("Job No.", Job."No.");
                    PurchaseJournalLine.SETRANGE("Journal Batch Name", Section);
                    IF DPU.GETFILTER("Piecework Code") <> '' THEN
                        PurchaseJournalLine.SETFILTER("Job Unit", DPU.GETFILTER("Piecework Code"));
                    IF DPU.GETFILTER("Expected Date") <> '' THEN
                        PurchaseJournalLine.SETFILTER("Date Needed", DPU.GETFILTER("Expected Date"));
                    IF (PurchaseJournalLine.FINDSET) THEN
                        REPEAT
                            PurchaseJournalLine.DELETE(TRUE);
                        UNTIL PurchaseJournalLine.NEXT = 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    //JAV 27/10/20: - QB 1.07.00 Si no existe la unidad de obra, la elimino y me salto este paso, ya que es por no haber borrado bien los datos de esta tabla en alg£n paso
                    IF NOT DataPieceworkForProduction.GET(Job."No.", DPU."Piecework Code") THEN BEGIN
                        DPU.DELETE;
                        CurrReport.SKIP;
                    END;

                    //Recorro todos los descompuestos de la unidad de obra
                    Window.UPDATE(2, FORMAT(DPU."Piecework Code" + ' ' + DataPieceworkForProduction.Description));
                    DataCostByPiecework.RESET;
                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code", DPU."Piecework Code");
                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.", DPU."Job No.");
                    IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN  //JAV 26/09/22: - QB 1.11.03 En estudios no verificar presupuesto actual, es la propia versi¢n
                        DataCostByPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                    //DataCostByPiecework.GETFILTER("No.",PurchaseJournalLine."No.");
                    //JMMA COMENTADO PARA PODER EJECUTAR PRUEBAS DataCostByPiecework.SETFILTER("No.",PurchaseJournalLine.GETFILTER("No.")); //QB2017

                    IF DataCostByPiecework.FINDSET THEN BEGIN
                        REPEAT
                            IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource THEN
                                //JAV 30/10/19: - Para evitar un error si no tiene definido el recurso
                                //Resource2.GET(DataCostByPiecework."No.");
                                IF NOT Resource2.GET(DataCostByPiecework."No.") THEN
                                    Resource2.INIT;

                            IF (DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Item) OR
                               ((DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource) AND
                               (Resource2.Type = Resource2.Type::Subcontracting)) THEN BEGIN

                                //Mirar si hay una l¡nea que ya exista para poder aumentarla
                                PurchaseJournalLine.RESET;
                                PurchaseJournalLine.SETRANGE("Job No.", Job."No.");
                                PurchaseJournalLine.SETRANGE("Journal Batch Name", Section);
                                PurchaseJournalLine.SETRANGE("No.", DataCostByPiecework."No.");
                                IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource THEN
                                    PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Resource);
                                IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Item THEN
                                    PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Item);
                                PurchaseJournalLine.SETRANGE("Job Unit");
                                CASE opcBreakDownByPiecework OF
                                    opcBreakDownByPiecework::Boths:
                                        BEGIN
                                            PurchaseJournalLine.SETRANGE("Job Unit", DataCostByPiecework."Piecework Code");
                                        END;
                                    opcBreakDownByPiecework::Items:
                                        BEGIN
                                            IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Item THEN
                                                PurchaseJournalLine.SETRANGE("Job Unit", DataCostByPiecework."Piecework Code");
                                        END;
                                    opcBreakDownByPiecework::Resources:
                                        BEGIN
                                            IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource THEN
                                                PurchaseJournalLine.SETRANGE("Job Unit", DataCostByPiecework."Piecework Code");
                                        END;
                                END;
                                IF opcBreakDownByDate THEN
                                    PurchaseJournalLine.SETRANGE("Date Needed", DPU."Expected Date");

                                //JAV 03/05/20: - No mezclar diferentes actividades
                                IF (opcActividades) THEN
                                    PurchaseJournalLine.SETRANGE("Activity Code", DataCostByPiecework."Activity Code");

                                IF PurchaseJournalLine.FINDFIRST THEN BEGIN
                                    //Si se encuentra la l¡nea, debe aumentarse
                                    IF PurchaseJournalLine."Unit of Measure Code" = DataCostByPiecework."Cod. Measure Unit" THEN BEGIN
                                        //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                        //PurchaseJournalLine.VALIDATE(Quantity, PurchaseJournalLine.Quantity +
                                        //                                       (DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework"))
                                        PurchaseJournalLine.Quantity += DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework";
                                    END ELSE BEGIN
                                        IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Item THEN BEGIN
                                            IF ItemUnitofMeasure.GET(DataCostByPiecework."No.", DataCostByPiecework."Cod. Measure Unit") THEN
                                                BaseQuantity := DataCostByPiecework."Performance By Piecework" * ItemUnitofMeasure."Qty. per Unit of Measure"
                                            ELSE
                                                BaseQuantity := DataCostByPiecework."Performance By Piecework";
                                            //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                            //PurchaseJournalLine.VALIDATE(Quantity, PurchaseJournalLine.Quantity +
                                            //                                       (DPU."Expected Measured Amount" * (BaseQuantity / PurchaseJournalLine."Qty. Unit Measure base")));
                                            PurchaseJournalLine.Quantity += DPU."Expected Measured Amount" * (BaseQuantity / PurchaseJournalLine."Qty. Unit Measure base");
                                        END;
                                        IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource THEN BEGIN
                                            IF ResourceUnitofMeasure.GET(DataCostByPiecework."No.", DataCostByPiecework."Cod. Measure Unit") THEN
                                                BaseQuantity := DataCostByPiecework."Performance By Piecework" * ResourceUnitofMeasure."Qty. per Unit of Measure"
                                            ELSE
                                                BaseQuantity := DataCostByPiecework."Performance By Piecework";
                                            //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                            //PurchaseJournalLine.VALIDATE(Quantity, PurchaseJournalLine.Quantity +
                                            //                                       (DPU."Expected Measured Amount" * (BaseQuantity / PurchaseJournalLine."Qty. Unit Measure base")));
                                            PurchaseJournalLine.Quantity += DPU."Expected Measured Amount" * (BaseQuantity / PurchaseJournalLine."Qty. Unit Measure base");

                                        END;
                                    END;
                                    //JAV 10/06/21: - QB 1.08.48 El Validate de cantidad no sirve, recalculamos
                                    PurchaseJournalLine.UpdateCost;
                                    PurchaseJournalLine.MODIFY(TRUE);
                                END ELSE BEGIN
                                    //Si no hay una l¡nea que ya exista y se deba usar, crear una nueva
                                    GetLineNo;
                                    PurchaseJournalLine.INIT;
                                    PurchaseJournalLine.VALIDATE("Job No.", Job."No.");
                                    PurchaseJournalLine.VALIDATE("Journal Batch Name", Section);
                                    PurchaseJournalLine.VALIDATE("Line No.", LineNo);
                                    PurchaseJournalLine.VALIDATE("Date Update", WORKDATE);

                                    //-3685
                                    PurchaseJournalLine.VALIDATE("Code Piecework PRESTO", DataPieceworkForProduction."Code Piecework PRESTO");
                                    //+3685

                                    //QCPM_GAP06 07/05/19 PEL  JAV 09/08/19: - Se a¤ade el proveedor asociado al descompuesto en la l¡nea
                                    PurchaseJournalLine.VALIDATE("Vendor No.", DataCostByPiecework.Vendor);

                                    IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Item THEN BEGIN
                                        PurchaseJournalLine.Type := PurchaseJournalLine.Type::Item;
                                        PurchaseJournalLine.VALIDATE("No.", DataCostByPiecework."No.");

                                        //Q8092 >>
                                        IF DataCostByPiecework.Vendor <> '' THEN
                                            PurchaseJournalLine.VALIDATE("Vendor No.", DataCostByPiecework.Vendor);
                                        //Q8092 <<

                                        Item.GET(DataCostByPiecework."No.");
                                        PurchaseJournalLine.VALIDATE(Decription, Item.Description);
                                        IF ItemUnitofMeasure.GET(DataCostByPiecework."No.", DataCostByPiecework."Cod. Measure Unit") THEN BEGIN
                                            BaseQuantity := DataCostByPiecework."Performance By Piecework" * ItemUnitofMeasure."Qty. per Unit of Measure";
                                            QtyUnitOfMeasureBase := ItemUnitofMeasure."Qty. per Unit of Measure";
                                        END ELSE BEGIN
                                            BaseQuantity := DataCostByPiecework."Performance By Piecework";
                                            QtyUnitOfMeasureBase := 1;
                                        END;
                                        Window.UPDATE(3, FORMAT(DataCostByPiecework."No." + ' ' + Item.Description));
                                    END;
                                    IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource THEN BEGIN
                                        PurchaseJournalLine.Type := PurchaseJournalLine.Type::Resource;
                                        PurchaseJournalLine.VALIDATE("No.", DataCostByPiecework."No.");
                                        Resource.GET(DataCostByPiecework."No.");
                                        PurchaseJournalLine.VALIDATE(Decription, Resource.Name);

                                        IF ResourceUnitofMeasure.GET(DataCostByPiecework."No.", DataCostByPiecework."Cod. Measure Unit") THEN BEGIN
                                            BaseQuantity := DataCostByPiecework."Performance By Piecework" * ResourceUnitofMeasure."Qty. per Unit of Measure";
                                            QtyUnitOfMeasureBase := ResourceUnitofMeasure."Qty. per Unit of Measure";
                                        END ELSE BEGIN
                                            BaseQuantity := DataCostByPiecework."Performance By Piecework";
                                            QtyUnitOfMeasureBase := 1;
                                        END;
                                        Window.UPDATE(3, FORMAT(DataCostByPiecework."No." + ' ' + Resource.Name));
                                    END;

                                    //JAV 05/10/21: - QB 1.09.20 Poner una descripci¢n inicial
                                    IF DataCostByPiecework.Description <> '' THEN
                                        PurchaseJournalLine.Decription := COPYSTR(DataCostByPiecework.Description, 1, 50);

                                    //Calculos por tipo de desglose
                                    CASE opcBreakDownByPiecework OF
                                        opcBreakDownByPiecework::Boths:
                                            BEGIN
                                                PurchaseJournalLine.VALIDATE("Job Unit", DataCostByPiecework."Piecework Code");
                                                IF DataCostByPiecework.Description <> '' THEN
                                                    PurchaseJournalLine.Decription := COPYSTR(DataCostByPiecework.Description, 1, 50);
                                                PurchaseJournalLine.VALIDATE("Unit of Measure Code", DataCostByPiecework."Cod. Measure Unit");
                                                //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                                //PurchaseJournalLine.VALIDATE(Quantity, DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework");
                                                PurchaseJournalLine.Quantity := DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework";

                                                PurchaseJournalLine.VALIDATE("Estimated Price", DataCostByPiecework."Direc Unit Cost");
                                                PurchaseJournalLine.VALIDATE("Target Price", DataCostByPiecework."Direc Unit Cost");
                                                //JMMA A¥ADIR DIVISA
                                                IF DataCostByPiecework."Currency Code" <> '' THEN BEGIN
                                                    PurchaseJournalLine.VALIDATE("Currency Code", DataCostByPiecework."Currency Code");
                                                    PurchaseJournalLine.VALIDATE("Currency Date", PurchaseJournalLine."Date Needed");
                                                END;
                                                PurchaseJournalLine.VALIDATE("Direct Unit Cost", DataCostByPiecework."Direc Unit Cost");
                                                //IF PurchaseJournalLine."Currency Factor"=0 THEN
                                                //  PurchaseJournalLine.VALIDATE("Direc Unit Cost",DataCostByPiecework."Direct Unitary Cost (JC)");
                                                //--JMMA DIVISA
                                            END;
                                        opcBreakDownByPiecework::Items:
                                            BEGIN
                                                IF PurchaseJournalLine.Type = PurchaseJournalLine.Type::Item THEN BEGIN
                                                    PurchaseJournalLine.VALIDATE("Job Unit", DataCostByPiecework."Piecework Code");
                                                    IF DataCostByPiecework.Description <> '' THEN
                                                        PurchaseJournalLine.Decription := COPYSTR(DataCostByPiecework.Description, 1, 50);
                                                    PurchaseJournalLine.VALIDATE("Unit of Measure Code", DataCostByPiecework."Cod. Measure Unit");
                                                    //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                                    //PurchaseJournalLine.VALIDATE(Quantity, DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework");
                                                    PurchaseJournalLine.Quantity := DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework";

                                                    PurchaseJournalLine.VALIDATE("Estimated Price", DataCostByPiecework."Direc Unit Cost");
                                                    PurchaseJournalLine.VALIDATE("Target Price", DataCostByPiecework."Direc Unit Cost");
                                                    //JMMA A¥ADIR DIVISA
                                                    IF DataCostByPiecework."Currency Code" <> '' THEN BEGIN
                                                        PurchaseJournalLine.VALIDATE("Currency Code", DataCostByPiecework."Currency Code");
                                                        PurchaseJournalLine.VALIDATE("Currency Date", PurchaseJournalLine."Date Needed");
                                                        //PurchaseJournalLine.VALIDATE("Direc Unit Cost",DataCostByPiecework."Direc Unit Cost");

                                                    END;
                                                    PurchaseJournalLine.VALIDATE("Direct Unit Cost", DataCostByPiecework."Direc Unit Cost");
                                                    //IF PurchaseJournalLine."Currency Factor"=0 THEN
                                                    //  PurchaseJournalLine.VALIDATE("Direc Unit Cost",DataCostByPiecework."Direct Unitary Cost (JC)");

                                                END ELSE BEGIN
                                                    //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                                    //PurchaseJournalLine.VALIDATE(Quantity,DPU."Expected Measured Amount" * BaseQuantity);
                                                    PurchaseJournalLine.Quantity := DPU."Expected Measured Amount" * BaseQuantity;

                                                    PurchaseJournalLine.VALIDATE("Estimated Price", ROUND(DataCostByPiecework."Direc Unit Cost" /
                                                                               QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision"));
                                                    PurchaseJournalLine.VALIDATE("Target Price", ROUND(DataCostByPiecework."Direc Unit Cost" /
                                                                               QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision"));
                                                    PurchaseJournalLine."Qty. Unit Measure base" := 1;
                                                END;
                                            END;
                                        opcBreakDownByPiecework::Resources:
                                            BEGIN
                                                IF PurchaseJournalLine.Type = PurchaseJournalLine.Type::Resource THEN BEGIN
                                                    PurchaseJournalLine.VALIDATE("Job Unit", DataCostByPiecework."Piecework Code");
                                                    IF DataCostByPiecework.Description <> '' THEN
                                                        PurchaseJournalLine.Decription := COPYSTR(DataCostByPiecework.Description, 1, 50);
                                                    PurchaseJournalLine.VALIDATE("Unit of Measure Code", DataCostByPiecework."Cod. Measure Unit");
                                                    //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                                    //PurchaseJournalLine.VALIDATE(Quantity,DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework");
                                                    PurchaseJournalLine.Quantity := DPU."Expected Measured Amount" * DataCostByPiecework."Performance By Piecework";

                                                    PurchaseJournalLine.VALIDATE("Estimated Price", DataCostByPiecework."Direc Unit Cost");
                                                    PurchaseJournalLine.VALIDATE("Target Price", DataCostByPiecework."Direc Unit Cost");
                                                    //JMMA A¥ADIR DIVISA
                                                    IF DataCostByPiecework."Currency Code" <> '' THEN BEGIN
                                                        PurchaseJournalLine.VALIDATE("Currency Code", DataCostByPiecework."Currency Code");
                                                        PurchaseJournalLine.VALIDATE("Currency Date", PurchaseJournalLine."Date Needed");
                                                        //PurchaseJournalLine.VALIDATE("Direc Unit Cost",DataCostByPiecework."Direc Unit Cost");

                                                    END;
                                                    PurchaseJournalLine.VALIDATE("Direct Unit Cost", DataCostByPiecework."Direc Unit Cost");
                                                    //IF PurchaseJournalLine."Currency Factor"=0 THEN
                                                    //  PurchaseJournalLine.VALIDATE("Direc Unit Cost",DataCostByPiecework."Direct Unitary Cost (JC)");
                                                END ELSE BEGIN
                                                    //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                                    //PurchaseJournalLine.VALIDATE(Quantity, DPU."Expected Measured Amount" * BaseQuantity);

                                                    //-Q19864
                                                    Job.GET(PurchaseJournalLine."Job No.");
                                                    IF (Job."Warehouse Cost Unit" = '') AND NOT Aviso THEN BEGIN
                                                        //MESSAGE('La unidad de coste almac‚n no est  informada en proyecto %1',Job."No.");
                                                        ERROR('La unidad de coste almac‚n no est  informada en proyecto %1. Debe informarla para poder hacer acopio', Job."No.");

                                                        Aviso := TRUE;
                                                    END;
                                                    //-Q20082
                                                    //PurchaseJournalLine."Job Unit" := Job."Warehouse Cost Unit";
                                                    PurchaseJournalLine."Job Unit" := '';
                                                    //+Q20082
                                                    IF DataPieceworkForProduction.GET("Job No.", PurchaseJournalLine."Job Unit") THEN BEGIN
                                                        PurchaseJournalLine."Description 2" := DataPieceworkForProduction.Description;
                                                        IF PurchaseJournalLine."Unit of Measure Code" = '' THEN
                                                            PurchaseJournalLine."Unit of Measure Code" := DataPieceworkForProduction."Unit Of Measure";
                                                    END;
                                                    //+Q19864

                                                    PurchaseJournalLine.Quantity := DPU."Expected Measured Amount" * BaseQuantity;

                                                    PurchaseJournalLine.VALIDATE("Estimated Price", ROUND(DataCostByPiecework."Direc Unit Cost" /
                                                                                                          QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision"));
                                                    PurchaseJournalLine.VALIDATE("Target Price", ROUND(DataCostByPiecework."Direc Unit Cost" /
                                                                                                      QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision"));
                                                    PurchaseJournalLine."Qty. Unit Measure base" := 1;
                                                    //JMMA A¥ADIR DIVISA
                                                    IF DataCostByPiecework."Currency Code" <> '' THEN BEGIN
                                                        PurchaseJournalLine.VALIDATE("Currency Code", DataCostByPiecework."Currency Code");
                                                        PurchaseJournalLine.VALIDATE("Currency Date", PurchaseJournalLine."Date Needed");
                                                        //PurchaseJournalLine.VALIDATE("Direc Unit Cost",ROUND(DataCostByPiecework."Direc Unit Cost"/QtyUnitOfMeasureBase,Currency."Unit-Amount Rounding Precision"));

                                                    END;
                                                    PurchaseJournalLine.VALIDATE("Direct Unit Cost", ROUND(DataCostByPiecework."Direc Unit Cost" / QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision")); //JMMA
                                                                                                                                                                                                                      //IF PurchaseJournalLine."Currency Factor"=0 THEN
                                                                                                                                                                                                                      //  PurchaseJournalLine.VALIDATE("Direc Unit Cost",ROUND(DataCostByPiecework."Direct Unitary Cost (JC)"/QtyUnitOfMeasureBase,Currency."Unit-Amount Rounding Precision")); //JMMA
                                                END;
                                            END;
                                        opcBreakDownByPiecework::No:
                                            BEGIN
                                                //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                                                //PurchaseJournalLine.VALIDATE(Quantity,DPU."Expected Measured Amount" * BaseQuantity);
                                                PurchaseJournalLine.Quantity := DPU."Expected Measured Amount" * BaseQuantity;

                                                PurchaseJournalLine.VALIDATE("Estimated Price", ROUND(DataCostByPiecework."Direc Unit Cost" /
                                                                                                     QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision"));
                                                PurchaseJournalLine.VALIDATE("Target Price", ROUND(DataCostByPiecework."Direc Unit Cost" /
                                                                                                  QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision"));
                                                //JMMA A¥ADIR DIVISA
                                                IF DataCostByPiecework."Currency Code" <> '' THEN BEGIN
                                                    PurchaseJournalLine.VALIDATE("Currency Code", DataCostByPiecework."Currency Code");
                                                    PurchaseJournalLine.VALIDATE("Currency Date", PurchaseJournalLine."Date Needed");
                                                    //PurchaseJournalLine.VALIDATE("Direc Unit Cost",ROUND(DataCostByPiecework."Direc Unit Cost"/QtyUnitOfMeasureBase,Currency."Unit-Amount Rounding Precision"));

                                                END;
                                                PurchaseJournalLine.VALIDATE("Direct Unit Cost", ROUND(DataCostByPiecework."Direc Unit Cost" / QtyUnitOfMeasureBase, Currency."Unit-Amount Rounding Precision")); //JMMA
                                                                                                                                                                                                                  //IF PurchaseJournalLine."Currency Factor"=0 THEN
                                                                                                                                                                                                                  //  PurchaseJournalLine.VALIDATE("Direc Unit Cost",ROUND(DataCostByPiecework."Direct Unitary Cost (JC)"/QtyUnitOfMeasureBase,Currency."Unit-Amount Rounding Precision")); //JMMA
                                                PurchaseJournalLine."Qty. Unit Measure base" := 1;
                                            END;
                                    END;

                                    //vamos a llevarnos la Dimensiones del CA de la tabla DCU (DataCostByPiecework)
                                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                                        PurchaseJournalLine."Shortcut Dimension 1 Code" := DataCostByPiecework."Analytical Concept Direct Cost"
                                    ELSE
                                        PurchaseJournalLine."Shortcut Dimension 2 Code" := DataCostByPiecework."Analytical Concept Direct Cost";
                                    IF opcBreakDownByDate THEN
                                        PurchaseJournalLine."Date Needed" := DPU."Expected Date"
                                    ELSE
                                        PurchaseJournalLine."Date Needed" := PurchaseJournalLine."Date Update";
                                    PurchaseJournalLine.VALIDATE("Currency Date", PurchaseJournalLine."Date Needed");//JMMA AJUSTAR DIVISA

                                    //         //JDC 24/07/19: - GAP020 Modified function "DPU - OnAfterGetRecord"
                                    //         IF DataPieceworkForProduction."Outsourcing Code" <> '' THEN BEGIN 
                                    //           PurchaseJournalLine.VALIDATE("Vendor No.",DataPieceworkForProduction."Outsourcing Code");
                                    //           PurchaseJournalLine."Vendor Name" := DataPieceworkForProduction."Outsourcing Name";
                                    //         END;
                                    //         //GAP020 +

                                    //JAV 05/05/20: Tomar la actividad del descompuesto, no de la unidad de obra
                                    //IF (DataPieceworkForProduction."Activity Code" <> '') THEN
                                    //  PurchaseJournalLine."Activity Code" := DataPieceworkForProduction."Activity Code";
                                    //IF (DataCostByPiecework."Activity Code" <> '') THEN
                                    PurchaseJournalLine."Activity Code" := DataCostByPiecework."Activity Code"; //////

                                    //JAV 10/06/21: - QB 1.08.48 El Validate de cantidad no sirve, recalculamos
                                    PurchaseJournalLine.UpdateCost;
                                    PurchaseJournalLine.INSERT(TRUE);
                                END;

                                //Si la l¡nea tiene actividad, marcar que se puede generar
                                IF (PurchaseJournalLine."Activity Code" <> '') THEN BEGIN
                                    PurchaseJournalLine.Generate := TRUE;
                                    PurchaseJournalLine.MODIFY(FALSE);
                                END;
                                //Textos adicionales
                                QBText.CombineText(3, QBText.Table::Job, DataCostByPiecework."Job No.", DataCostByPiecework."Piecework Code", DataCostByPiecework."No.",
                                                      QBText.Table::Diario, PurchaseJournalLine."Job No.", PurchaseJournalLine."Journal Batch Name", FORMAT(PurchaseJournalLine."Line No."));
                            END;
                        UNTIL DataCostByPiecework.NEXT = 0;
                    END;
                END;




            }
            DataItem("Job Planning Line"; "Job Planning Line")
            {

                DataItemTableView = SORTING("Job No.", "Job Task No.", "Line No.")
                                 ORDER(Ascending);


                RequestFilterFields = "Type", "No.";
                DataItemLink = "Job No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    IF Job."Management By Production Unit" THEN
                        CurrReport.BREAK;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Window.UPDATE(2, FORMAT("Job Planning Line"."No." + ' ' + "Job Planning Line".Description));

                    IF "Job Planning Line".Type = "Job Planning Line".Type::Resource THEN
                        Resource.GET("Job Planning Line"."No.");
                    IF "Job Planning Line".Type = "Job Planning Line".Type::Item THEN
                        Item.GET("Job Planning Line"."No.");

                    IF ("Job Planning Line".Type = "Job Planning Line".Type::Item) OR
                        (("Job Planning Line".Type = "Job Planning Line".Type::Resource) AND
                         (Resource.Type = Resource.Type::Subcontracting)) THEN BEGIN
                        PurchaseJournalLine.RESET;
                        PurchaseJournalLine.SETRANGE("Job No.", Job."No.");
                        PurchaseJournalLine.SETRANGE("Journal Batch Name", Section);
                        PurchaseJournalLine.SETRANGE("No.", "Job Planning Line"."No.");
                        IF "Job Planning Line".Type = "Job Planning Line".Type::Resource THEN
                            PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Resource);
                        IF "Job Planning Line".Type = "Job Planning Line".Type::Item THEN
                            PurchaseJournalLine.SETRANGE(Type, PurchaseJournalLine.Type::Item);
                        IF opcBreakDownByDate THEN
                            PurchaseJournalLine.SETRANGE("Date Needed", "Job Planning Line"."Planning Date")
                        ELSE
                            PurchaseJournalLine.SETRANGE("Date Needed");
                        IF PurchaseJournalLine.FINDFIRST THEN BEGIN
                            //ya existe la l¡nea en la fecha
                            //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                            //PurchaseJournalLine.VALIDATE(Quantity, PurchaseJournalLine.Quantity + "Job Planning Line"."Quantity (Base)");
                            PurchaseJournalLine.Quantity := PurchaseJournalLine.Quantity + "Job Planning Line"."Quantity (Base)";
                            PurchaseJournalLine.UpdateCost;
                            PurchaseJournalLine.MODIFY(TRUE);
                        END ELSE BEGIN
                            GetLineNo;
                            PurchaseJournalLine.INIT;
                            PurchaseJournalLine.VALIDATE("Line No.", LineNo);
                            PurchaseJournalLine.VALIDATE("Job No.", Job."No.");
                            PurchaseJournalLine.VALIDATE("Date Update", WORKDATE);
                            IF "Job Planning Line".Type = "Job Planning Line".Type::Item THEN BEGIN
                                Item.GET("Job Planning Line"."No.");
                                PurchaseJournalLine.Type := PurchaseJournalLine.Type::Item;
                                PurchaseJournalLine.VALIDATE("No.", "Job Planning Line"."No.");
                                PurchaseJournalLine.VALIDATE(Decription, Item.Description);
                            END;
                            IF "Job Planning Line".Type = "Job Planning Line".Type::Resource THEN BEGIN
                                Resource.GET("Job Planning Line"."No.");
                                PurchaseJournalLine.Type := PurchaseJournalLine.Type::Resource;
                                PurchaseJournalLine.VALIDATE("No.", "Job Planning Line"."No.");
                                PurchaseJournalLine.VALIDATE(Decription, Resource.Name);
                            END;
                            //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                            //PurchaseJournalLine.VALIDATE(Quantity,"Job Planning Line"."Quantity (Base)");
                            PurchaseJournalLine.Quantity := "Job Planning Line"."Quantity (Base)";

                            //vamos a llevarnos la Dimensiones del CA de la tabla DCU (DataCostByPiecework)
                            IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                                PurchaseJournalLine."Shortcut Dimension 1 Code" := "Job Planning Line"."Analytical concept"
                            ELSE
                                PurchaseJournalLine."Shortcut Dimension 2 Code" := "Job Planning Line"."Analytical concept";
                            QtyUnitOfMeasureBase := "Job Planning Line"."Qty. per Unit of Measure";
                            IF QtyUnitOfMeasureBase = 0 THEN
                                QtyUnitOfMeasureBase := 1;
                            PurchaseJournalLine.VALIDATE("Estimated Price", ("Job Planning Line"."Unit Cost (LCY)" / QtyUnitOfMeasureBase));
                            PurchaseJournalLine.VALIDATE("Target Price", ("Job Planning Line"."Unit Cost (LCY)" / QtyUnitOfMeasureBase));
                            IF opcBreakDownByDate THEN
                                PurchaseJournalLine."Date Needed" := "Job Planning Line"."Planning Date"
                            ELSE
                                PurchaseJournalLine."Date Needed" := PurchaseJournalLine."Date Update";

                            //JAV 10/06/21: - QB 1.08.48 El Validate de cantidad no sirve, recalculamos
                            PurchaseJournalLine.UpdateCost;
                            PurchaseJournalLine.INSERT(TRUE);
                        END
                    END;
                END;


            }

            trigger OnPreDataItem();
            BEGIN
                Window.OPEN(Text001);
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                Job.SETRANGE("No.", JobNo);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                DateFrom := Job."Reestimation Last Date";

                IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN  //JAV 26/09/22: - QB 1.11.03 En estudios no verificar presupuesto actual, es la propia versi¢n
                    IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") AND (Job."Current Piecework Budget" = '') THEN
                        ERROR('No ha fijado el presupuesto actual en el proyecto');

                Window.UPDATE(1, FORMAT(Job."No." + ' ' + Job.Description));
            END;

            trigger OnPostDataItem();
            BEGIN
                //JAV 09/08/19: - Eliminamos los que est n en un comparativo
                IF (opcReducir IN [opcReducir::"Cantidad en comparativos y en contratos", opcReducir::"Cantidad en contratos"]) THEN
                    DeleteInQuotes;

                //JAV 31/05/21: - QB 1.08.46 Si est  marcado reducimos cantidad con el stock actual
                IF (opcReducir = opcReducir::"Cantidad en Stock") THEN
                    DeleteStock;

                IF (opcSecciones) THEN
                    DeleteInSections;

                IF (opcEliminar) THEN
                    DeleteZeros;

                //JAV 10/06/21: - QB 1.08.48 Ajuste final de los decimales en cantidades
                AjustLine;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group547")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcBreakDownByPiecework"; "opcBreakDownByPiecework")
                    {

                        CaptionML = ENU = 'Breakdown by piecework', ESP = 'Desglosar por unidad de obra';
                        //OptionCaptionML=ENU='Breakdown by piecework',ESP='Desglosar por unidad de obra';
                    }
                    field("opcBreakDownByDate"; "opcBreakDownByDate")
                    {

                        CaptionML = ENU = 'Breakdown by date need', ESP = 'Desglosar por fecha necesidad';
                    }
                    field("opcReducir"; "opcReducir")
                    {

                        CaptionML = ESP = 'Reducir cantidades';
                    }
                    field("opcSecciones"; "opcSecciones")
                    {

                        CaptionML = ESP = 'Eliminar lo incluido en otras secciones';
                    }
                    field("opcEliminar"; "opcEliminar")
                    {

                        CaptionML = ESP = 'Borrar l¡neas a cero';
                    }
                    field("opcActividades"; "opcActividades")
                    {

                        CaptionML = ESP = 'false mezclar actividades';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Currency@7001103 :
        Currency: Record 4;
        //       PurchaseJournalLine@7001105 :
        PurchaseJournalLine: Record 7207281;
        //       DataPieceworkForProduction@7001108 :
        DataPieceworkForProduction: Record 7207386;
        //       DataCostByPiecework@7001109 :
        DataCostByPiecework: Record 7207387;
        //       Resource@7001119 :
        Resource: Record 156;
        //       Resource2@7001110 :
        Resource2: Record 156;
        //       ItemUnitofMeasure@7001113 :
        ItemUnitofMeasure: Record 5404;
        //       ResourceUnitofMeasure@7001115 :
        ResourceUnitofMeasure: Record 205;
        //       Item@7001117 :
        Item: Record 27;
        //       FunctionQB@7001120 :
        FunctionQB: Codeunit 7207272;
        //       BaseQuantity@7001114 :
        BaseQuantity: Decimal;
        //       QtyUnitOfMeasureBase@7001118 :
        QtyUnitOfMeasureBase: Decimal;
        //       LineNo@7001116 :
        LineNo: Integer;
        //       DateFrom@7001104 :
        DateFrom: Date;
        //       Window@7001100 :
        Window: Dialog;
        //       Text001@7001102 :
        Text001: TextConst ENU = 'Generating purchase needs \ Project #1############### \ Unit #2###############\Decomposed #3##########', ESP = 'Generando necesidades de compra\Proyecto     #1###############\Unidad obra  #2###############\Descompuesto #3###############';
        //       Text002@7001101 :
        Text002: TextConst ENU = 'It is mandatory to indicate a date', ESP = 'Es obligatorio indicar una fecha';
        //       r@7001121 :
        r: Record 7207281;
        //       ComparativeQuoteLines@1100286000 :
        ComparativeQuoteLines: Record 7207413;
        //       QBText@1100286004 :
        QBText: Record 7206918;
        //       JobNo@1100286005 :
        JobNo: Code[20];
        //       Section@1100286006 :
        Section: Code[20];
        //       opcBreakDownByPiecework@1100286008 :
        opcBreakDownByPiecework: Option "No","Items","Resources","Boths";
        //       opcBreakDownByDate@1100286007 :
        opcBreakDownByDate: Boolean;
        //       opcReducir@1100286003 :
        opcReducir: Option "Cantidad en comparativos y en contratos","Cantidad en contratos","Cantidad en Stock","No Reducir";
        //       opcEliminar@1100286002 :
        opcEliminar: Boolean;
        //       opcActividades@1100286001 :
        opcActividades: Boolean;
        //       opcSecciones@1100286009 :
        opcSecciones: Boolean;
        //       Aviso@1100286010 :
        Aviso: Boolean;



    trigger OnInitReport();
    begin
        opcBreakDownByPiecework := opcBreakDownByPiecework::Boths;
        opcActividades := TRUE;
        opcSecciones := TRUE;
    end;

    trigger OnPostReport();
    begin
        Window.CLOSE;
    end;



    procedure GetLineNo()
    var
        //       PurchaseJournalLine2@7001100 :
        PurchaseJournalLine2: Record 7207281;
    begin
        PurchaseJournalLine2.RESET;
        PurchaseJournalLine2.SETRANGE("Job No.", Job."No.");
        PurchaseJournalLine2.SETRANGE("Journal Batch Name", Section);
        if PurchaseJournalLine2.FINDLAST then
            LineNo := PurchaseJournalLine2."Line No." + 1
        else
            LineNo := 100000;
    end;

    //     procedure SetParameters (pJob@1100286000 : Code[20];pSection@1100286001 :
    procedure SetParameters(pJob: Code[20]; pSection: Code[20])
    begin
        JobNo := pJob;
        Section := pSection;
    end;

    LOCAL procedure DeleteStock()
    begin
        //JAV 31/05/21: - QB 1.08.46 Restamos las existencias actuales en el almac‚n de la l¡nea de necesidad
        PurchaseJournalLine.RESET;
        PurchaseJournalLine.SETRANGE("Job No.", Job."No.");
        PurchaseJournalLine.SETRANGE("Journal Batch Name", Section);
        if (PurchaseJournalLine.FINDSET(TRUE)) then
            repeat
                PurchaseJournalLine.VALIDATE("Stock Location (Base)");
                if (PurchaseJournalLine."Stock Location (Base)" <> 0) then begin
                    //JAV 10/06/21: - QB 1.08.48 El Validate no sirve porue pone a cero los negativos, y pueden haber resultados intermedios negativos
                    //PurchaseJournalLine.VALIDATE(Quantity, PurchaseJournalLine.Quantity - PurchaseJournalLine."Stock Location (Base)");
                    PurchaseJournalLine.Quantity := PurchaseJournalLine.Quantity - PurchaseJournalLine."Stock Location (Base)";
                    PurchaseJournalLine.UpdateCost;
                    PurchaseJournalLine.MODIFY(FALSE);
                end;
            until (PurchaseJournalLine.NEXT = 0);
    end;

    LOCAL procedure DeleteInQuotes()
    var
        //       ComparativeQuoteHeader@1100286002 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@1100286000 :
        ComparativeQuoteLines: Record 7207413;
        //       PurchaseJournalLine@1100286001 :
        PurchaseJournalLine: Record 7207281;
        //       CtComp@1100286003 :
        CtComp: Decimal;
        //       CtCont@1100286006 :
        CtCont: Decimal;
        //       Cantidad@1100286007 :
        Cantidad: Decimal;
        //       CantidadEliminada@1100286004 :
        CantidadEliminada: Decimal;
    begin
        //JAV 09/08/19: - Eliminamos las cantidades que est‚n en comparativos generados para el proyecto
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Job No.", JobNo);
        if (ComparativeQuoteLines.FINDSET(FALSE)) then
            repeat
                //JAV 30/10/19: - Se guarda la cantidad en comprativos y en contratos
                ComparativeQuoteHeader.GET(ComparativeQuoteLines."Quote No.");

                CtComp := ComparativeQuoteLines.Quantity;
                CtCont := 0;
                if (ComparativeQuoteHeader."Generated Contract Doc No." <> '') then
                    CtCont := ComparativeQuoteLines.Quantity;

                CASE opcReducir OF
                    opcReducir::"Cantidad en comparativos y en contratos":
                        Cantidad := CtComp;
                    opcReducir::"Cantidad en contratos":
                        Cantidad := CtCont;
                end;

                PurchaseJournalLine.RESET;
                PurchaseJournalLine.SETRANGE("Job No.", ComparativeQuoteLines."Job No.");
                PurchaseJournalLine.SETRANGE("Journal Batch Name", Section);
                PurchaseJournalLine.SETRANGE(Type, ComparativeQuoteLines.Type);
                PurchaseJournalLine.SETRANGE("No.", ComparativeQuoteLines."No.");
                //JMMA 14/10/19: - Se a¤ade un filtro que faltaba en el proceso de ajuste de cantidades y no se elimina la l¡nea sino que se deja a cero
                PurchaseJournalLine.SETRANGE("Job Unit", ComparativeQuoteLines."Piecework No.");
                if (PurchaseJournalLine.FINDSET(TRUE)) then
                    repeat
                        //JAV 30/10/19: - Se guarda la cantidad en comprativos y en contratos
                        PurchaseJournalLine."Quantity in Comparatives" += CtComp;
                        PurchaseJournalLine."Quantity in Contracts" += CtCont;
                        if (Cantidad > 0) then begin
                            if Cantidad >= PurchaseJournalLine.Quantity then begin
                                CantidadEliminada := PurchaseJournalLine.Quantity;
                                PurchaseJournalLine.Quantity := 0;            //JMMA 14/10/19: - No se elimina la l¡nea, se deja a cero
                            end else begin
                                CantidadEliminada := Cantidad;
                                PurchaseJournalLine.Quantity -= Cantidad;
                            end;
                            Cantidad -= CantidadEliminada;
                        end;
                        //JAV 10/06/21: - QB 1.08.48 Ajustamos cantidades muy peque¤as por los redondeos
                        if (PurchaseJournalLine.Quantity < 0.001) then
                            PurchaseJournalLine.Quantity := 0;

                        PurchaseJournalLine.MODIFY;
                    until (Cantidad <= 0) or (PurchaseJournalLine.NEXT = 0);
            until (ComparativeQuoteLines.NEXT = 0);
    end;

    LOCAL procedure DeleteInSections()
    var
        //       PurchaseJournalLine1@1100286006 :
        PurchaseJournalLine1: Record 7207281;
        //       PurchaseJournalLine2@1100286003 :
        PurchaseJournalLine2: Record 7207281;
        //       CtComp@1100286002 :
        CtComp: Decimal;
        //       CtCont@1100286001 :
        CtCont: Decimal;
        //       Cantidad@1100286000 :
        Cantidad: Decimal;
        //       CantidadEliminada@1100286004 :
        CantidadEliminada: Decimal;
    begin
        //JAV 09/08/19: - Eliminamos las cantidades que est‚n en otras secciones
        PurchaseJournalLine1.RESET;
        PurchaseJournalLine1.SETRANGE("Job No.", JobNo);
        PurchaseJournalLine1.SETRANGE("Journal Batch Name", Section);
        if (PurchaseJournalLine1.FINDSET(FALSE)) then
            repeat
                Cantidad := 0;
                PurchaseJournalLine2.RESET;
                PurchaseJournalLine2.SETRANGE("Job No.", PurchaseJournalLine1."Job No.");
                PurchaseJournalLine2.SETFILTER("Journal Batch Name", '<>%1', Section);
                PurchaseJournalLine2.SETRANGE(Type, PurchaseJournalLine1.Type);
                PurchaseJournalLine2.SETRANGE("No.", PurchaseJournalLine1."No.");
                PurchaseJournalLine2.SETRANGE("Job Unit", PurchaseJournalLine1."Job Unit");
                if (PurchaseJournalLine2.FINDSET(TRUE)) then begin
                    repeat
                        Cantidad += PurchaseJournalLine2.Quantity;
                    until (PurchaseJournalLine2.NEXT = 0);
                    if (Cantidad >= PurchaseJournalLine1.Quantity) then
                        PurchaseJournalLine1.Quantity := 0
                    else
                        PurchaseJournalLine1.Quantity -= Cantidad;
                    PurchaseJournalLine1.MODIFY;
                end;
            until (PurchaseJournalLine1.NEXT = 0);
    end;

    LOCAL procedure DeleteZeros()
    var
        //       PurchaseJournalLine1@1100286006 :
        PurchaseJournalLine1: Record 7207281;
        //       PurchaseJournalLine2@1100286003 :
        PurchaseJournalLine2: Record 7207281;
        //       CtComp@1100286002 :
        CtComp: Decimal;
        //       CtCont@1100286001 :
        CtCont: Decimal;
        //       Cantidad@1100286000 :
        Cantidad: Decimal;
    begin
        //JAV 30/10/19: - Nuevo par metro sobre eliminar o no las l¡neas a cero
        PurchaseJournalLine2.RESET;
        PurchaseJournalLine2.SETRANGE("Job No.", JobNo);
        PurchaseJournalLine2.SETRANGE("Journal Batch Name", Section);
        PurchaseJournalLine2.SETRANGE(Quantity, 0);
        PurchaseJournalLine2.DELETEALL(TRUE);
    end;

    LOCAL procedure AjustLine()
    begin
        //JAV 10/06/21: - QB 1.08.48 Ajustamos los decimales para que no se pase
        PurchaseJournalLine.RESET;
        PurchaseJournalLine.SETRANGE("Job No.", Job."No.");
        PurchaseJournalLine.SETRANGE("Journal Batch Name", Section);
        if (PurchaseJournalLine.FINDSET(TRUE)) then
            repeat
                PurchaseJournalLine.Quantity := ROUND(PurchaseJournalLine.Quantity, 0.0001);
                PurchaseJournalLine.UpdateCost;
                PurchaseJournalLine.MODIFY(FALSE);
            until (PurchaseJournalLine.NEXT = 0);
    end;

    /*begin
    //{
//      3685 Pasar Cod. U.O. Presto
//      PEL 07/05/19: - QCPM_GAP06 y JAV 09/08/19: - Se a¤ade el proveedor asociado al descompuesto en la l¡nea
//      JAV 17/06/19: - Se quita el filtro de tipo como filtro por defecto
//      JAV 30/10/19: - Para evitar un error si no tiene definido el recurso
//      PGM 30/10/19: - Q8092 A¤adida condicion para que en el caso que el descompuesto sea un producto, deje el proveedor que viene del descompuesto
//                      siempre que no venga vac¡o.
//      JAV 31/05/21: - QB 1.08.46 Reducir opcionalmente el stock actual de la l¡nea de necesidad
//      JAV 26/09/22: - QB 1.11.03 En estudios no verificar ni utilizar el presupuesto actual
//      AML 05/07/23: - Q19864 Informar la uo como la de unidad coste almac‚n cuando se desglosa por recurso.
//      AML 06/10/23: - Q20082
//    }
    end.
  */

}



// RequestFilterFields="Type","No.";
