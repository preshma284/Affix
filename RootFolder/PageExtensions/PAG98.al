pageextension 50295 MyExtension98 extends 98//39
{
layout
{
addfirst("Control1")
{
//     field("Job No.";rec."Job No.")
//     {
        
//                 ToolTipML=ENU='Specif( ies the number of the related job. If you fill in this field and the Job Task No. field,  )then a job ledger entry will be posted together with the purchase line.',ESP='Especifica el n£mero del proyecto relacionado. Si rellena este campo y el campo N.§ tarea proyecto, se registrar  un movimiento de proyecto junto con la l¡nea de compra.';
//                 ApplicationArea=Jobs;
//                 Visible=seeJob;
                
//                             ;trigger OnValidate()    BEGIN
//                              rec.ShowShortcutDimCode(ShortcutDimCode);
//                            END;


// }
    field("QB_UO";rec."Piecework No.")
    {
        
                CaptionClass=txtPiecework ;
}
    field("QB CA Value";rec."QB CA Value")
    {
        
                ToolTipML=ESP='Contiene el Concepto anal¡tico que se va a asociar a la l¡nea. Se utiliza en lugar de la dimensi¢n para independizarnos de su n£mero';
}
} addafter("Nonstock")
{
    field("QB_GenBusPostingGroup";rec."Gen. Bus. Posting Group")
    {
        
                Visible=false;
                Editable=edAlbaran ;
}
    field("QB_GenProdPostingGroup";rec."Gen. Prod. Posting Group")
    {
        
                Visible=false;
                Editable=edAlbaran ;
}
} addafter("Line Amount")
{
    field("QW Not apply Withholding GE";rec."QW Not apply Withholding GE")
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
    field("Piecework No.";rec."Piecework No.")
    {
        
}
} addafter(ShortcutDimCode8)
{
    field("DP_NonDeductibleVATLine";rec."DP Non Deductible VAT Line")
    {
        
                ToolTipML=ESP='Este campo indica si la l¡nea tiene una parte del IVA no deducible que aumentar  el importe del gasto';
                Visible=seeNonDeductible ;
}
    field("DP_NonDeductibleVATPorc";rec."DP Non Deductible VAT %")
    {
        
                ToolTipML=ESP='Este campo indica el % no deducible de la l¡nea que aumentar  el improte del gasto';
                Visible=seeNonDeductible ;
}
    field("DP_DeductibleVATLine";rec."DP Deductible VAT Line")
    {
        
                ToolTipML=ESP='Este campo informa si la l¡nea es o no deducible a efectos de la prorrata de IVA';
                Visible=seeProrrata ;
}
    field("DP_ApplyProrrataType";rec."DP Apply Prorrata Type")
    {
        
                Visible=seeProrrata ;
}
    field("DP_ProrrataPerc";rec."DP Prorrata %")
    {
        
                Visible=seeProrrata ;
}
    field("DP_IVAOriginalAmountVAT";rec."DP VAT Amount")
    {
        
                Visible=seeProrrata ;
}
    field("DP_DeductibleVATAmount";rec."DP Deductible VAT amount")
    {
        
                Visible=seeProrrata OR seeNonDeductible ;
}
    field("DP_NonDeductibleVATAmount";rec."DP Non Deductible VAT amount")
    {
        
                Visible=seeProrrata OR seeNonDeductible ;
}
} addafter("Control47")
{
group("QB_Totales")
{
        
group("Control1100286007")
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
group("Control1100286003")
{
        
    field("QB_Total";"QB_Total")
    {
        
                CaptionML=ENU='TOTAL',ESP='TOTAL ABONO';
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
        
                CaptionML=ENU='TOTAL',ESP='TOTAL PAGO';
                Editable=false;
                Style=Strong;
                StyleExpr=TRUE 

  ;
}
}
}
}


//modify("Quantity")
//{
//
//
//}
//

//modify("Direct Unit Cost")
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

modify("Control47")
{
Visible=false;


}


modify("Control41")
{
Visible=false;


}


modify("Control23")
{
Visible=false;


}

}

actions
{
addafter("DeferralSchedule")
{
    action("InsertAutoLine")
    {
        CaptionML=ESP='Insertar L¡nea Autom tica';
                      Promoted=true;
                      Visible=seeInsertLineAuto;
                      PromotedIsBig=true;
                      PromotedCategory=Process;
                      PromotedOnly=true;
}
}
addafter("InsertExtTexts"){
  action("Action1902740304")
            {
                AccessByPermission = TableData 348 = R;
                ShortCutKey = 'Shift+Ctrl+D';
                CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el  rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                ApplicationArea = Dimensions;
                Image = Dimensions;
                trigger OnAction()
                BEGIN
                    rec.ShowDimensions;
                END;
            }
}


}

//trigger
trigger OnOpenPage()    BEGIN
                 //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                 seeQPR := FunctionQB.AccessToBudgets;
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);

                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
                 seeNonDeductible := DPManagement.AccessToNonDeductible;  //JAV 14/07/22: - DP 1.00.04 Se a¤ade el IVA no deducible
               END;
