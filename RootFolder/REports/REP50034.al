// report 50034 "Vesta: Contrato Medicion real"
// {
  
  
//     CaptionML=ENU='Contract',ESP='Vesta: Contrato Medici¢n Real';
//     EnableHyperlinks=true;
//     PreviewMode=PrintLayout;
//     DefaultLayout=Word;
//     WordMergeDataItem="Purchase Header";
  
//   dataset
// {

// DataItem("Purchase Header";"Purchase Header")
// {

//                DataItemTableView=SORTING("Document Type","No.")
//                                  WHERE("Document Type"=FILTER("Order"|"Blanket Order"));
//                RequestFilterHeadingML=ENU='Standard Purchase - Order',ESP='Compra est ndar: pedido';
               

//                RequestFilterFields="No.","Buy-from Vendor No.","No. Printed";
// Column(CompanyAddress1;CompanyAddr[1])
// {
// //SourceExpr=CompanyAddr[1];
// }Column(CompanyAddress2;CompanyAddr[2])
// {
// //SourceExpr=CompanyAddr[2];
// }Column(CompanyAddress3;CompanyAddr[3])
// {
// //SourceExpr=CompanyAddr[3];
// }Column(CompanyAddress4;CompanyAddr[4])
// {
// //SourceExpr=CompanyAddr[4];
// }Column(CompanyAddress5;CompanyAddr[5])
// {
// //SourceExpr=CompanyAddr[5];
// }Column(CompanyAddress6;CompanyAddr[6])
// {
// //SourceExpr=CompanyAddr[6];
// }Column(CompanyHomePage_Lbl;HomePageCaptionLbl)
// {
// //SourceExpr=HomePageCaptionLbl;
// }Column(CompanyHomePage;CompanyInfo."Home Page")
// {
// //SourceExpr=CompanyInfo."Home Page";
// }Column(CompanyEmail_Lbl;EmailIDCaptionLbl)
// {
// //SourceExpr=EmailIDCaptionLbl;
// }Column(CompanyEMail;CompanyInfo."E-Mail")
// {
// //SourceExpr=CompanyInfo."E-Mail";
// }Column(CompanyPicture;CompanyInfo.Picture)
// {
// //SourceExpr=CompanyInfo.Picture;
// }Column(CompanyPhoneNo;CompanyInfo."Phone No.")
// {
// //SourceExpr=CompanyInfo."Phone No.";
// }Column(CompanyPhoneNo_Lbl;CompanyInfoPhoneNoCaptionLbl)
// {
// //SourceExpr=CompanyInfoPhoneNoCaptionLbl;
// }Column(CompanyGiroNo;CompanyInfo."Giro No.")
// {
// //SourceExpr=CompanyInfo."Giro No.";
// }Column(CompanyGiroNo_Lbl;CompanyInfoGiroNoCaptionLbl)
// {
// //SourceExpr=CompanyInfoGiroNoCaptionLbl;
// }Column(CompanyBankName;CompanyInfo."Bank Name")
// {
// //SourceExpr=CompanyInfo."Bank Name";
// }Column(CompanyBankName_Lbl;CompanyInfoBankNameCaptionLbl)
// {
// //SourceExpr=CompanyInfoBankNameCaptionLbl;
// }Column(CompanyBankBranchNo;CompanyInfo."Bank Branch No.")
// {
// //SourceExpr=CompanyInfo."Bank Branch No.";
// }Column(CompanyBankBranchNo_Lbl;CompanyInfo.FIELDCAPTION("Bank Branch No."))
// {
// //SourceExpr=CompanyInfo.FIELDCAPTION("Bank Branch No.");
// }Column(CompanyBankAccountNo;CompanyInfo."Bank Account No.")
// {
// //SourceExpr=CompanyInfo."Bank Account No.";
// }Column(CompanyBankAccountNo_Lbl;CompanyInfoBankAccNoCaptionLbl)
// {
// //SourceExpr=CompanyInfoBankAccNoCaptionLbl;
// }Column(CompanyIBAN;CompanyInfo.IBAN)
// {
// //SourceExpr=CompanyInfo.IBAN;
// }Column(CompanyIBAN_Lbl;CompanyInfo.FIELDCAPTION(IBAN))
// {
// //SourceExpr=CompanyInfo.FIELDCAPTION(IBAN);
// }Column(CompanySWIFT;CompanyInfo."SWIFT Code")
// {
// //SourceExpr=CompanyInfo."SWIFT Code";
// }Column(CompanySWIFT_Lbl;CompanyInfo.FIELDCAPTION("SWIFT Code"))
// {
// //SourceExpr=CompanyInfo.FIELDCAPTION("SWIFT Code");
// }Column(CompanyLogoPosition;CompanyLogoPosition)
// {
// //SourceExpr=CompanyLogoPosition;
// }Column(CompanyRegistrationNumber;CompanyInfo.GetRegistrationNumber)
// {
// //SourceExpr=CompanyInfo.GetRegistrationNumber;
// }Column(CompanyRegistrationNumber_Lbl;CompanyInfo.GetRegistrationNumberLbl)
// {
// //SourceExpr=CompanyInfo.GetRegistrationNumberLbl;
// }Column(CompanyVATRegNo;CompanyInfo.GetVATRegistrationNumber)
// {
// //SourceExpr=CompanyInfo.GetVATRegistrationNumber;
// }Column(CompanyVATRegNo_Lbl;CompanyInfo.GetVATRegistrationNumberLbl)
// {
// //SourceExpr=CompanyInfo.GetVATRegistrationNumberLbl;
// }Column(CompanyVATRegistrationNo;CompanyInfo.GetVATRegistrationNumber)
// {
// //SourceExpr=CompanyInfo.GetVATRegistrationNumber;
// }Column(CompanyVATRegistrationNo_Lbl;CompanyInfo.GetVATRegistrationNumberLbl)
// {
// //SourceExpr=CompanyInfo.GetVATRegistrationNumberLbl;
// }Column(CompanyLegalOffice;CompanyInfo.GetLegalOffice)
// {
// //SourceExpr=CompanyInfo.GetLegalOffice;
// }Column(CompanyLegalOffice_Lbl;CompanyInfo.GetLegalOfficeLbl)
// {
// //SourceExpr=CompanyInfo.GetLegalOfficeLbl;
// }Column(CompanyCustomGiro;CompanyInfo.GetCustomGiro)
// {
// //SourceExpr=CompanyInfo.GetCustomGiro;
// }Column(CompanyCustomGiro_Lbl;CompanyInfo.GetCustomGiroLbl)
// {
// //SourceExpr=CompanyInfo.GetCustomGiroLbl;
// }Column(Company_Representative;QuoBuildingSetup."Company Representative")
// {
// //SourceExpr=QuoBuildingSetup."Company Representative";
// }Column(Representative_VAT_Reg;QuoBuildingSetup."VAT Registration No. Represen.")
// {
// //SourceExpr=QuoBuildingSetup."VAT Registration No. Represen.";
// }Column(Commercial_Register;QuoBuildingSetup."Commercial Register")
// {
// //SourceExpr=QuoBuildingSetup."Commercial Register";
// }Column(Notary;QuoBuildingSetup.Notary)
// {
// //SourceExpr=QuoBuildingSetup.Notary;
// }Column(Notarial_Protocol;QuoBuildingSetup."Notarial Protocol")
// {
// //SourceExpr=QuoBuildingSetup."Notarial Protocol";
// }Column(CompanyPostCode;CompanyInfo."Post Code")
// {
// //SourceExpr=CompanyInfo."Post Code";
// }Column(CompanyNIF;CompanyInfo."VAT Registration No.")
// {
// //SourceExpr=CompanyInfo."VAT Registration No.";
// }Column(CompanyDireccion;CompanyInfo.Address)
// {
// //SourceExpr=CompanyInfo.Address;
// }Column(CompanyName;CompanyInfo.Name)
// {
// //SourceExpr=CompanyInfo.Name;
// }Column(CompanyCity;CompanyInfo.City)
// {
// //SourceExpr=CompanyInfo.City;
// }Column(PaymentRoutingNo_CompanyInfo;CompanyInfo."Payment Routing No.")
// {
// //SourceExpr=CompanyInfo."Payment Routing No.";
// }Column(DocType_PurchHeader;"Document Type")
// {
// //SourceExpr="Document Type";
// }Column(No_PurchHeader;"No.")
// {
// //SourceExpr="No.";
// }Column(DocumentTitle_Lbl;DocumentTitleLbl)
// {
// //SourceExpr=DocumentTitleLbl;
// }Column(Amount_Lbl;AmountCaptionLbl)
// {
// //SourceExpr=AmountCaptionLbl;
// }Column(PurchLineInvDiscAmt_Lbl;PurchLineInvDiscAmtCaptionLbl)
// {
// //SourceExpr=PurchLineInvDiscAmtCaptionLbl;
// }Column(Subtotal_Lbl;SubtotalCaptionLbl)
// {
// //SourceExpr=SubtotalCaptionLbl;
// }Column(VATAmtLineVAT_Lbl;VATAmtLineVATCaptionLbl)
// {
// //SourceExpr=VATAmtLineVATCaptionLbl;
// }Column(VATAmtLineVATAmt_Lbl;VATAmtLineVATAmtCaptionLbl)
// {
// //SourceExpr=VATAmtLineVATAmtCaptionLbl;
// }Column(VATAmtSpec_Lbl;VATAmtSpecCaptionLbl)
// {
// //SourceExpr=VATAmtSpecCaptionLbl;
// }Column(VATIdentifier_Lbl;VATIdentifierCaptionLbl)
// {
// //SourceExpr=VATIdentifierCaptionLbl;
// }Column(VATAmtLineInvDiscBaseAmt_Lbl;VATAmtLineInvDiscBaseAmtCaptionLbl)
// {
// //SourceExpr=VATAmtLineInvDiscBaseAmtCaptionLbl;
// }Column(VATAmtLineLineAmt_Lbl;VATAmtLineLineAmtCaptionLbl)
// {
// //SourceExpr=VATAmtLineLineAmtCaptionLbl;
// }Column(VALVATBaseLCY_Lbl;VALVATBaseLCYCaptionLbl)
// {
// //SourceExpr=VALVATBaseLCYCaptionLbl;
// }Column(Total_Lbl;TotalCaptionLbl)
// {
// //SourceExpr=TotalCaptionLbl;
// }Column(PaymentTermsDesc_Lbl;PaymentTermsDescCaptionLbl)
// {
// //SourceExpr=PaymentTermsDescCaptionLbl;
// }Column(ShipmentMethodDesc_Lbl;ShipmentMethodDescCaptionLbl)
// {
// //SourceExpr=ShipmentMethodDescCaptionLbl;
// }Column(PrepymtTermsDesc_Lbl;PrepymtTermsDescCaptionLbl)
// {
// //SourceExpr=PrepymtTermsDescCaptionLbl;
// }Column(HomePage_Lbl;HomePageCaptionLbl)
// {
// //SourceExpr=HomePageCaptionLbl;
// }Column(EmailID_Lbl;EmailIDCaptionLbl)
// {
// //SourceExpr=EmailIDCaptionLbl;
// }Column(AllowInvoiceDisc_Lbl;AllowInvoiceDiscCaptionLbl)
// {
// //SourceExpr=AllowInvoiceDiscCaptionLbl;
// }Column(CurrRepPageNo;STRSUBSTNO(PageLbl,FORMAT(CurrReport.PAGENO)))
// {
// //SourceExpr=STRSUBSTNO(PageLbl,FORMAT(CurrReport.PAGENO));
// }Column(DocumentDate;FORMAT("Document Date",0,'<Closing><Day> de <Month Text> de <Year4>'))
// {
// //SourceExpr=FORMAT("Document Date",0,'<Closing><Day> de <Month Text> de <Year4>');
// }Column(DueDate;FORMAT("Due Date",0,4))
// {
// //SourceExpr=FORMAT("Due Date",0,4);
// }Column(ExptRecptDt_PurchaseHeader;FORMAT("Expected Receipt Date",0,4))
// {
// //SourceExpr=FORMAT("Expected Receipt Date",0,4);
// }Column(OrderDate_PurchaseHeader;FORMAT("Order Date",0,4))
// {
// //SourceExpr=FORMAT("Order Date",0,4);
// }Column(VATNoText;VATNoText)
// {
// //SourceExpr=VATNoText;
// }Column(VATRegNo_PurchHeader;"VAT Registration No.")
// {
// //SourceExpr="VAT Registration No.";
// }Column(PurchaserText;PurchaserText)
// {
// //SourceExpr=PurchaserText;
// }Column(SalesPurchPersonName;SalespersonPurchaser.Name)
// {
// //SourceExpr=SalespersonPurchaser.Name;
// }Column(ReferenceText;ReferenceText)
// {
// //SourceExpr=ReferenceText;
// }Column(YourRef_PurchHeader;"Your Reference")
// {
// //SourceExpr="Your Reference";
// }Column(BuyFrmVendNo_PurchHeader;"Buy-from Vendor No.")
// {
// //SourceExpr="Buy-from Vendor No.";
// }Column(BuyFromAddr1;BuyFromAddr[1])
// {
// //SourceExpr=BuyFromAddr[1];
// }Column(BuyFromAddr2;BuyFromAddr[2])
// {
// //SourceExpr=BuyFromAddr[2];
// }Column(BuyFromAddr3;BuyFromAddr[3])
// {
// //SourceExpr=BuyFromAddr[3];
// }Column(BuyFromAddr4;BuyFromAddr[4])
// {
// //SourceExpr=BuyFromAddr[4];
// }Column(BuyFromAddr5;BuyFromAddr[5])
// {
// //SourceExpr=BuyFromAddr[5];
// }Column(BuyFromAddr6;BuyFromAddr[6])
// {
// //SourceExpr=BuyFromAddr[6];
// }Column(BuyFromAddr7;BuyFromAddr[7])
// {
// //SourceExpr=BuyFromAddr[7];
// }Column(BuyFromAddr8;BuyFromAddr[8])
// {
// //SourceExpr=BuyFromAddr[8];
// }Column(PricesIncludingVAT_Lbl;PricesIncludingVATCaptionLbl)
// {
// //SourceExpr=PricesIncludingVATCaptionLbl;
// }Column(PricesInclVAT_PurchHeader;"Prices Including VAT")
// {
// //SourceExpr="Prices Including VAT";
// }Column(OutputNo;OutputNo)
// {
// //SourceExpr=OutputNo;
// }Column(VATBaseDisc_PurchHeader;"VAT Base Discount %")
// {
// //SourceExpr="VAT Base Discount %";
// }Column(PricesInclVATtxt;PricesInclVATtxtLbl)
// {
// //SourceExpr=PricesInclVATtxtLbl;
// }Column(PaymentTermsDesc;PaymentTerms.Description)
// {
// //SourceExpr=PaymentTerms.Description;
// }Column(ShipmentMethodDesc;ShipmentMethod.Description)
// {
// //SourceExpr=ShipmentMethod.Description;
// }Column(PrepmtPaymentTermsDesc;PrepmtPaymentTerms.Description)
// {
// //SourceExpr=PrepmtPaymentTerms.Description;
// }Column(DimText;DimText)
// {
// //SourceExpr=DimText;
// }Column(OrderNo_Lbl;OrderNoCaptionLbl)
// {
// //SourceExpr=OrderNoCaptionLbl;
// }Column(Page_Lbl;PageCaptionLbl)
// {
// //SourceExpr=PageCaptionLbl;
// }Column(DocumentDate_Lbl;DocumentDateCaptionLbl)
// {
// //SourceExpr=DocumentDateCaptionLbl;
// }Column(BuyFrmVendNo_PurchHeader_Lbl;FIELDCAPTION("Buy-from Vendor No."))
// {
// //SourceExpr=FIELDCAPTION("Buy-from Vendor No.");
// }Column(PricesInclVAT_PurchHeader_Lbl;FIELDCAPTION("Prices Including VAT"))
// {
// //SourceExpr=FIELDCAPTION("Prices Including VAT");
// }Column(Receiveby_Lbl;ReceivebyCaptionLbl)
// {
// //SourceExpr=ReceivebyCaptionLbl;
// }Column(Buyer_Lbl;BuyerCaptionLbl)
// {
// //SourceExpr=BuyerCaptionLbl;
// }Column(PayToVendNo_PurchHeader;"Pay-to Vendor No.")
// {
// //SourceExpr="Pay-to Vendor No.";
// }Column(VendAddr8;VendAddr[8])
// {
// //SourceExpr=VendAddr[8];
// }Column(VendAddr7;VendAddr[7])
// {
// //SourceExpr=VendAddr[7];
// }Column(VendAddr6;VendAddr[6])
// {
// //SourceExpr=VendAddr[6];
// }Column(VendAddr5;VendAddr[5])
// {
// //SourceExpr=VendAddr[5];
// }Column(VendAddr4;VendAddr[4])
// {
// //SourceExpr=VendAddr[4];
// }Column(VendAddr3;VendAddr[3])
// {
// //SourceExpr=VendAddr[3];
// }Column(VendAddr2;VendAddr[2])
// {
// //SourceExpr=VendAddr[2];
// }Column(VendAddr1;VendAddr[1])
// {
// //SourceExpr=VendAddr[1];
// }Column(VendorName;Vendor.Name)
// {
// //SourceExpr=Vendor.Name;
// }Column(VendorName2;Vendor."Name 2")
// {
// //SourceExpr=Vendor."Name 2";
// }Column(VendorDireccion;Vendor.Address)
// {
// //SourceExpr=Vendor.Address;
// }Column(VendorCity;Vendor.City)
// {
// //SourceExpr=Vendor.City;
// }Column(VendorRegistroMercantil;Vendor."QB Business Registration")
// {
// //SourceExpr=Vendor."QB Business Registration";
// }Column(VendorNIF;Vendor."VAT Registration No.")
// {
// //SourceExpr=Vendor."VAT Registration No.";
// }Column(VendorNombreRepresentante;Contact.Name)
// {
// //SourceExpr=Contact.Name;
// }Column(VendorNIFRepresentante;Contact."VAT Registration No.")
// {
// //SourceExpr=Contact."VAT Registration No.";
// }Column(VendorNotario;Vendor."QB Before the notary")
// {
// //SourceExpr=Vendor."QB Before the notary";
// }Column(VendorNIFNotario;Vendor."OLD_QB VAT Registr No. Attorn")
// {
// //SourceExpr=Vendor."OLD_QB VAT Registr No. Attorn";
// }Column(VendorProtocolo;Vendor."QB Protocol No.")
// {
// //SourceExpr=Vendor."QB Protocol No.";
// }Column(VendorFechaProtocolo;FORMAT(Vendor."QB Establishment Date",0,'<Closing><Day> de <Month Text> de <Year4>'))
// {
// //SourceExpr=FORMAT(Vendor."QB Establishment Date",0,'<Closing><Day> de <Month Text> de <Year4>');
// }Column(PaymentDetails_Lbl;PaymentDetailsCaptionLbl)
// {
// //SourceExpr=PaymentDetailsCaptionLbl;
// }Column(VendNo_Lbl;VendNoCaptionLbl)
// {
// //SourceExpr=VendNoCaptionLbl;
// }Column(SellToCustNo_PurchHeader;"Sell-to Customer No.")
// {
// //SourceExpr="Sell-to Customer No.";
// }Column(ShipToAddr1;ShipToAddr[1])
// {
// //SourceExpr=ShipToAddr[1];
// }Column(ShipToAddr2;ShipToAddr[2])
// {
// //SourceExpr=ShipToAddr[2];
// }Column(ShipToAddr3;ShipToAddr[3])
// {
// //SourceExpr=ShipToAddr[3];
// }Column(ShipToAddr4;ShipToAddr[4])
// {
// //SourceExpr=ShipToAddr[4];
// }Column(ShipToAddr5;ShipToAddr[5])
// {
// //SourceExpr=ShipToAddr[5];
// }Column(ShipToAddr6;ShipToAddr[6])
// {
// //SourceExpr=ShipToAddr[6];
// }Column(ShipToAddr7;ShipToAddr[7])
// {
// //SourceExpr=ShipToAddr[7];
// }Column(ShipToAddr8;ShipToAddr[8])
// {
// //SourceExpr=ShipToAddr[8];
// }Column(ShiptoAddress_Lbl;ShiptoAddressCaptionLbl)
// {
// //SourceExpr=ShiptoAddressCaptionLbl;
// }Column(SellToCustNo_PurchHeader_Lbl;FIELDCAPTION("Sell-to Customer No."))
// {
// //SourceExpr=FIELDCAPTION("Sell-to Customer No.");
// }Column(ItemNumber_Lbl;ItemNumberCaptionLbl)
// {
// //SourceExpr=ItemNumberCaptionLbl;
// }Column(ItemDescription_Lbl;ItemDescriptionCaptionLbl)
// {
// //SourceExpr=ItemDescriptionCaptionLbl;
// }Column(ItemQuantity_Lbl;ItemQuantityCaptionLbl)
// {
// //SourceExpr=ItemQuantityCaptionLbl;
// }Column(ItemUnit_Lbl;ItemUnitCaptionLbl)
// {
// //SourceExpr=ItemUnitCaptionLbl;
// }Column(ItemUnitPrice_Lbl;ItemUnitPriceCaptionLbl)
// {
// //SourceExpr=ItemUnitPriceCaptionLbl;
// }Column(ItemLineAmount_Lbl;ItemLineAmountCaptionLbl)
// {
// //SourceExpr=ItemLineAmountCaptionLbl;
// }Column(ToCaption_Lbl;ToCaptionLbl)
// {
// //SourceExpr=ToCaptionLbl;
// }Column(VendorIDCaption_Lbl;VendorIDCaptionLbl)
// {
// //SourceExpr=VendorIDCaptionLbl;
// }Column(ConfirmToCaption_Lbl;ConfirmToCaptionLbl)
// {
// //SourceExpr=ConfirmToCaptionLbl;
// }Column(PurchOrderCaption_Lbl;PurchOrderCaptionLbl)
// {
// //SourceExpr=PurchOrderCaptionLbl;
// }Column(PurchOrderNumCaption_Lbl;PurchOrderNumCaptionLbl)
// {
// //SourceExpr=PurchOrderNumCaptionLbl;
// }Column(PurchOrderDateCaption_Lbl;PurchOrderDateCaptionLbl)
// {
// //SourceExpr=PurchOrderDateCaptionLbl;
// }Column(TaxIdentTypeCaption_Lbl;TaxIdentTypeCaptionLbl)
// {
// //SourceExpr=TaxIdentTypeCaptionLbl;
// }Column(OrderDate_Lbl;OrderDateLbl)
// {
// //SourceExpr=OrderDateLbl;
// }Column(PaymentMethodDescription;PaymentMethod.Description)
// {
// //SourceExpr=PaymentMethod.Description;
// }Column(PorcentajeRetencionHeader;PercWithholding)
// {
// //SourceExpr=PercWithholding;
// }Column(TiempoGarant¡a;WarrantyTime)
// {
// //SourceExpr=WarrantyTime;
// }Column(JobNo;"Purchase Header"."QB Job No.")
// {
// //SourceExpr="Purchase Header"."QB Job No.";
// }Column(diapago;diapago)
// {
// //SourceExpr=diapago;
// }DataItem("Purchase Line";"Purchase Line")
// {

