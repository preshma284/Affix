page 7207408 "Activation Lines Hist. Subform"
{
Editable=false;
    CaptionML=ENU='Lines',ESP='L�neas';
    SourceTable=7207371;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Element Code";rec."Element Code")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Document No.";rec."Document No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Line No.";rec."Line No.")
    {
        
    }
    field("No.";rec."No.")
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
    field("Amount";rec."Amount")
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
    field("Activation Type";rec."Activation Type")
    {
        
    }
    field("Gen. Prod. Posting Group";rec."Gen. Prod. Posting Group")
    {
        
    }
    field("Account Type";rec."Account Type")
    {
        
    }
    field("Account No.";rec."Account No.")
    {
        
    }
    field("Bal. Account No.";rec."Bal. Account No.")
    {
        
    }
    field("Bal. Account Type";rec."Bal. Account Type")
    {
        
    }
    field("Depreciate until";rec."Depreciate until")
    {
        
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("New Location Code";rec."New Location Code")
    {
        
    }
    field("Variant Code";rec."Variant Code")
    {
        
    }
    field("Unit of Measure Code";rec."Unit of Measure Code")
    {
        
    }
    field("Item No.";rec."Item No.")
    {
        
    }
    field("New Variant Code";rec."New Variant Code")
    {
        
    }
    field("Applies-to Entry";rec."Applies-to Entry")
    {
        
    }
    field("Dimension Set ID";rec."Dimension Set ID")
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







