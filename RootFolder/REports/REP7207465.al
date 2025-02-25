report 7207465 "Certificaci¢n Registrada"
{
  
  
    CaptionML=ESP='Hist¢rico Certificaciones';
    
  dataset
{

DataItem("Hist. Measurements";"Post. Certifications")
{

               

               RequestFilterFields="No.";
Column(opcDetalleMedicion;opcDetalleMedicion)
{
//SourceExpr=opcDetalleMedicion;
}Column(opcResumen;opcResumen)
{
//SourceExpr=opcResumen;
}Column(Logo_CompanyInformation;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(Name_CompanyInformation;CompanyInformation.Name)
{
//SourceExpr=CompanyInformation.Name;
}Column(City_CompanyInformation;CompanyInformation.City)
{
//SourceExpr=CompanyInformation.City;
}Column(Address_CompanyInformation;CompanyInformation.Address)
{
//SourceExpr=CompanyInformation.Address;
}Column(PostCode__CompanyInformation;CompanyInformation."Post Code")
{
//SourceExpr=CompanyInformation."Post Code";
}Column(VATRegistrationNo_CompanyInformation;CompanyInformation."VAT Registration No.")
{
//SourceExpr=CompanyInformation."VAT Registration No.";
}Column(NombreCliente1;NombreCLiente1)
{
//SourceExpr=NombreCLiente1;
}Column(NombreCliente2;NombreCliente2)
{
//SourceExpr=NombreCliente2;
}Column(JobNo_MeasurementHeader;"Hist. Measurements"."Job No.")
{
//SourceExpr="Hist. Measurements"."Job No.";
}Column(PostingDate_MeasurementHeader;"Hist. Measurements"."Posting Date")
{
//SourceExpr="Hist. Measurements"."Posting Date";
}Column(CertificationNo_MeasurementHeader;"Hist. Measurements"."No. Measure")
{
//SourceExpr="Hist. Measurements"."No. Measure";
}Column(Description_MeasurementHeader;"Hist. Measurements".Description)
{
//SourceExpr="Hist. Measurements".Description;
}Column(Description2_MeasurementHeader;"Hist. Measurements"."Description 2")
{
//SourceExpr="Hist. Measurements"."Description 2";
}Column(No_PostCertifications;"Hist. Measurements"."No.")
{
//SourceExpr="Hist. Measurements"."No.";
}Column(NoMeasure_PostCertifications;"Hist. Measurements"."No. Measure")
{
//SourceExpr="Hist. Measurements"."No. Measure";
}Column(NoCertAnterior;certificacionanterior)
{
//SourceExpr=certificacionanterior;
}Column(CertificacionAnterior;certificacionanterior)
{
//SourceExpr=certificacionanterior;
}Column(TotalCantCertAnterior;TotalCantCertAnterior)
{
//SourceExpr=TotalCantCertAnterior;
}Column(TotalGeneral;TotalGeneral)
{
//SourceExpr=TotalGeneral;
}Column(PorcGtosGrales;PorcGtosGrales)
{
//SourceExpr=PorcGtosGrales;
}Column(GtosGrales;GtosGrales)
{
//SourceExpr=GtosGrales;
}Column(PorcBIndustrial;PorcBIndustrial)
{
//SourceExpr=PorcBIndustrial;
}Column(BIndustrial;BIndustrial)
{
//SourceExpr=BIndustrial;
}Column(PorcIVA;PorcIVA)
{
//SourceExpr=PorcIVA;
}Column(PorcBaja;PorcBaja)
{
//SourceExpr=PorcBaja;
}Column(BlnBaja;BlnBaja)
{
//SourceExpr=BlnBaja;
}Column(lblCBaja;lblCBaja)
{
//SourceExpr=lblCBaja;
}Column(PorcCI;PorcCI)
{
//SourceExpr=PorcCI;
}Column(BlnCI;BlnCI)
{
//SourceExpr=BlnCI;
}Column(lblCI;lblCI)
{
//SourceExpr=lblCI;
}DataItem("Hist. Measure Lines";"Hist. Certification Lines")
{

               DataItemTableView=SORTING("Job No.","Piecework No.");
DataItemLink="Document No."= FIELD("No.");
Column(PieceworkNo_HistCertificationsLines;"Hist. Measure Lines"."Piecework No.")
{
//SourceExpr="Hist. Measure Lines"."Piecework No.";
}Column(Description_HistCertificationsLines;"Hist. Measure Lines".Description)
{
//SourceExpr="Hist. Measure Lines".Description;
}Column(Description2_HistCertificationsLines;"Hist. Measure Lines"."Description 2")
{
//SourceExpr="Hist. Measure Lines"."Description 2";
}Column(Amount_HistCertificationsLines;"Hist. Measure Lines"."Cert Term PEC amount")
{
//SourceExpr="Hist. Measure Lines"."Cert Term PEC amount";
}Column(Quantity_HistCertificationsLines;"Hist. Measure Lines"."Cert Quantity to Term")
{
//SourceExpr="Hist. Measure Lines"."Cert Quantity to Term";
}Column(SalePrice_HistCertificationsLines;"Hist. Measure Lines"."Contract Price")
{
//SourceExpr="Hist. Measure Lines"."Contract Price";
}Column(ContractPrice_HistCertificationsLines;"Hist. Measure Lines"."Sale Price")
{
//SourceExpr="Hist. Measure Lines"."Sale Price";
}Column(CantCertAnterior;CantCertAnterior)
{
//SourceExpr=CantCertAnterior;
}Column(CantCertOrigen;CantCertOrigen)
{
//SourceExpr=CantCertOrigen;
}Column(TotalCapi;TotalCapi)
{
//SourceExpr=TotalCapi;
}Column(TotalLinea;TotalLinea)
{
//SourceExpr=TotalLinea;
}Column(TotalTotalLinea;TotalTotalLinea)
{
//SourceExpr=TotalTotalLinea;
}Column(TotalTotalCapi;TotalTotalCapi)
{
//SourceExpr=TotalTotalCapi;
}Column(Capitulos;Capitulo)
{
//SourceExpr=Capitulo;
}Column(CaptionCapitulo;CaptionCapitulo)
{
//SourceExpr=CaptionCapitulo;
}Column(ADeducir_Caption;ADeducir_CaptionLbl)
{
//SourceExpr=ADeducir_CaptionLbl;
}Column(TextoExtendido;TextoExtendido)
{
//SourceExpr=TextoExtendido;
}DataItem("Post. Meas. Lines Bill of Item";"Post. Meas. Lines Bill of Item")
{

               DataItemTableView=SORTING("Piecework No.","Bill of Item No Line","Job No.");
               

               DataItemLinkReference="Hist. Measure Lines";
Column(PieceworkCode_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Piecework No.")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Piecework No.";
}Column(BillOfItemNoLine;"Post. Meas. Lines Bill of Item"."Bill of Item No Line")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Bill of Item No Line";
}Column(JobNo_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Job No.")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Job No.";
}Column(Description_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item".Description)
{
//SourceExpr="Post. Meas. Lines Bill of Item".Description;
}Column(Units_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Period Units")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Period Units";
}Column(Length_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Budget Length")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Budget Length";
}Column(Width_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Budget Width")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Budget Width";
}Column(Height_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Budget Height")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Budget Height";
}Column(Total_MeasureLinePierceworkCertif;"Post. Meas. Lines Bill of Item"."Period Total")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Period Total";
}Column(PMLBI_BudgetTotal;"Post. Meas. Lines Bill of Item"."Budget Total")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Budget Total";
}Column(MeasureUnits_MeasureLinePieceworkCertif;"Post. Meas. Lines Bill of Item"."Measured Units")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Measured Units";
}Column(MeasureTot_MeasureLinePieceworkCertif;"Post. Meas. Lines Bill of Item"."Measured Total")
{
//SourceExpr="Post. Meas. Lines Bill of Item"."Measured Total";
}Column(contador;contador)
{
//SourceExpr=contador;
}Column(DescVacia;DescVacia)
{
//SourceExpr=DescVacia;
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code");
DataItemLink="Job No."= FIELD("Job No.");
Column(PieceworkCode_DataPieceworkForProduction;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(Type_DataPieceworkForProduction;"Data Piecework For Production".Type)
{
//SourceExpr="Data Piecework For Production".Type;
}Column(Description2_DataPieceworkForProduction;"Data Piecework For Production"."Description 2")
{
//SourceExpr="Data Piecework For Production"."Description 2";
}Column(Description_DataPieceworkForProduction;"Data Piecework For Production".Description)
{
//SourceExpr="Data Piecework For Production".Description;
}Column(AmountProductionBudget_DataPieceworkForProduction;"Data Piecework For Production"."Amount Production Budget")
{
//SourceExpr="Data Piecework For Production"."Amount Production Budget";
}Column(Identation_DataPieceworkForProduction;"Data Piecework For Production".Indentation)
{
//SourceExpr="Data Piecework For Production".Indentation;
}Column(ContractPrice_DataPieceworkForProduction;"Data Piecework For Production"."Contract Price")
{
//SourceExpr="Data Piecework For Production"."Contract Price";
}Column(InitialProductPrice_DataPieceworkForProduction;"Data Piecework For Production"."Initial Produc. Price")
{
//SourceExpr="Data Piecework For Production"."Initial Produc. Price";
}Column(CertifiedAmount_DataPieceworkForProduction;"Data Piecework For Production"."Certified Amount")
{
//SourceExpr="Data Piecework For Production"."Certified Amount";
}Column(AccountType_DataPieceworkForProduction;"Data Piecework For Production"."Account Type")
{
//SourceExpr="Data Piecework For Production"."Account Type";
}Column(Capitulo_Caption;Capitulo_CaptionLbl)
{
//SourceExpr=Capitulo_CaptionLbl;
}Column(Resumen_Caption;Resumen_CaptionLbl)
{
//SourceExpr=Resumen_CaptionLbl;
}Column(ImporteContratado_Caption;ImporteContratado_CaptionLbl)
{
//SourceExpr=ImporteContratado_CaptionLbl;
}Column(Importe_Caption;Importe_CaptionLbl)
{
//SourceExpr=Importe_CaptionLbl;
}Column(cantidadOrigen;cantidadorigen)
{
//SourceExpr=cantidadorigen;
}Column(cantidadOrigen2;cantidadorigen2)
{
//SourceExpr=cantidadorigen2;
}Column(Tipo;Tipo)
{
//SourceExpr=Tipo;
}Column(Indentacion;Indentacion)
{
//SourceExpr=Indentacion;
}Column(unidad;unidad)
{
//SourceExpr=unidad;
}Column(DPFPCode;DPFPCode)
{
//SourceExpr=DPFPCode;
}Column(DPFPDescription;DPFPDescription)
{
//SourceExpr=DPFPDescription;
}Column(TipoIVA;TipoIVA)
{
//SourceExpr=TipoIVA;
}Column(ImporteCert;ImporteCert)
{
//SourceExpr=ImporteCert;
}Column(ImporteCert2;ImporteCert2)
{
//SourceExpr=ImporteCert2;
}Column(ImporteCertLinea;ImporteCertLinea)
{
//SourceExpr=ImporteCertLinea;
}Column(ImporteCerTotal;ImporteCerTotal )
{
//SourceExpr=ImporteCerTotal ;
}trigger OnPreDataItem();
    BEGIN 
                               IF NOT(opcResumen) THEN
                                 CurrReport.BREAK;

                               "Data Piecework For Production".SETRANGE("Data Piecework For Production".Indentation,0);
                               "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Account Type","Data Piecework For Production"."Account Type"::Heading);
                               "Data Piecework For Production".SETFILTER("Data Piecework For Production".Type,'<>%1',"Data Piecework For Production".Type::"Cost Unit");
                               "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Customer Certification Unit",TRUE);
                             END;

trigger OnAfterGetRecord();
    BEGIN 

                                  IF TEMP_DataPieceworkForProd.GET("Job No.", "Piecework Code") THEN
                                    ImporteCertLinea := TEMP_DataPieceworkForProd."Initial Produc. Price"
                                  ELSE
                                    ImporteCertLinea := 0;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                               IF NOT(opcDetalleMedicion) THEN
                                 CurrReport.BREAK;

                               //"Post. Meas. Lines Bill of Item".SETRANGE("Post. Meas. Lines Bill of Item"."Document No.", "Hist. Measure Lines"."Document No.");
                               "Post. Meas. Lines Bill of Item".SETRANGE("Document Type", "Post. Meas. Lines Bill of Item"."Document Type"::Measuring);
                               "Post. Meas. Lines Bill of Item".SETRANGE("Document No.", "Hist. Measure Lines"."Cert Medition No.");
                               "Post. Meas. Lines Bill of Item".SETRANGE("Line No.","Hist. Measure Lines"."Cert Medition Line No.");
                               //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                               contador := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  //PrimeraLinea();  //Q18912 CSM 06/03/23 Í Informes medici¢n. SE COMENTA LÖNEA.
                                  DescVacia := 0;

                                  IF ("Post. Meas. Lines Bill of Item".Description = '') AND ("Post. Meas. Lines Bill of Item"."Budget Total" = 0) THEN BEGIN 
                                    DescVacia := 1;
                                    CurrReport.SKIP;
                                  END;

                                  IF ("Post. Meas. Lines Bill of Item".Description <> '') OR ("Post. Meas. Lines Bill of Item"."Budget Total" <> 0) THEN
                                    contador +=1;
                                END;


}trigger OnPreDataItem();
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
                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                                  IF FirstLineMeasure = 0 THEN
                                    FirstLineMeasure := "Hist. Measure Lines"."Line No.";

                                  IF TotalLinea THEN
                                    TotalCapi := 0;

                                  IF TotalTotalLinea THEN
                                    TotalTotalCapi := 0;

                                  CantCertAnterior := 0;
                                  TotalLinea := FALSE;
                                  TotalTotalLinea := FALSE;

                                  DataPieceworkForProduction.RESET;
                                  DataPieceworkForProduction.SETRANGE("Job No.","Hist. Measure Lines"."Job No.");
                                  DataPieceworkForProduction.SETRANGE("Piecework Code",COPYSTR("Hist. Measure Lines"."Piecework No.",1,4));
                                  IF DataPieceworkForProduction.FINDFIRST THEN
                                    Capitulo := DataPieceworkForProduction."Piecework Code";

                                  //IF COPYSTR("Hist. Measure Lines"."Piecework No.",1,4) <> Capitulo THEN
                                  //  TotalCapi := 0;

                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                                  ImporteCert2 := 0;

                                  //buscar datos en tabla Hist. Mediciones. 7207338 y 7207339.
                                  HistMeasurementHeader.RESET;
                                  HistMeasurementHeader.SETRANGE("Job No.","Hist. Measurements"."Job No.");
                                  IF HistMeasurementHeader.FINDSET THEN BEGIN 
                                    REPEAT
                                      IF HistMeasurementHeader."No. Measure" <> "Hist. Measurements"."No. Measure" THEN BEGIN 
                                        HistMeasurementLines.RESET;
                                        HistMeasurementLines.SETCURRENTKEY("Piecework No.");
                                        HistMeasurementLines.SETRANGE("Document No.",HistMeasurementHeader."No.");
                                        HistMeasurementLines.SETRANGE("Piecework No.","Hist. Measure Lines"."Piecework No.");
                                        IF HistMeasurementLines.FINDFIRST THEN BEGIN 
                                          CantCertAnterior += HistMeasurementLines."Med. Term Measure";
                                        END;
                                      END;
                                    UNTIL (HistMeasurementHeader.NEXT = 0) OR (HistMeasurementHeader."No. Measure" >= "Hist. Measurements"."No. Measure");
                                  END;
                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                                  TotalCantCertAnterior += CantCertAnterior * "Hist. Measure Lines"."Sale Price";
                                  ImporteCert2 += CantCertAnterior * "Hist. Measure Lines"."Sale Price";
                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                                  CantCertOrigen := CantCertAnterior + "Hist. Measure Lines"."Cert Quantity to Term";    //"Med. Term Measure";

                                  TotalCapi += CantCertOrigen * "Hist. Measure Lines"."Sale Price";
                                  TotalTotalCapi += CantCertOrigen * "Hist. Measure Lines"."Sale Price";
                                  TotalGeneral += CantCertOrigen * "Hist. Measure Lines"."Sale Price";

                                  ImporteCertLinea := CantCertOrigen * "Hist. Measure Lines"."Sale Price";

                                  DataPieceworkForProduction.RESET;
                                  DataPieceworkForProduction.SETRANGE("Job No.","Hist. Measure Lines"."Job No.");
                                  DataPieceworkForProduction.SETRANGE("Piecework Code",COPYSTR("Hist. Measure Lines"."Piecework No.",1,2));
                                  IF DataPieceworkForProduction.FINDFIRST THEN BEGIN 
                                    CaptionCapitulo := DataPieceworkForProduction."Piecework Code";

                                    //guardar IMPORTE en TEMPORAL para tipo Mayor.
                                    IF TEMP_DataPieceworkForProd.GET("Job No.", COPYSTR("Hist. Measure Lines"."Piecework No.",1,2)) THEN BEGIN 
                                      TEMP_DataPieceworkForProd."Initial Produc. Price" += ImporteCertLinea;
                                      TEMP_DataPieceworkForProd.MODIFY(FALSE);
                                    END ELSE BEGIN 
                                      TEMP_DataPieceworkForProd."Job No." := "Hist. Measure Lines"."Job No.";
                                      TEMP_DataPieceworkForProd."Piecework Code" := COPYSTR("Hist. Measure Lines"."Piecework No.",1,2);
                                      TEMP_DataPieceworkForProd."Initial Produc. Price" := ImporteCertLinea;
                                      TEMP_DataPieceworkForProd.INSERT(FALSE);
                                    END;
                                  END;
                                  ImporteCertLinea := 0;

                                  HistMeasures2.RESET;
                                  HistMeasures2.SETRANGE("Document No.","Hist. Measure Lines"."Document No.");
                                  IF HistMeasures2.FINDSET THEN BEGIN 
                                    REPEAT
                                      IF HistMeasures2."Piecework No." = "Hist. Measure Lines"."Piecework No." THEN BEGIN 
                                        HistMeasures2.NEXT;

                                        HistMeasures3.RESET;
                                        HistMeasures3.SETRANGE("Document No.","Hist. Measure Lines"."Document No.");
                                        IF HistMeasures3.FINDLAST THEN BEGIN 
                                          IF (COPYSTR(HistMeasures2."Piecework No.",1,2) <> COPYSTR("Hist. Measure Lines"."Piecework No.",1,2))
                                          OR ("Hist. Measure Lines"."Piecework No." = HistMeasures3."Piecework No.") THEN BEGIN 
                                            TotalTotalLinea := TRUE;
                                            TotalLinea := TRUE;
                                            BREAK;
                                          END ELSE IF (COPYSTR(HistMeasures2."Piecework No.",1,4) <> COPYSTR("Hist. Measure Lines"."Piecework No.",1,4))
                                          OR ("Hist. Measure Lines"."Piecework No." = HistMeasures3."Piecework No.") THEN BEGIN 
                                            TotalLinea := TRUE;
                                            BREAK;
                                          END;
                                        END;
                                      END;
                                    UNTIL HistMeasures2.NEXT = 0;
                                  END;

                                  IF QBText.GET(QBText.Table::Job, "Hist. Measure Lines"."Job No.", "Hist. Measure Lines"."Piecework No.") THEN
                                      TextoExtendido := QBText.GetCostText;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                               IF NOT(opcDetalleMedicion) AND NOT(opcResumen) THEN
                                 ERROR(TxtOpciones);
                               //Q18912 CSM 06/03/23 Í Informes medici¢n. +
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  Customer.RESET;
                                  Customer.SETRANGE("No.","Customer No.");
                                  IF Customer.FINDSET THEN BEGIN 
                                    NombreCLiente1 := Customer.Name;
                                    NombreCliente2 := Customer."Name 2";
                                  END;

                                  Job.GET("Job No.");

                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                                  certificacionanterior := '';

                                  HistMeasurementHeader.RESET;
                                  HistMeasurementHeader.SETRANGE("Job No.", "Hist. Measurements"."Job No.");
                                  IF HistMeasurementHeader.FINDLAST THEN REPEAT
                                    IF HistMeasurementHeader."No." <> "Hist. Measurements"."No." THEN
                                      certificacionanterior := HistMeasurementHeader."No. Measure";
                                  UNTIL (HistMeasurementHeader.NEXT(-1)=0) OR (certificacionanterior <> '');
                                  //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                                  VATPostingSetup.RESET;
                                  VATPostingSetup.SETRANGE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");
                                  VATPostingSetup.SETRANGE("VAT Bus. Posting Group",'NAC');
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
                                  VATPostingSetup2.SETRANGE("VAT Bus. Posting Group",Customer2."VAT Bus. Posting Group");
                                  VATPostingSetup2.SETRANGE("VAT Prod. Posting Group",Job."VAT Prod. PostingGroup");
                                  IF VATPostingSetup2.FINDFIRST THEN
                                    PorcIVA := VATPostingSetup2."VAT %";
                                END;


}
}
  requestpage
  {
SaveValues=true;
    layout
{
area(content)
{
group("group995")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("opcDetalleMedicion";"opcDetalleMedicion")
    {
        
                  CaptionML=ENU='with Medition detail',ESP='Con detalle de medici¢n';
                  ToolTipML=ENU='Specifies whether to print medition detail.',ESP='Especifica si se debe imprimir el detalle de la medici¢n o no.';
    }
    field("opcResumen";"opcResumen")
    {
        
                  CaptionML=ENU='Show Summary',ESP='Mostrar resumen';
    }

}

}
}
  }
  labels
{
lblCapitulo='CAPÖTULO/';
lblResumen='RESUME/ RESUMEN/';
lblImporte='AMOUNT/ IMPORTE/';
lblImporteContratado='CONTRACT AMOuNT/ IMPORTE CONTRATADO/';
lblCliente='Customer:/ Cliente:/';
lblNumPresupuesto='Job No:/ N£m. Proyecto:/';
lblFechaCertificacion='Measurement Date:/ Fecha Certificaci¢n:/';
lblNCertificacion='Measurement No:/ N§ Certificaci¢n:/';
lblDescripcion='Description:/ Descripci¢n:/';
lblCertificacion='MEASUREMENT/ CERTIFICACION/';
lblDirectorObra='CONSTRUCTION MANAGER/ DIRECTOR DE OBRA/';
lblContratista='CONTRACTOR/ CONTRATISTA/';
lblEjecucionMaterial='MATERIAL EXECUTION/ EJECUCIàN MATERIAL/';
lblCertificacionSinIva='CERTIFICATION WITHOUT VAT/ CERTIFICACIàN SIN IVA/';
lblLiquidoCertificacion='LIQUID CERTIFICATION N§/ LÖQUIDO DE CERTIFICACION N§/';
lblADeducir='To deduct measurement n§/ A deducir medici¢n n§/';
lblUnidades='UNITS/ UDS/';
lblLongitud='LENGHT/ LONGITUD/';
lblAncho='WIDTH/ ANCHO/';
lblAltura='HEIGHT/ ALTURA/';
lblCantidad='QUANTITY/ CANTIDAD/';
lblPrecio='PRICE/ PRECIO/';
lblSubtotal='Subtotal/ Subtotal/';
lblTotal='Total/';
lblCertificadoOrigen='Origin Measure/ Certificaci¢n a origen/';
lblCertificacionesAnteriores='Previous Measurement/ Certificaci¢n anterior/';
lblCertificacionActual='Current Measurement/ Certificaci¢n actual/';
lblResumenCertificacion='MEASUREMENT SUMMARY/ RESUMEN DE CERTIFICACION/';
lblCertifSinIVA='CERTIFICACIàN SIN IVA/';
lblGtosGrales='Gastos Generales/';
lblBIndustrial='Beneficio Industrial/';
lblTotalBase='Total base/';
lblLiquidoCertif='LÖQUIDO CERTIFICACIàN N§/';
}
  
    var
