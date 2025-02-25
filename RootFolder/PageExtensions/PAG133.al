pageextension 50124 MyExtension133 extends 133//113
{
layout
{
addafter("Control28")
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

//modify("Unit Price")
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

//modify("Line Amount")
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

modify("Control28")
{
Visible=false;


}

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
      TotalSalesInvoiceHeader : Record 112;
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
//procedure ShowDocumentLineTracking();
//    var
//      DocumentLineTracking : Page 6560;
//    begin
//      CLEAR(DocumentLineTracking);
//      DocumentLineTracking.SetDoc(
//        6,rec."Document No.",rec."Line No.",rec."Blanket Order No.",rec."Blanket Order Line No.",rec."Order No.",rec."Order Line No.");
//      DocumentLineTracking.RUNMODAL;
//    end;
LOCAL procedure "------------------------------------------ QB Totales"();
    begin
    end;
procedure QB_CalculateDocTotals();
    var
      qbSalesInvoiceHeader : Record 112;
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      if ( (qbSalesInvoiceHeader.GET(rec."Document No."))  )then begin
        qbSalesInvoiceHeader.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

        QB_Base  := qbSalesInvoiceHeader.Amount;
        QB_IVA   := qbSalesInvoiceHeader."Amount Including VAT" - qbSalesInvoiceHeader.Amount;
        QB_IRPF  := qbSalesInvoiceHeader."QW Total Withholding PIT";
        QB_Total := QB_Base + QB_IVA - QB_IRPF;
        QB_Ret   := qbSalesInvoiceHeader."QW Total Withholding GE";
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

