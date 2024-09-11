pageextension 50280 MyExtension841 extends 841//846
{
layout
{
addafter("Amount (LCY)")
{
    field("Job No.";rec."Job No.")
    {
        
}
    field("Piecework Code";rec."Piecework Code")
    {
        
}
    field("Payment Method Code";rec."Payment Method Code")
    {
        
}
    field("Payment Terms Code";rec."Payment Terms Code")
    {
        
}
    field("Document Situation";rec."Document Situation")
    {
        
                Editable=false ;
}
    field("Bank Account";rec."Bank Account")
    {
        
}
    field("Currency Code";rec."Currency Code")
    {
        
}
    field("Amount";rec."Amount")
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
      SuggestWkshLines : Report 840;
      CashFlowManagement : Codeunit 841;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      CFName : Text[50];
      CFAccName : Text[50];
      SourceNumEnabled : Boolean;
      IsSaasExcelAddinEnabled : Boolean;

    
    

//procedure
//Local procedure ShowErrors();
//    var
//      CashFlowSetup : Record 843;
//      ErrorMessage : Record 700;
//      TempErrorMessage : Record 700 TEMPORARY ;
//    begin
//      if ( CashFlowSetup.GET  )then begin
//        ErrorMessage.SETRANGE("Context Record ID",CashFlowSetup.RECORDID);
//        ErrorMessage.CopyToTemp(TempErrorMessage);
//        CurrPage.ErrorMessagesPart.PAGE.SetRecords(TempErrorMessage);
//        CurrPage.ErrorMessagesPart.PAGE.UPDATE;
//      end;
//    end;
//Local procedure DeleteErrors();
//    var
//      CashFlowSetup : Record 843;
//      ErrorMessage : Record 700;
//    begin
//      if ( CashFlowSetup.GET  )then begin
//        ErrorMessage.SETRANGE("Context Record ID",CashFlowSetup.RECORDID);
//        if ( ErrorMessage.FINDFIRST  )then
//          ErrorMessage.DELETEALL(TRUE);
//        COMMIT;
//      end;
//    end;

//procedure
}

