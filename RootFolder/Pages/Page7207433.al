page 7207433 "Element Delivery List"
{
Editable=false;
    CaptionML=ENU='Element Delivery List',ESP='Lista entrega elemento';
    SourceTable=7207356;
    SourceTableView=WHERE("Document Type"=CONST("Delivery"));
    DataCaptionFields="Contract Code";
    PageType=List;
    CardPageID="Element Delivery Header";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Contract Code";rec."Contract Code")
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
                                 PAGE.RUN(PAGE::"Element Delivery Header",Rec);
                               END;


    }

}

}
area(Creation)
{


}
}
  

    /*begin
    end.
  
*/
}







