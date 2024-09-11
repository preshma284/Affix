tableextension 50183 "QBU Cash Flow Manual RevenueExt" extends "Cash Flow Manual Revenue"
{
  
  
    CaptionML=ENU='Cash Flow Manual Revenue',ESP='Ingresos manuales flujos efectivo';
    LookupPageID="Cash Flow Manual Revenues";
    DrillDownPageID="Cash Flow Manual Revenues";
  
  fields
{
    field(7207270;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Receivables CF Account No.',ESP='Proyecto';
                                                   Description='QB 1.09.22 - JAV 25/10/21 Proyecto asociado';


    }
    field(7207271;"QBU Bank Account No.";Code[20])
    {
        TableRelation="Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Receivables CF Account No.',ESP='Banco';
                                                   Description='QB 1.09.22 - JAV 25/10/21 Banco asociado' ;


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
}
  
    var
//       DimMgt@1002 :
      DimMgt: Codeunit 408;
//       RevTxt@1000 :
      RevTxt: 
// Abbreviation of Revenue, used as prefix for code (e.g. REV000001)
TextConst ENU='REV',ESP='ING';

    
    


/*
trigger OnInsert();    begin
               DimMgt.UpdateDefaultDim(
                 DATABASE::"Cash Flow Manual Revenue",Code,
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             end;


*/

/*
trigger OnDelete();    begin
               DimMgt.DeleteDefaultDim(DATABASE::"Cash Flow Manual Revenue",Code);
             end;


*/

/*
trigger OnRename();    begin
               DimMgt.RenameDefaultDim(DATABASE::"Cash Flow Manual Revenue",xRec.Code,Code);
             end;

*/



// procedure ValidateShortcutDimCode (FieldNo@1000 : Integer;var ShortcutDimCode@1001 :

/*
procedure ValidateShortcutDimCode (FieldNo: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNo,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::"Cash Flow Manual Expense",Code,FieldNo,ShortcutDimCode);
    end;
*/


    
    
/*
procedure InitNewRecord ()
    var
//       CashFlowManualRevenue@1002 :
      CashFlowManualRevenue: Record 849;
//       CashFlowAccount@1001 :
      CashFlowAccount: Record 841;
//       CashFlowCode@1000 :
      CashFlowCode: Code[10];
    begin
      CashFlowManualRevenue.SETFILTER(Code,'%1',RevTxt + '0*');
      if not CashFlowManualRevenue.FINDLAST then
        CashFlowCode := PADSTR(RevTxt,MAXSTRLEN(CashFlowManualRevenue.Code),'0')
      else
        CashFlowCode := CashFlowManualRevenue.Code;
      CashFlowCode := INCSTR(CashFlowCode);

      CashFlowAccount.SETRANGE("Source Type",CashFlowAccount."Source Type"::"Cash Flow Manual Revenue");
      if not CashFlowAccount.FINDFIRST then
        exit;

      Code := CashFlowCode;
      "Cash Flow Account No." := CashFlowAccount."No.";
      "Starting Date" := WORKDATE;
      "Ending Date" := 0D;
    end;

    /*begin
    end.
  */
}





