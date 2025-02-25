pageextension 50220 MyExtension52 extends 52//38
{
layout
{
addafter("Buy-from Vendor Name")
{
    field("QB_VATRegistrationNo";rec."VAT Registration No.")
    {
        
                Importance=Additional ;
}
    field("QB Job No.";rec."QB Job No.")
    {
        
                Visible=seeJob;
                
                          ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                             CurrPage.UPDATE;
                           END;

trigger OnLookup(var Text: Text): Boolean    VAR
                           JobNo : Code[20];
                         BEGIN
                           //JAV 25/07/19: - Al sacar la lista de proyectos, filtrar por los que se pueden ver por el usuario
                           JobNo := Rec."QB Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funci¢n
                           IF FunctionQB.LookupUserJobs(JobNo) THEN BEGIN
                             Rec.VALIDATE("QB Job No.", JobNo);
                             CurrPage.UPDATE(TRUE);
                           END;
                         END;


}
    field("QB Budget item";rec."QB Budget item")
    {
        
                Visible=seeQPR;
                Enabled=edQPR ;
}
    field("QB Contract No.";rec."QB Contract No.")
    {
        
                Visible=verContrato ;
}
    field("QB Order To";rec."QB Order To")
    {
        
}
} addfirst("factboxes")
{
    part("DropArea";7174655)
    {
        
                Visible=seeDragDrop;
}
    part("FilesSP";7174656)
    {
        
                Visible=seeDragDrop;
}
} addafter("Posting Description")
{
    field("QB_PostingNoSeries";rec."Posting No. Series")
    {
        
                Importance=Additional ;
}
    field("QB_ReturnShipmentNo";rec."Return Shipment No.")
    {
        
                Importance=Additional ;
}
} addafter("Buy-from Contact")
{
    field("QB_PostingNo";rec."Posting No.")
    {
        
                Importance=Additional ;
}
    field("QB Total document amount";rec."QB Total document amount")
    {
        
}
group("QB_GroupDate")
{
        
                CaptionML=ESP='Fechas';
}
} addafter("Posting Date")
{
    field("QB_SIIYearMonth";rec."QB SII Year-Month")
    {
        
                Visible=verSII ;
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
} addafter("Expected Receipt Date")
{
    field("QB Operation date SII";rec."QB Operation date SII")
    {
        
                Visible=verSII ;
}
    field("QB Do not send to SII";rec."QB Do not send to SII")
    {
        
                Visible=verSII ;
}
} addafter("Invoice Details")
{
group("Control1100286057")
{
        
                CaptionML=ESP='Prorrata de IVA';
                Visible=seeprorrata;
    field("DP Force Not Use Prorrata";rec."DP Force Not Use Prorrata")
    {
        
                ToolTipML=ESP='Si se marca este campo no se aplicar  la prorrata en ning£in caso, aunque el sistema calcule que si debe usarse';
                Visible=seeprorrata ;
}
    field("DP_ApplyProrrata>";rec."DP Apply Prorrata Type")
    {
        
                Visible=seeprorrata ;
}
    field("DP_ProrrataPercentaje";rec."DP Prorrata %")
    {
        
}
    field("DP Non Deductible VAT Amount";rec."DP Non Deductible VAT Amount")
    {
        
}
    field("DP Deductible VAT Amount";rec."DP Deductible VAT Amount")
    {
        
}
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
} addafter("Payment Method Code")
{
    field("QW Cod. Withholding by GE";rec."QW Cod. Withholding by GE")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                           END;


}
    field("QW Witholding Due Date";rec."QW Witholding Due Date")
    {
        
                Editable=QB_edGEDuedate ;
}
    field("QW Cod. Withholding by PIT";rec."QW Cod. Withholding by PIT")
    {
        
}
} addafter("Location Code")
{
    field("QB_PayableBankNo";rec."QB Payable Bank No.")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payable Bank No."))
    {
        
                CaptionML=ENU='Bank Name',ESP='Nombre del banco';
                Enabled=false ;
}
} addafter("Application")
{
group("Control7174339")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII Exercise-Period";rec."QuoSII Exercise-Period")
    {
        
}
    field("QuosII_DoNotSendToSI";rec."QB Do not send to SII")
    {
        
                ToolTipML=ESP='Si se marca este documento no subir  al SII, pero quedar  en la lista de documentos del SII como referencia';
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
}
    field("QuoSII Purch. Invoice Type";rec."QuoSII Purch. Invoice Type")
    {
        
                Enabled=PurchInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Purch. Cor. Inv. Type";rec."QuoSII Purch. Cor. Inv. Type")
    {
        
                Enabled=PurchCorrectedInvoiceTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Purch. Cr.Memo Type";rec."QuoSII Purch. Cr.Memo Type")
    {
        
                Enabled=PurchCrMemoTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Purch Special Regimen";rec."QuoSII Purch Special Regimen")
    {
        
}
    field("QuoSII Purch Special Regimen 1";rec."QuoSII Purch Special Regimen 1")
    {
        
}
    field("QuoSII Purch Special Regimen 2";rec."QuoSII Purch Special Regimen 2")
    {
        
}
    field("QuoSII Purch. UE Inv Type";rec."QuoSII Purch. UE Inv Type")
    {
        
                Enabled=PurchUEInvTypeB;
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
                             QuoSII_SetEditable;
                           END;


}
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Enabled=BienesDescriptionB ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Enabled=OperatorAddressB ;
}
    field("QuoSII Last Ticket No.";rec."QuoSII Last Ticket No.")
    {
        
                Enabled=LastTicketNoB ;
}
    field("QuoSII Third Party";rec."QuoSII Third Party")
    {
        
}
}
}


//modify("Posting Date")
//{
//
//
//}
//

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

//modify("Expected Receipt Date")
//{
//
//
//}
//

modify("Payment Terms Code")
{
Enabled=QB_edPagos ;


}


modify("Payment Method Code")
{
Enabled=QB_edPagos ;


}


modify("SII Information")
{
Visible=verSII;


}


//modify("Succeeded Company Name")
//{
//
//
//}
//
}

actions
{
addafter("Request Approval")
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
                      PromotedCategory=Category5;
                      
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
                      PromotedCategory=Category5;
                      
                                trigger OnAction()    VAR
                                 ReleaseComparativeQuote : Codeunit 7207332;
                               BEGIN
                                 cuApproval.PerformManualReopen(Rec);
                               END;


}
    action("QB_ControlContrato")
    {
        
                      CaptionML=ESP='Control Contrato';
                      Promoted=true;
                      Visible=vercontrato;
                      PromotedIsBig=true;
                      Image=ViewPage;
                      PromotedCategory=Category9;
                      
                                trigger OnAction()    VAR
                                 ControlContratos : Record 7206912;
                                 pgControlContratos : Page 7206922;
                               BEGIN
                                 //JAV 20/10/19: - Control de contratos, ver los registros
                                 ControlContratos.RESET;
                                 ControlContratos.SETRANGE(Proyecto, rec."QB Job No.");
                                 CLEAR(pgControlContratos);
                                 pgControlContratos.SETTABLEVIEW(ControlContratos);
                                 pgControlContratos.RUNMODAL;
                               END;


}
}
}


//modify("Statistics")
//{
//
//
//}
//

modify("Dimensions")
{

trigger OnBeforeAction()    BEGIN
Commit; //JAV 05/02/22: - QB 1.10.17 Para el error por el RunModal
END;

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


modify("GetPostedDocumentLinesToReverse")
{

trigger OnBeforeAction()    BEGIN
Commit; // Por el RunModal
END;

}


//modify("Copy Document")
//{
//
//
//}
//

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


modify("Flow")
{
Visible=false;


}


modify("SeeFlows")
{
Visible=false;


}


modify("Preview")
{

trigger OnBeforeAction()    VAR
                                 PurchPostYesNo : Codeunit 91;
                               BEGIN
Commit; //Por el RunModal
END;

}

}

//trigger
trigger OnOpenPage()    VAR
                 OfficeMgt : Codeunit 1630;
                 SIIManagement : Codeunit 10756;
                 PermissionManager : Codeunit 51256; //changed from 9002
               BEGIN
                 SetDocNoVisible;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsSaaS := PermissionManager.SoftwareAsAService;

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   Rec.FILTERGROUP(0);
                 END;
                 IF (rec."No." <> '') AND (rec."Buy-from Vendor No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 ActivateFields;

                 //JAV 04/07/19: - Control del SII de Mirosoft, se incluye la fecha de operaci¢n
                 verSII := FunctionQB.AccessToSII;

                 //Ver fases de pago
                 QB_verPaymentPhases := FunctionQB.AccessToPaymentPhases;
                 //JAV 12/07/20: - Ver Calculo vtos.
                 QB_verVtos := FunctionQB.AccessToChangeBaseVtos;

                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Purchase Header");
                 //Q7357 +

                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
               END;
trigger OnAfterGetRecord()    BEGIN
                       CalculateCurrentShippingOption;

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;

                       //QRE15449-INI
                       QB_PurchaseHeaderExt.Read(Rec);
                       //QRE15449-FIN
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           SIIManagement : Codeunit 10756;
                         BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RECORDID);

                           SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);
                           //JAV 27/10/21: - QB 1.09.25 Campos editables
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
      CopyPurchDoc : Report 492;
      MoveNegPurchLines : Report 6698;
      ReportPrint : Codeunit 228;
      UserMgt : Codeunit 5700;
      PurchCalcDiscByType : Codeunit 66;
      LinesInstructionMgt : Codeunit 1320;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      ShipToOptions: Option "Default (Vendor Address)","Alternate Vendor Address","Custom Address";
      JobQueueVisible : Boolean ;
      JobQueueUsed : Boolean ;
      HasIncomingDocument : Boolean;
      DocNoVisible : Boolean;
      VendorCreditMemoNoMandatory : Boolean;
      OpenApprovalEntriesExist : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      ShowWorkflowStatus : Boolean;
      IsOfficeAddin : Boolean;
      CanCancelApprovalForRecord : Boolean;
      DocumentIsPosted : Boolean;
      OpenPostedPurchCrMemoQst : TextConst ENU='The credit memo is posted as number %1 and moved to the Posted Purchase Credit Memos window.\\Do you want to open the posted credit memo?',ESP='La nota de cr‚dito se registr¢ con el n£mero %1 y se movi¢ a la ventana de notas de cr‚dito de compras registradas.\\¨Quiere abrir la nota de cr‚dito registrada?';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      OperationDescription : Text[500];
      IsSaaS : Boolean;
      IsBuyFromCountyVisible : Boolean;
      IsPayToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      "--------------------- QB" : Integer;
      QBPagePublisher : Codeunit 7207348;
      FunctionQB : Codeunit 7207272;
      Funcionesdecontratos : Codeunit 7206907;
      verContrato : Boolean ;
      verSII : Boolean ;
      QB_verPaymentPhases : Boolean;
      QB_edPagos : Boolean;
      QB_verVtos : Boolean;
      QB_edVtos : Boolean;
      QB_edGEDueDate : Boolean;
      SIISetup : Record 10751;
      seeJob : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
      seeDragDrop : Boolean;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      "--------------------------------------- QRE" : Integer;
      QREFunctions : Codeunit 7238197;
      QB_PurchaseHeaderExt : Record 7238728;
      "---------------------------- QuoSII" : Integer;
      SIIProcesing : Codeunit 7174332;
      vQuoSII : Boolean;
      PurchInvoiceTypeB : Boolean;
      PurchCorrectedInvoiceTypeB : Boolean;
      PurchCrMemoTypeB : Boolean;
      PurchUEInvTypeB : Boolean;
      BienesDescriptionB : Boolean;
      OperatorAddressB : Boolean;
      FirstTicketNoB : Boolean;
      LastTicketNoB : Boolean;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206928;
      QBApprovalManagement : Codeunit 7207354;
      ApprovalsMgmt : Codeunit 1535;
      ApprovalsActive : Boolean;
      OpenApprovalsPage : Boolean;
      CanRequestApproval : Boolean;
      CanCancelApproval : Boolean;
      CanRelease : Boolean;
      CanReopen : Boolean;
      CanRequestDueApproval : Boolean;
      verAppCircuit : Boolean;
      enAppCircuit : Boolean;

    
    

