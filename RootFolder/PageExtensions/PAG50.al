pageextension 50208 MyExtension50 extends 50//38
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
                           JobNo := Rec."QB Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funciï¿½n
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
    field("Receiving No. Series";rec."Receiving No. Series")
    {
        
                CaptionML=ENU='rec."Receiving No. Series"',ESP='Nï¿½ serie FRI';
                Visible=verRegisterSeries ;
}
} addafter("Assigned User ID")
{
group("QB_Checks")
{
        
                CaptionML=ESP='Documento QB';
    field("QB Contract";rec."QB Contract")
    {
        
                ToolTipML=ESP='Indica si el documento rpoviene de un comprativo y por tanto es un contrato de compra';
                Importance=Promoted;
                
                              ;trigger OnAssistEdit()    VAR
                               ComparativeQuoteHeader : Record 7207412;
                               ComparativeQuote : Page 7207546;
                             BEGIN
                               //JAV 04/08/22: - QB 1.11.01 Navegar al comparativo de origen
                               IF (rec."QB Contract") THEN BEGIN
                                 ComparativeQuoteHeader.RESET;
                                 ComparativeQuoteHeader.SETRANGE("Generated Contract Doc Type", Rec."Document Type");
                                 ComparativeQuoteHeader.SETRANGE("Generated Contract Doc No.", Rec."No.");

                                 CLEAR(ComparativeQuote);
                                 ComparativeQuote.SETTABLEVIEW(ComparativeQuoteHeader);
                                 ComparativeQuote.SETRECORD(ComparativeQuoteHeader);
                                 ComparativeQuote.RUNMODAL;
                               END;
                             END;


}
    field("QB Manage by Proforms";rec."QB Manage by Proforms")
    {
        
                Editable=edProforms ;
}
    field("QB No. Generated Proforms";rec."QB No. Generated Proforms")
    {
        
}
    field("QB % Proformar";rec."QB % Proformar")
    {
        
                ToolTipML=ESP='Si el documento puede generar proformas (tiene lï¿½neas de tipo recurso o lï¿½neas con productos proformables), indica el % por defecto de la cantidad a recibir que se propone como cantidad a generar proforma';
}
}
group("QB_GroupDate")
{
        
                CaptionML=ESP='Fechas';
}
} addafter("Document Date")
{
    field("QB_SIIYearMonth";rec."QB SII Year-Month")
    {
        
                Visible=verSII ;
}
    field("QB Calc Due Date";rec."QB Calc Due Date")
    {
        
                Visible=QB_verVtos;
                Editable=QB_edPagos;
                
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
} addafter("Order Date")
{
    field("QB Receipt Date";rec."QB Receipt Date")
    {
        
}
} addafter("Vendor Invoice No.")
{
//     field("Vendor Posting Group";rec."Vendor Posting Group")
//     {
        
// }
} addafter("Status")
{
    field("QB Stocks New Functionality";rec."QB Stocks New Functionality")
    {
        
}
group("Control1100286154")
{
        
                CaptionML=ESP='Aprobaciï¿½n';
    field("QB Approval Job No";rec."QB Approval Job No")
    {
        
                ToolTipML=ESP='Indica el proyecto que se usarï¿½ para aprobar este documento, puede ser diferente al establecido para el documento en general';
}
    field("QB Approval Budget item";rec."QB Approval Budget item")
    {
        
                ToolTipML=ESP='Indica la partida presupuestaria o la U.Obra que se usarï¿½ para aprobar este documento, puede ser diferente al establecido para el documento en general>';
}
    field("QB Approval Circuit Code";rec."QB Approval Circuit Code")
    {
        
                ToolTipML=ESP='Que circuito de aprobaciï¿½n que se utilizarï¿½ para este documento';
                Enabled=CanRequestApproval;
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           //QRE16699+
                           rQBApprovalCircuitHeader.RESET;
                           rQBApprovalCircuitHeader.FILTERGROUP(1);
                           rQBApprovalCircuitHeader.SETRANGE("Document Type", rQBApprovalCircuitHeader."Document Type"::PurchaseOrder);

                           //JAV 06/05/22: - Si se filtra fuerza mucho a que no se pueda cambiar el circuito, si ese es el objetivo se debe cambiar el mï¿½todo de uso, pero lo mantenemos por Culmia
                           IF (Job.GET(rec."QB Job No.")) THEN BEGIN
                             IF Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion] THEN BEGIN
                               rQBApprovalCircuitHeader.SETFILTER("Job No.", '%1|%2', '', Rec."QB Job No.");
                               rQBApprovalCircuitHeader.SETFILTER(CA, '%1|%2', '', Rec."QB Budget item");
                             END;
                           END;

                           CLEAR(pQBApprovalCircuitList);
                           pQBApprovalCircuitList.SETTABLEVIEW(rQBApprovalCircuitHeader);
                           pQBApprovalCircuitList.LOOKUPMODE(TRUE);
                           IF (pQBApprovalCircuitList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                             pQBApprovalCircuitList.GETRECORD(rQBApprovalCircuitHeader);
                             Rec."QB Approval Circuit Code" := rQBApprovalCircuitHeader."Circuit Code";
                           END;
                           //QRE16699-
                         END;


}
    field("QBApprovalManagement.GetLastStatus(RECORDID, Status)";QBApprovalManagement.GetLastStatus(Rec.RECORDID, rec."Status".AsInteger()))
    {
        
                CaptionML=ESP='Situaciï¿½n';
}
    field("QBApprovalManagement.GetLastDateTime(RECORDID)";QBApprovalManagement.GetLastDateTime(Rec.RECORDID))
    {
        
                CaptionML=ESP='Ult.Acciï¿½n';
}
    field("QBApprovalManagement.GetLastComment(RECORDID)";QBApprovalManagement.GetLastComment(Rec.RECORDID))
    {
        
                CaptionML=ESP='Ult.Comentario';
}
}
} addfirst("Invoice Details")
{
    field("Posting No.";rec."Posting No.")
    {
        
}
    field("QB Order To";rec."QB Order To")
    {
        
}
} addafter("VAT Bus. Posting Group")
{
    field("QB Payment Phases";rec."QB Payment Phases")
    {
        
                Visible=QB_verPaymentPhases;
                
                              ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                           END;

trigger OnAssistEdit()    BEGIN
                               QBPaymentPhasesandDueDate.SeeDocumentPhases(Rec);
                             END;


}
} addafter("Payment Method Code")
{
    field("Cod. Withholding by G.E";rec."QW Cod. Withholding by GE")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             QB_SetEditable;
                           END;


}
    field("QW Witholding Due Date";rec."QW Witholding Due Date")
    {
        
                Editable=QB_edGEDuedate ;
}
    field("Cod. Withholding by PIT";rec."QW Cod. Withholding by PIT")
    {
        
}
} addafter("Promised Receipt Date")
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
} addafter("Prepayment")
{
group("Control7174341")
{
        
                CaptionML=ENU='QuoSII',ESP='QuoSII';
                Visible=vQuoSII;
    field("QuoSII Exercise-Period";rec."QuoSII Exercise-Period")
    {
        
}
    field("QB Do not send to SII";rec."QB Do not send to SII")
    {
        
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
group("Control7001106")
{
        
                CaptionML=ENU='Contract',ESP='Contrato';
                Visible=seeRE ;
    field("QBPurchaseHeaderExt.QB_Validacion Portal Proveedor";QBPurchaseHeaderExt."QB_Validacion Portal Proveedor")
    {
        
                CaptionML=ESP='Validacion Portal Proveedor';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.QB_coCertificacion";QBPurchaseHeaderExt.QB_coCertificacion)
    {
        
                CaptionML=ESP='Cï¿½d. Certificaciï¿½n';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBBudgetitem";QBPurchaseHeaderExt."QB_Budget item")
    {
        
                CaptionML=ESP='Partida Presupuestaria';
                TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=field("QB Job No."),"Account Type"=FILTER("Unit"));
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
}
group("Control1100286058")
{
        
                CaptionML=ESP='Real Estate';
                Visible=seeRE;
    field("QBPurchaseHeaderExt.QB_Classif Code 1";QBPurchaseHeaderExt."QB_Classif Code 1")
    {
        
                CaptionML=ESP='Cï¿½d Clasif. 1';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.QB_Expense Interface Entry No.";QBPurchaseHeaderExt."QB_Expense Interface Entry No.")
    {
        
                CaptionML=ESP='Nï¿½ mov. interfaz gastos';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.QB_Cod. Fact. Gastos";QBPurchaseHeaderExt."QB_Cod. Fact. Gastos")
    {
        
                CaptionML=ESP='Cï¿½d. Fact. Gastos';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.QB_inREGE";QBPurchaseHeaderExt.QB_inREGE)
    {
        
                CaptionML=ESP='REGE';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.QB_Tipo ID Externo";QBPurchaseHeaderExt."QB_Tipo ID Externo")
    {
        
                CaptionML=ESP='Tipo ID Externo';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.QB_DevengoIVAdifretenciones";QBPurchaseHeaderExt.QB_DevengoIVAdifretenciones)
    {
        
                CaptionML=ESP='Devengo IVA dif. retenciones';
                
                            ;trigger OnValidate()    BEGIN
                             SaveExtRec();
                           END;


}
    field("QBPurchaseHeaderExt.ID Usuario";QBPurchaseHeaderExt."ID Usuario")
    {
        
                CaptionML=ENU='User ID',ESP='ID Usuario';
                Editable=false ;
}
}
} addfirst("factboxes")
{}


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

//modify("Order Date")
//{
//
//
//}
//

modify("Payment Terms Code")
{
Enabled=QB_edPagos;


}


modify("Payment Method Code")
{
Enabled=QB_edPagos;


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
addafter("Invoices")
{
    action("QB_SeeProform")
    {
        CaptionML=ESP='Proformas';
                      Image=Documents;
}
} addafter("GetRecurringPurchaseLines")
{
    action("QB_ProposeSubcontracting")
    {
        CaptionML=ENU='Propose Subcontracting',ESP='Proponer subcontrataciones';
                      Promoted=true;
                      Image=CreatePutAway;
                      PromotedCategory=Process;
}
    action("QB_ProposeValuedRelationship")
    {
        CaptionML=ENU='Propose from Valued Relationship',ESP='Proponer desde Rel.Val.';
                      ToolTipML=ESP='Proponer el consumo desde las relaciones valoradas registradas en el periodo';
                      Promoted=true;
                      Image=CalculatePlan;
                      PromotedCategory=Process;
}
    separator("Action7001110")
    {
        
}
    action("QB_CreateBrokenLines")
    {
        
                      CaptionML=ENU='Create Broken Lines',ESP='Crear lï¿½neas en descompuesto';
                      Promoted=true;
                      Image=OrderTracking;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 CurrPage.PurchLines.PAGE.Decomposed; //QB2516
                               END;


}
    separator("Action7001113")
    {
        
}
} addafter("Post")
{
    action("Proform")
    {
        CaptionML=ENU='Proform',ESP='Gen.Proforma';
                      ApplicationArea=Suite;
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=IntercompanyOrder;
                      PromotedCategory=Category6;
}
} addafter("&Print")
{
    action("QB_FichaContrato")
    {
        
                      CaptionML=ENU='Contract Card',ESP='Ficha contrato';
                      Promoted=true;
                      Image=Document;
                      PromotedCategory=Report;
                      
                                trigger OnAction()    BEGIN
                                 //Esta acciï¿½n se lanza desde la CU 7207349, funciï¿½n OnBeforeActionEvent_ContractCard, no poner cï¿½digo aquï¿½
                               END;


}
    action("QB_PrintContract")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='Imprimir Contrato';
                      ToolTipML=ENU='Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.',ESP='Permite preparar el documento para su impresiï¿½n. Se abre la ventana de solicitud de informe para el documento, donde puede especificar quï¿½ incluir en la impresiï¿½n.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Image=Print;
                      PromotedCategory=Report;
                      
                                trigger OnAction()    VAR
                                 QBPagePublisher : Codeunit 7207348;
                               BEGIN
                                 //JAV 14/03/19: - Se cambia la llamada a la funciï¿½n de impresiï¿½n de documentos para pasar tipo y nï¿½mero de documento
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
} addafter("SendCustom")
{
group("QB_Approval")
{
        
                      CaptionML=ENU='Approval',ESP='Aprobaciï¿½n';
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
                      ToolTipML=ENU='Reject the approval request.',ESP='Rechaza la solicitud de aprobaciï¿½n.';
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
                      ToolTipML=ENU='Reject the approval request.',ESP='Rechaza la solicitud de aprobaciï¿½n.';
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
                      ToolTipML=ENU='Delegate the approval to a substitute approver.',ESP='Delega la aprobaciï¿½n a un aprobador sustituto.';
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
        
                      CaptionML=ENU='Request Approval',ESP='Aprobaciï¿½n solic.';
    action("QB_Approvals")
    {
        
                      AccessByPermission=TableData 454=R;
                      CaptionML=ENU='Approvals',ESP='Aprobaciones';
                      ToolTipML=ENU='View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.',ESP='Permite ver una lista de los registros en espera de aprobaciï¿½n. Por ejemplo, puede ver quiï¿½n ha solicitado la aprobaciï¿½n del registro, cuï¿½ndo se enviï¿½ y la fecha de vencimiento de la aprobaciï¿½n.';
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
        
                      CaptionML=ENU='Send A&pproval Request',ESP='Enviar solicitud a&probaciï¿½n';
                      ToolTipML=ENU='Request approval of the document.',ESP='Permite solicitar la aprobaciï¿½n del documento.';
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
        
                      CaptionML=ENU='Cancel Approval Re&quest',ESP='Cancelar solicitud aprobaciï¿½n';
                      ToolTipML=ENU='Cancel the approval request.',ESP='Cancela la solicitud de aprobaciï¿½n.';
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
                                 COMMIT;
                                 ControlContratos.RESET;
                                 ControlContratos.SETRANGE(Proyecto, rec."QB Job No.");
                                 //Q20392
                                 ControlContratos.SETRANGE(Contrato,rec."No.");
                                 //Q20392

                                 CLEAR(pgControlContratos);
                                 pgControlContratos.SETTABLEVIEW(ControlContratos);
                                 pgControlContratos.RUNMODAL;
                               END;


}
}
}


//modify("Dimensions")
//{
//
//
//}
//

modify("Approvals")
{
Visible=False;


}


//modify("DocAttach")
//{
//
//
//}
//

modify("Release")
{
Visible=False;


}


modify("Reopen")
{
Visible=False;


}


modify("GetRecurringPurchaseLines")
{

trigger OnBeforeAction()    VAR
                                 StdVendPurchCode : Record 175;
                               BEGIN
Commit; //JAV 22/03/21: - QB 1.08.27 Para evitar error con el RunModal
END;

}


//modify("CopyDocument")
//{
//
//
//}
//

//modify("MoveNegativeLines")
//{
//
//
//}
//

modify("SendApprovalRequest")
{
Visible=False;


}


modify("CancelApprovalRequest")
{
Visible=False;


}


modify("SeeFlows")
{
Visible=False;


}


//modify("Preview")
//{
//
//
//}
//

//modify("&Print")
//{
//
//
//}
//
}

//trigger
trigger OnOpenPage()    VAR
                 SIIManagement : Codeunit 10756;
                 PermissionManager : Codeunit 9002;
                         PermissionManager1: Codeunit 51256;

               BEGIN
                 SetDocNoVisible;
                 IsSaaS := PermissionManager1.SoftwareAsAService;

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   Rec.FILTERGROUP(0);
                 END;
                 IF (rec."No." <> '') AND (rec."Buy-from Vendor No." = '') THEN
                   DocumentIsPosted := (NOT Rec.GET(rec."Document Type",rec."No."));

                 SIIManagement.CombineOperationDescription(rec."Operation Description",rec."Operation Description 2",OperationDescription);

                 ActivateFields;

                 //QB
                 verRegisterSeries := FunctionQB.QB_UserSeriesForJob;  //JAV 01/07/19: - Se aï¿½ade el campo del Nï¿½mero de serie de registro si es por proyecto
                 QB_verPaymentPhases := FunctionQB.AccessToPaymentPhases;  //Si se ven las fases de pago
                 QB_verVtos := FunctionQB.AccessToChangeBaseVtos;  //JAV 12/07/20: - Ver Calculo vtos.
                 verContrato := Funcionesdecontratos.ModuloActivo;  //JAV 15/05/19: - Asociar facturas a contratos
                 verSII := FunctionQB.AccessToSII();  //JAV 04/07/19: - Control del SII de Mirosoft, se incluye la fecha de operaciï¿½n
                 verControlcontrato := FALSE;  //JAV 14/05/19: - Control de contratos, botï¿½n de sobrepasar
                 IF UserSetup.GET(USERID) THEN
                   verControlcontrato := (verContrato AND UserSetup."Control Contracts");

                 vQuoSII := FunctionQB.AccessToQuoSII;
                 QuoSII_SetEditable;  //JAV 29/07/21: - QuoSII_1.5y Se unifican las funciones para poner editables los campos del QuoSII

                 //JAV 27/10/21: - QB 1.09.25 Activar campos Job y QPR
                 seeJob := (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets);
                 seeQPR := (FunctionQB.AccessToBudgets);
                 seeRE  := (FunctionQB.AccessToRealEstate);
               END;
trigger OnAfterGetRecord()    BEGIN
                       CalculateCurrentShippingAndPayToOption;

                       //JAV 27/10/21: - QB 1.09.25 Campos editables
                       QB_SetEditable;

                       QRE_SetEditable; //QRE_15434
                       //QRE15449-INI
                       QBPurchaseHeaderExt.Read(Rec);
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

                           QRE_SetEditable; //QRE_15434
                         END;


//trigger

var
      CopyPurchDoc : Report 492;
      MoveNegPurchLines : Report 6698;
      ReportPrint : Codeunit 228;
      UserMgt : Codeunit 5700;
      ArchiveManagement : Codeunit 5063;
      PurchCalcDiscByType : Codeunit 66;
      FormatAddress : Codeunit 365;
      ChangeExchangeRate : Page 511;
      ShipToOptions: Option "Default (Company Address)","Location","Customer Address","Custom Address";
      PayToOptions: Option "Default (Vendor)","Another Vendor","Custom Address";
      JobQueueVisible : Boolean ;
      JobQueueUsed : Boolean ;
      HasIncomingDocument : Boolean;
      DocNoVisible : Boolean;
      VendorInvoiceNoMandatory : Boolean;
      OpenApprovalEntriesExistForCurrUser : Boolean;
      OpenApprovalEntriesExist : Boolean;
      ShowWorkflowStatus : Boolean;
      CanCancelApprovalForRecord : Boolean;
      DocumentIsPosted : Boolean;
      OpenPostedPurchaseOrderQst : TextConst ENU='The order is posted as number %1 and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?',ESP='El pedido se registrï¿½ con el nï¿½mero %1 y se moviï¿½ a la ventana de facturas de compra registradas.\\ï¿½Quiere abrir la factura registrada?';
      CanRequestApprovalForFlow : Boolean;
      CanCancelApprovalForFlow : Boolean;
      OperationDescription : Text[500];
      ShowShippingOptionsWithLocation : Boolean;
      IsSaaS : Boolean;
      IsBuyFromCountyVisible : Boolean;
      IsPayToCountyVisible : Boolean;
      IsShipToCountyVisible : Boolean;
      "--------------------------------------- QB" : Integer;
      UserSetup : Record 91;
      QBPagePublisher : Codeunit 7207348;
      Funcionesdecontratos : Codeunit 7206907;
      FunctionQB : Codeunit 7207272;
      verRegisterSeries : Boolean ;
      QB_verPaymentPhases : Boolean;
      QB_edPagos : Boolean;
      QB_verVtos : Boolean;
      QB_edVtos : Boolean;
      QB_edGEDueDate : Boolean;
      verSII : Boolean;
      verControlcontrato : Boolean ;
      verContrato : Boolean ;
      QB_PurchReceiveFRISPreview : Codeunit 7206927;
      QBPaymentPhasesandDueDate : Codeunit 7207336;
      seeJob : Boolean;
      seeQPR : Boolean;
      edQPR : Boolean;
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
      BudgetEditable : Boolean;
      QREFunctions : Codeunit 7238197;
      QBPurchaseHeaderExt : Record 7238728;
      rQBApprovalCircuitHeader : Record 7206986;
      pQBApprovalCircuitList : Page 7207040;
      Job : Record 167;
      seeRE : Boolean;

    
    

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
//      InstructionMgt : Codeunit 1330;
//      ApplicationAreaMgmtFacade : Codeunit 9179;
//      LinesInstructionMgt : Codeunit 1320;
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
//      if ( InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode)  )then
//        ShowPostedConfirmationMessage;
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
//Local procedure Prepayment37OnAfterValidate();
//    begin
//      CurrPage.UPDATE;
//    end;
Local procedure SetDocNoVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
     DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order","Reminder","FinChMemo";
   begin
     DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Order,rec."No.");
   end;
Local procedure SetExtDocNoMandatoryCondition();
   var
     PurchasesPayablesSetup : Record 312;
   begin
     PurchasesPayablesSetup.GET;
     VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
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
//      OrderPurchaseHeader : Record 38;
//      PurchInvHeader : Record 122;
//      InstructionMgt : Codeunit 1330;
//    begin
//      if ( not OrderPurchaseHeader.GET(rec."Document Type",rec."No.")  )then begin
//        PurchInvHeader.SETRANGE("No.",rec."Last Posting No.");
//        if ( PurchInvHeader.FINDFIRST  )then
//          if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedPurchaseOrderQst,PurchInvHeader."No."),
//               InstructionMgt.ShowPostedConfirmationMessageCode)
//          then
//            PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
//      end;
//    end;
//Local procedure ValidateShippingOption();
//    begin
//      CASE ShipToOptions OF
//        ShipToOptions::"Default (Company Address)",
//        ShipToOptions::"Custom Address":
//          begin
//            Rec.VALIDATE("Location Code",'');
//            Rec.VALIDATE("Sell-to Customer No.",'');
//          end;
//        ShipToOptions::Location:
//          begin
//            Rec.VALIDATE("Location Code");
//            Rec.VALIDATE("Sell-to Customer No.",'');
//          end;
//        ShipToOptions::"Customer Address":
//          begin
//            Rec.VALIDATE("Sell-to Customer No.");
//            Rec.VALIDATE("Location Code",'');
//          end;
//      end;
//    end;
//Local procedure ShowReleaseNotification() : Boolean;
//    var
//      LocationsQuery : Query 5002;
//    begin
//      if ( rec."Status" <> rec."Status"::Released  )then begin
//        LocationsQuery.SETRANGE(Document_No,rec."No.");
//        LocationsQuery.SETRANGE(Require_Receive,TRUE);
//        LocationsQuery.OPEN;
//        if ( LocationsQuery.READ  )then
//          exit(TRUE);
//        LocationsQuery.SETRANGE(Document_No,rec."No.");
//        LocationsQuery.SETRANGE(Require_Receive);
//        LocationsQuery.SETRANGE(Require_Put_away,TRUE);
//        LocationsQuery.OPEN;
//        exit(LocationsQuery.READ);
//      end;
//      exit(FALSE);
//    end;
Local procedure CalculateCurrentShippingAndPayToOption();
   begin
     CASE TRUE OF
       rec."Sell-to Customer No." <> '':
         ShipToOptions := ShipToOptions::"Customer Address";
       rec."Location Code" <> '':
         ShipToOptions := ShipToOptions::Location;
       ELSE
         if ( rec.ShipToAddressEqualsCompanyShipToAddress  )then
           ShipToOptions := ShipToOptions::"Default (Company Address)"
         ELSE
           ShipToOptions := ShipToOptions::"Custom Address";
     end;

     CASE TRUE OF
       (rec."Pay-to Vendor No." = rec."Buy-from Vendor No.") and rec.BuyFromAddressEqualsPayToAddress:
         PayToOptions := PayToOptions::"Default (Vendor)";
       (rec."Pay-to Vendor No." = rec."Buy-from Vendor No.") and (not rec.BuyFromAddressEqualsPayToAddress):
         PayToOptions := PayToOptions::"Custom Address";
       rec."Pay-to Vendor No." <> rec."Buy-from Vendor No.":
         PayToOptions := PayToOptions::"Another Vendor";
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
      Rec.VALIDATE("QB Calc Due Date");
      QB_edGEDueDate := (rec."QW Cod. Withholding by GE" <> '');

      //QB JAV 12/05/20_ Aprobaciones de QuoBuilding, se llama a la funciï¿½n para activar los controles de aprobaciï¿½n
      cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
      OpenApprovalEntriesExistForCurrUser := FALSE; //No se ven las del estï¿½ndar

      //JAV 06/06/21: - QB 1.08.48 Verificar si tiene proformas asociadas y modificar automï¿½ticamente si lo tiene
      Rec.CALCFIELDS("QB No. Generated Proforms");
      if ( (rec."QB No. Generated Proforms" <> 0) and (not rec."QB Manage by Proforms")  )then begin
        rec."QB Manage by Proforms" := TRUE;
        Rec.MODIFY;
      end;
      edProforms := (rec."QB No. Generated Proforms" = 0);

      //JAV 27/10/21: - QB 1.09.25 Campos de presupuestos editables y lï¿½neas
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
    end;
LOCAL procedure QRE_SetEditable();
    var
      Job : Record 167;
    begin
      BudgetEditable := FALSE;
      if ( Job.GET(Rec."QB Job No.")  )then
        BudgetEditable := (Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion]);  //JAV 13/12/21: Aï¿½adir Real Estate
    end;
LOCAL procedure SaveExtRec();
    begin
      QBPurchaseHeaderExt.MODIFY(TRUE);
    end;

//procedure
}

