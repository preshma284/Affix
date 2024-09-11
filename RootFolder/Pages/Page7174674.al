page 7174674 "Customer List Example DragDrop"
{
    Editable = false;
    CaptionML = ENU = 'Customer List', ESP = 'Lista de clientes';
    SourceTable = 18;
    PageType = List;
    CardPageID = "Customer Card";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.', ESP = 'Especifica el n�mero del cliente. El campo se rellena autom�ticamente a partir de una serie num�rica definida o de forma manual porque se habilit� la entrada manual de n�meros en la configuraci�n de series num�ricas.';
                    ApplicationArea = All;
                }
                field("Name"; rec."Name")
                {

                    ToolTipML = ENU = 'Specifies the customers name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.', ESP = 'Especifica el nombre del cliente. Este nombre aparecer� en todos los documentos de venta del cliente. Puede insertar un m�ximo de 50 caracteres, tanto n�meros como letras.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {

                    ToolTipML = ENU = 'Specifies the code for the responsibility center that will administer this customer by default.', ESP = 'Especifica el c�digo del centro de responsabilidad que administrar� este cliente de forma predeterminada.';
                }
                field("Location Code"; rec."Location Code")
                {

                    ToolTipML = ENU = 'Specifies from which location sales to this customer will be processed by default.', ESP = 'Especifica desde qu� ubicaci�n se procesar�n las ventas a este cliente de forma predeterminada.';
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

                    ToolTipML = ENU = 'Specifies the customers telephone number.', ESP = 'Especifica el n�mero de tel�fono del cliente.';
                    ApplicationArea = Basic, Suite;
                }
                field("IC Partner Code"; rec."IC Partner Code")
                {

                    ToolTipML = ENU = 'Specifies the customers IC partner code, if the customer is one of your intercompany partners.', ESP = 'Especifica el c�digo de socio de empresas vinculadas del cliente, si este es uno de sus socios de empresas vinculadas.';
                    Visible = FALSE;
                }
                field("Contact"; rec."Contact")
                {

                    ToolTipML = ENU = 'Specifies the name of the person you regularly contact when you do business with this customer.', ESP = 'Especifica el nombre de la persona con la que se comunica normalmente cuando trata con este cliente.';
                    ApplicationArea = Basic, Suite;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {

                    ToolTipML = ENU = 'Specifies a code for the salesperson who normally handles this customers account.', ESP = 'Especifica un c�digo para el vendedor que suele encargarse de la cuenta de este cliente.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Customer Posting Group"; rec."Customer Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the customers market type to link business transactions to.', ESP = 'Especifica el tipo de mercado del cliente al que vincular las transacciones empresariales.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the customers trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.', ESP = 'Especifica el tipo de comercio del cliente para vincular las transacciones realizadas para este cliente con la cuenta de contabilidad general correspondiente seg�n la configuraci�n de registro general.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the customers VAT specification to link transactions made for this customer to.', ESP = 'Indica la especificaci�n de IVA del cliente a la que vincular las transacciones realizadas para este cliente.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Customer Price Group"; rec."Customer Price Group")
                {

                    ToolTipML = ENU = 'Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.', ESP = 'Especifica el c�digo de grupo de precios de cliente, que puede utilizar para configurar precios de venta especiales en la ventana Precios de venta.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Customer Disc. Group"; rec."Customer Disc. Group")
                {

                    ToolTipML = ENU = 'Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.', ESP = 'Especifica el c�digo de grupo de descuento de cliente, que puede utilizar como criterio para configurar descuentos especiales en la ventana Descuentos l�nea de ventas.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                    ToolTipML = ENU = 'Specifies a code that indicates the payment terms that you require of the customer.', ESP = 'Especifica un c�digo que indica los t�rminos de pago que suele exigir al proveedor.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Reminder Terms Code"; rec."Reminder Terms Code")
                {

                    ToolTipML = ENU = 'Specifies how reminders about late payments are handled for this customer.', ESP = 'Especifica c�mo se controlan los avisos sobre los pagos vencidos para este cliente.';
                    Visible = FALSE;
                }
                field("Fin. Charge Terms Code"; rec."Fin. Charge Terms Code")
                {

                    ToolTipML = ENU = 'Specifies finance charges are calculated for the customer.', ESP = 'Especifica que los intereses que se calculan para el cliente.';
                    Visible = FALSE;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    ToolTipML = ENU = 'Specifies the default currency for the customer.', ESP = 'Especifica la divisa predeterminada para el cliente.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Language Code"; rec."Language Code")
                {

                    ToolTipML = ENU = 'Specifies the language to be used on printouts for this customer.', ESP = 'Especifica el idioma que se va a usar en las copias impresas para este cliente.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Search Name"; rec."Search Name")
                {

                    ToolTipML = ENU = 'Specifies an alternate name that you can use to search for a customer when you cannot remember the value in the Name field.', ESP = 'Especifica un nombre alternativo que puede usar para buscar un cliente cuando no logra recordar el valor del campo Nombre.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Credit Limit (LCY)"; rec."Credit Limit (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.', ESP = 'Especifica el importe m�ximo por el que se permite al cliente superar el saldo del pago antes de que se emitan las advertencias.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Blocked"; rec."Blocked")
                {

                    ToolTipML = ENU = 'Specifies which transactions with the customer that cannot be blocked, for example, because the customer is declared insolvent.', ESP = 'Especifica qu� transacciones con el cliente no pueden bloquearse, por ejemplo, porque el cliente ha sido declarado insolvente.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {

                    ToolTipML = ENU = 'Specifies when the customer card was last modified.', ESP = 'Especifica cu�ndo se modific� la ficha cliente por �ltima vez.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Application Method"; rec."Application Method")
                {

                    ToolTipML = ENU = 'Specifies how to apply payments to entries for this customer.', ESP = 'Especifica c�mo liquidar pagos en los movimientos para este cliente.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Combine Shipments"; rec."Combine Shipments")
                {

                    ToolTipML = ENU = 'Specifies if several orders delivered to the customer can appear on the same sales invoice.', ESP = 'Especifica si en una misma factura de venta pueden figurar varios pedidos entregados al cliente.';
                    Visible = FALSE;
                }
                field("Reserve"; rec."Reserve")
                {

                    ToolTipML = ENU = 'Specifies whether items will never, automatically (Always), or optionally be reserved for this customer. Optional means that you must manually reserve items for this customer.', ESP = 'Especifica si los productos no se reservar�n nunca, lo har�n autom�ticamente (siempre) u opcionalmente para este cliente. Opcional significa que se deben reservar manualmente los productos para este cliente.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Shipping Advice"; rec."Shipping Advice")
                {

                    ToolTipML = ENU = 'Specifies if the customer accepts partial shipment of orders.', ESP = 'Especifica si el cliente acepta env�os parciales de pedidos.';
                    ApplicationArea = Basic, Suite;
                    Visible = FALSE;
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {

                    ToolTipML = ENU = 'Specifies which shipping company is used when you ship items to the customer.', ESP = 'Especifica qu� empresa de env�o se usa cuando se env�an productos al cliente.';
                    ApplicationArea = Suite;
                    Visible = FALSE;
                }
                field("Base Calendar Code"; rec."Base Calendar Code")
                {

                    ToolTipML = ENU = 'Specifies a customizable calendar for shipment planning that includes the customers working days and holidays.', ESP = 'Especifica un calendario personalizable para la planificaci�n de env�os que incluye los d�as laborables y los festivos del cliente.';
                    Visible = FALSE;
                }
                field("Balance (LCY)"; rec."Balance (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customers balance.', ESP = 'Especifica el importe de pago que el cliente debe para las ventas completadas. Este valor tambi�n se conoce como el saldo del cliente.';
                    ApplicationArea = Basic, Suite;

                    ; trigger OnDrillDown()
                    BEGIN
                        rec.OpenCustomerLedgerEntries(FALSE);
                    END;


                }
                field("Balance Due (LCY)"; rec."Balance Due (LCY)")
                {

                    ToolTipML = ENU = 'Specifies payments from the customer that are overdue per todays date.', ESP = 'Especifica los pagos del cliente que est�n vencidos seg�n la fecha actual.';
                    ApplicationArea = Basic, Suite;

                    ; trigger OnDrillDown()
                    BEGIN
                        rec.OpenCustomerLedgerEntries(TRUE);
                    END;


                }
                field("Sales (LCY)"; rec."Sales (LCY)")
                {

                    ToolTipML = ENU = 'Specifies the total net amount of sales to the customer in LCY.', ESP = 'Especifica el importe neto total de las ventas efectuadas al cliente en la divisa local.';
                    ApplicationArea = Basic, Suite;
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
            part("part3"; 5360)
            {

                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = CRMIsCoupledToRecord;
            }
            //removed pages
            // part("part4"; 875)
            // {

            //     ApplicationArea = All;
            //     SubPageLink = "Source Type" = CONST("Customer"), "Source No." = FIELD("No.");
            //     Visible = SocialListeningVisible;
            // }
            // part("part5"; 876)
            // {

            //     ApplicationArea = All;
            //     SubPageLink = "Source Type" = CONST("Customer"), "Source No." = FIELD("No.");
            //     Visible = SocialListeningSetupVisible;
            //     UpdatePropagation = Both;
            // }
            part("SalesHistSelltoFactBox"; 9080)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part("SalesHistBilltoFactBox"; 9081)
            {

                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = FALSE;
            }
            part("CustomerStatisticsFactBox"; 9082)
            {
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part("CustomerDetailsFactBox"; 9084)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = FALSE;
            }
            part("part10"; 35304)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            part("part11"; 35306)
            {

                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            part("part12"; 9085)
            {
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = FALSE;
            }
            part("part13"; 9086)
            {
                SubPageLink = "No." = FIELD("No."), "Currency Filter" = FIELD("Currency Filter"), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = FALSE;
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
                CaptionML = ENU = '&Customer', ESP = '&Cliente';
                Image = Customer;
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Customer"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action2")
                {
                    CaptionML = ENU = '&Payment Days', ESP = 'D�a&s pago';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 10700;
                    RunPageLink = "Table Name" = CONST("Customer"), "Code" = FIELD("Payment Days Code");
                    Image = PaymentDays;
                }
                action("action3")
                {
                    CaptionML = ENU = 'N&on-Payment Periods', ESP = '&Periodos no-pago';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 10701;
                    RunPageLink = "Table Name" = CONST("Customer"), "Code" = FIELD("Non-Paymt. Periods Code");
                    Image = PaymentPeriod;
                }
                group("group6")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action4")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-Individual';
                        ToolTipML = ENU = 'View or edit the single set of dimensions that are set up for the selected record.', ESP = 'Permite ver o editar el grupo �nico de dimensiones configuradas para el registro seleccionado.';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(18), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action5")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&M�ltiple';
                        ToolTipML = ENU = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.', ESP = 'Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar c�digos de dimensi�n a transacciones para distribuir los costes y analizar la informaci�n hist�rica.';
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            Cust: Record 18;
                            DefaultDimMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Cust);
                            DefaultDimMultiple.SetMultiCust(Cust);
                            DefaultDimMultiple.RUNMODAL;
                        END;


                    }

                }
                action("action6")
                {
                    CaptionML = ENU = 'Bank Accounts', ESP = 'Bancos';
                    ToolTipML = ENU = 'View or set up the customers bank accounts. You can set up any number of bank accounts for each customer.', ESP = 'Permite ver o configurar las cuentas bancarias del cliente. Es posible configurar todas las cuentas bancarias deseadas para cada cliente.';
                    RunObject = Page 424;
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = BankAccount;
                }
                action("action7")
                {
                    CaptionML = ENU = 'Direct Debit Mandates', ESP = '�rdenes de domiciliaci�n de adeudo directo';
                    ToolTipML = ENU = 'View the direct-debit mandates that reflect agreements with customers to collect invoice payments from their bank account.', ESP = 'Permite ver las �rdenes de domiciliaci�n de adeudo directo para reflejar los acuerdos con los clientes a fin de cobrar los pagos de factura desde su banco.';
                    RunObject = Page 1230;
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = MakeAgreement;
                }
                action("ShipToAddresses")
                {

                    CaptionML = ENU = 'Ship-&to Addresses', ESP = 'Di&recci�n env�o';
                    ToolTipML = ENU = 'View or edit alternate shipping addresses where the customer wants items delivered if different from the regular address.', ESP = 'Permite ver o editar las direcciones alternativas donde el cliente desea que se entreguen los productos, si difiere de su direcci�n habitual.';
                    RunObject = Page 301;
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = ShipAddress;
                }
                action("action9")
                {
                    CaptionML = ENU = 'Payment A&ddresses', ESP = '&Direcci�n de pago';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page 7000039;
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = Addresses;
                }
                action("action10")
                {
                    AccessByPermission = TableData 5050 = R;
                    CaptionML = ENU = 'C&ontact', ESP = '&Contacto';
                    ToolTipML = ENU = 'View or edit detailed information about the contact person at the customer.', ESP = 'Permite ver o editar la informaci�n detallada sobre la persona de contacto del cliente.';
                    ApplicationArea = Basic, Suite;
                    Image = ContactPerson;

                    trigger OnAction()
                    BEGIN
                        rec.ShowContact;
                    END;


                }
                action("action11")
                {
                    CaptionML = ENU = 'Cross Re&ferences', ESP = 'Referencias cru&zadas';
                    ToolTipML = ENU = 'Set up the customers own identification of items that you sell to the customer. Cross-references to the customers item number means that the item number is automatically shown on sales documents instead of the number that you use.', ESP = 'Permite configurar la identificaci�n propia del cliente en aquellos productos que usted le vende. Las referencias cruzadas con el n�mero de producto del cliente indican que ese n�mero de producto (y no el que usted usa) se muestra autom�ticamente en los documentos de venta.';
                    RunObject = Page 52451;
                    RunPageView = SORTING("Reference Type", "Reference Type No.");
                    RunPageLink = "Reference Type" = CONST("Customer"), "Reference Type No." = FIELD("No.");
                    Image = Change;
                }
                action("OnlineMap")
                {

                    CaptionML = ENU = 'Online Map', ESP = 'Online Map';
                    ToolTipML = ENU = 'View the address on an online map.', ESP = 'Permite ver la direcci�n en un mapa en l�nea.';
                    ApplicationArea = All;
                    Visible = FALSE;
                    Image = Map;
                    Scope = Repeater;

                    trigger OnAction()
                    BEGIN
                        rec.DisplayMap;
                    END;


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
            group("ActionGroupCRM")
            {

                CaptionML = ENU = 'Dynamics CRM', ESP = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action("CRMGotoAccount")
                {

                    CaptionML = ENU = 'Account', ESP = 'Cuenta';
                    ToolTipML = ENU = 'Open the coupled Microsoft Dynamics CRM account.', ESP = 'Abre la cuenta emparejada de Microsoft Dynamics CRM.';
                    ApplicationArea = All;
                    Image = CoupledCustomer;

                    trigger OnAction()
                    VAR
                        CRMIntegrationManagement: Codeunit 5330;
                    BEGIN
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(rec.RECORDID);
                    END;


                }
                action("CRMSynchronizeNow")
                {

                    AccessByPermission = TableData 5331 = IM;
                    CaptionML = ENU = 'Synchronize Now', ESP = 'Sincronizar ahora';
                    ToolTipML = ENU = 'Send or Rec.GET updated data to or from Microsoft Dynamics CRM.', ESP = 'Permite enviar u obtener datos actualizados a Microsoft Dynamics CRM o desde Microsoft Dynamics CRM.';
                    ApplicationArea = All;
                    Image = Refresh;

                    trigger OnAction()
                    VAR
                        Customer: Record 18;
                        CRMIntegrationManagement: Codeunit 5330;
                        CustomerRecordRef: RecordRef;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(Customer);
                        Customer.NEXT;

                        IF Customer.COUNT = 1 THEN
                            CRMIntegrationManagement.UpdateOneNow(Customer.RECORDID)
                        ELSE BEGIN
                            CustomerRecordRef.GETTABLE(Customer);
                            CRMIntegrationManagement.UpdateMultipleNow(CustomerRecordRef);
                        END
                    END;


                }
                action("UpdateStatisticsInCRM")
                {

                    CaptionML = ENU = 'Update Account Statistics', ESP = 'Actualizar estad�sticas de cuentas';
                    ToolTipML = ENU = 'Send customer statistics data to Dynamics CRM to update the Account Statistics FactBox.', ESP = 'Permite enviar datos de estad�sticas de clientes a Dynamics CRM para actualizar el cuadro informativo de estad�sticas de cuentas.';
                    ApplicationArea = All;
                    Enabled = CRMIsCoupledToRecord;
                    Image = UpdateXML;

                    trigger OnAction()
                    VAR
                        CRMIntegrationManagement: Codeunit 5330;
                    BEGIN
                        CRMIntegrationManagement.CreateOrUpdateCRMAccountStatistics(Rec);
                    END;


                }
                group("Coupling")
                {

                    CaptionML =//@@@='Coupling is a noun',
ENU = 'Coupling', ESP = 'Emparejamiento';
                    ToolTipML = ENU = 'Create, change, or Rec.DELETE a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.', ESP = 'Crea, cambia o elimina un emparejamiento entre el registro de Microsoft Dynamics NAV y un registro de Microsoft Dynamics CRM.';
                    Image = LinkAccount;
                    action("ManageCRMCoupling")
                    {

                        AccessByPermission = TableData 5331 = IM;
                        CaptionML = ENU = 'Set Up Coupling', ESP = 'Configurar emparejamiento';
                        ToolTipML = ENU = 'Create or Rec.MODIFY the coupling to a Microsoft Dynamics CRM account.', ESP = 'Permite crear o modificar el emparejamiento con una cuenta de Microsoft Dynamics CRM.';
                        ApplicationArea = All;
                        Image = LinkAccount;

                        trigger OnAction()
                        VAR
                            CRMIntegrationManagement: Codeunit 5330;
                        BEGIN
                            CRMIntegrationManagement.DefineCoupling(rec.RECORDID);
                        END;


                    }
                    action("DeleteCRMCoupling")
                    {

                        AccessByPermission = TableData 5331 = IM;
                        CaptionML = ENU = 'Delete Coupling', ESP = 'Eliminar emparejamiento';
                        ToolTipML = ENU = 'Delete the coupling to a Microsoft Dynamics CRM account.', ESP = 'Elimina el emparejamiento con una cuenta de Microsoft Dynamics CRM.';
                        ApplicationArea = All;
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;

                        trigger OnAction()
                        VAR
                            CRMCouplingManagement: Codeunit 5331;
                        BEGIN
                            CRMCouplingManagement.RemoveCoupling(rec.RECORDID);
                        END;


                    }

                }
                group("Create")
                {

                    CaptionML = ENU = 'Create', ESP = 'Crear';
                    Image = NewCustomer;
                    action("CreateInCRM")
                    {

                        CaptionML = ENU = 'Create Account in Dynamics CRM', ESP = 'Crear cuenta en Dynamics CRM';
                        ToolTipML = ENU = 'Generate the account in the coupled Microsoft Dynamics CRM account.', ESP = 'Genera la cuenta en la cuenta de Microsoft Dynamics CRM emparejada.';
                        ApplicationArea = All;
                        Image = NewCustomer;

                        trigger OnAction()
                        VAR
                            Customer: Record 18;
                            CRMIntegrationManagement: Codeunit 5330;
                            CustomerRecordRef: RecordRef;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Customer);
                            Customer.NEXT;

                            // IF Customer.COUNT = 1 THEN
                                // CRMIntegrationManagement.CreateNewRecordInCRM(rec.RECORDID, FALSE)
                            // ELSE BEGIN
                                // CustomerRecordRef.GETTABLE(Customer);
                                // CRMIntegrationManagement.CreateNewRecordsInCRM(CustomerRecordRef);
                            // END
                        END;


                    }
                    action("CreateFromCRM")
                    {

                        CaptionML = ENU = 'Create Customer in Dynamics NAV', ESP = 'Crear cliente en Dynamics NAV';
                        ToolTipML = ENU = 'Generate the customer in the coupled Microsoft Dynamics CRM account.', ESP = 'Genera el cliente en la cuenta de Microsoft Dynamics CRM emparejada.';
                        ApplicationArea = All;
                        Image = NewCustomer;

                        trigger OnAction()
                        VAR
                            CRMIntegrationManagement: Codeunit 5330;
                        BEGIN
                            CRMIntegrationManagement.ManageCreateNewRecordFromCRM(DATABASE::Customer);
                        END;


                    }

                }

            }
            group("group27")
            {
                CaptionML = ENU = 'History', ESP = 'Historial';
                Image = History;
                action("CustomerLedgerEntries")
                {

                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                    RunObject = Page 25;
                    RunPageView = SORTING("Customer No.")
                                  ORDER(Descending);
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = CustomerLedger;
                }
                action("action22")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 151;
                    RunPageLink = "No." = FIELD("No."), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = Statistics;
                }
                action("action23")
                {
                    CaptionML = ENU = 'S&ales', ESP = 'Ve&ntas';
                    RunObject = Page 155;
                    RunPageLink = "No." = FIELD("No."), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = Sales;
                }
                action("action24")
                {
                    CaptionML = ENU = 'Entry Statistics', ESP = 'Estad�sticas documentos';
                    RunObject = Page 302;
                    RunPageLink = "No." = FIELD("No."), "Date Filter" = FIELD("Date Filter"), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Image = EntryStatistics;
                }
                action("action25")
                {
                    CaptionML = ENU = 'Statistics by C&urrencies', ESP = 'Estad�sticas por di&visas';
                    RunObject = Page 486;
                    RunPageLink = "Customer Filter" = FIELD("No."), "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"), "Date Filter" = FIELD("Date Filter");
                    Image = Currencies;
                }
                action("action26")
                {
                    CaptionML = ENU = 'Item &Tracking Entries', ESP = 'Movs. &seguim. prod.';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    VAR
                        ItemTrackingDocMgt: Codeunit 6503;
                    BEGIN
                        // ItemTrackingDocMgt.ShowItemTrackingForMasterData(1, rec."No.", '', '', '', '', '');
                    END;


                }

            }
            group("group34")
            {
                CaptionML = ENU = 'S&ales', ESP = 'Ve&ntas';
                Image = Sales;
                action("Sales_InvoiceDiscounts")
                {

                    CaptionML = ENU = 'Invoice &Discounts', ESP = 'Dto. &factura';
                    ToolTipML = ENU = 'Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.', ESP = 'Permite configurar descuentos diferentes que se aplican a las facturas para el cliente. Un descuento de factura se concede autom�ticamente al cliente cuando el total de una factura de venta supera un importe determinado.';
                    RunObject = Page 23;
                    RunPageLink = "Code" = FIELD("Invoice Disc. Code");
                    Image = CalculateInvoiceDiscount;
                }
                action("Sales_Prices")
                {

                    CaptionML = ENU = 'Prices', ESP = 'Precios';
                    ToolTipML = ENU = 'View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.', ESP = 'Permite ver o configurar distintos precios para los art�culos que se venden al cliente. Se concede un precio de art�culo autom�ticamente en las l�neas de factura cuando se cumplen los criterios especificados, como el cliente, la cantidad o la fecha final.';
                    RunObject = Page 7002;
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    RunPageLink = "Sales Type" = CONST("Customer"), "Sales Code" = FIELD("No.");
                    Image = Price;
                }
                action("Sales_LineDiscounts")
                {

                    CaptionML = ENU = 'Line Discounts', ESP = 'Descuentos l�nea';
                    ToolTipML = ENU = 'Set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.', ESP = 'Permite configurar descuentos distintos para los productos que se venden al cliente. Un descuento de producto se concede autom�ticamente en las l�neas de factura cuando se cumplen los criterios especificados, como el cliente, la cantidad o la fecha final.';
                    RunObject = Page 7004;
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    RunPageLink = "Sales Type" = CONST("Customer"), "Sales Code" = FIELD("No.");
                    Image = LineDiscount;
                }
                action("action30")
                {
                    CaptionML = ENU = 'Prepa&yment Percentages', ESP = 'Porcentajes &prepago';
                    RunObject = Page 664;
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    RunPageLink = "Sales Type" = CONST("Customer"), "Sales Code" = FIELD("No.");
                    Image = PrepaymentPercentages;
                }
                action("action31")
                {
                    CaptionML = ENU = 'S&td. Cust. Sales Codes', ESP = '&C�d. est�nd. vtas. clie.';
                    RunObject = Page 173;
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = CodesList;
                }

            }
            group("group40")
            {
                CaptionML = ENU = 'Documents', ESP = 'Documentos';
                Image = Documents;
                action("action32")
                {
                    CaptionML = ENU = 'Quotes', ESP = 'Ofertas';
                    RunObject = Page 9300;
                    RunPageView = SORTING("Sell-to Customer No.");
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    Image = Quote;
                }
                action("action33")
                {
                    CaptionML = ENU = 'Orders', ESP = 'Pedidos';
                    RunObject = Page 9305;
                    RunPageView = SORTING("Sell-to Customer No.");
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    Image = Document;
                }
                action("action34")
                {
                    CaptionML = ENU = 'Return Orders', ESP = 'Devoluciones';
                    RunObject = Page 9304;
                    RunPageView = SORTING("Sell-to Customer No.");
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    Image = ReturnOrder;
                }
                group("group44")
                {
                    CaptionML = ENU = 'Issued Documents', ESP = 'Documentos emitidos';
                    Image = Documents;
                    action("action35")
                    {
                        CaptionML = ENU = 'Issued &Reminders', ESP = 'A&visos emitidos';
                        RunObject = Page 440;
                        RunPageView = SORTING("Customer No.", "Posting Date");
                        RunPageLink = "Customer No." = FIELD("No.");
                        Image = OrderReminder;
                    }
                    action("action36")
                    {
                        CaptionML = ENU = 'Issued &Finance Charge Memos', ESP = 'Docs. de &financiaci�n emitidos';
                        RunObject = Page 452;
                        RunPageView = SORTING("Customer No.", "Posting Date");
                        RunPageLink = "Customer No." = FIELD("No.");
                        Image = FinChargeMemo;
                    }

                }
                action("action37")
                {
                    CaptionML = ENU = 'Blanket Orders', ESP = 'Pedidos abiertos';
                    RunObject = Page 9303;
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    Image = BlanketOrder;
                }

            }
            group("group48")
            {
                CaptionML = ENU = 'Service', ESP = 'Servicio';
                Image = ServiceItem;
                action("action38")
                {
                    CaptionML = ENU = 'Service Orders', ESP = 'Pedidos servicio';
                    RunObject = Page 9318;
                    RunPageView = SORTING("Document Type", "Customer No.");
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = Document;
                }
                action("action39")
                {
                    CaptionML = ENU = 'Ser&vice Contracts', ESP = 'Con&tratos servicios';
                    RunObject = Page 6065;
                    RunPageView = SORTING("Customer No.", "Ship-to Code");
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = ServiceAgreement;
                }
                action("action40")
                {
                    CaptionML = ENU = 'Service &Items', ESP = '&Productos servicio';
                    RunObject = Page 5988;
                    RunPageView = SORTING("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = ServiceItem;
                }

            }

        }
        area(Creation)
        {

            action("NewSalesBlanketOrder")
            {

                CaptionML = ENU = 'Blanket Sales Order', ESP = 'Pedido abierto venta';
                RunObject = Page 507;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                Image = BlanketOrder;
                RunPageMode = Create;
            }
            action("NewSalesQuote")
            {

                CaptionML = ENU = 'Sales Quote', ESP = 'Oferta venta';
                ToolTipML = ENU = 'Create a new sales quote where you offer items or services to a customer.', ESP = 'Permite crear una nueva oferta de venta en la que se pueden ofrecer productos o servicios a un cliente.';
                ApplicationArea = Basic, Suite;
                RunObject = Page 41;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                Image = NewSalesQuote;
                RunPageMode = Create;
            }
            action("NewSalesInvoice")
            {

                CaptionML = ENU = 'Sales Invoice', ESP = 'Factura venta';
                ToolTipML = ENU = 'Create a sales invoice for the customer.', ESP = 'Crea una factura de venta para el cliente.';
                ApplicationArea = Basic, Suite;
                RunObject = Page 43;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                Image = NewSalesInvoice;
                RunPageMode = Create;
            }
            action("NewSalesOrder")
            {

                CaptionML = ENU = 'Sales Order', ESP = 'Pedido venta';
                ToolTipML = ENU = 'Create a sales order for the customer.', ESP = 'Crea un pedido de venta para el cliente.';
                ApplicationArea = Basic, Suite;
                RunObject = Page 42;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                Image = Document;
                RunPageMode = Create;
            }
            action("NewSalesCrMemo")
            {

                CaptionML = ENU = 'Sales Credit Memo', ESP = 'Abono venta';
                ToolTipML = ENU = 'Create a new sales credit memo to revert a posted sales invoice.', ESP = 'Permite crear un nuevo abono de venta para revertir una factura de venta registrada.';
                ApplicationArea = Basic, Suite;
                RunObject = Page 44;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                Image = CreditMemo;
                RunPageMode = Create;
            }
            action("NewSalesReturnOrder")
            {

                CaptionML = ENU = 'Sales Return Order', ESP = 'Devoluci�n venta';
                RunObject = Page 6630;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                Image = ReturnOrder;
                RunPageMode = Create;
            }
            action("NewServiceQuote")
            {

                CaptionML = ENU = 'Service Quote', ESP = 'Oferta servicio';
                RunObject = Page 5964;
                RunPageLink = "Customer No." = FIELD("No.");
                Image = Quote;
                RunPageMode = Create;
            }
            action("NewServiceInvoice")
            {

                CaptionML = ENU = 'Service Invoice', ESP = 'Factura servicio';
                RunObject = Page 5933;
                RunPageLink = "Customer No." = FIELD("No.");
                Image = Invoice;
                RunPageMode = Create;
            }
            action("NewServiceOrder")
            {

                CaptionML = ENU = 'Service Order', ESP = 'Pedido servicio';
                RunObject = Page 5900;
                RunPageLink = "Customer No." = FIELD("No.");
                Image = Document;
                RunPageMode = Create;
            }
            action("NewServiceCrMemo")
            {

                CaptionML = ENU = 'Service Credit Memo', ESP = 'Abono servicio';
                RunObject = Page 5935;
                RunPageLink = "Customer No." = FIELD("No.");
                Image = CreditMemo;
                RunPageMode = Create;
            }
            action("NewReminder")
            {

                CaptionML = ENU = 'Reminder', ESP = 'Recordatorio';
                RunObject = Page 434;
                RunPageLink = "Customer No." = FIELD("No.");
                Image = Reminder;
                RunPageMode = Create;
            }
            action("NewFinChargeMemo")
            {

                CaptionML = ENU = 'Finance Charge Memo', ESP = 'Documento inter�s';
                RunObject = Page 446;
                RunPageLink = "Customer No." = FIELD("No.");
                Image = FinChargeMemo;
                RunPageMode = Create;
            }

        }
        area(Processing)
        {

            group("group66")
            {
                CaptionML = ENU = 'History', ESP = 'Historial';
                Image = History;
                action("CustomerLedgerEntriesHistory")
                {

                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                    RunObject = Page 25;
                    RunPageView = SORTING("Customer No.");
                    RunPageLink = "Customer No." = FIELD("No.");
                    Image = CustomerLedger;
                    Scope = Repeater;
                }

            }
            group("PricesAndDiscounts")
            {

                CaptionML = ENU = 'Prices and Discounts', ESP = 'Precios y descuentos';
                action("Prices_InvoiceDiscounts")
                {

                    CaptionML = ENU = 'Invoice &Discounts', ESP = 'Dto. &factura';
                    ToolTipML = ENU = 'Set up different discounts applied to invoices for the selected customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.', ESP = 'Permite configurar descuentos diferentes que se aplican a las facturas del cliente seleccionado. Un descuento en factura se concede autom�ticamente al cliente cuando el total de una factura de venta supera un importe determinado.';
                    RunObject = Page 23;
                    RunPageLink = "Code" = FIELD("Invoice Disc. Code");
                    Image = CalculateInvoiceDiscount;
                    Scope = Repeater;
                }
                action("Prices_Prices")
                {

                    CaptionML = ENU = 'Prices', ESP = 'Precios';
                    ToolTipML = ENU = 'View or set up different prices for items that you sell to the selected customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.', ESP = 'Permite ver o configurar precios distintos para los art�culos que se venden al cliente seleccionado. Se concede un precio de art�culo autom�ticamente en las l�neas de factura cuando se cumplen los criterios especificados, como el cliente, la cantidad o la fecha final.';
                    RunObject = Page 7002;
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    RunPageLink = "Sales Type" = CONST("Customer"), "Sales Code" = FIELD("No.");
                    Image = Price;
                    Scope = Repeater;
                }
                action("Prices_LineDiscounts")
                {

                    CaptionML = ENU = 'Line Discounts', ESP = 'Descuentos l�nea';
                    ToolTipML = ENU = 'Set up different discounts for items that you sell to the selected customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.', ESP = 'Permite configurar descuentos distintos para los productos que se venden al cliente seleccionado. Un descuento de producto se concede autom�ticamente en las l�neas de factura cuando se cumplen los criterios especificados, como el cliente, la cantidad o la fecha final.';
                    RunObject = Page 7004;
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    RunPageLink = "Sales Type" = CONST("Customer"), "Sales Code" = FIELD("No.");
                    Image = LineDiscount;
                    Scope = Repeater;
                }

            }
            group("group72")
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Aprobaci�n solic.';
                Image = SendApprovalRequest;
                action("SendApprovalRequest")
                {

                    CaptionML = ENU = 'Send A&pproval Request', ESP = 'Enviar solicitud a&probaci�n';
                    ToolTipML = ENU = 'Send an approval request.', ESP = 'Env�a una solicitud de aprobaci�n.';
                    Enabled = (NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    VAR
                        ApprovalsMgmt: Codeunit 1535;
                    BEGIN
                        IF ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnSendCustomerForApproval(Rec);
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
                        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                    END;


                }

            }
            group("group75")
            {
                CaptionML = ENU = 'Workflow', ESP = 'Flujo de trabajo';
                action("CreateApprovalWorkflow")
                {

                    CaptionML = ENU = 'Create Approval Workflow', ESP = 'Crear flujo de trabajo de aprobaci�n';
                    ToolTipML = ENU = 'Set up an approval workflow for creating or changing customers, by going through a few pages that will guide you.', ESP = 'Permite configurar un flujo de trabajo de aprobaci�n para crear o cambiar clientes a trav�s de unas cuantas p�ginas que le orientar�n.';
                    ApplicationArea = Suite;
                    Enabled = NOT EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Cust. Approval WF Setup Wizard");
                    END;


                }
                action("ManageApprovalWorkflows")
                {

                    CaptionML = ENU = 'Manage Approval Workflows', ESP = 'Administrar flujos de trabajo de aprobaci�n';
                    ToolTipML = ENU = 'View or edit existing approval workflows for creating or changing customers.', ESP = 'Permite ver o editar flujos de trabajo de aprobaci�n existentes para crear o modificar clientes.';
                    ApplicationArea = Suite;
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;

                    trigger OnAction()
                    VAR
                        WorkflowManagement: Codeunit 1501;
                    BEGIN
                        WorkflowManagement.NavigateToWorkflows(DATABASE::Customer, EventFilter);
                    END;


                }

            }
            action("action61")
            {
                CaptionML = ENU = 'Cash Receipt Journal', ESP = 'Diario de recibos de efectivo';
                RunObject = Page 255;
                Image = CashReceiptJournal;
            }
            action("action62")
            {
                CaptionML = ENU = 'Sales Journal', ESP = 'Diario ventas';
                RunObject = Page 253;
                Image = Journals;
            }

        }
        area(Reporting)
        {

            group("Reports")
            {

                CaptionML = ENU = 'Reports', ESP = 'Informes';
                group("SalesReports")
                {

                    CaptionML = ENU = 'Sales Reports', ESP = 'Informes de ventas';
                    Image = Report;
                    action("ReportCustomerTop10List")
                    {

                        CaptionML = ENU = 'Customer - Top 10 List', ESP = 'Cliente - Listado 10 mejores';
                        ToolTipML = ENU = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.', ESP = 'Permite ver los clientes que m�s compran o que m�s deben en un per�odo seleccionado. Solo se incluir�n los clientes que hayan comprado durante el per�odo seleccionado o que tengan alg�n saldo al final de este.';
                        ApplicationArea = Basic, Suite;
                        RunObject = Report 111;
                        Image = Report;
                    }
                    action("ReportCustomerSalesList")
                    {

                        CaptionML = ENU = 'Customer - Sales List', ESP = 'Lista ventas - cliente';
                        ToolTipML = ENU = 'View customer sales in a period, for example, to report sales activity to customs and tax authorities.', ESP = 'Permite ver las ventas a clientes en un per�odo, por ejemplo, para informar de la actividad de ventas a las autoridades fiscales y aduaneras.';
                        ApplicationArea = Basic, Suite;
                        RunObject = Report 119;
                        Image = Report;
                    }
                    action("ReportSalesStatistics")
                    {

                        CaptionML = ENU = 'Sales Statistics', ESP = 'Estad�sticas ventas';
                        ToolTipML = ENU = 'View customers total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.', ESP = 'Permite ver el total de costes, ventas y beneficios de los clientes a lo largo del tiempo, por ejemplo, para analizar las tendencias de ganancias. Este informe muestra importes originales y actualizados de costes, ventas, beneficios, descuentos en factura, descuentos por pronto pago y porcentaje de beneficio durante tres per�odos ajustables.';
                        ApplicationArea = Basic, Suite;
                        RunObject = Report 112;
                        Image = Report;
                    }

                }
                group("FinanceReports")
                {

                    CaptionML = ENU = 'Finance Reports', ESP = 'Informes financieros';
                    Image = Report;
                    action("action66")
                    {
                        CaptionML = ENU = 'Statement', ESP = 'Extracto';
                        ToolTipML = ENU = 'View a list of a customers transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.', ESP = 'Permite ver una lista de transacciones del cliente en un per�odo seleccionado, por ejemplo, para enviar al cliente al cierre de un per�odo contable. Tambi�n permite ver todos los saldos vencidos, sea cual sea el per�odo especificado, o bien elegir que se incluya un rango de antig�edad.';
                        ApplicationArea = Basic, Suite;
                        RunObject = Codeunit 8810;
                        Image = Report;
                    }
                    action("ReportCustomerBalanceToDate")
                    {

                        CaptionML = ENU = 'Customer - Balance to Date', ESP = 'Cliente - Saldo por fechas';
                        ToolTipML = ENU = 'View, print, or save a customers balance on a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.', ESP = 'Vea, imprima o guarde el saldo de un cliente en una fecha determinada. Puede usar el informe para extraer el ingreso total de venta al cierre de un per�odo contable o del a�o fiscal.';
                        RunObject = Report 121;
                        Image = Report;
                    }
                    action("ReportCustomerTrialBalance")
                    {

                        CaptionML = ENU = 'Customer - Trial Balance', ESP = 'Cliente - Balance sumas y saldos';
                        ToolTipML = ENU = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.', ESP = 'Permite ver el saldo inicial y final de los clientes con movimientos durante un per�odo especificado. El informe se puede utilizar para comprobar que el saldo de un grupo contable de cliente es igual al saldo de la cuenta de contable correspondiente en una fecha determinada.';
                        ApplicationArea = Suite;
                        RunObject = Report 129;
                        Image = Report;
                    }
                    action("ReportCustomerDetailTrial")
                    {

                        CaptionML = ENU = 'Customer - Detail Trial Bal.', ESP = 'Cliente - Movimientos';
                        ToolTipML = ENU = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.', ESP = 'Permite ver el saldo de los clientes con saldos en una fecha determinada. El informe puede usarse, por ejemplo, al cierre de un per�odo contable o para una auditor�a.';
                        ApplicationArea = Basic, Suite;
                        RunObject = Report 104;
                        Image = Report;
                    }
                    action("ReportCustomerSummaryAging")
                    {

                        CaptionML = ENU = 'Customer - Summary Aging', ESP = 'Deuda cliente por vencimientos';
                        ToolTipML = ENU = 'View, print, or save a summary of each customers total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customers creditworthiness, or to prepare liquidity analyses.', ESP = 'Permite ver, imprimir o guardar un resumen del total de pagos vencidos de cada cliente, divididos en tres periodos. El informe se puede utilizar para decidir cu�ndo emitir recordatorios, valorar el cr�dito de un cliente o preparar los an�lisis liquidez.';
                        RunObject = Report 105;
                        Image = Report;
                    }
                    action("ReportCustomerDetailedAging")
                    {

                        CaptionML = ENU = 'Customer - Detailed Aging', ESP = 'Cliente - Deuda pendiente';
                        ToolTipML = ENU = 'View, print, or save a detailed list of each customers total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customers creditworthiness, or to prepare liquidity analyses.', ESP = 'Permite ver, imprimir o guardar una lista detallada del total de pagos vencidos de cada cliente, divididos en tres periodos. El informe se puede utilizar para decidir cu�ndo emitir recordatorios, valorar el cr�dito de un cliente o preparar un an�lisis liquidez.';
                        RunObject = Report 106;
                        Image = Report;
                    }
                    action("ReportAgedAccountsReceivable")
                    {

                        CaptionML = ENU = 'Aged Accounts Receivable', ESP = 'Antig�edad cobros';
                        ToolTipML = ENU = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.', ESP = 'Permite ver un resumen del vencimiento de los pagos o los pagos vencidos de los clientes, divididos en cuatro periodos. Es necesario especificar la fecha a partir de la cual se desea calcular la antig�edad y la duraci�n del periodo para el que cada columna contendr� datos.';
                        ApplicationArea = Basic, Suite;
                        RunObject = Report 120;
                        Image = Report;
                    }
                    action("ReportCustomerPaymentReceipt")
                    {

                        CaptionML = ENU = 'Customer - Payment Receipt', ESP = 'Clientes - Pagos recibidos';
                        ToolTipML = ENU = 'View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.', ESP = 'Permite ver un documento que muestra los movimientos de cliente en los que se liquid� un pago. Este informe puede usarse como albar�n de pago para enviar al cliente.';
                        ApplicationArea = Suite;
                        RunObject = Report 211;
                        Image = Report;
                    }

                }

            }
            group("group95")
            {
                CaptionML = ENU = 'General', ESP = 'General';
                action("action74")
                {
                    CaptionML = ENU = 'Customer List', ESP = 'Lista de clientes';
                    RunObject = Report 101;
                    Image = Report;
                }
                action("action75")
                {
                    CaptionML = ENU = 'Customer Register', ESP = 'Registro movs. cliente';
                    RunObject = Report 103;
                    Image = Report;
                }
                action("action76")
                {
                    CaptionML = ENU = 'Customer - Top 10 List', ESP = 'Cliente - Listado 10 mejores';
                    RunObject = Report 111;
                    Image = Report;
                }

            }
            group("group99")
            {
                CaptionML = ENU = 'Sales', ESP = 'Ventas';
                Image = Sales;
                action("action77")
                {
                    CaptionML = ENU = 'Customer - Order Summary', ESP = 'Cliente - Total pedidos';
                    RunObject = Report 107;
                    Image = Report;
                }
                action("action78")
                {
                    CaptionML = ENU = 'Customer - Order Detail', ESP = 'Cliente - L�neas pedidos';
                    RunObject = Report 108;
                    Image = Report;
                }
                action("action79")
                {
                    CaptionML = ENU = 'Customer - Sales List', ESP = 'Lista ventas - cliente';
                    RunObject = Report 119;
                    Image = Report;
                }
                action("action80")
                {
                    CaptionML = ENU = 'Sales Statistics', ESP = 'Estad�sticas ventas';
                    RunObject = Report 112;
                    Image = Report;
                }
                action("action81")
                {
                    CaptionML = ENU = 'Customer/Item Sales', ESP = 'Cliente - Ventas por productos';
                    RunObject = Report 113;
                    Image = Report;
                }

            }
            group("group105")
            {
                CaptionML = ENU = 'Finance', ESP = 'Finanzas';
                Image = Report;
                action("action82")
                {
                    CaptionML = ENU = 'Customer - Detail Trial Bal.', ESP = 'Cliente - Movimientos';
                    RunObject = Report 104;
                    Image = Report;
                }
                action("action83")
                {
                    CaptionML = ENU = 'Customer - Summary Aging', ESP = 'Deuda cliente por vencimientos';
                    RunObject = Report 105;
                    Image = Report;
                }
                action("action84")
                {
                    CaptionML = ENU = 'Customer Detailed Aging', ESP = 'Deuda pendiente cliente';
                    RunObject = Report 106;
                    Image = Report;
                }
                action("Statement")
                {

                    CaptionML = ENU = 'Statement', ESP = 'Extracto';
                    RunObject = Codeunit 8810;
                    Image = Report;
                }
                action("action86")
                {
                    CaptionML = ENU = 'Reminder', ESP = 'Recordatorio';
                    RunObject = Report 117;
                    Image = Reminder;
                }
                action("action87")
                {
                    CaptionML = ENU = 'Aged Accounts Receivable', ESP = 'Antig�edad cobros';
                    RunObject = Report 120;
                    Image = Report;
                }
                action("action88")
                {
                    CaptionML = ENU = 'Customer - Balance to Date', ESP = 'Cliente - Saldo por fechas';
                    RunObject = Report 121;
                    Image = Report;
                }
                action("action89")
                {
                    CaptionML = ENU = 'Customer - Trial Balance', ESP = 'Cliente - Balance sumas y saldos';
                    RunObject = Report 129;
                    Image = Report;
                }
                action("action90")
                {
                    CaptionML = ENU = 'Customer - Payment Receipt', ESP = 'Clientes - Pagos recibidos';
                    RunObject = Report 211;
                    Image = Report;
                }

            }
            action("action91")
            {
                CaptionML = ENU = 'Customer - Due Payments', ESP = 'Cliente - Cobros por vtos.';
                ApplicationArea = Basic, Suite;
                // RunObject = Report 7000006;
                Image = Report;
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

                actionref(action61_Promoted; action61)
                {
                }
                actionref(action62_Promoted; action62)
                {
                }
                actionref(action22_Promoted; action22)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informar';

                actionref(action77_Promoted; action77)
                {
                }
                actionref(action79_Promoted; action79)
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
                actionref(action87_Promoted; action87)
                {
                }
                actionref(action88_Promoted; action88)
                {
                }
                actionref(action90_Promoted; action90)
                {
                }
                actionref(action91_Promoted; action91)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Approve', ESP = 'Aprobar';
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'New Document', ESP = 'Nuevo documento';

                actionref(OnlineMap_Promoted; OnlineMap)
                {
                }
                actionref(NewSalesQuote_Promoted; NewSalesQuote)
                {
                }
                actionref(NewSalesInvoice_Promoted; NewSalesInvoice)
                {
                }
                actionref(NewSalesOrder_Promoted; NewSalesOrder)
                {
                }
                actionref(NewSalesCrMemo_Promoted; NewSalesCrMemo)
                {
                }
                actionref(NewReminder_Promoted; NewReminder)
                {
                }
            }
            group(Category_Category6)
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Solicitar aprobaci�n';
            }
            group(Category_Category7)
            {
                CaptionML = ENU = 'Customer', ESP = 'Cliente';

                actionref(action10_Promoted; action10)
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
        SetCustomerNoVisibilityOnFactBoxes;
    END;

    trigger OnOpenPage()
    VAR
        CRMIntegrationManagement: Codeunit 5330;
    BEGIN
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        SetWorkflowManagementEnabledState;

        //QUONEXT 20.07.17 DRAG&DROP. Actualizaci�n de los ficheros.
        CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Customer);
        ///FIN QUONEXT 20.07.17
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetSocialListeningFactboxVisibility;
    END;

    trigger OnAfterGetCurrRecord()
    VAR
        CRMCouplingManagement: Codeunit 5331;
    BEGIN
        SetSocialListeningFactboxVisibility;

        CRMIsCoupledToRecord :=
          CRMCouplingManagement.IsRecordCoupledToCRM(rec.RECORDID) AND CRMIntegrationEnabled;
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RECORDID);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(rec.RECORDID);

        SetWorkflowManagementEnabledState;

        //QUONEXT 20.07.17 DRAG&DROP.
        CurrPage.DropArea.PAGE.SetFilter(Rec);
        CurrPage.FilesSP.PAGE.SetFilter(Rec);
        ///FIN QUONEXT 20.07.17
    END;



    var
        ApprovalsMgmt: Codeunit 1535;
        SocialListeningSetupVisible: Boolean;
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        EventFilter: Text;

    procedure GetSelectionFilter(): Text;
    var
        Cust: Record 18;
        SelectionFilterManagement: Codeunit 46;
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        exit(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    end;

    procedure SetSelection(var Cust: Record 18);
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
    end;

    LOCAL procedure SetSocialListeningFactboxVisibility();
    var
        SocialListeningMgt: Codeunit 50455;
    begin
        SocialListeningMgt.GetCustFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;

    LOCAL procedure SetCustomerNoVisibilityOnFactBoxes();
    begin
        // CurrPage.SalesHistSelltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
        // CurrPage.SalesHistBilltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
        // CurrPage.CustomerDetailsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
        // CurrPage.CustomerStatisticsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    end;

    LOCAL procedure SetWorkflowManagementEnabledState();
    var
        WorkflowManagement: Codeunit 1501;
        WorkflowEventHandling: Codeunit 1520;
    begin
        EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer, EventFilter);
    end;

    // begin
    /*{
      QUONEXT 20.07.17 DRAG&DROP. Ejemplo del procedimiento para integrar otro maestro.
                       Dos nuevos factbox en la p�gina "Drop Area" y "FilesSP"
                       Dos nuevas llamadas a esos factbox en el m�todo OnAfterGetCurrRecord y una en OnOpenPage
    }*///end
}








