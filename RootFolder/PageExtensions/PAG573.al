pageextension 50235 MyExtension573 extends 573//379
{
layout
{
addafter("Cust. Ledger Entry No.")
{
    field("QB_JobNo";rec."QB Job No.")
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
      Navigate : Page 344;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;

    
    

//procedure
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

