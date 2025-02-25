report 7207439 "QB Imprimir Pagare Laser"
{
  
  
    Permissions=TableData 270=m;
    CaptionML=ESP='Imprimir Pagare L ser';
    UseRequestPage=false;
  
  dataset
{

DataItem("Linea";"QB Crear Efectos Linea")
{

               DataItemTableView=SORTING("Relacion No.","Line No.");
               

               RequestFilterFields="Tipo Linea";
Column(PARA_LA_CABECERA_________________;'')
{
//SourceExpr='';
}Column(NoPagare;"No. Pagare")
{
//SourceExpr="No. Pagare";
}Column(FechaCabecera;FechaCabecera)
{
//SourceExpr=FechaCabecera;
}Column(CompanyAddr1;CompanyAddr[1])
{
//SourceExpr=CompanyAddr[1];
}Column(CompanyAddr2;CompanyAddr[2])
{
//SourceExpr=CompanyAddr[2];
}Column(CompanyAddr3;CompanyAddr[3])
{
//SourceExpr=CompanyAddr[3];
}Column(CompanyAddr4;CompanyAddr[4])
{
//SourceExpr=CompanyAddr[4];
}Column(CompanyAddr5;CompanyAddr[5])
{
//SourceExpr=CompanyAddr[5];
}Column(CompanyAddr6;CompanyAddr[6])
{
//SourceExpr=CompanyAddr[6];
}Column(CompanyAddr7;CompanyAddr[7])
{
//SourceExpr=CompanyAddr[7];
}Column(CompanyAddr8;CompanyAddr[8])
{
//SourceExpr=CompanyAddr[8];
}Column(PARA_LA_LISTA_DE_DOCUMENTOS_____;'')
{
//SourceExpr='';
}Column(verDocumentos;verLineas)
{
//SourceExpr=verLineas;
}Column(Carta1;Carta1)
{
//SourceExpr=Carta1;
}Column(Carta2;txtCarta2)
{
//SourceExpr=txtCarta2;
}Column(Carta3;Carta3)
{
//SourceExpr=Carta3;
}Column(NConceptoCaption;NConceptoCaptionLbl)
{
//SourceExpr=NConceptoCaptionLbl;
}Column(SConceptoCaption;SConceptoCaptionLbl)
{
//SourceExpr=SConceptoCaptionLbl;
}Column(ImporteCaption;ImporteCaptionLbl)
{
//SourceExpr=ImporteCaptionLbl;
}Column(DocumentoNuestro;NDocumento)
{
//SourceExpr=NDocumento;
}Column(DocumentoSuyo;SDocumento)
{
//SourceExpr=SDocumento;
}Column(DocumentoImporte;Amount)
{
//SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpression="Currency Code";
}Column(PARA_EL_PAGARE____________________;'')
{
//SourceExpr='';
}Column(ImprimirPagare;0)
{
//SourceExpr=0;
}Column(CheckToAddr1;CheckToAddr[1])
{
//SourceExpr=CheckToAddr[1];
}Column(CheckToAddr2;CheckToAddr[2])
{
//SourceExpr=CheckToAddr[2];
}Column(CheckToAddr3;CheckToAddr[3])
{
//SourceExpr=CheckToAddr[3];
}Column(CheckToAddr4;CheckToAddr[4])
{
//SourceExpr=CheckToAddr[4];
}Column(CheckToAddr5;CheckToAddr[5])
{
//SourceExpr=CheckToAddr[5];
}Column(BancoDireccion1;BankAccount.Name + ' ' + BankAccount."Name 2")
{
//SourceExpr=BankAccount.Name + ' ' + BankAccount."Name 2";
}Column(BancoDireccion2;BankAccount.Address)
{
//SourceExpr=BankAccount.Address;
}Column(BancoDireccion3;BankAccount.County + ' ' + BankAccount.City  + ' ' + BankAccount."Country/Region Code")
{
//SourceExpr=BankAccount.County + ' ' + BankAccount.City  + ' ' + BankAccount."Country/Region Code";
}Column(BancoCCC;BankAccount."CCC Bank No." + '           ' + BankAccount."CCC Bank Branch No." + '       ' + BankAccount."CCC Control Digits" + '       ' + BankAccount."CCC Bank Account No.")
{
//SourceExpr=BankAccount."CCC Bank No." + '           ' + BankAccount."CCC Bank Branch No." + '       ' + BankAccount."CCC Control Digits" + '       ' + BankAccount."CCC Bank Account No.";
}Column(BancoIBAN;IBANCaptionLbl + ' ' + BankAccount.IBAN)
{
//SourceExpr=IBANCaptionLbl + ' ' + BankAccount.IBAN;
}Column(FechaVencimiento1;FechaVto[1])
{
//SourceExpr=FechaVto[1];
}Column(FechaVencimiento2;FechaVto[2])
{
//SourceExpr=FechaVto[2];
}Column(FechaVencimiento3;FechaVto[3])
{
//SourceExpr=FechaVto[3];
}Column(PagareImportePad;CheckAmountTextPad)
{
//SourceExpr=CheckAmountTextPad;
}Column(NombreDestinatario;COPYSTR(Vendor.Name + ' ' + Vendor."Name 2",1,80))
{
//SourceExpr=COPYSTR(Vendor.Name + ' ' + Vendor."Name 2",1,80);
}Column(ImporteLetra1;DescriptionLine[1])
{
//SourceExpr=DescriptionLine[1];
}Column(ImporteLetra2;DescriptionLine[2])
{
//SourceExpr=DescriptionLine[2];
}Column(FechaDocumento1;FechaDoc[1])
{
//SourceExpr=FechaDoc[1];
}Column(FechaDocumento2;FechaDoc[2])
{
//SourceExpr=FechaDoc[2];
}Column(FechaDocumento3;FechaDoc[3])
{
//SourceExpr=FechaDoc[3];
}Column(Imp0;"Imp0 No. Serie")
{
//SourceExpr="Imp0 No. Serie";
}Column(Imp1;Imp1)
{
//SourceExpr=Imp1;
}Column(Imp2;Imp2)
{
//SourceExpr=Imp2;
}Column(Imp3;"Imp3 No. Cheque Adicional")
{
//SourceExpr="Imp3 No. Cheque Adicional";
}Column(Imp4;Imp4)
{
//SourceExpr=Imp4;
}Column(Pie1;S3 + "No. Pagare")
{
//SourceExpr=S3 + "No. Pagare";
}Column(Pie2;S5 +BankAccount."CCC Bank No." + S2)
{
//SourceExpr=S5 +BankAccount."CCC Bank No." + S2;
}Column(Pie3;BankAccount."CCC Bank Branch No." + S5)
{
//SourceExpr=BankAccount."CCC Bank Branch No." + S5;
}Column(Pie4;BankAccount."CCC Bank Account No." + S2)
{
//SourceExpr=BankAccount."CCC Bank Account No." + S2;
}Column(Pie5;"Imp3 No. Cheque Adicional" + S1)
{
//SourceExpr="Imp3 No. Cheque Adicional" + S1;
}Column(Pie6;CheckAmountText + S3)
{
//SourceExpr=CheckAmountText + S3;
}Column(Pie0;S3 + "No. Pagare" + S5 + BankAccount."CCC Bank No." + S3 + '  ' +  BankAccount."CCC Bank Branch No." + S5 + '  ' + BankAccount."CCC Bank Account No." + S2 + '  ' + "Imp3 No. Cheque Adicional" + S1 )
{
//SourceExpr=S3 + "No. Pagare" + S5 + BankAccount."CCC Bank No." + S3 + '  ' +  BankAccount."CCC Bank Branch No." + S5 + '  ' + BankAccount."CCC Bank Account No." + S2 + '  ' + "Imp3 No. Cheque Adicional" + S1 ;
}trigger OnPreDataItem();
    BEGIN 
                               IF Linea.COUNT = 0 THEN
                                 ERROR(Text004);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  CompanyInfo.GET;
                                  FormatAddr.Company(CompanyAddr,CompanyInfo);

                                  Cabecera.GET(Linea."Relacion No.");
                                  BankAccount.GET(Cabecera."Bank Account No.");
                                  BankAccount.TESTFIELD(Blocked,FALSE);
                                  IF (BankAccount."Imp Lineas Documentos" = 0) THEN
                                    BankAccount."Imp Lineas Documentos" := 15;
                                    //ERROR('No ha definido cuantas l¡neas de documentos caben en el informe');
                                  FechaCabecera := CompanyInfo.City + ', a ' + FORMAT(Cabecera."Posting Date",0,'<Closing><Day> de <Month Text> de <Year4>');

                                  Lineas2.RESET;
                                  Lineas2.SETRANGE("No. Pagare", "No. Pagare");
                                  NroLineas := Lineas2.COUNT;
                                  IF (NroLineas > BankAccount."Imp Lineas Documentos") THEN
                                    verLineas := FALSE
                                  ELSE
                                    verLineas := TRUE;

                                  //Verificaci¢n adicional
                                  IF (Linea."Currency Code" <> BankAccount."Currency Code") THEN
                                    ERROR(Text002, "Document No.");

                                  CheckLedgEntry.RESET;
                                  CheckLedgEntry.SETRANGE("Bank Account No.", Cabecera."Bank Account No.");
                                  CheckLedgEntry.SETRANGE("Check No.", Linea."No. Pagare");
                                  CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                                  CheckLedgEntry.FINDFIRST;

                                  IF Linea."Currency Code" = '' THEN
                                    txtAux := '°'
                                  ELSE
                                    txtAux := Linea."Currency Code";

                                  IF (NOT verLineas) THEN
                                    txtCarta2 := STRSUBSTNO(Carta2c, Linea."No. Pagare", Linea."Due Date",CheckLedgEntry.Amount, txtAux, NroLineas)
                                  ELSE
                                    IF (Linea."Tipo Linea" <> Linea."Tipo Linea"::Cambio) THEN
                                      txtCarta2 := STRSUBSTNO(Carta2a, Linea."No. Pagare", Linea."Due Date",CheckLedgEntry.Amount, txtAux)
                                    ELSE
                                      txtCarta2 := STRSUBSTNO(Carta2b, Linea."No. Pagare", Linea."Due Date",CheckLedgEntry.Amount, txtAux, Linea."Bill No.", Linea."Original Due Date");

                                  CheckAmountText := FORMAT(CheckLedgEntry.Amount,0);

                                  Vendor.GET(Linea."Vendor No.");
                                  CLEAR(CheckToAddr);
                                  FormatAddr.Vendor(CheckToAddr,Vendor);

                                  FechaVto[1] := FORMAT(DATE2DMY(Linea."Due Date",1));
                                  FechaVto[2] := UPPERCASE(FORMAT(Linea."Due Date",0,'<month text>'));
                                  FechaVto[3] := FORMAT(DATE2DMY(Linea."Due Date",3));

                                  FechaDoc[1] := ChangeNotInLetters.DiaATexto(DATE2DMY(Linea."Posting Date",1));
                                  FechaDoc[2] := UPPERCASE(FORMAT(Linea."Posting Date",0,'<month text>'));
                                  FechaDoc[3] := FORMAT(DATE2DMY(Linea."Posting Date",3));

                                  NDocumento := 'N/Ref. ' + Linea."Document No.";
                                  SDocumento := '';
                                  IF Linea."External Document No." <> '' THEN BEGIN 
                                    IF (Linea."Tipo Linea" = Linea."Tipo Linea"::Abono) THEN
                                      SDocumento := 'S/Abono ' + Linea."External Document No." // + ' del ' + FORMAT(Linea."Document Date");
                                    ELSE

                                      SDocumento := 'S/Fra. ' + Linea."External Document No."; // + ' del ' + FORMAT(Linea."Document Date");
                                  END;


                                  // IF BankAccount."Currency Code" <> '' THEN
                                  //  Currency.GET(BankAccount."Currency Code")
                                  // ELSE
                                  //  Currency.InitRoundingPrecision;
                                  //
                                  // txtAux := FORMAT(Currency."Amount Rounding Precision");
                                  // mDec   := STRLEN(txtAux)-2;
                                  // txtAux := FORMAT(CheckLedgEntry.Amount,0,'<Sign><Integer Thousand><Decimals>');
                                  // nDec   := STRLEN(txtAux) - STRPOS(txtAux,',');
                                  // txtAux := txtAux + PADSTR('',mDec-nDec,'0');
                                  //
                                  // CheckAmountText    := txtAux;
                                  // CheckAmountTextPad := PADSTR('',30 - STRLEN(txtAux) - 3 ,'*') + txtAux + '***';
                                  //
                                  // CLEAR(ChangeNotInLetters);
                                  //ChangeNotInLetters.FormatNoText(DescriptionLine, CheckLedgEntry.Amount, BankAccount."Currency Code");
                                  ChangeNotInLetters.Decimal2TextTwoLines(DescriptionLine[1],DescriptionLine[2], MAXSTRLEN(DescriptionLine[1]), CheckLedgEntry.Amount, FALSE, BankAccount."Currency Code", 0);
                                  CheckAmountTextPad := ChangeNotInLetters.Decimal2Format(CheckLedgEntry.Amount, BankAccount."Currency Code", 30, '*');

                                  Linea.Printed := TRUE;
                                  Linea.Carta := Linea.Carta OR verLineas;      //Si ya estaba impresa o no tiene necesidad de la carta adicional la marco como impresa
                                  Linea.Tipo := Linea.Tipo::Pagare;
                                  Linea.MODIFY(TRUE);
                                END;


}
}
  requestpage
  {
SaveValues=true;
    layout
{
}
  }
  labels
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='Preview is not allowed.',ESP='No est  permitida la vista previa.';
//       Text001@1001 :
      Text001: TextConst ENU='Last Check No. must be filled in.',ESP='Debe rellenar el £lt. n§ cheque.';
//       Text002@1005 :
      Text002: TextConst ESP='El documento %1 no est  en la misma divisa del banco';
//       CompanyInfo@1062 :
      CompanyInfo: Record 79;
//       BankAccount@1071 :
      BankAccount: Record 270;
//       CheckLedgEntry@1072 :
      CheckLedgEntry: Record 272;
//       Currency@1073 :
      Currency: Record 4;
//       GLSetup@1007 :
      GLSetup: Record 98;
//       Vendor@7001112 :
      Vendor: Record 23;
//       Cabecera@7001123 :
      Cabecera: Record 7206922;
//       Lineas2@7001104 :
      Lineas2: Record 7206923;
//       FormatAddr@1074 :
      FormatAddr: Codeunit 365;
//       CheckManagement@1075 :
      CheckManagement: Codeunit 367;
//       ChangeNotInLetters@7001100 :
      ChangeNotInLetters: Codeunit 7207289;
//       CompanyAddr@1076 :
      CompanyAddr: ARRAY [8] OF Text[50];
//       CheckToAddr@1077 :
      CheckToAddr: ARRAY [8] OF Text[50];
//       FechaVto@7001125 :
      FechaVto: ARRAY [3] OF Text;
//       FechaDoc@7001116 :
      FechaDoc: ARRAY [3] OF Text;
//       CheckNoText@1084 :
      CheckNoText: Text[30];
//       CheckAmountText@7001118 :
      CheckAmountText: Text[30];
//       CheckAmountTextPad@7001117 :
      CheckAmountTextPad: Text[30];
//       DescriptionLine@7001124 :
      DescriptionLine: ARRAY [2] OF Text[80];
//       FoundChecks@1098 :
      FoundChecks: Boolean;
//       Text003@7001130 :
      Text003: TextConst ESP='Ha sobrepasado el n£mero m ximo de pagar‚s a imprimir\N£mero de pagar‚ %1\M ximo configurado para el banco %2';
//       Text004@7001144 :
      Text004: TextConst ESP='Nada que imprimir';
//       Carta1@7001102 :
      Carta1: TextConst ESP='Muy se¤ores nuestros:';
//       Carta2a@7001109 :
      Carta2a: TextConst ESP='          Adjunto remitimos pagar‚ n£mero %1 con vencimiento %2 por un importe de %3%4, como pago de los documentos que relacionamos a continuaci¢n:';
//       Carta2b@7001103 :
      Carta2b: TextConst ESP='          Adjunto remitimos pagar‚ n£mero %1 con vencimiento %2 por un importe de %3%4, que reemplaza a uno anterior, como pago de los documentos que relacionamos a continuaci¢n:';
//       Carta2c@1100286006 :
      Carta2c: TextConst ESP='          Adjunto remitimos pagar‚ n£mero %1 con vencimiento %2 por un importe de %3%4, como pago de %5 documentos que relacionamos en hoja aparte';
//       Carta3@7001110 :
      Carta3: TextConst ESP='Sin otro particular, reciba un cordial saludo.';
//       NConceptoCaptionLbl@7001142 :
      NConceptoCaptionLbl: TextConst ESP='N/REFERENCIA';
//       SConceptoCaptionLbl@7001113 :
      SConceptoCaptionLbl: TextConst ESP='CONCEPTO DE PAGO';
//       ImporteCaptionLbl@7001114 :
      ImporteCaptionLbl: TextConst ESP='IMPORTE';
//       AntVendor@7001106 :
      AntVendor: Code[20];
//       AntFecha@7001108 :
      AntFecha: Date;
//       AntPagare@7001107 :
      AntPagare: Code[20];
//       FechaCabecera@7001101 :
      FechaCabecera: Text;
//       txtCarta2@7001111 :
      txtCarta2: Text;
//       IBANCaptionLbl@7001115 :
      IBANCaptionLbl: TextConst ESP='IBAN';
//       txtAux@7001121 :
      txtAux: Text;
//       nDec@7001122 :
      nDec: Integer;
//       mDec@7001120 :
      mDec: Integer;
//       SDocumento@7001131 :
      SDocumento: Text;
//       NDocumento@7001141 :
      NDocumento: Text;
//       S1@1100286000 :
      S1: TextConst ESP='a';
//       S2@1100286001 :
      S2: TextConst ESP='b';
//       S3@1100286002 :
      S3: TextConst ESP='c';
//       S4@1100286003 :
      S4: TextConst ESP='d';
//       S5@1100286004 :
      S5: TextConst ESP='e';
//       NroLineas@1100286005 :
      NroLineas: Integer;
//       verLineas@1100286007 :
      verLineas: Boolean;

    /*begin
    end.
  */
  
}



