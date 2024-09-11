pageextension 50232 MyExtension5628 extends 5628//81
{
layout
{
addafter("Account No.")
{
    field("QB_UsageSale";rec."Usage/Sale")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_PieceworkCode";rec."Piecework Code")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      GLSetup : Record 98;
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      ClientTypeManagement : Codeunit 50192; //change from 4
      ChangeExchangeRate : Page 511;
      GLReconcile : Page 345;
      CurrentJnlBatchName : Code[10];
      AccName : Text[50];
      BalAccountName : Text[50];
      Balance : Decimal;
      TotalBalance : Decimal;
      ShowBalance : Boolean;
      ShowTotalBalance : Boolean;
      AddCurrCodeIsFound : Boolean;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      ApplyEntriesActionEnabled : Boolean;
      BalanceVisible : Boolean ;
      TotalBalanceVisible : Boolean ;
      IsSaasExcelAddinEnabled : Boolean;

    
    

//procedure
//Local procedure UpdateBalance();
//    begin
//      GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
//      BalanceVisible := ShowBalance;
//      TotalBalanceVisible := ShowTotalBalance;
//    end;
//Local procedure EnableApplyEntriesAction();
//    begin
//      ApplyEntriesActionEnabled :=
//        (rec."Account Type" IN [rec."Account Type"::Customer,rec."Account Type"::Vendor]) or
//        (rec."Bal. Account Type" IN [rec."Bal. Account Type"::Customer,rec."Bal. Account Type"::Vendor]);
//    end;
//Local procedure GetAddCurrCode() : Code[10];
//    begin
//      if ( not AddCurrCodeIsFound  )then begin
//        AddCurrCodeIsFound := TRUE;
//        GLSetup.GET;
//      end;
//      exit(GLSetup."Additional Reporting Currency");
//    end;
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;

//procedure
}

