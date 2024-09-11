page 7207299 "Allocation Term List"
{
  ApplicationArea=All;

CaptionML=ENU='Allocation Term List',ESP='Lista de periodos de imputaci¢n';
    SourceTable=7207297;
    PageType=List;
  layout
{
area(content)
{
repeater("table")
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
    field("Initial Date";rec."Initial Date")
    {
        
    }
    field("Final Date";rec."Final Date")
    {
        
    }
    field("Period Type";rec."Period Type")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE 

  ;
    }

}

}
}
  

    /*begin
    end.
  
*/
}








