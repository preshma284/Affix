report 50007 "Proforma Invoice by Resource"
{


    CaptionML = ENU = 'Proforma Invoice', ESP = 'Factura proforma';

    dataset
    {

        DataItem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Posted Purchase Receipt', ESP = 'Hist¢rico albaranes compra';


            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            Column(PurchRcptHeaderNo; "No.")
            {
                //SourceExpr="No.";
            }
            Column(PurchRcptHeaderJobNo; "Job No.")
            {
                //SourceExpr="Job No.";
            }
            Column(LineCount; LineCount)
            {
                //SourceExpr=LineCount;
            }
            Column(NUM_LINES_REPORT; NUM_LINES_REPORT)
            {
                //SourceExpr=NUM_LINES_REPORT;
            }
            Column(NUM_LINES_FOOT; NUM_LINES_FOOT)
            {
                //SourceExpr=NUM_LINES_FOOT;
            }
            Column(PaddingLine; PaddingLine)
            {
                //SourceExpr=PaddingLine;
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
                    Column(CopyText; CopyText)
                    {
                        //SourceExpr=CopyText;
                    }
                    Column(PostingDate; "Purch. Rcpt. Header"."Posting Date")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Posting Date";
                    }
                    Column(BuyfromVendoName; "Purch. Rcpt. Header"."Buy-from Vendor Name" + ' ' + "Purch. Rcpt. Header"."Buy-from Vendor Name 2")
                    {
                        //SourceExpr="Purch. Rcpt. Header"."Buy-from Vendor Name" + ' ' + "Purch. Rcpt. Header"."Buy-from Vendor Name 2";
                    }
                    Column(JobDescription; Job.Description + ' ' + Job."Description 2")
                    {
                        //SourceExpr=Job.Description + ' ' + Job."Description 2";
                    }
                    Column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                        //SourceExpr=PaymentTerms.Description;
                    }
                    Column(PaymentMethodDesc; PaymentMethod.Description)
                    {
                        //SourceExpr=PaymentMethod.Description;
                    }
                    Column(PercentageWithholding; WithholdingGroup."Percentage Withholding")
                    {
                        //SourceExpr=WithholdingGroup."Percentage Withholding";
                    }
                    Column(PageLoop_Number; Number)
                    {
                        //SourceExpr=Number;
                    }
                    Column(CompanyPicture; CompanyInformation.Picture)
                    {
                        //SourceExpr=CompanyInformation.Picture;
                    }
                    Column(NoOfCopies; NoOfCopies)
                    {
                        //SourceExpr=NoOfCopies;
                    }
                    Column(OutputNo; OutputNo)
                    {
                        //SourceExpr=OutputNo;
                    }
                    Column(IndexDoc; DocIndex)
                    {
                        //SourceExpr=DocIndex;
                    }
                    Column(includeLogo; includeLogo)
                    {
                        //SourceExpr=includeLogo;
                    }
                    Column(AmountUO; AmountUO)
                    {
                        //SourceExpr=AmountUO;
                        AutoFormatType = 1;
                    }
                    Column(VATAmount; VATAmount)
                    {
                        //SourceExpr=VATAmount;
                        AutoFormatType = 1;
                    }
                    Column(AmountUOOld; AmountUOOld)
                    {
                        //SourceExpr=AmountUOOld;
                        AutoFormatType = 1;
                    }
                    Column(ByVATApplied; ByVATApplied)
                    {
                        //SourceExpr=ByVATApplied;
                    }
                    Column(WithholdingAmount; WithholdingAmount)
                    {
                        //SourceExpr=WithholdingAmount;
                        AutoFormatType = 1;
                    }
                    DataItem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                    {

                        DataItemTableView = SORTING("Document No.", "Line No.")
                                 WHERE("Quantity" = FILTER(<> 0));


                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemLink = "Document No." = FIELD("No.");
                        Column(LineNo; "Line No.")
                        {
                            //SourceExpr="Line No.";
                        }
                        Column(PieceWorkNo; "Piecework NÂº")
                        {
                            //SourceExpr="Piecework N§";
                        }
                        Column(PieceworkCode; "Purch. Rcpt. Line"."No.")
                        {
                            //SourceExpr="Purch. Rcpt. Line"."No.";
                        }
                        Column(CertifiedQuantity; Quantity)
                        {
                            DecimalPlaces = 2 : 5;
                            //SourceExpr=Quantity;
                        }
                        Column(Percentage; Percentage)
                        {
                            //SourceExpr=Percentage;
                        }
                        Column(UnitOfMeasure; "Unit of Measure")
                        {
                            //SourceExpr="Unit of Measure";
                        }
                        Column(uoDesc; Description + ' ' + "Description 2")
                        {
                            //SourceExpr=Description + ' ' + "Description 2";
                        }
                        Column(uoPrice; "Unit Cost (LCY)")
                        {
                            DecimalPlaces = 0 : 6;
                            //SourceExpr="Unit Cost (LCY)";
                            AutoFormatType = 2;
                        }
                        Column(uoAmount; AmountUO)
                        {
                            //SourceExpr=AmountUO;
                            AutoFormatType = 1;
                        }
                        Column(uoUniqueCode; UniqueCode)
                        {
                            //SourceExpr=UniqueCode;
                        }
                        DataItem("QB Text"; "QB Text")
                        {

                            DataItemTableView = SORTING("Table")
                                 WHERE("Table" = CONST("Job"));
                            DataItemLink = "Key1" = FIELD("Job No."),
                            "Key2" = FIELD("Piecework NÂº");
                            Column(ExtendedTextLineText; Text1)
                            {
                                //SourceExpr=Text1;
                            }
                            DataItem("otherLines"; "2000000026")
                            {

                                DataItemTableView = SORTING("Number");
                                ;
                                Column(otherLines_Number; Number)
                                {
                                    //SourceExpr=Number;
                                }
                                DataItem("Totals"; "2000000026")
                                {

                                    ;
                                    Column(AmountUOTot; AmountUOTot)
                                    {
                                        //SourceExpr=AmountUOTot;
                                    }
                                    Column(AmountUoOldTot; AmountUoOldTot)
                                    {
                                        //SourceExpr=AmountUoOldTot;
                                    }
                                    Column(AmountVATot; AmountVATot)
                                    {
                                        //SourceExpr=AmountVATot;
                                    }
                                    Column(AmountRetTot; AmountRetTot)
                                    {
                                        //SourceExpr=AmountRetTot;
                                    }
                                    Column(Totals_Number; Number)
                                    {
                                        //SourceExpr=Number ;
                                    }
                                    trigger OnPreDataItem();
                                    BEGIN
                                        SETRANGE(Number, 1, 1);
                                    END;


                                }
                                trigger OnPreDataItem();
                                BEGIN
                                    nlinesUltPag := LineCount MOD NUM_LINES_REPORT;

                                    IF ((nlinesUltPag + NUM_LINES_FOOT) <= NUM_LINES_REPORT) THEN BEGIN
                                        otherLines.SETRANGE(Number, nlinesUltPag + NUM_LINES_FOOT + 1, NUM_LINES_REPORT);
                                        PaddingLine := NUM_LINES_REPORT;
                                    END
                                    ELSE BEGIN
                                        otherLines.SETRANGE(Number, nlinesUltPag + NUM_LINES_FOOT + 1, NUM_LINES_REPORT * 2);
                                        PaddingLine := NUM_LINES_REPORT * 2;
                                    END
                                END;


                            }
                            trigger OnPreDataItem();
                            BEGIN
                                CurrReport.BREAK;
                            END;

                            trigger OnAfterGetRecord();
                            BEGIN
                                Text1 := "QB Text".GetCostText;
                                LineCount += 1;
                            END;


                        }
                        trigger OnAfterGetRecord();
                        BEGIN
                            AmountUO := ROUND("Unit Cost (LCY)" * Quantity, Currency."Amount Rounding Precision");
                            VATAmount := ROUND(AmountUO * "VAT %" / 100, Currency."Amount Rounding Precision");
                            IF "VAT %" <> 0 THEN
                                ByVATApplied := "VAT %";

                            IF WithholdingGroup."Withholding Base" = WithholdingGroup."Withholding Base"::"Invoice Amount" THEN
                                WithholdingAmount := ROUND(AmountUO * WithholdingGroup."Percentage Withholding" / 100,
                                                           Currency."Amount Rounding Precision")
                            ELSE
                                WithholdingAmount := ROUND((AmountUO + VATAmount) * WithholdingGroup."Percentage Withholding" / 100,
                                                           Currency."Amount Rounding Precision");

                            AmountUOTot := AmountUOTot + AmountUO;
                            AmountUoOldTot := AmountUoOldTot + AmountUOOld;
                            AmountVATot := AmountVATot + VATAmount;
                            AmountRetTot := AmountRetTot + WithholdingAmount;
                            LineCount += 1;
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        LineCount := 0;
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
                BEGIN
                    IF Number > 1 THEN BEGIN
                        CopyText := textCOPY;
                        OutputNo += 1;
                    END;

                    CurrReport.PAGENO := 1;
                    DocIndex += 1;

                    AmountUOTot := 0;
                    AmountUoOldTot := 0;
                    AmountVATot := 0;
                    AmountRetTot := 0;
                END;

                trigger OnPostDataItem();
                BEGIN
                    IF NOT CurrReport.PREVIEW THEN
                        PurchRcptPrinted.RUN("Purch. Rcpt. Header");
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                LineCount := 1;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                //Clarify with EU Team

                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                CompanyInformation.GET;

                IF ResponsibilityCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddress.RespCenter(CompanyAddr, ResponsibilityCenter);
                    CompanyInformation."Phone No." := ResponsibilityCenter."Phone No.";
                    CompanyInformation."Fax No." := ResponsibilityCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddress.Company(CompanyAddr, CompanyInformation);
                END;

                IF "Purchaser Code" = '' THEN BEGIN
                    SalespersonPurchaser.INIT;
                END ELSE BEGIN
                    SalespersonPurchaser.GET("Purchaser Code");
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");

                FormatAddress.PurchRcptShipTo(ShipToAddr, "Purch. Rcpt. Header");
                FormatAddress.PurchRcptPayTo(VendAddr, "Purch. Rcpt. Header");

                IF NOT Job.GET("Purch. Rcpt. Header"."Job No.") THEN
                    CLEAR(Job);

                IF NOT PaymentTerms.GET("Purch. Rcpt. Header"."Payment Terms Code") THEN
                    CLEAR(PaymentTerms);

                IF NOT PaymentMethod.GET("Purch. Rcpt. Header"."Payment Method Code") THEN
                    CLEAR(PaymentMethod);

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          15, "No.", 0, 0, DATABASE::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');
                ;

                //Buscar el grupo de retenci¢n del pedido/contrato original
                CLEAR(WithholdingGroup);
                IF (PurchaseHeaderOrder.GET(PurchaseHeaderOrder."Document Type"::Order, "Purch. Rcpt. Header"."Order No.")) THEN BEGIN
                    IF (PurchaseHeaderOrder."QW Cod. Withholding by GE" <> '') THEN
                        WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", PurchaseHeaderOrder."QW Cod. Withholding by GE");
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group10")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("NoOfCopies"; "NoOfCopies")
                    {

                        CaptionML = ENU = 'No. Copies', ESP = 'N£m. Copias';
                    }
                    field("includeLogo"; "includeLogo")
                    {

                        CaptionML = ENU = 'Include Logo', ESP = 'Incluye Logo';
                    }

                }

            }
        }
    }
    labels
    {
        Purchaser = 'Purchaser/ Comprador/';
        PurchReceipt = 'Purchases - Receipt/ Compras - Albar n/';
        Page = 'Page/ P g./';
        NumDoc = 'DOCUMENT NO./ N§ DOCUMENTO/';
        Date = 'DATE/ FECHA/';
        Day = 'DAY/ DÖA/';
        Month = 'MONTH/ MES/';
        Year = 'YEAR/ A¥O/';
        Subcontractor = 'SOBCONTRACTOR/ SUBCONTRATISTA/';
        JobL = 'JOB:/ OBRA:/';
        AmountInvoice = 'AMOUNT OF THIS INVOICE/ IMPORTE PRESENTE FACTURA/';
        Obs = 'OBSERVATIONS/ OBSERVACIONES/';
        Total = 'TOTAL/ TOTAL/';
        Deduct = 'PREVIOUS CERTIFICATIONS TO DEDUCT/ A DEDUCIR POR CERTIFICACIONES ANTERIORES/';
        Liquidity = 'LIQUIDITY TO PAY/ LIQUIDO A PAGAR/';
        TheSubcontractor = 'THE SUBCONTRACTOR/ EL SUBCONTRATISTA/';
        JobLeader = 'THE JOB LEADER/ EL JEFE DE OBRA/';
        GroupProd = 'GROUP / PRODUCTION LEADER/ J. GRUPO / PRODUCCIàN/';
        NoSettle = '* WON''T BE SETTLE THE TOTAL OF THE JOBS UNTIL CONTRACT DOCUMENTATION HAS BEEN DELIVERY./ * NO SE LIQUIDARµ EL TOTAL DE LOS TRABAJOS HASTA LA ENTREGA DE LA DOCUMENTACIàN DEL CONTRATO./';
        ValProforma = '* THE VALIDITY OF THIS PROFORMA INVOICE IS SUBJECT TO THE SIGNATURE BY GROUP AND/OR PRODUCTION LEADER/ * LA VALIDEZ DE ESTA PROFORMA ESTµ SUPEDITADA A LA FIRMA POR PARTE DEL J. GRUPO Y/O J. PRODUCCION./';
        PieceWorkL = 'PIECEWORK/ RECURSO N§/';
        Concept = 'CONCEPT/ CONCEPTO/';
        Measurement = 'MEASUREMENT/ MEDICIàN/';
        You = 'YOU/ UD./';
        CostUnit = 'COST PER UNIT/ PRECIO DE LA UNIDAD/';
        Certificate = 'MEASUREMENT CERTIFICATE/ ACTA DE MEDICIàN/';
        PaymentMet = 'PAYMENT METHOD:/ FORMA DE PAGO:/';
        PaymentDoc = 'PAYMENT DOCUMENT:/ DOCUMENTO DE COBRO:/';
        WithholdingGE = 'WITHHOLDING G.E./ RETENCIàN B.E./';
        PercVAT = '% V.A.T./ % I.V.A./';
        Perc = '%/ %/';
        WithholdingInvoice = 'WITHHOLDING % / THIS INVOICE/ % RETENCION / PRESENTE FACTURA/';
    }

    var
        //       CompanyInformation@7001155 :
        CompanyInformation: Record 79;
        //       SalespersonPurchaser@7001154 :
        SalespersonPurchaser: Record 13;
        //       DimensionBuffer@7001153 :
        DimensionBuffer: Record 360;
        //       DimensionBuffer2@7001152 :
        DimensionBuffer2: Record 360;
        //       Language@7001151 :
        // Language: Record 8;
        Language: Codeunit "Language";
        //       ResponsibilityCenter@7001150 :
        ResponsibilityCenter: Record 5714;
        //       PurchaseHeaderOrder@1100286000 :
        PurchaseHeaderOrder: Record 38;
        //       PurchRcptPrinted@7001149 :
        PurchRcptPrinted: Codeunit 318;
        //       SegManagement@7001148 :
        SegManagement: Codeunit 5051;
        //       VendAddr@7001147 :
        VendAddr: ARRAY[8] OF Text[50];
        //       ShipToAddr@7001146 :
        ShipToAddr: ARRAY[8] OF Text[50];
        //       CompanyAddr@7001145 :
        CompanyAddr: ARRAY[8] OF Text[50];
        //       PurchaserText@7001144 :
        PurchaserText: Text[30];
        //       ReferenceText@7001143 :
        ReferenceText: Text[30];
        //       MoreLines@7001142 :
        MoreLines: Boolean;
        //       NoOfCopies@7001141 :
        NoOfCopies: Integer;
        //       NoOfLoops@7001140 :
        NoOfLoops: Integer;
        //       CopyText@7001139 :
        CopyText: Text[30];
        //       FormatAddress@7001138 :
        FormatAddress: Codeunit 365;
        //       DimText@7001137 :
        DimText: Text[120];
        //       OldDimText@7001136 :
        OldDimText: Text[75];
        //       ShowInternalInfo@7001135 :
        ShowInternalInfo: Boolean;
        //       Continue@7001134 :
        Continue: Boolean;
        //       LogInteraction@7001133 :
        LogInteraction: Boolean;
        //       ShowCorrectionLines@7001132 :
        ShowCorrectionLines: Boolean;
        //       ProformaaOrigen@7001131 :
        ProformaaOrigen: Boolean;
        //       PurchRcptHeader@7001130 :
        PurchRcptHeader: Record 120;
        //       PurchRcptLine@7001129 :
        PurchRcptLine: Record 121;
        //       CertifiedQuantity@7001128 :
        CertifiedQuantity: Decimal;
        //       CertifiedQuantityOld@7001127 :
        CertifiedQuantityOld: Decimal;
        //       Job@7001126 :
        Job: Record 167;
        //       Percentage@7001125 :
        Percentage: Decimal;
        //       Price@7001124 :
        Price: Decimal;
        //       AmountUO@7001123 :
        AmountUO: Decimal;
        //       AmountUOOld@7001122 :
        AmountUOOld: Decimal;
        //       PurchaseLine@7001121 :
        PurchaseLine: Record 39;
        //       Currency@7001120 :
        Currency: Record 4;
        //       Text1@7001119 :
        Text1: Text;
        //       LineCount@7001117 :
        LineCount: Integer;
        //       PaymentMethod@7001116 :
        PaymentMethod: Record 289;
        //       PaymentTerms@7001115 :
        PaymentTerms: Record 3;
        //       VATAmount@7001114 :
        VATAmount: Decimal;
        //       WithholdingAmount@7001113 :
        WithholdingAmount: Decimal;
        //       WithholdingGroup@7001112 :
        WithholdingGroup: Record 7207330;
        //       ByVATApplied@7001111 :
        ByVATApplied: Decimal;
        //       includeLogo@7001110 :
        includeLogo: Boolean;
        //       OutputNo@7001109 :
        OutputNo: Integer;
        //       DocIndex@7001108 :
        DocIndex: Integer;
        //       nlinesUltPag@7001107 :
        nlinesUltPag: Integer;
        //       NUM_LINES_REPORT@7001106 :
        NUM_LINES_REPORT: Integer;
        //       NUM_LINES_FOOT@7001105 :
        NUM_LINES_FOOT: Integer;
        //       PaddingLine@7001104 :
        PaddingLine: Integer;
        //       AmountUOTot@7001103 :
        AmountUOTot: Decimal;
        //       AmountUoOldTot@7001102 :
        AmountUoOldTot: Decimal;
        //       AmountVATot@7001101 :
        AmountVATot: Decimal;
        //       AmountRetTot@7001100 :
        AmountRetTot: Decimal;
        //       textCOPY@7001156 :
        textCOPY: TextConst ENU = 'COPY', ESP = 'COPIA';
        //       UniqueCode@1000000000 :
        UniqueCode: Code[10];



    trigger OnInitReport();
    begin
        NUM_LINES_REPORT := 31;
        NUM_LINES_FOOT := 15;
    end;

    trigger OnPreReport();
    begin
        if includeLogo then begin
            CompanyInformation.GET;
            CompanyInformation.CALCFIELDS(Picture);
        end;
    end;



    /*begin
        {
          QB9999 JDC 27/08/19 - Created, based on 7207327
        }
        end.
      */

}