//                DataItemTableView=SORTING("Document Type","Document No.","Line No.");
// DataItemLink="Document Type"= FIELD("Document Type"),
//                             "Document No."= FIELD("No.");
// Column(LineNo_PurchLine;"Line No.")
// {
// //SourceExpr="Line No.";
// }Column(AllowInvDisctxt;AllowInvDisctxt)
// {
// //SourceExpr=AllowInvDisctxt;
// }Column(Type_PurchLine;FORMAT(Type,0,2))
// {
// //SourceExpr=FORMAT(Type,0,2);
// }Column(No_PurchLine;"No.")
// {
// //SourceExpr="No.";
// }Column(Desc_PurchLine;Description)
// {
// //SourceExpr=Description;
// }Column(Qty_PurchLine;Quantity)
// {
// //SourceExpr=Quantity;
// }Column(UOM_PurchLine;"Unit of Measure")
// {
// //SourceExpr="Unit of Measure";
// }Column(DirUnitCost_PurchLine;"Direct Unit Cost")
// {
// //SourceExpr="Direct Unit Cost";
//                AutoFormatType=2;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(LineDisc_PurchLine;"Line Discount %")
// {
// //SourceExpr="Line Discount %";
// }Column(LineAmt_PurchLine;"Line Amount")
// {
// //SourceExpr="Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(AllowInvDisc_PurchLine;"Allow Invoice Disc.")
// {
// //SourceExpr="Allow Invoice Disc.";
// }Column(VATIdentifier_PurchLine;"VAT Identifier")
// {
// //SourceExpr="VAT Identifier";
// }Column(InvDiscAmt_PurchLine;-"Inv. Discount Amount")
// {
// //SourceExpr=-"Inv. Discount Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Currency Code";
// }Column(TotalInclVAT;"Line Amount" - "Inv. Discount Amount")
// {
// //SourceExpr="Line Amount" - "Inv. Discount Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(DirectUniCost_Lbl;DirectUniCostCaptionLbl)
// {
// //SourceExpr=DirectUniCostCaptionLbl;
// }Column(PurchLineLineDisc_Lbl;PurchLineLineDiscCaptionLbl)
// {
// //SourceExpr=PurchLineLineDiscCaptionLbl;
// }Column(VATDiscountAmount_Lbl;VATDiscountAmountCaptionLbl)
// {
// //SourceExpr=VATDiscountAmountCaptionLbl;
// }Column(No_PurchLine_Lbl;FIELDCAPTION("No."))
// {
// //SourceExpr=FIELDCAPTION("No.");
// }Column(Desc_PurchLine_Lbl;FIELDCAPTION(Description))
// {
// //SourceExpr=FIELDCAPTION(Description);
// }Column(Qty_PurchLine_Lbl;FIELDCAPTION(Quantity))
// {
// //SourceExpr=FIELDCAPTION(Quantity);
// }Column(UOM_PurchLine_Lbl;ItemUnitOfMeasureCaptionLbl)
// {
// //SourceExpr=ItemUnitOfMeasureCaptionLbl;
// }Column(VATIdentifier_PurchLine_Lbl;FIELDCAPTION("VAT Identifier"))
// {
// //SourceExpr=FIELDCAPTION("VAT Identifier");
// }Column(AmountIncludingVAT;"Amount Including VAT")
// {
// //SourceExpr="Amount Including VAT";
// }Column(TotalPriceCaption_Lbl;TotalPriceCaptionLbl)
// {
// //SourceExpr=TotalPriceCaptionLbl;
// }Column(InvDiscCaption_Lbl;InvDiscCaptionLbl)
// {
// //SourceExpr=InvDiscCaptionLbl;
// }Column(Piecework_No;"Piecework No.")
// {
// //SourceExpr="Piecework No.";
// }Column(RetencionesLinea;"QW % Withholding by GE")
// {
// //SourceExpr="QW % Withholding by GE";
// }DataItem("Totals";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
//                ;
// Column(VATAmountText;TempVATAmountLine.VATAmountText)
// {
// //SourceExpr=TempVATAmountLine.VATAmountText;
// }Column(TotalVATAmount;VATAmount)
// {
// //SourceExpr=VATAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalVATDiscountAmount;-VATDiscountAmount)
// {
// //SourceExpr=-VATDiscountAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalVATBaseAmount;VATBaseAmount)
// {
// //SourceExpr=VATBaseAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalAmountInclVAT;TotalAmountInclVAT)
// {
// //SourceExpr=TotalAmountInclVAT;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalInclVATText;TotalInclVATText)
// {
// //SourceExpr=TotalInclVATText;
// }Column(TotalExclVATText;TotalExclVATText)
// {
// //SourceExpr=TotalExclVATText;
// }Column(TotalSubTotal;TotalSubTotal)
// {
// //SourceExpr=TotalSubTotal;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalInvoiceDiscountAmount;TotalInvoiceDiscountAmount)
// {
// //SourceExpr=TotalInvoiceDiscountAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalAmount;TotalAmount)
// {
// //SourceExpr=TotalAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalText;TotalText)
// {
// //SourceExpr=TotalText;
// }DataItem("VATCounter";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(VATAmtLineVATBase;TempVATAmountLine."VAT Base")
// {
// //SourceExpr=TempVATAmountLine."VAT Base";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineVATAmt;TempVATAmountLine."VAT Amount")
// {
// //SourceExpr=TempVATAmountLine."VAT Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineLineAmt;TempVATAmountLine."Line Amount")
// {
// //SourceExpr=TempVATAmountLine."Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineInvDiscBaseAmt;TempVATAmountLine."Inv. Disc. Base Amount")
// {
// //SourceExpr=TempVATAmountLine."Inv. Disc. Base Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineInvDiscAmt;TempVATAmountLine."Invoice Discount Amount")
// {
// //SourceExpr=TempVATAmountLine."Invoice Discount Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineVAT;TempVATAmountLine."VAT %")
// {
// DecimalPlaces=0:5;
//                //SourceExpr=TempVATAmountLine."VAT %";
// }Column(VATAmtLineVATIdentifier;TempVATAmountLine."VAT Identifier")
// {
// //SourceExpr=TempVATAmountLine."VAT Identifier";
// }DataItem("VATCounterLCY";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(VALExchRate;VALExchRate)
// {
// //SourceExpr=VALExchRate;
// }Column(VALSpecLCYHeader;VALSpecLCYHeader)
// {
// //SourceExpr=VALSpecLCYHeader;
// }Column(VALVATAmountLCY;VALVATAmountLCY)
// {
// //SourceExpr=VALVATAmountLCY;
//                AutoFormatType=1;
// }Column(VALVATBaseLCY;VALVATBaseLCY)
// {
// //SourceExpr=VALVATBaseLCY;
//                AutoFormatType=1;
// }DataItem("PrepmtLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=FILTER(1..));
//                ;
// Column(PrepmtLineAmount;PrepmtLineAmount)
// {
// //SourceExpr=PrepmtLineAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtInvBufGLAccNo;TempPrepaymentInvLineBuffer."G/L Account No.")
// {
// //SourceExpr=TempPrepaymentInvLineBuffer."G/L Account No.";
// }Column(PrepmtInvBufDesc;TempPrepaymentInvLineBuffer.Description)
// {
// //SourceExpr=TempPrepaymentInvLineBuffer.Description;
// }Column(TotalInclVATText2;TotalInclVATText)
// {
// //SourceExpr=TotalInclVATText;
// }Column(TotalExclVATText2;TotalExclVATText)
// {
// //SourceExpr=TotalExclVATText;
// }Column(PrepmtInvBufAmt;TempPrepaymentInvLineBuffer.Amount)
// {
// //SourceExpr=TempPrepaymentInvLineBuffer.Amount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmountText;TempPrepmtVATAmountLine.VATAmountText)
// {
// //SourceExpr=TempPrepmtVATAmountLine.VATAmountText;
// }Column(PrepmtVATAmount;PrepmtVATAmount)
// {
// //SourceExpr=PrepmtVATAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtTotalAmountInclVAT;PrepmtTotalAmountInclVAT)
// {
// //SourceExpr=PrepmtTotalAmountInclVAT;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATBaseAmount;PrepmtVATBaseAmount)
// {
// //SourceExpr=PrepmtVATBaseAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtInvBuDescCaption;PrepmtInvBuDescCaptionLbl)
// {
// //SourceExpr=PrepmtInvBuDescCaptionLbl;
// }Column(PrepmtInvBufGLAccNoCaption;PrepmtInvBufGLAccNoCaptionLbl)
// {
// //SourceExpr=PrepmtInvBufGLAccNoCaptionLbl;
// }Column(PrepaymentSpecCaption;PrepaymentSpecCaptionLbl)
// {
// //SourceExpr=PrepaymentSpecCaptionLbl;
// }DataItem("PrepmtVATCounter";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(PrepmtVATAmtLineVATAmt;TempPrepmtVATAmountLine."VAT Amount")
// {
// //SourceExpr=TempPrepmtVATAmountLine."VAT Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmtLineVATBase;TempPrepmtVATAmountLine."VAT Base")
// {
// //SourceExpr=TempPrepmtVATAmountLine."VAT Base";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmtLineLineAmt;TempPrepmtVATAmountLine."Line Amount")
// {
// //SourceExpr=TempPrepmtVATAmountLine."Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmtLineVAT;TempPrepmtVATAmountLine."VAT %")
// {
// DecimalPlaces=0:5;
//                //SourceExpr=TempPrepmtVATAmountLine."VAT %";
// }Column(PrepmtVATAmtLineVATId;TempPrepmtVATAmountLine."VAT Identifier")
// {
// //SourceExpr=TempPrepmtVATAmountLine."VAT Identifier";
// }Column(PrepymtVATAmtSpecCaption;PrepymtVATAmtSpecCaptionLbl)
// {
// //SourceExpr=PrepymtVATAmtSpecCaptionLbl;
// }DataItem("LetterText";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
// Column(GreetingText;GreetingLbl)
// {
// //SourceExpr=GreetingLbl;
// }Column(BodyText;BodyLbl)
// {
// //SourceExpr=BodyLbl;
// }Column(ClosingText;ClosingLbl )
// {
// //SourceExpr=ClosingLbl ;
// }trigger OnPreDataItem();
//     BEGIN 
//                                SETRANGE(Number,1,TempPrepmtVATAmountLine.COUNT);
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   TempPrepmtVATAmountLine.GetLine(Number);
//                                 END;


