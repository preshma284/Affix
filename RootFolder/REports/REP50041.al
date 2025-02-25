// report 50041 "Vesta: Certificacion"
// {


//     CaptionML=ESP='Vesta: Certificaci¢n borrador';

//   dataset
// {

// DataItem("Measurement Header";"Measurement Header")
// {

//                DataItemTableView=SORTING("No.")
//                                  WHERE("Document Type"=CONST("Certification"));


//                RequestFilterFields="No.";
// Column(opcDetalleMedicion;opcDetalleMedicion)
// {
// //SourceExpr=opcDetalleMedicion;
// }Column(opcResumen;opcResumen)
// {
// //SourceExpr=opcResumen;
// }Column(FORMAT_TODAY_0___Day__Month_Text__Year4___;FORMAT(TODAY,0,'<Day>  <Month Text>, <Year4>'))
// {
// //SourceExpr=FORMAT(TODAY,0,'<Day>  <Month Text>, <Year4>');
// }Column(CurrReport_PAGENO;CurrReport.PAGENO)
// {
// //SourceExpr=CurrReport.PAGENO;
// }Column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
// {
// //SourceExpr=CurrReport_PAGENOCaptionLbl;
// }Column(Measurement_Header_Document_Type;"Document Type")
// {
// //SourceExpr="Document Type";
// }Column(Measurement_Header_No;"No.")
// {
// //SourceExpr="No.";
// }Column(Measurement_Header_Job_No;"Job No.")
// {
// //SourceExpr="Job No.";
// }Column(Name_MeasurementHeader;"Measurement Header".Name)
// {
// //SourceExpr="Measurement Header".Name;
// }Column(Name2_MeasurementHeader;"Measurement Header"."Name 2")
// {
// //SourceExpr="Measurement Header"."Name 2";
// }Column(PostingDate_MeasurementHeader;"Measurement Header"."Posting Date")
// {
// //SourceExpr="Measurement Header"."Posting Date";
// }Column(CertificationDate_MeasurementHeader;"Measurement Header"."Certification Date")
// {
// //SourceExpr="Measurement Header"."Certification Date";
// }Column(CertificationNo_MeasurementHeader;"Measurement Header"."No. Measure")
// {
// //SourceExpr="Measurement Header"."No. Measure";
// }Column(Description_MeasurementHeader;"Measurement Header".Description)
// {
// //SourceExpr="Measurement Header".Description;
// }Column(Description2_MeasurementHeader;"Measurement Header"."Description 2")
// {
// //SourceExpr="Measurement Header"."Description 2";
// }Column(Picture_CompanyInformation;CompanyInformation.Picture)
// {
// //SourceExpr=CompanyInformation.Picture;
// }Column(Name_CompanyInformation;CompanyInformation.Name)
// {
// //SourceExpr=CompanyInformation.Name;
// }Column(Certificacion_Caption;Certificacion_CaptionLbl)
// {
// //SourceExpr=Certificacion_CaptionLbl;
// }Column(Unidades_Caption;Unidades_CaptionLbl)
// {
// //SourceExpr=Unidades_CaptionLbl;
// }Column(Longitud_Caption;Longitud_CaptionLbl)
// {
// //SourceExpr=Longitud_CaptionLbl;
// }Column(Ancho_Caption;Ancho_CaptionLbl)
// {
// //SourceExpr=Ancho_CaptionLbl;
// }Column(Altura_Caption;Altura_CaptionLbl)
// {
// //SourceExpr=Altura_CaptionLbl;
// }Column(Cantidad_Caption;Cantidad_CaptionLbl)
// {
// //SourceExpr=Cantidad_CaptionLbl;
// }Column(Precio_Caption;Precio_CaptionLbl)
// {
// //SourceExpr=Precio_CaptionLbl;
// }Column(Subtotal_Caption;Subtotal_CaptionLbl)
// {
// //SourceExpr=Subtotal_CaptionLbl;
// }Column(CertificadoOrigen_Caption;CertificadoOrigen_CaptionLbl)
// {
// //SourceExpr=CertificadoOrigen_CaptionLbl;
// }Column(CertificacionAnteriores_Caption;CertificacionesAnteriores_CaptionLbl)
// {
// //SourceExpr=CertificacionesAnteriores_CaptionLbl;
// }Column(CertificacionActual_Caption;CertificacionActual_CaptionLbl)
// {
// //SourceExpr=CertificacionActual_CaptionLbl;
// }Column(NombreCliente1;NombreCliente1)
// {
// //SourceExpr=NombreCliente1;
// }Column(NombreCliente2;NombreCliente2)
// {
// //SourceExpr=NombreCliente2;
// }DataItem("Measurement Lines";"Measurement Lines")
// {

//                DataItemTableView=SORTING("Document type","Document No.","Line No.");
// DataItemLink="Document No."= FIELD("No.");
// Column(PieceworkNo_MeasurementLines;"Measurement Lines"."Piecework No.")
// {
// //SourceExpr="Measurement Lines"."Piecework No.";
// }Column(Description_MeasurementLines;"Measurement Lines".Description)
// {
// //SourceExpr="Measurement Lines".Description;
// }Column(Description2_MeasurementLines;"Measurement Lines"."Description 2")
// {
// //SourceExpr="Measurement Lines"."Description 2";
// }Column(Amount_MeasurementLines;"Measurement Lines"."Med. Term PEC Amount")
// {
// //SourceExpr="Measurement Lines"."Med. Term PEC Amount";
// }Column(City_CompanyInformation;CompanyInformation.City)
// {
// //SourceExpr=CompanyInformation.City;
// }Column(Capitulo_captionLbl;Capitulo_CaptionLbl)
// {
// //SourceExpr=Capitulo_CaptionLbl;
// }Column(Resumen_CaptionLbl;Resumen_CaptionLbl)
// {
// //SourceExpr=Resumen_CaptionLbl;
// }Column(Importe_Caption;Importe_CaptionLbl)
// {
// //SourceExpr=Importe_CaptionLbl;
// }Column(Quantity_MeasurementLines;"Measurement Lines"."Med. Term Measure")
// {
// //SourceExpr="Measurement Lines"."Med. Term Measure";
// }Column(SalesPrice_MeasurementLines;"Measurement Lines"."Contract Price")
// {
// //SourceExpr="Measurement Lines"."Contract Price";
// }Column(ContractPrice_MeasurementLines;"Measurement Lines"."Sales Price")
// {
// //SourceExpr="Measurement Lines"."Sales Price";
// }Column(CantCertAnterior;CantCertAnterior)
// {
// //SourceExpr=CantCertAnterior;
// }Column(CantCertOrigen;CantCertOrigen)
// {
// //SourceExpr=CantCertOrigen;
// }Column(DescMed;DescMed)
// {
// //SourceExpr=DescMed;
// }Column(TotalCapi;TotalCapi)
// {
// //SourceExpr=TotalCapi;
// }Column(TotalLinea;TotalLinea)
// {
// //SourceExpr=TotalLinea;
// }Column(TotalTotalLinea;TotalTotalLinea)
// {
// //SourceExpr=TotalTotalLinea;
// }Column(TotalTotalCapi;TotalTotalCapi)
// {
// //SourceExpr=TotalTotalCapi;
// }Column(TotalGeneral;TotalGeneral)
// {
// //SourceExpr=TotalGeneral;
// }Column(Capitulos;Capitulo)
// {
// //SourceExpr=Capitulo;
// }Column(CaptionCapitulo;CaptionCapitulo)
// {
// //SourceExpr=CaptionCapitulo;
// }Column(ADeducir_Caption;ADeducir_CaptionLbl)
// {
// //SourceExpr=ADeducir_CaptionLbl;
// }DataItem("Hist. Measure Lines";"Hist. Measure Lines")
// {

