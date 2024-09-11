page 7207013 "QB Ceded List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Ceded List',ESP='Prestados';
    SourceTable=7206975;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Item Entry No.";rec."Item Entry No.")
    {
        
    }
    field("Item No.";rec."Item No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Entry Type";rec."Entry Type")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Origin Location";rec."Origin Location")
    {
        
    }
    field("Destination Location";rec."Destination Location")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Remaining Quantity";rec."Remaining Quantity")
    {
        
    }
    field("Open";rec."Open")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("User";rec."User")
    {
        
    }
    field("Created Datetime";rec."Created Datetime")
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
  trigger OnOpenPage()    BEGIN
                 Rec.SETRANGE(Open,TRUE);
               END;




    /*begin
    end.
  
*/
}








