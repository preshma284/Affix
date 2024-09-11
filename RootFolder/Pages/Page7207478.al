page 7207478 "Operative Jobs Card"
{
    CaptionML = ENU = 'Operative Jobs Card', ESP = 'Ficha proyectos operativos';
    SourceTable = 167;
    SourceTableView = SORTING("No.")
                    ORDER(Ascending)
                    WHERE("Card Type" = FILTER("Proyecto operativo"));
    PageType = Card;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group160")
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

                }
                group("group165")
                {

                    CaptionML = ENU = 'Customer', ESP = 'Cliente';
                    field("Bill-to Customer No."; rec."Bill-to Customer No.")
                    {

                        ShowMandatory = TRUE;
                    }
                    field("Bill-to Name"; rec."Bill-to Name")
                    {

                    }
                    field("Bill-to Address"; rec."Bill-to Address")
                    {

                        Importance = Additional;
                    }
                    field("Bill-to Address 2"; rec."Bill-to Address 2")
                    {

                        Importance = Additional;
                    }
                    field("Bill-to Post Code"; rec."Bill-to Post Code")
                    {

                        Importance = Additional;
                    }
                    field("Bill-to City"; rec."Bill-to City")
                    {

                        Importance = Additional;
                    }
                    field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                    {

                        Importance = Additional;
                    }
                    field("Bill-to County"; rec."Bill-to County")
                    {

                        Importance = Additional;
                    }
                    field("Customer Type"; rec."Customer Type")
                    {

                    }

                }
                group("group175")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Contacto';
                    field("Bill-to Contact"; rec."Bill-to Contact")
                    {

                        Importance = Additional;
                    }
                    field("Bill-to Contact No."; rec."Bill-to Contact No.")
                    {

                        Importance = Additional;
                    }

                }
                group("group178")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Personas';
                    grid("group179")
                    {

                        GridLayout = Rows;
                        group("group180")
                        {

                            field("Person Responsible"; rec."Person Responsible")
                            {


                                ; trigger OnValidate()
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
                    grid("group183")
                    {

                        GridLayout = Rows;
                        group("group184")
                        {

                            field("Construction Manager"; rec."Construction Manager")
                            {


                                ; trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[9]_"; Descriptions[9])
                            {

                                CaptionML = ENU = 'Person responsible', ESP = 'Nombre responsable';
                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }
                    grid("group187")
                    {

                        GridLayout = Rows;
                        group("group188")
                        {

                            field("Income Statement Responsible"; rec."Income Statement Responsible")
                            {


                                ; trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[2]_"; Descriptions[2])
                            {

                                CaptionML = ENU = 'Salesperson Name', ESP = 'Nombre Comercial';
                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }
                    grid("group191")
                    {

                        GridLayout = Rows;
                        group("group192")
                        {

                            field("Project Management"; rec."Project Management")
                            {


                                ; trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[4]_"; Descriptions[4])
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
                group("group196")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Datos variables';
                    grid("group197")
                    {

                        GridLayout = Rows;
                        group("group198")
                        {

                            field("Clasification"; rec."Clasification")
                            {

                                Importance = Promoted;

                                ; trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[3]_"; Descriptions[3])
                            {

                                CaptionML = ENU = 'Clasification Name', ESP = 'Nombre clasificaci�n';
                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }
                    grid("group201")
                    {

                        GridLayout = Rows;
                        group("group202")
                        {

                            field("Quote Type"; rec."Quote Type")
                            {


                                ; trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[5]_"; Descriptions[5])
                            {

                                CaptionML = ESP = 'Descripcion Tipo';
                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }
                    grid("group205")
                    {

                        GridLayout = Rows;
                        group("group206")
                        {

                            field("Job Phases"; rec."Job Phases")
                            {


                                ; trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[6]_"; Descriptions[6])
                            {

                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }

                }
                group("group209")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Datos generales';
                    grid("group210")
                    {

                        GridLayout = Rows;
                        group("group211")
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
                    grid("group214")
                    {

                        GridLayout = Rows;
                        group("group215")
                        {

                            CaptionML = ENU = 'Opportunity Code', ESP = 'C�digo oportunidad';
                            field("Opportunity Code"; rec."Opportunity Code")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
                                BEGIN
                                    CurrPage.UPDATE;
                                END;


                            }
                            field("Descriptions[8]_"; Descriptions[8])
                            {

                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }
                    field("QB Activable"; rec."QB Activable")
                    {

                        Visible = FALSE;
                    }
                    field("QB Activable Date"; rec."QB Activable Date")
                    {

                        Visible = FALSE;
                    }

                }
                group("group220")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Situaci�n';
                    field("Blocked"; rec."Blocked")
                    {

                        Enabled = QB_BlockedEnabled;
                    }
                    field("Status"; rec."Status")
                    {

                        Visible = FALSE;
                    }
                    grid("group223")
                    {

                        GridLayout = Rows;
                        group("group224")
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
                group("group227")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Datos';

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                    Visible = FALSE;
                }
                field("Obralia Code"; rec."Obralia Code")
                {

                    Visible = vObralia;
                }
                field("Original Quote Code"; rec."Original Quote Code")
                {

                    Editable = FALSE;
                }
                grid("group232")
                {

                    GridLayout = Rows;
                    group("group233")
                    {

                        CaptionML = ENU = 'Import Cost Database Code', ESP = 'Preciario Directos Cargado';
                        field("Import Cost Database Direct"; rec."Import Cost Database Direct")
                        {

                            Importance = Additional;
                            ShowCaption = false;
                        }
                        field("Import Cost Database Dir. Date"; rec."Import Cost Database Dir. Date")
                        {

                            Importance = Additional;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group236")
                {

                    GridLayout = Rows;
                    group("group237")
                    {

                        CaptionML = ENU = 'Import Cost Database Code', ESP = 'Preciario Indirectos Cargado';
                        field("Import Cost Database Indirect"; rec."Import Cost Database Indirect")
                        {

                            Importance = Additional;
                            ShowCaption = false;
                        }
                        field("Import Cost Database Ind. Date"; rec."Import Cost Database Ind. Date")
                        {

                            Importance = Additional;
                            ShowCaption = false;
                        }

                    }

                }

            }
            group("group240")
            {

                CaptionML = ENU = 'Posting', ESP = 'Estado';
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
                group("group243")
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

                }
                group("group249")
                {

                    CaptionML = ENU = 'Posting', ESP = 'Fechas Edici�n';
                    field("Creation Date"; rec."Creation Date")
                    {

                    }
                    field("Last Date Modified"; rec."Last Date Modified")
                    {

                    }

                }

            }
            group("group252")
            {

                CaptionML = ENU = 'Job Data', ESP = 'Direcci�n';
                Editable = InternalStatusEditable;
                field("Job Address 1"; rec."Job Address 1")
                {

                }
                field("Job Adress 2"; rec."Job Adress 2")
                {

                }
                field("Job City"; rec."Job City")
                {

                }
                field("Job P.C."; rec."Job P.C.")
                {

                }
                field("Job Province"; rec."Job Province")
                {

                }
                field("Job Country/Region Code"; rec."Job Country/Region Code")
                {

                }
                field("Job Telephone"; rec."Job Telephone")
                {

                }
                field("Job Fax"; rec."Job Fax")
                {

                }

            }
            group("group261")
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
            group("group271")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                Editable = InternalStatusEditable;
                group("group272")
                {

                    CaptionML = ENU = 'Production', ESP = 'Datos Generales';
                    Editable = InternalStatusEditable;
                    field("Job Type"; rec."Job Type")
                    {

                    }
                    field("Mandatory Allocation Term By"; rec."Mandatory Allocation Term By")
                    {

                    }
                    field("Job Posting Group"; rec."Job Posting Group")
                    {

                    }
                    field("VAT Prod. PostingGroup"; rec."VAT Prod. PostingGroup")
                    {

                    }
                    group("group277")
                    {

                        CaptionML = ENU = 'Location', ESP = 'Almac�n';
                        field("Purcharse Shipment Provision"; rec."Purcharse Shipment Provision")
                        {

                        }
                        field("Job Location"; rec."Job Location")
                        {

                        }
                        field("Warehouse Cost Unit"; rec."Warehouse Cost Unit")
                        {

                        }
                        field("QB Allow Ceded"; rec."QB Allow Ceded")
                        {

                        }

                    }
                    group("group282")
                    {

                        CaptionML = ENU = 'Service Order', ESP = 'Pedidos Servicio';
                        Visible = seeServiceOrders;
                        field("QB Allow Service Order"; rec."QB Allow Service Order")
                        {


                            ; trigger OnValidate()
                            BEGIN
                                CurrPage.UPDATE(TRUE);
                            END;


                        }
                        field("QB Contract No."; rec."QB Contract No.")
                        {

                            Visible = seeServiceOrders;
                        }

                    }

                }
                group("group285")
                {

                    CaptionML = ENU = 'Production', ESP = 'Ejecuci�n Matrerial';
                    Editable = InternalStatusEditable;
                    field("Production Calculate Mode"; rec."Production Calculate Mode")
                    {

                        Enabled = enCalcProd;
                    }
                    field("Calculate WIP by periods"; rec."Calculate WIP by periods")
                    {

                        ToolTipML = ESP = 'Indica el modo de c�lculo de la Obra en Curso, si est� marcado ser� por periodos, si no ser� a origen';
                        Enabled = enCalcProd;
                    }
                    field("Management By Production Unit"; rec."Management By Production Unit")
                    {

                    }
                    field("Separation Job Unit/Cert. Unit"; rec."Separation Job Unit/Cert. Unit")
                    {

                        CaptionML = ENU = 'Separation Job Unit/Cert. Unit', ESP = 'Agrupaciones coste';
                        ToolTipML = ESP = 'Si se marca deber� relacionar las unidades de obra de coste con las de venta, para poder efectuar los c�lculos correctamente.';
                    }
                    field("Management by tasks"; rec."Management by tasks")
                    {

                        ToolTipML = ESP = 'Indica si es obligatorio informar la tarea asociada en las l�neas que registrar imputaciones contra el proyecto.';
                    }
                    field("WIP Method"; rec."WIP Method")
                    {

                        Visible = FALSE;
                    }
                    field("Allow Schedule/Contract Lines"; rec."Allow Schedule/Contract Lines")
                    {

                        Visible = FALSE;
                    }

                }
                group("group293")
                {

                    CaptionML = ENU = 'Production', ESP = 'Certificaci�n';
                    Editable = InternalStatusEditable;
                    field("Multi-Client Job"; rec."Multi-Client Job")
                    {

                    }
                    field("Invoicing Type"; rec."Invoicing Type")
                    {

                        Editable = edInvoicingType;

                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Sales Medition Type"; rec."Sales Medition Type")
                    {

                    }

                }
                group("group297")
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
                    field("% Margin"; rec."% Margin")
                    {

                    }
                    field("General Expenses / Other"; rec."General Expenses / Other")
                    {

                    }
                    field("Industrial Benefit"; rec."Industrial Benefit")
                    {

                        DecimalPlaces = 2 : 8;
                    }
                    field("Low Coefficient"; rec."Low Coefficient")
                    {

                        DecimalPlaces = 2 : 8;
                    }
                    field("Quality Deduction"; rec."Quality Deduction")
                    {

                        DecimalPlaces = 2 : 8;
                    }
                    field("Planned K"; rec."Planned K")
                    {

                    }

                }
                group("group307")
                {

                    CaptionML = ESP = 'Anticipos';
                    Visible = verAnticipos;
                    field("Cust. Prepayment Amount (LCY)"; rec."Cust. Prepayment Amount (LCY)")
                    {

                        Visible = ShowQBCustPrepmt;
                    }
                    field("Vend. Prepayment Amount (LCY)"; rec."Vend. Prepayment Amount (LCY)")
                    {

                        Visible = ShowQBVendPrepmt;
                    }

                }
                group("group310")
                {

                    CaptionML = ENU = 'Invoicing', ESP = 'Contratos';
                    Visible = verControlContrato;
                    field("No controlar en contratos"; rec."No controlar en contratos")
                    {

                        Visible = verControlContrato;
                        Editable = edControlContrato;
                    }
                    field("Quantity available contracts"; rec."Quantity available contracts")
                    {

                        Visible = verControlContrato;
                    }

                }
                group("group313")
                {

                    CaptionML = ENU = 'Invoicing', ESP = 'Series de Registro';
                    Visible = verSerieRegistro;
                    field("Serie Registro Fras Vta."; rec."Serie Registro Fras Vta.")
                    {

                        Visible = verSerieRegistro;
                    }
                    field("Serie Registro Abonos Vta."; rec."Serie Registro Abonos Vta.")
                    {

                        Visible = verSerieRegistro;
                    }
                    field("Serie Registro FRI"; rec."Serie Registro FRI")
                    {

                        Visible = verSerieRegistro;
                    }
                    field("Serie Registro Salida Almacen"; rec."Serie Registro Salida Almacen")
                    {

                    }

                }
                group("group318")
                {

                    CaptionML = ENU = 'Invoicing', ESP = 'Presupuestos';
                    field("Initial Budget Piecework"; rec."Initial Budget Piecework")
                    {

                    }
                    field("Current Piecework Budget"; rec."Current Piecework Budget")
                    {

                    }
                    field("Initial Reestimation Code"; rec."Initial Reestimation Code")
                    {

                        Editable = false;
                    }
                    field("Latest Reestimation Code"; rec."Latest Reestimation Code")
                    {

                        Editable = false;
                    }
                    field("Last Redetermination"; rec."Last Redetermination")
                    {

                        Visible = false;
                    }

                }
                group("group324")
                {

                    CaptionML = ENU = 'Invoicing', ESP = 'Agrupaci�n';
                    Visible = seeMatrixOrJob;
                    field("Job Matrix - Work"; rec."Job Matrix - Work")
                    {

                        ToolTipML = ESP = 'Indica si el proyecto es padre o �nico (proyecto matr�z), o si son proyectos hijos de un proyecto matr�z (proyecto trabajo). Si define proyectos hijos, estos autom�ticamente se marcan como proyectos de trabajo.';
                        Editable = FALSE;
                    }
                    field("No. of Matrix Job it Belongs"; rec."No. of Matrix Job it Belongs")
                    {

                        ToolTipML = ESP = 'Cuantos proyectos hijo o de trabajdo tiene el proyecto matr�z';
                        BlankZero = true;
                    }
                    field("Matrix Job it Belongs"; rec."Matrix Job it Belongs")
                    {

                        ToolTipML = ESP = 'Proyecto matriz al que pertenece este proyecto de trabajo.';
                        Editable = FALSE;
                    }
                    field("Allocation Item by Unfold"; rec."Allocation Item by Unfold")
                    {

                        ToolTipML = ESP = 'Si marcamos imputaci�n por desglose S�LO ser� posible la imputaci�n en los Subproyectos y no en el Proyecto Matriz, si no est� marcado podemos imputar tanto en los Subproyectos como en el Proyecto Matriz indiferentemente';
                        Editable = edAIBUnfold;
                    }

                }

            }
            group("group329")
            {

                CaptionML = ENU = 'Duration', ESP = 'Duraci�n y licitaci�n';
                Editable = InternalStatusEditable;
                field("Starting Date"; rec."Starting Date")
                {

                }
                field("Ending Date"; rec."Ending Date")
                {

                }
                field("Reestimation Last Date"; rec."Reestimation Last Date")
                {

                }
                field("Init Real Date Construction"; rec."Init Real Date Construction")
                {

                }
                field("End Prov. Date Construction"; rec."End Prov. Date Construction")
                {

                }
                field("End Real Construction Date"; rec."End Real Construction Date")
                {

                    Enabled = Completado;
                }
                field("Reception Date"; rec."Reception Date")
                {

                }
                field("Job Guarrantee Date Rec.INIT"; rec."Job Guarrantee Date INIT")
                {

                }
                field("Job Guarrantee Period"; rec."Job Guarrantee Period")
                {

                }
                field("Job Guarrantee Date End"; rec."Job Guarrantee Date End")
                {

                }
                group("group340")
                {

                    CaptionML = ESP = 'Licitacion';
                    field("Bidding Date"; rec."Bidding Date")
                    {

                    }
                    field("Final Allocation Date"; rec."Final Allocation Date")
                    {

                    }
                    field("Contract Sign Date"; rec."Contract Sign Date")
                    {

                    }
                    field("Doc. Verifying Readiness Date"; rec."Doc. Verifying Readiness Date")
                    {

                    }
                    field("Execution Official Term"; rec."Execution Official Term")
                    {

                    }
                    field("Warranty Term"; rec."Warranty Term")
                    {

                    }
                    field("Guarantee Definitive %"; rec."Guarantee Definitive %")
                    {

                        Editable = edGuaranteeDef;

                        ; trigger OnAssistEdit()
                        BEGIN
                            //JAV 26/08/19: - Solicitud de garant�a
                            Guarantees.SolicitudDefinitiva(Rec, TRUE);
                            Rec.CALCFIELDS("Guarantee Definitive Job");
                        END;


                    }
                    field("Guarantee Definitive"; rec."Guarantee Definitive")
                    {

                        Editable = edGuaranteeDef;
                    }
                    field("Guarantee Definitive Job"; rec."Guarantee Definitive Job")
                    {

                    }

                }

            }
            group("group350")
            {

                CaptionML = ENU = 'Foreign Trade', ESP = 'Internacional';
                Visible = FALSE;
                Editable = InternalStatusEditable;
                field("Language Code"; rec."Language Code")
                {

                }

            }
            group("group352")
            {

                CaptionML = ENU = 'JV', ESP = 'UTE';
                Editable = InternalStatusEditable;
                group("group353")
                {

                    CaptionML = ENU = 'Data JV In MAtrix Company', ESP = 'Datos UTE en empresa matriz';
                    field("% JV Share"; rec."% JV Share")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }

                }
                group("group355")
                {

                    CaptionML = ENU = 'In formative Data', ESP = 'Datos informativos';
                    field("Partner JV"; rec."Partner JV")
                    {

                    }
                    field("% Total Share JV(O+V)"; rec."% Total Share JV(O+V)")
                    {

                        Visible = false;
                    }
                    field("Dimensions JV Code"; rec."Dimensions JV Code")
                    {

                        Visible = false;
                    }
                    field("Worksheet Type"; rec."Worksheet Type")
                    {

                        Visible = false;
                    }
                    field("Rate Repercussion Job Code"; rec."Rate Repercussion Job Code")
                    {

                        Visible = FALSE;
                    }
                    field("Rate Repercussion Cost Unit"; rec."Rate Repercussion Cost Unit")
                    {

                        Visible = FALSE;
                    }
                    field("Month Closing JV"; rec."Month Closing JV")
                    {

                        Visible = false;
                    }

                }
                group("group363")
                {

                    CaptionML = ESP = 'UTE Origen';
                    field("Company UTE"; rec."Company UTE")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Job UTE"; rec."Job UTE")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }
                    field("BaseProdUTE"; BaseProdUTE)
                    {

                        CaptionML = ESP = 'Producci�n prevista UTE';
                        Editable = false;
                    }
                    field("BaseActualProdUTE"; BaseActualProdUTE)
                    {

                        CaptionML = ESP = 'Producci�n ejecutada UTE';
                        Editable = false;
                    }
                    field("ProdUTE"; ProdUTE)
                    {

                        CaptionML = ENU = '"Estimated UTE Production "', ESP = 'Producci�n Participada';
                        Editable = false;
                    }
                    field("ActualProdUTE"; ActualProdUTE)
                    {

                        CaptionML = ENU = '"JV Actual Production Amount "', ESP = 'Producci�n ejecutada Participada';
                        Editable = false;
                    }

                }
                group("group370")
                {

                    CaptionML = ENU = 'Data JV In Company JV', ESP = 'Datos UTE en empresa UTE';
                    Visible = FALSE;
                    field("Piecework of CD integrat. JV"; rec."Piecework of CD integrat. JV")
                    {

                    }
                    field("Piecework of CI intergrat. JV"; rec."Piecework of CI intergrat. JV")
                    {

                    }

                }

            }
            group("group373")
            {

                CaptionML = ENU = 'Job Data', ESP = 'Datos Varios Obra';
                Editable = InternalStatusEditable;
                field("Branch Manager Name"; rec."Branch Manager Name")
                {

                }
                field("Architect Code"; rec."Architect Code")
                {

                }
                field("Architect"; rec."Architect")
                {

                }
                field("Insurance Company"; rec."Insurance Company")
                {

                }
                field("Policy No."; rec."Policy No.")
                {

                }
                field("License Status"; rec."License Status")
                {

                }
                field("Job License Date"; rec."Job License Date")
                {

                }
                field("License Dossier No."; rec."License Dossier No.")
                {

                }
                field("Policy Starting Date"; rec."Policy Starting Date")
                {

                }
                field("Policy Ending Date"; rec."Policy Ending Date")
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
                    CaptionML = ENU = 'SubJobs', ESP = 'Subproyectos';
                    RunObject = Page 7207293;
                    RunPageView = SORTING("Job Matrix - Work", "Matrix Job it Belongs")
                                  WHERE("Job Matrix - Work" = CONST("Work"));
                    RunPageLink = "Matrix Job it Belongs" = FIELD("No.");
                    Enabled = edSubproyectos;
                    Image = ServiceCode;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Contract Card', ESP = 'Ficha contrato';
                    Image = EmployeeAgreement;

                    trigger OnAction()
                    VAR
                        DocumentDataContracts: Record 7207391;
                        EntryNo: Code[20];
                    BEGIN
                        //JAV 30/10/21: - QB 1.09.26 CAmbio la forma de obtener los Datos del proyecto para impresi�n del contrato
                        IF (NOT DocumentDataContracts.GET(Rec."No.", '')) THEN BEGIN
                            DocumentDataContracts.INIT;
                            DocumentDataContracts."Job No." := Rec."No.";
                            DocumentDataContracts."Contract No." := '';
                            DocumentDataContracts.INSERT;
                        END;
                        DocumentDataContracts."Job Name" := Rec.Description + ' ' + Rec."Description 2";//Actualizamos los datos del documento siempre por si han cambiado

                        DocumentDataContracts.RESET;
                        DocumentDataContracts.SETRANGE("Job No.", rec."No.");
                        DocumentDataContracts.SETRANGE("Contract No.", '');
                        PAGE.RUN(PAGE::"Job Contract Card", DocumentDataContracts);
                    END;


                }
                action("action4")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Job"), "No." = FIELD("No.");
                    Image = ViewComments;
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
                    CaptionML = ENU = 'Online Map', ESP = 'Mapa Online';
                    Image = NewExchangeRate;

                    trigger OnAction()
                    BEGIN
                        rec.DisplayMap;
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Quality', ESP = 'Calidad';
                    RunObject = Page 7207568;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = TransferFunds;
                }
                action("action8")
                {
                    CaptionML = ESP = 'Garant�a';
                    RunObject = Page 7207653;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = Voucher;
                }

            }
            group("group12")
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

                        //Q13639 +
                        SetCurrencyFB;
                        //Q13639 -
                    END;


                }
                action("Ver Agrupado")
                {

                    CaptionML = ENU = 'Grouped view', ESP = 'Ver Agrupado';
                    Enabled = enMatrix;
                    Image = Group;

                    trigger OnAction()
                    BEGIN
                        //Q13639 +
                        ShowGrouped := (NOT ShowGrouped);
                        SetCurrencyFB;
                        //Q13639 -
                    END;


                }

            }
            group("group16")
            {
                CaptionML = ENU = 'Planning', ESP = 'Presupuestos';
                action("action12")
                {
                    CaptionML = ENU = 'Costs Budgets', ESP = 'Ppto Costes';
                    RunObject = Page 7207598;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = CopyLedgerToBudget;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Budget Sales - Certifications', ESP = 'Ppto Venta';
                    RunObject = Page 7207600;
                    RunPageView = SORTING("Job No.", "No.");
                    RunPageLink = "Job No." = FIELD("No."), "Budget Filter" = FIELD("Current Piecework Budget");
                    Image = Replan;
                }
                action("InvoiceMilestones")
                {

                    CaptionML = ENU = 'Invoice Milestones', ESP = 'Hitos Facturaci�n';
                    RunObject = Page 7207329;
                    RunPageLink = "Job No." = FIELD("No.");
                    Enabled = enMilestones;
                    Image = JobPrice;
                }
                action("action15")
                {
                    CaptionML = ENU = 'Budgets per A.C.', ESP = 'Presupuesto por C.A.';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        DimJob: Code[20];
                        DimBudgetJob: Code[20];
                        DimReest: Code[20];
                        BudgetbyCA: Page 7207279;
                    BEGIN
                        QBPageSubscriber.seeBudgetByCA(Rec, FALSE);
                    END;


                }
                action("action16")
                {
                    CaptionML = ENU = 'Planning Milestones', ESP = 'Hitos planificaci�n';
                    RunObject = Page 7207467;
                    RunPageLink = "Job No." = FIELD("No.");
                    Visible = FALSE;
                    Image = Completed;
                }
                action("action17")
                {
                    CaptionML = ENU = 'Costs Planning per Milestone', ESP = 'Planificaci�n costes por hitos';
                    Visible = FALSE;
                    Image = PayrollStatistics;

                    trigger OnAction()
                    VAR
                        JobConceptPlan: Page 7207468;
                    BEGIN
                        CLEAR(JobConceptPlan);
                        JobConceptPlan.SetJob(rec."No.");
                        JobConceptPlan.RUNMODAL;
                    END;


                }
                action("action18")
                {
                    CaptionML = ENU = 'Planning Assign', ESP = 'Asignar planificaci�n';
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
                action("action19")
                {
                    CaptionML = ENU = 'Apply Target Coeficient', ESP = 'Aplicar coeficiente objetivo';
                    Image = UpdateUnitCost;
                    trigger OnAction()
                    VAR
                        DataCostByPiecework: Record 7207387;
                        Text50001: TextConst ENU = 'Finished.', ESP = 'Proceso terminado.';
                        ConfirmText: TextConst ENU = 'Do you want to apply target coeficient?', ESP = '�Desea aplicar el coeficiente objetivo?';
                        ErrorText: TextConst ENU = 'Canceled.', ESP = 'Proceso cancelado por el usuario.';
                    BEGIN
                        //QPE6449

                        IF NOT CONFIRM(ConfirmText) THEN
                            ERROR(ErrorText);

                        DataCostByPiecework.RESET;
                        DataCostByPiecework.SETRANGE("Job No.", Rec."No.");
                        IF DataCostByPiecework.FINDSET THEN BEGIN
                            REPEAT
                                DataCostByPiecework.VALIDATE("Direc Unit Cost", DataCostByPiecework."Direc Unit Cost" + ((Rec."Target Coeficient" / 100) * DataCostByPiecework."Direc Unit Cost"));
                                DataCostByPiecework.MODIFY(TRUE);
                            UNTIL DataCostByPiecework.NEXT = 0;
                        END;

                        MESSAGE(Text50001);
                    END;
                }

            }
            group("Reestimations")
            {

                CaptionML = ENU = 'Reestimations', ESP = 'Reestimaciones';
                Visible = FALSE;
                Image = ApplicationWorksheet;
                action("action20")
                {
                    CaptionML = ENU = 'Reestmation per Concept', ESP = 'Reestimaci�n por concepto';
                    Visible = FALSE;

                    trigger OnAction()
                    VAR
                        ReestimationHeader: Record 7207315;
                    BEGIN
                        Rec.TESTFIELD("Management By Production Unit", FALSE);
                        ReestimationHeader.RESET;
                        ReestimationHeader.FILTERGROUP(2);
                        ReestimationHeader.SETRANGE("Job No.", rec."No.");
                        ReestimationHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Reestimation List", ReestimationHeader);
                    END;


                }
                action("action21")
                {
                    CaptionML = ENU = 'Hist. Reestimation per Concept', ESP = 'Hist. reestimaci�n por concepto';
                    Visible = FALSE;

                    trigger OnAction()
                    VAR
                        HistReestimationHeader: Record 7207317;
                    BEGIN
                        HistReestimationHeader.RESET;
                        HistReestimationHeader.FILTERGROUP(2);
                        HistReestimationHeader.SETRANGE("Job No.", rec."No.");
                        HistReestimationHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Hist. Reestimation hdr. List", HistReestimationHeader);
                    END;


                }

            }
            group("group28")
            {
                CaptionML = ENU = 'Planning', ESP = 'Planificaci�n';
                group("group29")
                {
                    CaptionML = ENU = 'Resource Planning', ESP = 'Planificaci�n de recursos';
                    Visible = FALSE;
                    Image = ResourcePlanning;
                    action("action22")
                    {
                        CaptionML = ENU = 'Resource Allocated per Job', ESP = 'Asign. recursos por proyecto';
                        RunObject = Page 221;
                        Visible = FALSE;
                        Image = Resource;
                    }
                    action("action23")
                    {
                        CaptionML = ENU = 'Res. Gr. Allocate per Job', ESP = 'Asign. fams. recursos proyectos';
                        RunObject = Page 228;
                        Visible = FALSE;
                        Image = ResourceGroup;
                    }
                    action("action24")
                    {
                        CaptionML = ENU = 'Invoicing Milestone', ESP = 'Hitos facturaci�n';
                        Visible = FALSE;
                        Image = CreateInteraction;

                        trigger OnAction()
                        BEGIN
                            QBPageSubscriber.TJob_SeeMilestone(Rec);
                        END;


                    }

                }

            }
            group("group33")
            {
                CaptionML = ENU = 'WIP', ESP = 'WIP';
                Visible = FALSE;
                action("action25")
                {
                    CaptionML = ENU = 'Calcultae WIP', ESP = 'Calcular WIP';
                    Description = 'WIP';
                    Visible = FALSE;
                    Image = CalculateWIP;

                    trigger OnAction()
                    VAR
                        Job: Record 167;
                    BEGIN
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Calculate WIP", TRUE, FALSE, Job);
                    END;


                }
                action("action26")
                {
                    CaptionML = ENU = 'Post WIP to G/L', ESP = 'Resgistra WIP en C/G';
                    Visible = FALSE;
                    Image = Post;

                    trigger OnAction()
                    VAR
                        Job: Record 167;
                    BEGIN
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job)
                    END;


                }
                group("group36")
                {
                    CaptionML = ENU = 'Entries WIP', ESP = 'Movimientos WIP';
                    Visible = FALSE;
                    Image = WIPEntries;
                    action("action27")
                    {
                        CaptionML = ENU = 'WIP Entries', ESP = 'Movimientos WIP';
                        RunObject = Page 1008;
                        RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                        RunPageLink = "Job No." = FIELD("No.");
                        Visible = FALSE;
                        Image = WIPEntries;
                    }
                    action("action28")
                    {
                        CaptionML = ENU = 'WIP G/L Entries', ESP = 'Movs. contabilidad WIP';
                        RunObject = Page 1009;
                        RunPageView = SORTING("Job No.");
                        RunPageLink = "Job No." = FIELD("No.");
                        Visible = FALSE;
                        Image = WIPEntries;
                    }

                }

            }
            group("group39")
            {
                CaptionML = ENU = '&Prices', ESP = '&Precios';
                Visible = FALSE;
                group("group40")
                {
                    CaptionML = ENU = 'Prices', ESP = 'Precios';
                    Image = PriceAdjustment;
                    action("action29")
                    {
                        CaptionML = ENU = 'Price', ESP = 'Precios';
                        RunObject = Page 204;
                        RunPageLink = "Job No." = FIELD("No.");
                        Image = SalesPrices;
                    }
                    action("action30")
                    {
                        CaptionML = ENU = 'REsource', ESP = 'Recurso';
                        RunObject = Page 1011;
                        RunPageLink = "Job No." = FIELD("No.");
                    }
                    action("action31")
                    {
                        CaptionML = ENU = 'Item', ESP = 'Item';
                        RunObject = Page 1012;
                        RunPageLink = "Job No." = FIELD("No.");
                    }
                    action("action32")
                    {
                        CaptionML = ENU = 'G/L Account', ESP = 'Cuenta';
                        RunObject = Page 1013;
                        RunPageLink = "Job No." = FIELD("No.");
                    }

                }

            }
            group("group45")
            {
                CaptionML = ENU = 'Cash', ESP = 'Tesorer�a';
                group("group46")
                {
                    CaptionML = ENU = 'Treasury', ESP = 'Tesorer�a';
                    Image = CashFlow;
                    action("action33")
                    {
                        CaptionML = ENU = 'Treasury Rules', ESP = 'Reglas tesorer�a';
                        RunObject = Page 7207473;
                        RunPageView = SORTING("Job No.", "Analytic Concept");
                        RunPageLink = "Job No." = FIELD("No.");
                        Image = CashFlowSetup;
                    }
                    action("action34")
                    {
                        CaptionML = ENU = 'Update Cash Budget', ESP = 'Actualizar Ppto. de tesorer�a';
                        // RunObject = Report 7022906;
                        Visible = FALSE;
                        Image = CalculateCost;
                    }

                }

            }
            group("group49")
            {
                CaptionML = ENU = 'Rentals', ESP = 'Alquileres';
                // ActionContainerType =NewDocumentItems ;
                group("group50")
                {
                    CaptionML = ENU = 'Rent&als Managements', ESP = 'Gesti�n &Alquileres';
                    Image = ResourcePrice;
                    action("action35")
                    {
                        Ellipsis = true;
                        CaptionML = ENU = 'Associated Contracts', ESP = 'Contratos asociados';
                        RunObject = Page 7207436;
                        RunPageLink = "Job No." = FIELD("No.");
                    }
                    action("action36")
                    {
                        Ellipsis = true;
                        CaptionML = ENU = 'Documents Sending', ESP = 'Documentos env�o';
                        RunObject = Page 7207435;
                        RunPageLink = "Customer/Vendor No." = FIELD("Bill-to Customer No."), "Job No." = FIELD("No.");
                    }
                    action("action37")
                    {
                        CaptionML = ENU = 'Return Document', ESP = 'Documento devoluci�n';
                        RunObject = Page 7207426;
                        RunPageLink = "Customer/Vendor No." = FIELD("Bill-to Customer No."), "Job No." = FIELD("No.");
                    }
                    action("action38")
                    {
                        CaptionML = ENU = 'Document Utilization', ESP = 'Documento utilizaci�n';
                    }
                    action("action39")
                    {
                        CaptionML = ENU = 'History Documents Entry', ESP = 'Hist�ricos doc. entrada';
                        RunObject = Page 7207431;
                        RunPageLink = "Job No." = FIELD("No.");
                    }
                    action("action40")
                    {
                        CaptionML = ENU = 'History Doc. Return', ESP = 'Hist�ricos doc. devoluci�n';
                        RunObject = Page 7207415;
                        RunPageLink = "Job No." = FIELD("No.");
                    }
                    action("action41")
                    {
                        CaptionML = ENU = 'Historical Documents Utilization', ESP = 'Hist�ricos doc. utilizaci�n';
                    }

                }

            }
            group("group58")
            {
                CaptionML = ENU = 'Log', ESP = 'Log';
                // ActionContainerType =NewDocumentItems ;
                action("action42")
                {
                    CaptionML = ENU = 'Copy Job', ESP = 'Registro de cambios';
                    RunObject = Page 7207659;
                    RunPageLink = "Job" = FIELD("No.");
                    Image = Log;

                    trigger OnAction()
                    VAR
                        ConfigTemplateManagement: Codeunit 8612;
                        RecRef: RecordRef;
                    BEGIN
                    END;


                }

            }

        }
        area(Processing)
        {
            Description = 'Job Management';
            action("action43")
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
            action("action44")
            {
                CaptionML = ENU = 'Pending Tasks', ESP = 'Tareas pendientes';
                RunObject = Page 5096;
                RunPageView = SORTING("Opportunity No.", "Date", "Closed")
                                  ORDER(Ascending)
                                  WHERE("Status" = FILTER(<> "Completed"), "System To-do Type" = CONST("Organizer"));
                RunPageLink = "Opportunity No." = FIELD("Opportunity Code");
                Visible = FALSE;
                Image = ItemTrackingLedger;
            }
            group("group63")
            {
                CaptionML = ENU = 'Purchase', ESP = 'Compras';
                action("action45")
                {
                    CaptionML = ENU = 'Material requirements', ESP = 'Necesidades de materiales';
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
                group("group65")
                {
                    CaptionML = ENU = 'Documents', ESP = 'Documentos';
                    Image = Agreement;
                    action("action46")
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
                    action("action47")
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
                    action("action48")
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
                    action("action49")
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
                    action("action50")
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
                    action("action51")
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
                    action("action52")
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
                group("group73")
                {
                    CaptionML = ENU = 'Historical', ESP = 'Hist�ricos';
                    Image = JobRegisters;
                    action("action53")
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
                    action("action54")
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
                    action("action55")
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
                    action("action56")
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
                    action("action57")
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
                    action("action58")
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
                action("action59")
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
            group("group81")
            {
                CaptionML = ENU = 'Cost Allocat&ions', ESP = '&Imputaciones de costes';
                action("action60")
                {
                    CaptionML = ENU = 'Delivery Notes', ESP = 'Albaranes de almac�n';
                    Image = NewShipment;

                    trigger OnAction()
                    VAR
                        OutputShipmentHeader: Record 7207308;
                    BEGIN
                        OutputShipmentHeader.RESET;
                        OutputShipmentHeader.FILTERGROUP(2);
                        OutputShipmentHeader.SETRANGE("Job No.", rec."No.");
                        OutputShipmentHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Output Shipment List", OutputShipmentHeader);
                    END;


                }
                action("action61")
                {
                    CaptionML = ENU = 'Parts of Job', ESP = 'Partes de trabajo';
                    Image = CalculateRemainingUsage;

                    trigger OnAction()
                    VAR
                        WorksheetLines: Record 7207291;
                        WorksheetLinesList: Page 7207275;
                        WorksheetHeader: Record 7207290;
                        WorkSheetHeaderlist: Page 7207271;
                    begin

                        WorksheetLines.RESET;
                        WorksheetLines.FILTERGROUP(2);
                        WorksheetLines.SETRANGE("Job No.", rec."No.");
                        WorksheetLines.FILTERGROUP(0);

                        CLEAR(WorksheetLinesList);
                        WorksheetLinesList.SETTABLEVIEW(WorksheetLines);
                        WorksheetLinesList.RUN;

                        //JMMA 041220
                        WorksheetHeader.RESET;
                        WorksheetHeader.FILTERGROUP(2);
                        WorksheetHeader.SETRANGE("Job No.", rec."No.");
                        WorksheetHeader.FILTERGROUP(0);
                        CLEAR(WorkSheetHeaderlist);
                        WorkSheetHeaderlist.SETTABLEVIEW(WorksheetHeader);
                        WorkSheetHeaderlist.RUN;
                    END;


                }
                group("group84")
                {
                    CaptionML = ENU = 'Documents', ESP = 'Documentos';
                    Image = Agreement;
                    action("action62")
                    {
                        CaptionML = ENU = 'Regulation of Occurrences', ESP = 'Regularizaci�n de existencias';

                        trigger OnAction()
                        VAR
                            HeaderRegularizationStock: Record 7207408;
                        BEGIN
                            Rec.TESTFIELD("Job Location");
                            HeaderRegularizationStock.RESET;
                            HeaderRegularizationStock.FILTERGROUP(2);
                            HeaderRegularizationStock.SETRANGE("Location Code", rec."Job Location");
                            HeaderRegularizationStock.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Regularization Stock List", HeaderRegularizationStock);
                        END;


                    }
                    action("action63")
                    {
                        CaptionML = ENU = 'Parts of use of Rental Elements', ESP = 'Partes de utiliz. elementos alq.';

                        trigger OnAction()
                        VAR
                            WorksheetHeader: Record 7207290;
                            QBWorksheetList: Page 7207271;
                        BEGIN
                            WorksheetHeader.RESET;
                            WorksheetHeader.FILTERGROUP(2);
                            WorksheetHeader.SETRANGE("Sheet Type", WorksheetHeader."Sheet Type"::"By Job");
                            WorksheetHeader.SETRANGE("No. Resource /Job", rec."No.");
                            WorksheetHeader.SETRANGE("Rental Machinery", TRUE);
                            WorksheetHeader.FILTERGROUP(0);
                            CLEAR(QBWorksheetList);

                            QBWorksheetList.SETTABLEVIEW(WorksheetHeader);
                            QBWorksheetList.RUN;
                        END;


                    }
                    action("action64")
                    {
                        CaptionML = ENU = 'Indirect Cost Allocations', ESP = 'Imputaci�n costes indirectos';

                        trigger OnAction()
                        VAR
                            CostsheetHeader: Record 7207433;
                        BEGIN
                            CostsheetHeader.RESET;
                            CostsheetHeader.FILTERGROUP(2);
                            CostsheetHeader.SETRANGE("Job No.", rec."No.");
                            CostsheetHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Costsheet List", CostsheetHeader);
                        END;


                    }

                }
                group("group88")
                {
                    CaptionML = ENU = 'Posted', ESP = 'Hist�ricos';
                    Image = JobRegisters;
                    action("action65")
                    {
                        CaptionML = ENU = 'Warehouse Shipment history', ESP = 'Hist�rico de albaranes de almac�n';

                        trigger OnAction()
                        VAR
                            PostedOutputShipmentHeader: Record 7207310;
                        BEGIN
                            PostedOutputShipmentHeader.RESET;
                            PostedOutputShipmentHeader.FILTERGROUP(2);
                            PostedOutputShipmentHeader.SETRANGE("Job No.", rec."No.");
                            PostedOutputShipmentHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Posted Output Shipment List", PostedOutputShipmentHeader);
                        END;


                    }
                    action("action66")
                    {
                        CaptionML = ENU = 'Hist. Part of Job', ESP = 'Hist�rico partes de trabajo';

                        trigger OnAction()
                        VAR
                            WorksheetHeaderHist: Record 7207292;
                        BEGIN
                            WorksheetHeaderHist.RESET;
                            WorksheetHeaderHist.FILTERGROUP(2);
                            WorksheetHeaderHist.SETRANGE("Sheet Type", WorksheetHeaderHist."Sheet Type"::"By Job");
                            WorksheetHeaderHist.SETRANGE("No. Resource /Job", rec."No.");
                            WorksheetHeaderHist.SETRANGE("Rental Machinery", FALSE);
                            WorksheetHeaderHist.FILTERGROUP(0);
                            //JMMA 041220 PAGE.RUNMODAL(PAGE::"QB Tables Automatic Dimensions",WorksheetHeaderHist);
                            PAGE.RUNMODAL(PAGE::"QB Worksheet List Hist.", WorksheetHeaderHist);
                        END;


                    }
                    action("action67")
                    {
                        CaptionML = ENU = 'History of Parts of Use of Leased Elements', ESP = 'Hist�rcio de parte util. elem. alq';

                        trigger OnAction()
                        VAR
                            WorksheetHeaderHist: Record 7207292;
                        BEGIN
                            WorksheetHeaderHist.RESET;
                            WorksheetHeaderHist.FILTERGROUP(2);
                            WorksheetHeaderHist.SETRANGE("Sheet Type", WorksheetHeaderHist."Sheet Type"::"By Job");
                            WorksheetHeaderHist.SETRANGE("No. Resource /Job", rec."No.");
                            WorksheetHeaderHist.SETRANGE("Rental Machinery", TRUE);
                            WorksheetHeaderHist.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"QB Worksheet List Hist.", WorksheetHeaderHist);
                        END;


                    }
                    action("action68")
                    {
                        CaptionML = ENU = 'Hist. Indirect Cost Allocations', ESP = 'Hist. imputaciones costes indirectos';

                        trigger OnAction()
                        VAR
                            CostsheetHeaderHist: Record 7207435;
                        BEGIN
                            CostsheetHeaderHist.RESET;
                            CostsheetHeaderHist.FILTERGROUP(2);
                            CostsheetHeaderHist.SETRANGE("Job No.", rec."No.");
                            CostsheetHeaderHist.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Costsheet Hist. List", CostsheetHeaderHist);
                        END;


                    }

                }

            }
            group("Production")
            {

                CaptionML = ENU = 'Production', ESP = 'Ejecuci�n Material';
                action("action69")
                {
                    CaptionML = ENU = 'Value Production Relations', ESP = 'Relaciones valoradas';
                    Image = SuggestPayment;

                    trigger OnAction()
                    VAR
                        ProdMeasureHeader: Record 7207399;
                    BEGIN
                        ProdMeasureHeader.RESET;
                        ProdMeasureHeader.FILTERGROUP(2);
                        ProdMeasureHeader.SETRANGE("Job No.", rec."No.");
                        ProdMeasureHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Prod. Measure List", ProdMeasureHeader);
                    END;


                }
                action("action70")
                {
                    CaptionML = ENU = 'Hist. Value Production Relations', ESP = 'Hist. relaciones valoradas';
                    Image = TeamSales;

                    trigger OnAction()
                    VAR
                        HistProdMeasureHeader: Record 7207401;
                    BEGIN
                        HistProdMeasureHeader.RESET;
                        HistProdMeasureHeader.FILTERGROUP(2);
                        HistProdMeasureHeader.SETRANGE("Job No.", rec."No.");
                        HistProdMeasureHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Post. Prod. Measurement List", HistProdMeasureHeader);
                    END;


                }

            }
            group("group96")
            {
                CaptionML = ENU = '&Sales', ESP = 'Medici�n Venta';
                action("action71")
                {
                    CaptionML = ENU = '&Measurs', ESP = '&Mediciones';
                    Image = BinContent;

                    trigger OnAction()
                    VAR
                        MeasurementHeader: Record 7207336;
                    BEGIN
                        MeasurementHeader.RESET;
                        MeasurementHeader.FILTERGROUP(2);
                        MeasurementHeader.SETRANGE("Document Type", MeasurementHeader."Document Type"::Measuring);
                        MeasurementHeader.SETRANGE("Job No.", rec."No.");
                        MeasurementHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Measurement List", MeasurementHeader);
                    END;


                }
                action("action72")
                {
                    CaptionML = ENU = 'Measure Hisory', ESP = 'Hist�rico de mediciones';
                    Image = ServiceOrderSetup;

                    trigger OnAction()
                    VAR
                        HistMeasurements: Record 7207338;
                    BEGIN
                        HistMeasurements.RESET;
                        HistMeasurements.FILTERGROUP(2);
                        HistMeasurements.SETRANGE("Job No.", rec."No.");
                        HistMeasurements.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Measure Post List", HistMeasurements);
                    END;


                }

            }
            group("group99")
            {
                CaptionML = ENU = '&Sales', ESP = 'Certificaci�n y Facturaci�n';
                action("action73")
                {
                    CaptionML = ENU = 'Certifications', ESP = 'Certificaciones';
                    Image = Segment;

                    trigger OnAction()
                    VAR
                        MeasurementHeader: Record 7207336;
                    BEGIN
                        MeasurementHeader.RESET;
                        MeasurementHeader.FILTERGROUP(2);
                        MeasurementHeader.SETRANGE("Document Type", MeasurementHeader."Document Type"::Certification);
                        MeasurementHeader.SETRANGE("Job No.", rec."No.");
                        MeasurementHeader.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Certification List", MeasurementHeader);
                    END;


                }
                action("action74")
                {
                    CaptionML = ENU = 'Certification History', ESP = 'Hist�rico de certificaciones';
                    Image = Document;

                    trigger OnAction()
                    VAR
                        PostCertifications: Record 7207341;
                    BEGIN
                        PostCertifications.RESET;
                        PostCertifications.FILTERGROUP(2);
                        PostCertifications.SETRANGE("Job No.", rec."No.");
                        PostCertifications.FILTERGROUP(0);
                        PAGE.RUNMODAL(PAGE::"Post. Certifications List", PostCertifications);
                    END;


                }
                group("<Action7001298>")
                {

                    CaptionML = ENU = 'Documents', ESP = 'Documentos';
                    Image = Agreement;
                    action("action75")
                    {
                        CaptionML = ENU = 'Inviced', ESP = 'Facturas';
                        Image = Invoice;

                        trigger OnAction()
                        VAR
                            SalesHeader: Record 36;
                        BEGIN
                            SalesHeader.RESET;
                            SalesHeader.FILTERGROUP(2);
                            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
                            SalesHeader.SETRANGE("QB Job No.", rec."No.");
                            SalesHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Sales List", SalesHeader);
                        END;


                    }
                    action("action76")
                    {
                        CaptionML = ENU = 'Credit Memo', ESP = 'Abonos';
                        Image = CreditMemo;

                        trigger OnAction()
                        VAR
                            SalesHeader: Record 36;
                        BEGIN
                            SalesHeader.RESET;
                            SalesHeader.FILTERGROUP(2);
                            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Credit Memo");
                            SalesHeader.SETRANGE("QB Job No.", rec."No.");
                            SalesHeader.FILTERGROUP(0);

                            //-Q20362
                            //PAGE.RUNMODAL(PAGE::"Sales List",SalesHeader);
                            PAGE.RUNMODAL(PAGE::"Sales Credit Memos", SalesHeader);
                            //
                        END;


                    }

                }
                group("group105")
                {
                    CaptionML = ENU = 'Historical', ESP = 'Hist�ricos';
                    Image = JobRegisters;
                    action("action77")
                    {
                        CaptionML = ENU = 'Billing History', ESP = 'Hist�rico de facturaci�n';
                        Image = Invoice;

                        trigger OnAction()
                        VAR
                            SalesInvoiceHeader: Record 112;
                        BEGIN
                            SalesInvoiceHeader.RESET;
                            SalesInvoiceHeader.FILTERGROUP(2);
                            SalesInvoiceHeader.SETRANGE("Job No.", rec."No.");
                            SalesInvoiceHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Posted Sales Invoices", SalesInvoiceHeader)
                        END;


                    }
                    action("action78")
                    {
                        CaptionML = ENU = 'History of Credit Memo', ESP = 'Hist�rico de abono';
                        Image = CreditMemo;

                        trigger OnAction()
                        VAR
                            SalesCrMemoHeader: Record 114;
                        BEGIN
                            SalesCrMemoHeader.RESET;
                            SalesCrMemoHeader.FILTERGROUP(2);
                            SalesCrMemoHeader.SETRANGE("Job No.", rec."No.");
                            SalesCrMemoHeader.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memos", SalesCrMemoHeader);
                        END;


                    }

                }

            }
            group("group108")
            {
                CaptionML = ENU = 'Service Orders', ESP = 'Pedidos de Servicio';
                Visible = seeServiceOrders;
                Image = JobRegisters;
                action("SO_Created")
                {

                    CaptionML = ENU = 'Service Orders', ESP = 'Pedidos Creados';
                    RunObject = Page 7207050;
                    RunPageView = SORTING("No.");
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ViewServiceOrder;
                }
                action("PriceReviews")
                {

                    CaptionML = ENU = 'Price reviews', ESP = 'Revisiones precio';
                    RunObject = Page 7207053;
                    RunPageLink = "Job No." = FIELD("No.");
                    Enabled = enRevPrice;
                    Image = PriceAdjustment;
                }
                group("group111")
                {
                    CaptionML = ESP = 'Pedidos';
                    Image = ServiceCode;
                    action("SO_Posted")
                    {

                        CaptionML = ENU = 'Service Orders Posted', ESP = 'Pedidos Registrados';
                        RunObject = Page 7207059;
                        RunPageView = SORTING("No.")
                                  WHERE("Status" = CONST("Finished"));
                        RunPageLink = "Job No." = FIELD("No.");
                        Visible = ShowQBCustPrepmt;
                        Image = PostedServiceOrder;
                    }
                    action("SO_RP_Facturacion")
                    {

                        CaptionML = ESP = 'Fact. Autom�tica';
                        Image = CoupledPurchaseInvoice;

                        trigger OnAction()
                        VAR
                            // QBInvoiceServiceOrders: Report 7207448;
                        BEGIN
                            //JAV 04/10/21: - QB 1.09.21 Pedidos de servicio
                            // QBInvoiceServiceOrders.SetJobNo(Rec."No.");
                            // QBInvoiceServiceOrders.RUN;
                        END;


                    }
                    action("SO_Invoiced")
                    {

                        CaptionML = ENU = 'Service Orders Inv.', ESP = 'Pedidos Facturados';
                        RunObject = Page 7207059;
                        RunPageView = SORTING("No.")
                                  WHERE("Status" = CONST("Invoiced"));
                        RunPageLink = "Job No." = FIELD("No.");
                        Visible = ShowQBCustPrepmt;
                        Image = ServiceLedger;
                    }

                }
                group("group115")
                {
                    CaptionML = ESP = 'Informes';
                    Image = PrintReport;
                    action("SO_RP_VC")
                    {

                        CaptionML = ESP = 'Inf. Ventas/Coste';
                        Image = Report;

                        trigger OnAction()
                        VAR
                            QBServiceOrderHeader: Record 7206966;
                            // QBExpInvServiceOrder: Report 7207446;/
                        BEGIN
                            //JAV 04/10/21: - QB 1.09.21 Pedidos de servicio
                            Rec.TESTFIELD("No.");

                            QBServiceOrderHeader.RESET;
                            QBServiceOrderHeader.SETRANGE("Job No.", Rec."No.");

                            // Q16330 EPV 11/02/22 : Opci�n por defecto En Proceso
                            //QBServiceOrderHeader.SETFILTER(Status, '%1', QBServiceOrderHeader.Status::Pending);
                            QBServiceOrderHeader.SETFILTER(Status, '%1', QBServiceOrderHeader.Status::"In Process");
                            //-->

                            // CLEAR(QBExpInvServiceOrder);
                            // QBExpInvServiceOrder.SETTABLEVIEW(QBServiceOrderHeader);
                            // QBExpInvServiceOrder.RUNMODAL;
                        END;


                    }
                    action("SO_RP_Valoracion")
                    {

                        CaptionML = ESP = 'Inf. Valoraci�n';
                        Image = Report;

                        trigger OnAction()
                        VAR
                            QBServiceOrderHeader: Record 7206966;
                            // QBEvaluationBreakdownList: Report 7207447;
                        BEGIN
                            //JAV 04/10/21: - QB 1.09.21 Pedidos de servicio
                            Rec.TESTFIELD("No.");

                            QBServiceOrderHeader.RESET;
                            QBServiceOrderHeader.SETRANGE("Job No.", Rec."No.");
                            QBServiceOrderHeader.SETFILTER(Status, '%1', QBServiceOrderHeader.Status::Pending);

                            // CLEAR(QBEvaluationBreakdownList);
                            // QBEvaluationBreakdownList.SETTABLEVIEW(QBServiceOrderHeader);
                            // QBEvaluationBreakdownList.RUNMODAL;
                        END;


                    }

                }

            }
            group("group118")
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

            group("group122")
            {
                CaptionML = ENU = 'Job Control', ESP = 'Control del proyecto';
                action("action88")
                {
                    CaptionML = ENU = 'Scorecard', ESP = 'Cuadro de mando';
                    RunObject = Page 7207616;
                    RunPageLink = "No." = FIELD("No."), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter"), "Budget Filter" = FIELD("Current Piecework Budget");
                    Image = AllocatedCapacity;
                }
                action("action89")
                {
                    CaptionML = ENU = 'Production Analysis', ESP = 'An�lisis producci�n';
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
                        TrackingbyPiecework.LOOKUPMODE(TRUE);
                        TrackingbyPiecework.SETTABLEVIEW(DataPieceworkForProduction);
                        TrackingbyPiecework.ReceivesJob(rec."No.", rec."Current Piecework Budget");
                        IF DataPieceworkForProduction.FINDFIRST THEN
                            TrackingbyPiecework.SETRECORD(DataPieceworkForProduction);
                        IF TrackingbyPiecework.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        END;
                    END;


                }
                action("action90")
                {
                    CaptionML = ENU = 'Certification Analysis', ESP = 'An�lisis de certificaci�n';
                    RunObject = Page 7207592;
                    RunPageView = SORTING("Job No.", "Piecework Code");
                    RunPageLink = "Job No." = FIELD("No."), "Budget Filter" = FIELD("Current Piecework Budget");
                    Image = SuggestCustomerBill;
                }
                action("action91")
                {
                    CaptionML = ENU = 'Job Review', ESP = 'Revisi�n proyecto';
                    RunObject = Page 7207351;
                    RunPageLink = "No." = FIELD("No."), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
                    Image = MachineCenterCalendar;
                }
                action("action92")
                {
                    CaptionML = ENU = 'Job Analytical Summary', ESP = 'Resumen anal�tica proyecto';
                    RunObject = Page 7207368;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Zones;
                }
                action("action93")
                {
                    CaptionML = ENU = 'Job Analytical', ESP = 'Anal�tica proyecto';
                    Image = AnalysisView;

                    trigger OnAction()
                    BEGIN
                        AnalyticsJob;
                    END;


                }
                action("Job_Schema")
                {

                    CaptionML = ENU = 'Job Scheme', ESP = 'Esquema de proyecto';
                    Image = ChartOfAccounts;

                    trigger OnAction()
                    BEGIN
                        //JAV 11/03/21: - QB 1.08.23 Se pasa la ejecuci�n de esta acci�n a la CodeUnit "QB - PAGE - Subscriber"
                    END;


                }
                action("action95")
                {
                    CaptionML = ENU = 'Subcontrating Tranking', ESP = 'Seguimiento por c�digo de compras';
                    RunObject = Page 7206971;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ServiceTasks;
                }
                action("action96")
                {
                    CaptionML = ENU = 'Subcontrating Tranking', ESP = 'Seguimiento subcontrataci�n';
                    RunObject = Page 7207587;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = SelectItemSubstitution;
                }
                action("action97")
                {
                    CaptionML = ENU = 'Tracking Purchase Materials', ESP = 'Seguimiento compra materiales';
                    RunObject = Page 7207289;
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ItemAvailbyLoc;
                }
                action("action98")
                {
                    CaptionML = ENU = 'Investment Tracking', ESP = 'Seguimiento de Inversiones';
                    RunObject = Page 7207587;
                    RunPageLink = "Job No." = FIELD("No."), "Budget Filter" = FIELD("Current Piecework Budget");
                    Visible = FALSE;
                    Image = Balance;
                }
                action("action99")
                {
                    CaptionML = ENU = 'Location', ESP = 'Almac�n';
                    Image = NewResourceGroup;

                    trigger OnAction()
                    VAR
                        Item: Record 27;
                        QueryJobLocation: Page 7207576;
                    BEGIN
                        CLEAR(QueryJobLocation);
                        Item.RESET;
                        Item.SETRANGE("Location Filter", rec."Job Location");
                        IF Item.FINDFIRST THEN BEGIN
                            REPEAT
                                Item.CALCFIELDS("Net Change");
                                IF Item."Net Change" <> 0 THEN BEGIN
                                    Item.MARK(TRUE);
                                END;
                            UNTIL Item.NEXT = 0;
                        END;
                        Item.MARKEDONLY(TRUE);
                        IF Item.FINDSET THEN BEGIN
                            QueryJobLocation.SETTABLEVIEW(Item);
                            QueryJobLocation.RUNMODAL;
                        END ELSE BEGIN
                            MESSAGE(Text50000);
                        END;
                    END;


                }
                action("action100")
                {
                    CaptionML = ENU = 'Return Pending', ESP = 'Pendiente devoluci�n';
                    RunObject = Page 7207452;
                    RunPageView = SORTING("Customer No.", "Job No.", "Contract No.", "Posting Date", "Pending")
                                  WHERE("Entry Type" = CONST("Delivery"), "Pending" = CONST(true));
                    RunPageLink = "Job No." = FIELD("No.");
                    Image = ServiceLines;
                }

            }
            group("Statistics")
            {

                CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                Image = Statistics;
                group("EstadísticasSubGroup")
                {

                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Image = Statistics;
                    action("action101")
                    {
                        ShortCutKey = 'F7';
                        CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas del proyecto';
                        RunObject = Page 7207332;
                        RunPageLink = "No." = FIELD("No."), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter"), "Budget Filter" = FIELD("Current Piecework Budget");
                        Image = Statistics;
                    }
                    action("action102")
                    {
                        CaptionML = ENU = 'Element Statistics', ESP = 'Estad�sticas elementos';
                        RunObject = Page 7207413;
                        RunPageView = WHERE("Delivered Quantity" = FILTER(<> 0));
                        RunPageLink = "Job Filter" = FIELD("No.");
                        Visible = FALSE;
                        Image = Statistics1099;
                    }
                    action("action103")
                    {
                        CaptionML = ENU = 'Aggregated Statistics', ESP = 'Estadisticas agregada';
                        RunObject = Page 7207357;
                        RunPageLink = "No." = FIELD("No.");
                        Enabled = edMultiproyect;
                        Image = StatisticsGroup;
                    }
                    action("action104")
                    {
                        ShortCutKey = 'F7';
                        CaptionML = ENU = 'Accepted Offer Statictis', ESP = 'Estad�sticas oferta aceptada';
                        RunObject = Page 7207370;
                        RunPageLink = "No." = FIELD("Original Quote Code"), "Resource Filter" = FIELD("Resource Filter"), "Posting Date Filter" = FIELD("Posting Date Filter"), "Resource Gr. Filter" = FIELD("Resource Gr. Filter");
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
                    action("action105")
                    {
                        ShortCutKey = 'Ctrl+F7';
                        CaptionML = ENU = 'Ledger Entries', ESP = 'Movimientos del proyecto';
                        RunObject = Page 92;
                        RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                        RunPageLink = "Job No." = FIELD("No.");
                        Image = Jobledger;
                    }
                    action("action106")
                    {
                        CaptionML = ENU = 'Rent Elements Entries', ESP = 'Mov. elementos alquiler';
                        RunObject = Page 7207452;
                        RunPageView = SORTING("Customer No.", "Job No.", "Contract No.", "Posting Date", "Pending");
                        RunPageLink = "Job No." = FIELD("No.");
                        Image = ServiceLedger;
                    }
                    action("action107")
                    {
                        CaptionML = ENU = 'Aggregate Entries', ESP = 'Movimientos agregados';
                        Image = JobLedger;

                        trigger OnAction()
                        VAR
                            Job: Record 167;
                            JobStart: Code[20];
                            JobEnd: Code[20];
                            JobLedgerEntry: Record 169;
                            JobLedgerEntries: Page 92;
                        BEGIN
                            IF rec."Allocation Item by Unfold" THEN BEGIN
                                Job.RESET;
                                Job.SETCURRENTKEY(Job."Job Matrix - Work", "Matrix Job it Belongs");
                                Job.SETRANGE("Job Matrix - Work", rec."Job Matrix - Work"::Work);
                                Job.SETRANGE("Matrix Job it Belongs", rec."No.");
                                IF Job.FINDFIRST THEN JobStart := Job."No.";
                                IF Job.FINDLAST THEN JobEnd := Job."No.";
                                JobLedgerEntry.RESET;
                                JobLedgerEntry.SETRANGE("Job No.", JobStart, JobEnd);

                                CLEAR(JobLedgerEntries);
                                JobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
                                JobLedgerEntries.RUNMODAL;
                            END;
                        END;


                    }

                }

            }
            group("Reports")
            {

                CaptionML = ENU = 'Reports', ESP = 'Infomes';
                group("group148")
                {
                    CaptionML = ENU = 'Reports', ESP = 'Informes';
                    Image = AnalysisView;
                    action("<Listado de precios descompuestos>")
                    {

                        CaptionML = ENU = 'Listado de precios descompuestos', ESP = 'Listado de precios descompuestos';
                        Visible = FALSE;

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            // REPORT.RUNMODAL(REPORT::"Decomposed Price List", TRUE, TRUE, Job);
                        END;


                    }
                    action("action109")
                    {
                        CaptionML = ENU = 'Informe de gastos por partida', ESP = 'Proyectos operativos sin nivel';

                        trigger OnAction()
                        VAR
                            // Operatprojectswithoutlevel: Report 7207414;
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            // CLEAR(Operatprojectswithoutlevel);
                            // IF (rec."Current Piecework Budget" = '') THEN
                            //     Operatprojectswithoutlevel.SetParameters(rec."No.", rec."Initial Budget Piecework", rec."Starting Date", rec."Ending Date")
                            // ELSE
                            //     Operatprojectswithoutlevel.SetParameters(rec."No.", rec."Current Piecework Budget", rec."Starting Date", rec."Ending Date");
                            // Operatprojectswithoutlevel.RUNMODAL;
                        END;


                    }
                    action("action110")
                    {
                        CaptionML = ENU = 'Proyectos operativos sin nivel', ESP = 'Informe de gastos por partida';

                        trigger OnAction()
                        VAR
                            // BudgetExpenditureReport: Report 7207415;
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
                            Ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
                            // CLEAR(BudgetExpenditureReport);
                            // BudgetExpenditureReport.SetParameters(rec."No.", Fini, Ffin);
                            // BudgetExpenditureReport.RUNMODAL;
                        END;


                    }
                    action("action111")
                    {
                        CaptionML = ENU = 'Real Job vs. Budget', ESP = 'Proyecto real vs. presupuesto';
                        Visible = FALSE;

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(REPORT::"Job Actual To Budget", TRUE, TRUE, Job);
                        END;


                    }
                    action("action112")
                    {
                        CaptionML = ENU = 'Job Analysis', ESP = 'An�lisis proyecto';
                        Visible = FALSE;

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(REPORT::"Job Analysis", TRUE, TRUE, Job);
                        END;


                    }
                    action("action113")
                    {
                        CaptionML = ENU = 'Planning Job - Lines', ESP = 'Proyecto - L�neas planificaci�n';
                        Visible = FALSE;

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            REPORT.RUNMODAL(REPORT::"Job - Planning Lines", TRUE, TRUE, Job);
                        END;


                    }
                    action("action114")
                    {
                        CaptionML = ENU = 'Invoiced Pending Shipments', ESP = 'Albaranes ptes. de facturar';

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            PurchRcptHeader.RESET;
                            //Q18863. CPA 20/02/23. INFORME ALBARANES PTES FACTURAR - cambio filtro por defecto. Begin
                            //PurchRcptHeader.SETRANGE("No.", "No.");
                            PurchRcptHeader.SETRANGE("Job No.", rec."No.");
                            //Q18863. CPA 20/02/23. INFORME ALBARANES PTES FACTURAR - cambio filtro por defecto. End

                            // REPORT.RUNMODAL(REPORT::"Invoiced Pending Shipments", TRUE, TRUE, PurchRcptHeader);
                        END;


                    }
                    action("action115")
                    {
                        CaptionML = ENU = 'Monthly Job Summary', ESP = 'Resumen mensual';

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Fini := CALCDATE('PM-2M+1D', WORKDATE);
                            Ffin := CALCDATE('PM-1M', WORKDATE);
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            Job.SETFILTER("Posting Date Filter", '%1..%2', Fini, Ffin);
                            // REPORT.RUNMODAL(REPORT::"Monthly Job Summary", TRUE, TRUE, Job);
                        END;


                    }
                    action("action116")
                    {
                        CaptionML = ENU = 'Actual Cost of Job', ESP = 'Coste real de obra';

                        trigger OnAction()
                        BEGIN
                            //JAV 25/07/19: - Establece el proyecto actual en el informe
                            Fini := CALCDATE('PM-2M+1D', WORKDATE);
                            Ffin := CALCDATE('PM-1M', WORKDATE);
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            Job.SETFILTER("Posting Date Filter", '%1..%2', Fini, Ffin);
                            // REPORT.RUNMODAL(REPORT::"Job Actual Cost", TRUE, TRUE, Job);
                        END;


                    }
                    action("action117")
                    {
                        CaptionML = ESP = 'An�lisis prod. por descompuestos';


                        trigger OnAction()
                        BEGIN
                            //JMMA 22/09/20: - Muestra la informaci�n de la p�gina de An�lisis de producci�n pero llegando al detalle de los descompuestos, mostrando coste previsto vs incurrido a este nivel
                            Job.RESET;
                            Job.SETRANGE("No.", rec."No.");
                            // REPORT.RUNMODAL(REPORT::"QB Piecework Analytic", TRUE, TRUE, Job);
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
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Planning', ESP = 'Planificaci�n';

                actionref(action12_Promoted; action12)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
                actionref(InvoiceMilestones_Promoted; InvoiceMilestones)
                {
                }
                actionref(action43_Promoted; action43)
                {
                }
                actionref(action44_Promoted; action44)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Project monitoring', ESP = 'Seguimiento de proyecto';

                actionref(action89_Promoted; action89)
                {
                }
                actionref(action15_Promoted; action15)
                {
                }
                actionref(action88_Promoted; action88)
                {
                }
                actionref(action90_Promoted; action90)
                {
                }
                actionref(action92_Promoted; action92)
                {
                }
                actionref(action101_Promoted; action101)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Execution', ESP = 'Ejecuci�n';

                actionref(action45_Promoted; action45)
                {
                }
                actionref(action46_Promoted; action46)
                {
                }
                actionref(action48_Promoted; action48)
                {
                }
                actionref(action49_Promoted; action49)
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
                actionref("Ver Agrupado_Promoted"; "Ver Agrupado")
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
        verSerieRegistro := QuoBuildingSetup."Series for Job";

        //JAV 08/05/19 - Se a�aden los campos del control de contrato
        verControlContrato := QuoBuildingSetup."Use Contract Control";
        edControlContrato := FALSE;
        IF (UserSetup.GET(USERID)) THEN
            edControlContrato := UserSetup."Control Contracts";

        //JAV 02/04/20: - Campo visible si se controla que faltan datos
        rRef.GETTABLE(Rec);
        QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);

        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF seeDragDrop THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Job);
        //Q7357 +

        vObralia := (FunctionQB.AccessToObralia);

        //Q12879 -
        ShowQBCustPrepmt := QBPrepmtMgt.AccessToCustomerPrepayment;
        ShowQBVendPrepmt := QBPrepmtMgt.AccessToVendorPrepayment;
        verAnticipos := ShowQBCustPrepmt OR ShowQBVendPrepmt;
        //Q12879 +

        //JAV 04/10/21: - QB 1.09.21 Pedidos de servicio
        seeServiceOrders := FunctionQB.AccessToServiceOrder(FALSE);
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
        rec."Card Type" := rec."Card Type"::"Proyecto operativo"; // QB4973

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
        QBPagePublisher: Codeunit 7207348;
        QBPageSubscriber: Codeunit 7207349;
        Guarantees: Codeunit 7207355;
        FunctionQB: Codeunit 7207272;
        QBPrepmtMgt: Codeunit 7207300;
        JobTaskLines: Page 1002;
        Descriptions: ARRAY[10] OF Text;
        Fini: Date;
        Ffin: Date;
        BDimJob: Boolean;
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
        verSerieRegistro: Boolean;
        verControlContrato: Boolean;
        edControlContrato: Boolean;
        ChangeInternalStatus: Boolean;
        edGuaranteeDef: Boolean;
        Text011: TextConst ESP = 'El proyecto no es editbale, no puede cambiar este campo';
        Text012: TextConst ESP = 'Solo el usuairo que lo bloque� o el responsle de proyectos puede levantar el bloqueo';
        edAIBUnfold: Boolean;
        QB_MandatoryFields: Boolean;
        QB_BlockedEnabled: Boolean;
        edMultiProyect: Boolean;
        JobType: Option;
        seeDragDrop: Boolean;
        verAnticipos: Boolean;
        vObralia: Boolean;
        seeMatrixOrJob: Boolean;
        edSubproyectos: Boolean;
        enCalcProd: Boolean;
        ShowQBCustPrepmt: Boolean;
        ShowQBVendPrepmt: Boolean;
        seeServiceOrders: Boolean;
        enRevPrice: Boolean;
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
        "---------------------- UTE": Integer;
        ProdUTE: Decimal;
        ActualProdUTE: Decimal;
        BaseProdUTE: Decimal;
        BaseActualProdUTE: Decimal;
        "-------------------------- Agrupados": Integer;
        enMatrix: Boolean;
        ShowGrouped: Boolean;

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

        LOCAL procedure SetAIBUnfold();
    begin
        //JAV 27/01/19: - Imputaci�n por desglose solo es editable si tiene proyectos hijos
        Rec.CALCFIELDS("No. of Matrix Job it Belongs");
        edAIBUnfold := (rec."No. of Matrix Job it Belongs" <> 0);

        //JAV 19/11/20: - La parte de proyectos matriz o de trabajo solo es visible si es realmente matriz o de trabajo
        seeMatrixOrJob := (rec."No. of Matrix Job it Belongs" <> 0) or (rec."Job Matrix - Work" = rec."Job Matrix - Work"::Work);
        edSubproyectos := (rec."Job Matrix - Work" <> rec."Job Matrix - Work"::Work);

        if (rec."No. of Matrix Job it Belongs" = 0) then
            rec."Allocation Item by Unfold" := FALSE;
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
        if Resource.GET(rec."Construction Manager") then Descriptions[9] := Resource.Name;

        //JMMA 031220 UTE
        BaseProdUTE := rec.ProdAmountUTE_Base(0);
        BaseActualProdUTE := rec.ProdAmountUTE_Base(1);
        ProdUTE := rec.ProdAmountUTE;
        ActualProdUTE := rec.ActualProdAmountUTE;
        //UTE

        Completado := (rec.Status = rec.Status::Completed);                       //Si est� en estado completado
        SetInternalStatus;                                                //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");  //JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
        QB_BlockedEnabled := not rec."Data Missed";                          //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
        Rec.CALCFIELDS("Guarantee Definitive Job");                           //JAV 19/09/19: - Hacer la garant�a editable solo si no se ha procesado

        edGuaranteeDef := (rec."Guarantee Definitive Job" = '');
        SetAIBUnfold;                                                     //JAV 27/01/19: - Imputaci�n por desglose solo es editable si tiene proyectos hijos

        JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);  //Si se pueden ver las divisas del proyecto

        Rec.CALCFIELDS("No. of Matrix Job it Belongs");                       //Si es muti-proyecto
        edMultiProyect := (rec."No. of Matrix Job it Belongs" <> 0);

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

        //JAV 25/11/20: - QB 1.07.07 No se puede cambiar el c�lculo del WIP si ya se ha lanzado alguna vez
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.");
        JobLedgerEntry.SETRANGE("Job No.", rec."No.");
        JobLedgerEntry.SETRANGE("Job in progress", TRUE);
        enCalcProd := JobLedgerEntry.ISEMPTY;

        //Q13639 +
        enMatrix := rec.IsMatrixJob();
        //Q13639 -

        //Q12733 EPV 16/02/22 - Revisi�n de precio
        enRevPrice := (seeServiceOrders) and (rec."QB Allow Service Order");
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_General.PAGE.SetViewData(ShowCurrency, ShowGrouped);        //Q13639
        CurrPage.FB_Purchase.PAGE.SetViewData(ShowCurrency, ShowGrouped);       //Q13639
        CurrPage.FB_Warehouse.PAGE.SetViewData(ShowCurrency, ShowGrouped);      //Q13639
        CurrPage.FB_Certification.PAGE.SetViewData(ShowCurrency, ShowGrouped);  //Q13639
        CurrPage.FB_Production.PAGE.SetViewData(ShowCurrency, ShowGrouped);     //Q13639
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      NZG 15/01/18: - QBV004 A�adida la acci�n de "Tareas Pendientes"
      PGM 02/02/18: - QBV1104 Deshabilitar el campo Fecha Real Fin de Obra cuando el estado es completado.
                              He suprimido el xRec del campo rec."End Real Construction Date" para que se modifique cuando se cambia manualmente el valor.
      PGM 12/11/18: - QB4973 A�adido campo "Card type" y al crear una nueva oferta se le pone el valor "Proyecto Operativo" por defecto.
      JAV 13/03/19: - Eliminado el campo "Card Type" de la pantalla porque es peligroso que lo cambie el cliente
      PEL 19/03/19: - OBR Se a�aden campos de Obralia
      PEL 29/04/19: - QCPM_GAP05 Si el estado interno no deja editar la ficha, no editable.
      PEL 29/04/19: - QCPM_GAP05 Control al modificar.
      JAV 04/05/19: - Se hacen los campos de aprobadores visibles seg�n configuraci�n
      JAV 04/05/19: - Se hace o no visible la aprobaci�n simplificada seg�n par�metro
      PEL 13/02/19: - QPE6449 Actualizar precio aplicando el coeficiente objetivo
      JAV 12/06/19: - Cambio para usar las 5 fechas auxiliares
      JAV 13/06/19: - Un registro nuevo siempre ser� editable
      JAV 20/06/19: - Se a�ade el campo del N�mero de serie de registro de facturas y abonos por proyecto
      JAV 09/07/19: - Se a�ade el capo del n� serie para salida almac�n
      JAV 25/07/19: - Establece el proyecto actual en los informes de la ficha
      JDC 25/07/19: - GAP029 KALAM Added field 50003 "Multi-Client Job"
      JAV 28/07/19: - Se elimina el campo "Responsabilitiy Center" y se activa el uso de los responsables para el control de usuarios
      JAV 04/08/19: - Se a�ade en el panel de fechas un grupo licitaci�n con los campos rec."Bidding Date", rec."Final Allocation Date",
                      rec."Contract Sign Date", "Doc. Verifying Readiness Date", rec."Execution Official Term", rec."Warranty Term", Guarantor, "Guarantor Amount"
      JAV 06/08/19: - Se a�aden rec."Budget Status" y no editable si est� bloqueado, y el campo rec."Blocked By"
      JAV 08/08/19: - Se pasa a la tabla la funci�n de SetEditable para unificar estudios y proyectos
      JAV 26/08/19: - Solicitud de garant�a
      JAV 09/09/19: - Se informan las variables de edici�n al iniciar la p�gina
      JAV 18/09/19: - Se hacen no visibles acciones que no funcionan bien y campos que no son necesarios
      JAV 19/09/19: - Hacer la garant�a editable solo si no se ha procesado
      PGM 19/09/19: - GAP012 KALAM A�adidos los campos rec."Job Phases", rec."Customer Type" y  la subpage "Externals"
      JAV 02/10/19: - Se a�ade la acci�n para ver el log de cambios
                    - Se a�aden los campos de preciario de costes cargados nuevos y se eliminan los antiguos
      PGM 08/10/19: - GAP015 KALAM A�adido el campo rec."Project Management"
      JAV 11/10/19: - Se hacen no visibles los campos rec."Initial Reestimation Code", rec."Latest Reestimation Code" y rec."Last Redetermination" pues actualmente no se usan
      PGM 22/10/19: - Q8090 Corregido el filtro cuando se le da a la acci�n de "Garantias" desde las propiedades de la acci�n. Sustituido "Quotes No." por "Job No."
      JAV 27/01/19: - Imputaci�n por desglose solo es editable si tiene proyectos hijos
      JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
      JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
      JAV 20/02/20: - Se a�aden las fechas del plazo de garant�a de la obra
      JAV 22/02/20: - Se eliminan los campos "Access Level", "Apply Usage Link" y "Sent Date" que no se usan
      Q12879 JDC 01/03/21 - Created function "PrepmtVendEntries - OnAction", "CreateVendQBPrepmt - OnAction"
                            Modified function "OnOpenPage"
      Q13639 MMS 08/07/21 - Crear bot�n "Ver Agrupado" para mostrar los valores agrupados de proyectos Padre-Hijo
      DGG 08/10/21 - QB 1.09.21: Se a�ade grupo "Almac�n Central"
      Q16330 EPV 11/02/22 - Opci�n por defecto "En Proceso" a la hora de lanzar el informe Ventas/Costes
      Q12733 EPV 16/02/22 - Revisi�n de precio
      JAV 03/08/22: - QB 1.11.01 Se eliminan los botones para liberar el IVA diferido que no tienen sentido mantener en esta p�gina

      Q18863. CPA 20/02/23. INFORME ALBARANES PTES FACTURAR - cambio filtro por defecto.
                          - Invoiced Pending Shipments - OnAction
      Q20362 AML 30/10/23 - Cambio en la llamada a abonos ventas
    }*///end
}