// DataItemLink="Document No."= FIELD("Document No."),
//                             "Job No."= FIELD("Job No."),
//                             "Piecework No."= FIELD("Piecework No.");
// DataItem("Data Piecework For Production";"Data Piecework For Production")
// {

// DataItemLink="Job No."= FIELD("Job No.");
// Column(Job_Description_______Job__Description_2_;Job.Description + ' '+Job."Description 2")
// {
// //SourceExpr=Job.Description + ' '+Job."Description 2";
// }Column(Identation_DataPieceworkForProduction;"Data Piecework For Production".Indentation)
// {
// //SourceExpr="Data Piecework For Production".Indentation;
// }Column(DRAFT_CERTIFICATION_N________Measurement_Header___No__;'DRAFT CERTIFICATION No.: ' + "Measurement Header"."No.")
// {
// //SourceExpr='DRAFT CERTIFICATION No.: ' + "Measurement Header"."No.";
// }Column(PADSTR____Indentation___2___Data_Piecework__For_Produc___DescUO;PADSTR('',Indentation * 2)+"Data Piecework For Production".DescUO)
// {
// //SourceExpr=PADSTR('',Indentation * 2)+"Data Piecework For Production".DescUO;
// }Column(Data_Piecework_For_Production___Piecework_Code;"Piecework Code")
// {
// //SourceExpr="Piecework Code";
// }Column(Data_Piecework_For_Production___Piecework_Code__Control1100229004;"Piecework Code")
// {
// //SourceExpr="Piecework Code";
// }Column(PADSTR____Indentation___2___Data_Piecework__For_Produc___DescUO_Control1100229003;PADSTR('',Indentation * 2)+"Data Piecework For Production".DescUO)
// {
// //SourceExpr=PADSTR('',Indentation * 2)+"Data Piecework For Production".DescUO;
// }Column(funUnitsOfMeasure;funUnitsOfMeasure)
// {
// //SourceExpr=funUnitsOfMeasure;
// }Column(QuantityToOrigin_Quantity;QuantityToOrigin+Quantity)
// {
// //SourceExpr=QuantityToOrigin+Quantity;
// }Column(OriginPrice;OriginPrice)
// {
// //SourceExpr=OriginPrice;
//                AutoFormatType=1;
// }Column(CertificateToOrigin_Certificate;CertificateToOrigin+Certificate)
// {
// //SourceExpr=CertificateToOrigin+Certificate;
//                AutoFormatType=1;
// }Column(CertificateToOrigin;CertificateToOrigin)
// {
// //SourceExpr=CertificateToOrigin;
//                AutoFormatType=1;
// }Column(QuantityToOrigin;QuantityToOrigin)
// {
// //SourceExpr=QuantityToOrigin;
// }Column(PreviousPrice;PreviousPrice)
// {
// //SourceExpr=PreviousPrice;
//                AutoFormatType=1;
// }Column(Certificate;Certificate)
// {
// //SourceExpr=Certificate;
//                AutoFormatType=1;
// }Column(Quantity;Quantity)
// {
// //SourceExpr=Quantity;
// }Column(SectionPrice;SectionPrice)
// {
// //SourceExpr=SectionPrice;
//                AutoFormatType=1;
// }Column(QuantityToOrigin_Quantity_Control1100229027;QuantityToOrigin+Quantity)
// {
// //SourceExpr=QuantityToOrigin+Quantity;
// }Column(QuantityToOrigin_Control1100229028;QuantityToOrigin)
// {
// //SourceExpr=QuantityToOrigin;
// }Column(Quantity_Control1100229029;Quantity)
// {
// //SourceExpr=Quantity;
// }Column(OriginPrice_Control1100229030;OriginPrice)
// {
// //SourceExpr=OriginPrice;
//                AutoFormatType=1;
// }Column(PreviousPrice_Control1100229031;PreviousPrice)
// {
// //SourceExpr=PreviousPrice;
//                AutoFormatType=1;
// }Column(SectionPrice_Control1100229032;SectionPrice)
// {
// //SourceExpr=SectionPrice;
//                AutoFormatType=1;
// }Column(CertificateToOrigin_SectionCertificate;CertificateToOrigin+SectionCertificate)
// {
// //SourceExpr=CertificateToOrigin+SectionCertificate;
//                AutoFormatType=1;
// }Column(CertificateToOrigin_Control1100229034;CertificateToOrigin)
// {
// //SourceExpr=CertificateToOrigin;
//                AutoFormatType=1;
// }Column(SectionCertificate;SectionCertificate)
// {
// //SourceExpr=SectionCertificate;
//                AutoFormatType=1;
// }Column(TOTAL_______Piecework_Code;'TOTAL  ' + "Piecework Code")
// {
// //SourceExpr='TOTAL  ' + "Piecework Code";
// }Column(TotalGeneralCertificateToOrigin_Certificate;TotalGeneralCertificateToOrigin+Certificate)
// {
// //SourceExpr=TotalGeneralCertificateToOrigin+Certificate;
//                AutoFormatType=1;
// }Column(TotalGeneralCertificateToOrigin;TotalGeneralCertificateToOrigin)
// {
// //SourceExpr=TotalGeneralCertificateToOrigin;
//                AutoFormatType=1;
// }Column(Certificate_Control1100229048;Certificate)
// {
// //SourceExpr=Certificate;
//                AutoFormatType=1;
// }Column(CodeCaption;CodeCaptionLbl)
// {
// //SourceExpr=CodeCaptionLbl;
// }Column(DescriptionCaption;DescriptionCaptionLbl)
// {
// //SourceExpr=DescriptionCaptionLbl;
// }Column(QuantityCaption;QuantityCaptionLbl)
// {
// //SourceExpr=QuantityCaptionLbl;
// }Column(PriceCaption;PriceCaptionLbl)
// {
// //SourceExpr=PriceCaptionLbl;
// }Column(AmountCaption;AmountCaptionLbl)
// {
// //SourceExpr=AmountCaptionLbl;
// }Column(AmountCaption_Control1100229060;AmountCaption_Control1100229060Lbl)
// {
// //SourceExpr=AmountCaption_Control1100229060Lbl;
// }Column(PriceCaption_Control1100229062;PriceCaption_Control1100229062Lbl)
// {
// //SourceExpr=PriceCaption_Control1100229062Lbl;
// }Column(QuantityCaption_Control1100229063;QuantityCaption_Control1100229063Lbl)
// {
// //SourceExpr=QuantityCaption_Control1100229063Lbl;
// }Column(DescriptionCaption_Control1100229064;DescriptionCaption_Control1100229064Lbl)
// {
// //SourceExpr=DescriptionCaption_Control1100229064Lbl;
// }Column(CodeCaption_Control1100229065;CodeCaption_Control1100229065Lbl)
// {
// //SourceExpr=CodeCaption_Control1100229065Lbl;
// }Column(PartialCaption;PartialCaptionLbl)
// {
// //SourceExpr=PartialCaptionLbl;
// }Column(LengthCaption;LengthCaptionLbl)
// {
// //SourceExpr=LengthCaptionLbl;
// }Column(WidthCaption;WidthCaptionLbl)
// {
// //SourceExpr=WidthCaptionLbl;
// }Column(HeightCaption;HeigthCaptionLbl)
// {
// //SourceExpr=HeigthCaptionLbl;
// }Column(Units_Caption;Units_CaptionLbl)
// {
// //SourceExpr=Units_CaptionLbl;
// }Column(Certification_to_OriginCaption;Certification_to_OriginCaptionLbl)
// {
// //SourceExpr=Certification_to_OriginCaptionLbl;
// }Column(Previous_CertificationsCaption;Previous_CertificationsCaptionLbl)
// {
// //SourceExpr=Previous_CertificationsCaptionLbl;
// }Column(Current_CertificationCaption;Current_CertificationCaptionLbl)
// {
// //SourceExpr=Current_CertificationCaptionLbl;
// }Column(Previous_CertificationsCaption_Control1100229025;Previous_CertificationsCaption_Control1100229025Lbl)
// {
// //SourceExpr=Previous_CertificationsCaption_Control1100229025Lbl;
// }Column(Current_CertificationCaption_Control1100229026;Current_CertificationCaption_Control1100229026Lbl)
// {
// //SourceExpr=Current_CertificationCaption_Control1100229026Lbl;
// }Column(Previous_CertificationsCaption_Control1100229036;Previous_CertificationsCaption_Control1100229036Lbl)
// {
// //SourceExpr=Previous_CertificationsCaption_Control1100229036Lbl;
// }Column(Current_CertificationCaption_Control1100229038;Current_CertificationCaption_Control1100229038Lbl)
// {
// //SourceExpr=Current_CertificationCaption_Control1100229038Lbl;
// }Column(TOTALCaption;TOTALCaptionLbl)
// {
// //SourceExpr=TOTALCaptionLbl;
// }Column(Data_Piecework_For_Production__Job_No;"Job No.")
// {
// //SourceExpr="Job No.";
// }Column(Data_Piecework_For_Production__Unique_Code;"Unique Code")
// {
// //SourceExpr="Unique Code";
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
// }Column(PorcIVA;PorcIVA)
// {
// //SourceExpr=PorcIVA;
// }Column(Type_Datapieceworkforproduction;"Data Piecework For Production".Type)
// {
// //SourceExpr="Data Piecework For Production".Type;
// }Column(AccountType_DataPieceworkForProduction;"Data Piecework For Production"."Account Type")
// {
// //SourceExpr="Data Piecework For Production"."Account Type";
// }Column(Description2_DataPieceworkForProduction;"Data Piecework For Production"."Description 2")
// {
// //SourceExpr="Data Piecework For Production"."Description 2";
// }Column(Description_DataPieceworkForProduction;"Data Piecework For Production".Description)
// {
// //SourceExpr="Data Piecework For Production".Description;
// }Column(cantidadOrigen2;cantidadorigen2)
// {
// //SourceExpr=cantidadorigen2;
// }Column(ContractPrice_DataPieceworkForProduction;"Data Piecework For Production"."Contract Price")
// {
// //SourceExpr="Data Piecework For Production"."Contract Price";
// }Column(PC_DataPieceworkForProduction;"Data Piecework For Production"."Piecework Code")
// {
// //SourceExpr="Data Piecework For Production"."Piecework Code";
// }Column(check;check)
// {
// //SourceExpr=check;
// }Column(Tipo;Tipo)
// {
// //SourceExpr=Tipo;
// }Column(Indentacion;Indentacion)
// {
// //SourceExpr=Indentacion;
// }Column(unidad;unidad)
// {
// //SourceExpr=unidad;
// }Column(DPFPCode;DPFPCode)
// {
// //SourceExpr=DPFPCode;
// }Column(DPFPDescription;DPFPDescription)
// {
// //SourceExpr=DPFPDescription;
// }Column(PRESTO;PRESTO)
// {
// //SourceExpr=PRESTO;
// }Column(TipoIVA;TipoIVA)
// {
// //SourceExpr=TipoIVA;
// }Column(ImporteCertLinea;ImporteCertLinea)
// {
// //SourceExpr=ImporteCertLinea;
// }Column(CertificacionAnterior;certificacionanterior)
// {
// //SourceExpr=certificacionanterior;
// }Column(ImporteCert2;ImporteCert2)
// {
// //SourceExpr=ImporteCert2;
// }DataItem("Measurement Lin. Piecew. Prod.";"Measurement Lin. Piecew. Prod.")
// {

