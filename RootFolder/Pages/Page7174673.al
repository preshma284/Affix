page 7174673 "Vendor List Example DragDrop"
{
    Editable = false;
    CaptionML = ENU = 'Vendor List', ESP = 'Lista de proveedores';
    SourceTable = 23;
    PageType = List;
    CardPageID = "Vendor Card";

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.', ESP = 'Especifica el n�mero del proveedor. El campo se rellena autom�ticamente a partir de una serie num�rica definida o de forma manual porque se habilit� la entrada manual de n�meros en la configuraci�n de series num�ricas.';
                    ApplicationArea = All;
                }
                field("Name"; rec."Name")
                {

                    ToolTipML = ENU = 'Specifies the vendors name. You can enter a maximum of 30 characters, both numbers and letters.', ESP = 'Especifica el nombre del proveedor. Se pueden escribir un m�ximo de 30 caracteres, tanto n�meros como letras.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {

                    ToolTipML = ENU = 'Specifies the code for the responsibility center that will administer this vendor by default.', ESP = 'Especifica el c�digo del centro de responsabilidad que administrar� este proveedor de forma predeterminada.';
                }
                field("Location Code"; rec."Location Code")
                {

                    ToolTipML = ENU = 'Specifies the warehouse location where items from the vendor must be received by default.', ESP = 'Especifica el almac�n en que se deben recibir los productos del proveedor de forma predeterminada.';
                }
                field("Post Code"; rec."Post Code")
                {

                    ToolTipML = ENU = 'Specifies the postal code.', ESP = 'Especifica el c�digo postal.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {

                    ToolTipML = ENU = 'Specifies the country/region of the address.', ESP = 'Especifica el pa�s o la regi�n de la direcci�n.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Phone No."; rec."Phone No.")
                {

                    ToolTipML = ENU = 'Specifies the vendors telephone number.', ESP = 'Especifica el n�mero de tel�fono del proveedor.';
                    ApplicationArea = Basic, Suite;
                }
                field("Fax No."; rec."Fax No.")
                {

                    ToolTipML = ENU = 'Specifies the vendors fax number.', ESP = 'Especifica el n�mero de fax del proveedor.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("IC Partner Code"; rec."IC Partner Code")
                {

                    ToolTipML = ENU = 'Specifies the vendors IC partner code, if the vendor is one of your intercompany partners.', ESP = 'Especifica el c�digo de socio de empresas vinculadas del proveedor, si el proveedor es uno de sus socios de empresas vinculadas.';
                    Visible = FALSE;
                }
                field("Contact"; rec."Contact")
                {

                    ToolTipML = ENU = 'Specifies the name of the person you regularly contact when you do business with this vendor.', ESP = 'Especifica el nombre de la persona con la que contacta normalmente cuando trata con este proveedor.';
                    ApplicationArea = Basic, Suite;
                }
                field("Purchaser Code"; rec."Purchaser Code")
                {

                    ToolTipML = ENU = 'Specifies a code to specify the purchaser who normally handles this vendors account.', ESP = 'Especifica el c�digo para especificar el comprador que normalmente maneja la cuenta de este proveedor.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Vendor Posting Group"; rec."Vendor Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the vendors market type to link business transactions made for the vendor with the appropriate account in the general ledger.', ESP = 'Especifica el tipo de mercado del proveedor para vincular las transacciones empresariales realizadas para el proveedor con la cuenta correspondiente en la contabilidad general.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the vendors trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.', ESP = 'Especifica el tipo de comercio del proveedor para vincular las transacciones realizadas para este proveedor con la cuenta de contabilidad general correspondiente seg�n la configuraci�n de registro general.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the vendors VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.', ESP = 'Indica la especificaci�n de IVA del proveedor para vincular las transacciones realizadas para este proveedor con la cuenta de contabilidad general correspondiente seg�n la configuraci�n de registro de IVA.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                    ToolTipML = ENU = 'Specifies a code that indicates the payment terms that the vendor usually requires.', ESP = 'Especifica un c�digo que indica los t�rminos de pago que suele requerir el proveedor.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Fin. Charge Terms Code"; rec."Fin. Charge Terms Code")
                {

                    ToolTipML = ENU = 'Specifies how the vendor calculates finance charges.', ESP = 'Especifica la manera en que el proveedor calcula los intereses.';
                    Visible = FALSE;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    ToolTipML = ENU = 'Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.', ESP = 'Especifica el c�digo de divisa que se inserta de forma predeterminada al crear documentos de compras o l�neas del diario para el proveedor.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Language Code"; rec."Language Code")
                {

                    ToolTipML = ENU = 'Specifies the language on printouts for this vendor.', ESP = 'Especifica el idioma en las copias impresas para este proveedor.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Search Name"; rec."Search Name")
                {

                    ToolTipML = ENU = 'Specifies a search name.', ESP = 'Especifica un nombre de b�squeda.';
                    ApplicationArea = Basic, Suite;
                }
                field("Blocked"; rec."Blocked")
                {

                    ToolTipML = ENU = 'Specifies which transactions with the vendor that cannot be posted.', ESP = 'Especifica qu� transacciones con el proveedor no pueden registrarse.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {

                    ToolTipML = ENU = 'Specifies when the vendor card was last modified.', ESP = 'Especifica cu�ndo se modific� la ficha de proveedor por �ltima vez.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Application Method"; rec."Application Method")
                {

                    ToolTipML = ENU = 'Specifies how to apply payments to entries for this vendor.', ESP = 'Especifica c�mo liquidar pagos en los movimientos para este proveedor.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Location Code2"; rec."Location Code")
                {

                    ToolTipML = ENU = 'Specifies the warehouse location where items from the vendor must be received by default.', ESP = 'Especifica el almac�n en que se deben recibir los productos del proveedor de forma predeterminada.';
                    Visible = FALSE;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {

                    ToolTipML = ENU = 'Specifies how the vendor must ship items to you.', ESP = 'Especifica c�mo debe enviarle el proveedor los productos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Lead Time Calculation"; rec."Lead Time Calculation")
                {

                    ToolTipML = ENU = 'Specifies a date formula for the amount of time that it takes to replenish the item.', ESP = 'Especifica una f�rmula de fecha con la cantidad de tiempo que se tarda en reponer el producto.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Base Calendar Code"; rec."Base Calendar Code")
                {

                    ToolTipML = ENU = 'Specifies the code for the vendors customizable calendar.', ESP = 'Especifica el c�digo del calendario personalizable del proveedor.';
                    Visible = FALSE;
                }
                field("Balance (LCY)"; rec."Balance (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.', ESP = 'Especifica el valor total de sus compras completadas al proveedor en el ejercicio actual. Se calcula a partir de importes sin IVA sobre facturas y abonos de compra completados.';
                    ApplicationArea = Basic, Suite;

                    ; trigger OnDrillDown()
                    BEGIN
                        rec.OpenVendorLedgerEntries(FALSE);
                    END;


                }
                field("Balance Due (LCY)"; rec."Balance Due (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all open purchase invoices and credit memos.', ESP = 'Especifica el valor total de sus compras sin pagar al proveedor en el ejercicio actual. Se calcula a partir de importes sin IVA sobre facturas y abonos de compra abiertos.';
                    ApplicationArea = Basic, Suite;

                    ; trigger OnDrillDown()
                    BEGIN
                        rec.OpenVendorLedgerEntries(TRUE);
                    END;


                }

            }

        }
        area(FactBoxes)
        {
            part("DropArea"; 7174655)
            {
                ;
            }
            part("FilesSP"; 7174656)
            {
                ;
            }
            //obsolte page
            part("part3"; 51568)
            {

                ApplicationArea = All;

                // SubPageLink = "Source Type" = CONST("Vendor"), "Source No." = FIELD("No.");
                Visible = SocialListeningVisible;
            }
            //obsolte page
            part("part4"; 51569)
            {

                ApplicationArea = All;
                // SubPageLink = "Source Type" = CONST("Vendor"), "Source No." = FIELD("No.");
                Visible = SocialListeningSetupVisible;
                UpdatePropagation = Both;
            }
            part("VendorDetailsFactBox"; 9093)
            {
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = FALSE;
            }
            part("VendorStatisticsFactBox"; 9094)
            {
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part("VendorHistBuyFromFactBox"; 9095)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part("VendorHistPayToFactBox"; 9096)
            {

                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = FALSE;
            }
            part("part9"; 35305)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
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
                CaptionML = ENU = 'Ven&dor', ESP = '&Proveedor';
                Image = Vendor;
                group("group3")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action1")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-Individual';
                        ToolTipML = ENU = 'View or edit the single set of dimensions that are set up for the selected record.', ESP = 'Permite ver o editar el grupo �nico de dimensiones configuradas para el registro seleccionado.';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(23), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action2")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&M�ltiple';
                        ToolTipML = ENU = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.', ESP = 'Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar c�digos de dimensi�n a transacciones para distribuir los costes y analizar la informaci�n hist�rica.';
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            Vend: Record 23;
                            DefaultDimMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Vend);
                            DefaultDimMultiple.SetMultiVendor(Vend);
                            DefaultDimMultiple.RUNMODAL;
                        END;


                    }

                }
                action("action3")
                {
                    CaptionML = ENU = 'Bank Accounts', ESP = 'Bancos';
                    RunObject = Page 426;
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = BankAccount;
                }
                action("action4")
                {
                    AccessByPermission = TableData 5050 = R;
                    CaptionML = ENU = 'C&ontact', ESP = '&Contacto';
                    Image = ContactPerson;

                    trigger OnAction()
                    BEGIN
                        rec.ShowContact;
                    END;


                }
                separator("separator5")
                {

                }
                action("OrderAddresses")
                {

                    CaptionML = ENU = 'Order &Addresses', ESP = 'D&irecciones pedido';
                    RunObject = Page 369;
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = Addresses;
                }
                action("action7")
                {
                    CaptionML = ENU = 'Payment A&ddresses', ESP = '&Direcci�n de pago';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 7000043;
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = Addresses;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Vendor"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action9")
                {
                    CaptionML = ENU = 'P&ayment Days', ESP = 'D�a&s pago';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 10700;
                    RunPageLink = "Table Name" = CONST("Vendor"), "Code" = FIELD("Payment Days Code");
                    Image = PaymentDays;
                }
                action("action10")
                {
                    CaptionML = ENU = 'Non-Pa&yment Periods', ESP = 'Periodos &no-pago';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 10701;
                    RunPageLink = "Table Name" = CONST("Vendor"), "Code" = FIELD("Non-Paymt. Periods Code");
                    Image = PaymentPeriod;
                }
                action("action11")
                {
                    CaptionML = ENU = 'Cross Re&ferences', ESP = 'Referencias cru&zadas';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 52451;
                    RunPageView = SORTING("Reference Type", "Reference Type No.");
                    RunPageLink = "Reference Type" = CONST("Vendor"), "Reference Type No." = FIELD("No.");
                    Image = Change;
                }
                action("ApprovalEntries")
                {

                    AccessByPermission = TableData 454 = R;
                    CaptionML = ENU = 'Approvals', ESP = 'Aprobaciones';
                    ToolTipML = ENU = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.', ESP = 'Permite ver una lista de los registros en espera de aprobaci�n. Por ejemplo, puede ver qui�n ha solicitado la aprobaci�n del registro, cu�ndo se envi� y la fecha de vencimiento de la aprobaci�n.';
                    ApplicationArea = Suite;
                    Image = Approvals;

                    trigger OnAction()
                    BEGIN
                        ApprovalsMgmt.OpenApprovalEntriesPage(rec.RECORDID);
                    END;


                }

            }
            group("group16")
            {
                CaptionML = ENU = '&Purchases', ESP = '&Compras';
                Image = Purchasing;
                action("action13")
                {
                    CaptionML = ENU = 'Items', ESP = 'Productos';
                    RunObject = Page 297;
                    RunPageView = SORTING("Vendor No.");
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = Item;
                }
                action("action14")
                {
                    CaptionML = ENU = 'Invoice &Discounts', ESP = 'Dto. &factura';
                    ToolTipML = ENU = 'View or set up conditions for invoice discounts and service charges for the vendor.', ESP = 'Permite ver o configurar las condiciones para descuentos en factura y cargos por servicios del proveedor.';
                    RunObject = Page 28;
                    RunPageLink = "Code" = FIELD("Invoice Disc. Code");
                    Image = CalculateInvoiceDiscount;
                }
                action("action15")
                {
                    CaptionML = ENU = 'Prices', ESP = 'Precios';
                    ToolTipML = ENU = 'View or set up different prices for items that you buy from the vendor. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.', ESP = 'Permite ver o configurar distintos precios para los art�culos que se compran al proveedor. Se concede un precio de art�culo autom�ticamente en las l�neas de factura cuando se cumplen los criterios especificados, como el proveedor, la cantidad o la fecha final.';
                    RunObject = Page 7012;
                    RunPageView = SORTING("Vendor No.");
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = Price;
                }
                action("action16")
                {
                    CaptionML = ENU = 'Line Discounts', ESP = 'Descuentos l�nea';
                    ToolTipML = ENU = 'View or set up purchase line discounts.', ESP = 'Permite ver o configurar descuentos de l�nea de compra.';
                    RunObject = Page 7014;
                    RunPageView = SORTING("Vendor No.");
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = LineDiscount;
                }
                action("action17")
                {
                    CaptionML = ENU = 'Prepa&yment Percentages', ESP = 'Porcentajes &prepago';
                    RunObject = Page 665;
                    RunPageView = SORTING("Vendor No.");
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = PrepaymentPercentages;
                }
                action("action18")
                {
                    CaptionML = ENU = 'S&td. Vend. Purchase Codes', ESP = '&C�d. est�nd. comp. prov.';
                    RunObject = Page 178;
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = CodesList;
                }
                action("action19")
                {
                    CaptionML = ENU = 'Mapping Text to Account', ESP = 'Asignaci�n de texto a cuenta';
                    ToolTipML = ENU = 'Page mapping text to account', ESP = 'P�gina de asignaci�n de texto a cuenta';
                    RunObject = Page 1254;
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = MapAccounts;
                }

            }
            group("group24")
            {
                CaptionML = ENU = 'Documents', ESP = 'Documentos';
                Image = Administration;
                action("action20")
                {
                    CaptionML = ENU = 'Quotes', ESP = 'Ofertas';
                    RunObject = Page 9306;
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.");
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    Image = Quote;
                }
                action("action21")
                {
                    CaptionML = ENU = 'Orders', ESP = 'Pedidos';
                    RunObject = Page 9307;
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.");
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    Image = Document;
                }
                action("action22")
                {
                    CaptionML = ENU = 'Return Orders', ESP = 'Devoluciones';
                    RunObject = Page 9311;
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.");
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    Image = ReturnOrder;
                }
                action("action23")
                {
                    CaptionML = ENU = 'Blanket Orders', ESP = 'Pedidos abiertos';
                    RunObject = Page 9310;
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.");
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    Image = BlanketOrder;
                }

            }
            group("group29")
            {
                CaptionML = ENU = 'History', ESP = 'Historial';
                Image = History;
                action("action24")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                    RunObject = Page 29;
                    RunPageView = SORTING("Vendor No.")
                                  ORDER(Descending);
                    RunPageLink = "Vendor No." = FIELD("No.");
                    Image = VendorLedger;
                }
                action("action25")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 152;
                    RunPageLink = "No." = FIELD("No."), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = Statistics;
                }
                action("action26")
                {
                    CaptionML = ENU = 'Purchases', ESP = 'Compras';
                    RunObject = Page 156;
                    RunPageLink = "No." = FIELD("No."), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = Purchase;
                }
                action("action27")
                {
                    CaptionML = ENU = 'Entry Statistics', ESP = 'Estad�sticas documentos';
                    RunObject = Page 303;
                    RunPageLink = "No." = FIELD("No."), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = EntryStatistics;
                }
                action("action28")
                {
                    CaptionML = ENU = 'Statistics by C&urrencies', ESP = 'Estad�sticas por di&visas';
                    RunObject = Page 487;
                    RunPageLink = "Vendor Filter" = FIELD("No."), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"), "Date Filter" = FIELD("Date Filter");
                    Image = Currencies;
                }
                action("action29")
                {
                    CaptionML = ENU = 'Item &Tracking Entries', ESP = 'Movs. &seguim. prod.';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    VAR
                        ItemTrackingDocMgt: Codeunit 6503;
                    BEGIN
                        // ItemTrackingDocMgt.ShowItemTrackingForMasterData(2, rec."No.", '', '', '', '', '');
                    END;


                }

            }

        }
        area(Creation)
        {

            action("NewBlanketPurchaseOrder")
            {

                CaptionML = ENU = 'Blanket Purchase Order', ESP = 'Pedido abierto compra';
                RunObject = Page 509;
                RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                Image = BlanketOrder;
                RunPageMode = Create;
            }
            action("NewPurchaseQuote")
            {

                CaptionML = ENU = 'Purchase Quote', ESP = 'Oferta compra';
                RunObject = Page 49;
                RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                Image = Quote;
                RunPageMode = Create;
            }
            action("NewPurchaseInvoice")
            {

                CaptionML = ENU = 'Purchase Invoice', ESP = 'Factura compra';
                ToolTipML = ENU = 'Create a new purchase invoice for items or services.', ESP = 'Permite crear una nueva factura de compra de productos o servicios.';
                ApplicationArea = Basic, Suite;
                RunObject = Page 51;
                RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                Image = NewPurchaseInvoice;
                RunPageMode = Create;
            }
            action("NewPurchaseOrder")
            {

                CaptionML = ENU = 'Purchase Order', ESP = 'Pedido compra';
                ToolTipML = ENU = 'Create a new purchase order.', ESP = 'Crea un nuevo pedido de compra.';
                ApplicationArea = Suite;
                RunObject = Page 50;
                RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                Image = Document;
                RunPageMode = Create;
            }
            action("NewPurchaseCrMemo")
            {

                CaptionML = ENU = 'Purchase Credit Memo', ESP = 'Abono compra';
                ToolTipML = ENU = 'Create a new purchase credit memo to revert a posted purchase invoice.', ESP = 'Permite crear un nuevo abono de compra para revertir una factura de compra registrada.';
                ApplicationArea = Basic, Suite;
                RunObject = Page 52;
                RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                Image = CreditMemo;
                RunPageMode = Create;
            }
            action("NewPurchaseReturnOrder")
            {

                CaptionML = ENU = 'Purchase Return Order', ESP = 'Devoluci�n compra';
                RunObject = Page 6640;
                RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                Image = ReturnOrder;
                RunPageMode = Create;
            }

        }
        area(Processing)
        {

            group("group44")
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Aprobaci�n solic.';
                Image = SendApprovalRequest;
                action("SendApprovalRequest")
                {

                    CaptionML = ENU = 'Send A&pproval Request', ESP = 'Enviar solicitud a&probaci�n';
                    ToolTipML = ENU = 'Send an approval request.', ESP = 'Env�a una solicitud de aprobaci�n.';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    VAR
                        ApprovalsMgmt: Codeunit 1535;
                    BEGIN
                        IF ApprovalsMgmt.CheckVendorApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnSendVendorForApproval(Rec);
                    END;


                }
                action("CancelApprovalRequest")
                {

                    CaptionML = ENU = 'Cancel Approval Re&quest', ESP = '&Cancelar solicitud aprobaci�n';
                    ToolTipML = ENU = 'Cancel the approval request.', ESP = 'Cancela la solicitud de aprobaci�n.';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    VAR
                        ApprovalsMgmt: Codeunit 1535;
                    BEGIN
                        ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);
                    END;


                }

            }
            action("action38")
            {
                CaptionML = ENU = 'Payment Journal', ESP = 'Diario de pagos';
                RunObject = Page 256;
                Image = PaymentJournal;
            }
            action("action39")
            {
                CaptionML = ENU = 'Purchase Journal', ESP = 'Diario compras';
                RunObject = Page 254;
                Image = Journals;
            }

        }
        area(Reporting)
        {

            group("group50")
            {
                CaptionML = ENU = 'General', ESP = 'General';
                Image = Report;
                action("action40")
                {
                    CaptionML = ENU = 'Vendor - List', ESP = 'Proveedor - Listado';
                    RunObject = Report 301;
                    Image = Report;
                }
                action("action41")
                {
                    CaptionML = ENU = 'Vendor Register', ESP = 'Registro movs. proveedor';
                    RunObject = Report 303;
                    Image = Report;
                }
                action("action42")
                {
                    CaptionML = ENU = 'Vendor Item Catalog', ESP = 'Lista productos proveedores';
                    ToolTipML = ENU = 'View a list of the items that your vendors supply.', ESP = 'Permite ver una lista de los productos que suministran los proveedores.';
                    ApplicationArea = Suite;
                    RunObject = Report 320;
                    Image = Report;
                }
                action("action43")
                {
                    CaptionML = ENU = 'Vendor - Labels', ESP = 'Proveedor - Etiquetas';
                    RunObject = Report 310;
                    Image = Report;
                }
                action("action44")
                {
                    CaptionML = ENU = 'Vendor - Top 10 List', ESP = 'Proveedor - Listado 10 mejores';
                    ToolTipML = ENU = 'View a list of the top vendors by balances or purchases.', ESP = 'Permite ver una lista de los principales proveedores por saldos o compras.';
                    ApplicationArea = Suite;
                    RunObject = Report 311;
                    Image = Report;
                }

            }
            group("group56")
            {
                CaptionML = ENU = 'Orders', ESP = 'Pedidos';
                Image = Report;
                action("action45")
                {
                    CaptionML = ENU = 'Vendor - Order Summary', ESP = 'Proveedor - Total pedidos';
                    RunObject = Report 307;
                    Image = Report;
                }
                action("action46")
                {
                    CaptionML = ENU = 'Vendor - Order Detail', ESP = 'Proveedor - L�neas pedidos';
                    RunObject = Report 308;
                    Image = Report;
                }

            }
            group("group59")
            {
                CaptionML = ENU = 'Purchase', ESP = 'Compra';
                Image = Purchase;
                action("action47")
                {
                    CaptionML = ENU = 'Vendor - Purchase List', ESP = 'Lista compras - Proveedor';
                    ToolTipML = ENU = 'View a list of vendor purchases for a selected period.', ESP = 'Permite ver una lista de compras de proveedores en un per�odo seleccionado.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Report 309;
                    Image = Report;
                }
                action("action48")
                {
                    CaptionML = ENU = 'Vendor/Item Purchases', ESP = 'Compras prov./producto';
                    ToolTipML = ENU = 'View a list of item entries for each vendor in a selected period.', ESP = 'Permite ver una lista de movimientos de producto de cada proveedor durante un per�odo determinado.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Report 313;
                    Image = Report;
                }
                action("action49")
                {
                    CaptionML = ENU = 'Purchase Statistics', ESP = 'Estad�sticas compras';
                    ToolTipML = ENU = 'View a list of amounts for purchases, invoice discount and payment discount in $ for each vendor.', ESP = 'Permite ver una lista de importes de compras, descuentos en factura y descuentos por pronto pago en USD de cada proveedor.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Report 312;
                    Image = Report;
                }

            }
            group("group63")
            {
                CaptionML = ENU = 'Financial Management', ESP = 'Gesti�n financiera';
                Image = Report;
                action("action50")
                {
                    CaptionML = ENU = 'Payments on Hold', ESP = 'Pagos retenidos';
                    ToolTipML = ENU = 'View a list of all vendor ledger entries on which the On Hold field is marked.', ESP = 'Permite ver una lista de todos los movimientos de proveedor cuyo campo Esperar aparece marcado.';
                    ApplicationArea = Suite;
                    RunObject = Report 319;
                    Image = Report;
                }
                action("action51")
                {
                    CaptionML = ENU = 'Vendor - Summary Aging', ESP = 'Proveedor - Pagos por periodos';
                    ToolTipML = ENU = 'View, print, or save a summary of the payables owed to each vendor, divided into three time periods.', ESP = 'Permite ver, imprimir o guardar un resumen de los documentos a pagar adeudados a cada proveedor, divididos en tres periodos de tiempo.';
                    RunObject = Report 305;
                    Image = Report;
                }
                action("action52")
                {
                    CaptionML = ENU = 'Aged Accounts Payable', ESP = 'Antig�edad pagos';
                    ToolTipML = ENU = 'View a list of aged remaining balances for each vendor.', ESP = 'Permite ver una lista de saldos pendientes vencidos de cada proveedor.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Report 322;
                    Image = Report;
                }
                action("action53")
                {
                    CaptionML = ENU = 'Vendor - Balance to Date', ESP = 'Proveedor - Saldo por fechas';
                    ToolTipML = ENU = 'View, print, or save a detail balance to date for selected vendors.', ESP = 'Permite ver, imprimir o guardar un saldo detallado hasta la fecha para determinados proveedores.';
                    RunObject = Report 321;
                    Image = Report;
                }
                action("action54")
                {
                    CaptionML = ENU = 'Vendor - Trial Balance', ESP = 'Proveedor - Balance sumas y saldos';
                    ToolTipML = ENU = 'View a detail balance for selected vendors.', ESP = 'Permite ver un saldo detallado para determinados proveedores.';
                    ApplicationArea = Suite;
                    RunObject = Report 329;
                    Image = Report;
                }
                action("action55")
                {
                    CaptionML = ENU = 'Vendor - Due Payments', ESP = 'Proveedor - Pagos por vtos.';
                    ApplicationArea = Basic, Suite;
                    // RunObject = Report 7000007;
                    Image = Report;
                }
                action("action56")
                {
                    CaptionML = ENU = 'Vendor - Detail Trial Balance', ESP = 'Proveedor - Balance de comprobaci�n detallado';
                    ToolTipML = ENU = 'View a detail trial balance for selected vendors.', ESP = 'Permite ver un saldo de comprobaci�n detallado de determinados proveedores.';
                    ApplicationArea = Basic, Suite;
                    RunObject = Report 304;
                    Image = Report
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
                CaptionML = ENU = 'Process', ESP = 'Procesar';

                actionref(action38_Promoted; action38)
                {
                }
                actionref(action24_Promoted; action24)
                {
                }
                actionref(action25_Promoted; action25)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informar';

                actionref(action55_Promoted; action55)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'New Document', ESP = 'Nuevo documento';

                actionref(NewPurchaseInvoice_Promoted; NewPurchaseInvoice)
                {
                }
                actionref(NewPurchaseOrder_Promoted; NewPurchaseOrder)
                {
                }
                actionref(NewPurchaseCrMemo_Promoted; NewPurchaseCrMemo)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Vendor', ESP = 'Proveedor';

                actionref(action11_Promoted; action11)
                {
                }
                actionref(ApprovalEntries_Promoted; ApprovalEntries)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        SetVendorNoVisibilityOnFactBoxes;
    END;

    trigger OnOpenPage()
    BEGIN

        //QUONEXT 20.07.17 DRAG&DROP. Actualizaci�n de los ficheros.
        CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Vendor);
        ///FIN QUONEXT 20.07.17
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetSocialListeningFactboxVisibility
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        SetSocialListeningFactboxVisibility;
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RECORDID);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(rec.RECORDID);


        //QUONEXT 20.07.17 DRAG&DROP.
        CurrPage.DropArea.PAGE.SetFilter(Rec);
        CurrPage.FilesSP.PAGE.SetFilter(Rec);
        ///FIN QUONEXT 20.07.17
    END;



    var
        ApprovalsMgmt: Codeunit 1535;
        SocialListeningSetupVisible: Boolean;
        SocialListeningVisible: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;



    procedure GetSelectionFilter(): Text;
    var
        Vend: Record 23;
        SelectionFilterManagement: Codeunit 46;
    begin
        CurrPage.SETSELECTIONFILTER(Vend);
        exit(SelectionFilterManagement.GetSelectionFilterForVendor(Vend));
    end;

    procedure SetSelection(var Vend: Record 23);
    begin
        CurrPage.SETSELECTIONFILTER(Vend);
    end;

    LOCAL procedure SetSocialListeningFactboxVisibility();
    var
        SocialListeningMgt: Codeunit 50455;
    begin
        SocialListeningMgt.GetVendFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;

    LOCAL procedure SetVendorNoVisibilityOnFactBoxes();
    begin
        // CurrPage.VendorDetailsFactBox.PAGE.SetVendorNoVisibility(FALSE);
        // CurrPage.VendorHistBuyFromFactBox.PAGE.SetVendorNoVisibility(FALSE);
        // CurrPage.VendorHistPayToFactBox.PAGE.SetVendorNoVisibility(FALSE);
        // CurrPage.VendorStatisticsFactBox.PAGE.SetVendorNoVisibility(FALSE);
    end;

    // begin//end
}








