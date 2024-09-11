page 7207216 "QB BI Sales Dashboard"
{
SourceTable=32;
    SourceTableView=WHERE("Entry Type"=FILTER("Sale"));
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
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Entry Type";rec."Entry Type")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Sales Amount (Actual)";rec."Sales Amount (Actual)")
    {
        
    }
    field("Sales Amount (Expected)";rec."Sales Amount (Expected)")
    {
        
    }
    field("Cost Amount (Expected)";rec."Cost Amount (Expected)")
    {
        
    }
    field("Cost Amount (Actual)";rec."Cost Amount (Actual)")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("CountryRegionName";CountryRegion.Name)
    {
        
    }
    field("CustomerName";Customer.Name)
    {
        
    }
    field("Customer_Posting_Group";Customer."Customer Posting Group")
    {
        
    }
    field("Customer_Disc_Group";Customer."Customer Disc. Group")
    {
        
    }
    field("City";Customer.City)
    {
        
    }
    field("Description";Item.Description)
    {
        
    }
    field("SalesPersonName";SalespersonPurchaser.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF rec."Country/Region Code" <> CountryRegion.Code THEN
                         IF NOT CountryRegion.GET(rec."Country/Region Code") THEN CLEAR(CountryRegion);

                       IF rec."Source No." <> Customer."No." THEN
                         IF NOT Customer.GET(rec."Source No.") THEN CLEAR(Customer);

                       IF Customer."Salesperson Code" <> SalespersonPurchaser.Code THEN
                         IF NOT SalespersonPurchaser.GET(Customer."Salesperson Code") THEN CLEAR(SalespersonPurchaser);

                       IF rec."Item No." <> Item."No." THEN
                         IF NOT Item.GET(rec."Item No.") THEN CLEAR(Item);
                     END;



    var
      CountryRegion : Record 9;
      Customer : Record 18;
      Item : Record 27;
      SalespersonPurchaser : Record 13;

    /*begin
    end.
  
*/
}







