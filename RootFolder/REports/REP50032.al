// report 50032 "Vesta: Vale de Suministro"
// {


//     CaptionML=ENU='Purchase Order',ESP='Vesta: Vale de Suministro';
//     PreviewMode=PrintLayout;

//   dataset
// {

// DataItem("Purchase Header";"Purchase Header")
// {

//                DataItemTableView=SORTING("Document Type","No.")
//                                  WHERE("Document Type"=FILTER("Order"|"Blanket Order"));
//                RequestFilterHeadingML=ENU='Purchase Order',ESP='Pedido compra';


//                RequestFilterFields="No.","Buy-from Vendor No.","No. Printed";
// Column(DocType_PurchHeader;"Document Type")
// {
// //SourceExpr="Document Type";
// }Column(No_PurchHeader;"No.")
// {
// //SourceExpr="No.";
// }Column(HomepageCaption;HomepageCaptionLbl)
// {
// //SourceExpr=HomepageCaptionLbl;
// }Column(EmailCaption;EmailCaptionLbl)
// {
// //SourceExpr=EmailCaptionLbl;
// }Column(AmtCaption;AmtCaptionLbl)
// {
// //SourceExpr=AmtCaptionLbl;
// }Column(PaymentTermsCaption;PaymentTermsCaptionLbl)
// {
// //SourceExpr=PaymentTermsCaptionLbl;
// }Column(ShpMethodCaption;ShpMethodCaptionLbl)
// {
// //SourceExpr=ShpMethodCaptionLbl;
// }Column(PrePmtTermsDescCaption;PrePmtTermsDescCaptionLbl)
// {
// //SourceExpr=PrePmtTermsDescCaptionLbl;
// }Column(DocDateCaption;DocDateCaptionLbl)
// {
// //SourceExpr=DocDateCaptionLbl;
// }Column(AllowInvDiscCaption;AllowInvDiscCaptionLbl)
// {
// //SourceExpr=AllowInvDiscCaptionLbl;
// }Column(VendorData_Caption;VendorData)
// {
// //SourceExpr=VendorData;
// }Column(Nombre_Caption;Nombre_CaptionLbl)
// {
// //SourceExpr=Nombre_CaptionLbl;
// }Column(Direccion_Caption;Direccion_CaptionLbl)
// {
// //SourceExpr=Direccion_CaptionLbl;
// }Column(CIF_Caption;CIF_CaptionLbl)
// {
// //SourceExpr=CIF_CaptionLbl;
// }Column(Contacto_Caption;Contacto_CaptionLbl)
// {
// //SourceExpr=Contacto_CaptionLbl;
// }Column(Fecha_Caption;Fecha_CaptionLbl)
// {
// //SourceExpr=Fecha_CaptionLbl;
// }Column(NPedido_Caption;NPedido_CaptionLbl)
// {
// //SourceExpr=NPedido_CaptionLbl;
// }Column(Ampliacion_Caption;Ampliacion_CaptionLbl)
// {
// //SourceExpr=Ampliacion_CaptionLbl;
// }Column(FormaPago_Caption;FormaPago_CaptionLbl)
// {
// //SourceExpr=FormaPago_CaptionLbl;
// }Column(Retencion_Caption;Retencion_CaptionLbl)
// {
// //SourceExpr=Retencion_CaptionLbl;
// }Column(Obra_Caption;Obra_CaptionLbl)
// {
// //SourceExpr=Obra_CaptionLbl;
// }Column(FechaEntrega_Caption;FechaEntrega_CaptionLbl)
// {
// //SourceExpr=FechaEntrega_CaptionLbl;
// }Column(DireccionEntrega_Caption;DireccionEntrega_CaptionLbl)
// {
// //SourceExpr=DireccionEntrega_CaptionLbl;
// }Column(ContactoMayus_Caption;Contacto_Mayus)
// {
// //SourceExpr=Contacto_Mayus;
// }Column(CIFVendor;CIFVendor)
// {
// //SourceExpr=CIFVendor;
// }Column(TelefonoProv;TelefonoProv)
// {
// //SourceExpr=TelefonoProv;
// }Column(ContactoProv;ContactoProv)
// {
// //SourceExpr=ContactoProv;
// }Column(ContactoObra;ContactoObra)
// {
// //SourceExpr=ContactoObra;
// }Column(TelefonoObra;TelefonoObra)
// {
// //SourceExpr=TelefonoObra;
// }Column(CPObra;CPObra)
// {
// //SourceExpr=CPObra;
// }Column(PoblacionObra;PoblacionObra)
// {
// //SourceExpr=PoblacionObra;
// }Column(FechaInicio;FechaInicio)
// {
// //SourceExpr=FechaInicio;
// }Column(FechaFin;FechaFin)
// {
// //SourceExpr=FechaFin;
// }Column(DireccionEntrega;DireccionEntrega)
// {
// //SourceExpr=DireccionEntrega;
// }DataItem("CopyLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// DataItem("PageLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
//                ;
// Column(OrderCopyText;STRSUBSTNO(Text004,CopyText))
// {
// //SourceExpr=STRSUBSTNO(Text004,CopyText);
// }Column(CompanyAddr1;CompanyAddr[1])
// {
// //SourceExpr=CompanyAddr[1];
// }Column(CompanyAddr2;CompanyAddr[2])
// {
// //SourceExpr=CompanyAddr[2];
// }Column(CompanyAddr3;CompanyAddr[3])
// {
// //SourceExpr=CompanyAddr[3];
// }Column(CompanyAddr4;CompanyAddr[4])
// {
// //SourceExpr=CompanyAddr[4];
// }Column(CompanyInfoPicture;CompanyInfo.Picture)
// {
// //SourceExpr=CompanyInfo.Picture;
// }Column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
// {
// //SourceExpr=CompanyInfo."Phone No.";
// }Column(CompanyInfoHomepage;CompanyInfo."Home Page")
// {
// //SourceExpr=CompanyInfo."Home Page";
// }Column(CompanyInfoEmail;CompanyInfo."E-Mail")
// {
// //SourceExpr=CompanyInfo."E-Mail";
// }Column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
// {
// //SourceExpr=CompanyInfo."VAT Registration No.";
// }Column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
// {
// //SourceExpr=CompanyInfo."Giro No.";
// }Column(CompanyInfoBankName;CompanyInfo."Bank Name")
// {
// //SourceExpr=CompanyInfo."Bank Name";
// }Column(CompanyInfoBankAccNo;CompanyInfo."Bank Account No.")
// {
// //SourceExpr=CompanyInfo."Bank Account No.";
// }Column(CompanyInfoName;CompanyInfo.Name)
// {
// //SourceExpr=CompanyInfo.Name;
// }Column(CompanyInfoPaymentRountingNo;CompanyInfo."Payment Routing No.")
// {
// //SourceExpr=CompanyInfo."Payment Routing No.";
// }Column(CompanyInfoAddress;CompanyInfo.Address)
// {
// //SourceExpr=CompanyInfo.Address;
// }Column(CompanyInfoAddress2;CompanyInfo."Address 2")
// {
// //SourceExpr=CompanyInfo."Address 2";
// }Column(CompanyInfoCity;CompanyInfo.City)
// {
// //SourceExpr=CompanyInfo.City;
// }Column(DocDate_PurchHeader;FORMAT("Purchase Header"."Document Date",0,4))
// {
// //SourceExpr=FORMAT("Purchase Header"."Document Date",0,4);
// }Column(VATNoText;VATNoText)
// {
// //SourceExpr=VATNoText;
// }Column(VATRegNo_PurchHeader;"Purchase Header"."VAT Registration No.")
// {
// //SourceExpr="Purchase Header"."VAT Registration No.";
// }Column(PurchaserText;PurchaserText)
// {
// //SourceExpr=PurchaserText;
// }Column(SalesPurchPersonName;SalesPurchPerson.Name)
// {
// //SourceExpr=SalesPurchPerson.Name;
// }Column(ReferenceText;ReferenceText)
// {
// //SourceExpr=ReferenceText;
// }Column(YourReference_PurchHeader;"Purchase Header"."Your Reference")
// {
// //SourceExpr="Purchase Header"."Your Reference";
// }Column(CompanyAddr5;CompanyAddr[5])
// {
// //SourceExpr=CompanyAddr[5];
// }Column(CompanyAddr6;CompanyAddr[6])
// {
// //SourceExpr=CompanyAddr[6];
// }Column(BuyfromVenNo_PurchHeader;"Purchase Header"."Buy-from Vendor No.")
// {
// //SourceExpr="Purchase Header"."Buy-from Vendor No.";
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
// }Column(PricesIncludingVAT_PurchHeader;"Purchase Header"."Prices Including VAT")
// {
// //SourceExpr="Purchase Header"."Prices Including VAT";
// }Column(OutputNo;OutputNo)
// {
// //SourceExpr=OutputNo;
// }Column(VATBaseDisc_PurchHeader;"Purchase Header"."VAT Base Discount %")
// {
// //SourceExpr="Purchase Header"."VAT Base Discount %";
// }Column(PricesInclVATtxt;PricesInclVATtxt)
// {
// //SourceExpr=PricesInclVATtxt;
// }Column(ShowInternalInfo;ShowInternalInfo)
// {
// //SourceExpr=ShowInternalInfo;
// }Column(PrepmtPayTermsDesc;PrepmtPaymentTerms.Description)
// {
// //SourceExpr=PrepmtPaymentTerms.Description;
// }Column(PayTermsDesc;PaymentTerms.Description)
// {
// //SourceExpr=PaymentTerms.Description;
// }Column(ShipMethodDesc;ShipmentMethod.Description)
// {
// //SourceExpr=ShipmentMethod.Description;
// }Column(PhoneNoCaption;PhoneNoCaptionLbl)
// {
// //SourceExpr=PhoneNoCaptionLbl;
// }Column(VATRegNoCaption;VATRegNoCaptionLbl)
// {
// //SourceExpr=VATRegNoCaptionLbl;
// }Column(GiroNoCaption;GiroNoCaptionLbl)
// {
// //SourceExpr=GiroNoCaptionLbl;
// }Column(BankCaption;BankCaptionLbl)
// {
// //SourceExpr=BankCaptionLbl;
// }Column(BankAccNoCaption;BankAccNoCaptionLbl)
// {
// //SourceExpr=BankAccNoCaptionLbl;
// }Column(OrderNoCaption;OrderNoCaptionLbl)
// {
// //SourceExpr=OrderNoCaptionLbl;
// }Column(PageCaption;PageCaptionLbl)
// {
// //SourceExpr=PageCaptionLbl;
// }Column(BuyfromVenNo_PurchHeaderCaption;"Purchase Header".FIELDCAPTION("Buy-from Vendor No."))
// {
// //SourceExpr="Purchase Header".FIELDCAPTION("Buy-from Vendor No.");
// }Column(PricesIncludingVAT_PurchHeaderCaption;"Purchase Header".FIELDCAPTION("Prices Including VAT"))
// {
// //SourceExpr="Purchase Header".FIELDCAPTION("Prices Including VAT");
// }Column(CACCaption;CACCaptionLbl)
// {
// //SourceExpr=CACCaptionLbl;
// }Column(VendorData;VendorData)
// {
// //SourceExpr=VendorData;
// }Column(OrderInfo;OrderInfo)
// {
// //SourceExpr=OrderInfo;
// }Column(JobData;JobData)
// {
// //SourceExpr=JobData;
// }Column(PedidoCompra_Caption;PedidoCompra_CaptionLbl)
// {
// //SourceExpr=PedidoCompra_CaptionLbl;
// }Column(PostingDate_PurchaseHeader;"Purchase Header"."Posting Date")
// {
// //SourceExpr="Purchase Header"."Posting Date";
// }Column(VendorOrderNo_PurchaseHeader;"Purchase Header"."Vendor Order No.")
// {
// //SourceExpr="Purchase Header"."Vendor Order No.";
// }Column(JobNo_PurchaseHeader;"Purchase Header"."QB Job No.")
// {
// //SourceExpr="Purchase Header"."QB Job No.";
// }Column(LeadTimeCalculation_PurchaseHeader;"Purchase Header"."Lead Time Calculation")
// {
// //SourceExpr="Purchase Header"."Lead Time Calculation";
// }Column(PaytoName_PurchaseHeader;"Purchase Header"."Pay-to Name")
// {
// //SourceExpr="Purchase Header"."Pay-to Name";
// }Column(PaytoName2_PurchaseHeader;"Purchase Header"."Pay-to Name 2")
// {
// //SourceExpr="Purchase Header"."Pay-to Name 2";
// }Column(PaytoAddress_PurchaseHeader;"Purchase Header"."Pay-to Address")
// {
// //SourceExpr="Purchase Header"."Pay-to Address";
// }Column(PaytoAddress2_PurchaseHeader;"Purchase Header"."Pay-to Address 2")
// {
// //SourceExpr="Purchase Header"."Pay-to Address 2";
// }Column(PaytoContact_PurchaseHeader;"Purchase Header"."Pay-to Contact")
// {
// //SourceExpr="Purchase Header"."Pay-to Contact";
// }Column(ShiptoAddress_PurchaseHeader;"Purchase Header"."Ship-to Address")
// {
// //SourceExpr="Purchase Header"."Ship-to Address";
// }Column(ShiptoAddress2_PurchaseHeader;"Purchase Header"."Ship-to Address 2")
// {
// //SourceExpr="Purchase Header"."Ship-to Address 2";
// }Column(PaytoCity_PurchaseHeader;"Purchase Header"."Pay-to City")
// {
// //SourceExpr="Purchase Header"."Pay-to City";
// }Column(PaytoPostCode_PurchaseHeader;"Purchase Header"."Pay-to Post Code")
// {
// //SourceExpr="Purchase Header"."Pay-to Post Code";
// }Column(AgreementLine_Caption;AgreementLineLbl)
// {
// //SourceExpr=AgreementLineLbl;
// }Column(AgreementiHeader_Caption;AgreementHeaderLbl)
// {
// //SourceExpr=AgreementHeaderLbl;
// }Column(Sign_Caption;SignCaption)
// {
// //SourceExpr=SignCaption;
// }Column(Tot_Caption;TOTALCaption)
// {
// //SourceExpr=TOTALCaption;
// }Column(VAT_Caption;VATCaption)
// {
// //SourceExpr=VATCaption;
// }Column(Amount_Caption;AmountCaption)
// {
// //SourceExpr=AmountCaption;
// }Column(Imprescindible_Caption;ImprescindibleCaption)
// {
// //SourceExpr=ImprescindibleCaption;
// }Column(Fdo_Caption;FdoCaptionLbl)
// {
// //SourceExpr=FdoCaptionLbl;
// }Column(Proveedor_Caption;ProveedorCaptionLbl)
// {
// //SourceExpr=ProveedorCaptionLbl;
// }Column(PorcRetencion;PorcRetencion)
// {
// //SourceExpr=PorcRetencion;
// }Column(FormaPago;FormaPago)
// {
// //SourceExpr=FormaPago;
// }Column(AmountIncludingVAT_PurchaseHeader;"Purchase Header"."Amount Including VAT")
// {
// //SourceExpr="Purchase Header"."Amount Including VAT";
// }Column(Amount_PurchaseHeader;"Purchase Header".Amount)
// {
// //SourceExpr="Purchase Header".Amount;
// }Column(diapago;diapago)
// {
// //SourceExpr=diapago;
// }DataItem("DimensionLoop1";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=FILTER(1..));


