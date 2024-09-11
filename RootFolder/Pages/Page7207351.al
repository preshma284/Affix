page 7207351 "Job Review"
{
    CaptionML = ENU = 'Job Review', ESP = 'Proyecto vista';
    SaveValues = true;
    InsertAllowed = false;
    SourceTable = 167;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'See for', ESP = 'Ver por';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'See for', ESP = 'Ver por';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF PeriodType = PeriodType::Period THEN
                            PeriodPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Year THEN
                            YearPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Quarter THEN
                            QuarterPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Month THEN
                            MonthPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Week THEN
                            WeekPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Day THEN
                            DayPeriodTypeOnValidate;
                    END;


                }
                field("AmountType"; AmountType)
                {

                    CaptionML = ENU = 'See how', ESP = 'Ver como';
                    ToolTipML = ENU = 'Net Changer', ESP = 'Saldo periodo';
                    OptionCaptionML = ENU = 'See how', ESP = 'Ver como';
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
            part("CronoJob"; 7207343)
            {
                ;
            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        UpdateSubForm;
    END;



    var
        PeriodType: Option "Day","Week","Month","Quarter","Year","Period";
        AmountType: Option "Net Change","Balance at Date";



    procedure UpdateSubForm();
    begin
        CurrPage.CronoJob.PAGE.Set(Rec, PeriodType, AmountType);
    end;

    LOCAL procedure DayPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure WeekPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure MonthPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure QuarterPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure YearPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure PeriodPeriodTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
        UpdateSubForm;
    end;

    LOCAL procedure DayPeriodTypeOnValidate();
    begin
        DayPeriodTypeOnPush;
    end;

    LOCAL procedure WeekPeriodTypeOnValidate();
    begin
        WeekPeriodTypeOnPush;
    end;

    LOCAL procedure MonthPeriodTypeOnValidate();
    begin
        MonthPeriodTypeOnPush;
    end;

    LOCAL procedure QuarterPeriodTypeOnValidate();
    begin
        QuarterPeriodTypeOnPush;
    end;

    LOCAL procedure YearPeriodTypeOnValidate();
    begin
        YearPeriodTypeOnPush;
    end;

    LOCAL procedure PeriodPeriodTypeOnValidate();
    begin
        PeriodPeriodTypeOnPush;
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