// DataItemLink="Job No."= FIELD("Job No."),
//                             "Piecework Code"= FIELD("Piecework Code");
// Column(PieceworkCode_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod."."Piecework Code")
// {
// //SourceExpr="Measurement Lin. Piecew. Prod."."Piecework Code";
// }Column(JobNo_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod."."Job No.")
// {
// //SourceExpr="Measurement Lin. Piecew. Prod."."Job No.";
// }Column(Description_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Description)
// {
// //SourceExpr="Measurement Lin. Piecew. Prod.".Description;
// }Column(Units_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Units)
// {
// //SourceExpr="Measurement Lin. Piecew. Prod.".Units;
// }Column(Length_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Length)
// {
// //SourceExpr="Measurement Lin. Piecew. Prod.".Length;
// }Column(Width_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Width)
// {
// //SourceExpr="Measurement Lin. Piecew. Prod.".Width;
// }Column(Height_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Height)
// {
// //SourceExpr="Measurement Lin. Piecew. Prod.".Height;
// }Column(Total_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Total)
// {
// //SourceExpr="Measurement Lin. Piecew. Prod.".Total;
// }Column(contador;contador)
// {
// //SourceExpr=contador;
// }Column(DescVacia;DescVacia)
// {
// //SourceExpr=DescVacia;
// }DataItem("Data Cost By Piecework";"Data Cost By Piecework")
// {

//                DataItemTableView=SORTING("Piecework Code","Job No.");
// DataItemLink="Job No."= FIELD("Job No."),
//                             "Piecework Code"= FIELD("Piecework Code");
// Column(No_DataCostByPiecework;"Data Cost By Piecework"."No.")
// {
// //SourceExpr="Data Cost By Piecework"."No.";
// }Column(PieceworkCode_DataCostByPiecework;"Data Cost By Piecework"."Piecework Code")
// {
// //SourceExpr="Data Cost By Piecework"."Piecework Code";
// }Column(DescripcionDescompuesto;DescripcionDescompuesto)
// {
// //SourceExpr=DescripcionDescompuesto;
// }Column(TextoExtendido;TextoExtendido )
// {
// //SourceExpr=TextoExtendido ;
// }trigger OnAfterGetRecord();
//     BEGIN 

//                                   DataCostByPiecework.RESET;
//                                   DataCostByPiecework.SETRANGE("Job No.","Data Cost By Piecework"."Job No.");
//                                   DataCostByPiecework.SETRANGE("Piecework Code","Data Cost By Piecework"."Piecework Code");
//                                   IF DataCostByPiecework.FINDSET THEN BEGIN 
//                                     IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Resource THEN BEGIN 
//                                       Resource.RESET;
//                                       Resource.SETRANGE("No.","Data Cost By Piecework"."No.");
//                                       IF Resource.FINDSET THEN
//                                         DescripcionDescompuesto := Resource.Name + ' ' + Resource."Name 2";

//                                       //{ExtendedTextLine.RESET;
// //                                      ExtendedTextLine.SETRANGE("Table Name",ExtendedTextLine."Table Name"::Resource);
// //                                      ExtendedTextLine.SETRANGE("No.","Data Cost By Piecework"."No.");
// //                                      IF ExtendedTextLine.FINDSET THEN
// //                                        REPEAT
// //                                          TextoExtendido += ExtendedTextLine.Text + ' ';
// //                                        UNTIL ExtendedTextLine.NEXT = 0;}
//                                     END;

//                                     IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Item THEN BEGIN 
//                                       Item.RESET;
//                                       Item.SETRANGE("No.","Data Cost By Piecework"."No.");
//                                       IF Item.FINDSET THEN
//                                         DescripcionDescompuesto := Item.Description + Item."Description 2";

//                                       //{ExtendedTextLine.RESET;
// //                                      ExtendedTextLine.SETRANGE("Table Name",ExtendedTextLine."Table Name"::Item);
// //                                      ExtendedTextLine.SETRANGE("No.","Data Cost By Piecework"."No.");
// //                                      IF ExtendedTextLine.FINDSET THEN
// //                                        REPEAT
// //                                          TextoExtendido += ExtendedTextLine.Text + ' ';
// //                                        UNTIL ExtendedTextLine.NEXT = 0;}
//                                     END;

