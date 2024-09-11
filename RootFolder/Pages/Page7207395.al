page 7207395 "Hist. Exp. Notes Lines Subform"
{
CaptionML=ENU='Hist. Exp. Notes Lines Subform.',ESP='Subform. Hist. Lineas Notas de gasto';
    SourceTable=7207324;
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
    field("Dimension Set ID";rec."Dimension Set ID")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Expense Date";rec."Expense Date")
    {
        
    }
    field("Expense Concept";rec."Expense Concept")
    {
        
    }
    field("Expense Account";rec."Expense Account")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Price Cost";rec."Price Cost")
    {
        
    }
    field("Total Amount";rec."Total Amount")
    {
        
    }
    field("Total Amount (DL)";rec."Total Amount (DL)")
    {
        
    }
    field("Justifying";rec."Justifying")
    {
        
    }
    field("Payment Charge Enterprise";rec."Payment Charge Enterprise")
    {
        
    }
    field("Bal. Account Payment";rec."Bal. Account Payment")
    {
        
    }
    field("Job Task No.";rec."Job Task No.")
    {
        
    }
    field("Withholding Amount (DL)";rec."Withholding Amount (DL)")
    {
        
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
    }
    field("No Document Vendor";rec."No Document Vendor")
    {
        
    }
    field("VAT Product Posting Group";rec."VAT Product Posting Group")
    {
        
    }
    field("Percentage VAT";rec."Percentage VAT")
    {
        
    }
    field("VAT Amount";rec."VAT Amount")
    {
        
    }
    field("VAT Amount (DL)";rec."VAT Amount (DL)")
    {
        
    }
    field("Billable";rec."Billable")
    {
        
    }
    field("Sales Amount";rec."Sales Amount")
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
////CaptionML=ENU='&Line',ESP='&L¡nea';
group("group2")
{
        CaptionML=ENU='&Line',ESP='&L¡nea';
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

    // begin//end
}







