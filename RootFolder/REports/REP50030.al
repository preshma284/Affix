// report 50030 "Vesta: Quote Public Offer"
// {
  
  
//     CaptionML=ENU='Print Public Offer',ESP='Vesta: Impresi¢n de la oferta p£blica';
//     ShowPrintStatus=true;
    
//   dataset
// {

// DataItem("Job";"Job")
// {

//                DataItemTableView=SORTING("No.")
//                                  WHERE("Card Type"=CONST("Estudio"),"Job Matrix - Work"=CONST("Work"));
//                PrintOnlyIfDetail=false;
               

//                RequestFilterFields="No.";
// Column(JobNo;"No.")
// {
// //SourceExpr="No.";
// }Column(WithIVA;WithIVA)
// {
// //SourceExpr=WithIVA;
// }Column(NotValuate;NotValuate)
// {
// //SourceExpr=NotValuate;
// }Column(OnlyResume;OnlySummary)
// {
// //SourceExpr=OnlySummary;
// }Column(PrintMeasureLines;PrintMeasureLines)
// {
// //SourceExpr=PrintMeasureLines;
// }Column(DateFooter;FORMAT(TODAY,0,'<Day> of <Month Text> of <Year4>'))
// {
// //SourceExpr=FORMAT(TODAY,0,'<Day> of <Month Text> of <Year4>');
// }Column(CompanyInformation_Picture;CompanyInformation.Picture)
// {
// //SourceExpr=CompanyInformation.Picture;
// }Column(CityDate;CityDate)
// {
// //SourceExpr=CityDate;
// }Column(HeaderTx;HeaderTx)
// {
// //SourceExpr=HeaderTx;
// }Column(DescriptionText1;DescriptionText[1])
// {
// //SourceExpr=DescriptionText[1];
// }Column(DescriptionText2;DescriptionText[2])
// {
// //SourceExpr=DescriptionText[2];
// }Column(DescriptionTextValid;[DescriptionTextValid[1]] ])
// {
// //SourceExpr=[DescriptionTextValid[1]] ];
// }Column(MonthsTx;MonthsTx)
// {
// //SourceExpr=MonthsTx;
// }Column(CustAddr_1;CustAddr[1])
// {
// //SourceExpr=CustAddr[1];
// }Column(CustAddr_2;CustAddr[2])
// {
// //SourceExpr=CustAddr[2];
// }Column(CustAddr_4;CustAddr[4])
// {
// //SourceExpr=CustAddr[4];
// }Column(CustAddr_3;CustAddr[3])
// {
// //SourceExpr=CustAddr[3];
// }Column(CustAddr_5;CustAddr[5])
// {
// //SourceExpr=CustAddr[5];
// }Column(CustAddr_6;CustAddr[6])
// {
// //SourceExpr=CustAddr[6];
// }Column(JobDescription;Job.Description + Job."Description 2")
// {
// //SourceExpr=Job.Description + Job."Description 2";
// }Column(Amou_Job;Job."Amou Piecework Meas./Certifi.")
// {
// //SourceExpr=Job."Amou Piecework Meas./Certifi.";
// }Column(Billtoname_Job;Job."Bill-to Name")
// {
// //SourceExpr=Job."Bill-to Name";
// }Column(Billtoname2_Job;Job."Bill-to Name 2")
// {
// //SourceExpr=Job."Bill-to Name 2";
// }Column(SentDate;Job."Sent Date")
// {
// //SourceExpr=Job."Sent Date";
// }Column(AmountLow;AmountLow)
// {
// //SourceExpr=AmountLow;
// }Column(AmountIndustrialBenefit;AmountIndustrialBenefit)
// {
// //SourceExpr=AmountIndustrialBenefit;
// }Column(PorcGtosGrales;PorcGtosGrales)
// {
// //SourceExpr=PorcGtosGrales;
// }Column(GtosGrales;GtosGrales)
// {
// //SourceExpr=GtosGrales;
// }Column(PorcBIndustrial;PorcBIndustrial)
// {
// //SourceExpr=PorcBIndustrial;
// }Column(BIndustrial;BIndustrial)
// {
// //SourceExpr=BIndustrial;
// }Column(PorcCoefBaja;PorcCoefBaja)
// {
// //SourceExpr=PorcCoefBaja;
// }Column(CoefBaja;CoefBaja)
// {
// //SourceExpr=CoefBaja;
// }Column(PorcCoefInd;PorcCoefInd)
// {
// //SourceExpr=PorcCoefInd;
// }Column(CoefInd;CoefInd)
// {
// //SourceExpr=CoefInd;
// }Column(PorcIVA;PorcIVA)
// {
// //SourceExpr=PorcIVA;
// }DataItem("Data Piecework For Production";"Data Piecework For Production")
// {

