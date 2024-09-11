page 7206906 "Withholding Movements B.E."
{
  ApplicationArea=All;

    CaptionML = ENU = 'Withholding Movements', ESP = 'Movs. Retenciones B.E.';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207329;
    SourceTableView = SORTING("Entry No.")
                    WHERE("Withholding Type" = CONST("G.E"));
    DataCaptionFields = "No.";
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Type"; rec."Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Account Name"; rec."Account Name")
                {

                }
                field("Document Type"; rec."Document Type")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("External Document No."; rec."External Document No.")
                {

                }
                field("Description"; rec."Description")
                {

                    CaptionML = ENU = 'Description';
                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                }
                field("QB Approval Circuit Code"; rec."QB Approval Circuit Code")
                {

                }
                field("QB Approval Job No"; rec."QB Approval Job No")
                {

                }
                field("QB Approval Budget item"; rec."QB Approval Budget item")
                {

                }
                field("Approval Status"; rec."Approval Status")
                {

                }
                field("Withholding Code"; rec."Withholding Code")
                {

                }
                field("Withholding Type"; rec."Withholding Type")
                {

                    Visible = false;
                }
                field("Withholding treating"; rec."Withholding treating")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                    Visible = False;
                }
                field("Withholding Base"; rec."Withholding Base")
                {

                }
                field("Withholding Base (LCY)"; rec."Withholding Base (LCY)")
                {

                    Visible = False;
                }
                field("Withholding %"; rec."Withholding %")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {

                    Visible = false;
                }
                field("Due Date"; rec."Due Date")
                {

                    StyleExpr = stDueDate;
                }
                field("Job warranty end date"; rec."Job warranty end date")
                {

                    StyleExpr = stJobDate;
                }
                field("Open"; rec."Open")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Release Date"; rec."Release Date")
                {

                }
                field("Released-to Document No."; rec."Released-to Document No.")
                {

                }
                field("Released by Amount"; rec."Released by Amount")
                {

                }
                field("Applies-to ID"; rec."Applies-to ID")
                {

                }
                field("Released-to Movement No."; rec."Released-to Movement No.")
                {

                }
                field("Entry No."; rec."Entry No.")
                {

                }
                field("QB_Unpaid"; rec."QB_Unpaid")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("<Action53>")
            {

                CaptionML = ENU = 'Ent&ry', ESP = '&Movimiento';
                action("<Action3>")
                {

                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }
            group("group4")
            {
                CaptionML = ENU = '&Application', ESP = 'Procesar';
                action("<Action36>")
                {

                    CaptionML = ENU = 'Release Withholding', ESP = 'Liberar retenci�n';
                    Enabled = bLiberar;
                    Image = MakeAgreement;

                    trigger OnAction()
                    VAR
                        Text000: TextConst ESP = 'Confirme que desea liberar %1 retenciones.';
                        Text001: TextConst ENU = 'Releasing Whithholding/s... \1#######', ESP = 'Liberando retenci�n 1#######';
                        Window: Dialog;
                        total: Integer;
                        read: Integer;
                        liq: Integer;
                        inv: Integer;
                        r: Boolean;
                        QBWithholdingApr: Codeunit 7206987;
                    BEGIN
                        //JAV 13/12/22: - QB 1.12.26 Nueva aprobaci�n de retenciones
                        IF (QBWithholdingApr.IsApprovalsWorkflowActive) AND (Rec."Approval Status" <> Rec."Approval Status"::Released) THEN
                            ERROR('No puede liberar esta retenci�n hasta que no est� aprobada');

                        CurrPage.SETSELECTIONFILTER(WithholdingMovements);
                        cduWithholdingtreating.FunReleaseWitholding(WithholdingMovements);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Defer Withholding', ESP = 'Fraccionar retenci�n';
                    Enabled = bLiberar;
                    Image = Splitlines;

                    trigger OnAction()
                    BEGIN
                        CLEAR(cduWithholdingtreating);
                        cduWithholdingtreating.FunDeferWithholding(Rec);
                    END;


                }

            }
            group("group7")
            {
                CaptionML = ESP = 'Navegar';
                // ActionContainerType=ActionItems ;
                action("action4")
                {
                    CaptionML = ENU = '&Navigate', ESP = 'Nav. Original';
                    Image = Navigate;

                    trigger OnAction()
                    VAR
                        NavigatePage: Page 344;
                    BEGIN
                        NavigatePage.SetDoc(rec."Posting Date", Rec."Document No.");
                        NavigatePage.RUN;
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = '&Navigate', ESP = 'Nav. Liberado';
                    Enabled = NOT bLiberar;
                    Image = Navigate;

                    trigger OnAction()
                    VAR
                        NavigatePage: Page 344;
                        i: Integer;
                        txt: Text;
                    BEGIN
                        NavigatePage.SetDoc(rec."Release Date", rec."Released-to Doc. No");
                        NavigatePage.RUN;
                    END;


                }

            }
            group("group10")
            {
                CaptionML = ESP = 'Liquidar';
                // ActionContainerType=NewDocumentItems ;
                action("action6")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Mark Application', ESP = 'Marcar liquidaci�n';
                    Enabled = bLiberar;
                    Image = SelectLineToApply;

                    trigger OnAction()
                    BEGIN
                        CLEAR(cduWithholdingtreating);
                        cduWithholdingtreating.FunMarkApplication(Rec);
                        CurrPage.UPDATE;
                    END;


                }
                action("action7")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'Post. Marked Application', ESP = 'Registrar Liquidaci�n';
                    Enabled = bLiquidar;
                    Image = Post;

                    trigger OnAction()
                    BEGIN
                        CLEAR(cduWithholdingtreating);
                        Rec.TESTFIELD("Applies-to ID");
                        cduWithholdingtreating.FunMarkPostApplication(Rec);
                    END;


                }
                action("UnpaidWithholding")
                {

                    CaptionML = ESP = 'Impagar retenci�n';
                    Enabled = bImpagar;
                    Image = UnApply;

                    trigger OnAction()
                    VAR
                        WithholdingMovements: Record 7207329;
                        cWithholdingTreating: Codeunit 7207306;
                    BEGIN
                        //Q15417 LCG 06/10/21-INI
                        WithholdingMovements.RESET();
                        CurrPage.SETSELECTIONFILTER(WithholdingMovements);
                        IF WithholdingMovements.FINDSET() THEN
                            REPEAT
                                cWithholdingTreating.FunUnpaidWithholding(Rec);
                            UNTIL WithholdingMovements.NEXT() = 0;
                        //Q15417 LCG 06/10/21-FIN
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group15")
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
                action("Comment")
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
            group("group21")
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
                        //Para compatibilziar con el proceso anterior
                        IF (Rec."QB Approval Job No" = '') THEN BEGIN
                            Rec."QB Approval Job No" := Rec."Job No.";
                            Rec.MODIFY;
                        END;

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
            group(Category_New)
            {
                CaptionML = ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ESP = 'Proceso';

                actionref("<Action36>_Promoted"; "<Action36>")
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(UnpaidWithholding_Promoted; UnpaidWithholding)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Imprimir';
            }
            group(Category_Category4)
            {
                CaptionML = ESP = 'Navegar';

                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ESP = 'Liberar';

                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
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
                actionref(Comment_Promoted; Comment)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        QuoBuildingSetup.GET();
    END;

    trigger OnAfterGetRecord()
    BEGIN
        FunOnAfterGetRecord;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        //CODEUNIT.RUN(CODEUNIT::"Mov. retenci�n-Editar",Rec);
        //EXIT(FALSE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        FunOnAfterGetRecord;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        WithholdingMovements: Record 7207329;
        cduWithholdingtreating: Codeunit 7207306;
        bLiberar: Boolean;
        bLiquidar: Boolean;
        stDueDate: Text;
        stJobDate: Text;
        bImpagar: Boolean;
        "---------------------------- Aprobaciones inicio": Integer;
        cuApproval: Codeunit 7206987;
        QBApprovalManagement: Codeunit 7207354;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;

    LOCAL procedure FunOnAfterGetRecord();
    begin
        //JAV 07/03/19: - Se ponen no activos los botones de acci�n cuando es una linea de IRPF
        bLiberar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") and (rec.Open);
        bLiquidar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") and (rec."Released-to Movement No." = 0);
        //Q15417 LCG 06/10/21 - QRE - INI
        bImpagar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") and (rec.Open) and (not rec.QB_Unpaid);
        //Q15417 LCG 06/10/21 - QRE - FIN
        //JAV 06/05/20: - Colores si se acerca el vencimiento
        stDueDate := 'Standar';
        if (rec."Due Date" <> 0D) then
            if (CALCDATE(QuoBuildingSetup."Days Warning Withholding", rec."Due Date") <= WORKDATE) then
                stDueDate := 'Attention';

        Rec.CALCFIELDS("Job warranty end date");
        stJobDate := 'Standar';
        Rec.CALCFIELDS("Job warranty end date");
        if (rec."Job warranty end date" <> 0D) then
            if (CALCDATE(QuoBuildingSetup."Days Warning Withholding", rec."Job warranty end date") <= WORKDATE) then
                stJobDate := 'Attention';

        //Q17128 -
        /*{
        Name := '';
        if (Type = Type::Customer) then begin
          if Customer.GET(rec."No.") then
            Name := Customer.Name;
        end ELSE begin
          if Vendor.GET(rec."No.") then
            Name := Vendor.Name;
        end;
        }*/
        //Q17128 +



        //JAV 10/03/20: - Se llama a la funci�n para activar los controles de aprobaci�n
        cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);
    end;

    // begin
    /*{
      JAV 18/10/19: - Esta pantalla es solo para ver retenciones de Buena Ejecuci�n
      LCG 06/10/21: - Q15417 QRE Se crea campo QB_Unpaid y bot�n UnpaidWithholding
      JDC 01/06/22: - QB 1.10.49 (Q17128) Added fields rec."Account Name". Modified function "FunOnAfterGetRecord"
      JAV 13/12/22: - QB 1.12.26 Nueva aprobaci�n de retenciones. Se a�aden columnas, variables globales, proceso y acciones
    }*///end
}









