page 7207058 "QB Post. Serv. Order Subf."
{
Editable=false;
    CaptionML=ENU='Lines',ESP='L�neas';
    SourceTable=7206969;
    PageType=ListPart;
    AutoSplitKey=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Piecework No.";rec."Piecework No.")
    {
        
    }
    field("Code Piecework PRESTO";rec."Code Piecework PRESTO")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Contract Price";rec."Contract Price")
    {
        
    }
    field("Sale Price";rec."Sale Price")
    {
        
    }
    field("Quantity";rec."Quantity")
    {
        
    }
    field("Quantity Invoiced";rec."Quantity Invoiced")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Expenses/Investment";rec."Expenses/Investment")
    {
        
    }
    field("Cost Amount";rec."Cost Amount")
    {
        
    }
    field("Sale Amount";rec."Sale Amount")
    {
        
    }
    field("Profit";rec."Profit")
    {
        
    }
    field("Price review percentage";rec."Price review percentage")
    {
        
    }
    field("Sale Price With Price review";rec."Sale Price With Price review")
    {
        
    }
    field("Sale Amount With Price review";rec."Sale Amount With Price review")
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
                                 //This functionality was copied from page 7021439. Unsupported part was commented. Please check it.
                                 //CurrPage.HistLinDoc.FORM.
                                 _ShowDimensions;
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Measurement Lines Bill of Item',ESP='Descompuesto lineas de medici�n',ESN='Descompuesto lineas de medici�n';
                      Visible=false;
                      Image=ItemTrackingLines;
                      
                                
    trigger OnAction()    BEGIN
                                 //This functionality was copied from page 7021439. Unsupported part was commented. Please check it.
                                 //CurrPage.HistLinDoc.FORM.
                                 ShowBillofItemMeasurement;
                               END;


    }

}

}
}
  

    procedure _ShowDimensions();
    begin
      Rec.ShowDimensions;
    end;

    procedure ShowBillofItemMeasurement();
    var
      recPostMeasLinesBillofItem : Record 7207396;
      pagePostMeasurBillofItem : Page 7207375;
    begin
      recPostMeasLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
      recPostMeasLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
      CLEAR(pagePostMeasurBillofItem);
      pagePostMeasurBillofItem.SETTABLEVIEW(recPostMeasLinesBillofItem);
      pagePostMeasurBillofItem.EDITABLE(FALSE);
      pagePostMeasurBillofItem.LOOKUPMODE(TRUE);
      pagePostMeasurBillofItem.RUNMODAL;
    end;

    // begin//end
}







