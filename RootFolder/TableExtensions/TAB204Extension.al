tableextension 50152 "MyExtension50152" extends "Unit of Measure"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='Unit of Measure',ESP='Unidad medida';
    LookupPageID="Units of Measure";
    DrillDownPageID="Units of Measure";
  
  fields
{
    field(7174334;"QFA Unit of measure code FACE";Option)
    {
        OptionMembers=" ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo FACE para eFactura';
                                                   OptionCaptionML=ENU='" ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36"',ESP='" ,01 Unidades,02 Horas-HUR,03 Kilogramos-KGM,04 Litros-LTR,05 Otros,06 Cajas-BX,07 Bandejas-DS,08 Barriles-BA,09 Bidones-JY,10 Bolsas-BG,11 Bombonas-CO,12 Botellas-BO,13 Botes-CI,14 Tetra Briks,15 Centilitros-CLT,16 Centímetros-CMT,17 Cubos-BI,18 Docenas,19 Estuches-CS,20 Garrafas-DJ,21 Gramos-GRM,22 Kilómetros-KMT,23 Latas-CA,24 Manojos-BH,25 Metros-MTR,26 Milímetros-MMT,27 6-Packs,28 Paquetes-PK,29 Raciones,30 Rollos-RO,31 Sobres-EN,32 Tarrinas-TB,33 Metro cúbico-MTQ,34 Segundo-SEC,35 Vatio-WTT,36 Kilovatio por hora-KWh"';
                                                   
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
}
  fieldgroups
{
   // fieldgroup(Brick;"Code","Description","International Standard Code")
   // {
       // 
   // }
}
  
    var
//       UnitOfMeasureTranslation@1000 :
      UnitOfMeasureTranslation: Record 5402;

    


/*
trigger OnInsert();    begin
               SetLastDateTimeModified;
             end;


*/

/*
trigger OnModify();    begin
               SetLastDateTimeModified;
             end;


*/

/*
trigger OnDelete();    begin
               UnitOfMeasureTranslation.SETRANGE(Code,Code);
               UnitOfMeasureTranslation.DELETEALL;
             end;


*/

/*
trigger OnRename();    begin
               UpdateItemBaseUnitOfMeasure;
             end;

*/




/*
LOCAL procedure UpdateItemBaseUnitOfMeasure ()
    var
//       Item@1000 :
      Item: Record 27;
    begin
      Item.SETCURRENTKEY("Base Unit of Measure");
      Item.SETRANGE("Base Unit of Measure",xRec.Code);
      if not Item.ISEMPTY then
        Item.MODIFYALL("Base Unit of Measure",Code,TRUE);
    end;
*/


    
    
/*
procedure GetDescriptionInCurrentLanguage () : Text[10];
    var
//       Language@1000 :
      Language: Record 8;
//       UnitOfMeasureTranslation@1001 :
      UnitOfMeasureTranslation: Record 5402;
    begin
      if UnitOfMeasureTranslation.GET(Code,Language.GetUserLanguage) then
        exit(UnitOfMeasureTranslation.Description);
      exit(Description);
    end;
*/


    
//     procedure CreateListInCurrentLanguage (var TempUnitOfMeasure@1000 :
    
/*
procedure CreateListInCurrentLanguage (var TempUnitOfMeasure: Record 204 TEMPORARY)
    var
//       UnitOfMeasure@1001 :
      UnitOfMeasure: Record 204;
    begin
      if UnitOfMeasure.FINDSET then
        repeat
          TempUnitOfMeasure := UnitOfMeasure;
          TempUnitOfMeasure.Description := UnitOfMeasure.GetDescriptionInCurrentLanguage;
          TempUnitOfMeasure.INSERT;
        until UnitOfMeasure.NEXT = 0;
    end;
*/


    
/*
LOCAL procedure SetLastDateTimeModified ()
    var
//       DotNet_DateTimeOffset@1000 :
      DotNet_DateTimeOffset: Codeunit 3006;
    begin
      "Last Modified Date Time" := DotNet_DateTimeOffset.ConvertToUtcDateTime(CURRENTDATETIME);
    end;

    /*begin
    end.
  */
}




