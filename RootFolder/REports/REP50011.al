// report 50011 "Roig - Sales - Invoice"
// {


//     Permissions = TableData 7190 = rimd;
//     CaptionML = ENU = 'Sales - Invoice', ESP = 'Ventas - Factura';
//     EnableHyperlinks = true;
//     PreviewMode = PrintLayout;

//     dataset
//     {

//         DataItem("Doc_Cabecera"; "Sales Invoice Header")
//         {

//             DataItemTableView = SORTING("No.");
//             RequestFilterHeadingML = ENU = 'Posted Sales Invoice', ESP = 'Hist¢rico facturas venta';


//             RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
//             Column(No_SalesInvHdr; "No.")
//             {
//                 //SourceExpr="No.";
//             }
//             Column(PaymentTermsDescription; PaymentTerms.Description)
//             {
//                 //SourceExpr=PaymentTerms.Description;
//             }
//             Column(ShipmentMethodDescription; ShipmentMethod.Description)
//             {
//                 //SourceExpr=ShipmentMethod.Description;
//             }
//             Column(PaymentMethodDescription; PaymentMethod.Description)
//             {
//                 //SourceExpr=PaymentMethod.Description;
//             }
//             Column(PaymentTransfer; (PaymentMethod."Bill Type" = PaymentMethod."Bill Type"::Transfer))
//             {
//                 //SourceExpr=(PaymentMethod."Bill Type" = PaymentMethod."Bill Type"::Transfer);
//             }
//             Column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
//             {
//                 //SourceExpr=PmtTermsDescCaptionLbl;
//             }
//             Column(ShpMethodDescCaption; ShpMethodDescCaptionLbl)
//             {
//                 //SourceExpr=ShpMethodDescCaptionLbl;
//             }
//             Column(PmtMethodDescCaption; PmtMethodDescCaptionLbl)
//             {
//                 //SourceExpr=PmtMethodDescCaptionLbl;
//             }
//             Column(DocDateCaption; DocDateCaptionLbl)
//             {
//                 //SourceExpr=DocDateCaptionLbl;
//             }
//             Column(HomePageCaption; HomePageCaptionLbl)
//             {
//                 //SourceExpr=HomePageCaptionLbl;
//             }
//             Column(EmailCaption; EmailCaptionLbl)
//             {
//                 //SourceExpr=EmailCaptionLbl;
//             }
//             Column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
//             {
//                 //SourceExpr=DisplayAdditionalFeeNote;
//             }
//             Column(CM; (CertOrigen = 0))
//             {
//                 //SourceExpr=(CertOrigen = 0);
//             }
//             Column(CM_Origen; CertOrigen)
//             {
//                 //SourceExpr=CertOrigen;
//             }
//             Column(CM_Anterior; CertAnterior)
//             {
//                 //SourceExpr=CertAnterior;
//             }
//             Column(CM_Actual; CertActual)
//             {
//                 //SourceExpr=CertActual;
//             }
//             Column(TieneIRPF; (Doc_Cabecera."QW Cod. Withholding by PIT" <> ''))
//             {
//                 //SourceExpr=(Doc_Cabecera."QW Cod. Withholding by PIT" <> '');
//             }
//             Column(TotFactura; TotFactura)
//             {
//                 //SourceExpr=TotFactura;
//             }
//             Column(RetPago; RetPago)
//             {
//                 //SourceExpr=RetPago;
//             }
//             Column(TotPagar; TotPagar)
//             {
//                 //SourceExpr=TotPagar;
//             }
//             Column(PGG; Totales[14])
//             {
//                 //SourceExpr=Totales[14];
//             }
//             Column(PBI; Totales[15])
//             {
//                 //SourceExpr=Totales[15];
//             }
//             Column(PBaja; Totales[16])
//             {
//                 //SourceExpr=Totales[16];
//             }
//             Column(PIVA; Totales[17])
//             {
//                 //SourceExpr=Totales[17];
//             }
//             Column(PRF; Totales[18])
//             {
//                 //SourceExpr=Totales[18];
//             }
//             Column(PRP; Totales[19])
//             {
//                 //SourceExpr=Totales[19];
//             }
//             Column(T01; Totales[1])
//             {
//                 //SourceExpr=Totales[1];
//             }
//             Column(T02; Totales[2])
//             {
//                 //SourceExpr=Totales[2];
//             }
//             Column(T03; Totales[3])
//             {
//                 //SourceExpr=Totales[3];
//             }
//             Column(T04; Totales[4])
//             {
//                 //SourceExpr=Totales[4];
//             }
//             Column(T05; Totales[5])
//             {
//                 //SourceExpr=Totales[5];
//             }
//             Column(T06; Totales[6])
//             {
//                 //SourceExpr=Totales[6];
//             }
//             Column(T07; Totales[7])
//             {
//                 //SourceExpr=Totales[7];
//             }
//             Column(T08; Totales[8])
//             {
//                 //SourceExpr=Totales[8];
//             }
//             Column(T09; Totales[9])
//             {
//                 //SourceExpr=Totales[9];
//             }
//             Column(T10; Totales[10])
//             {
//                 //SourceExpr=Totales[10];
//             }
//             Column(T11; Totales[11])
//             {
//                 //SourceExpr=Totales[11];
//             }
//             Column(T12; Totales[12])
//             {
//                 //SourceExpr=Totales[12];
//             }
//             Column(T13; Totales[13])
//             {
//                 //SourceExpr=Totales[13];
//             }
//             DataItem("CopyLoop"; "2000000026")
//             {

//                 DataItemTableView = SORTING("Number");
//                 ;
//                 DataItem("PageLoop"; "2000000026")
//                 {

//                     DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = CONST(1));
//                     Column(CompanyInfoPicture; CompanyInfo.Picture)
//                     {
//                         //SourceExpr=CompanyInfo.Picture;
//                     }
//                     Column(DocumentCaptionCopyText; STRSUBSTNO(DocumentCaption, CopyText))
//                     {
//                         //SourceExpr=STRSUBSTNO(DocumentCaption,CopyText);
//                     }
//                     Column(CompanyAddr1; CompanyAddr[1])
//                     {
//                         //SourceExpr=CompanyAddr[1];
//                     }
//                     Column(CompanyAddr2; CompanyAddr[2])
//                     {
//                         //SourceExpr=CompanyAddr[2];
//                     }
//                     Column(CompanyAddr3; CompanyAddr[3])
//                     {
//                         //SourceExpr=CompanyAddr[3];
//                     }
//                     Column(CompanyAddr4; CompanyAddr[4])
//                     {
//                         //SourceExpr=CompanyAddr[4];
//                     }
//                     Column(CompanyAddr5; CompanyAddr[5])
//                     {
//                         //SourceExpr=CompanyAddr[5];
//                     }
//                     Column(CompanyAddr6; CompanyAddr[6])
//                     {
//                         //SourceExpr=CompanyAddr[6];
//                     }
//                     Column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
//                     {
//                         //SourceExpr=CompanyInfo."Phone No.";
//                     }
//                     Column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
//                     {
//                         //SourceExpr=CompanyInfo."VAT Registration No.";
//                     }
//                     Column(CompanyInfoHomePage; CompanyInfo."Home Page")
//                     {
//                         //SourceExpr=CompanyInfo."Home Page";
//                     }
//                     Column(CompanyInfoEmail; CompanyInfo."E-Mail")
//                     {
//                         //SourceExpr=CompanyInfo."E-Mail";
//                     }
//                     Column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
//                     {
//                         //SourceExpr=CompanyInfo."Giro No.";
//                     }
//                     Column(BankName; BankName)
//                     {
//                         //SourceExpr=BankName;
//                     }
//                     Column(BankAccountNo; BankIBAN)
//                     {
//                         //SourceExpr=BankIBAN;
//                     }
//                     Column(CompanyInforRegMer; QuoBuildingSetup."Commercial Register")
//                     {
//                         //SourceExpr=QuoBuildingSetup."Commercial Register";
//                     }
//                     Column(CompanyInfoLogoPie; QuoBuildingSetup.Logo1)
//                     {
//                         //SourceExpr=QuoBuildingSetup.Logo1;
//                     }
//                     Column(TxtPie; TxtPie)
//                     {
//                         //SourceExpr=TxtPie;
//                     }
//                     Column(CustAddr1; CustAddr[1])
//                     {
//                         //SourceExpr=CustAddr[1];
//                     }
//                     Column(CustAddr2; CustAddr[2])
//                     {
//                         //SourceExpr=CustAddr[2];
//                     }
//                     Column(CustAddr3; CustAddr[3])
//                     {
//                         //SourceExpr=CustAddr[3];
//                     }
//                     Column(CustAddr4; CustAddr[4])
//                     {
//                         //SourceExpr=CustAddr[4];
//                     }
//                     Column(CustAddr5; CustAddr[5])
//                     {
//                         //SourceExpr=CustAddr[5];
//                     }
//                     Column(CustAddr6; CustAddr[6])
//                     {
//                         //SourceExpr=CustAddr[6];
//                     }
//                     Column(CustAddr7; CustAddr[7])
//                     {
//                         //SourceExpr=CustAddr[7];
//                     }
//                     Column(CustAddr8; CustAddr[8])
//                     {
//                         //SourceExpr=CustAddr[8];
//                     }
//                     Column(No_SalesInvoiceHeader1; Doc_Cabecera."No.")
//                     {
//                         //SourceExpr=Doc_Cabecera."No.";
//                     }
//                     Column(BilltoCustNo_SalesInvHdr; Doc_Cabecera."Bill-to Customer No.")
//                     {
//                         //SourceExpr=Doc_Cabecera."Bill-to Customer No.";
//                     }
//                     Column(PostingDate_SalesInvHdr; Doc_Cabecera."Posting Date")
//                     {
//                         //SourceExpr=Doc_Cabecera."Posting Date";
//                     }
//                     Column(VATRegNo_SalesInvHeader; Doc_Cabecera."VAT Registration No.")
//                     {
//                         //SourceExpr=Doc_Cabecera."VAT Registration No.";
//                     }
//                     Column(DueDate_SalesInvHeader; FORMAT(Doc_Cabecera."Due Date"))
//                     {
//                         //SourceExpr=FORMAT(Doc_Cabecera."Due Date");
//                     }
//                     Column(Witholding_HasDueDate; (WitholdingDueDate <> 0D))
//                     {
//                         //SourceExpr=(WitholdingDueDate <> 0D);
//                     }
//                     Column(Witholding_DueDate; FORMAT(WitholdingDueDate))
//                     {
//                         //SourceExpr=FORMAT(WitholdingDueDate);
//                     }
//                     Column(YourReference_SalesInvHdr; Doc_Cabecera."Your Reference")
//                     {
//                         //SourceExpr=Doc_Cabecera."Your Reference";
//                     }
//                     Column(OrderNo_SalesInvHeader; Doc_Cabecera."Order No.")
//                     {
//                         //SourceExpr=Doc_Cabecera."Order No.";
//                     }
//                     Column(DocDate_SalesInvoiceHdr; Doc_Cabecera."Document Date")
//                     {
//                         //SourceExpr=Doc_Cabecera."Document Date";
//                     }
//                     Column(PricesInclVAT_SalesInvHdr; Doc_Cabecera."Prices Including VAT")
//                     {
//                         //SourceExpr=Doc_Cabecera."Prices Including VAT";
//                     }
//                     Column(PricesInclVATYesNo; FORMAT(Doc_Cabecera."Prices Including VAT"))
//                     {
//                         //SourceExpr=FORMAT(Doc_Cabecera."Prices Including VAT");
//                     }
//                     Column(VATNoText; VATNoText)
//                     {
//                         //SourceExpr=VATNoText;
//                     }
//                     Column(SalesPersonText; SalesPersonText)
//                     {
//                         //SourceExpr=SalesPersonText;
//                     }
//                     Column(SalesPurchPersonName; SalesPurchPerson.Name)
//                     {
//                         //SourceExpr=SalesPurchPerson.Name;
//                     }
//                     Column(ReferenceText; ReferenceText)
//                     {
//                         //SourceExpr=ReferenceText;
//                     }
//                     Column(OrderNoText; OrderNoText)
//                     {
//                         //SourceExpr=OrderNoText;
//                     }
//                     Column(OutputNo; OutputNo)
//                     {
//                         //SourceExpr=OutputNo;
//                     }
//                     Column(PageCaption; PageCaptionCap)
//                     {
//                         //SourceExpr=PageCaptionCap;
//                     }
//                     Column(PhoneNoCaption; PhoneNoCaptionLbl)
//                     {
//                         //SourceExpr=PhoneNoCaptionLbl;
//                     }
//                     Column(VATRegNoCaption; VATRegNoCaptionLbl)
//                     {
//                         //SourceExpr=VATRegNoCaptionLbl;
//                     }
//                     Column(GiroNoCaption; GiroNoCaptionLbl)
//                     {
//                         //SourceExpr=GiroNoCaptionLbl;
//                     }
//                     Column(BankNameCaption; BankNameCaptionLbl)
//                     {
//                         //SourceExpr=BankNameCaptionLbl;
//                     }
//                     Column(BankAccNoCaption; BankAccNoCaptionLbl)
//                     {
//                         //SourceExpr=BankAccNoCaptionLbl;
//                     }
//                     Column(DueDateCaption; DueDateCaptionLbl)
//                     {
//                         //SourceExpr=DueDateCaptionLbl;
//                     }
//                     Column(InvoiceNoCaption; InvoiceNoCaptionLbl)
//                     {
//                         //SourceExpr=InvoiceNoCaptionLbl;
//                     }
//                     Column(PostingDateCaption; PostingDateCaptionLbl)
//                     {
//                         //SourceExpr=PostingDateCaptionLbl;
//                     }
//                     Column(BilltoCustNo_SalesInvHdrCaption; Doc_Cabecera.FIELDCAPTION("Bill-to Customer No."))
//                     {
//                         //SourceExpr=Doc_Cabecera.FIELDCAPTION("Bill-to Customer No.");
//                     }
//                     Column(PricesInclVAT_SalesInvHdrCaption; Doc_Cabecera.FIELDCAPTION("Prices Including VAT"))
//                     {
//                         //SourceExpr=Doc_Cabecera.FIELDCAPTION("Prices Including VAT");
//                     }
//                     Column(CACCaption; CACCaptionLbl)
//                     {
//                         //SourceExpr=CACCaptionLbl;
//                     }
//                     Column(JobNo; JobNo)
//                     {
//                         //SourceExpr=JobNo;
//                     }
//                     DataItem("Doc_Lineas"; "Sales Invoice Line")
//                     {

