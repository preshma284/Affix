pageextension 50183 MyExtension380 extends 380//274
{
layout
{
addafter("Description")
{
    field("Description 2";rec."Description 2")
    {
        
}
    field("Concepto Interbancario";rec."Concepto Interbancario")
    {
        
}
    field("Descripcion conc. interbanc.";rec."Descripcion conc. interbanc.")
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
      BankAccRecon : Record 273;
      StyleTxt : Text;
      TotalDiff : Decimal;
      Balance : Decimal;
      TotalBalance : Decimal;
      TotalDiffEnable : Boolean ;
      TotalBalanceEnable : Boolean ;
      BalanceEnable : Boolean ;
      ApplyEntriesAllowed : Boolean;

    
    

//procedure
//Local procedure CalcBalance(BankAccReconLineNo : Integer);
//    var
//      TempBankAccReconLine : Record 274;
//    begin
//      if ( BankAccRecon.GET(rec."Statement Type",rec."Bank Account No.",rec."Statement No.")  )then;
//
//      TempBankAccReconLine.COPY(Rec);
//
//      TotalDiff := -rec."Difference";
//      if ( TempBankAccReconLine.CALCSUMS(rec."Difference")  )then begin
//        TotalDiff := TotalDiff + TempBankAccReconLine.Difference;
//        TotalDiffEnable := TRUE;
//      end ELSE
//        TotalDiffEnable := FALSE;
//
//      TotalBalance := BankAccRecon."Balance Last Statement" - rec."Statement Amount";
//      if ( TempBankAccReconLine.CALCSUMS(rec."Statement Amount")  )then begin
//        TotalBalance := TotalBalance + TempBankAccReconLine."Statement Amount";
//        TotalBalanceEnable := TRUE;
//      end ELSE
//        TotalBalanceEnable := FALSE;
//
//      Balance := BankAccRecon."Balance Last Statement" - rec."Statement Amount";
//      TempBankAccReconLine.SETRANGE("Statement Line No.",0,BankAccReconLineNo);
//      if ( TempBankAccReconLine.CALCSUMS(rec."Statement Amount")  )then begin
//        Balance := Balance + TempBankAccReconLine."Statement Amount";
//        BalanceEnable := TRUE;
//      end ELSE
//        BalanceEnable := FALSE;
//    end;
//Local procedure ApplyEntries();
//    var
//      BankAccReconApplyEntries : Codeunit 374;
//    begin
//      rec."Ready for Application" := TRUE;
//      CurrPage.SAVERECORD;
//      COMMIT;
//      BankAccReconApplyEntries.ApplyEntries(Rec);
//    end;
//
//    //[External]
//procedure GetSelectedRecords(var TempBankAccReconciliationLine : Record 274 TEMPORARY );
//    var
//      BankAccReconciliationLine : Record 274;
//    begin
//      CurrPage.SETSELECTIONFILTER(BankAccReconciliationLine);
//      if ( BankAccReconciliationLine.FINDSET  )then
//        repeat
//          TempBankAccReconciliationLine := BankAccReconciliationLine;
//          TempBankAccReconciliationLine.INSERT;
//        until BankAccReconciliationLine.NEXT = 0;
//    end;
//Local procedure SetUserInteractions();
//    begin
//      StyleTxt := rec.GetStyle;
//      ApplyEntriesAllowed := rec."Type" = rec."Type"::"Check Ledger Entry";
//    end;
//
//    //[External]
//procedure ToggleMatchedFilter(SetFilterOn : Boolean);
//    begin
//      if ( SetFilterOn  )then
//        Rec.SETFILTER("Difference",'<>%1',0)
//      ELSE
//        Rec.RESET;
//      CurrPage.UPDATE;
//    end;

//procedure
}

