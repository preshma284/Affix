// report 50063 "INESCO Abono Venta Borrador"
// {


//     Permissions = TableData 7190 = rimd;
//     CaptionML = ENU = 'Sales - Credit Memo', ESP = 'Ventas - Abono';
//     PreviewMode = PrintLayout;

//     dataset
//     {

//         DataItem("Sales Header"; "Sales Header")
//         {

//             DataItemTableView = SORTING("No.");
//             RequestFilterHeadingML = ENU = 'Draft Sales Credit Memo', ESP = 'Borrador abonos venta';


//             RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
//             Column(No_SalesCrMemoHeader; NoDocFact)
//             {
//                 //SourceExpr=NoDocFact;
//             }
//             Column(DescripcionDivisa; DescDivisa)
//             {
//                 //SourceExpr=DescDivisa;
//             }
//             Column(TotalBase_Caption; TotalBase_CaptionLbl)
//             {
//                 //SourceExpr=TotalBase_CaptionLbl;
//             }
//             Column(footer; footer1)
//             {
//                 //SourceExpr=footer1;
//             }
//             Column(footer2; footer2)
//             {
//                 //SourceExpr=footer2;
//             }
//             DataItem("CopyLoop"; "2000000026")
//             {

//                 DataItemTableView = SORTING("Number");
//                 ;
//                 DataItem("PageLoop"; "2000000026")
//                 {

//                     DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = CONST(1));
//                     Column(CompanyInfo2Picture; CompanyInfo2.Picture)
//                     {
//                         //SourceExpr=CompanyInfo2.Picture;
//                     }
//                     Column(CompanyInfo1Picture; CompanyInfo1.Picture)
//                     {
//                         //SourceExpr=CompanyInfo1.Picture;
//                     }
//                     Column(CompanyInfoPicture; CompanyInfo3.Picture)
//                     {
//                         //SourceExpr=CompanyInfo3.Picture;
//                     }
//                     Column(SalesCorrectiveInvCopy; STRSUBSTNO(Text1100001, CopyText))
//                     {
//                         //SourceExpr=STRSUBSTNO(Text1100001,CopyText);
//                     }
//                     Column(CustAddr1; CustAddr[1])
//                     {
//                         //SourceExpr=CustAddr[1];
//                     }
//                     Column(CompanyAddr1; CompanyAddr[1])
//                     {
//                         //SourceExpr=CompanyAddr[1];
//                     }
//                     Column(CustAddr2; CustAddr[2])
//                     {
//                         //SourceExpr=CustAddr[2];
//                     }
//                     Column(CompanyAddr2; CompanyAddr[2])
//                     {
//                         //SourceExpr=CompanyAddr[2];
//                     }
//                     Column(CustAddr3; CustAddr[3])
//                     {
//                         //SourceExpr=CustAddr[3];
//                     }
//                     Column(CompanyAddr3; CompanyAddr[3])
//                     {
//                         //SourceExpr=CompanyAddr[3];
//                     }
//                     Column(CustAddr4; CustAddr[4])
//                     {
//                         //SourceExpr=CustAddr[4];
//                     }
//                     Column(CompanyAddr4; CompanyAddr[4])
//                     {
//                         //SourceExpr=CompanyAddr[4];
//                     }
//                     Column(CustAddr5; CustAddr[5])
//                     {
//                         //SourceExpr=CustAddr[5];
//                     }
//                     Column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
//                     {
//                         //SourceExpr=CompanyInfo."Phone No.";
//                     }
//                     Column(CustAddr6; CustAddr[6])
//                     {
//                         //SourceExpr=CustAddr[6];
//                     }
//                     Column(CompanyInfoHomePage; CompanyInfo."Home Page")
//                     {
//                         //SourceExpr=CompanyInfo."Home Page";
//                     }
//                     Column(CompanyInfoEMail; CompanyInfo."E-Mail")
//                     {
//                         //SourceExpr=CompanyInfo."E-Mail";
//                     }
//                     Column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
//                     {
//                         //SourceExpr=CompanyInfo."VAT Registration No.";
//                     }
//                     Column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
//                     {
//                         //SourceExpr=CompanyInfo."Giro No.";
//                     }
//                     Column(CompanyInfoBankName; CompanyInfo."Bank Name")
//                     {
//                         //SourceExpr=CompanyInfo."Bank Name";
//                     }
//                     Column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
//                     {
//                         //SourceExpr=CompanyInfo."Bank Account No.";
//                     }
//                     Column(BilltoCustNo_SalesCrMemoHeader; "Sales Header"."Bill-to Customer No.")
//                     {
//                         //SourceExpr="Sales Header"."Bill-to Customer No.";
//                     }
//                     Column(PostDate_SalesCrMemoHeader; FORMAT("Sales Header"."Posting Date", 0, 4))
//                     {
//                         //SourceExpr=FORMAT("Sales Header"."Posting Date",0,4);
//                     }
//                     Column(VATNoText; VATNoText)
//                     {
//                         //SourceExpr=VATNoText;
//                     }
//                     Column(VATRegNo_SalesCrMemoHeader; "Sales Header"."VAT Registration No.")
//                     {
//                         //SourceExpr="Sales Header"."VAT Registration No.";
//                     }
//                     Column(SalesPersonText; SalesPersonText)
//                     {
//                         //SourceExpr=SalesPersonText;
//                     }
//                     Column(SalesPurchPersonName; SalesPurchPerson.Name)
//                     {
//                         //SourceExpr=SalesPurchPerson.Name;
//                     }
//                     Column(AppliedToText; AppliedToText)
//                     {
//                         //SourceExpr=AppliedToText;
//                     }
//                     Column(ReferenceText; ReferenceText)
//                     {
//                         //SourceExpr=ReferenceText;
//                     }
//                     Column(YourRef_SalesCrMemoHeader; "Sales Header"."Your Reference")
//                     {
//                         //SourceExpr="Sales Header"."Your Reference";
//                     }
//                     Column(CustAddr7; CustAddr[7])
//                     {
//                         //SourceExpr=CustAddr[7];
//                     }
//                     Column(CustAddr8; CustAddr[8])
//                     {
//                         //SourceExpr=CustAddr[8];
//                     }
//                     Column(CompanyAddr5; CompanyAddr[5])
//                     {
//                         //SourceExpr=CompanyAddr[5];
//                     }
//                     Column(CompanyAddr6; CompanyAddr[6])
//                     {
//                         //SourceExpr=CompanyAddr[6];
//                     }
//                     Column(DocDate_SalesCrMemoHeader; FORMAT("Sales Header"."Document Date", 0, 4))
//                     {
//                         //SourceExpr=FORMAT("Sales Header"."Document Date",0,4);
//                     }
//                     Column(PricIncVAT_SalesCrMemoHeader; "Sales Header"."Prices Including VAT")
//                     {
//                         //SourceExpr="Sales Header"."Prices Including VAT";
//                     }
//                     Column(ReturnOrderNoText; ReturnOrderNoText)
//                     {
//                         //SourceExpr=ReturnOrderNoText;
//                     }
//                     Column(RetOrderNo_SalesCrMemoHeader; "Sales Header"."No.")
//                     {
//                         //SourceExpr="Sales Header"."No.";
//                     }
//                     Column(PageCaption; PageCaptionCap)
//                     {
//                         //SourceExpr=PageCaptionCap;
//                     }
//                     Column(OutputNo; OutputNo)
//                     {
//                         //SourceExpr=OutputNo;
//                     }
//                     Column(PricInclVAT1_SalesCrMemoHeader; FORMAT("Sales Header"."Prices Including VAT"))
//                     {
//                         //SourceExpr=FORMAT("Sales Header"."Prices Including VAT");
//                     }
//                     Column(VATBaseDiscPct_SalesCrMemoHeader; "Sales Header"."VAT Base Discount %")
//                     {
//                         //SourceExpr="Sales Header"."VAT Base Discount %";
//                     }
//                     Column(CorrInvNo_SalesCrMemoHeader; "Sales Header"."Corrected Invoice No.")
//                     {
//                         //SourceExpr="Sales Header"."Corrected Invoice No.";
//                     }
//                     Column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoPhoneNoCaptionLbl;
//                     }
//                     Column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoHomePageCaptionLbl;
//                     }
//                     Column(CompanyInfoEMailCaption; CompanyInfoEMailCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoEMailCaptionLbl;
//                     }
//                     Column(CompanyInfoVATRegistrationNoCaption; CompanyInfoVATRegistrationNoCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoVATRegistrationNoCaptionLbl;
//                     }
//                     Column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoGiroNoCaptionLbl;
//                     }
//                     Column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoBankNameCaptionLbl;
//                     }
//                     Column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
//                     {
//                         //SourceExpr=CompanyInfoBankAccountNoCaptionLbl;
//                     }
//                     Column(SalesCrMemoHeaderNoCaption; SalesCrMemoHeaderNoCaptionLbl)
//                     {
//                         //SourceExpr=SalesCrMemoHeaderNoCaptionLbl;
//                     }
//                     Column(SalesCrMemoHeaderPostingDateCaption; SalesCrMemoHeaderPostingDateCaptionLbl)
//                     {
//                         //SourceExpr=SalesCrMemoHeaderPostingDateCaptionLbl;
//                     }
//                     Column(CorrectedInvoiceNoCaption; CorrectedInvoiceNoCaptionLbl)
//                     {
//                         //SourceExpr=CorrectedInvoiceNoCaptionLbl;
//                     }
//                     Column(DocumentDateCaption; DocumentDateCaptionLbl)
//                     {
//                         //SourceExpr=DocumentDateCaptionLbl;
//                     }
//                     Column(BilltoCustNo_SalesCrMemoHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
//                     {
//                         //SourceExpr="Sales Header".FIELDCAPTION("Bill-to Customer No.");
//                     }
//                     Column(PricIncVAT_SalesCrMemoHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
//                     {
//                         //SourceExpr="Sales Header".FIELDCAPTION("Prices Including VAT");
//                     }
//                     Column(CACCaption; CACCaptionLbl)
//                     {
//                         //SourceExpr=CACCaptionLbl;
//                     }
//                     Column(NoAbonoCaption; NoAbonoCaptionLbl)
//                     {
//                         //SourceExpr=NoAbonoCaptionLbl;
//                     }
//                     Column(VencimientoCaption; VencimientoCaptionLbl)
//                     {
//                         //SourceExpr=VencimientoCaptionLbl;
//                     }
//                     Column(FormaPagoCaption; FormaPago_CaptionLbl)
//                     {
//                         //SourceExpr=FormaPago_CaptionLbl;
//                     }
//                     Column(ConceptoAbonoCaption; ConceptoAbonoCaptionLbl)
//                     {
//                         //SourceExpr=ConceptoAbonoCaptionLbl;
//                     }
//                     Column(Iva_Caption; IVA_CaptionLbl)
//                     {
//                         //SourceExpr=IVA_CaptionLbl;
//                     }
//                     Column(TotalAbono_Caption; TotalAbono_CaptionLbl)
//                     {
//                         //SourceExpr=TotalAbono_CaptionLbl;
//                     }
//                     Column(ClienteCaption; ClienteCaptionLbl)
//                     {
//                         //SourceExpr=ClienteCaptionLbl;
//                     }
//                     Column(CompaniInfoCity; CompanyInfo.City)
//                     {
//                         //SourceExpr=CompanyInfo.City;
//                     }
//                     Column(Retencion_Caption; Retencion_CaptionLbl)
//                     {
//                         //SourceExpr=Retencion_CaptionLbl;
//                     }
//                     Column(ImporteRetencion; "Sales Line"."QW Withholding Amount by GE")
//                     {
//                         //SourceExpr="Sales Line"."QW Withholding Amount by GE";
//                     }
//                     Column(NCUenta_Caption; NCuenta_CaptionLbl)
//                     {
//                         //SourceExpr=NCuenta_CaptionLbl;
//                     }
//                     Column(DescripcionPago; DescPago)
//                     {
//                         //SourceExpr=DescPago;
//                     }
//                     Column(FormaPago; FormaPago)
//                     {
//                         //SourceExpr=FormaPago;
//                     }
//                     Column(WorkDesc; WorkDesc)
//                     {
//                         //SourceExpr=WorkDesc;
//                     }
//                     Column(WithholdingAmt; WithholdingAmt)
//                     {
//                         //SourceExpr=WithholdingAmt;
//                     }
//                     DataItem("DimensionLoop1"; "2000000026")
//                     {