//                         DataItemTableView = SORTING("Document No.", "Line No.");


//                         DataItemLinkReference = "Doc_Cabecera";
//                         DataItemLink = "Document No." = FIELD("No.");
//                         Column(GetCarteraInvoice; GetCarteraInvoice)
//                         {
//                             //SourceExpr=GetCarteraInvoice;
//                         }
//                         Column(LineAmt_SalesInvoiceLine; "Line Amount")
//                         {
//                             //SourceExpr="Line Amount";
//                             AutoFormatType = 1;
//                             AutoFormatExpression = GetCurrencyCode;
//                         }
//                         Column(Description_SalesInvLine; Description)
//                         {
//                             //SourceExpr=Description;
//                         }
//                         Column(No_SalesInvoiceLine; "No.")
//                         {
//                             //SourceExpr="No.";
//                         }
//                         Column(Quantity_SalesInvoiceLine; Quantity)
//                         {
//                             //SourceExpr=Quantity;
//                         }
//                         Column(UOM_SalesInvoiceLine; "Unit of Measure")
//                         {
//                             //SourceExpr="Unit of Measure";
//                         }
//                         Column(UnitPrice_SalesInvLine; "Unit Price")
//                         {
//                             //SourceExpr="Unit Price";
//                             AutoFormatType = 2;
//                             AutoFormatExpression = GetCurrencyCode;
//                         }
//                         Column(LineDisc_SalesInvoiceLine; "Line Discount %")
//                         {
//                             //SourceExpr="Line Discount %";
//                         }
//                         Column(VATIdent_SalesInvLine; "VAT Identifier")
//                         {
//                             //SourceExpr="VAT Identifier";
//                         }
//                         Column(VATPorc_SalesInvLine; Doc_Lineas."VAT %")
//                         {
//                             //SourceExpr=Doc_Lineas."VAT %";
//                         }
//                         Column(PostedShipmentDate; FORMAT("Shipment Date"))
//                         {
//                             //SourceExpr=FORMAT("Shipment Date");
//                         }
//                         Column(Type_SalesInvoiceLine; FORMAT(Type))
//                         {
//                             //SourceExpr=FORMAT(Type);
//                         }
//                         Column(InvDiscountAmount; -"Inv. Discount Amount")
//                         {
//                             //SourceExpr=-"Inv. Discount Amount";
//                             AutoFormatType = 1;
//                             AutoFormatExpression = GetCurrencyCode;
//                         }
//                         Column(TotalSubTotal; TotalSubTotal)
//                         {
//                             //SourceExpr=TotalSubTotal;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = Doc_Cabecera."Currency Code";
//                         }
//                         Column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
//                         {
//                             //SourceExpr=TotalInvoiceDiscountAmount;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = Doc_Cabecera."Currency Code";
//                         }
//                         Column(TotalAmount; TotalAmount)
//                         {
//                             //SourceExpr=TotalAmount;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = Doc_Cabecera."Currency Code";
//                         }
//                         Column(TotalGivenAmount; TotalGivenAmount)
//                         {
//                             //SourceExpr=TotalGivenAmount;
//                         }
//                         Column(SalesInvoiceLineAmount; Amount)
//                         {
//                             //SourceExpr=Amount;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = Doc_Lineas.GetCurrencyCode;
//                         }
//                         Column(AmountIncludingVATAmount; "Amount Including VAT" - Amount)
//                         {
//                             //SourceExpr="Amount Including VAT" - Amount;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = GetCurrencyCode;
//                         }
//                         Column(Amount_SalesInvoiceLineIncludingVAT; "Amount Including VAT")
//                         {
//                             //SourceExpr="Amount Including VAT";
//                             AutoFormatType = 1;
//                             AutoFormatExpression = GetCurrencyCode;
//                         }
//                         Column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
//                         {
//                             //SourceExpr=VATAmountLine.VATAmountText;
//                         }
//                         Column(TotalExclVATText; TotalExclVATText)
//                         {
//                             //SourceExpr=TotalExclVATText;
//                         }
//                         Column(TotalInclVATText; TotalInclVATText)
//                         {
//                             //SourceExpr=TotalInclVATText;
//                         }
//                         Column(TotalAmountInclVAT; TotalAmountInclVAT)
//                         {
//                             //SourceExpr=TotalAmountInclVAT;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = Doc_Cabecera."Currency Code";
//                         }
//                         Column(TotalAmountVAT; TotalAmountVAT)
//                         {
//                             //SourceExpr=TotalAmountVAT;
//                             AutoFormatType = 1;
//                             AutoFormatExpression = Doc_Cabecera."Currency Code";
//                         }
//                         Column(VATBaseDisc_SalesInvHdr; Doc_Cabecera."VAT Base Discount %")
//                         {
//                             //SourceExpr=Doc_Cabecera."VAT Base Discount %";
//                             AutoFormatType = 1;
//                         }
//                         Column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
//                         {
//                             //SourceExpr=TotalPaymentDiscountOnVAT;
//                             AutoFormatType = 1;
//                         }
//                         Column(VATAmtLineVATCalcType; VATAmountLine."VAT Calculation Type")
//                         {
//                             //SourceExpr=VATAmountLine."VAT Calculation Type";
//                         }
//                         Column(LineNo_SalesInvoiceLine; "Line No.")
//                         {
//                             //SourceExpr="Line No.";
//                         }
//                         Column(PmtinvfromdebtpaidtoFactCompCaption; PmtinvfromdebtpaidtoFactCompCaptionLbl)
//                         {
//                             //SourceExpr=PmtinvfromdebtpaidtoFactCompCaptionLbl;
//                         }
//                         Column(UnitPriceCaption; UnitPriceCaptionLbl)
//                         {
//                             //SourceExpr=UnitPriceCaptionLbl;
//                         }
//                         Column(DiscountCaption; DiscountCaptionLbl)
//                         {
//                             //SourceExpr=DiscountCaptionLbl;
//                         }
//                         Column(AmtCaption; AmtCaptionLbl)
//                         {
//                             //SourceExpr=AmtCaptionLbl;
//                         }
//                         Column(PostedShpDateCaption; PostedShpDateCaptionLbl)
//                         {
//                             //SourceExpr=PostedShpDateCaptionLbl;
//                         }
//                         Column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
//                         {
//                             //SourceExpr=InvDiscAmtCaptionLbl;
//                         }
//                         Column(SubtotalCaption; SubtotalCaptionLbl)
//                         {
//                             //SourceExpr=SubtotalCaptionLbl;
//                         }
//                         Column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
//                         {
//                             //SourceExpr=PmtDiscGivenAmtCaptionLbl;
//                         }
//                         Column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
//                         {
//                             //SourceExpr=PmtDiscVATCaptionLbl;
//                         }
//                         Column(Description_SalesInvLineCaption; FIELDCAPTION(Description))
//                         {
//                             //SourceExpr=FIELDCAPTION(Description);
//                         }
//                         Column(No_SalesInvoiceLineCaption; FIELDCAPTION("No."))
//                         {
//                             //SourceExpr=FIELDCAPTION("No.");
//                         }
//                         Column(Quantity_SalesInvoiceLineCaption; FIELDCAPTION(Quantity))
//                         {
//                             //SourceExpr=FIELDCAPTION(Quantity);
//                         }
//                         Column(UOM_SalesInvoiceLineCaption; FIELDCAPTION("Unit of Measure"))
//                         {
//                             //SourceExpr=FIELDCAPTION("Unit of Measure");
//                         }
//                         Column(VATIdent_SalesInvLineCaption; FIELDCAPTION("VAT Identifier"))
//                         {
//                             //SourceExpr=FIELDCAPTION("VAT Identifier");
//                         }
//                         Column(IsLineWithTotals; LineNoWithTotal = "Line No.")
//                         {
//                             //SourceExpr=LineNoWithTotal = "Line No.";
//                         }
//                         DataItem("DimensionLoop2"; "2000000026")
//                         {

