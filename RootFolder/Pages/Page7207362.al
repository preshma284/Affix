page 7207362 "List of Quote Versions"
{
    Editable = false;
    CaptionML = ENU = 'List of Quote Versions', ESP = 'Lista de versiones de oferta';
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    WHERE("Card Type" = FILTER("Estudio"));
    PageType = List;
    CardPageID = "Versions Quote Card";

    layout
    {
        area(content)
        {
            field("Text001"; Text001)
            {

                Visible = IsLookupMode;
                Style = StrongAccent;
                StyleExpr = TRUE;
                ShowCaption = false;
            }
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    StyleExpr = stCalculated1;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = stCalculated2;
                }
                field("txtCalculated"; txtCalculated)
                {

                    CaptionML = ESP = 'Importes';
                    StyleExpr = stCalculated2;
                }
                field("Approval Status"; rec."Approval Status")
                {

                    StyleExpr = stCalculated2;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    StyleExpr = stCalculated2;
                }
                field("Starting Date"; rec."Starting Date")
                {

                    StyleExpr = stCalculated2;
                }
                field("Ending Date"; rec."Ending Date")
                {

                    StyleExpr = stCalculated2;
                }
                field("Internal Status"; rec."Internal Status")
                {

                    StyleExpr = stCalculated2;
                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    StyleExpr = stCalculated2;
                }
                field("Original Quote Code"; rec."Original Quote Code")
                {

                    StyleExpr = stCalculated1;
                }
                field("Copy of Version"; rec."Copy of Version")
                {

                    StyleExpr = stCalculated2;
                }
                field("TotalAmountCostBudget"; TotalAmountCostBudget)
                {

                    CaptionML = ENU = 'Total Amount Cost Budget', ESP = 'Total Importe coste presupuesto';
                    // Numeric = false;
                    Enabled = FALSE;
                    StyleExpr = stCalculated2;
                }
                field("TotalAmountStudiedBudget"; TotalAmountStudiedBudget)
                {

                    CaptionML = ENU = 'Total Amount Studied Budget', ESP = 'Total Importe estudiado presupuesto';
                    // Numeric = false;
                    Enabled = FALSE;
                    StyleExpr = stCalculated2;
                }
                field("DiffBiddingBasesBudget"; DiffBiddingBasesBudget)
                {

                    CaptionML = ENU = '% Diff Amount Cost Budget & Bidding Bases Budget', ESP = '% Diferencia Imp. coste Ppto. y Ppto. Base licitaci�n';
                    Enabled = FALSE;
                    StyleExpr = stCalculated2;
                }
                field("Amou Piecework Meas./Certifi."; rec."Amou Piecework Meas./Certifi.")
                {

                    CaptionML = ENU = 'Amou Piecework Meas./Certifi.', ESP = 'Total importe venta presupuesto';
                    StyleExpr = stCalculated2;
                }
                field("Canceled"; rec."Canceled")
                {

                    StyleExpr = stCalculated2;
                }
                field("Category Code"; rec."Category Code")
                {

                    StyleExpr = stCalculated2;
                }
                field("Category Description"; rec."Category Description")
                {

                    StyleExpr = stCalculated2;
                }
                field("Situation Code"; rec."Situation Code")
                {

                    StyleExpr = stCalculated2;
                }
                field("Situation Description"; rec."Situation Description")
                {

                    StyleExpr = stCalculated2;
                }

            }

        }
        area(FactBoxes)
        {
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

            group("Version")
            {

                CaptionML = ENU = '&Version', ESP = '&Versi�n';
                Visible = NotLookupMode;
                action("action1")
                {
                    CaptionML = ENU = 'Create Version', ESP = 'Crear versi�n';
                    Image = CopyFromTask;

                    trigger OnAction()
                    VAR
                        // GenerateQuotes: Report 7207292;
                        VersionsQuoteCard: Page 7207363;
                    BEGIN
                        //JAV 11/04/19: - Se a�ade la acci�n de crear un nueva versi�n
                        // CLEAR(GenerateQuotes);
                        // GenerateQuotes.VersionJob(TRUE);
                        // GenerateQuotes.SetParam(rec."Original Quote Code", '');
                        // GenerateQuotes.RUNMODAL;

                        //JAV 31/07/19: - Tras crear una nueva versi�n presentar la ficha de dicha versi�n
                        // IF (GenerateQuotes.GetJobGenerate <> '') THEN BEGIN
                            // Job.GET(GenerateQuotes.GetJobGenerate);
                            // CLEAR(VersionsQuoteCard);
                            // VersionsQuoteCard.SETRECORD(Job);
                            // VersionsQuoteCard.RUN;
                        // END;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Versions Compare', ESP = 'Comparar versiones';
                    Enabled = HaveVersions;
                    Image = ExchProdBOMItem;

                    trigger OnAction()
                    BEGIN
                        QBPageSubscriber.seeBudgetByCA(Rec, TRUE);
                    END;


                }
                action("action3")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207370;
                    RunPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                    Visible = NotLookupMode;
                    Image = Statistics;
                }
                action("action4")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Visible = NotLookupMode;
                    Image = ViewComments;
                }
                group("group7")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action5")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-Individual';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                        Visible = NotLookupMode;
                        Image = Dimensions;
                    }
                    action("action6")
                    {
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones_&Multiples';
                        Visible = NotLookupMode;
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            Job: Record 167;
                            DefaultDimensionsMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Job);
                            DefaultDimensionsMultiple.SetMultiJob(Job);
                            DefaultDimensionsMultiple.RUNMODAL;
                        END;


                    }

                }

            }
            group("group10")
            {
                CaptionML = ENU = 'Budget', ESP = 'P&resupuestos';
                action("PptoCoste")
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
                action("PptoVenta")
                {

                    CaptionML = ENU = 'Certification Piecework', ESP = 'Presupuesto de venta';
                    RunObject = Page 7207601;
                    RunPageView = SORTING("Job No.", "Piecework Code");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = LedgerBudget;
                }
                action("CalcPpto")
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
                action("CalcAnalitic")
                {

                    CaptionML = ENU = 'Calculate Analytical Budget', ESP = 'Calcular ppto anal�tico';
                    Image = Reconcile;

                    trigger OnAction()
                    VAR
                        JobOVersión: Boolean;
                        DataPieceworkForProduction: Record 7207386;
                        ConvertToBudgetxCA: Codeunit 7207282;
                    BEGIN
                        IF CONFIRM(Text008, FALSE) THEN BEGIN
                            JobOVersión := (rec."Card Type" = rec."Card Type"::Estudio) AND (rec."Original Quote Code" <> '');
                            DataPieceworkForProduction.RESET;
                            DataPieceworkForProduction.SETRANGE("Job No.", rec."No.");
                            IF (DataPieceworkForProduction.FINDFIRST) THEN BEGIN
                                ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction, JobOVersión, rec."No.");
                                MESSAGE(Text009);
                            END;
                        END;
                    END;


                }

            }
            group("group15")
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
                        QBJobCurrencyExchange.SETRANGE("Job No.", rec."Original Quote Code");
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
            group("group18")
            {
                CaptionML = ENU = 'Print', ESP = '&Imprimir';
                Visible = NotLookupMode;
                action("action13")
                {
                    CaptionML = ENU = 'Quote State-Owned', ESP = 'Impresi�n presupuesto de venta';
                    Visible = NotLookupMode;
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
                action("action14")
                {
                    CaptionML = ENU = 'Budget/Measure', ESP = 'Presupuesto de medici�n';
                    Visible = NotLookupMode;
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        VersionSelected: Record 167;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(VersionSelected);
                        //JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
                        QBReportSelections.Print(QBReportSelections.Usage::Q2, VersionSelected);
                        //REPORT.RUNMODAL(REPORT::"Print Offer",TRUE,FALSE,VersionSelected);
                    END;


                }
                action("action15")
                {
                    CaptionML = ENU = 'Item Budget', ESP = 'Presupuesto producto';
                    Visible = NotLookupMode;
                    Image = ExplodeBOM;

                    trigger OnAction()
                    VAR
                        Job2: Record 167;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        Job2.RESET;
                        Job2.SETRANGE("No.", rec."No.");
                        //JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
                        QBReportSelections.Print(QBReportSelections.Usage::Q3, Job2);
                        //REPORT.RUNMODAL(REPORT::"Budget Offer Item",TRUE,FALSE,Job2);
                    END;


                }
                action("action16")
                {
                    CaptionML = ENU = 'Bill of Item Box', ESP = 'Cuadro de descompuesto';
                    Visible = NotLookupMode;
                    Image = OrderTracking;


                    trigger OnAction()
                    VAR
                        VersionSelected: Record 167;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(VersionSelected);
                        //JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
                        QBReportSelections.Print(QBReportSelections.Usage::Q4, VersionSelected);
                        //REPORT.RUNMODAL(REPORT::"Print Material Box",TRUE,FALSE,VersionSelected);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Versi�n';

                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(PptoCoste_Promoted; PptoCoste)
                {
                }
                actionref(PptoVenta_Promoted; PptoVenta)
                {
                }
                actionref(CalcPpto_Promoted; CalcPpto)
                {
                }
                actionref(CalcAnalitic_Promoted; CalcAnalitic)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action13_Promoted; action13)
                {
                }
                actionref(action14_Promoted; action14)
                {
                }
                actionref(action15_Promoted; action15)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Currency', ESP = 'Divisas';

                actionref(JobCurrencyExchanges_Promoted; JobCurrencyExchanges)
                {
                }
                actionref(ChangeFactboxCurrency_Promoted; ChangeFactboxCurrency)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 19/09/19: - Si estamos en modo lookup cambiar el caption y no presentar las opciones
        IF CurrPage.LOOKUPMODE THEN BEGIN
            CurrPage.CAPTION := Text001;
            IsLookupMode := TRUE;
        END ELSE
            NotLookupMode := TRUE;
        //JAV fin
        HaveVersions := Rec.COUNT > 1;

        //JAV 08/04/20: - GEN003-02 Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
        HaveVersions := Rec.COUNT > 1;
    END;



    var
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        QBPageSubscriber: Codeunit 7207349;
        TotalAmountStudiedBudget: Decimal;
        TotalAmountCostBudget: Decimal;
        DiffBiddingBasesBudget: Decimal;
        IsLookupMode: Boolean;
        NotLookupMode: Boolean;
        Text001: TextConst ESP = 'Seleccione la versi�n que desea aceptar';
        txtCalculated: Text;
        stCalculated1: Text;
        stCalculated2: Text;
        HaveVersions: Boolean;
        "--------------------------------------- Divisas": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        useCurrencies: Boolean;
        edCurrencies: Boolean;
        edCurrencyCode: Boolean;
        edInvoiceCurrencyCode: Boolean;
        canEditJobsCurrencies: Boolean;
        canChangeFactboxCurrency: Boolean;
        ShowCurrency: Integer;
        Text008: TextConst ENU = 'Analytic budget be will calculate. Do you want to continue?', ESP = 'Se va a calcular el presupuesto anal�tico. �Desea continuar?';
        Text009: TextConst ENU = 'Process is finished', ESP = 'Proceso terminado.';

    procedure CreateVersion();
    begin
        rec."Original Quote Code" := Rec.GETFILTER("Original Quote Code");
        Job.GET(rec."Original Quote Code");
        Rec.TRANSFERFIELDS(Job);

        rec.Status := rec.Status::Planning;
        Rec.VALIDATE("Job Matrix - Work", rec."Job Matrix - Work"::Work);
        Rec.VALIDATE("Original Quote Code", Job."No.");
    end;

    LOCAL procedure CalculateTotalAmountCostBudget();
    var
        DataPieceworkForProduction2: Record 7207386;
    begin
        //QBV102>>
        CLEAR(TotalAmountCostBudget);
        DataPieceworkForProduction2.RESET;
        DataPieceworkForProduction2.SETRANGE("Job No.", rec."No.");
        DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
        DataPieceworkForProduction2.SETRANGE("Budget Filter", rec."Budget Filter");
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
        DataPieceworkForProduction3.SETRANGE("Job No.", rec."No.");
        DataPieceworkForProduction3.SETRANGE("Account Type", DataPieceworkForProduction3."Account Type"::Unit);
        DataPieceworkForProduction3.SETRANGE("Budget Filter", rec."Budget Filter");
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
        Job.SETRANGE("No.", rec."No.");
        if Job.FINDSET then
            if TotalAmountCostBudget = 0 then
                DiffBiddingBasesBudget := 0
            ELSE
                DiffBiddingBasesBudget := (Job."Bidding Bases Budget" * 100) / TotalAmountCostBudget;
        //QBV102<<
    end;

    LOCAL procedure funOnAfterGetRecord();
    var
        Job: Record 167;
        QBPageSubscriber: Codeunit 7207349;
    begin
        //QBV102>>
        CalculateTotalAmountCostBudget;
        CalculateTotalAmountStudiedBudget;
        DiffAmountCostbudgetBiddingBasesBudget;
        //QBV102<<

        //Si se pueden ver las divisas del proyecto
        Job.GET(rec."Original Quote Code");
        JobCurrencyExchangeFunction.SetRecordCurrencies(Job, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        //JAV 30/01/10: - Marca de que el presupuesto debe actualizarce
        QBPageSubscriber.SetBudgetNeedRecalculate(rec."Pending Calculation Budget", rec."Pending Calculation Analitical", stCalculated1, stCalculated2, txtCalculated);
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_JobOffersStatis.PAGE.SetCurrency(ShowCurrency);
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      NZG 23/01/18: - QBV102 A�adidos Los totales de Amount Cost Budget y Amount Studied Budget y porcentaje
      PGM 20/12/18: - QB4973 A�adido filtro en el sourceTableView para que solo aparezcan los estudios
      JAV 11/04/19: - Se a�ade la acci�n de crear un nueva versi�n
      JAV 31/07/19: - Tras crear una nueva versi�n presentar la ficha de dicha versi�n
      JAV 19/09/19: - Si estamos en modo lookup cambiar el caption y no presentar las opciones
      JAV 03/10/19: - Se usa el selector de informes para lanzar los reports
      JDC 12/08/19: - GAP010 Added fields 50004 rec."Category Code", 50005 rec."Category Description", 50006 rec."Situation Code" and 50007 rec."Situation Description"
    }*///end
}







