pageextension 50252 MyExtension7000002 extends 7000002//7000002
{
layout
{
addfirst("Control1")
{
    field("On Hold";rec."On Hold")
    {
        
}
} addafter("Document No.")
{
    field("QB_ExternalDocumentNo";rec."External Document No.")
    {
        
}
} addafter("Account No.")
{
    field("QB_VendorName";rec."Vendor Name")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("ObraliaLogEntry.GetResponsePagos";ObraliaLogEntry.GetResponsePagos)
    {
        
                CaptionML=ESP='Semaforo';
                Visible=vObralia;
                Editable=FALSE;
                StyleExpr=ObraliaStyle;
                
                              ;trigger OnAssistEdit()    VAR
                               ObraliaLogEntry : Record 7206904;
                             BEGIN
                               ObraliaLogEntry.ViewResponse(rec."Obralia Entry");
                             END;


}
    field("QB_ApprovalStatus";rec."Approval Status")
    {
        
}
    field("QB Approval Circuit Code";rec."QB Approval Circuit Code")
    {
        
                ToolTipML=ESP='Que circuito de aprobaci¢n que se utilizar  para este documento';
                Enabled=CanRequestApproval ;
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
    field("QB_CertificadosVencidos";"txtCert")
    {
        
                CaptionML=ESP='Certificados Vencidos';
                Editable=false;
                StyleExpr=Style3 ;
}
    field("QB_PaymentBankNo";rec."QB Payment bank No.")
    {
        
}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payment bank No."))
    {
        
                CaptionML=ENU='Own Bank Name',ESP='Nombre del banco propio';
                Enabled=false ;
}
} addafter("Entry No.")
{
    field("Approval Check 1";rec."Approval Check 1")
    {
        
                Visible=vApp1;
                Editable=edAppAd ;
}
    field("Approval Check 2";rec."Approval Check 2")
    {
        
                Visible=vApp2;
                Editable=edAppAd ;
}
    field("Approval Check 3";rec."Approval Check 3")
    {
        
                Visible=vApp3;
                Editable=edAppAd ;
}
    field("Approval Check 4";rec."Approval Check 4")
    {
        
                Visible=vApp4;
                Editable=edAppAd ;
}
    field("Approval Check 5";rec."Approval Check 5")
    {
        
                Visible=vApp5;
                Editable=edAppAd ;
}
} addfirst("factboxes")
{    part("IncomingDocAttachFactBox";193)
    {
        
                ApplicationArea=Basic,Suite;
                ShowFilter=false ;
}
} addafter("Control1901421107")
{
}

}

actions
{
addafter("Documents Maturity")
{
    action("QB_Obralia1")
    {
        
                      CaptionML=ENU='Obralia',ESP='Verficar en Obralia';
                      Promoted=true;
                      Visible=vObralia;
                      Enabled=aObralia;
                      PromotedIsBig=true;
                      Image=Web;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 Obralia : Codeunit 7206901;
                                 ObraliaLogEntry : Record 7206904;
                                 Response : Text[1];
                                 ConfirmObralia : TextConst ENU='Do you want to check Obralia staus?',ESP='¨Desea comprobar el estado en Obralia?';
                               BEGIN
                                 //OBR
                                 IF CONFIRM(ConfirmObralia, FALSE) THEN
                                   Rec.VALIDATE("Obralia Entry", Obralia.SemaforoRequest_CarteraDoc(Rec,TRUE));
                               END;


}
    action("QB_Obralia2")
    {
        
                      CaptionML=ENU='Obralia',ESP='Verif.Varios Obralia';
                      Promoted=true;
                      Visible=FALSE;
                      PromotedIsBig=true;
                      Image=LaunchWeb;
                      PromotedCategory=Process;
                      
                              //   trigger OnAction()    VAR
                              //    ObraliaCarteraDocQueue : Report 7207425;
                              //    ConfirmObralia : TextConst ENU='Do you want to check Obralia staus?',ESP='¨Desea comprobar el estado en Obralia?';
                              //  BEGIN
                              //    //OBR
                              //    CLEAR(ObraliaCarteraDocQueue);
                              //    ObraliaCarteraDocQueue.RUN;
                              //  END;


}
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
                      PromotedCategory=Category6;
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
                      PromotedCategory=Category6;
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
                      PromotedCategory=Category6;
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
                      PromotedCategory=Category6;
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
                      PromotedCategory=Category6;
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
                      PromotedCategory=Category5;
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
                      PromotedCategory=Category5;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 cuApproval.SendApproval(Rec);
                               END;


}
    action("QB_SendApprovalRequest2")
    {
        
                      CaptionML=ENU='Send Due Approval Request',ESP='Enviar sol. apr. Cert.Vencido';
                      ToolTipML=ENU='Request approval of the document.',ESP='Permite solicitar la aprobaci¢n del documento con certificado vencido.';
                      ApplicationArea=Basic,Suite;
                      Promoted=true;
                      Visible=ApprovalsActive;
                      Enabled=CanRequestDueApproval;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=true;
                      
                                trigger OnAction()    BEGIN
                                 cuApproval.SendDueApproval(Rec);
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
                      PromotedCategory=Category5;
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

}

//trigger
trigger OnOpenPage()    BEGIN
                 CategoryFilter := Rec.GETFILTER("Category Code");
                 UpdateStatistics;

                 //QB
                 FunctionQB.SetUserJobCarteraDocFilter(Rec);                 //JAV 26/01/21: - QB Filtro de proyectos permitidos para el usuario
                 cuApproval.SetCheckVisible(vApp1,vApp2,vApp3,vApp4,vApp5);  //Establecer los checks adicionales
                 cuApproval.AutomaticApprove;                                //Aprobar los que no tengan proyecto
                 vObralia := (FunctionQB.AccessToObralia);                   //Obralia
               END;
trigger OnAfterGetCurrRecord()    BEGIN
                           //QB - Abrir el FactBox del archivo del documento
                           GetDocument(FALSE);
                         END;


//trigger

var
      Text1100000 : TextConst ENU='Payable Bills cannot be printed.',ESP='No se pueden imprimir los efectos a pagar.';
      Text1100001 : TextConst ENU='Only Receivable Bills can be rejected.',ESP='S¢lo se pueden impagar efectos a cobrar.';
      Text1100002 : TextConst ENU='Only  Bills can be rejected.',ESP='S¢lo se pueden impagar efectos.';
      Doc : Record 7000002;
      CustLedgEntry : Record 21;
      SalesInvHeader : Record 112;
      PurchInvHeader : Record 122;
      CarteraManagement : Codeunit 7000000;
      CategoryFilter : Code[250];
      CurrTotalAmountLCY : Decimal;
      ShowCurrent : Boolean;
      CurrTotalAmountVisible : Boolean ;
      "---------------------------- QB" : Integer;
      txtCert : Text;
      Style1 : Text;
      Style2 : Text;
      Style3 : Text;
      QualityManagement : Codeunit 7207293;
      FunctionQB : Codeunit 7207272;
      Job : Record 167;
      vObralia : Boolean;
      aObralia : Boolean;
      Obralia : Codeunit 7206901;
      ObraliaLogEntry : Record 7206904;
      ObraliaStyle : Text;
      "--------------------------------- QB Ver Doc" : Integer;
      vDocumento : Boolean;
      seeWithHolding : Boolean;
      CarteraDoc : Record 7000002;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206917;
      QBApprovalManagement : Codeunit 7207354;
      ApprovalsMgmt : Codeunit 1535;
      ApprovalsActive : Boolean;
      OpenApprovalsPage : Boolean;
      CanRequestApproval : Boolean;
      CanCancelApproval : Boolean;
      CanRelease : Boolean;
      CanReopen : Boolean;
      CanRequestDueApproval : Boolean;
      vApp1 : Boolean;
      vApp2 : Boolean;
      vApp3 : Boolean;
      vApp4 : Boolean;
      vApp5 : Boolean;
      edAppAd : Boolean;

    

//procedure
//procedure UpdateStatistics();
//    begin
//      Doc.COPY(Rec);
//      CarteraManagement.UpdateStatistics(Doc,CurrTotalAmountLCY,ShowCurrent);
//      CurrTotalAmountVisible := ShowCurrent;
//    end;
//
//    //[External]
//procedure GetSelected(var NewDoc : Record 7000002);
//    begin
//      CurrPage.SETSELECTIONFILTER(NewDoc);
//    end;
//
//    //[External]
//procedure PrintDoc();
//    begin
//      CurrPage.SETSELECTIONFILTER(Doc);
//      if ( not Doc.FIND('-')  )then
//        exit;
//
//      if ( (Doc.Type <> Doc.Type::ivable) and (Doc."Document Type" = Doc."Document Type"::Bill)  )then
//        ERROR(Text1100000);
//
//      if ( Doc.Type = Doc.Type::ivable  )then begin
//        if ( Doc."Document Type" = Doc."Document Type"::Bill  )then begin
//          CustLedgEntry.RESET;
//          repeat
//            CustLedgEntry.GET(Doc."Entry No.");
//            CustLedgEntry.MARK(TRUE);
//          until Doc.NEXT = 0;
//
//          CustLedgEntry.MARKEDONLY(TRUE);
//          CustLedgEntry.PrintBill(TRUE);
//        end ELSE begin
//          SalesInvHeader.RESET;
//          repeat
//            SalesInvHeader.GET(Doc."Document No.");
//            SalesInvHeader.MARK(TRUE);
//          until Doc.NEXT = 0;
//
//          SalesInvHeader.MARKEDONLY(TRUE);
//          SalesInvHeader.PrintRecords(TRUE);
//        end;
//      end ELSE begin
//        PurchInvHeader.RESET;
//        repeat
//          PurchInvHeader.GET(Doc."Document No.");
//          PurchInvHeader.MARK(TRUE);
//        until Doc.NEXT = 0;
//
//        PurchInvHeader.MARKEDONLY(TRUE);
//        PurchInvHeader.PrintRecords(TRUE);
//      end;
//    end;
//
//    //[External]
//procedure Reject();
//    begin
//      if ( Doc.Type <> Doc.Type::ivable  )then
//        ERROR(Text1100001);
//      if ( Doc."Document Type" <> rec."Document Type"::Bill  )then
//        ERROR(Text1100002);
//
//      CurrPage.SETSELECTIONFILTER(Doc);
//      if ( not Doc.FIND('-')  )then
//        exit;
//
//      CustLedgEntry.RESET;
//      repeat
//        CustLedgEntry.GET(Doc."Entry No.");
//        CustLedgEntry.MARK(TRUE);
//      until Doc.NEXT = 0;
//
//      CustLedgEntry.MARKEDONLY(TRUE);
//      REPORT.RUNMODAL(REPORT::"Reject Docs.",TRUE,FALSE,CustLedgEntry);
//    end;
//Local procedure CategoryFilterOnAfterValidate();
//    begin
//      Rec.SETFILTER("Category Code",CategoryFilter);
//      CurrPage.UPDATE(FALSE);
//      UpdateStatistics;
//    end;
LOCAL procedure AfterGetCurrentRecord();
    begin
      xRec := Rec;
      UpdateStatistics;

      //JAV 10/03/20: - Se llama a la funci¢n para activar los controles de aprobaci¢n
      cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen, CanRequestDueApproval);

      //Presentar los certificados vencidos y colores por aprobaciones
      QualityManagement.VendorCertificatesDued(rec."Account No.", TODAY, txtCert);

      Style1 := 'none';
      Style2 := 'none';
      Style3 := 'none';

      if ( not (rec."Approval Status" IN [rec."Approval Status"::Released, rec."Approval Status"::"Due Released"])  )then begin
        Style1 := 'Attention';
        Style2 := 'Attention';
      end;

      if ( (txtCert <> '') and (rec."Approval Status" <> rec."Approval Status"::"Due Released")  )then begin
        Style1 := 'Attention';
        Style3 := 'Attention';
      end;

      if ( not ObraliaLogEntry.GET(rec."Obralia Entry")  )then
        ObraliaLogEntry.INIT
      ELSE
        ObraliaStyle := ObraliaLogEntry.GetResponseStyle;

      aObralia := FALSE;
      if ( Job.GET(rec."Job No.")  )then
        aObralia := (Job."Obralia Code" <> '');

      //JAV 28/06/22: - QB 1.10.54 Obtener si los checks adicionales son editables
      edAppAd := cuApproval.CheckEditables(Rec);
    end;
LOCAL procedure "---------------------- QB"();
    begin
    end;
LOCAL procedure GetDocument(pVer : Boolean) : Boolean;
    var
      CarteraDoc : Record 7000002;
      recref : RecordRef;
      PurchaseHeader : Record 38;
      PurchInvHeader : Record 122;
      PostedPurchaseInvoice : Page 138;
      PurchaseInvoice : Page 51;
    begin
      if ( (not PurchInvHeader.GET(Rec."Document No."))  )then
        PurchInvHeader.INIT;

      if ( (pVer)  )then begin
        CLEAR(PostedPurchaseInvoice);
        PostedPurchaseInvoice.SETRECORD(PurchInvHeader);
        PostedPurchaseInvoice.RUNMODAL;
      end ELSE begin
        vDocumento := TRUE;
        seeWithHolding := TRUE;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(PurchInvHeader);
        CurrPage.IncomingDocAttachFactBox.PAGE.SendUpdate;
      end;
    end;

//procedure
}

