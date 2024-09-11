page 7207560 "Summary Piecework Analytical"
{
    CaptionML = ENU = 'Summary Piecework Analytical', ESP = 'Resumen anal�tica unidad obra';
    SaveValues = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207386;
    DataCaptionFields = "Piecework Code", "Description";
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

                    CaptionML = ENU = 'Day,Week,Month,Quarter,Year,PEriod', ESP = 'D�a,Semana,Mes,Trimestre,A�o,Periodo';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'Day,Week,Month,Quarter,Year,PEriod', ESP = 'D�a,Semana,Mes,Trimestre,A�o,Periodo';
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
            part("AnalJob"; 7207561)
            {

                Editable = False;
            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                ToolTipML = ENU = 'PRevious Period', ESP = 'Periodo anterior';
                Image = PreviousRecord;

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
                Image = NextRecord;


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
        PercentageAdvance := rec.AdvanceProductionPercentage;
        UpdateSubForm;
    END;



    var
        Calendar: Record 2000000007;
        // ItemPeriodLength: Option "Day","Week","Month","Quarter","Year","Period";
        ItemPeriodLength: enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";
        PercentageAdvance: Decimal;



    LOCAL procedure FindPeriod(SearchText: Code[10]);
    var
        PeriodFormMgt: Codeunit 50324;
    begin
        if Rec.GETFILTER("Filter Date") <> '' then begin
            Calendar.SETFILTER("Period Start", rec.GETFILTER("Filter Date"));
            if not PeriodFormMgt.FindDate('+', Calendar, ItemPeriodLength) then
                PeriodFormMgt.FindDate('+', Calendar, ItemPeriodLength::Day);
            Calendar.SETRANGE("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText, Calendar, ItemPeriodLength);
        if AmountType = AmountType::"Net Change" then begin
            Rec.SETRANGE("Filter Date", Calendar."Period Start", Calendar."Period end");
            if Rec.GETRANGEMIN("Filter Date") = Rec.GETRANGEMAX("Filter Date") then
                Rec.SETRANGE("Filter Date", rec.GETRANGEMIN("Filter Date"));
        end ELSE
            Rec.SETRANGE("Filter Date", 0D, Calendar."Period end");
    end;

    procedure UpdateSubForm();
    begin
        CurrPage.AnalJob.PAGE.Set(Rec, ItemPeriodLength, AmountType, PercentageAdvance);
    end;

    LOCAL procedure PeriodItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure YearItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure QuarterItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure MonthItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure WeekItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure DayItemPeriodLengthOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    LOCAL procedure DayItemPeriodLengthOnValidate();
    begin
        DayItemPeriodLengthOnPush;
    end;

    LOCAL procedure WeekItemPeriodLengthOnValidate();
    begin
        WeekItemPeriodLengthOnPush;
    end;

    LOCAL procedure MonthItemPeriodLengthOnValidat();
    begin
        MonthItemPeriodLengthOnPush;
    end;

    LOCAL procedure QuarterItemPeriodLengthOnValid();
    begin
        QuarterItemPeriodLengthOnPush;
    end;

    LOCAL procedure YearItemPeriodLengthOnValidate();
    begin
        YearItemPeriodLengthOnPush;
    end;

    LOCAL procedure PeriodItemPeriodLengthOnValida();
    begin
        PeriodItemPeriodLengthOnPush;
    end;

    LOCAL procedure NetChangeAmountTypeOnValidate();
    begin
        NetChangeAmountTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnValid();
    begin
        BalanceatDateAmountTypeOnPush;
    end;

    // begin//end
}