//                DataItemLinkReference="Purchase Header";
// Column(DimText;DimText)
// {
// //SourceExpr=DimText;
// }Column(HdrDimsCaption;HdrDimsCaptionLbl)
// {
// //SourceExpr=HdrDimsCaptionLbl;
// }DataItem("Purchase Line";"Purchase Line")
// {

//                DataItemTableView=SORTING("Document Type","Document No.","Line No.");


//                DataItemLinkReference="Purchase Header";
// DataItemLink="Document Type"= FIELD("Document Type"),
//                             "Document No."= FIELD("No.");
// Column(Amount_PurchaseLine;"Purchase Line".Amount)
// {
// //SourceExpr="Purchase Line".Amount;
// }Column(DirectUnitCost_PurchaseLine;"Purchase Line"."Direct Unit Cost")
// {
// //SourceExpr="Purchase Line"."Direct Unit Cost";
// }Column(Quantity_PurchaseLine;"Purchase Line".Quantity)
// {
// //SourceExpr="Purchase Line".Quantity;
// }DataItem("RoundLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(PurchLineLineAmt;PurchLine."Line Amount")
// {
// //SourceExpr=PurchLine."Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Line"."Currency Code";
// }Column(Desc_PurchLine;"Purchase Line".Description)
// {
// //SourceExpr="Purchase Line".Description;
// }Column(LineNo_PurchLine;"Purchase Line"."Line No.")
// {
// //SourceExpr="Purchase Line"."Line No.";
// }Column(AllowInvDisctxt;AllowInvDisctxt)
// {
// //SourceExpr=AllowInvDisctxt;
// }Column(Type_PurchLine;FORMAT("Purchase Line".Type,0,2))
// {
// //SourceExpr=FORMAT("Purchase Line".Type,0,2);
// }Column(No_PurchLine;"Purchase Line"."No.")
// {
// //SourceExpr="Purchase Line"."No.";
// }Column(Quantity_PurchLine;"Purchase Line".Quantity)
// {
// //SourceExpr="Purchase Line".Quantity;
// }Column(UnitofMeasure_PurchLine;"Purchase Line"."Unit of Measure")
// {
// //SourceExpr="Purchase Line"."Unit of Measure";
// }Column(DirectUnitCost_PurchLine;"Purchase Line"."Direct Unit Cost")
// {
// //SourceExpr="Purchase Line"."Direct Unit Cost";
//                AutoFormatType=2;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(LineDisc_PurchLine;"Purchase Line"."Line Discount %")
// {
// //SourceExpr="Purchase Line"."Line Discount %";
// }Column(LineAmt_PurchLine;"Purchase Line"."Line Amount")
// {
// //SourceExpr="Purchase Line"."Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(AllowInvDisc_PurchLine;"Purchase Line"."Allow Invoice Disc.")
// {
// //SourceExpr="Purchase Line"."Allow Invoice Disc.";
// }Column(VATIdentifier_PurchLine;"Purchase Line"."VAT Identifier")
// {
// //SourceExpr="Purchase Line"."VAT Identifier";
// }Column(InvDiscAmt_PurchLine;-PurchLine."Inv. Discount Amount")
// {
// //SourceExpr=-PurchLine."Inv. Discount Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Line"."Currency Code";
// }Column(LineAmtInvDiscAmt_PurchLine;-PurchLine."Pmt. Disc. Rcd. Amount (Old)")
// {
// //SourceExpr=-PurchLine."Pmt. Disc. Rcd. Amount (Old)";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Line"."Currency Code";
// }Column(TotalInclVATText;TotalInclVATText)
// {
// //SourceExpr=TotalInclVATText;
// }Column(VATAmtLineText;VATAmountLine.VATAmountText)
// {
// //SourceExpr=VATAmountLine.VATAmountText;
// }Column(VATAmt;VATAmount)
// {
// //SourceExpr=VATAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalExclVATText;TotalExclVATText)
// {
// //SourceExpr=TotalExclVATText;
// }Column(VATDiscAmt;-VATDiscountAmount)
// {
// //SourceExpr=-VATDiscountAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATBaseAmt;VATBaseAmount)
// {
// //SourceExpr=VATBaseAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalAmtInclVAT;TotalAmountInclVAT)
// {
// //SourceExpr=TotalAmountInclVAT;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalSubTotal;TotalSubTotal)
// {
// //SourceExpr=TotalSubTotal;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalInvDiscAmt;TotalInvoiceDiscountAmount)
// {
// //SourceExpr=TotalInvoiceDiscountAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalAmt;TotalAmount)
// {
// //SourceExpr=TotalAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(DirectUnitCostCaption;DirectUnitCostCaptionLbl)
// {
// //SourceExpr=DirectUnitCostCaptionLbl;
// }Column(DiscountPercentCaption;DiscountPercentCaptionLbl)
// {
// //SourceExpr=DiscountPercentCaptionLbl;
// }Column(InvDiscAmtCaption;InvDiscAmtCaptionLbl)
// {
// //SourceExpr=InvDiscAmtCaptionLbl;
// }Column(SubtotalCaption;SubtotalCaptionLbl)
// {
// //SourceExpr=SubtotalCaptionLbl;
// }Column(TotalText;TotalTextLbl)
// {
// //SourceExpr=TotalTextLbl;
// }Column(VATDiscountAmtCaption;VATDiscountAmtCaptionLbl)
// {
// //SourceExpr=VATDiscountAmtCaptionLbl;
// }Column(Desc_PurchLineCaption;"Purchase Line".FIELDCAPTION(Description))
// {
// //SourceExpr="Purchase Line".FIELDCAPTION(Description);
// }Column(No_PurchLineCaption;"Purchase Line".FIELDCAPTION("No."))
// {
// //SourceExpr="Purchase Line".FIELDCAPTION("No.");
// }Column(Quantity_PurchLineCaption;"Purchase Line".FIELDCAPTION(Quantity))
// {
// //SourceExpr="Purchase Line".FIELDCAPTION(Quantity);
// }Column(UnitofMeasure_PurchLineCaption;"Purchase Line".FIELDCAPTION("Unit of Measure"))
// {
// //SourceExpr="Purchase Line".FIELDCAPTION("Unit of Measure");
// }Column(VATIdentifier_PurchLineCaption;"Purchase Line".FIELDCAPTION("VAT Identifier"))
// {
// //SourceExpr="Purchase Line".FIELDCAPTION("VAT Identifier");
// }Column(No_Caption;No_CaptionLbl)
// {
// //SourceExpr=No_CaptionLbl;
// }Column(MedicionInicial_Caption;MedicionInicial_CaptionLbl)
// {
// //SourceExpr=MedicionInicial_CaptionLbl;
// }Column(MedicionAmpl_Caption;MedicionAmpl_CaptionLbl)
// {
// //SourceExpr=MedicionAmpl_CaptionLbl;
// }Column(UD_Caption;UD_CaptionLbl)
// {
// //SourceExpr=UD_CaptionLbl;
// }Column(Conecpto_Caption;Concepto_CaptionLbl)
// {
// //SourceExpr=Concepto_CaptionLbl;
// }Column(Precio_Caption;Precio_CaptionLbl)
// {
// //SourceExpr=Precio_CaptionLbl;
// }Column(Total_Caption;Total_CaptionLbl)
// {
// //SourceExpr=Total_CaptionLbl;
// }Column(UnitOfMeasureCode_PurchaseLine;"Purchase Line"."Unit of Measure Code")
// {
// //SourceExpr="Purchase Line"."Unit of Measure Code";
// }Column(VATPorc_PurchaseLine;"Purchase Line"."VAT %")
// {
// //SourceExpr="Purchase Line"."VAT %";
// }Column(PorcIVA;porcIVA)
// {
// //SourceExpr=porcIVA;
// }Column(NLinea;Nlinea)
// {
// //SourceExpr=Nlinea;
// }Column(ConceptoLinea;ConceptoLinea)
// {
// //SourceExpr=ConceptoLinea;
// }Column(TxtAdicional;TxtAdicional)
// {
// //SourceExpr=TxtAdicional;
// }DataItem("DimensionLoop2";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=FILTER(1..));
//                ;
// Column(DimText1;DimText)
// {
// //SourceExpr=DimText;
// }Column(LineDimsCaption;LineDimsCaptionLbl)
// {
// //SourceExpr=LineDimsCaptionLbl;
// }DataItem("BlankSpaces";"2000000026")
// {

