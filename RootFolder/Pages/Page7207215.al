page 7207215 "QB BI Top Customer Overview"
{
SourceTable=18;
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
    field("Name";rec."Name")
    {
        
    }
    field("Sales (LCY)";rec."Sales (LCY)")
    {
        
    }
    field("Profit (LCY)";rec."Profit (LCY)")
    {
        
    }
    field("Country/Region Code";rec."Country/Region Code")
    {
        
    }
    field("City";rec."City")
    {
        
    }
    field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
    {
        
    }
    field("Global Dimension 2 Code";rec."Global Dimension 2 Code")
    {
        
    }
    field("SalesPersonName";SalesPersonPurchaser.Name)
    {
        
    }
    field("CountryRegionName";CountryRegion.Name)
    {
        
    }

}

}
}
  
trigger OnAfterGetRecord()    BEGIN
                       IF rec."Salesperson Code" <> SalesPersonPurchaser.Code THEN BEGIN
                         CLEAR(SalesPersonPurchaser);
                         IF SalesPersonPurchaser.GET(rec."Salesperson Code") THEN;
                       END;

                       IF rec."Country/Region Code" <> CountryRegion.Code THEN BEGIN
                         CLEAR(CountryRegion);
                         IF CountryRegion.GET(rec."Country/Region Code") THEN;
                       END;
                     END;



    var
      SalesPersonPurchaser : Record 13;
      CountryRegion : Record 9;

    /*begin
    end.
  
*/
}







