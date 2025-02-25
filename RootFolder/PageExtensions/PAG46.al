pageextension 50198 MyExtension46 extends 46//37
{
layout
{
addafter("Line Amount")
{
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
} addafter("Shipping Time")
{
    field("Job No.";rec."Job No.")
    {
        
                ToolTipML=ENU='Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the sales line.',ESP='Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de ventas.';
                ApplicationArea=Jobs;
                Visible=seeJob;
                
                            ;trigger OnValidate()    BEGIN
                             rec.ShowShortcutDimCode(ShortcutDimCode);

                             //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                             QB_SetEditable;
                           END;


}
    field("QB_UO";rec."QB_Piecework No.")
    {
        
                CaptionClass=txtPiecework ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 Location : Record 14;
               BEGIN
                 IF Location.READPERMISSION THEN
                   LocationCodeVisible := NOT Location.ISEMPTY;

                 //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                 seeQPR := FunctionQB.AccessToBudgets;
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
               END;
trigger OnAfterGetRecord()    BEGIN
                       rec.ShowShortcutDimCode(ShortcutDimCode);
                       UpdateTypeText;
                       SetItemChargeFieldsStyle;

                       //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           GetTotalSalesHeader;
                           CalculateTotals;
                           SetLocationCodeMandatory;
                           UpdateEditableOnRow;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;

                           //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                           QB_SetEditable;
                         END;


//trigger

var
      Currency : Record 4;
      TotalSalesHeader : Record 36;
      TotalSalesLine : Record 37;
      SalesHeader : Record 36;
      SalesSetup : Record 311;
      InventorySetup : Record 313;
      TempOptionLookupBuffer : Record 1670 TEMPORARY ;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      SalesPriceCalcMgt : Codeunit 7000;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      SalesCalcDiscountByType : Codeunit 56;
      DocumentTotals : Codeunit 57;
      VATAmount : Decimal;
      AmountWithDiscountAllowed : Decimal;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      Text001 : TextConst ENU='You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.',ESP='No puede usar la funci¢n Desplegar L.M. puesto que se ha facturado un prepago del pedido de venta.';
      LocationCodeMandatory : Boolean;
      InvDiscAmountEditable : Boolean;
      UnitofMeasureCodeIsChangeable : Boolean;
      LocationCodeVisible : Boolean;
      IsFoundation : Boolean;
      IsCommentLine : Boolean;
      CurrPageIsEditable : Boolean;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';
      ItemChargeStyleExpression : Text;
      TypeAsText : Text[30];
      "------------------------------------ QB" : Integer;
      seeJob : Boolean;
      seeQB : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      FunctionQB : Codeunit 7207272;
      txtPiecework : Text[80];
      "--------------------- QuoSII" : Integer;
      vQuoSII : Boolean;

    

//procedure
//procedure ApproveCalcInvDisc();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//Local procedure ValidateInvoiceDiscountAmount();
//    var
//      SalesHeader : Record 36;
//      ConfirmManagement : Codeunit 27;
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      if ( SalesHeader.InvoicedLineExists  )then
//        if ( not ConfirmManagement.ConfirmProcess(UpdateInvDiscountQst,TRUE)  )then
//          exit;
//
//      SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//      CurrPage.UPDATE(FALSE);
//    end;
//
//    //[External]
//procedure CalcInvDisc();
//    var
//      SalesCalcDiscount : Codeunit 60;
//    begin
//      SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure ExplodeBOM();
//    begin
//      if ( rec."Prepmt. Amt. Inv." <> 0  )then
//        ERROR(Text001);
//      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure OpenPurchOrderForm();
//    var
//      PurchHeader : Record 38;
//      PurchOrder : Page 50;
//    begin
//      Rec.TESTfield("Purchase Order No.");
//      PurchHeader.SETRANGE("No.",rec."Purchase Order No.");
//      PurchOrder.SETTABLEVIEW(PurchHeader);
//      PurchOrder.EDITABLE := FALSE;
//      PurchOrder.RUN;
//    end;
//
//    //[External]
//procedure OpenSpecialPurchOrderForm();
//    var
//      PurchHeader : Record 38;
//      PurchRcptHeader : Record 120;
//      PurchOrder : Page 50;
//    begin
//      Rec.TESTfield("Special Order Purchase No.");
//      PurchHeader.SETRANGE("No.",rec."Special Order Purchase No.");
//      if ( not PurchHeader.ISEMPTY  )then begin
//        PurchOrder.SETTABLEVIEW(PurchHeader);
//        PurchOrder.EDITABLE := FALSE;
//        PurchOrder.RUN;
//      end ELSE begin
//        PurchRcptHeader.SETRANGE("Order No.",rec."Special Order Purchase No.");
//        if ( PurchRcptHeader.COUNT = 1  )then
//          PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
//        ELSE
//          PAGE.RUN(PAGE::"Posted Purchase Receipts",PurchRcptHeader);
//      end;
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
//procedure ShowNonstockItems();
//    begin
//      rec.ShowNonstock;
//    end;
//
//    //[External]
//procedure ShowTracking();
//    var
//      TrackingForm : Page 99000822;
//    begin
//      TrackingForm.SetSalesLine(Rec);
//      TrackingForm.RUNMODAL;
//    end;
//
//    //[External]
//procedure ItemChargeAssgnt();
//    begin
//      rec.ShowItemChargeAssgnt;
//    end;
//
//    //[External]
//procedure UpdateForm(SetSaveRecord : Boolean);
//    begin
//      CurrPage.UPDATE(SetSaveRecord);
//    end;
//
//    //[External]
//procedure ShowPrices();
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      CLEAR(SalesPriceCalcMgt);
//      SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
//    end;
//
//    //[External]
//procedure ShowLineDisc();
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      CLEAR(SalesPriceCalcMgt);
//      SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
//    end;
//
//    //[External]
//procedure OrderPromisingLine();
//    var
//      OrderPromisingLine : Record 99000880 TEMPORARY ;
//      OrderPromisingLines : Page 99000959;
//    begin
//      OrderPromisingLine.SETRANGE("Source Type",rec."Document Type");
//      OrderPromisingLine.SETRANGE("Source ID",rec."Document No.");
//      OrderPromisingLine.SETRANGE("Source Line No.",rec."Line No.");
//
//      OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
//      OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
//      OrderPromisingLines.RUNMODAL;
//    end;
//Local procedure NoOnAfterValidate();
//    begin
//      InsertExtendedText(FALSE);
//      if (rec."Type" = rec."Type"::"Charge (Item)") and (rec."No." <> xRec."No.") and
//         (xRec."No." <> '')
//      then
//        CurrPage.SAVERECORD;
//
//      SaveAndAutoAsmToOrder;
//
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        if ( (rec."Outstanding Qty. (Base)" <> 0) and (rec."No." <> xRec."No.")  )then begin
//          rec.AutoReserve;
//          CurrPage.UPDATE(FALSE);
//        end;
//      end;
//    end;
//Local procedure VariantCodeOnAfterValidate();
//    begin
//      SaveAndAutoAsmToOrder;
//    end;
//Local procedure LocationCodeOnAfterValidate();
//    begin
//      SaveAndAutoAsmToOrder;
//
//      if (rec."Reserve" = rec."Reserve"::Always) and
//         (rec."Outstanding Qty. (Base)" <> 0) and
//         (rec."Location Code" <> xRec."Location Code")
//      then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure ReserveOnAfterValidate();
//    begin
//      if ( (rec."Reserve" = rec."Reserve"::Always) and (rec."Outstanding Qty. (Base)" <> 0)  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//    end;
//Local procedure QuantityOnAfterValidate();
//    begin
//      if ( rec."Type" = rec."Type"::Item  )then
//        CASE Reserve OF
//          rec."Reserve"::Always:
//            begin
//              CurrPage.SAVERECORD;
//              rec.AutoReserve;
//            end;
//        end;
//
//      OnAfterQuantityOnAfterValidate(Rec,xRec);
//    end;
//Local procedure QtyToAsmToOrderOnAfterValidate();
//    begin
//      CurrPage.SAVERECORD;
//      if ( rec."Reserve" = rec."Reserve"::Always  )then
//        rec.AutoReserve;
//      CurrPage.UPDATE(TRUE);
//    end;
//Local procedure UnitofMeasureCodeOnAfterValida();
//    begin
//      DeltaUpdateTotals;
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure ShipmentDateOnAfterValidate();
//    begin
//      if (rec."Reserve" = rec."Reserve"::Always) and
//         (rec."Outstanding Qty. (Base)" <> 0) and
//         (rec."Shipment Date" <> xRec."Shipment Date")
//      then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//        CurrPage.UPDATE(FALSE);
//      end ELSE
//        CurrPage.UPDATE(TRUE);
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
//      DocumentLineTracking.SetDoc(0,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",'',0);
//      DocumentLineTracking.RUNMODAL;
//    end;
Local procedure SetLocationCodeMandatory();
   begin
     LocationCodeMandatory := InventorySetup."Location Mandatory" and (rec."Type" = rec."Type"::Item);
   end;
Local procedure GetTotalSalesHeader();
   begin
     DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec,TotalSalesHeader,Currency);
   end;
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
//      IsCommentLine := not rec.HasTypeToFillMandatoryFields;
//      UnitofMeasureCodeIsChangeable := not IsCommentLine;
//
//      CurrPageIsEditable := CurrPage.EDITABLE;
//      InvDiscAmountEditable := CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount";
//    end;
//Local procedure UpdateTypeText();
//    var
//      RecRef : RecordRef;
//    begin
//      if ( not IsFoundation  )then
//        exit;
//      RecRef.GETTABLE(Rec);
//      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.field(FIELDNO(rec."Type")));
//    end;
Local procedure SetItemChargeFieldsStyle();
   begin
     ItemChargeStyleExpression := '';
     if ( rec.AssignedItemCharge and (rec."Qty. Assigned" <> rec."Quantity")  )then
       ItemChargeStyleExpression := 'Unfavorable';
   end;
//Local procedure ValidateShortcutDimension(DimIndex : Integer);
//    var
//      AssembleToOrderLink : Record 904;
//    begin
//      rec.ValidateShortcutDimCode(DimIndex,ShortcutDimCode[DimIndex]);
//      AssembleToOrderLink.UpdateAsmDimFromSalesLine(Rec);
//    end;
//
//    [Integration]
//Local procedure OnAfterQuantityOnAfterValidate(var SalesLine : Record 37;xSalesLine : Record 37);
//    begin
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
LOCAL procedure "------------------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    begin
      //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
      edQPR := FunctionQB.Job_IsBudget(Rec."Job No.");
    end;
procedure QB_SetTxtPiecework(Job : Code[20]);
    begin
      if ( (Job = '')  )then
        Job := Rec."Job No.";

      if ( (FunctionQB.Job_IsBudget(Job))  )then
        txtPiecework := 'Partida Presupuestaria'
      ELSE
        txtPiecework := 'Unidad de Obra';
      CurrPage.UPDATE(FALSE);
    end;

//procedure
}