//                DataItemTableView=WHERE("Customer Certification Unit"=FILTER(true));
               

//                RequestFilterFields="No.";
// DataItemLink="Job No."= FIELD("No.");
// Column(Piecework_Code;"Data Piecework For Production"."Piecework Code")
// {
// //SourceExpr="Data Piecework For Production"."Piecework Code";
// }Column(Piecework_AccountType;"Data Piecework For Production"."Account Type")
// {
// //SourceExpr="Data Piecework For Production"."Account Type";
// }Column(Piecework_Type;"Data Piecework For Production".Type)
// {
// //SourceExpr="Data Piecework For Production".Type;
// }Column(Piecework_Indentation;"Data Piecework For Production".Indentation)
// {
// //SourceExpr="Data Piecework For Production".Indentation;
// }Column(Piecework_Description;"Data Piecework For Production".Description)
// {
// //SourceExpr="Data Piecework For Production".Description;
// }Column(Piecework_Description2;"Data Piecework For Production"."Description 2")
// {
// //SourceExpr="Data Piecework For Production"."Description 2";
// }Column(Piecework_SaleQuantityBase;"Data Piecework For Production"."Sale Quantity (base)")
// {
// //SourceExpr="Data Piecework For Production"."Sale Quantity (base)";
// }Column(Piecework_Price;Precio)
// {
// //SourceExpr=Precio;
//                AutoFormatType=2;
// }Column(Piecework_Amount;Importe)
// {
// //SourceExpr=Importe;
// }Column(Piecework_CodePieceworkPresto;"Data Piecework For Production"."Code Piecework PRESTO")
// {
// //SourceExpr="Data Piecework For Production"."Code Piecework PRESTO";
// }Column(Piecework_UnitOfMeasure;"Data Piecework For Production"."Unit Of Measure")
// {
// //SourceExpr="Data Piecework For Production"."Unit Of Measure";
// }Column(Piecework_CustomerCertificationUnit;"Data Piecework For Production"."Customer Certification Unit")
// {
// //SourceExpr="Data Piecework For Production"."Customer Certification Unit";
// }Column(Piecework_UniqueCode;"Data Piecework For Production"."Unique Code")
// {
// //SourceExpr="Data Piecework For Production"."Unique Code";
// }Column(LineaTotal;LineaTotal)
// {
// //SourceExpr=LineaTotal;
// }Column(TotalCapituloBuffer;TotalCapituloBuffer)
// {
// //SourceExpr=TotalCapituloBuffer;
// }Column(TotalCapituloText;TotalCapituloText)
// {
// //SourceExpr=TotalCapituloText;
// }Column(LineaTotalTotal;LineaTotalTotal)
// {
// //SourceExpr=LineaTotalTotal;
// }Column(TotalTotalCapituloText;TotalTotalCapituloText)
// {
// //SourceExpr=TotalTotalCapituloText;
// }Column(TotalTotalCapituloBuffer;TotalTotalCapituloBuffer)
// {
// //SourceExpr=TotalTotalCapituloBuffer;
// }Column(TotalPresupuesto;TotalPresupuesto)
// {
// //SourceExpr=TotalPresupuesto;
// }Column(ExtendedLine;ExtendedLine)
// {
// //SourceExpr=ExtendedLine;
// }DataItem("Measurement Lin. Piecew. Prod.";"Measurement Lin. Piecew. Prod.")
// {

