report 7207301 "Pending to Post Certification"
{


    CaptionML = ENU = 'Pending to Post Certification', ESP = 'Certificaci¢n Borrador';

    dataset
    {

        DataItem("Measurement Header"; "Measurement Header")
        {

            DataItemTableView = SORTING("No.");
            ;
            Column(CompanyPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(txtPie; TxtPie)
            {
                //SourceExpr=TxtPie;
            }
            Column(HEmpresa; CompanyInformation.Name)
            {
                //SourceExpr=CompanyInformation.Name;
            }
            Column(HFirma; TxtFirma)
            {
                //SourceExpr=TxtFirma;
            }
            Column(CustAddr1; CustAddr[1])
            {
                //SourceExpr=CustAddr[1];
            }
            Column(CustAddr2; CustAddr[2])
            {
                //SourceExpr=CustAddr[2];
            }
            Column(CustAddr3; CustAddr[3])
            {
                //SourceExpr=CustAddr[3];
            }
            Column(CustAddr4; CustAddr[4])
            {
                //SourceExpr=CustAddr[4];
            }
            Column(CustAddr5; CustAddr[5])
            {
                //SourceExpr=CustAddr[5];
            }
            Column(CustAddr6; CustAddr[6])
            {
                //SourceExpr=CustAddr[6];
            }
            Column(HDoc_No; "Measurement Header"."No.")
            {
                //SourceExpr="Measurement Header"."No.";
            }
            Column(HCertification_No; "Measurement Header"."No. Measure")
            {
                //SourceExpr="Measurement Header"."No. Measure";
            }
            Column(HJob_No; "Measurement Header"."Job No.")
            {
                //SourceExpr="Measurement Header"."Job No.";
            }
            Column(HDate; "Measurement Header"."Measurement Date")
            {
                //SourceExpr="Measurement Header"."Measurement Date";
            }
            Column(HCertificationText; "Measurement Header"."Text Measure")
            {
                //SourceExpr="Measurement Header"."Text Measure";
            }
            Column(HCustomer_No; "Measurement Header"."Customer No.")
            {
                //SourceExpr="Measurement Header"."Customer No.";
            }
            Column(opcText; opcText)
            {
                //SourceExpr=opcText;
            }
            Column(PGG; Job."General Expenses / Other")
            {
                //SourceExpr=Job."General Expenses / Other";
            }
            Column(PBI; Job."Industrial Benefit")
            {
                //SourceExpr=Job."Industrial Benefit";
            }
            Column(PBaja; Job."Low Coefficient")
            {
                //SourceExpr=Job."Low Coefficient";
            }
            Column(PIVA; Totales[17])
            {
                //SourceExpr=Totales[17];
            }
            Column(PRF; Totales[18])
            {
                //SourceExpr=Totales[18];
            }
            Column(PRP; Totales[19])
            {
                //SourceExpr=Totales[19];
            }
            Column(T01; Totales[1])
            {
                //SourceExpr=Totales[1];
            }
            Column(T02; Totales[2])
            {
                //SourceExpr=Totales[2];
            }
            Column(T03; Totales[3])
            {
                //SourceExpr=Totales[3];
            }
            Column(T04; Totales[4])
            {
                //SourceExpr=Totales[4];
            }
            Column(T05; Totales[5])
            {
                //SourceExpr=Totales[5];
            }
            Column(T06; Totales[6])
            {
                //SourceExpr=Totales[6];
            }
            Column(T07; Totales[7])
            {
                //SourceExpr=Totales[7];
            }
            Column(T08; Totales[8])
            {
                //SourceExpr=Totales[8];
            }
            Column(T09; Totales[9])
            {
                //SourceExpr=Totales[9];
            }
            Column(T10; Totales[10])
            {
                //SourceExpr=Totales[10];
            }
            Column(T11; Totales[11])
            {
                //SourceExpr=Totales[11];
            }
            Column(T12; Totales[12])
            {
                //SourceExpr=Totales[12];
            }
            Column(T13; Totales[13])
            {
                //SourceExpr=Totales[13];
            }
            DataItem("Pasada"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
                Column(NPasada; Pasada.Number)
                {
                    //SourceExpr=Pasada.Number;
                }
                DataItem("Hist. Certification Lines"; "Hist. Certification Lines")
                {

                    DataItemTableView = SORTING("Document No.", "Line No.");


                    UseTemporary = true;
                    Column(LDocument_No; "Hist. Certification Lines"."Document No.")
                    {
                        //SourceExpr="Hist. Certification Lines"."Document No.";
                    }
                    Column(LPiecework_Order; "Hist. Certification Lines"."Piecework No.")
                    {
                        //SourceExpr="Hist. Certification Lines"."Piecework No.";
                    }
                    Column(LPiecework_No; PieceworkCode)
                    {
                        //SourceExpr=PieceworkCode;
                    }
                    Column(LDescription; txtDescription)
                    {
                        //SourceExpr=txtDescription;
                    }
                    Column(LMayor; (Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Header))
                    {
                        //SourceExpr=(Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Header);
                    }
                    Column(LDetalle; (Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Data))
                    {
                        //SourceExpr=(Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Data);
                    }
                    Column(LMedicion; (Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Med))
                    {
                        //SourceExpr=(Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Med);
                    }
                    Column(LTotal; (Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Total))
                    {
                        //SourceExpr=(Pasada.Number = 2) AND ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Total);
                    }
                    Column(LIdentacion; DataPieceworkForProduction.Indentation)
                    {
                        //SourceExpr=DataPieceworkForProduction.Indentation;
                    }
                    Column(LQuantityPrevious; "Hist. Certification Lines"."Tmp Quantity Previous")
                    {
                        DecimalPlaces = 3 : 4;
                        //SourceExpr="Hist. Certification Lines"."Tmp Quantity Previous";
                    }
                    Column(LQuantityPeriod; "Hist. Certification Lines"."Tmp Quantity Origin" - "Hist. Certification Lines"."Tmp Quantity Previous")
                    {
                        DecimalPlaces = 3 : 4;
                        //SourceExpr="Hist. Certification Lines"."Tmp Quantity Origin" - "Hist. Certification Lines"."Tmp Quantity Previous";
                    }
                    Column(LQuantityOrigin; "Hist. Certification Lines"."Tmp Quantity Origin")
                    {
                        DecimalPlaces = 3 : 4;
                        //SourceExpr="Hist. Certification Lines"."Tmp Quantity Origin";
                    }
                    Column(LPrice; LinePrice)
                    {
                        //SourceExpr=LinePrice;
                    }
                    Column(LAmountAnt; LineAmountAnt)
                    {
                        //SourceExpr=LineAmountAnt;
                    }
                    Column(LAmountOri; LineAmountOri)
                    {
                        //SourceExpr=LineAmountOri;
                    }
                    Column(LAmountTot; LineAmountTot)
                    {
                        //SourceExpr=LineAmountTot;
                    }
                    Column(LTexto; TextoExtendido)
                    {
                        //SourceExpr=TextoExtendido;
                    }
                    Column(LtmpOrigin; "Hist. Certification Lines"."Tmp Origin amount")
                    {
                        //SourceExpr="Hist. Certification Lines"."Tmp Origin amount";
                    }
                    Column(LtmpPrev; "Hist. Certification Lines"."Tmp Previous amount")
                    {
                        //SourceExpr="Hist. Certification Lines"."Tmp Previous amount";
                    }
                    DataItem("Measurement Lin. Piecew. Prod."; "Measurement Lin. Piecew. Prod.")
                    {

                        DataItemTableView = SORTING("Job No.", "Piecework Code", "Code Budget", "Line No.");
                        DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework No.");
                        Column(MLinea; MContador)
                        {
                            //SourceExpr=MContador;
                        }
                        Column(MMax; MMax)
                        {
                            //SourceExpr=MMax;
                        }
                        Column(MDescription; "Measurement Lin. Piecew. Prod.".Description)
                        {
                            //SourceExpr="Measurement Lin. Piecew. Prod.".Description;
                        }
                        Column(MUnits; "Measurement Lin. Piecew. Prod.".Units)
                        {
                            //SourceExpr="Measurement Lin. Piecew. Prod.".Units;
                        }
                        Column(MLength; "Measurement Lin. Piecew. Prod.".Length)
                        {
                            //SourceExpr="Measurement Lin. Piecew. Prod.".Length;
                        }
                        Column(MWidth; "Measurement Lin. Piecew. Prod.".Width)
                        {
                            //SourceExpr="Measurement Lin. Piecew. Prod.".Width;
                        }
                        Column(MHeight; "Measurement Lin. Piecew. Prod.".Height)
                        {
                            //SourceExpr="Measurement Lin. Piecew. Prod.".Height;
                        }
                        Column(MTotal; "Measurement Lin. Piecew. Prod.".Total)
                        {
                            //SourceExpr="Measurement Lin. Piecew. Prod.".Total;
                        }
                        Column(MSuma; MSuma)
                        {
                            //SourceExpr=MSuma ;
                        }
                        trigger OnPreDataItem();
                        BEGIN
                            IF (Pasada.Number = 1) THEN
                                CurrReport.BREAK;

                            IF ("Hist. Certification Lines"."Tmp Piecework Header" <> "Hist. Certification Lines"."Tmp Piecework Header"::Med) THEN
                                CurrReport.BREAK;

                            "Measurement Lin. Piecew. Prod.".SETRANGE("Measurement Lin. Piecew. Prod."."Code Budget", Job."Current Piecework Budget");
                            MContador := 0;
                            MSuma := 0;
                            MMax := 0;
                            IF ("Measurement Lin. Piecew. Prod.".FINDSET) THEN
                                REPEAT
                                    IF ("Measurement Lin. Piecew. Prod.".Description <> '') OR ("Measurement Lin. Piecew. Prod.".Total <> 0) THEN
                                        MMax += 1;
                                    MSuma += "Measurement Lin. Piecew. Prod.".Total;
                                UNTIL ("Measurement Lin. Piecew. Prod.".NEXT = 0);

                            IF (MMax = 0) THEN
                                CurrReport.BREAK;

                            "Measurement Lin. Piecew. Prod.".FINDFIRST;

                            LineAmountAnt := 0;
                            LineAmountOri := 0;
                            LineAmountTot := 0;
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            IF ("Measurement Lin. Piecew. Prod.".Description = '') AND ("Measurement Lin. Piecew. Prod.".Total = 0) THEN
                                CurrReport.BREAK
                            ELSE
                                MContador += 1;
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        "Hist. Certification Lines".RESET;
                        IF (Pasada.Number = 1) THEN
                            "Hist. Certification Lines".SETRANGE("Tmp Piecework Header", "Hist. Certification Lines"."Tmp Piecework Header"::Header);
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        PieceworkCode := DELCHR("Hist. Certification Lines"."Piecework No.", '>', MarcaFinal);
                        IF NOT DataPieceworkForProduction.GET(PostCertifications."Job No.", PieceworkCode) THEN
                            DataPieceworkForProduction.INIT;

                        //Ordenamos por U.O, pero podemos mostrar otro c¢digo
                        CASE opcCodigo OF
                            opcCodigo::"U.Obra":
                                PieceworkCode := DataPieceworkForProduction."Piecework Code";
                            opcCodigo::Presto:
                                PieceworkCode := DataPieceworkForProduction."Code Piecework PRESTO";
                            opcCodigo::Propio:
                                PieceworkCode := DataPieceworkForProduction."Additional Text Code";
                        END;

                        PieceworkCode := PADSTR('', STRLEN(DataPieceworkForProduction."Piecework Code") - Level0, ' ') + PieceworkCode;

                        CASE opcPrice OF
                            opcPrice::Venta:
                                LinePrice := "Hist. Certification Lines"."Contract Price";
                            opcPrice::Contrato:
                                LinePrice := "Hist. Certification Lines"."Sale Price";
                        END;

                        IF (Pasada.Number = 1) THEN BEGIN
                            IF (DataPieceworkForProduction.Indentation = 0) THEN BEGIN
                                LineAmountAnt := "Hist. Certification Lines"."Tmp Previous amount";
                                LineAmountOri := "Hist. Certification Lines"."Tmp Origin amount";
                                LineAmountTot := 0;
                            END ELSE BEGIN
                                LineAmountAnt := 0;
                                LineAmountOri := 0;
                                LineAmountTot := "Hist. Certification Lines"."Tmp Origin amount";
                            END;
                        END ELSE BEGIN
                            IF ("Hist. Certification Lines"."Tmp Piecework Header" = "Hist. Certification Lines"."Tmp Piecework Header"::Total) THEN BEGIN
                                LineAmountAnt := 0;
                                LineAmountOri := 0;
                                LineAmountTot := "Hist. Certification Lines"."Tmp Origin amount";
                            END ELSE BEGIN
                                LineAmountAnt := ROUND("Hist. Certification Lines"."Tmp Quantity Previous" * LinePrice, Currency."Unit-Amount Rounding Precision");
                                LineAmountOri := ROUND("Hist. Certification Lines"."Tmp Quantity Origin" * LinePrice, Currency."Unit-Amount Rounding Precision");
                                LineAmountTot := 0;
                            END;
                        END;


                        txtDescription := DELCHR(DataPieceworkForProduction.Description + ' ' + DataPieceworkForProduction."Description 2", '>', ' ');

                        IF (Pasada.Number = 2) AND (opcText) THEN BEGIN
                            IF QBText.GET(QBText.Table::Job, "Hist. Certification Lines"."Job No.", "Hist. Certification Lines"."Piecework No.") THEN
                                TextoExtendido := QBText.GetSalesText
                            ELSE
                                TextoExtendido := '';
                        END;
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    CASE opcResumen OF
                        opcResumen::"Resumen+Certificaci¢n":
                            Pasada.SETFILTER(Number, '1..2');
                        opcResumen::Resumen:
                            Pasada.SETFILTER(Number, '1..1');
                        opcResumen::Certificacion:
                            Pasada.SETFILTER(Number, '2..2');
                    END;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                CompanyInformation.GET;
                FormatAddr.Company(CompanyAddr, CompanyInformation);
                CompanyInformation.CALCFIELDS(Picture);

                TxtPie := CompanyAddr[1] + ' ' + CompanyAddr[2] + ' ' + CompanyAddr[3] + ' ' + CompanyAddr[4] + ' ' + CompanyAddr[5] + ' NIF: ' + CompanyInformation."VAT Registration No.";
                TxtFirma := CompanyInformation.City + ', a ' + FORMAT("Measurement Header"."Posting Date", 0, '<Day> de <Month Text> de <Year4>');

                Customer.GET("Measurement Header"."Customer No.");
                FormatAddr.Customer(CustAddr, Customer);

                Job.GET("Measurement Header"."Job No.");
                IF NOT Currency.GET(Job."Currency Code") THEN
                    Currency.INIT;
                Currency.InitRoundingPrecision;


                //Montar la tabla temporal
                PostCertifications.TRANSFERFIELDS("Measurement Header");
                PostCertifications."No." := 'ZZ' + FORMAT(SESSIONID);
                PostCertifications.INSERT;

                MeasurementLines.RESET;
                MeasurementLines.SETRANGE("Document No.", "Measurement Header"."No.");
                IF (MeasurementLines.FINDSET(FALSE)) THEN
                    REPEAT
                        HistCertificationLines.TRANSFERFIELDS(MeasurementLines);
                        HistCertificationLines."Document No." := PostCertifications."No.";
                        HistCertificationLines.INSERT;
                    UNTIL (MeasurementLines.NEXT = 0);

                //-Q18273 AML 18/05/23
                //HistCertificationLines.MontarTemporal("Hist. Certification Lines", Totales, Level0, MarcaFinal, "Measurement Header"."No.", opcDetalleMedicion, opcPrice);
                MontarTemporal("Hist. Certification Lines", Totales, Level0, MarcaFinal, "Measurement Header"."No.", opcDetalleMedicion, opcPrice);
                //+Q18273 AML 18/05/23
            END;

            trigger OnPostDataItem();
            BEGIN
                //Borrar la tabla temporal
                HistCertificationLines.RESET;
                HistCertificationLines.SETRANGE("Document No.", PostCertifications."No.");
                HistCertificationLines.DELETEALL;

                PostCertifications.DELETE;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group454")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcPrice"; "opcPrice")
                    {

                        CaptionML = ESP = 'Usar Precio';
                    }
                    field("opcText"; "opcText")
                    {

                        CaptionML = ESP = 'Con textos extendidos';
                    }
                    field("opcDetalleMedicion"; "opcDetalleMedicion")
                    {

                        CaptionML = ENU = 'with Medition detail', ESP = 'Con detalle de medici¢n';
                        ToolTipML = ENU = 'Specifies whether to print medition detail.', ESP = 'Especifica si se debe imprimir el detalle de la medici¢n o no.';
                    }
                    field("opcResumen"; "opcResumen")
                    {

                        CaptionML = ENU = 'Show Summary', ESP = 'Presentar';
                    }
                    field("opcCodigo"; "opcCodigo")
                    {

                        CaptionML = ESP = 'C¢digo a mostrar';
                    }

                }

            }
        }
    }
    labels
    {
        lblHCustomer = 'Cliente:/';
        lblHJob = '"Cod. Proyecto/';
        lblHDate = 'Fecha Certificaci¢n:/';
        lblHNumber = '"N§ Certificaci¢n/';
        lblHDescription = 'Descripci¢n:/';
        lblPPage = 'Pagina:/';
        lblLCUO = 'Unidad de Obra/';
        lblLCDes = 'Descripci¢n/';
        lblLCOri = 'Medicion/';
        lblLCPrice = 'Precio/';
        lblLCTotal = 'Importe/';
        lblSuma = 'Total/';
        lblMDes = 'Descripci¢n/';
        lblMUd = 'Ud./';
        lblMLar = 'Largo/';
        lblMAnc = 'Ancho/';
        lblMAlt = 'Alto/';
        lblMTot = 'Total/';
        lblLTOrigen = 'Certificado a origen/';
        lblTLAnterior = 'Certificaci¢n anterior/';
        lblTLActual = 'Certificaci¢n actual/';
        lblTCert = 'Total Ejecuci¢n Material:/';
        lblTAnt = 'A Deducir por certificaciones anteriores:/';
        lblTAct = 'Total Certificaci¢n:/';
        lblT04 = 'Gastos generales:/';
        lblT05 = 'Beneficio Industrial:/';
        lblT06 = 'Baja:/';
        lblT07 = 'Total Certificaci¢n:/';
        lblT08 = 'Retenci¢n de Buena Ejecuci¢n:/';
        lblT09 = 'Base Imponible:/';
        lblT10 = 'IVA:/';
        lblT11 = 'Total a Facturar:/';
        lblT12 = 'Retenci¢n de Buena Ejecuci¢n:/';
        lblT13 = 'Total a Pagar:/';
    }

    var
        //       DataPieceworkForProduction@1100286008 :
        DataPieceworkForProduction: Record 7207386;
        //       CompanyInformation@1100286026 :
        CompanyInformation: Record 79;
        //       Currency@1100286023 :
        Currency: Record 4;
        //       Customer@1100286030 :
        Customer: Record 18;
        //       Job@1100286016 :
        Job: Record 167;
        //       Piecework@1100286029 :
        Piecework: Record 7207277;
        //       QBText@1100286007 :
        QBText: Record 7206918;
        //       PostCertifications@1100286015 :
        PostCertifications: Record 7207341;
        //       HistCertificationLines@1100286025 :
        HistCertificationLines: Record 7207342;
        //       MeasurementLines@1100286027 :
        MeasurementLines: Record 7207337;
        //       FormatAddr@1100286037 :
        FormatAddr: Codeunit 365;
        //       CustAddr@1100286036 :
        CustAddr: ARRAY[8] OF Text[50];
        //       CompanyAddr@1100286035 :
        CompanyAddr: ARRAY[8] OF Text[50];
        //       PieceworkCode@1100286010 :
        PieceworkCode: Text;
        //       TxtFirma@1100286034 :
        TxtFirma: Text;
        //       TxtPie@1100286024 :
        TxtPie: Text;
        //       LinePrice@1100286020 :
        LinePrice: Decimal;
        //       LineAmountAnt@1100286001 :
        LineAmountAnt: Decimal;
        //       LineAmountOri@1100286000 :
        LineAmountOri: Decimal;
        //       LineAmountTot@1100286011 :
        LineAmountTot: Decimal;
        //       txtDescription@1100286013 :
        txtDescription: Text;
        //       Level0@1100286014 :
        Level0: Integer;
        //       TextoExtendido@1100286006 :
        TextoExtendido: Text;
        //       MContador@1100286018 :
        MContador: Integer;
        //       MMax@1100286017 :
        MMax: Integer;
        //       MSuma@1100286019 :
        MSuma: Decimal;
        //       Totales@1100286022 :
        Totales: ARRAY[20] OF Decimal;
        //       MarcaFinal@1100286009 :
        MarcaFinal: Text;
        //       "------------------------------- Opciones"@1100286002 :
        "------------------------------- Opciones": Integer;
        //       opcText@1100286005 :
        opcText: Boolean;
        //       opcDetalleMedicion@1100286003 :
        opcDetalleMedicion: Boolean;
        //       opcResumen@1100286004 :
        opcResumen: Option "Resumen+Certificaci¢n","Certificacion","Resumen";
        //       opcCodigo@1100286012 :
        opcCodigo: Option "U.Obra","Presto","Propio";
        //       opcPrice@1100286021 :
        opcPrice: Option "Venta","Contrato";



    trigger OnInitReport();
    begin
        opcPrice := opcPrice::Contrato;
        opcResumen := opcResumen::"Resumen+Certificaci¢n";
        opcText := TRUE;
        opcDetalleMedicion := TRUE;
        opcCodigo := opcCodigo::Presto;
    end;



    // procedure MontarTemporal (var pTabla@1100286005 : Record 7207342;var pTotales@1100286006 : ARRAY [20] OF Decimal;var pLevel0@1100286012 : Integer;var pMarcaFinal@1100286022 : Text;pNro@1100286007 : Code[20];pDetMedicion@1100286009 : Boolean;pPrice@1100286010 :
    procedure MontarTemporal(var pTabla: Record 7207342; var pTotales: ARRAY[20] OF Decimal; var pLevel0: Integer; var pMarcaFinal: Text; pNro: Code[20]; pDetMedicion: Boolean; pPrice: Option "Venta","Contrato")
    var
        //       PostCertifications1@1100286015 :
        PostCertifications1: Record 7207336;
        //       PostCertifications@1100286014 :
        PostCertifications: Record 7207336;
        //       Job@1100286018 :
        Job: Record 167;
        //       Customer@1100286019 :
        Customer: Record 18;
        //       VATPostingSetup@1100286020 :
        VATPostingSetup: Record 325;
        //       WithholdingGroup@1100286021 :
        WithholdingGroup: Record 7207330;
        //       HistCertifications@1100286008 :
        HistCertifications: Record 7207337;
        //       tmpDataPieceworkForProduction@1100286004 :
        tmpDataPieceworkForProduction: Record 7207386 TEMPORARY;
        //       DataPieceworkForProduction@1100286016 :
        DataPieceworkForProduction: Record 7207386;
        //       Currency@1100286013 :
        Currency: Record 4;
        //       i@1100286000 :
        i: Integer;
        //       nLinea@1100286001 :
        nLinea: Integer;
        //       ImpOri@1100286003 :
        ImpOri: Decimal;
        //       ImpAnt@1100286002 :
        ImpAnt: Decimal;
        //       LinePrice@1100286011 :
        LinePrice: Decimal;
        //       MarcaFinal@1100286017 :
        MarcaFinal: TextConst ESP = 'z';
    begin
        //Q18273 AML 18/05/23 Se cambian las variables PostCertifications1, PostCertifications y HistCertifications para que llame a las certificaciones sin registrar. Las registradas no EXISTEN AUN!!!
        //Cargar el temporal con las l¡neas de las certificaciones a imprimir
        pTabla.RESET;
        pTabla.DELETEALL;
        CLEAR(pTotales);
        pMarcaFinal := MarcaFinal;
        if not PostCertifications1.GET(pNro) then
            exit;
        if not Job.GET(PostCertifications1."Job No.") then
            exit;

        Customer.GET(PostCertifications1."Customer No.");

        //Porcentajes generales
        pTotales[14] := Job."General Expenses / Other";
        pTotales[15] := Job."Industrial Benefit";
        pTotales[16] := Job."Low Coefficient";

        //% IVA
        pTotales[17] := 0;
        if (VATPostingSetup.GET(Customer."VAT Bus. Posting Group", Job."VAT Prod. PostingGroup")) then
            pTotales[17] := VATPostingSetup."VAT %";

        //% Retenciones
        pTotales[18] := 0;
        pTotales[19] := 0;
        if (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", Customer."QW Withholding Group by GE")) then
            CASE WithholdingGroup."Withholding treating" OF
                WithholdingGroup."Withholding treating"::"Payment Withholding":
                    pTotales[19] := WithholdingGroup."Percentage Withholding";
                WithholdingGroup."Withholding treating"::"Pending Invoice":
                    pTotales[18] := WithholdingGroup."Percentage Withholding";
            end;


        tmpDataPieceworkForProduction.RESET;
        tmpDataPieceworkForProduction.DELETEALL;
        if not Currency.GET(PostCertifications1."Currency Code") then
            Currency.INIT;
        Currency.InitRoundingPrecision;

        nLinea := 0;

        //Primero a¤ado las unidades de esta certificaci¢n al temporal como medici¢n a origen
        HistCertifications.RESET;
        HistCertifications.SETRANGE("Document No.", pNro);
        HistCertifications.SETFILTER("Piecework No.", '<>%1', '');
        if (HistCertifications.FINDSET) then
            repeat
                nLinea += 1;

                //pTabla := HistCertifications;
                pTabla.TRANSFERFIELDS(HistCertifications);
                pTabla."Document No." := '';
                pTabla."Line No." := nLinea;
                pTabla."Tmp Quantity Origin" := HistCertifications."Cert Quantity to Term";
                pTabla."Tmp Quantity Previous" := 0;
                pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Data;
                pTabla.INSERT;
                if pDetMedicion then begin
                    nLinea += 1;
                    pTabla."Line No." := nLinea;
                    pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Med;
                    pTabla.INSERT;
                end;
                //A¤ado al temporal de unidades de obra las de la certificaci¢n para saber las que llevo metidas
                tmpDataPieceworkForProduction."Piecework Code" := HistCertifications."Piecework No.";
                if not tmpDataPieceworkForProduction.INSERT then;

                //Sumo a los ptotales
                CASE pPrice OF
                    pPrice::Venta:
                        LinePrice := pTabla."Contract Price";
                    pPrice::Contrato:
                        LinePrice := pTabla."Sale Price";
                end;

                pTotales[1] += ROUND(HistCertifications."Cert Quantity to Term" * LinePrice, Currency."Unit-Amount Rounding Precision");
            until (HistCertifications.NEXT = 0);


        //Ahora a¤ado las certificaciones anteriores a la actual
        PostCertifications.RESET;
        PostCertifications.SETRANGE("Job No.", PostCertifications1."Job No.");
        PostCertifications.SETRANGE("Customer No.", PostCertifications1."Customer No.");
        PostCertifications.SETFILTER("No.", '<%1', PostCertifications1."No.");
        PostCertifications.SETFILTER("Cancel By", '');
        PostCertifications.SETFILTER("Cancel No.", '');
        if (PostCertifications.FINDLAST) then
            repeat
                HistCertifications.RESET;
                HistCertifications.SETRANGE("Document No.", PostCertifications."No.");
                HistCertifications.SETFILTER("Piecework No.", '<>%1', '');
                if (HistCertifications.FINDSET) then
                    repeat
                        pTabla.RESET;
                        pTabla.SETRANGE("Piecework No.", HistCertifications."Piecework No.");
                        if (not pTabla.FINDFIRST) then begin
                            nLinea += 1;

                            //pTabla := HistCertifications;
                            pTabla.TRANSFERFIELDS(HistCertifications);
                            pTabla."Document No." := '';
                            pTabla."Line No." := nLinea;
                            pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Data;
                            pTabla."Tmp Quantity Origin" := 0;
                            pTabla."Tmp Quantity Previous" := 0;
                            pTabla.INSERT;

                            if pDetMedicion then begin
                                nLinea += 1;
                                pTabla."Line No." := nLinea;
                                pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Med;
                                pTabla.INSERT;
                            end;
                            //A¤ado al temporal de unidades de obra las de la certificaci¢n para saber las que llevo metidas
                            tmpDataPieceworkForProduction."Piecework Code" := HistCertifications."Piecework No.";
                            if not tmpDataPieceworkForProduction.INSERT then;
                        end;

                        //La a¤ado como medici¢n anterior y a origen
                        pTabla.RESET;
                        pTabla.SETRANGE("Piecework No.", HistCertifications."Piecework No.");
                        pTabla.FINDFIRST;
                        pTabla."Tmp Quantity Origin" += HistCertifications."Cert Quantity to Term";
                        pTabla."Tmp Quantity Previous" += HistCertifications."Cert Quantity to Term";
                        pTabla.MODIFY;

                        //Sumo a los ptotales
                        CASE pPrice OF
                            pPrice::Venta:
                                LinePrice := pTabla."Contract Price";
                            pPrice::Contrato:
                                LinePrice := pTabla."Sale Price";
                        end;

                        pTotales[1] += ROUND(HistCertifications."Cert Quantity to Term" * LinePrice, Currency."Unit-Amount Rounding Precision");
                        pTotales[2] -= ROUND(HistCertifications."Cert Quantity to Term" * LinePrice, Currency."Unit-Amount Rounding Precision");
                    until (HistCertifications.NEXT = 0);
            until (PostCertifications.NEXT(-1) = 0);


        //Ahora a¤ado las unidades de mayor asociadas a cada una de las l¡neas de la certificaci¢n
        pLevel0 := MAXSTRLEN(DataPieceworkForProduction."Piecework Code");  //Este es el tama¤o de la primera unidad de obra a presentar, para la identaci¢n.
        tmpDataPieceworkForProduction.RESET;
        if (tmpDataPieceworkForProduction.FINDSET) then
            repeat
                FOR i := 1 TO STRLEN(tmpDataPieceworkForProduction."Piecework Code") - 1 DO begin
                    if (DataPieceworkForProduction.GET(PostCertifications1."Job No.", COPYSTR(tmpDataPieceworkForProduction."Piecework Code", 1, i))) then begin
                        pTabla.RESET;
                        pTabla.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                        if (not pTabla.FINDFIRST) then begin
                            //Calculo en importe de las U.O. por debajo
                            DataPieceworkForProduction.VALIDATE(Totaling); //por si acaso
                            ImpOri := 0;
                            ImpAnt := 0;
                            pTabla.RESET;
                            pTabla.SETRANGE("Tmp Piecework Header", pTabla."Tmp Piecework Header"::Data);
                            pTabla.SETFILTER("Piecework No.", DataPieceworkForProduction.Totaling);
                            if (pTabla.FINDSET) then
                                repeat
                                    CASE pPrice OF
                                        pPrice::Venta:
                                            LinePrice := pTabla."Contract Price";
                                        pPrice::Contrato:
                                            LinePrice := pTabla."Sale Price";
                                    end;

                                    ImpAnt += ROUND(pTabla."Tmp Quantity Previous" * LinePrice, Currency."Unit-Amount Rounding Precision");
                                    ImpOri += ROUND(pTabla."Tmp Quantity Origin" * LinePrice, Currency."Unit-Amount Rounding Precision");
                                until pTabla.NEXT = 0;

                            nLinea += 1;
                            pTabla.INIT;
                            pTabla."Line No." := nLinea;
                            pTabla."Piecework No." := DataPieceworkForProduction."Piecework Code";
                            pTabla."Tmp Origin amount" := ImpOri;
                            pTabla."Tmp Previous amount" := ImpAnt;
                            pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Header;
                            pTabla.INSERT;

                            nLinea += 1;
                            pTabla."Line No." := nLinea;
                            pTabla."Piecework No." := DataPieceworkForProduction."Piecework Code" + pMarcaFinal;
                            pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Total;
                            pTabla.INSERT;

                            if (STRLEN(DataPieceworkForProduction."Piecework Code") < pLevel0) then
                                pLevel0 := STRLEN(DataPieceworkForProduction."Piecework Code");
                        end;
                    end;
                end;
            until tmpDataPieceworkForProduction.NEXT = 0;

        //Calculo de ptotales, tenemos ya ptotales[1]=Total a origen y ptotales[2]=Total anterior
        //pTotales[14] = %GG , pTotales[15] = %BI, pTotales[16] = % Baja
        //ptotales[17] = % IVA, ptotales[18] = % RetFac, ptotales[19] = % RetPago

        pTotales[3] := pTotales[1] + pTotales[2];                                                                                               //Total certificaci¢n
        if (pPrice = pPrice::Contrato) then begin
            pTotales[4] := ROUND(pTotales[3] * Job."General Expenses / Other" / 100, Currency."Unit-Amount Rounding Precision");                 //Gastos generales
            pTotales[5] := ROUND(pTotales[3] * Job."Industrial Benefit" / 100, Currency."Unit-Amount Rounding Precision");                       //Beneficio Industrial
            pTotales[6] := -ROUND((pTotales[3] + pTotales[4] + pTotales[5]) * Job."Low Coefficient" / 100, Currency."Unit-Amount Rounding Precision"); //Baja
        end;
        pTotales[7] := pTotales[3] + pTotales[4] + pTotales[5] - pTotales[6];                                                                         //Importe certificaci¢n
        pTotales[8] := ROUND(pTotales[7] * pTotales[18] / 100, Currency."Unit-Amount Rounding Precision");                                    //Retenci¢n en factura
        pTotales[9] := pTotales[7] - pTotales[8];                                                                                             //Base imponible
        pTotales[10] := ROUND(pTotales[9] * pTotales[17] / 100, Currency."Unit-Amount Rounding Precision");                                    //IVA
        pTotales[11] := pTotales[9] + pTotales[10];                                                                                            //Total Factura
        pTotales[12] := ROUND(pTotales[11] * pTotales[19] / 100, Currency."Unit-Amount Rounding Precision");                                   //Retenci¢n de pago
        pTotales[13] := pTotales[11] - pTotales[12];                                                                                           //Total a pagar

        if (pTotales[7] = pTotales[3]) or (pTotales[8] = 0) then
            pTotales[7] := 0;
        if (pTotales[3] = pTotales[9]) or (pTotales[10] = 0) then
            pTotales[9] := 0;
        if (pTotales[12] = 0) then
            pTotales[13] := 0;
    end;

    /*begin
    //{
//      Q18273 AML 18/05/23 Se cambia la Funcion MontarTemporal, se cambia de la tabla al informe y se cambian las variables
//    }
    end.
  */

}



