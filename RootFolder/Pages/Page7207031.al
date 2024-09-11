page 7207031 "QB Job Prepayment List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Job Prepayment List', ESP = 'Anticipos de Proyecto';
    SourceTable = 7206928;
    SourceTableView = SORTING("Order");
    PageType = List;
    CardPageID = "QB Job Prepayment Card";

    layout
    {
        area(content)
        {
            group("group21")
            {

                CaptionML = ESP = 'Filtros';
                field("FVer"; FVer)
                {

                    CaptionML = ESP = 'Ver';

                    ; trigger OnValidate()
                    BEGIN
                        SetFilters;
                    END;


                }
                field("FJob"; FJob)
                {

                    CaptionML = ESP = 'Proyecto';
                    TableRelation = Job;
                    Enabled = edFilters;

                    ; trigger OnValidate()
                    VAR
                        aTipo: Text;
                    BEGIN
                        SetFilters;
                    END;

                    trigger OnLookup(var Text: Text): Boolean
                    VAR
                        JobNo: Code[20];
                    BEGIN
                        //JAV 04/04/22: - QB 1.10.31 Al sacar la lista de proyectos, filtrar por los que se pueden ver por el usuario
                        JobNo := FJob;
                        IF FunctionQB.LookupUserJobs(JobNo) THEN
                            FJob := JobNo;

                        SetFilters;
                    END;


                }
                field("FType"; FType)
                {

                    CaptionML = ESP = 'Tipo';
                    Enabled = edFilters;

                    ; trigger OnValidate()
                    BEGIN
                        SetFilters;
                    END;


                }
                field("FNo"; FNo)
                {

                    CaptionML = ESP = 'No.';

                    ; trigger OnValidate()
                    BEGIN
                        SetFilters;
                    END;


                }

            }
            repeater("General")
            {

                field("Entry No."; rec."Entry No.")
                {

                    Visible = false;
                    StyleExpr = StyleLine;
                }
                field("Apply to Entry No."; rec."Apply to Entry No.")
                {

                    Visible = false;
                }
                field("Job No."; rec."Job No.")
                {

                    StyleExpr = StyleLine;
                }
                field("Job Descripcion"; rec."Job Descripcion")
                {

                }
                field("Account Type"; rec."Account Type")
                {

                    StyleExpr = StyleLine;
                }
                field("Account No."; rec."Account No.")
                {

                    StyleExpr = StyleLine;
                }
                field("Account Description"; rec."Account Description")
                {

                }
                field("Entry Type"; rec."Entry Type")
                {

                    StyleExpr = StyleLine;
                }
                field("Document No."; rec."Document No.")
                {

                    StyleExpr = StyleLine;
                }
                field("Approval Status"; rec."Approval Status")
                {

                }
                field("Description"; rec."Description")
                {

                    StyleExpr = StyleLine;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    StyleExpr = StyleLine;
                }
                field("Document Date"; rec."Document Date")
                {

                    StyleExpr = StyleLine;
                }
                field("External Document No."; rec."External Document No.")
                {

                    StyleExpr = StyleLine;
                }
                field("sumAmount"; sumAmount)
                {

                    CaptionML = ESP = 'Importe';
                    StyleExpr = StyleLine;
                }
                field("sumAppliedAmount"; sumAppliedAmount)
                {

                    CaptionML = ESP = 'Importe Aplicado';
                    BlankZero = true;
                    StyleExpr = StyleLine;
                }
                field("sumPendingAmount"; sumPendingAmount)
                {

                    CaptionML = ESP = 'Importe Pendiente';
                    BlankZero = true;
                    StyleExpr = StyleLine;
                }
                field("sumNoApAmount"; sumNoApAmount)
                {

                    CaptionML = ESP = 'Importe No Aprobado';
                    BlankZero = true;
                    StyleExpr = StyleLine;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    StyleExpr = StyleLine;
                }
                field("sumAmountLCY"; sumAmountLCY)
                {

                    CaptionML = ESP = 'Importe (DL)';
                    Visible = false;
                    StyleExpr = StyleLine;
                }
                field("sumNoApAmountLCY"; sumNoApAmountLCY)
                {

                    CaptionML = ESP = 'Importe No Aprobado (DL)';
                    BlankZero = true;
                    Visible = false;
                    StyleExpr = StyleLine;
                }

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

            action("Regenerate")
            {

                CaptionML = ESP = 'Regenerar Totales';
                Image = Recalculate;

                trigger OnAction()
                BEGIN
                    QBPrepaymentManagement.RegenerateTotals(Rec);
                END;


            }
            action("Post")
            {

                CaptionML = ESP = 'Registrar';
                Enabled = enPost;
                Image = Post;

                trigger OnAction()
                BEGIN
                    QBPrepaymentManagement.Generate(Rec);
                END;


            }
            action("See")
            {

                CaptionML = ESP = 'Ver Documento';
                Enabled = enSee;
                Image = Document;

                trigger OnAction()
                BEGIN
                    QBPrepaymentManagement.SeeDocument(Rec);
                END;


            }
            action("Navigate")
            {

                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected posted purchase document.', ESP = 'Busca todos los movimientos y los documentos que existen seg�n el n�mero de documento y la fecha de registro del documento de compra registrado seleccionado.';
                Enabled = enNavigate;
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    QBPrepaymentManagement.Navigate(Rec);
                END;


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
                        Rec.CheckData;
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
                        Rec.CheckData;
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
            group("Process")
            {

                CaptionML = ENU = 'Process', ESP = 'Procesos';
                action("Cancel")
                {

                    CaptionML = ENU = 'Cancel', ESP = 'Cancelar Anticipo';
                    Enabled = enCancel;
                    Image = Cancel;


                    trigger OnAction()
                    BEGIN
                        //JAV 09/06/22: QB 1.10.49 Cancelar anticipos
                        QBPrepaymentManagement.Cancel(Rec);
                    END;


                }

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
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Registros';

                actionref(Post_Promoted; Post)
                {
                }
                actionref(See_Promoted; See)
                {
                }
                actionref(Navigate_Promoted; Navigate)
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
                actionref(QB_Release_Promoted; QB_Release)
                {
                }
                actionref(QB_Reopen_Promoted; QB_Reopen)
                {
                }
            }
            group(Category_Category9)
            {
                CaptionML = ENU = 'Post', ESP = 'Registrar';
            }
            group(Category_Category10)
            {
                CaptionML = ENU = 'Release', ESP = 'Lanzar';
            }
        }
    }


    trigger OnOpenPage()
    BEGIN
        FJob := Rec.GETFILTER("Job No.");
        edFilters := (FJob = '');

        CASE Rec.GETFILTER(rec."Account Type") OF
            FORMAT(Rec."Account Type"::Customer):
                BEGIN
                    FType := Rec."Account Type"::Customer;
                    QBPrepaymentManagement.AccessToCustomerPrepaymentError;
                    seeCustomer := TRUE;
                    seeVendor := FALSE;
                END;
            FORMAT(Rec."Account Type"::Vendor):
                BEGIN
                    FType := Rec."Account Type"::Vendor;
                    QBPrepaymentManagement.AccessToVendorPrepaymentError;
                    seeCustomer := FALSE;
                    seeVendor := TRUE;
                END;
            ELSE BEGIN
                FType := FType::Todos;
                seeCustomer := QBPrepaymentManagement.AccessToCustomerPrepayment;
                seeVendor := QBPrepaymentManagement.AccessToVendorPrepayment;
                IF (NOT seeCustomer) AND (NOT seeVendor) THEN
                    QBPrepaymentManagement.AccessToCustomerPrepaymentError;  //Para que de el error
            END;
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetControls;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetControls;
    END;



    var
        FunctionQB: Codeunit 7207272;
        QBPrepaymentManagement: Codeunit 7207300;
        sumAmount: Decimal;
        sumAmountLCY: Decimal;
        sumAppliedAmount: Decimal;
        sumAppliedAmountLCY: Decimal;
        sumPendingAmount: Decimal;
        sumPendingAmountLCY: Decimal;
        sumNoApAmount: Decimal;
        sumNoApAmountLCY: Decimal;
        StyleLine: Text;
        seeCustomer: Boolean;
        seeVendor: Boolean;
        enPost: Boolean;
        enSee: Boolean;
        enNavigate: Boolean;
        enCancel: Boolean;
        edFilters: Boolean;
        FJob: Text;
        FType: Option "Proveedor","Cliente","Todos";
        FNo: Code[20];
        FVer: Option "Todos","Sin Registrar","Registrados";
        Job: Record 167;
        Customer: Record 18;
        Vendor: Record 23;
        QBPrepayment: Record 7206928;
        tmpQBPrepayment: Record 7206928 TEMPORARY;
        QBPrepaymentCard: Page 7207032;
        "---------------------------- Aprobaciones inicio": Integer;
        cuApproval: Codeunit 7206931;
        QBApprovalManagement: Codeunit 7207354;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;

    procedure SetType(pType: Option);
    begin
        FType := pType;
    end;

    LOCAL procedure SetControls();
    begin
        //JAV 31/03/22: - QB 1.10.29 Aprobaciones de QuoBuilding, se llama a la funci�n para activar los controles de aprobaci�n
        if (Rec."Entry Type" IN [Rec."Entry Type"::Invoice, Rec."Entry Type"::Bill]) then begin
            cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
            //JAV 11/04/22: - QB 1.10.35 No se puede volver a abrir mientras tenga un documento generado
            if (rec."Document No." <> '') then
                CanReopen := FALSE;
        end ELSE begin
            ApprovalsActive := FALSE;
            OpenApprovalsPage := FALSE;
            CanRequestApproval := FALSE;
            CanCancelApproval := FALSE;
            CanRelease := FALSE;
            CanReopen := FALSE;
        end;

        enPost := (rec."Document No." = '') and (rec."Approval Status" = rec."Approval Status"::Released);
        enSee := (rec.Amount = 0) and (rec."Entry Type" = rec."Entry Type"::Invoice) and (rec."Document No." <> '');
        enNavigate := (rec.Amount <> 0);

        Rec.CALCFIELDS("Sum Account Amount");
        enCancel := (rec."Account No." <> '') and (rec."Sum Account Amount" <> 0);  //JAV 09/06/22: QB 1.10.49 Cancelar anticipos

        StyleLine := '';
        if (rec."Entry Type" IN [rec."Entry Type"::Invoice, rec."Entry Type"::Bill]) then begin
            if (rec.Amount <> 0) then
                StyleLine := 'Favorable'
            ELSE begin
                if (rec."Approval Status" = rec."Approval Status"::Open) then
                    StyleLine := 'StandardAccent'
                ELSE
                    StyleLine := 'StrongAccent';
            end;
        end;
        if (rec."Entry Type" IN [rec."Entry Type"::Application, rec."Entry Type"::Cancelation]) then
            StyleLine := 'Unfavorable';
        if (rec."Entry Type" IN [rec."Entry Type"::TAccount, rec."Entry Type"::TJob]) then
            StyleLine := 'Strong';

        CASE rec."Entry Type" OF
            rec."Entry Type"::TAccount:
                begin
                    Rec.CALCFIELDS("Sum Account Amount", "Sum Account Amount (LCY)", "Sum Account not App. Amt.", "Sum Account not App.Amt. (LCY)");
                    sumAmount := rec."Sum Account Amount";
                    sumAmountLCY := rec."Sum Account Amount (LCY)";
                    sumNoApAmount := rec."Sum Account not App. Amt.";
                    sumNoApAmountLCY := rec."Sum Account not App.Amt. (LCY)";
                end;
            rec."Entry Type"::TJob:
                begin
                    Rec.CALCFIELDS("Sum Job Amount", "Sum Job Amount (LCY)", "Sum Job not App. Amount", "Sum Job not App. Amount (LCY)");
                    sumAmount := rec."Sum Job Amount";
                    sumAmountLCY := rec."Sum Job Amount (LCY)";
                    sumNoApAmount := rec."Sum Job not App. Amount";
                    sumNoApAmountLCY := rec."Sum Job not App. Amount (LCY)";
                end;
            ELSE begin
                sumAmount := rec.Amount;
                sumAmountLCY := rec."Amount (LCY)";
                sumNoApAmount := rec."not Approved Amount";
                sumNoApAmountLCY := rec."not Approved Amount (LCY)";
            end;
        end;

        CASE rec."Entry Type" OF
            rec."Entry Type"::Invoice, rec."Entry Type"::Bill:
                begin
                    Rec.CALCFIELDS("Applied Amount");
                    sumAppliedAmount := -rec."Applied Amount";
                    sumAppliedAmountLCY := 0;
                    sumPendingAmount := sumAmount - sumAppliedAmount;
                    sumPendingAmountLCY := 0;
                end;
            ELSE begin
                sumAppliedAmount := 0;
                sumAppliedAmountLCY := 0;
                sumPendingAmount := 0;
                sumPendingAmountLCY := 0;
            end;
        end;

        //JAV 09/11/22: - QB 1.12.16 Poner la descripci�n del proyecto y de la cuenta en la pantalla
        if (Rec."Job Descripcion" = '') then begin
            if (Job.GET(rec."Job No.")) then begin
                Rec."Job Descripcion" := Job.Description;
                Rec.MODIFY(FALSE);
            end;
        end;

        if (Rec."Account Description" = '') then begin
            CASE rec."Account Type" OF
                Rec."Account Type"::Customer:
                    if (Customer.GET(rec."Account No.")) then begin
                        Rec."Account Description" := Customer.Name;
                        Rec.MODIFY(FALSE);
                    end;
                Rec."Account Type"::Vendor:
                    if (Vendor.GET(rec."Account No.")) then begin
                        Rec."Account Description" := Vendor.Name;
                        Rec.MODIFY(FALSE);
                    end;
            end;
        end;
    end;

    procedure NewJobCustomer(JobNo: Code[20]);
    begin
        //-------------------------------------------------------------------------------------------------------------------
        // Crear un nuevo anticipo de cliente de un proyecto
        //-------------------------------------------------------------------------------------------------------------------
        QBPrepaymentManagement.AccessToCustomerPrepayment;

        // tmpQBPrepayment.DELETEALL;
        // tmpQBPrepayment.INIT;
        // tmpQBPrepayment."Account Type" := tmpQBPrepayment."Account Type"::Customer;
        // tmpQBPrepayment.VALIDATE("Posting Date", WORKDATE);
        // tmpQBPrepayment.VALIDATE("Job No.", JobNo);
        // tmpQBPrepayment.INSERT;
        //
        // CLEAR(QBPrepaymentCard);
        // QBPrepaymentCard.SetData(tmpQBPrepayment);  //JobNo, QBP."Account Type"::Customer); //Q12879
        // QBPrepaymentCard.LOOKUPMODE(TRUE);
        // COMMIT; // Por el runmodal
        // if QBPrepaymentCard.RUNMODAL <> ACTION::LookupOK then
        //  exit;
        //
        // //Obtener los datos y guardarse el registro
        // QBPrepaymentCard.GetData(QBPrepayment);
        // Rec := QBPrepayment;
        // Rec.INSERT(TRUE);

        Rec.INIT;
        Rec."Account Type" := tmpQBPrepayment."Account Type"::Customer;
        Rec.VALIDATE("Posting Date", WORKDATE);
        Rec.VALIDATE("Job No.", JobNo);
        Rec.INSERT(TRUE);
        COMMIT; // Por el runmodal

        CLEAR(QBPrepaymentCard);
        QBPrepaymentCard.SetData(JobNo);
        QBPrepaymentCard.SETRECORD(Rec);
        QBPrepaymentCard.RUNMODAL;

        //Obtener los datos y guardarse el registro
        QBPrepaymentCard.GetData(QBPrepayment);
        Rec := QBPrepayment;
        Rec.INSERT(TRUE);

        /*{---
        //Crear una factura con los datos
        CASE tmpQBPrepayment."Generate Document" OF
          tmpQBPrepayment."Generate Document"::Invoice : CreateSalesInvoice(tmpQBPrepayment."Job No.", tmpQBPrepayment."Account No.", tmpQBPrepayment."Posting Date",
                                                                            tmpQBPrepayment."Description Line 1", tmpQBPrepayment."Description Line 2",
                                                                            tmpQBPrepayment."Pending Amount", tmpQBPrepayment."Currency Code");
          tmpQBPrepayment."Generate Document"::Bill    : CreateQBPrepmtBillEntry(tmpQBPrepayment."Job No.", QBP."Account Type"::Customer, tmpQBPrepayment."Account No.", tmpQBPrepayment."Posting Date",
                                                                                 tmpQBPrepayment."Description Line 1", tmpQBPrepayment."Description Line 2",
                                                                                 tmpQBPrepayment."Pending Amount", tmpQBPrepayment."Currency Code");
        end;
        ---}*/
    end;

    procedure NewJobVendor(JobNo: Code[20]);
    begin
        //-------------------------------------------------------------------------------------------------------------------
        // Crear un nuevo anticipo de proveedor de un proyecto
        //-------------------------------------------------------------------------------------------------------------------

        // tmpQBPrepayment.DELETEALL;
        // tmpQBPrepayment.INIT;
        // tmpQBPrepayment."Account Type" := tmpQBPrepayment."Account Type"::Vendor;
        // tmpQBPrepayment.VALIDATE("Posting Date", WORKDATE);
        // tmpQBPrepayment.VALIDATE("Job No.", JobNo);
        // tmpQBPrepayment.INSERT;
        //
        // CLEAR(QBPrepaymentCard);
        // QBPrepaymentCard.SetData(tmpQBPrepayment);  //JobNo, QBP."Account Type"::Customer); //Q12879
        // QBPrepaymentCard.LOOKUPMODE(TRUE);
        // COMMIT; // Por el runmodal
        // if QBPrepaymentCard.RUNMODAL = ACTION::LookupOK then begin
        //  //Obtener los datos y guardarse el registro
        //  QBPrepaymentCard.GetData(QBPrepayment);
        //  Rec := QBPrepayment;
        //  Rec.INSERT(TRUE);
        // end;

        Rec.INIT;
        Rec."Account Type" := tmpQBPrepayment."Account Type"::Customer;
        Rec.VALIDATE("Posting Date", WORKDATE);
        Rec.VALIDATE("Job No.", JobNo);
        Rec.INSERT(TRUE);
        COMMIT; // Por el runmodal

        CLEAR(QBPrepaymentCard);
        QBPrepaymentCard.SetData(JobNo);
        QBPrepaymentCard.SETRECORD(Rec);
        QBPrepaymentCard.RUNMODAL;

        /*{---
        CASE DocumentType OF
          DocumentType::Invoice : CreatePurchaseInvoice(JobNo, VendorNo,DocDate,Description1,Description2,PrepmtAmount,Curr);
          DocumentType::Bill    : CreateQBPrepmtBillEntry(JobNo, QBP."Account Type"::Vendor, VendorNo, DocDate, Description1, Description2, PrepmtAmount, Curr);  //Q13154
        end;
        //Q12879 +
        ---}*/
    end;

    LOCAL procedure SetFilters();
    begin
        Rec.RESET;
        Rec.SETCURRENTKEY("Job No.", "Account Type", TJ, "Account No.", TC);
        CASE FVer OF
            FVer::"Sin Registrar":
                Rec.SETRANGE("See in Pending", TRUE);
            FVer::Registrados:
                Rec.SETRANGE("See in Posting", TRUE);
        end;

        if (FJob <> '') then
            Rec.SETRANGE("Job No.", FJob);

        CASE FType OF
            FType::Cliente:
                Rec.SETRANGE("Account Type", rec."Account Type"::Customer);
            FType::Proveedor:
                Rec.SETRANGE("Account Type", rec."Account Type"::Vendor);
        end;

        if (FNo <> '') then
            Rec.SETRANGE("Account No.", FNo);

        CurrPage.UPDATE;
    end;

    // begin
    /*{
      JAV 09/06/22: - QB 1.10.49 Cancelar anticipos
      JAV 08/11/22: - QB 1.12.16 Peque�as mejoras
    }*///end
}








