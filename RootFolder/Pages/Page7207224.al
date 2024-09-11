page 7207224 "QB BI Cust. Ledger Entries"
{
SourceTable=21;
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
    field("Customer No.";rec."Customer No.")
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
    field("Due Date";rec."Due Date")
    {
        
    }
    field("Pmt. Discount Date";rec."Pmt. Discount Date")
    {
        
    }
    field("Document Date";rec."Document Date")
    {
        
    }
    field("Salesperson Code";rec."Salesperson Code")
    {
        
    }
    field("Source Code";rec."Source Code")
    {
        
    }
    field("Reason Code";rec."Reason Code")
    {
        
    }
    field("IC Partner Code";rec."IC Partner Code")
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
    field("QB WIP Remaining Amount";rec."QB WIP Remaining Amount")
    {
        
    }
    field("QB WIP Remaining Amt. (LCY)";rec."QB WIP Remaining Amt. (LCY)")
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
    field("Original Amt. (LCY)";rec."Original Amt. (LCY)")
    {
        
    }
    field("Remaining Amt. (LCY)";rec."Remaining Amt. (LCY)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("Customer_Name";Customer.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."Customer No." <> Customer."No." THEN
                         IF NOT Customer.GET(rec."Customer No.") THEN CLEAR(Customer);
                     END;



    var
      Customer : Record 18;

    /*begin
    end.
  
*/
}







