page 7207214 "QB BI Vendor Item Ledger Entr."
{
SourceTable=32;
    SourceTableView=SORTING("Item No.")
                    WHERE("Source Type"=FILTER("Vendor"));
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Item_No";rec."Item No.")
    {
        
    }
    field("false";rec."Source No.")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }

}

}
}
  
    var
      Customer : Record 18;

    /*begin
    end.
  
*/
}







