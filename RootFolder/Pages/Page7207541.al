page 7207541 "Costsheet Hist. Lin. Subform."
{
Editable=false;
    CaptionML=ENU='Costsheet Hist. Lin. Subform.',ESP='Subform. hist. lin. Parte cte';
    SourceTable=7207436;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Piecework No.";rec."Piecework No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Amount";rec."Amount")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
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
        CaptionML=ENU='Line',ESP='L¡nea';
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      Image=Dimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 _ShowDimensions
                               END;


    }

}

}
}
  

    procedure _ShowDimensions();
    begin
      Rec.ShowDimensions;
    end;

    // begin//end
}







