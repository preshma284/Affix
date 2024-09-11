page 7207455 "His. Element Contract List"
{
CaptionML=ENU='His. Element Contract List',ESP='Lista his. contrato elemento';
    SourceTable=7207373;
    PageType=List;
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
    field("Customer/Vendor No.";rec."Customer/Vendor No.")
    {
        
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
    field("Document State";rec."Document State")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Posting Date";rec."Posting Date")
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
    field("Description 2";rec."Description 2")
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
                                 PAGE.RUN(PAGE::"Pos. Element Contract Header",Rec);
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







