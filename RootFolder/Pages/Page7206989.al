page 7206989 "Operative Matrix Jobs List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Operative Matrix Jobs List', ESP = 'Lista proyectos Matriz operativos';
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    ORDER(Ascending)
                    WHERE("Card Type" = FILTER("Proyecto operativo"), "Job Type" = CONST("Operative"), "Archived" = CONST(false));
    PageType = List;
    CardPageID = "Operative Jobs Card";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    StyleExpr = IsMatrix;
                }
                field("Matrix Job it Belongs"; rec."Matrix Job it Belongs")
                {

                }
                field("Old Job No."; rec."Old Job No.")
                {

                }
                field("OLD_Done"; rec."OLD_Done")
                {

                }
                field("Description"; rec."Description")
                {

                    StyleExpr = IsMatrix;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = false;
                    StyleExpr = IsMatrix;
                }
                field("Oficina/Identif"; rec."Oficina/Identif")
                {

                }
                field("Creation Date"; rec."Creation Date")
                {

                }
                field("Mandatory Allocation Term By"; rec."Mandatory Allocation Term By")
                {

                    CaptionML = ENU = 'Mandatory Allocation Term By', ESP = 'Imputaci�n';
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {

                    CaptionML = ENU = 'Bill-to Name', ESP = 'Cliente';
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Job Type"; rec."Job Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Invoicing Type"; rec."Invoicing Type")
                {

                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    CaptionML = ENU = 'Bill-to Customer No.', ESP = 'N� cliente';
                }
                field("Internal Status"; rec."Internal Status")
                {

                }
                field("Starting Date"; rec."Starting Date")
                {

                }
                field("Ending Date"; rec."Ending Date")
                {

                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    Visible = False;
                }
                field("Next Invoice Date"; rec."Next Invoice Date")
                {

                    Visible = False;
                }
                field("Job Posting Group"; rec."Job Posting Group")
                {

                    Visible = False;
                }
                field("ProductionBudgetTotal"; ProductionBudgetTotal)
                {

                    CaptionML = ENU = 'Total Sales Matrix (LCY)', ESP = 'Total Venta Matriz (DL)';
                    Editable = false;
                }
                field("CostBudgetTotal"; CostBudgetTotal)
                {

                    CaptionML = ENU = 'Total Cost Matrix (LCY)', ESP = 'Total Coste Matriz (DL)';
                    Editable = false;
                }
                field("ProductionActual"; ProductionActual)
                {

                    CaptionML = ENU = 'Actual Production Amount (LCY)', ESP = 'Importe Producci�n ejecutada Matriz (DL)';
                    Editable = false;
                }
                field("InvoicedActual"; InvoicedActual)
                {

                    CaptionML = ENU = 'Actual Invoiced Amount (LCY)', ESP = 'Importe Facturado Matriz (DL)';
                    Editable = false;
                }
                field("CostActual"; CostActual)
                {

                    CaptionML = ENU = 'Actual Cost Amount (LCY)', ESP = 'Importe Coste Incurrido Matriz (DL)';
                    Editable = false;
                }
                field("Budget Cost Amount"; rec."Budget Cost Amount")
                {

                    CaptionML = ENU = 'Budget Cost Amount (LCY)', ESP = 'Imp. coste ppto. (DL)';
                }
                field("Actual Production Amount"; rec."Actual Production Amount")
                {

                    CaptionML = ENU = 'Actual Earned Value Amount (LCY)', ESP = 'Importe producci�n real (DL)';
                }
                field("Production Budget Amount"; rec."Production Budget Amount")
                {

                    CaptionML = ENU = 'Estimated Value Budget Amount (LCY)', ESP = 'Importe producci�n ppto. (DL)';
                }
                field("Budget Sales Amount"; rec."Budget Sales Amount")
                {

                    CaptionML = ENU = 'Budget Sales Amount (LCY)', ESP = 'Imp. venta ppto. (DL)';
                }
                field("Direct Cost Amount PieceWork"; rec."Direct Cost Amount PieceWork")
                {

                    CaptionML = ENU = 'Direct Cost Amount by Work Package (LCY)', ESP = 'Importe Costes directos UO (DL)';
                }
                field("Usage (Cost) (LCY)"; rec."Usage (Cost) (LCY)")
                {

                }
                field("Invoiced Price (LCY)"; rec."Invoiced Price (LCY)")
                {

                }
                field("Search Description"; rec."Search Description")
                {

                }
                field("Job Phases"; rec."Job Phases")
                {

                }
                field("Customer Type"; rec."Customer Type")
                {

                }
                field("Clasification"; rec."Clasification")
                {

                }
                field("Responsibility Center"; rec."Responsibility Center")
                {

                }
                field("Project Management"; rec."Project Management")
                {

                }
                field("Project Management Descr."; rec."Project Management Descr.")
                {

                    Editable = FALSE;
                }
                field("Obralia Code"; rec."Obralia Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("JobAttributesFactbox"; 7206921)
            {

                ApplicationArea = Basic, Suite;
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

            group("BtnJob")
            {

                CaptionML = ENU = '&Job', ESP = 'Pro&yecto';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                group("group4")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action2")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-&Individual';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action3")
                    {
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&Multiple';
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
                action("action4")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    RunObject = Page 92;
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = JobLedger;
                }
                action("action5")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207332;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action6")
                {
                    CaptionML = ENU = 'Job Crhonovision', ESP = 'Cronovisi�n proyecto';
                    RunObject = Page 7207351;
                    RunPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                    Image = MachineCenterCalendar;
                }
                action("action7")
                {
                    CaptionML = ENU = 'Job Analytics', ESP = 'Analitica proyecto';
                    RunObject = Page 554;
                    Image = InsertStartingFee;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Job Scheme', ESP = 'Esquema de proyectos';
                    RunObject = Page 490;
                    RunPageLink = "Dimension 3 Filter" = FIELD("No.");
                    Image = ChartOfAccounts;
                }
                action("action9")
                {
                    CaptionML = ENU = 'Production analysis', ESP = 'An�lisis de producci�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    VAR
                        DataPieceworkForProduction: Record 7207386;
                        TrackingbyPiecework: Page 7207651;
                    BEGIN

                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.FILTERGROUP(2);
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.", rec."No.");
                        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Production Unit", TRUE);
                        DataPieceworkForProduction.FILTERGROUP(0);
                        DataPieceworkForProduction.SETRANGE("Budget Filter", rec."Current Piecework Budget");
                        CLEAR(TrackingbyPiecework);
                        //JAV 03/06/19: - Se a�ade el (TRUE) al LookupMode
                        TrackingbyPiecework.LOOKUPMODE(TRUE);
                        TrackingbyPiecework.SETTABLEVIEW(DataPieceworkForProduction);
                        TrackingbyPiecework.ReceivesJob(rec."No.", rec."Current Piecework Budget");
                        IF DataPieceworkForProduction.FINDFIRST THEN
                            TrackingbyPiecework.SETRECORD(DataPieceworkForProduction);
                        IF TrackingbyPiecework.RUNMODAL = ACTION::LookupOK THEN;
                    END;


                }

            }
            group("group13")
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
            group("BtnPrice")
            {

                CaptionML = ENU = '&Price', ESP = '&Precios';
                action("action12")
                {
                    CaptionML = ENU = 'Resource', ESP = 'Recurso';
                    RunObject = Page 1011;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ResourcePrice;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Item', ESP = 'Producto';
                    RunObject = Page 1012;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ItemCosts;
                }
                action("action14")
                {
                    CaptionML = ENU = 'G/L Account', ESP = 'Cuenta';
                    RunObject = Page 1013;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = GL;
                }

            }
            group("BtnControl")
            {

                CaptionML = ENU = 'Plan&ning', ESP = 'Pla&nific.';
                action("action15")
                {
                    CaptionML = ENU = 'Resource &Allocated pero Job', ESP = '&Asignaci�n recursos';
                    RunObject = Page 221;
                    Visible = FALSE;
                    Image = ResourcePlanning;
                }
                action("action16")
                {
                    CaptionML = ENU = 'Res. Group All&ocated per Job', ESP = 'A&signaci�n fams. recursos';
                    RunObject = Page 228;
                    Visible = FALSE;
                    Image = ResourceGroup;
                }

            }
            group("group23")
            {
                CaptionML = ENU = 'Plan&ning', ESP = 'Presupuestos';
                action("action17")
                {
                    CaptionML = ENU = 'Costs Budgets', ESP = 'Ppto Costes';
                    RunObject = Page 7207598;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = CopyLedgerToBudget;
                }
                action("action18")
                {
                    CaptionML = ENU = 'Budget Sales - Certifications', ESP = 'Ppto Venta';
                    RunObject = Page 7207600;
                    RunPageView = SORTING("Job No.", "No.");
                    RunPageLink = "Job No." = FIELD("No."), "Budget Filter" = FIELD("Current Piecework Budget");
                    Image = Replan;
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

                actionref(action6_Promoted; action6)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action17_Promoted; action17)
                {
                }
                actionref(action18_Promoted; action18)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = '4', ESP = '4';
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
                CaptionML = ENU = 'Attributes', ESP = 'Atributos';
            }
        }
    }



    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);

        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);

        //Q7357 -
        //seeDragDrop := FunctionQB.AccessToDragAndDrop;
        //IF (seeDragDrop) THEN
        //  CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);
        //Q7357 +

        //JAV 06/10/20: - QB 1.06.18 Filtramos los proyectos matriz con hijos
        Rec.SETFILTER("No. of Matrix Job it Belongs", '<>0');
        REPEAT
            Rec.MARK(TRUE);
        UNTIL Rec.NEXT = 0;
        Rec.SETRANGE("No. of Matrix Job it Belongs");

        Rec.SETFILTER("Matrix Job it Belongs", '<>%1', '');
        REPEAT
            Rec.MARK(TRUE);
        UNTIL Rec.NEXT = 0;
        Rec.SETRANGE("Matrix Job it Belongs");

        Rec.MARKEDONLY(TRUE);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        FunOnAfterGetRecord;
        CalcTotMatrix;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        FunOnAfterGetRecord;
    END;



    var
        FunctionQB: Codeunit 7207272;
        Text000: TextConst ENU = 'Cost Database', ESP = 'Presupuesto';
        IsMatrix: Text;
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
        "-------------------------- QB Atributos": Integer;
        ClientTypeManagement: Codeunit 50192;
        TempFilterJobAttributesBuffer: Record 7206911 TEMPORARY;
        TempJobFilteredFromAttributes: Record 167 TEMPORARY;
        TempJobFilteredFromPickJob: Record 167 TEMPORARY;
        IsOnPhone: Boolean;
        RunOnTempRec: Boolean;
        RunOnPickJob: Boolean;
        ProductionBudgetTotal: Decimal;
        CostBudgetTotal: Decimal;
        ProductionActual: Decimal;
        CostActual: Decimal;
        InvoicedActual: Decimal;
        CostNotInvoiced: Decimal;

    procedure ExistJob(): Boolean;
    var
        Job: Record 167;
    begin
        if rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job" then begin
            Job.RESET;
            Job.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
            Job.SETRANGE("Job Matrix - Work", Job."Job Matrix - Work"::Work);
            Job.SETRANGE("Matrix Job it Belongs", rec."No.");
            if not Job.ISEMPTY then
                exit(TRUE)
            ELSE
                exit(FALSE);
        end ELSE
            exit(FALSE);
    end;

    LOCAL procedure FunOnAfterGetRecord();
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
    begin
        Rec.CALCFIELDS("No. of Matrix Job it Belongs");
        IsMatrix := 'Standar';
        if (rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job") and (rec."No. of Matrix Job it Belongs" <> 0) then
            IsMatrix := 'Strong';
        if (rec."Job Matrix - Work" = rec."Job Matrix - Work"::Work) then
            IsMatrix := 'Ambiguous';

        //JAV 13/02/20: - Se a�ade el factbox y la acci�n para los atributos de los proyectos
        //CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData("No.");

        //Si se pueden ver las divisas del proyecto
        //JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        //+Q8636
        //if (seeDragDrop) then begin
        //  CurrPage.DropArea.PAGE.SetFilter(Rec);
        //  CurrPage.FilesSP.PAGE.SetFilter(Rec);
        //end;
        //-Q8636
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        //CurrPage.FB_General.PAGE.SetCurrency(ShowCurrency);
        //CurrPage.FB_Purchase.PAGE.SetCurrency(ShowCurrency);
        //CurrPage.FB_Warehouse.PAGE.SetCurrency(ShowCurrency);
        //CurrPage.FB_Certification.PAGE.SetCurrency(ShowCurrency);
        //CurrPage.FB_Production.PAGE.SetCurrency(ShowCurrency);
        //CurrPage.UPDATE;
    end;

    LOCAL procedure "------------------------- QB Atributos"();
    begin
    end;

    LOCAL procedure ClearAttributesFilter();
    begin
        Rec.CLEARMARKS;
        Rec.MARKEDONLY(FALSE);
        TempFilterJobAttributesBuffer.RESET;
        TempFilterJobAttributesBuffer.DELETEALL(FALSE);
        Rec.FILTERGROUP(0);
        Rec.SETRANGE("No.");
    end;

    //[External]
    procedure SetTempFilteredJobRec(var Job: Record 167);
    begin
        TempJobFilteredFromAttributes.RESET;
        TempJobFilteredFromAttributes.DELETEALL(FALSE);

        TempJobFilteredFromPickJob.RESET;
        TempJobFilteredFromPickJob.DELETEALL(FALSE);

        RunOnTempRec := TRUE;
        RunOnPickJob := TRUE;

        if Job.FINDSET(FALSE) then
            repeat
                TempJobFilteredFromAttributes := Job;
                TempJobFilteredFromAttributes.INSERT;
                TempJobFilteredFromPickJob := Job;
                TempJobFilteredFromPickJob.INSERT(FALSE);
            until Job.NEXT = 0;
    end;

    LOCAL procedure RestoreTempJobFilteredFromAttributes();
    begin
        if not RunOnPickJob then
            exit;

        TempJobFilteredFromAttributes.RESET;
        TempJobFilteredFromAttributes.DELETEALL(FALSE);
        RunOnTempRec := TRUE;

        if TempJobFilteredFromPickJob.FINDSET(FALSE) then
            repeat
                TempJobFilteredFromAttributes := TempJobFilteredFromPickJob;
                TempJobFilteredFromAttributes.INSERT(FALSE);
            until TempJobFilteredFromPickJob.NEXT = 0;
    end;

    LOCAL procedure "--------------------------- CALCULAR AGREGADOS"();
    begin
    end;

    LOCAL procedure CalcTotMatrix();
    var
        rJob: Record 167;
    begin
        ProductionBudgetTotal := 0;
        CostBudgetTotal := 0;
        ProductionActual := 0;
        InvoicedActual := 0;
        CostActual := 0;
        if rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job" then begin
            //JMMA primero sumamos el propio proyecto
            if rJob.GET(rec."No.") then begin
                rJob.SETFILTER("Posting Date Filter", '');
                rJob.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
                rJob.CALCFIELDS("Production Budget Amount", "Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
                ProductionBudgetTotal += rJob."Production Budget Amount";
                CostBudgetTotal += rJob."Direct Cost Amount PieceWork" + rJob."Indirect Cost Amount Piecework";
                rJob.SETFILTER("Posting Date Filter", rec.GETFILTER("Posting Date Filter"));
                rJob.CALCFIELDS("Usage (Cost) (LCY)", "Invoiced (LCY)", "Job in Progress (LCY)", "Actual Production Amount");
                ProductionActual += rJob."Actual Production Amount";
                InvoicedActual += rJob."Invoiced (LCY)";
                CostActual += rJob."Usage (Cost) (LCY)";
            end;
            //JMMA Ahora sumamos todos los hijos.
            rJob.RESET;
            rJob.SETRANGE("Matrix Job it Belongs", rec."No.");
            if rJob.FINDFIRST then
                repeat
                    rJob.SETFILTER("Posting Date Filter", '');
                    rJob.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
                    rJob.CALCFIELDS("Production Budget Amount", "Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
                    ProductionBudgetTotal += rJob."Production Budget Amount";
                    CostBudgetTotal += rJob."Direct Cost Amount PieceWork" + rJob."Indirect Cost Amount Piecework";
                    rJob.SETFILTER("Posting Date Filter", rec.GETFILTER("Posting Date Filter"));
                    rJob.CALCFIELDS("Usage (Cost) (LCY)", "Invoiced (LCY)", "Job in Progress (LCY)", "Actual Production Amount");
                    ProductionActual += rJob."Actual Production Amount";
                    InvoicedActual += rJob."Invoiced (LCY)";
                    CostActual += rJob."Usage (Cost) (LCY)";
                until rJob.NEXT = 0;
        end;
    end;

    // begin
    /*{
      PGM 20/12/18: - QB4973 A�adido filtro en el sourceTableView para que solo aparezcan los proyectos operativos
      PEL 19/03/19: - OBR Se a�aden campos de Obralia
      JAV 03/06/19: - Se a�ade el (TRUE) al LookupMode
      JAV 11/06/19: - Se a�ade la imagen en la acci�n de dimensiones
      JAV 09/07/19: - Se cambia el campo "Status" por el de rec."Internal Status", se eliminan los campos "status" y "Operative Status"
      PGM 20/09/19: - KALAM GAP011 Sacado los campos "Responsible Center", rec."Clasification" y rec."Customer Type"
      PGM 08/10/19: - KALAM GAP015 A�adido los campos rec."Project Management" y "Project Management Descr."
      JAV 03/02/19: - Se a�aden botones de acceso directo al presupuesto de coste y de venta
      JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
      MMS 08/07/21: - Q13639 A�adimos en los caption de las columnas desde �ProductionBudgetTotal� hasta "Direct Cost Amount PieceWork" la indicaci�n de que est�n en divisa local
    }*///end
}









