pageextension 50131 MyExtension139 extends 139//123
{
layout
{
addafter("Job No.")
{
    field("QB_PieceworkNo";rec."Piecework No.")
    {
        
}
} addafter("Shortcut Dimension 2 Code")
{
    field("DP_NonDeductibleVATLine";rec."DP Non Deductible VAT Line")
    {
        
                ToolTipML=ESP='Este campo indica si la l¡nea tiene una parte del IVA no deducible que aumentar  el importe del gasto';
                Visible=seeNonDeductible ;
}
    field("DP_NonDeductibleVATPorc";rec."DP Non Deductible VAT %")
    {
        
                ToolTipML=ESP='Este campo indica el % no deducible de la l¡nea que aumentar  el improte del gasto';
                Visible=seeNonDeductible ;
}
    field("DP_DeductibleVATLine";rec."DP Deductible VAT Line")
    {
        
                ToolTipML=ESP='Este campo informa si la l¡nea es o no deducible a efectos de la prorrata de IVA';
                Visible=seeProrrata ;
}
    field("DP_ApplyProrrataType";rec."DP Apply Prorrata Type")
    {
        
                Visible=seeProrrata ;
}
    field("DP_ProrrataPerc";rec."DP Prorrata %")
    {
        
                Visible=seeProrrata ;
}
    field("DP_IVAOriginalAmountVAT";rec."DP VAT Amount")
    {
        
                Visible=seeProrrata ;
}
    field("DP_DeductibleVATAmount";rec."DP Deductible VAT amount")
    {
        
                Visible=seeProrrata OR seeNonDeductible ;
}
    field("DP_NonDeductibleVATAmount";rec."DP Non Deductible VAT amount")
    {
        
                Visible=seeProrrata OR seeNonDeductible ;
}
} addafter("Control31")
{
group("Control1100286008")
{
        
group("Control1100286007")
{
        
    field("QB_Base";"QB_Base")
    {
        
                CaptionML=ENU='Total Withholding G.E',ESP='Base Imponible';
                Editable=false ;
}
    field("QB_IVA";"QB_IVA")
    {
        
                CaptionML=ENU='Total Withholding G.E',ESP='IVA';
                Editable=false ;
}
    field("QB_IRPF";"QB_IRPF")
    {
        
                CaptionML=ENU='Total Withholding PIT',ESP='IRPF';
                Editable=false ;
}
}
group("Control1100286003")
{
        
    field("QB_Total";"QB_Total")
    {
        
                CaptionML=ENU='TOTAL',ESP='TOTAL FACTURA';
                Editable=false;
                Style=Strong;
                StyleExpr=TRUE ;
}
    field("QB_Ret";"QB_Ret")
    {
        
                CaptionML=ENU='Total Withholding G.E',ESP='Retenci¢n Pago';
                Editable=false ;
}
    field("QB_Pagar";"QB_Pagar")
    {
        
                CaptionML=ENU='TOTAL',ESP='TOTAL A PAGAR';
                Editable=false;
                Style=Strong;
                StyleExpr=TRUE 

  ;
}
}
}
}


modify("Control31")
{
Visible=false;


}


modify("Control25")
{
Visible=false;


}


modify("Control7")
{
Visible=false;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
                 seeNonDeductible := DPManagement.AccessToNonDeductible;  //JAV 14/07/22: - DP 1.00.04 Se a¤ade el IVA no deducible
               END;
trigger OnAfterGetRecord()    BEGIN
                       QB_CalculateDocTotals;
                     END;


//trigger

var
      TotalPurchInvHeader : Record 122;
      DocumentTotals : Codeunit 57;
      IsFoundation : Boolean;
      VATAmount : Decimal;
      "------------------------------------ QB Totales" : Integer;
      QB_Base : Decimal;
      QB_IVA : Decimal;
      QB_IRPF : Decimal;
      QB_Total : Decimal;
      QB_Ret : Decimal;
      QB_Pagar : Decimal;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      seeNonDeductible : Boolean;

    

//procedure
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(
//        7,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",rec."Order No.",rec."Order Line No.");
//      DocumentLineTracking.RUNMODAL;
//    end;
LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;
procedure QB_CalculateDocTotals();
    var
      qbPurchaseHeader : Record 122;
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      if ( (qbPurchaseHeader.GET(rec."Document No."))  )then begin
        qbPurchaseHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

        QB_Base  := qbPurchaseHeader.Amount;
        QB_IVA   := qbPurchaseHeader."Amount Including VAT" - qbPurchaseHeader.Amount;
        QB_IRPF  := qbPurchaseHeader."QW Total Withholding PIT";
        QB_Total := QB_Base + QB_IVA - QB_IRPF;
        QB_Ret   := qbPurchaseHeader."QW Total Withholding GE";
        QB_Pagar := QB_Total - QB_Ret;
      end ELSE begin
        QB_Base  := 0;
        QB_IVA   := 0;
        QB_IRPF  := 0;
        QB_Total := 0;
        QB_Ret   := 0;
        QB_Pagar := 0;
      end;
    end;

//procedure
}

