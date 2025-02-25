pageextension 50142 MyExtension161 extends 161//38
{
layout
{
addafter("TotalPurchLine.""Unit Volume""")
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


modify("TotalPurchLineLCY.Amount")
{
Visible=ViewQB;


}


modify("Quantity")
{
Visible=ViewQB;


}


modify("TotalPurchLine.""Units per Parcel""")
{
Visible=ViewQB;


}


modify("TotalPurchLine.""Net Weight""")
{
Visible=ViewQB;


}


modify("TotalPurchLine.""Gross Weight""")
{
Visible=ViewQB;


}


modify("TotalPurchLine.""Unit Volume""")
{
Visible=ViewQB;


}

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
      Text000 : TextConst ENU='Purchase %1 Statistics',ESP='Estad¡sticas %1 compras';
      Text001 : TextConst ENU='rec."Amount"',ESP='Importe';
      Text002 : TextConst ENU='Total',ESP='Total';
      Text003 : TextConst ENU='%1 must not be 0.',ESP='%1 no debe ser 0.';
      Text004 : TextConst ENU='%1 must not be greater than %2.',ESP='%1 no debe ser m s grande de %2';
      Text005 : TextConst ENU='You cannot change the invoice discount because a vendor invoice discount with the code %1 exists.',ESP='No puede cambiar el dto. factura porque existe un descuento de factura de proveedor con el c¢digo %1.';
      TotalPurchLine : Record 39;
      TotalPurchLineLCY : Record 39;
      Vend : Record 23;
      TempVATAmountLine : Record 290 TEMPORARY ;
      PurchSetup : Record 312;
      PurchPost : Codeunit 90;
      TotalAmount1 : Decimal;
      TotalAmount2 : Decimal;
      VATAmount : Decimal;
      VATAmountText : Text[30];
      PrevNo : Code[20];
      AllowInvDisc : Boolean;
      AllowVATDifference : Boolean;
      "---------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      ViewQB : Boolean;
      decAmountVATGE : Decimal;
      decAmountBaseGE : Decimal;
      decAmountVATPIT : Decimal;
      decAmountBasePIT : Decimal;
      decCalculateBaseGE : Decimal;
      decCalculateBasePIT : Decimal;
      QBPagePublisher : Codeunit 7207348;
      IRPFAmount : Decimal;

    
    

//procedure
Local procedure UpdateHeaderInfo();
   var
     CurrExchRate : Record 330;
     UseDate : Date;
   begin
     TotalPurchLine."Inv. Discount Amount" := TempVATAmountLine.GetTotalInvDiscAmount;
     TotalAmount1 :=
       TotalPurchLine."Line Amount" - TotalPurchLine."Inv. Discount Amount" - TotalPurchLine."Pmt. Discount Amount";
     VATAmount := TempVATAmountLine.GetTotalVATAmount;
     if ( rec."Prices Including VAT"  )then begin
       TotalAmount1 := TempVATAmountLine.GetTotalAmountInclVAT;
       TotalAmount2 := TotalAmount1 - VATAmount;
       TotalPurchLine."Line Amount" :=
         TotalAmount1 + TotalPurchLine."Inv. Discount Amount" + TotalPurchLine."Pmt. Discount Amount";
     end ELSE
       TotalAmount2 := TotalAmount1 + VATAmount;

     if ( rec."Prices Including VAT"  )then
       TotalPurchLineLCY.Amount := TotalAmount2
     ELSE
       TotalPurchLineLCY.Amount := TotalAmount1;
     if ( rec."Currency Code" <> ''  )then begin
       if (rec."Document Type" IN [rec."Document Type"::"Blanket Order",rec."Document Type"::Quote]) and
          (rec."Posting Date" = 0D)
       then
         UseDate := WORKDATE
       ELSE
         UseDate := rec."Posting Date";

       TotalPurchLineLCY.Amount :=
         CurrExchRate.ExchangeAmtFCYToLCY(
           UseDate,rec."Currency Code",TotalPurchLineLCY.Amount,rec."Currency Factor");
     end;
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
//
//      WITH TotalPurchLine DO
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
//      if ( TotalPurchLine."Inv. Discount Amount" / InvDiscBaseAmount > 1  )then
//        ERROR(
//          Text004,
//          TotalPurchLine.FIELDCAPTION("Inv. Discount Amount"),
//          TempVATAmountLine.FIELDCAPTION("Inv. Disc. Base Amount"));
//
//      TempVATAmountLine.SetInvoiceDiscountAmount(
//        TotalPurchLine."Inv. Discount Amount",rec."Currency Code",rec."Prices Including VAT",rec."VAT Base Discount %");
//      CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
//      UpdateHeaderInfo;
//
//      rec."Invoice Discount Calculation" := rec."Invoice Discount Calculation"::"Amount";
//      rec."Invoice Discount Value" := TotalPurchLine."Inv. Discount Amount";
//      Rec.MODIFY;
//      UpdateVATOnPurchLines;
//    end;
//Local procedure GetCaptionClass(FieldCaption : Text[100];ReverseCaption : Boolean) : Text[80];
//    begin
//      if ( rec."Prices Including VAT" XOR ReverseCaption  )then
//        exit('2,1,' + FieldCaption);
//
//      exit('2,0,' + FieldCaption);
//    end;
//Local procedure UpdateVATOnPurchLines();
//    var
//      PurchLine : Record 39;
//    begin
//      GetVATSpecification;
//      if ( TempVATAmountLine.GetAnyLineModified  )then begin
//        PurchLine.UpdateVATOnLines(0,Rec,PurchLine,TempVATAmountLine);
//        PurchLine.UpdateVATOnLines(1,Rec,PurchLine,TempVATAmountLine);
//      end;
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
//    begin
//      if ( not AllowInvDisc  )then
//        ERROR(Text005,rec."Invoice Disc. Code");
//    end;
Local procedure CalculateTotals();
   var
     PurchLine : Record 39;
     TempPurchLine : Record 39 TEMPORARY ;
   begin
     CLEAR(PurchLine);
     CLEAR(TotalPurchLine);
     CLEAR(TotalPurchLineLCY);
     CLEAR(PurchPost);

     PurchPost.GetPurchLines(Rec,TempPurchLine,0);
     CLEAR(PurchPost);
     PurchPost.SumPurchLinesTemp(
       Rec,TempPurchLine,0,TotalPurchLine,TotalPurchLineLCY,VATAmount,VATAmountText);

     if ( rec."Prices Including VAT"  )then begin
       TotalAmount2 := TotalPurchLine.Amount;
       TotalAmount1 := TotalAmount2 + VATAmount;
       TotalPurchLine."Line Amount" :=
         TotalAmount1 + TotalPurchLine."Inv. Discount Amount" + TotalPurchLine."Pmt. Discount Amount";
     end ELSE begin
       TotalAmount1 := TotalPurchLine.Amount;
       TotalAmount2 := TotalPurchLine."Amount Including VAT";
     end;

     if ( Vend.GET(rec."Pay-to Vendor No.")  )then
       Vend.CALCFIELDS("Balance (LCY)")
     ELSE
       CLEAR(Vend);

     PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine);
     TempVATAmountLine.MODIFYALL(Modified,FALSE);
     SetVATSpecification;

     OnAfterCalculateTotals(Rec,TotalPurchLine,TotalPurchLineLCY,TempVATAmountLine);
   end;
//
  //  [IntegrationEvent(false, false)]
Local procedure OnAfterCalculateTotals(var PurchHeader : Record 38;var TotalPurchLine : Record 39;var TotalPurchLineLCY : Record 39;var TempVATAmountLine : Record 290 TEMPORARY );
   begin
   end;
//
  //  [IntegrationEvent(false,false)]
Local procedure OnOpenPageOnBeforeSetEditable(var AllowInvDisc : Boolean;var AllowVATDifference : Boolean);
   begin
   end;
LOCAL procedure QB_ValidateTotalReceivableAndGetVATWithholdings();
    begin
      //JAV 23/10/19: - Se simplifica el c lculo de los importes de las retenciones
      Rec.CALCFIELDS("QW Base Withholding GE", "QW Total Withholding GE", "QW Total Withholding GE Before", "QW Base Withholding PIT", "QW Total Withholding PIT");
    end;

//procedure
}

