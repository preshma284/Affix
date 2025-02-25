report 7207375 "Theoretical Cost Vs Actual Cos"
{


    CaptionML = ENU = 'Theoretical Cost Vs Actual Cost', ESP = 'Coste Te¢rico versus Coste real';

    dataset
    {

        DataItem("Job1"; "Job")
        {

            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterHeadingML = ESP = 'Obra';


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
            Column(FORMAT_Job1__No______Job1_Description; FORMAT(Job1."No.") + '  ' + Job1.Description)
            {
                //SourceExpr=FORMAT(Job1."No.") + '  ' +Job1.Description;
            }
            Column(Job1_Description2; Job1."Description 2")
            {
                //SourceExpr=Job1."Description 2";
            }
            Column(JobText____; JobText + ':')
            {
                //SourceExpr=JobText+':';
            }
            Column(CompanyInformation1_Picture; CompanyInformation1.Picture)
            {
                //SourceExpr=CompanyInformation1.Picture;
            }
            Column(Period___; Period + ':')
            {
                //SourceExpr=Period +  ':';
            }
            Column(FilterPeriod; FilterPeriod)
            {
                //SourceExpr=FilterPeriod;
            }
            Column(BudgetNo; BudgetNo)
            {
                //SourceExpr=BudgetNo;
            }
            Column(BudgetText; BudgetText)
            {
                //SourceExpr=BudgetText;
            }
            Column(CurrentExpensePeriod_CurrentExpense; CurrentExpensePeriod + CurrentExpense)
            {
                //SourceExpr=CurrentExpensePeriod+CurrentExpense;
            }
            Column(TheoricalExpensePeriod_TheoricalExpense; TheoricalExpensePeriod + TheoricalExpense)
            {
                //SourceExpr=TheoricalExpensePeriod+TheoricalExpense;
            }
            Column(DevPeriod2_DevPeriod1; DevPeriod2 + DevPeriod1)
            {
                //SourceExpr=DevPeriod2+DevPeriod1;
            }
            Column(AccumDev2_AccumDev1; AccumDev2 + AccumDev1)
            {
                //SourceExpr=AccumDev2+AccumDev1;
            }
            Column(AccumulatedTheoricalExp2_AccumulatedTheoricalExp1; AccumulatedTheoricalExp2 + AccumulatedTheoricalExp1)
            {
                //SourceExpr=AccumulatedTheoricalExp2+AccumulatedTheoricalExp1;
            }
            Column(CurrentAccumExpense2_CurrentAccumExpense1; CurrentAccumExpense2 + CurrentAccumExpense1)
            {
                //SourceExpr=CurrentAccumExpense2+CurrentAccumExpense1;
            }
            Column(Theorist_Cost_Vrs_Current_CostCaption; Theorist_Cost_Vrs_Current_CostCaption)
            {
                //SourceExpr=Theorist_Cost_Vrs_Current_CostCaption;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
                //SourceExpr=CurrReport_PAGENOCaption;
            }
            Column(PieceworkCaption; PieceworkCaption)
            {
                //SourceExpr=PieceworkCaption;
            }
            Column(U__mea_Caption; U__mea_Caption)
            {
                //SourceExpr=U__mea_Caption;
            }
            Column(DescriptionCaption; DescriptionCaption)
            {
                //SourceExpr=DescriptionCaption;
            }
            Column(Accumulated_theo_expenseCaption; Accumulated_theo_expenseCaption)
            {
                //SourceExpr=Accumulated_theo_expenseCaption;
            }
            Column(Current_Expense_monthCaption; Current_Expense_monthCaption)
            {
                //SourceExpr=Current_Expense_monthCaption;
            }
            Column(Theorist_Expense_MonthCaption; Theorist_Expense_MonthCaption)
            {
                //SourceExpr=Theorist_Expense_MonthCaption;
            }
            Column(Deviation_MonthCaption; Deviation_MonthCaption)
            {
                //SourceExpr=Deviation_MonthCaption;
            }
            Column(Devi_from_update_Caption; Devi_from_update_Caption)
            {
                //SourceExpr=Devi_from_update_Caption;
            }
            Column(Processed_ProductionCaption; Processed_ProductionCaption)
            {
                //SourceExpr=Processed_ProductionCaption;
            }
            Column(Current_Theorisst_ExpenseCaption; Current_Theorisst_ExpenseCaption)
            {
                //SourceExpr=Current_Theorisst_ExpenseCaption;
            }
            Column(Total_Consolidate_JobCaption; Total_Consolidate_JobCaption)
            {
                //SourceExpr=Total_Consolidate_JobCaption;
            }
            Column(Budget_caption; Budget_caption + ':')
            {
                //SourceExpr=Budget_caption +  ':';
            }
            Column(Job1_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(AccumDev1_Control1100251023; AccumDev1)
            {
                //SourceExpr=AccumDev1;
            }
            Column(TheoricalExpense_Control22; TheoricalExpense)
            {
                //SourceExpr=TheoricalExpense;
            }
            DataItem("2000000026"; "2000000026")
            {

                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                PrintOnlyIfDetail = true;
                ;
                Column(AccumDev1; AccumDev1)
                {
                    //SourceExpr=AccumDev1;
                }
                Column(DevPeriod1; DevPeriod1)
                {
                    //SourceExpr=DevPeriod1;
                }
                Column(TheoricalExpense; TheoricalExpense)
                {
                    //SourceExpr=TheoricalExpense;
                }
                Column(TotalText; TotalText)
                {
                    //SourceExpr=TotalText;
                }
                Column(Job1_Description; Job1.Description)
                {
                    //SourceExpr=Job1.Description;
                }
                Column(CurrentExpense; CurrentExpense)
                {
                    //SourceExpr=CurrentExpense;
                }
                Column(AccumulatedTheoricalExp1; AccumulatedTheoricalExp1)
                {
                    //SourceExpr=AccumulatedTheoricalExp1;
                }
                Column(CurrentAccumExpense1; CurrentAccumExpense1)
                {
                    //SourceExpr=CurrentAccumExpense1;
                }
                Column(Integer_Number; Number)
                {
                    //SourceExpr=Number;
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Title", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Piecework"), "Production Unit" = CONST(true));


                    DataItemLinkReference = "Job1";
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(FORMAT_Title__________NameTitle; FORMAT(Title) + '  ' + NameTitle)
                    {
                        //SourceExpr=FORMAT(Title) + '  ' + NameTitle;
                    }
                    Column(Piecework; Piecework)
                    {
                        //SourceExpr=Piecework;
                    }
                    Column(Data_Piecework_For_Production__Unit_Of_Measure; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(Data_Piecework_For_Production___Description; "Data Piecework For Production".Description)
                    {
                        //SourceExpr="Data Piecework For Production".Description;
                    }
                    Column(AccumDev1_Control20; AccumDev1)
                    {
                        //SourceExpr=AccumDev1;
                    }
                    Column(DevPeriod1_Control21; DevPeriod1)
                    {
                        //SourceExpr=DevPeriod1;
                    }
                    Column(CurrentExpense_Control23; CurrentExpense)
                    {
                        //SourceExpr=CurrentExpense;
                    }
                    Column(AccumulatedTheoricalExp1_Control36; AccumulatedTheoricalExp1)
                    {
                        //SourceExpr=AccumulatedTheoricalExp1;
                    }
                    Column(Data_Piecework_For_Production______Processed_Production; "Data Piecework For Production"."% Processed Production")
                    {
                        //SourceExpr="Data Piecework For Production"."% Processed Production";
                    }
                    Column(CurrentAccumExpense1_Control1100251001; CurrentAccumExpense1)
                    {
                        //SourceExpr=CurrentAccumExpense1;
                    }
                    Column(CurrentExpense_Control8; CurrentExpense)
                    {
                        //SourceExpr=CurrentExpense;
                    }
                    Column(TheoricalExpense_Control9; TheoricalExpense)
                    {
                        //SourceExpr=TheoricalExpense;
                    }
                    Column(DevPeriod1_Control10; DevPeriod1)
                    {
                        //SourceExpr=DevPeriod1;
                    }
                    Column(AccumDev1_Control11; AccumDev1)
                    {
                        //SourceExpr=AccumDev1;
                    }
                    Column(FORMAT_Title______NameTitle_Control12; FORMAT(Title) + '  ' + NameTitle)
                    {
                        //SourceExpr=FORMAT(Title) + '  ' + NameTitle;
                    }
                    Column(CurrentAccumExpense1_Control1100251002; CurrentAccumExpense1)
                    {
                        //SourceExpr=CurrentAccumExpense1;
                    }
                    Column(AccumulatedTheoricalExp1_Control1100251003; AccumulatedTheoricalExp1)
                    {
                        //SourceExpr=AccumulatedTheoricalExp1;
                    }
                    Column(ChapterCaption; ChapterCaption)
                    {
                        //SourceExpr=ChapterCaption;
                    }
                    Column(Total_chapterCaption; Total_chapterCaption)
                    {
                        //SourceExpr=Total_chapterCaption;
                    }
                    Column(Data_Piecework_For_Production__Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Data_Piecework_For_Production__Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(Data_Piecework_For_Production__Title; Title)
                    {
                        //SourceExpr=Title;
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF Job1.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Job1.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Job1."Current Piecework Budget");

                        CurrReport.CREATETOTALS("Amount Production Performed", CurrentExpense, TheoricalExpense, DevPeriod1, AccumDev1,
                                                 CurrentAccumExpense1, AccumulatedTheoricalExp1);

                        IF "Data Piecework For Production"."% Processed Production" = 100 THEN
                            CurrReport.SHOWOUTPUT(NOT ((PeriodMea = 0) AND (CurrentExpense = 0) AND (TheoricalExpense = 0) AND
                                                      (DevPeriod1 = 0) AND (AccumDev1 = 0)));
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Filter Date");
                        PriceMediumCost := "Data Piecework For Production".CostPrice;
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        SETFILTER("Filter Date", '%1..%2', StartDate, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production",
                                   "Amount Cost Budget (JC)");

                        PeriodMea := 0;
                        CurrentExpense := 0;
                        TheoricalExpense := 0;
                        DevPeriod1 := 0;
                        AccumDev1 := 0;

                        PeriodMea := "Total Measurement Production";
                        CurrentExpense := "Amount Cost Performed (JC)";
                        TheoricalExpense := "Total Measurement Production" * PriceMediumCost;

                        DevPeriod1 := TheoricalExpense - CurrentExpense;

                        IF DataPieceworkForProduction1.GET("Job No.", "Piecework Code") THEN BEGIN
                            DataPieceworkForProduction1.SETFILTER(DataPieceworkForProduction1."Filter Date", '..%1', EndDate);
                            IF Job1.GETFILTER("Budget Filter") <> '' THEN
                                DataPieceworkForProduction1.SETFILTER("Budget Filter", Job1.GETFILTER("Budget Filter"));
                            DataPieceworkForProduction1.CALCFIELDS("Total Measurement Production", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)",
                                                  "Amount Cost Budget (JC)");
                            AccumulatedTheoricalExp1 := DataPieceworkForProduction1."Total Measurement Production" * PriceMediumCost;
                            CurrentAccumExpense1 := DataPieceworkForProduction1."Amount Cost Performed (JC)";
                            AccumDev1 := AccumulatedTheoricalExp1 - CurrentAccumExpense1;
                        END;

                        Piecework := COPYSTR("Piecework Code", STRLEN(Title) + 1);
                        NameTitle := '';
                        IF DataPieceworkForProduction3.GET(Job1."No.", Title) THEN
                            NameTitle := DataPieceworkForProduction3.Description;

                        SaleInProcess := ROUND("Amount Production Performed" *
                                                   (1 - ("% Processed Production" / 100)), 0.01);
                        SaleProcessed := ROUND("Amount Production Performed" *
                                                   ("% Processed Production" / 100), 0.01);
                        BudgetInProcess := ROUND(("Amount Production Budget" *
                                                   (100 - "% Processed Production") / 100), 0.01);
                        BudgetProcessed := ROUND(("Amount Production Budget" *
                                                   "% Processed Production" / 100), 0.01);

                        ProductionExpenseInProcess := SaleInProcess;
                        TotalInProgress := TotalInProgress + SaleInProcess;
                        TotalConsolidated := TotalConsolidated + SaleProcessed;
                    END;

                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Production Performed");

                    CurrentExpensePeriod := CurrentExpense;
                    TheoricalExpensePeriod := TheoricalExpense;
                    CurrentAccumExpense2 := CurrentAccumExpense1;
                    AccumulatedTheoricalExp2 := AccumulatedTheoricalExp1;
                    DevPeriod2 := DevPeriod1;
                    AccumDev2 := AccumDev1;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Total := 0;
                    TotalConsolidated := 0;
                    TotalInProgress := 0;
                END;
            }
            DataItem("Job2"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(FORMAT_Job2__No_________Description; FORMAT(Job2."No.") + '  ' + Description)
                {
                    //SourceExpr=FORMAT(Job2."No.") + '  ' +Description;
                }
                Column(Job2_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(AccumulatedTheoricalExp1_Control1100251024; AccumulatedTheoricalExp1)
                {
                    //SourceExpr=AccumulatedTheoricalExp1;
                }
                Column(CurrentAccumExpense1_Control1100251025; CurrentAccumExpense1)
                {
                    //SourceExpr=CurrentAccumExpense1;
                }
                Column(CurrentExpense_Control1100251026; CurrentExpense)
                {
                    //SourceExpr=CurrentExpense;
                }
                Column(TheoricalExpense_Control1100251027; TheoricalExpense)
                {
                    //SourceExpr=TheoricalExpense;
                }
                Column(DevPeriod1_Control1100251028; DevPeriod1)
                {
                    //SourceExpr=DevPeriod1;
                }
                Column(AccumDev1m_Control1100251029; AccumDev1)
                {
                    //SourceExpr=AccumDev1;
                }
                Column(Management_ExpenseCaption; Management_ExpenseCaption)
                {
                    //SourceExpr=Management_ExpenseCaption;
                }
                Column(Total_Management_ExpenseCaption; Total_Management_ExpenseCaption)
                {
                    //SourceExpr=Total_Management_ExpenseCaption;
                }
                Column(Job2_No_; "No.")
                {
                    //SourceExpr="No.";
                }
                DataItem("Management Expense"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Cost Unit"));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(AccumDev1_Control1100251006; AccumDev1)
                    {
                        //SourceExpr=AccumDev1;
                    }
                    Column(DevPeriod1_Control1100251007; DevPeriod1)
                    {
                        //SourceExpr=DevPeriod1;
                    }
                    Column(TheoricalExpense_Control1100251008; TheoricalExpense)
                    {
                        //SourceExpr=TheoricalExpense;
                    }
                    Column(CurrentExpense_Control1100251009; CurrentExpense)
                    {
                        //SourceExpr=CurrentExpense;
                    }
                    Column(CurrentAccumExpense1_Control1100251010; CurrentAccumExpense1)
                    {
                        //SourceExpr=CurrentAccumExpense1;
                    }
                    Column(AccumulatedTheoricalExp1_Control1100251011; AccumulatedTheoricalExp1)
                    {
                        //SourceExpr=AccumulatedTheoricalExp1;
                    }
                    Column(Management_Expense_Description; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(Management_Expense__Unit_Of_Measure; "Unit Of Measure")
                    {
                        //SourceExpr="Unit Of Measure";
                    }
                    Column(Piecework_Control60; Piecework)
                    {
                        //SourceExpr=Piecework;
                    }
                    Column(Management_Expense____Processed_Production; "% Processed Production")
                    {
                        //SourceExpr="% Processed Production";
                    }
                    Column(AccumulatedTheoricalExp1_Control1100251012; AccumulatedTheoricalExp1)
                    {
                        //SourceExpr=AccumulatedTheoricalExp1;
                    }
                    Column(CurrentAccumExpense1_Control1100251013; CurrentAccumExpense1)
                    {
                        //SourceExpr=CurrentAccumExpense1;
                    }
                    Column(CurrentExpense_Control1100251014; CurrentExpense)
                    {
                        //SourceExpr=CurrentExpense;
                    }
                    Column(TheoricalExpense_Control1100251015; TheoricalExpense)
                    {
                        //SourceExpr=TheoricalExpense;
                    }
                    Column(DevPeriod1_Control1100251016; DevPeriod1)
                    {
                        //SourceExpr=DevPeriod1;
                    }
                    Column(AccumDev1_Control1100251017; AccumDev1)
                    {
                        //SourceExpr=AccumDev1;
                    }
                    Column(AccumulatedTheoricalExp1_Control1100251018; AccumulatedTheoricalExp1)
                    {
                        //SourceExpr=AccumulatedTheoricalExp1;
                    }
                    Column(CurrentAccumExpense1_Control1100251019; CurrentAccumExpense1)
                    {
                        //SourceExpr=CurrentAccumExpense1;
                    }
                    Column(CurrentExpense_Control1100251020; CurrentExpense)
                    {
                        //SourceExpr=CurrentExpense;
                    }
                    Column(TheoricalExpense_Control1100251021; TheoricalExpense)
                    {
                        //SourceExpr=TheoricalExpense;
                    }
                    Column(DevPeriod1_Control1100251022; DevPeriod1)
                    {
                        //SourceExpr=DevPeriod1;
                    }
                    Column(SumCaption; SumCaption)
                    {
                        //SourceExpr=SumCaption;
                    }
                    Column(SumCaption_Control83; SumCaption_Control83)
                    {
                        //SourceExpr=SumCaption_Control83;
                    }
                    Column(Management_Expense_Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Management_Expense_Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(Management_Expense_Title; Title)
                    {
                        //SourceExpr=Title ;
                    }
                    //D4 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF Job1.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Job1.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Job1."Current Piecework Budget");

                        CurrReport.CREATETOTALS(PeriodMea, CurrentExpense, TheoricalExpense, DevPeriod1, AccumDev1);
                        CurrReport.CREATETOTALS(Sum);

                        IF ByChapter THEN
                            CurrReport.SHOWOUTPUT(FALSE);

                        CurrReport.SHOWOUTPUT(NOT ((PeriodMea = 0) AND (CurrentExpense = 0) AND (TheoricalExpense = 0) AND
                                                 (DevPeriod1 = 0) AND (AccumDev1 = 0)));
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        SETFILTER("Filter Date", '%1..%2', StartDate, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production",
                                    "Amount Cost Budget (JC)");

                        PeriodMea := 0;
                        CurrentExpense := 0;
                        TheoricalExpense := 0;
                        DevPeriod1 := 0;
                        AccumDev1 := 0;

                        CurrentAccumExpense1 := 0;
                        AccumulatedTheoricalExp1 := 0;

                        PeriodMea := "Total Measurement Production";
                        CurrentExpense := ("Amount Cost Performed (JC)");

                        TheoricalExpense := "Amount Cost Budget (JC)";

                        DevPeriod1 := TheoricalExpense - CurrentExpense;

                        IF DataPieceworkForProduction1.GET("Job No.", "Piecework Code") THEN BEGIN
                            IF Job2.GETFILTER("Budget Filter") <> '' THEN
                                DataPieceworkForProduction1.SETFILTER("Budget Filter", Job2.GETFILTER("Budget Filter"));
                            DataPieceworkForProduction1.SETFILTER(DataPieceworkForProduction1."Filter Date", '%1..%2', JobBudget."Budget Date", EndDate);

                            DataPieceworkForProduction1.CALCFIELDS("Total Measurement Production", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)",
                                                 "Amount Cost Budget (JC)");
                            CurrentAccumExpense1 := DataPieceworkForProduction1."Amount Cost Performed (JC)";

                            AccumulatedTheoricalExp1 := DataPieceworkForProduction1."Amount Cost Budget (JC)";
                            Sum := CurrentExpense;
                            AccumDev1 := AccumulatedTheoricalExp1 - CurrentAccumExpense1;
                        END;

                        Piecework := COPYSTR("Piecework Code", STRLEN(Title) + 1);

                        SaleInProcess := ROUND("Amount Production Performed" *
                                                   (1 - ("% Processed Production" / 100)), 0.01);
                        SaleProcessed := ROUND("Amount Production Performed" *
                                                   ("% Processed Production" / 100), 0.01);
                        BudgetInProcess := ROUND(("Amount Production Budget" *
                                                   (100 - "% Processed Production") / 100), 0.01);
                        BudgetProcessed := ROUND(("Amount Production Budget" *
                                                   "% Processed Production" / 100), 0.01);

                        ProductionExpenseInProcess := SaleInProcess;
                    END;


                }
                //D3 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF Job1.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Job1.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Job1."Current Piecework Budget");

                    CurrReport.SHOWOUTPUT(NOT ByTitle);
                    IF ByChapter THEN
                        CurrReport.SHOWOUTPUT(FALSE);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    FOR i := 1 TO 9 DO
                        Expense1[i] := TRUE;

                    DataPieceworkForProduction2.SETRANGE("Job No.", "No.");
                    DataPieceworkForProduction2.SETRANGE("Subtype Cost", "Management Expense"."Subtype Cost"::"Deprec. Anticipated");
                    IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                        Expense1[1] := FALSE;
                    DataPieceworkForProduction2.RESET;

                    DataPieceworkForProduction2.SETRANGE("Job No.", "No.");
                    DataPieceworkForProduction2.SETRANGE("Subtype Cost", "Management Expense"."Subtype Cost"::"Current Expenses");
                    IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                        Expense1[2] := FALSE;
                    DataPieceworkForProduction2.RESET;

                    Expense1[3] := FALSE;

                    DataPieceworkForProduction2.SETRANGE("Job No.", "No.");
                    DataPieceworkForProduction2.SETRANGE("Subtype Cost", "Management Expense"."Subtype Cost"::"Deprec. Deferred");
                    IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                        Expense1[4] := FALSE;
                    DataPieceworkForProduction2.RESET;

                    DataPieceworkForProduction2.SETRANGE("Job No.", "No.");
                    DataPieceworkForProduction2.SETRANGE("Subtype Cost", "Management Expense"."Subtype Cost"::"Deprec. Inmovilized");
                    IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                        Expense1[5] := FALSE;
                    DataPieceworkForProduction2.RESET;

                    Expense1[6] := FALSE;
                    Expense1[7] := FALSE;

                    DataPieceworkForProduction2.SETRANGE("Job No.", "No.");
                    DataPieceworkForProduction2.SETRANGE("Subtype Cost", "Management Expense"."Subtype Cost"::"Financial Charges");
                    IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                        Expense1[8] := FALSE;
                    DataPieceworkForProduction2.RESET;

                    DataPieceworkForProduction2.SETRANGE("Job No.", "No.");
                    DataPieceworkForProduction2.SETRANGE("Subtype Cost", "Management Expense"."Subtype Cost"::Others);
                    IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                        Expense1[9] := FALSE;
                    DataPieceworkForProduction2.RESET;
                END;


            }
            //Job1 Triggers    
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation1.GET;
                StartDate := GETRANGEMIN("Posting Date Filter");
                EndDate := GETRANGEMAX("Posting Date Filter");

                IF ((Job1.GETFILTER(Job1."Posting Date Filter") = '') OR (StartDate = EndDate)) THEN
                    ERROR(Text0001);

                CompanyInformation1.GET;
                CompanyInformation1.CALCFIELDS(CompanyInformation1.Picture);
                FilterPeriod := Job1.GETFILTER(Job1."Posting Date Filter");
                CurrReport.CREATETOTALS(PeriodMea, CurrentExpense, TheoricalExpense, DevPeriod1, AccumDev1);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                BudgetText := '';
                IF Job1.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Job1."No.", Job1.GETFILTER("Budget Filter")) THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        BudgetNo := JobBudget."Cod. Budget";
                    END
                END
                ELSE BEGIN
                    IF JobBudget.GET(Job1."No.", Job1."Current Piecework Budget") THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        BudgetNo := JobBudget."Cod. Budget";
                    END;
                END;

                Job1.SETRANGE("Posting Date Filter");
                CALCFIELDS("Production Budget Amount", "Actual Production Amount");
                Job1.SETRANGE("Posting Date Filter", StartDate, EndDate);
                CALCFIELDS("Actual Production Amount");

                IF Job1."Matrix Job it Belongs" <> '' THEN
                    JobText := Text0002
                ELSE
                    JobText := Text0003;
                IF JobText = Text0003 THEN
                    TotalText := Text0004
                ELSE
                    TotalText := Text0005;
                CurrentDate := "Reestimation Last Date";

                BudgetAmount := 0;
                RecordAmount := 0;
                BudgetAmount := Job1.ProductionBudgetWithoutProcess;
                RecordAmount := "Actual Production Amount" - Job1.ProductionTheoricalProcess;
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
        //       Text0001@7001119 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Theorist_Cost_Vrs_Current_CostCaption@7001118 :
        Theorist_Cost_Vrs_Current_CostCaption: TextConst ENU = 'Theorist Cost Vrs Current Cost', ESP = 'Coste Te¢rico Vrs. Coste real';
        //       CurrReport_PAGENOCaption@7001117 :
        CurrReport_PAGENOCaption: TextConst ENU = 'Page', ESP = 'P g.';
        //       PieceworkCaption@7001116 :
        PieceworkCaption: TextConst ENU = 'Piecework', ESP = 'Unidad obra';
        //       U__mea_Caption@7001115 :
        U__mea_Caption: TextConst ENU = 'U. Mea.', ESP = 'U. M.';
        //       DescriptionCaption@7001114 :
        DescriptionCaption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Accumulated_theo_expenseCaption@7001113 :
        Accumulated_theo_expenseCaption: TextConst ENU = 'Accumulated Theorist Expense', ESP = 'Gto Tco acumulado';
        //       Current_Expense_monthCaption@7001112 :
        Current_Expense_monthCaption: TextConst ENU = 'Current Expense Month', ESP = 'Gto real mes';
        //       Theorist_Expense_MonthCaption@7001111 :
        Theorist_Expense_MonthCaption: TextConst ENU = 'Theorist Expense Month', ESP = 'Gto Tco mes';
        //       Deviation_MonthCaption@7001110 :
        Deviation_MonthCaption: TextConst ENU = 'Deviation Month', ESP = 'Desviaci¢n mes';
        //       Devi_from_update_Caption@7001109 :
        Devi_from_update_Caption: TextConst ENU = 'Devi. From Update', ESP = 'Desv. dsd actualiz.';
        //       Processed_ProductionCaption@7001108 :
        Processed_ProductionCaption: TextConst ENU = '% Processed Production', ESP = '% Produc.';
        //       Current_Theorisst_ExpenseCaption@7001107 :
        Current_Theorisst_ExpenseCaption: TextConst ENU = 'Current Theorisst Expense', ESP = 'Gto Tco Real';
        //       Total_Consolidate_JobCaption@7001106 :
        Total_Consolidate_JobCaption: TextConst ENU = 'Total Consolidate Job', ESP = 'Total Obra Consolidado';
        //       ChapterCaption@7001105 :
        ChapterCaption: TextConst ENU = 'Chapter', ESP = 'Cap¡tulo';
        //       Total_chapterCaption@7001104 :
        Total_chapterCaption: TextConst ENU = 'Total Job', ESP = 'Total obra';
        //       Management_ExpenseCaption@7001103 :
        Management_ExpenseCaption: TextConst ENU = 'Management Expense', ESP = 'Gastos gestion';
        //       Total_Management_ExpenseCaption@7001102 :
        Total_Management_ExpenseCaption: TextConst ENU = 'Total Management Expense', ESP = 'Total Gastos de gesti¢n';
        //       SumCaption@7001101 :
        SumCaption: TextConst ENU = 'Sum', ESP = 'Suma';
        //       SumCaption_Control83@7001100 :
        SumCaption_Control83: TextConst ENU = 'Sum', ESP = 'Suma';
        //       CurrentExpense@7001172 :
        CurrentExpense: Decimal;
        //       TheoricalExpense@7001171 :
        TheoricalExpense: Decimal;
        //       DevPeriod1@7001170 :
        DevPeriod1: Decimal;
        //       AccumDev1@7001169 :
        AccumDev1: Decimal;
        //       StartDate@7001168 :
        StartDate: Date;
        //       EndDate@7001167 :
        EndDate: Date;
        //       CurrentDate@7001166 :
        CurrentDate: Date;
        //       DataPieceworkForProduction1@7001165 :
        DataPieceworkForProduction1: Record 7207386;
        //       CurrentAccumExpense1@7001164 :
        CurrentAccumExpense1: Decimal;
        //       AccumulatedTheoricalExp1@7001163 :
        AccumulatedTheoricalExp1: Decimal;
        //       CompanyInformation1@7001162 :
        CompanyInformation1: Record 79;
        //       JobText@7001161 :
        JobText: Text[30];
        //       TotalText@7001160 :
        TotalText: Text[30];
        //       FilterPeriod@7001159 :
        FilterPeriod: Text[30];
        //       ForecastDataAmountPiecework@7001158 :
        ForecastDataAmountPiecework: Record 7207392;
        //       BudgetAmount@7001157 :
        BudgetAmount: Decimal;
        //       RecordAmount@7001156 :
        RecordAmount: Decimal;
        //       Piecework@7001155 :
        Piecework: Code[20];
        //       Resource@7001154 :
        Resource: Record 156;
        //       TotalCostAmount@7001153 :
        TotalCostAmount: Decimal;
        //       Difference@7001152 :
        Difference: Decimal;
        //       ByTitle@7001151 :
        ByTitle: Boolean;
        //       ByChapter@7001150 :
        ByChapter: Boolean;
        //       TotalMea@7001149 :
        TotalMea: Decimal;
        //       Total@7001148 :
        Total: Decimal;
        //       PeriodMea@7001147 :
        PeriodMea: Decimal;
        //       NumberRecords@7001146 :
        NumberRecords: Integer;
        //       Sum@7001145 :
        Sum: Decimal;
        //       DataPieceworkForProduction2@7001144 :
        DataPieceworkForProduction2: Record 7207386;
        //       Print@7001143 :
        Print: Boolean;
        //       Expense1@7001142 :
        Expense1: ARRAY[9] OF Boolean;
        //       i@7001141 :
        i: Integer;
        //       Expense2@7001140 :
        Expense2: Text[30];
        //       CurrentExpensePeriod@7001139 :
        CurrentExpensePeriod: Decimal;
        //       TheoricalExpensePeriod@7001138 :
        TheoricalExpensePeriod: Decimal;
        //       CurrentAccumExpense2@7001137 :
        CurrentAccumExpense2: Decimal;
        //       AccumulatedTheoricalExp2@7001136 :
        AccumulatedTheoricalExp2: Decimal;
        //       DevPeriod2@7001135 :
        DevPeriod2: Decimal;
        //       AccumDev2@7001134 :
        AccumDev2: Decimal;
        //       NameTitle@7001133 :
        NameTitle: Text[35];
        //       DataPieceworkForProduction3@7001132 :
        DataPieceworkForProduction3: Record 7207386;
        //       AmountTheoricalExpenseConsolidated@7001131 :
        AmountTheoricalExpenseConsolidated: Decimal;
        //       ProductionExpenseInProcess@7001130 :
        ProductionExpenseInProcess: Decimal;
        //       TotalConsolidated@7001129 :
        TotalConsolidated: Decimal;
        //       TotalInProgress@7001128 :
        TotalInProgress: Decimal;
        //       CompanyInformation2@7001127 :
        CompanyInformation2: Record 79;
        //       SaleInProcess@7001126 :
        SaleInProcess: Decimal;
        //       SaleProcessed@7001125 :
        SaleProcessed: Decimal;
        //       BudgetProcessed@7001124 :
        BudgetProcessed: Decimal;
        //       BudgetInProcess@7001123 :
        BudgetInProcess: Decimal;
        //       PriceMediumCost@7001122 :
        PriceMediumCost: Decimal;
        //       BudgetText@7001121 :
        BudgetText: Text[50];
        //       JobBudget@7001120 :
        JobBudget: Record 7207407;
        //       Text0002@7001173 :
        Text0002: TextConst ENU = 'Record', ESP = 'Expediente';
        //       Text0003@7001174 :
        Text0003: TextConst ENU = 'Job', ESP = 'Obra';
        //       Text0004@7001175 :
        Text0004: TextConst ENU = 'Total Direct Cost', ESP = 'Total coste directo';
        //       Text0005@7001176 :
        Text0005: TextConst ENU = 'Total Record', ESP = 'Total Expediente';
        //       Period@7001177 :
        Period: TextConst ENU = 'Period', ESP = 'Periodo';
        //       Budget_caption@7001178 :
        Budget_caption: TextConst ENU = 'Budget ', ESP = 'Presupuesto';
        //       BudgetNo@7001179 :
        BudgetNo: Code[10];

    /*begin
    end.
  */

}



