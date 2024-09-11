page 7207002 "QB Proform List"
{
    ApplicationArea = All;

    Editable = false;
    CaptionML = ENU = 'QB Proform List', ESP = 'QB Lista proformas';
    //ApplicationArea = Basic, Suite;
    SourceTable = 7206960;
    SourceTableView = SORTING("Posting Date")
                    ORDER(Descending);
    PageType = List;
    UsageCategory = History;
    CardPageID = "QB Proform Card";

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the involved entry or record, according to the specified number series.', ESP = 'Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                    ApplicationArea = Suite;
                }
                field("Order Date"; rec."Order Date")
                {

                }
                field("Order No."; rec."Order No.")
                {

                }
                field("Proform Number"; rec."Proform Number")
                {

                }
                field("Validated"; rec."Validated")
                {

                    Editable = false;
                }
                field("Invoiced"; Invoiced)
                {

                    CaptionML = ESP = 'Facturada';
                }
                field("Invoice No."; rec."Invoice No.")
                {

                }
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los art�culos.';
                    ApplicationArea = Basic, Suite;
                }
                field("Order Address Code"; rec."Order Address Code")
                {

                    ToolTipML = ENU = 'Specifies the order address of the related vendor.', ESP = 'Especifica la direcci�n de pedido del proveedor relacionado.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Buy-from Vendor Name"; rec."Buy-from Vendor Name")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who delivered the items.', ESP = 'Especifica el nombre del proveedor que envi� los productos.';
                    ApplicationArea = Suite;
                }
                field("Buy-from Post Code"; rec."Buy-from Post Code")
                {

                    ToolTipML = ENU = 'Specifies the post code of the vendor who delivered the items.', ESP = 'Especifica el c�digo postal del proveedor que entreg� los art�culos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Buy-from Country/Region Code"; rec."Buy-from Country/Region Code")
                {

                    ToolTipML = ENU = 'Specifies the city of the vendor who delivered the items.', ESP = 'Especifica la ciudad del proveedor que entreg� los art�culos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Buy-from Contact"; rec."Buy-from Contact")
                {

                    ToolTipML = ENU = 'Specifies the name of the contact person at the vendor who delivered the items.', ESP = 'Especifica el nombre de la persona de contacto del proveedor que entreg� los art�culos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the vendor that you received the invoice from.', ESP = 'Especifica el n�mero del proveedor que le envi� la factura.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Pay-to Name"; rec."Pay-to Name")
                {

                    ToolTipML = ENU = 'Specifies the name of the vendor who you received the invoice from.', ESP = 'Especifica el nombre del proveedor que le envi� la factura.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Pay-to Post Code"; rec."Pay-to Post Code")
                {

                    ToolTipML = ENU = 'Specifies the post code of the vendor that you received the invoice from.', ESP = 'Especifica el c�digo postal del proveedor que le envi� la factura.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Pay-to Country/Region Code"; rec."Pay-to Country/Region Code")
                {

                    ToolTipML = ENU = 'Specifies the country/region code of the address.', ESP = 'Especifica el c�digo de pa�s o regi�n de la direcci�n.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Pay-to Contact"; rec."Pay-to Contact")
                {

                    ToolTipML = ENU = 'Specifies the name of the person to contact about an invoice from this vendor.', ESP = 'Especifica el nombre de la persona con la que debe contactar para tratar acerca de cualquier factura procedente de este proveedor.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Ship-to Code"; rec."Ship-to Code")
                {

                    ToolTipML = ENU = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.', ESP = 'Especifica el c�digo de una direcci�n de env�o alternativa si desea realizar el env�o a otra direcci�n diferente a la que se ha introducido autom�ticamente. Este campo tambi�n se utiliza en el caso de env�o directo.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {

                    ToolTipML = ENU = 'Specifies the name of the customer at the address that the items are shipped to.', ESP = 'Especifica el nombre del cliente de la direcci�n a la que se env�an los productos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {

                    ToolTipML = ENU = 'Specifies the postal code of the address that the items are shipped to.', ESP = 'Especifica el c�digo postal de la direcci�n a la que se env�an los productos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Ship-to Country/Region Code"; rec."Ship-to Country/Region Code")
                {

                    ToolTipML = ENU = 'Specifies the country/region code of the address that the items are shipped to.', ESP = 'Especifica el c�digo del pa�s o la regi�n de la direcci�n a la que se env�an los productos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {

                    ToolTipML = ENU = 'Specifies the name of the contact person at the address that the items are shipped to.', ESP = 'Especifica el nombre de la persona de contacto de la direcci�n a la que se env�an los productos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                    ToolTipML = ENU = 'Specifies the date the purchase header was posted.', ESP = 'Especifica la fecha en que se registr� la cabecera de compra.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Purchaser Code"; rec."Purchaser Code")
                {

                    ToolTipML = ENU = 'Specifies which purchaser is assigned to the vendor.', ESP = 'Especifica el comprador asignado al proveedor.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("TPeriod"; TPeriod)
                {

                    CaptionML = ESP = 'Importe Periodo (Base)';
                }
                field("TOrigin"; TOrigin)
                {

                    CaptionML = ESP = 'Importe Origen (Base)';
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    ToolTipML = ENU = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.', ESP = 'Especifica el c�digo de dimensi�n del acceso directo 1, que es uno de los dos c�digos de dimensi�n globales que se configuran en la ventana Configuraci�n de contabilidad.';
                    ApplicationArea = Dimensions;
                    Visible = FALSE;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    ToolTipML = ENU = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.', ESP = 'Especifica el c�digo de dimensi�n del acceso directo 2, que es uno de los dos c�digos de dimensi�n globales que se configuran en la ventana Configuraci�n de contabilidad.';
                    ApplicationArea = Dimensions;
                    Visible = FALSE;
                }
                field("Location Code"; rec."Location Code")
                {

                    ToolTipML = ENU = 'Specifies the code for the location where the items on the receipt were registered.', ESP = 'Especifica el c�digo de la ubicaci�n donde se registraron los art�culos del recibo.';
                    ApplicationArea = Location;
                    Visible = TRUE;
                }
                field("No. Printed"; rec."No. Printed")
                {

                    ToolTipML = ENU = 'Specifies how many times the document has been printed.', ESP = 'Especifica el n�mero de veces que se ha impreso el documento.';
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; rec."Document Date")
                {

                    ToolTipML = ENU = 'Specifies the date when the related document was created.', ESP = 'Especifica la fecha en la que se cre� el documento correspondiente.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {

                    ToolTipML = ENU = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).', ESP = 'Especifica las condiciones de entrega del env�o en cuesti�n, como franco a bordo (FOB).';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("QB_JobNo"; rec."Job No.")
                {

                    CaptionML = ENU = 'Job', ESP = 'Proyecto';
                    ToolTipML =;
                    Visible = TRUE;
                }
                field("QB_JobDescription"; JobDescription)
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n Proyecto';
                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207495)
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
                CaptionML = ENU = '&Receipt', ESP = 'Al&baranes';
                Image = Receipt;
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    ToolTipML = ENU = 'View statistical information, such as the value of posted entries, for the record.', ESP = 'Permite ver informaci�n estad�stica del registro, como el valor de los movimientos registrados.';
                    ApplicationArea = Suite;
                    RunObject = Page 399;
                    RunPageLink = "No." = FIELD("No.");
                    Promoted = true;
                    Image = Statistics;
                    PromotedCategory = Process;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    ToolTipML = ENU = 'View or add comments for the record.', ESP = 'Permite ver o agregar comentarios para el registro.';
                    ApplicationArea = Comments;
                    RunObject = Page 66;
                    RunPageLink = "Document Type" = CONST("Receipt"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
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

            }

        }
        area(Processing)
        {

            action("action4")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = '&Imprimir';
                ToolTipML = ENU = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.', ESP = 'Preparar el documento para imprimirlo. Se abre una ventana de solicitud de informe para el documento, donde puede especificar qu� incluir en la impresi�n.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Visible = NOT IsOfficeAddin;
                Image = Print;
                PromotedCategory = Process;

                trigger OnAction()
                VAR
                    QBProformHeader: Record 7206960;
                BEGIN
                    CurrPage.SETSELECTIONFILTER(QBProformHeader);
                    QBProformHeader.PrintRecords(TRUE);
                END;


            }
            action("action5")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', ESP = 'Buscar todos los movimientos y los documentos que existen para el n�mero de documento y la fecha de registro que constan en el movimiento o documento seleccionados.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                Visible = NOT IsOfficeAddin;
                Image = Navigate;
                PromotedCategory = Process;


                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }

        }
    }

    trigger OnOpenPage()
    VAR
        OfficeMgt: Codeunit 1630;
        HasFilters: Boolean;
    BEGIN
        HasFilters := Rec.GETFILTERS <> '';
        IF HasFilters THEN
            IF Rec.FINDFIRST THEN;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        JobDescription := '';
        IF Job.GET(Rec."Job No.") THEN
            JobDescription := Job.Description;
        Invoiced := (rec."Invoice No." <> '');
        rec.CalculateTotal(TPeriod, TOrigin);

        rec.Validated := rec."Validated By" <> '';
        Rec.MODIFY;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        Invoiced := (rec."Invoice No." <> '');
    END;



    var
        IsOfficeAddin: Boolean;
        "-------------------------- QB": Integer;
        Job: Record 167;
        JobDescription: Text;
        Invoiced: Boolean;
        UserSetup: Record 91;
        isEditable: Boolean;
        isInvoiced: Boolean;
        enValidate: Boolean;
        enFact: Boolean;
        TPeriod: Decimal;
        TOrigin: Decimal;

    LOCAL procedure ActivateFields();
    var
        PurchasesPayablesSetup: Record 312;
    begin
        PurchasesPayablesSetup.GET;

        enValidate := FALSE;
        if UserSetup.GET(USERID) then
            enValidate := (UserSetup."QB Validate Proform");
        enFact := (PurchasesPayablesSetup."QB No Validate Proform") or (rec."Validated By" <> '');
        isEditable := (rec."Validated By" = '') and (rec."Invoice No." = '');
        isInvoiced := (rec."Invoice No." = '');
    end;

    // begin
    /*{
      PGM 23/01/18: - QBV008 He cambiado el c�digo de la acci�n de imprimir para que imprima el nuevo report
      JAV 06/07/19: - Se a�aden los campos "Receive in FRI" y Canceled, sefiltran los cancelados por defecto
      JAV 03/10/19: - Se a�ade la acci�n de imprimir las facturas proforma
      Q13252 QMD 09/06/21 - Se a�ade Fact Box
    }*///end
}








