page 7207103 "QPR Budget List"
{
    CaptionML = ENU = 'Job Budget List', ESP = 'Lista presupuesto obra';
    SourceTable = 7207407;
    SourceTableView = SORTING("Job No.", "Budget Date")
                    ORDER(Ascending);
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                repeater("Group")
                {

                    field("Cod. Budget"; rec."Cod. Budget")
                    {

                        StyleExpr = stCalculated1;
                    }
                    field("Budget Name"; rec."Budget Name")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("Budget Simulation"; rec."Budget Simulation")
                    {

                    }
                    field("Initial Budget"; rec."Initial Budget")
                    {

                    }
                    field("Actual Budget"; rec."Actual Budget")
                    {

                    }
                    field("Budget Date"; rec."Budget Date")
                    {

                        Editable = false;
                        StyleExpr = stCalculated2;
                    }
                    field("QPR End Date"; rec."QPR End Date")
                    {

                        Editable = false;
                    }
                    field("Status"; rec."Status")
                    {

                    }
                    field("Approval Status"; rec."Approval Status")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("Origin"; rec."Origin")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("QPR Cost Amount"; rec."QPR Cost Amount")
                    {

                    }
                    field("QPR Sale Amount"; rec."QPR Sale Amount")
                    {

                    }
                    field("QPR Sale Amount - QPR Cost Amount"; rec."QPR Sale Amount" - rec."QPR Cost Amount")
                    {

                        CaptionML = ESP = 'Importe Presup.';
                    }
                    field("QPR Cost Comprometido"; rec."QPR Cost Comprometido")
                    {

                    }
                    field("QPR Cost Performed"; rec."QPR Cost Performed")
                    {

                    }
                    field("QPR Cost Invoiced"; rec."QPR Cost Invoiced")
                    {

                    }
                    field("QPR Sale Comprometido"; rec."QPR Sale Comprometido")
                    {

                    }
                    field("QPR Sale Performed"; rec."QPR Sale Performed")
                    {

                    }
                    field("QPR Sale Invoiced"; rec."QPR Sale Invoiced")
                    {

                    }
                    field("Value Date"; rec."Value Date")
                    {

                        Visible = useCurrencies;
                    }

                }

            }
            part("Operations"; 7207104)
            {

                CaptionML = ENU = 'Operations', ESP = 'Operaciones';
                SubPageLink = "Job No." = FIELD("Job No."), "Budget Filter" = FIELD("Cod. Budget");
                Editable = bEditable;
                UpdatePropagation = Both

  ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Plan&ning', ESP = 'P&resupuestos';
                action("action1")
                {
                    CaptionML = ENU = 'Changer Status Budget', ESP = 'Cambiar estado presupuesto';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        LChangeBudgetStatus: Codeunit 7207331;
                    BEGIN
                        LChangeBudgetStatus.BudgetChangeStatus(Rec);

                        IF (rec.Status = rec.Status::Open) THEN
                            rec."Approval Status" := rec."Approval Status"::Open
                        ELSE
                            rec."Approval Status" := rec."Approval Status"::Released;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Changer Status Budget', ESP = 'Marcar como actual';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        LChangeBudgetStatus: Codeunit 7207331;
                    BEGIN
                        LChangeBudgetStatus.SetBudgetActual(Rec);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Changer Status Budget', ESP = 'Marcar como inicial';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        LChangeBudgetStatus: Codeunit 7207331;
                    BEGIN
                        LChangeBudgetStatus.SetBudgetInitial(Rec);
                    END;


                }
                action("PieceworkScheduling")
                {

                    CaptionML = ENU = 'Piecework Sch&eduling', ESP = '&Planificaci�n de UO';
                    Visible = TRUE;
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        PlanJobUnitsMatrix: Page 7207060;
                    BEGIN
                        //SchedulePiecework;
                        //JAV 11/12/18: se llama desde aqu� para provechar la llamada anterior en otra acci�n
                        //PAGE.RUNMODAL(PAGE::"Plan Job Units",DataJobUnitForProduction);
                        //JAV 11/12/18 fin

                        //QRE-LCG-INI Quito el cometario a la primera funci�n y comento la segunda que no existe.
                        //JAV 22/06/21: - QB 1.09.02 Se pasa a una funci�n presentar la pantalla de planificaci�n

                        //QBPageSubscriber.SeeSchedulePieceworks("Job No.", "Cod. Budget", TRUE);
                        QBPageSubscriber.SeeSchedulePieceworksForBudgets(rec."Job No.", rec."Cod. Budget", TRUE);
                        //QRE-LCG-fin

                        SetColumns(SetWanted::Initial);
                        PlanJobUnitsMatrix.Load(MatrixColumnCaptions, MatrixRecords, QtyType, rec."Job No.", rec."Cod. Budget", ColumnSet, TRUE, FALSE);
                        PlanJobUnitsMatrix.RUNMODAL;

                    END;


                }

            }
            group("group7")
            {
                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("action5")
                {
                    CaptionML = ENU = 'Calculate Budget Revision', ESP = 'Calcular Presupuesto';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        LJob: Record 167;
                        LJobBudgetActual: Record 7207407;
                        FunctionQB: Codeunit 7207272;
                    BEGIN

                        //TO-DO Esto solo debe calcular los totales, pero ya se van haciendo al meter las l�neas

                        // IF (Rec."Budget Date" = 0D) THEN
                        //  ERROR(Text003, "Cod. Budget");
                        //
                        //
                        // //Calcula el presupuesto marcado
                        // CLEAR(RateBudgetsbyPiecework);
                        // LJob.GET("Job No.");
                        // LJobBudgetActual.GET("Job No.","Cod. Budget");
                        // IF LJobBudgetActual.Status <> LJobBudgetActual.Status::Close THEN
                        //  RateBudgetsbyPiecework.ValueInitialization(LJob,LJobBudgetActual)
                        // ELSE
                        //  MESSAGE(Text000);
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Test', ESP = 'Test';
                    Image = TaskList;

                    trigger OnAction()
                    VAR
                        CostPieceworkJobIdent: Codeunit 7207296;
                    BEGIN
                        //JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
                        CLEAR(CostPieceworkJobIdent);
                        CostPieceworkJobIdent.Process(rec."Job No.", rec."Cod. Budget", 1);
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Import Budget since Excel', ESP = 'Importar ppto. desde Excel';
                    Image = Import;

                    trigger OnAction()
                    VAR
                        // ImportBudgetExcel: Report 7207376;
                    BEGIN
                        // ImportBudgetExcel.ReceiveParameters(rec."Job No.", rec."Cod. Budget");
                        // ImportBudgetExcel.RUNMODAL;
                        // CLEAR(ImportBudgetExcel);
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'Export Budget to Excel', ESP = 'Exportar ppto. a Excel';
                    Image = Export;

                    trigger OnAction()
                    VAR
                        // ImportBudgetExcel: Report 7207376;
                    BEGIN

                        // RExportLinPptoExcel.SetParametros(rec."Job No.", rec."Cod. Budget");
                        // RExportLinPptoExcel.RUNMODAL;
                        // CLEAR(RExportLinPptoExcel);
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = 'Import Budget sice Excel', ESP = 'Importar ppto. desde Excel';
                    Image = Import;

                    trigger OnAction()
                    VAR
                        // ImportBudgetExcel: Report 7207376;
                    BEGIN

                        // RImportLinPptoExcel.SetParameters(rec."Job No.", rec."Cod. Budget");
                        // RImportLinPptoExcel.RUNMODAL;
                        // CLEAR(RImportLinPptoExcel);
                    END;


                }
                action("CloseMonth")
                {

                    CaptionML = ENU = 'Close Month', ESP = 'Cerrar Ejercicio';
                    Image = ClosePeriod;

                    trigger OnAction()
                    VAR
                        // MonthClosing: Report 7207424;
                        Job: Record 167;
                    BEGIN
                        //QCPM_GAP09
                        Job.RESET;
                        Job.SETRANGE("No.", Rec."Job No.");
                        Job.FINDFIRST;

                        // CLEAR(MonthClosing);
                        // MonthClosing.SetMonth(Rec."Job No.");
                        // MonthClosing.SETTABLEVIEW(Job);
                        // MonthClosing.RUN;
                    END;


                }

            }
            group("group14")
            {
                CaptionML = ENU = 'Initial P&rosfit', ESP = '&Utilidades';
                action("action11")
                {
                    CaptionML = ENU = 'Copy Budget of a Job', ESP = 'Copiar de otro presupuesto';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        rJob: Record 167;
                    BEGIN
                        //JAV 11/04/19: - Se remite el presupuesto al proceso de copiar de otro presupuesto
                        rJob.GET(rec."Job No.");
                        CurrPage.Operations.PAGE.CopyBudgetOtherJob(rJob."Initial Budget Piecework", TRUE);
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'Copy from another budget', ESP = 'Copiar de otro ejercicio';
                    Image = ExchProdBOMItem;

                    trigger OnAction()
                    VAR
                        // CopyJobBudget: Report 7207400;
                    BEGIN
                        // CLEAR(CopyJobBudget);
                        // CopyJobBudget.PassParameters(Rec);
                        // CopyJobBudget.RUNMODAL;
                    END;


                }
                action("action13")
                {
                    CaptionML = ENU = 'Bring Budget Line', ESP = 'Traer plantilla Ppto.';
                    Image = Template;

                    trigger OnAction()
                    BEGIN
                        // CLEAR(RTraerPresupuesto);
                        // RTraerPresupuesto.SetBudgetTarget(Rec."Job No.");
                        // RTraerPresupuesto.RUN;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group19")
            {
                CaptionML = ENU = 'Approval', ESP = 'Aprobaci¢n';
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
                    ToolTipML = ENU = 'Reject the approval request.', ESP = 'Rechaza la solicitud de aprobaci¢n.';
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
                    ToolTipML = ENU = 'Reject the approval request.', ESP = 'Rechaza la solicitud de aprobaci¢n.';
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
                    ToolTipML = ENU = 'Delegate the approval to a substitute approver.', ESP = 'Delega la aprobaci¢n a un aprobador sustituto.';
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
            group("group25")
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Aprobaci¢n solic.';
                action("Approvals")
                {

                    AccessByPermission = TableData 454 = R;
                    CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                    ToolTipML = ENU = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.', ESP = 'Permite ver una lista de los registros en espera de aprobaci¢n. Por ejemplo, puede ver qui‚n ha solicitado la aprobaci¢n del registro, cu ndo se envi¢ y la fecha de vencimiento de la aprobaci¢n.';
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

                    CaptionML = ENU = 'Send A&pproval Request', ESP = 'Enviar solicitud a&probaci¢n';
                    ToolTipML = ENU = 'Request approval of the document.', ESP = 'Permite solicitar la aprobaci¢n del documento.';
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

                    CaptionML = ENU = 'Cancel Approval Re&quest', ESP = '&Cancelar solicitud aprobaci¢n';
                    ToolTipML = ENU = 'Cancel the approval request.', ESP = 'Cancela la solicitud de aprobaci¢n.';
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
                action("InsertDate")
                {

                    CaptionML = ESP = 'Insertar fecha';
                    Visible = InsertDateVisible;
                    Image = Insert;


                    trigger OnAction()
                    VAR
                        JobBudget: Record 7207407;
                        // InsertDateToJobBudget: Report 7238281;
                    BEGIN
                        //RE16257-LCG-010222-INI
                        // CLEAR(InsertDateToJobBudget);
                        // InsertDateToJobBudget.SetJobBudget(Rec."Job No.", Rec."Cod. Budget");
                        // InsertDateToJobBudget.RUN;
                        CurrPage.UPDATE();
                        //RE16257-LCG-010222-FIN
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
                CaptionML = ENU = 'Process', ESP = 'Procesar';

                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref(CloseMonth_Promoted; CloseMonth)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informes';

                actionref(PieceworkScheduling_Promoted; PieceworkScheduling)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Calculate', ESP = 'C lculos';

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
                actionref(Comment_Promoted; Comment)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        useCurrencies := FunctionQB.UseCurrenciesInJobs(1);
    END;

    trigger OnOpenPage()
    BEGIN
        //JAV 29/01/20: - Si no hay ning£n presupuesto, creamos el inicial
        Job.GET(rec."Job No.");
        IF (Rec.ISEMPTY) THEN BEGIN

            Job."Initial Budget Piecework" := FORMAT(DATE2DMY(WORKDATE, 3));
            Job.MODIFY;

            JobBudget.INIT;
            JobBudget."Job No." := rec."Job No.";
            JobBudget."Cod. Budget" := Job."Initial Budget Piecework";
            JobBudget."Budget Name" := Text001;
            JobBudget."Budget Date" := TODAY;
            JobBudget."Actual Budget" := TRUE;
            JobBudget."Budget Ref." := TRUE;
            JobBudget.INSERT(TRUE);
        END;

        //JAV 30/05/19: - Posicionarse en el presupuesto mas nuevo siempre
        //Rec.FINDLAST;

        //JMMA 270121 Job.GET("Job No.");
        IF Job.GET(rec."Job No.") THEN;
        JobDescription := '';
        IF Rec.GETFILTER("Job No.") <> '' THEN
            JobDescription := FunctionQB.ShowDescriptionJob(Rec.GETFILTER("Job No."));
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //JAV 05/03/19: - La lista de unidades de obras no es editable si el presupuesto esta cerrado
        bEditable := (rec.Status = rec.Status::Open);
        //JAV --

        //JAV 30/01/10: - Marca de que el presupuesto debe actualizarce
        QBPageSubscriber.SetBudgetNeedRecalculate(rec."Pending Calculation Budget", rec."Pending Calculation Analitical", stCalculated1, stCalculated2, txtCalculated);

        //JAV 10/03/20: - Se llama a la funci¢n para activar los controles de aprobaci¢n
        cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);

        SetVisibleInsertDate(Rec."Job No.")
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CurrPage.Operations.PAGE.SetParameter(Rec."Cod. Budget");
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        JobBudget: Record 7207407;
        QuoBuildingSetup: Record 7207278;
        PieceworkData: Page 7207506;
        CostUnitData: Page 7207535;
        DataInvestementUnit: Page 7207599;
        RateBudgetsbyPiecework: Codeunit 7207329;
        Text000: TextConst ENU = 'CLOSED BUDGET', ESP = 'PRESUPUESTO CERRADO';
        Text001: TextConst ESP = 'Inicial';
        ConvertToBudgetxCA: Codeunit 7207282;
        Text002: TextConst ESP = 'Confirme que desea lanzar el proceso';
        Text003: TextConst ESP = 'No ha indicado la fecha en el presupuesto %1, no lo puede calcular';
        Text005: TextConst ENU = 'The process is over', ESP = 'El proceso ha terminado';
        FunctionQB: Codeunit 7207272;
        QBPageSubscriber: Codeunit 7207349;
        JobDescription: Text[250];
        IsVersion: Boolean;
        TotalAmountStudiedBudget: Decimal;
        TotalAmountCostBudget: Decimal;
        DiffBiddingBasesBudget: Decimal;
        DiffAssignedAmount: Decimal;
        Text006: TextConst ENU = 'Cannot reestimate actual budged', ESP = 'No puede reestimar el Presupuesto actual';
        bEditable: Boolean;
        txtCalculated: Text;
        stCalculated1: Text;
        stCalculated2: Text;
        useCurrencies: Boolean;
        Text008: TextConst ENU = 'The analytical budget will be calculated. do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal¡tico. ¨Desea continuar?';
        "---------------------------- Aprobaciones": Integer;
        cuApproval: Codeunit 7206929;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        "-------------------": Integer;
        // RTraerPresupuesto: Report 7207451;
        // RExportLinPptoExcel: Report 7207454;
        // RImportLinPptoExcel: Report 7207455;
        "---------------": Integer;
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        ColumnSet: Text[1024];
        MatrixColumnCaptions: ARRAY[32] OF Text[1024];
        // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
        PeriodType :Enum "Analysis Period Type";
        SetWanted: Option "Initial","Previous","Same","Next";
        QtyType: Option "Net Change","Balance at Date";
        NoJob: Code[20];
        BudgetFilter: Code[20];
        TypeFilter: Text;
        PKFirstRecInCurrSet: Text[100];
        InsertDateVisible: Boolean;

    procedure OpenBudgetxPiecework();
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Cod. Budget");
        CLEAR(PieceworkData);
        //JAV 02/04/19: - Se elimina de la llamada a la page de costes directos el LOOKUPMODE
        //PieceworkData.LOOKUPMODE(TRUE); //JAV 26/03/19: - Se a¤ade TRUE al LOOKUPMODE
        //JAV 02/04/19 fin
        PieceworkData.SETTABLEVIEW(DataPieceworkForProduction);
        PieceworkData.ReceivedJob(rec."Job No.", rec."Cod. Budget");
        if DataPieceworkForProduction.FINDFIRST then
            PieceworkData.SETRECORD(DataPieceworkForProduction);

        //JAV ++ 05/03/19: - Si esta cerrado que no sea editable
        PieceworkData.EDITABLE(rec.Status = rec.Status::Open);
        //JAV --

        //JAV 02/04/19: - Se elimina el lookup mode y su retorno
        //if PieceworkData.RUNMODAL=ACTION::LookupOK then;
        PieceworkData.RUNMODAL;
    end;

    procedure OpenBudgetxPieceworkCost();
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Cod. Budget");
        CLEAR(CostUnitData);
        //JAV 02/04/19: - Se elimina de la llamada a la page de costes indirectos el LOOKUPMODE
        //CostUnitData.LOOKUPMODE(TRUE); //JAV 26/03/19: - Se a¤ade TRUE al LOOKUPMODE
        //JAV 02/04/19 fin
        CostUnitData.SETTABLEVIEW(DataPieceworkForProduction);
        CostUnitData.ReceivesJob(rec."Job No.", rec."Cod. Budget");
        if DataPieceworkForProduction.FINDFIRST then
            CostUnitData.SETRECORD(DataPieceworkForProduction);

        //JAV ++ 05/03/19: - Si esta cerrado que no sea editable
        CostUnitData.EDITABLE(rec.Status = rec.Status::Open);
        //JAV --

        //JAV 02/04/19: - Se elimina el lookup mode y su retorno
        //if CostUnitData.RUNMODAL=ACTION::LookupOK then;
        CostUnitData.RUNMODAL;
    end;

    procedure PlanSubcontrating();
    var
        LActivityQB: Record 7207280;
        LActivitiesforSubcontract: Page 7207606;
    begin
        LActivitiesforSubcontract.PassCurrentBudgetCode(rec."Cod. Budget", rec."Job No.");
        LActivityQB.SETRANGE("Job Filter", rec."Job No.");
        LActivityQB.SETRANGE("Budget Filter", rec."Cod. Budget");
        LActivitiesforSubcontract.SETTABLEVIEW(LActivityQB);
        LActivitiesforSubcontract.RUNMODAL;
    end;

    procedure OpenBudgetxPieceworkInver();
    begin
        CLEAR(DataInvestementUnit);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Cod. Budget");
        CLEAR(CostUnitData);
        //JAV 02/04/19: - Se elimina de la llamada a la page de inversi¢n el LOOKUPMODE
        //DataInvestementUnit.LOOKUPMODE(TRUE); //JAV 26/03/19: - Se a¤ade TRUE al LOOKUPMODE
        //JAV 02/04/19 fin
        DataInvestementUnit.SETTABLEVIEW(DataPieceworkForProduction);
        DataInvestementUnit.ReceiveJob(rec."Job No.", rec."Cod. Budget");
        if DataPieceworkForProduction.FINDFIRST then
            DataInvestementUnit.SETRECORD(DataPieceworkForProduction);

        //JAV ++ 05/03/19: - Si esta cerrado que no sea editable
        DataInvestementUnit.EDITABLE(rec.Status = rec.Status::Open);
        //JAV --

        //JAV 02/04/19: - Se elimina el lookup mode y su retorno
        //if DataInvestementUnit.RUNMODAL=ACTION::LookupOK then;
        DataInvestementUnit.RUNMODAL;
    end;

    LOCAL procedure CalculateTotalAmountCostBudget();
    var
        DataPieceworkForProduction2: Record 7207386;
    begin
        //QBV102>>
        CLEAR(TotalAmountCostBudget);
        DataPieceworkForProduction2.RESET;
        DataPieceworkForProduction2.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
        DataPieceworkForProduction2.SETRANGE("Budget Filter", rec."Cod. Budget");
        if DataPieceworkForProduction2.FINDSET then begin
            repeat
                DataPieceworkForProduction2.CALCFIELDS("Amount Cost Budget (JC)");
                TotalAmountCostBudget += DataPieceworkForProduction2."Amount Cost Budget (JC)";
            until DataPieceworkForProduction2.NEXT = 0;
        end;
        //QBV102<<
    end;

    LOCAL procedure CalculateTotalAmountStudiedBudget();
    var
        DataPieceworkForProduction3: Record 7207386;
    begin
        //QBV102>>
        CLEAR(TotalAmountStudiedBudget);
        DataPieceworkForProduction3.RESET;
        DataPieceworkForProduction3.SETRANGE("Job No.", rec."Job No.");
        DataPieceworkForProduction3.SETRANGE("Account Type", DataPieceworkForProduction3."Account Type"::Unit);
        DataPieceworkForProduction3.SETRANGE("Budget Filter", rec."Cod. Budget");
        DataPieceworkForProduction3.SETRANGE(Studied, TRUE);
        if DataPieceworkForProduction3.FINDSET then begin
            repeat
                DataPieceworkForProduction3.CALCFIELDS("Amount Cost Budget");
                TotalAmountStudiedBudget += DataPieceworkForProduction3."Amount Cost Budget";
            until DataPieceworkForProduction3.NEXT = 0;
        end;
        //QBV102<<
    end;

    LOCAL procedure DiffAmountCostbudgetBiddingBasesBudget();
    var
        Job: Record 167;
    begin
        //QBV102>>
        Job.RESET;
        Job.SETRANGE("No.", rec."Job No.");
        if Job.FINDSET then
            if TotalAmountCostBudget = 0 then
                DiffBiddingBasesBudget := 0
            ELSE
                DiffBiddingBasesBudget := (Job."Bidding Bases Budget" * 100) / TotalAmountCostBudget;
        //QBV102<<
    end;

    LOCAL procedure DiffAmountCostBudgetAssignedAmount();
    var
        Job: Record 167;
    begin
        //QBV102>>
        Job.RESET;
        Job.SETRANGE("No.", rec."Job No.");
        if Job.FINDSET then
            if TotalAmountCostBudget = 0 then
                DiffAssignedAmount := 0
            ELSE
                DiffAssignedAmount := (Job."Assigned Amount" * 100) / TotalAmountCostBudget;
        //QBV102<<
    end;

    procedure SetColumns(SetWanted: Option "Initial","Previous","Same","Next");
    var
        MatrixMgt: Codeunit 9200;
        Job: Record 167;
        CurrSetLength: Integer;
    begin
        if Job.GET(rec."Job No.") then;
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, 32, FALSE, PeriodType, FORMAT(Job."Starting Date") + '..' + FORMAT(Job."Ending Date"),
                                           PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
    end;

    LOCAL procedure SetVisibleInsertDate(JobNo: Code[20]);
    var
        Job: Record 167;
    begin

        Job.RESET;
        if Job.GET(JobNo) then
            InsertDateVisible := Job."Card Type" = Job."Card Type"::Promocion;
    end;

    // begin
    /*{
      NZG 23/01/18: - QBV102 A¤adidos Los totales de Amount Cost Budget y Amount Studied Budget y porcentajes
      JAV 05/03/19: - Si esta cerrado que no sea editable
                    - Se hace no editable el campo "TotalCost"
                    - La lista de unidades de obras no es editable si el presupuesto esta cerrado
      JAV 26/03/19: - Se pone imagen en el boton Utilidades presupuestos sucesivos
                    - Se a¤aden los campos 21 "Budget Amount Cost Direct" y 22 "Budget Amount Cost Indirect"
                    - Se a¤ade TRUE al LOOKUPMODE
      JAV 02/04/19: - Se deshace lo anterior, se elimina de la llamada a las Pages de costes directos, indirectos, inversiones y agrupaci¢n de costes el modo LOOKUP que realmente deb¡a estar a FALSE
      JAV 08/04/19: - Se cambia el caption del bot¢n "&Utilidades Inicial" por "Utilidades"
                    - Se a¤ade una acci¢n para volver a traer los textos del preciario
      JAV 11/04/19: - Se remite el presupuesto actual al proceso de copiar de otro presupuesto
                    - Nueva acci¢n para copiar de otro presupuesto
      PEL 02/05/19: - QCPM_GAP09 Nueva acci¢n del cierre del mes
      JAV 30/05/19: - Calcular el total de las l¡neas en una sola funci¢n
                    - Posicionarse en el presupuesto mas nuevo siempre
      JAV 26/09/19: - Se ocultan las columnas de mediciones que no tienen mucho sentido real, solo se calculan en cada l¡nea para saber el previsto y la desviaci¢n
      JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
      JAV 11/10/19: - Se a¤ade el campo 11 "Reestimation" que indica si el presupuesto se ha reestimado y el 12 rec."Origin" del presupuesto del que se ha copiado/reestimado
      JAV 29/01/20: - Si no hay ning£n presupuesto, creamos el inicial
      JAV 30/01/10: - Marca de que el presupuesto debe actualizarce
      Q13715 QMD 23/06/21 - Se a¤ade campo "Cost in closed period"
      RE16067-LCG-281221- Cambiar la asignaci�n de fechas cuando el proyecto es tipo promoci�n. Esto se hace porque cuando se crea el primer presupuesto o Job Budget no se ha informado la fecha final del proyecto.
      RE16257-LCG-010222-Crear bot�n para introducir fecha en presupuestos multianuales.
    }*///end
}







