Codeunit 50721 "Deferral Utilities 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        DeferralHeader: Record 1701;
        GenJnlCheckLine: Codeunit 11;
        AmountRoundingPrecision: Decimal;
        InvalidPostingDateErr: TextConst ENU = '%1 is not within the range of posting dates for your company.', ESP = '%1 no est� dentro del intervalo de fechas de registro de la empresa.';
        DeferSchedOutOfBoundsErr: TextConst ENU = 'The deferral schedule falls outside the accounting periods that have been set up for the company.', ESP = 'La previsi�n de fraccionamiento est� fuera de los per�odos de contabilidad configurados para la empresa.';
        SelectDeferralCodeMsg: TextConst ENU = 'A deferral code must be selected for the line to view the deferral schedule.', ESP = 'Para que la l�nea vea la previsi�n de fraccionamiento, se debe seleccionar un c�digo de fraccionamiento.';

    //[External]
    PROCEDURE CreateRecurringDescription(PostingDate: Date; Description: Text[50]) FinalDescription: Text[50];
    VAR
        AccountingPeriod: Record 50;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        Year: Integer;
        MonthText: Text[30];
    BEGIN
        Day := DATE2DMY(PostingDate, 1);
        Week := DATE2DWY(PostingDate, 2);
        Month := DATE2DMY(PostingDate, 2);
        MonthText := FORMAT(PostingDate, 0, '<Month Text>');
        Year := DATE2DMY(PostingDate, 3);
        IF IsAccountingPeriodExist(AccountingPeriod, PostingDate) THEN BEGIN
            AccountingPeriod.SETRANGE("Starting Date", 0D, PostingDate);
            IF NOT AccountingPeriod.FINDLAST THEN
                AccountingPeriod.Name := '';
        END;
        FinalDescription :=
          COPYSTR(STRSUBSTNO(Description, Day, Week, Month, MonthText, AccountingPeriod.Name, Year), 1, MAXSTRLEN(Description));
    END;

    //[External]
    PROCEDURE CreateDeferralSchedule(DeferralCode: Code[10]; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; AmountToDefer: Decimal; CalcMethod: Option "Straight-Line","Equal per Period","Days per Period","User-Defined"; StartDate: Date; NoOfPeriods: Integer; ApplyDeferralPercentage: Boolean; DeferralDescription: Text[50]; AdjustStartDate: Boolean; CurrencyCode: Code[10]);
    VAR
        DeferralTemplate: Record 1700;
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        AdjustedStartDate: Date;
        AdjustedDeferralAmount: Decimal;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCreateDeferralSchedule(
          DeferralCode, DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo, AmountToDefer, CalcMethod,
          StartDate, NoOfPeriods, ApplyDeferralPercentage, DeferralDescription, AdjustStartDate, CurrencyCode, IsHandled);
        IF IsHandled THEN
            EXIT;

        InitCurrency(CurrencyCode);
        DeferralTemplate.GET(DeferralCode);
        // "Start Date" passed in needs to be adjusted based on the Deferral Code's Start Date setting
        IF AdjustStartDate THEN
            AdjustedStartDate := SetStartDate(DeferralTemplate, StartDate)
        ELSE
            AdjustedStartDate := StartDate;

        AdjustedDeferralAmount := AmountToDefer;
        IF ApplyDeferralPercentage THEN
            AdjustedDeferralAmount := ROUND(AdjustedDeferralAmount * (DeferralTemplate."Deferral %" / 100), AmountRoundingPrecision);

        SetDeferralRecords(DeferralHeader, DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo,
          CalcMethod, NoOfPeriods, AdjustedDeferralAmount, AdjustedStartDate,
          DeferralCode, DeferralDescription, AmountToDefer, AdjustStartDate, CurrencyCode);

        CASE CalcMethod OF
            CalcMethod::"Straight-Line":
                CalculateStraightline(DeferralHeader, DeferralLine, DeferralTemplate);
            CalcMethod::"Equal per Period":
                CalculateEqualPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
            CalcMethod::"Days per Period":
                CalculateDaysPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
            CalcMethod::"User-Defined":
                CalculateUserDefined(DeferralHeader, DeferralLine, DeferralTemplate);
        END;

        OnAfterCreateDeferralSchedule(DeferralHeader, DeferralLine, DeferralTemplate);
    END;

    //[External]
    PROCEDURE CalcDeferralNoOfPeriods(CalcMethod: Option; NoOfPeriods: Integer; StartDate: Date): Integer;
    VAR
        DeferralTemplate: Record 1700;
        AccountingPeriod: Record 50;
    BEGIN
        CASE CalcMethod OF
            ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"::"Equal per Period"),
          ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"::"User-Defined"):
                EXIT(NoOfPeriods);
            ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"::"Straight-Line"),
            ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"::"Days per Period"):
                BEGIN
                    IF IsAccountingPeriodExist(AccountingPeriod, StartDate) THEN BEGIN
                        AccountingPeriod.SETFILTER("Starting Date", '>=%1', StartDate);
                        AccountingPeriod.FINDFIRST;
                    END;
                    IF AccountingPeriod."Starting Date" = StartDate THEN
                        EXIT(NoOfPeriods);

                    EXIT(NoOfPeriods + 1);
                END;
        END;

        DeferralTemplate."Calc. Method" := Enum::"Deferral Calculation Method".FromInteger(CalcMethod);
        DeferralTemplate.FIELDERROR("Calc. Method");
    END;

    LOCAL PROCEDURE CalculateStraightline(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    VAR
        AccountingPeriod: Record 50;
        AmountToDefer: Decimal;
        AmountToDeferFirstPeriod: Decimal;
        FractionOfPeriod: Decimal;
        PeriodicDeferralAmount: Decimal;
        RunningDeferralTotal: Decimal;
        PeriodicCount: Integer;
        HowManyDaysLeftInPeriod: Integer;
        NumberOfDaysInPeriod: Integer;
        PostDate: Date;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        PerDiffSum: Decimal;
    BEGIN
        // If the Start Date passed in matches the first date of a financial period, this is essentially the same
        // as the "Equal Per Period" deferral method, so call that function.
        OnBeforeCalculateStraightline(DeferralHeader, DeferralLine, DeferralTemplate);

        IF IsAccountingPeriodExist(AccountingPeriod, DeferralHeader."Start Date") THEN BEGIN
            AccountingPeriod.SETFILTER("Starting Date", '>=%1', DeferralHeader."Start Date");
            IF NOT AccountingPeriod.FINDFIRST THEN
                ERROR(DeferSchedOutOfBoundsErr);
        END;
        IF AccountingPeriod."Starting Date" = DeferralHeader."Start Date" THEN BEGIN
            CalculateEqualPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
            EXIT;
        END;

        PeriodicDeferralAmount := ROUND(DeferralHeader."Amount to Defer" / DeferralHeader."No. of Periods", AmountRoundingPrecision);

        FOR PeriodicCount := 1 TO (DeferralHeader."No. of Periods" + 1) DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            IF (PeriodicCount = 1) OR (PeriodicCount = (DeferralHeader."No. of Periods" + 1)) THEN BEGIN
                IF PeriodicCount = 1 THEN BEGIN
                    CLEAR(RunningDeferralTotal);

                    // Get the starting date of the accounting period of the posting date is in
                    FirstPeriodDate := GetPeriodStartingDate(PostDate);

                    // Get the starting date of the next accounting period
                    SecondPeriodDate := GetNextPeriodStartingDate(PostDate);

                    HowManyDaysLeftInPeriod := (SecondPeriodDate - DeferralHeader."Start Date");
                    NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);
                    FractionOfPeriod := (HowManyDaysLeftInPeriod / NumberOfDaysInPeriod);

                    AmountToDeferFirstPeriod := (PeriodicDeferralAmount * FractionOfPeriod);
                    AmountToDefer := ROUND(AmountToDeferFirstPeriod, AmountRoundingPrecision);
                    RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
                END ELSE
                    // Last period
                    AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);
            END ELSE BEGIN
                AmountToDefer := ROUND(PeriodicDeferralAmount, AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            END;

            DeferralLine."Posting Date" := PostDate;
            DeferralLine.Description := CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                ERROR(InvalidPostingDateErr, PostDate);

            PerDiffSum := PerDiffSum + ROUND(AmountToDefer / DeferralHeader."No. of Periods", AmountRoundingPrecision);

            DeferralLine.Amount := AmountToDefer;

            DeferralLine.INSERT;
        END;

        OnAfterCalculateStraightline(DeferralHeader, DeferralLine, DeferralTemplate);
    END;

    LOCAL PROCEDURE CalculateEqualPerPeriod(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    VAR
        PeriodicCount: Integer;
        PostDate: Date;
        AmountToDefer: Decimal;
        RunningDeferralTotal: Decimal;
    BEGIN
        OnBeforeCalculateEqualPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);

        FOR PeriodicCount := 1 TO DeferralHeader."No. of Periods" DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            DeferralLine.VALIDATE("Posting Date", PostDate);
            DeferralLine.Description := CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            AmountToDefer := DeferralHeader."Amount to Defer";
            IF PeriodicCount = 1 THEN
                CLEAR(RunningDeferralTotal);

            IF PeriodicCount <> DeferralHeader."No. of Periods" THEN BEGIN
                AmountToDefer := ROUND(AmountToDefer / DeferralHeader."No. of Periods", AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            END ELSE
                AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);

            DeferralLine.Amount := AmountToDefer;
            DeferralLine.INSERT;
        END;

        OnAfterCalculateEqualPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
    END;

    LOCAL PROCEDURE CalculateDaysPerPeriod(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    VAR
        AccountingPeriod: Record 50;
        AmountToDefer: Decimal;
        PeriodicCount: Integer;
        NumberOfDaysInPeriod: Integer;
        NumberOfDaysInSchedule: Integer;
        NumberOfDaysIntoCurrentPeriod: Integer;
        NumberOfPeriods: Integer;
        PostDate: Date;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        EndDate: Date;
        TempDate: Date;
        NoExtraPeriod: Boolean;
        DailyDeferralAmount: Decimal;
        RunningDeferralTotal: Decimal;
    BEGIN
        OnBeforeCalculateDaysPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);

        IF IsAccountingPeriodExist(AccountingPeriod, DeferralHeader."Start Date") THEN BEGIN
            AccountingPeriod.SETFILTER("Starting Date", '>=%1', DeferralHeader."Start Date");
            IF NOT AccountingPeriod.FINDFIRST THEN
                ERROR(DeferSchedOutOfBoundsErr);
        END;
        IF AccountingPeriod."Starting Date" = DeferralHeader."Start Date" THEN
            NoExtraPeriod := TRUE
        ELSE
            NoExtraPeriod := FALSE;

        // If comparison used <=, it messes up the calculations
        IF NOT NoExtraPeriod THEN BEGIN
            IF IsAccountingPeriodExist(AccountingPeriod, DeferralHeader."Start Date") THEN BEGIN
                AccountingPeriod.SETFILTER("Starting Date", '<%1', DeferralHeader."Start Date");
                AccountingPeriod.FINDLAST;
            END;
            NumberOfDaysIntoCurrentPeriod := (DeferralHeader."Start Date" - AccountingPeriod."Starting Date");
        END ELSE
            NumberOfDaysIntoCurrentPeriod := 0;

        IF NoExtraPeriod THEN
            NumberOfPeriods := DeferralHeader."No. of Periods"
        ELSE
            NumberOfPeriods := (DeferralHeader."No. of Periods" + 1);

        FOR PeriodicCount := 1 TO NumberOfPeriods DO BEGIN
            // Figure out the end date...
            IF PeriodicCount = 1 THEN
                TempDate := DeferralHeader."Start Date";

            IF PeriodicCount <> NumberOfPeriods THEN
                TempDate := GetNextPeriodStartingDate(TempDate)
            ELSE
                // Last Period, special case here...
                IF NoExtraPeriod THEN BEGIN
                    TempDate := GetNextPeriodStartingDate(TempDate);
                    EndDate := TempDate;
                END ELSE
                    EndDate := (TempDate + NumberOfDaysIntoCurrentPeriod);
        END;
        NumberOfDaysInSchedule := (EndDate - DeferralHeader."Start Date");
        DailyDeferralAmount := (DeferralHeader."Amount to Defer" / NumberOfDaysInSchedule);

        FOR PeriodicCount := 1 TO NumberOfPeriods DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            IF PeriodicCount = 1 THEN BEGIN
                CLEAR(RunningDeferralTotal);
                FirstPeriodDate := DeferralHeader."Start Date";

                // Get the starting date of the next accounting period
                SecondPeriodDate := GetNextPeriodStartingDate(PostDate);
                NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);

                AmountToDefer := ROUND(NumberOfDaysInPeriod * DailyDeferralAmount, AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            END ELSE BEGIN
                // Get the starting date of the accounting period of the posting date is in
                FirstPeriodDate := GetCurPeriodStartingDate(PostDate);

                // Get the starting date of the next accounting period
                SecondPeriodDate := GetNextPeriodStartingDate(PostDate);

                NumberOfDaysInPeriod := (SecondPeriodDate - FirstPeriodDate);

                IF PeriodicCount <> NumberOfPeriods THEN BEGIN
                    // Not the last period
                    AmountToDefer := ROUND(NumberOfDaysInPeriod * DailyDeferralAmount, AmountRoundingPrecision);
                    RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
                END ELSE
                    AmountToDefer := (DeferralHeader."Amount to Defer" - RunningDeferralTotal);
            END;

            DeferralLine."Posting Date" := PostDate;
            DeferralLine.Description := CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                ERROR(InvalidPostingDateErr, PostDate);

            DeferralLine.Amount := AmountToDefer;

            DeferralLine.INSERT;
        END;

        OnAfterCalculateDaysPerPeriod(DeferralHeader, DeferralLine, DeferralTemplate);
    END;

    LOCAL PROCEDURE CalculateUserDefined(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    VAR
        PeriodicCount: Integer;
        PostDate: Date;
    BEGIN
        OnBeforeCalculateUserDefined(DeferralHeader, DeferralLine, DeferralTemplate);

        FOR PeriodicCount := 1 TO DeferralHeader."No. of Periods" DO BEGIN
            InitializeDeferralHeaderAndSetPostDate(DeferralLine, DeferralHeader, PeriodicCount, PostDate);

            DeferralLine."Posting Date" := PostDate;
            DeferralLine.Description := CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");

            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                ERROR(InvalidPostingDateErr, PostDate);

            // For User-Defined, user must enter in deferral amounts
            DeferralLine.INSERT;
        END;

        OnAfterCalculateUserDefined(DeferralHeader, DeferralLine, DeferralTemplate);
    END;

    PROCEDURE FilterDeferralLines(VAR DeferralLine: Record 1702; DeferralDocType: Enum "Deferral Document Type"; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer);
    BEGIN
        DeferralLine.SETRANGE("Deferral Doc. Type", DeferralDocType);
        DeferralLine.SETRANGE("Gen. Jnl. Template Name", GenJnlTemplateName);
        DeferralLine.SETRANGE("Gen. Jnl. Batch Name", GenJnlBatchName);
        DeferralLine.SETRANGE("Document Type", DocumentType);
        DeferralLine.SETRANGE("Document No.", DocumentNo);
        DeferralLine.SETRANGE("Line No.", LineNo);
    END;

    LOCAL PROCEDURE SetStartDate(DeferralTemplate: Record 1700; StartDate: Date) AdjustedStartDate: Date;
    VAR
        AccountingPeriod: Record 50;
        DeferralStartOption: Option "Posting Date","Beginning of Period","End of Period","Beginning of Next Period";
    BEGIN
        // "Start Date" passed in needs to be adjusted based on the Deferral Code's Start Date setting;
        CASE DeferralTemplate."Start Date" OF
            Enum::"Deferral Calculation Start Date".FromInteger(DeferralStartOption::"Posting Date"):
                AdjustedStartDate := StartDate;
            Enum::"Deferral Calculation Start Date".FromInteger(DeferralStartOption::"Beginning of Period"):
                BEGIN
                    IF AccountingPeriod.ISEMPTY THEN
                        EXIT(CALCDATE('<-CM>', StartDate));
                    AccountingPeriod.SETRANGE("Starting Date", 0D, StartDate);
                    IF AccountingPeriod.FINDLAST THEN
                        AdjustedStartDate := AccountingPeriod."Starting Date";
                END;
            Enum::"Deferral Calculation Start Date".FromInteger(DeferralStartOption::"End of Period"):
                BEGIN
                    IF AccountingPeriod.ISEMPTY THEN
                        EXIT(CALCDATE('<CM>', StartDate));
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', StartDate);
                    IF AccountingPeriod.FINDFIRST THEN
                        AdjustedStartDate := CALCDATE('<-1D>', AccountingPeriod."Starting Date");
                END;
            Enum::"Deferral Calculation Start Date".FromInteger(DeferralStartOption::"Beginning of Next Period"):
                BEGIN
                    IF AccountingPeriod.ISEMPTY THEN
                        EXIT(CALCDATE('<CM + 1D>', StartDate));
                    AccountingPeriod.SETFILTER("Starting Date", '>%1', StartDate);
                    IF AccountingPeriod.FINDFIRST THEN
                        AdjustedStartDate := AccountingPeriod."Starting Date";
                END;
        END;
    END;

    //[External]
    PROCEDURE SetDeferralRecords(VAR DeferralHeader: Record 1701; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; CalcMethod: Option "Straight-Line","Equal per Period","Days per Period","User-Defined"; NoOfPeriods: Integer; AdjustedDeferralAmount: Decimal; AdjustedStartDate: Date; DeferralCode: Code[10]; DeferralDescription: Text[50]; AmountToDefer: Decimal; AdjustStartDate: Boolean; CurrencyCode: Code[10]);
    BEGIN
        IF NOT DeferralHeader.GET(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo) THEN BEGIN
            // Need to create the header record.
            DeferralHeader."Deferral Doc. Type" := Enum::"Deferral Document Type".FromInteger(DeferralDocType);
            DeferralHeader."Gen. Jnl. Template Name" := GenJnlTemplateName;
            DeferralHeader."Gen. Jnl. Batch Name" := GenJnlBatchName;
            DeferralHeader."Document Type" := DocumentType;
            DeferralHeader."Document No." := DocumentNo;
            DeferralHeader."Line No." := LineNo;
            DeferralHeader.INSERT;
        END;
        DeferralHeader."Amount to Defer" := AdjustedDeferralAmount;
        IF AdjustStartDate THEN
            DeferralHeader."Initial Amount to Defer" := AmountToDefer;
        DeferralHeader."Calc. Method" := Enum::"Deferral Calculation Method".FromInteger(CalcMethod);
        DeferralHeader."Start Date" := AdjustedStartDate;
        DeferralHeader."No. of Periods" := NoOfPeriods;
        DeferralHeader."Schedule Description" := DeferralDescription;
        DeferralHeader."Deferral Code" := DeferralCode;
        DeferralHeader."Currency Code" := CurrencyCode;
        DeferralHeader.MODIFY;
        // Remove old lines as they will be recalculated/recreated
        RemoveDeferralLines(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo);
    END;

    //[External]
    PROCEDURE RemoveOrSetDeferralSchedule(DeferralCode: Code[10]; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; Amount: Decimal; PostingDate: Date; Description: Text[50]; CurrencyCode: Code[10]; AdjustStartDate: Boolean);
    VAR
        DeferralHeader: Record 1701;
        DeferralTemplate: Record 1700;
    BEGIN
        IF DeferralCode = '' THEN
            // If the user cleared the deferral code, we should remove the saved schedule...
            IF DeferralHeader.GET(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo) THEN BEGIN
                DeferralHeader.DELETE;
                RemoveDeferralLines(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo);
            END;
        IF DeferralCode <> '' THEN
            IF LineNo <> 0 THEN
                IF DeferralTemplate.GET(DeferralCode) THEN BEGIN
                    ValidateDeferralTemplate(DeferralTemplate);

                    CreateDeferralSchedule(DeferralCode, DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo, Amount, ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"), PostingDate, DeferralTemplate."No. of Periods",
                      TRUE, GetDeferralDescription(GenJnlBatchName, DocumentNo, Description),
                      AdjustStartDate, CurrencyCode);
                END;
    END;

    //[External]
    PROCEDURE CreateScheduleFromGL(GenJournalLine: Record 81; FirstEntryNo: Integer);
    VAR
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        DeferralTemplate: Record 1700;
        PostedDeferralHeader: Record 1704;
        PostedDeferralLine: Record 1705;
        CustPostingGr: Record 92;
        VendPostingGr: Record 93;
        BankAcc: Record 270;
        BankAccPostingGr: Record 277;
        GenJnlPostLine: Codeunit 12;
        DeferralAccount: Code[20];
        Account: Code[20];
        GLAccount: Code[20];
        GLAccountType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";
    BEGIN
        IF DeferralHeader.GET(DeferralHeader."Deferral Doc. Type"::"G/L",
             GenJournalLine."Journal Template Name",
             GenJournalLine."Journal Batch Name", 0, '',
             GenJournalLine."Line No.")
        THEN BEGIN
            IF DeferralTemplate.GET(DeferralHeader."Deferral Code") THEN
                DeferralAccount := DeferralTemplate."Deferral Account";

            IF (GenJournalLine."Account No." = '') AND (GenJournalLine."Bal. Account No." <> '') THEN BEGIN
                GLAccount := GenJournalLine."Bal. Account No.";
                GLAccountType := ConvertDocumentTypeToOptionGenJournalAccountType(GenJournalLine."Bal. Account Type");
            END ELSE BEGIN
                GLAccount := GenJournalLine."Account No.";
                GLAccountType := ConvertDocumentTypeToOptionGenJournalAccountType(GenJournalLine."Account Type");
            END;

            // Account types not G/L are not storing a GL account in the GenJnlLine's Account field, need to retrieve
            CASE GLAccountType OF
                ConvertDocumentTypeToOptionGenJournalAccountType(GenJournalLine."Account Type"::Customer):
                    BEGIN
                        CustPostingGr.GET(GenJournalLine."Posting Group");
                        Account := CustPostingGr.GetReceivablesAccount;
                    END;
                ConvertDocumentTypeToOptionGenJournalAccountType(GenJournalLine."Account Type"::Vendor):
                    BEGIN
                        VendPostingGr.GET(GenJournalLine."Posting Group");
                        Account := VendPostingGr.GetPayablesAccount;
                    END;
                ConvertDocumentTypeToOptionGenJournalAccountType(GenJournalLine."Account Type"::"Bank Account"):
                    BEGIN
                        BankAcc.GET(GLAccount);
                        BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");
                        Account := BankAccPostingGr."G/L Account No.";
                    END;
                ELSE
                    Account := GLAccount;
            END;

            // Create the Posted Deferral Schedule with the Document Number created from the posted GL Trx...
            PostedDeferralHeader.INIT;
            PostedDeferralHeader.TRANSFERFIELDS(DeferralHeader);
            PostedDeferralHeader."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type"::"G/L";
            // Adding document number so we can connect the Ledger and Deferral Schedule details...
            PostedDeferralHeader."Gen. Jnl. Document No." := GenJournalLine."Document No.";
            PostedDeferralHeader."Account No." := Account;
            PostedDeferralHeader."Document Type" := 0;
            PostedDeferralHeader."Document No." := '';
            PostedDeferralHeader."Line No." := GenJournalLine."Line No.";
            PostedDeferralHeader."Currency Code" := GenJournalLine."Currency Code";
            PostedDeferralHeader."Deferral Account" := DeferralAccount;
            PostedDeferralHeader."Posting Date" := GenJournalLine."Posting Date";
            PostedDeferralHeader."Entry No." := FirstEntryNo;
            OnBeforePostedDeferralHeaderInsert(PostedDeferralHeader, GenJournalLine);
            PostedDeferralHeader.INSERT(TRUE);
            FilterDeferralLines(DeferralLine, DeferralHeader."Deferral Doc. Type"::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.");
            IF DeferralLine.FINDSET THEN BEGIN
                REPEAT
                    PostedDeferralLine.INIT;
                    PostedDeferralLine.TRANSFERFIELDS(DeferralLine);
                    PostedDeferralLine."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type"::"G/L";
                    PostedDeferralLine."Gen. Jnl. Document No." := GenJournalLine."Document No.";
                    PostedDeferralLine."Account No." := Account;
                    PostedDeferralLine."Document Type" := 0;
                    PostedDeferralLine."Document No." := '';
                    PostedDeferralLine."Line No." := GenJournalLine."Line No.";
                    PostedDeferralLine."Currency Code" := GenJournalLine."Currency Code";
                    PostedDeferralLine."Deferral Account" := DeferralAccount;
                    OnBeforePostedDeferralLineInsert(PostedDeferralLine, GenJournalLine);
                    PostedDeferralLine.INSERT(TRUE);
                UNTIL DeferralLine.NEXT = 0;
            END;
        END;

        OnAfterCreateScheduleFromGL(GenJournalLine, PostedDeferralHeader);

        GenJnlPostLine.RemoveDeferralSchedule(GenJournalLine);
    END;

    //[External]
    PROCEDURE DeferralCodeOnValidate(DeferralCode: Code[10]; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; Amount: Decimal; PostingDate: Date; Description: Text[50]; CurrencyCode: Code[10]);
    VAR
        DeferralHeader: Record 1701;
        DeferralLine: Record 1702;
        DeferralTemplate: Record 1700;
    BEGIN
        DeferralHeader.INIT;
        DeferralLine.INIT;
        IF DeferralCode = '' THEN
            // If the user cleared the deferral code, we should remove the saved schedule...
            DeferralCodeOnDelete(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo)
        ELSE
            IF LineNo <> 0 THEN
                IF DeferralTemplate.GET(DeferralCode) THEN BEGIN
                    ValidateDeferralTemplate(DeferralTemplate);

                    CreateDeferralSchedule(DeferralCode, DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo, Amount, ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"), PostingDate, DeferralTemplate."No. of Periods",
                      TRUE, GetDeferralDescription(GenJnlBatchName, DocumentNo, Description), TRUE, CurrencyCode);
                END;
    END;

    //[External]
    PROCEDURE DeferralCodeOnDelete(DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer);
    VAR
        DeferralHeader: Record 1701;
    BEGIN
        IF LineNo <> 0 THEN
            // Deferral Additions
            IF DeferralHeader.GET(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo) THEN BEGIN
                DeferralHeader.DELETE;
                RemoveDeferralLines(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo);
            END;
    END;

    //[External]
    PROCEDURE OpenLineScheduleEdit(DeferralCode: Code[10]; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; Amount: Decimal; PostingDate: Date; Description: Text[50]; CurrencyCode: Code[10]): Boolean;
    VAR
        DeferralTemplate: Record 1700;
        DeferralHeader: Record 1701;
        DeferralSchedule: Page 1702;
        Changed: Boolean;
    BEGIN
        IF DeferralCode = '' THEN
            MESSAGE(SelectDeferralCodeMsg)
        ELSE
            IF DeferralTemplate.GET(DeferralCode) THEN
                IF DeferralHeader.GET(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo) THEN BEGIN
                    DeferralSchedule.SetParameter(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo);
                    DeferralSchedule.RUNMODAL;
                    Changed := DeferralSchedule.GetParameter;
                    CLEAR(DeferralSchedule);
                END ELSE BEGIN
                    CreateDeferralSchedule(DeferralCode, DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo, Amount, ConvertDocumentTypeToOptionDeferralCalculationMethod(DeferralTemplate."Calc. Method"), PostingDate, DeferralTemplate."No. of Periods", TRUE,
                      GetDeferralDescription(GenJnlBatchName, DocumentNo, Description), TRUE, CurrencyCode);
                    COMMIT;
                    IF DeferralHeader.GET(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo) THEN BEGIN
                        DeferralSchedule.SetParameter(DeferralDocType, GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo);
                        DeferralSchedule.RUNMODAL;
                        Changed := DeferralSchedule.GetParameter;
                        CLEAR(DeferralSchedule);
                    END;
                END;
        EXIT(Changed);
    END;


    LOCAL PROCEDURE RemoveDeferralLines(DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer);
    VAR
        DeferralLine: Record 1702;
    BEGIN
        FilterDeferralLines(DeferralLine, Enum::"Deferral Document Type".FromInteger(DeferralDocType), GenJnlTemplateName, GenJnlBatchName, DocumentType, DocumentNo, LineNo);
        DeferralLine.DELETEALL;
    END;

    LOCAL PROCEDURE ValidateDeferralTemplate(DeferralTemplate: Record 1700);
    BEGIN
        WITH DeferralTemplate DO BEGIN
            TESTFIELD("Deferral Account");
            TESTFIELD("Deferral %");
            TESTFIELD("No. of Periods");
        END;
    END;


    LOCAL PROCEDURE InitCurrency(CurrencyCode: Code[10]);
    VAR
        Currency: Record 4;
    BEGIN
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    END;

    //[External]
    PROCEDURE GetSalesDeferralDocType(): Integer;
    BEGIN
        EXIT(DeferralHeader."Deferral Doc. Type"::Sales.AsInteger())
    END;

    LOCAL PROCEDURE InitializeDeferralHeaderAndSetPostDate(VAR DeferralLine: Record 1702; DeferralHeader: Record 1701; PeriodicCount: Integer; VAR PostDate: Date);
    VAR
        AccountingPeriod: Record 50;
    BEGIN
        DeferralLine.INIT;
        DeferralLine."Deferral Doc. Type" := DeferralHeader."Deferral Doc. Type";
        DeferralLine."Gen. Jnl. Template Name" := DeferralHeader."Gen. Jnl. Template Name";
        DeferralLine."Gen. Jnl. Batch Name" := DeferralHeader."Gen. Jnl. Batch Name";
        DeferralLine."Document Type" := DeferralHeader."Document Type";
        DeferralLine."Document No." := DeferralHeader."Document No.";
        DeferralLine."Line No." := DeferralHeader."Line No.";
        DeferralLine."Currency Code" := DeferralHeader."Currency Code";

        IF PeriodicCount = 1 THEN BEGIN
            IF NOT AccountingPeriod.ISEMPTY THEN BEGIN
                AccountingPeriod.SETFILTER("Starting Date", '..%1', DeferralHeader."Start Date");
                IF NOT AccountingPeriod.FINDFIRST THEN
                    ERROR(DeferSchedOutOfBoundsErr);
            END;
            PostDate := DeferralHeader."Start Date";
        END ELSE BEGIN
            IF IsAccountingPeriodExist(AccountingPeriod, CALCDATE('<CM>', PostDate) + 1) THEN BEGIN
                AccountingPeriod.SETFILTER("Starting Date", '>%1', PostDate);
                IF NOT AccountingPeriod.FINDFIRST THEN
                    ERROR(DeferSchedOutOfBoundsErr);
            END;
            PostDate := AccountingPeriod."Starting Date";
        END;
    END;

    LOCAL PROCEDURE IsAccountingPeriodExist(VAR AccountingPeriod: Record 50; PostingDate: Date): Boolean;
    VAR
        AccountingPeriodMgt: Codeunit 360;
    BEGIN
        AccountingPeriod.RESET;
        IF NOT AccountingPeriod.ISEMPTY THEN
            EXIT(TRUE);

        AccountingPeriodMgt.InitDefaultAccountingPeriod(AccountingPeriod, PostingDate);
        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE GetPurchDeferralDocType(): Integer;
    BEGIN
        EXIT(DeferralHeader."Deferral Doc. Type"::Purchase.AsInteger())
    END;

    //[External]
    PROCEDURE GetGLDeferralDocType(): Integer;
    BEGIN
        EXIT(DeferralHeader."Deferral Doc. Type"::"G/L".AsInteger())
    END;

 
    LOCAL PROCEDURE GetPeriodStartingDate(PostingDate: Date): Date;
    VAR
        AccountingPeriod: Record 50;
    BEGIN
        IF AccountingPeriod.ISEMPTY THEN
            EXIT(CALCDATE('<-CM>', PostingDate));

        AccountingPeriod.SETFILTER("Starting Date", '<%1', PostingDate);
        IF AccountingPeriod.FINDLAST THEN
            EXIT(AccountingPeriod."Starting Date");

        ERROR(DeferSchedOutOfBoundsErr);
    END;

    LOCAL PROCEDURE GetNextPeriodStartingDate(PostingDate: Date): Date;
    VAR
        AccountingPeriod: Record 50;
    BEGIN
        IF AccountingPeriod.ISEMPTY THEN
            EXIT(CALCDATE('<CM+1D>', PostingDate));

        AccountingPeriod.SETFILTER("Starting Date", '>%1', PostingDate);
        IF AccountingPeriod.FINDFIRST THEN
            EXIT(AccountingPeriod."Starting Date");

        ERROR(DeferSchedOutOfBoundsErr);
    END;

    LOCAL PROCEDURE GetCurPeriodStartingDate(PostingDate: Date): Date;
    VAR
        AccountingPeriod: Record 50;
    BEGIN
        IF AccountingPeriod.ISEMPTY THEN
            EXIT(CALCDATE('<-CM>', PostingDate));

        AccountingPeriod.SETFILTER("Starting Date", '<=%1', PostingDate);
        AccountingPeriod.FINDLAST;
        EXIT(AccountingPeriod."Starting Date");
    END;

    LOCAL PROCEDURE GetDeferralDescription(GenJnlBatchName: Code[10]; DocumentNo: Code[20]; Description: Text[50]): Text[50];
    BEGIN
        IF GenJnlBatchName <> '' THEN
            EXIT(COPYSTR(STRSUBSTNO('%1-%2', GenJnlBatchName, Description), 1, 50));
        EXIT(COPYSTR(STRSUBSTNO('%1-%2', DocumentNo, Description), 1, 50));
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalculateDaysPerPeriod(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalculateEqualPerPeriod(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalculateStraightline(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalculateUserDefined(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateDeferralSchedule(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCreateScheduleFromGL(VAR GenJournalLine: Record 81; VAR PostedDeferralHeader: Record 1704);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalculateDaysPerPeriod(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalculateEqualPerPeriod(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalculateStraightline(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCalculateUserDefined(DeferralHeader: Record 1701; VAR DeferralLine: Record 1702; DeferralTemplate: Record 1700);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateDeferralSchedule(DeferralCode: Code[10]; DeferralDocType: Integer; GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer; AmountToDefer: Decimal; CalcMethod: Option "Straight-Line","Equal per Period","Days per Period","User-Defined"; StartDate: Date; NoOfPeriods: Integer; ApplyDeferralPercentage: Boolean; DeferralDescription: Text[100]; AdjustStartDate: Boolean; CurrencyCode: Code[10]; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostedDeferralHeaderInsert(VAR PostedDeferralHeader: Record 1704; GenJournalLine: Record 81);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostedDeferralLineInsert(VAR PostedDeferralLine: Record 1705; GenJournalLine: Record 81);
    BEGIN
    END;

    /* /*BEGIN
END.*/
    procedure ConvertDocumentTypeToOptionGenJournalAccountType(DocumentType: Enum "Gen. Journal Account Type"): Option;
    var
        optionValue: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee","Allocation Account";
    begin
        case DocumentType of
            DocumentType::"G/L Account":
                optionValue := optionValue::"G/L Account";
            DocumentType::"Customer":
                optionValue := optionValue::"Customer";
            DocumentType::"Vendor":
                optionValue := optionValue::"Vendor";
            DocumentType::"Bank Account":
                optionValue := optionValue::"Bank Account";
            DocumentType::"Fixed Asset":
                optionValue := optionValue::"Fixed Asset";
            DocumentType::"IC Partner":
                optionValue := optionValue::"IC Partner";
            DocumentType::"Employee":
                optionValue := optionValue::"Employee";
            DocumentType::"Allocation Account":
                optionValue := optionValue::"Allocation Account";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionDeferralCalculationMethod(DocumentType: Enum "Deferral Calculation Method"): Option;
    var
        optionValue: Option "Straight-Line","Equal per Period","Days per Period","User-Defined";
    begin
        case DocumentType of
            DocumentType::"Straight-Line":
                optionValue := optionValue::"Straight-Line";
            DocumentType::"Equal per Period":
                optionValue := optionValue::"Equal per Period";
            DocumentType::"Days per Period":
                optionValue := optionValue::"Days per Period";
            DocumentType::"User-Defined":
                optionValue := optionValue::"User-Defined";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionDeferralDocumentType(DocumentType: Enum "Deferral Document Type"): Option;
    var
        optionValue: Option "Purchase","Sales","G/L";
    begin
        case DocumentType of
            DocumentType::"Purchase":
                optionValue := optionValue::"Purchase";
            DocumentType::"Sales":
                optionValue := optionValue::"Sales";
            DocumentType::"G/L":
                optionValue := optionValue::"G/L";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;
}







