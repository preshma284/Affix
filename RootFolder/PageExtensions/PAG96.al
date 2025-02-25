pageextension 50294 MyExtension96 extends 96//37
{
layout
{
addafter("Line Amount")
{
    field("QW Not apply Withholding by GE";rec."QW Not apply Withholding by GE")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
                             QB_UpdateLineTotals;
                           END;


}
    field("QW % Withholding by GE";rec."QW % Withholding by GE")
    {
        
}
    field("QW Withholding Amount by GE";rec."QW Withholding Amount by GE")
    {
        
}
    field("QW Not apply Withholding PIT";rec."QW Not apply Withholding PIT")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
                             QB_UpdateLineTotals;
                           END;


}
    field("QW % Withholding by PIT";rec."QW % Withholding by PIT")
    {
        
}
    field("QW Withholding Amount by PIT";rec."QW Withholding Amount by PIT")
    {
        
}
} addafter("Qty. Assigned")
{
//     field("Job No.";rec."Job No.")
//     {
        
//                 ToolTipML=ENU='Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the sales line.',ESP='Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de ventas.';
//                 ApplicationArea=Jobs;
//                 Visible=seeJob;
                
//                             ;trigger OnValidate()    BEGIN
//                              rec.ShowShortcutDimCode(ShortcutDimCode);

//                              //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
//                              QB_SetEditable;
//                            END;


// }
    field("QB_Piecework No.";rec."QB_Piecework No.")
    {
        
                Visible=seeQPR;
                Enabled=edqpr ;
}
} addafter("Control39")
{
group("QB_Totales")
{
        
group("Control1100286008")
{
        
    field("QB_Base";"QB_Base")
    {
        
                CaptionML=ENU='Total Withholding G.E',ESP='Base Imponible';
                Editable=false ;
}
    field("QB_IVA";"QB_IVA")
    {
        
                CaptionML=ENU='Total Withholding G.E',ESP='IVA';
                Editable=false ;
}
    field("QB_IRPF";"QB_IRPF")
    {
        
                CaptionML=ENU='Total Withholding PIT',ESP='IRPF';
                Editable=false ;
}
}
group("Control1100286004")
{
        
    field("QB_Total";"QB_Total")
    {
        
                CaptionML=ENU='TOTAL',ESP='TOTAL FACTURA';
                Editable=false;
                Style=Strong;
                StyleExpr=TRUE ;
}
    field("QB_Ret";"QB_Ret")
    {
        
                CaptionML=ENU='Total Withholding G.E',ESP='Retenci¢n Pago';
                Editable=false ;
}
    field("QB_Pagar";"QB_Pagar")
    {
        
                CaptionML=ENU='TOTAL',ESP='TOTAL A PAGAR';
                Editable=false;
                Style=Strong;
                StyleExpr=TRUE 

  ;
}
}
}
}


//modify("No.")
//{
//
//
//}
//

//modify("Quantity")
//{
//
//
//}
//

//modify("Unit Price")
//{
//
//
//}
//

//modify("Line Discount %")
//{
//
//
//}
//

modify("Control39")
{
Visible=false;


}


modify("Control35")
{
Visible=false;


}


modify("Control17")
{
Visible=false;


}

}

actions
{
addafter("Get Return &Receipt Lines")
{
    action("QB_BringCertifications")
    {
        
                      CaptionML=ENU='Bring Certifications',ESP='Traer ce&rtificaciones';
                      Image=CheckLedger;
                      promoted = true;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 QB_BringCertifications;
                               END;


}
}

}

//trigger
trigger OnOpenPage()    VAR
                 Location : Record 14;
               BEGIN
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
                           UpdateEditableOnRow;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;

                           //Calcular totales del documento
                           QB_CalculateDocTotals;

                           //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                           QB_SetEditable;
                         END;


//trigger