//                         DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = FILTER(1 ..));


//                         DataItemLinkReference = "Sales Header";
//                         Column(DimText; DimText)
//                         {
//                             //SourceExpr=DimText;
//                         }
//                         Column(Number_IntegerLine; Number)
//                         {
//                             //SourceExpr=Number;
//                         }
//                         Column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
//                         {
//                             //SourceExpr=HeaderDimensionsCaptionLbl;
//                         }
//                         DataItem("Sales Line"; "Sales Line")
//                         {

//                             DataItemTableView = SORTING("Document No.", "Line No.");


//                             DataItemLinkReference = "Sales Header";
//                             DataItemLink = "Document No." = FIELD("No.");
//                             Column(LineAmt_SalesCrMemoLine; "Line Amount")
//                             {
//                                 //SourceExpr="Line Amount";
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(Desc_SalesCrMemoLine; Description)
//                             {
//                                 //SourceExpr=Description;
//                             }
//                             Column(No_SalesCrMemoLine; "No.")
//                             {
//                                 //SourceExpr="No.";
//                             }
//                             Column(Qty_SalesCrMemoLine; Quantity)
//                             {
//                                 //SourceExpr=Quantity;
//                             }
//                             Column(UOM_SalesCrMemoLine; "Unit of Measure")
//                             {
//                                 //SourceExpr="Unit of Measure";
//                             }
//                             Column(UnitPrice_SalesCrMemoLine; "Unit Price")
//                             {
//                                 //SourceExpr="Unit Price";
//                                 AutoFormatType = 2;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(LineDisc_SalesCrMemoLine; "Line Discount %")
//                             {
//                                 //SourceExpr="Line Discount %";
//                             }
//                             Column(VATIdent_SalesCrMemoLine; "VAT Identifier")
//                             {
//                                 //SourceExpr="VAT Identifier";
//                             }
//                             Column(PostedReceiptDate; FORMAT(PostedReceiptDate))
//                             {
//                                 //SourceExpr=FORMAT(PostedReceiptDate);
//                             }
//                             Column(Type_SalesCrMemoLine; FORMAT(Type))
//                             {
//                                 //SourceExpr=FORMAT(Type);
//                             }
//                             Column(NNCTotalLineAmt; NNC_TotalLineAmount)
//                             {
//                                 //SourceExpr=NNC_TotalLineAmount;
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(NNCTotalAmtInclVat; NNC_TotalAmountInclVat)
//                             {
//                                 //SourceExpr=NNC_TotalAmountInclVat;
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(NNCTotalInvDiscAmt; NNC_TotalInvDiscAmount)
//                             {
//                                 //SourceExpr=NNC_TotalInvDiscAmount;
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(NNCTotalAmt; NNC_TotalAmount)
//                             {
//                                 //SourceExpr=NNC_TotalAmount;
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(InvDiscAmt_SalesCrMemoLine; -"Inv. Discount Amount")
//                             {
//                                 //SourceExpr=-"Inv. Discount Amount";
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(PmtDiscAmt_SalesCrMemoLine; -"Pmt. Discount Amount")
//                             {
//                                 //SourceExpr=-"Pmt. Discount Amount";
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = GetCurrencyCode;
//                             }
//                             Column(TotalExclVATText; TotalExclVATText)
//                             {
//                                 //SourceExpr=TotalExclVATText;
//                             }
//                             Column(TotalInclVATText; TotalInclVATText)
//                             {
//                                 //SourceExpr=TotalInclVATText;
//                             }
//                             Column(AmtIncVAT_SalesCrMemoLine; "Amount Including VAT")
//                             {
//                                 //SourceExpr="Amount Including VAT";
//                                 AutoFormatType = 1;
//                             }
//                             Column(AmtIncVATAmt_SalesCrMemoLine; "Amount Including VAT" - Amount)
//                             {
//                                 //SourceExpr="Amount Including VAT" - Amount;
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = SalesCrMemoLine.GetCurrencyCode;
//                             }
//                             Column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
//                             {
//                                 //SourceExpr=VATAmountLine.VATAmountText;
//                             }
//                             Column(Amt_SalesCrMemoLine; Amount)
//                             {
//                                 //SourceExpr=Amount;
//                                 AutoFormatType = 1;
//                                 AutoFormatExpression = SalesCrMemoLine.GetCurrencyCode;
//                             }
//                             Column(DocNo_SalesCrMemoLine; "Document No.")
//                             {
//                                 //SourceExpr="Document No.";
//                             }
//                             Column(LineNo_SalesCrMemoLine; "Line No.")
//                             {
//                                 //SourceExpr="Line No.";
//                             }
//                             Column(UnitPriceCaption; UnitPriceCaptionLbl)
//                             {
//                                 //SourceExpr=UnitPriceCaptionLbl;
//                             }
//                             Column(SalesCrMemoLineLineDiscountCaption; SalesCrMemoLineLineDiscountCaptionLbl)
//                             {
//                                 //SourceExpr=SalesCrMemoLineLineDiscountCaptionLbl;
//                             }
//                             Column(AmountCaption; AmountCaptionLbl)
//                             {
//                                 //SourceExpr=AmountCaptionLbl;
//                             }
//                             Column(PostedReceiptDateCaption; PostedReceiptDateCaptionLbl)
//                             {
//                                 //SourceExpr=PostedReceiptDateCaptionLbl;
//                             }
//                             Column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
//                             {
//                                 //SourceExpr=InvDiscountAmountCaptionLbl;
//                             }
//                             Column(SubtotalCaption; SubtotalCaptionLbl)
//                             {
//                                 //SourceExpr=SubtotalCaptionLbl;
//                             }
//                             Column(PmtDiscGivenAmountCaption; PmtDiscGivenAmountCaptionLbl)
//                             {
//                                 //SourceExpr=PmtDiscGivenAmountCaptionLbl;
//                             }
//                             Column(Desc_SalesCrMemoLineCaption; FIELDCAPTION(Description))
//                             {
//                                 //SourceExpr=FIELDCAPTION(Description);
//                             }
//                             Column(No_SalesCrMemoLineCaption; FIELDCAPTION("No."))
//                             {
//                                 //SourceExpr=FIELDCAPTION("No.");
//                             }
//                             Column(Qty_SalesCrMemoLineCaption; FIELDCAPTION(Quantity))
//                             {
//                                 //SourceExpr=FIELDCAPTION(Quantity);
//                             }
//                             Column(UOM_SalesCrMemoLineCaption; FIELDCAPTION("Unit of Measure"))
//                             {
//                                 //SourceExpr=FIELDCAPTION("Unit of Measure");
//                             }
//                             Column(VATIdent_SalesCrMemoLineCaption; FIELDCAPTION("VAT Identifier"))
//                             {
//                                 //SourceExpr=FIELDCAPTION("VAT Identifier");
//                             }
//                             Column(Description2; "Sales Line"."Description 2")
//                             {
//                                 //SourceExpr="Sales Line"."Description 2";
//                             }
//                             DataItem("BlankRows"; "2000000026")
//                             {

