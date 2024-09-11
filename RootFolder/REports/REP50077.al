report 50077 "Inesco Sales - Invoice"
{


    Permissions = TableData 7190 = rimd;
    CaptionML = ENU = 'Sales - Invoice', ESP = 'Ventas - Factura';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

    dataset
    {

        DataItem("Sales Invoice Header"; "Sales Invoice Header")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Posted Sales Invoice', ESP = 'Hist¢rico facturas venta';


            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            Column(No_SalesInvHdr; "No.")
            {
                //SourceExpr="No.";
            }
            Column(PaymentTermsDescription; PaymentTerms.Description)
            {
                //SourceExpr=PaymentTerms.Description;
            }
            Column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
                //SourceExpr=ShipmentMethod.Description;
            }
            Column(PaymentMethodDescription; PaymentMethod.Description)
            {
                //SourceExpr=PaymentMethod.Description;
            }
            Column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            {
                //SourceExpr=PmtTermsDescCaptionLbl;
            }
            Column(ShpMethodDescCaption; ShpMethodDescCaptionLbl)
            {
                //SourceExpr=ShpMethodDescCaptionLbl;
            }
            Column(PmtMethodDescCaption; PmtMethodDescCaptionLbl)
            {
                //SourceExpr=PmtMethodDescCaptionLbl;
            }
            Column(DocDateCaption; DocDateCaptionLbl)
            {
                //SourceExpr=DocDateCaptionLbl;
            }
            Column(HomePageCaption; HomePageCaptionLbl)
            {
                //SourceExpr=HomePageCaptionLbl;
            }
            Column(EmailCaption; EmailCaptionLbl)
            {
                //SourceExpr=EmailCaptionLbl;
            }
            Column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
            {
                //SourceExpr=DisplayAdditionalFeeNote;
            }
            Column(footer; footer)
            {
                //SourceExpr=footer;
            }
            Column(footer2; footer2)
            {
                //SourceExpr=footer2;
            }
            Column(ShowLines; ShowLines)
            {
                //SourceExpr=ShowLines;
            }
            Column(SalesInvoiceTxt; SalesInvoiceTxt)
            {
                //SourceExpr=SalesInvoiceTxt;
            }
            DataItem("CopyLoop"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
                DataItem("PageLoop"; "2000000026")
                {

                    DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                    ;
                    Column(CompanyInfo3Picture; CompanyInfo.Picture)
                    {
                        //SourceExpr=CompanyInfo.Picture;
                    }
                    Column(CompanyInfo3Picture2; rCfgQuoBuilding.Logo1)
                    {
                        //SourceExpr=rCfgQuoBuilding.Logo1;
                    }
                    Column(DocumentCaption; STRSUBSTNO(DocumentCaption, CopyText))
                    {
                        //SourceExpr=STRSUBSTNO(DocumentCaption,CopyText);
                    }
                    Column(CustAddr1; CustAddr[1])
                    {
                        //SourceExpr=CustAddr[1];
                    }
                    Column(CompanyAddr1; CompanyAddr[1])
                    {
                        //SourceExpr=CompanyAddr[1];
                    }
                    Column(CustAddr2; CustAddr[2])
                    {
                        //SourceExpr=CustAddr[2];
                    }
                    Column(CompanyAddr2; CompanyAddr[2])
                    {
                        //SourceExpr=CompanyAddr[2];
                    }
                    Column(CustAddr3; CustAddr[3])
                    {
                        //SourceExpr=CustAddr[3];
                    }
                    Column(CompanyAddr3; CompanyAddr[3])
                    {
                        //SourceExpr=CompanyAddr[3];
                    }
                    Column(CustAddr4; CustAddr[4])
                    {
                        //SourceExpr=CustAddr[4];
                    }
                    Column(CompanyAddr4; CompanyAddr[4])
                    {
                        //SourceExpr=CompanyAddr[4];
                    }
                    Column(CustAddr5; CustAddr[5])
                    {
                        //SourceExpr=CustAddr[5];
                    }
                    Column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                        //SourceExpr=CompanyInfo."Phone No.";
                    }
                    Column(CustAddr6; CustAddr[6])
                    {
                        //SourceExpr=CustAddr[6];
                    }
                    Column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
                    {
                        //SourceExpr=CompanyInfo."VAT Registration No.";
                    }
                    Column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                        //SourceExpr=CompanyInfo."Home Page";
                    }
                    Column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                        //SourceExpr=CompanyInfo."E-Mail";
                    }
                    Column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                        //SourceExpr=CompanyInfo."Giro No.";
                    }
                    Column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                        //SourceExpr=CompanyInfo."Bank Name";
                    }
                    Column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                        //SourceExpr=CompanyInfo."Bank Account No.";
                    }
                    Column(BilltoCustNo_SalesInvHdr; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                        //SourceExpr="Sales Invoice Header"."Bill-to Customer No.";
                    }
                    Column(PostingDate_SalesInvHdr; FORMAT("Sales Invoice Header"."Posting Date", 0, 4))
                    {
                        //SourceExpr=FORMAT("Sales Invoice Header"."Posting Date",0,4);
                    }
                    Column(VATNoText; VATNoText)
                    {
                        //SourceExpr=VATNoText;
                    }
                    Column(VATRegNo_SalesInvHeader; "Sales Invoice Header"."VAT Registration No.")
                    {
                        //SourceExpr="Sales Invoice Header"."VAT Registration No.";
                    }
                    Column(DueDate_SalesInvHeader; FORMAT("Sales Invoice Header"."Due Date", 0, 4))
                    {
                        //SourceExpr=FORMAT("Sales Invoice Header"."Due Date",0,4);
                    }
                    Column(SalesPersonText; SalesPersonText)
                    {
                        //SourceExpr=SalesPersonText;
                    }
                    Column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                        //SourceExpr=SalesPurchPerson.Name;
                    }
                    Column(No_SalesInvoiceHeader1; "Sales Invoice Header"."No.")
                    {
                        //SourceExpr="Sales Invoice Header"."No.";
                    }
                    Column(ReferenceText; ReferenceText)
                    {
                        //SourceExpr=ReferenceText;
                    }
                    Column(YourReference_SalesInvHdr; "Sales Invoice Header"."Your Reference")
                    {
                        //SourceExpr="Sales Invoice Header"."Your Reference";
                    }
                    Column(OrderNoText; OrderNoText)
                    {
                        //SourceExpr=OrderNoText;
                    }
                    Column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {
                        //SourceExpr="Sales Invoice Header"."Order No.";
                    }
                    Column(CustAddr7; CustAddr[7])
                    {
                        //SourceExpr=CustAddr[7];
                    }
                    Column(CustAddr8; CustAddr[8])
                    {
                        //SourceExpr=CustAddr[8];
                    }
                    Column(CompanyAddr5; CompanyAddr[5])
                    {
                        //SourceExpr=CompanyAddr[5];
                    }
                    Column(CompanyAddr6; CompanyAddr[6])
                    {
                        //SourceExpr=CompanyAddr[6];
                    }
                    Column(DocDate_SalesInvoiceHdr; FORMAT("Sales Invoice Header"."Document Date", 0, 4))
                    {
                        //SourceExpr=FORMAT("Sales Invoice Header"."Document Date",0,4);
                    }
                    Column(PricesInclVAT_SalesInvHdr; "Sales Invoice Header"."Prices Including VAT")
                    {
                        //SourceExpr="Sales Invoice Header"."Prices Including VAT";
                    }
                    Column(OutputNo; OutputNo)
                    {
                        //SourceExpr=OutputNo;
                    }
                    Column(PricesInclVATYesNo; FORMAT("Sales Invoice Header"."Prices Including VAT"))
                    {
                        //SourceExpr=FORMAT("Sales Invoice Header"."Prices Including VAT");
                    }
                    Column(PageCaption; PageCaptionCap)
                    {
                        //SourceExpr=PageCaptionCap;
                    }
                    Column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                        //SourceExpr=PhoneNoCaptionLbl;
                    }
                    Column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                        //SourceExpr=VATRegNoCaptionLbl;
                    }
                    Column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                        //SourceExpr=GiroNoCaptionLbl;
                    }
                    Column(BankNameCaption; BankNameCaptionLbl)
                    {
                        //SourceExpr=BankNameCaptionLbl;
                    }
                    Column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                        //SourceExpr=BankAccNoCaptionLbl;
                    }
                    Column(DueDateCaption; DueDateCaptionLbl)
                    {
                        //SourceExpr=DueDateCaptionLbl;
                    }
                    Column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                        //SourceExpr=InvoiceNoCaptionLbl;
                    }
                    Column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                        //SourceExpr=PostingDateCaptionLbl;
                    }
                    Column(BilltoCustNo_SalesInvHdrCaption; "Sales Invoice Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                        //SourceExpr="Sales Invoice Header".FIELDCAPTION("Bill-to Customer No.");
                    }
                    Column(PricesInclVAT_SalesInvHdrCaption; "Sales Invoice Header".FIELDCAPTION("Prices Including VAT"))
                    {
                        //SourceExpr="Sales Invoice Header".FIELDCAPTION("Prices Including VAT");
                    }
                    Column(CACCaption; CACCaptionLbl)
                    {
                        //SourceExpr=CACCaptionLbl;
                    }
                    Column(InvoiceNoLbl; InvoiceNoLbl)
                    {
                        //SourceExpr=InvoiceNoLbl;
                    }
                    Column(CIFLbl; CIFLbl)
                    {
                        //SourceExpr=CIFLbl;
                    }
                    Column(UMLbl; UMLbl)
                    {
                        //SourceExpr=UMLbl;
                    }
                    Column(ConceptsLbl; ConceptsLbl)
                    {
                        //SourceExpr=ConceptsLbl;
                    }
                    Column(PriceLbl; PriceLbl)
                    {
                        //SourceExpr=PriceLbl;
                    }
                    Column(BaseLbl; BaseLbl)
                    {
                        //SourceExpr=BaseLbl;
                    }
                    Column(RetentionLbl; RetentionLbl)
                    {
                        //SourceExpr=RetentionLbl;
                    }
                    Column(DiferenceLbl; DiferenceLbl)
                    {
                        //SourceExpr=DiferenceLbl;
                    }
                    Column(VATLbl; VATLbl)
                    {
                        //SourceExpr=VATLbl;
                    }
                    Column(TotalLbl; TotalLbl)
                    {
                        //SourceExpr=TotalLbl;
                    }
                    Column(WorkDescription; WorkDes)
                    {
                        //SourceExpr=WorkDes;
                    }
                    Column(Total_Withholding_GE; -WithHoldingGEAmount)
                    {
                        //SourceExpr=-WithHoldingGEAmount;
                    }
                    Column(GEWithholdingCaption; GEWithholdingCaptionLbl)
                    {
                        //SourceExpr=GEWithholdingCaptionLbl;
                    }
                    Column(WithholdingGEPorc; WithholdingGEPorc)
                    {
                        //SourceExpr=WithholdingGEPorc;
                    }
                    Column(Total_Withholding_PIT; -WithHoldingPITAmount)
                    {
                        //SourceExpr=-WithHoldingPITAmount;
                    }
                    Column(PITWithholdingCaption; PITWithholdingCaptionLbl)
                    {
                        //SourceExpr=PITWithholdingCaptionLbl;
                    }
                    Column(WithholdingPITPorc; WithholdingPITPorc)
                    {
                        //SourceExpr=WithholdingPITPorc;
                    }
                    Column(InvoiceBase; InvoiceBase)
                    {
                        //SourceExpr=InvoiceBase;
                    }
                    Column(SubTotalWithoutWithholding; SubTotalWithoutWithholding)
                    {
                        //SourceExpr=SubTotalWithoutWithholding;
                    }
                    Column(InvoiceTotal; InvoiceTotal)
                    {
                        //SourceExpr=InvoiceTotal;
                    }
                    Column(PSIVATText; PSIVATText)
                    {
                        //SourceExpr=PSIVATText;
                    }
                    Column(ContractNoLbl; ContractNoLbl)
                    {
                        //SourceExpr=ContractNoLbl;
                    }
                    Column(ContractNoTxt; ContractNoTxt)
                    {
                        //SourceExpr=ContractNoTxt;
                    }
                    Column(BenefitCenterTxt; BenefitCenterTxt)
                    {
                        //SourceExpr=BenefitCenterTxt;
                    }
                    Column(PosPresupTxt; PosPresupTxt)
                    {
                        //SourceExpr=PosPresupTxt;
                    }
                    Column(OrderTxt; OrderTxt)
                    {
                        //SourceExpr=OrderTxt;
                    }
                    Column(PepTxt; PepTxt)
                    {
                        //SourceExpr=PepTxt;
                    }
                    Column(OrderNoTxt; OrderNoTxt)
                    {
                        //SourceExpr=OrderNoTxt;
                    }
                    Column(ContractNo_SalesInvoiceHeader; rSalesHeaderExt."Contract No.")
                    {
                        //SourceExpr=rSalesHeaderExt."Contract No.";
                    }
                    Column(FailiureBenefitCenter_SalesInvHeader; rSalesHeaderExt."Failiure Benefit Centre")
                    {
                        //SourceExpr=rSalesHeaderExt."Failiure Benefit Centre";
                    }
                    Column(FailiureBudgetPos_SalesInvHeader; rSalesHeaderExt."Failiure Budget Pos.")
                    {
                        //SourceExpr=rSalesHeaderExt."Failiure Budget Pos.";
                    }
                    Column(FailiureOrder_SalesInvHeader; rSalesHeaderExt."Failiure Order")
                    {
                        //SourceExpr=rSalesHeaderExt."Failiure Order";
                    }
                    Column(FailiurePep_SalesInvHeader; rSalesHeaderExt."Failiure Pep.")
                    {
                        //SourceExpr=rSalesHeaderExt."Failiure Pep.";
                    }
                    Column(FailiureOrderNo_SalesInvHeader; rSalesHeaderExt."Failiure Order No.")
                    {
                        //SourceExpr=rSalesHeaderExt."Failiure Order No.";
                    }
                    DataItem("DimensionLoop1"; "2000000026")
                    {

                        DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER(1 ..));


                        DataItemLinkReference = "Sales Invoice Header";
                        Column(DimText; DimText)
                        {
                            //SourceExpr=DimText;
                        }
                        Column(Number_DimensionLoop1; Number)
                        {
                            //SourceExpr=Number;
                        }
                        Column(HdrDimsCaption; HdrDimsCaptionLbl)
                        {
                            //SourceExpr=HdrDimsCaptionLbl;
                        }
                        DataItem("Sales Invoice Line"; "Sales Invoice Line")
                        {

                            DataItemTableView = SORTING("Document No.", "Line No.");


                            DataItemLinkReference = "Sales Invoice Header";
                            DataItemLink = "Document No." = FIELD("No.");
                            Column(GetCarteraInvoice; GetCarteraInvoice)
                            {
                                //SourceExpr=GetCarteraInvoice;
                            }
                            Column(LineAmt_SalesInvoiceLine; "Line Amount")
                            {
                                //SourceExpr="Line Amount";
                                AutoFormatType = 1;
                                AutoFormatExpression = GetCurrencyCode;
                            }
                            Column(Description_SalesInvLine; Description)
                            {
                                //SourceExpr=Description;
                            }
                            Column(No_SalesInvoiceLine; "No.")
                            {
                                //SourceExpr="No.";
                            }
                            Column(Quantity_SalesInvoiceLine; Quantity)
                            {
                                //SourceExpr=Quantity;
                            }
                            Column(UOM_SalesInvoiceLine; "Unit of Measure")
                            {
                                //SourceExpr="Unit of Measure";
                            }
                            Column(UnitPrice_SalesInvLine; "Unit Price")
                            {
                                //SourceExpr="Unit Price";
                                AutoFormatType = 2;
                                AutoFormatExpression = GetCurrencyCode;
                            }
                            Column(LineDisc_SalesInvoiceLine; "Line Discount %")
                            {
                                //SourceExpr="Line Discount %";
                            }
                            Column(VATIdent_SalesInvLine; "VAT Identifier")
                            {
                                //SourceExpr="VAT Identifier";
                            }
                            Column(PostedShipmentDate; FORMAT("Shipment Date"))
                            {
                                //SourceExpr=FORMAT("Shipment Date");
                            }
                            Column(Type_SalesInvoiceLine; FORMAT(Type))
                            {
                                //SourceExpr=FORMAT(Type);
                            }
                            Column(InvDiscountAmount; -"Inv. Discount Amount")
                            {
                                //SourceExpr=-"Inv. Discount Amount";
                                AutoFormatType = 1;
                                AutoFormatExpression = GetCurrencyCode;
                            }
                            Column(TotalSubTotal; TotalSubTotal)
                            {
                                //SourceExpr=TotalSubTotal;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            }
                            Column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                            {
                                //SourceExpr=TotalInvoiceDiscountAmount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            }
                            Column(TotalAmount; TotalAmount)
                            {
                                //SourceExpr=TotalAmount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            }
                            Column(TotalGivenAmount; TotalGivenAmount)
                            {
                                //SourceExpr=TotalGivenAmount;
                            }
                            Column(SalesInvoiceLineAmount; Amount)
                            {
                                //SourceExpr=Amount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            }
                            Column(AmountIncludingVATAmount; "Amount Including VAT" - Amount)
                            {
                                //SourceExpr="Amount Including VAT" - Amount;
                                AutoFormatType = 1;
                                AutoFormatExpression = GetCurrencyCode;
                            }
                            Column(Amount_SalesInvoiceLineIncludingVAT; "Amount Including VAT")
                            {
                                //SourceExpr="Amount Including VAT";
                                AutoFormatType = 1;
                                AutoFormatExpression = GetCurrencyCode;
                            }
                            Column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                            {
                                //SourceExpr=VATAmountLine.VATAmountText;
                            }
                            Column(TotalExclVATText; TotalExclVATText)
                            {
                                //SourceExpr=TotalExclVATText;
                            }
                            Column(TotalInclVATText; TotalInclVATText)
                            {
                                //SourceExpr=TotalInclVATText;
                            }
                            Column(TotalAmountInclVAT; TotalAmountInclVAT)
                            {
                                //SourceExpr=TotalAmountInclVAT;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            }
                            Column(TotalAmountVAT; TotalAmountVAT)
                            {
                                //SourceExpr=TotalAmountVAT;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            }
                            Column(VATBaseDisc_SalesInvHdr; "Sales Invoice Header"."VAT Base Discount %")
                            {
                                //SourceExpr="Sales Invoice Header"."VAT Base Discount %";
                                AutoFormatType = 1;
                            }
                            Column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
                            {
                                //SourceExpr=TotalPaymentDiscountOnVAT;
                                AutoFormatType = 1;
                            }
                            Column(VATAmtLineVATCalcType; VATAmountLine."VAT Calculation Type")
                            {
                                //SourceExpr=VATAmountLine."VAT Calculation Type";
                            }
                            Column(LineNo_SalesInvoiceLine; "Line No.")
                            {
                                //SourceExpr="Line No.";
                            }
                            Column(PmtinvfromdebtpaidtoFactCompCaption; PmtinvfromdebtpaidtoFactCompCaptionLbl)
                            {
                                //SourceExpr=PmtinvfromdebtpaidtoFactCompCaptionLbl;
                            }
                            Column(UnitPriceCaption; UnitPriceCaptionLbl)
                            {
                                //SourceExpr=UnitPriceCaptionLbl;
                            }
                            Column(DiscountCaption; DiscountCaptionLbl)
                            {
                                //SourceExpr=DiscountCaptionLbl;
                            }
                            Column(AmtCaption; AmtCaptionLbl)
                            {
                                //SourceExpr=AmtCaptionLbl;
                            }
                            Column(PostedShpDateCaption; PostedShpDateCaptionLbl)
                            {
                                //SourceExpr=PostedShpDateCaptionLbl;
                            }
                            Column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                            {
                                //SourceExpr=InvDiscAmtCaptionLbl;
                            }
                            Column(SubtotalCaption; SubtotalCaptionLbl)
                            {
                                //SourceExpr=SubtotalCaptionLbl;
                            }
                            Column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
                            {
                                //SourceExpr=PmtDiscGivenAmtCaptionLbl;
                            }
                            Column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
                            {
                                //SourceExpr=PmtDiscVATCaptionLbl;
                            }
                            Column(Description_SalesInvLineCaption; FIELDCAPTION(Description))
                            {
                                //SourceExpr=FIELDCAPTION(Description);
                            }
                            Column(No_SalesInvoiceLineCaption; FIELDCAPTION("No."))
                            {
                                //SourceExpr=FIELDCAPTION("No.");
                            }
                            Column(Quantity_SalesInvoiceLineCaption; FIELDCAPTION(Quantity))
                            {
                                //SourceExpr=FIELDCAPTION(Quantity);
                            }
                            Column(UOM_SalesInvoiceLineCaption; FIELDCAPTION("Unit of Measure"))
                            {
                                //SourceExpr=FIELDCAPTION("Unit of Measure");
                            }
                            Column(VATIdent_SalesInvLineCaption; FIELDCAPTION("VAT Identifier"))
                            {
                                //SourceExpr=FIELDCAPTION("VAT Identifier");
                            }
                            Column(IsLineWithTotals; LineNoWithTotal = "Line No.")
                            {
                                //SourceExpr=LineNoWithTotal = "Line No.";
                            }
                            DataItem("Sales Shipment Buffer"; "2000000026")
                            {

                                DataItemTableView = SORTING("Number");
                                ;
                                Column(PostingDate_SalesShipmentBuffer; FORMAT(SalesShipmentBuffer."Posting Date"))
                                {
                                    //SourceExpr=FORMAT(SalesShipmentBuffer."Posting Date");
                                }
                                Column(Quantity_SalesShipmentBuffer; SalesShipmentBuffer.Quantity)
                                {
                                    DecimalPlaces = 0 : 5;
                                    //SourceExpr=SalesShipmentBuffer.Quantity;
                                }
                                Column(ShpCaption; ShpCaptionLbl)
                                {
                                    //SourceExpr=ShpCaptionLbl;
                                }
                                DataItem("DimensionLoop2"; "2000000026")
                                {

                                    DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER(1 ..));
                                    ;
                                    Column(DimText1; DimText)
                                    {
                                        //SourceExpr=DimText;
                                    }
                                    Column(LineDimsCaption; LineDimsCaptionLbl)
                                    {
                                        //SourceExpr=LineDimsCaptionLbl;
                                    }
                                    DataItem("AsmLoop"; "2000000026")
                                    {

                                        DataItemTableView = SORTING("Number");
                                        ;
                                        Column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                                        {
                                            //DecimalPlaces=0:5;
                                            //SourceExpr=GetUOMText(TempPostedAsmLine."Unit of Measure Code");
                                        }
                                        Column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                                        {
                                            //DecimalPlaces=0:5;
                                            //SourceExpr=TempPostedAsmLine.Quantity;
                                        }
                                        Column(TempPostedAsmLineVariantCode; BlanksForIndent + TempPostedAsmLine."Variant Code")
                                        {
                                            //DecimalPlaces=0:5;
                                            //SourceExpr=BlanksForIndent + TempPostedAsmLine."Variant Code";
                                        }
                                        Column(TempPostedAsmLineDescrip; BlanksForIndent + TempPostedAsmLine.Description)
                                        {
                                            //SourceExpr=BlanksForIndent + TempPostedAsmLine.Description;
                                        }
                                        Column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                                        {
                                            //SourceExpr=BlanksForIndent + TempPostedAsmLine."No.";
                                        }
                                        DataItem("VATCounter"; "2000000026")
                                        {

                                            DataItemTableView = SORTING("Number");
                                            ;
                                            Column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                                            {
                                                //SourceExpr=VATAmountLine."VAT Base";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                                            }
                                            Column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                                            {
                                                //SourceExpr=VATAmountLine."VAT Amount";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                            }
                                            Column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                                            {
                                                //SourceExpr=VATAmountLine."Line Amount";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                            }
                                            Column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                                            {
                                                //SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                            }
                                            Column(VATAmtLineInvDiscountAmt; VATAmountLine."Invoice Discount Amount")
                                            {
                                                //SourceExpr=VATAmountLine."Invoice Discount Amount";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                            }
                                            Column(VATAmtLineECAmount; VATAmountLine."EC Amount")
                                            {
                                                //SourceExpr=VATAmountLine."EC Amount";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                            }
                                            Column(VATAmountLineVAT; VATAmountLine."VAT %")
                                            {
                                                DecimalPlaces = 0 : 5;
                                                //SourceExpr=VATAmountLine."VAT %";
                                            }
                                            Column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                                            {
                                                //SourceExpr=VATAmountLine."VAT Identifier";
                                            }
                                            Column(VATAmountLineEC; VATAmountLine."EC %")
                                            {
                                                //SourceExpr=VATAmountLine."EC %";
                                                AutoFormatType = 1;
                                                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                            }
                                            Column(VATAmtLineVATCaption; VATAmtLineVATCaptionLbl)
                                            {
                                                //SourceExpr=VATAmtLineVATCaptionLbl;
                                            }
                                            Column(VATECBaseCaption; VATECBaseCaptionLbl)
                                            {
                                                //SourceExpr=VATECBaseCaptionLbl;
                                            }
                                            Column(VATAmountCaption; VATAmountCaptionLbl)
                                            {
                                                //SourceExpr=VATAmountCaptionLbl;
                                            }
                                            Column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                                            {
                                                //SourceExpr=VATAmtSpecCaptionLbl;
                                            }
                                            Column(VATIdentCaption; VATIdentCaptionLbl)
                                            {
                                                //SourceExpr=VATIdentCaptionLbl;
                                            }
                                            Column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                                            {
                                                //SourceExpr=InvDiscBaseAmtCaptionLbl;
                                            }
                                            Column(LineAmtCaption1; LineAmtCaption1Lbl)
                                            {
                                                //SourceExpr=LineAmtCaption1Lbl;
                                            }
                                            Column(InvPmtDiscCaption; InvPmtDiscCaptionLbl)
                                            {
                                                //SourceExpr=InvPmtDiscCaptionLbl;
                                            }
                                            Column(ECAmtCaption; ECAmtCaptionLbl)
                                            {
                                                //SourceExpr=ECAmtCaptionLbl;
                                            }
                                            Column(ECCaption; ECCaptionLbl)
                                            {
                                                //SourceExpr=ECCaptionLbl;
                                            }
                                            Column(TotalCaption; TotalCaptionLbl)
                                            {
                                                //SourceExpr=TotalCaptionLbl;
                                            }
                                            DataItem("VATClauseEntryCounter"; "2000000026")
                                            {

                                                DataItemTableView = SORTING("Number");
                                                ;
                                                Column(VATClauseVATIdentifier; VATAmountLine."VAT Identifier")
                                                {
                                                    //SourceExpr=VATAmountLine."VAT Identifier";
                                                }
                                                Column(VATClauseCode; VATAmountLine."VAT Clause Code")
                                                {
                                                    //SourceExpr=VATAmountLine."VAT Clause Code";
                                                }
                                                Column(VATClauseDescription; VATClause.Description)
                                                {
                                                    //SourceExpr=VATClause.Description;
                                                }
                                                Column(VATClauseDescription2; VATClause."Description 2")
                                                {
                                                    //SourceExpr=VATClause."Description 2";
                                                }
                                                Column(VATClauseAmount; VATAmountLine."VAT Amount")
                                                {
                                                    //SourceExpr=VATAmountLine."VAT Amount";
                                                    AutoFormatType = 1;
                                                    AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                                                }
                                                Column(VATClausesCaption; VATClausesCap)
                                                {
                                                    //SourceExpr=VATClausesCap;
                                                }
                                                Column(VATClauseVATIdentifierCaption; VATIdentifierCaptionLbl)
                                                {
                                                    //SourceExpr=VATIdentifierCaptionLbl;
                                                }
                                                Column(VATClauseVATAmtCaption; VATAmtCaptionLbl)
                                                {
                                                    //SourceExpr=VATAmtCaptionLbl;
                                                }
                                                DataItem("VatCounterLCY"; "2000000026")
                                                {

                                                    DataItemTableView = SORTING("Number");
                                                    ;
                                                    Column(VALSpecLCYHeader; VALSpecLCYHeader)
                                                    {
                                                        //SourceExpr=VALSpecLCYHeader;
                                                    }
                                                    Column(VALExchRate; VALExchRate)
                                                    {
                                                        //SourceExpr=VALExchRate;
                                                    }
                                                    Column(VALVATBaseLCY; VALVATBaseLCY)
                                                    {
                                                        //SourceExpr=VALVATBaseLCY;
                                                        AutoFormatType = 1;
                                                    }
                                                    Column(VALVATAmountLCY; VALVATAmountLCY)
                                                    {
                                                        //SourceExpr=VALVATAmountLCY;
                                                        AutoFormatType = 1;
                                                    }
                                                    Column(VATAmountLineVAT1; VATAmountLine."VAT %")
                                                    {
                                                        DecimalPlaces = 0 : 5;
                                                        //SourceExpr=VATAmountLine."VAT %";
                                                    }
                                                    Column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                                                    {
                                                        //SourceExpr=VATAmountLine."VAT Identifier";
                                                    }
                                                    Column(VALVATBaseLCYCaption1; VALVATBaseLCYCaption1Lbl)
                                                    {
                                                        //SourceExpr=VALVATBaseLCYCaption1Lbl;
                                                    }
                                                    DataItem("PaymentReportingArgument"; "Payment Reporting Argument")
                                                    {

                                                        DataItemTableView = SORTING("Key");


                                                        UseTemporary = true;
                                                        Column(PaymentServiceLogo; Logo)
                                                        {
                                                            //SourceExpr=Logo;
                                                        }
                                                        Column(PaymentServiceURLText; "URL Caption")
                                                        {
                                                            //SourceExpr="URL Caption";
                                                        }
                                                        Column(PaymentServiceURL; GetTargetURL)
                                                        {
                                                            //SourceExpr=GetTargetURL;
                                                        }
                                                        DataItem("Total"; "2000000026")
                                                        {

                                                            DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                                                        }
                                                        DataItem("Total2"; "2000000026")
                                                        {

                                                            DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                                                            ;
                                                            Column(SelltoCustNo_SalesInvHdr; "Sales Invoice Header"."Sell-to Customer No.")
                                                            {
                                                                //SourceExpr="Sales Invoice Header"."Sell-to Customer No.";
                                                            }
                                                            Column(ShipToAddr1; ShipToAddr[1])
                                                            {
                                                                //SourceExpr=ShipToAddr[1];
                                                            }
                                                            Column(ShipToAddr2; ShipToAddr[2])
                                                            {
                                                                //SourceExpr=ShipToAddr[2];
                                                            }
                                                            Column(ShipToAddr3; ShipToAddr[3])
                                                            {
                                                                //SourceExpr=ShipToAddr[3];
                                                            }
                                                            Column(ShipToAddr4; ShipToAddr[4])
                                                            {
                                                                //SourceExpr=ShipToAddr[4];
                                                            }
                                                            Column(ShipToAddr5; ShipToAddr[5])
                                                            {
                                                                //SourceExpr=ShipToAddr[5];
                                                            }
                                                            Column(ShipToAddr6; ShipToAddr[6])
                                                            {
                                                                //SourceExpr=ShipToAddr[6];
                                                            }
                                                            Column(ShipToAddr7; ShipToAddr[7])
                                                            {
                                                                //SourceExpr=ShipToAddr[7];
                                                            }
                                                            Column(ShipToAddr8; ShipToAddr[8])
                                                            {
                                                                //SourceExpr=ShipToAddr[8];
                                                            }
                                                            Column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                                                            {
                                                                //SourceExpr=ShiptoAddressCaptionLbl;
                                                            }
                                                            Column(SelltoCustNo_SalesInvHdrCaption; "Sales Invoice Header".FIELDCAPTION("Sell-to Customer No."))
                                                            {
                                                                //SourceExpr="Sales Invoice Header".FIELDCAPTION("Sell-to Customer No.");
                                                            }
                                                            DataItem("LineFee"; "2000000026")
                                                            {

                                                                DataItemTableView = SORTING("Number")
                                 ORDER(Ascending)
                                 WHERE("Number" = FILTER(1 ..));
                                                                ;
                                                                Column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                                                                {
                                                                    //SourceExpr=TempLineFeeNoteOnReportHist.ReportText ;
                                                                }
                                                                trigger OnAfterGetRecord();
                                                                BEGIN
                                                                    IF NOT DisplayAdditionalFeeNote THEN
                                                                        CurrReport.BREAK;

                                                                    IF Number = 1 THEN BEGIN
                                                                        IF NOT TempLineFeeNoteOnReportHist.FINDSET THEN
                                                                            CurrReport.BREAK
                                                                    END ELSE
                                                                        IF TempLineFeeNoteOnReportHist.NEXT = 0 THEN
                                                                            CurrReport.BREAK;
                                                                END;


                                                            }
                                                            trigger OnPreDataItem();
                                                            BEGIN
                                                                IF NOT ShowShippingAddr THEN
                                                                    CurrReport.BREAK;
                                                            END;


                                                        }
                                                        trigger OnPreDataItem();
                                                        VAR
                                                            //                                PaymentServiceSetup@1000 :
                                                            PaymentServiceSetup: Record 1060;
                                                        BEGIN
                                                            PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument, "Sales Invoice Header");
                                                            IF ISEMPTY THEN
                                                                CurrReport.BREAK;
                                                        END;


                                                    }
                                                    trigger OnPreDataItem();
                                                    BEGIN
                                                        IF (NOT GLSetup."Print VAT specification in LCY") OR
                                                           ("Sales Invoice Header"."Currency Code" = '')
                                                        THEN
                                                            CurrReport.BREAK;

                                                        SETRANGE(Number, 1, VATAmountLine.COUNT);
                                                        CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                                                        IF GLSetup."LCY Code" = '' THEN
                                                            VALSpecLCYHeader := Text007 + Text008
                                                        ELSE
                                                            VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                                                        CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", 1);
                                                        CalculatedExchRate := ROUND(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.00001);
                                                        VALExchRate := STRSUBSTNO(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                                                    END;

                                                    trigger OnAfterGetRecord();
                                                    BEGIN
                                                        VATAmountLine.GetLine(Number);
                                                        VALVATBaseLCY :=
                                                          VATAmountLine.GetBaseLCY(
                                                            "Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code",
                                                            "Sales Invoice Header"."Currency Factor");
                                                        VALVATAmountLCY :=
                                                          VATAmountLine.GetAmountLCY(
                                                            "Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code",
                                                            "Sales Invoice Header"."Currency Factor");
                                                    END;


                                                }
                                                trigger OnPreDataItem();
                                                BEGIN
                                                    CLEAR(VATClause);
                                                    SETRANGE(Number, 1, VATAmountLine.COUNT);
                                                    CurrReport.CREATETOTALS(VATAmountLine."VAT Amount");
                                                END;

                                                trigger OnAfterGetRecord();
                                                BEGIN
                                                    VATAmountLine.GetLine(Number);
                                                    IF NOT VATClause.GET(VATAmountLine."VAT Clause Code") THEN
                                                        CurrReport.SKIP;
                                                    VATClause.TranslateDescription("Sales Invoice Header"."Language Code");
                                                END;


                                            }
                                            trigger OnPreDataItem();
                                            BEGIN
                                                SETRANGE(Number, 1, VATAmountLine.COUNT);
                                                CurrReport.CREATETOTALS(
                                                  VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                                                  VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount",
                                                  //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                                                  //VATAmountLine."EC Amount",VATAmountLine."Pmt. Disc. Given Amount");
                                                  VATAmountLine."EC Amount");
                                                //-->
                                            END;

                                            trigger OnAfterGetRecord();
                                            BEGIN
                                                VATAmountLine.GetLine(Number);
                                                IF VATAmountLine."VAT Amount" = 0 THEN
                                                    VATAmountLine."VAT %" := 0;
                                                IF VATAmountLine."EC Amount" = 0 THEN
                                                    VATAmountLine."EC %" := 0;
                                            END;


                                        }
                                        trigger OnPreDataItem();
                                        BEGIN
                                            CLEAR(TempPostedAsmLine);
                                            IF NOT DisplayAssemblyInformation THEN
                                                CurrReport.BREAK;
                                            CollectAsmInformation;
                                            CLEAR(TempPostedAsmLine);
                                            SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                                        END;

                                        trigger OnAfterGetRecord();
                                        VAR
                                            //                                   ItemTranslation@1000 :
                                            ItemTranslation: Record 30;
                                        BEGIN
                                            IF Number = 1 THEN
                                                TempPostedAsmLine.FINDSET
                                            ELSE
                                                TempPostedAsmLine.NEXT;

                                            IF ItemTranslation.GET(TempPostedAsmLine."No.",
                                                 TempPostedAsmLine."Variant Code",
                                                 "Sales Invoice Header"."Language Code")
                                            THEN
                                                TempPostedAsmLine.Description := ItemTranslation.Description;
                                        END;


                                    }
                                    trigger OnPreDataItem();
                                    BEGIN
                                        IF NOT ShowInternalInfo THEN
                                            CurrReport.BREAK;

                                        DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                                    END;

                                    trigger OnAfterGetRecord();
                                    BEGIN
                                        IF Number = 1 THEN BEGIN
                                            IF NOT DimSetEntry2.FINDSET THEN
                                                CurrReport.BREAK;
                                        END ELSE
                                            IF NOT Continue THEN
                                                CurrReport.BREAK;

                                        CLEAR(DimText);
                                        Continue := FALSE;
                                        REPEAT
                                            OldDimText := DimText;
                                            IF DimText = '' THEN
                                                DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                            ELSE
                                                DimText :=
                                                  STRSUBSTNO(
                                                    '%1, %2 %3', DimText,
                                                    DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                            IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                                DimText := OldDimText;
                                                Continue := TRUE;
                                                EXIT;
                                            END;
                                        UNTIL DimSetEntry2.NEXT = 0;
                                    END;


                                }
                                trigger OnPreDataItem();
                                BEGIN
                                    SalesShipmentBuffer.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                                    SalesShipmentBuffer.SETRANGE("Line No.", "Sales Invoice Line"."Line No.");

                                    SETRANGE(Number, 1, SalesShipmentBuffer.COUNT);
                                END;

                                trigger OnAfterGetRecord();
                                BEGIN
                                    IF Number = 1 THEN
                                        SalesShipmentBuffer.FIND('-')
                                    ELSE
                                        SalesShipmentBuffer.NEXT;
                                END;


                            }
                            trigger OnPreDataItem();
                            BEGIN
                                VATAmountLine.DELETEALL;
                                SalesShipmentBuffer.RESET;
                                SalesShipmentBuffer.DELETEALL;
                                FirstValueEntryNo := 0;
                                MoreLines := FIND('+');
                                LineNoWithTotal := "Line No.";
                                WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                    MoreLines := NEXT(-1) <> 0;
                                IF NOT MoreLines THEN
                                    CurrReport.BREAK;
                                SETRANGE("Line No.", 0, "Line No.");

                                //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                                //CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount","Pmt. Disc. Given Amount");
                                CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount");
                                //-->
                            END;

                            trigger OnAfterGetRecord();
                            BEGIN
                                InitializeShipmentBuffer;
                                IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                    "No." := '';

                                IF VATPostingSetup.GET("Sales Invoice Line"."VAT Bus. Posting Group", "Sales Invoice Line"."VAT Prod. Posting Group") THEN BEGIN
                                    VATAmountLine.INIT;
                                    VATAmountLine."VAT Identifier" := "VAT Identifier";
                                    VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                    VATAmountLine."Tax Group Code" := "Tax Group Code";
                                    VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                    VATAmountLine."EC %" := VATPostingSetup."EC %";
                                    VATAmountLine."VAT Base" := "Sales Invoice Line".Amount;
                                    VATAmountLine."Amount Including VAT" := "Sales Invoice Line"."Amount Including VAT";
                                    VATAmountLine."Line Amount" := "Line Amount";
                                    //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                                    //VATAmountLine."Pmt. Disc. Given Amount" := "Pmt. Disc. Given Amount";
                                    //-->
                                    IF "Allow Invoice Disc." THEN
                                        VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                    VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                    VATAmountLine.SetCurrencyCode("Sales Invoice Header"."Currency Code");
                                    VATAmountLine."VAT Difference" := "VAT Difference";
                                    VATAmountLine."EC Difference" := "EC Difference";
                                    IF "Sales Invoice Header"."Prices Including VAT" THEN
                                        VATAmountLine."Prices Including VAT" := TRUE;
                                    VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                                    VATAmountLine.InsertLine;

                                    TotalSubTotal += "Line Amount";
                                    TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                                    TotalAmount += Amount;
                                    TotalAmountVAT += "Amount Including VAT" - Amount;
                                    TotalAmountInclVAT += "Amount Including VAT";
                                    //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                                    //TotalGivenAmount -= "Pmt. Disc. Given Amount";
                                    //TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Pmt. Disc. Given Amount" - "Amount Including VAT");
                                    TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                                    //-->

                                    PSIVATText := VATPostingSetup."ISP Description"; //Q16364 EPV 14/02/22 - Adaptar Factura Inesco

                                END;

                                //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                                // Se comenta el c¢digo porque ya se asigna el texto de ISP m s arriba
                                //{
                                //                                  //PEL
                                //                                  IF VATProductPostingGroup.GET("Sales Invoice Line"."VAT Prod. Posting Group") THEN BEGIN 
                                //                                    IF VATProductPostingGroup.PSI THEN
                                //                                      PSIVATText := CompanyInfo."PSI VAT Text";
                                //                                  END;
                                //                                  }
                                //-->
                            END;

                            trigger OnPostDataItem();
                            BEGIN

                                //PEL
                                // InvoiceBase := TotalSubTotal;
                                // SubTotalWithoutWithholding := InvoiceBase - WithHoldingGEAmount - WithHoldingPITAmount;
                                // InvoiceTotal := TotalAmountInclVAT;
                            END;


                        }
                        trigger OnPreDataItem();
                        BEGIN
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        END;


                    }
                    trigger OnAfterGetRecord();
                    BEGIN
                        //PEL

                        WithholdingGEPorc := 0;
                        WithHoldingGEAmount := 0;

                        //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                        //{
                        //                                  IF "Sales Invoice Header"."Cod. Withholding by G.E" <> '' THEN BEGIN 
                        //                                    "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."Total Withholding G.E");
                        //                                    WithHoldingGEAmount := "Sales Invoice Header"."Total Withholding G.E";
                        //                                    WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", "Sales Invoice Header"."Cod. Withholding by G.E");
                        //                                  }

                        IF "Sales Invoice Header"."QW Cod. Withholding by GE" <> '' THEN BEGIN
                            "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."QW Total Withholding GE");
                            WithHoldingGEAmount := "Sales Invoice Header"."QW Total Withholding GE";
                            WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", "Sales Invoice Header"."QW Cod. Withholding by GE");
                            //-->

                            WithholdingGEPorc := WithholdingGroup."Percentage Withholding";

                        END;

                        WithholdingPITPorc := 0;
                        WithHoldingPITAmount := 0;

                        //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                        //{
                        //                                  IF "Sales Invoice Header"."Cod. Withholding by PIT" <> '' THEN BEGIN 
                        //                                    "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."Total Withholding PIT");
                        //                                    WithHoldingPITAmount := "Sales Invoice Header"."Total Withholding PIT";
                        //                                    WithholdingGroup.GET(WithholdingGroup."Withholding Type"::PIT, "Sales Invoice Header"."Cod. Withholding by PIT");
                        //                                  }
                        IF "Sales Invoice Header"."QW Cod. Withholding by PIT" <> '' THEN BEGIN
                            "Sales Invoice Header".CALCFIELDS("Sales Invoice Header"."QW Total Withholding PIT");
                            WithHoldingPITAmount := "Sales Invoice Header"."QW Total Withholding PIT";
                            WithholdingGroup.GET(WithholdingGroup."Withholding Type"::PIT, "Sales Invoice Header"."QW Cod. Withholding by PIT");
                            //-->

                            WithholdingPITPorc := WithholdingGroup."Percentage Withholding";
                        END;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalGivenAmount := 0;
                    TotalPaymentDiscountOnVAT := 0;
                END;

                trigger OnPostDataItem();
                BEGIN
                    IF NOT CurrReport.PREVIEW THEN
                        CODEUNIT.RUN(CODEUNIT::"Sales Inv.-Printed", "Sales Invoice Header");
                END;


            }
            trigger OnAfterGetRecord();
            VAR
                //                                   Handled@1000 :
                Handled: Boolean;
                //                                   SaltoLinea@1100286000 :
                SaltoLinea: Char;
            BEGIN
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                IF rSalesHeaderExt.GET("Sales Invoice Header".RECORDID) THEN;

                FormatAddressFields("Sales Invoice Header");
                FormatDocumentFields("Sales Invoice Header");

                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);
                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                GetLineFeeNoteOnReportHist("No.");

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              SegManagement.SalesInvoiceInterDocType, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              SegManagement.SalesInvoiceInterDocType, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    END;

                OnAfterGetRecordSalesInvoiceHeader("Sales Invoice Header");
                OnGetReferenceText("Sales Invoice Header", ReferenceText, Handled);

                //PEL
                CustAddr[1] := "Sales Invoice Header"."Sell-to Customer Name";
                CustAddr[2] := "Sales Invoice Header"."Sell-to Address";
                CustAddr[3] := "Sales Invoice Header"."Sell-to Address 2";
                CustAddr[4] := "Sales Invoice Header"."Sell-to Post Code" + ' ' + "Sales Invoice Header"."Sell-to City";
                CompanyAddr[1] := CompanyInfo.City;
                SaltoLinea := 10;
                footer := CompanyInfo.Name + FORMAT(SaltoLinea) + CompanyInfo.Address + ' - Telf. ' + CompanyInfo."Phone No." + ' - Fax. ' + CompanyInfo."Fax No." + ' - ' + CompanyInfo."Post Code" + ' ' + CompanyInfo.City;
                //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
                //footer2 := CompanyInfo."Commercial Register" + ' - C.I.F. ' + CompanyInfo."VAT Registration No.";
                footer2 := rCfgQuoBuilding."Commercial Register" + ' ' + rCfgQuoBuilding."Commercial Register Sheet" + ' - C.I.F. ' + CompanyInfo."VAT Registration No.";
                //-->

                WorkDes := "Sales Invoice Header".GetWorkDescription;
            END;


        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("group203")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("NoOfCopies"; "NoOfCopies")
                    {

                        CaptionML = ENU = 'No. of Copies', ESP = 'N§ copias';
                        ToolTipML = ENU = 'Specifies how many copies of the document to print.', ESP = 'Especifica cu ntas copias del documento se van a imprimir.';
                        ApplicationArea = Basic, Suite;
                    }
                    field("ShowInternalInfo"; "ShowInternalInfo")
                    {

                        CaptionML = ENU = 'Show Internal Information', ESP = 'Mostrar informaci¢n interna';
                        ToolTipML = ENU = 'Specifies if you want the printed report to show information that is only for internal use.', ESP = 'Especifica si desea que el informe impreso muestre informaci¢n para uso interno exclusivamente.';
                        ApplicationArea = Basic, Suite;
                    }
                    field("LogInteraction"; "LogInteraction")
                    {

                        CaptionML = ENU = 'Log Interaction', ESP = 'Log interacci¢n';
                        ToolTipML = ENU = 'Specifies that interactions with the contact are logged.', ESP = 'Indica que las interacciones con el contacto est n registradas.';
                        ApplicationArea = Basic, Suite;
                        Enabled = LogInteractionEnable;
                    }
                    field("DisplayAsmInformation"; "DisplayAssemblyInformation")
                    {

                        CaptionML = ENU = 'Show Assembly Components', ESP = 'Mostrar componentes del ensamblado';
                        ToolTipML = ENU = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.', ESP = 'Especifica si desea que el informe incluya informaci¢n sobre componentes que se utilizaron en pedidos de ensamblado vinculados que suministraron el producto de venta.';
                        ApplicationArea = Assembly;
                    }
                    field("DisplayAdditionalFeeNote"; "DisplayAdditionalFeeNote")
                    {

                        CaptionML = ENU = 'Show Additional Fee Note', ESP = 'Mostrar nota recargo';
                        ToolTipML = ENU = 'Specifies that any notes about additional fees are included on the document.', ESP = 'Especifica que se incluyen notas sobre los recargos en el documento.';
                        ApplicationArea = Basic, Suite;
                    }
                    field("ShowLines"; "ShowLines")
                    {

                        CaptionML = ENU = 'Show Lines', ESP = 'Mostrar l¡neas';
                    }

                }

            }
        }
        trigger OnInit()
        BEGIN
            LogInteractionEnable := TRUE;
        END;

        trigger OnOpenPage()
        BEGIN
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        END;


    }
    labels
    {
    }

    var
        //       Text004@1004 :
        Text004:
// "%1 = Document No."
TextConst ENU = 'Sales - Invoice %1', ESP = 'Ventas - Factura %1';
        //       PageCaptionCap@1005 :
        PageCaptionCap: TextConst ENU = 'Page %1 of %2', ESP = 'P gina %1 de %2';
        //       GLSetup@1007 :
        GLSetup: Record 98;
        //       ShipmentMethod@1008 :
        ShipmentMethod: Record 10;
        //       PaymentTerms@1009 :
        PaymentTerms: Record 3;
        //       SalesPurchPerson@1010 :
        SalesPurchPerson: Record 13;
        //       CompanyInfo@1011 :
        CompanyInfo: Record 79;
        //       CompanyInfo1@1045 :
        CompanyInfo1: Record 79;
        //       CompanyInfo2@1046 :
        CompanyInfo2: Record 79;
        //       CompanyInfo3@1068 :
        CompanyInfo3: Record 79;
        //       SalesSetup@1048 :
        SalesSetup: Record 311;
        //       SalesShipmentBuffer@1000 :
        SalesShipmentBuffer: Record 7190 TEMPORARY;
        //       Cust@1012 :
        Cust: Record 18;
        //       VATAmountLine@1013 :
        VATAmountLine: Record 290 TEMPORARY;
        //       DimSetEntry1@1014 :
        DimSetEntry1: Record 480;
        //       DimSetEntry2@1015 :
        DimSetEntry2: Record 480;
        //       RespCenter@1016 :
        RespCenter: Record 5714;
        //       Language@1017 :
        Language: Codeunit "Language";
        //       CurrExchRate@1054 :
        CurrExchRate: Record 330;
        //       TempPostedAsmLine@1066 :
        TempPostedAsmLine: Record 911 TEMPORARY;
        //       VATClause@1069 :
        VATClause: Record 560;
        //       TempLineFeeNoteOnReportHist@1070 :
        TempLineFeeNoteOnReportHist: Record 1053 TEMPORARY;
        //       FormatAddr@1019 :
        FormatAddr: Codeunit 365;
        //       FormatDocument@1074 :
        FormatDocument: Codeunit 368;
        //       SegManagement@1020 :
        SegManagement: Codeunit 5051;
        //       CustAddr@1021 :
        CustAddr: ARRAY[8] OF Text[50];
        //       ShipToAddr@1022 :
        ShipToAddr: ARRAY[8] OF Text[50];
        //       CompanyAddr@1023 :
        CompanyAddr: ARRAY[8] OF Text[50];
        //       OrderNoText@1024 :
        OrderNoText: Text[80];
        //       SalesPersonText@1025 :
        SalesPersonText: Text[30];
        //       VATNoText@1026 :
        VATNoText: Text[80];
        //       ReferenceText@1027 :
        ReferenceText: Text[80];
        //       TotalText@1028 :
        TotalText: Text[50];
        //       TotalExclVATText@1029 :
        TotalExclVATText: Text[50];
        //       TotalInclVATText@1030 :
        TotalInclVATText: Text[50];
        //       MoreLines@1031 :
        MoreLines: Boolean;
        //       NoOfCopies@1032 :
        NoOfCopies: Integer;
        //       NoOfLoops@1033 :
        NoOfLoops: Integer;
        //       CopyText@1034 :
        CopyText: Text[30];
        //       ShowShippingAddr@1035 :
        ShowShippingAddr: Boolean;
        //       NextEntryNo@1043 :
        NextEntryNo: Integer;
        //       FirstValueEntryNo@1042 :
        FirstValueEntryNo: Integer;
        //       DimText@1037 :
        DimText: Text[120];
        //       OldDimText@1038 :
        OldDimText: Text[75];
        //       ShowInternalInfo@1039 :
        ShowInternalInfo: Boolean;
        //       Continue@1040 :
        Continue: Boolean;
        //       LogInteraction@1041 :
        LogInteraction: Boolean;
        //       VALVATBaseLCY@1052 :
        VALVATBaseLCY: Decimal;
        //       VALVATAmountLCY@1053 :
        VALVATAmountLCY: Decimal;
        //       VALSpecLCYHeader@1055 :
        VALSpecLCYHeader: Text[80];
        //       Text007@1049 :
        Text007: TextConst ENU = 'VAT Amount Specification in ', ESP = 'Especificar importe IVA en ';
        //       Text008@1051 :
        Text008: TextConst ENU = 'Local Currency', ESP = 'Divisa local';
        //       VALExchRate@1047 :
        VALExchRate: Text[50];
        //       Text009@1056 :
        Text009: TextConst ENU = 'Exchange rate: %1/%2', ESP = 'Tipo cambio: %1/%2';
        //       CalculatedExchRate@1057 :
        CalculatedExchRate: Decimal;
        //       Text010@1058 :
        Text010: TextConst ENU = 'Sales - Prepayment Invoice %1', ESP = 'Ventas - Factura prepago %1';
        //       OutputNo@1059 :
        OutputNo: Integer;
        //       TotalSubTotal@1061 :
        TotalSubTotal: Decimal;
        //       TotalAmount@1062 :
        TotalAmount: Decimal;
        //       TotalAmountInclVAT@1064 :
        TotalAmountInclVAT: Decimal;
        //       TotalAmountVAT@1065 :
        TotalAmountVAT: Decimal;
        //       TotalInvoiceDiscountAmount@1063 :
        TotalInvoiceDiscountAmount: Decimal;
        //       TotalPaymentDiscountOnVAT@1060 :
        TotalPaymentDiscountOnVAT: Decimal;
        //       VATPostingSetup@1100000 :
        VATPostingSetup: Record 325;
        //       PaymentMethod@1100001 :
        PaymentMethod: Record 289;
        //       TotalGivenAmount@1100002 :
        TotalGivenAmount: Decimal;
        //       LogInteractionEnable@19003940 :
        LogInteractionEnable: Boolean;
        //       DisplayAssemblyInformation@1067 :
        DisplayAssemblyInformation: Boolean;
        //       PhoneNoCaptionLbl@6169 :
        PhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ESP = 'N§ tel‚fono';
        //       VATRegNoCaptionLbl@2224 :
        VATRegNoCaptionLbl: TextConst ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
        //       GiroNoCaptionLbl@7839 :
        GiroNoCaptionLbl: TextConst ENU = 'Giro No.', ESP = 'N§ giro postal';
        //       BankNameCaptionLbl@5585 :
        BankNameCaptionLbl: TextConst ENU = 'Bank', ESP = 'Banco';
        //       BankAccNoCaptionLbl@1535 :
        BankAccNoCaptionLbl: TextConst ENU = 'Account No.', ESP = 'N§ cuenta';
        //       DueDateCaptionLbl@3162 :
        DueDateCaptionLbl: TextConst ENU = 'Due Date', ESP = 'Fecha vencimiento';
        //       InvoiceNoCaptionLbl@5312 :
        InvoiceNoCaptionLbl: TextConst ENU = 'Invoice No.', ESP = 'N§ factura';
        //       PostingDateCaptionLbl@4591 :
        PostingDateCaptionLbl: TextConst ENU = 'Posting Date', ESP = 'Fecha registro';
        //       HdrDimsCaptionLbl@2756 :
        HdrDimsCaptionLbl: TextConst ENU = 'Header Dimensions', ESP = 'Dimensiones cabecera';
        //       PmtinvfromdebtpaidtoFactCompCaptionLbl@1106068 :
        PmtinvfromdebtpaidtoFactCompCaptionLbl: TextConst ENU = 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.', ESP = 'Para que se libere de la deuda, el pago de esta factura se debe realizar a la compa¤¡a Factoring.';
        //       UnitPriceCaptionLbl@9823 :
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESP = 'Precio venta';
        //       DiscountCaptionLbl@7535 :
        DiscountCaptionLbl: TextConst ENU = 'Discount %', ESP = '% Descuento';
        //       AmtCaptionLbl@9683 :
        AmtCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       VATClausesCap@1071 :
        VATClausesCap: TextConst ENU = 'VAT Clause', ESP = 'Cl usula de IVA';
        //       PostedShpDateCaptionLbl@3882 :
        PostedShpDateCaptionLbl: TextConst ENU = 'Posted Shipment Date', ESP = 'Fecha env¡o registrada';
        //       InvDiscAmtCaptionLbl@4720 :
        InvDiscAmtCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ESP = 'Importe descuento factura';
        //       SubtotalCaptionLbl@1782 :
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ESP = 'Subtotal';
        //       PmtDiscGivenAmtCaptionLbl@1100444 :
        PmtDiscGivenAmtCaptionLbl: TextConst ENU = 'Payment Disc Given Amount', ESP = 'Importe descuento pago';
        //       PmtDiscVATCaptionLbl@1108299 :
        PmtDiscVATCaptionLbl: TextConst ENU = 'Payment Discount on VAT', ESP = 'Descuento P.P. sobre IVA';
        //       ShpCaptionLbl@5152 :
        ShpCaptionLbl: TextConst ENU = 'Shipment', ESP = 'Env¡o';
        //       LineDimsCaptionLbl@6798 :
        LineDimsCaptionLbl: TextConst ENU = 'Line Dimensions', ESP = 'Dimensiones l¡nea';
        //       VATAmtLineVATCaptionLbl@2066 :
        VATAmtLineVATCaptionLbl: TextConst ENU = 'VAT %', ESP = '% IVA';
        //       VATECBaseCaptionLbl@1104919 :
        VATECBaseCaptionLbl: TextConst ENU = 'VAT+EC Base', ESP = 'Base IVA+RE';
        //       VATAmountCaptionLbl@4595 :
        VATAmountCaptionLbl: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
        //       VATAmtSpecCaptionLbl@3447 :
        VATAmtSpecCaptionLbl: TextConst ENU = 'VAT Amount Specification', ESP = 'Especificaci¢n importe IVA';
        //       VATIdentCaptionLbl@5459 :
        VATIdentCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
        //       InvDiscBaseAmtCaptionLbl@2407 :
        InvDiscBaseAmtCaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ESP = 'Importe base descuento factura';
        //       LineAmtCaption1Lbl@9011 :
        LineAmtCaption1Lbl: TextConst ENU = 'Line Amount', ESP = 'Importe l¡nea';
        //       InvPmtDiscCaptionLbl@1103130 :
        InvPmtDiscCaptionLbl: TextConst ENU = 'Invoice and Payment Discounts', ESP = 'Descuentos facturas y pagos';
        //       ECAmtCaptionLbl@1106492 :
        ECAmtCaptionLbl: TextConst ENU = 'EC Amount', ESP = 'Importe RE';
        //       ECCaptionLbl@1106861 :
        ECCaptionLbl: TextConst ENU = 'EC %', ESP = '% RE';
        //       TotalCaptionLbl@1909 :
        TotalCaptionLbl: TextConst ENU = 'Total', ESP = 'Total';
        //       VALVATBaseLCYCaption1Lbl@9220 :
        VALVATBaseLCYCaption1Lbl: TextConst ENU = 'VAT Base', ESP = 'Base IVA';
        //       VATAmtCaptionLbl@8387 :
        VATAmtCaptionLbl: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
        //       VATIdentifierCaptionLbl@6906 :
        VATIdentifierCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
        //       ShiptoAddressCaptionLbl@8743 :
        ShiptoAddressCaptionLbl: TextConst ENU = 'Ship-to Address', ESP = 'Direcci¢n de env¡o';
        //       PmtTermsDescCaptionLbl@8726 :
        PmtTermsDescCaptionLbl: TextConst ENU = 'Payment Terms', ESP = 'T‚rminos pago';
        //       ShpMethodDescCaptionLbl@9810 :
        ShpMethodDescCaptionLbl: TextConst ENU = 'Shipment Method', ESP = 'Condiciones env¡o';
        //       PmtMethodDescCaptionLbl@1103142 :
        PmtMethodDescCaptionLbl: TextConst ENU = 'Payment Method', ESP = 'Forma pago';
        //       DocDateCaptionLbl@1108215 :
        DocDateCaptionLbl: TextConst ENU = 'Document Date', ESP = 'Fecha emisi¢n documento';
        //       HomePageCaptionLbl@1109328 :
        HomePageCaptionLbl: TextConst ENU = 'Home Page', ESP = 'P gina Web';
        //       EmailCaptionLbl@1106630 :
        EmailCaptionLbl: TextConst ENU = 'Email', ESP = 'Correo electr¢nico';
        //       CACCaptionLbl@1100091 :
        CACCaptionLbl: Text;
        //       CACTxt@1100092 :
        CACTxt: TextConst ENU = 'R‚gimen especial del criterio de caja', ESP = 'R‚gimen especial del criterio de caja';
        //       DisplayAdditionalFeeNote@1072 :
        DisplayAdditionalFeeNote: Boolean;
        //       LineNoWithTotal@1073 :
        LineNoWithTotal: Integer;
        //       InvoiceNoLbl@1100286000 :
        InvoiceNoLbl: TextConst ENU = 'Invice No.', ESP = 'Factura N§';
        //       CIFLbl@1100286002 :
        CIFLbl: TextConst ESP = 'C.I.F.';
        //       UMLbl@1100286001 :
        UMLbl: TextConst ESP = 'U.M.';
        //       ConceptsLbl@1100286003 :
        ConceptsLbl: TextConst ENU = 'Concepts', ESP = 'Conceptos';
        //       PriceLbl@1100286004 :
        PriceLbl: TextConst ENU = 'Euro Price', ESP = 'Precio Euros';
        //       BaseLbl@1100286005 :
        BaseLbl: TextConst ENU = 'Base', ESP = 'Base imponible';
        //       RetentionLbl@1100286006 :
        RetentionLbl: TextConst ENU = 'Retention', ESP = 'Retenci¢n';
        //       DiferenceLbl@1100286007 :
        DiferenceLbl: TextConst ENU = 'Diference', ESP = 'Diferencia';
        //       VATLbl@1100286008 :
        VATLbl: TextConst ENU = 'VAT', ESP = 'IVA';
        //       TotalLbl@1100286009 :
        TotalLbl: TextConst ENU = 'Total', ESP = 'Total';
        //       GEWithholdingCaptionLbl@1100286011 :
        GEWithholdingCaptionLbl: TextConst ENU = 'Withholding G.E.', ESP = 'Retenciones B.E.';
        //       PITWithholdingCaptionLbl@1100286010 :
        PITWithholdingCaptionLbl: TextConst ENU = 'Withholding PIT', ESP = 'Retenciones IRPF';
        //       WithholdingGroup@1100286016 :
        WithholdingGroup: Record 7207330;
        //       WithholdingGEPorc@1100286015 :
        WithholdingGEPorc: Decimal;
        //       WithHoldingGEAmount@1100286021 :
        WithHoldingGEAmount: Decimal;
        //       WithholdingPITPorc@1100286018 :
        WithholdingPITPorc: Decimal;
        //       WithHoldingPITAmount@1100286022 :
        WithHoldingPITAmount: Decimal;
        //       InvoiceBase@1100286014 :
        InvoiceBase: Decimal;
        //       InvoiceTotal@1100286013 :
        InvoiceTotal: Decimal;
        //       TotalPayment@1100286012 :
        TotalPayment: Decimal;
        //       SubTotalWithoutWithholding@1100286017 :
        SubTotalWithoutWithholding: Decimal;
        //       footer@1100286019 :
        footer: Text;
        //       footer2@1100286020 :
        footer2: Text;
        //       WorkDes@1100286023 :
        WorkDes: Text;
        //       ShowLines@1100286024 :
        ShowLines: Boolean;
        //       SalesInvoiceTxt@1100286025 :
        SalesInvoiceTxt: TextConst ENU = 'Sales Invoice', ESP = 'Factura de ventas';
        //       VATProductPostingGroup@1100286026 :
        VATProductPostingGroup: Record 324;
        //       PSIVATText@1100286027 :
        PSIVATText: Text;
        //       ContractNoTxt@100000005 :
        ContractNoTxt: TextConst ENU = 'Contract No.', ESP = 'N§ contrato';
        //       BenefitCenterTxt@100000004 :
        BenefitCenterTxt: TextConst ENU = 'Benefit Centre', ESP = 'Centro de beneficio';
        //       PosPresupTxt@100000003 :
        PosPresupTxt: TextConst ENU = 'Budget Pos.', ESP = 'Pos. Presup.';
        //       OrderTxt@100000002 :
        OrderTxt: TextConst ENU = 'Order', ESP = 'Orden';
        //       PepTxt@100000001 :
        PepTxt: TextConst ESP = 'Pep.';
        //       OrderNoTxt@100000000 :
        OrderNoTxt: TextConst ENU = 'Order', ESP = 'Pedido';
        //       ContractNoLbl@1100286028 :
        ContractNoLbl: TextConst ENU = 'Contract No.', ESP = 'N§ contrato';
        //       "--"@1100286030 :
        "--": Integer;
        //       rCfgQuoBuilding@1100286029 :
        rCfgQuoBuilding: Record 7207278;
        //       rSalesHeaderExt@1100286031 :
        rSalesHeaderExt: Record 7207071;



    trigger OnInitReport();
    begin
        GLSetup.GET;
        SalesSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
        //CompanyInfo.CALCFIELDS("Picture 2");
        rCfgQuoBuilding.GET;
        rCfgQuoBuilding.CALCFIELDS(Logo1);
        //-->
    end;

    trigger OnPreReport();
    begin
        if not CurrReport.USEREQUESTPAGE then
            InitLogInteraction;
    end;



    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    LOCAL procedure IsReportInPreviewMode(): Boolean;
    var
        //       MailManagement@7001100 :
        MailManagement: Codeunit 9520;
    begin
        //exit(CurrReport.PREVIEW or MailManagement.IsHandlingGetEmailBody);
        exit(CurrReport.PREVIEW);
    end;

    LOCAL procedure InitializeShipmentBuffer()
    var
        //       SalesShipmentHeader@1000 :
        SalesShipmentHeader: Record 110;
        //       TempSalesShipmentBuffer@1001 :
        TempSalesShipmentBuffer: Record 7190 TEMPORARY;
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then
            if SalesShipmentHeader.GET("Sales Invoice Line"."Shipment No.") then
                exit;

        if "Sales Invoice Header"."Order No." = '' then
            exit;

        CASE "Sales Invoice Line".Type OF
            "Sales Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Invoice Line");
            "Sales Invoice Line".Type::"G/L Account", "Sales Invoice Line".Type::Resource,
          "Sales Invoice Line".Type::"Charge (Item)", "Sales Invoice Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Invoice Line");
        end;

        SalesShipmentBuffer.RESET;
        SalesShipmentBuffer.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SETRANGE("Line No.", "Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.FIND('-') then begin
            TempSalesShipmentBuffer := SalesShipmentBuffer;
            if SalesShipmentBuffer.NEXT = 0 then begin
                SalesShipmentBuffer.GET(
                  TempSalesShipmentBuffer."Document No.", TempSalesShipmentBuffer."Line No.", TempSalesShipmentBuffer."Entry No.");
                SalesShipmentBuffer.DELETE;
                exit;
            end;
            SalesShipmentBuffer.CALCSUMS(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
                SalesShipmentBuffer.DELETEALL;
                exit;
            end;
        end;
    end;

    //     LOCAL procedure GenerateBufferFromValueEntry (SalesInvoiceLine2@1002 :
    LOCAL procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record 113)
    var
        //       ValueEntry@1000 :
        ValueEntry: Record 5802;
        //       ItemLedgerEntry@1001 :
        ItemLedgerEntry: Record 32;
        //       TotalQuantity@1003 :
        TotalQuantity: Decimal;
        //       Quantity@1004 :
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SETRANGE("Posting Date", "Sales Invoice Header"."Posting Date");
        ValueEntry.SETRANGE("Item Charge No.", '');
        ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.FIND('-') then
            repeat
                if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.NEXT = 0) or (TotalQuantity = 0);
    end;

    //     LOCAL procedure GenerateBufferFromShipment (SalesInvoiceLine@1000 :
    LOCAL procedure GenerateBufferFromShipment(SalesInvoiceLine: Record 113)
    var
        //       SalesInvoiceHeader@1001 :
        SalesInvoiceHeader: Record 112;
        //       SalesInvoiceLine2@1002 :
        SalesInvoiceLine2: Record 113;
        //       SalesShipmentHeader@1006 :
        SalesShipmentHeader: Record 110;
        //       SalesShipmentLine@1004 :
        SalesShipmentLine: Record 111;
        //       TotalQuantity@1003 :
        TotalQuantity: Decimal;
        //       Quantity@1005 :
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SETCURRENTKEY("Order No.");
        SalesInvoiceHeader.SETFILTER("No.", '..%1', "Sales Invoice Header"."No.");
        SalesInvoiceHeader.SETRANGE("Order No.", "Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.FIND('-') then
            repeat
                SalesInvoiceLine2.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SETRANGE(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SETRANGE("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SETRANGE("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.FIND('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.NEXT = 0;
            until SalesInvoiceHeader.NEXT = 0;

        SalesShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        SalesShipmentLine.SETRANGE("Order No.", "Sales Invoice Header"."Order No.");
        SalesShipmentLine.SETRANGE("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SETRANGE(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SETRANGE("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SETRANGE("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SETFILTER(Quantity, '<>%1', 0);

        if SalesShipmentLine.FIND('-') then
            repeat
                if "Sales Invoice Header"."Get Shipment Used" then
                    CorrectShipment(SalesShipmentLine);
                if ABS(SalesShipmentLine.Quantity) <= ABS(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if ABS(SalesShipmentLine.Quantity) > ABS(TotalQuantity) then
                        SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    if SalesShipmentHeader.GET(SalesShipmentLine."Document No.") then
                        AddBufferEntry(
                          SalesInvoiceLine,
                          Quantity,
                          SalesShipmentHeader."Posting Date");
                end;
            until (SalesShipmentLine.NEXT = 0) or (TotalQuantity = 0);
    end;

    //     LOCAL procedure CorrectShipment (var SalesShipmentLine@1001 :
    LOCAL procedure CorrectShipment(var SalesShipmentLine: Record 111)
    var
        //       SalesInvoiceLine@1000 :
        SalesInvoiceLine: Record 113;
    begin
        SalesInvoiceLine.SETCURRENTKEY("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SETRANGE("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SETRANGE("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.FIND('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.NEXT = 0;
    end;

    //     LOCAL procedure AddBufferEntry (SalesInvoiceLine@1001 : Record 113;QtyOnShipment@1002 : Decimal;PostingDate@1003 :
    LOCAL procedure AddBufferEntry(SalesInvoiceLine: Record 113; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SETRANGE("Posting Date", PostingDate);
        if SalesShipmentBuffer.FIND('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.MODIFY;
            exit;
        end;

        WITH SalesShipmentBuffer DO begin
            "Document No." := SalesInvoiceLine."Document No.";
            "Line No." := SalesInvoiceLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := SalesInvoiceLine.Type;
            "No." := SalesInvoiceLine."No.";
            Quantity := QtyOnShipment;
            "Posting Date" := PostingDate;
            INSERT;
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    LOCAL procedure DocumentCaption(): Text[250];
    begin
        if "Sales Invoice Header"."Prepayment Invoice" then
            exit(Text010);
        exit(Text004);
    end;

    procedure GetCarteraInvoice(): Boolean;
    var
        //       CustLedgEntry@1000 :
        CustLedgEntry: Record 21;
    begin
        WITH CustLedgEntry DO begin
            SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETRANGE("Document No.", "Sales Invoice Header"."No.");
            SETRANGE("Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
            SETRANGE("Posting Date", "Sales Invoice Header"."Posting Date");
            if FINDFIRST then
                if "Document Situation" = "Document Situation"::" " then
                    exit(FALSE)
                else
                    exit(TRUE)
            else
                exit(FALSE);
        end;
    end;

    //     procedure ShowCashAccountingCriteria (SalesInvoiceHeader@1100002 :
    procedure ShowCashAccountingCriteria(SalesInvoiceHeader: Record 112): Text;
    var
        //       VATEntry@1100000 :
        VATEntry: Record 254;
    begin
        GLSetup.GET;
        if not GLSetup."Unrealized VAT" then
            exit;
        CACCaptionLbl := '';
        VATEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
        VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::Invoice);
        if VATEntry.FINDSET then
            repeat
                if VATEntry."VAT Cash Regime" then
                    CACCaptionLbl := CACTxt;
            until (VATEntry.NEXT = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;

    //     procedure InitializeRequest (NewNoOfCopies@1000 : Integer;NewShowInternalInfo@1001 : Boolean;NewLogInteraction@1002 : Boolean;DisplayAsmInfo@1003 :
    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    //     LOCAL procedure FormatDocumentFields (SalesInvoiceHeader@1000 :
    LOCAL procedure FormatDocumentFields(SalesInvoiceHeader: Record 112)
    begin
        WITH SalesInvoiceHeader DO begin
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
            if "Payment Method Code" = '' then
                PaymentMethod.INIT
            else
                PaymentMethod.GET("Payment Method Code");

            OrderNoText := FormatDocument.SetText("Order No." <> '', FIELDCAPTION("Order No."));
            ReferenceText := FormatDocument.SetText("Your Reference" <> '', FIELDCAPTION("Your Reference"));
            VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FIELDCAPTION("VAT Registration No."));
        end;
    end;

    //     LOCAL procedure FormatAddressFields (SalesInvoiceHeader@1000 :
    LOCAL procedure FormatAddressFields(SalesInvoiceHeader: Record 112)
    begin
        FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesInvBillTo(CustAddr, SalesInvoiceHeader);
        ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, SalesInvoiceHeader);
    end;

    LOCAL procedure CollectAsmInformation()
    var
        //       ValueEntry@1000 :
        ValueEntry: Record 5802;
        //       ItemLedgerEntry@1001 :
        ItemLedgerEntry: Record 32;
        //       PostedAsmHeader@1002 :
        PostedAsmHeader: Record 910;
        //       PostedAsmLine@1004 :
        PostedAsmLine: Record 911;
        //       SalesShipmentLine@1003 :
        SalesShipmentLine: Record 111;
    begin
        TempPostedAsmLine.DELETEALL;
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then
            exit;
        WITH ValueEntry DO begin
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
            SETRANGE(Adjustment, FALSE);
            if not FINDSET then
                exit;
        end;
        repeat
            if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FINDSET then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.NEXT = 0;
                    end;
                end;
        until ValueEntry.NEXT = 0;
    end;

    //     LOCAL procedure TreatAsmLineBuffer (PostedAsmLine@1000 :
    LOCAL procedure TreatAsmLineBuffer(PostedAsmLine: Record 911)
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FINDFIRST then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        end else begin
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        end;
    end;

    //     LOCAL procedure GetUOMText (UOMCode@1000 :
    LOCAL procedure GetUOMText(UOMCode: Code[10]): Text[10];
    var
        //       UnitOfMeasure@1001 :
        UnitOfMeasure: Record 204;
    begin
        if not UnitOfMeasure.GET(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10];
    begin
        exit(PADSTR('', 2, ' '));
    end;

    //     LOCAL procedure GetLineFeeNoteOnReportHist (SalesInvoiceHeaderNo@1004 :
    LOCAL procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        //       LineFeeNoteOnReportHist@1000 :
        LineFeeNoteOnReportHist: Record 1053;
        //       CustLedgerEntry@1003 :
        CustLedgerEntry: Record 21;
        //       Customer@1001 :
        Customer: Record 18;
    begin
        TempLineFeeNoteOnReportHist.DELETEALL;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FINDFIRST then
            exit;

        if not Customer.GET(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SETRANGE("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FINDSET then begin
            repeat
                TempLineFeeNoteOnReportHist.INIT;
                TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.INSERT;
            until LineFeeNoteOnReportHist.NEXT = 0;
        end else begin
            //Clarify
            // LineFeeNoteOnReportHist.SETRANGE("Language Code", Language.GetUserLanguage);
            if LineFeeNoteOnReportHist.FINDSET then
                repeat
                    TempLineFeeNoteOnReportHist.INIT;
                    TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.INSERT;
                until LineFeeNoteOnReportHist.NEXT = 0;
        end;
    end;

    //    [Integration(DEFAULT,TRUE)]
    //     procedure OnAfterGetRecordSalesInvoiceHeader (SalesInvoiceHeader@1213 :
    procedure OnAfterGetRecordSalesInvoiceHeader(SalesInvoiceHeader: Record 112)
    begin
    end;


    //     procedure OnGetReferenceText (SalesInvoiceHeader@1000 : Record 112;var ReferenceText@1001 : Text[80];var Handled@1002 :
    procedure OnGetReferenceText(SalesInvoiceHeader: Record 112; var ReferenceText: Text[80]; var Handled: Boolean)
    begin
    end;

    /*begin
    //{
//      //Q7484 JDC 08/07/19 - Changed on layout to show information from Averia.
//      //Q16364 EPV 14/02/22 - Adaptar Factura Inesco
//    }
    end.
  */

}



