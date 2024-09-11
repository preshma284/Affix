page 7207665 "Receipt Purchase Invoices List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Receipt Purchase Invoices', ESP = 'Recepcion de Facturas de compra';
    SourceTable = 38;
    SourceTableView = WHERE("Document Type" = CONST("Invoice"));
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the involved entry or record, according to the specified number series.', ESP = 'Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los art�culos.';
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; rec."Buy-from Vendor Name")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los art�culos.';
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor Invoice No."; rec."Vendor Invoice No.")
                {

                }
                field("QB Job No."; rec."QB Job No.")
                {

                }
                field("QB Receipt Date"; rec."QB Receipt Date")
                {

                    ToolTipML = ESP = 'Especifica la fecha en que se recibi� el documento';
                }
                field("Document Date"; rec."Document Date")
                {

                    ToolTipML = ESP = 'Especifica la fecha del documento';
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    ToolTipML = ENU = 'Specifies how to make payment, such as with bank transfer, cash, or check.', ESP = 'Especifica c�mo realizar el pago, por ejemplo transferencia bancaria, en efectivo o con cheque.';
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                    ToolTipML = ENU = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.', ESP = 'Especifica una f�rmula que calcula la fecha de vencimiento del pago, la fecha de descuento por pronto pago y el importe de descuento por pronto pago.';
                    ApplicationArea = Basic, Suite;
                }
                field("Due Date"; rec."Due Date")
                {

                    ToolTipML = ENU = 'Specifies when the invoice is due.', ESP = 'Especifica cu�ndo vence la factura.';
                    ApplicationArea = Basic, Suite;
                }
                field("QB Total document amount"; rec."QB Total document amount")
                {

                    ToolTipML = ESP = 'Especifica el importe total del documento indicado por el proveedor.';
                }

            }

        }
        area(FactBoxes)
        {
            part("IncomingDocAttachFactBox"; 193)
            {

                ApplicationArea = Basic, Suite;
                ShowFilter = false;
            }
            part("part2"; 9093)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No."), "Date Filter" = FIELD("Date Filter");
            }
            systempart(Links; Links)
            {

                Visible = FALSE;
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
                CaptionML = ENU = '&Invoice', ESP = '&Factura';
                Image = Invoice;
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'Co&mentarios';
                    ToolTipML = ENU = 'View or add comments for the record.', ESP = 'Permite ver o agregar comentarios para el registro.';
                    ApplicationArea = Comments;
                    RunObject = Page 66;
                    RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No."), "Document Line No." = CONST(0);
                    Image = ViewComments;
                }
                action("Dimensions")
                {

                    AccessByPermission = TableData 348 = R;
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                    ApplicationArea = Dimensions;
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group6")
            {
                CaptionML = ENU = 'Invoice', ESP = 'Factura';
                action("Vendor")
                {

                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Vendor', ESP = 'Proveedor';
                    ToolTipML = ENU = 'View or edit detailed information about the vendor on the purchase document.', ESP = 'Permite ver o editar la informaci�n detallada sobre el proveedor en el documento de compra.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 26;
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    Image = Vendor;
                    Scope = Repeater;
                }
                action("Edit")
                {

                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Vendor', ESP = 'Editar';
                    ToolTipML = ENU = 'Edit the purchase document.', ESP = 'Permite editar el documento de compra.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 51;
                    RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                    Image = PurchaseInvoice;
                    Scope = Repeater
    ;
                }

            }

        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                actionref(Vendor_Promoted; Vendor)
                {
                }
                actionref(Edit_Promoted; Edit)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(Dimensions_Promoted; Dimensions)
                {
                }
            }
        }
    }



    trigger OnOpenPage()
    VAR
        PurchasesPayablesSetup: Record 312;
    BEGIN
        rec.SetSecurityFilterOnRespCenter;

        JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

        rec.CopyBuyFromVendorFilter;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."QB Job No." := '';

        rec."QB Receipt Date" := TODAY;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    END;



    var
        OpenPostedPurchaseInvQst: TextConst ENU = 'The invoice is posted as number %1 and moved to the Posted Purchase Invoice window.\\Do you want to open the posted invoice?', ESP = 'La factura se registr� con el n�mero %1 y se movi� a la ventana de facturas de compra registradas.\\�Quiere abrir la factura registrada?';
        TotalsMismatchErr: TextConst ENU = 'The invoice cannot be posted because the total is different from the total on the related incoming document.', ESP = 'La factura no se puede registrar porque el importe total es diferente del total del documento entrante relacionado.';
        ReportPrint: Codeunit 228;
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        PowerBIVisible: Boolean;
        ReadyToPostQst: TextConst ENU = '%1 out of %2 selected invoices are ready for post. \Do you want to continue and post them?', ESP = '%1 de las %2 facturas seleccionadas est�n listas para el registro. \�Desea continuar y registrarlas?';
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        Funcionesdecontratos: Codeunit 7206907;
        QuoBuildingSetup: Record 7207278;
        verSII: Boolean;
        FunctionQB: Codeunit 7207272;
        Job: Record 167;

    LOCAL procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit 1535;
        WorkflowWebhookManagement: Codeunit 1543;
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RECORDID);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(rec.RECORDID);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    //[External]
    procedure Post(PostingCodeunitID: Integer);
    var
        ApplicationAreaMgmtFacade: Codeunit 9179;
        LinesInstructionMgt: Codeunit 1320;
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

        rec.SendToPosting(PostingCodeunitID);

        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            ShowPostedConfirmationMessage;
    end;

    LOCAL procedure ShowPostedConfirmationMessage();
    var
        PurchInvHeader: Record 122;
        InstructionMgt: Codeunit 1330;
    begin
        PurchInvHeader.SETRANGE("Pre-Assigned No.", rec."No.");
        PurchInvHeader.SETRANGE("Order No.", '');
        if PurchInvHeader.FINDFIRST then
            if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedPurchaseInvQst, PurchInvHeader."No."),
                 InstructionMgt.ShowPostedConfirmationMessageCode)
            then
                PAGE.RUN(PAGE::"Posted Purchase Invoice", PurchInvHeader);
    end;

    //[External]
    procedure VerifyTotal(PurchaseHeader: Record 38);
    begin
        if not PurchaseHeader.IsTotalValid then
            ERROR(TotalsMismatchErr);
    end;

    // begin
    /*{
      JAV 08/01/20: - Lista de documentos recibidos
    }*///end
}








