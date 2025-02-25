pageextension 50186 MyExtension398 extends 398//114
{
layout
{
addafter("TotalAdjCostLCY - CostLCY")
{
group("QB_Withholding")
{
        
                CaptionML=ENU='Withholdings',ESP='Retenci¢n B.E.';
    field("QB_decCalculateBaseGE";rec."QW Base Withholding GE" + 0)
    {
        
                CaptionML=ENU='Base Calculate GE',ESP='Base calculo BE';
                Editable=FALSE ;
}
    field("QB_WithholdingAmountGE";rec."QW Total Withholding GE" +  rec."QW Total Withholding GE Before")
    {
        
                CaptionML=ESP='Importe Retenci¢n';
}
}
group("QB_WithholdingPIT")
{
        
                CaptionML=ENU='Retenciones',ESP='Retenci¢n IRPF';
    field("QB_decCalculateBasePIT";rec."QW Base Withholding PIT" + 0)
    {
        
                CaptionML=ENU='Calculate Base PIT',ESP='Base calculo IRPF';
                Editable=FALSE ;
}
    field("QB_WithholdingAmountPIT";rec."QW Total Withholding PIT" + 0)
    {
        
                CaptionML=ENU='Total Withholding PIT',ESP='Importe Retenci¢n IRPF';
}
}
    field("QB_AmountToCollect";AmountInclVAT - rec."QW Total Withholding GE" - rec."QW Total Withholding PIT")
    {
        
                CaptionML=ESP='Total a Cobrar';
                Style=Strong;
                StyleExpr=TRUE ;
}
}

}

actions
{


}

//trigger
trigger OnAfterGetRecord()    VAR
                       CostCalcMgt : Codeunit 5836;
                       CustLedgEntry : Record 21;
                     BEGIN
                       CLEARALL;

                       IF rec."Currency Code" = '' THEN
                         Currency.InitRoundingPrecision
                       ELSE
                         Currency.GET(rec."Currency Code");

                       SalesCrMemoLine.SETRANGE("Document No.",rec."No.");
                       IF SalesCrMemoLine.FIND('-') THEN
                         REPEAT
                           CustAmount := CustAmount + SalesCrMemoLine.Amount;
                           AmountInclVAT := AmountInclVAT + SalesCrMemoLine."Amount Including VAT";
                           IF rec."Prices Including VAT" THEN BEGIN
                             InvDiscAmount := InvDiscAmount + SalesCrMemoLine."Inv. Discount Amount" /
                               (1 + (SalesCrMemoLine."VAT %" + SalesCrMemoLine."EC %") / 100);
                             PmtDiscAmount := PmtDiscAmount + SalesCrMemoLine."Pmt. Discount Amount" /
                               (1 + (SalesCrMemoLine."VAT %" + SalesCrMemoLine."EC %") / 100)
                           END ELSE BEGIN
                             InvDiscAmount := InvDiscAmount + SalesCrMemoLine."Inv. Discount Amount";
                             PmtDiscAmount := PmtDiscAmount + SalesCrMemoLine."Pmt. Discount Amount";
                           END;
                           CostLCY := CostLCY + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Cost (LCY)");
                           LineQty := LineQty + SalesCrMemoLine.Quantity;
                           TotalNetWeight := TotalNetWeight + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Net Weight");
                           TotalGrossWeight := TotalGrossWeight + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Gross Weight");
                           TotalVolume := TotalVolume + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Volume");
                           IF SalesCrMemoLine."Units per Parcel" > 0 THEN
                             TotalParcels := TotalParcels + ROUND(SalesCrMemoLine.Quantity / SalesCrMemoLine."Units per Parcel",1,'>');
                           IF SalesCrMemoLine."VAT %" <> VATpercentage THEN
                             IF VATpercentage = 0 THEN
                               VATpercentage := SalesCrMemoLine."VAT %" + SalesCrMemoLine."EC %"
                             ELSE
                               VATpercentage := -1;
                           TotalAdjCostLCY :=
                             TotalAdjCostLCY + CostCalcMgt.CalcSalesCrMemoLineCostLCY(SalesCrMemoLine) +
                             CostCalcMgt.CalcSalesCrMemoLineNonInvtblCostAmt(SalesCrMemoLine);
                         UNTIL SalesCrMemoLine.NEXT = 0;
                       VATAmount := AmountInclVAT - CustAmount;
                       InvDiscAmount := ROUND(InvDiscAmount,Currency."Amount Rounding Precision");

                       IF VATpercentage <= 0 THEN
                         VATAmountText := Text000
                       ELSE
                         VATAmountText := STRSUBSTNO(Text001,VATpercentage);

                       IF rec."Currency Code" = '' THEN
                         AmountLCY := CustAmount
                       ELSE
                         AmountLCY :=
                           CurrExchRate.ExchangeAmtFCYToLCY(
                             WORKDATE,rec."Currency Code",CustAmount,rec."Currency Factor");

                       ProfitLCY := AmountLCY - CostLCY;

                       CustLedgEntry.SETCURRENTKEY("Document No.");
                       CustLedgEntry.SETRANGE("Document No.",rec."No.");
                       CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::"Credit Memo");
                       CustLedgEntry.SETRANGE("Customer No.",rec."Bill-to Customer No.");
                       IF CustLedgEntry.FINDFIRST THEN
                         AmountLCY := -CustLedgEntry."Sales (LCY)";

                       IF AmountLCY <> 0 THEN
                         ProfitPct := ROUND(100 * ProfitLCY / AmountLCY,0.1);

                       AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
                       IF AmountLCY <> 0 THEN
                         AdjProfitPct := ROUND(100 * AdjProfitLCY / AmountLCY,0.1);

                       IF Cust.GET(rec."Bill-to Customer No.") THEN
                         Cust.CALCFIELDS("Balance (LCY)")
                       ELSE
                         CLEAR(Cust);

                       IF Cust."Credit Limit (LCY)" = 0 THEN
                         CreditLimitLCYExpendedPct := 0
                       ELSE
                         CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);

                       SalesCrMemoLine.CalcVATAmountLines(Rec,TempVATAmountLine);
                       CurrPage.Subform.PAGE.SetTempVATAmountLine(TempVATAmountLine);
                       CurrPage.Subform.PAGE.InitGlobals(rec."Currency Code",FALSE,FALSE,FALSE,FALSE,rec."VAT Base Discount %");

                       ValidateTotalReceivableAndGetVATWithholdings;
                     END;


