Codeunit 50324 "PeriodFormManagement 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = '<Week>.<Year4>', ESP = '<Week>.<Year4>';
        Text001: TextConst ENU = '<Month Text,3> <Year4>', ESP = '<Month Text,3> <Year4>';
        Text002: TextConst ENU = '<Quarter>/<Year4>', ESP = '<Quarter>/<Year4>';
        Text003: TextConst ENU = '<Year4>', ESP = '<Year4>';
        AccountingPeriod: Record 50;
        AccountingPeriodMgt: Codeunit 360;

    //[External]
    PROCEDURE FindDate(SearchString: Text[3]; VAR Calendar: Record 2000000007; PeriodType: Enum "Analysis Period Type"): Boolean;
    VAR
        Found: Boolean;
    BEGIN
        Calendar.SETRANGE("Period Type", PeriodType);
        // Calendar."Period Type" := PeriodType;
        IF Calendar."Period Start" = 0D THEN
            Calendar."Period Start" := WORKDATE;
        IF SearchString IN ['', '=><'] THEN
            SearchString := '=<>';
        IF PeriodType = PeriodType::"Accounting Period" THEN BEGIN
            AccountingPeriod.SETRANGE("Starting Date");
            IF AccountingPeriod.ISEMPTY THEN BEGIN
                AccountingPeriodMgt.InitDefaultAccountingPeriod(AccountingPeriod, GetCalendarPeriodMinDate(Calendar));
                Found := TRUE;
            END ELSE BEGIN
                SetAccountingPeriodFilter(Calendar);
                Found := AccountingPeriod.FIND(SearchString);
            END;
            IF Found THEN
                CopyAccountingPeriod(Calendar);
        END ELSE BEGIN
            Found := Calendar.FIND(SearchString);
            IF Found THEN
                Calendar."Period End" := NORMALDATE(Calendar."Period End");
        END;
        EXIT(Found);
    END;

    //[External]
    PROCEDURE NextDate(NextStep: Integer; VAR Calendar: Record 2000000007; PeriodType: Enum "Analysis Period Type"): Integer;
    BEGIN
        Calendar.SETRANGE("Period Type", PeriodType);
        // Calendar."Period Type" := PeriodType;
        IF PeriodType = PeriodType::"Accounting Period" THEN BEGIN
            IF AccountingPeriod.ISEMPTY THEN
                AccountingPeriodMgt.InitDefaultAccountingPeriod(AccountingPeriod, CALCDATE('<+1M>', GetCalendarPeriodMinDate(Calendar)))
            ELSE BEGIN
                SetAccountingPeriodFilter(Calendar);
                NextStep := AccountingPeriod.NEXT(NextStep);
            END;
            IF NextStep <> 0 THEN
                CopyAccountingPeriod(Calendar);
        END ELSE BEGIN
            NextStep := Calendar.NEXT(NextStep);
            IF NextStep <> 0 THEN
                Calendar."Period End" := NORMALDATE(Calendar."Period End");
        END;
        EXIT(NextStep);
    END;

    //[External]
    PROCEDURE CreatePeriodFormat(PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period"; Date: Date): Text[10];
    BEGIN
        CASE PeriodType OF
            PeriodType::Day:
                EXIT(FORMAT(Date));
            PeriodType::Week:
                BEGIN
                    IF DATE2DWY(Date, 2) = 1 THEN
                        Date := Date + 7 - DATE2DWY(Date, 1);
                    EXIT(FORMAT(Date, 0, Text000));
                END;
            PeriodType::Month:
                EXIT(FORMAT(Date, 0, Text001));
            PeriodType::Quarter:
                EXIT(FORMAT(Date, 0, Text002));
            PeriodType::Year:
                EXIT(FORMAT(Date, 0, Text003));
            PeriodType::"Accounting Period":
                EXIT(FORMAT(Date));
        END;
    END;

    //[External]
    PROCEDURE MoveDateByPeriod(Date: Date; PeriodType: Option; MoveByNoOfPeriods: Integer): Date;
    VAR
        DateExpression: DateFormula;
    BEGIN
        EVALUATE(DateExpression, '<' + FORMAT(MoveByNoOfPeriods) + GetPeriodTypeSymbol(PeriodType) + '>');
        EXIT(CALCDATE(DateExpression, Date));
    END;

    //[External]
    PROCEDURE MoveDateByPeriodToEndOfPeriod(Date: Date; PeriodType: Option; MoveByNoOfPeriods: Integer): Date;
    VAR
        DateExpression: DateFormula;
    BEGIN
        EVALUATE(DateExpression, '<' + FORMAT(MoveByNoOfPeriods + 1) + GetPeriodTypeSymbol(PeriodType) + '-1D>');
        EXIT(CALCDATE(DateExpression, Date));
    END;

    //[External]
    PROCEDURE GetPeriodTypeSymbol(PeriodType: Option): Text[1];
    VAR
        Date: Record 2000000007;
    BEGIN
        CASE PeriodType OF
            Date."Period Type"::Date:
                EXIT('D');
            Date."Period Type"::Week:
                EXIT('W');
            Date."Period Type"::Month:
                EXIT('M');
            Date."Period Type"::Quarter:
                EXIT('Q');
            Date."Period Type"::Year:
                EXIT('Y');
        END;
    END;

    LOCAL PROCEDURE SetAccountingPeriodFilter(VAR Calendar: Record 2000000007);
    BEGIN
        AccountingPeriod.SETFILTER("Starting Date", Calendar.GETFILTER("Period Start"));
        AccountingPeriod.SETFILTER(Name, Calendar.GETFILTER("Period Name"));
        AccountingPeriod."Starting Date" := Calendar."Period Start";
    END;

    LOCAL PROCEDURE GetCalendarPeriodMinDate(VAR Calendar: Record 2000000007): Date;
    BEGIN
        IF Calendar.GETFILTER("Period Start") <> '' THEN
            EXIT(Calendar.GETRANGEMIN("Period Start"));
        EXIT(Calendar."Period Start");
    END;

    LOCAL PROCEDURE CopyAccountingPeriod(VAR Calendar: Record 2000000007);
    BEGIN
        Calendar.INIT;
        Calendar."Period Start" := AccountingPeriod."Starting Date";
        Calendar."Period Name" := AccountingPeriod.Name;
        IF AccountingPeriod.ISEMPTY THEN
            Calendar."Period End" := AccountingPeriodMgt.GetDefaultPeriodEndingDate(Calendar."Period Start")
        ELSE
            IF AccountingPeriod.NEXT = 0 THEN
                Calendar."Period End" := DMY2DATE(31, 12, 9998)
            ELSE
                Calendar."Period End" := AccountingPeriod."Starting Date" - 1;
    END;

    //[External]
    PROCEDURE GetFullPeriodDateFilter(PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period"; DateFilter: Text): Text;
    VAR
        AccountingPeriod: Record 50;
        Period: Record 2000000007;
        StartDate: Date;
        EndDate: Date;
    BEGIN
        IF DateFilter = '' THEN
            EXIT(DateFilter);

        Period.SETFILTER("Period Start", DateFilter);
        StartDate := Period.GETRANGEMIN("Period Start");
        EndDate := Period.GETRANGEMAX("Period Start");
        CASE PeriodType OF
            PeriodType::Week,
            PeriodType::Month,
            PeriodType::Quarter,
            PeriodType::Year:
                BEGIN
                    Period.SETRANGE("Period Type", PeriodType);
                    Period.SETFILTER("Period Start", '<=%1', StartDate);
                    Period.FINDLAST;
                    StartDate := Period."Period Start";
                    Period.SETRANGE("Period Start");
                    Period.SETFILTER("Period End", '>%1', EndDate);
                    Period.FINDFIRST;
                    EndDate := NORMALDATE(Period."Period End");
                END;
            PeriodType::"Accounting Period":
                BEGIN
                    AccountingPeriod.SETFILTER("Starting Date", '<=%1', StartDate);
                    AccountingPeriod.FINDLAST;
                    StartDate := AccountingPeriod."Starting Date";
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', EndDate);
                    AccountingPeriod.FINDFIRST;
                    EndDate := AccountingPeriod."Starting Date" - 1;
                END;
        END;
        Period.SETRANGE("Period Start", StartDate, EndDate);
        EXIT(Period.GETFILTER("Period Start"));
    END;

    //[External]
    PROCEDURE FindPeriodOnMatrixPage(VAR DateFilter: Text; VAR InternalDateFilter: Text; SearchText: Text[3]; PeriodType: Enum "Analysis Period Type"; UpdateDateFilter: Boolean);
    VAR
        Item: Record 27;
        Calendar: Record 2000000007;
    BEGIN
        IF DateFilter <> '' THEN BEGIN
            Calendar.SETFILTER("Period Start", DateFilter);
            IF NOT FindDate('+', Calendar, PeriodType) THEN
                FindDate('+', Calendar, PeriodType::Day);
            Calendar.SETRANGE("Period Start");
        END;
        FindDate(SearchText, Calendar, PeriodType);
        Item.SETRANGE("Date Filter", Calendar."Period Start", Calendar."Period End");
        IF Item.GETRANGEMIN("Date Filter") = Item.GETRANGEMAX("Date Filter") THEN
            Item.SETRANGE("Date Filter", Item.GETRANGEMIN("Date Filter"));
        InternalDateFilter := Item.GETFILTER("Date Filter");
        IF UpdateDateFilter THEN
            DateFilter := InternalDateFilter;
    END;

    /* /*BEGIN
END.*/
}







