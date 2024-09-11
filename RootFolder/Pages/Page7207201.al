page 7207201 "QB BI Power BI Vendor List"
{
SourceTable=380;
    SourceTableView=SORTING("Vendor No.","Currency Code","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Initial Entry Due Date","Posting Date");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Vendor_No";rec."Vendor No.")
    {
        
    }
    field("Vendor_Name";"Name")
    {
        
    }
    field("Balance_Due";"BalanceDue")
    {
        
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
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
    field("Applied Vend. Ledger Entry No.";rec."Applied Vend. Ledger Entry No.")
    {
        
    }
    field("Remaining Pmt. Disc. Possible";rec."Remaining Pmt. Disc. Possible")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    VAR
                       Vendor : Record 23;
                     BEGIN
                       CLEAR(Name);
                       CLEAR(BalanceDue);

                       IF rec."Vendor No." <> Vendor."No." THEN BEGIN
                         IF Vendor.GET(rec."Vendor No.") THEN BEGIN
                           Name := Vendor.Name;
                           Vendor.CALCFIELDS("Balance Due");
                           BalanceDue := Vendor."Balance Due";
                         END;
                       END;
                     END;



    var
      Name : Text[50];
      BalanceDue : Decimal;

    /*begin
    end.
  
*/
}







