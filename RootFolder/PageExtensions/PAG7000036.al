pageextension 50266 MyExtension7000036 extends 7000036//81
{
layout
{
addafter("Description")
{
    field("QB_JobNo";rec."Job No.")
    {
        
                Visible=false ;
}
    field("QB_PaymentBankNo";rec."QB Payment Bank No.")
    {
        
}
    field("QB_PaymentBankName";FunctionQB.GetBankName(rec."QB Payment Bank No."))
    {
        
                CaptionML=ENU='Own Bank Name',ESP='Nombre del banco propio';
                Enabled=false ;
}
}

}

actions
{


}

//trigger

//trigger

var
      Text1100000 : TextConst ENU='Please, post the journal lines. Otherwise, inconsistencies can appear in your data.',ESP='Registre las l¡neas del Diario. Si no, podr¡an aparecer incoherencias entre los datos.';
      GLReconcile : Page 345;
      ChangeExchangeRate : Page 511;
      GenJnlManagement : Codeunit 230;
      ReportPrint : Codeunit 228;
      CurrentJnlBatchName : Code[10];
      PassedCurrentJnlBatchName : Code[10];
      AccName : Text[50];
      BalAccName : Text[50];
      Balance : Decimal;
      TotalBalance : Decimal;
      ShowBalance : Boolean;
      ShowTotalBalance : Boolean;
      ClosingForbidden : Boolean;
      PostOk : Boolean;
      OpenedFromBatch : Boolean;
      BalanceVisible : Boolean ;
      TotalBalanceVisible : Boolean ;
      "---------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;

    
    

//procedure
//Local procedure UpdateBalance();
//    begin
//      GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
//      BalanceVisible := ShowBalance;
//      TotalBalanceVisible := ShowTotalBalance;
//    end;
//
//    //[External]
//procedure SetJnlBatchName(NewJnlBatchName : Code[10]);
//    begin
//      PassedCurrentJnlBatchName := NewJnlBatchName;
//    end;
//
//    //[External]
//procedure AllowClosing(FromBatch : Boolean);
//    begin
//      ClosingForbidden := FromBatch;
//    end;
//Local procedure CurrentJnlBatchNameOnAfterVali();
//    begin
//      CurrPage.SAVERECORD;
//      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure AfterGetCurrentRecord();
//    begin
//      xRec := Rec;
//      GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
//      UpdateBalance;
//    end;

//procedure
}