//       CompanyInformation@7001100 :
      CompanyInformation: Record 79;
//       Customer@7001106 :
      Customer: Record 18;
//       Job@7001118 :
      Job: Record 167;
//       DataPieceworkForProduction@7001116 :
      DataPieceworkForProduction: Record 7207386;
//       MeasurementHeaderz@7001114 :
      MeasurementHeaderz: Record 7207336;
//       HistCertifications@7001113 :
      HistCertifications: Record 7207342;
//       HistCertifications2@7001112 :
      HistCertifications2: Record 7207342;
//       HistMeasures@1000000023 :
      HistMeasures: Record 7207339;
//       HistMeasures2@1000000021 :
      HistMeasures2: Record 7207339;
//       QBText@7001103 :
      QBText: Record 7206918;
//       HistCertifications3@7001123 :
      HistCertifications3: Record 7207342;
//       HistMeasures3@1000000024 :
      HistMeasures3: Record 7207339;
//       PostCertifications@7001121 :
      PostCertifications: Record 7207341;
//       HistCertificationLines@7001120 :
      HistCertificationLines: Record 7207342;
//       HistMeasureLines@1000000025 :
      HistMeasureLines: Record 7207339;
//       NombreCLiente1@7001107 :
      NombreCLiente1: Text;
//       NombreCliente2@7001108 :
      NombreCliente2: Text;
