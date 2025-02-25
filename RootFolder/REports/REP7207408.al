report 7207408 "QB Piecework Analytic"
{


    CaptionML = ENU = 'Piecework Analytic', ESP = 'Anal¡tica unidad de obra';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Budget Filter", "Posting Date Filter";
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
                //SourceExpr=FORMAT(TODAY,0,4);
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(FORMAT_Job__No____________Job_Description; FORMAT(Job."No.") + '  ' + Job.Description + ' ' + Job."Description 2")
            {
                //SourceExpr=FORMAT(Job."No.") + '  ' +Job.Description + ' ' + Job."Description 2";
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(PeriodFilter; PeriodFilter)
            {
                //SourceExpr=PeriodFilter;
            }
            Column(Job_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(Job_Description; Description)
            {
                //SourceExpr=Description;
            }
            Column(Job_Description2; "Description 2")
            {
                //SourceExpr="Description 2";
            }
            Column(PeriodFilter_Cap; PeriodFilterLbl)
            {
                //SourceExpr=PeriodFilterLbl;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Title", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Production Unit" = CONST(true));


                CalcFields = "Amount Production Performed", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)", "Budget Measure", "Total Measurement Production", "Amount Cost Budget (JC)", "Amount Production Budget";
                DataItemLink = "Job No." = FIELD("No.");
                Column(Picework_PieceworkCode; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(Picework_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Piecework_MeasureBudgPieceworkSol; "Measure Budg. Piecework Sol")
                {
                    //SourceExpr="Measure Budg. Piecework Sol";
                }
                Column(Piecework_AmountProductionBudget; "Amount Production Budget")
                {
                    //SourceExpr="Amount Production Budget";
                }
                Column(Piecework_AverCostPricePendBudget; "Aver. Cost Price Pend. Budget")
                {
                    //SourceExpr="Aver. Cost Price Pend. Budget";
                }
                Column(Piecework_AmountCostBudgetLCY; "Amount Cost Budget (JC)")
                {
                    //SourceExpr="Amount Cost Budget (JC)";
                }
                Column(Piecework_TotalMeasurementProduction; "Total Measurement Production")
                {
                    //SourceExpr="Total Measurement Production";
                }
                Column(Piecework_AmountProductionPerformed; "Amount Production Performed")
                {
                    //SourceExpr="Amount Production Performed";
                }
                Column(Piecework_AdvanceProductionPercentage; AdvanceProductionPercentage)
                {
                    //SourceExpr=AdvanceProductionPercentage;
                }
                Column(Piecework_AmountCostRealized; AmountCostRealized)
                {
                    //SourceExpr=AmountCostRealized;
                }
                Column(Piecework_AmountCostPerformedLCY; "Amount Cost Performed (JC)")
                {
                    //SourceExpr="Amount Cost Performed (JC)";
                }
                Column(Piecework_Desviation; Desviation)
                {
                    //SourceExpr=Desviation;
                }
                Column(NoBudget; NoBudget)
                {
                    //SourceExpr=NoBudget;
                }
                Column(BudgetText; BudgetText)
                {
                    //SourceExpr=BudgetText;
                }
                Column(Budget_caption; Budget_caption)
                {
                    //SourceExpr=Budget_caption;
                }
                Column(AnalyticalPieceworkCaption; AnalyticalPieceworkLbl)
                {
                    //SourceExpr=AnalyticalPieceworkLbl;
                }
                Column(page_Caption; page_Caption)
                {
                    //SourceExpr=page_Caption;
                }
                Column(Job_caption; Job_caption)
                {
                    //SourceExpr=Job_caption;
                }
                Column(Picework_PieceworkCode_Cap; FIELDCAPTION("Piecework Code"))
                {
                    //SourceExpr=FIELDCAPTION("Piecework Code");
                }
                Column(Picework_Description_Cap; FIELDCAPTION(Description))
                {
                    //SourceExpr=FIELDCAPTION(Description);
                }
                Column(Piecework_MeasureBudgPieceworkSol_Cap; FIELDCAPTION("Measure Budg. Piecework Sol"))
                {
                    //SourceExpr=FIELDCAPTION("Measure Budg. Piecework Sol");
                }
                Column(Piecework_AmountProductionBudget_Cap; FIELDCAPTION("Amount Production Budget"))
                {
                    //SourceExpr=FIELDCAPTION("Amount Production Budget");
                }
                Column(Piecework_AverCostPricePendBudget_Cap; FIELDCAPTION("Aver. Cost Price Pend. Budget"))
                {
                    //SourceExpr=FIELDCAPTION("Aver. Cost Price Pend. Budget");
                }
                Column(Piecework_AmountCostBudgetLCY_Cap; FIELDCAPTION("Amount Cost Budget (JC)"))
                {
                    //SourceExpr=FIELDCAPTION("Amount Cost Budget (JC)");
                }
                Column(Piecework_TotalMeasurementProduction_Cap; FIELDCAPTION("Total Measurement Production"))
                {
                    //SourceExpr=FIELDCAPTION("Total Measurement Production");
                }
                Column(Piecework_AmountProductionPerformed_Cap; FIELDCAPTION("Amount Production Performed"))
                {
                    //SourceExpr=FIELDCAPTION("Amount Production Performed");
                }
                Column(Piecework_AdvanceProductionPercentage_Cap; AdvanceProductionPercentageLbl)
                {
                    //SourceExpr=AdvanceProductionPercentageLbl;
                }
                Column(Piecework_AmountCostRealized_Cap; AmountCostRealizedLbl)
                {
                    //SourceExpr=AmountCostRealizedLbl;
                }
                Column(Piecework_AmountCostPerformedLCY_Cap; FIELDCAPTION("Amount Cost Performed (JC)"))
                {
                    //SourceExpr=FIELDCAPTION("Amount Cost Performed (JC)");
                }
                Column(Piecework_Desviation_Cap; DesviationLbl)
                {
                    //SourceExpr=DesviationLbl;
                }
                DataItem("Data Cost By Piecework"; "Data Cost By Piecework")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Ascending)
                                 WHERE("No." = FILTER(<> ''));
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                    Column(DataCost_CostType; "Cost Type")
                    {
                        //SourceExpr="Cost Type";
                    }
                    Column(DataCost_No; "No.")
                    {
                        //SourceExpr="No.";
                    }
                    Column(DataCost_Description; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(DataCost_AmountCostRealized_DC; AmountCostRealized_DC)
                    {
                        //SourceExpr=AmountCostRealized_DC;
                    }
                    Column(DataCost_AmountCostPerformedLCY_DC; AmountCostPerformedLCY_DC)
                    {
                        //SourceExpr=AmountCostPerformedLCY_DC;
                    }
                    Column(DataCost_Desviation_DC; Desviation_DC)
                    {
                        //SourceExpr=Desviation_DC;
                    }
                    DataItem("DataCostByPiecework_Temp"; "Data Cost By Piecework")
                    {

                        DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Ascending)
                                 WHERE("No." = FILTER(<> ''));
                        DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                        UseTemporary = true;
                        Column(DataCost_Temp_CostType; "Cost Type")
                        {
                            //SourceExpr="Cost Type";
                        }
                        Column(DataCost_Temp_No; "No.")
                        {
                            //SourceExpr="No.";
                        }
                        Column(DataCost_Temp_Description; Description)
                        {
                            //SourceExpr=Description;
                        }
                        Column(DataCost_Temp_AmountCostRealized_DC; AmountCostRealized_DCT)
                        {
                            //SourceExpr=AmountCostRealized_DCT;
                        }
                        Column(DataCost_Temp_AmountCostPerformedLCY_DC; AmountCostPerformedLCY_DCT)
                        {
                            //SourceExpr=AmountCostPerformedLCY_DCT;
                        }
                        Column(DataCost_Temp_Desviation_DCT; Desviation_DCT)
                        {
                            //SourceExpr=Desviation_DCT ;
                        }
                        trigger OnPreDataItem();
                        BEGIN
                            IF Job.GETFILTER("Budget Filter") <> '' THEN
                                SETFILTER("Cod. Budget", Job.GETFILTER("Budget Filter"))
                            ELSE
                                SETFILTER("Cod. Budget", Job."Current Piecework Budget");
                        END;

                        trigger OnAfterGetRecord();
                        VAR
                            //                                   JobLedgerEntryDCP@1100286000 :
                            JobLedgerEntryDCP: Record 169;
                        BEGIN
                            //SETFILTER("Cod. Budget","Data Piecework For Production".GETFILTER("Budget Filter"));
                            AmountCostRealized_DCT := 0;
                            AmountCostPerformedLCY_DCT := 0;

                            AmountCostRealized_DCT := "Data Piecework For Production"."Total Measurement Production" * "Performance By Piecework" * "Direct Unitary Cost (JC)";

                            //-Calcular Importe Coste realizado
                            JobLedgerEntryDCP.RESET;
                            JobLedgerEntryDCP.SETCURRENTKEY("Job No.", "Posting Date", Type, "No.", "Entry Type", "Piecework No.");
                            JobLedgerEntryDCP.SETRANGE("Entry Type", JobLedgerEntryDCP."Entry Type"::Usage);
                            JobLedgerEntryDCP.SETRANGE("Job No.", "Job No.");
                            JobLedgerEntryDCP.SETRANGE("Piecework No.", "Piecework Code");
                            JobLedgerEntryDCP.SETFILTER("Posting Date", PeriodFilter);

                            CASE DataCostByPiecework_Temp."Cost Type" OF
                                DataCostByPiecework_Temp."Cost Type"::Account:
                                    JobLedgerEntryDCP.SETRANGE(Type, JobLedgerEntryDCP.Type::"G/L Account");
                                DataCostByPiecework_Temp."Cost Type"::Item:
                                    JobLedgerEntryDCP.SETRANGE(Type, JobLedgerEntryDCP.Type::Item);
                                DataCostByPiecework_Temp."Cost Type"::Resource:
                                    JobLedgerEntryDCP.SETRANGE(Type, JobLedgerEntryDCP.Type::Resource);
                            END;
                            JobLedgerEntryDCP.SETRANGE("No.", "No.");
                            IF JobLedgerEntryDCP.FINDSET THEN
                                REPEAT
                                    AmountCostPerformedLCY_DCT += JobLedgerEntryDCP."Total Cost (LCY)";
                                UNTIL JobLedgerEntryDCP.NEXT = 0;
                            //+Calcular Importe Coste realizado

                            Desviation_DCT := CalculateDesviationPercentage_DCP(AmountCostRealized_DCT, AmountCostPerformedLCY_DCT);
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        IF Job.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Cod. Budget", Job.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Cod. Budget", Job."Current Piecework Budget");
                    END;

                    trigger OnAfterGetRecord();
                    VAR
                        //                                   JobLedgerEntryDCP@1100286000 :
                        JobLedgerEntryDCP: Record 169;
                    BEGIN
                        //SETFILTER("Cod. Budget","Data Piecework For Production".GETFILTER("Budget Filter"));
                        AmountCostRealized_DC := 0;
                        AmountCostPerformedLCY_DC := 0;

                        AmountCostRealized_DC := "Data Piecework For Production"."Total Measurement Production" * "Performance By Piecework" * "Direct Unitary Cost (JC)";

                        //-Calcular Importe Coste realizado
                        JobLedgerEntryDCP.RESET;
                        JobLedgerEntryDCP.SETCURRENTKEY("Job No.", "Posting Date", Type, "No.", "Entry Type", "Piecework No.");
                        JobLedgerEntryDCP.SETRANGE("Entry Type", JobLedgerEntryDCP."Entry Type"::Usage);
                        JobLedgerEntryDCP.SETRANGE("Job No.", "Job No.");
                        JobLedgerEntryDCP.SETRANGE("Piecework No.", "Piecework Code");
                        JobLedgerEntryDCP.SETFILTER("Posting Date", PeriodFilter);

                        CASE "Data Cost By Piecework"."Cost Type" OF
                            "Data Cost By Piecework"."Cost Type"::Account:
                                JobLedgerEntryDCP.SETRANGE(Type, JobLedgerEntryDCP.Type::"G/L Account");
                            "Data Cost By Piecework"."Cost Type"::Item:
                                JobLedgerEntryDCP.SETRANGE(Type, JobLedgerEntryDCP.Type::Item);
                            "Data Cost By Piecework"."Cost Type"::Resource:
                                JobLedgerEntryDCP.SETRANGE(Type, JobLedgerEntryDCP.Type::Resource);
                        END;
                        JobLedgerEntryDCP.SETRANGE("No.", "No.");
                        IF JobLedgerEntryDCP.FINDSET THEN
                            REPEAT
                                AmountCostPerformedLCY_DC += JobLedgerEntryDCP."Total Cost (LCY)";
                            UNTIL JobLedgerEntryDCP.NEXT = 0;
                        //+Calcular Importe Coste realizado

                        Desviation_DC := CalculateDesviationPercentage_DCP(AmountCostRealized_DC, AmountCostPerformedLCY_DC);
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    IF Job.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Job."Current Piecework Budget");
                END;

                trigger OnAfterGetRecord();
                VAR
                    //                                   DataCostByPiecework@1100286000 :
                    DataCostByPiecework: Record 7207387;
                    //                                   JobLedgerEntry@1100286001 :
                    JobLedgerEntry: Record 169;
                BEGIN
                    SETFILTER("Filter Date", PeriodFilter);
                    CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget", "Budget Measure", "Total Measurement Production",
                    "Amount Production Performed", "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");

                    AmountCostRealized := AmountCostTheoreticalProduction(NoBudget, "Data Piecework For Production");
                    Desviation := CalculateDesviationPercentage(AmountCostRealized, "Amount Cost Performed (JC)");

                    //-Insertar l¡neas que no existan
                    JobLedgerEntry.RESET;
                    JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date", Type, "No.", "Entry Type", "Piecework No.");
                    JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntry.SETRANGE("Job No.", "Job No.");
                    JobLedgerEntry.SETRANGE("Piecework No.", "Piecework Code");
                    JobLedgerEntry.SETFILTER("Posting Date", PeriodFilter);
                    IF JobLedgerEntry.FINDSET THEN
                        REPEAT
                            DataCostByPiecework.RESET;
                            DataCostByPiecework.SETCURRENTKEY("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                            DataCostByPiecework.SETRANGE("Job No.", JobLedgerEntry."Job No.");
                            DataCostByPiecework.SETRANGE("Piecework Code", JobLedgerEntry."Piecework No.");
                            DataCostByPiecework.SETRANGE("Cod. Budget", Job.GETFILTER("Budget Filter"));
                            CASE JobLedgerEntry.Type OF
                                JobLedgerEntry.Type::"G/L Account":
                                    BEGIN
                                        DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Account);
                                        CostType := CostType::Account;
                                    END;
                                JobLedgerEntry.Type::Item:
                                    BEGIN
                                        DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Item);
                                        CostType := CostType::Item;
                                    END;
                                JobLedgerEntry.Type::Resource:
                                    BEGIN
                                        DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
                                        CostType := CostType::Resource;
                                    END;
                            END;
                            DataCostByPiecework.SETRANGE("No.", JobLedgerEntry."No.");
                            IF DataCostByPiecework.ISEMPTY THEN BEGIN
                                DataCostByPiecework_Temp.INIT;
                                DataCostByPiecework_Temp."Job No." := JobLedgerEntry."Job No.";
                                DataCostByPiecework_Temp."Cod. Budget" := Job.GETFILTER("Budget Filter");
                                DataCostByPiecework_Temp."Piecework Code" := JobLedgerEntry."Piecework No.";
                                DataCostByPiecework_Temp."Cost Type" := CostType;
                                DataCostByPiecework_Temp."No." := JobLedgerEntry."No.";
                                DataCostByPiecework_Temp.Description := JobLedgerEntry.Description;
                                IF NOT DataCostByPiecework_Temp.INSERT THEN
                                    DataCostByPiecework_Temp.MODIFY;
                            END;
                        UNTIL JobLedgerEntry.NEXT = 0;
                    //+Insertar l¡neas que no existan
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                // StartDate := GETRANGEMIN("Posting Date Filter");
                // EndDate := GETRANGEMAX("Posting Date Filter");

                //IF ((Job.GETFILTER(Job."Posting Date Filter") = '') OR (StartDate = EndDate)) THEN
                IF (Job.GETFILTER(Job."Posting Date Filter") = '') THEN
                    ERROR(Text0001);

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
                PeriodFilter := Job.GETFILTER(Job."Posting Date Filter");

                DataCostByPiecework_Temp.DELETEALL;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                SETFILTER("Posting Date Filter", PeriodFilter);

                BudgetText := '';
                IF Job.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Job."No.", Job.GETFILTER("Budget Filter")) THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        NoBudget := JobBudget."Cod. Budget";
                    END
                END
                ELSE BEGIN
                    IF JobBudget.GET(Job."No.", Job."Current Piecework Budget") THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        NoBudget := JobBudget."Cod. Budget";
                    END;
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       CompanyInformation@1100286000 :
        CompanyInformation: Record 79;
        //       StartDate@1100286002 :
        StartDate: Date;
        //       EndDate@1100286001 :
        EndDate: Date;
        //       Text0001@1100286003 :
        Text0001: TextConst ENU = 'You must specify a date period in the Filter Date field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       PeriodFilter@1100286004 :
        PeriodFilter: Text[30];
        //       CostType@1100286005 :
        CostType: Option "Account","Resource","Resource Group","Item","Posting U.";
        //       AmountCostRealized@1100286006 :
        AmountCostRealized: Decimal;
        //       Desviation@1100286007 :
        Desviation: Decimal;
        //       AmountCostRealized_DC@1100286008 :
        AmountCostRealized_DC: Decimal;
        //       AmountCostPerformedLCY_DC@1100286009 :
        AmountCostPerformedLCY_DC: Decimal;
        //       AmountCostRealized_DCT@1100286018 :
        AmountCostRealized_DCT: Decimal;
        //       AmountCostPerformedLCY_DCT@1100286017 :
        AmountCostPerformedLCY_DCT: Decimal;
        //       Desviation_DC@1100286023 :
        Desviation_DC: Decimal;
        //       Desviation_DCT@1100286024 :
        Desviation_DCT: Decimal;
        //       BudgetText@1100286012 :
        BudgetText: Text[50];
        //       JobBudget@1100286011 :
        JobBudget: Record 7207407;
        //       NoBudget@1100286010 :
        NoBudget: Code[20];
        //       Budget_caption@1100286013 :
        Budget_caption: TextConst ENU = 'Budget', ESP = 'Presupuesto';
        //       AnalyticalPieceworkLbl@1100286014 :
        AnalyticalPieceworkLbl: TextConst ENU = 'Analytical Picework', ESP = 'Anal¡tica unidad de obra';
        //       page_Caption@1100286015 :
        page_Caption: TextConst ENU = 'page', ESP = 'p g.';
        //       Job_caption@1100286016 :
        Job_caption: TextConst ENU = 'N§ JOB', ESP = 'PROYECTO N§';
        //       AdvanceProductionPercentageLbl@1100286019 :
        AdvanceProductionPercentageLbl: TextConst ENU = 'Advance', ESP = '% Avance';
        //       AmountCostRealizedLbl@1100286020 :
        AmountCostRealizedLbl: TextConst ESP = 'Coste teorico producci¢n realizada';
        //       DesviationLbl@1100286021 :
        DesviationLbl: TextConst ESP = '% Desviaci¢n Costes';
        //       BudgetinProgress@1100286022 :
        BudgetinProgress: Code[20];
        //       PeriodFilterLbl@1100286025 :
        PeriodFilterLbl: TextConst ENU = 'Date Filter', ESP = '"Filtro fecha "';

    //     procedure CalculateDesviationPercentage_DCP (PCostTheorical@1100281000 : Decimal;PCostReal@1100281001 :
    procedure CalculateDesviationPercentage_DCP(PCostTheorical: Decimal; PCostReal: Decimal): Decimal;
    var
        //       RelCertificationProduct@1100003 :
        RelCertificationProduct: Record 7207397;
        //       DataPieceworkForProduction@1100002 :
        DataPieceworkForProduction: Record 7207386;
        //       AmountCostProduction@1100001 :
        AmountCostProduction: Decimal;
    begin
        if PCostTheorical <> 0 then
            exit(ROUND(((PCostReal - PCostTheorical) * 100 / PCostTheorical), 0.01))
        else
            exit(0);
    end;

    /*begin
    //{
//      EPV 03/01/23  Q18434 Reducir el tama¤o de las columnas para que no traspase el ancho del informe. Se modifica el informe para mantener los t¡tulos de las columnas en todas las p ginas
//    }
    end.
  */

}



