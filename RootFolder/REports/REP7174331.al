report 7174331 "SII Contrast"
{
  ApplicationArea=All;



    CaptionML = ENU = 'SII Contrast', ESP = 'SII Contraste';

    dataset
    {

        DataItem("Table2000000026"; "2000000026")
        {

            DataItemTableView = SORTING("Number")
                                 ORDER(Ascending)
                                 WHERE("Number" = CONST(1));
            ;
            Column(Label; Label)
            {
                //SourceExpr=Label;
            }
            Column(Filters; Filters)
            {
                //SourceExpr=Filters;
            }
            Column(ErrorValidacion; ErrorValidacion)
            {
                //SourceExpr=ErrorValidacion;
            }
            Column(Total_Caption; TotalLbl)
            {
                //SourceExpr=TotalLbl;
            }
            Column(BaseLbl_Caption; BaseLbl)
            {
                //SourceExpr=BaseLbl;
            }
            Column(TotalBase; TotalBase)
            {
                //SourceExpr=TotalBase;
            }
            Column(VAT_Caption; VATLbl)
            {
                //SourceExpr=VATLbl;
            }
            Column(TotalVat; TotalVat)
            {
                //SourceExpr=TotalVat;
            }
            Column(Purch_Caption; PurchLbl)
            {
                //SourceExpr=PurchLbl;
            }
            Column(SalesNoSII_Caption; SalesNoSIILbl)
            {
                //SourceExpr=SalesNoSIILbl;
            }
            Column(PurchNoSII_Caption; PurchNoSIILbl)
            {
                //SourceExpr=PurchNoSIILbl;
            }
            DataItem("Cust. Ledger Entry Total"; "Cust. Ledger Entry")
            {

                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
                                 ORDER(Ascending);
                ;
                Column(Sales_Caption; SalesLbl)
                {
                    //SourceExpr=SalesLbl;
                }
                Column(TotalBaseSales; TotalBaseSales)
                {
                    //SourceExpr=TotalBaseSales;
                }
                Column(TotalVATSales; TotalVATSales)
                {
                    //SourceExpr=TotalVATSales;
                }
                Column(Total_C_Caption; TotalLbl)
                {
                    //SourceExpr=TotalLbl;
                }
                Column(Base_C_Caption; BaseLbl)
                {
                    //SourceExpr=BaseLbl;
                }
                Column(VAT_C_Caption; VATLbl)
                {
                    //SourceExpr=VATLbl;
                }
                DataItem("Vendor Ledger Entry Total"; "Vendor Ledger Entry")
                {

                    DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                                 ORDER(Ascending);
                    ;
                    Column(Total_V_Caption; TotalLbl)
                    {
                        //SourceExpr=TotalLbl;
                    }
                    Column(Base_Caption; BaseLbl)
                    {
                        //SourceExpr=BaseLbl;
                    }
                    Column(TotalBasePurch; TotalBasePurch)
                    {
                        //SourceExpr=TotalBasePurch;
                    }
                    Column(VAT_V_Caption; VATLbl)
                    {
                        //SourceExpr=VATLbl;
                    }
                    Column(TotalVATPurch; TotalVATPurch)
                    {
                        //SourceExpr=TotalVATPurch;
                    }
                    DataItem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {

                        DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
                                 ORDER(Ascending);
                        ;
                        Column(CustLedgerEntry_CustomerNo; "Customer No.")
                        {
                            //SourceExpr="Customer No.";
                        }
                        Column(Customer_Name; Customer.Name)
                        {
                            //SourceExpr=Customer.Name;
                        }
                        Column(CustLedgerEntry_PostingDate; "Posting Date")
                        {
                            //SourceExpr="Posting Date";
                        }
                        Column(CustLedgerEntry_DocumentNo; "Document No.")
                        {
                            //SourceExpr="Document No.";
                        }
                        Column(Shipped; Shipped)
                        {
                            //SourceExpr=Shipped;
                        }
                        Column(CustLedgerEntry_ShipNo; "QuoSII Ship No.")
                        {
                            //SourceExpr="QuoSII Ship No.";
                        }
                        Column(CustLedgerEntry_SalesInvoiceType; "QuoSII Sales Invoice Type")
                        {
                            //SourceExpr="QuoSII Sales Invoice Type";
                        }
                        Column(CustLedgerEntry_SalesCorrectedInvoiceType; "QuoSII Sales Corrected In.Type")
                        {
                            //SourceExpr="QuoSII Sales Corrected In.Type";
                        }
                        Column(Estadocuadre_CLE; Estadocuadre_CLE)
                        {
                            //SourceExpr=Estadocuadre_CLE;
                        }
                        Column(Descuadrebase_CLE; Descuadrebase_CLE)
                        {
                            //SourceExpr=Descuadrebase_CLE;
                        }
                        Column(DescuadrebaseISP_CLE; DescuadrebaseISP_CLE)
                        {
                            //SourceExpr=DescuadrebaseISP_CLE;
                        }
                        Column(Descuadrecuota_CLE; Descuadrecuota_CLE)
                        {
                            //SourceExpr=Descuadrecuota_CLE;
                        }
                        Column(DescuadrecuotaRE_CLE; DescuadrecuotaRE_CLE)
                        {
                            //SourceExpr=DescuadrecuotaRE_CLE;
                        }
                        Column(Descuadreimporte_CLE; Descuadreimporte_CLE)
                        {
                            //SourceExpr=Descuadreimporte_CLE;
                        }
                        Column(ValidacionBase_CLE; ValidacionBase_CLE)
                        {
                            //SourceExpr=ValidacionBase_CLE;
                        }
                        Column(ValidacionCuota_CLE; ValidacionCuota_CLE)
                        {
                            //SourceExpr=ValidacionCuota_CLE;
                        }
                        Column(ValidacionImporte_CLE; ValidacionImporte_CLE)
                        {
                            //SourceExpr=ValidacionImporte_CLE;
                        }
                        Column(ValidacionBaseTotal_CLE; ValidacionBaseTotal_CLE)
                        {
                            //SourceExpr=ValidacionBaseTotal_CLE;
                        }
                        Column(ValidacionCuotaTotal_CLE; ValidacionCuotaTotal_CLE)
                        {
                            //SourceExpr=ValidacionCuotaTotal_CLE;
                        }
                        Column(ValidacionImporteTotal_CLE; ValidacionImporteTotal_CLE)
                        {
                            //SourceExpr=ValidacionImporteTotal_CLE;
                        }
                        Column(CustLedgerEntry_CustomerNo_Caption; FIELDCAPTION("Customer No."))
                        {
                            //SourceExpr=FIELDCAPTION("Customer No.");
                        }
                        Column(Customer_Name_Caption; Customer.FIELDCAPTION(Customer.Name))
                        {
                            //SourceExpr=Customer.FIELDCAPTION(Customer.Name);
                        }
                        Column(CustLedgerEntry_PostingDate_Caption; FIELDCAPTION("Posting Date"))
                        {
                            //SourceExpr=FIELDCAPTION("Posting Date");
                        }
                        Column(CustLedgerEntry_DocumentNo_Caption; FIELDCAPTION("Document No."))
                        {
                            //SourceExpr=FIELDCAPTION("Document No.");
                        }
                        Column(Shipped_Caption; ShippedLbl)
                        {
                            //SourceExpr=ShippedLbl;
                        }
                        Column(CustLedgerEntry_ShipNo_Caption; FIELDCAPTION("QuoSII Ship No."))
                        {
                            //SourceExpr=FIELDCAPTION("QuoSII Ship No.");
                        }
                        Column(CustLedgerEntry_SalesInvoiceType_Caption; FIELDCAPTION("QuoSII Sales Invoice Type"))
                        {
                            //SourceExpr=FIELDCAPTION("QuoSII Sales Invoice Type");
                        }
                        Column(CustLedgerEntry_SalesCorrectedInvoiceType_Caption; FIELDCAPTION("QuoSII Sales Corrected In.Type"))
                        {
                            //SourceExpr=FIELDCAPTION("QuoSII Sales Corrected In.Type");
                        }
                        Column(Estadocuadre_Caption; EstadocuadreLbl)
                        {
                            //SourceExpr=EstadocuadreLbl;
                        }
                        Column(Descuadrebase_Caption; DescuadrebaseLbl)
                        {
                            //SourceExpr=DescuadrebaseLbl;
                        }
                        Column(DescuadrebaseISP_Caption; DescuadrebaseISPLbl)
                        {
                            //SourceExpr=DescuadrebaseISPLbl;
                        }
                        Column(Descuadrecuota_Caption; DescuadrecuotaLbl)
                        {
                            //SourceExpr=DescuadrecuotaLbl;
                        }
                        Column(DescuadrecuotaRE_Caption; DescuadrecuotaRELbl)
                        {
                            //SourceExpr=DescuadrecuotaRELbl;
                        }
                        Column(Descuadreimporte_Caption; DescuadreimporteLbl)
                        {
                            //SourceExpr=DescuadreimporteLbl;
                        }
                        Column(ComprobacionBase_Caption; ComprobacionBaseLbl)
                        {
                            //SourceExpr=ComprobacionBaseLbl;
                        }
                        Column(ComprobacionCuota_Caption; ComprobacionCuotaLbl)
                        {
                            //SourceExpr=ComprobacionCuotaLbl;
                        }
                        Column(ComprobacionImporte_Caption; ComprobacionImporteLbl)
                        {
                            //SourceExpr=ComprobacionImporteLbl;
                        }
                        Column(TotalComprobacionBase_Caption; TotalComprobacionBaseLbl)
                        {
                            //SourceExpr=TotalComprobacionBaseLbl;
                        }
                        Column(TotalComprobacionCuota_Caption; TotalComprobacionCuotaLbl)
                        {
                            //SourceExpr=TotalComprobacionCuotaLbl;
                        }
                        Column(TotalComprobacionImporte_Caption; TotalComprobacionImporteLbl)
                        {
                            //SourceExpr=TotalComprobacionImporteLbl;
                        }
                        DataItem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                        {

                            DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                                 ORDER(Ascending);
                            ;
                            Column(VendorLedgerEntry_CustomerNo; "Vendor No.")
                            {
                                //SourceExpr="Vendor No.";
                            }
                            Column(Vendor_Name; Vendor.Name)
                            {
                                //SourceExpr=Vendor.Name;
                            }
                            Column(VendorLedgerEntry_PostingDate; "Posting Date")
                            {
                                //SourceExpr="Posting Date";
                            }
                            Column(VendorLedgerEntry_DocumentNo; "Document No.")
                            {
                                //SourceExpr="Document No.";
                            }
                            Column(Shipped_V; Shipped)
                            {
                                //SourceExpr=Shipped;
                            }
                            Column(VendorLedgerEntry_ShipNo; "QuoSII Ship No.")
                            {
                                //SourceExpr="QuoSII Ship No.";
                            }
                            Column(VendorLedgerEntry_PurchInvoiceType; "QuoSII Purch. Invoice Type")
                            {
                                //SourceExpr="QuoSII Purch. Invoice Type";
                            }
                            Column(VendorLedgerEntry_PurchCorrectedInvoiceType; "QuoSII Purch. Corr. Inv. Type")
                            {
                                //SourceExpr="QuoSII Purch. Corr. Inv. Type";
                            }
                            Column(Estadocuadre_VLE; Estadocuadre_VLE)
                            {
                                //SourceExpr=Estadocuadre_VLE;
                            }
                            Column(Descuadrebase_VLE; Descuadrebase_VLE)
                            {
                                //SourceExpr=Descuadrebase_VLE;
                            }
                            Column(DescuadrebaseISP_VLE; DescuadrebaseISP_VLE)
                            {
                                //SourceExpr=DescuadrebaseISP_VLE;
                            }
                            Column(Descuadrecuota_VLE; Descuadrecuota_VLE)
                            {
                                //SourceExpr=Descuadrecuota_VLE;
                            }
                            Column(DescuadrecuotaRE_VLE; DescuadrecuotaRE_VLE)
                            {
                                //SourceExpr=DescuadrecuotaRE_VLE;
                            }
                            Column(Descuadreimporte_VLE; Descuadreimporte_VLE)
                            {
                                //SourceExpr=Descuadreimporte_VLE;
                            }
                            Column(ValidacionBase_VLE; ValidacionBase_VLE)
                            {
                                //SourceExpr=ValidacionBase_VLE;
                            }
                            Column(ValidacionCuota_VLE; ValidacionCuota_VLE)
                            {
                                //SourceExpr=ValidacionCuota_VLE;
                            }
                            Column(ValidacionImporte_VLE; ValidacionImporte_VLE)
                            {
                                //SourceExpr=ValidacionImporte_VLE;
                            }
                            Column(ValidacionBaseTotal_VLE; ValidacionBaseTotal_VLE)
                            {
                                //SourceExpr=ValidacionBaseTotal_VLE;
                            }
                            Column(ValidacionCuotaTotal_VLE; ValidacionCuotaTotal_VLE)
                            {
                                //SourceExpr=ValidacionCuotaTotal_VLE;
                            }
                            Column(ValidacionImporteTotal_VLE; ValidacionImporteTotal_VLE)
                            {
                                //SourceExpr=ValidacionImporteTotal_VLE;
                            }
                            Column(VendorLedgerEntry_VendorNo_Caption; FIELDCAPTION("Vendor No."))
                            {
                                //SourceExpr=FIELDCAPTION("Vendor No.");
                            }
                            Column(Vendor_Name_Caption; Customer.FIELDCAPTION(Customer.Name))
                            {
                                //SourceExpr=Customer.FIELDCAPTION(Customer.Name);
                            }
                            Column(VendorLedgerEntry_PostingDate_Caption; FIELDCAPTION("Posting Date"))
                            {
                                //SourceExpr=FIELDCAPTION("Posting Date");
                            }
                            Column(VendorLedgerEntry_DocumentNo_Caption; FIELDCAPTION("Document No."))
                            {
                                //SourceExpr=FIELDCAPTION("Document No.");
                            }
                            Column(Shipped_V_Caption; ShippedLbl)
                            {
                                //SourceExpr=ShippedLbl;
                            }
                            Column(VendorLedgerEntry_ShipNo_Caption; FIELDCAPTION("QuoSII Ship No."))
                            {
                                //SourceExpr=FIELDCAPTION("QuoSII Ship No.");
                            }
                            Column(VendorLedgerEntry_PurchInvoiceType_Caption; FIELDCAPTION("QuoSII Purch. Invoice Type"))
                            {
                                //SourceExpr=FIELDCAPTION("QuoSII Purch. Invoice Type");
                            }
                            Column(VendorLedgerEntry_PurchCorrectedInvoiceType_Caption; FIELDCAPTION("QuoSII Purch. Corr. Inv. Type"))
                            {
                                //SourceExpr=FIELDCAPTION("QuoSII Purch. Corr. Inv. Type");
                            }
                            Column(Estadocuadre_V_Caption; EstadocuadreLbl)
                            {
                                //SourceExpr=EstadocuadreLbl;
                            }
                            Column(Descuadrebase_V_Caption; DescuadrebaseLbl)
                            {
                                //SourceExpr=DescuadrebaseLbl;
                            }
                            Column(DescuadrebaseISP_V_Caption; DescuadrebaseISPLbl)
                            {
                                //SourceExpr=DescuadrebaseISPLbl;
                            }
                            Column(Descuadrecuota_V_Caption; DescuadrecuotaLbl)
                            {
                                //SourceExpr=DescuadrecuotaLbl;
                            }
                            Column(DescuadrecuotaRE_V_Caption; DescuadrecuotaRELbl)
                            {
                                //SourceExpr=DescuadrecuotaRELbl;
                            }
                            Column(Descuadreimporte_V_Caption; DescuadreimporteLbl)
                            {
                                //SourceExpr=DescuadreimporteLbl;
                            }
                            Column(ComprobacionBase_V_Caption; ComprobacionBaseLbl)
                            {
                                //SourceExpr=ComprobacionBaseLbl;
                            }
                            Column(ComprobacionCuota_V_Caption; ComprobacionCuotaLbl)
                            {
                                //SourceExpr=ComprobacionCuotaLbl;
                            }
                            Column(ComprobacionImporte_V_Caption; ComprobacionImporteLbl)
                            {
                                //SourceExpr=ComprobacionImporteLbl;
                            }
                            Column(TotalComprobacionBase_V_Caption; TotalComprobacionBaseLbl)
                            {
                                //SourceExpr=TotalComprobacionBaseLbl;
                            }
                            Column(TotalComprobacionCuota_V_Caption; TotalComprobacionCuotaLbl)
                            {
                                //SourceExpr=TotalComprobacionCuotaLbl;
                            }
                            Column(TotalComprobacionImporte_V_Caption; TotalComprobacionImporteLbl)
                            {
                                //SourceExpr=TotalComprobacionImporteLbl;
                            }
                            DataItem("Vendor Ledger Entry No SII"; "Vendor Ledger Entry")
                            {

                                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code")
                                 ORDER(Ascending);
                                ;
                                Column(SIITypeVendor_VendorLedgerEntryNoSII; SIITypeVendor)
                                {
                                    //SourceExpr=SIITypeVendor;
                                }
                                Column(VendorNo_VendorLedgerEntryNoSII; "Vendor Ledger Entry No SII"."Vendor No.")
                                {
                                    //SourceExpr="Vendor Ledger Entry No SII"."Vendor No.";
                                }
                                Column(Name_VendorLedgerEntryNoSII; Vendor.Name)
                                {
                                    //SourceExpr=Vendor.Name;
                                }
                                Column(PostingDate_VendorLedgerEntryNoSII; "Vendor Ledger Entry No SII"."Posting Date")
                                {
                                    //SourceExpr="Vendor Ledger Entry No SII"."Posting Date";
                                }
                                Column(DocumentNo_VendorLedgerEntryNoSII; "Vendor Ledger Entry No SII"."Document No.")
                                {
                                    //SourceExpr="Vendor Ledger Entry No SII"."Document No.";
                                }
                                Column(VendorPostingGroup_VendorLedgerEntryNoSII; "Vendor Ledger Entry No SII"."Vendor Posting Group")
                                {
                                    //SourceExpr="Vendor Ledger Entry No SII"."Vendor Posting Group";
                                }
                                Column(PostingGrupSIIType_VendorLedgerEntryNoSII_Caption; PostingGrupSIITypeLbl)
                                {
                                    //SourceExpr=PostingGrupSIITypeLbl;
                                }
                                Column(VendorNo_VendorLedgerEntryNoSII_Caption; FIELDCAPTION("Vendor No."))
                                {
                                    //SourceExpr=FIELDCAPTION("Vendor No.");
                                }
                                Column(Name_VendorLedgerEntryNoSII_Caption; Vendor.FIELDCAPTION(Vendor.Name))
                                {
                                    //SourceExpr=Vendor.FIELDCAPTION(Vendor.Name);
                                }
                                Column(PostingDate_VendorLedgerEntryNoSII_Caption; FIELDCAPTION("Posting Date"))
                                {
                                    //SourceExpr=FIELDCAPTION("Posting Date");
                                }
                                Column(DocumentNo_VendorLedgerEntryNoSII_Caption; FIELDCAPTION("Document No."))
                                {
                                    //SourceExpr=FIELDCAPTION("Document No.");
                                }
                                Column(VendorPostingGroup_VendorLedgerEntryNoSII_Caption; FIELDCAPTION("Vendor Posting Group"))
                                {
                                    //SourceExpr=FIELDCAPTION("Vendor Posting Group");
                                }
                                DataItem("Cust. Ledger Entry No SII"; "Cust. Ledger Entry")
                                {

                                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
                                 ORDER(Ascending);
                                    ;
                                    Column(SIITypeCustomer_CustLedgerEntryNoSII; SIITypeCustomer)
                                    {
                                        //SourceExpr=SIITypeCustomer;
                                    }
                                    Column(CustomerNo_CustLedgerEntryNoSII; "Cust. Ledger Entry No SII"."Customer No.")
                                    {
                                        //SourceExpr="Cust. Ledger Entry No SII"."Customer No.";
                                    }
                                    Column(Name_CustLedgerEntryNoSII; Customer.Name)
                                    {
                                        //SourceExpr=Customer.Name;
                                    }
                                    Column(PostingDate_CustLedgerEntryNoSII; "Cust. Ledger Entry No SII"."Posting Date")
                                    {
                                        //SourceExpr="Cust. Ledger Entry No SII"."Posting Date";
                                    }
                                    Column(DocumentNo_CustLedgerEntryNoSII; "Cust. Ledger Entry No SII"."Document No.")
                                    {
                                        //SourceExpr="Cust. Ledger Entry No SII"."Document No.";
                                    }
                                    Column(CustomerPostingGroup_CustLedgerEntryNoSII; "Cust. Ledger Entry No SII"."Customer Posting Group")
                                    {
                                        //SourceExpr="Cust. Ledger Entry No SII"."Customer Posting Group";
                                    }
                                    Column(PostingGrupSIIType_CustLedgerEntryNoSII_Caption; PostingGrupSIITypeLbl)
                                    {
                                        //SourceExpr=PostingGrupSIITypeLbl;
                                    }
                                    Column(CustomerNo_CustLedgerEntryNoSII_Caption; FIELDCAPTION("Customer No."))
                                    {
                                        //SourceExpr=FIELDCAPTION("Customer No.");
                                    }
                                    Column(Name_CustLedgerEntryNoSII_Caption; Customer.FIELDCAPTION(Customer.Name))
                                    {
                                        //SourceExpr=Customer.FIELDCAPTION(Customer.Name);
                                    }
                                    Column(PostingDate_CustLedgerEntryNoSII_Caption; FIELDCAPTION("Posting Date"))
                                    {
                                        //SourceExpr=FIELDCAPTION("Posting Date");
                                    }
                                    Column(DocumentNo_CustLedgerEntryNoSII_Caption; FIELDCAPTION("Document No."))
                                    {
                                        //SourceExpr=FIELDCAPTION("Document No.");
                                    }
                                    Column(CustomerPostingGroup_CustLedgerEntryNoSII_Caption; FIELDCAPTION("Customer Posting Group"))
                                    {
                                        //SourceExpr=FIELDCAPTION("Customer Posting Group") ;
                                    }
                                    trigger OnPreDataItem();
                                    BEGIN
                                        //1902>
                                        "Cust. Ledger Entry No SII".SETRANGE("Posting Date", StartDate, EndDate);
                                        "Cust. Ledger Entry No SII".SETRANGE("Bill No.", '');
                                        "Cust. Ledger Entry No SII".SETFILTER("Document Type", '%1|%2',
                                                                              "Cust. Ledger Entry No SII"."Document Type"::Invoice,
                                                                              "Cust. Ledger Entry No SII"."Document Type"::"Credit Memo");

                                        "Cust. Ledger Entry No SII".SETRANGE("QuoSII Exported", FALSE);

                                        IF "Cust. Ledger Entry No SII".FINDSET THEN;
                                        //<1902
                                    END;

                                    trigger OnAfterGetRecord();
                                    VAR
                                        //                                   lrCustomerPostGroup@1000000000 :
                                        lrCustomerPostGroup: Record 92;
                                    BEGIN
                                        //1902>
                                        Customer.GET("Cust. Ledger Entry No SII"."Customer No.");
                                        CLEAR(SIITypeCustomer);
                                        IF "Cust. Ledger Entry No SII"."Customer Posting Group" <> '' THEN BEGIN
                                            IF lrCustomerPostGroup.GET("Cust. Ledger Entry No SII"."Customer Posting Group") THEN
                                                SIITypeCustomer := FORMAT(lrCustomerPostGroup."QuoSII Type");
                                        END;
                                        //<1902
                                    END;


                                }
                                trigger OnPreDataItem();
                                BEGIN
                                    //1902>
                                    "Vendor Ledger Entry No SII".SETRANGE("Posting Date", StartDate, EndDate);
                                    "Vendor Ledger Entry No SII".SETRANGE("Bill No.", '');
                                    "Vendor Ledger Entry No SII".SETFILTER("Document Type", '%1|%2',
                                                        "Vendor Ledger Entry No SII"."Document Type"::Invoice,
                                                        "Vendor Ledger Entry No SII"."Document Type"::"Credit Memo");
                                    "Vendor Ledger Entry No SII".SETRANGE("QuoSII Exported", FALSE);

                                    IF "Vendor Ledger Entry No SII".FINDSET THEN;
                                    //<1902
                                END;

                                trigger OnAfterGetRecord();
                                VAR
                                    //                                   lrVendorPostGroup@1000000000 :
                                    lrVendorPostGroup: Record 93;
                                BEGIN
                                    //1902>
                                    Vendor.GET("Vendor Ledger Entry No SII"."Vendor No.");
                                    CLEAR(SIITypeVendor);
                                    IF "Vendor Ledger Entry No SII"."Vendor Posting Group" <> '' THEN BEGIN
                                        IF lrVendorPostGroup.GET("Vendor Ledger Entry No SII"."Vendor Posting Group") THEN
                                            SIITypeVendor := FORMAT(lrVendorPostGroup."QuoSII Type");
                                    END;
                                    //<1902
                                END;


                            }
                            trigger OnPreDataItem();
                            BEGIN
                                IF StartDate = 0D THEN
                                    ERROR(STRSUBSTNO(Text7174332, StartDateLbl));

                                IF EndDate = 0D THEN
                                    ERROR(STRSUBSTNO(Text7174332, EndDateLbl));

                                "Vendor Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);
                                //Filtro para que no coja los efectos"
                                "Vendor Ledger Entry".SETRANGE("Bill No.", '');
                                "Vendor Ledger Entry".SETFILTER("Document Type", '%1|%2',
                                                    "Vendor Ledger Entry"."Document Type"::Invoice, "Vendor Ledger Entry"."Document Type"::"Credit Memo");

                                //-
                                Contador := "Vendor Ledger Entry".COUNT;
                                Actual := 0;

                                ValidacionBaseTotal_VLE := 0;
                                ValidacionCuotaTotal_VLE := 0;
                                ValidacionImporteTotal_VLE := 0;

                                IF "Vendor Ledger Entry".FINDSET THEN;
                                //+
                            END;

                            trigger OnAfterGetRecord();
                            BEGIN
                                Vendor.GET("Vendor Ledger Entry"."Vendor No.");
                                //Si se selecciona tipo de SII en el grupo registro, se comprueba que el cliente/proveedor pertenezca a ese tipo.

                                IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                                    IF NOT VendorPostingGroup.GET(Vendor."Vendor Posting Group") THEN
                                        CurrReport.SKIP
                                    ELSE BEGIN
                                        IF VendorPostingGroup."QuoSII Type" <> PostingGroupSIIType THEN
                                            CurrReport.SKIP;
                                    END;
                                END;

                                //-
                                //ProgressWindow.UPDATE(1,"Vendor Ledger Entry"."Document No.");
                                Actual += 1;
                                IF Contador <= 25 THEN
                                    Progress := (Actual / Contador * 2500) DIV 1
                                ELSE IF Actual MOD (Contador DIV 25) = 0 THEN
                                    Progress := (Actual / Contador * 2500) DIV 1;


                                ProgressWindow.UPDATE(1, Progress + 7500);

                                ValidacionBase_VLE := 0;
                                ValidacionCuota_VLE := 0;
                                ValidacionImporte_VLE := 0;
                                //+

                                //Comprobamos si esta o no enviado
                                Shipped := NoLbl;

                                SIIDocumentShipmentLine.RESET;
                                SIIDocumentShipmentLine.SETRANGE("Entry No.", "Vendor Ledger Entry"."Entry No.");
                                SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);

                                IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                                    //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                                    IF OnlyNotShipped THEN
                                        CurrReport.SKIP;

                                    Shipped := YesLbl;
                                END;

                                //-
                                IF Shipped = YesLbl THEN BEGIN
                                    SIIDocuments.RESET;
                                    SIIDocuments.SETFILTER("Document Type", '%1|%2|%3', 2, 8, 6);
                                    SIIDocuments.SETRANGE("Entry No.", "Vendor Ledger Entry"."Entry No.");
                                    //QuoSII_1.4.96.999.begin 
                                    //SIIDocumentShipmentLine.SETFILTER(SIIDocumentShipmentLine."AEAT Status",'%1|%2','CORRECTO','PARCIALMENTECORRECTO');
                                    SIIDocuments.SETFILTER("AEAT Status", '%1|%2', 'CORRECTO', 'PARCIALMENTECORRECTO');
                                    //QuoSII_1.4.96.999.end
                                    IF SIIDocuments.FINDFIRST THEN BEGIN
                                        //-
                                        //QuoSII_1.4.96.999.begin 
                                        //    IF SIIDocuments."Invoice Type" <> 'F4' THEN
                                        //      ValidacionBase_VLE := SIIDocuments."Inv. Base Amount"
                                        //    ELSE
                                        ValidacionBase_VLE := SIIDocuments."Inv. Base Amount" / 100;
                                        //QuoSII_1.4.96.999.end
                                        ValidacionCuota_VLE := SIIDocuments."Inv. Share";
                                        ValidacionImporte_VLE := SIIDocuments."Inv. Amount";
                                        //+
                                    END;
                                END;
                                //+

                                //Se calcula la base y el IVA de cada factura
                                BaseAmount := 0;
                                VATAmount := 0;
                                Amount := 0;
                                SubtotalBase := 0;
                                SubtotalVAT := 0;

                                VATEntry.RESET;
                                VATEntry.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VATEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                                VATEntry.SETFILTER("Document Type", '%1|%2', VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo");
                                VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                                IF VATEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        BaseAmount += VATEntry.Base;
                                        VATAmount += VATEntry.Amount;
                                    UNTIL VATEntry.NEXT = 0;
                                END ELSE BEGIN
                                    //No sujeta
                                    "Vendor Ledger Entry".CALCFIELDS("Amount (LCY)");
                                    BaseAmount := -"Vendor Ledger Entry"."Amount (LCY)";
                                END;

                                //-
                                Amount := BaseAmount + VATAmount;
                                IF Shipped = YesLbl THEN BEGIN
                                    ValidacionBase_VLE -= BaseAmount;
                                    ValidacionCuota_VLE -= VATAmount;
                                    ValidacionImporte_VLE -= Amount;

                                    IF ValidacionImporte_VLE <> 0 THEN
                                        HayErrorValidacion := TRUE;
                                END;
                                //+

                                SubtotalBase += BaseAmount;
                                SubtotalVAT += VATAmount;
                                TotalBase += BaseAmount;
                                TotalVat += VATAmount;

                                VATEntry.RESET;
                                VATEntry.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");
                                VATEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                                VATEntry.SETFILTER("Document Type", '%1|%2', VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo");
                                VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                                IF VATEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                            ValidacionBase_VLE := 0;
                                            ValidacionCuota_VLE := 0;
                                            ValidacionImporte_VLE := 0;
                                        END;

                                        IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"No Taxable VAT" THEN BEGIN
                                            ValidacionBase_VLE := 0;
                                            ValidacionCuota_VLE := 0;
                                            ValidacionImporte_VLE := 0;
                                        END;
                                    UNTIL VATEntry.NEXT = 0;
                                END;
                                //-
                                ValidacionBaseTotal_VLE += ValidacionBase_VLE;
                                ValidacionCuotaTotal_VLE += ValidacionCuota_VLE;
                                ValidacionImporteTotal_VLE += ValidacionImporte_VLE;
                                //+


                                CurrReport.CREATETOTALS(SubtotalBase, SubtotalVAT);

                                //1901>
                                IF wMostrarSoloDocsConDiferencias THEN BEGIN
                                    IF (ValidacionBase_VLE = 0)
                                      AND (ValidacionCuota_VLE = 0)
                                      AND (ValidacionImporte_VLE = 0) THEN
                                        CurrReport.SKIP;
                                END;
                                //<1901
                            END;


                        }
                        trigger OnPreDataItem();
                        BEGIN
                            SubtotalBase := 0;
                            SubtotalVAT := 0;
                            TotalBase := 0;
                            TotalVat := 0;

                            IF StartDate = 0D THEN
                                ERROR(STRSUBSTNO(Text7174332, StartDateLbl));

                            IF EndDate = 0D THEN
                                ERROR(STRSUBSTNO(Text7174332, EndDateLbl));

                            "Cust. Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);

                            //Filtro para que no coja los efectos"
                            "Cust. Ledger Entry".SETRANGE("Bill No.", '');
                            "Cust. Ledger Entry".SETFILTER("Document Type", '%1|%2',
                                                           "Cust. Ledger Entry"."Document Type"::Invoice, "Cust. Ledger Entry"."Document Type"::"Credit Memo");

                            //-
                            Contador := "Cust. Ledger Entry".COUNT;
                            Actual := 0;

                            ValidacionBaseTotal_CLE := 0;
                            ValidacionCuotaTotal_CLE := 0;
                            ValidacionImporteTotal_CLE := 0;


                            IF "Cust. Ledger Entry".FINDSET THEN;
                            //+
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            Customer.GET("Cust. Ledger Entry"."Customer No.");
                            //Si se selecciona tipo de SII en el grupo registro, se comprueba que el cliente/proveedor pertenezca a ese tipo.
                            IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                                IF NOT CustomerPostingGroup.GET(Customer."Customer Posting Group") THEN
                                    CurrReport.SKIP
                                ELSE BEGIN
                                    IF CustomerPostingGroup."QuoSII Type" <> PostingGroupSIIType THEN
                                        CurrReport.SKIP;
                                END;
                            END;


                            //-
                            //ProgressWindow.UPDATE(1,"Cust. Ledger Entry"."Document No.");
                            Actual += 1;
                            IF Contador <= 25 THEN
                                Progress := (Actual / Contador * 2500) DIV 1
                            ELSE IF Actual MOD (Contador DIV 25) = 0 THEN
                                Progress := (Actual / Contador * 2500) DIV 1;


                            ProgressWindow.UPDATE(1, Progress + 5000);

                            ValidacionBase_CLE := 0;
                            ValidacionCuota_CLE := 0;
                            ValidacionImporte_CLE := 0;
                            //+

                            //Comprobamos si esta o no enviado
                            Shipped := NoLbl;

                            SIIDocumentShipmentLine.RESET;
                            SIIDocumentShipmentLine.SETRANGE("Entry No.", "Cust. Ledger Entry"."Entry No.");
                            SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);

                            IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                                //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                                IF OnlyNotShipped THEN
                                    CurrReport.SKIP;

                                Shipped := YesLbl;
                            END;

                            //-
                            IF Shipped = YesLbl THEN BEGIN
                                SIIDocuments.RESET;
                                SIIDocuments.SETFILTER("AEAT Status", '%1|%2', 'CORRECTO', 'PARCIALMENTECORRECTO');
                                SIIDocuments.SETFILTER("Document Type", '%1|%2|%3', 1, 7, 6);
                                SIIDocuments.SETRANGE("Entry No.", "Cust. Ledger Entry"."Entry No.");
                                IF SIIDocuments.FINDFIRST THEN BEGIN
                                    //-
                                    //QuoSII_1.4.96.999.begin 
                                    IF SIIDocuments."Invoice Type" <> 'F4' THEN
                                        ValidacionBase_CLE := SIIDocuments."Inv. Base Amount"
                                    ELSE
                                        ValidacionBase_CLE := SIIDocuments."Inv. Base Amount" / 100;
                                    //QuoSII_1.4.96.999.end
                                    ValidacionCuota_CLE := SIIDocuments."Inv. Share";
                                    ValidacionImporte_CLE := SIIDocuments."Inv. Amount";
                                    //+
                                END;
                            END;
                            //+


                            //Se calcula la base y el IVA de cada factura
                            BaseAmount := 0;
                            VATAmount := 0;
                            Amount := 0;

                            VATEntry.RESET;
                            VATEntry.SETRANGE("Posting Date", "Cust. Ledger Entry"."Posting Date");
                            VATEntry.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
                            VATEntry.SETFILTER("Document Type", '%1|%2', VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo");
                            VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                            IF VATEntry.FINDSET THEN BEGIN
                                REPEAT
                                    BaseAmount += VATEntry.Base;
                                    VATAmount += VATEntry.Amount;
                                UNTIL VATEntry.NEXT = 0;
                            END ELSE BEGIN
                                //No sujeta
                                "Cust. Ledger Entry".CALCFIELDS("Amount (LCY)");
                                BaseAmount := -"Cust. Ledger Entry"."Amount (LCY)";
                            END;

                            //-
                            Amount := BaseAmount + VATAmount;
                            IF Shipped = YesLbl THEN BEGIN
                                ValidacionBase_CLE += BaseAmount;
                                ValidacionCuota_CLE += VATAmount;
                                ValidacionImporte_CLE += Amount;

                                IF ValidacionImporte_CLE <> 0 THEN
                                    HayErrorValidacion := TRUE;
                            END;
                            //+

                            SubtotalBase += BaseAmount;
                            SubtotalVAT += VATAmount;

                            TotalBase += BaseAmount;
                            TotalVat += VATAmount;

                            VATEntry.RESET;
                            VATEntry.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");
                            VATEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                            VATEntry.SETFILTER("Document Type", '%1|%2', VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo");
                            VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                            IF VATEntry.FINDSET THEN BEGIN
                                REPEAT
                                    IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                        ValidacionBase_CLE := 0;
                                        ValidacionCuota_CLE := 0;
                                        ValidacionImporte_CLE := 0;
                                    END;

                                    IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"No Taxable VAT" THEN BEGIN
                                        ValidacionBase_CLE := 0;
                                        ValidacionCuota_CLE := 0;
                                        ValidacionImporte_CLE := 0;
                                    END;
                                UNTIL VATEntry.NEXT = 0;
                            END;
                            //-
                            ValidacionBaseTotal_CLE += ValidacionBase_CLE;
                            ValidacionCuotaTotal_CLE += ValidacionCuota_CLE;
                            ValidacionImporteTotal_CLE += ValidacionImporte_CLE;
                            //+

                            CurrReport.CREATETOTALS(SubtotalBase, SubtotalVAT);

                            //1901>
                            IF wMostrarSoloDocsConDiferencias THEN BEGIN
                                IF (ValidacionBase_CLE = 0)
                                  AND (ValidacionCuota_CLE = 0)
                                  AND (ValidacionImporte_CLE = 0) THEN
                                    CurrReport.SKIP;
                            END;
                            //<1901
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        "Vendor Ledger Entry Total".SETRANGE("Posting Date", StartDate, EndDate);

                        //Filtro para que no coja los efectos"
                        "Vendor Ledger Entry Total".SETRANGE("Bill No.", '');
                        "Vendor Ledger Entry Total".SETFILTER("Document Type", '%1|%2',
                                        "Vendor Ledger Entry Total"."Document Type"::Invoice, "Vendor Ledger Entry Total"."Document Type"::"Credit Memo");

                        //-
                        Contador := "Vendor Ledger Entry Total".COUNT;
                        Actual := 0;

                        ValidacionBase_VLE := 0;
                        ValidacionCuota_VLE := 0;
                        ValidacionImporte_VLE := 0;

                        IF "Vendor Ledger Entry Total".FINDSET THEN;
                        //+
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        Vendor.GET("Vendor Ledger Entry Total"."Vendor No.");
                        //Si se selecciona tipo de SII en el grupo registro, se comprueba que el cliente/proveedor pertenezca a ese tipo.

                        IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                            IF NOT VendorPostingGroup.GET(Vendor."Vendor Posting Group") THEN
                                CurrReport.SKIP
                            ELSE BEGIN
                                IF VendorPostingGroup."QuoSII Type" <> PostingGroupSIIType THEN
                                    CurrReport.SKIP;
                            END;
                        END;

                        //-
                        //ProgressWindow.UPDATE(1,"Cust. Ledger Entry"."Document No.");
                        Actual += 1;
                        IF Contador <= 25 THEN
                            Progress := (Actual / Contador * 2500) DIV 1
                        ELSE IF Actual MOD (Contador DIV 25) = 0 THEN
                            Progress := (Actual / Contador * 2500) DIV 1;

                        ProgressWindow.UPDATE(1, Progress + 2500);

                        SIIDocumentShipmentLine.RESET;
                        SIIDocumentShipmentLine.SETRANGE("Entry No.", "Vendor Ledger Entry Total"."Entry No.");
                        SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);

                        IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                            //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                            IF OnlyNotShipped THEN
                                CurrReport.SKIP;

                            Shipped := YesLbl;
                        END;

                        //QuoSII1.4.begin 
                        SIIDocuments.RESET;
                        SIIDocuments.SETFILTER("Document Type", '%1|%2|%3', SIIDocuments."Document Type"::FR, SIIDocuments."Document Type"::PR,
                          SIIDocuments."Document Type"::OI);
                        SIIDocuments.SETRANGE("Entry No.", "Vendor Ledger Entry Total"."Entry No.");
                        //QuoSII_1.4.96.999.begin 
                        //SIIDocumentShipmentLine.SETFILTER(SIIDocumentShipmentLine."AEAT Status",'%1|%2','CORRECTO','PARCIALMENTECORRECTO');
                        SIIDocuments.SETFILTER("AEAT Status", '%1|%2', 'CORRECTO', 'PARCIALMENTECORRECTO');
                        //QuoSII_1.4.96.999.end
                        IF SIIDocuments.FINDFIRST THEN BEGIN

                            Descuadrebase_VLE := SIIDocuments."Base Imbalance";
                            DescuadrebaseISP_VLE := SIIDocuments."ISP Base Imbalance";
                            Descuadrecuota_VLE := SIIDocuments."Imbalance Fee";
                            DescuadrecuotaRE_VLE := SIIDocuments."Imbalance RE Fee";
                            Descuadreimporte_VLE := SIIDocuments."Imbalance Amount";
                            CASE SIIDocuments."Tally Status" OF
                                SIIDocuments."Tally Status"::Checked:
                                    Estadocuadre_VLE := 'Contrastada';
                                SIIDocuments."Tally Status"::"Partially Checked":
                                    Estadocuadre_VLE := 'Parcialmente Contrastada';
                                SIIDocuments."Tally Status"::"Not Checkeable":
                                    Estadocuadre_VLE := 'No Contrastable';
                                SIIDocuments."Tally Status"::"Not Checked":
                                    Estadocuadre_VLE := 'No Contrastada';
                                SIIDocuments."Tally Status"::"Check in Progress":
                                    Estadocuadre_VLE := 'Contraste en proceso';
                                ELSE
                                    Estadocuadre_VLE := '';
                            END;
                        END;
                        //QuoSII1.4.end

                        //Comprobamos si esta o no enviado
                        Shipped := NoLbl;

                        SIIDocumentShipmentLine.RESET;
                        SIIDocumentShipmentLine.SETRANGE("Entry No.", "Vendor Ledger Entry"."Entry No.");
                        SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);
                        IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                            //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                            IF OnlyNotShipped THEN
                                CurrReport.SKIP;

                            Shipped := YesLbl;
                        END;

                        //Se calcula la base y el IVA de cada factura
                        BaseAmount := 0;
                        VATAmount := 0;
                        Amount := 0;
                        SubtotalBase := 0;
                        SubtotalVAT := 0;

                        VATEntry.RESET;
                        VATEntry.SETRANGE("Posting Date", "Vendor Ledger Entry Total"."Posting Date");
                        VATEntry.SETRANGE("Document No.", "Vendor Ledger Entry Total"."Document No.");
                        VATEntry.SETFILTER("Document Type", '%1|%2', VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo");
                        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                        IF VATEntry.FINDSET THEN BEGIN
                            REPEAT
                                BaseAmount += VATEntry.Base;
                                VATAmount += VATEntry.Amount;
                            UNTIL VATEntry.NEXT = 0;
                        END ELSE BEGIN
                            "Vendor Ledger Entry Total".CALCFIELDS("Amount (LCY)");
                            BaseAmount := -"Vendor Ledger Entry Total"."Amount (LCY)";
                        END;


                        TotalBasePurch += BaseAmount;
                        TotalVATPurch += VATAmount;

                        TotalBase += BaseAmount;
                        TotalVat += VATAmount;

                        CurrReport.CREATETOTALS(SubtotalBase, SubtotalVAT, TotalBase, TotalVat);
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    SubtotalBase := 0;
                    SubtotalVAT := 0;

                    "Cust. Ledger Entry Total".SETRANGE("Posting Date", StartDate, EndDate);
                    //Filtro para que no coja los efectos"
                    "Cust. Ledger Entry Total".SETRANGE("Bill No.", '');
                    "Cust. Ledger Entry Total".SETFILTER("Document Type", '%1|%2', "Cust. Ledger Entry Total"."Document Type"::Invoice,
                      "Cust. Ledger Entry Total"."Document Type"::"Credit Memo");

                    HayErrorValidacion := FALSE;
                    ErrorValidacion := '';

                    //-
                    Contador := "Cust. Ledger Entry Total".COUNT;
                    Actual := 0;

                    ValidacionBase_CLE := 0;
                    ValidacionCuota_CLE := 0;
                    ValidacionImporte_CLE := 0;

                    IF "Cust. Ledger Entry Total".FINDSET THEN;
                    //+
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Customer.GET("Cust. Ledger Entry Total"."Customer No.");
                    //Si se selecciona tipo de SII en el grupo registro, se comprueba que el cliente/proveedor pertenezca a ese tipo.
                    IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                        IF NOT CustomerPostingGroup.GET(Customer."Customer Posting Group") THEN
                            CurrReport.SKIP
                        ELSE BEGIN
                            IF CustomerPostingGroup."QuoSII Type" <> PostingGroupSIIType THEN
                                CurrReport.SKIP;
                        END;
                    END;

                    //-
                    //ProgressWindow.UPDATE(1,"Cust. Ledger Entry"."Document No.");
                    Actual += 1;
                    IF Contador <= 25 THEN
                        Progress := (Actual / Contador * 2500) DIV 1
                    ELSE IF Actual MOD (Contador DIV 25) = 0 THEN
                        Progress := (Actual / Contador * 2500) DIV 1;

                    ProgressWindow.UPDATE(1, Progress);

                    //+

                    //Comprobamos si esta o no enviado
                    Shipped := NoLbl;

                    SIIDocumentShipmentLine.RESET;
                    SIIDocumentShipmentLine.SETRANGE("Entry No.", "Cust. Ledger Entry Total"."Entry No.");
                    SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);

                    IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                        //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                        IF OnlyNotShipped THEN
                            CurrReport.SKIP;

                        Shipped := YesLbl;
                    END;

                    //QuoSII1.4.begin 
                    SIIDocuments.RESET;
                    SIIDocuments.SETFILTER("AEAT Status", '%1|%2', 'CORRECTO', 'PARCIALMENTECORRECTO');
                    SIIDocuments.SETFILTER("Document Type", '%1|%2|%3', SIIDocuments."Document Type"::FE, SIIDocuments."Document Type"::CE,
                      SIIDocuments."Document Type"::OI);
                    SIIDocuments.SETRANGE("Entry No.", "Cust. Ledger Entry Total"."Entry No.");
                    IF SIIDocuments.FINDFIRST THEN BEGIN
                        Descuadrebase_CLE := SIIDocuments."Base Imbalance";
                        DescuadrebaseISP_CLE := SIIDocuments."ISP Base Imbalance";
                        Descuadrecuota_CLE := SIIDocuments."Imbalance Fee";
                        DescuadrecuotaRE_CLE := SIIDocuments."Imbalance RE Fee";
                        Descuadreimporte_CLE := SIIDocuments."Imbalance Amount";
                        CASE SIIDocuments."Tally Status" OF
                            SIIDocuments."Tally Status"::Checked:
                                Estadocuadre_CLE := 'Contrastada';
                            SIIDocuments."Tally Status"::"Partially Checked":
                                Estadocuadre_CLE := 'Parcialmente Contrastada';
                            SIIDocuments."Tally Status"::"Not Checkeable":
                                Estadocuadre_CLE := 'No Contrastable';
                            SIIDocuments."Tally Status"::"Not Checked":
                                Estadocuadre_CLE := 'No Contrastada';
                            SIIDocuments."Tally Status"::"Check in Progress":
                                Estadocuadre_CLE := 'Contraste en proceso';
                            ELSE
                                Estadocuadre_CLE := '';
                        END;
                    END;
                    //QuoSII1.4.end

                    //Se calcula la base y el IVA de cada factura
                    BaseAmount := 0;
                    VATAmount := 0;
                    Amount := 0;

                    VATEntry.RESET;
                    VATEntry.SETRANGE("Posting Date", "Cust. Ledger Entry Total"."Posting Date");
                    VATEntry.SETRANGE("Document No.", "Cust. Ledger Entry Total"."Document No.");
                    VATEntry.SETFILTER("Document Type", '%1|%2', VATEntry."Document Type"::Invoice, VATEntry."Document Type"::"Credit Memo");
                    VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                    IF VATEntry.FINDSET THEN BEGIN
                        REPEAT
                            BaseAmount += VATEntry.Base;
                            VATAmount += VATEntry.Amount;
                        UNTIL VATEntry.NEXT = 0;
                    END ELSE BEGIN
                        "Cust. Ledger Entry Total".CALCFIELDS("Amount (LCY)");
                        BaseAmount := -"Cust. Ledger Entry Total"."Amount (LCY)";
                    END;

                    TotalBaseSales += BaseAmount;
                    TotalVATSales += VATAmount;
                    TotalBase += BaseAmount;
                    TotalVat += VATAmount;

                    CurrReport.CREATETOTALS(SubtotalBase, SubtotalVAT, TotalBase, TotalVat);
                END;

                trigger OnPostDataItem();
                BEGIN
                    IF HayErrorValidacion THEN
                        ErrorValidacion := 'Hay errores de validaci¢n. Por favor rev¡selos.';
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                //Creamos un texto con los filtros para mostrarlos en el informe.
                Filters := '';
                IF (StartDate <> 0D) AND (EndDate <> 0D) THEN
                    Filters := STRSUBSTNO('%1..%2', StartDate, EndDate);

                IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                    IF Filters <> '' THEN
                        Filters += '; ';
                    Filters += PostingGrupSIITypeLbl + ': ' + FORMAT(PostingGroupSIIType);
                END;

                IF OnlyNotShipped THEN BEGIN
                    IF Filters <> '' THEN
                        Filters += '; ';
                    Filters += OnlyNotShippedLbl;
                END;

                TotalBase := 0;
                TotalVat := 0;
                TotalBaseSales := 0;
                TotalVATSales := 0;
                TotalBasePurch := 0;
                TotalVATPurch := 0;

                ProgressWindow.OPEN('Procesando contraste @1@@@@@@@@@@');

                SIIDocuments.RESET;
                SIIDocuments.SETRANGE("Posting Date", StartDate, EndDate);
                SIIDocuments.SETFILTER(SIIDocuments."AEAT Status", '<>%1&<>%2', 'INCORRECTO', '');
                IF SIIDocuments.FINDSET THEN BEGIN
                    REPEAT
                        QuoSIIManagement.ProcessConsulta(SIIDocuments."Document No.",
                                                         SIIDocuments."Document Type",
                                                         SIIDocuments."Entry No.",
                                                         SIIDocuments."Register Type",     //JAV 30/05
                                                         0);
                    UNTIL SIIDocuments.NEXT = 0;

                    SLEEP(10000);
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                ProgressWindow.CLOSE;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; "StartDate")
                {

                    CaptionML = ESP = 'Fecha Inicio';
                }
                field("End Date"; "EndDate")
                {

                    CaptionML = ESP = 'Fecha Fin';
                }
                field("Book Type"; "PostingGroupSIIType")
                {

                    CaptionML = ESP = 'Tipo libro';
                }
                field("Breakdown"; "Breakdown")
                {

                    CaptionML = ESP = 'Desglose';
                }
                field("Only Not Shipped"; "OnlyNotShipped")
                {

                    CaptionML = ESP = 'Mostrar solo no enviados';
                }
                field("MostrarSoloDocsConDiferencias"; "wMostrarSoloDocsConDiferencias")
                {

                    CaptionML = ENU = 'Show documents with differences only', ESP = 'Mostrar solo documentos con diferencias';
                }

            }
        }
    }
    labels
    {
    }

    var
        //       wMostrarSoloDocsConDiferencias@1000000150 :
        wMostrarSoloDocsConDiferencias: Boolean;
        //       SIIType@1000000060 :
        SIIType: Record 7174331;
        //       SIIDocumentShipmentLine@1000000059 :
        SIIDocumentShipmentLine: Record 7174336;
        //       VATEntry@1000000058 :
        VATEntry: Record 254;
        //       VATEntryAux@1000000057 :
        VATEntryAux: Record 254;
        //       Customer@1000000056 :
        Customer: Record 18;
        //       Vendor@1000000055 :
        Vendor: Record 23;
        //       CustLedgerEntry@1000000054 :
        CustLedgerEntry: Record 21;
        //       VendLedgerEntry@1000000053 :
        VendLedgerEntry: Record 25;
        //       CustomerPostingGroup@1000000052 :
        CustomerPostingGroup: Record 92;
        //       VendorPostingGroup@1000000051 :
        VendorPostingGroup: Record 93;
        //       Filters@1000000049 :
        Filters: Text[150];
        //       Shipped@1000000048 :
        Shipped: Text[150];
        //       StartDate@1000000047 :
        StartDate: Date;
        //       EndDate@1000000046 :
        EndDate: Date;
        //       Breakdown@1000000045 :
        Breakdown: Boolean;
        //       BaseAmount@1000000044 :
        BaseAmount: Decimal;
        //       VATAmount@1000000043 :
        VATAmount: Decimal;
        //       Amount@1000000042 :
        Amount: Decimal;
        //       PostingGroupSIIType@1000000041 :
        PostingGroupSIIType: OPtion " ","LF","OI","OS","BI";
        //       OnlyNotShipped@1000000040 :
        OnlyNotShipped: Boolean;
        //       TotalBase@1000000039 :
        TotalBase: Decimal;
        //       TotalVat@1000000038 :
        TotalVat: Decimal;
        //       TotalBaseSales@1000000037 :
        TotalBaseSales: Decimal;
        //       TotalVATSales@1000000036 :
        TotalVATSales: Decimal;
        //       TotalBasePurch@1000000035 :
        TotalBasePurch: Decimal;
        //       TotalVATPurch@1000000034 :
        TotalVATPurch: Decimal;
        //       SubtotalBase@1000000033 :
        SubtotalBase: Decimal;
        //       SubtotalVAT@1000000032 :
        SubtotalVAT: Decimal;
        //       SIIDocuments@1000000031 :
        SIIDocuments: Record 7174333;
        //       Estadocuadre_CLE@1000000030 :
        Estadocuadre_CLE: Text[150];
        //       Descuadrebase_CLE@1000000029 :
        Descuadrebase_CLE: Decimal;
        //       DescuadrebaseISP_CLE@1000000028 :
        DescuadrebaseISP_CLE: Decimal;
        //       Descuadrecuota_CLE@1000000027 :
        Descuadrecuota_CLE: Decimal;
        //       DescuadrecuotaRE_CLE@1000000026 :
        DescuadrecuotaRE_CLE: Decimal;
        //       Descuadreimporte_CLE@1000000025 :
        Descuadreimporte_CLE: Decimal;
        //       Estadocuadre_VLE@1000000024 :
        Estadocuadre_VLE: Text[150];
        //       Descuadrebase_VLE@1000000023 :
        Descuadrebase_VLE: Decimal;
        //       DescuadrebaseISP_VLE@1000000022 :
        DescuadrebaseISP_VLE: Decimal;
        //       Descuadrecuota_VLE@1000000021 :
        Descuadrecuota_VLE: Decimal;
        //       DescuadrecuotaRE_VLE@1000000020 :
        DescuadrecuotaRE_VLE: Decimal;
        //       Descuadreimporte_VLE@1000000019 :
        Descuadreimporte_VLE: Decimal;
        //       ValidacionBase_CLE@1000000018 :
        ValidacionBase_CLE: Decimal;
        //       ValidacionCuota_CLE@1000000017 :
        ValidacionCuota_CLE: Decimal;
        //       ValidacionImporte_CLE@1000000016 :
        ValidacionImporte_CLE: Decimal;
        //       ValidacionBase_VLE@1000000015 :
        ValidacionBase_VLE: Decimal;
        //       ValidacionCuota_VLE@1000000014 :
        ValidacionCuota_VLE: Decimal;
        //       ValidacionImporte_VLE@1000000013 :
        ValidacionImporte_VLE: Decimal;
        //       QuoSIIManagement@1000000012 :
        QuoSIIManagement: Codeunit 7174331;
        //       HayErrorValidacion@1000000011 :
        HayErrorValidacion: Boolean;
        //       ErrorValidacion@1000000010 :
        ErrorValidacion: Text[100];
        //       ProgressWindow@1000000009 :
        ProgressWindow: Dialog;
        //       Contador@1000000008 :
        Contador: Integer;
        //       Actual@1000000007 :
        Actual: Integer;
        //       Progress@1000000006 :
        Progress: Decimal;
        //       ValidacionBaseTotal_CLE@1000000005 :
        ValidacionBaseTotal_CLE: Decimal;
        //       ValidacionCuotaTotal_CLE@1000000004 :
        ValidacionCuotaTotal_CLE: Decimal;
        //       ValidacionImporteTotal_CLE@1000000003 :
        ValidacionImporteTotal_CLE: Decimal;
        //       ValidacionBaseTotal_VLE@1000000002 :
        ValidacionBaseTotal_VLE: Decimal;
        //       ValidacionCuotaTotal_VLE@1000000001 :
        ValidacionCuotaTotal_VLE: Decimal;
        //       ValidacionImporteTotal_VLE@1000000000 :
        ValidacionImporteTotal_VLE: Decimal;
        //       PageConst@1000000087 :
        PageConst: TextConst ENU = 'Page';
        //       YesLbl@1000000086 :
        YesLbl: TextConst ENU = 'Yes', ESP = 'Si';
        //       NoLbl@1000000085 :
        NoLbl: TextConst ENU = 'No', ESP = 'No';
        //       StartDateLbl@1000000084 :
        StartDateLbl: TextConst ENU = 'Start Date', ESP = 'Fecha Inicio';
        //       EndDateLbl@1000000083 :
        EndDateLbl: TextConst ENU = 'end Date', ESP = 'Fecha Fin';
        //       PostingGrupSIITypeLbl@1000000082 :
        PostingGrupSIITypeLbl: TextConst ENU = 'Posting gr. SII', ESP = 'Tipo Libro';
        //       OnlyNotShippedLbl@1000000081 :
        OnlyNotShippedLbl: TextConst ENU = 'Show only not shipped', ESP = 'Mostrar solo no enviados';
        //       TotalLbl@1000000080 :
        TotalLbl: TextConst ENU = 'Period Total:', ESP = 'Total periodo:';
        //       VATLbl@1000000079 :
        VATLbl: TextConst ENU = 'VAT', ESP = 'IVA';
        //       BaseLbl@1000000078 :
        BaseLbl: TextConst ENU = 'Base', ESP = 'Base';
        //       PostingDateLbl@1000000077 :
        PostingDateLbl: TextConst ENU = 'Posting Date', ESP = 'Fecha registro';
        //       DocNoLbl@1000000076 :
        DocNoLbl: TextConst ENU = 'Documento No.', ESP = 'N§ documento';
        //       ShippedLbl@1000000075 :
        ShippedLbl: TextConst ENU = 'Shipped', ESP = 'Enviado';
        //       InvoiceTypeLbl@1000000074 :
        InvoiceTypeLbl: TextConst ENU = 'Invoice Type', ESP = 'Tipo factura';
        //       CorrectedInvTypeLbl@1000000073 :
        CorrectedInvTypeLbl: TextConst ENU = 'Corrected Invoice Type', ESP = 'Tipo fact. rect.';
        //       SalesLbl@1000000072 :
        SalesLbl: TextConst ENU = 'Sales', ESP = 'Ventas';
        //       PurchLbl@1000000071 :
        PurchLbl: TextConst ENU = 'Purchases', ESP = 'Compras';
        //       SalesNoSIILbl@1000000096 :
        SalesNoSIILbl: TextConst ESP = 'Ventas sin Documento SII';
        //       PurchNoSIILbl@1000000097 :
        PurchNoSIILbl: TextConst ESP = 'Compras sin Documento SII';
        //       Label@1000000070 :
        Label: TextConst ENU = 'SII Validation Report', ESP = 'Informe Validaci¢n SII';
        //       Text7174332@1000000069 :
        Text7174332: TextConst ENU = 'Debe indicar un valor en el campo %1.';
        //       PeriodLbl@1000000068 :
        PeriodLbl: TextConst ENU = 'Period', ESP = 'Periodo';
        //       EstadocuadreLbl@1000000067 :
        EstadocuadreLbl: TextConst ESP = 'Estado cuadre';
        //       DescuadrebaseLbl@1000000066 :
        DescuadrebaseLbl: TextConst ESP = 'Descuadre Base';
        //       DescuadrebaseISPLbl@1000000065 :
        DescuadrebaseISPLbl: TextConst ESP = 'Descuadre Base ISP';
        //       DescuadrecuotaLbl@1000000064 :
        DescuadrecuotaLbl: TextConst ESP = 'Descuadre Cuota';
        //       DescuadrecuotaRELbl@1000000063 :
        DescuadrecuotaRELbl: TextConst ESP = 'Descuadre Cuota RE';
        //       DescuadreimporteLbl@1000000062 :
        DescuadreimporteLbl: TextConst ESP = 'Descuadre Importe';
        //       Err001@1000000061 :
        Err001: TextConst ESP = 'Fecha hasta debe ser posterior a Fecha desde';
        //       ComprobacionBaseLbl@1000000088 :
        ComprobacionBaseLbl: TextConst ESP = 'Comprobaci¢n base';
        //       ComprobacionCuotaLbl@1000000089 :
        ComprobacionCuotaLbl: TextConst ESP = 'Comprobaci¢n cuota';
        //       ComprobacionImporteLbl@1000000090 :
        ComprobacionImporteLbl: TextConst ESP = 'Comprobaci¢n importe';
        //       TotalComprobacionBaseLbl@1000000091 :
        TotalComprobacionBaseLbl: TextConst ESP = 'Total comprobaci¢n base';
        //       TotalComprobacionCuotaLbl@1000000092 :
        TotalComprobacionCuotaLbl: TextConst ESP = 'Total comprobaci¢n cuota';
        //       TotalComprobacionImporteLbl@1000000093 :
        TotalComprobacionImporteLbl: TextConst ESP = 'Total comprobaci¢n importe';
        //       SIITypeVendor@1000000094 :
        SIITypeVendor: Text;
        //       SIITypeCustomer@1000000095 :
        SIITypeCustomer: Text;

    /*begin
    {
      QuoSII_1.4.96.999 22/08/19 QMD - Migraci¢n Informe de Contraste. Desarrollo
      1901 19/09/19 CHP: PBI 13125, Se condiciona el informe para que no salgan las l¡neas con "Validaciones" a 0.
      1902 01/10/19 CHP: PBI 13368, Se muestran los documentos que no est n en Documentos SII.
      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as¡ no entra en confusi¢n con campos denominados Type
    }
    end.
  */

}




