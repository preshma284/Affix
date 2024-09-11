page 7207361 "Quotes Card"
{
    CaptionML = ENU = 'Quotes Card', ESP = 'Ficha oferta';
    SourceTable = 167;
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

                    CaptionML = ENU = 'No.', ESP = 'N� Estudio';

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

                    Visible = FALSE;
                }
                field("Archived"; rec."Archived")
                {

                }
                group("group40")
                {

                    CaptionML = ENU = 'Customer', ESP = 'Cliente';
                    field("Bill-to Customer No."; rec."Bill-to Customer No.")
                    {

                        CaptionML = ENU = 'Bill-to Customer No.', ESP = 'Factura-a N� cliente';


                        ShowMandatory = TRUE;
                        trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Bill-to Name"; rec."Bill-to Name")
                    {

                        CaptionML = ENU = 'Bill-to Name', ESP = 'Nombre';
                        Editable = FALSE;
                    }
                    field("Bill-to Address"; rec."Bill-to Address")
                    {

                        CaptionML = ENU = 'Bill-to Address', ESP = 'Direcci�n';
                        Editable = FALSE;
                    }
                    field("Bill-to Address 2"; rec."Bill-to Address 2")
                    {

                        CaptionML = ENU = 'Bill-to Address 2', ESP = 'Direcci�n 2';
                        Editable = FALSE;
                    }
                    field("Bill-to Post Code"; rec."Bill-to Post Code")
                    {

                        CaptionML = ENU = 'Bill-to Post Code', ESP = 'C.P.';
                        Editable = FALSE;
                    }
                    field("Bill-to City"; rec."Bill-to City")
                    {

                        CaptionML = ENU = 'Bill-to City', ESP = 'Poblaci�n';
                        Editable = FALSE;
                    }
                    field("Bill-to County"; rec."Bill-to County")
                    {

                        CaptionML = ENU = 'Bill-to County', ESP = 'Provincia';
                        Editable = FALSE;
                    }
                    field("Customer Type"; rec."Customer Type")
                    {

                    }

                }
                group("group49")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Contacto';
                    field("Bill-to Contact No."; rec."Bill-to Contact No.")
                    {

                        CaptionML = ENU = 'Bill-to Contact No.', ESP = 'N� contacto';
                    }
                    field("Bill-to Contact"; rec."Bill-to Contact")
                    {

                        CaptionML = ENU = 'Bill-to Contact', ESP = 'Nombre';
                        Editable = FALSE;
                    }

                }
                group("group52")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Personas';
                    grid("group53")
                    {

                        GridLayout = Rows;
                        group("group54")
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
                    grid("group57")
                    {

                        GridLayout = Rows;
                        group("group58")
                        {

                            CaptionML = ESP = 'Responsable comercial';
                            field("Income Statement Responsible"; rec."Income Statement Responsible")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
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
                    grid("group61")
                    {

                        GridLayout = Rows;
                        group("group62")
                        {

                            CaptionML = ENU = 'Project Management', ESP = 'Direcci�n facultativa';
                            field("Project Management"; rec."Project Management")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
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
                group("group65")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Datos generales';
                    grid("group66")
                    {

                        GridLayout = Rows;
                        group("group67")
                        {

                            CaptionML = ENU = 'Clasification', ESP = 'Clasificaci�n';
                            field("Clasification"; rec."Clasification")
                            {

                                Importance = Promoted;


                                ShowCaption = false;
                                trigger OnValidate()
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
                    grid("group70")
                    {

                        GridLayout = Rows;
                        group("group71")
                        {

                            CaptionML = ENU = 'Quote Type', ESP = 'Tipo oferta';
                            field("Quote Type"; rec."Quote Type")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
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
                    grid("group74")
                    {

                        GridLayout = Rows;
                        group("group75")
                        {

                            CaptionML = ENU = 'Job Phases', ESP = 'Fase del proyecto';
                            field("Job Phases"; rec."Job Phases")
                            {



                                ShowCaption = false;
                                trigger OnValidate()
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
                    grid("group78")
                    {

                        GridLayout = Rows;
                        group("group79")
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
                    grid("group82")
                    {

                        GridLayout = Rows;
                        group("group83")
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

                }
                group("group86")
                {

                    CaptionML = ENU = 'Contact', ESP = 'Situaci�n';
                    field("Blocked"; rec."Blocked")
                    {

                        Enabled = QB_BlockedEnabled;
                    }
                    grid("group88")
                    {

                        GridLayout = Rows;
                        group("group89")
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
                    field("Quote Status"; rec."Quote Status")
                    {

                        Editable = FALSE;
                    }
                    field("Approved/Refused By"; rec."Approved/Refused By")
                    {

                        CaptionML = ENU = 'Approved/Refused By', ESP = 'Aprobada/Denegada por';
                        Editable = FALSE;
                    }
                    field("Rejection Reason"; rec."Rejection Reason")
                    {

                        Editable = FALSE;
                    }
                    field("Observations"; rec."Observations")
                    {

                    }

                }
                group("group96")
                {

                    CaptionML = ESP = 'Versiones';
                    field("Versions No."; rec."Versions No.")
                    {


                        ; trigger OnDrillDown()
                        BEGIN
                            Job.RESET;
                            Job.FILTERGROUP(2);
                            Job.SETRANGE("Original Quote Code", rec."No.");
                            //Job.SETRANGE(Status,Job.Status::Planning);
                            Job.FILTERGROUP(0);
                            PAGE.RUNMODAL(PAGE::"List of Quote Versions", Job);
                        END;


                    }
                    field("Presented Version"; rec."Presented Version")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            //JAV 07/07/19: - Se actualiza el estilo del importe de la garant�a defintiva y la p�gina al cambiar la versi�n presentada para que refresque el fact-box
                            SetStGuarantee;
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Accepted Version No."; rec."Accepted Version No.")
                    {

                        Editable = FALSE;
                    }
                    field("Generated Job"; rec."Generated Job")
                    {

                        Editable = FALSE;
                    }

                }

            }
            group("group101")
            {

                CaptionML = ENU = 'Posting', ESP = 'Estado';
                field("Data Missed Message"; rec."Data Missed Message")
                {

                    Visible = QB_MandatoryFields;
                }
                field("Internal Status"; rec."Internal Status")
                {

                    Editable = InternalStatusEditable;

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
                group("group104")
                {

                    CaptionML = ENU = 'Posting', ESP = 'Fechas';
                    field("Present. Quote Real Date"; rec."Present. Quote Real Date")
                    {

                        Visible = FALSE;
                        ShowCaption = false;
                    }
                    grid("group106")
                    {

                        GridLayout = Rows;
                        group("group107")
                        {

                            CaptionML = ESP = 'Publicaci�n';
                            field("Posting Date"; rec."Posting Date")
                            {

                                CaptionML = ENU = 'Posting Date', ESP = 'Fecha';
                                Editable = InternalStatusEditable;
                            }
                            field(""; '')
                            {

                                CaptionML = ENU = 'Present. Quote Required Date', ESP = 'Hora';
                            }

                        }

                    }
                    grid("group110")
                    {

                        GridLayout = Rows;
                        group("group111")
                        {

                            CaptionML = ESP = 'Presentaci�n requerida';
                            field("Present. Quote Required Date"; rec."Present. Quote Required Date")
                            {

                                Editable = InternalStatusEditable;
                                ShowCaption = false;
                            }
                            field("Present. Quote Required Time"; rec."Present. Quote Required Time")
                            {

                                Editable = InternalStatusEditable;
                                ShowCaption = false;
                            }

                        }

                    }
                    grid("group114")
                    {

                        GridLayout = Rows;
                        group("group115")
                        {

                            CaptionML = ESP = 'Presentaci�n real';
                            field("Sent Date"; rec."Sent Date")
                            {

                                Editable = editFechaEnvio;
                                ShowCaption = false;
                            }
                            field("Present. Quote Real Time"; rec."Present. Quote Real Time")
                            {

                                Editable = editFechaEnvio;
                                ShowCaption = false;
                            }

                        }

                    }

                }
                group("group118")
                {

                    CaptionML = ENU = 'Posting', ESP = 'Fechas Configurables';
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
                group("group124")
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
            group("group127")
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
            group("group136")
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

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Currency Value Date"; rec."Currency Value Date")
                {

                    Visible = useCurrencies;
                }

            }
            group("group141")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                Editable = InternalStatusEditable;
                field("Job Posting Group"; rec."Job Posting Group")
                {

                }
                field("VAT Prod. PostingGroup"; rec."VAT Prod. PostingGroup")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Mandatory Allocation Term By"; rec."Mandatory Allocation Term By")
                {

                }

            }
            group("group146")
            {

                CaptionML = ENU = 'Bidding', ESP = 'Licitaci�n';
                Editable = InternalStatusEditable;
                field("Bidding Bases Budget"; rec."Bidding Bases Budget")
                {

                    Importance = Promoted;
                }
                field("% Dangerously Low Bids"; rec."% Dangerously Low Bids")
                {

                    Editable = edLow;
                }
                field("Low Average Competition"; rec."Low Average Competition")
                {

                    Editable = edLow;
                }
                field("Quotes Opening Date"; rec."Quotes Opening Date")
                {

                    Importance = Promoted;
                }
                field("Allocation Process"; rec."Allocation Process")
                {

                }
                field("Implementation Period"; rec."Implementation Period")
                {

                }
                field("Guarantee Period"; rec."Guarantee Period")
                {

                }
                field("Improvements"; rec."Improvements")
                {

                }
                field("Subcontracting Limit %"; rec."Subcontracting Limit %")
                {

                }
                field("Poster Charge"; rec."Poster Charge")
                {

                    Visible = FALSE;
                }
                field("Advertising Charge"; rec."Advertising Charge")
                {

                    Visible = FALSE;
                }
                field("Price Revision"; rec."Price Revision")
                {

                }
                field("Payment Method"; rec."Payment Method")
                {

                }
                field("Planned K"; rec."Planned K")
                {

                }
                group("group161")
                {

                    CaptionML = ESP = 'Autor';
                    field("Job Author"; rec."Job Author")
                    {

                    }
                    field("E-mail (author)"; rec."E-mail (author)")
                    {

                        CaptionML = ENU = 'E-mail (author)', ESP = 'E-mail';
                    }
                    field("Phone No. (author)"; rec."Phone No. (author)")
                    {

                        CaptionML = ENU = 'Phone No. (author)', ESP = 'Tel�fono';
                    }

                }
                group("group165")
                {

                    CaptionML = ESP = 'Garant�a';
                    field("Guarantee Provisional %"; rec."Guarantee Provisional %")
                    {

                        Editable = edGuaranteePro;
                    }
                    field("Guarantee Provisional"; rec."Guarantee Provisional")
                    {

                        Editable = edGuaranteePro;

                        ; trigger OnAssistEdit()
                        BEGIN
                            //JAV 26/08/19: - Solicitud de garant�as
                            Guarantees.SolicitudProvisional(Rec);
                            SetStGuarantee;
                        END;


                    }
                    field("Guarantee Provisional Quote"; rec."Guarantee Provisional Quote")
                    {

                    }
                    field("Guarantee Definitive %"; rec."Guarantee Definitive %")
                    {

                        Editable = edGuaranteeDef;

                        ; trigger OnValidate()
                        BEGIN
                            //JAV 26/08/19: - Se crea un fucni�n para establecer el estilo del campo garant�a defintiviva
                            SetStGuarantee;
                        END;


                    }
                    field("Guarantee Definitive"; rec."Guarantee Definitive")
                    {

                        Editable = edGuaranteeDef;
                        Style = Attention;
                        StyleExpr = stGuarantee;

                        ; trigger OnValidate()
                        BEGIN
                            //JAV 26/08/19: - Se crea un fucni�n para establecer el estilo del campo garant�a defintiviva
                            SetStGuarantee;
                        END;

                        trigger OnAssistEdit()
                        BEGIN
                            //JAV 26/08/19: - Solicitud de garant�as
                            Guarantees.SolicitudDefinitiva(Rec, TRUE);
                            SetStGuarantee;
                        END;


                    }
                    field("Guarantee Definitive Quote"; rec."Guarantee Definitive Quote")
                    {

                    }

                }
                group("group172")
                {

                    CaptionML = ESP = 'Adjudicaci�n';
                    field("Provisional Allocation Date"; rec."Provisional Allocation Date")
                    {

                        Importance = Promoted;
                    }
                    field("Final Allocation Period"; rec."Final Allocation Period")
                    {

                    }
                    field("Final Allocation Date"; rec."Final Allocation Date")
                    {

                    }
                    grid("group176")
                    {

                        GridLayout = Rows;
                        group("group177")
                        {

                            CaptionML = ESP = 'Empresa Adjudicaci�n';
                            field("Bidder Company"; rec."Bidder Company")
                            {

                                Editable = FALSE;
                                ShowCaption = false;
                            }
                            field("BidderCompanyName"; GetBidderCompany())
                            {

                                Editable = FALSE;
                                ShowCaption = false;
                            }

                        }

                    }
                    field("Assigned Amount"; rec."Assigned Amount")
                    {

                        Editable = FALSE;
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

            }
            group("group183")
            {

                CaptionML = ENU = 'JV', ESP = 'UTE';
                Editable = InternalStatusEditable;
                group("group184")
                {

                    CaptionML = ENU = 'Data JV In MAtrix Company', ESP = 'Datos UTE en empresa matriz';
                    field("% JV Share"; rec."% JV Share")
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
                    field("Month Closing JV"; rec."Month Closing JV")
                    {

                        Visible = false;
                    }
                    field("Partner JV"; rec."Partner JV")
                    {

                        Visible = false;
                    }

                }
                group("group191")
                {

                    CaptionML = ENU = 'Data JV In Company JV', ESP = 'Datos UTE en empresa UTE';
                    Visible = false;
                    Editable = InternalStatusEditable;
                    field("Piecework of CD integrat. JV"; rec."Piecework of CD integrat. JV")
                    {

                        Visible = false;
                    }
                    field("Piecework of CI intergrat. JV"; rec."Piecework of CI intergrat. JV")
                    {

                        Visible = false;
                    }

                }

            }
            part("part1"; 7207045)
            {

                CaptionML = ENU = 'Responsible', ESP = 'Responsables';
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

            }
            group("group4")
            {
                CaptionML = ENU = '&Quote', ESP = '&Oferta';
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
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
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207376;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action5")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger Entries', ESP = 'Movimientos del estudio';
                    Image = JobLedger;

                    trigger OnAction()
                    VAR
                        pgJobLedgerEntries: Page 92;
                        JobLedgerEntry: Record 169;
                    BEGIN
                        JobLedgerEntry.RESET;
                        JobLedgerEntry.SETCURRENTKEY("Job No.");
                        JobLedgerEntry.SETFILTER("Job No.", rec."No." + '*');
                        CLEAR(pgJobLedgerEntries);
                        pgJobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
                        pgJobLedgerEntries.RUNMODAL;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Change Customer No.', ESP = 'Cambiar N� Cliente';
                    ToolTipML = ENU = 'Allows to Rec.MODIFY the Bill-To Customer No. for the quote and its versions, as they  have been assigned a Generic Customer', ESP = 'Se utiliza para cambiar el campo Facturar a N� Cliente del Estudio y de sus versiones, al haber sido asignadas a un Cliente Gen�rico.';
                    Image = ChangeCustomer;

                    trigger OnAction()
                    VAR
                        CustomerList: Page 22;
                        CustRec: Record 18;
                        JobRec: Record 167;
                    BEGIN
                        //QX7105 >>
                        QBTableSubscriber.ChangeGenericCustomer_TJob(Rec);
                        CurrPage.UPDATE;
                        //QX7105 <<
                    END;


                }

            }
            group("group10")
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
            group("group13")
            {
                CaptionML = ENU = '&Quote', ESP = '&Estado';
                action("action9")
                {
                    CaptionML = ENU = 'Approve', ESP = 'Aceptar';
                    Enabled = ChangeStatus;
                    Image = Approve;

                    trigger OnAction()
                    BEGIN
                        //JAV 22/09/19: - No dejar aceptar, rechazar, volver a abrir o generar proyectos de estudios bloqueados
                        IF (rec."Budget Status" = rec."Budget Status"::Blocked) THEN
                            ERROR(err001);

                        QBTableSubscriber.TJob_Accept(Rec);
                        CurrPage.UPDATE;
                    END;


                }
                action("action10")
                {
                    CaptionML = ENU = 'Reject', ESP = 'Rechazar';
                    Enabled = ChangeStatus;
                    Image = Reject;

                    trigger OnAction()
                    BEGIN
                        //JAV 22/09/19: - No dejar aceptar, rechazar, volver a abrir o generar proyectos de estudios bloqueados
                        IF (rec."Budget Status" = rec."Budget Status"::Blocked) THEN
                            ERROR(err001);

                        QBTableSubscriber.TJob_Reject(Rec);
                        CurrPage.UPDATE;
                    END;


                }
                action("action11")
                {
                    CaptionML = ENU = 'Relaunch', ESP = 'Volver a abrir';
                    Enabled = ChangeStatus;
                    Image = Delegate;

                    trigger OnAction()
                    BEGIN
                        //JAV 22/09/19: - No dejar aceptar, rechazar, volver a abrir o generar proyectos de estudios bloqueados
                        IF (rec."Budget Status" = rec."Budget Status"::Blocked) THEN
                            ERROR(err001);

                        IF (rec."Quote Status" = rec."Quote Status"::Accepted) AND (rec."Generated Job" <> '') THEN
                            ERROR(Text009);
                        QBTableSubscriber.TJob_Reopen(Rec);
                        CurrPage.UPDATE;
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'Create Job', ESP = 'Crear proyecto';
                    Image = CreateJobSalesInvoice;

                    trigger OnAction()
                    VAR
                        // GenerateQuotes: Report 7207292;
                        JobNo: Code[10];
                        rJob: Record 167;
                    BEGIN
                        //JAV 22/09/19: - No dejar aceptar, rechazar, volver a abrir o generar proyectos de estudios bloqueados
                        IF (rec."Budget Status" = rec."Budget Status"::Blocked) THEN
                            ERROR(err001);

                        IF rec."Quote Status" <> rec."Quote Status"::Accepted THEN
                            ERROR(Text007);
                        IF rec."Generated Job" <> '' THEN
                            ERROR(Text008);

                        COMMIT; // Me lo guardo para que luego no de problemas
                        QBTableSubscriber.TJob_CreateJob(Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }

            }
            group("group18")
            {
                CaptionML = ENU = 'Management of the Opportunity', ESP = 'Gesti�n de la oportunidad';
                action("action13")
                {
                    CaptionML = ENU = 'Create Opportunity', ESP = 'Crear oportunidad';
                    Image = ItemTracking;

                    trigger OnAction()
                    VAR
                        LJob: Record 167;
                        // LGenerateOpportunity: Report 7207328;
                    BEGIN
                        IF rec."Opportunity Code" <> '' THEN
                            ERROR(Text010, rec."Opportunity Code");

                        LJob.RESET;
                        LJob.SETFILTER("No.", rec."No.");

                        // CLEAR(LGenerateOpportunity);

                        // LGenerateOpportunity.SETTABLEVIEW(LJob);
                        // LGenerateOpportunity.RUNMODAL;
                    END;


                }
                action("action14")
                {
                    CaptionML = ENU = 'Opportunity', ESP = 'Oportunidad';
                    RunObject = Page 5123;
                    RunPageLink = "No." = FIELD("Opportunity Code");
                    Image = Opportunity;
                }
                action("action15")
                {
                    CaptionML = ENU = 'Opportunity Stage', ESP = 'Etapas oportunidad';
                    RunObject = Page 5125;
                    RunPageView = SORTING("Opportunity No.")
                                  ORDER(Ascending);
                    RunPageLink = "Opportunity No." = FIELD("Opportunity Code");
                    Image = OpportunityList;
                }
                action("action16")
                {
                    CaptionML = ENU = 'Pending Tasks', ESP = 'Tareas pendientes';
                    RunObject = Page 5096;
                    RunPageView = SORTING("Opportunity No.", "Date", "Closed")
                                  ORDER(Ascending)
                                  WHERE("Status" = FILTER(<>"Completed"), "System To-do Type" = CONST("Organizer"));
                    RunPageLink = "Opportunity No." = FIELD("Opportunity Code");
                    Image = ItemTrackingLedger;
                }

            }
            group("group23")
            {
                CaptionML = ENU = 'Bidding', ESP = 'Licitaci�n';
                action("action17")
                {
                    CaptionML = ENU = 'Valuation Criteria', ESP = 'Criterios de valoraci�n';
                    RunObject = Page 7207388;
                    RunPageView = SORTING("Quote Code", "Standard Code", "Standard Description")
                                  ORDER(Ascending);
                    RunPageLink = "Quote Code" = FIELD("No.");
                    Image = MakeAgreement;
                }
                action("action18")
                {
                    CaptionML = ENU = 'Penalties', ESP = 'Penalizaciones';
                    RunObject = Page 7207387;
                    RunPageView = SORTING("Quote Code", "Penalization Code", "Number")
                                  ORDER(Ascending);
                    RunPageLink = "Quote Code" = FIELD("No.");
                    Image = OverdueEntries;
                }
                action("action19")
                {
                    CaptionML = ENU = 'Competition', ESP = 'Competencia';
                    RunObject = Page 7207390;
                    RunPageView = SORTING("Quote Code", "Competitor Code")
                                  ORDER(Ascending);
                    RunPageLink = "Quote Code" = FIELD("No.");
                    Image = TeamSales;
                }
                action("action20")
                {
                    CaptionML = ESP = 'Garant�a';
                    RunObject = Page 7207653;
                    RunPageLink = "Quote No." = FIELD("No.");
                    Image = Voucher;
                }

            }
            group("group28")
            {
                CaptionML = ENU = '&Versions', ESP = '&Versiones';
                action("action21")
                {
                    CaptionML = ENU = 'Versions', ESP = 'Versiones';
                    RunObject = Page 7207362;
                    RunPageLink = "Original Quote Code" = FIELD("No.");
                    Enabled = HaveVersions;
                    Image = BOMVersions;
                }
                action("action22")
                {
                    CaptionML = ENU = 'Create Version', ESP = 'Crear versi�n';
                    Image = CopyFromTask;

                    trigger OnAction()
                    VAR
                        // GenerateQuotes: Report 7207292;
                        ListofQuoteVersions: Page 7207362;
                        Job1: Record 167;
                        Job2: Record 167;
                    BEGIN
                        // CLEAR(GenerateQuotes);
                        // GenerateQuotes.VersionJob(TRUE);
                        // GenerateQuotes.SetParam(rec."No.", '');
                        // GenerateQuotes.RUNMODAL;

                        //JAV 31/07/19: - Tras crear una nueva versi�n presentar la lista de versiones con la versi�n creada ya seleccionada
                        // IF (GenerateQuotes.GetJobGenerate <> '') THEN BEGIN
                        //     Job.RESET;
                        //     Job.SETRANGE("Original Quote Code", rec."No.");
                        //     CLEAR(ListofQuoteVersions);
                        //     ListofQuoteVersions.SETTABLEVIEW(Job);
                        //     Job.GET(GenerateQuotes.GetJobGenerate);
                        //     ListofQuoteVersions.SETRECORD(Job);
                        //     ListofQuoteVersions.RUN;
                        // END;
                    END;


                }
                action("action23")
                {
                    CaptionML = ENU = 'Versions Compare', ESP = 'Comparar versiones';
                    Enabled = HaveVersions;
                    Image = ExchProdBOMItem;

                    trigger OnAction()
                    BEGIN
                        QBPageSubscriber.seeBudgetByCA(Rec, TRUE);
                    END;


                }

            }
            group("group32")
            {
                CaptionML = ENU = 'Log', ESP = 'Log';
                // ActionContainerType =NewDocumentItems ;
                action("action24")
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
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'ProcessAdmin', ESP = 'Proceso';

                actionref(action9_Promoted; action9)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Versions', ESP = 'Administrar';
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Currencies', ESP = 'Versiones';

                actionref(action21_Promoted; action21)
                {
                }
                actionref(action22_Promoted; action22)
                {
                }
                actionref(action23_Promoted; action23)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Attributes', ESP = 'Divias';

                actionref(JobCurrencyExchanges_Promoted; JobCurrencyExchanges)
                {
                }
                actionref(ChangeFactboxCurrency_Promoted; ChangeFactboxCurrency)
                {
                }
            }
            group(Category_Category6)
            {
                CaptionML = ENU = 'Somes', ESP = 'Atributos';

                actionref(Attributes_Promoted; Attributes)
                {
                }
            }
            group(Category_Category7)
            {
                CaptionML = ESP = 'Varios';

                actionref(action13_Promoted; action13)
                {
                }
                actionref(action14_Promoted; action14)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
                actionref(action17_Promoted; action17)
                {
                }
                actionref(action19_Promoted; action19)
                {
                }
            }
        }
    }


    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);

        //QCPM_GAP04 Los botones de cambiar estado se hacen editables seg�n usuario
        UserSetup.GET(USERID);
        ChangeStatus := UserSetup."Modify Quote Status";

        //JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
        SetInternalStatus;

        //JAV 09/09/19: - Se informan las variables de edici�n al iniciar la p�gina
        InternalStatusEditable := TRUE; //Por defecto ser� editable
        ChangeInternalStatus := TRUE;
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
        //QX7105 >>  JAV 05/08/19: - Clientes gen�ricos en contacto, se simplifican las funciones
        IF CheckContact THEN
            EXIT(Rec.NEXT(Steps));
    END;

    trigger OnAfterGetRecord()
    BEGIN
        funOnAfterGetRecord;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    VAR
        QBTablesSetup: Record 7206903;
        rRef: RecordRef;
    BEGIN
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        rec."Responsibility Center" := UserRespCenter;
        rec.Status := rec.Status::Planning;
        rec."Card Type" := rec."Card Type"::Estudio; // QB4973

        //JAV 13/06/19: - En uno nuevo siempre ser� editable
        InternalStatusEditable := TRUE;

        //JAV 02/04/20: - Campo visible si se controla que faltan datos
        rRef.GETTABLE(Rec);
        QB_MandatoryFields := QBTablesSetup.AsMandatoryFields(rRef.NUMBER);
    END;

    trigger OnDeleteRecord(): Boolean
    VAR
        UserSetup: Record 91;
    BEGIN
        //JAV 11/03/19: - Se activa el bot�n de eliminar, pero se verifica que se pueda antes de lanzarlo
        IF NOT UserSetup.GET(USERID) THEN
            ERROR(Text000);
        IF NOT UserSetup."Allow DELETE Job Quotes" THEN
            ERROR(Text000);

        IF InternalsStatus.GET(rec."Card Type", rec."Internal Status") THEN
            IF InternalsStatus.Order > 1 THEN
                ERROR(Text001, rec.FIELDCAPTION(rec."Internal Status"), rec."Internal Status");

        Rec.CALCFIELDS("Versions No.");
        IF (rec."Versions No." <> 0) THEN
            ERROR(Text002);
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        //QX7105 >> JAV 05/08/19: - Clientes gen�ricos en contacto, se simplifican las funciones
        IF NOT CheckContact THEN
            ERROR('');
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        ControlQuotesManagement: Record 7207334;
        Job: Record 167;
        Text000: TextConst ESP = 'Su usuario no est� configurado para eliminar estudios';
        Text001: TextConst ESP = 'No puede eliminar una oferta con el campo %1 en estado %2';
        Text002: TextConst ESP = 'No puede eliminar una oferta con versiones, elim�nelas previamente';
        Text009: TextConst ENU = 'To re-launch the tender you must: \\ -Rec.DELETE the budgets of the associated job. \\ -Rec.DELETE the billing milestones of the associated job. \\ - Change the job status to Finished. \\ - Rec.DELETE the job.', ESP = 'Para volver a lanzar la oferta debe:\\   -Eliminar los presupuestos del proyecto asociado.\\   -Eliminar los hitos de facturaci�n del proyecto asociado.\\   -Cambiar el estado del proyecto a Terminado.\\   -Borrar el proyecto.';
        Text007: TextConst ENU = 'The quote must be Accepted in order to create a job.', ESP = 'La oferta debe estar Aceptada para poder crear un proyecto.';
        Text008: TextConst ENU = 'There is already a job generated for this quote.', ESP = 'Ya existe un proyecto generado para esta oferta.';
        Text010: TextConst ENU = 'The quote already has the opportunity %1 associated.', ESP = 'La oferta ya tiene asociada la oportunidad %1.';
        QuoBuildingSetup: Record 7207278;
        InternalsStatus: Record 7207440;
        CustRec: Record 18;
        UserSetup: Record 91;
        Text50001: TextConst ENU = '"Study contact No. field must have a value in Job: No.=%1. It can not be zero or be blank."', ESP = '"N� contacto estudio debe tener un valor en Proyecto: N�=%1. No puede ser cero ni estar vac�o."';
        JobLedgerEntry: Record 169;
        DataPieceworkForProduction: Record 7207386;
        QBTableSubscriber: Codeunit 7207347;
        QBPagePublisher: Codeunit 7207348;
        QBPageSubscriber: Codeunit 7207349;
        Guarantees: Codeunit 7207355;
        err001: TextConst ESP = 'No puede modificar un Estudio bloqueado';
        Text011: TextConst ESP = 'El estudio est� aceptado o rechazado, no puede cambiar este campo';
        Text012: TextConst ESP = 'El estudio solo lo puede desbloquear el que lo bloque� o el responsable del proyectos';
        FunctionQB: Codeunit 7207272;
        Descriptions: ARRAY[10] OF Text;
        Version: Boolean;
        InternalStatusEditable: Boolean;
        ChangeStatus: Boolean;
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
        edGuaranteePro: Boolean;
        edGuaranteeDef: Boolean;
        stGuarantee: Boolean;
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
        QB_MandatoryFields: Boolean;
        QB_BlockedEnabled: Boolean;
        HaveVersions: Boolean;
        seeDragDrop: Boolean;
        edLow: Boolean;
        "--------------------------------------- Divisas": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        useCurrencies: Boolean;
        edCurrencies: Boolean;
        edCurrencyCode: Boolean;
        edInvoiceCurrencyCode: Boolean;
        canEditJobsCurrencies: Boolean;
        canChangeFactboxCurrency: Boolean;
        ShowCurrency: Integer;

    LOCAL procedure CheckContact(): Boolean;
    begin
        //QX7105 >>
        //JAV 05/08/19: - Se pasa el check del contacto a una funci�n
        if CustRec.GET(rec."Bill-to Customer No.") then begin
            if (CustRec."QB Generic Customer") and (rec."Bill-to Contact No." = '') then begin
                MESSAGE(Text50001, Rec."No.");
                CurrPage.UPDATE(FALSE);
                exit(FALSE);
            end;
        end;
        exit(TRUE);
        //QX7105 <<
    end;

    LOCAL procedure SetStGuarantee();
    begin
        //JAV 26/08/19: - Se crea un funci�n para establecer edici�n y estilo de los campos de garant�as

        Rec.CALCFIELDS("Guarantee Provisional Quote", "Guarantee Definitive Quote");
        stGuarantee := (not Job.GET(rec."Presented Version"));
        edGuaranteePro := (rec."Guarantee Provisional Quote" = '');
        edGuaranteeDef := (rec."Guarantee Definitive Quote" = '');
    end;

    LOCAL procedure GetBidderCompany(): Text;
    var
        CompetitionQuote: Record 7207307;
        Contact: Record 5050;
    begin
        //JAV 07/12/19: - Se informa del nombre de la empresa adjudicataria

        //Miro si es la propia empresa
        if CompetitionQuote.GET(rec."No.", '') then
            if CompetitionQuote."Opening Result" = CompetitionQuote."Opening Result"::Accepted then
                exit(COMPANYNAME);

        //Miro si est� definida la empresa a la que se le adjudic�
        if (Contact.GET(rec."Bidder Company")) then
            exit(Contact.Name);

        exit('');
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

        //JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
        CurrPage.JobAttributesFactbox.PAGE.LoadJobAttributesData(rec."No.");

        //JAV 02/04/20: - Bloqueo no puede ser editable si faltan datos
        QB_BlockedEnabled := not rec."Data Missed";

        //JAV 26/08/19: - Se crea un funci�n para establecer edici�n y estilo de los campos de garant�as
        SetStGuarantee;

        //JAV 09/04/20: - Si tiene versiones
        JobVersion.RESET;
        JobVersion.SETRANGE("Original Quote Code", rec."No.");
        HaveVersions := (not JobVersion.ISEMPTY);

        //Si se pueden ver las divisas del proyecto
        JobCurrencyExchangeFunction.SetRecordCurrencies(Rec, edCurrencies, canEditJobsCurrencies, canChangeFactboxCurrency, edCurrencyCode, edInvoiceCurrencyCode);

        //+Q8636
        if (seeDragDrop) then begin
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        end;
        //-Q8636

        edLow := (not rec."Low from Competitors");
    end;

    LOCAL procedure SetCurrencyFB();
    begin
        CurrPage.FB_StatusQuotesJobGen.PAGE.SetCurrency(ShowCurrency);
        CurrPage.FB_StatusQuotesBidding.PAGE.SetCurrency(ShowCurrency);
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      PGM 12/11/18: - QB4973 A�adido campo "Job Type QB" y al crear una nueva oferta se le pone el valor "Estudio" por defecto.
      JAV 11/03/19: - Se activa el bot�n de eliminar, pero se verifica que se pueda antes de lanzarlo
      JAV 13/03/19: - Elimino el campo "Card Type" porque es peligroso que lo cambie el cliente
      JAV 11/04/19: - Se a�aden los campos "Import Cost Database Code" e "Import Date"
      PGM 26/04/19: - QCPM_GAP02 Sacado los campos "Present. Quote Required Date", "Present. Quote Real Date" y rec."Improvements"
      PEL 29/04/19: - QCPM_GAP05 Control al modificar.
      RSH 29/04/19: - QX7105 A�adir Study contact No. y Study contact para permitir usar contactos de un cliente gen�rico y codigo para obligar a informar el Study contact No. si el Bill-To es gen�rico.
      PEL 02/05/19: - QCPM_GAP04 Control modificaci�n
      RSH 02/05/19: - QX7105  A�adir page action "Cambiar N� Cliente" que llama a la funci�n ChangeBillToGeneric de la T167.
      JAV 04/05/19: - El nombre del responsable comercial no se refrescaba al eliminarlo
      JAV 09/05/19: - se cambia el uso del campo "Status 2" por el de "Quote Phase", y se elimina de la pantalla por no ser operativo en QB sino en dynplus
      JAV 01/06/19: - Se a�ade control para cambiar el estado en ambos sentidos
                    - Se pasa a una funci�n el que sea editable
      JAV 02/06/19: - Se cambia el campo "Quote Phase" por rec."Internal Status"
                    - Los botones de cambiar estado se hacen editabales seg�n usuario
      JAV 12/06/19: - Cambio para las 5 fechas auxiliares m�s la de env�o al cliente
      JAV 31/07/19: - Tras crear una nueva versi�n presentar la lista de versiones con la versi�n creada ya seleccionada
      JAV 05/08/19: - Clientes gen�ricos en contacto, se simplifican las funciones y se pasa el check del contacto a una funci�n
                    - Se usan los campos est�ndar de contacto en lugar de nuevos campos creados
      JAV 06/08/19: - Se permite o no cambiar el estado interno del proyecto seg�n estado y usuario
                    - Se a�aden los campos rec."Budget Status" y rec."Blocked By"
                    - No editable si est� bloqueado, aprobado o rechazado
      JAV 08/08/19: - Se pasa a una funci�n en la tabla el que sea editable
      JAV 23/08/19: - Se eliminan FactBox duplicados
      JAV 26/08/19: - Se a�aden campos de garant�as y sus solicitudes, cambio de edici�n y estilos
      JAV 07/07/19: - Se actualiza el estilo del importe de la garant�a defintiva y la p�gina al cambiar la versi�n presentada para que refresque el fact-box
      JAV 22/09/19: - No dejar aceptar, rechazar, volver a abrir o generar proyectos de estudios bloqueados
      JAV 24/09/19: - Esta opci�n no tiene sentido en QB al eliminar el registro, no hay que mirar el campo de estado est�ndar
      JAV 02/10/19: - Se a�ade la acci�n para ver el log de cambios
                    - No eliminaba el nombre del responsable si estaba en blanco y sal�a el anterior.
                    - Se agrupan el nombre con el c�digos de los representantes en la misma l�nea de la pantalla y se mueven campos para que sea mas l�gico el orden
      JAV 05/10/19: - Se a�aden los paneles de notas y v�nculos
      JDC 23/07/19: - GAP016 Added button "ChangeStudy"
      PGM 20/09/19: - GAP011 Sacado los campos de rec."Responsibility Center" y rec."Customer Type"
      PGM 20/09/19: - GAP013 A�adida la Subpage "Externals"
      PGM 08/10/19: - GAP015 A�adido el campo rec."Project Management"
      PGM 05/11/19: - Q8192 Se pasa el campo rec."Bidder Company" a no Editable y se a�ade el campo "Bidder Company Name"
      JAV 07/12/19: - Se elimina una fecha duplicada y se informa del nombre de la empresa adjudicataria
      JAV 30/01/20: - Se crea la funci�n SetInternalStatus para unificar las llamadas a funciones de edici�n
      JAV 13/02/20: - A�adimos el manejo de atributos a los proyectos
      JAV 29/02/20: - Se elimina l�nea que no hace nada
      AML 3/10/23: - Q19785 Cambios en la creaci�n de nuevo proyecto para evitar error.
    }*///end
}