//                                     IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::Account THEN BEGIN 
//                                       GLAccount.RESET;
//                                       GLAccount.SETRANGE("No.","Data Cost By Piecework"."No.");
//                                       IF GLAccount.FINDSET THEN
//                                         DescripcionDescompuesto := GLAccount.Name;

//                                       //{ExtendedTextLine.RESET;
// //                                      ExtendedTextLine.SETRANGE("Table Name",ExtendedTextLine."Table Name"::"G/L Account");
// //                                      ExtendedTextLine.SETRANGE("No.","Data Cost By Piecework"."No.");
// //                                      IF ExtendedTextLine.FINDSET THEN
// //                                        REPEAT
// //                                          TextoExtendido += ExtendedTextLine.Text + ' ';
// //                                        UNTIL ExtendedTextLine.NEXT = 0;}
//                                     END;

//                                     //{IF DataCostByPiecework."Cost Type" = DataCostByPiecework."Cost Type"::"Resource Group" THEN BEGIN 
// //                                      ResourceGroup.RESET;
// //                                      ResourceGroup.SETRANGE("No.","Data Cost By Piecework"."No.");
// //                                      IF ResourceGroup.FINDSET THEN
// //                                        DescripcionDescompuesto := ResourceGroup.Name;
// //                                    END;}
//                                   END;
//                                 END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                contador := 0;
//                                "Measurement Lin. Piecew. Prod.".SETRANGE("Measurement Lin. Piecew. Prod."."Code Budget",Job."Current Piecework Budget");
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   PrimeraLinea();

//                                   DescVacia := 0;

//                                   IF ("Measurement Lin. Piecew. Prod.".Description = '') AND ("Measurement Lin. Piecew. Prod.".Total = 0) THEN BEGIN 
//                                    DescVacia := 1;
//                                     CurrReport.BREAK;
//                                   END;

//                                   IF ("Measurement Lin. Piecew. Prod.".Description <> '') OR ("Measurement Lin. Piecew. Prod.".Total <> 0) THEN
//                                     contador +=1;
//                                 END;

// trigger OnPostDataItem();
//     BEGIN 
//                                 contador := 0;
//                               END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                CurrReport.CREATETOTALS(Certificate,Quantity,CertificateToOrigin,QuantityToOrigin,
//                                                        CertificateToOriginTotalGen);
//                                FirstPage := TRUE;

//                                IF opcResumen = TRUE THEN BEGIN 
//                                  "Data Piecework For Production".SETRANGE("Data Piecework For Production".Indentation,0);
//                                  "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Account Type","Data Piecework For Production"."Account Type"::Heading);
//                                  "Data Piecework For Production".SETFILTER("Data Piecework For Production".Type,'<>%1',"Data Piecework For Production".Type::"Cost Unit");
//                                  "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Customer Certification Unit",TRUE);
//                                END;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF opcResumen = TRUE THEN BEGIN 
//                                     ImporteCertLinea := 0;
//                                     IF "Data Piecework For Production".Indentation = 0 THEN
//                                       ImporteCertifi += "Data Piecework For Production"."Certified Amount";

//                                     VATPostingSetup.RESET;
//                                     VATPostingSetup.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");
//                                     VATPostingSetup.SETRANGE("VAT Bus. Posting Group",'NAC');
//                                     IF VATPostingSetup.FINDSET THEN
//                                        TipoIVA := VATPostingSetup."VAT %";

//                                     //Gtos Generales y B§ Industrial
//                                     Job2.RESET;
//                                     Job2.SETRANGE("No.","Data Piecework For Production"."Job No.");
//                                     IF Job2.FINDFIRST THEN BEGIN 
//                                       IF Job2."General Expenses / Other" <> 0 THEN BEGIN 
//                                         PorcGtosGrales := Job2."General Expenses / Other";
//                                         GtosGrales := TRUE;
//                                       END ELSE
//                                         GtosGrales := FALSE;

//                                       IF Job2."Industrial Benefit" <> 0 THEN BEGIN 
//                                         PorcBIndustrial := Job2."Industrial Benefit";
//                                         BIndustrial := TRUE
//                                       END ELSE
//                                         BIndustrial := FALSE;

//                                       //IVA
//                                       Customer2.GET(Job2."Bill-to Customer No.");
//                                       VATPostingSetup2.RESET;
//                                       VATPostingSetup2.SETRANGE("VAT Bus. Posting Group",Customer2."VAT Bus. Posting Group");
//                                       VATPostingSetup2.SETRANGE("VAT Prod. Posting Group",Job2."VAT Prod. PostingGroup");
//                                       IF VATPostingSetup2.FINDFIRST THEN
//                                         PorcIVA := VATPostingSetup2."VAT %";
//                                     END;


//                                     MeasurementLines3.RESET;
//                                     MeasurementLines3.SETRANGE("Job No.","Measurement Header"."Job No.");
//                                     IF MeasurementLines3.FINDSET THEN BEGIN 
//                                       REPEAT
//                                         IF COPYSTR(MeasurementLines3."Piecework No.",1,STRLEN("Data Piecework For Production"."Piecework Code")) = "Data Piecework For Production"."Piecework Code" THEN
//                                           ImporteCertLinea += MeasurementLines3."Med. Measured Quantity" * MeasurementLines3."Sales Price";
//                                       UNTIL (MeasurementLines3.NEXT = 0) OR (MeasurementLines3."Document No." > "Measurement Header"."No.");
//                                     END;

//                                     CantCertAnterior := 0;

//                                     MeasurementHeader.RESET;
//                                     MeasurementHeader.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
//                                     MeasurementHeader.ASCENDING(FALSE);
//                                     IF MeasurementHeader.FINDSET THEN BEGIN 
//                                       REPEAT
//                                         MeasurementLines.RESET;
//                                         MeasurementLines.SETRANGE("Document No.",MeasurementHeader."No.");
//                                         MeasurementLines.SETRANGE("Piecework No.","Data Piecework For Production"."Piecework Code");
//                                         IF MeasurementLines.FINDFIRST THEN BEGIN 
//                                           IF MeasurementLines."Document No." = "Measurement Header"."No." THEN
//                                             BREAK;
//                                           CantCertAnterior += MeasurementLines."Med. Measured Quantity";
//                                         END;
//                                       UNTIL MeasurementHeader.NEXT = 0;
//                                     END;
//                                   END ELSE BEGIN 
//                                     PrimeraLinea;

//                                     TextoExtendido := '';
//                                     unidad := FALSE;

