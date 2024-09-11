page 7207467 "Job Planning Milestones"
{
CaptionML=ENU='Job Planning Milestones',ESP='Hitos planificaci¢n proy.';
    SourceTable=7207375;
    DelayedInsert=true;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job No.";rec."Job No.")
    {
        
                Visible=False ;
    }
    field("Planning Milestone Code";rec."Planning Milestone Code")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Estimated Date";rec."Estimated Date")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}







