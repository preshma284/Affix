page 7207446 "LM Rental Element"
{
CaptionML=ENU='LM Rental Element',ESP='LM elemento alquiler';
    SourceTable=7207347;
    PopulateAllFields=true;
    PageType=List;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Variant Code";rec."Variant Code")
    {
        
    }
    field("Item No.";rec."Item No.")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Base Unit of Measure";rec."Base Unit of Measure")
    {
        
    }
    field("Quantity by";rec."Quantity by")
    {
        
    }
    field("Status";rec."Status")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Weighing";rec."Weighing")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}







