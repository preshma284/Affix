page 7207535 "Cost Unit Data"
{
    CaptionML = ENU = 'Cost Unit Data', ESP = 'Datos unidad de coste';
    SourceTable = 7207386;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = FILTER("Cost Unit"));
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            group("group27")
            {

                group("group28")
                {

                    field("Indirect Cost Budget"; JobBudget."Budget Amount Cost Indirect")
                    {

                        CaptionML = ENU = 'Indirect Cost Budget', ESP = 'Importe Presupuesto';
                        Editable = FALSE;
                    }

                }
                group("group30")
                {

                    field("JobBudget.Cod. Budget + ' - ' + JobBudget.Budget Name"; JobBudget."Cod. Budget" + ' - ' + JobBudget."Budget Name")
                    {

                        ShowCaption = false;
                    }

                }

            }
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code", Description;
                ShowAsTree = true;
                FreezeColumn = "Piecework Code";
                field("Piecework Code"; rec."Piecework Code")
                {

                    StyleExpr = stLine;
                }
                field("Code Piecework PRESTO"; rec."Code Piecework PRESTO")
                {

                    StyleExpr = stLine;
                }
                field("Additional Text Code"; rec."Additional Text Code")
                {

                    Visible = seeAditionalCode;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stLine;
                }
                field("Subtype Cost"; rec."Subtype Cost")
                {

                    StyleExpr = stLine;
                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = stLineType;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = FALSE;
                    StyleExpr = stLine;
                }
                field("Allocation Terms"; rec."Allocation Terms")
                {

                    StyleExpr = stLine;
                }
                field("Type Unit Cost"; rec."Type Unit Cost")
                {

                    StyleExpr = stLine;
                }
                field("Over JV Production"; rec."Over JV Production")
                {

                    Editable = isUTE;
                }
                field("% Expense Cost"; rec."% Expense Cost")
                {

                    Editable = ExpensesCostEditable;
                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                field("% Expense Cost Amount Base"; rec."% Expense Cost Amount Base")
                {

                    BlankZero = true;

                    ; trigger OnLookup(var Text: Text): Boolean
                    VAR
                        ForecastDataAmountPiecework: Record 7207392;
                        PieceworkAmountPlanning: Page 7207511;
                    BEGIN
                        //Mostrar los registros de base para el c�lculo de ingresos
                        ForecastDataAmountPiecework.RESET;
                        ForecastDataAmountPiecework.SETRANGE("Job No.", rec."Job No.");
                        ForecastDataAmountPiecework.SETRANGE("Unit Type", ForecastDataAmountPiecework."Unit Type"::"Job Unit");
                        IF rec."Allocation Terms" = rec."Allocation Terms"::"% on Production" THEN
                            ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Incomes);
                        IF rec."Allocation Terms" = rec."Allocation Terms"::"% on Direct Costs" THEN
                            ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                        IF (Rec.GETFILTER("Budget Filter") <> '') THEN
                            ForecastDataAmountPiecework.SETRANGE("Cod. Budget", rec.GETFILTER("Budget Filter"))
                        ELSE
                            ForecastDataAmountPiecework.SETRANGE("Cod. Budget", '');

                        //++ForecastDataAmountPiecework.SETRANGE(Performed,FALSE);

                        CLEAR(PieceworkAmountPlanning);
                        PieceworkAmountPlanning.SETTABLEVIEW(ForecastDataAmountPiecework);
                        PieceworkAmountPlanning.RUNMODAL;
                    END;


                }
                field("Cost Amount Base"; rec."Cost Amount Base")
                {


                    ; trigger OnValidate()
                    BEGIN
                        //-Q18150
                        Rec.VALIDATE("Measure Budg. Piecework Sol", rec."Cost Amount Base");
                    END;


                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    StyleExpr = stLine;
                }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    Editable = false;

                    ; trigger OnValidate()
                    VAR
                        Addition: Decimal;
                    BEGIN
                        //JAV 22/05/22: - QB 1.10.44 Unificar los registros en uno solo con fecha de inicio de la obra para que calcule correctamente
                        Rec.CALCFIELDS("Measure Budg. Piecework Sol");

                        IF (Rec."Measure Budg. Piecework Sol" <> xRec."Measure Budg. Piecework Sol") THEN BEGIN
                            IF NOT Job.GET(rec."Job No.") THEN
                                Job.INIT;

                            ExpectedTimeUnitData.RESET;
                            ExpectedTimeUnitData.SETRANGE("Job No.", Rec."Job No.");
                            ExpectedTimeUnitData.SETRANGE("Piecework Code", Rec."Piecework Code");
                            IF (Rec.GETFILTER("Budget Filter") <> '') THEN
                                ExpectedTimeUnitData.SETRANGE("Budget Code", rec.GETFILTER("Budget Filter"))
                            ELSE
                                ExpectedTimeUnitData.SETRANGE("Budget Code", '');
                            FirstReg := TRUE;
                            //-Q18150 Calculamos el total que hay para agruparlo.
                            Addition := 0;
                            ExpectedTimeUnitData.CALCSUMS("Expected Measured Amount");
                            Addition := ExpectedTimeUnitData."Expected Measured Amount";
                            //+Q18150
                            IF (ExpectedTimeUnitData.FINDSET) THEN
                                REPEAT
                                    IF (FirstReg) THEN BEGIN
                                        ExpectedTimeUnitData."Expected Date" := Job."Starting Date";
                                        //-Q18150
                                        //ExpectedTimeUnitData."Expected Measured Amount" := Rec."Measure Budg. Piecework Sol";
                                        ExpectedTimeUnitData."Expected Measured Amount" := Addition;
                                        //+Q18150
                                        ExpectedTimeUnitData.MODIFY(TRUE);
                                        FirstReg := FALSE;
                                    END ELSE
                                        ExpectedTimeUnitData.DELETE;
                                UNTIL (ExpectedTimeUnitData.NEXT = 0);

                            //JAV 18/05/22: - QB 1.10.42 Si cambiamos el importe, calculamos la unidad de obra
                            Rec.CalculatePiecework;
                        END;

                        CurrPage.UPDATE(FALSE);
                    END;


                }
                field("Measure Pending Budget"; rec."Measure Pending Budget")
                {

                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget"; rec."Amount Cost Budget")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    StyleExpr = stLine;
                }
                field("Planned Expense"; rec."Planned Expense")
                {

                    StyleExpr = stLine;
                }
                field("Periodic Cost"; rec."Periodic Cost")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Performed (LCY)"; rec."Amount Cost Performed (LCY)")
                {

                    StyleExpr = stLine;
                }
                field("Amount Cost Performed (JC)"; rec."Amount Cost Performed (JC)")
                {

                    StyleExpr = stLine;
                }
                field("Production Unit"; rec."Production Unit")
                {

                    StyleExpr = stLine;
                }
                field("Date Rec.INIT"; rec."Date INIT")
                {

                }
                field("Date end"; rec."Date end")
                {

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
                    StyleExpr = stLine

  ;
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
                CaptionML = ENU = 'Piecework', ESP = '&Unidades obra';
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
                action("action2")
                {
                    CaptionML = ENU = 'Extended Text', ESP = '&Textos adicionales';
                    RunObject = Page 7206929;
                    RunPageView = SORTING("Table", "Key1", "Key2");
                    RunPageLink = "Table" = CONST("Job"), "Key1" = FIELD("Job No."), "Key2" = FIELD("Piecework Code");
                    Image = AdjustItemCost;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Piecework"), "No." = FIELD("Unique Code");
                    Image = Note;
                }
                separator("separator4")
                {

                }
                action("action5")
                {
                    CaptionML = ENU = '&PIecework Planning', ESP = '&Planificaci�n de UO';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    BEGIN
                        //-Q19564 30/05/23 AML Se modifica la llamada y se pone similara a los costes directos porque esto no funciona
                        /////////////////PlanningUnitCost;
                        QBPageSubscriber.SeeSchedulePieceworks(rec."Job No.", CurrentBudget, FALSE);
                        //+Q19564
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Bill of Item Piecework', ESP = '&Descompuesto UO';
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        ShowUnitCost;
                    END;


                }
                separator("separator7")
                {

                }
                action("action8")
                {
                    CaptionML = ENU = 'Data E&xport Microsoft Proyect', ESP = 'E&xportar datos a Microsoft Proyect';
                    Visible = FALSE;
                    Image = Export;

                    trigger OnAction()
                    VAR
                    // ExportBudgetToMSP: Report 7207382;
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::"Cost Unit");
                        // ExportBudgetToMSP.PassParameters(CurrentBudget);
                        // ExportBudgetToMSP.SETTABLEVIEW(DataPieceworkForProduction);
                        // ExportBudgetToMSP.RUNMODAL;
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = 'Data Import &Microsoft Poyect', ESP = 'Importar datos a &Microsoft Proyect';
                    Visible = FALSE;
                    Image = Import;

                    trigger OnAction()
                    VAR
                        Job: Record 167;
                    // ImportBudgetToMSP: Report 7207383;
                    BEGIN
                        Job.RESET;
                        Job.SETRANGE("No.", rec."Job No.");
                        // ImportBudgetToMSP.PassParameters(CurrentBudget);
                        // ImportBudgetToMSP.SETTABLEVIEW(Job);
                        // ImportBudgetToMSP.RUNMODAL;
                    END;


                }
                action("action10")
                {
                    CaptionML = ENU = 'Data View MSP', ESP = 'Ver dat&os MSP';
                }
                separator("separator11")
                {

                }
                action("action12")
                {
                    CaptionML = ENU = 'Activation Accounts', ESP = '&Cuentas de activaci�n';
                }

            }
            group("group15")
            {
                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("action13")
                {
                    CaptionML = ENU = 'Budget Review Calculate', ESP = 'Calcular revision ppto.';
                    Image = CalculatePlan;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        LJob: Record 167;
                        LJobBudget: Record 7207407;
                    BEGIN
                        CLEAR(RateBudgetsbyPiecework);
                        LJob.GET(rec."Job No.");
                        IF NOT LJobBudget.GET(rec."Job No.", CurrentBudget) THEN BEGIN
                            CLEAR(LJobBudget);
                            LJobBudget."Job No." := LJob."No.";
                            LJobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(LJob, LJobBudget);
                    END;


                }
                action("action14")
                {
                    CaptionML = ENU = 'Analytic Budget &Calculate', ESP = '&Calcular pto. anal�tico';
                    Image = CalculateConsumption;

                    trigger OnAction()
                    VAR
                        ConvertToBudgetxCA: Codeunit 7207282;
                    BEGIN
                        CLEAR(ConvertToBudgetxCA);
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            IF Job.GET(rec."Job No.") THEN BEGIN
                                IF (Job."Job Type" = Job."Job Type"::Operative) AND
                                   (Job.Status = Job.Status::Planning) AND (Job."Original Quote Code" <> '') THEN
                                    Version := TRUE
                                ELSE
                                    Version := FALSE;
                            END;
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                            DataPieceworkForProduction.SETRANGE("Budget Filter", CurrentBudget);
                            IF DataPieceworkForProduction.FINDSET THEN BEGIN
                                ConvertToBudgetxCA.PassBudget(CurrentBudget);
                                ConvertToBudgetxCA.SetCalledSinceReestimation(FALSE, '');
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, Version, rec."Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }
                separator("separator15")
                {

                }
                action("action16")
                {
                    CaptionML = ENU = 'Cost Distribut&e', ESP = 'R&epartir coste';
                    Image = SuggestVendorPayments;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", CurrentBudget);
                        // CLEAR(DistriProporBudgetCost);

                        //JAV 18/03/19: Pasamos al proceso de reparto por fechas las fechas de inicio y fin del proyecto
                        Job.GET(rec."Job No.");
                        //DistriProporBudgetCost.Fechas(Job."Starting Date", Job."Ending Date");
                        // DistriProporBudgetCost.setJob(rec."Job No.");
                        //JAV 18/03/19 fin

                        // DistriProporBudgetCost.SETTABLEVIEW(DataPieceworkForProduction2);
                        // DistriProporBudgetCost.RUNMODAL;
                    END;


                }
                action("action17")
                {
                    CaptionML = ENU = 'Move Budget Over Time', ESP = '&Mover presupuesto en el tiempo';
                    Image = MachineCenterLoad;

                    trigger OnAction()
                    VAR
                    // MoveCostsBudget: Report 7207356;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", CurrentBudget);
                        // CLEAR(MoveCostsBudget);
                        // MoveCostsBudget.SETTABLEVIEW(DataPieceworkForProduction2);
                        // MoveCostsBudget.RUNMODAL;
                    END;


                }
                separator("separator18")
                {

                }
                action("action19")
                {
                    CaptionML = ENU = 'Indirect Expenses Plan', ESP = 'Planificar gastos indirectos';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(CostUnitPeriodify);
                        // CostUnitPeriodify.GetData(rec."Piecework Code", rec."Job No.", CurrentBudget);
                        // CostUnitPeriodify.RUNMODAL;
                    END;


                }
                action("action20")
                {
                    CaptionML = ENU = 'Indirect Amortization Plan', ESP = 'Planificar amortizaci�n indirectos';
                    Image = Replan;

                    trigger OnAction()
                    BEGIN
                        //Gestion de costes indirectos periodificables
                        IF rec."Type Unit Cost" = rec."Type Unit Cost"::External THEN BEGIN
                            EXIT;
                        END;
                        IF (rec."Type Unit Cost" = rec."Type Unit Cost"::Internal) AND (NOT rec."Periodic Cost") THEN BEGIN
                            EXIT;
                        END;

                        rec.AmountPlan;
                    END;


                }
                action("action21")
                {
                    CaptionML = ESP = 'Regularizar indirectos';
                    Image = CalculateCost;

                    trigger OnAction()
                    VAR
                        QBPageSubscriber: Codeunit 7207349;
                    BEGIN
                        //JAV 22/03/19: - Nueva acci�n para repartir los gastos generales
                        QBPageSubscriber.RegularizarGastosGenerales(Rec."Job No.");
                    END;


                }
                action("action22")
                {
                    CaptionML = ENU = 'Indirect Amortization Plan', ESP = 'Borrar datos costes';
                    Image = DeleteExpiredComponents;


                    trigger OnAction()
                    VAR
                        ExpectedTimeUnitData: Record 7207388;
                        ForecastDataAmountPiecework: Record 7207392;
                    BEGIN
                        //JAV 29/06/19: - Eliminar datos para el c�lculo correcto del coste
                        IF (rec."Account Type" = rec."Account Type"::Heading) THEN
                            ERROR(Text000);
                        IF (rec."Allocation Terms" <> rec."Allocation Terms"::"Fixed Amount") THEN
                            ERROR(Text001);

                        Rec.VALIDATE("Measure Pending Budget", 0);

                        ExpectedTimeUnitData.RESET;
                        ExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
                        ExpectedTimeUnitData.SETRANGE("Budget Code", CurrentBudget);
                        ExpectedTimeUnitData.SETRANGE("Piecework Code", rec."Piecework Code");
                        ExpectedTimeUnitData.DELETEALL;

                        ForecastDataAmountPiecework.SETRANGE("Job No.", rec."Job No.");
                        ForecastDataAmountPiecework.SETRANGE("Cod. Budget", CurrentBudget);
                        ForecastDataAmountPiecework.SETRANGE("Piecework Code", rec."Piecework Code");
                        ForecastDataAmountPiecework.DELETEALL;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
                actionref(action17_Promoted; action17)
                {
                }
                actionref(action19_Promoted; action19)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action22_Promoted; action22)
                {
                }
            }
        }
    }



    trigger OnInit()
    BEGIN
        MeasureBudgetPendingEditable := TRUE;
        ExpensesCostEditable := TRUE;
    END;

    trigger OnOpenPage()
    BEGIN
        //JAV 26/03/19: - Se lee el presupuesto en curso
        JobBudget.GET(CurrentJob, CurrentBudget);
        JobBudget.CALCFIELDS("Budget Amount Cost Indirect");
        //JAV 26/03/19 fin

        //Q2814 >>
        /*{IF JobBudget.GET(CurrentJob,CurrentBudget) THEN
          IF JobBudget."Budget Name" <> '' THEN
            NameBudget := JobBudget."Budget Name"
          ELSE
            NameBudget := JobBudget."Cod. Budget";}*/

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", Rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::"Cost Unit");
        IF DataPieceworkForProduction.FINDSET THEN BEGIN
            REPEAT
                DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                TotalBudget += DataPieceworkForProduction."Amount Cost Budget (JC)";
            UNTIL DataPieceworkForProduction.NEXT = 0;
        END;
        //Q2814 <<

        QuoBuildingSetup.GET();
        seeAditionalCode := (QuoBuildingSetup."Use Aditional Code");
        seeHours := (QuoBuildingSetup."Hours control" <> QuoBuildingSetup."Hours control"::No);

        //JAV 05/03/19: Ver si es editable
        bEditable := CurrPage.EDITABLE;

        //JAV 13/10/21: - QB 1.09.21 Si es UTE hacer editbales campos
        IF NOT Job.GET(rec."Job No.") THEN
            Job.INIT;

        isUTE := (Job."Company UTE" <> '');
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        //JAV 12/03/19: - Se quita restricci�n de borrado pues ya lo hace solo el est�ndar
        //IF (rec."Account Type" = rec."Account Type"::Heading) AND (CurrentExpansionStatus = 0) THEN
        //  ERROR(Text011);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        xRec := Rec;
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
        SetEditable;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        JobBudget: Record 7207407;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        DataPieceworkForProduction2: Record 7207386;
        ExpectedTimeUnitData: Record 7207388;
        // CostUnitPeriodify: Report 7207345;
        // DistriProporBudgetCost: Report 7207355;
        MeasureBudgetPendingEditable: Boolean;
        ExpensesCostEditable: Boolean;
        CurrentJob: Code[20];
        CurrentBudget: Code[20];
        NameBudget: Text[30];
        DescripcionIndent: Integer;
        CurrentExpansionStatus: Integer;
        Text000: TextConst ESP = 'Solo para unidades';
        Text001: TextConst ESP = 'Solo para importe fijo';
        Text005: TextConst ENU = 'The process is over.', ESP = 'El proceso ha terminado.';
        PieceworkCodeEmphasize: Boolean;
        Identation: Integer;
        DescriptionEmphasize: Boolean;
        CostUnitTypeEmphasize: Boolean;
        PriceCostMeasureBudgetPendingEmphasize: Boolean;
        Text008: TextConst ENU = 'The analytical budget will be calculated. Do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        Version: Boolean;
        Text010: TextConst ENU = 'You can not define bill of item or plaificar in units of job of heading', ESP = 'No se puede definir descompuesto ni plaificar en unidades de obra de mayor';
        Window: Dialog;
        Text011: TextConst ENU = 'You can not Rec.DELETE a larger drive if it is not deployed.', ESP = 'No se puede borrar una unidad de mayor si no esta desplegada.';
        Text012: TextConst ENU = 'Preparing Planning Data Cost Unit # 1 #########', ESP = 'Preparando datos de planificaci�n unidad de coste #1#########';
        Text013: TextConst ENU = 'Does not have cost units that can be planned.', ESP = 'No tiene unidades de coste planificables.';
        TotalBudget: Decimal;
        stLine: Text;
        stLineType: Text;
        seeHours: Boolean;
        seeAditionalCode: Boolean;
        bEditable: Boolean;
        isUTE: Boolean;
        edMed: Boolean;
        FirstReg: Boolean;
        QBPageSubscriber: Codeunit 7207349;

    procedure PlanningUnitCost();
    var
        TMPExpectedTimeUnitData: Record 7207389;
        ExpectedTimeUnitData: Record 7207388;
        DataPieceworkForProduction: Record 7207386;
    begin
        TMPExpectedTimeUnitData.RESET;
        TMPExpectedTimeUnitData.SETCURRENTKEY("Job No.");
        TMPExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
        TMPExpectedTimeUnitData.DELETEALL;

        Window.OPEN(Text012);
        ExpectedTimeUnitData.SETCURRENTKEY(ExpectedTimeUnitData."Job No.", ExpectedTimeUnitData."Piecework Code");
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Budget Filter", CurrentBudget);
        DataPieceworkForProduction.SETRANGE(Plannable, TRUE);
        if DataPieceworkForProduction.FINDSET then begin
            repeat
                Window.UPDATE(1, DataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Budget Code", CurrentBudget);
                ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                if ExpectedTimeUnitData.FINDSET then
                    repeat
                        CLEAR(TMPExpectedTimeUnitData);
                        TMPExpectedTimeUnitData.TRANSFERFIELDS(ExpectedTimeUnitData);
                        TMPExpectedTimeUnitData.INSERT;
                        DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");

                        TMPExpectedTimeUnitData."Expected Cost Amount" := ROUND(TMPExpectedTimeUnitData."Expected Measured Amount" *
                                                                DataPieceworkForProduction."Aver. Cost Price Pend. Budget", 0.01);
                        TMPExpectedTimeUnitData."Expected Production Amount" := ROUND(
                                   TMPExpectedTimeUnitData."Expected Measured Amount" *
                                   DataPieceworkForProduction.ProductionPrice, 0.01);
                        TMPExpectedTimeUnitData.MODIFY;
                    until ExpectedTimeUnitData.NEXT = 0;
            until DataPieceworkForProduction.NEXT = 0;
            Window.CLOSE;
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Plan Job Units", DataPieceworkForProduction);
        end ELSE
            ERROR(Text013);
    end;

    procedure ShowUnitCost();
    var
        DataCostByPiecework: Record 7207387;
        PG_BillofItemsPiecbyJobList: Page 7207515;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text010);

        //JAV 07/06/19: - Quitar limitaci�n de internos y externos para ver los descompuestos
        //if rec."Type Unit Cost" <> rec."Type Unit Cost"::External then begin

        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", rec."Job No.");
        DataCostByPiecework.SETRANGE("Piecework Code", rec."Piecework Code");
        DataCostByPiecework.SETRANGE("Cod. Budget", CurrentBudget);

        //Abrir la page de descompuestos
        CLEAR(PG_BillofItemsPiecbyJobList);
        PG_BillofItemsPiecbyJobList.SETTABLEVIEW(DataCostByPiecework);
        PG_BillofItemsPiecbyJobList.RUNMODAL;
    end;

    procedure ReceivesJob(PCodeJob: Code[20]; PCodeBudget: Code[20]);
    begin
        CurrentJob := PCodeJob;
        CurrentBudget := PCodeBudget
    end;

    LOCAL procedure SetEditable();
    begin
        edMed := bEditable and (rec."% Expense Cost" = 0);

        if rec."Account Type" = rec."Account Type"::Heading then begin
            ExpensesCostEditable := FALSE;
            MeasureBudgetPendingEditable := FALSE;
        end ELSE begin
            ExpensesCostEditable := (Rec."Allocation Terms" IN [Rec."Allocation Terms"::"% on Production", Rec."Allocation Terms"::"% on Direct Costs"]);
            MeasureBudgetPendingEditable := ExpensesCostEditable;
        end;


        stLine := rec.GetStyle('');
        stLineType := rec.GetStyle('StrongAccent');

        DescripcionIndent := 0;
    end;

    // begin
    /*{
      Filtrar por unidades de coste
      Q2814 PGM 24/01/2019 - C�lculo del presupuesto de costes indirectos.
      JAV 12/03/19: - Se quita restricci�n de borrado pues ya lo hace solo el est�ndar
      JAV 26/03/19: - Se lee el presupuesto en que estamos y se calcula el importe del mismo, ya que lo que sacaba era el total de todos los presupuestos que hubiera, no el actual
                    - Se cambian los daots que se presentan en el primer grupo de la pantalla
      JAV 07/06/19: - Quitar limitaci�n de internos y externos
      AML 30/05/23  - Q19564 Se modifica la llamada de Planificacion UO (&PIecework Planning) y se pone similara a los costes directos porque esto no funciona
      AML 23/06/23  - Q18150 Correcciones para la planificacion de indirectos.
      AML 23/06/23  - Q18150 A�adido campo rec."Cost Amount Base"
    }*///end
}







