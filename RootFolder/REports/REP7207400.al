report 7207400 "Copy Job Budget"
{


    CaptionML = ENU = 'Copy Job Budget', ESP = 'Copiar presupuesto obra';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");

            ;
            trigger OnPreDataItem();
            BEGIN
                Job.SETRANGE("No.", JobBudget."Job No.");

                IF BudgetOrigin = '' THEN
                    ERROR(Text001);

                IF NOT JobBudget.FIND('=') THEN //Leo el registro del presupuesto por si no existe
                    ERROR(Text002);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                w.OPEN('#1###################################');

                //JAV 11/10/19: - Se marca como presupuesto no reestimado y se informa del origen
                JobBudget.Reestimation := FALSE;
                JobBudget.Origin := BudgetOrigin;
                JobBudget.MODIFY;

                //Procesar los descompuestos
                DataCostByPiecework.SETRANGE("Job No.", JobBudget."Job No.");
                DataCostByPiecework.SETRANGE("Cod. Budget", JobBudget."Cod. Budget");
                IF DataCostByPiecework.FINDSET THEN BEGIN
                    w.UPDATE(1, 'Copiando Descompuestos: Preparar ' + FORMAT(DataCostByPiecework.COUNT));
                    DataCostByPiecework.DELETEALL(TRUE);
                END;

                DataCostByPiecework.SETRANGE("Job No.", JobBudget."Job No.");
                DataCostByPiecework.SETRANGE("Cod. Budget", BudgetOrigin);
                IF DataCostByPiecework.FINDSET THEN
                    REPEAT
                        w.UPDATE(1, 'Copiando Descompuestos: ' + DataCostByPiecework."Piecework Code");
                        CLEAR(DataCostByPieceworkInsert);
                        DataCostByPieceworkInsert := DataCostByPiecework;
                        DataCostByPieceworkInsert."Cod. Budget" := JobBudget."Cod. Budget";
                        IF DataCostByPieceworkInsert.INSERT THEN;
                    UNTIL DataCostByPiecework.NEXT = 0;

                //JAV 09/10/19: - Se copian las l¡neas de mediciones
                MeasurementLinPiecewProd.SETRANGE("Job No.", JobBudget."Job No.");
                MeasurementLinPiecewProd.SETRANGE("Code Budget", JobBudget."Cod. Budget");
                IF MeasurementLinPiecewProd.FINDSET THEN BEGIN
                    w.UPDATE(1, 'Copiando Lineas Medici¢n: Preparar ' + FORMAT(MeasurementLinPiecewProd.COUNT));
                    MeasurementLinPiecewProd.DELETEALL(TRUE);
                END;

                MeasurementLinPiecewProd.SETRANGE("Job No.", JobBudget."Job No.");
                MeasurementLinPiecewProd.SETRANGE("Code Budget", BudgetOrigin);
                IF MeasurementLinPiecewProd.FINDSET THEN
                    REPEAT
                        w.UPDATE(1, 'Copiando Lineas Medici¢n: ' + MeasurementLinPiecewProd."Piecework Code");
                        CLEAR(MeasurementLinPiecewProdInsert);
                        MeasurementLinPiecewProdInsert := MeasurementLinPiecewProd;
                        MeasurementLinPiecewProdInsert."Code Budget" := JobBudget."Cod. Budget";
                        IF MeasurementLinPiecewProdInsert.INSERT THEN;
                    UNTIL MeasurementLinPiecewProd.NEXT = 0;


                //Procesar cantidades e importes
                ExpectedTimeUnitData.SETCURRENTKEY(ExpectedTimeUnitData."Job No.");
                ExpectedTimeUnitData.SETRANGE("Job No.", JobBudget."Job No.");
                ExpectedTimeUnitData.SETRANGE("Budget Code", JobBudget."Cod. Budget");
                IF ExpectedTimeUnitData.FINDSET THEN BEGIN
                    w.UPDATE(1, 'Copiando Cantidades: Preparar ' + FORMAT(ExpectedTimeUnitData.COUNT));
                    ExpectedTimeUnitData.DELETEALL(TRUE);
                END;

                ExpectedTimeUnitData.RESET;
                IF ExpectedTimeUnitData.FINDLAST THEN
                    LastEntry := ExpectedTimeUnitData."Entry No."
                ELSE
                    LastEntry := 0;

                ExpectedTimeUnitData.SETCURRENTKEY(ExpectedTimeUnitData."Job No.");
                ExpectedTimeUnitData.SETRANGE("Job No.", JobBudget."Job No.");
                ExpectedTimeUnitData.SETRANGE("Budget Code", BudgetOrigin);
                IF ExpectedTimeUnitData.FINDSET THEN
                    REPEAT
                        w.UPDATE(1, 'Copiando Cantidades: ' + ExpectedTimeUnitData."Piecework Code");
                        CLEAR(ExpectedTimeUnitDataInsert);
                        ExpectedTimeUnitDataInsert := ExpectedTimeUnitData;
                        LastEntry := LastEntry + 1;
                        ExpectedTimeUnitDataInsert."Entry No." := LastEntry;
                        ExpectedTimeUnitDataInsert."Budget Code" := JobBudget."Cod. Budget";
                        IF ExpectedTimeUnitDataInsert.INSERT THEN;
                    UNTIL ExpectedTimeUnitData.NEXT = 0;

                ForecastDataAmountPiecework.SETCURRENTKEY(ForecastDataAmountPiecework."Job No.");
                ForecastDataAmountPiecework.SETRANGE("Job No.", JobBudget."Job No.");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", JobBudget."Cod. Budget");
                //JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
                ForecastDataAmountPiecework.SETFILTER("Unit Type", '%1|%2', ForecastDataAmountPiecework."Entry Type"::Expenses, ForecastDataAmountPiecework."Entry Type"::Incomes);
                IF ForecastDataAmountPiecework.FINDSET THEN BEGIN
                    w.UPDATE(1, 'Copiando Importes: Preparar ' + FORMAT(ForecastDataAmountPiecework.COUNT));
                    ForecastDataAmountPiecework.DELETEALL;
                END;

                ForecastDataAmountPiecework.RESET;
                IF ForecastDataAmountPiecework.FINDLAST THEN
                    LastEntry := ForecastDataAmountPiecework."Entry No."
                ELSE
                    LastEntry := 0;

                ForecastDataAmountPiecework.SETCURRENTKEY(ForecastDataAmountPiecework."Job No.");
                ForecastDataAmountPiecework.SETRANGE("Job No.", JobBudget."Job No.");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", BudgetOrigin);
                //JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
                ForecastDataAmountPiecework.SETFILTER("Unit Type", '%1|%2', ForecastDataAmountPiecework."Entry Type"::Expenses, ForecastDataAmountPiecework."Entry Type"::Incomes);
                IF ForecastDataAmountPiecework.FINDSET THEN
                    REPEAT
                        w.UPDATE(1, 'Copiando Importes: ' + ForecastDataAmountPiecework."Piecework Code");
                        CLEAR(ForecastDataAmountPieceworkInsert);
                        ForecastDataAmountPieceworkInsert := ForecastDataAmountPiecework;
                        LastEntry := LastEntry + 1;
                        ForecastDataAmountPieceworkInsert."Entry No." := LastEntry;
                        ForecastDataAmountPieceworkInsert."Cod. Budget" := JobBudget."Cod. Budget";
                        IF ForecastDataAmountPieceworkInsert.INSERT THEN;
                    UNTIL ForecastDataAmountPiecework.NEXT = 0;
                //AML Suscriptor
                OnCopyBudget(Job, JobBudget."Cod. Budget", BudgetOrigin);
                //AML

                w.CLOSE;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group736")
                {

                    CaptionML = ENU = 'Option', ESP = 'Opciones';
                    field("BudgetOrigin"; "BudgetOrigin")
                    {

                        AssistEdit = false;
                        CaptionML = ENU = 'Origin Budget Code', ESP = 'Cod. presupuesto origen';

                        ; trigger OnLookup(var Text: Text): Boolean
                        VAR
                            //                              locJobBudget@7001101 :
                            locJobBudget: Record 7207407;
                            //                              locJobBudgetList@7001100 :
                            locJobBudgetList: Page 7206909;
                        BEGIN
                            CLEAR(locJobBudgetList);
                            locJobBudget.SETRANGE("Job No.", JobBudget."Job No.");
                            locJobBudget.SETFILTER("Cod. Budget", '<>%1', JobBudget."Cod. Budget");
                            locJobBudgetList.SETTABLEVIEW(locJobBudget);
                            locJobBudgetList.LOOKUPMODE(TRUE);
                            IF BudgetOrigin <> '' THEN BEGIN
                                IF locJobBudget.GET(JobBudget."Job No.", BudgetOrigin) THEN
                                    locJobBudgetList.SETRECORD(locJobBudget);
                            END;
                            IF locJobBudgetList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                locJobBudgetList.GETRECORD(locJobBudget);
                                BudgetOrigin := locJobBudget."Cod. Budget";
                            END;
                        END;


                    }
                    //verify similar scenarios
                    //To be validated
                    // field("Field 2"; " ")
                    // {

                    //     CaptionClass = Text19010225;
                    //     MultiLine = true;
                    // }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       JobBudget@7001100 :
        JobBudget: Record 7207407;
        //       Text001@7001102 :
        Text001: TextConst ENU = 'You must specify Origin budget', ESP = 'Debe especificar presupuesto de Origen';
        //       DataCostByPiecework@7001103 :
        DataCostByPiecework: Record 7207387;
        //       DataCostByPieceworkInsert@7001104 :
        DataCostByPieceworkInsert: Record 7207387;
        //       ExpectedTimeUnitData@7001105 :
        ExpectedTimeUnitData: Record 7207388;
        //       ExpectedTimeUnitDataInsert@7001107 :
        ExpectedTimeUnitDataInsert: Record 7207388;
        //       ForecastDataAmountPiecework@7001108 :
        ForecastDataAmountPiecework: Record 7207392;
        //       ForecastDataAmountPieceworkInsert@7001109 :
        ForecastDataAmountPieceworkInsert: Record 7207392;
        //       Text002@7001111 :
        Text002: TextConst ENU = 'The budget of seceded origin does not exist', ESP = 'El presupuesto de origen sececionado no existe';
        //       Text19010225@7001112 :
        Text19010225: TextConst ENU = 'The data that exists from the target version will be erased', ESP = 'Se borraran los datos que exitan de la versi¢n destino';
        //       MeasurementLinPiecewProd@1100286002 :
        MeasurementLinPiecewProd: Record 7207390;
        //       MeasurementLinPiecewProdInsert@1100286003 :
        MeasurementLinPiecewProdInsert: Record 7207390;
        //       w@1100286005 :
        w: Dialog;
        //       BudgetOrigin@1100286004 :
        BudgetOrigin: Code[20];
        //       LastEntry@1100286001 :
        LastEntry: Integer;
        //       CBudgetOrigin@1100286000 :
        CBudgetOrigin: Code[20];

    //     procedure PassParameters (PJobBudget@1100000 :
    procedure PassParameters(PJobBudget: Record 7207407)
    begin
        JobBudget := PJobBudget;
    end;

    //     procedure PassParameters2 (PBudgetDestination@1100000 : Record 7207407;PBudgetOrigin@1100286000 :
    procedure PassParameters2(PBudgetDestination: Record 7207407; PBudgetOrigin: Code[20])
    begin
        JobBudget := PBudgetDestination;
        BudgetOrigin := PBudgetOrigin;
    end;


    //     LOCAL procedure OnCopyBudget (Job@1100286000 : Record 167;BudgetCode@1100286001 : Code[20];OldBudgetCode@1100286002 :
    LOCAL procedure OnCopyBudget(Job: Record 167; BudgetCode: Code[20]; OldBudgetCode: Code[20])
    begin
    end;

    /*begin
    //{
//      JAV 09/10/19: - Se copian las l¡neas de mediciones
//      JAV 11/10/19: - Se marca como presupuesto no reestimado y se informa del origen
//      JAV 20/10/21: - QB 1.09.22 Considerar £nicamente ingresos y gastos, no certificaciones
//    }
    end.
  */

}



