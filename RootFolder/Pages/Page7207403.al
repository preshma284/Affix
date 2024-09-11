page 7207403 "Vendor Statistics Withhold. FB"
{
    Editable = false;
    CaptionML = ENU = 'Vendor Statistics Withhold. FB', ESP = 'Estad�sticas Retenciones Proveedor';
    LinksAllowed = false;
    SourceTable = 23;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field("QW Withholding Amount PIT"; rec."QW Withholding Amount PIT")
            {

            }
            field("QW Withholding Amount G.E"; rec."QW Withholding Amount G.E")
            {

            }
            field("QW Withholding Pending Amount"; rec."QW Withholding Pending Amount")
            {

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF CurrentDate <> WORKDATE THEN BEGIN
            CurrentDate := WORKDATE;
            DateFilterCalc.CreateAccountingPeriodFilter(VendDateFilter[1], VendDateName[1], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(VendDateFilter[2], VendDateName[2], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(VendDateFilter[3], VendDateName[3], CurrentDate, -1);
        END;

        Rec.SETRANGE("Date Filter", 0D, CurrentDate);
        Rec.CALCFIELDS(
          Balance, "Balance (LCY)", "Balance Due", "Balance Due (LCY)",
          "Outstanding Orders (LCY)", "Amt. Rcd. Not Invoiced (LCY)",
          "Reminder Amounts (LCY)");

        TotalAmountLCY := rec."Balance (LCY)" + rec."Outstanding Orders (LCY)" + rec."Amt. Rcd. Not Invoiced (LCY)" + rec."Outstanding Invoices (LCY)";

        FOR i := 1 TO 4 DO BEGIN
            Rec.SETFILTER("Date Filter", VendDateFilter[i]);
            Rec.CALCFIELDS(
              "Purchases (LCY)", "Inv. Discounts (LCY)", "Inv. Amounts (LCY)", "Pmt. Discounts (LCY)",
              "Pmt. Disc. Tolerance (LCY)", "Pmt. Tolerance (LCY)",
              "Fin. Charge Memo Amounts (LCY)", "Cr. Memo Amounts (LCY)", "Payments (LCY)",
              "Reminder Amounts (LCY)", "Refunds (LCY)", "Other Amounts (LCY)");
            VendPurchLCY[i] := rec."Purchases (LCY)";
            VendInvDiscAmountLCY[i] := rec."Inv. Discounts (LCY)";
            InvAmountsLCY[i] := rec."Inv. Amounts (LCY)";
            VendPaymentDiscLCY[i] := rec."Pmt. Discounts (LCY)";
            VendPaymentDiscTolLCY[i] := rec."Pmt. Disc. Tolerance (LCY)";
            VendPaymentTolLCY[i] := rec."Pmt. Tolerance (LCY)";
            VendReminderChargeAmtLCY[i] := rec."Reminder Amounts (LCY)";
            VendFinChargeAmtLCY[i] := rec."Fin. Charge Memo Amounts (LCY)";
            VendCrMemoAmountsLCY[i] := rec."Cr. Memo Amounts (LCY)";
            VendPaymentsLCY[i] := rec."Payments (LCY)";
            VendRefundsLCY[i] := rec."Refunds (LCY)";
            VendOtherAmountsLCY[i] := rec."Other Amounts (LCY)";
        END;
        Rec.SETRANGE("Date Filter", 0D, CurrentDate);
    END;



    var
        DateFilterCalc: Codeunit 358;
        VendDateFilter: ARRAY[4] OF Text[30];
        VendDateName: ARRAY[4] OF Text[30];
        TotalAmountLCY: Decimal;
        CurrentDate: Date;
        VendPurchLCY: ARRAY[4] OF Decimal;
        VendInvDiscAmountLCY: ARRAY[4] OF Decimal;
        VendPaymentDiscLCY: ARRAY[4] OF Decimal;
        VendPaymentDiscTolLCY: ARRAY[4] OF Decimal;
        VendPaymentTolLCY: ARRAY[4] OF Decimal;
        VendReminderChargeAmtLCY: ARRAY[4] OF Decimal;
        VendFinChargeAmtLCY: ARRAY[4] OF Decimal;
        VendCrMemoAmountsLCY: ARRAY[4] OF Decimal;
        VendPaymentsLCY: ARRAY[4] OF Decimal;
        VendRefundsLCY: ARRAY[4] OF Decimal;
        VendOtherAmountsLCY: ARRAY[4] OF Decimal;
        i: Integer;
        InvAmountsLCY: ARRAY[4] OF Decimal;
        j: Integer;
        NoOpen: ARRAY[3] OF Integer;
        NoHonored: ARRAY[3] OF Integer;
        OpenAmtLCY: ARRAY[3] OF Decimal;
        OpenRemainingAmtLCY: ARRAY[3] OF Decimal;
        HonoredAmtLCY: ARRAY[3] OF Decimal;
        HonoredRemainingAmtLCY: ARRAY[3] OF Decimal;
        DocumentSituationFilter: ARRAY[3] OF Option "Posted BG/PO","Closed BG/PO","BG/PO",Cartera,"Closed Documents";
      Text000: TextConst ENU = 'Overdue Amounts (LCY) as of %1', ESP = 'Importes vencidos (DL) a %1';
        Text001: TextConst ENU = 'Placeholder', ESP = 'Marcador de posici�n';

    /*begin
    end.
  
*/
}







