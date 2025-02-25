report 7207298 "Certification Model 2"
{


    CaptionML = ENU = 'Certification Model 2', ESP = 'Certificaci¢n modelo 2';

    dataset
    {

        DataItem("Post. Certifications"; "Post. Certifications")
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
            Column(HDoc_No; "Post. Certifications"."No.")
            {
                //SourceExpr="Post. Certifications"."No.";
            }
            Column(HCertification_No; "Post. Certifications"."No. Measure")
            {
                //SourceExpr="Post. Certifications"."No. Measure";
            }
            Column(HJob_No; "Post. Certifications"."Job No.")
            {
                //SourceExpr="Post. Certifications"."Job No.";
            }
            Column(HDate; "Post. Certifications"."Measurement Date")
            {
                //SourceExpr="Post. Certifications"."Measurement Date";
            }
            Column(HCertificationText; "Post. Certifications"."Text Measure")
            {
                //SourceExpr="Post. Certifications"."Text Measure";
            }
            Column(HCustomer_No; "Post. Certifications"."Customer No.")
            {
                //SourceExpr="Post. Certifications"."Customer No.";
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
                        IF NOT DataPieceworkForProduction.GET("Post. Certifications"."Job No.", PieceworkCode) THEN
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
                TxtFirma := CompanyInformation.City + ', a ' + FORMAT("Post. Certifications"."Posting Date", 0, '<Day> de <Month Text> de <Year4>');

                Customer.GET("Post. Certifications"."Customer No.");
                FormatAddr.Customer(CustAddr, Customer);

                Job.GET("Post. Certifications"."Job No.");
                IF NOT Currency.GET(Job."Currency Code") THEN
                    Currency.INIT;
                Currency.InitRoundingPrecision;


                //Montar la tabla temporal
                "Hist. Certification Lines".MontarTemporal("Hist. Certification Lines", Totales, Level0, MarcaFinal, "Post. Certifications"."No.", opcDetalleMedicion, opcPrice);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group433")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcPrice"; "opcPrice")
                    {

                        CaptionML = ESP = 'Usar Precio';
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
        //Estas dos no se pueden tocar porque no imprime ya estos datos
        opcText := FALSE;
        opcDetalleMedicion := FALSE;


        opcPrice := opcPrice::Contrato;
        opcResumen := opcResumen::"Resumen+Certificaci¢n";
        opcCodigo := opcCodigo::Presto;
    end;



    /*begin
        end.
      */

}



