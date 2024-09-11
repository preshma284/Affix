tableextension 50851 "MyExtension50851" extends "Posted Approval Entry"
{
  
  
    CaptionML=ENU='Posted Approval Entry',ESP='Mov. aprobaci¢n registrado';
  
  fields
{
    field(7207271;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Proyecto/Departamento';
                                                   Description='QB 1.00 - JAV 09/09/19: - Para conocer el proyecto o el departamento de origen de la aprobaci¢n';
                                                   Editable=false;


    }
    field(7238210;"QB_Piecework No.";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢d. U.O./Partida Pres.';
                                                   Description='QB 1.10.22 JAV 02/03/22: - QRE15411  JAV 03/11/22 QB 1.12.12 Se cambia el caption' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       UserMgt@1000 :
      UserMgt: Codeunit 418;

    
    


/*
trigger OnDelete();    var
//                PostedApprovalCommentLine@1000 :
               PostedApprovalCommentLine: Record 457;
             begin
               PostedApprovalCommentLine.SETRANGE("Posted Record ID","Posted Record ID");
               PostedApprovalCommentLine.DELETEALL;
             end;

*/




/*
procedure ShowRecord ()
    var
//       PageManagement@1001 :
      PageManagement: Codeunit 700;
//       RecRef@1000 :
      RecRef: RecordRef;
    begin
      if not RecRef.GET("Posted Record ID") then
        exit;
      RecRef.SETRECFILTER;
      PageManagement.PageRun(RecRef);
    end;

    /*begin
    //{
//      BS::21834 CSM 20/05/24 Í Falta proyecto y partida aprobaci¢n en mov retenci¢n.  New Fields 72xxxxxx
//    }
    end.
  */
}




