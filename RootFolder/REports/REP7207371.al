report 7207371 "Cost Control Card"
{


    Permissions = TableData 121 = r;
    CaptionML = ESP = 'Ficha Control de Costes', ENG = 'Cost Control Card';
    EnableHyperlinks = true;

    dataset
    {

        DataItem("PriceCostDataBase"; "Data Piecework For Production")
        {

            DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 ORDER(Descending)
                                 WHERE("Account Type" = CONST("Unit"), "Production Unit" = CONST(true));


            RequestFilterFields = "Job No.", "Piecework Code", "Filter Date";
            Column(CompanyInformationPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(TextProj; TextProj)
            {
                //SourceExpr=TextProj;
            }
            Column(UODesc; Description)
            {
                //SourceExpr=Description;
            }
            Column(FilterPeriod; FilterPeriod)
            {
                //SourceExpr=FilterPeriod;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(NameJob; NameJob)
            {
                //SourceExpr=NameJob;
            }
            Column(JobNo; "Job No.")
            {
                //SourceExpr="Job No.";
            }
            Column(Description2; Job."Description 2")
            {
                //SourceExpr=Job."Description 2";
            }
            Column(UOCod; "Piecework Code")
            {
                //SourceExpr="Piecework Code";
            }
            Column(BudgetInitialPeriod; BudgetInitialPeriod)
            {
                //SourceExpr=BudgetInitialPeriod;
            }
            Column(BudgetInitialYear; BudgetInitialYear)
            {
                //SourceExpr=BudgetInitialYear;
            }
            Column(BudgetInitialSource; BudgetInitialSource)
            {
                //SourceExpr=BudgetInitialSource;
            }
            Column(BudgetInitialTotal; BudgetInitialTotal)
            {
                //SourceExpr=BudgetInitialTotal;
            }
            Column(BudgetActualPeriod; BudgetActualPeriod)
            {
                //SourceExpr=BudgetActualPeriod;
            }
            Column(BudgetActualYear; BudgetActualYear)
            {
                //SourceExpr=BudgetActualYear;
            }
            Column(BudgetActualSource; BudgetActualSource)
            {
                //SourceExpr=BudgetActualSource;
            }
            Column(BudgetActualTotal; BudgetActualTotal)
            {
                //SourceExpr=BudgetActualTotal;
            }
            Column(RealPeriod; RealPeriod)
            {
                //SourceExpr=RealPeriod;
            }
            Column(RealYear; RealYear)
            {
                //SourceExpr=RealYear;
            }
            Column(RealSource; RealSource)
            {
                //SourceExpr=RealSource;
            }
            Column(RealTotal; RealTotal)
            {
                //SourceExpr=RealTotal;
            }
            Column(MeasurePeriod; MeasurePeriod)
            {
                //SourceExpr=MeasurePeriod;
            }
            Column(MeasureYear; MeasureYear)
            {
                //SourceExpr=MeasureYear;
            }
            Column(MeasureSource; MeasureSource)
            {
                //SourceExpr=MeasureSource;
            }
            Column(MeasureTotal; MeasureTotal)
            {
                //SourceExpr=MeasureTotal;
            }
            Column(CostUnitReal; CostUnitReal)
            {
                //SourceExpr=CostUnitReal;
            }
            Column(CostUnitBudget; CostUnitBudget)
            {
                //SourceExpr=CostUnitBudget;
            }
            Column(Initial_Budget_Piecework; Job."Initial Budget Piecework")
            {
                //SourceExpr=Job."Initial Budget Piecework";
            }
            Column(Current_Piecework_Budget; Job."Current Piecework Budget")
            {
                //SourceExpr=Job."Current Piecework Budget";
            }
            DataItem("Data Cost By Piecework"; "Data Cost By Piecework")
            {

                DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Descending)
                                 WHERE("Cost Type" = FILTER("Item" | "Resource"));
                DataItemLink = "Job No." = FIELD("Job No."),
                            "Cod. Measure Unit" = FIELD("Piecework Code");
                Column(AmountMov; AmountMov)
                {
                    //SourceExpr=AmountMov;
                }
                Column(AmountBudget; AmountBudget)
                {
                    //SourceExpr=AmountBudget;
                }
                Column(CostMov; CostMov)
                {
                    //SourceExpr=CostMov;
                }
                Column(CostBudget; CostBudget)
                {
                    //SourceExpr=CostBudget;
                }
                Column(QuantityBudget; QuantityBudget)
                {
                    //SourceExpr=QuantityBudget;
                }
                Column(QuantityMov; QuantityMov)
                {
                    //SourceExpr=QuantityMov;
                }
                Column(Unit; Unit)
                {
                    //SourceExpr=Unit;
                }
                Column(NameItemReso; NameItemReso)
                {
                    //SourceExpr=NameItemReso;
                }
                Column(Data_Cost_By_Piecework_Type_Cost; "Cost Type")
                {
                    //SourceExpr="Cost Type";
                }
                Column(Data_Cost_By_Piecework_No; "Data Cost By Piecework"."No.")
                {
                    //SourceExpr="Data Cost By Piecework"."No.";
                }
                Column(itemBookmark; itemBookmark)
                {
                    //SourceExpr=itemBookmark;
                }
                Column(resourceBookmark; resourceBookmark)
                {
                    //SourceExpr=resourceBookmark;
                }
                DataItem("LinesShipment"; "Purch. Rcpt. Line")
                {
                    //verify
                    DataItemTableView = SORTING("Job No.", "Type", "No.", "Order Date")
                                 ORDER(Descending);
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework NÂº" = FIELD("Piecework Code");
                    Column(LinesShipment__Buy_from_Vendor_No__; "Buy-from Vendor No.")
                    {
                        //SourceExpr="Buy-from Vendor No.";
                    }
                    Column(NameProv; NameProv)
                    {
                        //SourceExpr=NameProv;
                    }
                    Column(LinesShipment__Document_No__; "Document No.")
                    {
                        //SourceExpr="Document No.";
                    }
                    Column(CabCompra2__Posting_Date_; PurchRcptHeader2."Posting Date")
                    {
                        //SourceExpr=PurchRcptHeader2."Posting Date";
                    }
                    Column(LinesShipment_Type; Type)
                    {
                        //SourceExpr=Type;
                    }
                    Column(LinesShipment__No__; "No.")
                    {
                        //SourceExpr="No.";
                    }
                    Column(NameItemReso_Control86; NameItemReso)
                    {
                        //SourceExpr=NameItemReso;
                    }
                    Column(Quantity__Quantity_Invoiced_; Quantity - "Quantity Invoiced")
                    {
                        //SourceExpr=Quantity-"Quantity Invoiced";
                    }
                    Column(LinesShipment__Unit_Cost_; "Unit Cost")
                    {
                        //SourceExpr="Unit Cost";
                    }
                    Column(CostPend_Control96; CostPend)
                    {
                        //SourceExpr=CostPend;
                    }
                    Column(LinesShipment_Line_No_; "Line No.")
                    {
                        //SourceExpr="Line No." ;
                    }
                    trigger OnPreDataItem();
                    BEGIN
                        CurrReport.CREATETOTALS(CostPend);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        PurchRcptHeader2.GET("Document No.");
                        IF (PurchRcptHeader2."Posting Date" < DateIni) OR (PurchRcptHeader2."Posting Date" > DateEnd) THEN
                            CurrReport.SKIP;
                        IF Quantity = "Quantity Invoiced" THEN
                            CurrReport.SKIP;
                        CostPend := (Quantity - "Quantity Invoiced") * "Unit Cost"
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    //SETFILTER("Cod. Budget",PriceCostDataBase.GETFILTER("Budget Filter"));
                    SETFILTER("Cod. Budget", Job."Current Piecework Budget");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    CASE "Cost Type" OF
                        "Cost Type"::Item:
                            BEGIN
                                IF Item.GET("No.") THEN BEGIN
                                    NameItemReso := Item.Description;
                                    Unit := Item."Base Unit of Measure";
                                END ELSE BEGIN
                                    NameItemReso := '';
                                    Unit := '';
                                END;
                            END;
                        "Cost Type"::Resource:
                            BEGIN
                                IF Resource.GET("No.") THEN BEGIN
                                    NameItemReso := Resource.Name;
                                    Unit := Resource."Base Unit of Measure";
                                END ELSE BEGIN
                                    NameItemReso := '';
                                    Unit := '';
                                END;
                            END;
                    END;

                    QuantityBudget := "Performance By Piecework";
                    CostBudget := "Direct Unitary Cost (JC)";

                    JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date", Type, "No.", "Entry Type", "Piecework No.");
                    JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntry.SETRANGE("Job No.", PriceCostDataBase."Job No.");
                    JobLedgerEntry.SETRANGE("Piecework No.", PriceCostDataBase."Piecework Code");
                    JobLedgerEntry.SETFILTER("Posting Date", '%1..%2', DateIni, DateEnd);
                    IF "Cost Type" = "Cost Type"::Item THEN
                        JobLedgerEntry.SETRANGE(Type, JobLedgerEntry.Type::Item);
                    IF "Cost Type" = "Cost Type"::Resource THEN
                        JobLedgerEntry.SETRANGE(Type, JobLedgerEntry.Type::Resource);
                    JobLedgerEntry.SETRANGE("No.", "No.");
                    QuantityMov := 0;
                    AmountMov := 0;
                    IF JobLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            QuantityMov := QuantityMov + JobLedgerEntry.Quantity;
                            AmountMov := AmountMov + JobLedgerEntry."Total Cost (LCY)";
                        UNTIL JobLedgerEntry.NEXT = 0;
                        IF QuantityMov <> 0 THEN
                            IF QuantityMov <> 0 THEN
                                CostMov := (AmountMov / QuantityMov)
                            ELSE
                                CostMov := 0
                        ELSE
                            QuantityMov := 0;
                    END ELSE BEGIN
                        QuantityMov := 0;
                        AmountMov := 0;
                        CostMov := 0;
                    END;


                    IF ("Cost Type" = "Cost Type"::Item) THEN BEGIN
                        Item2.GET("No."); //Get Item record
                        ItemRecRef.SETPOSITION(Item2.GETPOSITION); //Set position in item reference
                        itemBookmark := FORMAT(ItemRecRef.RECORDID, 0, 10); //Create NAV Bookmark
                    END;

                    IF ("Cost Type" = "Cost Type"::Resource) THEN BEGIN
                        Resource.GET("No."); //Get Item record
                        ResRecRef.SETPOSITION(Resource.GETPOSITION); //Set position in item reference
                        resourceBookmark := FORMAT(ResRecRef.RECORDID, 0, 10); //Create NAV Bookmark
                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                DateIni := GETRANGEMIN("Filter Date");
                DateEnd := GETRANGEMAX("Filter Date");
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
                FilterPeriod := GETFILTER("Filter Date");
            END;

            trigger OnAfterGetRecord();
            BEGIN

                NameJob := '';
                IF Job.GET("Job No.") THEN BEGIN
                    NameJob := Job.Description + Job."Description 2";
                    IF Job."Matrix Job it Belongs" <> '' THEN
                        TextProj := Record
                    ELSE
                        TextProj := TJob;
                    IF TextProj = TJob THEN
                        TextTotal := TotalJob
                    ELSE
                        TextTotal := TotalRecord;
                END;


                //Datos Ppto Inicial
                //Periodo
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Initial Budget Piecework");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DateIni, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetInitialPeriod := DataPieceworkForProduction."Budget Measure";
                END;

                //A¤o
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Initial Budget Piecework");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DMY2DATE(1, 1, DATE2DMY(DateEnd, 3)), DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetInitialYear := DataPieceworkForProduction."Budget Measure";
                END;

                //Origen
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Initial Budget Piecework");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetInitialSource := DataPieceworkForProduction."Budget Measure";
                END;

                //Total
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Initial Budget Piecework");
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetInitialTotal := DataPieceworkForProduction."Budget Measure";
                END;

                //Datos Ppto Actual
                //Periodo
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DateIni, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetActualPeriod := DataPieceworkForProduction."Budget Measure";
                END;

                //A¤o
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DMY2DATE(1, 1, DATE2DMY(DateEnd, 3)), DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetActualYear := DataPieceworkForProduction."Budget Measure";
                END;

                //Origen
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetActualSource := DataPieceworkForProduction."Budget Measure";
                END;

                //Total
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                    BudgetActualTotal := DataPieceworkForProduction."Budget Measure";
                END;

                //Datos realizado
                //Periodo
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DateIni, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
                    RealPeriod := DataPieceworkForProduction."Amount Cost Performed (JC)";
                END;

                //A¤o
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DMY2DATE(1, 1, DATE2DMY(DateEnd, 3)), DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
                    RealYear := DataPieceworkForProduction."Amount Cost Performed (JC)";
                END;

                //Origen
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
                    RealSource := DataPieceworkForProduction."Amount Cost Performed (JC)";
                END;

                //Total
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)");
                    RealTotal := DataPieceworkForProduction."Amount Cost Performed (JC)";
                END;


                //Datos medici¢n
                //Periodo
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DateIni, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                    MeasurePeriod := DataPieceworkForProduction."Total Measurement Production";
                END;

                //A¤o
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', DMY2DATE(1, 1, DATE2DMY(DateEnd, 3)), DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                    MeasureYear := DataPieceworkForProduction."Total Measurement Production";
                END;

                //Origen
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                    MeasureSource := DataPieceworkForProduction."Total Measurement Production";
                END;

                //Total
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    DataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                    MeasureTotal := DataPieceworkForProduction."Total Measurement Production";
                END;



                //Cuadro de precios
                //Precio coste ppto
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Job No.", '%1', "Job No.");
                DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Piecework Code", '%1', "Piecework Code");
                DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                DataPieceworkForProduction.SETFILTER("Filter Date", '%1..%2', 0D, DateEnd);
                IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                    CostUnitBudget := DataPieceworkForProduction.CostPrice;
                END;

                //Precio realizado
                IF MeasureSource <> 0 THEN
                    CostUnitReal := RealSource / MeasureSource
                ELSE
                    CostUnitReal := 0;
            END;


        }
    }
    requestpage
    {
        CaptionML = ESP = 'Ficha Control de Costes', ENG = 'Card Cost Control';
        layout
        {
        }
    }
    labels
    {
        lbNameReport = 'CARD COSTS CONTROL/ FICHA DE CONTROL DE COSTES/';
        lbPagNo = 'Page/ P g./';
        lbMeasures = 'Measures/ Mediciones/';
        lbPeriod = 'Period/ Per¡odo/';
        lbYear = 'Year/ A¤o/';
        lbOrigin = 'Origin/ Origen/';
        lbTotal = 'Total/ Total/';
        lbCosts = 'Costs/ Costes/';
        lbReal = 'Real/ Real/';
        lbDesviation = 'Desviation/ Desviaci¢n/';
        lbUdBudget = 'Budget Units/ Unidades ppto/';
        lbMeasure = 'MEASURE/ MEDICIàN/';
        lbBudget = 'Budget/ Ppto./';
        lbPerformed = 'Performed/ Realizado/';
        lbPriceUnit = 'UNIT PRICE/ PRECIO UNITARIO/';
        lbAmount = 'AMOUNT/ IMPORTE/';
        lbUdJobNo = 'No Preicework/ Unidad de obra n§/';
        lbBudgetInitial = 'Initial Budget/ Presupuesto inicial/';
        lbBudgetActual = 'Actual Budget/ Presupuesto actual/';
        lbMeasureReal = 'Real Measure/ Medici¢n real/';
        lbPorcPi = '% over PI/ % sobre PI/';
        lbPorcPA = '% over PA/ % sobre PA/';
        lbCostReal = 'Real Cost/ Coste Real/';
        lbCostUnit = 'Unit Cost/ Coste unitario/';
        lbCostAvance = 'Advance Cost/ Coste avance/';
        lbEstimatEnd = 'End Estimation/ Estimaci¢n final/';
        DynamicsNAVURL = 'DynamicsNAV:///// DynamicsNAV://///';
    }

    var
        //       DateIni@1100231000 :
        DateIni: Date;
        //       DateEnd@1100231001 :
        DateEnd: Date;
        //       DateAct@1100231002 :
        DateAct: Date;
        //       DataPieceworkForProduction@1100231003 :
        DataPieceworkForProduction: Record 7207386;
        //       CompanyInformation@1100231004 :
        CompanyInformation: Record 79;
        //       JobLedgerEntry@1100231005 :
        JobLedgerEntry: Record 169;
        //       TextProj@1100231006 :
        TextProj: Text[30];
        //       TextTotal@1100231007 :
        TextTotal: Text[30];
        //       FilterPeriod@1100231008 :
        FilterPeriod: Text[30];
        //       MeasureOrigen@1100231009 :
        MeasureOrigen: Decimal;
        //       AmountShipment@1100231036 :
        AmountShipment: Decimal;
        //       PurchRcptHeader2@1100231037 :
        PurchRcptHeader2: Record 120;
        //       QuantityPendShipment@1100231038 :
        QuantityPendShipment: Decimal;
        //       NameProv@1100231039 :
        NameProv: Text[30];
        //       Vendor@1100231040 :
        Vendor: Record 23;
        //       AmountAnality@1100231041 :
        AmountAnality: Decimal;
        //       ForecastDataAmountPiecework2@1100231043 :
        ForecastDataAmountPiecework2: Record 7207392;
        //       CostPend@1100231044 :
        CostPend: Decimal;
        //       Text0001@1100251000 :
        Text0001: TextConst ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       NameJob@1100227000 :
        NameJob: Text[250];
        //       Job@1100227001 :
        Job: Record 167;
        //       Item@1100227002 :
        Item: Record 27;
        //       NameItemReso@1100227003 :
        NameItemReso: Text[250];
        //       Unit@1100227004 :
        Unit: Code[10];
        //       Resource@1100227005 :
        Resource: Record 156;
        //       QuantityBudget@1100227006 :
        QuantityBudget: Decimal;
        //       CostBudget@1100227007 :
        CostBudget: Decimal;
        //       AmountBudget@1100227008 :
        AmountBudget: Decimal;
        //       QuantityMov@1100227009 :
        QuantityMov: Decimal;
        //       AmountMov@1100227010 :
        AmountMov: Decimal;
        //       CostMov@1100227011 :
        CostMov: Decimal;
        //       "//------- Version 2013"@1100227012 :
        "//------- Version 2013": Integer;
        //       BudgetInitialPeriod@1100227013 :
        BudgetInitialPeriod: Decimal;
        //       BudgetInitialYear@1100227014 :
        BudgetInitialYear: Decimal;
        //       BudgetInitialSource@1100227015 :
        BudgetInitialSource: Decimal;
        //       BudgetInitialTotal@1100227016 :
        BudgetInitialTotal: Decimal;
        //       BudgetActualPeriod@1100227020 :
        BudgetActualPeriod: Decimal;
        //       BudgetActualYear@1100227019 :
        BudgetActualYear: Decimal;
        //       BudgetActualSource@1100227018 :
        BudgetActualSource: Decimal;
        //       BudgetActualTotal@1100227017 :
        BudgetActualTotal: Decimal;
        //       RealPeriod@1100227024 :
        RealPeriod: Decimal;
        //       RealYear@1100227023 :
        RealYear: Decimal;
        //       RealSource@1100227022 :
        RealSource: Decimal;
        //       RealTotal@1100227021 :
        RealTotal: Decimal;
        //       MeasurePeriod@1100227028 :
        MeasurePeriod: Decimal;
        //       MeasureYear@1100227027 :
        MeasureYear: Decimal;
        //       MeasureSource@1100227026 :
        MeasureSource: Decimal;
        //       MeasureTotal@1100227025 :
        MeasureTotal: Decimal;
        //       CostUnitReal@1100227029 :
        CostUnitReal: Decimal;
        //       CostUnitBudget@1100227030 :
        CostUnitBudget: Decimal;
        //       "--- Link with page item and resource"@1100227035 :
        "--- Link with page item and resource": Boolean;
        //       ItemRecRef@1100227034 :
        ItemRecRef: RecordRef;
        //       Item2@1100227033 :
        Item2: Record 27;
        //       itemBookmark@1100227032 :
        itemBookmark: Text[250];
        //       ResRecRef@1100227037 :
        ResRecRef: RecordRef;
        //       Resource2@1100227036 :
        Resource2: Record 156;
        //       resourceBookmark@1100227031 :
        resourceBookmark: Text[250];
        //       TJob@7001100 :
        TJob: TextConst ENU = 'Job', ESP = 'Obra';
        //       TotalJob@7001101 :
        TotalJob: TextConst ENU = 'Total Job', ESP = 'Total Obra';
        //       TotalRecord@7001102 :
        TotalRecord: TextConst ENU = 'Total Record', ESP = 'Total Expediente';
        //       Record@7001103 :
        Record: TextConst ENU = 'Record', ESP = 'Expediente';



    trigger OnPreReport();
    begin
        ItemRecRef.OPEN(27); //Open reference to record 27 - Item
        ResRecRef.OPEN(DATABASE::Resource);
    end;



    /*begin
        end.
      */

}



