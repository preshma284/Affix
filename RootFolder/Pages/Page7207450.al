page 7207450 "Chronovision Rental Elements"
{
    CaptionML = ENU = 'Chronovision Rental Elements', ESP = 'Cronovisi�n elementos de alquiler';
    SaveValues = true;
    InsertAllowed = false;
    SourceTable = 7207344;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'See By', ESP = 'Ver por';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'See By', ESP = 'Ver por';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF PeriodType = PeriodType::"Accounting Period" THEN
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
                        CurrPage.UPDATE;
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
                        CurrPage.UPDATE
                    END;


                }

            }
            part("MasterLine"; 7207451)
            {

                CaptionML = ENU = 'MasterLine', ESP = 'MaestrasLineas';
            }

        }
    }







    trigger OnAfterGetRecord()
    BEGIN
        UpdateSubForm;
    END;



    var
        // PeriodType: Option "Day","Week","Month","Quarter","Year","Period";
        PeriodType: Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";



    procedure UpdateSubForm();
    begin
        CurrPage.MasterLine.PAGE.Set(Rec, PeriodType, AmountType);
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







