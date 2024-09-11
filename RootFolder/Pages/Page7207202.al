page 7207202 "QB BI Power BI Item Purch.List"
{
SourceTable=32;
    SourceTableView=SORTING("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date")
                    WHERE("Entry Type"=FILTER("Purchase"));
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Item No.";rec."Item No.")
    {
        
    }
    field("Search_Description";SearchDescription)
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       CLEAR(SearchDescription);

                       IF Item."No." <> rec."Item No." THEN BEGIN
                         IF Item.GET(rec."Item No.") THEN
                           SearchDescription := Item."Search Description";
                       END;
                     END;



    var
      SearchDescription : Text[50];
      Item : Record 27;

    /*begin
    end.
  
*/
}







