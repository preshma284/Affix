pageextension 50291 MyExtension9308 extends 9308//38
{
layout
{
addafter("Buy-from Vendor Name")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
}
    field("QB_JobNo";rec."QB Job No.")
    {
        
}
} addafter("Posting Date")
{
    field("QB_ReceiptDate";rec."QB Receipt Date")
    {
        
}
    field("QB_OperationDateSII";rec."QB Operation date SII")
    {
        
                Visible=verSII;
                Editable=FALSE ;
}
} addafter("Job Queue Status")
{
    field("QB_VendorPostingGroup";rec."Vendor Posting Group")
    {
        
}
} addafter("Amount")
{
    field("QB_Base";"QB_Base")
    {
        
                CaptionML=ESP='Base Imponible';
                Editable=false ;
}
    field("QB_IVA";"QB_IVA")
    {
        
                CaptionML=ESP='IVA';
                Editable=false ;
}
    field("QB_IRPF";"QB_IRPF")
    {
        
                CaptionML=ESP='IRPF';
                Editable=false ;
}
    field("QB_Total";"QB_Total")
    {
        
                CaptionML=ESP='Total';
                Editable=false ;
}
    field("QB_Ret";"QB_Ret")
    {
        
                CaptionML=ESP='Ret.Pago';
                Editable=false ;
}
    field("QB_Pagar";"QB_Pagar")
    {
        
                CaptionML=ESP='A Pagar';
                Editable=false ;
}
    field("QB_TotalDocumentAmount";rec."QB Total document amount")
    {
        
}
} addfirst("factboxes")
{    part("DropArea";7174655)
    {
        
                Visible=seeDragDrop;
}
    part("FilesSP";7174656)
    {
        
                Visible=seeDragDrop;
}
}


modify("Amount")
{
Visible=false ;


}

}

actions
{
addafter("Display")
{
group("QB_RequestApproval")
{
        
                      CaptionML=ENU='Request Approval',ESP='Aprobaci¢n solic.';
    action("QB_Approvals")
    {
        
                      AccessByPermission=TableData 454=R;
                      CaptionML=ENU='Approvals',ESP='Aprobaciones';
                      ToolTipML=ENU='View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.',ESP='Permite ver una lista de los registros en espera de aprobaci¢n. Por ejemplo, puede ver qui‚n ha solicitado la aprobaci¢n del registro, cu ndo se envi¢ y la fecha de vencimiento de la aprobaci¢n.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Visible=ApprovalsActive;
                      PromotedIsBig=true;
                      Image=Approvals;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 WorkflowsEntriesBuffer : Record 832;
                                 QBApprovalSubscriber : Codeunit 7207354;
                               BEGIN
                                 cuApproval.ViewApprovals(Rec);
                               END;


}
    action("QB_SendApprovalRequest")
    {
        
                      CaptionML=ENU='Send A&pproval Request',ESP='Enviar solicitud a&probaci¢n';
                      ToolTipML=ENU='Request approval of the document.',ESP='Permite solicitar la aprobaci¢n del documento.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Visible=ApprovalsActive;
                      Enabled=CanRequestApproval;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 cuApproval.SendApproval(Rec);
                               END;


}
    action("QB_CancelApprovalRequest")
    {
        
                      CaptionML=ENU='Cancel Approval Re&quest',ESP='Cancelar solicitud aprobaci¢n';
                      ToolTipML=ENU='Cancel the approval request.',ESP='Cancela la solicitud de aprobaci¢n.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Visible=ApprovalsActive;
                      Enabled=CanCancelApproval;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category8;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 WorkflowWebhookMgt : Codeunit 1543;
                               BEGIN
                                 cuApproval.CancelApproval(Rec);
                               END;


}
    action("QB_Release")
    {
        
                      CaptionML=ENU='Release',ESP='Lanzar';
                      Promoted=true;
                      Enabled=CanRelease;
                      Image=ReleaseDoc;
                      PromotedCategory=Category8;
                      
                                trigger OnAction()    VAR
                                 ReleaseComparativeQuote : Codeunit 7207332;
                               BEGIN
                                 //JAV 04/02/20: - Verificar el importe del proveedor con el de la factura
                                 QB_CheckAmounts(TRUE);

                                 //JAV 14/05/19: - Control de contratos verificar importes
                                 Funcionesdecontratos.VerificarImportes(Rec);

                                 cuApproval.PerformManualRelease(Rec);
                               END;


}
    action("QB_Reopen")
    {
        
                      CaptionML=ENU='Open',ESP='Volver a abrir';
                      Promoted=true;
                      Enabled=CanReopen;
                      Image=ReOpen;
                      PromotedCategory=Category8;
                      
                                
    trigger OnAction()    VAR
                                 ReleaseComparativeQuote : Codeunit 7207332;
                               BEGIN
                                 cuApproval.PerformManualReopen(Rec);
                               END;


}
}
}
addbefore("Preview"){
  action("Post")
                {

                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'R&egistrar';
                    ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', ESP = 'Finaliza el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa.';
                    ApplicationArea = Basic, Suite;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = PostOrder;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    VAR
                        PurchaseHeader: Record 38;
                        PurchaseBatchPostMgt: Codeunit 1372;
                    BEGIN
                        //JAV 14/05/19: - Control de contratos verificar importes
                        Funcionesdecontratos.VerificarImportes(Rec);

                        CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                        IF PurchaseHeader.COUNT > 1 THEN BEGIN
                            PurchaseHeader.FINDSET;
                            REPEAT
                                VerifyTotal(PurchaseHeader);
                            UNTIL PurchaseHeader.NEXT = 0;
                            PurchaseBatchPostMgt.RunWithUI(PurchaseHeader, rec.COUNT, ReadyToPostQst);
                        END ELSE BEGIN
                            VerifyTotal(Rec);
                            Post(CODEUNIT::"Purch.-Post (Yes/No)");
                        END;
                    END;


                }
}



modify("Invoice")
{
Visible=false ;


}


modify("Approvals")
{
Visible=false;


}


modify("Action7")
{
Visible=false;


}


modify("Release")
{
Visible=false;


}


modify("Reopen")
{
Visible=false;


}


modify("Request Approval")
{
Visible=false;


}


modify("SendApprovalRequest")
{
Visible=false;


}


modify("CancelApprovalRequest")
{
Visible=false;


}


//modify("Post")
//{
//
//
//}
//

//modify("PostAndPrint")
//{
//
//
//}
//

//modify("PostBatch")
//{
//
//
//}
//
}

