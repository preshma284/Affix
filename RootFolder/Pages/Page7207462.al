page 7207462 "Element Return List"
{
Editable=false;
    CaptionML=ENU='Element Return List',ESP='Lista devoluci¢n elemento';
    SourceTable=7207356;
    SourceTableView=WHERE("Document Type"=CONST("Return"));
    DataCaptionFields="Contract Code";
    PageType=List;
    CardPageID="Element Return Header";
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
                      RunObject=Page 7207462;
                      Image=EditLines ;
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







