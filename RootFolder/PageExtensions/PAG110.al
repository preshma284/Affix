pageextension 50110 MyExtension110 extends 110//92
{
layout
{
addafter("Payment Tolerance Credit Acc.")
{
    field("QB Confirming Account";rec."QB Confirming Account")
    {
        
                ToolTipML=ESP='Indica la cuenta de registro si la operaci¢n ha provenido de un confirming';
}
    field("QB Confirming Discount Acc.";rec."QB Confirming Discount Acc.")
    {
        
                ToolTipML=ESP='Indica la cuenta de registro si la operaci¢n ha provenido de un confirming al descuento';
}
    field("QB Confirming Collection Acc.";rec."QB Confirming Collection Acc.")
    {
        
                ToolTipML=ESP='Indica la cuenta de registro si la operaci¢n ha provenido de un confirming al cobro';
}
    field("QuoSII Type";rec."QuoSII Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Invoice Description";rec."QuoSII Invoice Description")
    {
        
                Visible=vQuoSII ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 ReminderTerms : Record 292;
               BEGIN
                 rec.SetAccountVisibility(PmtToleranceVisible,PmtDiscountVisible,InvRoundingVisible,ApplnRoundingVisible);
                 ReminderTerms.SetAccountVisibility(InterestAccountVisible,AddFeeAccountVisible,AddFeePerLineAccountVisible);
                 UpdateAccountVisibilityBasedOnFinChargeTerms(InterestAccountVisible,AddFeeAccountVisible);

                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;


//trigger

var
      PmtDiscountVisible : Boolean;
      PmtToleranceVisible : Boolean;
      InvRoundingVisible : Boolean;
      ApplnRoundingVisible : Boolean;
      InterestAccountVisible : Boolean;
      AddFeeAccountVisible : Boolean;
      AddFeePerLineAccountVisible : Boolean;
      ShowAllAccounts : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    
    

//procedure
Local procedure UpdateAccountVisibilityBasedOnFinChargeTerms(var InterestAccountVisible : Boolean;var AddFeeAccountVisible : Boolean);
   var
     FinanceChargeTerms : Record 5;
   begin
     FinanceChargeTerms.SETRANGE("Post Interest",TRUE);
     InterestAccountVisible := InterestAccountVisible or not FinanceChargeTerms.ISEMPTY;

     FinanceChargeTerms.SETRANGE("Post Interest");
     FinanceChargeTerms.SETRANGE("Post Additional Fee",TRUE);
     AddFeeAccountVisible := AddFeeAccountVisible or not FinanceChargeTerms.ISEMPTY;
   end;

//procedure
}

