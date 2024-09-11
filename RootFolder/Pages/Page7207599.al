page 7207599 "Data Investement Unit"
{
    CaptionML = ENU = 'Data Investement Unit', ESP = 'Datos unidad de inversi�n';
    InsertAllowed = false;
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = FILTER("Investment Unit"));
    DataCaptionFields = "Job No.";
    PageType = List;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            field("FORMAT(JobBudget.Budget Name)"; FORMAT(JobBudget."Budget Name"))
            {

                CaptionML = ENU = 'Investment Budget', ESP = 'Presupuesto de inversiones';
                CaptionClass = FORMAT(JobBudget."Budget Name");
                Editable = False;
                Style = Standard;
                StyleExpr = TRUE;
            }
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code";
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        rec."Piecework Code" := UPPERCASE(rec."Piecework Code");
                    END;


                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Account Type"; rec."Account Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = False;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                }
                field("Measure Pending Budget"; rec."Measure Pending Budget")
                {

                    Editable = MeasureBudgetPendingEditable;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    DecimalPlaces = 0 : 9;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                }
                field("Planned Expense"; rec."Planned Expense")
                {

                }
                field("Periodic Cost"; rec."Periodic Cost")
                {

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
                CaptionML = ENU = 'Investement &Unit', ESP = '&Udes Inversion';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = '&Ficha';

                    trigger OnAction()
                    BEGIN

                        PAGE.RUNMODAL(PAGE::"Job Piecework Card", Rec);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Extended &Text', ESP = '&Textos adicionales';
                    RunObject = Page 391;
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    RunPageLink = "Table Name" = CONST(16), "No." = FIELD("Unique Code");
                }
                action("action3")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Piecework"), "No." = FIELD("Unique Code");
                }
                separator("separator4")
                {

                }
                group("group7")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    action("action5")
                    {
                        CaptionML = ENU = 'Dimensions Individual', ESP = 'Dimensiones individuales';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(7207386), "No." = FIELD("Unique Code");
                    }
                    action("action6")
                    {
                        CaptionML = ENU = 'Dimensions Multiple', ESP = 'Dimensiones multiples';

                        trigger OnAction()
                        BEGIN
                            //JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
                            CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                            DefaultDimensionsMultiple.ClearTempDefaultDim;
                            IF DataPieceworkForProduction.FINDSET THEN
                                REPEAT
                                    DefaultDimensionsMultiple.CopyDefaultDimToDefaultDim(DATABASE::"Data Piecework For Production", DataPieceworkForProduction."Unique Code");
                                UNTIL Rec.NEXT = 0;
                            DefaultDimensionsMultiple.RUNMODAL;
                        END;


                    }

                }
                separator("separator7")
                {

                }
                action("action8")
                {
                    CaptionML = ENU = '&Planning Piecework', ESP = '&Planificaci�n de UO';

                    trigger OnAction()
                    BEGIN
                        PlanningUI;
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = '&Bill of Item Piecework', ESP = '&Descompuesto UO';

                    trigger OnAction()
                    BEGIN
                        ShowUI;
                    END;


                }
                separator("separator10")
                {

                }
                action("action11")
                {
                    CaptionML = ENU = 'E&xport Data Microsoft Proyect', ESP = 'E&xportar datos a Microsoft Proyect';
                    Image = Export;

                    trigger OnAction()
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        // ExportBudgetToMSP.PassParameters(CBudgetinProgres);
                        // ExportBudgetToMSP.SETTABLEVIEW(DataPieceworkForProduction);
                        // ExportBudgetToMSP.RUNMODAL;
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'Import data &Microsoft Proyect', ESP = 'Importar datos a &Microsoft Proyect';
                    Image = Import;

                    trigger OnAction()
                    BEGIN
                        Job.RESET;
                        Job.SETRANGE("No.", rec."Job No.");
                        // ImportBudgetToMSP.PassParameters(CBudgetinProgres);
                        // ImportBudgetToMSP.SETTABLEVIEW(Job);
                        // ImportBudgetToMSP.RUNMODAL;
                    END;


                }
                action("action13")
                {
                    CaptionML = ENU = 'See Dat&a', ESP = 'Ver dat&os MSP';
                }

            }
            group("Offert")
            {

                CaptionML = ENU = 'Functions', ESP = '&Acciones';
                Visible = OffertVisible;
                action("action14")
                {
                    CaptionML = ENU = 'Calculate Revision Budget', ESP = 'Calcular revisi�n ppto';
                    Image = CalculatePlan;

                    trigger OnAction()
                    VAR
                        LRateBudgetsbyPiecework: Codeunit 7207329;
                        LJobBudget: Record 7207407;
                        LJob: Record 167;
                    BEGIN
                        CLEAR(LRateBudgetsbyPiecework);
                        LJob.GET(rec."Job No.");
                        IF NOT LJobBudget.GET(rec."Job No.", CBudgetinProgres) THEN BEGIN
                            CLEAR(LJobBudget);
                            LJobBudget."Job No." := LJob."No.";
                            LJobBudget."Cod. Budget" := '';
                        END;
                        LRateBudgetsbyPiecework.ValueInitialization(LJob, LJobBudget);
                    END;


                }
                action("action15")
                {
                    CaptionML = ENU = '&Calculate Budget Analytic', ESP = '&Calcular ppto. anal�tico';

                    trigger OnAction()
                    VAR
                        ConvertToBudgetxCA: Codeunit 7207282;
                    BEGIN
                        CLEAR(ConvertToBudgetxCA);
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            IF Job.GET(rec."Job No.") THEN BEGIN
                                IF (Job."Job Type" = Job."Job Type"::Operative) AND
                                   (Job.Status = Job.Status::Planning) AND (Job."Original Quote Code" <> '') THEN
                                    IsVersion := TRUE
                                ELSE
                                    IsVersion := FALSE;
                            END;
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                            DataPieceworkForProduction.SETRANGE("Budget Filter", CBudgetinProgres);
                            IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                                ConvertToBudgetxCA.PassBudget(CBudgetinProgres);
                                ConvertToBudgetxCA.SetCalledSinceReestimation(FALSE, '');
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, IsVersion, rec."Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }
                separator("separator16")
                {

                }
                action("action17")
                {
                    CaptionML = ENU = 'Distribut&e Cost', ESP = 'R&epartir coste';
                    Image = SuggestVendorPayments;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", CBudgetinProgres);
                        // CLEAR(DistriProporBudgetCost);
                        // DistriProporBudgetCost.SETTABLEVIEW(DataPieceworkForProduction2);
                        // DistriProporBudgetCost.RUNMODAL;
                    END;


                }
                action("action18")
                {
                    CaptionML = ENU = '&Move Budget Over Time', ESP = '&Mover presupuesto en el tiempo';
                    Image = MachineCenterLoad;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", CBudgetinProgres);
                        // CLEAR(MoveCostsBudget);
                        // MoveCostsBudget.SETTABLEVIEW(DataPieceworkForProduction2);
                        // MoveCostsBudget.RUNMODAL;
                    END;


                }
                separator("separator19")
                {

                }
                action("action20")
                {
                    CaptionML = ENU = 'Planning Investment Expenses', ESP = 'Planificar gasto de inversi�n';

                    trigger OnAction()
                    BEGIN
                        // CLEAR(CostUnitPeriodify);
                        // CostUnitPeriodify.GetData(rec."Piecework Code", rec."Job No.", CBudgetinProgres);
                        // CostUnitPeriodify.RUNMODAL;
                    END;


                }
                action("action21")
                {
                    CaptionML = ENU = 'Planning Investment Depreciate', ESP = 'Planificar amortizaci�n inversi�n';

                    trigger OnAction()
                    BEGIN
                        IF rec."Type Unit Cost" = rec."Type Unit Cost"::External THEN BEGIN
                            EXIT;
                        END;
                        IF (rec."Type Unit Cost" = rec."Type Unit Cost"::Internal) AND (NOT rec."Periodic Cost") THEN BEGIN
                            EXIT;
                        END;

                        rec.PlanQuantity;
                    END;


                }
                separator("separator22")
                {

                }
                action("action23")
                {
                    CaptionML = ENU = 'Depreciate Plant Expenses', ESP = 'Amortizar gastos de plantas';

                    trigger OnAction()
                    BEGIN
                        // CLEAR(GenerateSheetAmortPlant);

                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Piecework Code", rec."Piecework Code");
                        // GenerateSheetAmortPlant.SETTABLEVIEW(DataPieceworkForProduction);
                        // GenerateSheetAmortPlant.RUNMODAL;
                    END;


                }

            }
            group("Job")
            {

                CaptionML = ENU = 'Functions', ESP = '&Acciones';
                Visible = JobVisible;
                action("action24")
                {
                    CaptionML = ENU = '&Calculate Budget Analytic', ESP = '&Calcular ppto. anal�tico';
                    Visible = False;

                    trigger OnAction()
                    VAR
                        ConvertToBudgetxCA: Codeunit 7207282;
                    BEGIN
                        CLEAR(ConvertToBudgetxCA);
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            IF Job.GET(rec."Job No.") THEN BEGIN
                                IF (Job."Job Type" = Job."Job Type"::Operative) AND
                                   (Job.Status = Job.Status::Planning) AND (Job."Original Quote Code" <> '') THEN
                                    IsVersion := TRUE
                                ELSE
                                    IsVersion := FALSE;
                            END;
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                            IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, IsVersion, rec."Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }
                separator("separator25")
                {

                }
                action("action26")
                {
                    CaptionML = ENU = '&Rec.GET Cost Database', ESP = '&Traer preciario';
                    Visible = False;
                    Image = JobPrice;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(BringCostDatabase);
                        // BringCostDatabase.GatherDate(rec."Job No.", '');
                        // BringCostDatabase.RUNMODAL;
                    END;


                }
                action("action27")
                {
                    CaptionML = ENU = '&Test', ESP = 'Test';
                    Visible = False;
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
                separator("separator28")
                {

                }
                action("action29")
                {
                    CaptionML = ENU = 'C&reate Certification Budget', ESP = 'C&rear presupuesto certificaci�n';
                    Visible = False;

                    trigger OnAction()
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETCURRENTKEY("Job No.", "Piecework Code");
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        // IF DataPieceworkForProduction.FINDFIRST THEN
                            // REPORT.RUN(REPORT::"Create Budget Cert. Piecework", TRUE, TRUE, DataPieceworkForProduction);
                    END;


                }
                separator("separator30")
                {

                }
                action("action31")
                {
                    CaptionML = ENU = 'Calculate Budget Review', ESP = 'Calcular revisi�n ppto';
                    Image = CalculatePlan;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        LJob: Record 167;
                        LJobBudget: Record 7207407;
                    BEGIN
                        CLEAR(RateBudgetsbyPiecework);
                        LJob.GET(rec."Job No.");
                        CLEAR(LJobBudget);
                        RateBudgetsbyPiecework.ValueInitialization(LJob, LJobBudget);
                    END;


                }
                action("action32")
                {
                    CaptionML = ENU = 'Distribute Cost', ESP = 'R&epartir coste';
                    Image = SuggestVendorPayments;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        // CLEAR(DistriProporBudgetCost);
                        // DistriProporBudgetCost.SETTABLEVIEW(DataPieceworkForProduction2);
                        // DistriProporBudgetCost.RUNMODAL;
                    END;


                }
                action("action33")
                {
                    CaptionML = ENU = '&Move Budget Over Time', ESP = '&Mover presupuesto en el tiempo';
                    Image = MachineCenterLoad;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction2);
                        // CLEAR(MoveCostsBudget);
                        // MoveCostsBudget.SETTABLEVIEW(DataPieceworkForProduction2);
                        // MoveCostsBudget.RUNMODAL;
                    END;


                }
                separator("separator34")
                {

                }
                action("action35")
                {
                    CaptionML = ENU = 'Planning Inverstment Expenses', ESP = 'Planificar gasto de inversi�n';

                    trigger OnAction()
                    BEGIN
                        // CLEAR(CostUnitPeriodify);
                        // CostUnitPeriodify.GetData(rec."Piecework Code", rec."Job No.", CBudgetinProgres);
                        // CostUnitPeriodify.RUNMODAL;
                    END;


                }
                action("action36")
                {
                    CaptionML = ENU = 'Planning Depreciate Investment', ESP = 'Planificar amortizaci�n inversi�n';

                    trigger OnAction()
                    BEGIN
                        IF rec."Type Unit Cost" = rec."Type Unit Cost"::External THEN BEGIN
                            EXIT;
                        END;
                        IF (rec."Type Unit Cost" = rec."Type Unit Cost"::Internal) AND (NOT rec."Periodic Cost") THEN BEGIN
                            EXIT;
                        END;

                        rec.PlanQuantity;
                    END;


                }
                separator("separator37")
                {

                }
                action("action38")
                {
                    CaptionML = ENU = 'Despreciate Plant Expenses', ESP = 'Amortizar gastos de planta';

                    trigger OnAction()
                    BEGIN
                        // CLEAR(GenerateSheetAmortPlant);
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Piecework Code", rec."Piecework Code");
                        // GenerateSheetAmortPlant.SETTABLEVIEW(DataPieceworkForProduction);
                        // GenerateSheetAmortPlant.RUNMODAL;
                    END;


                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action14_Promoted; action14)
                {
                }
                actionref(action17_Promoted; action17)
                {
                }
                actionref(action18_Promoted; action18)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        JobVisible := TRUE;
        OfferVisible := TRUE;
        MeasureBudgetPendingEditable := TRUE;
    END;

    trigger OnOpenPage()
    BEGIN
        IF JobBudget.GET(CJobinProgres, CBudgetinProgres) THEN;

        OfferVisible := TRUE;
        JobVisible := FALSE;
        IF Job.GET(rec."Job No.") THEN BEGIN
            IF Job.Status <> Job.Status::Planning THEN BEGIN
                OfferVisible := FALSE;
                JobVisible := TRUE;
            END ELSE BEGIN
                OfferVisible := TRUE;
                JobVisible := FALSE;
            END;
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        DescriptionIndent := 0;
        IF rec."Account Type" = rec."Account Type"::Heading THEN BEGIN
            MeasureBudgetPendingEditable := FALSE;
        END ELSE BEGIN
            MeasureBudgetPendingEditable := TRUE;
        END;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.Type := rec.Type::"Investment Unit";
        rec."Production Unit" := TRUE;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        IF rec."Account Type" = rec."Account Type"::Heading THEN
            ERROR(Text011);
    END;



    var
        GLBudgetEntry: Record 96;
        Piecework: Record 7207277;
        PeriodificationUnitCost: Record 7207432;
        text007: TextConst ENU = 'The cost unit is not remeasurable', ESP = 'La unidad de coste no es periodificable';
        JobVisible: Boolean;
        OfferVisible: Boolean;
        MeasureBudgetPendingEditable: Boolean;
        JobBudget: Record 7207407;
        CJobinProgres: Code[20];
        CBudgetinProgres: Code[20];
        Job: Record 167;
        DescriptionIndent: Integer;
        Text011: TextConst ENU = 'You can not Rec.DELETE a larger drive if it is not deployed', ESP = 'No se puede borrar una unidad de mayor si no esta desplegada';
        DataPieceworkForProduction: Record 7207386;
        DefaultDimensionsMultiple: Page 542;
        Window: Dialog;
        Text012: TextConst ENU = 'Preparing Planning Data Cost Unit #1#########', ESP = 'Preparando datos de planificaci�n unidad de coste #1#########';
        Text010: TextConst ENU = 'You can not define bill of item or plan in piecework of major', ESP = 'No se puede definir descompuesto ni planificar en unidades de obra de mayor';
        Text013: TextConst ENU = 'Does not have planned investment units', ESP = 'No tiene unidades de inversi�n planificables';
        DataCostByPiecework: Record 7207387;
        // ExportBudgetToMSP: Report 7207382;
        // ImportBudgetToMSP: Report 7207383;
        OffertVisible: Boolean;
        Text005: TextConst ENU = 'The process is over', ESP = 'El proceso ha terminado';
        Text008: TextConst ENU = 'The analytical budget will be calculated. Do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        IsVersion: Boolean;
        DataPieceworkForProduction2: Record 7207386;
        // DistriProporBudgetCost: Report 7207355;
        // MoveCostsBudget: Report 7207356;
        // CostUnitPeriodify: Report 7207345;
        // GenerateSheetAmortPlant: Report 7207386;
        // BringCostDatabase: Report 7207277;
        Text009: TextConst ENU = 'You must create the code of Unit of work before assigning the data', ESP = 'Debe de crear el c�digo de Unidad de obra antes de asignar los datos';

    procedure PlanningUI();
    var
        LDataPieceworkForProduction: Record 7207386;
        LExpectedTimeUnitData: Record 7207388;
        LTMPExpectedTimeUnitData: Record 7207389;
    begin
        LTMPExpectedTimeUnitData.RESET;
        LTMPExpectedTimeUnitData.SETCURRENTKEY("Job No.");
        LTMPExpectedTimeUnitData.SETRANGE("Job No.", rec."Job No.");
        LTMPExpectedTimeUnitData.DELETEALL;

        Window.OPEN(Text012);
        LExpectedTimeUnitData.SETCURRENTKEY(LExpectedTimeUnitData."Job No.", LExpectedTimeUnitData."Piecework Code");
        LDataPieceworkForProduction.RESET;
        LDataPieceworkForProduction.FILTERGROUP(2);
        LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        LDataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::"Investment Unit");
        LDataPieceworkForProduction.FILTERGROUP(0);
        LDataPieceworkForProduction.SETRANGE("Budget Filter", CJobinProgres);
        LDataPieceworkForProduction.SETRANGE(Plannable, TRUE);
        if LDataPieceworkForProduction.FINDSET then begin
            repeat
                Window.UPDATE(1, LDataPieceworkForProduction."Piecework Code");
                LExpectedTimeUnitData.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                LExpectedTimeUnitData.SETRANGE("Piecework Code", LDataPieceworkForProduction."Piecework Code");
                LExpectedTimeUnitData.SETRANGE("Budget Code", CBudgetinProgres);
                LExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                if LExpectedTimeUnitData.FINDSET then
                    repeat
                        CLEAR(LTMPExpectedTimeUnitData);
                        LTMPExpectedTimeUnitData.TRANSFERFIELDS(LExpectedTimeUnitData);
                        LTMPExpectedTimeUnitData.SetData;
                        LTMPExpectedTimeUnitData.INSERT(FALSE);
                    until LExpectedTimeUnitData.NEXT = 0;
            until LDataPieceworkForProduction.NEXT = 0;
            Window.CLOSE;
            COMMIT;
            PAGE.RUNMODAL(PAGE::"Planning Pieceworks MSP", LDataPieceworkForProduction);
        end ELSE
            ERROR(Text013);
    end;

    procedure ShowUI();
    var
        Piecework: Record 7207277;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text010);

        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.", rec."Job No.");
        DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code", rec."Piecework Code");
        Job.GET(rec."Job No.");
        DataCostByPiecework.SETRANGE("Cod. Budget", CBudgetinProgres);
        PAGE.RUNMODAL(PAGE::"Hist. Head. Deliv Element List", DataCostByPiecework);
    end;

    procedure ReceiveJob(PCJob: Code[20]; PBudget: Code[20]);
    begin
        CJobinProgres := PCJob;
        CBudgetinProgres := PBudget;
    end;

    // begin
    /*{
      JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
      JAV 10/04/22: - QB 1.10.34 Se cambia la forma de llamar al cambio de dimensi�n m�ltiple
    }*///end
}