//       certificacionanterior@7001128 :
      certificacionanterior: Code[20];
//       ncertificacion@7001129 :
      ncertificacion: Integer;
//       DescripcionDescompuesto@7001133 :
      DescripcionDescompuesto: Text;
//       TextoExtendido@7001140 :
      TextoExtendido: Text;
//       cantidadorigen@7001149 :
      cantidadorigen: Decimal;
//       certianterior@7001151 :
      certianterior: Decimal;
//       cantidadorigen2@7001156 :
      cantidadorigen2: Decimal;
//       cantidadanterior@7001157 :
      cantidadanterior: Decimal;
//       CantCertAnterior@7001160 :
      CantCertAnterior: Decimal;
//       CantCertOrigen@7001159 :
      CantCertOrigen: Decimal;
//       desc1@7001163 :
      desc1: Text[50];
//       desc2@7001164 :
      desc2: Text[50];
//       Tipo@7001165 :
      Tipo: Integer;
//       Indentacion@7001166 :
      Indentacion: Integer;
//       contador@7001167 :
      contador: Integer;
//       DPFPCode@7001168 :
      DPFPCode: Text[20];
//       DPFPDescription@7001169 :
      DPFPDescription: Text[100];
//       unidad@7001170 :
      unidad: Boolean;
//       DescVacia@7001171 :
      DescVacia: Integer;
