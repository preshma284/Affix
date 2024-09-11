Codeunit 50023 "SII XML Creator 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        CompanyInformation: Record 79;
        SIISetup: Record 10751;
        SIIManagement: Codeunit 50026;
        XMLDOMManagement: Codeunit 6224;
        SoapenvTxt: TextConst ENU = 'http://schemas.xmlsoap.org/soap/envelope/', ESP = 'http://schemas.xmlsoap.org/soap/envelope/';
        CompanyInformationMissingErr: TextConst ENU = 'Your company is not properly set up. Go to company information and complete your setup.', ESP = 'La empresa no est� configurada correctamente. Vaya a la informaci�n de la empresa y complete la configuraci�n.';
        DataTypeManagement: Codeunit 701;
        LastXMLNode: DotNet XmlNode;
        ErrorMsg: Text;
        DetailedLedgerEntryShouldBePaymentErr: TextConst ENU = 'Expected the detailed ledger entry to have a Payment document type, but got %1 instead.', ESP = 'Se esperaba que el movimiento detallado tuviera un tipo de documento de pago, pero en su lugar se obtuvo %1.';
        RegistroDelPrimerSemestreTxt: TextConst ENU = 'Registro del primer semestre', ESP = 'Registro del primer semestre';
        IsInitialized: Boolean;
        RetryAccepted: Boolean;
        SIISetupInitialized: Boolean;
        UploadTypeGlb: Option "Regular","Intracommunity","RetryAccepted","Collection In Cash";
        LCLbl: TextConst ENU = 'LC', ESP = 'LC';
        SIIVersion: Option "1.1","1.0","1.1bis";
        SiiTxt: Text;
        SiiLRTxt: Text;

    PROCEDURE GenerateXml(LedgerEntry: Variant; VAR XMLDocOut: DotNet XmlDocument; UploadType: Option; IsCreditMemoRemoval: Boolean): Boolean;
    VAR
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        DetailedCustLedgEntry: Record 379;
        DetailedVendorLedgEntry: Record 380;
        RecordRef: RecordRef;
        "---------------------------------- QB": Integer;
        QBRelationshipSetup: Record 7207335;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
    BEGIN
        GetSIISetup;
        SiiTxt := SIISetup."SuministroInformacion Schema";
        SiiLRTxt := SIISetup."SuministroLR Schema";
        IF NOT IsInitialized THEN
            XMLDocOut := XMLDocOut.XmlDocument;

        RecordRef.GETTABLE(LedgerEntry);
        CASE RecordRef.NUMBER OF
            DATABASE::"Cust. Ledger Entry":
                BEGIN
                    RecordRef.SETTABLE(CustLedgerEntry);

                    //JAV 28/05/20: - Si no se debe subir al SII salimos de la funcion
                    IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN
                        IF (SalesInvoiceHeader."Do not send to SII") THEN
                            EXIT(FALSE);
                    IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN
                        IF (SalesCrMemoHeader."Do not send to SII") THEN
                            EXIT(FALSE);
                    //JAV 28/05/20 fin

                    //JAV 12/05/22: - QB 1.10.40 Si se ha marcado en los movimientos de cliente o proveedor no subir al SII.
                    IF (CustLedgerEntry."Do not sent to SII") THEN
                        EXIT(FALSE);
                    //JAV 12/05/22 fin

                    IF UploadType = UploadTypeGlb::"Collection In Cash" THEN
                        EXIT(CreateCollectionInCashXml(XMLDocOut, CustLedgerEntry, UploadType));
                    EXIT(CreateInvoicesIssuedLedgerXml(CustLedgerEntry, XMLDocOut, UploadType, IsCreditMemoRemoval));
                END;
            DATABASE::"Vendor Ledger Entry":
                BEGIN
                    RecordRef.SETTABLE(VendorLedgerEntry);

                    //JAV 09/07/19: - Cuando cancelamos un efecto generamos una nueva factura para su pago, esta no debe pasar al SII
                    QBRelationshipSetup.GET;
                    IF QBRelationshipSetup."RP Forma Pago Anulacion" <> '' THEN
                        IF VendorLedgerEntry."Payment Method Code" = QBRelationshipSetup."RP Forma Pago Anulacion" THEN
                            EXIT(FALSE);
                    //JAV 09/07/19 fin

                    //JAV 28/05/20: - Si no se debe subir al SII
                    IF PurchInvHeader.GET(VendorLedgerEntry."Document No.") THEN
                        IF (PurchInvHeader."Do not send to SII") THEN
                            EXIT(FALSE);
                    IF PurchCrMemoHdr.GET(VendorLedgerEntry."Document No.") THEN
                        IF (PurchCrMemoHdr."Do not send to SII") THEN
                            EXIT(FALSE);
                    //JAV 28/05/20 fin

                    //JAV 12/05/22: - QB 1.10.40 Si se ha marcado en los movimientos de cliente o proveedor no subir al SII.
                    IF (VendorLedgerEntry."Do not sent to SII") THEN
                        EXIT(FALSE);
                    //JAV 12/05/22 fin

                    EXIT(CreateInvoicesReceivedLedgerXml(VendorLedgerEntry, XMLDocOut, UploadType, IsCreditMemoRemoval));
                END;
            DATABASE::"Detailed Cust. Ledg. Entry":
                BEGIN
                    RecordRef.SETTABLE(DetailedCustLedgEntry);
                    IF DetailedCustLedgEntry."Document Type" <> DetailedCustLedgEntry."Document Type"::Payment THEN
                        ErrorMsg := STRSUBSTNO(DetailedLedgerEntryShouldBePaymentErr, FORMAT(DetailedCustLedgEntry."Document Type"));
                    CustLedgerEntry.GET(DetailedCustLedgEntry."Cust. Ledger Entry No.");
                    EXIT(CreateReceivedPaymentsXml(CustLedgerEntry, XMLDocOut))
                END;
            DATABASE::"Detailed Vendor Ledg. Entry":
                BEGIN
                    RecordRef.SETTABLE(DetailedVendorLedgEntry);
                    IF DetailedVendorLedgEntry."Document Type" <> DetailedVendorLedgEntry."Document Type"::Payment THEN
                        ErrorMsg := STRSUBSTNO(DetailedLedgerEntryShouldBePaymentErr, FORMAT(DetailedVendorLedgEntry."Document Type"));
                    VendorLedgerEntry.GET(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                    EXIT(CreateEmittedPaymentsXml(VendorLedgerEntry, XMLDocOut))
                END
            ELSE
                EXIT;
        END;
    END;

    LOCAL PROCEDURE CreateEmittedPaymentsXml(PurchaseVendorLedgerEntry: Record 25; VAR XMLDocOut: DotNet XmlDocument): Boolean;
    VAR
        Vendor: Record 23;
        SIIDocUploadState: Record 10752;
        TempXMLNode: DotNet XmlNode;
        XMLNode: DotNet XmlNode;
        PurchaseVendorLedgerEntryRecRef: RecordRef;
        DocumentType: Option "Sales","Purchase","Intra Community","Payment Received","Payment Sent","Collection In Cash";
        HeaderName: Text;
        HeaderVATNo: Text;
    BEGIN
        IF NOT CompanyInformation.GET THEN BEGIN
            ErrorMsg := CompanyInformationMissingErr;
            EXIT;
        END;
        HeaderName := CompanyInformation.Name;
        HeaderVATNo := CompanyInformation."VAT Registration No.";

        SIIDocUploadState.GetSIIDocUploadStateByVendLedgEntry(PurchaseVendorLedgerEntry);
        PopulateXmlPrerequisites(
          XMLDocOut, XMLNode, DocumentType::"Payment Sent", HeaderName, HeaderVATNo, FALSE, UploadTypeGlb::Regular);

        Vendor.GET(PurchaseVendorLedgerEntry."Vendor No.");
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRPagos', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDFactura', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDEmisorFactura', '', 'sii', SiiTxt, XMLNode);

        FillThirdPartyId(
          XMLNode,
          Vendor."Country/Region Code",
          Vendor.Name,
          Vendor."VAT Registration No.",
          Vendor."No.",
          TRUE,
          SIIManagement.VendorIsIntraCommunity(Vendor."No."), FALSE, SIIDocUploadState.IDType);

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', PurchaseVendorLedgerEntry."External Document No.", 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(PurchaseVendorLedgerEntry."Document Date"), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Pagos', '', 'siiLR', SiiLRTxt, XMLNode);

        PurchaseVendorLedgerEntryRecRef.GETTABLE(PurchaseVendorLedgerEntry);
        AddEmittedPayments(XMLNode, PurchaseVendorLedgerEntryRecRef);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateReceivedPaymentsXml(CustLedgerEntry: Record 21; VAR XMLDocOut: DotNet XmlDocument): Boolean;
    VAR
        TempXMLNode: DotNet XmlNode;
        XMLNode: DotNet XmlNode;
        SalesCustLedgerEntryRecRef: RecordRef;
        DocumentType: Option "Sales","Purchase","Intra Community","Payment Received","Payment Sent","Collection In Cash";
        HeaderName: Text;
        HeaderVATNo: Text;
    BEGIN
        IF NOT CompanyInformation.GET THEN BEGIN
            ErrorMsg := CompanyInformationMissingErr;
            EXIT;
        END;
        HeaderName := CompanyInformation.Name;
        HeaderVATNo := CompanyInformation."VAT Registration No.";

        PopulateXmlPrerequisites(
          XMLDocOut, XMLNode, DocumentType::"Payment Received", HeaderName, HeaderVATNo, FALSE, UploadTypeGlb::Regular);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRCobros', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDFactura', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDEmisorFactura', '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NIF', CompanyInformation."VAT Registration No.", 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', CustLedgerEntry."Document No.", 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(CustLedgerEntry."Posting Date"), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Cobros', '', 'siiLR', SiiLRTxt, XMLNode);

        SalesCustLedgerEntryRecRef.GETTABLE(CustLedgerEntry);
        AddReceivedPayments(XMLNode, SalesCustLedgerEntryRecRef);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE AddEmittedPayments(VAR XMLNode: DotNet XmlNode; PurchaseVendorLedgerEntryRecRef: RecordRef);
    VAR
        VendorLedgerEntry: Record 25;
        PaymentDetailedVendorLedgEntry: Record 380;
    BEGIN
        IF SIIManagement.IsLedgerCashFlowBased(PurchaseVendorLedgerEntryRecRef) THEN BEGIN
            PurchaseVendorLedgerEntryRecRef.SETTABLE(VendorLedgerEntry);
            VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type");
            VendorLedgerEntry.SETRANGE("Document No.", VendorLedgerEntry."Document No.");
            IF VendorLedgerEntry.FINDSET THEN
                REPEAT
                    IF SIIManagement.FindPaymentDetailedVendorLedgerEntries(PaymentDetailedVendorLedgEntry, VendorLedgerEntry) THEN
                        REPEAT
                            AddPayment(
                              XMLNode, 'Pago', PaymentDetailedVendorLedgEntry."Posting Date",
                              PaymentDetailedVendorLedgEntry.Amount, VendorLedgerEntry."Payment Method Code");
                        UNTIL PaymentDetailedVendorLedgEntry.NEXT = 0;
                UNTIL VendorLedgerEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE AddReceivedPayments(VAR XMLNode: DotNet XmlNode; SalesCustLedgerEntryRecRef: RecordRef);
    VAR
        CustLedgerEntry: Record 21;
        PaymentDetailedCustLedgEntry: Record 379;
    BEGIN
        IF SIIManagement.IsLedgerCashFlowBased(SalesCustLedgerEntryRecRef) THEN BEGIN
            SalesCustLedgerEntryRecRef.SETTABLE(CustLedgerEntry);
            CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type");
            CustLedgerEntry.SETRANGE("Document No.", CustLedgerEntry."Document No.");
            IF CustLedgerEntry.FINDSET THEN
                REPEAT
                    IF SIIManagement.FindPaymentDetailedCustomerLedgerEntries(PaymentDetailedCustLedgEntry, CustLedgerEntry) THEN
                        REPEAT
                            AddPayment(
                              XMLNode, 'Cobro', PaymentDetailedCustLedgEntry."Posting Date",
                              PaymentDetailedCustLedgEntry.Amount, CustLedgerEntry."Payment Method Code");
                        UNTIL PaymentDetailedCustLedgEntry.NEXT = 0;
                UNTIL CustLedgerEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE AddPayment(VAR XMLNode: DotNet XmlNode; PmtHeaderTxt: Text; PostingDate: Date; Amount: Decimal; PaymentMethodCode: Code[10]);
    VAR
        TempXMLNode: DotNet XmlNode;
        BaseXMLNode: DotNet XmlNode;
    BEGIN
        BaseXMLNode := XMLNode;
        XMLDOMManagement.AddElementWithPrefix(XMLNode, PmtHeaderTxt, '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Fecha', FormatDate(PostingDate), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Importe', FormatNumber(ABS(Amount)), 'sii', SiiTxt, TempXMLNode);
        InsertMedioNode(XMLNode, PaymentMethodCode);
        XMLNode := BaseXMLNode;
    END;

    LOCAL PROCEDURE CalculateNonExemptVATEntries(VAR TempVATEntryOut: Record 254 TEMPORARY; TempVATEntry: Record 254 TEMPORARY; SplitByEUService: Boolean; VATAmount: Decimal);
    BEGIN
        TempVATEntryOut.SETRANGE("VAT %", TempVATEntry."VAT %");
        TempVATEntryOut.SETRANGE("EC %", TempVATEntry."EC %");
        IF SplitByEUService THEN
            TempVATEntryOut.SETRANGE("EU Service", TempVATEntry."EU Service");
        IF TempVATEntryOut.FINDFIRST THEN BEGIN
            TempVATEntryOut.Amount += VATAmount;
            TempVATEntryOut.Base += TempVATEntry.Base + TempVATEntry."Unrealized Base";
            TempVATEntryOut.MODIFY;
        END ELSE BEGIN
            TempVATEntryOut.INIT;
            TempVATEntryOut.COPY(TempVATEntry);
            TempVATEntryOut.Amount := VATAmount;
            TempVATEntryOut.Base := TempVATEntryOut.Base + TempVATEntryOut."Unrealized Base";
            TempVATEntryOut.INSERT;
        END;
        TempVATEntryOut.SETRANGE("VAT %");
        TempVATEntryOut.SETRANGE("EC %");
        TempVATEntryOut.SETRANGE("EU Service");
    END;

    LOCAL PROCEDURE CreateInvoicesIssuedLedgerXml(CustLedgerEntry: Record 21; VAR XMLDocOut: DotNet XmlDocument; UploadType: Option; IsCreditMemoRemoval: Boolean): Boolean;
    VAR
        XMLNode: DotNet XmlNode;
        DocumentType: Option "Sales","Purchase","Intra Community","Payment Received","Payment Sent","Collection In Cash";
    BEGIN
        IF NOT CompanyInformation.GET THEN BEGIN
            ErrorMsg := CompanyInformationMissingErr;
            EXIT(FALSE);
        END;

        PopulateXmlPrerequisites(
          XMLDocOut, XMLNode, DocumentType::Sales, CompanyInformation.Name, CompanyInformation."VAT Registration No.",
          IsCreditMemoRemoval, UploadType);

        LastXMLNode := XMLNode;
        EXIT(PopulateXMLWithSalesInvoice(XMLNode, CustLedgerEntry));
    END;

    LOCAL PROCEDURE CreateInvoicesReceivedLedgerXml(VendorLedgerEntry: Record 25; VAR XMLDocOut: DotNet XmlDocument; UploadType: Option; IsCreditMemoRemoval: Boolean): Boolean;
    VAR
        XMLNode: DotNet XmlNode;
        DocumentType: Option "Sales","Purchase","Intra Community","Payment Received","Payment Sent","Collection In Cash";
    BEGIN
        IF NOT CompanyInformation.GET THEN BEGIN
            ErrorMsg := CompanyInformationMissingErr;
            EXIT(FALSE);
        END;

        PopulateXmlPrerequisites(
          XMLDocOut, XMLNode, DocumentType::Purchase, CompanyInformation.Name, CompanyInformation."VAT Registration No.",
          IsCreditMemoRemoval, UploadType);

        LastXMLNode := XMLNode;
        EXIT(PopulateXMLWithPurchInvoice(XMLNode, VendorLedgerEntry));
    END;

    LOCAL PROCEDURE CreateCollectionInCashXml(VAR XMLDocOut: DotNet XmlDocument; CustLedgEntry: Record 21; UploadType: Option): Boolean;
    VAR
        XMLNode: DotNet XmlNode;
        DocumentType: Option "Sales","Purchase","Intra Community","Payment Received","Payment Sent","Collection In Cash";
    BEGIN
        IF NOT CompanyInformation.GET THEN BEGIN
            ErrorMsg := CompanyInformationMissingErr;
            EXIT(FALSE);
        END;

        PopulateXmlPrerequisites(
          XMLDocOut, XMLNode, DocumentType::"Collection In Cash", CompanyInformation.Name, CompanyInformation."VAT Registration No.",
          FALSE, UploadType);

        LastXMLNode := XMLNode;
        EXIT(PopulateXMLWithCollectionInCash(XMLNode, CustLedgEntry));
    END;

    LOCAL PROCEDURE FindCustLedgerEntryOfRefDocument(CustLedgerEntry: Record 21; VAR OldCustLedgerEntry: Record 21; CorrectedInvoiceNo: Code[20]): Boolean;
    BEGIN
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::"Credit Memo" THEN
            EXIT(FALSE);
        IF CorrectedInvoiceNo = '' THEN
            EXIT(FALSE);
        OldCustLedgerEntry.SETRANGE("Document No.", CorrectedInvoiceNo);
        OldCustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        EXIT(OldCustLedgerEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE FindVendorLedgerEntryOfRefDocument(VendorLedgerEntry: Record 25; VAR OldVendorLedgerEntry: Record 25; CorrectedInvoiceNo: Code[20]): Boolean;
    BEGIN
        IF VendorLedgerEntry."Document Type" <> VendorLedgerEntry."Document Type"::"Credit Memo" THEN
            EXIT(FALSE);
        IF CorrectedInvoiceNo = '' THEN
            EXIT(FALSE);
        OldVendorLedgerEntry.SETRANGE("Document No.", CorrectedInvoiceNo);
        OldVendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        EXIT(OldVendorLedgerEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE PopulateXmlPrerequisites(VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; DocumentType: Option "Sales","Purchase","Intra Community","Payment Received","Payment Sent","Collection In Cash"; Name: Text; VATRegistrationNo: Text; IsCreditMemoRemoval: Boolean; UploadType: Option);
    VAR
        RootXMLNode: DotNet XmlNode;
        CurrentXMlNode: DotNet XmlNode;
        XMLNamespaceManager: DotNet XmlNamespaceManager;
    BEGIN
        IF IsInitialized THEN BEGIN
            XMLNode := LastXMLNode;
            EXIT;
        END;
        IsInitialized := TRUE;

        XMLDOMManagement.AddRootElementWithPrefix(XMLDoc, 'Envelope', 'soapenv', SoapenvTxt, RootXMLNode);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:sii', SiiTxt);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:siiLR', SiiLRTxt);
        XMLDOMManagement.AddDeclaration(XMLDoc, '1.0', 'UTF-8', '');
        XMLNamespaceManager := XMLNamespaceManager.XmlNamespaceManager(RootXMLNode.OwnerDocument.NameTable);
        XMLNamespaceManager.AddNamespace('siiLR', SiiLRTxt);
        XMLNamespaceManager.AddNamespace('sii', SiiTxt);

        XMLDOMManagement.AddElementWithPrefix(RootXMLNode, 'Header', '', 'soapenv', SoapenvTxt, CurrentXMlNode);
        XMLDOMManagement.AddElementWithPrefix(RootXMLNode, 'Body', '', 'soapenv', SoapenvTxt, CurrentXMlNode);
        CASE DocumentType OF
            DocumentType::Sales:
                IF IsCreditMemoRemoval THEN
                    XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'BajaLRFacturasEmitidas', '', 'siiLR', SiiLRTxt, CurrentXMlNode)
                ELSE
                    XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'SuministroLRFacturasEmitidas', '', 'siiLR', SiiLRTxt, CurrentXMlNode);
            DocumentType::Purchase:
                IF IsCreditMemoRemoval THEN
                    XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'BajaLRFacturasRecibidas', '', 'siiLR', SiiLRTxt, CurrentXMlNode)
                ELSE
                    XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'SuministroLRFacturasRecibidas', '', 'siiLR', SiiLRTxt, CurrentXMlNode);
            DocumentType::"Intra Community":
                XMLDOMManagement.AddElementWithPrefix(
                  CurrentXMlNode, 'SuministroLRDetOperacionIntracomunitaria', '', 'siiLR', SiiLRTxt, CurrentXMlNode);
            DocumentType::"Payment Received":
                XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'SuministroLRCobrosEmitidas', '', 'siiLR', SiiLRTxt, CurrentXMlNode);
            DocumentType::"Payment Sent":
                XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'SuministroLRPagosRecibidas', '', 'siiLR', SiiLRTxt, CurrentXMlNode);
            DocumentType::"Collection In Cash":
                XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'SuministroLRCobrosMetalico', '', 'siiLR', SiiLRTxt, CurrentXMlNode);
        END;
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Cabecera', '', 'sii', SiiTxt, CurrentXMlNode);
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'IDVersionSii', COPYSTR(FORMAT(SIIVersion), 1, 3), 'sii', SiiTxt, XMLNode); // API version
        XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'Titular', '', 'sii', SiiTxt, CurrentXMlNode);
        FillCompanyInfo(CurrentXMlNode, Name, VATRegistrationNo);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

        IF NOT (DocumentType IN [DocumentType::"Payment Received", DocumentType::"Payment Sent"]) AND NOT IsCreditMemoRemoval THEN
            IF (UploadType = UploadTypeGlb::RetryAccepted) OR RetryAccepted THEN
                XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'TipoComunicacion', 'A1', 'sii', SiiTxt, XMLNode)
            ELSE
                XMLDOMManagement.AddElementWithPrefix(CurrentXMlNode, 'TipoComunicacion', 'A0', 'sii', SiiTxt, XMLNode);

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLNode := CurrentXMlNode;
    END;

    LOCAL PROCEDURE PopulateXMLWithSalesInvoice(XMLNode: DotNet XmlNode; CustLedgerEntry: Record 21): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
        Customer: Record 18;
        TempServVATEntryCalcNonExempt: Record 254 TEMPORARY;
        TempGoodsVATEntryCalcNonExempt: Record 254 TEMPORARY;
        TempXMLNode: DotNet XmlNode;
        DesgloseFacturaXMLNode: DotNet XmlNode;
        DesgloseTipoOperacionXMLNode: DotNet XmlNode;
        DomesticXMLNode: DotNet XmlNode;
        EUServiceXMLNode: DotNet XmlNode;
        NonEUServiceXMLNode: DotNet XmlNode;
        CustLedgerEntryRecRef: RecordRef;
        //NonExemptTransactionType: ARRAY[2] OF 'S1,S2,S3,Initial';
        NonExemptTransactionType: array[4] of Option S1,S2,S3,Initial;

        i: integer;
        ExemptionCausePresent: ARRAY[2, 10] OF Boolean;
        ExemptExists: ARRAY[2] OF Boolean;
        AddNodeForTotals: Boolean;
        ExemptionBaseAmounts: ARRAY[2, 10] OF Decimal;
        TotalBase: Decimal;
        TotalNonExemptBase: Decimal;
        TotalVATAmount: Decimal;
        TotalAmount: Decimal;
        InvoiceType: Text;
        DomesticCustomer: Boolean;
        RegimeCodes: ARRAY[3] OF Code[2];
    BEGIN

        for i := 1 to 4 do
            case i of
                1:
                    NonExemptTransactionType[i] := NonExemptTransactionType::S1;
                2:
                    NonExemptTransactionType[i] := NonExemptTransactionType::S2;
                3:
                    NonExemptTransactionType[i] := NonExemptTransactionType::S3;
                4:
                    NonExemptTransactionType[i] := NonExemptTransactionType::Initial;
            end;
        Customer.GET(SIIManagement.GetCustFromLedgEntryByGLSetup(CustLedgerEntry));
        DomesticCustomer := SIIManagement.IsDomesticCustomer(Customer);

        SIIDocUploadState.GetSIIDocUploadStateByCustLedgEntry(CustLedgerEntry);
        IF IsSalesInvoice(InvoiceType, SIIDocUploadState) THEN BEGIN
            InitializeSalesXmlBody(XMLNode, CustLedgerEntry."Posting Date");

            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'NumSerieFacturaEmisor', FORMAT(CustLedgerEntry."Document No."), 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(CustLedgerEntry."Posting Date"), 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FacturaExpedida', '', 'siiLR', SiiLRTxt, XMLNode);

            IF InvoiceType = '' THEN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoFactura', 'F1', 'sii', SiiTxt, TempXMLNode)
            ELSE
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'TipoFactura', InvoiceType, 'sii', SiiTxt, TempXMLNode);

            GetClaveRegimenNodeSales(RegimeCodes, SIIDocUploadState, CustLedgerEntry, Customer);
            GenerateNodeForFechaOperacionSales(XMLNode, CustLedgerEntry, RegimeCodes);
            GenerateClaveRegimenNode(XMLNode, RegimeCodes);

            // 0) We may have both Services and Goods parts in the same document
            // 1) Build node for Services
            // 2) Build node for Goods
            IF NOT DomesticCustomer THEN
                GetSourceForServiceOrGoods(
                  TempServVATEntryCalcNonExempt, ExemptionCausePresent[1], ExemptionBaseAmounts[1],
                  NonExemptTransactionType[1], ExemptExists[1], CustLedgerEntry, TRUE, DomesticCustomer);
            GetSourceForServiceOrGoods(
              TempGoodsVATEntryCalcNonExempt, ExemptionCausePresent[2], ExemptionBaseAmounts[2],
              NonExemptTransactionType[2], ExemptExists[2], CustLedgerEntry, FALSE, DomesticCustomer);

            AddNodeForTotals :=
              IncludeImporteTotalNode AND
              ((InvoiceType IN [GetF2InvoiceType, 'F4']) AND
               (TempServVATEntryCalcNonExempt.COUNT + TempGoodsVATEntryCalcNonExempt.COUNT = 1)) OR
              (SIIDocUploadState."Sales Special Scheme Code" IN [SIIDocUploadState."Sales Special Scheme Code"::"03 Special System",
                                                                 SIIDocUploadState."Sales Special Scheme Code"::"05 Travel Agencies"]);
            DataTypeManagement.GetRecordRef(CustLedgerEntry, CustLedgerEntryRecRef);
            CalculateTotalVatAndBaseAmounts(CustLedgerEntryRecRef, TotalBase, TotalNonExemptBase, TotalVATAmount);
            IF AddNodeForTotals THEN BEGIN
                TotalAmount := -TotalBase - TotalVATAmount;
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'ImporteTotal', FormatNumber(TotalAmount), 'sii', SiiTxt, TempXMLNode);
            END;
            FillBaseImponibleACosteNode(XMLNode, RegimeCodes, -TotalNonExemptBase);

            FillOperationDescription(
              XMLNode, GetOperationDescriptionFromDocument(TRUE, CustLedgerEntry."Document No."),
              CustLedgerEntry."Posting Date", CustLedgerEntry.Description);
            FillRefExternaNode(XMLNode, FORMAT(SIIDocUploadState."Entry No"));
            FillSucceededCompanyInfo(XMLNode, SIIDocUploadState);
            IF AddNodeForTotals THEN
                FillMacrodatoNode(XMLNode, TotalAmount);

            IF IncludeContraparteNodeBySalesInvType(InvoiceType) THEN BEGIN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Contraparte', '', 'sii', SiiTxt, XMLNode);
                FillThirdPartyId(
                  XMLNode, Customer."Country/Region Code", Customer.Name, Customer."VAT Registration No.", Customer."No.", TRUE,
                  SIIManagement.CustomerIsIntraCommunity(Customer."No."), Customer."Not in AEAT", SIIDocUploadState.IDType);
            END;

            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoDesglose', '', 'sii', SiiTxt, XMLNode);
            IF DomesticCustomer THEN
                GenerateNodeForServicesOrGoodsDomesticCustomer(
                  TempGoodsVATEntryCalcNonExempt, TempServVATEntryCalcNonExempt, XMLNode, DesgloseFacturaXMLNode, DomesticXMLNode,
                  DesgloseTipoOperacionXMLNode, EUServiceXMLNode, NonEUServiceXMLNode, ExemptionCausePresent, ExemptionBaseAmounts,
                  NonExemptTransactionType, ExemptExists, CustLedgerEntry, DomesticCustomer, RegimeCodes)
            ELSE
                GenerateNodeForServicesOrGoodsForeignCustomer(
                  TempGoodsVATEntryCalcNonExempt, TempServVATEntryCalcNonExempt, XMLNode, DesgloseFacturaXMLNode, DomesticXMLNode,
                  DesgloseTipoOperacionXMLNode, EUServiceXMLNode, NonEUServiceXMLNode, ExemptionCausePresent, ExemptionBaseAmounts,
                  NonExemptTransactionType, ExemptExists, CustLedgerEntry, DomesticCustomer, RegimeCodes);
            EXIT(TRUE);
        END;

        EXIT(HandleCorrectiveInvoiceSales(XMLNode, SIIDocUploadState, CustLedgerEntry, Customer));
    END;

    LOCAL PROCEDURE PopulateXMLWithPurchInvoice(XMLNode: DotNet XmlNode; VendorLedgerEntry: Record 25): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
        TempVATEntryNormalCalculated: Record 254 TEMPORARY;
        TempVATEntryReverseChargeCalculated: Record 254 TEMPORARY;
        VATEntry: Record 254;
        Vendor: Record 23;
        TempXMLNode: DotNet XmlNode;
        VendorLedgerEntryRecRef: RecordRef;
        AddNodeForTotals: Boolean;
        ECVATEntryExists: Boolean;
        CuotaDeducibleValue: Decimal;
        TotalBase: Decimal;
        TotalNonExemptBase: Decimal;
        TotalVATAmount: Decimal;
        TotalAmount: Decimal;
        InvoiceType: Text;
        RegimeCodes: ARRAY[3] OF Code[2];
        VendNo: Code[20];
    BEGIN
        Vendor.GET(VendorLedgerEntry."Vendor No.");
        DataTypeManagement.GetRecordRef(VendorLedgerEntry, VendorLedgerEntryRecRef);

        SIIDocUploadState.GetSIIDocUploadStateByVendLedgEntry(VendorLedgerEntry);
        IF IsPurchInvoice(InvoiceType, SIIDocUploadState) THEN BEGIN
            VendNo := SIIManagement.GetVendFromLedgEntryByGLSetup(VendorLedgerEntry);
            InitializePurchXmlBody(
              XMLNode, VendNo, VendorLedgerEntry."Posting Date", SIIDocUploadState.IDType);

            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'NumSerieFacturaEmisor', FORMAT(VendorLedgerEntry."External Document No."), 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(VendorLedgerEntry."Document Date"), 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FacturaRecibida', '', 'siiLR', SiiLRTxt, XMLNode);

            IF InvoiceType = '' THEN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoFactura', 'F1', 'sii', SiiTxt, TempXMLNode)
            ELSE
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'TipoFactura', InvoiceType, 'sii', SiiTxt, TempXMLNode);

            GenerateNodeForFechaOperacionPurch(XMLNode, VendorLedgerEntry);
            GetClaveRegimenNodePurchases(RegimeCodes, SIIDocUploadState, VendorLedgerEntry, Vendor);
            GenerateClaveRegimenNode(XMLNode, RegimeCodes);
            IF SIIManagement.FindVatEntriesFromLedger(VendorLedgerEntryRecRef, VATEntry) THEN BEGIN
                REPEAT
                    CalculatePurchVATEntries(
                      TempVATEntryNormalCalculated, TempVATEntryReverseChargeCalculated,
                      CuotaDeducibleValue, VATEntry,
                      VendNo, VendorLedgerEntry."Posting Date", InvoiceType);
                    ECVATEntryExists := ECVATEntryExists OR (VATEntry."EC %" <> 0);
                UNTIL VATEntry.NEXT = 0;
            END;

            AddNodeForTotals :=
              IncludeImporteTotalNode AND
              ((InvoiceType IN [GetF2InvoiceType, 'F4']) AND
               (TempVATEntryNormalCalculated.COUNT + TempVATEntryReverseChargeCalculated.COUNT = 1)) OR
              (SIIDocUploadState."Purch. Special Scheme Code" IN [SIIDocUploadState."Purch. Special Scheme Code"::"03 Special System",
                                                                  SIIDocUploadState."Purch. Special Scheme Code"::"05 Travel Agencies"]);
            CalculateTotalVatAndBaseAmounts(VendorLedgerEntryRecRef, TotalBase, TotalNonExemptBase, TotalVATAmount);
            IF AddNodeForTotals THEN BEGIN
                TotalAmount := TotalBase + TotalVATAmount;
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'ImporteTotal', FormatNumber(TotalAmount), 'sii', SiiTxt, TempXMLNode);
            END;
            FillBaseImponibleACosteNode(XMLNode, RegimeCodes, TotalNonExemptBase);

            FillOperationDescription(
              XMLNode, GetOperationDescriptionFromDocument(FALSE, VendorLedgerEntry."Document No."),
              VendorLedgerEntry."Posting Date", VendorLedgerEntry.Description);
            FillRefExternaNode(XMLNode, FORMAT(SIIDocUploadState."Entry No"));
            FillSucceededCompanyInfo(XMLNode, SIIDocUploadState);
            IF AddNodeForTotals THEN
                FillMacrodatoNode(XMLNode, TotalAmount);

            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DesgloseFactura', '', 'sii', SiiTxt, XMLNode);

            AddPurchVATEntriesWithElement(XMLNode, TempVATEntryReverseChargeCalculated, 'InversionSujetoPasivo', RegimeCodes);
            FillNoTaxableVATEntriesPurch(TempVATEntryNormalCalculated, VendorLedgerEntry);
            AddPurchVATEntriesWithElement(XMLNode, TempVATEntryNormalCalculated, 'DesgloseIVA', RegimeCodes);
            XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

            AddPurchTail(
              XMLNode, VendorLedgerEntry."Posting Date", GetRequestDateOfSIIHistoryByVendLedgEntry(VendorLedgerEntry),
              VendNo, CuotaDeducibleValue, SIIDocUploadState.IDType, RegimeCodes, ECVATEntryExists, InvoiceType,
              NOT TempVATEntryReverseChargeCalculated.ISEMPTY);

            EXIT(TRUE);
        END;

        // corrective invoice
        EXIT(HandleCorrectiveInvoicePurchases(XMLNode, SIIDocUploadState, VendorLedgerEntry, Vendor));
    END;

    LOCAL PROCEDURE PopulateXMLWithCollectionInCash(XMLNode: DotNet XmlNode; CustLedgerEntry: Record 21): Boolean;
    VAR
        Customer: Record 18;
        SIIDocUploadState: Record 10752;
        TempXMLNode: DotNet XmlNode;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRCobrosMetalico', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, FillDocHeaderNode, '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Ejercicio', GetYear(CustLedgerEntry."Posting Date"), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Periodo', '0A', 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Contraparte', '', 'siiLR', SiiLRTxt, XMLNode);
        Customer.GET(SIIManagement.GetCustFromLedgEntryByGLSetup(CustLedgerEntry));
        SIIDocUploadState.GetSIIDocUploadStateByCustLedgEntry(CustLedgerEntry);
        FillThirdPartyId(
          XMLNode, Customer."Country/Region Code", Customer.Name, Customer."VAT Registration No.", Customer."No.", TRUE,
          SIIManagement.CustomerIsIntraCommunity(Customer."No."), Customer."Not in AEAT", SIIDocUploadState.IDType);

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'ImporteTotal', FormatNumber(CustLedgerEntry."Sales (LCY)"), 'siiLR', SiiLRTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE AddPurchVATEntriesWithElement(VAR XMLNode: DotNet XmlNode; VAR TempVATEntryCalculated: Record 254 TEMPORARY; XMLNodeName: Text; RegimeCodes: ARRAY[3] OF Code[2]);
    BEGIN
        IF TempVATEntryCalculated.ISEMPTY THEN
            EXIT;
        XMLDOMManagement.AddElementWithPrefix(XMLNode, XMLNodeName, '', 'sii', SiiTxt, XMLNode);
        AddPurchVATEntries(XMLNode, TempVATEntryCalculated, RegimeCodes);
    END;

    PROCEDURE FormatDate(Value: Date): Text;
    BEGIN
        EXIT(FORMAT(Value, 0, '<Day,2>-<Month,2>-<Year4>'));
    END;

    PROCEDURE FormatNumber(Number: Decimal): Text;
    BEGIN
        EXIT(FORMAT(Number, 0, '<Precision,2:2><Standard Format,9>'));
    END;

    LOCAL PROCEDURE GetYear(Value: Date): Text;
    BEGIN
        EXIT(FORMAT(DATE2DMY(Value, 3)));
    END;

    LOCAL PROCEDURE InitializeCorrectiveRemovalXmlBody(VAR XMLNode: DotNet XmlNode; NewPostingDate: Date; IsSales: Boolean; SIIDocUploadState: Record 10752; Name: Text; VATNo: Code[20]; CountryCode: Code[20]; ThirdPartyId: Code[20]; NotInAEAT: Boolean);
    VAR
        TempXMLNode: DotNet XmlNode;
        IssuerName: Text;
        IssuerVATNo: Code[20];
        IssuerCountryCode: Code[20];
        IssuerBackupVatNo: Code[20];
        IsIssuerIntraCommunity: Boolean;
    BEGIN
        IF IsSales THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRBajaExpedidas', '', 'siiLR', SiiLRTxt, XMLNode)
        ELSE
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRBajaRecibidas', '', 'siiLR', SiiLRTxt, XMLNode);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, FillDocHeaderNode, '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'Ejercicio', GetYear(NewPostingDate), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'Periodo', FORMAT(NewPostingDate, 0, '<Month,2>'), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDFactura', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDEmisorFactura', '', 'sii', SiiTxt, XMLNode);

        IF IsSales THEN BEGIN
            IssuerName := CompanyInformation.Name;
            IssuerVATNo := CompanyInformation."VAT Registration No.";
            IssuerCountryCode := CompanyInformation."Country/Region Code";
            IssuerBackupVatNo := CompanyInformation."VAT Registration No.";
            IsIssuerIntraCommunity := FALSE;
        END ELSE BEGIN
            IssuerName := Name;
            IssuerVATNo := VATNo;
            IssuerCountryCode := CountryCode;
            IssuerBackupVatNo := ThirdPartyId;
            IsIssuerIntraCommunity := FALSE;
        END;

        FillThirdPartyId(
          XMLNode,
          IssuerCountryCode,
          IssuerName,
          IssuerVATNo,
          IssuerBackupVatNo,
          NOT IsSales,
          IsIssuerIntraCommunity,
          NotInAEAT, SIIDocUploadState.IDType);

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', FORMAT(SIIDocUploadState."Corrected Doc. No."), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(SIIDocUploadState."Corr. Posting Date"), 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE InitializeSalesXmlBody(VAR XMLNode: DotNet XmlNode; PostingDate: Date);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRFacturasEmitidas', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, FillDocHeaderNode, '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'Ejercicio', GetYear(PostingDate), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'Periodo', FORMAT(PostingDate, 0, '<Month,2>'), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDFactura', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDEmisorFactura', '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NIF', CompanyInformation."VAT Registration No.", 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
    END;

    // LOCAL PROCEDURE InitializePurchXmlBody(VAR XMLNode: DotNet XmlNode; VendorNo: Code[20]; PostingDate: Date; IDType: Integer);
    LOCAL PROCEDURE InitializePurchXmlBody(VAR XMLNode: DotNet XmlNode; VendorNo: Code[20]; PostingDate: Date; IDType: Enum "SII ID Type");
    VAR
        Vendor: Record 23;
        TempXMLNode: DotNet XmlNode;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RegistroLRFacturasRecibidas', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, FillDocHeaderNode, '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'Ejercicio', GetYear(PostingDate), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'Periodo', FORMAT(PostingDate, 0, '<Month,2>'), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDFactura', '', 'siiLR', SiiLRTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDEmisorFactura', '', 'sii', SiiTxt, XMLNode);
        Vendor.GET(VendorNo);
        FillThirdPartyId(
          XMLNode, Vendor."Country/Region Code", Vendor.Name, Vendor."VAT Registration No.", Vendor."No.", FALSE,
          SIIManagement.VendorIsIntraCommunity(Vendor."No."), FALSE, IDType);
    END;

    LOCAL PROCEDURE AddPurchVATEntries(VAR XMLNode: DotNet XmlNode; VAR TempVATEntry: Record 254 TEMPORARY; RegimeCodes: ARRAY[3] OF Code[2]);
    BEGIN
        TempVATEntry.RESET;
        TempVATEntry.SETCURRENTKEY("VAT %", "EC %");
        IF TempVATEntry.FINDSET THEN
            REPEAT
                FillDetalleIVANode(XMLNode, TempVATEntry, TRUE, 1, TRUE, 0, RegimeCodes, 'CuotaSoportada');
            UNTIL TempVATEntry.NEXT = 0;
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
    END;

    // LOCAL PROCEDURE AddPurchTail(VAR XMLNode: DotNet XmlNode; PostingDate: Date; RequestDate: Date; BuyFromVendorNo: Code[20]; CuotaDeducibleValue: Decimal; IDType: Integer; RegimeCodes: ARRAY[3] OF Code[2]; ECVATEntryExists: Boolean; InvoiceType: Text; HasReverseChargeEntry: Boolean);
    LOCAL PROCEDURE AddPurchTail(VAR XMLNode: DotNet XmlNode; PostingDate: Date; RequestDate: Date; BuyFromVendorNo: Code[20]; CuotaDeducibleValue: Decimal; IDType: enum "SII ID Type"; RegimeCodes: ARRAY[3] OF Code[2]; ECVATEntryExists: Boolean; InvoiceType: Text; HasReverseChargeEntry: Boolean);
    VAR
        Vendor: Record 23;
        TempXMLNode: DotNet XmlNode;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Contraparte', '', 'sii', SiiTxt, XMLNode);
        Vendor.GET(BuyFromVendorNo);
        FillThirdPartyId(
          XMLNode, Vendor."Country/Region Code", Vendor.Name, Vendor."VAT Registration No.", Vendor."No.",
          TRUE, SIIManagement.VendorIsIntraCommunity(Vendor."No."), FALSE, IDType);

        FillFechaRegContable(XMLNode, PostingDate, RequestDate);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'CuotaDeducible',
          FormatNumber(CalcCuotaDeducible(PostingDate, RegimeCodes, IDType, ECVATEntryExists, InvoiceType,
              HasReverseChargeEntry, CuotaDeducibleValue)),
          'sii', SiiTxt, TempXMLNode);
    END;

    // LOCAL PROCEDURE FillThirdPartyId(VAR XMLNode: DotNet XmlNode; CountryCode: Code[20]; Name: Text; VatNo: Code[20]; BackupVatId: Code[20]; NeedNombreRazon: Boolean; IsIntraCommunity: Boolean; IsNotInAEAT: Boolean; IDTypeInt: Integer);
    LOCAL PROCEDURE FillThirdPartyId(VAR XMLNode: DotNet XmlNode; CountryCode: Code[20]; Name: Text; VatNo: Code[20]; BackupVatId: Code[20]; NeedNombreRazon: Boolean; IsIntraCommunity: Boolean; IsNotInAEAT: Boolean; IDTypeInt: Enum "SII ID Type");
    VAR
        TempXMLNode: DotNet XmlNode;
        IDType: Text[30];
    BEGIN
        IF VatNo = '' THEN
            VatNo := BackupVatId;
        IDType := GetIDTypeToExport(IDTypeInt);
        IF SIIManagement.CountryAndVATRegNoAreLocal(CountryCode, VatNo) THEN BEGIN
            IF NeedNombreRazon THEN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NombreRazon', Name, 'sii', SiiTxt, TempXMLNode);
            IF IsNotInAEAT THEN BEGIN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDOtro', '', 'sii', SiiTxt, XMLNode);
                // In case of self employment, we use '07' means "Unregistered"
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'CodigoPais', CountryCode, 'sii', SiiTxt, TempXMLNode);
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDType', IDType, 'sii', SiiTxt, TempXMLNode);
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'ID', VatNo, 'sii', SiiTxt, TempXMLNode);
                XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
            END ELSE
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NIF', VatNo, 'sii', SiiTxt, TempXMLNode);
        END ELSE BEGIN
            IF NeedNombreRazon THEN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NombreRazon', Name, 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDOtro', '', 'sii', SiiTxt, XMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'CodigoPais', CountryCode, 'sii', SiiTxt, TempXMLNode);

            IF IsIntraCommunity THEN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDType', IDType, 'sii', SiiTxt, TempXMLNode)
            ELSE
                IF IsNotInAEAT THEN
                    // In case of self employment, we use '07' means "Unregistered"
                    XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDType', IDType, 'sii', SiiTxt, TempXMLNode)
                ELSE
                    XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDType', IDType, 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'ID', VatNo, 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        END;
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
    END;

    LOCAL PROCEDURE AddTipoDesgloseDetailHeader(VAR TipoDesgloseXMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUXMLNode: DotNet XmlNode; VAR VATXMLNode: DotNet XmlNode; EUService: Boolean; DomesticCustomer: Boolean; NoTaxableVAT: Boolean);
    VAR
        VATNodeName: Text;
    BEGIN
        VATNodeName := GetVATNodeName(NoTaxableVAT);
        IF DomesticCustomer THEN BEGIN
            IF ISNULL(DesgloseFacturaXMLNode) THEN
                XMLDOMManagement.AddElementWithPrefix(TipoDesgloseXMLNode, 'DesgloseFactura', '', 'sii', SiiTxt, DesgloseFacturaXMLNode);
            IF ISNULL(DomesticXMLNode) THEN
                XMLDOMManagement.AddElementWithPrefix(DesgloseFacturaXMLNode, VATNodeName, '', 'sii', SiiTxt, DomesticXMLNode);
            VATXMLNode := DomesticXMLNode;
        END ELSE BEGIN
            IF ISNULL(DesgloseTipoOperacionXMLNode) THEN
                XMLDOMManagement.AddElementWithPrefix(
                  TipoDesgloseXMLNode, 'DesgloseTipoOperacion', '', 'sii', SiiTxt, DesgloseTipoOperacionXMLNode);
            IF EUService THEN
                AddVATXMLNodeUnderParentNode(EUXMLNode, VATXMLNode, DesgloseTipoOperacionXMLNode, 'PrestacionServicios', VATNodeName)
            ELSE
                AddVATXMLNodeUnderParentNode(EUXMLNode, VATXMLNode, DesgloseTipoOperacionXMLNode, 'Entrega', VATNodeName);
        END;
    END;

    LOCAL PROCEDURE AddVATXMLNodeUnderParentNode(VAR EUXMLNode: DotNet XmlNode; VAR VATXMLNode: DotNet XmlNode; DesgloseTipoOperacionXMLNode: DotNet XmlNode; ParentVATNodeName: Text; VATNodeName: Text);
    BEGIN
        IF ISNULL(EUXMLNode) THEN
            XMLDOMManagement.AddElementWithPrefix(DesgloseTipoOperacionXMLNode, ParentVATNodeName, '', 'sii', SiiTxt, EUXMLNode);
        IF ISNULL(VATXMLNode) THEN
            XMLDOMManagement.AddElementWithPrefix(EUXMLNode, VATNodeName, '', 'sii', SiiTxt, VATXMLNode);
    END;

    LOCAL PROCEDURE FillSucceededCompanyInfo(VAR XMLNode: DotNet XmlNode; SIIDocUploadState: Record 10752);
    BEGIN
        IF (NOT IncludeChangesVersion11) OR (SIIDocUploadState."Succeeded Company Name" = '') THEN
            EXIT;

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'EntidadSucedida', '', 'sii', SiiTxt, XMLNode);
        FillCompanyInfo(XMLNode, SIIDocUploadState."Succeeded Company Name", SIIDocUploadState."Succeeded VAT Registration No.");
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
    END;

    LOCAL PROCEDURE FillCompanyInfo(VAR XMLNode: DotNet XmlNode; Name: Text; VATRegistrationNo: Text);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NombreRazon', Name, 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NIF', VATRegistrationNo, 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE CalculateECAmount(Base: Decimal; ECPercentage: Decimal): Decimal;
    VAR
        GeneralLedgerSetup: Record 98;
    BEGIN
        GeneralLedgerSetup.GET;
        EXIT(ROUND(Base * ECPercentage / 100, GeneralLedgerSetup."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE CalculateNonTaxableAmountVendor(VendLedgEntry: Record 25): Decimal;
    VAR
        NoTaxableEntry: Record 10740;
    BEGIN
        IF SIIManagement.NoTaxableEntriesExistPurchase(
             NoTaxableEntry,
             SIIManagement.GetVendFromLedgEntryByGLSetup(VendLedgEntry), VendLedgEntry."Document Type",
             VendLedgEntry."Document No.", VendLedgEntry."Posting Date")
        THEN BEGIN
            NoTaxableEntry.CALCSUMS("Amount (LCY)");
            EXIT(NoTaxableEntry."Amount (LCY)");
        END;
        EXIT(0);
    END;

    LOCAL PROCEDURE CalcNonExemptVATEntriesWithCuotaDeducible(VAR TempVATEntry: Record 254 TEMPORARY; VAR CuotaDeducible: Decimal; VendorLedgerEntry: Record 25; Sign: Integer);
    VAR
        VATEntry: Record 254;
        VendorLedgerEntryRecRef: RecordRef;
        VATAmount: Decimal;
    BEGIN
        DataTypeManagement.GetRecordRef(VendorLedgerEntry, VendorLedgerEntryRecRef);
        IF SIIManagement.FindVatEntriesFromLedger(VendorLedgerEntryRecRef, VATEntry) THEN
            REPEAT
                VATAmount := CalcVATAmountExclEC(VATEntry);
                CuotaDeducible += Sign * ABS(VATAmount);
                CalculateNonExemptVATEntries(TempVATEntry, VATEntry, TRUE, VATAmount);
            UNTIL VATEntry.NEXT = 0;
    END;

    PROCEDURE GetLastErrorMsg(): Text;
    BEGIN
        EXIT(ErrorMsg);
    END;

    LOCAL PROCEDURE GetSourceForServiceOrGoods(VAR TempVATEntryCalculatedNonExempt: Record 254 TEMPORARY; VAR ExemptionCausePresent: ARRAY[10] OF Boolean; VAR ExemptionBaseAmounts: ARRAY[10] OF Decimal; VAR NonExemptTransactionType: Option "S1","S2","S3","Initial"; VAR ExemptExists: Boolean; CustLedgerEntry: Record 21; IsService: Boolean; DomesticCustomer: Boolean);
    VAR
        VATEntry: Record 254;
        DataTypeManagement: Codeunit 701;
        SIIInitialDocUpload: Codeunit 51303;
        RecRef: RecordRef;
        ExemptionCode: Option;
    BEGIN
        DataTypeManagement.GetRecordRef(CustLedgerEntry, RecRef);
        SIIManagement.FindVatEntriesFromLedger(RecRef, VATEntry);
        IF NOT DomesticCustomer THEN
            VATEntry.SETRANGE("EU Service", IsService);
        IF VATEntry.FINDSET THEN BEGIN
            IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(CustLedgerEntry."Posting Date") THEN
                NonExemptTransactionType := NonExemptTransactionType::S1
            ELSE
                NonExemptTransactionType := NonExemptTransactionType::Initial;
            REPEAT
                BuildVATEntrySource(
                  ExemptExists, ExemptionCausePresent, ExemptionCode, ExemptionBaseAmounts,
                  TempVATEntryCalculatedNonExempt, NonExemptTransactionType, VATEntry, CustLedgerEntry."Posting Date", TRUE);
            UNTIL VATEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE GenerateNodeForServicesOrGoodsDomesticCustomer(VAR TempGoodsVATEntryCalcNonExempt: Record 254 TEMPORARY; VAR TempServVATEntryCalcNonExempt: Record 254 TEMPORARY; VAR XMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUServiceXMLNode: DotNet XmlNode; VAR NonEUServiceXMLNode: DotNet XmlNode; ExemptionCausePresent: ARRAY[2, 10] OF Boolean; ExemptionBaseAmounts: ARRAY[2, 10] OF Decimal; NonExemptTransactionType: ARRAY[2] OF Option; ExemptExists: ARRAY[2] OF Boolean; CustLedgerEntry: Record 21; DomesticCustomer: Boolean; RegimeCodes: ARRAY[3] OF Code[2]);
    BEGIN
        GenerateNodeForServicesOrGoods(
          TempGoodsVATEntryCalcNonExempt, XMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
          EUServiceXMLNode, NonEUServiceXMLNode, ExemptionCausePresent[2], ExemptionBaseAmounts[2],
          NonExemptTransactionType[2], ExemptExists[2], CustLedgerEntry, FALSE, DomesticCustomer, RegimeCodes);
        GenerateNodeForServicesOrGoods(
          TempServVATEntryCalcNonExempt, XMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
          EUServiceXMLNode, NonEUServiceXMLNode, ExemptionCausePresent[1], ExemptionBaseAmounts[1],
          NonExemptTransactionType[1], ExemptExists[1], CustLedgerEntry, TRUE, DomesticCustomer, RegimeCodes);
    END;

    LOCAL PROCEDURE GenerateNodeForServicesOrGoodsForeignCustomer(VAR TempGoodsVATEntryCalcNonExempt: Record 254 TEMPORARY; VAR TempServVATEntryCalcNonExempt: Record 254 TEMPORARY; VAR XMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUServiceXMLNode: DotNet XmlNode; VAR NonEUServiceXMLNode: Dotnet XmlNode; ExemptionCausePresent: ARRAY[2, 10] OF Boolean; ExemptionBaseAmounts: ARRAY[2, 10] OF Decimal; NonExemptTransactionType: ARRAY[2] OF Option; ExemptExists: ARRAY[2] OF Boolean; CustLedgerEntry: Record 21; DomesticCustomer: Boolean; RegimeCodes: ARRAY[3] OF Code[2]);
    BEGIN
        GenerateNodeForServicesOrGoods(
          TempServVATEntryCalcNonExempt, XMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
          EUServiceXMLNode, NonEUServiceXMLNode, ExemptionCausePresent[1], ExemptionBaseAmounts[1],
          NonExemptTransactionType[1], ExemptExists[1], CustLedgerEntry, TRUE, DomesticCustomer, RegimeCodes);
        GenerateNodeForServicesOrGoods(
          TempGoodsVATEntryCalcNonExempt, XMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
          EUServiceXMLNode, NonEUServiceXMLNode, ExemptionCausePresent[2], ExemptionBaseAmounts[2],
          NonExemptTransactionType[2], ExemptExists[2], CustLedgerEntry, FALSE, DomesticCustomer, RegimeCodes);
    END;

    LOCAL PROCEDURE GenerateNodeForServicesOrGoods(VAR TempVATEntryCalculatedNonExempt: Record 254 TEMPORARY; VAR TipoDesgloseXMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUServiceXMLNode: DotNet XmlNode; VAR NonEUServiceXMLNode: DotNet XmlNode; ExemptionCausePresent: ARRAY[10] OF Boolean; ExemptionBaseAmounts: ARRAY[10] OF Decimal; NonExemptTransactionType: Option "S1","S2","S3","Initial"; ExemptExists: Boolean; CustLedgerEntry: Record 21; IsService: Boolean; DomesticCustomer: Boolean; RegimeCodes: ARRAY[3] OF Code[2]);
    VAR
        SIIInitialDocUpload: Codeunit 51303;
        TempXmlNode: DotNet XmlNode;
        BaseNode: DotNet XmlNode;
        VATXMLNode: DotNet XmlNode;
        EUXMLNode: DotNet XmlNode;
        NonTaxHandled: Boolean;
    BEGIN
        BaseNode := TipoDesgloseXMLNode;

        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(CustLedgerEntry."Posting Date") THEN BEGIN
            MoveNonTaxableEntriesToTempVATEntryBuffer(TempVATEntryCalculatedNonExempt, CustLedgerEntry, IsService);
            NonTaxHandled := TRUE;
        END;

        IF ExemptExists THEN BEGIN
            AddTipoDesgloseDetailHeader(
              TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode, EUXMLNode,
              VATXMLNode, IsService, DomesticCustomer, FALSE);
            HandleExemptEntries(VATXMLNode, ExemptionCausePresent, ExemptionBaseAmounts);
        END;

        // Generating XML node for NonExempt part
        TempVATEntryCalculatedNonExempt.RESET;
        TempVATEntryCalculatedNonExempt.SETCURRENTKEY("VAT %", "EC %");
        IF TempVATEntryCalculatedNonExempt.FINDSET THEN BEGIN
            AddTipoDesgloseDetailHeader(
              TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
              EUXMLNode, VATXMLNode, IsService, DomesticCustomer, FALSE);
            XMLDOMManagement.AddElementWithPrefix(VATXMLNode, 'NoExenta', '', 'sii', SiiTxt, VATXMLNode);
            XMLDOMManagement.AddElementWithPrefix(VATXMLNode, 'TipoNoExenta', FORMAT(NonExemptTransactionType), 'sii', SiiTxt, TempXmlNode);
            XMLDOMManagement.AddElementWithPrefix(VATXMLNode, 'DesgloseIVA', '', 'sii', SiiTxt, VATXMLNode);
            REPEAT
                FillDetalleIVANode(
                  VATXMLNode, TempVATEntryCalculatedNonExempt, TRUE, -1, NOT IsService, NonExemptTransactionType, RegimeCodes, 'CuotaRepercutida');
            UNTIL TempVATEntryCalculatedNonExempt.NEXT = 0;
        END;

        IF NOT NonTaxHandled THEN BEGIN
            CLEAR(DomesticXMLNode);
            CLEAR(EUServiceXMLNode);
            CLEAR(NonEUServiceXMLNode);
            HandleNonTaxableVATEntries(
              CustLedgerEntry,
              TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
              EUXMLNode, IsService, DomesticCustomer);
            CLEAR(DomesticXMLNode);
        END;

        TipoDesgloseXMLNode := BaseNode;
    END;

    LOCAL PROCEDURE GenerateNodeForNonTaxableVAT(NonTaxableAmount: Decimal; VAR XMLNode: DotNet XmlNode; XMLNodeName: Text);
    VAR
        BaseNode: DotNet XmlNode;
    BEGIN
        BaseNode := XMLNode;

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, XMLNodeName, FormatNumber(NonTaxableAmount), 'sii', SiiTxt, XMLNode);

        XMLNode := BaseNode;
    END;

    LOCAL PROCEDURE FillNoTaxableVATEntriesPurch(VAR TempVATEntryCalculated: Record 254 TEMPORARY; VendLedgEntry: Record 25);
    VAR
        NonTaxableAmount: Decimal;
    BEGIN
        NonTaxableAmount := CalculateNonTaxableAmountVendor(VendLedgEntry);
        IF NonTaxableAmount = 0 THEN
            EXIT;

        TempVATEntryCalculated.RESET;
        IF TempVATEntryCalculated.FINDLAST THEN;

        TempVATEntryCalculated.INIT;
        TempVATEntryCalculated."Entry No." += 1;
        TempVATEntryCalculated.Base := NonTaxableAmount;
        TempVATEntryCalculated.Type := TempVATEntryCalculated.Type::Purchase;
        // assign non-blank value to distinguish between the normal VAT entry from non-taxable one
        TempVATEntryCalculated."No Taxable Type" := TempVATEntryCalculated."No Taxable Type"::"Non Taxable Art 7-14 and others";
        TempVATEntryCalculated.INSERT;
    END;

    LOCAL PROCEDURE GetExemptionCode(VATEntry: Record 254; VAR ExemptionCode: Option): Boolean;
    VAR
        VATPostingSetup: Record 325;
        VATClause: Record 560;
    BEGIN
        VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
        IF VATPostingSetup."VAT Clause Code" <> '' THEN BEGIN
            VATClause.GET(VATPostingSetup."VAT Clause Code");
            // IF VATClause."SII Exemption Code" = VATClause."SII Exemption Code"::" " THEN
            //     EXIT(FALSE);
            // ExemptionCode := VATClause."SII Exemption Code";
            EXIT(TRUE);
        END
    END;

    LOCAL PROCEDURE CalculateExemptVATEntries(VAR ExemptionCausesPresent: ARRAY[10] OF Boolean; VAR ExemptionBaseAmounts: ARRAY[10] OF Decimal; TempVATEntry: Record 254 TEMPORARY; ExemptionCode: Option);
    BEGIN
        // We have 7 exemption codes: first is empty, the remaining are E1-E6.;
        // Options enumerated from 0, arrays - from 1.
        // We do not process "empty" exemption code here, thus no index modifications required.
        IF ExemptionCausesPresent[ExemptionCode] THEN
            ExemptionBaseAmounts[ExemptionCode] += TempVATEntry.Base
        ELSE BEGIN
            ExemptionCausesPresent[ExemptionCode] := TRUE;
            ExemptionBaseAmounts[ExemptionCode] := TempVATEntry.Base;
        END;
    END;

    LOCAL PROCEDURE CalculatePurchVATEntries(VAR TempVATEntryNormalCalculated: Record 254 TEMPORARY; VAR TempVATEntryReverseChargeCalculated: Record 254 TEMPORARY; VAR CuotaDeducibleValue: Decimal; VATEntry: Record 254; VendorNo: Code[20]; PostingDate: Date; InvoiceType: Text);
    VAR
        VATAmount: Decimal;
    BEGIN
        VATAmount := VATEntry.Amount + VATEntry."Unrealized Amount";
        CuotaDeducibleValue += VATAmount;
        OnAfterCalculateCuotaDeducibleValue(CuotaDeducibleValue, VATAmount, VATEntry);

        IF UseReverseChargeNotIntracommunity(VATEntry."VAT Calculation Type", VendorNo, PostingDate, InvoiceType) THEN //enum to option
            CalculateNonExemptVATEntries(TempVATEntryReverseChargeCalculated, VATEntry, TRUE, VATAmount)
        ELSE
            CalculateNonExemptVATEntries(TempVATEntryNormalCalculated, VATEntry, TRUE, VATAmount);
    END;

    LOCAL PROCEDURE BuildNonExemptTransactionType(VATEntry: Record 254; VAR TransactionType: Option "S1","S2","S3","Initial");
    BEGIN
        // "Reverse Charge VAT" means S2
        IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
            IF TransactionType = TransactionType::Initial THEN
                TransactionType := TransactionType::S2
            ELSE
                IF TransactionType = TransactionType::S1 THEN BEGIN
                    TransactionType := TransactionType::S3
                END
        END ELSE BEGIN
            IF TransactionType = TransactionType::Initial THEN
                TransactionType := TransactionType::S1
            ELSE
                IF TransactionType = TransactionType::S2 THEN BEGIN
                    TransactionType := TransactionType::S3
                END
        END;
    END;

    LOCAL PROCEDURE BuildExemptionCodeString(ExemptionIndex: Integer): Text;
    BEGIN
        CASE ExemptionIndex OF
            1:
                EXIT('E1');
            2:
                EXIT('E2');
            3:
                EXIT('E3');
            4:
                EXIT('E4');
            5:
                EXIT('E5');
            6:
                EXIT('E6');
        END;
    END;

    LOCAL PROCEDURE HandleCorrectiveInvoiceSales(VAR XMLNode: DotNet XmlNode; SIIDocUploadState: Record 10752; CustLedgerEntry: Record 21; Customer: Record 18): Boolean;
    VAR
        OldCustLedgerEntry: Record 21;
        SalesCrMemoHeader: Record 114;
        TempXMLNode: DotNet XmlNode;
        CustLedgerEntryRecRef: RecordRef;
        TotalBase: Decimal;
        TotalNonExemptBase: Decimal;
        TotalVATAmount: Decimal;
        CorrectedInvoiceNo: Code[20];
        CorrectionType: Option;
    BEGIN
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Invoice THEN BEGIN
            GetCorrectionInfoFromDocument(
              CustLedgerEntry."Document No.", CorrectedInvoiceNo, CorrectionType,
              CustLedgerEntry."Correction Type", CustLedgerEntry."Corrected Invoice No.");
            IF FindCustLedgerEntryOfRefDocument(CustLedgerEntry, OldCustLedgerEntry, CorrectedInvoiceNo) THEN
                IF CorrectionType = SalesCrMemoHeader."Correction Type"::Removal THEN BEGIN
                    InitializeCorrectiveRemovalXmlBody(
                      XMLNode, CustLedgerEntry."Posting Date", TRUE, SIIDocUploadState,
                      Customer.Name, Customer."VAT Registration No.", Customer."Country/Region Code", Customer."No.", Customer."Not in AEAT");
                    EXIT(TRUE);
                END;
        END;
        InitializeSalesXmlBody(XMLNode, CustLedgerEntry."Posting Date");

        // calculate totals for current doc
        DataTypeManagement.GetRecordRef(CustLedgerEntry, CustLedgerEntryRecRef);
        CalculateTotalVatAndBaseAmounts(CustLedgerEntryRecRef, TotalBase, TotalNonExemptBase, TotalVATAmount);

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', FORMAT(CustLedgerEntry."Document No."), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(CustLedgerEntry."Posting Date"), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FacturaExpedida', '', 'siiLR', SiiLRTxt, XMLNode);
        // IF SIIDocUploadState."Sales Cr. Memo Type" = 0 THEN
        if SIIDocUploadState."Sales Cr. Memo Type" = SIIDocUploadState."Sales Cr. Memo Type"::" " then
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoFactura', 'R1', 'sii', SiiTxt, TempXMLNode)
        ELSE
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'TipoFactura', COPYSTR(FORMAT(SIIDocUploadState."Sales Cr. Memo Type"), 1, 2), 'sii', SiiTxt, TempXMLNode);

        IF (CorrectionType = SalesCrMemoHeader."Correction Type"::Replacement) OR
           (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice)
        THEN
            HandleReplacementSalesCorrectiveInvoice(
              XMLNode, SIIDocUploadState, OldCustLedgerEntry, CustLedgerEntry, Customer, TotalBase, TotalNonExemptBase, TotalVATAmount)
        ELSE
            CorrectiveInvoiceSalesDifference(
              XMLNode, SIIDocUploadState, OldCustLedgerEntry, CustLedgerEntry, Customer, TotalBase, TotalNonExemptBase, TotalVATAmount);

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CorrectiveInvoiceSalesDifference(VAR XMLNode: DotNet XmlNode; SIIDocUploadState: Record 10752; OldCustLedgerEntry: Record 21; CustLedgerEntry: Record 21; Customer: Record 18; TotalBase: Decimal; TotalNonExemptBase: Decimal; TotalVATAmount: Decimal);
    VAR
        TempVATEntryPerPercent: Record 254 TEMPORARY;
        SIIInitialDocUpload: Codeunit 51303;
        TempXMLNode: DotNet XmlNode;
        TipoDesgloseXMLNode: DotNet XmlNode;
        DesgloseFacturaXMLNode: DotNet XmlNode;
        DomesticXMLNode: DotNet XmlNode;
        DesgloseTipoOperacionXMLNode: DotNet XmlNode;
        EUServiceXMLNode: DotNet XmlNode;
        NonEUServiceXMLNode: DotNet XmlNode;
        EUXMLNode: DotNet XmlNode;
        VATXMLNode: DotNet XmlNode;
        TotalAmount: Decimal;
        EUService: Boolean;
        EntriesFound: Boolean;
        DomesticCustomer: Boolean;
        NonTaxHandled: Boolean;
        RegimeCodes: ARRAY[3] OF Code[2];
        NonExemptTransactionType: Option "S1","S2","S3","Initial";
        ExemptExists: Boolean;
        ExemptionCausePresent: ARRAY[10] OF Boolean;
        ExemptionBaseAmounts: ARRAY[10] OF Decimal;
    BEGIN
        DomesticCustomer := SIIManagement.IsDomesticCustomer(Customer);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoRectificativa', 'I', 'sii', SiiTxt, TempXMLNode);
        GenerateFacturasRectificadasNode(XMLNode, OldCustLedgerEntry."Document No.", OldCustLedgerEntry."Posting Date");
        GetClaveRegimenNodeSales(RegimeCodes, SIIDocUploadState, CustLedgerEntry, Customer);
        GenerateNodeForFechaOperacionSales(XMLNode, CustLedgerEntry, RegimeCodes);
        GenerateClaveRegimenNode(XMLNode, RegimeCodes);

        TotalAmount := -TotalBase - TotalVATAmount;
        IF IncludeImporteTotalNode THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'ImporteTotal', FormatNumber(TotalAmount), 'sii', SiiTxt, TempXMLNode);
        FillBaseImponibleACosteNode(XMLNode, RegimeCodes, -TotalNonExemptBase);
        FillOperationDescription(
          XMLNode, GetOperationDescriptionFromDocument(TRUE, CustLedgerEntry."Document No."),
          CustLedgerEntry."Posting Date", CustLedgerEntry.Description);
        FillRefExternaNode(XMLNode, FORMAT(SIIDocUploadState."Entry No"));
        FillSucceededCompanyInfo(XMLNode, SIIDocUploadState);
        FillMacrodatoNode(XMLNode, TotalAmount);

        IF IncludeContraparteNodeByCrMemoType(SIIDocUploadState."Sales Cr. Memo Type") THEN BEGIN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Contraparte', '', 'sii', SiiTxt, XMLNode);
            FillThirdPartyId(
              XMLNode, Customer."Country/Region Code", Customer.Name, Customer."VAT Registration No.", Customer."No.", TRUE,
              SIIManagement.CustomerIsIntraCommunity(Customer."No."), Customer."Not in AEAT", SIIDocUploadState.IDType);
        END;

        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(CustLedgerEntry."Posting Date") THEN BEGIN
            MoveNonTaxableEntriesToTempVATEntryBuffer(TempVATEntryPerPercent, CustLedgerEntry, FALSE);
            NonTaxHandled := TRUE;
        END;

        IF DomesticCustomer THEN
            GetSourceForServiceOrGoods(
              TempVATEntryPerPercent, ExemptionCausePresent, ExemptionBaseAmounts,
              NonExemptTransactionType, ExemptExists, CustLedgerEntry, FALSE, DomesticCustomer);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoDesglose', '', 'sii', SiiTxt, TipoDesgloseXMLNode);
        FOR EUService := TRUE DOWNTO FALSE DO BEGIN
            IF NOT DomesticCustomer THEN
                GetSourceForServiceOrGoods(
                  TempVATEntryPerPercent, ExemptionCausePresent, ExemptionBaseAmounts,
                  NonExemptTransactionType, ExemptExists, CustLedgerEntry, EUService, DomesticCustomer);
            TempVATEntryPerPercent.SETCURRENTKEY("VAT %", "EC %");
            IF NOT DomesticCustomer THEN
                TempVATEntryPerPercent.SETRANGE("EU Service", EUService);
            EntriesFound := TempVATEntryPerPercent.FINDSET;
            IF NOT EntriesFound THEN
                TempVATEntryPerPercent.INIT;
            IF EntriesFound OR ExemptExists THEN BEGIN
                AddTipoDesgloseDetailHeader(
                  TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
                  EUXMLNode, VATXMLNode, EUService, DomesticCustomer, FALSE);
                IF ExemptExists THEN BEGIN
                    HandleExemptEntries(VATXMLNode, ExemptionCausePresent, ExemptionBaseAmounts);
                    ExemptExists := FALSE;
                END;
                IF EntriesFound THEN BEGIN
                    XMLDOMManagement.AddElementWithPrefix(VATXMLNode, 'NoExenta', '', 'sii', SiiTxt, VATXMLNode);
                    XMLDOMManagement.AddElementWithPrefix(VATXMLNode, 'TipoNoExenta', FORMAT(NonExemptTransactionType), 'sii', SiiTxt, TempXMLNode);
                    XMLDOMManagement.AddElementWithPrefix(VATXMLNode, 'DesgloseIVA', '', 'sii', SiiTxt, VATXMLNode);
                    REPEAT
                        FillDetalleIVANode(
                          VATXMLNode, TempVATEntryPerPercent, TRUE, -1, TRUE, NonExemptTransactionType, RegimeCodes, 'CuotaRepercutida');
                    UNTIL TempVATEntryPerPercent.NEXT = 0;
                END;
            END;
            TempVATEntryPerPercent.DELETEALL;
            IF NOT NonTaxHandled THEN BEGIN
                CLEAR(DomesticXMLNode);
                CLEAR(EUServiceXMLNode);
                CLEAR(NonEUServiceXMLNode);
                HandleNonTaxableVATEntries(
                  CustLedgerEntry,
                  TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
                  EUXMLNode, EUService, DomesticCustomer);
                CLEAR(DomesticXMLNode);
            END;
            CLEAR(EUXMLNode);
            CLEAR(VATXMLNode);
        END;
    END;

    LOCAL PROCEDURE HandleCorrectiveInvoicePurchases(VAR XMLNode: DotNet XmlNode; SIIDocUploadState: Record 10752; VendorLedgerEntry: Record 25; Vendor: Record 23): Boolean;
    VAR
        OldVendorLedgerEntry: Record 25;
        PurchCrMemoHdr: Record 124;
        VendorLedgerEntryRecRef: RecordRef;
        TotalBase: Decimal;
        TotalNonExemptBase: Decimal;
        TotalVATAmount: Decimal;
        CorrectedInvoiceNo: Code[20];
        CorrectionType: Option;
        VendNo: Code[20];
    BEGIN
        IF VendorLedgerEntry."Document Type" <> VendorLedgerEntry."Document Type"::Invoice THEN BEGIN
            GetCorrectionInfoFromDocument(
              VendorLedgerEntry."Document No.", CorrectedInvoiceNo, CorrectionType,
              VendorLedgerEntry."Correction Type", VendorLedgerEntry."Corrected Invoice No.");
            IF FindVendorLedgerEntryOfRefDocument(VendorLedgerEntry, OldVendorLedgerEntry, CorrectedInvoiceNo) THEN
                IF CorrectionType = PurchCrMemoHdr."Correction Type"::Removal THEN BEGIN
                    InitializeCorrectiveRemovalXmlBody(XMLNode,
                      VendorLedgerEntry."Posting Date", FALSE, SIIDocUploadState,
                      Vendor.Name, Vendor."VAT Registration No.", Vendor."Country/Region Code", Vendor."No.", FALSE);
                    EXIT(TRUE);
                END;
        END;
        VendNo := SIIManagement.GetVendFromLedgEntryByGLSetup(VendorLedgerEntry);
        InitializePurchXmlBody(XMLNode, VendNo, VendorLedgerEntry."Posting Date", SIIDocUploadState.IDType);

        // calculate totals for current doc
        DataTypeManagement.GetRecordRef(VendorLedgerEntry, VendorLedgerEntryRecRef);
        CalculateTotalVatAndBaseAmounts(VendorLedgerEntryRecRef, TotalBase, TotalNonExemptBase, TotalVATAmount);

        IF (CorrectionType = PurchCrMemoHdr."Correction Type"::Replacement) OR
           (VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice)
        THEN
            HandleReplacementPurchCorrectiveInvoice(
              XMLNode, Vendor, SIIDocUploadState, OldVendorLedgerEntry, VendorLedgerEntry, TotalBase, TotalNonExemptBase, TotalVATAmount)
        ELSE
            HandleNormalPurchCorrectiveInvoice(
              XMLNode, Vendor, SIIDocUploadState, OldVendorLedgerEntry, VendorLedgerEntry, TotalBase, TotalNonExemptBase, TotalVATAmount);
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE HandleReplacementPurchCorrectiveInvoice(VAR XMLNode: DotNet XmlNode; Vendor: Record 23; SIIDocUploadState: Record 10752; OldVendorLedgerEntry: Record 25; VendorLedgerEntry: Record 25; TotalBase: Decimal; TotalNonExemptBase: Decimal; TotalVATAmount: Decimal);
    VAR
        TempVATEntryPerPercent: Record 254 TEMPORARY;
        TempOldVATEntryPerPercent: Record 254 TEMPORARY;
        TempXMLNode: DotNet XmlNode;
        OldVendorLedgerEntryRecRef: RecordRef;
        OldTotalBase: Decimal;
        OldTotalNonExemptBase: Decimal;
        OldTotalVATAmount: Decimal;
        BaseAmountDiff: Decimal;
        VATAmountDiff: Decimal;
        ECPercentDiff: Decimal;
        ECAmountDiff: Decimal;
        CuotaDeducibleDecValue: Decimal;
        TotalAmount: Decimal;
        RegimeCodes: ARRAY[3] OF Code[2];
        ECVATEntryExists: Boolean;
        InvoiceType: Text;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', FORMAT(VendorLedgerEntry."External Document No."), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(VendorLedgerEntry."Document Date"), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode); // exit ID factura node

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FacturaRecibida', '', 'siiLR', SiiLRTxt, XMLNode);

        UpdatePurchCrMemoTypeFromCorrInvType(SIIDocUploadState);
        IF SIIDocUploadState."Purch. Cr. Memo Type".AsInteger() = 0 THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoFactura', 'R1', 'sii', SiiTxt, TempXMLNode)
        ELSE
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'TipoFactura', COPYSTR(FORMAT(SIIDocUploadState."Purch. Cr. Memo Type"), 1, 2), 'sii', SiiTxt, TempXMLNode);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoRectificativa', 'S', 'sii', SiiTxt, TempXMLNode);
        IF VendorLedgerEntry."Document Type" <> VendorLedgerEntry."Document Type"::Invoice THEN BEGIN
            GenerateFacturasRectificadasNode(XMLNode, OldVendorLedgerEntry."External Document No.", OldVendorLedgerEntry."Posting Date");
            // calculate totals for old doc
            DataTypeManagement.GetRecordRef(OldVendorLedgerEntry, OldVendorLedgerEntryRecRef);
            CalculateTotalVatAndBaseAmounts(OldVendorLedgerEntryRecRef, OldTotalBase, OldTotalNonExemptBase, OldTotalVATAmount);
        END;

        // write totals amounts in XML
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'ImporteRectificacion', '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'BaseRectificada', FormatNumber(ABS(OldTotalBase)), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'CuotaRectificada', FormatNumber(ABS(OldTotalVATAmount)), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        GetClaveRegimenNodePurchases(RegimeCodes, SIIDocUploadState, VendorLedgerEntry, Vendor);
        GenerateClaveRegimenNode(XMLNode, RegimeCodes);

        TotalAmount := OldTotalBase + OldTotalVATAmount + TotalBase + TotalVATAmount;
        IF IncludeImporteTotalNode THEN
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'ImporteTotal', FormatNumber(TotalAmount), 'sii', SiiTxt,
              TempXMLNode);
        FillBaseImponibleACosteNode(XMLNode, RegimeCodes, OldTotalNonExemptBase + TotalNonExemptBase);
        FillOperationDescription(
          XMLNode, GetOperationDescriptionFromDocument(FALSE, VendorLedgerEntry."Document No."),
          VendorLedgerEntry."Posting Date", VendorLedgerEntry.Description);
        FillRefExternaNode(XMLNode, FORMAT(SIIDocUploadState."Entry No"));
        FillSucceededCompanyInfo(XMLNode, SIIDocUploadState);
        FillMacrodatoNode(XMLNode, TotalAmount);

        // calculate Credit memo differences grouped by VAT %
        CalcNonExemptVATEntriesWithCuotaDeducible(TempVATEntryPerPercent, CuotaDeducibleDecValue, VendorLedgerEntry, 1);
        CuotaDeducibleDecValue := ABS(CuotaDeducibleDecValue);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DesgloseFactura', '', 'sii', SiiTxt, XMLNode);

        // calculate old and new VAT totals grouped by VAT %
        CalcNonExemptVATEntriesWithCuotaDeducible(TempOldVATEntryPerPercent, CuotaDeducibleDecValue, OldVendorLedgerEntry, -1);
        CuotaDeducibleDecValue := ABS(CuotaDeducibleDecValue);

        // loop over and fill diffs
        TempVATEntryPerPercent.RESET;
        TempVATEntryPerPercent.SETCURRENTKEY("VAT %", "EC %");
        IF TempVATEntryPerPercent.FINDSET THEN BEGIN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DesgloseIVA', '', 'sii', SiiTxt, XMLNode);
            REPEAT
                CalcTotalDiffAmounts(
                  BaseAmountDiff, VATAmountDiff, ECPercentDiff, ECAmountDiff, TempOldVATEntryPerPercent, TempVATEntryPerPercent);

                // fill XML
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DetalleIVA', '', 'sii', SiiTxt, XMLNode);
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'TipoImpositivo', FormatNumber(TempVATEntryPerPercent."VAT %"), 'sii', SiiTxt, TempXMLNode);
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'BaseImponible', FormatNumber(BaseAmountDiff), 'sii', SiiTxt, TempXMLNode);
                OnBeforeAddVATAmountPurchDiffElement(TempVATEntryPerPercent, VATAmountDiff);
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'CuotaSoportada', FormatNumber(VATAmountDiff), 'sii', SiiTxt, TempXMLNode);

                GenerateRecargoEquivalenciaNodes(XMLNode, ECPercentDiff, ECAmountDiff);
                XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
                ECVATEntryExists := ECVATEntryExists OR (ECPercentDiff <> 0);
            UNTIL TempVATEntryPerPercent.NEXT = 0;
            XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        END;
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Contraparte', '', 'sii', SiiTxt, XMLNode);
        FillThirdPartyId(
          XMLNode, Vendor."Country/Region Code", Vendor.Name, Vendor."VAT Registration No.", Vendor."No.", TRUE,
          SIIManagement.VendorIsIntraCommunity(Vendor."No."), FALSE, SIIDocUploadState.IDType);
        FillFechaRegContable(XMLNode, VendorLedgerEntry."Posting Date", GetRequestDateOfSIIHistoryByVendLedgEntry(VendorLedgerEntry));
        IF CuotaDeducibleDecValue = 0 THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'CuotaDeducible', FormatNumber(0), 'sii', SiiTxt, TempXMLNode)
        ELSE BEGIN
            IsPurchInvoice(InvoiceType, SIIDocUploadState);
            CuotaDeducibleDecValue :=
              CalcCuotaDeducible(
                VendorLedgerEntry."Posting Date", RegimeCodes, SIIDocUploadState.IDType,
                ECVATEntryExists, InvoiceType, TRUE, CuotaDeducibleDecValue);
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'CuotaDeducible', FormatNumber(CuotaDeducibleDecValue), 'sii', SiiTxt, TempXMLNode);
        END;
    END;

    LOCAL PROCEDURE HandleNormalPurchCorrectiveInvoice(VAR XMLNode: DotNet XmlNode; Vendor: Record 23; SIIDocUploadState: Record 10752; OldVendorLedgerEntry: Record 25; VendorLedgerEntry: Record 25; TotalBase: Decimal; TotalNonExemptBase: Decimal; TotalVATAmount: Decimal);
    VAR
        TempVATEntryNormalCalculated: Record 254 TEMPORARY;
        TempVATEntryReverseChargeCalculated: Record 254 TEMPORARY;
        VATEntry: Record 254;
        TempXMLNode: DotNet XmlNode;
        VendorLedgerEntryRecRef: RecordRef;
        VATEntriesFound: Boolean;
        ECVATEntryExists: Boolean;
        CuotaDeducibleDecValue: Decimal;
        TotalAmount: Decimal;
        RegimeCodes: ARRAY[3] OF Code[2];
        VendNo: Code[20];
        InvoiceType: Text;
    BEGIN
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', FORMAT(VendorLedgerEntry."External Document No."), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(VendorLedgerEntry."Document Date"), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode); // exit ID factura node

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FacturaRecibida', '', 'siiLR', SiiLRTxt, XMLNode);
        IF SIIDocUploadState."Purch. Cr. Memo Type".AsInteger() = 0 THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoFactura', 'R1', 'sii', SiiTxt, TempXMLNode)
        ELSE
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'TipoFactura', COPYSTR(FORMAT(SIIDocUploadState."Purch. Cr. Memo Type"), 1, 2), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoRectificativa', 'I', 'sii', SiiTxt, TempXMLNode);
        GenerateFacturasRectificadasNode(XMLNode, OldVendorLedgerEntry."External Document No.", OldVendorLedgerEntry."Posting Date");
        SIIDocUploadState.GetSIIDocUploadStateByVendLedgEntry(VendorLedgerEntry);
        GetClaveRegimenNodePurchases(RegimeCodes, SIIDocUploadState, VendorLedgerEntry, Vendor);
        GenerateClaveRegimenNode(XMLNode, RegimeCodes);
        VendNo := SIIManagement.GetVendFromLedgEntryByGLSetup(VendorLedgerEntry);

        IF NOT TempVATEntryNormalCalculated.ISEMPTY THEN
            TotalBase -= ABS(TempVATEntryNormalCalculated.Base);
        TotalAmount := TotalBase + TotalVATAmount;
        FillNoTaxableVATEntriesPurch(TempVATEntryNormalCalculated, VendorLedgerEntry);
        IF IncludeImporteTotalNode THEN
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'ImporteTotal', FormatNumber(TotalAmount), 'sii', SiiTxt, TempXMLNode);
        FillBaseImponibleACosteNode(XMLNode, RegimeCodes, TotalNonExemptBase);
        FillOperationDescription(
          XMLNode, GetOperationDescriptionFromDocument(FALSE, VendorLedgerEntry."Document No."),
          VendorLedgerEntry."Posting Date", VendorLedgerEntry.Description);
        FillRefExternaNode(XMLNode, FORMAT(SIIDocUploadState."Entry No"));
        FillSucceededCompanyInfo(XMLNode, SIIDocUploadState);
        FillMacrodatoNode(XMLNode, TotalAmount);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DesgloseFactura', '', 'sii', SiiTxt, XMLNode);

        DataTypeManagement.GetRecordRef(VendorLedgerEntry, VendorLedgerEntryRecRef);
        VATEntriesFound := SIIManagement.FindVatEntriesFromLedger(VendorLedgerEntryRecRef, VATEntry);
        IF VATEntriesFound OR NOT TempVATEntryNormalCalculated.ISEMPTY
        THEN BEGIN
            IF VATEntriesFound THEN
                REPEAT
                    CalculatePurchVATEntries(
                      TempVATEntryNormalCalculated, TempVATEntryReverseChargeCalculated, CuotaDeducibleDecValue,
                      VATEntry, VendNo, VendorLedgerEntry."Posting Date", InvoiceType);
                    ECVATEntryExists := ECVATEntryExists OR (VATEntry."EC %" <> 0);
                UNTIL VATEntry.NEXT = 0;
            AddPurchVATEntriesWithElement(
              XMLNode, TempVATEntryReverseChargeCalculated, 'InversionSujetoPasivo', RegimeCodes);
            AddPurchVATEntriesWithElement(
              XMLNode, TempVATEntryNormalCalculated, 'DesgloseIVA', RegimeCodes);
            XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
            IsPurchInvoice(InvoiceType, SIIDocUploadState);
            AddPurchTail(
              XMLNode, VendorLedgerEntry."Posting Date", GetRequestDateOfSIIHistoryByVendLedgEntry(VendorLedgerEntry),
              VendNo, CuotaDeducibleDecValue, SIIDocUploadState.IDType, RegimeCodes, ECVATEntryExists, InvoiceType,
              NOT TempVATEntryReverseChargeCalculated.ISEMPTY);
        END;
        XMLDOMManagement.FindNode(XMLNode, '../..', XMLNode);
    END;

    LOCAL PROCEDURE HandleReplacementSalesCorrectiveInvoice(VAR XMLNode: DotNet XmlNode; SIIDocUploadState: Record 10752; OldCustLedgerEntry: Record 21; CustLedgerEntry: Record 21; Customer: Record 18; TotalBase: Decimal; TotalNonExemptBase: Decimal; TotalVATAmount: Decimal);
    VAR
        TempOldVATEntryPerPercent: Record 254 TEMPORARY;
        OldVATEntry: Record 254;
        NewVATEntry: Record 254;
        TempVATEntryPerPercent: Record 254 TEMPORARY;
        SIIInitialDocUpload: Codeunit 51303;
        TempXMLNode: DotNet XmlNode;
        TipoDesgloseXMLNode: DotNet XmlNode;
        DesgloseFacturaXMLNode: DotNet XmlNode;
        DomesticXMLNode: DotNet XmlNode;
        DesgloseTipoOperacionXMLNode: DotNet XmlNode;
        EUXMLNode: DotNet XmlNode;
        OldCustLedgerEntryRecRef: RecordRef;
        CustLedgerEntryRecRef: RecordRef;
        RegimeCodes: ARRAY[3] OF Code[2];
        ExemptionCode: Option;
        OldTotalBase: Decimal;
        OldTotalNonExemptBase: Decimal;
        OldTotalVATAmount: Decimal;
        TotalAmount: Decimal;
        BaseAmountDiff: Decimal;
        VATAmountDiff: Decimal;
        ECPercentDiff: Decimal;
        ECAmountDiff: Decimal;
        DomesticCustomer: Boolean;
        NormalVATEntriesFound: Boolean;
        i: Integer;
        NonExemptTransactionType: Option "S1","S2","S3","Initial";
        ExemptExists: Boolean;
        ExemptionCausePresent: ARRAY[10] OF Boolean;
        ExemptionBaseAmounts: ARRAY[10] OF Decimal;
    BEGIN
        DomesticCustomer := SIIManagement.IsDomesticCustomer(Customer);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoRectificativa', 'S', 'sii', SiiTxt, TempXMLNode);
        IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Invoice THEN BEGIN
            GenerateFacturasRectificadasNode(XMLNode, OldCustLedgerEntry."Document No.", OldCustLedgerEntry."Posting Date");
            // calculate totals for old doc
            DataTypeManagement.GetRecordRef(OldCustLedgerEntry, OldCustLedgerEntryRecRef);
            CalculateTotalVatAndBaseAmounts(OldCustLedgerEntryRecRef, OldTotalBase, OldTotalNonExemptBase, OldTotalVATAmount);
        END;

        // write totals amounts in XML
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'ImporteRectificacion', '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'BaseRectificada', FormatNumber(ABS(OldTotalBase)), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'CuotaRectificada', FormatNumber(ABS(OldTotalVATAmount)), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);

        GetClaveRegimenNodeSales(RegimeCodes, SIIDocUploadState, CustLedgerEntry, Customer);
        GenerateClaveRegimenNode(XMLNode, RegimeCodes);

        TotalAmount := ABS(OldTotalBase + OldTotalVATAmount) - ABS(TotalBase + TotalVATAmount);
        IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice THEN
            TotalAmount := -TotalAmount;
        IF IncludeImporteTotalNode THEN
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'ImporteTotal', FormatNumber(TotalAmount), 'sii', SiiTxt,
              TempXMLNode);

        FillBaseImponibleACosteNode(XMLNode, RegimeCodes, ABS(OldTotalNonExemptBase) - ABS(TotalNonExemptBase));
        FillOperationDescription(
          XMLNode, GetOperationDescriptionFromDocument(TRUE, CustLedgerEntry."Document No."),
          CustLedgerEntry."Posting Date", CustLedgerEntry.Description);
        FillRefExternaNode(XMLNode, FORMAT(SIIDocUploadState."Entry No"));
        FillSucceededCompanyInfo(XMLNode, SIIDocUploadState);
        FillMacrodatoNode(XMLNode, TotalAmount);
        UpdateSalesCrMemoTypeFromCorrInvType(SIIDocUploadState);
        IF IncludeContraparteNodeByCrMemoType(SIIDocUploadState."Sales Cr. Memo Type") THEN BEGIN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Contraparte', '', 'sii', SiiTxt, XMLNode);
            FillThirdPartyId(
              XMLNode, Customer."Country/Region Code", Customer.Name, Customer."VAT Registration No.", Customer."No.", TRUE,
              SIIManagement.CustomerIsIntraCommunity(Customer."No."), Customer."Not in AEAT", SIIDocUploadState.IDType);
        END;

        DataTypeManagement.GetRecordRef(CustLedgerEntry, CustLedgerEntryRecRef);
        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(CustLedgerEntry."Posting Date") THEN
            NonExemptTransactionType := NonExemptTransactionType::S1
        ELSE
            NonExemptTransactionType := NonExemptTransactionType::Initial;
        IF SIIManagement.FindVatEntriesFromLedger(CustLedgerEntryRecRef, NewVATEntry) THEN
            REPEAT
                BuildVATEntrySource(
                  ExemptExists, ExemptionCausePresent, ExemptionCode, ExemptionBaseAmounts,
                  TempVATEntryPerPercent, NonExemptTransactionType, NewVATEntry, CustLedgerEntry."Posting Date", NOT DomesticCustomer);
            UNTIL NewVATEntry.NEXT = 0;

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoDesglose', '', 'sii', SiiTxt, XMLNode);
        TipoDesgloseXMLNode := XMLNode;
        TempVATEntryPerPercent.RESET;
        TempVATEntryPerPercent.SETCURRENTKEY("VAT %", "EC %");
        NormalVATEntriesFound := TempVATEntryPerPercent.FINDSET;
        IF NormalVATEntriesFound OR ExemptExists THEN
            AddTipoDesgloseDetailHeader(
              TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
              EUXMLNode, XMLNode, FALSE, DomesticCustomer, FALSE);

        IF ExemptExists THEN BEGIN
            FOR i := 1 TO ARRAYLEN(ExemptionBaseAmounts) DO
                ExemptionBaseAmounts[i] := -ExemptionBaseAmounts[i]; // reverse sign for replacement credit memo
            HandleExemptEntries(XMLNode, ExemptionCausePresent, ExemptionBaseAmounts);
        END;

        // calculate old VAT totals grouped by VAT %
        DataTypeManagement.GetRecordRef(OldCustLedgerEntry, OldCustLedgerEntryRecRef);
        IF SIIManagement.FindVatEntriesFromLedger(OldCustLedgerEntryRecRef, OldVATEntry) THEN
            REPEAT
                IF NOT GetExemptionCode(OldVATEntry, ExemptionCode) THEN
                    CalculateNonExemptVATEntries(TempOldVATEntryPerPercent, OldVATEntry, TRUE, CalcVATAmountExclEC(OldVATEntry));
            UNTIL OldVATEntry.NEXT = 0;

        // loop over and fill diffs
        IF NormalVATEntriesFound THEN BEGIN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'NoExenta', '', 'sii', SiiTxt, XMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoNoExenta', FORMAT(NonExemptTransactionType), 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DesgloseIVA', '', 'sii', SiiTxt, XMLNode);
            REPEAT
                CalcTotalDiffAmounts(
                  BaseAmountDiff, VATAmountDiff, ECPercentDiff, ECAmountDiff, TempOldVATEntryPerPercent, TempVATEntryPerPercent);

                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DetalleIVA', '', 'sii', SiiTxt, XMLNode);
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'TipoImpositivo',
                  FormatNumber(CalcTipoImpositivo(NonExemptTransactionType, RegimeCodes, BaseAmountDiff, TempVATEntryPerPercent."VAT %")),
                  'sii', SiiTxt, TempXMLNode);
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'BaseImponible', FormatNumber(ABS(BaseAmountDiff)), 'sii', SiiTxt, TempXMLNode);

                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'CuotaRepercutida', FormatNumber(ABS(VATAmountDiff) - ABS(ECAmountDiff)), 'sii', SiiTxt, TempXMLNode);

                GenerateRecargoEquivalenciaNodes(XMLNode, ECPercentDiff, ECAmountDiff);
                XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
            UNTIL TempVATEntryPerPercent.NEXT = 0;
        END;

        HandleReplacementNonTaxableVATEntries(
          CustLedgerEntry, OldCustLedgerEntry,
          TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
          EUXMLNode, FALSE, DomesticCustomer);
    END;

    LOCAL PROCEDURE CalculateTotalVatAndBaseAmounts(LedgerEntryRecRef: RecordRef; VAR TotalBaseAmount: Decimal; VAR TotalNonExemptVATBaseAmount: Decimal; VAR TotalVATAmount: Decimal);
    VAR
        VATEntry: Record 254;
    BEGIN
        TotalBaseAmount := 0;
        TotalVATAmount := 0;

        IF SIIManagement.FindVatEntriesFromLedger(LedgerEntryRecRef, VATEntry) THEN BEGIN
            REPEAT
                TotalBaseAmount += VATEntry.Base;
                IF VATEntry."VAT %" <> 0 THEN
                    TotalNonExemptVATBaseAmount += VATEntry.Base;
                IF VATEntry."VAT Calculation Type" <> VATEntry."VAT Calculation Type"::"Reverse Charge VAT" THEN
                    TotalVATAmount += VATEntry.Amount;
            UNTIL VATEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE GenerateFacturasRectificadasNode(VAR XMLNode: DotNet XmlNode; DocNo: Code[35]; PostingDate: Date);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        IF DocNo = '' THEN
            EXIT;

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FacturasRectificadas', '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'IDFacturaRectificada', '', 'sii', SiiTxt, XMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'NumSerieFacturaEmisor', DocNo, 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaExpedicionFacturaEmisor', FormatDate(PostingDate), 'sii', SiiTxt, TempXMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
    END;

    LOCAL PROCEDURE GetClaveRegimenNodeSales(VAR RegimeCodes: ARRAY[3] OF Code[2]; SIIDocUploadState: Record 10752; CustLedgerEntry: Record 21; Customer: Record 18);
    VAR
        SIIInitialDocUpload: Codeunit 51303;
        CustLedgerEntryRecRef: RecordRef;
    BEGIN
        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(CustLedgerEntry."Posting Date") THEN BEGIN
            RegimeCodes[1] := '16';
            EXIT;
        END;
        DataTypeManagement.GetRecordRef(CustLedgerEntry, CustLedgerEntryRecRef);
        IF SIIManagement.IsLedgerCashFlowBased(CustLedgerEntryRecRef) THEN BEGIN
            RegimeCodes[1] := '07';
            EXIT;
        END;
        // IF SIIDocUploadState."Sales Special Scheme Code" <> 0 THEN BEGIN
        //  SIIDocUploadState.GetSpecialSchemeCodes(RegimeCodes);
        //  EXIT;
        // END;
        IF SIIManagement.CountryIsLocal(Customer."Country/Region Code") THEN BEGIN
            RegimeCodes[1] := '01';
            EXIT;
        END;
        RegimeCodes[1] := '02';
    END;

    LOCAL PROCEDURE GetClaveRegimenNodePurchases(VAR RegimeCodes: ARRAY[3] OF Code[2]; SIIDocUploadState: Record 10752; VendorLedgerEntry: Record 25; Vendor: Record 23);
    VAR
        SIIInitialDocUpload: Codeunit 51303;
        VendorLedgerEntryRecRef: RecordRef;
    BEGIN
        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(VendorLedgerEntry."Posting Date") THEN BEGIN
            RegimeCodes[1] := '14';
            EXIT;
        END;
        DataTypeManagement.GetRecordRef(VendorLedgerEntry, VendorLedgerEntryRecRef);
        IF SIIManagement.IsLedgerCashFlowBased(VendorLedgerEntryRecRef) THEN BEGIN
            RegimeCodes[1] := '07';
            EXIT;
        END;
        // IF SIIDocUploadState."Purch. Special Scheme Code" <> 0 THEN BEGIN
        //  SIIDocUploadState.GetSpecialSchemeCodes(RegimeCodes);
        //  EXIT;
        // END;
        IF SIIManagement.VendorIsIntraCommunity(Vendor."No.") THEN BEGIN
            RegimeCodes[1] := '09';
            EXIT;
        END;
        RegimeCodes[1] := '01';
    END;

    LOCAL PROCEDURE GenerateClaveRegimenNode(VAR XMLNode: DotNet XmlNode; RegimeCodes: ARRAY[3] OF Code[2]);
    VAR
        TempXMLNode: DotNet XmlNode;
        i: Integer;
    BEGIN
        IF RegimeCodes[1] <> '' THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'ClaveRegimenEspecialOTrascendencia', RegimeCodes[1], 'sii', SiiTxt, TempXMLNode);
        FOR i := 2 TO ARRAYLEN(RegimeCodes) DO
            IF RegimeCodes[i] <> '' THEN
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode, 'ClaveRegimenEspecialOTrascendenciaAdicional' + FORMAT(i - 1), RegimeCodes[i], 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE GenerateNodeForFechaOperacionSales(VAR XMLNode: DotNet XmlNode; CustLedgerEntry: Record 21; RegimeCodes: ARRAY[3] OF Code[2]);
    VAR
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        SalesInvoiceLine: Record 113;
        SalesCrMemoLine: Record 115;
        SalesShipmentLine: Record 111;
        ReturnReceiptLine: Record 6661;
        LastShipDate: Date;
        PostingDate: Date;
    BEGIN
        CASE CustLedgerEntry."Document Type" OF
            CustLedgerEntry."Document Type"::Invoice:
                IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                    PostingDate := SalesInvoiceHeader."Posting Date";
                    SalesInvoiceLine.SETRANGE("Document No.", CustLedgerEntry."Document No.");
                    SalesInvoiceLine.SETFILTER(Quantity, '>%1', 0);
                    IF SalesInvoiceLine.FINDSET THEN
                        REPEAT
                            IF SalesInvoiceLine."Shipment No." = '' THEN BEGIN
                                IF (SalesInvoiceLine."Shipment Date" > LastShipDate) AND
                                   (DATE2DMY(SalesInvoiceLine."Shipment Date", 3) = DATE2DMY(SalesInvoiceHeader."Posting Date", 3))
                                THEN
                                    LastShipDate := SalesInvoiceLine."Shipment Date";
                            END ELSE
                                IF SalesShipmentLine.GET(SalesInvoiceLine."Shipment No.", SalesInvoiceLine."Shipment Line No.") THEN
                                    IF (SalesShipmentLine."Posting Date" > LastShipDate) AND
                                       (DATE2DMY(SalesShipmentLine."Posting Date", 3) = DATE2DMY(SalesInvoiceHeader."Posting Date", 3))
                                    THEN
                                        LastShipDate := SalesShipmentLine."Posting Date";
                        UNTIL SalesInvoiceLine.NEXT = 0;
                END;
            CustLedgerEntry."Document Type"::"Credit Memo":
                IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                    PostingDate := SalesCrMemoHeader."Posting Date";
                    SalesCrMemoLine.SETRANGE("Document No.", CustLedgerEntry."Document No.");
                    SalesCrMemoLine.SETFILTER(Quantity, '>%1', 0);
                    IF SalesCrMemoLine.FINDSET THEN
                        REPEAT
                            IF SalesCrMemoLine."Return Receipt No." = '' THEN BEGIN
                                IF (SalesCrMemoLine."Shipment Date" > LastShipDate) AND
                                   (DATE2DMY(SalesCrMemoLine."Shipment Date", 3) = DATE2DMY(SalesCrMemoHeader."Posting Date", 3))
                                THEN
                                    LastShipDate := SalesCrMemoLine."Shipment Date";
                            END ELSE
                                IF ReturnReceiptLine.GET(SalesCrMemoLine."Return Receipt No.", SalesCrMemoLine."Return Receipt Line No.") THEN
                                    IF (ReturnReceiptLine."Posting Date" > LastShipDate) AND
                                       (DATE2DMY(ReturnReceiptLine."Posting Date", 3) = DATE2DMY(SalesCrMemoHeader."Posting Date", 3))
                                    THEN
                                        LastShipDate := ReturnReceiptLine."Posting Date";
                        UNTIL SalesCrMemoLine.NEXT = 0;
                END;
        END;
        IF PostingDate <> 0D THEN
            FillFechaOperacion(XMLNode, LastShipDate, PostingDate, TRUE, RegimeCodes);
    END;

    LOCAL PROCEDURE GenerateNodeForFechaOperacionPurch(VAR XMLNode: DotNet XmlNode; VendorLedgerEntry: Record 25);
    VAR
        PurchInvHeader: Record 122;
        PurchInvLine: Record 123;
        PurchRcptLine: Record 121;
        LastRcptDate: Date;
        DummyRegimeCodes: ARRAY[3] OF Code[2];
        "----------------------------- QB": Integer;
        PurchCrMemoHdr: Record 124;
    BEGIN
        IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice THEN
            IF PurchInvHeader.GET(VendorLedgerEntry."Document No.") THEN BEGIN
                PurchInvLine.SETRANGE("Document No.", VendorLedgerEntry."Document No.");
                IF PurchInvLine.FINDSET THEN
                    REPEAT
                        IF PurchInvLine."Receipt No." <> '' THEN
                            IF PurchRcptLine.GET(PurchInvLine."Receipt No.", PurchInvLine."Receipt Line No.") THEN
                                IF PurchRcptLine."Posting Date" > LastRcptDate THEN
                                    LastRcptDate := PurchRcptLine."Posting Date"
                    UNTIL PurchInvLine.NEXT = 0;
                //Q5555 PER 04.02.19
                //FillFechaOperacion(XMLNode,LastRcptDate,PurchInvHeader."Posting Date",FALSE,'');
                FillFechaOperacionNode(XMLNode, PurchInvHeader."Operation date SII", PurchInvHeader."Posting Date");
                //Q5555 Fin
            END;

        //Q5555
        IF VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" THEN
            IF PurchCrMemoHdr.GET(VendorLedgerEntry."Document No.") THEN BEGIN
                FillFechaOperacionNode(XMLNode, PurchCrMemoHdr."Operation date SII", PurchCrMemoHdr."Posting Date");
            END;
        //Q5555 fin
    END;

    LOCAL PROCEDURE GenerateRecargoEquivalenciaNodes(VAR XMLNode: DotNet XmlNode; ECPercent: Decimal; ECAmount: Decimal);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        IF ECPercent <> 0 THEN BEGIN
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'TipoRecargoEquivalencia', FormatNumber(ECPercent), 'sii', SiiTxt, TempXMLNode);
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'CuotaRecargoEquivalencia', FormatNumber(ECAmount), 'sii', SiiTxt,
              TempXMLNode);
        END;
    END;

    LOCAL PROCEDURE GetOperationDescriptionFromDocument(IsSales: Boolean; DocumentNo: Code[35]): Text;
    VAR
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
        ServiceInvoiceHeader: Record 5992;
        ServiceCrMemoHeader: Record 5994;
    BEGIN
        IF IsSales THEN BEGIN
            IF SalesInvoiceHeader.GET(DocumentNo) THEN
                EXIT(SalesInvoiceHeader."Operation Description" + SalesInvoiceHeader."Operation Description 2");
            IF SalesCrMemoHeader.GET(DocumentNo) THEN
                EXIT(SalesCrMemoHeader."Operation Description" + SalesCrMemoHeader."Operation Description 2");
            IF ServiceInvoiceHeader.GET(DocumentNo) THEN
                EXIT(ServiceInvoiceHeader."Operation Description" + ServiceInvoiceHeader."Operation Description 2");
            IF ServiceCrMemoHeader.GET(DocumentNo) THEN
                EXIT(ServiceCrMemoHeader."Operation Description" + ServiceCrMemoHeader."Operation Description 2");
        END ELSE BEGIN
            IF PurchInvHeader.GET(DocumentNo) THEN
                EXIT(PurchInvHeader."Operation Description" + PurchInvHeader."Operation Description 2");
            IF PurchCrMemoHdr.GET(DocumentNo) THEN
                EXIT(PurchCrMemoHdr."Operation Description" + PurchCrMemoHdr."Operation Description 2");
        END;
    END;

    LOCAL PROCEDURE GetCorrectionInfoFromDocument(DocumentNo: Code[20]; VAR CorrectedInvoiceNo: Code[20]; VAR CorrectionType: Option; EntryCorrType: Option; EntryCorrInvNo: Code[20]);
    VAR
        PurchCrMemoHdr: Record 124;
        SalesCrMemoHeader: Record 114;
        ServiceCrMemoHeader: Record 5994;
    BEGIN
        CASE TRUE OF
            PurchCrMemoHdr.GET(DocumentNo):
                BEGIN
                    CorrectedInvoiceNo := PurchCrMemoHdr."Corrected Invoice No.";
                    CorrectionType := PurchCrMemoHdr."Correction Type";
                END;
            SalesCrMemoHeader.GET(DocumentNo):
                BEGIN
                    CorrectedInvoiceNo := SalesCrMemoHeader."Corrected Invoice No.";
                    CorrectionType := SalesCrMemoHeader."Correction Type";
                END;
            ServiceCrMemoHeader.GET(DocumentNo):
                BEGIN
                    CorrectedInvoiceNo := ServiceCrMemoHeader."Corrected Invoice No.";
                    CorrectionType := ServiceCrMemoHeader."Correction Type";
                END
            ELSE BEGIN
                CorrectedInvoiceNo := EntryCorrInvNo;
                CorrectionType := EntryCorrType;
            END;
        END;
    END;

    LOCAL PROCEDURE GetRequestDateOfSIIHistoryByVendLedgEntry(VendorLedgerEntry: Record 25): Date;
    VAR
        SIIDocUploadState: Record 10752;
        SIIHistory: Record 10750;
    BEGIN
        SIIDocUploadState.GetSIIDocUploadStateByVendLedgEntry(VendorLedgerEntry);
        SIIHistory.SETRANGE("Document State Id", SIIDocUploadState.Id);
        SIIHistory.FINDLAST;
        EXIT(DT2DATE(SIIHistory."Request Date"));
    END;

    LOCAL PROCEDURE GetSIISetup();
    BEGIN
        IF SIISetupInitialized THEN
            EXIT;

        SIISetup.GET;
        SIISetup.TESTFIELD("Invoice Amount Threshold");
        SIISetup.TESTFIELD("SuministroInformacion Schema");
        SIISetup.TESTFIELD("SuministroLR Schema");
        SIISetupInitialized := TRUE;
    END;

    // LOCAL PROCEDURE GetIDTypeToExport(IDType: Integer): Text[30];
    LOCAL PROCEDURE GetIDTypeToExport(IDType: Enum "SII ID Type"): Text[30];
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        CASE IDType OF
            SIIDocUploadState.IDType::"02-VAT Registration No.":
                EXIT('02');
            SIIDocUploadState.IDType::"03-Passport":
                EXIT('03');
            SIIDocUploadState.IDType::"04-ID Document":
                EXIT('04');
            SIIDocUploadState.IDType::"05-Certificate Of Residence":
                EXIT('05');
            SIIDocUploadState.IDType::"06-Other Probative Document":
                EXIT('06');
            SIIDocUploadState.IDType::"07-Not On The Census":
                EXIT('07');
        END;
    END;

    LOCAL PROCEDURE GetVATNodeName(NoTaxableVAT: Boolean): Text;
    BEGIN
        IF NoTaxableVAT THEN
            EXIT('NoSujeta');
        EXIT('Sujeta');
    END;

    PROCEDURE SetIsRetryAccepted(NewRetryAccepted: Boolean);
    BEGIN
        RetryAccepted := NewRetryAccepted;
    END;

    PROCEDURE SetSIIVersionNo(NewSIIVersion: Option);
    BEGIN
        SIIVersion := NewSIIVersion;
    END;

    LOCAL PROCEDURE IsREAGYPSpecialSchemeCode(VATEntry: Record 254; RegimeCodes: ARRAY[3] OF Code[2]): Boolean;
    BEGIN
        EXIT((VATEntry.Type = VATEntry.Type::Purchase) AND RegimeCodesContainsValue(RegimeCodes, SecondSpecialRegimeCode));
    END;

    LOCAL PROCEDURE ExportTaxInformation(VATEntry: Record 254; RegimeCodes: ARRAY[3] OF Code[2]): Boolean;
    BEGIN
        IF VATEntry.Type <> VATEntry.Type::Purchase THEN
            EXIT(TRUE);

        EXIT((VATEntry."No Taxable Type" = 0) OR (NOT RegimeCodesContainsValue(RegimeCodes, EighthSpecialRegimeCode)));
    END;

    LOCAL PROCEDURE ExportTipoImpositivo(VATEntry: Record 254; RegimeCodes: ARRAY[3] OF Code[2]): Boolean;
    BEGIN
        IF IsREAGYPSpecialSchemeCode(VATEntry, RegimeCodes) THEN
            EXIT(FALSE);

        EXIT(ExportTaxInformation(VATEntry, RegimeCodes));
    END;

    LOCAL PROCEDURE SecondSpecialRegimeCode(): Code[2];
    BEGIN
        EXIT('02');
    END;

    LOCAL PROCEDURE EighthSpecialRegimeCode(): Code[2];
    BEGIN
        EXIT('08');
    END;

    LOCAL PROCEDURE BuildVATEntrySource(VAR ExemptExists: Boolean; VAR ExemptionCausePresent: ARRAY[10] OF Boolean; VAR ExemptionCode: Option; VAR ExemptionBaseAmounts: ARRAY[10] OF Decimal; VAR VATEntryPerPercent: Record 254; VAR NonExemptTransactionType: Option "S1","S2","S3","Initial"; VAR VATEntry: Record 254; PostingDate: Date; SplitByEUService: Boolean);
    VAR
        VATPostingSetup: Record 325;
        SIIInitialDocUpload: Codeunit 51303;
    BEGIN
        VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
        IF VATPostingSetup."No Taxable Type" <> 0 THEN
            EXIT;

        IF GetExemptionCode(VATEntry, ExemptionCode) THEN BEGIN
            CalculateExemptVATEntries(ExemptionCausePresent, ExemptionBaseAmounts, VATEntry, ExemptionCode);
            IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(PostingDate) THEN
                MoveExemptEntriesToTempVATEntryBuffer(VATEntryPerPercent, ExemptionCausePresent, ExemptionBaseAmounts)
            ELSE
                ExemptExists := TRUE;
        END ELSE BEGIN
            CalculateNonExemptVATEntries(VATEntryPerPercent, VATEntry, SplitByEUService, VATEntry.Amount + VATEntry."Unrealized Amount");
            BuildNonExemptTransactionType(VATEntry, NonExemptTransactionType);
        END
    END;

    LOCAL PROCEDURE HandleExemptEntries(VAR XMLNode: DotNet XmlNode; ExemptionCausePresent: ARRAY[10] OF Boolean; ExemptionBaseAmounts: ARRAY[10] OF Decimal);
    VAR
        TempXmlNode: DotNet XmlNode;
        StopExemptLoop: Boolean;
        BaseAmount: Decimal;
        ExemptionEntryIndex: Integer;
    BEGIN
        FOR ExemptionEntryIndex := 1 TO ARRAYLEN(ExemptionCausePresent) DO
            IF ExemptionCausePresent[ExemptionEntryIndex] AND (NOT StopExemptLoop) THEN BEGIN
                StopExemptLoop := FALSE;

                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Exenta', '', 'sii', SiiTxt, XMLNode);
                IF IncludeChangesVersion11 THEN
                    XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DetalleExenta', '', 'sii', SiiTxt, XMLNode);

                // The first exemption does not have specific cause, it's because of zero VAT %
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode,
                  'CausaExencion',
                  BuildExemptionCodeString(ExemptionEntryIndex),
                  'sii',
                  SiiTxt,
                  TempXmlNode);
                BaseAmount := -ExemptionBaseAmounts[ExemptionEntryIndex];
                XMLDOMManagement.AddElementWithPrefix(
                  XMLNode,
                  'BaseImponible',
                  FormatNumber(BaseAmount),
                  'sii',
                  SiiTxt, TempXmlNode);
                XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
                XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
            END;
    END;

    LOCAL PROCEDURE CalcTotalDiffAmounts(VAR TotalBaseAmountDiff: Decimal; VAR TotalVATAmountDiff: Decimal; VAR TotalECPercentDiff: Decimal; VAR TotalECAmountDiff: Decimal; VAR TempOldVATEntryPerPercent: Record 254 TEMPORARY; VAR TempVATEntryPerPercent: Record 254 TEMPORARY);
    VAR
        BaseAmountDiff: Decimal;
        VATAmountDiff: Decimal;
        ECPercentDiff: Decimal;
        ECAmountDiff: Decimal;
    BEGIN
        TotalBaseAmountDiff := 0;
        TotalVATAmountDiff := 0;
        TotalECPercentDiff := 0;
        TotalECAmountDiff := 0;
        TempVATEntryPerPercent.SETRANGE("VAT %", TempVATEntryPerPercent."VAT %");
        TempVATEntryPerPercent.SETRANGE("EC %", TempVATEntryPerPercent."EC %");
        REPEAT
            CalcDiffAmounts(BaseAmountDiff, VATAmountDiff, ECPercentDiff, ECAmountDiff, TempOldVATEntryPerPercent, TempVATEntryPerPercent);
            TotalBaseAmountDiff += BaseAmountDiff;
            TotalVATAmountDiff += VATAmountDiff;
            TotalECPercentDiff += ECPercentDiff;
            TotalECAmountDiff += ECAmountDiff;
        UNTIL TempVATEntryPerPercent.NEXT = 0;
        TempVATEntryPerPercent.SETRANGE("VAT %");
        TempVATEntryPerPercent.SETRANGE("EC %");
    END;

    LOCAL PROCEDURE CalcDiffAmounts(VAR BaseAmountDiff: Decimal; VAR VATAmountDiff: Decimal; VAR ECPercentDiff: Decimal; VAR ECAmountDiff: Decimal; VAR TempOldVATEntryPerPercent: Record 254 TEMPORARY; TempVATEntryPerPercent: Record 254 TEMPORARY);
    BEGIN
        TempOldVATEntryPerPercent.SETRANGE("VAT %", TempVATEntryPerPercent."VAT %");
        TempOldVATEntryPerPercent.SETRANGE("EC %", TempVATEntryPerPercent."EC %");
        IF TempOldVATEntryPerPercent.FINDFIRST THEN BEGIN
            BaseAmountDiff := TempVATEntryPerPercent.Base + TempOldVATEntryPerPercent.Base;
            VATAmountDiff := TempVATEntryPerPercent.Amount + TempOldVATEntryPerPercent.Amount;
            ECPercentDiff := TempVATEntryPerPercent."EC %" - TempOldVATEntryPerPercent."EC %";
            ECAmountDiff := CalculateECAmount(TempVATEntryPerPercent.Base, TempVATEntryPerPercent."EC %") +
              CalculateECAmount(TempOldVATEntryPerPercent.Base, TempOldVATEntryPerPercent."EC %");
        END ELSE BEGIN
            BaseAmountDiff := TempVATEntryPerPercent.Base;
            VATAmountDiff := TempVATEntryPerPercent.Amount;
            ECPercentDiff := TempVATEntryPerPercent."EC %";
            ECAmountDiff := CalculateECAmount(TempVATEntryPerPercent.Base, TempVATEntryPerPercent."EC %");
        END;
    END;

    LOCAL PROCEDURE CalcVATAmountExclEC(VATEntry: Record 254): Decimal;
    VAR
        VATEntryAmount: Decimal;
        VATEntryBase: Decimal;
    BEGIN
        IF VATEntry.Amount = 0 THEN
            VATEntryAmount := VATEntry."Unrealized Amount"
        ELSE
            VATEntryAmount := VATEntry.Amount;
        IF VATEntry."EC %" = 0 THEN
            EXIT(VATEntryAmount);
        IF VATEntry.Base = 0 THEN
            VATEntryBase := VATEntry."Unrealized Base"
        ELSE
            VATEntryBase := VATEntry.Base;
        EXIT(VATEntryAmount - CalculateECAmount(VATEntryBase, VATEntry."EC %"));
    END;

    LOCAL PROCEDURE CalcTipoImpositivo(NonExemptTransactionType: Option "S1","S2","S3","Initial"; RegimeCodes: ARRAY[3] OF Code[2]; VATAmount: Decimal; Amount: Decimal): Decimal;
    VAR
        i: Integer;
        SpecialRegimeCodes: Boolean;
    BEGIN
        FOR i := 1 TO ARRAYLEN(RegimeCodes) DO
            SpecialRegimeCodes := SpecialRegimeCodes OR (RegimeCodes[i] IN ['03', '05', '09']);
        IF (FORMAT(NonExemptTransactionType) = 'S1') AND SpecialRegimeCodes AND (VATAmount = 0) THEN
            EXIT(0);
        EXIT(Amount);
    END;

    // LOCAL PROCEDURE CalcCuotaDeducible(PostingDate: Date; RegimeCodes: ARRAY[3] OF Code[2]; IDType: Integer; ECVATEntryExists: Boolean; InvoiceType: Text; HasReverseChargeEntry: Boolean; Amount: Decimal): Decimal;
    LOCAL PROCEDURE CalcCuotaDeducible(PostingDate: Date; RegimeCodes: ARRAY[3] OF Code[2]; IDType: Enum "SII ID Type"; ECVATEntryExists: Boolean; InvoiceType: Text; HasReverseChargeEntry: Boolean; Amount: Decimal): Decimal;
    VAR
        SIIDocUploadState: Record 10752;
        SIIInitialDocUpload: Codeunit 51303;
    BEGIN
        IF IncludeChangesVersion11bis THEN
            IF ECVATEntryExists OR
               ((IDType IN [SIIDocUploadState.IDType::"03-Passport", SIIDocUploadState.IDType::"04-ID Document",
                            SIIDocUploadState.IDType::"05-Certificate Of Residence",
                            SIIDocUploadState.IDType::"06-Other Probative Document"]) OR
                (InvoiceType = GetF2InvoiceType)) AND
               (NOT HasReverseChargeEntry)
            THEN
                EXIT(0);
        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(PostingDate) OR RegimeCodesContainsValue(RegimeCodes, '13') THEN
            EXIT(0);
        EXIT(Amount);
    END;

    LOCAL PROCEDURE UseReverseChargeNotIntracommunity(VATCalcType: Enum "Tax Calculation Type"; VendNo: Code[20]; PostingDate: Date; InvoiceType: Text): Boolean;
    VAR
        VATEntry: Record 254;
        SIIInitialDocUpload: Codeunit 51303;
    BEGIN
        EXIT(
          (VATCalcType = VATEntry."VAT Calculation Type"::"Reverse Charge VAT") AND
          (NOT SIIManagement.VendorIsIntraCommunity(VendNo)) AND
          (InvoiceType <> GetF5InvoiceType) AND
          (NOT SIIInitialDocUpload.DateWithinInitialUploadPeriod(PostingDate)));
    END;

    LOCAL PROCEDURE HandleNonTaxableVATEntries(CustLedgerEntry: Record 21; VAR TipoDesgloseXMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUXMLNode: DotNet XmlNode; IsService: Boolean; DomesticCustomer: Boolean);
    VAR
        CustNo: Code[20];
        Amount: ARRAY[2] OF Decimal;
        HasEntries: ARRAY[2] OF Boolean;
        IsLocalRule: Boolean;
        i: Integer;
    BEGIN
        CustNo := SIIManagement.GetCustFromLedgEntryByGLSetup(CustLedgerEntry);
        FOR IsLocalRule := FALSE TO TRUE DO BEGIN
            i += 1;
            HasEntries[i] :=
              SIIManagement.GetNoTaxableSalesAmount(
                Amount[i], CustNo, CustLedgerEntry."Document Type", CustLedgerEntry."Document No.",//enum to option
                CustLedgerEntry."Posting Date", IsService, TRUE, IsLocalRule);
        END;
        ExportNonTaxableVATEntries(
          TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode,
          DesgloseTipoOperacionXMLNode, EUXMLNode, IsService, DomesticCustomer, HasEntries, Amount);
    END;

    LOCAL PROCEDURE HandleReplacementNonTaxableVATEntries(CustLedgerEntry: Record 21; OldCustLedgerEntry: Record 21; VAR TipoDesgloseXMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUXMLNode: DotNet XmlNode; IsService: Boolean; DomesticCustomer: Boolean);
    VAR
        CustNo: Code[20];
        OldAmount: Decimal;
        Amount: Decimal;
        ReplacementAmount: ARRAY[2] OF Decimal;
        HasEntries: ARRAY[2] OF Boolean;
        IsLocalRule: Boolean;
        i: Integer;
    BEGIN
        CustNo := SIIManagement.GetCustFromLedgEntryByGLSetup(CustLedgerEntry);
        FOR IsLocalRule := FALSE TO TRUE DO BEGIN
            i += 1;
            HasEntries[i] :=
              SIIManagement.GetNoTaxableSalesAmount(
                OldAmount, CustNo, CustLedgerEntry."Document Type", CustLedgerEntry."Document No.",//enum to option
                CustLedgerEntry."Posting Date", IsService, TRUE, IsLocalRule) OR
              SIIManagement.GetNoTaxableSalesAmount(
                Amount, CustNo, OldCustLedgerEntry."Document Type", OldCustLedgerEntry."Document No.",//enum to option
                OldCustLedgerEntry."Posting Date", IsService, TRUE, IsLocalRule);
            ReplacementAmount[i] := ABS(OldAmount + Amount);
        END;
        ExportNonTaxableVATEntries(
          TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode, EUXMLNode, IsService, DomesticCustomer,
          HasEntries, ReplacementAmount);
    END;

    LOCAL PROCEDURE ExportNonTaxableVATEntries(VAR TipoDesgloseXMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUXMLNode: DotNet XmlNode; IsService: Boolean; DomesticCustomer: Boolean; HasEntries: ARRAY[2] OF Boolean; Amount: ARRAY[2] OF Decimal);
    BEGIN
        IF HasEntries[1] THEN
            InsertNoTaxableNode(
              TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
              EUXMLNode, IsService, DomesticCustomer,
              'ImportePorArticulos7_14_Otros', Amount[1]);

        IF HasEntries[2] THEN
            InsertNoTaxableNode(
              TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
              EUXMLNode, IsService, DomesticCustomer,
              'ImporteTAIReglasLocalizacion', Amount[2]);
    END;

    LOCAL PROCEDURE MoveExemptEntriesToTempVATEntryBuffer(VAR TempVATEntryPerPercent: Record 254 TEMPORARY; ExemptionCausePresent: ARRAY[10] OF Boolean; ExemptionBaseAmounts: ARRAY[10] OF Decimal);
    VAR
        VATEntry: Record 254;
        StopExemptLoop: Boolean;
        ExemptionEntryIndex: Integer;
        EntryNo: Integer;
    BEGIN
        VATEntry.FINDLAST;
        EntryNo := VATEntry."Entry No." + +2000000; // Choose Entry No. to avoid conflict with real VAT Entries
        FOR ExemptionEntryIndex := 1 TO ARRAYLEN(ExemptionCausePresent) DO
            IF NOT StopExemptLoop AND ExemptionCausePresent[ExemptionEntryIndex] THEN BEGIN
                StopExemptLoop := FALSE;
                EntryNo += 1;
                TempVATEntryPerPercent."Entry No." := EntryNo;
                TempVATEntryPerPercent.Base := ExemptionBaseAmounts[ExemptionEntryIndex];
                TempVATEntryPerPercent.INSERT;
            END;
        CLEAR(ExemptionCausePresent);
        CLEAR(ExemptionBaseAmounts);
    END;

    LOCAL PROCEDURE MoveNonTaxableEntriesToTempVATEntryBuffer(VAR TempVATEntryCalculatedNonExempt: Record 254 TEMPORARY; CustLedgerEntry: Record 21; IsService: Boolean);
    VAR
        NoTaxableEntry: Record 10740;
        VATEntry: Record 254;
        EntryNo: Integer;
    BEGIN
        VATEntry.FINDLAST;
        EntryNo := VATEntry."Entry No." + 3000000;
        IF SIIManagement.NoTaxableEntriesExistSales(
             NoTaxableEntry,
             SIIManagement.GetCustFromLedgEntryByGLSetup(CustLedgerEntry), CustLedgerEntry."Document Type", CustLedgerEntry."Document No.",
             CustLedgerEntry."Posting Date", IsService, FALSE, FALSE)
        THEN BEGIN
            IF NoTaxableEntry.FINDSET THEN
                REPEAT
                    EntryNo += 1;
                    TempVATEntryCalculatedNonExempt.TRANSFERFIELDS(NoTaxableEntry);
                    TempVATEntryCalculatedNonExempt."Entry No." := EntryNo;
                    TempVATEntryCalculatedNonExempt.Amount := 0;
                    TempVATEntryCalculatedNonExempt.INSERT;
                UNTIL NoTaxableEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE IsPurchInvoice(VAR InvoiceType: Text; SIIDocUploadState: Record 10752) IsInvoice: Boolean;
    BEGIN
        IsInvoice := FALSE;
        CASE SIIDocUploadState."Document Type" OF
            SIIDocUploadState."Document Type"::Invoice:
                BEGIN
                    IsInvoice :=
                      IsPurchInvType(SIIDocUploadState."Purch. Invoice Type");
                    IF SIIDocUploadState."Purch. Invoice Type" =
                       SIIDocUploadState."Purch. Invoice Type"::"Customs - Complementary Liquidation"
                    THEN
                        InvoiceType := LCLbl
                    ELSE
                        InvoiceType := COPYSTR(FORMAT(SIIDocUploadState."Purch. Invoice Type"), 1, 2);
                END;
            SIIDocUploadState."Document Type"::"Credit Memo":
                BEGIN
                    IsInvoice :=
                      SIIDocUploadState."Purch. Cr. Memo Type" IN [SIIDocUploadState."Purch. Cr. Memo Type"::"F1 Invoice",
                                                                   SIIDocUploadState."Purch. Cr. Memo Type"::"F2 Simplified Invoice"];
                    IF IsInvoice THEN
                        InvoiceType := COPYSTR(FORMAT(SIIDocUploadState."Purch. Cr. Memo Type"), 1, 2);
                END;
        END;
        EXIT(IsInvoice);
    END;

    LOCAL PROCEDURE IsPurchInvType(InvType: Enum "SII Purch. Invoice Type"): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        EXIT(
          InvType IN [SIIDocUploadState."Purch. Invoice Type"::"F1 Invoice",
                      SIIDocUploadState."Purch. Invoice Type"::"F2 Simplified Invoice",
                      SIIDocUploadState."Purch. Invoice Type"::"F3 Invoice issued to replace simplified invoices",
                      SIIDocUploadState."Purch. Invoice Type"::"F4 Invoice summary entry",
                      SIIDocUploadState."Purch. Invoice Type"::"F5 Imports (DUA)",
                      SIIDocUploadState."Purch. Invoice Type"::"F6 Accounting support material",
                      SIIDocUploadState."Purch. Invoice Type"::"Customs - Complementary Liquidation"]);
    END;

    LOCAL PROCEDURE IsSalesInvoice(VAR InvoiceType: Text; SIIDocUploadState: Record 10752) IsInvoice: Boolean;
    BEGIN
        IsInvoice := FALSE;
        CASE SIIDocUploadState."Document Type" OF
            SIIDocUploadState."Document Type"::Invoice:
                BEGIN
                    IsInvoice := IsSalesInvType(SIIDocUploadState."Sales Invoice Type");
                    InvoiceType := COPYSTR(FORMAT(SIIDocUploadState."Sales Invoice Type"), 1, 2);
                END;
            SIIDocUploadState."Document Type"::"Credit Memo":
                BEGIN
                    IsInvoice :=
                      SIIDocUploadState."Sales Cr. Memo Type" IN [SIIDocUploadState."Sales Cr. Memo Type"::"F1 Invoice",
                                                                  SIIDocUploadState."Sales Cr. Memo Type"::"F2 Simplified Invoice"];
                    IF IsInvoice THEN
                        InvoiceType := COPYSTR(FORMAT(SIIDocUploadState."Sales Cr. Memo Type"), 1, 2);
                END;
        END;
        EXIT(IsInvoice);
    END;

    // LOCAL PROCEDURE IsSalesInvType(InvType: Integer): Boolean;
    LOCAL PROCEDURE IsSalesInvType(InvType: Enum "SII Sales Invoice Type"): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        EXIT(
          InvType IN [SIIDocUploadState."Sales Invoice Type"::"F1 Invoice",
                      SIIDocUploadState."Sales Invoice Type"::"F2 Simplified Invoice",
                      SIIDocUploadState."Sales Invoice Type"::"F3 Invoice issued to replace simplified invoices",
                      SIIDocUploadState."Sales Invoice Type"::"F4 Invoice summary entry"]);
    END;

    LOCAL PROCEDURE InsertNoTaxableNode(VAR TipoDesgloseXMLNode: DotNet XmlNode; VAR DesgloseFacturaXMLNode: DotNet XmlNode; VAR DomesticXMLNode: DotNet XmlNode; VAR DesgloseTipoOperacionXMLNode: DotNet XmlNode; VAR EUXMLNode: DotNet XmlNode; EUService: Boolean; DomesticCustomer: Boolean; NodeName: Text; NonTaxableAmount: Decimal);
    VAR
        VATXMLNode: DotNet XmlNode;
    BEGIN
        AddTipoDesgloseDetailHeader(
          TipoDesgloseXMLNode, DesgloseFacturaXMLNode, DomesticXMLNode, DesgloseTipoOperacionXMLNode,
          EUXMLNode, VATXMLNode, EUService, DomesticCustomer, TRUE);
        GenerateNodeForNonTaxableVAT(NonTaxableAmount, VATXMLNode, NodeName);
    END;

    LOCAL PROCEDURE InsertMedioNode(VAR XMLNode: DotNet XmlNode; PaymentMethodCode: Code[10]);
    VAR
        PaymentMethod: Record 289;
        TempXMLNode: DotNet XmlNode;
        MedioValue: Text;
    BEGIN
        MedioValue := '04';
        IF PaymentMethodCode <> '' THEN BEGIN
            PaymentMethod.GET(PaymentMethodCode);
            IF PaymentMethod."SII Payment Method Code" <> 0 THEN
                MedioValue := FORMAT(PaymentMethod."SII Payment Method Code");
        END;
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Medio', MedioValue, 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE FillDetalleIVANode(VAR XMLNode: DotNet XmlNode; VAR TempVATEntry: Record 254 TEMPORARY; UseSign: Boolean; Sign: Integer; FillEUServiceNodes: Boolean; NonExemptTransactionType: Option "S1","S2","S3","Initial"; RegimeCodes: ARRAY[3] OF Code[2]; AmountNodeName: Text);
    VAR
        TempXmlNode: DotNet XmlNode;
        Base: Decimal;
        Amount: Decimal;
        ECPercent: Decimal;
        ECAmount: Decimal;
        VATPctText: Text;
    BEGIN
        TempVATEntry.SETRANGE("VAT %", TempVATEntry."VAT %");
        TempVATEntry.SETRANGE("EC %", TempVATEntry."EC %");
        REPEAT
            IF UseSign THEN BEGIN
                Base += TempVATEntry.Base * Sign;
                Amount += TempVATEntry.Amount * Sign;
            END ELSE BEGIN
                Base += ABS(TempVATEntry.Base);
                Amount += ABS(TempVATEntry.Amount);
            END;
        UNTIL TempVATEntry.NEXT = 0;
        IF TempVATEntry."EC %" <> 0 THEN BEGIN
            ECPercent := TempVATEntry."EC %";
            ECAmount += CalculateECAmount(Base, TempVATEntry."EC %");
            Amount := Amount - ECAmount;
        END;

        TempVATEntry.SETRANGE("VAT %");
        TempVATEntry.SETRANGE("EC %");

        VATPctText :=
          FormatNumber(CalcTipoImpositivo(NonExemptTransactionType, RegimeCodes, Base, TempVATEntry."VAT %"));

        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DetalleIVA', '', 'sii', SiiTxt, XMLNode);
        IF ExportTipoImpositivo(TempVATEntry, RegimeCodes) THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'TipoImpositivo', VATPctText, 'sii', SiiTxt, TempXmlNode);
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'BaseImponible', FormatNumber(Base), 'sii', SiiTxt, TempXmlNode);
        IF IsREAGYPSpecialSchemeCode(TempVATEntry, RegimeCodes) THEN BEGIN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'PorcentCompensacionREAGYP', VATPctText, 'sii', SiiTxt, TempXmlNode);
            AmountNodeName := 'ImporteCompensacionREAGYP';
        END;
        OnBeforeAddLineAmountElement(TempVATEntry, AmountNodeName, Amount);
        IF ExportTaxInformation(TempVATEntry, RegimeCodes) THEN
            XMLDOMManagement.AddElementWithPrefix(XMLNode, AmountNodeName, FormatNumber(Amount), 'sii', SiiTxt, TempXmlNode);
        IF (ECPercent <> 0) AND FillEUServiceNodes THEN
            GenerateRecargoEquivalenciaNodes(XMLNode, ECPercent, ECAmount);
        XMLDOMManagement.FindNode(XMLNode, '..', XMLNode);
    END;

    LOCAL PROCEDURE FillOperationDescription(VAR XMLNode: DotNet XmlNode; OperationDescription: Text; PostingDate: Date; LedgerEntryDescription: Text);
    VAR
        SIIInitialDocUpload: Codeunit 51303;
        TempXMLNode: DotNet XmlNode;
    BEGIN
        IF OperationDescription <> '' THEN
            XMLDOMManagement.AddElementWithPrefix(
              XMLNode, 'DescripcionOperacion', OperationDescription, 'sii', SiiTxt, TempXMLNode)
        ELSE
            IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(PostingDate) THEN
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DescripcionOperacion', RegistroDelPrimerSemestreTxt, 'sii', SiiTxt, TempXMLNode)
            ELSE
                XMLDOMManagement.AddElementWithPrefix(XMLNode, 'DescripcionOperacion', LedgerEntryDescription, 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE FillFechaRegContable(VAR XMLNode: DotNet XmlNode; PostingDate: Date; RequestDate: Date);
    VAR
        SIIInitialDocUpload: Codeunit 51303;
        TempXMLNode: DotNet XmlNode;
        NodePostingDate: Date;
    BEGIN
        IF SIIInitialDocUpload.DateWithinInitialUploadPeriod(PostingDate) THEN
            NodePostingDate := WORKDATE
        ELSE
            NodePostingDate := RequestDate;
        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'FechaRegContable', FormatDate(NodePostingDate), 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE FillFechaOperacion(VAR XMLNode: DotNet XmlNode; LastShptRcptDate: Date; PostingDate: Date; IsSales: Boolean; RegimeCodes: ARRAY[3] OF Code[2]);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        IF ((LastShptRcptDate = 0D) OR (LastShptRcptDate = PostingDate)) AND
           NOT (IsSales AND RegimeCodesContainsValue(RegimeCodes, '14'))
        THEN
            EXIT;

        IF LastShptRcptDate > WORKDATE THEN
            LastShptRcptDate := PostingDate;
        IF IsSales THEN BEGIN
            IF NOT IncludeFechaOperationForSales(PostingDate, LastShptRcptDate, RegimeCodes) THEN
                EXIT;
            IF IsShptDateMustBeAfterPostingDate(RegimeCodes) THEN
                LastShptRcptDate := PostingDate + 1;
        END;
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FechaOperacion', FormatDate(LastShptRcptDate), 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE FillMacrodatoNode(VAR XMLNode: DotNet XmlNode; TotalAmount: Decimal);
    VAR
        TempXMLNode: DotNet XmlNode;
        Value: Text;
    BEGIN
        IF NOT IncludeChangesVersion11 THEN
            EXIT;
        IF ABS(TotalAmount) > SIISetup."Invoice Amount Threshold" THEN
            Value := 'S'
        ELSE
            Value := 'N';
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'Macrodato', Value, 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE FillDocHeaderNode(): Text;
    BEGIN
        IF IncludeChangesVersion11 THEN
            EXIT('PeriodoLiquidacion');
        EXIT('PeriodoImpositivo');
    END;

    LOCAL PROCEDURE FillRefExternaNode(VAR XMLNode: DotNet XmlNode; Value: Text);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        IF NOT IncludeChangesVersion11 THEN
            EXIT;
        XMLDOMManagement.AddElementWithPrefix(XMLNode, 'RefExterna', Value, 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE FillBaseImponibleACosteNode(VAR XMLNode: DotNet XmlNode; RegimeCodes: ARRAY[3] OF Code[2]; TotalBase: Decimal);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        IF NOT RegimeCodesContainsValue(RegimeCodes, SIIManagement.GetBaseImponibleACosteRegimeCode) THEN
            EXIT;

        XMLDOMManagement.AddElementWithPrefix(
          XMLNode, 'BaseImponibleACoste', FormatNumber(TotalBase), 'sii', SiiTxt, TempXMLNode);
    END;

    LOCAL PROCEDURE IncludeContraparteNodeBySalesInvType(InvoiceType: Text): Boolean;
    BEGIN
        IF IncludeChangesVersion11bis THEN
            EXIT(InvoiceType IN ['F1', 'F3']);
        EXIT(InvoiceType IN ['F1', 'F3', 'F4']);
    END;

    // LOCAL PROCEDURE IncludeContraparteNodeByCrMemoType(CrMemoType: Option): Boolean;
    LOCAL PROCEDURE IncludeContraparteNodeByCrMemoType(CrMemoType: Enum "SII Sales Credit Memo Type"): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        EXIT(
          CrMemoType IN [SIIDocUploadState."Sales Cr. Memo Type"::"R1 Corrected Invoice",
                         SIIDocUploadState."Sales Cr. Memo Type"::"R2 Corrected Invoice (Art. 80.3)",
                         SIIDocUploadState."Sales Cr. Memo Type"::"R3 Corrected Invoice (Art. 80.4)",
                         SIIDocUploadState."Sales Cr. Memo Type"::"R4 Corrected Invoice (Other)"]);
    END;

    LOCAL PROCEDURE IncludeFechaOperationForSales(PostingDate: Date; LastShptRcptDate: Date; RegimeCodes: ARRAY[3] OF Code[2]): Boolean;
    VAR
        SpecialRegimeCodes: Boolean;
        i: Integer;
    BEGIN
        IF NOT IncludeChangesVersion11bis THEN
            EXIT(TRUE);
        FOR i := 1 TO ARRAYLEN(RegimeCodes) DO
            SpecialRegimeCodes := SpecialRegimeCodes OR (RegimeCodes[i] IN ['14', '15']);
        IF SpecialRegimeCodes THEN
            EXIT(TRUE);
        EXIT(PostingDate >= LastShptRcptDate);
    END;

    LOCAL PROCEDURE IsShptDateMustBeAfterPostingDate(RegimeCodes: ARRAY[3] OF Code[2]): Boolean;
    BEGIN
        IF NOT IncludeChangesVersion11bis THEN
            EXIT(FALSE);
        EXIT(RegimeCodesContainsValue(RegimeCodes, '14'));
    END;

    LOCAL PROCEDURE RegimeCodesContainsValue(RegimeCodes: ARRAY[3] OF Code[2]; Value: Text) RegimeCodeFound: Boolean;
    VAR
        i: Integer;
    BEGIN
        FOR i := 1 TO ARRAYLEN(RegimeCodes) DO
            RegimeCodeFound := RegimeCodeFound OR (RegimeCodes[i] = Value);
    END;

    LOCAL PROCEDURE IncludeChangesVersion11(): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        EXIT((SIIVersion = SIIDocUploadState."Version No."::"1.1") OR IncludeChangesVersion11bis);
    END;

    LOCAL PROCEDURE IncludeChangesVersion11bis(): Boolean;
    VAR
        SIIDocUploadState: Record 10752;
    BEGIN
        EXIT(SIIVersion >= SIIDocUploadState."Version No."::"2.1");
    END;

    LOCAL PROCEDURE IncludeImporteTotalNode(): Boolean;
    BEGIN
        IF NOT IncludeChangesVersion11bis THEN
            EXIT(TRUE);
        EXIT(SIISetup."Include ImporteTotal");
    END;

    LOCAL PROCEDURE GetF2InvoiceType(): Text[2];
    BEGIN
        EXIT('F2');
    END;

    LOCAL PROCEDURE GetF5InvoiceType(): Text[2];
    BEGIN
        EXIT('F5');
    END;

    LOCAL PROCEDURE UpdateSalesCrMemoTypeFromCorrInvType(VAR SIIDocUploadState: Record 10752);
    BEGIN
        IF SIIDocUploadState."Document Type" <> SIIDocUploadState."Document Type"::Invoice THEN
            EXIT;

        CASE SIIDocUploadState."Sales Invoice Type" OF
            SIIDocUploadState."Sales Invoice Type"::"R1 Corrected Invoice":
                SIIDocUploadState."Sales Cr. Memo Type" := SIIDocUploadState."Sales Cr. Memo Type"::"R1 Corrected Invoice";
            SIIDocUploadState."Sales Invoice Type"::"R2 Corrected Invoice (Art. 80.3)":
                SIIDocUploadState."Sales Cr. Memo Type" := SIIDocUploadState."Sales Cr. Memo Type"::"R2 Corrected Invoice (Art. 80.3)";
            SIIDocUploadState."Sales Invoice Type"::"R3 Corrected Invoice (Art. 80.4)":
                SIIDocUploadState."Sales Cr. Memo Type" := SIIDocUploadState."Sales Cr. Memo Type"::"R3 Corrected Invoice (Art. 80.4)";
            SIIDocUploadState."Sales Invoice Type"::"R4 Corrected Invoice (Other)":
                SIIDocUploadState."Sales Cr. Memo Type" := SIIDocUploadState."Sales Cr. Memo Type"::"R4 Corrected Invoice (Other)";
            SIIDocUploadState."Sales Invoice Type"::"R5 Corrected Invoice in Simplified Invoices":
                SIIDocUploadState."Sales Cr. Memo Type" :=
                  SIIDocUploadState."Sales Cr. Memo Type"::"R5 Corrected Invoice in Simplified Invoices";
        END;
    END;

    LOCAL PROCEDURE UpdatePurchCrMemoTypeFromCorrInvType(VAR SIIDocUploadState: Record 10752);
    BEGIN
        IF SIIDocUploadState."Document Type" <> SIIDocUploadState."Document Type"::Invoice THEN
            EXIT;

        CASE SIIDocUploadState."Purch. Invoice Type" OF
            SIIDocUploadState."Purch. Invoice Type"::"R1 Corrected Invoice":
                SIIDocUploadState."Purch. Cr. Memo Type" := SIIDocUploadState."Purch. Cr. Memo Type"::"R1 Corrected Invoice";
            SIIDocUploadState."Purch. Invoice Type"::"R2 Corrected Invoice (Art. 80.3)":
                SIIDocUploadState."Purch. Cr. Memo Type" := SIIDocUploadState."Purch. Cr. Memo Type"::"R2 Corrected Invoice (Art. 80.3)";
            SIIDocUploadState."Purch. Invoice Type"::"R3 Corrected Invoice (Art. 80.4)":
                SIIDocUploadState."Purch. Cr. Memo Type" := SIIDocUploadState."Purch. Cr. Memo Type"::"R3 Corrected Invoice (Art. 80.4)";
            SIIDocUploadState."Purch. Invoice Type"::"R4 Corrected Invoice (Other)":
                SIIDocUploadState."Purch. Cr. Memo Type" := SIIDocUploadState."Purch. Cr. Memo Type"::"R4 Corrected Invoice (Other)";
            SIIDocUploadState."Purch. Invoice Type"::"R5 Corrected Invoice in Simplified Invoices":
                SIIDocUploadState."Purch. Cr. Memo Type" :=
                  SIIDocUploadState."Purch. Cr. Memo Type"::"R5 Corrected Invoice in Simplified Invoices";
        END;
    END;

    PROCEDURE Reset();
    BEGIN
        IsInitialized := FALSE;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalculateCuotaDeducibleValue(VAR CuotaDeducibleValue: Decimal; VAR VATAmount: Decimal; VAR VATEntry: Record 254);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeAddLineAmountElement(VAR TempVATEntry: Record 254 TEMPORARY; AmountNodeName: Text; VAR Amount: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeAddVATAmountPurchDiffElement(VAR TempVATEntry: Record 254 TEMPORARY; VAR VATAmountDiff: Decimal);
    BEGIN
    END;

    LOCAL PROCEDURE FillFechaOperacionNode(VAR XMLNode: DotNet XmlNode; LastShptRcptDate: Date; PostingDate: Date);
    VAR
        TempXMLNode: DotNet XmlNode;
    BEGIN
        //JAV 09/07/19: - La fecha de operaci�n solo se env�a si est� informada, ver p�rrafo de abajo
        IF LastShptRcptDate <> 0D THEN BEGIN
            //Q5555 Fecha operaci�n, se indica que se debe enviar siempre. Y sin control de fecha como realiza el est�ndar.
            IF LastShptRcptDate = 0D THEN
                //JAV 01/07/19: - La fecha de operaci�n ser� la del registro de la factura si no indicamos otra cosa, no la del d�a.
                //LastShptRcptDate := TODAY;
                LastShptRcptDate := PostingDate;
            XMLDOMManagement.AddElementWithPrefix(XMLNode, 'FechaOperacion', FormatDate(LastShptRcptDate), 'sii', SiiTxt, TempXMLNode);
        END;
        /*{--------------------------------------------------------------------------------------------------------------------------------------
              Esto es directamente desde la AEAT, preguntas frecuentes, consultado el 09/07/19

              2.12. Cuando debe cumplimentarse el campo "Fecha operaci�n"?

              Deber�cumplimentarse el campo �fecha de operaci�n� en el Libro registro de Facturas Expedidas cuando
              la fecha de realizaci�n de la operaci�n sea distinta a la fecha de expedici�n de la factura.

              Deber� cumplimentarse el campo �fecha de operaci�n� en el Libro registro de Facturas Recibidas cuando
              la fecha de realizaci�n de la operaci�n sea distinta a la fecha de expedici�n de la factura y as� conste en la misma.

              Ejemplo: la empresa A vende mercanc�as a otra empresa el 3 de julio de 2018, documentando la operaci�n
              en factura de fecha 1 de agosto de 2018. �Cu�ndo debo suministrar los datos a trav�s del SII? �Debo consignar alg�n campo espec�fico?

              Los datos deber�n suministrarse en el plazo de los 4 d�as siguientes a la expedici�n de la factura (hasta el 7 de agosto).
              Se consignar� la �Fecha de expedici�n de la factura� (1 de agosto de 2018) y el campo �Fecha operaci�n� (3 de julio de 2018).
              ----------------------------------------------------------------------------------------------------------------------------------------}*/
    END;

    /*BEGIN
/*{
      PER 04/02/19: - Q5555 Fecha operacion, se indica que se debe enviar siempre. Y sin control de fecha como realiza el est�ndar.  >>Cancelado por las sigientes opciones
      JAV 01/07/19: - La fecha de operacion ser� la del registro de la factura si no indicamos otra cosa, no la del d�a.
      JAV 09/07/19: - La fecha de operacion solo se env�a si est� informada, ver p�rrafo de abajo que lo explica en el desarrollo
                    - Cuando cancelamos un efecto, generamos una nueva factura para su pago, esta no debe pasar al SII
      JAV 12/05/22: - QB 1.10.40 Contemplar si se ha marcado en los movimientos de cliente o proveedor no subir al SII.
    }
END.*/
}









