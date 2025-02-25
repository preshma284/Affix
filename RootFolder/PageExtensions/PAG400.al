pageextension 50188 MyExtension400 extends 400//122
{
layout
{
addafter("TotalVolume")
{
group("Control1100286006")
{
        
                CaptionML=ENU='Retenciones',ESP='Retenci¢n B.E.';
    field("decCalculateBaseGE";rec."QW Base Withholding GE" + 0)
    {
        
                CaptionML=ENU='Base Calculate GE',ESP='Base calculo BE';
                Editable=FALSE ;
}
    field("QW Total Withholding GE +  QW Total Withholding GE Before";rec."QW Total Withholding GE" +  rec."QW Total Withholding GE Before")
    {
        
                CaptionML=ESP='Importe Retenci¢n';
}
}
group("Control1100286003")
{
        
                CaptionML=ENU='Retenciones',ESP='Retenci¢n IRPF';
    field("decCalculateBasePIT";rec."QW Base Withholding PIT" + 0)
    {
        
                CaptionML=ENU='Calculate Base PIT',ESP='Base calculo IRPF';
                Editable=FALSE ;
}
    field("QW Total Withholding PIT + 0";rec."QW Total Withholding PIT" + 0)
    {
        
                CaptionML=ENU='Total Withholding PIT',ESP='Importe Retenci¢n IRPF';
}
}
    field("AmountInclVAT - QW Total Withholding GE - QW Total Withholding PIT";AmountInclVAT - rec."QW Total Withholding GE" - rec."QW Total Withholding PIT")
    {
        
                CaptionML=ESP='Total a Pagar';
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
                       VendLedgEntry : Record 25;
                     BEGIN
                       CLEARALL;

                       IF rec."Currency Code" = '' THEN
                         Currency.InitRoundingPrecision
                       ELSE
                         Currency.GET(rec."Currency Code");

                       PurchInvLine.SETRANGE("Document No.",rec."No.");

                       IF PurchInvLine.FIND('-') THEN
                         REPEAT
                           VendAmount := VendAmount + PurchInvLine.Amount;
                           AmountInclVAT := AmountInclVAT + PurchInvLine."Amount Including VAT";
                           IF rec."Prices Including VAT" THEN BEGIN
                             InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount" /
                               (1 + (PurchInvLine."VAT %" + PurchInvLine."EC %") / 100);
                             PmtDiscAmount := PmtDiscAmount + PurchInvLine."Pmt. Discount Amount" /
                               (1 + (PurchInvLine."VAT %" + PurchInvLine."EC %") / 100)
                           END ELSE BEGIN
                             InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount";
                             PmtDiscAmount := PmtDiscAmount + PurchInvLine."Pmt. Discount Amount";
                           END;
                           LineQty := LineQty + PurchInvLine.Quantity;
                           TotalNetWeight := TotalNetWeight + (PurchInvLine.Quantity * PurchInvLine."Net Weight");
                           TotalGrossWeight := TotalGrossWeight + (PurchInvLine.Quantity * PurchInvLine."Gross Weight");
                           TotalVolume := TotalVolume + (PurchInvLine.Quantity * PurchInvLine."Unit Volume");
                           IF PurchInvLine."Units per Parcel" > 0 THEN
                             TotalParcels := TotalParcels + ROUND(PurchInvLine.Quantity / PurchInvLine."Units per Parcel",1,'>');
                           IF PurchInvLine."VAT %" <> VATPercentage THEN
                             IF VATPercentage = 0 THEN
                               VATPercentage := PurchInvLine."VAT %" + PurchInvLine."EC %"
                             ELSE
                               VATPercentage := -1;
                         UNTIL PurchInvLine.NEXT = 0;
                       VATAmount := AmountInclVAT - VendAmount;
                       InvDiscAmount := ROUND(InvDiscAmount,Currency."Amount Rounding Precision");

                       IF VATPercentage <= 0 THEN
                         VATAmountText := Text000
                       ELSE
                         VATAmountText := STRSUBSTNO(Text001,VATPercentage);

                       IF rec."Currency Code" = '' THEN
                         AmountLCY := VendAmount
                       ELSE
                         AmountLCY :=
                           CurrExchRate.ExchangeAmtFCYToLCY(
                             WORKDATE,rec."Currency Code",VendAmount,rec."Currency Factor");

                       VendLedgEntry.SETCURRENTKEY("Document No.");
                       VendLedgEntry.SETRANGE("Document No.",rec."No.");
                       VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::Invoice);
                       VendLedgEntry.SETRANGE("Vendor No.",rec."Pay-to Vendor No.");
                       IF VendLedgEntry.FINDFIRST THEN
                         AmountLCY := VendLedgEntry."Purchase (LCY)";

                       IF NOT Vend.GET(rec."Pay-to Vendor No.") THEN
                         CLEAR(Vend);
                       Vend.CALCFIELDS("Balance (LCY)");

                       PurchInvLine.CalcVATAmountLines(Rec,TempVATAmountLine);
                       CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
                       CurrPage.SubForm.PAGE.InitGlobals(rec."Currency Code",FALSE,FALSE,FALSE,FALSE,rec."VAT Base Discount %");

                       QB_ValidateTotalReceivableAndGetVATWithholdings;
                     END;


//trigger

var
      Text000 : TextConst ENU='VAT Amount',ESP='Importe IVA';
      Text001 : TextConst ENU='%1% VAT',ESP='%1% IVA';
      CurrExchRate : Record 330;
      PurchInvLine : Record 123;
      Vend : Record 23;
      TempVATAmountLine : Record 290 TEMPORARY ;
      Currency : Record 4;
      VendAmount : Decimal;
      AmountInclVAT : Decimal;
      InvDiscAmount : Decimal;
      AmountLCY : Decimal;
      LineQty : Decimal;
      TotalNetWeight : Decimal;
      TotalGrossWeight : Decimal;
      TotalVolume : Decimal;
      TotalParcels : Decimal;
      VATAmount : Decimal;
      VATPercentage : Decimal;
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
LOCAL procedure QB_ValidateTotalReceivableAndGetVATWithholdings();
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

