tableextension 50120 "MyExtension50120" extends "Company Information"
{
  
  
    CaptionML=ENU='Company Information',ESP='Informaci¢n empresa';
  
  fields
{
    field(7174331;"QuoSII Activate";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Activate QuoSII',ESP='Activar QuoSII';
                                                   Description='QuoSII';


    }
    field(7174332;"QuoSII Nos. Serie SII";Code[20])
    {
        TableRelation="No. Series";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Serial No. SII',ESP='Nos. serie QuoSII';
                                                   Description='QuoSII';


    }
    field(7174333;"QuoSII Export SII Path";Text[250])
    {
        ExtendedDatatype=URL;
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Export SII Path',ESP='Ruta Exportacion QuoSII';
                                                   Description='QuoSII';


    }
    field(7174334;"QuoSII VAT Reg. No. Repres.";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Registration No. Repre',ESP='CIF/NIF Representante';
                                                   Description='QuoSII';


    }
    field(7174335;"QuoSII VAT Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IDType"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Type',ESP='Tipo CIF/NIF';
                                                   Description='QuoSII';


    }
    field(7174336;"QuoSII Day Periodo Purchase";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='D¡a periodo anterior compras';
                                                   Description='QuoSII 1.5e   JAV 12/04/21 que d¡a marca el m ximo para usar periodo anterior en compras';


    }
    field(7174337;"QuoSII Not Use Shipment Date";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No usar Fechas envio como Fecha Operaci¢n';
                                                   Description='QuoSII 1.5e   JAV 12/04/21 si se marca indica que NO se usar n las fechas de envio en la generaci¢n del QuoSII';


    }
    field(7174338;"QuoSII Server WS";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Server WS',ESP='Servidor WS';
                                                   Description='QuoSII';


    }
    field(7174339;"QuoSII Port WS";Text[6])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Port WS',ESP='Puerto WS';
                                                   Description='QuoSII';


    }
    field(7174340;"QuoSII Instance WS";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Instance WS',ESP='Instancia WS';
                                                   Description='QuoSII';


    }
    field(7174341;"QuoSII First date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Primera fecha de env¡o';
                                                   Description='QuoSII 1.5f   JAV 15/04/21 a partir de que fecha de registro se env¡an documentos al SII';


    }
    field(7174342;"QuoSII User WS";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User WS',ESP='Usuario WS';
                                                   Description='QuoSII';


    }
    field(7174343;"QuoSII Pass WS";Text[100])
    {
        ExtendedDatatype=Masked;
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Pass WS',ESP='Contrase¤a WS';
                                                   Description='QuoSII 1,5s PSM 14/06/21 se amplia de 30 a 100';


    }
    field(7174344;"QuoSII Domain WS";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Domain WS',ESP='Dominio WS';
                                                   Description='QuoSII';


    }
    field(7174345;"QuoSII REAGYP %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='REAGYP %',ESP='REAGYP %';
                                                   Description='QuoSII';


    }
    field(7174346;"QuoSII Version";Option)
    {
        OptionMembers="1.0","1.1";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='SII Version',ESP='Version QuoSII';
                                                   
                                                   Description='QuoSII,QuoSII1.4';


    }
    field(7174347;"QuoSII Email From";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   Description='QuoSII';


    }
    field(7174348;"QuoSII Email To";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   Description='QuoSII';


    }
    field(7174349;"QuoSII Use Server DLL";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Use Server DLL',ESP='Usar Servidor DLL';
                                                   Description='QuoSII';


    }
    field(7174350;"QuoSII Certificate";BLOB)
    {
        DataClassification=ToBeClassified;
                                                   Description='QuoSII';


    }
    field(7174351;"QuoSII Certificate Password";BLOB)
    {
        DataClassification=ToBeClassified;
                                                   Description='QuoSII';


    }
    field(7174352;"QuoSII Purch. Invoices Period";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purch. Invoices Period',ESP='Periodo de Facturas Recibidas';
                                                   Description='QuoSII';


    }
    field(7174353;"QuoSII Inclusion Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='SII Inclusion Date',ESP='Fecha Inclusion QuoSII';
                                                   Description='QuoSII';


    }
    field(7174354;"QuoSII Ignore Messages";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Ignore Messages for 100.000.000 Invoices±',ESP='Ignorar mensajes para facturas de 100.000.000±';
                                                   Description='QuoSII';


    }
    field(7174355;"QuoSII Use Auto Date";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Adjust to Shipping Date',ESP='Ajustar a Fecha Env¡o';
                                                   Description='QuoSII 1.06.12   JAV 28/09/22: - Se cambia el caption para que sea mas informativo';


    }
    field(7174356;"QuoSII Use SSL";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Use SSL',ESP='Usar SSL';
                                                   Description='QuoSII';


    }
    field(7174357;"QuoSII Send Queue Type";Option)
    {
        OptionMembers="Real","Pruebas";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo entorno del env¡o a la cola';
                                                   OptionCaptionML=ESP='Real,Pruebas';
                                                   
                                                   Description='QuoSII 1.5j  JAV 06/05/21 Que tipo de env¡o se usar  para la cola de proyectos';


    }
    field(7174358;"QuoSII Send Default Type";Option)
    {
        OptionMembers="Real","Pruebas";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo entorno del env¡o';
                                                   OptionCaptionML=ESP='Real,Pruebas';
                                                   
                                                   Description='QuoSII 1.5l  JAV 06/05/21 Que tipo de env¡o se usar  para env¤ios normales';


    }
    field(7174359;"QuoSII Admin";Text[50])
    {
        TableRelation="User Setup";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Usuario Administrador';
                                                   Description='QuoSII 1.5l  JAV 04/08/21 Si el usuario es el administrador de QuoSII';


    }
    field(7174360;"QuoSII Dimension Job";Code[20])
    {
        TableRelation="Dimension";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Dimensi¢n para Proyectos';
                                                   Description='QuoSII 1.5z - Que dimensi¢n es la relacionada con proyectos que deseamos guardar en el movimeinto a partir del documento original';


    }
    field(7174361;"QuoSII Purch.Operation Date";Option)
    {
        OptionMembers="Blank","DocumentDate","PostingDate";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Operaci¢n Compras';
                                                   OptionCaptionML=ENU='Blank,Document Date,Posting Date',ESP='En Blanco,Fecha Emisi¢n,Fecha Registro';
                                                   
                                                   Description='QuoSII 1.06.06 JAV 28/09/22: - Indica que fecha se usar  como fecha de operaci¢n en documentos de compra';


    }
}
  keys
{
   // key(key1;"Primary Key")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       PostCode@1000 :
      PostCode: Record 225;
//       Text000@1001 :
      Text000: TextConst ENU='The number that you entered may not be a valid International Bank Account Number (IBAN). Do you want to continue?',ESP='Es posible que el n£mero que ha introducido no sea un n£mero de cuenta bancaria internacional (IBAN) v lido. ¨Confirma que desea continuar?';
//       Text001@1002 :
      Text001: TextConst ENU='File Location for IC files',ESP='Ubicaci¢n de los archivos IC';
//       Text002@1003 :
      Text002: TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ESP='Para poder usar Online Map, primero debe rellenar la ventana Configuraci¢n Online Map.\Consulte Configuraci¢n de Online Map en la Ayuda.';
//       NoPaymentInfoQst@1005 :
      NoPaymentInfoQst: 
// "%1 = Company Information"
TextConst ENU='No payment information is provided in %1. Do you want to update it now?',ESP='No se ha proporcionado ninguna informaci¢n de pago en %1. ¨Desea actualizar ahora?';
//       NoPaymentInfoMsg@1004 :
      NoPaymentInfoMsg: TextConst ENU='No payment information is provided in %1. Review the report.',ESP='No se proporciona ninguna informaci¢n de pago en %1. Revise el informe.';
//       GLNCheckDigitErr@1006 :
      GLNCheckDigitErr: TextConst ENU='The %1 is not valid.',ESP='%1 no es v lido.';
//       DevBetaModeTxt@1007 :
      DevBetaModeTxt: 
// {Locked}
TextConst ENU='DEV_BETA',ESP='DEV_BETA';
//       SyncAlreadyEnabledErr@1008 :
      SyncAlreadyEnabledErr: TextConst ENU='Office 365 Business profile synchronization is already enabled for another company in the system.',ESP='La sincronizaci¢n del perfil de Office 365 Empresa ya est  habilitada para otra empresa en el sistema.';
//       ContactUsFullTxt@1010 :
      ContactUsFullTxt: 
// "%1 = phone number, %2 = email"
TextConst ENU='Questions? Contact us at %1 or %2.',ESP='Si tiene alguna pregunta, p¢ngase en contacto con nosotros en %1 o %2.';
//       ContactUsShortTxt@1009 :
      ContactUsShortTxt: 
// "%1 = phone number or email"
TextConst ENU='Questions? Contact us at %1.',ESP='Si tiene alguna pregunta, p¢ngase en contacto con nosotros en %1.';
//       PictureUpdated@1011 :
      PictureUpdated: Boolean;

    
    


/*
trigger OnInsert();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
               if PictureUpdated then
                 "Picture - Last Mod. Date Time" := "Last Modified Date Time";
             end;


*/

/*
trigger OnModify();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
               if PictureUpdated then
                 "Picture - Last Mod. Date Time" := "Last Modified Date Time";
             end;

*/



// procedure CheckIBAN (IBANCode@1000 :

/*
procedure CheckIBAN (IBANCode: Code[100])
    var
//       Modulus97@1001 :
      Modulus97: Integer;
//       I@1002 :
      I: Integer;
    begin
      if IBANCode = '' then
        exit;
      IBANCode := DELCHR(IBANCode);
      Modulus97 := 97;
      if (STRLEN(IBANCode) <= 5) or (STRLEN(IBANCode) > 34) then
        IBANError;
      if IsDigit(IBANCode[1]) or IsDigit(IBANCode[2]) then
        IBANError;
      ConvertIBAN(IBANCode);
      WHILE STRLEN(IBANCode) > 6 DO
        IBANCode := CalcModulus(COPYSTR(IBANCode,1,6),Modulus97) + COPYSTR(IBANCode,7);
      EVALUATE(I,IBANCode);
      if (I MOD Modulus97) <> 1 then
        IBANError;
    end;
*/


//     LOCAL procedure ConvertIBAN (var IBANCode@1000 :
    
/*
LOCAL procedure ConvertIBAN (var IBANCode: Code[100])
    var
//       I@1002 :
      I: Integer;
    begin
      IBANCode := COPYSTR(IBANCode,5) + COPYSTR(IBANCode,1,4);
      I := 0;
      WHILE I < STRLEN(IBANCode) DO begin
        I := I + 1;
        if ConvertLetter(IBANCode,COPYSTR(IBANCode,I,1),I) then
          I := 0;
      end;
    end;
*/


//     LOCAL procedure CalcModulus (Number@1000 : Code[10];Modulus97@1001 :
    
/*
LOCAL procedure CalcModulus (Number: Code[10];Modulus97: Integer) : Code[10];
    var
//       I@1002 :
      I: Integer;
    begin
      EVALUATE(I,Number);
      I := I MOD Modulus97;
      if I = 0 then
        exit('');
      exit(FORMAT(I));
    end;
*/


//     LOCAL procedure ConvertLetter (var IBANCode@1000 : Code[100];Letter@1001 : Code[1];LetterPlace@1002 :
    
/*
LOCAL procedure ConvertLetter (var IBANCode: Code[100];Letter: Code[1];LetterPlace: Integer) : Boolean;
    var
//       Letter2@1003 :
      Letter2: Code[2];
//       LetterCharInt@1004 :
      LetterCharInt: Integer;
    begin
      // CFR assumes letter to number conversion where A = 10, B = 11, ... , Y = 34, Z = 35
      // We must ignore country alphabet feature like Estonian
      LetterCharInt := Letter[1];
      if LetterCharInt IN [65..90] then begin
        Letter2 := FORMAT(LetterCharInt - 55,9);
        if LetterPlace = 1 then
          IBANCode := Letter2 + COPYSTR(IBANCode,2)
        else begin
          if LetterPlace = STRLEN(IBANCode) then
            IBANCode := COPYSTR(IBANCode,1,LetterPlace - 1) + Letter2
          else
            IBANCode :=
              COPYSTR(IBANCode,1,LetterPlace - 1) + Letter2 + COPYSTR(IBANCode,LetterPlace + 1);
        end;
        exit(TRUE);
      end;
      if IsDigit(Letter[1]) then
        exit(FALSE);

      IBANError;
    end;
*/


//     LOCAL procedure IsDigit (LetterChar@1000 :
    
/*
LOCAL procedure IsDigit (LetterChar: Char) : Boolean;
    var
//       Letter@1001 :
      Letter: Code[1];
    begin
      Letter[1] := LetterChar;
      exit((Letter >= '0') and (Letter <= '9'))
    end;
*/


    
/*
LOCAL procedure IBANError ()
    begin
      if not CONFIRM(Text000) then
        ERROR('');
    end;
*/


    
    
/*
procedure DisplayMap ()
    var
//       MapPoint@1001 :
      MapPoint: Record 800;
//       MapMgt@1000 :
      MapMgt: Codeunit 802;
    begin
      if MapPoint.FINDFIRST then
        MapMgt.MakeSelection(DATABASE::"Company Information",GETPOSITION)
      else
        MESSAGE(Text002);
    end;
*/


    
/*
LOCAL procedure IsPaymentInfoAvailble () : Boolean;
    begin
      exit(
        (("Giro No." + IBAN + "Bank Name" + "Bank Branch No." + "Bank Account No." + "SWIFT Code") <> '') or
        "Allow Blank Payment Info.");
    end;
*/


    
    
/*
procedure GetRegistrationNumber () : Text;
    begin
      exit("Registration No.");
    end;
*/


    
    
/*
procedure GetRegistrationNumberLbl () : Text;
    begin
      exit(FIELDCAPTION("Registration No."));
    end;
*/


    
    
/*
procedure GetVATRegistrationNumber () : Text;
    begin
      exit("VAT Registration No.");
    end;
*/


    
    
/*
procedure GetVATRegistrationNumberLbl () : Text;
    begin
      if Name = '' then // Is the record loaded?
        GET;
      if "VAT Registration No." = '' then
        exit('');
      exit(FIELDCAPTION("VAT Registration No."));
    end;
*/


    
    
/*
procedure GetLegalOffice () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure GetLegalOfficeLbl () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure GetCustomGiro () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure GetCustomGiroLbl () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure VerifyAndSetPaymentInfo ()
    var
//       CompanyInformationPage@1000 :
      CompanyInformationPage: Page 1;
    begin
      GET;
      if IsPaymentInfoAvailble then
        exit;
      if CONFIRM(NoPaymentInfoQst,TRUE,TABLECAPTION) then begin
        CompanyInformationPage.SETRECORD(Rec);
        CompanyInformationPage.EDITABLE(TRUE);
        if CompanyInformationPage.RUNMODAL = ACTION::OK then
          CompanyInformationPage.GETRECORD(Rec);
      end;
      if not IsPaymentInfoAvailble then
        MESSAGE(NoPaymentInfoMsg,TABLECAPTION);
    end;
*/


    
//     procedure GetSystemIndicator (var Text@1000 : Text[250];var Style@1001 :
    
/*
procedure GetSystemIndicator (var Text: Text[250];var Style: Option "Standard","Accent1","Accent2","Accent3","Accent4","Accent5","Accent6","Accent7","Accent8","Accent")
    begin
      Style := "System Indicator Style";
      CASE "System Indicator" OF
        "System Indicator"::None:
          Text := '';
        "System Indicator"::"Custom Text":
          Text := "Custom System Indicator Text";
        "System Indicator"::"Company Information":
          Text := Name;
        "System Indicator"::Company:
          Text := COMPANYNAME;
        "System Indicator"::Database:
          Text := GetDatabaseIndicatorText(FALSE);
        "System Indicator"::"Company+Database":
          Text := GetDatabaseIndicatorText(TRUE);
      end;
      OnAfterGetSystemIndicator(Text,Style)
    end;
*/


//     LOCAL procedure GetDatabaseIndicatorText (IncludeCompany@1003 :
    
/*
LOCAL procedure GetDatabaseIndicatorText (IncludeCompany: Boolean) : Text[250];
    var
//       ActiveSession@1000 :
      ActiveSession: Record 2000000110;
//       Text@1002 :
      Text: Text[1024];
    begin
      ActiveSession.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
      ActiveSession.SETRANGE("Session ID",SESSIONID);
      ActiveSession.FINDFIRST;
      Text := ActiveSession."Database Name" + ' - ' + ActiveSession."Server Computer Name";
      if IncludeCompany then
        Text := COMPANYNAME + ' - ' + Text;
      if STRLEN(Text) > 250 then
        exit(COPYSTR(Text,1,247) + '...');
      exit(Text)
    end;
*/


    
/*
procedure BuildCCC ()
    begin
      "CCC No." := "CCC Bank No." + "CCC Bank Branch No." + "CCC Control Digits" + "CCC Bank Account No.";
      if "CCC No." <> '' then
        TESTFIELD("Bank Account No.",'');
    end;
*/


//     procedure PrePadString (InString@1100000 : Text[250];MaxLen@1100001 :
    
/*
procedure PrePadString (InString: Text[250];MaxLen: Integer) : Text[250];
    begin
      exit(PADSTR('',MaxLen - STRLEN(InString),'0') + InString);
    end;
*/


    
//     procedure GetCountryRegionCode (CountryRegionCode@1000 :
    
/*
procedure GetCountryRegionCode (CountryRegionCode: Code[10]) : Code[10];
    begin
      CASE CountryRegionCode OF
        '',"Country/Region Code":
          exit("Country/Region Code");
        else
          exit(CountryRegionCode);
      end;
    end;
*/


    
    
/*
procedure GetDevBetaModeTxt () : Text[250];
    begin
      exit(DevBetaModeTxt);
    end;
*/


    
    
/*
procedure GetContactUsText () : Text;
    begin
      if ("Phone No." <> '') and ("E-Mail" <> '') then
        exit(STRSUBSTNO(ContactUsFullTxt,"Phone No.","E-Mail"));

      if "Phone No." <> '' then
        exit(STRSUBSTNO(ContactUsShortTxt,"Phone No."));

      if "E-Mail" <> '' then
        exit(STRSUBSTNO(ContactUsShortTxt,"E-Mail"));

      exit('');
    end;
*/


    
    
/*
procedure IsSyncEnabledForOtherCompany () SyncEnabled : Boolean;
    var
//       CompanyInformation@1000 :
      CompanyInformation: Record 79;
//       Company@1001 :
      Company: Record 2000000006;
    begin
      Company.SETFILTER(Name,'<>%1',COMPANYNAME);
      if Company.FINDSET then begin
        repeat
          CompanyInformation.CHANGECOMPANY(Company.Name);
          if CompanyInformation.GET then
            SyncEnabled := CompanyInformation."Sync with O365 Bus. profile";
        until (Company.NEXT = 0) or SyncEnabled;
      end;
    end;
*/


    
/*
LOCAL procedure SetBrandColorValue ()
    var
//       O365BrandColor@1000 :
      O365BrandColor: Record 2121;
    begin
      if "Brand Color Code" <> '' then begin
        O365BrandColor.GET("Brand Color Code");
        "Brand Color Value" := O365BrandColor."Color Value";
      end else
        "Brand Color Value" := '';
    end;
*/


    
//     LOCAL procedure OnAfterGetSystemIndicator (var Text@1000 : Text[250];var Style@1001 :
    
/*
LOCAL procedure OnAfterGetSystemIndicator (var Text: Text[250];var Style: Option "Standard","Accent1","Accent2","Accent3","Accent4","Accent5","Accent6","Accent7","Accent8","Accent")
    begin
    end;

    /*begin
    //{
//      JAV 23/08/21: - QuoSII 1.5z - Se a¤ade el campo 7174360 "QuoSII Dimension Job" que indica que dimensi¢n es la relacionada con proyectos que deseamos guardar en el documento
//      JAV 28/09/22: - QuoSII 1.06.06 Se a¤ade el campo 7174361 "QuoSII Purch.Operation". Se cambia el caption de "QuoSII Use Auto Date" para que sea mas informativo
//    }
    end.
  */
}




