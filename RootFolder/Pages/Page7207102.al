page 7207102 "QPR Budget Jobs Card"
{
    CaptionML = ENU = 'Budget Card', ESP = 'Ficha de Presupuesto';
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    ORDER(Ascending)
                    WHERE("Card Type" = FILTER("Presupuesto"));
    PageType = Card;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group47")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                Editable = InternalStatusEditable;
                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Description"; rec."Description")
                {

                    ShowMandatory = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Archived"; rec."Archived")
                {

                    Visible = false;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                }
                group("group53")
                {

                    CaptionML = ENU = 'People', ESP = 'Personas';
                    grid("group54")
                    {

                        GridLayout = Rows;
                        group("group55")
                        {

                            CaptionML = ESP = 'Responsable';
                            field("Person Responsible"; rec."Person Responsible")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[1]_"; Descriptions[1])
                            {

                                CaptionML = ENU = 'Person responsible', ESP = 'Nombre responsable';
                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }

                }
                group("group58")
                {

                    CaptionML = ENU = 'General Data', ESP = 'Datos generales';
                    grid("group59")
                    {

                        GridLayout = Rows;
                        group("group60")
                        {

                            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro responsabilidad';
                            field("Responsibility Center"; rec."Responsibility Center")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[7]_"; Descriptions[7])
                            {

                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }

                }
                field("Search Description"; rec."Search Description")
                {

                }
                group("group64")
                {

                    CaptionML = ENU = 'Situation', ESP = 'Situaci�n';
                    field("Blocked"; rec."Blocked")
                    {

                        Enabled = QB_BlockedEnabled;
                    }
                    field("Status"; rec."Status")
                    {

                        Visible = FALSE;
                    }
                    grid("group67")
                    {

                        GridLayout = Rows;
                        group("group68")
                        {

                            CaptionML = ESP = 'Edici�n';
                            field("Budget Status"; rec."Budget Status")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
                                BEGIN
                                    //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
                                    SetInternalStatus;
                                END;

                                trigger OnAssistEdit()
                                BEGIN
                                    //JAV 06/08/19: - Se a�aden rec."Budget Status" no editable si est� bloqueado
                                    //JAV 02/10/19: - Solo el que lo bloque� o el responsable de proyectos puede abrirlo

                                    IF (rec."Quote Status" <> rec."Quote Status"::Pending) THEN
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

                                ShowCaption = false;
                            }

                        }

                    }

                }
                group("group71")
                {

                    CaptionML = ENU = 'Data', ESP = 'Datos';

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                    Visible = FALSE;
                }
                field("QB_Budget control"; rec."QB_Budget control")
                {

                }

            }
            group("group75")
            {

                CaptionML = ENU = 'Status', ESP = 'Estado';
                Editable = InternalStatusEditable;
                field("Data Missed Message"; rec."Data Missed Message")
                {

                    Visible = QB_MandatoryFields;
                }
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

                        //JAV 30/01/20: - Se pasa a una funci�n el set estados editables
                        SetInternalStatus;
                    END;

                    trigger OnAssistEdit()
                    VAR
                        Changestatus: Page 7206927;
                    BEGIN
                        IF (InternalsStatus.IfInternalStatusEditable(rec."Card Type")) THEN BEGIN
                            CLEAR(Changestatus);
                            Changestatus.SetStatus(rec."Card Type", rec."Internal Status");
                            Changestatus.LOOKUPMODE(TRUE);
                            IF (Changestatus.RUNMODAL = ACTION::LookupOK) THEN
                                Rec.VALIDATE(rec."Internal Status", Changestatus.GetStatus);

                            //JAV 30/01/20: - Se pasa a una funci�n el set estados editables
                            SetInternalStatus;
                        END;
                    END;


                }
                group("group78")
                {

                    CaptionML = ENU = 'Dates', ESP = 'Fechas';
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
                        Enabled = editFecha3;
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
                    field("QB_Last Closing Date"; rec."QB_Last Closing Date")
                    {

                        Editable = FALSe;
                    }

                }
                group("group85")
                {

                    CaptionML = ENU = 'Edition Dates', ESP = 'Fechas Edici�n';
                    field("Creation Date"; rec."Creation Date")
                    {

                    }
                    field("Last Date Modified"; rec."Last Date Modified")
                    {

                    }

                }

            }
            group("group88")
            {

                CaptionML = ENU = 'Job Data', ESP = 'Direcci�n';
                Editable = InternalStatusEditable;
                field("Job Address 1"; rec."Job Address 1")
                {

                    CaptionML = ENU = 'Job Address 1', ESP = 'Direcci�n 1';
                }
                field("Job Adress 2"; rec."Job Adress 2")
                {

                    CaptionML = ENU = '" Job Adress 2"', ESP = 'Direcci�n 2';
                }
                field("Job City"; rec."Job City")
                {

                    CaptionML = ENU = 'Job City', ESP = 'Poblaci�n';
                }
                field("Job P.C."; rec."Job P.C.")
                {

                    CaptionML = ENU = 'Job P.C.', ESP = 'C.P.';
                }
                field("Job Province"; rec."Job Province")
                {

                    CaptionML = ENU = 'Job Province', ESP = 'Provincia';
                }
                field("Job Country/Region Code"; rec."Job Country/Region Code")
                {

                    CaptionML = ENU = 'Job Country/Region Code', ESP = 'C�d. pa�s/regi�n';
                }
                field("Job Telephone"; rec."Job Telephone")
                {

                    CaptionML = ENU = 'Job Telephone', ESP = 'Tel�fono';
                }
                field("Job Fax"; rec."Job Fax")
                {

                    CaptionML = ENU = 'Job Fax', ESP = 'Fax obra';
                }

            }
            group("group97")
            {

                CaptionML = ENU = 'Bidding', ESP = 'Divisas';
                Visible = useCurrencies;
                Editable = InternalStatusEditable;
                field("Currency Code"; rec."Currency Code")
                {

                    CaptionML = ENU = 'Currency Code', ESP = 'Divisa contrato';
                    Visible = useCurrencies;
                    Editable = edCurrencyCode;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Aditional Currency"; rec."Aditional Currency")
                {

                    CaptionML = ENU = 'Aditional Currency', ESP = 'Divisa reporting';
                    Visible = useCurrencies;
                    Editable = edCurrencies;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("General Currencies"; rec."General Currencies")
                {

                    Visible = useCurrencies;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Currency Value Date"; rec."Currency Value Date")
                {

                    Visible = useCurrencies;
                }
                field("Invoice Currency Code"; rec."Invoice Currency Code")
                {

                    Visible = useCurrencies;
                    Editable = edInvoiceCurrencyCode;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Exch. Calculation (Cost)"; rec."Exch. Calculation (Cost)")
                {

                    Visible = useCurrencies;
                }
                field("Exch. Calculation (Price)"; rec."Exch. Calculation (Price)")
                {

                    Visible = useCurrencies;
                }
                field("Adjust Exchange Rate Piecework"; rec."Adjust Exchange Rate Piecework")
                {

                    ToolTipML = ESP = 'A que U.O. se imputan las diferencias de cambio de divisas';
                }
                field("Adjust Exchange Rate A.C."; rec."Adjust Exchange Rate A.C.")
                {

                    ToolTipML = ESP = 'A que Concepto Anal�tico se imputan las diferencias de cambio de divisas';
                }

            }
            group("group107")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                Editable = InternalStatusEditable;
                group("group108")
                {

                    CaptionML = ENU = 'Invoicing', ESP = 'C�lculos';
                    field("Assigned Amount"; rec."Assigned Amount")
                    {

                    }
                    field("Assigned Amount (LCY)"; rec."Assigned Amount (LCY)")
                    {

                        Visible = useCurrencies;
                        Editable = FALSE;
                    }
                    field("Assigned Amount (ACY)"; rec."Assigned Amount (ACY)")
                    {

                        Visible = useCurrencies;
                        Editable = FALSE;
                    }

                }
                group("group112")
                {

                    CaptionML = ENU = 'Production', ESP = 'Datos Generales';
                    Editable = InternalStatusEditable;
                    field("Mandatory Allocation Term By"; rec."Mandatory Allocation Term By")
                    {

                    }
                    field("Management By Production Unit"; rec."Management By Production Unit")
                    {

                    }
                    field("Purcharse Shipment Provision"; rec."Purcharse Shipment Provision")
                    {

                    }

                }
                group("group116")
                {

                    CaptionML = ENU = 'Activable Expenses', ESP = 'Gastos Activables';
                    Visible = seeActivable;
                    Editable = InternalStatusEditable;
                    field("QB Activable"; rec."QB Activable")
                    {

                        Visible = seeActivable;

                        ; trigger OnValidate()
                        BEGIN
                            //JAV 10/11/22: - QB 1.12.00 Gastos activables
                            FunOnAfterGetRecord;
                        END;


                    }
                    field("QB Activable Status"; rec."QB Activable Status")
                    {

                        ToolTipML = ESP = 'Indica si para este proyecto se pueden generar los movimientos de activaci�n de los gastos, cuando est� en un estado en que se puedan activar los gastos.';
                        Visible = seeActivable;
                    }
                    field("QB Activable Date"; rec."QB Activable Date")
                    {

                        Visible = seeActivable;
                        Enabled = edActivable;
                    }

                }
                group("group120")
                {

                    CaptionML = ENU = 'Duration', ESP = 'Duraci�n';
                    Editable = InternalStatusEditable;
                    field("Starting Date"; rec."Starting Date")
                    {

                    }
                    field("Ending Date"; rec."Ending Date")
                    {

                    }

                }
                group("group123")
                {

                    CaptionML = ENU = 'Invoicing', ESP = 'Presupuestos';
                    field("Initial Budget Piecework"; rec."Initial Budget Piecework")
                    {

                    }
                    field("Current Piecework Budget"; rec."Current Piecework Budget")
                    {

                    }

                }

            }
            group("group126")
            {

                CaptionML = ENU = 'Foreign Trade', ESP = 'Internacional';
                Visible = FALSE;
                Editable = InternalStatusEditable;
                field("Language Code"; rec."Language Code")
                {

                }

            }
            part("part1"; 7207045)
            {

                CaptionML = ESP = 'Responsable';
                SubPageView = SORTING("Type", "Table Code", "ID Register");
                SubPageLink = "Type" = CONST("Job"), "Table Code" = FIELD("No.");
                Editable = InternalStatusEditable;
            }
            part("part2"; 7206924)
            {
                SubPageLink = "Job No." = FIELD("No.");
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
            part("FB_Purchase"; 7207500)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            part("FB_Warehouse"; 7207501)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            part("FB_Certification"; 7207502)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            part("FB_Production"; 7207503)
            {
                SubPageLink = "No." = FIELD("No."), "Posting Date Filter" = FIELD("Posting Date Filter");
            }
            part("JobAttributesFactbox"; 7206921)
            {
                ;
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
                    Image = Category;

                    trigger OnAction()
                    BEGIN
                        //JAV 13/02/20: - Se a�ade el factbox y la acci�n para los atributos de los proyectos
                        PAGE.RUNMODAL(PAGE::"Job Attribute Value Editor", Rec);
                        CurrPage.SAVERECORD;
                        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");
                    END;


                }

            }
            group("group4")
            {
                CaptionML = ENU = '&Job', ESP = 'Pro&yecto';
                action("action2")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("No.");
                    Image = Dimensions;
                }
                action("action4")
                {
                    CaptionML = ENU = 'Online Map', ESP = 'Mapa Online';
                    Image = NewExchangeRate;

                    trigger OnAction()
                    BEGIN
                        rec.DisplayMap;
                    END;


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
            group("group11")
            {
                CaptionML = ENU = 'Planning', ESP = 'Planificaci�n';
                action("action7")
                {
                    CaptionML = ENU = 'Budget Data', ESP = 'Partidas Presupuestarias';
                    RunObject = Page 7207103;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = CopyLedgerToBudget;
                }

            }

        }
        area(Processing)
        {
            Description = 'Job Management';
            action("action8")
            {
                Ellipsis = true;
                CaptionML = ENU = 'Copy Job', ESP = 'Copiar proyecto';
                RunObject = Page 1040;
                Visible = FALSE;
                Image = CopyFromTask;

                trigger OnAction()
                VAR
                    ConfigTemplateManagement: Codeunit 8612;
                    RecRef: RecordRef;
                BEGIN
                    RecRef.GETTABLE(Rec);
                    ConfigTemplateManagement.UpdateFromTemplateSelection(RecRef);
                END;


            }
            action("action9")
            {
                CaptionML = ENU = 'Pending Tasks', ESP = 'Tareas pendientes';
                RunObject = Page 5096;
                RunPageView = SORTING("Opportunity No.", "Date", "Closed")
                                  ORDER(Ascending)
                                  WHERE("Status" = FILTER(<> Completed), "System To-do Type" = CONST("Organizer"));
                RunPageLink = "Opportunity No." = FIELD("Opportunity Code");
                Visible = FALSE;
                Image = ItemTrackingLedger;
            }
            group("group16")
            {
                CaptionML = ENU = 'Purchase', ESP = 'Compras';
                group("group17")
                {
                    CaptionML = ENU = 'Documents', ESP = 'Documentos';
                    Image = Agreement;
                    action("action10")
                    {
                        CaptionML = ENU = 'Comparison of offers', ESP = 'Comparativos de ofertas';
                        Image = JobPrice;

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
                    action("action11")
                    {
                        CaptionML = ENU = 'Open Orders(Contract)', ESP = 'Pedidos abiertos(Contratos)';
                        Image = Purchase;

                        trigger OnAction()
                        VAR
                            PurchaseHeader: Record 38;
                        BEGIN
                            PurchaseHeader.RESET;
                            PurchaseHeader.FILTERGROUP(2);
                            PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::"Blanket Order");
                            PurchaseHeader.SETRANGE("QB Job No.", rec."No.");
                            PurchaseHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Purchase List", PurchaseHeader);
                        END;


                    }
                    action("action12")
                    {
                        CaptionML = ENU = 'Order', ESP = 'Pedidos';
                        Image = Order;

                        trigger OnAction()
                        VAR
                            RPurchaseHeader: Record 38;
                        BEGIN
                            RPurchaseHeader.RESET;
                            RPurchaseHeader.FILTERGROUP(2);
                            RPurchaseHeader.SETRANGE("Document Type", RPurchaseHeader."Document Type"::Order);
                            RPurchaseHeader.SETRANGE("QB Job No.", rec."No.");
                            RPurchaseHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Purchase List", RPurchaseHeader);
                        END;


                    }
                    action("action13")
                    {
                        CaptionML = ESP = 'Proformas';
                        Image = ExternalDocument;

                        trigger OnAction()
                        VAR
                            QBProformHeader: Record 7206960;
                        BEGIN
                            //Ver las Proformas sin facturar
                            QBProformHeader.RESET;
                            QBProformHeader.FILTERGROUP(2);
                            QBProformHeader.SETRANGE("Job No.", rec."No.");
                            QBProformHeader.SETFILTER("Invoice No.", '=%1', '');
                            QBProformHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"QB Proform List", QBProformHeader);
                        END;


                    }
                    action("action14")
                    {
                        CaptionML = ENU = 'Invoices', ESP = 'Facturas';
                        Image = Invoice;

                        trigger OnAction()
                        VAR
                            PurchaseHeaderInvoiced: Record 38;
                        BEGIN
                            PurchaseHeaderInvoiced.RESET;
                            PurchaseHeaderInvoiced.FILTERGROUP(2);
                            PurchaseHeaderInvoiced.SETRANGE("Document Type", PurchaseHeaderInvoiced."Document Type"::Invoice);
                            PurchaseHeaderInvoiced.SETRANGE("QB Job No.", rec."No.");
                            PurchaseHeaderInvoiced.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Purchase List", PurchaseHeaderInvoiced);
                        END;


                    }
                    action("action15")
                    {
                        CaptionML = ENU = 'Credit Memo', ESP = 'Abonos';
                        Image = CreditMemo;

                        trigger OnAction()
                        VAR
                            PurchaseHeaderPayment: Record 38;
                        BEGIN
                            PurchaseHeaderPayment.RESET;
                            PurchaseHeaderPayment.FILTERGROUP(2);
                            PurchaseHeaderPayment.SETRANGE("Document Type", PurchaseHeaderPayment."Document Type"::"Credit Memo");
                            PurchaseHeaderPayment.SETRANGE("QB Job No.", rec."No.");
                            PurchaseHeaderPayment.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Purchase List", PurchaseHeaderPayment);
                        END;


                    }
                    action("action16")
                    {
                        CaptionML = ENU = 'Receptions', ESP = 'Recepciones';
                        Image = Receipt;

                        trigger OnAction()
                        VAR
                            HeaderJobReception: Record 7207410;
                        BEGIN
                            HeaderJobReception.RESET;
                            HeaderJobReception.FILTERGROUP(2);
                            HeaderJobReception.SETRANGE("Job No.", rec."No.");
                            HeaderJobReception.SETRANGE(Posted, FALSE);
                            HeaderJobReception.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Job Receptions List", HeaderJobReception);
                        END;


                    }

                }
                group("group25")
                {
                    CaptionML = ENU = 'Historical', ESP = 'Hist�ricos';
                    Image = JobRegisters;
                    action("action17")
                    {
                        CaptionML = ENU = 'Shipments', ESP = 'Albaranes compra';
                        Image = ReceiptLines;

                        trigger OnAction()
                        VAR
                            PurchRcptHeader: Record 120;
                        BEGIN
                            PurchRcptHeader.RESET;
                            PurchRcptHeader.FILTERGROUP(2);
                            //JMMA ERROR EN CAMPO FILTRO PurchRcptHeader.SETRANGE("Cod. Withholding by PIT","No.");
                            PurchRcptHeader.SETRANGE("Job No.", rec."No.");

                            PurchRcptHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
                        END;


                    }
                    action("action18")
                    {
                        CaptionML = ESP = 'Proformas Facturadas';
                        Image = ExternalDocument;

                        trigger OnAction()
                        VAR
                            QBProformHeader: Record 7206960;
                        BEGIN
                            //Ver las Proformas facturadas
                            QBProformHeader.RESET;
                            QBProformHeader.FILTERGROUP(2);
                            QBProformHeader.SETRANGE("Job No.", rec."No.");
                            QBProformHeader.SETFILTER("Invoice No.", '<>%1', '');
                            QBProformHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"QB Proform List", QBProformHeader);
                        END;


                    }
                    action("action19")
                    {
                        CaptionML = ENU = 'Invoiced Historical', ESP = 'Hist�ricos de facturas';
                        Image = Invoice;

                        trigger OnAction()
                        VAR
                            PurchInvHeaderInvoiced: Record 122;
                        BEGIN
                            PurchInvHeaderInvoiced.RESET;
                            PurchInvHeaderInvoiced.FILTERGROUP(2);
                            PurchInvHeaderInvoiced.SETRANGE("Job No.", rec."No.");
                            PurchInvHeaderInvoiced.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Posted Purchase Invoices", PurchInvHeaderInvoiced);
                        END;


                    }
                    action("action20")
                    {
                        CaptionML = ENU = 'Payment Historical', ESP = 'Hist�ricos de abonos';
                        Image = CreditMemo;

                        trigger OnAction()
                        VAR
                            PurchCrMemoHdrPayment: Record 124;
                        BEGIN
                            PurchCrMemoHdrPayment.RESET;
                            PurchCrMemoHdrPayment.FILTERGROUP(2);
                            PurchCrMemoHdrPayment.SETRANGE("Job No.", rec."No.");
                            PurchCrMemoHdrPayment.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memos", PurchCrMemoHdrPayment);
                        END;


                    }
                    action("action21")
                    {
                        CaptionML = ENU = 'Expense Note Posted', ESP = 'Hist�ricos de nota de gastos';
                        Image = RollUpCosts;

                        trigger OnAction()
                        VAR
                            HistExpenseNotesHeader: Record 7207323;
                        BEGIN
                            HistExpenseNotesHeader.RESET;
                            HistExpenseNotesHeader.FILTERGROUP(2);
                            HistExpenseNotesHeader.SETRANGE("Job No.", rec."No.");
                            HistExpenseNotesHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Hist. Expense Notes List", HistExpenseNotesHeader);
                        END;


                    }
                    action("action22")
                    {
                        CaptionML = ENU = 'Receptions Historical', ESP = 'Hist�ricos recepciones';
                        Image = History;

                        trigger OnAction()
                        VAR
                            HeaderJobReception: Record 7207410;
                        BEGIN
                            HeaderJobReception.RESET;
                            HeaderJobReception.FILTERGROUP(2);
                            HeaderJobReception.SETRANGE("Job No.", rec."No.");
                            HeaderJobReception.SETRANGE(Posted, TRUE);
                            HeaderJobReception.FILTERGROUP(0);
                            IF HeaderJobReception.FINDSET THEN
                                PAGE.RUNMODAL(PAGE::"Job Receptions List", HeaderJobReception)
                            ELSE
                                MESSAGE(Text50000);
                        END;


                    }

                }
                action("action23")
                {
                    CaptionML = ENU = 'Note of Expenses', ESP = 'Notas de gastos';
                    Image = InsertTravelFee;

                    trigger OnAction()
                    VAR
                        ExpenseNotesHeader: Record 7207320;
                    BEGIN
                        ExpenseNotesHeader.RESET;
                        ExpenseNotesHeader.FILTERGROUP(2);
                        ExpenseNotesHeader.SETRANGE("Job No.", rec."No.");
                        ExpenseNotesHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Expense Notes List", ExpenseNotesHeader);
                    END;


                }

            }
            group("group33")
            {
                CaptionML = ENU = 'Prepayment', ESP = 'Anticipos';
                Visible = verAnticipos;
                Image = JobRegisters;
                action("PrepmtCustEntries")
                {

                    CaptionML = ENU = 'Prepmt. Cust. Entries', ESP = 'Ant. Clientes';
                    Visible = ShowQBCustPrepmt;
                    Image = Prepayment;

                    trigger OnAction()
                    BEGIN
                        QBPrepmtMgt.SeeJobCustomer(rec."No.");
                    END;


                }
                action("PrepmtVendEntries")
                {

                    CaptionML = ENU = 'Prepmt. Vend. Entries', ESP = 'Ant. Proveedores';
                    Visible = ShowQBVendPrepmt;
                    Image = PrepaymentSimulation;

                    trigger OnAction()
                    BEGIN
                        //Q12879 -
                        QBPrepmtMgt.SeeJobVendor(rec."No.");
                        //Q12879 +
                    END;


                }

            }

        }
        area(Reporting)
        {

            group("group37")
            {
                CaptionML = ENU = 'Job Control', ESP = 'Control del proyecto';
            }
            group("Statistics")
            {

                CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                Image = Statistics;
                group("EstadísticasSubGroup")
                {

                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;
                    action("action26")
                    {
                        ShortCutKey = 'F7';
                        CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas del proyecto';
                        RunObject = Page 7207332;
                        RunPageLink = "No." = FIELD("No."), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter"), "Budget Filter" = FIELD("Current Piecework Budget");
                        Image = Statistics;
                    }

                }

            }
            group("Entries")
            {

                CaptionML = ENU = 'Entries', ESP = 'Movimientos';
                Image = JobLedger;
                group("Subgroup Entries")
                {

                    CaptionML = ENU = 'Entries', ESP = 'Movimientos';
                    Image = JobLedger;
                    action("action27")
                    {
                        ShortCutKey = 'Ctrl+F7';
                        CaptionML = ENU = 'Ledger Entries', ESP = 'Movimientos del proyecto';
                        RunObject = Page 92;
                        RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                        RunPageLink = "Job No." = FIELD("No.");
                        Image = JobLedger;
                    }

                }

            }
            group("Reports")
            {

                CaptionML = ENU = 'Reports', ESP = 'Infomes';
                group("group45")
                {
                    CaptionML = ENU = 'Reports', ESP = 'Informes';
                    Image = AnalysisView
    ;

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
                CaptionML = ENU = 'Planning', ESP = 'Planificaci�n';

                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
                actionref(action9_Promoted; action9)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Project monitoring', ESP = 'Seguimiento de proyecto';

                actionref(action26_Promoted; action26)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Execution', ESP = 'Ejecuci�n';

                actionref(action10_Promoted; action10)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action13_Promoted; action13)
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
                CaptionML = ENU = 'Attributes', ESP = 'Atributos';

                actionref(Attributes_Promoted; Attributes)
                {
                }
            }
        }
    }

    trigger OnInit()
    BEGIN
        Completado := TRUE;
        InternalStatusEditable := TRUE; //Por defecto ser� editable
        ChangeInternalStatus := TRUE;
    END;

    trigger OnOpenPage()
    VAR
        QBTablesSetup: Record 7206903;
        rRef: RecordRef;
    BEGIN
        rec.FilterResponsability(Rec);

        //JAV 30/04/20: - Guardar el tipo segun el filtro de entrada
        JobType := rec."Job Type";

        //JAV 30/01/20: - Se pasa a una funci�n el set estados editables
        SetInternalStatus;

        //JAV 20/06/19: - Se a�ade el campo del N�mero de serie de registro de facturas y abonos por proyecto
        QuoBuildingSetup.GET;

        //JAV 02/04/20: - Campo visible si se controla que faltan datos
        rRef.GETTABLE(Rec);
        QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);

        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 1);

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF seeDragDrop THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);

        //JAV 14/03/22: - QB 1.10.24 Ver anticipos de clientes y de proveedores
        ShowQBCustPrepmt := QBPrepmtMgt.AccessToCustomerPrepayment;
        ShowQBVendPrepmt := QBPrepmtMgt.AccessToVendorPrepayment;
        verAnticipos := ShowQBCustPrepmt OR ShowQBVendPrepmt;

        //JAV 07/04/22: - QB 1.12.00 Si el proyecto puede activar gastos, se cambia la variable
        //JAV 07/04/22: - QB 1.12.00 Si el proyecto puede activar gastos, se cambia la variable
        IF (QBActivableExpensesSetup.GET()) THEN
            seeActivable := QBActivableExpensesSetup."Activable RE"
        ELSE
            seeActivable := FALSE;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        HasCotSalesUserSetup: Boolean;
        UserRespCEnter: Code[20];
    BEGIN
        IF FunctionQB.AccessToQuobuilding THEN BEGIN
            FunctionQB.GetJobFilter(HasCotSalesUserSetup, UserRespCEnter);
            rec."Responsibility Center" := UserRespCEnter;
        END;

        rec.Status := rec.Status::Open;
        rec."Card Type" := rec."Card Type"::Presupuesto; // QB4973

        //JAV 13/06/19: - Uno nuevo siempre ser� editable
        InternalStatusEditable := TRUE;

        //JAV 30/04/20: - Al crear pone el tipo segun el filtro de entrada
        rec."Job Type" := JobType;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        FunOnAfterGetRecord;
    END;



    var
        JobTask: Record 1001;
        GeneralLedgerSetup: Record 98;
        DimensionCodeBuffer: Record 367;
        GLBudgetName: Record 95;
        InternalsStatus: Record 7207440;
        QuoBuildingSetup: Record 7207278;
        UserSetup: Record 91;
        Job: Record 167;
        PurchRcptHeader: Record 120;
        DataPieceworkForProduction: Record 7207386;
        JobLedgerEntry: Record 169;
        QBActivableExpensesSetup: Record 7206997;
        QBPagePublisher: Codeunit 7207348;
        QBPageSubscriber: Codeunit 7207349;
        FunctionQB: Codeunit 7207272;
        QBPrepmtMgt: Codeunit 7207300;
        JobTaskLines: Page 1002;
        Descriptions: ARRAY[10] OF Text;
        Text50000: TextConst ENU = 'No data to display.', ESP = 'No hay datos que mostrar.';
        Completado: Boolean;
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
        ChangeInternalStatus: Boolean;
        Text011: TextConst ESP = 'El proyecto no es editbale, no puede cambiar este campo';
        Text012: TextConst ESP = 'Solo el usuairo que lo bloque� o el responsle de proyectos puede levantar el bloqueo';
        QB_MandatoryFields: Boolean;
        QB_BlockedEnabled: Boolean;
        JobType: Option;
        seeDragDrop: Boolean;
        verAnticipos: Boolean;
        ShowQBCustPrepmt: Boolean;
        ShowQBVendPrepmt: Boolean;
        seeActivable: Boolean;
        edActivable: Boolean;
        "--------------------------------------- Divisas": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        useCurrencies: Boolean;
        edCurrencies: Boolean;
        edCurrencyCode: Boolean;
        edInvoiceCurrencyCode: Boolean;
        canEditJobsCurrencies: Boolean;
        canChangeFactboxCurrency: Boolean;
        ShowCurrency: Integer;
        edInvoicingType: Boolean;
        enMilestones: Boolean;

    procedure AnalyticsJob();
    var
        AnalysisbyDimensions: Page 554;
        DimensionCodeBuffer: Record 367;
        Job: Record 167;
        Since: Code[20];
        CUntil: Code[20];
    begin
        CLEAR(AnalysisbyDimensions);
        DimensionCodeBuffer.SETRANGE(Code, rec."Job Analysis View Code");
        if rec."Job Matrix - Work" = rec."Job Matrix - Work"::Work then
            DimensionCodeBuffer.SETRANGE("Dimension 3 Value Filter", rec."No.")
        ELSE begin
            Job.RESET;
            Job.SETCURRENTKEY("Job Matrix - Work", "Matrix Job it Belongs");
            Job.SETRANGE("Job Matrix - Work", Job."Job Matrix - Work"::Work);
            Job.SETRANGE("Matrix Job it Belongs", rec."No.");
            if Job.FINDSET then begin
                Since := Job."No.";
                repeat
                    CUntil := Job."No.";
                until Job.NEXT = 0;
                DimensionCodeBuffer.SETRANGE("Dimension 3 Value Filter", Since, CUntil);
            end ELSE begin
                DimensionCodeBuffer.SETRANGE("Dimension 3 Value Filter", rec."No.")
            end;
        end;
        AnalysisbyDimensions.SETTABLEVIEW(DimensionCodeBuffer);
        AnalysisbyDimensions.RUNMODAL;
    end;

    procedure OpenBudget();
    begin
        JobTask.RESET;
        JobTask.SETRANGE("Job No.", rec."No.");
        JobTaskLines.SETTABLEVIEW(JobTask);
        JobTaskLines.RUN;
    end;

    procedure OpenBudgetCost();
    begin
        JobTask.RESET;
        JobTask.SETRANGE(JobTask."Job No.", rec."No.");
        CLEAR(JobTaskLines);
        JobTaskLines.LOOKUPMODE := TRUE;
        JobTaskLines.SETTABLEVIEW(JobTask);
        if JobTaskLines.RUNMODAL = ACTION::LookupOK then;
    end;

    LOCAL procedure SetInternalStatus();
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
        InvoiceMilestone: Record 7207331;
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

        Completado := (rec.Status = rec.Status::Completed);                       //Si est� en estado completado
        SetInternalStatus;                                                //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");  //JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
        QB_BlockedEnabled := not rec."Data Missed";                          //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
        Rec.CALCFIELDS("Guarantee Definitive Job");                           //JAV 19/09/19: - Hacer la garant�a editable solo si no se ha procesado

        JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);  //Si se pueden ver las divisas del proyecto

        if (seeDragDrop) then begin                                       //Asociar los registros del Sharepoint
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        end;

        InvoiceMilestone.RESET;                                           //JAV 30/09/20 Si se puede cambiar el tipo de facturaci�n
        InvoiceMilestone.SETRANGE("Job No.", rec."No.");
        if (InvoiceMilestone.ISEMPTY) then
            edInvoicingType := TRUE
        ELSE begin
            edInvoicingType := FALSE;
            if (rec."Invoicing Type" = rec."Invoicing Type"::Administration) then
                rec."Invoicing Type" := rec."Invoicing Type"::Landmark;
        end;
        enMilestones := (rec."Invoicing Type" <> rec."Invoicing Type"::Administration);  //JAV 30/09/20 Si est�n activos los hitos de facturaci�n

        //JAV 25/11/20: - QB 1.07.07 Si se puede cambiar el c�lculo del WIP si ya se ha lanzado alguna vez
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.");
        JobLedgerEntry.SETRANGE("Job No.", rec."No.");
        JobLedgerEntry.SETRANGE("Job in progress", TRUE);

        //JAV 10/11/22: - QB 1.12.00 Gastos activables
        edActivable := (Rec."QB Activable" = Rec."QB Activable"::activatable);
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_General.PAGE.SetViewData(ShowCurrency, FALSE);
        CurrPage.FB_Purchase.PAGE.SetViewData(ShowCurrency, FALSE);
        CurrPage.FB_Warehouse.PAGE.SetViewData(ShowCurrency, FALSE);
        CurrPage.FB_Certification.PAGE.SetViewData(ShowCurrency, FALSE);
        CurrPage.FB_Production.PAGE.SetViewData(ShowCurrency, FALSE);
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      JAV 06/04/22: - QB 1.10.31 Se eliminan campos que no se usan y se han eliminado de la tabla
      JAV 07/04/22: - QB 1.10.32 Si el proyecto puede activar gastos
      QRE15411-LCG-
                    Modificado filtro en part Responsible para que s�lo salgan los responsables que no tienen Unidad de obra asignada.
                    A�adir bot�n para que aparezcan todos los responsables tanto general como de partidas.

      QRE15469-LCG-071221 A�adir campo rec."QB_Budget control" para el control de partidas presupuestarias.
      Q17888 - MCM - 18/08/22 - Se oculta el campo Archived
      JAV 03/08/22: - QB 1.11.01 Se eliminan los botones para liberar el IVA diferido que no tienen sentido mantener en esta p�gina
      JAV 10/10/22: - QB 1.12.00 Se a�aden en el grupo de registro los campos rec."QB Activable",rec."QB Activable Status" y rec."QB Activable Date", se cambia la variable de control de visible
    }*///end
}







