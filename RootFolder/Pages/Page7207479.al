page 7207479 "Quotes List"
{
    ApplicationArea = All;

    Editable = false;
    CaptionML = ENU = 'Quotes List', ESP = 'Lista ofertas';
    SourceTable = 167;
    // SourceTableView = SORTING("No.")
    //                 ORDER(Descending)
    //                 WHERE("Card Type" = FILTER("Estudio"), "Original Quote Code" = FILTER(''), "Archived" = CONST(false));
    SourceTableView = SORTING("No.")
    ORDER(Descending)
    WHERE("Card Type" = FILTER("Estudio"), "Original Quote Code" = FILTER(''), "Archived" = CONST(false));
    PageType = List;
    CardPageID = "Quotes Card";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    StyleExpr = isMatrix;
                }
                field("Description"; rec."Description")
                {

                    StyleExpr = IsMatrix;
                }
                field("Observations"; rec."Observations")
                {

                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Creation Date"; rec."Creation Date")
                {

                }
                field("Present. Quote Required Date"; rec."Present. Quote Required Date")
                {

                }
                field("Bill-to Name"; rec."Bill-to Name")
                {

                    CaptionML = ENU = 'Bill-to Name', ESP = 'Nombre cliente';
                }
                field("Quote Type"; rec."Quote Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Budgeted Amount"; rec."Budgeted Amount")
                {

                }
                field("Allocation Process"; rec."Allocation Process")
                {

                    Visible = FALSE;
                }
                field("Budget Sales Amount"; rec."Budget Sales Amount")
                {

                }
                field("Quote Status"; rec."Quote Status")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Internal Status"; rec."Internal Status")
                {

                }
                field("Income Statement Responsible"; rec."Income Statement Responsible")
                {

                }
                field("Clasification"; rec."Clasification")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Versions No."; rec."Versions No.")
                {

                }
                field("Invoicing Type"; rec."Invoicing Type")
                {

                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    Visible = False;
                }
                field("Search Description"; rec."Search Description")
                {

                }
                field("Rejection Reason"; rec."Rejection Reason")
                {

                }
                field("Approved/Refused By"; rec."Approved/Refused By")
                {

                    CaptionML = ENU = 'Approved/Refused By', ESP = 'Aprobada/Denegada por';
                }
                field("Accepted Version No."; rec."Accepted Version No.")
                {

                }
                field("Bidding Bases Budget"; rec."Bidding Bases Budget")
                {

                }
                field("Low Coefficient"; rec."Low Coefficient")
                {

                }
                field("TotalImpCostePres"; TotalImpCostePres)
                {

                    CaptionML = ENU = 'Total Amount Cost Budget', ESP = 'Total Coste Presupuesto';
                    // Numeric = false;
                    Visible = FALSE;
                    Enabled = FALSE;
                }
                field("TotalImpVentaPres"; TotalImpVentaPres)
                {

                    CaptionML = ENU = 'Sales Budget Amount Total', ESP = 'Total Venta Presupuestada';
                    Visible = FALSE;
                }
                field("AmountCostSubmited"; AmountCostSubmitted)
                {

                    CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                }
                field("AmountSalesSubmited"; AmountSalesSubmitted)
                {

                    CaptionML = ENU = 'Sale Budget Amount', ESP = 'Importe ppto. venta';
                }
                field("PercentageMarginLow"; PercentageMarginLow)
                {

                    CaptionML = ENU = '% Margin', ESP = '% Margen';
                    BlankZero = true;
                }
                field("Customer Type"; rec."Customer Type")
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
            part("FB_StatusQuotesJobGen"; 7207486)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            part("FB_StatusQuotesBidding"; 7207485)
            {
                SubPageLink = "No." = FIELD("No.");
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
            group("group6")
            {
                CaptionML = ENU = 'Versions', ESP = '&Versiones';
                action("action4")
                {
                    CaptionML = ENU = 'Versions', ESP = 'Versiones';
                    RunObject = Page 7207362;
                    RunPageLink = "Original Quote Code" = FIELD("No.");
                    Image = BOMVersions;
                }

            }
            group("group8")
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

                actionref(action4_Promoted; action4)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';
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
        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF seeDragDrop THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);
        //Q7357 +
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        TotalImpVentaPres: Decimal;
        PercentageMarginLow: Decimal;
        AmountSalesSubmitted: Decimal;
        AmountCostSubmitted: Decimal;
        TotalImpCostePres: Decimal;
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

    procedure ExistJob(): Boolean;
    var
        Job: Record 167;
    begin
        if rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job" then begin
            Job.RESET;
            Job.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
            Job.SETRANGE("Job Matrix - Work", Job."Job Matrix - Work"::Work);
            Job.SETRANGE("Matrix Job it Belongs", rec."No.");
            if Job.FINDLAST then
                exit(TRUE)
            ELSE
                exit(FALSE);
        end ELSE
            exit(FALSE);
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        IsMatrix := 'Standar';
        if ((rec."Job Matrix - Work" = rec."Job Matrix - Work"::"Matrix Job") and ExistJob) then
            IsMatrix := 'Strong';

        Job.SETRANGE("No.", rec."Presented Version");
        if Job.FINDFIRST then begin
            Job.CALCFIELDS("Amou Piecework Meas./Certifi.");
            TotalImpVentaPres := Job."Amou Piecework Meas./Certifi.";
            Job.CALCFIELDS(Job."Direct Cost Amount PieceWork");
            Job.CALCFIELDS(Job."Indirect Cost Amount Piecework");
            TotalImpCostePres := Job."Direct Cost Amount PieceWork" + Job."Indirect Cost Amount Piecework";
        end ELSE begin
            TotalImpVentaPres := 0;
            TotalImpCostePres := 0;
        end;

        PercentageMarginLow := 0;
        if rec."Presented Version" <> '' then begin
            Job.GET(rec."Presented Version");
            Job.CALCFIELDS("Budget Cost Amount", Job."Budget Sales Amount");
            AmountSalesSubmitted := Job."Budget Sales Amount";
            AmountCostSubmitted := Job."Budget Cost Amount";
            //PercentageMarginSubmitted := Job.CalMarginPricePercentage;
            if AmountSalesSubmitted <> 0 then
                PercentageMarginLow := ROUND((AmountSalesSubmitted - AmountCostSubmitted) * 100 / AmountSalesSubmitted, 0.01);
        end ELSE begin
            AmountCostSubmitted := 0;
            AmountSalesSubmitted := 0;
        end;

        //JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");

        //Si se pueden ver las divisas del proyecto
        JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        //+Q8636
        if seeDragDrop then begin
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        end;
        //-Q8636
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_StatusQuotesJobGen.PAGE.SetCurrency(ShowCurrency);
        CurrPage.FB_StatusQuotesBidding.PAGE.SetCurrency(ShowCurrency);
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
      QBV1098 - PGM - 01/02/2018 - A�adido filtro en el sourceTableView para que solo aparezcan las ofertas sin sus versiones.
      QB4973 PGM 20/12/2018 - A�adido filtro en el sourceTableView para que solo aparezcan los estudios
      JAV 09/05/19: Se elimina el campo "Status 2" pues es del Dynplus
      JAV 02/06/19: - Se cambia el campo "Quote Phase" por rec."Internal Status"
      JAV 09/07/19: - Se elimina el campo "Status" que no tiene sentido en QB mas que para uso interno
      JAV 26/07/19: - Se ordena primero el mas reciene, igual que en obras
      JAV 05/10/19: - Se a�aden los paneles de notas y v�nvulos
      PGM 20/09/19: - GAP011 Sacado los campos de rec."Responsibility Center" y rec."Customer Type"
      PGM 08/10/19: - GAP015 A�adido los campos rec."Project Management" y "Project Management Descr."
      JAV 07/12/19: - Se a�ade la fecha de presentaci�n requerida
      JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
    }*///end
}








