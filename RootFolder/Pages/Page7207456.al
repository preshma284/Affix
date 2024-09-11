page 7207456 "Subform. Posted Element Contra"
{
Editable=false;
    CaptionML=ENU='Subform. Posted Element Contract',ESP='Subform. hist. cont. elemento';
    MultipleNewLines=true;
    SourceTable=7207374;
    DelayedInsert=true;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Job No.";rec."Job No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Piecework Code";rec."Piecework Code")
    {
        
    }
    field("Unit Price";rec."Unit Price")
    {
        
    }
    field("Planned Delivery Quantity";rec."Planned Delivery Quantity")
    {
        
    }
    field("Unit of Measure";rec."Unit of Measure")
    {
        
                Editable=False ;
    }
    field("Delivered Quantity";rec."Delivered Quantity")
    {
        
    }
    field("Return Quantity";rec."Return Quantity")
    {
        
    }
    field("Variant Code";rec."Variant Code")
    {
        
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
                Visible=False ;
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
                Visible=False 

  ;
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
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='D&imensiones';
                      Image=Dimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 _ShowDimensions;
                               END;


    }

}

}
}
  

    procedure _ShowDimensions();
    begin
      Rec.ShowDimensions;
    end;

    // procedure ShowDimensions();
    // begin
    //   Rec.ShowDimensions;
    // end;

    // begin//end
}







