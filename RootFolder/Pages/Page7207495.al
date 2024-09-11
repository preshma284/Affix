page 7207495 "QB Proform Totals FactBox"
{
CaptionML=ENU='Proform Totals',ESP='Totales de la Proforma';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7206960;
    PageType=CardPart;
    
  layout
{
area(content)
{
group("group195")
{
        
                CaptionML=ESP='Totales de la Proforma';
    field("tOrigin";tOrigin)
    {
        
                CaptionML=ENU='Amount to Origin',ESP='Importe a Origen';
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("PrevAmount";PrevAmount)
    {
        
                CaptionML=ENU='Previous amount',ESP='Importe anterior';
    }
    field("tPeriod";tPeriod)
    {
        
                CaptionML=ENU='TAX BASE',ESP='BASE IMPONIBLE';
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("VATAmount";VATAmount)
    {
        
                CaptionML=ENU='VAT amount',ESP='Importe del IVA';
                CaptionClass=CaptionVAT ;
    }
    field("Total";Total)
    {
        
                CaptionML=ENU='Total',ESP='Total';
    }
    field("WithholdingAmount";WithholdingAmount)
    {
        
                CaptionML=ENU='Withholding of payment',ESP='Retenci�n de pago';
                CaptionClass=CaptionWith ;
    }
    field("TotalToPay";TotalToPay)
    {
        
                CaptionML=ENU='TOTAL TO PAY',ESP='TOTAL A PAGAR';
                Style=Strong;
                StyleExpr=TRUE 

  ;
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       CalculateFields;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           CalculateFields;
                         END;



    var
      tPeriod : Decimal;
      tOrigin : Decimal;
      PrevAmount : Decimal;
      VATBase : Decimal;
      VATAmount : Decimal;
      WithholdingAmount : Decimal;
      Total : Decimal;
      TotalToPay : Decimal;
      CaptionWith : Text;
      CaptionVAT : Text;
      PorcVAT : Decimal;

    procedure CalculateFields();
    var
      QBProformLine : Record 7206961;
      Currency : Record 4;
      WithholdingGroup : Record 7207330;
      QBProform : Codeunit 7207345;
    begin
      tPeriod := 0;
      tOrigin := 0;
      VATAmount := 0;
      WithholdingAmount := 0;
      PrevAmount := 0;
      Total := 0;
      TotalToPay := 0;

      CLEAR(WithholdingGroup);
      if rec."QW Cod. Withholding by GE" <> '' then
        WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E",rec."QW Cod. Withholding by GE");

      QBProformLine.RESET;
      QBProformLine.SETRANGE("Document No.", rec."No.");
      if (QBProformLine.FINDSET(FALSE)) then
        repeat
          QBProform.RecalculateLineOrigin(QBProformLine, QBProformLine.Quantity);
          VATBase := QBProformLine.Quantity * QBProformLine."Direct Unit Cost";

          tPeriod += VATBase;
          tOrigin += QBProformLine."QB Qty. Proformed Origin" * QBProformLine."Direct Unit Cost";

          VATAmount += ROUND(VATBase * QBProformLine."VAT %" / 100, Currency."Amount Rounding Precision");

          if (CaptionVAT = '') and (QBProformLine."VAT %" <> 0) then
            CaptionVAT := STRSUBSTNO('IVA (%1%)', QBProformLine."VAT %");
        until (QBProformLine.NEXT = 0);

      PrevAmount := tOrigin - tPeriod;
      Total := tPeriod + VATAmount;

      if (CaptionVAT = '') then
        CaptionVAT := 'IVA';

      CaptionWith := STRSUBSTNO('Ret.Pago (%1%)', WithholdingGroup."Percentage Withholding");
      if WithholdingGroup."Withholding Base" = WithholdingGroup."Withholding Base"::"Invoice Amount" then
        WithholdingAmount += ROUND(tPeriod * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision")
      ELSE
        WithholdingAmount += ROUND((tPeriod + VATAmount) * WithholdingGroup."Percentage Withholding" / 100, Currency."Amount Rounding Precision");

      TotalToPay := Total - WithholdingAmount;
    end;

    // begin//end
}