//                             DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = FILTER(1 ..));
//                             ;
//                             Column(DimText1; DimText)
//                             {
//                                 //SourceExpr=DimText;
//                             }
//                             Column(LineDimsCaption; LineDimsCaptionLbl)
//                             {
//                                 //SourceExpr=LineDimsCaptionLbl;
//                             }
//                             DataItem("Total"; "2000000026")
//                             {

//                                 DataItemTableView = SORTING("Number");
//                                 ;
//                                 Column(BL_Line; Number)
//                                 {
//                                     //SourceExpr=Number;
//                                 }
//                                 DataItem("VATCounter"; "2000000026")
//                                 {

//                                     DataItemTableView = SORTING("Number");
//                                     ;
//                                     Column(ISP; txtISP)
//                                     {
//                                         //SourceExpr=txtISP;
//                                     }
//                                     Column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
//                                     {
//                                         //SourceExpr=VATAmountLine."VAT Identifier";
//                                     }
//                                     Column(VATAmountLineVATBase; VATAmountLine."VAT Base")
//                                     {
//                                         //SourceExpr=VATAmountLine."VAT Base";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Lineas.GetCurrencyCode;
//                                     }
//                                     Column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
//                                     {
//                                         //SourceExpr=VATAmountLine."VAT Amount";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Cabecera."Currency Code";
//                                     }
//                                     Column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
//                                     {
//                                         //SourceExpr=VATAmountLine."Line Amount";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Cabecera."Currency Code";
//                                     }
//                                     Column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
//                                     {
//                                         //SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Cabecera."Currency Code";
//                                     }
//                                     Column(VATAmtLineInvDiscountAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
//                                     {
//                                         //SourceExpr=VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Cabecera."Currency Code";
//                                     }
//                                     Column(VATAmtLineECAmount; VATAmountLine."EC Amount")
//                                     {
//                                         //SourceExpr=VATAmountLine."EC Amount";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Cabecera."Currency Code";
//                                     }
//                                     Column(VATAmountLineVAT; VATAmountLine."VAT %")
//                                     {
//                                         DecimalPlaces = 0 : 5;
//                                         //SourceExpr=VATAmountLine."VAT %";
//                                     }
//                                     Column(VATAmountLineEC; VATAmountLine."EC %")
//                                     {
//                                         //SourceExpr=VATAmountLine."EC %";
//                                         AutoFormatType = 1;
//                                         AutoFormatExpression = Doc_Cabecera."Currency Code";
//                                     }
//                                     Column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
//                                     {
//                                         //SourceExpr=VATAmtSpecCaptionLbl;
//                                     }
//                                     Column(VATIdentCaption; VATIdentCaptionLbl)
//                                     {
//                                         //SourceExpr=VATIdentCaptionLbl;
//                                     }
//                                     Column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
//                                     {
//                                         //SourceExpr=InvDiscBaseAmtCaptionLbl;
//                                     }
//                                     Column(LineAmtCaption1; LineAmtCaption1Lbl)
//                                     {
//                                         //SourceExpr=LineAmtCaption1Lbl;
//                                     }
//                                     Column(InvPmtDiscCaption; InvPmtDiscCaptionLbl)
//                                     {
//                                         //SourceExpr=InvPmtDiscCaptionLbl;
//                                     }
//                                     Column(ECAmtCaption; ECAmtCaptionLbl)
//                                     {
//                                         //SourceExpr=ECAmtCaptionLbl;
//                                     }
//                                     Column(ECCaption; ECCaptionLbl)
//                                     {
//                                         //SourceExpr=ECCaptionLbl;
//                                     }
//                                     Column(TotalCaption; TotalCaptionLbl)
//                                     {
//                                         //SourceExpr=TotalCaptionLbl;
//                                     }
//                                     Column(RetPorc; WitholdingPorc)
//                                     {
//                                         //SourceExpr=WitholdingPorc;
//                                     }
//                                     Column(RetAmount; WitholdingAmount)
//                                     {
//                                         //SourceExpr=WitholdingAmount;
//                                     }
//                                     DataItem("Hist. Certification Lines"; "Hist. Certification Lines")
//                                     {

//                                         DataItemTableView = SORTING("Document No.", "Line No.");


//                                         UseTemporary = true;
//                                         Column(LDocument_No; 'CERT')
//                                         {
//                                             //SourceExpr='CERT';
//                                         }
//                                         Column(LPiecework_Order; "Hist. Certification Lines"."Piecework No.")
//                                         {
//                                             //SourceExpr="Hist. Certification Lines"."Piecework No.";
//                                         }
//                                         Column(LPieceworkIdentation; DataPieceworkForProduction.Indentation)
//                                         {
//                                             //SourceExpr=DataPieceworkForProduction.Indentation;
//                                         }
//                                         Column(LPiecework_No; PieceworkCode)
//                                         {
//                                             //SourceExpr=PieceworkCode;
//                                         }
//                                         Column(LDescription; PieceworkDes)
//                                         {
//                                             //SourceExpr=PieceworkDes;
//                                         }
//                                         Column(LAmountAnt; LineAmountAnt)
//                                         {
//                                             //SourceExpr=LineAmountAnt;
//                                         }
//                                         Column(LAmountOri; LineAmountOri)
//                                         {
//                                             //SourceExpr=LineAmountOri;
//                                         }
//                                         Column(LAmountTot; LineAmountTot)
//                                         {
//                                             //SourceExpr=LineAmountTot ;
//                                         }
//                                         trigger OnPreDataItem();
//                                         BEGIN
//                                             "Hist. Certification Lines".RESET;
//                                             IF "Hist. Certification Lines".COUNT = 0 THEN
//                                                 CurrReport.BREAK;
//                                         END;

//                                         trigger OnAfterGetRecord();
//                                         VAR
//                                             //                                   NSpaces@1100286000 :
//                                             NSpaces: Integer;
//                                         BEGIN
//                                             PieceworkCode := DELCHR("Hist. Certification Lines"."Piecework No.", '>', MarcaFinal);
//                                             NSpaces := (STRLEN(PieceworkCode) - Level0) * 2;

//                                             IF NOT DataPieceworkForProduction.GET(JobNo, PieceworkCode) THEN
//                                                 DataPieceworkForProduction.INIT;

//                                             //Ordenamos por U.O, pero podemos mostrar otro c¢digo
//                                             PieceworkCode := PADSTR('', NSpaces, ' ') + DataPieceworkForProduction."Piecework Code";
//                                             PieceworkDes := PADSTR('', NSpaces, ' ') + DataPieceworkForProduction.Description;

//                                             IF (DataPieceworkForProduction.Indentation = 0) THEN BEGIN
//                                                 LineAmountAnt := "Hist. Certification Lines"."Tmp Previous amount";
//                                                 LineAmountOri := "Hist. Certification Lines"."Tmp Origin amount";
//                                                 LineAmountTot := 0;
//                                             END ELSE BEGIN
//                                                 LineAmountAnt := 0;
//                                                 LineAmountOri := 0;
//                                                 LineAmountTot := "Hist. Certification Lines"."Tmp Origin amount";
//                                             END;
//                                         END;


//                                     }
//                                     trigger OnPreDataItem();
//                                     BEGIN
//                                         SETRANGE(Number, 1, VATAmountLine.COUNT);
//                                         CurrReport.CREATETOTALS(
//                                           VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
//                                           VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount",
//                                           VATAmountLine."EC Amount", VATAmountLine."Pmt. Discount Amount");
//                                     END;

//                                     trigger OnAfterGetRecord();
//                                     BEGIN
//                                         VATAmountLine.GetLine(Number);
//                                         IF VATAmountLine."VAT Amount" = 0 THEN
//                                             VATAmountLine."VAT %" := 0;
//                                         IF VATAmountLine."EC Amount" = 0 THEN
//                                             VATAmountLine."EC %" := 0;

//                                         IF (Number <> 1) THEN BEGIN
//                                             WitholdingPorc := 0;
//                                             WitholdingAmount := 0;
//                                         END;
//                                     END;


//                                 }
//                                 trigger OnPreDataItem();
//                                 BEGIN
//                                     SETRANGE(Number, 1, MaxLineas - (NLineas MOD MaxLineas));
//                                 END;


//                             }
//                             trigger OnPreDataItem();
//                             BEGIN
//                                 IF NOT ShowInternalInfo THEN
//                                     CurrReport.BREAK;

//                                 DimSetEntry2.SETRANGE("Dimension Set ID", Doc_Lineas."Dimension Set ID");
//                             END;

//                             trigger OnAfterGetRecord();
//                             BEGIN
//                                 IF Number = 1 THEN BEGIN
//                                     IF NOT DimSetEntry2.FINDSET THEN
//                                         CurrReport.BREAK;
//                                 END ELSE
//                                     IF NOT Continue THEN
//                                         CurrReport.BREAK;

