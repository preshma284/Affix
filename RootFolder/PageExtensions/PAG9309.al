pageextension 50292 MyExtension9309 extends 9309//38
{
layout
{
addafter("Posting Date")
{
    field("QB_OperationDateSII";rec."QB Operation date SII")
    {
        
                Visible=verSII;
                Editable=FALSE ;
}
} addfirst("FactBoxes")
{
    field("QB_ReceiptDate";rec."QB Receipt Date")
    {
        
}
    field("QB Total document amount";rec."QB Total document amount")
    {
        
}
} addafter("Job Queue Status")
{
    part("DropArea";7174655)
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
addafter("Finance")
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


modify("Approvals")
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

}

//trigger
trigger OnOpenPage()    VAR
                 PurchasesPayablesSetup : Record 312;
                 OfficeMgt : Codeunit 1630;
               BEGIN
                 rec.SetSecurityFilterOnRespCenter;

                 JobQueueActive := PurchasesPayablesSetup.JobQueueActive;
                 IsOfficeAddin := OfficeMgt.IsAvailable;

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
                       //QB
                       QB_SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           //QB
                           QB_SetEditable;

                           //+Q8636
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //-Q8636
                         END;


//trigger

var
      ReportPrint : Codeunit 228;
      LinesInstructionMgt : Codeunit 1320;
      JobQueueActive : Boolean ;
      OpenApprovalEntriesExist : Boolean;
      IsOfficeAddin : Boolean;
      CanCancelApprovalForRecord : Boolean;
      OpenPostedPurchCrMemoQst : TextConst ENU='The credit memo is posted as number %1 and moved to the Posted Purchase Credit Memos window.\\Do you want to open the posted credit memo?',ESP='La nota de cr‚dito se registr¢ con el n£mero %1 y se movi¢ a la ventana de notas de cr‚dito de compras registradas.\\¨Quiere abrir la nota de cr‚dito registrada?';
      ReadyToPostQst : TextConst ENU='%1 out of %2 selected credit memos are ready for post. \Do you want to continue and post them?',ESP='%1 de los %2 abonos seleccionados est n listos para el registro. \¨Desea continuar y registrarlas?';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      "--------------------------------------- QB" : Integer;
      verSII : Boolean ;
      FunctionQB : Codeunit 7207272;
      seeDragDrop : Boolean;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206928;
      ApprovalsMgmt : Codeunit 1535;
      ApprovalsActive : Boolean;
      OpenApprovalsPage : Boolean;
      CanRequestApproval : Boolean;
      CanCancelApproval : Boolean;
      CanRelease : Boolean;
      CanReopen : Boolean;
      CanRequestDueApproval : Boolean;

    
    

//procedure
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookManagement : Codeunit 1543;
   begin
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

     WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
   end;
//Local procedure CheckPurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader : Record 38);
//    var
//      ApplicationAreaMgmtFacade : Codeunit 9179;
//      LinesInstructionMgt : Codeunit 1320;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader);
//    end;
//Local procedure Post(PostingCodeunitID : Integer);
//    var
//      PurchCrMemoHdr : Record 124;
//      ApplicationAreaMgmtFacade : Codeunit 9179;
//      InstructionMgt : Codeunit 1330;
//      IsScheduledPosting : Boolean;
//    begin
//      if ( ApplicationAreaMgmtFacade.IsFoundationEnabled  )then
//        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);
//
//      rec.SendToPosting(PostingCodeunitID);
//
//      IsScheduledPosting := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";
//
//      if ( IsScheduledPosting  )then
//        CurrPage.CLOSE;
//      CurrPage.UPDATE(FALSE);
//
//      if ( PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)"  )then
//        exit;
//
//      if ( IsOfficeAddin  )then begin
//        PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",rec."No.");
//        if ( PurchCrMemoHdr.FINDFIRST  )then
//          PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
//      end ELSE
//        if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//          ShowPostedConfirmationMessage;
//    end;
//Local procedure ShowPostedConfirmationMessage();
//    var
//      PurchCrMemoHdr : Record 124;
//      InstructionMgt : Codeunit 1330;
//    begin
//      PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",rec."No.");
//      if ( PurchCrMemoHdr.FINDFIRST  )then
//        if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedPurchCrMemoQst,PurchCrMemoHdr."No."),
//             InstructionMgt.ShowPostedConfirmationMessageCode)
//        then
//          PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
//    end;
LOCAL procedure "-------------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    begin
      //QB JAV 12/05/20_ Aprobaciones de QuoBuilding, se llama a la funci¢n para activar los controles de aprobaci¢n
      cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
    end;

//procedure
}