//trigger

var
      Text000 : TextConst ENU='VAT Amount',ESP='Importe IVA';
      Text001 : TextConst ENU='%1% VAT',ESP='%1% IVA';
      CurrExchRate : Record 330;
      SalesCrMemoLine : Record 115;
      Cust : Record 18;
      TempVATAmountLine : Record 290 TEMPORARY ;
      Currency : Record 4;
      TotalAdjCostLCY : Decimal;
      CustAmount : Decimal;
      AmountInclVAT : Decimal;
      InvDiscAmount : Decimal;
      VATAmount : Decimal;
      CostLCY : Decimal;
      ProfitLCY : Decimal;
      ProfitPct : Decimal;
      AdjProfitLCY : Decimal;
      AdjProfitPct : Decimal;
      LineQty : Decimal;
      TotalNetWeight : Decimal;
      TotalGrossWeight : Decimal;
      TotalVolume : Decimal;
      TotalParcels : Decimal;
      AmountLCY : Decimal;
      CreditLimitLCYExpendedPct : Decimal;
      VATpercentage : Decimal;
      VATAmountText : Text[30];
      PmtDiscAmount : Decimal;
      decAmountVATGE : Decimal;
      decAmountBaseGE : Decimal;
      decAmountVATPIT : Decimal;
      decAmountBasePIT : Decimal;
      decCalculateBaseGE : Decimal;
      decCalculateBasePIT : Decimal;
      QBPagePublisher : Codeunit 7207348;

    
    

//procedure
LOCAL procedure ValidateTotalReceivableAndGetVATWithholdings();
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      //QBPagePublisher.ValidateTotalReceivableGetVATWithholdingsSalesCrMemoStatistics(Rec,decAmountVATGE,decAmountBaseGE,decAmountVATPIT,
      //                                                                               decAmountBasePIT,decCalculateBaseGE,decCalculateBasePIT);

      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