trigger OnAfterGetRecord()    BEGIN
                       rec.ShowShortcutDimCode(ShortcutDimCode);
                       CLEAR(DocumentTotals);
                       UpdateTypeText;
                       SetItemChargeFieldsStyle;

                       //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
                       QB_SetEditable;
                       QRE_seeInsertLineAuto;
                       //QRE15449-INI
                       QBPurchLineExt.Read(Rec);
                       //QRE15449-FIN
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
                           GetTotalPurchHeader;
                           CalculateTotals;
                           UpdateEditableOnRow;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;

                           //Calcular totales del documento
                           QB_CalculateDocTotals;
                           QB_SetEditable; //QPR Q15434
                           QRE_seeInsertLineAuto;
                         END;


//trigger

var
      TotalPurchaseHeader : Record 38;
      TotalPurchaseLine : Record 39;
      Currency : Record 4;
      PurchasesPayablesSetup : Record 312;
      TempOptionLookupBuffer : Record 1670 TEMPORARY ;
      TransferExtendedText : Codeunit 378;
      ItemAvailFormsMgt : Codeunit 353;
      PurchCalcDiscByType : Codeunit 66;
      DocumentTotals : Codeunit 57;
      ShortcutDimCode : ARRAY [8] OF Code[20];
      Text000 : TextConst ENU='Unable to run this function while in View mode.',ESP='No es posible ejecutar esta funci¢n en el modo Ver.';
      VATAmount : Decimal;
      InvoiceDiscountAmount : Decimal;
      InvoiceDiscountPct : Decimal;
      AmountWithDiscountAllowed : Decimal;
      InvDiscAmountEditable : Boolean;
      UpdateAllowedVar : Boolean;
      TypeAsText : Text[30];
      ItemChargeStyleExpression : Text;
      UnitofMeasureCodeIsChangeable : Boolean;
      IsFoundation : Boolean;
      IsCommentLine : Boolean;
      CurrPageIsEditable : Boolean;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';
      "----------------------------- QB" : Integer;
      decAmountVATGE : Decimal;
      decAmountBaseGE : Decimal;
      decAmountVATPIT : Decimal;
      decAmountBasePIT : Decimal;
      decCalculateBaseGE : Decimal;
      decCalculateBasePIT : Decimal;
      QBPagePublisher : Codeunit 7207348;
      PurchHeaderRec : Record 38;
      WithholdingTreating : Codeunit 7207306;
      QPRPageSubscriber : Codeunit 7238190;
      TotalDocument : Decimal;
      TotalPay : Decimal;
      FunctionQB : Codeunit 7207272;
      txtPiecework : Text[80];
      seeJob : Boolean;
      seeQB : Boolean;
      seeQPR : Boolean;
      edAlbaran : Boolean;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      seeNonDeductible : Boolean;
      seeNonDeductibleAmounts : Boolean;
      "------------------------------------ QB Totales" : Integer;
      QB_Base : Decimal;
      QB_IVA : Decimal;
      QB_IRPF : Decimal;
      QB_Total : Decimal;
      QB_Ret : Decimal;
      QB_Pagar : Decimal;
      "-------------------------------------------QRE" : Integer;
      QREFunctions : Codeunit 7238197;
      QBPurchLineExt : Record 7238729;
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
//
//    //[External]
//procedure CalcInvDisc();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",Rec);
//      DocumentTotals.PurchaseDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure ExplodeBOM();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
//      DocumentTotals.PurchaseDocTotalsNotUpToDate;
//    end;
//
//    //[External]
//procedure GetReturnShipment();
//    begin
//      CODEUNIT.RUN(CODEUNIT::"Purch.-Get Return Shipments",Rec);
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
//procedure ItemChargeAssgnt();
//    begin
//      rec.ShowItemChargeAssgnt;
//    end;
//
//    //[External]
//procedure OpenItemTrackingLines();
//    begin
//      rec.OpenItemTrackingLines;
//    end;
//
//    //[External]
//procedure UpdateForm(SetSaveRecord : Boolean);
//    begin
//      CurrPage.UPDATE(SetSaveRecord);
//    end;
//
//    //[External]
//procedure SetUpdateAllowed(UpdateAllowed : Boolean);
//    begin
//      UpdateAllowedVar := UpdateAllowed;
//    end;
//
//    //[External]
//procedure UpdateAllowed() : Boolean;
//    begin
//      if ( UpdateAllowedVar = FALSE  )then begin
//        MESSAGE(Text000);
//        exit(FALSE);
//      end;
//      exit(TRUE);
//    end;
//
//    //[External]
//procedure ShowLineComments();
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
Local procedure GetTotalPurchHeader();
   begin
     DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec,TotalPurchaseHeader,Currency);
   end;
