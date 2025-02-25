report 7207327 "QB Proforma from FRI"
{


    CaptionML = ENU = 'Proforma Invoice', ESP = 'Factura proforma';
    PreviewMode = PrintLayout;

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
            Column(CompanyPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(IsOrigen; TypeReport = TypeReport::"A Origen")
            {
                //SourceExpr=TypeReport = TypeReport::"A Origen";
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
            Column(includeLogo; includeLogo)
            {
                //SourceExpr=includeLogo;
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
                    Column(PageLoop_Number; Number)
                    {
                        //SourceExpr=Number;
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
                    DataItem("tmpPurchRcptLine"; "Purch. Rcpt. Line")
                    {



                        UseTemporary = true;
                        Column(LineNo; "Line No.")
                        {
                            //SourceExpr="Line No.";
                        }
                        Column(Orden; Orden)
                        {
                            //SourceExpr=Orden;
                        }
                        Column(FormatNo; Number)
                        {
                            //SourceExpr=Number;
                        }
                        Column(PieceworkCode; "Piecework NÂº")
                        {
                            //SourceExpr="Piecework N§";
                        }
                        Column(CertifiedQuantityPeriod; Quantity)
                        {
                            DecimalPlaces = 2 : 5;
                            //SourceExpr=Quantity;
                        }
                        Column(CertifiedQuantityOrigin; "Qty. Received Origin")
                        {
                            DecimalPlaces = 2 : 5;
                            //SourceExpr="Qty. Received Origin";
                        }
                        Column(UnitOfMeasure; DataPieceworkForProduction."Unit Of Measure")
                        {
                            //SourceExpr=DataPieceworkForProduction."Unit Of Measure";
                        }
                        Column(Descripcion; Descripcion)
                        {
                            //SourceExpr=Descripcion;
                        }
                        Column(uoPrice; "Direct Unit Cost")
                        {
                            DecimalPlaces = 2 : 6;
                            //SourceExpr="Direct Unit Cost";
                            AutoFormatType = 2;
                        }
                        Column(LineAmount; LineAmount)
                        {
                            //SourceExpr=LineAmount;
                            AutoFormatType = 1;
                        }
                        Column(AmountUOTot; AmountTotal)
                        {
                            //SourceExpr=AmountTotal;
                        }
                        Column(AmountUOAnt; AmountTotAnt)
                        {
                            //SourceExpr=AmountTotAnt;
                        }
                        Column(AmountVATot; AmountTotVAT)
                        {
                            //SourceExpr=AmountTotVAT;
                        }
                        Column(AmountRetTot; AmountTotRet)
                        {
                            //SourceExpr=AmountTotRet;
                        }
                        Column(Totals_Number; Number)
                        {
                            //SourceExpr=Number;
                        }
                        Column(AmountUO; AmountUOOrigin)
                        {
                            //SourceExpr=AmountUOOrigin;
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
                        Column(ByVATApplied; VATPercent)
                        {
                            //SourceExpr=VATPercent;
                        }
                        Column(WithholdingAmount; WithholdingAmount)
                        {
                            //SourceExpr=WithholdingAmount;
                            AutoFormatType = 1;
                        }
                        Column(ExtendedText; ExtendedText)
                        {
                            //SourceExpr=ExtendedText ;
                        }
                        trigger OnAfterGetRecord();
                        BEGIN
                            IF NOT DataPieceworkForProduction.GET("Job No.", "Piecework NÂº") THEN
                                DataPieceworkForProduction.INIT;

                            IF (Agrupado) THEN BEGIN
                                Orden := "Piecework NÂº";
                                Descripcion := DataPieceworkForProduction.Description + ' ' + DataPieceworkForProduction."Description 2";
                            END ELSE BEGIN
                                Orden := '00000' + FORMAT(tmpPurchRcptLine."Line No.");
                                Orden := COPYSTR(Orden, STRLEN(Orden) - 5);

                                Orden := FORMAT(tmpPurchRcptLine."Line No.");
                                Orden := PADSTR('', 10 - STRLEN(Orden), '0') + Orden;

                                Descripcion := tmpPurchRcptLine.Description + ' ' + tmpPurchRcptLine."Description 2";
                            END;

                            IF (QBText.GET(QBText.Table::Contrato, 0 + PurchaseHeader."Document Type"::Order, "Order No.", FORMAT("Order Line No."))) THEN
                                ExtendedText := QBText.GetCostText
                            ELSE
                                ExtendedText := '';

                            AmountUOPeriod := ROUND("Direct Unit Cost" * Quantity, Currency."Amount Rounding Precision");
                            AmountUOOrigin := ROUND("Direct Unit Cost" * "Qty. Received Origin", Currency."Amount Rounding Precision");
                            AmountUOOld := AmountUOOrigin - AmountUOPeriod;

                            VATAmount := ROUND(AmountUOPeriod * "VAT %" / 100, Currency."Amount Rounding Precision");
                            IF ("VAT %" <> 0) THEN
                                VATPercent := "VAT %";

                            IF WithholdingGroup."Withholding Base" = WithholdingGroup."Withholding Base"::"Invoice Amount" THEN
                                WithholdingAmount := ROUND(AmountUOPeriod * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision")
                            ELSE
                                WithholdingAmount := ROUND((AmountUOPeriod + VATAmount) * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision");

                            IF (TypeReport = TypeReport::"A Origen") THEN BEGIN
                                LineAmount := AmountUOOrigin;
                                AmountTotAnt += AmountUOOld;
                            END ELSE BEGIN
                                LineAmount := AmountUOPeriod;
                                AmountTotAnt += 0;
                            END;
                            AmountTotal += LineAmount;
                            AmountTotVAT += VATAmount;
                            AmountTotRet += WithholdingAmount;

                            //Propios de la l¡nea
                            Number := 1 - Number;
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

                    AmountTotal := 0;
                    AmountTotAnt := 0;
                    AmountTotVAT := 0;
                    AmountTotRet := 0;
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
                LineCount := 0;
                VATPercent := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                IF ResponsibilityCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddress.RespCenter(CompanyAddr, ResponsibilityCenter);
                    CompanyInformation."Phone No." := ResponsibilityCenter."Phone No.";
                    CompanyInformation."Fax No." := ResponsibilityCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddress.Company(CompanyAddr, CompanyInformation);
                END;

                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");

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

                IF (Agrupado) THEN
                    MontarAgrupado
                ELSE
                    MontarNoAgrupado;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group513")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("Agrupado"; "Agrupado")
                    {

                        CaptionML = ESP = 'Agrupado por U.O.';
                    }
                    field("TypeReport"; "TypeReport")
                    {

                        CaptionML = ESP = 'Tipo';
                    }
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
        TotalOrigen = 'TOTAL/ TOTAL A ORIGEN/';
        TotalPeriodo = 'TOTAL/ TOTAL DEL PERIODO/';
        Deduct = 'PREVIOUS CERTIFICATIONS TO DEDUCT/ A DEDUCIR POR CERTIFICACIONES ANTERIORES/';
        Liquidity = 'LIQUIDITY TO PAY/ LIQUIDO A PAGAR/';
        TheSubcontractor = 'THE SUBCONTRACTOR/ EL SUBCONTRATISTA/';
        JobLeader = 'THE JOB LEADER/ EL JEFE DE OBRA/';
        GroupProd = 'GROUP / PRODUCTION LEADER/ J. GRUPO / PRODUCCIêN/';
        NoSettle = '* WON''T BE SETTLE THE TOTAL OF THE JOBS UNTIL CONTRACT DOCUMENTATION HAS BEEN DELIVERY./ * NO SE LIQUIDARÛ EL TOTAL DE LOS TRABAJOS HASTA LA ENTREGA DE LA DOCUMENTACIêN DEL CONTRATO./';
        ValProforma = '* THE VALIDITY OF THIS PROFORMA INVOICE IS SUBJECT TO THE SIGNATURE BY GROUP AND/OR PRODUCTION LEADER/ * LA VALIDEZ DE ESTA PROFORMA ESTÛ SUPEDITADA A LA FIRMA POR PARTE DEL J. GRUPO Y/O J. PRODUCCIêN./';
        PieceWorkL = 'PIECEWORK/ UNIDAD DE OBRA/';
        Concept = 'CONCEPT/ CONCEPTO/';
        Measurement = 'MEASUREMENT/ MEDICIàN/';
        Origin = 'Origen/';
        Period = 'Periodo/';
        MeasureUnit = 'YOU/ U.M./';
        CostUnit = 'COST PER UNIT/ PRECIO DE LA UNIDAD/';
        Certificate = 'MEASUREMENT CERTIFICATE/ ACTA DE MEDICIàN/';
        PaymentMet = 'PAYMENT METHOD:/ FORMA DE PAGO:/';
        PaymentDoc = 'PAYMENT DOCUMENT:/ DOCUMENTO DE COBRO:/';
        WithholdingGE = 'WITHHOLDING G.E./ RETENCIàN B.E./';
        PercVAT = '% V.A.T./ % I.V.A./';
        Perc = '%/ %/';
        WithholdingInvoice = 'WITHHOLDING % / THIS INVOICE/ % RETENCIàN / PRESENTE FACTURA/';
        SyS = 'SUMA Y SIGUE/';
    }

    var
        //       CompanyInformation@7001155 :
        CompanyInformation: Record 79;
        //       Job@1100286006 :
        Job: Record 167;
        //       DataPieceworkForProduction@1100286004 :
        DataPieceworkForProduction: Record 7207386;
        //       QBText@1100286005 :
        QBText: Record 7206918;
        //       Language@7001151 :
        Language: Codeunit "Language";
        //       ResponsibilityCenter@7001150 :
        ResponsibilityCenter: Record 5714;
        //       PurchaseHeader@1100286014 :
        PurchaseHeader: Record 38;
        //       PurchRcptHeader@1100286015 :
        PurchRcptHeader: Record 120;
        //       PurchRcptLine1@1100286013 :
        PurchRcptLine1: Record 121;
        //       PurchRcptLine2@1100286010 :
        PurchRcptLine2: Record 121;
        //       Currency@7001120 :
        Currency: Record 4;
        //       PaymentMethod@1100286029 :
        PaymentMethod: Record 289;
        //       PaymentTerms@1100286028 :
        PaymentTerms: Record 3;
        //       WithholdingGroup@1100286027 :
        WithholdingGroup: Record 7207330;
        //       PurchaseHeaderOrder@1100286023 :
        PurchaseHeaderOrder: Record 38;
        //       PurchRcptPrinted@1100286019 :
        PurchRcptPrinted: Codeunit 318;
        //       SegManagement@1100286018 :
        SegManagement: Codeunit 5051;
        //       FormatAddress@1100286016 :
        FormatAddress: Codeunit 365;
        //       VendAddr@1100286026 :
        VendAddr: ARRAY[8] OF Text[50];
        //       CompanyAddr@1100286024 :
        CompanyAddr: ARRAY[8] OF Text[50];
        //       ReferenceText@1100286022 :
        ReferenceText: Text[30];
        //       MoreLines@1100286021 :
        MoreLines: Boolean;
        //       NoOfLoops@1100286020 :
        NoOfLoops: Integer;
        //       CopyText@1100286017 :
        CopyText: Text[30];
        //       Continue@1100286012 :
        Continue: Boolean;
        //       LogInteraction@1100286011 :
        LogInteraction: Boolean;
        //       ExtendedText@7001119 :
        ExtendedText: Text;
        //       LineCount@7001117 :
        LineCount: Integer;
        //       VATAmount@7001114 :
        VATAmount: Decimal;
        //       WithholdingAmount@7001113 :
        WithholdingAmount: Decimal;
        //       OutputNo@7001109 :
        OutputNo: Integer;
        //       DocIndex@7001108 :
        DocIndex: Integer;
        //       AmountUOPeriod@1100286007 :
        AmountUOPeriod: Decimal;
        //       AmountUOOrigin@1100286003 :
        AmountUOOrigin: Decimal;
        //       AmountUOOld@1100286002 :
        AmountUOOld: Decimal;
        //       LineAmount@1100286009 :
        LineAmount: Decimal;
        //       AmountTotal@7001103 :
        AmountTotal: Decimal;
        //       AmountTotAnt@7001102 :
        AmountTotAnt: Decimal;
        //       AmountTotVAT@7001101 :
        AmountTotVAT: Decimal;
        //       AmountTotRet@7001100 :
        AmountTotRet: Decimal;
        //       textCOPY@7001156 :
        textCOPY: TextConst ENU = 'COPY', ESP = 'COPIA';
        //       VATPercent@1100286033 :
        VATPercent: Decimal;
        //       Number@1100286008 :
        Number: Integer;
        //       Descripcion@1000000000 :
        Descripcion: Text;
        //       Orden@1000000001 :
        Orden: Text;
        //       "-------------------- Opciones"@1100286000 :
        "-------------------- Opciones": Integer;
        //       NoOfCopies@1100286001 :
        NoOfCopies: Integer;
        //       includeLogo@1100286030 :
        includeLogo: Boolean;
        //       TypeReport@1100286031 :
        TypeReport: Option "A Origen","Del Periodo";
        //       Agrupado@1000000002 :
        Agrupado: Boolean;



    trigger OnInitReport();
    begin
        includeLogo := TRUE;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        if (includeLogo) then
            CompanyInformation.CALCFIELDS(Picture);
    end;



    LOCAL procedure MontarAgrupado()
    begin
        PurchRcptLine1.SETCURRENTKEY("Order No.", "Order Line No.", "Posting Date");
        PurchRcptLine1.SETRANGE("Order No.", "Purch. Rcpt. Header"."Order No.");
        PurchRcptLine1.SETFILTER("Document No.", '<=%1', "Purch. Rcpt. Header"."No.");
        PurchRcptLine1.SETFILTER(Quantity, '<>0');
        PurchRcptLine1.SETRANGE(Cancelled, FALSE);
        if PurchRcptLine1.FINDSET(TRUE) then
            repeat
                if (PurchRcptHeader.GET(PurchRcptLine1."Document No.")) then begin
                    if (not PurchRcptHeader.Cancelled) then begin
                        //Llevar a la temporal
                        tmpPurchRcptLine.RESET;
                        tmpPurchRcptLine.SETCURRENTKEY("Document No.", "Piecework NÂº");
                        //tmpPurchRcptLine.SETRANGE("Document No.", "No.");
                        tmpPurchRcptLine.SETRANGE("Piecework NÂº", PurchRcptLine1."Piecework NÂº");
                        tmpPurchRcptLine.SETRANGE("Direct Unit Cost", PurchRcptLine1."Direct Unit Cost");
                        if tmpPurchRcptLine.FINDFIRST then begin
                            if (PurchRcptLine1."Document No." = "Purch. Rcpt. Header"."No.") then
                                tmpPurchRcptLine.Quantity += PurchRcptLine1.Quantity;
                            tmpPurchRcptLine."Qty. Received Origin" += PurchRcptLine1.Quantity;
                            tmpPurchRcptLine.MODIFY;
                        end else begin
                            LineCount += 1;
                            tmpPurchRcptLine := PurchRcptLine1;
                            tmpPurchRcptLine."Document No." := "Purch. Rcpt. Header"."No.";
                            tmpPurchRcptLine."Line No." := LineCount;
                            if (PurchRcptLine1."Document No." = "Purch. Rcpt. Header"."No.") then
                                tmpPurchRcptLine.Quantity := PurchRcptLine1.Quantity
                            else
                                tmpPurchRcptLine.Quantity := 0;
                            tmpPurchRcptLine."Qty. Received Origin" := PurchRcptLine1.Quantity;
                            tmpPurchRcptLine.INSERT;
                        end;
                        //Eliminar l¡neas a cero
                        if (tmpPurchRcptLine.Quantity = 0) and (tmpPurchRcptLine."Qty. Received Origin" = 0) then
                            tmpPurchRcptLine.DELETE;

                    end;
                end;
            until PurchRcptLine1.NEXT = 0;
    end;

    LOCAL procedure MontarNoAgrupado()
    begin
        PurchRcptLine1.SETCURRENTKEY("Order No.", "Order Line No.", "Posting Date");
        PurchRcptLine1.SETRANGE("Order No.", "Purch. Rcpt. Header"."Order No.");
        PurchRcptLine1.SETFILTER("Document No.", '<=%1', "Purch. Rcpt. Header"."No.");
        PurchRcptLine1.SETFILTER(Quantity, '<>0');
        PurchRcptLine1.SETRANGE(Cancelled, FALSE);
        if PurchRcptLine1.FINDSET(TRUE) then
            repeat
                if (PurchRcptHeader.GET(PurchRcptLine1."Document No.")) then begin
                    if (not PurchRcptHeader.Cancelled) then begin
                        //Llevar a la temporal
                        tmpPurchRcptLine.RESET;
                        tmpPurchRcptLine.SETRANGE("Order Line No.", PurchRcptLine1."Order Line No.");
                        tmpPurchRcptLine.SETRANGE("Direct Unit Cost", PurchRcptLine1."Direct Unit Cost");
                        if tmpPurchRcptLine.FINDFIRST then begin
                            if (PurchRcptLine1."Document No." = "Purch. Rcpt. Header"."No.") then
                                tmpPurchRcptLine.Quantity += PurchRcptLine1.Quantity;
                            tmpPurchRcptLine."Qty. Received Origin" += PurchRcptLine1.Quantity;
                            tmpPurchRcptLine.MODIFY;
                        end else begin
                            LineCount += 1;
                            tmpPurchRcptLine := PurchRcptLine1;
                            tmpPurchRcptLine."Document No." := "Purch. Rcpt. Header"."No.";
                            tmpPurchRcptLine."Line No." := LineCount;
                            if (PurchRcptLine1."Document No." = "Purch. Rcpt. Header"."No.") then
                                tmpPurchRcptLine.Quantity := PurchRcptLine1.Quantity
                            else
                                tmpPurchRcptLine.Quantity := 0;
                            tmpPurchRcptLine."Qty. Received Origin" := PurchRcptLine1.Quantity;
                            tmpPurchRcptLine.INSERT;
                        end;
                        //Eliminar l¡neas a cero
                        if (tmpPurchRcptLine.Quantity = 0) and (tmpPurchRcptLine."Qty. Received Origin" = 0) then
                            tmpPurchRcptLine.DELETE;
                    end;
                end;
            until PurchRcptLine1.NEXT = 0;
    end;

    /*begin
    end.
  */

}