// }trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number = 1 THEN BEGIN 
//                                     IF NOT TempPrepaymentInvLineBuffer.FIND('-') THEN
//                                       CurrReport.BREAK;
//                                   END ELSE
//                                     IF TempPrepaymentInvLineBuffer.NEXT = 0 THEN
//                                       CurrReport.BREAK;

//                                   IF "Purchase Header"."Prices Including VAT" THEN
//                                     PrepmtLineAmount := TempPrepaymentInvLineBuffer."Amount Incl. VAT"
//                                   ELSE
//                                     PrepmtLineAmount := TempPrepaymentInvLineBuffer.Amount;
//                                 END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                IF (NOT GLSetup."Print VAT specification in LCY") OR
//                                   ("Purchase Header"."Currency Code" = '') OR
//                                   (TempVATAmountLine.GetTotalVATAmount = 0)
//                                THEN
//                                  CurrReport.BREAK;

//                                SETRANGE(Number,1,TempVATAmountLine.COUNT);

//                                IF GLSetup."LCY Code" = '' THEN
//                                  VALSpecLCYHeader := VATAmountSpecificationLbl + LocalCurrentyLbl
//                                ELSE
//                                  VALSpecLCYHeader := VATAmountSpecificationLbl + FORMAT(GLSetup."LCY Code");

