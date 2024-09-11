page 7207289 "Trancking Materials Purchase"
{
    CaptionML = ENU = 'Trancking Materials Purchase', ESP = 'Seguimiento compara materiales';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 39;
    SourceTableView = SORTING("Document Type", "Job No.", "Expected Receipt Date", "Type", "No.")
                    WHERE("Document Type" = CONST("Order"), "Type" = CONST("Item"));
    PageType = List;

    layout
    {
        area(content)
        {
            group("Group")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'See For', ESP = 'Ver por';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'See For', ESP = 'Ver por';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF PeriodType = PeriodType::"Accounting Period" THEN
                            AccountingPerioPeriodTypeOnVal;
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
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF AmountType = AmountType::"Balance at Date" THEN
                            BalanceatDateAmountTypeOnValid;
                        IF AmountType = AmountType::"Net Change" THEN
                            NetChangeAmountTypeOnValidate;
                        CurrPage.UPDATE;
                    END;


                }

            }
            repeater("table")
            {

                Editable = False;
                field("No."; rec."No.")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Expected Receipt Date"; rec."Expected Receipt Date")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Item Reference Unit of Measure"; rec."Item Reference Unit of Measure")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Outstanding Quantity"; rec."Outstanding Quantity")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Quantity Received"; rec."Quantity Received")
                {

                }
                field("Quantity Invoiced"; rec."Quantity Invoiced")
                {

                }
                field("Job Task No."; rec."Job Task No.")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            action("action1")
            {
                CaptionML = ENU = '&View Order', ESP = '&Ver pedido';
                RunObject = Page 50;
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.");
                Image = ViewPage;
            }

        }
        area(Processing)
        {

            action("action2")
            {
                CaptionML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                ToolTipML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                Image = PreviousRecord;

                trigger OnAction()
                BEGIN
                    FindPeriod('<=');
                END;


            }
            action("action3")
            {
                CaptionML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                ToolTipML = ENU = 'Next Period', ESP = 'Periodo siguiente';
                Image = NextRecord;


                trigger OnAction()
                BEGIN
                    FindPeriod('>=');
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        AmountType := AmountType::"Balance at Date";
        FindPeriod('');
    END;



    var
        // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
        PeriodType: Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";
        FilterDate: Text[30];

    LOCAL procedure FindPeriod(SearchText: Code[10]);
    var
        Calendar: Record 2000000007;
        AccountingPeriod: Record 50;
        PeriodFormManagement: Codeunit 50324;
    begin
        if FilterDate <> '' then begin
            Calendar.SETFILTER("Period Start", FilterDate);
            if not PeriodFormManagement.FindDate('+', Calendar, PeriodType) then
                PeriodFormManagement.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SETRANGE("Period Start");
        end;
        PeriodFormManagement.FindDate(SearchText, Calendar, PeriodType);
        if AmountType = AmountType::"Net Change" then
            if Calendar."Period Start" = Calendar."Period end" then
                Rec.SETRANGE("Expected Receipt Date", Calendar."Period Start")
            ELSE
                Rec.SETRANGE("Expected Receipt Date", Calendar."Period Start", Calendar."Period end")
        ELSE
            Rec.SETRANGE("Expected Receipt Date", 0D, Calendar."Period end");

        FilterDate := rec.GETFILTER("Expected Receipt Date");
    end;

    LOCAL procedure AccountingPerioPeriodTypeOnVal();
    begin
        AccountingPerioPeriodTypOnPush;
    end;

    LOCAL procedure AccountingPerioPeriodTypOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure YearPeriodTypeOnValidate();
    begin
        YearPeriodTypeOnPush;
    end;

    LOCAL procedure YearPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure QuarterPeriodTypeOnValidate();
    begin
        QuarterPeriodTypeOnPush;
    end;

    LOCAL procedure QuarterPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure MonthPeriodTypeOnValidate();
    begin
        MonthPeriodTypeOnPush;
    end;

    LOCAL procedure MonthPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure WeekPeriodTypeOnValidate();
    begin
        WeekPeriodTypeOnPush;
    end;

    LOCAL procedure WeekPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure DayPeriodTypeOnValidate();
    begin
        DayPeriodTypeOnPush;
    end;

    LOCAL procedure DayPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure BalanceatDateAmountTypeOnValid();
    begin
        BalanceatDateAmountTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure NetChangeAmountTypeOnValidate();
    begin
        NetChangeAmountTypeOnPush;
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
        FindPeriod('');
    end;

    // begin//end
}







