report 7207380 "Job Tracking"
{


    CaptionML = ENU = 'Job Tracking', ESP = 'Seguimiento de obra';

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
            Column(PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(FORMAT__No___Description; FORMAT("No.") + '  ' + Description + "Description 2")
            {
                //SourceExpr=FORMAT("No.") + '  ' + Description + "Description 2";
            }
            Column(Project_Lbl; Project_Lbl)
            {
                //SourceExpr=Project_Lbl;
            }
            Column(Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(Selection_GETFILTER__Posting_Date_Filter; Selection.GETFILTER("Posting Date Filter"))
            {
                //SourceExpr=Selection.GETFILTER("Posting Date Filter");
            }
            Column(Filters_Lbl___Filter; Filters_Lbl + Filter)
            {
                //SourceExpr=Filters_Lbl +  Filter;
            }
            Column(Pending_Lbl; Pending_Lbl)
            {
                //SourceExpr=Pending_Lbl;
            }
            Column(JobTracking_Lbl; JobTracking_Lbl)
            {
                //SourceExpr=JobTracking_Lbl;
            }
            Column(Page_Lbl; Page_Lbl)
            {
                //SourceExpr=Page_Lbl;
            }
            Column(Piecework_Lbl; Piecework_Lbl)
            {
                //SourceExpr=Piecework_Lbl;
            }
            Column(Description_Lbl; Description_Lbl)
            {
                //SourceExpr=Description_Lbl;
            }
            Column(Measurement_Lbl; Measurement_Lbl)
            {
                //SourceExpr=Measurement_Lbl;
            }
            Column(Budget_Lbl; Budget_Lbl)
            {
                //SourceExpr=Budget_Lbl;
            }
            Column(CostPrice_Lbl; CostPrice_Lbl)
            {
                //SourceExpr=CostPrice_Lbl;
            }
            Column(CostAmount_Lbl; CostAmount_Lbl)
            {
                //SourceExpr=CostAmount_Lbl;
            }
            Column(Executed_Lbl; Executed_Lbl)
            {
                //SourceExpr=Executed_Lbl;
            }
            Column(PriceDeviation_Lbl; PriceDeviation_Lbl)
            {
                //SourceExpr=PriceDeviation_Lbl;
            }
            Column(QtyDeviation_Lbl; QtyDeviation_Lbl)
            {
                //SourceExpr=QtyDeviation_Lbl;
            }
            Column(Production_Lbl; Production_Lbl)
            {
                //SourceExpr=Production_Lbl;
            }
            Column(ExecJob_Lbl; ExecJob_Lbl)
            {
                //SourceExpr=ExecJob_Lbl;
            }
            Column(UN_Lbl; UN_Lbl)
            {
                //SourceExpr=UN_Lbl;
            }
            Column(Date_Lbl; Date_Lbl)
            {
                //SourceExpr=Date_Lbl;
            }
            Column(Stock_Lbl; Stock_Lbl)
            {
                //SourceExpr=Stock_Lbl;
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
                Column(JobCost; JobCost)
                {
                    //SourceExpr=JobCost;
                }
                Column(JobPerformed___ShipmentAmount; JobPerformed + ShipmentAmount)
                {
                    //SourceExpr=JobPerformed + ShipmentAmount;
                }
                Column(JobCost_JobPerformed___ShipmentAmount; JobCost - (JobPerformed + ShipmentAmount))
                {
                    //SourceExpr=JobCost - (JobPerformed + ShipmentAmount);
                }
                Column(TOTAL_FORMAT_Job__No____Job_Description; 'TOTAL  ' + FORMAT(Job."No.") + '  ' + Job.Description + Job."Description 2")
                {
                    //SourceExpr='TOTAL  '+ FORMAT(Job."No.") +  '  '  + Job.Description + Job."Description 2";
                }
                Column(TotalDeviationPrice; TotalDeviationPrice)
                {
                    //SourceExpr=TotalDeviationPrice;
                }
                Column(TotalDeviationQty; TotalDeviationQty)
                {
                    //SourceExpr=TotalDeviationQty;
                }
                Column(No_Job; Job."No.")
                {
                    //SourceExpr=Job."No.";
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Production Unit" = CONST(true));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(COPYSTR_Spaces_1_Indentation2__DPFP_Description; COPYSTR(Spaces, 1, Indentation * 2) + "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
                    }
                    Column(AmountCostPerformed_DataPieceworkForProduction; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(COPYSTR_Spaces__Indentation2__PieceworkCode; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code")
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2) + "Piecework Code";
                    }
                    Column(AmountCostBudget_DataPieceworkForProduction; "Data Piecework For Production"."Amount Cost Budget (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Budget (JC)";
                    }
                    Column(AmountCostBudget_AmountCostPerformed; "Amount Cost Budget (JC)" - "Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Amount Cost Budget (JC)" - "Amount Cost Performed (JC)";
                    }
                    Column(DeviatePrice; DeviatePrice)
                    {
                        //SourceExpr=DeviatePrice;
                    }
                    Column(DeviateQty; DeviateQty)
                    {
                        //SourceExpr=DeviateQty;
                    }
                    Column(Production; Production)
                    {
                        //SourceExpr=Production;
                    }
                    Column(ExecJob; ExecJob)
                    {
                        //SourceExpr=ExecJob;
                    }
                    Column(ExecJob_; ExecJob)
                    {
                        //SourceExpr=ExecJob;
                    }
                    Column(AmountCostBudget_AmountCostPerformed2; "Amount Cost Budget (JC)" - "Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Amount Cost Budget (JC)" - "Amount Cost Performed (JC)";
                    }
                    Column(AmountCostPerformed_DataPieceworkForProduction2; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(AmountCostBudget_DataPieceworkForProduction2; "Data Piecework For Production"."Amount Cost Budget (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Budget (JC)";
                    }
                    Column(BudgetMeasure_DataPieceworkForProduction; "Data Piecework For Production"."Budget Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Budget Measure";
                    }
                    Column(BudgetMeasCost; BudgetMeasCost)
                    {
                        //SourceExpr=BudgetMeasCost;
                    }
                    Column(TotalMeasurementProduction_DataPieceworkForProduction; "Data Piecework For Production"."Total Measurement Production")
                    {
                        //SourceExpr="Data Piecework For Production"."Total Measurement Production";
                    }
                    Column(PerformMeasCost; PerformMeasCost)
                    {
                        //SourceExpr=PerformMeasCost;
                    }
                    Column(TotalMeasurementProduction__BudgetMeasCost_PerformMeasCost; "Total Measurement Production" * (BudgetMeasCost - PerformMeasCost))
                    {
                        //SourceExpr="Total Measurement Production" * (BudgetMeasCost - PerformMeasCost);
                    }
                    Column(BudgetMeasCost__BudgetMeasure_TotalMeasurementProduction; BudgetMeasCost * ("Budget Measure" - "Total Measurement Production"))
                    {
                        //SourceExpr=BudgetMeasCost * ("Budget Measure" - "Total Measurement Production");
                    }
                    Column(UnitOfMeasure_DataPieceworkForProduction; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(JobPerformed; JobPerformed)
                    {
                        //SourceExpr=JobPerformed;
                    }
                    Column(JobCost_; JobCost)
                    {
                        //SourceExpr=JobCost;
                    }
                    Column(JobCost_JobPerformed; JobCost - JobPerformed)
                    {
                        //SourceExpr=JobCost - JobPerformed;
                    }
                    Column(TOTAL_GENERAL_FORMAT_Job__No__Job_Description; 'TOTAL GENERAL : ' + FORMAT(Job."No.") + '  ' + Job.Description + Job."Description 2")
                    {
                        //SourceExpr='TOTAL GENERAL : '+ FORMAT(Job."No.") + '  ' + Job.Description + Job."Description 2";
                    }
                    Column(JobNo_DataPieceworkForProduction; "Data Piecework For Production"."Job No.")
                    {
                        //SourceExpr="Data Piecework For Production"."Job No.";
                    }
                    Column(PieceworkCode_DataPieceworkForProduction; "Data Piecework For Production"."Piecework Code")
                    {
                        //SourceExpr="Data Piecework For Production"."Piecework Code";
                    }
                    DataItem("Item"; "Item")
                    {

                        DataItemTableView = SORTING("No.");
                        ;
                        Column(ShipmentAmount; ShipmentAmount)
                        {
                            //SourceExpr=ShipmentAmount;
                        }
                        Column(No_Item; Item."No.")
                        {
                            //SourceExpr=Item."No.";
                        }
                        Column(Description_Item; Item.Description)
                        {
                            //SourceExpr=Item.Description ;
                        }
                        trigger OnAfterGetRecord();
                        BEGIN
                            SETFILTER("Location Filter", Job."Job Location");
                            SETFILTER("Date Filter", '%1..%2', 0D, Job.GETRANGEMAX("Posting Date Filter"));
                            CALCFIELDS("Net Change");
                            CUItemCostManagement.CalculateAverageCost(Item, AverageCostLCY, AverageCostACY);

                            ShipmentAmount := ShipmentAmount + Item."Net Change" * AverageCostLCY;
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                                "Data Piecework For Production"."Amount Cost Performed (JC)",
                                                "Data Piecework For Production"."Amount Production Budget",
                                                "Data Piecework For Production"."Amount Production Performed",
                                                PendingJob,
                                                JobCost,
                                                JobPerformed);
                        CurrReport.CREATETOTALS(TotalDeviationPrice, TotalDeviationQty);

                        IF Selection.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Selection."Current Piecework Budget");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        TittleName := '';
                        IF DataPieceworkForProduction.GET(Job."No.", "Data Piecework For Production".Title) THEN
                            TittleName := DataPieceworkForProduction.Description;

                        SETRANGE("Data Piecework For Production"."Filter Date");
                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                        SETFILTER("Data Piecework For Production"."Filter Date", '%1..%2', 0D, EndDate);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        IF "Total Measurement Production" <> 0 THEN
                            PerformMeasCost := ROUND("Amount Cost Performed (JC)" / "Total Measurement Production", 0.01)
                        ELSE
                            PerformMeasCost := 0;

                        IF "Budget Measure" <> 0 THEN
                            ExecJob := ROUND("Total Measurement Production" / "Budget Measure", 0.01) * 100
                        ELSE
                            ExecJob := 0;

                        IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN BEGIN
                            CalculateHigher("Data Piecework For Production", DeviatePrice, DeviateQty, Production, ExecJob);
                            IF "Amount Cost Budget (JC)" <> 0 THEN
                                ExecJob := ROUND(Production / "Amount Cost Budget (JC)") * 100
                            ELSE
                                ExecJob := 0;
                        END ELSE BEGIN
                            Production := "Data Piecework For Production"."Amount Production Performed";
                        END;

                        IF ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit) THEN BEGIN
                            JobCost := JobCost + "Amount Cost Budget (JC)";
                            JobPerformed := JobPerformed + "Amount Cost Performed (JC)";
                        END;

                        IF "Data Piecework For Production"."Budget Measure" <> 0 THEN
                            BudgetMeasCost := ROUND("Amount Cost Budget (JC)" / "Data Piecework For Production"."Budget Measure")
                        ELSE
                            BudgetMeasCost := 0;

                        IF ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit) AND
                           ("Data Piecework For Production".Type = "Data Piecework For Production".Type::Piecework) THEN BEGIN
                            TotalDeviationPrice := TotalDeviationPrice + "Total Measurement Production" * (BudgetMeasCost - PerformMeasCost);
                            TotalDeviationQty := TotalDeviationQty + BudgetMeasCost * ("Budget Measure" - "Total Measurement Production");
                        END;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    IF Selection.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Selection."Current Piecework Budget");

                    SETFILTER("Posting Date Filter", '%1..%2', StartDate, EndDate);
                    CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                            "Data Piecework For Production"."Amount Cost Performed (JC)",
                                            "Data Piecework For Production"."Amount Production Budget",
                                            "Data Piecework For Production"."Amount Production Performed",
                                            PendingJob,
                                            JobPerformed,
                                            JobCost);
                    CurrReport.CREATETOTALS(TotalDeviationPrice, TotalDeviationQty);

                    ShipmentAmount := 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    PendingJob := 0;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                StartDate := GETRANGEMIN("Posting Date Filter");
                EndDate := GETRANGEMAX("Posting Date Filter");

                IF ((Selection.GETFILTER(Selection."Posting Date Filter") = '') OR (StartDate = EndDate)) THEN
                    ERROR(Text0001);

                PeriodFilter := Job.GETFILTER(Job."Posting Date Filter");
                Filter := Selection.GETFILTERS();

                CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                        "Data Piecework For Production"."Amount Cost Performed (JC)",
                                        "Data Piecework For Production"."Amount Production Budget",
                                        "Data Piecework For Production"."Amount Production Performed",
                                        JobCost,
                                        JobPerformed);

                CurrReport.CREATETOTALS(TotalDeviationPrice, TotalDeviationQty);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                BudgetText := '';

                IF Selection.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Selection."No.", Selection.GETFILTER("Budget Filter")) THEN BEGIN
                        BudgetText := JobBudget."Budget Name"
                    END
                END ELSE BEGIN
                    IF JobBudget.GET(Selection."No.", Selection."Current Piecework Budget") THEN BEGIN
                        BudgetText := JobBudget."Budget Name"
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
        //       DetailLevel@7001132 :
        DetailLevel: Option "Titulo","Subtitulos","Detalle";
        //       Difference@7001131 :
        Difference: Decimal;
        //       TotalText@7001130 :
        TotalText: Text[30];
        //       CompanyInformation@7001129 :
        CompanyInformation: Record 79;
        //       StartDate@7001128 :
        StartDate: Date;
        //       EndDate@7001127 :
        EndDate: Date;
        //       PeriodFilter@7001126 :
        PeriodFilter: Text[30];
        //       TittleName@7001125 :
        TittleName: Text[60];
        //       DataPieceworkForProduction@7001124 :
        DataPieceworkForProduction: Record 7207386;
        //       Piecework_@7001123 :
        Piecework_: Code[20];
        //       Resource@7001122 :
        Resource: Record 156;
        //       "---"@7001121 :
        "---": Integer;
        //       Spaces@7001120 :
        Spaces: Text[30];
        //       PendingCost@7001119 :
        PendingCost: Decimal;
        //       PendingProduction@7001118 :
        PendingProduction: Decimal;
        //       PendingJob@7001117 :
        PendingJob: Decimal;
        //       PerformMeasCost@7001116 :
        PerformMeasCost: Decimal;
        //       ExecJob@7001115 :
        ExecJob: Decimal;
        //       DeviatePrice@7001114 :
        DeviatePrice: Decimal;
        //       DeviateQty@7001113 :
        DeviateQty: Decimal;
        //       Production@7001112 :
        Production: Decimal;
        //       CUItemCostManagement@7001111 :
        CUItemCostManagement: Codeunit 5804;
        //       AverageCostLCY@7001110 :
        AverageCostLCY: Decimal;
        //       AverageCostACY@7001109 :
        AverageCostACY: Decimal;
        //       ShipmentAmount@7001108 :
        ShipmentAmount: Decimal;
        //       JobCost@7001107 :
        JobCost: Decimal;
        //       JobPerformed@7001106 :
        JobPerformed: Decimal;
        //       BudgetMeasCost@7001105 :
        BudgetMeasCost: Decimal;
        //       TotalDeviationPrice@7001104 :
        TotalDeviationPrice: Decimal;
        //       TotalDeviationQty@7001103 :
        TotalDeviationQty: Decimal;
        //       Filter@7001102 :
        Filter: Text[250];
        //       BudgetText@7001101 :
        BudgetText: Text[50];
        //       JobBudget@7001100 :
        JobBudget: Record 7207407;
        //       Text0001@7001152 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Pending_Lbl@7001151 :
        Pending_Lbl: TextConst ENU = 'Pending', ESP = 'Pendiente';
        //       JobTracking_Lbl@7001150 :
        JobTracking_Lbl: TextConst ENU = 'Job Tracking', ESP = 'Seguimiento de Obra';
        //       Page_Lbl@7001149 :
        Page_Lbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       Piecework_Lbl@7001148 :
        Piecework_Lbl: TextConst ENU = 'Piecework', ESP = 'Unidad obra';
        //       Description_Lbl@7001147 :
        Description_Lbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Measurement_Lbl@7001146 :
        Measurement_Lbl: TextConst ENU = 'Measurement', ESP = 'Medici¢n';
        //       Budget_Lbl@7001145 :
        Budget_Lbl: TextConst ENU = 'Budget', ESP = 'Presupuesto';
        //       CostPrice_Lbl@7001144 :
        CostPrice_Lbl: TextConst ENU = 'Cost Price', ESP = 'Pcio coste';
        //       CostAmount_Lbl@7001143 :
        CostAmount_Lbl: TextConst ENU = 'Cost Amount', ESP = 'Imp. Coste';
        //       Executed_Lbl@7001142 :
        Executed_Lbl: TextConst ENU = 'Executed', ESP = 'Ejecutado';
        //       PriceDeviation_Lbl@7001137 :
        PriceDeviation_Lbl: TextConst ENU = 'Price Deviation', ESP = 'Desviaci¢n Precio';
        //       QtyDeviation_Lbl@7001136 :
        QtyDeviation_Lbl: TextConst ENU = 'Quantity Deviation', ESP = 'Desviaci¢n Cantidad';
        //       Production_Lbl@7001135 :
        Production_Lbl: TextConst ENU = 'Production', ESP = 'Producci¢n';
        //       ExecJob_Lbl@7001134 :
        ExecJob_Lbl: TextConst ENU = 'Exec. Job', ESP = 'Obra Ejec.';
        //       UN_Lbl@7001133 :
        UN_Lbl: TextConst ENU = 'UN', ESP = 'UD';
        //       Project_Lbl@7001138 :
        Project_Lbl: TextConst ENU = 'Job: ', ESP = 'Proyecto: ';
        //       Filters_Lbl@7001139 :
        Filters_Lbl: TextConst ENU = 'Filters: ', ESP = 'Filtros: ';
        //       Stock_Lbl@7001140 :
        Stock_Lbl: TextConst ENU = 'STOCK', ESP = 'EXISTENCIAS';
        //       Date_Lbl@7001141 :
        Date_Lbl: TextConst ENU = 'Date filter: ', ESP = 'Filtro fecha: ';



    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        Spaces := '                    ';
    end;



    // procedure CalculateHigher (PA_DataPieceworkForProduction@1100251000 : Record 7207386;var PA_DeviatePrice@1100251001 : Decimal;var PA_DeviateQty@1100251002 : Decimal;var PA_Production@1100251003 : Decimal;var PA_ExecJob@1100251004 :
    procedure CalculateHigher(PA_DataPieceworkForProduction: Record 7207386; var PA_DeviatePrice: Decimal; var PA_DeviateQty: Decimal; var PA_Production: Decimal; var PA_ExecJob: Decimal)
    var
        //       LODataPieceworkForProduction@1100251005 :
        LODataPieceworkForProduction: Record 7207386;
        //       LOTotalMeasBudget@1100251006 :
        LOTotalMeasBudget: Decimal;
        //       LOProductionTotal@1100251007 :
        LOProductionTotal: Decimal;
    begin
        PA_ExecJob := 0;
        PA_DeviatePrice := 0;
        PA_DeviateQty := 0;
        PA_Production := 0;

        LODataPieceworkForProduction.SETRANGE(LODataPieceworkForProduction."Job No.", PA_DataPieceworkForProduction."Job No.");
        LODataPieceworkForProduction.SETFILTER(LODataPieceworkForProduction."Account Type", '<>%1', LODataPieceworkForProduction."Account Type"::Heading);
        LODataPieceworkForProduction.SETFILTER(LODataPieceworkForProduction."Piecework Code", PA_DataPieceworkForProduction.Totaling);
        if LODataPieceworkForProduction.FINDSET then
            repeat
                if Selection.GETFILTER("Budget Filter") <> '' then
                    LODataPieceworkForProduction.SETFILTER("Budget Filter", Selection.GETFILTER("Budget Filter"));

                LODataPieceworkForProduction.SETRANGE("Filter Date");
                LODataPieceworkForProduction.CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                LODataPieceworkForProduction.SETRANGE("Budget Filter");
                LODataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, EndDate);
                LODataPieceworkForProduction.CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                if LODataPieceworkForProduction."Budget Measure" <> 0 then
                    BudgetMeasCost := ROUND(LODataPieceworkForProduction."Amount Cost Budget (JC)" / LODataPieceworkForProduction."Budget Measure")
                else
                    BudgetMeasCost := 0;

                if LODataPieceworkForProduction."Total Measurement Production" <> 0 then
                    PerformMeasCost := ROUND(LODataPieceworkForProduction."Amount Cost Performed (JC)" / LODataPieceworkForProduction."Total Measurement Production", 0.01)
                else
                    PerformMeasCost := 0;

                PA_DeviatePrice := PA_DeviatePrice + LODataPieceworkForProduction."Total Measurement Production" * (BudgetMeasCost - PerformMeasCost);
                PA_DeviateQty := PA_DeviateQty +
                                    BudgetMeasCost * (LODataPieceworkForProduction."Budget Measure" - LODataPieceworkForProduction."Total Measurement Production");
                PA_Production := PA_Production + LODataPieceworkForProduction."Amount Production Performed";
                LOTotalMeasBudget := LOTotalMeasBudget + LODataPieceworkForProduction."Budget Measure";
                LOProductionTotal := LOProductionTotal + LODataPieceworkForProduction."Total Measurement Production";
            until LODataPieceworkForProduction.NEXT = 0;
    end;

    /*begin
    end.
  */

}



