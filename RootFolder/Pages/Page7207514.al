page 7207514 "Estimate"
{
Editable=true;
    CaptionML=ENU='Estimate',ESP='Previsi¢n';
    InsertAllowed=false;
    DeleteAllowed=true;
    ModifyAllowed=false;
    SourceTable=7207388;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job No.";rec."Job No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Piecework Code";rec."Piecework Code")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Expected Date";rec."Expected Date")
    {
        
    }
    field("Budget Code";rec."Budget Code")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Expected Measured Amount";rec."Expected Measured Amount")
    {
        
                DecimalPlaces=2:6;
    }
    field("Performed";rec."Performed")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}







