pageextension 50129 MyExtension137 extends 137//121
{
layout
{
addafter("Quantity")
{
    field("QB_DirectUnitCost";rec."Direct Unit Cost")
    {
        
}
    field("QB_Amount";rec."Quantity" * rec."Direct Unit Cost")
    {
        
                CaptionML=ESP='Importe';
                BlankZero=true;
}
    field("QB_QtyOrigin";rec."Qty. Origin")
    {
        
                ToolTipML=ENU='Specifies the quantity of the item or service on the line.',ESP='Especifica la cantidad del producto o servicio en la l¡nea.';
                ApplicationArea=Suite;
                BlankZero=true;
}
    field("QB_AmountOrigin";rec."Qty. Origin" * rec."Direct Unit Cost")
    {
        
                CaptionML=ESP='Importe Origen';
                BlankZero=true;
}
} addafter("Qty. Rcd. Not Invoiced")
{
    field("QB_OrderNo";rec."Order No.")
    {
        
}
    field("QB_OrderLineNo";rec."Order Line No.")
    {
        
}
} addafter("Job Task No.")
{
    field("QB_PieceworkNo";rec."Piecework NÂº")
    {
        
}
} addafter("Correction")
{
    field("Cancelled";rec."Cancelled")
    {
        
}
    field("Accounted";rec."Accounted")
    {
        
                Visible=false ;
}
    field("QB Qty Provisioned";rec."QB Qty Provisioned")
    {
        
                Visible=false ;
}
    field("QB Amount Provisioned";rec."QB Amount Provisioned")
    {
        
                Visible=false ;
}
}

}

actions
{


}

//trigger
trigger OnAfterGetRecord()    BEGIN
                       //JAV 18/11/20: - QB 1.07.05 Filtramos por documento para la cantidad a origen
                       Rec.SETFILTER("Filter Document No.", '<=%1', rec."Document No.");

                       QB_CalculateDocTotals;
                     END;


//trigger

var
      IsFoundation : Boolean;
      "---------------------- QB" : Integer;
      PurchRcptLine : Record 121;
      QB_Base : Decimal;
      QB_Origen : Decimal;
      QB_Pending : Decimal;

    
    

//procedure
//Local procedure ShowTracking();
//    var
//      ItemLedgEntry : Record 32;
//      TempItemLedgEntry : Record 32 TEMPORARY ;
//      TrackingForm : Page 99000822;
//    begin
//      Rec.TESTfield("Type",rec."Type"::Item);
//      if ( rec."Item Rcpt. Entry No." <> 0  )then begin
//        ItemLedgEntry.GET(rec."Item Rcpt. Entry No.");
//        TrackingForm.SetItemLedgEntry(ItemLedgEntry);
//      end ELSE
//        TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
//          DATABASE::"Purch. Rcpt. Line",0,rec."Document No.",'',0,rec."Line No.");
//
//      TrackingForm.RUNMODAL;
//    end;
//Local procedure UndoReceiptLine();
//    var
//      PurchRcptLine : Record 121;
//    begin
//      PurchRcptLine.COPY(Rec);
//      CurrPage.SETSELECTIONFILTER(PurchRcptLine);
//      CODEUNIT.RUN(CODEUNIT::"Undo Purchase Receipt Line",PurchRcptLine);
//    end;
//Local procedure PageShowItemPurchInvLines();
//    begin
//      Rec.TESTfield("Type",rec."Type"::Item);
//      rec.ShowItemPurchInvLines;
//    end;
//
//    //[External]
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(
//        5,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",rec."Order No.",rec."Order Line No.");
//      DocumentLineTracking.RUNMODAL;
//    end;
LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;
procedure QB_CalculateDocTotals();
    var
      qbSalesCrMemoHeader : Record 114;
    begin
      //JAV 04/01/21: - QB 1.09.10 Calculo del total del albar n para ponerlo en la pantalla

      QB_Base   := 0;
      QB_Origen := 0;
      QB_Pending:= 0;

      PurchRcptLine.RESET;
      PurchRcptLine.SETRANGE("Document No.", Rec."Document No.");
      PurchRcptLine.SETRANGE("Cancelled", FALSE);
      if ( PurchRcptLine.FINDSET(FALSE)  )then
        repeat
          PurchRcptLine.SETFILTER("Filter Document No.", '<=%1', rec."Document No.");
          PurchRcptLine.CALCFIELDS("Qty. Origin");
          QB_Base   += ROUND(PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost", 0.01);
          QB_Origen += ROUND(PurchRcptLine."Qty. Origin" * PurchRcptLine."Direct Unit Cost", 0.01);
          QB_Pending+= ROUND((PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced") * PurchRcptLine."Direct Unit Cost", 0.01);
        until (PurchRcptLine.NEXT = 0);
    end;

//procedure
}

