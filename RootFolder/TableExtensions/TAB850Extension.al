tableextension 50184 "MyExtension50184" extends "Cash Flow Manual Expense"
{
  
  
    CaptionML=ENU='Cash Flow Manual Expense',ESP='Gastos manuales flujos efectivo';
    LookupPageID="Cash Flow Manual Expenses";
    DrillDownPageID="Cash Flow Manual Expenses";
  
  fields
{
    field(7207270;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Receivables CF Account No.',ESP='Proyecto';
                                                   Description='QB 1.09.22 - JAV 25/10/21 Proyecto asociado';


    }
    field(7207271;"Bank Account No.";Code[20])
    {
        TableRelation="Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Receivables CF Account No.',ESP='Banco';
                                                   Description='QB 1.09.22 - JAV 25/10/21 Banco asociado';


    }
    field(7207272;"Payroll";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N¢mina';
                                                   Description='QB 1.09.22 - JAV 25/10/21 Si es la n¢mina del proyecto' ;


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
//       ExpTxt@1000 :
      ExpTxt: 
// Abbreviation of Expense, used as prefix for code (e.g. EXP000001)
TextConst ENU='EXP',ESP='GAS';

    
    


/*
trigger OnInsert();    begin
               DimMgt.UpdateDefaultDim(
                 DATABASE::"Cash Flow Manual Expense",Code,
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             end;


*/

/*
trigger OnDelete();    begin
               DimMgt.DeleteDefaultDim(DATABASE::"Cash Flow Manual Expense",Code);
             end;


*/

/*
trigger OnRename();    begin
               DimMgt.RenameDefaultDim(DATABASE::"Cash Flow Manual Expense",xRec.Code,Code);
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
//       CashFlowManualExpense@1002 :
      CashFlowManualExpense: Record 850;
//       CashFlowAccount@1001 :
      CashFlowAccount: Record 841;
//       CashFlowCode@1000 :
      CashFlowCode: Code[10];
    begin
      CashFlowManualExpense.SETFILTER(Code,'%1',ExpTxt + '0*');
      if not CashFlowManualExpense.FINDLAST then
        CashFlowCode := PADSTR(ExpTxt,MAXSTRLEN(CashFlowManualExpense.Code),'0')
      else
        CashFlowCode := CashFlowManualExpense.Code;
      CashFlowCode := INCSTR(CashFlowCode);

      CashFlowAccount.SETRANGE("Source Type",CashFlowAccount."Source Type"::"Cash Flow Manual Expense");
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




