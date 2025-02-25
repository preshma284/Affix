pageextension 50140 MyExtension152 extends 152//23
{
layout
{
addafter("GetInvoicedPrepmtAmountLCY")
{
    field("QB_WithholdingAmountGE";rec."QW Withholding Amount G.E")
    {
        
                Editable=FALSE ;
}
    field("QB_WithholdingAmountPIT";rec."QW Withholding Amount PIT")
    {
        
                Editable=FALSE ;
}
    field("QB_PendingWithholdingAmount";rec."QW Withholding Pending Amount")
    {
        
}
    field("QB_InvoicedWithoutWithholdings";rec."Inv. Amounts (LCY)"-rec."QW Withholding Amount PIT"-rec."QW Withholding Amount G.E")
    {
        
                CaptionML=ENU='Invoiced(Without Withholdings)',ESP='Facturado (Sin retenci¢n)';
}
    field("QB_Paid";(rec."Inv. Amounts (LCY)"-rec."QW Withholding Amount PIT"-rec."QW Withholding Amount G.E")-rec."Balance (LCY)")
    {
        
                CaptionML=ENU='Paid',ESP='Pagado';
}
}

}

actions
{


}

//trigger

//trigger

var
      Text000 : TextConst ENU='Overdue Amounts (LCY) as of %1',ESP='Importes vencidos (DL) a %1';
      DateFilterCalc : Codeunit 358;
      VendDateFilter : ARRAY [4] OF Text[30];
      VendDateName : ARRAY [4] OF Text[30];
      CurrentDate : Date;
      VendPurchLCY : ARRAY [4] OF Decimal;
      VendInvDiscAmountLCY : ARRAY [4] OF Decimal;
      VendPaymentDiscLCY : ARRAY [4] OF Decimal;
      VendPaymentDiscTolLCY : ARRAY [4] OF Decimal;
      VendPaymentTolLCY : ARRAY [4] OF Decimal;
      VendReminderChargeAmtLCY : ARRAY [4] OF Decimal;
      VendFinChargeAmtLCY : ARRAY [4] OF Decimal;
      VendCrMemoAmountsLCY : ARRAY [4] OF Decimal;
      VendPaymentsLCY : ARRAY [4] OF Decimal;
      VendRefundsLCY : ARRAY [4] OF Decimal;
      VendOtherAmountsLCY : ARRAY [4] OF Decimal;
      i : Integer;
      InvAmountsLCY : ARRAY [4] OF Decimal;
      Text001 : TextConst ENU='Placeholder',ESP='Marcador de posici¢n';
      j : Integer;
      NoOpen : ARRAY [3] OF Integer;
      NoHonored : ARRAY [3] OF Integer;
      OpenAmtLCY : ARRAY [3] OF Decimal;
      OpenRemainingAmtLCY : ARRAY [3] OF Decimal;
      HonoredAmtLCY : ARRAY [3] OF Decimal;
      HonoredRemainingAmtLCY : ARRAY [3] OF Decimal;
      DocumentSituationFilter : ARRAY [3] OF Option " ","Posted BG/PO","Closed BG/PO","BG/PO","Cartera","Closed Documents";

    
    

//procedure
//procedure UpdateBillStatistics();
//    var
//      VendLedgEntry : Record 25;
//    begin
//      DocumentSituationFilter[1] := DocumentSituationFilter::Cartera;
//      DocumentSituationFilter[2] := DocumentSituationFilter::"BG/PO";
//      DocumentSituationFilter[3] := DocumentSituationFilter::"Posted BG/PO";
//
//      WITH VendLedgEntry DO begin
//        SETCURRENTKEY("Vendor No.","Document Type","Document Situation","Document Status");
//        SETRANGE("Vendor No.",Rec."No.");
//        FOR j := 1 TO 3 DO begin
//          SETRANGE("Document Situation",DocumentSituationFilter[j]);
//          SETRANGE("Document Status","Document Status"::Open);
//          CALCSUMS("Amount (LCY) stats.","Remaining Amount (LCY) stats.");
//          OpenAmtLCY[j] := "Amount (LCY) stats.";
//          OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats.";
//          NoOpen[j] := COUNT;
//          SETRANGE("Document Status");
//
//          SETRANGE("Document Status","Document Status"::Honored);
//          CALCSUMS("Amount (LCY) stats.","Remaining Amount (LCY) stats.");
//          HonoredAmtLCY[j] := "Amount (LCY) stats.";
//          HonoredRemainingAmtLCY[j] := "Remaining Amount (LCY) stats.";
//          NoHonored[j] := COUNT;
//          SETRANGE("Document Status");
//
//          SETRANGE("Document Situation");
//        end;
//      end;
//    end;
//procedure DrillDownOpen(Situation: Option " ","Posted BG/PO","Closed BG/PO","BG/PO","Cartera","Closed Documents");
//    var
//      VendLedgEntry : Record 25;
//      VendLedgEntriesForm : Page 29;
//    begin
//      WITH VendLedgEntry DO begin
//        SETCURRENTKEY("Vendor No.","Document Type","Document Situation","Document Status");
//        SETRANGE("Vendor No.",Rec."No.");
//        CASE Situation OF
//          Situation::Cartera:
//            SETRANGE("Document Situation","Document Situation"::Cartera);
//          Situation::"BG/PO":
//            SETRANGE("Document Situation","Document Situation"::"BG/PO");
//          Situation::"Posted BG/PO":
//            SETRANGE("Document Situation","Document Situation"::"Posted BG/PO");
//        end;
//        SETRANGE("Document Status","Document Status"::Open);
//        VendLedgEntriesForm.SETTABLEVIEW(VendLedgEntry);
//        VendLedgEntriesForm.SETRECORD(VendLedgEntry);
//        VendLedgEntriesForm.RUNMODAL;
//        SETRANGE("Document Status");
//        SETRANGE("Document Situation");
//      end;
//    end;
//procedure DrillDownHonored(Situation: Option " ","Posted BG/PO","Closed BG/PO","BG/PO","Cartera","Closed Documents");
//    var
//      VendLedgEntry : Record 25;
//      VendLedgEntriesForm : Page 29;
//    begin
//      WITH VendLedgEntry DO begin
//        SETCURRENTKEY("Vendor No.","Document Type","Document Situation","Document Status");
//        SETRANGE("Vendor No.",Rec."No.");
//        CASE Situation OF
//          Situation::Cartera:
//            SETRANGE("Document Situation","Document Situation"::Cartera);
//          Situation::"BG/PO":
//            SETRANGE("Document Situation","Document Situation"::"BG/PO");
//          Situation::"Posted BG/PO":
//            SETRANGE("Document Situation","Document Situation"::"Posted BG/PO");
//        end;
//
//        Rec.SETRANGE("Document Status","Document Status"::Honored);
//        VendLedgEntriesForm.SETTABLEVIEW(VendLedgEntry);
//        VendLedgEntriesForm.SETRECORD(VendLedgEntry);
//        VendLedgEntriesForm.RUNMODAL;
//        Rec.SETRANGE("Document Status");
//        Rec.SETRANGE("Document Situation");
//      end;
//    end;

//procedure
}

