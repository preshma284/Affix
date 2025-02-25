pageextension 50245 MyExtension6631 extends 6631//37
{
layout
{
addafter("Qty. Assigned")
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
                           UpdateCurrency;

                           //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                           QB_SetEditable;
                         END;


//trigger

var
      Currency : Record 4;
      TotalSalesHeader : Record 36;
      TotalSalesLine : Record 37;
      SalesSetup : Record 311;
      TempOptionLookupBuffer : Record 1670 TEMPORARY ;
      ApplicationAreaMgmtFacade : Codeunit 9179;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      SalesCalcDiscByType : Codeunit 56;
      DocumentTotals : Codeunit 57;
      VATAmount : Decimal;
      AmountWithDiscountAllowed : Decimal;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      LocationCodeMandatory : Boolean;
      InvDiscAmountEditable : Boolean;
      TypeAsText : Text[30];
      ItemChargeStyleExpression : Text;
      IsFoundation : Boolean;
      UnitofMeasureCodeIsChangeable : Boolean;
      LocationCodeVisible : Boolean;
      IsCommentLine : Boolean;
      CurrPageIsEditable : Boolean;
      "----------------------------- QB" : Integer;
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
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//      CurrPage.UPDATE(FALSE);
//    end;
//
//    //[External]
//procedure CalcInvDisc();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//Local procedure ExplodeBOM();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure InsertExtendedText(Unconditionally : Boolean);
//    var
//      IsHandled : Boolean;
//    begin
//      IsHandled := FALSE;
//      OnBeforeInsertExtendedText(Rec,IsHandled);
//      if ( IsHandled  )then
//        exit;
//
//      if ( TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally)  )then begin
//        CurrPage.SAVERECORD;
//        COMMIT;
//        TransferExtendedText.InsertSalesExtText(Rec);
//      end;
//      if ( TransferExtendedText.MakeUpdate  )then
//        UpdateForm(TRUE);
//    end;
//Local procedure PageShowReservation();
//    begin
//      Rec.FIND;
//      rec.ShowReservation;
//    end;
//Local procedure ShowTracking();
//    var
//      TrackingForm : Page 99000822;
//    begin
//      TrackingForm.SetSalesLine(Rec);
//      TrackingForm.RUNMODAL;
//    end;
//Local procedure ItemChargeAssgnt();
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
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(8,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",'',0);
//      DocumentLineTracking.RUNMODAL;
//    end;
//Local procedure NoOnAfterValidate();
//    begin
//      InsertExtendedText(FALSE);
//      if (rec."Type" = rec."Type"::"Charge (Item)") and (rec."No." <> xRec."No.") and
//         (xRec."No." <> '')
//      then
//        CurrPage.SAVERECORD;
//    end;
//Local procedure LocationCodeOnAfterValidate();
//    begin
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
//        CurrPage.UPDATE(FALSE);
//      end;
//    end;
//Local procedure QuantityOnAfterValidate();
//    begin
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
//Local procedure UnitofMeasureCodeOnAfterValida();
//    begin
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//    end;
Local procedure SetLocationCodeMandatory();
   var
     InventorySetup : Record 313;
   begin
     InventorySetup.GET;
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
//Local procedure ReverseReservedQtySign() : Decimal;
//    begin
//      Rec.CALCFIELDS("Reserved Quantity");
//      exit(-rec."Reserved Quantity");
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
//
//      RecRef.GETTABLE(Rec);
//      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.field(FIELDNO(rec."Type")));
//    end;
Local procedure SetItemChargeFieldsStyle();
   begin
     ItemChargeStyleExpression := '';
     if ( rec.AssignedItemCharge  )then
       ItemChargeStyleExpression := 'Unfavorable';
   end;
Local procedure UpdateCurrency();
   begin
     if ( Currency.Code <> TotalSalesHeader."Currency Code"  )then
       if ( not Currency.GET(TotalSalesHeader."Currency Code")  )then begin
         CLEAR(Currency);
         Currency.InitRoundingPrecision;
       end
   end;
//
//    [Integration]
//Local procedure OnBeforeInsertExtendedText(var SalesLine : Record 37;var IsHandled : Boolean);
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

