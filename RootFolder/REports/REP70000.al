report 70000 "Operat. projects without leBAK"
{


    CaptionML = ENU = 'Operat. projects without level', ESP = 'Proyectos Operativos sin nivel';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);
            ;
            Column(No_Job; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            Column(Description_Job; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            Column(Description2_Job; Job."Description 2")
            {
                //SourceExpr=Job."Description 2";
            }
            Column(Job_No_Descrip_Descrip2; Job."No." + ' ' + Job.Description + ' ' + Job."Description 2")
            {
                //SourceExpr=Job."No." + ' '+ Job.Description  + ' '+ Job."Description 2";
            }
            Column(Budget; Budget)
            {
                //SourceExpr=Budget;
            }
            Column(BudgetCode; BudgetCode)
            {
                //SourceExpr=BudgetCode;
            }
            Column(JobNo_BudgetCode; Job."No." + ' ' + BudgetCode)
            {
                //SourceExpr=Job."No."  + ' ' + BudgetCode;
            }
            Column(Company_Name; CompanyInformation.Name)
            {
                //SourceExpr=CompanyInformation.Name;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //OptionCaptionML=ENU='COMPANYNAME',ESP='COMPANYNAME';
                //SourceExpr=COMPANYNAME;
            }
            Column(Company_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(FirstDate; FirstDate)
            {
                //SourceExpr=FirstDate;
            }
            Column(LastDate; LastDate)
            {
                //SourceExpr=LastDate;
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending);
                DataItemLink = "Job No." = FIELD("No.");
                Column(Description_DataPieceworkForProduction; "Data Piecework For Production".Description)
                {
                    //SourceExpr="Data Piecework For Production".Description;
                }
                Column(PieceworkCode_DataPieceworkForProduction; "Data Piecework For Production"."Piecework Code")
                {
                    //SourceExpr="Data Piecework For Production"."Piecework Code";
                }
                Column(Indent_UnitWorkCode; Indent_UnitWorkCode)
                {
                    //SourceExpr=Indent_UnitWorkCode;
                }
                Column(Indent_Description; Indent_Description)
                {
                    //SourceExpr=Indent_Description;
                }
                Column(Indent_Description2; Indent_Description2)
                {
                    //SourceExpr=Indent_Description2;
                }
                Column(MeasureBudgPieceworkSol_DataPieceworkForProduction; "Data Piecework For Production"."Measure Budg. Piecework Sol")
                {
                    //SourceExpr="Data Piecework For Production"."Measure Budg. Piecework Sol";
                }
                Column(TotalMeasurementProduction_DataPieceworkForProduction; "Data Piecework For Production"."Total Measurement Production")
                {
                    //SourceExpr="Data Piecework For Production"."Total Measurement Production";
                }
                Column(ExpectedCostPrice; ExpectedCostPrice)
                {
                    //SourceExpr=ExpectedCostPrice;
                }
                Column(EstimatedCostAmount; EstimatedCostAmount)
                {
                    //SourceExpr=EstimatedCostAmount;
                }
                Column(AmountCostPerformed_DataPieceworkForProduction; "Data Piecework For Production"."Amount Cost Performed (JC)")
                {
                    //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                }
                Column(RealCostPrice; RealCostPrice)
                {
                    //SourceExpr=RealCostPrice;
                }
                Column(DescPiecework_DataPieceworkForProduction; "Data Piecework For Production"."Desc. Piecework")
                {
                    //SourceExpr="Data Piecework For Production"."Desc. Piecework";
                }
                Column(UnitOfMeasure_DataPieceworkForProduction; "Data Piecework For Production"."Unit Of Measure")
                {
                    //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                }
                Column(Type_DataPieceworkForProduction; "Data Piecework For Production".Type)
                {
                    //SourceExpr="Data Piecework For Production".Type;
                }
                Column(AccountType_DataPieceworkForProduction; "Data Piecework For Production"."Account Type")
                {
                    //SourceExpr="Data Piecework For Production"."Account Type";
                }
                Column(Indentation_DataPieceworkForProduction; "Data Piecework For Production".Indentation)
                {
                    //SourceExpr="Data Piecework For Production".Indentation;
                }
                Column(Totaling_DataPieceworkForProduction; "Data Piecework For Production".Totaling)
                {
                    //SourceExpr="Data Piecework For Production".Totaling;
                }
                Column(AmountProductionBudget_DataPieceworkForProduction; "Data Piecework For Production"."Amount Production Budget")
                {
                    //SourceExpr="Data Piecework For Production"."Amount Production Budget";
                }
                Column(SaleQuantitybase_DataPieceworkForProduction; "Data Piecework For Production"."Sale Quantity (base)")
                {
                    //SourceExpr="Data Piecework For Production"."Sale Quantity (base)";
                }
                Column(CertifiedQuantity_DataPieceworkForProduction; "Data Piecework For Production"."Certified Quantity")
                {
                    //SourceExpr="Data Piecework For Production"."Certified Quantity";
                }
                Column(CertifiedAmount_DataPieceworkForProduction; "Data Piecework For Production"."Certified Amount")
                {
                    //SourceExpr="Data Piecework For Production"."Certified Amount";
                }
                Column(CertificationPrice; CertificationPrice)
                {
                    //SourceExpr=CertificationPrice;
                }
                Column(AmountProductionPerformed_DataPieceworkForProduction; "Data Piecework For Production"."Amount Production Performed")
                {
                    //SourceExpr="Data Piecework For Production"."Amount Production Performed";
                }
                Column(PerformedWorkPrice; PerformedWorkPrice)
                {
                    //SourceExpr=PerformedWorkPrice;
                }
                Column(DeviationCost_Perc; DeviationCost_Perc)
                {
                    //SourceExpr=DeviationCost_Perc;
                }
                Column(DeviationCertificate_Perc; DeviationCertificate_Perc)
                {
                    //SourceExpr=DeviationCertificate_Perc;
                }
                Column(PorDesvCost; PorDesvCost)
                {
                    //SourceExpr=PorDesvCost;
                }
                Column(PorDesvCert; PorDesvCert)
                {
                    //SourceExpr=PorDesvCert;
                }
                Column(MonthAdvance; MonthAdvance)
                {
                    //SourceExpr=MonthAdvance;
                }
                Column(Month_Adv; Month_Adv)
                {
                    //SourceExpr=Month_Adv;
                }
                Column(TotalEstimatedCost_UWType_Month; TotalEstimatedCost_UWType_Month)
                {
                    //SourceExpr=TotalEstimatedCost_UWType_Month;
                }
                Column(TotalRealCost_UWType_Month; TotalRealCost_UWType_Month)
                {
                    //SourceExpr=TotalRealCost_UWType_Month;
                }
                Column(TotalObEjAmount_UWType_Month; TotalObEjAmount_UWType_Month)
                {
                    //SourceExpr=TotalObEjAmount_UWType_Month;
                }
                Column(TotalCertifAmount_UWType_Month; TotalCertifAmount_UWType_Month)
                {
                    //SourceExpr=TotalCertifAmount_UWType_Month;
                }
                Column(DeviationCost_UWType_Month; DeviationCost_UWType_Month)
                {
                    //SourceExpr=DeviationCost_UWType_Month;
                }
                Column(DeviationCert_UWType_Month; DeviationCert_UWType_Month)
                {
                    //SourceExpr=DeviationCert_UWType_Month;
                }
                Column(Perc_DeviationCost_UWType_Month; Perc_DeviationCost_UWType_Month)
                {
                    //SourceExpr=Perc_DeviationCost_UWType_Month;
                }
                Column(Perc_DeviationCert_UWType_Month; Perc_DeviationCert_UWType_Month)
                {
                    //SourceExpr=Perc_DeviationCert_UWType_Month;
                }
                Column(IsUnit; IsUnit)
                {
                    //SourceExpr=IsUnit;
                }
                DataItem("Begg_Data"; "2000000026")
                {

                    DataItemTableView = SORTING("Number")
                                 ORDER(Ascending)
                                 WHERE("Number" = CONST(1));
                    ;
                    Column(MeasureBudgPieceworkSol_DataPieceworkForProduction_Begg; DataPieceworkForProduction_Begg."Measure Budg. Piecework Sol")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Measure Budg. Piecework Sol";
                    }
                    Column(TotalMeasurementProduction_DataPieceworkForProduction_Begg; DataPieceworkForProduction_Begg."Total Measurement Production")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Total Measurement Production";
                    }
                    Column(Unit_Cost; Unit_Cost)
                    {
                        //SourceExpr=Unit_Cost;
                    }
                    Column(Beginning_EstimatedCostAmount; Beginning_EstimatedCostAmount)
                    {
                        //SourceExpr=Beginning_EstimatedCostAmount;
                    }
                    Column(ExpectedCostPrice_Begg; ExpectedCostPrice_Begg)
                    {
                        //SourceExpr=ExpectedCostPrice_Begg;
                    }
                    Column(AmountCostPerformed_DataPieceworkForProduction_Begg; DataPieceworkForProduction_Begg."Amount Cost Performed (JC)")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Amount Cost Performed (JC)";
                    }
                    Column(Beginning_RealCostPrice; Beginning_RealCostPrice)
                    {
                        //SourceExpr=Beginning_RealCostPrice;
                    }
                    Column(AmountProductionBudget_Begg; DataPieceworkForProduction_Begg."Amount Production Budget")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Amount Production Budget";
                    }
                    Column(SaleQuantitybase_Begg; DataPieceworkForProduction_Begg."Sale Quantity (base)")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Sale Quantity (base)";
                    }
                    Column(CertifiedQuantity_Begg; DataPieceworkForProduction_Begg."Certified Quantity")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Certified Quantity";
                    }
                    Column(CertifiedAmount_Begg; DataPieceworkForProduction_Begg."Certified Amount")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Certified Amount";
                    }
                    Column(Beginning_CertificationPrice; Beginning_CertificationPrice)
                    {
                        //SourceExpr=Beginning_CertificationPrice;
                    }
                    Column(AmountProductionPerformed_Begg; DataPieceworkForProduction_Begg."Amount Production Performed")
                    {
                        //SourceExpr=DataPieceworkForProduction_Begg."Amount Production Performed";
                    }
                    Column(Beginning_PerformedWorkPrice; Beginning_PerformedWorkPrice)
                    {
                        //SourceExpr=Beginning_PerformedWorkPrice;
                    }
                    Column(Beginning_DeviationCost_Perc; Beginning_DeviationCost_Perc)
                    {
                        //SourceExpr=Beginning_DeviationCost_Perc;
                    }
                    Column(Beginning_DeviationCertificate_Perc; Beginning_DeviationCertificate_Perc)
                    {
                        //SourceExpr=Beginning_DeviationCertificate_Perc;
                    }
                    Column(Beginning_PorDesvCost; Beginning_PorDesvCost)
                    {
                        //SourceExpr=Beginning_PorDesvCost;
                    }
                    Column(Beginning_PorDesvCert; Beginning_PorDesvCert)
                    {
                        //SourceExpr=Beginning_PorDesvCert;
                    }
                    Column(Beginning_Advance; Beginning_Advance)
                    {
                        //SourceExpr=Beginning_Advance;
                    }
                    Column(Beginning_Adv; Beginning_Adv)
                    {
                        //SourceExpr=Beginning_Adv;
                    }
                    Column(TotalEstimatedCost_UWType_Begg; TotalEstimatedCost_UWType_Begg)
                    {
                        //SourceExpr=TotalEstimatedCost_UWType_Begg;
                    }
                    Column(TotalRealCost_UWType_Begg; TotalRealCost_UWType_Begg)
                    {
                        //SourceExpr=TotalRealCost_UWType_Begg;
                    }
                    Column(TotalObEjAmount_UWType_Begg; TotalObEjAmount_UWType_Begg)
                    {
                        //SourceExpr=TotalObEjAmount_UWType_Begg;
                    }
                    Column(TotalCertifAmount_UWType_Begg; TotalCertifAmount_UWType_Begg)
                    {
                        //SourceExpr=TotalCertifAmount_UWType_Begg;
                    }
                    Column(DeviationCost_UWType_Begg; DeviationCost_UWType_Begg)
                    {
                        //SourceExpr=DeviationCost_UWType_Begg;
                    }
                    Column(DeviationCert_UWType_Begg; DeviationCert_UWType_Begg)
                    {
                        //SourceExpr=DeviationCert_UWType_Begg;
                    }
                    Column(Perc_DeviationCost_UWType_Begg; Perc_DeviationCost_UWType_Begg)
                    {
                        //SourceExpr=Perc_DeviationCost_UWType_Begg;
                    }
                    Column(Perc_DeviationCert_UWType_Begg; Perc_DeviationCert_UWType_Begg)
                    {
                        //SourceExpr=Perc_DeviationCert_UWType_Begg;
                    }
                    DataItem("Total"; "2000000026")
                    {

                        DataItemTableView = SORTING("Number")
                                 ORDER(Ascending)
                                 WHERE("Number" = CONST(1));
                        ;
                        Column(TotalEstimatedCost_Month; TotalEstimatedCost_Month)
                        {
                            //SourceExpr=TotalEstimatedCost_Month;
                        }
                        Column(TotalRealCost_Month; TotalRealCost_Month)
                        {
                            //SourceExpr=TotalRealCost_Month;
                        }
                        Column(TotalObEjAmount_Month; TotalObEjAmount_Month)
                        {
                            //SourceExpr=TotalObEjAmount_Month;
                        }
                        Column(TotalCertifAmount_Month; TotalCertifAmount_Month)
                        {
                            //SourceExpr=TotalCertifAmount_Month;
                        }
                        Column(Tot_DeviationCost_Month; Tot_DeviationCost_Month)
                        {
                            //SourceExpr=Tot_DeviationCost_Month;
                        }
                        Column(Tot_DeviationCert_Month; Tot_DeviationCert_Month)
                        {
                            //SourceExpr=Tot_DeviationCert_Month;
                        }
                        Column(Tot_Perc_DeviationCost_Month; Tot_Perc_DeviationCost_Month)
                        {
                            //SourceExpr=Tot_Perc_DeviationCost_Month;
                        }
                        Column(Tot_Perc_DeviationCert_Month; Tot_Perc_DeviationCert_Month)
                        {
                            //SourceExpr=Tot_Perc_DeviationCert_Month;
                        }
                        Column(TotalEstimatedCost_Begg; TotalEstimatedCost_Begg)
                        {
                            //SourceExpr=TotalEstimatedCost_Begg;
                        }
                        Column(TotalRealCost_Begg; TotalRealCost_Begg)
                        {
                            //SourceExpr=TotalRealCost_Begg;
                        }
                        Column(TotalObEjAmount_Begg; TotalObEjAmount_Begg)
                        {
                            //SourceExpr=TotalObEjAmount_Begg;
                        }
                        Column(TotalCertifAmount_Begg; TotalCertifAmount_Begg)
                        {
                            //SourceExpr=TotalCertifAmount_Begg;
                        }
                        Column(Tot_DeviationCost_Begg; Tot_DeviationCost_Begg)
                        {
                            //SourceExpr=Tot_DeviationCost_Begg;
                        }
                        Column(Tot_DeviationCert_Begg; Tot_DeviationCert_Begg)
                        {
                            //SourceExpr=Tot_DeviationCert_Begg;
                        }
                        Column(Tot_Perc_DeviationCost_Begg; Tot_Perc_DeviationCost_Begg)
                        {
                            //SourceExpr=Tot_Perc_DeviationCost_Begg;
                        }
                        Column(Tot_Perc_DeviationCert_Begg; Tot_Perc_DeviationCert_Begg)
                        {
                            //SourceExpr=Tot_Perc_DeviationCert_Begg;
                        }
                        Column(PeriodResult; PeriodResult)
                        {
                            //SourceExpr=PeriodResult;
                        }
                        Column(Perc_PeriodResult; Perc_PeriodResult)
                        {
                            //SourceExpr=Perc_PeriodResult;
                        }
                        Column(BeggResult; BeggResult)
                        {
                            //SourceExpr=BeggResult;
                        }
                        Column(Perc_BeggResult; Perc_BeggResult)
                        {
                            //SourceExpr=Perc_BeggResult ;
                        }
                        trigger OnAfterGetRecord();
                        BEGIN
                            //-------------------------------------------------TOTALES MES---------------------------------------------------------//
                            Tot_DeviationCost_Month := 0;
                            Tot_DeviationCert_Month := 0;
                            Tot_Perc_DeviationCost_Month := 0;
                            Tot_Perc_DeviationCert_Month := 0;

                            DataPFProd_Month_Total.RESET;
                            DataPFProd_Month_Total.SETRANGE(DataPFProd_Month_Total."Job No.", Job."No.");
                            DataPFProd_Month_Total.SETRANGE(DataPFProd_Month_Total."Account Type", DataPFProd_Month_Total."Account Type"::Unit);
                            DataPFProd_Month_Total.SETFILTER(DataPFProd_Month_Total."Filter Date", '%1..%2', FirstDate, LastDate);
                            DataPFProd_Month_Total.SETFILTER(DataPFProd_Month_Total."Budget Filter", BudgetCode);
                            DataPFProd_Month_Total.SETAUTOCALCFIELDS(DataPFProd_Month_Total."Amount Cost Performed (JC)", DataPFProd_Month_Total."Amount Production Performed",
                                                           DataPFProd_Month_Total."Certified Amount");

                            IF DataPFProd_Month_Total.FINDSET(FALSE, FALSE) THEN
                                REPEAT
                                    TotalEstimatedCost_Month += DataPFProd_Month_Total.AmountCostTheoreticalProduction(JobBudget."Cod. Budget", DataPFProd_Month_Total);
                                    TotalRealCost_Month += DataPFProd_Month_Total."Amount Cost Performed (JC)";
                                    TotalObEjAmount_Month += DataPFProd_Month_Total."Amount Production Performed";
                                    TotalCertifAmount_Month += DataPFProd_Month_Total."Certified Amount";
                                UNTIL DataPFProd_Month_Total.NEXT = 0;

                            Tot_DeviationCost_Month := (TotalRealCost_Month - TotalEstimatedCost_Month);
                            Tot_DeviationCert_Month := (TotalCertifAmount_Month - TotalObEjAmount_Month);

                            IF TotalEstimatedCost_Month <> 0 THEN
                                Tot_Perc_DeviationCost_Month := 100 * Tot_DeviationCost_Month / TotalEstimatedCost_Month;
                            IF TotalObEjAmount_Month <> 0 THEN
                                Tot_Perc_DeviationCert_Month := 100 * Tot_DeviationCert_Month / TotalObEjAmount_Month;

                            //-------------------------------------------------TOTALES ORIGEN---------------------------------------------------------//
                            Tot_DeviationCost_Begg := 0;
                            Tot_DeviationCert_Begg := 0;
                            Tot_Perc_DeviationCost_Begg := 0;
                            Tot_Perc_DeviationCert_Begg := 0;

                            DataPFProd_Begg_Total.RESET;
                            DataPFProd_Begg_Total.SETRANGE(DataPFProd_Begg_Total."Job No.", Job."No.");
                            DataPFProd_Begg_Total.SETRANGE(DataPFProd_Begg_Total."Account Type", DataPFProd_Begg_Total."Account Type"::Unit);
                            DataPFProd_Begg_Total.SETFILTER(DataPFProd_Begg_Total."Filter Date", '..%1', LastDate);
                            DataPFProd_Begg_Total.SETFILTER(DataPFProd_Begg_Total."Budget Filter", BudgetCode);
                            DataPFProd_Begg_Total.SETAUTOCALCFIELDS(DataPFProd_Begg_Total."Amount Cost Performed (JC)", DataPFProd_Begg_Total."Amount Production Performed",
                                                           DataPFProd_Begg_Total."Certified Amount");

                            IF DataPFProd_Begg_Total.FINDSET(FALSE, FALSE) THEN
                                REPEAT
                                    TotalEstimatedCost_Begg += DataPFProd_Begg_Total.AmountCostTheoreticalProduction(JobBudget."Cod. Budget", DataPFProd_Begg_Total);
                                    TotalRealCost_Begg += DataPFProd_Begg_Total."Amount Cost Performed (JC)";
                                    TotalObEjAmount_Begg += DataPFProd_Begg_Total."Amount Production Performed";
                                    TotalCertifAmount_Begg += DataPFProd_Begg_Total."Certified Amount";
                                UNTIL DataPFProd_Begg_Total.NEXT = 0;

                            Tot_DeviationCost_Begg := (TotalRealCost_Begg - TotalEstimatedCost_Begg);
                            Tot_DeviationCert_Begg := (TotalCertifAmount_Begg - TotalObEjAmount_Begg);

                            IF TotalEstimatedCost_Begg <> 0 THEN
                                Tot_Perc_DeviationCost_Begg := 100 * Tot_DeviationCost_Begg / TotalEstimatedCost_Begg;
                            IF TotalObEjAmount_Begg <> 0 THEN
                                Tot_Perc_DeviationCert_Begg := 100 * Tot_DeviationCert_Begg / TotalObEjAmount_Begg;

                            PeriodResult := TotalObEjAmount_Month - TotalRealCost_Month;
                            IF TotalObEjAmount_Month <> 0 THEN
                                Perc_PeriodResult := 100 * PeriodResult / TotalObEjAmount_Month;

                            BeggResult := TotalObEjAmount_Begg - TotalRealCost_Begg;
                            IF TotalObEjAmount_Begg <> 0 THEN
                                Perc_BeggResult := 100 * BeggResult / TotalObEjAmount_Begg;
                        END;


                    }
                    trigger OnAfterGetRecord();
                    BEGIN
                        IF (FirstPage) THEN
                            FirstPage := FALSE
                        ELSE
                            CLEAR(CompanyInformation.Picture);

                        DataPieceworkForProduction_Begg.SETFILTER(DataPieceworkForProduction_Begg."Filter Date", '<=%1', LastDate);
                        DataPieceworkForProduction_Begg.SETFILTER(DataPieceworkForProduction_Begg."Budget Filter", BudgetCode);

                        //-------------------------------------------CAMPOS CALCULADOS-------------------------------------------//
                        DataPieceworkForProduction_Begg.CALCFIELDS(
                                   DataPieceworkForProduction_Begg."Measure Budg. Piecework Sol",
                                   DataPieceworkForProduction_Begg."Total Measurement Production",
                                   DataPieceworkForProduction_Begg."Amount Cost Performed (JC)",
                                   DataPieceworkForProduction_Begg."Certified Quantity",
                                   DataPieceworkForProduction_Begg."Certified Amount",
                                   DataPieceworkForProduction_Begg."Amount Production Performed");


                        IF DataPieceworkForProduction_Begg."Account Type" = DataPieceworkForProduction_Begg."Account Type"::Unit THEN
                            IsUnit := TRUE
                        ELSE
                            IsUnit := FALSE; //+001

                        //---------------------------------------------- AVANCE UDS-----------------------------------------------//
                        MonthAdvance := 0;
                        Beginning_Adv := FALSE;
                        Beginning_Advance := 0;
                        IF DataPieceworkForProduction_Begg."Measure Budg. Piecework Sol" > 0 THEN BEGIN
                            MonthAdvance := 100 * "Data Piecework For Production"."Total Measurement Production" / DataPieceworkForProduction_Begg."Measure Budg. Piecework Sol";
                            Beginning_Advance := 100 * DataPieceworkForProduction_Begg."Total Measurement Production" / DataPieceworkForProduction_Begg."Measure Budg. Piecework Sol";
                            Month_Adv := TRUE;
                            Beginning_Adv := TRUE;
                        END;

                        //---------------------------------------------COSTE PREVISTO---------------------------------------------//
                        Beginning_EstimatedCostAmount := DataPieceworkForProduction_Begg.AmountCostTheoreticalProduction(JobBudget."Cod. Budget", DataPieceworkForProduction_Begg);

                        ExpectedCostPrice_Begg := 0;
                        IF DataPieceworkForProduction_Begg."Total Measurement Production" <> 0 THEN
                            ExpectedCostPrice_Begg := Beginning_EstimatedCostAmount / DataPieceworkForProduction_Begg."Total Measurement Production";

                        //----------------------------------------------COSTE REAL-----------------------------------------------//
                        Beginning_RealCostPrice := 0;
                        IF DataPieceworkForProduction_Begg."Total Measurement Production" <> 0 THEN
                            Beginning_RealCostPrice := DataPieceworkForProduction_Begg."Amount Cost Performed (JC)" / DataPieceworkForProduction_Begg."Total Measurement Production";

                        Beginning_PorDesvCost := FALSE;
                        Beginning_DeviationCost_Perc := 0;
                        IF Beginning_EstimatedCostAmount > 0 THEN BEGIN
                            Beginning_DeviationCost_Perc := 100 * (DataPieceworkForProduction_Begg."Amount Cost Performed (JC)" - Beginning_EstimatedCostAmount) / Beginning_EstimatedCostAmount;
                            Beginning_PorDesvCost := TRUE;
                        END;

                        //---------------------------------------------OBRA EJECUTADA---------------------------------------------//
                        Beginning_PerformedWorkPrice := 0;
                        IF DataPieceworkForProduction_Begg."Total Measurement Production" <> 0 THEN
                            Beginning_PerformedWorkPrice := 100 * DataPieceworkForProduction_Begg."Amount Production Performed" / DataPieceworkForProduction_Begg."Total Measurement Production";

                        //---------------------------------------------CERTIFICACIàN---------------------------------------------//
                        Beginning_CertificationPrice := 0;
                        IF DataPieceworkForProduction_Begg."Certified Quantity" <> 0 THEN
                            Beginning_CertificationPrice := 100 * DataPieceworkForProduction_Begg."Certified Amount" / DataPieceworkForProduction_Begg."Certified Quantity";

                        Beginning_PorDesvCert := FALSE;
                        Beginning_DeviationCertificate_Perc := 0;
                        IF DataPieceworkForProduction_Begg."Amount Production Performed" > 0 THEN BEGIN
                            Beginning_DeviationCertificate_Perc := 100 * (DataPieceworkForProduction_Begg."Certified Amount" - DataPieceworkForProduction_Begg."Amount Production Performed") / DataPieceworkForProduction_Begg."Amount Production Performed";
                            Beginning_PorDesvCert := TRUE;
                        END;

                        //-------------------------------------------------TOTALES---------------------------------------------------------//

                        IF (BeggCTR = 0) OR (LastTypBegg <> "Data Piecework For Production".Type) THEN BEGIN

                            BeggCTR := 1;
                            DeviationCost_UWType_Begg := 0;
                            DeviationCert_UWType_Begg := 0;
                            Perc_DeviationCost_UWType_Begg := 0;
                            Perc_DeviationCert_UWType_Begg := 0;
                            TotalEstimatedCost_UWType_Begg := 0;
                            TotalRealCost_UWType_Begg := 0;
                            TotalObEjAmount_UWType_Begg := 0;
                            TotalCertifAmount_UWType_Begg := 0;


                            DataPFProd_Begg_Total.SETRANGE(DataPFProd_Begg_Total."Job No.", "Data Piecework For Production"."Job No.");
                            DataPFProd_Begg_Total.SETRANGE(DataPFProd_Begg_Total.Type, "Data Piecework For Production".Type);
                            DataPFProd_Begg_Total.SETRANGE(DataPFProd_Begg_Total."Account Type", DataPFProd_Begg_Total."Account Type"::Unit);
                            DataPFProd_Begg_Total.SETFILTER(DataPFProd_Begg_Total."Filter Date", '..%1', LastDate);
                            DataPFProd_Begg_Total.SETFILTER(DataPFProd_Begg_Total."Budget Filter", BudgetCode);
                            DataPFProd_Begg_Total.FINDSET(FALSE, FALSE);
                            DataPFProd_Begg_Total.SETAUTOCALCFIELDS(DataPFProd_Begg_Total."Amount Cost Performed (JC)", DataPFProd_Begg_Total."Amount Production Performed",
                                                           DataPFProd_Begg_Total."Certified Amount");

                            IF DataPFProd_Begg_Total.FINDSET(FALSE, FALSE) THEN
                                REPEAT
                                    TotalEstimatedCost_UWType_Begg += DataPFProd_Begg_Total.AmountCostTheoreticalProduction(JobBudget."Cod. Budget", DataPFProd_Begg_Total);
                                    TotalRealCost_UWType_Begg += DataPFProd_Begg_Total."Amount Cost Performed (JC)";
                                    TotalObEjAmount_UWType_Begg += DataPFProd_Begg_Total."Amount Production Performed";
                                    TotalCertifAmount_UWType_Begg += DataPFProd_Begg_Total."Certified Amount";
                                UNTIL DataPFProd_Begg_Total.NEXT = 0;

                            DeviationCost_UWType_Begg := (TotalRealCost_UWType_Begg - TotalEstimatedCost_UWType_Begg);
                            DeviationCert_UWType_Begg := (TotalCertifAmount_UWType_Begg - TotalObEjAmount_UWType_Begg);

                            IF TotalEstimatedCost_UWType_Begg <> 0 THEN
                                Perc_DeviationCost_UWType_Begg := 100 * DeviationCost_UWType_Begg / TotalEstimatedCost_UWType_Begg;
                            IF TotalObEjAmount_UWType_Begg <> 0 THEN
                                Perc_DeviationCert_UWType_Begg := 100 * DeviationCert_UWType_Begg / TotalObEjAmount_UWType_Begg;

                            LastTypBegg := "Data Piecework For Production".Type;
                        END;
                    END;


                }

                trigger OnPreDataItem();
                BEGIN
                    "Data Piecework For Production".SETFILTER("Filter Date", '%1..%2', FirstDate, LastDate);
                    "Data Piecework For Production".SETFILTER("Budget Filter", BudgetCode);

                    IF LevelsText <> '' THEN
                        "Data Piecework For Production".SETFILTER(Indentation, '<=%1', Levels);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    //-------------------------CAMPOS CALCULADOS----------------------
                    "Data Piecework For Production".CALCFIELDS(
                          "Data Piecework For Production"."Measure Budg. Piecework Sol",
                          "Data Piecework For Production"."Total Measurement Production",
                          "Data Piecework For Production"."Amount Cost Performed (JC)",
                          "Data Piecework For Production"."Certified Quantity",
                          "Data Piecework For Production"."Certified Amount",
                          "Data Piecework For Production"."Amount Production Performed");

                    //--------------------------INDENTACIàN---------------------------
                    Indent_Description := '';
                    Indent_Description1 := '';
                    Indent_Description2 := '';
                    Indent_UnitWorkCode := '';
                    IndentSpace := '';

                    FOR i := 0 TO "Data Piecework For Production".Indentation DO BEGIN
                        Indent_Description += '   ';
                        Indent_UnitWorkCode += '   ';
                    END;

                    //PGM 06/07/2020 -
                    QBText.RESET;
                    QBText.SETRANGE(Key1, "Data Piecework For Production"."Job No.");
                    QBText.SETRANGE(Key2, "Data Piecework For Production"."Piecework Code");
                    IF QBText.FINDFIRST THEN BEGIN
                        QBText.CALCFIELDS("Cost Text");
                        QBText."Cost Text".CREATEINSTREAM(InStr, TEXTENCODING::Windows);
                        InStr.READTEXT(Indent_Description);
                    END ELSE
                        //PGM 06/07/2020 +
                        Indent_Description += "Data Piecework For Production".Description;

                    Indent_UnitWorkCode += "Data Piecework For Production"."Piecework Code";

                    IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN
                        IsUnit := TRUE
                    ELSE
                        IsUnit := FALSE; //+001

                    //-------------------------COSTE PREVISTO--------------------------------
                    EstimatedCostAmount := "Data Piecework For Production".AmountCostTheoreticalProduction(JobBudget."Cod. Budget", "Data Piecework For Production");
                    ExpectedCostPrice := 0;

                    IF "Data Piecework For Production"."Total Measurement Production" <> 0 THEN
                        ExpectedCostPrice := EstimatedCostAmount / "Data Piecework For Production"."Total Measurement Production";


                    //---------------------------COSTE REAL----------------------------------
                    RealCostPrice := 0;
                    IF "Data Piecework For Production"."Total Measurement Production" <> 0 THEN
                        RealCostPrice := "Data Piecework For Production"."Amount Cost Performed (JC)" / "Data Piecework For Production"."Total Measurement Production";

                    PorDesvCost := FALSE;
                    DeviationCost_Perc := 0;
                    IF EstimatedCostAmount > 0 THEN BEGIN
                        DeviationCost_Perc := 100 * ("Data Piecework For Production"."Amount Cost Performed (JC)" - EstimatedCostAmount) / EstimatedCostAmount;
                        PorDesvCost := TRUE;
                    END;

                    //------------------------------OBRA EJECUTADA----------------------------
                    PerformedWorkPrice := 0;
                    IF "Data Piecework For Production"."Total Measurement Production" <> 0 THEN
                        PerformedWorkPrice := "Data Piecework For Production"."Amount Production Performed" / "Data Piecework For Production"."Total Measurement Production";

                    //-------------------------------CERTIFICACION----------------------------
                    CertificationPrice := 0;
                    IF "Data Piecework For Production"."Certified Amount" <> 0 THEN
                        CertificationPrice := 100 * "Data Piecework For Production"."Certified Amount" / "Data Piecework For Production"."Certified Quantity";

                    PorDesvCert := FALSE;
                    DeviationCertificate_Perc := 0;
                    IF "Data Piecework For Production"."Amount Production Performed" > 0 THEN BEGIN
                        DeviationCertificate_Perc := 100 * ("Data Piecework For Production"."Certified Amount" - "Data Piecework For Production"."Amount Production Performed") / "Data Piecework For Production"."Amount Production Performed";
                        PorDesvCert := TRUE;
                    END;

                    //---------------------------------DATOS UDS ORIGEN---------------------
                    DataPieceworkForProduction_Begg.GET("Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code");

                    //---------------------------------TOTALES------------------------------
                    IF (MonthCTR = 0) OR (LastTypeMonth <> Type) THEN BEGIN
                        MonthCTR := 1;

                        DeviationCost_UWType_Month := 0;
                        DeviationCert_UWType_Month := 0;
                        Perc_DeviationCost_UWType_Month := 0;
                        Perc_DeviationCert_UWType_Month := 0;

                        TotalEstimatedCost_UWType_Month := 0;
                        TotalRealCost_UWType_Month := 0;
                        TotalObEjAmount_UWType_Month := 0;
                        TotalCertifAmount_UWType_Month := 0;

                        DataPFProd_Begg_Total.SETRANGE("Job No.", "Job No.");
                        DataPFProd_Begg_Total.SETRANGE(Type, Type);
                        DataPFProd_Begg_Total.SETRANGE("Account Type", "Account Type");
                        DataPFProd_Begg_Total.SETFILTER("Filter Date", '%1..%2', FirstDate, LastDate);
                        DataPFProd_Begg_Total.SETFILTER("Budget Filter", BudgetCode);
                        DataPFProd_Begg_Total.SETAUTOCALCFIELDS("Amount Cost Performed (JC)", "Amount Production Performed", "Certified Amount");

                        IF DataPFProd_Begg_Total.FINDSET(FALSE, FALSE) THEN
                            REPEAT
                                TotalEstimatedCost_UWType_Month += DataPFProd_Month_Total.AmountCostTheoreticalProduction(JobBudget."Cod. Budget", DataPFProd_Month_Total);
                                TotalRealCost_UWType_Month += DataPFProd_Month_Total."Amount Cost Performed (JC)";
                                TotalObEjAmount_UWType_Month += DataPFProd_Month_Total."Amount Production Performed";
                                TotalCertifAmount_UWType_Month += DataPFProd_Month_Total."Certified Amount";
                            UNTIL DataPFProd_Month_Total.NEXT = 0;

                        DeviationCost_UWType_Month := (TotalRealCost_UWType_Month - TotalEstimatedCost_UWType_Month);
                        DeviationCert_UWType_Month := (TotalCertifAmount_UWType_Month - TotalObEjAmount_UWType_Month);

                        IF TotalEstimatedCost_UWType_Month <> 0 THEN
                            Perc_DeviationCost_UWType_Month := 100 * DeviationCost_UWType_Month / TotalEstimatedCost_UWType_Month;
                        IF TotalObEjAmount_UWType_Month <> 0 THEN
                            Perc_DeviationCert_UWType_Month := 100 * DeviationCert_UWType_Month / TotalObEjAmount_UWType_Month;

                        LastTypeMonth := Type;

                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                Job.SETRANGE("No.", JobNo);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("JobNo"; "JobNo")
                {

                    CaptionML = ENU = 'Proyect', ESP = 'Proyecto';
                    TableRelation = Job;

                    ; trigger OnValidate()
                    BEGIN

                        IF BudgetCode <> '' THEN
                            IF Job.GET(JobNo) THEN BEGIN
                                IF NOT JobBudget.GET(JobNo, BudgetCode) THEN BEGIN
                                    BudgetCode := '';
                                END;
                            END ELSE
                                BudgetCode := '';
                    END;


                }
                field("BudgetCode"; "BudgetCode")
                {

                    CaptionML = ENU = 'Budget', ESP = 'Presupuesto';
                    TableRelation = "Job Budget"."Cod. Budget";

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN

                        CLEAR(JobBudgetList);
                        CLEAR(JobBudget);

                        JobBudgetList.LOOKUPMODE(TRUE);
                        IF JobNo <> '' THEN BEGIN
                            JobBudget.SETRANGE(JobBudget."Job No.", JobNo);
                            JobBudgetList.SETTABLEVIEW(JobBudget);
                        END;

                        IF JobBudgetList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            JobBudgetList.GETRECORD(JobBudget);
                            BudgetCode := JobBudget."Cod. Budget";
                            IF JobNo = '' THEN
                                JobNo := JobBudget."Job No.";
                        END;
                    END;


                }
                field("FirstDate"; "FirstDate")
                {

                    CaptionML = ENU = 'First Date', ESP = 'Fecha desde';
                }
                field("LastDate"; "LastDate")
                {

                    CaptionML = ENU = 'Last Date', ESP = 'Fecha hasta';
                }
                field("LevelsText"; "LevelsText")
                {

                    CaptionML = ENU = 'Levels (all blank)', ESP = 'Niveles (Blanco todos)';
                }

            }
        }
    }
    labels
    {
        Company = '"Company: "/ "Empresa: "/';
        Job = '"Job: "/ "Obra: "/';
        Budget_ = '"Budget: "/ "Presupuesto: "/';
        DateFrom = '"Date from: "/ "Fecha desde: "/';
        DateUntil = '"Date until: "/ "Fecha hasta: "/';
        Code = '"Code "/ "C¢digo "/';
        Descripcton = 'Description/ Descripci¢n/';
        Unit = 'Unit/ Unidad/';
        UnitsToBe = '"Units to be "/ "Unidades a "/';
        executed = 'executed/ ejecutar/';
        Month = 'Month:/ Mes:/';
        Beginning = 'Beginning:/ Origen:/';
        ExecUnits = 'Exec. Units/ Uds. Ejec./';
        AdvancePerc = 'Advance %/ % Avance/';
        ExpectedCost = 'Expected Cost/ Coste Previsto/';
        Prices = 'Prices/ Precios/';
        Amount = 'Amount/ Importe/';
        RealCost = 'Real Cost/ Coste Real/';
        Deviation = 'Deviation/ Desviaci¢n/';
        cost = 'cost/ coste/';
        Perc = '%/ %/';
        ExecutedJob = 'Executed Job/ Obra Ejecutada/';
        UnitsToBeExec = 'Units to be executed/ Uds. a ejecutar/';
        ExecUnits_ = 'Executed units/ Uds. ejecutadas/';
        Certification = 'Certification/ Certificaci¢n/';
        MONTH_ = 'MONTH/ MES/';
        BEGINNING_ = 'BEGINNING/ ORIGEN/';
        PeriodResult_ = 'Period result/ Resultado periodo/';
        BeginningResult_ = 'Beginning result/ Resultado origen/';
    }

    var
        //       JobNo@7001190 :
        JobNo: Code[20];
        //       Levels@7001189 :
        Levels: Integer;
        //       LevelsText@7001188 :
        LevelsText: Text;
        //       JobBudget@7001187 :
        JobBudget: Record 7207407;
        //       JobBudgetList@7001186 :
        JobBudgetList: Page 7207598;
        //       DateFilter@7001185 :
        DateFilter: Text;
        //       CopysNo@7001184 :
        CopysNo: Integer;
        //       BudgetCode@7001183 :
        BudgetCode: Code[20];
        //       JobTable@7001182 :
        JobTable: Record 167;
        //       FirstDate@7001181 :
        FirstDate: Date;
        //       LastDate@7001180 :
        LastDate: Date;
        //       Budget@7001179 :
        Budget: Text;
        //       CompanyInformation@7001178 :
        CompanyInformation: Record 79;
        //       IndentSpace@7001177 :
        IndentSpace: Text;
        //       Indent_Description@7001176 :
        Indent_Description: Text[250];
        //       Indent_Description1@7001175 :
        Indent_Description1: Text[45];
        //       Indent_Description2@7001174 :
        Indent_Description2: Text[45];
        //       Indent_UnitWorkCode@7001173 :
        Indent_UnitWorkCode: Code[20];
        //       i@7001172 :
        i: Integer;
        //       Unit_Cost@7001171 :
        Unit_Cost: Decimal;
        //       EstimatedCostAmount@7001170 :
        EstimatedCostAmount: Decimal;
        //       RealCostPrice@7001169 :
        RealCostPrice: Decimal;
        //       CertificationPrice@7001168 :
        CertificationPrice: Decimal;
        //       PerformedWorkPrice@7001167 :
        PerformedWorkPrice: Decimal;
        //       DeviationCost@7001166 :
        DeviationCost: Decimal;
        //       DeviationCertificate@7001165 :
        DeviationCertificate: Decimal;
        //       DeviationCost_Perc@7001164 :
        DeviationCost_Perc: Decimal;
        //       DeviationCertificate_Perc@7001163 :
        DeviationCertificate_Perc: Decimal;
        //       PorDesvCost@7001162 :
        PorDesvCost: Boolean;
        //       PorDesvCert@7001161 :
        PorDesvCert: Boolean;
        //       MonthAdvance@7001160 :
        MonthAdvance: Decimal;
        //       Month_Adv@7001159 :
        Month_Adv: Boolean;
        //       DataPieceworkForProduction_Begg@7001158 :
        DataPieceworkForProduction_Begg: Record 7207386;
        //       Beginning_UnitCost@7001157 :
        Beginning_UnitCost: Decimal;
        //       Beginning_EstimatedCostAmount@7001156 :
        Beginning_EstimatedCostAmount: Decimal;
        //       Beginning_RealCostPrice@7001155 :
        Beginning_RealCostPrice: Decimal;
        //       Beginning_CertificationPrice@7001154 :
        Beginning_CertificationPrice: Decimal;
        //       Beginning_PerformedWorkPrice@7001153 :
        Beginning_PerformedWorkPrice: Decimal;
        //       Beginning_DeviationCost@7001152 :
        Beginning_DeviationCost: Decimal;
        //       Beginning_DeviationCertificate@7001151 :
        Beginning_DeviationCertificate: Decimal;
        //       Beginning_DeviationCost_Perc@7001150 :
        Beginning_DeviationCost_Perc: Decimal;
        //       Beginning_DeviationCertificate_Perc@7001149 :
        Beginning_DeviationCertificate_Perc: Decimal;
        //       Beginning_PorDesvCost@7001148 :
        Beginning_PorDesvCost: Boolean;
        //       Beginning_PorDesvCert@7001147 :
        Beginning_PorDesvCert: Boolean;
        //       Beginning_Advance@7001146 :
        Beginning_Advance: Decimal;
        //       Beginning_Adv@7001145 :
        Beginning_Adv: Boolean;
        //       TotalEstimatedCost_UWType_Month@7001144 :
        TotalEstimatedCost_UWType_Month: Decimal;
        //       TotalRealCost_UWType_Month@7001143 :
        TotalRealCost_UWType_Month: Decimal;
        //       TotalObEjAmount_UWType_Month@7001142 :
        TotalObEjAmount_UWType_Month: Decimal;
        //       TotalCertifAmount_UWType_Month@7001141 :
        TotalCertifAmount_UWType_Month: Decimal;
        //       TotalEstimatedCost_UWType_Begg@7001140 :
        TotalEstimatedCost_UWType_Begg: Decimal;
        //       TotalRealCost_UWType_Begg@7001139 :
        TotalRealCost_UWType_Begg: Decimal;
        //       TotalObEjAmount_UWType_Begg@7001138 :
        TotalObEjAmount_UWType_Begg: Decimal;
        //       TotalCertifAmount_UWType_Begg@7001137 :
        TotalCertifAmount_UWType_Begg: Decimal;
        //       DataPFProd_Month_Total@7001136 :
        DataPFProd_Month_Total: Record 7207386;
        //       DataPFProd_Begg_Total@7001135 :
        DataPFProd_Begg_Total: Record 7207386;
        //       DeviationCost_UWType_Month@7001134 :
        DeviationCost_UWType_Month: Decimal;
        //       DeviationCert_UWType_Month@7001133 :
        DeviationCert_UWType_Month: Decimal;
        //       DeviationCost_UWType_Begg@7001132 :
        DeviationCost_UWType_Begg: Decimal;
        //       DeviationCert_UWType_Begg@7001131 :
        DeviationCert_UWType_Begg: Decimal;
        //       Perc_DeviationCost_UWType_Month@7001130 :
        Perc_DeviationCost_UWType_Month: Decimal;
        //       Perc_DeviationCert_UWType_Month@7001129 :
        Perc_DeviationCert_UWType_Month: Decimal;
        //       Perc_DeviationCost_UWType_Begg@7001128 :
        Perc_DeviationCost_UWType_Begg: Decimal;
        //       Perc_DeviationCert_UWType_Begg@7001127 :
        Perc_DeviationCert_UWType_Begg: Decimal;
        //       TotalEstimatedCost_Month@7001126 :
        TotalEstimatedCost_Month: Decimal;
        //       TotalRealCost_Month@7001125 :
        TotalRealCost_Month: Decimal;
        //       TotalObEjAmount_Month@7001124 :
        TotalObEjAmount_Month: Decimal;
        //       TotalCertifAmount_Month@7001123 :
        TotalCertifAmount_Month: Decimal;
        //       TotalEstimatedCost_Begg@7001122 :
        TotalEstimatedCost_Begg: Decimal;
        //       TotalRealCost_Begg@7001121 :
        TotalRealCost_Begg: Decimal;
        //       TotalObEjAmount_Begg@7001120 :
        TotalObEjAmount_Begg: Decimal;
        //       TotalCertifAmount_Begg@7001119 :
        TotalCertifAmount_Begg: Decimal;
        //       Tot_DeviationCost_Month@7001118 :
        Tot_DeviationCost_Month: Decimal;
        //       Tot_DeviationCert_Month@7001117 :
        Tot_DeviationCert_Month: Decimal;
        //       Tot_DeviationCost_Begg@7001116 :
        Tot_DeviationCost_Begg: Decimal;
        //       Tot_DeviationCert_Begg@7001115 :
        Tot_DeviationCert_Begg: Decimal;
        //       Tot_Perc_DeviationCost_Month@7001114 :
        Tot_Perc_DeviationCost_Month: Decimal;
        //       Tot_Perc_DeviationCert_Month@7001113 :
        Tot_Perc_DeviationCert_Month: Decimal;
        //       Tot_Perc_DeviationCost_Begg@7001112 :
        Tot_Perc_DeviationCost_Begg: Decimal;
        //       Tot_Perc_DeviationCert_Begg@7001111 :
        Tot_Perc_DeviationCert_Begg: Decimal;
        //       LastTypeMonth@7001110 :
        LastTypeMonth: Option "Unidad de obra","Unidad de coste","Unidad de inversi¢n","Unidad Auxiliar";
        //       LastTypBegg@7001109 :
        LastTypBegg: Option "Unidad de obra","Unidad de coste","Unidad de inversi¢n","Unidad Auxiliar";
        //       MonthCTR@7001108 :
        MonthCTR: Integer;
        //       BeggCTR@7001107 :
        BeggCTR: Integer;
        //       UExecMonth@7001106 :
        UExecMonth: Decimal;
        //       PeriodResult@7001105 :
        PeriodResult: Decimal;
        //       Perc_PeriodResult@7001104 :
        Perc_PeriodResult: Decimal;
        //       BeggResult@7001103 :
        BeggResult: Decimal;
        //       Perc_BeggResult@7001102 :
        Perc_BeggResult: Decimal;
        //       ExpectedCostPrice@7001101 :
        ExpectedCostPrice: Decimal;
        //       ExpectedCostPrice_Begg@7001100 :
        ExpectedCostPrice_Begg: Decimal;
        //       IsUnit@7001191 :
        IsUnit: Boolean;
        //       FirstPage@1100286000 :
        FirstPage: Boolean;
        //       QBText@1000000000 :
        QBText: Record 7206918;
        //       InStr@1000000001 :
        InStr: InStream;



    trigger OnPreReport();
    begin
        if not JobTable.GET(JobNo) then
            ERROR('Falta introducir proyecto');
        if LastDate = 0D then
            ERROR('Falta introducir fecha hasta: ');

        if not EVALUATE(Levels, LevelsText) and (LevelsText <> '') then
            ERROR('N£mero niveles no v lido, solo admite n£mero o vacio (todos los niveles)')
        else
            Levels := Levels - 1;

        if BudgetCode = '' then begin
            JobBudget.SETRANGE("Job No.", JobTable."No.");
            JobBudget.SETRANGE("Actual Budget", TRUE);
            if JobBudget.FINDSET(FALSE, FALSE) then;
        end else
            JobBudget.GET(JobTable."No.", BudgetCode);

        Budget := JobBudget."Budget Name";
        BudgetCode := JobBudget."Cod. Budget";

        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        FirstPage := TRUE;
    end;



    // procedure SetParameters (pJob@1100286000 : Code[20];pBudget@1100286001 : Code[20];pFini@1100286002 : Date;pFfin@1100286003 :
    procedure SetParameters(pJob: Code[20]; pBudget: Code[20]; pFini: Date; pFfin: Date)
    begin
        //JAV 25/07/19: - Nuevo par metro de proyecto y presupuesto a imprimir
        JobNo := pJob;
        BudgetCode := pBudget;
        FirstDate := pFini;
        LastDate := pFfin;
    end;

    /*begin
    //{
//      001 MRR 21/09/17 - A¤adida "IsUnit" para modificar condici¢n de visibilidad de las l¡neas en el layout
//      JAV 30/05/19: - Multiplicaba por 100 el precio de venta
//      JAV 25/07/19: - Nuevo par metro de proyecto a imprimir
//    }
    end.
  */

}



