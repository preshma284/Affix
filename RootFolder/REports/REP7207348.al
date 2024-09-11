report 7207348 "Propose Costsheet"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Propose Costsheet', ESP = 'Proponer partes costes';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Cost Unit"), "Type Unit Cost" = CONST("External"), "Account Type" = CONST("Unit"), "Allocation Terms" = FILTER(<> 'Fixed Amount'));
                DataItemLink = "Job No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    NoLine := 0;
                    Total := "Data Piecework For Production".COUNT;
                    DateStartYear := DMY2DATE(1, 1, DATE2DMY(DatePosting, 3));
                    DateBefore := DMY2DATE(1, DATE2DMY(DatePosting, 2), DATE2DMY(DatePosting, 3)) - 1;
                    AccumulatedAllocation := 0;
                    JobJV.SETCURRENTKEY(JobJV."Rate Repercussion Job Code", JobJV."Rate Repercussion Cost Unit");

                    //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes
                    NumberRegister := 0;
                    TotalRegister := COUNT;
                END;

                trigger OnAfterGetRecord();
                VAR
                    //                                   LProductionProcessed@7001100 :
                    LProductionProcessed: Decimal;
                    //                                   LDataPieceworkForProduction@7001101 :
                    LDataPieceworkForProduction: Record 7207386;
                BEGIN
                    //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes
                    NumberRegister += 1;
                    Window.UPDATE(2, ROUND((NumberRegister / TotalRegister) * 10000, 1));


                    // Si hay un proyecto UTE que alimenta esta unidad de obra me la voy a saltar
                    JobJV.SETRANGE("Rate Repercussion Job Code", "Data Piecework For Production"."Job No.");
                    JobJV.SETRANGE("Rate Repercussion Cost Unit", "Data Piecework For Production"."Piecework Code");
                    IF JobJV.FINDFIRST THEN
                        IF JobJV."No." <> "Data Piecework For Production"."Job No." THEN
                            CurrReport.SKIP;

                    IF Job."Rate Repercussion Job Code" = '' THEN BEGIN
                        //Read := Read + 1;
                        //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes y se da un mensaje al finalizar
                        //Window.UPDATE(1,ROUND(Read / Total * 10000,1));
                        //Window.UPDATE(2,Read);
                        //Window.UPDATE(3,Total);
                        NroLin += 1;
                        NoLine := NoLine + 10000;

                        CostsheetLines2.INIT;
                        CostsheetLines2.VALIDATE("Document No.", CostsheetHeader."No.");
                        CostsheetLines2.VALIDATE("Line No.", NoLine);
                        CostsheetLines2.INSERT(TRUE);
                        CalcLine(CostsheetLines2, "Data Piecework For Production", DatePosting);

                    END ELSE BEGIN
                        //Si hay que repercutirselo a otro proyecto lo que hago es que acumulo el terorico y luego al final inserto la linea por diferencia
                        //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes
                        //Read:=Read+1;
                        //Window.UPDATE(1,ROUND(Read/Total*10000,1));
                        //Window.UPDATE(2,Read);
                        //Window.UPDATE(3,Total);

                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.GET(Job."No.", "Piecework Code");

                        SETFILTER("Data Piecework For Production"."Budget Filter", Job.GETFILTER("Budget Filter"));

                        CASE "Data Piecework For Production"."Allocation Terms" OF
                            "Data Piecework For Production"."Allocation Terms"::"Fixed Amount":
                                BEGIN
                                    AccumulatedAllocation := AccumulatedAllocation + 0;
                                END;
                            "Data Piecework For Production"."Allocation Terms"::"% on Production":
                                BEGIN

                                    //jmma error en migraci¢n campo equivocado        "Data Piecework For Production".VALIDATE("% Cost Asign.Sale");
                                    "Data Piecework For Production".VALIDATE("% Expense Cost");
                                    "Data Piecework For Production".SETFILTER("Filter Date", '%1..%2', DateStartYear, DatePosting);

                                    "Data Piecework For Production".CALCFIELDS("Amount Cost Performed (LCY)");

                                    LProductionProcessed := 0;
                                    LDataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
                                    LDataPieceworkForProduction.SETRANGE("Filter Date", DateStartYear, DatePosting);
                                    LDataPieceworkForProduction.SETRANGE("Account Type", LDataPieceworkForProduction."Account Type"::Unit);
                                    LDataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
                                    IF LDataPieceworkForProduction.FINDSET THEN
                                        REPEAT
                                            LDataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                                            LProductionProcessed := LProductionProcessed +
                                                      ROUND(LDataPieceworkForProduction."Amount Production Performed" * LDataPieceworkForProduction."% Processed Production" / 100, 0.01);
                                        UNTIL LDataPieceworkForProduction.NEXT = 0;

                                    AccumulatedAllocation := AccumulatedAllocation +
                                        ROUND(LProductionProcessed * "Data Piecework For Production"."% Expense Cost" / 100, 0.01);
                                    //jmma error en migraci¢n campo equivocado              ROUND(LProductionProcessed * "Data Piecework For Production"."% Cost Asign.Sale" / 100,0.01);
                                END;
                            "Data Piecework For Production"."Allocation Terms"::"% on Direct Costs":
                                BEGIN

                                    //jmma error en migraci¢n campo equivocado        "Data Piecework For Production".VALIDATE("% Cost Asign.Sale");
                                    "Data Piecework For Production".VALIDATE("% Expense Cost");
                                    "Data Piecework For Production".SETFILTER("Filter Date", '..%1', DatePosting);
                                    CostRealized := 0;
                                    DataPieceworkForProduction.RESET;
                                    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                                    DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction.Type, DataPieceworkForProduction.Type::Piecework);
                                    DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                                    IF DataPieceworkForProduction.FINDSET THEN
                                        REPEAT
                                            DataPieceworkForProduction.SETRANGE("Filter Date", DateStartYear, DatePosting);
                                            DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (LCY)");
                                            CostRealized := CostRealized + DataPieceworkForProduction."Amount Cost Performed (LCY)";
                                        UNTIL DataPieceworkForProduction.NEXT = 0;
                                    AccumulatedAllocation := AccumulatedAllocation +
                                          ROUND(CostRealized * "Data Piecework For Production"."% Expense Cost" / 100, 0.01);
                                    //jmma error en migraci¢n campo equivocado                    ROUND(CostRealized * "Data Piecework For Production"."% Cost Asign.Sale" / 100,0.01);

                                    "Data Piecework For Production".CALCFIELDS("Amount Cost Performed (LCY)");
                                END;
                        END;
                    END;
                END;

                trigger OnPostDataItem();
                BEGIN
                    IF (Job."Rate Repercussion Job Code" <> '') AND (AccumulatedAllocation <> 0) THEN BEGIN
                        //JAV 08/07/19: - Se da un mensaje al finalizar
                        NroLin += 1;

                        NoLine := NoLine + 10000;
                        CostsheetLines2.INIT;
                        CostsheetLines2.VALIDATE("Document No.", CostsheetHeader."No.");
                        CostsheetLines2.VALIDATE("Line No.", NoLine);
                        CostsheetLines2.INSERT(TRUE);
                        CostsheetLines2.VALIDATE("Unit Cost No.", DataPieceworkForProductionRatesRepercussion."Piecework Code");
                        CostsheetLines2.VALIDATE("Invoicing Job", DataPieceworkForProductionRatesRepercussion."Job Billing Structure");
                        UnitsPostingGroup.GET(DataPieceworkForProductionRatesRepercussion."Posting Group Unit Cost");
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                            CostsheetLines2.VALIDATE("Shortcut Dimension 1 Code", UnitsPostingGroup."Cost Analytic Concept");
                        IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                            CostsheetLines2.VALIDATE("Shortcut Dimension 2 Code", UnitsPostingGroup."Cost Analytic Concept");
                        DataPieceworkForProductionRatesRepercussion.SETFILTER("Budget Filter", Job."Current Piecework Budget");

                        CASE DataPieceworkForProductionRatesRepercussion."Allocation Terms" OF
                            DataPieceworkForProductionRatesRepercussion."Allocation Terms"::"Fixed Amount":
                                BEGIN
                                    DataPieceworkForProductionRatesRepercussion.SETRANGE("Filter Date", DateStartYear, DatePosting);
                                    DataPieceworkForProductionRatesRepercussion.CALCFIELDS("Amount Cost Performed (LCY)");
                                    CostsheetLines2.Amount := AccumulatedAllocation;
                                    CostRealized := DataPieceworkForProductionRatesRepercussion."Amount Cost Performed (LCY)";
                                    CostsheetLines2.Amount := ROUND(CostsheetLines2.Amount - CostRealized, 0.01);
                                END;
                            DataPieceworkForProductionRatesRepercussion."Allocation Terms"::"% on Production":
                                BEGIN
                                    DataPieceworkForProductionRatesRepercussion.VALIDATE("% Expense Cost");
                                    DataPieceworkForProductionRatesRepercussion.SETRANGE("Filter Date", DateStartYear, DatePosting);
                                    DataPieceworkForProductionRatesRepercussion.CALCFIELDS("Amount Cost Performed (LCY)");
                                    CostsheetLines2.Amount := AccumulatedAllocation;
                                    CostRealized := DataPieceworkForProductionRatesRepercussion."Amount Cost Performed (LCY)";
                                    CostsheetLines2.Amount := ROUND(CostsheetLines2.Amount - CostRealized, 0.01);
                                END;
                            DataPieceworkForProductionRatesRepercussion."Allocation Terms"::"% on Direct Costs":
                                BEGIN
                                    DataPieceworkForProductionRatesRepercussion.VALIDATE("% Expense Cost");
                                    DataPieceworkForProductionRatesRepercussion.SETRANGE("Filter Date", DateStartYear, DatePosting);
                                    CostsheetLines2.Amount := AccumulatedAllocation;
                                    DataPieceworkForProductionRatesRepercussion.CALCFIELDS("Amount Cost Performed (LCY)");

                                    CostRealized := DataPieceworkForProductionRatesRepercussion."Amount Cost Performed (LCY)";
                                    CostsheetLines2.Amount := ROUND(CostsheetLines2.Amount - CostRealized, 0.01);
                                END;
                        END;
                        CostsheetLines2.MODIFY;
                        //-Q19838-Q18150
                        IF CostsheetLines2.Amount = 0 THEN CostsheetLines2.DELETE; //Para no dejar l¡neas a 0.
                                                                                   //+Q19838
                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IF DatePosting = 0D
                  THEN
                    ERROR(text001);
                //JAV 08/07/19: - Se cambia lo que se presenta en la pantalla para que sean datos coherentes
                //Window.OPEN('@1@@@@@@@@@@@@@@@@@@@@@@\'+
                //            '#2######## DE #3#########');

                Window.OPEN(Text006 + Text007);
                NroCab := 0;
                NroLin := 0;
                NroJob := 0;
                TotJob := COUNT;

                //JAV 08/07/19: - Se cabia el borrado de registros vac¡os para que funcione solo con los creados
                //IF Job.FINDLAST THEN
                //  UntilJob := Job."No.";
                //IF Job.FINDFIRST THEN
                //  SinceJob := Job."No.";
            END;

            trigger OnAfterGetRecord();
            BEGIN
                //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes
                NroJob += 1;
                Window.UPDATE(1, ROUND((NroJob / TotJob) * 10000, 1));

                //Si el proyecto no tiene presupuestadas unidades de coste no crear cabeceras
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
                DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::"Cost Unit");
                //Q18150
                //SETRANGE("Budget Filter","Current Piecework Budget");
                DataPieceworkForProduction.SETRANGE("Budget Filter", "Current Piecework Budget");
                //+Q18150
                IF NOT DataPieceworkForProduction.FINDFIRST THEN
                    CurrReport.SKIP;

                CostsheetHeader.INIT;
                CostsheetHeader."No." := '';
                CostsheetHeader.INSERT(TRUE);
                CostsheetHeader."Posting Date" := DatePosting;

                IF Job."Rate Repercussion Job Code" <> '' THEN BEGIN
                    CostsheetHeader.VALIDATE("Job No.", Job."Rate Repercussion Job Code");
                    JobRatesRepercussion.GET(Job."Rate Repercussion Job Code");
                    DataPieceworkForProductionRatesRepercussion.GET(Job."Rate Repercussion Job Code", Job."Rate Repercussion Cost Unit");
                END ELSE
                    CostsheetHeader.VALIDATE("Job No.", Job."No.");
                CostsheetHeader.MODIFY;

                //JAV 08/07/19: - Se da un mensjae al finalizar
                NroCab += 1;
                //JAV 08/07/19: - Se cambia el borrado de registros vac¡os para que funcione solo con los creados
                IF (SinceJob = '') THEN
                    SinceJob := CostsheetHeader."No.";
                UntilJob := CostsheetHeader."No.";
            END;

            trigger OnPostDataItem();
            BEGIN
                //proceso para que borre los proyectos de la cabecera que no tengan l¡neas
                //JAV 08/07/19: - Se cabia el borrado de registros vac¡os para que funcione solo con los creados
                // Job2.SETRANGE(Job2."No.",SinceJob,UntilJob);
                // IF Job2.FINDFIRST THEN
                //  REPEAT
                //    CostsheetHeader2.RESET;
                //    CostsheetHeader2.SETRANGE("Job No.",Job2."No.");
                //    IF CostsheetHeader2.FINDFIRST THEN
                //      REPEAT
                //        CostsheetLines.RESET;
                //        CostsheetLines.SETRANGE("Document No.",CostsheetHeader2."No.");
                //        IF NOT CostsheetLines.FINDFIRST THEN
                //          CostsheetHeader2.DELETE(TRUE);
                //          //JAV 08/07/19: - Se da un mensaje al finalizar
                //          NroCab -= 1;
                //      UNTIL CostsheetHeader2.NEXT = 0;
                //  UNTIL Job2.NEXT = 0;

                CostsheetHeader2.RESET;
                CostsheetHeader2.SETRANGE("No.", SinceJob, UntilJob);
                IF CostsheetHeader2.FINDSET THEN
                    REPEAT
                        CostsheetLines.RESET;
                        CostsheetLines.SETRANGE("Document No.", CostsheetHeader2."No.");
                        IF NOT CostsheetLines.FINDFIRST THEN BEGIN
                            CostsheetHeader2.DELETE(TRUE);
                            //JAV 08/07/19: - Se da un mensaje al finalizar
                            NroCab -= 1;
                        END;
                    UNTIL CostsheetHeader2.NEXT = 0;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group576")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("DatePosting"; "DatePosting")
                    {

                        CaptionML = ENU = 'Date Posting', ESP = 'Fecha registro';



                        ; trigger OnValidate()
                        BEGIN
                            DatePostingOnAfterValidate;
                        END;


                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       DatePosting@7001100 :
        DatePosting: Date;
        //       Window@7001101 :
        Window: Dialog;
        //       text001@7001102 :
        text001: TextConst ENU = 'You must specify Posting Date.', ESP = 'Debe especificar Fecha registro.';
        //       SinceJob@7001103 :
        SinceJob: Code[20];
        //       UntilJob@7001104 :
        UntilJob: Code[20];
        //       DataPieceworkForProduction@7001105 :
        DataPieceworkForProduction: Record 7207386;
        //       CostsheetHeader@7001106 :
        CostsheetHeader: Record 7207433;
        //       JobRatesRepercussion@7001107 :
        JobRatesRepercussion: Record 167;
        //       DataPieceworkForProductionRatesRepercussion@7001108 :
        DataPieceworkForProductionRatesRepercussion: Record 7207386;
        //       Job2@7001109 :
        Job2: Record 167;
        //       CostsheetHeader2@7001110 :
        CostsheetHeader2: Record 7207433;
        //       CostsheetLines@7001111 :
        CostsheetLines: Record 7207434;
        //       NoLine@7001112 :
        NoLine: Integer;
        //       Total@7001113 :
        Total: Decimal;
        //       DateStartYear@7001114 :
        DateStartYear: Date;
        //       AccumulatedAllocation@7001115 :
        AccumulatedAllocation: Decimal;
        //       JobJV@7001116 :
        JobJV: Record 167;
        //       Read@7001117 :
        Read: Decimal;
        //       CostsheetLines2@7001118 :
        CostsheetLines2: Record 7207434;
        //       UnitsPostingGroup@7001119 :
        UnitsPostingGroup: Record 7207431;
        //       FunctionQB@7001120 :
        FunctionQB: Codeunit 7207272;
        //       CostRealized@7001121 :
        CostRealized: Decimal;
        //       Text006@1100286001 :
        Text006: TextConst ENU = 'Processing delivery note lines \\', ESP = 'Proyecto @1@@@@@@@@@@@@@@@@@ \\';
        //       Text007@1100286000 :
        Text007: TextConst ENU = 'Generating Entry #1###### from #2###### ', ESP = 'U.O. @2@@@@@@@@@@@@@@@@@';
        //       NroCab@1100286007 :
        NroCab: Integer;
        //       NroLin@1100286004 :
        NroLin: Integer;
        //       NroJob@1100286003 :
        NroJob: Integer;
        //       TotJob@1100286002 :
        TotJob: Integer;
        //       NumberRegister@1100286005 :
        NumberRegister: Integer;
        //       TotalRegister@1100286006 :
        TotalRegister: Integer;
        //       RemainingCost@1100286008 :
        RemainingCost: Decimal;
        //       Ejecutado@1100286009 :
        Ejecutado: Decimal;
        //       EjecutadoAnt@1100286012 :
        EjecutadoAnt: Decimal;
        //       Porc_Ejecutado@1100286010 :
        Porc_Ejecutado: Decimal;
        //       DateBefore@1100286011 :
        DateBefore: Date;



    trigger OnPostReport();
    begin
        //JAV 08/07/19: - Se da un mensaje al finalizar
        MESSAGE('Se han creado %1 cabeceras y %2 l¡neas', NroCab, NroLin);
    end;



    // procedure CheckCostsheet (pLine@100000000 : Record 7207434;pJob@100000001 : Code[20];pDate@100000002 :
    procedure CheckCostsheet(pLine: Record 7207434; pJob: Code[20]; pDate: Date)
    var
        //       ExpectedTimeUnitData@1000000000 :
        ExpectedTimeUnitData: Record 7207388;
    begin
        ExpectedTimeUnitData.RESET;
        ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Expected Date");
        ExpectedTimeUnitData.SETRANGE("Job No.", pJob);
        //-Q18150
        ExpectedTimeUnitData.SETRANGE("Budget Code", Job."Current Piecework Budget");
        //+Q18150
        ExpectedTimeUnitData.SETRANGE("Piecework Code", pLine."Unit Cost No.");
        ExpectedTimeUnitData.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::"Cost Unit");
        ExpectedTimeUnitData.SETRANGE("Incluided In Dispatch", FALSE);
        ExpectedTimeUnitData.SETFILTER("Expected Date", '<=%1', pDate);
        if ExpectedTimeUnitData.FINDSET(TRUE, FALSE) then
            repeat
                ExpectedTimeUnitData."Incluided In Dispatch" := TRUE;
                ExpectedTimeUnitData."Doc. Dispatch No." := pLine."Document No.";
                ExpectedTimeUnitData.MODIFY;
            until ExpectedTimeUnitData.NEXT = 0;
    end;

    LOCAL procedure DatePostingOnAfterValidate()
    begin
        if DatePosting <> 0D then
            DatePosting := CALCDATE('PM', DatePosting);
    end;

    //     procedure CalcLine (pLine@100000000 : Record 7207434;pDataPiecework@100000001 : Record 7207386;pDate@100000003 :
    procedure CalcLine(pLine: Record 7207434; pDataPiecework: Record 7207386; pDate: Date)
    var
        //       Job@100000004 :
        Job: Record 167;
        //       JobBudget@1100286000 :
        JobBudget: Record 7207407;
        //       GeneralLedgerSetup@1100286002 :
        GeneralLedgerSetup: Record 98;
        //       Percent@1100286003 :
        Percent: Decimal;
        //       Total@1100286001 :
        Total: Decimal;
        //       PieceworkSetup@1100286005 :
        PieceworkSetup: Record 7207279;
        //       Records@1100286004 :
        Records: Record 7207393;
        //       Objective@1100286006 :
        Objective: Decimal;
    begin
        //Q18150 AML Cambios en la funci¢n CalclineBAK se conserva de momento para ver los cambios
        //Q18150 AML Los cambios se producen en la manera de calcular pDataPiecework."Allocation Terms"::"% on Production":
        GeneralLedgerSetup.GET;
        //-18150
        PieceworkSetup.GET;
        //+18150

        //JAV 25/04/20: - Se pasa el c¢digo que rellena una l¡nea a una funci¢n para poder llamarlo desde otros lugares
        Job.GET(pDataPiecework."Job No.");
        //JMMA 040521 a¤adir filtro fecha
        Job.SETRANGE("Posting Date Filter", 0D, DatePosting);
        pLine.VALIDATE("Unit Cost No.", pDataPiecework."Piecework Code");
        pLine.VALIDATE("Invoicing Job", pDataPiecework."Job Billing Structure");

        UnitsPostingGroup.GET(pDataPiecework."Posting Group Unit Cost");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then
            pLine.VALIDATE("Shortcut Dimension 1 Code", UnitsPostingGroup."Cost Analytic Concept");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 then
            pLine.VALIDATE("Shortcut Dimension 2 Code", UnitsPostingGroup."Cost Analytic Concept");
        pDataPiecework.SETFILTER("Budget Filter", Job."Current Piecework Budget");

        CASE pDataPiecework."Allocation Terms" OF
            pDataPiecework."Allocation Terms"::"Fixed Amount":
                begin
                    pLine.Amount := 0;
                end;
            pDataPiecework."Allocation Terms"::"% on Production":
                begin
                    pDataPiecework.VALIDATE("% Expense Cost"); //jmma error en migraci¢n campo equivocado
                    pDataPiecework.SETFILTER("Filter Date", '%1..%2', 0D, pDate);
                    pDataPiecework.CALCFIELDS("Amount Cost Performed (LCY)");
                    if JobBudget.GET(Job."No.", Job."Current Piecework Budget") then;
                    //AML Obtener el total a producir.
                    Total := 0;
                    Ejecutado := 0;
                    "Data Piecework For Production".SETRANGE("Filter Date", JobBudget."Budget Date", CALCDATE('PM', JobBudget."Budget Date"));
                    "Data Piecework For Production".CALCFIELDS("Amount Cost Performed (JC)");
                    //-Q18150
                    "Data Piecework For Production".CALCFIELDS("Amount Cost Performed (LCY)");
                    Ejecutado := pDataPiecework."Amount Cost Performed (LCY)";  //AML El c lculo no era correcto
                    pDataPiecework.SETFILTER("Filter Date", '%1..%2', JobBudget."Budget Date", pDate);
                    pDataPiecework.CALCFIELDS("Amount Cost Performed (LCY)");
                    EjecutadoAnt := pDataPiecework."Amount Cost Performed (LCY)";  //AML Para el porcentaje anterior
                    RemainingCost := 0;
                    Ejecutado := CalculatePercentage(JobBudget, Total, DatePosting);
                    Records.GET(pDataPiecework."Job No.", pDataPiecework."No. Record");
                    ////
                    if Records."Record Status" = Records."Record Status"::Approved then Objective := PieceworkSetup."Objective % High" / 100;
                    if Records."Record Status" = Records."Record Status"::"Technical Approval" then Objective := PieceworkSetup."Objective % Medium" / 100;
                    if Records."Record Status" = Records."Record Status"::Management then Objective := PieceworkSetup."Objective % Low" / 100;

                    Ejecutado := ROUND((pDataPiecework."% Expense Cost" / 100) * Objective * Ejecutado, GeneralLedgerSetup."Amount Rounding Precision");
                    RemainingCost := Ejecutado - EjecutadoAnt;
                    //+Q18150
                    pLine.Amount := ROUND(RemainingCost, 0.01);
                    CheckCostsheet(pLine, pDataPiecework."Job No.", pDate);
                end;
            pDataPiecework."Allocation Terms"::"% on Direct Costs":
                begin
                    pDataPiecework.VALIDATE("% Expense Cost");  //jmma error en migraci¢n campo equivocado
                    pDataPiecework.SETFILTER("Filter Date", '%1..%2', DateStartYear, pDate);
                    pDataPiecework.CALCFIELDS("Amount Cost Performed (LCY)");

                    CostRealized := 0;
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", pDataPiecework."Job No.");
                    DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                    DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework);
                    if DataPieceworkForProduction.FINDSET then
                        repeat
                            DataPieceworkForProduction.SETRANGE("Filter Date", DateStartYear, pDate);
                            DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (LCY)");
                            CostRealized += "Data Piecework For Production"."Amount Cost Performed (LCY)";
                        until DataPieceworkForProduction.NEXT = 0;

                    CostRealized := ROUND(CostRealized * pDataPiecework."% Expense Cost" / 100, 0.01); //jmma error en campo migraci¢n
                    pLine.Amount := ROUND(CostRealized - pDataPiecework."Amount Cost Performed (LCY)", 0.01);
                    CheckCostsheet(pLine, pDataPiecework."Job No.", pDate);
                end;
        end;
        //Guardo la l¡nea
        pLine.MODIFY;
    end;

    //     LOCAL procedure CalculatePercentage (JobBudget@1100286002 : Record 7207407;Total@1100286003 : Decimal;pDate@1100286004 :
    LOCAL procedure CalculatePercentage(JobBudget: Record 7207407; Total: Decimal; pDate: Date) Percent: Decimal;
    var
        //       HistProdMeasureLines@1100286000 :
        HistProdMeasureLines: Record 7207402;
        //       Measure@1100286001 :
        Measure: Decimal;
    begin
        //Q18150 AML Caculamos el avance en el per¡odo
        Measure := 0;
        HistProdMeasureLines.SETRANGE("Job No.", JobBudget."Job No.");
        HistProdMeasureLines.SETRANGE("Posting Date", JobBudget."Budget Date", pDate);
        //HistProdMeasureLines.SETRANGE("Piecework No.",DataPieceworkForProduction."Piecework Code");
        if HistProdMeasureLines.FINDSET then
            repeat
                //Measure += HistProdMeasureLines."Measure Term";
                Measure += HistProdMeasureLines."PROD Amount Term";
            until HistProdMeasureLines.NEXT = 0;
        //-Q18150
        //exit(Measure / Total);
        exit(Measure);

        //+Q18150
    end;

    //     procedure CalcLineBAK (pLine@100000000 : Record 7207434;pDataPiecework@100000001 : Record 7207386;pDate@100000003 :
    procedure CalcLineBAK(pLine: Record 7207434; pDataPiecework: Record 7207386; pDate: Date)
    var
        //       Job@100000004 :
        Job: Record 167;
    begin
        //JAV 25/04/20: - Se pasa el c¢digo que rellena una l¡nea a una funci¢n para poder llamarlo desde otros lugares
        Job.GET(pDataPiecework."Job No.");
        //JMMA 040521 a¤adir filtro fecha
        Job.SETRANGE("Posting Date Filter", 0D, DatePosting);
        pLine.VALIDATE("Unit Cost No.", pDataPiecework."Piecework Code");
        pLine.VALIDATE("Invoicing Job", pDataPiecework."Job Billing Structure");

        UnitsPostingGroup.GET(pDataPiecework."Posting Group Unit Cost");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then
            pLine.VALIDATE("Shortcut Dimension 1 Code", UnitsPostingGroup."Cost Analytic Concept");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 then
            pLine.VALIDATE("Shortcut Dimension 2 Code", UnitsPostingGroup."Cost Analytic Concept");
        pDataPiecework.SETFILTER("Budget Filter", Job."Current Piecework Budget");

        CASE pDataPiecework."Allocation Terms" OF
            pDataPiecework."Allocation Terms"::"Fixed Amount":
                begin
                    pLine.Amount := 0;
                end;
            pDataPiecework."Allocation Terms"::"% on Production":
                begin
                    pDataPiecework.VALIDATE("% Expense Cost"); //jmma error en migraci¢n campo equivocado
                    pDataPiecework.SETFILTER("Filter Date", '%1..%2', DateStartYear, pDate);
                    pDataPiecework.CALCFIELDS("Amount Cost Performed (LCY)");

                    CostRealized := 0;
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", pDataPiecework."Job No.");
                    DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                    DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
                    if DataPieceworkForProduction.FINDSET then
                        repeat
                            DataPieceworkForProduction.SETRANGE("Filter Date", DateStartYear, pDate);
                            DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                            CostRealized += ROUND(DataPieceworkForProduction."Amount Production Performed" * DataPieceworkForProduction."% Processed Production" / 100, 0.01);
                        until DataPieceworkForProduction.NEXT = 0;

                    CostRealized := ROUND(CostRealized * pDataPiecework."% Expense Cost" / 100, 0.01); //jmma error en campo migraci¢n
                                                                                                       //JMMA 031220 PRODUTE
                    if pDataPiecework."Over JV Production" then begin
                        if Job.GET(pDataPiecework."Job No.") then
                            if Job."Job UTE" <> '' then begin
                                Job.SETRANGE("Posting Date Filter", DateStartYear, pDate);  //JAV 10/05/21: - QB 1.08.42 filtrar igual que en el resto del programa
                                CostRealized := Job.ActualProdAmountUTE * pDataPiecework."% Expense Cost" / 100;
                            end;
                        //JMMA 031220 PRODUTE

                    end;
                    pLine.Amount := ROUND(CostRealized - pDataPiecework."Amount Cost Performed (LCY)", 0.01);
                    CheckCostsheet(pLine, pDataPiecework."Job No.", pDate);
                end;
            pDataPiecework."Allocation Terms"::"% on Direct Costs":
                begin
                    pDataPiecework.VALIDATE("% Expense Cost");  //jmma error en migraci¢n campo equivocado
                    pDataPiecework.SETFILTER("Filter Date", '%1..%2', DateStartYear, pDate);
                    pDataPiecework.CALCFIELDS("Amount Cost Performed (LCY)");

                    CostRealized := 0;
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", pDataPiecework."Job No.");
                    DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                    DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework);
                    if DataPieceworkForProduction.FINDSET then
                        repeat
                            DataPieceworkForProduction.SETRANGE("Filter Date", DateStartYear, pDate);
                            DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (LCY)");
                            CostRealized += DataPieceworkForProduction."Amount Cost Performed (LCY)";
                        until DataPieceworkForProduction.NEXT = 0;

                    CostRealized := ROUND(CostRealized * pDataPiecework."% Expense Cost" / 100, 0.01); //jmma error en campo migraci¢n
                    pLine.Amount := ROUND(CostRealized - pDataPiecework."Amount Cost Performed (LCY)", 0.01);
                    CheckCostsheet(pLine, pDataPiecework."Job No.", pDate);
                end;
        end;
        //Guardo la l¡nea
        pLine.MODIFY;
    end;

    /*begin
    //{
//      JAV 08/07/19: - Se cambia lo que se presenta en la pantalla para que sean datos coherentes y se da mensaje al finalizar
//                    - Se cambia el borrado de registros vac¡os para que funcione solo con los creados
//      AML Q18150 23/5/23 Se pone filtro de presupuesto. Relacionado con el calculo de periodificables. Se corrije calculode producido.
//      AML Q19838 30/06/23 Modificacion para no escribir lineas a 0
//    }
    end.
  */

}