//                DataItemTableView=SORTING("Job No.","Piecework Code","Line No.");
// DataItemLink="Job No."= FIELD("Job No."),
//                             "Piecework Code"= FIELD("Piecework Code");
// Column(LineMeasure_JobNo;"Job No.")
// {
// //SourceExpr="Job No.";
// }Column(LineMeasure_PieceworkCode;"Piecework Code")
// {
// //SourceExpr="Piecework Code";
// }Column(LineMeasure_LineNo;"Line No.")
// {
// //SourceExpr="Line No.";
// }Column(LineMeasure_Description;Description)
// {
// //SourceExpr=Description;
// }Column(LineMeasure_Units;Units)
// {
// //SourceExpr=Units;
// }Column(LineMeasure_Lenght;Length)
// {
// //SourceExpr=Length;
// }Column(LineMeasure_Width;Width)
// {
// //SourceExpr=Width;
// }Column(LineMeasure_Height;Height)
// {
// //SourceExpr=Height;
// }Column(LineMeasure_Total;Total )
// {
// //SourceExpr=Total ;
// }trigger OnPreDataItem();
//     BEGIN 
//                                IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN BEGIN 
//                                  IsUnit := FALSE; //+001
//                                  CurrReport.SKIP;
//                                END;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF ("Measurement Lin. Piecew. Prod.".Description = '') AND ("Measurement Lin. Piecew. Prod.".Length = 0) AND ("Measurement Lin. Piecew. Prod.".Units = 0) AND
//                                     ("Measurement Lin. Piecew. Prod.".Height = 0) AND ("Measurement Lin. Piecew. Prod.".Width = 0) AND ("Measurement Lin. Piecew. Prod.".Total = 0) THEN
//                                     CurrReport.SKIP;
//                                 END;


// }trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF FirstLine = TRUE THEN BEGIN 
//                                     FirstLine := FALSE;
//                                     CLEAR(CompanyInformation.Picture);
//                                   END;

//                                   "Data Piecework For Production".CALCFIELDS("Accumulated Amount Contract","Accumulated Amount","Amount Production Budget");
//                                   //JAV 26/07/19: - Precio e importe dependen de si queremos desglosar GG/BI/Baja
//                                   IF PrecioConPorcentajes THEN BEGIN 
//                                     Precio  := "Data Piecework For Production"."Unit Price Sale (base)";
//                                     Importe := "Data Piecework For Production"."Sale Amount";
//                                   END ELSE BEGIN 
//                                     Precio  := "Data Piecework For Production"."Contract Price";
//                                     Importe := "Data Piecework For Production"."Amount Sale Contract";
//                                   END;
//                                   IF ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit) THEN
//                                     PEM += Importe;

//                                   IF NOT NotValuate THEN BEGIN 
//                                     IF WithIVA THEN
//                                       ImportaPrint := ROUND(("Accumulated Amount" * (1 + VATPostingSetup."VAT+EC %"/100)),Currency."Amount Rounding Precision")
//                                     ELSE
//                                       ImportaPrint := "Accumulated Amount";

//                                       IF "Data Piecework For Production"."Sale Quantity (base)" <> 0 THEN
//                                         UnitaryPrice := ROUND(ImportaPrint / "Data Piecework For Production"."Sale Quantity (base)",
//                                                              Currency."Unit-Amount Rounding Precision")
//                                       ELSE
//                                         UnitaryPrice := 0;
//                                   END;

//                                   Father:="Data Piecework For Production".ReturnFather("Data Piecework For Production");
//                                   IF (Father = '') THEN Father:= "Piecework Code";

//                                   IF "Account Type" ="Account Type"::Unit THEN BEGIN 
//                                     IsUnit := TRUE; //+001
//                                     IF WithIVA THEN BEGIN 
//                                       TotalAmount := ROUND(("Accumulated Amount" * (1 + VATPostingSetup."VAT+EC %"/100)),Currency."Amount Rounding Precision") + TotalAmount;
//                                     END ELSE BEGIN 
//                                       TotalAmount := "Accumulated Amount" + TotalAmount;
//                                     END;
//                                   END;