//                ;
// Column(Number;Number)
// {
// //SourceExpr=Number;
// }DataItem("VATCounter";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(VATAmtLineVATECBase;VATAmountLine."VAT Base")
// {
// //SourceExpr=VATAmountLine."VAT Base";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineVATAmt;VATAmountLine."VAT Amount")
// {
// //SourceExpr=VATAmountLine."VAT Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineLineAmt;VATAmountLine."Line Amount")
// {
// //SourceExpr=VATAmountLine."Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineInvDiscBaseAmt;VATAmountLine."Inv. Disc. Base Amount")
// {
// //SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineInvDiscAmtPmtDiscGivenAmt;VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount (Old)")
// {
// //SourceExpr=VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount (Old)";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineECAmt;VATAmountLine."EC Amount")
// {
// //SourceExpr=VATAmountLine."EC Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineVAT1;VATAmountLine."VAT %")
// {
// DecimalPlaces=0:6;
//                //SourceExpr=VATAmountLine."VAT %";
// }Column(VATAmtLineVATIdentifier;VATAmountLine."VAT Identifier")
// {
// //SourceExpr=VATAmountLine."VAT Identifier";
// }Column(VATAmtLineInvDiscAmt1;VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount (Old)")
// {
// //SourceExpr=VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount (Old)";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATAmtLineEC;VATAmountLine."EC %")
// {
// //SourceExpr=VATAmountLine."EC %";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(VATPercentCaption;VATPercentCaptionLbl)
// {
// //SourceExpr=VATPercentCaptionLbl;
// }Column(VATBaseCaption;VATBaseCaptionLbl)
// {
// //SourceExpr=VATBaseCaptionLbl;
// }Column(VATAmtCaption;VATAmtCaptionLbl)
// {
// //SourceExpr=VATAmtCaptionLbl;
// }Column(VATAmtSpecCaption;VATAmtSpecCaptionLbl)
// {
// //SourceExpr=VATAmtSpecCaptionLbl;
// }Column(VATIdentCaption;VATIdentCaptionLbl)
// {
// //SourceExpr=VATIdentCaptionLbl;
// }Column(InvDiscBaseAmtCaption;InvDiscBaseAmtCaptionLbl)
// {
// //SourceExpr=InvDiscBaseAmtCaptionLbl;
// }Column(LineAmtCaption;LineAmtCaptionLbl)
// {
// //SourceExpr=LineAmtCaptionLbl;
// }Column(InvDiscAmt1Caption;InvDiscAmt1CaptionLbl)
// {
// //SourceExpr=InvDiscAmt1CaptionLbl;
// }Column(ECAmtCaption;ECAmtCaptionLbl)
// {
// //SourceExpr=ECAmtCaptionLbl;
// }Column(ECCaption;ECCaptionLbl)
// {
// //SourceExpr=ECCaptionLbl;
// }DataItem("VATCounterLCY";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(VALExchRate;VALExchRate)
// {
// //SourceExpr=VALExchRate;
// }Column(VALSpecLCYHdr;VALSpecLCYHeader)
// {
// //SourceExpr=VALSpecLCYHeader;
// }Column(VALVATAmtLCY;VALVATAmountLCY)
// {
// //SourceExpr=VALVATAmountLCY;
//                AutoFormatType=1;
// }Column(VALVATBaseLCY;VALVATBaseLCY)
// {
// //SourceExpr=VALVATBaseLCY;
//                AutoFormatType=1;
// }Column(VATAmtLineVAT2;VATAmountLine."VAT %")
// {
// DecimalPlaces=0:5;
//                //SourceExpr=VATAmountLine."VAT %";
// }Column(VATAmtLineVATIdentifier3;VATAmountLine."VAT Identifier")
// {
// //SourceExpr=VATAmountLine."VAT Identifier";
// }DataItem("Total";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
// }DataItem("Total2";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
//                ;
// Column(PaytoVendNo_PurchHeader;"Purchase Header"."Pay-to Vendor No.")
// {
// //SourceExpr="Purchase Header"."Pay-to Vendor No.";
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
// }Column(PaymentDetailsCaption;PaymentDetailsCaptionLbl)
// {
// //SourceExpr=PaymentDetailsCaptionLbl;
// }Column(VendNoCaption;VendNoCaptionLbl)
// {
// //SourceExpr=VendNoCaptionLbl;
// }DataItem("Total3";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));
//                ;
// Column(SelltoCustNo_PurchHeader;"Purchase Header"."Sell-to Customer No.")
// {
// //SourceExpr="Purchase Header"."Sell-to Customer No.";
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
// }Column(ShiptoAddCaption;ShiptoAddCaptionLbl)
// {
// //SourceExpr=ShiptoAddCaptionLbl;
// }Column(SelltoCustNo_PurchHeaderCaption;"Purchase Header".FIELDCAPTION("Sell-to Customer No."))
// {
// //SourceExpr="Purchase Header".FIELDCAPTION("Sell-to Customer No.");
// }DataItem("PrepmtLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=FILTER(1..));
//                ;
// Column(PrepmtLineAmt;PrepmtLineAmount)
// {
// //SourceExpr=PrepmtLineAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtInvBufGLAccNo;PrepmtInvBuf."G/L Account No.")
// {
// //SourceExpr=PrepmtInvBuf."G/L Account No.";
// }Column(PrepmtInvBufDesc;PrepmtInvBuf.Description)
// {
// //SourceExpr=PrepmtInvBuf.Description;
// }Column(TotalExclVATText1;TotalExclVATText)
// {
// //SourceExpr=TotalExclVATText;
// }Column(PrepmtVATAmtLineTxt;PrepmtVATAmountLine.VATAmountText)
// {
// //SourceExpr=PrepmtVATAmountLine.VATAmountText;
// }Column(PrepmtVATAmt;PrepmtVATAmount)
// {
// //SourceExpr=PrepmtVATAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(TotalInclVATTxt1;TotalInclVATText)
// {
// //SourceExpr=TotalInclVATText;
// }Column(PrepmtInvBufAmtPrepmtVATAmt;PrepmtInvBuf.Amount + PrepmtVATAmount)
// {
// //SourceExpr=PrepmtInvBuf.Amount + PrepmtVATAmount;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtTotalAmtInclVAT;PrepmtTotalAmountInclVAT)
// {
// //SourceExpr=PrepmtTotalAmountInclVAT;
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(Number_IntegerLine;Number)
// {
// //SourceExpr=Number;
// }Column(DescCaption;DescCaptionLbl)
// {
// //SourceExpr=DescCaptionLbl;
// }Column(GLAccNoCaption;GLAccNoCaptionLbl)
// {
// //SourceExpr=GLAccNoCaptionLbl;
// }Column(PrepmtSpecCaption;PrepmtSpecCaptionLbl)
// {
// //SourceExpr=PrepmtSpecCaptionLbl;
// }DataItem("PrepmtDimLoop";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=FILTER(1..));
//                ;
// Column(DimText2;DimText)
// {
// //SourceExpr=DimText;
// }DataItem("PrepmtVATCounter";"2000000026")
// {

