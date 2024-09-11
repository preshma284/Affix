page 7207273 "Quobuilding Comment WorkSheet"
{
CaptionML=ENU='Quobuilding Comment WorkSheet',ESP='Hoja cmentarios Quobuilding';
    MultipleNewLines=true;
    SourceTable=7207270;
    DelayedInsert=true;
    PageType=List;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Date";rec."Date")
    {
        
    }
    field("Comment";rec."Comment")
    {
        
                Style=Strong;
                StyleExpr=TRUE 

  ;
    }

}

}
}
  trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  rec.SetUpNewLine;
                END;




    /*begin
    end.
  
*/
}







