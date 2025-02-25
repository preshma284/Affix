pageextension 50290 MyExtension9307 extends 9307//38
{
layout
{
addafter("Buy-from Vendor No.")
{
    field("QB_JobNo";rec."QB Job No.")
    {
        
}
    field("QB_JobDescription";"JobDescription")
    {
        
                CaptionML=ENU='Job Description',ESP='Descripci¢n del Proyecto';
                Editable=FALSE ;
}
    field("QB Budget item";rec."QB Budget item")
    {
        
}
    field("QB Contract";rec."QB Contract")
    {
        
                ToolTipML=ESP='Indica si el documento rpoviene de un comprativo y por tanto es un contrato de compra';
}
    field("QB % Proformar";rec."QB % Proformar")
    {
        
                ToolTipML=ESP='Si el documento puede generar proformas (tiene l¡neas de tipo recurso o l¡neas con productos proformables), que % de la cantidad a recibir se informar  como cantidad para generar proforma';
}
} addafter("Posting Description")
{
    field("QBApprovalManagement.GetLastStatus(RECORDID, Status)";QBApprovalManagement.GetLastStatus(Rec.RECORDID, rec."Status".AsInteger()))
    {
        
                CaptionML=ESP='Situaci¢n';
}
    field("QBApprovalManagement.GetLastDateTime(RECORDID)";QBApprovalManagement.GetLastDateTime(Rec.RECORDID))
    {
        
                CaptionML=ESP='Ult.Acci¢n';
}
    field("QBApprovalManagement.GetLastComment(RECORDID)";QBApprovalManagement.GetLastComment(Rec.RECORDID))
    {
        
                CaptionML=ESP='Ult.Comentario';
}
    field("QBPurchaseHeaderExt.ID Usuario";QBPurchaseHeaderExt."ID Usuario")
    {
        
                CaptionML=ENU='User ID',ESP='ID Usuario';
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

}

actions
{
addafter("Print")
{
    action("QB_FichaContrato")
    {
        
                      CaptionML=ENU='Contract Card',ESP='Ficha contrato';
                      Promoted=true;
                      Image=Document;
                      PromotedCategory=Report;
                      
                                trigger OnAction()    BEGIN
                                 //Esta acci¢n se lanza desde la CU 7207349, funci¢n OnBeforeActionEvent_ContractCard, no poner c¢digo aqu¡
                               END;


}
    action("QB_PrintContract")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='Imprimir Contrato';
                      ToolTipML=ENU='Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.',ESP='Permite preparar el documento para su impresi¢n. Se abre la ventana de solicitud de informe para el documento, donde puede especificar qu‚ incluir en la impresi¢n.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Image=Print;
                      PromotedCategory=Report;
                      
                                trigger OnAction()    VAR
                                 QBPagePublisher : Codeunit 7207348;
                               BEGIN
                                 //JAV 14/03/19: - Se cambia la llamada a la funci¢n de impresi¢n de documentos para pasar tipo y n£mero de documento
                                 COMMIT;
                                 QBPagePublisher.PurchaseContractPrint(rec."Document Type", rec."No.");
                               END;


}
    action("QB_Annexed")
    {
        CaptionML=ENU='Annexed',ESP='Anexo';
                      Promoted=true;
                      Image=PrintCover;
                      PromotedCategory=Report;
}
} addafter("Request Approval")
{
group("QB_Approval")
{
        
                      CaptionML=ENU='Approval',ESP='Aprobaci¢n';
    action("QB_Approve")
    {
        
                      CaptionML=ENU='Approve',ESP='Aprobar';
                      ToolTipML=ENU='Approve the requested changes.',ESP='Aprueba los cambios solicitados.';
                      ApplicationArea=All;
                      Promoted=true;
                      Visible=OpenApprovalsPage;
                      PromotedIsBig=true;
                      Image=Approve;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                               END;


}
    action("QB_WithHolding")
    {
        
                      CaptionML=ENU='Reject',ESP='Retener';
                      ToolTipML=ENU='Reject the approval request.',ESP='Rechaza la solicitud de aprobaci¢n.';
                      ApplicationArea=All;
                      Promoted=true;
                      Visible=OpenApprovalsPage;
                      PromotedIsBig=true;
                      Image=Lock;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 cuApproval.WitHoldingApproval(Rec);
                               END;


}
    action("QB_Reject")
    {
        
                      CaptionML=ENU='Reject',ESP='Rechazar';
                      ToolTipML=ENU='Reject the approval request.',ESP='Rechaza la solicitud de aprobaci¢n.';
                      ApplicationArea=All;
                      Promoted=true;
                      Visible=OpenApprovalsPage;
                      PromotedIsBig=true;
                      Image=Reject;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                               END;


}
    action("QB_Delegate")
    {
        
                      CaptionML=ENU='Delegate',ESP='Delegar';
                      ToolTipML=ENU='Delegate the approval to a substitute approver.',ESP='Delega la aprobaci¢n a un aprobador sustituto.';
                      ApplicationArea=All;
                      Promoted=true;
                      Visible=OpenApprovalsPage;
                      Image=Delegate;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                               END;


}
    action("QB_Comment")
    {
        
                      CaptionML=ENU='Comments',ESP='Comentarios';
                      ToolTipML=ENU='View or add comments for the record.',ESP='Permite ver o agregar comentarios para el registro.';
                      ApplicationArea=All;
                      Promoted=true;
                      Visible=OpenApprovalsPage;
                      Image=ViewComments;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 ApprovalsMgmt : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;


}
}
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
                      PromotedCategory=Category4;
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
                      PromotedCategory=Category4;
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
                      PromotedCategory=Category4;
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
                      PromotedCategory=Category4;
                      
                                trigger OnAction()    VAR
                                 ReleaseComparativeQuote : Codeunit 7207332;
                               BEGIN
                                 cuApproval.PerformManualRelease(Rec);
                               END;


}
    action("QB_Reopen")
    {
        
                      CaptionML=ENU='Open',ESP='Volver a abrir';
                      Promoted=true;
                      Enabled=CanReopen;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      
                                trigger OnAction()    VAR
                                 ReleaseComparativeQuote : Codeunit 7207332;
                               BEGIN
                                 cuApproval.PerformManualReopen(Rec);
                               END;


}
}
}


modify("Approvals")
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
Visible=false ;


}


