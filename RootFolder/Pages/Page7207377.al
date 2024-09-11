page 7207377 "Transfers Between Jobs Card"
{
    CaptionML = ENU = 'Proyects Transfers', ESP = 'Traspaso entre proyectos';
    SourceTable = 7207286;
    PopulateAllFields = true;
    SourceTableView = SORTING("No.");
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Posting Date"; rec."Posting Date")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Balance"; rec."Balance")
                {

                }
                field("Comment"; rec."Comment")
                {

                }
                field("Posting No. Series"; rec."Posting No. Series")
                {

                    Visible = false;
                }
                field("User ID"; rec."User ID")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Approval Status"; rec."Approval Status")
                {

                }
                group("group29")
                {

                    CaptionML = ESP = 'Aprobaci�n';
                    Visible = ApprovalsActive;
                    field("QB Approval Job No"; rec."QB Approval Job No")
                    {

                    }
                    field("QB Approval Budget item"; rec."QB Approval Budget item")
                    {

                    }
                    field("QB Approval Department"; rec."QB Approval Department")
                    {

                    }
                    field("QB Approval Circuit Code"; rec."QB Approval Circuit Code")
                    {

                        ToolTipML = ESP = 'Que circuito de aprobaci�n que se utilizar� para este documento';
                        Enabled = CanRequestApproval;
                    }
                    field("QBApprovalManagement.GetLastStatus(Rec.RECORDID, Approval Status)"; QBApprovalManagement.GetLastStatus(Rec.RECORDID, rec."Approval Status"))
                    {

                        CaptionML = ESP = 'Situaci�n';
                    }
                    field("QBApprovalManagement.GetLastDateTime(Rec.RECORDID)"; QBApprovalManagement.GetLastDateTime(Rec.RECORDID))
                    {

                        CaptionML = ESP = 'Ult.Acci�n';
                    }
                    field("QBApprovalManagement.GetLastComment(Rec.RECORDID)"; QBApprovalManagement.GetLastComment(Rec.RECORDID))
                    {

                        CaptionML = ESP = 'Ult.Comentario';
                    }

                }

            }
            part("LinDoc"; 7207378)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = 'P&osting', ESP = 'Documento';
                action("action1")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207297;
                    Image = Post;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'Comentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Sheet"), "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }
            group("group5")
            {
                CaptionML = ENU = 'Approval', ESP = 'Aprobaci�n';
                action("Approve")
                {

                    CaptionML = ENU = 'Approve', ESP = 'Aprobar';
                    ToolTipML = ENU = 'Approve the requested changes.', ESP = 'Aprueba los cambios solicitados.';
                    ApplicationArea = All;
                    Visible = OpenApprovalsPage;
                    Image = Approve;

                    trigger OnAction()
                    BEGIN
                        ApprovalsMgmt.ApproveRecordApprovalRequest(rec.RECORDID);
                    END;


                }
                action("QB_WithHolding")
                {

                    CaptionML = ENU = 'Reject', ESP = 'Retener';
                    ToolTipML = ENU = 'Reject the approval request.', ESP = 'Rechaza la solicitud de aprobaci�n.';
                    ApplicationArea = All;
                    Visible = OpenApprovalsPage;
                    Image = Lock;

                    trigger OnAction()
                    BEGIN
                        cuApproval.WitHoldingApproval(Rec);
                    END;


                }
                action("Reject")
                {

                    CaptionML = ENU = 'Reject', ESP = 'Rechazar';
                    ToolTipML = ENU = 'Reject the approval request.', ESP = 'Rechaza la solicitud de aprobaci�n.';
                    ApplicationArea = All;
                    Visible = OpenApprovalsPage;
                    Image = Reject;

                    trigger OnAction()
                    BEGIN
                        ApprovalsMgmt.RejectRecordApprovalRequest(rec.RECORDID);
                    END;


                }
                action("Delegate")
                {

                    CaptionML = ENU = 'Delegate', ESP = 'Delegar';
                    ToolTipML = ENU = 'Delegate the approval to a substitute approver.', ESP = 'Delega la aprobaci�n a un aprobador sustituto.';
                    ApplicationArea = All;
                    Visible = OpenApprovalsPage;
                    Image = Delegate;

                    trigger OnAction()
                    BEGIN
                        ApprovalsMgmt.DelegateRecordApprovalRequest(rec.RECORDID);
                    END;


                }
                action("Comment_")
                {

                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    ToolTipML = ENU = 'View or add comments for the record.', ESP = 'Permite ver o agregar comentarios para el registro.';
                    ApplicationArea = All;
                    Visible = OpenApprovalsPage;
                    Image = ViewComments;

                    trigger OnAction()
                    VAR
                        ApprovalsMgmt: Codeunit 1535;
                    BEGIN
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    END;


                }

            }
            group("group11")
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Aprobaci�n solic.';
                action("Approvals")
                {

                    AccessByPermission = TableData 454 = R;
                    CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                    ToolTipML = ENU = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.', ESP = 'Permite ver una lista de los registros en espera de aprobaci�n. Por ejemplo, puede ver qui�n ha solicitado la aprobaci�n del registro, cu�ndo se envi� y la fecha de vencimiento de la aprobaci�n.';
                    ApplicationArea = Suite;
                    Visible = ApprovalsActive;
                    Image = Approvals;

                    trigger OnAction()
                    VAR
                        WorkflowsEntriesBuffer: Record 832;
                        QBApprovalSubscriber: Codeunit 7207354;
                    BEGIN
                        cuApproval.ViewApprovals(Rec);
                    END;


                }
                action("SendApprovalRequest")
                {

                    CaptionML = ENU = 'Send A&pproval Request', ESP = 'Enviar solicitud a&probaci�n';
                    ToolTipML = ENU = 'Request approval of the document.', ESP = 'Permite solicitar la aprobaci�n del documento.';
                    ApplicationArea = Basic, Suite;
                    Visible = ApprovalsActive;
                    Enabled = CanRequestApproval;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    BEGIN
                        cuApproval.SendApproval(Rec);
                    END;


                }
                action("CancelApprovalRequest")
                {

                    CaptionML = ENU = 'Cancel Approval Re&quest', ESP = '&Cancelar solicitud aprobaci�n';
                    ToolTipML = ENU = 'Cancel the approval request.', ESP = 'Cancela la solicitud de aprobaci�n.';
                    ApplicationArea = Basic, Suite;
                    Visible = ApprovalsActive;
                    Enabled = CanCancelApproval;
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    VAR
                        WorkflowWebhookMgt: Codeunit 1543;
                    BEGIN
                        cuApproval.CancelApproval(Rec);
                    END;


                }
                action("Release")
                {

                    CaptionML = ENU = 'Release', ESP = 'Lanzar';
                    Enabled = CanRelease;
                    Image = ReleaseDoc;

                    trigger OnAction()
                    VAR
                        ReleaseComparativeQuote: Codeunit 7207332;
                    BEGIN
                        cuApproval.PerformManualRelease(Rec);
                    END;


                }
                action("Reopen")
                {

                    CaptionML = ENU = 'Open', ESP = 'Volver a abrir';
                    Enabled = CanReopen;
                    Image = ReOpen;


                    trigger OnAction()
                    VAR
                        ReleaseComparativeQuote: Codeunit 7207332;
                    BEGIN
                        cuApproval.PerformManualReopen(Rec);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
            group(Category_Category4)
            {
                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
            }
            group(Category_Category5)
            {
                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
            }
            group(Category_Category6)
            {
                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(QB_WithHolding_Promoted; QB_WithHolding)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
                actionref(Comment_Promoted; Comment_)
                {
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //JAV 10/03/20: - Se llama a la funci�n para activar los controles de aprobaci�n
        cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
    END;



    var
        FunctionQB: Codeunit 7207272;
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
        "---------------------------- Aprobaciones": Integer;
        cuApproval: Codeunit 7206921;
        QBApprovalManagement: Codeunit 7207354;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;/*

    begin
    {
      JAV 28/10/19: - Se cambia el name y caption para que sea mas significativo del contenido
    }
    end.*/


}







