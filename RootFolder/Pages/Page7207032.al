page 7207032 "QB Job Prepayment Card"
{
    CaptionML = ENU = 'QB Prepayment Edit', ESP = 'Preparar Anticipo';
    SourceTable = 7206928;
    DataCaptionExpression = PageCaption_;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group19")
            {

                CaptionML = ESP = 'Datos generales';
                group("Job")
                {

                    CaptionML = ENU = 'Job', ESP = 'Proyecto';
                    field("Job No."; rec."Job No.")
                    {

                        Editable = edJob;
                    }
                    field("Job Descripcion"; rec."Job Descripcion")
                    {

                        Editable = false;
                    }
                    field("Budget Item"; rec."Budget Item")
                    {

                        Enabled = edCard;
                    }

                }
                group("Account")
                {

                    CaptionML = ENU = 'Account', ESP = 'Cuenta';
                    field("Account Type"; rec."Account Type")
                    {

                        Enabled = enType;

                        ; trigger OnValidate()
                        BEGIN
                            SetControls;
                        END;


                    }
                    field("Account No."; rec."Account No.")
                    {

                        Enabled = edCard;
                    }
                    field("Account Description"; rec."Account Description")
                    {

                        Enabled = false;
                    }

                }
                group("group28")
                {

                    CaptionML = ENU = 'Data', ESP = 'Aprobaci�n';
                    field("Approval Status"; rec."Approval Status")
                    {

                    }
                    field("QB Approval Circuit Code"; rec."QB Approval Circuit Code")
                    {

                        Enabled = edCard;
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
                group("Data")
                {

                    CaptionML = ENU = 'Data', ESP = 'Datos del Anticipo';
                    Visible = seeData;
                    field("Prepayment Type"; rec."Prepayment Type")
                    {

                        Enabled = edCard;

                        ; trigger OnValidate()
                        BEGIN
                            SetControls;
                            CurrPage.UPDATE;
                        END;


                    }
                    field("For Document No."; rec."For Document No.")
                    {

                        Enabled = edDocNo;
                    }
                    field("Generate Document"; rec."Generate Document")
                    {

                        Enabled = edGenerateDoc;

                        ; trigger OnValidate()
                        BEGIN
                            SetControls;
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Posting Date"; rec."Posting Date")
                    {

                        Enabled = edCard;
                    }
                    field("Document Date"; rec."Document Date")
                    {

                        Enabled = edDate;
                    }
                    field("External Document No."; rec."External Document No.")
                    {

                        ToolTipML = ESP = 'Para proveedores se debe informar del N� de su factura. Para Clientes es opcional y representa un n�mero de referencia.';
                        Enabled = edCard;
                    }
                    field("Payment Method Code"; rec."Payment Method Code")
                    {

                        ToolTipML = ESP = 'Indica la forma de pago con la que se van a generar el documento de anticipo';
                        Enabled = edCard;
                    }
                    field("Payment Terms Code"; rec."Payment Terms Code")
                    {

                        ToolTipML = ESP = 'Indica que T�rminos de pago se usar� al generar el documento de anticipo';
                        Enabled = edCard;
                    }
                    field("Due Date"; rec."Due Date")
                    {

                        ToolTipML = ESP = 'Indica la fecha de vencimiento que se aplciar� al documento de anticipo que se genere';
                        Enabled = edCard;
                    }
                    field("Currency Code"; rec."Currency Code")
                    {

                        TableRelation = Currency;
                        Enabled = edCard;
                    }
                    field("Base Amount"; rec."Base Amount")
                    {

                        Enabled = edCard;
                    }
                    field("Percentage"; rec."Percentage")
                    {

                        DecimalPlaces = 2 : 4;
                        Enabled = edCard;
                    }
                    field("Not Approved Amount"; rec."Not Approved Amount")
                    {

                        CaptionML = ENU = 'Prepayment Amount', ESP = 'Importe Anticipo';
                        ToolTipML = ESP = 'Indica el importe del anticipo que se va a generar. Este estar� como pendiente hasta que se registre el documento correspondiente, momento en que pasar� a definitivo';
                        Enabled = edCard;
                    }
                    field("Description Line 1"; rec."Description Line 1")
                    {

                        Enabled = edCard;
                    }
                    field("Description Line 2"; rec."Description Line 2")
                    {

                        Enabled = enDescription;
                    }
                    field("Document No."; rec."Document No.")
                    {

                    }

                }
                group("Cancel")
                {

                    CaptionML = ENU = 'Data', ESP = 'Cancelaci�n del Anticipo';
                    Visible = seeCancel;
                    Editable = false;
                    field("Entry Type"; rec."Entry Type")
                    {

                    }
                    field("Description"; rec."Description")
                    {

                    }
                    field("Amount"; rec."Amount")
                    {

                        Enabled = edCard;

                        ; trigger OnValidate()
                        BEGIN
                            SetControls;
                            CurrPage.UPDATE;
                        END;


                    }

                }
                group("Totals1")
                {

                    CaptionML = ENU = 'Data', ESP = 'Totales de la Cuenta';
                    Visible = seeTotales1;
                    Editable = false;
                    field("Description1"; rec."Description")
                    {

                    }
                    field("Amount1"; rec."Sum Account Amount")
                    {

                        DrillDown = false;
                        Enabled = edCard;

                        ; trigger OnValidate()
                        BEGIN
                            SetControls;
                            CurrPage.UPDATE;
                        END;


                    }

                }
                group("Totals2")
                {

                    CaptionML = ENU = 'Data', ESP = 'Totales del Proyecto';
                    Visible = seeTotales2;
                    Editable = false;
                    field("Description2"; rec."Description")
                    {

                    }
                    field("Amount2"; rec."Sum Job Amount")
                    {

                        DrillDown = false;
                    }

                }

            }
            group("group61")
            {

                CaptionML = ESP = 'Notas';
                field("Comments"; rec."Comments")
                {

                    Editable = edCard;
                    MultiLine = true;
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
            //CaptionML=ESP='Opciones';
            action("Preview")
            {

                CaptionML = ESP = 'Vista Previa';
                Enabled = enPreview;
                Image = View;

                trigger OnAction()
                VAR
                    QBPrepaimentManagement: Codeunit 7207300;
                BEGIN
                    //-----------------------------------------------------------------------------------------------------------------------------------
                    //JAV 28/03/22: - QB 1.10.29 Modificaciones para el tratamiento del anticipo sin factura, se a�ade la acci�n para la vista previa
                    //-----------------------------------------------------------------------------------------------------------------------------------
                    QBPrepaimentManagement.CreateGenJnlLines(Rec, FALSE);
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
                ApplicationArea = Basic, Suite;
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
                        SetControls;
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
                        SetControls;
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
                        SetControls;
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

                actionref(Preview_Promoted; Preview)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

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
                CaptionML = ENU = 'Incoming Document', ESP = 'Documento entrante';
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
        FTipo := Rec.GETFILTER(rec."Account Type");

        IF NOT QuoBuildingSetup.GET THEN
            QuoBuildingSetup.INIT;

        //JAV 29/06/22: - QB 1.10.57 Se cambia de lugar el c�digo que pone el tipo de documento para que funcione correctamente
        // CASE QuoBuildingSetup."Prepayment Document Type" OF
        //  QuoBuildingSetup."Prepayment Document Type"::ForceInvoice : rec."Generate Document" := rec."Generate Document"::Invoice;
        //  QuoBuildingSetup."Prepayment Document Type"::ForceBill    : rec."Generate Document" := rec."Generate Document"::Bill;
        // END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetControls;
        PageCaption_ := 'Anticipo N� ' + FORMAT(rec."Entry No.");
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        Rec."Job No." := FJob;
        CASE FTipo OF
            FORMAT(Rec."Account Type"::Customer):
                Rec."Account Type" := Rec."Account Type"::Customer;
            FORMAT(Rec."Account Type"::Vendor):
                Rec."Account Type" := Rec."Account Type"::Vendor;
        END;
        rec."Posting Date" := TODAY;
        rec."Document Date" := TODAY;

        SetControls;

        //JAV 29/06/22: - QB 1.10.57 Se cambia de lugar el c�digo que pone el tipo de documento para que funcione correctamente
        CASE QuoBuildingSetup."Prepayment Document Type" OF
            QuoBuildingSetup."Prepayment Document Type"::Invoice,
          QuoBuildingSetup."Prepayment Document Type"::ForceInvoice:
                rec."Generate Document" := rec."Generate Document"::Invoice;
            QuoBuildingSetup."Prepayment Document Type"::Bill,
          QuoBuildingSetup."Prepayment Document Type"::ForceBill:
                rec."Generate Document" := rec."Generate Document"::Bill;
        END;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        //Mirar el �ltimo tipo
        QBPrepayment.RESET;
        QBPrepayment.SETRANGE("Job No.", Job."No.");
        CASE rec."Account Type" OF
            QBP."Account Type"::Customer:
                BEGIN
                    QBPrepayment.SETRANGE("Account Type", QBP."Account Type"::Customer);
                    QBPrepayment.SETRANGE("Account No.", rec."Account No.");
                END;
            QBP."Account Type"::Vendor:
                BEGIN
                    QBPrepayment.SETRANGE("Account Type", QBP."Account Type"::Vendor);
                    QBPrepayment.SETRANGE("Account No.", rec."Account No.");
                END;
        END;
        QBPrepayment.SETFILTER("Entry Type", '%1|%2', QBP."Entry Type"::Invoice, QBP."Entry Type"::Bill);

        QBPrepayment.CALCSUMS(Amount);
        IF (QBPrepayment.Amount <> 0) THEN BEGIN
            IF QBPrepayment.FINDLAST THEN
                CASE rec."Entry Type" OF
                    rec."Entry Type"::Invoice:
                        IF (QBPrepayment."Entry Type" <> QBP."Entry Type"::Invoice) THEN
                            ERROR(Txt006);
                    rec."Entry Type"::Bill:
                        IF (QBPrepayment."Entry Type" <> QBP."Entry Type"::Bill) THEN
                            ERROR(Txt006);
                END;
        END;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetControls;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        Job: Record 167;
        Customer: Record 18;
        Vendor: Record 23;
        Currency: Record 4;
        QBPrepayment: Record 7206928;
        QBP: Record 7206928;
        QBPrepaymentTypes: Record 7206993;
        FunctionQB: Codeunit 7207272;
        QBPrepaymentManagement: Codeunit 7207300;
        enType: Boolean;
        enDescription: Boolean;
        Txt006: TextConst ESP = 'No puede usar ese tipo de documento ya que es diferente al �ltimo que us�.';
        Txt010: TextConst ESP = 'Anticipo a cuenta';
        Txt011: TextConst ESP = '%1% sobre %2 para el proyecto %3';
        Txt012: TextConst ESP = 'Sobre %2 para el proyecto %3';
        Txt013: TextConst ESP = 'Anticipo del %1% para el proyecto %3';
        Txt014: TextConst ESP = 'Para el proyecto %3';
        Txt017: TextConst ESP = 'Anticipo %1 proyecto %2';
        Txt020: TextConst ESP = 'Liq. %1% del anticipo pendiente de %2';
        Txt021: TextConst ESP = 'Liq.Parcial anticipo pendiente de %2';
        Txt022: TextConst ESP = 'Liquidaci�n completa del anticipo pendiente';
        enPreview: Boolean;
        edJob: Boolean;
        edCard: Boolean;
        edType: Boolean;
        edDate: Boolean;
        edGenerateDoc: Boolean;
        edDocNo: Boolean;
        enPost: Boolean;
        enSee: Boolean;
        enNavigate: Boolean;
        gJob: Code[20];
        gType: Option;
        FJob: Text;
        FTipo: Text;
        PageCaption_: Text;
        seeData: Boolean;
        seeCancel: Boolean;
        seeTotales1: Boolean;
        seeTotales2: Boolean;
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

    procedure SetData(pJob: Code[20]);
    begin
        edJob := (not Job.GET(pJob));
    end;

    procedure GetData(var pRec: Record 7206928);
    begin
        pRec := Rec;
    end;

    LOCAL procedure SetControls();
    begin
        edCard := (Rec."Approval Status" = Rec."Approval Status"::Open) and (Rec.Amount = 0);  //Solo ser� editable si est� abierto y no est� registrado
                                                                                               //JAV 09/11/22: - QB 1.12.16 Solo son editables las entradas de factura y efecto, las anulaciones y totales no
        edCard := edCard and ((Rec."Entry Type" = Rec."Entry Type"::Invoice) or (Rec."Entry Type" = Rec."Entry Type"::Bill));

        enPreview := (Rec.Amount = 0) and (rec."Generate Document" = rec."Generate Document"::Bill);
        enDescription := edCard and (rec."Generate Document" = rec."Generate Document"::Invoice) and (edCard);

        //JAV 31/03/22: - QB 1.10.29 Aprobaciones de QuoBuilding, se llama a la funci�n para activar los controles de aprobaci�n
        //JAV 09/11/22: - QB 1.12.16 Solo son editables las entradas de factura y efecto, las anulaciones y totales no
        //if (Rec."Entry No." <> 0) then
        if (Rec."Entry No." <> 0) and ((Rec."Entry Type" = Rec."Entry Type"::Invoice) or (Rec."Entry Type" = Rec."Entry Type"::Bill)) then
            cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen)
        ELSE begin
            ApprovalsActive := FALSE;
            OpenApprovalsPage := FALSE;
            CanRequestApproval := FALSE;
            CanCancelApproval := FALSE;
            CanRelease := FALSE;
            CanReopen := FALSE;
        end;

        edJob := edCard and (FJob = '');
        enType := edCard and (FTipo = '');

        edDate := edCard and (Rec."Account Type" = Rec."Account Type"::Vendor);

        enPost := (rec."Document No." = '') and (rec."Approval Status" = rec."Approval Status"::Released);
        enSee := (rec.Amount = 0) and (rec."Entry Type" = rec."Entry Type"::Invoice) and (rec."Document No." <> '');
        enNavigate := (rec.Amount <> 0);

        //JAV 11/04/22: - QB 1.10.35 Editable seg�n configuraci�n y tipo
        edDocNo := edCard and (rec."For Document Type" <> rec."For Document Type"::None);

        edGenerateDoc := edCard;
        if (QBPrepaymentTypes.GET(rec."Prepayment Type")) then
            edGenerateDoc := edCard and (QBPrepaymentTypes."Document to Generate" = QBPrepaymentTypes."Document to Generate"::" ");

        edGenerateDoc := edCard and (not (QuoBuildingSetup."Prepayment Document Type" IN [QuoBuildingSetup."Prepayment Document Type"::ForceInvoice, QuoBuildingSetup."Prepayment Document Type"::ForceBill]));

        //JAV 09/11/22: - QB 1.12.16 A�adir datos seg�n el tipo de entrada y solo son editable las adecuadas
        seeData := (Rec."Entry Type" = Rec."Entry Type"::Invoice) or (Rec."Entry Type" = Rec."Entry Type"::Bill);
        seeCancel := (Rec."Entry Type" = Rec."Entry Type"::Cancelation);
        seeTotales1 := (Rec."Entry Type" = Rec."Entry Type"::TAccount);
        seeTotales2 := (Rec."Entry Type" = Rec."Entry Type"::TJob);
    end;

    // begin
    /*{
      JDC 26/02/21 - Q12879 Modified function "OnOpenPage", "AccountNo - OnValidate", "SetJob", "SetAplicacion"
      JDC 07/05/21 - Q13154 Modified function "GetData"
                            Modified PageLayout adding "SourceType"
      JAV 28/03/22: - QB 1.10.29 Modificaciones para el tratamiento del anticipo sin factura, se a�ade la acci�n para la vista previa
      JAV 29/06/22: - QB 1.10.57 Se cambia de lugar el c�digo que pone el tipo de documento para que funcione correctamente
      JAV 09/11/22: - QB 1.12.16 Solo son editables las entradas de factura y efecto, las anulaciones y totales no
                                 A�adir datos seg�n el tipo de entrada y solo son editable las adecuadas
    }*///end
}







