pageextension 50214 MyExtension510 extends 510//39
{
layout
{
addafter("VAT Prod. Posting Group")
{
    field("Job No.";rec."Job No.")
    {
        
}
    field("Piecework No.";rec."Piecework No.")
    {
        
                Visible=FALSE ;
}
    field("QW % Withholding by GE";rec."QW % Withholding by GE")
    {
        
}
    field("QW Withholding Amount by GE";rec."QW Withholding Amount by GE")
    {
        
}
    field("QW % Withholding by PIT";rec."QW % Withholding by PIT")
    {
        
}
    field("QW Withholding Amount by PIT";rec."QW Withholding Amount by PIT")
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
      TotalPurchaseHeader : Record 38;
      TotalPurchaseLine : Record 39;
      PurchLine : Record 39;
      CurrentPurchLine : Record 39;
      Currency : Record 4;
      PurchasesPayablesSetup : Record 312;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      PurchCalcDiscByType : Codeunit 66;
      DocumentTotals : Codeunit 57;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      VATAmount : Decimal;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      AmountWithDiscountAllowed : Decimal;
      InvDiscAmountEditable : Boolean;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';

    

//procedure
//procedure ApproveCalcInvDisc();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
//      DocumentTotals.PurchaseDocTotalsNotUpToDate;
//    end;
//Local procedure ValidateInvoiceDiscountAmount();
//    var
//      PurchaseHeader : Record 38;
//    begin
//      PurchaseHeader.GET(rec."Document Type",rec."Document No.");
//      if ( PurchaseHeader.InvoicedLineExists  )then
//        if ( not CONFIRM(UpdateInvDiscountQst,FALSE)  )then
//          exit;
//
//      DocumentTotals.PurchaseDocTotalsNotUpToDate;
//      PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchaseHeader);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure ExplodeBOM();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
//      DocumentTotals.PurchaseDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure InsertExtendedText(Unconditionally : Boolean);
//    begin
//      OnBeforeInsertExtendedText(Rec);
//      if ( TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally)  )then begin
//        CurrPage.SAVERECORD;
//        TransferExtendedText.InsertPurchExtText(Rec);
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
//Local procedure GetTotalsPurchaseHeader();
//    begin
//      DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec,TotalPurchaseHeader,Currency);
//    end;
//Local procedure CalculateTotals();
//    begin
//      DocumentTotals.PurchaseCheckIfDocumentChanged(Rec,xRec);
//      DocumentTotals.CalculatePurchaseSubPageTotals(
//        TotalPurchaseHeader,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
//      DocumentTotals.RefreshPurchaseLine(Rec);
//    end;
//Local procedure DeltaUpdateTotals();
//    begin
//      DocumentTotals.PurchaseDeltaUpdateTotals(Rec,xRec,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
//      if ( rec."Line Amount" <> xRec."Line Amount"  )then begin
//        CurrPage.SAVERECORD;
//        rec.SendLineInvoiceDiscountResetNotification;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure UpdateEditableOnRow();
//    begin
//      InvDiscAmountEditable := CurrPage.EDITABLE and not PurchasesPayablesSetup."Calc. Inv. Discount";
//    end;
//Local procedure ShowOrders();
//    begin
//      CurrentPurchLine := Rec;
//      PurchLine.RESET;
//      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
//      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
//    end;
//Local procedure ShowInvoices();
//    begin
//      CurrentPurchLine := Rec;
//      PurchLine.RESET;
//      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Invoice);
//      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
//    end;
//Local procedure ShowReturnOrders();
//    begin
//      CurrentPurchLine := Rec;
//      PurchLine.RESET;
//      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::"Return Order");
//      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
//    end;
//Local procedure ShowCreditMemos();
//    begin
//      CurrentPurchLine := Rec;
//      PurchLine.RESET;
//      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
//      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::"Credit Memo");
//      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
//    end;
//Local procedure ShowPostedReceipts();
//    var
//      PurchRcptLine : Record 121;
//    begin
//      CurrentPurchLine := Rec;
//      PurchRcptLine.RESET;
//      PurchRcptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      PurchRcptLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchRcptLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Purchase Receipt Lines",PurchRcptLine);
//    end;
//Local procedure ShowPostedInvoices();
//    var
//      PurchInvLine : Record 123;
//    begin
//      CurrentPurchLine := Rec;
//      PurchInvLine.RESET;
//      PurchInvLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      PurchInvLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchInvLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines",PurchInvLine);
//    end;
//Local procedure ShowPostedReturnReceipts();
//    var
//      ReturnShptLine : Record 6651;
//    begin
//      CurrentPurchLine := Rec;
//      ReturnShptLine.RESET;
//      ReturnShptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      ReturnShptLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      ReturnShptLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Return Shipment Lines",ReturnShptLine);
//    end;
//Local procedure ShowPostedCreditMemos();
//    var
//      PurchCrMemoLine : Record 125;
//    begin
//      CurrentPurchLine := Rec;
//      PurchCrMemoLine.RESET;
//      PurchCrMemoLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
//      PurchCrMemoLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
//      PurchCrMemoLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
//      PAGE.RUNMODAL(PAGE::"Posted Purchase Cr. Memo Lines",PurchCrMemoLine);
//    end;
//Local procedure NoOnAfterValidate();
//    begin
//      InsertExtendedText(FALSE);
//    end;
//Local procedure CrossReferenceNoOnAfterValidat();
//    begin
//      InsertExtendedText(FALSE);
//    end;
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(3,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",'',0);
//      DocumentLineTracking.RUNMODAL;
//    end;
//
//    [Integration]
//Local procedure OnBeforeInsertExtendedText(var PurchaseLine : Record 39);
//    begin
//    end;
//
//    [Integration]
//Local procedure OnCrossReferenceNoOnLookup(var PurchaseLine : Record 39);
//    begin
//    end;
LOCAL procedure ValidateSaveShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
      rec.ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
      CurrPage.SAVERECORD;
    end;

//procedure
}