//                                 ;
//                                 Column(Number; Number)
//                                 {
//                                     //SourceExpr=Number;
//                                 }
//                                 DataItem("Sales Shipment Buffer"; "2000000026")
//                                 {

//                                     DataItemTableView = SORTING("Number");
//                                     ;
//                                     Column(SalesShptBufferPostDate; FORMAT(SalesShipmentBuffer."Posting Date"))
//                                     {
//                                         //SourceExpr=FORMAT(SalesShipmentBuffer."Posting Date");
//                                     }
//                                     Column(SalesShptBufferQuantity; SalesShipmentBuffer.Quantity)
//                                     {
//                                         DecimalPlaces = 0 : 5;
//                                         //SourceExpr=SalesShipmentBuffer.Quantity;
//                                     }
//                                     Column(ReturnReceiptCaption; ReturnReceiptCaptionLbl)
//                                     {
//                                         //SourceExpr=ReturnReceiptCaptionLbl;
//                                     }
//                                     DataItem("DimensionLoop2"; "2000000026")
//                                     {

//                                         DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = FILTER(1 ..));
//                                         ;
//                                         Column(DimText1; DimText)
//                                         {
//                                             //SourceExpr=DimText;
//                                         }
//                                         Column(LineDimensionsCaption; LineDimensionsCaptionLbl)
//                                         {
//                                             //SourceExpr=LineDimensionsCaptionLbl;
//                                         }
//                                         DataItem("VATCounter"; "2000000026")
//                                         {

//                                             DataItemTableView = SORTING("Number");
//                                             ;
//                                             Column(VATAmtLineVATECBase; VATAmountLine."VAT Base")
//                                             {
//                                                 //SourceExpr=VATAmountLine."VAT Base";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
//                                             {
//                                                 //SourceExpr=VATAmountLine."VAT Amount";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
//                                             {
//                                                 //SourceExpr=VATAmountLine."Line Amount";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
//                                             {
//                                                 //SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
//                                             {
//                                                 //SourceExpr=VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmtLineECAmt; VATAmountLine."EC Amount")
//                                             {
//                                                 //SourceExpr=VATAmountLine."EC Amount";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmtLineVAT; VATAmountLine."VAT %")
//                                             {
//                                                 DecimalPlaces = 0 : 6;
//                                                 //SourceExpr=VATAmountLine."VAT %";
//                                             }
//                                             Column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
//                                             {
//                                                 //SourceExpr=VATAmountLine."VAT Identifier";
//                                             }
//                                             Column(VATAmtLineEC; VATAmountLine."EC %")
//                                             {
//                                                 //SourceExpr=VATAmountLine."EC %";
//                                                 AutoFormatType = 1;
//                                                 AutoFormatExpression = "Sales Header"."Currency Code";
//                                             }
//                                             Column(VATAmountLineVATCaption; VATAmountLineVATCaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineVATCaptionLbl;
//                                             }
//                                             Column(VATAmountLineVATECBaseControl105Caption; VATAmountLineVATECBaseControl105CaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineVATECBaseControl105CaptionLbl;
//                                             }
//                                             Column(VATAmountLineVATAmountControl106Caption; VATAmountLineVATAmountControl106CaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineVATAmountControl106CaptionLbl;
//                                             }
//                                             Column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountSpecificationCaptionLbl;
//                                             }
//                                             Column(VATAmountLineVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineVATIdentifierCaptionLbl;
//                                             }
//                                             Column(VATAmountLineInvDiscBaseAmountControl130Caption; VATAmountLineInvDiscBaseAmountControl130CaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineInvDiscBaseAmountControl130CaptionLbl;
//                                             }
//                                             Column(VATAmountLineLineAmountControl135Caption; VATAmountLineLineAmountControl135CaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineLineAmountControl135CaptionLbl;
//                                             }
//                                             Column(InvandPmtDiscountsCaption; InvandPmtDiscountsCaptionLbl)
//                                             {
//                                                 //SourceExpr=InvandPmtDiscountsCaptionLbl;
//                                             }
//                                             Column(ECCaption; ECCaptionLbl)
//                                             {
//                                                 //SourceExpr=ECCaptionLbl;
//                                             }
//                                             Column(ECAmountCaption; ECAmountCaptionLbl)
//                                             {
//                                                 //SourceExpr=ECAmountCaptionLbl;
//                                             }
//                                             Column(VATAmountLineVATECBaseControl113Caption; VATAmountLineVATECBaseControl113CaptionLbl)
//                                             {
//                                                 //SourceExpr=VATAmountLineVATECBaseControl113CaptionLbl;
//                                             }
//                                             DataItem("VATClauseEntryCounter"; "2000000026")
//                                             {

//                                                 DataItemTableView = SORTING("Number");
//                                                 ;
//                                                 Column(VATClauseVATIdentifier; VATAmountLine."VAT Identifier")
//                                                 {
//                                                     //SourceExpr=VATAmountLine."VAT Identifier";
//                                                 }
//                                                 Column(VATClauseCode; VATAmountLine."VAT Clause Code")
//                                                 {
//                                                     //SourceExpr=VATAmountLine."VAT Clause Code";
//                                                 }
//                                                 Column(VATClauseDescription; VATClause.Description)
//                                                 {
//                                                     //SourceExpr=VATClause.Description;
//                                                 }
//                                                 Column(VATClauseDescription2; VATClause."Description 2")
//                                                 {
//                                                     //SourceExpr=VATClause."Description 2";
//                                                 }
//                                                 Column(VATClauseAmount; VATAmountLine."VAT Amount")
//                                                 {
//                                                     //SourceExpr=VATAmountLine."VAT Amount";
//                                                     AutoFormatType = 1;
//                                                     AutoFormatExpression = "Sales Header"."Currency Code";
//                                                 }
//                                                 Column(VATClausesCaption; VATClausesCap)
//                                                 {
//                                                     //SourceExpr=VATClausesCap;
//                                                 }
//                                                 Column(VATClauseVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
//                                                 {
//                                                     //SourceExpr=VATAmountLineVATIdentifierCaptionLbl;
//                                                 }
//                                                 Column(VATClauseVATAmtCaption; VATAmountLineVATAmountControl106CaptionLbl)
//                                                 {
//                                                     //SourceExpr=VATAmountLineVATAmountControl106CaptionLbl;
//                                                 }
//                                                 DataItem("VATCounterLCY"; "2000000026")
//                                                 {

//                                                     DataItemTableView = SORTING("Number");
//                                                     ;
//                                                     Column(VALSpecLCYHeader; VALSpecLCYHeader)
//                                                     {
//                                                         //SourceExpr=VALSpecLCYHeader;
//                                                     }
//                                                     Column(VALExchRate; VALExchRate)
//                                                     {
//                                                         //SourceExpr=VALExchRate;
//                                                     }
//                                                     Column(VALVATAmtLCY; VALVATAmountLCY)
//                                                     {
//                                                         //SourceExpr=VALVATAmountLCY;
//                                                         AutoFormatType = 1;
//                                                     }
//                                                     Column(VALVATBaseLCY; VALVATBaseLCY)
//                                                     {
//                                                         //SourceExpr=VALVATBaseLCY;
//                                                         AutoFormatType = 1;
//                                                     }
//                                                     Column(VATAmtLineVAT1; VATAmountLine."VAT %")
//                                                     {
//                                                         DecimalPlaces = 0 : 5;
//                                                         //SourceExpr=VATAmountLine."VAT %";
//                                                     }
//                                                     Column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
//                                                     {
//                                                         //SourceExpr=VATAmountLine."VAT Identifier";
//                                                     }
//                                                     DataItem("Total"; "2000000026")
//                                                     {

