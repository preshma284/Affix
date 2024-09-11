page 7206953 "QB External Worksheet Lin. Pos"
{
Editable=false;
    CaptionML=ENU='Lines',ESP='Lineas';
    SourceTable=7206936;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Piecework No.";rec."Piecework No.")
    {
        
    }
    field("Resource No.";rec."Resource No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Work Type Code";rec."Work Type Code")
    {
        
    }
    field("Work Day Date";rec."Work Day Date")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Quantity Invoiced";rec."Quantity Invoiced")
    {
        
    }
    field("Quantity Pending";rec."Quantity Pending")
    {
        
    }
    field("Cost Price";rec."Cost Price")
    {
        
    }
    field("Total Cost";rec."Total Cost")
    {
        
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
        CaptionML=ENU='&Line',ESP='&L¡nea';
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

    // begin//end
}








