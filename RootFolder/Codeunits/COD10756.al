Codeunit 50026 "SII Management 1"
{

    trigger OnRun()
    BEGIN
    END;

    VAR
        DontAskAgainTxt: TextConst ENU = 'Don''t ask again', ESP = 'No volver a preguntar';
        SiiNotificationNameTxt: TextConst ENU = 'Sii Setup Notification', ESP = 'Notificaci�n de configuraci�n SII';
        SIIServiceNameTxt: TextConst ENU = 'SII Service', ESP = 'Servicio SII';
        SIIBusinessSetupDescriptionTxt: TextConst ENU = 'Set up and enable the SII service.', ESP = 'Permite configurar y habilitar el servicio SII.';
        SIIBusinessSetupKeywordsTxt: TextConst ENU = 'Finance,SII', ESP = 'Finanzas,SII';
        SetupNotificationTxt: TextConst ENU = 'Do you want to setup SII Document Transmission?', ESP = '�Desea configurar la transmisi�n de documentos SII?';
        YesTxt: TextConst ENU = 'Yes', ESP = 'S�';
        NoSIIStateErr: TextConst ENU = 'The document has not been transmitted and hence has no status.', ESP = 'El documento no se ha transmitido y, por tanto, no tiene ning�n estado.';

    [EventSubscriber(ObjectType::Page, 43, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnSalesInvoicePageOpen(VAR Rec: Record 36);
    BEGIN
        CreateSetupNotification;
    END;

    [EventSubscriber(ObjectType::Page, 51, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnPurchInvoicePageOpen(VAR Rec: Record 38);
    BEGIN
        CreateSetupNotification;
    END;

    [EventSubscriber(ObjectType::Page, 44, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnSalesCreditMemoPageOpen(VAR Rec: Record 36);
    BEGIN
        CreateSetupNotification;
    END;

    [EventSubscriber(ObjectType::Page, 52, OnOpenPageEvent, '', true, true)]
    LOCAL PROCEDURE OnPurchCreditMemoPageOpen(VAR Rec: Record 38);
    BEGIN
        CreateSetupNotification;
    END;

    //[External]
    PROCEDURE IsSIISetupEnabled(): Boolean;
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF NOT SIISetup.GET THEN
            EXIT(FALSE);
        EXIT(SIISetup.Enabled);
    END;

    LOCAL PROCEDURE CreateSetupNotification();
    VAR
        SetupNotification: Notification;
    BEGIN
        IF NOT ShowNotification THEN
            EXIT;

        SetupNotification.MESSAGE := SetupNotificationTxt;
        SetupNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        SetupNotification.ADDACTION(YesTxt, CODEUNIT::"SII Management", 'OpenSIIVATSetup');
        SetupNotification.ADDACTION(DontAskAgainTxt, CODEUNIT::"SII Management", 'DeactivateSIISetupNotification');
        SetupNotification.SEND;
    END;

    //[External]
    PROCEDURE OpenSIIVATSetup(SetupNotification: Notification);
    BEGIN
        PAGE.RUN(PAGE::"SII Setup");
    END;

    //[External]
    PROCEDURE DeactivateSIISetupNotification(VAR SetupNotification: Notification);
    VAR
        MyNotifications: Record 1518;
        NotificationGuid: GUID;
    BEGIN
        NotificationGuid := SetupNotification.ID;
        IF MyNotifications.GET(USERID, NotificationGuid) THEN BEGIN
            MyNotifications.VALIDATE(Enabled, FALSE);
            MyNotifications.MODIFY;
        END ELSE
            MyNotifications.InsertDefault(GetNotificationId, SiiNotificationNameTxt, 'SII', FALSE);
    END;

    LOCAL PROCEDURE ShowNotification(): Boolean;
    VAR
        MyNotifications: Record 1518;
        SIISetup: Record 10751;
        CompanyInformationMgt: Codeunit 1306;
    BEGIN
        IF CompanyInformationMgt.IsDemoCompany THEN
            EXIT(FALSE);
        IF SIISetup.IsEnabled THEN
            EXIT(FALSE);
        EXIT(MyNotifications.IsEnabled(GetNotificationId));
    END;

    LOCAL PROCEDURE GetNotificationId(): Text;
    BEGIN
        EXIT('C36C1441-6711-4878-9EB4-B8C8EAECD925');
    END;

    // [EventSubscriber(ObjectType::Table, 1875, OnRegisterBusinessSetup, '', true, true)]
    LOCAL PROCEDURE HandleRegisterBusinessSetup(VAR TempBusinessSetup: Record 51145 TEMPORARY);
    VAR
        SIISetup: Record 10751;
    BEGIN
        IF NOT SIISetup.GET THEN BEGIN
            SIISetup.INIT;
            SIISetup.INSERT(TRUE);
        END;

        TempBusinessSetup.InsertExtensionBusinessSetup(
          TempBusinessSetup, SIIServiceNameTxt, SIIBusinessSetupDescriptionTxt, SIIBusinessSetupKeywordsTxt,
          TempBusinessSetup.Area::Service, PAGE::"SII Setup", 'Default');
    END;

    // PROCEDURE GetSIIStyle(SIIState: Option "Pending","Incorrect","Accepted","Accepted With Errors","Communication Error","Failed","Not Supported") StyleText: Text;
    PROCEDURE GetSIIStyle(SIIState: enum "SII Document Status") StyleText: Text;
    
    BEGIN
        CASE SIIState OF
            SIIState::Accepted:
                StyleText := 'Favorable';
            SIIState::"Accepted With Errors":
                StyleText := 'Ambiguous';
            SIIState::Failed,
          SIIState::Incorrect,
          SIIState::"Communication Error":
                StyleText := 'Unfavorable';
            ELSE
                StyleText := 'Standard';
        END;
    END;

    //[External]
    PROCEDURE GetSalesIDType(CustNo: Code[20]; CorrectionType: Option; CorrDocNo: Code[20]): Integer;
    VAR
        Cust: Record 18;
        SalesHeader: Record 36;
        CompanyInformation: Record 79;
        SIIManagement: Codeunit 50026;
        CountryCode: Code[20];
        VATRegNo: Code[20];
    BEGIN
        IF CustNo = '' THEN
            EXIT(0);

        Cust.GET(CustNo);
        IF (CorrectionType = SalesHeader."Correction Type"::Removal) AND (CorrDocNo <> '') THEN BEGIN
            CompanyInformation.GET;
            CountryCode := CompanyInformation."Country/Region Code";
            VATRegNo := CompanyInformation."VAT Registration No.";
        END ELSE BEGIN
            CountryCode := Cust."Country/Region Code";
            VATRegNo := Cust."VAT Registration No.";
        END;
        EXIT(
          SIIManagement.GetIDType(CountryCode, VATRegNo, Cust."Not in AEAT", SIIManagement.CustomerIsIntraCommunity(Cust."No.")));
    END;

    //[External]
    PROCEDURE GetPurchIDType(VendNo: Code[20]; CorrectionType: Option; CorrDocNo: Code[20]): Integer;
    VAR
        Vend: Record 23;
        PurchaseHeader: Record 38;
        SIIManagement: Codeunit 50026;
    BEGIN
        IF VendNo = '' THEN
            EXIT(0);

        Vend.GET(VendNo);
        IF (CorrectionType = PurchaseHeader."Correction Type"::Removal) AND (CorrDocNo <> '') THEN; // keep condition and parameters to avoid breaking changes of external function
        EXIT(
          SIIManagement.GetIDType(
            Vend."Country/Region Code", Vend."VAT Registration No.", FALSE,
            SIIManagement.VendorIsIntraCommunity(Vend."No.")));
    END;

    //[External]
    PROCEDURE GetIDType(CountryCode: Code[20]; VATRegNo: Code[20]; IsNotInAEAT: Boolean; IsIntraCommunity: Boolean): Integer;
    VAR
        SIIDocUploadState: Record 10752;
        SIIManagement: Codeunit 50026;
    BEGIN
        IF SIIManagement.CountryAndVATRegNoAreLocal(CountryCode, VATRegNo) THEN BEGIN
            IF IsNotInAEAT THEN
                EXIT(SIIDocUploadState.IDType::"07-Not On The Census".AsInteger());
            EXIT(0);
        END;
        IF IsIntraCommunity THEN
            EXIT(SIIDocUploadState.IDType::"02-VAT Registration No.".AsInteger());
        IF IsNotInAEAT THEN
            EXIT(SIIDocUploadState.IDType::"07-Not On The Census".AsInteger());
        EXIT(SIIDocUploadState.IDType::"06-Other Probative Document".AsInteger());
    END;

    //[External]
    PROCEDURE GetVendFromLedgEntryByGLSetup(VendorLedgerEntry: Record 25): Code[20];
    VAR
        GeneralLedgerSetup: Record 98;
    BEGIN
        GeneralLedgerSetup.GET;
        CASE GeneralLedgerSetup."Bill-to/Sell-to VAT Calc." OF
            GeneralLedgerSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No.":
                EXIT(VendorLedgerEntry."Vendor No.");
            GeneralLedgerSetup."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No.":
                EXIT(VendorLedgerEntry."Buy-from Vendor No.");
        END;
    END;

    //[External]
    PROCEDURE GetCustFromLedgEntryByGLSetup(CustLedgerEntry: Record 21): Code[20];
    VAR
        GeneralLedgerSetup: Record 98;
    BEGIN
        GeneralLedgerSetup.GET;
        CASE GeneralLedgerSetup."Bill-to/Sell-to VAT Calc." OF
            GeneralLedgerSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No.":
                EXIT(CustLedgerEntry."Customer No.");
            GeneralLedgerSetup."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No.":
                EXIT(CustLedgerEntry."Sell-to Customer No.");
        END;
    END;

    PROCEDURE GetNoTaxablePurchAmount(VAR NoTaxableAmount: Decimal; SourceNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    VAR
        NoTaxableEntry: Record 10740;
    BEGIN
        IF NoTaxableEntriesExistPurchase(NoTaxableEntry, SourceNo, DocumentType, DocumentNo, PostingDate) THEN BEGIN
            NoTaxableEntry.CALCSUMS("Amount (LCY)");
            NoTaxableAmount := -NoTaxableEntry."Amount (LCY)";
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    PROCEDURE GetNoTaxableSalesAmount(VAR NoTaxableAmount: Decimal; SourceNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; DocumentNo: Code[20]; PostingDate: Date; IsService: Boolean; UseNoTaxableType: Boolean; IsLocalRule: Boolean): Boolean;
    VAR
        NoTaxableEntry: Record 10740;
    BEGIN
        IF NoTaxableEntriesExistSales(NoTaxableEntry, SourceNo, DocumentType, DocumentNo, PostingDate, IsService, UseNoTaxableType, IsLocalRule) THEN BEGIN
            NoTaxableEntry.CALCSUMS("Amount (LCY)");
            NoTaxableAmount := -NoTaxableEntry."Amount (LCY)";
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE GetBaseImponibleACosteRegimeCode(): Text;
    BEGIN
        EXIT('06');
    END;

    PROCEDURE SIIStateDrilldown(VAR SIIDocUploadState: Record 10752);
    VAR
        SIIHistory: Record 10750;
    BEGIN
        IF NOT SIIDocUploadState.FINDFIRST THEN
            ERROR(NoSIIStateErr);
        SIIHistory.SETRANGE("Document State Id", SIIDocUploadState.Id);
        SIIHistory.FINDFIRST;
        PAGE.RUN(PAGE::"SII History", SIIHistory);
    END;

    PROCEDURE IsVATEntryCashFlowBased(VATEntry: Record 254): Boolean;
    BEGIN
        // to know if a payment VAT entry is cash based, we look at "Unrealized VAT Entry No."
        // to know if an invoice VAT entry is cash based, we look at "Unrealized Base"
        EXIT((VATEntry."Unrealized VAT Entry No." <> 0) OR (VATEntry."Unrealized Base" <> 0));
    END;

    PROCEDURE IsDetailedLedgerCashFlowBased(DtldLedgerEntryRecRef: RecordRef): Boolean;
    VAR
        LedgerEntryRecRef: RecordRef;
    BEGIN
        GetLedgerFromDetailed(LedgerEntryRecRef, DtldLedgerEntryRecRef);
        EXIT(IsLedgerCashFlowBased(LedgerEntryRecRef));
    END;

    PROCEDURE IsLedgerCashFlowBased(LedgerEntryRecRef: RecordRef): Boolean;
    VAR
        VATEntry: Record 254;
        SourceLedgerEntryRecRef: RecordRef;
        "-------------------------------- QB": Integer;
        GeneralLedgerSetup: Record 98;
    BEGIN
        //JAV 20/07/20: - Si la empresa no tiene activado el IVA de caja, no debe retornar el r�gimen especial
        GeneralLedgerSetup.GET;
        IF (NOT GeneralLedgerSetup."VAT Cash Regime") THEN
            EXIT(FALSE);

        // TRUE only in case of all VAT Entries are Cash Flow based
        SourceLedgerEntryRecRef.GET(LedgerEntryRecRef.RECORDID);
        IF IsBillLedgerEntryRecRef(SourceLedgerEntryRecRef) THEN
            IF NOT FindInvoiceDocLedgerFromBillLedger(SourceLedgerEntryRecRef, SourceLedgerEntryRecRef) THEN
                EXIT(FALSE);

        IF NOT FindVatEntriesFromLedger(SourceLedgerEntryRecRef, VATEntry) THEN
            EXIT(FALSE);

        REPEAT
            IF NOT IsVATEntryCashFlowBased(VATEntry) THEN
                EXIT(FALSE);
        UNTIL VATEntry.NEXT = 0;

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE IsBillLedgerEntryRecRef(LedgerEntryRecRef: RecordRef): Boolean;
    VAR
        DummyCustLedgerEntry: Record 21;
        DocumentTypeFieldRef: FieldRef;
    BEGIN
        DocumentTypeFieldRef := LedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Document Type"));
        DummyCustLedgerEntry."Document Type" := DocumentTypeFieldRef.VALUE;
        EXIT(DummyCustLedgerEntry."Document Type" = DummyCustLedgerEntry."Document Type"::Bill);
    END;

    PROCEDURE IsIntracommunity(CountryRegionCode: Code[10]): Boolean;
    VAR
        DummyCountryRegion: Record 9;
    BEGIN
        IF CountryIsLocal(CountryRegionCode) THEN
            EXIT(FALSE);
        // If EU Country/Region is not blank it means that the country IS in EU and it is NOT Spain (that means, Intracommunity).
        EXIT(DummyCountryRegion.EUCountryFound(CountryRegionCode));
    END;

    LOCAL PROCEDURE FindVatEntryFromDetailedLedger(DetailedLedgerEntryRecRef: RecordRef; VAR VATEntry: Record 254; DocumentType: Option " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund","Bill"): Boolean;
    VAR
        DummyDetailedCustLedgEntry: Record 379;
        TransNoFieldRef: FieldRef;
        DocNumberFieldRef: FieldRef;
        PostingDateFieldRef: FieldRef;
        TransactionNumber: Integer;
        DocNumber: Code[20];
        PostingDate: Date;
    BEGIN
        // get transaction number from ledger rec ref
        TransNoFieldRef := DetailedLedgerEntryRecRef.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Transaction No."));
        TransactionNumber := TransNoFieldRef.VALUE;

        PostingDateFieldRef := DetailedLedgerEntryRecRef.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Posting Date"));
        PostingDate := PostingDateFieldRef.VALUE;

        DocNumberFieldRef := DetailedLedgerEntryRecRef.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Document No."));
        DocNumber := DocNumberFieldRef.VALUE;

        // search for the vat entry
        VATEntry.RESET;
        VATEntry.SETRANGE("Transaction No.", TransactionNumber);
        VATEntry.SETRANGE("Posting Date", PostingDate);
        VATEntry.SETRANGE("Document No.", DocNumber);

        IF DocumentType <> DocumentType::" " THEN
            VATEntry.SETRANGE("Document Type", DocumentType);

        EXIT(VATEntry.FINDFIRST);
    END;

    PROCEDURE FindVatEntriesFromLedger(LedgerEntryRecRef: RecordRef; VAR VATEntry: Record 254): Boolean;
    VAR
        DummyCustLedgerEntry: Record 21;
        TransNoFieldRef: FieldRef;
        DocNumberFieldRef: FieldRef;
        PostingDateFieldRef: FieldRef;
        TransactionNumber: Integer;
        DocNumber: Code[20];
        PostingDate: Date;
    BEGIN
        // get transaction number from ledger rec ref
        TransNoFieldRef := LedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Transaction No."));
        TransactionNumber := TransNoFieldRef.VALUE;

        PostingDateFieldRef := LedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Posting Date"));
        PostingDate := PostingDateFieldRef.VALUE;

        DocNumberFieldRef := LedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Document No."));
        DocNumber := DocNumberFieldRef.VALUE;

        // search for the vat entry
        VATEntry.RESET;
        VATEntry.SETRANGE("Transaction No.", TransactionNumber);
        VATEntry.SETRANGE("Posting Date", PostingDate);
        VATEntry.SETRANGE("Document No.", DocNumber);
        VATEntry.SETRANGE("No Taxable Type", VATEntry."No Taxable Type"::" ");
        EXIT(VATEntry.FINDSET);
    END;

    PROCEDURE FindOriginalLedgerFromDetailedPaymentLedger(PaymentDetailedLedgerEntryRecRef: RecordRef; VAR SalesDocLedgerEntryRecRefOut: RecordRef);
    VAR
        DummyDetailedCustLedgEntry: Record 379;
        PaymentVATEntry: Record 254;
        SalesDocVATEntry: Record 254;
        DocTypeFieldRef: FieldRef;
        DocumentType: Option;
    BEGIN
        DocTypeFieldRef := PaymentDetailedLedgerEntryRecRef.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Document Type"));
        DocumentType := DocTypeFieldRef.VALUE;
        IF DocumentType <> DummyDetailedCustLedgEntry."Document Type"::Payment.AsInteger() THEN
            EXIT;

        FindVatEntryFromDetailedLedger(PaymentDetailedLedgerEntryRecRef, PaymentVATEntry, PaymentVATEntry."Document Type"::Payment.AsInteger());

        SalesDocVATEntry.GET(PaymentVATEntry."Unrealized VAT Entry No.");

        FindLedgerFromVatEntry(SalesDocLedgerEntryRecRefOut, SalesDocVATEntry);
    END;

    PROCEDURE FindOriginalLedgerFromPaymentLedger(PaymentLedgerEntryRecRef: RecordRef; VAR SalesDocLedgerEntryRecRefOut: RecordRef);
    VAR
        DummyCustLedgerEntry: Record 21;
        PaymentVATEntry: Record 254;
        SalesDocVATEntry: Record 254;
        DocTypeFieldRef: FieldRef;
        DocumentType: Option;
    BEGIN
        DocTypeFieldRef := PaymentLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Document Type"));
        DocumentType := DocTypeFieldRef.VALUE;
        IF DocumentType <> DummyCustLedgerEntry."Document Type"::Payment.AsInteger() THEN
            EXIT;

        FindVatEntriesFromLedger(PaymentLedgerEntryRecRef, PaymentVATEntry);

        SalesDocVATEntry.GET(PaymentVATEntry."Unrealized VAT Entry No.");

        FindLedgerFromVatEntry(SalesDocLedgerEntryRecRefOut, SalesDocVATEntry);
    END;

    PROCEDURE FindVatEntriesReferringToDocLedger(InvoiceDocLedgerEntryRecRef: RecordRef; VAR PaymentVATEntry: Record 254): Boolean;
    VAR
        SalesDocVATEntry: Record 254;
    BEGIN
        FindVatEntriesFromLedger(InvoiceDocLedgerEntryRecRef, SalesDocVATEntry);

        PaymentVATEntry.RESET;
        PaymentVATEntry.SETRANGE("Unrealized VAT Entry No.", SalesDocVATEntry."Entry No.");
        EXIT(PaymentVATEntry.FINDSET);
    END;

    PROCEDURE FindDetailedPaymentApplicationLedgerFromLedger(PaymentDocLedgerEntryRecRef: RecordRef; VAR PaymentDetailedDocLedgerEntryRecRefOut: RecordRef; ApplicationDate: Date; DocNumber: Code[20]): Boolean;
    VAR
        DummyCustLedgerEntry: Record 21;
        DummyDetailedCustLedgEntry: Record 379;
        EntryTypeFieldRef: FieldRef;
        DocNumberFieldRef: FieldRef;
        InitialDocTypeFieldRef: FieldRef;
        UnappliedFieldRef: FieldRef;
        PostingDateFieldRef: FieldRef;
        AppliedLedgerEntryNoFieldRef: FieldRef;
        AppliedLedgerEntry: Integer;
    BEGIN
        // the detailed ledger entry should:

        // 1) have the application date
        PostingDateFieldRef := PaymentDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Posting Date"));
        PostingDateFieldRef.SETRANGE(ApplicationDate);

        // 2) have the doc number
        DocNumberFieldRef := PaymentDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Document No."));
        DocNumberFieldRef.SETRANGE(DocNumber);

        // 3) have the "Application" type
        EntryTypeFieldRef := PaymentDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Entry Type"));
        EntryTypeFieldRef.SETRANGE(DummyDetailedCustLedgEntry."Entry Type"::Application);

        // 4) refer to a payment entry "Payment" (we could also look for the "Invoice" one but Payment is probably better here - could apply to credit memos)
        InitialDocTypeFieldRef :=
          PaymentDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Initial Document Type"));
        InitialDocTypeFieldRef.SETRANGE(DummyDetailedCustLedgEntry."Initial Document Type"::Payment); // we want the application to the payment

        // 5) not be unapplied
        UnappliedFieldRef := PaymentDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO(Unapplied));
        UnappliedFieldRef.SETRANGE(FALSE); // ignore unapplied entries

        // 6) refer to the given payment ledger entry
        AppliedLedgerEntryNoFieldRef := PaymentDocLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Entry No."));
        AppliedLedgerEntry := AppliedLedgerEntryNoFieldRef.VALUE;
        AppliedLedgerEntryNoFieldRef :=
          PaymentDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Applied Cust. Ledger Entry No."));
        AppliedLedgerEntryNoFieldRef.SETFILTER(FORMAT(AppliedLedgerEntry));

        EXIT(PaymentDetailedDocLedgerEntryRecRefOut.FINDFIRST);
    END;

    PROCEDURE FindDetailedLedgerFromVatEntry(VAR InvoiceDetailedDocLedgerEntryRecRefOut: RecordRef; InvoiceDocVATEntry: Record 254): Boolean;
    VAR
        DummyDetailedCustLedgEntry: Record 379;
        EntryTypeFieldRef: FieldRef;
        DocNumberFieldRef: FieldRef;
        InitialDocTypeFieldRef: FieldRef;
        UnappliedFieldRef: FieldRef;
        TransactionNbFieldRef: FieldRef;
        PostingDateFieldRef: FieldRef;
    BEGIN
        PostingDateFieldRef := InvoiceDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Posting Date"));
        PostingDateFieldRef.SETRANGE(InvoiceDocVATEntry."Posting Date");

        DocNumberFieldRef := InvoiceDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Document No."));
        DocNumberFieldRef.SETRANGE(InvoiceDocVATEntry."Document No.");

        EntryTypeFieldRef := InvoiceDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Entry Type"));
        EntryTypeFieldRef.SETRANGE(DummyDetailedCustLedgEntry."Entry Type"::Application);

        InitialDocTypeFieldRef :=
          InvoiceDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Initial Document Type"));
        InitialDocTypeFieldRef.SETFILTER('<>' + FORMAT(DummyDetailedCustLedgEntry."Initial Document Type"::Payment)); // we want the application to the invoice, not the payment

        UnappliedFieldRef := InvoiceDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO(Unapplied));
        UnappliedFieldRef.SETRANGE(FALSE); // ignore unapplied entries

        TransactionNbFieldRef := InvoiceDetailedDocLedgerEntryRecRefOut.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Transaction No."));
        TransactionNbFieldRef.SETRANGE(InvoiceDocVATEntry."Transaction No.");

        EXIT(InvoiceDetailedDocLedgerEntryRecRefOut.FINDFIRST);
    END;

    PROCEDURE FindLedgerFromVatEntry(VAR InvoiceDocLedgerEntryRecRefOut: RecordRef; InvoiceDocVATEntry: Record 254);
    VAR
        DummyCustLedgerEntry: Record 21;
        TransNoFieldRef: FieldRef;
        DocNumberFieldRef: FieldRef;
        PostingDateFieldRef: FieldRef;
    BEGIN
        // search for a ledger that has the transaction number of the vat entry
        PostingDateFieldRef := InvoiceDocLedgerEntryRecRefOut.FIELD(DummyCustLedgerEntry.FIELDNO("Posting Date"));
        PostingDateFieldRef.SETRANGE(InvoiceDocVATEntry."Posting Date");

        DocNumberFieldRef := InvoiceDocLedgerEntryRecRefOut.FIELD(DummyCustLedgerEntry.FIELDNO("Document No."));
        DocNumberFieldRef.SETRANGE(InvoiceDocVATEntry."Document No.");

        TransNoFieldRef := InvoiceDocLedgerEntryRecRefOut.FIELD(DummyCustLedgerEntry.FIELDNO("Transaction No."));
        TransNoFieldRef.SETRANGE(InvoiceDocVATEntry."Transaction No.");
        InvoiceDocLedgerEntryRecRefOut.FINDFIRST;
    END;

    LOCAL PROCEDURE FindInvoiceDocLedgerFromBillLedger(VAR InvoiceDocLedgerEntryRecRef: RecordRef; BillLedgerEntryRecRef: RecordRef): Boolean;
    VAR
        DummyCustLedgerEntry: Record 21;
        DocNumberFieldRef: FieldRef;
        DocTypeFieldRef: FieldRef;
        SourceDocNumberFieldRef: FieldRef;
    BEGIN
        SourceDocNumberFieldRef := BillLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Document No."));
        DocNumberFieldRef := InvoiceDocLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Document No."));
        DocNumberFieldRef.SETRANGE(SourceDocNumberFieldRef.VALUE);

        DocTypeFieldRef := InvoiceDocLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Document Type"));
        DocTypeFieldRef.SETFILTER(FORMAT(DummyCustLedgerEntry."Document Type"::Invoice));

        EXIT(InvoiceDocLedgerEntryRecRef.FINDFIRST);
    END;

    PROCEDURE FindPaymentDetailedCustomerLedgerEntries(VAR PaymentDetailedCustLedgEntry: Record 379; CustLedgerEntry: Record 21): Boolean;
    BEGIN
        PaymentDetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
        PaymentDetailedCustLedgEntry.SETRANGE("Document Type", PaymentDetailedCustLedgEntry."Document Type"::Payment);
        PaymentDetailedCustLedgEntry.SETRANGE(Unapplied, FALSE);
        EXIT(PaymentDetailedCustLedgEntry.FINDSET);
    END;

    PROCEDURE FindPaymentDetailedVendorLedgerEntries(VAR PaymentDetailedVendorLedgEntry: Record 380; VendorLedgerEntry: Record 25): Boolean;
    BEGIN
        PaymentDetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
        PaymentDetailedVendorLedgEntry.SETRANGE("Document Type", PaymentDetailedVendorLedgEntry."Document Type"::Payment);
        PaymentDetailedVendorLedgEntry.SETRANGE(Unapplied, FALSE);
        EXIT(PaymentDetailedVendorLedgEntry.FINDSET);
    END;

    PROCEDURE NoTaxableEntriesExistPurchase(VAR NoTaxableEntry: Record 10740; SourceNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; DocumentNo: Code[20]; PostingDate: Date): Boolean;
    BEGIN
        NoTaxableEntry.FilterNoTaxableEntry(NoTaxableEntry.Type::Purchase.AsInteger(), SourceNo, DocumentType, DocumentNo, PostingDate, FALSE);
        NoTaxableEntry.SETRANGE("Not In 347", FALSE);
        EXIT(NOT NoTaxableEntry.ISEMPTY);
    END;

    PROCEDURE NoTaxableEntriesExistSales(VAR NoTaxableEntry: Record 10740; SourceNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; DocumentNo: Code[20]; PostingDate: Date; IsService: Boolean; UseNoTaxableType: Boolean; IsLocalRule: Boolean): Boolean;
    BEGIN
        NoTaxableEntry.FilterNoTaxableEntry(NoTaxableEntry.Type::Sale.AsInteger(), SourceNo, DocumentType, DocumentNo, PostingDate, FALSE);
        NoTaxableEntry.SETRANGE("EU Service", IsService);
        NoTaxableEntry.SETRANGE("Not In 347", FALSE);
        IF UseNoTaxableType THEN
            IF IsLocalRule THEN
                NoTaxableEntry.SETRANGE(
                  "No Taxable Type", NoTaxableEntry."No Taxable Type"::"Non Taxable Due To Localization Rules")
            ELSE
                NoTaxableEntry.SETFILTER(
                  "No Taxable Type", '<>%1', NoTaxableEntry."No Taxable Type"::"Non Taxable Due To Localization Rules");
        EXIT(NOT NoTaxableEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE GetLedgerFromDetailed(VAR LedgerEntryRecRef: RecordRef; DtldLedgerEntryRecRef: RecordRef);
    VAR
        DummyCustLedgerEntry: Record 21;
        DummyDetailedCustLedgEntry: Record 379;
        EntryNoFieldRef: FieldRef;
        SourceEntryNoFieldRef: FieldRef;
    BEGIN
        SourceEntryNoFieldRef := DtldLedgerEntryRecRef.FIELD(DummyDetailedCustLedgEntry.FIELDNO("Cust. Ledger Entry No."));
        IF DtldLedgerEntryRecRef.NUMBER = DATABASE::"Detailed Cust. Ledg. Entry" THEN
            LedgerEntryRecRef.OPEN(DATABASE::"Cust. Ledger Entry", FALSE)
        ELSE
            LedgerEntryRecRef.OPEN(DATABASE::"Vendor Ledger Entry", FALSE);
        EntryNoFieldRef := LedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO("Entry No."));
        EntryNoFieldRef.SETRANGE(SourceEntryNoFieldRef.VALUE);
        LedgerEntryRecRef.FINDFIRST;
    END;

    PROCEDURE DoesPaymentDetailedLedgerCloseInvoice(PaymentDetailedLedgerEntryRecRef: RecordRef; IsCustomerPayment: Boolean): Boolean;
    VAR
        DummyCustLedgerEntry: Record 21;
        InvoiceDocLedgerEntryRecRef: RecordRef;
        OpenFieldRef: FieldRef;
        IsLedgerEntryOpen: Boolean;
    BEGIN
        IF IsCustomerPayment THEN
            InvoiceDocLedgerEntryRecRef.OPEN(DATABASE::"Cust. Ledger Entry", FALSE)
        ELSE
            InvoiceDocLedgerEntryRecRef.OPEN(DATABASE::"Vendor Ledger Entry", FALSE);

        FindOriginalLedgerFromDetailedPaymentLedger(PaymentDetailedLedgerEntryRecRef, InvoiceDocLedgerEntryRecRef);
        OpenFieldRef := InvoiceDocLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO(Open));
        IsLedgerEntryOpen := OpenFieldRef.VALUE;
        EXIT(NOT IsLedgerEntryOpen);
    END;

    PROCEDURE DoesPaymentLedgerCloseInvoice(PaymentLedgerEntryRecRef: RecordRef; IsCustomerPayment: Boolean): Boolean;
    VAR
        DummyCustLedgerEntry: Record 21;
        InvoiceDocLedgerEntryRecRef: RecordRef;
        OpenFieldRef: FieldRef;
        IsLedgerEntryOpen: Boolean;
    BEGIN
        IF IsCustomerPayment THEN
            InvoiceDocLedgerEntryRecRef.OPEN(DATABASE::"Cust. Ledger Entry", FALSE)
        ELSE
            InvoiceDocLedgerEntryRecRef.OPEN(DATABASE::"Vendor Ledger Entry", FALSE);

        FindOriginalLedgerFromPaymentLedger(PaymentLedgerEntryRecRef, InvoiceDocLedgerEntryRecRef);
        OpenFieldRef := InvoiceDocLedgerEntryRecRef.FIELD(DummyCustLedgerEntry.FIELDNO(Open));
        IsLedgerEntryOpen := OpenFieldRef.VALUE;
        EXIT(NOT IsLedgerEntryOpen);
    END;

    PROCEDURE CountryIsLocal(CountryCode: Code[20]): Boolean;
    BEGIN
        EXIT((CountryCode = 'ES') OR (CountryCode = ''));
    END;

    PROCEDURE CountryAndVATRegNoAreLocal(CountryCode: Code[20]; VATRegNo: Code[20]): Boolean;
    BEGIN
        EXIT(CountryIsLocal(CountryCode) OR ((STRPOS(VATRegNo, 'N') = 1) AND NOT CharIsCapitalLetter(VATRegNo[2]))); // VAT Nos starting with 'N' are local, those with 'NL', 'NO', etc. are not.
    END;

    PROCEDURE IsDomesticCustomer(Customer: Record 18): Boolean;
    BEGIN
        EXIT(CountryIsLocal(Customer."Country/Region Code") AND (STRPOS(Customer."VAT Registration No.", 'N') <> 1));
    END;

    PROCEDURE CustomerIsIntraCommunity(CustomerNo: Code[20]): Boolean;
    VAR
        Customer: Record 18;
    BEGIN
        Customer.GET(CustomerNo);
        EXIT(IsIntracommunity(Customer."Country/Region Code"));
    END;

    PROCEDURE VendorIsIntraCommunity(VendorNo: Code[20]): Boolean;
    VAR
        Vendor: Record 23;
    BEGIN
        Vendor.GET(VendorNo);
        EXIT(IsIntracommunity(Vendor."Country/Region Code"));
    END;

    PROCEDURE CombineOperationDescription(OperationDescription1: Text[250]; OperationDescription2: Text[250]; VAR Result: Text[500]);
    BEGIN
        Result := OperationDescription1 + OperationDescription2;
    END;

    PROCEDURE SplitOperationDescription(OperationDescription: Text[500]; VAR Part1: Text[250]; VAR Part2: Text[250]);
    BEGIN
        Part1 := '';
        Part2 := '';

        IF OperationDescription = '' THEN
            EXIT;

        IF STRLEN(OperationDescription) > MAXSTRLEN(Part1) THEN BEGIN
            Part1 := COPYSTR(OperationDescription, 1, MAXSTRLEN(Part1));
            Part2 := COPYSTR(OperationDescription, MAXSTRLEN(Part1) + 1, STRLEN(OperationDescription) - MAXSTRLEN(Part1));
        END ELSE
            Part1 := COPYSTR(OperationDescription, 1, STRLEN(OperationDescription));
    END;

    PROCEDURE CharIsCapitalLetter(Char: Char): Boolean;
    BEGIN
        EXIT(Char IN ['A' .. 'Z']);
    END;

    PROCEDURE IsAllowedSalesInvType(InvType: Option): Boolean;
    VAR
        SalesInvoiceHeader: Record 112;
    BEGIN
        EXIT(InvType IN [SalesInvoiceHeader."Invoice Type"::"F1 Invoice".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"F2 Simplified Invoice".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"F3 Invoice issued to replace simplified invoices".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"F4 Invoice summary entry".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"R1 Corrected Invoice".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"R2 Corrected Invoice (Art. 80.3)".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"R3 Corrected Invoice (Art. 80.4)".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"R4 Corrected Invoice (Other)".AsInteger(),
                         SalesInvoiceHeader."Invoice Type"::"R5 Corrected Invoice in Simplified Invoices".AsInteger()]);
    END;

    PROCEDURE IsAllowedServInvType(InvType: Option): Boolean;
    VAR
        ServiceInvoiceHeader: Record 5992;
    BEGIN
        EXIT(InvType IN [ServiceInvoiceHeader."Invoice Type"::"F1 Invoice".AsInteger(),
                         ServiceInvoiceHeader."Invoice Type"::"F2 Simplified Invoice".AsInteger(),
                         ServiceInvoiceHeader."Invoice Type"::"F3 Invoice issued to replace simplified invoices".AsInteger(),
                         ServiceInvoiceHeader."Invoice Type"::"F4 Invoice summary entry".AsInteger()]);
    END;

    PROCEDURE Run347DeclarationToGenerateCollectionsInCash();
    VAR
        // Make347Declaration: Report 10707;
    BEGIN
        // Make347Declaration.SetCollectionInCashMode(TRUE);
        // Make347Declaration.RUNMODAL;
    END;

    //[External]
    PROCEDURE UpdateSIIInfoInSalesDoc(VAR SalesHeader: Record 36);
    BEGIN
        SalesHeader."Special Scheme Code" :=
          GetSalesSpecialSchemeCode(SalesHeader."Bill-to Customer No.", SalesHeader."VAT Country/Region Code");
    END;

    //[External]
    PROCEDURE UpdateSIIInfoInServiceDoc(VAR ServiceHeader: Record 5900);
    BEGIN
        ServiceHeader."Special Scheme Code" :=
          GetSalesSpecialSchemeCode(ServiceHeader."Bill-to Customer No.", ServiceHeader."VAT Country/Region Code");
    END;

    // LOCAL PROCEDURE GetSalesSpecialSchemeCode(BillToCustomerNo: Code[20]; VATCountryRegionCode: Code[10]): Integer;
    LOCAL PROCEDURE GetSalesSpecialSchemeCode(BillToCustomerNo: Code[20]; VATCountryRegionCode: Code[10]): Enum "SII Sales Special Scheme Code";
    VAR
        GeneralLedgerSetup: Record 98;
        Customer: Record 18;
        SalesHeader: Record 36;
    BEGIN
        GeneralLedgerSetup.GET;
        IF GeneralLedgerSetup."VAT Cash Regime" THEN
            EXIT(SalesHeader."Special Scheme Code"::"07 Special Cash");
        IF BillToCustomerNo <> '' THEN
            IF Customer.GET(BillToCustomerNo) THEN BEGIN
                IF CountryIsLocal(VATCountryRegionCode) OR
                   CustomerIsIntraCommunity(Customer."No.")
                THEN
                    EXIT(SalesHeader."Special Scheme Code"::"01 General");
                EXIT(SalesHeader."Special Scheme Code"::"02 Export");
            END;
    END;

    //[External]
    PROCEDURE UpdateSIIInfoInPurchDoc(VAR PurchaseHeader: Record 38);
    VAR
        GeneralLedgerSetup: Record 98;
        Vendor: Record 23;
    BEGIN
        WITH PurchaseHeader DO BEGIN
            GeneralLedgerSetup.GET;
            IF GeneralLedgerSetup."VAT Cash Regime" THEN
                "Special Scheme Code" := "Special Scheme Code"::"07 Special Cash"
            ELSE
                IF "Pay-to Vendor No." <> '' THEN
                    IF Vendor.GET("Pay-to Vendor No.") THEN
                        IF VendorIsIntraCommunity(Vendor."No.") THEN
                            "Special Scheme Code" := "Special Scheme Code"::"09 Intra-Community Acquisition"
                        ELSE
                            "Special Scheme Code" := "Special Scheme Code"::"01 General";
        END;
    END;

    /*BEGIN
/*{
      JAV 20/07/20: Modifico la funcion IsLedgerCashFlowBased para trabajar con un parametro de Configuracion contabilidad y no devolvere el regimen especial
    }
END.*/
}








