page 7207474 "Detail Job Payment"
{
CaptionML=ENU='Detail Job Payment',ESP='Detalle pagos proyecto';
    SourceTable=7207380;
    PageType=List;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Fact No.";rec."Fact No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Concept Code";rec."Concept Code")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Amount Type";rec."Amount Type")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("% Amopunt";rec."% Amopunt")
    {
        
    }
    field("Due Method";rec."Due Method")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Fixed Day";rec."Fixed Day")
    {
        
                CaptionML=ENU='Fixed Day',ESP='D�a de pago';
                Visible=false ;
    }
    field("Period";rec."Period")
    {
        
                Visible=false ;
    }
    field("Value Date Formula";rec."Value Date Formula")
    {
        
    }
    field("VAT Prod. Posting Group";rec."VAT Prod. Posting Group")
    {
        
    }
    field("VAT Bus. Posting Group";rec."VAT Bus. Posting Group")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ENU='&Fixed Dates',ESP='&Fechas fijas';
                      RunObject=Page 7207475;
RunPageLink="Job No."=FIELD("Job No."), "Rule Code"=FIELD("Rule Code"), "Fact No."=FIELD("Fact No.");
                      Image=WorkCenterCalendar;
    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  

    /*begin
    end.
  
*/
}