//                                                         DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = CONST(1));
//                                                     }
//                                                     DataItem("Total2"; "2000000026")
//                                                     {

//                                                         DataItemTableView = SORTING("Number")
//                                  WHERE("Number" = CONST(1));
//                                                         ;
//                                                         Column(SelltoCustNo_SalesCrMemoHeader; "Sales Header"."Sell-to Customer No.")
//                                                         {
//                                                             //SourceExpr="Sales Header"."Sell-to Customer No.";
//                                                         }
//                                                         Column(ShipToAddr1; ShipToAddr[1])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[1];
//                                                         }
//                                                         Column(ShipToAddr2; ShipToAddr[2])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[2];
//                                                         }
//                                                         Column(ShipToAddr3; ShipToAddr[3])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[3];
//                                                         }
//                                                         Column(ShipToAddr4; ShipToAddr[4])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[4];
//                                                         }
//                                                         Column(ShipToAddr5; ShipToAddr[5])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[5];
//                                                         }
//                                                         Column(ShipToAddr6; ShipToAddr[6])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[6];
//                                                         }
//                                                         Column(ShipToAddr7; ShipToAddr[7])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[7];
//                                                         }
//                                                         Column(ShipToAddr8; ShipToAddr[8])
//                                                         {
//                                                             //SourceExpr=ShipToAddr[8];
//                                                         }
//                                                         Column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
//                                                         {
//                                                             //SourceExpr=ShiptoAddressCaptionLbl;
//                                                         }
//                                                         Column(SelltoCustNo_SalesCrMemoHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
//                                                         {
//                                                             //SourceExpr="Sales Header".FIELDCAPTION("Sell-to Customer No.") ;
//                                                         }
//                                                         trigger OnPreDataItem();
//                                                         BEGIN
//                                                             IF NOT ShowShippingAddr THEN
//                                                                 CurrReport.BREAK;
//                                                         END;


//                                                     }
//                                                     trigger OnPreDataItem();
//                                                     BEGIN
//                                                         IF (NOT GLSetup."Print VAT specification in LCY") OR
//                                                            ("Sales Header"."Currency Code" = '')
//                                                         THEN
//                                                             CurrReport.BREAK;

//                                                         SETRANGE(Number, 1, VATAmountLine.COUNT);
//                                                         CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

//                                                         IF GLSetup."LCY Code" = '' THEN
//                                                             VALSpecLCYHeader := Text008 + Text009
//                                                         ELSE
//                                                             VALSpecLCYHeader := Text008 + FORMAT(GLSetup."LCY Code");

//                                                         CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
//                                                         CalculatedExchRate := ROUND(1 / "Sales Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
//                                                         VALExchRate := STRSUBSTNO(Text010, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
//                                                     END;

//                                                     trigger OnAfterGetRecord();
//                                                     BEGIN
//                                                         VATAmountLine.GetLine(Number);
//                                                         VALVATBaseLCY :=
//                                                           VATAmountLine.GetBaseLCY(
//                                                             "Sales Header"."Posting Date", "Sales Header"."Currency Code",
//                                                             "Sales Header"."Currency Factor");
//                                                         VALVATAmountLCY :=
//                                                           VATAmountLine.GetAmountLCY(
//                                                             "Sales Header"."Posting Date", "Sales Header"."Currency Code",
//                                                             "Sales Header"."Currency Factor");
//                                                     END;


//                                                 }
//                                                 trigger OnPreDataItem();
//                                                 BEGIN
//                                                     CLEAR(VATClause);
//                                                     SETRANGE(Number, 1, VATAmountLine.COUNT);
//                                                     CurrReport.CREATETOTALS(VATAmountLine."VAT Amount");
//                                                 END;

//                                                 trigger OnAfterGetRecord();
//                                                 BEGIN
//                                                     VATAmountLine.GetLine(Number);
//                                                     IF NOT VATClause.GET(VATAmountLine."VAT Clause Code") THEN
//                                                         CurrReport.SKIP;
//                                                     VATClause.TranslateDescription("Sales Header"."Language Code");
//                                                 END;


//                                             }
//                                             trigger OnPreDataItem();
//                                             BEGIN
//                                                 SETRANGE(Number, 1, VATAmountLine.COUNT);
//                                                 CurrReport.CREATETOTALS(
//                                                   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
//                                                   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount",
//                                                   VATAmountLine."EC Amount", VATAmountLine."Pmt. Discount Amount");
//                                             END;

//                                             trigger OnAfterGetRecord();
//                                             BEGIN
//                                                 VATAmountLine.GetLine(Number);
//                                             END;


//                                         }
//                                         trigger OnPreDataItem();
//                                         BEGIN
//                                             IF NOT ShowInternalInfo THEN
//                                                 CurrReport.BREAK;

//                                             DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
//                                         END;

//                                         trigger OnAfterGetRecord();
//                                         BEGIN
//                                             IF Number = 1 THEN BEGIN
//                                                 IF NOT DimSetEntry2.FIND('-') THEN
//                                                     CurrReport.BREAK;
//                                             END ELSE
//                                                 IF NOT Continue THEN
//                                                     CurrReport.BREAK;

//                                             CLEAR(DimText);
//                                             Continue := FALSE;
//                                             REPEAT
//                                                 OldDimText := DimText;
//                                                 IF DimText = '' THEN
//                                                     DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
//                                                 ELSE
//                                                     DimText :=
//                                                       STRSUBSTNO(
//                                                         '%1, %2 %3', DimText,
//                                                         DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
//                                                 IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                                     DimText := OldDimText;
//                                                     Continue := TRUE;
//                                                     EXIT;
//                                                 END;
//                                             UNTIL DimSetEntry2.NEXT = 0;
//                                         END;


//                                     }
//                                     trigger OnPreDataItem();
//                                     BEGIN
//                                         SETRANGE(Number, 1, SalesShipmentBuffer.COUNT);
//                                     END;

//                                     trigger OnAfterGetRecord();
//                                     BEGIN
//                                         IF Number = 1 THEN
//                                             SalesShipmentBuffer.FIND('-')
//                                         ELSE
//                                             SalesShipmentBuffer.NEXT;
//                                     END;


//                                 }
//                                 trigger OnPreDataItem();
//                                 BEGIN
//                                     NumSpaces := 5 - "Sales Line".COUNT;
//                                     SETRANGE(Number, 1, NumSpaces);
//                                 END;

//                                 trigger OnPostDataItem();
//                                 BEGIN
//                                     BlankRows.Number := 0;
//                                 END;


//                             }
//                             trigger OnPreDataItem();
//                             BEGIN
//                                 VATAmountLine.DELETEALL;
//                                 SalesShipmentBuffer.RESET;
//                                 SalesShipmentBuffer.DELETEALL;
//                                 FirstValueEntryNo := 0;
//                                 MoreLines := FIND('+');
//                                 WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
//                                     MoreLines := NEXT(-1) <> 0;
//                                 IF NOT MoreLines THEN
//                                     CurrReport.BREAK;
//                                 SETRANGE("Line No.", 0, "Line No.");
//                                 CurrReport.CREATETOTALS(Amount, "Amount Including VAT", "Inv. Discount Amount", "Pmt. Discount Amount");
//                             END;

//                             trigger OnAfterGetRecord();
//                             BEGIN
//                                 NNC_TotalLineAmount += "Line Amount";
//                                 NNC_TotalAmountInclVat += "Amount Including VAT";
//                                 NNC_TotalInvDiscAmount += "Inv. Discount Amount";
//                                 NNC_TotalAmount += Amount;

//                                 SalesShipmentBuffer.DELETEALL;
//                                 PostedReceiptDate := 0D;
//                                 IF Quantity <> 0 THEN
//                                     PostedReceiptDate := FindPostedShipmentDate;

//                                 IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
//                                     "No." := '';

//                                 IF VATPostingSetup.GET("Sales Line"."VAT Bus. Posting Group", "Sales Line"."VAT Prod. Posting Group") THEN BEGIN
//                                     VATAmountLine.INIT;
//                                     VATAmountLine."VAT Identifier" := "VAT Identifier";
//                                     VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
//                                     VATAmountLine."Tax Group Code" := "Tax Group Code";
//                                     VATAmountLine."VAT %" := VATPostingSetup."VAT %";
//                                     VATAmountLine."EC %" := VATPostingSetup."EC %";
//                                     VATAmountLine."VAT Base" := "Sales Line".Amount;
//                                     VATAmountLine."Amount Including VAT" := "Sales Line"."Amount Including VAT";
//                                     VATAmountLine."Line Amount" := "Line Amount";
//                                     VATAmountLine."Pmt. Discount Amount" := "Pmt. Discount Amount";
//                                     VATAmountLine.SetCurrencyCode("Sales Header"."Currency Code");
//                                     IF "Allow Invoice Disc." THEN
//                                         VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
//                                     VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
//                                     VATAmountLine."VAT Difference" := "VAT Difference";
//                                     VATAmountLine."EC Difference" := "EC Difference";
//                                     IF "Sales Header"."Prices Including VAT" THEN
//                                         VATAmountLine."Prices Including VAT" := TRUE;
//                                     VATAmountLine."VAT Clause Code" := "VAT Clause Code";
//                                     VATAmountLine.InsertLine;
//                                 END;
//                             END;