//                DataItemTableView=SORTING("Number");
//                ;
// Column(PrepmtVATAmtLineVATAmt;PrepmtVATAmountLine."VAT Amount")
// {
// //SourceExpr=PrepmtVATAmountLine."VAT Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmtLineVATBase;PrepmtVATAmountLine."VAT Base")
// {
// //SourceExpr=PrepmtVATAmountLine."VAT Base";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmtLineLineAmt;PrepmtVATAmountLine."Line Amount")
// {
// //SourceExpr=PrepmtVATAmountLine."Line Amount";
//                AutoFormatType=1;
//                AutoFormatExpression="Purchase Header"."Currency Code";
// }Column(PrepmtVATAmtLineVAT;PrepmtVATAmountLine."VAT %")
// {
// DecimalPlaces=0:5;
//                //SourceExpr=PrepmtVATAmountLine."VAT %";
// }Column(PrepmtVATAmtLineVATIdentifier;PrepmtVATAmountLine."VAT Identifier")
// {
// //SourceExpr=PrepmtVATAmountLine."VAT Identifier";
// }Column(PrepmtVATAmtSpecCaption;PrepmtVATAmtSpecCaptionLbl)
// {
// //SourceExpr=PrepmtVATAmtSpecCaptionLbl;
// }Column(PrepmtVATPercentCaption;VATPercentCaptionLbl)
// {
// //SourceExpr=VATPercentCaptionLbl;
// }Column(PrepmtVATBaseCaption;VATBaseCaptionLbl)
// {
// //SourceExpr=VATBaseCaptionLbl;
// }Column(PrepmtVATAmtCaption;VATAmtCaptionLbl)
// {
// //SourceExpr=VATAmtCaptionLbl;
// }Column(PrepmtVATIdentCaption;VATIdentCaptionLbl)
// {
// //SourceExpr=VATIdentCaptionLbl;
// }Column(PrepmtLineAmtCaption;LineAmtCaptionLbl)
// {
// //SourceExpr=LineAmtCaptionLbl;
// }Column(PrepmtTotalCaption;TotalCaptionLbl)
// {
// //SourceExpr=TotalCaptionLbl;
// }
// DataItem("PrepmtTotal";"2000000026")
// {

//                DataItemTableView=SORTING("Number")
//                                  WHERE("Number"=CONST(1));

//                               ;
// trigger OnPreDataItem();
//     BEGIN 
//                                IF NOT PrepmtInvBuf.FIND('-') THEN
//                                  CurrReport.BREAK;
//                              END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                SETRANGE(Number,1,PrepmtVATAmountLine.COUNT);
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   PrepmtVATAmountLine.GetLine(Number);
//                                 END;


// }
// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number = 1 THEN BEGIN 
//                                     IF NOT PrepmtDimSetEntry.FINDSET THEN
//                                       CurrReport.BREAK;
//                                   END ELSE
//                                     IF NOT Continue THEN
//                                       CurrReport.BREAK;

//                                   CLEAR(DimText);
//                                   Continue := FALSE;
//                                   REPEAT
//                                     OldDimText := DimText;
//                                     IF DimText = '' THEN
//                                       DimText := STRSUBSTNO('%1 %2',PrepmtDimSetEntry."Dimension Code",PrepmtDimSetEntry."Dimension Value Code")
//                                     ELSE
//                                       DimText :=
//                                         STRSUBSTNO(
//                                           '%1, %2 %3',DimText,
//                                           PrepmtDimSetEntry."Dimension Code",PrepmtDimSetEntry."Dimension Value Code");
//                                     IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN 
//                                       DimText := OldDimText;
//                                       Continue := TRUE;
//                                       EXIT;
//                                     END;
//                                   UNTIL PrepmtDimSetEntry.NEXT = 0;
//                                 END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                CurrReport.CREATETOTALS(
//                                  PrepmtInvBuf.Amount,PrepmtInvBuf."Amount Incl. VAT",
//                                  PrepmtVATAmountLine."Line Amount",PrepmtVATAmountLine."VAT Base",
//                                  PrepmtVATAmountLine."VAT Amount",
//                                  PrepmtLineAmount);
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number = 1 THEN BEGIN 
//                                     IF NOT PrepmtInvBuf.FIND('-') THEN
//                                       CurrReport.BREAK;
//                                   END ELSE
//                                     IF PrepmtInvBuf.NEXT = 0 THEN
//                                       CurrReport.BREAK;

//                                   IF ShowInternalInfo THEN
//                                     PrepmtDimSetEntry.SETRANGE("Dimension Set ID",PrepmtInvBuf."Dimension Set ID");

//                                   IF "Purchase Header"."Prices Including VAT" THEN
//                                     PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
//                                   ELSE
//                                     PrepmtLineAmount := PrepmtInvBuf.Amount;
//                                 END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
//                                  CurrReport.BREAK;
//                              END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
//                                  CurrReport.BREAK;
//                              END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                IF (NOT GLSetup."Print VAT specification in LCY") OR
//                                   ("Purchase Header"."Currency Code" = '') OR
//                                   (VATAmountLine.GetTotalVATAmount = 0)
//                                THEN
//                                  CurrReport.BREAK;

//                                SETRANGE(Number,1,VATAmountLine.COUNT);
//                                CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

//                                IF GLSetup."LCY Code" = '' THEN
//                                  VALSpecLCYHeader := Text007 + Text008
//                                ELSE
//                                  VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

//                                CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
//                                VALExchRate := STRSUBSTNO(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   VATAmountLine.GetLine(Number);
//                                   VALVATBaseLCY :=
//                                     VATAmountLine.GetBaseLCY(
//                                       "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
//                                   VALVATAmountLCY :=
//                                     VATAmountLine.GetAmountLCY(
//                                       "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
//                                 END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                IF (VATAmount = 0) AND (VATAmountLine."VAT %" + VATAmountLine."EC %" = 0) THEN
//                                  CurrReport.BREAK;
//                                SETRANGE(Number,1,VATAmountLine.COUNT);
//                                CurrReport.CREATETOTALS(
//                                  VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
//                                  VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount",
//                                  VATAmountLine."EC Amount",VATAmountLine."Pmt. Disc. Given Amount (Old)");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   VATAmountLine.GetLine(Number);
//                                 END;


// }
// trigger OnPreDataItem();
//     VAR
// //                                NumSpaces@7001100 :
//                                NumSpaces: Integer;
//                              BEGIN 
//                                NumSpaces := 23 - "Purchase Line".COUNT;
//                                SETRANGE(Number,1,NumSpaces);
//                              END;

// trigger OnPostDataItem();
//     BEGIN 
//                                 BlankSpaces.Number := 0;
//                               END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                IF NOT ShowInternalInfo THEN
//                                  CurrReport.BREAK;

//                                DimSetEntry2.SETRANGE("Dimension Set ID","Purchase Line"."Dimension Set ID");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number = 1 THEN BEGIN 
//                                     IF NOT DimSetEntry2.FINDSET THEN
//                                       CurrReport.BREAK;
//                                   END ELSE
//                                     IF NOT Continue THEN
//                                       CurrReport.BREAK;

//                                   CLEAR(DimText);
//                                   Continue := FALSE;
//                                   REPEAT
//                                     OldDimText := DimText;
//                                     IF DimText = '' THEN
//                                       DimText := STRSUBSTNO('%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
//                                     ELSE
//                                       DimText :=
//                                         STRSUBSTNO(
//                                           '%1, %2 %3',DimText,
//                                           DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
//                                     IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN 
//                                       DimText := OldDimText;
//                                       Continue := TRUE;
//                                       EXIT;
//                                     END;
//                                   UNTIL DimSetEntry2.NEXT = 0;
//                                 END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                MoreLines := PurchLine.FIND('+');
//                                WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2" = '') AND
//                                      (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
//                                      (PurchLine.Amount = 0)
//                                DO
//                                  MoreLines := PurchLine.NEXT(-1) <> 0;
//                                IF NOT MoreLines THEN
//                                  CurrReport.BREAK;
//                                PurchLine.SETRANGE("Line No.",0,PurchLine."Line No.");
//                                SETRANGE(Number,1,PurchLine.COUNT);
//                                CurrReport.CREATETOTALS(PurchLine."Line Amount",PurchLine."Inv. Discount Amount",PurchLine."Pmt. Disc. Rcd. Amount (Old)");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number = 1 THEN
//                                     PurchLine.FIND('-')
//                                   ELSE
//                                     PurchLine.NEXT;
//                                   "Purchase Line" := PurchLine;

