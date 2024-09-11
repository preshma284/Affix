tableextension 50179 "MyExtension50179" extends "Cash Flow Account"
{
  
  DataCaptionFields="No.","Name";
    CaptionML=ENU='Cash Flow Account',ESP='Cuenta flujos efectivo';
    LookupPageID="Cash Flow Account List";
    DrillDownPageID="Cash Flow Account List";
  
  fields
{
    field(7207270;"QB Payment Bank Filter";Code[250])
    {
        TableRelation="Bank Account";
                                                   ValidateTableRelation=false;
                                                   //TestTableRelation=false;
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Bank Filter',ESP='Filtro bando de pago';
                                                   Description='Q7812' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Search Name")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Name","Account Type","Amount")
   // {
       // 
   // }
}
  
    var
//       MoveEntries@1008 :
      MoveEntries: Codeunit 361;

    


/*
trigger OnInsert();    begin
               if Indentation < 0 then
                 Indentation := 0;
             end;


*/

/*
trigger OnModify();    begin
               "Last Date Modified" := TODAY;

               if Indentation < 0 then
                 Indentation := 0;
             end;


*/

/*
trigger OnDelete();    var
//                CommentLine@1000 :
               CommentLine: Record 97;
             begin
               MoveEntries.MoveCashFlowEntries(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"G/L Account");
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;
             end;


*/

/*
trigger OnRename();    begin
               "Last Date Modified" := TODAY;
             end;

*/



/*begin
    end.
  */
}