//procedure
Local procedure ActivateFields();
   begin
     IsBuyFromCountyVisible := FormatAddress.UseCounty(rec."Buy-from Country/Region Code");
     IsPayToCountyVisible := FormatAddress.UseCounty(rec."Pay-to Country/Region Code");
     IsShipToCountyVisible := FormatAddress.UseCounty(rec."Ship-to Country/Region Code");
   end;
//Local procedure Post(PostingCodeunitID : Integer);
//    var
//      PurchaseHeader : Record 38;
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
//      DocumentIsPosted := (not PurchaseHeader.GET(rec."Document Type",rec."No.")) or IsScheduledPosting;
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
//      CurrPage.UPDATE;
//    end;
//Local procedure ShortcutDimension2CodeOnAfterV();
//    begin
//      CurrPage.UPDATE;
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
     DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Credit Memo",rec."No.");
   end;
Local procedure SetExtDocNoMandatoryCondition();
   var
     PurchasesPayablesSetup : Record 312;
   begin
     PurchasesPayablesSetup.GET;
     VendorCreditMemoNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
   end;
Local procedure SetControlAppearance();
   var
     ApprovalsMgmt : Codeunit 1535;
     WorkflowWebhookMgt : Codeunit 1543;
   begin
     JobQueueVisible := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";
     HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
     SetExtDocNoMandatoryCondition;

     OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
     OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);

     CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);

     WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
   end;
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
//Local procedure ValidateShippingOption();
//    begin
//      CASE ShipToOptions OF
//        ShipToOptions::"Default (Vendor Address)":
//          begin
//            Rec.VALIDATE("Order Address Code",'');
//            Rec.VALIDATE("Buy-from Vendor No.");
//          end;
//        ShipToOptions::"Alternate Vendor Address":
//          Rec.VALIDATE("Order Address Code",'');
//      end
//    end;
Local procedure CalculateCurrentShippingOption();
   begin
     CASE TRUE OF
       rec."Order Address Code" <> '':
         ShipToOptions := ShipToOptions::"Alternate Vendor Address";
       rec.BuyFromAddressEqualsShipToAddress:
         ShipToOptions := ShipToOptions::"Default (Vendor Address)";
       ELSE
         ShipToOptions := ShipToOptions::"Custom Address";
     end;
   end;
