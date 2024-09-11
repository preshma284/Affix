page 7207430 "Subform. Hist. Lin Delivery/Re"
{
Editable=false;
    CaptionML=ENU='Subform. Hist. Lin Delivery/Return Elem',ESP='Subform. histo. lin ent/dev ele';
    SourceTable=7207360;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Contract Code";rec."Contract Code")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Document No.";rec."Document No.")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Line No.";rec."Line No.")
    {
        
    }
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("Unit of Measure";rec."Unit of Measure")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Unit Price";rec."Unit Price")
    {
        
    }
    field("Shortcut Dimensios 1 Code";rec."Shortcut Dimensios 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
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
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
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







