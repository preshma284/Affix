page 7207506 "Piecework Data"
{
    CaptionML = ENU = 'Piecework Data', ESP = 'Datos unidad de obra';
    InsertAllowed = false;
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = FILTER("Piecework"), "Production Unit" = CONST(true));
    DataCaptionFields = "Job No.";
    PageType = Worksheet;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            grid("group48")
            {

                GridLayout = Columns;
                group("group49")
                {

                    field("JobBudget.Cod. Budget + '  ' + JobBudget.Budget Name"; JobBudget."Cod. Budget" + '  ' + JobBudget."Budget Name")
                    {

                        CaptionML = ESP = 'Presupuesto';
                    }
                    field("JobBudget.Budget Amount Cost Direct"; JobBudget."Budget Amount Cost Direct")
                    {

                        CaptionML = ENU = 'Direct Cost Budget', ESP = 'Importe Presupuesto';
                        Editable = FALSE;
                    }
                    field("TotalAmountStudiedBudget"; TotalAmountStudiedBudget)
                    {

                        CaptionML = ENU = 'Total Amount Studied Budget', ESP = 'Importe Estudiado';
                        // Numeric = false;
                        Enabled = FALSE;
                    }
                    field("FORMAT(StudiedPercentage,5,0) +' %'"; FORMAT(StudiedPercentage, 5, 0) + ' %')
                    {

                        CaptionML = ENU = '% Studied', ESP = '% Estudiado';
                        // DecimalPlaces = 2 : 2;
                        Editable = false;
                    }

                }
                group("group54")
                {

                    Visible = false;
                    field("JobBudget.Med Presupuestada"; JobBudget."Med Presupuestada")
                    {

                        CaptionML = ESP = 'Med. Presupuestada';
                        Visible = false;
                        Editable = false;
                    }
                    field("JobBudget.Med Ejecutada"; JobBudget."Med Ejecutada")
                    {

                        CaptionML = ESP = 'Med. Ejecutada';
                        Visible = false;
                        Editable = false;
                    }
                    field("JobBudget.Porcentaje Ejecutado"; JobBudget."Porcentaje Ejecutado")
                    {

                        CaptionML = ESP = '% Ejecutado';
                        Visible = false;
                        Editable = false;
                    }
                    field("JobBudget.Coste Directo Ejecutado"; JobBudget."Coste Directo Ejecutado")
                    {

                        CaptionML = ENU = '% Studied', ESP = 'Coste Ejecutado';
                        DecimalPlaces = 2 : 2;
                        Editable = false;
                    }
                    field("JobBudget.Importe Directo Esperado"; JobBudget."Importe Directo Esperado")
                    {

                        CaptionML = ESP = 'Coste Esperado';
                        Editable = false;
                    }
                    field("JobBudget.Diferencia Directos Esperada"; JobBudget."Diferencia Directos Esperada")
                    {

                        CaptionML = ESP = 'Diferencia';
                        Editable = false;
                    }

                }

            }
            repeater("table")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code", Description;
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        rec."Piecework Code" := UPPERCASE(rec."Piecework Code");
                        IF (xRec."Piecework Code" <> rec."Piecework Code") AND (xRec."Piecework Code" <> '') THEN BEGIN
                            IF NOT DataJobUnitForProduction.GET(rec."Job No.", rec."Piecework Code") THEN BEGIN
                                IF DataJobUnitForProduction.GET(xRec."Job No.", xRec."Piecework Code") THEN BEGIN
                                    DataJobUnitForProduction.DELETE;
                                    DataJobUnitForProduction.TRANSFERFIELDS(Rec, TRUE);
                                    DataJobUnitForProduction."Piecework Code" := rec."Piecework Code";
                                    IF DataJobUnitForProduction.INSERT THEN;
                                END;
                            END;
                        END;
                        OnAfterValidaCodePiecewrk;
                    END;


                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    StyleExpr = stLine;
                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                }
                field("Totaling"; rec."Totaling")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Indentation"; rec."Indentation")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Posting Group Unit Cost"; rec."Posting Group Unit Cost")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Not Recalculate Cost"; rec."Not Recalculate Cost")
                {

                    StyleExpr = stLine;
                }
                field("% Of Margin"; rec."% Of Margin")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Customer Certification Unit"; rec."Customer Certification Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;

                    ; trigger OnValidate()
                    BEGIN
                        // JAV 17/12/2018 Para las fechas
                        OnValidateType;
                        // JAV 17/12/2018 fin
                        CurrPage.UPDATE;
                    END;


                }
                field("Rental Unit"; rec."Rental Unit")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Initial Produc. Price"; rec."Initial Produc. Price")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("ProductionPrice"; rec."ProductionPrice")
                {

                    CaptionML = ENU = 'Production Price', ESP = 'Precio de Produccion';
                    DecimalPlaces = 0 : 6;
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    CaptionML = ENU = 'Measure Budg. Piecework sol', ESP = 'Medici�n ppto. unidad obra';
                    BlankZero = true;
                    Editable = edMeasureBudgPieceworkSol;
                    StyleExpr = stMeasureBudgPieceworkSol;

                    ; trigger OnValidate()
                    BEGIN
                        OnABudgetMeasurePieceworkSol;
                    END;


                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Measure Performed Budget"; rec."Measure Performed Budget")
                {

                    Visible = False;
                    Editable = False;
                    StyleExpr = stLine;
                }
                field("Measure Pending Budget"; rec."Measure Pending Budget")
                {

                    CaptionML = ENU = 'Measure Pending Budget', ESP = 'Medici�n ppto. pendiente';
                    BlankZero = true;
                    Visible = True;
                    Editable = False;
                    StyleExpr = stLine;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    CaptionML = ENU = 'Amount Cost Budget.', ESP = 'Importe coste ppto.';
                    StyleExpr = stLine;
                }
                field("Initial Budget Measure"; rec."Initial Budget Measure")
                {

                    Visible = seeInitialNew;
                    StyleExpr = stInitial1;
                }
                field("Initial Budget Price"; rec."Initial Budget Price")
                {

                    Visible = seeInitialNew;
                    StyleExpr = stInitial1;
                }
                field("InitialAmount"; InitialAmount)
                {

                    CaptionML = ESP = 'Importe Inicial';
                    Visible = seeInitialNew;
                    StyleExpr = stInitial1;
                }
                field("Initial Measure"; rec."Initial Measure")
                {

                    Visible = seeInitialOld;
                    StyleExpr = stInitial1;
                }
                field("Initial Price"; rec."Initial Price")
                {

                    Visible = seeInitialOld;
                    StyleExpr = stInitial1;
                }
                field("Initial Amount"; rec."Initial Amount")
                {

                    Visible = seeInitialOld;
                    StyleExpr = stInitial1;
                }
                field("InitialDiference"; InitialDiference)
                {

                    CaptionML = ESP = 'Dif. Prod. Inicial/Actual';
                    Editable = false;
                    StyleExpr = stInitial2;
                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    BlankZero = true;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        OnAfterBudgetProductionAmount;
                    END;


                }
                field("Actual Cost DP"; rec."Actual Cost DP")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Amount Budget Cost Pending"; rec."Amount Budget Cost Pending")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Amount Budget Cost Performed"; rec."Amount Budget Cost Performed")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Cost Price"; rec."CostPrice")
                {

                    CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Sale Amount"; rec."Sale Amount")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("AmountBudgetCostPerformed"; AmountBudgetCostPerformed)
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("AmountBudgetCostPending"; AmountBudgetCostPending)
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Total Measurement Production"; rec."Total Measurement Production")
                {

                    CaptionML = ENU = 'Total Measurement Production', ESP = 'Medici�n producci�n Ejecutada';
                    StyleExpr = stLine;
                }
                field("Amount Production Performed"; rec."Amount Production Performed")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Amount Cost Performed (JC)"; rec."Amount Cost Performed (JC)")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("MedicionPendiente"; MedicionPendiente)
                {

                    CaptionML = ESP = 'Medici�n Pendiente';
                    Editable = false;
                    StyleExpr = stMedicionPendiente;
                }
                field("PrecioCosteReal"; PrecioCosteReal)
                {

                    CaptionML = ESP = 'Precio Coste Real';
                    Editable = false;
                    StyleExpr = stLine2;
                }
                field("PrecioCosteMedio"; PrecioCosteMedio)
                {

                    CaptionML = ESP = 'Precio medio de coste';
                    Editable = false;
                    StyleExpr = stLine2;
                }
                field("ImporteEsperado"; ImporteEsperado)
                {

                    CaptionML = ESP = 'Coste Total Estimado';
                    Editable = false;
                    StyleExpr = stLine2;
                }
                field("Diferencia"; Diferencia)
                {

                    CaptionML = ESP = 'Deviacion Coste';
                    Editable = false;
                    StyleExpr = stDiferencia;
                }
                field("amountProductionInProgress"; rec."amountProductionInProgress")
                {

                    CaptionML = ENU = 'Amount Production In Progress', ESP = 'Importe producci�n en tr�mite';
                    BlankZero = true;
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("AmountProductionAccepted"; rec."AmountProductionAccepted")
                {

                    CaptionML = ENU = 'Amount Production Accepted', ESP = 'Importe producci�n aceptada';
                    BlankZero = true;
                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Amount Sale Performed (JC)"; rec."Amount Sale Performed (JC)")
                {

                    BlankZero = true;
                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("% Processed Production"; rec."% Processed Production")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Reassuring"; rec."Reassuring")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Amount Sale Contract"; rec."Amount Sale Contract")
                {

                    Visible = false;
                    StyleExpr = stLine;
                }
                field("Record Type"; rec."Record Type")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Studied"; rec."Studied")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 20/03/19: - Se mejora el c�lculo del importe estudiado, se recalcula lo estudiado al cambiar el valor
                        //CurrPage.UPDATE;
                        Rec.MODIFY(TRUE);
                        CalculateTotalAmountStudiedBudget;
                        CurrPage.UPDATE(FALSE);
                        //JAV 20/03/19
                    END;


                }
                field("Activity Code"; rec."Activity Code")
                {

                    StyleExpr = stLine;
                }
                field("Planned K"; rec."Planned K")
                {

                    BlankZero = true;
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Passing K"; rec."Passing K")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Calculated K"; rec."Calculated K")
                {

                    BlankZero = true;
                    StyleExpr = stLine;
                }
                field("Margen"; rec."CalculateMarginBudget")
                {

                    CaptionML = ENU = 'Margin', ESP = 'Margen (Producci�n ppto. - Coste realizado)';
                    ToolTipML = ESP = 'CALCULO: Importe producci�n ppto. - Importe coste realizado DL';
                    StyleExpr = stLine;
                }
                field("% Margen"; rec."CalculateMarginBudgetPerc")
                {

                    CaptionML = ENU = '% Margin', ESP = '% Margen';
                    ToolTipML = ESP = 'CALCULO: (Importe producci�n ppto. - Importe coste realizado DL) * 100 / Importe producci�n ppto.';
                    StyleExpr = stLine;
                }
                field("Date Rec.INIT"; rec."Date INIT")
                {

                    Editable = DateEditable;
                    StyleExpr = stLine;
                }
                field("Date end"; rec."Date end")
                {

                    Editable = DateEditable;
                    StyleExpr = stLine;
                }
                field("Distributed"; rec."Distributed")
                {

                    StyleExpr = stLine;
                }
                field("Registered Hours"; rec."Registered Hours")
                {

                    Visible = seeHours;
                    StyleExpr = stLine;
                }
                field("Manual Hours"; rec."Manual Hours")
                {

                    Visible = seeHours;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Manual Hours + Registered Hours"; rec."Manual Hours" + rec."Registered Hours")
                {

                    CaptionML = ESP = 'Horas Totales';
                    Visible = seeHours;
                    StyleExpr = stLine;
                }
                field("Expected Hours"; rec."Expected Hours")
                {

                    Visible = seeHours;
                    StyleExpr = stLine;
                }
                field("Expected Hours - (Manual Hours + Registered Hours)"; rec."Expected Hours" - (rec."Manual Hours" + rec."Registered Hours"))
                {

                    CaptionML = ESP = 'Horas Pendientes';
                    AutoFormatType = 2;
                    Visible = seeHours;
                    StyleExpr = stLine;
                }
                field("Registered Work Part"; rec."Registered Work Part")
                {

                    Visible = seeHours;
                    StyleExpr = stLine;
                }

            }
            group("group134")
            {

                group("group135")
                {


                }
                part("PG_BillOfItems"; 7207515)
                {

                    SubPageView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                    SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Cod. Budget" = FIELD("Budget Filter");
                    Visible = verDescompuestos;
                    Editable = bEditable;
                    UpdatePropagation = Both;
                }
                part("MeasurementLines"; 7207666)
                {
                    SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Code Budget" = FIELD("Budget Filter");
                    Visible = verMediciones;
                    Editable = bEditable;
                    UpdatePropagation = Both;
                }
                part("LineasDescripcion"; 7207570)
                {
                    SubPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Visible = verTextos;
                    Editable = bEditable;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Job Units', ESP = 'Unidades Obra';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Enabled = bEditable;
                    Image = View;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Job Piecework Card", Rec);
                    END;


                }
                action("NuevaLinea")
                {

                    CaptionML = ENU = 'New Line', ESP = 'Nueva l�nea';
                    RunObject = Page 7207508;
                    RunPageLink = "Job No." = FIELD("Job No."), "Production Unit" = FILTER(true);
                    Enabled = bEditable;
                    Image = New;
                    RunPageMode = Create;
                }
                action("BillOfItemJU")
                {

                    CaptionML = ENU = 'Bill &Of Item JU', ESP = '&Descompuesto UO';
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        ShowPiecework;
                    END;


                }
                action("MeasureLines")
                {

                    CaptionML = ENU = 'Measure &Lines', ESP = '&L�neas de medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        ShowMeasureLinesPiecework;
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Extended Texts', ESP = 'Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2");
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Image = AdjustItemCost;
                }
                action("action6")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job Cost Piecework"), "No." = FIELD("Unique Code");
                    Image = Note;
                }
                group("group9")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action7")
                    {
                        CaptionML = ENU = 'Individual Dimensions', ESP = 'Dimensiones individual';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(7207386), "No." = FIELD("Unique Code");
                        Image = Dimensions;
                    }
                    action("MultipleDimensions")
                    {

                        CaptionML = ENU = 'Multiple Dimensions', ESP = 'Dimensiones multiples';
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            DataJobUnitForProduction: Record 7207386;
                            DefaultDimMultiple: Page 542;
                        BEGIN
                            //JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensiones m�ltiple
                            CurrPage.SETSELECTIONFILTER(DataJobUnitForProduction);
                            DefaultDimMultiple.ClearTempDefaultDim;
                            IF DataJobUnitForProduction.FINDSET THEN
                                REPEAT
                                    DefaultDimMultiple.CopyDefaultDimToDefaultDim(DATABASE::"Data Piecework For Production", DataJobUnitForProduction."Unique Code");
                                UNTIL Rec.NEXT = 0;
                            DefaultDimMultiple.RUNMODAL;
                        END;


                    }

                }
                action("HistSalePricesJU")
                {

                    CaptionML = ENU = '&Hist. Sale Prices JU', ESP = '&Hist. precios venta UO';
                    Visible = false;

                    trigger OnAction()
                    VAR
                        HistSalePricesJU: Record 7207385;
                    BEGIN
                        HistSalePricesJU.RESET;
                        HistSalePricesJU.FILTERGROUP(2);
                        HistSalePricesJU.SETRANGE("Job No.", rec."Job No.");
                        HistSalePricesJU.FILTERGROUP(0);
                        HistSalePricesJU.SETFILTER("Cod. Reestimate", rec.GETFILTER("Budget Filter"));
                        IF rec."Account Type" = rec."Account Type"::Heading THEN
                            HistSalePricesJU.SETFILTER("Piecework Code", rec.Totaling)
                        ELSE
                            HistSalePricesJU.SETFILTER("Piecework Code", rec."Piecework Code");
                        PAGE.RUNMODAL(PAGE::"Hist. Sale Prices Piecework Li", HistSalePricesJU);
                    END;


                }
                action("ExportDataToMicrosoftProyect")
                {

                    CaptionML = ENU = 'E&xport Data To Microsoft Proyect', ESP = 'E&xportar datos a Microsoft Project';
                    Image = Export;

                    trigger OnAction()
                    VAR
                    // ExportBudgetToMSP: Report 7207382;
                    BEGIN
                        DataJobUnitForProduction.RESET;
                        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                        // ExportBudgetToMSP.PassParameters(BudgetInProgress);
                        // ExportBudgetToMSP.SETTABLEVIEW(DataJobUnitForProduction);
                        // ExportBudgetToMSP.RUNMODAL;
                    END;


                }
                action("ImportDataToMicrosoftProyect")
                {

                    CaptionML = ENU = 'Import Data To &Microsoft Proyect', ESP = 'Importar datos a &Microsoft Project';
                    Image = Import;

                    trigger OnAction()
                    VAR
                    // ImportBudgetToMSP: Report 7207383;
                    BEGIN
                        Job.RESET;
                        Job.SETRANGE("No.", rec."Job No.");
                        // ImportBudgetToMSP.PassParameters(BudgetInProgress);
                        // ImportBudgetToMSP.SETTABLEVIEW(Job);
                        // ImportBudgetToMSP.RUNMODAL;
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'View Dat&a MSP', ESP = 'Ver dat&os MSP';
                    Visible = FALSE;
                    Image = Status;

                    trigger OnAction()
                    BEGIN
                        //JAV 11/12/18: Se cambia la llamada, se eliminan las propiedades y se pone c�digo para que recalcule primero,
                        //              se provecha la llamada que estaba en otra acci�n

                        //Propiedades del bot�n eliminadas
                        //RunObjectPAGE Planning Pieceworks MSP
                        //RunPageViewSORTING(Job No.,Piecework Code)
                        //RunPageLinkJob No.=FIELD(Job No.)

                        //SchedulePiecework;
                        //PAGE.RUNMODAL(PAGE::"Planning Pieceworks MSP",DataJobUnitForProduction);
                        //JAV 11/12/18 fin
                    END;


                }
                action("ActivationAccount")
                {

                    CaptionML = ENU = 'A&ctivation Account', ESP = '&Cuentas de activaci�n';
                    Visible = false;
                }

            }
            group("AccProyectos")
            {

                CaptionML = ENU = '&Acciones', ESP = 'Acciones Generales';
                separator("-")
                {

                    CaptionML = ESP = '--- Para Proyectos';
                }
                action("SurveyABC")
                {

                    CaptionML = ENU = 'Survey ABC', ESP = 'Estudio ABC';
                    Visible = VisibleJobs;
                    Image = CalculateSimulation;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN

                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE("Budget Filter", BudgetInProgress);
                        IF DataPieceworkForProduction.FINDFIRST THEN
                            REPEAT
                                DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                                DataPieceworkForProduction."Amount Cost Budget Planning" := DataPieceworkForProduction."Amount Cost Budget (JC)";
                                DataPieceworkForProduction.MODIFY;
                            UNTIL DataPieceworkForProduction.NEXT = 0;

                        StudyABC := NOT StudyABC;
                        CurrPage.UPDATE;
                        IF StudyABC THEN BEGIN
                            Rec.SETRANGE("Account Type", rec."Account Type"::Unit);
                            Rec.SETCURRENTKEY("Job No.", "Account Type", "Amount Cost Budget Planning");
                            rec.ASCENDING(FALSE);
                        END ELSE BEGIN
                            Rec.SETRANGE("Account Type");
                            Rec.SETCURRENTKEY("Job No.", "Piecework Code");
                            rec.ASCENDING(TRUE);
                        END;
                    END;


                }
                action("MarkStudiedDatapiecework")
                {

                    CaptionML = ENU = 'MARK Studied Data Piecework', ESP = 'Marcar estudiado';
                    Visible = VisibleJobs;
                    Enabled = bEditable;
                    Image = Approval;
                    trigger OnAction()
                    VAR
                        ConfirmMarkTrue: TextConst ENU = 'Do you want to Rec.MARK Datapiecework as studied?', ESP = '�Desea marcar como estudiado la unidad de obra?';
                        ConfirmMarkFalse: TextConst ENU = 'Do you want to unmark Datapiecework as studied?', ESP = '�Desea desmarcar como estudiado la unidad de obra?';
                        DataPieceworkForProductionAux: Record 7207386;
                        ConfirmMark: TextConst ESP = '�Desea cambiar la marca de estudiado a las unidades de obra seleccionadas?';
                        tmpDataPieceworkForProductionAux: Record 7207386 temporary;
                        i: Integer;
                    BEGIN
                        //JAV 20/03/19: - Cambio el proceso de marcar para que funcione mejor
                        IF CONFIRM(ConfirmMark, TRUE) THEN BEGIN
                            //Guardo los datos en un temporal
                            tmpDataPieceworkForProductionAux.RESET;
                            tmpDataPieceworkForProductionAux.DELETEALL;
                            CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionAux);
                            Rec.COPYFILTER("Budget Filter", DataPieceworkForProductionAux."Budget Filter"); // 19/03/2019
                            IF DataPieceworkForProductionAux.FINDSET(FALSE) THEN BEGIN
                                REPEAT
                                    tmpDataPieceworkForProductionAux := DataPieceworkForProductionAux;
                                    tmpDataPieceworkForProductionAux.INSERT;
                                UNTIL DataPieceworkForProductionAux.NEXT = 0;
                            END;

                            //Proceso por niveles ya que los padres me cambian a los hijos
                            i := 0;
                            REPEAT
                                CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionAux);
                                Rec.COPYFILTER("Budget Filter", DataPieceworkForProductionAux."Budget Filter"); // 19/03/2019
                                DataPieceworkForProductionAux.SETRANGE(Indentation, i);
                                IF DataPieceworkForProductionAux.FINDSET THEN BEGIN
                                    REPEAT
                                        //Si est� en el temporal, lo cambio
                                        tmpDataPieceworkForProductionAux.RESET;
                                        tmpDataPieceworkForProductionAux.SETRANGE("Piecework Code", DataPieceworkForProductionAux."Piecework Code");
                                        IF (NOT tmpDataPieceworkForProductionAux.ISEMPTY) THEN BEGIN
                                            DataPieceworkForProductionAux.VALIDATE(Studied, NOT DataPieceworkForProductionAux.Studied);
                                            DataPieceworkForProductionAux.MODIFY(TRUE);
                                        END;
                                        //Quito del temporal los ya cambiados
                                        tmpDataPieceworkForProductionAux.RESET;
                                        IF (DataPieceworkForProductionAux."Account Type" = DataPieceworkForProductionAux."Account Type"::Heading) THEN BEGIN
                                            IF DataPieceworkForProductionAux.Totaling = '' THEN
                                                DataPieceworkForProductionAux.VALIDATE(Totaling);
                                            tmpDataPieceworkForProductionAux.SETFILTER("Piecework Code", DataPieceworkForProductionAux.Totaling);
                                            IF tmpDataPieceworkForProductionAux.FINDSET THEN
                                                REPEAT
                                                    tmpDataPieceworkForProductionAux.DELETE;
                                                UNTIL tmpDataPieceworkForProductionAux.NEXT = 0;
                                            //tmpDataPieceworkForProductionAux.DELETEALL;
                                        END ELSE BEGIN
                                            tmpDataPieceworkForProductionAux.SETRANGE("Piecework Code", DataPieceworkForProductionAux."Piecework Code");
                                            tmpDataPieceworkForProductionAux.DELETEALL;
                                        END;
                                    UNTIL DataPieceworkForProductionAux.NEXT = 0;
                                END;
                                i += 1;
                                tmpDataPieceworkForProductionAux.RESET;
                            UNTIL tmpDataPieceworkForProductionAux.COUNT = 0;
                            CalculateTotalAmountStudiedBudget;
                            CurrPage.UPDATE(FALSE);
                        END;

                        //  {--------------------------------------------------------------------------------------------------

                        //QB4932

                        //  IF DataPieceworkForProductionAux.Studied THEN BEGIN
                        //    IF NOT CONFIRM(ConfirmMarkFalse, TRUE) THEN
                        //      EXIT;
                        //  END ELSE BEGIN
                        //    IF NOT CONFIRM(ConfirmMarkTrue, TRUE) THEN
                        //      EXIT;
                        //  END;

                        //  CurrPage.SETSELECTIONFILTER(DataPieceworkForProductionAux);
                        //  Rec.COPYFILTER("Budget Filter",DataPieceworkForProductionAux."Budget Filter"); // 19/03/2019
                        //  IF DataPieceworkForProductionAux.FINDSET THEN BEGIN
                        //    REPEAT
                        //      DataPieceworkForProductionAux.VALIDATE(Studied, NOT DataPieceworkForProductionAux.Studied);
                        //      DataPieceworkForProductionAux.MODIFY(TRUE);
                        //    UNTIL DataPieceworkForProductionAux.NEXT = 0;
                        //  END;
                        //  //CalculateTotalAmountStudiedBudget;
                        //  CurrPage.UPDATE;
                        //  ---------------------------------------------------------------------------------------------------}
                    END;
                }
                action("SaveInitial")
                {

                    CaptionML = ENU = 'Save Initial', ESP = 'Guardar Inicial';
                    Visible = seeInitialOld;
                    Enabled = bEditable;
                    Image = SaveasStandardJournal;
                    trigger OnAction()
                    VAR
                        ConfirmProcess: TextConst ENU = 'Do you want to Rec.MARK Datapiecework as studied?', ESP = '�Desea guardar la medici�n actual como la inicial?';
                        DataPieceworkForProductionAux: Record 7207386;
                        tmpDataPieceworkForProductionAux: Record 7207386 temporary;
                        i: Integer;
                    BEGIN
                        //JAV 07/08/20: - Guardar todos los datos actuales en los campos de datos iniciales, siempre que no tengan un dato anteriormente guardado
                        IF CONFIRM(ConfirmProcess, FALSE) THEN BEGIN
                            DataPieceworkForProduction2.RESET;
                            DataPieceworkForProduction2.SETRANGE("Job No.", rec."Job No.");
                            DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
                            DataPieceworkForProduction2.SETFILTER("Initial Measure", '=0');
                            IF (DataPieceworkForProduction2.FINDSET(TRUE)) THEN
                                REPEAT
                                    DataPieceworkForProduction2.SETFILTER("Budget Filter", BudgetInProgress);
                                    DataPieceworkForProduction2.VALIDATE("Initial Measure");
                                    DataPieceworkForProduction2.MODIFY;
                                UNTIL DataPieceworkForProduction2.NEXT = 0;

                            CurrPage.UPDATE;
                        END;
                    END;
                }
                separator("separator1")
                {

                    CaptionML = ESP = '--- Para ambos';
                }
                action("CalculateBudgetRevision")
                {

                    CaptionML = ENU = 'Calculate Budget Revision', ESP = 'Calcular revisi�n ppto.';
                    Image = CalculatePlan;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                    BEGIN
                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."Job No.");
                        IF NOT JobBudget.GET(rec."Job No.", BudgetInProgress) THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }
                action("CalculateAnalyticalBudget")
                {

                    CaptionML = ENU = '&Calculate Analytical Budget', ESP = '&Calcular Ppto. analitico';
                    Image = CalculateConsumption;

                    trigger OnAction()
                    BEGIN
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            //JAV 18/03/19 - Se cambia el campo Job.status por el Job."Card type"
                            //  IF Job.GET("Job No.") THEN BEGIN
                            //    IF (Job."Job Type" = Job."Job Type"::Operative) AND
                            //       (Job.Status = Job.Status::Planning) AND (Job."Original Quote Code" <> '') THEN
                            //      JobOrVersion :=TRUE
                            //    ELSE
                            //      JobOrVersion := FALSE;
                            //  END;
                            Job.GET(rec."Job No."); //Tiene que existir si hemos llegado a esta p�gina, si no mejor dar un error
                            JobOrVersion := (Job."Job Type" = Job."Job Type"::Operative) AND (Job."Card Type" = Job."Card Type"::Estudio) AND (Job."Original Quote Code" <> '');
                            //JAV 18/03/19 fin

                            DataJobUnitForProduction.RESET;
                            DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                            IF DataJobUnitForProduction.FIND('-') THEN BEGIN
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataJobUnitForProduction, JobOrVersion, rec."Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }
                action("ProportionalDistributionCost")
                {

                    CaptionML = ENU = 'Proportional Distribution Cost', ESP = 'Repartir coste proporcional';
                    Image = ResourcePlanning;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        //JAV 18/03/19 - Unificar botones de acci�n
                        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                            DataPieceworkForProduction2.SETRANGE("Budget Filter", BudgetInProgress);
                        //JAV 18/03/19 - fin
                        // CLEAR(DistriProporBudgetCost);

                        //JAV 07/10/21: - QB 1.09.22 Pasamos al proceso el proyecto
                        // DistriProporBudgetCost.setJob(rec."Job No.");
                        //JAV --

                        // DistriProporBudgetCost.SETTABLEVIEW(DataPieceworkForProduction2);
                        // DistriProporBudgetCost.RUNMODAL;
                    END;


                }
                action("MoveBudgetInTime")
                {

                    CaptionML = ENU = 'Move Budget In Time', ESP = 'Mover presupuesto en el tiempo';
                    Image = CreateMovement;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    // MoveCostsBudget: Report 7207356;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        //JAV 18/03/19 - Unificar botones de acci�n
                        IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                            DataPieceworkForProduction2.SETRANGE("Budget Filter", BudgetInProgress);
                        //JAV 18/03/19 - fin
                        // CLEAR(MoveCostsBudget);
                        // MoveCostsBudget.SETTABLEVIEW(DataPieceworkForProduction2);
                        // MoveCostsBudget.RUNMODAL;
                    END;


                }
                action("PieceworkScheduling")
                {

                    CaptionML = ENU = 'Piecework Sch&eduling', ESP = '&Planificaci�n de UO';
                    Visible = TRUE;
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    BEGIN
                        //SchedulePiecework;
                        //JAV 11/12/18: se llama desde aqu� para provechar la llamada anterior en otra acci�n
                        //PAGE.RUNMODAL(PAGE::"Plan Job Units",DataJobUnitForProduction);
                        //JAV 11/12/18 fin

                        //JAV 22/06/21: - QB 1.09.02 Se pasa a una funci�n presentar la pantalla de planificaci�n
                        QBPageSubscriber.SeeSchedulePieceworks(rec."Job No.", BudgetInProgress, TRUE);
                    END;


                }
                group("group28")
                {
                    CaptionML = ESP = 'Copiar Descompuestos';
                    Image = Copy;
                    action("action24")
                    {
                        CaptionML = ENU = 'Copy Bill Of Items Of JU From Cost Database', ESP = 'Copiar descompuesto de UO desde preciarios';
                        Enabled = bEditable;
                        Image = CopyFromBOM;

                        trigger OnAction()
                        VAR
                            PriceBillofItemAssignment: Page 7207581;
                        BEGIN
                            CLEAR(PriceBillofItemAssignment);
                            IF rec."Piecework Code" = '' THEN
                                ERROR(Text009);

                            PriceBillofItemAssignment.GetPiecework(Rec, BudgetInProgress);
                            PriceBillofItemAssignment.DefinitionFilter(rec.Type::Piecework);
                            PriceBillofItemAssignment.RUNMODAL;
                            CurrPage.UPDATE;
                        END;


                    }
                    action("action25")
                    {
                        CaptionML = ENU = 'Copy Bill Of Items Of JU From Jobs', ESP = 'Copiar descompuesto de UO desde proyectos';
                        Visible = False;
                        Enabled = bEditable;
                        Image = CopyBOM;

                        trigger OnAction()
                        VAR
                            JobPieceworkList: Page 7207583;
                        BEGIN
                            CLEAR(JobPieceworkList);
                            IF rec."Piecework Code" = '' THEN
                                ERROR(Text009);

                            JobPieceworkList.GetPiecework(Rec, BudgetInProgress);
                            JobPieceworkList.DefinitionFilter(rec.Type::Piecework);
                            JobPieceworkList.RUNMODAL;
                            CurrPage.UPDATE;
                        END;


                    }

                }
                action("action26")
                {
                    CaptionML = ENU = 'I&Ncrease Sales Price', ESP = 'Modificar importes de Coste';
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    VAR
                    // CostAmountIncrease: Report 7207362;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataJobUnitForProduction);
                        // CLEAR(CostAmountIncrease);
                        // CostAmountIncrease.SETTABLEVIEW(DataJobUnitForProduction);
                        // CostAmountIncrease.SetBudget(BudgetInProgress);
                        // CostAmountIncrease.RUNMODAL;
                        CLEAR(DataJobUnitForProduction);
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action27")
                {
                    CaptionML = ESP = 'Imprimir recursos descompuesto';
                    Image = ResourceCosts;

                    trigger OnAction()
                    VAR
                    // ResourcesbyPiecework: Report 50005;
                    BEGIN
                        // ResourcesbyPiecework.PassParameters(rec."Job No.");
                        // ResourcesbyPiecework.RUNMODAL;
                    END;


                }

            }
            group("ActQuotes")
            {

                CaptionML = ENU = '&Actions', ESP = '&Acciones Estudio';
                Visible = VisibleQuotes;
                action("CopyBudgetFromOtherJob")
                {

                    CaptionML = ENU = '&Rec.COPY Budget From Other Job', ESP = '&Copiar Presupuesto de otra obra';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(JobBudgetCopy);
                        // JobBudgetCopy.ColletData(rec."Job No.", rec."Budget Filter", FALSE);
                        // JobBudgetCopy.RUNMODAL;
                    END;


                }
                action("GetCostDatabase")
                {

                    CaptionML = ENU = '&Rec.GET Cost Database', ESP = '&Traer preciario';
                    Image = InsertStartingFee;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(BringCostDatabase);
                        // BringCostDatabase.GatherDate(rec."Job No.", codeBudget);
                        // BringCostDatabase.RUNMODAL;
                    END;


                }
                action("CopyPieceworkAndBillOfItemsFromCostDatabase")
                {

                    CaptionML = ENU = 'Copy Piecework And Bill Of Items From Cost Database', ESP = 'Copiar UO y descompuestos desde preciarios';
                    Image = SplitChecks;

                    trigger OnAction()
                    VAR
                        BringPieceworktoTheJob: Page 7207584;
                    BEGIN
                        BringPieceworktoTheJob.ReceivedJob(rec."Job No.", Rec);
                        BringPieceworktoTheJob.RUNMODAL;
                        CLEAR(BringPieceworktoTheJob);
                    END;


                }
                action("Test")
                {

                    CaptionML = ENU = '&Test', ESP = 'Test';
                    Image = TestReport;

                    trigger OnAction()
                    VAR
                        CostPieceworkJobIdent: Codeunit 7207296;
                    BEGIN
                        //JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
                        CLEAR(CostPieceworkJobIdent);
                        CostPieceworkJobIdent.Process(rec."Job No.", rec."Budget Filter", 1);
                    END;


                }
                action("AssingUnitCertification")
                {

                    CaptionML = ENU = 'Assing Unit &Certification', ESP = 'Asignar Unid. &Certificacion';
                }
                action("CreateBudgetCertification")
                {

                    CaptionML = ENU = 'C&reate Budget Certification', ESP = 'C&rear presupuesto certificaci�n';
                    Image = TransferFunds;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETCURRENTKEY("Job No.", "Piecework Code");
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        // IF DataPieceworkForProduction.FINDSET THEN
                        // REPORT.RUN(REPORT::"Create Budget Cert. Piecework", TRUE, TRUE, DataPieceworkForProduction);
                    END;


                }
                action("AssingSaleToProdPrices")
                {

                    CaptionML = ENU = 'Assing Sale To Prod. Prices', ESP = 'Asignar Venta a Precios Prod.';
                    Visible = false;

                    trigger OnAction()
                    BEGIN
                        Job.RESET;
                        Job.SETCURRENTKEY("No.");
                        Job.SETRANGE("No.", rec."Job No.");
                        // IF Job.FINDFIRST THEN
                        // REPORT.RUN(REPORT::"Assign Sales to Production", TRUE, TRUE, Job);
                    END;


                }

            }
            group("group41")
            {
                CaptionML = ESP = 'Ver';
                // ActionContainerType =ActivityButtons ;
                group("group42")
                {
                    CaptionML = ENU = 'View', ESP = 'Ver';
                    Image = ViewPage;
                    action("VerDes")
                    {

                        CaptionML = ESP = 'Descompuestos';

                        trigger OnAction()
                        BEGIN
                            //Ver solo descompuestos
                            verDescompuestos := TRUE;
                            verMediciones := FALSE;
                            verTextos := FALSE;
                        END;


                    }
                    action("VerDesTex")
                    {

                        CaptionML = ESP = 'Descompuestos+Textos';

                        trigger OnAction()
                        BEGIN
                            //Ver descompuesto+textos
                            verDescompuestos := TRUE;
                            verMediciones := FALSE;
                            verTextos := TRUE;
                        END;


                    }
                    action("VerDesMed")
                    {

                        CaptionML = ESP = 'Descompuestos+Medicion';

                        trigger OnAction()
                        BEGIN
                            //Ver Descompuestos+Medicion
                            verDescompuestos := TRUE;
                            verMediciones := TRUE;
                            verTextos := FALSE;
                        END;


                    }
                    action("VerMedTex")
                    {

                        CaptionML = ESP = 'Medici�n+Textos';


                        trigger OnAction()
                        BEGIN
                            //Ver Medici�n+Textos
                            verDescompuestos := FALSE;
                            verMediciones := TRUE;
                            verTextos := TRUE;
                        END;


                    }

                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(SurveyABC_Promoted; SurveyABC)
                {
                }
                actionref(MarkStudiedDatapiecework_Promoted; MarkStudiedDatapiecework)
                {
                }
                actionref(SaveInitial_Promoted; SaveInitial)
                {
                }
                actionref(CalculateBudgetRevision_Promoted; CalculateBudgetRevision)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action27_Promoted; action27)
                {
                }
                actionref(CopyPieceworkAndBillOfItemsFromCostDatabase_Promoted; CopyPieceworkAndBillOfItemsFromCostDatabase)
                {
                }
            }
            group(Category_Report)
            {
                actionref(ExportDataToMicrosoftProyect_Promoted; ExportDataToMicrosoftProyect)
                {
                }
                actionref(ImportDataToMicrosoftProyect_Promoted; ImportDataToMicrosoftProyect)
                {
                }
                actionref(ProportionalDistributionCost_Promoted; ProportionalDistributionCost)
                {
                }
                actionref(MoveBudgetInTime_Promoted; MoveBudgetInTime)
                {
                }
                actionref(PieceworkScheduling_Promoted; PieceworkScheduling)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        //JAV 26/03/19: - Se calcula el importe del presupuesto, no el del �ltimo presupuesto, siempre debe existir si entramos en la pantalla
        //IF JobBudget.GET(JobInProgress,BudgetInProgress) THEN
        //  VarNameBudget := JobBudget."Budget Name";

        JobBudget.GET(JobInProgress, BudgetInProgress);
        JobBudget.CALCFIELDS("Budget Amount Cost Direct");
        //JAV 26/03/19 fin

        //JAV 18/03/19 - Se cambia el campo Job.status por el Job."Card type" en el OnOpenPage
        IF NOT Job.GET(rec."Job No.") THEN   //Tiene que existir si hemos llegado a esta p�gina, salvo que no haya presupuesto
            Job.INIT;
        VisibleQuotes := (Job."Card Type" = Job."Card Type"::Estudio);
        VisibleJobs := (Job."Card Type" = Job."Card Type"::"Proyecto operativo");

        //JAV 26/08/20: - Se informa el filtro del presupuesto inicial
        Rec.SETRANGE("Initial Budget Filter", Job."Initial Budget Piecework");

        //JAV 05/03/19: Ver si es editable
        bEditable := CurrPage.EDITABLE;

        //JAV 03/04/19: - Poner visibles las pages del pie seg�n la configuraci�n
        QuoBuildingSetup.GET;

        verDescompuestos := (QuoBuildingSetup."Ver en Costes Directos" IN
                               [QuoBuildingSetup."Ver en Costes Directos"::d,
                                QuoBuildingSetup."Ver en Costes Directos"::dm,
                                QuoBuildingSetup."Ver en Costes Directos"::dt,
                                QuoBuildingSetup."Ver en Costes Directos"::"mt"]);
        verTextos := (QuoBuildingSetup."Ver en Costes Directos" IN
                               [QuoBuildingSetup."Ver en Costes Directos"::dt,
                                QuoBuildingSetup."Ver en Costes Directos"::mt]);
        verMediciones := (QuoBuildingSetup."Ver en Costes Directos" IN
                               [QuoBuildingSetup."Ver en Costes Directos"::dm,
                                QuoBuildingSetup."Ver en Costes Directos"::mt]);
        seeHours := (QuoBuildingSetup."Hours control" <> QuoBuildingSetup."Hours control"::No);
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");

        //JAV 14/06/19: - Se a�aden totales de importe de producci�n ejecutada
        CalculateProduction;

        //JAV 26/08/20: - Ver medici�n inicial nueva o la anterior
        seeInitialNew := VisibleJobs AND (NOT QuoBuildingSetup."Use Old Initial Budget");
        seeInitialOld := VisibleJobs AND (QuoBuildingSetup."Use Old Initial Budget");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        Rec.VALIDATE("Production Unit", TRUE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CurrPage.PG_BillOfItems.PAGE.setEditable(rec."Account Type" = rec."Account Type"::Unit);
        funOnAfterGetRecord;
    END;



    var
        Job: Record 167;
        DataJobUnitForProduction: Record 7207386;
        ConvertToBudgetxCA: Codeunit 7207282;
        // JobBudgetCopy: Report 7207305;
        // BringCostDatabase: Report 7207277;
        // DistriProporBudgetCost: Report 7207355;
        JobBudget: Record 7207407;
        DataPieceworkForProduction2: Record 7207386;
        rJob: Record 167;
        QuoBuildingSetup: Record 7207278;
        QBPageSubscriber: Codeunit 7207349;
        BudgetInProgress: Code[20];
        VisibleQuotes: Boolean;
        VisibleJobs: Boolean;
        Text001: TextConst ENU = 'Bill of items and measure lines details cannot be defined in heading pieceworks', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        Text005: TextConst ENU = 'The process is over.', ESP = 'El proceso ha terminado.';
        Text008: TextConst ENU = 'The analytical budget will be calculated. Do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        JobOrVersion: Boolean;
        BudgetCostAmount: Boolean;
        PCostPrice: Boolean;
        ProductionBudgetAmount: Boolean;
        ProductionPerformedAmount: Boolean;
        TotalProductionMeasure: Boolean;
        PerformedSaleAmount: Boolean;
        PerformedCostAmount: Boolean;
        JobInProgress: Code[20];
        Text009: TextConst ENU = 'You must create the code of Piecework before assigning the data.', ESP = 'Debe de crear el c�digo de Unidad de obra antes de asignar los datos.';
        StudyABC: Boolean;
        VarNameBudget: Text[30];
        AmountBudgetCostPerformed: Boolean;
        AmountBudgetCostPending: Boolean;
        Text010: TextConst ENU = 'Preparing work unit planning data #1#########', ESP = 'Preparaci�n de los datos de planificaci�n de la unidad de obra #1#########';
        BudgetName: Text[30];
        codeBudget: Code[20];
        TotalAmountStudiedBudget: Decimal;
        StudiedPercentage: Decimal;
        DateEditable: Boolean;
        bEditable: Boolean;
        verDescompuestos: Boolean;
        verMediciones: Boolean;
        verTextos: Boolean;
        PrecioCosteReal: Decimal;
        MedicionPendiente: Decimal;
        ImportePendiente: Decimal;
        CantidadPendiente: Decimal;
        PrecioCosteMedio: Decimal;
        ImporteEsperado: Decimal;
        Diferencia: Decimal;
        aPrecioCosteReal: Decimal;
        aMedicionPendiente: Decimal;
        aImportePendiente: Decimal;
        aCantidadPendiente: Decimal;
        aPrecioCosteMedio: Decimal;
        aImporteEsperado: Decimal;
        aDiferencia: Decimal;
        ProducciónEjecutada: Decimal;
        ProducciónTotal: Decimal;
        PorcEjecutado: Decimal;
        CosteEjecutado: Decimal;
        InitialAmount: Decimal;
        InitialDiference: Decimal;
        seeInitialOld: Boolean;
        seeInitialNew: Boolean;
        stLine: Text;
        stLine2: Text;
        stLineType: Text;
        stMedicionPendiente: Text;
        stDiferencia: Text;
        stInitial1: Text;
        stInitial2: Text;
        stMeasureBudgPieceworkSol: Text;
        edMeasureBudgPieceworkSol: Boolean;
        seeHours: Boolean;
        seeAditionalCode: Boolean;

    procedure ShowPiecework();
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text001);

        DataJobUnitForProduction.RESET;
        DataJobUnitForProduction.FILTERGROUP(2);
        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
        DataJobUnitForProduction.SETRANGE("Account Type", DataJobUnitForProduction."Account Type"::Unit);
        DataJobUnitForProduction.SETRANGE("Production Unit", TRUE);
        DataJobUnitForProduction.SETRANGE(Type, DataJobUnitForProduction.Type::Piecework);
        DataJobUnitForProduction.FILTERGROUP(0);
        DataJobUnitForProduction.SETRANGE("Budget Filter", BudgetInProgress);
        DataJobUnitForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        if DataJobUnitForProduction.FINDFIRST then begin
            DataJobUnitForProduction.SETRANGE("Piecework Code");
            PAGE.RUNMODAL(PAGE::"Piecework Bill of Items Card", DataJobUnitForProduction);
        end;
    end;

    procedure ShowMeasureLinesPiecework();
    var
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text001);
        ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", BudgetInProgress, rec."Piecework Code");
    end;

    LOCAL procedure OnAfterValidaCodePiecewrk();
    begin
        CurrPage.UPDATE(TRUE);
    end;

    LOCAL procedure OnABudgetMeasurePieceworkSol();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    LOCAL procedure OnAfterBudgetProductionAmount();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    procedure ReceivedJob(PJob: Code[20]; Pbudget: Code[20]);
    begin
        JobInProgress := PJob;
        BudgetInProgress := Pbudget;
    end;

    LOCAL procedure CalculateTotalAmountStudiedBudget();
    var
        DataPieceworkForProduction3: Record 7207386;
    begin
        //QBV102>>
        CLEAR(TotalAmountStudiedBudget);

        //JAV 26/03/19: - Ya hemos leido Job al entrar en la p�gina, no leerlo de nuevo
        //if Rec."Job No."<>'' then begin
        //  rJob.GET(rec."Job No.");
        //  rJob.CALCFIELDS("Direct Cost Amount PieceWork");
        //end;
        //JAV fin

        DataPieceworkForProduction3.RESET;
        DataPieceworkForProduction3.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction3.SETRANGE("Account Type", DataPieceworkForProduction3."Account Type"::Unit);
        DataPieceworkForProduction3.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter")); //QB932
        DataPieceworkForProduction3.SETRANGE(Studied, TRUE);
        if DataPieceworkForProduction3.FINDFIRST then begin
            repeat
                //DataPieceworkForProduction3.CALCFIELDS("Amount Studied Budget");
                //TotalAmountStudiedBudget += DataPieceworkForProduction3."Amount Studied Budget";
                if (DataPieceworkForProduction3.Studied) then begin
                    DataPieceworkForProduction3.CALCFIELDS("Amount Cost Budget (JC)");
                    TotalAmountStudiedBudget += DataPieceworkForProduction3."Amount Cost Budget (JC)";
                end;
            until DataPieceworkForProduction3.NEXT = 0;
        end;

        //JAV 26/03/19: - El c�lculo no es sobre Job sino sobre el presupuesto en curso, y redondeamos el porcentaje a 2 decimales
        //if rJob."Direct Cost Amount PieceWork"<>0 then
        //  StudiedPercentage:=TotalAmountStudiedBudget/rJob."Direct Cost Amount PieceWork"*100;
        if JobBudget."Budget Amount Cost Direct" <> 0 then
            StudiedPercentage := ROUND(TotalAmountStudiedBudget / JobBudget."Budget Amount Cost Direct" * 100, 0.01);
        //JAV 26/03/19 fin

        //QBV102<<
    end;

    LOCAL procedure OnValidateType();
    begin
        //JAV 17/12/2018 Para las fechas
        DateEditable := (rec."Account Type" = rec."Account Type"::Unit);
        //JAV 17/12/2018 fin
    end;

    LOCAL procedure UpdateStudied();
    var
        DataPieceworkForProduction3: Record 7207386;
        DataCostByPiecework: Record 7207387;
    begin
        //JAV 20/03/19: - Esto ya no es necesario, los c�lculos se hacen al marcar o desmarcar
        /*{--------
        //QB4932

        if Rec."Job No."<>'' then begin
          rJob.GET(rec."Job No.");
        end;

        //Primero los de tipo Unidad

        //Por cada Unidad, miramos sus descompuestos.
        DataPieceworkForProduction3.RESET;
        DataPieceworkForProduction3.SETRANGE( "Job No.", rec. "Job No.");
        DataPieceworkForProduction3.SETRANGE("Account Type", DataPieceworkForProduction3."Account Type"::Unit);
        DataPieceworkForProduction3.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter")); //QB932
        if DataPieceworkForProduction3.FINDFIRST then begin
          repeat

            //Se reinica la marca a falso.
            DataPieceworkForProduction3.Studied := FALSE;
            DataPieceworkForProduction3.MODIFY;

            //Si todos los descompuestos estan estudiados, lo marcamos.
            DataCostByPiecework.RESET;
            DataCostByPiecework.SETRANGE("Job No.", DataPieceworkForProduction3."Job No.");
            DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction3."Piecework Code");
            DataCostByPiecework.SETRANGE("Cod. Budget", Rec.GETFILTER("Budget Filter"));
            DataCostByPiecework.SETRANGE(Studied, FALSE);
            if DataCostByPiecework.FINDFIRST then begin
              //Si encuentra un descompuesto no estudiado, se marca a falso.
              DataPieceworkForProduction3.MODIFY;
            end ELSE begin
              //Comprobamos que al menos exista un descompuesto.
              DataCostByPiecework.SETRANGE(Studied, TRUE);
              if DataCostByPiecework.FINDFIRST then begin
                //Si todos estan estudiados
                DataPieceworkForProduction3.Studied := TRUE;
                DataPieceworkForProduction3.MODIFY;
              end;
            end;

          until DataPieceworkForProduction3.NEXT=0;
        end;

        //Ahora las cabeceras. Las calculamos en base a sus "hijos"
        UpdateStudiedHeading;
        }*/
    end;

    LOCAL procedure UpdateStudiedHeading();
    var
        DataPieceworkForProduction2: Record 7207386;
        DataPieceworkForProduction3: Record 7207386;
        PieceworkFilter: Text;
    begin
        //JAV 20/03/19: - Esto ya no es necesario, los c�lculos se hacen al marcar o desmarcar
        /*{---------------------------------------------------------------------------------------

        //QB4932

        //Por cada Cabecera, miramos sus descompuestos.
        //Lo ordenamos inverso a la indentacio�n para que empiece por los mas "profundos".
        DataPieceworkForProduction3.RESET;
        DataPieceworkForProduction3.SETCURRENTKEY(Indentation);
        DataPieceworkForProduction3.ASCENDING(FALSE);

        DataPieceworkForProduction3.SETRANGE( "Job No.", rec. "Job No.");
        DataPieceworkForProduction3.SETRANGE("Account Type", DataPieceworkForProduction3."Account Type"::Heading);
        DataPieceworkForProduction3.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter")); //QB932
        if DataPieceworkForProduction3.FINDSET then begin
          repeat

            //JAV ++ 05/03/19: - Arreglar si no tiene sumatorio una de mayor para que no de error
            if DataPieceworkForProduction3.Totaling = '' then
              DataPieceworkForProduction3.VALIDATE(Totaling);
            //JAV --

            //Se reinica la marca a falso.
            DataPieceworkForProduction3.Studied := FALSE;
            DataPieceworkForProduction3.MODIFY;

            //Filtramos a sus "hijos"
            PieceworkFilter := '&<>' + DataPieceworkForProduction3."Piecework Code";
            PieceworkFilter := COPYSTR(DataPieceworkForProduction3.Totaling,1,20-STRLEN(PieceworkFilter)) + PieceworkFilter;

            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETCURRENTKEY("Account Type", "Piecework Code");
            DataPieceworkForProduction2.SETRANGE( "Job No.", rec. "Job No.");
            //DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Heading);
            DataPieceworkForProduction2.SETFILTER("Piecework Code", PieceworkFilter);
            DataPieceworkForProduction2.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter"));
            DataPieceworkForProduction2.SETRANGE(Studied, FALSE);
            if DataPieceworkForProduction2.FINDFIRST then begin
              //Si encuentra un "hijo" no estudiado, se marca a falso.
              DataPieceworkForProduction3.MODIFY;
            end ELSE begin
              //Comprobamos que al menos exista un "hijo".
              DataPieceworkForProduction2.SETRANGE(Studied, TRUE);
              if DataPieceworkForProduction2.FINDFIRST then begin
                //Si todos estan estudiados
                DataPieceworkForProduction3.Studied := TRUE;
                DataPieceworkForProduction3.MODIFY;
              end;
            end;

          until DataPieceworkForProduction3.NEXT=0;
        end;
        }*/
    end;

    LOCAL procedure CalculateProduction();
    var
        DataPieceworkForProduction4: Record 7207386;
    begin
        //JAV 14/06/19: - Se Calculan los totales de importe de producci�n ejecutada
        // Producci�nTotal := 0;
        // Producci�nEjecutada := 0;
        // PorcEjecutado := 0;
        // CosteEjecutado := 0;
        //
        // DataPieceworkForProduction4.RESET;
        // DataPieceworkForProduction4.SETRANGE( "Job No.", rec. "Job No.");
        // DataPieceworkForProduction4.SETRANGE("Account Type",DataPieceworkForProduction4."Account Type"::Unit);
        // DataPieceworkForProduction4.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter"));
        // if DataPieceworkForProduction4.FINDSET(FALSE) then begin
        //  repeat
        //    DataPieceworkForProduction4.CALCFIELDS("Measure Pending Budget", "Total Measurement Production", "Amount Cost Performed LCY");
        //    Producci�nTotal     += DataPieceworkForProduction4."Measure Pending Budget";
        //    Producci�nEjecutada += DataPieceworkForProduction4."Total Measurement Production";
        //    CosteEjecutado      += DataPieceworkForProduction4."Amount Cost Performed LCY";
        //  until DataPieceworkForProduction4.NEXT=0;
        // end;
        //
        // if (Producci�nTotal <> 0) then
        //    PorcEjecutado := ROUND(Producci�nEjecutada * 100 / Producci�nTotal, 0.01);

        JobBudget.GET(JobInProgress, BudgetInProgress);
        JobBudget.CALCFIELDS("Budget Amount Cost Direct");

        Job.SETFILTER("Budget Filter", rec.GETFILTER("Budget Filter"));
        Job.CALCFIELDS("Actual Production Amount", "Usage (Cost) (LCY)", "Production Budget Amount");

        JobBudget."Porcentaje Ejecutado" := 0;
        if Job."Production Budget Amount" <> 0 then
            JobBudget."Porcentaje Ejecutado" := Job."Actual Production Amount" / Job."Production Budget Amount" * 100;

        //coste directo ejecutado, coste directo esperado
        DataPieceworkForProduction4.RESET;
        DataPieceworkForProduction4.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction4.SETRANGE("Account Type", DataPieceworkForProduction4."Account Type"::Unit);
        DataPieceworkForProduction4.SETRANGE(Type, DataPieceworkForProduction4.Type::Piecework);
        //DataPieceworkForProduction4.SETFILTER("Piecework Code", Totaling);
        DataPieceworkForProduction4.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter"));
        if DataPieceworkForProduction4.FINDSET(FALSE) then begin
            repeat
                CalculateEstimatedOne(DataPieceworkForProduction4);
                JobBudget."Importe Directo Esperado" += aImporteEsperado;
                DataPieceworkForProduction4.CALCFIELDS("Amount Cost Performed (JC)");
                JobBudget."Coste Directo Ejecutado" += DataPieceworkForProduction4."Amount Cost Performed (JC)";
                JobBudget."Diferencia Directos Esperada" += (JobBudget."Importe Directo Esperado" - JobBudget."Coste Directo Ejecutado");

            //PrecioCosteMedio += aPrecioCosteMedio;
            //Diferencia += aDiferencia;
            until DataPieceworkForProduction4.NEXT = 0;
        end;
    end;

    LOCAL procedure CalculateEstimated();
    var
        DataPieceworkForProduction4: Record 7207386;
    begin
        if (rec."Account Type" = rec."Account Type"::Unit) then begin
            CalculateEstimatedOne(Rec);
            PrecioCosteReal := aPrecioCosteReal;
            MedicionPendiente := aMedicionPendiente;
            ImportePendiente := aImportePendiente;
            ImporteEsperado := aImporteEsperado;
            PrecioCosteMedio := aPrecioCosteMedio;
            Diferencia := aDiferencia;
        end ELSE begin
            PrecioCosteReal := 0;
            MedicionPendiente := 0;
            CantidadPendiente := 0;
            ImportePendiente := 0;
            ImporteEsperado := 0;
            PrecioCosteMedio := 0;
            Diferencia := 0;

            DataPieceworkForProduction4.RESET;
            DataPieceworkForProduction4.SETRANGE("Job No.", rec."Job No.");
            DataPieceworkForProduction4.SETRANGE("Account Type", DataPieceworkForProduction4."Account Type"::Unit);
            DataPieceworkForProduction4.SETFILTER("Piecework Code", rec.Totaling);
            DataPieceworkForProduction4.SETRANGE("Budget Filter", Rec.GETFILTER("Budget Filter"));
            if DataPieceworkForProduction4.FINDSET(FALSE) then begin
                repeat
                    CalculateEstimatedOne(DataPieceworkForProduction4);
                    PrecioCosteReal += aPrecioCosteReal;
                    MedicionPendiente += aMedicionPendiente;
                    ImportePendiente += aImportePendiente;
                    ImporteEsperado += aImporteEsperado;
                    //PrecioCosteMedio += aPrecioCosteMedio;
                    Diferencia += aDiferencia;
                until DataPieceworkForProduction4.NEXT = 0;
                if (aCantidadPendiente <> 0) then
                    PrecioCosteMedio := ROUND(aImporteEsperado / aCantidadPendiente, 0.01);
            end;
        end;

        //JAV 11/10/19: - Redondeo los importes calculados y marco en tres colores
        Diferencia := ROUND(Diferencia, 0.01);
        MedicionPendiente := ROUND(MedicionPendiente, 0.01);
    end;

    LOCAL procedure CalculateEstimatedOne(pDataPieceworkForProduction: Record 7207386);
    begin
        //JAV 14/06/19: - Calculo de precios
        //Lista de campos calculados de la tabla pDataPieceworkForProduction
        //"Measure Budg. Piecework Sol"   : Es la medici�n total de la obra se puede filtrar por fecha de planificaci�n
        //"Actual Cost LCY"               : Es el coste incurrido real se puede filtrar por fecha
        //rec."Measure Pending Budget"        : Es la medici�n pendiente del reestudio actual. hasta que no se reestime se mantiene.
        //"Aver. Cost Price Pend. Budget" : Es el coste de la partida, que se aplicar� para la medici�n pendiente cuando se reestime
        //"Amount Cost Budget LCY"        : Es el coste previsto total para la partida completa. Ser� la suma de el coste incurrido + (medici�n pendiente * "aver. cost price pend. budget").
        //                                  Siempre despu�s de reestimar
        //rec."Amount Production Budget"      : Es el importe de producci�n total de la partida, si se trabaja sin separaci�n ser� igual a la venta total de la partida en contrato.
        //                                  Si hay separaci�n ser� la venta de las partidas relacionadas
        //rec."Total Measurement Production"  : Es la medici�n de producci�n ejecutada

        aPrecioCosteReal := 0;
        aMedicionPendiente := 0;
        aCantidadPendiente := 0;
        aImportePendiente := 0;
        aImporteEsperado := 0;
        aPrecioCosteMedio := 0;
        aDiferencia := 0;

        pDataPieceworkForProduction.SETRANGE("Budget Filter", BudgetInProgress);
        pDataPieceworkForProduction.SETFILTER("Filter Date", '..%1', JobBudget."Budget Date"); //JAV 18/02/21: - QB 1.08.11 Filtrar los importes por la fecha del presupuesto

        if (pDataPieceworkForProduction.Type = pDataPieceworkForProduction.Type::Piecework) then begin
            pDataPieceworkForProduction.CALCFIELDS("Total Measurement Production", "Amount Cost Performed (JC)", "Total Measurement Production", "Measure Budg. Piecework Sol",
                                                   "Aver. Cost Price Pend. Budget", "Amount Cost Budget (JC)");

            if (pDataPieceworkForProduction."Total Measurement Production" <> 0) then
                aPrecioCosteReal := ROUND(pDataPieceworkForProduction."Amount Cost Performed (JC)" / pDataPieceworkForProduction."Total Measurement Production", 0.01);
            aMedicionPendiente := pDataPieceworkForProduction."Measure Budg. Piecework Sol" - pDataPieceworkForProduction."Total Measurement Production";

            if aMedicionPendiente > 0 then
                aImportePendiente := aMedicionPendiente * pDataPieceworkForProduction."Aver. Cost Price Pend. Budget";
            aImporteEsperado := pDataPieceworkForProduction."Amount Cost Performed (JC)" + aImportePendiente;
            if (pDataPieceworkForProduction."Measure Budg. Piecework Sol" <> 0) then
                aPrecioCosteMedio := ROUND(aImporteEsperado / pDataPieceworkForProduction."Measure Budg. Piecework Sol", 0.01);
            aDiferencia := aImporteEsperado - pDataPieceworkForProduction."Amount Cost Budget (JC)";
            aCantidadPendiente := pDataPieceworkForProduction."Measure Budg. Piecework Sol";
        end;
    end;

    LOCAL procedure funOnAfterGetRecord();
    var
        DataPieceworkForProduction5: Record 7207386;
    begin
        // JAV 17/12/2018 Para las fechas
        OnValidateType;
        // JAV 17/12/2018 fin

        //JAV 14/06/19: - Calculo de precios
        CalculateEstimated;

        //jmma 18/10/19 desactivado por lentitud en la carga CalculateProduction;
        //CalculateProduction;

        //QBV102>>
        CalculateTotalAmountStudiedBudget;

        //Estilos de campos
        stLine := rec.GetStyle('');
        stLine2 := rec.GetStyle('Attention');
        stLineType := rec.GetStyle('StrongAccent');

        CASE TRUE OF
            (MedicionPendiente > 0):
                stMedicionPendiente := rec.GetStyle('Favorable');
            (MedicionPendiente = 0):
                stMedicionPendiente := rec.GetStyle('Standard');
            (MedicionPendiente < 0):
                stMedicionPendiente := rec.GetStyle('Unfavorable');
        end;

        CASE TRUE OF
            (Diferencia < 0):
                stDiferencia := rec.GetStyle('Favorable');
            (Diferencia = 0):
                stDiferencia := rec.GetStyle('Standard');
            (Diferencia > 0):
                stDiferencia := rec.GetStyle('Unfavorable');
        end;

        Rec.CALCFIELDS("No. Medition detail Cost");
        if (rec."No. Medition detail Cost" <> 0) then
            stMeasureBudgPieceworkSol := rec.GetStyle('Subordinate')
        ELSE
            stMeasureBudgPieceworkSol := rec.GetStyle('StandardAccent');

        Rec.CALCFIELDS("No. Medition detail Cost");
        edMeasureBudgPieceworkSol := (rec."No. Medition detail Cost" = 0);

        //Presupuesto inicial
        if (QuoBuildingSetup."Use Old Initial Budget") then begin
            if (rec."Initial Amount" = 0) then
                InitialDiference := 0
            ELSE
                InitialDiference := rec."Initial Amount" - rec."Amount Production Budget";
        end ELSE begin
            //-Q19520 AML 24/05/23 Diferenciar el calculo entre UO y Mayor
            //Rec.CALCFIELDS("Initial Budget Measure", "Initial Budget Price");
            //InitialAmount := ROUND(rec."Initial Budget Measure" * rec."Initial Budget Price", 0.01);
            //InitialDiference := InitialAmount - rec."Amount Cost Budget (JC)";
            if rec."Account Type" = rec."Account Type"::Unit then begin
                Rec.CALCFIELDS("Initial Budget Measure", "Initial Budget Price", "Amount Cost Budget (JC)");
                InitialAmount := ROUND(rec."Initial Budget Measure" * rec."Initial Budget Price", 0.01);
                InitialDiference := InitialAmount - rec."Amount Cost Budget (JC)";
            end
            ELSE begin
                InitialAmount := 0;
                InitialDiference := 0;
                DataPieceworkForProduction5.SETRANGE("Job No.", rec."Job No.");
                DataPieceworkForProduction5.SETFILTER("Piecework Code", rec.Totaling);
                DataPieceworkForProduction5.SETRANGE("Initial Budget Filter", Job."Initial Budget Piecework");

                DataPieceworkForProduction5.SETRANGE("Account Type", DataPieceworkForProduction5."Account Type"::Unit);
                if DataPieceworkForProduction5.FINDSET then
                    repeat
                        DataPieceworkForProduction5.SETRANGE("Budget Filter", rec.GETFILTER("Budget Filter"));
                        DataPieceworkForProduction5.CALCFIELDS("Initial Budget Measure", "Initial Budget Price", "Amount Cost Budget (JC)");
                        InitialAmount += ROUND(DataPieceworkForProduction5."Initial Budget Measure" * DataPieceworkForProduction5."Initial Budget Price", 0.01);
                    //InitialDiference += InitialAmount - DataPieceworkForProduction5.rec."Amount Cost Budget (JC)";

                    until DataPieceworkForProduction5.NEXT = 0;
                Rec.CALCFIELDS("Initial Budget Measure", "Initial Budget Price", "Amount Cost Budget (JC)");
                InitialDiference := InitialAmount - rec."Amount Cost Budget (JC)";
                //+Q19520
            end;
        end;

        stInitial1 := rec.GetStyle('Ambiguous');
        CASE TRUE OF
            (InitialDiference > 0):
                stInitial2 := rec.GetStyle('Favorable');
            (InitialDiference = 0):
                stInitial2 := stInitial1;
            (InitialDiference < 0):
                stInitial2 := rec.GetStyle('Unfavorable');
        end;

        //JAV 27/02/21: - QB 1.08.19 No poner K planificada en unidades de mayor
        if (rec."Account Type" = rec."Account Type"::Heading) then
            rec."Planned K" := 0;
        //PAT QB19327 Eliminar valor columna en lineas.
        if rec."Account Type" = rec."Account Type"::Heading then
            rec."Measure Pending Budget" := 0;
        //PAT 19327
    end;

    // begin
    /*{
      NZG  16/01/18: - QBV102 A�adidos los campos rec."Studied" y "Amount Studied Budget"
                       QB4932 Nueva accion
      PEL          : - QB4932 Filtrar por budget
      PEL  14/02/19: - QB4932 Actualizar el campo estudiado al abrir la p�gina
      JAV  11/12/18: - Se a�aden los campos de fechas, editables seg�n el campo de tipo de movimiento: solo para unidades.
                     - Se cambia la funci�n "SchedulePiecework" para que no lance al final la page, ahora se llama desde los botones "Planificaci�n de UO" y "Ver datos MSP"
      JAV  05/03/19: - Arreglar si no tiene sumatorio una de mayor para que no de error
                     - A�ado columnas de "Margen" y "% Margen"
                     - Si no es editable, desactivar casi todo
                     - Se a�ade el panel de textos, pero no visible por defecto
      PGM  19/03/19: - QB4932 A�adido el Rec.COPYFILTER para poder llevar el filtro a la tabla JAV  20/03/19: - Se corrige un error en la llamada a las l�neas de medici�n
                     - Se mejora el c�lculo del importe estudiado, se hace editable el campo "Estudiado" y se desactivan las funciones UpdateStudied y CalculateTotalAmountStudiedBudget
      JAV  26/03/19: - Ya hemos leido Job al entrar en la p�gina, no leerlo de nuevo
                     - Se eliminan las variables globales rJob, VarNameBudget y NameMarkStudied que no se usan
                     - Se calcula el importe del presupuesto, no el del �ltimo presupuesto, se cambia el c�lculo del porcentaje a este campo
                     - Se cambian los datos a presentar en la pantalla en el primer grupo de campos y se a�ade el c�digo del presupuesto y su nombre
      JAV  02/04/19: - Se aumenta la indentaci�n de las pages de datos para que se presenten una junto a la otra, ahorrando espacio
      JAV  03/04/19: - Nuevo par�metro en conf.QB con la pantallas se ver�n por defecto en la page de costes directos
                     - Se reordenan las acciones para que tengan mas sentido su distribuci�n
                     - Se promueven las acciones de recalculo y "Planificaci�n de UO" al grupo de reports, y se cambia el nombre del grupo a Calculos
                     - Se hacen no visibles los botones
                       - "Ver datos MSP" que de momento no funciona
                       - "Copiar UO y descompuestos desde preciarios" que no hace lo que dice
                       - "Copiar descompuesto de UO desde proyectos" que no hace lo que dice
                       - "Cuentas de activaci�n" que no hace nada
      JAV  14/06/19: - Se cambian orden de algunas columnas que se ponen visibles, y se a�anden precio de coste real, precio medio de coste, importe previsto y diferencia
                     - Se a�aden totales de importe de producci�n ejecutada
      JAV  26/09/19: - Se ocultan las columnas de mediciones que no tienen mucho sentido real, solo se calculan en cada l�nea para saber el previsto y la desviaci�n
      JAV  05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
      JAV  11/10/19: - Redondeo los importes calculados y marco en tres colores el campo de diferencia
      QMD  18/09/19: - VSTS 7528   GAP018. Coeficiente de paso - A�adir campo K Passing
      JAV  18/10/19: - Se cambian algunas colunnas de orden y visibilidad
      JMMA 18/10/19: - Desactivado por lentitud en la carga CalculateProduction;
      JAV  22/06/21: - QB 1.09.02 Se pasa a una funci�n presentar la pantalla de planificaci�n
      JAV 10/04/22:  - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
      JAV 12/04/22:  - QB 1.10.35 Se eliminan los campos DataPieceworkForProduction.Activable y JobLedgEntry.Activate porque no se usan para nada
      PAT 20/04/23:  - QB 19327 Eliminar valor columna en lineas.
      AML 25/04/23   - QB19520 Diferencio PPto Inicial vs Actual
    }*///end
}







