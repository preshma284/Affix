pageextension 50111 MyExtension111 extends 111//93
{
layout
{
addafter("Payment Tolerance Credit Acc.")
{
    field("QB_AcctPurchRcptPendingInv";rec."Acct. Purch. Rcpt Pending Inv.")
    {
        
}
    field("QB Confirming Account";rec."QB Confirming Account")
    {
        
                ToolTipML=ESP='Indica la cuenta de registro si la operaci¢n ha provenido de un confirming';
}
    field("QuoSII Type";rec."QuoSII Type")
    {
        
                Visible=vQuoSII ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 rec.SetAccountVisibility(PmtToleranceVisible,PmtDiscountVisible,InvRoundingVisible,ApplnRoundingVisible);

                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;


//trigger

var
      PmtDiscountVisible : Boolean;
      PmtToleranceVisible : Boolean;
      InvRoundingVisible : Boolean;
      ApplnRoundingVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    

//procedure

//procedure
}

