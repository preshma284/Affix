report 50072 "Pedido venta"
{


    CaptionML = ENU = 'Sales order', ESP = 'Pedido venta';
    PreviewMode = PrintLayout;

    dataset
    {

        DataItem("Sales Header"; "Sales Header")
        {

            DataItemTableView = SORTING("Document Type", "No.")
                                 WHERE("Document Type" = CONST("Order"));
            RequestFilterHeadingML = ENU = 'Sales Order', ESP = 'Pedido venta';


            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
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
            Column(DocType_SalesHeader; "Document Type")
            {
                //SourceExpr="Document Type";
            }
            Column(No_SalesHeader; "No.")
            {
                //SourceExpr="No.";
            }
            Column(PostingDate_SalesHeader; FORMAT("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
                //SourceExpr=FORMAT("Posting Date",0,'<Day,2>/<Month,2>/<Year4>');
            }
            Column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
                //SourceExpr=PaymentTermsCaptionLbl;
            }
            Column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
                //SourceExpr=ShipmentMethodCaptionLbl;
            }
            Column(PaymentMethodCaption; PaymentMethodCaptionLbl)
            {
                //SourceExpr=PaymentMethodCaptionLbl;
            }
            Column(HomePageCaption; HomePageCaptionLbl)
            {
                //SourceExpr=HomePageCaptionLbl;
            }
            Column(EmailCaption; EmailCaptionLbl)
            {
                //SourceExpr=EmailCaptionLbl;
            }
            Column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
                //SourceExpr=DocumentDateCaptionLbl;
            }
            Column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            {
                //SourceExpr=AllowInvDiscCaptionLbl;
            }
            Column(Logo_empresa; rCompanyInfo.Picture)
            {
                //SourceExpr=rCompanyInfo.Picture;
            }
            Column(Name_Empresa; rCompanyInfo.Name)
            {
                //SourceExpr=rCompanyInfo.Name;
            }
            Column(Address_Empresa; rCompanyInfo.Address + '(' + rCompanyInfo."Post Code" + '  ' + rCompanyInfo.County + ')')
            {
                //SourceExpr=rCompanyInfo.Address + '(' + rCompanyInfo."Post Code"+'  '+ rCompanyInfo.County + ')';
            }
            Column(PostCode_Empresa; rCompanyInfo."Post Code" + ', ' + rCompanyInfo.County)
            {
                //SourceExpr=rCompanyInfo."Post Code"+', '+ rCompanyInfo.County;
            }
            Column(CIF_Empresa; rCompanyInfo."VAT Registration No.")
            {
                //SourceExpr=rCompanyInfo."VAT Registration No.";
            }
            Column(Email_empresa; rCompanyInfo."E-Mail")
            {
                //SourceExpr=rCompanyInfo."E-Mail";
            }
            Column(HomePage_Empresa; rCompanyInfo."Home Page")
            {
                //SourceExpr=rCompanyInfo."Home Page";
            }
            Column(PhoneNo_Empresa; rCompanyInfo."Phone No.")
            {
                //SourceExpr=rCompanyInfo."Phone No.";
            }
            Column(PhoneNo2_Empresa; rCompanyInfo."Phone No. 2")
            {
                //SourceExpr=rCompanyInfo."Phone No. 2";
            }
            Column(SelltoCustomerName_SalesHeader; "Sales Header"."Sell-to Customer Name")
            {
                //SourceExpr="Sales Header"."Sell-to Customer Name";
            }
            Column(SelltoAddress_SalesHeader; "Sales Header"."Sell-to Address")
            {
                //SourceExpr="Sales Header"."Sell-to Address";
            }
            Column(SelltoContact_SalesHeader; "Sales Header"."Sell-to Contact")
            {
                //SourceExpr="Sales Header"."Sell-to Contact";
            }
            Column(SelltoPhoneNo_SalesHeader; "Sales Header"."Sell-to Phone No.")
            {
                //SourceExpr="Sales Header"."Sell-to Phone No.";
            }
            DataItem("CopyLoop"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
                DataItem("PageLoop"; "2000000026")
                {

                    DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                    Column(CIF_Customer; rCustomer."VAT Registration No.")
                    {
                        //SourceExpr=rCustomer."VAT Registration No.";
                    }
                    Column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                        //SourceExpr=CompanyInfo2.Picture;
                    }
                    Column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                        //SourceExpr=CompanyInfo3.Picture;
                    }
                    Column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                        //SourceExpr=CompanyInfo1.Picture;
                    }
                    Column(SalesHeaderCopyText; STRSUBSTNO(Text004, CopyText))
                    {
                        //SourceExpr=STRSUBSTNO(Text004,CopyText);
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
                    Column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                        //SourceExpr=CompanyInfo."Home Page";
                    }
                    Column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                        //SourceExpr=CompanyInfo."E-Mail";
                    }
                    Column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
                    {
                        //SourceExpr=CompanyInfo."VAT Registration No.";
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
                    Column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                        //SourceExpr="Sales Header"."Bill-to Customer No.";
                    }
                    Column(DocDate_SalesHeader; FORMAT("Sales Header"."Document Date", 0, 4))
                    {
                        //SourceExpr=FORMAT("Sales Header"."Document Date",0,4);
                    }
                    Column(VATNoText; VATNoText)
                    {
                        //SourceExpr=VATNoText;
                    }
                    Column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                        //SourceExpr="Sales Header"."VAT Registration No.";
                    }
                    Column(ShipmentDate_SalesHeader; FORMAT("Sales Header"."Shipment Date"))
                    {
                        //SourceExpr=FORMAT("Sales Header"."Shipment Date");
                    }
                    Column(SalesPersonText; SalesPersonText)
                    {
                        //SourceExpr=SalesPersonText;
                    }
                    Column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                        //SourceExpr=SalesPurchPerson.Name;
                    }
                    Column(SalesHeaderNo1; "Sales Header"."No.")
                    {
                        //SourceExpr="Sales Header"."No.";
                    }
                    Column(ReferenceText; "Sales Header".FIELDCAPTION("External Document No."))
                    {
                        //SourceExpr="Sales Header".FIELDCAPTION("External Document No.");
                    }
                    Column(SalesOrderReference_SalesHeader; "Sales Header"."External Document No.")
                    {
                        //SourceExpr="Sales Header"."External Document No.";
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
                    Column(PricesIncludVAT_SalesHeader; "Sales Header"."Prices Including VAT")
                    {
                        //SourceExpr="Sales Header"."Prices Including VAT";
                    }
                    Column(PageCaption; PageCaptionCap)
                    {
                        //SourceExpr=PageCaptionCap;
                    }
                    Column(OutputNo; OutputNo)
                    {
                        //SourceExpr=OutputNo;
                    }
                    Column(PricesInclVATYesNo_SalesHeader; FORMAT("Sales Header"."Prices Including VAT"))
                    {
                        //SourceExpr=FORMAT("Sales Header"."Prices Including VAT");
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
                    Column(BankAccountNoCaption; BankAccountNoCaptionLbl)
                    {
                        //SourceExpr=BankAccountNoCaptionLbl;
                    }
                    Column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                        //SourceExpr=ShipmentDateCaptionLbl;
                    }
                    Column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                        //SourceExpr=OrderNoCaptionLbl;
                    }
                    Column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                        //SourceExpr="Sales Header".FIELDCAPTION("Bill-to Customer No.");
                    }
                    Column(PricesIncludVAT_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
                    {
                        //SourceExpr="Sales Header".FIELDCAPTION("Prices Including VAT");
                    }
                    Column(CACCaption; CACCaptionLbl)
                    {
                        //SourceExpr=CACCaptionLbl;
                    }
                    DataItem("DimensionLoop1"; "2000000026")
                    {

                        DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER(1 ..));


                        DataItemLinkReference = "Sales Header";
                        Column(DimText_DimLoop1; DimText)
                        {
                            //SourceExpr=DimText;
                        }
                        Column(Number_DimLoop1; Number)
                        {
                            //SourceExpr=Number;
                        }
                        Column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                            //SourceExpr=HeaderDimensionsCaptionLbl;
                        }
                        DataItem("Sales Line"; "Sales Line")
                        {

                            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");


                            DataItemLinkReference = "Sales Header";
                            DataItemLink = "Document Type" = FIELD("Document Type"),
                            "Document No." = FIELD("No.");
                        }
                        DataItem("RoundLoop"; "2000000026")
                        {

                            DataItemTableView = SORTING("Number");
                            ;
                            Column(LineNo_SalesLine; "Sales Line"."Line No.")
                            {
                                //SourceExpr="Sales Line"."Line No.";
                            }
                            Column(LineAmt_SalesLine; SalesLine."Line Amount")
                            {
                                //SourceExpr=SalesLine."Line Amount";
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(Desc_SalesLine; "Sales Line".Description)
                            {
                                //SourceExpr="Sales Line".Description;
                            }
                            Column(NNCSalesLineLineAmt; NNC_SalesLineLineAmt)
                            {
                                //SourceExpr=NNC_SalesLineLineAmt;
                            }
                            Column(NNCSalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                            {
                                //SourceExpr=NNC_SalesLineInvDiscAmt;
                            }
                            Column(NNCTotalExclVAT; NNC_TotalExclVAT)
                            {
                                //SourceExpr=NNC_TotalExclVAT;
                            }
                            Column(NNCVATAmt; NNC_VATAmt)
                            {
                                //SourceExpr=NNC_VATAmt;
                            }
                            Column(NNCPmtDiscOnVAT; NNC_PmtDiscOnVAT)
                            {
                                //SourceExpr=NNC_PmtDiscOnVAT;
                            }
                            Column(NNCTotalInclVAT2; NNC_TotalInclVAT2)
                            {
                                //SourceExpr=NNC_TotalInclVAT2;
                            }
                            Column(NNCVatAmt2; NNC_VatAmt2)
                            {
                                //SourceExpr=NNC_VatAmt2;
                            }
                            Column(NNCTotalExclVAT2; NNC_TotalExclVAT2)
                            {
                                //SourceExpr=NNC_TotalExclVAT2;
                            }
                            Column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                            {
                                //SourceExpr="Sales Header"."VAT Base Discount %";
                            }
                            Column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                            {
                                //SourceExpr=AsmInfoExistsForLine;
                            }
                            Column(No2_SalesLine; "Sales Line"."No.")
                            {
                                //SourceExpr="Sales Line"."No.";
                            }
                            Column(Qty_SalesLine; "Sales Line".Quantity)
                            {
                                //SourceExpr="Sales Line".Quantity;
                            }
                            Column(UOM_SalesLine; "Sales Line"."Unit of Measure")
                            {
                                //SourceExpr="Sales Line"."Unit of Measure";
                            }
                            Column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                            {
                                //SourceExpr="Sales Line"."Unit Price";
                                AutoFormatType = 2;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(LineDisc_SalesLine; "Sales Line"."Line Discount %")
                            {
                                //SourceExpr="Sales Line"."Line Discount %";
                            }
                            Column(LineAmt1_SalesLine; "Sales Line"."Line Amount")
                            {
                                //SourceExpr="Sales Line"."Line Amount";
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                            {
                                //SourceExpr="Sales Line"."Allow Invoice Disc.";
                            }
                            Column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                            {
                                //SourceExpr="Sales Line"."VAT Identifier";
                            }
                            Column(Type_SalesLine; FORMAT("Sales Line".Type))
                            {
                                //SourceExpr=FORMAT("Sales Line".Type);
                            }
                            Column(No1_SalesLine; "Sales Line"."Line No.")
                            {
                                //SourceExpr="Sales Line"."Line No.";
                            }
                            Column(AllowInvDisYesNo_SalesLine; FORMAT("Sales Line"."Allow Invoice Disc."))
                            {
                                //SourceExpr=FORMAT("Sales Line"."Allow Invoice Disc.");
                            }
                            Column(SalesLineInvDiscAmt; SalesLine."Inv. Discount Amount")
                            {
                                //SourceExpr=SalesLine."Inv. Discount Amount";
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(SalesLineLineAmtInvDiscAmt; -SalesLine."Pmt. Discount Amount")
                            {
                                //SourceExpr=-SalesLine."Pmt. Discount Amount";
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(NNCPmtDiscGivenAmount; NNC_PmtDiscGivenAmount)
                            {
                                //SourceExpr=NNC_PmtDiscGivenAmount;
                            }
                            Column(SalesLinePmtDiscGivenAmt; SalesLine."Pmt. Discount Amount")
                            {
                                //SourceExpr=SalesLine."Pmt. Discount Amount";
                            }
                            Column(TotalExclVATText; TotalExclVATText)
                            {
                                //SourceExpr=TotalExclVATText;
                            }
                            Column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                            {
                                //SourceExpr=VATAmountLine.VATAmountText;
                            }
                            Column(TotalInclVATText; TotalInclVATText)
                            {
                                //SourceExpr=TotalInclVATText;
                            }
                            Column(VATAmount; VATAmount)
                            {
                                //SourceExpr=VATAmount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(SalesLineLAmtInvDiscAmtVATAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" - SalesLine."Pmt. Discount Amount" + VATAmount)
                            {
                                //SourceExpr=SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" - SalesLine."Pmt. Discount Amount" + VATAmount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(VATDiscountAmount; -VATDiscountAmount)
                            {
                                //SourceExpr=-VATDiscountAmount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(VATBaseAmount; VATBaseAmount)
                            {
                                //SourceExpr=VATBaseAmount;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(TotalAmountInclVAT; TotalAmountInclVAT)
                            {
                                //SourceExpr=TotalAmountInclVAT;
                                AutoFormatType = 1;
                                AutoFormatExpression = "Sales Header"."Currency Code";
                            }
                            Column(UnitPriceCaption; UnitPriceCaptionLbl)
                            {
                                //SourceExpr=UnitPriceCaptionLbl;
                            }
                            Column(DiscountCaption; DiscountCaptionLbl)
                            {
                                //SourceExpr=DiscountCaptionLbl;
                            }
                            Column(AmountCaption; AmountCaptionLbl)
                            {
                                //SourceExpr=AmountCaptionLbl;
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
                            Column(PaymentDiscVATCaption; PaymentDiscVATCaptionLbl)
                            {
                                //SourceExpr=PaymentDiscVATCaptionLbl;
                            }
                            Column(Desc_SalesLineCaption; "Sales Line".FIELDCAPTION(Description))
                            {
                                //SourceExpr="Sales Line".FIELDCAPTION(Description);
                            }
                            Column(No_SalesLineCaption; "Sales Line".FIELDCAPTION("No."))
                            {
                                //SourceExpr="Sales Line".FIELDCAPTION("No.");
                            }
                            Column(Qty_SalesLineCaption; "Sales Line".FIELDCAPTION(Quantity))
                            {
                                //SourceExpr="Sales Line".FIELDCAPTION(Quantity);
                            }
                            Column(UOM_SalesLineCaption; "Sales Line".FIELDCAPTION("Unit of Measure"))
                            {
                                //SourceExpr="Sales Line".FIELDCAPTION("Unit of Measure");
                            }
                            Column(AllowInvDisc_SalesLineCaption; "Sales Line".FIELDCAPTION("Allow Invoice Disc."))
                            {
                                //SourceExpr="Sales Line".FIELDCAPTION("Allow Invoice Disc.");
                            }
                            Column(VATIdentifier_SalesLineCaption; "Sales Line".FIELDCAPTION("VAT Identifier"))
                            {
                                //SourceExpr="Sales Line".FIELDCAPTION("VAT Identifier");
                            }
                            DataItem("DimensionLoop2"; "2000000026")
                            {

                                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER(1 ..));
                                ;
                                Column(DimText_DimLoop2; DimText)
                                {
                                    //SourceExpr=DimText;
                                }
                                Column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                                {
                                    //SourceExpr=LineDimensionsCaptionLbl;
                                }
                                DataItem("AsmLoop"; "2000000026")
                                {

                                    ;
                                    Column(AsmLineUnitOfMeasureText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                                    {
                                        //SourceExpr=GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code");
                                    }
                                    Column(AsmLineQuantity; AsmLine.Quantity)
                                    {
                                        //SourceExpr=AsmLine.Quantity;
                                    }
                                    Column(AsmLineDescription; BlanksForIndent + AsmLine.Description)
                                    {
                                        //SourceExpr=BlanksForIndent + AsmLine.Description;
                                    }
                                    Column(AsmLineNo; BlanksForIndent + AsmLine."No.")
                                    {
                                        //SourceExpr=BlanksForIndent + AsmLine."No.";
                                    }
                                    Column(AsmLineType; AsmLine.Type)
                                    {
                                        //SourceExpr=AsmLine.Type;
                                    }
                                    DataItem("VATCounter"; "2000000026")
                                    {

                                        DataItemTableView = SORTING("Number");
                                        ;
                                        Column(VATAmountLineVATECBase; VATAmountLine."VAT Base")
                                        {
                                            //SourceExpr=VATAmountLine."VAT Base";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                                        {
                                            //SourceExpr=VATAmountLine."VAT Amount";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                                        {
                                            //SourceExpr=VATAmountLine."Line Amount";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                                        {
                                            //SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                                        {
                                            //SourceExpr=VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATAmountLineECAmt; VATAmountLine."EC Amount")
                                        {
                                            //SourceExpr=VATAmountLine."EC Amount";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATAmountLineVAT_VATCounter; VATAmountLine."VAT %")
                                        {
                                            DecimalPlaces = 0 : 5;
                                            //SourceExpr=VATAmountLine."VAT %";
                                        }
                                        Column(VATAmtLineVATIdentifier_VATCounter; VATAmountLine."VAT Identifier")
                                        {
                                            //SourceExpr=VATAmountLine."VAT Identifier";
                                        }
                                        Column(VATAmountLineEC; VATAmountLine."EC %")
                                        {
                                            //SourceExpr=VATAmountLine."EC %";
                                            AutoFormatType = 1;
                                            AutoFormatExpression = "Sales Header"."Currency Code";
                                        }
                                        Column(VATPecrentCaption; VATPecrentCaptionLbl)
                                        {
                                            //SourceExpr=VATPecrentCaptionLbl;
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
                                        Column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                                        {
                                            //SourceExpr=InvDiscBaseAmtCaptionLbl;
                                        }
                                        Column(LineAmountCaption; LineAmountCaptionLbl)
                                        {
                                            //SourceExpr=LineAmountCaptionLbl;
                                        }
                                        Column(InvPmtDiscountsCaption; InvPmtDiscountsCaptionLbl)
                                        {
                                            //SourceExpr=InvPmtDiscountsCaptionLbl;
                                        }
                                        Column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                                        {
                                            //SourceExpr=VATIdentifierCaptionLbl;
                                        }
                                        Column(ECAmtCaption; ECAmtCaptionLbl)
                                        {
                                            //SourceExpr=ECAmtCaptionLbl;
                                        }
                                        Column(ECPercentCaption; ECPercentCaptionLbl)
                                        {
                                            //SourceExpr=ECPercentCaptionLbl;
                                        }
                                        Column(TotalCaption; TotalCaptionLbl)
                                        {
                                            //SourceExpr=TotalCaptionLbl;
                                        }
                                        DataItem("VATCounterLCY"; "2000000026")
                                        {

                                            DataItemTableView = SORTING("Number");
                                            ;
                                            Column(VALExchRate; VALExchRate)
                                            {
                                                //SourceExpr=VALExchRate;
                                            }
                                            Column(VALSpecLCYHeader; VALSpecLCYHeader)
                                            {
                                                //SourceExpr=VALSpecLCYHeader;
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
                                            Column(VATAmountLineVAT_VATCounterLCY; VATAmountLine."VAT %")
                                            {
                                                DecimalPlaces = 0 : 5;
                                                //SourceExpr=VATAmountLine."VAT %";
                                            }
                                            Column(VATAmtLineVATIdentifier_VATCounterLCY; VATAmountLine."VAT Identifier")
                                            {
                                                //SourceExpr=VATAmountLine."VAT Identifier";
                                            }
                                            Column(VATBaseCaption; VATBaseCaptionLbl)
                                            {
                                                //SourceExpr=VATBaseCaptionLbl;
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
                                                Column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                                                {
                                                    //SourceExpr="Sales Header"."Sell-to Customer No.";
                                                }
                                                Column(ShipToAddr8; ShipToAddr[8])
                                                {
                                                    //SourceExpr=ShipToAddr[8];
                                                }
                                                Column(ShipToAddr7; ShipToAddr[7])
                                                {
                                                    //SourceExpr=ShipToAddr[7];
                                                }
                                                Column(ShipToAddr6; ShipToAddr[6])
                                                {
                                                    //SourceExpr=ShipToAddr[6];
                                                }
                                                Column(ShipToAddr5; ShipToAddr[5])
                                                {
                                                    //SourceExpr=ShipToAddr[5];
                                                }
                                                Column(ShipToAddr4; ShipToAddr[4])
                                                {
                                                    //SourceExpr=ShipToAddr[4];
                                                }
                                                Column(ShipToAddr3; ShipToAddr[3])
                                                {
                                                    //SourceExpr=ShipToAddr[3];
                                                }
                                                Column(ShipToAddr2; ShipToAddr[2])
                                                {
                                                    //SourceExpr=ShipToAddr[2];
                                                }
                                                Column(ShipToAddr1; ShipToAddr[1])
                                                {
                                                    //SourceExpr=ShipToAddr[1];
                                                }
                                                Column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                                                {
                                                    //SourceExpr=ShiptoAddressCaptionLbl;
                                                }
                                                Column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
                                                {
                                                    //SourceExpr="Sales Header".FIELDCAPTION("Sell-to Customer No.");
                                                }
                                                DataItem("PrepmtLoop"; "2000000026")
                                                {

                                                    DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER(1 ..));
                                                    ;
                                                    Column(PrepmtLineAmount; PrepmtLineAmount)
                                                    {
                                                        //SourceExpr=PrepmtLineAmount;
                                                        AutoFormatType = 1;
                                                        AutoFormatExpression = "Sales Header"."Currency Code";
                                                    }
                                                    Column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                                                    {
                                                        //SourceExpr=PrepmtInvBuf.Description;
                                                    }
                                                    Column(GLAccountNo_PrepmtInvBuf; PrepmtInvBuf."G/L Account No.")
                                                    {
                                                        //SourceExpr=PrepmtInvBuf."G/L Account No.";
                                                    }
                                                    Column(TotalExclVATText1; TotalExclVATText)
                                                    {
                                                        //SourceExpr=TotalExclVATText;
                                                    }
                                                    Column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText)
                                                    {
                                                        //SourceExpr=PrepmtVATAmountLine.VATAmountText;
                                                    }
                                                    Column(TotalInclVATTxt; TotalInclVATText)
                                                    {
                                                        //SourceExpr=TotalInclVATText;
                                                    }
                                                    Column(PrepmtInvBufAmount; PrepmtInvBuf.Amount)
                                                    {
                                                        //SourceExpr=PrepmtInvBuf.Amount;
                                                        AutoFormatType = 1;
                                                        AutoFormatExpression = "Sales Header"."Currency Code";
                                                    }
                                                    Column(PrepmtVATAmount; PrepmtVATAmount)
                                                    {
                                                        //SourceExpr=PrepmtVATAmount;
                                                        AutoFormatType = 1;
                                                        AutoFormatExpression = "Sales Header"."Currency Code";
                                                    }
                                                    Column(PrepmtInvBufAmtPrepmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                                                    {
                                                        //SourceExpr=PrepmtInvBuf.Amount + PrepmtVATAmount;
                                                        AutoFormatType = 1;
                                                        AutoFormatExpression = "Sales Header"."Currency Code";
                                                    }
                                                    Column(VATAmtLVATAmtText1; VATAmountLine.VATAmountText)
                                                    {
                                                        //SourceExpr=VATAmountLine.VATAmountText;
                                                    }
                                                    Column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                                                    {
                                                        //SourceExpr=PrepmtTotalAmountInclVAT;
                                                        AutoFormatType = 1;
                                                        AutoFormatExpression = "Sales Header"."Currency Code";
                                                    }
                                                    Column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                                                    {
                                                        //SourceExpr=PrepmtVATBaseAmount;
                                                        AutoFormatType = 1;
                                                        AutoFormatExpression = "Sales Header"."Currency Code";
                                                    }
                                                    Column(DescriptionCaption; DescriptionCaptionLbl)
                                                    {
                                                        //SourceExpr=DescriptionCaptionLbl;
                                                    }
                                                    Column(GLAccountNoCaption; GLAccountNoCaptionLbl)
                                                    {
                                                        //SourceExpr=GLAccountNoCaptionLbl;
                                                    }
                                                    Column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                                                    {
                                                        //SourceExpr=PrepaymentSpecCaptionLbl;
                                                    }
                                                    DataItem("PrepmtDimLoop"; "2000000026")
                                                    {

                                                        DataItemTableView = SORTING("Number")
                                 WHERE("Number" = FILTER(1 ..));
                                                        ;
                                                        Column(DimText2; DimText)
                                                        {
                                                            //SourceExpr=DimText;
                                                        }
                                                        DataItem("PrepmtVATCounter"; "2000000026")
                                                        {

                                                            DataItemTableView = SORTING("Number");
                                                            ;
                                                            Column(VATAmt_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Amount")
                                                            {
                                                                //SourceExpr=PrepmtVATAmountLine."VAT Amount";
                                                                AutoFormatType = 1;
                                                                AutoFormatExpression = "Sales Header"."Currency Code";
                                                            }
                                                            Column(VATBase_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Base")
                                                            {
                                                                //SourceExpr=PrepmtVATAmountLine."VAT Base";
                                                                AutoFormatType = 1;
                                                                AutoFormatExpression = "Sales Header"."Currency Code";
                                                            }
                                                            Column(LineAmt_PrepmtVATAmtLine; PrepmtVATAmountLine."Line Amount")
                                                            {
                                                                //SourceExpr=PrepmtVATAmountLine."Line Amount";
                                                                AutoFormatType = 1;
                                                                AutoFormatExpression = "Sales Header"."Currency Code";
                                                            }
                                                            Column(VAT_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT %")
                                                            {
                                                                DecimalPlaces = 0 : 5;
                                                                //SourceExpr=PrepmtVATAmountLine."VAT %";
                                                            }
                                                            Column(VATIdentifier_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Identifier")
                                                            {
                                                                //SourceExpr=PrepmtVATAmountLine."VAT Identifier";
                                                            }
                                                            Column(PrepaymentVATAmtSpecCaption; PrepaymentVATAmtSpecCaptionLbl)
                                                            {
                                                                //SourceExpr=PrepaymentVATAmtSpecCaptionLbl;
                                                            }
                                                            Column(PrepmtVATPercentCaption; VATPecrentCaptionLbl)
                                                            {
                                                                //SourceExpr=VATPecrentCaptionLbl;
                                                            }
                                                            Column(PrepmtVATBaseCaption; VATECBaseCaptionLbl)
                                                            {
                                                                //SourceExpr=VATECBaseCaptionLbl;
                                                            }
                                                            Column(PrepmtVATAmtCaption; VATAmountCaptionLbl)
                                                            {
                                                                //SourceExpr=VATAmountCaptionLbl;
                                                            }
                                                            Column(PrepmtVATIdentCaption; VATIdentifierCaptionLbl)
                                                            {
                                                                //SourceExpr=VATIdentifierCaptionLbl;
                                                            }
                                                            Column(PrepmtLineAmtCaption; LineAmountCaptionLbl)
                                                            {
                                                                //SourceExpr=LineAmountCaptionLbl;
                                                            }
                                                            Column(PrepmtTotalCaption; TotalCaptionLbl)
                                                            {
                                                                //SourceExpr=TotalCaptionLbl;
                                                            }
                                                            DataItem("PrepmtTotal"; "2000000026")
                                                            {

                                                                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                                                                ;
                                                                Column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
                                                                {
                                                                    //SourceExpr=PrepmtPaymentTerms.Description;
                                                                }
                                                                Column(PrepmtPaymentTermsCaption; PrepmtPaymentTermsCaptionLbl)
                                                                {
                                                                    //SourceExpr=PrepmtPaymentTermsCaptionLbl ;
                                                                }
                                                                trigger OnPreDataItem();
                                                                BEGIN
                                                                    IF NOT PrepmtInvBuf.FIND('-') THEN
                                                                        CurrReport.BREAK;
                                                                END;


                                                            }
                                                            trigger OnPreDataItem();
                                                            BEGIN
                                                                SETRANGE(Number, 1, PrepmtVATAmountLine.COUNT);
                                                            END;

                                                            trigger OnAfterGetRecord();
                                                            BEGIN
                                                                PrepmtVATAmountLine.GetLine(Number);
                                                            END;


                                                        }
                                                        trigger OnAfterGetRecord();
                                                        BEGIN
                                                            IF Number = 1 THEN BEGIN
                                                                IF NOT TempPrepmtDimSetEntry.FIND('-') THEN
                                                                    CurrReport.BREAK;
                                                            END ELSE
                                                                IF NOT Continue THEN
                                                                    CurrReport.BREAK;

                                                            CLEAR(DimText);
                                                            Continue := FALSE;
                                                            REPEAT
                                                                OldDimText := DimText;
                                                                IF DimText = '' THEN
                                                                    DimText :=
                                                                      STRSUBSTNO('%1 %2', TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code")
                                                                ELSE
                                                                    DimText :=
                                                                      STRSUBSTNO(
                                                                        '%1, %2 %3', DimText,
                                                                        TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code");
                                                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                                                    DimText := OldDimText;
                                                                    Continue := TRUE;
                                                                    EXIT;
                                                                END;
                                                            UNTIL TempPrepmtDimSetEntry.NEXT = 0;
                                                        END;


                                                    }
                                                    trigger OnPreDataItem();
                                                    BEGIN
                                                        CurrReport.CREATETOTALS(
                                                          PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT",
                                                          PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT Base",
                                                          PrepmtVATAmountLine."VAT Amount",
                                                          PrepmtLineAmount);
                                                    END;

                                                    trigger OnAfterGetRecord();
                                                    BEGIN
                                                        IF Number = 1 THEN BEGIN
                                                            IF NOT PrepmtInvBuf.FIND('-') THEN
                                                                CurrReport.BREAK;
                                                        END ELSE
                                                            IF PrepmtInvBuf.NEXT = 0 THEN
                                                                CurrReport.BREAK;

                                                        IF ShowInternalInfo THEN
                                                            DimMgt.GetDimensionSet(TempPrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");

                                                        IF "Sales Header"."Prices Including VAT" THEN
                                                            PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                                                        ELSE
                                                            PrepmtLineAmount := PrepmtInvBuf.Amount;
                                                    END;


                                                }
                                                trigger OnPreDataItem();
                                                BEGIN
                                                    IF NOT ShowShippingAddr THEN
                                                        CurrReport.BREAK;
                                                END;


                                            }
                                            trigger OnPreDataItem();
                                            BEGIN
                                                IF (NOT GLSetup."Print VAT specification in LCY") OR
                                                   ("Sales Header"."Currency Code" = '') OR
                                                   (VATAmountLine.GetTotalVATAmount = 0)
                                                THEN
                                                    CurrReport.BREAK;

                                                SETRANGE(Number, 1, VATAmountLine.COUNT);
                                                CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                                                IF GLSetup."LCY Code" = '' THEN
                                                    VALSpecLCYHeader := Text007 + Text008
                                                ELSE
                                                    VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                                                CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                                                VALExchRate := STRSUBSTNO(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                                            END;

                                            trigger OnAfterGetRecord();
                                            BEGIN
                                                VATAmountLine.GetLine(Number);
                                                VALVATBaseLCY :=
                                                  VATAmountLine.GetBaseLCY(
                                                    "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                                                VALVATAmountLCY :=
                                                  VATAmountLine.GetAmountLCY(
                                                    "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                                            END;


                                        }
                                        trigger OnPreDataItem();
                                        BEGIN
                                            IF (VATAmount = 0) AND (VATAmountLine."VAT %" + VATAmountLine."EC %" = 0) THEN
                                                CurrReport.BREAK;
                                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                                            CurrReport.CREATETOTALS(
                                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount",
                                              VATAmountLine."EC Amount", VATAmountLine."Pmt. Discount Amount");
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
                                        IF NOT DisplayAssemblyInformation THEN
                                            CurrReport.BREAK;
                                        IF NOT AsmInfoExistsForLine THEN
                                            CurrReport.BREAK;
                                        AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                        AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                        SETRANGE(Number, 1, AsmLine.COUNT);
                                    END;

                                    trigger OnAfterGetRecord();
                                    BEGIN
                                        IF Number = 1 THEN
                                            AsmLine.FINDSET
                                        ELSE
                                            AsmLine.NEXT;
                                    END;


                                }
                                trigger OnPreDataItem();
                                BEGIN
                                    IF NOT ShowInternalInfo THEN
                                        CurrReport.BREAK;

                                    DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
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
                                MoreLines := SalesLine.FIND('+');
                                WHILE MoreLines AND (SalesLine.Description = '') AND (SalesLine."Description 2" = '') AND
                                      (SalesLine."No." = '') AND (SalesLine.Quantity = 0) AND
                                      (SalesLine.Amount = 0)
                                DO
                                    MoreLines := SalesLine.NEXT(-1) <> 0;
                                IF NOT MoreLines THEN
                                    CurrReport.BREAK;
                                SalesLine.SETRANGE("Line No.", 0, SalesLine."Line No.");
                                SETRANGE(Number, 1, SalesLine.COUNT);
                                CurrReport.CREATETOTALS(SalesLine."Line Amount", SalesLine."Inv. Discount Amount", SalesLine."Pmt. Discount Amount");
                            END;

                            trigger OnAfterGetRecord();
                            BEGIN
                                IF Number = 1 THEN
                                    SalesLine.FIND('-')
                                ELSE
                                    SalesLine.NEXT;
                                "Sales Line" := SalesLine;
                                IF DisplayAssemblyInformation THEN
                                    AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);

                                IF NOT "Sales Header"."Prices Including VAT" AND
                                   (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                                THEN
                                    SalesLine."Line Amount" := 0;

                                IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                    "Sales Line"."No." := '';

                                NNC_SalesLineLineAmt += SalesLine."Line Amount";
                                NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";

                                NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;

                                NNC_TotalExclVAT := NNC_TotalLCY;
                                NNC_VATAmt := VATAmount;
                                NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;

                                NNC_PmtDiscOnVAT := -VATDiscountAmount;

                                NNC_TotalInclVAT2 := TotalAmountInclVAT;

                                NNC_VatAmt2 := VATAmount;
                                NNC_TotalExclVAT2 := VATBaseAmount;
                                NNC_PmtDiscGivenAmount := NNC_PmtDiscGivenAmount - SalesLine."Pmt. Discount Amount";
                            END;

                            trigger OnPostDataItem();
                            BEGIN
                                SalesLine.DELETEALL;
                            END;


                        }
                        trigger OnPreDataItem();
                        BEGIN
                            CurrReport.BREAK;
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
                            IF NOT DimSetEntry1.FIND('-') THEN
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
                trigger OnPreDataItem();
                BEGIN
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                END;

                trigger OnAfterGetRecord();
                VAR
                    //                                   PrepmtSalesLine@1002 :
                    PrepmtSalesLine: Record 37 TEMPORARY;
                    //                                   TempSalesLine@1001 :
                    TempSalesLine: Record 37 TEMPORARY;
                    //                                   SalesPost@1000 :
                    SalesPost: Codeunit 80;
                BEGIN
                    CLEAR(SalesLine);
                    CLEAR(SalesPost);
                    VATAmountLine.DELETEALL;
                    SalesLine.DELETEALL;
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DELETEALL;
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);

                    IF NOT PrepmtSalesLine.ISEMPTY THEN BEGIN
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        IF NOT TempSalesLine.ISEMPTY THEN
                            SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    END;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrepmtVATAmountLineDeduct);
                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    SalesPostPrepmt2.BuildInvLineBuffer2("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    IF (VATAmountLine."VAT Calculation Type" = VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT") AND
                       "Sales Header"."Prices Including VAT"
                    THEN BEGIN
                        VATBaseAmount := VATAmountLine.GetTotalLineAmount(FALSE, "Sales Header"."Currency Code");
                        TotalAmountInclVAT := VATAmountLine.GetTotalLineAmount(FALSE, "Sales Header"."Currency Code");
                    END;

                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscGivenAmount := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    NNC_SalesLineInvDiscAmt := 0;
                END;

                trigger OnPostDataItem();
                BEGIN
                    IF Print THEN
                        CODEUNIT.RUN(CODEUNIT::"Sales-Printed", "Sales Header");
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                Print := Print OR NOT IsReportInPreviewMode;
                AsmInfoExistsForLine := FALSE;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                FormatAddressFields("Sales Header");
                FormatDocumentFields("Sales Header");

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                ShowCashAccountingCriteria("Sales Header");

                IF Print THEN BEGIN
                    IF CurrReport.USErequestpage AND ArchiveDocument OR
                       NOT CurrReport.USErequestpage AND SalesSetup."Archive Orders"
                    THEN
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                OnAfterPostDataItem("Sales Header");
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
                group("group189")
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
                    field("ArchiveDocument"; "ArchiveDocument")
                    {

                        CaptionML = ENU = 'Archive Document', ESP = 'Archivar documento';
                        ToolTipML = ENU = 'Specifies if the document is archived after you print it.', ESP = 'Especifica si el documento se archiva despu‚s de imprimirlo.';
                        ApplicationArea = Basic, Suite;

                        ; trigger OnValidate()
                        BEGIN
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        END;


                    }
                    field("LogInteraction"; "LogInteraction")
                    {

                        CaptionML = ENU = 'Log Interaction', ESP = 'Log interacci¢n';
                        ToolTipML = ENU = 'Specifies that interactions with the contact are logged.', ESP = 'Indica que las interacciones con el contacto est n registradas.';
                        ApplicationArea = Basic, Suite;
                        Enabled = LogInteractionEnable;

                        ; trigger OnValidate()
                        BEGIN
                            IF LogInteraction THEN
                                ArchiveDocument := ArchiveDocumentEnable;
                        END;


                    }
                    field("ShowAssemblyComponents"; "DisplayAssemblyInformation")
                    {

                        CaptionML = ENU = 'Show Assembly Components', ESP = 'Mostrar componentes del ensamblado';
                        ToolTipML = ENU = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.', ESP = 'Especifica si desea que el informe incluya informaci¢n sobre componentes que se utilizaron en pedidos de ensamblado vinculados que suministraron el producto de venta.';
                        ApplicationArea = Assembly;
                    }

                }

            }
        }
        trigger OnInit()
        BEGIN
            LogInteractionEnable := TRUE;
            ArchiveDocument := SalesSetup."Archive Orders";
        END;

        trigger OnOpenPage()
        BEGIN
            InitLogInteraction;

            LogInteractionEnable := LogInteraction;
        END;


    }
    labels
    {
        Contactolbl = 'CONTACTO:/';
        Empresalbl = 'EMPRESA:/';
        TlfCorreolbl = 'TF:/';
        CIFlbl = 'CIF:/';
        Direccionlbl = 'DOMICILIO:/';
        FechaLBL = 'FECHA/';
        NPedidolbl = 'N§ PEDIDO/';
        Descripcionlbl = 'Descripci¢n/';
        Unidadeslbl = 'Unidades/';
        Preciolbl = 'Precio/Unidad/';
        Totallbl = 'Total/';
        Notalbl = 'NOTAS:/';
        IVAVigentelbl = 'A ESTOS PRECIOS SE LES APLICARÛ EL I.V.A. VIGENTE./';
        PlazosLBL = 'PLAZOS DE SUMINISTRO:/';
        InicioLBL = 'INICIO:/';
        FinLBL = 'FIN:/';
        CondicionesLBL = 'CONDICIONES PARTICULARES DE CONTRATACIêN/';
        Condiciones1LBL = '1. CARACTERäSTICAS DE LOS MATERIALES A SUMINISTRAR: Los materiales a los que se refiere este Pedido deber n ajustarse a las especificaciones entregadas./';
        Condiciones2LBL = '2. PRECIO: Los precios incluyen sin cargo :/';
        Condiciones21LBL = '- Embalaje necesario para la manipulaci¢n y el transporte de los materiales./';
        Condiciones22LBL = '- Portes a punto de destino, incluyendo la entrega y descarga./';
        Condiciones3LBL = '3. EXPEDICIêN, ENTREGA Y CORRESPONDENCIA: El CLIENTE, en el acto de expedici¢n total o parcial de los materiales, deber  remitir a la direcci¢n se¤alada como destino, el oportuna nota de entrega./';
        Condiciones31LBL = 'El peso, cantidad y n£mero de bultos o piezas expedidas ser n los reconocidos en el momento de la recepci¢n que quedar  acreditada con la firma del albar n correspondiente./';
        Condiciones32LBL = 'El albar n ser  firmado por el Jefe de Obra o persona en quien ‚ste delegue./';
        Condiciones33LBL = 'Toda correspondencia, albar n, factura, etc. a que d‚ origen este Pedido, deber  expresar la referencia y fecha del mismo./';
        Condiciones4LBL = '4. FORMA DE PAGO:/';
        Condiciones5LBL = '5. PROTECCIêN DE DATOS. Ambas partes se comprometen a cumplir la normativa vigente en materia de protecci¢n de datos personales./';
        Condiciones6LBL = '6.FUERO: Las partes para cuantas cuestiones o litigios se susciten con motivo de la interpretaci¢n, aplicaci¢n o cumplimiento del presente contrato, se someten expresamente para su resoluci¢n a arbitraje de la Sociedad Espa¤ola de Arbitraje, que tendr  lugar de acuerdo con su Reglamento y Estatutos, encomendando a dicha asociaci¢n la administraci¢n del arbitraje y la designaci¢n de los  rbitros./';
        NormaticaPRLlbl = 'NORMATIVA PRL PARA EMPRESAS DE SUMINISTRO DE MATERIALES/';
        NormaticaPRL1lbl = 'Å  Prohibir la presencia de trabajadores o terceros en el radio de acci¢n de la gr£a durante las tareas de carga y descarga./';
        NormaticaPRL2lbl = 'Å  No subir ni bajar con el cami¢n en movimiento./';
        NormaticaPRL3lbl = 'Å  En trabajos en zonas de servicios afectados, en las que no se disponga de una buena visibilidad de la ubicaci¢n conductos o cables, ser  necesaria la colaboraci¢n de un se¤alista./';
        NormaticaPRL4lbl = 'Å  En operaciones en zonas pr¢ximas a cables el‚ctricos, es necesario comprobar la tensi¢n de estos cables para poder identificar la distancia m¡nima de seguridad./';
        NormaticaPRL5lbl = 'Å  Realizar las entradas o salidas de las v¡as con precauci¢n y, si fuese necesario, con la ayuda de un se¤alista./';
        NormaticaPRL6lbl = 'Å  Cuando las operaciones comporten maniobras complejas o peligrosas, el conductor tiene que disponer de un se¤alista experto que lo gu¡e./';
        NormaticaPRL7lbl = 'Å  Evitar desplazamientos del cami¢n de obra en zonas a menos de 2 m del borde de coronaci¢n de taludes./';
        NormaticaPRL8lbl = 'Å  Durante la carga y descarga, el conductor ha de estar dentro de la cabina. Si no fuera posible, el conductor se posicionar  en un lugar que no entra¤e ning£n riesgo y cumpliendo las medidas de seguridad necesarias./';
        NormaticaPRL9lbl = 'Å  Realizar la carga y descarga del cami¢n en lugares habilitados./';
        NormaticaPRL10lbl = 'Å  Situar la carga uniformemente repartida por toda la caja del cami¢n./';
        NormaticaPRL11lbl = 'Å  Antes de levantar la caja basculadora, hay que asegurarse de la ausencia de obst culos a‚reos y de que la plataforma est‚ plana y sensiblemente horizontal./';
        NormaticaPRL12lbl = 'Å  Estacionar el cami¢n de obra en zonas adecuadas, de terreno llano y firme, sin riesgos de desplomes, desprendimientos o inundaciones (como m¡nimo a 2 m de los bordes de coronaci¢n). Hay que poner los frenos, sacar las llaves del contacto, cerrar el interruptor de la bater¡a y cerrar la cabina y el compartimento del motor./';
        NormaticaPRL13lbl = 'Å  Est  prohibido abandonar el cami¢n con el motor en marcha./';
        NormaticaPRL14lbl = 'Å  Cuando el conductor se baje del cami¢n, deber  utilizar casco de seguridad y chaleco con bandas reflectantes, as¡ como calzado de seguridad./';
        NormaticaPRL15lbl = 'Å  La iluminaci¢n de cada zona dedicada a la carga y la descarga de mercanc¡as ha de ser la adecuada para las caracter¡sticas de la actividad que se efect£e en ella./';
        NormaticaPRL16lbl = 'Å  Todos los desechos, como palets, cartones, bidones, latas, etc., que se produzcan como consecuencia de la realizaci¢n de los trabajos de carga y descarga, ser n controlados y eliminados peri¢dicamente en contenedores espec¡ficos./';
        NormaticaPRL17lbl = 'Å  Mantener los suelos de las cajas de los camiones limpios y ordenados./';
        NormaticaPRL18lbl = 'Å  No se podr n cargar m s de dos alturas de palets para evitar que los trabajadores tengan que subir a m s de dos metros de altura para colocar las eslingas para la descarga con gr£a. Si se cargan as¡, la descarga habr  que realizarla con carretilla elevadora adecuada al terreno, peso de la carga y altura. O bien mediante medios auxiliares adecuados a dicho altura tales como escaleras o m¢dulos de andamios./';
        ParaPoderTramitarLBL = 'PARA PODER TRAMITAR EL PAGO, ES OBLIGATORIO DEVOLVER FIRMADO EL PRESENTE PEDIDO FIRMADO/';
        CLIENTElbl = 'CLIENTE/';
        LignumTechlbl = 'Lignum Tech/';
        Fdolbl = 'FDO./';
    }

    var
        //       Text004@1004 :
        Text004:
// "%1 = Document No."
TextConst ENU = 'Order Confirmation %1', ESP = 'Confirmar pedido %1';
        //       PageCaptionCap@1005 :
        PageCaptionCap: TextConst ENU = 'Page %1 of %2', ESP = 'P gina %1 de %2';
        //       GLSetup@1007 :
        GLSetup: Record 98;
        //       ShipmentMethod@1008 :
        ShipmentMethod: Record 10;
        //       PaymentTerms@1009 :
        PaymentTerms: Record 3;
        //       PrepmtPaymentTerms@1068 :
        PrepmtPaymentTerms: Record 3;
        //       SalesPurchPerson@1010 :
        SalesPurchPerson: Record 13;
        //       CompanyInfo@1011 :
        CompanyInfo: Record 79;
        //       CompanyInfo1@1047 :
        CompanyInfo1: Record 79;
        //       CompanyInfo2@1048 :
        CompanyInfo2: Record 79;
        //       CompanyInfo3@1086 :
        CompanyInfo3: Record 79;
        //       SalesSetup@1050 :
        SalesSetup: Record 311;
        //       VATAmountLine@1012 :
        VATAmountLine: Record 290 TEMPORARY;
        //       PrepmtVATAmountLine@1058 :
        PrepmtVATAmountLine: Record 290 TEMPORARY;
        //       PrepmtVATAmountLineDeduct@1069 :
        PrepmtVATAmountLineDeduct: Record 290 TEMPORARY;
        //       SalesLine@1013 :
        SalesLine: Record 37 TEMPORARY;
        //       DimSetEntry1@1014 :
        DimSetEntry1: Record 480;
        //       DimSetEntry2@1015 :
        DimSetEntry2: Record 480;
        //       TempPrepmtDimSetEntry@1060 :
        TempPrepmtDimSetEntry: Record 480 TEMPORARY;
        //       PrepmtInvBuf@1059 :
        PrepmtInvBuf: Record 461 TEMPORARY;
        //       RespCenter@1016 :
        RespCenter: Record 5714;
        //       Language@1017 :
        Language: Codeunit "Language";
        //       CurrExchRate@1056 :
        CurrExchRate: Record 330;
        //       AsmHeader@1085 :
        AsmHeader: Record 900;
        //       AsmLine@1083 :
        AsmLine: Record 901;
        //       FormatAddr@1019 :
        FormatAddr: Codeunit 365;
        //       SegManagement@1020 :
        SegManagement: Codeunit 5051;
        //       ArchiveManagement@1044 :
        ArchiveManagement: Codeunit 5063;
        //       FormatDocument@1064 :
        FormatDocument: Codeunit 368;
        //       SalesPostPrepmt@1061 :
        SalesPostPrepmt: Codeunit 442;
        SalesPostPrepmt2: Codeunit "Sales-Post Prepayments 1";
        //       DimMgt@1071 :
        DimMgt: Codeunit 408;
        //       CustAddr@1021 :
        CustAddr: ARRAY[8] OF Text[50];
        //       ShipToAddr@1022 :
        ShipToAddr: ARRAY[8] OF Text[50];
        //       CompanyAddr@1023 :
        CompanyAddr: ARRAY[8] OF Text[50];
        //       SalesPersonText@1024 :
        SalesPersonText: Text[30];
        //       VATNoText@1025 :
        VATNoText: Text[80];
        //       TotalText@1027 :
        TotalText: Text[50];
        //       TotalExclVATText@1028 :
        TotalExclVATText: Text[50];
        //       TotalInclVATText@1029 :
        TotalInclVATText: Text[50];
        //       MoreLines@1030 :
        MoreLines: Boolean;
        //       NoOfCopies@1031 :
        NoOfCopies: Integer;
        //       NoOfLoops@1032 :
        NoOfLoops: Integer;
        //       CopyText@1033 :
        CopyText: Text[30];
        //       ShowShippingAddr@1034 :
        ShowShippingAddr: Boolean;
        //       DimText@1036 :
        DimText: Text[120];
        //       OldDimText@1037 :
        OldDimText: Text[75];
        //       ShowInternalInfo@1038 :
        ShowInternalInfo: Boolean;
        //       Continue@1039 :
        Continue: Boolean;
        //       ArchiveDocument@1045 :
        ArchiveDocument: Boolean;
        //       LogInteraction@1046 :
        LogInteraction: Boolean;
        //       VATAmount@1040 :
        VATAmount: Decimal;
        //       VATBaseAmount@1043 :
        VATBaseAmount: Decimal;
        //       VATDiscountAmount@1042 :
        VATDiscountAmount: Decimal;
        //       TotalAmountInclVAT@1041 :
        TotalAmountInclVAT: Decimal;
        //       VALVATBaseLCY@1049 :
        VALVATBaseLCY: Decimal;
        //       VALVATAmountLCY@1051 :
        VALVATAmountLCY: Decimal;
        //       VALSpecLCYHeader@1052 :
        VALSpecLCYHeader: Text[80];
        //       Text007@1055 :
        Text007: TextConst ENU = 'VAT Amount Specification in ', ESP = 'Especificar importe IVA en ';
        //       Text008@1054 :
        Text008: TextConst ENU = 'Local Currency', ESP = 'Divisa local';
        //       Text009@1053 :
        Text009: TextConst ENU = 'Exchange rate: %1/%2', ESP = 'Tipo cambio: %1/%2';
        //       VALExchRate@1057 :
        VALExchRate: Text[50];
        //       PrepmtVATAmount@1066 :
        PrepmtVATAmount: Decimal;
        //       PrepmtVATBaseAmount@1065 :
        PrepmtVATBaseAmount: Decimal;
        //       PrepmtTotalAmountInclVAT@1063 :
        PrepmtTotalAmountInclVAT: Decimal;
        //       PrepmtLineAmount@1062 :
        PrepmtLineAmount: Decimal;
        //       OutputNo@1067 :
        OutputNo: Integer;
        //       NNC_TotalLCY@1072 :
        NNC_TotalLCY: Decimal;
        //       NNC_TotalExclVAT@1073 :
        NNC_TotalExclVAT: Decimal;
        //       NNC_VATAmt@1074 :
        NNC_VATAmt: Decimal;
        //       NNC_TotalInclVAT@1075 :
        NNC_TotalInclVAT: Decimal;
        //       NNC_PmtDiscOnVAT@1076 :
        NNC_PmtDiscOnVAT: Decimal;
        //       NNC_TotalInclVAT2@1077 :
        NNC_TotalInclVAT2: Decimal;
        //       NNC_VatAmt2@1078 :
        NNC_VatAmt2: Decimal;
        //       NNC_TotalExclVAT2@1079 :
        NNC_TotalExclVAT2: Decimal;
        //       NNC_SalesLineLineAmt@1080 :
        NNC_SalesLineLineAmt: Decimal;
        //       NNC_SalesLineInvDiscAmt@1081 :
        NNC_SalesLineInvDiscAmt: Decimal;
        //       Print@1070 :
        Print: Boolean;
        //       PaymentMethod@1100000 :
        PaymentMethod: Record 289;
        //       NNC_PmtDiscGivenAmount@1100003 :
        NNC_PmtDiscGivenAmount: Decimal;
        //       ArchiveDocumentEnable@19005281 :
        ArchiveDocumentEnable: Boolean;
        //       LogInteractionEnable@19003940 :
        LogInteractionEnable: Boolean;
        //       DisplayAssemblyInformation@1082 :
        DisplayAssemblyInformation: Boolean;
        //       AsmInfoExistsForLine@1084 :
        AsmInfoExistsForLine: Boolean;
        //       PaymentTermsCaptionLbl@8455 :
        PaymentTermsCaptionLbl: TextConst ENU = 'Payment Terms', ESP = 'T‚rminos pago';
        //       ShipmentMethodCaptionLbl@9854 :
        ShipmentMethodCaptionLbl: TextConst ENU = 'Shipment Method', ESP = 'Condiciones env¡o';
        //       PaymentMethodCaptionLbl@1101573 :
        PaymentMethodCaptionLbl: TextConst ENU = 'Payment Method', ESP = 'Forma pago';
        //       PhoneNoCaptionLbl@6169 :
        PhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ESP = 'N§ tel‚fono';
        //       VATRegNoCaptionLbl@2224 :
        VATRegNoCaptionLbl: TextConst ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
        //       GiroNoCaptionLbl@7839 :
        GiroNoCaptionLbl: TextConst ENU = 'Giro No.', ESP = 'N§ giro postal';
        //       BankNameCaptionLbl@5585 :
        BankNameCaptionLbl: TextConst ENU = 'Bank', ESP = 'Banco';
        //       BankAccountNoCaptionLbl@5341 :
        BankAccountNoCaptionLbl: TextConst ENU = 'Account No.', ESP = 'N§ cuenta';
        //       ShipmentDateCaptionLbl@3615 :
        ShipmentDateCaptionLbl: TextConst ENU = 'Shipment Date', ESP = 'Fecha env¡o';
        //       OrderNoCaptionLbl@5963 :
        OrderNoCaptionLbl: TextConst ENU = 'Order No.', ESP = 'N§ pedido';
        //       HeaderDimensionsCaptionLbl@7125 :
        HeaderDimensionsCaptionLbl: TextConst ENU = 'Header Dimensions', ESP = 'Dimensiones cabecera';
        //       UnitPriceCaptionLbl@9823 :
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESP = 'Precio venta';
        //       DiscountCaptionLbl@7535 :
        DiscountCaptionLbl: TextConst ENU = 'Discount %', ESP = '% Descuento';
        //       AmountCaptionLbl@7794 :
        AmountCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       InvDiscAmtCaptionLbl@4720 :
        InvDiscAmtCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ESP = 'Importe descuento factura';
        //       SubtotalCaptionLbl@1782 :
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ESP = 'Subtotal';
        //       PmtDiscGivenAmtCaptionLbl@1100444 :
        PmtDiscGivenAmtCaptionLbl: TextConst ENU = 'Pmt. Discount Given Amount', ESP = 'Importe descuento P.P. concedido';
        //       PaymentDiscVATCaptionLbl@4507 :
        PaymentDiscVATCaptionLbl: TextConst ENU = 'Payment Discount on VAT', ESP = 'Descuento P.P. sobre IVA';
        //       LineDimensionsCaptionLbl@3801 :
        LineDimensionsCaptionLbl: TextConst ENU = 'Line Dimensions', ESP = 'Dimensiones l¡nea';
        //       VATPecrentCaptionLbl@1518 :
        VATPecrentCaptionLbl: TextConst ENU = 'VAT %', ESP = '% IVA';
        //       VATECBaseCaptionLbl@1104919 :
        VATECBaseCaptionLbl: TextConst ENU = 'VAT+EC Base', ESP = 'Base IVA+RE';
        //       VATAmountCaptionLbl@4595 :
        VATAmountCaptionLbl: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
        //       VATAmtSpecCaptionLbl@3447 :
        VATAmtSpecCaptionLbl: TextConst ENU = 'VAT Amount Specification', ESP = 'Especificaci¢n importe IVA';
        //       InvDiscBaseAmtCaptionLbl@2407 :
        InvDiscBaseAmtCaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ESP = 'Importe base descuento factura';
        //       LineAmountCaptionLbl@5261 :
        LineAmountCaptionLbl: TextConst ENU = 'Line Amount', ESP = 'Importe l¡nea';
        //       InvPmtDiscountsCaptionLbl@1102312 :
        InvPmtDiscountsCaptionLbl: TextConst ENU = 'Invoice and Pmt. Discounts', ESP = 'Factura y descuentos P.P.';
        //       VATIdentifierCaptionLbl@6906 :
        VATIdentifierCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
        //       ECAmtCaptionLbl@1106492 :
        ECAmtCaptionLbl: TextConst ENU = 'EC Amount', ESP = 'Importe RE';
        //       ECPercentCaptionLbl@1108950 :
        ECPercentCaptionLbl: TextConst ENU = 'EC %', ESP = '% RE';
        //       TotalCaptionLbl@1909 :
        TotalCaptionLbl: TextConst ENU = 'Total', ESP = 'Total';
        //       VATBaseCaptionLbl@5098 :
        VATBaseCaptionLbl: TextConst ENU = 'VAT Base', ESP = 'Base IVA';
        //       ShiptoAddressCaptionLbl@8743 :
        ShiptoAddressCaptionLbl: TextConst ENU = 'Ship-to Address', ESP = 'Direcci¢n de env¡o';
        //       DescriptionCaptionLbl@3701 :
        DescriptionCaptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       GLAccountNoCaptionLbl@5526 :
        GLAccountNoCaptionLbl: TextConst ENU = 'G/L Account No.', ESP = 'N§ cuenta';
        //       PrepaymentSpecCaptionLbl@4480 :
        PrepaymentSpecCaptionLbl: TextConst ENU = 'Prepayment Specification', ESP = 'Especificaci¢n prepago';
        //       PrepaymentVATAmtSpecCaptionLbl@5296 :
        PrepaymentVATAmtSpecCaptionLbl: TextConst ENU = 'Prepayment VAT Amount Specification', ESP = 'Especificaci¢n importe IVA prepago';
        //       PrepmtPaymentTermsCaptionLbl@5110 :
        PrepmtPaymentTermsCaptionLbl: TextConst ENU = 'Prepmt. Payment Terms', ESP = 'T‚rminos prepago';
        //       HomePageCaptionLbl@1109328 :
        HomePageCaptionLbl: TextConst ENU = 'Home Page', ESP = 'P gina Web';
        //       EmailCaptionLbl@1106630 :
        EmailCaptionLbl: TextConst ENU = 'E-Mail', ESP = 'Correo electr¢nico';
        //       DocumentDateCaptionLbl@1107925 :
        DocumentDateCaptionLbl: TextConst ENU = 'Document Date', ESP = 'Fecha emisi¢n documento';
        //       AllowInvDiscCaptionLbl@1000694785 :
        AllowInvDiscCaptionLbl: TextConst ENU = 'Allow Invoice Discount', ESP = 'Permitir descuento factura';
        //       CACCaptionLbl@1100091 :
        CACCaptionLbl: Text;
        //       CACTxt@1100092 :
        CACTxt: TextConst ENU = 'Rï¿½gimen especial del criterio de caja', ESP = 'R‚gimen especial del criterio de caja';
        //       rCompanyInfo@1100286000 :
        rCompanyInfo: Record 79;
        //       rCustomer@1100286001 :
        rCustomer: Record 18;




    trigger OnInitReport();
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);

        OnAfterInitReport;

        rCompanyInfo.GET;
        rCompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        if not CurrReport.USEREQUESTPAGE then
            InitLogInteraction;
    end;

    trigger OnPostReport();
    begin
        if LogInteraction and Print then
            if "Sales Header".FINDSET then
                repeat
                    "Sales Header".CALCFIELDS("No. of Archived Versions");
                    if "Sales Header"."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          SegManagement.SalesOrderConfirmInterDocType, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence",
                          "Sales Header"."No. of Archived Versions", DATABASE::Contact, "Sales Header"."Bill-to Contact No."
                          , "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description",
                          "Sales Header"."Opportunity No.")
                    else
                        SegManagement.LogDocument(
                          SegManagement.SalesOrderConfirmInterDocType, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence",
                          "Sales Header"."No. of Archived Versions", DATABASE::Customer, "Sales Header"."Bill-to Customer No.",
                          "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description",
                          "Sales Header"."Opportunity No.");
                until "Sales Header".NEXT = 0;

        rCustomer.GET("Sales Header"."Sell-to Customer No.");
    end;



    // procedure InitializeRequest (NoOfCopiesFrom@1000 : Integer;ShowInternalInfoFrom@1001 : Boolean;ArchiveDocumentFrom@1002 : Boolean;LogInteractionFrom@1003 : Boolean;PrintFrom@1004 : Boolean;DisplayAsmInfo@1005 :
    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    LOCAL procedure IsReportInPreviewMode(): Boolean;
    var
        //       MailManagement@1000 :
        MailManagement: Codeunit 9520;
    begin
        exit(CurrReport.PREVIEW or MailManagement.IsHandlingGetEmailBody);
    end;

    LOCAL procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';
    end;

    //     LOCAL procedure FormatAddressFields (var SalesHeader@1000 :
    LOCAL procedure FormatAddressFields(var SalesHeader: Record 36)
    begin
        FormatAddr.GetCompanyAddr(SalesHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesHeaderBillTo(CustAddr, SalesHeader);
        ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesHeader);
    end;

    //     LOCAL procedure FormatDocumentFields (SalesHeader@1000 :
    LOCAL procedure FormatDocumentFields(SalesHeader: Record 36)
    begin
        WITH SalesHeader DO begin
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetPaymentTerms(PrepmtPaymentTerms, "Prepmt. Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
            FormatDocument.SetPaymentMethod(PaymentMethod, "Payment Method Code", "Language Code");

            VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FIELDCAPTION("VAT Registration No."));
        end;
    end;

    //     LOCAL procedure GetUnitOfMeasureDescr (UOMCode@1000 :
    LOCAL procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10];
    var
        //       UnitOfMeasure@1001 :
        UnitOfMeasure: Record 204;
    begin
        if not UnitOfMeasure.GET(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    //     procedure ShowCashAccountingCriteria (SalesHeader@1100002 :
    procedure ShowCashAccountingCriteria(SalesHeader: Record 36): Text;
    var
        //       VATPostingSetup@1100000 :
        VATPostingSetup: Record 325;
        //       SalesLine@1100001 :
        SalesLine: Record 37;
    begin
        GLSetup.GET;
        if not GLSetup."VAT Cash Regime" then
            exit;
        CACCaptionLbl := '';
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        if SalesLine.FINDSET then
            repeat
                if VATPostingSetup.GET(SalesHeader."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
                    if VATPostingSetup."Unrealized VAT Type" <> VATPostingSetup."Unrealized VAT Type"::" " then
                        CACCaptionLbl := CACTxt;
            until (SalesLine.NEXT = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;


    procedure BlanksForIndent(): Text[10];
    begin
        exit(PADSTR('', 2, ' '));
    end;

    // [Integration(TRUE, TRUE)]
    LOCAL procedure OnAfterInitReport()
    begin
    end;

    // [Integration(TRUE, TRUE)]
    //     LOCAL procedure OnAfterPostDataItem (var SalesHeader@1000 :
    LOCAL procedure OnAfterPostDataItem(var SalesHeader: Record 36)
    begin
    end;

    /*begin
    end.
  */

}



