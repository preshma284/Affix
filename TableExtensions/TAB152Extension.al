tableextension 50143 "QBU Resource GroupExt" extends "Resource Group"
{
  
  DataCaptionFields="No.","Name";
    CaptionML=ENU='Resource Group',ESP='Familia recurso';
    LookupPageID="Resource Groups";
    DrillDownPageID="Resource Groups";
  
  fields
{
    field(7207270;"QBU Cod. C.A. Indirect Cost";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Cod. C.A. Indirect Cost',ESP='C¢d. C.A. costes indirectos';
                                                   Description='QB 1.00 - QB271';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000001 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Cod. C.A. Indirect Cost", FALSE);
                                                            END;


    }
    field(7207272;"QBU Cod. C.A. Direct Cost";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. C.A. Indirect Cost',ESP='C¢d. C.A. costes directos';
                                                   Description='QB 1.00 - QB271' ;

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Cod. C.A. Direct Cost", FALSE);
                                                            END;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       ResCapacityEntry@1000 :
      ResCapacityEntry: Record 160;
//       ResCost@1001 :
      ResCost: Record 202;
//       ResPrice@1002 :
      ResPrice: Record 201;
//       CommentLine@1003 :
      CommentLine: Record 97;
//       DimMgt@1004 :
      DimMgt: Codeunit 408;

    
    


/*
trigger OnInsert();    begin
               DimMgt.UpdateDefaultDim(
                 DATABASE::"Resource Group","No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             end;


*/

/*
trigger OnDelete();    begin
               ResCapacityEntry.SETCURRENTKEY("Resource Group No.");
               ResCapacityEntry.SETRANGE("Resource Group No.","No.");
               ResCapacityEntry.DELETEALL;

               ResCost.SETRANGE(Type,ResCost.Type::"Group(Resource)");
               ResCost.SETRANGE(Code,"No.");
               ResCost.DELETEALL;

               ResPrice.SETRANGE(Type,ResPrice.Type::"Group(Resource)");
               ResPrice.SETRANGE(Code,"No.");
               ResPrice.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"Resource Group");
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::"Resource Group","No.");
             end;


*/

/*
trigger OnRename();    begin
               DimMgt.RenameDefaultDim(DATABASE::"Resource Group",xRec."No.","No.");
             end;

*/



// procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::"Resource Group","No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    end;

    /*begin
    end.
  */
}





