page 7207363 "Versions Quote Card"
{
    CaptionML = ENU = 'Versions Quote Card', ESP = 'Ficha oferta versiones';
    InsertAllowed = false;
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    WHERE("Card Type" = CONST("Estudio"), "Original Quote Code" = FILTER(<> ''));
    PageType = Card;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                Editable = InternalStatusEditable;
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
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    Editable = FALSE;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        BilltoCustomerNoOnAfterValidat;
                    END;


                }
                group("group62")
                {

                    CaptionML = ENU = 'Customer', ESP = 'Direcci�n';
                    field("Bill-to Name"; rec."Bill-to Name")
                    {

                        Editable = FALSE;
                    }
                    field("Bill-to Address"; rec."Bill-to Address")
                    {

                        Editable = FALSE;
                    }
                    field("Bill-to Address 2"; rec."Bill-to Address 2")
                    {

                        Editable = FALSE;
                    }
                    field("Bill-to Post Code"; rec."Bill-to Post Code")
                    {

                        Editable = FALSE;
                    }
                    field("Bill-to City"; rec."Bill-to City")
                    {

                        Editable = FALSE;
                    }
                    field("Bill-to County"; rec."Bill-to County")
                    {

                        Editable = FALSE;
                    }

                }
                group("group69")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Contacto';
                    field("Bill-to Contact No."; rec."Bill-to Contact No.")
                    {

                        CaptionML = ENU = 'Bill-to Contact No.', ESP = 'N� contacto';
                    }
                    field("Bill-to Contact"; rec."Bill-to Contact")
                    {

                        CaptionML = ENU = 'Bill-to Contact', ESP = 'A la atenci�n de';
                        Editable = FALSE;
                    }

                }
                field("Search Description"; rec."Search Description")
                {

                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Income Statement Responsible"; rec."Income Statement Responsible")
                {

                }
                field("Budget Status"; rec."Budget Status")
                {


                    ; trigger OnValidate()
                    BEGIN
                        //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
                        SetInternalStatus;
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        //JAV 06/08/19: - Se a�aden rec."Budget Status" no editable si est� bloqueado
                        //JAV 02/10/19: - Solo el que lo bloque� o el responsable de proyectos puede abrirlo

                        IF (NOT ChangeInternalStatus) THEN
                            ERROR(Text011)
                        ELSE BEGIN
                            CASE rec."Budget Status" OF
                                rec."Budget Status"::Open:
                                    Rec.VALIDATE(rec."Budget Status", rec."Budget Status"::Blocked);
                                rec."Budget Status"::Blocked:
                                    BEGIN
                                        IF (USERID <> rec."Blocked By") THEN BEGIN
                                            UserSetup.GET(USERID);
                                            IF (NOT UserSetup."View all Jobs") THEN
                                                ERROR(Text012);
                                        END;
                                        Rec.VALIDATE(rec."Budget Status", rec."Budget Status"::Open);
                                    END;
                            END;
                            //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
                            SetInternalStatus;
                        END;
                    END;


                }
                field("Blocked By"; rec."Blocked By")
                {

                }
                field("Canceled"; rec."Canceled")
                {

                }
                field("% Margin"; rec."% Margin")
                {

                }
                grid("group79")
                {

                    GridLayout = Rows;
                    group("group80")
                    {

                        CaptionML = ESP = 'Preciario Directos Cargado';
                        field("Import Cost Database Direct"; rec."Import Cost Database Direct")
                        {

                            ShowCaption = false;
                        }
                        field("Import Cost Database Dir. Date"; rec."Import Cost Database Dir. Date")
                        {

                            ShowCaption = false;
                        }

                    }
                    group("group83")
                    {

                        CaptionML = ESP = 'Preciario Indirectos Cargado';
                        field("Import Cost Database Indirect"; rec."Import Cost Database Indirect")
                        {

                            ShowCaption = false;
                        }
                        field("Import Cost Database Ind. Date"; rec."Import Cost Database Ind. Date")
                        {

                            ShowCaption = false;
                        }

                    }

                }
                field("Copy of Version"; rec."Copy of Version")
                {

                }
                field("Category Code"; rec."Category Code")
                {

                }
                field("Situation Code"; rec."Situation Code")
                {

                }
                field("Approval Status"; rec."Approval Status")
                {

                }
                group("group90")
                {

                    CaptionML = ESP = 'Aprobaci�n';
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
            group("group95")
            {

                CaptionML = ENU = 'Posting', ESP = 'Estado';
                Editable = InternalStatusEditable;
                field("Internal Status"; rec."Internal Status")
                {


                    ; trigger OnValidate()
                    BEGIN
                        //JAV 13/06/19: - Se llama a la funci�n de establecer en editable el estado
                        //Solo si puede cambiarlo
                        IF (rec."Internal Status" <> xRec."Internal Status") THEN BEGIN
                            IF (InternalsStatus.GET(rec."Card Type", xRec."Internal Status")) THEN BEGIN
                                IF (InternalsStatus.IfInternalStatusEditable(rec."Card Type")) THEN
                                    InternalStatusEditable := InternalsStatus.GetInternalStatusEditable(rec."Card Type", rec."Internal Status")
                                ELSE
                                    ERROR('');
                            END;
                        END;

                        //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
                        SetInternalStatus;
                    END;

                    trigger OnAssistEdit()
                    VAR
                        Changestatus: Page 7206927;
                    BEGIN
                        IF (ChangeInternalStatus) THEN BEGIN
                            CLEAR(Changestatus);
                            Changestatus.SetStatus(rec."Card Type", rec."Internal Status");
                            Changestatus.LOOKUPMODE(TRUE);
                            IF (Changestatus.RUNMODAL = ACTION::LookupOK) THEN
                                Rec.VALIDATE(rec."Internal Status", Changestatus.GetStatus);

                            //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
                            SetInternalStatus;
                        END;
                    END;


                }
                field("Sent Date"; rec."Sent Date")
                {

                    Editable = editFechaEnvio;
                }
                group("group98")
                {

                    CaptionML = ENU = 'Posting', ESP = 'Fechas';
                    field("Date 1"; rec."Date 1")
                    {

                        CaptionClass = txtFecha1;
                        Visible = verFecha1;
                        Editable = editFecha1;
                    }
                    field("Date 2"; rec."Date 2")
                    {

                        CaptionClass = txtFecha2;
                        Visible = verFecha2;
                        Editable = editFecha2;
                    }
                    field("Date 3"; rec."Date 3")
                    {

                        CaptionClass = txtFecha3;
                        Visible = verFecha3;
                        Editable = editFecha3;
                    }
                    field("Date 4"; rec."Date 4")
                    {

                        CaptionClass = txtFecha4;
                        Visible = verFecha4;
                        Editable = editFecha4;
                    }
                    field("Date 5"; rec."Date 5")
                    {

                        CaptionClass = txtFecha5;
                        Visible = verFecha5;
                        Editable = editFecha5;
                    }

                }
                group("group104")
                {

                    CaptionML = ENU = 'Posting', ESP = 'Fechas Edici�n';
                    field("Creation Date"; rec."Creation Date")
                    {

                    }
                    field("Last Date Modified"; rec."Last Date Modified")
                    {

                    }
                    field("txtCalculated"; txtCalculated)
                    {

                        CaptionML = ESP = 'Importes';
                        Editable = false;
                        StyleExpr = stCalculated1;
                    }

                }

            }
            group("group108")
            {

                CaptionML = ENU = 'Bidding', ESP = 'Divisas';
                Visible = useCurrencies;
                Editable = InternalStatusEditable;
                field("Currency Code"; rec."Currency Code")
                {

                    CaptionML = ENU = 'Currency Code', ESP = 'Divisa contrato';
                    Visible = useCurrencies;
                    Editable = edCurrencies;
                }
                field("Aditional Currency"; rec."Aditional Currency")
                {

                    CaptionML = ENU = 'Aditional Currency', ESP = 'Divisa reporting';
                    Visible = useCurrencies;
                    Editable = edCurrencies;
                }
                field("General Currencies"; rec."General Currencies")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Currency Value Date"; rec."Currency Value Date")
                {

                    Visible = useCurrencies;
                    Editable = FALSE;
                }

            }
            group("group113")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                Editable = InternalStatusEditable;
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Original Quote Code"; rec."Original Quote Code")
                {

                    Editable = FALSE;
                }
                field("Offert Price"; rec."Offert Price")
                {

                }
                field("Quote Type"; rec."Quote Type")
                {

                }
                field("Management By Production Unit"; rec."Management By Production Unit")
                {

                }
                field("Separation Job Unit/Cert. Unit"; rec."Separation Job Unit/Cert. Unit")
                {

                }
                field("Invoicing Type"; rec."Invoicing Type")
                {

                }
                field("Job Posting Group"; rec."Job Posting Group")
                {

                    Visible = FALSE;
                }

            }
            group("group122")
            {

                CaptionML = ENU = 'Period', ESP = 'Plazos';
                Editable = InternalStatusEditable;
                field("Starting Date"; rec."Starting Date")
                {

                }
                field("Ending Date"; rec."Ending Date")
                {

                }
                field("Validate Quote"; rec."Validate Quote")
                {

                }

            }
            group("group126")
            {

                CaptionML = ENU = 'Calculations', ESP = 'C�lculos';
                Editable = InternalStatusEditable;
                field("Use Unit Price Ratio"; rec."Use Unit Price Ratio")
                {

                    Visible = FALSE;
                }
                group("group128")
                {

                    CaptionML = ENU = 'Equipament Cost Parameters', ESP = 'Par�metros coste maquinar�a';
                    Visible = FALSE;
                    field("% Residual Value"; rec."% Residual Value")
                    {

                        Visible = FALSE;
                    }
                    field("% Interests"; rec."% Interests")
                    {

                        Visible = FALSE;
                    }
                    field("% Repairs and Spare Parts"; rec."% Repairs and Spare Parts")
                    {

                        Visible = FALSE;
                    }
                    field("Unitary Cost Naphta"; rec."Unitary Cost Naphta")
                    {

                        Visible = FALSE;
                    }
                    field("Unitary Cost Diesel"; rec."Unitary Cost Diesel")
                    {

                        Visible = FALSE;
                    }
                    field("% Grease"; rec."% Grease")
                    {

                        Visible = FALSE;
                    }

                }
                group("group135")
                {

                    CaptionML = ENU = 'Sale Calculate Parameters', ESP = 'Par�metros c�lculo venta';
                    field("% Unforeseen"; rec."% Unforeseen")
                    {

                        Visible = FALSE;
                    }
                    field("% Finance Expenses"; rec."% Finance Expenses")
                    {

                        Visible = FALSE;
                    }
                    field("% Material Benefits"; rec."% Material Benefits")
                    {

                        Visible = FALSE;
                    }
                    field("% Workforce Benefits"; rec."% Workforce Benefits")
                    {

                        Visible = FALSE;
                    }
                    field("% Equipament Benefits"; rec."% Equipament Benefits")
                    {

                        Visible = FALSE;
                    }
                    field("% Subcontrating Benefits"; rec."% Subcontrating Benefits")
                    {

                        Visible = FALSE;
                    }
                    field("% Other Benefits"; rec."% Other Benefits")
                    {

                        Visible = FALSE;
                    }
                    field("VAT Prod. PostingGroup"; rec."VAT Prod. PostingGroup")
                    {

                    }
                    field("General Expenses / Other"; rec."General Expenses / Other")
                    {

                    }
                    field("Industrial Benefit"; rec."Industrial Benefit")
                    {

                    }
                    field("Low Coefficient"; rec."Low Coefficient")
                    {

                    }
                    field("Quality Deduction"; rec."Quality Deduction")
                    {

                    }
                    field("Planned K"; rec."Planned K")
                    {

                    }

                }

            }

        }
        area(FactBoxes)
        {
            part("DropArea"; 7174655)
            {

                Visible = seeDragDrop;
            }
            part("FilesSP"; 7174656)
            {

                Visible = seeDragDrop;
            }
            part("FB_JobOffersStatis"; 7207490)
            {
                SubPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                Visible = TRUE;
            }
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
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Version', ESP = '&Version';
                action("action1")
                {
                    CaptionML = ENU = 'Quote State-Owned', ESP = 'Impresi�n presupuesto de venta';
                    Image = PrintReport;

                    trigger OnAction()
                    VAR
                        VersionSelected: Record 167;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(VersionSelected);
                        //JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
                        QBReportSelections.Print(QBReportSelections.Usage::Q1, VersionSelected);
                        //REPORT.RUNMODAL(REPORT::"Print Quote Public Offer",TRUE,FALSE,VersionSelected);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207370;
                    RunPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                    Image = Statistics;
                }
                action("action4")
                {
                    CaptionML = ENU = 'Estimated Sale Price', ESP = 'Precio venta estimado';
                }
                action("action5")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                    Image = Dimensions;
                }
                action("action6")
                {
                    CaptionML = ENU = 'Improvements Sheet', ESP = 'Mejoras pliego';
                    RunObject = Page 7207386;
                    RunPageLink = "Version Code" = FIELD("No.");
                    Image = Components;
                }

            }
            group("group9")
            {
                CaptionML = ENU = 'Job Currency', ESP = 'Divisas Proyecto';
                Visible = useCurrencies;
                action("JobCurrencyExchanges")
                {

                    CaptionML = ENU = 'Job Currency Exchanges', ESP = 'Cambios de divisa';
                    Visible = useCurrencies;
                    Enabled = canEditJobsCurrencies;
                    Image = CurrencyExchangeRates;

                    trigger OnAction()
                    VAR
                        QBJobCurrencyExchange: Record 7206917;
                        QBJobCurrencyExchanges: Page 7207667;
                    BEGIN
                        //GEN003-02
                        QBJobCurrencyExchange.RESET;
                        QBJobCurrencyExchange.SETRANGE("Job No.", rec."No.");
                        CLEAR(QBJobCurrencyExchanges);
                        QBJobCurrencyExchanges.SETTABLEVIEW(QBJobCurrencyExchange);
                        QBJobCurrencyExchanges.RUNMODAL;
                        CurrPage.UPDATE;
                    END;


                }
                action("ChangeFactboxCurrency")
                {

                    CaptionML = ENU = 'Change Factbox Currency', ESP = 'Cambiar divisa factboxs';
                    Visible = useCurrencies;
                    Enabled = canChangeFactboxCurrency;
                    Image = Change;

                    trigger OnAction()
                    VAR
                        Salir: Boolean;
                    BEGIN
                        //Q7539 -
                        Salir := FALSE;
                        REPEAT
                            ShowCurrency := (ShowCurrency + 1) MOD 3;
                            CASE ShowCurrency OF
                                0:
                                    Salir := TRUE;
                                1:
                                    Salir := (rec."Currency Code" <> '');
                                2:
                                    Salir := (rec."Aditional Currency" <> '');
                            END;
                        UNTIL (Salir);
                        SetCurrencyFB;
                    END;


                }

            }
            group("group12")
            {
                CaptionML = ENU = 'Pur&chase', ESP = '&Compras';
                action("action9")
                {
                    CaptionML = ENU = 'Purchasing Needs', ESP = '&Necesidades de compras';
                    Image = Components;

                    trigger OnAction()
                    VAR
                        PurchaseJournalLine: Page 7207353;
                    BEGIN
                        CLEAR(PurchaseJournalLine);
                        PurchaseJournalLine.PassJob(rec."No.");
                        PurchaseJournalLine.RUNMODAL;
                    END;


                }
                action("action10")
                {
                    CaptionML = ENU = '&Comparative', ESP = '&Comparativos';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        ComparativeQuoteHeader: Record 7207412;
                    BEGIN
                        ComparativeQuoteHeader.RESET;
                        ComparativeQuoteHeader.FILTERGROUP(2);
                        ComparativeQuoteHeader.SETRANGE("Job No.", rec."No.");
                        ComparativeQuoteHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Comparative Quote List", ComparativeQuoteHeader);
                    END;


                }

            }
            group("group15")
            {
                CaptionML = ENU = 'Budget', ESP = 'P&resupuestos';
                action("action11")
                {
                    CaptionML = ENU = 'Job Budget', ESP = 'Presupuesto de coste';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        Job1: Record 167;
                        OfferBudgetList: Page 7207625;
                    BEGIN
                        //-QCPM_GAP04
                        Rec.TESTFIELD("Blocked Quote Version", FALSE);
                        //+QCPM_GAP04

                        IF rec."Management By Production Unit" <> TRUE THEN
                            ERROR(Text001)
                        ELSE BEGIN
                            CLEAR(OfferBudgetList);
                            Job1.FILTERGROUP(2);
                            Job1.SETRANGE("No.", rec."No.");
                            Job1.GET(rec."No.");
                            Job1.FILTERGROUP(0);
                            OfferBudgetList.SETTABLEVIEW(Job1);
                            OfferBudgetList.SETRECORD(Job1);
                            OfferBudgetList.RUNMODAL;
                        END
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'Certification Piecework', ESP = 'Presupuesto de venta';
                    RunObject = Page 7207601;
                    RunPageView = SORTING("Job No.", "Piecework Code");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = LedgerBudget;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Calculte Budget Review', ESP = 'Calcular revisi�n presupuesto';
                    Image = Calculate;

                    trigger OnAction()
                    VAR
                        RateBudgetsbyPiecework: Codeunit 7207329;
                        Job1: Record 167;
                        JobBudget1: Record 7207407;
                    BEGIN
                        CLEAR(RateBudgetsbyPiecework);
                        Job1.GET(rec."No.");
                        IF NOT JobBudget1.GET(rec."No.", '') THEN BEGIN
                            CLEAR(JobBudget1);
                            JobBudget1."Job No." := Job1."No.";
                            JobBudget1."Cod. Budget" := '';
                        END;
                        RateBudgetsbyPiecework.ValueInitialization(Job1, JobBudget1);
                    END;


                }
                action("action14")
                {
                    CaptionML = ENU = 'Calculate Analytical Budget', ESP = 'Calcular ppto anal�tico';
                    Image = Reconcile;

                    trigger OnAction()
                    BEGIN
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            //JAV 11/04/19: - No se debe usar Status sino "Card Type" para diferenciar estudio y proyecto
                            //IF ("Job Type" = "Job Type"::Operative) AND
                            //   (Status = Status::Planning) AND ("Original Quote Code" <> '') THEN
                            IF (rec."Card Type" = rec."Card Type"::Estudio) AND (rec."Original Quote Code" <> '') THEN
                                JobOVersión := TRUE
                            ELSE
                            JobOVersión := FALSE;
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."No.");
                            IF DataPieceworkForProduction.FIND('-') THEN BEGIN
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, JobOVersión, rec."No.");
                                MESSAGE(Text009);
                            END;
                        END;
                    END;


                }

            }
            group("group20")
            {
                CaptionML = ENU = 'Log', ESP = 'Log';
                // ActionContainerType =NewDocumentItems ;
                action("action15")
                {
                    CaptionML = ENU = 'Copy Job', ESP = 'Registro de cambios';
                    RunObject = Page 7207659;
                    RunPageLink = "Version" = FIELD("No.");
                    Image = Log;

                    trigger OnAction()
                    VAR
                        ConfigTemplateManagement: Codeunit 8612;
                        RecRef: RecordRef;
                    BEGIN
                    END;


                }
                action("action16")
                {
                    CaptionML = ENU = 'Budget by Concepts', ESP = 'Presupuesto por conceptos';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        DimOf: Code[20];
                        DimBudgetOf: Code[20];
                        DimJob: Boolean;
                    BEGIN
                        QBPageSubscriber.seeBudgetByCA(Rec, FALSE);
                    END;


                }

            }
            group("group23")
            {
                CaptionML = ENU = 'Budget', ESP = '***** OPCIONES OCULTAS *****';
                action("action17")
                {
                    CaptionML = ENU = 'Planning Milestone', ESP = 'H&itos de planificaci�n';
                    RunObject = Page 7207467;
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = PayrollStatistics;
                }
                action("action18")
                {
                    CaptionML = ESP = 'Planificaci�n &costes por hitos';
                    Visible = FALSE;
                    Image = Period;

                    trigger OnAction()
                    BEGIN
                        CLEAR(JobConceptPlan);
                        JobConceptPlan.SetJob(rec."No.");
                        JobConceptPlan.RUNMODAL;
                    END;


                }
                action("action19")
                {
                    CaptionML = ENU = 'Ass&ign Planning', ESP = 'As&ignar planificaci�n';
                    Visible = FALSE;
                    Image = ResourcePlanning;

                    trigger OnAction()
                    VAR
                        CodeunitModificManagement: Codeunit 7207273;
                    BEGIN
                        CLEAR(CodeunitModificManagement);
                        CodeunitModificManagement."PlannedJobMilestoneS/N"(Rec);
                    END;


                }
                separator("separator20")
                {

                }
                action("action21")
                {
                    CaptionML = ENU = 'Job Budget', ESP = 'Presupuesto de obra';
                    Visible = FALSE;
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        Job1: Record 167;
                        OfferBudgetList: Page 7207625;
                        JobCurrencyExchange: Record 7206917;
                        Error001: TextConst ENU = '%1 doesn''t exist fot Quote %2, Currency %3.', ESP = '%1 no existe para la Oferta %2, Divisa %3.';
                    BEGIN
                        //-GEN003-02
                        IF Rec."Currency Code" <> '' THEN BEGIN
                            JobCurrencyExchange.RESET;
                            JobCurrencyExchange.SETRANGE("Job No.", Rec."No.");
                            JobCurrencyExchange.SETRANGE("Currency Code", Rec."Currency Code");
                            IF NOT JobCurrencyExchange.FINDFIRST THEN
                                ERROR(Error001, JobCurrencyExchange.TABLECAPTION, Rec."No.", Rec."Currency Code");
                        END;

                        IF Rec."Aditional Currency" <> '' THEN BEGIN
                            JobCurrencyExchange.RESET;
                            JobCurrencyExchange.SETRANGE("Job No.", Rec."No.");
                            JobCurrencyExchange.SETRANGE("Currency Code", Rec."Aditional Currency");
                            IF NOT JobCurrencyExchange.FINDFIRST THEN
                                ERROR(Error001, JobCurrencyExchange.TABLECAPTION, Rec."No.", Rec."Aditional Currency");
                        END;
                        //+GEN003-02

                        IF (NOT rec."Management By Production Unit") THEN
                            ERROR(Text001)
                        ELSE BEGIN
                            CLEAR(OfferBudgetList);
                            Job1.FILTERGROUP(2);
                            Job1.SETRANGE("No.", rec."No.");
                            Job1.GET(rec."No.");
                            Job1.FILTERGROUP(0);
                            OfferBudgetList.SETTABLEVIEW(Job1);
                            OfferBudgetList.SETRECORD(Job1);
                            OfferBudgetList.RUNMODAL;
                        END
                    END;


                }
                action("action22")
                {
                    CaptionML = ENU = 'Budget by Direct Cost', ESP = 'Presupuesto por costes directos';
                    Visible = FALSE;
                    Image = Import;

                    trigger OnAction()
                    BEGIN
                        //-QCPM_GAP04
                        Rec.TESTFIELD("Blocked Quote Version", FALSE);
                        //+QCPM_GAP04

                        IF rec."Management By Production Unit" <> TRUE THEN
                            ERROR(Text001)
                        ELSE
                            OpenBudgetxUO;
                    END;


                }
                action("action23")
                {
                    CaptionML = ENU = 'Budget by Indirect Cost', ESP = 'Presupuesto por coste indirectos';
                    Visible = FALSE;
                    Image = Export;

                    trigger OnAction()
                    BEGIN
                        //-QCPM_GAP04
                        Rec.TESTFIELD("Blocked Quote Version", FALSE);
                        //+QCPM_GAP04

                        IF rec."Management By Production Unit" <> TRUE THEN
                            ERROR(Text001)
                        ELSE
                            OpenBudgetxUOcost;
                    END;


                }
                action("action24")
                {
                    CaptionML = ENU = 'Budget by Investments', ESP = 'Presupuesto por inversiones';
                    Visible = FALSE;
                    Image = InsertStartingFee;
                }
                action("action25")
                {
                    CaptionML = ENU = '&Subcontrating Planning', ESP = 'Planificaci�n &subcontrataciones';
                    Visible = FALSE;
                    Image = CalculateRemainingUsage;

                    trigger OnAction()
                    VAR
                        SubcontractingPlanification: Page 7207586;
                    BEGIN
                        CLEAR(SubcontractingPlanification);
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.FILTERGROUP(2);
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
                        DataPieceworkForProduction.FILTERGROUP(0);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Current Piecework Budget");
                        CLEAR(PieceworkData);
                        SubcontractingPlanification.LOOKUPMODE(TRUE);
                        SubcontractingPlanification.SETTABLEVIEW(DataPieceworkForProduction);
                        IF SubcontractingPlanification.RUNMODAL = ACTION::LookupOK THEN
                            CLEAR(SubcontractingPlanification);
                    END;


                }
                separator("separator26")
                {

                }
                action("action27")
                {
                    CaptionML = ENU = 'Job &Planning Line', ESP = 'L�neas &planificaci�n proyecto';
                    RunObject = Page 1007;
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = JobLines;
                }
                separator("separator28")
                {

                }
                action("action29")
                {
                    CaptionML = ENU = 'Determination Materials Unitary Cost', ESP = 'Determinaci�n coste unitario materiales';
                    RunObject = Page 7207634;
                    RunPageView = SORTING("Job No.", "Type", "No.");
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = ItemCosts;
                }
                action("action30")
                {
                    CaptionML = ENU = 'Determination Workforce Unitary Cost', ESP = 'Determinaci�n coste unitario mano de obra';
                    RunObject = Page 7207635;
                    RunPageView = SORTING("Job No.", "Type", "No.");
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = SettleOpenTransactions;
                }
                action("action31")
                {
                    CaptionML = ENU = 'Determination Equipament Unitary Cost', ESP = 'Determinaci�n coste unitario maquinar�a';
                    RunObject = Page 7207636;
                    RunPageView = SORTING("Job No.", "Type", "No.");
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = ResourceCosts;
                }
                separator("separator32")
                {

                }
                action("action33")
                {
                    CaptionML = ENU = 'Invoiced Milestone', ESP = 'Hitos facturaci�n';
                    Visible = FALSE;
                    Image = CalculateDepreciation;

                    trigger OnAction()
                    BEGIN
                        QBPageSubscriber.TJob_SeeMilestone(Rec);
                    END;


                }
                action("action34")
                {
                    CaptionML = ENU = 'Import Budget from Excel', ESP = 'Importar ppto. desde Excel';
                    Visible = FALSE;
                    Image = ImportExcel;

                    trigger OnAction()
                    VAR
                        // ImportBudgetExcel: Report 7207376;
                    BEGIN
                        // ImportBudgetExcel.ReceiveParameters(rec."No.", '');
                        // ImportBudgetExcel.RUNMODAL;
                        // CLEAR(ImportBudgetExcel);
                    END;


                }
                action("action35")
                {
                    CaptionML = ENU = '&Prices', ESP = '&Precios';
                    // RunObject = Page 204;
                    // RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = SalesPrices;
                }

            }

        }
        area(Processing)
        {

            group("group44")
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
                    BEGIN
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    END;


                }

            }
            group("group50")
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
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Proceso';

                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action21_Promoted; action21)
                {
                }
                actionref(action22_Promoted; action22)
                {
                }
                actionref(action33_Promoted; action33)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
                actionref(action14_Promoted; action14)
                {
                }
                actionref(action17_Promoted; action17)
                {
                }
                actionref(action18_Promoted; action18)
                {
                }
                actionref(action19_Promoted; action19)
                {
                }
                actionref(action23_Promoted; action23)
                {
                }
                actionref(action27_Promoted; action27)
                {
                }
                actionref(action35_Promoted; action35)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action1_Promoted; action1)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Status', ESP = 'Lanzar';

                actionref(action29_Promoted; action29)
                {
                }
                actionref(action30_Promoted; action30)
                {
                }
                actionref(action31_Promoted; action31)
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
                CaptionML = ENU = 'Currencies', ESP = 'Divisas';

                actionref(JobCurrencyExchanges_Promoted; JobCurrencyExchanges)
                {
                }
                actionref(ChangeFactboxCurrency_Promoted; ChangeFactboxCurrency)
                {
                }
            }
            group(Category_Category6)
            {
                CaptionML = ENU = 'Approvals', ESP = 'Solicitar Aprobaci�n';

                actionref(QB_WithHolding_Promoted; QB_WithHolding)
                {
                }
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
            group(Category_Category7)
            {
                CaptionML = ENU = 'Approve', ESP = 'Aprobar';

                actionref(Approve_Promoted; Approve)
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
    VAR
        DefaultDimension: Record 352;
        DimensionValue: Record 349;
        FunctionQB: Codeunit 7207272;
        QBTableSubscriber: Codeunit 7207347;
    BEGIN
        rec.FilterResponsability(Rec);

        //JAV 11/03/19: - Para evitar un problema con las dimensiones, las revisamos al abrir la p�gina
        //JAV 11/04/19: - Se usa No. para el valor de dimensi�n, evitamos problemas con los presupuestos
        IF NOT DefaultDimension.GET(DATABASE::Job, rec."No.", FunctionQB.ReturnDimQuote) THEN BEGIN
            DefaultDimension.INIT;
            DefaultDimension."Table ID" := DATABASE::Job;
            DefaultDimension."No." := rec."No.";
            DefaultDimension."Dimension Code" := FunctionQB.ReturnDimQuote;
            DefaultDimension."Dimension Value Code" := rec."No.";
            DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
            DefaultDimension.INSERT;
        END ELSE IF DefaultDimension."Dimension Value Code" <> rec."No." THEN BEGIN
            DefaultDimension."Dimension Value Code" := rec."No.";
            DefaultDimension.MODIFY;
        END;

        IF NOT DimensionValue.GET(FunctionQB.ReturnDimQuote, rec."No.") THEN BEGIN
            DimensionValue.INIT;
            DimensionValue."Dimension Code" := FunctionQB.ReturnDimQuote;
            DimensionValue.Code := rec."No.";
            DimensionValue.Name := rec.Description;
            DimensionValue.INSERT;
        END;

        //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
        SetInternalStatus;

        //JAV 08/04/20: - GEN003-02 Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF (seeDragDrop) THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);
        //Q7357 +
    END;

    trigger OnNextRecord(Steps: Integer): Integer
    BEGIN
        //QX7105 >>
        IF CheckContact THEN
            EXIT(Rec.NEXT(Steps));
        //QX7105 <<

        //JAV 13/06/19: - En uno nuevo siempre ser� editable
        InternalStatusEditable := TRUE;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        rec."Responsibility Center" := UserRespCenter;
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    BEGIN
        SetJobOriginalInternalStatus;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        SetJobOriginalInternalStatus;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        //QX7105 >>
        IF NOT CheckContact THEN
            ERROR('');
        //QX7105 <<
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        DimensionCodeBuffer: Record 367;
        GLBudgetName: Record 95;
        UserSetup: Record 91;
        InternalsStatus: Record 7207440;
        JobLedgerEntry: Record 169;
        FunctionQB: Codeunit 7207272;
        ConvertToBudgetxCA: Codeunit 7207282;
        QBPageSubscriber: Codeunit 7207349;
        PieceworkData: Page 7207506;
        BudgetbyCA: Page 7207279;
        JobTaskLines: Page 1002;
        CostUnitData: Page 7207535;
        DataInvestementUnit: Page 7207599;
        JobConceptPlan: Page 7207468;
        Descriptions: ARRAY[10] OF Text;
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
        BoolVersion: Boolean;
        JobOVersión: Boolean;
        Text001: TextConst ENU = 'Can''t create titles if isn''t active field "Management by Units Production"', ESP = 'No se puede usar esta opci�n si no est� activo el campo "Gesti�n por unidades de producci�n"';
        Text002: TextConst ENU = 'Can''t budget by item because field rec."Management By Production Unit" is active', ESP = 'No puede presupuestar por Item porque est� activo el campo "Gesti�n por unidades de producci�n"';
        Text004: TextConst ENU = 'Field Dpto. Code should have a value for you can budget by analitic concept', ESP = 'El campo C�d. Dpto debe de tener un valor para poder presupuestar por concepto anal�tico';
        Text005: TextConst ENU = '"Doesn''t exist value for the offer dimension in configuration of QuoBuilding for the dimension of offer budget "', ESP = '"No existe en conf. de QuoBuilding valor de dimensi�n de oferta para la dimensi�n de presupuesto de oferta "';
        Text008: TextConst ENU = 'Analytic budget be will calculate. Do you want to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        Text009: TextConst ENU = 'Process is finished', ESP = 'El proceso ha terminado.';
        InternalStatusEditable: Boolean;
        txtFecha1: Text;
        txtFecha2: Text;
        txtFecha3: Text;
        txtFecha4: Text;
        txtFecha5: Text;
        verFecha1: Boolean;
        verFecha2: Boolean;
        verFecha3: Boolean;
        verFecha4: Boolean;
        verFecha5: Boolean;
        editFecha1: Boolean;
        editFecha2: Boolean;
        editFecha3: Boolean;
        editFecha4: Boolean;
        editFecha5: Boolean;
        editFechaEnvio: Boolean;
        Text50001: TextConst ENU = '"Study contact No. field must have a value in Job: No.=%1. It can not be zero or be blank."', ESP = '"N� contacto estudio debe tener un valor en Proyecto: N�=%1. No puede ser cero ni estar vac�o."';
        ChangeInternalStatus: Boolean;
        Text011: TextConst ESP = 'La versi�n no es editable, no puede modificar este campo';
        Text012: TextConst ESP = 'Solo el que lo bloue� o el responsable de proyectos puede desbloquear la versi�n';
        txtCalculated: Text;
        stCalculated1: Text;
        stCalculated2: Text;
        seeDragDrop: Boolean;
        "--------------------------------------- Divisas": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        useCurrencies: Boolean;
        edCurrencies: Boolean;
        edCurrencyCode: Boolean;
        edInvoiceCurrencyCode: Boolean;
        canEditJobsCurrencies: Boolean;
        canChangeFactboxCurrency: Boolean;
        ShowCurrency: Integer;
        "---------------------------- Aprobaciones inicio": Integer;
        cuApproval: Codeunit 7206915;
        QBApprovalManagement: Codeunit 7207354;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;
        "---------------------------- Aprobaciones fin": Integer;

    procedure OpenBudgetxUO();
    begin
        CLEAR(CostUnitData);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        CLEAR(PieceworkData);
        PieceworkData.LOOKUPMODE(TRUE);
        PieceworkData.SETTABLEVIEW(DataPieceworkForProduction);
        PieceworkData.ReceivedJob(rec."No.", '');
        if DataPieceworkForProduction.FINDFIRST then
            PieceworkData.SETRECORD(DataPieceworkForProduction);

        if PieceworkData.RUNMODAL = ACTION::LookupOK then;
    end;

    procedure OpenBudgetxUOcost();
    begin
        CLEAR(CostUnitData);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        CLEAR(PieceworkData);
        CostUnitData.LOOKUPMODE(TRUE);
        CostUnitData.SETTABLEVIEW(DataPieceworkForProduction);
        CostUnitData.ReceivesJob(rec."No.", '');
        if DataPieceworkForProduction.FINDFIRST then
            CostUnitData.SETRECORD(DataPieceworkForProduction);

        if PieceworkData.RUNMODAL = ACTION::LookupOK then;
    end;

    procedure OpenBudgetxUOinvest();
    begin
        CLEAR(DataInvestementUnit);
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
        DataPieceworkForProduction.FILTERGROUP(0);
        CLEAR(CostUnitData);
        DataInvestementUnit.LOOKUPMODE(TRUE);
        DataInvestementUnit.SETTABLEVIEW(DataPieceworkForProduction);
        DataInvestementUnit.ReceiveJob(rec."No.", '');
        if DataPieceworkForProduction.FINDFIRST then
            DataInvestementUnit.SETRECORD(DataPieceworkForProduction);
        if DataInvestementUnit.RUNMODAL = ACTION::LookupOK then;
    end;

    LOCAL procedure BilltoCustomerNoOnAfterValidat();
    begin
        CurrPage.UPDATE;
    end;

    LOCAL procedure CheckContact(): Boolean;
    var
        Customer: Record 18;
    begin
        //QX7105 >>
        //JAV 05/08/19: - Se pasa el check del contacto a una funci�n
        if Customer.GET(rec."Bill-to Customer No.") then begin
            if (Customer."QB Generic Customer") and (rec."Bill-to Contact No." = '') then begin
                MESSAGE(Text50001, Rec."No.");
                CurrPage.UPDATE(FALSE);
                exit(FALSE);
            end;
        end;
        exit(TRUE);
        //QX7105 <<
    end;

    LOCAL procedure SetJobOriginalInternalStatus();
    begin
        if Job.GET(rec."Original Quote Code") then begin
            Job."Internal Status" := rec."Internal Status";
            Job."Sent Date" := rec."Sent Date";
            Job."Date 1" := rec."Date 1";
            Job."Date 2" := rec."Date 2";
            Job."Date 3" := rec."Date 3";
            Job."Date 4" := rec."Date 4";
            Job."Date 5" := rec."Date 5";
            Job.MODIFY;
        end;
    end;

    LOCAL procedure SetInternalStatus();
    var
        QBPagePublisher: Codeunit 7207348;
    begin
        //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n

        //JAV 08/08/19: - Se pasa a un evento el que sea editable
        QBPagePublisher.SetJobPageEditable(Rec, InternalStatusEditable, ChangeInternalStatus);

        //JAV 12/06/19: - Cambio para usar las 5 fechas auxiliares m�s la de env�o al cliente
        InternalsStatus.setDates(rec."Card Type", rec."Internal Status", InternalStatusEditable,
                                 txtFecha1, txtFecha2, txtFecha3, txtFecha4, txtFecha5,
                                 verFecha1, verFecha2, verFecha3, verFecha4, verFecha5,
                                 editFecha1, editFecha2, editFecha3, editFecha4, editFecha5, editFechaEnvio);
        //JAV 12/06/19 fin
    end;

    LOCAL procedure funOnAfterGetRecord();
    var
        JobVersion: Record 167;
        Resource: Record 156;
        JobClassification: Record 7207276;
        DirFacContact: Record 5050;
        QuoteType: Record 7207283;
        TAuxJobPhases: Record 7206914;
        ResponsibilityCenter: Record 5714;
        Opportunity: Record 5092;
        SalesPerson: Record 13;
        QBPageSubscriber: Codeunit 7207349;
    begin
        //JAV Leer tablas auxiliares
        CLEAR(Descriptions);
        if Resource.GET(rec."Person Responsible") then Descriptions[1] := Resource.Name;
        if SalesPerson.GET(rec."Income Statement Responsible") then Descriptions[2] := SalesPerson.Name;
        if JobClassification.GET(rec.Clasification) then Descriptions[3] := JobClassification.Description;
        if DirFacContact.GET(rec."Project Management") then Descriptions[4] := DirFacContact.Name;
        if QuoteType.GET(rec."Quote Type") then Descriptions[5] := QuoteType.Description;
        if TAuxJobPhases.GET(rec."Job Phases") then Descriptions[6] := TAuxJobPhases.Description;
        if ResponsibilityCenter.GET(rec."Responsibility Center") then Descriptions[7] := ResponsibilityCenter.Name;
        if Opportunity.GET(rec."Opportunity Code") then Descriptions[8] := Opportunity.Description;

        //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
        SetInternalStatus;

        //JAV 10/03/20: - Se llama a la funci�n para activar los controles de aprobaci�n
        cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);

        //Si se pueden ver las divisas del proyecto
        JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        //JAV 30/01/10: - Marca de que el presupuesto debe actualizarce
        QBPageSubscriber.SetBudgetNeedRecalculate(rec."Pending Calculation Budget", rec."Pending Calculation Analitical", stCalculated1, stCalculated2, txtCalculated);

        //+Q8636
        if (seeDragDrop) then begin
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        end;
        //-Q8636
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_JobOffersStatis.PAGE.SetCurrency(ShowCurrency);
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      PGM 12/11/18: - QB4973 A�adido campo "Card Type".
      JAV 11/03/19: - Para evitar un problema con las dimensiones, las revisamos al abrir la p�gina
                    - Se elimina el campo de tipo de ficha, es peligroso que lo pueda manejar el usuario
      JAV 18/03/19: - Se a�aden los campos del preciario importado
                    - Se a�ade TRUE a las accines LOOKUPMODE en las p�ginas en que faltaba
      JAV 11/04/19: - Se usa No. para el valor de dimensi�n, evitamos problemas con los presupuestos
                    - No se debe usar Status sino "Card Type" para diferenciar estudio y proyecto
      RSH 29/04/19: - QX7105 A�adir Study contact No. y Study contact para permitir usar contactos de un cliente gen�rico y codigo para obligar a informar el Study contact No. si el Bill-To es gen�rico.
      PEL 02/05/19: - QCPM_GAP04 Control modificaci�n
      JAV 26/05/19: - Se a�ade el bot�n de impresi�n del presupuesto de venta
      JAV 12/06/19: - Cambio para usar las 5 fechas auxiliares m�s la de env�o al cliente
      JAV 04/08/19: - Se agrupa en una funci�n el hacerlo editable
      JAV 05/08/19: - Clientes gen�ricos en contacto, campos visibles, se simplifican las funciones y se pasa el check del contacto a una funci�n
                    - Se usan los campos est�ndar de contacto en lugar de nuevos campos creados
      JAV 06/08/19: - Se permite o no cambiar el estado interno del proyecto seg�n estado y usuario
                    - Se a�aden los campos rec."Budget Status" y rec."Blocked By" no editable si est� bloqueado
                    - No editable si est� bloqueado o lo est� su padre
      JAV 08/08/19: - Se pasa a una funci�n en la tabla el que sea editable
      JDC 12/08/19: - KALAM GAP010 Added fields 50004 rec."Category Code" and 50006 rec."Situation Code"
      JAV 29/08/19: - Se eliminan las acciones duplicadas "Presupuesto de obra", "Calcular revisi�n presupuesto" y "Calcular ppto anal�tico"
      PGM 20/09/19: - GAP013 A�adida la subpage "Externals"
      JAV 02/10/19: - Se a�ade la acci�n para ver el log de cambios
                    - Se a�aden los campos de preciario de costes cargados nuevos y se eliminan los antiguos
      JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
      JAV 05/10/19: - Se hace no visible el campo rec."Use Unit Price Ratio" pues no se usa actualmente, y se reordenan las acciones para que salga igual que en otras partes
      JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
      JAV 22/02/20: - Se eliminan las subp�ginas e responsables y externos pues no tienen sentido en la versi�n
      JAV 13/03/20: - Se a�aden las aprobaciones de versiones del estudio
    }*///end
}







