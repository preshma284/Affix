page 7207209 "QB BI Sales Hdr. Cust."
{
SourceTable=37;
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
    field("Qty_Shipped_Base";rec."Qty. Shipped (Base)")
    {
        
    }
    field("Qty_Invoiced_Base";rec."Qty. Invoiced (Base)")
    {
        
    }
    field("<Base_Unit_of_Measure>";Item."Base Unit of Measure")
    {
        
    }
    field("<Description>";Item.Description)
    {
        
    }
    field("<Inventory>";Item.Inventory)
    {
        
    }
    field("<Unit_Price>";Item."Unit Price")
    {
        
    }
    field("Customer_No";Customer."No.")
    {
        
    }
    field("<Name>";Customer.Name)
    {
        
    }
    field("<Balance>";Customer.Balance)
    {
        
    }
    field("<Country_Region_Code>";Customer."Country/Region Code")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF Item."No." <> rec."No." THEN BEGIN
                         CLEAR(Item);
                         IF Item.GET(rec."No.") THEN BEGIN
                           Item.CALCFIELDS(Inventory);
                           Item.CALCFIELDS("Qty. on Prod. Order");
                         END;
                       END;

                       IF Customer."No." <> rec."Sell-to Customer No." THEN BEGIN
                         CLEAR(Customer);
                         IF Customer.GET(rec."Sell-to Customer No.") THEN
                           Customer.CALCFIELDS(Balance);
                       END;
                     END;



    var
      Item : Record 27;
      Customer : Record 18;

    /*begin
    end.
  
*/
}







