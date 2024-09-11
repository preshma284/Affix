tableextension 50171 "MyExtension50171" extends "VAT Product Posting Group"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='VAT Product Posting Group',ESP='Grupo registro IVA producto';
    LookupPageID="VAT Product Posting Groups";
    DrillDownPageID="VAT Product Posting Groups";
  
  fields
{
    field(7174334;"QFA Code Tax Type";Option)
    {
        OptionMembers=" ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Code Tax Type',ESP='eFactura Tipo Impuesto';
                                                   OptionCaptionML=ENU='" ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29"',ESP='" ,01 IVA,02 IPSI,03 IGIC,04 IRPF,05 Otro,06 ITPAJD,07 IE: Impuestos especiales,08 Ra: Renta aduanas,09 IGTECM,10 IECDPCAC,11 IIIMAB,12 ICIO,13 IMVDN,14 IMSN,15 IMGSN,16 IMPN,17 REIVA,18 REIGIC,19 REIPSI,20 IPS,21 RLEA,22 IVPEE,23 Impuesto sobre la producción de combustible nuclear gastado y residuos radiactivos resultantes de la generación de energía nucleoeléctrica,24 Impuesto sobre el almacenamiento de combustible nuclear gastado y residuos radioactivos en instalaciones centralizadas,25 IDEC: Impuesto sobre los Depósitos en las Entidades de Crédito,26 Impuesto sobre las labores del tabaco en la Comunidad Autónoma de Canarias,27 IGFEI,28 IRNR,29 Impuesto sobre Sociedades"';
                                                   
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
   // fieldgroup(Brick;"Description")
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
      "Last Modified DateTime" := CURRENTDATETIME;
    end;

    /*begin
    end.
  */
}




