page 7207421 "Usage Line Hist. Subform."
{
Editable=false;
    CaptionML=ENU='Usage Line Hist. Subform.',ESP='Subform. hist. Lin.utilizacion';
    SourceTable=7207366;
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
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Initial Date Calculation";rec."Initial Date Calculation")
    {
        
    }
    field("Return Date";rec."Return Date")
    {
        
    }
    field("Application Date";rec."Application Date")
    {
        
    }
    field("Delivery Mov. No.";rec."Delivery Mov. No.")
    {
        
    }
    field("Return Mov. No.";rec."Return Mov. No.")
    {
        
    }
    field("Return Document";rec."Return Document")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Unit Price";rec."Unit Price")
    {
        
    }
    field("Usage Days";rec."Usage Days")
    {
        
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
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
        CaptionML=ENU='Line',ESP='L�nea';
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