//                                   //Texto adicional
//                                   ExtendedLine := ''; //JAV 04/03/19: - Para que no duplique textos si la siguiente no los tiene
//                                   IF QBText.GET(QBText.Table::Job, "Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code") THEN
//                                     ExtendedLine := QBText.GetSalesText;

//                                   //Totales
//                                   CLEAR(LineaTotal);
//                                   CLEAR(LineaTotalTotal);
//                                   CLEAR(Mayor);
//                                   IF "Data Piecework For Production".Indentation = 0 THEN BEGIN 
//                                     TotalCapituloBuffer := "Data Piecework For Production"."Amount Production Budget"; //pgm
//                                     TotalTotalCapituloBuffer := "Data Piecework For Production"."Amount Production Budget";
//                                     TotalTotalCapituloText := "Data Piecework For Production"."Piecework Code";
//                                     TotalPresupuesto += "Data Piecework For Production"."Amount Production Budget";
//                                   END ELSE BEGIN 
//                                     //IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading THEN BEGIN //pgm
//                                     IF ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading) AND ("Data Piecework For Production".Indentation < 3) THEN BEGIN //pgm
//                                       TotalCapituloBuffer := "Data Piecework For Production"."Amount Production Budget";
//                                       TotalCapituloText := "Data Piecework For Production"."Piecework Code";
//                                     END;
//                                     DataPieceworkForProduction2.GET("Job No.","Piecework Code");
//                                     ident := DataPieceworkForProduction2.Indentation; //pgm
//                                     IF DataPieceworkForProduction2."Account Type" = DataPieceworkForProduction2."Account Type"::Heading THEN BEGIN 
//                                       Mayor := TRUE;
//                                     END;
//                                     DataPieceworkForProduction2.NEXT;
//                                       IF (DataPieceworkForProduction2."Account Type" = DataPieceworkForProduction2."Account Type"::Heading) AND (Mayor = FALSE) THEN
//                                         LineaTotal := TRUE;
//                                       IF (DataPieceworkForProduction2."Account Type" = DataPieceworkForProduction2."Account Type"::Heading) AND (Mayor = TRUE) AND (DataPieceworkForProduction2.Indentation = 1) THEN
//                                         LineaTotal := TRUE;
//                                       IF (DataPieceworkForProduction2."Account Type" = DataPieceworkForProduction2."Account Type"::Heading) AND (Mayor = FALSE) AND (DataPieceworkForProduction2.Indentation = ident) THEN // pgm
//                                         LineaTotal := FALSE;  // pgm

//                                     IF DataPieceworkForProduction2.Indentation = 0 THEN BEGIN 
//                                       LineaTotalTotal := TRUE;
//                                       LineaTotal := FALSE;
//                                     END;
//                                   END;
//                                 END;


// }trigger OnAfterGetRecord();
//     VAR
// //                                   DataPieceworkForProd@7001100 :
//                                   DataPieceworkForProd: Record 7207386;
// //                                   MeasurementLinPiecewProd@7001101 :
//                                   MeasurementLinPiecewProd: Record 7207390;
//                                 BEGIN 
//                                   CLEAR(CustAddr);
//                                   IF "Bill-to Customer No." <> '' THEN BEGIN 
//                                     Customer.GET("Bill-to Customer No.");
//                                     FormatAddress.Customer(CustAddr,Customer);
//                                   END;
//                                   COMPRESSARRAY(CustAddr);

//                                   CLEAR(Currency);
//                                   IF Job."Currency Code" <> '' THEN
//                                     Currency.GET(Job."Currency Code");
//                                   Currency.InitRoundingPrecision;
//                                   IF NOT VATPostingSetup.GET(Customer."VAT Bus. Posting Group",Job."VAT Prod. PostingGroup") THEN
//                                     CLEAR(VATPostingSetup);