//                                 CLEAR(DimText);
//                                 Continue := FALSE;
//                                 REPEAT
//                                     OldDimText := DimText;
//                                     IF DimText = '' THEN
//                                         DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
//                                     ELSE
//                                         DimText :=
//                                           STRSUBSTNO(
//                                             '%1, %2 %3', DimText,
//                                             DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
//                                     IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                         DimText := OldDimText;
//                                         Continue := TRUE;
//                                         EXIT;
//                                     END;
//                                 UNTIL DimSetEntry2.NEXT = 0;
//                             END;


//                         }
//                         trigger OnPreDataItem();
//                         BEGIN
//                             txtISP := '';

//                             VATAmountLine.DELETEALL;
//                             TempVATAmountLineLCY.DELETEALL;
//                             VATBaseRemainderAfterRoundingLCY := 0;
//                             AmtInclVATRemainderAfterRoundingLCY := 0;
//                             SalesShipmentBuffer.RESET;
//                             SalesShipmentBuffer.DELETEALL;
//                             FirstValueEntryNo := 0;
//                             MoreLines := FIND('+');
//                             WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
//                                 MoreLines := NEXT(-1) <> 0;
//                             IF NOT MoreLines THEN
//                                 CurrReport.BREAK;
//                             LineNoWithTotal := "Line No.";
//                             SETRANGE("Line No.", 0, "Line No.");
//                             CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount", "Pmt. Discount Amount");

//                             NLineas := 0;
//                         END;

//                         trigger OnAfterGetRecord();
//                         BEGIN
//                             NLineas += 1;

//                             InitializeShipmentBuffer;
//                             IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
//                                 "No." := '';

//                             IF VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN BEGIN
//                                 IF (txtISP = '') THEN
//                                     txtISP := VATPostingSetup."ISP Description";

//                                 VATAmountLine.INIT;
//                                 VATAmountLine."VAT Identifier" := "VAT Identifier";
//                                 VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
//                                 VATAmountLine."Tax Group Code" := "Tax Group Code";
//                                 VATAmountLine."VAT %" := VATPostingSetup."VAT %";
//                                 VATAmountLine."EC %" := VATPostingSetup."EC %";
//                                 VATAmountLine."VAT Base" := Amount;
//                                 VATAmountLine."Amount Including VAT" := "Amount Including VAT";
//                                 VATAmountLine."Line Amount" := "Line Amount";
//                                 VATAmountLine."Pmt. Discount Amount" := "Pmt. Discount Amount";
//                                 IF "Allow Invoice Disc." THEN
//                                     VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
//                                 VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
//                                 VATAmountLine.SetCurrencyCode(Doc_Cabecera."Currency Code");
//                                 VATAmountLine."VAT Difference" := "VAT Difference";
//                                 VATAmountLine."EC Difference" := "EC Difference";
//                                 IF Doc_Cabecera."Prices Including VAT" THEN
//                                     VATAmountLine."Prices Including VAT" := TRUE;
//                                 VATAmountLine."VAT Clause Code" := "VAT Clause Code";
//                                 VATAmountLine.QB_SetPositiveFalse;
//                                 VATAmountLine.InsertLine;
//                                 CalcVATAmountLineLCY(
//                                   Doc_Cabecera, VATAmountLine, TempVATAmountLineLCY,
//                                   VATBaseRemainderAfterRoundingLCY, AmtInclVATRemainderAfterRoundingLCY);

//                                 TotalSubTotal += "Line Amount";
//                                 TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
//                                 TotalAmount += Amount;
//                                 TotalAmountVAT += "Amount Including VAT" - Amount;
//                                 TotalAmountInclVAT += "Amount Including VAT";
//                                 TotalGivenAmount -= "Pmt. Discount Amount";
//                                 TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Pmt. Discount Amount" - "Amount Including VAT");
//                             END;
//                         END;


//                     }
//                     trigger OnPreDataItem();
//                     BEGIN
//                         NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
//                         IF NoOfLoops <= 0 THEN
//                             NoOfLoops := 1;
//                         CopyText := '';
//                         SETRANGE(Number, 1, NoOfLoops);
//                         OutputNo := 1;
//                     END;

//                     trigger OnAfterGetRecord();
//                     BEGIN
//                         IF Number > 1 THEN BEGIN
//                             CopyText := 'Copia de';
//                             OutputNo += 1;
//                         END;
//                         CurrReport.PAGENO := 1;

//                         TotalSubTotal := 0;
//                         TotalInvoiceDiscountAmount := 0;
//                         TotalAmount := 0;
//                         TotalAmountVAT := 0;
//                         TotalAmountInclVAT := 0;
//                         TotalGivenAmount := 0;
//                         TotalPaymentDiscountOnVAT := 0;
//                     END;

//                     trigger OnPostDataItem();
//                     BEGIN
//                         IF NOT IsReportInPreviewMode THEN
//                             CODEUNIT.RUN(CODEUNIT::"Sales Inv.-Printed", Doc_Cabecera);
//                     END;


//                 }
//                 trigger OnPreDataItem();
//                 BEGIN
//                     QuoBuildingSetup.GET;
//                     QuoBuildingSetup.CALCFIELDS(Logo1);
//                     TxtPie := QuoBuildingSetup.QB_GetText1;

//                     CompanyInfo.GET;
//                     CompanyInfo.CALCFIELDS(Picture);
//                 END;

//                 trigger OnAfterGetRecord();
//                 VAR
//                     //                                   Handled@1000 :
//                     Handled: Boolean;
//                     //                                   SalesInvoiceHeader@1000000000 :
//                     SalesInvoiceHeader: Record 112;
//                 BEGIN
//                     //Clarify with EU Team
//                     // CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                     FormatAddressFields(Doc_Cabecera);
//                     FormatDocumentFields(Doc_Cabecera);

//                     IF NOT Cust.GET("Bill-to Customer No.") THEN
//                         CLEAR(Cust);

//                     DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

//                     GetLineFeeNoteOnReportHist("No.");


//                     //Buscar proyecto
//                     JobNo := '';
//                     IF (Doc_Cabecera."Job No." <> '') THEN
//                         JobNo := Doc_Cabecera."Job No."
//                     ELSE BEGIN
//                         SalesInvoiceLine.RESET;
//                         SalesInvoiceLine.SETRANGE("Document No.", Doc_Cabecera."No.");
//                         SalesInvoiceLine.SETFILTER("Job No.", '<>%1', '');
//                         IF (SalesInvoiceLine.FINDFIRST) THEN
//                             JobNo := SalesInvoiceLine."Job No.";
//                     END;

//                     //Retenci¢n de IRPF
//                     WitholdingPorc := 0;
//                     WitholdingAmount := 0;
//                     IF (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::PIT, Doc_Cabecera."QW Cod. Withholding by PIT")) THEN BEGIN
//                         Doc_Cabecera.CALCFIELDS("QW Total Withholding PIT");
//                         WitholdingPorc := WithholdingGroup."Percentage Withholding";
//                         WitholdingAmount := Doc_Cabecera."QW Total Withholding PIT";
//                     END;

//                     //Retenci¢n de Pago
//                     IF (Doc_Cabecera."QW Witholding Due Date" = 0D) THEN
//                         Doc_Cabecera.VALIDATE("QW Witholding Due Date");
//                     WitholdingDueDate := Doc_Cabecera."QW Witholding Due Date";

//                     //Total factura
//                     Doc_Cabecera.CALCFIELDS("Amount Including VAT", "QW Total Withholding GE");
//                     TotFactura := Doc_Cabecera."Amount Including VAT" - WitholdingAmount;
//                     RetPago := Doc_Cabecera."QW Total Withholding GE";
//                     TotPagar := TotFactura - RetPago;

//                     //Compruebo si la factura viene de una certificaci¢n
//                     CertificationCode := '';
//                     SalesInvoiceLine.RESET;
//                     SalesInvoiceLine.SETRANGE("Document No.", Doc_Cabecera."No.");
//                     SalesInvoiceLine.SETFILTER("QB Certification code", '<>%1', '');
//                     IF SalesInvoiceLine.FINDFIRST THEN
//                         CertificationCode := SalesInvoiceLine."QB Certification code";

//                     //Montar la tabla temporal con la certificaci¢n
//                     "Hist. Certification Lines".MontarTemporal("Hist. Certification Lines", Totales, Level0, MarcaFinal, CertificationCode, FALSE, 1);
//                     "Hist. Certification Lines".RESET;
//                     "Hist. Certification Lines".SETFILTER("Tmp Piecework Header", '<>%1', "Hist. Certification Lines"."Tmp Piecework Header"::Header);
//                     "Hist. Certification Lines".DELETEALL;
//                     "Hist. Certification Lines".RESET;

//                     //Banco de pago, por defecto el de la empresa, pero si lo tiene el del cliente, y si tiene la factura este
//                     BankName := CompanyInfo."Bank Name";
//                     BankIBAN := CompanyInfo.IBAN;
//                     IF (BankAccount.GET(Cust."QB Receivable Bank No.")) THEN BEGIN
//                         BankName := BankAccount.Name;
//                         BankIBAN := BankAccount.IBAN;
//                     END;
//                     IF (BankAccount.GET(Doc_Cabecera."Payment bank No.")) THEN BEGIN
//                         BankName := BankAccount.Name;
//                         BankIBAN := BankAccount.IBAN;
//                     END;

//                     //JAV 29/10/20 Buscar importe anterior
//                     CertOrigen := 0;
//                     CertAnterior := 0;
//                     CertActual := 0;
//                     IF (CertificationCode = '') AND (opcCert) THEN BEGIN
//                         Doc_Cabecera.CALCFIELDS(Amount);
//                         CertActual := Doc_Cabecera.Amount;

//                         SalesInvoiceHeader.RESET;
//                         SalesInvoiceHeader.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
//                         SalesInvoiceHeader.SETFILTER("Job No.", '%1|%2', '', "Job No.");
//                         IF SalesInvoiceHeader.FINDSET(FALSE) THEN
//                             REPEAT
//                                 SalesInvoiceHeader.CALCFIELDS(Amount);
//                                 CertOrigen += SalesInvoiceHeader.Amount;
//                             UNTIL SalesInvoiceHeader.NEXT = 0;
//                         CertAnterior := CertOrigen - CertActual;
//                     END;
//                 END;


//             }
//         }
//     }
//     requestpage
//     {
//         SaveValues = true;

//         layout
//         {
//             area(content)
//             {
//                 group("group22")
//                 {

//                     CaptionML = ENU = 'Options', ESP = 'Opciones';
//                     field("NoOfCopies"; "NoOfCopies")
//                     {

