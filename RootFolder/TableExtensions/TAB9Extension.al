tableextension 50102 "MyExtension50102" extends "Country/Region"
{
  
  
    CaptionML=ENU='Country/Region',ESP='Pa¡s/regi¢n';
    LookupPageID="Countries/Regions";
  
  fields
{
    field(7174331;"QuoSII Country Code";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("CountryIDType"),
                                                                                                   "SII Entity"=CONST(''));
                                                   CaptionML=ENU='SII Country Code',ESP='C¢d. Pa¡s SII';
                                                   Description='QuoSII_1.4.02.042';


    }
    field(7174332;"QuoSII VAT Reg No. Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IDType"),
                                                                                                   "SII Entity"=CONST('AEAT'));
                                                   CaptionML=ENU='VAT Reg No. Type',ESP='Tipo CIF/NIF';
                                                   Description='QuoSII_1.4.97.999';


    }
    field(7174334;"QFA Code ISO 3166-1 Alpha-3";Code[3])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Code ISO 3166-1',ESP='C¢digo ISO 3166-1';
                                                   Description='QFA 0.1' ;


    }
}
  keys
{
   // key(key1;"Code")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"EU Country/Region Code")
  //  {
       /* ;
 */
   // }
   // key(key3;"Intrastat Code")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"Code","Name","VAT Scheme")
   // {
       // 
   // }
}
  
    var
//       CountryRegionNotFilledErr@1000 :
      CountryRegionNotFilledErr: TextConst ENU='You must specify a country or region.',ESP='Debe especificar un pa¡s o regi¢n.';

    


/*
trigger OnInsert();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
             end;


*/

/*
trigger OnModify();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
             end;


*/

/*
trigger OnDelete();    var
//                VATRegNoFormat@1000 :
               VATRegNoFormat: Record 381;
             begin
               VATRegNoFormat.SETFILTER("Country/Region Code",Code);
               VATRegNoFormat.DELETEALL;
             end;


*/

/*
trigger OnRename();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
             end;

*/



// procedure GetVATRegistrationNoLimitedBySetup (VATRegistrationNo@1100000 :

/*
procedure GetVATRegistrationNoLimitedBySetup (VATRegistrationNo: Code[20]) : Code[20];
    begin
      if STRPOS(VATRegistrationNo,"EU Country/Region Code") <> 0 then
        exit(COPYSTR(VATRegistrationNo,1,"VAT Registration No. digits" + STRLEN("EU Country/Region Code")));

      exit(COPYSTR(VATRegistrationNo,1,"VAT Registration No. digits"))
    end;
*/


    
//     procedure IsEUCountry (CountryRegionCode@1000 :
    
/*
procedure IsEUCountry (CountryRegionCode: Code[10]) : Boolean;
    var
//       CountryRegion@1003 :
      CountryRegion: Record 9;
    begin
      if CountryRegionCode = '' then
        ERROR(CountryRegionNotFilledErr);

      if not CountryRegion.GET(CountryRegionCode) then
        ERROR(CountryRegionNotFilledErr);

      exit(CountryRegion."EU Country/Region Code" <> '');
    end;
*/


//     procedure EUCountryFound (CountryRegionCode@1000 :
    
/*
procedure EUCountryFound (CountryRegionCode: Code[10]) : Boolean;
    var
//       CountryRegion@1003 :
      CountryRegion: Record 9;
    begin
      if CountryRegion.GET(CountryRegionCode) then
        exit(CountryRegion."EU Country/Region Code" <> '');
      exit(FALSE);
    end;
*/


    
    
/*
procedure GetNameInCurrentLanguage () : Text[50];
    var
//       CountryRegionTranslation@1001 :
      CountryRegionTranslation: Record 11;
//       Language@1002 :
      Language: Record 8;
    begin
      if CountryRegionTranslation.GET(Code,Language.GetUserLanguage) then
        exit(CountryRegionTranslation.Name);
      exit(Name);
    end;
*/


    
//     procedure CreateAddressFormat (CountryCode@1000 : Code[10];LinePosition@1001 : Integer;FieldID@1002 :
    
