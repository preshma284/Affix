page 7207007 "QB Receipt/Transfer Subform"
{
CaptionML=ENU='Receipt/Transfer Subform',ESP='L�neas';
    SourceTable=7206971;
    PageType=ListPart;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Item No.";rec."Item No.")
    {
        
                NotBlank=true;
                ShowMandatory=True ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
                NotBlank=true;
                ShowMandatory=True ;
    }
    field("Unit Cost";rec."Unit Cost")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
    }
    field("Origin Location";rec."Origin Location")
    {
        
                NotBlank=true;
                Editable=false;
                ShowMandatory=True ;
    }
    field("Destination Location";rec."Destination Location")
    {
        
                Editable=false ;
    }
    field("Document Job No.";rec."Document Job No.")
    {
        
                Enabled=FALSE 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("Ceded")
    {
        
                      CaptionML=ENU='Ceded',ESP='Prestados';
                      RunObject=Page 7207013;
                      RunPageView=SORTING("Item No.");
RunPageLink="Item No."=FIELD("Item No.");
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Loaners;
                      PromotedCategory=Process;
                      PromotedOnly=true ;
    }
    action("action2")
    {
        AccessByPermission=TableData 14=R;
                      CaptionML=ENU='Disponibility Location',ESP='Disponibilidad prod. por Almac�n';
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
  
    var
      ItemAvailFormsMgt : Codeunit 353;

    /*begin
    end.
  
*/
}







