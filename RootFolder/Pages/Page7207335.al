page 7207335 "Reestimation Lines Subform."
{
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    MultipleNewLines = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207316;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Control1")
            {

                field("Analytical concept"; rec."Analytical concept")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("G/L Account"; rec."G/L Account")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Budget amount"; rec."Budget amount")
                {


                    ; trigger OnDrillDown()
                    BEGIN
                        ShowBudgetAmount;
                    END;


                }
                field("Realized Amount"; rec."Realized Amount")
                {


                    ; trigger OnDrillDown()
                    BEGIN
                        ShowRealizedAmount;
                    END;


                }
                field("Realized Excess"; rec."Realized Excess")
                {

                }
                field("Estimated outstanding amount"; rec."Estimated outstanding amount")
                {

                }
                field("CalcTotalAmount"; rec."CalcTotalAmount")
                {

                    CaptionML = ENU = 'Total amount to estimated origin', ESP = 'Importe total a origen estimado';



                    ; trigger OnValidate()
                    BEGIN
                        CalcTotalAmountOnAfterValidate;
                    END;


                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = 'A&ction', ESP = 'A&cciones';
                action("action1")
                {
                    CaptionML = ENU = 'Move to date', ESP = 'Trasladar a fecha';
                    Image = ChangeDates;

                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021469. Unsupported part was commented. Please check it.
                        // CurrPage.LinDoc.FORM.
                        MoveToDate;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Move reestimation in the time', ESP = 'Mover reestimaci�n en el tiempo';
                    Image = MovementWorksheet;

                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021469. Unsupported part was commented. Please check it.
                        // CurrPage.LinDoc.FORM.
                        MoveInstallment;
                    END;


                }

            }
            group("group5")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'D&imensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021469. Unsupported part was commented. Please check it.
                        // CurrPage.LinDoc.FORM.
                        _ShowDimensions;
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Outstandig temporary assignment', ESP = 'Asignaci�n temporal de pendiente';
                    Image = AutoReserve;


                    trigger OnAction()
                    BEGIN
                        //This functionality was copied from page 7021469. Unsupported part was commented. Please check it.
                        // CurrPage.LinDoc.FORM.
                        BudgetForecastCA;
                    END;


                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(ShortcutDimCode);
    END;



    var
        ShortcutDimCode: ARRAY[8] OF Code[20];

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure BudgetForecastCA();
    begin
        PAGE.RUNMODAL(PAGE::"Budget Forecast CA", Rec);
    end;

    procedure ShowBudgetAmount();
    var
        GLBudgetEntry: Record 96;
        recProy: Record 167;
        ReestimationHeader: Record 7207315;
        FunctionQB: Codeunit 7207272;
    begin
        if recProy.GET(rec."Job No.") then begin
            if ReestimationHeader.GET(rec."Document No.") then ReestimationHeader.TESTFIELD("Reestimation Date");
            GLBudgetEntry.RESET;
            GLBudgetEntry.SETRANGE("Budget Name", recProy."Jobs Budget Code");

            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then
                GLBudgetEntry.SETFILTER("Global Dimension 1 Code", rec."Analytical concept")
            ELSE
                GLBudgetEntry.SETFILTER("Global Dimension 2 Code", rec."Analytical concept");

            GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", recProy."No.");
            GLBudgetEntry.SETFILTER("Budget Dimension 2 Code", recProy."Latest Reestimation Code");
            PAGE.RUN(0, GLBudgetEntry);
        end;
    end;

    procedure ShowRealizedAmount();
    var
        GLEntry: Record 17;
        recProy: Record 167;
        ReestimationHeader: Record 7207315;
        FunctionQB: Codeunit 7207272;
    begin
        if recProy.GET(rec."Job No.") then begin
            if ReestimationHeader.GET(rec."Document No.") then ReestimationHeader.TESTFIELD("Reestimation Date");
            GLEntry.RESET;

            if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then
                GLEntry.SETFILTER("Global Dimension 1 Code", rec."Analytical concept")
            ELSE
                GLEntry.SETFILTER("Global Dimension 2 Code", rec."Analytical concept");

            GLEntry.SETRANGE("Job No.", recProy."No.");
            GLEntry.SETFILTER("Posting Date", '..%1', ReestimationHeader."Reestimation Date");
            PAGE.RUN(0, GLEntry);
        end;
    end;

    procedure MoveToDate();
    var
        BringreestimationtodateCA: Page 7207381;
    begin
        CLEAR(BringreestimationtodateCA);
        BringreestimationtodateCA.SETTABLEVIEW(Rec);
        BringreestimationtodateCA.RUNMODAL;
    end;

    procedure MoveInstallment();
    var
        ReestimationLines: Record 7207316;
    begin
        //Falta el Report RedrawReceivableBills 7000196
        /*{
        CurrPage.SETSELECTIONFILTER(ReestimationLines);
        RedrawReceivableBills.SETTABLEVIEW(ReestimationLines);
        RedrawReceivableBills.RUNMODAL;
        }*/
    end;

    LOCAL procedure CalcTotalAmountOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
    end;

    // begin//end
}