//                                   IF (Job."Creation Date" <> 0D) AND (Job."Validate Quote" <> 0D) THEN BEGIN 
//                                     ValidateQuote := Job."Validate Quote" - Job."Creation Date";
//                                     ValidateQuote := ROUND(ValidateQuote/30,1);
//                                     //ChangeNotInLetters.FormatNoText(DescriptionTextValid,ValidateQuote,'');
//                                     ChangeNotInLetters.Decimal2TextTwoLines(DescriptionTextValid[1],DescriptionTextValid[2], MAXSTRLEN(DescriptionTextValid[1]), ValidateQuote, FALSE, '', 0);

//                                     IF ValidateQuote = 1 THEN
//                                       MonthsTx := Text005
//                                     ELSE
//                                       MonthsTx := Text004
//                                   END;

//                                   //Gtos Generales, B§ Industrial, Coeficiente baja y Coeficientes indirectos
//                                   IF (NOT PrecioConPorcentajes) THEN BEGIN 
//                                     IF Job."General Expenses / Other" <> 0 THEN BEGIN 
//                                       PorcGtosGrales := Job."General Expenses / Other";
//                                       GtosGrales := TRUE;
//                                     END;

//                                     IF Job."Industrial Benefit" <> 0 THEN BEGIN 
//                                       PorcBIndustrial := Job."Industrial Benefit";
//                                       BIndustrial := TRUE
//                                     END;

//                                     IF Job."Low Coefficient" <> 0 THEN BEGIN 
//                                       PorcCoefBaja := Job."Low Coefficient";
//                                       CoefBaja := TRUE
//                                     END;

//                                     IF Job."Quality Deduction" <> 0 THEN BEGIN 
//                                       PorcCoefInd := Job."Quality Deduction";
//                                       CoefInd := TRUE
//                                     END;
//                                   END;

//                                   Job.CALCFIELDS("Contract Amount");
//                                   QBTableSubscriber.TJob_CalcPorcAmounts(Job, Job."Contract Amount", AmountGG, AmountIndustrialBenefit, AmountLow);

//                                   //IVA
//                                   VATPostingSetup2.RESET;
//                                   VATPostingSetup2.SETRANGE("VAT Bus. Posting Group",Customer."VAT Bus. Posting Group");
//                                   VATPostingSetup2.SETRANGE("VAT Prod. Posting Group",Job."VAT Prod. PostingGroup");
//                                   IF VATPostingSetup2.FINDFIRST THEN
//                                     PorcIVA := VATPostingSetup2."VAT %";
//                                 END;


// }
// }
//   requestpage
//   {

//     layout
// {
// area(content)
// {
// group("group66")
// {
        
//                   CaptionML=ENU='Options',ESP='Opciones';
//     field("OnlySummary";"OnlySummary")
//     {
        
//                   CaptionML=ENU='Do you want summary only print?',ESP='¨Imprimir solo resumen?';
                  
//                               ;trigger OnValidate()    BEGIN
//                                CompletoEnable := NOT OnlySummary;
//                                IF OnlySummary THEN BEGIN
//                                  PrintMeasureLines := FALSE;
//                                  NotValuate := FALSE;
//                                END;
//                              END;


//     }
//     field("PrintMeasureLines";"PrintMeasureLines")
//     {
        
//                   CaptionML=ENU='Do you want measure lines include?',ESP='¨Incluir l¡neas de medici¢n?';
//                   Enabled=CompletoEnable ;
//     }
//     field("NotValuate";"NotValuate")
//     {
        
//                   CaptionML=ENU='Not valuate?',ESP='¨Sin valorar?';
//                   Enabled=CompletoEnable ;
//     }
//     field("WithIVA";"WithIVA")
//     {
        
//                   CaptionML=ENU='Print with IVA',ESP='Imprimir con IVA';
//     }

// }

// }
// }trigger OnInit()    BEGIN
//                CompletoEnable := TRUE;
//              END;


