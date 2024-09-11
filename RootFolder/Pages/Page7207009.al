page 7207009 "QB Post. Receipt/Transfer Sub."
{
Editable=false;
    CaptionML=ENU='Lines',ESP='L�neas';
    SourceTable=7206973;
    PageType=ListPart;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Line No.";rec."Line No.")
    {
        
    }
    field("Item No.";rec."Item No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Unit Cost";rec."Unit Cost")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
    }
    field("Origin Location";rec."Origin Location")
    {
        
    }
    field("Destination Location";rec."Destination Location")
    {
        
    }

}

}
}actions
{
area(Processing)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
                      Image=Line ;
group("group3")
{
        CaptionML=ENU='Item Availability by',ESP='Disponibilidad prod. por';
                      Image=ItemAvailability ;
    action("action1")
    {
        AccessByPermission=TableData 14=R;
                      CaptionML=ENU='Location',ESP='Almac�n';
                      ToolTipML=ENU='View the actual and projected quantity of the item per location.',ESP='Permite ver la cantidad real y proyectada del producto por ubicaci�n.';
                      ApplicationArea=Location;
                      Image=Warehouse;
                      
                                
    trigger OnAction()    VAR
                                 Item : Record 27;
                               BEGIN

                                 Item.GET(rec."Item No.");
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByLocation);
                               END;


    }

}

}

}
}
  
    var
      ItemAvailFormsMgt : Codeunit 353;

    /*begin
    end.
  
*/
}







