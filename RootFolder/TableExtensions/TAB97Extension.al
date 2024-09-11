tableextension 50128 "MyExtension50128" extends "Comment Line"
{
  
  
    CaptionML=ENU='Comment Line',ESP='L¡n. comentario';
    LookupPageID="Comment List";
    DrillDownPageID="Comment List";
  
  fields
{
    field(7207271;"User";Code[50])
    {
        TableRelation=User."User Name";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';
                                                   Description='QBA5412' ;


    }
}
  keys
{
   // key(key1;"Table Name","No.","Line No.")
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
//       CommentLine@1000 :
      CommentLine: Record 97;
    begin
      CommentLine.SETRANGE("Table Name","Table Name");
      CommentLine.SETRANGE("No.","No.");
      CommentLine.SETRANGE(Date,WORKDATE);
      if not CommentLine.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    //{
//      QBA5412 PGM 26/12/2018 - A¤adido campo User
//    }
    end.
  */
}




