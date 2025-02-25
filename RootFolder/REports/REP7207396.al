report 7207396 "Final Summary"
{


    CaptionML = ENU = 'Final Summary', ESP = 'Resumen Final';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Posting Date Filter";
            Column(PlannedMonthCost__PlannedMonthCostInd; PlannedMonthCost + PlannedMonthCostInd)
            {
                //SourceExpr=PlannedMonthCost + PlannedMonthCostInd;
            }
            Column(LastPlannedCost__LastPlannedCostInd; LastPlannedCost + LastPlannedCostInd)
            {
                //SourceExpr=LastPlannedCost + LastPlannedCostInd;
            }
            Column(PlannedBegCost__PlannedBegCostInd; PlannedBegCost + PlannedBegCostInd)
            {
                //SourceExpr=PlannedBegCost + PlannedBegCostInd;
            }
            Column(MonthCost__MonthCostInd; MonthCost + MonthCostInd)
            {
                //SourceExpr=MonthCost + MonthCostInd;
            }
            Column(LastCost__LastCostInd; LastCost + LastCostInd)
            {
                //SourceExpr=LastCost + LastCostInd;
            }
            Column(BegCost__BegCostInd; BegCost + BegCostInd)
            {
                //SourceExpr=BegCost + BegCostInd;
            }
            Column(ExecJobMonth__ExecJobMonthInd; ExecJobMonth + ExecJobMonthInd)
            {
                //SourceExpr=ExecJobMonth + ExecJobMonthInd;
            }
            Column(ExecJobBeg__ExecJobBegInd; ExecJobBeg + ExecJobBegInd)
            {
                //SourceExpr=ExecJobBeg + ExecJobBegInd;
            }
            Column(I1; I1)
            {
                //SourceExpr=I1;
            }
            Column(J1; J1)
            {
                //SourceExpr=J1;
            }
            Column(GrandTotal_Lbl; GrandTotal_Lbl)
            {
                //SourceExpr=GrandTotal_Lbl;
            }
            Column(Job_No; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            Column(Job_BudgetFilter; Job."Budget Filter")
            {
                //SourceExpr=Job."Budget Filter";
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));
                DataItemLink = "Job No." = FIELD("No.");
                Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(Job_No____Job_Description; Job."No." + ' ' + Job.Description + ' ' + Job."Description 2")
                {
                    //SourceExpr=Job."No." +  ' ' + Job.Description +  ' ' + Job."Description 2";
                }
                Column(Year; Year)
                {
                    //SourceExpr=Year;
                }
                Column(Month; Month)
                {
                    //SourceExpr=Month;
                }
                Column(Picture; CompanyInformation.Picture)
                {
                    //SourceExpr=CompanyInformation.Picture;
                }
                Column(TOTAL__Description; 'TOTAL ' + Description)
                {
                    //SourceExpr='TOTAL ' + Description;
                }
                Column(PlannedMonthCostUPP; PlannedMonthCostUPP)
                {
                    //SourceExpr=PlannedMonthCostUPP;
                }
                Column(PlannedBegCostUPP; PlannedBegCostUPP)
                {
                    //SourceExpr=PlannedBegCostUPP;
                }
                Column(MonthCostUPP; MonthCostUPP)
                {
                    //SourceExpr=MonthCostUPP;
                }
                Column(BegCostUPP; BegCostUPP)
                {
                    //SourceExpr=BegCostUPP;
                }
                Column(ExecJobMonthUPP; ExecJobMonthUPP)
                {
                    //SourceExpr=ExecJobMonthUPP;
                }
                Column(ExecJobBegUPP; ExecJobBegUPP)
                {
                    //SourceExpr=ExecJobBegUPP;
                }
                Column(I1UPP; I1UPP)
                {
                    //SourceExpr=I1UPP;
                }
                Column(J1UPP; J1UPP)
                {
                    //SourceExpr=J1UPP;
                }
                Column(LastPlannedCostUPP; LastPlannedCostUPP)
                {
                    //SourceExpr=LastPlannedCostUPP;
                }
                Column(LastCostUPP; LastCostUPP)
                {
                    //SourceExpr=LastCostUPP;
                }
                Column(PlannedMonthCost; PlannedMonthCost)
                {
                    //SourceExpr=PlannedMonthCost;
                }
                Column(PlannedBegCost; PlannedBegCost)
                {
                    //SourceExpr=PlannedBegCost;
                }
                Column(MonthCost; MonthCost)
                {
                    //SourceExpr=MonthCost;
                }
                Column(BegCost; BegCost)
                {
                    //SourceExpr=BegCost;
                }
                Column(ExecJobMonth; ExecJobMonth)
                {
                    //SourceExpr=ExecJobMonth;
                }
                Column(ExecJobBeg; ExecJobBeg)
                {
                    //SourceExpr=ExecJobBeg;
                }
                Column(I1_UPP; I1)
                {
                    //SourceExpr=I1;
                }
                Column(J1_UPP; J1)
                {
                    //SourceExpr=J1;
                }
                Column(LastPlannedCost; LastPlannedCost)
                {
                    //SourceExpr=LastPlannedCost;
                }
                Column(LastCost; LastCost)
                {
                    //SourceExpr=LastCost;
                }
                Column(REALCOSTJOB_Lbl; REALCOSTJOB_Lbl)
                {
                    //SourceExpr=REALCOSTJOB_Lbl;
                }
                Column(Page_Lbl; Page_Lbl)
                {
                    //SourceExpr=Page_Lbl;
                }
                Column(FINALSUMMARY_Lbl; FINALSUMMARY_Lbl)
                {
                    //SourceExpr=FINALSUMMARY_Lbl;
                }
                Column(JOB__Lbl; JOB__Lbl)
                {
                    //SourceExpr=JOB__Lbl;
                }
                Column(YEAR__Lbl; YEAR__Lbl)
                {
                    //SourceExpr=YEAR__Lbl;
                }
                Column(MONTH__Lbl; MONTH__Lbl)
                {
                    //SourceExpr=MONTH__Lbl;
                }
                Column(PLANNING_Lbl; PLANNING_Lbl)
                {
                    //SourceExpr=PLANNING_Lbl;
                }
                Column(OPERATION_Lbl; OPERATION_Lbl)
                {
                    //SourceExpr=OPERATION_Lbl;
                }
                Column(UN_Lbl; UN_Lbl)
                {
                    //SourceExpr=UN_Lbl;
                }
                Column(DESCRIPTION_Lbl; DESCRIPTION_Lbl)
                {
                    //SourceExpr=DESCRIPTION_Lbl;
                }
                Column(MonthLbl; MonthLbl)
                {
                    //SourceExpr=MonthLbl;
                }
                Column(EXECUTED_PERC_Lbl; EXECUTED_PERC_Lbl)
                {
                    //SourceExpr=EXECUTED_PERC_Lbl;
                }
                Column(BEGINNINGLbl; BEGINNINGLbl)
                {
                    //SourceExpr=BEGINNINGLbl;
                }
                Column(EXECUTED_Lbl; EXECUTED_Lbl)
                {
                    //SourceExpr=EXECUTED_Lbl;
                }
                Column(EXECJOB__SALEPRICE_Lbl; EXECJOB__SALEPRICE_Lbl)
                {
                    //SourceExpr=EXECJOB__SALEPRICE_Lbl;
                }
                Column(DEVIATION_COST_PLANNEDPERC_Lbl; DEVIATION_COST_PLANNEDPERC_Lbl)
                {
                    //SourceExpr=DEVIATION_COST_PLANNEDPERC_Lbl;
                }
                Column(DIRECTTOTALCOST_UNITARY_Lbl; DIRECTTOTALCOST_UNITARY_Lbl)
                {
                    //SourceExpr=DIRECTTOTALCOST_UNITARY_Lbl;
                }
                Column(TOTALVOL_Lbl; TOTALVOL_Lbl)
                {
                    //SourceExpr=TOTALVOL_Lbl;
                }
                Column(LAST_Lbl; LAST_Lbl)
                {
                    //SourceExpr=LAST_Lbl;
                }
                Column(TOTAL_DIRECT_JOB_Lbl; TOTAL_DIRECT_JOB_Lbl)
                {
                    //SourceExpr=TOTAL_DIRECT_JOB_Lbl;
                }
                Column(DPFP_Job_No; "Data Piecework For Production"."Job No.")
                {
                    //SourceExpr="Data Piecework For Production"."Job No.";
                }
                Column(DPFP_PieceworkCode; "Data Piecework For Production"."Piecework Code")
                {
                    //SourceExpr="Data Piecework For Production"."Piecework Code";
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    LastFieldNo := FIELDNO("Job No.");

                    CurrReport.CREATETOTALS(MonthCost, BegCost, PlannedMonthCost, PlannedBegCostInd);
                    CurrReport.CREATETOTALS(LastCost, LastPlannedCost);
                    CurrReport.CREATETOTALS(ExecJobMonth, ExecJobBeg, LastExecJob);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    InitVariable;
                    "Data Piecework For Production".SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"));

                    IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN BEGIN
                        SETRANGE("Data Piecework For Production"."Filter Date");
                        CALCFIELDS("Aver. Cost Price Pend. Budget");
                        CALCFIELDS("Data Piecework For Production"."Budget Measure", "Data Piecework For Production"."Amount Production Budget");
                        TotalBudgetMeasur := "Data Piecework For Production"."Budget Measure";
                        ExpectedUnitCost := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";
                        LastExpectedUnitCost := "Data Piecework For Production"."Aver. Cost Price Pend. Budget";

                        SETRANGE("Data Piecework For Production"."Filter Date", DateFrom, DateTo);
                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                        CALCFIELDS("Budget Measure");
                        MeasurPerformMonth := "Total Measurement Production";
                        MonthCost := "Amount Cost Performed (JC)";
                        PlannedMonthCost := ROUND("Total Measurement Production" * ExpectedUnitCost, 0.01);
                        ExecJobMonth := "Amount Production Performed";

                        SETRANGE("Data Piecework For Production"."Filter Date", 0D, DateTo);
                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed", "Amount Cost Budget (JC)");
                        CALCFIELDS("Budget Measure");
                        MeasurPerformBeg := "Total Measurement Production";
                        BegCost := "Amount Cost Performed (JC)";

                        IF "Data Piecework For Production"."Total Measurement Production" <> 0 THEN
                            AverageCost := CalculateAverageCost("Data Piecework For Production")
                        ELSE
                            AverageCost := ExpectedUnitCost;

                        PlannedBegCostInd := ROUND("Total Measurement Production" * AverageCost, 0.01);
                        ExecJobBeg := "Amount Production Performed";

                        IF Job."Reestimation Last Date" <> 0D THEN
                            SETRANGE("Data Piecework For Production"."Filter Date", Job."Reestimation Last Date" + 1, DateTo)
                        ELSE
                            SETRANGE("Data Piecework For Production"."Filter Date", DateTo + 1, DateTo);

                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                        CALCFIELDS("Budget Measure");
                        LastMeasurPerf := "Total Measurement Production";
                        LastCost := "Amount Cost Performed (JC)";
                        LastPlannedCost := ROUND("Total Measurement Production" * ExpectedUnitCost, 0.01);
                        LastExecJob := "Amount Production Performed";

                        IF MeasurPerformMonth <> 0 THEN
                            E2 := ROUND((MonthCost / MeasurPerformMonth), 0.01)
                        ELSE
                            E2 := 0;

                        IF LastMeasurPerf <> 0 THEN
                            EULT := ROUND((LastCost / LastMeasurPerf), 0.01)
                        ELSE
                            EULT := 0;

                        IF MeasurPerformBeg <> 0 THEN
                            D2 := ROUND((BegCost / MeasurPerformBeg), 0.01)
                        ELSE
                            D2 := 0;

                        IF MeasurPerformBeg <> 0 THEN
                            F2 := ROUND((ExecJobBeg / MeasurPerformBeg), 0.01)
                        ELSE
                            F2 := 0;

                        IF MeasurPerformMonth <> 0 THEN
                            G2 := ROUND((ExecJobMonth / MeasurPerformMonth), 0.01)
                        ELSE
                            G2 := 0;

                        I1 := -PlannedMonthCost + MonthCost;
                        J1 := -PlannedBegCostInd + BegCost;
                        I2 := -ExpectedUnitCost + E2;
                        J2 := -LastExpectedUnitCost + D2;

                        IF TotalBudgetMeasur <> 0 THEN
                            MeasurePerc := ROUND(MeasurPerformBeg * 100 / TotalBudgetMeasur, 0.01)
                        ELSE
                            MeasurePerc := 0;
                    END ELSE BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
                        DataPieceworkForProduction.SETFILTER("Piecework Code", "Data Piecework For Production".Totaling);
                        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));

                        IF DataPieceworkForProduction.FINDSET THEN
                            REPEAT
                                DataPieceworkForProduction.SETRANGE("Filter Date");
                                DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Budget Measure", DataPieceworkForProduction."Amount Production Budget",
                                                               DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                                TotalBudgetMeasurUPP := TotalBudgetMeasurUPP + DataPieceworkForProduction."Budget Measure";
                                ExpectedUnitCostUPP := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                                LastExpectedUnitCostUPP := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";

                                DataPieceworkForProduction.SETRANGE("Filter Date", DateFrom, DateTo);
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                MonthCostUPP := MonthCostUPP + DataPieceworkForProduction."Amount Cost Performed (JC)";
                                PlannedMonthCostUPP := PlannedMonthCostUPP +
                                                            ROUND(DataPieceworkForProduction."Total Measurement Production" * ExpectedUnitCostUPP, 0.01);
                                ExecJobMonthUPP := ExecJobMonthUPP + DataPieceworkForProduction."Amount Production Performed";

                                DataPieceworkForProduction.SETRANGE("Filter Date", 0D, DateTo);
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                BegCostUPP := BegCostUPP + DataPieceworkForProduction."Amount Cost Performed (JC)";
                                IF DataPieceworkForProduction."Total Measurement Production" <> 0 THEN
                                    AverageCost := CalculateAverageCost(DataPieceworkForProduction)
                                ELSE
                                    AverageCost := ExpectedUnitCostUPP;

                                PlannedBegCostIndUPP := PlannedBegCostIndUPP +
                                                                ROUND(DataPieceworkForProduction."Total Measurement Production" * AverageCost, 0.01);
                                ExecJobBegUPP := ExecJobBegUPP + DataPieceworkForProduction."Amount Production Performed";

                                DataPieceworkForProduction.SETRANGE("Filter Date", 0D, DateFrom - 1);
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                LastCostUPP := LastCostUPP + DataPieceworkForProduction."Amount Cost Performed (JC)";
                                LastPlannedCostUPP := LastPlannedCostUPP +
                                                            ROUND(DataPieceworkForProduction."Total Measurement Production" * ExpectedUnitCostUPP, 0.01);
                                LastExecJobUPP := LastExecJobUPP + DataPieceworkForProduction."Amount Production Performed";
                            UNTIL DataPieceworkForProduction.NEXT = 0;

                        I1UPP := -PlannedMonthCostUPP + MonthCostUPP;
                        J1UPP := -PlannedBegCostIndUPP + BegCostUPP;
                    END;
                END;


            }
            DataItem("IndirectCosts"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));
                DataItemLink = "Job No." = FIELD("No."),
                            "Budget Filter" = FIELD("Budget Filter");
                Column(J1_Ind; J1)
                {
                    //SourceExpr=J1;
                }
                Column(I1_Ind; I1)
                {
                    //SourceExpr=I1;
                }
                Column(BegCostInd; BegCostInd)
                {
                    //SourceExpr=BegCostInd;
                }
                Column(LastCostInd; LastCostInd)
                {
                    //SourceExpr=LastCostInd;
                }
                Column(MonthCostInd; MonthCostInd)
                {
                    //SourceExpr=MonthCostInd;
                }
                Column(PlannedBegCostInd; PlannedBegCostInd)
                {
                    //SourceExpr=PlannedBegCostInd;
                }
                Column(LastPlannedCostInd; LastPlannedCostInd)
                {
                    //SourceExpr=LastPlannedCostInd;
                }
                Column(PlannedMonthCostInd; PlannedMonthCostInd)
                {
                    //SourceExpr=PlannedMonthCostInd;
                }
                Column(TOTAL_INDIRECT_JOB_Lbl; TOTAL_INDIRECT_JOB_Lbl)
                {
                    //SourceExpr=TOTAL_INDIRECT_JOB_Lbl;
                }
                Column(JobNo_IndirectCosts; IndirectCosts."Job No.")
                {
                    //SourceExpr=IndirectCosts."Job No.";
                }
                Column(PieceworkCode_IndirectCosts; IndirectCosts."Piecework Code")
                {
                    //SourceExpr=IndirectCosts."Piecework Code";
                }
                Column(BudgetFilter_IndirectCosts; IndirectCosts."Budget Filter")
                {
                    //SourceExpr=IndirectCosts."Budget Filter" ;
                }
                //D2 triggers
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS(MonthCostInd, BegCostInd, PlannedMonthCostInd, PlannedBegCostInd);
                    CurrReport.CREATETOTALS(LastCostInd, LastPlannedCostInd);
                    CurrReport.CREATETOTALS(ExecJobMonthInd, ExecJobBegInd, LastExecJobInd);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    InitIndVariable;
                    SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"));
                    IF IndirectCosts."Account Type" = IndirectCosts."Account Type"::Unit THEN BEGIN
                        SETRANGE(IndirectCosts."Filter Date");
                        CALCFIELDS("Aver. Cost Price Pend. Budget");
                        CALCFIELDS(IndirectCosts."Budget Measure", IndirectCosts."Amount Production Budget");
                        ExpectedUnitCost := IndirectCosts."Aver. Cost Price Pend. Budget";
                        LastExpectedUnitCost := IndirectCosts."Aver. Cost Price Pend. Budget";

                        SETRANGE(IndirectCosts."Filter Date", DateFrom, DateTo);
                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                        CALCFIELDS("Budget Measure");
                        MeasurPerfMonthInd := "Total Measurement Production";
                        MonthCostInd := IndirectCosts."Amount Cost Performed (JC)";
                        PlannedMonthCostInd := ROUND(IndirectCosts."Total Measurement Production" * ExpectedUnitCost, 0.01);
                        ExecJobMonthInd := IndirectCosts."Amount Production Performed";

                        SETRANGE(IndirectCosts."Filter Date", 0D, DateTo);
                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed", "Amount Cost Budget (JC)");
                        CALCFIELDS("Budget Measure");
                        MeasurPerfBegInd := "Total Measurement Production";
                        BegCostInd := "Amount Cost Performed (JC)";
                        IF IndirectCosts."Total Measurement Production" <> 0 THEN
                            AverageCost := IndirectCosts."Amount Cost Budget (JC)" / IndirectCosts."Total Measurement Production"
                        ELSE
                            AverageCost := ExpectedUnitCost;

                        PlannedBegCostInd := ROUND("Total Measurement Production" * AverageCost, 0.01);
                        ExecJobBegInd := "Amount Production Performed";

                        IF Job."Reestimation Last Date" <> 0D THEN
                            SETRANGE(IndirectCosts."Filter Date", Job."Reestimation Last Date" + 1, DateTo)
                        ELSE
                            SETRANGE(IndirectCosts."Filter Date", 0D, DateTo);

                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                        CALCFIELDS("Budget Measure");
                        LastCostInd := "Amount Cost Performed (JC)";
                        LastPlannedCostInd := ROUND("Total Measurement Production" * ExpectedUnitCost, 0.01);
                        LastExecJobInd := "Amount Production Performed";

                        IF MeasurPerfMonthInd <> 0 THEN
                            E2 := ROUND((MonthCostInd / MeasurPerfMonthInd), 0.01)
                        ELSE
                            E2 := 0;

                        IF MeasurPerfBegInd <> 0 THEN
                            D2 := ROUND((BegCostInd / MeasurPerfBegInd), 0.01)
                        ELSE
                            D2 := 0;

                        I1 := -PlannedMonthCostInd + MonthCostInd;
                        J1 := -PlannedBegCostInd + BegCostInd;
                        I2 := -ExpectedUnitCost + E2;
                        I2 := -LastExpectedUnitCost + D2;

                    END ELSE BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", IndirectCosts."Job No.");
                        DataPieceworkForProduction.SETFILTER("Piecework Code", IndirectCosts.Totaling);
                        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Latest Reestimation Code");

                        IF DataPieceworkForProduction.FINDSET THEN
                            REPEAT
                                DataPieceworkForProduction.SETRANGE("Filter Date");
                                DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Budget Measure", DataPieceworkForProduction."Amount Production Budget",
                                                               DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                                ExpectedUnitCostUPP := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                                LastExpectedUnitCostUPP := DataPieceworkForProduction."Aver. Cost Price Pend. Budget";

                                DataPieceworkForProduction.SETRANGE("Filter Date", DateFrom, DateTo);
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                MonthCostIndUPP := MonthCostUPP + DataPieceworkForProduction."Amount Cost Performed (JC)";
                                PlannedMonthCostIndUPP := PlannedMonthCostIndUPP +
                                                            ROUND(DataPieceworkForProduction."Total Measurement Production" * ExpectedUnitCostUPP, 0.01);
                                ExecJobMonthIndUPP := ExecJobMonthIndUPP + DataPieceworkForProduction."Amount Production Performed";

                                DataPieceworkForProduction.SETRANGE("Filter Date", 0D, DateTo);
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                BegCostIndUPP := BegCostIndUPP + DataPieceworkForProduction."Amount Cost Performed (JC)";

                                IF DataPieceworkForProduction."Total Measurement Production" <> 0 THEN
                                    AverageCost := DataPieceworkForProduction."Amount Cost Budget (JC)" / DataPieceworkForProduction."Total Measurement Production"
                                ELSE
                                    AverageCost := ExpectedUnitCostUPP;

                                PlannedBegCostUPP := PlannedBegCostUPP +
                                                                ROUND(DataPieceworkForProduction."Total Measurement Production" * AverageCost, 0.01);
                                ExecJobBegIndUPP := ExecJobBegIndUPP + DataPieceworkForProduction."Amount Production Performed";

                                IF Job."Reestimation Last Date" <> 0D THEN
                                    DataPieceworkForProduction.SETRANGE("Filter Date", Job."Reestimation Last Date" + 1, DateTo)
                                ELSE
                                    DataPieceworkForProduction.SETRANGE("Filter Date", 0D, DateTo);

                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                LastCostIndUPP := LastCostIndUPP + DataPieceworkForProduction."Amount Cost Performed (JC)";
                                LastPlannedCostIndUPP := LastPlannedCostIndUPP +
                                                            ROUND(DataPieceworkForProduction."Total Measurement Production" * ExpectedUnitCostUPP, 0.01);
                                LastExecJobIndUPP := LastExecJobIndUPP + DataPieceworkForProduction."Amount Production Performed";
                            UNTIL DataPieceworkForProduction.NEXT = 0;

                        I1UPP := -PlannedMonthCostIndUPP + MonthCostIndUPP;
                        J1UPP := -PlannedBegCostUPP + BegCostIndUPP;
                    END;
                END;


            }
            //Job Triggers
            trigger OnPreDataItem();
            BEGIN
                Year := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 3);
                Month := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 2);

                IF (Year = 0) OR (Month = 0) THEN
                    ERROR(Text50000);

                DateFrom := DMY2DATE(1, Month, Year);
                DateTo := CALCDATE('PM', DateFrom);

                CurrReport.CREATETOTALS(MonthCost, BegCost, PlannedMonthCost, PlannedBegCostInd);
                CurrReport.CREATETOTALS(LastCost, LastPlannedCost);
                CurrReport.CREATETOTALS(ExecJobMonth, ExecJobBeg, LastExecJob);
                CurrReport.CREATETOTALS(MonthCostInd, BegCostInd, PlannedMonthCostInd, PlannedBegCostInd);
                CurrReport.CREATETOTALS(LastCostInd, LastPlannedCostInd);
                CurrReport.CREATETOTALS(ExecJobMonthInd, ExecJobBegInd, LastExecJobInd);
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                SETFILTER("Budget Filter", Job."Current Piecework Budget");
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
        //       LastFieldNo@7001167 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001166 :
        FooterPrinted: Boolean;
        //       Year@7001165 :
        Year: Integer;
        //       Month@7001164 :
        Month: Integer;
        //       DateFrom@7001163 :
        DateFrom: Date;
        //       DateTo@7001162 :
        DateTo: Date;
        //       MeasurPerformMonth@7001161 :
        MeasurPerformMonth: Decimal;
        //       MeasurPerformBeg@7001160 :
        MeasurPerformBeg: Decimal;
        //       TotalBudgetMeasur@7001159 :
        TotalBudgetMeasur: Decimal;
        //       MonthCost@7001158 :
        MonthCost: Decimal;
        //       BegCost@7001157 :
        BegCost: Decimal;
        //       PlannedMonthCost@7001156 :
        PlannedMonthCost: Decimal;
        //       PlannedBegCost@7001155 :
        PlannedBegCost: Decimal;
        //       ExecJobMonth@7001154 :
        ExecJobMonth: Decimal;
        //       ExecJobBeg@7001153 :
        ExecJobBeg: Decimal;
        //       ExpectedUnitCost@7001152 :
        ExpectedUnitCost: Decimal;
        //       LastExpectedUnitCost@7001151 :
        LastExpectedUnitCost: Decimal;
        //       MeasurePerc@7001150 :
        MeasurePerc: Decimal;
        //       E2@7001149 :
        E2: Decimal;
        //       EULT@7001148 :
        EULT: Decimal;
        //       D2@7001147 :
        D2: Decimal;
        //       F2@7001146 :
        F2: Decimal;
        //       G2@7001145 :
        G2: Decimal;
        //       I1@7001144 :
        I1: Decimal;
        //       I2@7001143 :
        I2: Decimal;
        //       J1@7001142 :
        J1: Decimal;
        //       J2@7001141 :
        J2: Decimal;
        //       CompanyInformation@7001140 :
        CompanyInformation: Record 79;
        //       TotalBudgetMeasurUPP@7001139 :
        TotalBudgetMeasurUPP: Decimal;
        //       MonthCostUPP@7001138 :
        MonthCostUPP: Decimal;
        //       BegCostUPP@7001137 :
        BegCostUPP: Decimal;
        //       PlannedMonthCostUPP@7001136 :
        PlannedMonthCostUPP: Decimal;
        //       PlannedBegCostUPP@7001135 :
        PlannedBegCostUPP: Decimal;
        //       ExecJobMonthUPP@7001134 :
        ExecJobMonthUPP: Decimal;
        //       ExecJobBegUPP@7001133 :
        ExecJobBegUPP: Decimal;
        //       ExpectedUnitCostUPP@7001132 :
        ExpectedUnitCostUPP: Decimal;
        //       LastExpectedUnitCostUPP@7001131 :
        LastExpectedUnitCostUPP: Decimal;
        //       I1UPP@7001130 :
        I1UPP: Decimal;
        //       J1UPP@7001129 :
        J1UPP: Decimal;
        //       DataPieceworkForProduction@7001128 :
        DataPieceworkForProduction: Record 7207386;
        //       LastMeasurPerf@7001127 :
        LastMeasurPerf: Decimal;
        //       LastCost@7001126 :
        LastCost: Decimal;
        //       LastPlannedCost@7001125 :
        LastPlannedCost: Decimal;
        //       LastExecJob@7001124 :
        LastExecJob: Decimal;
        //       AverageCost@7001123 :
        AverageCost: Decimal;
        //       LastCostUPP@7001122 :
        LastCostUPP: Decimal;
        //       LastPlannedCostUPP@7001121 :
        LastPlannedCostUPP: Decimal;
        //       LastExecJobUPP@7001120 :
        LastExecJobUPP: Decimal;
        //       MonthCostInd@7001119 :
        MonthCostInd: Decimal;
        //       BegCostInd@7001118 :
        BegCostInd: Decimal;
        //       PlannedMonthCostInd@7001117 :
        PlannedMonthCostInd: Decimal;
        //       PlannedBegCostInd@7001116 :
        PlannedBegCostInd: Decimal;
        //       ExecJobMonthInd@7001115 :
        ExecJobMonthInd: Decimal;
        //       ExecJobBegInd@7001114 :
        ExecJobBegInd: Decimal;
        //       LastCostInd@7001113 :
        LastCostInd: Decimal;
        //       LastPlannedCostInd@7001112 :
        LastPlannedCostInd: Decimal;
        //       LastExecJobInd@7001111 :
        LastExecJobInd: Decimal;
        //       MonthCostIndUPP@7001110 :
        MonthCostIndUPP: Decimal;
        //       BegCostIndUPP@7001109 :
        BegCostIndUPP: Decimal;
        //       PlannedMonthCostIndUPP@7001108 :
        PlannedMonthCostIndUPP: Decimal;
        //       PlannedBegCostIndUPP@7001107 :
        PlannedBegCostIndUPP: Decimal;
        //       ExecJobMonthIndUPP@7001106 :
        ExecJobMonthIndUPP: Decimal;
        //       ExecJobBegIndUPP@7001105 :
        ExecJobBegIndUPP: Decimal;
        //       LastCostIndUPP@7001104 :
        LastCostIndUPP: Decimal;
        //       LastPlannedCostIndUPP@7001103 :
        LastPlannedCostIndUPP: Decimal;
        //       LastExecJobIndUPP@7001102 :
        LastExecJobIndUPP: Decimal;
        //       MeasurPerfMonthInd@7001101 :
        MeasurPerfMonthInd: Decimal;
        //       MeasurPerfBegInd@7001100 :
        MeasurPerfBegInd: Decimal;
        //       Text50000@7001199 :
        Text50000: TextConst ENU = 'You must indicate Year and Month of Job', ESP = 'Debe indicar a¤o y mes del informe de obra';
        //       GrandTotal_Lbl@7001198 :
        GrandTotal_Lbl: TextConst ENU = 'GRAND TOTAL', ESP = 'TOTAL GENERAL';
        //       REALCOSTJOB_Lbl@7001197 :
        REALCOSTJOB_Lbl: TextConst ENU = 'REAL COST OF JOB', ESP = 'COSTE REAL DE OBRA';
        //       Page_Lbl@7001196 :
        Page_Lbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       FINALSUMMARY_Lbl@7001195 :
        FINALSUMMARY_Lbl: TextConst ENU = 'FINAL SUMMARY', ESP = 'RESUMEN FINAL';
        //       JOB__Lbl@7001194 :
        JOB__Lbl: TextConst ENU = 'JOB:', ESP = 'OBRA:';
        //       YEAR__Lbl@7001193 :
        YEAR__Lbl: TextConst ENU = 'YEAR:', ESP = 'A¥O:';
        //       MONTH__Lbl@7001192 :
        MONTH__Lbl: TextConst ENU = 'MONTH:', ESP = 'MES:';
        //       PLANNING_Lbl@7001191 :
        PLANNING_Lbl: TextConst ENU = 'PLANNING', ESP = 'PLANIFICACIàN';
        //       OPERATION_Lbl@7001190 :
        OPERATION_Lbl: TextConst ENU = 'OPERATION', ESP = 'OPERACION';
        //       UN_Lbl@7001189 :
        UN_Lbl: TextConst ENU = 'UN', ESP = 'UD';
        //       DESCRIPTION_Lbl@7001188 :
        DESCRIPTION_Lbl: TextConst ENU = 'DESCRIPTION', ESP = 'DESCRIPCIàN';
        //       MonthLbl@7001187 :
        MonthLbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       EXECUTED_PERC_Lbl@7001186 :
        EXECUTED_PERC_Lbl: TextConst ENU = 'EXECUTED % ', ESP = '% REALIZADO';
        //       BEGINNINGLbl@7001184 :
        BEGINNINGLbl: TextConst ENU = 'BEGINNING', ESP = 'ORIGEN';
        //       EXECUTED_Lbl@7001183 :
        EXECUTED_Lbl: TextConst ENU = 'EXECUTED', ESP = 'REALIZADO';
        //       EXECJOB__SALEPRICE_Lbl@7001182 :
        EXECJOB__SALEPRICE_Lbl: TextConst ENU = 'EXECUTED JOB/ SALE PRICE', ESP = 'OBRA EJECUTADA/ PRECIO VENTA';
        //       DEVIATION_COST_PLANNEDPERC_Lbl@7001179 :
        DEVIATION_COST_PLANNEDPERC_Lbl: TextConst ENU = 'DEVIATION COST/ PLANNED %', ESP = 'DESVIACION COSTE/ %PLANIFICADO';
        //       DIRECTTOTALCOST_UNITARY_Lbl@7001178 :
        DIRECTTOTALCOST_UNITARY_Lbl: TextConst ENU = 'TOTAL DIRECT COST/ UNITARY', ESP = 'COSTE DIRECTO TOTAL / UNITARIO';
        //       TOTALVOL_Lbl@7001177 :
        TOTALVOL_Lbl: TextConst ENU = 'TOTAL VOL.', ESP = 'VOL. TOTAL';
        //       LAST_Lbl@7001175 :
        LAST_Lbl: TextConst ENU = 'LAST', ESP = 'éLTIMO';
        //       TOTAL_DIRECT_JOB_Lbl@7001169 :
        TOTAL_DIRECT_JOB_Lbl: TextConst ENU = 'DIRECT TOTAL JOB', ESP = 'TOTAL DIRECTOS OBRA';
        //       TOTAL_INDIRECT_JOB_Lbl@7001168 :
        TOTAL_INDIRECT_JOB_Lbl: TextConst ENU = 'INDIRECT TOTAL JOB', ESP = 'TOTAL INDIRECTOS OBRA';

    procedure InitVariable()
    begin
        MeasurPerformMonth := 0;
        MeasurPerformBeg := 0;
        TotalBudgetMeasur := 0;
        MonthCost := 0;
        BegCost := 0;
        LastCost := 0;
        PlannedMonthCost := 0;
        PlannedBegCostInd := 0;
        LastPlannedCost := 0;
        ExecJobMonth := 0;
        ExecJobBeg := 0;
        LastExecJob := 0;
        ExpectedUnitCost := 0;
        LastExpectedUnitCost := 0;
        MeasurePerc := 0;
        I2 := 0;
        J1 := 0;
        I1 := 0;
        I2 := 0;
        E2 := 0;
        F2 := 0;
        G2 := 0;
        D2 := 0;
        TotalBudgetMeasurUPP := 0;
        MonthCostUPP := 0;
        BegCostUPP := 0;
        LastCostUPP := 0;
        PlannedMonthCostUPP := 0;
        PlannedBegCostIndUPP := 0;
        LastPlannedCostUPP := 0;
        ExecJobMonthUPP := 0;
        ExecJobBegUPP := 0;
        LastExecJobUPP := 0;
        ExpectedUnitCostUPP := 0;
        LastExpectedUnitCostUPP := 0;
        I1UPP := 0;
        J1UPP := 0;
    end;

    procedure InitIndVariable()
    begin
        MonthCostInd := 0;
        BegCostInd := 0;
        PlannedMonthCostInd := 0;
        PlannedBegCostInd := 0;
        ExecJobMonthInd := 0;
        ExecJobBegInd := 0;
        LastCostInd := 0;
        LastPlannedCostInd := 0;
        LastExecJobInd := 0;
        MonthCostIndUPP := 0;
        BegCostIndUPP := 0;
        PlannedMonthCostIndUPP := 0;
        PlannedBegCostUPP := 0;
        ExecJobMonthIndUPP := 0;
        ExecJobBegIndUPP := 0;
        LastCostIndUPP := 0;
        LastPlannedCostIndUPP := 0;
        LastExecJobIndUPP := 0;
    end;

    //     procedure CalculateAverageCost (PADataPieceworkForProduction@1100000 :
    procedure CalculateAverageCost(PADataPieceworkForProduction: Record 7207386): Decimal;
    var
        //       LOTotalMeasurement@1100001 :
        LOTotalMeasurement: Decimal;
        //       LODataCostByPiecework@1100002 :
        LODataCostByPiecework: Record 7207387;
        //       LODimensionValue@1100003 :
        LODimensionValue: Record 349;
        //       CUFunctionQB@1100004 :
        CUFunctionQB: Codeunit 7207272;
        //       MaxDate@1100005 :
        MaxDate: Date;
        //       InitialAmount@1100006 :
        InitialAmount: Decimal;
        //       Reestimation@1100007 :
        Reestimation: Boolean;
        //       LODimensionValue2@1100008 :
        LODimensionValue2: Record 349;
        //       LOToDate@1100009 :
        LOToDate: Date;
    begin

        LOTotalMeasurement := PADataPieceworkForProduction."Total Measurement Production";
        LODataCostByPiecework.SETCURRENTKEY("Job No.", "Piecework Code", "Cod. Budget");
        LODataCostByPiecework.SETRANGE("Job No.", PADataPieceworkForProduction."Job No.");
        LODataCostByPiecework.SETRANGE("Piecework Code", PADataPieceworkForProduction."Piecework Code");
        LODataCostByPiecework.SETFILTER("Cod. Budget", '<>%1', '');

        if LODataCostByPiecework.FINDFIRST then begin
            LODimensionValue.SETRANGE("Dimension Code", CUFunctionQB.ReturnDimReest);
            LODimensionValue.SETRANGE(Code, LODataCostByPiecework."Cod. Budget");

            if LODimensionValue.FINDFIRST then begin
                Reestimation := TRUE;
                MaxDate := LODimensionValue."Reestimation Date";
            end else
                MaxDate := DateTo;
        end else
            MaxDate := DateTo;

        PADataPieceworkForProduction.SETRANGE("Budget Filter", '');
        PADataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
        PADataPieceworkForProduction.SETRANGE("Filter Date", 0D, MaxDate);
        PADataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
        InitialAmount := PADataPieceworkForProduction."Total Measurement Production" * PADataPieceworkForProduction."Aver. Cost Price Pend. Budget";

        if Reestimation then begin
            LODimensionValue.RESET;
            LODimensionValue.SETRANGE("Dimension Code", CUFunctionQB.ReturnDimReest); //---------------------
            LODimensionValue.SETFILTER(Code, '>=%1', LODataCostByPiecework."Cod. Budget");

            if LODimensionValue.FINDSET then
                repeat
                    LODataCostByPiecework.SETRANGE("Cod. Budget", LODimensionValue.Code);

                    if LODataCostByPiecework.FINDFIRST then begin
                        PADataPieceworkForProduction.SETRANGE("Budget Filter", LODimensionValue.Code);
                        PADataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                        LODimensionValue2 := LODimensionValue;
                        LODimensionValue2.COPYFILTERS(LODimensionValue);

                        if LODimensionValue2.NEXT <> 0 then begin
                            if LODimensionValue2."Reestimation Date" > DateTo then
                                LOToDate := DateTo
                            else
                                LOToDate := LODimensionValue2."Reestimation Date";
                        end else begin
                            LOToDate := DateTo;
                        end;

                        PADataPieceworkForProduction.SETRANGE("Filter Date", MaxDate + 1, LOToDate);
                        PADataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                        InitialAmount := InitialAmount + (PADataPieceworkForProduction."Total Measurement Production" *
                                            PADataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                        MaxDate := LOToDate;
                    end;
                until LODimensionValue.NEXT = 0;
        end;

        if LOTotalMeasurement <> 0 then
            exit(InitialAmount / LOTotalMeasurement)
        else
            exit(0);
    end;

    /*begin
    end.
  */

}



