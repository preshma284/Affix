report 7174333 "SII Ledger VAT Entry"
{
  ApplicationArea=All;



    CaptionML = ENU = 'SII Ledger VAT Entry', ESP = 'SII Movimientos de IVA';

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
            Column(Breakdown; Breakdown)
            {
                //SourceExpr=Breakdown;
            }
            Column(Filters; Filters)
            {
                //SourceExpr=Filters;
            }
            Column(TotalLbl; TotalLbl)
            {
                //SourceExpr=TotalLbl;
            }
            Column(VATLbl; VATLbl)
            {
                //SourceExpr=VATLbl;
            }
            Column(BaseLbl; BaseLbl)
            {
                //SourceExpr=BaseLbl;
            }
            Column(AmountLbl; AmountLbl)
            {
                //SourceExpr=AmountLbl;
            }
            Column(PostingDateLbl; PostingDateLbl)
            {
                //SourceExpr=PostingDateLbl;
            }
            Column(DocNoLbl; DocNoLbl)
            {
                //SourceExpr=DocNoLbl;
            }
            Column(ShippedLbl; ShippedLbl)
            {
                //SourceExpr=ShippedLbl;
            }
            Column(InvoiceTypeLbl; InvoiceTypeLbl)
            {
                //SourceExpr=InvoiceTypeLbl;
            }
            Column(CorrectedInvTypeLbl; CorrectedInvTypeLbl)
            {
                //SourceExpr=CorrectedInvTypeLbl;
            }
            Column(SalesLbl; SalesLbl)
            {
                //SourceExpr=SalesLbl;
            }
            Column(PurchLbl; PurchLbl)
            {
                //SourceExpr=PurchLbl;
            }
            Column(TotalBase; TotalBase)
            {
                //SourceExpr=TotalBase;
            }
            Column(TotalVAT; TotalVat)
            {
                //SourceExpr=TotalVat;
            }
            Column(ShipNoLbl; ShipNoLbl)
            {
                //SourceExpr=ShipNoLbl;
            }
            DataItem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {

                ;
                Column(CustEntryNo; "Cust. Ledger Entry"."Entry No.")
                {
                    //SourceExpr="Cust. Ledger Entry"."Entry No.";
                }
                Column(CustNo; "Cust. Ledger Entry"."Customer No.")
                {
                    //SourceExpr="Cust. Ledger Entry"."Customer No.";
                }
                Column(CustName; Customer.Name)
                {
                    //SourceExpr=Customer.Name;
                }
                Column(CustPostingDate; "Cust. Ledger Entry"."Posting Date")
                {
                    //SourceExpr="Cust. Ledger Entry"."Posting Date";
                }
                Column(CustDocNo; "Cust. Ledger Entry"."Document No.")
                {
                    //SourceExpr="Cust. Ledger Entry"."Document No.";
                }
                Column(CustShipped; Shipped)
                {
                    //SourceExpr=Shipped;
                }
                Column(CustInvoiceType; "Cust. Ledger Entry"."QuoSII Sales Invoice Type")
                {
                    //SourceExpr="Cust. Ledger Entry"."QuoSII Sales Invoice Type";
                }
                Column(CustCorrectedInvoiceType; "Cust. Ledger Entry"."QuoSII Sales Corrected In.Type")
                {
                    //SourceExpr="Cust. Ledger Entry"."QuoSII Sales Corrected In.Type";
                }
                Column(CustBaseAmount; BaseAmount)
                {
                    //SourceExpr=BaseAmount;
                }
                Column(CustVATAmount; VATAmount)
                {
                    //SourceExpr=VATAmount;
                }
                Column(CustBaseVATAmount; BaseVATAmount)
                {
                    //SourceExpr=BaseVATAmount;
                }
                Column(CustShipNo; "Cust. Ledger Entry"."QuoSII Ship No.")
                {
                    //SourceExpr="Cust. Ledger Entry"."QuoSII Ship No.";
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
                Column(SIIEntity_CustLedgerEntry; "Cust. Ledger Entry"."QuoSII Entity")
                {
                    //SourceExpr="Cust. Ledger Entry"."QuoSII Entity";
                }
                DataItem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {

                    ;
                    Column(VendEntryNo; "Vendor Ledger Entry"."Entry No.")
                    {
                        //SourceExpr="Vendor Ledger Entry"."Entry No.";
                    }
                    Column(VendNo; "Vendor Ledger Entry"."Vendor No.")
                    {
                        //SourceExpr="Vendor Ledger Entry"."Vendor No.";
                    }
                    Column(VendName; Vendor.Name)
                    {
                        //SourceExpr=Vendor.Name;
                    }
                    Column(VendPostingDate; "Vendor Ledger Entry"."Posting Date")
                    {
                        //SourceExpr="Vendor Ledger Entry"."Posting Date";
                    }
                    Column(VendDocNo; "Vendor Ledger Entry"."External Document No.")
                    {
                        //SourceExpr="Vendor Ledger Entry"."External Document No.";
                    }
                    Column(VendShipped; Shipped)
                    {
                        //SourceExpr=Shipped;
                    }
                    Column(VendInvoiceType; "Vendor Ledger Entry"."QuoSII Purch. Invoice Type")
                    {
                        //SourceExpr="Vendor Ledger Entry"."QuoSII Purch. Invoice Type";
                    }
                    Column(VendCorrectedInvoiceType; "Vendor Ledger Entry"."QuoSII Purch. Corr. Inv. Type")
                    {
                        //SourceExpr="Vendor Ledger Entry"."QuoSII Purch. Corr. Inv. Type";
                    }
                    Column(VendBaseAmount; BaseAmount)
                    {
                        //SourceExpr=BaseAmount;
                    }
                    Column(VendVATAmount; VATAmount)
                    {
                        //SourceExpr=VATAmount;
                    }
                    Column(VendBaseVATAmount; BaseVATAmount)
                    {
                        //SourceExpr=BaseVATAmount;
                    }
                    Column(VendShipNo; "Vendor Ledger Entry"."QuoSII Ship No.")
                    {
                        //SourceExpr="Vendor Ledger Entry"."QuoSII Ship No.";
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
                    Column(SIIEntity_VendorLedgerEntry; "Vendor Ledger Entry"."QuoSII Entity")
                    {
                        //SourceExpr="Vendor Ledger Entry"."QuoSII Entity" ;
                    }
                    trigger OnPreDataItem();
                    VAR
                        //                                VendorLedgerEntryAux@1100286000 :
                        VendorLedgerEntryAux: Record 25;
                    BEGIN

                        //Si no se encuentran movimientos de factura, filtrar por abonos.
                        //{
                        //                               VendorLedgerEntryAux.RESET;
                        //                               VendorLedgerEntryAux.SETFILTER("Posting Date", Period);
                        //                               VendorLedgerEntryAux.SETRANGE("Document Type", VendorLedgerEntryAux."Document Type"::Invoice);
                        //                               VendorLedgerEntryAux.SETRANGE("Bill No.", '');
                        //                               IF VendorLedgerEntryAux.FINDFIRST THEN BEGIN 
                        //                                 "Vendor Ledger Entry".SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type"::Invoice);
                        //                               END ELSE BEGIN 
                        //                                 "Vendor Ledger Entry".SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type"::"Credit Memo");
                        //                               END;
                        //                               }
                        "Vendor Ledger Entry".SETFILTER("Posting Date", Period);
                        //Filtro para que no coja los efectos"
                        "Vendor Ledger Entry".SETRANGE("Bill No.", '');
                        //QuoSII_1.4.02.042.begin 
                        IF SIIEntity <> SIIEntity::" " THEN
                            "Vendor Ledger Entry".SETRANGE("QuoSII Entity", FORMAT(SIIEntity - 1));
                        //QuoSII_1.4.02.042.end
                        "Vendor Ledger Entry".SETFILTER("Document Type", '%1|%2', "Vendor Ledger Entry"."Document Type"::Invoice, "Vendor Ledger Entry"."Document Type"::"Credit Memo");
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        Vendor.GET("Vendor Ledger Entry"."Vendor No.");
                        //Si se selecciona tipo de SII en el grupo registro, se comprueba que el cliente/proveedor pertenezca a ese tipo.
                        IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                            IF NOT VendorPostingGroup.GET(Vendor."Vendor Posting Group") THEN BEGIN
                                CurrReport.SKIP;
                            END ELSE IF VendorPostingGroup."QuoSII Type" <> PostingGroupSIIType THEN BEGIN
                                CurrReport.SKIP;
                            END;
                        END;

                        //QuoSII1.4.begin 
                        SIIDocuments.RESET;
                        SIIDocuments.SETFILTER("Document Type", '%1|%2|%3', SIIDocuments."Document Type"::FR, SIIDocuments."Document Type"::PR, SIIDocuments."Document Type"::OI);
                        SIIDocuments.SETRANGE("Entry No.", "Vendor Ledger Entry"."Entry No.");
                        IF SIIDocuments.FINDFIRST THEN BEGIN
                            Descuadrebase_VLE := SIIDocuments."Base Imbalance";
                            DescuadrebaseISP_VLE := SIIDocuments."ISP Base Imbalance";
                            Descuadrecuota_VLE := SIIDocuments."Imbalance Fee";
                            DescuadrecuotaRE_VLE := SIIDocuments."Imbalance RE Fee";
                            Descuadreimporte_VLE := SIIDocuments."Imbalance Amount";
                            Estadocuadre_VLE := FORMAT(SIIDocuments."Tally Status");
                        END;
                        //QuoSII1.4.end

                        //Comprobamos si esta o no enviado
                        Shipped := NoLbl;


                        SIIDocumentShipmentLine.RESET;
                        SIIDocumentShipmentLine.SETRANGE("Entry No.", "Vendor Ledger Entry"."Entry No.");
                        SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);
                        IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                            //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                            IF OnlyNotShipped THEN BEGIN
                                CurrReport.SKIP
                            END;
                            Shipped := YesLbl;
                        END;


                        //Se calcula la base y el IVA de cada factura
                        BaseAmount := 0;
                        VATAmount := 0;

                        //IF Breakdown THEN BEGIN 

                        VATEntry.RESET;
                        VATEntry.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");
                        VATEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                        IF VATEntry.FINDSET THEN BEGIN
                            REPEAT
                                BaseAmount += VATEntry.Base;
                                VATAmount += VATEntry.Amount;
                            UNTIL VATEntry.NEXT = 0;
                        END ELSE BEGIN
                            //Si es No sujeta no tiene movs de IVA
                            "Vendor Ledger Entry".CALCFIELDS("Amount (LCY)");
                            BaseAmount := -"Vendor Ledger Entry"."Amount (LCY)";
                        END;

                        BaseVATAmount := BaseAmount + VATAmount;

                        TotalBase += BaseAmount;
                        TotalVat += VATAmount;

                        //END;
                    END;


                }
                trigger OnPreDataItem();
                VAR
                    //                                CustLedgerEntryAux@1100286000 :
                    CustLedgerEntryAux: Record 21;
                BEGIN

                    //Si no se encuentran movimientos de factura, filtrar por abonos.
                    //{
                    //                               CustLedgerEntryAux.RESET;
                    //                               CustLedgerEntryAux.SETFILTER("Posting Date", Period);
                    //                               CustLedgerEntryAux.SETRANGE("Document Type", CustLedgerEntryAux."Document Type"::Invoice);
                    //                               CustLedgerEntryAux.SETRANGE("Bill No.", '');
                    //
                    //                               IF CustLedgerEntryAux.FINDFIRST THEN BEGIN 
                    //                                 "Cust. Ledger Entry".SETRANGE("Document Type", "Cust. Ledger Entry"."Document Type"::Invoice);
                    //                               END ELSE BEGIN 
                    //                                 "Cust. Ledger Entry".SETRANGE("Document Type", "Cust. Ledger Entry"."Document Type"::"Credit Memo");
                    //                               END;
                    //                               }

                    "Cust. Ledger Entry".SETFILTER("Posting Date", Period);
                    //Filtro para que no coja los efectos"
                    "Cust. Ledger Entry".SETRANGE("Bill No.", '');
                    //QuoSII_1.4.02.042.begin 
                    IF SIIEntity <> SIIEntity::" " THEN
                        "Cust. Ledger Entry".SETRANGE("QuoSII Entity", FORMAT(SIIEntity - 1));
                    //QuoSII_1.4.02.042.end
                    "Cust. Ledger Entry".SETFILTER("Document Type", '%1|%2', "Cust. Ledger Entry"."Document Type"::Invoice, "Cust. Ledger Entry"."Document Type"::"Credit Memo");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Customer.GET("Cust. Ledger Entry"."Customer No.");
                    //Si se selecciona tipo de SII en el grupo registro, se comprueba que el cliente/proveedor pertenezca a ese tipo.
                    IF PostingGroupSIIType <> PostingGroupSIIType::" " THEN BEGIN
                        IF NOT CustomerPostingGroup.GET(Customer."Customer Posting Group") THEN BEGIN
                            CurrReport.SKIP;
                        END ELSE IF CustomerPostingGroup."QuoSII Type" <> PostingGroupSIIType THEN BEGIN
                            CurrReport.SKIP;
                        END;
                    END;

                    //Comprobamos si esta o no enviado
                    Shipped := NoLbl;

                    SIIDocumentShipmentLine.RESET;
                    SIIDocumentShipmentLine.SETRANGE("Entry No.", "Cust. Ledger Entry"."Entry No.");
                    SIIDocumentShipmentLine.SETRANGE(Status, SIIDocumentShipmentLine.Status::Enviada);
                    IF SIIDocumentShipmentLine.FINDFIRST THEN BEGIN
                        //Si esta marcado OnlyNotShipped y esta enviado, saltamos al siguiente registro
                        IF OnlyNotShipped THEN BEGIN
                            CurrReport.SKIP
                        END;
                        Shipped := YesLbl;
                    END;

                    //QuoSII1.4.begin 
                    SIIDocuments.RESET;
                    SIIDocuments.SETFILTER("Document Type", '%1|%2|%3', SIIDocuments."Document Type"::FE, SIIDocuments."Document Type"::CE, SIIDocuments."Document Type"::OI);
                    SIIDocuments.SETRANGE("Entry No.", "Cust. Ledger Entry"."Entry No.");
                    IF SIIDocuments.FINDFIRST THEN BEGIN
                        Descuadrebase_CLE := SIIDocuments."Base Imbalance";
                        DescuadrebaseISP_CLE := SIIDocuments."ISP Base Imbalance";
                        Descuadrecuota_CLE := SIIDocuments."Imbalance Fee";
                        DescuadrecuotaRE_CLE := SIIDocuments."Imbalance RE Fee";
                        Descuadreimporte_CLE := SIIDocuments."Imbalance Amount";
                        Estadocuadre_CLE := FORMAT(SIIDocuments."Tally Status");
                    END;
                    //QuoSII1.4.end

                    //Se calcula la base y el IVA de cada factura
                    BaseAmount := 0;
                    VATAmount := 0;

                    //IF Breakdown THEN BEGIN 

                    VATEntry.RESET;
                    VATEntry.SETRANGE("Posting Date", "Cust. Ledger Entry"."Posting Date");
                    VATEntry.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
                    VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                    IF VATEntry.FINDSET THEN BEGIN
                        REPEAT
                            BaseAmount += VATEntry.Base;
                            VATAmount += VATEntry.Amount;
                        UNTIL VATEntry.NEXT = 0;
                    END ELSE BEGIN
                        //Si es No sujeta no tiene movs de IVA
                        "Cust. Ledger Entry".CALCFIELDS("Amount (LCY)");
                        BaseAmount := -"Cust. Ledger Entry"."Amount (LCY)";
                    END;

                    BaseVATAmount := BaseAmount + VATAmount;

                    TotalBase += BaseAmount;
                    TotalVat += VATAmount;

                    //END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                //Creamos un texto con los filtros para mostrarlos en el informe.
                Filters := '';
                IF Period <> '' THEN
                    Filters += PeriodLbl + ': ' + Period;

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
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("Options")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("Period"; "Period")
                    {

                        CaptionML = ENU = 'Period', ESP = 'Periodo';

                        ; trigger OnValidate()
                        BEGIN
                            //AppMgt.MakeDateFilter(Period);
                        END;


                    }
                    field("PostingGroupSIIType"; "PostingGroupSIIType")
                    {

                        CaptionML = ENU = 'Posting Group SII Type', ESP = 'Tipo libro';
                        //OptionCaptionML=ENU='Posting Group SII Type',ESP='Tipo libro';
                    }
                    field("Breakdown"; "Breakdown")
                    {

                        CaptionML = ENU = 'Breakdown', ESP = 'Desglose';
                    }
                    field("OnlyNotShipped"; "OnlyNotShipped")
                    {

                        CaptionML = ENU = 'Show Only Not Shipped', ESP = 'Mostrar solo no enviados';
                    }
                    field("SIIEntity"; "SIIEntity")
                    {

                        CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
                    }

                }

            }
        }
    }
    labels
    {
        EstadocuadreLbl = 'Estado cuadre/';
        DescuadrebaseLbl = 'Descuadre Base/';
        DescuadrebaseISPLbl = 'Descuadre Base ISP/';
        DescuadrecuotaLbl = 'Descuadre Cuota/';
        DescuadrecuotaRELbl = 'Desuadre Cuota RE/';
        DescuadreimporteLbl = 'Descuadre Importe/';
        SIIEntityLbl = 'SII Entity/ Entidad SII/';
    }

    var
        //       SIIType@1100286009 :
        SIIType: Record 7174331;
        //       SIIDocumentShipmentLine@1100286008 :
        SIIDocumentShipmentLine: Record 7174336;
        //       VATEntry@1100286003 :
        VATEntry: Record 254;
        //       Customer@1100286006 :
        Customer: Record 18;
        //       Vendor@1100286007 :
        Vendor: Record 23;
        //       CustomerPostingGroup@1000000003 :
        CustomerPostingGroup: Record 92;
        //       VendorPostingGroup@1000000004 :
        VendorPostingGroup: Record 93;
        //       Filters@1000000005 :
        Filters: Text;
        //       Shipped@1100286010 :
        Shipped: Text;
        //       Period@1100286000 :
        Period: Text;
        //       Breakdown@1100286002 :
        Breakdown: Boolean;
        //       BaseAmount@1100286004 :
        BaseAmount: Decimal;
        //       VATAmount@1100286005 :
        VATAmount: Decimal;
        //       YesLbl@1000000000 :
        YesLbl: TextConst ENU = 'Yes', ESP = 'Si';
        //       NoLbl@1000000001 :
        NoLbl: TextConst ENU = 'No', ESP = 'No';
        //       BaseVATAmount@1000000023 :
        BaseVATAmount: Decimal;
        //       PostingGroupSIIType@1000000002 :
        PostingGroupSIIType: Option " ","LF","OI","OS","BI";
        //       PeriodLbl@1000000006 :
        PeriodLbl: TextConst ENU = 'Period', ESP = 'Periodo';
        //       PostingGrupSIITypeLbl@1000000007 :
        PostingGrupSIITypeLbl: TextConst ENU = 'Posting gr. SII', ESP = 'Tipo Libro';
        //       OnlyNotShipped@1000000008 :
        OnlyNotShipped: Boolean;
        //       OnlyNotShippedLbl@1000000009 :
        OnlyNotShippedLbl: TextConst ENU = 'Show only not shipped', ESP = 'Mostrar solo no enviados';
        //       TotalLbl@1000000010 :
        TotalLbl: TextConst ENU = 'Period Total:', ESP = 'Total periodo:';
        //       VATLbl@1000000011 :
        VATLbl: TextConst ENU = 'VAT', ESP = 'IVA';
        //       BaseLbl@1000000012 :
        BaseLbl: TextConst ENU = 'Base', ESP = 'Base';
        //       AmountLbl@1000000024 :
        AmountLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       PostingDateLbl@1000000013 :
        PostingDateLbl: TextConst ENU = 'Posting Date', ESP = 'Fecha registro';
        //       DocNoLbl@1000000014 :
        DocNoLbl: TextConst ENU = 'Documento No.', ESP = 'N§ documento';
        //       ShippedLbl@1000000015 :
        ShippedLbl: TextConst ENU = 'Shipped', ESP = 'Enviado';
        //       InvoiceTypeLbl@1000000016 :
        InvoiceTypeLbl: TextConst ENU = 'Type', ESP = 'Tipo';
        //       CorrectedInvTypeLbl@1000000017 :
        CorrectedInvTypeLbl: TextConst ENU = 'Correcte Type', ESP = 'Tipo rect.';
        //       SalesLbl@1000000018 :
        SalesLbl: TextConst ENU = 'Sales', ESP = 'Ventas';
        //       PurchLbl@1000000019 :
        PurchLbl: TextConst ENU = 'Purchases', ESP = 'Compras';
        //       TotalBase@1000000020 :
        TotalBase: Decimal;
        //       TotalVat@1000000021 :
        TotalVat: Decimal;
        //       Label@1000000022 :
        Label: TextConst ENU = 'Sii Report', ESP = 'Informe SII';
        //       ShipNoLbl@1100286011 :
        ShipNoLbl: TextConst ENU = 'Ship No.', ESP = 'Num. Env¡o';
        //       Estadocuadre_CLE@7174331 :
        Estadocuadre_CLE: Text;
        //       Descuadrebase_CLE@7174332 :
        Descuadrebase_CLE: Decimal;
        //       DescuadrebaseISP_CLE@7174333 :
        DescuadrebaseISP_CLE: Decimal;
        //       Descuadrecuota_CLE@7174334 :
        Descuadrecuota_CLE: Decimal;
        //       DescuadrecuotaRE_CLE@7174335 :
        DescuadrecuotaRE_CLE: Decimal;
        //       Descuadreimporte_CLE@7174336 :
        Descuadreimporte_CLE: Decimal;
        //       Estadocuadre_VLE@7174342 :
        Estadocuadre_VLE: Text;
        //       Descuadrebase_VLE@7174341 :
        Descuadrebase_VLE: Decimal;
        //       DescuadrebaseISP_VLE@7174340 :
        DescuadrebaseISP_VLE: Decimal;
        //       Descuadrecuota_VLE@7174339 :
        Descuadrecuota_VLE: Decimal;
        //       DescuadrecuotaRE_VLE@7174338 :
        DescuadrecuotaRE_VLE: Decimal;
        //       Descuadreimporte_VLE@7174337 :
        Descuadreimporte_VLE: Decimal;
        //       SIIDocuments@7174343 :
        SIIDocuments: Record 7174333;
        //       SIIEntity@7174344 :
        SIIEntity: Option " ","AEAT","ATCN";

    /*begin
    {
      QuoSII1.4 MCM 02/05/18 - Se incluye la informaci¢n de contraste
      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
    }
    end.
  */

}




