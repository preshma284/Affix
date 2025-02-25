report 7207422 "Borrador de Medicion"
{


    CaptionML = ESP = 'Borrador de Medici¢n';

    dataset
    {

        DataItem("Measurement Header"; "Measurement Header")
        {

            DataItemTableView = SORTING("No.")
                                 WHERE("Document Type" = CONST("Measuring"));


            RequestFilterFields = "No.";
            Column(opcDetalleMedicion; opcDetalleMedicion)
            {
                //SourceExpr=opcDetalleMedicion;
            }
            Column(opcResumen; opcResumen)
            {
                //SourceExpr=opcResumen;
            }
            Column(FORMAT_TODAY_0___Day__Month_Text__Year4___; FORMAT(TODAY, 0, '<Day>  <Month Text>, <Year4>'))
            {
                //SourceExpr=FORMAT(TODAY,0,'<Day>  <Month Text>, <Year4>');
            }
            Column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
                //SourceExpr=CurrReport.PAGENO;
            }
            Column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
                //SourceExpr=CurrReport_PAGENOCaptionLbl;
            }
            Column(Measurement_Header_Document_Type; "Document Type")
            {
                //SourceExpr="Document Type";
            }
            Column(Measurement_Header_No; "No.")
            {
                //SourceExpr="No.";
            }
            Column(Measurement_Header_Job_No; "Job No.")
            {
                //SourceExpr="Job No.";
            }
            Column(Name_MeasurementHeader; "Measurement Header".Name)
            {
                //SourceExpr="Measurement Header".Name;
            }
            Column(Name2_MeasurementHeader; "Measurement Header"."Name 2")
            {
                //SourceExpr="Measurement Header"."Name 2";
            }
            Column(PostingDate_MeasurementHeader; "Measurement Header"."Posting Date")
            {
                //SourceExpr="Measurement Header"."Posting Date";
            }
            Column(CertificationDate_MeasurementHeader; "Measurement Header"."Certification Date")
            {
                //SourceExpr="Measurement Header"."Certification Date";
            }
            Column(CertificationNo_MeasurementHeader; "Measurement Header"."No. Measure")
            {
                //SourceExpr="Measurement Header"."No. Measure";
            }
            Column(Description_MeasurementHeader; "Measurement Header".Description)
            {
                //SourceExpr="Measurement Header".Description;
            }
            Column(Description2_MeasurementHeader; "Measurement Header"."Description 2")
            {
                //SourceExpr="Measurement Header"."Description 2";
            }
            Column(Picture_CompanyInformation; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(Name_CompanyInformation; CompanyInformation.Name)
            {
                //SourceExpr=CompanyInformation.Name;
            }
            Column(Certificacion_Caption; Certificacion_CaptionLbl)
            {
                //SourceExpr=Certificacion_CaptionLbl;
            }
            Column(Unidades_Caption; Unidades_CaptionLbl)
            {
                //SourceExpr=Unidades_CaptionLbl;
            }
            Column(Longitud_Caption; Longitud_CaptionLbl)
            {
                //SourceExpr=Longitud_CaptionLbl;
            }
            Column(Ancho_Caption; Ancho_CaptionLbl)
            {
                //SourceExpr=Ancho_CaptionLbl;
            }
            Column(Altura_Caption; Altura_CaptionLbl)
            {
                //SourceExpr=Altura_CaptionLbl;
            }
            Column(Cantidad_Caption; Cantidad_CaptionLbl)
            {
                //SourceExpr=Cantidad_CaptionLbl;
            }
            Column(Precio_Caption; Precio_CaptionLbl)
            {
                //SourceExpr=Precio_CaptionLbl;
            }
            Column(Subtotal_Caption; Subtotal_CaptionLbl)
            {
                //SourceExpr=Subtotal_CaptionLbl;
            }
            Column(CertificadoOrigen_Caption; CertificadoOrigen_CaptionLbl)
            {
                //SourceExpr=CertificadoOrigen_CaptionLbl;
            }
            Column(CertificacionAnteriores_Caption; CertificacionesAnteriores_CaptionLbl)
            {
                //SourceExpr=CertificacionesAnteriores_CaptionLbl;
            }
            Column(CertificacionActual_Caption; CertificacionActual_CaptionLbl)
            {
                //SourceExpr=CertificacionActual_CaptionLbl;
            }
            Column(NombreCliente1; NombreCliente1)
            {
                //SourceExpr=NombreCliente1;
            }
            Column(NombreCliente2; NombreCliente2)
            {
                //SourceExpr=NombreCliente2;
            }
            Column(CertificacionAnterior; certificacionanterior)
            {
                //SourceExpr=certificacionanterior;
            }
            Column(TotalCantCertAnterior; TotalCantCertAnterior)
            {
                //SourceExpr=TotalCantCertAnterior;
            }
            Column(TotalGeneral; TotalGeneral)
            {
                //SourceExpr=TotalGeneral;
            }
            Column(PorcGtosGrales; PorcGtosGrales)
            {
                //SourceExpr=PorcGtosGrales;
            }
            Column(GtosGrales; GtosGrales)
            {
                //SourceExpr=GtosGrales;
            }
            Column(PorcBIndustrial; PorcBIndustrial)
            {
                //SourceExpr=PorcBIndustrial;
            }
            Column(BIndustrial; BIndustrial)
            {
                //SourceExpr=BIndustrial;
            }
            Column(PorcIVA; PorcIVA)
            {
                //SourceExpr=PorcIVA;
            }
            Column(PorcBaja; PorcBaja)
            {
                //SourceExpr=PorcBaja;
            }
            Column(BlnBaja; BlnBaja)
            {
                //SourceExpr=BlnBaja;
            }
            Column(lblCBaja; lblCBaja)
            {
                //SourceExpr=lblCBaja;
            }
            Column(PorcCI; PorcCI)
            {
                //SourceExpr=PorcCI;
            }
            Column(BlnCI; BlnCI)
            {
                //SourceExpr=BlnCI;
            }
            Column(lblCI; lblCI)
            {
                //SourceExpr=lblCI;
            }
            DataItem("Measurement Lines"; "Measurement Lines")
            {

                DataItemTableView = SORTING("Document No.", "Line No.");


                DataItemLinkReference = "Measurement Header";
                DataItemLink = "Document No." = FIELD("No.");
                Column(PieceworkNo_MeasurementLines; "Measurement Lines"."Piecework No.")
                {
                    //SourceExpr="Measurement Lines"."Piecework No.";
                }
                Column(Description_MeasurementLines; "Measurement Lines".Description)
                {
                    //SourceExpr="Measurement Lines".Description;
                }
                Column(Description2_MeasurementLines; "Measurement Lines"."Description 2")
                {
                    //SourceExpr="Measurement Lines"."Description 2";
                }
                Column(Amount_MeasurementLines; "Measurement Lines"."Med. Term PEC Amount")
                {
                    //SourceExpr="Measurement Lines"."Med. Term PEC Amount";
                }
                Column(City_CompanyInformation; CompanyInformation.City)
                {
                    //SourceExpr=CompanyInformation.City;
                }
                Column(Capitulo_captionLbl; Capitulo_CaptionLbl)
                {
                    //SourceExpr=Capitulo_CaptionLbl;
                }
                Column(Resumen_CaptionLbl; Resumen_CaptionLbl)
                {
                    //SourceExpr=Resumen_CaptionLbl;
                }
                Column(Importe_Caption; Importe_CaptionLbl)
                {
                    //SourceExpr=Importe_CaptionLbl;
                }
                Column(SalesPrice_MeasurementLines; "Measurement Lines"."Contract Price")
                {
                    //SourceExpr="Measurement Lines"."Contract Price";
                }
                Column(ContractPrice_MeasurementLines; "Measurement Lines"."Sales Price")
                {
                    //SourceExpr="Measurement Lines"."Sales Price";
                }
                Column(CantCertAnterior; CantCertAnterior)
                {
                    //SourceExpr=CantCertAnterior;
                }
                Column(CantCertOrigen; CantCertOrigen)
                {
                    //SourceExpr=CantCertOrigen;
                }
                Column(DescMed; DescMed)
                {
                    //SourceExpr=DescMed;
                }
                Column(TotalCapi; TotalCapi)
                {
                    //SourceExpr=TotalCapi;
                }
                Column(TotalLinea; TotalLinea)
                {
                    //SourceExpr=TotalLinea;
                }
                Column(TotalTotalLinea; TotalTotalLinea)
                {
                    //SourceExpr=TotalTotalLinea;
                }
                Column(TotalTotalCapi; TotalTotalCapi)
                {
                    //SourceExpr=TotalTotalCapi;
                }
                Column(Capitulos; Capitulo)
                {
                    //SourceExpr=Capitulo;
                }
                Column(CaptionCapitulo; CaptionCapitulo)
                {
                    //SourceExpr=CaptionCapitulo;
                }
                Column(ADeducir_Caption; ADeducir_CaptionLbl)
                {
                    //SourceExpr=ADeducir_CaptionLbl;
                }
                Column(TextoExtendido; TextoExtendido)
                {
                    //SourceExpr=TextoExtendido;
                }
                DataItem("Measure Lines Bill of Item"; "Measure Lines Bill of Item")
                {

                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.", "Piecework Code", "Bill of Item No Line")
                                 WHERE("Document Type" = CONST("Measuring"));


                    DataItemLinkReference = "Measurement Lines";
                    DataItemLink = "Document No." = FIELD("Document No."),
                            "Line No." = FIELD("Line No."),
                            "Piecework Code" = FIELD("Piecework No.");
                    Column(MLBI_PieceworkCode; "Measure Lines Bill of Item"."Piecework Code")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Piecework Code";
                    }
                    Column(MLBI_LineNoBillOfItem; "Measure Lines Bill of Item"."Bill of Item No Line")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Bill of Item No Line";
                    }
                    Column(MLBI_JobNo; "Measure Lines Bill of Item"."Job No.")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Job No.";
                    }
                    Column(MLBI_Descrip; "Measure Lines Bill of Item".Description)
                    {
                        //SourceExpr="Measure Lines Bill of Item".Description;
                    }
                    Column(MLBI_Units; "Measure Lines Bill of Item"."Period Units")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Period Units";
                    }
                    Column(MLBI_Length; "Measure Lines Bill of Item"."Budget Length")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Budget Length";
                    }
                    Column(MLBI_Width; "Measure Lines Bill of Item"."Budget Width")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Budget Width";
                    }
                    Column(MLBI_Height; "Measure Lines Bill of Item"."Budget Height")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Budget Height";
                    }
                    Column(MLBI_Total; "Measure Lines Bill of Item"."Period Total")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Period Total";
                    }
                    Column(MLBI_BUDGETtotal; "Measure Lines Bill of Item"."Budget Total")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Budget Total";
                    }
                    Column(MLBI_MeasuredUnits; "Measure Lines Bill of Item"."Measured Units")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Measured Units";
                    }
                    Column(MLBI_MeasuredTotal; "Measure Lines Bill of Item"."Measured Total")
                    {
                        //SourceExpr="Measure Lines Bill of Item"."Measured Total";
                    }
                    Column(contador; contador)
                    {
                        //SourceExpr=contador;
                    }
                    Column(DescVacia; DescVacia)
                    {
                        //SourceExpr=DescVacia;
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                        IF NOT (opcDetalleMedicion) THEN
                            CurrReport.BREAK;

                        "Measure Lines Bill of Item".SETRANGE("Measure Lines Bill of Item"."Document Type", "Measurement Lines"."Document type"::Measuring);
                        "Measure Lines Bill of Item".SETRANGE("Measure Lines Bill of Item"."Document No.", "Measurement Lines"."Document No.");
                        contador := 0;
                        //Q18912 CSM 06/03/23 Í Informes medici¢n. +
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                        //PrimeraLinea;
                        DescVacia := 0;

                        IF ("Measure Lines Bill of Item".Description = '') AND ("Measure Lines Bill of Item"."Budget Total" = 0) THEN BEGIN
                            DescVacia := 1;
                            CurrReport.SKIP;
                        END;

                        IF ("Measure Lines Bill of Item".Description <> '') OR ("Measure Lines Bill of Item"."Budget Total" <> 0) THEN
                            contador += 1;
                        //Q18912 CSM 06/03/23 Í Informes medici¢n. +
                    END;
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    MeasurementNoCode := '';
                    conta := 0;

                    TotalCapi := 0;
                    TotalTotalCapi := 0;
                    CantCertAnterior := 0;
                    TotalCantCertAnterior := 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF FirstLineMeasure = 0 THEN
                        FirstLineMeasure := "Measurement Lines"."Line No.";

                    IF TotalLinea THEN
                        TotalCapi := 0;

                    IF TotalTotalLinea THEN
                        TotalTotalCapi := 0;

                    CantCertAnterior := 0;
                    TotalLinea := FALSE;
                    TotalTotalLinea := FALSE;

                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Measurement Lines"."Job No.");
                    DataPieceworkForProduction.SETRANGE("Piecework Code", COPYSTR("Measurement Lines"."Piecework No.", 1, 4));
                    IF DataPieceworkForProduction.FINDFIRST THEN
                        Capitulo := DataPieceworkForProduction."Piecework Code";

                    //IF COPYSTR("Measurement Lines"."Piecework No.",1,4) <> Capitulo THEN
                    //  TotalCapi := 0;

                    //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                    ImporteCert2 := 0;

                    //buscar datos en tabla Hist. Mediciones. 7207338 y 7207339.
                    HistMeasurementHeader.RESET;
                    HistMeasurementHeader.SETRANGE("Job No.", "Measurement Lines"."Job No.");
                    IF HistMeasurementHeader.FINDSET THEN BEGIN
                        REPEAT
                            IF HistMeasurementHeader."No. Measure" <> "Measurement Header"."No. Measure" THEN BEGIN
                                HistMeasurementLines.RESET;
                                HistMeasurementLines.SETCURRENTKEY("Piecework No.");
                                HistMeasurementLines.SETRANGE("Document No.", HistMeasurementHeader."No.");
                                HistMeasurementLines.SETRANGE("Piecework No.", "Measurement Lines"."Piecework No.");
                                IF HistMeasurementLines.FINDFIRST THEN BEGIN
                                    CantCertAnterior += HistMeasurementLines."Med. Term Measure";
                                END;
                            END;
                        UNTIL (HistMeasurementHeader.NEXT = 0) OR (HistMeasurementHeader."No. Measure" >= "Measurement Header"."No. Measure");
                    END;
                    //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                    MeasurementHeader.RESET;
                    MeasurementHeader.SETRANGE("Job No.", "Measurement Lines"."Job No.");
                    IF MeasurementHeader.FINDSET THEN BEGIN
                        REPEAT
                            IF MeasurementHeader."No. Measure" <> "Measurement Header"."No. Measure" THEN BEGIN
                                MeasurementLines.RESET;
                                MeasurementLines.SETCURRENTKEY("Piecework No.");
                                MeasurementLines.SETRANGE("Document No.", MeasurementHeader."No.");
                                MeasurementLines.SETRANGE("Piecework No.", "Measurement Lines"."Piecework No.");
                                IF MeasurementLines.FINDFIRST THEN BEGIN
                                    CantCertAnterior += MeasurementLines."Med. Term Measure";
                                END;
                            END;
                        UNTIL (MeasurementHeader.NEXT = 0) OR (MeasurementHeader."No. Measure" = "Measurement Header"."No. Measure");
                    END;

                    //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                    TotalCantCertAnterior += CantCertAnterior * "Measurement Lines"."Sales Price";
                    ImporteCert2 += CantCertAnterior * "Measurement Lines"."Sales Price";
                    //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                    CantCertOrigen := CantCertAnterior + "Measurement Lines"."Med. Term Measure";

                    TotalCapi += CantCertOrigen * "Measurement Lines"."Sales Price";
                    TotalTotalCapi += CantCertOrigen * "Measurement Lines"."Sales Price";
                    TotalGeneral += CantCertOrigen * "Measurement Lines"."Sales Price";

                    ImporteCertLinea := CantCertOrigen * "Sales Price";

                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Measurement Lines"."Job No.");
                    DataPieceworkForProduction.SETRANGE("Piecework Code", COPYSTR("Measurement Lines"."Piecework No.", 1, 2));
                    IF DataPieceworkForProduction.FINDFIRST THEN BEGIN
                        CaptionCapitulo := DataPieceworkForProduction."Piecework Code";

                        //guardar IMPORTE en TEMPORAL para tipo Mayor.
                        IF TEMP_DataPieceworkForProd.GET("Job No.", COPYSTR("Measurement Lines"."Piecework No.", 1, 2)) THEN BEGIN
                            TEMP_DataPieceworkForProd."Initial Produc. Price" += ImporteCertLinea;
                            TEMP_DataPieceworkForProd.MODIFY(FALSE);
                        END ELSE BEGIN
                            TEMP_DataPieceworkForProd."Job No." := "Job No.";
                            TEMP_DataPieceworkForProd."Piecework Code" := COPYSTR("Measurement Lines"."Piecework No.", 1, 2);
                            TEMP_DataPieceworkForProd."Initial Produc. Price" := ImporteCertLinea;
                            TEMP_DataPieceworkForProd.INSERT(FALSE);
                        END;
                    END;
                    ImporteCertLinea := 0;

                    MeasurementLines2.RESET;
                    MeasurementLines2.SETRANGE("Document No.", "Measurement Lines"."Document No.");
                    IF MeasurementLines2.FINDSET THEN BEGIN
                        REPEAT
                            IF MeasurementLines2."Piecework No." = "Measurement Lines"."Piecework No." THEN BEGIN
                                MeasurementLines2.NEXT;

                                MeasurementLines3.RESET;
                                MeasurementLines3.SETRANGE("Document No.", "Measurement Lines"."Document No.");
                                IF MeasurementLines3.FINDLAST THEN BEGIN
                                    IF (COPYSTR(MeasurementLines2."Piecework No.", 1, 2) <> COPYSTR("Measurement Lines"."Piecework No.", 1, 2))
                                    OR ("Measurement Lines"."Piecework No." = MeasurementLines3."Piecework No.") THEN BEGIN
                                        TotalTotalLinea := TRUE;
                                        TotalLinea := TRUE;
                                        BREAK;
                                    END ELSE IF (COPYSTR(MeasurementLines2."Piecework No.", 1, 4) <> COPYSTR("Measurement Lines"."Piecework No.", 1, 4))
                                    OR ("Measurement Lines"."Piecework No." = MeasurementLines3."Piecework No.") THEN BEGIN
                                        TotalLinea := TRUE;
                                        BREAK;
                                    END;
                                END;
                            END;
                        UNTIL MeasurementLines2.NEXT = 0;
                    END;

                    IF QBText.GET(QBText.Table::Job, "Measurement Lines"."Job No.", "Measurement Lines"."Piecework No.") THEN
                        TextoExtendido := QBText.GetCostText;
                END;

            }

            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = SORTING("Job No.", "Account Type", "Customer Certification Unit", "Piecework Code");
                DataItemLink = "Job No." = FIELD("Job No.");
                Column(Identation_DataPieceworkForProduction; "Data Piecework For Production".Indentation)
                {
                    //SourceExpr="Data Piecework For Production".Indentation;
                }
                Column(unidad; unidad)
                {
                    //SourceExpr=unidad;
                }
                Column(Data_Piecework_For_Production___Piecework_Code; "Data Piecework For Production"."Piecework Code")
                {
                    //SourceExpr="Data Piecework For Production"."Piecework Code";
                }
                Column(Type_Datapieceworkforproduction; "Data Piecework For Production".Type)
                {
                    //SourceExpr="Data Piecework For Production".Type;
                }
                Column(AccountType_DataPieceworkForProduction; "Data Piecework For Production"."Account Type")
                {
                    //SourceExpr="Data Piecework For Production"."Account Type";
                }
                Column(Description2_DataPieceworkForProduction; "Data Piecework For Production"."Description 2")
                {
                    //SourceExpr="Data Piecework For Production"."Description 2";
                }
                Column(Description_DataPieceworkForProduction; "Data Piecework For Production".Description)
                {
                    //SourceExpr="Data Piecework For Production".Description;
                }
                Column(cantidadOrigen2; cantidadorigen2)
                {
                    //SourceExpr=cantidadorigen2;
                }
                Column(ContractPrice_DataPieceworkForProduction; "Data Piecework For Production"."Contract Price")
                {
                    //SourceExpr="Data Piecework For Production"."Contract Price";
                }
                Column(PC_DataPieceworkForProduction; "Data Piecework For Production"."Piecework Code")
                {
                    //SourceExpr="Data Piecework For Production"."Piecework Code";
                }
                Column(Tipo; Tipo)
                {
                    //SourceExpr=Tipo;
                }
                Column(Indentacion; Indentacion)
                {
                    //SourceExpr=Indentacion;
                }
                Column(DPFPCode; DPFPCode)
                {
                    //SourceExpr=DPFPCode;
                }
                Column(DPFPDescription; DPFPDescription)
                {
                    //SourceExpr=DPFPDescription;
                }
                Column(TipoIVA; TipoIVA)
                {
                    //SourceExpr=TipoIVA;
                }
                Column(ImporteCertLinea; ImporteCertLinea)
                {
                    //SourceExpr=ImporteCertLinea;
                }
                Column(ImporteCert2; ImporteCert2)
                {
                    //SourceExpr=ImporteCert2;
                }
                Column(ImporteCerTotal; ImporteCerTotal)
                {
                    //SourceExpr=ImporteCerTotal ;
                }
                //D3 Triggers
                trigger OnPreDataItem();
                BEGIN
                    IF NOT (opcResumen) THEN
                        CurrReport.BREAK;

                    "Data Piecework For Production".SETRANGE("Data Piecework For Production".Indentation, 0);
                    "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Account Type", "Data Piecework For Production"."Account Type"::Heading);
                    "Data Piecework For Production".SETFILTER("Data Piecework For Production".Type, '<>%1', "Data Piecework For Production".Type::"Cost Unit");
                    "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Customer Certification Unit", TRUE);
                END;

                trigger OnAfterGetRecord();
                BEGIN

                    IF TEMP_DataPieceworkForProd.GET("Job No.", "Piecework Code") THEN
                        ImporteCertLinea := TEMP_DataPieceworkForProd."Initial Produc. Price"
                    ELSE
                        ImporteCertLinea := 0;
                END;


            }
            //MH Triggers
            trigger OnPreDataItem();
            BEGIN
                //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                IF NOT (opcDetalleMedicion) AND NOT (opcResumen) THEN
                    ERROR(TxtOpciones);
                //Q18912 CSM 06/03/23 Í Informes medici¢n. +
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Customer.RESET;
                Customer.SETRANGE("No.", "Customer No.");
                IF Customer.FINDSET THEN BEGIN
                    NombreCliente1 := Customer.Name;
                    NombreCliente2 := Customer."Name 2";
                END;

                Job.GET("Measurement Header"."Job No.");

                //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                HistMeasurementLines.SETCURRENTKEY("Job No.", "Piecework No.");
                HistMeasurementLines.SETRANGE("Job No.", "Measurement Header"."Job No.");
                IF HistMeasurementLines.FINDLAST THEN
                    IF HistMeasurementHeader.GET(HistMeasurementLines."Document No.") THEN
                        certificacionanterior := HistMeasurementHeader."No. Measure";
                //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                VATPostingSetup.RESET;
                VATPostingSetup.SETRANGE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
                VATPostingSetup.SETRANGE("VAT Bus. Posting Group", 'NAC');
                IF VATPostingSetup.FINDSET THEN
                    TipoIVA := VATPostingSetup."VAT %";

                //Gtos Generales y B§ Industrial
                IF Job."General Expenses / Other" <> 0 THEN BEGIN
                    PorcGtosGrales := Job."General Expenses / Other";
                    GtosGrales := TRUE;
                END ELSE
                    GtosGrales := FALSE;

                IF Job."Industrial Benefit" <> 0 THEN BEGIN
                    PorcBIndustrial := Job."Industrial Benefit";
                    BIndustrial := TRUE
                END ELSE
                    BIndustrial := FALSE;
                //Q19929 %Baja
                PorcBaja := Job."Low Coefficient";
                IF Job."Low Coefficient" <> 0 THEN BEGIN
                    BlnBaja := TRUE;
                END
                ELSE BEGIN
                    BlnBaja := FALSE;
                END;
                //-Q19929
                PorcCI := Job."Quality Deduction";
                IF Job."Quality Deduction" <> 0 THEN BEGIN
                    BlnCI := TRUE;
                END
                ELSE BEGIN
                    BlnCI := FALSE;
                END;

                //+Q19929

                //IVA
                Customer2.GET(Job."Bill-to Customer No.");
                VATPostingSetup2.RESET;
                VATPostingSetup2.SETRANGE("VAT Bus. Posting Group", Customer2."VAT Bus. Posting Group");
                VATPostingSetup2.SETRANGE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
                IF VATPostingSetup2.FINDFIRST THEN
                    PorcIVA := VATPostingSetup2."VAT %";
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group807")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("opcDetalleMedicion"; "opcDetalleMedicion")
                    {

                        CaptionML = ENU = 'with Medition detail', ESP = 'Con detalle de medici¢n';
                        ToolTipML = ENU = 'Specifies whether to print medition detail.', ESP = 'Especifica si se debe imprimir el detalle de la medici¢n o no.';
                    }
                    field("opcResumen"; "opcResumen")
                    {

                        CaptionML = ENU = 'Show Summary', ESP = 'Mostrar resumen';
                    }

                }

            }
        }
    }
    labels
    {
        lblCliente = 'Customer:/ Cliente:/';
        lblNEmPresup = 'Job No:/ N£m. Proyecto:/';
        lblFechaCert = 'Certification Date:/ Fecha Certificaci¢n:/';
        lblNCert = 'Certification No:/ N§ Certificaci¢n/';
        lblDescripcion = 'Description:/ Descripci¢n:/';
        lblResumenCertificacion = '"CERTIFICATION DRAFT SUMMARY "/ BORRADOR DE RESUMEN DE MEDICION/';
        lblEjecucionMaterial = 'MATERIAL EXECUTION/ EJECUCIàN MATERIAL/';
        lblCertifSinIVA = 'CERTIFICACIàN SIN IVA/';
        lblLiquidoCertif = '"LÖQUIDO MEDICIàN N§ "/ "LÖQUIDO MEDICIàN N§ "/';
        lblGtosGrales = 'GTOS GRALES/OTROS/';
        lblBIndustrial = 'B§ INDUSTRIAL/';
        lblCapitulo = 'CHAPTER/ CAPÖTULO/';
        lblResumen = 'SUMMARY/ RESUMEN/';
        lblImporte = 'AMOUNT/ IMPORTE/';
        lblCertificacion = 'MEDITION DRAFT/ BORRADOR DE MEDICIàN/';
        lblUnidades = 'UNITS/ UDS/';
        lblLongitud = 'LENGHT/ LONGITUD/';
        lblAncho = 'WIDTH/ ANCHO/';
        lblAltura = 'HEIGHT/ ALTURA/';
        lblCantidad = 'QUANTITY/ CANTIDAD/';
        lblPrecio = 'PRICE/ PRECIO/';
        lblSubtotal = 'Subtotal/ Subtotal/';
        lblCertificadoOrigen = 'Origin Certificate/ Medicion origen/';
        lblCertificacionesAnteriores = 'Previous Certification/ Medicion anterior/';
        lblCertificacionActual = 'Current certification/ Medicion actual/';
        lblTotal = 'Total/';
        lblTotalBase = 'Total base/';
    }

    var
        //       Job@7001104 :
        Job: Record 167;
        //       Customer@1100286006 :
        Customer: Record 18;
        //       NombreCliente1@1100286007 :
        NombreCliente1: Text;
        //       NombreCliente2@1100286008 :
        NombreCliente2: Text;
        //       MeasurementHeader@1100286004 :
        MeasurementHeader: Record 7207336;
        //       MeasurementLines@7001109 :
        MeasurementLines: Record 7207337;
        //       Certificate@7001100 :
        Certificate: Decimal;
        //       Quantity@7001101 :
        Quantity: Decimal;
        //       CertificateToOrigin@7001102 :
        CertificateToOrigin: Decimal;
        //       QuantityToOrigin@7001103 :
        QuantityToOrigin: Decimal;
        //       CertificateToOriginTotalGen@7001105 :
        CertificateToOriginTotalGen: Decimal;
        //       FirstPage@7001106 :
        FirstPage: Boolean;
        //       SectionPrice@7001107 :
        SectionPrice: Decimal;
        //       ThisCertificationQuantity@7001108 :
        ThisCertificationQuantity: Decimal;
        //       MeasurementNoCode@7001110 :
        MeasurementNoCode: Code[20];
        //       SectionCertificate@7001111 :
        SectionCertificate: Decimal;
        //       OnlySummary@7001112 :
        OnlySummary: Boolean;
        //       ExtendedLine@7001114 :
        ExtendedLine: Text[150];
        //       boolPostMeasLinesBillofItem@7001115 :
        boolPostMeasLinesBillofItem: Boolean;
        //       CurrReport_PAGENOCaptionLbl@7001116 :
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESP = 'P gina';
        //       CodeCaptionLbl@7001139 :
        CodeCaptionLbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       DescriptionCaptionLbl@7001138 :
        DescriptionCaptionLbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       QuantityCaptionLbl@7001137 :
        QuantityCaptionLbl: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       PriceCaptionLbl@7001136 :
        PriceCaptionLbl: TextConst ENU = 'Price', ESP = 'Precio';
        //       AmountCaptionLbl@7001135 :
        AmountCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       AmountCaption_Control1100229060Lbl@7001134 :
        AmountCaption_Control1100229060Lbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       PriceCaption_Control1100229062Lbl@7001133 :
        PriceCaption_Control1100229062Lbl: TextConst ENU = 'Price', ESP = 'Precio';
        //       QuantityCaption_Control1100229063Lbl@7001132 :
        QuantityCaption_Control1100229063Lbl: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       DescriptionCaption_Control1100229064Lbl@7001131 :
        DescriptionCaption_Control1100229064Lbl: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       CodeCaption_Control1100229065Lbl@7001130 :
        CodeCaption_Control1100229065Lbl: TextConst ENU = 'Code', ESP = 'C¢digo';
        //       PartialCaptionLbl@7001129 :
        PartialCaptionLbl: TextConst ENU = 'Partial', ESP = 'Parciales';
        //       LengthCaptionLbl@7001128 :
        LengthCaptionLbl: TextConst ENU = 'Length', ESP = 'Longitud';
        //       WidthCaptionLbl@7001127 :
        WidthCaptionLbl: TextConst ENU = 'Width', ESP = 'Anchura';
        //       HeigthCaptionLbl@7001126 :
        HeigthCaptionLbl: TextConst ENU = 'Height', ESP = 'Altura';
        //       Units_CaptionLbl@7001125 :
        Units_CaptionLbl: TextConst ENU = 'Units', ESP = 'Uds.';
        //       Certification_to_OriginCaptionLbl@7001124 :
        Certification_to_OriginCaptionLbl: TextConst ENU = 'Certification to Origin', ESP = 'Certificaci¢n a origen';
        //       Previous_CertificationsCaptionLbl@7001123 :
        Previous_CertificationsCaptionLbl: TextConst ENU = 'Previous Certifications', ESP = 'Certificaciones anteriores';
        //       Current_CertificationCaptionLbl@7001122 :
        Current_CertificationCaptionLbl: TextConst ENU = 'Current Certification', ESP = 'Certificaci¢n actual';
        //       Previous_CertificationsCaption_Control1100229025Lbl@7001121 :
        Previous_CertificationsCaption_Control1100229025Lbl: TextConst ENU = 'Previous Certifications', ESP = 'Certificaciones anteriores';
        //       Current_CertificationCaption_Control1100229026Lbl@7001120 :
        Current_CertificationCaption_Control1100229026Lbl: TextConst ENU = 'Current Certification', ESP = 'Certificaci¢n actual';
        //       Previous_CertificationsCaption_Control1100229036Lbl@7001119 :
        Previous_CertificationsCaption_Control1100229036Lbl: TextConst ENU = 'Previous Certifications', ESP = 'Certificaciones anteriores';
        //       Current_CertificationCaption_Control1100229038Lbl@7001118 :
        Current_CertificationCaption_Control1100229038Lbl: TextConst ENU = 'Current Certification', ESP = 'Certificaci¢n actual';
        //       TOTALCaptionLbl@7001117 :
        TOTALCaptionLbl: TextConst ESP = 'TOTAL';
        //       OriginPrice@7001140 :
        OriginPrice: Decimal;
        //       PreviousPrice@7001141 :
        PreviousPrice: Decimal;
        //       TotalGeneralCertificateToOrigin@7001142 :
        TotalGeneralCertificateToOrigin: Decimal;
        //       Job2@7001150 :
        Job2: Record 167;
        //       PorcGtosGrales@7001149 :
        PorcGtosGrales: Decimal;
        //       GtosGrales@7001148 :
        GtosGrales: Boolean;
        //       PorcBIndustrial@7001147 :
        PorcBIndustrial: Decimal;
        //       BIndustrial@7001146 :
        BIndustrial: Boolean;
        //       VATPostingSetup2@7001145 :
        VATPostingSetup2: Record 325;
        //       Customer2@7001144 :
        Customer2: Record 18;
        //       CompanyInformation@7001151 :
        CompanyInformation: Record 79;
        //       DescripcionDescompuesto@7001152 :
        DescripcionDescompuesto: Text;
        //       TextoExtendido@7001153 :
        TextoExtendido: Text;
        //       DataCostByPiecework@7001154 :
        DataCostByPiecework: Record 7207387;
        //       Resource@7001155 :
        Resource: Record 156;
        //       Item@7001157 :
        Item: Record 27;
        //       GLAccount@7001158 :
        GLAccount: Record 15;
        //       certianterior@7001159 :
        certianterior: Decimal;
        //       PostMeasLinesBillofItem@7001160 :
        PostMeasLinesBillofItem: Record 7207396;
        //       Cliente_CaptionLbl@7001186 :
        Cliente_CaptionLbl: TextConst ENU = 'Customer:', ESP = 'Cliente:';
        //       NumPresupuesto_CaptionLbl@7001185 :
        NumPresupuesto_CaptionLbl: TextConst ENU = 'Budget No:', ESP = 'N£m. Presupuesto:';
        //       FechaCertificacion_CaptionLbl@7001184 :
        FechaCertificacion_CaptionLbl: TextConst ENU = 'Certification Date:', ESP = 'Fecha Certificaci¢n:';
        //       NCertificacion_CaptionLbl@7001183 :
        NCertificacion_CaptionLbl: TextConst ENU = 'Certification No:', ESP = 'N§ Certificaci¢n:';
        //       Descripcion_CaptionLbl@7001182 :
        Descripcion_CaptionLbl: TextConst ENU = 'Description:', ESP = 'Descripci¢n:';
        //       Certificacion_CaptionLbl@7001181 :
        Certificacion_CaptionLbl: TextConst ENU = 'CERTIFICATION DRAFT', ESP = 'BORRADOR MEDICION';
        //       Capitulo_CaptionLbl@7001180 :
        Capitulo_CaptionLbl: TextConst ENU = 'CHAPTER', ESP = 'CAPÖTULO';
        //       Resumen_CaptionLbl@7001179 :
        Resumen_CaptionLbl: TextConst ENU = 'SUMMARY', ESP = 'RESUMEN';
        //       ImporteContratado_CaptionLbl@7001178 :
        ImporteContratado_CaptionLbl: TextConst ENU = 'CONTRACTED AMOUNT', ESP = 'IMPORTE CONTRATADO';
        //       Importe_CaptionLbl@7001177 :
        Importe_CaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        //       DirectorObra_CaptionLbl@7001176 :
        DirectorObra_CaptionLbl: TextConst ENU = 'CONSTRUCTION MANAGER', ESP = 'DIRECTOR DE OBRA';
        //       Contratista_CaptionLbl@7001175 :
        Contratista_CaptionLbl: TextConst ENU = 'CONTRACTOR', ESP = 'CONTRATISTA';
        //       Ejecuci¢nMaterial_CaptionLbl@7001174 :
        EjecucionMaterial_CaptionLbl: TextConst ENU = 'MATERIAL EXECUTION', ESP = 'EJECUCIàN MATERIAL';
        //       CertificacionSinIva_CaptionLbl@7001173 :
        CertificacionSinIva_CaptionLbl: TextConst ENU = 'CERTIFICATION WITHOUT VAT', ESP = 'CERTIFICACIàN SIN IVA';
        //       LiquidoCertificacion_CaptionLbl@7001172 :
        LiquidoCertificacion_CaptionLbl: TextConst ENU = 'LIQUID CERTIFICATION N§', ESP = 'LÖQUIDO DE CERTIFICACION N§';
        //       ADeducir_CaptionLbl@7001171 :
        ADeducir_CaptionLbl: TextConst ENU = 'To deduct medition n§', ESP = 'A deducir medici¢n n§';
        //       Unidades_CaptionLbl@7001170 :
        Unidades_CaptionLbl: TextConst ENU = 'UNITS', ESP = 'UDS';
        //       Longitud_CaptionLbl@7001169 :
        Longitud_CaptionLbl: TextConst ENU = 'LENGHT', ESP = 'LONGITUD';
        //       Ancho_CaptionLbl@7001168 :
        Ancho_CaptionLbl: TextConst ENU = 'WIDTH', ESP = 'ANCHO';
        //       Altura_CaptionLbl@7001167 :
        Altura_CaptionLbl: TextConst ENU = 'Height', ESP = 'Altura';
        //       Cantidad_CaptionLbl@7001166 :
        Cantidad_CaptionLbl: TextConst ENU = 'Quantity', ESP = 'Cantidad';
        //       Precio_CaptionLbl@7001165 :
        Precio_CaptionLbl: TextConst ENU = 'Price', ESP = 'Precio';
        //       Subtotal_CaptionLbl@7001164 :
        Subtotal_CaptionLbl: TextConst ENU = 'Subtotal', ESP = 'Subtotal';
        //       CertificadoOrigen_CaptionLbl@7001163 :
        CertificadoOrigen_CaptionLbl: TextConst ENU = 'Origin Certificate', ESP = 'Certificado origen';
        //       CertificacionesAnteriores_CaptionLbl@7001162 :
        CertificacionesAnteriores_CaptionLbl: TextConst ENU = 'Previous Certification', ESP = 'Certificacion anterior';
        //       CertificacionActual_CaptionLbl@7001161 :
        CertificacionActual_CaptionLbl: TextConst ENU = 'Current Certification', ESP = 'Certificaci¢n actual';
        //       cantidadorigen2@7001187 :
        cantidadorigen2: Decimal;
        //       PostCertifications@7001188 :
        PostCertifications: Record 7207341;
        //       HistCertificationLines@7001189 :
        HistCertificationLines: Record 7207342;
        //       CantCertAnterior@7001190 :
        CantCertAnterior: Decimal;
        //       CantCertOrigen@7001191 :
        CantCertOrigen: Decimal;
        //       MeasurementLines2@7001192 :
        MeasurementLines2: Record 7207337;
        //       DescMed@7001193 :
        DescMed: Text[50];
        //       MeasureLinesBillofItem@7001194 :
        MeasureLinesBillofItem: Record 7207395;
        //       check@7001195 :
        check: Boolean;
        //       DPFPCode@7001206 :
        DPFPCode: Text[20];
        //       DPFPDescription@7001205 :
        DPFPDescription: Text[100];
        //       DescVacia@7001203 :
        DescVacia: Integer;
        //       Capitulo@7001202 :
        Capitulo: Code[20];
        //       TotalLinea@7001201 :
        TotalLinea: Boolean;
        //       TotalCapi@7001200 :
        TotalCapi: Decimal;
        //       TotalTotalCapi@7001199 :
        TotalTotalCapi: Decimal;
        //       TotalTotalLinea@7001198 :
        TotalTotalLinea: Boolean;
        //       CaptionSubcapitulo@7001197 :
        CaptionSubcapitulo: Text;
        //       CaptionCapitulo@7001196 :
        CaptionCapitulo: Text;
        //       Tipo@7001209 :
        Tipo: Integer;
        //       Indentacion@7001208 :
        Indentacion: Integer;
        //       contador@7001207 :
        contador: Integer;
        //       MeasurementLines3@7001210 :
        MeasurementLines3: Record 7207337;
        //       opcDetalleMedicion@1100286000 :
        opcDetalleMedicion: Boolean;
        //       opcResumen@1100286001 :
        opcResumen: Boolean;
        //       certificacionanterior@1100286002 :
        certificacionanterior: Code[20];
        //       conta@1100286003 :
        conta: Integer;
        //       TotalGeneral@1100286005 :
        TotalGeneral: Decimal;
        //       DataPieceworkForProduction@1100286009 :
        DataPieceworkForProduction: Record 7207386;
        //       ImporteCertLinea@1100286010 :
        ImporteCertLinea: Decimal;
        //       ImporteCertifi@1100286011 :
        ImporteCertifi: Decimal;
        //       VATPostingSetup@1100286012 :
        VATPostingSetup: Record 325;
        //       TipoIVA@1100286013 :
        TipoIVA: Decimal;
        //       FirstLine@1100286014 :
        FirstLine: Boolean;
        //       PRESTO@1100286015 :
        PRESTO: Code[40];
        //       ImporteCert2@1100286016 :
        ImporteCert2: Decimal;
        //       ImporteCerTotal@1000000000 :
        ImporteCerTotal: Decimal;
        //       QBText@100000000 :
        QBText: Record 7206918;
        //       PorcIVA@1100286026 :
        PorcIVA: Decimal;
        //       BlnBaja@1100286034 :
        BlnBaja: Boolean;
        //       PorcBaja@1100286033 :
        PorcBaja: Decimal;
        //       PorcCI@1100286032 :
        PorcCI: Decimal;
        //       BlnCI@1100286031 :
        BlnCI: Boolean;
        //       "-------------------------- ESPECIAL"@1100286017 :
        "-------------------------- ESPECIAL": Integer;
        //       unidad@1100286025 :
        unidad: Boolean;
        //       HistMeasurementHeader@1100286020 :
        HistMeasurementHeader: Record 7207338;
        //       HistMeasurementLines@1100286019 :
        HistMeasurementLines: Record 7207339;
        //       TotalCantCertAnterior@1100286021 :
        TotalCantCertAnterior: Decimal;
        //       FirstLineMeasure@1100286023 :
        FirstLineMeasure: Integer;
        //       MeasurementHeader3@1100286024 :
        MeasurementHeader3: Record 7207336;
        //       TEMP_DataPieceworkForProd@1100286018 :
        TEMP_DataPieceworkForProd: Record 7207386 TEMPORARY;
        //       TxtOpciones@1100286022 :
        TxtOpciones: TextConst ENU = 'Debe seleccionar al menos una opci¢n de impresi¢n.', ESP = 'Debe seleccionar al menos una opci¢n de impresi¢n.';
        //       lblCBaja@1100286028 :
        lblCBaja: TextConst ESP = 'Coef. Baja';
        //       lblCI@1100286027 :
        lblCI: TextConst ESP = 'Coef. Indirectos';



    trigger OnInitReport();
    begin
        //Q18912 CSM 06/03/23 Í Informes medici¢n. -
        opcDetalleMedicion := TRUE;
        opcResumen := TRUE;
        //Q18912 CSM 06/03/23 Í Informes medici¢n. +

        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);  //Q18912 CSM 06/03/23
    end;



    LOCAL procedure PrimeraLinea()
    begin
        if (FirstLine) then begin
            FirstLine := FALSE;
        end else begin
            //CLEAR(CompanyInformation.Picture);    //Q18912 CSM 06/03/23 Í Informes medici¢n. SE COMENTA LÖNEA.
        end;
    end;

    /*begin
    //{
//      JAV 15/10/19: - Se cambia la variable "Measurement Header"."Certification No." que se ha eliminado por "Measurement Header"."No. Measure"
//      Q18912 CSM 06/03/23 Í Informes medici¢n.
//      Q19929 A¤adir Coeficientes
//    }
    end.
  */

}



