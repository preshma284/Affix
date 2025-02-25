report 7207352 "Comparative Quote Printing"
{
  
  
    CaptionML=ENU='Comparative Quote Printing',ESP='Impresi¢n comparativo oferta';
    
  dataset
{

DataItem("Comparative Quote Header";"Comparative Quote Header")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               ;
Column(InfoEmpresa_Picture;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(Cab_No;"Comparative Quote Header"."No.")
{
//SourceExpr="Comparative Quote Header"."No.";
}Column(Cab_Fecha;"Comparative Quote Header"."Comparative Date")
{
//SourceExpr="Comparative Quote Header"."Comparative Date";
}Column(Cab_FiltroActividad;"Comparative Quote Header"."Activity Filter")
{
//SourceExpr="Comparative Quote Header"."Activity Filter";
}Column(Cab_JobNo;"Job No.")
{
//SourceExpr="Job No.";
}Column(Cab_DescProy;Job.Description)
{
//SourceExpr=Job.Description;
}Column(Cab_varTexto;TextV)
{
//SourceExpr=TextV;
}Column(Cab_ComparativeQuoteHeader_K;"Comparative Quote Header".K)
{
//SourceExpr="Comparative Quote Header".K;
}Column(Cab_Firmas;opcFirmas)
{
//SourceExpr=opcFirmas;
}Column(Cab_Cargo1;opcCargos[1])
{
//SourceExpr=opcCargos[1];
}Column(Cab_Cargo2;opcCargos[2])
{
//SourceExpr=opcCargos[2];
}Column(Cab_Cargo3;opcCargos[3])
{
//SourceExpr=opcCargos[3];
}Column(Cab_Cargo4;opcCargos[4])
{
//SourceExpr=opcCargos[4];
}Column(Car_Nombre1;opcNombres[1])
{
//SourceExpr=opcNombres[1];
}Column(Car_Nombre2;opcNombres[2])
{
//SourceExpr=opcNombres[2];
}Column(Car_Nombre3;opcNombres[3])
{
//SourceExpr=opcNombres[3];
}Column(Car_Nombre4;opcNombres[4])
{
//SourceExpr=opcNombres[4];
}Column(Linea;Linea)
{
//SourceExpr=Linea;
}Column(TotalLineas;TotalLineas)
{
//SourceExpr=TotalLineas;
}Column(Condiciones;Condiciones)
{
//SourceExpr=Condiciones;
}Column(TotalCondiciones;TotalCondiciones)
{
//SourceExpr=TotalCondiciones;
}Column(TotalGeneral;TotalGeneral)
{
//SourceExpr=TotalGeneral;
}DataItem("QB Tmp Data Prices Vendor";"QB Tmp Data Prices Vendor")
{

               DataItemTableView=SORTING("Type","Vendor/Contact","Version No.");
               

               UseTemporary=true;
Column(Line_Agrupar;"Vendor/Contact" + FORMAT("Version No."))
{
//SourceExpr="Vendor/Contact" + FORMAT("Version No.");
}Column(Line_VersionNo;"Version No.")
{
//SourceExpr="Version No.";
}Column(Line_Type;Type)
{
//SourceExpr=Type;
}Column(Line_LineNo;Code)
{
//SourceExpr=Code;
}Column(Line_Name;"V Name")
{
//SourceExpr="V Name";
}Column(Line_Contact;"V Contact")
{
//SourceExpr="V Contact";
}Column(Line_Telef;"V Telef")
{
//SourceExpr="V Telef";
}Column(Line_Mail;"V Mail")
{
//SourceExpr="V Mail";
}Column(Line_Fax;"V Fax")
{
//SourceExpr="V Fax";
}Column(Line_Seleccionado;"V Seleccionado")
{
//SourceExpr="V Seleccionado";
}Column(Line_NoPresentado;"V NoPresentado")
{
//SourceExpr="V NoPresentado";
}Column(Line_UnidadObra;"L Pieceworl No")
{
//SourceExpr="L Pieceworl No";
}Column(Line_No;"L No.")
{
//SourceExpr="L No.";
}Column(Line_Descripcion;"L Description")
{
//SourceExpr="L Description";
}Column(Line_QTY;"L Quantity")
{
//SourceExpr="L Quantity";
}Column(Line_UM;"L UM")
{
//SourceExpr="L UM";
}Column(Line_Precio;"L Price")
{
//SourceExpr="L Price";
}Column(Line_Importe;"L Amount")
{
//SourceExpr="L Amount";
}Column(Line_PrecioPrevisto;"P Estimated Price")
{
//SourceExpr="P Estimated Price";
}Column(Line_ImportePrevisto;"P Estimated Amount")
{
//SourceExpr="P Estimated Amount";
}Column(Line_PrecioObjetivo;"P Target Price")
{
//SourceExpr="P Target Price";
}Column(Line_ImporteObjetivo;"P Target Amount")
{
//SourceExpr="P Target Amount";
}Column(Line_PrecioOptimo;"P Lowest Price")
{
//SourceExpr="P Lowest Price";
}Column(Line_ImporteOptimo;"P Lowestr Amount")
{
//SourceExpr="P Lowestr Amount";
}Column(Line_TAmount;"T Amount")
{
//SourceExpr="T Amount";
}Column(Line_TEstimated;"T Estimated")
{
//SourceExpr="T Estimated";
}Column(Line_TTarget;"T Target")
{
//SourceExpr="T Target";
}Column(Line_TLowest;"T Lowestr")
{
//SourceExpr="T Lowestr";
}Column(Line_ValidezOferta;"Q Quote Validity")
{
//SourceExpr="Q Quote Validity";
}Column(Line_PaymentTermsCode;"Q FP")
{
//SourceExpr="Q FP";
}Column(Line_PaymentMethodCode;"Q MP")
{
//SourceExpr="Q MP";
}Column(Line_Codretencion;"Q Witholding Code")
{
//SourceExpr="Q Witholding Code";
}Column(Line_DevolRetencion;"Q Return Withholding")
{
//SourceExpr="Q Return Withholding";
}Column(Line_Fechafin;"Q End Date")
{
//SourceExpr="Q End Date";
}Column(Line_Fechaoferta;"Q Quote Date")
{
//SourceExpr="Q Quote Date";
}Column(Line_FechaInicio;"Q Start Date" )
{
//SourceExpr="Q Start Date" ;
}trigger OnPreDataItem();
    BEGIN 
                               "Vendor/Contact" := '';
                               SinPrecio := FALSE;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF (FirstLine) THEN
                                    FirstLine := FALSE
                                  ELSE BEGIN 
                                    CLEAR(CompanyInformation.Picture);
                                  END;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               CompanyInformation.GET;
                               CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
                               FirstLine := TRUE;
                             END;

trigger OnAfterGetRecord();
    VAR
//                                   Vendor2@7001100 :
                                  Vendor2: Record 23;
//                                   VendorConditionsData2@1100286000 :
                                  VendorConditionsData2: Record 7207414;
                                BEGIN 
                                  Job.GET("Comparative Quote Header"."Job No.");

                                  //jmma llevar a comentario el c¢digo del proveedor seleccionado
                                  TextV := '';
                                  IF "Comparative Quote Header"."Selected Vendor"<>'' THEN BEGIN 
                                    Vendor2.GET("Comparative Quote Header"."Selected Vendor");
                                    TextV := STRSUBSTNO(Text003, "Comparative Quote Header"."Selected Version No.", Vendor2.Name);
                                  END;

                                  CLEAR(QBCommentLine);
                                  Counter := 0;
                                  QBCommentLine.RESET;
                                  QBCommentLine.SETRANGE("Document Type",QBCommentLine."Document Type"::Reestimation);
                                  QBCommentLine.SETRANGE("No.","Comparative Quote Header"."No.");
                                  IF QBCommentLine.FINDSET(FALSE) THEN
                                    REPEAT
                                      Counter += 1;
                                      TextV += QBCommentLine.Comment + ' ';
                                    UNTIL (QBCommentLine.NEXT = 0 ) OR (Counter >= 3);

                                  //Calculo de la K
                                  // JobBudget.RESET;
                                  // JobBudget.SETRANGE("Job No.","Comparative Quote Header"."Job No.");
                                  // IF JobBudget.FINDFIRST THEN BEGIN 
                                  //  JobBudget.CALCFIELDS("Production Budget Amount","Budget Amount Cost");
                                  //  Margen := ROUND(((JobBudget."Production Budget Amount" - JobBudget."Budget Amount Cost")*100/JobBudget."Production Budget Amount"),0.01);
                                  // END;
                                  // Kcalculada := ROUND(1 - (Margen/100),0.1);

                                  //JAV 25/03/19: - Calculos de importes totales para las diferencias
                                  ComparativeQuoteLines.RESET;
                                  ComparativeQuoteLines.SETRANGE("Quote No.", "No.");
                                  IF (ComparativeQuoteLines.FINDSET(FALSE)) THEN
                                    REPEAT
                                      ComparativeQuoteLines.CALCFIELDS("Lowest Price", "Lowert Amount");
                                      TotalPrevisto += ComparativeQuoteLines."Estimated Amount";
                                      TotalObjetivo += ComparativeQuoteLines."Target Amount";
                                      TotalOptimo += ComparativeQuoteLines."Lowert Amount";
                                    UNTIL ComparativeQuoteLines.NEXT = 0;

                                  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                                  //JAV 04/03/21: - QB 1.08.20 A¤ado las l¡neas al temporal
                                  "QB Tmp Data Prices Vendor".RESET;
                                  "QB Tmp Data Prices Vendor".DELETEALL;

                                  FillUpDataVendorPriceDetails;   //A¤adir las l¡neas de los productos/recursos
                                  FillUpOtherVendorConditions;    //Se a¤aden las otras condiciones del proveedor y se cualifican correctamente si las tienen o no incluidas
                                  FillUpGeneralVendorConditions;  //Se a¤aden las condiciones generales
                                  FillSelected;                   //Marcar los registros del proveedor/versi¢n seleccionados
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group579")
{
        
                  CaptionML=ESP='Opciones';
    field("ShowAllVersions";"ShowAllVersions")
    {
        
                  CaptionML=ENU='Show All Versions',ESP='Mostrar todas versiones';
    }
    field("opcFirmas";"opcFirmas")
    {
        
                  CaptionML=ESP='Firmas en Papel';
                  
                              ;trigger OnValidate()    BEGIN
                               SetCargos;
                             END;


    }
    field("opcImpNombre";"opcImpNombre")
    {
        
                  CaptionML=ESP='Firmas con nombre';
                  
                              ;trigger OnValidate()    BEGIN
                               SetCargos;
                             END;


    }
group("group583")
{
        
                  CaptionML=ESP='Firmantes';
                  Visible=seeFirmasNuevas;
grid("group584")
{
        
                  GridLayout=Rows ;
group("group585")
{
        
                  CaptionML=ESP='Firmante 1';

}

}
grid("group589")
{
        
                  GridLayout=Rows ;
group("group590")
{
        
                  CaptionML=ESP='Firmante 2';

}

}
grid("group594")
{
        
                  GridLayout=Rows ;
group("group595")
{
        
                  CaptionML=ESP='Firmante 3';

}

}
grid("group599")
{
        
                  GridLayout=Rows ;
group("group600")
{
        
                  CaptionML=ESP='Firmante 4';

}

}

}
group("group604")
{
        
                  CaptionML=ESP='Firmantes';
                  Visible=seeFirmasAntiguas;

}

}

}
}trigger OnInit()    BEGIN
               edFirmantes := TRUE;
             END;

trigger OnOpenPage()    BEGIN
                   SetCargos;
                 END;


  }
  labels
{
txtTit='COMPARATIVE QUOTES/ COMPARATIVOS COMPRAS/';
txtObra='Job:/ Obra:/';
txtFComp='Comparative Date/ Fecha comparativa/';
txtOferta='Offer No./ N§ oferta/';
txtFiltro='Activity Filter/ Filtro actividad/';
txtN='No./ N§/';
txtMed='Measurement/ Medici¢n/';
txtCdadPrev='Qty. Preview/ Cdad. Prevista/';
txtConcep='Concept/ Concepto/';
txtTf='Phone/ Tfno./';
lblFax='Fax/ fax/';
txtMov='Mobile/ M¢vil/';
txtPrecio='PRICE/ PRECIO/';
txtTotal='TOTAL/ TOTAL/';
txtOfOptima='OPTIMAL OFFER/ OFERTA àPTIMA/';
txtImpInicialPrev='Estimated initial amount/ Importe inicial previsto/';
txtImpPrev='Expected amount/ Importe previsto/';
txtImporte='Amount/ Importe/';
txtObjetivo='target/ objetivo/';
txtSumUO='SUM UNITS OF WORK/ SUMA UNIDADES DE OBRA/';
txtDifImpPrevi='Difference with expected amount/ Diferencia con importe previsto/';
txtDifImpObj='Difference with target amount/ Diferencia con importe objetivo/';
txtFComienzo='Start date/ Fecha de comienzo/';
txtFOferta='Offer date/ Fecha de la oferta/';
txtFValidezOf='Offer validity/ Validez de la oferta/';
txtFTermin='End date/ Fecha de terminaci¢n/';
txtFPago='Payment method/ Forma de pago/';
txtTPago='Payment term/ T‚rmino de pago/';
txtRetencion='Withholding/ Retenci¢n/';
txtDevGarant='Return Guarantee/ Devoluci¢n Garant¡a/';
txtSumVar='SUM SEVERAL/ SUMA OTRAS CONDICIONES/';
txtTotContrat='TOTAL CONTRACT/ TOTAL OFERTADO/';
txtObserv='OBSERVATIONS/ OBSERVACIONES/';
txtFdo='Signed :/ Fdo.:/';
txtFecha='Date/ Fecha/';
lbIncluido='INCLUDED/ INCLUIDO/';
lbimporte='AMOUNT/ IMPORTE/';
lbOtrasCond='OTHER CONDITIONS/ OTRAS CONDICIONES/';
txtPartida='SHIPMENT/ Partida/';
CompraLbl='Comparative/ Comparativo/';
DepartLbl='" "/ " "/';
ObraNLbl='JOB No.:/ OBRA n§:/';
JObraLbl='J. WORK:/ J. OBRA:/';
FechaLbl='DATE:/ FECHA:/';
NoPresentado='Not Presented/ No Presentado/';
TipoLinea='10/';
TipoTotalLinea='20/';
TipoCondiciones='30/';
TipoTotalCondiciones='40/';
TipoTotalGeneral='50/';
}
  
    var
//       Text001@1100227090 :
      Text001: TextConst ESP='#.##0,00 [$°-1]';
//       Text002@1100227089 :
      Text002: TextConst ESP='#.##0,00000 [$°-1]';
//       CompanyInformation@7001100 :
      CompanyInformation: Record 79;
//       PurchasesPayablesSetup@1100286026 :
      PurchasesPayablesSetup: Record 312;
//       Job@1100227001 :
      Job: Record 167;
//       Vendor@7001104 :
      Vendor: Record 23;
//       recContact@7001103 :
      recContact: Record 5050;
//       ActivityQB@7001102 :
      ActivityQB: Record 7207280;
//       QBCommentLine@7001101 :
      QBCommentLine: Record 7207270;
//       JobBudget@7001113 :
      JobBudget: Record 7207407;
//       ComparativeQuoteLines@7001111 :
      ComparativeQuoteLines: Record 7207413;
//       DataPieceworkForProduction@7001108 :
      DataPieceworkForProduction: Record 7207386;
//       OtherVendorConditions@1100286014 :
      OtherVendorConditions: Record 7207416;
//       tmpOtherVendorConditions@1100286013 :
      tmpOtherVendorConditions: Record 7207416 TEMPORARY;
//       VendorConditionsData@1100286022 :
      VendorConditionsData: Record 7207414;
//       VendorConditionsData2@1100286021 :
      VendorConditionsData2: Record 7207414;
//       DataPricesVendor@1100286006 :
      DataPricesVendor: Record 7207415;
//       Counter@7001105 :
      Counter: Integer;
//       AntCodeVersion@1100286008 :
      AntCodeVersion: Text;
//       NewCodeVersion@1100286007 :
      NewCodeVersion: Text;
//       Description@1100227008 :
      Description: Text[80];
//       NameOtras@1100227015 :
      NameOtras: Text[100];
//       TextV@1100227016 :
      TextV: Text[250];
//       Included@1100286000 :
      Included: Text;
//       Code@1100286001 :
      Code: Text;
//       txtFP@1100286002 :
      txtFP: Text;
//       txtMP@1100286003 :
      txtMP: Text;
//       SinPrecio@1100286004 :
      SinPrecio: Boolean;
//       JobCode@1100286012 :
      JobCode: Code[20];
//       "-------------------------- Sumas"@1100286009 :
      "-------------------------- Sumas": Integer;
//       SumVendor@1100286010 :
      SumVendor: Decimal;
//       FirstLine@7001109 :
      FirstLine: Boolean;
//       TotalPrevisto@7001122 :
      TotalPrevisto: Decimal;
//       TotalObjetivo@7001123 :
      TotalObjetivo: Decimal;
//       TotalOptimo@7001121 :
      TotalOptimo: Decimal;
//       Seleccionado@7001107 :
      Seleccionado: Boolean;
//       "-------------------------- Opciones"@1100286011 :
      "-------------------------- Opciones": Integer;
//       Text003@1100286023 :
      Text003: TextConst ESP='Proveedor propuesto: (%1) %2';
//       Linea@1100286015 :
      Linea: TextConst ESP='10';
//       TotalLineas@1100286016 :
      TotalLineas: TextConst ESP='20';
//       Condiciones@1100286017 :
      Condiciones: TextConst ESP='30';
//       TotalCondiciones@1100286018 :
      TotalCondiciones: TextConst ESP='40';
//       TotalGeneral@1100286019 :
      TotalGeneral: TextConst ESP='50';
//       ShowAllVersions@1100286020 :
      ShowAllVersions: Boolean;
//       opcFirmas@1100286030 :
      opcFirmas: Boolean;
//       opcImpNombre@1100286005 :
      opcImpNombre: Boolean;
//       opcCharges@1100286028 :
      opcCharges: ARRAY [10] OF Code[10];
//       opcOldCharges@1100286027 :
      opcOldCharges: ARRAY [10] OF Code[10];
//       opcCargos@1100286024 :
      opcCargos: ARRAY [10] OF Text;
//       opcNombres@1100286025 :
      opcNombres: ARRAY [10] OF Text;
//       edFirmantes@1100286029 :
      edFirmantes: Boolean;
//       seeFirmasAntiguas@1100286032 :
      seeFirmasAntiguas: Boolean;
//       seeFirmasNuevas@1100286031 :
      seeFirmasNuevas: Boolean;

    

trigger OnInitReport();    var
//                    Workflow@1100286000 :
                   Workflow: Record 1501;
//                    ApComparativeQuote@1100286001 :
                   ApComparativeQuote: Codeunit 7206916;
                 begin
                   opcFirmas := FALSE;
                   if Workflow.GET(ApComparativeQuote.GetApprovalsText(0)) then
                     opcFirmas := Workflow.Enabled;
                   opcImpNombre := opcFirmas;

                   PurchasesPayablesSetup.GET();
                   if PurchasesPayablesSetup."QB Comp Firmantes" then begin
                     seeFirmasNuevas := TRUE;
                     opcCharges[1] := PurchasesPayablesSetup."QB Comp Cargo Firmante 1";
                     opcCharges[2] := PurchasesPayablesSetup."QB Comp Cargo Firmante 2";
                     opcCharges[3] := PurchasesPayablesSetup."QB Comp Cargo Firmante 3";
                     opcCharges[4] := PurchasesPayablesSetup."QB Comp Cargo Firmante 4";
                   end else begin
                     seeFirmasAntiguas := TRUE;
                     if (PurchasesPayablesSetup."QB Comp Firmante 1" = '') then begin
                       opcCargos[1] := 'JEFE DE OBRA';
                       opcCargos[2] := 'JEFE DE GRUPO';
                       opcCargos[3] := 'DIRECTOR TCNICO';
                       opcCargos[4] := 'DIRECTOR GENERAL';
                     end else begin
                       opcCargos[1] := PurchasesPayablesSetup."QB Comp Firmante 1";
                       opcCargos[2] := PurchasesPayablesSetup."QB Comp Firmante 2";
                       opcCargos[3] := PurchasesPayablesSetup."QB Comp Firmante 3";
                       opcCargos[4] := PurchasesPayablesSetup."QB Comp Firmante 4";
                     end;
                   end;
                 end;



// LOCAL procedure AddTotalVendorLines (pCodeVersion@1100286000 :
LOCAL procedure AddTotalVendorLines (pCodeVersion: Text)
    var
//       Code@1100286002 :
      Code: Code[20];
//       Version@1100286003 :
      Version: Integer;
    begin
      //Linea de total del proveedor, toma los valores de la £ltima l¡nea creada por defecto
      Code := DELCHR(COPYSTR(pCodeVersion, 1, 20));
      if not EVALUATE(Version, COPYSTR(pCodeVersion, 22)) then
        Version := 0;

      "QB Tmp Data Prices Vendor".INIT;
      "QB Tmp Data Prices Vendor".Type := TotalLineas;
      "QB Tmp Data Prices Vendor"."Vendor/Contact" := Code;
      "QB Tmp Data Prices Vendor"."Version No." := Version;
      "QB Tmp Data Prices Vendor".Code := Code20(TotalLineas, FORMAT(TotalLineas));
      "QB Tmp Data Prices Vendor"."T Amount" := SumVendor;
      "QB Tmp Data Prices Vendor"."T Estimated" := TotalPrevisto;
      "QB Tmp Data Prices Vendor"."T Target" := TotalObjetivo;
      "QB Tmp Data Prices Vendor"."T Lowestr" := TotalOptimo;
      "QB Tmp Data Prices Vendor".INSERT;

      "QB Tmp Data Prices Vendor".INIT;
      "QB Tmp Data Prices Vendor".Type := TotalGeneral;
      "QB Tmp Data Prices Vendor"."Vendor/Contact" := Code;
      "QB Tmp Data Prices Vendor"."Version No." := Version;
      "QB Tmp Data Prices Vendor".Code := TotalGeneral;
      "QB Tmp Data Prices Vendor"."T Amount" := SumVendor;
      "QB Tmp Data Prices Vendor"."T Estimated" := TotalPrevisto;
      "QB Tmp Data Prices Vendor"."T Target" := TotalObjetivo;
      "QB Tmp Data Prices Vendor"."T Lowestr" := TotalOptimo;
      if "QB Tmp Data Prices Vendor".INSERT then ;

      SumVendor := 0;
    end;

//     LOCAL procedure AddTotalOtherLines (pCodeVersion@1100286000 :
    LOCAL procedure AddTotalOtherLines (pCodeVersion: Text)
    var
//       Code@1100286002 :
      Code: Code[20];
//       Version@1100286003 :
      Version: Integer;
    begin
      //Linea de total del proveedor, toma los valores de la £ltima l¡nea creada por defecto
      Code := DELCHR(COPYSTR(pCodeVersion, 1, 20));
      EVALUATE(Version, COPYSTR(pCodeVersion, 22));

      "QB Tmp Data Prices Vendor".INIT;
      "QB Tmp Data Prices Vendor".Type := TotalCondiciones;
      "QB Tmp Data Prices Vendor"."Vendor/Contact" := Code;
      "QB Tmp Data Prices Vendor"."Version No." := Version;
      "QB Tmp Data Prices Vendor".Code := Code20(TotalCondiciones, FORMAT(TotalCondiciones));
      "QB Tmp Data Prices Vendor"."T Amount" := SumVendor;
      "QB Tmp Data Prices Vendor".INSERT;

      if "QB Tmp Data Prices Vendor".GET(TotalGeneral, Code, Version, TotalGeneral) then begin
        "QB Tmp Data Prices Vendor"."T Amount" += SumVendor;
        "QB Tmp Data Prices Vendor".MODIFY;
      end else begin
        "QB Tmp Data Prices Vendor".INIT;
        "QB Tmp Data Prices Vendor".Type := TotalGeneral;
        "QB Tmp Data Prices Vendor"."Vendor/Contact" := Code;
        "QB Tmp Data Prices Vendor"."Version No." := Version;
        "QB Tmp Data Prices Vendor".Code := TotalGeneral;
        "QB Tmp Data Prices Vendor"."T Amount" := SumVendor;
        "QB Tmp Data Prices Vendor".INSERT;
      end;

      SumVendor := 0;
    end;

//     LOCAL procedure PadNum (pLon@1100286001 : Integer;pNum@1100286000 :
    LOCAL procedure PadNum (pLon: Integer;pNum: Integer) : Text;
    var
//       Data@1100286002 :
      Data: Text;
    begin
      Data := PADSTR('', pLon, '0') + FORMAT(pNum);
      Data := COPYSTR(Data, STRLEN(Data) - pLon - 1);
      exit(Data);
    end;

//     LOCAL procedure Code20 (pTipo@1100286002 : Code[2];pText@1100286003 :
    LOCAL procedure Code20 (pTipo: Code[2];pText: Text) : Code[20];
    var
//       Data@1100286001 :
      Data: Text;
//       Num@1100286004 :
      Num: Text;
    begin
      exit(COPYSTR(pTipo + pText, 1, 20));
    end;

//     LOCAL procedure SetNewCode (pVendor@1100286000 : Code[20];pContact@1100286001 : Code[20];pVersion@1100286002 :
    LOCAL procedure SetNewCode (pVendor: Code[20];pContact: Code[20];pVersion: Integer) : Text;
    begin
      exit(PADSTR(pVendor + pContact, 20, ' ') + '_' + FORMAT(pVersion));
    end;

//     LOCAL procedure IsSelected (pVendor@1100286000 : Code[20];pVersion@1100286001 :
    LOCAL procedure IsSelected (pVendor: Code[20];pVersion: Integer) : Boolean;
    begin
      exit(("Comparative Quote Header"."Selected Vendor" <> '') and
           ("Comparative Quote Header"."Selected Vendor" = pVendor) and
           ("Comparative Quote Header"."Selected Version No." = pVersion));
    end;

//     LOCAL procedure IncludeReg (pVendorConditionsData@1100286000 :
    LOCAL procedure IncludeReg (pVendorConditionsData: Record 7207414) : Boolean;
    var
//       SelVersion@1100286001 :
      SelVersion: Integer;
    begin
      pVendorConditionsData.CALCFIELDS("MAX Version");
      if (("Comparative Quote Header"."Selected Vendor" <> '') and
          ("Comparative Quote Header"."Selected Vendor" = pVendorConditionsData."Vendor No.") and
          ("Comparative Quote Header"."Selected Version No." = pVendorConditionsData."Version No.")) then
        SelVersion := "Comparative Quote Header"."Selected Version No."
      else
        SelVersion := 0;

      exit((ShowAllVersions) or
           (pVendorConditionsData."Version No." = pVendorConditionsData."MAX Version") or
           (pVendorConditionsData."Version No." = SelVersion));
    end;

    LOCAL procedure FillUpDataVendorPriceDetails ()
    begin
      //Q13150 - A¤adir los datos del proveedor en el temporal

      AntCodeVersion := '';
      SumVendor := 0;

      VendorConditionsData.RESET;
      VendorConditionsData.SETRANGE("Quote Code", "Comparative Quote Header"."No.");
      if (VendorConditionsData.FINDSET(FALSE)) then
        repeat
          VendorConditionsData.CALCFIELDS("MAX Version");
          if IncludeReg(VendorConditionsData) then begin
            DataPricesVendor.RESET;
            DataPricesVendor.SETRANGE("Quote Code", VendorConditionsData."Quote Code");
            DataPricesVendor.SETRANGE("Vendor No.", VendorConditionsData."Vendor No.");
            DataPricesVendor.SETRANGE("Contact No.", VendorConditionsData."Contact No.");
            DataPricesVendor.SETRANGE("Version No.", VendorConditionsData."Version No.");
            if (DataPricesVendor.FINDSET(FALSE)) then
              repeat
                //Si cambia el proveedor, a¤adir l¡nea de totales
                NewCodeVersion := SetNewCode(DataPricesVendor."Vendor No.", DataPricesVendor."Contact No.", DataPricesVendor."Version No.");
                if (AntCodeVersion <> '') and (AntCodeVersion <> NewCodeVersion) then
                  AddTotalVendorLines(AntCodeVersion);
                AntCodeVersion := NewCodeVersion;
                SumVendor += DataPricesVendor."Purchase Amount";
                if VendorConditionsData.GET("Comparative Quote Header"."No.",DataPricesVendor."Vendor No.",DataPricesVendor."Contact No.",DataPricesVendor."Version No.") then begin
                  VendorConditionsData.CALCFIELDS("Lines whitout prices");
                  SinPrecio := VendorConditionsData."Lines whitout prices";
                end else
                  SinPrecio := TRUE;

                "QB Tmp Data Prices Vendor".INIT;
                "QB Tmp Data Prices Vendor".Type := Linea;
                "QB Tmp Data Prices Vendor"."Vendor/Contact" := DataPricesVendor."Vendor No." + DataPricesVendor."Contact No.";
                "QB Tmp Data Prices Vendor"."Version No." := DataPricesVendor."Version No.";
                //PSM 100621+
                "QB Tmp Data Prices Vendor".Code := Code20(Linea, PadNum(16, DataPricesVendor."Line No."));
                //"QB Tmp Data Prices Vendor".Code := Code20(Linea, PadNum(18, DataPricesVendor."Line No."));
                //PSM 100621+
                "QB Tmp Data Prices Vendor"."V NoPresentado" := SinPrecio;
                //Datos del proveedor o contacto
                if DataPricesVendor."Contact No." <> '' then begin
                  recContact.GET(DataPricesVendor."Contact No.");
                  "QB Tmp Data Prices Vendor"."V Telef" := recContact."Phone No.";
                  "QB Tmp Data Prices Vendor"."V Mail" := recContact."E-Mail";
                  "QB Tmp Data Prices Vendor"."V Fax"  := recContact."Fax No.";
                  "QB Tmp Data Prices Vendor"."V Name"  := recContact.Name;
                  "QB Tmp Data Prices Vendor"."V Contact"  := '';
                end else begin
                  Vendor.GET(DataPricesVendor."Vendor No.");
                  "QB Tmp Data Prices Vendor"."V Telef" := Vendor."Phone No.";
                  "QB Tmp Data Prices Vendor"."V Mail" := Vendor."E-Mail";
                  "QB Tmp Data Prices Vendor"."V Fax"  := Vendor."Fax No.";
                  "QB Tmp Data Prices Vendor"."V Name"  := Vendor.Name;
                  "QB Tmp Data Prices Vendor"."V Contact"  := Vendor.Contact;
                end;

                //Datos de la l¡nea
                "QB Tmp Data Prices Vendor"."L No." := DataPricesVendor."No.";
                "QB Tmp Data Prices Vendor"."L Description" := DataPricesVendor.TypeDescription(DataPricesVendor.Type,DataPricesVendor."No.");
                "QB Tmp Data Prices Vendor"."L Quantity" := DataPricesVendor.TypeQTY(DataPricesVendor.Type,DataPricesVendor."No.");
                "QB Tmp Data Prices Vendor"."L UM" := DataPricesVendor.TypeUM(DataPricesVendor.Type,DataPricesVendor."No.");
                "QB Tmp Data Prices Vendor"."L Price" := DataPricesVendor."Vendor Price";
                "QB Tmp Data Prices Vendor"."L Amount" := DataPricesVendor."Purchase Amount";

                //Otros precios e importes salen de las l¡neas del comparativo
                if not ComparativeQuoteLines.GET(DataPricesVendor."Quote Code", DataPricesVendor."Line No.") then
                  ComparativeQuoteLines.INIT;
                ComparativeQuoteLines.CALCFIELDS("Lowest Price","Lowert Amount");

                "QB Tmp Data Prices Vendor"."P Estimated Price" := ComparativeQuoteLines."Estimated Price";
                "QB Tmp Data Prices Vendor"."P Estimated Amount" := ComparativeQuoteLines."Estimated Amount";
                "QB Tmp Data Prices Vendor"."P Target Price" := ComparativeQuoteLines."Target Price";
                "QB Tmp Data Prices Vendor"."P Target Amount" := ComparativeQuoteLines."Target Amount";
                "QB Tmp Data Prices Vendor"."P Lowest Price" := ComparativeQuoteLines."Lowest Price";
                "QB Tmp Data Prices Vendor"."P Lowestr Amount" := ComparativeQuoteLines."Lowert Amount";

                //Ver si ha dado los precios o no
                if VendorConditionsData.GET("Comparative Quote Header"."No.",DataPricesVendor."Vendor No.",DataPricesVendor."Contact No.",DataPricesVendor."Version No.") then begin
                  VendorConditionsData.CALCFIELDS("Lines whitout prices");
                  "QB Tmp Data Prices Vendor"."V NoPresentado" := VendorConditionsData."Lines whitout prices";
                end else
                  "QB Tmp Data Prices Vendor"."V NoPresentado" := TRUE;

                "QB Tmp Data Prices Vendor"."Version No." := DataPricesVendor."Version No.";

                "QB Tmp Data Prices Vendor".INSERT;
              until (DataPricesVendor.NEXT = 0);
          end;
        until (VendorConditionsData.NEXT = 0);

      //A¤adimos los totales del £ltimo proveedor
      AddTotalVendorLines(NewCodeVersion);
    end;

    LOCAL procedure FillUpOtherVendorConditions ()
    begin
      //Ahora se a¤aden las otras condiciones del proveedor
      tmpOtherVendorConditions.RESET;
      tmpOtherVendorConditions.DELETEALL;

      AntCodeVersion := '';
      SumVendor := 0;
      OtherVendorConditions.RESET;
      OtherVendorConditions.SETRANGE("Quote Code", "Comparative Quote Header"."No.");
      if OtherVendorConditions.FINDSET(FALSE) then
        repeat
          if VendorConditionsData.GET(OtherVendorConditions."Quote Code",OtherVendorConditions."Vendor No.",OtherVendorConditions."Contact No.",OtherVendorConditions."Version No.") then begin
            VendorConditionsData.CALCFIELDS("MAX Version");
            if IncludeReg(VendorConditionsData) then begin
              //Si cambia el proveedor, a¤adir l¡nea de totales
              NewCodeVersion := SetNewCode(OtherVendorConditions."Vendor No.", OtherVendorConditions."Contact No.", OtherVendorConditions."Version No.");
              if (AntCodeVersion <> '') and (AntCodeVersion <> NewCodeVersion) then
                AddTotalOtherLines(AntCodeVersion);

              AntCodeVersion := NewCodeVersion;
              SumVendor += OtherVendorConditions.Amount;

              "QB Tmp Data Prices Vendor".INIT;
              "QB Tmp Data Prices Vendor".Type := Condiciones;
              "QB Tmp Data Prices Vendor"."Vendor/Contact" := OtherVendorConditions."Vendor No." + OtherVendorConditions."Contact No.";
              "QB Tmp Data Prices Vendor"."Version No." := OtherVendorConditions."Version No.";
              "QB Tmp Data Prices Vendor".Code := Code20(Condiciones, OtherVendorConditions.Code);
              "QB Tmp Data Prices Vendor"."L Description" := OtherVendorConditions.Description;
              "QB Tmp Data Prices Vendor"."L Amount" := OtherVendorConditions.Amount;
              if not "QB Tmp Data Prices Vendor".INSERT then ;

              //Guardo en la tabla temporal el c¢digo para incluirlo en todos los proveedores luego
              CLEAR(tmpOtherVendorConditions);
              tmpOtherVendorConditions.Code := OtherVendorConditions.Code;
              tmpOtherVendorConditions.Description := OtherVendorConditions.Description;
              if not tmpOtherVendorConditions.INSERT then ;
            end;
          end;
        until OtherVendorConditions.NEXT = 0;

      if (AntCodeVersion <> '') then
        AddTotalOtherLines(AntCodeVersion);

      //Hay que generar registros para todos los proveedores, as¡ me aseguro de que existan los necesarios para montar la tabla en el report
      VendorConditionsData.RESET;
      VendorConditionsData.SETRANGE("Quote Code", "Comparative Quote Header"."No.");
      if (VendorConditionsData.FINDSET(FALSE)) then
        repeat
          VendorConditionsData.CALCFIELDS("MAX Version");
          if IncludeReg(VendorConditionsData) then begin
            tmpOtherVendorConditions.RESET;
            if (tmpOtherVendorConditions.FINDSET(FALSE)) then
              repeat
                if not "QB Tmp Data Prices Vendor".GET(Condiciones, VendorConditionsData."Vendor No." + VendorConditionsData."Contact No.", VendorConditionsData."Version No.",
                                                       Code20(Condiciones, tmpOtherVendorConditions.Code)) then begin
                  "QB Tmp Data Prices Vendor".INIT;
                  "QB Tmp Data Prices Vendor".Type := Condiciones;
                  "QB Tmp Data Prices Vendor"."Vendor/Contact" := VendorConditionsData."Vendor No." + VendorConditionsData."Contact No.";
                  "QB Tmp Data Prices Vendor"."Version No." := VendorConditionsData."Version No.";
                  "QB Tmp Data Prices Vendor".Code := Code20(Condiciones, tmpOtherVendorConditions.Code);
                  "QB Tmp Data Prices Vendor"."L Description" := OtherVendorConditions.Description;
                  "QB Tmp Data Prices Vendor"."L Amount" := 0;
                  "QB Tmp Data Prices Vendor".INSERT;

                  "QB Tmp Data Prices Vendor".Type := TotalCondiciones;
                  "QB Tmp Data Prices Vendor".Code := Code20(TotalCondiciones, FORMAT(TotalCondiciones));

                  "QB Tmp Data Prices Vendor"."T Amount" := 0;
                  if "QB Tmp Data Prices Vendor".INSERT then;

                end;
              until (tmpOtherVendorConditions.NEXT = 0);
          end;
        until (VendorConditionsData.NEXT = 0);

      //Si no hay otras condiciones, elimino la l¡nea de totales por est‚tica
      "QB Tmp Data Prices Vendor".RESET;
      "QB Tmp Data Prices Vendor".SETRANGE(Type, Condiciones);
      if ("QB Tmp Data Prices Vendor".ISEMPTY) then begin
        "QB Tmp Data Prices Vendor".RESET;
        "QB Tmp Data Prices Vendor".SETRANGE(Type, TotalCondiciones);
        "QB Tmp Data Prices Vendor".DELETEALL;
      end;
    end;

    LOCAL procedure FillUpGeneralVendorConditions ()
    begin
      //A¤adimos las condiciones generales del proveedor
      VendorConditionsData.RESET;
      VendorConditionsData.SETRANGE("Quote Code", "Comparative Quote Header"."No.");
      if (VendorConditionsData.FINDSET(FALSE)) then
        repeat
            if "QB Tmp Data Prices Vendor".GET(TotalGeneral, VendorConditionsData."Vendor No." + VendorConditionsData."Contact No.", VendorConditionsData."Version No.", TotalGeneral) then begin
              VendorConditionsData.CALCFIELDS("Lines whitout prices");

              "QB Tmp Data Prices Vendor"."V NoPresentado" := VendorConditionsData."Lines whitout prices";
              "QB Tmp Data Prices Vendor".MODIFY;
            end;

          VendorConditionsData.CALCFIELDS("Total Vendor Amount");

          //Dejo en blanco el registro si no se ha presentado
          if (VendorConditionsData."Total Vendor Amount" <> 0) then begin
            if (VendorConditionsData."Payment Phases" = '') then begin
              txtMP := VendorConditionsData."Payment Method Code";
              txtFP := VendorConditionsData."Payment Terms Code";
            end else begin
              txtMP := 'Por fases ' + VendorConditionsData."Payment Phases";
              txtFP := '';
            end;

            if "QB Tmp Data Prices Vendor".GET(TotalGeneral, VendorConditionsData."Vendor No." + VendorConditionsData."Contact No.", VendorConditionsData."Version No.", TotalGeneral) then begin
              "QB Tmp Data Prices Vendor"."Q Quote Validity" := FORMAT(VendorConditionsData."Quote Validity");
              "QB Tmp Data Prices Vendor"."Q FP" := txtFP;
              "QB Tmp Data Prices Vendor"."Q MP" := txtMP;
              "QB Tmp Data Prices Vendor"."Q Witholding Code" := VendorConditionsData."Withholding Code";
              "QB Tmp Data Prices Vendor"."Q Return Withholding" := FORMAT(VendorConditionsData."Return Withholding");
              "QB Tmp Data Prices Vendor"."Q end Date" := VendorConditionsData."end Date";
              "QB Tmp Data Prices Vendor"."Q Quote Date" := VendorConditionsData."Quonte Date";
              "QB Tmp Data Prices Vendor"."Q Start Date" := VendorConditionsData."Start Date";
              "QB Tmp Data Prices Vendor".MODIFY;
            end;
          end;
        until (VendorConditionsData.NEXT = 0);
    end;

    LOCAL procedure FillSelected ()
    begin
      if ("Comparative Quote Header"."Selected Vendor" <> '') then begin
        "QB Tmp Data Prices Vendor".RESET;
        "QB Tmp Data Prices Vendor".SETRANGE("Vendor/Contact", "Comparative Quote Header"."Selected Vendor");
        "QB Tmp Data Prices Vendor".SETRANGE("Version No.", "Comparative Quote Header"."Selected Version No.");
        "QB Tmp Data Prices Vendor".MODIFYALL("V Seleccionado", TRUE);
      end;
    end;

//     procedure SetJob (pJob@1100286000 :
    procedure SetJob (pJob: Code[20])
    begin
      JobCode := pJob;
    end;

    LOCAL procedure SetCargos ()
    var
//       QBPosition@1100286000 :
      QBPosition: Record 7206989;
//       QBJobResponsible@1100286001 :
      QBJobResponsible: Record 7206992;
    begin
      if (seeFirmasAntiguas) then
        exit;

      CLEAR(opcCargos);
      if QBPosition.GET(opcCharges[1]) then
        opcCargos[1] := QBPosition.Description;
      if QBPosition.GET(opcCharges[2]) then
        opcCargos[2] := QBPosition.Description;
      if QBPosition.GET(opcCharges[3]) then
        opcCargos[3] := QBPosition.Description;
      if QBPosition.GET(opcCharges[4]) then
        opcCargos[4] := QBPosition.Description;

      if (not opcImpNombre) then
        CLEAR(opcNombres)
      else begin
        if ((opcNombres[1] = '') or (opcOldCharges[1] <> opcCharges[1])) then begin
          QBJobResponsible.RESET;
          QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);
          QBJobResponsible.SETRANGE("Table Code", JobCode);
          QBJobResponsible.SETRANGE(Position, opcCharges[1]);
          if (QBJobResponsible.FINDFIRST) then begin
            QBJobResponsible.CALCFIELDS(Name);
            opcNombres[1] := QBJobResponsible.Name;
          end;
        end;
        if ((opcNombres[2] = '') or (opcOldCharges[1] <> opcCharges[1])) then begin
          QBJobResponsible.RESET;
          QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);
          QBJobResponsible.SETRANGE("Table Code", JobCode);
          QBJobResponsible.SETRANGE(Position, opcCharges[2]);
          if (QBJobResponsible.FINDFIRST) then begin
            QBJobResponsible.CALCFIELDS(Name);
            opcNombres[2] := QBJobResponsible.Name;
          end;
        end;
        if ((opcNombres[3] = '') or (opcOldCharges[1] <> opcCharges[1])) then begin
          QBJobResponsible.RESET;
          QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);
          QBJobResponsible.SETRANGE("Table Code", JobCode);
          QBJobResponsible.SETRANGE(Position, opcCharges[3]);
          if (QBJobResponsible.FINDFIRST) then begin
            QBJobResponsible.CALCFIELDS(Name);
            opcNombres[3] := QBJobResponsible.Name;
          end;
        end;
        if ((opcNombres[4] = '') or (opcOldCharges[1] <> opcCharges[1])) then begin
          QBJobResponsible.RESET;
          QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);
          QBJobResponsible.SETRANGE("Table Code", JobCode);
          QBJobResponsible.SETRANGE(Position, opcCharges[4]);
          if (QBJobResponsible.FINDFIRST) then begin
            QBJobResponsible.CALCFIELDS(Name);
            opcNombres[4] := QBJobResponsible.Name;
          end;
        end;
      end;

      opcOldCharges[1] := opcCharges[1];
      opcOldCharges[2] := opcCharges[2];
      opcOldCharges[3] := opcCharges[3];
      opcOldCharges[4] := opcCharges[4];

      edFirmantes := opcFirmas;
    end;

    /*begin
    //{
//      JAV 10/03/19: - Se a¤ade en la cabecera el c¢digo del proyecto y la actividad
//                    - Se ponen de texto en color rojo los precios que coinciden con el mejor precio
//      PGM 19/03/19: - Se arregla que no saque contactos que no est n en el comparativo
//      JAV 26/03/19: - Se elimina lo anterior porque no funcionaba
//                    - Se a¤aden campos para Agrupar Columnas = "Vendor No." + "Contact No." y se usa en las rupturas
//                    - Se cambia el comportamiento, la forma de sumar y totalizar
//                    - Se ponen colores y negrita dependiendo del dato a mostrar
//                    - Los datos de condiciones ahora ya se correspondan con la columna en que aparecen
//      JAV 22/11/19: - Se cambia la forma de obtener las otras condiciones del proveedor y se cualifican correctamente si las tienen o no incluidas
//      JDC 06/04/21: - Q13150 Modified function "Comparative Quote Header - OnAfterGetRecord"
//                             Modified ReportLayout
//                             Added function "FillUpDataVendorPriceDetails"
//    }
    end.
  */
  
}