//trigger
trigger OnOpenPage()    VAR
                 PurchasesPayablesSetup : Record 312;
               BEGIN
                 rec.SetSecurityFilterOnRespCenter;

                 JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

                 rec.CopyBuyFromVendorFilter;

                 //JAV 04/07/19: - Control del SII de Mirosoft, se incluye la fecha de operaci¢n
                 verSII := FunctionQB.AccessToSII();


                 //QB JAV 12/05/20_ Aprobaciones de QuoBuilding, se llama a la funci¢n para activar los controles de aprobaci¢n
                 cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Purchase Header");
                 //Q7357 +
               END;
trigger OnAfterGetRecord()    BEGIN
                       //Calculamos importes para ver total y total a pagar
                       Rec.CALCFIELDS("Amount Including VAT","QW Total Withholding PIT","QW Total Withholding GE");

                       //JAV 30/10/20: - QB 1.07.03 Calcular importes
                       QB_CalculateDocTotals;
                       //QB
                       QB_SetControlAppearance;

                       //+Q8636
                       IF seeDragDrop THEN BEGIN
                         CurrPage.DropArea.PAGE.SetFilter(Rec);
                         CurrPage.FilesSP.PAGE.SetFilter(Rec);
                       END;
                       //-Q8636
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           // Contextual Power BI FactBox: send data to filter the report in the FactBox: (SourceTableFildToCompare,QueryName/FieldName)
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection(rec."No.",FALSE,PowerBIVisible);

                           //QB
                           QB_SetControlAppearance;

                           //CPA 25-05-22 - Q17160.Begin
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //CPA 25-05-22 - Q17160.End
                         END;


//trigger

