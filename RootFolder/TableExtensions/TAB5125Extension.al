tableextension 50193 "MyExtension50193" extends "Purch. Comment Line Archive"
{
  
  
    CaptionML=ENU='Purch. Comment Line Archive',ESP='Archivo de l¡nea de comentario de compra';
    LookupPageID="Purch. Comment List";
    DrillDownPageID="Purch. Comment List";
  
  fields
{
    field(7207271;"User";Code[50])
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
//       PurchCommentLine@1000 :
      PurchCommentLine: Record 5125;
    begin
      PurchCommentLine.SETRANGE("Document Type","Document Type");
      PurchCommentLine.SETRANGE("No.","No.");
      PurchCommentLine.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
      PurchCommentLine.SETRANGE("Version No.","Version No.");
      PurchCommentLine.SETRANGE("Document Line No.","Line No.");
      PurchCommentLine.SETRANGE(Date,WORKDATE);
      if not PurchCommentLine.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    //{
//      QBA PGM 26/12/2018 - A¤adido campo nuevo User
//    }
    end.
  */
}