//                         }
//                         trigger OnPreDataItem();
//                         BEGIN
//                             IF NOT ShowInternalInfo THEN
//                                 CurrReport.BREAK;
//                         END;

//                         trigger OnAfterGetRecord();
//                         BEGIN
//                             IF Number = 1 THEN BEGIN
//                                 IF NOT DimSetEntry1.FINDSET THEN
//                                     CurrReport.BREAK;
//                             END ELSE
//                                 IF NOT Continue THEN
//                                     CurrReport.BREAK;

//                             CLEAR(DimText);
//                             Continue := FALSE;
//                             REPEAT
//                                 OldDimText := DimText;
//                                 IF DimText = '' THEN
//                                     DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
//                                 ELSE
//                                     DimText :=
//                                       STRSUBSTNO(
//                                         '%1, %2 %3', DimText,
//                                         DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
//                                 IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
//                                     DimText := OldDimText;
//                                     Continue := TRUE;
//                                     EXIT;
//                                 END;
//                             UNTIL DimSetEntry1.NEXT = 0;
//                         END;


//                     }
//                     trigger OnPreDataItem();
//                     BEGIN
//                         NoOfLoops := ABS(NoOfCopies) + 1;
//                         CopyText := '';
//                         SETRANGE(Number, 1, NoOfLoops);
//                         OutputNo := 1;
//                     END;

//                     trigger OnAfterGetRecord();
//                     BEGIN
//                         CurrReport.PAGENO := 1;
//                         IF Number > 1 THEN BEGIN
//                             CopyText := FormatDocument.GetCOPYText;
//                             OutputNo += 1;
//                         END;

//                         NNC_TotalLineAmount := 0;
//                         NNC_TotalAmountInclVat := 0;
//                         NNC_TotalInvDiscAmount := 0;
//                         NNC_TotalAmount := 0;
//                     END;


//                 }
//                 trigger OnAfterGetRecord();
//                 BEGIN
//                     CurrReport.LANGUAGE := Language.GetLanguageID(Language."Language Code");

//                     FormatAddressFields("Sales Header");
//                     FormatDocumentFields("Sales Header");

//                     DimSetEntry1.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");

//                     //ShowCashAccountingCriteria("Sales Header");
//                     //      procedure LogDocument(DocumentType: Integer; DocumentNo: Code[20]; DocNoOccurrence: 
//                     //      Integer; VersionNo: Integer; AccountTableNo: Integer; AccountNo: Code[20]; SalespersonCode: Code[20]; 
//                     //      CampaignNo: Code[20]; Description: Text[100]; OpportunityNo: Code[20]): Integer

//                     IF LogInteraction THEN
//                         IF NOT CurrReport.PREVIEW THEN
//                             IF "Bill-to Contact No." <> '' THEN
//                                 SegManagement.LogDocument(
//                                   6, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
//                                   "Campaign No.", "Posting Description", '')
//                             ELSE
//                                 SegManagement.LogDocument(
//                                   6, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
//                                   "Campaign No.", "Posting Description", '');

//                     Currency.RESET;
//                     Currency.SETRANGE(Code, "Currency Code");
//                     IF Currency.FINDFIRST THEN
//                         DescDivisa := Currency.Description
//                     ELSE
//                         DescDivisa := 'Euros';


//                     PaymentTerms.RESET;
//                     PaymentTerms.SETRANGE(Code, "Payment Terms Code");
//                     IF PaymentTerms.FINDSET THEN
//                         DescPago := PaymentTerms.Description;

//                     PaymentMethod.RESET;
//                     PaymentMethod.SETRANGE(Code, "Payment Method Code");
//                     IF PaymentMethod.FINDSET THEN
//                         FormaPago := PaymentMethod.Description;

//                     //pgm
//                     SaltoLinea := 10;
//                     footer1 := CompanyInfo.Name + FORMAT(SaltoLinea) + CompanyInfo.Address + ' - Telf. ' + CompanyInfo."Phone No." + ' - Fax. ' + CompanyInfo."Fax No." + ' - ' + CompanyInfo."Post Code" + ' ' + CompanyInfo.City;
//                     footer2 := QuoBuildingSetup."Commercial Register";

//                     WorkDesc := "Sales Header".GetWorkDescription; //Q8890

//                     ///QUONEXT PER 07.05.19 Calculo del n£mero de serie siguiente de factura.
//                     NoDocFact := "No.";
//                     IF CalcularSerie THEN BEGIN
//                         FncCalcularSerie("Sales Header");
//                         NoDocFact := "Sales Header"."Posting No.";
//                     END;
//                     ///FIN QUONEXT PER 07.05.19

//                     //Retenciones
//                     WithholdingGroup.RESET;
//                     WithholdingGroup.SETRANGE("Withholding Type", WithholdingGroup."Withholding Type"::"G.E");
//                     WithholdingGroup.SETRANGE(Code, "Sales Header"."QW Cod. Withholding by GE");
//                     IF WithholdingGroup.FINDFIRST THEN BEGIN
//                         "Sales Header".CALCFIELDS(Amount);
//                         WithholdingAmt := ("Sales Header".Amount * WithholdingGroup."Percentage Withholding") / 100;
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
//                 group("group162")
//                 {

//                     CaptionML = ENU = 'Options', ESP = 'Opciones';
//                     field("NoOfCopies"; "NoOfCopies")
//                     {

//                         CaptionML = ENU = 'No. of Copies', ESP = 'N§ copias';
//                         ToolTipML = ENU = 'Specifies how many copies of the document to print.', ESP = 'Especifica cu ntas copias del documento se van a imprimir.';
//                         ApplicationArea = Basic, Suite;
//                     }
//                     field("ShowInternalInfo"; "ShowInternalInfo")
//                     {

//                         CaptionML = ENU = 'Show Internal Information', ESP = 'Mostrar informaci¢n interna';
//                         ToolTipML = ENU = 'Specifies if the document shows internal information.', ESP = 'Especifica si el documento muestra informaci¢n interna.';
//                         ApplicationArea = Basic, Suite;
//                     }
//                     field("LogInteraction"; "LogInteraction")
//                     {

//                         CaptionML = ENU = 'Log Interaction', ESP = 'Log interacci¢n';
//                         ToolTipML = ENU = 'Specifies that interactions with the contact are logged.', ESP = 'Indica que las interacciones con el contacto est n registradas.';
//                         ApplicationArea = Basic, Suite;
//                         Enabled = LogInteractionEnable;
//                     }
//                     field("CalcularSerie"; "CalcularSerie")
//                     {

//                         CaptionML = ESP = 'Calcular no. serie registro';
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
//             LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
//             LogInteractionEnable := LogInteraction;
//         END;


//     }
//     labels
//     {
//     }

