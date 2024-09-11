Codeunit 51303 "SII Initial Doc. Upload 1"
{


    // trigger OnRun()
    // BEGIN
    //     HandleExistingPostedDocuments;
    // END;

    VAR
        SIIJobManagement: Codeunit 51301;
        StartDate: Date;
        EndDate: Date;
        JobType: Option "HandlePending","HandleCommError","InitialUpload";

    // LOCAL PROCEDURE HandleExistingPostedDocuments();
    // BEGIN
    //     // We need to upload all the documents poseted from 01 January 2017 to 01 July 2017
    //     StartDate := GetInitialStartDate;
    //     EndDate := GetInitialEndDate;

    //     HandleExistingCustomerLedgerEntries;
    //     HandleExistingVendorLedgerEntries;

    //     SIIJobManagement.RenewJobQueueEntry(JobType::HandlePending);
    // END;

    // LOCAL PROCEDURE HandleExistingCustomerLedgerEntries();
    // VAR
    //     SIIDocUploadState: Record 10752;
    //     CustLedgerEntry: Record 21;
    //     var1: Codeunit "SII Initial Doc. Upload";
    // BEGIN
    //     CustLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
    //     IF CustLedgerEntry.FINDSET THEN BEGIN
    //         REPEAT
    //             IF CustLedgerEntry."Document Type" IN [CustLedgerEntry."Document Type"::"Credit Memo",
    //                                                    CustLedgerEntry."Document Type"::Invoice]
    //             THEN
    //                 SIIDocUploadState.CreateNewRequest(
    //                   CustLedgerEntry."Entry No.", SIIDocUploadState."Document Source"::"Customer Ledger",
    //                   CustLedgerEntry."Document Type", CustLedgerEntry."Document No.", CustLedgerEntry."External Document No.",
    //                   CustLedgerEntry."Posting Date");
    //         UNTIL CustLedgerEntry.NEXT = 0;
    //     END;
    // END;

    // LOCAL PROCEDURE HandleExistingVendorLedgerEntries();
    // VAR
    //     SIIDocUploadState: Record 10752;
    //     VendorLedgerEntry: Record 25;
    // BEGIN
    //     VendorLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
    //     IF VendorLedgerEntry.FINDSET THEN BEGIN
    //         REPEAT
    //             IF VendorLedgerEntry."Document Type" IN [VendorLedgerEntry."Document Type"::"Credit Memo",
    //                                                      VendorLedgerEntry."Document Type"::Invoice]
    //             THEN
    //                 SIIDocUploadState.CreateNewRequest(
    //                   VendorLedgerEntry."Entry No.", SIIDocUploadState."Document Source"::"Vendor Ledger",
    //                   VendorLedgerEntry."Document Type", VendorLedgerEntry."Document No.", VendorLedgerEntry."External Document No.",
    //                   VendorLedgerEntry."Posting Date");
    //         UNTIL VendorLedgerEntry.NEXT = 0;
    //     END;
    // END;

    PROCEDURE ScheduleInitialUpload();
    BEGIN
        SIIJobManagement.RenewJobQueueEntry(JobType::InitialUpload);
    END;

    PROCEDURE GetInitialStartDate(): Date;
    BEGIN
        EXIT(DMY2DATE(1, 1, 2017));
    END;

    PROCEDURE GetInitialEndDate(): Date;
    BEGIN
        EXIT(DMY2DATE(30, 6, 2017));
    END;

    PROCEDURE DateWithinInitialUploadPeriod(InputDate: Date): Boolean;
    BEGIN
        EXIT(InputDate IN [GetInitialStartDate .. GetInitialEndDate]);
    END;


    /* /*BEGIN
END.*/
}









