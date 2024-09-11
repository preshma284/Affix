page 7207417 "Usage List"
{
Editable=false;
    CaptionML=ENU='Usage List',ESP='Lista utilizaci¢n';
    SourceTable=7207362;
    PageType=List;
    CardPageID="Usage Header";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Contract Code";rec."Contract Code")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
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
        CaptionML=ENU='Line',ESP='L¡nea';
    action("action1")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      Image=EditLines;
                      
                                trigger OnAction()    BEGIN
                                 PAGE.RUN(PAGE::"Usage Header",Rec);
                               END;


    }

}

}
area(Processing)
{


}
}
  
    var
      CUDimensionManagement : Codeunit 408;

    /*begin
    end.
  
*/
}







