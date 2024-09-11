page 7206986 "Posted Subfor. Aux. Loc.  Lin"
{
Editable=false;
    CaptionML=ENU='Posted Subfor. Aux. Location Output Shpt Lin',ESP='Hist. Subfor. l�neas albar�n salida almac�n auxiliar';
    SourceTable=7206954;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("table")
{
        
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Variant Code";rec."Variant Code")
    {
        
                Visible=False ;
    }
    field("Outbound Warehouse";rec."Outbound Warehouse")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("No. Serie for Tracking";rec."No. Serie for Tracking")
    {
        
                Editable=False ;
    }
    field("No. Lot for Tracking";rec."No. Lot for Tracking")
    {
        
                Editable=False ;
    }
    field("Unit Cost";rec."Unit Cost")
    {
        
                Editable=False ;
    }
    field("Total Cost";rec."Total Cost")
    {
        
                Editable=False ;
    }
    field("Sales Price";rec."Sales Price")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
                Editable=False ;
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Billable";rec."Billable")
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
        CaptionML=ENU='Line',ESP='L�nea';
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      Image=Dimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 ShowDimensions_;
                               END;


    }

}

}
}
  
    var
      PurchaseHeader : Record 38;
      ItemCrossReference : Record "Item Reference";
      TransferExtendedText : Codeunit 378;
      // ConsumptionProposed : Report 7207339;
      ShortcutDimCode : ARRAY [8] OF Code[20];

    procedure ShowDimensions_();
    begin
      Rec.ShowDimensions;
    end;

    // begin//end
}








