Codeunit 50025 "SII Job Upload Pending Docs. 1"
{


    // trigger OnRun()
    // BEGIN
    //     UploadPendingDocuments;
    // END;

    VAR
        SIIJobManagement: Codeunit 51301;
        JobType: Option "HandlePending","HandleCommError","InitialUpload";

    // LOCAL PROCEDURE UploadPendingDocuments();
    // VAR
    //     SIIDocUploadManagement: Codeunit 50024;
    // BEGIN
    //     SIIDocUploadManagement.UploadPendingDocuments;
    // END;

    // [EventSubscriber(ObjectType::Table, 21, OnAfterInsertEvent, '', true, true)]
    // LOCAL PROCEDURE OnCustomerLedgerEntryCreated(VAR Rec: Record 21; RunTrigger: Boolean);
    // BEGIN
    //     CreateSIIRequestForCustLedgEntry(Rec);
    // END;

    // [EventSubscriber(ObjectType::Table, 25, OnAfterInsertEvent, '', true, true)]
    // LOCAL PROCEDURE OnVendorLedgerEntryCreated(VAR Rec: Record 25; RunTrigger: Boolean);
    // BEGIN
    //     CreateSIIRequestForVendLedgEntry(Rec);
    // END;

    [EventSubscriber(ObjectType::Codeunit, 80, OnAfterPostSalesDoc, '', true, true)]
    LOCAL PROCEDURE OnAfterPostSalesDoc(VAR SalesHeader: Record 36; VAR GenJnlPostLine: Codeunit 12; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        IF SalesHeader.ISTEMPORARY THEN
            EXIT;

        SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', true, true)]
    LOCAL PROCEDURE OnAfterPostPurchDoc(VAR PurchaseHeader: Record 38; VAR GenJnlPostLine: Codeunit 12; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        IF PurchaseHeader.ISTEMPORARY THEN
            EXIT;

        SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    END;

    PROCEDURE OnAfterPostServiceDoc(VAR ServiceHeader: Record 5900);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        IF ServiceHeader.ISTEMPORARY THEN
            EXIT;

        SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    END;

    PROCEDURE OnAfterGLLinePost(GenJnlLine: Record 81);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        IF GenJnlLine.ISTEMPORARY THEN
            EXIT;

        IF GenJnlLine."Document Type" IN [GenJnlLine."Document Type"::"Credit Memo",
                                          GenJnlLine."Document Type"::Invoice,
                                          GenJnlLine."Document Type"::Payment]
        THEN
            SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    END;

    [EventSubscriber(ObjectType::Table, 380, OnAfterInsertEvent, '', true, true)]
    PROCEDURE OnDetailedVendorLedgerEntryCreated(VAR Rec: Record 380; RunTrigger: Boolean);
    BEGIN
        CreateSIIRequestForDtldVendLedgEntry(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 379, OnAfterInsertEvent, '', true, true)]
    PROCEDURE OnDetailedCustomerLedgerEntryCreated(VAR Rec: Record 379; RunTrigger: Boolean);
    BEGIN
        CreateSIIRequestForDtldCustLedgEntry(Rec);
    END;

    PROCEDURE OnVendorEntriesApplied(VAR VendorLedgerEntry: Record 25);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF VendorLedgerEntry.ISTEMPORARY THEN
            EXIT;
        IF NOT SIISetup.IsEnabled THEN
            EXIT;
        IF VendorLedgerEntry."Document Type" <> VendorLedgerEntry."Document Type"::Payment THEN
            EXIT;

        SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    END;

    PROCEDURE OnCustomerEntriesApplied(VAR CustLedgerEntry: Record 21);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF CustLedgerEntry.ISTEMPORARY THEN
            EXIT;
        IF NOT SIISetup.IsEnabled THEN
            EXIT;
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Payment THEN
            EXIT;

        SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    END;

    // PROCEDURE CreateSIIRequestForCustLedgEntry(VAR CustLedgEntry: Record 21);
    // VAR
    //     SIISetup: Record 10751;
    //     SIIDocUploadState: Record 10752;
    // BEGIN
    //     IF NOT SIISetup.IsEnabled THEN
    //         EXIT;

    //     WITH CustLedgEntry DO BEGIN
    //         IF ISTEMPORARY OR
    //            (NOT ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::Invoice]))
    //         THEN
    //             EXIT;

    //         SIIDocUploadState.CreateNewRequest(
    //           "Entry No.",
    //           SIIDocUploadState."Document Source"::"Customer Ledger",
    //           "Document Type",
    //           "Document No.", "External Document No.",
    //           "Posting Date")
    //     END;
    // END;

    // PROCEDURE CreateSIIRequestForVendLedgEntry(VAR VendorLedgerEntry: Record 25);
    // VAR
    //     SIISetup: Record 10751;
    //     SIIDocUploadState: Record 10752;
    // BEGIN
    //     IF NOT SIISetup.IsEnabled THEN
    //         EXIT;

    //     WITH VendorLedgerEntry DO BEGIN
    //         IF ISTEMPORARY OR
    //            (NOT ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::Invoice]))
    //         THEN
    //             EXIT;

    //         SIIDocUploadState.CreateNewRequest(
    //           "Entry No.",
    //           SIIDocUploadState."Document Source"::"Vendor Ledger",
    //           "Document Type",
    //           "Document No.", "External Document No.",
    //           "Posting Date")
    //     END;
    // END;

    PROCEDURE CreateSIIRequestForDtldVendLedgEntry(VAR DetailedVendorLedgEntry: Record 380);
    VAR
        SIISetup: Record 10751;
        VendorLedgerEntry: Record 25;
        SIIDocUploadState: Record 10752;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        WITH DetailedVendorLedgEntry DO BEGIN
            IF ISTEMPORARY THEN
                EXIT;

            IF ("Document Type" <> "Document Type"::Payment) OR
               ("Entry Type" <> "Entry Type"::Application) OR
               Unapplied OR
               ("Initial Document Type" = "Initial Document Type"::Payment) OR
               (NOT IsVendCashflowBased(DetailedVendorLedgEntry))
            THEN
                EXIT;

            VendorLedgerEntry.GET("Vendor Ledger Entry No.");
            IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Bill THEN BEGIN
                VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                VendorLedgerEntry.SETRANGE("Document No.", VendorLedgerEntry."Document No.");
                IF NOT VendorLedgerEntry.FINDFIRST THEN
                    EXIT;
            END;

            SIIDocUploadState.CreateNewVendPmtRequest(
              "Entry No.",
              VendorLedgerEntry."Entry No.",
              VendorLedgerEntry."External Document No.", "Posting Date");
        END;
    END;

    PROCEDURE CreateSIIRequestForDtldCustLedgEntry(VAR DetailedCustLedgEntry: Record 379);
    VAR
        SIISetup: Record 10751;
        CustLedgerEntry: Record 21;
        SIIDocUploadState: Record 10752;
    BEGIN
        IF NOT SIISetup.IsEnabled THEN
            EXIT;

        WITH DetailedCustLedgEntry DO BEGIN
            IF ISTEMPORARY THEN
                EXIT;

            IF ("Document Type" <> "Document Type"::Payment) OR
               ("Entry Type" <> "Entry Type"::Application) OR
               Unapplied OR
               ("Initial Document Type" = "Initial Document Type"::Payment) OR
               (NOT IsCustCashflowBased(DetailedCustLedgEntry))
            THEN
                EXIT;

            CustLedgerEntry.GET("Cust. Ledger Entry No.");
            IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Bill THEN BEGIN
                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
                CustLedgerEntry.SETRANGE("Document No.", CustLedgerEntry."Document No.");
                IF NOT CustLedgerEntry.FINDFIRST THEN
                    EXIT;
            END;

            SIIDocUploadState.CreateNewCustPmtRequest(
              "Entry No.",
              CustLedgerEntry."Entry No.",
              CustLedgerEntry."Document No.", "Posting Date");
        END;
    END;

    LOCAL PROCEDURE IsVendCashflowBased(DetailedVendorLedgEntry: Record 380): Boolean;
    VAR
        DataTypeManagement: Codeunit 701;
        SIIManagement: Codeunit 50026;
        DetailedVendorLedgerRecRef: RecordRef;
    BEGIN
        DataTypeManagement.GetRecordRef(DetailedVendorLedgEntry, DetailedVendorLedgerRecRef);
        EXIT(SIIManagement.IsDetailedLedgerCashFlowBased(DetailedVendorLedgerRecRef));
    END;

    LOCAL PROCEDURE IsCustCashflowBased(DetailedCustLedgEntry: Record 379): Boolean;
    VAR
        DataTypeManagement: Codeunit 701;
        SIIManagement: Codeunit 50026;
        DetailedCustomerLedgerRecRef: RecordRef;
    BEGIN
        DataTypeManagement.GetRecordRef(DetailedCustLedgEntry, DetailedCustomerLedgerRecRef);
        EXIT(SIIManagement.IsDetailedLedgerCashFlowBased(DetailedCustomerLedgerRecRef));
    END;

    
    /*BEGIN
/*{
      Uploads invoices 1 min after their creation, using event subscribers on Sales Invoices and Purchase invoices
    }
END.*/
}









