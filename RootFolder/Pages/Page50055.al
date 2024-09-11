page 50055 "Technical Details Assets"
{
CaptionML=ENU='Technical Details Assets',ESP='Ficha t‚cnica activos fijos';
    SourceTable=50008;
    SourceTableView=WHERE("Type"=CONST("Technical Detail"));
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