LOCAL procedure "----------------------------------------------------------"();
    begin
    end;
LOCAL procedure QB_SetEditable();
    var
      Job : Record 167;
    begin
      QB_edPagos := (rec."QB Payment Phases" = '');
      QB_edVtos := (rec."QB Calc Due Date" = rec."QB Calc Due Date"::Reception);

      QB_edGEDueDate := (rec."QW Cod. Withholding by GE" <> '');

      //QB JAV 12/05/20_ Aprobaciones de QuoBuilding, se llama a la funci¢n para activar los controles de aprobaci¢n
      cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
      OpenApprovalEntriesExistForCurrUser := FALSE; //No se ven las del est ndar
      enAppCircuit := CanRequestApproval and (rec."OLD_QB Approval Situation" = rec."OLD_QB Approval Situation"::Pending);  //Si se puede generar un circuito y est  pendiente estar  habilitado

      //JAV 27/10/21: - QB 1.09.25 Campos de presupuestos editables y l¡neas
      edQPR := FunctionQB.Job_IsBudget(Rec."QB Job No.");
      CurrPage.PurchLines.PAGE.QB_SetTxtPiecework(Rec."QB Job No.");

      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      QuoSII_SetEditable;
    end;
LOCAL procedure QuoSII_SetEditable();
    begin
      //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII
      if ( (vQuoSII)  )then
        SIIProcesing.PG_Compras_SetFieldNotEditable(Rec,PurchInvoiceTypeB,PurchCorrectedInvoiceTypeB,PurchCrMemoTypeB,PurchUEInvTypeB,BienesDescriptionB,
                                                        OperatorAddressB,FirstTicketNoB,LastTicketNoB);

      Rec."Due Date" := Rec."Due Date" ;
    end;

//procedure
}

