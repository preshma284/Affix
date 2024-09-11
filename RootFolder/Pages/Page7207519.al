page 7207519 "Units Posting Group List"
{
  ApplicationArea=All;

CaptionML=ENU='Units Posting Group List',ESP='Lista grupos contables unidades';
    SourceTable=7207431;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Cost Account";rec."Cost Account")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Cost Analytic Concept";rec."Cost Analytic Concept")
    {
        
    }
    field("Entry Account";rec."Entry Account")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Entry Analytic Concept";rec."Entry Analytic Concept")
    {
        
    }
    field("Account Per. Applicaction Acc.";rec."Account Per. Applicaction Acc.")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}