//                                CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
//                                VALExchRate := STRSUBSTNO(ExchangeRateLbl,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   TempVATAmountLine.GetLine(Number);
//                                   VALVATBaseLCY :=
//                                     TempVATAmountLine.GetBaseLCY(
//                                       "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
//                                   VALVATAmountLCY :=
//                                     TempVATAmountLine.GetAmountLCY(
//                                       "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
//                                 END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                IF VATAmount = 0 THEN
//                                  CurrReport.BREAK;
//                                SETRANGE(Number,1,TempVATAmountLine.COUNT);
//                                CurrReport.CREATETOTALS(
//                                  TempVATAmountLine."Line Amount",TempVATAmountLine."Inv. Disc. Base Amount",
//                                  TempVATAmountLine."Invoice Discount Amount",TempVATAmountLine."VAT Base",TempVATAmountLine."VAT Amount");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   TempVATAmountLine.GetLine(Number);
//                                 END;


// }trigger OnAfterGetRecord();
//     VAR
// //                                   TempPrepmtPurchLine@1000 :
//                                   TempPrepmtPurchLine: Record 39 TEMPORARY;
//                                 BEGIN 
//                                   CLEAR(TempPurchLine);
//                                   CLEAR(PurchPost);
//                                   TempPurchLine.DELETEALL;
//                                   TempVATAmountLine.DELETEALL;
//                                   PurchPost.GetPurchLines("Purchase Header",TempPurchLine,0);
//                                   TempPurchLine.CalcVATAmountLines(0,"Purchase Header",TempPurchLine,TempVATAmountLine);
//                                   TempPurchLine.UpdateVATOnLines(0,"Purchase Header",TempPurchLine,TempVATAmountLine);
//                                   VATAmount := TempVATAmountLine.GetTotalVATAmount;
//                                   VATBaseAmount := TempVATAmountLine.GetTotalVATBase;
//                                   VATDiscountAmount :=
//                                     TempVATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
//                                   TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT;

