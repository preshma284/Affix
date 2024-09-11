report 7207370 "Decomposed Price List"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Decomposed Price List', ESP = 'Listado precios descompuestos';

    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;


            RequestFilterFields = "No.", "Budget Filter";
            Column(Job_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(Job_Description; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            Column(Job_Description2; Job."Description 2")
            {
                //SourceExpr=Job."Description 2";
            }
            Column(TotalCostPendingI_Control16; TotalCostPendingI)
            {
                //SourceExpr=TotalCostPendingI;
            }
            DataItem("<Data Piecework For Prod.>"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Title", "Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Account Type" = CONST("Unit"), "Production Unit" = CONST(true));
                PrintOnlyIfDetail = true;


                RequestFilterFields = "Piecework Code";
                CalcFields = "Amount Production Performed", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)", "Budget Measure", "Total Measurement Production", "Amount Cost Budget (JC)", "Amount Production Budget";
                DataItemLink = "Job No." = FIELD("No.");
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(COMPANYNAME; COMPANYNAME)
                {
                    //SourceExpr=COMPANYNAME;
                }
                Column(CompanyInformation_Picture; CompanyInformation.Picture)
                {
                    //SourceExpr=CompanyInformation.Picture;
                }
                Column(Job_No_1; "Job No.")
                {
                    //SourceExpr="Job No.";
                }
                Column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(NoBudget; NoBudget)
                {
                    //SourceExpr=NoBudget;
                }
                Column(BudgetText; BudgetText)
                {
                    //SourceExpr=BudgetText;
                }
                Column(DataPieceworkForProductionc__Title; Title)
                {
                    //SourceExpr=Title;
                }
                Column(Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Piecework_Code; "Piecework Code")
                {
                    //SourceExpr="Piecework Code";
                }
                Column(TotalMea; TotalMea)
                {
                    //SourceExpr=TotalMea;
                }
                Column(DataPieceworkForProduction__Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(DataPieceworkForProduction__Unit_Of_Measure; "Unit Of Measure")
                {
                    //SourceExpr="Unit Of Measure";
                }
                Column(DataPieceworkForProduction___PriceSales; PriceSales)
                {
                    //SourceExpr=PriceSales;
                }
                Column(PendingMea; PendingMea)
                {
                    //SourceExpr=PendingMea;
                }
                Column(DataPieceworkForProduction___Amount_Production_Budget; "Amount Production Budget")
                {
                    //SourceExpr="Amount Production Budget";
                }
                Column(PendingSale; PendingSale)
                {
                    //SourceExpr=PendingSale;
                }
                Column(TotalSale; TotalSale)
                {
                    //SourceExpr=TotalSale;
                }
                Column(CosTotUnit_CosTotUnitP; TotalUnitCost + TotalUnitCostI)
                {
                    //SourceExpr=TotalUnitCost+TotalUnitCostI;
                }
                Column(TotalCostPending_TotalCostPendingI; TotalCostPending + TotalCostPendingI)
                {
                    //SourceExpr=TotalCostPending+TotalCostPendingI;
                }
                Column(TotalUnitCosit_TotalMea__TotalUnitCosI_TotalMea; TotalUnitCost * TotalMea + TotalUnitCostI * TotalMea)
                {
                    //SourceExpr=TotalUnitCost*TotalMea + TotalUnitCostI*TotalMea;
                }
                Column(TotalUnitCost_TotalUnitCostI_Control35; TotalUnitCost + TotalUnitCostI)
                {
                    //SourceExpr=TotalUnitCost+TotalUnitCostI;
                }
                Column(TotalCostPending_TotalCostPendingI_Control36; TotalCostPending + TotalCostPendingI)
                {
                    //SourceExpr=TotalCostPending+TotalCostPendingI;
                }
                Column(TotalUnitCost_TotalMea___TotalUnitCosTotalUnitCosI_TotalMea_Control37; TotalUnitCost * TotalMea + TotalUnitCostI * TotalMea)
                {
                    //SourceExpr=TotalUnitCost*TotalMea +TotalUnitCostI*TotalMea;
                }
                Column(DECOMPOSED_PRICE_LISTCaption; DECOMPOSED_PRICE_LISTCaption)
                {
                    //SourceExpr=DECOMPOSED_PRICE_LISTCaption;
                }
                Column(page_Caption; page_Caption)
                {
                    //SourceExpr=page_Caption;
                }
                Column(DataPieceworkForProduction_ChapterCaptions; Chapter_Caption)
                {
                    //SourceExpr=Chapter_Caption;
                }
                Column(Pending_MeasurementCaption; Pending_MeasurementCaption)
                {
                    //SourceExpr=Pending_MeasurementCaption;
                }
                Column(Total_sale_pendingCaption; Total_sale_pendingCaption)
                {
                    //SourceExpr=Total_sale_pendingCaption;
                }
                Column(Total_SaleCaption; Total_SaleCaption)
                {
                    //SourceExpr=Total_SaleCaption;
                }
                Column(DataPieceworkForProduction_Piecework_Code_Caption; FIELDCAPTION("Piecework Code"))
                {
                    //SourceExpr=FIELDCAPTION("Piecework Code");
                }
                Column(MeasureCaption; MeasureCaption)
                {
                    //SourceExpr=MeasureCaption;
                }
                Column(DataPieceworkForProduction__DescriptionCaption; FIELDCAPTION(Description))
                {
                    //SourceExpr=FIELDCAPTION(Description);
                }
                Column(DataPieceworkForProduction__UnitOf_Measure_Caption; FIELDCAPTION("Unit Of Measure"))
                {
                    //SourceExpr=FIELDCAPTION("Unit Of Measure");
                }
                Column(Sale_PriceCaption; Sale_PriceCaption)
                {
                    //SourceExpr=Sale_PriceCaption;
                }
                Column(Total_CostCaption; "Total CostCaption")
                {
                    //SourceExpr="Total CostCaption";
                }
                Column(Total_Cost_Pending_Caption; Total_Cost_Pending_Caption)
                {
                    //SourceExpr=Total_Cost_Pending_Caption;
                }
                Column(Total_Unit_CostCaption; Total_Unit_CostCaption)
                {
                    //SourceExpr=Total_Unit_CostCaption;
                }
                Column(Cost_PriceCaption; Cost_PriceCaption)
                {
                    //SourceExpr=Cost_PriceCaption;
                }
                Column(Quantity_ByCaption; Quantity_ByCaption)
                {
                    //SourceExpr=Quantity_ByCaption;
                }
                Column(Unit_Code_MeasureCaption; Unit_Code_MeasureCaption)
                {
                    //SourceExpr=Unit_Code_MeasureCaption;
                }
                Column(DescriptionCaption; DescriptionCaption)
                {
                    //SourceExpr=DescriptionCaption;
                }
                Column(CodeCaption; CodeCaption)
                {
                    //SourceExpr=CodeCaption;
                }
                Column(TotalCaption; TotalCaption)
                {
                    //SourceExpr=TotalCaption;
                }
                Column(Total_projectCaption; Total_projectCaption)
                {
                    //SourceExpr=Total_projectCaption;
                }
                Column(Job_caption; Job_caption)
                {
                    //SourceExpr=Job_caption;
                }
                Column(Budget_caption; Budget_caption)
                {
                    //SourceExpr=Budget_caption;
                }
                Column(Departure_caption; Departure_caption)
                {
                    //SourceExpr=Departure_caption;
                }
                Column(Cod; Cod)
                {
                    //SourceExpr=Cod;
                }
                Column(Chapter; Chapter)
                {
                    //SourceExpr=Chapter;
                }
                Column(Cod1; Cod1)
                {
                    //SourceExpr=Cod1;
                }
                Column(Subchapter; Subchapter)
                {
                    //OptionCaptionML=ENU='SUBCHAPTER',ESP='SUBCAPÖTULO';
                    //SourceExpr=Subchapter;
                }
                Column(NotPrintResourceCapt; NotPrintResourceCapt)
                {
                    //SourceExpr=NotPrintResourceCapt;
                }
                Column(Total_ResourcesCaption; "Total_ ResourcesCaption")
                {
                    //SourceExpr="Total_ ResourcesCaption";
                }
                DataItem("Items"; "Data Cost By Piecework")
                {

                    DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Ascending)
                                 WHERE("Cost Type" = CONST("Item"), "No." = FILTER(<> ''));
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                    Column(Items__N__; "No.")
                    {
                        //SourceExpr="No.";
                    }
                    Column(Items_BillOfItemsDescription; Items.BillOfItemsDescription)
                    {
                        //SourceExpr=Items.BillOfItemsDescription;
                    }
                    Column(Items__Cod_Measure_Unit_; "Cod. Measure Unit")
                    {
                        //SourceExpr="Cod. Measure Unit";
                    }
                    Column(Items_Performance_By_Piecework_; "Performance By Piecework")
                    {
                        //SourceExpr="Performance By Piecework";
                    }
                    Column(Items_Direct_Unitary_Cost_; "Direct Unitary Cost (JC)")
                    {
                        //SourceExpr="Direct Unitary Cost (JC)";
                    }
                    Column(TotalUnitCost; TotalUnitCost)
                    {
                        //SourceExpr=TotalUnitCost;
                    }
                    Column(TotalCostPending; TotalCostPending)
                    {
                        //SourceExpr=TotalCostPending;
                    }
                    Column(TotalUnitCost_TotalMea; TotalUnitCost * TotalMea)
                    {
                        //SourceExpr=TotalUnitCost*TotalMea;
                    }
                    Column(TotalUnitCost_TotalMea_Control8; TotalUnitCost * TotalMea)
                    {
                        //SourceExpr=TotalUnitCost*TotalMea;
                    }
                    Column(TotalCostPending_Control9; TotalCostPending)
                    {
                        //SourceExpr=TotalCostPending;
                    }
                    Column(TotalUnitCost_Control11; TotalUnitCost)
                    {
                        //SourceExpr=TotalUnitCost;
                    }
                    Column(Total_ItemsCaption; "Total ItemsCaption")
                    {
                        //SourceExpr="Total ItemsCaption";
                    }
                    Column(Items_Job_No_; "Job No.")
                    {
                        //SourceExpr="Job No.";
                    }
                    Column(Items_Piecework_Code; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(Items_Cod_Budget; "Cod. Budget")
                    {
                        //SourceExpr="Cod. Budget";
                    }
                    Column(Items_Cost_Type; "Cost Type")
                    {
                        //SourceExpr="Cost Type";
                    }
                    DataItem("Resources"; "Data Cost By Piecework")
                    {

                        DataItemTableView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.")
                                 ORDER(Ascending)
                                 WHERE("Cost Type" = CONST("Resource"), "No." = FILTER(<> ''));
                        DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                        Column(Resources__N__; "No.")
                        {
                            //SourceExpr="No.";
                        }
                        Column(Resources_BillOfItemsDescription; Resources.BillOfItemsDescription)
                        {
                            //SourceExpr=Resources.BillOfItemsDescription;
                        }
                        Column(Resources_Cod_Measure_Unit; "Cod. Measure Unit")
                        {
                            //SourceExpr="Cod. Measure Unit";
                        }
                        Column(Resources_Performance_By_Piecework_; "Performance By Piecework")
                        {
                            //SourceExpr="Performance By Piecework";
                        }
                        Column(Resources_Direct_Unitary_Cost_; "Direct Unitary Cost (JC)")
                        {
                            //SourceExpr="Direct Unitary Cost (JC)";
                        }
                        Column(TotalUnitCostI_TotalMea; TotalUnitCostI * TotalMea)
                        {
                            //SourceExpr=TotalUnitCostI*TotalMea;
                        }
                        Column(TotalCostPendingI; TotalCostPendingI)
                        {
                            //SourceExpr=TotalCostPendingI;
                        }
                        Column(TotalUnitCostI; TotalUnitCostI)
                        {
                            //SourceExpr=TotalUnitCostI;
                        }
                        Column(TotalUnitCostI_TotalMea_Control15; TotalUnitCostI * TotalMea)
                        {
                            //SourceExpr=TotalUnitCostI*TotalMea;
                        }
                        Column(TotalUnitCostI_Control19; TotalUnitCostI)
                        {
                            //SourceExpr=TotalUnitCostI;
                        }
                        Column(Resources_Cod__proyecto; "Job No.")
                        {
                            //SourceExpr="Job No.";
                        }
                        Column(Resources_Piecework_Code; "Piecework Code")
                        {
                            //SourceExpr="Piecework Code";
                        }
                        Column(Resources_Cod_Budget; "Cod. Budget")
                        {
                            //SourceExpr="Cod. Budget";
                        }
                        Column(Resources_Cost_Type; "Cost Type")
                        {
                            //SourceExpr="Cost Type" ;
                        }
                        trigger OnPreDataItem();
                        BEGIN
                            SETFILTER("Cod. Budget", "<Data Piecework For Prod.>".GETFILTER("Budget Filter"));
                            CurrReport.CREATETOTALS(TotalUnitCostI, TotalCostPendingI);
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            TotalUnitCostI := "Performance By Piecework" * "Direct Unitary Cost (JC)";
                            TotalCostPendingI := TotalUnitCostI * PendingMea;
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        SETFILTER("Cod. Budget", "<Data Piecework For Prod.>".GETFILTER("Budget Filter"));
                        CurrReport.CREATETOTALS(TotalUnitCost, TotalCostPending);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        TotalUnitCost := "Performance By Piecework" * "Direct Unitary Cost (JC)";
                        TotalCostPending := TotalUnitCost * PendingMea;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    IF Job.GETFILTER("Budget Filter") <> '' THEN
                        SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"))
                    ELSE
                        SETFILTER("Budget Filter", Job."Current Piecework Budget");

                    CurrReport.CREATETOTALS(TotalUnitCost, TotalCostPending, TotalUnitCostI, TotalCostPendingI);

                    CurrReport.SHOWOUTPUT(CurrReport.TOTALSCAUSEDBY = "<Data Piecework For Prod.>".FIELDNO(Title));
                    "<Data Piecework For Prod.>".Title := '';

                    IF "<Data Piecework For Prod.>".GET("<Data Piecework For Prod.>"."Job No.", "<Data Piecework For Prod.>".Title) THEN;

                    CurrReport.SHOWOUTPUT(CurrReport.TOTALSCAUSEDBY = "<Data Piecework For Prod.>".FIELDNO("Piecework Code"));
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Cod1 := '';
                    Subchapter := '';
                    "<Data Piecework For Prod.>".CALCFIELDS("Budget Measure");
                    "<Data Piecework For Prod.>".CALCFIELDS("Total Measurement Production");
                    TotalMea := "<Data Piecework For Prod.>"."Budget Measure";
                    PerforMea := "<Data Piecework For Prod.>"."Total Measurement Production";
                    AmountExecuCost := "<Data Piecework For Prod.>"."Amount Cost Performed (JC)";
                    PendingMea := TotalMea - PerforMea;
                    TotalCostAmount := AmountExecuCost + PendingMea * PriceCostPending;
                    IF TotalMea <> 0 THEN
                        PriceTotalCost := TotalCostAmount / TotalMea
                    ELSE
                        PriceTotalCost := 0;
                    IF PerforMea <> 0 THEN
                        PriceExecuCost := AmountExecuCost / PerforMea
                    ELSE
                        PriceExecuCost := 0;

                    AmountPendCost := PendingMea * PriceCostPending;

                    TotalSale := "<Data Piecework For Prod.>"."Amount Production Budget";
                    SaleRun := "Amount Production Performed";
                    PendingSale := TotalSale - SaleRun;

                    Father := ReturnFather("<Data Piecework For Prod.>");
                    IF Indentation = 2 THEN
                        Father1 := ReturnFatherR("<Data Piecework For Prod.>")
                    ELSE
                        Father1 := '';

                    DataPieceworkForProduction1.RESET;
                    IF Job.GETFILTER("Budget Filter") <> '' THEN
                        DataPieceworkForProduction1.SETFILTER("Budget Filter", Job.GETFILTER("Budget Filter"))
                    ELSE
                        DataPieceworkForProduction1.SETFILTER("Budget Filter", Job."Current Piecework Budget");

                    DataPieceworkForProduction1.SETFILTER("Job No.", Job."No.");
                    DataPieceworkForProduction1.SETRANGE("Account Type", DataPieceworkForProduction1."Account Type"::Heading);
                    DataPieceworkForProduction1.SETRANGE("Piecework Code", Father);
                    IF DataPieceworkForProduction1.FINDFIRST THEN BEGIN
                        Cod := DataPieceworkForProduction1."Piecework Code";
                        Chapter := DataPieceworkForProduction1.Description;
                    END;

                    Resources.RESET;
                    Resources.SETRANGE("Job No.", "Job No.");
                    Resources.SETRANGE("Piecework Code", "Piecework Code");
                    Resources.SETRANGE("Cost Type", Resources."Cost Type"::Resource);
                    IF NOT Resources.FINDFIRST THEN
                        NotPrintResourceCapt := TRUE
                    ELSE
                        NotPrintResourceCapt := FALSE;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                BudgetText := '';
                IF Job.GETFILTER("Budget Filter") <> '' THEN BEGIN
                    IF JobBudget.GET(Job."No.", Job.GETFILTER("Budget Filter")) THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        NoBudget := JobBudget."Cod. Budget";
                    END
                END
                ELSE BEGIN
                    IF JobBudget.GET(Job."No.", Job."Current Piecework Budget") THEN BEGIN
                        BudgetText := JobBudget."Budget Name";
                        NoBudget := JobBudget."Cod. Budget";
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
        //       CompanyInformation@7001121 :
        CompanyInformation: Record 79;
        //       TotalMea@7001120 :
        TotalMea: Decimal;
        //       PerforMea@7001119 :
        PerforMea: Decimal;
        //       PendingMea@7001118 :
        PendingMea: Decimal;
        //       PriceTotalCost@7001117 :
        PriceTotalCost: Decimal;
        //       PriceExecuCost@7001116 :
        PriceExecuCost: Decimal;
        //       PriceCostPending@7001115 :
        PriceCostPending: Decimal;
        //       Diference@7001114 :
        Diference: Decimal;
        //       TotalCostAmount@7001113 :
        TotalCostAmount: Decimal;
        //       AmountExecuCost@7001112 :
        AmountExecuCost: Decimal;
        //       AmountPendCost@7001111 :
        AmountPendCost: Decimal;
        //       TotalSale@7001110 :
        TotalSale: Decimal;
        //       SaleRun@7001109 :
        SaleRun: Decimal;
        //       PendingSale@7001108 :
        PendingSale: Decimal;
        //       Resource@7001106 :
        Resource: Record 156;
        //       TotalUnitCost@7001105 :
        TotalUnitCost: Decimal;
        //       TotalUnitCostI@7001104 :
        TotalUnitCostI: Decimal;
        //       TotalCostPending@7001103 :
        TotalCostPending: Decimal;
        //       TotalCostPendingI@7001102 :
        TotalCostPendingI: Decimal;
        //       BudgetText@7001101 :
        BudgetText: Text[50];
        //       JobBudget@7001100 :
        JobBudget: Record 7207407;
        //       Text0001@7001141 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       DECOMPOSED_PRICE_LISTCaption@7001140 :
        DECOMPOSED_PRICE_LISTCaption: TextConst ENU = 'DECOMPOSED PRICE LIST', ESP = 'LISTADO DE PRECIOS DESCOMPUESTOS';
        //       page_Caption@7001139 :
        page_Caption: TextConst ENU = 'page', ESP = 'p g.';
        //       Pending_MeasurementCaption@7001138 :
        Pending_MeasurementCaption: TextConst ENU = 'Pending Measurement', ESP = 'Medici¢n pte';
        //       Total_sale_pendingCaption@7001137 :
        Total_sale_pendingCaption: TextConst ENU = 'Total sale pending', ESP = 'Total venta pte';
        //       Total_SaleCaption@7001136 :
        Total_SaleCaption: TextConst ENU = 'Total Sale', ESP = 'Venta total';
        //       MeasureCaption@7001135 :
        MeasureCaption: TextConst ENU = 'Measure', ESP = 'Medici¢n';
        //       Sale_PriceCaption@7001134 :
        Sale_PriceCaption: TextConst ENU = 'Sale Price', ESP = 'Precio Venta';
        //       "Total CostCaption"@7001133 :
        "Total CostCaption": TextConst ENU = 'Total Cost', ESP = 'Coste total';
        //       Total_Cost_Pending_Caption@7001132 :
        Total_Cost_Pending_Caption: TextConst ENU = 'Total Cost Pending', ESP = 'Coste total pte.';
        //       Total_Unit_CostCaption@7001131 :
        Total_Unit_CostCaption: TextConst ENU = 'Total Unit Cost', ESP = 'Coste total unitario';
        //       Cost_PriceCaption@7001130 :
        Cost_PriceCaption: TextConst ENU = 'Cost Price', ESP = 'Precio de coste';
        //       Quantity_ByCaption@7001129 :
        Quantity_ByCaption: TextConst ENU = 'Quantity By U.M.', ESP = 'Cdad. por U.M.';
        //       Unit_Code_MeasureCaption@7001128 :
        Unit_Code_MeasureCaption: TextConst ENU = 'Unit Code Measure', ESP = 'C¢d. U.M.';
        //       DescriptionCaption@7001127 :
        DescriptionCaption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       CodeCaption@7001126 :
        CodeCaption: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       TotalCaption@7001125 :
        TotalCaption: TextConst ENU = 'Total', ESP = 'Total';
        //       Total_projectCaption@7001124 :
        Total_projectCaption: TextConst ENU = 'Total Project', ESP = 'Total proyecto';
        //       "Total ItemsCaption"@7001123 :
        "Total ItemsCaption": TextConst ENU = 'Total Items', ESP = 'Total productos';
        //       "Total_ ResourcesCaption"@7001122 :
        "Total_ ResourcesCaption": TextConst ENU = 'Total Resources', ESP = 'Total recursos';
        //       Job_caption@7001142 :
        Job_caption: TextConst ENU = 'N§ JOB', ESP = 'PROYECTO N§';
        //       Budget_caption@7001143 :
        Budget_caption: TextConst ENU = 'Budget', ESP = 'Presupuesto';
        //       NoBudget@7001144 :
        NoBudget: Code[20];
        //       Departure_caption@7001145 :
        Departure_caption: TextConst ENU = 'Departure', ESP = 'Partida';
        //       Chapter_Caption@7001107 :
        Chapter_Caption: TextConst ENU = 'CHAP./SUBCHAP.', ESP = 'CAPÖTULO';
        //       DataPieceworkForProduction1@7001146 :
        DataPieceworkForProduction1: Record 7207386;
        //       Chapter@7001147 :
        Chapter: Text[50];
        //       Cod@7001148 :
        Cod: Text[20];
        //       Father@7001149 :
        Father: Code[20];
        //       Father1@7001150 :
        Father1: Code[20];
        //       Cod1@7001151 :
        Cod1: Text[20];
        //       Subchapter@7001152 :
        Subchapter: Text[50];
        //       NotPrintResourceCapt@7001153 :
        NotPrintResourceCapt: Boolean;
        //       SubChapter_Caption@7001154 :
        SubChapter_Caption: TextConst ESP = 'SUBCAPÖTULO';

    //     procedure ReturnFatherR (DataPieceworkForProduction1@1100227000 :
    procedure ReturnFatherR(DataPieceworkForProduction1: Record 7207386): Code[20];
    var
        //       FatherAux@1100227001 :
        FatherAux: Code[20];
        //       Father@1100227003 :
        Father: Code[20];
        //       DataPieceworkForProduction2@1100227002 :
        DataPieceworkForProduction2: Record 7207386;
        //       DataPieceworkForProduction3@1100227004 :
        DataPieceworkForProduction3: Record 7207386;
        //       DataPieceworkForProduction4@7001100 :
        DataPieceworkForProduction4: Record 7207386;
    begin
        if DataPieceworkForProduction1.Indentation > 0 then begin
            FatherAux := '';
            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETRANGE("Job No.", DataPieceworkForProduction1."Job No.");
            DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Heading);
            if DataPieceworkForProduction2.FINDSET then begin
                repeat
                    DataPieceworkForProduction3.RESET;
                    DataPieceworkForProduction3.SETRANGE("Job No.", DataPieceworkForProduction2."Job No.");
                    DataPieceworkForProduction3.SETFILTER("Piecework Code", DataPieceworkForProduction2.Totaling);
                    if DataPieceworkForProduction3.FINDSET then begin
                        repeat
                            if (DataPieceworkForProduction3."Piecework Code" = DataPieceworkForProduction1."Piecework Code")
                              and (DataPieceworkForProduction2.Indentation = (DataPieceworkForProduction1.Indentation - 1)) then begin
                                FatherAux := DataPieceworkForProduction2."Piecework Code";
                                Cod1 := DataPieceworkForProduction2."Piecework Code";
                                Subchapter := DataPieceworkForProduction2.Description;
                            end;
                        until (DataPieceworkForProduction3.NEXT = 0) or (FatherAux <> '');
                    end;
                until (DataPieceworkForProduction2.NEXT = 0) or (FatherAux <> '');
            end;
            Father := FatherAux;
            FatherAux := '';
        end else
            Father := '';

        exit(Father);
    end;

    /*begin
    //{
//      JAV 13/05/19: - Se aumenta la longitud de la variable global "NoBudget" a 20
//    }
    end.
  */

}



// RequestFilterFields="Piecework Code";

