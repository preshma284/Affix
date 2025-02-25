report 7207417 "Invoice origin by vendor 2"
{



    dataset
    {

        DataItem("Job"; "Job")
        {

            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = false;


            RequestFilterFields = "No.";
            Column(Job_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            DataItem("2000000026"; "2000000026")
            {

                DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                PrintOnlyIfDetail = false;
                Column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                    //SourceExpr=FORMAT(TODAY,0,4);
                }
                Column(USERID; USERID)
                {
                    //SourceExpr=USERID;
                }
                Column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                    //SourceExpr=CurrReport.PAGENO;
                }
                Column(FORMAT_Job__No____________Job_Description; FORMAT(Job."No.") + '  ' + Job.Description)
                {
                    //SourceExpr=FORMAT(Job."No.") + '  ' +Job.Description;
                }
                Column(TextJob____; TextJob + ':')
                {
                    //SourceExpr=TextJob+':';
                }
                Column(Periodo___; 'Periodo :')
                {
                    //SourceExpr='Per¡odo :';
                }
                Column(FilterPeriod; FilterPeriod)
                {
                    //SourceExpr=FilterPeriod;
                }
                Column(TotalAmount; TotalAmount)
                {
                    //SourceExpr=TotalAmount;
                }
                Column(TotalText; TotalText)
                {
                    //SourceExpr=TotalText;
                }
                Column(Job_Description; Job.Description)
                {
                    //SourceExpr=Job.Description;
                }
                Column(Invoice_origin_by_vendorCaption; Invoice_origin_by_vendorCaptionLbl)
                {
                    //SourceExpr=Invoice_origin_by_vendorCaptionLbl;
                }
                Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                    //SourceExpr=CurrReport_PAGENOCaptionLbl;
                }
                Column(AmountCaption; AmountCaptionLbl)
                {
                    //SourceExpr=AmountCaptionLbl;
                }
                Column(N__documentCaption; N__documentCaptionLbl)
                {
                    //SourceExpr=N__documentCaptionLbl;
                }
                Column(Registry_DateCaption; RegistryDateCaptionLbl)
                {
                    //SourceExpr=RegistryDateCaptionLbl;
                }
                Column(VendorCaption; VendorCaptionLbl)
                {
                    //SourceExpr=VendorCaptionLbl;
                }
                Column(Purch__Inv__Header__Due_Date_Caption; "Purch. Inv. Header".FIELDCAPTION("Due Date"))
                {
                    //SourceExpr="Purch. Inv. Header".FIELDCAPTION("Due Date");
                }
                Column(No_Doc_VendorCaption; N__Doc_VendorCaptionLbl)
                {
                    //SourceExpr=N__Doc_VendorCaptionLbl;
                }
                Column(Integer_Number; Number)
                {
                    //SourceExpr=Number;
                }
                DataItem("Proveedor"; "Vendor")
                {

                    DataItemTableView = SORTING("No.");
                    PrintOnlyIfDetail = true;


                    RequestFilterFields = "No.";
                    Column(FORMAT__No____________Name; FORMAT("No.") + '  ' + Name)
                    {
                        //SourceExpr=FORMAT("No.") + '  ' +Name;
                    }
                    Column(TotalAmountVendor; TotalAmountVendor)
                    {
                        //SourceExpr=TotalAmountVendor;
                    }
                    Column(Total_Vendor_Caption; Total_Vendor_CaptionLbl)
                    {
                        //SourceExpr=Total_Vendor_CaptionLbl;
                    }
                    Column(Proveedor_No_; "No.")
                    {
                        //SourceExpr="No.";
                    }
                    DataItem("Purch. Inv. Header"; "Purch. Inv. Header")
                    {

                        DataItemTableView = SORTING("Buy-from Vendor No.", "Shortcut Dimension 1 Code");


                        DataItemLinkReference = "Proveedor";
                        DataItemLink = "Buy-from Vendor No." = FIELD("No.");
                        Column(DocumentType; DocumentType)
                        {
                            //SourceExpr=DocumentType;
                        }
                        Column(No; "No.")
                        {
                            IncludeCaption = true;
                            //SourceExpr="No.";
                        }
                        Column(Posting_Date; "Posting Date")
                        {
                            IncludeCaption = true;
                            //SourceExpr="Posting Date";
                        }
                        Column(AmountPInvHeader; "Purch. Inv. Header".Amount)
                        {
                            IncludeCaption = true;
                            //SourceExpr="Purch. Inv. Header".Amount;
                        }
                        Column(Due_Date; "Due Date")
                        {
                            IncludeCaption = true;
                            //SourceExpr="Due Date";
                        }
                        Column(Vendor_Invoice_No; "Vendor Invoice No.")
                        {
                            IncludeCaption = true;
                            //SourceExpr="Vendor Invoice No.";
                        }
                        Column(InvoicesCaption; InvoicesCaptionLbl)
                        {
                            //SourceExpr=InvoicesCaptionLbl;
                        }
                        Column(Buy_from_Vendor_No; "Buy-from Vendor No.")
                        {
                            IncludeCaption = true;
                            //SourceExpr="Buy-from Vendor No.";
                        }
                        //D3 Triggers
                        trigger OnPreDataItem();
                        BEGIN
                            SETFILTER("Shortcut Dimension 1 Code", '%1', Job."Global Dimension 1 Code");
                            SETFILTER("Job No.", Job."No.");
                            DocumentType := Text0007;
                            IF boolFilter THEN
                                SETFILTER("Posting Date", '%1..%2', DateStart, DateEnd);
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            CALCFIELDS(Amount);
                        END;
                    }
                    DataItem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
                    {

                        DataItemTableView = SORTING("Buy-from Vendor No.", "Shortcut Dimension 1 Code");


                        DataItemLinkReference = "Proveedor";
                        DataItemLink = "Buy-from Vendor No." = FIELD("No.");
                        Column(TipoDocumentoAbono; DocumentType)
                        {
                            //SourceExpr=DocumentType;
                        }
                        Column(Purch__Cr__Memo_Hdr___No__; "No.")
                        {
                            //SourceExpr="No.";
                        }
                        Column(Purch__Cr__Memo_Hdr___Posting_Date_; "Posting Date")
                        {
                            //SourceExpr="Posting Date";
                        }
                        Column(Purch__Cr__Memo_Hdr_Amount; -Amount)
                        {
                            //SourceExpr=-Amount;
                        }
                        Column(Purch__Cr__Memo_Hdr___Due_Date_; "Due Date")
                        {
                            //SourceExpr="Due Date";
                        }
                        Column(Purch__Cr__Memo_Hdr___Vendor_Cr__Memo_No__; "Vendor Cr. Memo No.")
                        {
                            //SourceExpr="Vendor Cr. Memo No.";
                        }
                        Column(PaymentsCaption; PaymentsCaptionLbl)
                        {
                            //SourceExpr=PaymentsCaptionLbl;
                        }
                        Column(Purch__Cr__Memo_Hdr__Buy_from_Vendor_No_; "Buy-from Vendor No.")
                        {
                            //SourceExpr="Buy-from Vendor No.";
                        }
                        //D4 Triggers
                        trigger OnPreDataItem();
                        BEGIN
                            SETFILTER("Shortcut Dimension 1 Code", '%1', Job."Global Dimension 1 Code");
                            SETFILTER("Job No.", Job."No.");
                            DocumentType := Text0008;
                            IF boolFilter THEN
                                SETFILTER("Posting Date", '%1..%2', DateStart, DateEnd);
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            CALCFIELDS(Amount);
                        END;
                    }

                    DataItem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
                    {

                        DataItemTableView = SORTING("Buy-from Vendor No.", "Shortcut Dimension 1 Code");


                        DataItemLinkReference = "Proveedor";
                        DataItemLink = "Buy-from Vendor No." = FIELD("No.");
                        Column(DocumentTypeAlbaran; DocumentType)
                        {
                            //SourceExpr=DocumentType;
                        }
                        Column(ShipmentsCaption; ShipmentsCaptionLbl)
                        {
                            //SourceExpr=ShipmentsCaptionLbl;
                        }
                        Column(Purch__Rcpt__Header_No_; "No.")
                        {
                            //SourceExpr="No.";
                        }
                        Column(Purch__Rcpt__Header_Buy_from_Vendor_No_; "Buy-from Vendor No.")
                        {
                            //SourceExpr="Buy-from Vendor No.";
                        }
                        DataItem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                        {

                            DataItemTableView = SORTING("Document No.", "Line No.");
                            DataItemLink = "Document No." = FIELD("No.");
                            Column(Purch__Rcpt__Header___Posting_Date_; "Purch. Rcpt. Header"."Posting Date")
                            {
                                //SourceExpr="Purch. Rcpt. Header"."Posting Date";
                            }
                            Column(AmoShip; AmoShip)
                            {
                                //SourceExpr=AmoShip;
                            }
                            Column(Purch__Rcpt__Line__Document_No__; "Document No.")
                            {
                                //SourceExpr="Document No.";
                            }
                            Column(Purch__Rcpt__Header___Due_Date_; "Purch. Rcpt. Header"."Due Date")
                            {
                                //SourceExpr="Purch. Rcpt. Header"."Due Date";
                            }
                            Column(Purch__Rcpt__Header___Vendor_Shipment_No__; "Purch. Rcpt. Header"."Vendor Shipment No.")
                            {
                                //SourceExpr="Purch. Rcpt. Header"."Vendor Shipment No.";
                            }
                            Column(Purch__Rcpt__Line_Line_No_; "Line No.")
                            {
                                //SourceExpr="Line No.";
                            }
                            Column(CompanyName_p; COMPANYNAME)
                            {
                                //SourceExpr=COMPANYNAME ;
                            }
                            //D6 triggers
                            trigger OnAfterGetRecord();
                            BEGIN
                                AmoShip := AmoShip + (Quantity - "Quantity Invoiced") * "Direct Unit Cost";
                            END;


                        }
                        //D5 Triggers
                        trigger OnPreDataItem();
                        BEGIN
                            SETFILTER("Shortcut Dimension 1 Code", '%1', Job."Global Dimension 1 Code");
                            SETFILTER("Job No.", Job."No.");
                            DocumentType := Text0009;
                            IF boolFilter THEN
                                SETFILTER("Posting Date", '%1..%2', DateStart, DateEnd);
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            AmoShip := 0;
                        END;


                    }
                    //D2 Triggers
                    trigger OnAfterGetRecord();
                    BEGIN
                        FirstInv := TRUE;
                        FirstShip := TRUE;
                        FirstPay := TRUE;
                        TotalAmountVendor := 0;
                    END;



                }
                //D1 Triggers
            }
            //Jb Triggers
            trigger OnPreDataItem();
            BEGIN

                FilterPeriod := Job.GETFILTER(Job."Posting Date Filter");

                IF FilterPeriod <> '' THEN BEGIN
                    boolFilter := TRUE;
                    DateStart := GETRANGEMIN("Posting Date Filter");
                    DateEnd := GETRANGEMAX("Posting Date Filter");
                END ELSE BEGIN
                    boolFilter := FALSE;
                    FilterPeriod := Text0002;
                END;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF "Matrix Job it Belongs" <> '' THEN
                    TextJob := Text0003
                ELSE
                    TextJob := Text0004;
                IF TextJob = Text0004 THEN
                    TotalText := Text0005
                ELSE
                    TotalText := Text0006;
                TotalAmount := 0;
            END;


        }
    }

    requestpage
    {

        layout
        {
        }
    }
    labels
    {
        lblVendor = 'Vendor/ Proveedor/';
        lblNDocument = 'N§ Document/ N§ documento/';
        lblNVendorDocument = '"N§ Vendor Doc "/ N§ Doc Proveedor/';
        lblRegistryDate = 'Registry Date/ Fecha de registro/';
        lblDueDate = 'Due Date/ Fecha vencimiento/';
        lblAmount = 'Amount/ Importe/';
    }

    var
        //       Text0001@7001111 :
        Text0001: TextConst ENU = 'You must specify a date range in the Date Filter field', ESP = 'Debe especificar un rango de fecha en el campo Filtro Fecha';
        //       Invoice_origin_by_vendorCaptionLbl@7001110 :
        Invoice_origin_by_vendorCaptionLbl: TextConst ENU = 'Invoice origin by vendor', ESP = 'Facturaci¢n origen por proveedor';
        //       CurrReport_PAGENOCaptionLbl@7001109 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P g.';
        //       AmountCaptionLbl@7001108 :
        AmountCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       N__documentCaptionLbl@7001107 :
        N__documentCaptionLbl: TextConst ENU = 'N§ Document', ESP = 'N§ documento';
        //       RegistryDateCaptionLbl@7001106 :
        RegistryDateCaptionLbl: TextConst ENU = 'Registry Date', ESP = 'Fecha de registro';
        //       VendorCaptionLbl@7001105 :
        VendorCaptionLbl: TextConst ENU = 'Vendor', ESP = 'Proveedor';
        //       N__Doc_VendorCaptionLbl@7001104 :
        N__Doc_VendorCaptionLbl: TextConst ENU = 'No Doc Vendor', ESP = 'N§ Doc Proveedor';
        //       Total_Vendor_CaptionLbl@7001103 :
        Total_Vendor_CaptionLbl: TextConst ENU = 'Vendor Total', ESP = '"Total Proveedor "';
        //       InvoicesCaptionLbl@7001102 :
        InvoicesCaptionLbl: TextConst ENU = 'Invoices', ESP = 'Facturas';
        //       PaymentsCaptionLbl@7001101 :
        PaymentsCaptionLbl: TextConst ENU = 'Payments', ESP = 'Abonos';
        //       ShipmentsCaptionLbl@7001100 :
        ShipmentsCaptionLbl: TextConst ENU = 'Shipments', ESP = 'Albaranes';
        //       DateStart@7001127 :
        DateStart: Date;
        //       DateEnd@7001126 :
        DateEnd: Date;
        //       TextJob@7001125 :
        TextJob: Text[30];
        //       TotalText@7001124 :
        TotalText: Text[30];
        //       FilterPeriod@7001123 :
        FilterPeriod: Text[30];
        //       CompanyInformation@7001122 :
        CompanyInformation: Record 79;
        //       AmoInv@7001121 :
        AmoInv: Decimal;
        //       AmoPay@7001120 :
        AmoPay: Decimal;
        //       AmoShip@7001119 :
        AmoShip: Decimal;
        //       FirstInv@7001118 :
        FirstInv: Boolean;
        //       FirstPay@7001117 :
        FirstPay: Boolean;
        //       FirstShip@7001116 :
        FirstShip: Boolean;
        //       boolFilter@7001115 :
        boolFilter: Boolean;
        //       TotalAmount@7001114 :
        TotalAmount: Decimal;
        //       TotalAmountVendor@7001113 :
        TotalAmountVendor: Decimal;
        //       DocumentType@7001112 :
        DocumentType: Text;
        //       Text0002@7001128 :
        Text0002: TextConst ESP = 'A ORIGEN';
        //       Text0003@7001129 :
        Text0003: TextConst ESP = 'Expediente';
        //       Text0004@7001130 :
        Text0004: TextConst ESP = 'Obra';
        //       Text0005@7001131 :
        Text0005: TextConst ESP = 'Total obra';
        //       Text0006@7001132 :
        Text0006: TextConst ESP = 'Total Expediente';
        //       Text0007@7001133 :
        Text0007: TextConst ESP = 'Factura';
        //       Text0008@7001134 :
        Text0008: TextConst ESP = 'Abono';
        //       Text0009@7001135 :
        Text0009: TextConst ESP = 'Albaran';



    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;



    /*begin
        end.
      */

}



// RequestFilterFields="No.";
