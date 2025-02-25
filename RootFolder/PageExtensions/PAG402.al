pageextension 50190 MyExtension402 extends 402//36
{
layout
{
addafter("NoOfVATLines_General")
{
group("Control1100286007")
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
group("Control1100286002")
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
    field("TotalAmount2[1] - QW Total Withholding GE - QW Total Withholding PIT";TotalAmount2[1] - rec."QW Total Withholding GE" - rec."QW Total Withholding PIT")
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
trigger OnAfterGetRecord()    BEGIN
                      //  RefreshOnAfterGetRecord;
                       QB_ValidateTotalReceivableAndGetVATWithholdings;
                     END;


//trigger

var
      Text000 : TextConst ENU='Sales %1 Statistics',ESP='Estad¡sticas %1 ventas';
      Text001 : TextConst ENU='Total',ESP='Total';
      Text002 : TextConst ENU='rec."Amount"',ESP='Importe';
      Text003 : TextConst ENU='%1 must not be 0.',ESP='%1 no debe ser 0.';
      Text004 : TextConst ENU='%1 must not be greater than %2.',ESP='%1 no debe ser m s grande de %2';
      Text005 : TextConst ENU='You cannot change the invoice discount because a customer invoice discount with the code %1 exists.',ESP='No puede cambiar el dto. factura porque existe un descuento de factura de cliente con el c¢digo %1.';
      TotalSalesLine : ARRAY [3] OF Record 37;
      TotalSalesLineLCY : ARRAY [3] OF Record 37;
      Cust : Record 18;
      TempVATAmountLine1 : Record 290 TEMPORARY ;
      TempVATAmountLine2 : Record 290 TEMPORARY ;
      TempVATAmountLine3 : Record 290 TEMPORARY ;
      TempVATAmountLine4 : Record 290 TEMPORARY ;
      SalesSetup : Record 311;
      SalesPost : Codeunit 80;
      VATLinesForm : Page 9401;
      TotalAmount1 : ARRAY [3] OF Decimal;
      TotalAmount2 : ARRAY [3] OF Decimal;
      VATAmount : ARRAY [3] OF Decimal;
      PrepmtTotalAmount : Decimal;
      PrepmtVATAmount : Decimal;
      PrepmtTotalAmount2 : Decimal;
      VATAmountText : ARRAY [3] OF Text[30];
      PrepmtVATAmountText : Text[30];
      ProfitLCY : ARRAY [3] OF Decimal;
      ProfitPct : ARRAY [3] OF Decimal;
      AdjProfitLCY : ARRAY [3] OF Decimal;
      AdjProfitPct : ARRAY [3] OF Decimal;
      TotalAdjCostLCY : ARRAY [3] OF Decimal;
      CreditLimitLCYExpendedPct : Decimal;
      PrepmtInvPct : Decimal;
      PrepmtDeductedPct : Decimal;
      i : Integer;
      PrevNo : Code[20];
      ActiveTab: Option "General","Invoicing","Shipping","Prepayment";
      PrevTab: Option "General","Invoicing","Shipping","Prepayment";
      VATLinesFormIsEditable : Boolean;
      AllowInvDisc : Boolean;
      AllowVATDifference : Boolean;
      Text006 : TextConst ENU='Prepmt. Amount',ESP='Importe prepago';
      Text007 : TextConst ENU='Prepmt. Amt. Invoiced',ESP='Importe prepago facturado';
      Text008 : TextConst ENU='Prepmt. Amt. Deducted',ESP='Importe prepago descontado';
      Text009 : TextConst ENU='Prepmt. Amt. to Deduct',ESP='Importe prepago para descontar';
      DynamicEditable : Boolean;
      UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ESP='Se han facturado una o varias l¡neas. No se tendr  en cuenta el descuento distribuido entre las l¡neas facturadas.\\¨Desea actualizar el descuento en factura?';
      decAmountVATGE : Decimal;
      decAmountBaseGE : Decimal;
      decAmountVATPIT : Decimal;
      decAmountBasePIT : Decimal;
      decCalculateBaseGE : Decimal;
      decCalculateBasePIT : Decimal;
      QBPagePublisher : Codeunit 7207348;

    
    

//procedure
//Local procedure RefreshOnAfterGetRecord();
//    var
//      SalesLine : Record 37;
//      TempSalesLine : Record 37 TEMPORARY ;
//      SalesPostPrepayments : Codeunit 442;
//    begin
//      CurrPage.CAPTION(STRSUBSTNO(Text000,rec."Document Type"));
//
//      if ( PrevNo = rec."No."  )then
//        exit;
//      PrevNo := rec."No.";
//      Rec.FILTERGROUP(2);
//      Rec.SETRANGE("No.",PrevNo);
//      Rec.FILTERGROUP(0);
//
//      CLEAR(SalesLine);
//      CLEAR(TotalSalesLine);
//      CLEAR(TotalSalesLineLCY);
//
//      FOR i := 1 TO 3 DO begin
//        TempSalesLine.DELETEALL;
//        CLEAR(TempSalesLine);
//        CLEAR(SalesPost);
//        SalesPost.GetSalesLines(Rec,TempSalesLine,i - 1);
//        CLEAR(SalesPost);
//        CASE i OF
//          1:
//            SalesLine.CalcVATAmountLines(0,Rec,TempSalesLine,TempVATAmountLine1);
//          2:
//            SalesLine.CalcVATAmountLines(0,Rec,TempSalesLine,TempVATAmountLine2);
//          3:
//            SalesLine.CalcVATAmountLines(0,Rec,TempSalesLine,TempVATAmountLine3);
//        end;
//
//        SalesPost.SumSalesLinesTemp(
//          Rec,TempSalesLine,i - 1,TotalSalesLine[i],TotalSalesLineLCY[i],
//          VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);
//
//        if ( i = 3  )then
//          TotalAdjCostLCY[i] := TotalSalesLineLCY[i]."Unit Cost (LCY)";
//
//        AdjProfitLCY[i] := TotalSalesLineLCY[i].Amount - TotalAdjCostLCY[i];
//        if ( TotalSalesLineLCY[i].Amount <> 0  )then
//          AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalSalesLineLCY[i].Amount * 100,0.1);
//
//        if ( rec."Prices Including VAT"  )then begin
//          TotalAmount2[i] := TotalSalesLine[i].Amount;
//          TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
//          TotalSalesLine[i]."Line Amount" :=
//            TotalAmount1[i] + TotalSalesLine[i]."Inv. Discount Amount" + TotalSalesLine[i]."Pmt. Discount Amount";
//        end ELSE begin
//          TotalAmount1[i] := TotalSalesLine[i].Amount;
//          TotalAmount2[i] := TotalSalesLine[i]."Amount Including VAT";
//        end;
//      end;
//      TempSalesLine.DELETEALL;
//      CLEAR(TempSalesLine);
//      SalesPostPrepayments.GetSalesLines(Rec,0,TempSalesLine);
//      SalesPostPrepayments.SumPrepmt(
//        Rec,TempSalesLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
//      PrepmtInvPct :=
//        Pct(TotalSalesLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
//      PrepmtDeductedPct :=
//        Pct(TotalSalesLine[1]."Prepmt Amt Deducted",TotalSalesLine[1]."Prepmt. Amt. Inv.");
//      if ( rec."Prices Including VAT"  )then begin
//        PrepmtTotalAmount2 := PrepmtTotalAmount;
//        PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
//      end ELSE
//        PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;
//
//      if ( Cust.GET(rec."Bill-to Customer No.")  )then
//        Cust.CALCFIELDS("Balance (LCY)")
//      ELSE
//        CLEAR(Cust);
//
//      CASE TRUE OF
//        Cust."Credit Limit (LCY)" = 0:
//        CreditLimitLCYExpendedPct := 0;
//        Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
//        CreditLimitLCYExpendedPct := 0;
//        Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
//        CreditLimitLCYExpendedPct := 10000;
//        ELSE
//        CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);
//      end;
//
//      TempVATAmountLine1.MODIFYALL(Modified,FALSE);
//      TempVATAmountLine2.MODIFYALL(Modified,FALSE);
//      TempVATAmountLine3.MODIFYALL(Modified,FALSE);
//      TempVATAmountLine4.MODIFYALL(Modified,FALSE);
//
//      PrevTab := -1;
//
//      UpdateHeaderInfo(2,TempVATAmountLine2);
//    end;
//Local procedure UpdateHeaderInfo(IndexNo : Integer;var VATAmountLine : Record 290);
//    var
//      CurrExchRate : Record 330;
//      UseDate : Date;
//    begin
//      TotalSalesLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
//      TotalAmount1[IndexNo] :=
//        TotalSalesLine[IndexNo]."Line Amount" - TotalSalesLine[IndexNo]."Inv. Discount Amount" -
//        TotalSalesLine[IndexNo]."Pmt. Discount Amount";
//      VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
//      if ( rec."Prices Including VAT"  )then begin
//        TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
//        TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
//        TotalSalesLine[IndexNo]."Line Amount" :=
//          TotalAmount1[IndexNo] + TotalSalesLine[IndexNo]."Inv. Discount Amount" +
//          TotalSalesLine[IndexNo]."Pmt. Discount Amount";
//      end ELSE
//        TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];
//
//      if ( rec."Prices Including VAT"  )then
//        TotalSalesLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
//      ELSE
//        TotalSalesLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
//      if ( rec."Currency Code" <> ''  )then
//        if ( rec."Posting Date" = 0D  )then
//          UseDate := WORKDATE
//        ELSE
//          UseDate := rec."Posting Date";
//
//      TotalSalesLineLCY[IndexNo].Amount :=
//        CurrExchRate.ExchangeAmtFCYToLCY(
//          UseDate,rec."Currency Code",TotalSalesLineLCY[IndexNo].Amount,rec."Currency Factor");
//
//      ProfitLCY[IndexNo] := TotalSalesLineLCY[IndexNo].Amount - TotalSalesLineLCY[IndexNo]."Unit Cost (LCY)";
//      if ( TotalSalesLineLCY[IndexNo].Amount = 0  )then
//        ProfitPct[IndexNo] := 0
//      ELSE
//        ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalSalesLineLCY[IndexNo].Amount,0.01);
//
//      AdjProfitLCY[IndexNo] := TotalSalesLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
//      if ( TotalSalesLineLCY[IndexNo].Amount = 0  )then
//        AdjProfitPct[IndexNo] := 0
//      ELSE
//        AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalSalesLineLCY[IndexNo].Amount,0.01);
//    end;
//Local procedure GetVATSpecification(QtyType: Option "General","Invoicing","Shipping");
//    begin
//      CASE QtyType OF
//        QtyType::General:
//          begin
//            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
//            UpdateHeaderInfo(1,TempVATAmountLine1);
//          end;
//        QtyType::Invoicing:
//          begin
//            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
//            UpdateHeaderInfo(2,TempVATAmountLine2);
//          end;
//        QtyType::Shipping:
//          VATLinesForm.GetTempVATAmountLine(TempVATAmountLine3);
//      end;
//    end;
//Local procedure UpdateTotalAmount(IndexNo : Integer);
//    var
//      SaveTotalAmount : Decimal;
//    begin
//      CheckAllowInvDisc;
//      if ( rec."Prices Including VAT"  )then begin
//        SaveTotalAmount := TotalAmount1[IndexNo];
//        UpdateInvDiscAmount(IndexNo);
//        TotalAmount1[IndexNo] := SaveTotalAmount;
//      end;
//
//      WITH TotalSalesLine[IndexNo] DO
//        "Inv. Discount Amount" := "Line Amount" - TotalAmount1[IndexNo];
//      UpdateInvDiscAmount(IndexNo);
//    end;
//Local procedure UpdateInvDiscAmount(ModifiedIndexNo : Integer);
//    var
//      ConfirmManagement : Codeunit 27;
//      PartialInvoicing : Boolean;
//      MaxIndexNo : Integer;
//      IndexNo : ARRAY [2] OF Integer;
//      i : Integer;
//      InvDiscBaseAmount : Decimal;
//    begin
//      CheckAllowInvDisc;
//      if ( not (ModifiedIndexNo IN [1,2])  )then
//        exit;
//
//      if ( rec.InvoicedLineExists  )then
//        if ( not ConfirmManagement.ConfirmProcess(UpdateInvDiscountQst,TRUE)  )then
//          ERROR('');
//
//      if ( ModifiedIndexNo = 1  )then
//        InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(FALSE,rec."Currency Code")
//      ELSE
//        InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(FALSE,rec."Currency Code");
//
//      if ( InvDiscBaseAmount = 0  )then
//        ERROR(Text003,TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));
//
//      if ( TotalSalesLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1  )then
//        ERROR(
//          Text004,
//          TotalSalesLine[ModifiedIndexNo].FIELDCAPTION("Inv. Discount Amount"),
//          TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));
//
//      PartialInvoicing := (TotalSalesLine[1]."Line Amount" <> TotalSalesLine[2]."Line Amount");
//
//      IndexNo[1] := ModifiedIndexNo;
//      IndexNo[2] := 3 - ModifiedIndexNo;
//      if ( (ModifiedIndexNo = 2) and PartialInvoicing  )then
//        MaxIndexNo := 1
//      ELSE
//        MaxIndexNo := 2;
//
//      if ( not PartialInvoicing  )then
//        if ( ModifiedIndexNo = 1  )then
//          TotalSalesLine[2]."Inv. Discount Amount" := TotalSalesLine[1]."Inv. Discount Amount"
//        ELSE
//          TotalSalesLine[1]."Inv. Discount Amount" := TotalSalesLine[2]."Inv. Discount Amount";
//
//      FOR i := 1 TO MaxIndexNo DO
//        WITH TotalSalesLine[IndexNo[i]] DO begin
//          if ( (i = 1) or not PartialInvoicing  )then
//            if ( IndexNo[i] = 1  )then begin
//              TempVATAmountLine1.SetInvoiceDiscountAmount(
//                "Inv. Discount Amount",rec."Currency Code",rec."Prices Including VAT",rec."VAT Base Discount %");
//            end ELSE
//              TempVATAmountLine2.SetInvoiceDiscountAmount(
//                "Inv. Discount Amount",rec."Currency Code",rec."Prices Including VAT",rec."VAT Base Discount %");
//
//          if ( (i = 2) and PartialInvoicing  )then
//            if ( IndexNo[i] = 1  )then begin
//              InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(FALSE,rec."Currency Code");
//              if ( InvDiscBaseAmount = 0  )then
//                TempVATAmountLine1.SetInvoiceDiscountPercent(
//                  0,rec."Currency Code",rec."Prices Including VAT",FALSE,rec."VAT Base Discount %")
//              ELSE
//                TempVATAmountLine1.SetInvoiceDiscountPercent(
//                  100 * TempVATAmountLine2.GetTotalInvDiscAmount / InvDiscBaseAmount,
//                  rec."Currency Code",rec."Prices Including VAT",FALSE,rec."VAT Base Discount %");
//            end ELSE begin
//              InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(FALSE,rec."Currency Code");
//              if ( InvDiscBaseAmount = 0  )then
//                TempVATAmountLine2.SetInvoiceDiscountPercent(
//                  0,rec."Currency Code",rec."Prices Including VAT",FALSE,rec."VAT Base Discount %")
//              ELSE
//                TempVATAmountLine2.SetInvoiceDiscountPercent(
//                  100 * TempVATAmountLine1.GetTotalInvDiscAmount / InvDiscBaseAmount,
//                  rec."Currency Code",rec."Prices Including VAT",FALSE,rec."VAT Base Discount %");
//            end;
//        end;
//
//      UpdateHeaderInfo(1,TempVATAmountLine1);
//      UpdateHeaderInfo(2,TempVATAmountLine2);
//
//      if ( ModifiedIndexNo = 1  )then
//        VATLinesForm.SetTempVATAmountLine(TempVATAmountLine1)
//      ELSE
//        VATLinesForm.SetTempVATAmountLine(TempVATAmountLine2);
//
//      rec."Invoice Discount Calculation" := rec."Invoice Discount Calculation"::"Amount";
//      rec."Invoice Discount Value" := TotalSalesLine[1]."Inv. Discount Amount";
//      Rec.MODIFY;
//
//      UpdateVATOnSalesLines;
//    end;
//Local procedure UpdatePrepmtAmount();
//    var
//      TempSalesLine : Record 37 TEMPORARY ;
//      SalesPostPrepmt : Codeunit 442;
//    begin
//      SalesPostPrepmt.UpdatePrepmtAmountOnSaleslines(Rec,PrepmtTotalAmount);
//      SalesPostPrepmt.GetSalesLines(Rec,0,TempSalesLine);
//      SalesPostPrepmt.SumPrepmt(
//        Rec,TempSalesLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
//      PrepmtInvPct :=
//        Pct(TotalSalesLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
//      PrepmtDeductedPct :=
//        Pct(TotalSalesLine[1]."Prepmt Amt Deducted",TotalSalesLine[1]."Prepmt. Amt. Inv.");
//      if ( rec."Prices Including VAT"  )then begin
//        PrepmtTotalAmount2 := PrepmtTotalAmount;
//        PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
//      end ELSE
//        PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;
//      Rec.MODIFY;
//    end;
//Local procedure GetCaptionClass(FieldCaption : Text[100];ReverseCaption : Boolean) : Text[80];
//    begin
//      if ( rec."Prices Including VAT" XOR ReverseCaption  )then
//        exit('2,1,' + FieldCaption);
//      exit('2,0,' + FieldCaption);
//    end;
//Local procedure UpdateVATOnSalesLines();
//    var
//      SalesLine : Record 37;
//    begin
//      GetVATSpecification(ActiveTab);
//      if ( TempVATAmountLine1.GetAnyLineModified  )then
//        SalesLine.UpdateVATOnLines(0,Rec,SalesLine,TempVATAmountLine1);
//      if ( TempVATAmountLine2.GetAnyLineModified  )then
//        SalesLine.UpdateVATOnLines(1,Rec,SalesLine,TempVATAmountLine2);
//      PrevNo := '';
//    end;
//Local procedure CustInvDiscRecExists(InvDiscCode : Code[20]) : Boolean;
//    var
//      CustInvDisc : Record 19;
//    begin
//      CustInvDisc.SETRANGE(Code,InvDiscCode);
//      exit(CustInvDisc.FINDFIRST);
//    end;
//Local procedure CheckAllowInvDisc();
//    begin
//      if ( not AllowInvDisc  )then
//        ERROR(Text005,rec."Invoice Disc. Code");
//    end;
//Local procedure Pct(Numerator : Decimal;Denominator : Decimal) : Decimal;
//    begin
//      if ( Denominator = 0  )then
//        exit(0);
//      exit(ROUND(Numerator / Denominator * 10000,1));
//    end;
//Local procedure VATLinesDrillDown(var VATLinesToDrillDown : Record 290;ThisTabAllowsVATEditing : Boolean);
//    begin
//      CLEAR(VATLinesForm);
//      VATLinesForm.SetTempVATAmountLine(VATLinesToDrillDown);
//      VATLinesForm.InitGlobals(
//        rec."Currency Code",AllowVATDifference,AllowVATDifference and ThisTabAllowsVATEditing,
//        rec."Prices Including VAT",AllowInvDisc,rec."VAT Base Discount %");
//      VATLinesForm.RUNMODAL;
//      VATLinesForm.GetTempVATAmountLine(VATLinesToDrillDown);
//    end;
//Local procedure TotalAmount21OnAfterValidate();
//    begin
//      WITH TotalSalesLine[1] DO begin
//        if ( rec."Prices Including VAT"  )then
//          "Inv. Discount Amount" := "Line Amount" - rec."Amount Including VAT"
//        ELSE
//          "Inv. Discount Amount" := "Line Amount" - Amount;
//      end;
//      UpdateInvDiscAmount(1);
//    end;
//
//    [Integration]
//Local procedure OnOpenPageOnBeforeSetEditable(var AllowInvDisc : Boolean;var AllowVATDifference : Boolean);
//    begin
//    end;
LOCAL procedure QB_ValidateTotalReceivableAndGetVATWithholdings();
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      //QBPagePublisher.ValidateTotalReceivableGetVATWithholdingPurchaseOrderStatistics(Rec,decAmountVATGE,decAmountBaseGE,decAmountVATPIT,
      //                decAmountBasePIT,decCalculateBaseGE,decCalculateBasePIT);

      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

