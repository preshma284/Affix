Codeunit 50274 "VendEntry-ApplyPostedEntries1"
{


    TableNo = 25;
    Permissions = TableData 25 = rimd;
    EventSubscriberInstance = Manual;
    trigger OnRun()
    BEGIN
        IF PreviewMode THEN
            CASE RunOptionPreviewContext OF
                RunOptionPreview::Apply:
                    Apply(Rec, DocumentNoPreviewContext, ApplicationDatePreviewContext);
                RunOptionPreview::Unapply:
                    PostUnApplyVendor(DetailedVendorLedgEntryPreviewContext, DocumentNoPreviewContext, ApplicationDatePreviewContext);
            END
        ELSE
            Apply(Rec, rec."Document No.", 0D);
    END;

    VAR
        PostingApplicationMsg: TextConst ENU = 'Posting application...', ESP = 'Registrando liquidaci�n...';
        MustNotBeBeforeErr: TextConst ENU = 'The posting date entered must not be before the posting date on the vendor ledger entry.', ESP = 'La fecha de registro especificada no debe ser anterior a la fecha de registro del movimiento de proveedor.';
        NoEntriesAppliedErr: TextConst ENU = 'Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.', ESP = 'No se puede registrar porque no especific� qu� movimiento quiere aplicar. Debe especificar un movimiento en el campo %1 para seleccionar uno o varios movimientos.';
        UnapplyPostedAfterThisEntryErr: TextConst ENU = 'Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.', ESP = 'Para poder aplicar este movimiento antes debe desliquidar todos los movimientos de liquidaci�n registrados despu�s del mismo.';
        NoApplicationEntryErr: TextConst ENU = 'Vendor Ledger Entry No. %1 does not have an application entry.', ESP = 'El n� de movimiento de proveedor %1 no tiene movimiento de liquidaci�n.';
        UnapplyingMsg: TextConst ENU = 'Unapplying and posting...', ESP = 'Desliquidando y registrando...';
        UnapplyAllPostedAfterThisEntryErr: TextConst ENU = 'Before you can unapply this entry, you must first unapply all application entries in Vendor Ledger Entry No. %1 that were posted after this entry.', ESP = 'Para poder desliquidar este movimiento, antes debe desliquidar todos los movimientos de liquidaci�n del n� de movimiento de proveedor %1 registrados despu�s del mismo.';
        NotAllowedPostingDatesErr: TextConst ENU = 'Posting date is not within the range of allowed posting dates.', ESP = 'La fecha de registro no est� comprendida en el periodo de fechas de registro permitidas.';
        LatestEntryMustBeApplicationErr: TextConst ENU = 'The latest Transaction No. must be an application in Vendor Ledger Entry No. %1.', ESP = 'El n� de transacci�n m�s reciente debe ser una liquidaci�n en el n� de movimiento de proveedor %1.';
        CannotUnapplyExchRateErr: TextConst ENU = 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.', ESP = 'No puede desliquidar una entrada con fecha de registro %1, el tipo de cambio de la moneda de la divisa de informe adicional ha sido modificado.';
        CannotUnapplyInReversalErr: TextConst ENU = 'You cannot unapply Vendor Ledger Entry No. %1 because the entry is part of a reversal.', ESP = 'No puede desliquidar el n� de movimiento de proveedor %1 porque forma parte de una retrocesi�n.';
        CannotApplyClosedEntriesErr: TextConst ENU = 'One or more of the entries that you selected is closed. You cannot apply closed entries.', ESP = 'Uno o varios de los movimientos que ha seleccionado est�n liquidados. No puede liquidar movimientos liquidados.';
        Text1100000: TextConst ENU = 'Application of %1 %2', ESP = 'Liquidaci�n de %1 %2';
        Text1100001: TextConst ENU = 'Application of %1 %2/%3', ESP = 'Liquidaci�n de %1 %2/%3';
        Text1100002: TextConst ENU = 'To apply a set of entries containing bills, the cursor should be positioned on an entry different than bill type or Invoice to cartera type.', ESP = 'Para liquidar un conjunto de movs. con efectos, debe situar el cursor sobre un mov. de un tipo diferente a efecto o factura a cartera.';
        Text1100003: TextConst ENU = 'You cannot unapply the entry.', ESP = 'No puede desliquidar el movimiento.';
        DetailedVendorLedgEntryPreviewContext: Record 380;
        ApplicationDatePreviewContext: Date;
        DocumentNoPreviewContext: Code[20];
        RunOptionPreview: Option "Apply","Unapply";
        RunOptionPreviewContext: Option "Apply","Unapply";
        PreviewMode: Boolean;

    //[External]
    PROCEDURE Apply(VendLedgEntry: Record 25; DocumentNo: Code[20]; ApplicationDate: Date): Boolean;
    VAR
        PaymentToleranceMgt: Codeunit 426;
        SIIJobUploadPendingDocs: Codeunit 50025;
    BEGIN
        WITH VendLedgEntry DO BEGIN
            IF ("Document Type" = "Document Type"::Bill) OR
               (("Document Type" = "Document Type"::Invoice) AND
                ("Document Situation" = "Document Situation"::Cartera) AND
                ("Document Status" = "Document Status"::Open))
            THEN
                ERROR(Text1100002);

            IF NOT PreviewMode THEN
                IF NOT PaymentToleranceMgt.PmtTolVend(VendLedgEntry) THEN
                    EXIT(FALSE);
            GET("Entry No.");

            IF ApplicationDate = 0D THEN
                ApplicationDate := GetApplicationDate(VendLedgEntry)
            ELSE
                IF ApplicationDate < GetApplicationDate(VendLedgEntry) THEN
                    ERROR(MustNotBeBeforeErr);

            IF DocumentNo = '' THEN
                DocumentNo := "Document No.";

            VendPostApplyVendLedgEntry(VendLedgEntry, DocumentNo, ApplicationDate);
            SIIJobUploadPendingDocs.OnVendorEntriesApplied(VendLedgEntry);
            EXIT(TRUE);
        END;
    END;

    //[External]
    PROCEDURE GetApplicationDate(VendLedgEntry: Record 25) ApplicationDate: Date;
    VAR
        ApplyToVendLedgEntry: Record 25;
    BEGIN
        WITH VendLedgEntry DO BEGIN
            ApplicationDate := 0D;
            ApplyToVendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID");
            ApplyToVendLedgEntry.SETRANGE("Vendor No.", "Vendor No.");
            ApplyToVendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
            ApplyToVendLedgEntry.FIND('-');
            REPEAT
                IF ApplyToVendLedgEntry."Posting Date" > ApplicationDate THEN
                    ApplicationDate := ApplyToVendLedgEntry."Posting Date";
            UNTIL ApplyToVendLedgEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE VendPostApplyVendLedgEntry(VendLedgEntry: Record 25; DocumentNo: Code[20]; ApplicationDate: Date);
    VAR
        SourceCodeSetup: Record 242;
        GenJnlLine: Record 81;
        UpdateAnalysisView: Codeunit 410;
        GenJnlPostLine: Codeunit 12;
        GenJnlPostLine1: Codeunit 50001;
        GenJnlPostPreview: Codeunit 19;
        Window: Dialog;
        EntryNoBeforeApplication: Integer;
        EntryNoAfterApplication: Integer;
    BEGIN
        WITH VendLedgEntry DO BEGIN
            Window.OPEN(PostingApplicationMsg);

            SourceCodeSetup.GET;

            GenJnlLine.INIT;
            GenJnlLine."Document No." := DocumentNo;
            GenJnlLine."Posting Date" := ApplicationDate;
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := "Vendor No.";
            CALCFIELDS("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
            GenJnlLine.Correction :=
              ("Debit Amount" < 0) OR ("Credit Amount" < 0) OR
              ("Debit Amount (LCY)" < 0) OR ("Credit Amount (LCY)" < 0);
            GenJnlLine."Document Type" := "Document Type";
            IF "Document Type" <> "Document Type"::Bill THEN
                GenJnlLine.Description := STRSUBSTNO(Text1100000, "Document Type", "Document No.")
            ELSE
                GenJnlLine.Description := STRSUBSTNO(Text1100001, "Document Type", "Document No.", "Bill No.");
            GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";
            GenJnlLine."Posting Group" := "Vendor Posting Group";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := "Vendor No.";
            GenJnlLine."Source Code" := SourceCodeSetup."Purchase Entry Application";
            GenJnlLine."System-Created Entry" := TRUE;

            EntryNoBeforeApplication := FindLastApplDtldVendLedgEntry;

            GenJnlPostLine.SetIDBillSettlement(BeAppliedToBill(VendLedgEntry));
            OnBeforePostApplyVendLedgEntry(GenJnlLine, VendLedgEntry);
            GenJnlPostLine.VendPostApplyVendLedgEntry(GenJnlLine, VendLedgEntry);
            OnAfterPostApplyVendLedgEntry(GenJnlLine, VendLedgEntry);

            EntryNoAfterApplication := FindLastApplDtldVendLedgEntry;
            IF EntryNoAfterApplication = EntryNoBeforeApplication THEN
                ERROR(NoEntriesAppliedErr, GenJnlLine.FIELDCAPTION("Applies-to ID"));

            IF PreviewMode THEN
                GenJnlPostPreview.ThrowError;

            COMMIT;
            Window.CLOSE;
            UpdateAnalysisView.UpdateAll(0, TRUE);
        END;
    END;

    LOCAL PROCEDURE FindLastApplDtldVendLedgEntry(): Integer;
    VAR
        DtldVendLedgEntry: Record 380;
    BEGIN
        DtldVendLedgEntry.LOCKTABLE;
        IF DtldVendLedgEntry.FINDLAST THEN
            EXIT(DtldVendLedgEntry."Entry No.");

        EXIT(0);
    END;

    LOCAL PROCEDURE FindLastApplEntry(VendLedgEntryNo: Integer): Integer;
    VAR
        DtldVendLedgEntry: Record 380;
        ApplicationEntryNo: Integer;
    BEGIN
        WITH DtldVendLedgEntry DO BEGIN
            SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type");
            SETRANGE("Vendor Ledger Entry No.", VendLedgEntryNo);
            SETRANGE("Entry Type", "Entry Type"::Application);
            SETRANGE(Unapplied, FALSE);
            ApplicationEntryNo := 0;
            IF FIND('-') THEN
                REPEAT
                    IF "Entry No." > ApplicationEntryNo THEN
                        ApplicationEntryNo := "Entry No.";
                UNTIL NEXT = 0;
        END;
        EXIT(ApplicationEntryNo);
    END;

    LOCAL PROCEDURE FindLastTransactionNo(VendLedgEntryNo: Integer): Integer;
    VAR
        DtldVendLedgEntry: Record 380;
        LastTransactionNo: Integer;
    BEGIN
        WITH DtldVendLedgEntry DO BEGIN
            SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type");
            SETRANGE("Vendor Ledger Entry No.", VendLedgEntryNo);
            SETRANGE(Unapplied, FALSE);
            SETFILTER("Entry Type", '<>%1&<>%2', "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
            LastTransactionNo := 0;
            IF FINDSET THEN
                REPEAT
                    IF LastTransactionNo < "Transaction No." THEN
                        LastTransactionNo := "Transaction No.";
                UNTIL NEXT = 0;
        END;
        EXIT(LastTransactionNo);
    END;

  

    //[External]
    PROCEDURE UnApplyVendLedgEntry(VendLedgEntryNo: Integer);
    VAR
        DtldVendLedgEntry: Record 380;
        ApplicationEntryNo: Integer;
    BEGIN
        CheckReversal(VendLedgEntryNo);
        ApplicationEntryNo := FindLastApplEntry(VendLedgEntryNo);
        IF ApplicationEntryNo = 0 THEN
            ERROR(NoApplicationEntryErr, VendLedgEntryNo);
        DtldVendLedgEntry.GET(ApplicationEntryNo);
        UnApplyVendor(DtldVendLedgEntry);
    END;

    LOCAL PROCEDURE UnApplyVendor(DtldVendLedgEntry: Record 380);
    VAR
        UnapplyVendEntries: Page 624;
    BEGIN
        WITH DtldVendLedgEntry DO BEGIN
            TESTFIELD("Entry Type", "Entry Type"::Application);
            TESTFIELD(Unapplied, FALSE);
            UnapplyVendEntries.SetDtldVendLedgEntry("Entry No.");
            UnapplyVendEntries.LOOKUPMODE(TRUE);
            UnapplyVendEntries.RUNMODAL;
        END;
    END;

    //[External]
    PROCEDURE PostUnApplyVendor(DtldVendLedgEntry2: Record 380; DocNo: Code[20]; PostingDate: Date);
    VAR
        GLEntry: Record 17;
        VendLedgEntry: Record 25;
        DtldVendLedgEntry: Record 380;
        SourceCodeSetup: Record 242;
        GenJnlLine: Record 81;
        DateComprReg: Record 87;
        TempVendorLedgerEntry: Record 25 TEMPORARY;
        AdjustExchangeRates: Report 595;
        GenJnlPostLine: Codeunit 12;
        GenJnlPostPreview: Codeunit 19;
        Window: Dialog;
        LastTransactionNo: Integer;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
    BEGIN
        MaxPostingDate := 0D;
        GLEntry.LOCKTABLE;
        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;
        VendLedgEntry.GET(DtldVendLedgEntry2."Vendor Ledger Entry No.");
        CheckPostingDate(PostingDate, MaxPostingDate);
        IF PostingDate < DtldVendLedgEntry2."Posting Date" THEN
            ERROR(MustNotBeBeforeErr);
        IF DtldVendLedgEntry2."Transaction No." = 0 THEN BEGIN
            DtldVendLedgEntry.SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SETRANGE("Application No.", DtldVendLedgEntry2."Application No.");
        END ELSE BEGIN
            DtldVendLedgEntry.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SETRANGE("Transaction No.", DtldVendLedgEntry2."Transaction No.");
        END;
        DtldVendLedgEntry.SETRANGE("Vendor No.", DtldVendLedgEntry2."Vendor No.");
        DtldVendLedgEntry.SETFILTER("Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DtldVendLedgEntry.FIND('-') THEN
            REPEAT
                IF NOT AddCurrChecked THEN BEGIN
                    CheckAdditionalCurrency(PostingDate, DtldVendLedgEntry."Posting Date");
                    AddCurrChecked := TRUE;
                END;
                IF DtldVendLedgEntry."Initial Document Type" = DtldVendLedgEntry."Initial Document Type"::" " THEN
                    ERROR(Text1100003);
                CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
                IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
                    IF DtldVendLedgEntry."Entry Type" = DtldVendLedgEntry."Entry Type"::Application THEN BEGIN
                        LastTransactionNo :=
                          FindLastApplTransactionEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");
                        IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") THEN
                            ERROR(UnapplyAllPostedAfterThisEntryErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
                    END;
                    LastTransactionNo := FindLastTransactionNo(DtldVendLedgEntry."Vendor Ledger Entry No.");
                    IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") THEN
                        ERROR(LatestEntryMustBeApplicationErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
                END;
            UNTIL DtldVendLedgEntry.NEXT = 0;

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate, 0);

        WITH DtldVendLedgEntry2 DO BEGIN
            SourceCodeSetup.GET;
            VendLedgEntry.GET("Vendor Ledger Entry No.");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := "Vendor No.";
            GenJnlLine.Correction := TRUE;
            GenJnlLine."Document Type" := "Document Type";
            GenJnlLine.Description := VendLedgEntry.Description;
            GenJnlLine."Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
            GenJnlLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := "Vendor No.";
            GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Purch. Entry Appln.";
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."System-Created Entry" := TRUE;
            Window.OPEN(UnapplyingMsg);
            OnBeforePostUnapplyVendLedgEntry(GenJnlLine, VendLedgEntry, DtldVendLedgEntry2);
            CollectAffectedLedgerEntries(TempVendorLedgerEntry, DtldVendLedgEntry2);
            GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine, DtldVendLedgEntry2);
            AdjustExchangeRates.AdjustExchRateVend(GenJnlLine, TempVendorLedgerEntry);
            OnAfterPostUnapplyVendLedgEntry(GenJnlLine, VendLedgEntry, DtldVendLedgEntry2);

            IF PreviewMode THEN
                GenJnlPostPreview.ThrowError;

            COMMIT;
            Window.CLOSE;
        END;
    END;

    LOCAL PROCEDURE CheckPostingDate(PostingDate: Date; VAR MaxPostingDate: Date);
    VAR
        GenJnlCheckLine: Codeunit 11;
    BEGIN
        IF GenJnlCheckLine.DateNotAllowed(PostingDate) THEN
            ERROR(NotAllowedPostingDatesErr);

        IF PostingDate > MaxPostingDate THEN
            MaxPostingDate := PostingDate;
    END;

    LOCAL PROCEDURE CheckAdditionalCurrency(OldPostingDate: Date; NewPostingDate: Date);
    VAR
        GLSetup: Record 98;
        CurrExchRate: Record 330;
    BEGIN
        IF OldPostingDate = NewPostingDate THEN
            EXIT;
        GLSetup.GET;
        IF GLSetup."Additional Reporting Currency" <> '' THEN
            IF CurrExchRate.ExchangeRate(OldPostingDate, GLSetup."Additional Reporting Currency") <>
               CurrExchRate.ExchangeRate(NewPostingDate, GLSetup."Additional Reporting Currency")
            THEN
                ERROR(CannotUnapplyExchRateErr, NewPostingDate);
    END;

    LOCAL PROCEDURE CheckReversal(VendLedgEntryNo: Integer);
    VAR
        VendLedgEntry: Record 25;
    BEGIN
        VendLedgEntry.GET(VendLedgEntryNo);
        IF VendLedgEntry.Reversed THEN
            ERROR(CannotUnapplyInReversalErr, VendLedgEntryNo);
    END;

    //[External]
    PROCEDURE ApplyVendEntryFormEntry(VAR ApplyingVendLedgEntry: Record 25);
    VAR
        VendLedgEntry: Record 25;
        ApplyVendEntries: Page 233;
        VendEntryApplID: Code[50];
    BEGIN
        IF NOT ApplyingVendLedgEntry.Open THEN
            ERROR(CannotApplyClosedEntriesErr);

        VendEntryApplID := USERID;
        IF VendEntryApplID = '' THEN
            VendEntryApplID := '***';
        IF ApplyingVendLedgEntry."Remaining Amount" = 0 THEN
            ApplyingVendLedgEntry.CALCFIELDS("Remaining Amount");

        ApplyingVendLedgEntry."Applying Entry" := TRUE;
        IF ApplyingVendLedgEntry."Applies-to ID" = '' THEN
            ApplyingVendLedgEntry."Applies-to ID" := VendEntryApplID;
        ApplyingVendLedgEntry."Amount to Apply" := ApplyingVendLedgEntry."Remaining Amount";
        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", ApplyingVendLedgEntry);
        COMMIT;

        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
        VendLedgEntry.SETRANGE("Vendor No.", ApplyingVendLedgEntry."Vendor No.");
        VendLedgEntry.SETRANGE(Open, TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
            ApplyVendEntries.SetVendLedgEntry(ApplyingVendLedgEntry);
            ApplyVendEntries.SETRECORD(VendLedgEntry);
            ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
            IF ApplyingVendLedgEntry."Applies-to ID" <> VendEntryApplID THEN
                ApplyVendEntries.SetAppliesToID(ApplyingVendLedgEntry."Applies-to ID");
            ApplyVendEntries.RUNMODAL;
            CLEAR(ApplyVendEntries);
            ApplyingVendLedgEntry."Applying Entry" := FALSE;
            ApplyingVendLedgEntry."Applies-to ID" := '';
            ApplyingVendLedgEntry."Amount to Apply" := 0;
        END;
    END;

    LOCAL PROCEDURE CollectAffectedLedgerEntries(VAR TempVendorLedgerEntry: Record 25 TEMPORARY; DetailedVendorLedgEntry2: Record 380);
    VAR
        DetailedVendorLedgEntry: Record 380;
    BEGIN
        TempVendorLedgerEntry.DELETEALL;
        WITH DetailedVendorLedgEntry DO BEGIN
            IF DetailedVendorLedgEntry2."Transaction No." = 0 THEN BEGIN
                SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
                SETRANGE("Application No.", DetailedVendorLedgEntry2."Application No.");
            END ELSE BEGIN
                SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
                SETRANGE("Transaction No.", DetailedVendorLedgEntry2."Transaction No.");
            END;
            SETRANGE("Vendor No.", DetailedVendorLedgEntry2."Vendor No.");
            SETRANGE(Unapplied, FALSE);
            SETFILTER("Entry Type", '<>%1', "Entry Type"::"Initial Entry");
            IF FINDSET THEN
                REPEAT
                    TempVendorLedgerEntry."Entry No." := "Vendor Ledger Entry No.";
                    IF TempVendorLedgerEntry.INSERT THEN;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE FindLastApplTransactionEntry(VendLedgEntryNo: Integer): Integer;
    VAR
        DtldVendLedgEntry: Record 380;
        LastTransactionNo: Integer;
    BEGIN
        DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        LastTransactionNo := 0;
        IF DtldVendLedgEntry.FIND('-') THEN
            REPEAT
                IF (DtldVendLedgEntry."Transaction No." > LastTransactionNo) AND NOT DtldVendLedgEntry.Unapplied THEN
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            UNTIL DtldVendLedgEntry.NEXT = 0;
        EXIT(LastTransactionNo);
    END;

    LOCAL PROCEDURE BeAppliedToBill(VendLedgEntry2: Record 25): Boolean;
    VAR
        VendLedgEntry3: Record 25;
    BEGIN
        IF VendLedgEntry2."Applies-to ID" = '' THEN
            EXIT(FALSE);
        WITH VendLedgEntry3 DO BEGIN
            SETCURRENTKEY("Applies-to ID", "Document Type");
            SETRANGE("Applies-to ID", VendLedgEntry2."Applies-to ID");
            SETRANGE("Document Type", VendLedgEntry2."Document Type"::Bill);
            IF NOT ISEMPTY THEN
                EXIT(TRUE);
            EXIT(FALSE);
        END;
    END;

    //[External]
    PROCEDURE PreviewApply(VendorLedgerEntry: Record 25; DocumentNo: Code[20]; ApplicationDate: Date);
    VAR
        GenJnlPostPreview: Codeunit 19;
        VendEntryApplyPostedEntries: Codeunit 227;
        VendEntryApplyPostedEntries1: Codeunit 50274;
        PaymentToleranceMgt: Codeunit 426;
    BEGIN
        IF NOT PaymentToleranceMgt.PmtTolVend(VendorLedgerEntry) THEN
            EXIT;

        BINDSUBSCRIPTION(VendEntryApplyPostedEntries);
        VendEntryApplyPostedEntries1.SetApplyContext(ApplicationDate, DocumentNo);
        GenJnlPostPreview.Preview(VendEntryApplyPostedEntries, VendorLedgerEntry);
    END;

    //[External]
    PROCEDURE PreviewUnapply(DetailedVendorLedgEntry: Record 380; DocumentNo: Code[20]; ApplicationDate: Date);
    VAR
        VendorLedgerEntry: Record 25;
        GenJnlPostPreview: Codeunit 19;
        VendEntryApplyPostedEntries: Codeunit 227;
        VendEntryApplyPostedEntries1: Codeunit 50274;
    BEGIN
        BINDSUBSCRIPTION(VendEntryApplyPostedEntries);
        VendEntryApplyPostedEntries1.SetUnapplyContext(DetailedVendorLedgEntry, ApplicationDate, DocumentNo);
        GenJnlPostPreview.Preview(VendEntryApplyPostedEntries, VendorLedgerEntry);
    END;

    //[External]
    PROCEDURE SetApplyContext(ApplicationDate: Date; DocumentNo: Code[20]);
    BEGIN
        ApplicationDatePreviewContext := ApplicationDate;
        DocumentNoPreviewContext := DocumentNo;
        RunOptionPreviewContext := RunOptionPreview::Apply;
    END;

    //[External]
    PROCEDURE SetUnapplyContext(VAR DetailedVendorLedgEntry: Record 380; ApplicationDate: Date; DocumentNo: Code[20]);
    BEGIN
        ApplicationDatePreviewContext := ApplicationDate;
        DocumentNoPreviewContext := DocumentNo;
        DetailedVendorLedgEntryPreviewContext := DetailedVendorLedgEntry;
        RunOptionPreviewContext := RunOptionPreview::Unapply;
    END;

  

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostApplyVendLedgEntry(GenJournalLine: Record 81; VendorLedgerEntry: Record 25);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostUnapplyVendLedgEntry(GenJournalLine: Record 81; VendorLedgerEntry: Record 25; DetailedVendorLedgEntry: Record 380);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostApplyVendLedgEntry(VAR GenJournalLine: Record 81; VendorLedgerEntry: Record 25);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostUnapplyVendLedgEntry(VAR GenJournalLine: Record 81; VendorLedgerEntry: Record 25; DetailedVendorLedgEntry: Record 380);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}





