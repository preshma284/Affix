tableextension 50198 "QBU FA AllocationExt" extends "FA Allocation"
{
  
  
    CaptionML=ENU='FA Allocation',ESP='A/F Distribuci¢n';
    LookupPageID="FA Allocations";
    DrillDownPageID="FA Allocations";
  
  fields
{
    field(7207270;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(7207271;"QBU Piecework Code";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Piecework Code',ESP='C¢d. unidad de obra'; ;


    }
}
  keys
{
   // key(key1;"Code","Allocation Type","Line No.")
  //  {
       /* //SumIndexFields=""Allocation %""
                                                   Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot rename a %1.',ESP='No se puede cambiar el nombre a %1.';
//       GLAcc@1001 :
      GLAcc: Record 15;
//       DimMgt@1003 :
      DimMgt: Codeunit 408;

    
    


/*
trigger OnInsert();    begin
               "Dimension Set ID" := 0;
               "Global Dimension 1 Code" := '';
               "Global Dimension 2 Code" := '';
             end;


*/

/*
trigger OnRename();    begin
               ERROR(Text000,TABLECAPTION);
             end;

*/



// procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',Code,"Allocation Type","Line No."),
          "Global Dimension 1 Code","Global Dimension 2 Code");
    end;

    /*begin
    end.
  */
}