//       Capitulo@7001173 :
      Capitulo: Code[20];
//       TotalLinea@7001174 :
      TotalLinea: Boolean;
//       TotalCapi@7001175 :
      TotalCapi: Decimal;
//       TotalTotalCapi@7001172 :
      TotalTotalCapi: Decimal;
//       TotalGeneral@7001181 :
      TotalGeneral: Decimal;
//       TotalTotalLinea@7001176 :
      TotalTotalLinea: Boolean;
//       CaptionSubcapitulo@7001177 :
      CaptionSubcapitulo: Text;
//       CaptionCapitulo@7001178 :
      CaptionCapitulo: Text;
//       PRESTO@7001179 :
      PRESTO: Code[40];
//       Cont@7001180 :
      Cont: Integer;
//       FirstLine@7001184 :
      FirstLine: Boolean;
//       "-------------------------- Opciones"@7001182 :
      "-------------------------- Opciones": Integer;
//       opcDetalleMedicion@7001183 :
      opcDetalleMedicion: Boolean;
//       opcResumen@1000000000 :
      opcResumen: Boolean;
//       TipoIVA@1000000011 :
      TipoIVA: Decimal;
//       ImporteCert@1000000010 :
      ImporteCert: Decimal;
//       ImporteCert2@1000000009 :
      ImporteCert2: Decimal;