//                                   TempPrepaymentInvLineBuffer.DELETEALL;
//                                   PurchasePostPrepayments.GetPurchLines("Purchase Header",0,TempPrepmtPurchLine);
//                                   IF NOT TempPrepmtPurchLine.ISEMPTY THEN BEGIN 
//                                     PurchasePostPrepayments.GetPurchLinesToDeduct("Purchase Header",TempPurchLine);
//                                     IF NOT TempPurchLine.ISEMPTY THEN
//                                       PurchasePostPrepayments.CalcVATAmountLines("Purchase Header",TempPurchLine,TempPrePmtVATAmountLineDeduct,1);
//                                   END;
//                                   PurchasePostPrepayments.CalcVATAmountLines("Purchase Header",TempPrepmtPurchLine,TempPrepmtVATAmountLine,0);
//                                   TempPrepmtVATAmountLine.DeductVATAmountLine(TempPrePmtVATAmountLineDeduct);
//                                   PurchasePostPrepayments.UpdateVATOnLines("Purchase Header",TempPrepmtPurchLine,TempPrepmtVATAmountLine,0);
//                                   PurchasePostPrepayments.BuildInvLineBuffer2("Purchase Header",TempPrepmtPurchLine,0,TempPrepaymentInvLineBuffer);
//                                   PrepmtVATAmount := TempPrepmtVATAmountLine.GetTotalVATAmount;
//                                   PrepmtVATBaseAmount := TempPrepmtVATAmountLine.GetTotalVATBase;
//                                   PrepmtTotalAmountInclVAT := TempPrepmtVATAmountLine.GetTotalAmountInclVAT;
//                                 END;


