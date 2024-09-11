page 7207391 "Expense Notes"
{
    CaptionML = ENU = 'Expense Notes', ESP = 'Notas de gasto';
    SourceTable = 7207320;
    SourceTableView = SORTING("No.");
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Employee"; rec."Employee")
                {

                }
                field("Expense Description"; rec."Expense Description")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                }
                field("Expense Note Date"; rec."Expense Note Date")
                {

                }
                field("PIT Withholding Group"; rec."PIT Withholding Group")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {

                }
                field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
                {

                }
                field("Remaining Advance Amount DL"; rec."Remaining Advance Amount DL")
                {

                }
                field("Bal. Account Type"; rec."Bal. Account Type")
                {

                }
                field("Bal. Account Code"; rec."Bal. Account Code")
                {

                }
                field("Approval Status"; rec."Approval Status")
                {

                }
                group("group41")
                {

                    CaptionML = ESP = 'Aprobaci�n';
                    Visible = ApprovalsActive;
                    field("QB Approval Circuit Code"; rec."QB Approval Circuit Code")
                    {

                        ToolTipML = ESP = 'Que circuito de aprobaci�n que se utilizar� para este documento';
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
            part("part1"; 7207393)
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("<Control7001117>")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part(IncomingDocAttachFactBox; 193)
            {
                ApplicationArea = Basic, Suite;
                Visible = not IsOfficeAddin;
                ShowFilter = false;
            }

            systempart(Links; Links)
            {
                Visible = true;
            }

            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Document', ESP = '&Notas';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;

                    trigger OnAction()
                    VAR
                        JobsSetup: Record 312;
                    BEGIN
                        JobsSetup.GET;
                        PAGE.RUNMODAL(PAGE::"Statistics Expense Notes", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 27;
                    RunPageLink = "No." = FIELD("Employee");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207358;
                    RunPageLink = "Document Type" = CONST("Expense Notes"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group8")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action5")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    Image = Post;

                    trigger OnAction()
                    BEGIN
                        //IF WorkflowEventsQB.PrePostApprovalCheckExpenseNotes(Rec) THEN
                        CODEUNIT.RUN(CODEUNIT::"Post. Expense Note (Yes/No)", Rec);
                    END;


                }

            }
            group("QB_Approval")
            {

                CaptionML = ENU = 'Approval', ESP = 'Aprobaci�n';
                action("QB_Approve")
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
                action("QB_Reject")
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
                action("QB_Delegate")
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
                action("QB_Comment")
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
            group("QB_RequestApproval")
            {

                CaptionML = ENU = 'Request Approval', ESP = 'Aprobaci�n solic.';
                action("QB_Approvals")
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
                action("QB_SendApprovalRequest")
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
                action("QB_CancelApprovalRequest")
                {

                    CaptionML = ENU = 'Cancel Approval Re&quest', ESP = 'Cancelar solicitud aprobaci�n';
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
                action("QB_Release")
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
                action("QB_Reopen")
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
        area(Reporting)
        {

            action("action16")
            {
                CaptionML = ENU = 'Print', ESP = '&Imprimir';
                Image = Print;


                trigger OnAction()
                VAR
                    ExpenseNotesHeader: Record 7207320;
                BEGIN
                    ExpenseNotesHeader.RESET;
                    ExpenseNotesHeader.SETRANGE("No.", rec."No.");
                    // REPORT.RUNMODAL(REPORT::"Expense Notes", TRUE, FALSE, ExpenseNotesHeader);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Proceso';

                actionref(action5_Promoted; action5)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action16_Promoted; action16)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Approve', ESP = 'Aprobar';

                actionref(QB_Approve_Promoted; QB_Approve)
                {
                }
                actionref(QB_WithHolding_Promoted; QB_WithHolding)
                {
                }
                actionref(QB_Reject_Promoted; QB_Reject)
                {
                }
                actionref(QB_Delegate_Promoted; QB_Delegate)
                {
                }
                actionref(QB_Comment_Promoted; QB_Comment)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Invoice', ESP = 'Factura';
            }
            group(Category_Category6)
            {
                CaptionML = ENU = 'Posting', ESP = 'Registro';
            }
            group(Category_Category7)
            {
                CaptionML = ENU = 'View', ESP = 'Ver';
            }
            group(Category_Category8)
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Solicitar aprobaci�n';

                actionref(QB_Approvals_Promoted; QB_Approvals)
                {
                }
                actionref(QB_SendApprovalRequest_Promoted; QB_SendApprovalRequest)
                {
                }
                actionref(QB_CancelApprovalRequest_Promoted; QB_CancelApprovalRequest)
                {
                }
            }
            group(Category_Category9)
            {
                CaptionML = ENU = 'Incoming Document', ESP = 'Documento entrante';
            }
            group(Category_Category10)
            {
                CaptionML = ENU = 'Release', ESP = 'Lanzar';

                actionref(QB_Release_Promoted; QB_Release)
                {
                }
                actionref(QB_Reopen_Promoted; QB_Reopen)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);

        //JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
        IsOfficeAddin := OfficeMgt.IsAvailable;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //QB JAV 12/05/20_ Aprobaciones de QuoBuilding, se llama a la funci�n para activar los controles de aprobaci�n
        cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Responsibility Center" := FunctionQB.GetUserJobResponsibilityCenter;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    END;



    var
        FunctionQB: Codeunit 7207272;
        "------------------------------ FactBox Documentos": Integer;
        IsOfficeAddin: Boolean;
        OfficeMgt: Codeunit 1630;
        "---------------------------- Aprobaciones": Integer;
        cuApproval: Codeunit 7206919;
        QBApprovalManagement: Codeunit 7207354;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;
        CanRequestDueApproval: Boolean;/*

    begin
    {
      JAV 29/06/22: - QB 1.10.57 Se a�ade el FactBox de documentos
    }
    end.*/


}







