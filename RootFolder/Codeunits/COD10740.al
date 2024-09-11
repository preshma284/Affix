Codeunit 50022 "No Taxable Mgt. 1"
{


    Permissions = TableData 10740 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        GeneralLedgerSetup: Record 98;
        SIIManagement: Codeunit 50026;
        GLSetupRead: Boolean;

    // LOCAL PROCEDURE CreateNoTaxableEntriesPurchInvoice(GenJournalLine: Record 81; TransactionNo: Integer): Boolean;
    // VAR
    //     PurchInvHeader: Record 122;
    //     PurchInvLine: Record 123;
    //     NoTaxableEntry: Record 10740;
    //     PostedLineRecordRef: RecordRef;
    // BEGIN
    //     IF GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Invoice THEN
    //         EXIT(FALSE);
    //     IF NOT PurchInvHeader.GET(GenJournalLine."Document No.") THEN
    //         EXIT(FALSE);
    //     IF NOT FindNoTaxableLinesPurchaseInvoice(
    //          PurchInvLine, GenJournalLine."Account No.", GenJournalLine."Document No.", GenJournalLine."Posting Date")
    //     THEN
    //         EXIT(TRUE);

    //     NoTaxableEntry.InitFromGenJnlLine(GenJournalLine);
    //     NoTaxableEntry."Transaction No." := TransactionNo;
    //     PostedLineRecordRef.GETTABLE(PurchInvLine);
    //     InsertNoTaxableEntriesFromPurchLines(PostedLineRecordRef, NoTaxableEntry, 1);
    //     EXIT(TRUE);
    // END;

    // LOCAL PROCEDURE CreateNoTaxableEntriesPurchCreditMemo(GenJournalLine: Record 81; TransactionNo: Integer): Boolean;
    // VAR
    //     PurchCrMemoHdr: Record 124;
    //     PurchCrMemoLine: Record 125;
    //     NoTaxableEntry: Record 10740;
    //     PostedLineRecordRef: RecordRef;
    // BEGIN
    //     IF GenJournalLine."Document Type" <> GenJournalLine."Document Type"::"Credit Memo" THEN
    //         EXIT(FALSE);
    //     IF NOT PurchCrMemoHdr.GET(GenJournalLine."Document No.") THEN
    //         EXIT(FALSE);
    //     IF NOT FindNoTaxableLinesPurchaseCrMemo(
    //          PurchCrMemoLine, GenJournalLine."Account No.", GenJournalLine."Document No.", GenJournalLine."Posting Date")
    //     THEN
    //         EXIT(TRUE);

    //     NoTaxableEntry.InitFromGenJnlLine(GenJournalLine);
    //     NoTaxableEntry."Transaction No." := TransactionNo;
    //     PostedLineRecordRef.GETTABLE(PurchCrMemoLine);
    //     InsertNoTaxableEntriesFromPurchLines(PostedLineRecordRef, NoTaxableEntry, -1);
    //     EXIT(TRUE);
    // END;

    LOCAL PROCEDURE CreateNoTaxableEntriesSalesInvoice(GenJournalLine: Record 81; TransactionNo: Integer): Boolean;
    VAR
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF GenJournalLine."Document Type" <> GenJournalLine."Document Type"::Invoice THEN
            EXIT(FALSE);
        IF NOT SalesInvoiceHeader.GET(GenJournalLine."Document No.") THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesSalesInvoice(SalesInvoiceLine,
             GenJournalLine."Account No.", GenJournalLine."Document No.", GenJournalLine."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromGenJnlLine(GenJournalLine);
        NoTaxableEntry."Transaction No." := TransactionNo;
        PostedLineRecordRef.GETTABLE(SalesInvoiceLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, -1);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateNoTaxableEntriesSalesCreditMemo(GenJournalLine: Record 81; TransactionNo: Integer): Boolean;
    VAR
        SalesCrMemoHeader: Record 114;
        SalesCrMemoLine: Record 115;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF GenJournalLine."Document Type" <> GenJournalLine."Document Type"::"Credit Memo" THEN
            EXIT(FALSE);
        IF NOT SalesCrMemoHeader.GET(GenJournalLine."Document No.") THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesSalesCrMemo(
             SalesCrMemoLine, GenJournalLine."Account No.", GenJournalLine."Document No.", GenJournalLine."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromGenJnlLine(GenJournalLine);
        NoTaxableEntry."Transaction No." := TransactionNo;
        PostedLineRecordRef.GETTABLE(SalesCrMemoLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, 1);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateNoTaxableEntriesServiceInvoice(ServiceHeader: Record 5900; ServInvoiceNo: Code[20]): Boolean;
    VAR
        ServiceInvoiceHeader: Record 5992;
        ServiceInvoiceLine: Record 5993;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF NOT (ServiceHeader."Document Type" IN [ServiceHeader."Document Type"::Order, ServiceHeader."Document Type"::Invoice]) THEN
            EXIT(FALSE);
        IF NOT ServiceInvoiceHeader.GET(ServInvoiceNo) THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesServiceInvoice(
             ServiceInvoiceLine, ServiceHeader."Customer No.", ServInvoiceNo, ServiceHeader."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromServiceDocument(ServiceHeader, ServInvoiceNo);
        PostedLineRecordRef.GETTABLE(ServiceInvoiceLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, -1);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateNoTaxableEntriesServiceCreditMemo(ServiceHeader: Record 5900; ServCrMemoNo: Code[20]): Boolean;
    VAR
        ServiceCrMemoHeader: Record 5994;
        ServiceCrMemoLine: Record 5995;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF ServiceHeader."Document Type" <> ServiceHeader."Document Type"::"Credit Memo" THEN
            EXIT(FALSE);
        IF NOT ServiceCrMemoHeader.GET(ServCrMemoNo) THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesServiceCrMemo(
             ServiceCrMemoLine, ServiceHeader."Customer No.", ServCrMemoNo, ServiceHeader."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromServiceDocument(ServiceHeader, ServCrMemoNo);
        PostedLineRecordRef.GETTABLE(ServiceCrMemoLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, 1);
        EXIT(TRUE);
    END;

    // LOCAL PROCEDURE CreateNoTaxableEntriesPurchInvoiceFromVendEntry(VendorLedgerEntry: Record 25): Boolean;
    // VAR
    //     PurchInvHeader: Record 122;
    //     PurchInvLine: Record 123;
    //     NoTaxableEntry: Record 10740;
    //     PostedLineRecordRef: RecordRef;
    // BEGIN
    //     IF VendorLedgerEntry."Document Type" <> VendorLedgerEntry."Document Type"::Invoice THEN
    //         EXIT(FALSE);
    //     IF NOT PurchInvHeader.GET(VendorLedgerEntry."Document No.") THEN
    //         EXIT(FALSE);
    //     IF NOT FindNoTaxableLinesPurchaseInvoice(
    //          PurchInvLine, VendorLedgerEntry."Vendor No.", VendorLedgerEntry."Document No.", VendorLedgerEntry."Posting Date")
    //     THEN
    //         EXIT(TRUE);

    //     NoTaxableEntry.InitFromVendorEntry(
    //       VendorLedgerEntry, PurchInvHeader."Pay-to Country/Region Code", FALSE, PurchInvHeader."VAT Registration No.");
    //     PostedLineRecordRef.GETTABLE(PurchInvLine);
    //     InsertNoTaxableEntriesFromPurchLines(PostedLineRecordRef, NoTaxableEntry, 1);
    //     EXIT(TRUE);
    // END;

    // LOCAL PROCEDURE CreateNoTaxableEntriesPurchCreditMemoFromVendEntry(VendorLedgerEntry: Record 25): Boolean;
    // VAR
    //     PurchCrMemoHdr: Record 124;
    //     PurchCrMemoLine: Record 125;
    //     NoTaxableEntry: Record 10740;
    //     PostedLineRecordRef: RecordRef;
    // BEGIN
    //     IF VendorLedgerEntry."Document Type" <> VendorLedgerEntry."Document Type"::"Credit Memo" THEN
    //         EXIT(FALSE);
    //     IF NOT PurchCrMemoHdr.GET(VendorLedgerEntry."Document No.") THEN
    //         EXIT(FALSE);
    //     IF NOT FindNoTaxableLinesPurchaseCrMemo(
    //          PurchCrMemoLine, VendorLedgerEntry."Vendor No.", VendorLedgerEntry."Document No.", VendorLedgerEntry."Posting Date")
    //     THEN
    //         EXIT(TRUE);

    //     NoTaxableEntry.InitFromVendorEntry(
    //       VendorLedgerEntry, PurchCrMemoHdr."Pay-to Country/Region Code", FALSE, PurchCrMemoHdr."VAT Registration No.");
    //     PostedLineRecordRef.GETTABLE(PurchCrMemoLine);
    //     InsertNoTaxableEntriesFromPurchLines(PostedLineRecordRef, NoTaxableEntry, -1);
    //     EXIT(TRUE);
    // END;

    LOCAL PROCEDURE CreateNoTaxableEntriesSalesInvoiceFromCustEntry(CustLedgerEntry: Record 21): Boolean;
    VAR
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Invoice THEN
            EXIT(FALSE);
        IF NOT SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesSalesInvoice(SalesInvoiceLine,
             CustLedgerEntry."Customer No.", CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromCustomerEntry(
          CustLedgerEntry, SalesInvoiceHeader."Bill-to Country/Region Code",
          SalesInvoiceHeader."EU 3-Party Trade", SalesInvoiceHeader."VAT Registration No.");
        PostedLineRecordRef.GETTABLE(SalesInvoiceLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, -1);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateNoTaxableEntriesSalesCreditMemoFromCustEntry(CustLedgerEntry: Record 21): Boolean;
    VAR
        SalesCrMemoHeader: Record 114;
        SalesCrMemoLine: Record 115;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::"Credit Memo" THEN
            EXIT(FALSE);
        IF NOT SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesSalesCrMemo(
             SalesCrMemoLine, CustLedgerEntry."Customer No.", CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromCustomerEntry(
          CustLedgerEntry, SalesCrMemoHeader."Bill-to Country/Region Code",
          SalesCrMemoHeader."EU 3-Party Trade", SalesCrMemoHeader."VAT Registration No.");
        PostedLineRecordRef.GETTABLE(SalesCrMemoLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, 1);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateNoTaxableEntriesServiceInvoiceFromCustEntry(VAR CustLedgerEntry: Record 21): Boolean;
    VAR
        ServiceInvoiceHeader: Record 5992;
        ServiceInvoiceLine: Record 5993;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Invoice THEN
            EXIT(FALSE);
        IF NOT ServiceInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesServiceInvoice(
             ServiceInvoiceLine, CustLedgerEntry."Customer No.", CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromCustomerEntry(
          CustLedgerEntry, ServiceInvoiceHeader."Bill-to Country/Region Code",
          ServiceInvoiceHeader."EU 3-Party Trade", ServiceInvoiceHeader."VAT Registration No.");
        PostedLineRecordRef.GETTABLE(ServiceInvoiceLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, -1);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateNoTaxableEntriesServiceCreditMemoFromCustEntry(CustLedgerEntry: Record 21): Boolean;
    VAR
        ServiceCrMemoHeader: Record 5994;
        ServiceCrMemoLine: Record 5995;
        NoTaxableEntry: Record 10740;
        PostedLineRecordRef: RecordRef;
    BEGIN
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::"Credit Memo" THEN
            EXIT(FALSE);
        IF NOT ServiceCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN
            EXIT(FALSE);
        IF NOT FindNoTaxableLinesServiceCrMemo(
             ServiceCrMemoLine, CustLedgerEntry."Customer No.", CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date")
        THEN
            EXIT(TRUE);

        NoTaxableEntry.InitFromCustomerEntry(
          CustLedgerEntry, ServiceCrMemoHeader."Bill-to Country/Region Code",
          ServiceCrMemoHeader."EU 3-Party Trade", ServiceCrMemoHeader."VAT Registration No.");
        PostedLineRecordRef.GETTABLE(ServiceCrMemoLine);
        InsertNoTaxableEntriesFromSalesLines(PostedLineRecordRef, NoTaxableEntry, 1);
        EXIT(TRUE);
    END;

    PROCEDURE FindNoTaxableLinesPurchaseInvoice(VAR PurchInvLine: Record 123; VendorNo: Code[20]; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        WITH PurchInvLine DO BEGIN
            SETRANGE("Pay-to Vendor No.", VendorNo);
            SETRANGE("Document No.", DocumentNo);
            SETRANGE("Posting Date", PostingDate);
            SETFILTER("VAT Calculation Type", '%1|%2', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT");
            SETRANGE("VAT %", 0);
            EXIT(FINDSET);
        END;
    END;

    PROCEDURE FindNoTaxableLinesPurchaseCrMemo(VAR PurchCrMemoLine: Record 125; VendorNo: Code[20]; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        WITH PurchCrMemoLine DO BEGIN
            SETRANGE("Pay-to Vendor No.", VendorNo);
            SETRANGE("Document No.", DocumentNo);
            SETRANGE("Posting Date", PostingDate);
            SETFILTER("VAT Calculation Type", '%1|%2', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT");
            SETRANGE("VAT %", 0);
            EXIT(FINDSET);
        END;
    END;

    PROCEDURE FindNoTaxableLinesSalesInvoice(VAR SalesInvoiceLine: Record 113; CustomerNo: Code[20]; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        WITH SalesInvoiceLine DO BEGIN
            SETRANGE("Bill-to Customer No.", CustomerNo);
            SETRANGE("Document No.", DocumentNo);
            SETRANGE("Posting Date", PostingDate);
            SETFILTER("VAT Calculation Type", '%1|%2', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT");
            SETRANGE("VAT %", 0);
            EXIT(FINDSET);
        END;
    END;

    PROCEDURE FindNoTaxableLinesSalesCrMemo(VAR SalesCrMemoLine: Record 115; CustomerNo: Code[20]; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        WITH SalesCrMemoLine DO BEGIN
            SETRANGE("Bill-to Customer No.", CustomerNo);
            SETRANGE("Document No.", DocumentNo);
            SETRANGE("Posting Date", PostingDate);
            SETFILTER("VAT Calculation Type", '%1|%2', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT");
            SETRANGE("VAT %", 0);
            EXIT(FINDSET);
        END;
    END;

    PROCEDURE FindNoTaxableLinesServiceInvoice(VAR ServiceInvoiceLine: Record 5993; CustomerNo: Code[20]; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        WITH ServiceInvoiceLine DO BEGIN
            SETRANGE("Bill-to Customer No.", CustomerNo);
            SETRANGE("Document No.", DocumentNo);
            SETRANGE("Posting Date", PostingDate);
            SETFILTER("VAT Calculation Type", '%1|%2', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT");
            SETRANGE("VAT %", 0);
            EXIT(FINDSET);
        END;
    END;

    PROCEDURE FindNoTaxableLinesServiceCrMemo(VAR ServiceCrMemoLine: Record 5995; CustomerNo: Code[20]; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        WITH ServiceCrMemoLine DO BEGIN
            SETRANGE("Bill-to Customer No.", CustomerNo);
            SETRANGE("Document No.", DocumentNo);
            SETRANGE("Posting Date", PostingDate);
            SETFILTER("VAT Calculation Type", '%1|%2', "VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT");
            SETRANGE("VAT %", 0);
            EXIT(FINDSET);
        END;
    END;

    // LOCAL PROCEDURE InsertNoTaxableEntriesFromPurchLines(VAR PostedLineRecRef: RecordRef; NoTaxableEntry: Record 10740; Sign: Integer);
    // VAR
    //     DummyPurchInvLine: Record 123;
    //     VATPostingSetup: Record 325;
    //     GLAccount: Record 15;
    //     TypeFieldRef: FieldRef;
    //     NoFieldRef: FieldRef;
    //     AmountFieldRef: FieldRef;
    //     VATBusPostGrFieldRef: FieldRef;
    //     VATProdPostGrFieldRef: FieldRef;
    //     GenBusPostGrFieldRef: FieldRef;
    //     GenProdPostGrFieldRef: FieldRef;
    //     LineType: Option;
    //     LineNo: Code[20];
    //     LineAmount: Decimal;
    //     VATBusPostGroup: Code[20];
    //     VATProdPostGroup: Code[20];
    //     GenBusPostGroup: Code[20];
    //     GenProdPostGroup: Code[20];
    //     NotIn347: Boolean;
    // BEGIN
    //     WITH PostedLineRecRef DO
    //         REPEAT
    //             TypeFieldRef := FIELD(DummyPurchInvLine.FIELDNO(Type));
    //             NoFieldRef := FIELD(DummyPurchInvLine.FIELDNO("No."));
    //             AmountFieldRef := FIELD(DummyPurchInvLine.FIELDNO(Amount));
    //             VATBusPostGrFieldRef := FIELD(DummyPurchInvLine.FIELDNO("VAT Bus. Posting Group"));
    //             VATProdPostGrFieldRef := FIELD(DummyPurchInvLine.FIELDNO("VAT Prod. Posting Group"));
    //             GenBusPostGrFieldRef := FIELD(DummyPurchInvLine.FIELDNO("Gen. Bus. Posting Group"));
    //             GenProdPostGrFieldRef := FIELD(DummyPurchInvLine.FIELDNO("Gen. Prod. Posting Group"));
    //             LineType := TypeFieldRef.VALUE;
    //             LineNo := NoFieldRef.VALUE;
    //             LineAmount := AmountFieldRef.VALUE;
    //             VATBusPostGroup := VATBusPostGrFieldRef.VALUE;
    //             VATProdPostGroup := VATProdPostGrFieldRef.VALUE;
    //             GenBusPostGroup := GenBusPostGrFieldRef.VALUE;
    //             GenProdPostGroup := GenProdPostGrFieldRef.VALUE;

    //             IF VATPostingSetup.GET(VATBusPostGroup, VATProdPostGroup) AND VATPostingSetup.IsNoTaxable THEN BEGIN
    //                 IF FORMAT(LineType) = FORMAT(DummyPurchInvLine.Type::"G/L Account") THEN
    //                     NotIn347 := GLAccount.GET(LineNo) AND GLAccount."Ignore in 347 Report";
    //                 InsertNoTaxableEntry(
    //                   NoTaxableEntry, NoTaxableEntry.Type::Purchase, Sign * LineAmount, VATPostingSetup."EU Service", NotIn347, 0, 0,
    //                   VATPostingSetup."VAT Calculation Type", VATBusPostGroup, VATProdPostGroup,
    //                   GenBusPostGroup, GenProdPostGroup);
    //                 UpdateAmountsInCurrency(NoTaxableEntry);
    //             END;
    //         UNTIL NEXT = 0;
    // END;

    LOCAL PROCEDURE InsertNoTaxableEntriesFromSalesLines(VAR PostedLineRecRef: RecordRef; NoTaxableEntry: Record 10740; Sign: Integer);
    VAR
        DummySalesInvoiceLine: Record 113;
        VATPostingSetup: Record 325;
        VATProductPostingGroup: Record 324;
        GLAccount: Record 15;
        TypeFieldRef: FieldRef;
        NoFieldRef: FieldRef;
        AmountFieldRef: FieldRef;
        VATBusPostGrFieldRef: FieldRef;
        VATProdPostGrFieldRef: FieldRef;
        GenBusPostGrFieldRef: FieldRef;
        GenProdPostGrFieldRef: FieldRef;
        LineType: Option;
        LineNo: Code[20];
        LineAmount: Decimal;
        VATBusPostGroup: Code[20];
        VATProdPostGroup: Code[20];
        GenBusPostGroup: Code[20];
        GenProdPostGroup: Code[20];
        NotIn347: Boolean;
    BEGIN
        WITH PostedLineRecRef DO
            REPEAT
                TypeFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO(Type));
                NoFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO("No."));
                AmountFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO(Amount));
                VATBusPostGrFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO("VAT Bus. Posting Group"));
                VATProdPostGrFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO("VAT Prod. Posting Group"));
                GenBusPostGrFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO("Gen. Bus. Posting Group"));
                GenProdPostGrFieldRef := FIELD(DummySalesInvoiceLine.FIELDNO("Gen. Prod. Posting Group"));
                LineType := TypeFieldRef.VALUE;
                LineNo := NoFieldRef.VALUE;
                LineAmount := AmountFieldRef.VALUE;
                VATBusPostGroup := VATBusPostGrFieldRef.VALUE;
                VATProdPostGroup := VATProdPostGrFieldRef.VALUE;
                GenBusPostGroup := GenBusPostGrFieldRef.VALUE;
                GenProdPostGroup := GenProdPostGrFieldRef.VALUE;

                IF VATPostingSetup.GET(VATBusPostGroup, VATProdPostGroup) AND VATPostingSetup.IsNoTaxable THEN BEGIN
                    IF FORMAT(LineType) = FORMAT(DummySalesInvoiceLine.Type::"G/L Account") THEN
                        NotIn347 := GLAccount.GET(LineNo) AND GLAccount."Ignore in 347 Report";
                    IF VATProductPostingGroup.GET(VATPostingSetup."VAT Prod. Posting Group") THEN;
                    InsertNoTaxableEntry(
                      NoTaxableEntry, NoTaxableEntry.Type::Sale, Sign * LineAmount, VATPostingSetup."EU Service", NotIn347,
                      VATPostingSetup."No Taxable Type", VATProductPostingGroup."Delivery Operation Code",
                      VATPostingSetup."VAT Calculation Type", VATBusPostGroup, VATProdPostGroup,
                      GenBusPostGroup, GenProdPostGroup);
                    UpdateAmountsInCurrency(NoTaxableEntry);
                END;
            UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE InsertNoTaxableEntriesFromGenJnlLine(GenJournalLine: Record 81; TransactionNo: Integer; Sign: Integer);
    VAR
        NoTaxableEntry: Record 10740;
        VATPostingSetup: Record 325;
        VATProductPostingGroup: Record 324;
        GeneralPostingSetup: Record 252;
        EntryType: Enum "General Posting Type";
    BEGIN
        WITH GenJournalLine DO BEGIN
            IF NOT VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN
                IF NOT VATPostingSetup.GET("Bal. VAT Bus. Posting Group", "Bal. VAT Prod. Posting Group") THEN
                    EXIT;
            IF NOT VATPostingSetup.IsNoTaxable THEN
                EXIT;

            IF NOT GeneralPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group") THEN
                IF NOT GeneralPostingSetup.GET("Bal. Gen. Bus. Posting Group", "Bal. Gen. Prod. Posting Group") THEN;

            IF ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor) THEN
                EntryType := NoTaxableEntry.Type::Purchase;

            IF ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer) THEN BEGIN
                EntryType := NoTaxableEntry.Type::Sale;
                IF VATProductPostingGroup.GET(VATPostingSetup."VAT Prod. Posting Group") THEN;
            END;

            IF "Document Type" = "Document Type"::"Credit Memo" THEN
                Sign := -Sign;
            NoTaxableEntry.InitFromGenJnlLine(GenJournalLine);
            NoTaxableEntry."Transaction No." := TransactionNo;
            InsertNoTaxableEntry(
              NoTaxableEntry, EntryType, Sign * ABS(Amount), VATPostingSetup."EU Service", FALSE,
              VATPostingSetup."No Taxable Type", VATProductPostingGroup."Delivery Operation Code",
              VATPostingSetup."VAT Calculation Type", VATPostingSetup."VAT Bus. Posting Group", VATPostingSetup."VAT Prod. Posting Group",
              GeneralPostingSetup."Gen. Bus. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");
            UpdateAmountsInCurrency(NoTaxableEntry);
        END;
    END;

    LOCAL PROCEDURE InsertNoTaxableEntriesFromGenLedgEntry(NoTaxableEntry: Record 10740; EntryAmount: Decimal; Sign: Integer);
    VAR
        GLEntry: Record 17;
        VATPostingSetup: Record 325;
        VATProductPostingGroup: Record 324;
        GeneralPostingSetup: Record 252;
    BEGIN
        IF NoTaxableEntry.Type = NoTaxableEntry.Type::Sale THEN BEGIN
            GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Customer);
            GLEntry.SETRANGE("Bal. Account Type", GLEntry."Bal. Account Type"::Customer);
        END ELSE BEGIN
            GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Vendor);
            GLEntry.SETRANGE("Bal. Account Type", GLEntry."Bal. Account Type"::Vendor);
        END;
        GLEntry.SETRANGE("Source No.", NoTaxableEntry."Source No.");
        GLEntry.SETRANGE("Document Type", NoTaxableEntry."Document Type");
        GLEntry.SETRANGE("Document No.", NoTaxableEntry."Document No.");
        GLEntry.SETRANGE("Posting Date", NoTaxableEntry."Posting Date");
        GLEntry.SETRANGE(Reversed, FALSE);

        IF GLEntry.ISEMPTY THEN
            EXIT;
        GLEntry.FINDFIRST;
        IF NOT VATPostingSetup.GET(GLEntry."VAT Bus. Posting Group", GLEntry."VAT Prod. Posting Group") THEN
            EXIT;
        IF NOT VATPostingSetup.IsNoTaxable THEN
            EXIT;

        IF GeneralPostingSetup.GET(GLEntry."Gen. Bus. Posting Group", GLEntry."Gen. Prod. Posting Group") THEN;
        IF NoTaxableEntry.Type = NoTaxableEntry.Type::Sale THEN
            IF VATProductPostingGroup.GET(VATPostingSetup."VAT Prod. Posting Group") THEN;
        IF NoTaxableEntry."Document Type" = NoTaxableEntry."Document Type"::"Credit Memo" THEN
            Sign := -Sign;
        InsertNoTaxableEntry(
          NoTaxableEntry, NoTaxableEntry.Type, Sign * ABS(EntryAmount), VATPostingSetup."EU Service", FALSE,
          VATPostingSetup."No Taxable Type", VATProductPostingGroup."Delivery Operation Code",
          VATPostingSetup."VAT Calculation Type", VATPostingSetup."VAT Bus. Posting Group", VATPostingSetup."VAT Prod. Posting Group",
          GeneralPostingSetup."Gen. Bus. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");
        UpdateAmountsInCurrency(NoTaxableEntry);
    END;

    LOCAL PROCEDURE InsertNoTaxableEntry(VAR NoTaxableEntry: Record 10740; EntryType: Enum "General Posting Type"; EntryAmount: Decimal; EUService: Boolean; NotIn347: Boolean; NoTaxableType: Option; DeliveryOperationCode: Option; VATCalculationType: Enum "Tax Calculation Type"; VATBusPostingGroupCode: Code[20]; VATProdPostingGroupCode: Code[20]; GenBusPostingGroupCode: Code[20]; GenProdPostingGroupCode: Code[20]);
    BEGIN
        WITH NoTaxableEntry DO BEGIN
            Type := EntryType;
            Base := EntryAmount;
            Amount := EntryAmount;
            "EU Service" := EUService;
            "Not In 347" := NotIn347;
            "No Taxable Type" := NoTaxableType;
            "Delivery Operation Code" := DeliveryOperationCode;
            "VAT Calculation Type" := VATCalculationType;
            "VAT Bus. Posting Group" := VATBusPostingGroupCode;
            "VAT Prod. Posting Group" := VATProdPostingGroupCode;
            "Gen. Bus. Posting Group" := GenBusPostingGroupCode;
            "Gen. Prod. Posting Group" := GenProdPostingGroupCode;
            Intracommunity := SIIManagement.IsIntracommunity("Country/Region Code");
            Update(NoTaxableEntry);
        END;
    END;

    LOCAL PROCEDURE MapDeliveryOperationCode(DeliveryOperationCode: Option " ","E - General","M - Imported Tax Exempt","H - Imported Tax Exempt (Representative)"): Integer;
    BEGIN
        IF DeliveryOperationCode = DeliveryOperationCode::" " THEN
            EXIT(DeliveryOperationCode::"E - General");
        EXIT(DeliveryOperationCode);
    END;

    // PROCEDURE CalcNoTaxableAmountCustomerSimple(VAR NormalAmount: Decimal; VAR EUServiceAmount: Decimal; VAR EU3PartyAmount: Decimal; CustomerNo: Code[20]; FromDate: Date; ToDate: Date; FilterString: Text);
    // VAR
    //     NoTaxableNormalAmountSales: ARRAY[3] OF Decimal;
    // BEGIN
    //     CalcNoTaxableAmountCustomer(
    //       NoTaxableNormalAmountSales, NormalAmount, EUServiceAmount, EU3PartyAmount, CustomerNo,
    //       FromDate, ToDate, FilterString, FALSE);
    // END;

    // PROCEDURE CalcNoTaxableAmountCustomerWithDeliveryCode(VAR NoTaxableNormalAmount: ARRAY[3] OF Decimal; VAR EUServiceAmount: Decimal; VAR EU3PartyAmount: Decimal; CustomerNo: Code[20]; FromDate: Date; ToDate: Date; FilterString: Text);
    // VAR
    //     NormalAmount: Decimal;
    // BEGIN
    //     CalcNoTaxableAmountCustomer(
    //       NoTaxableNormalAmount, NormalAmount, EUServiceAmount, EU3PartyAmount, CustomerNo,
    //       FromDate, ToDate, FilterString, TRUE);
    // END;

    // LOCAL PROCEDURE CalcNoTaxableAmountCustomer(VAR NoTaxableNormalAmountSales: ARRAY[3] OF Decimal; VAR NormalAmount: Decimal; VAR EUServiceAmount: Decimal; VAR EU3PartyAmount: Decimal; CustomerNo: Code[20]; FromDate: Date; ToDate: Date; FilterString: Text; SplitByDelivery: Boolean);
    // VAR
    //     NoTaxableEntry: Record 10740;
    // BEGIN
    //     NoTaxableEntry.FilterNoTaxableEntriesForSource(
    //       NoTaxableEntry.Type::Sale, CustomerNo, NoTaxableEntry."Document Type"::Invoice,
    //       FromDate, ToDate, FilterString);
    //     IF NoTaxableEntry.ISEMPTY THEN
    //         EXIT;

    //     NoTaxableEntry.SETRANGE("EU Service", TRUE);
    //     NoTaxableEntry.CALCSUMS(Amount);
    //     EUServiceAmount += ABS(NoTaxableEntry.Amount);

    //     NoTaxableEntry.SETRANGE("EU Service", FALSE);
    //     NoTaxableEntry.SETRANGE("EU 3-Party Trade", TRUE);
    //     NoTaxableEntry.CALCSUMS(Amount);
    //     EU3PartyAmount += ABS(NoTaxableEntry.Amount);

    //     NoTaxableEntry.SETRANGE("EU 3-Party Trade", FALSE);
    //     IF NOT SplitByDelivery THEN BEGIN
    //         NoTaxableEntry.CALCSUMS(Amount);
    //         NormalAmount += ABS(NoTaxableEntry.Amount);
    //     END ELSE BEGIN
    //         IF NoTaxableEntry.FINDSET THEN
    //             REPEAT
    //                 NoTaxableNormalAmountSales[MapDeliveryOperationCode(NoTaxableEntry."Delivery Operation Code")] +=
    //                   ABS(NoTaxableEntry.Amount);
    //             UNTIL NoTaxableEntry.NEXT = 0;
    //     END;
    // END;

    // PROCEDURE CalcNoTaxableAmountVendor(VAR NormalAmount: Decimal; VAR EUServiceAmount: Decimal; VendorNo: Code[20]; FromDate: Date; ToDate: Date; FilterString: Text[1024]);
    // VAR
    //     NoTaxableEntry: Record 10740;
    // BEGIN
    //     NoTaxableEntry.FilterNoTaxableEntriesForSource(
    //       NoTaxableEntry.Type::Purchase, VendorNo, NoTaxableEntry."Document Type"::Invoice,
    //       FromDate, ToDate, FilterString);
    //     IF NoTaxableEntry.ISEMPTY THEN
    //         EXIT;

    //     WITH NoTaxableEntry DO BEGIN
    //         SETRANGE("EU Service", FALSE);
    //         CALCSUMS(Amount);
    //         NormalAmount += ABS(Amount);

    //         SETRANGE("EU Service", TRUE);
    //         CALCSUMS(Amount);
    //         EUServiceAmount += ABS(Amount);
    //     END;
    // END;

    LOCAL PROCEDURE ConvertAmountFCYtoLCY(Amount: Decimal; PostingDate: Date; CurrencyCode: Code[10]; CurrencyFactor: Decimal): Decimal;
    VAR
        CurrencyExchangeRate: Record 330;
    BEGIN
        IF CurrencyCode = '' THEN
            EXIT(Amount);
        EXIT(
          ROUND(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PostingDate, CurrencyCode, Amount, CurrencyFactor)));
    END;

    LOCAL PROCEDURE ConvertAmountLCYtoACY(Amount: Decimal; PostingDate: Date; CurrencyCode: Code[10]): Decimal;
    VAR
        Currency: Record 4;
        CurrencyExchangeRate: Record 330;
        CurrencyFactor: Decimal;
    BEGIN
        Currency.GET(CurrencyCode);
        Currency.InitRoundingPrecision;
        CurrencyFactor := CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode);
        EXIT(
          ROUND(
            CurrencyExchangeRate.ExchangeAmtLCYToFCY(
              PostingDate, CurrencyCode, Amount, CurrencyFactor), Currency."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE UpdateAmountsInCurrency(VAR NoTaxableEntry: Record 10740);
    BEGIN
        WITH NoTaxableEntry DO BEGIN
            "Base (LCY)" := ConvertAmountFCYtoLCY(Base, "Posting Date", "Currency Code", "Currency Factor");
            "Amount (LCY)" := ConvertAmountFCYtoLCY(Amount, "Posting Date", "Currency Code", "Currency Factor");
            GetGLSetup;
            IF GeneralLedgerSetup."Additional Reporting Currency" <> '' THEN BEGIN
                "Base (ACY)" :=
                  ConvertAmountLCYtoACY("Base (LCY)", "Posting Date", GeneralLedgerSetup."Additional Reporting Currency");
                "Amount (ACY)" :=
                  ConvertAmountLCYtoACY("Amount (LCY)", "Posting Date", GeneralLedgerSetup."Additional Reporting Currency");
            END;
            MODIFY;
        END;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN
            GeneralLedgerSetup.GET;
        GLSetupRead := TRUE;
    END;

    // PROCEDURE UpdateNoTaxableEntryFromVendorLedgerEntry(VendorLedgerEntry: Record 25);
    // VAR
    //     Vendor: Record 23;
    //     NoTaxableEntry: Record 10740;
    // BEGIN
    //     WITH VendorLedgerEntry DO BEGIN
    //         IF CreateNoTaxableEntriesPurchInvoiceFromVendEntry(VendorLedgerEntry) THEN
    //             EXIT;
    //         IF CreateNoTaxableEntriesPurchCreditMemoFromVendEntry(VendorLedgerEntry) THEN
    //             EXIT;

    //         CALCFIELDS(Amount);
    //         Vendor.GET("Vendor No.");
    //         NoTaxableEntry.InitFromVendorEntry(VendorLedgerEntry, Vendor."Country/Region Code", FALSE, Vendor."VAT Registration No.");
    //         NoTaxableEntry.Type := NoTaxableEntry.Type::Purchase;
    //         InsertNoTaxableEntriesFromGenLedgEntry(NoTaxableEntry, Amount, 1);
    //     END;
    // END;

    PROCEDURE UpdateNoTaxableEntryFromCustomerLedgerEntry(CustLedgerEntry: Record 21);
    VAR
        NoTaxableEntry: Record 10740;
        Customer: Record 18;
    BEGIN
        WITH CustLedgerEntry DO BEGIN
            IF CreateNoTaxableEntriesSalesInvoiceFromCustEntry(CustLedgerEntry) THEN
                EXIT;
            IF CreateNoTaxableEntriesSalesCreditMemoFromCustEntry(CustLedgerEntry) THEN
                EXIT;
            IF CreateNoTaxableEntriesServiceInvoiceFromCustEntry(CustLedgerEntry) THEN
                EXIT;
            IF CreateNoTaxableEntriesServiceCreditMemoFromCustEntry(CustLedgerEntry) THEN
                EXIT;

            CALCFIELDS(Amount);
            Customer.GET("Customer No.");
            NoTaxableEntry.InitFromCustomerEntry(CustLedgerEntry, Customer."Country/Region Code", FALSE, Customer."VAT Registration No.");
            NoTaxableEntry.Type := NoTaxableEntry.Type::Sale;
            InsertNoTaxableEntriesFromGenLedgEntry(NoTaxableEntry, Amount, -1);
        END;
    END;

    // [EventSubscriber(ObjectType::Codeunit, 12, OnAfterPostVend, '', true, true)]
    // LOCAL PROCEDURE InsertNoTaxableEntryOnPostVend(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    // BEGIN
    //     IF NOT (GenJournalLine."Document Type" IN
    //             [GenJournalLine."Document Type"::Invoice, GenJournalLine."Document Type"::"Credit Memo"])
    //     THEN
    //         EXIT;

    //     IF CreateNoTaxableEntriesPurchInvoice(GenJournalLine, TempGLEntryBuf."Transaction No.") THEN
    //         EXIT;
    //     IF CreateNoTaxableEntriesPurchCreditMemo(GenJournalLine, TempGLEntryBuf."Transaction No.") THEN
    //         EXIT;

    //     InsertNoTaxableEntriesFromGenJnlLine(GenJournalLine, TempGLEntryBuf."Transaction No.", 1);
    // END;

    // [EventSubscriber(ObjectType::Codeunit, 12, OnAfterPostCust, '', true, true)]
    // LOCAL PROCEDURE InsertNoTaxableEntryOnPostCust(VAR GenJournalLine: Record 81; Balancing: Boolean; VAR TempGLEntryBuf: Record 17 TEMPORARY; VAR NextEntryNo: Integer; VAR NextTransactionNo: Integer);
    // BEGIN
    //     IF NOT (GenJournalLine."Document Type" IN
    //             [GenJournalLine."Document Type"::Invoice, GenJournalLine."Document Type"::"Credit Memo"])
    //     THEN
    //         EXIT;

    //     IF CreateNoTaxableEntriesSalesInvoice(GenJournalLine, TempGLEntryBuf."Transaction No.") THEN
    //         EXIT;
    //     IF CreateNoTaxableEntriesSalesCreditMemo(GenJournalLine, TempGLEntryBuf."Transaction No.") THEN
    //         EXIT;

    //     InsertNoTaxableEntriesFromGenJnlLine(GenJournalLine, TempGLEntryBuf."Transaction No.", -1);
    // END;

    // [EventSubscriber(ObjectType::Codeunit, 5980, OnAfterPostServiceDoc, '', true, true)]
    // LOCAL PROCEDURE InsertNoTaxableEntryOnAfterPostServiceDoc(VAR ServiceHeader: Record 5900; ServShipmentNo: Code[20]; ServInvoiceNo: Code[20]; ServCrMemoNo: Code[20]);
    // BEGIN
    //     IF NOT CreateNoTaxableEntriesServiceInvoice(ServiceHeader, ServInvoiceNo) THEN
    //         CreateNoTaxableEntriesServiceCreditMemo(ServiceHeader, ServCrMemoNo);
    // END;

    // [EventSubscriber(ObjectType::Codeunit, 17, OnReverseVendLedgEntryOnBeforeInsertVendLedgEntry, '', true, true)]
    // LOCAL PROCEDURE ReverseNoTaxableEntryVend(VAR NewVendLedgEntry: Record 25; VendLedgEntry: Record 25);
    // VAR
    //     DummyNoTaxableEntry: Record 10740;
    // BEGIN
    //     DummyNoTaxableEntry.Reverse(
    //       DummyNoTaxableEntry.Type::Purchase, VendLedgEntry."Vendor No.",
    //       VendLedgEntry."Document Type", VendLedgEntry."Document No.", VendLedgEntry."Posting Date");
    // END;

    // [EventSubscriber(ObjectType::Codeunit, 17, OnReverseCustLedgEntryOnBeforeInsertCustLedgEntry, '', true, true)]
    // LOCAL PROCEDURE ReverseNoTaxableEntryCust(VAR NewCustLedgerEntry: Record 21; CustLedgerEntry: Record 21);
    // VAR
    //     DummyNoTaxableEntry: Record 10740;
    // BEGIN
    //     DummyNoTaxableEntry.Reverse(
    //       DummyNoTaxableEntry.Type::Sale, CustLedgerEntry."Customer No.",
    //       CustLedgerEntry."Document Type", CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date");
    // END;

    /* /*BEGIN
END.*/
}









