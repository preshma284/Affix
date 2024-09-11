page 7207586 "Subcontracting Planification"
{
    CaptionML = ENU = 'Subcontracting Planification', ESP = 'Planificaci�n subcontrataci�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Production Unit" = CONST(true));
    PageType = List;
    CardPageID = "Job Piecework Card";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        C243dPieceworkOnAfterValidate;
                    END;


                }
                field("Account Type"; rec."Account Type")
                {

                    Visible = false;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = false;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("No. Subcontracting Resource"; rec."No. Subcontracting Resource")
                {

                }
                field("Activity Code"; rec."Activity Code")
                {

                }
                field("Analytical Concept Subcon Code"; rec."Analytical Concept Subcon Code")
                {

                }
                field("Budget Measure"; rec."Budget Measure")
                {


                    ; trigger OnValidate()
                    BEGIN
                        Measure243nPieceworkSolOnA;
                    END;


                }
                field("Price Subcontracting Cost"; rec."Price Subcontracting Cost")
                {

                }
                field("CostPrice"; rec."CostPrice")
                {

                    CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
                    Visible = False;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    Visible = false;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
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
                CaptionML = ENU = 'Pieceswork', ESP = '&Unidades Obra';
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
                    CaptionML = ENU = 'Piecework Bill of Item', ESP = '&Descompuesto UO';

                    trigger OnAction()
                    BEGIN
                        PieceworkShow;
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Measurement Lines', ESP = '&L�neas de medici�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        PieceworkMeasureLineShow;
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Extended Text', ESP = '&Textos adicionales';
                    RunObject = Page 391;
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    RunPageLink = "Table Name" = CONST(16), "No." = FIELD("Unique Code");
                }
                action("action5")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job Cost Piecework"), "No." = FIELD("Unique Code");
                }
                action("action6")
                {
                    CaptionML = ENU = 'Piecework Planification', ESP = '&Planificaci�n de UO';

                    trigger OnAction()
                    BEGIN
                        PieceworkPlanning;
                    END;


                }

            }
            group("group9")
            {
                CaptionML = ENU = 'Actions', ESP = '&Acciones';
                action("action7")
                {
                    ShortCutKey = 'Shift+F11';
                    CaptionML = ENU = 'Asign Bill of Item Unit', ESP = 'Asignar descompuesto unit.';
                    Image = Troubleshoot;


                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        IF CONFIRM(Text010) THEN BEGIN
                            CLEAR(DataPieceworkForProduction);
                            CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
                            AsigBillOfItemUnit(DataPieceworkForProduction);
                        END;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    BEGIN
        DescriptionIndent := 0;
        OnAfterGetCurrRecord;
        C243dPieceworkOnFormat;
        Description243nOnFormat;
        Measure243nBudgetPieceworkSolOnF;
        CostPriceOnFormat;
        AmountCostBudgetOnFormat;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        OnAfterGetCurrRecord;
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        DataCostByPiecework: Record 7207387;
        Job: Record 167;
        PieceworkCodeEmphasize: Boolean;
        DescriptionEmphasize: Boolean;
        DescriptionIndent: Integer;
        MeasurementBudgetPieceworkSolEmpha: Boolean;
        CostPriceEmphasize: Boolean;
        AmountCostBudgetEmphasize: Boolean;
        Text007: TextConst ENU = 'Can''t define bill of items and not detail of measurement lines in piecework heading', ESP = 'No se pueden definir descompuestos ni detalle de l�neas de medici�n en mayores de unidades de obra.';
        Text010: TextConst ENU = 'Do you want update bill of item? (will be deleted previouses and will be created a unique line by piecework)', ESP = '�Actualizar descompuesto? (borrar� los anteriores y crear� una unica linea por cada Unidad de obra)';

    procedure PieceworkShow();
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text007);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Piecework Code", rec."Piecework Code");
        DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
        DataPieceworkForProduction.FILTERGROUP(0);
        if Rec.GETFILTER("Budget Filter") <> '' then begin
            DataPieceworkForProduction.SETRANGE("Budget Filter", rec.GETFILTER("Budget Filter"));
        end ELSE begin
            DataPieceworkForProduction.SETFILTER("Budget Filter", '');
        end;
        PAGE.RUNMODAL(PAGE::"Piecework Bill of Items Card", DataPieceworkForProduction);
    end;

    procedure PieceworkPlanning();
    var
        DataPieceworkForProduction: Record 7207386;
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        Job.GET(rec."Job No.");
        DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Latest Reestimation Code");
        PAGE.RUNMODAL(PAGE::"Piecework Planning", DataPieceworkForProduction);
    end;

    procedure PieceworkMeasureLineShow();
    var
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        if rec."Account Type" = rec."Account Type"::Heading then
            ERROR(Text007);
        if Rec.GETFILTER("Budget Filter") <> '' then
            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Rec.GETFILTER("Budget Filter"), rec."Piecework Code")
        ELSE begin
            Job.GET(rec."Job No.");
            ManagementLineofMeasure.editMeasurementLinPiecewProd(rec."Job No.", Job."Current Piecework Budget", rec."Piecework Code");
        end;
    end;

    procedure AsigBillOfItemUnit(var DataPieceworkForProduction1: Record 7207386);
    begin
        if DataPieceworkForProduction1.FINDSET then
            repeat
                DataPieceworkForProduction1."Budget Filter" := rec.GETFILTER("Budget Filter");
                if DataPieceworkForProduction1."No. Subcontracting Resource" <> '' then
                    DataPieceworkForProduction1.AssigBillOfItemUnitSubcontracting(1);
            until DataPieceworkForProduction1.NEXT = 0;
        DataPieceworkForProduction1.SETRANGE("Piecework Code");
    end;

    LOCAL procedure C243dPieceworkOnAfterValidate();
    begin
        CurrPage.UPDATE(TRUE);
    end;

    LOCAL procedure Measure243nPieceworkSolOnA();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    LOCAL procedure OnAfterGetCurrRecord();
    begin
        xRec := Rec;
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    LOCAL procedure C243dPieceworkOnFormat();
    begin
        PieceworkCodeEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure Description243nOnFormat();
    begin
        DescriptionIndent := (rec.Indentation) * 220;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DescriptionEmphasize := TRUE;
        end;
    end;

    LOCAL procedure Measure243nBudgetPieceworkSolOnF();
    begin
        MeasurementBudgetPieceworkSolEmpha := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure CostPriceOnFormat();
    begin
        CostPriceEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    LOCAL procedure AmountCostBudgetOnFormat();
    begin
        AmountCostBudgetEmphasize := rec."Account Type" <> rec."Account Type"::Unit;
    end;

    // begin//end
}