LOCAL procedure CalculateTotals();
    begin
      DocumentTotals.PurchaseCheckIfDocumentChanged(Rec,xRec);
      DocumentTotals.CalculatePurchaseSubPageTotals(
        TotalPurchaseHeader,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct);
      DocumentTotals.RefreshPurchaseLine(Rec);

      //JAV 18/08/19: - Calculo del total de retenciones
      TotalPurchaseHeader.CALCFIELDS("QW Base Withholding GE", "QW Base Withholding PIT", "QW Total Withholding GE", "QW Total Withholding PIT");

      TotalDocument := TotalPurchaseLine.Amount + VATAmount - TotalPurchaseHeader."QW Total Withholding PIT";
      TotalPay := TotalDocument - TotalPurchaseHeader."QW Total Withholding GE";
    end;
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
//      if ( rec."Type" <> rec."Type"::" "  )then
//        UnitofMeasureCodeIsChangeable := rec.CanEditUnitOfMeasureCode
//      ELSE
//        UnitofMeasureCodeIsChangeable := FALSE;
//
//      IsCommentLine := rec."Type" = rec."Type"::" ";
//      CurrPageIsEditable := CurrPage.EDITABLE;
//      InvDiscAmountEditable := CurrPageIsEditable and not PurchasesPayablesSetup."Calc. Inv. Discount";
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
LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    begin
      //JAV 05/02/22: - QB 1.10.17 Si viene de un albar n algunos campos no ser n nunca editables
      edAlbaran := (rec."Receipt Line No." = 0);

      //JAV 27/10/21: - QB 1.09.25 Ver columnas seg£n tipo de proyecto
      seeQPR := FunctionQB.Job_IsBudget(Rec."Job No.");
      seeQB := not seeQPR;
    end;
LOCAL procedure QB_UpdateLineTotals();
    begin
      //JAV 18/08/19: - Actualizo los totales al modificar el importe de la l¡nea
      if ( Rec.MODIFY(TRUE)  )then ; // Esto calcula las retenciones al llamar a la siguiente funci¢n el onaftgergetcurrentrecord
    end;
procedure QB_CalculateDocTotals();
    var
      qbPurchaseHeader : Record 38;
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      if ( (qbPurchaseHeader.GET(rec."Document Type",rec."Document No."))  )then begin
        qbPurchaseHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

        QB_Base  := qbPurchaseHeader.Amount;
        QB_IVA   := qbPurchaseHeader."Amount Including VAT" - qbPurchaseHeader.Amount;
        QB_IRPF  := qbPurchaseHeader."QW Total Withholding PIT";
        QB_Total := QB_Base + QB_IVA - QB_IRPF;
        QB_Ret   := qbPurchaseHeader."QW Total Withholding GE";
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
procedure QB_GetTotal() : Decimal;
    begin
      exit(QB_Pagar);
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
LOCAL procedure "------------------------------------QRE"();
    begin
    end;
LOCAL procedure SaveExtRec();
    begin
      QBPurchLineExt.MODIFY(TRUE);
    end;
LOCAL procedure QRE_seeInsertLineAuto();
    var
      QuoBuildingSetup : Record 7207278;
      PurchaseHeader : Record 38;
    begin
      seeInsertLineAuto := FALSE;

      if ( FunctionQB.Job_IsBudget(Rec."Job No.")  )then begin
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
    end;

//procedure
}

