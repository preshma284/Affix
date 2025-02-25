pageextension 50126 MyExtension135 extends 135//115
{
layout
{
addafter("Control29")
{
group("Control1100286009")
{
        
group("Control1100286006")
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
group("Control1100286002")
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


//modify("Type")
//{
//
//
//}
//

//modify("FilteredTypeField")
//{
//
//
//}
//

//modify("No.")
//{
//
//
//}
//

//modify("Cross-Reference No.")
//{
//
//
//}
//

//modify("IC Partner Code")
//{
//
//
//}
//

//modify("Variant Code")
//{
//
//
//}
//

//modify("Description")
//{
//
//
//}
//

//modify("Return Reason Code")
//{
//
//
//}
//

//modify("Quantity")
//{
//
//
//}
//

//modify("Unit of Measure Code")
//{
//
//
//}
//

//modify("Unit of Measure")
//{
//
//
//}
//

//modify("Unit Cost (LCY)")
//{
//
//
//}
//

//modify("Unit Price")
//{
//
//
//}
//

//modify("Line Amount")
//{
//
//
//}
//

//modify("Line Discount %")
//{
//
//
//}
//

//modify("Line Discount Amount")
//{
//
//
//}
//

//modify("Allow Invoice Disc.")
//{
//
//
//}
//

//modify("Job No.")
//{
//
//
//}
//

//modify("Appl.""-from Item Entry""")
//{
//
//
//}
//

//modify("Appl.""-to Item Entry""")
//{
//
//
//}
//

//modify("Deferral Code")
//{
//
//
//}
//

//modify("Shortcut Dimension 1 Code")
//{
//
//
//}
//

//modify("Shortcut Dimension 2 Code")
//{
//
//
//}
//

modify("Control29")
{
Visible=false;


}


//modify("Invoice Discount Amount")
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
trigger OnAfterGetRecord()    BEGIN
                       QB_CalculateDocTotals;
                     END;


//trigger

var
      TotalSalesCrMemoHeader : Record 114;
      DocumentTotals : Codeunit 57;
      VATAmount : Decimal;
      IsFoundation : Boolean;
      "------------------------------------ QB Totales" : Integer;
      QB_Base : Decimal;
      QB_IVA : Decimal;
      QB_IRPF : Decimal;
      QB_Total : Decimal;
      QB_Ret : Decimal;
      QB_Pagar : Decimal;

    
    

//procedure
//Local procedure PageShowItemReturnRcptLines();
//    begin
//      if ( not (Type IN [rec."Type"::Item,rec."Type"::"Charge (Item)"])  )then
//        Rec.TESTfield("Type");
//      rec.ShowItemReturnRcptLines;
//    end;
//
//    //[External]
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(
//        10,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",rec."Order No.",rec."Order Line No.");
//      DocumentLineTracking.RUNMODAL;
//    end;
LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;
procedure QB_CalculateDocTotals();
    var
      qbSalesCrMemoHeader : Record 114;
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      if ( (qbSalesCrMemoHeader.GET(rec."Document No."))  )then begin
        qbSalesCrMemoHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

        QB_Base  := qbSalesCrMemoHeader.Amount;
        QB_IVA   := qbSalesCrMemoHeader."Amount Including VAT" - qbSalesCrMemoHeader.Amount;
        QB_IRPF  := qbSalesCrMemoHeader."QW Total Withholding PIT";
        QB_Total := QB_Base + QB_IVA - QB_IRPF;
        QB_Ret   := qbSalesCrMemoHeader."QW Total Withholding GE";
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

