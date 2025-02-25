report 7207364 "Itemized Budget"
{


    CaptionML = ENU = 'Itemized Budget', ESP = 'Presupuesto desglosado';

    dataset
    {

        DataItem("Selection"; "Job")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'JOB', ESP = 'OBRA';


            RequestFilterFields = "No.", "Budget Filter";
            Column(DelegationCode_Selection; Selection."QB Activable")
            {
                //SourceExpr=Selection."QB Activable";
            }
            Column(DirectionCode_Selection; Selection."QB Activable Date")
            {
                //SourceExpr=Selection."QB Activable Date";
            }
            Column(IntMonth; IntMonth)
            {
                //SourceExpr=IntMonth;
            }
            Column(IntYear; IntYear)
            {
                //SourceExpr=IntYear;
            }
            Column(No___Description__Description2; "No." + '  ' + Description + '  ' + "Description 2")
            {
                //SourceExpr="No." + '  ' + Description + '  ' + "Description 2";
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
            Column(JobBudget_BudgetDate; JobBudget."Budget Date")
            {
                //SourceExpr=JobBudget."Budget Date";
            }
            Column(JobBudget_CodBudget; JobBudget."Cod. Budget")
            {
                //SourceExpr=JobBudget."Cod. Budget";
            }
            Column(Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(GeneralTotal_TotCostAmount_Gross; GeneralTotal_TotCostAmount_Gross)
            {
                //SourceExpr=GeneralTotal_TotCostAmount_Gross;
            }
            Column(GeneralTotal_ExecCostAmount_Gross; GeneralTotal_ExecCostAmount_Gross)
            {
                //SourceExpr=GeneralTotal_ExecCostAmount_Gross;
            }
            Column(GeneralTotal_PendingCostAmount_Gross; GeneralTotal_PendingCostAmount_Gross)
            {
                //SourceExpr=GeneralTotal_PendingCostAmount_Gross;
            }
            Column(GeneralTotal_TotalTotalSale_Gross; GeneralTotal_TotalTotalSale_Gross)
            {
                //SourceExpr=GeneralTotal_TotalTotalSale_Gross;
            }
            Column(GeneralTotal_TotalExecSale_Gross; GeneralTotal_TotalExecSale_Gross)
            {
                //SourceExpr=GeneralTotal_TotalExecSale_Gross;
            }
            Column(GeneralTotal_TotalPendingSale_Gross; GeneralTotal_TotalPendingSale_Gross)
            {
                //SourceExpr=GeneralTotal_TotalPendingSale_Gross;
            }
            Column(TotalGrossDiff; TotalGrossDiff)
            {
                //SourceExpr=TotalGrossDiff;
            }
            Column(ExecGrossDiff; ExecGrossDiff)
            {
                //SourceExpr=ExecGrossDiff;
            }
            Column(PendingGrossDiff; PendingGrossDiff)
            {
                //SourceExpr=PendingGrossDiff;
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
            Column(Measurement_Lbl; Measurement_Lbl)
            {
                //SourceExpr=Measurement_Lbl;
            }
            Column(CostPrice_Lbl; CostPrice_Lbl)
            {
                //SourceExpr=CostPrice_Lbl;
            }
            Column(CostAmount_Lbl; CostAmount_Lbl)
            {
                //SourceExpr=CostAmount_Lbl;
            }
            Column(Total_Lbl; Total_Lbl)
            {
                //SourceExpr=Total_Lbl;
            }
            Column(Exec_Lbl; Exec_Lbl)
            {
                //SourceExpr=Exec_Lbl;
            }
            Column(Pending_Lbl; Pending_Lbl)
            {
                //SourceExpr=Pending_Lbl;
            }
            Column(TotalJob_Lbl; TotalJob_Lbl)
            {
                //SourceExpr=TotalJob_Lbl;
            }
            Column(TotalProduction_Lbl; TotalProduction_Lbl)
            {
                //SourceExpr=TotalProduction_Lbl;
            }
            Column(PendingProduction_Lbl; PendingProduction_Lbl)
            {
                //SourceExpr=PendingProduction_Lbl;
            }
            Column(TR_Lbl; TR_Lbl)
            {
                //SourceExpr=TR_Lbl;
            }
            Column(MONTH_Lbl; MONTH_Lbl)
            {
                //SourceExpr=MONTH_Lbl;
            }
            Column(YEAR_Lbl; YEAR_Lbl)
            {
                //SourceExpr=YEAR_Lbl;
            }
            Column(DELEGATION_Lbl; DELEGATION_Lbl)
            {
                //SourceExpr=DELEGATION_Lbl;
            }
            Column(ADDRESS_Lbl; ADDRESS_Lbl)
            {
                //SourceExpr=ADDRESS_Lbl;
            }
            Column(JOB_Lbl; JOB_Lbl)
            {
                //SourceExpr=JOB_Lbl;
            }
            Column(PLANNINGBYPIECEWORK_Lbl; PLANNINGBYPIECEWORK_Lbl)
            {
                //SourceExpr=PLANNINGBYPIECEWORK_Lbl;
            }
            Column(Page_Lbl; Page_Lbl)
            {
                //SourceExpr=Page_Lbl;
            }
            Column(FORECASTDATE_Lbl; FORECASTDATE_Lbl)
            {
                //SourceExpr=FORECASTDATE_Lbl;
            }
            Column(FORECAST_NO_Lbl; FORECAST_NO_Lbl)
            {
                //SourceExpr=FORECAST_NO_Lbl;
            }
            Column(COST_Lbl; COST_Lbl)
            {
                //SourceExpr=COST_Lbl;
            }
            Column(PRODUCTION_Lbl; PRODUCTION_Lbl)
            {
                //SourceExpr=PRODUCTION_Lbl;
            }
            Column(TOTALCOSTS_Lbl; TOTALCOSTS_Lbl)
            {
                //SourceExpr=TOTALCOSTS_Lbl;
            }
            Column(TOTAL_PRODUCTION_Lbl; TOTAL_PRODUCTION_Lbl)
            {
                //SourceExpr=TOTAL_PRODUCTION_Lbl;
            }
            Column(DIFFERENCE_Lbl; DIFFERENCE_Lbl)
            {
                //SourceExpr=DIFFERENCE_Lbl;
            }
            Column(Piecework_Lbl; Piecework_Lbl)
            {
                //SourceExpr=Piecework_Lbl;
            }
            Column(No_Selection; Selection."No.")
            {
                //SourceExpr=Selection."No.";
            }
            DataItem("Job"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(Description_Job; Job.Description)
                {
                    //SourceExpr=Job.Description;
                }
                Column(No_Job; Job."No.")
                {
                    //SourceExpr=Job."No.";
                }
                Column(TotCostAmount; TotCostAmount)
                {
                    //SourceExpr=TotCostAmount;
                }
                Column(ExecCostAmount; ExecCostAmount)
                {
                    //SourceExpr=ExecCostAmount;
                }
                Column(PendingCostAmount_Job; PendingCostAmount)
                {
                    //SourceExpr=PendingCostAmount;
                }
                Column(PendingSale; PendingSale)
                {
                    //SourceExpr=PendingSale;
                }
                Column(TotalSale; TotalSale)
                {
                    //SourceExpr=TotalSale;
                }
                Column(ExecSale; ExecSale)
                {
                    //SourceExpr=ExecSale;
                }
                Column(TotDiff; TotDiff)
                {
                    //SourceExpr=TotDiff;
                }
                Column(ExecDiff; ExecDiff)
                {
                    //SourceExpr=ExecDiff;
                }
                Column(PendDiff; PendDiff)
                {
                    //SourceExpr=PendDiff;
                }
                Column(DIRECTTOTALCOST_Lbl; DIRECTTOTALCOST_Lbl)
                {
                    //SourceExpr=DIRECTTOTALCOST_Lbl;
                }
                Column(TOTAL_PRODUCTION_Lbl2; TOTAL_PRODUCTION_Lbl)
                {
                    //SourceExpr=TOTAL_PRODUCTION_Lbl;
                }
                Column(DIFFERENCE_2; Difference)
                {
                    //SourceExpr=Difference;
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Piecework"), "Production Unit" = CONST(true));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(Tittle____TittleName; FORMAT(Tittle) + '  ' + TittleName)
                    {
                        //SourceExpr=FORMAT(Tittle) +  '  ' + TittleName;
                    }
                    Column(UnitOfMeasure_DataPieceworkForProduction; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(Description_DataPieceworkForProduction; "Data Piecework For Production".Description)
                    {
                        //SourceExpr="Data Piecework For Production".Description;
                    }
                    Column(TotalSale_2; TotalSale)
                    {
                        //SourceExpr=TotalSale;
                    }
                    Column(TotMeasurement; TotMeasurement)
                    {
                        //SourceExpr=TotMeasurement;
                    }
                    Column(PendingCostAmount; PendingCostAmount)
                    {
                        //SourceExpr=PendingCostAmount;
                    }
                    Column(ExecSale_2; ExecSale)
                    {
                        //SourceExpr=ExecSale;
                    }
                    Column(PieceworkCode_DataPieceworkForProduction; "Data Piecework For Production"."Piecework Code")
                    {
                        //SourceExpr="Data Piecework For Production"."Piecework Code";
                    }
                    Column(PendingSale_2; PendingSale)
                    {
                        //SourceExpr=PendingSale;
                    }
                    Column(ExecCostAmount_DPFP; ExecCostAmount)
                    {
                        //SourceExpr=ExecCostAmount;
                    }
                    Column(TotCostAmount__DPFP; TotCostAmount)
                    {
                        //SourceExpr=TotCostAmount;
                    }
                    Column(PcosTot; PcosTot)
                    {
                        //SourceExpr=PcosTot;
                    }
                    Column(PcosExec; PcosExec)
                    {
                        //SourceExpr=PcosExec;
                    }
                    Column(PcosPending; PcosPending)
                    {
                        //SourceExpr=PcosPending;
                    }
                    Column(ExecMeasurement; ExecMeasurement)
                    {
                        //SourceExpr=ExecMeasurement;
                    }
                    Column(PendingMeasurement; PendingMeasurement)
                    {
                        //SourceExpr=PendingMeasurement;
                    }
                    Column(ProcessedProduction_DataPieceworkForProduction; "Data Piecework For Production"."% Processed Production")
                    {
                        //SourceExpr="Data Piecework For Production"."% Processed Production";
                    }
                    Column(Tittle____TittleName2; FORMAT(Tittle) + '  ' + TittleName)
                    {
                        //SourceExpr=FORMAT(Tittle) +  '  ' + TittleName;
                    }
                    Column(Chapter_Lbl; Chapter_Lbl)
                    {
                        //SourceExpr=Chapter_Lbl;
                    }
                    Column(ChapterTotal_Lbl; ChapterTotal_Lbl)
                    {
                        //SourceExpr=ChapterTotal_Lbl;
                    }
                    Column(JobNo_DataPieceworkForProduction; "Data Piecework For Production"."Job No.")
                    {
                        //SourceExpr="Data Piecework For Production"."Job No.";
                    }
                    Column(Title_DataPieceworkForProduction; "Data Piecework For Production".Title)
                    {
                        //SourceExpr="Data Piecework For Production".Title;
                    }
                    Column(TotCostAmount_DPFP2; TotCostAmount)
                    {
                        //SourceExpr=TotCostAmount;
                    }
                    Column(ExecCostAmount_DPFP2; ExecCostAmount)
                    {
                        //SourceExpr=ExecCostAmount;
                    }
                    Column(PendingCostAmount_DPFP2; PendingCostAmount)
                    {
                        //SourceExpr=PendingCostAmount;
                    }
                    Column(TotalSale_3; TotalSale)
                    {
                        //SourceExpr=TotalSale;
                    }
                    Column(ExecSale_3; ExecSale)
                    {
                        //SourceExpr=ExecSale;
                    }
                    Column(PendingSale_3; PendingSale)
                    {
                        //SourceExpr=PendingSale;
                    }
                    DataItem("Data Cost By Piecework"; "Data Cost By Piecework")
                    {

                        DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Ascending);
                        DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                        Column(Description_DataCostByPiecework; "Data Cost By Piecework".Description)
                        {
                            //SourceExpr="Data Cost By Piecework".Description;
                        }
                        Column(No_DataCostByPiecework; "Data Cost By Piecework"."No.")
                        {
                            //SourceExpr="Data Cost By Piecework"."No.";
                        }
                        Column(JobNo_DataCostByPiecework; "Data Cost By Piecework"."Job No.")
                        {
                            //SourceExpr="Data Cost By Piecework"."Job No.";
                        }
                        Column(PieceworkCode_DataCostByPiecework; "Data Cost By Piecework"."Piecework Code")
                        {
                            //SourceExpr="Data Cost By Piecework"."Piecework Code";
                        }
                        Column(CodBudget_DataCostByPiecework; "Data Cost By Piecework"."Cod. Budget")
                        {
                            //SourceExpr="Data Cost By Piecework"."Cod. Budget";
                        }
                        Column(CostType_DataCostByPiecework; "Data Cost By Piecework"."Cost Type")
                        {
                            //SourceExpr="Data Cost By Piecework"."Cost Type";
                        }
                        Column(AmountCostPendingLine; AmountCostPendingLine)
                        {
                            //SourceExpr=AmountCostPendingLine;
                        }
                        Column(PcostPendingLine; PcostPendingLine)
                        {
                            //SourceExpr=PcostPendingLine;
                        }
                        Column(MeasurementPendingLine; MeasurementPendingLine)
                        {
                            //SourceExpr=MeasurementPendingLine;
                        }
                        //D3 triggers
                        trigger OnPreDataItem();
                        BEGIN
                            SETRANGE("Data Cost By Piecework"."Cod. Budget", Budget_In_Process);
                            SETFILTER("Data Cost By Piecework"."Filter Date", '%1..%2', 0D, Date);
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            CALCFIELDS("Measure Product Exec.", "Measure Resource Exec.", "Product Exec. Cost", "Resource Exec. Cost");

                            IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::Item THEN BEGIN
                                IF "Measure Product Exec." <> 0 THEN
                                    PCost := "Product Exec. Cost" / "Measure Product Exec."
                                ELSE
                                    PCost := 0;
                                ExecMeasurement_ := "Measure Product Exec.";
                                Exec_Amount := "Product Exec. Cost";
                            END ELSE BEGIN
                                IF "Measure Resource Exec." <> 0 THEN
                                    PCost := "Resource Exec. Cost" / "Measure Resource Exec."
                                ELSE
                                    PCost := 0;
                                ExecMeasurement_ := "Measure Resource Exec.";
                                Exec_Amount := "Resource Exec. Cost";
                            END;

                            MeasurementPendingLine := "Data Cost By Piecework"."Performance By Piecework";
                            AmountCostPendingLine := MeasurementPendingLine * "Data Cost By Piecework"."Direct Unitary Cost (JC)";
                            PcostPendingLine := "Direct Unitary Cost (JC)";

                            IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::Item THEN BEGIN
                                IF ("Measure Product Exec." + MeasurementPendingLine) <> 0 THEN
                                    P_cost := (("Measure Product Exec." * PCost + MeasurementPendingLine * PcostPendingLine) / ("Measure Product Exec." + MeasurementPendingLine))
                                ELSE
                                    P_cost := 0;
                                TotalMeasurementLine := "Measure Product Exec." + MeasurementPendingLine;
                            END ELSE BEGIN
                                IF ("Measure Resource Exec." + MeasurementPendingLine) <> 0 THEN
                                    P_cost := (("Measure Resource Exec." * PCost + MeasurementPendingLine * PcostPendingLine) / ("Measure Resource Exec." + MeasurementPendingLine))
                                ELSE
                                    P_cost := 0;
                                TotalMeasurementLine := "Measure Resource Exec." + MeasurementPendingLine;
                            END;
                            ExecCostAmountNotBudgeted := ExecCostAmountNotBudgeted - Exec_Amount;
                        END;
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        SETRANGE("Budget Filter", Budget_In_Process);

                        CurrReport.CREATETOTALS(TotCostAmount, ExecCostAmount, PendingCostAmount, PendingDeliveryBill, PendingCostAmount, TotalSale, ExecSale, PendingSale);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        SETRANGE("Data Piecework For Production"."Filter Date");
                        SETRANGE("Budget Filter", Budget_In_Process);
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        SETFILTER("Data Piecework For Production"."Filter Date", '%1..%2', 0D, Date);
                        CALCFIELDS("Aver. Cost Price Pend. Budget");
                        SETRANGE("Budget Filter");
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");
                        SETRANGE("Budget Filter", Budget_In_Process);

                        PcosPending := "Aver. Cost Price Pend. Budget";
                        TotMeasurement := "Budget Measure";
                        ExecMeasurement := "Total Measurement Production";
                        ExecCostAmount := "Amount Cost Performed (JC)";
                        PendingMeasurement := TotMeasurement - ExecMeasurement;
                        TotCostAmount := "Amount Cost Performed (JC)" + PendingMeasurement * PcosPending;

                        ExecCostAmountNotBudgeted := ExecCostAmount;

                        IF TotMeasurement <> 0 THEN
                            PcosTot := TotCostAmount / TotMeasurement
                        ELSE
                            PcosTot := 0;

                        IF ExecMeasurement <> 0 THEN
                            PcosExec := ExecCostAmount / ExecMeasurement
                        ELSE
                            PcosExec := 0;

                        PendingCostAmount := PendingMeasurement * PcosPending;

                        TotalSale := "Data Piecework For Production"."Amount Production Budget";
                        ExecSale := "Data Piecework For Production"."Amount Production Performed";
                        PendingSale := TotalSale - ExecSale;
                        TittleName := '';

                        IF DataPieceworkForProduction.GET(Job."No.", Title) THEN
                            TittleName := DataPieceworkForProduction.Description;

                        Piecework_ := COPYSTR("Piecework Code", STRLEN(Title) + 1);

                        SaleInProcess := ROUND("Amount Production Performed" * (1 - ("% Processed Production" / 100)), 0.01);
                        SaleProcessed := ROUND("Amount Production Performed" * ("% Processed Production" / 100), 0.01);

                        BudgetInProcess := ROUND(("Amount Production Budget" * (100 - "% Processed Production") / 100), 0.01);
                        BudgetProcessed := ROUND(("Amount Production Budget" * ("% Processed Production" / 100)), 0.01);

                        GeneralTotal_TotalExecSale_Process := GeneralTotal_TotalExecSale_Process + SaleInProcess;
                        GeneralTotal_PendingCostAmount_Process := GeneralTotal_PendingCostAmount_Process + (BudgetInProcess - SaleInProcess);
                        GeneralTotal_TotalTotalSale_Process := GeneralTotal_TotalTotalSale_Process + BudgetInProcess;
                        GeneralTotal_TotalExecSale_ := GeneralTotal_TotalExecSale_ + SaleProcessed;
                        GeneralTotal_TotalPendingSale_ := GeneralTotal_TotalPendingSale_ + (BudgetProcessed - SaleProcessed);
                        GeneralTotal_TotalTotalSale_ := GeneralTotal_TotalTotalSale_ + BudgetProcessed;

                        GeneralTotal_TotalTotalSale_Gross := GeneralTotal_TotalTotalSale_Gross + TotalSale;
                        GeneralTotal_TotalExecSale_Gross := GeneralTotal_TotalExecSale_Gross + ExecSale;
                        GeneralTotal_TotalPendingSale_Gross := GeneralTotal_TotalPendingSale_Gross + PendingSale;

                        GeneralTotal_TotCostAmount_ := GeneralTotal_TotCostAmount_ + ROUND(TotCostAmount * "% Processed Production" / 100, 0.01);
                        GeneralTotal_ExecCostAmount_ := GeneralTotal_ExecCostAmount_ + ROUND(ExecCostAmount * "% Processed Production" / 100, 0.01);
                        GeneralTotal_PendingCostAmount_ := GeneralTotal_PendingCostAmount_ + ROUND(PendingCostAmount * "% Processed Production" / 100, 0.01);

                        GeneralTotal_TotCostAmount_Gross := GeneralTotal_TotCostAmount_Gross + TotCostAmount;
                        GeneralTotal_ExecCostAmount_Gross := GeneralTotal_ExecCostAmount_Gross + ExecCostAmount;
                        GeneralTotal_PendingCostAmount_Gross := GeneralTotal_PendingCostAmount_Gross + PendingCostAmount;
                    END;


                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS(TotCostAmount, ExecCostAmount, PendingCostAmount, PendingDeliveryBill, PendingCostAmount, TotalSale, ExecSale, PendingSale);
                END;
            }
            DataItem("Job2"; "Job")
            {

                DataItemTableView = SORTING("No.");
                DataItemLink = "No." = FIELD("No.");
                Column(No_Job2___Description; FORMAT(Job2."No.") + '  ' + Description)
                {
                    //SourceExpr=FORMAT(Job2."No.") +  '  ' + Description;
                }
                Column(Description_Job2; Job2.Description)
                {
                    //SourceExpr=Job2.Description;
                }
                Column(No_Job2; Job2."No.")
                {
                    //SourceExpr=Job2."No.";
                }
                Column(TotCostAmount_Job2; TotCostAmount)
                {
                    //SourceExpr=TotCostAmount;
                }
                Column(ExecCostAmount_Job2; ExecCostAmount)
                {
                    //SourceExpr=ExecCostAmount;
                }
                Column(PendingCostAmount_Job2; PendingCostAmount)
                {
                    //SourceExpr=PendingCostAmount;
                }
                Column(TotalSale_Job2; TotalSale)
                {
                    //SourceExpr=TotalSale;
                }
                Column(ExecSale_Job2; ExecSale)
                {
                    //SourceExpr=ExecSale;
                }
                Column(PendingSale_Job2; PendingSale)
                {
                    //SourceExpr=PendingSale;
                }
                Column(INDIRECTANDEXTERNAL_Lbl; INDIRECTANDEXTERNAL_Lbl)
                {
                    //SourceExpr=INDIRECTANDEXTERNAL_Lbl;
                }
                Column(INDIRECT_EXTERNAL_T_Lbl; INDIRECT_EXTERNAL_T_Lbl)
                {
                    //SourceExpr=INDIRECT_EXTERNAL_T_Lbl;
                }
                DataItem("Integer"; "Integer")
                {

                    DataItemTableView = SORTING("Number");
                    ;
                    DataItem("ManagementExpenses"; "Data Piecework For Production")
                    {

                        DataItemTableView = SORTING("Job No.", "Title", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Type" = CONST("Cost Unit"));


                        RequestFilterFields = "Piecework Code";
                        DataItemLinkReference = "Job2";
                        DataItemLink = "Job No." = FIELD("No.");
                        Column(TittleName; TittleName)
                        {
                            //SourceExpr=TittleName;
                        }
                        Column(UnitOfMeasure_ManagementExpenses; ManagementExpenses."Unit Of Measure")
                        {
                            //SourceExpr=ManagementExpenses."Unit Of Measure";
                        }
                        Column(Description_ManagementExpenses; ManagementExpenses.Description)
                        {
                            //SourceExpr=ManagementExpenses.Description;
                        }
                        Column(TotalSale_ManagementExpenses; TotalSale)
                        {
                            //SourceExpr=TotalSale;
                        }
                        Column(ExecSale_ManagementExpenses; ExecSale)
                        {
                            //SourceExpr=ExecSale;
                        }
                        Column(PendingSale_ManagementExpenses; PendingSale)
                        {
                            //SourceExpr=PendingSale;
                        }
                        Column(TotMeasurement_ManagementExpenses; TotMeasurement)
                        {
                            //SourceExpr=TotMeasurement;
                        }
                        Column(PendingCostAmount_ManagementExpenses; PendingCostAmount)
                        {
                            //SourceExpr=PendingCostAmount;
                        }
                        Column(ExecCostAmount_ManagementExpenses; ExecCostAmount)
                        {
                            //SourceExpr=ExecCostAmount;
                        }
                        Column(TotCostAmount_ManagementExpenses; TotCostAmount)
                        {
                            //SourceExpr=TotCostAmount;
                        }
                        Column(PcosTot_ManagementExpenses; PcosTot)
                        {
                            //SourceExpr=PcosTot;
                        }
                        Column(PcosExec_ManagementExpenses; PcosExec)
                        {
                            //SourceExpr=PcosExec;
                        }
                        Column(PcosPending_ManagementExpenses; PcosPending)
                        {
                            //SourceExpr=PcosPending;
                        }
                        Column(ExecMeasurement_ManagementExpenses; ExecMeasurement)
                        {
                            //SourceExpr=ExecMeasurement;
                        }
                        Column(PendingMeasurement_ManagementExpenses; PendingMeasurement)
                        {
                            //SourceExpr=PendingMeasurement;
                        }
                        Column(ProcessedProduction_ManagementExpenses; ManagementExpenses."% Processed Production")
                        {
                            //SourceExpr=ManagementExpenses."% Processed Production";
                        }
                        Column(PieceworkCode_ManagementExpenses; ManagementExpenses."Piecework Code")
                        {
                            //SourceExpr=ManagementExpenses."Piecework Code";
                        }
                        Column(TOTAL__TittleName; 'TOTAL ' + TittleName)
                        {
                            //SourceExpr='TOTAL ' +  TittleName;
                        }
                        Column(Type_Lbl; Type_Lbl)
                        {
                            //SourceExpr=Type_Lbl;
                        }
                        Column(JobNo_ManagementExpenses; ManagementExpenses."Job No.")
                        {
                            //SourceExpr=ManagementExpenses."Job No.";
                        }
                        Column(PieceworkCode_ManagementExpenses2; ManagementExpenses."Piecework Code")
                        {
                            //SourceExpr=ManagementExpenses."Piecework Code";
                        }
                        Column(UnitOfMeasure_ManagementExpenses2; ManagementExpenses."Unit Of Measure")
                        {
                            //SourceExpr=ManagementExpenses."Unit Of Measure";
                        }
                        Column(Description_ManagementExpenses2; ManagementExpenses.Description)
                        {
                            //SourceExpr=ManagementExpenses.Description;
                        }
                        Column(ProcessedProduction_ManagementExpenses2; ManagementExpenses."% Processed Production")
                        {
                            //SourceExpr=ManagementExpenses."% Processed Production";
                        }
                        Column(PendingCostAmount_ManagementExpenses2; PendingCostAmount)
                        {
                            //SourceExpr=PendingCostAmount;
                        }
                        Column(ExecCostAmount_ManagementExpenses2; ExecCostAmount)
                        {
                            //SourceExpr=ExecCostAmount;
                        }
                        Column(TotCostAmount_ManagementExpenses2; TotCostAmount)
                        {
                            //SourceExpr=TotCostAmount;
                        }
                        Column(TotalSale_ManagementExpenses2; TotalSale)
                        {
                            //SourceExpr=TotalSale;
                        }
                        Column(ExecSale_ManagementExpenses2; ExecSale)
                        {
                            //SourceExpr=ExecSale;
                        }
                        Column(PendingSale_ManagementExpenses2; PendingSale)
                        {
                            //SourceExpr=PendingSale;
                        }
                        Column(PendingCostAmount_ManagementExpenses3; PendingCostAmount)
                        {
                            //SourceExpr=PendingCostAmount;
                        }
                        Column(ExecCostAmount_ManagementExpenses3; ExecCostAmount)
                        {
                            //SourceExpr=ExecCostAmount;
                        }
                        Column(TotCostAmount_ManagementExpenses3; TotCostAmount)
                        {
                            //SourceExpr=TotCostAmount;
                        }
                        DataItem("Data Cost By Piecework2"; "Data Cost By Piecework")
                        {

                            DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Ascending);
                            DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                            Column(Description_DataCostByPiecework2; "Data Cost By Piecework2".Description)
                            {
                                //SourceExpr="Data Cost By Piecework2".Description;
                            }
                            Column(No_DataCostByPiecework2; "Data Cost By Piecework2"."No.")
                            {
                                //SourceExpr="Data Cost By Piecework2"."No.";
                            }
                            Column(JobNo_DataCostByPiecework2; "Data Cost By Piecework2"."Job No.")
                            {
                                //SourceExpr="Data Cost By Piecework2"."Job No.";
                            }
                            Column(PieceworkCode_DataCostByPiecework2; "Data Cost By Piecework2"."Piecework Code")
                            {
                                //SourceExpr="Data Cost By Piecework2"."Piecework Code";
                            }
                            Column(CodBudget_DataCostByPiecework2; "Data Cost By Piecework2"."Cod. Budget")
                            {
                                //SourceExpr="Data Cost By Piecework2"."Cod. Budget";
                            }
                            Column(CostType_DataCostByPiecework2; "Data Cost By Piecework2"."Cost Type")
                            {
                                //SourceExpr="Data Cost By Piecework2"."Cost Type";
                            }
                            Column(AmountCostPendingLine_DataCostByPiecework2; AmountCostPendingLine)
                            {
                                //SourceExpr=AmountCostPendingLine;
                            }
                            Column(PcostPendingLine_DataCostByPiecework2; PcostPendingLine)
                            {
                                //SourceExpr=PcostPendingLine;
                            }
                            Column(MeasurementPendingLine_DataCostByPiecework2; MeasurementPendingLine)
                            {
                                //SourceExpr=MeasurementPendingLine ;
                            }
                            //D7 Triggers
                            trigger OnPreDataItem();
                            BEGIN
                                SETRANGE("Cod. Budget", Budget_In_Process);

                                SETFILTER("Filter Date", '%1..%2', 0D, Date);
                            END;

                            trigger OnAfterGetRecord();
                            BEGIN
                                CALCFIELDS("Data Cost By Piecework2"."Measure Product Exec.", "Data Cost By Piecework2"."Measure Resource Exec.",
                                           "Data Cost By Piecework2"."Product Exec. Cost", "Data Cost By Piecework2"."Resource Exec. Cost");

                                IF "Data Cost By Piecework"."Cost Type" = "Data Cost By Piecework"."Cost Type"::Item THEN BEGIN
                                    IF "Measure Product Exec." <> 0 THEN
                                        PCost := "Product Exec. Cost" / "Measure Product Exec."
                                    ELSE
                                        PCost := 0;

                                    ExecMeasurement_ := "Measure Product Exec.";
                                    Exec_Amount := "Product Exec. Cost";
                                END ELSE BEGIN
                                    IF "Measure Resource Exec." <> 0 THEN
                                        PCost := "Resource Exec. Cost" / "Measure Resource Exec."
                                    ELSE
                                        PCost := 0;
                                    ExecMeasurement_ := "Measure Resource Exec.";
                                    Exec_Amount := "Resource Exec. Cost";
                                END;

                                MeasurementPendingLine := "Data Cost By Piecework2"."Performance By Piecework";
                                AmountCostPendingLine := MeasurementPendingLine * "Data Cost By Piecework2"."Direct Unitary Cost (JC)";
                                PcostPendingLine := "Data Cost By Piecework2"."Direct Unitary Cost (JC)";

                                IF "Data Cost By Piecework2"."Cost Type" = "Data Cost By Piecework2"."Cost Type"::Item THEN BEGIN
                                    IF ("Measure Product Exec." + MeasurementPendingLine) <> 0 THEN
                                        P_cost := (("Measure Product Exec." * PCost + MeasurementPendingLine * PcostPendingLine) / ("Data Cost By Piecework2"."Measure Product Exec." + MeasurementPendingLine))
                                    ELSE
                                        P_cost := 0;
                                    TotalMeasurementLine := "Data Cost By Piecework2"."Measure Product Exec." + MeasurementPendingLine;
                                END ELSE BEGIN
                                    IF ("Data Cost By Piecework2"."Measure Resource Exec." + MeasurementPendingLine) <> 0 THEN
                                        P_cost := (("Data Cost By Piecework2"."Measure Resource Exec." * PCost + MeasurementPendingLine * PcostPendingLine) / ("Data Cost By Piecework2"."Measure Resource Exec." + MeasurementPendingLine))
                                    ELSE
                                        P_cost := 0;
                                    TotalMeasurementLine := "Data Cost By Piecework2"."Measure Resource Exec." + MeasurementPendingLine;
                                END;

                                ExecCostAmountNotBudgeted := ExecCostAmountNotBudgeted - Exec_Amount;
                            END;


                        }
                        //D6 Triggers
                        trigger OnPreDataItem();
                        BEGIN
                            SETRANGE("Budget Filter", Budget_In_Process);

                            ManagementExpenses.SETRANGE("Subtype Cost", Integer.Number);

                            CurrReport.CREATETOTALS(TotCostAmount, ExecCostAmount, PendingCostAmount, TotalSale, ExecSale, PendingSale, Difference);
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            SETRANGE(ManagementExpenses."Filter Date");
                            SETRANGE("Budget Filter", Budget_In_Process);
                            CALCFIELDS("Budget Measure", "Amount Production Budget", "Amount Cost Budget (JC)");
                            SETRANGE(ManagementExpenses."Filter Date", 0D, Date);
                            CALCFIELDS("Aver. Cost Price Pend. Budget");
                            SETRANGE("Budget Filter");
                            CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");
                            SETRANGE("Budget Filter", Budget_In_Process);

                            NumMonthStartJob(NumMonthFromStart, Job."End Prov. Date Construction", Job."Init Real Date Construction");
                            IF NumMonthFromStart = 0 THEN
                                NumMonthFromStart := 1;

                            TotMeasurement := NumMonthFromStart;

                            IF ManagementExpenses."Subtype Cost" <> ManagementExpenses."Subtype Cost"::"Current Expenses" THEN BEGIN
                                TotCostAmount := ManagementExpenses."Amount Cost Budget (JC)";
                                IF TotMeasurement <> 0 THEN
                                    PcosTot := TotCostAmount / TotMeasurement
                                ELSE
                                    PcosTot := 0;
                            END;

                            ExecCostAmount := "Amount Cost Performed (JC)";
                            ExecCostAmountNotBudgeted := ExecCostAmount;
                            NumMonthStartJob(NumMonthFromStart, Date, Job."Init Real Date Construction");

                            IF NumMonthFromStart = 0 THEN
                                NumMonthFromStart := 1;
                            ExecMeasurement := NumMonthFromStart;
                            IF ExecMeasurement <> 0 THEN
                                PcosExec := ExecCostAmount / ExecMeasurement
                            ELSE
                                PcosExec := ExecCostAmount;

                            //se calcula el pendiente COMO PLANIFICADO A FUTURO
                            PendingMeasurement := 0;
                            IF ManagementExpenses."Subtype Cost" = ManagementExpenses."Subtype Cost"::"Current Expenses" THEN BEGIN
                                SETRANGE(ManagementExpenses."Filter Date", Date + 1, 99991231D);
                                CALCFIELDS("Amount Cost Budget (JC)");
                                PendingCostAmount := "Amount Cost Budget (JC)";
                                PcosPending := "Aver. Cost Price Pend. Budget";
                                PendingMeasurement := 0;
                                FromDate := Date + 1;
                                REPEAT
                                    SETRANGE(ManagementExpenses."Filter Date", FromDate, CALCDATE('PM', FromDate));
                                    CALCFIELDS("Amount Cost Budget (JC)");
                                    IF "Amount Cost Budget (JC)" <> 0 THEN
                                        PendingMeasurement := PendingMeasurement + 1;

                                    FromDate := CALCDATE('PM', FromDate);
                                    IF FromDate <> 99991231D THEN
                                        FromDate := FromDate + 1;
                                UNTIL FromDate >= Job."End Prov. Date Construction";

                                SETRANGE(ManagementExpenses."Filter Date");
                                ManagementExpenses.CALCFIELDS("Measure Pending Budget");
                                IF PendingMeasurement < ManagementExpenses."Measure Pending Budget" THEN
                                    PendingMeasurement := ManagementExpenses."Measure Pending Budget";
                            END ELSE BEGIN
                                SETRANGE(ManagementExpenses."Filter Date");
                                ManagementExpenses.CALCFIELDS("Measure Pending Budget");
                                PendingMeasurement := ManagementExpenses."Measure Pending Budget";
                            END;

                            IF PendingMeasurement <> 0 THEN
                                PcosPending := PendingCostAmount / PendingMeasurement
                            ELSE
                                PcosPending := PendingCostAmount;

                            IF ManagementExpenses."Type Unit Cost" = ManagementExpenses."Type Unit Cost"::External THEN BEGIN
                                PendingMeasurement := 0;
                                TotMeasurement := 0;
                                ExecMeasurement := 0;
                                PcosTot := 0;
                                PcosExec := 0;
                                PcosPending := 0;
                                PendingCostAmount := TotCostAmount - ExecCostAmount;
                            END;

                            IF ManagementExpenses."Subtype Cost" = ManagementExpenses."Subtype Cost"::"Deprec. Anticipated" THEN BEGIN
                                PendingCostAmount := TotCostAmount - ExecCostAmount;
                                IF PendingMeasurement <> 0 THEN
                                    PcosPending := PendingCostAmount / PendingMeasurement
                                ELSE
                                    PcosPending := PendingCostAmount;
                            END;

                            IF ManagementExpenses."Subtype Cost" = ManagementExpenses."Subtype Cost"::"Deprec. Deferred" THEN BEGIN
                                PendingCostAmount := TotCostAmount - ExecCostAmount;
                                IF PendingMeasurement <> 0 THEN
                                    PcosPending := PendingCostAmount / PendingMeasurement
                                ELSE
                                    PcosPending := PendingCostAmount;
                            END;

                            IF ManagementExpenses."Subtype Cost" = ManagementExpenses."Subtype Cost"::"Current Expenses" THEN BEGIN
                                TotCostAmount := ExecCostAmount + PendingCostAmount;
                                IF TotMeasurement <> 0 THEN
                                    PcosTot := TotCostAmount / TotMeasurement
                                ELSE
                                    PcosTot := 0;
                            END;

                            TotalSale := ManagementExpenses."Amount Production Budget";
                            ExecSale := ManagementExpenses."Amount Production Performed";
                            PendingSale := TotalSale - ExecSale;

                            Piecework_ := COPYSTR("Piecework Code", STRLEN(Title) + 1);

                            SaleInProcess := ROUND("Amount Production Performed" * (1 - ("% Processed Production" / 100)), 0.01);
                            SaleProcessed := ROUND("Amount Production Performed" * ("% Processed Production" / 100), 0.01);
                            BudgetInProcess := ROUND(("Amount Production Budget" * (100 - "% Processed Production") / 100), 0.01);
                            BudgetProcessed := ROUND(("Amount Production Budget" * "% Processed Production" / 100), 0.01);

                            GeneralTotal_TotalExecSale_Process := GeneralTotal_TotalExecSale_Process + SaleInProcess;
                            GeneralTotal_PendingCostAmount_Process := GeneralTotal_PendingCostAmount_Process + (BudgetInProcess - SaleInProcess);
                            GeneralTotal_TotalTotalSale_Process := GeneralTotal_TotalTotalSale_Process + BudgetInProcess;
                            GeneralTotal_TotalExecSale_ := GeneralTotal_TotalExecSale_ + SaleProcessed;
                            GeneralTotal_TotalPendingSale_ := GeneralTotal_TotalPendingSale_ + (BudgetProcessed - SaleProcessed);
                            GeneralTotal_TotalTotalSale_ := GeneralTotal_TotalTotalSale_ + BudgetProcessed;

                            GeneralTotal_TotalTotalSale_Gross := GeneralTotal_TotalTotalSale_Gross + TotalSale;
                            GeneralTotal_TotalExecSale_Gross := GeneralTotal_TotalExecSale_Gross + ExecSale;
                            GeneralTotal_TotalPendingSale_Gross := GeneralTotal_TotalPendingSale_Gross + PendingSale;

                            GeneralTotal_TotCostAmount_ := GeneralTotal_TotCostAmount_ + ROUND(TotCostAmount * "% Processed Production" / 100, 0.01);
                            GeneralTotal_ExecCostAmount_ := GeneralTotal_ExecCostAmount_ + ROUND(ExecCostAmount * "% Processed Production" / 100, 0.01);
                            GeneralTotal_PendingCostAmount_ := GeneralTotal_PendingCostAmount_ + ROUND(PendingCostAmount * "% Processed Production" / 100, 0.01);

                            GeneralTotal_TotCostAmount_Gross := GeneralTotal_TotCostAmount_Gross + TotCostAmount;
                            GeneralTotal_ExecCostAmount_Gross := GeneralTotal_ExecCostAmount_Gross + ExecCostAmount;
                            GeneralTotal_PendingCostAmount_Gross := GeneralTotal_PendingCostAmount_Gross + PendingCostAmount;
                        END;


                    }
                    //D5 Triggers
                    trigger OnPreDataItem();
                    BEGIN

                        Integer.SETRANGE(Number, "Data Piecework For Production"."Subtype Cost"::"Deprec. Anticipated"
                                               , "Data Piecework For Production"."Subtype Cost"::Others);

                        CurrReport.CREATETOTALS(TotCostAmount, ExecCostAmount, PendingCostAmount, TotalSale, ExecSale, PendingSale, Difference);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        DataPieceworkForProduction2.SETRANGE("Job No.", Job2."No.");
                        DataPieceworkForProduction2.SETRANGE(Type, DataPieceworkForProduction2.Type::"Cost Unit");
                        DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
                        DataPieceworkForProduction2.SETRANGE("Subtype Cost", Integer.Number);
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", Budget_In_Process);
                        IF NOT DataPieceworkForProduction2.FINDFIRST THEN
                            CurrReport.SKIP;

                        CASE Integer.Number OF
                            1:
                                TittleName := Text0007;
                            2:
                                TittleName := Text0008;
                            3:
                                TittleName := Text0009;
                            4:
                                TittleName := Text0010;
                            5:
                                TittleName := Text0011;
                            6:
                                TittleName := Text0012;
                        END;
                    END;


                }
                //D4 Triggers
                trigger OnPreDataItem();
                BEGIN
                    CurrReport.CREATETOTALS(TotCostAmount, ExecCostAmount, PendingDeliveryBill2, PendingCostAmount, TotalSale, ExecSale, PendingSale, Difference);
                END;


            }
            //Selection Triggers
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);

                CurrReport.CREATETOTALS(TotCostAmount, ExecCostAmount, PendingCostAmount, PendingDeliveryBill, PendingCostAmount, TotalSale, ExecSale, PendingSale);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF GETFILTER(Selection."Budget Filter") <> '' THEN
                    Budget_In_Process := GETFILTER(Selection."Budget Filter")
                ELSE BEGIN
                    IF Selection."Current Piecework Budget" <> '' THEN
                        Budget_In_Process := Selection."Current Piecework Budget"
                    ELSE
                        Budget_In_Process := Selection."Initial Budget Piecework";
                END;

                Selection.SETRANGE("Budget Filter", Budget_In_Process);
                JobBudget.GET(Selection."No.", Budget_In_Process);

                Date := JobBudget."Budget Date" - 1;
                IntMonth := DATE2DMY(Date, 2);
                IntYear := DATE2DMY(Date, 3);

                IF Selection."Matrix Job it Belongs" <> '' THEN
                    Job_Text := Text0003
                ELSE
                    Job_Text := Text0004;

                IF Job_Text = Text0004 THEN
                    TOTAL := Text0005
                ELSE
                    TOTAL := Text0006;

                GeneralTotal_TotCostAmount_ := 0;
                GeneralTotal_ExecCostAmount_ := 0;
                GeneralTotal_PendingCostAmount_ := 0;
                GeneralTotal_TotalTotalSale_ := 0;
                GeneralTotal_TotalExecSale_ := 0;
                GeneralTotal_TotalPendingSale_ := 0;
                GeneralTotal_TotalTotalSale_Process := 0;
                GeneralTotal_TotalExecSale_Process := 0;
                GeneralTotal_PendingCostAmount_Process := 0;
                GeneralTotal_TotCostAmount_Gross := 0;
                GeneralTotal_ExecCostAmount_Gross := 0;
                GeneralTotal_PendingCostAmount_Gross := 0;
                GeneralTotal_TotalTotalSale_Gross := 0;
                GeneralTotal_TotalExecSale_Gross := 0;
                GeneralTotal_TotalPendingSale_Gross := 0;
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
        //       Tittle@7001182 :
        Tittle: Boolean;
        //       TotMeasurement@7001181 :
        TotMeasurement: Decimal;
        //       ExecMeasurement@7001180 :
        ExecMeasurement: Decimal;
        //       PendingMeasurement@7001179 :
        PendingMeasurement: Decimal;
        //       PcosTot@7001178 :
        PcosTot: Decimal;
        //       PcosExec@7001177 :
        PcosExec: Decimal;
        //       PcosPending@7001176 :
        PcosPending: Decimal;
        //       Difference@7001175 :
        Difference: Decimal;
        //       TotCostAmount@7001174 :
        TotCostAmount: Decimal;
        //       ExecCostAmount@7001173 :
        ExecCostAmount: Decimal;
        //       PendingCostAmount@7001172 :
        PendingCostAmount: Decimal;
        //       ExecCostAmountNotBudgeted@7001171 :
        ExecCostAmountNotBudgeted: Decimal;
        //       TotalSale@7001170 :
        TotalSale: Decimal;
        //       ExecSale@7001169 :
        ExecSale: Decimal;
        //       PendingSale@7001168 :
        PendingSale: Decimal;
        //       Job_Text@7001167 :
        Job_Text: Text[30];
        //       TotalTotCostAmount@7001166 :
        TotalTotCostAmount: Decimal;
        //       TotalExecCostAmount@7001165 :
        TotalExecCostAmount: Decimal;
        //       TotalPendingCostAmount@7001164 :
        TotalPendingCostAmount: Decimal;
        //       TotalTotalSale@7001163 :
        TotalTotalSale: Decimal;
        //       TotalExecSale@7001162 :
        TotalExecSale: Decimal;
        //       TotalPendingSale@7001161 :
        TotalPendingSale: Decimal;
        //       Chapter@7001160 :
        Chapter: Boolean;
        //       TOTAL@7001158 :
        TOTAL: Text[30];
        //       DifferenceTotal@7001157 :
        DifferenceTotal: Decimal;
        //       CompanyInformation@7001156 :
        CompanyInformation: Record 79;
        //       PCost@7001155 :
        PCost: Decimal;
        //       MeasurementPendingLine@7001154 :
        MeasurementPendingLine: Decimal;
        //       PcostPendingLine@7001153 :
        PcostPendingLine: Decimal;
        //       AmountCostPendingLine@7001152 :
        AmountCostPendingLine: Decimal;
        //       TittleName@7001151 :
        TittleName: Text[60];
        //       DataPieceworkForProduction@7001150 :
        DataPieceworkForProduction: Record 7207386;
        //       Piecework_@7001149 :
        Piecework_: Code[20];
        //       Resource@7001148 :
        Resource: Record 156;
        //       GeneralTotalTotCostAmount@7001147 :
        GeneralTotalTotCostAmount: Decimal;
        //       GeneralTotalExecCostAmount@7001146 :
        GeneralTotalExecCostAmount: Decimal;
        //       GeneralTotalPendingCostAmount@7001145 :
        GeneralTotalPendingCostAmount: Decimal;
        //       GeneralTotalTotalSale@7001144 :
        GeneralTotalTotalSale: Decimal;
        //       GeneralTotalTotalExecSale@7001143 :
        GeneralTotalTotalExecSale: Decimal;
        //       GeneralTotalTotalPendingSale@7001142 :
        GeneralTotalTotalPendingSale: Decimal;
        //       PendingDeliveryBill@7001141 :
        PendingDeliveryBill: Decimal;
        //       JobLedgerEntry@7001140 :
        JobLedgerEntry: Record 169;
        //       PendingDeliveryBill2@7001139 :
        PendingDeliveryBill2: Decimal;
        //       P_cost@7001138 :
        P_cost: Decimal;
        //       TotalMeasurementLine@7001137 :
        TotalMeasurementLine: Decimal;
        //       ForecastDataAmountPiecework@7001136 :
        ForecastDataAmountPiecework: Record 7207392;
        //       GeneralTotal_TotCostAmount_@7001135 :
        GeneralTotal_TotCostAmount_: Decimal;
        //       GeneralTotal_ExecCostAmount_@7001134 :
        GeneralTotal_ExecCostAmount_: Decimal;
        //       GeneralTotal_PendingCostAmount_@7001133 :
        GeneralTotal_PendingCostAmount_: Decimal;
        //       GeneralTotal_TotalTotalSale_@7001132 :
        GeneralTotal_TotalTotalSale_: Decimal;
        //       GeneralTotal_TotalExecSale_@7001131 :
        GeneralTotal_TotalExecSale_: Decimal;
        //       GeneralTotal_TotalPendingSale_@7001130 :
        GeneralTotal_TotalPendingSale_: Decimal;
        //       GeneralTotal_TotalTotalSale_Process@7001129 :
        GeneralTotal_TotalTotalSale_Process: Decimal;
        //       GeneralTotal_TotalExecSale_Process@7001128 :
        GeneralTotal_TotalExecSale_Process: Decimal;
        //       GeneralTotal_PendingCostAmount_Process@7001127 :
        GeneralTotal_PendingCostAmount_Process: Decimal;
        //       GeneralTotal_TotCostAmount_Gross@7001126 :
        GeneralTotal_TotCostAmount_Gross: Decimal;
        //       GeneralTotal_ExecCostAmount_Gross@7001125 :
        GeneralTotal_ExecCostAmount_Gross: Decimal;
        //       GeneralTotal_PendingCostAmount_Gross@7001124 :
        GeneralTotal_PendingCostAmount_Gross: Decimal;
        //       GeneralTotal_TotalTotalSale_Gross@7001123 :
        GeneralTotal_TotalTotalSale_Gross: Decimal;
        //       GeneralTotal_TotalExecSale_Gross@7001183 :
        GeneralTotal_TotalExecSale_Gross: Decimal;
        //       GeneralTotal_TotalPendingSale_Gross@7001122 :
        GeneralTotal_TotalPendingSale_Gross: Decimal;
        //       SaleInProcess@7001120 :
        SaleInProcess: Decimal;
        //       SaleProcessed@7001119 :
        SaleProcessed: Decimal;
        //       BudgetInProcess@7001118 :
        BudgetInProcess: Decimal;
        //       BudgetProcessed@7001117 :
        BudgetProcessed: Decimal;
        //       ExecMeasurement_@7001116 :
        ExecMeasurement_: Decimal;
        //       Exec_Amount@7001115 :
        Exec_Amount: Decimal;
        //       Date@7001114 :
        Date: Date;
        //       IntYear@7001113 :
        IntYear: Integer;
        //       IntMonth@7001112 :
        IntMonth: Integer;
        //       NumMonthFromStart@7001111 :
        NumMonthFromStart: Integer;
        //       FromDate@7001110 :
        FromDate: Date;
        //       DataPieceworkForProduction2@7001109 :
        DataPieceworkForProduction2: Record 7207386;
        //       Budget_In_Process@7001108 :
        Budget_In_Process: Code[20];
        //       TotDiff@7001107 :
        TotDiff: Decimal;
        //       ExecDiff@7001106 :
        ExecDiff: Decimal;
        //       PendDiff@7001105 :
        PendDiff: Decimal;
        //       TotalGrossDiff@7001104 :
        TotalGrossDiff: Decimal;
        //       ExecGrossDiff@7001103 :
        ExecGrossDiff: Decimal;
        //       PendingGrossDiff@7001102 :
        PendingGrossDiff: Decimal;
        //       JobBudget@7001101 :
        JobBudget: Record 7207407;
        //       Text0001@7001225 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Text0002@7001224 :
        Text0002: TextConst ENU = 'You must indicate report date', ESP = 'Debe indicar fecha de informe';
        //       Text50000@7001223 :
        Text50000: TextConst ENU = 'You must indicate year and month of job report', ESP = 'Debe indicar a¤o y mes del informe de obra';
        //       OPERATION_Lbl@7001222 :
        OPERATION_Lbl: TextConst ENU = 'OPERATION', ESP = 'OPERACIàN';
        //       UN_Lbl@7001221 :
        UN_Lbl: TextConst ENU = 'UN', ESP = 'UD';
        //       DESCRIPTION_Lbl@7001220 :
        DESCRIPTION_Lbl: TextConst ENU = 'DESCRIPTION', ESP = 'DESCRIPCIàN';
        //       Measurement_Lbl@7001219 :
        Measurement_Lbl: TextConst ENU = 'Measurement', ESP = 'Medici¢n';
        //       CostPrice_Lbl@7001218 :
        CostPrice_Lbl: TextConst ENU = 'Cost Price', ESP = 'Pcio Coste';
        //       CostAmount_Lbl@7001217 :
        CostAmount_Lbl: TextConst ENU = 'Cost Amount', ESP = 'Imp. Coste';
        //       Total_Lbl@7001216 :
        Total_Lbl: TextConst ENU = 'Total', ESP = 'Total';
        //       Exec_Lbl@7001215 :
        Exec_Lbl: TextConst ENU = 'Executed', ESP = 'Ejecutado';
        //       Pending_Lbl@7001211 :
        Pending_Lbl: TextConst ENU = 'Pending', ESP = 'Pendiente';
        //       TotalJob_Lbl@7001207 :
        TotalJob_Lbl: TextConst ENU = 'Job Total', ESP = 'Total Obra';
        //       TotalProduction_Lbl@7001206 :
        TotalProduction_Lbl: TextConst ENU = 'Total Production', ESP = 'Prod. Total';
        //       PendingProduction_Lbl@7001205 :
        PendingProduction_Lbl: TextConst ENU = 'Pending production', ESP = 'Prod. pte';
        //       TR_Lbl@7001204 :
        TR_Lbl: TextConst ENU = 'TR', ESP = 'TR';
        //       MONTH_Lbl@7001203 :
        MONTH_Lbl: TextConst ENU = 'MONTH:', ESP = 'MES:';
        //       YEAR_Lbl@7001202 :
        YEAR_Lbl: TextConst ENU = 'YEAR:', ESP = 'A¥O:';
        //       DELEGATION_Lbl@7001201 :
        DELEGATION_Lbl: TextConst ENU = 'DELEGATION:', ESP = 'DELEGACIàN:';
        //       ADDRESS_Lbl@7001200 :
        ADDRESS_Lbl: TextConst ENU = 'ADDRESS:', ESP = 'DIRECCIàN:';
        //       JOB_Lbl@7001199 :
        JOB_Lbl: TextConst ENU = 'JOB:', ESP = 'PROY.:';
        //       PLANNINGBYPIECEWORK_Lbl@7001198 :
        PLANNINGBYPIECEWORK_Lbl: TextConst ENU = 'PLANNING BY PIECEWORK', ESP = 'PLANIFICACIàN POR UNIDADES DE OBRA';
        //       Page_Lbl@7001197 :
        Page_Lbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       FORECASTDATE_Lbl@7001196 :
        FORECASTDATE_Lbl: TextConst ENU = 'FORECAST DATE:', ESP = 'FECHA PREVISIàN:';
        //       FORECAST_NO_Lbl@7001195 :
        FORECAST_NO_Lbl: TextConst ENU = 'FORECAST No.', ESP = 'N§ PREVISIàN:';
        //       COST_Lbl@7001194 :
        COST_Lbl: TextConst ENU = 'COST', ESP = 'COSTE';
        //       PRODUCTION_Lbl@7001193 :
        PRODUCTION_Lbl: TextConst ENU = 'PRODUCTION', ESP = 'PRODUCCIàN';
        //       TOTALCOSTS_Lbl@7001192 :
        TOTALCOSTS_Lbl: TextConst ENU = 'TOTAL COSTS', ESP = 'COSTES TOTALES';
        //       TOTAL_PRODUCTION_Lbl@7001191 :
        TOTAL_PRODUCTION_Lbl: TextConst ENU = 'TOTAL PRODUCTION', ESP = 'PRODUCCIàN TOTAL';
        //       DIFFERENCE_Lbl@7001190 :
        DIFFERENCE_Lbl: TextConst ENU = 'DIFFERENCE', ESP = 'DIFERENCIA';
        //       DIRECTTOTALCOST_Lbl@7001189 :
        DIRECTTOTALCOST_Lbl: TextConst ENU = 'DIRECT TOTAL COST', ESP = 'TOTAL COSTE DIRECTO';
        //       Chapter_Lbl@7001186 :
        Chapter_Lbl: TextConst ENU = 'Chapter', ESP = 'Cap¡tulo';
        //       ChapterTotal_Lbl@7001185 :
        ChapterTotal_Lbl: TextConst ENU = 'Chapter Total', ESP = 'Total cap¡tulo';
        //       INDIRECTANDEXTERNAL_Lbl@7001184 :
        INDIRECTANDEXTERNAL_Lbl: TextConst ENU = 'INDIRECT and EXTERNAL', ESP = 'INDIRECTOS Y EXTERNOS';
        //       INDIRECT_EXTERNAL_T_Lbl@7001121 :
        INDIRECT_EXTERNAL_T_Lbl: TextConst ENU = 'INDIRECT and EXTERNAL T.', ESP = 'T. INDIRECTOS Y EXTERNOS';
        //       Type_Lbl@7001100 :
        Type_Lbl: TextConst ENU = 'Type ', ESP = 'Tipo ';
        //       Text0003@7001159 :
        Text0003: TextConst ENU = 'Record', ESP = 'Expediente';
        //       Text0004@7001187 :
        Text0004: TextConst ENU = 'Job', ESP = 'Obra';
        //       Text0005@7001188 :
        Text0005: TextConst ENU = 'Job Total', ESP = 'Total Obra';
        //       Text0006@7001208 :
        Text0006: TextConst ENU = 'Record Total', ESP = 'Total Expediente';
        //       Text0007@7001209 :
        Text0007: TextConst ENU = 'Deprec. Anticipated', ESP = 'Gastos anticipados';
        //       Text0008@7001210 :
        Text0008: TextConst ENU = 'Current Expenses', ESP = 'Gastos Corrientes';
        //       Text0009@7001212 :
        Text0009: TextConst ENU = 'Deprec. Inmovilized', ESP = 'Amortizaci¢n de Inmovilizado';
        //       Text0010@7001213 :
        Text0010: TextConst ENU = 'Deprec. Deferred', ESP = 'Gastos Diferidos';
        //       Text0011@7001214 :
        Text0011: TextConst ENU = 'Financial Charges', ESP = 'Cargas Financieras';
        //       Text0012@7001226 :
        Text0012: TextConst ENU = 'Others', ESP = 'Tasas';
        //       Piecework_Lbl@7001227 :
        Piecework_Lbl: TextConst ENU = 'PIECEWORK', ESP = 'UNIDAD DE OBRA';

    //     procedure ReportDate (PAReportDate@1100251000 :
    procedure ReportDate(PAReportDate: Date)
    begin
        Date := PAReportDate;
    end;

    //     procedure NumMonthStartJob (var PANumberOfMonths@1100251000 : Integer;PAUntilDate@1100251002 : Date;PAStartReportDate@1100251003 :
    procedure NumMonthStartJob(var PANumberOfMonths: Integer; PAUntilDate: Date; PAStartReportDate: Date)
    var
        //       LODate@1100251001 :
        LODate: Date;
        //       LODataPieceworkForProduction@1100000 :
        LODataPieceworkForProduction: Record 7207386;
    begin
        PANumberOfMonths := 0;

        LODataPieceworkForProduction.GET(ManagementExpenses."Job No.", ManagementExpenses."Piecework Code");
        LODataPieceworkForProduction.SETRANGE("Budget Filter", Budget_In_Process);
        LODate := DMY2DATE(1, DATE2DMY(PAStartReportDate, 2), DATE2DMY(PAStartReportDate, 3));
        if LODate >= PAUntilDate then
            PANumberOfMonths := 1
        else begin
            repeat
                LODataPieceworkForProduction.SETRANGE("Filter Date", LODate, CALCDATE('PM', LODate));
                LODataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                if LODataPieceworkForProduction."Amount Cost Budget (JC)" <> 0 then
                    PANumberOfMonths := PANumberOfMonths + 1;
                LODate := CALCDATE('PM', LODate) + 1;
            until LODate > PAUntilDate
        end;
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="Piecework Code";