//   }
//   labels
// {
// PageNoL='Page/ P g./';
// AmountL='Amount/ Importe/';
// PUnitL='Unitary Price/ P. unitario/';
// QuantityL='Quantity/ Cantidad/';
// DescL='Description/ Descripci¢n/';
// PartialsL='Partials/ Parciales/';
// HeightL='Height/ Altura/';
// WidthL='Width/ Anchura/';
// LongL='Long/ Longitud/';
// UnitsL='Units/ Uds./';
// CodeL='Code/ Codigo/';
// TotalPieceworkL='PIECEWORK TOTAL/ TOTAL U.O./';
// TitleL='Title/ T¡tulo/';
// TotalBudgetL='BUDGET TOTAL/ TOTAL PRESUPUESTO/';
// TotalOfferL='OFFER TOTAL/ TOTAL OFERTA/';
// StringEmptyL='-/';
// QtyIncrementVATL='This amount will be increased by the corresponding VAT./ Esta cantidad se ver  incrementada por el IVA correspondiente./';
// AccountPropertyL='Will be of account of the property all type of Municipal Licenses as well as the fees of the Facultative Direction./ Ser n de cuenta de la propiedad todo tipo de Licencias Municipales as¡ como los honorarios de la Direcci¢n Facultativa/';
// ShipOutBudgetL='All item that is carried out outside budget, will be invoiced according to the unit prices agreed prior to its realization./ Toda partida que se realice fuera de presupuesto, ser  facturada conforme a los precios unitarios pactados con anterioridad a su realizaci¢n./';
// ShipJustifyL='The items marked A JUSTIFY, will be settled according to the work actually performed./ Las partidas marcadas como A JUSTIFICAR, se liquidar n seg£n obra realmente realizada./';
// AccountContractorL='The Contractor shall be responsible for the service and implementation of the necessary materials for the good development of the same, fees of all the personnel that work to his orders as well as the Social Security of the same./ Quedar  de cuenta de Contratista el servicio y puesta en obra de los materiales necesarios para el buen desarrollo de la misma, honorarios de todo el personal que trabaje a sus ordenes as¡ como la Seguridad Social del mismo./';
// BudgetContentL='The present budget has been made according to the items and measurements made by us and according to our criteria in terms of qualities and materials used, so we are not responsible if the qualities do not match those designed by the project architect, as well as in measurements./ El presente presupuesto ha sido realizado conforme a las partidas y mediciones realizadas por nosotros y seg£n nuestros criterios en cuanto a calidades y materiales empleados, por lo que no nos responsabilizamos si las calidades no coinciden con las pensadas por el arquitecto redactor del proyecto, as¡ como en las mediciones./';
// AccordingPropertyL='According the property/ Conforme la propiedad/';
// AccordingContractorL='According the contractor/ Conforme el contratista/';
// TimeValidityContractL='"VALIDITY OF THIS BUDGET WILL BE FOR "/ LA VALIDEZ DEL PRESENTE PRESUPUESTO SERµ DE/';
// MounthL='mounth/ mes/';
// MounthsL='mounths/ meses/';
// AscendToL='Ascend the general budget to the quantity expressed/ Asciende el presupuesto general a la expresada cantidad de/';
// AmountLowL='Amount Low/ Importe Baja/';
// IndustrialBenefit='Industrial Benefit/ Beneficio Industrial/';
// WithIVAL='Included VAT/ IVA incluido/';
// lblCliente='Customer:/ Cliente:/';
// lblNPresupuesto='Budget No:/ N§ Presupuesto:/';
// lblFechaPresupuesto='Budget Date:/ Fecha Presupuesto:/';
// lblDescripcion='Description:/ Descripci¢n:/';
// lblResumenPresupuesto='BUDGET SUMMARY/ RESUMEN DE PRESUPUESTO/';
// lblEjecucionMaterial='MATERIAL EXECUTION/ EJECUCIàN MATERIAL/';
// lblCertifSinIVA='CERTIFICACIàN SIN IVA/';
// lblLiquidoCertif='"LÖQUIDO CERTIFICACIàN N§ "/';
// lblGtosGrales='Gtos grales/';
// lblBIndustrial='B§ Industrial/';
// lblPresupuesto='BUDGET/ PRESUPUESTO/';
// lblCapitulo='CAPÖTULO/';
// lblResumen='RESUMEN/';
// lblCantidad='QUANT./ CANT/';
// lblPrecio='PRICE/ PRECIO/';
// lblUDS='UTS/ UDS/';
// lblLAR='HEIGHT/ LAR/';
// lblANC='WIDTH/ ANC/';
// lblCANT='QUANT/ CANT/';
// lblLong='LENGTH/ LONG/';
// lblCBaja='Low Coefficient/ Coeficiente baja/';
// lblCIndirectos='Indirect Coefficients/ Coef. Indirectos/';
// lblTotalCapi='Total cap¡tulos/';
// lblTotalBase='Total base/';
// lblImporte='IMPORTE/';
// }
  
