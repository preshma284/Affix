pageextension 50166 MyExtension283 extends 283//81
{
layout
{
addafter("Description")
{
    field("QB_UsageSale";rec."Usage/Sale")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_PieceworkCode";rec."Piecework Code")
    {
        
                Visible=FALSE ;
}
}

}

actions
{


}

//trigger

//trigger

var
      GenJnlAlloc : Record 221;
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      ChangeExchangeRate : Page 511;
      CurrentJnlBatchName : Code[10];
      AccName : Text[50];
      BalAccName : Text[50];
      Balance : Decimal;
      TotalBalance : Decimal;
      ShowBalance : Boolean;
      ShowTotalBalance : Boolean;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      BalanceVisible : Boolean ;
      TotalBalanceVisible : Boolean ;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;

    
    

//procedure
//Local procedure UpdateBalance();
//    begin
//      GenJnlManagement.CalcBalance(
//        Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
//      BalanceVisible := ShowBalance;
//      TotalBalanceVisible := ShowTotalBalance;
//    end;
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure SetConrolVisibility();
//    var
//      GLSetup : Record 98;
//    begin
//      GLSetup.GET;
//      AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
//      DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
//    end;

//procedure
}

