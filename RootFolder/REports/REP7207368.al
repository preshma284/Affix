report 7207368 "Current and pending situation"
{


    CaptionML = ESP = 'Situaci¢n act y pendiente', ENG = 'Current and pending situation';

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
            Column(FORMAT__No____________Description; FORMAT("No.") + '  ' + Description + Job."Description 2")
            {
                //SourceExpr=FORMAT("No.") + '  ' +Description+Job."Description 2";
            }
            Column(Project___; 'Project :')
            {
                //SourceExpr='Project :';
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(TextBudget; TextBudget)
            {
                //SourceExpr=TextBudget;
            }
            Column(Selection_Description; Description)
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
            Column(TGVarCostPend; TGVarCostPend)
            {
                //SourceExpr=TGVarCostPend;
            }
            Column(Difference; Difference)
            {
                //SourceExpr=Difference;
            }
            Column(TotSaleExeConsolidated; TotSaleExeConsolidated)
            {
                //SourceExpr=TotSaleExeConsolidated;
            }
            Column(TotSaleExeInProcess; TotSaleExeInProcess)
            {
                //SourceExpr=TotSaleExeInProcess;
            }
            Column(TotSaleExeConsolidated_TotSaleExeInProcess; TotSaleExeConsolidated + TotSaleExeInProcess)
            {
                //SourceExpr=TotSaleExeConsolidated+TotSaleExeInProcess;
            }
            Column(TotSalePendConsolidated; TotSalePendConsolidated)
            {
                //SourceExpr=TotSalePendConsolidated;
            }
            Column(TotSalePendInProcess; TotSalePendInProcess)
            {
                //SourceExpr=TotSalePendInProcess;
            }
            Column(TotSalePendConsolidated_TotSalePendInProcess; TotSalePendConsolidated + TotSalePendInProcess)
            {
                //SourceExpr=TotSalePendConsolidated+TotSalePendInProcess;
            }
            Column(TGVarCostPend_Control143; TGVarCostPend)
            {
                //SourceExpr=TGVarCostPend;
            }
            Column(TGVarCostPend_Control144; TGVarCostPend)
            {
                //SourceExpr=TGVarCostPend;
            }
            Column(TotDifferenceConsol; TotDifferenceConsol)
            {
                //SourceExpr=TotDifferenceConsol;
            }
            Column(TotDifferenceProfit; TotDifferenceProfit)
            {
                //SourceExpr=TotDifferenceProfit;
            }
            Column(Current_and_Pending_SituationCaption; Current_and_Pending_SituationCaptionLbl)
            {
                //SourceExpr=Current_and_Pending_SituationCaptionLbl;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(Unit_JobCaption; Unit_JobCaptionLbl)
            {
                //SourceExpr=Unit_JobCaptionLbl;
            }
            Column(U__measure_Caption; U__measure_CaptionLbl)
            {
                //SourceExpr=U__measure_CaptionLbl;
            }
            Column(DescriptionCaption; DescriptionCaptionLbl)
            {
                //SourceExpr=DescriptionCaptionLbl;
            }
            Column(Production_SourceCaption; Production_SourceCaptionLbl)
            {
                //SourceExpr=Production_SourceCaptionLbl;
            }
            Column(Measurement_Proj_Caption; Measurement_proj_CaptionLbl)
            {
                //SourceExpr=Measurement_proj_CaptionLbl;
            }
            Column(Measurement_SourceCaption; Measurement_SourceCaptionLbl)
            {
                //SourceExpr=Measurement_SourceCaptionLbl;
            }
            Column(Measurement_PendingCaption; Measurement_PendingCaptionLbl)
            {
                //SourceExpr=Measurement_PendingCaptionLbl;
            }
            Column(Cost_PendingCaption; Cost_PendingCaptionLbl)
            {
                //SourceExpr=Cost_PendingCaptionLbl;
            }
            Column(Production_PendingCaption; Production_PendingCaptionLbl)
            {
                //SourceExpr=Production_PendingCaptionLbl;
            }
            Column(Margin_PendingCaption; Margin_PendingCaptionLbl)
            {
                //SourceExpr=Margin_PendingCaptionLbl;
            }
            Column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
                //SourceExpr=EmptyStringCaptionLbl;
            }
            Column(Total_generalCaption; Total_generalCaptionLbl)
            {
                //SourceExpr=Total_generalCaptionLbl;
            }
            Column(EmptyStringCaption_Control150; EmptyStringCaption_Control150Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control150Lbl;
            }
            Column(Total_consolidatedCaption; Total_consolidatedCaptionLbl)
            {
                //SourceExpr=Total_consolidatedCaptionLbl;
            }
            Column(Total_in_ProcessCaption; Total_in_ProcessCaptionLbl)
            {
                //SourceExpr=Total_in_ProcessCaptionLbl;
            }
            Column(Total_Job_ProfitCaption; Total_Job_ProfitCaptionLbl)
            {
                //SourceExpr=Total_Job_ProfitCaptionLbl;
            }
            Column(EmptyStringCaption_Control151; EmptyStringCaption_Control151Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control151Lbl;
            }
            Column(EmptyStringCaption_Control152; EmptyStringCaption_Control152Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control152Lbl;
            }
            Column(Seleccion_No_; "No.")
            {
                //SourceExpr="No.";
            }
            DataItem("Job"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(Job_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Difference_Control180; Difference)
                {
                    //SourceExpr=Difference;
                }
                Column(TVarCostPend; TVarCostPend)
                {
                    //SourceExpr=TVarCostPend;
                }
                Column(TVarProdPending; TVarProdPending)
                {
                    //SourceExpr=TVarProdPending;
                }
                Column(TVarProdExecuted; TVarProdExecuted)
                {
                    //SourceExpr=TVarProdExecuted;
                }
                Column(Total_JobCaption; Total_JobCaptionLbl)
                {
                    //SourceExpr=Total_JobCaptionLbl;
                }
                Column(EmptyStringCaption_Control118; EmptyStringCaption_Control118Lbl)
                {
                    //SourceExpr=EmptyStringCaption_Control118Lbl;
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
                    Column(COPYSTR_varspaces_1_Indentation_2___Data_Piecework__for_Production___Description; COPYSTR(varspaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(Data_Piecework__for_Production___Amount_Production_Performed_; "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Performed";
                    }
                    Column(Difference_Control1100251003; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(AmountCostPend; AmountCostPend)
                    {
                        //SourceExpr=AmountCostPend;
                    }
                    Column(Amount_Producction_Budget____Amount_Production_Performed_; "Amount Production Budget" - "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Budget"-"Amount Production Performed";
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2___Piecework_Code_; COPYSTR(varspaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2___Data_Piecework__for_Production___Description_Control1100251000; COPYSTR(varspaces, 1, Indentation * 2) + "Data Piecework For Production".Description)
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Data Piecework For Production".Description;
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2___Piecework_Code__Control1100251013; COPYSTR(varspaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Data_Piecework__for_Production___Amount_Production_Performed__Control1100251004; "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Performed";
                    }
                    Column(Amount_Producction_Budget____Amount_Production_Performed__Control1100251005; "Amount Production Budget" - "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Budget"-"Amount Production Performed";
                    }
                    Column(AmountCostPend_Control1100251007; AmountCostPend)
                    {
                        //SourceExpr=AmountCostPend;
                    }
                    Column(Difference_Control1100251012; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(Data_Piecework__for_Production___Data_Piecework__for_Production____Unit_Of_Measure_; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(Data_Piecework__for_Production___Data_Piecework__for_Production___Description; "Data Piecework For Production".Description)
                    {
                        //SourceExpr="Data Piecework For Production".Description;
                    }
                    Column(Data_Piecework__for_Production___Amount_Production_Performed__Control13; "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Performed";
                    }
                    Column(Difference_Control15; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(Data_Piecework__for_Production___Budget_Measure__; "Budget Measure")
                    {
                        //SourceExpr="Budget Measure";
                    }
                    Column(Data_Piecework__for_Production___Total_Measurement_Production_; "Total Measurement Production")
                    {
                        //SourceExpr="Total Measurement Production";
                    }
                    Column(AmountCostPend_Control34; AmountCostPend)
                    {
                        //SourceExpr=AmountCostPend;
                    }
                    Column(Budget_Measure____Total_Measurement_Production_; "Budget Measure" - "Total Measurement Production")
                    {
                        //SourceExpr="Budget Measure"-"Total Measurement Production";
                    }
                    Column(Amount_Production_Budget____Amount_Production_Performed__Control20; "Amount Production Budget" - "Amount Production Performed")
                    {
                        //SourceExpr="Amount Production Budget"-"Amount Production Performed";
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2___Piecework_Code__Control7; COPYSTR(varspaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Data_Piecework__for_Production___Data_Piecework__for_Production______Processed_Production_; "Data Piecework For Production"."% Processed Production")
                    {
                        DecimalPlaces = 0 : 0;
                        //SourceExpr="Data Piecework For Production"."% Processed Production";
                    }
                    Column(EmptyStringCaption_Control1100251011; EmptyStringCaption_Control1100251011Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control1100251011Lbl;
                    }
                    Column(EmptyStringCaption_Control1100251014; EmptyStringCaption_Control1100251014Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control1100251014Lbl;
                    }
                    Column(EmptyStringCaption_Control110; EmptyStringCaption_Control110Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control110Lbl;
                    }
                    Column(Data_Piecework__for_Production__Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Data_Piecework__for_Production__Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(Data_Piecework__for_Production__Title; Title)
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
                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");

                        CALCFIELDS("Aver. Cost Price Pend. Budget");

                        SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        FunCostPending("Data Piecework For Production", VarprodPend, AmountCostPend, Difference,
                                            "Data Piecework For Production".GETFILTER("Budget Filter"));

                        IF "Data Piecework For Production"."Account Type" =
                            "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                            TVarProdExecuted := TVarProdExecuted + "Data Piecework For Production"."Amount Production Performed";
                            TVarProdPending := TVarProdPending + VarprodPend;
                            TGVarProdExecuted := TGVarProdExecuted + "Data Piecework For Production"."Amount Production Performed";
                            TGVarProdPending := TGVarProdPending + VarprodPend;
                            TVarCostPend := TVarCostPend + AmountCostPend;
                            TGVarCostPend := TGVarCostPend + AmountCostPend;
                        END;

                        //Acumulo consolidados y tr mite
                        IF "Data Piecework For Production"."Account Type" =
                            "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                            decSaleInProcess := ROUND("Amount Production Performed" *
                                                     (1 - "% Processed Production" / 100), 0.01);
                            decSaleProcessed := ROUND("Amount Production Performed" *
                                                     ("% Processed Production" / 100), 0.01);
                            decBudgetInProcess := ROUND(("Amount Production Budget" *
                                                     (100 - "% Processed Production") / 100), 0.01);
                            decBudgetProcessed := ROUND(("Amount Production Budget" *
                                                     "% Processed Production" / 100), 0.01);


                            TotSaleExeConsolidated := TotSaleExeConsolidated + decSaleProcessed;
                            TotSalePendConsolidated := TotSalePendConsolidated + (decBudgetProcessed - decSaleProcessed);
                            TotSaleTotConsolidated := TotSaleTotConsolidated + decBudgetProcessed;
                            TotSaleExeInProcess := TotSaleExeInProcess + decSaleInProcess;
                            TotSalePendInProcess := TotSalePendInProcess + (decBudgetInProcess - decSaleInProcess);
                            TotSaleTotInProcess := TotSaleTotInProcess + decBudgetInProcess;
                        END;
                    END;

                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF Selection.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Selection."Current Piecework Budget");

                    SETFILTER("Posting Date Filter", '%1..%2', DateStart, DateEnd);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    FunInicializa;
                END;

            }
            DataItem("Project2"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(FORMAT_Project2__No____________Description; FORMAT(Project2."No.") + '  ' + Description)
                {
                    //SourceExpr=FORMAT(Project2."No.") + '  ' +Description;
                }
                Column(Project2_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(TVarProdExecuted_Control73; TVarProdExecuted)
                {
                    //SourceExpr=TVarProdExecuted;
                }
                Column(TVarProdPending_Control74; TVarProdPending)
                {
                    //SourceExpr=TVarProdPending;
                }
                Column(TVarostPend_Control75; TVarCostPend)
                {
                    //SourceExpr=TVarCostPend;
                }
                Column(Difference_Control82; Difference)
                {
                    //SourceExpr=Difference;
                }
                Column(Expenses_ManagementCaption; Expenses_ManagementCaptionLbl)
                {
                    //SourceExpr=Expenses_ManagementCaptionLbl;
                }
                Column(Total_General_ExpensesCaption; Total_General_ExpensesCaptionLbl)
                {
                    //SourceExpr=Total_General_ExpensesCaptionLbl;
                }
                Column(EmptyStringCaption_Control149; EmptyStringCaption_Control149Lbl)
                {
                    //SourceExpr=EmptyStringCaption_Control149Lbl;
                }
                Column(Project2_No_; "No.")
                {
                    //SourceExpr="No.";
                }
                DataItem("Expenses_Management"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Piecework"));


                    CalcFields = "Amount Production Performed", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)", "Budget Measure", "Total Measurement Production", "Amount Production Budget", "Amount Cost Budget (JC)";
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(Difference_Control33; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(AmountCostPend_Control35; AmountCostPend)
                    {
                        //SourceExpr=AmountCostPend;
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2__Description; COPYSTR(varspaces, 1, Indentation * 2) + Description)
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+Description;
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2___Piecework_Code__Control1100251020; COPYSTR(varspaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Difference_Control1100251021; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(AmountCostPend_Control1100251022; AmountCostPend)
                    {
                        //SourceExpr=AmountCostPend;
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2__Description_Control1100251030; COPYSTR(varspaces, 1, Indentation * 2) + Description)
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+Description;
                    }
                    Column(COPYSTR_varspaces_1_Indentation_2___Piecework_Code__Control1100251031; COPYSTR(varspaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Expenses_Management__Unit_Of_Measure_; "Unit Of Measure")
                    {
                        //SourceExpr="Unit Of Measure";
                    }
                    Column(Expenses_Management_Description; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(Diferencia_Control1100251035; Difference)
                    {
                        //SourceExpr=Difference;
                    }
                    Column(ImpCosPte_Control1100251038; AmountCostPend)
                    {
                        //SourceExpr=AmountCostPend;
                    }
                    Column(COPYSTR_varespacios_1_Indentation_2___Piecework_Code__Control1100251041; COPYSTR(varspaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(varspaces,1,Indentation*2)+"Piecework Code";
                    }
                    Column(Expenses_Management____Processed_Production_; "% Processed Production")
                    {
                        DecimalPlaces = 0 : 0;
                        //SourceExpr="% Processed Production";
                    }
                    Column(EmptyStringCaption_Control135; EmptyStringCaption_Control135Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control135Lbl;
                    }
                    Column(EmptyStringCaption_Control1100251029; EmptyStringCaption_Control1100251029Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control1100251029Lbl;
                    }
                    Column(EmptyStringCaption_Control1100251043; EmptyStringCaption_Control1100251043Lbl)
                    {
                        //SourceExpr=EmptyStringCaption_Control1100251043Lbl;
                    }
                    Column(Expenses_Management_Job_No; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Expenses_Management_Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code" ;
                    }
                    //D4 TRiggers
                    trigger OnPreDataItem();
                    BEGIN
                        IF Selection.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Selection."Current Piecework Budget");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        CALCFIELDS("Aver. Cost Price Pend. Budget");
                        SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        FunCostPendingExpenses(Expenses_Management, VarprodPend, AmountCostPend, Difference,
                                               Expenses_Management.GETFILTER("Budget Filter"));

                        IF Expenses_Management."Account Type" = Expenses_Management."Account Type"::Unit THEN BEGIN
                            TGVarCostPend := TGVarCostPend + AmountCostPend;
                            TVarCostPend := TVarCostPend + AmountCostPend;
                            TotAmountCostPendConsol := TotAmountCostPendConsol + AmountCostPend;
                            TotAmountCostPendProfit := TotAmountCostPendProfit + AmountCostPend;
                        END;
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
                    FunInicializa;
                    SETRANGE("Posting Date Filter");
                    CALCFIELDS("Production Budget Amount");
                    SETFILTER("Posting Date Filter", '%1..%2', DateStart, DateEnd);
                    CALCFIELDS("Actual Production Amount");
                END;


            }
            //Job Triggers
            trigger OnPreDataItem();
            BEGIN
                DateStart := GETRANGEMIN("Posting Date Filter");
                DateEnd := GETRANGEMAX("Posting Date Filter");

                IF ((Selection.GETFILTER(Selection."Posting Date Filter") = '') OR (DateStart = DateEnd)) THEN
                    ERROR(Text0001);

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
                FilterPeriod := Job.GETFILTER(Job."Posting Date Filter");

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN

                TextBudget := '';
                IF Selection.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Selection."No.", Selection.GETFILTER("Budget Filter")) THEN BEGIN
                        TextBudget := JobBudget."Budget Name"
                    END
                END
                ELSE BEGIN
                    IF JobBudget.GET(Selection."No.", Selection."Current Piecework Budget") THEN BEGIN
                        TextBudget := JobBudget."Budget Name"
                    END;
                END;

                FunInicializa;
                FunInicializaJob;
                TotAmountCostPendProfit := 0;
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
        Project = 'Proyecto/ Project/';
        Presupuesto = 'Presupuesto/ Budget/';
        Pagina = 'Page/ Pag./';
    }

    var
        //       LevelDetail@1100231000 :
        LevelDetail: Option "Titulo","Subtitulos","Detalle";
        //       Difference@1100231004 :
        Difference: Decimal;
        //       AmountCostPend@1100231007 :
        AmountCostPend: Decimal;
        //       TextTotal@1100231021 :
        TextTotal: Text[30];
        //       TotDifference@1100231022 :
        TotDifference: Decimal;
        //       CompanyInformation@1100231023 :
        CompanyInformation: Record 79;
        //       DateStart@1100231024 :
        DateStart: Date;
        //       DateEnd@1100231025 :
        DateEnd: Date;
        //       FilterPeriod@1100231026 :
        FilterPeriod: Text[30];
        //       TotDifferenceConsol@1100231036 :
        TotDifferenceConsol: Decimal;
        //       TotVtaExeProfitOld@1100231039 :
        TotVtaExeProfitOld: Decimal;
        //       TotAmountCostPendConsol@1100251028 :
        TotAmountCostPendConsol: Decimal;
        //       TotAmountCostPendProfit@1100231041 :
        TotAmountCostPendProfit: Decimal;
        //       TotDifferenceProfit@1100231042 :
        TotDifferenceProfit: Decimal;
        //       decSaleInProcess@1100231048 :
        decSaleInProcess: Decimal;
        //       decSaleProcessed@1100231047 :
        decSaleProcessed: Decimal;
        //       decBudgetProcessed@1100231046 :
        decBudgetProcessed: Decimal;
        //       decBudgetInProcess@1100231045 :
        decBudgetInProcess: Decimal;
        //       Text0001@1100251000 :
        Text0001: TextConst ENU = '<You must specify a date range in the Date Filter field>', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       "---"@1100251005 :
        "---": Integer;
        //       varspaces@1100251001 :
        varspaces: Text[30];
        //       TotSaleExeConsolidated@1100251019 :
        TotSaleExeConsolidated: Decimal;
        //       TotSaleTotConsolidated@1100251018 :
        TotSaleTotConsolidated: Decimal;
        //       TotSalePendConsolidated@1100251017 :
        TotSalePendConsolidated: Decimal;
        //       TotSaleExeInProcess@1100251016 :
        TotSaleExeInProcess: Decimal;
        //       TotSaleTotInProcess@1100251015 :
        TotSaleTotInProcess: Decimal;
        //       TotSalePendInProcess@1100251014 :
        TotSalePendInProcess: Decimal;
        //       "--"@1100251035 :
        "--": Integer;
        //       TVarProdExecuted@1100251022 :
        TVarProdExecuted: Decimal;
        //       TVarProdPending@1100251021 :
        TVarProdPending: Decimal;
        //       TVarProdTotal@1100251020 :
        TVarProdTotal: Decimal;
        //       TVarCostPend@1100251023 :
        TVarCostPend: Decimal;
        //       TGVarProdExecuted@1100251027 :
        TGVarProdExecuted: Decimal;
        //       TGVarProdPending@1100251026 :
        TGVarProdPending: Decimal;
        //       TGVarProdTotal@1100251025 :
        TGVarProdTotal: Decimal;
        //       TGVarCostPend@1100251024 :
        TGVarCostPend: Decimal;
        //       VarprodPend@1100251002 :
        VarprodPend: Decimal;
        //       TextBudget@1100000 :
        TextBudget: Text[50];
        //       JobBudget@1100001 :
        JobBudget: Record 7207407;
        //       Current_and_Pending_SituationCaptionLbl@9150 :
        Current_and_Pending_SituationCaptionLbl: TextConst ENU = '<Current and Pending Situation>', ESP = 'Situaci¢n actual y pendiente';
        //       CurrReport_PAGENOCaptionLbl@8565 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       Unit_JobCaptionLbl@7962 :
        Unit_JobCaptionLbl: TextConst ENU = '<Unit Job>', ESP = 'Unidad obra';
        //       U__measure_CaptionLbl@1972 :
        U__measure_CaptionLbl: TextConst ENU = '<U. measure>', ESP = 'U. med.';
        //       DescriptionCaptionLbl@2524 :
        DescriptionCaptionLbl: TextConst ENU = '<Description>', ESP = 'Descripci¢n';
        //       Production_SourceCaptionLbl@6293 :
        Production_SourceCaptionLbl: TextConst ENU = '<Production Source>', ESP = 'Producci¢n origen';
        //       Measurement_proj_CaptionLbl@5283 :
        Measurement_proj_CaptionLbl: TextConst ENU = '<Measurement proj.>', ESP = 'Medici¢n proy.';
        //       Measurement_SourceCaptionLbl@8596 :
        Measurement_SourceCaptionLbl: TextConst ENU = '<Measurement Source>', ESP = 'Medici¢n Origen';
        //       Measurement_PendingCaptionLbl@8988 :
        Measurement_PendingCaptionLbl: TextConst ENU = '<Measurement Pending>', ESP = 'Medici¢n pendiente';
        //       Cost_PendingCaptionLbl@6202 :
        Cost_PendingCaptionLbl: TextConst ENU = '<Cost Pending>', ESP = 'Coste pendiente';
        //       Production_PendingCaptionLbl@7291 :
        Production_PendingCaptionLbl: TextConst ENU = '<Production Pending>', ESP = 'Producci¢n pendiente';
        //       Margin_PendingCaptionLbl@5309 :
        Margin_PendingCaptionLbl: TextConst ENU = '<Margin Pending>', ESP = 'Margen pendiente';
        //       EmptyStringCaptionLbl@5389 :
        EmptyStringCaptionLbl: TextConst ENU = '%', ESP = '%';
        //       Total_generalCaptionLbl@4052 :
        Total_generalCaptionLbl: TextConst ENU = '<Total General>', ESP = 'Total general';
        //       EmptyStringCaption_Control150Lbl@3817 :
        EmptyStringCaption_Control150Lbl: TextConst ENU = '%', ESP = '%';
        //       Total_consolidatedCaptionLbl@2404 :
        Total_consolidatedCaptionLbl: TextConst ENU = '<Total Consolidated>', ESP = 'Total consolidado';
        //       Total_in_ProcessCaptionLbl@1776 :
        Total_in_ProcessCaptionLbl: TextConst ENU = '<Total In Process>', ESP = 'Total en tr mite';
        //       Total_Job_ProfitCaptionLbl@6535 :
        Total_Job_ProfitCaptionLbl: TextConst ENU = '<Total Job Profit>', ESP = 'Total Obra Bruto';
        //       EmptyStringCaption_Control151Lbl@8726 :
        EmptyStringCaption_Control151Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control152Lbl@4743 :
        EmptyStringCaption_Control152Lbl: TextConst ENU = '%', ESP = '%';
        //       Total_JobCaptionLbl@5923 :
        Total_JobCaptionLbl: TextConst ENU = '<Total Job>', ESP = 'Total obra';
        //       EmptyStringCaption_Control118Lbl@9009 :
        EmptyStringCaption_Control118Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control1100251011Lbl@1198330013 :
        EmptyStringCaption_Control1100251011Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control1100251014Lbl@1145840743 :
        EmptyStringCaption_Control1100251014Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control110Lbl@9283 :
        EmptyStringCaption_Control110Lbl: TextConst ENU = '%', ESP = '%';
        //       Expenses_ManagementCaptionLbl@9638 :
        Expenses_ManagementCaptionLbl: TextConst ENU = '<Expenses Management>', ESP = 'Gastos gestion';
        //       Total_General_ExpensesCaptionLbl@5804 :
        Total_General_ExpensesCaptionLbl: TextConst ENU = '<Total General Expenses>', ESP = 'Total gastos generales';
        //       EmptyStringCaption_Control149Lbl@3016 :
        EmptyStringCaption_Control149Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control135Lbl@7450 :
        EmptyStringCaption_Control135Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control1100251029Lbl@1181951858 :
        EmptyStringCaption_Control1100251029Lbl: TextConst ENU = '%', ESP = '%';
        //       EmptyStringCaption_Control1100251043Lbl@1132659901 :
        EmptyStringCaption_Control1100251043Lbl: TextConst ENU = '%', ESP = '%';



    trigger OnPreReport();
    begin
        varspaces := '                    ';
    end;



    // procedure FunCostPending (DataPieceworkForProduction@1100251000 : Record 7207386;var VarProdPend@1100251003 : Decimal;var AmountCostPend@1100251004 : Decimal;var VarDifference@1100251005 : Decimal;ParCodeBudget@1100000 :
    procedure FunCostPending(DataPieceworkForProduction: Record 7207386; var VarProdPend: Decimal; var AmountCostPend: Decimal; var VarDifference: Decimal; ParCodeBudget: Code[20])
    var
        //       DataPieceworkForProduction2@1100251001 :
        DataPieceworkForProduction2: Record 7207386;
    begin
        //calcula el coste pendiente y la Difference
        AmountCostPend := 0;
        Difference := 0;
        VarProdPend := 0;

        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Job No.");
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Piecework Code", DataPieceworkForProduction."Piecework Code");
        DataPieceworkForProduction.SETRANGE("Filter Date");
        DataPieceworkForProduction.SETRANGE("Budget Filter", ParCodeBudget);
        DataPieceworkForProduction.CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget", "Amount Production Budget");
        DataPieceworkForProduction.SETFILTER("Budget Filter", '%1', ParCodeBudget);
        DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
        DataPieceworkForProduction.SETRANGE("Budget Filter");
        DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
        DataPieceworkForProduction.CALCFIELDS("Total Measurement Production", "Amount Production Performed");

        if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit then begin
            if DataPieceworkForProduction."Budget Measure" <> 0 then begin
                AmountCostPend := DataPieceworkForProduction."Aver. Cost Price Pend. Budget" *
                    (DataPieceworkForProduction."Budget Measure" - DataPieceworkForProduction."Total Measurement Production");
                VarProdPend := VarProdPend + DataPieceworkForProduction."Amount Production Budget" - DataPieceworkForProduction."Amount Production Performed";

            end else begin
                AmountCostPend := 0;
            end
        end else begin
            DataPieceworkForProduction2.COPYFILTERS(DataPieceworkForProduction);
            DataPieceworkForProduction2.SETFILTER(DataPieceworkForProduction2."Piecework Code", DataPieceworkForProduction.Totaling);
            DataPieceworkForProduction2.SETRANGE(DataPieceworkForProduction2."Account Type", DataPieceworkForProduction2."Account Type"::Unit);
            if DataPieceworkForProduction2.FINDSET then
                repeat
                    DataPieceworkForProduction2.SETRANGE("Filter Date");
                    DataPieceworkForProduction2.SETFILTER("Budget Filter", '%1', ParCodeBudget);
                    DataPieceworkForProduction2.CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget", "Amount Production Budget");
                    DataPieceworkForProduction2.CALCFIELDS("Aver. Cost Price Pend. Budget");
                    DataPieceworkForProduction2.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                    DataPieceworkForProduction2.CALCFIELDS("Total Measurement Production", "Amount Production Performed");
                    if DataPieceworkForProduction2."Budget Measure" <> 0 then begin
                        AmountCostPend := AmountCostPend + DataPieceworkForProduction2."Aver. Cost Price Pend. Budget" *
                                (DataPieceworkForProduction2."Budget Measure" - DataPieceworkForProduction2."Total Measurement Production");
                    end else
                        AmountCostPend := AmountCostPend + 0;
                //VarProdPend := VarProdPend + DataPieceworkForProduction."Importe producci¢n ppto."-DataPieceworkForProduction."Importe producci¢n realizada";
                until DataPieceworkForProduction2.NEXT = 0;
        end;

        if (VarProdPend <> 0) then
            Difference := ROUND(((VarProdPend - AmountCostPend) / VarProdPend) * 100, 0.1);
    end;

    //     procedure FunCostPendingExpenses (DataPieceworkForProduction@1100251000 : Record 7207386;var VarProdPend@1100251003 : Decimal;var AmountCostPend@1100251004 : Decimal;var VarDifference@1100251005 : Decimal;ParCodeBudget@1100000 :
    procedure FunCostPendingExpenses(DataPieceworkForProduction: Record 7207386; var VarProdPend: Decimal; var AmountCostPend: Decimal; var VarDifference: Decimal; ParCodeBudget: Code[20])
    var
        //       DataPieceworkForProduction2@1100251001 :
        DataPieceworkForProduction2: Record 7207386;
        //       VarLength@1100251002 :
        VarLength: Decimal;
    begin
        //calcula el coste pendiente y la Difference
        AmountCostPend := 0;
        Difference := 0;
        VarProdPend := 0;

        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Job No.");
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Piecework Code", DataPieceworkForProduction."Piecework Code");
        DataPieceworkForProduction.SETRANGE("Filter Date");
        DataPieceworkForProduction.SETRANGE("Budget Filter", ParCodeBudget);
        DataPieceworkForProduction.CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget", "Amount Production Budget", "Amount Cost Budget (JC)");
        DataPieceworkForProduction.SETFILTER("Budget Filter", '%1', ParCodeBudget);
        DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
        DataPieceworkForProduction.SETRANGE("Budget Filter");
        DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
        DataPieceworkForProduction.CALCFIELDS("Total Measurement Production", "Amount Production Performed", "Amount Cost Performed (JC)");

        if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit then begin
            if DataPieceworkForProduction."Allocation Terms" = DataPieceworkForProduction."Allocation Terms"::"% on Direct Costs" then
                AmountCostPend := (DataPieceworkForProduction."Amount Cost Budget (JC)" - DataPieceworkForProduction."Amount Cost Performed (JC)")
                              * DataPieceworkForProduction."% Expense Cost" / 100
            else
                if DataPieceworkForProduction."Allocation Terms" = DataPieceworkForProduction."Allocation Terms"::"% on Production" then
                    AmountCostPend := (DataPieceworkForProduction."Amount Production Budget" -
                                 DataPieceworkForProduction."Amount Production Performed") * DataPieceworkForProduction."% Expense Cost" / 100
                else
                    AmountCostPend := DataPieceworkForProduction."Amount Cost Budget (JC)" - DataPieceworkForProduction."Amount Cost Performed (JC)";
        end else begin
            VarLength := STRLEN(DataPieceworkForProduction."Piecework Code");
            DataPieceworkForProduction2.COPYFILTERS(DataPieceworkForProduction);
            DataPieceworkForProduction2.SETFILTER(DataPieceworkForProduction2."Piecework Code", DataPieceworkForProduction.Totaling);
            DataPieceworkForProduction2.SETRANGE(DataPieceworkForProduction2."Account Type", DataPieceworkForProduction2."Account Type"::Unit);
            if DataPieceworkForProduction2.FINDFIRST then
                repeat
                    DataPieceworkForProduction2.SETRANGE("Filter Date");
                    DataPieceworkForProduction2.SETFILTER("Budget Filter", '%1', ParCodeBudget);
                    DataPieceworkForProduction2.CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget", "Amount Production Budget", "Amount Cost Budget (JC)");
                    DataPieceworkForProduction2.CALCFIELDS("Aver. Cost Price Pend. Budget");
                    DataPieceworkForProduction2.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                    DataPieceworkForProduction2.CALCFIELDS("Total Measurement Production", "Amount Production Performed", "Amount Cost Performed (JC)");
                    if DataPieceworkForProduction2."Allocation Terms" = DataPieceworkForProduction2."Allocation Terms"::"% on Direct Costs" then
                        AmountCostPend := AmountCostPend +
                                   (DataPieceworkForProduction2."Amount Cost Budget (JC)" - DataPieceworkForProduction2."Amount Cost Performed (JC)") * DataPieceworkForProduction2."% Expense Cost" / 100
                    else
                        if DataPieceworkForProduction2."Allocation Terms" = DataPieceworkForProduction2."Allocation Terms"::"% on Production" then
                            AmountCostPend := AmountCostPend +
                                  (DataPieceworkForProduction2."Amount Production Budget" - DataPieceworkForProduction2."Amount Production Performed")
                                  * DataPieceworkForProduction2."% Expense Cost" / 100
                        else
                            AmountCostPend := AmountCostPend + DataPieceworkForProduction2."Amount Cost Budget (JC)" - DataPieceworkForProduction2."Amount Cost Performed (JC)";
                until DataPieceworkForProduction2.NEXT = 0;
        end;

        if (VarProdPend <> 0) then
            Difference := ROUND(((VarProdPend - AmountCostPend) / VarProdPend) * 100, 0.1);
    end;

    procedure FunInicializa()
    begin
        TVarProdExecuted := 0;
        TVarProdPending := 0;
        TVarProdTotal := 0;
        TVarCostPend := 0;
    end;

    procedure FunInicializaJob()
    begin
        TGVarProdExecuted := 0;
        TGVarProdPending := 0;
        TGVarProdTotal := 0;
        TGVarCostPend := 0;
    end;

    /*begin
    end.
  */

}



