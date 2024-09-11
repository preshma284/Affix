page 50063 "Maintenance Status Control"
{
CaptionML=ENU='Maintenance Status Control',ESP='Mantenimiento control de estado';
    SourceTable=5600;
    PageType=Card;
  layout
{
area(content)
{
group("General")
{
        
                Editable=False;
    field("Description";rec."Description")
    {
        
    }
    field("Search Description";rec."Search Description")
    {
        
    }
    field("FA Class Code";rec."FA Class Code")
    {
        
    }
    field("FA Subclass Code";rec."FA Subclass Code")
    {
        
    }
    field("FA Location Code";rec."FA Location Code")
    {
        
    }
    field("Budgeted Asset";rec."Budgeted Asset")
    {
        
    }
    field("Serial No.";rec."Serial No.")
    {
        
    }
    field("Main Asset/Component";rec."Main Asset/Component")
    {
        
    }
    field("Component of Main Asset";rec."Component of Main Asset")
    {
        
    }
    field("Responsible Employee";rec."Responsible Employee")
    {
        
    }
    field("Inactive";rec."Inactive")
    {
        
    }
    field("Blocked";rec."Blocked")
    {
        
    }
    field("Acquired";rec."Acquired")
    {
        
    }
    field("Last Date Modified";rec."Last Date Modified")
    {
        
    }

}
    part("part1";50062)
    {
        
                SubPageView=WHERE("Type"=CONST("Status Control"));SubPageLink="Asset No."=FIELD("No.");
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








