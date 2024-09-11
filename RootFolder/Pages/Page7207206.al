page 7207206 "QB BI Power BI Item Sales List"
{
SourceTable=5802;
    SourceTableView=SORTING("Item Ledger Entry No.","Entry Type")
                    WHERE("Item Ledger Entry Type"=FILTER("Sale"));
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Item_No";Item."No.")
    {
        
    }
    field("Search_Description";Item."Search Description")
    {
        
    }
    field("Sales_Entry_No";rec."Entry No.")
    {
        
    }
    field("Sales_Post_Date";rec."Posting Date")
    {
        
    }
    field("Sold_Quantity";rec."Invoiced Quantity")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       IF (Item."No." <> rec."Item No.") THEN BEGIN
                         CLEAR(Item);
                         IF Item.GET(rec."Item Ledger Entry No.") THEN;
                       END;
                     END;



    var
      Item : Record 27;

    /*begin
    end.
  
*/
}







