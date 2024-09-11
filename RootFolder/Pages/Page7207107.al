page 7207107 "QPR Budget Jobs List Archived"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Budget List Archived', ESP = 'Lista de Presupuestos Archivados';
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    ORDER(Descending)
                    WHERE("Card Type" = FILTER("Presupuesto"), "Archived" = CONST(true));
    PageType = List;
    CardPageID = "QPR Budget Jobs Card";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Creation Date"; rec."Creation Date")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Job Type"; rec."Job Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Mandatory Allocation Term By"; rec."Mandatory Allocation Term By")
                {

                }
                field("Invoicing Type"; rec."Invoicing Type")
                {

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
                field("Budget Cost Amount"; rec."Budget Cost Amount")
                {

                    CaptionML = ENU = 'Budget Cost Amount', ESP = 'Presupuesto';
                }
                field("Actual Production Amount"; rec."Actual Production Amount")
                {

                    CaptionML = ENU = 'Actual Earned Value Amount', ESP = 'Comprometido';
                }
                field("Invoiced Price (LCY)"; rec."Invoiced Price (LCY)")
                {

                    CaptionML = ENU = 'Invoiced Price', ESP = 'Realizado';
                }
                field("Production Budget Amount"; rec."Production Budget Amount")
                {

                    CaptionML = ENU = 'Estimated Value Budget Amount', ESP = 'Gasto';
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {

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
            part("FB_General"; 7207499)
            {
                SubPageLink = "No." = FIELD("No."), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter"), "Budget Filter" = FIELD("Current Piecework Budget");
            }
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

            group("group2")
            {

                CaptionML = ESP = 'Atributos';
                action("Attributes")
                {

                    AccessByPermission = TableData 7206905 = R;
                    CaptionML = ENU = 'Attributes', ESP = 'Atributos';
                    ToolTipML = ENU = 'View or edit the Jobs attributes, such as type, localization, or other characteristics that help to describe the Job.', ESP = 'Permite ver o editar los atributos del proyecto, como tipos, ubicaciones u otras caracter�sticas que ayudan a describir el mismo';
                    ApplicationArea = Basic, Suite;
                    Image = Category;

                    trigger OnAction()
                    BEGIN
                        //JAV 13/02/20: - Se a�ade el factbox y la acci�n para los atributos de los proyectos
                        PAGE.RUNMODAL(PAGE::"Job Attribute Value Editor", Rec);
                        CurrPage.SAVERECORD;
                        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");
                    END;


                }
                action("FilterByAttributes")
                {

                    AccessByPermission = TableData 7500 = R;
                    CaptionML = ENU = 'Filter by Attributes', ESP = 'Filtrar por atributos';
                    ToolTipML = ENU = 'Find items that match specific attributes. To make sure you include recent changes made by other users, clear the filter and then Rec.RESET it.', ESP = 'Permite buscar productos que coincidan con atributos espec�ficos. Para asegurarse de que incluye cambios recientes realizados por otros usuarios, borre el filtro y, a continuaci�n, restabl�zcalo.';
                    ApplicationArea = Basic, Suite;
                    Image = EditFilter;

                    trigger OnAction()
                    VAR
                        JobAttributeManagement: Codeunit 7206906;
                        TypeHelper: Codeunit 10;
                        CloseAction: Action;
                        FilterText: Text;
                        FilterPageID: Integer;
                        ParameterCount: Integer;
                    BEGIN
                        FilterPageID := PAGE::"Filter Jobs by Attribute";
                        IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone THEN
                            FilterPageID := PAGE::"Filter Jobs by Att. Phone";

                        CloseAction := PAGE.RUNMODAL(FilterPageID, TempFilterJobAttributesBuffer);
                        IF (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Phone) AND (CloseAction <> ACTION::LookupOK) THEN
                            EXIT;

                        IF TempFilterJobAttributesBuffer.ISEMPTY THEN BEGIN
                            ClearAttributesFilter;
                            EXIT;
                        END;

                        JobAttributeManagement.FindJobsByAttributes(TempFilterJobAttributesBuffer, TempJobFilteredFromAttributes);
                        FilterText := JobAttributeManagement.GetJobNoFilterText(TempJobFilteredFromAttributes, ParameterCount);

                        IF ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 THEN BEGIN
                            Rec.FILTERGROUP(0);
                            Rec.MARKEDONLY(FALSE);
                            Rec.SETFILTER("No.", FilterText);
                        END ELSE BEGIN
                            RunOnTempRec := TRUE;
                            Rec.CLEARMARKS;
                            Rec.RESET;
                        END;
                    END;


                }
                action("ClearAttributes")
                {

                    AccessByPermission = TableData 7500 = R;
                    CaptionML = ENU = 'Clear Attributes Filter', ESP = 'Borrar filtro de atributos';
                    ToolTipML = ENU = 'Remove the filter for specific item attributes.', ESP = 'Permite quitar el filtro de atributos de producto espec�ficos.';
                    ApplicationArea = Basic, Suite;
                    Image = RemoveFilterLines;

                    trigger OnAction()
                    BEGIN
                        ClearAttributesFilter;
                        TempJobFilteredFromAttributes.RESET;
                        TempJobFilteredFromAttributes.DELETEALL(FALSE);
                        RunOnTempRec := FALSE;

                        RestoreTempJobFilteredFromAttributes;
                    END;


                }

            }
            group("BtnJob")
            {

                CaptionML = ENU = '&Job', ESP = 'Pro&yecto';
                action("action4")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                group("group8")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action5")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-&Individual';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action6")
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
                action("action7")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    RunObject = Page 92;
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = JobLedger;
                }
                action("action8")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207332;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
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
            group("group16")
            {
                CaptionML = ENU = 'Plan&ning', ESP = 'Presupuesto';
                action("action11")
                {
                    CaptionML = ENU = 'Budgets Data', ESP = 'Partidas Presupuestarias';
                    RunObject = Page 7207103;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = CopyLedgerToBudget;
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

                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action11_Promoted; action11)
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

                actionref(Attributes_Promoted; Attributes)
                {
                }
                actionref(FilterByAttributes_Promoted; FilterByAttributes)
                {
                }
                actionref(ClearAttributes_Promoted; ClearAttributes)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);

        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 1);

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF (seeDragDrop) THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);
        //Q7357 +
    END;

    trigger OnAfterGetRecord()
    BEGIN
        FunOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        FunOnAfterGetRecord;
    END;



    var
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
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
        QuoBuildingSetup: Record 7207278;
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
        //JAV 13/02/20: - Se a�ade el factbox y la acci�n para los atributos de los proyectos
        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");

        //Si se pueden ver las divisas del proyecto
        JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        //+Q8636
        if (seeDragDrop) then begin
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        end;
        //-Q8636
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_General.PAGE.SetViewData(ShowCurrency, FALSE);
        CurrPage.UPDATE;
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

    // begin
    /*{
      PGM 20/12/18: - QB4973 A�adido filtro en el sourceTableView para que solo aparezcan los proyectos operativos
      PEL 19/03/19: - OBR Se a�aden campos de Obralia
      JAV 03/06/19: - Se a�ade el (TRUE) al LookupMode
      JAV 11/06/19: - Se a�ade la imagen en la acci�n de dimensiones
      JAV 09/07/19: - Se cambia el campo "Status" por el de rec."Internal Status", se eliminan los campos "status" y "Operative Status"
      PGM 20/09/19: - KALAM GAP011 Sacado los campos "Responsible Center", "Clasification" y "Customer Type"
      PGM 08/10/19: - KALAM GAP015 A�adido los campos "Project Management" y "Project Management Descr."
      JAV 03/02/19: - Se a�aden botones de acceso directo al presupuesto de coste y de venta
      JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
      JAV 05/04/21: - QB 1.08.32 Se eliminan los paneles laterales que ralentizan la p�gina
      JAV 01/06/22: - QB 1.10.46 Se corrige el texto err�neo en la columna "Realizado" en los proyectos inmobiliarios y los archivados
    }*///end
}








