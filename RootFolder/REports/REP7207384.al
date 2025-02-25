report 7207384 "Monitoring Job Period"
{



    dataset
    {

        DataItem("Seleccion"; "Job")
        {

            DataItemTableView = SORTING("No.");


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
            Column(CurrReportPAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(FORMAT__No____________Description; FORMAT("No.") + '  ' + Description)
            {
                //SourceExpr=FORMAT("No.") + '  ' +Description;
            }
            Column(Project___; Project)
            {
                //SourceExpr=Project;
            }
            Column(InfoCompany_Picture; InfoCompany.Picture)
            {
                //SourceExpr=InfoCompany.Picture;
            }
            Column(Filtros_____Filter; Filters + Filter)
            {
                //SourceExpr=Filters +Filter;
            }
            Column(Monitoring_Job_Period_CaptionLbl; Monitoring_Job_Period_CaptionLbl)
            {
                //SourceExpr=Monitoring_Job_Period_CaptionLbl;
            }
            Column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(Unit_JobCaptionLbl; Unit_JobCaptionLbl)
            {
                //SourceExpr=Unit_JobCaptionLbl;
            }
            Column(MeasureCaptionLbl; MeasureCaptionLbl)
            {
                //SourceExpr=MeasureCaptionLbl;
            }
            Column(RealSalesCostCaptionLbl; "Real Sales CostCaptionLbl")
            {
                //SourceExpr="Real Sales CostCaptionLbl";
            }
            Column(Real_Amt_CostlCaptionLbl; Real_Amt_CostlCaptionLbl)
            {
                //SourceExpr=Real_Amt_CostlCaptionLbl;
            }
            Column(Period_DesviationCaptionLbl; Period_DesviationCaptionLbl)
            {
                //SourceExpr=Period_DesviationCaptionLbl;
            }
            Column(ProductionCaptionLbl; ProductionCaptionLbl)
            {
                //SourceExpr=ProductionCaptionLbl;
            }
            Column(UDCaptionLbl; UDCaptionLbl)
            {
                //SourceExpr=UDCaptionLbl;
            }
            Column(Stock2; Stocks)
            {
                //SourceExpr=Stocks;
            }
            Column(Budget_Price_CostCaptionLbl; Budget_Price_CostCaptionLbl)
            {
                //SourceExpr=Budget_Price_CostCaptionLbl;
            }
            Column(JobNo; Job."No.")
            {
                //SourceExpr=Job."No.";
            }
            DataItem("Job"; "Job")
            {

                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                DataItemLink = "No." = FIELD("No.");
                Column(JOBPERFORMED_AmountStore; JOBPERFORMED + AmountStore)
                {
                    //SourceExpr=JOBPERFORMED + AmountStore;
                }
                Column(TOTAL____FORMAT_Job__No____________Job_Description; 'TOTAL  ' + FORMAT(Job."No.") + '  ' + Job.Description)
                {
                    //SourceExpr='TOTAL  '+FORMAT(Job."No.") + '  ' +Job.Description;
                }
                Column(DesviationTotalPrice; DesviationTotalPrice)
                {
                    //SourceExpr=DesviationTotalPrice;
                }
                Column(JobNo2; Job."No.")
                {
                    //SourceExpr=Job."No.";
                }
                DataItem("Data Piecework For Production"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Production Unit" = CONST(true));
                    DataItemLink = "Job No." = FIELD("No.");
                    Column(COPYSTR_Spaces_1_Indentation2_PieceWorkCode_Description; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code" + ' ' + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code"+' '+Description;
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(PriceDesviation; PriceDesviation)
                    {
                        //SourceExpr=PriceDesviation;
                    }
                    Column(Production; Production)
                    {
                        //SourceExpr=Production;
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformedo__Control1100251073; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(COPYSTR_Spaces_1_Indentation2_PieceWorkCode_Description_Control1100251006; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code" + ' ' + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code"+' '+Description;
                    }
                    Column(COPYSTR_Spaces_1_Indentation2_PieceWorkCode_Description_Control1100251000; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code" + ' ' + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code"+' '+Description;
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed__Control1100251004; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(PriceDesviation_Control1100251052; PriceDesviation)
                    {
                        //SourceExpr=PriceDesviation;
                    }
                    Column(Production_Control1100251054; Production)
                    {
                        //SourceExpr=Production;
                    }
                    Column(COPYSTR_Spaces_1_Indentation2_PieceWorkCode_Description_Control1100251046; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code" + ' ' + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code"+' '+Description;
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed__Control1100251067; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed__Control1100251007; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(DataPieceworkForProduction_TotalMeasurementProduction; "Data Piecework For Production"."Total Measurement Production")
                    {
                        //SourceExpr="Data Piecework For Production"."Total Measurement Production";
                    }
                    Column(AvgCostPerformed; AvgCostPerformed)
                    {
                        //SourceExpr=AvgCostPerformed;
                    }
                    Column(TotalMeasurementProduction_AvgBudgetCost_AvgCostPerformed; "Total Measurement Production" * (AvgBudgetCost - AvgCostPerformed))
                    {
                        //SourceExpr="Total Measurement Production"*(AvgBudgetCost - AvgCostPerformed);
                    }
                    Column(Production_Control1100251040; Production)
                    {
                        //SourceExpr=Production;
                    }
                    Column(COPYSTR_Spaces_1_Indentation2_PieceWorkCode_Description_Control1100251017; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code" + ' ' + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code"+' '+Description;
                    }
                    Column(UnitOfMeasure; "Unit Of Measure")
                    {
                        //SourceExpr="Unit Of Measure";
                    }
                    Column(AvgBudgetCost; AvgBudgetCost)
                    {
                        //SourceExpr=AvgBudgetCost;
                    }
                    Column(DataPieceworkForProduction_AmountCostPerformed__Control1100251063; "Data Piecework For Production"."Amount Cost Performed (JC)")
                    {
                        //SourceExpr="Data Piecework For Production"."Amount Cost Performed (JC)";
                    }
                    Column(COPYSTR_Spaces_1_Indentation2_PieceWorkCode_Description_Control1100251072; COPYSTR(Spaces, 1, Indentation * 2) + "Piecework Code" + ' ' + Description)
                    {
                        //SourceExpr=COPYSTR(Spaces,1,Indentation*2)+"Piecework Code"+' '+Description;
                    }
                    Column(DataPieceworkForProduction_UnitOfMeasure__Control1100251088; "Data Piecework For Production"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production"."Unit Of Measure";
                    }
                    Column(JOBPERFORMED; JOBPERFORMED)
                    {
                        //SourceExpr=JOBPERFORMED;
                    }
                    Column(TOTAL_GENERAL_____FORMAT_Job__No____________Job_Description; 'GENERAL TOTAL : ' + FORMAT(Job."No.") + '  ' + Job.Description)
                    {
                        //SourceExpr='GENERAL TOTAL : '+FORMAT(Job."No.") + '  ' +Job.Description;
                    }
                    Column(DesviationTotalPrice_Control1100251079; DesviationTotalPrice)
                    {
                        //SourceExpr=DesviationTotalPrice;
                    }
                    Column(Job__No_; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(PieceworkCode; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    DataItem("Item"; "Item")
                    {

                        DataItemTableView = SORTING("No.");
                        ;
                        Column(AmountStore; AmountStore)
                        {
                            //SourceExpr=AmountStore;
                        }
                        Column(STOCKS; Stocks)
                        {
                            //SourceExpr=Stocks;
                        }
                        Column(Item_No; Item."No.")
                        {
                            //SourceExpr=Item."No." ;
                        }
                        trigger OnAfterGetRecord();
                        BEGIN
                            SETFILTER("Location Filter", Job."Job Location");
                            SETFILTER("Date Filter", '%1..%2', 0D, Job.GETRANGEMAX("Posting Date Filter"));
                            CALCFIELDS("Net Change");
                            ItemCostMgt.CalculateAverageCost(Item, AverageCostLCY, AverageCostACY);

                            AmountStore := AmountStore + Item."Net Change" * AverageCostLCY;
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                                "Data Piecework For Production"."Amount Cost Performed (JC)",
                                                "Data Piecework For Production"."Amount Production Budget",
                                                "Data Piecework For Production"."Amount Production Performed",
                                                PendingJob,
                                                COSTJOB,
                                                JOBPERFORMED);
                        CurrReport.CREATETOTALS(DesviationTotalPrice, DesviationTotalQuantity);
                        IF Seleccion.GETFILTER("Budget Filter") <> '' THEN
                            SETFILTER("Budget Filter", Seleccion.GETFILTER("Budget Filter"))
                        ELSE
                            SETFILTER("Budget Filter", Seleccion."Current Piecework Budget");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        TitleName := '';
                        IF RecTitle.GET(Job."No.", Title) THEN
                            TitleName := RecTitle.Description;

                        SETRANGE("Data Piecework For Production"."Filter Date");

                        CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");

                        SETFILTER("Data Piecework For Production"."Filter Date", '%1..%2', DateIni, DateEnd);
                        CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");

                        IF "Total Measurement Production" <> 0 THEN
                            AvgCostPerformed := "Amount Cost Performed (JC)" / "Total Measurement Production"
                        ELSE
                            AvgCostPerformed := 0;

                        IF "Budget Measure" <> 0 THEN
                            OE := ROUND("Total Measurement Production" / "Budget Measure", 0.01) * 100
                        ELSE
                            OE := 0;

                        IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN BEGIN
                            CalcHigh("Data Piecework For Production", PriceDesviation, QuantityDesviation, Production, OE);
                            IF "Amount Cost Budget (JC)" <> 0 THEN
                                OE := ROUND(Production / "Amount Cost Budget (JC)") * 100
                            ELSE
                                OE := 0;
                        END ELSE BEGIN
                            Production := "Data Piecework For Production"."Amount Production Performed";
                        END;


                        IF ("Data Piecework For Production"."Account Type" =
                                              "Data Piecework For Production"."Account Type"::Unit) THEN BEGIN
                            COSTJOB := COSTJOB + "Amount Cost Budget (JC)";
                            JOBPERFORMED := JOBPERFORMED + "Amount Cost Performed (JC)";
                        END;
                        IF "Data Piecework For Production"."Budget Measure" <> 0 THEN
                            AvgBudgetCost := "Amount Cost Budget (JC)" / "Data Piecework For Production"."Budget Measure"
                        ELSE
                            AvgBudgetCost := 0;

                        IF ("Data Piecework For Production"."Account Type" =
                                              "Data Piecework For Production"."Account Type"::Unit) AND
                           ("Data Piecework For Production".Type = "Data Piecework For Production".Type::Piecework) THEN BEGIN
                            DesviationTotalPrice := DesviationTotalPrice + "Total Measurement Production" * (AvgBudgetCost - AvgCostPerformed);
                            DesviationTotalQuantity := DesviationTotalQuantity + AvgBudgetCost * ("Budget Measure" - "Total Measurement Production");
                        END;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    IF Seleccion.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Seleccion.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Seleccion."Current Piecework Budget");

                    SETFILTER("Posting Date Filter", '%1..%2', DateIni, DateEnd);
                    CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                            "Data Piecework For Production"."Amount Cost Performed (JC)",
                                            "Data Piecework For Production"."Amount Production Budget",
                                            "Data Piecework For Production"."Amount Production Performed",
                                            PendingJob,
                                            JOBPERFORMED,
                                            COSTJOB
                                            );
                    CurrReport.CREATETOTALS(DesviationTotalPrice, DesviationTotalQuantity);

                    AmountStore := 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    PendingJob := 0;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                DateIni := GETRANGEMIN("Posting Date Filter");
                DateEnd := GETRANGEMAX("Posting Date Filter");

                IF ((Seleccion.GETFILTER(Seleccion."Posting Date Filter") = '') OR (DateIni = DateEnd)) THEN
                    ERROR(Text0001);


                Filter := Seleccion.GETFILTERS();


                InfoCompany.GET;
                InfoCompany.CALCFIELDS(InfoCompany.Picture);

                InfoCompany.GET;
                InfoCompany.CALCFIELDS(InfoCompany.Picture);

                CurrReport.CREATETOTALS("Data Piecework For Production"."Amount Cost Budget (JC)",
                                        "Data Piecework For Production"."Amount Cost Performed (JC)",
                                        "Data Piecework For Production"."Amount Production Budget",
                                        "Data Piecework For Production"."Amount Production Performed",
                                        COSTJOB,
                                        JOBPERFORMED);
                CurrReport.CREATETOTALS(DesviationTotalPrice, DesviationTotalQuantity);
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
        //       DetailLevel@7001131 :
        DetailLevel: Option "Titulo","Subtitulos","Detalle";
        //       Difference@7001130 :
        Difference: Decimal;
        //       TotalText@7001129 :
        TotalText: Text[30];
        //       InfoCompany@7001128 :
        InfoCompany: Record 79;
        //       DateIni@7001127 :
        DateIni: Date;
        //       DateEnd@7001126 :
        DateEnd: Date;
        //       PeriodFilterOld@7001125 :
        PeriodFilterOld: Text[30];
        //       TitleName@7001124 :
        TitleName: Text[60];
        //       RecTitle@7001123 :
        RecTitle: Record 7207386;
        //       UOJob@7001122 :
        UOJob: Code[20];
        //       Reso@7001121 :
        Reso: Record 156;
        //       "---"@7001120 :
        "---": Integer;
        //       Spaces@7001119 :
        Spaces: Text[30];
        //       PendingCost@7001118 :
        PendingCost: Decimal;
        //       PendingProduction@7001117 :
        PendingProduction: Decimal;
        //       PendingJob@7001116 :
        PendingJob: Decimal;
        //       AvgCostPerformed@7001115 :
        AvgCostPerformed: Decimal;
        //       OE@7001114 :
        OE: Decimal;
        //       PriceDesviation@7001113 :
        PriceDesviation: Decimal;
        //       QuantityDesviation@7001112 :
        QuantityDesviation: Decimal;
        //       Production@7001111 :
        Production: Decimal;
        //       ItemCostMgt@7001110 :
        ItemCostMgt: Codeunit 5804;
        //       AverageCostLCY@7001109 :
        AverageCostLCY: Decimal;
        //       AverageCostACY@7001108 :
        AverageCostACY: Decimal;
        //       AmountStore@7001107 :
        AmountStore: Decimal;
        //       COSTJOB@7001106 :
        COSTJOB: Decimal;
        //       JOBPERFORMED@7001105 :
        JOBPERFORMED: Decimal;
        //       AvgBudgetCost@7001104 :
        AvgBudgetCost: Decimal;
        //       "--pv0604"@7001103 :
        "--pv0604": Integer;
        //       DesviationTotalPrice@7001102 :
        DesviationTotalPrice: Decimal;
        //       DesviationTotalQuantity@7001101 :
        DesviationTotalQuantity: Decimal;
        //       Filter@7001100 :
        Filter: Text[250];
        //       Text0001@7001143 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Text0002@7001142 :
        Text0002: TextConst ENU = 'You must specify a value in the To Date field', ESP = 'Debe especificar un valor en el campo Hasta Fecha';
        //       Monitoring_Job_Period_CaptionLbl@7001141 :
        Monitoring_Job_Period_CaptionLbl: TextConst ENU = 'Monitoring Job (Period)', ESP = 'Seguimiento de Obra (Periodo)';
        //       CurrReport_PAGENOCaptionLbl@7001140 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Pag', ESP = 'P g.';
        //       Unit_JobCaptionLbl@7001139 :
        Unit_JobCaptionLbl: TextConst ENU = 'Unit Job', ESP = 'Unidad obra';
        //       MeasureCaptionLbl@7001138 :
        MeasureCaptionLbl: TextConst ENU = 'Measure', ESP = 'Medici¢n';
        //       "Real Sales CostCaptionLbl"@7001137 :
        "Real Sales CostCaptionLbl": TextConst ENU = 'Real Sales Cost', ESP = 'Precio Coste Real';
        //       Real_Amt_CostlCaptionLbl@7001136 :
        Real_Amt_CostlCaptionLbl: TextConst ENU = 'Real Amt. Cost ', ESP = 'Imp. Coste Real';
        //       Period_DesviationCaptionLbl@7001135 :
        Period_DesviationCaptionLbl: TextConst ENU = 'Period Desviation', ESP = 'Desviaci¢n Periodo';
        //       ProductionCaptionLbl@7001134 :
        ProductionCaptionLbl: TextConst ENU = 'Production', ESP = 'Producci¢n';
        //       UDCaptionLbl@7001133 :
        UDCaptionLbl: TextConst ESP = 'UD';
        //       Budget_Price_CostCaptionLbl@7001132 :
        Budget_Price_CostCaptionLbl: TextConst ENU = 'Budget Cost Price', ESP = 'Precio Coste Presupuesto';
        //       Filters@7001144 :
        Filters: TextConst ENU = 'Filters:', ESP = 'Filtros:';
        //       Project@7001145 :
        Project: TextConst ENU = 'Project:', ESP = 'Proyecto:';
        //       Stocks@7001146 :
        Stocks: TextConst ENU = 'Stocks:', ESP = 'Existencias:';



    trigger OnPreReport();
    begin
        Spaces := '                    ';
    end;



    // LOCAL procedure CalcHigh (p_recdatosuo@7001105 : Record 7207386;var p_desviaprecio@7001104 : Decimal;var p_desviacantidad@7001103 : Decimal;var p_production@7001102 : Decimal;var p_OE@7001101 :
    LOCAL procedure CalcHigh(p_recdatosuo: Record 7207386; var p_desviaprecio: Decimal; var p_desviacantidad: Decimal; var p_production: Decimal; var p_OE: Decimal)
    var
        //       LocRecuo@7001108 :
        LocRecuo: Record 7207386;
        //       Vartotmedppto@7001107 :
        Vartotmedppto: Decimal;
        //       Vartotprod@7001106 :
        Vartotprod: Decimal;
    begin
        p_OE := 0;
        p_desviaprecio := 0;
        p_desviacantidad := 0;
        p_production := 0;

        LocRecuo.SETRANGE(LocRecuo."Job No.", p_recdatosuo."Job No.");
        LocRecuo.SETFILTER(LocRecuo."Account Type", '<>%1', LocRecuo."Account Type"::Unit);
        LocRecuo.SETFILTER(LocRecuo."Piecework Code", p_recdatosuo.Totaling);
        if LocRecuo.FIND('-') then
            repeat
                if Seleccion.GETFILTER("Budget Filter") <> '' then
                    LocRecuo.SETFILTER("Budget Filter", Seleccion.GETFILTER("Budget Filter"));
                LocRecuo.SETRANGE("Filter Date");
                LocRecuo.CALCFIELDS("Budget Measure", "Amount Production Budget", "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");
                LocRecuo.SETRANGE("Budget Filter");
                LocRecuo.SETFILTER("Filter Date", '%1..%2', DateIni, DateEnd);
                LocRecuo.CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Total Measurement Production");
                if LocRecuo."Budget Measure" <> 0 then
                    AvgBudgetCost := LocRecuo."Amount Cost Budget (JC)" / LocRecuo."Budget Measure"
                else
                    AvgBudgetCost := 0;

                if LocRecuo."Total Measurement Production" <> 0 then
                    AvgCostPerformed := LocRecuo."Amount Cost Performed (JC)" / LocRecuo."Total Measurement Production"
                else
                    AvgCostPerformed := 0;

                p_desviaprecio := p_desviaprecio +
                       LocRecuo."Total Measurement Production" * (AvgBudgetCost - AvgCostPerformed);

                p_desviacantidad := p_desviacantidad +
                    AvgBudgetCost * (LocRecuo."Budget Measure" - LocRecuo."Total Measurement Production");

                p_production := p_production + LocRecuo."Amount Production Performed";

                Vartotmedppto := Vartotmedppto + LocRecuo."Budget Measure";
                Vartotprod := Vartotprod + LocRecuo."Total Measurement Production";
            until LocRecuo.NEXT = 0;
    end;

    /*begin
    end.
  */

}