//                         CaptionML = ENU = 'No. of Copies', ESP = 'N§ copias';
//                         ToolTipML = ENU = 'Specifies how many copies of the document to print.', ESP = 'Especifica cu ntas copias del documento se van a imprimir.';
//                         ApplicationArea = Basic, Suite;
//                     }
//                     field("LogInteraction"; "LogInteraction")
//                     {

//                         CaptionML = ENU = 'Log Interaction', ESP = 'Log interacci¢n';
//                         ToolTipML = ENU = 'Specifies that interactions with the contact are logged.', ESP = 'Indica que las interacciones con el contacto est n registradas.';
//                         ApplicationArea = Basic, Suite;
//                         Enabled = LogInteractionEnable;
//                     }
//                     field("opcCert"; "opcCert")
//                     {

//                         CaptionML = ESP = 'Certificaci¢n';
//                     }

//                 }

//             }
//         }
//         trigger OnInit()
//         BEGIN
//             LogInteractionEnable := TRUE;
//         END;

//         trigger OnOpenPage()
//         BEGIN
//             InitLogInteraction;
//             LogInteractionEnable := LogInteraction;
//         END;


//     }
//     labels
//     {
//         lblJobNo = 'Obra/';
//         lblBaseImponible = 'Base Imponible/';
//         lblVATPorc = '% IVA/';
//         lblVATAmount = 'Importe I.V.A./';
//         lblIRPFporc = '% I.R.P.F./';
//         lblIRPFAmount = 'I.R.P.F./';
//         lblTotal = 'Total/';
//         lblTotalFactura = 'Total Factura/';
//         lblCertification = 'RESUMEN DE LA CERTIFICACION/';
//         lblUO = 'U.O./';
//         lblDescription = 'Descripci¢n/';
//         lblAmount = 'Importe/';
//         lblTCert = 'Total Ejecuci¢n Material:/';
//         lblTAnt = 'A Deducir por certificaciones anteriores:/';
//         lblTAct = 'Total Certificaci¢n:/';
//         lblT04 = 'Gastos generales:/';
//         lblT05 = 'Beneficio Industrial:/';
//         lblT06 = 'Baja:/';
//         lblT07 = 'Total Certificaci¢n:/';
//         lblT08 = 'Retenci¢n de Buena Ejecuci¢n:/';
//         lblT09 = 'Base Imponible:/';
//         lblT10 = 'IVA:/';
//         lblT11 = 'Total a Facturar:/';
//         lblT12 = 'Retenci¢n de Buena Ejecuci¢n:/';
//         lblT13 = 'Total a Pagar:/';
//     }

