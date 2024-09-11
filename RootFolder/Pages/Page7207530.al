page 7207530 "Regularization Stock List"
{
CaptionML=ENU='Regularization Stock List',ESP='Lista regularizaci¢n stock';
    SourceTable=7207408;
    DataCaptionFields="Location Code";
    PageType=List;
    CardPageID="Header Regularization Stock";
    RefreshOnActivate=true;
  layout
{
area(content)
{
repeater("Group")
{
        
                Editable=False;
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }

}

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L¡nea';
    action("action1")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      Image=EditLines;
                      
                                trigger OnAction()    BEGIN
                                 PAGE.RUN(PAGE::"Header Regularization Stock",Rec);
                               END;


    }

}

}
area(Processing)
{


}
}
  

    /*begin
    end.
  
*/
}







