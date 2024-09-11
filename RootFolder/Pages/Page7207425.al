page 7207425 "Subform. Element Return"
{
CaptionML=ENU='Subform. Element Return',ESP='Subform. devoluci�n elemento';
    MultipleNewLines=true;
    SourceTable=7207357;
    DelayedInsert=true;
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
    field("Rectification";rec.Rectification)
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Applicated Entry No.";rec."Applicated Entry No.")
    {
        
    }
    field("Variant Code";rec."Variant Code")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("Unit of Measure";rec."Unit of Measure")
    {
        
    }
    field("Amount to Manipulate";rec."Amount to Manipulate")
    {
        
    }
    field("Amount Manipulated";rec."Amount Manipulated")
    {
        
    }
    field("Unit Price";rec."Unit Price")
    {
        
    }
    field("Shortcut Dimensios 1 Code";rec."Shortcut Dimensios 1 Code")
    {
        
    }
    field("Weight to Manipulate";rec."Weight to Manipulate")
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
        CaptionML=ENU='&Line',ESP='&L�nea';
    action("action1")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='D&imensions',ESP='D&imensiones';
                      Image=Dimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 _ShowDimensions;
                               END;


    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       rec.ShowShortcutDimCode(ShortcutDimCode);
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  CLEAR(ShortcutDimCode);
                END;



    var
      ShortcutDimCode : ARRAY [8] OF Code[20];

    procedure _ShowDimensions();
    begin
      Rec.ShowDimensions;
    end;

    // procedure ShowDimensions();
    // begin
    //   Rec.ShowDimensions;
    // end;

    procedure UpdateForm(SetSaveRecord : Boolean);
    begin
      CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin//end
}