//                                   IF NOT "Purchase Header"."Prices Including VAT" AND
//                                      (PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT")
//                                   THEN
//                                     PurchLine."Line Amount" := 0;

//                                   IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
//                                     "Purchase Line"."No." := '';
//                                   AllowInvDisctxt := FORMAT("Purchase Line"."Allow Invoice Disc.");
//                                   TotalSubTotal += "Purchase Line"."Line Amount";
//                                   TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
//                                   TotalAmount += "Purchase Line".Amount;

//                                   //JAV 13/03/19: - No inicializaba el texto y copiaba el anterior siempre
//                                   TxtAdicional := '';
//                                   //JAV 13/03/19 fin

//                                   IF ShowUO THEN BEGIN 
//                                     Nlinea := "Purchase Line"."Piecework No.";

//                                     DataPieceworkForProduction.RESET;
//                                     DataPieceworkForProduction.SETRANGE("Job No.","Purchase Line"."Job No.");
//                                     DataPieceworkForProduction.SETRANGE("Piecework Code","Purchase Line"."Piecework No.");
//                                     IF DataPieceworkForProduction.FINDFIRST THEN BEGIN 
//                                       ConceptoLinea := DataPieceworkForProduction.Description + ' ' + DataPieceworkForProduction."Description 2";

//                                        IF QBText.GET(QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code") THEN
//                                         TxtAdicional := QBText.GetCostText;
//                                     END;
//                                   END ELSE BEGIN 
//                                     Nlinea := "Purchase Line"."No.";
//                                     ConceptoLinea := "Purchase Line".Description;

//                                     IF "Purchase Line".Type = "Purchase Line".Type::Resource THEN BEGIN 
//                                       ExtendedTextLine.RESET;
//                                       ExtendedTextLine.SETRANGE("Table Name",ExtendedTextLine."Table Name"::Resource);
//                                       ExtendedTextLine.SETRANGE("No.","Purchase Line"."No.");
//                                       IF ExtendedTextLine.FINDFIRST THEN BEGIN 
//                                         REPEAT
//                                           TxtAdicional := TxtAdicional + ' ' + ExtendedTextLine.Text;
//                                         UNTIL ExtendedTextLine.NEXT = 0;
//                                       END;
//                                     END;

//                                     IF "Purchase Line".Type = "Purchase Line".Type::Item THEN BEGIN 
//                                       ExtendedTextLine.RESET;
//                                       ExtendedTextLine.SETRANGE("Table Name",ExtendedTextLine."Table Name"::Item);
//                                       ExtendedTextLine.SETRANGE("No.","Purchase Line"."No.");
//                                       IF ExtendedTextLine.FINDFIRST THEN BEGIN 
//                                         REPEAT
//                                           TxtAdicional := TxtAdicional + ' ' + ExtendedTextLine.Text;
//                                         UNTIL ExtendedTextLine.NEXT = 0;
//                                       END;
//                                     END;

//                                     IF "Purchase Line".Type = "Purchase Line".Type::"G/L Account" THEN BEGIN 
//                                       ExtendedTextLine.RESET;
//                                       ExtendedTextLine.SETRANGE("Table Name",ExtendedTextLine."Table Name"::"G/L Account");
//                                       ExtendedTextLine.SETRANGE("No.","Purchase Line"."No.");
//                                       IF ExtendedTextLine.FINDFIRST THEN BEGIN 
//                                         REPEAT
//                                           TxtAdicional := TxtAdicional + ' ' + ExtendedTextLine.Text;
//                                         UNTIL ExtendedTextLine.NEXT = 0;
//                                       END;
//                                     END;
//                                   END;
//                                 END;

// trigger OnPostDataItem();
//     BEGIN 
//                                 PurchLine.DELETEALL;
//                               END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                CurrReport.BREAK;
//                              END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                IF NOT ShowInternalInfo THEN
//                                  CurrReport.BREAK;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF Number = 1 THEN BEGIN 
//                                     IF NOT DimSetEntry1.FINDSET THEN
//                                       CurrReport.BREAK;
//                                   END ELSE
//                                     IF NOT Continue THEN
//                                       CurrReport.BREAK;

//                                   CLEAR(DimText);
//                                   Continue := FALSE;
//                                   REPEAT
//                                     OldDimText := DimText;
//                                     IF DimText = '' THEN
//                                       DimText := STRSUBSTNO('%1 %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
//                                     ELSE
//                                       DimText :=
//                                         STRSUBSTNO(
//                                           '%1, %2 %3',DimText,
//                                           DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
//                                     IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN 
//                                       DimText := OldDimText;
//                                       Continue := TRUE;
//                                       EXIT;
//                                     END;
//                                   UNTIL DimSetEntry1.NEXT = 0;
//                                 END;


// }
// trigger OnAfterGetRecord();
//     BEGIN 
//                                   PaymentDay.RESET;
//                                   PaymentDay.SETRANGE(Code,CompanyInfo."Payment Days Code");
//                                   IF PaymentDay.FINDFIRST THEN
//                                     diapago := PaymentDay."Day of the month";
//                                 END;


// }
// trigger OnPreDataItem();
//     BEGIN 
//                                NoOfLoops := ABS(NoOfCopies) + 1;
//                                CopyText := '';
//                                SETRANGE(Number,1,NoOfLoops);
//                                OutputNo := 0;
//                              END;

// trigger OnAfterGetRecord();
//     VAR
// //                                   PrepmtPurchLine@1000 :
//                                   PrepmtPurchLine: Record 39 TEMPORARY;
// //                                   TempPurchLine@1002 :
//                                   TempPurchLine: Record 39 TEMPORARY;
//                                 BEGIN 
//                                   CLEAR(PurchLine);
//                                   CLEAR(PurchPost);
//                                   PurchLine.DELETEALL;
//                                   VATAmountLine.DELETEALL;
//                                   PurchPost.GetPurchLines("Purchase Header",PurchLine,0);
//                                   PurchLine.CalcVATAmountLines(0,"Purchase Header",PurchLine,VATAmountLine);
//                                   PurchLine.UpdateVATOnLines(0,"Purchase Header",PurchLine,VATAmountLine);
//                                   VATAmount := VATAmountLine.GetTotalVATAmount;
//                                   VATBaseAmount := VATAmountLine.GetTotalVATBase;
//                                   VATDiscountAmount :=
//                                     VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
//                                   TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
//                                   IF (VATAmountLine."VAT Calculation Type" = VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT") AND
//                                      "Purchase Header"."Prices Including VAT"
//                                   THEN BEGIN 
//                                     VATBaseAmount := VATAmountLine.GetTotalLineAmount(FALSE,"Purchase Header"."Currency Code");
//                                     TotalAmountInclVAT := VATAmountLine.GetTotalLineAmount(FALSE,"Purchase Header"."Currency Code");
//                                   END;

//                                   PrepmtInvBuf.DELETEALL;
//                                   PurchPostPrepmt.GetPurchLines("Purchase Header",0,PrepmtPurchLine);
//                                   IF NOT PrepmtPurchLine.ISEMPTY THEN BEGIN 
//                                     PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header",TempPurchLine);
//                                     IF NOT TempPurchLine.ISEMPTY THEN
//                                       PurchPostPrepmt.CalcVATAmountLines("Purchase Header",TempPurchLine,PrePmtVATAmountLineDeduct,1);
//                                   END;
//                                   PurchPostPrepmt.CalcVATAmountLines("Purchase Header",PrepmtPurchLine,PrepmtVATAmountLine,0);
//                                   PrepmtVATAmountLine.DeductVATAmountLine(PrePmtVATAmountLineDeduct);
//                                   PurchPostPrepmt.UpdateVATOnLines("Purchase Header",PrepmtPurchLine,PrepmtVATAmountLine,0);
//                                   PurchPostPrepmt.BuildInvLineBuffer2("Purchase Header",PrepmtPurchLine,0,PrepmtInvBuf);
//                                   PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
//                                   PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
//                                   PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

//                                   IF Number > 1 THEN
//                                     CopyText := FormatDocument.GetCOPYText;
//                                   CurrReport.PAGENO := 1;
//                                   OutputNo := OutputNo + 1;

//                                   TotalSubTotal := 0;
//                                   TotalAmount := 0;
//                                   TotalInvoiceDiscountAmount := 0;

//                                   WithholdingGroup.RESET;
//                                   WithholdingGroup.SETRANGE(Code,"Purchase Header"."QW Cod. Withholding by GE");
//                                   IF WithholdingGroup.FINDSET THEN
//                                     PorcRetencion := WithholdingGroup."Percentage Withholding";

//                                   FormaPago := "Purchase Header"."Payment Method Code" + ' ' + "Purchase Header"."Payment Terms Code";

//                                   Vendor.RESET;
//                                   Vendor.SETRANGE("No.","Purchase Header"."Pay-to Vendor No.");
//                                   IF Vendor.FINDSET THEN BEGIN 
//                                     CIFVendor := Vendor."VAT Registration No.";
//                                     TelefonoProv := Vendor."Phone No.";
//                                     ContactoProv := Vendor.Contact;
//                                   END;

//                                   IF Job.GET("Purchase Header"."QB Job No.") THEN
//                                     DireccionEntrega := Job."Job Address 1" + ' ' + Job."Job Adress 2" + ' ' + Job."Job P.C." + Job."Job City";

