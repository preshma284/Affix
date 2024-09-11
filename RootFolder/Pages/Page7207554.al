page 7207554 "Schedule MSP"
{
Editable=false;
    CaptionML=ENU='Schedule MSP',ESP='Previsi¢n MSP';
    SourceTable=7207389;
    PageType=List;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Expected Date";rec."Expected Date")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Code";rec."Budget Code")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Piecework Code";rec."Piecework Code")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Unit Type";rec."Unit Type")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Performed";rec."Performed")
    {
        
    }
    field("Budget Measure";rec."Budget Measure")
    {
        
                DecimalPlaces=2:6;
                Style=Ambiguous;
                StyleExpr=TRUE ;
    }
    field("Budget Sale Amount";rec."Budget Sale Amount")
    {
        
                DecimalPlaces=2:6;
                Style=Ambiguous;
                StyleExpr=TRUE ;
    }
    field("Budget Cost Amount";rec."Budget Cost Amount")
    {
        
                DecimalPlaces=2:6;
                Style=Ambiguous;
                StyleExpr=TRUE ;
    }
    field("Expected Measured Amount";rec."Expected Measured Amount")
    {
        
                DecimalPlaces=2:6;
    }
    field("Expected Production Amount";rec."Expected Production Amount")
    {
        
                DecimalPlaces=2:6;
    }
    field("Expected Cost Amount";rec."Expected Cost Amount")
    {
        
                DecimalPlaces=2:6;
    }
    field("Expected Percentage";rec."Expected Percentage")
    {
        
                DecimalPlaces=2:6;
    }

}

}
}
  

    /*begin
    end.
  
*/
}







