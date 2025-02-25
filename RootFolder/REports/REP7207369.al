report 7207369 "Production & Theoretical Cost"
{


    CaptionML = ENU = 'Production & Theoretical Cost', ESP = 'Producci¢n y coste te¢rico';
    PreviewMode = Normal;

    dataset
    {

        DataItem("Job"; "Job")
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
            Column(FORMAT_Job__No____________Job_Description; FORMAT(Job."No.") + '  ' + Job.Description + ' ' + Job."Description 2")
            {
                //SourceExpr=FORMAT(Job."No.") + '  ' +Job.Description + ' ' + Job."Description 2";
            }
            Column(JobText____; JobText + ':')
            {
                //SourceExpr=JobText+':';
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(Period___; Period)
            {
                //SourceExpr=Period;
            }
            Column(PeriodFilter; PeriodFilter)
            {
                //SourceExpr=PeriodFilter;
            }
            Column(BudgetText; BudgetText)
            {
                //SourceExpr=BudgetText;
            }
            Column(TextBudget_; TextBudget + ':')
            {
                //SourceExpr=TextBudget+':';
            }
            Column(DevAcum2_DevAcum; DevAcum2 + DevAcum)
            {
                //SourceExpr=DevAcum2+DevAcum;
            }
            Column(DevPeriod2_DevPeriod; DevPeriod2 + DevPeriod)
            {
                //SourceExpr=DevPeriod2+DevPeriod;
            }
            Column(TheoreticalExpensePeriod_TheoreticalExpense; TheoreticalExpensePeriod + TheoreticalExpense)
            {
                //SourceExpr=TheoreticalExpensePeriod+TheoreticalExpense;
            }
            Column(RealExpensePeriod_RealExpense; RealExpensePeriod + RealExpense)
            {
                //SourceExpr=RealExpensePeriod+RealExpense;
            }
            Column(TotalConsolidated_DecTotalInProcess; TotalConsolidated + TotalInProcess)
            {
                //SourceExpr=TotalConsolidated+TotalInProcess;
            }
            Column(TotalInProcess; TotalInProcess)
            {
                //SourceExpr=TotalInProcess;
            }
            Column(TotalConsolidated; TotalConsolidated)
            {
                //SourceExpr=TotalConsolidated;
            }
            Column(RealExpensePeriod_RealExpense_Control14; RealExpensePeriod + RealExpense)
            {
                //SourceExpr=RealExpensePeriod+RealExpense;
            }
            Column(TheoreticalExpensePeriod_TheoreticalExpense_Control16; TheoreticalExpensePeriod + TheoreticalExpense)
            {
                //SourceExpr=TheoreticalExpensePeriod+TheoreticalExpense;
            }
            Column(DevPeriod2_DevPeriod_Control18; DevPeriod2 + DevPeriod)
            {
                //SourceExpr=DevPeriod2+DevPeriod;
            }
            Column(DevAcum2_DevAcum_Control24; DevAcum2 + DevAcum)
            {
                //SourceExpr=DevAcum2+DevAcum;
            }
            Column(Production_And_Theoretical_CostCaption; Production_And_Theoretical_CostCaptionLbl)
            {
                //SourceExpr=Production_And_Theoretical_CostCaptionLbl;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(PieceworkCaption; PieceworkCaptionLbl)
            {
                //SourceExpr=PieceworkCaptionLbl;
            }
            Column(Unit_Of_Measure_Caption; Unit_Of_Measure_CaptionLbl)
            {
                //SourceExpr=Unit_Of_Measure_CaptionLbl;
            }
            Column(DescriptionCaption; DescriptionCaptionLbl)
            {
                //SourceExpr=DescriptionCaptionLbl;
            }
            Column(Amount_Production_PerformedCaption; Amount_Production_PerformedCaptionLbl)
            {
                //SourceExpr=Amount_Production_PerformedCaptionLbl;
            }
            Column(Real_Expense_MonthCaption; Real_Expense_MonthCaptionLbl)
            {
                //SourceExpr=Real_Expense_MonthCaptionLbl;
            }
            Column(Theoretical_Expense_MonthCaption; Theoretical_Expense_MonthCaptionLbl)
            {
                //SourceExpr=Theoretical_Expense_MonthCaptionLbl;
            }
            Column(Deviation_MonthCaption; Deviation_MonthCaptionLbl)
            {
                //SourceExpr=Deviation_MonthCaptionLbl;
            }
            Column(Dev__Since_Update_Caption; Dev__Since_Update_CaptionLbl)
            {
                //SourceExpr=Dev__Since_Update_CaptionLbl;
            }
            Column(Production_ProcessedCaption; Production_ProcessedCaptionLbl)
            {
                //SourceExpr=Production_ProcessedCaptionLbl;
            }
            Column(Total_Job_In_ProcessCaption; Total_Job_In_ProcessCaptionLbl)
            {
                //SourceExpr=Total_Job_In_ProcessCaptionLbl;
            }
            Column(Total_Job_ConsolidatedCaption; Total_Job_ConsolidatedCaptionLbl)
            {
                //SourceExpr=Total_Job_ConsolidatedCaptionLbl;
            }
            Column(Total_Gross_JobCaption; Total_Gross_JobCaptionLbl)
            {
                //SourceExpr=Total_Gross_JobCaptionLbl;
            }
            Column(Job_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(TextBudget; TextBudget)
            {
                //SourceExpr=TextBudget;
            }
            DataItem("2000000026"; "2000000026")
            {

                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                PrintOnlyIfDetail = true;
                ;
                Column(DevAcum; DevAcum)
                {
                    //SourceExpr=DevAcum;
                }
                Column(DevPeriod; DevPeriod)
                {
                    //SourceExpr=DevPeriod;
                }
                Column(TheoreticalExpense; TheoreticalExpense)
                {
                    //SourceExpr=TheoreticalExpense;
                }
                Column(TotalText; TotalText)
                {
                    //SourceExpr=TotalText;
                }
                Column(Job_Description; Job.Description)
                {
                    //SourceExpr=Job.Description;
                }
                Column(Total; Total)
                {
                    //SourceExpr=Total;
                }
                Column(RealExpense; RealExpense)
                {
                    //SourceExpr=RealExpense;
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


                    DataItemLinkReference = "Job";
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(FORMAT_Title___________NameTitle; FORMAT(Title) + '  ' + NameTitle)
                    {
                        //SourceExpr=FORMAT(Title) + '  ' + NameTitle;
                    }
                    Column(Piecework; Piecework)
                    {
                        //SourceExpr=Piecework;
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production____Unit_Of_Measure_; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production___Description; "Data Piecework For Production".Description)
                    {
                        //SourceExpr="Data Piecework For Production".Description;
                    }
                    Column(DevAcum_Control20; DevAcum)
                    {
                        //SourceExpr=DevAcum;
                    }
                    Column(DevPeriod_Control21; DevPeriod)
                    {
                        //SourceExpr=DevPeriod;
                    }
                    Column(TheoreticalExpense_Control22; TheoreticalExpense)
                    {
                        //SourceExpr=TheoreticalExpense;
                    }
                    Column(RealExpense_Control23; RealExpense)
                    {
                        //SourceExpr=RealExpense;
                    }
                    Column(Data_Piecework_For_Production___Amount_Production_Performed_; "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Performed";
                    }
                    Column(Data_Piecework_For_Production___Data_Piecework_For_Production______Processed_Production_; "Data Piecework For Production"."% Processed Production")
                    {
                        //SourceExpr="Data Piecework For Production"."% Processed Production";
                    }
                    Column(RealExpense_Control8; RealExpense)
                    {
                        //SourceExpr=RealExpense;
                    }
                    Column(TheoreticalExpense_Control9; TheoreticalExpense)
                    {
                        //SourceExpr=TheoreticalExpense;
                    }
                    Column(DevPeriod_Control10; DevPeriod)
                    {
                        //SourceExpr=DevPeriod;
                    }
                    Column(DevAcum_Control11; DevAcum)
                    {
                        //SourceExpr=DevAcum;
                    }
                    Column(ProductionAmountConsolidated; ProductionAmountConsolidated)
                    {
                        //SourceExpr=ProductionAmountConsolidated;
                    }
                    Column(FORMAT_Title___________NameTitle_Control12; FORMAT(Title) + '  ' + NameTitle)
                    {
                        //SourceExpr=FORMAT(Title) + '  ' + NameTitle;
                    }
                    Column(ProjectCaption; ProjectCaptionLbl)
                    {
                        //SourceExpr=ProjectCaptionLbl;
                    }
                    Column(Total_ProjectCaption; Total_ProjectCaptionLbl)
                    {
                        //SourceExpr=Total_ProjectCaptionLbl;
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
                        IF Job.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Job."Current Piecework Budget");


                        CurrReport.CREATETOTALS("Amount Production Performed", RealExpense, TheoreticalExpense, DevPeriod, DevAcum);

                        CurrReport.CREATETOTALS(ProductionAmountConsolidated, ProductionAmountInProcess);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        SETFILTER("Filter Date", '%1..%2', StartDate, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        PeriodAvg := 0;
                        RealExpense := 0;
                        TheoreticalExpense := 0;
                        DevPeriod := 0;
                        DevAcum := 0;

                        PeriodAvg := "Total Measurement Production";
                        RealExpense := "Amount Cost Performed (JC)";

                        TheoreticalExpense := PeriodAvg * "Aver. Cost Price Pend. Budget";

                        DevPeriod := TheoreticalExpense - RealExpense;

                        IF Price.GET("Job No.", "Piecework Code") THEN BEGIN
                            Price.SETFILTER(Price."Filter Date", '%1..%2', JobBudget."Budget Date", EndDate);
                            IF Job.GETFILTER("Budget Filter") <> '' THEN
                                Price.SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"));
                            Price.CALCFIELDS("Total Measurement Production", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");
                            TheoreticalExpenseAcummulated := Price."Total Measurement Production" * Price."Aver. Cost Price Pend. Budget";
                            RealExpenseAcummulated := Price."Amount Cost Performed (JC)";
                            DevAcum := TheoreticalExpenseAcummulated - RealExpenseAcummulated;
                        END;

                        Piecework := COPYSTR("Piecework Code", STRLEN(Title) + 1);
                        NameTitle := '';
                        IF RecTitle.GET(Job."No.", Title) THEN
                            NameTitle := RecTitle.Description;

                        SaleInProcess := ROUND("Amount Production Performed" *
                                                   (1 - ("% Processed Production" / 100)), 0.01);
                        SaleProcessed := ROUND("Amount Production Performed" *
                                                   ("% Processed Production" / 100), 0.01);
                        BudgetInProcess := ROUND(("Amount Production Budget" *
                                                   (100 - "% Processed Production") / 100), 0.01);
                        BudgetProcessed := ROUND(("Amount Production Budget" *
                                                   "% Processed Production" / 100), 0.01);

                        ProductionAmountInProcess := SaleInProcess;
                        TotalInProcess := TotalInProcess + SaleInProcess;
                        ProductionAmountConsolidated := SaleProcessed;
                        TotalConsolidated := TotalConsolidated + SaleProcessed;
                    END;
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Production Performed");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Total := 0;
                    TotalConsolidated := 0;
                    TotalInProcess := 0;
                END;

            }
            DataItem("Job2"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(FORMAT_Job2__No____________Description; FORMAT(Job2."No.") + '  ' + Description)
                {
                    //SourceExpr=FORMAT(Job2."No.") + '  ' +Description;
                }
                Column(Job2_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(TheoreticalExpense_Control47; TheoreticalExpense)
                {
                    //SourceExpr=TheoreticalExpense;
                }
                Column(DevPeriod_Control54; DevPeriod)
                {
                    //SourceExpr=DevPeriod;
                }
                Column(DevAcum_Control63; DevAcum)
                {
                    //SourceExpr=DevAcum;
                }
                Column(RealExpense_Control6; RealExpense)
                {
                    //SourceExpr=RealExpense;
                }
                Column(Management_ExpensesCaption; Management_ExpensesCaptionLbl)
                {
                    //SourceExpr=Management_ExpensesCaptionLbl;
                }
                Column(Total_Management_ExpensesCaption; Total_Management_ExpensesCaptionLbl)
                {
                    //SourceExpr=Total_Management_ExpensesCaptionLbl;
                }
                Column(Job2_No_; "No.")
                {
                    //SourceExpr="No.";
                }
                DataItem("ManagementExpenses"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Cost Unit"));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(TheoreticalExpense_Control40; TheoreticalExpense)
                    {
                        //SourceExpr=TheoreticalExpense;
                    }
                    Column(DevPeriod_Control48; DevPeriod)
                    {
                        //SourceExpr=DevPeriod;
                    }
                    Column(DevAcum_Control55; DevAcum)
                    {
                        //SourceExpr=DevAcum;
                    }
                    Column(RealExpense_Control2; RealExpense)
                    {
                        //SourceExpr=RealExpense;
                    }
                    Column(ManagementExpenses_Description; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(ManagementExpenses__Unit_Of_Measure_; "Unit Of Measure")
                    {
                        //SourceExpr="Unit Of Measure";
                    }
                    Column(Piecework_Control60; Piecework)
                    {
                        //SourceExpr=Piecework;
                    }
                    Column(TheoreticalExpense_Control42; TheoreticalExpense)
                    {
                        //SourceExpr=TheoreticalExpense;
                    }
                    Column(DevPeriod_Control51; DevPeriod)
                    {
                        //SourceExpr=DevPeriod;
                    }
                    Column(DevAcum_Control57; DevAcum)
                    {
                        //SourceExpr=DevAcum;
                    }
                    Column(RealExpense_Control3; RealExpense)
                    {
                        //SourceExpr=RealExpense;
                    }
                    Column(ManagementExpenses____Processed_Production_; "% Processed Production")
                    {
                        //SourceExpr="% Processed Production";
                    }
                    Column(TheoreticalExpense_Control46; TheoreticalExpense)
                    {
                        //SourceExpr=TheoreticalExpense;
                    }
                    Column(DevPeriod_Control53; DevPeriod)
                    {
                        //SourceExpr=DevPeriod;
                    }
                    Column(DevAcum_Control62; DevAcum)
                    {
                        //SourceExpr=DevAcum;
                    }
                    Column(RealExpense_Control5; RealExpense)
                    {
                        //SourceExpr=RealExpense;
                    }
                    Column(SumCaption; SumCaptionLbl)
                    {
                        //SourceExpr=SumCaptionLbl;
                    }
                    Column(SumCaption_Control83; SumCaption_Control83Lbl)
                    {
                        //SourceExpr=SumCaption_Control83Lbl;
                    }
                    Column(ManagementExpenses_Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(ManagementExpenses_Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(ManagementExpenses_Title; Title)
                    {
                        //SourceExpr=Title ;
                    }
                    //D4 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF Job.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Job."Current Piecework Budget");


                        CurrReport.CREATETOTALS(PeriodAvg, RealExpense, TheoreticalExpense, DevPeriod, DevAcum);
                        CurrReport.CREATETOTALS(Sum);


                        CurrReport.CREATETOTALS(ProductionAmountConsolidated, ProductionAmountInProcess);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        SETFILTER("Filter Date", '%1..%2', StartDate, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");


                        PeriodAvg := 0;
                        RealExpense := 0;
                        TheoreticalExpense := 0;
                        DevPeriod := 0;
                        DevAcum := 0;

                        TheoreticalExpenseAcummulated := 0;
                        RealExpenseAcummulated := 0;

                        IF "Unit Of Measure" = '' THEN
                            CurrReport.SKIP;

                        PeriodAvg := "Total Measurement Production";
                        RealExpense := ("Amount Cost Performed (JC)");

                        TheoreticalExpense := RealExpense;

                        DevPeriod := TheoreticalExpense - RealExpense;


                        IF Price.GET("Job No.", "Piecework Code") THEN BEGIN
                            IF Job.GETFILTER("Budget Filter") <> '' THEN
                                Price.SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"));
                            Price.SETFILTER(Price."Filter Date", '%1..%2', JobBudget."Budget Date", EndDate);

                            Price.CALCFIELDS("Total Measurement Production", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");
                            RealExpenseAcummulated := Price."Amount Cost Performed (JC)";

                            TheoreticalExpenseAcummulated := RealExpenseAcummulated;
                            Sum := RealExpense;
                            DevAcum := TheoreticalExpenseAcummulated - RealExpenseAcummulated;
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


                        ProductionAmountInProcess := SaleInProcess;
                        ProductionAmountConsolidated := SaleProcessed;
                    END;


                }
                //D3 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF Job.GETFILTER("Reestimation Filter") <> '' THEN
                        SETFILTER("Reestimation Filter", Job.GETFILTER("Reestimation Filter"));

                    //CurrReport.CREATETOTALS(ImpCosTot,ImpCosEjec,ImpCosPte,VtaTot,VtaEjec,VtaPte,Diferencia);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    FOR i := 1 TO 9 DO
                        BoolExpenses[i] := TRUE;

                    recManagementExpenses.SETRANGE("Job No.", "No.");
                    recManagementExpenses.SETRANGE("Subtype Cost", ManagementExpenses."Subtype Cost"::"Deprec. Anticipated");
                    IF NOT recManagementExpenses.FINDFIRST THEN
                        BoolExpenses[1] := FALSE;
                    recManagementExpenses.RESET;

                    recManagementExpenses.SETRANGE("Job No.", "No.");
                    recManagementExpenses.SETRANGE("Subtype Cost", ManagementExpenses."Subtype Cost"::"Current Expenses");
                    IF NOT recManagementExpenses.FINDFIRST THEN
                        BoolExpenses[2] := FALSE;
                    recManagementExpenses.RESET;

                    BoolExpenses[3] := FALSE;

                    recManagementExpenses.SETRANGE("Job No.", "No.");
                    recManagementExpenses.SETRANGE("Subtype Cost", ManagementExpenses."Subtype Cost"::"Deprec. Deferred");
                    IF NOT recManagementExpenses.FINDFIRST THEN
                        BoolExpenses[4] := FALSE;
                    recManagementExpenses.RESET;

                    recManagementExpenses.SETRANGE("Job No.", "No.");
                    recManagementExpenses.SETRANGE("Subtype Cost", ManagementExpenses."Subtype Cost"::"Deprec. Inmovilized");
                    IF NOT recManagementExpenses.FINDFIRST THEN
                        BoolExpenses[5] := FALSE;
                    recManagementExpenses.RESET;

                    BoolExpenses[6] := FALSE;
                    BoolExpenses[7] := FALSE;

                    recManagementExpenses.SETRANGE("Job No.", "No.");
                    recManagementExpenses.SETRANGE("Subtype Cost", ManagementExpenses."Subtype Cost"::"Financial Charges");
                    IF NOT recManagementExpenses.FINDFIRST THEN
                        BoolExpenses[8] := FALSE;
                    recManagementExpenses.RESET;

                    recManagementExpenses.SETRANGE("Job No.", "No.");
                    recManagementExpenses.SETRANGE("Subtype Cost", ManagementExpenses."Subtype Cost"::Others);
                    IF NOT recManagementExpenses.FINDFIRST THEN
                        BoolExpenses[9] := FALSE;
                    recManagementExpenses.RESET;
                END;


            }
            //Job Triggers
    trigger OnPreDataItem();
    BEGIN
        CompanyInformation2.GET;
        StartDate := GETRANGEMIN("Posting Date Filter");
        EndDate := GETRANGEMAX("Posting Date Filter");

        IF ((Job.GETFILTER(Job."Posting Date Filter") = '') OR (StartDate = EndDate)) THEN
            ERROR(Text0001);

        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
        PeriodFilter := Job.GETFILTER(Job."Posting Date Filter");
        CurrReport.CREATETOTALS(PeriodAvg, RealExpense, TheoreticalExpense, DevPeriod, DevAcum);
    END;

    trigger OnAfterGetRecord();
    BEGIN
        BudgetText := '';
        IF Job.GETFILTER("Budget Filter") <> '' THEN BEGIN
            IF JobBudget.GET(Job."No.", Job.GETFILTER("Budget Filter")) THEN BEGIN
                BudgetText := JobBudget."Cod. Budget" + '  ' + JobBudget."Budget Name";
            END
        END
        ELSE BEGIN
            IF JobBudget.GET(Job."No.", Job."Current Piecework Budget") THEN BEGIN
                BudgetText := JobBudget."Cod. Budget" + '  ' + JobBudget."Budget Name";
            END;
        END;


        Job.SETRANGE("Posting Date Filter");
        CALCFIELDS("Production Budget Amount", "Actual Production Amount");
        Job.SETRANGE("Posting Date Filter", StartDate, EndDate);
        CALCFIELDS("Actual Production Amount");
        IF Job."Matrix Job it Belongs" <> '' THEN
            JobText := 'Expediente'
        ELSE
            JobText := 'Obra';
        IF JobText = 'Obra' THEN
            TotalText := 'Total coste directo'
        ELSE
            TotalText := 'Total Expediente';
        CurrentDate := "Reestimation Last Date";

        BudgetAmount := 0;
        PostedAmount := 0;
        BudgetAmount := Job.ProductionBudgetWithoutProcess;
        PostedAmount := "Actual Production Amount" - Job.ProductionTheoricalProcess;
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
        //       Text0001@7001120 :
        Text0001: TextConst ENU = 'You must specify a date period in the Filter Date field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Production_And_Theoretical_CostCaptionLbl@7001119 :
        Production_And_Theoretical_CostCaptionLbl: TextConst ENU = 'Production and Theoretical Cost', ESP = 'Producci¢n y coste te¢rico';
        //       CurrReport_PAGENOCaptionLbl@7001118 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       PieceworkCaptionLbl@7001117 :
        PieceworkCaptionLbl: TextConst ENU = 'Piecework', ESP = 'Unidad obra';
        //       Unit_Of_Measure_CaptionLbl@7001116 :
        Unit_Of_Measure_CaptionLbl: TextConst ENU = 'Unit of Measure', ESP = 'U. med.';
        //       DescriptionCaptionLbl@7001115 :
        DescriptionCaptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Amount_Production_PerformedCaptionLbl@7001114 :
        Amount_Production_PerformedCaptionLbl: TextConst ENU = 'Amount Production Performed', ESP = 'Importe producci¢n realizada';
        //       Real_Expense_MonthCaptionLbl@7001113 :
        Real_Expense_MonthCaptionLbl: TextConst ENU = 'Real Expense Month', ESP = 'Gasto real mes';
        //       Theoretical_Expense_MonthCaptionLbl@7001112 :
        Theoretical_Expense_MonthCaptionLbl: TextConst ENU = 'Theoretical Expense Month', ESP = 'Gasto te¢rico mes';
        //       Deviation_MonthCaptionLbl@7001111 :
        Deviation_MonthCaptionLbl: TextConst ENU = 'Deviation Month', ESP = 'Desviaci¢n mes';
        //       Dev__Since_Update_CaptionLbl@7001110 :
        Dev__Since_Update_CaptionLbl: TextConst ENU = 'Dev. Since Update until end Term', ESP = 'Desv. desde actualiz. hasta fin periodo';
        //       Production_ProcessedCaptionLbl@7001109 :
        Production_ProcessedCaptionLbl: TextConst ENU = '% of Production Processed', ESP = '% Producci¢n tramitada';
        //       Total_Job_In_ProcessCaptionLbl@7001108 :
        Total_Job_In_ProcessCaptionLbl: TextConst ENU = 'Total Job In Process', ESP = 'Total Obra En Tr mite';
        //       Total_Job_ConsolidatedCaptionLbl@7001107 :
        Total_Job_ConsolidatedCaptionLbl: TextConst ENU = 'Total Job Consolidated', ESP = 'Total Obra Consolidado';
        //       Total_Gross_JobCaptionLbl@7001106 :
        Total_Gross_JobCaptionLbl: TextConst ENU = 'Total Gross Job', ESP = 'Total Obra Bruto';
        //       ProjectCaptionLbl@7001105 :
        ProjectCaptionLbl: TextConst ENU = 'Piecework', ESP = 'Unidad de obra';
        //       Total_ProjectCaptionLbl@7001104 :
        Total_ProjectCaptionLbl: TextConst ENU = 'Total Project', ESP = 'Total Unidades de obra';
        //       Management_ExpensesCaptionLbl@7001103 :
        Management_ExpensesCaptionLbl: TextConst ENU = 'Management_Expenses', ESP = 'Gastos gestion';
        //       Total_Management_ExpensesCaptionLbl@7001102 :
        Total_Management_ExpensesCaptionLbl: TextConst ENU = 'Total Management Expenses', ESP = 'Total Gastos de gesti¢n';
        //       SumCaptionLbl@7001101 :
        SumCaptionLbl: TextConst ENU = 'Sum', ESP = 'Suma';
        //       SumCaption_Control83Lbl@7001100 :
        SumCaption_Control83Lbl: TextConst ENU = 'Sum', ESP = 'Suma';
        //       RealExpense@7001170 :
        RealExpense: Decimal;
        //       TheoreticalExpense@7001169 :
        TheoreticalExpense: Decimal;
        //       DevPeriod@7001168 :
        DevPeriod: Decimal;
        //       DevAcum@7001167 :
        DevAcum: Decimal;
        //       StartDate@7001166 :
        StartDate: Date;
        //       EndDate@7001165 :
        EndDate: Date;
        //       CurrentDate@7001164 :
        CurrentDate: Date;
        //       Price@7001163 :
        Price: Record 7207386;
        //       RealExpenseAcummulated@7001162 :
        RealExpenseAcummulated: Decimal;
        //       TheoreticalExpenseAcummulated@7001161 :
        TheoreticalExpenseAcummulated: Decimal;
        //       CompanyInformation@7001160 :
        CompanyInformation: Record 79;
        //       JobText@7001159 :
        JobText: Text[30];
        //       TotalText@7001158 :
        TotalText: Text[30];
        //       PeriodFilter@7001157 :
        PeriodFilter: Text[30];
        //       ForecastDataAmountPiecework@7001156 :
        ForecastDataAmountPiecework: Record 7207392;
        //       BudgetAmount@7001155 :
        BudgetAmount: Decimal;
        //       PostedAmount@7001154 :
        PostedAmount: Decimal;
        //       Piecework@7001153 :
        Piecework: Code[20];
        //       Resource@7001152 :
        Resource: Record 156;
        //       TotalCostAmount@7001151 :
        TotalCostAmount: Decimal;
        //       Diference@7001150 :
        Diference: Decimal;
        //       PerTitle@7001149 :
        PerTitle: Boolean;
        //       PerProject@7001148 :
        PerProject: Boolean;
        //       TotalAvg@7001147 :
        TotalAvg: Decimal;
        //       Total@7001146 :
        Total: Decimal;
        //       PeriodAvg@7001145 :
        PeriodAvg: Decimal;
        //       RegistryNo@7001144 :
        RegistryNo: Integer;
        //       Sum@7001143 :
        Sum: Decimal;
        //       recManagementExpenses@7001142 :
        recManagementExpenses: Record 7207386;
        //       Print@7001141 :
        Print: Boolean;
        //       BoolExpenses@7001140 :
        BoolExpenses: ARRAY[9] OF Boolean;
        //       i@7001139 :
        i: Integer;
        //       Expenses@7001138 :
        Expenses: Text[30];
        //       RealExpensePeriod@7001137 :
        RealExpensePeriod: Decimal;
        //       TheoreticalExpensePeriod@7001136 :
        TheoreticalExpensePeriod: Decimal;
        //       DevPeriod2@7001135 :
        DevPeriod2: Decimal;
        //       DevAcum2@7001134 :
        DevAcum2: Decimal;
        //       NameTitle@7001133 :
        NameTitle: Text[35];
        //       RecTitle@7001132 :
        RecTitle: Record 7207386;
        //       ProductionAmountConsolidated@7001131 :
        ProductionAmountConsolidated: Decimal;
        //       ProductionAmountInProcess@7001130 :
        ProductionAmountInProcess: Decimal;
        //       TotalConsolidated@7001129 :
        TotalConsolidated: Decimal;
        //       TotalInProcess@7001128 :
        TotalInProcess: Decimal;
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
        //       BudgetText@7001122 :
        BudgetText: Text[50];
        //       JobBudget@7001121 :
        JobBudget: Record 7207407;
        //       Period@7001171 :
        Period: TextConst ENU = 'Period :', ESP = 'Per¡odo :';
        //       MAINTITLE@7001172 :
        MAINTITLE: TextConst ENU = 'Title', ESP = 'T¡tulo';
        //       TextBudget@7001173 :
        TextBudget: TextConst ENU = 'Budget: ', ESP = 'Presupuesto: ';

    /*begin
    end.
  */

}



