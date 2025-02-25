pageextension 50141 MyExtension160 extends 160//36
{
layout
{
addafter("TotalAdjCostLCY - TotalSalesLineLCY.""Unit Cost (LCY)""")
{
group("QB_Withholdings")
{
        
                CaptionML=ENU='Withholdings',ESP='Retenciones';
}
group("QB_WithholdingGE")
{
        
                CaptionML=ENU='Withholding G.E.',ESP='Retenci¢n B.E.';
    field("QB_WithholdingGEBaseCalculate";rec."QW Base Withholding GE" + 0)
    {
        
                CaptionML=ENU='Withholding GE Base Calculate',ESP='Base calculo Ret. Pago';
                Editable=FALSE ;
}
    field("QB_WithholdingPaimentAmount";rec."QW Total Withholding GE" +  rec."QW Total Withholding GE Before")
    {
        
                CaptionML=ENU='Withholding Paiment Amount',ESP='Importe Retenci¢n Pago';
}
}
group("QB_WithholdingPIT")
{
        
                CaptionML=ENU='Withholding PIT',ESP='Retenci¢n IRPF';
    field("QB_WithholdingCalculateBasePIT";rec."QW Base Withholding PIT" + 0)
    {
        
                CaptionML=ENU='Withholding Calculate Base PIT',ESP='Base calculo IRPF';
                Editable=FALSE ;
}
    field("QB_TotalWithholdingPIT";rec."QW Total Withholding PIT" + 0)
    {
        
                CaptionML=ENU='Total Withholding PIT',ESP='Importe Retenci¢n IRPF';
}
}
group("QB_Totals")
{
        
                CaptionML=ENU='Totals',ESP='Totales';
    field("QB_AmountToCharge";TotalAmount2 - rec."QW Total Withholding GE" - rec."QW Total Withholding PIT")
    {
        
                CaptionML=ENU='Amount to Charge',ESP='Total a Cobrar';
                Style=Strong;
                StyleExpr=TRUE ;
}
}
}


modify("ProfitLCY")
{
Visible=ViewQB;


}


modify("AdjProfitLCY")
{
Visible=ViewQB;


}


modify("ProfitPct")
{
Visible=ViewQB;


}


modify("AdjProfitPct")
{
Visible=ViewQB;


}


modify("TotalSalesLine.Quantity")
{
Visible=ViewQB;


}


modify("TotalSalesLine.""Units per Parcel""")
{
Visible=ViewQB;


}


modify("TotalSalesLine.""Net Weight""")
{
Visible=ViewQB;


}


modify("TotalSalesLine.""Gross Weight""")
{
Visible=ViewQB;


}


modify("TotalSalesLine.""Unit Volume""")
{
Visible=ViewQB;


}


modify("TotalSalesLineLCY.""Unit Cost (LCY)""")
{
Visible=ViewQB;


}


modify("TotalAdjCostLCY")
{
Visible=ViewQB;


}


modify("TotalAdjCostLCY - TotalSalesLineLCY.""Unit Cost (LCY)""")
{
Visible=ViewQB;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 SalesSetup.GET;
                 AllowInvDisc :=
                   NOT (SalesSetup."Calc. Inv. Discount" AND CustInvDiscRecExists(rec."Invoice Disc. Code"));
                 AllowVATDifference :=
                   SalesSetup."Allow VAT Difference" AND
                   NOT (rec."Document Type" IN [rec."Document Type"::Quote,rec."Document Type"::"Blanket Order"]);
                 OnOpenPageOnBeforeSetEditable(AllowInvDisc,AllowVATDifference);
                 CurrPage.EDITABLE := AllowVATDifference OR AllowInvDisc;
                 SetVATSpecification;

                 //JAV 29/03/20 - Si est  activo QB simplificar la pantalla
                 ViewQB := (FunctionQB.AccessToQuobuilding);
               END;
trigger OnAfterGetRecord()    BEGIN
                       CurrPage.CAPTION(STRSUBSTNO(Text000,rec."Document Type"));
                       IF PrevNo = rec."No." THEN BEGIN
                         GetVATSpecification;
                         EXIT;
                       END;

                       PrevNo := rec."No.";
                       Rec.FILTERGROUP(2);
                       Rec.SETRANGE("No.",PrevNo);
                       Rec.FILTERGROUP(0);

                       CalculateTotals;

                       QB_ValidateTotalReceivableAndGetVATWithholdings;
                     END;


//trigger

var
      Text000 : TextConst ENU='Sales %1 Statistics',ESP='Estad¡sticas %1 ventas';
      Text001 : TextConst ENU='Total',ESP='Total';
      Text002 : TextConst ENU='rec."Amount"',ESP='Importe';
      Text003 : TextConst ENU='%1 must not be 0.',ESP='%1 no debe ser 0.';
      Text004 : TextConst ENU='%1 must not be greater than %2.',ESP='%1 no debe ser m s grande de %2';
      Text005 : TextConst ENU='You cannot change the invoice discount because there is a %1 record for %2 %3.',ESP='No puede cambiar el dto. factura porque hay un %1 registro para %2 %3.';
      TotalSalesLine : Record 37;
      TotalSalesLineLCY : Record 37;
      Cust : Record 18;
      TempVATAmountLine : Record 290 TEMPORARY ;
      SalesSetup : Record 311;
      SalesPost : Codeunit 80;
      TotalAmount1 : Decimal;
      TotalAmount2 : Decimal;
      VATAmount : Decimal;
      VATAmountText : Text[30];
      ProfitLCY : Decimal;
      ProfitPct : Decimal;
      AdjProfitLCY : Decimal;
      AdjProfitPct : Decimal;
      TotalAdjCostLCY : Decimal;
      CreditLimitLCYExpendedPct : Decimal;
      PrevNo : Code[20];
      AllowInvDisc : Boolean;
      AllowVATDifference : Boolean;
      "------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      ViewQB : Boolean;
      decAmountVATGE : Decimal;
      decAmountBaseGE : Decimal;
      decAmountVATPIT : Decimal;
      decAmountBasePIT : Decimal;
      decBaseCalculateGE : Decimal;
      decBaseCalculatePIT : Decimal;

    
    

//procedure
Local procedure UpdateHeaderInfo();
   var
     CurrExchRate : Record 330;
     UseDate : Date;
   begin
     TotalSalesLine."Inv. Discount Amount" := TempVATAmountLine.GetTotalInvDiscAmount;
     TotalAmount1 :=
       TotalSalesLine."Line Amount" - TotalSalesLine."Inv. Discount Amount" - TotalSalesLine."Pmt. Discount Amount";
     VATAmount := TempVATAmountLine.GetTotalVATAmount;
     if ( rec."Prices Including VAT"  )then begin
       TotalAmount1 := TempVATAmountLine.GetTotalAmountInclVAT;
       TotalAmount2 := TotalAmount1 - VATAmount;
       TotalSalesLine."Line Amount" :=
         TotalAmount1 + TotalSalesLine."Inv. Discount Amount" + TotalSalesLine."Pmt. Discount Amount";
     end ELSE
       TotalAmount2 := TotalAmount1 + VATAmount;

     if ( rec."Prices Including VAT"  )then
       TotalSalesLineLCY.Amount := TotalAmount2
     ELSE
       TotalSalesLineLCY.Amount := TotalAmount1;
     if ( rec."Currency Code" <> ''  )then begin
       if (rec."Document Type" IN [rec."Document Type"::"Blanket Order",rec."Document Type"::Quote]) and
          (rec."Posting Date" = 0D)
       then
         UseDate := WORKDATE
       ELSE
         UseDate := rec."Posting Date";

       TotalSalesLineLCY.Amount :=
         CurrExchRate.ExchangeAmtFCYToLCY(
           UseDate,rec."Currency Code",TotalSalesLineLCY.Amount,rec."Currency Factor");
     end;
     ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
     if ( TotalSalesLineLCY.Amount = 0  )then
       ProfitPct := 0
     ELSE
       ProfitPct := ROUND(100 * ProfitLCY / TotalSalesLineLCY.Amount,0.01);

     AdjProfitLCY := TotalSalesLineLCY.Amount - TotalAdjCostLCY;
     if ( TotalSalesLineLCY.Amount = 0  )then
       AdjProfitPct := 0
     ELSE
       AdjProfitPct := ROUND(100 * AdjProfitLCY / TotalSalesLineLCY.Amount,0.01);
   end;
Local procedure GetVATSpecification();
   begin
     CurrPage.SubForm.PAGE.GetTempVATAmountLine(TempVATAmountLine);
     if ( TempVATAmountLine.GetAnyLineModified  )then
       UpdateHeaderInfo;
   end;
Local procedure SetVATSpecification();
   begin
     CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
     CurrPage.SubForm.PAGE.InitGlobals(
       rec."Currency Code",AllowVATDifference,AllowVATDifference,
       rec."Prices Including VAT",AllowInvDisc,rec."VAT Base Discount %");
   end;
//Local procedure UpdateTotalAmount();
//    var
//      SaveTotalAmount : Decimal;
//    begin
//      CheckAllowInvDisc;
//      if ( rec."Prices Including VAT"  )then begin
//        SaveTotalAmount := TotalAmount1;
//        UpdateInvDiscAmount;
//        TotalAmount1 := SaveTotalAmount;
//      end;
//      WITH TotalSalesLine DO
//        "Inv. Discount Amount" := "Line Amount" - TotalAmount1;
//      UpdateInvDiscAmount;
//    end;
//Local procedure UpdateInvDiscAmount();
//    var
//      InvDiscBaseAmount : Decimal;
//    begin
//      CheckAllowInvDisc;
//      InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(FALSE,rec."Currency Code");
//      if ( InvDiscBaseAmount = 0  )then
//        ERROR(Text003,TempVATAmountLine.FIELDCAPTION("Inv. Disc. Base Amount"));
//
//      if ( TotalSalesLine."Inv. Discount Amount" / InvDiscBaseAmount > 1  )then
//        ERROR(
//          Text004,
//          TotalSalesLine.FIELDCAPTION("Inv. Discount Amount"),
//          TempVATAmountLine.FIELDCAPTION("Inv. Disc. Base Amount"));
//
//      TempVATAmountLine.SetInvoiceDiscountAmount(
//        TotalSalesLine."Inv. Discount Amount",rec."Currency Code",rec."Prices Including VAT",rec."VAT Base Discount %");
//      CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
//      UpdateHeaderInfo;
//
//      rec."Invoice Discount Calculation" := rec."Invoice Discount Calculation"::"Amount";
//      rec."Invoice Discount Value" := TotalSalesLine."Inv. Discount Amount";
//      Rec.MODIFY;
//      UpdateVATOnSalesLines;
//    end;
//Local procedure GetCaptionClass(FieldCaption : Text[100];ReverseCaption : Boolean) : Text[80];
//    begin
//      if ( rec."Prices Including VAT" XOR ReverseCaption  )then
//        exit('2,1,' + FieldCaption);
//
//      exit('2,0,' + FieldCaption);
//    end;
//Local procedure UpdateVATOnSalesLines();
//    var
//      SalesLine : Record 37;
//    begin
//      GetVATSpecification;
//      if ( TempVATAmountLine.GetAnyLineModified  )then begin
//        SalesLine.UpdateVATOnLines(0,Rec,SalesLine,TempVATAmountLine);
//        SalesLine.UpdateVATOnLines(1,Rec,SalesLine,TempVATAmountLine);
//      end;
//      PrevNo := '';
//    end;
Local procedure CustInvDiscRecExists(InvDiscCode : Code[20]) : Boolean;
   var
     CustInvDisc : Record 19;
   begin
     CustInvDisc.SETRANGE(Code,InvDiscCode);
     exit(CustInvDisc.FINDFIRST);
   end;
//Local procedure CheckAllowInvDisc();
//    var
//      CustInvDisc : Record 19;
//    begin
//      if ( not AllowInvDisc  )then
//        ERROR(
//          Text005,
//          CustInvDisc.TABLECAPTION,Rec.FIELDCAPTION("Invoice Disc. Code"),"Invoice Disc. Code");
//    end;
LOCAL procedure CalculateTotals();
    var
      SalesLine : Record 37;
      TempSalesLine : Record 37 TEMPORARY ;
    begin
      CLEAR(SalesLine);
      CLEAR(TotalSalesLine);
      CLEAR(TotalSalesLineLCY);
      CLEAR(SalesPost);

      SalesPost.GetSalesLines(Rec,TempSalesLine,0);
      CLEAR(SalesPost);
      SalesPost.SumSalesLinesTemp(
        Rec,TempSalesLine,0,TotalSalesLine,TotalSalesLineLCY,
        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

      AdjProfitLCY := TotalSalesLineLCY.Amount - TotalAdjCostLCY;
      if ( TotalSalesLineLCY.Amount <> 0  )then
        AdjProfitPct := ROUND(AdjProfitLCY / TotalSalesLineLCY.Amount * 100,0.1);

      if ( rec."Prices Including VAT"  )then begin
        TotalAmount2 := TotalSalesLine.Amount;
        TotalAmount1 := TotalAmount2 + VATAmount;
        TotalSalesLine."Line Amount" :=
          TotalAmount1 + TotalSalesLine."Inv. Discount Amount" + TotalSalesLine."Pmt. Discount Amount";
      end ELSE begin
        TotalAmount1 := TotalSalesLine.Amount;
        TotalAmount2 := TotalSalesLine."Amount Including VAT";
      end;

      if ( Cust.GET(rec."Bill-to Customer No.")  )then
        Cust.CALCFIELDS("Balance (LCY)")
      ELSE
        CLEAR(Cust);
      if ( Cust."Credit Limit (LCY)" = 0  )then
        CreditLimitLCYExpendedPct := 0
      ELSE
        if ( Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0  )then
          CreditLimitLCYExpendedPct := 0
        ELSE
          if ( Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1  )then
            CreditLimitLCYExpendedPct := 10000
          ELSE
            CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);

      SalesLine.CalcVATAmountLines(0,Rec,TempSalesLine,TempVATAmountLine);
      TempVATAmountLine.MODIFYALL(Modified,FALSE);
      SetVATSpecification;

      OnAfterCalculateTotals(Rec,TotalSalesLine,TotalSalesLineLCY,TempVATAmountLine);
    end;

    // [IntegrationEvent(false,false)]
Local procedure OnAfterCalculateTotals(var SalesHeader : Record 36;var TotalSalesLine : Record 37;var TotalSalesLineLCY : Record 37;var TempVATAmountLine : Record 290 TEMPORARY );
   begin
   end;
//
  //  [IntegrationEvent(false, false)]
Local procedure OnOpenPageOnBeforeSetEditable(var AllowInvDisc : Boolean;var AllowVATDifference : Boolean);
   begin
   end;
LOCAL procedure QB_ValidateTotalReceivableAndGetVATWithholdings();
    var
      QBPagePublisher : Codeunit 7207348;
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