//                                   VendorConditionsData.RESET;
//                                   VendorConditionsData.SETRANGE("Job No.","Purchase Header"."QB Job No.");
//                                   VendorConditionsData.SETRANGE("Vendor No.","Purchase Header"."Pay-to Vendor No.");
//                                   IF VendorConditionsData.FINDFIRST THEN BEGIN 
//                                     FechaInicio := VendorConditionsData."Start Date";
//                                     FechaFin := VendorConditionsData."End Date";
//                                   END;

//                                   ContactoObra := Job."Construction Manager";
//                                   TelefonoObra := Job."Job Telephone";
//                                 END;

// trigger OnPostDataItem();
//     BEGIN 
//                                 IF NOT CurrReport.PREVIEW THEN
//                                   CODEUNIT.RUN(CODEUNIT::"Purch.Header-Printed","Purchase Header");
//                               END;


// }
// trigger OnAfterGetRecord();
//     BEGIN 
//                                   CompanyInfo.CALCFIELDS(Picture);
//                                   "Purchase Header".CALCFIELDS(Amount);
//                                   "Purchase Header".CALCFIELDS("Amount Including VAT");
//                                   CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

//                                   IF "Purchase Header".Amount <> 0 THEN
//                                     porcIVA := ROUND((("Purchase Header"."Amount Including VAT" - "Purchase Header".Amount)*100) / "Purchase Header".Amount);

//                                   FormatAddressFields("Purchase Header");
//                                   FormatDocumentFields("Purchase Header");
//                                   PricesInclVATtxt := FORMAT("Prices Including VAT");

//                                   DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

//                                   ShowCashAccountingCriteria("Purchase Header");

//                                   IF NOT CurrReport.PREVIEW THEN BEGIN 
//                                     IF ArchiveDocument THEN
//                                       ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

//                                     IF LogInteraction THEN BEGIN 
//                                       CALCFIELDS("No. of Archived Versions");
//                                       SegManagement.LogDocument(
//                                         13,"No.","Doc. No. Occurrence","No. of Archived Versions",DATABASE::Vendor,"Buy-from Vendor No.",
//                                         "Purchaser Code",'',"Posting Description",'');
//                                     END;
//                                   END;
//                                 END;


// }
// }
//   requestpage
//   {
// SaveValues=true;

//     layout
// {
// area(content)
// {
// group("group79")
// {

//                   CaptionML=ENU='Options',ESP='Opciones';
//     field("NoofCopies";"NoOfCopies")
//     {

//                   CaptionML=ENU='No. of Copies',ESP='N§ copias';
//     }
//     field("ShowInternalInformation";"ShowInternalInfo")
//     {

//                   CaptionML=ENU='Show Internal Information',ESP='Mostrar informaci¢n interna';
//     }
//     field("ArchiveDocument";"ArchiveDocument")
//     {

//                   CaptionML=ENU='Archive Document',ESP='Archivar documento';

//                               ;trigger OnValidate()    BEGIN
//                                IF NOT ArchiveDocument THEN
//                                  LogInteraction := FALSE;
//                              END;


//     }
//     field("LogInteraction";"LogInteraction")
//     {

//                   CaptionML=ENU='Log Interaction',ESP='Log interacci¢n';
//                   Enabled=LogInteractionEnable;

//                               ;trigger OnValidate()    BEGIN
//                                IF LogInteraction THEN
//                                  ArchiveDocument := ArchiveDocumentEnable;
//                              END;


//     }
//     field("ShowUO";"ShowUO")
//     {

//                   CaptionML=ENU='Show UO data',ESP='Mostrar datos UO';
//     }

// }

// }
// }trigger OnInit()    BEGIN
//                LogInteractionEnable := TRUE;
//              END;

// trigger OnOpenPage()    BEGIN
//                    ArchiveDocument := PurchSetup."Archive Quotes and Orders";
//                    LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

//                    LogInteractionEnable := LogInteraction;
//                    ShowUO := TRUE;
//                  END;


//   }
//   labels
// {
// lblPedidoCompra='PURCHASE ORDER/ VALE DE SUMINISTRO/';
// lblDatosProveedor='VENDOR DATA/ DATOS DEL PROVEEDOR/';
// lblNombre='Name/ NOMBRE/';
// lblDireccion='Address/ DIRECCIàN/';
// lblCIF='VAT Registration No./ C.I.F./N.I.F./';
// lblContacto='Contact/ CONTACTO/';
// lblTelefono='PHONE/ TELFONO/';
// lblDatosPedido='DATOS DEL PEDIDO/';
// lblFecha='DATE/ FECHA/';
// lblObra='JOB/ OBRA/';
// lblNPedido='ORDER NO./ N§ DEL PEDIDO/';
// lblFormaPago='PAYMENT METHOD/ FORMA DE PAGO/';
// lblRetencion='WITHHOLDING/ RETENCIàN/';
// lblDatosObra='DATOS DE LA OBRA/';
// lblFechaInicio='START DATE/ FECHA INICIO/';
// lblFechaFin='END DATE/ FECHA FIN/';
// lblDireccionEntrega='DELIVERY ADDRESS/ DIRECCIàN DE ENTREGA/';
// lblContacto2='CONTACT/ CONTACTO/';
// lblNUO='P.C. No./ N§ U.O./';
// lblAmpliacion='EXTENSION NO./ AMPLIACION N§/';
// lblFechaEntraga='DELIVERY DATE/ FECHA/PLAZO DE ENTREGA/';
// lblProveedor='THE VENDOR/ EL PROVEEDOR/';
// lblFIRMA='Signature and Stamp/ Firma y sello/';
// lblCondiAdic='ADDITIONAL AGREEMENT/ CLAUSULAS GENERALES/';
// }