//       PorcGtosGrales@1000000007 :
      PorcGtosGrales: Decimal;
//       GtosGrales@1000000006 :
      GtosGrales: Boolean;
//       PorcBIndustrial@1000000005 :
      PorcBIndustrial: Decimal;
//       BIndustrial@1000000004 :
      BIndustrial: Boolean;
//       PorcIVA@1000000003 :
      PorcIVA: Decimal;
//       ImporteCertLinea@1000000002 :
      ImporteCertLinea: Decimal;
//       Capitulo_CaptionLbl@1000000014 :
      Capitulo_CaptionLbl: TextConst ENU='CHAPTER',ESP='CAPÖTULO';
//       Resumen_CaptionLbl@1000000013 :
      Resumen_CaptionLbl: TextConst ENU='SUMMARY',ESP='RESUMEN';
//       ImporteContratado_CaptionLbl@1000000012 :
      ImporteContratado_CaptionLbl: TextConst ENU='CONTRACTED AMOUNT',ESP='IMPORTE CONTRATADO';
//       Importe_CaptionLbl@1000000008 :
      Importe_CaptionLbl: TextConst ENU='AMOUNT',ESP='IMPORTE';
//       ADeducir_CaptionLbl@1000000001 :
      ADeducir_CaptionLbl: TextConst ENU='To deduct measurement n§',ESP='A deducir certificaci¢n n§';
