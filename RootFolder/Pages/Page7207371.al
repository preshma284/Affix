page 7207371 "Price Cost Database List"
{
CaptionML=ENU='Price Cost Database List',ESP='Lista Precios preciario';
    SourceTable=7207284;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Piecework";rec."Piecework")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Quantity";rec."Quantity")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Price Cost";rec."Price Cost")
    {
        
    }
    field("Price Sale";rec."Price Sale")
    {
        
    }
    field("Budget Cost Amount";rec."Budget Cost Amount")
    {
        
    }
    field("Budget Sale Amount";rec."Budget Sale Amount")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}







