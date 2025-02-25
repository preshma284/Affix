pageextension 50267 MyExtension7000050 extends 7000050//7000020
{
layout
{
addafter("Export Electronic Payment")
{
    field("QB_ElectPmtsExported";rec."Elect. Pmts Exported")
    {
        
                Editable=false ;
}
    field("Confirming";rec."Confirming")
    {
        
                Visible=seeConfirming ;
}
    field("Confirming Line";rec."Confirming Line")
    {
        
                Visible=seeConfirming ;
}
group("Control1100286020")
{
        
                CaptionML=ESP='Aprobaci¢n';
                Visible=ApprovalsActive;
    field("QB Department";rec."QB Department")
    {
        
}
    field("QB Approval Circuit Code";rec."QB Approval Circuit Code")
    {
        
                ToolTipML=ESP='Que circuito de aprobaci¢n que se utilizar  para este documento';
                Enabled=CanRequestApproval ;
}
    field("Approval Status";rec."Approval Status")
    {
        
}
    field("QBApprovalManagement.GetLastStatus(RECORDID, Approval Status)";QBApprovalManagement.GetLastStatus(Rec.RECORDID, rec."Approval Status"))
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
}
}

}

actions
{
addafter("Export")
{
    action("QB_GenerarPagoElectronico")
    {
        
                      CaptionML=ESP='Generar Pago Electr¢nico';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 QBReportSelections : Record 7206901;
                                 ExportAgainQst : TextConst ENU='The selected payment order has already been exported. Do you want to export again?',ESP='Ya he generado un pago electroncio para esta orden de pago.\¨Desea repetir la exportaci¢n?';
                                 GenerateElectronicsPayments : Codeunit 7206908;
                               BEGIN
                                 //JAV 03/10/19: - Se utiliza el nuevo selector de informes para la generaci¢n del pago electr¢nico
                                 //JAV 26/10/20: - QB 1.07.00 Verificar si se puede ejecutar por estar aprobado
                                 //JAV 14/09/21: - QB 1.09.17 Nuevo proceso para generar los formatos sin necesidad de usar reports

                                 cuApproval.VerifyApprovalStatus(Rec);

                                 IF NOT Rec.FIND THEN  //Solo si est  guardado
                                   EXIT;

                                 IF (rec."Elect. Pmts Exported") THEN
                                   IF (NOT CONFIRM(ExportAgainQst)) THEN
                                     EXIT;

                                 CancelElectronicPayments;

                                 BankAccount.GET(rec."Bank Account No.");
                                 GenerateElectronicsPayments.Launch(Rec."No.", BankAccount."Electronic Report");

                                 // PmtOrd.RESET;
                                 // PmtOrd := Rec;
                                 // PmtOrd.SETRECFILTER;
                                 //
                                 //
                                 // IF (BankAccount."Electronic Report" <> 0) THEN
                                 //  QBReportSelections.PrintOneReport(BankAccount."Electronic Report", PmtOrd)
                                 // ELSE
                                 //  QBReportSelections.Print(QBReportSelections.Usage::G1, PmtOrd);
                               END;


}
    action("Action100000000")
    {
        CaptionML=ESP='Cancelar Pago Electr¢nico';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=VoidElectronicDocument;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 QBReportSelections : Record 7206901;
                                 CancelEP : TextConst ENU='The selected payment order has already been exported. Do you want to export again?',ESP='Esto cancelar  el pago electr¢nico generado.\¨Confirma que desea cancelarlo?';
                               BEGIN
                                 //JAV 14/03/20: - Cancelar el pago electr¢nico generado
                                 IF NOT Rec.FIND THEN
                                   EXIT;

                                 IF (rec."Elect. Pmts Exported") THEN
                                   IF (CONFIRM(CancelEP)) THEN
                                     CancelElectronicPayments;
                               END;


}
} addafter("Page Payment Orders Maturity Process")
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
                      PromotedCategory=Category9;
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
                      PromotedCategory=Category9;
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
                      PromotedCategory=Category9;
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
                      PromotedCategory=Category9;
                      
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
                      PromotedCategory=Category9;
                      
                                
    trigger OnAction()    VAR
                                 ReleaseComparativeQuote : Codeunit 7207332;
                               BEGIN
                                 cuApproval.PerformManualReopen(Rec);
                               END;


}
}
}


//modify("Export")
//{
//
//
//}
//

//modify("Post")
//{
//
//
//}
//

//modify("Post and &Print")
//{
//
//
//}
//
}

//trigger
trigger OnOpenPage()    BEGIN
                 //rec."Confirming"
                 seeConfirming := (QBCartera.IsFactoringActive);

                 //JAV 23/10/20: - QB 1.07.00 Aprobaciones de QuoBuilding, se llama a la funci¢n para activar los controles de aprobaci¢n
                 cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
               END;
trigger OnAfterGetRecord()    BEGIN
                       //JAV 23/10/20: - QB 1.07.00 Aprobaciones de QuoBuilding, se llama a la funci¢n para activar los controles de aprobaci¢n
                       cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
                     END;


//trigger

var
      PmtOrd : Record 7000020;
      PostBGPO : Codeunit 7000003;
      Navigate : Page 344;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206927;
      QBApprovalManagement : Codeunit 7207354;
      ApprovalsMgmt : Codeunit 1535;
      ApprovalsActive : Boolean;
      OpenApprovalsPage : Boolean;
      CanRequestApproval : Boolean;
      CanCancelApproval : Boolean;
      CanRelease : Boolean;
      CanReopen : Boolean;
      "------------------------------ QB" : Integer;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;
      BankAccount : Record 270;

    
    

//procedure
LOCAL procedure CancelElectronicPayments();
    var
      CarteraDoc : Record 7000002;
    begin
      rec."Export Electronic Payment" := FALSE;
      rec."Elect. Pmts Exported" := FALSE;
      Rec.MODIFY;

      CarteraDoc.RESET;
      CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
      CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", rec."No.");
      CarteraDoc.MODIFYALL("Elect. Pmts Exported", FALSE);
      COMMIT;
    end;
LOCAL procedure "------------------------------------- QB"();
    begin
    end;
LOCAL procedure VerifyApp();
    begin
    end;

//procedure
}