//                                     IF STRLEN("Data Piecework For Production"."Piecework Code") = 2 THEN BEGIN 
//                                       MeasurementLines.RESET;
//                                       MeasurementLines.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                                       IF MeasurementLines.FINDSET THEN
//                                         REPEAT
//                                           IF COPYSTR(MeasurementLines."Piecework No.",1,2) = "Data Piecework For Production"."Piecework Code" THEN BEGIN 
//                                             DPFPCode := "Data Piecework For Production"."Piecework Code";
//                                             DPFPDescription := "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
//                                             PRESTO := "Data Piecework For Production"."Piecework Code";
//                                             BREAK;
//                                           END ELSE BEGIN 
//                                             DPFPCode := '';
//                                             DPFPDescription := '';
//                                           END;
//                                         UNTIL MeasurementLines.NEXT = 0;
//                                         Tipo := "Data Piecework For Production"."Account Type";
//                                     END ELSE IF (STRLEN("Data Piecework For Production"."Piecework Code") = 4) AND ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading) THEN BEGIN 
//                                       MeasurementLines.RESET;
//                                       MeasurementLines.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                                       IF MeasurementLines.FINDSET THEN
//                                         REPEAT
//                                           IF COPYSTR(MeasurementLines."Piecework No.",1,4) = "Data Piecework For Production"."Piecework Code" THEN BEGIN 
//                                             DPFPCode := "Data Piecework For Production"."Piecework Code";
//                                             DPFPDescription := "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
//                                             PRESTO := "Data Piecework For Production"."Piecework Code";
//                                             BREAK;
//                                           END ELSE BEGIN 
//                                             DPFPCode := '';
//                                             DPFPDescription := '';
//                                             PRESTO := '';
//                                            // TotalCapi := 0;
//                                           END
//                                         UNTIL MeasurementLines.NEXT = 0;
//                                         Tipo := "Data Piecework For Production"."Account Type";
//                                     END ELSE BEGIN 
//                                       MeasurementLines.RESET;
//                                       MeasurementLines.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                                       MeasurementLines.SETRANGE("Line No.","Measurement Lines"."Line No.");
//                                       IF MeasurementLines.FINDFIRST THEN BEGIN 
//                                         IF MeasurementLines."Piecework No." = "Data Piecework For Production"."Piecework Code" THEN BEGIN 
//                                           DPFPCode := MeasurementLines."Piecework No.";
//                                           DPFPDescription := "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
//                                           PRESTO := "Data Piecework For Production"."Piecework Code";

//                                           IF QBText.GET(QBText.Table::Job, "Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code") THEN
//                                             TextoExtendido := QBText.GetSalesText;

//                                           Tipo := "Data Piecework For Production"."Account Type";
//                                           Indentacion := "Data Piecework For Production".Indentation;
//                                           unidad := TRUE;
//                                         END ELSE
//                                           CurrReport.SKIP;
//                                       END;
//                                     END;
//                                   END;
//                                 END;


// }trigger OnPreDataItem();
//     begin 
//                                //{"Measurement Lines".SETRANGE("Document type","Measurement Lines"."Document type"::Certification);
// //                               "Measurement Lines".SETRANGE("Document No.","Measurement Header"."No.");
// //                               IF "Data Piecework For Production".Totaling <> '' THEN
// //                                 "Measurement Lines".SETFILTER("Piecework No.","Data Piecework For Production".Totaling)
// //                               ELSE
// //                                 "Measurement Lines".SETRANGE("Piecework No.","Data Piecework For Production"."Piecework Code");}

//                                MeasurementNoCode := '';
//                                CurrReport.CREATETOTALS(Certificate,Quantity,SectionCertificate);
//                                conta := 0;
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   IF opcResumen = TRUE THEN
//                                     IF conta = 1 THEN
//                                       CurrReport.SKIP
//                                     ELSE
//                                       conta := 1;

//                                   IF TotalTotalLinea THEN
//                                     TotalTotalCapi := 0;

//                                   CantCertAnterior := 0;
//                                   TotalLinea := FALSE;
//                                   TotalTotalLinea := FALSE;

//                                   IF COPYSTR("Measurement Lines"."Piecework No.",1,4) <> Capitulo THEN
//                                     TotalCapi := 0;

//                                   MeasurementHeader.RESET;
//                                   MeasurementHeader.SETRANGE("Job No.","Measurement Lines"."Job No.");
//                                   IF MeasurementHeader.FINDSET THEN BEGIN 
//                                     REPEAT
//                                       IF MeasurementHeader."No." <> "Measurement Header"."No." THEN BEGIN 
//                                         MeasurementLines.RESET;
//                                         MeasurementLines.SETRANGE("Document No.",MeasurementHeader."No.");
//                                         MeasurementLines.SETRANGE("Piecework No.","Measurement Lines"."Piecework No.");
//                                         MeasurementLines.SETCURRENTKEY("Piecework No.");
//                                         IF MeasurementLines.FINDFIRST THEN BEGIN 
//                                         CantCertAnterior += MeasurementLines."Med. Measured Quantity";
//                                         END;
//                                       END;
//                                     UNTIL (MeasurementHeader.NEXT = 0) OR (MeasurementHeader."No." = "Measurement Header"."No.");
//                                   END;

//                                   CantCertOrigen := CantCertAnterior + "Measurement Lines"."Med. Measured Quantity";
//                                   TotalCapi += CantCertOrigen * "Measurement Lines"."Sales Price";
//                                   TotalTotalCapi += CantCertOrigen * "Measurement Lines"."Sales Price";
//                                   TotalGeneral += CantCertOrigen * "Measurement Lines"."Sales Price";

//                                   DataPieceworkForProduction.RESET;
//                                   DataPieceworkForProduction.SETRANGE("Job No.","Measurement Lines"."Job No.");
//                                   DataPieceworkForProduction.SETRANGE("Piecework Code",COPYSTR("Measurement Lines"."Piecework No.",1,4));
//                                   IF DataPieceworkForProduction.FINDFIRST THEN
//                                     Capitulo := DataPieceworkForProduction."Piecework Code";

//                                   DataPieceworkForProduction.RESET;
//                                   DataPieceworkForProduction.SETRANGE("Job No.","Measurement Lines"."Job No.");
//                                   DataPieceworkForProduction.SETRANGE("Piecework Code",COPYSTR("Measurement Lines"."Piecework No.",1,2));
//                                   IF DataPieceworkForProduction.FINDFIRST THEN
//                                     CaptionCapitulo :=  DataPieceworkForProduction."Code Piecework PRESTO";

//                                   MeasurementLines2.RESET;
//                                   MeasurementLines2.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                                   MeasurementLines2.SETCURRENTKEY("Piecework No.");
//                                   IF MeasurementLines2.FINDSET THEN BEGIN 
//                                     REPEAT
//                                       IF MeasurementLines2."Piecework No." = "Measurement Lines"."Piecework No." THEN BEGIN 
//                                         MeasurementLines2.NEXT;

//                                         MeasurementLines3.RESET;
//                                         MeasurementLines3.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                                         MeasurementLines3.SETCURRENTKEY("Piecework No.");
//                                         IF MeasurementLines3.FINDLAST THEN BEGIN 
//                                           IF (COPYSTR(MeasurementLines2."Piecework No.",1,2) <> COPYSTR("Measurement Lines"."Piecework No.",1,2)) OR ("Measurement Lines"."Piecework No." = MeasurementLines3."Piecework No.") THEN BEGIN 
//                                             TotalTotalLinea := TRUE;
//                                             TotalLinea := TRUE;
//                                             BREAK;
//                                           END ELSE IF (COPYSTR(MeasurementLines2."Piecework No.",1,4) <> COPYSTR("Measurement Lines"."Piecework No.",1,4)) OR ("Measurement Lines"."Piecework No." = MeasurementLines3."Piecework No.") THEN BEGIN 
//                                             TotalLinea := TRUE;
//                                             BREAK;
//                                           END;
//                                         END;
//                                       END;
//                                     UNTIL MeasurementLines2.NEXT = 0;
//                                   END;

//                               //     {
//                               //     IF "Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit THEN
//                               //       Certificate := "Measurement Lines".Amount
//                               //     ELSE
//                               //       SectionCertificate := "Measurement Lines".Amount;

//                               //     Quantity    := "Measurement Lines"."Quantity to Certificate";
//                               //     MeasurementNoCode := "Measurement Lines"."Measurement No.";
//                               //     SectionPrice := "Measurement Lines"."Sale Price (base)";

//                               //     CantCertAnterior := 0;
//                               //     TotalLinea := FALSE;
//                               //     TotalTotalLinea := FALSE;

//                               //     IF COPYSTR("Measurement Lines"."Piecework No.",1,4) <> Capitulo THEN
//                               //       TotalCapi := 0;

