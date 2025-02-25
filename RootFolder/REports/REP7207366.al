report 7207366 "Job Result Final"
{


    CaptionML = ENU = 'Job Result Final', ESP = 'Resultado obra final';

    dataset
    {

        DataItem("Selection"; "Job")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Job', ESP = 'Obra';


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
            Column(FORMAT__No____________Description; FORMAT("No.") + '  ' + Description + '  ' + "Description 2")
            {
                //SourceExpr=FORMAT("No.") + '  ' +Description + '  ' + "Description 2";
            }
            Column(JobText____; JobText + ':')
            {
                //SourceExpr=JobText+':';
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(DateT; DateT)
            {
                //SourceExpr=DateT;
            }
            Column(BudgetText; BudgetText)
            {
                //SourceExpr=BudgetText;
            }
            Column(BudgetCaption; BudgetCaption)
            {
                //SourceExpr=BudgetCaption;
            }
            Column(Selection_Description; Description)
            {
                //SourceExpr=Description;
            }
            Column(TotSaleExecConsolidate; TotSaleExecConsolidate)
            {
                //SourceExpr=TotSaleExecConsolidate;
            }
            Column(TotSalePendingConsolidate; TotSalePendingConsolidate)
            {
                //SourceExpr=TotSalePendingConsolidate;
            }
            Column(TotSaleTotConsolidate; TotSaleTotConsolidate)
            {
                //SourceExpr=TotSaleTotConsolidate;
            }
            Column(TotSaleTotConsolidate_TGVarTotalCost; TotSaleTotConsolidate - TGVarTotalCost)
            {
                //SourceExpr=TotSaleTotConsolidate-TGVarTotalCost;
            }
            Column(TGVarCostCompleted; TGVarCostCompleted)
            {
                //SourceExpr=TGVarCostCompleted;
            }
            Column(TGVarPendingCost; TGVarPendingCost)
            {
                //SourceExpr=TGVarPendingCost;
            }
            Column(TGVarTotalCost; TGVarTotalCost)
            {
                //SourceExpr=TGVarTotalCost;
            }
            Column(Selection_Description_Control204; Description)
            {
                //SourceExpr=Description;
            }
            Column(TotSaleExecInProcess; TotSaleExecInProcess)
            {
                //SourceExpr=TotSaleExecInProcess;
            }
            Column(TotSalePendingInProcess; TotSalePendingInProcess)
            {
                //SourceExpr=TotSalePendingInProcess;
            }
            Column(TotSaleTotInProcess; TotSaleTotInProcess)
            {
                //SourceExpr=TotSaleTotInProcess;
            }
            Column(TotSaleTotInProcess_Control181; TotSaleTotInProcess)
            {
                //SourceExpr=TotSaleTotInProcess;
            }
            Column(Selection_Description_Control41; Description)
            {
                //SourceExpr=Description;
            }
            Column(TGVarProdExecuted; TGVarProdExecuted)
            {
                //SourceExpr=TGVarProdExecuted;
            }
            Column(TGVarProdPending; TGVarProdPending)
            {
                //SourceExpr=TGVarProdPending;
            }
            Column(TGVarProdTotal; TGVarProdTotal)
            {
                //SourceExpr=TGVarProdTotal;
            }
            Column(TGVarCostCompleted_Control1100251021; TGVarCostCompleted)
            {
                //SourceExpr=TGVarCostCompleted;
            }
            Column(TGVarPendingCost_Control1100251026; TGVarPendingCost)
            {
                //SourceExpr=TGVarPendingCost;
            }
            Column(TGVarTotalCost_Control1100251027; TGVarTotalCost)
            {
                //SourceExpr=TGVarTotalCost;
            }
            Column(TGVarProdTotal_TGVarTotalCost; TGVarProdTotal - TGVarTotalCost)
            {
                //SourceExpr=TGVarProdTotal-TGVarTotalCost;
            }
            Column(MarginV; MarginV)
            {
                //SourceExpr=MarginV;
            }
            Column(JobResultFinalCaption; JobResultFinalCaption)
            {
                //SourceExpr=JobResultFinalCaption;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
                //SourceExpr=CurrReport_PAGENOCaption;
            }
            Column(PieceworkCaption; PieceworkCaption)
            {
                //SourceExpr=PieceworkCaption;
            }
            Column(MeasuredUnitCaption; MeasuredUnitCaption)
            {
                //SourceExpr=MeasuredUnitCaption;
            }
            Column(DescriptionCaption; DescriptionCaption)
            {
                //SourceExpr=DescriptionCaption;
            }
            Column(Prod__executedCaption; Prod__executedCaption)
            {
                //SourceExpr=Prod__executedCaption;
            }
            Column(Prod__pendingCaption; Prod__pendingCaption)
            {
                //SourceExpr=Prod__pendingCaption;
            }
            Column(Prod__totalCaption; Prod__totalCaption)
            {
                //SourceExpr=Prod__totalCaption;
            }
            Column(Origin_Real_ExprensesCaption; Origin_Real_ExprensesCaption)
            {
                //SourceExpr=Origin_Real_ExprensesCaption;
            }
            Column(Theoretical_Cost_Pending_Caption; Theoretical_Cost_Pending_Caption)
            {
                //SourceExpr=Theoretical_Cost_Pending_Caption;
            }
            Column(Total_Cost_EstimatedCaption; Total_Cost_EstimatedCaption)
            {
                //SourceExpr=Total_Cost_EstimatedCaption;
            }
            Column(ResultCaption; ResultCaption)
            {
                //SourceExpr=ResultCaption;
            }
            Column(Date_FilerCaption; Date_FilerCaption)
            {
                //SourceExpr=Date_FilerCaption;
            }
            Column(Production_in_processCaption; Production_in_processCaption)
            {
                //SourceExpr=Production_in_processCaption;
            }
            Column(MarginCaption; MarginCaption)
            {
                //SourceExpr=MarginCaption;
            }
            Column(Total_ConsolidatedCaption; Total_ConsolidatedCaption)
            {
                //SourceExpr=Total_ConsolidatedCaption;
            }
            Column(Total_in_ProcessCaption; Total_in_ProcessCaption)
            {
                //SourceExpr=Total_in_ProcessCaption;
            }
            Column(Total_Job_GrossCaption; Total_Job_GrossCaption)
            {
                //SourceExpr=Total_Job_GrossCaption;
            }
            Column(Selection_No_; "No.")
            {
                //SourceExpr="No.";
            }
            DataItem("Job"; "Job")
            {

                DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(Job_Job_Description; Job.Description)
                {
                    //SourceExpr=Job.Description;
                }
                Column(TVarProdExecuted; TVarProdExecuted)
                {
                    //SourceExpr=TVarProdExecuted;
                }
                Column(TVarProdPending; TVarProdPending)
                {
                    //SourceExpr=TVarProdPending;
                }
                Column(TVarProdTotal; TVarProdTotal)
                {
                    //SourceExpr=TVarProdTotal;
                }
                Column(TVarCostCompleted; TVarCostCompleted)
                {
                    //SourceExpr=TVarCostCompleted;
                }
                Column(TVarPendingCost; TVarPendingCost)
                {
                    //SourceExpr=TVarPendingCost;
                }
                Column(TVarTotalCost; TVarTotalCost)
                {
                    //SourceExpr=TVarTotalCost;
                }
                Column(TVarProdTotal_TVarTotalCost; TVarProdTotal - TVarTotalCost)
                {
                    //SourceExpr=TVarProdTotal-TVarTotalCost;
                }
                Column(Total_JobCaption; Total_JobCaption)
                {
                    //SourceExpr=Total_JobCaption;
                }
                Column(Job_No_; "No.")
                {
                    //SourceExpr="No.";
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Title", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(DataPieceworkForProduction_AmountProductionPerformed; "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountProductionBudget_AmountProductionPerformed; "Data Piecework For Production"."Amount Production Budget" - "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Budget"-"Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountProductionBudget; "Data Piecework For Production"."Amount Production Budget")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Budget";
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(PendingCost; PendingCost)
                    {
                        //SourceExpr=PendingCost;
                    }
                    Column(TotalCost; TotalCost)
                    {
                        //SourceExpr=TotalCost;
                    }
                    Column(Difference; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2_DataPieceworkForProduction_Description; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2_PieceworkCode; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(MarginV_Control1100251046; MarginV)
                    {
                        //SourceExpr=MarginV;
                    }
                    Column(DataPieceworkForProduction_AmountProductionPerformed__Control1100251002; "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountProductionBudget_AmountProductionPerformed__Control1100251003; "Data Piecework For Production"."Amount Production Budget" - "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Budget"-"Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountProductionBudget___Control1100251004; "Data Piecework For Production"."Amount Production Budget" - "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Budget"-"Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed__Control1100251005; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(PendingCost_Control1100251006; PendingCost)
                    {
                        //SourceExpr=PendingCost;
                    }
                    Column(TotalCost_Control1100251007; TotalCost)
                    {
                        //SourceExpr=TotalCost;
                    }
                    Column(Difference_Control1100251008; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2_DataPieceworkForProduction_Description_Control1100251024; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2_PieceworkCode__Control1100251025; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(MarginV_Control1100251045; MarginV)
                    {
                        //SourceExpr=MarginV;
                    }
                    Column(DataPieceworkForProduction_UnitOfMeasure; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(DataPieceworkForProduction_Description; "Data Piecework For Production".Description)
                    {
                        //SourceExpr="Data Piecework For Production".Description;
                    }
                    Column(DataPieceworkForProduction_AmountProductionPerformed__Control2; "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountProductionBudget_AmountProductionPerformed__Control3; "Data Piecework For Production"."Amount Production Budget" - "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Budget"-"Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountProductionBudget___Control4; "Data Piecework For Production"."Amount Production Budget" - "Data Piecework For Production"."Amount Production Performed")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Production Budget"-"Data Piecework For Production"."Amount Production Performed";
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed__Control5; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(PendingCost_Control6; PendingCost)
                    {
                        //SourceExpr=PendingCost;
                    }
                    Column(TotalCost_Control8; TotalCost)
                    {
                        //SourceExpr=TotalCost;
                    }
                    Column(Difference_Control13; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_2_PieceworkCode__Control7; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(DataPieceworkForProduction____ProcessedProduction; "Data Piecework For Production"."% Processed Production")
                    {
                        //SourceExpr="Data Piecework For Production"."% Processed Production";
                    }
                    Column(MarginV_Control1100251044; MarginV)
                    {
                        //SourceExpr=MarginV;
                    }
                    Column(DataPieceworkForProduction_JobNo; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(DataPieceworkForProduction_PieceworkCode; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(DataPieceworkForProduction_Title; Title)
                    {
                        //SourceExpr=Title;

                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF Selection.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Selection."Current Piecework Budget");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        Init_;
                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        CALCFIELDS("Aver. Cost Price Pend. Budget");

                        SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        TotalCost := 0;
                        PendingCost := 0;
                        Difference := 0;

                        IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN
                            Process_("Data Piecework For Production")
                        ELSE
                            LargerProcess_("Data Piecework For Production", "Data Piecework For Production".GETFILTER("Budget Filter"));
                    END;

                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF Selection.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Selection."Current Piecework Budget");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Init_;
                    TotalsInit_;

                    SETRANGE("Posting Date Filter");
                    CALCFIELDS("Production Budget Amount");
                    SETFILTER("Posting Date Filter", '%1..%2', StartDate, EndDate);
                    CALCFIELDS("Actual Production Amount", "Warehouse Availability Amount");
                    BudgetAmount := 0;
                    RecordAmount := 0;
                    Difference := 0;
                    "Posting Date Filter" := Selection."Posting Date Filter";
                    Job.SETFILTER("Piecework Filter", '');

                    BudgetAmount := Job.ProductionBudgetWithoutProcess;
                    RecordAmount := "Actual Production Amount" - Job.ProductionTheoricalProcess;
                    Difference := BudgetAmount - RecordAmount;

                    VarTotBudgetAmount := Job.ProductionBudgetWithoutProcess;
                    VarTotRecordAmount := "Actual Production Amount" - Job.ProductionTheoricalProcess;
                END;

            }
            DataItem("Job2"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(Job2_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(TVarCostCompleted_Control127; TVarCostCompleted)
                {
                    //SourceExpr=TVarCostCompleted;
                }
                Column(TVarPendingCost_Control128; TVarPendingCost)
                {
                    //SourceExpr=TVarPendingCost;
                }
                Column(TVarTotalCost_Control131; TVarTotalCost)
                {
                    //SourceExpr=TVarTotalCost;
                }
                Column(TVarTotalCost_Control132; -TVarTotalCost)
                {
                    //SourceExpr=-TVarTotalCost;
                }
                Column(Total_General_ExpensesCaption; Total_General_ExpensesCaption)
                {
                    //SourceExpr=Total_General_ExpensesCaption;
                }
                Column(Job2_No_; "No.")
                {
                    //SourceExpr="No.";
                }
                DataItem("GestionExpenses"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Cost Unit"));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(GestionExpenses_AmountCostPerformed; GestionExpenses."Amount Cost Performed (JC)")
                    {
                        //SourceExpr=GestionExpenses."Amount Cost Performed (JC)";
                    }
                    Column(PendingCost_Control1100251029; PendingCost)
                    {
                        //SourceExpr=PendingCost;
                    }
                    Column(TotalCost_Control1100251030; TotalCost)
                    {
                        //SourceExpr=TotalCost;
                    }
                    Column(Difference_Control1100251031; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_Description; COPYSTR(Spaces, 1, Indentation * 2) + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+Description;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_PieceworkCode__Control1100251033; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(GestionExpenses_AmountCostPerformed__Control1100251010; GestionExpenses."Amount Cost Performed (JC)")
                    {
                        //SourceExpr=GestionExpenses."Amount Cost Performed (JC)";
                    }
                    Column(PendingCost_Control1100251011; PendingCost)
                    {
                        //SourceExpr=PendingCost;
                    }
                    Column(TotalCost_Control1100251012; TotalCost)
                    {
                        //SourceExpr=TotalCost;
                    }
                    Column(Difference_Control1100251020; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_Description_Control1100251034; COPYSTR(Spaces, 1, Indentation * 2) + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+Description;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_PieceworkCode__Control1100251035; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(GestionExpenses_AmountCostPerformed__Control97; GestionExpenses."Amount Cost Performed (JC)")
                    {
                        //SourceExpr=GestionExpenses."Amount Cost Performed (JC)";
                    }
                    Column(PendingCost_Control98; PendingCost)
                    {
                        //SourceExpr=PendingCost;
                    }
                    Column(TotalCost_Control106; TotalCost)
                    {
                        //SourceExpr=TotalCost;
                    }
                    Column(Difference_Control124; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(GestionExpenses_Description; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(COPYSTR_Spaces_1_Indentation_PieceworkCode__Control1100251037; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(DataPieceworkForProduction_UnitOfMeasure_; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(GestionExpenses_Job_No_; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(GestionExpenses_PieceworkCode; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code" ;
                    }
                    //D4 triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF Selection.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Selection."Current Piecework Budget");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        Init_;

                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        CALCFIELDS("Aver. Cost Price Pend. Budget");

                        SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");
                        IF GestionExpenses."Account Type" = GestionExpenses."Account Type"::Unit THEN
                            ExpenseProcess_(GestionExpenses)
                        ELSE
                            ExpenseLargeProcess_(GestionExpenses, GestionExpenses.GETFILTER("Budget Filter"));
                    END;


                }
                //D3 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF Selection.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Selection."Current Piecework Budget");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Init_;
                    TotalsInit_;

                    SETRANGE("Posting Date Filter");
                    CALCFIELDS("Production Budget Amount");
                    SETFILTER("Posting Date Filter", '%1..%2', StartDate, EndDate);
                    CALCFIELDS("Actual Production Amount", "Warehouse Availability Amount");

                    BudgetAmount := 0;
                    RecordAmount := 0;
                    Difference := 0;
                    BudgetAmount := Job.ProductionBudgetWithoutProcess;
                    RecordAmount := "Actual Production Amount" - Job.ProductionTheoricalProcess;

                    Difference := BudgetAmount - RecordAmount;

                    VarTotBudgetAmount := Job.ProductionBudgetWithoutProcess;
                    VarTotRecordAmount := "Actual Production Amount" - Job.ProductionTheoricalProcess;
                END;


            }
            //Job Triggers
            trigger OnPreDataItem();
            BEGIN
                DateT := FORMAT(GETFILTER("Posting Date Filter"));
                StartDate := GETRANGEMIN("Posting Date Filter");
                EndDate := GETRANGEMAX("Posting Date Filter");

                IF ((Selection.GETFILTER(Selection."Posting Date Filter") = '') OR (StartDate = EndDate)) THEN
                    ERROR(Text0001);

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
                PeriodFilter := Job.GETFILTER(Job."Posting Date Filter");


                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
                Spaces := '          ';
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF "Matrix Job it Belongs" <> '' THEN
                    JobText := Text0002
                ELSE
                    JobText := Text0003;
                IF JobText = Text0003 THEN
                    TotalText := Text0005
                ELSE
                    TotalText := Text0004;

                BudgetText := '';
                IF Selection.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Selection."No.", Selection.GETFILTER("Budget Filter")) THEN BEGIN
                        BudgetText := JobBudget."Cod. Budget" + ' ' + JobBudget."Budget Name"
                    END
                END
                ELSE BEGIN
                    IF JobBudget.GET(Selection."No.", Selection."Current Piecework Budget") THEN BEGIN
                        BudgetText := JobBudget."Cod. Budget" + ' ' + JobBudget."Budget Name"
                    END;
                END;

                ProductionCostTotal := 0;

                Init_;
                TotalsInit_;
                JobTotalsInit_;
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
        TotSaleExeL = 'Executed Sale Total/ Total venta ejecuta/';
        TotSalePendL = 'Pending Sale Total/ Total venta pendiente/';
        TotSaleTotL = 'Sale Total/ Total venta/';
        TGVarCostComplL = 'Completed Cost Total/ Total coste realizado/';
        TGVarPendCostL = 'Pending Cost Total/ Total coste pendiente/';
        TGVarTotalCostL = 'Total Cost/ Coste total/';
        TGVarTotalL = 'Total/ Total/';
    }

    var
        //       JobText@7001150 :
        JobText: Text[30];
        //       TotalCost@7001143 :
        TotalCost: Decimal;
        //       PendingCost@7001142 :
        PendingCost: Decimal;
        //       Difference@7001141 :
        Difference: Decimal;
        //       TotalText@7001153 :
        TotalText: Text[30];
        //       CompanyInformation@7001100 :
        CompanyInformation: Record 79;
        //       StartDate@7001147 :
        StartDate: Date;
        //       EndDate@7001146 :
        EndDate: Date;
        //       PeriodFilter@7001149 :
        PeriodFilter: Text[30];
        //       PendingAverage@7001173 :
        PendingAverage: Decimal;
        //       VarTotBudgetAmount@7001168 :
        VarTotBudgetAmount: Decimal;
        //       VarTotRecordAmount@7001167 :
        VarTotRecordAmount: Decimal;
        //       BudgetAmount@7001166 :
        BudgetAmount: Decimal;
        //       RecordAmount@7001165 :
        RecordAmount: Decimal;
        //       DateT@7001101 :
        DateT: Text[30];
        //       TotSaleExecConsolidate@7001105 :
        TotSaleExecConsolidate: Decimal;
        //       TotSaleTotConsolidate@7001104 :
        TotSaleTotConsolidate: Decimal;
        //       TotSalePendingConsolidate@7001103 :
        TotSalePendingConsolidate: Decimal;
        //       TotSaleExecInProcess@7001111 :
        TotSaleExecInProcess: Decimal;
        //       TotSaleTotInProcess@7001110 :
        TotSaleTotInProcess: Decimal;
        //       TotSalePendingInProcess@7001109 :
        TotSalePendingInProcess: Decimal;
        //       ProductionCostTotal@7001157 :
        ProductionCostTotal: Decimal;
        //       SaleInProcess@7001172 :
        SaleInProcess: Decimal;
        //       SaleProcessed@7001171 :
        SaleProcessed: Decimal;
        //       BudgetInProcess@7001170 :
        BudgetInProcess: Decimal;
        //       BudgetProcessed@7001169 :
        BudgetProcessed: Decimal;
        //       Spaces@7001144 :
        Spaces: Text[30];
        //       VarCostCompleted@7001161 :
        VarCostCompleted: Decimal;
        //       VarPendingCost@7001160 :
        VarPendingCost: Decimal;
        //       VarTotalCost@7001159 :
        VarTotalCost: Decimal;
        //       VarDifference@7001158 :
        VarDifference: Decimal;
        //       VarProdExecuted@7001164 :
        VarProdExecuted: Decimal;
        //       VarProdPending@7001163 :
        VarProdPending: Decimal;
        //       VarProdTotal@7001162 :
        VarProdTotal: Decimal;
        //       TVarCostCompleted@7001139 :
        TVarCostCompleted: Decimal;
        //       TVarPendingCost@7001138 :
        TVarPendingCost: Decimal;
        //       TVarTotalCost@7001137 :
        TVarTotalCost: Decimal;
        //       TVarProdExecuted@7001136 :
        TVarProdExecuted: Decimal;
        //       TVarProdPending@7001135 :
        TVarProdPending: Decimal;
        //       TVarProdTotal@7001134 :
        TVarProdTotal: Decimal;
        //       TGVarCostCompleted@7001108 :
        TGVarCostCompleted: Decimal;
        //       TGVarPendingCost@7001107 :
        TGVarPendingCost: Decimal;
        //       TGVarTotalCost@7001106 :
        TGVarTotalCost: Decimal;
        //       TGVarProdExecuted@7001114 :
        TGVarProdExecuted: Decimal;
        //       TGVarProdPending@7001113 :
        TGVarProdPending: Decimal;
        //       TGVarProdTotal@7001112 :
        TGVarProdTotal: Decimal;
        //       MarginV@7001115 :
        MarginV: Decimal;
        //       BudgetText@7001102 :
        BudgetText: Text[50];
        //       Text0001@7001148 :
        Text0001: TextConst ENU = 'You should have specify a date range in the "Posting Date Filter" field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Text0002@7001151 :
        Text0002: TextConst ENU = 'Record', ESP = 'Expediente';
        //       Text0003@7001152 :
        Text0003: TextConst ENU = 'Job', ESP = 'Obra';
        //       Text0004@7001154 :
        Text0004: TextConst ENU = 'Record Total', ESP = 'Total Expediente';
        //       Text0005@7001155 :
        Text0005: TextConst ENU = 'Job Total', ESP = 'Total Obra';
        //       JobResultFinalCaption@7001116 :
        JobResultFinalCaption: TextConst ENU = 'Job Result Final', ESP = 'Resultado final de obra';
        //       CurrReport_PAGENOCaption@7001117 :
        CurrReport_PAGENOCaption: TextConst ENU = 'Page', ESP = 'P g.';
        //       PieceworkCaption@7001118 :
        PieceworkCaption: TextConst ENU = 'Piecework', ESP = 'U. Obra';
        //       MeasuredUnitCaption@7001119 :
        MeasuredUnitCaption: TextConst ENU = 'Measured U.', ESP = 'U. M.';
        //       DescriptionCaption@7001120 :
        DescriptionCaption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Prod__executedCaption@7001123 :
        Prod__executedCaption: TextConst ENU = 'Executed Prod.', ESP = 'Prod. ejecutada';
        //       Prod__pendingCaption@7001122 :
        Prod__pendingCaption: TextConst ENU = 'Pending Prod.', ESP = 'Prod. pendiente';
        //       Prod__totalCaption@7001121 :
        Prod__totalCaption: TextConst ENU = 'Total Prod.', ESP = 'Prod. total';
        //       Origin_Real_ExprensesCaption@7001126 :
        Origin_Real_ExprensesCaption: TextConst ENU = 'Origin Real Expenses', ESP = 'Gtos. real orig.';
        //       Theoretical_Cost_Pending_Caption@7001125 :
        Theoretical_Cost_Pending_Caption: TextConst ENU = 'Pending theoretical cost', ESP = 'Coste te¢rico pte.';
        //       Total_Cost_EstimatedCaption@7001124 :
        Total_Cost_EstimatedCaption: TextConst ENU = 'Estimated total cost', ESP = 'Coste total estimado';
        //       ResultCaption@7001133 :
        ResultCaption: TextConst ENU = 'Result', ESP = 'Resultado';
        //       Date_FilerCaption@7001132 :
        Date_FilerCaption: TextConst ENU = 'Date Filter', ESP = 'Filtro de fecha';
        //       Production_in_processCaption@7001131 :
        Production_in_processCaption: TextConst ENU = 'Production % in process', ESP = '% prod. tr mite';
        //       MarginCaption@7001130 :
        MarginCaption: TextConst ESP = '% Margen';
        //       Total_ConsolidatedCaption@7001129 :
        Total_ConsolidatedCaption: TextConst ENU = 'Consolidated total', ESP = 'Total Consolidado';
        //       Total_in_ProcessCaption@7001128 :
        Total_in_ProcessCaption: TextConst ENU = 'Total in Process', ESP = 'Total en Tr mite';
        //       Total_Job_GrossCaption@7001127 :
        Total_Job_GrossCaption: TextConst ENU = 'Job Total Gross', ESP = 'Total Obra Bruto';
        //       Total_JobCaption@7001140 :
        Total_JobCaption: TextConst ENU = 'Job Total', ESP = 'Total Obra';
        //       Total_General_ExpensesCaption@7001145 :
        Total_General_ExpensesCaption: TextConst ESP = 'Total gastos generales';
        //       JobBudget@7001156 :
        JobBudget: Record 7207407;
        //       BudgetCaption@7001174 :
        BudgetCaption: TextConst ENU = 'Budget:', ESP = 'Presupuesto:';

    //     procedure Process_ (var DataPieceworkForProduction1@1100251000 :
    procedure Process_(var DataPieceworkForProduction1: Record 7207386)
    begin
        SaleInProcess := 0;
        SaleProcessed := 0;
        BudgetInProcess := 0;
        BudgetProcessed := 0;

        DataPieceworkForProduction1.SETRANGE("Filter Date");
        DataPieceworkForProduction1.CALCFIELDS(DataPieceworkForProduction1."Budget Measure",
                   DataPieceworkForProduction1."Amount Production Budget", DataPieceworkForProduction1."Aver. Cost Price Pend. Budget",
                   DataPieceworkForProduction1."Amount Cost Budget (JC)");
        DataPieceworkForProduction1.CALCFIELDS("Aver. Cost Price Pend. Budget");

        DataPieceworkForProduction1.SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
        DataPieceworkForProduction1.CALCFIELDS(DataPieceworkForProduction1."Amount Production Performed",
                  DataPieceworkForProduction1."Amount Cost Performed (JC)", DataPieceworkForProduction1."Total Measurement Production");

        PendingAverage := DataPieceworkForProduction1."Budget Measure" - DataPieceworkForProduction1."Total Measurement Production";

        TotalCost := DataPieceworkForProduction1."Amount Cost Performed (JC)" + PendingAverage * DataPieceworkForProduction1."Aver. Cost Price Pend. Budget";
        PendingCost := PendingAverage * DataPieceworkForProduction1."Aver. Cost Price Pend. Budget";

        //Acumulo para l¡nea de totales
        VarProdExecuted := VarProdExecuted + DataPieceworkForProduction1."Amount Production Performed";
        VarProdTotal := VarProdTotal + DataPieceworkForProduction1."Amount Production Budget";
        VarPendingCost := VarPendingCost + (VarProdTotal - VarProdExecuted);


        VarCostCompleted := VarCostCompleted + DataPieceworkForProduction1."Amount Cost Performed (JC)";
        VarPendingCost := VarPendingCost + PendingCost;
        VarTotalCost := VarCostCompleted + VarPendingCost;

        Difference := ROUND(DataPieceworkForProduction1."Amount Production Budget" * DataPieceworkForProduction1."% Processed Production" / 100, 0.01) - TotalCost;
        VarDifference := VarDifference + Difference;

        //Acumulo totales general

        TVarProdExecuted := TVarProdExecuted + VarProdExecuted;
        TVarPendingCost := TVarPendingCost + VarPendingCost;
        TVarProdTotal := TVarProdTotal + VarProdTotal;

        TVarCostCompleted := TVarCostCompleted + VarCostCompleted;
        TVarPendingCost := TVarPendingCost + VarPendingCost;
        TVarTotalCost := TVarTotalCost + VarTotalCost;

        //Acumulo general obra

        TGVarProdExecuted := TGVarProdExecuted + VarProdExecuted;
        TGVarPendingCost := TGVarPendingCost + VarPendingCost;
        TGVarProdTotal := TGVarProdTotal + VarProdTotal;

        TGVarCostCompleted := TGVarCostCompleted + VarCostCompleted;
        TGVarPendingCost := TGVarPendingCost + VarPendingCost;
        TGVarTotalCost := TGVarTotalCost + VarTotalCost;

        //Acumulo consolidados y tr mite
        SaleInProcess := ROUND(DataPieceworkForProduction1."Amount Production Performed" *
                                   (1 - (DataPieceworkForProduction1."% Processed Production" / 100)), 0.01);
        SaleProcessed := ROUND(DataPieceworkForProduction1."Amount Production Performed" *
                                   (DataPieceworkForProduction1."% Processed Production" / 100), 0.01);
        BudgetInProcess := ROUND((DataPieceworkForProduction1."Amount Production Budget" *
                                   (100 - DataPieceworkForProduction1."% Processed Production") / 100), 0.01);
        BudgetProcessed := ROUND((DataPieceworkForProduction1."Amount Production Budget" *
                                   DataPieceworkForProduction1."% Processed Production" / 100), 0.01);


        TotSaleExecConsolidate := TotSaleExecConsolidate + SaleProcessed;
        TotSalePendingConsolidate := TotSalePendingConsolidate + (BudgetProcessed - SaleProcessed);
        TotSaleTotConsolidate := TotSaleTotConsolidate + BudgetProcessed;
        TotSaleExecInProcess := TotSaleExecInProcess + SaleInProcess;
        TotSalePendingInProcess := TotSalePendingInProcess + (BudgetInProcess - SaleInProcess);
        TotSaleTotInProcess := TotSaleTotInProcess + BudgetInProcess;
    end;

    //     procedure LargerProcess_ (DataPieceworkForProduction1@1100251000 : Record 7207386;BudgetCode@1100000 :
    procedure LargerProcess_(DataPieceworkForProduction1: Record 7207386; BudgetCode: Code[20])
    var
        //       DataPieceworkForProduction2@1100251001 :
        DataPieceworkForProduction2: Record 7207386;
    begin
        DataPieceworkForProduction2.RESET;
        DataPieceworkForProduction2.COPYFILTERS(DataPieceworkForProduction1);
        DataPieceworkForProduction2.SETRANGE(DataPieceworkForProduction2."Job No.", DataPieceworkForProduction1."Job No.");
        DataPieceworkForProduction2.SETFILTER(DataPieceworkForProduction2."Piecework Code", DataPieceworkForProduction1.Totaling);
        DataPieceworkForProduction2.SETFILTER(DataPieceworkForProduction2."Account Type", '%1', DataPieceworkForProduction2."Account Type"::Unit);
        if DataPieceworkForProduction2.FINDSET then
            repeat
                DataPieceworkForProduction1 := DataPieceworkForProduction2;
                DataPieceworkForProduction1.SETRANGE("Filter Date");
                DataPieceworkForProduction1.SETRANGE("Budget Filter", BudgetCode);
                DataPieceworkForProduction1.CALCFIELDS(DataPieceworkForProduction1."Budget Measure",
                         DataPieceworkForProduction1."Amount Production Budget", DataPieceworkForProduction1."Aver. Cost Price Pend. Budget",
                         DataPieceworkForProduction1."Amount Cost Budget (JC)");
                DataPieceworkForProduction1.CALCFIELDS("Aver. Cost Price Pend. Budget");
                DataPieceworkForProduction1.SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
                DataPieceworkForProduction1.CALCFIELDS(DataPieceworkForProduction1."Amount Production Performed",
                        DataPieceworkForProduction1."Amount Cost Performed (JC)", DataPieceworkForProduction1."Total Measurement Production");

                PendingAverage := DataPieceworkForProduction1."Budget Measure" - DataPieceworkForProduction1."Total Measurement Production";
                TotalCost := TotalCost + DataPieceworkForProduction1."Amount Cost Performed (JC)" + PendingAverage * DataPieceworkForProduction1."Aver. Cost Price Pend. Budget";
                PendingCost := PendingCost + PendingAverage * DataPieceworkForProduction1."Aver. Cost Price Pend. Budget";
                Difference := Difference + ROUND(DataPieceworkForProduction1."Amount Production Budget" *
                                               DataPieceworkForProduction1."% Processed Production" / 100, 0.01);
            until DataPieceworkForProduction2.NEXT = 0;

        Difference := Difference - TotalCost;
    end;

    //     procedure ExpenseProcess_ (var DataPieceworkForProduction1@1100251000 :
    procedure ExpenseProcess_(var DataPieceworkForProduction1: Record 7207386)
    begin
        DataPieceworkForProduction1.SETRANGE("Filter Date");
        DataPieceworkForProduction1.CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
        DataPieceworkForProduction1.CALCFIELDS("Aver. Cost Price Pend. Budget");

        DataPieceworkForProduction1.SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
        DataPieceworkForProduction1.CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

        ProductionCostTotal += (GestionExpenses."% Expense Cost" * Job2.ProductionTheoricalProcess) / 100;

        if DataPieceworkForProduction1."Allocation Terms" = DataPieceworkForProduction1."Allocation Terms"::"% on Direct Costs" then
            PendingCost := (DataPieceworkForProduction1."Amount Cost Budget (JC)" - DataPieceworkForProduction1."Amount Cost Performed (JC)")
            * DataPieceworkForProduction1."% Expense Cost" / 100
        else
            if DataPieceworkForProduction1."Allocation Terms" = DataPieceworkForProduction1."Allocation Terms"::"% on Production" then
                PendingCost := (DataPieceworkForProduction1."Amount Production Budget" -
                             DataPieceworkForProduction1."Amount Production Performed") * DataPieceworkForProduction1."% Expense Cost" / 100
            else
                PendingCost := DataPieceworkForProduction1."Amount Cost Budget (JC)" - DataPieceworkForProduction1."Amount Cost Performed (JC)";


        TotalCost := DataPieceworkForProduction1."Amount Cost Performed (JC)" + PendingCost;

        Difference := -TotalCost;

        //Acumulo para totales de unidades de coste
        VarCostCompleted := DataPieceworkForProduction1."Amount Cost Performed (JC)";
        TVarCostCompleted := TVarCostCompleted + VarCostCompleted;
        TVarPendingCost := TVarPendingCost + PendingCost;
        TVarTotalCost := TVarTotalCost + TotalCost;

        //Acumulo general obra
        TGVarCostCompleted := TGVarCostCompleted + VarCostCompleted;
        TGVarPendingCost := TGVarPendingCost + PendingCost;
        TGVarTotalCost := TGVarTotalCost + TotalCost;
    end;

    //     procedure ExpenseLargeProcess_ (DataPieceworkForProduction1@1100251000 : Record 7207386;BudgetCode@1100000 :
    procedure ExpenseLargeProcess_(DataPieceworkForProduction1: Record 7207386; BudgetCode: Code[20])
    var
        //       DataPieceworkForProduction2@1100251001 :
        DataPieceworkForProduction2: Record 7207386;
        //       VarCompleted@1100251002 :
        VarCompleted: Decimal;
    begin
        PendingCost := 0;

        DataPieceworkForProduction2.RESET;
        DataPieceworkForProduction2.COPYFILTERS(DataPieceworkForProduction1);
        DataPieceworkForProduction2.SETRANGE(DataPieceworkForProduction2."Job No.", DataPieceworkForProduction1."Job No.");
        DataPieceworkForProduction2.SETFILTER(DataPieceworkForProduction2."Piecework Code", DataPieceworkForProduction1.Totaling);
        DataPieceworkForProduction2.SETFILTER(DataPieceworkForProduction2."Account Type", '%1', DataPieceworkForProduction2."Account Type"::Unit);
        if DataPieceworkForProduction2.FINDSET then
            repeat
                DataPieceworkForProduction1 := DataPieceworkForProduction2;
                DataPieceworkForProduction1.SETRANGE("Filter Date");
                DataPieceworkForProduction1.SETRANGE("Budget Filter", BudgetCode);

                DataPieceworkForProduction1.CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                DataPieceworkForProduction1.CALCFIELDS("Aver. Cost Price Pend. Budget");

                DataPieceworkForProduction1.SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
                DataPieceworkForProduction1.CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");


                if DataPieceworkForProduction1."Allocation Terms" = DataPieceworkForProduction1."Allocation Terms"::"% on Direct Costs" then
                    PendingCost := PendingCost +
                       (DataPieceworkForProduction1."Amount Cost Budget (JC)" - DataPieceworkForProduction1."Amount Cost Performed (JC)") *
                        DataPieceworkForProduction1."% Expense Cost" / 100
                else
                    if DataPieceworkForProduction1."Allocation Terms" = DataPieceworkForProduction1."Allocation Terms"::"% on Production" then
                        PendingCost := PendingCost + (DataPieceworkForProduction1."Amount Production Budget" -
                                     DataPieceworkForProduction1."Amount Production Performed") * DataPieceworkForProduction1."% Expense Cost" / 100
                    else
                        PendingCost := PendingCost + DataPieceworkForProduction1."Amount Cost Budget (JC)" - DataPieceworkForProduction1."Amount Cost Performed (JC)";

                VarCompleted := VarCompleted + DataPieceworkForProduction1."Amount Cost Performed (JC)";

            //Difference := Difference -TotalCost;
            until DataPieceworkForProduction2.NEXT = 0;

        TotalCost := PendingCost + VarCompleted;
        Difference := -TotalCost;
    end;

    procedure Init_()
    begin
        VarCostCompleted := 0;
        VarPendingCost := 0;
        VarTotalCost := 0;
        VarDifference := 0;

        VarProdExecuted := 0;
        VarProdTotal := 0;
        VarProdPending := 0;
    end;

    procedure TotalsInit_()
    begin
        TVarCostCompleted := 0;
        TVarPendingCost := 0;
        TVarTotalCost := 0;

        TVarProdExecuted := 0;
        TVarProdTotal := 0;
        TVarProdPending := 0;
    end;

    procedure JobTotalsInit_()
    begin
        TGVarCostCompleted := 0;
        TGVarPendingCost := 0;
        TGVarTotalCost := 0;

        TGVarProdExecuted := 0;
        TGVarProdTotal := 0;
        TGVarProdPending := 0;

        TotSaleExecConsolidate := 0;
        TotSaleTotConsolidate := 0;
        TotSalePendingConsolidate := 0;

        TotSaleTotInProcess := 0;
        TotSalePendingInProcess := 0;
        TotSaleExecInProcess := 0;
    end;

    /*begin
    end.
  */

}



