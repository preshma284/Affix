page 7207200 "QB BI Power BI Customer List"
{
SourceTable=379;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Customer_No";rec."Customer No.")
    {
        
    }
    field("Customer_Name";"Name")
    {
        
    }
    field("Credit_Limit";"CreditLimit")
    {
        
    }
    field("Balance_Due";"BalanceDue")
    {
        
    }
    field("Cust. Ledger Entry No.";rec."Cust. Ledger Entry No.")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Amount (LCY)";rec."Amount (LCY)")
    {
        
    }
    field("Transaction No.";rec."Transaction No.")
    {
        
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }

}

}
}
  


















trigger OnAfterGetRecord()    VAR
                       Customer : Record 18;
                     BEGIN
                       CLEAR(Name);
                       CLEAR(CreditLimit);
                       CLEAR(BalanceDue);

                       IF rec."Customer No." <> Customer."No." THEN BEGIN
                         IF Customer.GET(rec."Customer No.") THEN BEGIN
                           Name := Customer.Name;
                           CreditLimit := Customer."Credit Limit (LCY)";
                           Customer.CALCFIELDS("Balance Due");
                           BalanceDue := Customer."Balance Due";
                         END;
                       END;
                     END;



    var
      Name : Text[50];
      CreditLimit : Decimal;
      BalanceDue : Decimal;

    /*begin
    end.
  
*/
}