//     var
//         //       QuoBuildingSetup@1000000103 :
//         QuoBuildingSetup: Record 7207278;
//         //       opcCert@1000000003 :
//         opcCert: Boolean;
//         //       GLSetup@1100286087 :
//         GLSetup: Record 98;
//         //       ShipmentMethod@1100286086 :
//         ShipmentMethod: Record 10;
//         //       PaymentTerms@1100286085 :
//         PaymentTerms: Record 3;
//         //       SalesPurchPerson@1100286084 :
//         SalesPurchPerson: Record 13;
//         //       CompanyInfo@1100286083 :
//         CompanyInfo: Record 79;
//         //       SalesSetup@1100286082 :
//         SalesSetup: Record 311;
//         //       SalesShipmentBuffer@1100286081 :
//         SalesShipmentBuffer: Record 7190 TEMPORARY;
//         //       Cust@1100286080 :
//         Cust: Record 18;
//         //       VATAmountLine@1100286079 :
//         VATAmountLine: Record 290 TEMPORARY;
//         //       TempVATAmountLineLCY@1100286078 :
//         TempVATAmountLineLCY: Record 290 TEMPORARY;
//         //       DimSetEntry1@1100286077 :
//         DimSetEntry1: Record 480;
//         //       DimSetEntry2@1100286076 :
//         DimSetEntry2: Record 480;
//         //       RespCenter@1100286075 :
//         RespCenter: Record 5714;
//         //       Language@1100286074 :
//         Language: Record 8;
//         //       CurrExchRate@1100286073 :
//         CurrExchRate: Record 330;
//         //       TempPostedAsmLine@1100286072 :
//         TempPostedAsmLine: Record 911 TEMPORARY;
//         //       VATClause@1100286071 :
//         VATClause: Record 560;
//         //       TempLineFeeNoteOnReportHist@1100286070 :
//         TempLineFeeNoteOnReportHist: Record 1053 TEMPORARY;
//         //       FormatAddr@1100286069 :
//         FormatAddr: Codeunit 365;
//         //       FormatDocument@1100286068 :
//         FormatDocument: Codeunit 368;
//         //       SegManagement@1100286067 :
//         SegManagement: Codeunit 5051;
//         //       CustAddr@1100286066 :
//         CustAddr: ARRAY[8] OF Text[50];
//         //       ShipToAddr@1100286065 :
//         ShipToAddr: ARRAY[8] OF Text[50];
//         //       CompanyAddr@1100286064 :
//         CompanyAddr: ARRAY[8] OF Text[50];
//         //       OrderNoText@1100286063 :
//         OrderNoText: Text[80];
//         //       SalesPersonText@1100286062 :
//         SalesPersonText: Text[30];
//         //       VATNoText@1100286061 :
//         VATNoText: Text[80];
//         //       ReferenceText@1100286060 :
//         ReferenceText: Text[80];
//         //       TotalText@1100286059 :
//         TotalText: Text[50];
//         //       TotalExclVATText@1100286058 :
//         TotalExclVATText: Text[50];
//         //       TotalInclVATText@1100286057 :
//         TotalInclVATText: Text[50];
//         //       MoreLines@1100286056 :
//         MoreLines: Boolean;
//         //       NoOfCopies@1100286055 :
//         NoOfCopies: Integer;
//         //       NoOfLoops@1100286054 :
//         NoOfLoops: Integer;
//         //       CopyText@1100286053 :
//         CopyText: Text[30];
//         //       ShowShippingAddr@1100286052 :
//         ShowShippingAddr: Boolean;
//         //       NextEntryNo@1100286051 :
//         NextEntryNo: Integer;
//         //       FirstValueEntryNo@1100286050 :
//         FirstValueEntryNo: Integer;
//         //       DimText@1100286049 :
//         DimText: Text[120];
//         //       OldDimText@1100286048 :
//         OldDimText: Text[75];
//         //       ShowInternalInfo@1100286047 :
//         ShowInternalInfo: Boolean;
//         //       Continue@1100286046 :
//         Continue: Boolean;
//         //       LogInteraction@1100286045 :
//         LogInteraction: Boolean;
//         //       VALVATBaseLCY@1100286044 :
//         VALVATBaseLCY: Decimal;
//         //       VALVATAmountLCY@1100286043 :
//         VALVATAmountLCY: Decimal;
//         //       VALSpecLCYHeader@1100286042 :
//         VALSpecLCYHeader: Text[80];
//         //       VALExchRate@1100286041 :
//         VALExchRate: Text[50];
//         //       CalculatedExchRate@1100286040 :
//         CalculatedExchRate: Decimal;
//         //       OutputNo@1100286039 :
//         OutputNo: Integer;
//         //       TotalSubTotal@1100286038 :
//         TotalSubTotal: Decimal;
//         //       TotalAmount@1100286037 :
//         TotalAmount: Decimal;
//         //       TotalAmountInclVAT@1100286036 :
//         TotalAmountInclVAT: Decimal;
//         //       TotalAmountVAT@1100286035 :
//         TotalAmountVAT: Decimal;
//         //       TotalInvoiceDiscountAmount@1100286034 :
//         TotalInvoiceDiscountAmount: Decimal;
//         //       TotalPaymentDiscountOnVAT@1100286033 :
//         TotalPaymentDiscountOnVAT: Decimal;
//         //       VATPostingSetup@1100286032 :
//         VATPostingSetup: Record 325;
//         //       PaymentMethod@1100286031 :
//         PaymentMethod: Record 289;
//         //       TotalGivenAmount@1100286030 :
//         TotalGivenAmount: Decimal;
//         //       LogInteractionEnable@1100286029 :
//         LogInteractionEnable: Boolean;
//         //       DisplayAssemblyInformation@1100286028 :
//         DisplayAssemblyInformation: Boolean;
//         //       CACCaptionLbl@1100286027 :
//         CACCaptionLbl: Text;
//         //       DisplayAdditionalFeeNote@1100286026 :
//         DisplayAdditionalFeeNote: Boolean;
//         //       LineNoWithTotal@1100286025 :
//         LineNoWithTotal: Integer;
//         //       VATBaseRemainderAfterRoundingLCY@1100286024 :
//         VATBaseRemainderAfterRoundingLCY: Decimal;
//         //       AmtInclVATRemainderAfterRoundingLCY@1100286023 :
//         AmtInclVATRemainderAfterRoundingLCY: Decimal;
//         //       "-----------------------------------------"@1100286022 :
//         "-----------------------------------------": Integer;
//         //       JobNo@1100286021 :
//         JobNo: Text;
//         //       SalesInvoiceLine@1100286020 :
//         SalesInvoiceLine: Record 113;
//         //       Currency@1100286019 :
//         Currency: Record 4;
//         //       RoundingPrec@1100286118 :
//         RoundingPrec: Decimal;
//         //       VATAmountLine1@1100286017 :
//         VATAmountLine1: Record 290;
//         //       WithholdingGroup@1100286016 :
//         WithholdingGroup: Record 7207330;
//         //       WitholdingPorc@1100286015 :
//         WitholdingPorc: Decimal;
//         //       WitholdingAmount@1100286014 :
//         WitholdingAmount: Decimal;
//         //       CertificationCode@1100286013 :
//         CertificationCode: Code[20];
//         //       TotFactura@1100286012 :
//         TotFactura: Decimal;
//         //       RetPago@1100286011 :
//         RetPago: Decimal;
//         //       TotPagar@1100286010 :
//         TotPagar: Decimal;
//         //       TxtPie@1100286009 :
//         TxtPie: Text;
//         //       Totales@1000000106 :
//         Totales: ARRAY[20] OF Decimal;
//         //       Level0@1100286007 :
//         Level0: Integer;
//         //       MarcaFinal@1100286006 :
//         MarcaFinal: Text;
//         //       LineAmountAnt@1100286005 :
//         LineAmountAnt: Decimal;
//         //       LineAmountOri@1100286004 :
//         LineAmountOri: Decimal;
//         //       LineAmountTot@1100286003 :
//         LineAmountTot: Decimal;
//         //       DataPieceworkForProduction@1100286002 :
//         DataPieceworkForProduction: Record 7207386;
//         //       PieceworkCode@1100286001 :
//         PieceworkCode: Text;
//         //       PieceworkDes@1100286000 :
//         PieceworkDes: Text;
//         //       Text004@1100286136 :
//         Text004:
// // "%1 = Document No."
// TextConst ENU = 'Sales - Invoice %1', ESP = '%1 Factura';
//         //       PageCaptionCap@1100286135 :
//         PageCaptionCap: TextConst ENU = 'Page %1 of %2', ESP = 'P gina %1 de %2';
//         //       Text007@1100286134 :
//         Text007: TextConst ENU = 'VAT Amount Specification in ', ESP = 'Especificar importe IVA en ';
//         //       Text008@1100286133 :
//         Text008: TextConst ENU = 'Local Currency', ESP = 'Divisa local';
//         //       Text009@1100286132 :
//         Text009: TextConst ENU = 'Exchange rate: %1/%2', ESP = 'Tipo cambio: %1/%2';
//         //       Text010@1100286131 :
//         Text010: TextConst ENU = 'Sales - Prepayment Invoice %1', ESP = 'Ventas - Factura prepago %1';
//         //       PhoneNoCaptionLbl@1100286130 :
//         PhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ESP = 'N§ tel‚fono';
//         //       VATRegNoCaptionLbl@1100286129 :
//         VATRegNoCaptionLbl: TextConst ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
//         //       GiroNoCaptionLbl@1100286128 :
//         GiroNoCaptionLbl: TextConst ENU = 'Giro No.', ESP = 'N§ giro postal';
//         //       BankNameCaptionLbl@1100286127 :
//         BankNameCaptionLbl: TextConst ENU = 'Bank', ESP = 'Banco';
//         //       BankAccNoCaptionLbl@1100286126 :
//         BankAccNoCaptionLbl: TextConst ENU = 'Account No.', ESP = 'N§ cuenta';
//         //       DueDateCaptionLbl@1100286125 :
//         DueDateCaptionLbl: TextConst ENU = 'Due Date', ESP = 'Fecha vencimiento';
//         //       InvoiceNoCaptionLbl@1100286124 :
//         InvoiceNoCaptionLbl: TextConst ENU = 'Invoice No.', ESP = 'N§ factura';
//         //       PostingDateCaptionLbl@1100286123 :
//         PostingDateCaptionLbl: TextConst ENU = 'Posting Date', ESP = 'Fecha registro';
//         //       HdrDimsCaptionLbl@1100286122 :
//         HdrDimsCaptionLbl: TextConst ENU = 'Header Dimensions', ESP = 'Dimensiones cabecera';
//         //       PmtinvfromdebtpaidtoFactCompCaptionLbl@1100286121 :
//         PmtinvfromdebtpaidtoFactCompCaptionLbl: TextConst ENU = 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.', ESP = 'Para que se libere de la deuda, el pago de esta factura se debe realizar a la compa¤¡a Factoring.';
//         //       UnitPriceCaptionLbl@1100286120 :
//         UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESP = 'Precio';
//         //       DiscountCaptionLbl@1100286119 :
//         DiscountCaptionLbl: TextConst ENU = 'Discount %', ESP = '% Descuento';
//         //       AmtCaptionLbl@1000000107 :
//         AmtCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
//         //       VATClausesCap@1100286117 :
//         VATClausesCap: TextConst ENU = 'VAT Clause', ESP = 'Cl usula de IVA';
//         //       PostedShpDateCaptionLbl@1100286116 :
//         PostedShpDateCaptionLbl: TextConst ENU = 'Posted Shipment Date', ESP = 'Fecha env¡o registrada';
//         //       InvDiscAmtCaptionLbl@1100286115 :
//         InvDiscAmtCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ESP = 'Importe descuento factura';
//         //       SubtotalCaptionLbl@1100286114 :
//         SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ESP = 'Subtotal';
//         //       PmtDiscGivenAmtCaptionLbl@1100286113 :
//         PmtDiscGivenAmtCaptionLbl: TextConst ENU = 'Payment Disc Given Amount', ESP = 'Importe descuento pago';
//         //       PmtDiscVATCaptionLbl@1100286112 :
//         PmtDiscVATCaptionLbl: TextConst ENU = 'Payment Discount on VAT', ESP = 'Descuento P.P. sobre IVA';
//         //       ShpCaptionLbl@1100286111 :
//         ShpCaptionLbl: TextConst ENU = 'Shipment', ESP = 'Env¡o';
//         //       LineDimsCaptionLbl@1100286110 :
//         LineDimsCaptionLbl: TextConst ENU = 'Line Dimensions', ESP = 'Dimensiones l¡nea';
//         //       VATAmtSpecCaptionLbl@1100286106 :
//         VATAmtSpecCaptionLbl: TextConst ENU = 'VAT Amount Specification', ESP = 'Especificaci¢n importe IVA';
//         //       VATIdentCaptionLbl@1100286105 :
//         VATIdentCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
//         //       InvDiscBaseAmtCaptionLbl@1100286104 :
//         InvDiscBaseAmtCaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ESP = 'Importe base descuento factura';
//         //       LineAmtCaption1Lbl@1100286103 :
//         LineAmtCaption1Lbl: TextConst ENU = 'Line Amount', ESP = 'Importe l¡nea';
//         //       InvPmtDiscCaptionLbl@1100286102 :
//         InvPmtDiscCaptionLbl: TextConst ENU = 'Invoice and Payment Discounts', ESP = 'Descuentos facturas y pagos';
//         //       ECAmtCaptionLbl@1100286101 :
//         ECAmtCaptionLbl: TextConst ENU = 'EC Amount', ESP = 'Importe RE';
//         //       ECCaptionLbl@1100286100 :
//         ECCaptionLbl: TextConst ENU = 'EC %', ESP = '% RE';
//         //       TotalCaptionLbl@1100286099 :
//         TotalCaptionLbl: TextConst ENU = 'Total', ESP = 'Total';
//         //       VALVATBaseLCYCaption1Lbl@1100286098 :
//         VALVATBaseLCYCaption1Lbl: TextConst ENU = 'VAT Base', ESP = 'Base IVA';
//         //       VATAmtCaptionLbl@1100286097 :
//         VATAmtCaptionLbl: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
//         //       VATIdentifierCaptionLbl@1100286096 :
//         VATIdentifierCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
//         //       ShiptoAddressCaptionLbl@1100286095 :
//         ShiptoAddressCaptionLbl: TextConst ENU = 'Ship-to Address', ESP = 'Direcci¢n de env¡o';
//         //       PmtTermsDescCaptionLbl@1100286094 :
//         PmtTermsDescCaptionLbl: TextConst ENU = 'Payment Terms', ESP = 'T‚rminos pago';
//         //       ShpMethodDescCaptionLbl@1100286093 :
//         ShpMethodDescCaptionLbl: TextConst ENU = 'Shipment Method', ESP = 'Condiciones env¡o';
//         //       PmtMethodDescCaptionLbl@1100286092 :
//         PmtMethodDescCaptionLbl: TextConst ENU = 'Payment Method', ESP = 'Forma pago';
//         //       DocDateCaptionLbl@1100286091 :
//         DocDateCaptionLbl: TextConst ENU = 'Document Date', ESP = 'Fecha emisi¢n documento';
//         //       HomePageCaptionLbl@1100286090 :
//         HomePageCaptionLbl: TextConst ENU = 'Home Page', ESP = 'P gina Web';
//         //       EmailCaptionLbl@1100286089 :
//         EmailCaptionLbl: TextConst ENU = 'Email', ESP = 'Correo electr¢nico';
//         //       CACTxt@1100286088 :
//         CACTxt: TextConst ENU = 'Rï¿½gimen especial del criterio de caja', ESP = 'R‚gimen especial del criterio de caja';
//         //       WitholdingDueDate@1100286137 :
//         WitholdingDueDate: Date;
//         //       NLineas@1100286138 :
//         NLineas: Integer;
//         //       MaxLineas@1100286139 :
//         MaxLineas: Integer;
//         //       txtISP@1100286140 :
//         txtISP: Text;
//         //       BankAccount@1100286109 :
//         BankAccount: Record 270;
//         //       BankName@1100286107 :
//         BankName: Text;
//         //       BankIBAN@1100286108 :
//         BankIBAN: Text;
//         //       CertOrigen@1000000000 :
//         CertOrigen: Decimal;
//         //       CertAnterior@1000000001 :
//         CertAnterior: Decimal;
//         //       CertActual@1000000002 :
//         CertActual: Decimal;




//     trigger OnInitReport();
//     begin
//         GLSetup.GET;
//         SalesSetup.GET;
//     end;

//     trigger OnPreReport();
//     begin
//         if not CurrReport.USEREQUESTPAGE then
//             InitLogInteraction;

//         MaxLineas := 30;
//     end;

//     trigger OnPostReport();
//     begin
//         if LogInteraction and not IsReportInPreviewMode then
//             if Doc_Cabecera.FINDSET then
//                 repeat
//                     if Doc_Cabecera."Bill-to Contact No." <> '' then
//                         SegManagement.LogDocument(
//                           SegManagement.SalesInvoiceInterDocType, Doc_Cabecera."No.", 0, 0, DATABASE::Contact,
//                           Doc_Cabecera."Bill-to Contact No.", Doc_Cabecera."Salesperson Code",
//                           Doc_Cabecera."Campaign No.", Doc_Cabecera."Posting Description", '')
//                     else
//                         SegManagement.LogDocument(
//                           SegManagement.SalesInvoiceInterDocType, Doc_Cabecera."No.", 0, 0, DATABASE::Customer,
//                           Doc_Cabecera."Bill-to Customer No.", Doc_Cabecera."Salesperson Code",
//                           Doc_Cabecera."Campaign No.", Doc_Cabecera."Posting Description", '');
//                 until Doc_Cabecera.NEXT = 0;
//     end;



//     procedure InitLogInteraction()
//     begin
//         LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
//     end;

//     LOCAL procedure IsReportInPreviewMode(): Boolean;
//     var
//         //       MailManagement@1000 :
//         MailManagement: Codeunit 9520;
//     begin
//         exit(CurrReport.PREVIEW or MailManagement.IsHandlingGetEmailBody);
//     end;

