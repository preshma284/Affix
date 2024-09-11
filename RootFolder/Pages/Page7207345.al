page 7207345 "Post. Reestim. Lines Subform."
{
Editable=false;
    CaptionML=ENU='Lines',ESP='L�neas';
    SourceTable=7207318;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("table")
{
        
    field("Analytical concept";rec."Analytical concept")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("G/L Account";rec."G/L Account")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Amount";rec."Budget Amount")
    {
        
    }
    field("Realized Amount";rec."Realized Amount")
    {
        
    }
    field("Realized Excess";rec."Realized Excess")
    {
        
    }
    field("Estimated outstanding amount";rec."Estimated outstanding amount")
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

    // procedure ShowDimensions();
    // begin
    //   Rec.ShowDimensions;
    // end;

    // begin//end
}







