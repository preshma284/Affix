page 7207226 "QB BI Bank Acc. Ledger Entries"
{
SourceTable=271;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Transaction No.";rec."Transaction No.")
    {
        
    }
    field("Bank Account No.";rec."Bank Account No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Document Date";rec."Document Date")
    {
        
    }
    field("Source Code";rec."Source Code")
    {
        
    }
    field("Reason Code";rec."Reason Code")
    {
        
    }
    field("Open";rec."Open")
    {
        
    }
    field("Currency Code";rec."Currency Code")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Debit Amount";rec."Debit Amount")
    {
        
    }
    field("Credit Amount";rec."Credit Amount")
    {
        
    }
    field("Remaining Amount";rec."Remaining Amount")
    {
        
    }
    field("Amount (LCY)";rec."Amount (LCY)")
    {
        
    }
    field("Debit Amount (LCY)";rec."Debit Amount (LCY)")
    {
        
    }
    field("Credit Amount (LCY)";rec."Credit Amount (LCY)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("Customer_Name";BankAccount.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."Bank Account No." <> BankAccount."No." THEN
                         IF NOT BankAccount.GET(rec."Bank Account No.") THEN CLEAR(BankAccount);
                     END;



    var
      BankAccount : Record 270;

    /*begin
    end.
  
*/
}







