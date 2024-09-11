page 7207225 "QB BI Vendor Ledger Entries"
{
SourceTable=25;
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
    field("Vendor No.";rec."Vendor No.")
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
    field("Purchaser Code";rec."Purchaser Code")
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
    field("Original Amt. (LCY)";rec."Original Amt. (LCY)")
    {
        
    }
    field("Remaining Amt. (LCY)";rec."Remaining Amt. (LCY)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("Customer_Name";Vendor.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."Vendor No." <> Vendor."No." THEN
                         IF NOT Vendor.GET(rec."Vendor No.") THEN CLEAR(Vendor);
                     END;



    var
      Vendor : Record 23;

    /*begin
    end.
  
*/
}







