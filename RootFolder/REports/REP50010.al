report 50010 "ViaAgora: Proforma"
{


    CaptionML = ENU = 'Proforma Invoice', ESP = 'Factura proforma';
    PreviewMode = PrintLayout;

    dataset
    {

        DataItem("QB Proform Header"; "QB Proform Header")
        {

            DataItemTableView = SORTING("No.");
            ;
            Column(CompanyPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(includeLogo; includeLogo)
            {
                //SourceExpr=includeLogo;
            }
            Column(TypeReport; TypeReport)
            {
                //SourceExpr=TypeReport;
            }
            Column(PurchRcptHeaderNo; "No.")
            {
                //SourceExpr="No.";
            }
            Column(PurchRcptHeaderJobNo; "Job No.")
            {
                //SourceExpr="Job No.";
            }
            Column(ProformNumber; "Proform Number")
            {
                //SourceExpr="Proform Number";
            }
            Column(PostingDate; "Posting Date")
            {
                //SourceExpr="Posting Date";
            }
            Column(QBProformHeader_BuyfromVendorNo; "Buy-from Vendor No.")
            {
                //SourceExpr="Buy-from Vendor No.";
            }
            Column(BuyfromVendoName; "Buy-from Vendor Name" + ' ' + "Buy-from Vendor Name 2")
            {
                //SourceExpr="Buy-from Vendor Name" + ' ' + "Buy-from Vendor Name 2";
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
            Column(TextCode; TextCode)
            {
                //SourceExpr=TextCode;
            }
            Column(VATText; VATText)
            {
                //SourceExpr=VATText;
            }
            Column(FormatoCnt; FormatoCnt)
            {
                //SourceExpr=FormatoCnt;
            }
            Column(TextPie; TextPie)
            {
                //SourceExpr=TextPie;
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
                    DataItem("tmpLines"; "QB Proform Line")
                    {

                        DataItemTableView = SORTING("Document No.", "Line No.");


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
                        Column(PieceworkCode; "Piecework Nº")
                        {
                            //SourceExpr="Piecework N§";
                        }
                        Column(QuantityPeriod; "QB tmp Proform Term")
                        {
                            DecimalPlaces = 2 : 5;
                            //SourceExpr="QB tmp Proform Term";
                        }
                        Column(QuantityOrigin; "QB tmp Proform Origin")
                        {
                            DecimalPlaces = 2 : 5;
                            //SourceExpr="QB tmp Proform Origin";
                        }
                        Column(UnitOfMeasure; "Unit of Measure Code")
                        {
                            //SourceExpr="Unit of Measure Code";
                        }
                        Column(Codigo; LinCodigo)
                        {
                            //SourceExpr=LinCodigo;
                        }
                        Column(Descripcion; LinDescripcion)
                        {
                            //SourceExpr=LinDescripcion;
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
                            IF NOT DataPieceworkForProduction.GET("Job No.", "Piecework Nº") THEN
                                DataPieceworkForProduction.INIT;

                            CASE PurchasesPayablesSetup."QB Proforma Def. Group" OF
                                PurchasesPayablesSetup."QB Proforma Def. Group"::None:
                                    BEGIN
                                        Orden := FORMAT(tmpLines."Line No.");
                                        Orden := PADSTR('', 10 - STRLEN(Orden), '0') + Orden;
                                        LinCodigo := tmpLines."Piecework Nº";
                                        LinDescripcion := tmpLines.Description + ' ' + tmpLines."Description 2";
                                        //LinDescripcion := tmpLines."N§" + ' ' + LinDescripcion;
                                    END;
                                PurchasesPayablesSetup."QB Proforma Def. Group"::Piecework:
                                    BEGIN
                                        Orden := "Piecework Nº";
                                        LinCodigo := tmpLines."Piecework Nº";
                                        LinDescripcion := DataPieceworkForProduction.Description + ' ' + DataPieceworkForProduction."Description 2";
                                    END;
                                PurchasesPayablesSetup."QB Proforma Def. Group"::Code:
                                    BEGIN
                                        Orden := tmpLines."No.";
                                        LinCodigo := tmpLines."No.";
                                        LinDescripcion := tmpLines.Description + ' ' + tmpLines."Description 2";
                                    END;
                            END;

                            //IF (QBText.GET(QBText.Table::Contrato, 0+PurchaseHeader."Document Type"::Order, "Order No.", FORMAT("Order Line No."))) THEN
                            //  ExtendedText := QBText.GetCostText
                            //ELSE
                            ExtendedText := '';

                            // "Direct Unit Cost" := 0;
                            // IF (TypeReport = TypeReport::"A Origen") AND ("QB tmp Proform Origin" <> 0) THEN
                            //  "Direct Unit Cost" := "QB tmp Proform Amount Origin" / "QB tmp Proform Origin"
                            // ELSE IF (TypeReport = TypeReport::"Del Periodo") AND ("QB tmp Proform Term" <> 0) THEN
                            //  "Direct Unit Cost" := "QB tmp Proform Amount Term" / "QB tmp Proform Term";

                            AmountUOPeriod := ROUND("Direct Unit Cost" * "QB tmp Proform Term", Currency."Amount Rounding Precision");
                            AmountUOOrigin := ROUND("Direct Unit Cost" * "QB tmp Proform Origin", Currency."Amount Rounding Precision");
                            AmountUOOld := AmountUOOrigin - AmountUOPeriod;

                            VATAmount := ROUND(AmountUOPeriod * "VAT %" / 100, Currency."Amount Rounding Precision");
                            IF ("VAT %" <> 0) THEN
                                VATPercent := "VAT %";

                            IF WithholdingGroup."Withholding Base" = WithholdingGroup."Withholding Base"::"Invoice Amount" THEN
                                WithholdingAmount := ROUND(AmountUOPeriod * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision")
                            ELSE
                                WithholdingAmount := ROUND((AmountUOPeriod + VATAmount) * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision");

                            IF (NOT "QB Recurrent Line") THEN BEGIN
                                IF (TypeReport = TypeReport::"A Origen") THEN BEGIN
                                    LineAmount := AmountUOOrigin;
                                    AmountTotAnt += AmountUOOld;
                                END ELSE BEGIN
                                    LineAmount := AmountUOPeriod;
                                    AmountTotAnt += 0;
                                END;
                            END ELSE BEGIN
                                LineAmount := ROUND("Direct Unit Cost" * "QB tmp Proform Term", Currency."Amount Rounding Precision");
                            END;

                            AmountTotal += LineAmount;
                            AmountBase := 0;
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
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        "QB Proform Header"."No. Printed" += 1;
                        "QB Proform Header".MODIFY;
                    END;
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
                //Clarify with EU Team
                //  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");

                IF NOT Job.GET("QB Proform Header"."Job No.") THEN
                    CLEAR(Job);

                IF NOT PaymentTerms.GET("QB Proform Header"."Payment Terms Code") THEN
                    CLEAR(PaymentTerms);

                IF NOT PaymentMethod.GET("QB Proform Header"."Payment Method Code") THEN
                    CLEAR(PaymentMethod);

                CLEAR(WithholdingGroup);
                IF "QB Proform Header"."QW Cod. Withholding by GE" <> '' THEN
                    WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", "QB Proform Header"."QW Cod. Withholding by GE");

                IF (NOT "QB Proform Header"."Last Proform") THEN
                    TextPie := PurchasesPayablesSetup.QB_GetText()
                ELSE
                    TextPie := PurchasesPayablesSetup.QB_GetLastText();
                IF (TextPie = '') THEN
                    TextPie := '**** NO SE HA CONFIGURADO EL TEXTO PARA EL PIE DE LA PROFORMA ****';

                MontarAgrupado;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group14")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
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
                    field("CntDecimales"; "CntDecimales")
                    {

                        CaptionML = ESP = 'Decimales en cantidad';
                    }

                }

            }
        }
    }
    labels
    {
        Purchaser = 'Purchaser/ Comprador/';
        PurchReceipt = 'VENDOR PRO-FORMA/ PROFORMA PROVEEDOR/';
        Page = 'Page/ P g./';
        NumDoc = 'DOCUMENT NO./ N§ DOCUMENTO/';
        Date = 'DATE/ FECHA/';
        Day = 'DAY/ DÖA/';
        Month = 'MONTH/ MES/';
        Year = 'YEAR/ A¥O/';
        Subcontractor = 'SOBCONTRACTOR/ SUBCONTRATISTA/';
        JobL = 'JOB:/ OBRA:/';
        AmountInvoice = 'TOTAL ORIGIN CERTIFICATION (V.B.)/ TOTAL CERTIFICACIàN A ORIGEN (B.I.)/';
        Obs = 'OBSERVATIONS/ OBSERVACIONES/';
        Total = 'TOTAL CERTIFICATION MONTH (V.B.)/ TOTAL CERTIFICACIàN MES (B.I.)/';
        Deduct = 'PREVIOUS TO DEDUCT (V.B.)/ A DEDUCIR ANTERIOR (B.I.)/';
        Liquidity = 'TOTAL INVOICE/ TOTAL FACTURA/';
        TheSubcontractor = 'VENDOR SIGN/ FIRMA PROVEEDOR/';
        JobLeader = 'JOB LEADER SIGN/ FIRMA JEFE DE OBRA/';
        GroupProd = 'GROUP / PRODUCTION LEADER SIGN/ FIRMA J. GRUPO / PRODUCCIàN/';
        NoSettle = '* WON''T BE SETTLE THE TOTAL OF THE JOBS UNTIL CONTRACT DOCUMENTATION HAS BEEN DELIVERY./ * NO SE LIQUIDARµ EL TOTAL DE LOS TRABAJOS HASTA LA ENTREGA DE LA DOCUMENTACIàN DEL CONTRATO./';
        ValProforma = '* THE VALIDITY OF THIS PROFORMA INVOICE IS SUBJECT TO THE SIGNATURE BY GROUP AND/OR PRODUCTION LEADER/ * LA VALIDEZ DE ESTA PROFORMA ESTµ SUPEDITADA A LA FIRMA POR PARTE DEL J. GRUPO Y/O J. PRODUCCIàN./';
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
        WithholdingInvoice = 'WITHHOLDING/ RETENCIàN/';
        SyS = 'SUMA Y SIGUE/';
    }

    var
        //       CompanyInformation@7001155 :
        CompanyInformation: Record 79;
        //       PurchasesPayablesSetup@1100286011 :
        PurchasesPayablesSetup: Record 312;
        //       Job@1100286006 :
        Job: Record 167;
        //       DataPieceworkForProduction@1100286004 :
        DataPieceworkForProduction: Record 7207386;
        //       QBText@1100286005 :
        QBText: Record 7206918;
        //       Language@7001151 :
        Language: Record 8;
        //       PurchaseHeader@1100286014 :
        PurchaseHeader: Record 38;
        //       QBProformLine@1100286013 :
        QBProformLine: Record 7206961;
        //       Currency@7001120 :
        Currency: Record 4;
        //       PaymentMethod@1100286029 :
        PaymentMethod: Record 289;
        //       PaymentTerms@1100286028 :
        PaymentTerms: Record 3;
        //       WithholdingGroup@1100286027 :
        WithholdingGroup: Record 7207330;
        //       VATPostingSetup@1100286023 :
        VATPostingSetup: Record 325;
        //       QBProform@1100286032 :
        QBProform: Codeunit 7207345;
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
        //       LinePrice@1100286010 :
        LinePrice: Decimal;
        //       LineAmount@1100286009 :
        LineAmount: Decimal;
        //       AmountTotal@7001103 :
        AmountTotal: Decimal;
        //       AmountTotAnt@7001102 :
        AmountTotAnt: Decimal;
        //       AmountBase@1100286018 :
        AmountBase: Decimal;
        //       AmountTotVAT@7001101 :
        AmountTotVAT: Decimal;
        //       AmountTotRet@7001100 :
        AmountTotRet: Decimal;
        //       textCOPY@7001156 :
        textCOPY: TextConst ENU = 'COPY', ESP = 'COPIA';
        //       VATPercent@1100286033 :
        VATPercent: Decimal;
        //       VATText@1100286019 :
        VATText: Text;
        //       Number@1100286008 :
        Number: Integer;
        //       LinCodigo@1100286016 :
        LinCodigo: Text;
        //       LinDescripcion@1000000000 :
        LinDescripcion: Text;
        //       Orden@1000000001 :
        Orden: Text;
        //       TextCode@1100286015 :
        TextCode: Text;
        //       FormatoCnt@1100286024 :
        FormatoCnt: Text;
        //       TextPie@1100286026 :
        TextPie: Text;
        //       bPrint@1100286035 :
        bPrint: Boolean;
        //       "-------------------- Opciones"@1100286000 :
        "-------------------- Opciones": Integer;
        //       NoOfCopies@1100286001 :
        NoOfCopies: Integer;
        //       includeLogo@1100286030 :
        includeLogo: Boolean;
        //       TypeReport@1100286031 :
        TypeReport: Option "A Origen","Del Periodo";
        //       CntDecimales@1100286025 :
        CntDecimales: Integer;
        //       seeRecurrent@1100286034 :
        seeRecurrent: Boolean;



    trigger OnInitReport();
    begin
        includeLogo := TRUE;
        PurchasesPayablesSetup.GET;
        CntDecimales := 4;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        if (includeLogo) then
            CompanyInformation.CALCFIELDS(Picture);

        CASE PurchasesPayablesSetup."QB Proforma Def. Group" OF
            PurchasesPayablesSetup."QB Proforma Def. Group"::None:
                TextCode := 'U.O.';
            PurchasesPayablesSetup."QB Proforma Def. Group"::Piecework:
                TextCode := 'UNIDAD DE OBRA';
            PurchasesPayablesSetup."QB Proforma Def. Group"::Code:
                TextCode := 'CàDIGO';
        end;

        if (CntDecimales > 8) then
            CntDecimales := 8;
        if (CntDecimales < 0) then
            CntDecimales := 4;
        FormatoCnt := STRSUBSTNO('n%1', CntDecimales);
    end;



    LOCAL procedure MontarAgrupado()
    begin
        VATText := '';

        tmpLines.RESET;
        tmpLines.DELETEALL;

        QBProformLine.RESET;
        QBProformLine.SETRANGE("Document No.", "QB Proform Header"."No.");
        if QBProformLine.FINDSET(FALSE) then
            repeat
                QBProform.RecalculateLineOrigin(QBProformLine, QBProformLine.Quantity);

                bPrint := FALSE;
                //Si no es recurrente, imprimir si tiene cantidad o cantidad a origen
                if (not QBProformLine."QB Recurrent Line") and ((QBProformLine.Quantity <> 0) or (QBProformLine."QB Qty. Proformed Origin" <> 0)) then
                    bPrint := TRUE;
                //Si es recurrente se imprime si se ha indicado que si se ven y tiene cantidad
                if (QBProformLine."QB Recurrent Line") and (seeRecurrent) and (QBProformLine.Quantity <> 0) then
                    bPrint := TRUE;

                if (bPrint) then begin
                    //Llevar a la tabla temporal, buscar el registro seg£n la agrupaci¢n deseada, y siempre por precio
                    tmpLines.RESET;
                    tmpLines.SETRANGE("Direct Unit Cost", QBProformLine."Direct Unit Cost");
                    CASE PurchasesPayablesSetup."QB Proforma Def. Group" OF
                        PurchasesPayablesSetup."QB Proforma Def. Group"::None:
                            tmpLines.SETRANGE("Line No.", QBProformLine."Line No.");
                        PurchasesPayablesSetup."QB Proforma Def. Group"::Piecework:
                            tmpLines.SETRANGE("Piecework Nº", QBProformLine."Piecework Nº");
                        PurchasesPayablesSetup."QB Proforma Def. Group"::Code:
                            tmpLines.SETRANGE("No.", QBProformLine."No.");
                    end;
                    if (not tmpLines.FINDFIRST) then begin
                        tmpLines := QBProformLine;
                        tmpLines."QB tmp Proform Term" := 0;
                        tmpLines."QB tmp Proform Origin" := 0;
                        tmpLines."QB tmp Proform Amount Term" := 0;
                        tmpLines."QB tmp Proform Amount Origin" := 0;
                        tmpLines.INSERT;
                    end;
                    tmpLines."QB tmp Proform Term" += QBProformLine.Quantity;
                    tmpLines."QB tmp Proform Origin" += QBProformLine."QB Qty. Proformed Origin";
                    tmpLines."QB tmp Proform Amount Origin" += QBProformLine."QB Qty. Proformed Origin" * QBProformLine."Direct Unit Cost";
                    tmpLines."QB tmp Proform Amount Term" += QBProformLine.Quantity * QBProformLine."Direct Unit Cost";
                    tmpLines.MODIFY;
                end;
                //El texto del IVA
                if (VATText = '') and VATPostingSetup.GET(QBProformLine."VAT Bus. Posting Group", QBProformLine."VAT Prod. Posting Group") then
                    VATText := STRSUBSTNO('%1%IVA (%2) %3', VATPostingSetup."VAT %", VATPostingSetup."VAT Identifier", VATPostingSetup."ISP Description");

            until QBProformLine.NEXT = 0;

        VATText := DELCHR(VATText, '>', ' ');
    end;

    /*begin
    end.
  */

}