// }trigger OnAfterGetRecord();
//     BEGIN 
//                                   AllowInvDisctxt := FORMAT("Allow Invoice Disc.");
//                                   TotalSubTotal += "Line Amount";
//                                   TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
//                                   TotalAmount += Amount;
//                                 END;


// }trigger OnAfterGetRecord();
//     VAR
// //                                   i@7001100 :
//                                   i: Integer;
//                                 BEGIN 
//                                   Vendor.GET("Purchase Header"."Pay-to Vendor No.");
//                                   IF NOT Contact.GET(Vendor."QB Representative 1") THEN
//                                     Contact.INIT;

//                                   IF PaymentMethod.GET(Vendor."Payment Method Code") THEN;
//                                   IF WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E","Purchase Header"."QW Cod. Withholding by GE") THEN BEGIN 
//                                     WarrantyTime := DELCHR(FORMAT(WithholdingGroup."Warranty Period"),'=',DELCHR(FORMAT(WithholdingGroup."Warranty Period"),'=','0123456789'));
//                                     PercWithholding := WithholdingGroup."Percentage Withholding";
//                                   END ELSE BEGIN 
//                                     WarrantyTime := '0';
//                                     PercWithholding := 0;
//                                   END;
//                                   TotalAmount := 0;
//                                   CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                                   FormatAddressFields("Purchase Header");
//                                   FormatDocumentFields("Purchase Header");

//                                   IF NOT CurrReport.PREVIEW THEN
//                                     IF LogInteraction THEN
//                                       SegManagement.LogDocument(
//                                         13,"No.",0,0,DATABASE::Vendor,"Buy-from Vendor No.",
//                                         "Purchaser Code",'',"Posting Description",'');

//                                   PaymentDay.RESET;
//                                   PaymentDay.SETRANGE(Code,CompanyInfo."Payment Days Code");
//                                   IF PaymentDay.FINDFIRST THEN
//                                     diapago := PaymentDay."Day of the month";
//                                 END;


// }
// }
// }
//   requestpage
//   {
// SaveValues=true;
      
//     layout
// {
// area(content)
// {
// group("group93")
// {
        
//                   CaptionML=ENU='Options',ESP='Opciones';
//     field("LogInteraction";"LogInteraction")
//     {
        
//                   CaptionML=ENU='Log Interaction',ESP='Log interacci¢n';
//                   ToolTipML=ENU='Specifies whether to log interaction.',ESP='Especifica si se debe registrar la interacci¢n.';
//                   ApplicationArea=Suite;
//                   Enabled=LogInteractionEnable 

//     ;
//     }

// }

// }
// }trigger OnInit()    BEGIN
//                LogInteractionEnable := TRUE;
//              END;

// trigger OnOpenPage()    BEGIN
//                    LogInteractionEnable := LogInteraction;
//                  END;


//   }
//   labels
// {
// }
  