//       conta@1000000015 :
      conta: Integer;
//       ImporteCertifi@1000000016 :
      ImporteCertifi: Decimal;
//       VATPostingSetup@1000000017 :
      VATPostingSetup: Record 325;
//       Job2@1000000018 :
      Job2: Record 167;
//       Customer2@1000000019 :
      Customer2: Record 18;
//       VATPostingSetup2@1000000020 :
      VATPostingSetup2: Record 325;
//       HistMeasurements@1000000022 :
      HistMeasurements: Record 7207338;
//       HistMeasurementHeader@1100286003 :
      HistMeasurementHeader: Record 7207338;
//       HistMeasurementLines@1100286002 :
      HistMeasurementLines: Record 7207339;
//       TotalCantCertAnterior@1100286001 :
      TotalCantCertAnterior: Decimal;
//       DataCostByPiecework@1100286007 :
      DataCostByPiecework: Record 7207387;
//       Resource@1100286006 :
      Resource: Record 156;
//       Item@1100286005 :
      Item: Record 27;
//       GLAccount@1100286004 :
      GLAccount: Record 15;
//       FirstLineMeasure@1100286008 :
      FirstLineMeasure: Integer;
//       ImporteCerTotal@1100286009 :
      ImporteCerTotal: Decimal;
//       MeasurementNoCode@1100286000 :
      MeasurementNoCode: Code[20];
