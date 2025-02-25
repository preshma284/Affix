pageextension 50247 MyExtension6641 extends 6641//39
{
layout
{
addfirst("Control1")
{
    field("QB_Job";rec."Job No.")
    {
        
                ToolTipML=ENU='Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the purchase line.',ESP='Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ de unidad de Obra, N§ Partida Presupuestaria o N§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de compra.';
                ApplicationArea=Jobs;
                
                            ;trigger OnValidate()    BEGIN
                             rec.ShowShortcutDimCode(ShortcutDimCode);

                             //JAV 28/04/22: - QB 1.10.37 Refrescar el cambio de dimensi¢n en la pantalla
                             CurrPage.UPDATE;
                           END;


}
    field("QB_UO";rec."Piecework No.")
    {
        
                CaptionClass=txtPiecework;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 28/04/22: - QB 1.10.37 Refrescar el cambio de dimensi¢n en la pantalla
                             rec.ShowShortcutDimCode(ShortcutDimCode);
                             CurrPage.UPDATE;
                           END;


}
    field("QB CA Value";rec."QB CA Value")
    {
        
                ToolTipML=ESP='Contiene el Concepto anal¡tico que se va a asociar a la l¡nea. Se utiliza en lugar de la dimensi¢n para independizarnos de su n£mero';
}
} addafter("Line Amount")
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
}

}

actions
{
addfirst("Processing")
{    action("InsertAutoLine")
    {
        CaptionML=ESP='Insertar L¡nea Autom tica';
                      Promoted=true;
                      PromotedIsBig=true;
                      PromotedCategory=Process;
                      PromotedOnly=true;
}
}

}

//trigger
trigger OnOpenPage()    BEGIN
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
                       QRE_seeInsertLineAuto;
                     END;
trigger OnNewRecord(BelowxRec: Boolean)    VAR
                  ApplicationAreaMgmtFacade : Codeunit 9179;
                BEGIN
                  rec.InitType;
                  // Default to Item for the first line and to previous line type for the others
                  IF ApplicationAreaMgmtFacade.IsFoundationEnabled THEN
                    IF xRec."Document No." = '' THEN
                      rec."Type" := rec."Type"::Item;

                  CLEAR(ShortcutDimCode);
                  UpdateTypeText;

                  //JAV 23/05/22: - QB 1.10.42 Al inicializar el registro ponemos los valores de la cabecera y refrescamos las dimensiones, no puede usar el evento OnInit de la page porque se lanza despu‚s de este
                  QPRPageSubscriber.PurchaseLine_InitValues(Rec);
                  rec.ShowShortcutDimCode(ShortcutDimCode);
                END;
trigger OnAfterGetCurrRecord()    BEGIN
                           GetTotalsPurchaseHeader;
                           CalculateTotals;
                           UpdateEditableOnRow;
                           UpdateCurrency;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;

                           //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                           QB_SetEditable;
                           QRE_seeInsertLineAuto;
                         END;


//trigger

var
      TotalPurchaseHeader : Record 38;
      TotalPurchaseLine : Record 39;
      PurchHeader : Record 38;
      Currency : Record 4;
      PurchasesPayablesSetup : Record 312;
      TempOptionLookupBuffer : Record 1670 TEMPORARY ;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      ConnotExplodeBOMErr : TextConst ENU='You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.',ESP='No puede usar la funci¢n Desplegar L.M. puesto que se ha facturado un prepago del pedido de compra.';
      PurchCalcDiscByType : Codeunit 66;
      DocumentTotals : Codeunit 57;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      VATAmount : Decimal;
      AmountWithDiscountAllowed : Decimal;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      InvDiscAmountEditable : Boolean;
      TypeAsText : Text[30];
      ItemChargeStyleExpression : Text;
      IsCommentLine : Boolean;
      IsFoundation : Boolean;
      UnitofMeasureCodeIsChangeable : Boolean;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';
      CurrPageIsEditable : Boolean;
      "-------------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      QPRPageSubscriber : Codeunit 7238190;
      txtPiecework : Text[80];
      seeJob : Boolean;
      seeQB : Boolean;
      seeQPR : Boolean;
      seeInsertLineAuto : Boolean;

    

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
//      if ( rec."Prepmt. Amt. Inv." <> 0  )then
//        ERROR(ConnotExplodeBOMErr);
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
//Local procedure PageShowReservation();
//    begin
//      Rec.FIND;
//      rec.ShowReservation;
//    end;
//Local procedure ShowTracking();
//    var
//      TrackingForm : Page 99000822;
//    begin
//      TrackingForm.SetPurchLine(Rec);
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
//      DocumentLineTracking.SetDoc(9,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",'',0);
//      DocumentLineTracking.RUNMODAL;
//    end;
//Local procedure NoOnAfterValidate();
//    begin
//      UpdateEditableOnRow;
//      InsertExtendedText(FALSE);
//      if (rec."Type" = rec."Type"::"Charge (Item)") and (rec."No." <> xRec."No.") and
//         (xRec."No." <> '')
//      then
//        CurrPage.SAVERECORD;
//    end;
//Local procedure CrossReferenceNoOnAfterValidat();
//    begin
//      InsertExtendedText(FALSE);
//    end;
//Local procedure ReverseReservedQtySign() : Decimal;
//    begin
//      Rec.CALCFIELDS("Reserved Quantity");
//      exit(-rec."Reserved Quantity");
//    end;
Local procedure GetTotalsPurchaseHeader();
   begin
     DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec,TotalPurchaseHeader,Currency);
   end;
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
//      IsCommentLine := rec."Type" = rec."Type"::" ";
//      UnitofMeasureCodeIsChangeable := not IsCommentLine;
//      CurrPageIsEditable := CurrPage.EDITABLE;
//      InvDiscAmountEditable := CurrPageIsEditable and not PurchasesPayablesSetup."Calc. Inv. Discount";
//    end;
//Local procedure UpdateTypeText();
//    var
//      RecRef : RecordRef;
//    begin
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
     if ( Currency.Code <> TotalPurchaseHeader."Currency Code"  )then
       if ( not Currency.GET(TotalPurchaseHeader."Currency Code")  )then begin
         CLEAR(Currency);
         Currency.InitRoundingPrecision;
       end
   end;
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
LOCAL procedure "------------------------------------------ QB"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    begin
      //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
      seeQPR := FunctionQB.Job_IsBudget(Rec."Job No.");
      seeQB := not seeQPR;
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
LOCAL procedure QRE_seeInsertLineAuto();
    var
      QuoBuildingSetup : Record 7207278;
      PurchaseHeader : Record 38;
    begin
      seeInsertLineAuto := FALSE;

      QuoBuildingSetup.GET;
      PurchaseHeader.RESET;
      PurchaseHeader.SETRANGE("Document Type", Rec."Document Type");
      PurchaseHeader.SETRANGE("No.", Rec."Document No.");
      if ( PurchaseHeader.FINDFIRST  )then begin
        if (QuoBuildingSetup."QB_QPR Create Auto" <> QuoBuildingSetup."QB_QPR Create Auto"::None) and
           (PurchaseHeader."QB Budget item" <> '') and
           (PurchaseHeader."QB Job No." <> '')
        then
          seeInsertLineAuto := TRUE;
      end;
    end;

//procedure
}

