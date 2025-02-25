pageextension 50212 MyExtension509 extends 509//38
{
layout
{
addafter("Buy-from Vendor Name")
{
    field("QB_JobNo";rec."QB Job No.")
    {
        
}
} addafter("No. of Archived Versions")
{
group("QB_GroupDate")
{
        
                CaptionML=ESP='Fechas';
}
} addafter("Document Date")
{
    field("QB Calc Due Date";rec."QB Calc Due Date")
    {
        
                Visible=QB_verVtos;
                Enabled=QB_edPagos;
                
                            ;trigger OnValidate()    BEGIN
                             QB_edVtos := (rec."QB Calc Due Date" = rec."QB Calc Due Date"::Reception);
                           END;


}
    field("QB No. Days Calc Due Date";rec."QB No. Days Calc Due Date")
    {
        
                Visible=QB_verVtos;
                Enabled=QB_edVtos;
                Editable=QB_edPagos ;
}
    field("QB Due Date Base";rec."QB Due Date Base")
    {
        
                Visible=QB_verVtos ;
}
} addafter("VAT Bus. Posting Group")
{
    field("QB Payment Phases";rec."QB Payment Phases")
    {
        
                Visible=QB_verPaymentPhases;
                
                            ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                           END;


}
//     field("Payment Terms Code";rec."Payment Terms Code")
//     {
        
//                 ToolTipML=ENU='Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.',ESP='Especifica una f¢rmula que calcula la fecha de vencimiento del pago, la fecha de descuento por pronto pago y el importe de descuento por pronto pago.';
//                 ApplicationArea=Suite;
//                 Importance=Promoted;
//                 Enabled=QB_edPagos;
//                 ShowMandatory=TRUE ;
// }
//     field("Payment Method Code";rec."Payment Method Code")
//     {
        
//                 ToolTipML=ENU='Specifies how to make payment, such as with bank transfer, cash, or check.',ESP='Especifica c¢mo realizar el pago, por ejemplo transferencia bancaria, en efectivo o con cheque.';
//                 ApplicationArea=Suite;
//                 Importance=Additional;
//                 Enabled=QB_edPagos;
//                 ShowMandatory=TRUE ;
// }
    field("QB_CodWithholdingByGE";rec."QW Cod. Withholding by GE")
    {
        
}
    field("QB_CodWithholdingByPIT";rec."QW Cod. Withholding by PIT")
    {
        
}
}


//modify("Document Date")
//{
//
//
//}
//

//modify("Due Date")
//{
//
//
//}
//

//modify("Order Date")
//{
//
//
//}
//
}

actions
{
addafter("Print")
{
    action("QB_PrintContract")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='&Print Contract',ESP='Imprimir Contrato';
                      ToolTipML=ENU='Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.',ESP='Preparar el documento para imprimirlo. Se abre una ventana de solicitud de informe para el documento, donde puede especificar qu‚ incluir en la impresi¢n.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Image=Print;
                      PromotedCategory=Report;
                      
                                trigger OnAction()    BEGIN
                                 //JAV 14/03/19: - Imprimir en el formato adecuado para QuoBuilding
                                 COMMIT;
                                 QBPagePublisher.PurchaseContractPrint(rec."Document Type", rec."No.");
                               END;


}
    action("QB_ContractCard")
    {
        CaptionML=ENU='Contract Card',ESP='Ficha contrato';
                      Image=ResourceMan;
}
    action("QB_Test")
    {
        CaptionML=ENU='Test',ESP='Test';
                      Image=TestReport;
}
    action("QB_Order")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Order',ESP='Pedido';
                      Image=TestReport;
                      
                                trigger OnAction()    BEGIN
                                 DocPrint.PrintPurchHeader(Rec);
                               END;


}
    action("QB_Attachment")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Attachment',ESP='Anexo';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Post;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    VAR
                                 LocTexto001 : TextConst ESP='El Pedido no es un contrato';
                               BEGIN
                               END;


}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   Rec.FILTERGROUP(0);
                 END;

                 SetDocNoVisible;

                 QB_verPaymentPhases := FunctionQB.AccessToPaymentPhases;
                 //JAV 12/07/20: - Ver Calculo vtos.
                 QB_verVtos := FunctionQB.AccessToChangeBaseVtos;
               END;
trigger OnAfterGetRecord()    BEGIN
                       SetControlAppearance;
                       QB_SetEditable;
                     END;


//trigger

var
      CopyPurchDoc : Report 492;
      DocPrint : Codeunit 229;
      UserMgt : Codeunit 5700;
      ArchiveManagement : Codeunit 5063;
      PurchCalcDiscByType : Codeunit 66;
      ChangeExchangeRate : Page 511;
      DocNoVisible : Boolean;
      OpenApprovalEntriesExist : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      ShowWorkflowStatus : Boolean;
      CanCancelApprovalForRecord : Boolean;
      "--------------------------------------- QB" : Integer;
      QBPagePublisher : Codeunit 7207348;
      QB_verPaymentPhases : Boolean;
      QB_edPagos : Boolean;
      FunctionQB : Codeunit 7207272;
      QB_verVtos : Boolean;
      QB_edVtos : Boolean;

    
    

//procedure
//Local procedure ApproveCalcInvDisc();
//    begin
//      CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
//    end;
//Local procedure SaveInvoiceDiscountAmount();
//    var
//      DocumentTotals : Codeunit 57;
//    begin
//      CurrPage.SAVERECORD;
//      DocumentTotals.PurchaseRedistributeInvoiceDiscountAmountsOnDocument(Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//Local procedure PurchaserCodeOnAfterValidate();
//    begin
//      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure ShortcutDimension1CodeOnAfterV();
//    begin
//      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure ShortcutDimension2CodeOnAfterV();
//    begin
//      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
//    end;
//Local procedure PricesIncludingVATOnAfterValid();
//    begin
//      CurrPage.UPDATE;
//    end;
Local procedure SetDocNoVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
     DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Reminder","FinChMemo";
   begin
     DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Blanket Order",rec."No.");
   end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
   begin
     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
   end;
LOCAL procedure QB_SetEditable();
    begin
      QB_edPagos := (rec."QB Payment Phases" = '');
      Rec.VALIDATE("QB Calc Due Date");
    end;

//procedure
}

