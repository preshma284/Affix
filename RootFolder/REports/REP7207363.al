report 7207363 "Copy Job Budget to Cost DB"
{


    CaptionML = ENU = 'Copu Job Budget to Cost DataBase', ESP = 'Copiar presupuesto a un Preciario';
    ProcessingOnly = true;

    dataset
    {

    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group639")
                {

                    CaptionML = ENU = 'Option', ESP = 'Opciones';
                    group("group640")
                    {

                        CaptionML = ESP = 'Destino';

                    }
                    group("group643")
                    {

                        CaptionML = ESP = 'Origen';
                        field("oJob"; "oJob")
                        {

                            CaptionML = ESP = 'Proyecto';
                            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"));
                        }
                        field("desdeUO"; "desdeUO")
                        {

                            CaptionML = ESP = 'Desde U.O.';
                            ToolTipML = ESP = 'Si la deja en blanco ser  desde la primera';
                            TableRelation = "Data Piecework For Production"."Piecework Code";

                            ; trigger OnLookup(var Text: Text): Boolean
                            BEGIN
                                DataPieceworkForProduction.RESET;
                                DataPieceworkForProduction.SETRANGE("Job No.", oJob);
                                CLEAR(DataPieceworkList);
                                DataPieceworkList.SETTABLEVIEW(DataPieceworkForProduction);
                                DataPieceworkList.LOOKUPMODE(TRUE);
                                IF (DataPieceworkList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                                    DataPieceworkList.GETRECORD(DataPieceworkForProduction);
                                    desdeUO := DataPieceworkForProduction."Piecework Code";
                                END;
                            END;


                        }
                        field("hastaUO"; "hastaUO")
                        {

                            CaptionML = ESP = 'Hasta U.O.';
                            ToolTipML = ESP = 'Si la deja en blanco ser  hasta la £ltima';
                            TableRelation = "Data Piecework For Production"."Piecework Code";

                            ; trigger OnLookup(var Text: Text): Boolean
                            BEGIN
                                DataPieceworkForProduction.RESET;
                                DataPieceworkForProduction.SETRANGE("Job No.", oJob);
                                IF (desdeUO <> '') THEN
                                    DataPieceworkForProduction.SETFILTER("Piecework Code", '%1..', desdeUO);
                                CLEAR(DataPieceworkList);
                                DataPieceworkList.SETTABLEVIEW(DataPieceworkForProduction);
                                DataPieceworkList.LOOKUPMODE(TRUE);
                                IF (DataPieceworkList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                                    DataPieceworkList.GETRECORD(DataPieceworkForProduction);
                                    hastaUO := DataPieceworkForProduction."Piecework Code";
                                END;
                            END;


                        }

                    }
                    group("group647")
                    {

                        CaptionML = ESP = 'Opciones';
                        field("CodePrefix"; "CodePrefix")
                        {

                            CaptionML = ENU = 'Prefix for unit of work', ESP = 'Prefijo para unidad de obra';
                        }

                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       CostDatabase@1100286002 :
        CostDatabase: Record 7207271;
        //       Piecework@1100286003 :
        Piecework: Record 7207277;
        //       BillofItemData@1100286004 :
        BillofItemData: Record 7207384;
        //       MeasureLinePieceworkPRESTO@1100286005 :
        MeasureLinePieceworkPRESTO: Record 7207285;
        //       PriceCostDatabasePRESTO@1100286008 :
        PriceCostDatabasePRESTO: Record 7207284;
        //       CommentLine2@1100286007 :
        CommentLine2: Record 97;
        //       DefaultDimension2@1100286010 :
        DefaultDimension2: Record 352;
        //       "-----------------------------------"@1100286006 :
        "-----------------------------------": Integer;
        //       Job@7001121 :
        Job: Record 167;
        //       DataPieceworkForProduction@7001134 :
        DataPieceworkForProduction: Record 7207386;
        //       QBText@7001119 :
        QBText: Record 7206918;
        //       DefaultDimension@7001116 :
        DefaultDimension: Record 352;
        //       CommentLine@7001120 :
        CommentLine: Record 97;
        //       DataCostByPiecework@7001114 :
        DataCostByPiecework: Record 7207387;
        //       DataCostByPieceworkCert@1100286009 :
        DataCostByPieceworkCert: Record 7207340;
        //       ExpectedTimeUnitData@7001132 :
        ExpectedTimeUnitData: Record 7207388;
        //       MeasurementLinPiecewProd@7001107 :
        MeasurementLinPiecewProd: Record 7207390;
        //       DataPieceworkList@7001122 :
        DataPieceworkList: Page 7207528;
        //       Window@7001101 :
        Window: Dialog;
        //       Text001@7001108 :
        Text001: TextConst ENU = 'You must select a job.', ESP = 'Debe de seleccionar un proyecto.';
        //       Text002@7001109 :
        Text002: TextConst ENU = 'You can only select a job.', ESP = 'Debe selecciona un preciario existente, o dejarlo en balcno para crear uno nuevo';
        //       NewPiecework@7001112 :
        NewPiecework: Code[20];
        //       Registro@7001133 :
        Registro: Integer;
        //       "--------------------------------- Opciones"@7001128 :
        "--------------------------------- Opciones": Integer;
        //       dPreciario@7001124 :
        dPreciario: Code[20];
        //       oJob@7001126 :
        oJob: Code[20];
        //       desdeUO@1100286001 :
        desdeUO: Code[20];
        //       hastaUO@1100286000 :
        hastaUO: Code[20];
        //       DeletePreciario@7001103 :
        DeletePreciario: Boolean;
        //       CodePrefix@7001100 :
        CodePrefix: Code[2];
        //       Text004@7001104 :
        Text004: TextConst ENU = 'Will the entire job budget be erased, are you sure?', ESP = 'Se borrarr n los datos del preciario actual, ¨Esta seguro?';
        //       Text005@7001102 :
        Text005: TextConst ENU = 'Erasing', ESP = 'Borrando';
        //       Text006@7001110 :
        Text006: TextConst ENU = 'Loading Cost Database\Piecework #1####################\Bill of Item   #2####################', ESP = 'Cargando\Unidad de obra #1####################\Descompuesto   #2####################';



    trigger OnPreReport();
    begin
        if not Job.GET(oJob) then
            ERROR(Text001);

        if (dPreciario <> '') then begin
            if not CostDatabase.GET(dPreciario) then
                ERROR(Text002);
            if DeletePreciario then
                BorrarDatos;
        end;

        if CostDatabase.GET(dPreciario) then begin
            CostDatabase.Description := 'Copiado del proyecto ' + Job."No.";
            CostDatabase.MODIFY;
        end else begin
            CostDatabase.INIT;
            CostDatabase.Description := 'Copiado del proyecto ' + Job."No.";
            CostDatabase.INSERT(TRUE);
            dPreciario := CostDatabase.Code;
        end;

        Window.OPEN(Text006);
        CargarDatos;
        Window.CLOSE;
    end;



    LOCAL procedure BorrarDatos()
    begin
        if not CONFIRM(Text004, FALSE) then
            ERROR('Proceso cancelado');

        Window.OPEN(Text005);

        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", dPreciario);
        Piecework.DELETEALL(TRUE);

        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", dPreciario);
        BillofItemData.DELETEALL(TRUE);

        Window.CLOSE;
    end;

    LOCAL procedure CargarDatos()
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", oJob);
        DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Current Piecework Budget");
        if (desdeUO <> '') and (hastaUO <> '') then
            DataPieceworkForProduction.SETFILTER("Piecework Code", '%1..%2', desdeUO, hastaUO)
        else if (desdeUO <> '') then
            DataPieceworkForProduction.SETFILTER("Piecework Code", '%1..', desdeUO)
        else if (hastaUO <> '') then
            DataPieceworkForProduction.SETFILTER("Piecework Code", '..%1', hastaUO);

        if (DataPieceworkForProduction.FINDSET(FALSE)) then
            repeat
                Window.UPDATE(1, FORMAT(DataPieceworkForProduction."Piecework Code" + ' ' + DataPieceworkForProduction.Description));

                //Cargar las unidades de obra
                DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget", "Measure Budg. Piecework Sol", "Amount Cost Budget (LCY)");
                NewPiecework := CodePrefix + DataPieceworkForProduction."Piecework Code";

                Piecework."Cost Database Default" := dPreciario;
                Piecework."No." := NewPiecework;

                Piecework.Description := DataPieceworkForProduction.Description;
                Piecework.Alias := UPPERCASE(DataPieceworkForProduction.Description);
                Piecework."Description 2" := DataPieceworkForProduction."Description 2";
                Piecework."Unit Type" := DataPieceworkForProduction.Type;
                Piecework."Global Dimension 1 Code" := DataPieceworkForProduction."Global Dimension 1 Code";
                Piecework."Global Dimension 2 Code" := DataPieceworkForProduction."Global Dimension 2 Code";
                Piecework.Blocked := DataPieceworkForProduction.Blocked;
                Piecework."Date Last Modified" := TODAY;
                //verify
                //To be validated
                //Piecework."Base Price Sales" := DataPieceworkForProduction."Code Cost Database";
                Piecework."Units of Measure" := DataPieceworkForProduction."Unit Of Measure";
                Piecework."Price Cost" := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                Piecework."Proposed Sale Price" := DataPieceworkForProduction."Contract Price";
                Piecework."% Margin" := DataPieceworkForProduction."% Of Margin";
                Piecework."Gross Profit Percentage" := 0;
                Piecework."Type Cost Unit" := DataPieceworkForProduction."Type Unit Cost";
                Piecework."Periodic Cost" := DataPieceworkForProduction."Periodic Cost";
                Piecework."Posting Group Unit Cost" := DataPieceworkForProduction."Posting Group Unit Cost";
                Piecework."Jobs Structured Billing" := DataPieceworkForProduction."Job Billing Structure";
                Piecework."Allocation Terms" := DataPieceworkForProduction."Allocation Terms";
                Piecework."Automatic Additional Text" := DataPieceworkForProduction."Additional Auto Text";
                Piecework."PRESTO Code Cost" := DataPieceworkForProduction."Code Piecework PRESTO";
                Piecework."PRESTO Code Sales" := '';
                Piecework."Measurement Cost" := DataPieceworkForProduction."Measure Budg. Piecework Sol";
                Piecework."Resource Subcontracting Code" := DataPieceworkForProduction."No. Subcontracting Resource";
                Piecework."Concept Analitycal Subcon Code" := DataPieceworkForProduction."Analytical Concept Subcon Code";
                Piecework."Account Type" := DataPieceworkForProduction."Account Type";
                Piecework.Identation := DataPieceworkForProduction.Indentation;
                Piecework.Totaling := DataPieceworkForProduction.Totaling;
                Piecework."Unique Code" := DataPieceworkForProduction."Unique Code";
                Piecework."Production Unit" := FALSE;
                //verify

                //Piecework.OLD_Order := 0;
                Piecework."Cod. Activity" := DataPieceworkForProduction."Activity Code";
                Piecework."Subtype Cost" := DataPieceworkForProduction."Subtype Cost";
                Piecework."Certification Unit" := DataPieceworkForProduction."Customer Certification Unit";
                Piecework."Piecework Filter" := '';
                Piecework."Total Amount Cost" := DataPieceworkForProduction."Amount Cost Budget (LCY)";
                Piecework."Total Amount Sales" := DataPieceworkForProduction."Sales Amount (Base)";
                Piecework."Measurement Sale" := DataPieceworkForProduction."Sale Quantity (base)";
                Piecework.Title := DataPieceworkForProduction.Title;
                if Piecework.INSERT(TRUE) then;

                //Copiar los descompuestos de coste
                DataCostByPiecework.RESET;
                DataCostByPiecework.SETRANGE("Job No.", oJob);
                DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                if (DataCostByPiecework.FINDSET) then
                    repeat
                        BillofItemData.INIT;
                        BillofItemData."Cod. Cost database" := dPreciario;
                        BillofItemData."Cod. Piecework" := NewPiecework;
                        BillofItemData.Use := BillofItemData.Use::Cost;

                        BillofItemData.Type := DataCostByPiecework."Cost Type";
                        BillofItemData."No." := DataCostByPiecework."No.";
                        BillofItemData."Concep. Analytical Direct Cost" := DataCostByPiecework."Analytical Concept Direct Cost";
                        BillofItemData."Quantity By" := DataCostByPiecework."Performance By Piecework";
                        BillofItemData."Units of Measure" := DataCostByPiecework."Cod. Measure Unit";
                        BillofItemData."Direct Unit Cost" := DataCostByPiecework."Direc Unit Cost";
                        BillofItemData."Piecework Cost" := DataCostByPiecework."Budget Cost";
                        BillofItemData.Position := 0;
                        BillofItemData."Bill of Item Units" := DataCostByPiecework."Performance By Piecework";
                        BillofItemData."Concep. Anal. Indirect Cost" := DataCostByPiecework."Analytical Concept Ind. Cost";
                        BillofItemData."Unit Cost Indirect" := DataCostByPiecework."Indirect Unit Cost";
                        BillofItemData.Description := DataCostByPiecework.Description;
                        BillofItemData."Description 2" := '';
                        if BillofItemData.INSERT then;
                    until (DataCostByPiecework.NEXT = 0);

                //Copiar los descompuestos de venta
                DataCostByPieceworkCert.RESET;
                DataCostByPieceworkCert.SETRANGE("Job No.", oJob);
                DataCostByPieceworkCert.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                if (DataCostByPieceworkCert.FINDSET) then
                    repeat
                        BillofItemData.INIT;
                        BillofItemData."Cod. Cost database" := dPreciario;
                        BillofItemData."Cod. Piecework" := NewPiecework;
                        BillofItemData.Use := BillofItemData.Use::Sales;

                        BillofItemData.Type := DataCostByPieceworkCert."Line Type";
                        BillofItemData."No." := DataCostByPieceworkCert."No.";
                        BillofItemData."Concep. Analytical Direct Cost" := '';
                        BillofItemData."Quantity By" := DataCostByPieceworkCert."Performance By Piecework";
                        BillofItemData."Units of Measure" := DataCostByPieceworkCert."Cod. Measure Unit";
                        BillofItemData."Direct Unit Cost" := DataCostByPieceworkCert."Sale Price";
                        BillofItemData."Piecework Cost" := DataCostByPieceworkCert."Sale Amount (LCY)";
                        BillofItemData.Position := 0;
                        BillofItemData."Bill of Item Units" := DataCostByPieceworkCert."Performance By Piecework";
                        BillofItemData."Concep. Anal. Indirect Cost" := '';
                        BillofItemData."Unit Cost Indirect" := 0;
                        BillofItemData.Description := DataCostByPieceworkCert.Description;
                        BillofItemData."Description 2" := '';
                        if BillofItemData.INSERT then;
                    until (DataCostByPieceworkCert.NEXT = 0);

                //Copio los comentarios asociados si existen
                CommentLine.RESET;
                CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"Job Cost Piecework");
                CommentLine.SETRANGE("No.", DataPieceworkForProduction."Job No.");
                if CommentLine.FINDSET(TRUE, TRUE) then begin
                    repeat
                        CommentLine2.INIT;
                        CommentLine2.TRANSFERFIELDS(CommentLine);
                        CommentLine2."Table Name" := CommentLine2."Table Name"::Piecework;
                        CommentLine2."No." := DataPieceworkForProduction."Job No.";
                        CommentLine2.INSERT(TRUE);
                    until CommentLine.NEXT = 0;
                end;

                //Copio los textos adicionales si existen
                QBText.CopyTo(QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code", '',
                              QBText.Table::Preciario, Piecework."Cost Database Default", Piecework."No.", '');

                //Copio las dimensiones si existen
                DefaultDimension.RESET;
                DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
                DefaultDimension.SETRANGE("No.", DataPieceworkForProduction."Job No.");
                if DefaultDimension.FINDSET(TRUE, TRUE) then begin
                    repeat
                        DefaultDimension2.INIT;
                        DefaultDimension2.TRANSFERFIELDS(DefaultDimension);
                        DefaultDimension2."Table ID" := DATABASE::Piecework;
                        DefaultDimension2."No." := DataPieceworkForProduction."Job No.";
                        DefaultDimension2.INSERT(TRUE);
                    until DefaultDimension.NEXT = 0;
                end;

                //Mediciones
                MeasurementLinPiecewProd.SETRANGE("Job No.", oJob); //JAV estaba mal
                MeasurementLinPiecewProd.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                if MeasurementLinPiecewProd.FINDSET(FALSE, FALSE) then
                    repeat
                        MeasureLinePieceworkPRESTO."Cost Database Code" := dPreciario;
                        MeasureLinePieceworkPRESTO.Use := MeasureLinePieceworkPRESTO.Use::Cost;
                        MeasureLinePieceworkPRESTO."Cod. Jobs Unit" := NewPiecework;
                        MeasureLinePieceworkPRESTO."Line No." := MeasurementLinPiecewProd."Line No.";

                        MeasureLinePieceworkPRESTO.Description := MeasurementLinPiecewProd.Description;
                        MeasureLinePieceworkPRESTO.Units := MeasurementLinPiecewProd.Units;
                        MeasureLinePieceworkPRESTO.Length := MeasurementLinPiecewProd.Length;
                        MeasureLinePieceworkPRESTO.Width := MeasurementLinPiecewProd.Width;
                        MeasureLinePieceworkPRESTO.Height := MeasurementLinPiecewProd.Height;
                        MeasureLinePieceworkPRESTO.Total := MeasurementLinPiecewProd.Total;

                        if MeasureLinePieceworkPRESTO.INSERT(TRUE) then;
                    until MeasurementLinPiecewProd.NEXT = 0;

            until DataPieceworkForProduction.NEXT = 0;
    end;

    //     procedure SetDatos (pPreciario@1100286000 : Code[20];pProyecto@1100286001 :
    procedure SetDatos(pPreciario: Code[20]; pProyecto: Code[20])
    begin
        dPreciario := pPreciario;
        oJob := pProyecto;
    end;

    /*begin
    //{
//      JAV 04/07/19: - Se guarda una estuctura de obra en un preciario
//      JAV 12/04/22: - QB 1.10.35 Se cambia el caption del campo "Fecha £ltima modificaci¢n" para homogeneizar y mejorar la sincronizaci¢n
//    }
    end.
  */

}



