page 7207205 "QB BI Power BI Sales List"
{
SourceTable=37;
    SourceTableView=SORTING("Document Type","Document No.","Line No.");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Document_No";SalesHeader."No.")
    {
        
    }
    field("Requested_Delivery_Date";SalesHeader."Requested Delivery Date")
    {
        
    }
    field("Shipment_Date";SalesHeader."Shipment Date")
    {
        
    }
    field("Due_Date";SalesHeader."Due Date")
    {
        
    }
    field("Item_No";rec."No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    VAR
                       GLAccount : Record 15;
                     BEGIN
                       IF (SalesHeader."Document Type" <> rec."Document Type") AND (SalesHeader."No." <> rec."Document No.") THEN BEGIN
                         CLEAR(SalesHeader);
                         IF SalesHeader.GET(rec."Document Type", rec."Document No.") THEN;
                       END;
                     END;



    var
      SalesHeader : Record 36;

    /*begin
    end.
  
*/
}