//     var
// //       JobData@7001102 :
//       JobData: TextConst ENU='PIECEWORK DATA',ESP='DATOS DE LA OBRA';
// //       OrderInfo@7001101 :
//       OrderInfo: TextConst ENU='ORDER INFO',ESP='INF. PEDIDO';
// //       VendorData@7001100 :
//       VendorData: TextConst ENU='VENDOR DATA',ESP='DATOS DEL PROVEEDOR';
// //       Text004@1004 :
//       Text004: 
// // "%1 = Document No."
// TextConst ENU='Provisioning Order %1',ESP='Vale de suministro %1';
// //       GLSetup@1007 :
//       GLSetup: Record 98;
// //       CompanyInfo@1008 :
//       CompanyInfo: Record 79;
// //       ShipmentMethod@1009 :
//       ShipmentMethod: Record 10;
// //       PaymentTerms@1010 :
//       PaymentTerms: Record 3;
// //       PrepmtPaymentTerms@1064 :
//       PrepmtPaymentTerms: Record 3;
// //       SalesPurchPerson@1011 :
//       SalesPurchPerson: Record 13;
// //       VATAmountLine@1012 :
//       VATAmountLine: Record 290 TEMPORARY;
// //       PrepmtVATAmountLine@1055 :
//       PrepmtVATAmountLine: Record 290 TEMPORARY;
// //       PrePmtVATAmountLineDeduct@1069 :
//       PrePmtVATAmountLineDeduct: Record 290 TEMPORARY;
// //       PurchLine@1013 :
//       PurchLine: Record 39 TEMPORARY;
// //       DimSetEntry1@1014 :
//       DimSetEntry1: Record 480;
// //       DimSetEntry2@1015 :
//       DimSetEntry2: Record 480;
// //       PrepmtDimSetEntry@1057 :
//       PrepmtDimSetEntry: Record 480;
// //       PrepmtInvBuf@1056 :
//       PrepmtInvBuf: Record 461 TEMPORARY;
// //       RespCenter@1016 :
//       RespCenter: Record 5714;
// //       Language@1017 :
//       Language: Record 8;
// //       CurrExchRate@1054 :
//       CurrExchRate: Record 330;
// //       PurchSetup@1066 :
//       PurchSetup: Record 312;
// //       FormatAddr@1019 :
//       FormatAddr: Codeunit 365;
// //       FormatDocument@1061 :
//       FormatDocument: Codeunit 368;
// //       PurchPost@1020 :
//       PurchPost: Codeunit 90;
// //       ArchiveManagement@1045 :
//       ArchiveManagement: Codeunit 5063;
// //       SegManagement@1046 :
//       SegManagement: Codeunit 5051;
// //       PurchPostPrepmt@1058 :
//       PurchPostPrepmt: Codeunit 444;
// //       VendAddr@1021 :
//       VendAddr: ARRAY [8] OF Text[50];
// //       ShipToAddr@1022 :
//       ShipToAddr: ARRAY [8] OF Text[50];
// //       CompanyAddr@1023 :
//       CompanyAddr: ARRAY [8] OF Text[50];
// //       BuyFromAddr@1024 :
//       BuyFromAddr: ARRAY [8] OF Text[50];
// //       PurchaserText@1025 :
//       PurchaserText: Text[30];
// //       VATNoText@1026 :
//       VATNoText: Text[80];
// //       ReferenceText@1027 :
//       ReferenceText: Text[80];
// //       TotalText@1028 :
//       TotalText: Text[50];
// //       TotalInclVATText@1029 :
//       TotalInclVATText: Text[50];
// //       TotalExclVATText@1030 :
//       TotalExclVATText: Text[50];
// //       MoreLines@1031 :
//       MoreLines: Boolean;
// //       NoOfCopies@1032 :
//       NoOfCopies: Integer;
// //       NoOfLoops@1033 :
//       NoOfLoops: Integer;
// //       CopyText@1034 :
//       CopyText: Text[30];
// //       OutputNo@1065 :
//       OutputNo: Integer;
// //       DimText@1035 :
//       DimText: Text[120];
// //       OldDimText@1036 :
//       OldDimText: Text[75];
// //       ShowInternalInfo@1037 :
//       ShowInternalInfo: Boolean;
// //       Continue@1038 :
//       Continue: Boolean;
// //       ArchiveDocument@1044 :
//       ArchiveDocument: Boolean;
// //       LogInteraction@1043 :
//       LogInteraction: Boolean;
// //       VATAmount@1039 :
//       VATAmount: Decimal;
// //       VATBaseAmount@1042 :
//       VATBaseAmount: Decimal;
// //       VATDiscountAmount@1041 :
//       VATDiscountAmount: Decimal;
// //       TotalAmountInclVAT@1040 :
//       TotalAmountInclVAT: Decimal;
// //       VALVATBaseLCY@1050 :
//       VALVATBaseLCY: Decimal;
// //       VALVATAmountLCY@1049 :
//       VALVATAmountLCY: Decimal;
// //       VALSpecLCYHeader@1048 :
//       VALSpecLCYHeader: Text[80];
// //       VALExchRate@1047 :
//       VALExchRate: Text[50];
// //       Text007@1053 :
//       Text007: TextConst ENU='VAT Amount Specification in ',ESP='Especificar importe IVA en ';
// //       Text008@1052 :
//       Text008: TextConst ENU='Local Currency',ESP='Divisa local';
// //       Text009@1051 :
//       Text009: TextConst ENU='Exchange rate: %1/%2',ESP='Tipo cambio: %1/%2';
// //       PrepmtVATAmount@1063 :
//       PrepmtVATAmount: Decimal;
// //       PrepmtVATBaseAmount@1062 :
//       PrepmtVATBaseAmount: Decimal;
// //       PrepmtTotalAmountInclVAT@1060 :
//       PrepmtTotalAmountInclVAT: Decimal;
// //       PrepmtLineAmount@1059 :
//       PrepmtLineAmount: Decimal;
// //       PricesInclVATtxt@1068 :
//       PricesInclVATtxt: Text[30];
// //       AllowInvDisctxt@1067 :
//       AllowInvDisctxt: Text[30];
// //       ArchiveDocumentEnable@19005281 :
//       ArchiveDocumentEnable: Boolean INDATASET;
// //       LogInteractionEnable@19003940 :
//       LogInteractionEnable: Boolean INDATASET;
// //       TotalSubTotal@1072 :
//       TotalSubTotal: Decimal;
// //       TotalAmount@1071 :
//       TotalAmount: Decimal;
// //       TotalInvoiceDiscountAmount@1070 :
//       TotalInvoiceDiscountAmount: Decimal;
// //       PhoneNoCaptionLbl@6169 :
//       PhoneNoCaptionLbl: TextConst ENU='Phone No.',ESP='N§ tel‚fono';
// //       VATRegNoCaptionLbl@2224 :
//       VATRegNoCaptionLbl: TextConst ENU='VAT Registration No.',ESP='CIF/NIF';
// //       GiroNoCaptionLbl@7839 :
//       GiroNoCaptionLbl: TextConst ENU='Giro No.',ESP='N§ giro postal';
// //       BankCaptionLbl@1791 :
//       BankCaptionLbl: TextConst ENU='Bank',ESP='Banco';
// //       BankAccNoCaptionLbl@1535 :
//       BankAccNoCaptionLbl: TextConst ENU='Account No.',ESP='N§ cuenta';
// //       OrderNoCaptionLbl@5963 :
//       OrderNoCaptionLbl: TextConst ENU='Order No.',ESP='N§ pedido';
// //       PageCaptionLbl@6215 :
//       PageCaptionLbl: TextConst ENU='Page',ESP='P g.';
// //       HdrDimsCaptionLbl@2756 :
//       HdrDimsCaptionLbl: TextConst ENU='Header Dimensions',ESP='Dimensiones cabecera';
// //       DirectUnitCostCaptionLbl@6248 :
//       DirectUnitCostCaptionLbl: TextConst ENU='Direct Unit Cost',ESP='Coste unit. directo';
// //       DiscountPercentCaptionLbl@5604 :
//       DiscountPercentCaptionLbl: TextConst ENU='Discount %',ESP='% Descuento';
// //       InvDiscAmtCaptionLbl@4720 :
//       InvDiscAmtCaptionLbl: TextConst ENU='Invoice Discount Amount',ESP='Importe descuento factura';
// //       SubtotalCaptionLbl@1782 :
//       SubtotalCaptionLbl: TextConst ENU='Subtotal',ESP='Subtotal';
// //       TotalTextLbl@1100469 :
//       TotalTextLbl: TextConst ENU='Payment Discount Received Amount',ESP='Importe recibido descuento pago';
// //       VATDiscountAmtCaptionLbl@3891 :
//       VATDiscountAmtCaptionLbl: TextConst ENU='Payment Discount on VAT',ESP='Descuento P.P. sobre IVA';
// //       LineDimsCaptionLbl@6798 :
//       LineDimsCaptionLbl: TextConst ENU='Line Dimensions',ESP='Dimensiones l¡nea';
// //       VATPercentCaptionLbl@6226 :
//       VATPercentCaptionLbl: TextConst ENU='VAT %',ESP='% IVA';
// //       VATBaseCaptionLbl@5098 :
//       VATBaseCaptionLbl: TextConst ENU='VAT Base',ESP='Base IVA';
// //       VATAmtCaptionLbl@8387 :
//       VATAmtCaptionLbl: TextConst ENU='VAT Amount',ESP='Importe IVA';
// //       VATAmtSpecCaptionLbl@3447 :
//       VATAmtSpecCaptionLbl: TextConst ENU='VAT Amount Specification',ESP='Especificaci¢n importe IVA';
// //       VATIdentCaptionLbl@5459 :
//       VATIdentCaptionLbl: TextConst ENU='VAT Identifier',ESP='Identific. IVA';
// //       InvDiscBaseAmtCaptionLbl@2407 :
//       InvDiscBaseAmtCaptionLbl: TextConst ENU='Invoice Discount Base Amount',ESP='Importe base descuento factura';
// //       LineAmtCaptionLbl@3126 :
//       LineAmtCaptionLbl: TextConst ENU='Line Amount',ESP='Importe l¡nea';
// //       InvDiscAmt1CaptionLbl@1106756 :
//       InvDiscAmt1CaptionLbl: TextConst ENU='Invoice and Payment Discounts',ESP='Descuentos facturas y pagos';
// //       ECAmtCaptionLbl@1106492 :
//       ECAmtCaptionLbl: TextConst ENU='EC Amount',ESP='Importe RE';
// //       ECCaptionLbl@1106861 :
//       ECCaptionLbl: TextConst ENU='EC %',ESP='% RE';
// //       TotalCaptionLbl@1909 :
//       TotalCaptionLbl: TextConst ENU='Total',ESP='Total';
// //       PaymentDetailsCaptionLbl@1801 :
//       PaymentDetailsCaptionLbl: TextConst ENU='Payment Details',ESP='Detalles del pago';
// //       VendNoCaptionLbl@1947 :
//       VendNoCaptionLbl: TextConst ENU='Vendor No.',ESP='N§ proveedor';
// //       ShiptoAddCaptionLbl@2212 :
//       ShiptoAddCaptionLbl: TextConst ENU='Ship-to Address',ESP='Direcci¢n de env¡o';
// //       DescCaptionLbl@6283 :
//       DescCaptionLbl: TextConst ENU='Description',ESP='Descripci¢n';
// //       GLAccNoCaptionLbl@9831 :
//       GLAccNoCaptionLbl: TextConst ENU='G/L Account No.',ESP='N§ cuenta';
// //       PrepmtSpecCaptionLbl@9049 :
//       PrepmtSpecCaptionLbl: TextConst ENU='Prepayment Specification',ESP='Especificaci¢n prepago';
// //       PrepmtVATAmtSpecCaptionLbl@8184 :
//       PrepmtVATAmtSpecCaptionLbl: TextConst ENU='Prepayment VAT Amount Specification',ESP='Especificaci¢n importe IVA prepago';
// //       HomepageCaptionLbl@1105864 :
//       HomepageCaptionLbl: TextConst ENU='Home Page',ESP='P gina Web';
// //       EmailCaptionLbl@1106630 :
//       EmailCaptionLbl: TextConst ENU='Email',ESP='Correo electr¢nico';
// //       AmtCaptionLbl@9683 :
//       AmtCaptionLbl: TextConst ENU='Amount',ESP='Importe';
// //       PaymentTermsCaptionLbl@8455 :
//       PaymentTermsCaptionLbl: TextConst ENU='Payment Terms',ESP='T‚rminos pago';
// //       ShpMethodCaptionLbl@6033 :
//       ShpMethodCaptionLbl: TextConst ENU='Shipment Method',ESP='Condiciones env¡o';
// //       PrePmtTermsDescCaptionLbl@5741 :
//       PrePmtTermsDescCaptionLbl: TextConst ENU='Prepayment Payment Terms',ESP='Condiciones prepago';
// //       DocDateCaptionLbl@1108215 :
//       DocDateCaptionLbl: TextConst ENU='Document Date',ESP='Fecha emisi¢n documento';
// //       AllowInvDiscCaptionLbl@1106485 :
//       AllowInvDiscCaptionLbl: TextConst ENU='Allow Invoice Discount',ESP='Permitir descuento factura';
// //       CACCaptionLbl@1100091 :
//       CACCaptionLbl: Text;
// //       CACTxt@1100092 :
//       CACTxt: TextConst ENU='R‚gimen especial del criterio de caja',ESP='R‚gimen especial del criterio de caja';
// //       PedidoCompra_CaptionLbl@7001103 :
//       PedidoCompra_CaptionLbl: TextConst ENU='PURCHASE ORDER',ESP='PEDIDO DE COMPRA';
// //       Nombre_CaptionLbl@7001104 :
//       Nombre_CaptionLbl: TextConst ENU='Name',ESP='Nombre';
// //       Direccion_CaptionLbl@7001105 :
//       Direccion_CaptionLbl: TextConst ENU='Address',ESP='Direcci¢n';
// //       CIF_CaptionLbl@7001106 :
//       CIF_CaptionLbl: TextConst ENU='VAT No.:',ESP='C.I.F.:';
// //       Contacto_CaptionLbl@7001107 :
//       Contacto_CaptionLbl: TextConst ENU='Contact:',ESP='Contacto:';
// //       Obra_CaptionLbl@7001108 :
//       Obra_CaptionLbl: TextConst ENU='JOB',ESP='OBRA';
// //       FechaEntrega_CaptionLbl@7001109 :
//       FechaEntrega_CaptionLbl: TextConst ENU='DELIVERY DATE/TERM',ESP='FECHA/PLAZO DE ENTREGA';
// //       DireccionEntrega_CaptionLbl@7001110 :
//       DireccionEntrega_CaptionLbl: TextConst ENU='DELIVERY ADDRESS',ESP='DIRECCIàN DE ENTREGA';
// //       Contacto_Mayus@7001111 :
//       Contacto_Mayus: TextConst ENU='CONTACT',ESP='CONTACTO';
// //       Fecha_CaptionLbl@7001112 :
//       Fecha_CaptionLbl: TextConst ENU='DATE',ESP='FECHA';
// //       NPedido_CaptionLbl@7001113 :
//       NPedido_CaptionLbl: TextConst ENU='ORDER NO.',ESP='N§ DEL PEDIDO';
// //       Ampliacion_CaptionLbl@7001114 :
//       Ampliacion_CaptionLbl: TextConst ENU='EXTENSION NO.',ESP='AMPLIACIàN N§';
// //       FormaPago_CaptionLbl@7001115 :
//       FormaPago_CaptionLbl: TextConst ENU='PAYMENT METHOD',ESP='FORMA DE PAGO';
// //       Retencion_CaptionLbl@7001116 :
//       Retencion_CaptionLbl: TextConst ENU='WITHHOLDING',ESP='RETENCIàN';
// //       No_CaptionLbl@7001117 :
//       No_CaptionLbl: TextConst ENU='No.',ESP='N§';
// //       MedicionInicial_CaptionLbl@7001118 :
//       MedicionInicial_CaptionLbl: TextConst ENU='INITIAL MEASURE.',ESP='MED.';
// //       MedicionAmpl_CaptionLbl@7001119 :
//       MedicionAmpl_CaptionLbl: TextConst ENU='EXT. MEASURE.',ESP='MEDICIàN AMPL.';
// //       UD_CaptionLbl@7001120 :
//       UD_CaptionLbl: TextConst ENU='UNITS',ESP='UD';
// //       Concepto_CaptionLbl@7001121 :
//       Concepto_CaptionLbl: TextConst ENU='CONCEPT',ESP='CONCEPTO';
// //       Precio_CaptionLbl@7001122 :
//       Precio_CaptionLbl: TextConst ENU='PRICE',ESP='PRECIO';
// //       Total_CaptionLbl@7001123 :
//       Total_CaptionLbl: TextConst ENU='Amount',ESP='Importe';
// //       AgreementLineLbl@7001125 :
//       AgreementLineLbl: TextConst ESP='El importe reflejado en este pedido es orientativo. La medici¢n indicada no es contractual y se abonar  la realmente ejecutada, sin derecho de reclamaci¢n de importe por mediciones no ejecutadas realmente. En los precios se incluyen los portes del material hasta pie de obra.';
// //       AgreementHeaderLbl@7001124 :
//       AgreementHeaderLbl: TextConst ENU='ADDITIONAL AGREEMENT',ESP='CLAUSULAS ADICIONALES';
// //       SignCaption@7001130 :
//       SignCaption: TextConst ENU='Signature and Stamp',ESP='firma y sello';
// //       TOTALCaption@7001129 :
//       TOTALCaption: TextConst ENU='TOTALORDER TO ORIGIN',ESP='TOTAL PEDIDO A ORIGEN';
// //       VATCaption@7001128 :
//       VATCaption: TextConst ENU=' % VAT',ESP=' % IVA';
// //       WithholdingTotalCaption@7001127 :
//       WithholdingTotalCaption: TextConst ENU='WITHHOLDING',ESP='RETENCIONES';
// //       AmountCaption@7001126 :
//       AmountCaption: TextConst ENU='Amount',ESP='Importe';
// //       ImprescindibleCaption@7001131 :
//       ImprescindibleCaption: TextConst ESP='ES IMPRESCINDIBLE QUE EN LA FACTURA SE INDIQUE DE FORMA CLARA EL NUMERO DE OBRA Y DE PEDIDO';
// //       FdoCaptionLbl@7001132 :
//       FdoCaptionLbl: TextConst ENU='Signed',ESP='Fdo.';
// //       ProveedorCaptionLbl@7001133 :
//       ProveedorCaptionLbl: TextConst ENU='VENDOR',ESP='PROVEEDOR';
// //       WithholdingGroup@7001134 :
//       WithholdingGroup: Record 7207330;
// //       PorcRetencion@7001135 :
//       PorcRetencion: Decimal;
// //       PaymentMethod@7001136 :
//       PaymentMethod: Record 289;
// //       FormaPago@7001137 :
//       FormaPago: Text;
// //       porcIVA@7001138 :
//       porcIVA: Decimal;
// //       Vendor@7001139 :
//       Vendor: Record 23;
// //       CIFVendor@7001140 :
//       CIFVendor: Text;
// //       ReversoContrato@7001141 :
//       ReversoContrato: Report 7207413;
// //       PaymentDay@7001142 :
//       PaymentDay: Record 10701;
// //       diapago@7001143 :
//       diapago: Integer;
// //       TelefonoProv@7001144 :
//       TelefonoProv: Text[30];
// //       ContactoProv@7001145 :
//       ContactoProv: Text[50];
// //       Job@7001147 :
//       Job: Record 167;
// //       ContactoObra@7001148 :
//       ContactoObra: Text[50];
// //       TelefonoObra@7001149 :
//       TelefonoObra: Text[30];
// //       SalespersonPurchaser@7001146 :
//       SalespersonPurchaser: Record 13;
// //       FechaInicio@7001150 :
//       FechaInicio: Date;
// //       FechaFin@7001151 :
//       FechaFin: Date;
// //       Nlinea@7001152 :
//       Nlinea: Code[20];
// //       ConceptoLinea@7001156 :
//       ConceptoLinea: Text;
// //       DireccionEntrega@7001153 :
//       DireccionEntrega: Text[100];
// //       Resource@7001154 :
//       Resource: Record 156;
// //       ShowUO@7001155 :
//       ShowUO: Boolean;
// //       ExtendedTextLine@7001157 :
//       ExtendedTextLine: Record 280;
// //       DataPieceworkForProduction@7001158 :
//       DataPieceworkForProduction: Record 7207386;
// //       VendorConditionsData@7001159 :
//       VendorConditionsData: Record 7207414;
// //       CPObra@7001160 :
//       CPObra: Text[10];
// //       PoblacionObra@7001161 :
//       PoblacionObra: Text[50];
// //       TxtAdicional@7001162 :
//       TxtAdicional: Text;
// //       QBText@100000000 :
//       QBText: Record 7206918;