var
      TotalSalesHeader : Record 36;
      TotalSalesLine : Record 37;
      SalesSetup : Record 311;
      Currency : Record 4;
      TempOptionLookupBuffer : Record 1670 TEMPORARY ;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      SalesCalcDiscountByType : Codeunit 56;
      DocumentTotals : Codeunit 57;
      VATAmount : Decimal;
      AmountWithDiscountAllowed : Decimal;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      InvDiscAmountEditable : Boolean;
      UnitofMeasureCodeIsChangeable : Boolean;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      IsFoundation : Boolean;
      IsCommentLine : Boolean;
      CurrPageIsEditable : Boolean;
      TypeAsText : Text[30];
      ItemChargeStyleExpression : Text;
      "-------------------------------------- QB" : Integer;
      WithholdingTreating : Codeunit 7207306;
      TotalDocument : Decimal;
      TotalPay : Decimal;
      seeJob : Boolean;
      seeQB : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      FunctionQB : Codeunit 7207272;
      txtPiecework : Text[80];
      "--------------------- QuoSII" : Integer;
      vQuoSII : Boolean;
      "------------------------------------ QB" : Integer;
      QB_Base : Decimal;
      QB_IVA : Decimal;
      QB_IRPF : Decimal;
      QB_Total : Decimal;
      QB_Ret : Decimal;
      QB_Pagar : Decimal;

    

//procedure
//procedure ApproveCalcInvDisc();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//Local procedure ExplodeBOM();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
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
//Local procedure GetReturnReceipt();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Sales-Get Return Receipts",Rec);
//      DocumentTotals.SalesDocTotalsNotUpToDate;
//    end;
//Local procedure InsertExtendedText(Unconditionally : Boolean);
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
//Local procedure OpenItemTrackingLines();
//    begin
//      rec.OpenItemTrackingLines;
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
//Local procedure ShowLineComments();
//    begin
//      rec.ShowLineComments;
//    end;
//Local procedure NoOnAfterValidate();
//    begin
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
//Local procedure ReserveOnAfterValidate();
//    begin
//      if ( (rec."Reserve" = rec."Reserve"::Always) and (rec."Outstanding Qty. (Base)" <> 0)  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//    end;
//Local procedure QuantityOnAfterValidate();
//    begin
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//      DeltaUpdateTotals;
//    end;
//Local procedure UnitofMeasureCodeOnAfterValida();
//    begin
//      if ( rec."Reserve" = rec."Reserve"::Always  )then begin
//        CurrPage.SAVERECORD;
//        rec.AutoReserve;
//      end;
//      DeltaUpdateTotals;
//    end;
//Local procedure UpdateEditableOnRow();
//    begin
//      IsCommentLine := not rec.HasTypeToFillMandatoryFields;
//      UnitofMeasureCodeIsChangeable := not IsCommentLine;
//
//      CurrPageIsEditable := CurrPage.EDITABLE;
//      InvDiscAmountEditable := CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount";
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
Local procedure GetTotalSalesHeader();
   begin
     DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec,TotalSalesHeader,Currency);
   end;
//Local procedure ValidateInvoiceDiscountAmount();
//    var
//      SalesHeader : Record 36;
//    begin
//      SalesHeader.GET(rec."Document Type",rec."Document No.");
//      SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
//      CurrPage.UPDATE(FALSE);
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
LOCAL procedure "-------------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    begin
      //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
      edQPR := FunctionQB.Job_IsBudget(Rec."Job No.");
    end;
procedure QB_BringCertifications();
    begin
      CODEUNIT.RUN(CODEUNIT::"Bring Certifications",Rec);
    end;
LOCAL procedure QB_UpdateLineTotals();
    begin
      //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
      if ( Rec.MODIFY(TRUE)  )then ; // Esto calcula las retenciones
    end;
LOCAL procedure QB_CalculateDocTotals();
    var
      qbSalesHeader : Record 36;
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      if ( (qbSalesHeader.GET(rec."Document Type",rec."Document No."))  )then begin
        qbSalesHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

        QB_Base  := qbSalesHeader.Amount;
        QB_IVA   := qbSalesHeader."Amount Including VAT" - qbSalesHeader.Amount;
        QB_IRPF  := qbSalesHeader."QW Total Withholding PIT";
        QB_Total := QB_Base + QB_IVA - QB_IRPF;
        QB_Ret   := qbSalesHeader."QW Total Withholding GE";
        QB_Pagar := QB_Total - QB_Ret;
      end ELSE begin
        QB_Base  := 0;
        QB_IVA   := 0;
        QB_IRPF  := 0;
        QB_Total := 0;
        QB_Ret   := 0;
        QB_Pagar := 0;
      end;
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

