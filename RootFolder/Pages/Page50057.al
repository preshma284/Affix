page 50057 "Status Control Assets"
{
CaptionML=ENU='Status Control Assets',ESP='Control estado activos fijos';
    SourceTable=50008;
    SourceTableView=WHERE("Type"=CONST("Status Control"));
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Asset No.";rec."Asset No.")
    {
        
    }
    field("Line No.";rec."Line No.")
    {
        
    }
    field("Type";rec."Type")
    {
        
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
area(FactBoxes)
{
    systempart(MyNotes;MyNotes)
    {
        ;
    }
    systempart(Links;Links)
    {
        ;
    }

}
}
  

    /*begin
    end.
  
*/
}