//                               //     PostCertifications.RESET;
//                               //     PostCertifications.SETRANGE("Job No.","Measurement Lines"."Job No.");
//                               //     PostCertifications.ASCENDING(FALSE);
//                               //     IF PostCertifications.FINDSET THEN BEGIN 
//                               //       REPEAT
//                               //         HistCertificationLines.RESET;
//                               //         HistCertificationLines.SETRANGE("Document No.",PostCertifications."No.");
//                               //         HistCertificationLines.SETRANGE("Piecework No.","Measurement Lines"."Piecework No.");
//                               //         IF HistCertificationLines.FINDFIRST THEN BEGIN 
//                               //           CantCertAnterior += HistCertificationLines.Quantity;
//                               //         END;
//                               //       UNTIL PostCertifications.NEXT = 0;
//                               //     END;

//                               //     CantCertOrigen := CantCertAnterior + "Measurement Lines"."Quantity to Certificate";
//                               //     DescMed := '';

//                               //     TotalCapi += CantCertOrigen * "Measurement Lines"."Contract Price";
//                               //     TotalTotalCapi += CantCertOrigen * "Measurement Lines"."Contract Price";
//                               //     Capitulo := COPYSTR("Measurement Lines"."Piecework No.",1,4);
//                               //     CaptionCapitulo :=  COPYSTR("Measurement Lines"."Piecework No.",1,2);

//                               //     MeasurementLines2.RESET;
//                               //     MeasurementLines2.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                               //     IF MeasurementLines2.FINDSET THEN BEGIN 
//                               //       REPEAT
//                               //         IF MeasurementLines2."Piecework No." = "Measurement Lines"."Piecework No." THEN BEGIN 
//                               //           MeasurementLines2.NEXT;

//                               //           MeasurementLines3.RESET;
//                               //           MeasurementLines3.SETRANGE("Document No.","Measurement Lines"."Document No.");
//                               //           IF MeasurementLines3.FINDLAST THEN BEGIN 

//                               //             IF (COPYSTR(MeasurementLines2."Piecework No.",1,2) <> COPYSTR("Measurement Lines"."Piecework No.",1,2)) OR ("Measurement Lines"."Piecework No." = MeasurementLines3."Piecework No.") THEN BEGIN 
//                               //               TotalTotalLinea := TRUE;
//                               //               TotalLinea := TRUE;
//                               //               BREAK;
//                               //             END ELSE IF (COPYSTR(MeasurementLines2."Piecework No.",1,4) <> COPYSTR("Measurement Lines"."Piecework No.",1,4)) OR ("Measurement Lines"."Piecework No." = MeasurementLines3."Piecework No.") THEN BEGIN 
//                               //               TotalLinea := TRUE;
//                               //               BREAK;
//                               //             END;
//                               //           END;
//                               //         END;
//                               //       UNTIL MeasurementLines2.NEXT = 0;
//                               //     END;
//                                   // Lineas de medicion
//                                   //{MeasurementLines2.RESET;
// //                                  MeasurementLines2.SETRANGE("Document type",MeasurementLines2."Document type"::Measuring);
// //                                  MeasurementLines2.SETRANGE("Job No.","Measurement Lines"."Job No.");
// //                                  MeasurementLines2.SETRANGE("Piecework No.","Measurement Lines"."Piecework No.");
// //                                  IF MeasurementLines2.FINDSET THEN
// //                                    REPEAT
// //                                      MeasureLinesBillofItem.RESET;
// //                                      MeasureLinesBillofItem.SETRANGE("Job No.",MeasurementLines2."Job No.");
// //                                      MeasureLinesBillofItem.SETRANGE("Piecework Code",MeasurementLines2."Piecework No.");
// //                                      IF MeasureLinesBillofItem.FINDSET THEN
// //                                        REPEAT
// //                                          DescMed := MeasureLinesBillofItem.Description;
// //                                          //MESSAGE(MeasureLinesBillofItem.Description);
// //                                        UNTIL MeasureLinesBillofItem.NEXT = 0;
// //                                    UNTIL MeasurementLines2.NEXT = 0;}

//                                   //MESSAGE("Measurement Lines"."Document No.");}
//                                 END;


// }trigger OnPreDataItem();
//     BEGIN 
//                                CurrReport.CREATETOTALS(Certificate,Quantity,CertificateToOrigin,QuantityToOrigin);
//                              END;

// trigger OnAfterGetRecord();
//     BEGIN 
//                                   Customer.RESET;
//                                   Customer.SETRANGE("No.","Customer No.");
//                                   IF Customer.FINDSET THEN BEGIN 
//                                     NombreCliente1 := Customer.Name;
//                                     NombreCliente2 := Customer."Name 2";
//                                   END;
//                                   Job.GET("Measurement Header"."Job No.");

//                                   MeasurementLines2.RESET;
//                                   MeasurementLines2.SETRANGE("Job No.","Measurement Header"."Job No.");
//                                   IF MeasurementLines2.FINDSET THEN BEGIN 
//                                     REPEAT
//                                       IF MeasurementLines2."Document No." < "Measurement Header"."No." THEN
//                                         certificacionanterior := MeasurementLines2."Document No.";
//                                     UNTIL MeasurementLines2.NEXT = 0;
//                                   END;
//                                 END;


// }
// }
// }
//   requestpage
//   {

//     layout
// {
// area(content)
// {
// group("group111")
// {

//                   CaptionML=ENU='Options',ESP='Opciones';
//     field("opcDetalleMedicion";"opcDetalleMedicion")
//     {

//                   CaptionML=ENU='with Medition detail',ESP='Con detalle de medici¢n';
//                   ToolTipML=ENU='Specifies whether to print medition detail.',ESP='Especifica si se debe imprimir el detalle de la medici¢n o no.';
//     }
//     field("opcResumen";"opcResumen")
//     {

//                   CaptionML=ENU='Show Summary',ESP='Mostrar resumen';
//     }

// }

// }
// }
//   }
//   labels
// {
// lblCliente='Customer:/ Cliente:/';
// lblNemPresup='Budget No:/ N£m. Presupuesto:/';
// lblFechaCert='Certification Date:/ Fecha Certificaci¢n:/';
// lblNCert='Certification No:/ N§ Certificaci¢n/';
// lblDescripcion='Description:/ Descripci¢n:/';
// lblResumenCertificacion='"CERTIFICATION DRAFT SUMMARY "/ BORRADOR DE RESUMEN DE CERTIFICACIàN/';
// lblEjecucionMaterial='MATERIAL EXECUTION/ EJECUCIàN MATERIAL/';
// lblCertifSinIVA='CERTIFICACIàN SIN IVA/';
// lblLiquidoCertif='"LÖQUIDO CERTIFICACIàN N§ "/';
// lblGtosGrales='GTOS GRALES/OTROS/';
// lblBIndustrial='B§ INDUSTRIAL/';
// lblCapitulo='CHAPTER/ CAPÖTULO/';
// lblResumen='SUMMARY/ RESUMEN/';
// lblImporte='AMOUNT/ IMPORTE/';
// lblCertificacion='CERTIFICATION DRAFT/ "BORRADOR DE CERTIFICACIàN "/';
// lblUnidades='UNITS/ UDS/';
// lblLongitud='LENGHT/ LONGITUD/';
// lblAncho='WIDTH/ ANCHO/';
// lblAltura='HEIGHT/ ALTURA/';
// lblCantidad='QUANTITY/ CANTIDAD/';
// lblPrecio='PRICE/ PRECIO/';
// lblSubtotal='Subtotal/ Subtotal/';
// lblCertificadoOrigen='Origin Certificate/ Certificado origen/';
// lblCertificacionesAnteriores='Previous Certification/ Certificacion anterior/';
// lblCertificacionActual='Current certification/ Certificaci¢n actual/';
// lblTotal='Total/';
// lblTotalBase='Total base/';
// }

