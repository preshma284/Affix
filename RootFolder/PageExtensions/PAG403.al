pageextension 50191 MyExtension403 extends 403//38
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


//modify("Total_Invoicing")
//{
//
//
//}
//
}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 PurchSetup.GET;
                 AllowInvDisc :=
                   NOT (PurchSetup."Calc. Inv. Discount" AND VendInvDiscRecExists(rec."Invoice Disc. Code"));
                 AllowVATDifference :=
                   PurchSetup."Allow VAT Difference" AND
                   NOT (rec."Document Type" IN [rec."Document Type"::Quote,rec."Document Type"::"Blanket Order"]);
                 OnOpenPageOnBeforeSetEditable(AllowInvDisc,AllowVATDifference);
                 VATLinesFormIsEditable := AllowVATDifference OR AllowInvDisc;
                 CurrPage.EDITABLE := VATLinesFormIsEditable;
               END;
trigger OnAfterGetRecord()    BEGIN
                      //  RefreshOnAfterGetRecord;

                       QB_ValidateTotalReceivableAndGetVATWithholdings;
                     END;


//trigger

var
      Text000 : TextConst ENU='Purchase %1 Statistics',ESP='Estad¡sticas %1 compras';
      Text001 : TextConst ENU='Total',ESP='Total';
      Text002 : TextConst ENU='rec."Amount"',ESP='Importe';
      Text003 : TextConst ENU='%1 must not be 0.',ESP='%1 no debe ser 0.';
      Text004 : TextConst ENU='%1 must not be greater than %2.',ESP='%1 no debe ser m s grande de %2';
      Text005 : TextConst ENU='You cannot change the invoice discount because there is a %1 record for %2 %3.',ESP='No puede cambiar el dto. factura porque hay un %1 registro para %2 %3.';
      TotalPurchLine : ARRAY [3] OF Record 39;
      TotalPurchLineLCY : ARRAY [3] OF Record 39;
      Vend : Record 23;
      TempVATAmountLine1 : Record 290 TEMPORARY ;
      TempVATAmountLine2 : Record 290 TEMPORARY ;
      TempVATAmountLine3 : Record 290 TEMPORARY ;
      TempVATAmountLine4 : Record 290 TEMPORARY ;
      PurchSetup : Record 312;
      PurchPost : Codeunit 90;
      VATLinesForm : Page 9401;
      TotalAmount1 : ARRAY [3] OF Decimal;
      TotalAmount2 : ARRAY [3] OF Decimal;
      VATAmount : ARRAY [3] OF Decimal;
      PrepmtTotalAmount : Decimal;
      PrepmtVATAmount : Decimal;
      PrepmtTotalAmount2 : Decimal;
      VATAmountText : ARRAY [3] OF Text[30];
      PrepmtVATAmountText : Text[30];
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
//      PurchLine : Record 39;
//      TempPurchLine : Record 39 TEMPORARY ;
//      PurchPostPrepayments : Codeunit 444;
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
//      CLEAR(PurchLine);
//      CLEAR(TotalPurchLine);
//      CLEAR(TotalPurchLineLCY);
//
//      FOR i := 1 TO 3 DO begin
//        TempPurchLine.DELETEALL;
//        CLEAR(TempPurchLine);
//        CLEAR(PurchPost);
//        PurchPost.GetPurchLines(Rec,TempPurchLine,i - 1);
//        CLEAR(PurchPost);
//        CASE i OF
//          1:
//            PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine1);
//          2:
//            PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine2);
//          3:
//            PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine3);
//        end;
//
//        PurchPost.SumPurchLinesTemp(
//          Rec,TempPurchLine,i - 1,TotalPurchLine[i],TotalPurchLineLCY[i],
//          VATAmount[i],VATAmountText[i]);
//        if ( rec."Prices Including VAT"  )then begin
//          TotalAmount2[i] := TotalPurchLine[i].Amount;
//          TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
//          TotalPurchLine[i]."Line Amount" :=
//            TotalAmount1[i] + TotalPurchLine[i]."Inv. Discount Amount" + TotalPurchLine[i]."Pmt. Discount Amount";
//        end ELSE begin
//          TotalAmount1[i] := TotalPurchLine[i].Amount;
//          TotalAmount2[i] := TotalPurchLine[i]."Amount Including VAT";
//        end;
//      end;
//      TempPurchLine.DELETEALL;
//      CLEAR(TempPurchLine);
//      PurchPostPrepayments.GetPurchLines(Rec,0,TempPurchLine);
//      PurchPostPrepayments.SumPrepmt(
//        Rec,TempPurchLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
//      PrepmtInvPct :=
//        Pct(TotalPurchLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
//      PrepmtDeductedPct :=
//        Pct(TotalPurchLine[1]."Prepmt Amt Deducted",TotalPurchLine[1]."Prepmt. Amt. Inv.");
//      if ( rec."Prices Including VAT"  )then begin
//        PrepmtTotalAmount2 := PrepmtTotalAmount;
//        PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
//      end ELSE
//        PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;
//
//      if ( Vend.GET(rec."Pay-to Vendor No.")  )then
//        Vend.CALCFIELDS("Balance (LCY)")
//      ELSE
//        CLEAR(Vend);
//
//      TempVATAmountLine1.MODIFYALL(Modified,FALSE);
//      TempVATAmountLine2.MODIFYALL(Modified,FALSE);
//      TempVATAmountLine3.MODIFYALL(Modified,FALSE);
//      TempVATAmountLine4.MODIFYALL(Modified,FALSE);
//
//      PrevTab := -1;
//      UpdateHeaderInfo(2,TempVATAmountLine2);
//    end;
//Local procedure UpdateHeaderInfo(IndexNo : Integer;var VATAmountLine : Record 290);
//    var
//      CurrExchRate : Record 330;
//      UseDate : Date;
//    begin
//      TotalPurchLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
//      TotalAmount1[IndexNo] :=
//        TotalPurchLine[IndexNo]."Line Amount" - TotalPurchLine[IndexNo]."Inv. Discount Amount" -
//        TotalPurchLine[IndexNo]."Pmt. Discount Amount";
//      VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
//      if ( rec."Prices Including VAT"  )then begin
//        TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
//        TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
//        TotalPurchLine[IndexNo]."Line Amount" :=
//          TotalAmount1[IndexNo] + TotalPurchLine[IndexNo]."Inv. Discount Amount" +
//          TotalPurchLine[IndexNo]."Pmt. Discount Amount";
//      end ELSE
//        TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];
//
//      if ( rec."Prices Including VAT"  )then
//        TotalPurchLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
//      ELSE
//        TotalPurchLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
//      if ( rec."Currency Code" <> ''  )then begin
//        if ( rec."Posting Date" = 0D  )then
//          UseDate := WORKDATE
//        ELSE
//          UseDate := rec."Posting Date";
//
//        TotalPurchLineLCY[IndexNo].Amount :=
//          CurrExchRate.ExchangeAmtFCYToLCY(
//            UseDate,rec."Currency Code",TotalPurchLineLCY[IndexNo].Amount,rec."Currency Factor");
//      end;
//    end;
//Local procedure GetVATSpecification(QtyType: Option "General","Invoicing","Shipping");
//    begin
//      CASE QtyType OF
//        QtyType::General:
//          begin
//            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
//            if ( TempVATAmountLine1.GetAnyLineModified  )then
//              UpdateHeaderInfo(1,TempVATAmountLine1);
//          end;
//        QtyType::Invoicing:
//          begin
//            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
//            if ( TempVATAmountLine2.GetAnyLineModified  )then
//              UpdateHeaderInfo(2,TempVATAmountLine2);
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
//      WITH TotalPurchLine[IndexNo] DO
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
//      if ( TotalPurchLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1  )then
//        ERROR(
//          Text004,
//          TotalPurchLine[ModifiedIndexNo].FIELDCAPTION("Inv. Discount Amount"),
//          TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));
//
//      PartialInvoicing := (TotalPurchLine[1]."Line Amount" <> TotalPurchLine[2]."Line Amount");
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
//          TotalPurchLine[2]."Inv. Discount Amount" := TotalPurchLine[1]."Inv. Discount Amount"
//        ELSE
//          TotalPurchLine[1]."Inv. Discount Amount" := TotalPurchLine[2]."Inv. Discount Amount";
//
//      FOR i := 1 TO MaxIndexNo DO
//        WITH TotalPurchLine[IndexNo[i]] DO begin
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
//      rec."Invoice Discount Value" := TotalPurchLine[1]."Inv. Discount Amount";
//      Rec.MODIFY;
//      UpdateVATOnPurchLines;
//    end;
//Local procedure UpdatePrepmtAmount();
//    var
//      TempPurchLine : Record 39 TEMPORARY ;
//      PurchPostPrepmt : Codeunit 444;
//    begin
//      PurchPostPrepmt.UpdatePrepmtAmountOnPurchLines(Rec,PrepmtTotalAmount);
//      PurchPostPrepmt.GetPurchLines(Rec,0,TempPurchLine);
//      PurchPostPrepmt.SumPrepmt(
//        Rec,TempPurchLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
//      PrepmtInvPct :=
//        Pct(TotalPurchLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
//      PrepmtDeductedPct :=
//        Pct(TotalPurchLine[1]."Prepmt Amt Deducted",TotalPurchLine[1]."Prepmt. Amt. Inv.");
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
//
//      exit('2,0,' + FieldCaption);
//    end;
//
//    //[External]
//procedure UpdateVATOnPurchLines();
//    var
//      PurchLine : Record 39;
//    begin
//      GetVATSpecification(ActiveTab);
//      if ( TempVATAmountLine1.GetAnyLineModified  )then
//        PurchLine.UpdateVATOnLines(0,Rec,PurchLine,TempVATAmountLine1);
//      if ( TempVATAmountLine2.GetAnyLineModified  )then
//        PurchLine.UpdateVATOnLines(1,Rec,PurchLine,TempVATAmountLine2);
//      PrevNo := '';
//    end;
Local procedure VendInvDiscRecExists(InvDiscCode : Code[20]) : Boolean;
   var
     VendInvDisc : Record 24;
   begin
     VendInvDisc.SETRANGE(Code,InvDiscCode);
     exit(VendInvDisc.FINDFIRST);
   end;
//Local procedure CheckAllowInvDisc();
//    var
//      VendInvDisc : Record 24;
//    begin
//      if ( not AllowInvDisc  )then
//        ERROR(
//          Text005,
//          VendInvDisc.TABLECAPTION,Rec.FIELDCAPTION("Invoice Disc. Code"),"Invoice Disc. Code");
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
//
  //  [IntegrationEvent(false,false)]
Local procedure OnOpenPageOnBeforeSetEditable(var AllowInvDisc : Boolean;var AllowVATDifference : Boolean);
   begin
   end;
LOCAL procedure QB_ValidateTotalReceivableAndGetVATWithholdings();
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      //QBPagePublisher.ValidateTotalReceivableGetVATWithholdingPurchaseOrderStatistics(Rec,decAmountVATGE,decAmountBaseGE,decAmountVATPIT,
      //                decAmountBasePIT,decCalculateBaseGE,decCalculateBasePIT);

      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

