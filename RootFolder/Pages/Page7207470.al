page 7207470 "Models Tempory Card"
{
CaptionML=ENU='Models Tempory Card',ESP='Ficha modelo temporal';
    SourceTable=7207377;
    PageType=Worksheet;
  layout
{
area(content)
{
group("group48")
{
        
                CaptionML=ENU='General',ESP='General';
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Assigned Total";rec."Assigned Total")
    {
        
    }

}
    part("part1";7207471)
    {
        SubPageLink="Model Code"=FIELD("Code");
    }

}

}
}
  

    /*begin
    end.
  
*/
}