//     var
// //       PageLbl@1040 :
//       PageLbl: 
// // "%1 = Page No."
// TextConst ENU='Page %1',ESP='P gina %1';
// //       VATAmountSpecificationLbl@1039 :
//       VATAmountSpecificationLbl: TextConst ENU='VAT Amount Specification in ',ESP='Especificaci¢n de importe de IVA en ';
// //       LocalCurrentyLbl@1038 :
//       LocalCurrentyLbl: TextConst ENU='Local Currency',ESP='Divisa local';
// //       ExchangeRateLbl@1037 :
//       ExchangeRateLbl: 
// // "%1 = CurrExchRate.""Relational Exch. Rate Amount"", %2 = CurrExchRate.""Exchange Rate Amount"""
// TextConst ENU='Exchange rate: %1/%2',ESP='Tipo cambio: %1/%2';
// //       CompanyInfoPhoneNoCaptionLbl@1036 :
//       CompanyInfoPhoneNoCaptionLbl: TextConst ENU='Phone No.',ESP='N.§ tel‚fono';
// //       CompanyInfoGiroNoCaptionLbl@1034 :
//       CompanyInfoGiroNoCaptionLbl: TextConst ENU='Giro No.',ESP='N.§ giro postal';
// //       CompanyInfoBankNameCaptionLbl@1033 :
//       CompanyInfoBankNameCaptionLbl: TextConst ENU='Bank',ESP='Banco';
// //       CompanyInfoBankAccNoCaptionLbl@1032 :
//       CompanyInfoBankAccNoCaptionLbl: TextConst ENU='Account No.',ESP='N§ cuenta';
// //       OrderNoCaptionLbl@1031 :
//       OrderNoCaptionLbl: TextConst ENU='Order No.',ESP='N§ pedido';
// //       PageCaptionLbl@1030 :
//       PageCaptionLbl: TextConst ENU='Page',ESP='P gina';
// //       DocumentDateCaptionLbl@1029 :
//       DocumentDateCaptionLbl: TextConst ENU='Document Date',ESP='Fecha de documento';
// //       DirectUniCostCaptionLbl@1027 :
//       DirectUniCostCaptionLbl: TextConst ENU='Unit Price',ESP='Precio venta';
// //       PurchLineLineDiscCaptionLbl@1026 :
//       PurchLineLineDiscCaptionLbl: TextConst ENU='Discount %',ESP='% Descuento';
// //       VATDiscountAmountCaptionLbl@1025 :
//       VATDiscountAmountCaptionLbl: TextConst ENU='Payment Discount on VAT',ESP='Descuento P.P. sobre IVA';
// //       PaymentDetailsCaptionLbl@1023 :
//       PaymentDetailsCaptionLbl: TextConst ENU='Payment Details',ESP='Detalles del pago';
// //       VendNoCaptionLbl@1022 :
//       VendNoCaptionLbl: TextConst ENU='Vendor No.',ESP='N.§ proveedor';
// //       ShiptoAddressCaptionLbl@1021 :
//       ShiptoAddressCaptionLbl: TextConst ENU='Ship-to Address',ESP='Direcci¢n de env¡o';
// //       PrepmtInvBuDescCaptionLbl@1020 :
//       PrepmtInvBuDescCaptionLbl: TextConst ENU='Description',ESP='Descripci¢n';
// //       PrepmtInvBufGLAccNoCaptionLbl@1019 :
//       PrepmtInvBufGLAccNoCaptionLbl: TextConst ENU='G/L Account No.',ESP='N§ cuenta';
// //       PrepaymentSpecCaptionLbl@1018 :
//       PrepaymentSpecCaptionLbl: TextConst ENU='Prepayment Specification',ESP='Especificaci¢n prepago';
// //       PrepymtVATAmtSpecCaptionLbl@1017 :
//       PrepymtVATAmtSpecCaptionLbl: TextConst ENU='Prepayment VAT Amount Specification',ESP='Especificaci¢n importe IVA prepago';
// //       AmountCaptionLbl@1016 :
//       AmountCaptionLbl: TextConst ENU='Amount',ESP='Importe';
// //       PurchLineInvDiscAmtCaptionLbl@1015 :
//       PurchLineInvDiscAmtCaptionLbl: TextConst ENU='Invoice Discount Amount',ESP='Importe descuento factura';
// //       SubtotalCaptionLbl@1014 :
//       SubtotalCaptionLbl: TextConst ENU='Subtotal',ESP='Subtotal';
// //       VATAmtLineVATCaptionLbl@1013 :
//       VATAmtLineVATCaptionLbl: TextConst ENU='VAT %',ESP='% IVA';
// //       VATAmtLineVATAmtCaptionLbl@1012 :
//       VATAmtLineVATAmtCaptionLbl: TextConst ENU='VAT Amount',ESP='Importe IVA';
// //       VATAmtSpecCaptionLbl@1011 :
//       VATAmtSpecCaptionLbl: TextConst ENU='VAT Amount Specification',ESP='Especificaci¢n importe IVA';
// //       VATIdentifierCaptionLbl@1010 :
//       VATIdentifierCaptionLbl: TextConst ENU='VAT Identifier',ESP='Identific. IVA';
// //       VATAmtLineInvDiscBaseAmtCaptionLbl@1009 :
//       VATAmtLineInvDiscBaseAmtCaptionLbl: TextConst ENU='Invoice Discount Base Amount',ESP='Importe base descuento factura';
// //       VATAmtLineLineAmtCaptionLbl@1008 :
//       VATAmtLineLineAmtCaptionLbl: TextConst ENU='Line Amount',ESP='Importe de l¡nea';
// //       VALVATBaseLCYCaptionLbl@1007 :
//       VALVATBaseLCYCaptionLbl: TextConst ENU='VAT Base',ESP='Base IVA';
// //       PricesInclVATtxtLbl@1048 :
//       PricesInclVATtxtLbl: TextConst ENU='Prices Including VAT',ESP='Precios IVA incluido';
// //       TotalCaptionLbl@1006 :
//       TotalCaptionLbl: TextConst ENU='Total',ESP='Total';
// //       PaymentTermsDescCaptionLbl@1005 :
//       PaymentTermsDescCaptionLbl: TextConst ENU='Payment Terms',ESP='Condiciones de pago';
// //       ShipmentMethodDescCaptionLbl@1004 :
//       ShipmentMethodDescCaptionLbl: TextConst ENU='Shipment Method',ESP='Condiciones env¡o';
// //       PrepymtTermsDescCaptionLbl@1003 :
//       PrepymtTermsDescCaptionLbl: TextConst ENU='Prepmt. Payment Terms',ESP='T‚rminos prepago';
// //       HomePageCaptionLbl@1002 :
//       HomePageCaptionLbl: TextConst ENU='Home Page',ESP='P gina Web';
// //       EmailIDCaptionLbl@1001 :
//       EmailIDCaptionLbl: TextConst ENU='Email',ESP='Correo electr¢nico';
// //       AllowInvoiceDiscCaptionLbl@1000 :
//       AllowInvoiceDiscCaptionLbl: TextConst ENU='Allow Invoice Discount',ESP='Permitir descuento factura';
// //       QuoBuildingSetup@1100286000 :
//       QuoBuildingSetup: Record 7207278;
// //       WithholdingGroup@7001102 :
//       WithholdingGroup: Record 7207330;
// //       PaymentMethod@7001101 :
//       PaymentMethod: Record 289;
// //       Vendor@7001100 :
//       Vendor: Record 23;
// //       GLSetup@1106 :
//       GLSetup: Record 98;
// //       CompanyInfo@1105 :
//       CompanyInfo: Record 79;
// //       ShipmentMethod@1104 :
//       ShipmentMethod: Record 10;
// //       PaymentTerms@1103 :
//       PaymentTerms: Record 3;
// //       PrepmtPaymentTerms@1102 :
//       PrepmtPaymentTerms: Record 3;
// //       SalespersonPurchaser@1101 :
//       SalespersonPurchaser: Record 13;
// //       TempVATAmountLine@1100 :
//       TempVATAmountLine: Record 290 TEMPORARY;
// //       TempPrepmtVATAmountLine@1099 :
//       TempPrepmtVATAmountLine: Record 290 TEMPORARY;
// //       TempPurchLine@1097 :
//       TempPurchLine: Record 39 TEMPORARY;
// //       TempPrepaymentInvLineBuffer@1093 :
//       TempPrepaymentInvLineBuffer: Record 461 TEMPORARY;
// //       TempPrePmtVATAmountLineDeduct@1035 :
//       TempPrePmtVATAmountLineDeduct: Record 290 TEMPORARY;
// //       RespCenter@1092 :
//       RespCenter: Record 5714;
// //       Language@1091 :
//       Language: Record 8;
// //       CurrExchRate@1090 :
//       CurrExchRate: Record 330;
// //       PurchSetup@1089 :
//       PurchSetup: Record 312;
// //       FormatAddr@1087 :
//       FormatAddr: Codeunit 365;
// //       FormatDocument@1086 :
//       FormatDocument: Codeunit 368;
// //       PurchPost@1085 :
//       PurchPost: Codeunit 90;
// //       SegManagement@1083 :
//       SegManagement: Codeunit 5051;
// //       PurchasePostPrepayments@1028 :
//       PurchasePostPrepayments: Codeunit 444;
// //       VendAddr@1081 :
//       VendAddr: ARRAY [8] OF Text[50];
// //       ShipToAddr@1080 :
//       ShipToAddr: ARRAY [8] OF Text[50];
// //       CompanyAddr@1079 :
//       CompanyAddr: ARRAY [8] OF Text[50];
// //       BuyFromAddr@1078 :
//       BuyFromAddr: ARRAY [8] OF Text[50];
// //       PurchaserText@1077 :
//       PurchaserText: Text[30];
// //       VATNoText@1076 :
//       VATNoText: Text[80];
// //       ReferenceText@1075 :
//       ReferenceText: Text[80];
// //       TotalText@1074 :
//       TotalText: Text[50];
// //       TotalInclVATText@1073 :
//       TotalInclVATText: Text[50];
// //       TotalExclVATText@1072 :
//       TotalExclVATText: Text[50];
// //       OutputNo@1067 :
//       OutputNo: Integer;
// //       DimText@1066 :
//       DimText: Text[120];
// //       LogInteraction@1061 :
//       LogInteraction: Boolean;
// //       VATAmount@1060 :
//       VATAmount: Decimal;
// //       VATBaseAmount@1059 :
//       VATBaseAmount: Decimal;
// //       VATDiscountAmount@1058 :
//       VATDiscountAmount: Decimal;
// //       TotalAmountInclVAT@1057 :
//       TotalAmountInclVAT: Decimal;
// //       VALVATBaseLCY@1056 :
//       VALVATBaseLCY: Decimal;
// //       VALVATAmountLCY@1055 :
//       VALVATAmountLCY: Decimal;
// //       VALSpecLCYHeader@1054 :
//       VALSpecLCYHeader: Text[80];
// //       VALExchRate@1053 :
//       VALExchRate: Text[50];
// //       PrepmtVATAmount@1052 :
//       PrepmtVATAmount: Decimal;
// //       PrepmtVATBaseAmount@1051 :
//       PrepmtVATBaseAmount: Decimal;
// //       PrepmtTotalAmountInclVAT@1050 :
//       PrepmtTotalAmountInclVAT: Decimal;
// //       PrepmtLineAmount@1049 :
//       PrepmtLineAmount: Decimal;
// //       AllowInvDisctxt@1047 :
//       AllowInvDisctxt: Text[30];
// //       LogInteractionEnable@1024 :
//       LogInteractionEnable: Boolean INDATASET;
// //       TotalSubTotal@1044 :
//       TotalSubTotal: Decimal;
// //       TotalAmount@1043 :
//       TotalAmount: Decimal;
// //       TotalInvoiceDiscountAmount@1042 :
//       TotalInvoiceDiscountAmount: Decimal;
// //       DocumentTitleLbl@1068 :
//       DocumentTitleLbl: TextConst ENU='Purchase Order',ESP='Pedido compra';
// //       CompanyLogoPosition@1069 :
//       CompanyLogoPosition: Integer;
// //       ReceivebyCaptionLbl@1071 :
//       ReceivebyCaptionLbl: TextConst ENU='Receive By',ESP='Recepci¢n por';
// //       BuyerCaptionLbl@1107 :
//       BuyerCaptionLbl: TextConst ENU='Buyer',ESP='Comprador';
// //       ItemNumberCaptionLbl@1108 :
//       ItemNumberCaptionLbl: TextConst ENU='Item No.',ESP='N.§ producto';
// //       ItemDescriptionCaptionLbl@1109 :
//       ItemDescriptionCaptionLbl: TextConst ENU='Description',ESP='Descripci¢n';
// //       ItemQuantityCaptionLbl@1110 :
//       ItemQuantityCaptionLbl: TextConst ENU='Quantity',ESP='Cantidad';
// //       ItemUnitCaptionLbl@1111 :
//       ItemUnitCaptionLbl: TextConst ENU='Unit',ESP='Unidad';
// //       ItemUnitPriceCaptionLbl@1112 :
//       ItemUnitPriceCaptionLbl: TextConst ENU='Unit Price',ESP='Precio venta';
// //       ItemLineAmountCaptionLbl@1113 :
//       ItemLineAmountCaptionLbl: TextConst ENU='Line Amount',ESP='Importe de l¡nea';
// //       PricesIncludingVATCaptionLbl@1114 :
//       PricesIncludingVATCaptionLbl: TextConst ENU='Prices Including VAT',ESP='Precios IVA incluido';
// //       ItemUnitOfMeasureCaptionLbl@1115 :
//       ItemUnitOfMeasureCaptionLbl: TextConst ENU='Unit',ESP='Unidad';
// //       ToCaptionLbl@1123 :
//       ToCaptionLbl: TextConst ENU='To:',ESP='Para:';
// //       VendorIDCaptionLbl@1122 :
//       VendorIDCaptionLbl: TextConst ENU='Vendor ID',ESP='Id. de proveedor';
// //       ConfirmToCaptionLbl@1121 :
//       ConfirmToCaptionLbl: TextConst ENU='Confirm To',ESP='Confirmar a';
// //       PurchOrderCaptionLbl@1120 :
//       PurchOrderCaptionLbl: TextConst ENU='PURCHASE ORDER',ESP='PEDIDO DE COMPRA';
// //       PurchOrderNumCaptionLbl@1119 :
//       PurchOrderNumCaptionLbl: TextConst ENU='Purchase Order Number:',ESP='N£mero de pedido de compra:';
// //       PurchOrderDateCaptionLbl@1118 :
//       PurchOrderDateCaptionLbl: TextConst ENU='Purchase Order Date:',ESP='Fecha de pedido de compra:';
// //       TaxIdentTypeCaptionLbl@1117 :
//       TaxIdentTypeCaptionLbl: TextConst ENU='Tax Ident. Type',ESP='Tipo de identificaci¢n fiscal';
// //       TotalPriceCaptionLbl@1126 :
//       TotalPriceCaptionLbl: TextConst ENU='Total Price',ESP='Precio total';
// //       InvDiscCaptionLbl@1124 :
//       InvDiscCaptionLbl: TextConst ENU='Invoice Discount:',ESP='Descuento en factura:';
// //       GreetingLbl@1062 :
//       GreetingLbl: TextConst ENU='Hello',ESP='Hola';
// //       ClosingLbl@1046 :
//       ClosingLbl: TextConst ENU='Sincerely',ESP='Un saludo,';
// //       BodyLbl@1045 :
//       BodyLbl: TextConst ENU='The purchase order is attached to this message.',ESP='El pedido de compra se adjunta a este mensaje.';
// //       OrderDateLbl@1041 :
//       OrderDateLbl: TextConst ENU='Order Date',ESP='Fecha pedido';
// //       PercWithholding@7001103 :
//       PercWithholding: Decimal;
// //       WarrantyTime@7001104 :
//       WarrantyTime: Text;
// //       PaymentDay@7001105 :
//       PaymentDay: Record 10701;
// //       diapago@7001106 :
//       diapago: Integer;
// //       Contact@100000000 :
//       Contact: Record 5050;

    

