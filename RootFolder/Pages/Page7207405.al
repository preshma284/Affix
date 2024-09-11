page 7207405 "Activation Line"
{
Editable=false;
    CaptionML=ENU='Activation Line',ESP='Lista activaci¢n';
    SourceTable=7207367;
    DataCaptionFields="Element Code";
    PageType=List;
    CardPageID="Activation Header";
  layout
{
area(content)
{
repeater("table")
{
        
    field("Element Code";rec."Element Code")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
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
    field("Description 2";rec."Description 2")
    {
        
    }
    field("ConfirmDeletion";rec."ConfirmDeletion")
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
    field("Currency Code";rec."Currency Code")
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
                                 PAGE.RUN(PAGE::"Activation Header",Rec);
                               END;


    }

}

}
area(Processing)
{


}
}
  
    var
      DimensionManagement : Codeunit 408;

    /*begin
    end.
  
*/
}







