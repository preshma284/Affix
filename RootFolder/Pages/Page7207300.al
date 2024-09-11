page 7207300 "Hours to perform List"
{
CaptionML=ENU='Hours to perform List',ESP='Lista hora a realizar';
    SourceTable=7207298;
    PageType=List;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Calendar";rec."Calendar")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Period";rec."Period")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Hours Total";rec."Hours Total")
    {
        
                Style=Strong;
                StyleExpr=TRUE 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("Day Total")
    {
        
                      CaptionML=ENU='Day Total',ESP='Total d�as';
                      RunObject=Page 7207297;
                      RunPageView=SORTING("Calendar","Allocation Term","Day")
                                  ORDER(Ascending);
RunPageLink="Calendar"=FIELD("Calendar"), "Allocation Term"=FIELD("Period");
                      Image=MachineCenterCalendar;
    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Day Total_Promoted"; "Day Total")
                {
                }
            }
        }
}
  

    /*begin
    end.
  
*/
}







