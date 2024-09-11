tableextension 50194 "QBU Sales Comment Line ArchiveExt" extends "Sales Comment Line Archive"
{
  
  
    CaptionML=ENU='Sales Comment Line Archive',ESP='Archivo l¡nea comentario venta';
    LookupPageID="Purch. Comment List";
    DrillDownPageID="Purch. Comment List";
  
  fields
{
    field(7207271;"QBU User";Code[50])
    {
        TableRelation=User."User Name";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';
                                                   Description='QB 1.00 - QBA5412' ;


    }
}
  keys
{
   // key(key1;"Document Type","No.","Doc. No. Occurrence","Version No.","Document Line No.","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  

    
    
/*
procedure SetUpNewLine ()
    var
//       SalesCommentLine@1000 :
      SalesCommentLine: Record 5126;
    begin
      SalesCommentLine.SETRANGE("Document Type","Document Type");
      SalesCommentLine.SETRANGE("No.","No.");
      SalesCommentLine.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
      SalesCommentLine.SETRANGE("Version No.","Version No.");
      SalesCommentLine.SETRANGE("Document Line No.","Line No.");
      SalesCommentLine.SETRANGE(Date,WORKDATE);
      if not SalesCommentLine.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    //{
//      QBA5412 PGM 26/12/2018 - A¤adido campo nuevo.
//    }
    end.
  */
}