//     var
//         //       Text003@1003 :
//         Text003: TextConst ENU = '(Applies to %1 %2)', ESP = '(Liq. por %1 %2)';
//         //       PageCaptionCap@1006 :
//         PageCaptionCap: TextConst ENU = 'Page %1 of %2', ESP = 'P gina %1 de %2';
//         //       GLSetup@1008 :
//         GLSetup: Record 98;
//         //       RespCenter@1018 :
//         RespCenter: Record 5714;
//         //       SalesSetup@1086 :
//         SalesSetup: Record 311;
//         //       SalesPurchPerson@1009 :
//         SalesPurchPerson: Record 13;
//         //       CompanyInfo@1010 :
//         CompanyInfo: Record 79;
//         //       CompanyInfo1@1083 :
//         CompanyInfo1: Record 79;
//         //       CompanyInfo2@1084 :
//         CompanyInfo2: Record 79;
//         //       CompanyInfo3@1085 :
//         CompanyInfo3: Record 79;
//         //       VATAmountLine@1011 :
//         VATAmountLine: Record 290 TEMPORARY;
//         //       VATClause@1060 :
//         VATClause: Record 560;
//         //       DimSetEntry1@1012 :
//         DimSetEntry1: Record 480;
//         //       DimSetEntry2@1013 :
//         DimSetEntry2: Record 480;
//         //       Language@1014 :
//         Language: Codeunit "Language";
//         //       SalesShipmentBuffer@1042 :
//         SalesShipmentBuffer: Record 7190 TEMPORARY;
//         //       CurrExchRate@1052 :
//         CurrExchRate: Record 330;
//         //       FormatAddr@1016 :
//         FormatAddr: Codeunit 365;
//         //       FormatDocument@1061 :
//         FormatDocument: Codeunit 368;
//         //       SegManagement@1017 :
//         SegManagement: Codeunit 5051;
//         //       CustAddr@1019 :
//         CustAddr: ARRAY[8] OF Text[50];
//         //       ShipToAddr@1020 :
//         ShipToAddr: ARRAY[8] OF Text[50];
//         //       CompanyAddr@1021 :
//         CompanyAddr: ARRAY[8] OF Text[50];
//         //       ReturnOrderNoText@1039 :
//         ReturnOrderNoText: Text[80];
//         //       SalesPersonText@1022 :
//         SalesPersonText: Text[30];
//         //       VATNoText@1023 :
//         VATNoText: Text[80];
//         //       ReferenceText@1024 :
//         ReferenceText: Text[80];
//         //       AppliedToText@1025 :
//         AppliedToText: Text;
//         //       TotalText@1026 :
//         TotalText: Text[50];
//         //       TotalExclVATText@1027 :
//         TotalExclVATText: Text[50];
//         //       TotalInclVATText@1028 :
//         TotalInclVATText: Text[50];
//         //       MoreLines@1029 :
//         MoreLines: Boolean;
//         //       NoOfCopies@1030 :
//         NoOfCopies: Integer;
//         //       NoOfLoops@1031 :
//         NoOfLoops: Integer;
//         //       CopyText@1032 :
//         CopyText: Text[30];
//         //       ShowShippingAddr@1033 :
//         ShowShippingAddr: Boolean;
//         //       DimText@1035 :
//         DimText: Text[120];
//         //       OldDimText@1036 :
//         OldDimText: Text[75];
//         //       ShowInternalInfo@1037 :
//         ShowInternalInfo: Boolean;
//         //       Continue@1038 :
//         Continue: Boolean;
//         //       LogInteraction@1040 :
//         LogInteraction: Boolean;
//         //       FirstValueEntryNo@1041 :
//         FirstValueEntryNo: Integer;
//         //       PostedReceiptDate@1043 :
//         PostedReceiptDate: Date;
//         //       NextEntryNo@1044 :
//         NextEntryNo: Integer;
//         //       VALVATBaseLCY@1045 :
//         VALVATBaseLCY: Decimal;
//         //       VALVATAmountLCY@1046 :
//         VALVATAmountLCY: Decimal;
//         //       Text008@1049 :
//         Text008: TextConst ENU = 'VAT Amount Specification in ', ESP = 'Especificar importe IVA en ';
//         //       Text009@1048 :
//         Text009: TextConst ENU = 'Local Currency', ESP = 'Divisa local';
//         //       Text010@1047 :
//         Text010: TextConst ENU = 'Exchange rate: %1/%2', ESP = 'Tipo cambio: %1/%2';
//         //       VALSpecLCYHeader@1050 :
//         VALSpecLCYHeader: Text[80];
//         //       VALExchRate@1051 :
//         VALExchRate: Text[50];
//         //       CalculatedExchRate@1053 :
//         CalculatedExchRate: Decimal;
//         //       OutputNo@1055 :
//         OutputNo: Integer;
//         //       NNC_TotalLineAmount@1059 :
//         NNC_TotalLineAmount: Decimal;
//         //       NNC_TotalAmountInclVat@1058 :
//         NNC_TotalAmountInclVat: Decimal;
//         //       NNC_TotalInvDiscAmount@1057 :
//         NNC_TotalInvDiscAmount: Decimal;
//         //       NNC_TotalAmount@1056 :
//         NNC_TotalAmount: Decimal;
//         //       VATPostingSetup@1100000 :
//         VATPostingSetup: Record 325;
//         //       Text1100001@1100010 :
//         Text1100001: TextConst ENU = 'Sales - Corrective invoice %1', ESP = 'Ventas - Factura correctiva %1';
//         //       LogInteractionEnable@19003940 :
//         LogInteractionEnable: Boolean;
//         //       CompanyInfoPhoneNoCaptionLbl@6373 :
//         CompanyInfoPhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ESP = 'N§ tel‚fono';
//         //       CompanyInfoHomePageCaptionLbl@3310 :
//         CompanyInfoHomePageCaptionLbl: TextConst ENU = 'Home Page', ESP = 'P gina Web';
//         //       CompanyInfoEMailCaptionLbl@1108005 :
//         CompanyInfoEMailCaptionLbl: TextConst ENU = 'Email', ESP = 'Correo electr¢nico';
//         //       CompanyInfoVATRegistrationNoCaptionLbl@5770 :
//         CompanyInfoVATRegistrationNoCaptionLbl: TextConst ENU = 'VAT Reg. No.', ESP = 'CIF/NIF';
//         //       CompanyInfoGiroNoCaptionLbl@9182 :
//         CompanyInfoGiroNoCaptionLbl: TextConst ENU = 'Giro No.', ESP = 'N§ giro postal';
//         //       CompanyInfoBankNameCaptionLbl@9342 :
//         CompanyInfoBankNameCaptionLbl: TextConst ENU = 'Bank', ESP = 'Banco';
//         //       CompanyInfoBankAccountNoCaptionLbl@9929 :
//         CompanyInfoBankAccountNoCaptionLbl: TextConst ENU = 'Account No.', ESP = 'N§ cuenta';
//         //       SalesCrMemoHeaderNoCaptionLbl@4129 :
//         SalesCrMemoHeaderNoCaptionLbl: TextConst ENU = 'Credit Memo No.', ESP = 'N§ serie abono';
//         //       SalesCrMemoHeaderPostingDateCaptionLbl@9076 :
//         SalesCrMemoHeaderPostingDateCaptionLbl: TextConst ENU = 'Posting Date', ESP = 'Fecha registro';
//         //       CorrectedInvoiceNoCaptionLbl@1106498 :
//         CorrectedInvoiceNoCaptionLbl: TextConst ENU = 'Corrected Invoice No.', ESP = 'N.§ factura corregida';
//         //       DocumentDateCaptionLbl@1107925 :
//         DocumentDateCaptionLbl: TextConst ENU = 'Document Date', ESP = 'Fecha emisi¢n documento';
//         //       HeaderDimensionsCaptionLbl@7125 :
//         HeaderDimensionsCaptionLbl: TextConst ENU = 'Header Dimensions', ESP = 'Dimensiones cabecera';
//         //       UnitPriceCaptionLbl@9823 :
//         UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESP = 'Precio venta';
//         //       SalesCrMemoLineLineDiscountCaptionLbl@1231 :
//         SalesCrMemoLineLineDiscountCaptionLbl: TextConst ENU = 'Discount %', ESP = '% Descuento';
//         //       AmountCaptionLbl@7794 :
//         AmountCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
//         //       PostedReceiptDateCaptionLbl@5921 :
//         PostedReceiptDateCaptionLbl: TextConst ENU = 'Posted Return Receipt Date', ESP = 'Fecha recepci¢n devoluci¢n registrada';
//         //       InvDiscountAmountCaptionLbl@9792 :
//         InvDiscountAmountCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ESP = 'Importe descuento factura';
//         //       SubtotalCaptionLbl@1782 :
//         SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ESP = 'Subtotal';
//         //       PmtDiscGivenAmountCaptionLbl@1108175 :
//         PmtDiscGivenAmountCaptionLbl: TextConst ENU = 'Payment Discount Received Amount', ESP = 'Importe recibido descuento pago';
//         //       ReturnReceiptCaptionLbl@1235 :
//         ReturnReceiptCaptionLbl: TextConst ENU = 'Return Receipt', ESP = 'Recepci¢n de devoluci¢n';
//         //       VATClausesCap@1071 :
//         VATClausesCap: TextConst ENU = 'VAT Clause', ESP = 'Cl usula de IVA';
//         //       LineDimensionsCaptionLbl@3801 :
//         LineDimensionsCaptionLbl: TextConst ENU = 'Line Dimensions', ESP = 'Dimensiones l¡nea';
//         //       VATAmountLineVATCaptionLbl@3480 :
//         VATAmountLineVATCaptionLbl: TextConst ENU = 'VAT %', ESP = '% IVA';
//         //       VATAmountLineVATECBaseControl105CaptionLbl@3519 :
//         VATAmountLineVATECBaseControl105CaptionLbl: TextConst ENU = 'VAT Base', ESP = 'Base IVA';
//         //       VATAmountLineVATAmountControl106CaptionLbl@4504 :
//         VATAmountLineVATAmountControl106CaptionLbl: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
//         //       VATAmountSpecificationCaptionLbl@9595 :
//         VATAmountSpecificationCaptionLbl: TextConst ENU = 'VAT Amount Specification', ESP = 'Especificaci¢n importe IVA';
//         //       VATAmountLineVATIdentifierCaptionLbl@3475 :
//         VATAmountLineVATIdentifierCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
//         //       VATAmountLineInvDiscBaseAmountControl130CaptionLbl@3093 :
//         VATAmountLineInvDiscBaseAmountControl130CaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ESP = 'Importe base descuento factura';
//         //       VATAmountLineLineAmountControl135CaptionLbl@4948 :
//         VATAmountLineLineAmountControl135CaptionLbl: TextConst ENU = 'Line Amount', ESP = 'Importe l¡nea';
//         //       InvandPmtDiscountsCaptionLbl@1105019 :
//         InvandPmtDiscountsCaptionLbl: TextConst ENU = 'Invoice and Payment Discounts', ESP = 'Descuentos facturas y pagos';
//         //       ECCaptionLbl@1106861 :
//         ECCaptionLbl: TextConst ENU = 'EC %', ESP = '% RE';
//         //       ECAmountCaptionLbl@1104570 :
//         ECAmountCaptionLbl: TextConst ENU = 'EC Amount', ESP = 'Importe RE';
//         //       VATAmountLineVATECBaseControl113CaptionLbl@8809 :
//         VATAmountLineVATECBaseControl113CaptionLbl: TextConst ENU = 'Total', ESP = 'Total';
//         //       ShiptoAddressCaptionLbl@8743 :
//         ShiptoAddressCaptionLbl: TextConst ENU = 'Ship-to Address', ESP = 'Direcci¢n de env¡o';
//         //       CACCaptionLbl@1100091 :
//         CACCaptionLbl: Text;
//         //       CACTxt@1100092 :
//         CACTxt: TextConst ENU = 'Régimen especial del criterio de caja', ESP = 'R‚gimen especial del criterio de caja';
//         //       NoAbonoCaptionLbl@7001107 :
//         NoAbonoCaptionLbl: TextConst ENU = 'INVOICE NO.', ESP = 'N§ Abono';
//         //       ClienteCaptionLbl@7001106 :
//         ClienteCaptionLbl: TextConst ENU = 'CLIENT', ESP = 'CLIENTE';
//         //       ConceptoAbonoCaptionLbl@7001105 :
//         ConceptoAbonoCaptionLbl: TextConst CAT = 'CONCEPTE ABONAMENT', ENU = 'INVOICE DESCRIPTION', ESP = 'CONCEPTO ABONO';
//         //       VencimientoCaptionLbl@7001104 :
//         VencimientoCaptionLbl: TextConst CAT = 'Venciment', ENU = 'Due Date', ESP = 'Vencimiento';
//         //       FormaPago_CaptionLbl@7001103 :
//         FormaPago_CaptionLbl: TextConst CAT = 'Forma pagament', ENU = 'Payment Terms', ESP = 'Forma de pago';
//         //       TotalBase_CaptionLbl@7001102 :
//         TotalBase_CaptionLbl: TextConst CAT = 'TOTAL BASE', ENU = 'TOTAL BASE', ESP = 'TOTAL BASE';
//         //       IVA_CaptionLbl@7001101 :
//         IVA_CaptionLbl: TextConst CAT = 'IVA', ENU = 'IVA', ESP = 'IVA';
//         //       TotalAbono_CaptionLbl@7001100 :
//         TotalAbono_CaptionLbl: TextConst CAT = 'TOTAL ABONEMENT', ENU = 'CR. MEMO TOTAL', ESP = 'TOTAL ABONO';
//         //       DescDivisa@7001109 :
//         DescDivisa: Text;
//         //       Currency@7001108 :
//         Currency: Record 4;
//         //       Retencion_CaptionLbl@7001110 :
//         Retencion_CaptionLbl: TextConst ENU = 'WITHHOLDING', ESP = 'RETENCIàN';
//         //       NumSpaces@7001111 :
//         NumSpaces: Integer;
//         //       NCuenta_CaptionLbl@7001112 :
//         NCuenta_CaptionLbl: TextConst ENU = 'No. Account', ESP = 'N§ CTA.';
//         //       PaymentTerms@7001113 :
//         PaymentTerms: Record 3;
//         //       DescPago@7001114 :
//         DescPago: Text;
//         //       PaymentMethod@7001115 :
//         PaymentMethod: Record 289;
//         //       FormaPago@7001116 :
//         FormaPago: Text;
//         //       footer1@1100286002 :
//         footer1: Text;
//         //       footer2@1100286001 :
//         footer2: Text;
//         //       SaltoLinea@100000001 :
//         SaltoLinea: Char;
//         //       SalesCrMemoLine@100000002 :
//         SalesCrMemoLine: Record 115;
//         //       CalcularSerie@100000004 :
//         CalcularSerie: Boolean;
//         //       NoDocFact@100000003 :
//         NoDocFact: Code[20];
//         //       WorkDesc@100000005 :
//         WorkDesc: Text;
//         //       WithholdingAmt@100000006 :
//         WithholdingAmt: Decimal;
//         //       WithholdingGroup@100000007 :
//         WithholdingGroup: Record 7207330;
//         //       QuoBuildingSetup@1100286000 :
//         QuoBuildingSetup: Record 7207278;



