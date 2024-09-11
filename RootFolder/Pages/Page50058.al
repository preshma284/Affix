page 50058 "Technical Details Subform"
{
CaptionML=ENU='Technical Details Subform',ESP='Ficha T�cnica Subpagina';
    MultipleNewLines=true;
    SourceTable=50008;
    DelayedInsert=true;
    PageType=ListPart;
    AutoSplitKey=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Type";rec."Type")
    {
        
                Editable=False ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("Posting DateTime";rec."Posting DateTime")
    {
        
    }
    field("Certification Date";rec."Certification Date")
    {
        
    }
    field("Status Control Date";rec."Status Control Date")
    {
        
    }
    field("Next Control Date";rec."Next Control Date")
    {
        
    }

}

}
}
  






trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  rec.Type := rec.Type::"Technical Detail";
                END;




    /*begin
    end.
  
*/
}








