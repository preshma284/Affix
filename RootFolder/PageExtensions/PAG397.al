pageextension 50185 MyExtension397 extends 397//112
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
                       CustLedgEntry : Record 21;
                       CostCalcMgt : Codeunit 5836;
                     BEGIN
                       CLEARALL;

                       IF rec."Currency Code" = '' THEN
                         currency.InitRoundingPrecision
                       ELSE
                         currency.GET(rec."Currency Code");

                       SalesInvLine.SETRANGE("Document No.",rec."No.");
                       IF SalesInvLine.FIND('-') THEN
                         REPEAT
                           CustAmount := CustAmount + SalesInvLine.Amount;
                           AmountInclVAT := AmountInclVAT + SalesInvLine."Amount Including VAT";
                           IF rec."Prices Including VAT" THEN BEGIN
                             InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" /
                               (1 + (SalesInvLine."VAT %" + SalesInvLine."EC %") / 100);
                             PmtDiscAmount := PmtDiscAmount + SalesInvLine."Pmt. Discount Amount" /
                               (1 + (SalesInvLine."VAT %" + SalesInvLine."EC %") / 100)
                           END ELSE BEGIN
                             InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
                             PmtDiscAmount := PmtDiscAmount + SalesInvLine."Pmt. Discount Amount";
                           END;
                           CostLCY := CostLCY + (SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)");
                           LineQty := LineQty + SalesInvLine.Quantity;
                           TotalNetWeight := TotalNetWeight + (SalesInvLine.Quantity * SalesInvLine."Net Weight");
                           TotalGrossWeight := TotalGrossWeight + (SalesInvLine.Quantity * SalesInvLine."Gross Weight");
                           TotalVolume := TotalVolume + (SalesInvLine.Quantity * SalesInvLine."Unit Volume");
                           IF SalesInvLine."Units per Parcel" > 0 THEN
                             TotalParcels := TotalParcels + ROUND(SalesInvLine.Quantity / SalesInvLine."Units per Parcel",1,'>');
                           IF SalesInvLine."VAT %" <> VATPercentage THEN
                             IF VATPercentage = 0 THEN
                               VATPercentage := SalesInvLine."VAT %" + SalesInvLine."EC %"
                             ELSE
                               VATPercentage := -1;
                           TotalAdjCostLCY :=
                             TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine) +
                             CostCalcMgt.CalcSalesInvLineNonInvtblCostAmt(SalesInvLine);
                         UNTIL SalesInvLine.NEXT = 0;
                       VATAmount := AmountInclVAT - CustAmount;
                       InvDiscAmount := ROUND(InvDiscAmount,currency."Amount Rounding Precision");

                       IF VATPercentage <= 0 THEN
                         VATAmountText := Text000
                       ELSE
                         VATAmountText := STRSUBSTNO(Text001,VATPercentage);

                       IF rec."Currency Code" = '' THEN
                         AmountLCY := CustAmount
                       ELSE
                         AmountLCY :=
                           CurrExchRate.ExchangeAmtFCYToLCY(
                             WORKDATE,rec."Currency Code",CustAmount,rec."Currency Factor");

                       CustLedgEntry.SETCURRENTKEY("Document No.");
                       CustLedgEntry.SETRANGE("Document No.",rec."No.");
                       CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::Invoice);
                       CustLedgEntry.SETRANGE("Customer No.",rec."Bill-to Customer No.");
                       IF CustLedgEntry.FINDFIRST THEN
                         AmountLCY := CustLedgEntry."Sales (LCY)";

                       ProfitLCY := AmountLCY - CostLCY;
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

                       SalesInvLine.CalcVATAmountLines(Rec,TempVATAmountLine);
                       CurrPage.Subform.PAGE.SetTempVATAmountLine(TempVATAmountLine);
                       CurrPage.Subform.PAGE.InitGlobals(rec."Currency Code",FALSE,FALSE,FALSE,FALSE,rec."VAT Base Discount %");

                       //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
                       QB_ValidateTotalReceivableAndGetVATWithholdings;
                     END;


//trigger

var
      Text000 : TextConst ENU='VAT Amount',ESP='Importe IVA';
      Text001 : TextConst ENU='%1% VAT',ESP='%1% IVA';
      CurrExchRate : Record 330;
      SalesInvLine : Record 113;
      Cust : Record 18;
      TempVATAmountLine : Record 290 TEMPORARY ;
      currency : Record 4;
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
      VATPercentage : Decimal;
      VATAmountText : Text[30];
      PmtDiscAmount : Decimal;

    
    

//procedure
LOCAL procedure QB_ValidateTotalReceivableAndGetVATWithholdings();
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