//     trigger OnInitReport();
//     begin
//         GLSetup.GET;
//         CompanyInfo.GET;
//         SalesSetup.GET;
//         FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
//         if not QuoBuildingSetup.GET then
//             QuoBuildingSetup.INIT;
//     end;

//     trigger OnPreReport();
//     begin
//         if not CurrReport.USEREQUESTPAGE then
//             InitLogInteraction;
//         CompanyInfo1.CALCFIELDS(Picture);
//     end;



//     procedure InitLogInteraction()
//     begin
//         LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
//     end;

//     LOCAL procedure FindPostedShipmentDate(): Date;
//     var
//         //       ReturnReceiptHeader@1000 :
//         ReturnReceiptHeader: Record 6660;
//         //       SalesShipmentBuffer2@1001 :
//         SalesShipmentBuffer2: Record 7190 TEMPORARY;
//     begin
//         NextEntryNo := 1;
//         if "Sales Line"."Return Receipt No." <> '' then
//             if ReturnReceiptHeader.GET("Sales Line"."Return Receipt No.") then
//                 exit(ReturnReceiptHeader."Posting Date");
//         //{
//         //      if "Sales Header"."Return Order No." = '' then
//         //        exit("Sales Header"."Posting Date");
//         //
//         //      CASE "Sales Line".Type OF
//         //        "Sales Line".Type::Item:
//         //          GenerateBufferFromValueEntry("Sales Line");
//         //        "Sales Line".Type::"G/L Account","Sales Line".Type::Resource,
//         //        "Sales Line".Type::"Charge (Item)","Sales Line".Type::"Fixed Asset":
//         //          GenerateBufferFromShipment("Sales Line");
//         //        "Sales Line".Type::" ":
//         //          exit(0D);
//         //      end;
//         //      }
//         SalesShipmentBuffer.RESET;
//         SalesShipmentBuffer.SETRANGE("Document No.", "Sales Line"."Document No.");
//         SalesShipmentBuffer.SETRANGE("Line No.", "Sales Line"."Line No.");

//         if SalesShipmentBuffer.FIND('-') then begin
//             SalesShipmentBuffer2 := SalesShipmentBuffer;
//             if SalesShipmentBuffer.NEXT = 0 then begin
//                 SalesShipmentBuffer.GET(
//                   SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
//                 SalesShipmentBuffer.DELETE;
//                 exit(SalesShipmentBuffer2."Posting Date");
//             end;
//             SalesShipmentBuffer.CALCSUMS(Quantity);
//             if SalesShipmentBuffer.Quantity <> "Sales Line".Quantity then begin
//                 SalesShipmentBuffer.DELETEALL;
//                 exit("Sales Header"."Posting Date");
//             end;
//         end else
//             exit("Sales Header"."Posting Date");
//     end;

//     //     LOCAL procedure GenerateBufferFromValueEntry (SalesCrMemoLine2@1002 :
//     LOCAL procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record 115)
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
//         TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
//         ValueEntry.SETCURRENTKEY("Document No.");
//         ValueEntry.SETRANGE("Document No.", SalesCrMemoLine2."Document No.");
//         ValueEntry.SETRANGE("Posting Date", "Sales Header"."Posting Date");
//         ValueEntry.SETRANGE("Item Charge No.", '');
//         ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
//         if ValueEntry.FIND('-') then
//             repeat
//                 if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then begin
//                     if SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 then
//                         Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
//                     else
//                         Quantity := ValueEntry."Invoiced Quantity";
//                     AddBufferEntry(
//                       SalesCrMemoLine2,
//                       -Quantity,
//                       ItemLedgerEntry."Posting Date");
//                     TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
//                 end;
//                 FirstValueEntryNo := ValueEntry."Entry No." + 1;
//             until (ValueEntry.NEXT = 0) or (TotalQuantity = 0);
//     end;