//       TEMP_DataPieceworkForProd@1100286010 :
      TEMP_DataPieceworkForProd: Record 7207386 TEMPORARY;
//       TxtOpciones@1100286011 :
      TxtOpciones: TextConst ENU='Debe seleccionar al menos una opci¢n de impresi¢n.',ESP='Debe seleccionar al menos una opci¢n de impresi¢n.';
//       BlnBaja@1100286012 :
      BlnBaja: Boolean;
//       PorcBaja@1100286013 :
      PorcBaja: Decimal;
//       lblCBaja@1100286014 :
      lblCBaja: TextConst ESP='Coef. Baja';
//       PorcCI@1100286015 :
      PorcCI: Decimal;
//       BlnCI@1100286016 :
      BlnCI: Boolean;
//       lblCI@1100286017 :
      lblCI: TextConst ESP='Coef. Indirectos';

    

trigger OnInitReport();    begin
                   //Q18912 CSM 06/03/23 Í Informes medici¢n. -
                   opcDetalleMedicion := TRUE;
                   opcResumen := TRUE;
                   //Q18912 CSM 06/03/23 Í Informes medici¢n. +

                   CompanyInformation.GET();
                   CompanyInformation.CALCFIELDS(Picture);
                 end;



LOCAL procedure PrimeraLinea ()
    begin
      if (FirstLine) then begin
        FirstLine := FALSE;
      end else begin
        //CLEAR(CompanyInformation.Picture);  //Q18912 CSM 06/03/23 Í Informes medici¢n. SE COMENTA LÖNEA.
      end;
    end;

    /*begin
    //{
//      Q18912 CSM 06/03/23 Í Informes medici¢n.  Se sustituye tabla del £ltimo DataItem.
//      Q19929 AML 21/08/23 A¤adir % BAja
//    }
    end.
  */
  
}



