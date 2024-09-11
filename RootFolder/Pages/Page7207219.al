page 7207219 "QB BI SalesOrders by salespers"
{
SourceTable=37;
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
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Line No.";rec."Line No.")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("CurrenyDescription";Currency.Description)
    {
        
    }
    field("Currency_Code";SalesHeader."Currency Code")
    {
        
    }
    field("SalesPersonCode";SalespersonPurchaser.Code)
    {
        
    }
    field("SalesPersonName";SalespersonPurchaser.Name)
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF Currency.Code <> rec."Currency Code" THEN
                         IF NOT Currency.GET(rec."Currency Code") THEN CLEAR(Currency);

                       IF (rec."Document Type" <> SalesHeader."Document Type") OR (rec."Document No." <> SalesHeader."No.") THEN
                         IF NOT SalesHeader.GET(rec."Document Type", rec."Document No.") THEN CLEAR(SalesHeader);

                       IF SalesHeader."Salesperson Code" <> SalespersonPurchaser.Code THEN
                         IF NOT SalespersonPurchaser.GET(SalesHeader."Salesperson Code") THEN CLEAR(SalespersonPurchaser);
                     END;



    var
      Currency : Record 4;
      SalesHeader : Record 36;
      SalespersonPurchaser : Record 13;

    /*begin
    end.
  
*/
}







