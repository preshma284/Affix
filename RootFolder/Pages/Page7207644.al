page 7207644 "RC Payables Coordinator"
{
    CaptionML = ENU = 'Accounts Payable Coordinator', ESP = 'Coordinador Cuentas por pagar';
    PageType = RoleCenter;
    layout
    {
        area(RoleCenter)
        {
            group("group54")
            {

                part("part1"; 7207645)
                {

                    ApplicationArea = Advanced;
                }

            }
            group("group56")
            {

                part("part2"; 9151)
                {

                    ApplicationArea = Advanced;
                }
                part("part3"; 681)
                {

                    ApplicationArea = Advanced;
                }
                part("part4"; 675)
                {

                    ApplicationArea = Advanced;
                    Visible = false;
                }
                systempart(MyNotes; MyNotes)
                {

                    ApplicationArea = Advanced;
                }

            }

        }
    }
    actions
    {
        area(Reporting)
        {

            action("action1")
            {
                CaptionML = ENU = '&Vendor - List', ESP = 'Pro&veedor - Listado';
                ToolTipML = ENU = 'View the list of your vendors.', ESP = 'Ver la lista de sus proveedores.';
                ApplicationArea = Advanced;
                RunObject = Report 301;
                Image = Report;
            }
            action("action2")
            {
                CaptionML = ENU = 'Vendor - &Balance to date', ESP = 'Proveedor - &Saldo por fechas';
                ToolTipML = ENU = 'View, print, or save a detail balance to date for selected vendors.', ESP = 'Permite ver, imprimir o guardar un saldo detallado hasta la fecha para determinados proveedores.';
                ApplicationArea = Advanced;
                RunObject = Report 321;
                Image = Report;
            }
            action("action3")
            {
                CaptionML = ENU = 'Vendor - &Summary Aging', ESP = 'Prov&eedor - Pagos por periodos';
                ToolTipML = ENU = 'View a summary of the payables owed to each vendor, divided into three time periods.', ESP = 'Muestra un resumen de los documentos a pagar adeudados a cada proveedor, divididos en tres per�odos.';
                ApplicationArea = Advanced;
                RunObject = Report 305;
                Image = Report;
            }
            action("action4")
            {
                CaptionML = ENU = 'Aged &Accounts Payable', ESP = '&Antig�edad pagos';
                ToolTipML = ENU = 'View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.', ESP = 'Permite ver un resumen del vencimiento de los pagos o los pagos vencidos a los proveedores (divididos en cuatro periodos). Es necesario especificar la fecha a partir de la cual se desea calcular la antig�edad y la duraci�n del periodo para el que cada columna contendr� datos.';
                ApplicationArea = Advanced;
                RunObject = Report 322;
                Image = Report;
            }
            action("action5")
            {
                CaptionML = ENU = 'Vendor - &Purchase List', ESP = 'Lista compras - P&roveedor';
                ToolTipML = ENU = 'View a list of your purchases in a period, for example, to report purchase activity to customs and tax authorities.', ESP = 'Muestra una lista de las compras realizadas en un per�odo, por ejemplo, para informar sobre la actividad de compras a las autoridades fiscales y aduaneras.';
                ApplicationArea = Advanced;
                RunObject = Report 309;
                Image = Report;
            }
            action("action6")
            {
                CaptionML = ENU = 'Pa&yments on Hold', ESP = 'Pagos re&tenidos';
                ToolTipML = ENU = 'View a list of all vendor ledger entries on which the On Hold field is marked.', ESP = 'Muestra una lista de todos los movimientos de proveedor cuyo campo Esperar aparece marcado.';
                ApplicationArea = Advanced;
                RunObject = Report 319;
                Image = Report;
            }
            action("action7")
            {
                CaptionML = ENU = 'P&urchase Statistics', ESP = 'Esta&d�sticas compras';
                ToolTipML = ENU = 'View a list of amounts for purchases, invoice discount and payment discount in $ for each vendor.', ESP = 'Muestra una lista de importes de compras, descuentos en factura y descuentos por pronto pago en USD de cada proveedor.';
                ApplicationArea = Advanced;
                RunObject = Report 312;
                Image = Report;
            }
            action("action8")
            {
                CaptionML = ENU = 'Vendor &Document Nos.', ESP = '&N� documento proveedor';
                ToolTipML = ENU = 'View a list of vendor ledger entries, sorted by document type and number. The report includes the document type, document number, posting date and source code of the entry, the name and number of the vendor, and so on. A warning appears when there is a gap in the number series or the documents were not posted in document-number order.', ESP = 'Muestra una lista de movimientos de proveedor, ordenados por n�meros y tipo de documento. El informe contiene el tipo de documento, el n�mero de documento, la fecha de registro, el c�digo de origen del movimiento, el nombre y n�mero del proveedor, etc. Aparece una advertencia cuando hay un salto en la numeraci�n o cuando el documento no fue registrado en un documento ordenado por n�meros.';
                ApplicationArea = Advanced;
                // RunObject = Report 328;
                Image = Report;
            }
            action("action9")
            {
                CaptionML = ENU = 'Purchase &Invoice Nos.', ESP = 'N� ser&ie fra. compra';
                ToolTipML = ENU = 'View or set up the number series for purchase invoices.', ESP = 'Permite ver o configurar n�meros de serie para las facturas de compra.';
                ApplicationArea = Advanced;
                // RunObject = Report 324;
                Image = Report;
            }
            action("action10")
            {
                CaptionML = ENU = 'Purchase &Credit Memo Nos.', ESP = 'N� serie abono &compra';
                ToolTipML = ENU = 'View or set up the number series for purchase credit memos.', ESP = 'Permite ver o configurar n�meros de serie para los abonos.';
                ApplicationArea = Advanced;
                // RunObject = Report 325;
                Image = Report;
            }
            action("action11")
            {
                CaptionML = ENU = 'Vendor - Due Payments', ESP = 'Proveedor - Pagos por vtos.';
                ToolTipML = ENU = 'View a list of payments to be made to a particular vendor sorted by due date.', ESP = 'Permite ver una lista de los pagos a realizar a un proveedor determinado ordenados por vencimientos.';
                // RunObject = Report 7000007;
                Image = Report;
            }
            group("group13")
            {
                CaptionML = ENU = 'Cartera Payment Order', ESP = 'Orden pago cartera';
                action("action12")
                {
                    CaptionML = ENU = 'Closed Payment Order Listing', ESP = 'Listado orden pago cerrada';
                    ToolTipML = ENU = 'View the list of completed payment orders.', ESP = 'Muestra la lista de �rdenes de pago completadas.';
                    // RunObject = Report 7000012;
                    Image = Report;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Posted Payment Order Listing', ESP = 'Listado orden pago regis.';
                    ToolTipML = ENU = 'View posted payment orders that represent payables to submit to the bank as a file for electronic payment.', ESP = 'Permite ver las �rdenes de pago registradas que representan los pagos que enviar al banco como un archivo de pago electr�nico.';
                    // RunObject = Report 7000011;
                    Image = Report;
                }
                action("action14")
                {
                    CaptionML = ENU = 'Payment Order Listing', ESP = 'Listado orden pago';
                    ToolTipML = ENU = 'View or edit payment orders that represent payables to submit to the bank as a file for electronic payment.', ESP = 'Permite ver o editar las �rdenes de pago registradas que representan los pagos que enviar al banco como un archivo de pago electr�nico.';
                    // RunObject = Report 7000010;
                    Image = Report;
                }

            }

        }
        area(Embedding)
        {
            ////ToolTipML=ENU='View and process vendor payments, and approve incoming documents.',ESP='Permite ver y procesar pagos de proveedor y aprobar documentos entrantes.';
            action("action15")
            {
                CaptionML = ENU = 'Vendors', ESP = 'Proveedores';
                ToolTipML = ENU = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.', ESP = 'Permite ver o editar la informaci�n detallada de los proveedores con los que realiza operaciones comerciales. En cada ficha de proveedor, puede abrir informaci�n relacionada, como estad�sticas de compras y pedidos en curso. Adem�s, puede definir los precios especiales y los descuentos de l�nea que el proveedor le concede si se cumplen ciertas condiciones.';
                ApplicationArea = Advanced;
                RunObject = Page 27;
                Image = Vendor;
            }
            action("action16")
            {
                CaptionML = ENU = 'Balance', ESP = 'Saldo';
                ToolTipML = ENU = 'View a summary of the bank account balance in different periods.', ESP = 'Permite ver un resumen del saldo de la cuenta bancaria en distintos per�odos.';
                ApplicationArea = Advanced;
                RunObject = Page 27;
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
                Image = Balance;
            }
            action("action17")
            {
                CaptionML = ENU = 'Purchase Orders', ESP = 'Pedidos compra';
                ToolTipML = ENU = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.', ESP = 'Permite crear pedidos de compra para reflejar los documentos de venta que le env�an los proveedores. Esto le permite registrar el coste de compra y realizar un seguimiento de las cuentas por pagar. Al registrar los pedidos de compra din�micamente, se actualizan los niveles de inventario para que pueda reducir los costes de inventario y ofrecer un mejor servicio al cliente. Los pedidos de compra permiten recepciones parciales (a diferencia de las facturas de compra), as� como el env�o directo desde el proveedor al cliente. Los pedidos de compra se pueden crear autom�ticamente a partir de archivos PDF o de imagen proporcionados por los proveedores mediante la caracter�stica Documentos entrantes.';
                ApplicationArea = Advanced;
                RunObject = Page 9307;
            }
            action("action18")
            {
                CaptionML = ENU = 'Purchase Invoices', ESP = 'Facturas compra';
                ToolTipML = ENU = 'Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.', ESP = 'Permite crear facturas de compra para reflejar los documentos de venta que le env�an los proveedores. Esto le permite registrar el coste de compra y realizar un seguimiento de las cuentas por pagar. Al registrar las facturas de compra din�micamente, se actualizan los niveles de inventario para que pueda reducir los costes de inventario y ofrecer un mejor servicio al cliente. Las facturas de compra se pueden crear autom�ticamente a partir de archivos PDF o de imagen proporcionados por los proveedores mediante la caracter�stica Documentos entrantes.';
                ApplicationArea = Advanced;
                RunObject = Page 9308;
            }
            action("action19")
            {
                CaptionML = ENU = 'Payment Orders List', ESP = 'Lista �rdenes pago';
                ToolTipML = ENU = 'View or edit payment orders that represent payables to submit to the bank as a file for electronic payment.', ESP = 'Permite ver o editar las �rdenes de pago registradas que representan los pagos que enviar al banco como un archivo de pago electr�nico.';
                RunObject = Page 7000051;
            }
            action("action20")
            {
                CaptionML = ENU = 'Posted Payment Orders List', ESP = 'Lista �rdenes pago registrada';
                ToolTipML = ENU = 'View posted payment orders that represent payables to submit to the bank as a file for electronic payment.', ESP = 'Permite ver las �rdenes de pago registradas que representan los pagos que enviar al banco como un archivo de pago electr�nico.';
                RunObject = Page 7000055;
            }
            action("action21")
            {
                CaptionML = ENU = 'Purchase Return Orders', ESP = 'Devoluciones compras';
                ToolTipML = ENU = 'Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.', ESP = 'Permite crear pedidos de devoluci�n de compra para reflejar los documentos de devoluci�n de venta que le env�an los proveedores por los productos incorrectos o da�ados que ha pagado y devuelto al proveedor. Los pedidos de devoluci�n de compra le permiten devolver productos correspondientes a varios documentos de compra mediante una �nica devoluci�n de compra y admiten documentos de almac�n para la manipulaci�n de productos. Los pedidos de devoluci�n de compra se pueden crear de forma autom�tica a partir de archivos PDF o de imagen proporcionados por los proveedores mediante la caracter�stica Documentos entrantes. Nota: Si a�n no ha abonado una compra err�nea, simplemente puede cancelar la factura de compra registrada para revertir la transacci�n financiera de forma autom�tica.';
                ApplicationArea = Advanced;
                RunObject = Page 9311;
            }
            action("action22")
            {
                CaptionML = ENU = 'Purchase Credit Memos', ESP = 'Abonos de compra';
                ToolTipML = ENU = 'Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.', ESP = 'Permite crear abonos de compra para reflejar los abonos de venta que le env�an los proveedores por los art�culos incorrectos o da�ados que ha pagado y devuelto al proveedor. Si necesita un mayor control del proceso de devoluci�n de compras (por ejemplo, documentos de almac�n para la manipulaci�n f�sica), use pedidos de devoluci�n de compra, en los que se integran los abonos de compra. Los abonos de compra se pueden crear de forma autom�tica a partir de archivos PDF o de imagen proporcionados por los proveedores mediante la caracter�stica Documentos entrantes. Nota: Si a�n no ha abonado una compra err�nea, simplemente puede cancelar la factura de compra registrada para revertir la transacci�n financiera de forma autom�tica.';
                ApplicationArea = Advanced;
                RunObject = Page 9309;
            }
            action("action23")
            {
                CaptionML = ENU = 'Bank Accounts', ESP = 'Bancos';
                ToolTipML = ENU = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.', ESP = 'Permite ver o configurar informaci�n detallada sobre la cuenta bancaria, por ejemplo, la divisa que se usa, el formato de archivos bancarios que se usa para importar y exportar como pagos electr�nicos y la numeraci�n de los cheques.';
                ApplicationArea = Advanced;
                RunObject = Page 371;
                Image = BankAccount;
            }
            action("action24")
            {
                CaptionML = ENU = 'Items', ESP = 'Productos';
                ToolTipML = ENU = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.', ESP = 'Permite ver o editar la informaci�n detallada de los productos que comercializa. La ficha de producto puede ser del tipo Inventario o Servicio para especificar si el producto es una unidad f�sica o una unidad de tiempo de mano de obra. Este campo tambi�n define si los productos del inventario o de los pedidos entrantes se reservan autom�ticamente para los documentos de salida y si se crean v�nculos de seguimiento de pedidos entre la demanda y el suministro para reflejar las acciones planificadas.';
                ApplicationArea = Advanced;
                RunObject = Page 31;
                Image = Item;
            }
            action("action25")
            {
                CaptionML = ENU = 'Purchase Journals', ESP = 'Diarios de compras';
                ToolTipML = ENU = 'Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.', ESP = 'Permite registrar cualquier transacci�n relacionada con las compras directamente en una cuenta de proveedor, banco o contabilidad general en lugar de utilizar documentos dedicados. Puede registrar todos los tipos de transacciones de compra financieras, incluidos pagos, reembolsos e importes financieros. Tenga en cuenta que no puede registrar las cantidades de producto con un diario de compras.';
                ApplicationArea = Advanced;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST("Purchases"), "Recurring" = CONST(false));
            }
            action("action26")
            {
                CaptionML = ENU = 'Payment Journals', ESP = 'Diarios de pagos';
                ToolTipML = ENU = 'Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.', ESP = 'Permite registrar los pagos a proveedores. Un diario de pagos es un tipo de diario general que se utiliza para registrar transacciones de pago salientes en las cuentas de contabilidad general, banco, cliente, proveedor, empleado y activos fijos. Las funci�n Proponer pagos a proveedores rellena autom�ticamente el diario con pagos que vencen. Cuando se registran los pagos, puede exportar los pagos a un archivo de banco para cargarlo en su banco si el sistema est� configurado para la banca electr�nica. Tambi�n puede emitir cheques electr�nicos desde el diario de pagos.';
                ApplicationArea = Advanced;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST("Payments"), "Recurring" = CONST(false));
                Image = Journals;
            }
            action("action27")
            {
                CaptionML = ENU = 'General Journals', ESP = 'Diarios generales';
                ToolTipML = ENU = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.', ESP = 'Permite registrar las transacciones financieras directamente en las cuentas de contabilidad general y otras cuentas, como las cuentas de banco, cliente, proveedor y empleado. Al registrar con un diario general, siempre se crean movimientos en las cuentas de contabilidad general. Esto es as� incluso cuando, por ejemplo, se registra una l�nea del diario en una cuenta de cliente, ya que el movimiento se registra en una cuenta contable de cobros a trav�s de un grupo contable.';
                ApplicationArea = Advanced;
                RunObject = Page 251;
                RunPageView = WHERE("Template Type" = CONST("General"), "Recurring" = CONST(false));
                Image = Journal;
            }
            action("action28")
            {
                CaptionML = ENU = 'Cartera Journal', ESP = 'Diario cartera';
                ToolTipML = ENU = 'Prepare to post entries for Cartera documents, which are bills and invoices for customers and vendors. There are two types of bills: receivable bills and payable bills. Receivable bills are sent to a customer to be credited after their due date arrives. Payable bills are sent to a customer from a vendor in order to receive payment when the due date arrives.', ESP = 'Permite prepararse para registrar movimientos de documentos Cartera, que son efectos y facturas de clientes y proveedores. Existen dos tipos de efectos: efectos a cobrar y efectos a pagar. Los efectos a cobrar se env�an a un cliente para que se abonen despu�s de su fecha de vencimiento. Los efectos a pagar los env�a un proveedor a un cliente para recibir el pago cuando llegue la fecha de vencimiento.';
                RunObject = Page 251;
                RunPageView = WHERE(//"Template Type" = CONST("Cartera"), to be refactored
                                    "Recurring" = CONST(false));
            }

        }
        area(Sections)
        {

            group("group33")
            {
                CaptionML = ENU = 'Posted Documents', ESP = 'Documentos hist�ricos';
                ToolTipML = ENU = 'View posted purchase invoices and credit memos, and analyze G/L registers.', ESP = 'Permite ver las facturas de compra y los abonos registrados y analizar los registros de movimientos de contabilidad.';
                Image = FiledPosted;
                action("action29")
                {
                    CaptionML = ENU = 'Posted Purchase Receipts', ESP = 'Hist�rico albaranes compra';
                    ToolTipML = ENU = 'Open the list of posted purchase receipts.', ESP = 'Abre la lista de albaranes de compra registrados.';
                    ApplicationArea = Advanced;
                    RunObject = Page 145;
                }
                action("action30")
                {
                    CaptionML = ENU = 'Posted Purchase Invoices', ESP = 'Hist�rico facturas compra';
                    ToolTipML = ENU = 'Open the list of posted purchase invoices.', ESP = 'Abre la lista de facturas de compra registradas.';
                    ApplicationArea = Advanced;
                    RunObject = Page 146;
                }
                action("action31")
                {
                    CaptionML = ENU = 'Posted Purchase Credit Memos', ESP = 'Hist�rico abono compra';
                    ToolTipML = ENU = 'Open the list of posted purchase credit memos.', ESP = 'Permite abrir la lista de abonos de compras registrados.';
                    ApplicationArea = Advanced;
                    RunObject = Page 147;
                }
                action("action32")
                {
                    CaptionML = ENU = 'Payable Closed Cartera Docs', ESP = 'Docs. cartera cerrados a pagar';
                    ToolTipML = ENU = 'View the vendor bills and invoices that are in closed bill groups.', ESP = 'Permite ver las facturas de los proveedores y las facturas que est�n en remesas cerradas.';
                    RunObject = Page 7000013;
                }
                action("action33")
                {
                    CaptionML = ENU = 'Closed Payment Orders List', ESP = 'Lista �rdenes pago cerrada';
                    ToolTipML = ENU = 'View the list of completed payment orders.', ESP = 'Muestra la lista de �rdenes de pago completadas.';
                    RunObject = Page 7000061;
                }
                action("action34")
                {
                    CaptionML = ENU = 'Posted Return Shipments', ESP = 'Hist�rico env�os devoluci�n';
                    ToolTipML = ENU = 'Open the list of posted return shipments.', ESP = 'Abre la lista de facturas de env�os de devoluciones registrados.';
                    ApplicationArea = Advanced;
                    RunObject = Page 6652;
                }
                action("action35")
                {
                    CaptionML = ENU = 'G/L Registers', ESP = 'Registro movs. contabilidad';
                    ToolTipML = ENU = 'View posted G/L entries.', ESP = 'Permite ver los movimientos de C/G registrados.';
                    ApplicationArea = Advanced;
                    RunObject = Page 116;
                    Image = GLRegisters;
                }

            }

        }
        area(Creation)
        {

            action("action36")
            {
                CaptionML = ENU = '&Vendor', ESP = 'Pro&veedor';
                ToolTipML = ENU = '"Set up a new vendor from whom you buy goods or services. "', ESP = '"Permite configurar un nuevo proveedor al que se compran productos o servicios. "';
                ApplicationArea = Advanced;
                RunObject = Page 26;
                Promoted = false;
                Image = Vendor;
                // PromotedCategory = Process;
                RunPageMode = Create;
            }
            action("action37")
            {
                CaptionML = ENU = '&Purchase Order', ESP = '&Pedido compra';
                ToolTipML = ENU = 'Create new purchase order.', ESP = 'Permite crear un nuevo pedido de compra.';
                RunObject = Page 50;
                Promoted = false;
                Image = Document;
                // PromotedCategory = Process;
                RunPageMode = Create;
            }
            action("action38")
            {
                CaptionML = ENU = 'Purchase &Invoice', ESP = '&Factura compra';
                ToolTipML = ENU = 'Create a new purchase invoice.', ESP = 'Crea una nueva factura de compra.';
                ApplicationArea = Advanced;
                RunObject = Page 51;
                Promoted = false;
                Image = NewPurchaseInvoice;
                // PromotedCategory = Process;
                RunPageMode = Create;
            }
            action("action39")
            {
                CaptionML = ENU = 'Purchase Credit &Memo', ESP = 'Abono co&mpra';
                ToolTipML = ENU = 'Create a new purchase credit memo to revert a posted purchase invoice.', ESP = 'Permite crear un nuevo abono de compra para revertir una factura de compra registrada.';
                ApplicationArea = Advanced;
                RunObject = Page 52;
                Promoted = false;
                Image = CreditMemo;
                // PromotedCategory = Process;
                RunPageMode = Create;
            }
            action("action40")
            {
                CaptionML = ENU = 'Payment Order', ESP = 'Orden pago';
                ToolTipML = ENU = 'Create a new payment order to submit payables as a file to the bank for electronic payment.', ESP = 'Permite crear una nueva orden de pago para enviar pagos como un archivo al banco para pago electr�nico.';
                RunObject = Page 7000050;
            }
            group("group47")
            {
                CaptionML = ENU = 'Bill Group - Export Formats', ESP = 'Remesa - Formatos de exportaci�n';
                action("action41")
                {
                    CaptionML = ENU = 'Payment Order - Export N34', ESP = 'Orden pago - Exportar N34';
                    ToolTipML = ENU = 'Send the payment orders to magnetic media, following the Higher Banking Councils (CSB) guidelines (Norm 34).', ESP = 'Env�a las �rdenes de pago en soporte magn�tico, siguiendo las directrices del Consejo Superior Bancario (Norma 34).';
                    // RunObject = Report 7000090;
                    Image = Report;
                }

            }
            action("action42")
            {
                CaptionML = ENU = 'Payment &Journal', ESP = '&Diario de pagos';
                ToolTipML = ENU = 'View or edit the payment journal where you can register payments to vendors.', ESP = 'Permite ver o editar el diario de pagos en el que se pueden registrar los pagos a proveedores.';
                ApplicationArea = Advanced;
                RunObject = Page 256;
                Image = PaymentJournal;
            }
            action("action43")
            {
                CaptionML = ENU = 'P&urchase Journal', ESP = 'Diario &compras';
                ToolTipML = ENU = '"Post any purchase transaction for the vendor. "', ESP = '"Registra todas las transacciones de compras para el proveedor. "';
                ApplicationArea = Advanced;
                RunObject = Page 254;
                Image = Journals;
            }
            action("action44")
            {
                CaptionML = ENU = 'Purchases && Payables &Setup', ESP = 'Confi&guraci�n compras y pagos';
                ToolTipML = ENU = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.', ESP = 'Permite definir las directivas generales de facturaci�n de compras y devoluciones, tales como si se deben requerir n�meros de factura de proveedor y c�mo registrar descuentos de compra. Configure las series num�ricas para la creaci�n de proveedores y los distintos documentos de compra.';
                ApplicationArea = Advanced;
                RunObject = Page 460;
                Image = Setup;
            }
            action("action45")
            {
                CaptionML = ENU = 'Navi&gate', ESP = '&Navegar';
                ToolTipML = ENU = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.', ESP = 'Permite buscar todos los movimientos y los documentos que existen para el n�mero de documento y la fecha de registro que constan en el movimiento, o documento, seleccionado.';
                ApplicationArea = Advanced;
                RunObject = Page 344;
                Image = Navigate
    ;
            }

        }
    }


    /*begin
    end.
  
*/
}







