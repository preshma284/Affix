page 50060 "Certifications Subform"
{
CaptionML=ENU='Certifications Subform',ESP='Certificaciones Subpagina';
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
                  rec.Type := rec.Type::Certification;
                END;




    /*begin
    end.
  
*/
}