/*
procedure CreateAddressFormat (CountryCode: Code[10];LinePosition: Integer;FieldID: Integer) : Integer;
    var
//       CustomAddressFormat@1003 :
      CustomAddressFormat: Record 725;
    begin
      CustomAddressFormat.INIT;
      CustomAddressFormat."Country/Region Code" := Code;
      CustomAddressFormat."Field ID" := FieldID;
      CustomAddressFormat."Line Position" := LinePosition - 1;
      CustomAddressFormat.INSERT;

      if FieldID <> 0 then
        CreateAddressFormatLine(CountryCode,1,FieldID,CustomAddressFormat."Line No.");

      CustomAddressFormat.BuildAddressFormat;
      CustomAddressFormat.MODIFY;

      exit(CustomAddressFormat."Line No.");
    end;
*/


    
//     procedure CreateAddressFormatLine (CountryCode@1002 : Code[10];FieldPosition@1003 : Integer;FieldID@1000 : Integer;LineNo@1005 :
    
/*
procedure CreateAddressFormatLine (CountryCode: Code[10];FieldPosition: Integer;FieldID: Integer;LineNo: Integer)
    var
//       CustomAddressFormatLine@1004 :
      CustomAddressFormatLine: Record 726;
    begin
      CustomAddressFormatLine.INIT;
      CustomAddressFormatLine."Country/Region Code" := CountryCode;
      CustomAddressFormatLine."Line No." := LineNo;
      CustomAddressFormatLine."Field Position" := FieldPosition - 1;
      CustomAddressFormatLine.VALIDATE("Field ID",FieldID);
      CustomAddressFormatLine.INSERT;
    end;
*/


    
    
/*
procedure InitAddressFormat ()
    var
//       CompanyInformation@1002 :
      CompanyInformation: Record 79;
//       CustomAddressFormat@1000 :
      CustomAddressFormat: Record 725;
//       LineNo@1001 :
      LineNo: Integer;
    begin
      CreateAddressFormat(Code,1,CompanyInformation.FIELDNO(Name));
      CreateAddressFormat(Code,2,CompanyInformation.FIELDNO("Name 2"));
      CreateAddressFormat(Code,3,CompanyInformation.FIELDNO("Contact Person"));
      CreateAddressFormat(Code,4,CompanyInformation.FIELDNO(Address));
      CreateAddressFormat(Code,5,CompanyInformation.FIELDNO("Address 2"));
      CASE xRec."Address Format" OF
        xRec."Address Format"::"City+Post Code":
          begin
            LineNo := CreateAddressFormat(Code,6,0);
            CreateAddressFormatLine(Code,1,CompanyInformation.FIELDNO(City),LineNo);
            CreateAddressFormatLine(Code,2,CompanyInformation.FIELDNO("Post Code"),LineNo);
          end;
        xRec."Address Format"::"Post Code+City",
        xRec."Address Format"::"Blank Line+Post Code+City":
          begin
            LineNo := CreateAddressFormat(Code,6,0);
            CreateAddressFormatLine(Code,1,CompanyInformation.FIELDNO("Post Code"),LineNo);
            CreateAddressFormatLine(Code,2,CompanyInformation.FIELDNO(City),LineNo);
          end;
        xRec."Address Format"::"City+County+Post Code":
          begin
            LineNo := CreateAddressFormat(Code,6,0);
            CreateAddressFormatLine(Code,1,CompanyInformation.FIELDNO(City),LineNo);
            CreateAddressFormatLine(Code,2,CompanyInformation.FIELDNO(County),LineNo);
            CreateAddressFormatLine(Code,3,CompanyInformation.FIELDNO("Post Code"),LineNo);
          end;
      end;
      CustomAddressFormat.GET(Code,LineNo);
      CustomAddressFormat.BuildAddressFormat;
      CustomAddressFormat.MODIFY;
    end;
*/


    
/*
LOCAL procedure ClearCustomAddressFormat ()
    var
//       CustomAddressFormat@1000 :
      CustomAddressFormat: Record 725;
    begin
      CustomAddressFormat.SETRANGE("Country/Region Code",Code);
      CustomAddressFormat.DELETEALL(TRUE);
    end;

    /*begin
    //{
//      QuoSII_1.4.97.999 15/07/19 QMD - Añadir nuevo campo
//    }
    end.
  */
}




