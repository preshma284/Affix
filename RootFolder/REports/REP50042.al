report 50042 "Vesta: Certificacion Reg.Com."
{
  
  
    CaptionML=ESP='Vesta: Certificaci¢n Completa';
    
  dataset
{

DataItem("Post. Certifications";"Post. Certifications")
{

               

               RequestFilterFields="Job No.";
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
}Column(JobNo_MeasurementHeader;"Post. Certifications"."Job No.")
{
//SourceExpr="Post. Certifications"."Job No.";
}Column(PostingDate_MeasurementHeader;"Post. Certifications"."Posting Date")
{
//SourceExpr="Post. Certifications"."Posting Date";
}Column(CertificationNo_MeasurementHeader;"Post. Certifications"."No. Measure")
{
//SourceExpr="Post. Certifications"."No. Measure";
}Column(Description_MeasurementHeader;"Post. Certifications".Description)
{
//SourceExpr="Post. Certifications".Description;
}Column(Description2_MeasurementHeader;"Post. Certifications"."Description 2")
{
//SourceExpr="Post. Certifications"."Description 2";
}Column(No_PostCertifications;"Post. Certifications"."No.")
{
//SourceExpr="Post. Certifications"."No.";
}Column(NoMeasure_PostCertifications;"Post. Certifications"."No. Measure")
{
//SourceExpr="Post. Certifications"."No. Measure";
}DataItem("Hist. Certification Lines";"Hist. Certification Lines")
{

               DataItemTableView=SORTING("Job No.","Piecework No.","Certification Date","Invoiced Certif.");
DataItemLink="Document No."= FIELD("No.");
Column(PieceworkNo_HistCertificationsLines;"Hist. Certification Lines"."Piecework No.")
{
//SourceExpr="Hist. Certification Lines"."Piecework No.";
}Column(Description_HistCertificationsLines;"Hist. Certification Lines".Description)
{
//SourceExpr="Hist. Certification Lines".Description;
}Column(Description2_HistCertificationsLines;"Hist. Certification Lines"."Description 2")
{
//SourceExpr="Hist. Certification Lines"."Description 2";
}Column(Amount_HistCertificationsLines;"Hist. Certification Lines"."Term Contract Amount")
{
//SourceExpr="Hist. Certification Lines"."Term Contract Amount";
}Column(Quantity_HistCertificationsLines;"Hist. Certification Lines"."Cert Quantity to Term")
{
//SourceExpr="Hist. Certification Lines"."Cert Quantity to Term";
}Column(SalePrice_HistCertificationsLines;"Hist. Certification Lines"."Contract Price")
{
//SourceExpr="Hist. Certification Lines"."Contract Price";
}Column(ContractPrice_HistCertificationsLines;"Hist. Certification Lines"."Sale Price")
{
//SourceExpr="Hist. Certification Lines"."Sale Price";
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
}Column(TotalGeneral;TotalGeneral)
{
//SourceExpr=TotalGeneral;
}Column(Capitulos;Capitulo)
{
//SourceExpr=Capitulo;
}Column(CaptionCapitulo;CaptionCapitulo)
{
//SourceExpr=CaptionCapitulo;
}Column(ADeducir_Caption;ADeducir_CaptionLbl)
{
//SourceExpr=ADeducir_CaptionLbl;
}DataItem("Hist. Measure Lines";"Hist. Measure Lines")
{

DataItemLink="Document No."= FIELD("Document No."),
                            "Job No."= FIELD("Job No."),
                            "Piecework No."= FIELD("Piecework No.");
DataItem("Data Piecework For Production";"Data Piecework For Production")
{

DataItemLink="Job No."= FIELD("Job No.");
Column(PieceworkCode_DataPieceworkForProduction;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(Type_DataPieceworkForProduction;"Data Piecework For Production".Type)
{
//SourceExpr="Data Piecework For Production".Type;
}Column(PieceworkCodePresto_DataPieceworkForProduction;"Data Piecework For Production"."Code Piecework PRESTO")
{
//SourceExpr="Data Piecework For Production"."Code Piecework PRESTO";
}Column(ContractOrderAmount_DataPieceworkForProduction;"Data Piecework For Production"."Contract/Order Amount")
{
//SourceExpr="Data Piecework For Production"."Contract/Order Amount";
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
}Column(CertificacionAnterior;certificacionanterior)
{
//SourceExpr=certificacionanterior;
}Column(cantidadOrigen;cantidadorigen)
{
//SourceExpr=cantidadorigen;
}Column(cantidadOrigen2;cantidadorigen2)
{
//SourceExpr=cantidadorigen2;
}Column(TextoExtendido;TextoExtendido)
{
//SourceExpr=TextoExtendido;
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
}Column(PRESTO;PRESTO)
{
//SourceExpr=PRESTO;
}Column(TipoIVA;TipoIVA)
{
//SourceExpr=TipoIVA;
}Column(ImporteCert;ImporteCert)
{
//SourceExpr=ImporteCert;
}Column(ImporteCert2;ImporteCert2)
{
//SourceExpr=ImporteCert2;
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
}Column(ImporteCertLinea;ImporteCertLinea)
{
//SourceExpr=ImporteCertLinea;
}DataItem("Measurement Lin. Piecew. Prod.";"Measurement Lin. Piecew. Prod.")
{

DataItemLink="Job No."= FIELD("Job No."),
                            "Piecework Code"= FIELD("Piecework Code");
Column(PieceworkCode_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod."."Piecework Code")
{
//SourceExpr="Measurement Lin. Piecew. Prod."."Piecework Code";
}Column(JobNo_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod."."Job No.")
{
//SourceExpr="Measurement Lin. Piecew. Prod."."Job No.";
}Column(Description_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Description)
{
//SourceExpr="Measurement Lin. Piecew. Prod.".Description;
}Column(Units_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Units)
{
//SourceExpr="Measurement Lin. Piecew. Prod.".Units;
}Column(Length_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Length)
{
//SourceExpr="Measurement Lin. Piecew. Prod.".Length;
}Column(Width_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Width)
{
//SourceExpr="Measurement Lin. Piecew. Prod.".Width;
}Column(Height_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Height)
{
//SourceExpr="Measurement Lin. Piecew. Prod.".Height;
}Column(Total_MeasureLinePierceworkCertif;"Measurement Lin. Piecew. Prod.".Total)
{
//SourceExpr="Measurement Lin. Piecew. Prod.".Total;
}Column(contador;contador)
{
//SourceExpr=contador;
}Column(DescVacia;DescVacia )
{
//SourceExpr=DescVacia ;
}trigger OnPreDataItem();
    BEGIN 
                               contador := 0;
                               "Measurement Lin. Piecew. Prod.".SETRANGE("Measurement Lin. Piecew. Prod."."Code Budget",Job."Current Piecework Budget");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  PrimeraLinea();

                                  DescVacia := 0;

                                  IF ("Measurement Lin. Piecew. Prod.".Description = '') AND ("Measurement Lin. Piecew. Prod.".Total = 0) THEN BEGIN 
                                   DescVacia := 1;
                                    CurrReport.BREAK;
                                  END;

                                  IF ("Measurement Lin. Piecew. Prod.".Description <> '') OR ("Measurement Lin. Piecew. Prod.".Total <> 0) THEN
                                    contador +=1;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                contador := 0;
                              END;


}trigger OnPreDataItem();
    BEGIN 
                               IF opcResumen = TRUE THEN BEGIN 
                                 "Data Piecework For Production".SETRANGE("Data Piecework For Production".Indentation,0);
                                 "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Account Type","Data Piecework For Production"."Account Type"::Heading);
                                 "Data Piecework For Production".SETFILTER("Data Piecework For Production".Type,'<>%1',"Data Piecework For Production".Type::"Cost Unit");
                                 "Data Piecework For Production".SETRANGE("Data Piecework For Production"."Customer Certification Unit",TRUE);
                               END;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF opcResumen = TRUE THEN BEGIN 
                                    ImporteCertLinea := 0;
                                    IF "Data Piecework For Production".Indentation = 0 THEN
                                      ImporteCertifi += "Data Piecework For Production"."Certified Amount";

                                    VATPostingSetup.RESET;
                                    VATPostingSetup.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");
                                    VATPostingSetup.SETRANGE("VAT Bus. Posting Group",'NAC');
                                    IF VATPostingSetup.FINDSET THEN
                                      TipoIVA := VATPostingSetup."VAT %";

                                    //Gtos Generales y B§ Industrial
                                    Job2.RESET;
                                    Job2.SETRANGE("No.","Data Piecework For Production"."Job No.");
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

                                      //IVA
                                      Customer2.GET(Job2."Bill-to Customer No.");
                                      VATPostingSetup2.RESET;
                                      VATPostingSetup2.SETRANGE("VAT Bus. Posting Group",Customer2."VAT Bus. Posting Group");
                                      VATPostingSetup2.SETRANGE("VAT Prod. Posting Group",Job2."VAT Prod. PostingGroup");
                                      IF VATPostingSetup2.FINDFIRST THEN
                                        PorcIVA := VATPostingSetup2."VAT %";
                                    END;


                                    HistCertifications3.RESET;
                                    HistCertifications3.SETRANGE("Job No.","Post. Certifications"."Job No.");
                                    //HistCertifications3.SETRANGE("Document No.","Post. Certifications"."No.");
                                    IF HistCertifications3.FINDSET THEN BEGIN 
                                      REPEAT
                                        //++++++IF COPYSTR(HistCertifications3."Piecework No.",1,2) = "Data Piecework For Production"."Piecework Code" THEN
                                        IF COPYSTR(HistCertifications3."Piecework No.",1,STRLEN("Data Piecework For Production"."Piecework Code")) = "Data Piecework For Production"."Piecework Code" THEN
                                          //ImporteCertLinea += HistCertifications3.Amount;
                                          ImporteCertLinea += HistCertifications3."Cert Quantity to Term" * HistCertifications3."Sale Price";
                                      UNTIL (HistCertifications3.NEXT = 0) OR (HistCertifications3."Document No." > "Post. Certifications"."No.");
                                    END;

                                    CantCertAnterior := 0;

                                    PostCertifications.RESET;
                                    PostCertifications.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
                                    PostCertifications.ASCENDING(FALSE);
                                    IF PostCertifications.FINDSET THEN BEGIN 
                                      REPEAT
                                        HistCertificationLines.RESET;
                                        HistCertificationLines.SETRANGE("Document No.",PostCertifications."No.");
                                        HistCertificationLines.SETRANGE("Piecework No.","Data Piecework For Production"."Piecework Code");
                                        IF HistCertificationLines.FINDFIRST THEN BEGIN 
                                          IF HistCertificationLines."Document No." = "Post. Certifications"."No." THEN
                                            BREAK;
                                          CantCertAnterior += HistCertificationLines."Cert Quantity to Term";
                                        END;
                                      UNTIL PostCertifications.NEXT = 0;
                                    END;
                                  END ELSE BEGIN 
                                    PrimeraLinea;
                                    DPFPCode := '';
                                    DPFPDescription := '';
                                    PRESTO := '';
                                    TextoExtendido := '';
                                    unidad := FALSE;

                                    IF STRLEN("Data Piecework For Production"."Piecework Code") = 2 THEN BEGIN 
                                      HistCertificationLines.RESET;
                                      HistCertificationLines.SETRANGE("Document No.","Hist. Certification Lines"."Document No.");
                                      IF HistCertificationLines.FINDSET THEN
                                        REPEAT
                                          IF COPYSTR(HistCertificationLines."Piecework No.",1,2) = "Data Piecework For Production"."Piecework Code" THEN BEGIN 
                                            DPFPCode := "Data Piecework For Production"."Piecework Code";
                                            DPFPDescription := "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
                                            PRESTO := "Data Piecework For Production"."Piecework Code";
                                            BREAK;
                                          END;
                                        UNTIL HistCertificationLines.NEXT = 0;
                                        Tipo := "Data Piecework For Production"."Account Type";
                                    END ELSE IF (STRLEN("Data Piecework For Production"."Piecework Code") = 4) AND ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Heading) THEN BEGIN 
                                      HistCertificationLines.RESET;
                                      HistCertificationLines.SETRANGE("Document No.","Hist. Certification Lines"."Document No.");
                                      IF HistCertificationLines.FINDSET THEN
                                        REPEAT
                                          IF COPYSTR(HistCertificationLines."Piecework No.",1,4) = "Data Piecework For Production"."Piecework Code" THEN BEGIN 
                                            DPFPCode := "Data Piecework For Production"."Piecework Code";
                                            DPFPDescription := "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
                                            PRESTO := "Data Piecework For Production"."Piecework Code";
                                            BREAK;
                                          END
                                        UNTIL HistCertificationLines.NEXT = 0;
                                        Tipo := "Data Piecework For Production"."Account Type";
                                    END ELSE BEGIN 
                                      HistCertificationLines.RESET;
                                      HistCertificationLines.SETRANGE("Document No.","Hist. Certification Lines"."Document No.");
                                      HistCertificationLines.SETRANGE("Line No.","Hist. Certification Lines"."Line No.");
                                      IF HistCertificationLines.FINDFIRST THEN BEGIN 
                                        IF HistCertificationLines."Piecework No." = "Data Piecework For Production"."Piecework Code" THEN BEGIN 
                                          DPFPCode := HistCertificationLines."Piecework No.";
                                          DPFPDescription := "Data Piecework For Production".Description + "Data Piecework For Production"."Description 2";
                                          PRESTO := "Data Piecework For Production"."Piecework Code";

                                          IF QBText.GET(QBText.Table::Job, "Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code") THEN
                                            TextoExtendido := QBText.GetSalesText;

                                          Tipo := "Data Piecework For Production"."Account Type";
                                          Indentacion := "Data Piecework For Production".Indentation;
                                          unidad := TRUE;
                                        END ELSE
                                          CurrReport.SKIP;
                                      END;
                                    END;

                                  END;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               conta := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Hist. Certification Lines"."Piecework No." <> '' THEN
                                    IF opcResumen = TRUE THEN
                                      IF conta = 1 THEN
                                        CurrReport.SKIP
                                      ELSE
                                        conta += 1;

                                  IF TotalTotalLinea THEN
                                    TotalTotalCapi := 0;

                                  CantCertAnterior := 0;
                                  TotalLinea := FALSE;
                                  TotalTotalLinea := FALSE;

                                  IF COPYSTR("Hist. Certification Lines"."Piecework No.",1,4) <> Capitulo THEN
                                    TotalCapi := 0;

                                  PostCertifications.RESET;
                                  PostCertifications.SETRANGE("Job No.","Hist. Certification Lines"."Job No.");
                                  //PostCertifications.ASCENDING(FALSE);
                                  IF PostCertifications.FINDSET THEN BEGIN 
                                    REPEAT
                                      //IF PostCertifications."No." < "Post. Certifications"."No." THEN BEGIN // PGM
                                      IF PostCertifications."No." < "Post. Certifications"."No." THEN BEGIN 
                                        HistCertificationLines.RESET;
                                        HistCertificationLines.SETRANGE("Document No.",PostCertifications."No.");
                                        HistCertificationLines.SETRANGE("Piecework No.","Hist. Certification Lines"."Piecework No.");
                                        HistCertificationLines.SETCURRENTKEY("Piecework No.");
                                        IF HistCertificationLines.FINDFIRST THEN BEGIN 
                                          CantCertAnterior += HistCertificationLines."Cert Quantity to Term";
                                        END;
                                      END;
                                    UNTIL (PostCertifications.NEXT = 0) OR (PostCertifications."No." = "Post. Certifications"."No.");
                                  END;

                                  //pgm >>
                                  //CantCertOrigen := CantCertAnterior + "Hist. Certification Lines".Quantity;
                                  CantCertOrigen := "Hist. Certification Lines"."Cert Quantity to Term";
                                  //pgm <<

                                  TotalCapi += CantCertOrigen * "Hist. Certification Lines"."Sale Price";
                                  TotalTotalCapi += CantCertOrigen * "Hist. Certification Lines"."Sale Price";
                                  TotalGeneral += CantCertOrigen * "Hist. Certification Lines"."Sale Price";

                                  DataPieceworkForProduction.RESET;
                                  DataPieceworkForProduction.SETRANGE("Job No.","Hist. Certification Lines"."Job No.");
                                  DataPieceworkForProduction.SETRANGE("Piecework Code",COPYSTR("Hist. Certification Lines"."Piecework No.",1,4));
                                  IF DataPieceworkForProduction.FINDFIRST THEN
                                    //Capitulo := DataPieceworkForProduction."Code Piecework PRESTO";
                                    Capitulo := DataPieceworkForProduction."Piecework Code";

                                  DataPieceworkForProduction.RESET;
                                  DataPieceworkForProduction.SETRANGE("Job No.","Hist. Certification Lines"."Job No.");
                                  DataPieceworkForProduction.SETRANGE("Piecework Code",COPYSTR("Hist. Certification Lines"."Piecework No.",1,2));
                                  IF DataPieceworkForProduction.FINDFIRST THEN
                                    CaptionCapitulo :=  DataPieceworkForProduction."Code Piecework PRESTO";


                                  HistCertifications2.RESET;
                                  HistCertifications2.SETRANGE("Document No.","Hist. Certification Lines"."Document No.");
                                  HistCertifications2.SETCURRENTKEY("Piecework No.");
                                  //HistCertifications2.SETRANGE("Piecework No.","Hist. Certification Lines"."Piecework No.");
                                  IF HistCertifications2.FINDSET THEN BEGIN 
                                    //TotalCapi := 0;
                                    REPEAT
                                      IF HistCertifications2."Piecework No." = "Hist. Certification Lines"."Piecework No." THEN BEGIN 
                                        HistCertifications2.NEXT;

                                        HistCertifications3.RESET;
                                        HistCertifications3.SETRANGE("Document No.","Hist. Certification Lines"."Document No.");
                                        HistCertifications3.SETCURRENTKEY("Piecework No.");
                                       // HistCertifications2.SETRANGE("Piecework No.","Hist. Certification Lines"."Piecework No.");
                                        IF HistCertifications3.FINDLAST THEN BEGIN 
                                          IF (COPYSTR(HistCertifications2."Piecework No.",1,2) <> COPYSTR("Hist. Certification Lines"."Piecework No.",1,2)) OR ("Hist. Certification Lines"."Piecework No." = HistCertifications3."Piecework No.") THEN BEGIN 
                                            TotalTotalLinea := TRUE;
                                            TotalLinea := TRUE;
                                            BREAK;
                                          END ELSE IF (COPYSTR(HistCertifications2."Piecework No.",1,4) <> COPYSTR("Hist. Certification Lines"."Piecework No.",1,4)) OR ("Hist. Certification Lines"."Piecework No." = HistCertifications3."Piecework No.") THEN BEGIN 
                                            TotalLinea := TRUE;
                                            //TotalCapi := 0;
                                            BREAK;
                                          END;
                                        END;
                                      END;
                                    UNTIL HistCertifications2.NEXT = 0;
                                  END;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               CompanyInformation.GET();
                               CompanyInformation.CALCFIELDS(Picture);
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


                                  HistCertifications2.RESET;
                                  HistCertifications2.SETRANGE("Job No.","Post. Certifications"."Job No.");
                                  IF HistCertifications2.FINDSET THEN BEGIN 
                                    REPEAT
                                      IF HistCertifications2."Document No." < "Post. Certifications"."No." THEN
                                        certificacionanterior := HistCertifications."OLD_Measurement No."; // HistCertifications2."Document No.";  //JAV 24/09/19: - Sacar el nro de certificaci¢n, no el c¢digo del registro

                                    UNTIL HistCertifications2.NEXT = 0;
                                  END;
                                END;


}
}
}
  requestpage
  {

    layout
{
area(content)
{
group("group115")
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
lblNumPresupuesto='Budget No:/ N£m. Presupuesto:/';
lblFechaCertificacion='Certification Date:/ Fecha Certificaci¢n:/';
lblNCertificacion='Certification No:/ N§ Certificaci¢n:/';
lblDescripcion='Description:/ Descripci¢n:/';
lblCertificacion='CERTIFICATION/ CERTIFICACIàN/';
lblDirectorObra='CONSTRUCTION MANAGER/ DIRECTOR DE OBRA/';
lblContratista='CONTRACTOR/ CONTRATISTA/';
lblEjecucionMaterial='MATERIAL EXECUTION/ EJECUCIàN MATERIAL/';
lblCertificacionSinIva='CERTIFICATION WITHOUT VAT/ CERTIFICACIàN SIN IVA/';
lblLiquidoCertificacion='LIQUID CERTIFICATION N§/ LÖQUIDO DE CERTIFICACION N§/';
lblADeducir='To deduct certification n§/ A deducir certificacion n§/';
lblUnidades='UNITS/ UDS/';
lblLongitud='LENGHT/ LONGITUD/';
lblAncho='WIDTH/ ANCHO/';
lblAltura='HEIGHT/ ALTURA/';
lblCantidad='QUANTITY/ CANTIDAD/';
lblPrecio='PRICE/ PRECIO/';
lblSubtotal='Subtotal/ Subtotal/';
lblTotal='Total/';
lblCertificadoOrigen='Origin Certificate/ Certificado origen/';
lblCertificacionesAnteriores='Previous Certification/ Certificacion anterior/';
lblCertificacionActual='Current certification/ Certificaci¢n actual/';
lblResumenCertificacion='CERTIFICATION SUMMARY/ RESUMEN DE CERTIFICACIàN/';
lblCertifSinIVA='CERTIFICACIàN SIN IVA/';
lblGtosGrales='Gastos Generales/';
lblBIndustrial='Beneficio Industrial/';
lblTotalBase='Total base/';
lblLiquidoCertif='"LÖQUIDO CERTIFICACIàN N§ "/';
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
//       QBText@7001103 :
      QBText: Record 7206918;
//       HistCertifications3@7001123 :
      HistCertifications3: Record 7207342;
//       PostCertifications@7001121 :
      PostCertifications: Record 7207341;
//       HistCertificationLines@7001120 :
      HistCertificationLines: Record 7207342;
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
      CaptionSubcapitulo: Code[2];
//       CaptionCapitulo@7001178 :
      CaptionCapitulo: Code[10];
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
      ADeducir_CaptionLbl: TextConst ENU='To deduct certification n§',ESP='A deducir certificacion n§';
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

    

trigger OnInitReport();    begin
                   CompanyInformation.GET();
                   //CompanyInformation.CALCFIELDS(Picture); QVE3199
                   //DataPieceworkForProduction.CALCFIELDS("Certified Amount");
                 end;

trigger OnPreReport();    begin
                  FirstLine := TRUE;
                end;



LOCAL procedure PrimeraLinea ()
    begin
      if (FirstLine) then begin
        FirstLine := FALSE;
      end else begin
        CLEAR(CompanyInformation.Picture);
      end;
    end;

    /*begin
    //{
//      QVE3199 PGM 26/10/2018: Se ha sustituido el logo de la Info. empresa por uno incrustado en el layout por problemas de procesamiento.
//    }
    end.
  */
  
}



