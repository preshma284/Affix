tableextension 50170 "QBU VAT Business Posting GroupExt" extends "VAT Business Posting Group"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='VAT Business Posting Group',ESP='Grupo registro IVA negocio';
    LookupPageID="VAT Business Posting Groups";
    DrillDownPageID="VAT Business Posting Groups";
  
  fields
{
    field(7174333;"QBU QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';


    }
    field(7174440;"QBU VAT Bus.Pst.Grp. in Cr.Memos";Code[20])
    {
        TableRelation="VAT Business Posting Group";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Bus.Pst.Grp. in Cr.Memos',ESP='Grp.Reg. IVA Neg. en Abonos';
                                                   Description='DynPlus IVA de abonos para el 303   QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud' ;


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
   // fieldgroup(Brick;"Code","Description")
   // {
       // 
   // }
}
  

    


/*
trigger OnInsert();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnModify();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnRename();    begin
               SetLastModifiedDateTime;
             end;

*/




/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified Date Time" := CURRENTDATETIME;
    end;

    /*begin
    end.
  */
}





