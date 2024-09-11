page 7207213 "QB BI Sales Hdr. Vendor"
{
SourceTable=39;
    SourceTableView=SORTING("Document Type","Document No.","Line No.")
                    WHERE("Type"=FILTER("Item"));
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("false";rec."Document No.")
    {
        
    }
    field("Item_No";rec."No.")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Base_Unit_of_Measure";Item."Base Unit of Measure")
    {
        
    }
    field("Description";Item.Description)
    {
        
    }
    field("Inventory";Item.Inventory)
    {
        
    }
    field("Unit_Price";Item."Unit Price")
    {
        
    }
    field("Qty_on_Purch_Order";Item."Qty. on Purch. Order")
    {
        
    }
    field("Vendor_No";Vendor."No.")
    {
        
    }
    field("Name";Vendor.Name)
    {
        
    }
    field("Balance";Vendor.Balance)
    {
        
    }
    field("Country_Region_Code";Vendor."Country/Region Code")
    {
        
    }

}

}
}
  


trigger OnAfterGetRecord()    BEGIN
                       IF Item."No." <> rec."No." THEN BEGIN
                         CLEAR(Item);
                         IF Item.GET(rec."No.") THEN
                           Item.CALCFIELDS(Inventory);
                       END;

                       IF Vendor."No." <> rec."Buy-from Vendor No." THEN BEGIN
                         CLEAR(Vendor);
                         IF Vendor.GET(rec."Buy-from Vendor No.") THEN
                           Vendor.CALCFIELDS(Balance);
                       END;
                     END;



    var
      Item : Record 27;
      Vendor : Record 23;

    /*begin
    end.
  
*/
}







