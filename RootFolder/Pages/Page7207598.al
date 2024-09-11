page 7207598 "Job Budget List"
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
            field("FORMAT(JobDescription)"; FORMAT(JobDescription))
            {

                CaptionClass = FORMAT(JobDescription);
                Editable = FALSE;
                Style = Standard;
                StyleExpr = TRUE;
            }
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
                    field("Reestimation"; rec."Reestimation")
                    {

                    }
                    field("Budget Ref."; rec."Budget Ref.")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("Budget Date"; rec."Budget Date")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("Status"; rec."Status")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("Origin"; rec."Origin")
                    {

                        StyleExpr = stCalculated2;
                    }
                    field("txtCalculated"; txtCalculated)
                    {

                        CaptionML = ESP = 'Importes';
                        Editable = FALSE;
                        StyleExpr = stCalculated2;
                    }
                    field("Cost in closed period"; rec."Cost in closed period")
                    {

                    }
                    field("Production Budget Amount"; rec."Production Budget Amount")
                    {

                        Style = StrongAccent;
                        StyleExpr = TRUE;
                    }
                    field("Budget Amount Cost"; rec."Budget Amount Cost")
                    {

                        Style = StrongAccent;
                        StyleExpr = TRUE;
                    }
                    field("CalculateMarginBudget"; rec."CalculateMarginBudget")
                    {

                        CaptionML = ENU = 'Margin', ESP = 'Margen';
                    }
                    field("CalculateMarginBudgetPercentage"; rec."CalculateMarginBudgetPercentage")
                    {

                        CaptionML = ENU = '% Margin Global', ESP = '% Margen global';
                    }
                    field("Target Amount"; rec."Target Amount")
                    {

                        StyleExpr = stTarget;
                    }
                    field("Cod. Reestimation"; rec."Cod. Reestimation")
                    {

                        Visible = FALSE;
                    }
                    field("Budget Amount Cost Direct"; rec."Budget Amount Cost Direct")
                    {

                    }
                    field("Budget Amount Cost Indirect"; rec."Budget Amount Cost Indirect")
                    {

                    }
                    field("TotalAmountCostBudget"; TotalAmountCostBudget)
                    {

                        CaptionML = ENU = 'Total Amount Cost Budget', ESP = 'Total Importe coste presupuesto';
                        // Numeric = false;
                        Enabled = FALSE;
                    }
                    field("TotalCost"; DataPieceworkForProduction."Total Amount Cost Budget")
                    {

                        CaptionML = ENU = 'Total Cost FlowField';
                        Editable = FALSE;
                    }
                    field("TotalAmountStudiedBudget"; TotalAmountStudiedBudget)
                    {

                        CaptionML = ENU = 'Total Amount Studied Budget', ESP = 'Total Importe estudiado presupuesto';
                        // Numeric = false;
                        Visible = FALSE;
                        Enabled = FALSE;
                    }
                    field("DiffBiddingBasesBudget"; DiffBiddingBasesBudget)
                    {

                        CaptionML = ENU = '% Diff Amount Cost Budget & Bidding Bases Budget', ESP = '% Diferencia Imp. coste Ppto. y Ppto. Base licitaci�n';
                        Enabled = FALSE;
                    }
                    field("DiffAssignedAmount"; DiffAssignedAmount)
                    {

                        CaptionML = ENU = '% Diff Amount Cost Budget & Assigned Amount %', ESP = '"% Diferencia  Imp. coste Ppto. e Imp. Adjudicado "';
                        Enabled = FALSE;
                    }
                    field("Med Presupuestada"; rec."Med Presupuestada")
                    {

                        Visible = FALSE;
                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Med Ejecutada"; rec."Med Ejecutada")
                    {

                        Visible = FALSE;
                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Porcentaje Ejecutado"; rec."Porcentaje Ejecutado")
                    {

                        Visible = FALSE;
                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Importe Produccion Ejecutada"; rec."Importe Produccion Ejecutada")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Otros Ingresos"; rec."Otros Ingresos")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Coste Directo Ejecutado"; rec."Coste Directo Ejecutado")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Coste Indirecto Ejecutado"; rec."Coste Indirecto Ejecutado")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Coste Total Ejecutado"; rec."Coste Total Ejecutado")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Resultado Produccion"; rec."Resultado Produccion")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Importe Directo Esperado"; rec."Importe Directo Esperado")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Diferencia Directos Esperada"; rec."Diferencia Directos Esperada")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Importe Total Esperado"; rec."Importe Total Esperado")
                    {

                        Style = Favorable;
                        StyleExpr = TRUE;
                    }
                    field("Production Budget Amount (LCY)"; rec."Production Budget Amount (LCY)")
                    {

                        Visible = useCurrencies;
                    }
                    field("Budget Amount Cost (LCY)"; rec."Budget Amount Cost (LCY)")
                    {

                        Visible = useCurrencies;
                    }
                    field("Production Budget Amount (ACY)"; rec."Production Budget Amount (ACY)")
                    {

                        Visible = useCurrencies;
                    }
                    field("Budget Amount Cost (ACY)"; rec."Budget Amount Cost (ACY)")
                    {

                        Visible = useCurrencies;
                    }
                    field("Value Date"; rec."Value Date")
                    {

                        Visible = useCurrencies;
                    }

                }

            }
            part("Operations"; 7207620)
            {

                CaptionML = ENU = 'Operations', ESP = 'Operaciones';
                SubPageLink = "Job No." = FIELD("Job No."), "Budget Filter" = FIELD("Cod. Budget");
                Editable = bEditable;
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
                    CaptionML = ESP = 'Ver Todos';
                    Image = AllLines;

                    trigger OnAction()
                    BEGIN
                        //JAV 18/05/22: - QB 1.10.42 Ver todos los presupuestos o solo el actual
                        See(TRUE);
                    END;


                }
                action("action2")
                {
                    CaptionML = ESP = 'Ver Actual';
                    Image = FilterLines;

                    trigger OnAction()
                    BEGIN
                        //JAV 18/05/22: - QB 1.10.42 Ver todos los presupuestos o solo el actual
                        See(FALSE);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Changer Status Budget', ESP = 'Cambiar estado presupuesto';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        LChangeBudgetStatus: Codeunit 7207331;
                    BEGIN
                        LChangeBudgetStatus.BudgetChangeStatus(Rec);
                    END;


                }
                action("action4")
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
                action("action5")
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
                action("action6")
                {
                    CaptionML = ENU = 'Budget by Direct Cost', ESP = 'Ppto. costes directos';
                    Image = CopyToTask;

                    trigger OnAction()
                    BEGIN
                        OpenBudgetxPiecework;
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Budget by Indirect Cost', ESP = 'Ppto. costes indirectos';
                    Image = CreateInteraction;

                    trigger OnAction()
                    BEGIN
                        OpenBudgetxPieceworkCost;
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'Investment Budget', ESP = 'Ppto. inversiones';
                    Image = InsertTravelFee;

                    trigger OnAction()
                    BEGIN
                        OpenBudgetxPieceworkInver;
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = 'Planification &Subcontrating', ESP = 'Planificaci�n &subcontrataci�n';
                    Image = CalculateLines;

                    trigger OnAction()
                    BEGIN
                        PlanSubcontrating;
                    END;


                }
                action("action10")
                {
                    CaptionML = ESP = 'Evoluci�n de las U.O.';
                    Image = CreateLinesFromTimesheet;

                    trigger OnAction()
                    VAR
                        DataPieceworkMatrix: Page 7207288;
                    BEGIN
                        CLEAR(DataPieceworkMatrix);
                        DataPieceworkMatrix.SetJob(rec."Job No.");
                        DataPieceworkMatrix.RUNMODAL;
                    END;


                }
                action("Action7001122")
                {
                    CaptionML = ENU = 'Objectives Card', ESP = 'Ficha Objetivos';
                    Image = NewItemNonStock;
                }

            }
            group("group14")
            {
                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("action12")
                {
                    CaptionML = ENU = 'Calculate Budget Revision', ESP = 'Calcular Presupuesto';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        LJob: Record 167;
                        LJobBudgetActual: Record 7207407;
                        FunctionQB: Codeunit 7207272;
                    BEGIN
                        IF (Rec."Budget Date" = 0D) THEN
                            ERROR(Text003, rec."Cod. Budget");


                        //Calcula el presupuesto marcado
                        CLEAR(RateBudgetsbyPiecework);
                        LJob.GET(rec."Job No.");
                        LJobBudgetActual.GET(rec."Job No.", rec."Cod. Budget");
                        IF LJobBudgetActual.Status <> LJobBudgetActual.Status::Close THEN
                            RateBudgetsbyPiecework.ValueInitialization(LJob, LJobBudgetActual)
                        ELSE
                            MESSAGE(Text000);
                    END;


                }
                action("action13")
                {
                    CaptionML = ENU = 'Calculate Budget Revision', ESP = 'Calcular todos los presupuestos';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        LJob: Record 167;
                        LJobBudget: Record 7207407;
                        FunctionQB: Codeunit 7207272;
                    BEGIN
                        //JAV 23/11/20: - QB 1.07.07 Calcula todos los presupuestos pendientes de recalcular que no est�n cerrados
                        LJobBudget.RESET;
                        LJobBudget.SETRANGE("Job No.", rec."Job No.");
                        LJobBudget.SETRANGE(Status, JobBudget.Status::Open);
                        IF (LJobBudget.FINDSET(FALSE)) THEN
                            REPEAT
                                IF (LJobBudget."Pending Calculation Budget") THEN BEGIN
                                    LJob.GET(rec."Job No.");

                                    CLEAR(RateBudgetsbyPiecework);
                                    RateBudgetsbyPiecework.ValueInitialization(LJob, LJobBudget);
                                END;

                                IF (LJobBudget."Pending Calculation Analitical") THEN BEGIN
                                    DataPieceworkForProduction.RESET;
                                    DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                                    DataPieceworkForProduction.SETRANGE("Budget Filter", LJobBudget."Cod. Budget");

                                    CLEAR(ConvertToBudgetxCA);
                                    ConvertToBudgetxCA.PassBudget(LJobBudget."Cod. Budget");
                                    ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, IsVersion, rec."Job No.");
                                END;
                            UNTIL LJobBudget.NEXT = 0;
                    END;


                }
                action("action14")
                {
                    CaptionML = ENU = 'Calculate Analytic Budget', ESP = 'Calcular ppto. anal�tico';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    BEGIN
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                            DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Cod. Budget");
                            IF DataPieceworkForProduction.FINDSET THEN BEGIN
                                CLEAR(ConvertToBudgetxCA);
                                ConvertToBudgetxCA.PassBudget(rec."Cod. Budget");
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, IsVersion, rec."Job No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }
                action("action15")
                {
                    CaptionML = ESP = 'Calcular diferencias';
                    Image = CalculateBalanceAccount;

                    trigger OnAction()
                    BEGIN
                        rec.CalculateProduction;
                        MESSAGE('Proceso finalizado');
                    END;


                }
                action("action16")
                {
                    CaptionML = ESP = 'Agrupar Datos';
                    Image = Compress;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        //JAV 25/05/22: - QB 1.10.43 Agrupar datos por fechas para reducir el n�mero de registros
                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."Job No.");
                        JobBudget.GET(rec."Job No.", rec."Cod. Budget");
                        RateBudgetsbyPiecework.GroupData(Job, JobBudget);
                    END;


                }
                separator("separator17")
                {

                }
                action("action18")
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
                action("action19")
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
                separator("separator20")
                {

                }
                action("action21")
                {
                    CaptionML = ENU = 'Assigned Certifiaction', ESP = 'Agrupaciones de coste';
                    Visible = verAgrupaciones;
                    Image = LotInfo;

                    trigger OnAction()
                    BEGIN
                        //JAV 31/10/20: - QB 1.07.03 Se usa la funci�n en la tabla para no repetir c�digo
                        Job.GET(rec."Job No.");
                        Job.AssignedCertification(rec."Cod. Budget");
                    END;


                }
                action("action22")
                {
                    CaptionML = ENU = 'Create Certification Budget (Without Separation)', ESP = 'Crear ppto. de certificaci�n (sin separaci�n)';
                    Image = ChangePaymentTolerance;

                    trigger OnAction()
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETCURRENTKEY("Job No.", "Piecework Code");
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        // IF DataPieceworkForProduction.FINDFIRST THEN
                            // REPORT.RUN(REPORT::"Create Budget Cert. Piecework", TRUE, TRUE, DataPieceworkForProduction);
                    END;


                }
                action("CloseMonth")
                {

                    CaptionML = ENU = 'Close Month', ESP = 'Cerrar mes';
                    Image = ClosePeriod;

                    trigger OnAction()
                    VAR
                        // MonthClosing: Report 7207424;
                        Job: Record 167;
                    BEGIN
                        //QCPM_GAP09
                        // CLEAR(MonthClosing);
                        Job.RESET;
                        Job.SETRANGE("No.", Rec."Job No.");
                        Job.FINDFIRST;
                        //+Q18730
                        //MonthClosing.SetMonth(Rec."Job No.");
                        // MonthClosing.Parametros(Job."No.", Rec."Cod. Budget");
                        // MonthClosing.SETTABLEVIEW(Job);
                        // MonthClosing.RUN;
                        //+Q18730
                    END;


                }

            }
            group("group27")
            {
                CaptionML = ENU = 'Initial P&rosfit', ESP = '&Utilidades';
                group("group28")
                {
                    CaptionML = ENU = 'Prosfit Initial Budget', ESP = 'Utilidades presupuesto inicial';
                    Image = ProjectToolsProjectMaintenance;
                    action("action24")
                    {
                        CaptionML = ENU = 'Copy Budget of a Job', ESP = 'Copiar ppto. de una obra';
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
                    action("action25")
                    {
                        CaptionML = ENU = 'Get Cost Database', ESP = 'Traer preciario';
                        Image = JobPrice;

                        trigger OnAction()
                        BEGIN
                            CurrPage.Operations.PAGE.GetCostDatabase(rec."Cod. Budget");
                        END;


                    }
                    action("action26")
                    {
                        CaptionML = ENU = 'Copy Piecerwork and Bill of Item', ESP = 'Copiar UO y descompuesto';
                        Image = Splitlines;

                        trigger OnAction()
                        BEGIN
                            CurrPage.Operations.PAGE.CopyPieceworkBillofItem;
                        END;


                    }
                    separator("separator27")
                    {

                    }

                }
                group("group33")
                {
                    CaptionML = ENU = 'Prosfit Succesive Budget', ESP = 'Utilidades presupuestos sucesivos';
                    Image = Job;
                    action("action28")
                    {
                        CaptionML = ENU = 'Budget Reestimated', ESP = 'Reestimar presupuesto';
                        Image = NewBank;

                        trigger OnAction()
                        VAR
                            BudgetReestimationInitialize: Codeunit 7207334;
                            MonthCurseBudget: Integer;
                        BEGIN
                            //Q13643+
                            QuoBuildingSetup.GET();
                            // Q13643 leer� la tabla de configuraci�n
                            IF QuoBuildingSetup."Block Reestimations" THEN begin
                                // Q13643 si la variable de configuraci�n 141 est� marcada

                                MonthCurseBudget := DATE2DMY(Rec."Budget Date", 2);
                                // Q13643 si la fecha del presupuesto est� entre los meses marcados en los campos 142 a 153
                                IF NOT FunctionQB.AllowReestimationMonth(MonthCurseBudget) THEN begin
                                    // Q13643 si no es uno de los meses permitidos pedir� confirmaci�n con Text009, por defecto false, si conforman sigue el proceso, si no confirman se cancela.
                                    IF NOT CONFIRM(Text009, FALSE) THEN
                                        ERROR(Text010);
                                END;
                            END;
                            //Q13643-

                            CLEAR(BudgetReestimationInitialize);
                            IF Rec."Actual Budget" = TRUE THEN
                                ERROR(Text006)
                            ELSE
                                IF (CONFIRM(Text002, FALSE)) THEN
                                    BudgetReestimationInitialize.RUN(Rec);
                        END;


                    }
                    action("action29")
                    {
                        CaptionML = ENU = 'Copy from another budget', ESP = 'Copiar de otro presupuesto';
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
                    action("action30")
                    {
                        CaptionML = ENU = 'Copy Budget of a Job', ESP = 'Copiar ppto. de una obra';
                        Image = CopyLedgerToBudget;

                        trigger OnAction()
                        VAR
                            rJob: Record 167;
                        BEGIN
                            //JAV 11/04/19: - Nueva acci�n para copiar de otro presupuesto
                            CurrPage.Operations.PAGE.CopyBudgetOtherJob(rec."Cod. Budget", FALSE);
                        END;


                    }

                }
                group("group37")
                {
                    CaptionML = ENU = 'Prosfit Succesive Budget', ESP = 'Varios';
                    Image = Administration;
                    action("action31")
                    {
                        CaptionML = ESP = 'Copiar a un Preciario';
                        Image = ImportExport;

                        trigger OnAction()
                        VAR
                            // CopyJobBudgettoCostDB: Report 7207363;
                        BEGIN
                            // CLEAR(CopyJobBudgettoCostDB);
                            // CopyJobBudgettoCostDB.SetDatos('', rec."Job No.");
                            // CopyJobBudgettoCostDB.RUNMODAL;
                        END;


                    }
                    action("action32")
                    {
                        CaptionML = ESP = 'Regularizar indirectos';
                        Image = CalculateCost;

                        trigger OnAction()
                        VAR
                            QBPagePublisher: Codeunit 7207348;
                        BEGIN
                            //JAV 22/03/19: - Nueva acci�n para repartir los gastos generales
                            QBPageSubscriber.RegularizarGastosGenerales(Rec."Job No.");
                        END;


                    }
                    action("action33")
                    {
                        CaptionML = ESP = 'Volver a traer textos';
                        Image = Text;


                        trigger OnAction()
                        VAR
                            QBPagePublisher: Codeunit 7207348;
                        BEGIN
                            //JAV 22/03/19: - Nueva acci�n para cargar los textos desde el preciario de nuevo
                            QBPagePublisher.CopyTextToJob(Rec."Job No.");
                        END;


                    }

                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';

                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Procesar';

                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
                actionref(CloseMonth_Promoted; CloseMonth)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action18_Promoted; action18)
                {
                }
                actionref(action25_Promoted; action25)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informes';
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Calculate', ESP = 'C�lculos';

                actionref(action12_Promoted; action12)
                {
                }
                actionref(action14_Promoted; action14)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
                actionref(action15_Promoted; action15)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnOpenPage()
    BEGIN
        //JAV 29/01/20: - Si no hay ning�n presupuesto, creamos el inicial
        IF (Rec.COUNT = 0) THEN BEGIN
            //JAV 12/10/19: - Establezco el presupuesto inicial solo si hay uno de estudios
            Job.GET(rec."Job No.");
            IF (Job."Initial Budget Piecework" = '') THEN BEGIN
                QuoBuildingSetup.GET();
                CASE QuoBuildingSetup."Initial Budget" OF
                    QuoBuildingSetup."Initial Budget"::Job:
                        Job."Initial Budget Piecework" := QuoBuildingSetup."Initial Budget Code";
                    QuoBuildingSetup."Initial Budget"::Quote:
                        Job."Initial Budget Piecework" := QuoBuildingSetup."Quote Budget Code";
                END;
                Job.MODIFY;
            END;

            JobBudget.INIT;
            JobBudget."Job No." := rec."Job No.";
            JobBudget."Cod. Budget" := Job."Initial Budget Piecework";
            JobBudget."Budget Name" := Text001;
            JobBudget."Budget Date" := TODAY;
            JobBudget."Actual Budget" := TRUE;
            JobBudget."Budget Ref." := TRUE;
            JobBudget.INSERT(TRUE);
        END;

        //JMMA 270121 Job.GET("Job No.");
        IF Job.GET(rec."Job No.") THEN;
        JobDescription := '';
        IF Rec.GETFILTER("Job No.") <> '' THEN
            JobDescription := FunctionQB.ShowDescriptionJob(Rec.GETFILTER("Job No."));
        DataPieceworkForProduction.CALCFIELDS("Total Amount Cost Budget");
        //QBV102>>
        //CalculateTotalAmountCostBudget;
        //CalculateTotalAmountStudiedBudget;
        //DiffAmountCostbudgetBiddingBasesBudget;
        //DiffAmountCostBudgetAssignedAmount;
        //CurrPage.UPDATE;
        //QBV102<<

        //JAV 18/05/22: - QB 1.10.42 Ver todos los presupuestos o solo el actual
        See(FALSE);

        //JAV 30/05/19: - Calcular el total de las l�neas en una sola funci�n
        CalculateTotals;

        //JAV 30/05/19: - Posicionarse en el presupuesto mas nuevo siempre
        Rec.FINDLAST;

        //JAV 15/05/20: - El bot�n de agrupaciones ser� visible si se puede usar
        verAgrupaciones := (Job."Separation Job Unit/Cert. Unit");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //JAV 05/03/19: - La lista de unidades de obras no es editable si el presupuesto esta cerrado
        bEditable := (rec.Status = rec.Status::Open);
        //JAV --

        //JAV 30/05/19: - Calcular el total de las l�neas en una sola funci�n
        CalculateTotals;

        //JAV 30/01/10: - Marca de que el presupuesto debe actualizarce
        QBPageSubscriber.SetBudgetNeedRecalculate(rec."Pending Calculation Budget", rec."Pending Calculation Analitical", stCalculated1, stCalculated2, txtCalculated);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //QBV102>>
        //CalculateTotalAmountCostBudget;
        //CalculateTotalAmountStudiedBudget;
        //DiffAmountCostbudgetBiddingBasesBudget;
        //DiffAmountCostBudgetAssignedAmount;
        //QBV102<<

        //JAV 30/05/19: - Calcular el total de las l�neas en una sola funci�n
        CalculateTotals;
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
        stTarget: Text;
        useCurrencies: Boolean;
        verAgrupaciones: Boolean;
        Text008: TextConst ENU = 'The analytical budget will be calculated. do you wish to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        Text009: TextConst ENU = 'You are not planning to re-estimate this month, do you want to continue?', ESP = 'No est� previsto reestimar en este mes, �desea continuar?';
        Text010: TextConst ENU = 'The process has been Canceled by the user', ESP = 'El proceso ha sido Cancelado por el usuario';
        JobCurrencyExchangeFunction: Codeunit 7207332;

    procedure OpenBudgetxPiecework();
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."Job No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Cod. Budget");
        CLEAR(PieceworkData);
        //JAV 02/04/19: - Se elimina de la llamada a la page de costes directos el LOOKUPMODE
        //PieceworkData.LOOKUPMODE(TRUE); //JAV 26/03/19: - Se a�ade TRUE al LOOKUPMODE
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
        //CostUnitData.LOOKUPMODE(TRUE); //JAV 26/03/19: - Se a�ade TRUE al LOOKUPMODE
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
        //JAV 02/04/19: - Se elimina de la llamada a la page de inversi�n el LOOKUPMODE
        //DataInvestementUnit.LOOKUPMODE(TRUE); //JAV 26/03/19: - Se a�ade TRUE al LOOKUPMODE
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

    LOCAL procedure CalculateTotals();
    begin
        //JAV 30/05/19: - Calcular el total de las l�neas en una sola funci�n
        CalculateTotalAmountCostBudget;
        CalculateTotalAmountStudiedBudget;
        DiffAmountCostbudgetBiddingBasesBudget;
        DiffAmountCostBudgetAssignedAmount;

        //JAV 20/07/21: QB 1.09.11 Estilo para el objetivo
        Rec.CALCFIELDS("Target Amount");
        CASE TRUE OF
            (rec."Target Amount" > 0):
                stTarget := 'Favorable';
            (rec."Target Amount" = 0):
                stTarget := 'Subordinate';
            (rec."Target Amount" < 0):
                stTarget := 'Unfavorable';
        end;

        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure See(pAll: Boolean);
    begin
        //------------------------------------------------------------------------------------
        //JAV 18/05/22: - QB 1.10.42 Ver todos los presupuestos o solo el actual
        //------------------------------------------------------------------------------------

        //Poner el filtro de presupuesto actual
        if (not pAll) then begin
            if Job.GET(rec."Job No.") then
                if (Job."Current Piecework Budget" <> '') then begin
                    Rec.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                    exit;
                end;
        end;

        //Si los quiero ver todos o no he podido filtrar, quito el filtro
        Rec.SETRANGE("Cod. Budget")
    end;

    // begin
    /*{
      NZG 23/01/18: - QBV102 A�adidos Los totales de Amount Cost Budget y Amount Studied Budget y porcentajes
      JAV 05/03/19: - Si esta cerrado que no sea editable
                    - Se hace no editable el campo "TotalCost"
                    - La lista de unidades de obras no es editable si el presupuesto esta cerrado
      JAV 26/03/19: - Se pone imagen en el boton Utilidades presupuestos sucesivos
                    - Se a�aden los campos 21 "Budget Amount Cost Direct" y 22 "Budget Amount Cost Indirect"
                    - Se a�ade TRUE al LOOKUPMODE
      JAV 02/04/19: - Se deshace lo anterior, se elimina de la llamada a las Pages de costes directos, indirectos, inversiones y agrupaci�n de costes el modo LOOKUP que realmente deb�a estar a FALSE
      JAV 08/04/19: - Se cambia el caption del bot�n "&Utilidades Inicial" por "Utilidades"
                    - Se a�ade una acci�n para volver a traer los textos del preciario
      JAV 11/04/19: - Se remite el presupuesto actual al proceso de copiar de otro presupuesto
                    - Nueva acci�n para copiar de otro presupuesto
      PEL 02/05/19: - QCPM_GAP09 Nueva acci�n del cierre del mes
      JAV 30/05/19: - Calcular el total de las l�neas en una sola funci�n
                    - Posicionarse en el presupuesto mas nuevo siempre
      JAV 26/09/19: - Se ocultan las columnas de mediciones que no tienen mucho sentido real, solo se calculan en cada l�nea para saber el previsto y la desviaci�n
      JAV 05/10/19: - Se unifican las codeunit de test de unidades de obra y la forma de llamarlas
      JAV 11/10/19: - Se a�ade el campo 11 rec."Reestimation" que indica si el presupuesto se ha reestimado y el 12 rec."Origin" del presupuesto del que se ha copiado/reestimado
      JAV 29/01/20: - Si no hay ning�n presupuesto, creamos el inicial
      JAV 30/01/10: - Marca de que el presupuesto debe actualizarce
      Q13715 QMD 23/06/21 - Se a�ade campo �Cost in closed period�
    }*///end
}







