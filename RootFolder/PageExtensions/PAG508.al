pageextension 50211 MyExtension508 extends 508//37
{
layout
{
addafter("No.")
{
    field("JobNo";rec."Job No.")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      CurrentSalesLine : Record 37;
      SalesLine : Record 37;
      TotalSalesHeader : Record 36;
      TotalSalesLine : Record 37;
      SalesHeader : Record 36;
      Currency : Record 4;
      SalesReceivablesSetup : Record 311;
      TransferExtendedText : Codeunit 378;
      SalesPriceCalcMgt : Codeunit 7000;
      ItemAvailFormsMgt : Codeunit 353;
      SalesCalcDiscountByType : Codeunit 56;
      DocumentTotals : Codeunit 57;
      VATAmount : Decimal;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      AmountWithDiscountAllowed : Decimal;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      InvDiscAmountEditable : Boolean;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';

    

//procedure
//procedure ApproveCalcInvDisc();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//Local procedure ValidateInvoiceDiscountAmount();
//    var
//      SalesHeader : Record 36;
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      if ( SalesHeader.InvoicedLineExists  )then
//        if ( not CONFIRM(UpdateInvDiscountQst,FALSE)  )then
//          exit;
//
//      SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure ExplodeBOM();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure InsertExtendedText(Unconditionally : Boolean);
//    begin
//      OnBeforeInsertExtendedText(Rec);
//      if ( TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally)  )then begin
//        CurrPage.SAVERECORD;
//        COMMIT;
//        TransferExtendedText.InsertSalesExtText(Rec);
//      end;
//      if ( TransferExtendedText.MakeUpdate  )then
//        UpdateForm(TRUE);
//    end;
//
//    //[External]
//procedure UpdateForm(SetSaveRecord : Boolean);
//    begin
//      CurrPage.UPDATE(SetSaveRecord);
//    end;
//Local procedure GetTotalSalesHeader();
//    begin
//      DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec,TotalSalesHeader,Currency);
//    end;
//Local procedure CalculateTotals();
//    begin
//      DocumentTotals.SalesCheckIfDocumentChanged(Rec,xRec);
//      DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader,TotalSalesLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
//      DocumentTotals.RefreshSalesLine(Rec);
//    end;
//Local procedure DeltaUpdateTotals();
//    begin
//      DocumentTotals.SalesDeltaUpdateTotals(Rec,xRec,TotalSalesLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
//      if ( rec."Line Amount" <> xRec."Line Amount"  )then begin
//        CurrPage.SAVERECORD;
//        rec.SendLineInvoiceDiscountResetNotification;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure UpdateEditableOnRow();
//    begin
//      InvDiscAmountEditable := CurrPage.EDITABLE and not SalesReceivablesSetup."Calc. Inv. Discount";
//    end;
//Local procedure ShowPrices();
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      CLEAR(SalesPriceCalcMgt);
//      SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
//    end;
//Local procedure ShowLineDisc();
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      CLEAR(SalesPriceCalcMgt);
//      SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
//    end;
//Local procedure ShowOrders();
//    begin
//      CurrentSalesLine := Rec;
//      SalesLine.RESET;
//      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
//      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
//    end;
//Local procedure ShowInvoices();
//    begin
//      CurrentSalesLine := Rec;
//      SalesLine.RESET;
//      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Invoice);
//      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
//    end;
//Local procedure ShowReturnOrders();
//    begin
//      CurrentSalesLine := Rec;
//      SalesLine.RESET;
//      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
//      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
//    end;
//Local procedure ShowCreditMemos();
//    begin
//      CurrentSalesLine := Rec;
//      SalesLine.RESET;
//      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Credit Memo");
//      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
//    end;
//Local procedure ShowPostedOrders();
//    var
//      SaleShptLine : Record 111;
//    begin
//      CurrentSalesLine := Rec;
//      SaleShptLine.RESET;
//      SaleShptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      SaleShptLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SaleShptLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Sales Shipment Lines",SaleShptLine);
//    end;
//Local procedure ShowPostedInvoices();
//    var
//      SalesInvLine : Record 113;
//    begin
//      CurrentSalesLine := Rec;
//      SalesInvLine.RESET;
//      SalesInvLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      SalesInvLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SalesInvLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Sales Invoice Lines",SalesInvLine);
//    end;
//Local procedure ShowPostedReturnReceipts();
//    var
//      ReturnRcptLine : Record 6661;
//    begin
//      CurrentSalesLine := Rec;
//      ReturnRcptLine.RESET;
//      ReturnRcptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      ReturnRcptLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      ReturnRcptLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Return Receipt Lines",ReturnRcptLine);
//    end;
//Local procedure ShowPostedCreditMemos();
//    var
//      SalesCrMemoLine : Record 115;
//    begin
//      CurrentSalesLine := Rec;
//      SalesCrMemoLine.RESET;
//      SalesCrMemoLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      SalesCrMemoLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
//      SalesCrMemoLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo Lines",SalesCrMemoLine);
//    end;
//Local procedure NoOnAfterValidate();
//    begin
//      InsertExtendedText(FALSE);
//
//      SaveAndAutoAsmToOrder;
//    end;
//Local procedure LocationCodeOnAfterValidate();
//    begin
//      SaveAndAutoAsmToOrder;
//    end;
//Local procedure VariantCodeOnAfterValidate();
//    begin
//      SaveAndAutoAsmToOrder;
//    end;
//Local procedure CrossReferenceNoOnAfterValidat();
//    begin
//      InsertExtendedText(FALSE);
//    end;
//Local procedure QuantityOnAfterValidate();
//    begin
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//
//      if (rec."Type" = rec."Type"::Item) and
//         (rec."Quantity" <> xRec.Quantity)
//      then
//        CurrPage.UPDATE(TRUE);
//    end;
//Local procedure UnitofMeasureCodeOnAfterValida();
//    begin
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//    end;
//Local procedure SaveAndAutoAsmToOrder();
//    begin
//      if ( (rec."Type" = rec."Type"::Item) and rec.IsAsmToOrderRequired  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoAsmToOrder;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//
//    //[External]
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(2,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",'',0);
//      DocumentLineTracking.RUNMODAL;
//    end;
//Local procedure ValidateShortcutDimension(DimIndex : Integer);
//    var
//      AssembleToOrderLink : Record 904;
//    begin
//      rec.ValidateShortcutDimCode(DimIndex,ShortcutDimCode[DimIndex]);
//      AssembleToOrderLink.UpdateAsmDimFromSalesLine(Rec);
//    end;
//
//    [Integration]
//Local procedure OnBeforeInsertExtendedText(var SalesLine : Record 37);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnCrossReferenceNoOnLookup(var SalesLine : Record 37);
//    begin
//    end;

//procedure
}