//     LOCAL procedure InitializeShipmentBuffer()
//     var
//         //       SalesShipmentHeader@1000 :
//         SalesShipmentHeader: Record 110;
//         //       TempSalesShipmentBuffer@1001 :
//         TempSalesShipmentBuffer: Record 7190 TEMPORARY;
//     begin
//         NextEntryNo := 1;
//         if Doc_Lineas."Shipment No." <> '' then
//             if SalesShipmentHeader.GET(Doc_Lineas."Shipment No.") then
//                 exit;

//         if Doc_Cabecera."Order No." = '' then
//             exit;

//         CASE Doc_Lineas.Type OF
//             Doc_Lineas.Type::Item:
//                 GenerateBufferFromValueEntry(Doc_Lineas);
//             Doc_Lineas.Type::"G/L Account", Doc_Lineas.Type::Resource,
//           Doc_Lineas.Type::"Charge (Item)", Doc_Lineas.Type::"Fixed Asset":
//                 GenerateBufferFromShipment(Doc_Lineas);
//         end;

//         SalesShipmentBuffer.RESET;
//         SalesShipmentBuffer.SETRANGE("Document No.", Doc_Lineas."Document No.");
//         SalesShipmentBuffer.SETRANGE("Line No.", Doc_Lineas."Line No.");
//         if SalesShipmentBuffer.FIND('-') then begin
//             TempSalesShipmentBuffer := SalesShipmentBuffer;
//             if SalesShipmentBuffer.NEXT = 0 then begin
//                 SalesShipmentBuffer.GET(
//                   TempSalesShipmentBuffer."Document No.", TempSalesShipmentBuffer."Line No.", TempSalesShipmentBuffer."Entry No.");
//                 SalesShipmentBuffer.DELETE;
//                 exit;
//             end;
//             SalesShipmentBuffer.CALCSUMS(Quantity);
//             if SalesShipmentBuffer.Quantity <> Doc_Lineas.Quantity then begin
//                 SalesShipmentBuffer.DELETEALL;
//                 exit;
//             end;
//         end;
//     end;

//     //     LOCAL procedure GenerateBufferFromValueEntry (SalesInvoiceLine2@1002 :
//     LOCAL procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record 113)
//     var
//         //       ValueEntry@1000 :
//         ValueEntry: Record 5802;
//         //       ItemLedgerEntry@1001 :
//         ItemLedgerEntry: Record 32;
//         //       TotalQuantity@1003 :
//         TotalQuantity: Decimal;
//         //       Quantity@1004 :
//         Quantity: Decimal;
//     begin
//         TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
//         ValueEntry.SETCURRENTKEY("Document No.");
//         ValueEntry.SETRANGE("Document No.", SalesInvoiceLine2."Document No.");
//         ValueEntry.SETRANGE("Posting Date", Doc_Cabecera."Posting Date");
//         ValueEntry.SETRANGE("Item Charge No.", '');
//         ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
//         if ValueEntry.FIND('-') then
//             repeat
//                 if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then begin
//                     if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
//                         Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
//                     else
//                         Quantity := ValueEntry."Invoiced Quantity";
//                     AddBufferEntry(
//                       SalesInvoiceLine2,
//                       -Quantity,
//                       ItemLedgerEntry."Posting Date");
//                     TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
//                 end;
//                 FirstValueEntryNo := ValueEntry."Entry No." + 1;
//             until (ValueEntry.NEXT = 0) or (TotalQuantity = 0);
//     end;

//     //     LOCAL procedure GenerateBufferFromShipment (SalesInvoiceLine@1000 :
//     LOCAL procedure GenerateBufferFromShipment(SalesInvoiceLine: Record 113)
//     var
//         //       SalesInvoiceHeader@1001 :
//         SalesInvoiceHeader: Record 112;
//         //       SalesInvoiceLine2@1002 :
//         SalesInvoiceLine2: Record 113;
//         //       SalesShipmentHeader@1006 :
//         SalesShipmentHeader: Record 110;
//         //       SalesShipmentLine@1004 :
//         SalesShipmentLine: Record 111;
//         //       TotalQuantity@1003 :
//         TotalQuantity: Decimal;
//         //       Quantity@1005 :
//         Quantity: Decimal;
//     begin
//         TotalQuantity := 0;
//         SalesInvoiceHeader.SETCURRENTKEY("Order No.");
//         SalesInvoiceHeader.SETFILTER("No.", '..%1', Doc_Cabecera."No.");
//         SalesInvoiceHeader.SETRANGE("Order No.", Doc_Cabecera."Order No.");
//         if SalesInvoiceHeader.FIND('-') then
//             repeat
//                 SalesInvoiceLine2.SETRANGE("Document No.", SalesInvoiceHeader."No.");
//                 SalesInvoiceLine2.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
//                 SalesInvoiceLine2.SETRANGE(Type, SalesInvoiceLine.Type);
//                 SalesInvoiceLine2.SETRANGE("No.", SalesInvoiceLine."No.");
//                 SalesInvoiceLine2.SETRANGE("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
//                 if SalesInvoiceLine2.FIND('-') then
//                     repeat
//                         TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
//                     until SalesInvoiceLine2.NEXT = 0;
//             until SalesInvoiceHeader.NEXT = 0;

//         SalesShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
//         SalesShipmentLine.SETRANGE("Order No.", Doc_Cabecera."Order No.");
//         SalesShipmentLine.SETRANGE("Order Line No.", SalesInvoiceLine."Line No.");
//         SalesShipmentLine.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
//         SalesShipmentLine.SETRANGE(Type, SalesInvoiceLine.Type);
//         SalesShipmentLine.SETRANGE("No.", SalesInvoiceLine."No.");
//         SalesShipmentLine.SETRANGE("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
//         SalesShipmentLine.SETFILTER(Quantity, '<>%1', 0);

//         if SalesShipmentLine.FIND('-') then
//             repeat
//                 if Doc_Cabecera."Get Shipment Used" then
//                     CorrectShipment(SalesShipmentLine);
//                 if ABS(SalesShipmentLine.Quantity) <= ABS(TotalQuantity - SalesInvoiceLine.Quantity) then
//                     TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
//                 else begin
//                     if ABS(SalesShipmentLine.Quantity) > ABS(TotalQuantity) then
//                         SalesShipmentLine.Quantity := TotalQuantity;
//                     Quantity :=
//                       SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

//                     TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
//                     SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

//                     if SalesShipmentHeader.GET(SalesShipmentLine."Document No.") then
//                         AddBufferEntry(
//                           SalesInvoiceLine,
//                           Quantity,
//                           SalesShipmentHeader."Posting Date");
//                 end;
//             until (SalesShipmentLine.NEXT = 0) or (TotalQuantity = 0);
//     end;

//     //     LOCAL procedure CorrectShipment (var SalesShipmentLine@1001 :
//     LOCAL procedure CorrectShipment(var SalesShipmentLine: Record 111)
//     var
//         //       SalesInvoiceLine@1000 :
//         SalesInvoiceLine: Record 113;
//     begin
//         SalesInvoiceLine.SETCURRENTKEY("Shipment No.", "Shipment Line No.");
//         SalesInvoiceLine.SETRANGE("Shipment No.", SalesShipmentLine."Document No.");
//         SalesInvoiceLine.SETRANGE("Shipment Line No.", SalesShipmentLine."Line No.");
//         if SalesInvoiceLine.FIND('-') then
//             repeat
//                 SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
//             until SalesInvoiceLine.NEXT = 0;
//     end;

//     //     LOCAL procedure AddBufferEntry (SalesInvoiceLine@1001 : Record 113;QtyOnShipment@1002 : Decimal;PostingDate@1003 :
//     LOCAL procedure AddBufferEntry(SalesInvoiceLine: Record 113; QtyOnShipment: Decimal; PostingDate: Date)
//     begin
//         SalesShipmentBuffer.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
//         SalesShipmentBuffer.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
//         SalesShipmentBuffer.SETRANGE("Posting Date", PostingDate);
//         if SalesShipmentBuffer.FIND('-') then begin
//             SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
//             SalesShipmentBuffer.MODIFY;
//             exit;
//         end;

//         WITH SalesShipmentBuffer DO begin
//             "Document No." := SalesInvoiceLine."Document No.";
//             "Line No." := SalesInvoiceLine."Line No.";
//             "Entry No." := NextEntryNo;
//             Type := SalesInvoiceLine.Type;
//             "No." := SalesInvoiceLine."No.";
//             Quantity := QtyOnShipment;
//             "Posting Date" := PostingDate;
//             INSERT;
//             NextEntryNo := NextEntryNo + 1
//         end;
//     end;

//     LOCAL procedure DocumentCaption(): Text[250];
//     var
//         //       DocCaption@1000 :
//         DocCaption: Text;
//     begin
//         if DocCaption <> '' then
//             exit(DocCaption);
//         if Doc_Cabecera."Prepayment Invoice" then
//             exit(Text010);
//         exit(Text004);
//     end;

//     procedure GetCarteraInvoice(): Boolean;
//     var
//         //       CustLedgEntry@1000 :
//         CustLedgEntry: Record 21;
//     begin
//         WITH CustLedgEntry DO begin
//             SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
//             SETRANGE("Document Type", "Document Type"::Invoice);
//             SETRANGE("Document No.", Doc_Cabecera."No.");
//             SETRANGE("Customer No.", Doc_Cabecera."Bill-to Customer No.");
//             SETRANGE("Posting Date", Doc_Cabecera."Posting Date");
//             if FINDFIRST then
//                 if "Document Situation" = "Document Situation"::" " then
//                     exit(FALSE)
//                 else
//                     exit(TRUE)
//             else
//                 exit(FALSE);
//         end;
//     end;

//     //     procedure ShowCashAccountingCriteria (SalesInvoiceHeader@1100002 :
//     procedure ShowCashAccountingCriteria(SalesInvoiceHeader: Record 112): Text;
//     var
//         //       VATEntry@1100000 :
//         VATEntry: Record 254;
//     begin
//         GLSetup.GET;
//         if not GLSetup."Unrealized VAT" then
//             exit;
//         CACCaptionLbl := '';
//         VATEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
//         VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::Invoice);
//         if VATEntry.FINDSET then
//             repeat
//                 if VATEntry."VAT Cash Regime" then
//                     CACCaptionLbl := CACTxt;
//             until (VATEntry.NEXT = 0) or (CACCaptionLbl <> '');
//         exit(CACCaptionLbl);
//     end;


//     //     procedure InitializeRequest (NewNoOfCopies@1000 : Integer;NewShowInternalInfo@1001 : Boolean;NewLogInteraction@1002 : Boolean;DisplayAsmInfo@1003 :
//     procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
//     begin
//         NoOfCopies := NewNoOfCopies;
//         ShowInternalInfo := NewShowInternalInfo;
//         LogInteraction := NewLogInteraction;
//         DisplayAssemblyInformation := DisplayAsmInfo;
//     end;