//     //     LOCAL procedure GenerateBufferFromShipment (SalesCrMemoLine@1000 :
//     LOCAL procedure GenerateBufferFromShipment(SalesCrMemoLine: Record 115)
//     var
//         //       SalesCrMemoHeader@1001 :
//         SalesCrMemoHeader: Record 114;
//         //       SalesCrMemoLine2@1002 :
//         SalesCrMemoLine2: Record 115;
//         //       ReturnReceiptHeader@1006 :
//         ReturnReceiptHeader: Record 6660;
//         //       ReturnReceiptLine@1004 :
//         ReturnReceiptLine: Record 6661;
//         //       TotalQuantity@1003 :
//         TotalQuantity: Decimal;
//         //       Quantity@1005 :
//         Quantity: Decimal;
//     begin
//         //{
//         //      TotalQuantity := 0;
//         //      SalesCrMemoHeader.SETCURRENTKEY("Return Order No.");
//         //      SalesCrMemoHeader.SETFILTER("No.",'..%1',"Sales Header"."No.");
//         //      SalesCrMemoHeader.SETRANGE("Return Order No.","Sales Header"."Return Order No.");
//         //      if SalesCrMemoHeader.FIND('-') then
//         //        repeat
//         //          SalesCrMemoLine2.SETRANGE("Document No.",SalesCrMemoHeader."No.");
//         //          SalesCrMemoLine2.SETRANGE("Line No.",SalesCrMemoLine."Line No.");
//         //          SalesCrMemoLine2.SETRANGE(Type,SalesCrMemoLine.Type);
//         //          SalesCrMemoLine2.SETRANGE("No.",SalesCrMemoLine."No.");
//         //          SalesCrMemoLine2.SETRANGE("Unit of Measure Code",SalesCrMemoLine."Unit of Measure Code");
//         //          if SalesCrMemoLine2.FIND('-') then
//         //            repeat
//         //              TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
//         //            until SalesCrMemoLine2.NEXT = 0;
//         //        until SalesCrMemoHeader.NEXT = 0;
//         //
//         //      ReturnReceiptLine.SETCURRENTKEY("Return Order No.","Return Order Line No.");
//         //      ReturnReceiptLine.SETRANGE("Return Order No.","Sales Header"."Return Order No.");
//         //      ReturnReceiptLine.SETRANGE("Return Order Line No.",SalesCrMemoLine."Line No.");
//         //      ReturnReceiptLine.SETRANGE("Line No.",SalesCrMemoLine."Line No.");
//         //      ReturnReceiptLine.SETRANGE(Type,SalesCrMemoLine.Type);
//         //      ReturnReceiptLine.SETRANGE("No.",SalesCrMemoLine."No.");
//         //      ReturnReceiptLine.SETRANGE("Unit of Measure Code",SalesCrMemoLine."Unit of Measure Code");
//         //      ReturnReceiptLine.SETFILTER(Quantity,'<>%1',0);
//         //
//         //      if ReturnReceiptLine.FIND('-') then
//         //        repeat
//         //          if "Sales Header"."Get Return Receipt Used" then
//         //            CorrectShipment(ReturnReceiptLine);
//         //          if ABS(ReturnReceiptLine.Quantity) <= ABS(TotalQuantity - SalesCrMemoLine.Quantity) then
//         //            TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
//         //          else begin
//         //            if ABS(ReturnReceiptLine.Quantity) > ABS(TotalQuantity) then
//         //              ReturnReceiptLine.Quantity := TotalQuantity;
//         //            Quantity :=
//         //              ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);
//         //
//         //            SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
//         //            TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;
//         //
//         //            if ReturnReceiptHeader.GET(ReturnReceiptLine."Document No.") then
//         //              AddBufferEntry(
//         //                SalesCrMemoLine,
//         //                -Quantity,
//         //                ReturnReceiptHeader."Posting Date");
//         //          end;
//         //        until (ReturnReceiptLine.NEXT = 0) or (TotalQuantity = 0);
//         //        }
//     end;

//     //     LOCAL procedure CorrectShipment (var ReturnReceiptLine@1001 :
//     LOCAL procedure CorrectShipment(var ReturnReceiptLine: Record 6661)
//     var
//         //       SalesCrMemoLine@1000 :
//         SalesCrMemoLine: Record 115;
//     begin
//         SalesCrMemoLine.SETCURRENTKEY("Return Receipt No.", "Return Receipt Line No.");
//         SalesCrMemoLine.SETRANGE("Return Receipt No.", ReturnReceiptLine."Document No.");
//         SalesCrMemoLine.SETRANGE("Return Receipt Line No.", ReturnReceiptLine."Line No.");
//         if SalesCrMemoLine.FIND('-') then
//             repeat
//                 ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
//             until SalesCrMemoLine.NEXT = 0;
//     end;

//     //     LOCAL procedure AddBufferEntry (SalesCrMemoLine@1001 : Record 115;QtyOnShipment@1002 : Decimal;PostingDate@1003 :
//     LOCAL procedure AddBufferEntry(SalesCrMemoLine: Record 115; QtyOnShipment: Decimal; PostingDate: Date)
//     begin
//         SalesShipmentBuffer.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
//         SalesShipmentBuffer.SETRANGE("Line No.", SalesCrMemoLine."Line No.");
//         SalesShipmentBuffer.SETRANGE("Posting Date", PostingDate);
//         if SalesShipmentBuffer.FIND('-') then begin
//             SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity - QtyOnShipment;
//             SalesShipmentBuffer.MODIFY;
//             exit;
//         end;

//         WITH SalesShipmentBuffer DO begin
//             INIT;
//             "Document No." := SalesCrMemoLine."Document No.";
//             "Line No." := SalesCrMemoLine."Line No.";
//             "Entry No." := NextEntryNo;
//             Type := SalesCrMemoLine.Type;
//             "No." := SalesCrMemoLine."No.";
//             Quantity := -QtyOnShipment;
//             "Posting Date" := PostingDate;
//             INSERT;
//             NextEntryNo := NextEntryNo + 1
//         end;
//     end;

//     //     procedure ShowCashAccountingCriteria (SalesCrMemoHeader@1100002 :
//     procedure ShowCashAccountingCriteria(SalesCrMemoHeader: Record 114): Text;
//     var
//         //       VATEntry@1100000 :
//         VATEntry: Record 254;
//     begin
//         GLSetup.GET;
//         if not GLSetup."Unrealized VAT" then
//             exit;
//         CACCaptionLbl := '';
//         VATEntry.SETRANGE("Document No.", SalesCrMemoHeader."No.");
//         VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::"Credit Memo");
//         if VATEntry.FINDSET then
//             repeat
//                 if VATEntry."VAT Cash Regime" then
//                     CACCaptionLbl := CACTxt;
//             until (VATEntry.NEXT = 0) or (CACCaptionLbl <> '');
//         exit(CACCaptionLbl);
//     end;

//     //     procedure InitializeRequest (NewNoOfCopies@1002 : Integer;NewShowInternalInfo@1000 : Boolean;NewLogInteraction@1001 :
//     procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
//     begin
//         NoOfCopies := NewNoOfCopies;
//         ShowInternalInfo := NewShowInternalInfo;
//         LogInteraction := NewLogInteraction;
//     end;

//     //     LOCAL procedure FormatAddressFields (var SalesCrMemoHeader@1000 :
//     LOCAL procedure FormatAddressFields(var SalesCrMemoHeader: Record 36)
//     begin

//         FormatAddr.GetCompanyAddr(SalesCrMemoHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
//         FormatAddr.SalesHeaderBillTo(CustAddr, SalesCrMemoHeader);
//         ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesCrMemoHeader);
//     end;

//     //     LOCAL procedure FormatDocumentFields (SalesCrMemoHeader@1000 :
//     LOCAL procedure FormatDocumentFields(SalesCrMemoHeader: Record 36)
//     begin
//         WITH SalesCrMemoHeader DO begin
//             FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
//             FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);

//             ///ReturnOrderNoText := FormatDocument.SetText("Return Order No." <> '',FIELDCAPTION("Return Order No."));
//             ReferenceText := FormatDocument.SetText("Your Reference" <> '', FIELDCAPTION("Your Reference"));
//             VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FIELDCAPTION("VAT Registration No."));
//             AppliedToText :=
//               FormatDocument.SetText(
//                 "Applies-to Doc. No." <> '', FORMAT(STRSUBSTNO(Text003, FORMAT("Applies-to Doc. Type"), "Applies-to Doc. No.")));
//         end;
//     end;


//     procedure GetCurrencyCode(): Code[10];
//     begin

//         exit("Sales Header"."Currency Code");
//     end;

//     //     LOCAL procedure FncCalcularSerie (var pSalesHeader@1100286000 :
//     LOCAL procedure FncCalcularSerie(var pSalesHeader: Record 36)
//     var
//         //       NoSeriesMgt@1100286001 :
//         NoSeriesMgt: Codeunit 396;
//         //       text50000@100000000 :
//         text50000: TextConst ENU = 'Debe informar el campo no. serie facturas.', ESP = 'Debe informar el campo no. serie facturas.';
//     begin

//         if pSalesHeader."Posting No. Series" = '' then
//             ERROR(text50000);

//         if pSalesHeader."Posting No." <> '' then
//             exit;

//         pSalesHeader."Posting No." := NoSeriesMgt.GetNextNo(pSalesHeader."Posting No. Series", pSalesHeader."Posting Date", TRUE);
//         pSalesHeader.MODIFY;
//         COMMIT;
//     end;

//     /*begin
//     //{
// //      PGM - 09/01/2018 - Informe de Abono de Venta
// //      Q8890 JMA 110220: - Se crea en el Layout la caja de la Descripci¢n de Trabajo (WorkDesc, Code.GetData(43,1) en layout) debajo de la cabecera documento [Replica de Abono Venta, R7207406)
// //      CAS-04711-W1X8Y6 AAV  11/08/20  - Correcci¢n CIF del cliente en el Layout
// //    }
//     end.
//   */

// }