// trigger OnInitReport();    begin
//                    QuoBuildingSetup.GET;
//                    GLSetup.GET;
//                    CompanyInfo.GET;
//                    PurchSetup.GET;
//                    CompanyInfo.CALCFIELDS(Picture);
//                  end;

// trigger OnPreReport();    begin
//                   if not CurrReport.USEREQUESTPAGE then
//                     InitLogInteraction;
//                 end;



// // procedure InitializeRequest (LogInteractionParam@1003 :
// procedure InitializeRequest (LogInteractionParam: Boolean)
//     begin
//       LogInteraction := LogInteractionParam;
//     end;

// //     LOCAL procedure FormatAddressFields (var PurchaseHeader@1000 :
//     LOCAL procedure FormatAddressFields (var PurchaseHeader: Record 38)
//     begin
//       FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
//       FormatAddr.PurchHeaderBuyFrom(BuyFromAddr,PurchaseHeader);
//       if PurchaseHeader."Buy-from Vendor No." <> PurchaseHeader."Pay-to Vendor No." then
//         FormatAddr.PurchHeaderPayTo(VendAddr,PurchaseHeader);
//       FormatAddr.PurchHeaderShipTo(ShipToAddr,PurchaseHeader);
//     end;

// //     LOCAL procedure FormatDocumentFields (PurchaseHeader@1000 :
//     LOCAL procedure FormatDocumentFields (PurchaseHeader: Record 38)
//     begin
//       WITH PurchaseHeader DO begin
//         FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
//         FormatDocument.SetPurchaser(SalespersonPurchaser,"Purchaser Code",PurchaserText);
//         FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
//         FormatDocument.SetPaymentTerms(PrepmtPaymentTerms,"Prepmt. Payment Terms Code","Language Code");
//         FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

//         ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
//         VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
//       end;
//     end;

//     LOCAL procedure InitLogInteraction ()
//     begin
//       LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
//     end;

//     /*begin
//     end.
//   */
  
  
// }



