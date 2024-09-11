Codeunit 50018 "FA Insert G/L Account 1"
{


    TableNo = 5601;
    trigger OnRun()
    VAR
        DisposalEntry: Boolean;
    BEGIN
        CLEAR(FAGLPostBuf);
        DisposalEntry :=
          (Rec."FA Posting Category" = Rec."FA Posting Category"::" ") AND
          (Rec."FA Posting Type" = Rec."FA Posting Type"::"Proceeds on Disposal");
        IF NOT BookValueEntry THEN
            BookValueEntry :=
              (Rec."FA Posting Category" = Rec."FA Posting Category"::Disposal) AND
              (Rec."FA Posting Type" = Rec."FA Posting Type"::"Book Value on Disposal");

        IF NOT DisposalEntry THEN
            FAGLPostBuf."Account No." := FAGetGLAcc.GetAccNo(Rec);
        FAGLPostBuf.Amount := Rec.Amount;
        FAGLPostBuf.Correction := Rec.Correction;
        FAGLPostBuf."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
        FAGLPostBuf."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
        FAGLPostBuf."Dimension Set ID" := Rec."Dimension Set ID";
        FAGLPostBuf."FA Entry No." := Rec."Entry No.";
        IF Rec."Entry No." > 0 THEN
            FAGLPostBuf."FA Entry Type" := FAGLPostBuf."FA Entry Type"::"Fixed Asset";
        FAGLPostBuf."Automatic Entry" := Rec."Automatic Entry";
        GLEntryNo := Rec."G/L Entry No.";

        QBCodeunitPublisher.OnRunCUFAInsertGLAccount(Rec);  // QB

        InsertBufferEntry;
        Rec."G/L Entry No." := TempFAGLPostBuf."Entry No.";
        IF DisposalEntry THEN
            CalcDisposalAmount(Rec);
        //-Q20269 Igual que BC14
        cdu5601_OnAfterRun(Rec, TempFAGLPostBuf, NumberOfEntries, OrgGenJnlLine, NetDisp,
                            FAGLPostBuf, DisposalEntry, BookValueEntry, NextEntryNo, GLEntryNo,
                            DisposalEntryNo, DisposalAmount, GainLossAmount, FAPostingGr2);
        //+Q20269
    END;

    VAR
        Text000: TextConst ENU = 'must not be more than 100', ESP = 'no debe ser m�s de 100';
        Text001: TextConst ENU = 'There is not enough space to insert the balance accounts.', ESP = 'No hay espacio suficiente para insertar la cuenta de saldo.';
        TempFAGLPostBuf: Record 5637 TEMPORARY;
        FAGLPostBuf: Record 5637;
        FAAlloc: Record 5615;
        FAPostingGr: Record 5606;
        FAPostingGr2: Record 5606;
        FADeprBook: Record 5612;
        FADimMgt: Codeunit 5674;
        FAGetGLAcc: Codeunit 5602;
        DepreciationCalc: Codeunit 5616;
        NextEntryNo: Integer;
        GLEntryNo: Integer;
        TotalAllocAmount: Decimal;
        NewAmount: Decimal;
        TotalPercent: Decimal;
        NumberOfEntries: Integer;
        NextLineNo: Integer;
        NoOfEmptyLines: Integer;
        NoOfEmptyLines2: Integer;
        OrgGenJnlLine: Boolean;
        DisposalEntryNo: Integer;
        GainLossAmount: Decimal;
        DisposalAmount: Decimal;
        BookValueEntry: Boolean;
        NetDisp: Boolean;
        QBCodeunitPublisher: Codeunit 7207352;
        QBFAAnaliticalDistribution: Codeunit 7206985;

    //[External]
    PROCEDURE InsertMaintenanceAccNo(VAR MaintenanceLedgEntry: Record 5625);
    BEGIN
        WITH MaintenanceLedgEntry DO BEGIN
            CLEAR(FAGLPostBuf);
            FAGLPostBuf."Account No." := FAGetGLAcc.GetMaintenanceAccNo(MaintenanceLedgEntry);
            FAGLPostBuf.Amount := Amount;
            FAGLPostBuf.Correction := Correction;
            FAGLPostBuf."Global Dimension 1 Code" := "Global Dimension 1 Code";
            FAGLPostBuf."Global Dimension 2 Code" := "Global Dimension 2 Code";
            FAGLPostBuf."Dimension Set ID" := "Dimension Set ID";
            FAGLPostBuf."FA Entry No." := "Entry No.";
            FAGLPostBuf."FA Entry Type" := FAGLPostBuf."FA Entry Type"::Maintenance;
            GLEntryNo := "G/L Entry No.";

            QBCodeunitPublisher.InsertMaintenanceAccNoCUFAInsertGLAccount(MaintenanceLedgEntry);   // QB

            InsertBufferEntry;
            "G/L Entry No." := TempFAGLPostBuf."Entry No.";
        END;
    END;

    LOCAL PROCEDURE InsertBufferBalAcc(FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss"; AllocAmount: Decimal; DeprBookCode: Code[10]; PostingGrCode: Code[20]; GlobalDim1Code: Code[20]; GlobalDim2Code: Code[20]; DimSetID: Integer; AutomaticEntry: Boolean; Correction: Boolean);
    VAR
        DimMgt: Codeunit 408;
        GLAccNo: Code[20];
        DimensionSetIDArr: ARRAY[10] OF Integer;
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        DimDict: Dictionary of [Integer, Code[20]];
        i: integer;
    BEGIN
        NumberOfEntries := 0;
        TotalAllocAmount := 0;
        NewAmount := 0;
        TotalPercent := 0;
        WITH FAPostingGr DO BEGIN
            RESET;
            GET(PostingGrCode);
            GLAccNo := GetGLAccNoFromFAPostingGroup(FAPostingGr, FAPostingType);
        END;

        DimensionSetIDArr[1] := DimSetID;

        WITH FAAlloc DO BEGIN
            RESET;
            SETRANGE(Code, PostingGrCode);
            SETRANGE("Allocation Type", FAPostingType);
            IF FIND('-') THEN
                REPEAT
                    IF ("Account No." = '') AND ("Allocation %" > 0) THEN
                        TESTFIELD("Account No.");
                    TotalPercent := TotalPercent + "Allocation %";
                    NewAmount :=
                      DepreciationCalc.CalcRounding(DeprBookCode, AllocAmount * TotalPercent / 100) - TotalAllocAmount;
                    TotalAllocAmount := TotalAllocAmount + NewAmount;
                    IF ABS(TotalAllocAmount) > ABS(AllocAmount) THEN
                        NewAmount := AllocAmount - (TotalAllocAmount - NewAmount);
                    CLEAR(FAGLPostBuf);
                    FAGLPostBuf."Account No." := "Account No.";

                    DimensionSetIDArr[2] := "Dimension Set ID";
                    FAGLPostBuf."Dimension Set ID" :=
                      DimMgt.GetCombinedDimensionSetID(
                        DimensionSetIDArr, FAGLPostBuf."Global Dimension 1 Code", FAGLPostBuf."Global Dimension 2 Code");

                    FAGLPostBuf.Amount := NewAmount;
                    FAGLPostBuf."Automatic Entry" := AutomaticEntry;
                    FAGLPostBuf.Correction := Correction;
                    FAGLPostBuf."FA Posting Group" := Code;
                    FAGLPostBuf."FA Allocation Type" := "Allocation Type";
                    FAGLPostBuf."FA Allocation Line No." := "Line No.";

                    QBCodeunitPublisher.InsertBufferBalAccCUFAInsertGLAccount(FAPostingType, AllocAmount, DeprBookCode, PostingGrCode, GlobalDim1Code, GlobalDim2Code, DimSetID, AutomaticEntry, Correction);  // QB

                    IF NewAmount <> 0 THEN BEGIN
                        FADimMgt.CheckFAAllocDim(FAAlloc, FAGLPostBuf."Dimension Set ID");
                        InsertBufferEntry;
                    END;
                UNTIL NEXT = 0;
            IF ABS(TotalAllocAmount) < ABS(AllocAmount) THEN BEGIN
                NewAmount := AllocAmount - TotalAllocAmount;
                CLEAR(FAGLPostBuf);
                FAGLPostBuf."Account No." := GLAccNo;
                FAGLPostBuf.Amount := NewAmount;
                FAGLPostBuf."Global Dimension 1 Code" := GlobalDim1Code;
                FAGLPostBuf."Global Dimension 2 Code" := GlobalDim2Code;
                TableID[1] := DATABASE::"G/L Account";
                No[1] := GLAccNo;
                //FAGLPostBuf."Dimension Set ID" :=
                //   DimMgt.GetDefaultDimID(TableID, No, '', FAGLPostBuf."Global Dimension 1 Code",
                //     FAGLPostBuf."Global Dimension 2 Code", DimSetID, 0);
                for i := 1 to 10 do begin
                    // Initialize a new dictionary for each dimension
                    clear(DimDict);
                    DimDict.Add(TableID[i], No[i]);
                    DefaultDimSource.Add(DimDict);
                end;
                FAGLPostBuf."Dimension Set ID" :=
                  DimMgt.GetDefaultDimID(DefaultDimSource, '', FAGLPostBuf."Global Dimension 1 Code",
                    FAGLPostBuf."Global Dimension 2 Code", DimSetID, 0);

                FAGLPostBuf."Automatic Entry" := AutomaticEntry;
                FAGLPostBuf.Correction := Correction;

                QBCodeunitPublisher.InsertBufferBalAcc2CUFAInsertGLAccount(FAPostingType, AllocAmount, DeprBookCode, PostingGrCode, GlobalDim1Code, GlobalDim2Code, DimSetID, AutomaticEntry, Correction, GLAccNo);  // QB

                IF NewAmount <> 0 THEN
                    InsertBufferEntry;
            END;
        END;
    END;

    //[External]
    PROCEDURE InsertBalAcc(VAR FALedgEntry: Record 5601);
    BEGIN
        // Called from codeunit 5632

        QBCodeunitPublisher.InsertBalAccCUFAInsertGLAccount(FALedgEntry); // QB

        WITH FALedgEntry DO
            InsertBufferBalAcc(
              GetPostingType(FALedgEntry), -Amount, "Depreciation Book Code",
              "FA Posting Group", "Global Dimension 1 Code", "Global Dimension 2 Code", "Dimension Set ID", "Automatic Entry", Correction);
    END;

    LOCAL PROCEDURE GetPostingType(VAR FALedgEntry: Record 5601): Integer;
    VAR
        FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss";
    BEGIN
        WITH FALedgEntry DO BEGIN
            IF "FA Posting Type".AsInteger() >= "FA Posting Type"::"Gain/Loss".AsInteger() THEN BEGIN
                IF "FA Posting Type" = "FA Posting Type"::"Gain/Loss" THEN BEGIN
                    IF "Result on Disposal" = "Result on Disposal"::Gain THEN
                        EXIT(FAPostingType::Gain);

                    EXIT(FAPostingType::Loss);
                END;
                IF "FA Posting Type" = "FA Posting Type"::"Book Value on Disposal" THEN BEGIN
                    IF "Result on Disposal" = "Result on Disposal"::Gain THEN
                        EXIT(FAPostingType::"Book Value Gain");

                    EXIT(FAPostingType::"Book Value Loss");
                END;
            END ELSE
                EXIT(ConvertPostingType);
        END;
    END;

    //[External]
    PROCEDURE GetBalAcc(GenJnlLine: Record 81): Integer;
    VAR
        TempGenJnlLine: Record 81 TEMPORARY;
        SkipInsert: Boolean;
    BEGIN
        TempFAGLPostBuf.DELETEALL;
        TempGenJnlLine.INIT;
        WITH GenJnlLine DO BEGIN
            RESET;
            FIND;
            TESTFIELD("Bal. Account No.", '');
            TESTFIELD("Account Type", "Account Type"::"Fixed Asset");
            TESTFIELD("Account No.");
            TESTFIELD("Depreciation Book Code");
            TESTFIELD("Posting Group");
            TESTFIELD("FA Posting Type");
            TempGenJnlLine.Description := Description;
            TempGenJnlLine."FA Add.-Currency Factor" := "FA Add.-Currency Factor";
            SkipInsert := FALSE;
            OnGetBalAccAfterSaveGenJnlLineFields(TempGenJnlLine, GenJnlLine, SkipInsert);
            IF NOT SkipInsert THEN
                InsertBufferBalAcc(
                  "FA Posting Type".AsInteger() - 1, -Amount, "Depreciation Book Code",
                  "Posting Group", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID", FALSE, FALSE);
            CalculateNoOfEmptyLines(GenJnlLine, NumberOfEntries);
            "Account Type" := "Account Type"::"G/L Account";
            "Depreciation Book Code" := '';
            "Posting Group" := '';
            VALIDATE("FA Posting Type", "FA Posting Type"::" ");
            IF TempFAGLPostBuf.FINDFIRST THEN
                REPEAT
                    "Line No." := 0;
                    VALIDATE("Account No.", TempFAGLPostBuf."Account No.");
                    VALIDATE(Amount, TempFAGLPostBuf.Amount);
                    VALIDATE("Depreciation Book Code", '');
                    "Shortcut Dimension 1 Code" := TempFAGLPostBuf."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := TempFAGLPostBuf."Global Dimension 2 Code";
                    "Dimension Set ID" := TempFAGLPostBuf."Dimension Set ID";
                    Description := TempGenJnlLine.Description;
                    "FA Add.-Currency Factor" := TempGenJnlLine."FA Add.-Currency Factor";
                    OnGetBalAccAfterRestoreGenJnlLineFields(GenJnlLine, TempGenJnlLine);
                    InsertGenJnlLine(GenJnlLine);
                UNTIL TempFAGLPostBuf.NEXT = 0;
        END;
        TempFAGLPostBuf.DELETEALL;
        EXIT(GenJnlLine."Line No.");
    END;

    //[External]
    PROCEDURE GetBalAcc2(VAR GenJnlLine: Record 81; VAR NextLineNo2: Integer);
    BEGIN
        NoOfEmptyLines2 := 1000;
        GetBalAcc(GenJnlLine);
        NextLineNo2 := NextLineNo;
    END;

    LOCAL PROCEDURE GetGLAccNoFromFAPostingGroup(FAPostingGr: Record 5606; FAPostingType: Option "Acquisition","Depr","WriteDown","Appr","Custom1","Custom2","Disposal","Maintenance","Gain","Loss","Book Value Gain","Book Value Loss") GLAccNo: Code[20];
    VAR
        FieldErrorText: Text[50];
    BEGIN
        FieldErrorText := Text000;
        WITH FAPostingGr DO
            CASE FAPostingType OF
                FAPostingType::Acquisition:
                    BEGIN
                        GLAccNo := GetAcquisitionCostBalanceAccount;
                        CALCFIELDS("Allocated Acquisition Cost %");
                        IF "Allocated Acquisition Cost %" > 100 THEN
                            FIELDERROR("Allocated Acquisition Cost %", FieldErrorText);
                    END;
                FAPostingType::Depr:
                    BEGIN
                        GLAccNo := GetDepreciationExpenseAccount;
                        CALCFIELDS("Allocated Depreciation %");
                        IF "Allocated Depreciation %" > 100 THEN
                            FIELDERROR("Allocated Depreciation %", FieldErrorText);
                    END;
                FAPostingType::WriteDown:
                    BEGIN
                        GLAccNo := GetWriteDownExpenseAccount;
                        CALCFIELDS("Allocated Write-Down %");
                        IF "Allocated Write-Down %" > 100 THEN
                            FIELDERROR("Allocated Write-Down %", FieldErrorText);
                    END;
                FAPostingType::Appr:
                    BEGIN
                        GLAccNo := GetAppreciationBalanceAccount;
                        CALCFIELDS("Allocated Appreciation %");
                        IF "Allocated Appreciation %" > 100 THEN
                            FIELDERROR("Allocated Appreciation %", FieldErrorText);
                    END;
                FAPostingType::Custom1:
                    BEGIN
                        GLAccNo := GetCustom1ExpenseAccount;
                        CALCFIELDS("Allocated Custom 1 %");
                        IF "Allocated Custom 1 %" > 100 THEN
                            FIELDERROR("Allocated Custom 1 %", FieldErrorText);
                    END;
                FAPostingType::Custom2:
                    BEGIN
                        GLAccNo := GetCustom2ExpenseAccount;
                        CALCFIELDS("Allocated Custom 2 %");
                        IF "Allocated Custom 2 %" > 100 THEN
                            FIELDERROR("Allocated Custom 2 %", FieldErrorText);
                    END;
                FAPostingType::Disposal:
                    BEGIN
                        GLAccNo := GetSalesBalanceAccount;
                        CALCFIELDS("Allocated Sales Price %");
                        IF "Allocated Sales Price %" > 100 THEN
                            FIELDERROR("Allocated Sales Price %", FieldErrorText);
                    END;
                FAPostingType::Maintenance:
                    BEGIN
                        GLAccNo := GetMaintenanceBalanceAccount;
                        CALCFIELDS("Allocated Maintenance %");
                        IF "Allocated Maintenance %" > 100 THEN
                            FIELDERROR("Allocated Maintenance %", FieldErrorText);
                    END;
                FAPostingType::Gain:
                    BEGIN
                        GLAccNo := GetGainsAccountOnDisposal;
                        CALCFIELDS("Allocated Gain %");
                        IF "Allocated Gain %" > 100 THEN
                            FIELDERROR("Allocated Gain %", FieldErrorText);
                    END;
                FAPostingType::Loss:
                    BEGIN
                        GLAccNo := GetLossesAccountOnDisposal;
                        CALCFIELDS("Allocated Loss %");
                        IF "Allocated Loss %" > 100 THEN
                            FIELDERROR("Allocated Loss %", FieldErrorText);
                    END;
                FAPostingType::"Book Value Gain":
                    BEGIN
                        GLAccNo := GetBookValueAccountOnDisposalGain;
                        CALCFIELDS("Allocated Book Value % (Gain)");
                        IF "Allocated Book Value % (Gain)" > 100 THEN
                            FIELDERROR("Allocated Book Value % (Gain)", FieldErrorText);
                    END;
                FAPostingType::"Book Value Loss":
                    BEGIN
                        GLAccNo := GetBookValueAccountOnDisposalLoss;
                        CALCFIELDS("Allocated Book Value % (Loss)");
                        IF "Allocated Book Value % (Loss)" > 100 THEN
                            FIELDERROR("Allocated Book Value % (Loss)", FieldErrorText);
                    END;
            END;
        EXIT(GLAccNo);
    END;

    LOCAL PROCEDURE CalculateNoOfEmptyLines(VAR GenJnlLine: Record 81; NumberOfEntries: Integer);
    VAR
        GenJnlLine2: Record 81;
    BEGIN
        GenJnlLine2."Journal Template Name" := GenJnlLine."Journal Template Name";
        GenJnlLine2."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        GenJnlLine2."Line No." := GenJnlLine."Line No.";
        GenJnlLine2.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine2.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        NextLineNo := GenJnlLine."Line No.";
        IF NoOfEmptyLines2 > 0 THEN
            NoOfEmptyLines := NoOfEmptyLines2
        ELSE BEGIN
            IF GenJnlLine2.NEXT = 0 THEN
                NoOfEmptyLines := 1000
            ELSE
                NoOfEmptyLines := (GenJnlLine2."Line No." - NextLineNo) DIV (NumberOfEntries + 1);
            IF NoOfEmptyLines < 1 THEN
                ERROR(Text001);
        END;
    END;

    LOCAL PROCEDURE InsertGenJnlLine(VAR GenJnlLine: Record 81);
    VAR
        FAJnlSetup: Record 5605;
    BEGIN
        NextLineNo := NextLineNo + NoOfEmptyLines;
        GenJnlLine."Line No." := NextLineNo;
        FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
        GenJnlLine.INSERT(TRUE);
    END;

    LOCAL PROCEDURE InsertBufferEntry();
    BEGIN
        IF TempFAGLPostBuf.FIND('+') THEN
            NextEntryNo := TempFAGLPostBuf."Entry No." + 1
        ELSE
            NextEntryNo := GLEntryNo;
        TempFAGLPostBuf := FAGLPostBuf;
        TempFAGLPostBuf."Entry No." := NextEntryNo;
        TempFAGLPostBuf."Original General Journal Line" := OrgGenJnlLine;
        TempFAGLPostBuf."Net Disposal" := NetDisp;
        TempFAGLPostBuf.INSERT;
        NumberOfEntries := NumberOfEntries + 1;
    END;

    //[External]
    PROCEDURE FindFirstGLAcc(VAR FAGLPostBuf: Record 5637): Boolean;
    VAR
        ReturnValue: Boolean;
    BEGIN
        ReturnValue := TempFAGLPostBuf.FIND('-');
        FAGLPostBuf := TempFAGLPostBuf;
        EXIT(ReturnValue);
    END;

    LOCAL PROCEDURE CalcDisposalAmount(FALedgEntry: Record 5601);
    BEGIN
        DisposalEntryNo := TempFAGLPostBuf."Entry No.";
        WITH FALedgEntry DO BEGIN
            FADeprBook.GET("FA No.", "Depreciation Book Code");
            FADeprBook.CALCFIELDS("Proceeds on Disposal", "Gain/Loss");
            DisposalAmount := FADeprBook."Proceeds on Disposal";
            GainLossAmount := FADeprBook."Gain/Loss";
            FAPostingGr2.GET("FA Posting Group");
        END;
    END;

    LOCAL PROCEDURE CorrectDisposalEntry();
    VAR
        LastDisposal: Boolean;
        GLAmount: Decimal;
    BEGIN
        TempFAGLPostBuf.GET(DisposalEntryNo);
        FADeprBook.CALCFIELDS("Gain/Loss");
        LastDisposal := CalcLastDisposal(FADeprBook);
        IF LastDisposal THEN
            GLAmount := GainLossAmount
        ELSE
            GLAmount := FADeprBook."Gain/Loss";
        IF GLAmount <= 0 THEN
            TempFAGLPostBuf."Account No." := FAPostingGr2.GetSalesAccountOnDisposalGain
        ELSE
            TempFAGLPostBuf."Account No." := FAPostingGr2.GetSalesAccountOnDisposalLoss;
        TempFAGLPostBuf.MODIFY;
        FAGLPostBuf := TempFAGLPostBuf;
        IF LastDisposal THEN
            EXIT;
        IF IdenticalSign(FADeprBook."Gain/Loss", GainLossAmount, DisposalAmount) THEN
            EXIT;
        IF FAPostingGr2.GetSalesAccountOnDisposalGain = FAPostingGr2.GetSalesAccountOnDisposalLoss THEN
            EXIT;
        FAGLPostBuf."FA Entry No." := 0;
        FAGLPostBuf."FA Entry Type" := FAGLPostBuf."FA Entry Type"::" ";
        FAGLPostBuf."Automatic Entry" := TRUE;
        OrgGenJnlLine := FALSE;
        IF FADeprBook."Gain/Loss" <= 0 THEN BEGIN
            FAGLPostBuf."Account No." := FAPostingGr2.GetSalesAccountOnDisposalGain;
            FAGLPostBuf.Amount := DisposalAmount;
            InsertBufferEntry;
            FAGLPostBuf."Account No." := FAPostingGr2.GetSalesAccountOnDisposalLoss;
            FAGLPostBuf.Amount := -DisposalAmount;
            FAGLPostBuf.Correction := NOT FAGLPostBuf.Correction;
            InsertBufferEntry;
        END ELSE BEGIN
            FAGLPostBuf."Account No." := FAPostingGr2.GetSalesAccountOnDisposalLoss;
            FAGLPostBuf.Amount := DisposalAmount;
            InsertBufferEntry;
            FAGLPostBuf."Account No." := FAPostingGr2.GetSalesAccountOnDisposalGain;
            FAGLPostBuf.Amount := -DisposalAmount;
            FAGLPostBuf.Correction := NOT FAGLPostBuf.Correction;
            InsertBufferEntry;
        END;
    END;

    LOCAL PROCEDURE CorrectBookValueEntry();
    VAR
        FALedgEntry: Record 5601;
        FAGLPostBuf: Record 5637;
        DepreciationCalc: Codeunit 5616;
        BookValueAmount: Decimal;
    BEGIN
        DepreciationCalc.SetFAFilter(
          FALedgEntry, FADeprBook."FA No.", FADeprBook."Depreciation Book Code", TRUE);
        FALedgEntry.SETRANGE("FA Posting Category", FALedgEntry."FA Posting Category"::Disposal);
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Book Value on Disposal");
        FALedgEntry.CALCSUMS(Amount);
        BookValueAmount := FALedgEntry.Amount;
        TempFAGLPostBuf.GET(DisposalEntryNo);
        FAGLPostBuf := TempFAGLPostBuf;
        IF IdenticalSign(FADeprBook."Gain/Loss", GainLossAmount, BookValueAmount) THEN
            EXIT;
        IF FAPostingGr2.GetBookValueAccountOnDisposalGain = FAPostingGr2.GetBookValueAccountOnDisposalLoss THEN
            EXIT;
        OrgGenJnlLine := FALSE;
        IF FADeprBook."Gain/Loss" <= 0 THEN BEGIN
            InsertBufferBalAcc(
              10,
              BookValueAmount,
              FADeprBook."Depreciation Book Code",
              FAPostingGr2.Code,
              FAGLPostBuf."Global Dimension 1 Code",
              FAGLPostBuf."Global Dimension 2 Code",
              FAGLPostBuf."Dimension Set ID",
              TRUE, FAGLPostBuf.Correction);

            InsertBufferBalAcc(
              11,
              -BookValueAmount,
              FADeprBook."Depreciation Book Code",
              FAPostingGr2.Code,
              FAGLPostBuf."Global Dimension 1 Code",
              FAGLPostBuf."Global Dimension 2 Code",
              FAGLPostBuf."Dimension Set ID",
              TRUE, NOT FAGLPostBuf.Correction);
        END ELSE BEGIN
            InsertBufferBalAcc(
              11,
              BookValueAmount,
              FADeprBook."Depreciation Book Code",
              FAPostingGr2.Code,
              FAGLPostBuf."Global Dimension 1 Code",
              FAGLPostBuf."Global Dimension 2 Code",
              FAGLPostBuf."Dimension Set ID",
              TRUE, FAGLPostBuf.Correction);

            InsertBufferBalAcc(
              10,
              -BookValueAmount,
              FADeprBook."Depreciation Book Code",
              FAPostingGr2.Code,
              FAGLPostBuf."Global Dimension 1 Code",
              FAGLPostBuf."Global Dimension 2 Code",
              FAGLPostBuf."Dimension Set ID",
              TRUE, NOT FAGLPostBuf.Correction);
        END;
    END;

    LOCAL PROCEDURE IdenticalSign(A: Decimal; B: Decimal; C: Decimal): Boolean;
    BEGIN
        EXIT(((A <= 0) = (B <= 0)) OR (C = 0));
    END;

    LOCAL PROCEDURE CalcLastDisposal(FADeprBook: Record 5612): Boolean;
    VAR
        FALedgEntry: Record 5601;
        DepreciationCalc: Codeunit 5616;
    BEGIN
        DepreciationCalc.SetFAFilter(
          FALedgEntry, FADeprBook."FA No.", FADeprBook."Depreciation Book Code", TRUE);
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Proceeds on Disposal");
        EXIT(NOT FALedgEntry.FINDFIRST);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetBalAccAfterSaveGenJnlLineFields(VAR ToGenJnlLine: Record 81; FromGenJnlLine: Record 81; VAR SkipInsert: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetBalAccAfterRestoreGenJnlLineFields(VAR ToGenJnlLine: Record 81; FromGenJnlLine: Record 81);
    BEGIN
    END;

    [IntegrationEvent(false,false)]
    PROCEDURE cdu5601_OnAfterRun(VAR Rec: Record 5601; VAR TempFAGLPostBuf: Record 5637 TEMPORARY; NumberOfEntries: Integer; OrgGenJnlLine: Boolean; NetDisp: Boolean; FAGLPostBuf: Record 5637; DisposalEntry: Boolean; BookValueEntry: Boolean; NextEntryNo: Integer; GLEntryNo: Integer; DisposalEntryNo: Integer; DisposalAmount: Decimal; GainLossAmount: Decimal; FAPostingGr2: Record 5606);
    BEGIN
        //Copia de evento BC14 AML 19/10/23
    END;

    /*BEGIN
/*{
      PEL 21/05/18: - QVE_1853 A�adido GLAccNo a InsertBufferBalAcc2CUFAInsertGLAccount
      JAV 17/10/20: - QB 1.06.21 Se eliminan la funci�n "GetBalAccCUAFInsertGLAccount" que no hace nada
      AML 17/10/23: - SE a�ade Suscripcion OnfAfterRun igual que BC14.
    }
END.*/
}









