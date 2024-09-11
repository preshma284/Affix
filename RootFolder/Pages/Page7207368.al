page 7207368 "Summary Analytic Job"
{
    CaptionML = ENU = 'Summary Analytic Job', ESP = 'Resumen anal�tica proyecto';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 167;
    DataCaptionFields = "No.", "Description";
    PageType = List;

    layout
    {
        area(content)
        {
            group("Group")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("ItemPeriodLength"; ItemPeriodLength)
                {

                    CaptionML = ENU = 'See for', ESP = 'Ver por';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'See for', ESP = 'Ver por';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF ItemPeriodLength = ItemPeriodLength::"Accounting Period" THEN
                            PeriodItemPeriodLengthOnValida;
                        IF ItemPeriodLength = ItemPeriodLength::Year THEN
                            YearItemPeriodLengthOnValidate;
                        IF ItemPeriodLength = ItemPeriodLength::Quarter THEN
                            QuarterItemPeriodLengthOnValid;
                        IF ItemPeriodLength = ItemPeriodLength::Month THEN
                            MonthItemPeriodLengthOnValidat;
                        IF ItemPeriodLength = ItemPeriodLength::Week THEN
                            WeekItemPeriodLengthOnValidate;
                        IF ItemPeriodLength = ItemPeriodLength::Day THEN
                            DayItemPeriodLengthOnValidate;
                    END;


                }
                field("AmountType"; AmountType)
                {

                    CaptionML = ENU = 'See How', ESP = 'Ver como';
                    ToolTipML = ENU = 'Net Change', ESP = 'Saldo periodo';
                    OptionCaptionML = ENU = 'See How', ESP = 'Ver como';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF AmountType = AmountType::"Balance at Date" THEN
                            BalanceatDateAmountTypeOnValid;
                        IF AmountType = AmountType::"Net Change" THEN
                            NetChangeAmountTypeOnValidate;
                    END;


                }

            }
            part("AnalJob"; 7207366)
            {

                Editable = False;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            action("action1")
            {
                CaptionML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                ToolTipML = ENU = 'Previous Period', ESP = 'Peridodo anterior';
                Image = PreviousSet;

                trigger OnAction()
                BEGIN
                    FindPeriod('<=');
                    UpdateSubForm;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                ToolTipML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                Image = NextSet;


                trigger OnAction()
                BEGIN
                    FindPeriod('>=');
                    UpdateSubForm;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        FindPeriod('');
    END;

    trigger OnAfterGetRecord()
    BEGIN
        FindPeriod('');
        UpdateSubForm;
    END;



    var
        Calendar: Record 2000000007;
        // ItemPeriodLength: Option "Day","Week","Month","Quarter","Year","Period";
        ItemPeriodLength:Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";



    LOCAL procedure FindPeriod(SearchText: Code[10]);
    var
        PeriodFormMgt: Codeunit 50324;
    begin
        if Rec.GETFILTER("Posting Date Filter") <> '' then begin
            Calendar.SETFILTER("Period Start", rec.GETFILTER("Posting Date Filter"));
            if not PeriodFormMgt.FindDate('+', Calendar, ItemPeriodLength) then
                PeriodFormMgt.FindDate('+', Calendar, ItemPeriodLength::Day);
            Calendar.SETRANGE("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText, Calendar, ItemPeriodLength);
        if AmountType = AmountType::"Net Change" then begin
            Rec.SETRANGE("Posting Date Filter", Calendar."Period Start", Calendar."Period end");
            if Rec.GETRANGEMIN("Posting Date Filter") = Rec.GETRANGEMAX("Posting Date Filter") then
                Rec.SETRANGE("Posting Date Filter", rec.GETRANGEMIN("Posting Date Filter"));
        end ELSE
            Rec.SETRANGE("Posting Date Filter", 0D, Calendar."Period end");

        Rec.SETFILTER("Reestimation Filter", rec."Latest Reestimation Code");
    end;

    procedure UpdateSubForm();
    begin
        CurrPage.AnalJob.PAGE.Set(Rec, ItemPeriodLength, AmountType);
    end;

    LOCAL procedure PeriodItemPeriodLengthOnValida();
    begin
        PeriodItemPeriodLengthOnPush;
    end;

    LOCAL procedure PeriodItemPeriodLengthOnPush();
    begin
    end;

    LOCAL procedure YearItemPeriodLengthOnValidate();
    begin
        YearItemPeriodLengthOnPush;
    end;

    LOCAL procedure YearItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure QuarterItemPeriodLengthOnValid();
    begin
        QuarterItemPeriodLengthOnPush;
    end;

    LOCAL procedure QuarterItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure MonthItemPeriodLengthOnValidat();
    begin
        MonthItemPeriodLengthOnPush;
    end;

    LOCAL procedure MonthItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure WeekItemPeriodLengthOnValidate();
    begin
        WeekItemPeriodLengthOnPush;
    end;

    LOCAL procedure WeekItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure DayItemPeriodLengthOnValidate();
    begin
        DayItemPeriodLengthOnPush;
    end;

    LOCAL procedure DayItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnValid();
    begin
        BalanceatDateAmountTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure NetChangeAmountTypeOnValidate();
    begin
        NetChangeAmountTypeOnPush;
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    // begin//end
}