//     //     LOCAL procedure FormatDocumentFields (SalesInvoiceHeader@1000 :
//     LOCAL procedure FormatDocumentFields(SalesInvoiceHeader: Record 112)
//     begin
//         WITH SalesInvoiceHeader DO begin
//             FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
//             FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
//             FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
//             FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
//             if "Payment Method Code" = '' then
//                 PaymentMethod.INIT
//             else
//                 PaymentMethod.GET("Payment Method Code");

//             OrderNoText := FormatDocument.SetText("Order No." <> '', FIELDCAPTION("Order No."));
//             ReferenceText := FormatDocument.SetText("Your Reference" <> '', FIELDCAPTION("Your Reference"));
//             VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FIELDCAPTION("VAT Registration No."));
//         end;

//         //Total l¡neas
//         TotalExclVATText := STRSUBSTNO('Importe Total %1', SalesInvoiceHeader."Currency Code");
//     end;

//     //     LOCAL procedure FormatAddressFields (SalesInvoiceHeader@1000 :
//     LOCAL procedure FormatAddressFields(SalesInvoiceHeader: Record 112)
//     begin
//         //FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
//         //FormatAddr.SalesInvBillTo(CustAddr,SalesInvoiceHeader);
//         ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, SalesInvoiceHeader);

//         CLEAR(CustAddr);
//         CustAddr[1] := COPYSTR(Doc_Cabecera."Bill-to Name" + ' ' + Doc_Cabecera."Bill-to Name 2", 1, 50);
//         CustAddr[2] := COPYSTR(Doc_Cabecera."Bill-to Address" + ' ' + Doc_Cabecera."Bill-to Address 2", 1, 50);
//         CustAddr[3] := COPYSTR(Doc_Cabecera."Bill-to Post Code" + ' ' + Doc_Cabecera."Bill-to City", 1, 50);
//         if (Doc_Cabecera."Bill-to County" <> '') and (Doc_Cabecera."Bill-to County" <> Doc_Cabecera."Bill-to City") then
//             CustAddr[3] := COPYSTR(CustAddr[3] + ' (' + Doc_Cabecera."Bill-to County" + ')', 1, 50);
//         CustAddr[4] += 'CIF/NIF ' + Doc_Cabecera."VAT Registration No.";


//         CLEAR(CompanyAddr);
//         CompanyAddr[1] := COPYSTR(CompanyInfo.Name + ' ' + CompanyInfo."Name 2", 1, 50);
//         CompanyAddr[2] := COPYSTR(DELCHR(CompanyInfo.Address + ' ' + CompanyInfo."Address 2", '<>', '') + ' ' +
//                                   CompanyInfo."Post Code" + ' ' + CompanyInfo.City, 1, 50);
//         CompanyAddr[3] := 'Tel: ' + CompanyInfo."Phone No." + ' Fax: ' + CompanyInfo."Fax No.";
//         CompanyAddr[4] := CompanyInfo."E-Mail" + '  CIF: ' + CompanyInfo."VAT Registration No.";
//     end;

//     LOCAL procedure CollectAsmInformation()
//     var
//         //       ValueEntry@1000 :
//         ValueEntry: Record 5802;
//         //       ItemLedgerEntry@1001 :
//         ItemLedgerEntry: Record 32;
//         //       PostedAsmHeader@1002 :
//         PostedAsmHeader: Record 910;
//         //       PostedAsmLine@1004 :
//         PostedAsmLine: Record 911;
//         //       SalesShipmentLine@1003 :
//         SalesShipmentLine: Record 111;
//     begin
//         TempPostedAsmLine.DELETEALL;
//         if Doc_Lineas.Type <> Doc_Lineas.Type::Item then
//             exit;
//         WITH ValueEntry DO begin
//             SETCURRENTKEY("Document No.");
//             SETRANGE("Document No.", Doc_Lineas."Document No.");
//             SETRANGE("Document Type", "Document Type"::"Sales Invoice");
//             SETRANGE("Document Line No.", Doc_Lineas."Line No.");
//             SETRANGE(Adjustment, FALSE);
//             if not FINDSET then
//                 exit;
//         end;
//         repeat
//             if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then
//                 if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
//                     SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
//                     if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
//                         PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
//                         if PostedAsmLine.FINDSET then
//                             repeat
//                                 TreatAsmLineBuffer(PostedAsmLine);
//                             until PostedAsmLine.NEXT = 0;
//                     end;
//                 end;
//         until ValueEntry.NEXT = 0;
//     end;

//     //     LOCAL procedure TreatAsmLineBuffer (PostedAsmLine@1000 :
//     LOCAL procedure TreatAsmLineBuffer(PostedAsmLine: Record 911)
//     begin
//         CLEAR(TempPostedAsmLine);
//         TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
//         TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
//         TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
//         TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
//         TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
//         if TempPostedAsmLine.FINDFIRST then begin
//             TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
//             TempPostedAsmLine.MODIFY;
//         end else begin
//             CLEAR(TempPostedAsmLine);
//             TempPostedAsmLine := PostedAsmLine;
//             TempPostedAsmLine.INSERT;
//         end;
//     end;

//     //     LOCAL procedure GetUOMText (UOMCode@1000 :
//     LOCAL procedure GetUOMText(UOMCode: Code[10]): Text[10];
//     var
//         //       UnitOfMeasure@1001 :
//         UnitOfMeasure: Record 204;
//     begin
//         if not UnitOfMeasure.GET(UOMCode) then
//             exit(UOMCode);
//         exit(UnitOfMeasure.Description);
//     end;


//     procedure BlanksForIndent(): Text[10];
//     begin
//         exit(PADSTR('', 2, ' '));
//     end;

//     //     LOCAL procedure GetLineFeeNoteOnReportHist (SalesInvoiceHeaderNo@1004 :
//     LOCAL procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
//     var
//         //       LineFeeNoteOnReportHist@1000 :
//         LineFeeNoteOnReportHist: Record 1053;
//         //       CustLedgerEntry@1003 :
//         CustLedgerEntry: Record 21;
//         //       Customer@1001 :
//         Customer: Record 18;
//     begin
//         TempLineFeeNoteOnReportHist.DELETEALL;
//         CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
//         CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeaderNo);
//         if not CustLedgerEntry.FINDFIRST then
//             exit;

//         if not Customer.GET(CustLedgerEntry."Customer No.") then
//             exit;

//         LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
//         LineFeeNoteOnReportHist.SETRANGE("Language Code", Customer."Language Code");
//         if LineFeeNoteOnReportHist.FINDSET then begin
//             repeat
//                 InsertTempLineFeeNoteOnReportHist(LineFeeNoteOnReportHist, TempLineFeeNoteOnReportHist);
//             until LineFeeNoteOnReportHist.NEXT = 0;
//         end else begin
//             //clarify with EU Team
//             // LineFeeNoteOnReportHist.SETRANGE("Language Code", Language.GetUserLanguage);
//             if LineFeeNoteOnReportHist.FINDSET then
//                 repeat
//                     InsertTempLineFeeNoteOnReportHist(LineFeeNoteOnReportHist, TempLineFeeNoteOnReportHist);
//                 until LineFeeNoteOnReportHist.NEXT = 0;
//         end;
//     end;

//     //     LOCAL procedure CalcVATAmountLineLCY (SalesInvoiceHeader@1003 : Record 112;TempVATAmountLine2@1001 : TEMPORARY Record 290;var TempVATAmountLineLCY2@1000 : TEMPORARY Record 290;var VATBaseRemainderAfterRoundingLCY2@1002 : Decimal;var AmtInclVATRemainderAfterRoundingLCY2@1005 :
//     LOCAL procedure CalcVATAmountLineLCY(SalesInvoiceHeader: Record 112; TempVATAmountLine2: Record 290 TEMPORARY; var TempVATAmountLineLCY2: Record 290 TEMPORARY; var VATBaseRemainderAfterRoundingLCY2: Decimal; var AmtInclVATRemainderAfterRoundingLCY2: Decimal)
//     var
//         //       VATBaseLCY@1004 :
//         VATBaseLCY: Decimal;
//         //       AmtInclVATLCY@1006 :
//         AmtInclVATLCY: Decimal;
//     begin
//         if (not GLSetup."Print VAT specification in LCY") or
//            (SalesInvoiceHeader."Currency Code" = '')
//         then
//             exit;

//         TempVATAmountLineLCY2.INIT;
//         TempVATAmountLineLCY2 := TempVATAmountLine2;
//         WITH SalesInvoiceHeader DO begin
//             VATBaseLCY :=
//               CurrExchRate.ExchangeAmtFCYToLCY(
//                 "Posting Date", "Currency Code", TempVATAmountLine2."VAT Base", "Currency Factor") +
//               VATBaseRemainderAfterRoundingLCY2;
//             AmtInclVATLCY :=
//               CurrExchRate.ExchangeAmtFCYToLCY(
//                 "Posting Date", "Currency Code", TempVATAmountLine2."Amount Including VAT", "Currency Factor") +
//               AmtInclVATRemainderAfterRoundingLCY2;
//         end;
//         TempVATAmountLineLCY2."VAT Base" := ROUND(VATBaseLCY);
//         TempVATAmountLineLCY2."Amount Including VAT" := ROUND(AmtInclVATLCY);
//         TempVATAmountLineLCY2.InsertLine;

//         VATBaseRemainderAfterRoundingLCY2 := VATBaseLCY - TempVATAmountLineLCY2."VAT Base";
//         AmtInclVATRemainderAfterRoundingLCY2 := AmtInclVATLCY - TempVATAmountLineLCY2."Amount Including VAT";
//     end;

//     //     LOCAL procedure InsertTempLineFeeNoteOnReportHist (var LineFeeNoteOnReportHist@1000 : Record 1053;var TempLineFeeNoteOnReportHist@1001 :
//     LOCAL procedure InsertTempLineFeeNoteOnReportHist(var LineFeeNoteOnReportHist: Record 1053; var TempLineFeeNoteOnReportHist: Record 1053 TEMPORARY)
//     begin
//         repeat
//             TempLineFeeNoteOnReportHist.INIT;
//             TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
//             TempLineFeeNoteOnReportHist.INSERT;
//         until TempLineFeeNoteOnReportHist.NEXT = 0;
//     end;

//     /*begin
//     end.
//   */

// }



