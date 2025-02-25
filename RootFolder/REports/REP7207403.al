report 7207403 "Production, cost and result"
{


    CaptionML = ENU = 'Production, cost and result', ESP = 'Produccion, Coste y Resultado';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Budget Filter";
            Column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
                //SourceExpr=FORMAT(TODAY,0,4);
            }
            Column(CurrReportPAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(CompanyInformationPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(CurrReportPAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(JobCaptionLbl; JobCaptionLbl)
            {
                //SourceExpr=JobCaptionLbl;
            }
            Column(ECONOMICPLANNINGCaptionLbl; ECONOMIC_PLANNINGCaptionLbl)
            {
                //SourceExpr=ECONOMIC_PLANNINGCaptionLbl;
            }
            Column(JobNo; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            DataItem("Header"; "2000000026")
            {

                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                Column(JobNo_JobDescription_JobDescription2; Job."No." + ' ' + Job.Description + ' ' + Job."Description 2")
                {
                    //SourceExpr=Job."No." + ' ' + Job.Description + ' ' + Job."Description 2";
                }
                Column(Job__No___________Job_DescriptionCaptionLbl; Job__No___________Job_DescriptionCaptionLbl)
                {
                    //SourceExpr=Job__No___________Job_DescriptionCaptionLbl;
                }
                Column(TxtTitle; TxtTitle)
                {
                    //SourceExpr=TxtTitle;
                }
                Column(JobCaption; JobCaptionLbl)
                {
                    //SourceExpr=JobCaptionLbl;
                }
                Column(S__ProductionCaptionLbl; S__ProductionCaptionLbl)
                {
                    //SourceExpr=S__Producti¢nCaptionLbl;
                }
                Column(Total_JobCaptionLbl; Total_JobCaptionLbl)
                {
                    //SourceExpr=Total_JobCaptionLbl;
                }
                Column(Planned_JobCaptionLbl; Planned_JobCaptionLbl)
                {
                    //SourceExpr=Planned_JobCaptionLbl;
                }
                Column(PADSTR____Indentation_2________Name_Control1100240016CaptionLbl; PADSTR____Indentation_2________Name_Control1100240016CaptionLbl)
                {
                    //SourceExpr=PADSTR____Indentation_2________Name_Control1100240016CaptionLbl;
                }
                Column(TotalCaptionLbl; TotalCaptionLbl)
                {
                    //SourceExpr=TotalCaptionLbl;
                }
                Column(Planned_CaptionLbl; Planned_CaptionLbl)
                {
                    //SourceExpr=Planned_CaptionLbl;
                }
                Column(SIECaptionLbl; SIECaptionLbl)
                {
                    //SourceExpr=SIECaptionLbl;
                }
                Column(cabeceraNumber; Number)
                {
                    //SourceExpr=Number;
                }
                DataItem("Income"; "Dimension Value")
                {

                    DataItemTableView = SORTING("Dimension Code", "Code")
                                 WHERE("Type" = CONST("Income"), "Indentation" = CONST(0), "Dimension Value Type" = CONST("Total"));
                    ;
                    Column(PADSTR_Indentation_2__Name; PADSTR('', Indentation * 2, ' ') + Name)
                    {
                        //SourceExpr=PADSTR('',Indentation*2,' ') + Name;
                    }
                    Column(decProductionSIE; decProductionSIE)
                    {
                        //SourceExpr=decProductionSIE;
                    }
                    Column(decPlannedProduction; decPlannedProduction)
                    {
                        //SourceExpr=decPlannedProduction;
                    }
                    Column(decTotalProduction; decTotalProduction)
                    {
                        //SourceExpr=decTotalProduction;
                    }
                    Column(decBySIE; decBySIE)
                    {
                        //SourceExpr=decBySIE;
                    }
                    Column(decByPlanif; decByPlanif)
                    {
                        //SourceExpr=decByPlanif;
                    }
                    Column(decByTotal; decByTotal)
                    {
                        //SourceExpr=decByTotal;
                    }
                    Column(PADSTR____Indentation_2________Name_Control1100240016; PADSTR('', Indentation * 2, ' ') + Name)
                    {
                        //SourceExpr=PADSTR('',Indentation*2,' ') + Name;
                    }
                    Column(decProductionSIE_Control1100240012; decProductionSIE)
                    {
                        //SourceExpr=decProductionSIE;
                    }
                    Column(decPlannedProduction_Control1100240014; decPlannedProduction)
                    {
                        //SourceExpr=decPlannedProduction;
                    }
                    Column(decTotalProduction_Control1100240018; decTotalProduction)
                    {
                        //SourceExpr=decTotalProduction;
                    }
                    Column(decByTotal_Control1100240033; decByTotal)
                    {
                        //SourceExpr=decByTotal;
                    }
                    Column(decBySIE_Control1100240034; decBySIE)
                    {
                        //SourceExpr=decBySIE;
                    }
                    Column(decByPlanif_Control1100240035; decByPlanif)
                    {
                        //SourceExpr=decByPlanif;
                    }
                    Column(IncomeDimensionCode; Income."Dimension Code")
                    {
                        //SourceExpr=Income."Dimension Code";
                    }
                    Column(IncomeCode; Income.Code)
                    {
                        //SourceExpr=Income.Code;
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        Income.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        IF Income.Totaling <> '' THEN BEGIN
                            Job.SETFILTER("Analytic Concept Filter", Income.Totaling);
                            Job.SETRANGE("Posting Date Filter", 0D, BudgetJob."Budget Date" - 1);
                            Job.CALCFIELDS("Realized Amount");
                            decProductionSIE := -Job."Realized Amount";
                            Job.SETRANGE("Posting Date Filter", BudgetJob."Budget Date", 99991231D);
                            Job.CALCFIELDS("Budgeted Amount");
                            decPlannedProduction := -Job."Budgeted Amount";
                            decTotalProduction := decProductionSIE + decPlannedProduction;
                        END ELSE BEGIN
                            Job.SETFILTER("Analytic Concept Filter", Income.Code);
                            Job.SETRANGE("Posting Date Filter", 0D, BudgetJob."Budget Date" - 1);
                            Job.CALCFIELDS("Realized Amount");
                            decProductionSIE := -Job."Realized Amount";
                            Job.SETRANGE("Posting Date Filter", BudgetJob."Budget Date", 99991231D);
                            Job.CALCFIELDS("Budgeted Amount");
                            decPlannedProduction := -Job."Budgeted Amount";
                            decTotalProduction := decProductionSIE + decPlannedProduction;
                        END;

                        decBySIE := 100;
                        decByPlanif := 100;
                        decByTotal := 100;
                    END;

                }

                DataItem("Expenses"; "Dimension Value")
                {

                    DataItemTableView = SORTING("Dimension Code", "Code")
                                 WHERE("Type" = FILTER("Expenses" | "Result"));
                    ;
                    Column(decByTotal_Control1100240008; decByTotal)
                    {
                        //SourceExpr=decByTotal;
                    }
                    Column(decByPlanif_Control1100240009; decByPlanif)
                    {
                        //SourceExpr=decByPlanif;
                    }
                    Column(decBySIE_Control1100240013; decBySIE)
                    {
                        //SourceExpr=decBySIE;
                    }
                    Column(decTotalExpenses; decTotalExpenses)
                    {
                        //SourceExpr=decTotalExpenses;
                    }
                    Column(decGPlannedExpenses; decGPlannedExpenses)
                    {
                        //SourceExpr=decGPlannedExpenses;
                    }
                    Column(decExpensesSIE; decExpensesSIE)
                    {
                        //SourceExpr=decExpensesSIE;
                    }
                    Column(PADSTR____Indentation_2________Name_Control1100240038; PADSTR('', Indentation * 2, ' ') + Name)
                    {
                        //SourceExpr=PADSTR('',Indentation*2,' ') + Name;
                    }
                    Column(decByTotal_Control1100240039; decByTotal)
                    {
                        //SourceExpr=decByTotal;
                    }
                    Column(decByPlanif_Control1100240040; decByPlanif)
                    {
                        //SourceExpr=decByPlanif;
                    }
                    Column(decBySIE_Control1100240041; decBySIE)
                    {
                        //SourceExpr=decBySIE;
                    }
                    Column(decTotalExpenses_Control1100240042; decTotalExpenses)
                    {
                        //SourceExpr=decTotalExpenses;
                    }
                    Column(decGPlannedExpenses_Control1100240043; decGPlannedExpenses)
                    {
                        //SourceExpr=decGPlannedExpenses;
                    }
                    Column(decExpensesSIE_Control1100240044; decExpensesSIE)
                    {
                        //SourceExpr=decExpensesSIE;
                    }
                    Column(PADSTR____Indentation_2________Name_Control1100240045; PADSTR('', Indentation * 2, ' ') + Name)
                    {
                        //SourceExpr=PADSTR('',Indentation*2,' ') + Name;
                    }
                    Column(ExpensesDimensionCode; Expenses."Dimension Code")
                    {
                        //SourceExpr=Expenses."Dimension Code";
                    }
                    Column(ExpensesCode; Expenses.Code)
                    {
                        //SourceExpr=Expenses.Code ;
                    }
                    //D3 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        Expenses.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        IF Expenses.Totaling <> '' THEN BEGIN
                            Job.SETFILTER("Analytic Concept Filter", Expenses.Totaling);
                            Job.SETRANGE("Posting Date Filter", 0D, BudgetJob."Budget Date" - 1);
                            Job.CALCFIELDS("Realized Amount");
                            IF Expenses.Type = Expenses.Type::Expenses THEN
                                decExpensesSIE := Job."Realized Amount"
                            ELSE
                                decExpensesSIE := -Job."Realized Amount";
                            Job.SETRANGE("Posting Date Filter", BudgetJob."Budget Date", 99991231D);
                            Job.CALCFIELDS("Budgeted Amount");
                            IF Expenses.Type = Expenses.Type::Expenses THEN
                                decGPlannedExpenses := Job."Budgeted Amount"
                            ELSE
                                decGPlannedExpenses := -Job."Budgeted Amount";
                            decTotalExpenses := decExpensesSIE + decGPlannedExpenses;
                        END ELSE BEGIN
                            Job.SETFILTER("Analytic Concept Filter", Expenses.Code);
                            Job.SETRANGE("Posting Date Filter", 0D, BudgetJob."Budget Date" - 1);
                            Job.CALCFIELDS("Realized Amount");
                            IF Expenses.Type = Expenses.Type::Expenses THEN
                                decExpensesSIE := Job."Realized Amount"
                            ELSE
                                decExpensesSIE := -Job."Realized Amount";
                            Job.SETRANGE("Posting Date Filter", BudgetJob."Budget Date", 99991231D);
                            Job.CALCFIELDS("Budgeted Amount");
                            IF Expenses.Type = Expenses.Type::Expenses THEN
                                decGPlannedExpenses := Job."Budgeted Amount"
                            ELSE
                                decGPlannedExpenses := -Job."Budgeted Amount";
                            decTotalExpenses := decExpensesSIE + decGPlannedExpenses;
                        END;

                        IF decProductionSIE <> 0 THEN
                            decBySIE := ROUND(decExpensesSIE * 100 / decProductionSIE, 0.01)
                        ELSE
                            decBySIE := 0;

                        IF decPlannedProduction <> 0 THEN
                            decByPlanif := ROUND(decGPlannedExpenses * 100 / decPlannedProduction, 0.01)
                        ELSE
                            decByPlanif := 0;

                        IF decTotalProduction <> 0 THEN
                            decByTotal := ROUND(decTotalExpenses * 100 / decTotalProduction, 0.01)
                        ELSE
                            decByTotal := 0;
                    END;


                }
            }
            //Job Triggers

            trigger OnAfterGetRecord();
            BEGIN
                IF GETFILTER(Job."Budget Filter") <> '' THEN
                    codeBudgetInCourse := GETFILTER(Job."Budget Filter")
                ELSE BEGIN
                    IF Job."Current Piecework Budget" <> '' THEN
                        codeBudgetInCourse := Job."Current Piecework Budget"
                    ELSE
                        codeBudgetInCourse := Job."Initial Budget Piecework";
                END;

                BudgetJob.GET(Job."No.", codeBudgetInCourse);

                Job.SETRANGE("Reestimation Filter", BudgetJob."Cod. Reestimation");


                TxtTitle := Text000 + ' ' + FORMAT(BudgetJob."Budget Date" - 1, 0, '<Month Text> <Year4>');
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
        //       FunctionQB@7001113 :
        FunctionQB: Codeunit 7207272;
        //       codeBudgetInCourse@7001112 :
        codeBudgetInCourse: Code[20];
        //       BudgetJob@7001111 :
        BudgetJob: Record 7207407;
        //       decProductionSIE@7001110 :
        decProductionSIE: Decimal;
        //       decPlannedProduction@7001109 :
        decPlannedProduction: Decimal;
        //       decTotalProduction@7001108 :
        decTotalProduction: Decimal;
        //       CompanyInformation@7001107 :
        CompanyInformation: Record 79;
        //       decBySIE@7001106 :
        decBySIE: Decimal;
        //       decByPlanif@7001105 :
        decByPlanif: Decimal;
        //       decByTotal@7001104 :
        decByTotal: Decimal;
        //       TxtTitle@7001103 :
        TxtTitle: Text[100];
        //       decExpensesSIE@7001102 :
        decExpensesSIE: Decimal;
        //       decGPlannedExpenses@7001101 :
        decGPlannedExpenses: Decimal;
        //       decTotalExpenses@7001100 :
        decTotalExpenses: Decimal;
        //       Text000@7001125 :
        Text000: TextConst ENU = 'Job SIE', ESP = 'Tarea SIE';
        //       CurrReport_PAGENOCaptionLbl@7001124 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       JobCaptionLbl@7001123 :
        JobCaptionLbl: TextConst ENU = 'PRODUCTION,COST and RESULT', ESP = 'PRODUCCION, COSTE Y RESULTADO';
        //       ECONOMIC_PLANNINGCaptionLbl@7001122 :
        ECONOMIC_PLANNINGCaptionLbl: TextConst ENU = 'ECONOMIC PLANNING', ESP = 'PLANIFICACION ECONOMICA';
        //       Job_CaptionLbl@7001121 :
        Job_CaptionLbl: TextConst ENU = 'Job:', ESP = 'Tarea:';
        //       S__Producti¢nCaptionLbl@7001120 :
        S__ProductionCaptionLbl: TextConst ENU = '%S/Production', ESP = '%S/Produccion';
        //       Total_JobCaptionLbl@7001119 :
        Total_JobCaptionLbl: TextConst ENU = 'Total Job', ESP = 'Tarea Total';
        //       Planned_JobCaptionLbl@7001118 :
        Planned_JobCaptionLbl: TextConst ENU = 'Planned Job', ESP = 'Tarea Planificada';
        //       PADSTR____Indentation_2________Name_Control1100240016CaptionLbl@7001117 :
        PADSTR____Indentation_2________Name_Control1100240016CaptionLbl: TextConst ENU = 'Activity/ nature', ESP = 'Actividad / natural';
        //       TotalCaptionLbl@7001116 :
        TotalCaptionLbl: TextConst ESP = 'Total';
        //       Planned_CaptionLbl@7001115 :
        Planned_CaptionLbl: TextConst ENU = 'Planned', ESP = 'Planificado';
        //       SIECaptionLbl@7001114 :
        SIECaptionLbl: TextConst ESP = 'SIE';
        //       Job__No___________Job_DescriptionCaptionLbl@7001126 :
        Job__No___________Job_DescriptionCaptionLbl: TextConst ENU = 'Proyect:', ESP = 'Obra:';



    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;



    /*begin
        end.
      */

}



