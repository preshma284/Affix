page 7207625 "Offer Budget List"
{
    Permissions = TableData 480 = rimd;
    CaptionML = ENU = 'Offer Budget List', ESP = 'Lista presupuestos oferta';
    DeleteAllowed = false;
    SourceTable = 167;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("JobDescription"; "JobDescription")
            {

                CaptionClass = JobDescription;
                Editable = FALSE;
                Style = Standard;
                StyleExpr = TRUE;
            }
            part("Operaciones"; 7207626)
            {

                CaptionML = ESP = 'Unidades de Obra';
                SubPageLink = "Job No." = FIELD("No."), "Budget Filter" = CONST('');
            }
            part("part2"; 7207490)
            {
                SubPageLink = "No." = FIELD("No.");
            }
        }
        area(FactBoxes)
        {
            part("part3"; 7207490)
            {
                SubPageLink = "No." = FIELD("No.");
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
                    CaptionML = ENU = 'B&udgets by Direct Costs', ESP = 'P&resupuestos por Costes Directos';
                    Image = CopyToTask;

                    trigger OnAction()
                    VAR
                        LZZ: Integer;
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        OpenBudgetByPiecework;

                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."No.");
                        CLEAR(JobBudget);
                        IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Bu&dgets by Indirect Costs', ESP = 'Pr&esupuestos por Costes Indirectos';
                    Image = CreateInteraction;

                    trigger OnAction()
                    VAR
                        LZZ: Integer;
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        OpenBudgetByPieceworkCost;

                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."No.");
                        CLEAR(JobBudget);
                        IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Bu&dgets by Inversions', ESP = 'Pr&esupuestos por Inversiones';
                    Image = InsertTravelFee;

                    trigger OnAction()
                    VAR
                        LZZ: Integer;
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        OpenBudgetByPieworkInver;

                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."No.");
                        CLEAR(JobBudget);
                        IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }

            }
            group("group6")
            {
                CaptionML = ENU = '&Actions', ESP = 'C�lculos';
                action("<Action1100251021>")
                {

                    CaptionML = ENU = 'Test', ESP = 'Test';
                    Image = TaskList;

                    trigger OnAction()
                    VAR
                        CostPieceworkJobIdent: Codeunit 7207296;
                    BEGIN
                        //JAV 06/10/19: - Se cambia la llamada al test
                        CLEAR(CostPieceworkJobIdent);
                        CostPieceworkJobIdent.Process(rec."No.", '', 1);
                    END;


                }
                action("<Action1100251007>")
                {

                    CaptionML = ENU = 'Calculate Budget Revision', ESP = 'Calcular revisi�n presupuesto';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."No.");
                        CLEAR(JobBudget);
                        IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }
                action("<Action1100251009>")
                {

                    CaptionML = ENU = '"Calculate Analytic Budget "', ESP = 'Calcular ppto. anal�tico';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        ConvertToBudgetxCA: Codeunit 7207282;
                        DataPieceworkForProduction: Record 7207386;
                        boolesversion: Boolean;
                    BEGIN
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."No.");
                            DataPieceworkForProduction.SETRANGE("Budget Filter", '');
                            IF DataPieceworkForProduction.FIND('-') THEN BEGIN
                                CLEAR(ConvertToBudgetxCA);
                                ConvertToBudgetxCA.PassBudget('');
                                //JMMA Corregir llamada par dimensi�n de oferta ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction,boolesversion,"No.");
                                boolesversion := TRUE;
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, boolesversion, rec."No.");
                                MESSAGE(Text005);
                            END;
                        END;
                    END;


                }

            }
            group("<Action1100251000>")
            {

                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("<Action1100251001>")
                {

                    CaptionML = ENU = 'Subcontractings &Planification', ESP = 'Planificaci�n &subcontrataciones';
                    Image = CalculateLines;

                    trigger OnAction()
                    VAR
                        LZZ: Integer;
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        PlanningSubcontracts;

                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."No.");
                        CLEAR(JobBudget);
                        IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'Import Budget from Excel', ESP = 'Importar ppto. desde Excel';
                    Image = Import;

                    trigger OnAction()
                    VAR
                        // ImportBudgetExcel: Report 7207376;
                        LZZ: Integer;
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job: Record 167;
                        JobBudget: Record 7207407;
                    BEGIN
                        // ImportBudgetExcel.ReceiveParameters(rec."No.", '');
                        // ImportBudgetExcel.RUNMODAL;
                        // CLEAR(ImportBudgetExcel);

                        CLEAR(RateBudgetsbyPiecework);
                        Job.GET(rec."No.");
                        CLEAR(JobBudget);
                        IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget);
                            JobBudget."Job No." := Job."No.";
                            JobBudget."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                    END;


                }
                action("<Action1100251026>")
                {

                    CaptionML = ENU = 'Asign Certification', ESP = 'Asignar Certificaci�n';
                    Image = LotInfo;

                    trigger OnAction()
                    BEGIN
                        AsigCertif;
                    END;


                }
                action("<Action1100251027>")
                {

                    CaptionML = ENU = 'Create Certification Budget (Not Preparation)', ESP = 'Crear ppto. de certificaci�n (sin separaci�n)';
                    Image = ChangePaymentTolerance;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETCURRENTKEY("Job No.", "Piecework Code");
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."No.");
                        // IF DataPieceworkForProduction.FIND('-') THEN
                            // REPORT.RUN(REPORT::"Create Budget Cert. Piecework", TRUE, TRUE, DataPieceworkForProduction);
                    END;


                }

            }
            group("<Action1100251099>")
            {

                CaptionML = ENU = '&Initial Utilities', ESP = '&Utilidades';
                group("<Action1100251011>")
                {

                    CaptionML = ENU = 'Initial Budget Utilities', ESP = 'Utilidades presupuesto inicial';
                    Image = ProjectToolsProjectMaintenance;
                    action("action11")
                    {
                        CaptionML = ENU = 'Copy Job Budget', ESP = 'Copiar ppto de una obra';
                        Image = CopyLedgerToBudget;

                        trigger OnAction()
                        BEGIN
                            CurrPage.Operaciones.PAGE.CopyBudgetOtherJob;
                        END;


                    }
                    action("action12")
                    {
                        CaptionML = ENU = 'Get Cost Database', ESP = 'Traer preciario';
                        Image = JobPrice;

                        trigger OnAction()
                        VAR
                            RateBudgetsbyPiecework: Codeunit 7207329;
                            Job: Record 167;
                            JobBudget: Record 7207407;
                        BEGIN
                            CurrPage.Operaciones.PAGE.GetCostDatabase;

                            CLEAR(RateBudgetsbyPiecework);
                            Job.GET(rec."No.");
                            CLEAR(JobBudget);
                            IF NOT JobBudget.GET(rec."No.", '') THEN BEGIN
                                CLEAR(JobBudget);
                                JobBudget."Job No." := Job."No.";
                                JobBudget."Cod. Budget" := '';
                            END;
                            RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
                        END;


                    }
                    action("<Action1100251014>")
                    {

                        CaptionML = ENU = 'Copy Piecework and Bill of Item', ESP = 'Copiar UO y descompuesto';
                        Image = Splitlines;

                        trigger OnAction()
                        BEGIN
                            CurrPage.Operaciones.PAGE.CopyPieceworkBillOfItem;
                        END;


                    }

                }
                action("action14")
                {
                    CaptionML = ESP = 'Volver a traer textos';
                    Image = Text;

                    trigger OnAction()
                    VAR
                        QBPagePublisher: Codeunit 7207348;
                    BEGIN
                        //JAV 22/03/19: - Nueva acci�n para cancelar una medici�n registrada
                        QBPagePublisher.CopyTextToJob(rec."No.");
                    END;


                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = '1', ESP = '1';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Budgets', ESP = 'Presupuestos';

                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = '3', ESP = '3';
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Calcs', ESP = 'C�lculos';

                actionref("<Action1100251021>_Promoted"; "<Action1100251021>")
                {
                }
                actionref("<Action1100251007>_Promoted"; "<Action1100251007>")
                {
                }
                actionref("<Action1100251009>_Promoted"; "<Action1100251009>")
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Utils', ESP = 'Varios';

                actionref("<Action1100251001>_Promoted"; "<Action1100251001>")
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        JobDescription := '';
        JobDescription := FunctionQB.ShowDescriptionJob(rec."No.")
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        JobDescription: Text[250];
        FunctionQB: Codeunit 7207272;
        PieceworkDataQuote: Page 7207637;
        CostUnitDataQuote: Page 7207638;
        DataInvestementUnit: Page 7207599;
        Text005: TextConst ENU = 'Process is finished', ESP = 'El proceso ha terminado';
        Text008: TextConst ENU = 'The analytic budget will be calculated. Do you want continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        CertificationAssigned: Page 7207591;

    procedure OpenBudgetByPiecework();
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE("Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", '');
        CLEAR(PieceworkDataQuote);
        //PieceworkDataQuote.LOOKUPMODE;
        PieceworkDataQuote.SETTABLEVIEW(DataPieceworkForProduction);
        PieceworkDataQuote.ReceivedJob(rec."No.", '');
        if DataPieceworkForProduction.FINDFIRST then
            PieceworkDataQuote.SETRECORD(DataPieceworkForProduction);

        //PER 28/08/19 Se envian los datos del proyecto a la p�gina del presupuesto
        CostUnitDataQuote.ReceivesJob(rec."No.", '');
        //FIN PER 28/08/19

        if PieceworkDataQuote.RUNMODAL = ACTION::LookupOK then;
    end;

    procedure OpenBudgetByPieceworkCost();
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", '');
        CLEAR(CostUnitDataQuote);
        //CostUnitDataQuote.LOOKUPMODE;
        CostUnitDataQuote.SETTABLEVIEW(DataPieceworkForProduction);
        CostUnitDataQuote.ReceivesJob(rec."No.", '');
        if DataPieceworkForProduction.FINDFIRST then
            CostUnitDataQuote.SETRECORD(DataPieceworkForProduction);
        if CostUnitDataQuote.RUNMODAL = ACTION::LookupOK then;
    end;

    procedure PlanningSubcontracts();
    var
        ActivityQB: Record 7207280;
        ActivitiesforSubcontract: Page 7207606;
    begin
        ActivitiesforSubcontract.PassCurrentBudgetCode('', rec."No.");
        ActivityQB.SETRANGE("Budget Filter", rec."No.");
        ActivityQB.SETRANGE("Budget Filter", '');
        ActivitiesforSubcontract.SETTABLEVIEW(ActivityQB);
        ActivitiesforSubcontract.RUNMODAL;
    end;

    procedure OpenBudgetByPieworkInver();
    begin
        CLEAR(DataInvestementUnit);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", '');
        CLEAR(DataInvestementUnit);
        //DataInvestementUnit.LOOKUPMODE;
        DataInvestementUnit.SETTABLEVIEW(DataPieceworkForProduction);
        DataInvestementUnit.ReceiveJob(rec."No.", '');
        if DataPieceworkForProduction.FINDFIRST then
            DataInvestementUnit.SETRECORD(DataPieceworkForProduction);
        if DataInvestementUnit.RUNMODAL = ACTION::LookupOK then;
    end;

    procedure AsigCertif();
    var
        RateBudgetsbyPiecework: Codeunit 7207329;
        Job: Record 167;
        JobBudget: Record 7207407;
    begin
        CLEAR(CertificationAssigned);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        DataPieceworkForProduction.SETRANGE("Budget Filter", '');
        CLEAR(CertificationAssigned);
        //CertificationAssigned.LOOKUPMODE;
        CertificationAssigned.SETTABLEVIEW(DataPieceworkForProduction);
        CertificationAssigned.ReceivesJob(rec."No.");
        if DataPieceworkForProduction.FINDFIRST then
            CertificationAssigned.SETRECORD(DataPieceworkForProduction);
        if CertificationAssigned.RUNMODAL = ACTION::LookupOK then;

        CLEAR(RateBudgetsbyPiecework);
        Job.GET(rec."No.");
        CLEAR(JobBudget);
        if not JobBudget.GET(rec."No.", '') then begin
            CLEAR(JobBudget);
            JobBudget."Job No." := Job."No.";
            JobBudget."Cod. Budget" := '';
        end;
        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget);
    end;

    // begin
    /*{
      PGM 08/01/18: - QBA5412 A�adida nueva accion "Presupuesto C.D. - Mediciones" y nueva funci�n para abrir la page al darle a la nueva acci�n.
      JAV 08/04/19: - Se cambia el caption del bot�n "&Utilidades Inicial" por "Utilidades", se a�ade el icono a la acci�n "Utilidades presupuesto inicial"
                    - Se a�ade una acci�n para volver a traer los textos del preciario
      JAV 08/05/19: - Se elimina la llamada a la page propia de Vesta y se pone el manejo general configurable
      PER 28/08/19: - Se envian los datos del proyecto a la p�gina del presupuesto
      JAV 06/10/19: - Se cambia la llamada al test
      JAV 22/02/20: - Se elimina la funci�n "OpenBudgetByPieceworkMeasure" pues no se utiliza
    }*///end
}







