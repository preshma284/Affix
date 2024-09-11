Codeunit 7174342 "QuoFacturae XML Creator"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        IsInitialized: Boolean;
        XMLDOMManagement: Codeunit 6224;
        LastXMLNode: DotNet XmlNode;
        VATAmounts: ARRAY[2, 10] OF Decimal;
        ECAmount: ARRAY[2, 10] OF Decimal;
        TMPVATEntry: Record 254 TEMPORARY;
        TotalInvoicesAmount: Decimal;
        TotalOutstandingAmount: Decimal;
        TotalExecutableAmount: Decimal;
        TotalGeneralSurcharges: Decimal;
        TotalTaxOutputs: Decimal;
        TotalGrossAmount: Decimal;

    PROCEDURE GenerateXML(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument);
    VAR
        SoapenvTxt: TextConst ENU = 'http://schemas.xmlsoap.org/soap/envelope/', ESP = 'http://schemas.xmlsoap.org/soap/envelope/';
        RootXMLNode: DotNet XmlNode;
        CurrentXMlNode: DotNet XmlNode;
        XMLNamespaceManager: DotNet XmlNamespaceManager;
        XMLNode: DotNet XmlNode;
    BEGIN
        IF IsInitialized THEN BEGIN
            XMLNode := LastXMLNode;
            EXIT;
        END ELSE
            XMLDoc := XMLDoc.XmlDocument;

        IsInitialized := TRUE;

        XMLDOMManagement.AddRootElementWithPrefix(XMLDoc, 'Facturae', 'namespace', SoapenvTxt, RootXMLNode);
        XMLDOMManagement.AddAttribute(RootXMLNode, 'xmlns:namespace', 'http://www.facturae.es/Facturae/2014/v3.2.1/Facturae');
        XMLDOMManagement.AddDeclaration(XMLDoc, '1.0', 'UTF-8', '');
        XMLNamespaceManager := XMLNamespaceManager.XmlNamespaceManager(RootXMLNode.OwnerDocument.NameTable);

        CalcVATEntries(CustLedgerEntry);

        CreateHeader(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);
        CreateParties(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);
        CreateInvoices(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);

        //CreateXMLFile(RootXMLNode);
    END;

    LOCAL PROCEDURE CreateHeader(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        Currency: Record 4;
    BEGIN
        XMLDOMManagement.AddElement(RootXMLNode, 'FileHeader', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'SchemaVersion', '3.2.1', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Modality', 'I', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceIssuerType', 'EM', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Batch', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'BatchIdentifier', CustLedgerEntry."Document No.", '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoicesCount', '1', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalInvoicesAmount', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, TotalInvoicesAmount), '', XMLNode);
        IF CustLedgerEntry."Currency Code" <> 'EUR' THEN BEGIN
            Currency.RESET;
            Currency.SETRANGE(Code, CustLedgerEntry."Currency Code");
            IF Currency.FINDFIRST THEN BEGIN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, TotalInvoicesAmount * Currency."Currency Factor"), '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            END;
        END;
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalOutstandingAmount', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, TotalOutstandingAmount), '', XMLNode);
        IF CustLedgerEntry."Currency Code" <> 'EUR' THEN BEGIN
            Currency.RESET;
            Currency.SETRANGE(Code, CustLedgerEntry."Currency Code");
            IF Currency.FINDFIRST THEN BEGIN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, TotalOutstandingAmount * Currency."Currency Factor"), '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            END;
        END;
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalExecutableAmount', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, TotalExecutableAmount), '', XMLNode);
        IF CustLedgerEntry."Currency Code" <> 'EUR' THEN BEGIN
            Currency.RESET;
            Currency.SETRANGE(Code, CustLedgerEntry."Currency Code");
            IF Currency.FINDFIRST THEN BEGIN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, TotalExecutableAmount * Currency."Currency Factor"), '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            END;
        END;
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceCurrencyCode', 'EUR', '', XMLNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateParties(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    BEGIN
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Parties', '', '', CurrentXMlNode);

        CreateSellerParty(XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);
        CreateBuyerParty(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateSellerParty(VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        CompanyInformation: Record 79;
        Text001: TextConst ESP = 'No existe configuraci�n de empresa.';
        CountryRegion: Record 9;
        PersonaFisica: Boolean;
        Text002: TextConst ESP = 'No ha definido un c�digo postar correcto en Informaci�n de Empresa';
    BEGIN
        CompanyInformation.RESET;
        IF NOT CompanyInformation.GET() THEN
            ERROR(Text001);
        IF (STRLEN(CompanyInformation."Post Code") <> 5) THEN
            ERROR(Text002);

        PersonaFisicaJuridica(CompanyInformation."VAT Registration No.", PersonaFisica);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'SellerParty', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxIdentification', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'PersonTypeCode', 'J', '', XMLNode);
        IF (CompanyInformation."Country/Region Code" = 'ES') THEN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'ResidenceTypeCode', 'R', '', XMLNode)
        ELSE BEGIN
            CountryRegion.RESET;
            CountryRegion.GET(CompanyInformation."Country/Region Code");
            IF (CountryRegion."EU Country/Region Code" <> '') THEN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'ResidenceTypeCode', 'U', '', XMLNode)
            ELSE
                XMLDOMManagement.AddElement(CurrentXMlNode, 'ResidenceTypeCode', 'E', '', XMLNode);
        END;
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxIdentificationNumber', CompanyInformation."VAT Registration No.", '', XMLNode);

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'LegalEntity', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'CorporateName', CompanyInformation.Name, '', XMLNode);
        IF (CompanyInformation."Country/Region Code" = 'ES') THEN BEGIN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'AddressInSpain', '', '', CurrentXMlNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'Address', CompanyInformation.Address, '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'PostCode', CompanyInformation."Post Code", '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'Town', CompanyInformation.City, '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'Province', CompanyInformation.County, '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'CountryCode', 'ESP', '', XMLNode);
        END ELSE BEGIN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'OverseasAddress', '', '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'Address', CompanyInformation.Address, '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'PostCodeAndTown', CompanyInformation."Post Code" + ' ' + CompanyInformation.City, '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'Province', CompanyInformation.County, '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'CountryCode', CountryRegion."QFA Code ISO 3166-1 Alpha-3", '', XMLNode);
        END;

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateBuyerParty(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        PersonaFisica: Boolean;
        Customer: Record 18;
        Text001: TextConst ESP = 'No existe el cliente %1.';
        CountryRegion: Record 9;
        QuoFacturaeAdminCenter: Record 7174370;
        Text002: TextConst ESP = 'No ha definido un C�digo Postal Correcto en el Centro Administrativo del cliente';
        Text003: TextConst ESP = 'No ha definido un C�digo Postal Correcto en la ficha del cliente';
    BEGIN
        Customer.RESET;
        IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN
            ERROR(Text001, Customer."No.");

        IF (STRLEN(Customer."Post Code") <> 5) THEN
            ERROR(Text003);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'BuyerParty', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxIdentification', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'PersonTypeCode', 'J', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'ResidenceTypeCode', 'R', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxIdentificationNumber', Customer."VAT Registration No.", '', XMLNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

        QuoFacturaeAdminCenter.RESET;
        QuoFacturaeAdminCenter.SETRANGE("Customer no.", Customer."No.");
        // +QFA 0.2
        //IF QuoFacturaeAdminCenter.FINDFIRST THEN BEGIN
        IF QuoFacturaeAdminCenter.FINDSET THEN BEGIN
            // -QF 0.2
            IF (STRLEN(QuoFacturaeAdminCenter."Post code") <> 5) THEN
                ERROR(Text002);

            XMLDOMManagement.AddElement(CurrentXMlNode, 'AdministrativeCentres', '', '', CurrentXMlNode);
            REPEAT
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AdministrativeCentre', '', '', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'CentreCode', QuoFacturaeAdminCenter.Code, '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'RoleTypeCode', GetAdministrativeCenter(QuoFacturaeAdminCenter), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Name', QuoFacturaeAdminCenter.Name, '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'FirstSurname', QuoFacturaeAdminCenter."First Surname", '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'SecondSurname', QuoFacturaeAdminCenter."Second Surname", '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AddressInSpain', '', '', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Address', QuoFacturaeAdminCenter.Address, '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'PostCode', QuoFacturaeAdminCenter."Post code", '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Town', QuoFacturaeAdminCenter.City, '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Province', QuoFacturaeAdminCenter.County, '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'CountryCode', 'ESP', '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'CentreDescription', QuoFacturaeAdminCenter.Description, '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            UNTIL QuoFacturaeAdminCenter.NEXT = 0;
        END;

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'LegalEntity', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'CorporateName', Customer.Name, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'AddressInSpain', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Address', Customer.Address, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'PostCode', Customer."Post Code", '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Town', Customer.City, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Province', Customer.County, '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'CountryCode', 'ESP', '', XMLNode);

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateInvoices(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    BEGIN
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Invoices', '', '', CurrentXMlNode);

        CreateInvoice(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);
        CreateTaxOutputs(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);
        CreateInvoiceTotals(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);
        CreateItems(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);

        CreateInvoicePaymentDetails(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);          //JAV 25/03/21: - 1.3h Informaci�n de pagos
        CreateInvoiceAdditionalInformation(CustLedgerEntry, XMLDoc, XMLNode, RootXMLNode, CurrentXMlNode);   //JAV 21/03/21: - 1.3g Informaci�n adicional de la factura con los Anexos

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateInvoice(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        SalesCrMemoHeader: Record 114;
        SalesInvoiceHeader: Record 112;
        Currency: Record 4;
        QuoFacturaeSetup: Record 7174368;
        CorrectionMethod: Code[2];
        InvoiceIssueDate: Text[10];
        OperationDate: Date;
        is: InStream;
        txtTemp1: Text[1000];
        txtTemp2: Text[1000];
        txtTemp3: Text[500];
        StartDate: Date;
        EndDate: Date;
    BEGIN
        OperationDate := 0D;
        StartDate := 0D;
        EndDate := 0D;

        XMLDOMManagement.AddElement(CurrentXMlNode, 'Invoice', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceHeader', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceNumber', CustLedgerEntry."Document No.", '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceDocumentType', 'FC', '', XMLNode);
        CASE CustLedgerEntry."Document Type" OF
            CustLedgerEntry."Document Type"::"Credit Memo":
                BEGIN
                    CorrectionMethod := FORMAT(CustLedgerEntry."QFA Correction Method Code", 0);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceClass', 'OR', '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'Corrective', '', '', CurrentXMlNode);
                    IF CorrectionMethod IN ['01', '02'] THEN BEGIN
                        SalesCrMemoHeader.RESET;
                        IF SalesCrMemoHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                            OperationDate := SalesCrMemoHeader."Posting Date";
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceNumber', SalesCrMemoHeader."Corrected Invoice No.", '', XMLNode);
                            IF SalesInvoiceHeader.GET(SalesCrMemoHeader."Corrected Invoice No.") THEN
                                InvoiceIssueDate := AdjustDate(SalesInvoiceHeader."Document Date");
                        END;
                    END;
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ReasonCode', FORMAT(CustLedgerEntry."QFA Correction Reason Code", 0), '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ReasonDescription', GetReasonCodeDesc(CustLedgerEntry."QFA Correction Reason Code"), '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxPeriod', '', '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'CorrectionMethod', CorrectionMethod, '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'CorrectionMethodDescription', GetCorrectionMethodDesc(CustLedgerEntry."QFA Correction Method Code"), '', XMLNode);
                    IF CorrectionMethod IN ['01', '02'] THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceIssueDate', InvoiceIssueDate, '', XMLNode);
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END;
            CustLedgerEntry."Document Type"::Invoice:
                BEGIN
                    SalesInvoiceHeader.RESET;
                    IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN
                        OperationDate := SalesInvoiceHeader."Shipment Date";
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceClass', 'OO', '', XMLNode);

                    StartDate := SalesInvoiceHeader."QFA Period Start Date";
                    EndDate := SalesInvoiceHeader."QFA Period End Date";
                END;
        END;

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceIssueData', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'IssueDate', AdjustDate(CustLedgerEntry."Document Date"), '', XMLNode);
        IF (OperationDate <> CustLedgerEntry."Document Date") AND (OperationDate <> 0D) THEN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'OperationDate', AdjustDate(CustLedgerEntry."Document Date"), '', XMLNode);

        //JAV 20/03/21 Periodo de facturaci�n
        // QuoFacturaeSetup.GET;
        // IF (StartDate = 0D) AND (QuoFacturaeSetup."Send alwais period dates") THEN BEGIN
        //  StartDate := CustLedgerEntry."Document Date";
        //  EndDate   := CustLedgerEntry."Document Date";
        // END;

        IF (StartDate <> 0D) THEN BEGIN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoicingPeriod', '', '', CurrentXMlNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'StartDate', AdjustDate(StartDate), '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'EndDate', AdjustDate(EndDate), '', XMLNode);
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        END;

        IF CustLedgerEntry."Currency Code" <> '' THEN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceCurrencyCode', CustLedgerEntry."Currency Code", '', XMLNode)
        ELSE
            XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceCurrencyCode', 'EUR', '', XMLNode);

        IF CustLedgerEntry."Currency Code" <> 'EUR' THEN BEGIN
            Currency.RESET;
            Currency.SETRANGE(Code, CustLedgerEntry."Currency Code");
            IF Currency.FINDFIRST THEN BEGIN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'ExchangeRateDetails', '', '', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'ExchangeRate', FORMAT(Currency."Currency Factor"), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'ExchangeRateDate', AdjustDate(Currency."Last Date Adjusted"), '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            END;
        END;

        IF CustLedgerEntry."Currency Code" <> '' THEN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxCurrencyCode', CustLedgerEntry."Currency Code", '', XMLNode)
        ELSE
            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxCurrencyCode', 'EUR', '', XMLNode);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'LanguageName', 'es', '', XMLNode);
        IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice THEN BEGIN
            SalesInvoiceHeader.RESET;
            IF SalesInvoiceHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                IF SalesInvoiceHeader."Work Description".HASVALUE THEN BEGIN
                    SalesInvoiceHeader.CALCFIELDS("Work Description");
                    SalesInvoiceHeader."Work Description".CREATEINSTREAM(is);
                    is.READ(txtTemp1, 1000);
                    is.READ(txtTemp2, 1000);
                    is.READ(txtTemp3, 498);
                    //XMLDOMManagement.AddElement(CurrentXMlNode,'InvoiceDescription',txtTemp1+' '+txtTemp2+' '+txtTemp3,'',XMLNode);
                END;
            END;
        END;

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateTaxOutputs(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        VATProductPostingGroup: Record 324;
    BEGIN
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxesOutputs', '', '', CurrentXMlNode);

        TMPVATEntry.RESET;
        TMPVATEntry.SETRANGE("Document No.", CustLedgerEntry."Document No.");
        TMPVATEntry.SETRANGE("Posting Date", CustLedgerEntry."Posting Date");
        IF TMPVATEntry.FINDSET THEN
            REPEAT
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Tax', '', '', CurrentXMlNode);
                VATProductPostingGroup.RESET;
                IF VATProductPostingGroup.GET(TMPVATEntry."VAT Prod. Posting Group") THEN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', AdjustOption(2, FORMAT(VATProductPostingGroup."QFA Code Tax Type", 0)), '', XMLNode)
                ELSE
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', '05', '', XMLNode);//DUDA

                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxRate', AdjustDecimal(2, TMPVATEntry."VAT %"), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxableBase', '', '', CurrentXMlNode);
                //QUONEXT PER 01.07.19 NO informa el importe base no realizado
                IF TMPVATEntry."Unrealized Base" <> 0 THEN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry."Unrealized Base"), '', XMLNode)
                ELSE
                    //FIN QUONEXT PER 01.07.19
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry.Base), '', XMLNode);
                IF NOT (CustLedgerEntry."Currency Code" IN ['EUR', '']) THEN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, -TMPVATEntry.Base), '', XMLNode);//DUDA
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

                IF TMPVATEntry.Amount <> 0 THEN BEGIN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxAmount', '', '', CurrentXMlNode);
                    IF TMPVATEntry."EC %" <> 0 THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, (-TMPVATEntry.Amount) - (TMPVATEntry."EC %" * (-TMPVATEntry.Base) / 100)), '', XMLNode)
                    ELSE BEGIN
                        //QUONEXT PER 01.07.19
                        IF TMPVATEntry."Unrealized Amount" <> 0 THEN
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry."Unrealized Amount"), '', XMLNode)
                        ELSE
                            //FIN QUONEXT PER 01.07.19
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry.Amount), '', XMLNode);
                    END;
                    IF NOT (CustLedgerEntry."Currency Code" IN ['EUR', '']) THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, -TMPVATEntry.Amount), '', XMLNode);//DUDA
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END ELSE BEGIN
                    IF TMPVATEntry."Unrealized Amount" <> 0 THEN BEGIN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxAmount', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry."Unrealized Amount"), '', XMLNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                    END;
                END;
                IF FALSE THEN BEGIN //DUDA
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'SpecialTaxableBase', '', '', CurrentXMlNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry.Amount), '', XMLNode);
                    IF NOT (CustLedgerEntry."Currency Code" IN ['EUR', '']) THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, -TMPVATEntry.Amount), '', XMLNode);//DUDA
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

                    XMLDOMManagement.AddElement(CurrentXMlNode, 'SpecialTaxAmount', '', '', CurrentXMlNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, -TMPVATEntry.Amount), '', XMLNode);
                    IF NOT (CustLedgerEntry."Currency Code" IN ['EUR', '']) THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, -TMPVATEntry.Amount), '', XMLNode);//DUDA
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END;

                IF TMPVATEntry."EC %" <> 0 THEN BEGIN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalenceSurcharge', AdjustDecimal(2, TMPVATEntry."EC %"), '', XMLNode);

                    XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalenceSurchargeAmount', '', '', CurrentXMlNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, (-TMPVATEntry.Amount) - (TMPVATEntry."VAT %" * (-TMPVATEntry.Base) / 100)), '', XMLNode);
                    IF NOT (CustLedgerEntry."Currency Code" IN ['EUR', '']) THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', AdjustDecimal(2, (-TMPVATEntry.Amount) - (TMPVATEntry."EC %" * (-TMPVATEntry.Base) / 100)), '', XMLNode);//DUDA
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END;
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            UNTIL TMPVATEntry.NEXT = 0;
        //XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateTaxesWithheld(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        VATProductPostingGroup: Record 324;
    BEGIN
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxesWithheld', '', '', CurrentXMlNode);

        TMPVATEntry.RESET;
        TMPVATEntry.SETRANGE("Document No.", CustLedgerEntry."Document No.");
        TMPVATEntry.SETRANGE("Posting Date", CustLedgerEntry."Posting Date");
        IF TMPVATEntry.FINDSET THEN
            REPEAT
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Tax', '', '', CurrentXMlNode);
                VATProductPostingGroup.RESET;
                IF VATProductPostingGroup.GET(TMPVATEntry."VAT Prod. Posting Group") THEN
                    XMLDOMManagement.AddElement(CurrentXMlNode, ' ', AdjustOption(2, FORMAT(VATProductPostingGroup."QFA Code Tax Type", 0)), '', XMLNode)
                ELSE
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', '05', '', XMLNode);//DUDA

                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxRate', FORMAT(TMPVATEntry."VAT %"), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxableBase', '', '', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', FORMAT(TMPVATEntry.Base), '', XMLNode);
                IF CustLedgerEntry."Currency Code" <> 'EUR' THEN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', FORMAT(TMPVATEntry.Base), '', XMLNode);//DUDA
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);

                IF TMPVATEntry.Amount <> 0 THEN BEGIN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxAmount', '', '', CurrentXMlNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', FORMAT(TMPVATEntry.Amount), '', XMLNode);
                    IF CustLedgerEntry."Currency Code" <> 'EUR' THEN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'EquivalentInEuros', FORMAT(TMPVATEntry.Amount), '', XMLNode);//DUDA
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END;
            UNTIL TMPVATEntry.NEXT = 0;

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateInvoiceTotals(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        DiscRate: Decimal;
        i: Integer;
        ECLine: Boolean;
    BEGIN
        //CalcTotals(CustLedgerEntry,TotalGeneralSurcharges,TotalTaxOutputs,TotalGrossAmount);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceTotals', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalGrossAmount', AdjustDecimal(2, TotalGrossAmount), '', XMLNode);
        IF CustLedgerEntry."Inv. Discount (LCY)" <> 0 THEN BEGIN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'GeneralDiscounts', '', '', CurrentXMlNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'Discount', '', '', CurrentXMlNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountReason', '', '', XMLNode);
            DiscRate := CustLedgerEntry."Inv. Discount (LCY)" * 100 / CustLedgerEntry."Sales (LCY)";
            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountRate', AdjustDecimal(2, DiscRate), '', XMLNode);
            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountAmount', AdjustDecimal(2, CustLedgerEntry."Inv. Discount (LCY)"), '', XMLNode);
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        END;
        ECLine := FALSE;
        FOR i := 1 TO ARRAYLEN(ECAmount, 1) DO BEGIN
            IF ECAmount[1] [i] <> 0 THEN
                ECLine := TRUE;
        END;
        IF ECLine THEN BEGIN
            XMLDOMManagement.AddElement(CurrentXMlNode, 'GeneralSurcharges', '', '', CurrentXMlNode);
            FOR i := 1 TO ARRAYLEN(ECAmount, 1) DO BEGIN
                IF ECAmount[1] [i] <> 0 THEN BEGIN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'Charge', '', '', CurrentXMlNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeReason', '', '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeRate', AdjustDecimal(2, ECAmount[1] [i]), '', XMLNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeAmount', AdjustDecimal(2, ECAmount[2] [i]), '', XMLNode);
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END;
            END;
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        END;
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalGeneralDiscounts', AdjustDecimal(2, CustLedgerEntry."Inv. Discount (LCY)"), '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalGeneralSurcharges', AdjustDecimal(2, TotalGeneralSurcharges), '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalGrossAmountBeforeTaxes', AdjustDecimal(2, TotalGrossAmount - CustLedgerEntry."Inv. Discount (LCY)" + TotalGeneralSurcharges), '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalTaxOutputs', AdjustDecimal(2, TotalTaxOutputs), '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalTaxesWithheld', '0.00', '', XMLNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceTotal', AdjustDecimal(2, TotalGrossAmount - CustLedgerEntry."Inv. Discount (LCY)" + TotalGeneralSurcharges + TotalTaxOutputs), '', XMLNode);
        /*{subvenciones
              XMLDOMManagement.AddElement(CurrentXMlNode,'Subsidies','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'Subsidy','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'SubsidyDescription','',XMLNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'SubsidyRate','',XMLNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'SubsidyAmount','',XMLNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);}*/
        /*{anticipos
              XMLDOMManagement.AddElement(CurrentXMlNode,'PaymentsOnAccount','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'PaymentOnAccount','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'PaymentOnAccountDate','',XMLNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'PaymentOnAccountAmount','',XMLNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);}*/
        /*{Suplidos
              XMLDOMManagement.AddElement(CurrentXMlNode,'ReimbursableExpenses','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'ReimbursableExpenses','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'ReimbursableExpensesSellerParty','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'PersonTypeCode','','',XMLNode); //F o J
              XMLDOMManagement.AddElement(CurrentXMlNode,'PersonTypResidenceTypeCodeeCode','','',XMLNode); //E, R o U
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'TaxIdentificationNumber','',XMLNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'ReimbursableExpensesBuyerParty','','',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'PersonTypeCode','','',XMLNode); //F o J
              XMLDOMManagement.AddElement(CurrentXMlNode,'PersonTypResidenceTypeCodeeCode','','',XMLNode); //E, R o U
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'TaxIdentificationNumber','',XMLNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'IssueDate','',XMLNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'InvoiceNumber','',XMLNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'InvoiceSeriesCode','',XMLNode);
              XMLDOMManagement.AddElement(CurrentXMlNode,'ReimbursableExpensesAmount','',XMLNode);
              XMLDOMManagement.FindNode(CurrentXMlNode,'..',CurrentXMlNode);}*/
        //XMLDOMManagement.AddElement(CurrentXMlNode,'TotalFinancialExpenses','',XMLNode); //Gastos Financieros
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalOutstandingAmount', AdjustDecimal(2, TotalGrossAmount - CustLedgerEntry."Inv. Discount (LCY)" + TotalGeneralSurcharges + TotalTaxOutputs), '', XMLNode)
        ;
        //XMLDOMManagement.AddElement(CurrentXMlNode,'TotalPaymentsOnAccount','',XMLNode); //Total Anticipos
        //XMLDOMManagement.AddElement(CurrentXMlNode,'AmountsWithheld',CustLedgerEntry."Inv. Discount (LCY)",'',XMLNode); //Total retenciones
        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalExecutableAmount', AdjustDecimal(2, TotalGrossAmount - CustLedgerEntry."Inv. Discount (LCY)" + TotalGeneralSurcharges + TotalTaxOutputs), '', XMLNode);
        //XMLDOMManagement.AddElement(CurrentXMlNode,'TotalReimbursableExpenses',CustLedgerEntry."Inv. Discount (LCY)",'',XMLNode); //Total Suplidos
        //XMLDOMManagement.AddElement(CurrentXMlNode,'PaymentInKind',CustLedgerEntry."Inv. Discount (LCY)",'',XMLNode); //Total pagos en especie

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateItems(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        UnitofMeasure: Record 204;
        VATProductPostingGroup: Record 324;
        QuoFacturaeGroupedConcepts: Query 50100;// 7174340;
        QuoFacturae_CrMGroupedConcepts: Query 50101;// 7174341;
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        SalesCrMemoLine: Record 115;
        InStr: InStream;
        WorkDescription: Text;
        QuoFacturaeSetup: Record 7174368;
        FirstLine: Boolean;
    BEGIN
        //JAV 20/03/21: - QFA 1.3g Se cambia la forma de generar las l�neas agrupadas o sin agrupar

        WorkDescription := GetWorkDescription(CustLedgerEntry);

        XMLDOMManagement.AddElement(CurrentXMlNode, 'Items', '', '', CurrentXMlNode);

        QuoFacturaeSetup.GET;
        CASE TRUE OF
            //Facturas no agrupadas
            (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice) AND (QuoFacturaeSetup."Generate Grouped" = FALSE):
                BEGIN
                    //JAV 08/04/21: - QFA 1.3j Se a�ade la descipci�n del trabajo en la primera l�nea
                    IF (WorkDescription <> '') AND (QuoFacturaeSetup."WorkDescription in Lines") THEN BEGIN
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceLine', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'ItemDescription', WorkDescription, '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'Quantity', '0', '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitOfMeasure', '01', '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitPriceWithoutTax', '0', '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalCost', '0', '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'GrossAmount', '0', '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxesOutputs', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'Tax', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', '05', '', XMLNode);//DUDA
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxRate', '0', '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxableBase', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', '0', '', XMLNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxAmount', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', '0', '', XMLNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                    END;


                    // +QFA 0.2
                    SalesInvoiceLine.RESET;
                    SalesInvoiceLine.SETRANGE("Document No.", CustLedgerEntry."Document No.");
                    IF SalesInvoiceLine.FINDSET THEN
                        REPEAT
                            IF (SalesInvoiceLine.Description <> '') OR (SalesInvoiceLine.Quantity <> 0) OR (SalesInvoiceLine.Amount <> 0) THEN BEGIN //JAV 20/03/21 No sacar l�neas a cero
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceLine', '', '', CurrentXMlNode);

                                //JAV 20/03/21 Se a�ade referencia del cliente
                                IF (SalesInvoiceHeader."External Document No." <> '') THEN
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'FileReference', COPYSTR(SalesInvoiceHeader."External Document No.", 1, 20), '', XMLNode);

                                XMLDOMManagement.AddElement(CurrentXMlNode, 'ItemDescription', SalesInvoiceLine.Description + ' ' + SalesInvoiceLine."Description 2", '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'Quantity', FORMAT(SalesInvoiceLine.Quantity), '', XMLNode);
                                UnitofMeasure.GET(SalesInvoiceLine."Unit of Measure Code");
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitOfMeasure', AdjustOption(2, FORMAT(UnitofMeasure."QFA Unit of measure code FACE", 0)), '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitPriceWithoutTax', AdjustDecimal(6, SalesInvoiceLine."Unit Price"), '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalCost', AdjustDecimal(2, SalesInvoiceLine.Amount), '', XMLNode);

                                IF SalesInvoiceLine."Line Discount %" <> 0 THEN BEGIN
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountsAndRebates', '', '', CurrentXMlNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'Discount', '', '', CurrentXMlNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountReason', '', '', XMLNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountRate', AdjustDecimal(2, SalesInvoiceLine."Line Discount %"), '', XMLNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountAmount', AdjustDecimal(2, SalesInvoiceLine."Line Discount Amount"), '', XMLNode);

                                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                END;

                                IF SalesInvoiceLine."EC %" <> 0 THEN BEGIN

                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'Charges', '', '', CurrentXMlNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'Charge', '', '', CurrentXMlNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeReason', '', '', XMLNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeRate', AdjustDecimal(2, SalesInvoiceLine."EC %"), '', XMLNode);
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeAmount', AdjustDecimal(2, SalesInvoiceLine."VAT Base Amount" * SalesCrMemoLine."EC %" / 100), '', XMLNode);
                                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                END;
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'GrossAmount', AdjustDecimal(2, SalesInvoiceLine.Amount - SalesInvoiceLine."Line Discount Amount" + (SalesInvoiceLine."VAT Base Amount" * SalesInvoiceLine."EC %" / 100)), '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxesOutputs', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'Tax', '', '', CurrentXMlNode);
                                VATProductPostingGroup.RESET;
                                IF VATProductPostingGroup.GET(SalesInvoiceLine."VAT Prod. Posting Group") THEN
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', AdjustOption(2, FORMAT(VATProductPostingGroup."QFA Code Tax Type", 0)), '', XMLNode)
                                ELSE
                                    XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', '05', '', XMLNode);//DUDA
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxRate', AdjustDecimal(2, SalesInvoiceLine."VAT %"), '', XMLNode);

                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxableBase', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, SalesInvoiceLine."VAT Base Amount"), '', XMLNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxAmount', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount"), '', XMLNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'ArticleCode', FORMAT(SalesInvoiceLine."No."), '', XMLNode);

                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            END;
                        UNTIL SalesInvoiceLine.NEXT = 0;
                END;

            //Facturas agrupadas
            (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice) AND (QuoFacturaeSetup."Generate Grouped" = TRUE):
                BEGIN
                    // +QFA 0.2
                    QuoFacturaeGroupedConcepts.SETRANGE(QuoFacturaeGroupedConcepts.Document_No, CustLedgerEntry."Document No.");
                    QuoFacturaeGroupedConcepts.OPEN;
                    WHILE QuoFacturaeGroupedConcepts.READ DO BEGIN
                        IF (QuoFacturaeGroupedConcepts.Quantity <> 0) OR (QuoFacturaeGroupedConcepts.Sum_Amount <> 0) THEN BEGIN //JAV 20/03/21 No sacar l�neas a cero
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceLine', '', '', CurrentXMlNode);

                            XMLDOMManagement.AddElement(CurrentXMlNode, 'ItemDescription', WorkDescription, '', XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'Quantity', FORMAT(QuoFacturaeGroupedConcepts.Quantity), '', XMLNode);
                            UnitofMeasure.GET(QuoFacturaeGroupedConcepts.Unit_of_Measure_Code);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitOfMeasure', AdjustOption(2, FORMAT(UnitofMeasure."QFA Unit of measure code FACE", 0)), '', XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitPriceWithoutTax', AdjustDecimal(6, QuoFacturaeGroupedConcepts.Sum_Unit_Price), '', XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalCost', AdjustDecimal(2, QuoFacturaeGroupedConcepts.Sum_Amount), '', XMLNode);

                            IF QuoFacturaeGroupedConcepts.Line_Discount <> 0 THEN BEGIN
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountsAndRebates', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'Discount', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountReason', '', '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountRate', AdjustDecimal(2, QuoFacturaeGroupedConcepts.Line_Discount), '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountAmount', AdjustDecimal(2, QuoFacturaeGroupedConcepts.Sum_Line_Discount_Amount), '', XMLNode);

                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            END;

                            IF QuoFacturaeGroupedConcepts.EC <> 0 THEN BEGIN
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'Charges', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'Charge', '', '', CurrentXMlNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeReason', '', '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeRate', AdjustDecimal(2, QuoFacturaeGroupedConcepts.EC), '', XMLNode);
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeAmount', AdjustDecimal(2, QuoFacturaeGroupedConcepts.Sum_VAT_Base_Amount * QuoFacturaeGroupedConcepts.EC / 100), '', XMLNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            END;

                            XMLDOMManagement.AddElement(CurrentXMlNode, 'GrossAmount', AdjustDecimal(2, (QuoFacturaeGroupedConcepts.Sum_Amount - QuoFacturaeGroupedConcepts.Sum_Line_Discount_Amount) +
                                                                                    ((QuoFacturaeGroupedConcepts.Sum_VAT_Base_Amount * QuoFacturaeGroupedConcepts.EC) / 100)), '', XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxesOutputs', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'Tax', '', '', CurrentXMlNode);
                            VATProductPostingGroup.RESET;
                            IF VATProductPostingGroup.GET(QuoFacturaeGroupedConcepts.VAT_Prod_Posting_Group) THEN
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', AdjustOption(2, FORMAT(VATProductPostingGroup."QFA Code Tax Type", 0)), '', XMLNode)
                            ELSE
                                XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', '05', '', XMLNode);//DUDA
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxRate', AdjustDecimal(2, QuoFacturaeGroupedConcepts.VAT), '', XMLNode);

                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxableBase', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, QuoFacturaeGroupedConcepts.Sum_VAT_Base_Amount), '', XMLNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxAmount', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, QuoFacturaeGroupedConcepts.Sum_Amount_Including_VAT - QuoFacturaeGroupedConcepts.Sum_VAT_Base_Amount), '', XMLNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'ArticleCode', FORMAT(QuoFacturaeGroupedConcepts.No), '', XMLNode);

                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        END;
                    END;
                    QuoFacturaeGroupedConcepts.CLOSE;
                END;

            //Si son abonos, de momento salen siempre agrupados
            (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo"):
                BEGIN
                    // +QFA 0.2
                    QuoFacturae_CrMGroupedConcepts.SETRANGE(QuoFacturae_CrMGroupedConcepts.Document_No, CustLedgerEntry."Document No.");
                    QuoFacturae_CrMGroupedConcepts.OPEN;
                    WHILE QuoFacturae_CrMGroupedConcepts.READ DO BEGIN

                        XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceLine', '', '', CurrentXMlNode);
                        //XMLDOMManagement.AddElement(CurrentXMlNode,'ItemDescription',SalesCrMemoLine.Description+' ' +SalesCrMemoLine."Description 2",'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'ItemDescription', QuoFacturae_CrMGroupedConcepts.Description + ' ' + QuoFacturae_CrMGroupedConcepts.Description_2, '', XMLNode);
                        //XMLDOMManagement.AddElement(CurrentXMlNode,'Quantity',FORMAT(SalesCrMemoLine.Quantity),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'Quantity', FORMAT(QuoFacturae_CrMGroupedConcepts.Quantity), '', XMLNode);
                        //UnitofMeasure.GET(SalesCrMemoLine."Unit of Measure Code");
                        UnitofMeasure.GET(QuoFacturae_CrMGroupedConcepts.Unit_of_Measure_Code);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitOfMeasure', AdjustOption(2, FORMAT(UnitofMeasure."QFA Unit of measure code FACE")), '', XMLNode);
                        //XMLDOMManagement.AddElement(CurrentXMlNode,'UnitPriceWithoutTax',adjustdecimal(2,SalesCrMemoLine."Unit Price",0,'<Precision,6:6><Sign><Integer><Decimals>'),',','.'),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'UnitPriceWithoutTax', AdjustDecimal(6, QuoFacturae_CrMGroupedConcepts.Sum_Unit_Price), '', XMLNode);
                        //XMLDOMManagement.AddElement(CurrentXMlNode,'TotalCost',adjustdecimal(2,SalesCrMemoLine.Amount),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalCost', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.Sum_Amount), '', XMLNode);
                        //IF SalesCrMemoLine."Line Discount %" <> 0 THEN BEGIN
                        IF QuoFacturae_CrMGroupedConcepts.Line_Discount <> 0 THEN BEGIN
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountsAndRebates', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'Discount', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountReason', '', '', XMLNode);
                            //XMLDOMManagement.AddElement(CurrentXMlNode,'DiscountRate',adjustdecimal(2,SalesCrMemoLine."Line Discount %"),'',XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountRate', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.Line_Discount), '', XMLNode);
                            //XMLDOMManagement.AddElement(CurrentXMlNode,'DiscountAmount',adjustdecimal(2,SalesCrMemoLine."Line Discount Amount"),'',XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'DiscountAmount', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.Sum_Line_Discount_Amount), '', XMLNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        END;
                        //IF SalesCrMemoLine."EC %" <> 0 THEN BEGIN
                        IF QuoFacturae_CrMGroupedConcepts.EC <> 0 THEN BEGIN
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'Charges', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'Charge', '', '', CurrentXMlNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeReason', '', '', XMLNode);
                            //XMLDOMManagement.AddElement(CurrentXMlNode,'ChargeRate',adjustdecimal(2,SalesCrMemoLine."EC %"),'',XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeRate', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.EC), '', XMLNode);
                            //XMLDOMManagement.AddElement(CurrentXMlNode,'ChargeAmount',adjustdecimal(2,SalesCrMemoLine."VAT Base Amount"*SalesCrMemoLine."EC %"/100),'',XMLNode);
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'ChargeAmount', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.Sum_VAT_Base_Amount * QuoFacturae_CrMGroupedConcepts.EC / 100), '', XMLNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        END;
                        //        XMLDOMManagement.AddElement(CurrentXMlNode,'GrossAmount',adjustdecimal(2,SalesCrMemoLine.Amount-SalesCrMemoLine."Line Discount Amount"+
                        //                                                                        (SalesCrMemoLine."VAT Base Amount"*SalesCrMemoLine."EC %"/100)),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'GrossAmount', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.Sum_Amount - QuoFacturae_CrMGroupedConcepts.Sum_Line_Discount_Amount +
                                                                                        (QuoFacturae_CrMGroupedConcepts.Sum_VAT_Base_Amount * QuoFacturae_CrMGroupedConcepts.EC / 100)), '', XMLNode);


                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxesOutputs', '', '', CurrentXMlNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'Tax', '', '', CurrentXMlNode);
                        VATProductPostingGroup.RESET;
                        //IF VATProductPostingGroup.GET(SalesCrMemoLine."VAT Prod. Posting Group") THEN
                        IF VATProductPostingGroup.GET(QuoFacturae_CrMGroupedConcepts.VAT_Prod_Posting_Group) THEN
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', AdjustOption(2, FORMAT(VATProductPostingGroup."QFA Code Tax Type", 0)), '', XMLNode)
                        ELSE
                            XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxTypeCode', '05', '', XMLNode);//DUDA
                                                                                                          //XMLDOMManagement.AddElement(CurrentXMlNode,'TaxRate',adjustdecimal(2,SalesCrMemoLine."VAT %"),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxRate', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.VAT), '', XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TaxableBase', '', '', CurrentXMlNode);
                        //XMLDOMManagement.AddElement(CurrentXMlNode,'TotalAmount',adjustdecimal(2,SalesCrMemoLine."VAT Base Amount"),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'TotalAmount', AdjustDecimal(2, QuoFacturae_CrMGroupedConcepts.Sum_VAT_Base_Amount), '', XMLNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        //XMLDOMManagement.AddElement(CurrentXMlNode,'ArticleCode',FORMAT(SalesCrMemoLine."No."),'',XMLNode);
                        XMLDOMManagement.AddElement(CurrentXMlNode, 'ArticleCode', FORMAT(QuoFacturae_CrMGroupedConcepts.No), '', XMLNode);

                        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                        //UNTIL SalesCrMemoLine.NEXT = 0;
                    END;
                END;
        END;

        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreatePayments(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    BEGIN
        XMLDOMManagement.AddElement(CurrentXMlNode, 'PaymentsDetails', '', '', CurrentXMlNode);
        XMLDOMManagement.AddElement(CurrentXMlNode, 'Installment', '', '', CurrentXMlNode);
        XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE PersonaFisicaJuridica(VATRegistrationNo: Code[20]; VAR PersonaFisica: Boolean): Boolean;
    BEGIN
        IF NOT (COPYSTR(VATRegistrationNo, 1, 1) IN ['A', 'a', 'B', 'b', 'C', 'c', 'D', 'd', 'E', 'e', 'F', 'f',
                                                   'G', 'g', 'H', 'h', 'J', 'j', 'P', 'p', 'Q', 'q', 'R', 'r',
                                                   'S', 's', 'U', 'u', 'V', 'v', 'N', 'n', 'W', 'w'])
        THEN
            PersonaFisica := TRUE
        ELSE
            PersonaFisica := FALSE;
    END;

    LOCAL PROCEDURE GetAdministrativeCenter(QuoFacturaeAdminCenter: Record 7174370) CentreType: Code[10];
    BEGIN
        CASE QuoFacturaeAdminCenter.Type OF
            QuoFacturaeAdminCenter.Type::Fiscal:
                CentreType := '01';
            QuoFacturaeAdminCenter.Type::Receiver:
                CentreType := '02';
            QuoFacturaeAdminCenter.Type::Payer:
                CentreType := '03';
            QuoFacturaeAdminCenter.Type::Buyer:
                CentreType := '04';
            QuoFacturaeAdminCenter.Type::Collector:
                CentreType := '05';
            QuoFacturaeAdminCenter.Type::Seller:
                CentreType := '06';
            QuoFacturaeAdminCenter.Type::"Payment receiver":
                CentreType := '07';
            QuoFacturaeAdminCenter.Type::"Collection receiver":
                CentreType := '08';
            ELSE
                CentreType := '09';
        END;

        EXIT(CentreType);
    END;

    LOCAL PROCEDURE GetReasonCodeDesc(ReasonCode: Integer) ReasonDesc: Text;
    BEGIN
        CASE ReasonCode OF
            1:
                ReasonDesc := 'N�mero de la factura';
            2:
                ReasonDesc := 'Serie de la factura';
            3:
                ReasonDesc := 'Fecha Expedici�n';
            4:
                ReasonDesc := 'Nombre y apellidos/Raz�n social - Emisor';
            5:
                ReasonDesc := 'Nombre y apellidos/Raz�n social - Receptor';
            6:
                ReasonDesc := 'Identificaci�n fiscal Emisor/Obligado';
            7:
                ReasonDesc := 'Identificaci�n fiscal Receptor';
            8:
                ReasonDesc := 'Domicilio Emisor/Obligado';
            9:
                ReasonDesc := 'Domicilio Receptor';
            10:
                ReasonDesc := 'Detalle Operaci�n';
            11:
                ReasonDesc := 'Porcentaje impositivo a aplicar';
            12:
                ReasonDesc := 'Cuota tributaria a aplicar';
            13:
                ReasonDesc := 'Fecha/Periodo a aplicar';
            14:
                ReasonDesc := 'Clase de factura';
            15:
                ReasonDesc := 'Literales legales';
            16:
                ReasonDesc := 'Base imponible';
            80:
                ReasonDesc := 'C�lculo de cuotas repercutidas';
            81:
                ReasonDesc := 'C�lculo de cuotas retenidas';
            82:
                ReasonDesc := 'Base imponible modificada por devoluci�n de envases/embalajes';
            83:
                ReasonDesc := 'Base imponible modificada por descuentos y bonificaciones';
            84:
                ReasonDesc := 'Base imponible modificada por resoluci�n firme, judicial o administrativa';
            ELSE
                ReasonDesc := 'Base imponible modificada cuotas repercutidas no satisfechas. Auto de declaraci�n de concurso';
        END;

        EXIT(ReasonDesc);
    END;

    LOCAL PROCEDURE GetCorrectionMethodDesc(_MethodCode: Integer) MethodDesc: Text;
    BEGIN
        CASE _MethodCode OF
            1:
                MethodDesc := 'Rectificaci�n �ntegra';
            2:
                MethodDesc := 'Rectificaci�n por diferencias';
            3:
                MethodDesc := 'Rectificaci�n por descuento por volumen de operaciones durante un periodo'
            ELSE
                MethodDesc := 'Autorizadas por la Agencia Tributaria';
        END;
    END;

    LOCAL PROCEDURE CalcDiscounts();
    BEGIN
    END;

    LOCAL PROCEDURE CalcSurcharges();
    BEGIN
    END;

    LOCAL PROCEDURE CalcTotals(VAR CustLedgerEntry: Record 21; VAR TotalGeneralSurcharges: Decimal; VAR TotalTaxOutputs: Decimal; VAR TotalGrossAmount: Decimal);
    VAR
        i: Integer;
        found: Boolean;
        jvat: Integer;
        jec: Integer;
    BEGIN
        TotalTaxOutputs := 0;
        TotalGeneralSurcharges := 0;
        TotalGrossAmount := 0;
        jvat := 1;
        jec := 1;

        FOR i := 1 TO ARRAYLEN(ECAmount, 1) DO BEGIN
            ECAmount[1] [i] := 0;
            ECAmount[2] [i] := 0;
            VATAmounts[1] [i] := 0;
            VATAmounts[2] [i] := 0;
        END;

        TMPVATEntry.RESET;
        TMPVATEntry.SETRANGE("Document No.", CustLedgerEntry."Document No.");
        TMPVATEntry.SETRANGE("Posting Date", CustLedgerEntry."Posting Date");
        IF TMPVATEntry.FINDSET THEN
            REPEAT
                IF TMPVATEntry.Amount <> 0 THEN BEGIN
                    found := FALSE;
                    FOR i := 1 TO ARRAYLEN(VATAmounts, 1) DO BEGIN
                        IF VATAmounts[1] [i] = TMPVATEntry."VAT %" THEN BEGIN
                            IF TMPVATEntry."EC %" <> 0 THEN
                                VATAmounts[2] [i] += ((-TMPVATEntry.Amount) - (TMPVATEntry."EC %" * (-TMPVATEntry.Base) / 100))
                            ELSE
                                VATAmounts[2] [i] += (-TMPVATEntry.Amount);
                            found := TRUE;
                        END;
                    END;

                    IF NOT found THEN BEGIN
                        VATAmounts[1] [jvat] := TMPVATEntry."VAT %";
                        IF TMPVATEntry."EC %" <> 0 THEN
                            VATAmounts[2] [jvat] := ((-TMPVATEntry.Amount) - (TMPVATEntry."EC %" * (-TMPVATEntry.Base) / 100))
                        ELSE
                            VATAmounts[2] [jvat] := (-TMPVATEntry.Amount);
                        jvat += 1;
                    END;
                END;

                //QUONEXT PER 01.07.19 Se informa el iva no realizado.
                //TotalGrossAmount += -TMPVATEntry.Base  --> CODIGO ORIGINAL COMENTADO.
                IF TMPVATEntry.Base <> 0 THEN
                    TotalGrossAmount += -TMPVATEntry.Base
                ELSE
                    TotalGrossAmount += -TMPVATEntry."Unrealized Base";
                //FIN QUONEXT PER 01.07.19

                //QUONEXT PER 01.07.19 Se informa el iva no realizado.
                IF TMPVATEntry."Unrealized Amount" <> 0 THEN BEGIN
                    found := FALSE;
                    FOR i := 1 TO ARRAYLEN(VATAmounts, 1) DO BEGIN
                        IF VATAmounts[1] [i] = TMPVATEntry."VAT %" THEN BEGIN
                            IF TMPVATEntry."EC %" <> 0 THEN
                                VATAmounts[2] [i] += ((-TMPVATEntry."Unrealized Amount") - (TMPVATEntry."EC %" * (-TMPVATEntry."Unrealized Base") / 100))
                            ELSE
                                VATAmounts[2] [i] += (-TMPVATEntry."Unrealized Amount");
                            found := TRUE;
                        END;
                    END;

                    IF NOT found THEN BEGIN
                        VATAmounts[1] [jvat] := TMPVATEntry."VAT %";
                        IF TMPVATEntry."EC %" <> 0 THEN
                            VATAmounts[2] [jvat] := ((-TMPVATEntry."Unrealized Amount") - (TMPVATEntry."EC %" * (-TMPVATEntry."Unrealized Base") / 100))
                        ELSE
                            VATAmounts[2] [jvat] := (-TMPVATEntry."Unrealized Amount");
                        jvat += 1;
                    END;

                END;
                //fin QUONEXT PER 01.07.19 Se informa el iva no realizado.

                IF TMPVATEntry."EC %" <> 0 THEN BEGIN
                    found := FALSE;
                    FOR i := 1 TO ARRAYLEN(ECAmount, 1) DO BEGIN
                        IF ECAmount[1] [i] = TMPVATEntry."EC %" THEN BEGIN
                            ECAmount[2] [i] += ((-TMPVATEntry.Amount) - (TMPVATEntry."VAT %" * (-TMPVATEntry.Base) / 100));
                            found := TRUE;
                        END;
                    END;

                    IF NOT found THEN BEGIN
                        ECAmount[1] [jec] := TMPVATEntry."EC %";
                        ECAmount[2] [jec] := ((-TMPVATEntry.Amount) - (TMPVATEntry."VAT %" * (-TMPVATEntry.Base) / 100));
                        jec += 1;
                    END;
                END;
            UNTIL TMPVATEntry.NEXT = 0;

        FOR i := 1 TO ARRAYLEN(ECAmount, 1) DO BEGIN
            IF ECAmount[1] [i] <> 0 THEN
                TotalGeneralSurcharges += ECAmount[2] [i];
        END;

        FOR i := 1 TO ARRAYLEN(VATAmounts, 1) DO BEGIN
            IF VATAmounts[1] [i] <> 0 THEN
                TotalTaxOutputs += VATAmounts[2] [i];
        END;
    END;

    LOCAL PROCEDURE CreateXMLFile(RootXMLNode: DotNet XmlNode);
    VAR
        os: OutStream;
        tempBLOB: codeunit "Temp Blob";
        txt: Text;
        btxt: BigText;
        is: InStream;
        i: Integer;
        j: Integer;
        xmlFile: File;
        ToFile: Text;
    BEGIN
        tempBLOB.CreateOutStream(os, TextEncoding::Windows);
        XMLDOMManagement.SaveXMLDocumentToOutStream(os, RootXMLNode);

        ToFile := FORMAT(CURRENTDATETIME, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>') + '.xml';
        txt := TEMPORARYPATH + '\' + ToFile;

        IF NOT EXISTS(txt) then begin
            //tempBLOB.Blob.EXPORT(txt)
            TempBlob.CreateInStream(is, TextEncoding::Windows);
            is.Read(txt);
            DownloadFromStream(is, 'Download file', 'C:\TMP\FACE', 'XML file(*.xml)|*.xml', ToFile);
        end
        ELSE BEGIN
            ERASE(txt);
            //tempBLOB.Blob.EXPORT(txt);
            TempBlob.CreateInStream(is, TextEncoding::Windows);
            is.Read(txt);
            DownloadFromStream(is, 'Download file', 'C:\TMP\FACE', 'XML file(*.xml)|*.xml', ToFile);
        END;

        //DOWNLOAD(txt, 'Download file', 'C:\TMP\FACE', 'XML file(*.xml)|*.xml', ToFile);

        MESSAGE('Fichero exportado.');
    END;

    LOCAL PROCEDURE CreateOnMemoryXML(RootXMLNode: DotNet XmlNode);
    VAR
        os: OutStream;
        tempBLOB: Codeunit "Temp Blob";
        txt: Text;
        btxt: BigText;
        is: InStream;
        i: Integer;
        j: Integer;
    BEGIN
        tempBLOB.CreateOutStream(os, TextEncoding::Windows);
        XMLDOMManagement.SaveXMLDocumentToOutStream(os, RootXMLNode);
        tempBLOB.CreateInStream(is, TextEncoding::Windows);

        is.READ(btxt);


        i := 1;
        j := 1;
        IF btxt.LENGTH > 100 THEN
            REPEAT
                j := 100;
                IF j > btxt.LENGTH THEN
                    j := btxt.LENGTH;

                btxt.GETSUBTEXT(txt, i, j);
                i := i + j;
            UNTIL i >= btxt.LENGTH
        ELSE
            btxt.GETSUBTEXT(txt, 1, btxt.LENGTH);
    END;

    LOCAL PROCEDURE CalcVATEntries(VAR CustLedgerEntry: Record 21);
    VAR
        VATEntry: Record 254;
        SumTotalGeneralSurcharges: Decimal;
        SumTotalTaxOutputs: Decimal;
        SumTotalGrossAmount: Decimal;
    BEGIN
        TotalInvoicesAmount := 0;
        TotalOutstandingAmount := 0;
        TotalExecutableAmount := 0;

        TMPVATEntry.DELETEALL;

        //CustLedgerEntry.FINDSET;
        //REPEAT
        SumTotalGeneralSurcharges := 0;
        SumTotalTaxOutputs := 0;
        SumTotalGrossAmount := 0;

        VATEntry.RESET;
        VATEntry.SETRANGE("Document No.", CustLedgerEntry."Document No.");
        VATEntry.SETRANGE("Posting Date", CustLedgerEntry."Posting Date");
        IF VATEntry.FINDSET THEN
            REPEAT
                CLEAR(TMPVATEntry);
                TMPVATEntry.RESET;
                TMPVATEntry.INIT;
                TMPVATEntry.COPY(VATEntry);
                TMPVATEntry.INSERT;
            UNTIL VATEntry.NEXT = 0;

        CalcTotals(CustLedgerEntry, TotalGeneralSurcharges, TotalTaxOutputs, TotalGrossAmount);

        SumTotalGeneralSurcharges += TotalGeneralSurcharges;
        SumTotalTaxOutputs += TotalTaxOutputs;
        SumTotalGrossAmount += TotalGrossAmount;

        //QUONEXT PER 29.04.19 No tiene en cuenta los importes base no realizados, se recoge la informaci�n del mov. cliente
        /*{TotalInvoicesAmount += SumTotalGrossAmount-CustLedgerEntry."Inv. Discount (LCY)"+SumTotalGeneralSurcharges+SumTotalTaxOutputs;
                TotalOutstandingAmount += SumTotalGrossAmount-CustLedgerEntry."Inv. Discount (LCY)"+SumTotalGeneralSurcharges+SumTotalTaxOutputs;
                TotalExecutableAmount  += SumTotalGrossAmount-CustLedgerEntry."Inv. Discount (LCY)"+SumTotalGeneralSurcharges+SumTotalTaxOutputs;}*/
        TotalInvoicesAmount += CustLedgerEntry."Amount (LCY) stats." - CustLedgerEntry."Inv. Discount (LCY)";
        TotalOutstandingAmount += CustLedgerEntry."Amount (LCY) stats." - CustLedgerEntry."Inv. Discount (LCY)";
        TotalExecutableAmount += CustLedgerEntry."Amount (LCY) stats." - CustLedgerEntry."Inv. Discount (LCY)";
        ///FIN QUONEXT PER 29.04.19
      //UNTIL CustLedgerEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateInvoicePaymentDetails(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        CustLedgerEntryDue: Record 21;
        PaymentMethod: Record 289;
        SalesInvoiceHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        BankAccount: Record 270;
        IBAN: Text;
        GenHeader: Boolean;
    BEGIN
        //JAV 25/03/21: - 1.3h Informaci�n de pagos

        IBAN := '';
        IF (CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice) THEN BEGIN
            IF (SalesInvoiceHeader.GET(CustLedgerEntry."Document No.")) THEN
                IF (BankAccount.GET(SalesInvoiceHeader."Payment bank No.")) THEN
                    IBAN := BankAccount.IBAN;
        END;

        CustLedgerEntryDue.RESET;
        CustLedgerEntryDue.SETRANGE("Customer No.", CustLedgerEntry."Customer No.");
        CustLedgerEntryDue.SETRANGE("Document No.", CustLedgerEntry."Document No.");
        CustLedgerEntryDue.SETRANGE("Document Type", CustLedgerEntryDue."Document Type"::Bill);
        //Si no es un efecto, busco la factura
        IF (CustLedgerEntryDue.ISEMPTY) THEN
            CustLedgerEntryDue.SETRANGE("Document Type", CustLedgerEntryDue."Document Type"::Invoice);

        IF (CustLedgerEntryDue.FINDSET) THEN BEGIN
            REPEAT
                PaymentMethod.GET(CustLedgerEntryDue."Payment Method Code");
                CustLedgerEntryDue.CALCFIELDS("Original Amt. (LCY)");

                IF (NOT GenHeader) THEN BEGIN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'PaymentDetails', '', '', CurrentXMlNode);
                    GenHeader := TRUE;
                END;

                XMLDOMManagement.AddElement(CurrentXMlNode, 'Installment', '', '', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'InstallmentDueDate', AdjustDate(CustLedgerEntryDue."Due Date"), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'InstallmentAmount', AdjustDecimal(2, CustLedgerEntryDue."Original Amt. (LCY)"), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'PaymentMeans', AdjustOption(2, FORMAT(PaymentMethod."QFA Payment Means Type", 0)), '', XMLNode);
                IF (IBAN <> '') THEN BEGIN
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'AccountToBeCredited', '', '', CurrentXMlNode);
                    XMLDOMManagement.AddElement(CurrentXMlNode, 'IBAN', IBAN, '', XMLNode);
                    XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
                END;
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            UNTIL (CustLedgerEntryDue.NEXT = 0);
        END ELSE BEGIN

        END;

        IF (GenHeader) THEN
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE CreateInvoiceAdditionalInformation(VAR CustLedgerEntry: Record 21; VAR XMLDoc: DotNet XmlDocument; VAR XMLNode: DotNet XmlNode; VAR RootXMLNode: DotNet XmlNode; VAR CurrentXMlNode: DotNet XmlNode);
    VAR
        SalesInvoiceHeader: Record 112;
        TempBlob: Codeunit "Temp Blob";
        DocumentAttachment: Record 1173;
        QuoFacturaeSetup: Record 7174368;
        WorkDescription: Text;
        Text64: Text;
        CR: Text;
        HeaderSet: Boolean;
    BEGIN
        //JAV 21/03/21: - Informaci�n adicional al documento: descripci�n del trabajo y documentos adjuntos

        HeaderSet := FALSE;

        //JAV 21/03/21: - A�adir documentos adjuntos
        DocumentAttachment.RESET;
        DocumentAttachment.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
        DocumentAttachment.SETRANGE("No.", CustLedgerEntry."Document No.");
        DocumentAttachment.SETRANGE("QFA Send", TRUE);  //QFA 1.3i
        IF (DocumentAttachment.FINDSET) THEN BEGIN
            IF (NOT HeaderSet) THEN BEGIN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AdditionalData', '', '', CurrentXMlNode);
                HeaderSet := TRUE;
            END;

            XMLDOMManagement.AddElement(CurrentXMlNode, 'RelatedDocuments', '', '', CurrentXMlNode);
            REPEAT
                Text64 := GetFile(DocumentAttachment);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'Attachment', '', '', CurrentXMlNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AttachmentCompressionAlgorithm', 'NONE', '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AttachmentFormat', LOWERCASE(DocumentAttachment."File Extension"), '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AttachmentEncoding', 'BASE64', '', XMLNode);
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AttachmentData', Text64, '', XMLNode);
                XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
            UNTIL (DocumentAttachment.NEXT = 0);
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
        END;

        //JAV 20/03/21: - A�adir l�nea de descripci�n del trabajo si lo tiene informado y es una factura no agrupada
        QuoFacturaeSetup.GET;
        WorkDescription := GetWorkDescription(CustLedgerEntry);
        IF (WorkDescription <> '') AND (QuoFacturaeSetup."Generate Grouped" = FALSE) AND (NOT QuoFacturaeSetup."WorkDescription in Lines") THEN BEGIN
            IF (NOT HeaderSet) THEN BEGIN
                XMLDOMManagement.AddElement(CurrentXMlNode, 'AdditionalData', '', '', CurrentXMlNode);
                HeaderSet := TRUE;
            END;
            XMLDOMManagement.AddElement(CurrentXMlNode, 'InvoiceAdditionalInformation', WorkDescription, '', XMLNode);
        END;

        IF (HeaderSet) THEN
            XMLDOMManagement.FindNode(CurrentXMlNode, '..', CurrentXMlNode);
    END;

    LOCAL PROCEDURE GetFile(DocumentAttachment: Record 1173): Text;
    VAR
        DocumentStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FullFileName: Text;
        FileManagement: Codeunit 419;
        FileManagement1: Codeunit 50372;
        Text64: Text;
        ServerFileName: Text;
        Base64Convert: Codeunit "Base64 Convert";
        InStr:InStream;
        
    BEGIN
        //JAV 21/03/21: - Leer el fichero adjunto y retornarlo como texto en Base64

        IF (DocumentAttachment."File Name" = '') OR (DocumentAttachment.ID = 0) OR (NOT DocumentAttachment."Document Reference ID".HASVALUE) THEN
            EXIT('');

        FullFileName := DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension";   //Nombre guardado
        TempBlob.CreateOutStream(DocumentStream, TextEncoding::Windows);                   //Crear OutStream
        DocumentAttachment."Document Reference ID".EXPORTSTREAM(DocumentStream);                      //Asociar OutStream al documento
        FullFileName := FileManagement.BLOBExport(TempBlob, FullFileName, FALSE);                       //Crear el fichero temporal
        ServerFileName := FileManagement1.UploadFileSilent(FullFileName);                              //Descargar el fichero
        FileManagement.BLOBImportFromServerFile(TempBlob, ServerFileName);                            //Cargar el fichero temporal en el Blob
        //Text64 := TempBlob.ToBase64String();                                                            //Extrar el texto en Base-64
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(Text64);
        Text64 := Base64Convert.ToBase64(Text64); 
        EXIT(Text64);
    END;

    LOCAL PROCEDURE GetWorkDescription(CustLedgerEntry: Record 21): Text;
    VAR
        SalesInvoiceHeader: Record 112;
        TempBlob: codeunit "Temp Blob";
        CR: Text;
        InStr: InStream;
        Blob: OutStream;
    BEGIN
        //JAV 21/03/21: - Retorna la descripci�n del trabajo en un texto

        SalesInvoiceHeader.GET(CustLedgerEntry."Document No.");
        SalesInvoiceHeader.CALCFIELDS("Work Description");
        //TempBlob.Blob := SalesInvoiceHeader."Work Description";\
        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(SalesInvoiceHeader."Work Description");
        CR[1] := 10;
        //EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::Windows));
        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    END;

    LOCAL PROCEDURE AdjustOption(pLon: Integer; pCode: Text): Text;
    BEGIN
        IF (DELCHR(pCode, '<>', ' ') = '') THEN
            pCode := '01';
        EXIT(COPYSTR(pCode, 1, pLon));
    END;

    LOCAL PROCEDURE AdjustDate(pDate: Date): Text;
    BEGIN
        EXIT(FORMAT(pDate, 0, '<Year4>-<Month,2>-<Day,2>'));
    END;

    LOCAL PROCEDURE AdjustDecimal(pDecimals: Integer; pAmount: Decimal): Text;
    BEGIN
        EXIT(CONVERTSTR(FORMAT(pAmount, 0, '<Precision,' + FORMAT(pDecimals) + ': Option "+ FORMAT(pDecimals) +"><Sign><Integer><Decimals>'), ',', '.'));
    END;


    /*BEGIN
    /*{
          QFA 0.2 08/11/18 - Agrupamos conceptos, no usamos un concepto por l�nea.
          Q5621 17/12/18 JALA - S�lo agrupamos en una l�nea en el caso de que la "descripci�n del trabajo" est� rellena.
          QUONEXT PER 29.04.19 No tiene en cuenta los importes base no realizados, se recoge la informaci�n del mov. cliente
        }
    END.*/
}