//     var
// //       Customer@1000000016 :
//       Customer: Record 18;
// //       JobsSetup@1000000014 :
//       JobsSetup: Record 315;
// //       QBText@1000000013 :
//       QBText: Record 7206918;
// //       CompanyInformation@1000000012 :
//       CompanyInformation: Record 79;
// //       VATPostingSetup@1000000011 :
//       VATPostingSetup: Record 325;
// //       Currency@1000000010 :
//       Currency: Record 4;
// //       VATPostingSetup2@1000000008 :
//       VATPostingSetup2: Record 325;
// //       DataPieceworkForProduction2@1000000006 :
//       DataPieceworkForProduction2: Record 7207386;
// //       ChangeNotInLetters@1000000017 :
//       ChangeNotInLetters: Codeunit 7207289;
// //       FormatAddress@1000000015 :
//       FormatAddress: Codeunit 365;
// //       QBTableSubscriber@1100286009 :
//       QBTableSubscriber: Codeunit 7207347;
// //       DescriptionText@7001120 :
//       DescriptionText: ARRAY [2] OF Text[80];
// //       CustAddr@7001108 :
//       CustAddr: ARRAY [8] OF Text[50];
// //       ExtendedLine@7001126 :
//       ExtendedLine: Text;
// //       TotalAmount@7001124 :
//       TotalAmount: Decimal;
// //       ValidateQuote@7001113 :
//       ValidateQuote: Decimal;
// //       DescriptionTextValid@7001115 :
//       DescriptionTextValid: ARRAY [2] OF Text[57];
// //       MonthsTx@7001116 :
//       MonthsTx: Text[30];
// //       HeaderTx@7001102 :
//       HeaderTx: Text[30];
// //       Text001@7001104 :
//       Text001: TextConst ENU='MEASUREMENTS',ESP='MEDICIONES';
// //       Text002@7001105 :
//       Text002: TextConst ENU='MEASUREMENTS and BUDGET',ESP='MEDICIONES Y PRESUPUESTO';
// //       Text003@7001106 :
//       Text003: TextConst ENU='BUDGET',ESP='PRESUPUESTO';
// //       ImportaPrint@7001123 :
//       ImportaPrint: Decimal;
// //       Text004@7001117 :
//       Text004: TextConst ENU='MONTHS',ESP='MESES';
// //       Text005@7001118 :
//       Text005: TextConst ENU='MONTH',ESP='MES';
// //       UnitaryPrice@7001127 :
//       UnitaryPrice: Decimal;
// //       PieceworkAmountSaleContract@7001134 :
//       PieceworkAmountSaleContract: Decimal;
// //       Father@7001125 :
//       Father: Code[20];
// //       CityDate@7001129 :
//       CityDate: Text[100];
// //       Text006@7001130 :
//       Text006: TextConst ENU=', to ',ESP=', a ';
// //       Text007@7001131 :
//       Text007: TextConst ENU=' of ',ESP=' de ';
// //       IsUnit@7001132 :
//       IsUnit: Boolean;
// //       NotFather@7001133 :
//       NotFather: Boolean;
// //       PorcGtosGrales@7001142 :
//       PorcGtosGrales: Decimal;
// //       PorcBIndustrial@7001140 :
//       PorcBIndustrial: Decimal;
// //       BIndustrial@7001139 :
//       BIndustrial: Boolean;
// //       PorcCoefBaja@7001160 :
//       PorcCoefBaja: Decimal;
// //       CoefBaja@7001161 :
//       CoefBaja: Boolean;
// //       PorcCoefInd@7001162 :
//       PorcCoefInd: Decimal;
// //       CoefInd@7001163 :
//       CoefInd: Boolean;
// //       PorcIVA@7001136 :
//       PorcIVA: Decimal;
// //       LineaTotal@7001147 :
//       LineaTotal: Boolean;
// //       TotalCapituloText@7001150 :
//       TotalCapituloText: Text[50];
// //       TotalCapituloBuffer@7001151 :
//       TotalCapituloBuffer: Decimal;
// //       LineaTotalTotal@7001152 :
//       LineaTotalTotal: Boolean;
// //       TotalTotalCapituloText@7001153 :
//       TotalTotalCapituloText: Text[50];
// //       TotalTotalCapituloBuffer@7001154 :
//       TotalTotalCapituloBuffer: Decimal;
// //       TotalPresupuesto@7001155 :
//       TotalPresupuesto: Decimal;
// //       UltimaFila@7001156 :
//       UltimaFila: Boolean;
// //       Mayor@7001159 :
//       Mayor: Boolean;
// //       CRLF@7001166 :
//       CRLF: Text[2];
// //       FirstLine@1100286000 :
//       FirstLine: Boolean;
// //       Precio@1100286002 :
//       Precio: Decimal;
// //       Importe@1100286004 :
//       Importe: Decimal;
// //       PEM@1100286005 :
//       PEM: Decimal;
// //       AmountGG@1100286010 :
//       AmountGG: Decimal;
// //       AmountLow@1100286006 :
//       AmountLow: Decimal;
// //       AmountIndustrialBenefit@1100286007 :
//       AmountIndustrialBenefit: Decimal;
// //       GtosGrales@1100286008 :
//       GtosGrales: Boolean;
// //       "--------------------------------- OPCIONES"@1000000001 :
//       "--------------------------------- OPCIONES": Integer;
// //       OnlySummary@1000000003 :
//       OnlySummary: Boolean;
// //       PrintMeasureLines@1000000002 :
//       PrintMeasureLines: Boolean;
// //       NotValuate@1000000005 :
//       NotValuate: Boolean;
// //       WithIVA@1000000004 :
//       WithIVA: Boolean;
// //       PrecioConPorcentajes@1100286003 :
//       PrecioConPorcentajes: Boolean;
// //       CompletoEnable@1100286001 :
//       CompletoEnable: Boolean INDATASET;
// //       ident@1000000000 :
//       ident: Integer;

    