//     var
// //       Job@7001104 :
//       Job: Record 167;
// //       Customer@1100286006 :
//       Customer: Record 18;
// //       NombreCliente1@1100286007 :
//       NombreCliente1: Text;
// //       NombreCliente2@1100286008 :
//       NombreCliente2: Text;
// //       MeasurementHeader@1100286004 :
//       MeasurementHeader: Record 7207336;
// //       MeasurementLines@7001109 :
//       MeasurementLines: Record 7207337;
// //       QBText@7001113 :
//       QBText: Record 7206918;
// //       Certificate@7001100 :
//       Certificate: Decimal;
// //       Quantity@7001101 :
//       Quantity: Decimal;
// //       CertificateToOrigin@7001102 :
//       CertificateToOrigin: Decimal;
// //       QuantityToOrigin@7001103 :
//       QuantityToOrigin: Decimal;
// //       CertificateToOriginTotalGen@7001105 :
//       CertificateToOriginTotalGen: Decimal;
// //       FirstPage@7001106 :
//       FirstPage: Boolean;
// //       SectionPrice@7001107 :
//       SectionPrice: Decimal;
// //       ThisCertificationQuantity@7001108 :
//       ThisCertificationQuantity: Decimal;
// //       MeasurementNoCode@7001110 :
//       MeasurementNoCode: Code[20];
// //       SectionCertificate@7001111 :
//       SectionCertificate: Decimal;
// //       OnlySummary@7001112 :
//       OnlySummary: Boolean;
// //       ExtendedLine@7001114 :
//       ExtendedLine: Text;
// //       boolPostMeasLinesBillofItem@7001115 :
//       boolPostMeasLinesBillofItem: Boolean;
// //       CurrReport_PAGENOCaptionLbl@7001116 :
//       CurrReport_PAGENOCaptionLbl: TextConst ENU='Page',ESP='P gina';
// //       CodeCaptionLbl@7001139 :
//       CodeCaptionLbl: TextConst ENU='Code',ESP='C¢digo';
// //       DescriptionCaptionLbl@7001138 :
//       DescriptionCaptionLbl: TextConst ENU='Description',ESP='Descripci¢n';
// //       QuantityCaptionLbl@7001137 :
//       QuantityCaptionLbl: TextConst ENU='Quantity',ESP='Cantidad';
// //       PriceCaptionLbl@7001136 :
//       PriceCaptionLbl: TextConst ENU='Price',ESP='Precio';
// //       AmountCaptionLbl@7001135 :
//       AmountCaptionLbl: TextConst ENU='Amount',ESP='Importe';
// //       AmountCaption_Control1100229060Lbl@7001134 :
//       AmountCaption_Control1100229060Lbl: TextConst ENU='Amount',ESP='Importe';
// //       PriceCaption_Control1100229062Lbl@7001133 :
//       PriceCaption_Control1100229062Lbl: TextConst ENU='Price',ESP='Precio';
// //       QuantityCaption_Control1100229063Lbl@7001132 :
//       QuantityCaption_Control1100229063Lbl: TextConst ENU='Quantity',ESP='Cantidad';
// //       DescriptionCaption_Control1100229064Lbl@7001131 :
//       DescriptionCaption_Control1100229064Lbl: TextConst ENU='Description',ESP='Descripci¢n';
// //       CodeCaption_Control1100229065Lbl@7001130 :
//       CodeCaption_Control1100229065Lbl: TextConst ENU='Code',ESP='C¢digo';
// //       PartialCaptionLbl@7001129 :
//       PartialCaptionLbl: TextConst ENU='Partial',ESP='Parciales';
// //       LengthCaptionLbl@7001128 :
//       LengthCaptionLbl: TextConst ENU='Length',ESP='Longitud';
// //       WidthCaptionLbl@7001127 :
//       WidthCaptionLbl: TextConst ENU='Width',ESP='Anchura';
// //       HeigthCaptionLbl@7001126 :
//       HeigthCaptionLbl: TextConst ENU='Height',ESP='Altura';
// //       Units_CaptionLbl@7001125 :
//       Units_CaptionLbl: TextConst ENU='Units',ESP='Uds.';
// //       Certification_to_OriginCaptionLbl@7001124 :
//       Certification_to_OriginCaptionLbl: TextConst ENU='Certification to Origin',ESP='Certificaci¢n a origen';
// //       Previous_CertificationsCaptionLbl@7001123 :
//       Previous_CertificationsCaptionLbl: TextConst ENU='Previous Certifications',ESP='Certificaciones anteriores';
// //       Current_CertificationCaptionLbl@7001122 :
//       Current_CertificationCaptionLbl: TextConst ENU='Current Certification',ESP='Certificaci¢n actual';
// //       Previous_CertificationsCaption_Control1100229025Lbl@7001121 :
//       Previous_CertificationsCaption_Control1100229025Lbl: TextConst ENU='Previous Certifications',ESP='Certificaciones anteriores';
// //       Current_CertificationCaption_Control1100229026Lbl@7001120 :
//       Current_CertificationCaption_Control1100229026Lbl: TextConst ENU='Current Certification',ESP='Certificaci¢n actual';
// //       Previous_CertificationsCaption_Control1100229036Lbl@7001119 :
//       Previous_CertificationsCaption_Control1100229036Lbl: TextConst ENU='Previous Certifications',ESP='Certificaciones anteriores';
// //       Current_CertificationCaption_Control1100229038Lbl@7001118 :
//       Current_CertificationCaption_Control1100229038Lbl: TextConst ENU='Current Certification',ESP='Certificaci¢n actual';
// //       TOTALCaptionLbl@7001117 :
//       TOTALCaptionLbl: TextConst ESP='TOTAL';
// //       OriginPrice@7001140 :
//       OriginPrice: Decimal;
// //       PreviousPrice@7001141 :
//       PreviousPrice: Decimal;
// //       TotalGeneralCertificateToOrigin@7001142 :
//       TotalGeneralCertificateToOrigin: Decimal;
// //       Job2@7001150 :
//       Job2: Record 167;
// //       PorcGtosGrales@7001149 :
//       PorcGtosGrales: Decimal;
// //       GtosGrales@7001148 :
//       GtosGrales: Boolean;
// //       PorcBIndustrial@7001147 :
//       PorcBIndustrial: Decimal;
// //       BIndustrial@7001146 :
//       BIndustrial: Boolean;
// //       VATPostingSetup2@7001145 :
//       VATPostingSetup2: Record 325;
// //       Customer2@7001144 :
//       Customer2: Record 18;
// //       PorcIVA@7001143 :
//       PorcIVA: Decimal;
// //       CompanyInformation@7001151 :
//       CompanyInformation: Record 79;
// //       DescripcionDescompuesto@7001152 :
//       DescripcionDescompuesto: Text;
// //       TextoExtendido@7001153 :
//       TextoExtendido: Text;
// //       DataCostByPiecework@7001154 :
//       DataCostByPiecework: Record 7207387;
// //       Resource@7001155 :
//       Resource: Record 156;
// //       Item@7001157 :
//       Item: Record 27;
// //       GLAccount@7001158 :
//       GLAccount: Record 15;
// //       certianterior@7001159 :
//       certianterior: Decimal;
// //       PostMeasLinesBillofItem@7001160 :
//       PostMeasLinesBillofItem: Record 7207396;
// //       Cliente_CaptionLbl@7001186 :
//       Cliente_CaptionLbl: TextConst ENU='Customer:',ESP='Cliente:';
// //       NumPresupuesto_CaptionLbl@7001185 :
//       NumPresupuesto_CaptionLbl: TextConst ENU='Budget No:',ESP='N£m. Presupuesto:';
// //       FechaCertificacion_CaptionLbl@7001184 :
//       FechaCertificacion_CaptionLbl: TextConst ENU='Certification Date:',ESP='Fecha Certificaci¢n:';
// //       NCertificacion_CaptionLbl@7001183 :
//       NCertificacion_CaptionLbl: TextConst ENU='Certification No:',ESP='N§ Certificaci¢n:';
// //       Descripcion_CaptionLbl@7001182 :
//       Descripcion_CaptionLbl: TextConst ENU='Description:',ESP='Descripci¢n:';
// //       Certificacion_CaptionLbl@7001181 :
//       Certificacion_CaptionLbl: TextConst ENU='CERTIFICATION DRAFT',ESP='BORRADOR CERTIFICACIàN';
// //       Capitulo_CaptionLbl@7001180 :
//       Capitulo_CaptionLbl: TextConst ENU='CHAPTER',ESP='CAPÖTULO';
// //       Resumen_CaptionLbl@7001179 :
//       Resumen_CaptionLbl: TextConst ENU='SUMMARY',ESP='RESUMEN';
// //       ImporteContratado_CaptionLbl@7001178 :
//       ImporteContratado_CaptionLbl: TextConst ENU='CONTRACTED AMOUNT',ESP='IMPORTE CONTRATADO';
// //       Importe_CaptionLbl@7001177 :
//       Importe_CaptionLbl: TextConst ENU='Amount',ESP='Importe';
// //       DirectorObra_CaptionLbl@7001176 :
//       DirectorObra_CaptionLbl: TextConst ENU='CONSTRUCTION MANAGER',ESP='DIRECTOR DE OBRA';
// //       Contratista_CaptionLbl@7001175 :
//       Contratista_CaptionLbl: TextConst ENU='CONTRACTOR',ESP='CONTRATISTA';
// //       Ejecuci¢nMaterial_CaptionLbl@7001174 :
//       EjecucionMaterial_CaptionLbl: TextConst ENU='MATERIAL EXECUTION',ESP='EJECUCIàN MATERIAL';
// //       CertificacionSinIva_CaptionLbl@7001173 :
//       CertificacionSinIva_CaptionLbl: TextConst ENU='CERTIFICATION WITHOUT VAT',ESP='CERTIFICACIàN SIN IVA';
// //       LiquidoCertificacion_CaptionLbl@7001172 :
//       LiquidoCertificacion_CaptionLbl: TextConst ENU='LIQUID CERTIFICATION N§',ESP='LÖQUIDO DE CERTIFICACION N§';
// //       ADeducir_CaptionLbl@7001171 :
//       ADeducir_CaptionLbl: TextConst ENU='To deduct certification n§',ESP='A deducir certificacion n§';
// //       Unidades_CaptionLbl@7001170 :
//       Unidades_CaptionLbl: TextConst ENU='UNITS',ESP='UDS';
// //       Longitud_CaptionLbl@7001169 :
//       Longitud_CaptionLbl: TextConst ENU='LENGHT',ESP='LONGITUD';
// //       Ancho_CaptionLbl@7001168 :
//       Ancho_CaptionLbl: TextConst ENU='WIDTH',ESP='ANCHO';
// //       Altura_CaptionLbl@7001167 :
//       Altura_CaptionLbl: TextConst ENU='Height',ESP='Altura';
// //       Cantidad_CaptionLbl@7001166 :
//       Cantidad_CaptionLbl: TextConst ENU='Quantity',ESP='Cantidad';
// //       Precio_CaptionLbl@7001165 :
//       Precio_CaptionLbl: TextConst ENU='Price',ESP='Precio';
// //       Subtotal_CaptionLbl@7001164 :
//       Subtotal_CaptionLbl: TextConst ENU='Subtotal',ESP='Subtotal';
// //       CertificadoOrigen_CaptionLbl@7001163 :
//       CertificadoOrigen_CaptionLbl: TextConst ENU='Origin Certificate',ESP='Certificado origen';
// //       CertificacionesAnteriores_CaptionLbl@7001162 :
//       CertificacionesAnteriores_CaptionLbl: TextConst ENU='Previous Certification',ESP='Certificacion anterior';
// //       CertificacionActual_CaptionLbl@7001161 :
//       CertificacionActual_CaptionLbl: TextConst ENU='Current Certification',ESP='Certificaci¢n actual';
// //       cantidadorigen2@7001187 :
//       cantidadorigen2: Decimal;
// //       PostCertifications@7001188 :
//       PostCertifications: Record 7207341;
// //       HistCertificationLines@7001189 :
//       HistCertificationLines: Record 7207342;
// //       CantCertAnterior@7001190 :
//       CantCertAnterior: Decimal;
// //       CantCertOrigen@7001191 :
//       CantCertOrigen: Decimal;
// //       MeasurementLines2@7001192 :
//       MeasurementLines2: Record 7207337;
// //       DescMed@7001193 :
//       DescMed: Text[50];
// //       MeasureLinesBillofItem@7001194 :
//       MeasureLinesBillofItem: Record 7207395;
// //       check@7001195 :
//       check: Boolean;
// //       DPFPCode@7001206 :
//       DPFPCode: Text[20];
// //       DPFPDescription@7001205 :
//       DPFPDescription: Text[100];
// //       unidad@7001204 :
//       unidad: Boolean;
// //       DescVacia@7001203 :
//       DescVacia: Integer;
// //       Capitulo@7001202 :
//       Capitulo: Code[20];
// //       TotalLinea@7001201 :
//       TotalLinea: Boolean;
// //       TotalCapi@7001200 :
//       TotalCapi: Decimal;
// //       TotalTotalCapi@7001199 :
//       TotalTotalCapi: Decimal;
// //       TotalTotalLinea@7001198 :
//       TotalTotalLinea: Boolean;
// //       CaptionSubcapitulo@7001197 :
//       CaptionSubcapitulo: Code[2];
// //       CaptionCapitulo@7001196 :
//       CaptionCapitulo: Code[4];
// //       Tipo@7001209 :
//       Tipo: Integer;
// //       Indentacion@7001208 :
//       Indentacion: Integer;
// //       contador@7001207 :
//       contador: Integer;
// //       MeasurementLines3@7001210 :
//       MeasurementLines3: Record 7207337;
// //       opcDetalleMedicion@1100286000 :
//       opcDetalleMedicion: Boolean;
// //       opcResumen@1100286001 :
//       opcResumen: Boolean;
// //       certificacionanterior@1100286002 :
//       certificacionanterior: Code[20];
// //       conta@1100286003 :
//       conta: Integer;
// //       TotalGeneral@1100286005 :
//       TotalGeneral: Decimal;
// //       DataPieceworkForProduction@1100286009 :
//       DataPieceworkForProduction: Record 7207386;
// //       ImporteCertLinea@1100286010 :
//       ImporteCertLinea: Decimal;
// //       ImporteCertifi@1100286011 :
//       ImporteCertifi: Decimal;
// //       VATPostingSetup@1100286012 :
//       VATPostingSetup: Record 325;
// //       TipoIVA@1100286013 :
//       TipoIVA: Decimal;
// //       FirstLine@1100286014 :
//       FirstLine: Boolean;
// //       PRESTO@1100286015 :
//       PRESTO: Code[40];
// //       ImporteCert2@1100286016 :
//       ImporteCert2: Decimal;



// trigger OnInitReport();    begin
//                    CompanyInformation.GET();
//                    CompanyInformation.CALCFIELDS(Picture);
//                  end;



// LOCAL procedure PrimeraLinea ()
//     begin
//       if (FirstLine) then begin
//         FirstLine := FALSE;
//       end else begin
//         CLEAR(CompanyInformation.Picture);
//       end;
//     end;

//     /*begin
//     end.
//   */

// }




