pageextension 50236 MyExtension574 extends 574//380
{
layout
{
addafter("Initial Entry Due Date")
{
    field("QB Original Due Date";rec."QB Original Due Date")
    {
        
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 FunctionQB : Codeunit 7207272;
               BEGIN
                 SetConrolVisibility;

                 //CPA 03/02/22: - Q16275 - Permisos.Begin
                 FunctionQB.SetUserJobDetailedVendorLedgerEntriesFilter(Rec);
                 //CPA 03/02/22: - Q16275 - Permisos.End
               END;


//trigger

var
      Navigate : Page 344;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;

    
    

//procedure
Local procedure SetConrolVisibility();
   var
     GLSetup : Record 98;
   begin
     GLSetup.GET;
     AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
     DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
   end;

//procedure
}