// trigger OnPreReport();    begin
//                   JobsSetup.GET;
//                   CompanyInformation.GET;
//                   CompanyInformation.CALCFIELDS(Picture);
//                   CityDate := CompanyInformation.City + Text006 + FORMAT(TODAY,0,'<Day>') + Text007 + FORMAT(TODAY,0,'<Month Text>') + Text007 + FORMAT(TODAY,0,'<Year4>');

//                   if NotValuate then
//                     HeaderTx := Text001
//                   else begin
//                     if PrintMeasureLines then
//                       HeaderTx := Text002
//                     else
//                       HeaderTx := Text003
//                   end;

//                   CRLF := '';
//                   CRLF[1] := 13;
//                   CRLF[2] := 10;

//                   FirstLine := TRUE;
//                 end;



// /*begin
//     {
//       001 MCG 05/09/17 - A¤adida "IsUnit" para modificar condici¢n de visibilidad de las l¡neas en el layout
//       002 MCG 07/09/17 - A¤adida condici¢n para calcular el IVA si muestra las l¡neas de medici¢n
//       QVE3197 PGM 26/10/2018 - Sustituido el logo de la Info. Empresa por una imagen incrustada en el layout por problemas de procesamiento.
//       JAV 14/03/19: - Si una l¡nea no tiene textos adicionales, imprimia el anterior
//                     - Eliminar un espcio inicial que a¤adia a los textos y que salte de linea si est  en blanco
//       JAV 26/07/19: - Se cambia el filtro de status por el de card type
//     }
//     end.
//   */
  
// }



// RequestFilterFields="Piecework Code";
