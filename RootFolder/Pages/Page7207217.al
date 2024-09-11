page 7207217 "QB BI Item Sales By Customer"
{
SourceTable=5802;
    SourceTableView=WHERE("Source Type"=FILTER("Customer"),"Item Ledger Entry No."=FILTER(<>0),"Document Type"=FILTER("Sales Invoice"));
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
    field("Item No.";rec."Item No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Item Ledger Entry Quantity";rec."Item Ledger Entry Quantity")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("CustomerNo";Customer."No.")
    {
        
    }
    field("Name";Customer.Name)
    {
        
    }
    field("Description";Item.Description)
    {
        
    }
    field("Gen_Prod_Posting_Group";Item."Gen. Prod. Posting Group")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN

                       IF rec."Source No." <> Customer."No." THEN
                         IF NOT Customer.GET(rec."Source No.") THEN CLEAR(Customer);

                       IF rec."Item No." <> Item."No." THEN
                         IF NOT Item.GET(rec."Item No.") THEN CLEAR(Item);
                     END;



    var
      Customer : Record 18;
      Item : Record 27;

    /*begin
    end.
  
*/
}







