page 7207003 "QB Proform Card"
{
    CaptionML = ENU = 'QB Proform Card', ESP = 'QB Ficha proforma';
    SourceTable = 7206960;
    PageType = Document;

    layout
    {
        area(content)
        {
            group("group18")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.', ESP = 'Permite especificar el n�mero de una cuenta contable, un producto, un coste adicional o un activo fijo, seg�n lo que se haya seleccionado en el campo Tipo.';
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Editable = FALSE;
                }
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los productos.';
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Editable = FALSE;
                }
                field("QB_JobNo"; rec."Job No.")
                {

                    Editable = false;
                }
                field("QB_JobDescription"; JobDescription)
                {

                    CaptionML = ENU = 'Job Description', ESP = 'Descripci�n Proyecto';
                    Editable = FALSE;
                }
                group("group23")
                {

                    CaptionML = ENU = 'Buy-from', ESP = 'Direcci�n de compra';
                    field("Buy-from Vendor Name"; rec."Buy-from Vendor Name")
                    {

                        CaptionML = ENU = 'Name', ESP = 'Nombre';
                        ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los productos.';
                        ApplicationArea = Suite;
                        Editable = FALSE;
                    }
                    field("Buy-from Address"; rec."Buy-from Address")
                    {

                        CaptionML = ENU = 'Address', ESP = 'Direcci�n';
                        ToolTipML = ENU = 'Specifies the address of the vendor who delivered the items.', ESP = 'Especifica la direcci�n del proveedor que envi� los productos.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Buy-from Address 2"; rec."Buy-from Address 2")
                    {

                        CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';
                        ToolTipML = ENU = 'Specifies an additional part of the address of the vendor who delivered the items.', ESP = 'Especifica una parte adicional de la direcci�n del proveedor que envi� los productos.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Buy-from City"; rec."Buy-from City")
                    {

                        CaptionML = ENU = 'City', ESP = 'Poblaci�n';
                        ToolTipML = ENU = 'Specifies the city of the vendor who delivered the items.', ESP = 'Especifica la ciudad del proveedor que envi� los productos.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Buy-from County"; rec."Buy-from County")
                    {

                        CaptionML = ENU = 'County', ESP = 'Provincia';
                        ToolTipML = ENU = 'Specifies the state, province or county related to the posted purchase order.', ESP = 'Especifica el estado, provincia o comarca relacionados con el pedido de compra registrada.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Buy-from Post Code"; rec."Buy-from Post Code")
                    {

                        CaptionML = ENU = 'Post Code', ESP = 'C�digo postal';
                        ToolTipML = ENU = 'Specifies the post code of the vendor who delivered the items.', ESP = 'Especifica el c�digo postal del proveedor que envi� los productos.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Buy-from Country/Region Code"; rec."Buy-from Country/Region Code")
                    {

                        CaptionML = ENU = 'Country/Region', ESP = 'Pa�s/regi�n';
                        ToolTipML = ENU = 'Specifies the country or region of the address.', ESP = 'Especifica el pa�s o la regi�n de la direcci�n.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Buy-from Contact"; rec."Buy-from Contact")
                    {

                        CaptionML = ENU = 'Contact', ESP = 'Contacto';
                        ToolTipML = ENU = 'Specifies the name of the contact person at the vendor who delivered the items.', ESP = 'Especifica el nombre de la persona de contacto del proveedor que entreg� los productos.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }

                }
                group("group32")
                {

                    CaptionML = ESP = 'Pedido';
                    field("Order No."; rec."Order No.")
                    {

                        ToolTipML = ENU = 'Specifies the line number of the order that created the entry.', ESP = 'Especifica el n�mero de l�nea del pedido que cre� el movimiento.';
                        ApplicationArea = Basic, Suite;
                        Editable = FALSE;
                    }
                    field("Purchaser Code"; rec."Purchaser Code")
                    {

                        ToolTipML = ENU = 'Specifies which purchaser is assigned to the vendor.', ESP = 'Especifica el comprador asignado al proveedor.';
                        ApplicationArea = Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("QB_PaymentTermsCode"; rec."Payment Terms Code")
                    {

                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("QB_PaymentMethodCode"; rec."Payment Method Code")
                    {

                        Editable = FALSE;
                    }
                    field("QW Cod. Withholding by GE"; rec."QW Cod. Withholding by GE")
                    {

                        Editable = false;
                    }
                    field("QB_CurrencyCode"; rec."Currency Code")
                    {

                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                    {

                        ToolTipML = ENU = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.', ESP = 'Especifica el c�digo de dimensi�n del acceso directo 1, que es uno de los dos c�digos de dimensi�n globales que se configuran en la ventana Configuraci�n de contabilidad.';
                        ApplicationArea = Dimensions;
                        Importance = Additional;
                        Editable = FALSE;
                    }
                    field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                    {

                        ToolTipML = ENU = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.', ESP = 'Especifica el c�digo de dimensi�n del acceso directo 2, que es uno de los dos c�digos de dimensi�n globales que se configuran en la ventana Configuraci�n de contabilidad.';
                        ApplicationArea = Dimensions;
                        Importance = Additional;
                        Editable = FALSE;
                    }

                }
                group("group41")
                {

                    CaptionML = ENU = 'General', ESP = 'Datos generales';
                    field("Validated"; rec."Validated")
                    {

                        CaptionML = ESP = 'Validada';
                        Editable = false;
                    }
                    field("Validated By"; rec."Validated By")
                    {

                        Editable = false;
                    }
                    field("Order Date"; rec."Order Date")
                    {

                        Editable = isEditable;
                    }
                    field("Proform Number"; rec."Proform Number")
                    {

                    }
                    field("Last Proform"; rec."Last Proform")
                    {

                        Editable = enLast;
                    }
                    field("No. Printed"; rec."No. Printed")
                    {

                        ToolTipML = ENU = 'Specifies how many times the document has been printed.', ESP = 'Especifica el n�mero de veces que se ha impreso el documento.';
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        Editable = FALSE;
                    }

                }
                group("group48")
                {

                    CaptionML = ENU = 'General', ESP = 'Datos para facturar';
                    field("(rec.Invoice No. <> '')"; (rec."Invoice No." <> ''))
                    {

                        CaptionML = ESP = 'Facturada';
                    }
                    field("Vendor Invoice No."; rec."Vendor Invoice No.")
                    {

                        Enabled = isInvoiced;
                    }
                    field("Posting Date"; rec."Posting Date")
                    {

                        ToolTipML = ENU = 'Specifies the posting date of the record.', ESP = 'Permite especificar la fecha de registro del registro.';
                        ApplicationArea = Suite;
                        Importance = Promoted;
                        Enabled = isInvoiced;
                    }
                    field("Document Date"; rec."Document Date")
                    {

                        Enabled = isInvoiced;
                    }
                    field("Invoice No."; rec."Invoice No.")
                    {

                    }

                }

            }
            part("PurchReceiptLines"; 7207004)
            {

                ApplicationArea = Suite;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207495)
            {
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Receipt', ESP = 'Al&bar�n';
                Image = Receipt;
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'Comentarios';
                    ToolTipML = ENU = 'View or add comments for the record.', ESP = 'Permite ver o agregar comentarios para el registro.';
                    ApplicationArea = Suite;
                    RunObject = Page 66;
                    RunPageLink = "Document Type" = CONST("Receipt"), "No." = FIELD("No."), "Document Line No." = CONST(0);
                    Image = ViewComments;
                }
                action("action2")
                {
                    AccessByPermission = TableData 348 = R;
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                    ApplicationArea = Dimensions;
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }
                action("action3")
                {
                    AccessByPermission = TableData 456 = R;
                    CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                    ToolTipML = ENU = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.', ESP = 'Permite ver una lista de los registros en espera de aprobaci�n. Por ejemplo, puede ver qui�n ha solicitado la aprobaci�n del registro, cu�ndo se envi� y la fecha de vencimiento de la aprobaci�n.';
                    ApplicationArea = Suite;
                    Visible = false;
                    Image = Approvals;

                    trigger OnAction()
                    VAR
                        ApprovalsMgmt: Codeunit 1535;
                    BEGIN
                        ApprovalsMgmt.ShowPostedApprovalEntries(rec.RECORDID);
                    END;


                }
                action("GetRecurringPurchaseLines")
                {

                    Ellipsis = true;
                    CaptionML = ENU = 'Get Recurring Purchase Lines', ESP = 'Obtener l�neas de compra recurrentes';
                    ToolTipML = ENU = 'Insert purchase document lines that you have set up for the vendor as recurring. Recurring purchase lines could be for a monthly replenishment order or a fixed freight expense.', ESP = 'Permite insertar las l�neas del documento de compra que se han configurado para el proveedor como recurrentes. Las l�neas de compra recurrentes pueden ser un pedido de reposici�n mensual o un gasto de flete fijo.';
                    ApplicationArea = Suite;
                    Image = VendorCode;

                    trigger OnAction()
                    VAR
                        StdVendPurchCode: Record 175;
                        PurchaseHeader: Record 38;
                        PurchaseLine: Record 39;
                    BEGIN
                        QBProform.GetRecurrentLines(Rec);
                    END;


                }

            }

        }
        area(Processing)
        {

            action("action5")
            {
                CaptionML = ENU = '&Order/Contract', ESP = 'Pedido/Contrato';
                ToolTipML = ENU = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.', ESP = 'Ver el pdido/contrato de compra asociado';
                ApplicationArea = Basic, Suite;
                Image = Document;

                trigger OnAction()
                VAR
                    PurchaseOrder: Page 50;
                BEGIN
                    COMMIT;
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.SETRANGE("No.", rec."Order No.");

                    CLEAR(PurchaseOrder);
                    PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                    PurchaseOrder.RUNMODAL;
                END;


            }
            action("action6")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = 'Imprimir';
                ToolTipML = ENU = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.', ESP = 'Preparar el documento para imprimirlo. Se abre una ventana de solicitud de informe para el documento, donde puede especificar qu� incluir en la impresi�n.';
                ApplicationArea = Basic, Suite;
                Image = Print;

                trigger OnAction()
                VAR
                    // AlbaranCompra: Report 7207405;
                BEGIN
                    CurrPage.SETSELECTIONFILTER(QBProformHeader);
                    QBProformHeader.PrintRecords(TRUE);
                END;


            }
            action("action7")
            {
                CaptionML = ENU = '&Navigate', ESP = 'Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', ESP = 'Buscar todos los movimientos y los documentos que existen para el n�mero de documento y la fecha de registro que constan en el movimiento o documento seleccionados.';
                ApplicationArea = Basic, Suite;
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }
            action("Validar")
            {

                CaptionML = ENU = 'Validate', ESP = 'Validar';
                ToolTipML = ESP = 'Validar la proforma para que se pueda facturar';
                ApplicationArea = Suite;
                Enabled = enValidate;
                Image = Check;

                trigger OnAction()
                BEGIN
                    IF (rec."Validated By" = '') THEN BEGIN
                        rec."Validated By" := USERID;
                        rec."Validate Date" := TODAY;
                    END ELSE BEGIN
                        rec."Validated By" := '';
                        rec."Validate Date" := 0D;
                    END;
                    rec.Validated := (rec."Validated By" <> '');
                    enFact := (rec."Validated By" <> '');

                    //JAV 20/07/21: - QB 1.09.10 Para que bloquee bien las l�neas al cambiar el estado a validado
                    Rec.MODIFY;
                    CurrPage.UPDATE;
                END;


            }
            action("CrearFactura")
            {

                ShortCutKey = 'F9';
                Ellipsis = true;
                CaptionML = ENU = 'P&ost', ESP = 'Crear Factura';
                ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', ESP = 'Crea una factura de compra por las cantidades de la proforma';
                ApplicationArea = Suite;
                Enabled = enFact;
                Image = NewInvoice;

                trigger OnAction()
                BEGIN
                    COMMIT; //Por el RunModal
                    QBProform.Invoice(Rec, TRUE);
                END;


            }
            action("AsociarFactura")
            {

                CaptionML = ESP = 'Asociar Factura';
                ToolTipML = ESP = 'Asocia la proforma a una factura de compra existente';
                Enabled = enFact;
                Image = CoupledInvoice;

                trigger OnAction()
                BEGIN
                    COMMIT; //Por el RunModal
                    QBProform.Invoice(Rec, FALSE);
                END;


            }
            action("VerFactura")
            {

                CaptionML = ESP = 'Ver Factura';
                Image = Invoice;

                trigger OnAction()
                BEGIN
                    COMMIT; //Por el RunModal

                    IF (PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, rec."Invoice No.")) THEN BEGIN
                        CLEAR(PurchaseInvoice);
                        PurchaseInvoice.SETRECORD(PurchaseHeader);
                        PurchaseInvoice.RUNMODAL;
                    END ELSE IF (PurchInvHeader.GET(rec."Invoice No.")) THEN BEGIN
                        CLEAR(PostedPurchaseInvoice);
                        PostedPurchaseInvoice.SETRECORD(PurchInvHeader);
                        PostedPurchaseInvoice.RUNMODAL;
                    END;
                END;


            }
            action("QuitarFactura")
            {

                CaptionML = ESP = 'Quitar Factura';
                Image = DeleteXML;

                trigger OnAction()
                BEGIN
                    //JAV 23/06/21: - QB 1.09.01 Nueva acci�n para marcar la proforma como facturada, no quitar la factura en ese caso
                    IF (rec."Invoice No." = TxtMark) THEN
                        ERROR('Marcado como facturado por administraci�n, no se puede quitar la factura');

                    QBProform.ClearInvoice(Rec);
                END;


            }
            action("action13")
            {
                CaptionML = ESP = 'Marcar como Facturada';
                Visible = seeAdmin;
                Image = MakeOrder;


                trigger OnAction()
                VAR
                    PostCertificationsLines: Record 7207342;
                BEGIN
                    //JAV 23/06/21: - QB 1.09.01 Nueva acci�n para marcar la proforma como facturada, solo para administradores de QB
                    IF (rec."Invoice No." = TxtMark) THEN BEGIN
                        rec."Invoice No." := '';
                        rec."Vendor Invoice No." := '';
                    END ELSE BEGIN
                        rec."Invoice No." := TxtMark;
                        rec."Vendor Invoice No." := 'SIN FACTURA';
                    END;
                    Rec.MODIFY;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ESP = 'Proceso';

                actionref(action5_Promoted; action5)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(GetRecurringPurchaseLines_Promoted; GetRecurringPurchaseLines)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Informe';
            }
            group(Category_Category4)
            {
                CaptionML = ESP = 'Facturar';

                actionref(Validar_Promoted; Validar)
                {
                }
                actionref(CrearFactura_Promoted; CrearFactura)
                {
                }
                actionref(AsociarFactura_Promoted; AsociarFactura)
                {
                }
                actionref(VerFactura_Promoted; VerFactura)
                {
                }
                actionref(QuitarFactura_Promoted; QuitarFactura)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN

        ActivateFields;

        seeAdmin := (FunctionQB.IsQBAdmin);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        JobDescription := '';
        IF Job.GET(Rec."Job No.") THEN
            JobDescription := Job.Description;

        ActivateFields;

        IF (rec."Invoice No." <> '') AND (rec."Invoice No." <> TxtMark) THEN
            IF (NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, rec."Invoice No.")) THEN
                IF (NOT PurchInvHeader.GET(rec."Invoice No.")) THEN BEGIN
                    rec."Invoice No." := '';
                    Rec.MODIFY;
                END;

        QBProform.RecalculateOrigin(Rec);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        DocNo := QBProform.CreateNewRecord(Rec);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //Si lo acabamos de crear tomar los datos correctamente
        IF (QBProformHeader.GET(DocNo)) THEN BEGIN
            Rec.COPY(QBProformHeader);
            CurrPage.UPDATE;
            DocNo := '';
        END;

        ActivateFields;
        rec.SetDiscountLine;
    END;



    var
        QBProformHeader: Record 7206960;
        QBProformLine: Record 7206961;
        Job: Record 167;
        PurchaseHeader: Record 38;
        PurchInvHeader: Record 122;
        PurchaseList: Page 53;
        PurchaseInvoice: Page 51;
        PostedPurchaseInvoice: Page 138;
        UserSetup: Record 91;
        QBProform: Codeunit 7207345;
        FunctionQB: Codeunit 7207272;
        JobDescription: Text;
        isEditable: Boolean;
        isInvoiced: Boolean;
        DocNo: Code[20];
        enValidate: Boolean;
        enFact: Boolean;
        enLast: Boolean;
        seeAdmin: Boolean;
        TxtMark: TextConst ESP = 'ADMINISTRACION';

    LOCAL procedure ActivateFields();
    var
        PurchasesPayablesSetup: Record 312;
    begin
        PurchasesPayablesSetup.GET;

        enValidate := FALSE;
        if UserSetup.GET(USERID) then
            enValidate := (UserSetup."QB validate Proform");
        enFact := (PurchasesPayablesSetup."QB No validate Proform") or (rec."Validated By" <> '');
        isEditable := (rec."Validated By" = '') and (rec."Invoice No." = '');
        isInvoiced := (rec."Invoice No." = '');
        enLast := isEditable and (not rec."Last Proform Generated");
    end;

    // begin
    /*{
      PGM 23/01/18: - QBV008 He cambiado el c�digo de la acci�n de imprimir para que imprima el nuevo report
      JAV 05/07/19: - Permitir cancelar albaranes parcialmente facturados
                    - Se crea un grupo con los campos relacionados con el FRI
      JDC 27/08/19: - QB9999 Added action "ResourceInvoice", nueva acci�n de facturas proforma por recurso
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector y se elimina la impresi�n de la proforma por recurso que se agrupa en la proforma normal
      JAV 10/10/20: - QB 1.06.20 Se a�aden los campos rec."Currency Code"
      QMD 09/06/21: - Q13252 Se a�ade Fact Box
      JAV 23/06/21: - QB 1.09.01 Nueva acci�n para marcar la proforma como facturada, solo para administradores de QB
      JAV 20/07/21: - QB 1.09.10 Para que bloquee bien las l�neas al cambiar el estado a validado
    }*///end
}