modify("SendApprovalRequest")
{
Visible=false;


}


modify("CancelApprovalRequest")
{
Visible=false;


}

}

//trigger
trigger OnOpenPage()    VAR
                 PurchasesPayablesSetup : Record 312;
               BEGIN
                 IF Rec.GETFILTER(rec."Receive") <> '' THEN
                   rec.FilterPartialReceived;
                 IF Rec.GETFILTER(rec."Invoice") <> '' THEN
                   rec.FilterPartialInvoiced;

                 rec.SetSecurityFilterOnRespCenter;

                 JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

                 rec.CopyBuyFromVendorFilter;
               END;
trigger OnAfterGetRecord()    BEGIN

                       JobDescription := '';
                       IF Job.GET(Rec."QB Job No.") THEN
                         JobDescription := Job.Description;

                       //JAV 14/03/19: - Remarcar si hay diferencias en el IVA
                       Rec.CALCFIELDS("Amount Including VAT", "Amount");
                       DifIVA := rec."Amount Including VAT" <> rec."Amount";

                       //-17046
                       QBPurchaseHeaderExt.Read(Rec);
                       //+17046

                       //-17064
                       QB_SetControlAppearance;
                       //+17064
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //rec."OLD_QB Approval Coment" := USERID;
                           CurrPage.DropArea.PAGE.SetFilter(Rec);
                           CurrPage.FilesSP.PAGE.SetFilter(Rec);

                           //-17064
                           QB_SetControlAppearance;
                           //+17064
                         END;


//trigger

var
      ReportPrint : Codeunit 228;
      JobQueueActive : Boolean ;
      OpenApprovalEntriesExist : Boolean;
      CanCancelApprovalForRecord : Boolean;
      SkipLinesWithoutVAT : Boolean;
      ReadyToPostQst : TextConst ENU='%1 out of %2 selected orders are ready for post. \Do you want to continue and post them?',ESP='%1 de los %2 pedidos seleccionados est n listos para el registro. \¨Desea continuar y registrarlos?';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      "---------------------------------- QB" : Integer;
      Job : Record 167;
      JobDescription : Text;
      DifIVA : Boolean ;
      QB_PurchReceiveFRISPreview : Codeunit 7206927;
      FunctionQB : Codeunit 7207272;
      seeDragDrop : Boolean;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206912;
      QBApprovalManagement : Codeunit 7207354;
      ApprovalsMgmt : Codeunit 1535;
      ApprovalsActive : Boolean;
      OpenApprovalsPage : Boolean;
      CanRequestApproval : Boolean;
      CanCancelApproval : Boolean;
      CanRelease : Boolean;
      CanReopen : Boolean;
      CanRequestDueApproval : Boolean;
      edProforms : Boolean;
      "--------------------------------------- QRE" : Integer;
      QREFunctions : Codeunit 7238197;
      QBPurchaseHeaderExt : Record 7238728;

    
    

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

    //[External]
//procedure SkipShowingLinesWithoutVAT();
//    begin
//      SkipLinesWithoutVAT := TRUE;
//    end;
//Local procedure ShowHeader() : Boolean;
//    var
//      CashFlowManagement : Codeunit 841;
//    begin
//      if ( not SkipLinesWithoutVAT  )then
//        exit(TRUE);
//
//      exit(CashFlowManagement.GetTaxAmountFromPurchaseOrder(Rec) <> 0);
//    end;
LOCAL procedure "-------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_SetControlAppearance();
    var
      Job : Record 167;
    begin
      //-17064
      cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
      //+17064
    end;

//procedure
}

