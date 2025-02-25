report 7207390 "Job Actual Cost"
{


    CaptionML = ENU = 'Job Actual Cost', ESP = 'Coste Real de Obra';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Posting Date Filter";
            Column(decPlannedMonthCost; decPlannedMonthCost)
            {
                //SourceExpr=decPlannedMonthCost;
            }
            Column(decLastCostPlanned; decLastCostPlanned)
            {
                //SourceExpr=decLastCostPlanned;
            }
            Column(decPlannedOriginCost; decPlannedOriginCost)
            {
                //SourceExpr=decPlannedOriginCost;
            }
            Column(decCostMonth; decCostMonth)
            {
                //SourceExpr=decCostMonth;
            }
            Column(decLastCost; decLastCost)
            {
                //SourceExpr=decLastCost;
            }
            Column(decCostOrigin; decCostOrigin)
            {
                //SourceExpr=decCostOrigin;
            }
            Column(decOexecutedMonth; decOexecutedMonth)
            {
                //SourceExpr=decOexecutedMonth;
            }
            Column(decOexecutedOrigin; decOexecutedOrigin)
            {
                //SourceExpr=decOexecutedOrigin;
            }
            Column(decJ1; decJ1)
            {
                //SourceExpr=decJ1;
            }
            Column(decI1; decI1)
            {
                //SourceExpr=decI1;
            }
            Column(GENERALTOTALCaptionLbl; GENERAL_TOTALCaptionLbl)
            {
                //SourceExpr=GENERAL_TOTALCaptionLbl;
            }
            Column(Job_No; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Type" = CONST("Piecework"), "Production Unit" = CONST(true));


                RequestFilterFields = "Piecework Code";
                DataItemLink = "Job No." = FIELD("No.");
                Column(AccountType_DataPieceworkForProduction; "Account Type")
                {
                    //SourceExpr="Account Type";
                }
                Column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(PictureCompany; CompanyInformation.Picture)
                {
                    //SourceExpr=CompanyInformation.Picture;
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(CurrReportPAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(JobNoJobDesc; Job."No." + ' ' + Job.Description + Job."Description 2")
                {
                    //SourceExpr=Job."No." + ' ' + Job.Description + Job."Description 2";
                }
                Column(IntAge; IntAge)
                {
                    //SourceExpr=IntAge;
                }
                Column(IntMonth; IntMonth)
                {
                    //SourceExpr=IntMonth;
                }
                Column(Picture; CompanyInformation.Picture)
                {
                    //SourceExpr=CompanyInformation.Picture;
                }
                Column(COPYSTR_Spaces_1_Indentation2__DPFP_Description; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2")
                {
                    //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
                }
                Column(COPYSTR_Spaces__Indentation2__PieceworkCode; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                {
                    //SourceExpr=COPYSTR(Spaces,1,Indentation*2) + "Piecework Code";
                }
                Column(UnitJobHijoPieceworkCode; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(UnitJobHijoDescription; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Indentation; Indentation)
                {
                    //SourceExpr=Indentation;
                }
                Column(decPlannedMonthCostMAY; decPlannedMonthCostMAY)
                {
                    //SourceExpr=decPlannedMonthCostMAY;
                }
                Column(decPlannedOriginCostMAY; decPlannedOriginCostMAY)
                {
                    //SourceExpr=decPlannedOriginCostMAY;
                }
                Column(decCostMonthMAY; decCostMonthMAY)
                {
                    //SourceExpr=decCostMonthMAY;
                }
                Column(decCostOriginMAY; decCostOriginMAY)
                {
                    //SourceExpr=decCostOriginMAY;
                }
                Column(decOexecutedMonthMAY; decOexecutedMonthMAY)
                {
                    //SourceExpr=decOexecutedMonthMAY;
                }
                Column(decOexecutedOriginMAY; decOexecutedOriginMAY)
                {
                    //SourceExpr=decOexecutedOriginMAY;
                }
                Column(decI1MAY; decI1MAY)
                {
                    //SourceExpr=decI1MAY;
                }
                Column(decJ1MAY; decJ1MAY)
                {
                    //SourceExpr=decJ1MAY;
                }
                Column(decLastCostPlannedMAY; decLastCostPlannedMAY)
                {
                    //SourceExpr=decLastCostPlannedMAY;
                }
                Column(decLastCostMAY; decLastCostMAY)
                {
                    //SourceExpr=decLastCostMAY;
                }
                Column(decI2MAY; decI2MAY)
                {
                    //SourceExpr=decI2MAY;
                }
                Column(decJ2MAY; decJ2MAY)
                {
                    //SourceExpr=decJ2MAY;
                }
                Column(UnitJobHijoPieceworkCode_Control1100251011; UnitJobHijo."Piecework Code")
                {
                    //SourceExpr=UnitJobHijo."Piecework Code";
                }
                Column(UnitJobHijoUnitOfMeasure; UnitJobHijo."Unit Of Measure")
                {
                    //SourceExpr=UnitJobHijo."Unit Of Measure";
                }
                Column(UnitJobHijoDescription_Control1100251017; UnitJobHijo.Description)
                {
                    //SourceExpr=UnitJobHijo.Description;
                }
                Column(decMeasurementperformedmonth; decMeasurementperformedmonth)
                {
                    //SourceExpr=decMeasurementperformedmonth;
                }
                Column(decPercentageMeasurement; decPercentageMeasurement)
                {
                    //SourceExpr=decPercentageMeasurement;
                }
                Column(decPlannedMonthCost_Control1100251023; decPlannedMonthCost)
                {
                    //SourceExpr=decPlannedMonthCost;
                }
                Column(decAvgCost; decAvgCost)
                {
                    //SourceExpr=decAvgCost;
                }
                Column(decCostMonth_Control1100251026; decCostMonth)
                {
                    //SourceExpr=decCostMonth;
                }
                Column(decOexecutedMonth_Control1100251028; decOexecutedMonth)
                {
                    //SourceExpr=decOexecutedMonth;
                }
                Column(decUnitCostPrev; decUnitCostPrev)
                {
                    //SourceExpr=decUnitCostPrev;
                }
                Column(decMeasurementBudgetTotal; decMeasurementBudgetTotal)
                {
                    //SourceExpr=decMeasurementBudgetTotal;
                }
                Column(decPlannedOriginCost_Control1100251104; decPlannedOriginCost)
                {
                    //SourceExpr=decPlannedOriginCost;
                }
                Column(decCostOrigin_Control1100251105; decCostOrigin)
                {
                    //SourceExpr=decCostOrigin;
                }
                Column(decOexecutedOrigin_Control1100251106; decOexecutedOrigin)
                {
                    //SourceExpr=decOexecutedOrigin;
                }
                Column(decE2; decE2)
                {
                    //SourceExpr=decE2;
                }
                Column(decD2; decD2)
                {
                    //SourceExpr=decD2;
                }
                Column(decF2; decF2)
                {
                    //SourceExpr=decF2;
                }
                Column(decG2; decG2)
                {
                    //SourceExpr=decG2;
                }
                Column(decI1_Control1100251109; decI1)
                {
                    //SourceExpr=decI1;
                }
                Column(decI2; decI2)
                {
                    //SourceExpr=decI2;
                }
                Column(decJ1_Control1100251111; decJ1)
                {
                    //SourceExpr=decJ1;
                }
                Column(decJ2; decJ2)
                {
                    //SourceExpr=decJ2;
                }
                Column(decMeasurementperformedOrigin; decMeasurementperformedOrigin)
                {
                    //SourceExpr=decMeasurementperformedOrigin;
                }
                Column(decUnitCostPrev_Control1100024; decUnitCostPrev)
                {
                    //SourceExpr=decUnitCostPrev;
                }
                Column(decLastCostPlanned_Control1100025; decLastCostPlanned)
                {
                    //SourceExpr=decLastCostPlanned;
                }
                Column(decEULT; decEULT)
                {
                    //SourceExpr=decEULT;
                }
                Column(decLastCost_Control1100027; decLastCost)
                {
                    //SourceExpr=decLastCost;
                }
                Column(decPlannedMonthCost_Control1100251063; decPlannedMonthCost)
                {
                    //SourceExpr=decPlannedMonthCost;
                }
                Column(decPlannedOriginCost_Control1100251064; decPlannedOriginCost)
                {
                    //SourceExpr=decPlannedOriginCost;
                }
                Column(decCostMonth_Control1100251065; decCostMonth)
                {
                    //SourceExpr=decCostMonth;
                }
                Column(decCostOrigin_Control1100251066; decCostOrigin)
                {
                    //SourceExpr=decCostOrigin;
                }
                Column(decOexecutedMonth_Control1100251067; decOexecutedMonth)
                {
                    //SourceExpr=decOexecutedMonth;
                }
                Column(decOexecutedOrigin_Control1100251068; decOexecutedOrigin)
                {
                    //SourceExpr=decOexecutedOrigin;
                }
                Column(decI1_Control1100251069; decI1)
                {
                    //SourceExpr=decI1;
                }
                Column(decJ1_Control1100251070; decJ1)
                {
                    //SourceExpr=decJ1;
                }
                Column(decLastCostPlanned_Control1100029; decLastCostPlanned)
                {
                    //SourceExpr=decLastCostPlanned;
                }
                Column(decLastCost_Control1100030; decLastCost)
                {
                    //SourceExpr=decLastCost;
                }
                Column(REAL_COST_OF_JOBCaptionLbl; REAL_COST_OF_JOBCaptionLbl)
                {
                    //SourceExpr=REAL_COST_OF_JOBCaptionLbl;
                }
                Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(DIRECT_COSTCaptionLbl; DIRECT_COSTCaptionLbl)
                {
                    //SourceExpr=DIRECT_COSTCaptionLbl;
                }
                Column(Job__No___________Job_DescriptionCaptionLbl; Job__No___________Job_DescriptionCaptionLbl)
                {
                    //SourceExpr=Job__No___________Job_DescriptionCaptionLbl;
                }
                Column(AGE_CaptionLbl; AGE_CaptionLbl)
                {
                    //SourceExpr=AGE_CaptionLbl;
                }
                Column(MONTH_CaptionLbl; MONTH_CaptionLbl)
                {
                    //SourceExpr=MONTH_CaptionLbl;
                }
                Column(PLANNEDCaptionLbl; PLANNEDCaptionLbl)
                {
                    //SourceExpr=PLANNEDCaptionLbl;
                }
                Column(OPERATIONCaptionLbl; OPERATIONCaptionLbl)
                {
                    //SourceExpr=OPERATIONCaptionLbl;
                }
                Column(UDCaptionLbl; UDCaptionLbl)
                {
                    //SourceExpr=UDCaptionLbl;
                }
                Column(DESCRIPTIONCaptionLbl; DESCRIPTIONCaptionLbl)
                {
                    //SourceExpr=DESCRIPTIONCaptionLbl;
                }
                Column(MONTHCaptionLbl; MONTHCaptionLbl)
                {
                    //SourceExpr=MONTHCaptionLbl;
                }
                Column(COMPLETEDCaptionLbl; COMPLETEDCaptionLbl)
                {
                    //SourceExpr=COMPLETEDCaptionLbl;
                }
                Column(MONTHCaption_Control1100251016Lbl; MONTHCaption_Control1100251016Lbl)
                {
                    //SourceExpr=MONTHCaption_Control1100251016Lbl;
                }
                Column(ORIGINCaptionLbl; ORIGINCaptionLbl)
                {
                    //SourceExpr=ORIGINCaptionLbl;
                }
                Column(COMPLETEDCaption_Control1100251021Lbl; COMPLETEDCaption_Control1100251021Lbl)
                {
                    //SourceExpr=COMPLETEDCaption_Control1100251021Lbl;
                }
                Column(JOB_EXECUTED__SALES_PRICECaptionLbl; JOB_EXECUTED__SALES_PRICECaptionLbl)
                {
                    //SourceExpr=JOB_EXECUTED__SALES_PRICECaptionLbl;
                }
                Column(MONTHCaption_Control1100251029Lbl; MONTHCaption_Control1100251029Lbl)
                {
                    //SourceExpr=MONTHCaption_Control1100251029Lbl;
                }
                Column(ORIGINCaption_Control1100251030Lbl; ORIGINCaption_Control1100251030Lbl)
                {
                    //SourceExpr=ORIGINCaption_Control1100251030Lbl;
                }
                Column(COST_DESVIATION___PLANNEDCaptionLbl; COST_DESVIATION___PLANNEDCaptionLbl)
                {
                    //SourceExpr=COST_DESVIATION___PLANNEDCaptionLbl;
                }
                Column(TOTAL_UNITARY_DIRECT_COSTCaptionLbl; "TOTAL/UNITARY_DIRECT_COSTCaptionLbl")
                {
                    //SourceExpr="TOTAL/UNITARY_DIRECT_COSTCaptionLbl";
                }
                Column(VOL__TOTALCaptionLbl; VOL__TOTALCaptionLbl)
                {
                    //SourceExpr=VOL__TOTALCaptionLbl;
                }
                Column(ORIGINCaption_Control1100251127Lbl; ORIGINCaption_Control1100251127Lbl)
                {
                    //SourceExpr=ORIGINCaption_Control1100251127Lbl;
                }
                Column(LASTCaptionLbl; LASTCaptionLbl)
                {
                    //SourceExpr=LASTCaptionLbl;
                }
                Column(LASTCaption_Control1100015Lbl; LASTCaption_Control1100015Lbl)
                {
                    //SourceExpr=LASTCaption_Control1100015Lbl;
                }
                Column(ORIGINCaption_Control1100016Lbl; ORIGINCaption_Control1100016Lbl)
                {
                    //SourceExpr=ORIGINCaption_Control1100016Lbl;
                }
                Column(MONTHCaption_Control1100017Lbl; MONTHCaption_Control1100017Lbl)
                {
                    //SourceExpr=MONTHCaption_Control1100017Lbl;
                }
                Column(MONTHCaption_Control1100020Lbl; MONTHCaption_Control1100020Lbl)
                {
                    //SourceExpr=MONTHCaption_Control1100020Lbl;
                }
                Column(ORIGINCaption_Control1100022Lbl; ORIGINCaption_Control1100022Lbl)
                {
                    //SourceExpr=ORIGINCaption_Control1100022Lbl;
                }
                Column(DIRECT_JOB_TOTALCaptionLbl; DIRECT_JOB_TOTALCaptionLbl)
                {
                    //SourceExpr=DIRECT_JOB_TOTALCaptionLbl;
                }
                Column(DataPieceworkForProductionJobNo; "Data Piecework For Production"."Job No.")
                {
                    //SourceExpr="Data Piecework For Production"."Job No.";
                }
                Column(Med_Periodo_Lbl; Med_Periodo_Lbl)
                {
                    //SourceExpr=Med_Periodo_Lbl;
                }
                Column(Med_Origen_Lbl; Med_Origen_Lbl)
                {
                    //SourceExpr=Med_Origen_Lbl;
                }
                Column(Produccion_Lbl; Produccion_Lbl)
                {
                    //SourceExpr=Produccion_Lbl;
                }
                Column(Desviacion_Lbl; Desviacion_Lbl)
                {
                    //SourceExpr=Desviacion_Lbl;
                }
                Column(Planification_Importe_Lbl; Planification_Importe_Lbl)
                {
                    //SourceExpr=Planification_Importe_Lbl;
                }
                Column(Planification_Porc_Planif_Lbl; Planification_Porc_Planif_Lbl)
                {
                    //SourceExpr=Planification_Porc_Planif_Lbl;
                }
                Column(Completed_Importe_Lbl; Completed_Importe_Lbl)
                {
                    //SourceExpr=Completed_Importe_Lbl;
                }
                Column(Completed_porc_Complet_Lbl; Completed_porc_Complet_Lbl)
                {
                    //SourceExpr=Completed_porc_Complet_Lbl;
                }
                Column(Prod_Prec_Venta_Lbl; Prod_Prec_Venta_Lbl)
                {
                    //SourceExpr=Prod_Prec_Venta_Lbl ;
                }
                trigger OnPreDataItem();
                BEGIN
                    LastFieldNo := FIELDNO("Job No.");

                    CurrReport.CREATETOTALS(decCostMonth, decCostOrigin, decPlannedMonthCost, decPlannedOriginCost);
                    CurrReport.CREATETOTALS(decLastCost, decLastCostPlanned);
                    CurrReport.CREATETOTALS(decOexecutedMonth, decOexecutedOrigin, decOLastExecuted);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    FunInitVar;
                    IF "Account Type" = "Account Type"::Unit THEN BEGIN
                        SETRANGE("Filter Date");
                        SETRANGE("Budget Filter", codeBudgetInProgress);

                        CALCFIELDS("Aver. Cost Price Pend. Budget", "Budget Measure", "Amount Production Budget");

                        decMeasurementBudgetTotal := "Budget Measure";
                        IF dateUntil > recBudgetJob."Budget Date" THEN
                            decUnitCostPrev := "Aver. Cost Price Pend. Budget"
                        ELSE BEGIN
                            decUnitCostPrev := FunSearchProvided("Data Piecework For Production");
                        END;
                        //de momento son iguales pero hay que buscar formula de ultimo
                        decUnitCostPrevLast := "Aver. Cost Price Pend. Budget";

                        SETRANGE("Filter Date", dateSince, dateUntil);

                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");

                        CALCFIELDS("Budget Measure");

                        decMeasurementperformedmonth := "Total Measurement Production";
                        decCostMonth := "Amount Cost Performed (JC)";
                        decPlannedMonthCost := ROUND("Total Measurement Production" * decUnitCostPrev, 0.01);
                        decOexecutedMonth := "Amount Production Performed";

                        SETRANGE("Filter Date", 0D, dateUntil);

                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed", "Amount Cost Budget (JC)");
                        CALCFIELDS("Budget Measure");

                        decMeasurementperformedOrigin := "Total Measurement Production";
                        decCostOrigin := "Amount Cost Performed (JC)";
                        IF "Total Measurement Production" <> 0 THEN
                            decAvgCost := FunCalcAvgCost("Data Piecework For Production")
                        ELSE
                            decAvgCost := decUnitCostPrev;
                        decPlannedOriginCost := ROUND("Total Measurement Production" * decAvgCost, 0.01);
                        decOexecutedOrigin := "Amount Production Performed";

                        SETRANGE("Filter Date", 0D, dateSince - 1);

                        CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                        CALCFIELDS("Budget Measure");

                        decLastMeasurementPerformed := "Total Measurement Production";
                        decLastCost := "Amount Cost Performed (JC)";
                        decLastCostPlanned := ROUND("Total Measurement Production" * decUnitCostPrev, 0.01);
                        decOLastExecuted := "Amount Production Performed";

                        IF decMeasurementperformedmonth <> 0 THEN
                            decE2 := ROUND((decCostMonth / decMeasurementperformedmonth), 0.01)
                        ELSE
                            decE2 := 0;

                        IF decLastMeasurementPerformed <> 0 THEN
                            decEULT := ROUND((decLastCost / decLastMeasurementPerformed), 0.01)
                        ELSE
                            decEULT := 0;

                        IF decMeasurementperformedOrigin <> 0 THEN
                            decD2 := ROUND((decCostOrigin / decMeasurementperformedOrigin), 0.01)
                        ELSE
                            decD2 := 0;

                        IF decMeasurementperformedOrigin <> 0 THEN
                            decF2 := ROUND((decOexecutedOrigin / decMeasurementperformedOrigin), 0.01)
                        ELSE
                            decF2 := 0;

                        IF decMeasurementperformedmonth <> 0 THEN
                            decG2 := ROUND((decOexecutedMonth / decMeasurementperformedmonth), 0.01)
                        ELSE
                            decG2 := 0;

                        decI1 := -decPlannedMonthCost + decCostMonth;
                        decJ1 := -decPlannedOriginCost + decCostOrigin;
                        IF decPlannedMonthCost <> 0 THEN
                            decI2 := ((decCostMonth / decPlannedMonthCost) - 1) * 100
                        ELSE
                            decI2 := 0;

                        IF decPlannedOriginCost <> 0 THEN
                            decJ2 := ((decCostOrigin / decPlannedOriginCost) - 1) * 100
                        ELSE
                            decJ2 := 0;

                        IF decMeasurementBudgetTotal <> 0 THEN
                            decPercentageMeasurement := ROUND(decMeasurementperformedOrigin * 100 / decMeasurementBudgetTotal, 0.01)
                        ELSE
                            decPercentageMeasurement := 0;
                    END ELSE BEGIN
                        UnitJobHijo.RESET;
                        UnitJobHijo.SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
                        UnitJobHijo.SETFILTER("Piecework Code", "Data Piecework For Production".Totaling);
                        UnitJobHijo.SETRANGE("Account Type", UnitJobHijo."Account Type"::Unit);
                        UnitJobHijo.SETRANGE("Budget Filter", codeBudgetInProgress);
                        IF UnitJobHijo.FINDSET THEN
                            REPEAT
                                UnitJobHijo.SETRANGE("Filter Date");
                                UnitJobHijo.CALCFIELDS(UnitJobHijo."Budget Measure", UnitJobHijo."Amount Production Budget",
                                                               UnitJobHijo."Aver. Cost Price Pend. Budget");
                                decMeasurementBudgetTotalMAY := decMeasurementBudgetTotalMAY + UnitJobHijo."Budget Measure";
                                IF dateUntil > recBudgetJob."Budget Date" THEN
                                    decUnitCostPrevMAY := UnitJobHijo."Aver. Cost Price Pend. Budget"
                                ELSE BEGIN
                                    decUnitCostPrevMAY := FunSearchProvided(UnitJobHijo);
                                END;

                                //de momento son iguales pero hay que buscar formula de ultimo
                                decUnitCostPrevLastMAY := UnitJobHijo."Aver. Cost Price Pend. Budget";

                                UnitJobHijo.SETRANGE("Filter Date", dateSince, dateUntil);
                                UnitJobHijo.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                UnitJobHijo.CALCFIELDS("Budget Measure");
                                decCostMonthMAY := decCostMonthMAY + UnitJobHijo."Amount Cost Performed (JC)";
                                decPlannedMonthCostMAY := decPlannedMonthCostMAY +
                                                             ROUND(UnitJobHijo."Total Measurement Production" * decUnitCostPrevMAY, 0.01);
                                decOexecutedMonthMAY := decOexecutedMonthMAY + UnitJobHijo."Amount Production Performed";

                                UnitJobHijo.SETRANGE("Filter Date", 0D, dateUntil);
                                UnitJobHijo.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                UnitJobHijo.CALCFIELDS("Budget Measure");
                                decCostOriginMAY := decCostOriginMAY + UnitJobHijo."Amount Cost Performed (JC)";
                                IF UnitJobHijo."Total Measurement Production" <> 0 THEN
                                    decAvgCost := FunCalcAvgCost(UnitJobHijo)
                                ELSE
                                    decAvgCost := decUnitCostPrevMAY;

                                decPlannedOriginCostMAY := decPlannedOriginCostMAY +
                                                                ROUND(UnitJobHijo."Total Measurement Production" * decAvgCost, 0.01);
                                decOexecutedOriginMAY := decOexecutedOriginMAY + UnitJobHijo."Amount Production Performed";

                                IF recBudgetJob."Budget Date" <> 0D THEN
                                    UnitJobHijo.SETRANGE("Filter Date", recBudgetJob."Budget Date" + 1, dateUntil)
                                ELSE
                                    UnitJobHijo.SETRANGE("Filter Date", dateUntil + 1, dateUntil);
                                UnitJobHijo.CALCFIELDS("Amount Cost Performed (JC)", "Total Measurement Production", "Amount Production Performed");
                                UnitJobHijo.CALCFIELDS("Budget Measure");
                                decLastCostMAY := decLastCostMAY + UnitJobHijo."Amount Cost Performed (JC)";
                                decLastCostPlannedMAY := decLastCostPlannedMAY +
                                                             ROUND(UnitJobHijo."Total Measurement Production" * decUnitCostPrevMAY, 0.01);
                                decOLastExecutedMAY := decOLastExecutedMAY + UnitJobHijo."Amount Production Performed";
                                UnitJobHijo.SETRANGE("Filter Date", 0D, dateSince - 1);
                                UnitJobHijo.CALCFIELDS("Amount Cost Performed (JC)");
                                decLastCostMAY := decLastCostMAY + UnitJobHijo."Amount Cost Performed (JC)";
                            UNTIL UnitJobHijo.NEXT = 0;
                        decI1MAY := -decPlannedMonthCostMAY + decCostMonthMAY;
                        decJ1MAY := -decPlannedOriginCostMAY + decCostOriginMAY;

                        IF decPlannedMonthCostMAY <> 0 THEN
                            decI2MAY := ((decCostMonthMAY / decPlannedMonthCostMAY) - 1) * 100
                        ELSE
                            decI2MAY := 0;

                        IF decPlannedOriginCostMAY <> 0 THEN
                            decJ2MAY := ((decCostOriginMAY / decPlannedOriginCostMAY) - 1) * 100
                        ELSE
                            decJ2MAY := 0;

                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IntAge := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 3);
                IntMonth := DATE2DMY(Job.GETRANGEMIN(Job."Posting Date Filter"), 2);

                IF (IntAge = 0) OR (IntMonth = 0) THEN
                    ERROR(Text50000);

                dateSince := DMY2DATE(1, IntMonth, IntAge);
                dateUntil := CALCDATE('PM', dateSince);

                CurrReport.CREATETOTALS(decCostMonth, decCostOrigin, decPlannedMonthCost, decPlannedOriginCost);
                CurrReport.CREATETOTALS(decLastCost, decLastCostPlanned);
                CurrReport.CREATETOTALS(decOexecutedMonth, decOexecutedOrigin, decOLastExecuted);
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF GETFILTER(Job."Budget Filter") <> '' THEN
                    codeBudgetInProgress := GETFILTER(Job."Budget Filter")
                ELSE BEGIN
                    IF Job."Current Piecework Budget" <> '' THEN
                        codeBudgetInProgress := Job."Current Piecework Budget"
                    ELSE
                        codeBudgetInProgress := Job."Initial Budget Piecework";
                END;

                Job.SETRANGE("Budget Filter", codeBudgetInProgress);
                recBudgetJob.SETFILTER(recBudgetJob."Job No.", Job."No.");
                recBudgetJob.SETFILTER(recBudgetJob."Cod. Budget", codeBudgetInProgress);
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
        //       LastFieldNo@7001151 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001150 :
        FooterPrinted: Boolean;
        //       IntAge@7001149 :
        IntAge: Integer;
        //       IntMonth@7001148 :
        IntMonth: Integer;
        //       dateSince@7001147 :
        dateSince: Date;
        //       dateUntil@7001146 :
        dateUntil: Date;
        //       decMeasurementperformedmonth@7001145 :
        decMeasurementperformedmonth: Decimal;
        //       decMeasurementperformedOrigin@7001144 :
        decMeasurementperformedOrigin: Decimal;
        //       decMeasurementBudgetTotal@7001143 :
        decMeasurementBudgetTotal: Decimal;
        //       decCostMonth@7001142 :
        decCostMonth: Decimal;
        //       decCostOrigin@7001141 :
        decCostOrigin: Decimal;
        //       decPlannedMonthCost@7001140 :
        decPlannedMonthCost: Decimal;
        //       decPlannedOriginCost@7001139 :
        decPlannedOriginCost: Decimal;
        //       decOexecutedMonth@7001138 :
        decOexecutedMonth: Decimal;
        //       decOexecutedOrigin@7001137 :
        decOexecutedOrigin: Decimal;
        //       decUnitCostPrev@7001136 :
        decUnitCostPrev: Decimal;
        //       decUnitCostPrevLast@7001135 :
        decUnitCostPrevLast: Decimal;
        //       decPercentageMeasurement@7001134 :
        decPercentageMeasurement: Decimal;
        //       decE2@7001133 :
        decE2: Decimal;
        //       decEULT@7001132 :
        decEULT: Decimal;
        //       decD2@7001131 :
        decD2: Decimal;
        //       decF2@7001130 :
        decF2: Decimal;
        //       decG2@7001129 :
        decG2: Decimal;
        //       decI1@7001128 :
        decI1: Decimal;
        //       decI2@7001127 :
        decI2: Decimal;
        //       decJ1@7001126 :
        decJ1: Decimal;
        //       decJ2@7001125 :
        decJ2: Decimal;
        //       CompanyInformation@7001124 :
        CompanyInformation: Record 79;
        //       decMeasurementBudgetTotalMAY@7001123 :
        decMeasurementBudgetTotalMAY: Decimal;
        //       decCostMonthMAY@7001122 :
        decCostMonthMAY: Decimal;
        //       decCostOriginMAY@7001121 :
        decCostOriginMAY: Decimal;
        //       decPlannedMonthCostMAY@7001120 :
        decPlannedMonthCostMAY: Decimal;
        //       decPlannedOriginCostMAY@7001119 :
        decPlannedOriginCostMAY: Decimal;
        //       decOexecutedMonthMAY@7001118 :
        decOexecutedMonthMAY: Decimal;
        //       decOexecutedOriginMAY@7001117 :
        decOexecutedOriginMAY: Decimal;
        //       decUnitCostPrevMAY@7001116 :
        decUnitCostPrevMAY: Decimal;
        //       decUnitCostPrevLastMAY@7001115 :
        decUnitCostPrevLastMAY: Decimal;
        //       decI1MAY@7001114 :
        decI1MAY: Decimal;
        //       decJ1MAY@7001113 :
        decJ1MAY: Decimal;
        //       UnitJobHijo@7001112 :
        UnitJobHijo: Record 7207386;
        //       decLastMeasurementPerformed@7001111 :
        decLastMeasurementPerformed: Decimal;
        //       decLastCost@7001110 :
        decLastCost: Decimal;
        //       decLastCostPlanned@7001109 :
        decLastCostPlanned: Decimal;
        //       decOLastExecuted@7001108 :
        decOLastExecuted: Decimal;
        //       decAvgCost@7001107 :
        decAvgCost: Decimal;
        //       decLastCostMAY@7001106 :
        decLastCostMAY: Decimal;
        //       decLastCostPlannedMAY@7001105 :
        decLastCostPlannedMAY: Decimal;
        //       decOLastExecutedMAY@7001104 :
        decOLastExecutedMAY: Decimal;
        //       decI2MAY@7001103 :
        decI2MAY: Decimal;
        //       decJ2MAY@7001102 :
        decJ2MAY: Decimal;
        //       recBudgetJob@7001101 :
        recBudgetJob: Record 7207407;
        //       codeBudgetInProgress@7001100 :
        codeBudgetInProgress: Code[20];
        //       Text50000@7001182 :
        Text50000: TextConst ENU = 'Must indicate year and month of the job report', ESP = 'Debe indicar A¤o y mes del informe de obra';
        //       GENERAL_TOTALCaptionLbl@7001181 :
        GENERAL_TOTALCaptionLbl: TextConst ENU = 'GENERAL TOTAL', ESP = 'TOTAL GENERAL';
        //       REAL_COST_OF_JOBCaptionLbl@7001180 :
        REAL_COST_OF_JOBCaptionLbl: TextConst ENU = 'REAL COST OF JOB', ESP = 'COSTE REAL DE OBRA';
        //       CurrReport_PAGENOCaptionLbl@7001179 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'PAGE', ESP = 'P gina';
        //       DIRECT_COSTCaptionLbl@7001178 :
        DIRECT_COSTCaptionLbl: TextConst ENU = 'DIRECT COST', ESP = 'COSTE DIRECTO';
        //       Job__No___________Job_DescriptionCaptionLbl@7001177 :
        Job__No___________Job_DescriptionCaptionLbl: TextConst ENU = 'JOB:', ESP = 'OBRA:';
        //       AGE_CaptionLbl@7001176 :
        AGE_CaptionLbl: TextConst ENU = '<AGE:>', ESP = 'A¥O:';
        //       MONTH_CaptionLbl@7001175 :
        MONTH_CaptionLbl: TextConst ENU = '<MONTH:>', ESP = 'MES:';
        //       PLANNEDCaptionLbl@7001174 :
        PLANNEDCaptionLbl: TextConst ENU = '<PLANNED', ESP = 'PLANIFICACIàN';
        //       OPERATIONCaptionLbl@7001173 :
        OPERATIONCaptionLbl: TextConst ENU = '<OPERATION>', ESP = 'OPERACION';
        //       UDCaptionLbl@7001172 :
        UDCaptionLbl: TextConst ENU = 'UD', ESP = 'UD';
        //       DESCRIPTIONCaptionLbl@7001171 :
        DESCRIPTIONCaptionLbl: TextConst ENU = '<DESCRIPTION>', ESP = 'DESCRIPCION';
        //       MONTHCaptionLbl@7001170 :
        MONTHCaptionLbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       COMPLETEDCaptionLbl@7001169 :
        COMPLETEDCaptionLbl: TextConst ENU = '<% COMPLETED>', ESP = '% REALIZADO';
        //       MONTHCaption_Control1100251016Lbl@7001168 :
        MONTHCaption_Control1100251016Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       ORIGINCaptionLbl@7001167 :
        ORIGINCaptionLbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       COMPLETEDCaption_Control1100251021Lbl@7001166 :
        COMPLETEDCaption_Control1100251021Lbl: TextConst ENU = 'COMPLETED', ESP = 'REALIZADO';
        //       JOB_EXECUTED__SALES_PRICECaptionLbl@7001165 :
        JOB_EXECUTED__SALES_PRICECaptionLbl: TextConst ENU = 'JOB EXECUTED / SALES PRICE', ESP = 'OBRA EJECUTADA';
        //       MONTHCaption_Control1100251029Lbl@7001164 :
        MONTHCaption_Control1100251029Lbl: TextConst ENU = 'MONTH', ESP = 'MES';
        //       ORIGINCaption_Control1100251030Lbl@7001163 :
        ORIGINCaption_Control1100251030Lbl: TextConst ENU = 'ORIGIN', ESP = 'ORIGEN';
        //       COST_DESVIATION___PLANNEDCaptionLbl@7001162 :
        COST_DESVIATION___PLANNEDCaptionLbl: TextConst ENU = '<COST DESVIATION/ %PLANNED>', ESP = 'Importe %';
        //       "TOTAL/UNITARY_DIRECT_COSTCaptionLbl"@7001161 :
        "TOTAL/UNITARY_DIRECT_COSTCaptionLbl": TextConst ENU = '<TOTAL / UNITARY DIRECT COST>', ESP = 'COSTE DIRECTO MES / ORIGEN';
        //       VOL__TOTALCaptionLbl@7001160 :
        VOL__TOTALCaptionLbl: TextConst ENU = 'MED. TOTAL PARTIDA', ESP = 'MED. TOTAL PARTIDA';
        //       ORIGINCaption_Control1100251127Lbl@7001159 :
        ORIGINCaption_Control1100251127Lbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       LASTCaptionLbl@7001158 :
        LASTCaptionLbl: TextConst ENU = 'LAST', ESP = 'ULTIMO';
        //       LASTCaption_Control1100015Lbl@7001157 :
        LASTCaption_Control1100015Lbl: TextConst ENU = 'LAST', ESP = 'ULTIMO';
        //       ORIGINCaption_Control1100016Lbl@7001156 :
        ORIGINCaption_Control1100016Lbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       MONTHCaption_Control1100017Lbl@7001155 :
        MONTHCaption_Control1100017Lbl: TextConst ENU = '<MONTH>', ESP = 'MES';
        //       MONTHCaption_Control1100020Lbl@7001154 :
        MONTHCaption_Control1100020Lbl: TextConst ENU = '<MONTH>', ESP = 'MES';
        //       ORIGINCaption_Control1100022Lbl@7001153 :
        ORIGINCaption_Control1100022Lbl: TextConst ENU = '<ORIGIN>', ESP = 'ORIGEN';
        //       DIRECT_JOB_TOTALCaptionLbl@7001152 :
        DIRECT_JOB_TOTALCaptionLbl: TextConst ENU = 'DIRECT JOB TOTAL', ESP = 'TOTAL DIRECTOS OBRA';
        //       DataPieceworkForProduction@7001183 :
        DataPieceworkForProduction: Record 7207386;
        //       Spaces@7001184 :
        Spaces: Text[30];
        //       DataPieceworkForProduction2@1100286000 :
        DataPieceworkForProduction2: Record 7207386;
        //       Med_Periodo_Lbl@1100286001 :
        Med_Periodo_Lbl: TextConst ENU = 'Med. PERIODO';
        //       Med_Origen_Lbl@1100286002 :
        Med_Origen_Lbl: TextConst ENU = 'Med. ORIGEN';
        //       Produccion_Lbl@1100286003 :
        Produccion_Lbl: TextConst ENU = 'PRODUCCIàN';
        //       Desviacion_Lbl@1100286004 :
        Desviacion_Lbl: TextConst ENU = 'DESVIACIàN COSTE';
        //       Planification_Importe_Lbl@1100286005 :
        Planification_Importe_Lbl: TextConst ENU = 'Importe';
        //       Planification_Porc_Planif_Lbl@1100286006 :
        Planification_Porc_Planif_Lbl: TextConst ENU = 'Precio unitario';
        //       Completed_Importe_Lbl@1100286007 :
        Completed_Importe_Lbl: TextConst ENU = 'Importe';
        //       Completed_porc_Complet_Lbl@1100286008 :
        Completed_porc_Complet_Lbl: TextConst ENU = 'Precio unitario';
        //       Prod_Prec_Venta_Lbl@1100286009 :
        Prod_Prec_Venta_Lbl: TextConst ENU = 'Precio venta';

    LOCAL procedure FunInitVar()
    begin
        decMeasurementperformedmonth := 0;
        decMeasurementperformedOrigin := 0;
        decMeasurementBudgetTotal := 0;
        decCostMonth := 0;
        decCostOrigin := 0;
        decLastCost := 0;
        decPlannedMonthCost := 0;
        decPlannedOriginCost := 0;
        decLastCostPlanned := 0;
        decOexecutedMonth := 0;
        decOexecutedOrigin := 0;
        decOLastExecuted := 0;
        decUnitCostPrev := 0;
        decUnitCostPrevLast := 0;
        decPercentageMeasurement := 0;
        decJ2 := 0;
        decJ1 := 0;
        decI1 := 0;
        decI2 := 0;
        decE2 := 0;
        decF2 := 0;
        decG2 := 0;
        decD2 := 0;

        decMeasurementBudgetTotalMAY := 0;
        decCostMonthMAY := 0;
        decCostOriginMAY := 0;
        decLastCostMAY := 0;
        decPlannedMonthCostMAY := 0;
        decPlannedOriginCostMAY := 0;
        decLastCostPlannedMAY := 0;
        decOexecutedMonthMAY := 0;
        decOexecutedOriginMAY := 0;
        decOLastExecutedMAY := 0;
        decUnitCostPrevMAY := 0;
        decUnitCostPrevLastMAY := 0;
        decI1MAY := 0;
        decJ1MAY := 0;
        decI2MAY := 0;
        decJ2MAY := 0;
    end;

    //     LOCAL procedure FunCalcAvgCost (DataParUO@7001100 :
    LOCAL procedure FunCalcAvgCost(DataParUO: Record 7207386): Decimal;
    var
        //       locdecMeasureTotal@7001109 :
        locdecMeasureTotal: Decimal;
        //       locrecDataCost@7001108 :
        locrecDataCost: Record 7207387;
        //       loccduFunVarQB@7001107 :
        loccduFunVarQB: Codeunit 7207272;
        //       locdate@7001106 :
        locdate: Date;
        //       locdecImpinicial@7001105 :
        locdecImpinicial: Decimal;
        //       locboolReestimations@7001104 :
        locboolReestimations: Boolean;
        //       locdateUntil@7001103 :
        locdateUntil: Date;
        //       locrecBudgetJob@7001102 :
        locrecBudgetJob: Record 7207407;
        //       locrecBudgetJobSig@7001101 :
        locrecBudgetJobSig: Record 7207407;
    begin
        //Pensar cual es el coste medio que ahora no es nada facil. Esto no vale
        DataParUO.SETRANGE("Budget Filter", codeBudgetInProgress);
        DataParUO.CALCFIELDS("Aver. Cost Price Pend. Budget");
        DataParUO.SETRANGE("Filter Date", 0D, dateUntil);
        DataParUO.CALCFIELDS("Total Measurement Production");
        locdecImpinicial := DataParUO."Total Measurement Production" * DataParUO."Aver. Cost Price Pend. Budget";

        // EPV Q18342 02/01/22 - Se traslada c¢digo que exist¡a m s abajo
        locdecMeasureTotal := DataParUO."Total Measurement Production";
        //-->

        if locdecMeasureTotal <> 0 then
            exit(locdecImpinicial / locdecMeasureTotal)
        else
            exit(0);

        // EPV Q18342 02/01/22 - Se quita c¢digo que no aporta nada en esta posici¢n
        //locdecMeasureTotal := DataParUO."Total Measurement Production";
        //-->
    end;

    //     LOCAL procedure FunSearchProvided (DataParUO@7001101 :
    LOCAL procedure FunSearchProvided(DataParUO: Record 7207386): Decimal;
    var
        //       recDatosUO2@7001103 :
        recDatosUO2: Record 7207386;
        //       locrecDatoscoste@7001102 :
        locrecDatoscoste: Record 7207387;
    begin
        recDatosUO2.GET(DataParUO."Job No.", DataParUO."Piecework Code");
        locrecDatoscoste.SETCURRENTKEY("Job No.", "Piecework Code", "Cod. Budget");
        locrecDatoscoste.SETRANGE("Job No.", recDatosUO2."Job No.");
        locrecDatoscoste.SETRANGE("Piecework Code", recDatosUO2."Piecework Code");
        locrecDatoscoste.SETFILTER("Cod. Budget", '<>%1', Job."Initial Budget Piecework");
        if not locrecDatoscoste.FINDFIRST then begin
            recDatosUO2.SETRANGE("Budget Filter", Job."Initial Budget Piecework");
            recDatosUO2.CALCFIELDS("Aver. Cost Price Pend. Budget");
            exit(recDatosUO2."Aver. Cost Price Pend. Budget");
        end else begin
            locrecDatoscoste.SETFILTER("Cod. Budget", '<=%1', codeBudgetInProgress);
            if locrecDatoscoste.FINDLAST then begin
                recDatosUO2.SETRANGE("Budget Filter", locrecDatoscoste."Cod. Budget");
                recDatosUO2.CALCFIELDS("Aver. Cost Price Pend. Budget");
                exit(recDatosUO2."Aver. Cost Price Pend. Budget");
            end else begin
                recDatosUO2.SETRANGE("Budget Filter", Job."Initial Budget Piecework");
                recDatosUO2.CALCFIELDS("Aver. Cost Price Pend. Budget");
                exit(recDatosUO2."Aver. Cost Price Pend. Budget");
            end;
        end;
    end;

    /*begin
    //{
//      PGM Q13438 01/07/21 - QB 1.09.17 Cambios realizados en el layout seg£n la descripci¢n de la tarea, cambio de m rgenes y de totales
//      EPV Q18342 02/01/22 - Correcciones de c lculos erroneos y cambios est‚ticos solicitados por Jymmy (a petici¢n de Royg CyS).
//      PAT Q19153 18/04/23 - Corregir formato "COSTE REAL OBRA".
//    }
    end.
  */

}



// RequestFilterFields="Piecework Code";
