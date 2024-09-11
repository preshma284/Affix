page 7207546 "Comparative Quote"
{
    Permissions = TableData 5714 = rimd;
    CaptionML = ENU = 'Comparative Quote', ESP = 'Comparativo Oferta';
    SourceTable = 7207412;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                Editable = NOT bContratoGenerado;
                field("No."; rec."No.")
                {

                    Editable = edCard;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Comparative To"; rec."Comparative To")
                {

                    Visible = FALSE;
                }
                grid("group48")
                {

                    GridLayout = Rows;
                    group("group49")
                    {

                        CaptionML = ESP = 'Proyecto';
                        field("Job No."; rec."Job No.")
                        {

                            Editable = edCard;


                            ShowCaption = false;
                            trigger OnValidate()
                            BEGIN
                                SetEditable;
                                IF (Rec."Job No." <> xRec."Job No.") THEN
                                    SetFieldCaption;
                                CurrPage.UPDATE;
                            END;

                            trigger OnLookup(var Text: Text): Boolean
                            VAR
                                JobNo: Code[20];
                            BEGIN
                                JobNo := Rec."Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funci�n
                                IF (FunctionQB.LookupUserJobs(JobNo)) THEN
                                    Rec.VALIDATE("Job No.", JobNo);
                                CurrPage.UPDATE;
                            END;


                        }
                        field("Description"; rec."Description")
                        {

                            Editable = false;
                            ShowCaption = false;
                        }

                    }

                }
                grid("group52")
                {

                    GridLayout = Rows;
                    group("group53")
                    {

                        CaptionML = ESP = 'Partida Presupuestaria/U.O.';
                        field("QB Budget item"; rec."QB Budget item")
                        {

                            CaptionClass = '1,5,' + txtFieldCaption;
                            Editable = edCard;


                            ShowCaption = false;
                            trigger OnValidate()
                            BEGIN
                                CurrPage.UPDATE;
                            END;


                        }
                        field("GetDescriptionPartida_"; GetDescriptionPartida)
                        {

                            Editable = edCard;


                            ShowCaption = false;
                            trigger OnValidate()
                            BEGIN
                                CurrPage.UPDATE;
                            END;


                        }

                    }

                }
                grid("group56")
                {

                    GridLayout = Rows;
                    group("group57")
                    {

                        CaptionML = ESP = 'Filtro Actividad';
                        field("Activity Filter"; rec."Activity Filter")
                        {

                            Editable = edCard;
                            ShowCaption = false;
                        }
                        field("GetDescriptionActivity"; rec."GetDescriptionActivity")
                        {

                            CaptionML = ESP = 'Descripci�n actividad';
                            ShowCaption = false;
                        }

                    }

                }
                field("Area Activity"; rec."Area Activity")
                {

                    Visible = FALSE;
                }
                field("Comparative Date"; rec."Comparative Date")
                {

                    Editable = edCard;
                }
                field("Comparative Type"; rec."Comparative Type")
                {

                    Enabled = false;
                }
                field("Location Code"; rec."Location Code")
                {

                    Visible = FALSE;
                }
                field("Comparative Status"; rec."Comparative Status")
                {

                }
                group("group65")
                {

                    CaptionML = ESP = 'k';
                    field("K"; rec."K")
                    {

                    }
                    field("K sobre"; rec."K sobre")
                    {

                    }

                }
                group("group68")
                {

                    CaptionML = ESP = 'Aprobaci�n';
                    field("Approval Status"; rec."Approval Status")
                    {

                    }
                    field("QB Approval Circuit Code"; rec."QB Approval Circuit Code")
                    {

                        ToolTipML = ESP = 'Que circuito de aprobaci�n que se utilizar� para este documento';
                        Enabled = CanRequestApproval;
                        Editable = edCard;

                        ; trigger OnLookup(var Text: Text): Boolean
                        BEGIN
                            //QRE16699+
                            rQBApprovalCircuitHeader.RESET;
                            rQBApprovalCircuitHeader.FILTERGROUP(1);
                            rQBApprovalCircuitHeader.SETRANGE("Document Type", rQBApprovalCircuitHeader."Document Type"::Comparative);

                            //JAV 06/05/22: - Si se filtra fuerza mucho a que no se pueda cambiar el circuito, si ese es el objetivo se debe cambiar el m�todo de uso, pero lo mantenemos por Culmia
                            IF (Job.GET(rec."Job No.")) THEN BEGIN
                                IF Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion] THEN BEGIN
                                    rQBApprovalCircuitHeader.SETFILTER("Job No.", '%1|%2', '', Rec."Job No.");
                                    rQBApprovalCircuitHeader.SETFILTER(CA, '%1|%2', '', Rec."QB Budget item");
                                END;
                            END;

                            CLEAR(pQBApprovalCircuitList);
                            pQBApprovalCircuitList.SETTABLEVIEW(rQBApprovalCircuitHeader);
                            pQBApprovalCircuitList.LOOKUPMODE(TRUE);
                            IF (pQBApprovalCircuitList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                                pQBApprovalCircuitList.GETRECORD(rQBApprovalCircuitHeader);
                                Rec."QB Approval Circuit Code" := rQBApprovalCircuitHeader."Circuit Code";
                            END;
                            //QRE16699-
                        END;


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
                group("group74")
                {

                    CaptionML = ENU = 'Obralia', ESP = 'Obralia';
                    Visible = vObralia;
                    field("ObraliaLogEntry.User"; ObraliaLogEntry.User)
                    {

                        CaptionML = ESP = 'Usuario';
                        Editable = FALSE;
                    }
                    field("ObraliaLogEntry.Datetime Process"; ObraliaLogEntry."Datetime Process")
                    {

                        CaptionML = ESP = 'Fecha';
                        Editable = FALSE;
                    }
                    field("ObraliaLogEntry.GetResponse"; ObraliaLogEntry.GetResponse)
                    {

                        CaptionML = ESP = 'Semaforo';
                        Editable = FALSE;
                        StyleExpr = ObraliaStyle;

                        ; trigger OnAssistEdit()
                        VAR
                            ObraliaLogEntry: Record 7206904;
                        BEGIN
                            ObraliaLogEntry.ViewResponse(rec."Obralia Entry");
                        END;


                    }
                    field("ObraliaLogEntry.urlConsulta"; ObraliaLogEntry.urlConsulta)
                    {

                        ExtendedDatatype = URL;
                        CaptionML = ESP = 'URL Consulta';
                        Editable = false;
                    }

                }
                field("QB User ID"; rec."QB User ID")
                {

                }
                group("group80")
                {

                    CaptionML = ESP = 'Generaci�n';
                    field("QB Comp Value Qty.  Purc. Line"; rec."QB Comp Value Qty.  Purc. Line")
                    {

                        Editable = edCard;
                    }
                    field("Requirements date"; rec."Requirements date")
                    {

                        ToolTipML = ESP = 'Fecha de necesidad, cuando pase al pedido ser� la fecha de recepci�n esperada';
                        Editable = edCard;
                    }
                    field("Generate for months"; rec."Generate for months")
                    {

                        ToolTipML = ESP = 'Indica si se generar�n tantas l�neas en el pedido en tantos meses como cantidad se indique aqu�';
                        Visible = seeMonths;
                        Editable = edCard;

                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }

                }

            }
            group("group84")
            {

                CaptionML = ESP = 'Contrato';
                Editable = NOT bContratoGenerado;
                group("group85")
                {

                    CaptionML = ESP = 'Selecci�n';
                    field("Selection Made"; rec."Selection Made")
                    {

                    }
                    field("Selected Vendor"; rec."Selected Vendor")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            Vendor.RESET;
                            Vendor.SETRANGE("No.", rec."Selected Vendor");
                            IF Vendor.FINDFIRST THEN
                                VendorName := Vendor.Name;
                        END;


                    }
                    field("VendorName"; VendorName)
                    {

                        CaptionML = ENU = 'Vendor Name', ESP = 'Nombre Proveedor';
                        Editable = FALSE;
                    }
                    field("Contact Selectd No."; rec."Contact Selectd No.")
                    {

                        Visible = FALSE;
                    }
                    field("Selected Version No."; rec."Selected Version No.")
                    {

                    }
                    field("Amount Purchase"; rec."Amount Purchase")
                    {

                    }
                    field("Payment Phases"; rec."Payment Phases")
                    {

                    }
                    field("Payment Terms Code"; rec."Payment Terms Code")
                    {

                    }
                    field("Payment Method Code"; rec."Payment Method Code")
                    {

                    }
                    field("Currency Code"; rec."Currency Code")
                    {

                        Editable = FALSE;
                    }
                    field("Currency Factor"; rec."Currency Factor")
                    {

                        Editable = FALSE;
                    }

                }
                group("group97")
                {

                    CaptionML = ESP = 'Contrato';
                    field("Generate Type"; rec."Generate Type")
                    {

                        Editable = edCard;

                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }
                    field("Main Contract Doc No."; rec."Main Contract Doc No.")
                    {

                        Enabled = actMainContract;
                    }
                    field("Generated Contract Doc Type"; rec."Generated Contract Doc Type")
                    {

                    }
                    field("Generated Contract Doc No."; rec."Generated Contract Doc No.")
                    {

                    }
                    field("Generated Contract Ext No."; rec."Generated Contract Ext No.")
                    {

                    }
                    field("Generated Contract Date"; rec."Generated Contract Date")
                    {

                    }

                }

            }
            part("DocLin"; 7207547)
            {
                SubPageLink = "Quote No." = FIELD("No.");
                Editable = edCard;
                UpdatePropagation = Both;
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
            part("part4"; 7207627)
            {
                SubPageLink = "No." = FIELD("No.");
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
                CaptionML = ENU = '&Quote', ESP = '&Comparativo';
                action("Dimensions")
                {

                    AccessByPermission = TableData 348 = R;
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                    ApplicationArea = Dimensions;
                    Enabled = rec."No." <> '';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        //JAV 28/02/22: - QB 1.10.22 A�adimos el bot�n de dimensiones que no lo ten�a la p�gina
                        COMMIT;

                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207577;
                    RunPageLink = "Quote Code" = FIELD("No.");
                    Image = Statistics;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Proyecto';
                    Image = EditLines;

                    trigger OnAction()
                    VAR
                        Job: Record 167;
                        OperativeJobsCard: Page 7207478;
                        QPRBudgetJobsCard: Page 7207102;
                        REActiveCard: Page 7207092;
                    BEGIN
                        //JAV 28/02/22: - QB 1.10.22 Seg�n el tipo de proyecto debe usarse una u otra p�gina para verlo
                        Job.GET(Rec."Job No.");

                        CASE Job."Card Type" OF
                            Job."Card Type"::"Proyecto operativo":
                                BEGIN
                                    CLEAR(OperativeJobsCard);
                                    OperativeJobsCard.SETRECORD(Job);
                                    OperativeJobsCard.RUNMODAL;
                                END;
                            Job."Card Type"::Presupuesto:
                                BEGIN
                                    CLEAR(QPRBudgetJobsCard);
                                    QPRBudgetJobsCard.SETRECORD(Job);
                                    QPRBudgetJobsCard.RUNMODAL;
                                END;
                            Job."Card Type"::Promocion:
                                BEGIN
                                    CLEAR(REActiveCard);
                                    REActiveCard.SETRECORD(Job);
                                    REActiveCard.RUNMODAL;
                                END;
                        END;
                    END;


                }
                action("action4")
                {
                    CaptionML = ESP = 'Pasar al Proyecto';
                    Visible = seeQuote;
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    BEGIN
                        CLEAR(ComparativeQuoteFunctions);
                        ComparativeQuoteFunctions.MoveFromQuoteToJob(Rec);
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Update Coste Price', ESP = 'Actualizar Precios Coste';
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    BEGIN
                        //JAV 26/03/19: - Nueva acci�n y funci�n para actualizar precios de coste del presupuesto
                        UpdateLinesPrices;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Update unit cost to budget', ESP = 'Actualizar precios en presupuesto';
                    Image = OrderTracking;

                    trigger OnAction()
                    BEGIN
                        CurrPage.DocLin.PAGE.BreakDown_UpdatePrices(TRUE);
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Quotes Comparative"), "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }
            group("group10")
            {
                CaptionML = ENU = 'Functions', ESP = '&Acciones';
                action("action8")
                {
                    CaptionML = ENU = 'C&rear l�neas en descompuesto', ESP = 'C&rear l�neas en descompuesto';
                    Enabled = bAsociar;
                    Image = OrderTracking;

                    trigger OnAction()
                    BEGIN
                        CurrPage.DocLin.PAGE.BreakDown;
                    END;


                }
                action("action9")
                {
                    CaptionML = ENU = '&Incluir contactos de otras actividades', ESP = '&Incluir contactos de otras actividades';
                    Enabled = bAsociar;
                    Image = AddContacts;

                    trigger OnAction()
                    VAR
                        ComparativeQuoteFunctions: Codeunit 7207333;
                    BEGIN
                        ComparativeQuoteFunctions.AddContactsToActivity(Rec);
                    END;


                }
                action("action10")
                {
                    CaptionML = ENU = '&Fijar precio objetivo', ESP = '&Fijar precio objetivo';
                    Enabled = bAsociar;
                    Image = SuggestSalesPrice;

                    trigger OnAction()
                    VAR
                        ComparativeQuoteLines: Record 7207413;
                        ComparativeQuoteHeader: Record 7207412;
                    BEGIN
                        //ComparativeQuoteLines.RESET;
                        //ComparativeQuoteLines.SETRANGE("Quote No.","No.");
                        ComparativeQuoteHeader.RESET;
                        ComparativeQuoteHeader.SETRANGE("No.", rec."No.");
                        IF ComparativeQuoteHeader.FINDFIRST THEN BEGIN
                            // SetTargetPriceComparative.GetK(ComparativeQuoteHeader);
                            // SetTargetPriceComparative.SETTABLEVIEW(ComparativeQuoteHeader);
                            // SetTargetPriceComparative.RUNMODAL;
                            // CLEAR(SetTargetPriceComparative);
                            //REPORT.RUNMODAL(REPORT::"Set Target Price Comparative",TRUE,TRUE,ComparativeQuoteHeader);
                        END;
                    END;


                }

            }
            group("group14")
            {
                CaptionML = ENU = 'Functions', ESP = '&Generar';
                action("action11")
                {
                    CaptionML = ENU = '&Generar Comparativa', ESP = 'Asociar Proveedores';
                    Enabled = bAsociar;
                    Image = BOMVersions;

                    trigger OnAction()
                    BEGIN
                        //JAV 10/08/19 - Se a�ade la llamada a la funci�n AddPreselectedVendor para a�adirlos al comparativo
                        AddPreselectedVendor;
                        SelectedVendorsQuote.SETRANGE("Quote No.", rec."No.");

                        CLEAR(SelectVendortoCompare);
                        SelectVendortoCompare.SETTABLEVIEW(SelectedVendorsQuote);
                        SelectVendortoCompare.LOOKUPMODE(TRUE);
                        SelectVendortoCompare.RUNMODAL;
                    END;


                }
                action("action12")
                {
                    CaptionML = ENU = 'Proponer &subcontrataciones', ESP = 'Proponer Subcontrat.';
                    Enabled = bAsociar;
                    Image = CreatePutAway;

                    trigger OnAction()
                    BEGIN
                        GetSubcontracting;
                    END;


                }
                action("action13")
                {
                    CaptionML = ENU = '&Condiciones del proveedor', ESP = 'Condiciones proveedor';
                    Image = SuggestVendorPayments;

                    trigger OnAction()
                    VAR
                        ConditionsVendorQuote: Page 7207549;
                        VendorConditionsData: Record 7207414;
                    BEGIN
                        //JAV 10/08/19 - Se a�ade la llamada a la funci�n AddPreselectedVendor para a�adirlos al comparativo
                        AddPreselectedVendor;

                        IF rec."Approval Status" <> rec."Approval Status"::Open THEN
                            MESSAGE(Text004);    //JAV 27/12/18 - Poder ver condiciones de proveedor pero no modificar si el comparativo est� lanzado

                        COMMIT;   //- PSM 27/04/22 Por el Run Modal

                        VendorConditionsData.RESET;
                        VendorConditionsData.SETRANGE(VendorConditionsData."Quote Code", rec."No.");

                        CLEAR(ConditionsVendorQuote);
                        ConditionsVendorQuote.SETTABLEVIEW(VendorConditionsData);
                        ConditionsVendorQuote.EDITABLE := (rec."Approval Status" = rec."Approval Status"::Open);  //JAV 27/12/18 - Poder ver condiciones de proveedor pero no modificar si el comparativo est� lanzado
                        ConditionsVendorQuote.RUNMODAL;
                    END;


                }

            }
            group("group18")
            {
                CaptionML = ENU = 'Posting', ESP = '&Contrato';
                action("action14")
                {
                    CaptionML = ENU = '&Generar contrato', ESP = '&Generar contrato';
                    Enabled = bContratoNoGenerado;
                    Image = GetActionMessages;

                    trigger OnAction()
                    VAR
                        // GenerateBlanketOrder_Order: Report 7207346;
                    BEGIN
                        //Verificar que se pueda generar el contrato
                        IF (rec."Selected Vendor" = '') THEN
                            ERROR(Text001);
                        IF (cuApproval.IsApprovalsWorkflowActive) AND (rec."Approval Status" <> rec."Approval Status"::Released) THEN
                            ERROR(Text002);
                        IF (rec."Generated Contract Doc No." <> '') THEN
                            ERROR(Text003, rec."Generated Contract Doc No.");
                        IF (rec."Generate Type" = rec."Generate Type"::Extension) AND (rec."Main Contract Doc No." = '') THEN
                            ERROR(Text011);
                        cuApproval.CheckVendorComparativeBloqued(Rec);  //QPE6436 Verificar que no est� bloqueado el proveedor para comparativos

                        //Generar el contrato
                        // CLEAR(GenerateBlanketOrder_Order);
                        // GenerateBlanketOrder_Order.SetComparativeHeader(rec."No.");
                        // GenerateBlanketOrder_Order.RUNMODAL;

                        //JAV 08/05/19 - A�adir entrada al control de contratos
                        QuoBuildingSetup.GET;
                        IF QuoBuildingSetup."Use Contract Control" THEN
                            ControlContratos.AsociarContrato(Rec, FALSE);

                        //JAV 10/08/19: - Si est� configurado actualizar precios en descompuestos al generar contrato, hacerlo
                        QuoBuildingSetup.GET();
                        IF (QuoBuildingSetup."Act.Price on Generate Contract") THEN BEGIN
                            CurrPage.DocLin.PAGE.BreakDown_UpdatePrices(FALSE);
                            COMMIT;
                        END;

                        //JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o al desechar, cambiar el estado
                        Rec.FIND('=');
                        Rec."Comparative Status" := Rec."Comparative Status"::Generated;
                        Rec.MODIFY(TRUE);
                        COMMIT;

                        //Tras generar dar el mensaje y permitir ir al documento
                        CASE Rec."Generate Type" OF
                            Rec."Generate Type"::Contract:
                                Text := STRSUBSTNO(Text020, Text021, FORMAT(PurchaseHeader."Document Type"), PurchaseHeader."No.", Rec."No.");
                            Rec."Generate Type"::Extension:
                                Text := STRSUBSTNO(Text020, Text022, FORMAT(PurchaseHeader."Document Type"), PurchaseHeader."No.", Rec."No.");
                        END;

                        IF (CONFIRM(Text)) THEN
                            SeeContrat;
                    END;


                }
                action("action15")
                {
                    CaptionML = ENU = '&Asociar Contrato', ESP = '&Asociar contrato';
                    Visible = false;
                    Enabled = bContratoNoGenerado;
                    Image = Link;

                    trigger OnAction()
                    VAR
                        QBComparatives: Codeunit 7207328;
                    BEGIN
                        //OPCION DESACTIVADA: Da errores y no se usa actualmente, hay que rehacerla de otra manera si se desea mantenerla

                        IF (cuApproval.IsApprovalsWorkflowActive) AND (rec."Approval Status" <> rec."Approval Status"::Released) THEN
                            ERROR(Text002);

                        //-QPE6436
                        cuApproval.CheckVendorComparativeBloqued(Rec);
                        //+QPE6436

                        //Asociar el contrato
                        QBComparatives.AsociateContract(Rec);

                        //JAV 08/05/19 - A�adir entrada al control de contratos
                        ControlContratos.AsociarContrato(Rec, FALSE);

                        //JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o al desechar, cambiar el estado
                        Rec.FIND('=');
                        Rec."Comparative Status" := Rec."Comparative Status"::Approved;
                        Rec.MODIFY(TRUE);
                    END;


                }
                action("action16")
                {
                    CaptionML = ENU = 'Order', ESP = '&Ver Contrato';
                    Enabled = bContratoGenerado;
                    Image = Document;

                    trigger OnAction()
                    BEGIN
                        //JAV 11/03/19: - Se promueve el bot�n de ir al pedido, se cambia el caption a contrato y se mejora la acci�n cambia el bot�n de acci�n para ir al contrato generado
                        //JAV 05/06/22: - Se pasa a una funci�n para unificar llamarlo desde dos lugares
                        SeeContrat;
                    END;


                }
                action("action17")
                {
                    CaptionML = ENU = '&Print Contract', ESP = 'Imprimir contrato';
                    Enabled = bContratoGenerado;
                    Image = PrintForm;

                    trigger OnAction()
                    VAR
                        PurchaseHeader: Record 38;
                        Text005: TextConst ESP = 'false ha generado un contrato o el indicado no existe';
                        QBPagePublisher: Codeunit 7207348;
                    BEGIN
                        //JAV 14/03/19: - Nueva funci�n para imprimir pedidos o pedidos abiertos como contratos
                        IF rec."Generated Contract Doc No." = '' THEN
                            ERROR(Text005)
                        ELSE BEGIN
                            IF PurchaseHeader.GET(PurchaseHeader."Document Type"::"Blanket Order", rec."Generated Contract Doc No.") THEN
                                QBPagePublisher.PurchaseContractPrint(PurchaseHeader."Document Type", PurchaseHeader."No.")
                            ELSE IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, rec."Generated Contract Doc No.") THEN
                                QBPagePublisher.PurchaseContractPrint(PurchaseHeader."Document Type", PurchaseHeader."No.")
                            ELSE
                                ERROR(Text006);
                        END;
                    END;


                }
                action("Delete Contract")
                {

                    CaptionML = ENU = 'Delete Contract', ESP = 'Eliminar contrato';
                    Enabled = bContratoGenerado;
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    VAR
                        PurchaseHeader: Record 38;
                        PurchaseLine: Record 39;
                    BEGIN
                        //PGM y JAV 21/03/2019 - A�adida acci�n para eliminar el contrato generado
                        IF (rec."Generated Contract Doc No." = '') THEN
                            ERROR(Text005)
                        ELSE IF CONFIRM(Text008, FALSE) THEN
                            rec.EliminarContrato(TRUE);
                    END;


                }

            }

        }
        area(Reporting)
        {

            group("group25")
            {
                CaptionML = ENU = 'Posting', ESP = 'Imprimir';
                action("action19")
                {
                    CaptionML = ENU = 'Print', ESP = '&Imprimir';
                    Image = Print;

                    trigger OnAction()
                    VAR
                        ComparativeQuoteHeader: Record 7207412;
                        // ComparativeQuotePrinting: Report 7207352;
                    BEGIN
                        ComparativeQuoteHeader.SETRANGE("No.", rec."No.");

                        // CLEAR(ComparativeQuotePrinting);
                        // ComparativeQuotePrinting.SETTABLEVIEW(ComparativeQuoteHeader);
                        // ComparativeQuotePrinting.SetJob(Rec."Job No.");  //JAV 26/01/22: - QB 1.10.14 Le pasamos el proyecto al report
                        // ComparativeQuotePrinting.RUNMODAL;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group28")
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
                    VAR
                        ApprovalsMgmt: Codeunit 1535;
                    BEGIN
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    END;


                }

            }
            group("group34")
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
                    VAR
                        WorkflowsEntriesBuffer: Record 832;
                        QBApprovalSubscriber: Codeunit 7207354;
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
                    VAR
                        WorkflowWebhookMgt: Codeunit 1543;
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
                    VAR
                        ReleaseComparativeQuote: Codeunit 7207332;
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
                    VAR
                        ReleaseComparativeQuote: Codeunit 7207332;
                    BEGIN
                        cuApproval.PerformManualReopen(Rec);

                        //JAV 02/06/22: - QB 1.10.47 Al volver a abrir el documento, cambiar el estado
                        IF (Rec."Comparative Status" = Rec."Comparative Status"::Generated) THEN BEGIN
                            Rec.FIND('=');
                            IF (Rec."Generated Contract Doc No." <> '') THEN
                                Rec."Comparative Status" := Rec."Comparative Status"::Approved
                            ELSE IF (Rec."Selected Vendor" <> '') THEN
                                Rec."Comparative Status" := Rec."Comparative Status"::Selected
                            ELSE
                                Rec."Comparative Status" := Rec."Comparative Status"::InProcess;
                            Rec.MODIFY(TRUE);
                            CurrPage.UPDATE;
                        END;
                    END;


                }
                action("QB_Obralia")
                {

                    CaptionML = ENU = 'Obralia', ESP = 'Solicitud Obralia';
                    Visible = vObralia;
                    Enabled = aObralia;
                    Image = Web;
                    trigger OnAction()
                    VAR
                        Obralia: Codeunit 7206901;
                        ObraliaLogEntry: Record 7206904;
                        Response: Text[1];
                        ConfirmObralia: TextConst ENU = 'Do you want to check Obralia staus?', ESP = '�Desea comprobar el estado en Obralia?';
                    BEGIN
                        //OBR
                        IF CONFIRM(ConfirmObralia, FALSE) THEN
                            rec.VALIDATE("Obralia Entry", Obralia.SemaforoRequest_Comparative(Rec, TRUE));
                    END;

                }
                action("QB_Close")
                {

                    CaptionML = ENU = 'Close', ESP = 'Cerrar';
                    Visible = seeClose;
                    Image = Close;

                    trigger OnAction()
                    BEGIN
                        IF (Rec."Comparative Status" = Rec."Comparative Status"::Approved) THEN
                            ERROR('No puede cerrar un comparativo generado');
                        Rec."Comparative Status" := Rec."Comparative Status"::Closed;
                        Rec.MODIFY(TRUE);
                        MESSAGE('El documento ha pasado a la lista de comparativos cerrados');
                    END;


                }

            }
            group("group42")
            {
                CaptionML = ENU = 'Posting', ESP = '&Control Contrato';
                action("action32")
                {
                    CaptionML = ESP = 'Aumentar';
                    Visible = verControlcontrato;
                    Enabled = bContratoGenerado;
                    Image = CarryOutActionMessage;


                    trigger OnAction()
                    VAR
                        AddContractImport: Page 7207567;
                    BEGIN
                        //JAV 29/08/19: - Control de contratos, bot�n de ampliar importe
                        Funcionesdecontratos.AmpliarContrato(Rec);
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

                actionref(action3_Promoted; action3)
                {
                }
                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref(action13_Promoted; action13)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(action19_Promoted; action19)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = '4', ESP = 'Lanzar';

                actionref(QB_Close_Promoted; QB_Close)
                {
                }
                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
                actionref(QB_Obralia_Promoted; QB_Obralia)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';

                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(action32_Promoted; action32)
                {
                }
            }
            group(Category_Category6)
            {
                CaptionML = ENU = '5', ESP = 'Aprobar';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(QB_WithHolding_Promoted; QB_WithHolding)
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
            group(Category_Category7)
            {
                CaptionML = ENU = 'Contract', ESP = 'Contrato';

                actionref(action14_Promoted; action14)
                {
                }
                actionref(action15_Promoted; action15)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
                actionref(action17_Promoted; action17)
                {
                }
                actionref("Delete Contract_Promoted"; "Delete Contract")
                {
                }
            }
            group(Category_Category8)
            {
                actionref(Dimensions_Promoted; Dimensions)
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
        //JAV 29/08/19: - Control de contratos
        verControlContrato := Funcionesdecontratos.ModuloActivo;
        verAumentoContrato := FALSE;
        IF UserSetup.GET(USERID) THEN
            verAumentoContrato := (verControlContrato AND UserSetup."Control Contracts");

        IF Job.GET(rec."Job No.") THEN
            seeQuote := (Job."Card Type" = Job."Card Type"::Estudio);

        //Obralia
        vObralia := (FunctionQB.AccessToObralia);

        //Q7357 -
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF seeDragDrop THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Comparative Quote Header");
        //Q7357 +

        QuoBuildingSetup.GET;
        seeMonths := QuoBuildingSetup."Comparatives by months";


        SetFieldCaption();
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        IF Rec.FIND(Which) THEN
            EXIT(TRUE)
        ELSE BEGIN
            Rec.SETRANGE("No.");
            EXIT(Rec.FIND(Which));
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        VendorName := '';
        IF Vendor.GET(Rec."Selected Vendor") THEN
            VendorName := Vendor.Name;

        //JAV 10/03/20: - Se llama a la funci�n para activar los controles de aprobaci�n
        cuApproval.SetApprovalsControls(Rec, ApprovalsActive, OpenApprovalsPage, CanRequestApproval, CanCancelApproval, CanRelease, CanReopen);

        //Obralia
        SetEditable;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //+Q8636
        IF seeDragDrop THEN BEGIN
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        END;
        //-Q8636
        SetFieldCaption();
        SetEditable;
    END;



    var
        ComparativeQuoteLines: Record 7207413;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        SelectedVendorsQuote: Record 7207429;
        VendorTemp: Record 23 TEMPORARY;
        Text001: TextConst ENU = 'You can not generate a contract if the vendor is empty or the quote has not been launched and has followed the approval cycle', ESP = 'No se puede generar contrato si no ha seleccionado proveedor';
        Text002: TextConst ENU = 'You can not generate a contract if the vendor is empty or the quote has not been launched and has followed the approval cycle', ESP = 'No se puede generar contrato si la oferta no ha sido lanzada y ha seguido el ciclo de aprobaciones';
        Text003: TextConst ENU = 'Can not rebuild an order under a comparative used. \Blanket Order created %1', ESP = 'No se puede volver a generar un pedido bajo una comparativa utilizada.\ Pedido Abierto creado %1';
        Text004: TextConst ENU = 'The conditions of the Vendor can not be modified if the Quote  is not in the open state', ESP = 'No se puede modificar las condiciones del proveedor si la oferta no esta en estado abierto';
        Vendor: Record 23;
        Text005: TextConst ESP = 'No ha generado el contrato';
        Text006: TextConst ESP = 'El contrato generado ya no existe';
        Text007: TextConst ESP = 'El contrato no se puede eliminar porque existen l�neas con cantidad recibida.';
        Text008: TextConst ESP = 'Confirme que desea borrar el contrato generado';
        QuoBuildingSetup: Record 7207278;
        UserSetup: Record 91;
        Job: Record 167;
        ComparativeQuoteFunctions: Codeunit 7207333;
        Funcionesdecontratos: Codeunit 7206907;
        FunctionQB: Codeunit 7207272;
        ControlContratos: Codeunit 7206907;
        // SetTargetPriceComparative: Report 7207353;
        SelectVendortoCompare: Page 7207579;
        VendorName: Text;
        verAumentoContrato: Boolean;
        verControlContrato: Boolean;
        bContratoGenerado: Boolean;
        bContratoNoGenerado: Boolean;
        bAsociar: Boolean;
        useCurrencies: Boolean;
        seeQuote: Boolean;
        vObralia: Boolean;
        aObralia: Boolean;
        Obralia: Codeunit 7206901;
        ObraliaLogEntry: Record 7206904;
        ObraliaStyle: Text;
        seeDragDrop: Boolean;
        actMainContract: Boolean;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        seeMonths: Boolean;
        txtFieldCaption: Text;
        rQBApprovalCircuitHeader: Record 7206986;
        pQBApprovalCircuitList: Page 7207040;
        seeClose: Boolean;
        edCard: Boolean;
        Text: Text;
        DataPieceworkForProduction: Record 7207386;
        "---------------------------- Aprobaciones inicio": Integer;
        cuApproval: Codeunit 7206916;
        QBApprovalManagement: Codeunit 7207354;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsActive: Boolean;
        OpenApprovalsPage: Boolean;
        CanRequestApproval: Boolean;
        CanCancelApproval: Boolean;
        CanRelease: Boolean;
        CanReopen: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        Text009: TextConst ESP = 'El proyecto est� cerrado, no puede modificar';
        Text010: TextConst ESP = 'No puede recalcular, ya ha elegido proveedor';
        Text011: TextConst ESP = 'Ha seleccionado generar una extensi�n, pero no ha indicado el contrato que extender.';
        Text020: TextConst ESP = 'A partir del comparativo %4\se ha %1 el %2 n� %3 y ha pasado a la lista de comprativos generados. �Desea ver el documento generado?';
        Text021: TextConst ESP = 'Creado';
        Text022: TextConst ESP = 'Ampliado';

    procedure GetSubcontracting();
    var
        ComparativeQuoteLines: Record 7207413;
    begin
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."No.");
        if not ComparativeQuoteLines.FINDLAST then
            ComparativeQuoteLines."Quote No." := rec."No.";
        CODEUNIT.RUN(CODEUNIT::"Get Complete Subcontracting", ComparativeQuoteLines);
    end;

    LOCAL procedure SaveReportAsExcel(VendorConditionsData: Record 7207414);
    var
        TempFile: File;
        Name: Text[250];
        NewStream: InStream;
        ToFile: Text[250];
        ReturnValue: Boolean;
    begin
        // Specify that TempFile is opened as a binary file.
        TempFile.TEXTMODE(FALSE);
        // Specify that you can write to TempFile.
        TempFile.WRITEMODE(TRUE);
        Name := 'C:\QMD\TempReport.xls';
        // Create and open TempFile.
        TempFile.CREATE(Name);
        // Close TempFile so that the SAVEASEXCEL function can write to it.
        TempFile.CLOSE;
        REPORT.SAVEASEXCEL(7207357, Name, VendorConditionsData);
        TempFile.OPEN(Name);
        TempFile.CREATEINSTREAM(NewStream);
        ToFile := 'Report.xls';
        // Transfer the content from the temporary file on Microsoft Dynamics NAV
        // Server to a file on the client.
        ReturnValue := DOWNLOADFROMSTREAM(
          NewStream,
          'Save file to client',
          '',
          'Excel File *.xls| *.xls',
          ToFile);
        // Close the temporary file.
        TempFile.CLOSE();
    end;

    //[Business]
    LOCAL procedure PAGcomparativeQuote_OnPrePrint(DocumentNo: Code[20]);
    begin
    end;

    procedure UpdateLinesPrices();
    var
        ComparativeQuoteLines: Record 7207413;
        Job: Record 167;
        DataCostByPiecework: Record 7207387;
    begin
        //JAV 26/03/19: - Funci�n para actualizar precios de coste del presupuesto
        if (rec."Selected Vendor" <> '') then
            ERROR(Text010);

        Job.GET(rec."Job No.");
        if (Job.Status <> Job.Status::Open) then
            ERROR(Text009);

        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."No.");
        if (ComparativeQuoteLines.FINDSET) then
            repeat
                DataCostByPiecework.RESET;
                DataCostByPiecework.SETRANGE("Job No.", Job."No.");
                DataCostByPiecework.SETRANGE("Piecework Code", ComparativeQuoteLines."Piecework No.");
                DataCostByPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                if ComparativeQuoteLines.Type = ComparativeQuoteLines.Type::Item then
                    DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Item);
                if ComparativeQuoteLines.Type = ComparativeQuoteLines.Type::Resource then
                    DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
                DataCostByPiecework.SETRANGE("No.", ComparativeQuoteLines."No.");
                if DataCostByPiecework.FINDFIRST then begin
                    ComparativeQuoteLines.VALIDATE("Estimated Price", DataCostByPiecework."Direct Unitary Cost (JC)");
                    ComparativeQuoteLines.MODIFY;
                end;
            until ComparativeQuoteLines.NEXT = 0;
    end;

    LOCAL procedure AddPreselectedVendor();
    var
        SelectedVendorsQuote: Record 7207429;
        VendorConditionsData: Record 7207414;
    begin
        //JAV 10/08/19: - Nueva funci�n para a�adir vendedores preseleccionados a un comparativo
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."No.");
        if (ComparativeQuoteLines.FINDSET(FALSE)) then
            repeat
                if (ComparativeQuoteLines."Preselected Vendor" <> '') then begin
                    SelectedVendorsQuote.AddVendor(rec."Job No.", rec."No.", rec."Activity Filter", ComparativeQuoteLines."Preselected Vendor", '');
                end;
            until (ComparativeQuoteLines.NEXT = 0);
        COMMIT;
    end;

    LOCAL procedure SetEditable();
    begin
        if not ObraliaLogEntry.GET(rec."Obralia Entry") then
            ObraliaLogEntry.INIT
        ELSE
            ObraliaStyle := ObraliaLogEntry.GetResponseStyle;

        aObralia := FALSE;
        if Job.GET(rec."Job No.") then
            aObralia := (Job."Obralia Code" <> '');

        actMainContract := (rec."Generate Type" = rec."Generate Type"::Extension);

        //JAV 04/12/19: - Se activan los botones asociados al contrato solo si es posible usarlos
        bContratoNoGenerado := (rec."Generated Contract Doc No." = '') and (rec."Approval Status" = rec."Approval Status"::Released);
        bContratoGenerado := (rec."Generated Contract Doc No." <> '');

        //JAV 02/06/22: - La ficha ser� editable mientras el estado sea en proceso
        edCard := (Rec."Comparative Status" IN [Rec."Comparative Status"::InProcess, Rec."Comparative Status"::Selected]);
        bAsociar := (not bContratoGenerado) and (Rec."Comparative Status" <> Rec."Comparative Status"::Generated);
        //bContratoGenerado   := bContratoGenerado       and (Rec."Comparative Status" <> Rec."Comparative Status"::Generated);
        //bContratoNoGenerado := bContratoNoGenerado     and (Rec."Comparative Status" <> Rec."Comparative Status"::Generated);
        //CanRequestApproval  := CanRequestApproval      and (Rec."Comparative Status" <> Rec."Comparative Status"::Generated);

        seeClose := (Rec."Comparative Status" <> Rec."Comparative Status"::Generated) and (Rec."Comparative Status" <> Rec."Comparative Status"::Closed);

        //Q13150 -
        CanReopen := not bContratoGenerado;
        //Q13150 +
    end;

    LOCAL procedure SetFieldCaption();
    var
        Job: Record 167;
    begin
        txtFieldCaption := 'C¢d. unidad de obra';
        if Job.GET(rec."Job No.") then
            if Job."Card Type" IN [Job."Card Type"::Presupuesto, Job."Card Type"::Promocion] then
                txtFieldCaption := 'Partida presupuestaria';

        //Llamamos para cambiar fieldcaption en subform. en caso necesario
        CurrPage.DocLin.PAGE.SetFieldCaption(Rec."Job No.");
    end;

    LOCAL procedure SeeContrat();
    begin
        //JAV 05/06/22: - Se pasa a una funci�n ver el documento generado para unificar llamarlo desde dos lugares
        if rec."Generated Contract Doc No." = '' then
            ERROR(Text005)
        ELSE begin
            if PurchaseHeader.GET(PurchaseHeader."Document Type"::"Blanket Order", rec."Generated Contract Doc No.") then
                PAGE.RUN(PAGE::"Blanket Purchase Order", PurchaseHeader)
            ELSE if PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, rec."Generated Contract Doc No.") then
                PAGE.RUN(PAGE::"Purchase Order", PurchaseHeader)
            ELSE
                ERROR(Text006);
        end;
    end;

    LOCAL procedure GetDescriptionPartida(): Text;
    begin
        //JAV 03/08/22: - Obtener la descripci�n de la partida presupuestaria
        if DataPieceworkForProduction.GET(rec."Job No.", rec."QB Budget item") then
            exit(DataPieceworkForProduction.Description)
        ELSE
            exit('');
    end;

    // begin
    /*{
      JAV 27/12/18: - Poder ver condiciones de proveedor pero no modificar si el comparativo est� lanzado
      PEL 13/02/19: - QPE6436 comprobar si esta bloqueado para comparatva al lanzar o generar contrato.
      JAV 14/03/19: - Se hace no visible el bot�n de lanzar si hay un fujo de aprobaci�n
      JAV 08/05/19: - A�adir entrada al control de contratos
      JAV 10/08/19: - Se a�ade la funci�n AddPreselectedVendor para a�adirlos al comparativo
                    - Si est� configurado actualizar precios en descompuestos al generar contrato, hacerlo
      JAV 04/12/19: - Se limpia la fecha del contrato al eliminarlo
                    - Se activan los botones asociados al contrato solo si es posible usarlos
                    - OBR Se a�aden campos de Obralia. Creada funci�n para llamar al WS de Obralia
      JAV 10/03/20: - Se llama a la funci�n para activar los controles de aprobaci�n
      JAV 20/01/21: - SP 1.01 Se a�ade el enlace con SharePoint
      Q13150 JDC 31/03/21 - Added field 50 "Selected Version"
                            Modified PageLayout and PageActions
      JAV 30/04/21: - QB 1.08.41 Se desactiva la opci�n de asociar a un documento existente, sa errores y no se usa actualmente, hay que rehacerla de otra manera si se desea mantenerla
      PSM 27/04/22: - QB 1.10.37 Por el RunModal se a�ade otro commit
      LCG 18/11/21: - QRE15411 A�adir campo PieceWork No.
      DGG 07/03/22: - QRE16539 Se muestra campo "QB Comp Value Qty.  Purc. Line".
      PSM 14/03/22: - QRE16699 Filtro para Lookup de Circuit Code
      DGG 26/04/22: - QRE17046 Se muestra el campo "ID Usuario"
      JAV 02/06/22: - QB 1.10.47 Se a�ade el campo Status. Al seleccionar o quitar el proveedor, al generar contrato o eliminarlo, o al desechar el comparativo, cambiar el estado del comparativo
                                 Al volver a abrir el documento, cambiar el estado
      JAV 10/08/22: - QB 1.11.01 Se a�ade la descripcion de la UO/Partida
    }*///end
}