var
      OpenPostedPurchaseInvQst : TextConst ENU='The invoice is posted as number %1 and moved to the Posted Purchase Invoice window.\\Do you want to open the posted invoice?',ESP='La factura se registr¢ con el n£mero %1 y se movi¢ a la ventana de facturas de compra registradas.\\¨Quiere abrir la factura registrada?';
      TotalsMismatchErr : TextConst ENU='The invoice cannot be posted because the total is different from the total on the related incoming document.',ESP='La factura no se puede registrar porque el importe total es diferente del total del documento entrante relacionado.';
      ReportPrint : Codeunit 228;
      JobQueueActive : Boolean ;
      OpenApprovalEntriesExist : Boolean;
      CanCancelApprovalForRecord : Boolean;
      PowerBIVisible : Boolean;
      ReadyToPostQst : TextConst ENU='%1 out of %2 selected invoices are ready for post. \Do you want to continue and post them?',ESP='%1 de las %2 facturas seleccionadas est n listas para el registro. \¨Desea continuar y registrarlas?';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206913;
      ApprovalsMgmt : Codeunit 1535;
      ApprovalsActive : Boolean;
      OpenApprovalsPage : Boolean;
      CanRequestApproval : Boolean;
      CanCancelApproval : Boolean;
      CanRelease : Boolean;
      CanReopen : Boolean;
      CanRequestDueApproval : Boolean;
      "------------------------------------ QB" : Integer;
      QB_Base : Decimal;
      QB_IVA : Decimal;
      QB_IRPF : Decimal;
      QB_Total : Decimal;
      QB_Ret : Decimal;
      QB_Pagar : Decimal;
      Funcionesdecontratos : Codeunit 7206907;
      verSII : Boolean ;
      FunctionQB : Codeunit 7207272;
      seeDragDrop : Boolean;

    
    

//procedure
LOCAL procedure SetControlAppearance();
    var
      ApprovalsMgmt : Codeunit 1535;
      WorkflowWebhookManagement : Codeunit 1543;
    begin
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    end;

    // [External]
// procedure Post(PostingCodeunitID : Integer);
//    var
//      ApplicationAreaMgmtFacade : Codeunit 9179;
//      LinesInstructionMgt : Codeunit 1320;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

//      rec.SendToPosting(PostingCodeunitID);

//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        ShowPostedConfirmationMessage;
//    end;
//Local procedure ShowPostedConfirmationMessage();
//    var
//      PurchInvHeader : Record 122;
//      InstructionMgt : Codeunit 1330;
//    begin
//      PurchInvHeader.SETRANGE("Pre-Assigned No.",rec."No.");
//      PurchInvHeader.SETRANGE("Order No.",'');
//      if ( PurchInvHeader.FINDFIRST  )then
//        if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedPurchaseInvQst,PurchInvHeader."No."),
//             InstructionMgt.ShowPostedConfirmationMessageCode)
//        then
//          PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
//    end;
//
//    //[External]
//procedure VerifyTotal(PurchaseHeader : Record 38);
//    begin
//      if ( not PurchaseHeader.IsTotalValid  )then
//        ERROR(TotalsMismatchErr);
//    end;
LOCAL procedure "-------------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_CheckAmounts(pBloquear : Boolean);
    var
      ImportePago : Decimal;
      Text001 : TextConst ESP='No cuadran los importes\     Importe factura %1\     Importe proveedor %2';
      TotalPurchaseHeader : Record 38;
    begin
      //JAV 04/02/20: - Verificar el importe del proveedor con el de la factura
      if ( (rec."QB Total document amount" <> 0)  )then begin
        TotalPurchaseHeader.GET(rec."Document Type", rec."No.");
        TotalPurchaseHeader.CALCFIELDS("Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");
        ImportePago := TotalPurchaseHeader."Amount Including VAT" - TotalPurchaseHeader."QW Total Withholding PIT" - TotalPurchaseHeader."QW Total Withholding GE";;

        if ( (ABS(ImportePago - rec."QB Total document amount") > FunctionQB.QB_MaxDifAmountInvoice)  )then begin
          CASE pBloquear OF
            TRUE : ERROR(Text001, ImportePago, rec."QB Total document amount");
            FALSE: MESSAGE(Text001, ImportePago, rec."QB Total document amount");
          end;
        end;
      end;
    end;
LOCAL procedure QB_CalculateDocTotals();
    begin
      //JAV 18/08/19: - Calculo del total del documento con las retenciones
      Rec.CALCFIELDS("Amount", "Amount Including VAT", "QW Total Withholding GE", "QW Total Withholding PIT");

      QB_Base  := Rec.Amount;
      QB_IVA   := Rec."Amount Including VAT" - Rec.Amount;
      QB_IRPF  := Rec."QW Total Withholding PIT";
      QB_Total := QB_Base + QB_IVA - QB_IRPF;
      QB_Ret   := Rec."QW Total Withholding GE";
      QB_Pagar := QB_Total - QB_Ret;
    end;
LOCAL procedure QB_SetControlAppearance();
    begin
      //QB JAV 12/05/20_ Aprobaciones de QuoBuilding, se llama a la funci¢n para activar los controles de aprobaci¢n
      cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
    end;

//procedure
}