// trigger OnInitReport();    begin
//                    GLSetup.GET;
//                    CompanyInfo.GET;
//                    PurchSetup.GET;
//                    ShowUO := TRUE;
//                  end;



// // procedure InitializeRequest (NewNoOfCopies@1002 : Integer;NewShowInternalInfo@1000 : Boolean;NewArchiveDocument@1001 : Boolean;NewLogInteraction@1003 :
// procedure InitializeRequest (NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewArchiveDocument: Boolean;NewLogInteraction: Boolean)
//     begin
//       NoOfCopies := NewNoOfCopies;
//       ShowInternalInfo := NewShowInternalInfo;
//       ArchiveDocument := NewArchiveDocument;
//       LogInteraction := NewLogInteraction;
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
//         FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);
//         FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
//         FormatDocument.SetPaymentTerms(PrepmtPaymentTerms,"Prepmt. Payment Terms Code","Language Code");
//         FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

//         ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
//         VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
//       end;
//     end;

// //     procedure ShowCashAccountingCriteria (PurchaseHeader@1100002 :
//     procedure ShowCashAccountingCriteria (PurchaseHeader: Record 38) : Text;
//     var
// //       VATPostingSetup@1100000 :
//       VATPostingSetup: Record 325;
// //       PurchaseLine@1100001 :
//       PurchaseLine: Record 39;
//     begin
//       GLSetup.GET;
//       if not GLSetup."Unrealized VAT" then
//         exit;
//       CACCaptionLbl := '';
//       PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
//       if PurchaseLine.FINDSET then
//         repeat
//           if VATPostingSetup.GET(PurchaseHeader."VAT Bus. Posting Group",PurchaseLine."VAT Prod. Posting Group") then
//             if VATPostingSetup."VAT Cash Regime" then
//               CACCaptionLbl := CACTxt;
//         until (PurchaseLine.NEXT = 0) or (CACCaptionLbl <> '');
//       exit(CACCaptionLbl);
//     end;

//     /*begin
//     //{
// //      JAV 11/03/19: - Se a¤aden Lables y se reordenan en sus grupos para que sea mas sencillo encontrarlos
// //                    - Se a¤ade una fila en la cabecera para indicar Datos pedido y Datos de la obra
// //                    - Se a¤ade el logo del calidad al pie y el n£mero de p gina
// //                    - Se ajustan las columnas en cuanto a orden y anchos
// //      JAV 13/03/19: - No inicializaba el texto y copiaba el anterior siempre
// //      PGM 19/03/19: - Se hace que saque cabceras y cierre el recuadro en todas las p ginas
// //      JAV 11/04/10: - Se cambia la variable "porcIVA" de entera a decimal
// //    }
//     end.
//   */

// }




