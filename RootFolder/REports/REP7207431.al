report 7207431 "Job Sales Records Report"
{


    CaptionML = ENU = 'Print Public Offer', ESP = 'Impresi¢n del expediente de Venta';
    ShowPrintStatus = true;

    dataset
    {

        DataItem("Records"; "Records")
        {

            DataItemTableView = SORTING("Job No.", "No.");
            PrintOnlyIfDetail = false;
            ;
            Column(Logo; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(JobDescription; Description + "Description 2")
            {
                //SourceExpr=Description + "Description 2";
            }
            Column(JobNo; Records."Job No.")
            {
                //SourceExpr=Records."Job No.";
            }
            Column(DateFooter; FORMAT(TODAY, 0, '<Day> of <Month Text> of <Year4>'))
            {
                //SourceExpr=FORMAT(TODAY,0,'<Day> of <Month Text> of <Year4>');
            }
            Column(CityToDate; CompanyInformation.City + ', to ' + FORMAT(TODAY, 0, '<Day> of <Month Text> of <Year4>'))
            {
                //SourceExpr=CompanyInformation.City + ', to ' + FORMAT(TODAY,0,'<Day> of <Month Text> of <Year4>');
            }
            Column(CityDate; CityDate)
            {
                //SourceExpr=CityDate;
            }
            Column(HeaderTx; HeaderTx)
            {
                //SourceExpr=HeaderTx;
            }
            Column(DescriptionText1; DescriptionText[1])
            {
                //SourceExpr=DescriptionText[1];
            }
            Column(DescriptionText2; DescriptionText[2])
            {
                //SourceExpr=DescriptionText[2];
            }
            Column(DescriptionTextValid; DescriptionTextValid[1])
            {
                //SourceExpr=[DescriptionTextValid[1]] ];
            }
            Column(MonthsTx; MonthsTx)
            {
                //SourceExpr=MonthsTx;
            }
            Column(CustAddr_1; CustAddr[1])
            {
                //SourceExpr=CustAddr[1];
            }
            Column(CustAddr_2; CustAddr[2])
            {
                //SourceExpr=CustAddr[2];
            }
            Column(CustAddr_4; CustAddr[4])
            {
                //SourceExpr=CustAddr[4];
            }
            Column(CustAddr_3; CustAddr[3])
            {
                //SourceExpr=CustAddr[3];
            }
            Column(CustAddr_5; CustAddr[5])
            {
                //SourceExpr=CustAddr[5];
            }
            Column(CustAddr_6; CustAddr[6])
            {
                //SourceExpr=CustAddr[6];
            }
            Column(WithIVA; WithIVA)
            {
                //SourceExpr=WithIVA;
            }
            Column(NotValuate; NotValuate)
            {
                //SourceExpr=NotValuate;
            }
            Column(OnlyResume; OnlySummary)
            {
                //SourceExpr=OnlySummary;
            }
            Column(PrintMeasureLines; PrintMeasureLines)
            {
                //SourceExpr=PrintMeasureLines;
            }
            Column(CustomerName; CustomerName)
            {
                //SourceExpr=CustomerName;
            }
            Column(TotalExpediente; TotalExpediente)
            {
                //SourceExpr=TotalExpediente;
            }
            Column(Description_Job; Job2.Description)
            {
                //SourceExpr=Job2.Description;
            }
            Column(Description2_Job; Job2."Description 2")
            {
                //SourceExpr=Job2."Description 2";
            }
            DataItem("Data Piecework For Production"; "Data Piecework For Production")
            {

                DataItemTableView = WHERE("Customer Certification Unit" = FILTER(true));
                PrintOnlyIfDetail = true;


                RequestFilterFields = "Piecework Code";
                DataItemLink = "Job No." = FIELD("Job No."),
                            "No. Record" = FIELD("No.");
                Column(Capi; Capi)
                {
                    //SourceExpr=Capi;
                }
                DataItem("Data Piecework For Production2"; "Data Piecework For Production")
                {

                    DataItemTableView = SORTING("Job No.", "Customer Certification Unit", "Piecework Code")
                                 WHERE("Customer Certification Unit" = FILTER(true));
                    PrintOnlyIfDetail = true;
                    DataItemLink = "Job No." = FIELD("Job No."),
                            "No. Record" = FIELD("No. Record");
                    Column(PieceworkCode; "Piecework Code")
                    {
                        //SourceExpr="Piecework Code";
                    }
                    Column(CompanyInformation_Picture; CompanyInformation.Picture)
                    {
                        //SourceExpr=CompanyInformation.Picture;
                    }
                    Column(ImportaPrint; ImportaPrint)
                    {
                        //SourceExpr=ImportaPrint;
                    }
                    Column(funUnitsOfMeasure; funUnitsOfMeasure)
                    {
                        //SourceExpr=funUnitsOfMeasure;
                    }
                    Column(PieceworkUniqueCode; "Unique Code")
                    {
                        //SourceExpr="Unique Code";
                    }
                    Column(PieceworkIndentation; Indentation)
                    {
                        //SourceExpr=Indentation;
                    }
                    Column(PieceworkDescription; Description)
                    {
                        //SourceExpr=Description;
                    }
                    Column(PieceworkDescription2; "Description 2")
                    {
                        //SourceExpr="Description 2";
                    }
                    Column(TotalAmount; TotalAmount)
                    {
                        //SourceExpr=TotalAmount;
                    }
                    Column(PieceworkType; Type)
                    {
                        //SourceExpr=Type;
                    }
                    Column(NotFather; NotFather)
                    {
                        //SourceExpr=NotFather;
                    }
                    Column(IsUnit; IsUnit)
                    {
                        //SourceExpr=IsUnit;
                    }
                    Column(PieceworkAccountType; "Data Piecework For Production2"."Account Type")
                    {
                        //SourceExpr="Data Piecework For Production2"."Account Type";
                    }
                    Column(PieceworkSaleQuantityBase; "Data Piecework For Production2"."Sale Quantity (base)")
                    {
                        //SourceExpr="Data Piecework For Production2"."Sale Quantity (base)";
                    }
                    Column(PieceworkContractPrice; "Data Piecework For Production2"."Contract Price")
                    {
                        //SourceExpr="Data Piecework For Production2"."Contract Price";
                        AutoFormatType = 2;
                    }
                    Column(PieceworkAmountSaleContract1; "Data Piecework For Production2"."Amount Sale Contract")
                    {
                        //SourceExpr="Data Piecework For Production2"."Amount Sale Contract";
                        AutoFormatType = 1;
                    }
                    Column(AmountProductionBudget_DataPieceworkForProduction; "Data Piecework For Production2"."Amount Production Budget")
                    {
                        //SourceExpr="Data Piecework For Production2"."Amount Production Budget";
                    }
                    Column(CodePieceworkPresto_DataPieceworForProduction; "Data Piecework For Production2"."Code Piecework PRESTO")
                    {
                        //SourceExpr="Data Piecework For Production2"."Code Piecework PRESTO";
                    }
                    Column(UnitOfMeasure_DataPieceworkForProduction; "Data Piecework For Production2"."Unit Of Measure")
                    {
                        //SourceExpr="Data Piecework For Production2"."Unit Of Measure";
                    }
                    Column(CustomerCertificationUnit_DataPieceworkForProduction; "Data Piecework For Production2"."Customer Certification Unit")
                    {
                        //SourceExpr="Data Piecework For Production2"."Customer Certification Unit";
                    }
                    Column(SaleAmount_DatapieceworkForProduction; "Data Piecework For Production2"."Sale Amount")
                    {
                        //SourceExpr="Data Piecework For Production2"."Sale Amount";
                    }
                    Column(UnitPriceSales_DataPieceworkForProduction; DataPieceworkForProduction2."Unit Price Sale (base)")
                    {
                        //SourceExpr=DataPieceworkForProduction2."Unit Price Sale (base)";
                    }
                    Column(PieceworkAmountSaleContract; PieceworkAmountSaleContract)
                    {
                        //SourceExpr=PieceworkAmountSaleContract;
                    }
                    Column(Father; Father)
                    {
                        //SourceExpr=Father;
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
                    Column(PorcCoefBaja; PorcCoefBaja)
                    {
                        //SourceExpr=PorcCoefBaja;
                    }
                    Column(CoefBaja; CoefBaja)
                    {
                        //SourceExpr=CoefBaja;
                    }
                    Column(PorcCoefInd; PorcCoefInd)
                    {
                        //SourceExpr=PorcCoefInd;
                    }
                    Column(CoefInd; CoefInd)
                    {
                        //SourceExpr=CoefInd;
                    }
                    Column(PorcIVA; PorcIVA)
                    {
                        //SourceExpr=PorcIVA;
                    }
                    Column(Capitulo_Caption; Capitulo_CaptionLbl)
                    {
                        //SourceExpr=Capitulo_CaptionLbl;
                    }
                    Column(Resumen_Caption; Resumen_CaptionLbl)
                    {
                        //SourceExpr=Resumen_CaptionLbl;
                    }
                    Column(Importe_Caption; Importe_CaptionLbl)
                    {
                        //SourceExpr=Importe_CaptionLbl;
                    }
                    Column(PC_DataPieceworkForProduction; "Data Piecework For Production2"."Piecework Code")
                    {
                        //SourceExpr="Data Piecework For Production2"."Piecework Code";
                    }
                    Column(LineaTotal; LineaTotal)
                    {
                        //SourceExpr=LineaTotal;
                    }
                    Column(TotalCapituloBuffer; TotalCapituloBuffer)
                    {
                        //SourceExpr=TotalCapituloBuffer;
                    }
                    Column(TotalCapituloText; TotalCapituloText)
                    {
                        //SourceExpr=TotalCapituloText;
                    }
                    Column(LineaTotalTotal; LineaTotalTotal)
                    {
                        //SourceExpr=LineaTotalTotal;
                    }
                    Column(TotalTotalCapituloText; TotalTotalCapituloText)
                    {
                        //SourceExpr=TotalTotalCapituloText;
                    }
                    Column(TotalTotalCapituloBuffer; TotalTotalCapituloBuffer)
                    {
                        //SourceExpr=TotalTotalCapituloBuffer;
                    }
                    Column(TotalPresupuesto; TotalPresupuesto)
                    {
                        //SourceExpr=TotalPresupuesto;
                    }
                    Column(UltimaFila; UltimaFila)
                    {
                        //SourceExpr=UltimaFila;
                    }
                    Column(ExtendedLine; ExtendedLine)
                    {
                        //SourceExpr=ExtendedLine;
                    }
                    DataItem("Measure Line Piecework Certif."; "Measure Line Piecework Certif.")
                    {

                        DataItemTableView = SORTING("Job No.", "Piecework Code", "Line No.");
                        DataItemLink = "Job No." = FIELD("Job No."),
                            "Piecework Code" = FIELD("Piecework Code");
                        Column(LineMeasureUnits; Units)
                        {
                            //SourceExpr=Units;
                        }
                        Column(LineMeasureLenght; Length)
                        {
                            //SourceExpr=Length;
                        }
                        Column(LineMeasureWidth; Width)
                        {
                            //SourceExpr=Width;
                        }
                        Column(LineMeasureHeight; Height)
                        {
                            //SourceExpr=Height;
                        }
                        Column(LineMeasureTotal; Total)
                        {
                            //SourceExpr=Total;
                        }
                        Column(LinMedDescription; Description)
                        {
                            //SourceExpr=Description;
                        }
                        Column(LineMeasureJobNo; "Job No.")
                        {
                            //SourceExpr="Job No.";
                        }
                        Column(LineMeasurePieceworkCode; "Piecework Code")
                        {
                            //SourceExpr="Piecework Code";
                        }
                        Column(LineMeasureLineNo; "Line No.")
                        {
                            //SourceExpr="Line No.";
                        }
                        //D3 triggers
                        trigger OnPreDataItem();
                        BEGIN
                            IF "Data Piecework For Production2"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN BEGIN
                                IsUnit := FALSE; //+001
                                CurrReport.BREAK;
                            END;
                        END;

                        trigger OnAfterGetRecord();
                        BEGIN
                            IF ("Measure Line Piecework Certif.".Description = '') AND ("Measure Line Piecework Certif.".Length = 0) AND ("Measure Line Piecework Certif.".Units = 0) AND
                              ("Measure Line Piecework Certif.".Height = 0) AND ("Measure Line Piecework Certif.".Width = 0) AND ("Measure Line Piecework Certif.".Total = 0) THEN
                                CurrReport.SKIP;
                        END;
                    }
                    DataItem("integer1"; "2000000026")
                    {

                        DataItemTableView = SORTING("Number");
                        MaxIteration = 1;
                        Column(IntegerPieceworkSaleQuantityBase; "Data Piecework For Production"."Sale Quantity (base)")
                        {
                            //SourceExpr="Data Piecework For Production"."Sale Quantity (base)";
                        }
                        Column(UnitaryPrice; UnitaryPrice)
                        {
                            //SourceExpr=UnitaryPrice;
                            AutoFormatType = 2;
                        }
                        Column(IntegerImportaPrint; ImportaPrint)
                        {
                            //SourceExpr=ImportaPrint;
                            AutoFormatType = 1;
                        }
                        Column(integer1_Number; Number)
                        {
                            //SourceExpr=Number ;
                        }
                        //D4 Triggers
                    }
                    //D2 Triggers
                    trigger OnPreDataItem();
                    BEGIN
                        JobsSetup.GET;
                        FirstPage := TRUE;
                        TotalCapituloBuffer := 0;
                        "Data Piecework For Production2".SETFILTER("Piecework Code", Capi + '*');
                    END;

                    trigger OnAfterGetRecord();
                    BEGIN
                        "Data Piecework For Production2".CALCFIELDS("Accumulated Amount Contract", "Accumulated Amount");

                        //+002
                        IF WithIVA THEN BEGIN
                            "Contract Price" := ROUND(("Contract Price" * (1 + VATPostingSetup."VAT+EC %" / 100)), Currency."Amount Rounding Precision");
                            PieceworkAmountSaleContract := ROUND(("Data Piecework For Production"."Amount Sale Contract" * (1 + VATPostingSetup."VAT+EC %" / 100)), Currency."Unit-Amount Rounding Precision");
                        END ELSE BEGIN
                            "Contract Price" := ROUND("Contract Price", Currency."Amount Rounding Precision");
                            PieceworkAmountSaleContract := ROUND("Data Piecework For Production2"."Amount Sale Contract", Currency."Unit-Amount Rounding Precision");
                        END;
                        //+002

                        IF NOT NotValuate THEN BEGIN
                            IF WithIVA THEN
                                ImportaPrint := ROUND(("Accumulated Amount" * (1 + VATPostingSetup."VAT+EC %" / 100)), Currency."Amount Rounding Precision")
                            ELSE
                                ImportaPrint := "Accumulated Amount";

                            IF "Data Piecework For Production2"."Sale Quantity (base)" <> 0 THEN
                                UnitaryPrice := ROUND(ImportaPrint / "Data Piecework For Production2"."Sale Quantity (base)",
                                                     Currency."Unit-Amount Rounding Precision")
                            ELSE
                                UnitaryPrice := 0;
                        END;

                        Father := "Data Piecework For Production2".ReturnFather("Data Piecework For Production2");
                        IF (Father = '') THEN Father := "Piecework Code";

                        IF "Account Type" = "Account Type"::Unit THEN BEGIN
                            IsUnit := TRUE; //+001
                            IF WithIVA THEN BEGIN
                                TotalAmount := ROUND(("Accumulated Amount" * (1 + VATPostingSetup."VAT+EC %" / 100)), Currency."Amount Rounding Precision") + TotalAmount;
                            END ELSE BEGIN
                                TotalAmount := "Accumulated Amount" + TotalAmount;
                            END;
                        END;

                        //Gtos Generales, B§ Industrial, Coeficiente baja y Coeficientes indirectos
                        Job2.RESET;
                        Job2.SETRANGE("No.", "Data Piecework For Production2"."Job No.");
                        IF Job2.FINDFIRST THEN BEGIN
                            IF Job2."General Expenses / Other" <> 0 THEN BEGIN
                                PorcGtosGrales := Job2."General Expenses / Other";
                                GtosGrales := TRUE;
                            END ELSE
                                GtosGrales := FALSE;

                            IF Job2."Industrial Benefit" <> 0 THEN BEGIN
                                PorcBIndustrial := Job2."Industrial Benefit";
                                BIndustrial := TRUE
                            END ELSE
                                BIndustrial := FALSE;

                            IF Job2."Low Coefficient" <> 0 THEN BEGIN
                                PorcCoefBaja := Job2."Low Coefficient";
                                CoefBaja := TRUE
                            END ELSE
                                CoefBaja := FALSE;

                            IF Job2."Quality Deduction" <> 0 THEN BEGIN
                                PorcCoefInd := Job2."Quality Deduction";
                                CoefInd := TRUE
                            END ELSE
                                CoefInd := FALSE;

                            //IVA
                            Customer2.GET(Job2."Bill-to Customer No.");
                            VATPostingSetup2.RESET;
                            VATPostingSetup2.SETRANGE("VAT Bus. Posting Group", Customer2."VAT Bus. Posting Group");
                            VATPostingSetup2.SETRANGE("VAT Prod. Posting Group", Job2."VAT Prod. PostingGroup");
                            IF VATPostingSetup2.FINDFIRST THEN
                                PorcIVA := VATPostingSetup2."VAT %";
                        END;

                        //Totales
                        CLEAR(LineaTotal);
                        CLEAR(LineaTotalTotal);
                        CLEAR(Mayor);
                        IF "Data Piecework For Production2".Indentation = 0 THEN BEGIN
                            TotalTotalCapituloBuffer := "Data Piecework For Production2"."Sale Amount";
                            TotalTotalCapituloText := "Data Piecework For Production2"."Piecework Code";
                            TotalPresupuesto += "Data Piecework For Production2"."Sale Amount";
                        END;
                        IF "Data Piecework For Production2".Indentation <> 0 THEN BEGIN

                            TotalCapituloBuffer += "Data Piecework For Production2"."Sale Amount";

                            DataPieceworkForProduction2.RESET;
                            DataPieceworkForProduction2.SETRANGE("Job No.", "Data Piecework For Production2"."Job No.");
                            DataPieceworkForProduction2.SETFILTER("Piecework Code", "Data Piecework For Production2"."Piecework Code" + '..');
                            DataPieceworkForProduction2.SETRANGE("No. Record", "Data Piecework For Production2"."No. Record");
                            IF DataPieceworkForProduction2.FINDSET THEN BEGIN
                                IF DataPieceworkForProduction2.NEXT = 0 THEN
                                    LineaTotal := TRUE
                                ELSE
                                    DataPieceworkForProduction2.NEXT;
                                IF (COPYSTR(DataPieceworkForProduction2."Piecework Code", 1, 2) <> Capi) THEN BEGIN
                                    LineaTotal := TRUE;
                                END;
                            END;

                            IF DataPieceworkForProduction2.Indentation = 0 THEN BEGIN
                                LineaTotalTotal := TRUE;
                                LineaTotal := FALSE;
                            END;
                        END;

                        //JAV 19/03/19: Hacer que solo sume en el total lo que se presenta en el informe
                        IF (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit) THEN BEGIN
                            DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                            TotalExpediente += "Sale Quantity (base)" * "Contract Price";
                        END;
                        //JAV 19/03/19: fin

                        //Texto adicional
                        ExtendedLine := ''; //JAV 04/03/19: - Para que no duplique textos si la siguiente no los tiene
                        IF QBText.GET(QBText.Table::Job, "Data Piecework For Production2"."Job No.", "Data Piecework For Production2"."Piecework Code") THEN
                            ExtendedLine := QBText.GetSalesText;
                    END;
                }
                //D1 Triggers
                trigger OnPreDataItem();
                BEGIN
                    JobsSetup.GET;
                    FirstPage := TRUE;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF COPYSTR("Data Piecework For Production"."Piecework Code", 1, 2) <> Capi THEN BEGIN
                        TotalCapituloBuffer := "Data Piecework For Production"."Sale Amount";
                        Capi := COPYSTR("Data Piecework For Production"."Piecework Code", 1, 2);
                    END ELSE BEGIN
                        TotalCapituloBuffer += "Data Piecework For Production"."Sale Amount";
                    END;
                END;
            }
            //R Triggers

            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;

                CompanyInformation.CALCFIELDS(Picture);
                CityDate := CompanyInformation.City + Text006 + FORMAT(TODAY, 0, '<Day>') + Text007 + FORMAT(TODAY, 0, '<Month Text>') + Text007 + FORMAT(TODAY, 0, '<Year4>');

                IF NotValuate THEN
                    HeaderTx := Text001
                ELSE BEGIN
                    IF PrintMeasureLines THEN
                        HeaderTx := Text002
                    ELSE
                        HeaderTx := Text003
                END;

                FirstPage := TRUE;

                TotalExpediente := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Job2.GET(Records."Job No.");

                Records2.RESET;
                Records2.SETRANGE("Job No.", Records."Job No.");
                Records2.SETRANGE("No.", Records."No.");
                IF Records2.FINDFIRST THEN BEGIN
                    Records2.CALCFIELDS("Customer No.");
                    Customer.GET(Records2."Customer No.");
                    CustomerName := Customer.Name + Customer."Name 2";
                END;

                //JAV 19/03/19: Hacer que solo sume en el total lo que se presenta en el informe
                // DataPieceworkForProduction.RESET;
                // DataPieceworkForProduction.SETRANGE("Job No.",Records."Job No.");
                // DataPieceworkForProduction.SETRANGE("No. Record",Records."No.");
                // DataPieceworkForProduction.SETRANGE("Customer Certification Unit",TRUE);
                // DataPieceworkForProduction.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
                // IF DataPieceworkForProduction.FINDSET THEN BEGIN
                //  REPEAT
                //    DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                //    TotalExpediente += DataPieceworkForProduction."Sale Amount";
                //  UNTIL DataPieceworkForProduction.NEXT = 0;
                // END;
                //JAV 19/03/19 fin
            END;


        }

    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group845")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("OnlySummary"; "OnlySummary")
                    {

                        CaptionML = ENU = 'Do you want summary only print?', ESP = '¨Imprimir solo resumen?';

                        ; trigger OnValidate()
                        BEGIN
                            PrintMeasureLines := FALSE;
                            IF OnlySummary = TRUE THEN
                                PrintMeasureLinesEnable := FALSE
                            ELSE
                                PrintMeasureLinesEnable := TRUE;
                        END;


                    }
                    field("PrintMeasureLines"; "PrintMeasureLines")
                    {

                        CaptionML = ENU = 'Do you want measure lines include?', ESP = '¨Incluir l¡neas de medici¢n?';
                        Enabled = PrintMeasureLinesEnable;

                        ; trigger OnValidate()
                        BEGIN
                            OnlySummary := FALSE;
                        END;


                    }
                    field("NotValuate"; "NotValuate")
                    {

                        CaptionML = ENU = 'Not valuate?', ESP = '¨Sin valorar?';

                        ; trigger OnValidate()
                        BEGIN
                            //NotValuateOnPush;
                        END;


                    }
                    field("WithIVA"; "WithIVA")
                    {

                        CaptionML = ENU = 'Print with IVA', ESP = 'Imprimir con IVA';
                    }

                }

            }
        }
    }
    labels
    {
        PageNoL = 'Page/ P g./';
        AmountL = 'Amount/ Importe/';
        PUnitL = 'Unitary Price/ P. unitario/';
        QuantityL = 'Quantity/ Cantidad/';
        DescL = 'Description/ Descripci¢n/';
        PartialsL = 'Partials/ Parciales/';
        HeightL = 'Height/ Altura/';
        WidthL = 'Width/ Anchura/';
        LongL = 'Long/ Longitud/';
        UnitsL = 'Units/ Uds./';
        CodeL = 'Code/ Codigo/';
        TotalPieceworkL = 'PIECEWORK TOTAL/ TOTAL U.O./';
        TitleL = 'Title/ T¡tulo/';
        TotalBudgetL = 'BUDGET TOTAL/ TOTAL PRESUPUESTO/';
        TotalOfferL = 'OFFER TOTAL/ TOTAL OFERTA/';
        StringEmptyL = '-/';
        QtyIncrementVATL = 'This amount will be increased by the corresponding VAT./ Esta cantidad se ver  incrementada por el IVA correspondiente./';
        AccountPropertyL = 'Will be of account of the property all type of Municipal Licenses as well as the fees of the Facultative Direction./ Ser n de cuenta de la propiedad todo tipo de Licencias Municipales as¡ como los honorarios de la Direcci¢n Facultativa/';
        ShipOutBudgetL = 'All item that is carried out outside budget, will be invoiced according to the unit prices agreed prior to its realization./ Toda partida que se realice fuera de presupuesto, ser  facturada conforme a los precios unitarios pactados con anterioridad a su realizaci¢n./';
        ShipJustifyL = 'The items marked A JUSTIFY, will be settled according to the work actually performed./ Las partidas marcadas como A JUSTIFICAR, se liquidar n seg£n obra realmente realizada./';
        AccountContractorL = 'The Contractor shall be responsible for the service and implementation of the necessary materials for the good development of the same, fees of all the personnel that work to his orders as well as the Social Security of the same./ Quedar  de cuenta de Contratista el servicio y puesta en obra de los materiales necesarios para el buen desarrollo de la misma, honorarios de todo el personal que trabaje a sus ordenes as¡ como la Seguridad Social del mismo./';
        BudgetContentL = 'The present budget has been made according to the items and measurements made by us and according to our criteria in terms of qualities and materials used, so we are not responsible if the qualities do not match those designed by the project architect, as well as in measurements./ El presente presupuesto ha sido realizado conforme a las partidas y mediciones realizadas por nosotros y seg£n nuestros criterios en cuanto a calidades y materiales empleados, por lo que no nos responsabilizamos si las calidades no coinciden con las pensadas por el arquitecto redactor del proyecto, as¡ como en las mediciones./';
        AccordingPropertyL = 'According the property/ Conforme la propiedad/';
        AccordingContractorL = 'According the contractor/ Conforme el contratista/';
        TimeValidityContractL = '"VALIDITY OF THIS BUDGET WILL BE FOR "/ LA VALIDEZ DEL PRESENTE PRESUPUESTO SERµ DE/';
        MounthL = 'mounth/ mes/';
        MounthsL = 'mounths/ meses/';
        AscendToL = 'Ascend the general budget to the quantity expressed/ Asciende el presupuesto general a la expresada cantidad de/';
        AmountLowL = 'Amount Low/ Importe Baja/';
        IndustrialBenefit = 'Industrial Benefit/ Beneficio Industrial/';
        WithIVAL = 'Included VAT/ IVA incluido/';
        lblCliente = 'Customer:/ Cliente:/';
        lblNPresupuesto = 'Budget No:/ N§ Presupuesto:/';
        lblFechaPresupuesto = 'Budget Date:/ Fecha Presupuesto:/';
        lblDescripcion = 'Description:/ Descripci¢n:/';
        lblResumenPresupuesto = 'BUDGET SUMMARY/ RESUMEN DE PRESUPUESTO/';
        lblPresupuesto = 'BUDGET/ PRESUPUESTO/';
        lblEjecucionMaterial = 'MATERIAL EXECUTION/ EJECUCIàN MATERIAL/';
        lblCertifSinIVA = 'CERTIFICACIàN SIN IVA/';
        lblLiquidoCertif = '"LÖQUIDO CERTIFICACIàN N§ "/';
        lblGtosGrales = 'Gtos grales/';
        lblBIndustrial = 'B§ Industrial/';
        lblCantidad = 'QUANT./ CANT./';
        lblPrecio = 'PRICE/ PRECIO/';
        lblUDS = 'UTS/ UDS/';
        lblLAR = 'HEIGHT/ LAR/';
        lblANC = 'WIDTH/ ANC/';
        lblCANT = 'QUANT/ CANT/';
        lblLong = 'LENGTH/ LONG/';
        lblCBaja = 'Low Coefficient/ Coeficiente baja/';
        lblCIndirectos = 'Indirect Coefficients/ Coef. Indirectos/';
        lblTotalCapi = 'Total cap¡tulos/';
        lblTotalBase = 'Total base/';
        lblCapitulo = 'CAP./';
    }

    var
        //       DescriptionText@7001120 :
        DescriptionText: ARRAY[2] OF Text[80];
        //       ChangeNotInLetters@7001114 :
        ChangeNotInLetters: Codeunit 7207289;
        //       FirstPage@7001107 :
        FirstPage: Boolean;
        //       Customer@7001109 :
        Customer: Record 18;
        //       CustAddr@7001108 :
        CustAddr: ARRAY[8] OF Text[50];
        //       FormatAddress@7001110 :
        FormatAddress: Codeunit 365;
        //       JobsSetup@7001119 :
        JobsSetup: Record 315;
        //       PrintMeasureLines@7001103 :
        PrintMeasureLines: Boolean;
        //       OnlySummary@7001122 :
        OnlySummary: Boolean;
        //       ExtendedLine@7001126 :
        ExtendedLine: Text;
        //       QBText@7001128 :
        QBText: Record 7206918;
        //       CompanyInformation@7001100 :
        CompanyInformation: Record 79;
        //       NotValuate@7001101 :
        NotValuate: Boolean;
        //       TotalAmount@7001124 :
        TotalAmount: Decimal;
        //       ValidateQuote@7001113 :
        ValidateQuote: Decimal;
        //       DescriptionTextValid@7001115 :
        DescriptionTextValid: ARRAY[2] OF Text[57];
        //       MonthsTx@7001116 :
        MonthsTx: Text[30];
        //       HeaderTx@7001102 :
        HeaderTx: Text[30];
        //       Text001@7001104 :
        Text001: TextConst ENU = 'MEASUREMENTS', ESP = 'MEDICIONES';
        //       Text002@7001105 :
        Text002: TextConst ENU = 'MEASUREMENTS and BUDGET', ESP = 'MEDICIONES Y PRESUPUESTO';
        //       Text003@7001106 :
        Text003: TextConst ENU = 'BUDGET', ESP = 'PRESUPUESTO';
        //       WithIVA@7001121 :
        WithIVA: Boolean;
        //       VATPostingSetup@7001112 :
        VATPostingSetup: Record 325;
        //       ImportaPrint@7001123 :
        ImportaPrint: Decimal;
        //       Currency@7001111 :
        Currency: Record 4;
        //       Text004@7001117 :
        Text004: TextConst ENU = 'MONTHS', ESP = 'MESES';
        //       Text005@7001118 :
        Text005: TextConst ENU = 'MONTH', ESP = 'MES';
        //       UnitaryPrice@7001127 :
        UnitaryPrice: Decimal;
        //       PieceworkAmountSaleContract@7001134 :
        PieceworkAmountSaleContract: Decimal;
        //       Father@7001125 :
        Father: Code[20];
        //       CityDate@7001129 :
        CityDate: Text[100];
        //       Text006@7001130 :
        Text006: TextConst ENU = ', to ', ESP = ', a ';
        //       Text007@7001131 :
        Text007: TextConst ENU = ' of ', ESP = ' de ';
        //       IsUnit@7001132 :
        IsUnit: Boolean;
        //       NotFather@7001133 :
        NotFather: Boolean;
        //       PrintMeasureLinesEnable@7001135 :
        PrintMeasureLinesEnable: Boolean;
        //       Job2@7001143 :
        Job2: Record 167;
        //       PorcGtosGrales@7001142 :
        PorcGtosGrales: Decimal;
        //       GtosGrales@7001141 :
        GtosGrales: Boolean;
        //       PorcBIndustrial@7001140 :
        PorcBIndustrial: Decimal;
        //       BIndustrial@7001139 :
        BIndustrial: Boolean;
        //       PorcCoefBaja@7001160 :
        PorcCoefBaja: Decimal;
        //       CoefBaja@7001161 :
        CoefBaja: Boolean;
        //       PorcCoefInd@7001162 :
        PorcCoefInd: Decimal;
        //       CoefInd@7001163 :
        CoefInd: Boolean;
        //       VATPostingSetup2@7001138 :
        VATPostingSetup2: Record 325;
        //       Customer2@7001137 :
        Customer2: Record 18;
        //       PorcIVA@7001136 :
        PorcIVA: Decimal;
        //       Capitulo_CaptionLbl@7001146 :
        Capitulo_CaptionLbl: TextConst ENU = 'CHAPTER', ESP = 'CAPÖTULO';
        //       Resumen_CaptionLbl@7001145 :
        Resumen_CaptionLbl: TextConst ENU = 'SUMMARY', ESP = 'RESUMEN';
        //       Importe_CaptionLbl@7001144 :
        Importe_CaptionLbl: TextConst ENU = 'AMOUNT', ESP = 'IMPORTE';
        //       LineaTotal@7001147 :
        LineaTotal: Boolean;
        //       DataPieceworkForProduction@7001148 :
        DataPieceworkForProduction: Record 7207386;
        //       TotalCapituloText@7001150 :
        TotalCapituloText: Text[50];
        //       TotalCapituloBuffer@7001151 :
        TotalCapituloBuffer: Decimal;
        //       LineaTotalTotal@7001152 :
        LineaTotalTotal: Boolean;
        //       TotalTotalCapituloText@7001153 :
        TotalTotalCapituloText: Text[50];
        //       TotalTotalCapituloBuffer@7001154 :
        TotalTotalCapituloBuffer: Decimal;
        //       TotalPresupuesto@7001155 :
        TotalPresupuesto: Decimal;
        //       UltimaFila@7001156 :
        UltimaFila: Boolean;
        //       MeasurementLinPiecewProd@7001157 :
        MeasurementLinPiecewProd: Record 7207390;
        //       contador@7001158 :
        contador: Integer;
        //       Mayor@7001159 :
        Mayor: Boolean;
        //       CustomerName@7001164 :
        CustomerName: Text[50];
        //       Records2@7001165 :
        Records2: Record 7207393;
        //       TotalExpediente@7001166 :
        TotalExpediente: Decimal;
        //       Capi@7001167 :
        Capi: Text[2];
        //       DataPieceworkForProduction3@7001168 :
        DataPieceworkForProduction3: Record 7207386;
        //       DataPieceworkForProduction2@7001149 :
        DataPieceworkForProduction2: Record 7207386;



    trigger OnInitReport();
    begin

        PrintMeasureLinesEnable := TRUE;
        contador := 0;
    end;



    LOCAL procedure NotValuateOnPush()
    begin
        if NotValuate then
            OnlySummary := FALSE;
    end;

    /*begin
    //{
//      001 MCG 05/09/17 - A¤adida "IsUnit" para modificar condici¢n de visibilidad de las l¡neas en el layout
//      002 MCG 07/09/17 - A¤adida condici¢n para calcular el IVA si muestra las l¡neas de medici¢n
//      QVE3197 PGM 26/10/2018 - Sustituido el logo de la Info. Empresa por una imagen incrustada en el layout por problemas de procesamiento.
//
//      JAV 04/03/19: - Hacer que no duplique textos extendidos de la l¡nea si no los tiene
//      JAV 19/03/19: - Se cambia el caption del report para que exprese lo que realmente hace
//                    - Se hace que no saque el filtro del expediente pues no hace falta, pero se a¤ade el filtro de c¢digo en la U.O. del cap¡tulo
//                    - Hacer que solo sume en el total lo que se presenta en el informe
//                    - Que no a¤ada un espacio delante de la primera l¡nea de texto extendido
//    }
    end.
  */



}
