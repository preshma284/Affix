page 7207218 "QB BI Item Sales and Profit"
{
SourceTable=27;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Gen. Prod. Posting Group";rec."Gen. Prod. Posting Group")
    {
        
    }
    field("Item Disc. Group";rec."Item Disc. Group")
    {
        
    }
    field("Item Tracking Code";rec."Item Tracking Code")
    {
        
    }
    field("Profit %";rec."Profit %")
    {
        
    }
    field("Scrap %";rec."Scrap %")
    {
        
    }
    field("Sales Unit of Measure";rec."Sales Unit of Measure")
    {
        
    }
    field("Standard Cost";rec."Standard Cost")
    {
        
    }
    field("Unit Cost";rec."Unit Cost")
    {
        
    }
    field("Unit Price";rec."Unit Price")
    {
        
    }
    field("Unit Volume";rec."Unit Volume")
    {
        
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Purch. Unit of Measure";rec."Purch. Unit of Measure")
    {
        
    }
    field("COGS (LCY)";rec."COGS (LCY)")
    {
        
    }
    field("Inventory";rec."Inventory")
    {
        
    }
    field("Net Change";rec."Net Change")
    {
        
    }
    field("Net Invoiced Qty.";rec."Net Invoiced Qty.")
    {
        
    }
    field("Purchases (Qty.)";rec."Purchases (Qty.)")
    {
        
    }
    field("Sales (Qty.)";rec."Sales (Qty.)")
    {
        
    }
    field("Purchases (LCY)";rec."Purchases (LCY)")
    {
        
    }
    field("Sales (LCY)";rec."Sales (LCY)")
    {
        
    }
    field("VendorName";Vendor.Name)
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







