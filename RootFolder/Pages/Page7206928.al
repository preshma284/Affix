page 7206928 "TAux General Categories List"
{
  ApplicationArea=All;

CaptionML=ENU='General Categories List',ESP='Lista categorias generales';
    SourceTable=7206915;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Use In";rec."Use In")
    {
        
    }

}
    part("part1";7207277)
    {
        
                SubPageView=SORTING("Categorie","Code");SubPageLink="Categorie"=FIELD("Code");
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









