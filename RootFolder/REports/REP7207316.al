report 7207316 "Outstanding Shipments Detail"
{


    CaptionML = ENU = 'Outstanding Shipments Detail', ESP = 'Albaranes pendientes detalle';

    dataset
    {

        DataItem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {

            DataItemTableView = SORTING("Shortcut Dimension 1 Code");
            RequestFilterHeadingML = ESP = 'Hist¢rico albaranes compra';


            RequestFilterFields = "Job No.", "Shortcut Dimension 1 Code", "Buy-from Vendor No.";
            Column(Amount; Amount)
            {
                //SourceExpr=Amount;
            }
            Column(TOTAL_FRI_S_OUTSTANDINGCaption; TOTAL_FRI_S_OUTSTANDINGCaption)
            {
                //SourceExpr=TOTAL_FRI_S_OUTSTANDINGCaption;
            }
            Column(Purch__Rcpt__Header_No_; "No.")
            {
                //SourceExpr="No.";
            }
            Column(NameJob; NameJob)
            {
                //SourceExpr=NameJob;
            }
            Column(USERID; USERID)
            {
                //SourceExpr=USERID;
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            DataItem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {

                DataItemTableView = SORTING("Document No.", "Line No.")
                                 WHERE("Quantity" = FILTER(<> 0));


                CalcFields =;
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemLink = "Document No." = FIELD("No.");
                Column(STRSUBSTNO__Compras___Albaran__1__TextCopy_; STRSUBSTNO('Compras - Albar n %1', TextCopy))
                {
                    //SourceExpr=STRSUBSTNO('Compras - Albar n %1',TextCopy);
                }
                Column(STRSUBSTNO__Pag___1__FORMAT_CurrReport_PAGENO__; STRSUBSTNO('P g. %1', FORMAT(CurrReport.PAGENO)))
                {
                    //SourceExpr=STRSUBSTNO('P g. %1',FORMAT(CurrReport.PAGENO));
                }
                Column(FORMAT__Purch__Rcpt__Header___Document_Date__0_4_; FORMAT("Purch. Rcpt. Header"."Document Date", 0, 4))
                {
                    //SourceExpr=FORMAT("Purch. Rcpt. Header"."Document Date",0,4);
                }
                Column(Vendor_Name; 'Nombre Proveedor')
                {
                    //SourceExpr='Nombre Proveedor';
                }
                Column(Purch__Rcpt__Header___Pay_to_Vendor_No________Purch__Rcpt__Header___Pay_to_Name_; "Purch. Rcpt. Header"."Pay-to Vendor No." + '-' + "Purch. Rcpt. Header"."Pay-to Name")
                {
                    //SourceExpr="Purch. Rcpt. Header"."Pay-to Vendor No."+'-'+"Purch. Rcpt. Header"."Pay-to Name";
                }
                Column(Purch__Rcpt__Header___No__; "Purch. Rcpt. Header"."No.")
                {
                    //SourceExpr="Purch. Rcpt. Header"."No.";
                }
                Column(DescriRefer; DescriRefer)
                {
                    //SourceExpr=DescriRefer;
                }
                Column(Purch__Rcpt__Header___Your_Reference_; "Purch. Rcpt. Header"."Your Reference")
                {
                    //SourceExpr="Purch. Rcpt. Header"."Your Reference";
                }
                Column(Purch__Rcpt__Header___Shortcut_Dimension_1_Code_; "Purch. Rcpt. Header"."Shortcut Dimension 1 Code")
                {
                    //SourceExpr="Purch. Rcpt. Header"."Shortcut Dimension 1 Code";
                }
                Column(Purch__Rcpt__Line_Description; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Purch__Rcpt__Line_Description_Control38; Description)
                {
                    //SourceExpr=Description;
                }
                Column(Purch__Rcpt__Line_Quantity; Quantity)
                {
                    //SourceExpr=Quantity;
                }
                Column(Purch__Rcpt__Line__Unit_of_Measure_; "Unit of Measure")
                {
                    //SourceExpr="Unit of Measure";
                }
                Column(Purch__Rcpt__Line__Cod__Unity_of_work_;
                "Purch. Rcpt. Line"."Piecework NÂº")
                {
                    //SourceExpr="Purch. Rcpt. Line"."Piecework N§";
                }
                Column(Purch__Rcpt__Line__Purch__Rcpt__Line___Shortcut_Dimension_2_Code_; "Purch. Rcpt. Line"."Shortcut Dimension 2 Code")
                {
                    //SourceExpr="Purch. Rcpt. Line"."Shortcut Dimension 2 Code";
                }
                Column(Amount_Control1100251021; Amount)
                {
                    //SourceExpr=Amount;
                }
                Column(Purch__Rcpt__Line__Unit_Cost_; "Unit Cost")
                {
                    //SourceExpr="Unit Cost";
                }
                Column(QuantityOuts; QuantityOuts)
                {
                    //SourceExpr=QuantityOuts;
                }
                Column(Purch__Rcpt__Line__Quantity_Invoiced_; "Quantity Invoiced")
                {
                    //SourceExpr="Quantity Invoiced";
                }
                Column(Purch__Rcpt__Line__No__; "No.")
                {
                    //SourceExpr="No.";
                }
                Column(Purch__Rcpt__Line_Description_Control42; Description)
                {
                    //SourceExpr=Description;
                }
                Column(PurchRcptLine_Description2; PurchRcptLine."Description 2")
                {
                    //SourceExpr=PurchRcptLine."Description 2";
                }
                Column(Purch__Rcpt__Line_Quantity_Control43; Quantity)
                {
                    //SourceExpr=Quantity;
                }
                Column(Purch__Rcpt__Line__Unit_of_Measure__Control44; "Unit of Measure")
                {
                    //SourceExpr="Unit of Measure";
                }
                Column(Purch__Rcpt__Line_Type; Type)
                {
                    //SourceExpr=Type;
                }
                Column(Purch__Rcpt__Line__Purch__Rcpt__Line___Shortcut_Dimension_2_Code__Control1100251002; "Purch. Rcpt. Line"."Shortcut Dimension 2 Code")
                {
                    //SourceExpr="Purch. Rcpt. Line"."Shortcut Dimension 2 Code";
                }
                Column(Purch__Rcpt__Line__Quantity_Invoiced__Control1100251004; "Quantity Invoiced")
                {
                    //SourceExpr="Quantity Invoiced";
                }
                Column(Purch__Rcpt__Line__Unit_Cost__Control1100251006; "Unit Cost")
                {
                    //SourceExpr="Unit Cost";
                }
                Column(Purch__Rcpt__Line__Purch__Rcpt__Line___Pieceworkno; "Purch. Rcpt. Line"."Piecework NÂº")
                {
                    //SourceExpr="Purch. Rcpt. Line"."Piecework N§";
                }
                Column(Amount_Control1100251011; Amount)
                {
                    //SourceExpr=Amount;
                }
                Column(QuantityOuts_Control1100251013; QuantityOuts)
                {
                    //SourceExpr=QuantityOuts;
                }
                Column(Amount_Control1100251016; Amount)
                {
                    //SourceExpr=Amount;
                }
                Column(Purch__Rcpt__Header___No__Caption; Purch__Rcpt__Header___No__Caption)
                {
                    //SourceExpr=Purch__Rcpt__Header___No__Caption;
                }
                Column(N_Caption; N_Caption)
                {
                    //SourceExpr=N_Caption;
                }
                Column(DescriptionCaption; DescriptionCaption)
                {
                    //SourceExpr=DescriptionCaption;
                }
                Column(QuantityCaption; QuantityCaption)
                {
                    //SourceExpr=QuantityCaption;
                }
                Column(Un__MeasureCaption; Un__MeasureCaption)
                {
                    //SourceExpr=Un__MeasureCaption;
                }
                Column(TypeCaption; TypeCaption)
                {
                    //SourceExpr=TypeCaption;
                }
                Column(Quantity_invo_Caption; Quantity_invo_Caption)
                {
                    //SourceExpr=Quantity_invo_Caption;
                }
                Column(Concept_analyticalCaption; Concept_analyticalCaption)
                {
                    //SourceExpr=Concept_analyticalCaption;
                }
                Column(Price_costCaption; Price_costCaption)
                {
                    //SourceExpr=Price_costCaption;
                }
                Column(PieceworkCaption; PieceworkCaption)
                {
                    //SourceExpr=PieceworkCaption;
                }
                Column(AmountCaption; AmountCaption)
                {
                    //SourceExpr=AmountCaption;
                }
                Column(Quantity_Outs_Caption; Quantity_Outs_Caption)
                {
                    //SourceExpr=Quantity_Outs_Caption;
                }
                Column(N__the_WorkCaption; N__the_WorkCaption)
                {
                    //SourceExpr=N__the_WorkCaption;
                }
                Column(TOTAL_FRICaption; TOTAL_FRICaption)
                {
                    //SourceExpr=TOTAL_FRICaption;
                }
                Column(Purch__Rcpt__Line_Document_No_; "Document No.")
                {
                    //SourceExpr="Document No.";
                }
                Column(Purch__Rcpt__Line_Line_No_; "Line No.")
                {
                    //SourceExpr="Line No." ;
                }
                trigger OnPreDataItem();
                BEGIN

                    CurrReport.CREATETOTALS(Amount);
                END;

                trigger OnAfterGetRecord();
                BEGIN

                    QuantityOuts := "Purch. Rcpt. Line".Quantity - "Purch. Rcpt. Line"."Quantity Invoiced";
                    Amount := QuantityOuts * "Purch. Rcpt. Line"."Unit Cost";
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                FormatDire.Company(DirBusiness, CompanyInformation);

                CurrReport.CREATETOTALS(Amount);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF "Purchaser Code" = '' THEN BEGIN
                    SalespersonPurchaser.INIT;
                    DescriComprad := '';
                END ELSE BEGIN
                    SalespersonPurchaser.GET("Purchaser Code");
                    DescriComprad := Text01;
                END;
                IF "Your Reference" = '' THEN
                    DescriRefer := ''
                ELSE
                    DescriRefer := FIELDNAME("Your Reference");
                FormatDire.PurchRcptShipTo(EnvADir, "Purch. Rcpt. Header");

                FormatDire.PurchRcptPayTo(DireProv, "Purch. Rcpt. Header");

                IF Job.GET("Purch. Rcpt. Header"."Job No.") THEN BEGIN
                    NameJob := Job.Description + '' + Job."Description 2";
                END;

                QuantityOutsCheck := 0;
                AmountCheck := 0;
                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("Document No.", "Purch. Rcpt. Header"."No.");
                IF PurchRcptLine.FINDSET(FALSE, FALSE) THEN BEGIN
                    REPEAT
                        QuantityOutsCheck := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
                        AmountCheck += QuantityOutsCheck * PurchRcptLine."Unit Cost";
                    UNTIL PurchRcptLine.NEXT = 0;
                    IF AmountCheck = 0 THEN
                        CurrReport.SKIP;
                END;
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
    }

    var
        //       TOTAL_FRI_S_OUTSTANDINGCaption@7001114 :
        TOTAL_FRI_S_OUTSTANDINGCaption: TextConst ENU = 'TOTAL FRI''S OUTSTANDING', ESP = 'TOTAL FRI''S PENDIENTES';
        //       Purch__Rcpt__Header___No__Caption@7001113 :
        Purch__Rcpt__Header___No__Caption: TextConst ENU = 'N§ Shipment', ESP = 'N§ albar n';
        //       N_Caption@7001112 :
        N_Caption: TextConst ENU = 'N§', ESP = 'N§';
        //       DescriptionCaption@7001111 :
        DescriptionCaption: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       QuantityCaption@7001110 :
        QuantityCaption: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       Un__MeasureCaption@7001109 :
        Un__MeasureCaption: TextConst ENU = 'U. M.', ESP = 'U. M.';
        //       TypeCaption@7001108 :
        TypeCaption: TextConst ENU = 'Type', ESP = 'Tipo';
        //       Quantity_invo_Caption@7001107 :
        Quantity_invo_Caption: TextConst ENU = 'Quantity Invoiced', ESP = 'Cant. fact.';
        //       Concept_analyticalCaption@7001106 :
        Concept_analyticalCaption: TextConst ENU = 'Concept Analytical', ESP = 'C. anal¡t';
        //       Price_costCaption@7001105 :
        Price_costCaption: TextConst ENU = 'Price Cost', ESP = 'Precio coste';
        //       PieceworkCaption@7001104 :
        PieceworkCaption: TextConst ENU = 'Piecework', ESP = 'U.O.';
        //       AmountCaption@7001103 :
        AmountCaption: TextConst ENU = 'Amount', ESP = 'Importe';
        //       Quantity_Outs_Caption@7001102 :
        Quantity_Outs_Caption: TextConst ENU = 'Outstanding Quantity ', ESP = 'Cant. Pend.';
        //       N__the_WorkCaption@7001101 :
        N__the_WorkCaption: TextConst ENU = 'N§ the work', ESP = 'N§ de Obra';
        //       TOTAL_FRICaption@7001100 :
        TOTAL_FRICaption: TextConst ENU = 'TOTAL FRI', ESP = 'TOTAL FRI';
        //       CompanyInformation@7001132 :
        CompanyInformation: Record 79;
        //       SalespersonPurchaser@7001131 :
        SalespersonPurchaser: Record 13;
        //       CountAlbCompPrinted@7001130 :
        CountAlbCompPrinted: Codeunit 318;
        //       DireProv@7001129 :
        DireProv: ARRAY[8] OF Text[50];
        //       EnvADir@7001128 :
        EnvADir: ARRAY[8] OF Text[50];
        //       DirBusiness@7001127 :
        DirBusiness: ARRAY[8] OF Text[50];
        //       DescriComprad@7001126 :
        DescriComprad: Text[30];
        //       DescriRefer@7001125 :
        DescriRefer: Text[30];
        //       MasLins@7001124 :
        MasLins: Boolean;
        //       NoCopy@7001123 :
        NoCopy: Integer;
        //       NoLoops@7001122 :
        NoLoops: Integer;
        //       TextCopy@7001121 :
        TextCopy: Text[30];
        //       FormatDire@7001120 :
        FormatDire: Codeunit 365;
        //       QuantityOuts@7001119 :
        QuantityOuts: Decimal;
        //       Amount@7001118 :
        Amount: Decimal;
        //       PurchRcptLine@7001117 :
        PurchRcptLine: Record 121;
        //       QuantityOutsCheck@7001116 :
        QuantityOutsCheck: Decimal;
        //       AmountCheck@7001115 :
        AmountCheck: Decimal;
        //       Text01@7001133 :
        Text01: TextConst ENU = 'Purchaser', ESP = 'Comprador';
        //       NameJob@7001134 :
        NameJob: Text[100];
        //       Job@7001135 :
        Job: Record 167;

    /*begin
    end.
  */

}



