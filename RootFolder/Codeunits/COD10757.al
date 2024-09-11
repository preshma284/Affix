Codeunit 51304 "SII Recreate Missing Entries 1"
{


    trigger OnRun()
    VAR
        SIISetup: Record 10751;
        TempVendorLedgerEntry: Record 25 TEMPORARY;
        TempCustLedgEntry: Record 21 TEMPORARY;
        TempDetailedVendorLedgEntry: Record 380 TEMPORARY;
        TempDetailedCustLedgEntry: Record 379 TEMPORARY;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        GetSourceEntries(
          TempVendorLedgerEntry, TempCustLedgEntry, TempDetailedVendorLedgEntry, TempDetailedCustLedgEntry, TRUE, SIISetup."Starting Date");
    END;

    VAR
        Window: Dialog;
        CollectEntriesMsg: TextConst ENU = 'Collecting entries to handle', ESP = 'Recopilando movs. para gestionarlos';
        CreateRequestMsg: TextConst ENU = 'Creating missing SII entries', ESP = 'Creando movs. SII que faltan';
        ProgressMsg: TextConst ENU = 'Processing #1##########\@@@@@@@@@@', ESP = 'Procesando #1##########\@@@@@@@@@@';
        JobType: Option "HandlePending","HandleCommError","InitialUpload";
        RecreateMissingEntryJobTxt: TextConst ENU = 'Recreating missing SII entries', ESP = 'Regenerando movs. SII que faltan';
        EntriesMissingTxt: TextConst ENU = '%1 SII entries missing', ESP = '%1 movs. SII que faltan';
        MissingEntriesRecreateTxt: TextConst ENU = '%1 missing entries have been recreated', ESP = 'Se han regenerado %1 movimientos que faltan';

    // PROCEDURE UploadMissingSIIDocuments(VAR TempVendorLedgerEntry: Record 25 TEMPORARY; VAR TempCustLedgerEntry: Record 21 TEMPORARY; VAR TempDetailedVendorLedgEntry: Record 380 TEMPORARY; VAR TempDetailedCustLedgEntry: Record 379 TEMPORARY);
    // VAR
    //     SIIMissingEntriesState: Record 10754;
    //     SIIJobManagement: Codeunit 51301;
    //     EntriesMissing: Integer;
    // BEGIN
    //     SIIMissingEntriesState.Initialize;
    //     EntriesMissing := SIIMissingEntriesState."Entries Missing";
    //     UploadMissingVendInvoices(TempVendorLedgerEntry, SIIMissingEntriesState."Last VLE No.");
    //     UploadMissingVendPayments(TempDetailedVendorLedgEntry, SIIMissingEntriesState."Last DVLE No.");
    //     UploadMissingCustInvoices(TempCustLedgerEntry, SIIMissingEntriesState."Last CLE No.");
    //     UploadMissingCustPayments(TempDetailedCustLedgEntry, SIIMissingEntriesState."Last DCLE No.");
    //     SIIMissingEntriesState."Entries Missing" := 0;
    //     SIIMissingEntriesState.MODIFY;
    //     SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    //     SendTraceTagOn(STRSUBSTNO(MissingEntriesRecreateTxt, FORMAT(EntriesMissing)));
    // END;

    // LOCAL PROCEDURE UploadMissingVendInvoices(VAR TempVendLedgerEntry: Record 25 TEMPORARY; VAR LastEntryNo: Integer);
    // VAR
    //     VendorLedgerEntry: Record 25;
    //     SIIJobUploadPendingDocs: Codeunit 50025;
    //     TotalRecNo: Integer;
    //     RecNo: Integer;
    // BEGIN
    //     IF TempVendLedgerEntry.FINDSET THEN BEGIN
    //         SetWindowSource(TotalRecNo, CreateRequestMsg, TempVendLedgerEntry);
    //         REPEAT
    //             UpdateWindowProgress(RecNo, TotalRecNo);
    //             VendorLedgerEntry := TempVendLedgerEntry;
    //             SIIJobUploadPendingDocs.CreateSIIRequestForVendLedgEntry(VendorLedgerEntry);
    //         UNTIL TempVendLedgerEntry.NEXT = 0;
    //         CloseWindow;
    //         LastEntryNo := TempVendLedgerEntry."Entry No.";
    //     END;
    // END;

    LOCAL PROCEDURE UploadMissingVendPayments(VAR TempDetailedVendorLedgEntry: Record 380 TEMPORARY; VAR LastEntryNo: Integer);
    VAR
        DetailedVendorLedgEntry: Record 380;
        SIIJobUploadPendingDocs: Codeunit 50025;
        TotalRecNo: Integer;
        RecNo: Integer;
    BEGIN
        IF TempDetailedVendorLedgEntry.FINDSET THEN BEGIN
            SetWindowSource(TotalRecNo, CreateRequestMsg, TempDetailedVendorLedgEntry);
            REPEAT
                UpdateWindowProgress(RecNo, TotalRecNo);
                DetailedVendorLedgEntry := TempDetailedVendorLedgEntry;
                SIIJobUploadPendingDocs.CreateSIIRequestForDtldVendLedgEntry(DetailedVendorLedgEntry);
            UNTIL TempDetailedVendorLedgEntry.NEXT = 0;
            CloseWindow;
            LastEntryNo := TempDetailedVendorLedgEntry."Entry No.";
        END;
    END;

    // LOCAL PROCEDURE UploadMissingCustInvoices(VAR TempCustLedgerEntry: Record 21 TEMPORARY; VAR LastEntryNo: Integer);
    // VAR
    //     CustLedgerEntry: Record 21;
    //     SIIJobUploadPendingDocs: Codeunit 50025;
    //     TotalRecNo: Integer;
    //     RecNo: Integer;
    // BEGIN
    //     IF TempCustLedgerEntry.FINDSET THEN BEGIN
    //         SetWindowSource(TotalRecNo, CreateRequestMsg, TempCustLedgerEntry);
    //         REPEAT
    //             UpdateWindowProgress(RecNo, TotalRecNo);
    //             CustLedgerEntry := TempCustLedgerEntry;
    //             SIIJobUploadPendingDocs.CreateSIIRequestForCustLedgEntry(CustLedgerEntry);
    //         UNTIL TempCustLedgerEntry.NEXT = 0;
    //         CloseWindow;
    //         LastEntryNo := TempCustLedgerEntry."Entry No.";
    //     END;
    // END;

    LOCAL PROCEDURE UploadMissingCustPayments(VAR TempDetailedCustLedgEntry: Record 379 TEMPORARY; VAR LastEntryNo: Integer);
    VAR
        DetailedCustLedgEntry: Record 379;
        SIIJobUploadPendingDocs: Codeunit 50025;
        TotalRecNo: Integer;
        RecNo: Integer;
    BEGIN
        IF TempDetailedCustLedgEntry.FINDSET THEN BEGIN
            SetWindowSource(TotalRecNo, CreateRequestMsg, TempDetailedCustLedgEntry);
            REPEAT
                UpdateWindowProgress(RecNo, TotalRecNo);
                DetailedCustLedgEntry := TempDetailedCustLedgEntry;
                SIIJobUploadPendingDocs.CreateSIIRequestForDtldCustLedgEntry(DetailedCustLedgEntry);
            UNTIL TempDetailedCustLedgEntry.NEXT = 0;
            CloseWindow;
            LastEntryNo := TempDetailedCustLedgEntry."Entry No.";
        END;
    END;

    LOCAL PROCEDURE RequestNeedsToBeCreated(PostingDate: Date; DocSource: Option; EntryNo: Integer): Boolean;
    VAR
        SIIInitialDocUpload: Codeunit 51303;
    BEGIN
        EXIT(
          (NOT SIIInitialDocUpload.DateWithinInitialUploadPeriod(PostingDate)) AND
          SIIDocUploadStateDoesNotExist(DocSource, EntryNo));
    END;

    LOCAL PROCEDURE SIIDocUploadStateDoesNotExist(DocSource: Option; EntryNo: Integer): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        SIIDocUploadState.SETRANGE("Document Source", DocSource);
        SIIDocUploadState.SETRANGE("Entry No", EntryNo);
        EXIT(SIIDocUploadState.ISEMPTY);
    END;

    LOCAL PROCEDURE GetMaxDate(Date1: Date; Date2: Date): Date;
    BEGIN
        IF Date1 > Date2 THEN
            EXIT(Date1);
        EXIT(Date2);
    END;

    //[External]
    PROCEDURE GetMissingVendInvoices(VAR TempVendLedgerEntry: Record 25 TEMPORARY; VAR LastEntryNo: Integer; RecreateFromDate: Date);
    VAR
        VendLedgerEntry: Record 25;
        SIIDocUploadState: Record 10752;
        SIIInitialDocUpload: Codeunit 51303;
        TotalRecNo: Integer;
        RecNo: Integer;
    BEGIN
        TempVendLedgerEntry.RESET;
        TempVendLedgerEntry.DELETEALL;

        IF LastEntryNo <> 0 THEN
            VendLedgerEntry.SETFILTER("Entry No.", '>%1', LastEntryNo);
        VendLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', VendLedgerEntry."Document Type"::Invoice, VendLedgerEntry."Document Type"::"Credit Memo");
        VendLedgerEntry.SETFILTER(
          "Posting Date", '>%1', GetMaxDate(SIIInitialDocUpload.GetInitialEndDate, CALCDATE('<-1D>', RecreateFromDate)));
        IF VendLedgerEntry.FINDSET THEN BEGIN
            SetWindowSource(TotalRecNo, CollectEntriesMsg, VendLedgerEntry);
            REPEAT
                UpdateWindowProgress(RecNo, TotalRecNo);
                IF RequestNeedsToBeCreated(VendLedgerEntry."Posting Date", SIIDocUploadState."Document Source"::"Vendor Ledger",
                     VendLedgerEntry."Entry No.")
                THEN BEGIN
                    TempVendLedgerEntry.INIT;
                    TempVendLedgerEntry := VendLedgerEntry;
                    TempVendLedgerEntry.INSERT;
                END;
            UNTIL VendLedgerEntry.NEXT = 0;
            LastEntryNo := VendLedgerEntry."Entry No.";
            CloseWindow;
        END;
    END;

    //[External]
    PROCEDURE GetMissingDetailedVendLedgerEntries(VAR TempDetailedVendorLedgEntry: Record 380 TEMPORARY; VAR LastEntryNo: Integer; RecreateFromDate: Date);
    VAR
        DetailedVendorLedgEntry: Record 380;
        SIIDocUploadState: Record 10752;
        SIIInitialDocUpload: Codeunit 51303;
        DataTypeManagement: Codeunit 701;
        SIIManagement: Codeunit 50026;
        DetailedVendorLedgerRecRef: RecordRef;
        TotalRecNo: Integer;
        RecNo: Integer;
    BEGIN
        TempDetailedVendorLedgEntry.RESET;
        TempDetailedVendorLedgEntry.DELETEALL;

        IF LastEntryNo <> 0 THEN
            DetailedVendorLedgEntry.SETFILTER("Entry No.", '>%1', LastEntryNo);
        DetailedVendorLedgEntry.SETRANGE("Document Type", DetailedVendorLedgEntry."Document Type"::Payment);
        DetailedVendorLedgEntry.SETRANGE("Entry Type", DetailedVendorLedgEntry."Entry Type"::Application);
        DetailedVendorLedgEntry.SETFILTER("Initial Document Type", '<>%1', DetailedVendorLedgEntry."Initial Document Type"::Payment);
        DetailedVendorLedgEntry.SETFILTER(
          "Posting Date", '>%1', GetMaxDate(SIIInitialDocUpload.GetInitialEndDate, CALCDATE('<-1D>', RecreateFromDate)));
        DetailedVendorLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DetailedVendorLedgEntry.FINDSET THEN BEGIN
            SetWindowSource(TotalRecNo, CollectEntriesMsg, DetailedVendorLedgEntry);
            REPEAT
                UpdateWindowProgress(RecNo, TotalRecNo);
                DataTypeManagement.GetRecordRef(DetailedVendorLedgEntry, DetailedVendorLedgerRecRef);
                IF SIIManagement.IsDetailedLedgerCashFlowBased(DetailedVendorLedgerRecRef) THEN
                    IF RequestNeedsToBeCreated(DetailedVendorLedgEntry."Posting Date",
                         SIIDocUploadState."Document Source"::"Detailed Vendor Ledger",
                         DetailedVendorLedgEntry."Entry No.")
                    THEN BEGIN
                        TempDetailedVendorLedgEntry.INIT;
                        TempDetailedVendorLedgEntry := DetailedVendorLedgEntry;
                        TempDetailedVendorLedgEntry.INSERT;
                    END;
            UNTIL DetailedVendorLedgEntry.NEXT = 0;
            LastEntryNo := DetailedVendorLedgEntry."Entry No.";
            CloseWindow;
        END;
    END;

    //[External]
    PROCEDURE GetMissingCustInvoices(VAR TempCustLedgerEntry: Record 21 TEMPORARY; VAR LastEntryNo: Integer; RecreateFromDate: Date);
    VAR
        CustLedgerEntry: Record 21;
        SIIDocUploadState: Record 10752;
        SIIInitialDocUpload: Codeunit 51303;
        TotalRecNo: Integer;
        RecNo: Integer;
    BEGIN
        TempCustLedgerEntry.RESET;
        TempCustLedgerEntry.DELETEALL;

        IF LastEntryNo <> 0 THEN
            CustLedgerEntry.SETFILTER("Entry No.", '>%1', LastEntryNo);
        CustLedgerEntry.SETFILTER(
          "Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SETFILTER(
          "Posting Date", '>%1', GetMaxDate(SIIInitialDocUpload.GetInitialEndDate, CALCDATE('<-1D>', RecreateFromDate)));
        IF CustLedgerEntry.FINDSET THEN BEGIN
            SetWindowSource(TotalRecNo, CollectEntriesMsg, CustLedgerEntry);
            REPEAT
                UpdateWindowProgress(RecNo, TotalRecNo);
                IF RequestNeedsToBeCreated(CustLedgerEntry."Posting Date", SIIDocUploadState."Document Source"::"Customer Ledger",
                     CustLedgerEntry."Entry No.")
                THEN BEGIN
                    TempCustLedgerEntry.INIT;
                    TempCustLedgerEntry := CustLedgerEntry;
                    TempCustLedgerEntry.INSERT;
                END;
            UNTIL CustLedgerEntry.NEXT = 0;
            LastEntryNo := CustLedgerEntry."Entry No.";
            CloseWindow;
        END;
    END;

    //[External]
    PROCEDURE GetMissingDetailedCustLedgerEntries(VAR TempDetailedCustLedgEntry: Record 379 TEMPORARY; VAR LastEntryNo: Integer; RecreateFromDate: Date);
    VAR
        DetailedCustLedgEntry: Record 379;
        SIIDocUploadState: Record 10752;
        SIIInitialDocUpload: Codeunit 51303;
        DataTypeManagement: Codeunit 701;
        SIIManagement: Codeunit 50026;
        DetailedCustomerLedgerRecRef: RecordRef;
        TotalRecNo: Integer;
        RecNo: Integer;
    BEGIN
        TempDetailedCustLedgEntry.RESET;
        TempDetailedCustLedgEntry.DELETEALL;

        IF LastEntryNo <> 0 THEN
            DetailedCustLedgEntry.SETFILTER("Entry No.", '>%1', LastEntryNo);
        DetailedCustLedgEntry.SETRANGE("Document Type", DetailedCustLedgEntry."Document Type"::Payment);
        DetailedCustLedgEntry.SETRANGE("Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
        DetailedCustLedgEntry.SETFILTER("Initial Document Type", '<>%1', DetailedCustLedgEntry."Initial Document Type"::Payment);
        DetailedCustLedgEntry.SETFILTER(
          "Posting Date", '>%1', GetMaxDate(SIIInitialDocUpload.GetInitialEndDate, CALCDATE('<-1D>', RecreateFromDate)));
        DetailedCustLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DetailedCustLedgEntry.FINDSET THEN BEGIN
            SetWindowSource(TotalRecNo, CollectEntriesMsg, DetailedCustLedgEntry);
            REPEAT
                UpdateWindowProgress(RecNo, TotalRecNo);
                DataTypeManagement.GetRecordRef(DetailedCustLedgEntry, DetailedCustomerLedgerRecRef);
                IF SIIManagement.IsDetailedLedgerCashFlowBased(DetailedCustomerLedgerRecRef) THEN
                    IF RequestNeedsToBeCreated(DetailedCustLedgEntry."Posting Date",
                         SIIDocUploadState."Document Source"::"Detailed Customer Ledger",
                         DetailedCustLedgEntry."Entry No.")
                    THEN BEGIN
                        TempDetailedCustLedgEntry.INIT;
                        TempDetailedCustLedgEntry := DetailedCustLedgEntry;
                        TempDetailedCustLedgEntry.INSERT;
                    END;
            UNTIL DetailedCustLedgEntry.NEXT = 0;
            LastEntryNo := DetailedCustLedgEntry."Entry No.";
            CloseWindow;
        END;
    END;

    //[External]
    PROCEDURE GetMissingEntriesCount(): Integer;
    VAR
        SIIMissingEntriesState: Record 10754;
    BEGIN
        IF NOT SIIMissingEntriesState.GET THEN
            EXIT(0);
        EXIT(SIIMissingEntriesState."Entries Missing");
    END;

    //[External]
    PROCEDURE GetDaysSinceLastCheck(): Integer;
    VAR
        SIIMissingEntriesState: Record 10754;
    BEGIN
        IF NOT SIIMissingEntriesState.GET THEN
            EXIT(0);
        IF SIIMissingEntriesState."Last Missing Entries Check" = 0D THEN
            EXIT(10); // if "Missing Entries Check" never run some value needs to be returned to pay attention of the user
        EXIT(TODAY - SIIMissingEntriesState."Last Missing Entries Check");
    END;

    LOCAL PROCEDURE SetWindowSource(VAR TotalRecNo: Integer; SourceMessage: Text; Rec: Variant);
    VAR
        RecRef: RecordRef;
    BEGIN
        IF NOT GUIALLOWED THEN
            EXIT;

        IF SourceMessage <> '' THEN
            Window.OPEN(GetWindowOpenMessage(SourceMessage));
        RecRef.GETTABLE(Rec);
        Window.UPDATE(1, RecRef.CAPTION);
        TotalRecNo := RecRef.COUNT;
    END;

    PROCEDURE SendTraceTagOn(TraceMessage: Text);
    BEGIN
        //SENDTRACETAG('000023W', RecreateMissingEntryJobTxt, VERBOSITY::Normal, TraceMessage, DATACLASSIFICATION::SystemMetadata);
        LogMessage('000023W', TraceMessage, VERBOSITY::Normal, DATACLASSIFICATION::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Message', 'Missing Entry');
    END;

    //[External]
    PROCEDURE GetSourceEntries(VAR TempVendorLedgerEntry: Record 25 TEMPORARY; VAR TempCustLedgEntry: Record 21 TEMPORARY; VAR TempDetailedVendorLedgEntry: Record 380 TEMPORARY; VAR TempDetailedCustLedgEntry: Record 379 TEMPORARY; AllEntries: Boolean; FromDate: Date);
    VAR
        SIIMissingEntriesState: Record 10754;
        CustLedgEntryNo: Integer;
        VendLedgEntryNo: Integer;
        DtldCustLedgEntryNo: Integer;
        DtldVendLedgEntryNo: Integer;
    BEGIN
        SIIMissingEntriesState.Initialize;
        IF NOT AllEntries THEN BEGIN
            VendLedgEntryNo := SIIMissingEntriesState."Last VLE No.";
            CustLedgEntryNo := SIIMissingEntriesState."Last CLE No.";
            DtldVendLedgEntryNo := SIIMissingEntriesState."Last DVLE No.";
            DtldCustLedgEntryNo := SIIMissingEntriesState."Last DCLE No.";
        END;

        GetMissingVendInvoices(TempVendorLedgerEntry, VendLedgEntryNo, FromDate);
        GetMissingCustInvoices(TempCustLedgEntry, CustLedgEntryNo, FromDate);
        GetMissingDetailedVendLedgerEntries(TempDetailedVendorLedgEntry, DtldVendLedgEntryNo, FromDate);
        GetMissingDetailedCustLedgerEntries(TempDetailedCustLedgEntry, DtldCustLedgEntryNo, FromDate);
        SIIMissingEntriesState."Last VLE No." := VendLedgEntryNo;
        SIIMissingEntriesState."Last CLE No." := CustLedgEntryNo;
        SIIMissingEntriesState."Last DVLE No." := DtldVendLedgEntryNo;
        SIIMissingEntriesState."Last DCLE No." := DtldCustLedgEntryNo;
        SIIMissingEntriesState."Entries Missing" :=
          TempVendorLedgerEntry.COUNT +
          TempCustLedgEntry.COUNT +
          TempDetailedVendorLedgEntry.COUNT +
          TempDetailedCustLedgEntry.COUNT;
        SIIMissingEntriesState."Last Missing Entries Check" := TODAY;
        SIIMissingEntriesState.MODIFY;
        SendTraceTagOn(STRSUBSTNO(EntriesMissingTxt, FORMAT(SIIMissingEntriesState."Entries Missing")));
    END;

    //[External]
    PROCEDURE ShowRecreateMissingEntriesPage();
    BEGIN
        PAGE.RUN(PAGE::"Recreate Missing SII Entries");
    END;

    LOCAL PROCEDURE UpdateWindowProgress(VAR RecNo: Integer; TotalRecNo: Integer);
    BEGIN
        IF NOT GUIALLOWED THEN
            EXIT;

        RecNo += 1;
        Window.UPDATE(2, ROUND(RecNo / TotalRecNo * 10000, 1));
    END;

    LOCAL PROCEDURE CloseWindow();
    BEGIN
        IF GUIALLOWED THEN
            Window.CLOSE;
    END;

    LOCAL PROCEDURE GetWindowOpenMessage(SourceMessage: Text): Text;
    BEGIN
        EXIT(SourceMessage + '\' + ProgressMsg);
    END;

    /* /*BEGIN
END.*/
}









