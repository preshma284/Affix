page 7207328 "QuoBuilding Setup"
{
    CaptionML = ENU = 'QuoBuilding Setup', ESP = 'Conf. QuoBuilding';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207278;
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("group7")
            {

                CaptionML = ESP = 'Versiones';
                field("QBGlobalConf.Version QB"; QBGlobalConf."Version QB")
                {

                    CaptionML = ESP = 'Versi�n QB';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('QuoBuilding');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.QPR Version"; QBGlobalConf."QPR Version")
                {

                    CaptionML = ESP = 'Versi�n Presupuestos';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('QPR');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.RE Version"; QBGlobalConf."RE Version")
                {

                    CaptionML = ESP = 'Versi�n Real Estate';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('RE');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.MD Version"; QBGlobalConf."MD Version")
                {

                    CaptionML = ESP = 'Versi�n Master Data';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('Master Data');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.Version QuoSync"; QBGlobalConf."Version QuoSync")
                {

                    CaptionML = ESP = 'Versi�n QuoSync';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('QuoSync');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.Version SP"; QBGlobalConf."Version SP")
                {

                    CaptionML = ESP = 'Versi�n SP';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('SharePoint');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.Version QFA"; QBGlobalConf."Version QFA")
                {

                    CaptionML = ESP = 'Versi�n QFA';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('QuoFacturae');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.Version QuoSII"; QBGlobalConf."Version QuoSII")
                {

                    CaptionML = ESP = 'Versi�n QuoSII';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct('QuoSII');
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("rQBVersionChanges.GetDataVersion"; rQBVersionChanges.GetDataVersion)
                {

                    CaptionML = ESP = 'Version de Datos';
                    Editable = false;

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        CLEAR(QBVersionChanges);
                        QBVersionChanges.SetProduct(rQBVersionChanges.GetKey_DV);
                        QBVersionChanges.RUNMODAL;
                    END;


                }
                field("QBGlobalConf.License No."; QBGlobalConf."License No.")
                {

                    CaptionML = ENU = 'License No.', ESP = 'N� Lincencia';
                    Editable = enAdmin;

                    ; trigger OnValidate()
                    BEGIN
                        QBGlobalConf.MODIFY;
                    END;


                }

            }
            group("group18")
            {

                CaptionML = ENU = 'Modulos adicionales', ESP = 'Modulos adicionales';
                field("Quobuilding"; rec."Quobuilding")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("QW Withholding"; rec."QW Withholding")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Reestimates"; rec."Reestimates")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Rental Management"; rec."Rental Management")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Use Service Order"; rec."Use Service Order")
                {


                    ; trigger OnValidate()
                    BEGIN
                        SetEditable;
                        CurrPage.UPDATE;
                    END;


                }
                field("Is Test Company"; rec."Is Test Company")
                {

                    ToolTipML = ESP = 'Si se marca indica que estamos en una empresa de pruebas, lo que desactivar� los env�os al SII';
                }

            }
            group("group25")
            {

                CaptionML = ENU = 'QuoBuilding', ESP = 'Dimensiones';
                group("group26")
                {

                    CaptionML = ENU = 'QuoBuilding', ESP = 'Dimensiones';
                    field("Dimension for Quotes"; rec."Dimension for Quotes")
                    {

                    }
                    field("Dimension for CA Code"; rec."Dimension for CA Code")
                    {

                    }
                    field("Dimension for Jobs Code"; rec."Dimension for Jobs Code")
                    {

                    }
                    field("Dimension for Dpto Code"; rec."Dimension for Dpto Code")
                    {

                    }
                    field("Dimension for Reestim. Code"; rec."Dimension for Reestim. Code")
                    {

                    }
                    field("Dimension for JV Code"; rec."Dimension for JV Code")
                    {

                    }

                }
                group("group33")
                {

                    CaptionML = ESP = 'Valores dimensi�n por defecto';
                    field("Dim. Default Value for Quote"; rec."Dim. Default Value for Quote")
                    {

                        CaptionML = ENU = 'Job Dimension Default Value', ESP = 'Para Estudios';
                        ToolTipML = ESP = 'Al crear un nuevo proyecto operativo, usar� este valor de dimensi�n para la dimensi�n de Estudios';
                    }
                    field("Dim. Default Value for Job"; rec."Dim. Default Value for Job")
                    {

                        CaptionML = ENU = 'Job Dimension Default Value', ESP = 'Para Proyectos';
                        ToolTipML = ESP = 'Al crear un nuevo Estudio, usar� este valor de dimensi�n para la dimensi�n de Proyectos';
                    }

                }
                group("group36")
                {

                    CaptionML = ESP = 'Dimensi�n departamento';
                    field("Department Equal To Project"; rec."Department Equal To Project")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            SetDto;
                        END;


                    }
                    field("Value dimension for quote"; rec."Value dimension for quote")
                    {

                        ToolTipML = ESP = 'Indica si se traspasan autom�ticamente  los gastos de los estudios a los proyectos al crearlo';
                        Editable = edDimDpto;
                    }
                    field("Value dimension for job"; rec."Value dimension for job")
                    {

                        ToolTipML = ESP = 'Indica que Unidad de Obra de gastos indirectos ser� la que se emplee para pasar los gastos de un estudio al crear la obra relacionada';
                        Editable = edDimDpto;
                    }
                    field("Value dimension for structure"; rec."Value dimension for structure")
                    {

                        ToolTipML = ESP = 'Indica que Unidad de Obra de gastos indirectos ser� la que se emplee para pasar los gastos de un estudio al crear la obra relacionada';
                        Editable = edDimDpto;
                    }
                    field("Value dimension for location"; rec."Value dimension for location")
                    {

                    }

                }

            }
            group("group42")
            {

                CaptionML = ESP = 'Numeraci�n y valores';
                group("group43")
                {

                    CaptionML = ESP = 'Contadores';
                    field("Serie for Jobs"; rec."Serie for Jobs")
                    {

                    }
                    field("Serie for Offers"; rec."Serie for Offers")
                    {

                    }
                    field("Serie for Cost Database"; rec."Serie for Cost Database")
                    {

                    }
                    field("Serie for Measurement"; rec."Serie for Measurement")
                    {

                    }
                    field("Serie for Measurement Post"; rec."Serie for Measurement Post")
                    {

                    }
                    field("Serie for Reestimate"; rec."Serie for Reestimate")
                    {

                    }
                    field("Serie for Reestimate Post"; rec."Serie for Reestimate Post")
                    {

                    }
                    field("Serie for Indirect Part"; rec."Serie for Indirect Part")
                    {

                    }
                    field("Serie for Indirect Part Post"; rec."Serie for Indirect Part Post")
                    {

                    }
                    field("Serie for Record"; rec."Serie for Record")
                    {

                    }
                    field("Serie for Output Shipmen"; rec."Serie for Output Shipmen")
                    {

                    }
                    field("Serie for Stock Regularization"; rec."Serie for Stock Regularization")
                    {

                    }

                }
                group("group56")
                {

                    CaptionML = ENU = 'QuoBuilding', ESP = 'Financiero';
                    field("Budget for Jobs"; rec."Budget for Jobs")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            OnValidateJobsBudget;
                        END;


                    }
                    field("Budget for Quotes"; rec."Budget for Quotes")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            OnValidateQuotesBudget;
                        END;


                    }
                    field("Analysis View for Job"; rec."Analysis View for Job")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            OnValidateJobAnalytiViewCode;
                        END;


                    }
                    field("Analysis View for Quotes"; rec."Analysis View for Quotes")
                    {

                    }
                    field("Acc. Sched. Name for Job"; rec."Acc. Sched. Name for Job")
                    {

                    }

                }
                group("group62")
                {

                    CaptionML = ESP = 'Estudios y Obras';
                    field("% Generic Margin Sale Piecewor"; rec."% Generic Margin Sale Piecewor")
                    {

                    }
                    field("Initial Record Code"; rec."Initial Record Code")
                    {

                    }
                    field("Initial Budget Code"; rec."Initial Budget Code")
                    {

                    }
                    field("Quote Budget Code"; rec."Quote Budget Code")
                    {

                        ToolTipML = ESP = 'Si este campo est� relleno, al pasar un estudio a proyecto se crea un presupuesto adicional al mismo con este nombre y los datos del estudio.';
                    }
                    field("Initial Budget"; rec."Initial Budget")
                    {

                    }

                }
                group("group68")
                {

                    CaptionML = ESP = 'Grupo Registro';
                    field("Default Job Posting Group"; rec."Default Job Posting Group")
                    {

                        ToolTipML = ENU = 'Specifies the default posting group to be applied when you create a new job. This group is used whenever you create a job, but you can Rec.MODIFY the value on the job card.', ESP = 'Especifica el grupo de registro predeterminado que se va a aplicar al crear un proyecto nuevo. Este grupo se utiliza siempre que se crea un proyecto, pero puede modificar el valor en la ficha de proyecto.';
                        ApplicationArea = Jobs;
                    }

                }
                group("group70")
                {

                    CaptionML = ESP = 'Varios';
                    field("Create Location Equal To Proj."; rec."Create Location Equal To Proj.")
                    {

                    }
                    field("Skip Required Project"; rec."Skip Required Project")
                    {

                    }
                    field("Use Responsibility Center"; rec."Use Responsibility Center")
                    {

                    }

                }

            }
            group("Registro")
            {

                group("group75")
                {

                    CaptionML = ESP = 'Traspasos';
                    field("Serie for Transfers"; rec."Serie for Transfers")
                    {

                    }
                    field("Serie for Transfers Post"; rec."Serie for Transfers Post")
                    {

                    }
                    field("Transfers Account Expense"; rec."Transfers Account Expense")
                    {

                    }
                    field("Transfers Account Sales"; rec."Transfers Account Sales")
                    {

                    }

                }
                group("group80")
                {

                    CaptionML = ESP = 'Partes de Trabajo';
                    field("Serie for Work Sheet"; rec."Serie for Work Sheet")
                    {

                    }
                    field("Serie for Work Sheet Post"; rec."Serie for Work Sheet Post")
                    {

                    }
                    field("Default Calendar"; rec."Default Calendar")
                    {

                    }

                }
                group("group84")
                {

                    CaptionML = ESP = 'Diarios';
                    field("Jobs Book"; rec."Jobs Book")
                    {

                    }
                    field("Jobs Batch Book"; rec."Jobs Batch Book")
                    {

                    }
                    field("Periodic Expense Book"; rec."Periodic Expense Book")
                    {

                    }
                    field("Periodic Expense Batch Book"; rec."Periodic Expense Batch Book")
                    {

                    }
                    field("Expense Notes Book"; rec."Expense Notes Book")
                    {

                    }
                    field("Expense Notes Batch Book"; rec."Expense Notes Batch Book")
                    {

                    }
                    field("Delivery Note Book"; rec."Delivery Note Book")
                    {

                    }
                    field("Delivery Note Batch Book"; rec."Delivery Note Batch Book")
                    {

                    }

                }

            }
            group("Microsoft Project")
            {

                field("MSP Export Template"; rec."MSP Export Template")
                {


                    // ; trigger OnValidate()
                    // BEGIN
                    //     RequestFile;
                    // END;

                    // trigger OnAssistEdit()
                    // BEGIN
                    //     RequestFile;
                    // END;


                }

            }
            group("UTE")
            {

                field("Serie Integration Doc JV No."; rec."Serie Integration Doc JV No.")
                {

                }
                field("Posting Book Integration JV"; rec."Posting Book Integration JV")
                {

                }
                field("Batch Rec. integration JV"; rec."Batch Rec. integration JV")
                {

                }
                field("Close Batch Rec. JV"; rec."Close Batch Rec. JV")
                {

                }
                field("Bal. Account Regul. JV"; rec."Bal. Account Regul. JV")
                {

                }
                field("Close Account JV"; rec."Close Account JV")
                {

                }
                field("Close Bal. Account JV"; rec."Close Bal. Account JV")
                {

                }

            }
            group("group103")
            {

                CaptionML = ENU = 'Vendor evaluations', ESP = 'Garant�as';
                field("Guarantee Serial No."; rec."Guarantee Serial No.")
                {

                }
                field("Guarantee Analitical Concept"; rec."Guarantee Analitical Concept")
                {

                }
                field("Guarantee Piecework Unit"; rec."Guarantee Piecework Unit")
                {

                }
                field("Guarantee Piecework Unit Prov."; rec."Guarantee Piecework Unit Prov.")
                {

                }

            }
            group("group108")
            {

                CaptionML = ENU = 'Vendor evaluations', ESP = 'Calidad';
                group("group109")
                {

                    CaptionML = ESP = 'Certificados';
                    field("Use certificate control"; rec."Use certificate control")
                    {

                    }
                    field("Due Certificate Action"; rec."Due Certificate Action")
                    {

                    }

                }
                group("group112")
                {

                    CaptionML = ESP = 'Evaluaciones';
                    field("Evaluation Value"; rec."Evaluation Value")
                    {

                    }
                    field("Evaluation method"; rec."Evaluation method")
                    {

                    }

                }
                group("group115")
                {

                    CaptionML = ESP = 'Evaluaci�n: Nivel 1';
                    field("Evaluation score 1"; rec."Evaluation score 1")
                    {

                    }
                    field("Evaluation rating 1"; rec."Evaluation rating 1")
                    {

                    }

                }
                group("group118")
                {

                    CaptionML = ESP = 'Evaluaci�n: Nivel 2';
                    field("Evaluation score 2"; rec."Evaluation score 2")
                    {

                    }
                    field("Evaluation rating 2"; rec."Evaluation rating 2")
                    {

                    }

                }
                group("group121")
                {

                    CaptionML = ESP = 'Evaluaci�n: Nivel 3';
                    field("Evaluation score 3"; rec."Evaluation score 3")
                    {

                    }
                    field("Evaluation rating 3"; rec."Evaluation rating 3")
                    {

                    }

                }
                group("group124")
                {

                    CaptionML = ESP = 'Evaluaci�n: Nivel 4';
                    field("Evaluation score 4"; rec."Evaluation score 4")
                    {

                    }
                    field("Evaluation rating 4"; rec."Evaluation rating 4")
                    {

                    }

                }
                group("group127")
                {

                    CaptionML = ESP = 'Evaluaci�n: Nivel 5';
                    field("Evaluation score 5"; rec."Evaluation score 5")
                    {

                    }
                    field("Evaluation rating 5"; rec."Evaluation rating 5")
                    {

                    }

                }

            }
            group("group130")
            {

                CaptionML = ENU = 'General config', ESP = 'Configuraci�n General';
                group("group131")
                {

                    CaptionML = ENU = 'General config', ESP = 'Datos';
                    field("Ver en Costes Directos"; rec."Ver en Costes Directos")
                    {

                    }
                    field("Close month process"; rec."Close month process")
                    {

                    }
                    field("When Calculating Budget"; rec."When Calculating Budget")
                    {

                    }
                    field("When Calculating Analitical"; rec."When Calculating Analitical")
                    {

                    }
                    field("Day of the Period"; rec."Day of the Period")
                    {

                        ToolTipML = ESP = 'Cuando d�as de plazo hay para presentar documentos en el SII. Si es cero no se controla';
                    }
                    field("Days Warning Withholding"; rec."Days Warning Withholding")
                    {

                    }
                    field("Hours control"; rec."Hours control")
                    {

                    }
                    field("Use External Wookshet"; rec."Use External Wookshet")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            IF (rec."Use External Wookshet" <> rec."Use External Wookshet"::No) AND (rec."Use External Wookshet" <> xRec."Use External Wookshet") THEN
                                MESSAGE(Txt000);
                        END;


                    }
                    field("Auxiliary Location Code"; rec."Auxiliary Location Code")
                    {

                    }

                }
                group("group141")
                {

                    CaptionML = ENU = 'General config', ESP = 'Checks';
                    field("Not  AC obligatory in jobs"; rec."Not  AC obligatory in jobs")
                    {

                    }
                    field("CA in Stock Regularization"; rec."CA in Stock Regularization")
                    {

                        ToolTipML = ESP = 'Al marcar este check el sistema propondr� el valor configurado en Acopio a la columna "Concepto Anal�tico" desde el proceso de "Traer productos" de la ventana de REGULARIZACI�N DE STOCK.';
                    }
                    field("Use Aditional Code"; rec."Use Aditional Code")
                    {

                    }
                    field("Act.Price on Generate Contract"; rec."Act.Price on Generate Contract")
                    {

                    }
                    field("Mant. Contract Prices In Fact."; rec."Mant. Contract Prices In Fact.")
                    {

                    }
                    field("Use DCBP Aditional Fields"; rec."Use DCBP Aditional Fields")
                    {

                        ToolTipML = ESP = 'Si se ven los campos adicionales para el c�lculo de la cantidad de la U.O. en los descompuestos';
                    }
                    field("Job access control"; rec."Job access control")
                    {

                    }
                    field("Use Salesperson dimension"; rec."Use Salesperson dimension")
                    {

                    }
                    field("Series for Job"; rec."Series for Job")
                    {

                    }
                    field("Use Old Initial Budget"; rec."Use Old Initial Budget")
                    {

                        ToolTipML = ESP = 'Si no est� marcado se usa el dato del presupuesto inicial (opci�n preferente), si est� marcado se usan campos adicionales para ello (menos recomendado)';
                    }
                    field("Use Shipment type in Vendor"; rec."Use Shipment type in Vendor")
                    {

                        ToolTipML = ESP = 'Si se activa el movimiento de provisi�n/desprovisi�n del albar�n se efectua contra proveedor en lugar de contra cuenta';
                    }
                    field("Use WS for Reports"; rec."Use WS for Reports")
                    {

                    }
                    field("Use Date Budget Control"; rec."Use Date Budget Control")
                    {

                    }
                    field("Use Grouping"; rec."Use Grouping")
                    {

                        ToolTipML = ESP = 'Indica si se desea usar agrupacines de costes en las facturas de las certificaciones.';
                    }
                    field("Control Negative Target"; rec."Control Negative Target")
                    {

                    }
                    field("Payment Bank Mandatory"; rec."Payment Bank Mandatory")
                    {

                    }
                    field("Fiter Same Job Type"; rec."Fiter Same Job Type")
                    {

                        ToolTipML = ESP = 'Si se activa este check, por defecto se filtran que al buscar un proyecto en  compras sean del mismo tipo del actual (QB/RE/CECO)';
                    }

                }

            }
            group("group159")
            {

                CaptionML = ENU = 'Sales', ESP = 'Ventas';
                group("group160")
                {

                    CaptionML = ENU = 'Invoices', ESP = 'Facturas';
                    field("Sales Document Regiter Text"; rec."Sales Document Regiter Text")
                    {

                        ToolTipML = ESP = 'Si se deja en blanco usa el est�ndar de NAV, si no se puede usar  %1 para el tipo de documento, %2 para el Nro documento del proveedor/clientes, %3 para nombre del proveedor/ciente';
                    }
                    field("Use Sales Series"; rec."Use Sales Series")
                    {

                    }

                }
                group("group163")
                {

                    CaptionML = ENU = 'Internal Mail', ESP = 'Mail Interno';
                    field("Internal Shippind Sales Inv."; rec."Internal Shippind Sales Inv.")
                    {

                        ToolTipML = ESP = 'Este campo indica si se desea enviar un mail interno cuando se registre una factura de venta, si se realizar� el env�o de forma manual o autom�tica.';
                    }
                    field("Internal Shippind to Mail"; rec."Internal Shippind to Mail")
                    {

                        ToolTipML = ESP = 'Este campo indica si se desea enviar un mail interno cuando se registre una factura de venta, las direcciones de correo a donde se remiten (siempre se a�ade el usuario que registr� la factura)';
                    }
                    field("Internal Shippind Don't Show"; rec."Internal Shippind Don't Show")
                    {

                        ToolTipML = ESP = 'Este campo indica si no se desea mostrar el mensaje antes de proceder al env�o del mismo (si se muestra podr� modificarlo)';
                    }
                    field("Internal Shippind Don't Conf."; rec."Internal Shippind Don't Conf.")
                    {

                    }
                    field("Internal Shippind Inv. Layout"; rec."Internal Shippind Inv. Layout")
                    {

                        ToolTipML = ESP = 'Este campo indica si se desea enviar un mail interno cuando se registre una factura de venta, el dise�o del cuerpo del correo electr�nico que se emplear�.  Si se deja en blanco usar� un texto fijo.';
                    }
                    field("Internal Shippind Cr.M. Layout"; rec."Internal Shippind Cr.M. Layout")
                    {

                        ToolTipML = ESP = 'Este campo indica si se desea enviar un mail interno cuando se registre un abono de venta, el dise�o del cuerpo del correo electr�nico que se emplear�. Si se deja en blanco usar� un texto fijo.';
                    }
                    field("Internal Shipping Text 1"; rec."Internal Shipping Text 1")
                    {

                        ToolTipML = ESP = 'Si no se emplea el dise�o del cuerpo, esta ser� la primera l�nea a mostar. Se puede usar %1 para el tipo de documento, %2 para el n�mero del documento, %3 para el c�digo del cliente, %4 para el nombre del cliente, %5 para el usuario que ha registrado el documento, %6 para la empresa en que se ha registrado';
                    }
                    field("Internal Shipping Text 2"; rec."Internal Shipping Text 2")
                    {

                        ToolTipML = ESP = 'Si no se emplea el dise�o del cuerpo, esta ser� la segunda l�nea a mostar. Se puede usar %1 para el tipo de documento, %2 para el n�mero del documento, %3 para el c�digo del cliente, %4 para el nombre del cliente, %5 para el usuario que ha registrado el documento, %6 para la empresa en que se ha registrado';
                    }
                    field("Internal Shipping Text 3"; rec."Internal Shipping Text 3")
                    {

                        ToolTipML = ESP = 'Si no se emplea el dise�o del cuerpo, esta ser� la tercera l�nea a mostar. Se puede usar %1 para el tipo de documento, %2 para el n�mero del documento, %3 para el c�digo del cliente, %4 para el nombre del cliente, %5 para el usuario que ha registrado el documento, %6 para la empresa en que se ha registrado';
                    }

                }

            }
            group("group173")
            {

                CaptionML = ENU = 'Purchases', ESP = 'Compras';
                group("group174")
                {

                    CaptionML = ESP = 'Compras';
                    field("Purch. Document Regiter Text"; rec."Purch. Document Regiter Text")
                    {

                        ToolTipML = ESP = 'Si se deja en blanco usa el est�ndar de NAV, si no se puede usar  %1 para el tipo de documento, %2 para el Nro documento del proveedor/clientes, %3 para nombre del proveedor/ciente';
                    }
                    field("Vendor Amount Mandatory"; rec."Vendor Amount Mandatory")
                    {

                    }
                    field("Dif. Amount On"; rec."Dif. Amount On")
                    {

                    }
                    field("Max. Dif. Amount Invoice"; rec."Max. Dif. Amount Invoice")
                    {

                    }
                    field("Use Payment Phases"; rec."Use Payment Phases")
                    {

                        ToolTipML = ESP = 'Si se desea disponer de Fases de Pago en los documentos de compra (comparativos, pedidos, albaranes, facturas)';
                    }
                    field("Calc Due Date"; rec."Calc Due Date")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            IF (NOT (rec."Calc Due Date" = rec."Calc Due Date"::Reception)) THEN
                                rec."No. Days Calc Due Date" := 0;

                            SetEditable;
                        END;


                    }
                    field("No. Days Calc Due Date"; rec."No. Days Calc Due Date")
                    {

                        Enabled = edDiasVtos;
                    }
                    field("See Posting No"; rec."See Posting No")
                    {

                    }
                    field("QB Requires vendor approval"; rec."QB Requires vendor approval")
                    {

                    }
                    field("Comparatives by months"; rec."Comparatives by months")
                    {

                        ToolTipML = ESP = 'Si se permite desglosar por meses las l�neas de los comparativos al generar los contratos';
                    }

                }
                group("group185")
                {

                    CaptionML = ESP = 'Control de Contratos';
                    field("Use Contract Control"; rec."Use Contract Control")
                    {

                    }
                    field("k"; rec."k")
                    {

                    }
                    field("Contratos Importe"; rec."Contratos Importe")
                    {

                    }
                    field("Sin Contrato Importe"; rec."Sin Contrato Importe")
                    {

                    }

                }
                group("group190")
                {

                    CaptionML = ESP = 'Contratos Marco';
                    field("Blanket Purchase Multy-company"; rec."Blanket Purchase Multy-company")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }
                    field("Blanket Purchase Serie"; rec."Blanket Purchase Serie")
                    {

                        Enabled = enBlanket2;

                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }

                }

            }
            group("Personalizaciones")
            {

                group("group194")
                {

                    CaptionML = ESP = 'Divisas';
                    field("Use Currency in Jobs"; rec."Use Currency in Jobs")
                    {

                    }
                    field("Adjust Exchange Rate Piecework"; rec."Adjust Exchange Rate Piecework")
                    {

                        ToolTipML = ESP = 'A que Unidad de Obra se imputan las diferencias de cambio de divisas';
                    }
                    field("Adjust Exchange Rate A.C."; rec."Adjust Exchange Rate A.C.")
                    {

                        ToolTipML = ESP = 'A que Concepto Anal�tico se imputan las diferencias de cambio de divisas';
                    }

                }
                group("group198")
                {

                    CaptionML = ESP = 'Traspasar gastos de estudio a proyecto';
                    field("Quote to Job Expenses"; rec."Quote to Job Expenses")
                    {

                        CaptionML = ESP = 'Autom�ticamente';
                        ToolTipML = ESP = 'Indica si se traspasan autom�ticamente  los gastos de los estudios a los proyectos al crearlo';
                    }
                    field("Quote to Job Piecework"; rec."Quote to Job Piecework")
                    {

                        CaptionML = ESP = 'A que U.O.';
                        ToolTipML = ESP = 'Indica que Unidad de Obra de gastos indirectos ser� la que se emplee para pasar los gastos de un estudio al crear la obra relacionada';
                    }

                }
                group("group201")
                {

                    CaptionML = ESP = 'Referentes de clientes';
                    field("Use Referents"; rec."Use Referents")
                    {

                    }
                    field("Referents Dimension"; rec."Referents Dimension")
                    {

                    }

                }
                group("group204")
                {

                    CaptionML = ESP = 'Obra en Curso';
                    field("Use Customer in WIP"; rec."Use Customer in WIP")
                    {

                    }
                    field("Calculate WIP by periods"; rec."Calculate WIP by periods")
                    {

                    }

                }
                group("group207")
                {

                    CaptionML = ESP = 'Confirming y Factoring';
                    field("Use Confirming Lines"; rec."Use Confirming Lines")
                    {

                    }
                    field("Use Factoring Lines"; rec."Use Factoring Lines")
                    {

                    }

                }
                group("group210")
                {

                    CaptionML = ENU = 'Block Reestimates', ESP = 'Bloquear Reestimaciones';
                    field("Block Reestimations"; rec."Block Reestimations")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Allow in January"; rec."Allow in January")
                    {

                        Editable = edMonths;
                    }
                    field("Allow in February"; rec."Allow in February")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in March"; rec."Allow in March")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in April"; rec."Allow in April")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in May"; rec."Allow in May")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in June"; rec."Allow in June")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in July"; rec."Allow in July")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in August"; rec."Allow in August")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in September"; rec."Allow in September")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in October"; rec."Allow in October")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in November"; rec."Allow in November")
                    {

                        Enabled = edMonths;
                    }
                    field("Allow in December"; rec."Allow in December")
                    {

                        Enabled = edMonths;
                    }

                }

            }
            group("Pedidos de Servicio")
            {

                Visible = enServiceOrders;
                field("Serie for Service Order"; rec."Serie for Service Order")
                {

                    Visible = enServiceOrders;
                }
                field("Serie for Service Order Post"; rec."Serie for Service Order Post")
                {

                    Visible = enServiceOrders;
                }

            }
            group("Almacén Central")
            {

                field("Ceded Control"; rec."Ceded Control")
                {

                }
                field("Coste prod. prestados recibido"; rec."Coste prod. prestados recibido")
                {

                    ToolTipML = ESP = 'Indica de d�nde tomar� el coste del producto prestado cuando se hace la entrada en el almac�n principal. Este coste se actualizar� con el coste real en el momento de la devoluci�n del producto prestado.';
                }
                field("Periodo Calc. Precio Compra"; rec."Periodo Calc. Precio Compra")
                {

                    ToolTipML = ESP = 'Horizonte temporal tomado desde la fecha de trabajo, desde el cual se calcular� el coste medio de compra. Debe ser un valor negativo (-1A, -6M,...)';
                }
                field("Serie for Receipt/Transfer"; rec."Serie for Receipt/Transfer")
                {

                }
                field("Serie for Receipt/Transfer Pos"; rec."Serie for Receipt/Transfer Pos")
                {

                }
                field("Receipt Management Journal"; rec."Receipt Management Journal")
                {

                }
                field("Receipt Management Section"; rec."Receipt Management Section")
                {

                }
                field("Job revaluation Jnl. Template"; rec."Job revaluation Jnl. Template")
                {

                }
                field("Job revaluation Jnl. Batch"; rec."Job revaluation Jnl. Batch")
                {

                }

            }
            group("group237")
            {

                CaptionML = ENU = 'Modulos adicionales', ESP = 'Informaci�n Adicional';
                field("Company Code"; rec."Company Code")
                {

                }
                field("Commercial Register"; rec."Commercial Register")
                {

                }
                field("Commercial Register Sheet"; rec."Commercial Register Sheet")
                {

                }
                field("Company Representative"; rec."Company Representative")
                {

                }
                field("Representative Adress"; rec."Representative Adress")
                {

                }
                field("VAT Registration No. Represen."; rec."VAT Registration No. Represen.")
                {

                }
                field("Establishment Date"; rec."Establishment Date")
                {

                }
                group("group245")
                {

                    CaptionML = ENU = 'Notary', ESP = 'Notario';
                    field("Notary"; rec."Notary")
                    {

                    }
                    field("Notarial Protocol"; rec."Notarial Protocol")
                    {

                    }
                    field("Notary City"; rec."Notary City")
                    {

                    }

                }

            }
            group("group249")
            {

                CaptionML = ENU = 'Modulos adicionales', ESP = 'Logos Adicionales';
                field("QB_Text1"; QB_Text1)
                {

                    CaptionML = ESP = 'Texto en Factura';
                    MultiLine = true;

                    ; trigger OnValidate()
                    BEGIN
                        rec.QB_SetText1(QB_Text1);
                        CurrPage.UPDATE;
                    END;


                }
                field("Logo1"; rec."Logo1")
                {

                    CaptionML = ENU = 'Picture', ESP = 'Logotipo de Calidad';
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ESP = 'Crear Configuraci�n';
                Image = Setup;

                trigger OnAction()
                BEGIN
                    COMMIT;
                    QuobuildingInitialize.RUN;
                END;


            }
            action("action2")
            {
                CaptionML = ESP = 'Revisar Proyectos';
                Image = ChangeDimensions;

                trigger OnAction()
                BEGIN
                    COMMIT;
                    QuobuildingInitialize.UpdateJobsDimension;
                END;


            }
            action("action3")
            {
                CaptionML = ESP = 'Crear Web Services BI';
                Image = Web;

                trigger OnAction()
                BEGIN
                    COMMIT;
                    CreateWSBI();
                END;


            }
            action("action4")
            {
                CaptionML = ESP = 'Actualizar Versi�n';
                Image = UpdateShipment;


                trigger OnAction()
                BEGIN
                    UpdateVersion;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }


    trigger OnOpenPage()
    VAR
        Version: Text;
        NeedChange: Boolean;
    BEGIN
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
        Rec.GET; //Actualizar los cambios

        enAdmin := (FunctionQB.IsQBAdmin) AND (FunctionQB.IsClient('CEI'));

        //Conf. Global
        QBGlobalConf.GetGlobalConf('');
        QBGlobalConf.NeedChangeVersion(Version, NeedChange);
        IF (NeedChange) THEN BEGIN
            MESSAGE('Debe actualziar la versi�n del programa');
            //UpdateVersion;
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetDto;
        Rec.VALIDATE("Calc Due Date");
        SetEditable;

        //JAV 21/02/22: - QB 1.10.21 Si estamos con licencia de CEI no hacemos nada, si no pongo la del cliente
        IF (FunctionQB.GetVoiceFromClient('CEI') <> DELCHR(SERIALNUMBER)) THEN BEGIN
            QBGlobalConf."License No." := DELCHR(SERIALNUMBER);
            QBGlobalConf.MODIFY;
        END;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        QB_Text1 := rec.QB_GetText1();
        SetEditable;
    END;



    var
        QBGlobalConf: Record 7206985;
        rQBVersionChanges: Record 7206921;
        QBVersionChanges: Page 7207301;
        FunctionQB: Codeunit 7207272;
        QuobuildingInitialize: Codeunit 7207287;
        edDimDpto: Boolean;
        inicial: Integer;
        Nombre: Code[20];
        edDiasVtos: Boolean;
        enBlanket2: Boolean;
        Txt000: TextConst ESP = 'Recuerde configurar adecuadamente los registros de trabajadores externos para su correcto fucnionamiento';
        QB_Text1: Text;
        enServiceOrders: Boolean;
        enAdmin: Boolean;
        edMonths: Boolean;

    LOCAL procedure SetEditable();
    begin
        edDiasVtos := (rec."Calc Due Date" = rec."Calc Due Date"::Reception);
        enBlanket2 := (rec."Blanket Purchase Multy-company");
        edMonths := rec."Block Reestimations";
        enServiceOrders := rec."Use Service Order";
    end;

    procedure RequestFile();
    var
        // FileMgt: Codeunit "File Management";
        // ClientFileName: Text;
        Text002: TextConst ENU = 'Open', ESP = 'Abrir';
    begin
        // ClientFileName := FileMgt.OpenFileDialog(Text002, '', 'Fich. Microsoft Project (*.mpt)|*.mpt|Todos fich. (*.*)|*.*');
        // rec."MSP Export Template" := FileMgt.GetDirectoryName(ClientFileName) + '\' + FileMgt.GetFileName(ClientFileName);
    end;

    LOCAL procedure SetDto();
    begin
        edDimDpto := (not rec."Department Equal To Project");
        if (rec."Department Equal To Project") then begin
            rec."Value dimension for quote" := '';
            rec."Value dimension for job" := '';
        end;
    end;

    LOCAL procedure CreateWSBI();
    var
        tmpWS: Record 9900 TEMPORARY;
        // Object: Record 2000000001;
        txt: Text;
        i: Integer;
        txtError: Text;
    begin
        //Crear los Web Services de BI. Primero los est�ndar
        // CreateOne(tmpWS, tmpWS."Object Type"::Query, 256, 'QBI_GrupoDimension');
        // CreateOne(tmpWS, tmpWS."Object Type"::Query, 260, 'QBI_DimensionSetEntries');

        // //JAV 06/04/22: - QB 1.10.32 Se cambia la forma de generar los WebServices, ahora se usan los VersionList de los objetos que es mas c�modo y no requiere modiciar esta page cada vez

        // //Buscamos todos los objetos que contangan WSName= en su versionList, lo que haya despu�s ser� el nombre que le daremos al WebService
        // txtError := '';
        // Object.RESET;
        // Object.SETFILTER(Type, '%1|%2|%3', Object.Type::Query, Object.Type::Page, Object.Type::Codeunit);  //Solo se pueden incluir estos tipos en los WS
        // Object.SETFILTER("Version List", '*WSName*');
        // if (Object.FINDSET(FALSE)) then
        //     repeat
        //         if (Object.Compiled) then begin
        //             i := STRPOS(Object."Version List", 'WSName=') + STRLEN('WSName=');
        //             txt := COPYSTR(Object."Version List", i);
        //             CASE Object.Type OF
        //                 Object.Type::Query:
        //                     CreateOne(tmpWS, tmpWS."Object Type"::Query, Object.ID, txt);
        //                 Object.Type::Page:
        //                     CreateOne(tmpWS, tmpWS."Object Type"::Page, Object.ID, txt);
        //                 Object.Type::Codeunit:
        //                     CreateOne(tmpWS, tmpWS."Object Type"::Codeunit, Object.ID, txt);
        //             end;
        //         end ELSE
        //             txtError += STRSUBSTNO('   - %1 %2\', Object.Type, Object.ID);
        //     until (Object.NEXT = 0);

        // // tmpWS.PopulateTable;
        // if (txtError <> '') then
        //     MESSAGE('Finalizado. No se incluyen objectos no compilados:\' + txtError)
        // ELSE
        //     MESSAGE('Finalizado');

        /*{----------------------------------------------------------------------------------------------
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50099, 'QBI_DimPredeterminadas');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50098, 'QBI_MovBanco');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50097, 'QBI_AbonoCompra');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50096, 'QBI_FacCompra');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50095, 'QBI_MovValor');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50094, 'QBI_AlbCompra');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50093, 'QBI_ForecastDataAmount');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50092, 'QBI_Retenciones');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50091, 'QBI_UnidadesVenta');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50090, 'QBI_DimensionValor');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50089, 'QBI_MovimientosProyectos');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50088, 'QBI_HistAbonoVenta');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50087, 'QBI_HistFacturaVenta');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50086, 'QBI_MovimientosRetenciones');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50085, 'QBI_Cobros');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50084, 'QBI_Certificaciones');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50083, 'QBI_Vendor');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50082, 'QBI_ProduccionOrigen');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50081, 'QBI_Expedientes');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50080, 'QBI_Job');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50079, 'QBI_FactCompraLinea');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50078, 'QBI_AbonoCompraLinea');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50077, 'QBI_AlbaranDevolucionLinea');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50076, 'QBI_AutorizadosObra');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50075, 'QBI_Usuarios');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50074, 'QBI_Cargos');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50073, 'QBI_MovProducto');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50072, 'QBI_MovGrupoDim');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50071, 'QBI_CarteraDoc');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50070, 'QBI_UnidadesObra');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50069, 'QBI_Acopios');
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50068, 'QBI_Aprobaciones');            //JAV 22/11/21: - QB 1.09.29 Se a�aden las aprobaciones
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50067, 'QBI_PieceworkSetup');          //JAV 03/02/22: - QB 1.10.15 Se a�ade la conf.
        CreateOne(tmpWS, tmpWS."Object Type"::Query, 50066, 'QBI_CertificationPlanning');   //JAV 07/02/22: - QB 1.10.18 Se a�ade la planfificaci�n de certificaciones

        //CPA 23/03/22: QB 1.10.27 Nuevas p�ginas para los Web Service del BI

        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207200, 'QBI_CustomerList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207201, 'QBI_VendorList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207202, 'QBI_ItemPurchList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207203, 'QBI_GLAccountList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207204, 'QBI_JobsList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207205, 'QBI_SalesList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207206, 'QBI_ItemSalesList_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207207, 'QBI_GLBudgetedAmt_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207208, 'QBI_TopCustOverview_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207209, 'QBI_SalesHdrCust_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207210, 'QBI_CustItemLedgEnt_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207211, 'QBI_CustLedgEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207212, 'QBI_VendLedgEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207213, 'QBI_SalesHdrVendor_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207214, 'QBI_VendorItemLedgerEntr_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207215, 'QBI_TopCustomerOverview_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207216, 'QBI_SalesDashboard_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207217, 'QBI_ItemSalesByCustomer_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207218, 'QBI_ItemSalesandProfit_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207219, 'QBI_SalesOrdersbySalespers_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207220, 'QBI_SalesOpportunities_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207221, 'QBI_SegmentLines_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207222, 'QBI_CFForecastEntryDims_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207223, 'QBI_GLEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207224, 'QBI_CustLedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207225, 'QBI_VendorLedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207226, 'QBI_BankAccLedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207227, 'QBI_ItemLedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207228, 'QBI_ValueEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207229, 'QBI_FALedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207230, 'QBI_JobLedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207231, 'QBI_ResLedgerEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207232, 'QBI_GLBudgetEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207233, 'QBI_DimensionValue_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207234, 'QBI_Retenciones_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207235, 'QBI_AlbCompraLinea_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207236, 'QBI_FactCompra_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207237, 'QBI_AbonoCompra_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207238, 'QBI_MovBanco_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207239, 'QBI_ValueEntry_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207240, 'QBI_ForecastDataAmount_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207241, 'QBI_UnidadesVenta_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207242, 'QBI_MovimientosProyectos_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207243, 'QBI_HistoricoAbonoVenta_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207244, 'QBI_HistoricoFactventa_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207245, 'QBI_MovimientosRetenciones_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207246, 'QBI_Cobros_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207247, 'QBI_Certificaciones_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207248, 'QBI_ProduccionAorigen_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207249, 'QBI_Expedientes_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207250, 'QBI_Job_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207251, 'QBI_DimensionSetEntries_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207252, 'QBI_CobrosV2_Page');
        //CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207253, 'QBI_CobrosV2SubPage');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207254, 'QBI_DimPreterminadas_Page');
        //CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207255, 'QBI_CobrosV2SubSubPage');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207256, 'QBI_HistoricoLinAbVenta_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207257, 'QBI_HistLinFactVenta_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207258, 'QBI_HistLinCertitfication_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207259, 'QBI_DataPieceworkForProd_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207260, 'QBI_UnidadesObrav2_Page');
        CreateOne(tmpWS, tmpWS."Object Type"::Page, 7207262, 'QBI_LiqPagos');
        ------------------------------------------------------------------------------------------------- }*/
    end;

    LOCAL procedure CreateOne(var tmpWS: Record 9900; pType: Option; pNumber: Integer; pName: Text);
    var
        TenantWebService: Record 2000000168;
    // WebService: Record 2000000076;
    begin
        // if (not WebService.GET(pType, pName)) and (not TenantWebService.GET(pType, pName)) then begin
        //     tmpWS.INIT;
        //     tmpWS."Object Type" := pType;
        //     tmpWS."Service Name" := pName;
        //     tmpWS."Object ID" := pNumber;
        //     tmpWS.Published := TRUE;
        //     tmpWS."All Tenants" := TRUE;
        //     tmpWS.INSERT(TRUE);
        // end;
    end;

    LOCAL procedure OnValidateJobsBudget();
    var
        GLBudgetName: Record 95;
        GLBudgetEntry: Record 96;
        Text000: TextConst ENU = 'You can not change the name of the Jobs  Budget parameter', ESP = 'No se puede modificar el nombre del par metro Presupuesto para Proyecto';
        Text001: TextConst ENU = 'You want to change the name of the Jobs  Budget parameter', ESP = 'Desea modificar el nombre del par metro Presupuesto para Proyecto';
        FunctionQB: Codeunit 7207272;
        Text002: TextConst ENU = 'Dimension 1 of the Budget Name Accounting table must contain a dimension setting parameter %1', ESP = 'La dimensi¢n 1 de la tabla Nombre Presupuesto Contabilidad debe contener un par metro de configuraci¢n de dimensi¢n %1';
        Text003: TextConst ENU = 'Dimension 2 of the Budget Name Accounting table must contain a dimension setting parameter %1', ESP = 'La dimensi¢n 2 de la tabla Nombre Presupuesto Contabilidad debe contener un par metro de configuraci¢n de dimensi¢n %1';
        Job: Record 167;
    begin
        // Si se intenta modificar el par metro se comprueba que no est� bloqueado, se pide confirmaci�n, se verifica y se modifica en todos los proyectos
        if FunctionQB.AccessToQuobuilding then begin
            if (rec."Budget for Jobs" <> xRec."Budget for Jobs") and (xRec."Budget for Jobs" <> '') then begin
                GLBudgetName.GET(rec."Budget for Jobs");
                GLBudgetEntry.RESET;
                GLBudgetEntry.SETCURRENTKEY(GLBudgetEntry."Entry No.");
                if GLBudgetEntry.FINDFIRST then begin
                    if not GLBudgetName.Blocked then
                        ERROR(Text000);
                end ELSE begin
                    if (not CONFIRM(Text001, FALSE)) then
                        ERROR('');
                end;
            end;

            GLBudgetName.GET(rec."Budget for Jobs");
            if GLBudgetName."Budget Dimension 1 Code" <> FunctionQB.ReturnDimJobs then
                ERROR(Text002, FunctionQB.ReturnDimJobs);

            //JAV 19/12/21: - QB 1.10.09 No validar si no hay reestimaciones
            if rec.Reestimates then
                if GLBudgetName."Budget Dimension 2 Code" <> FunctionQB.ReturnDimReest then
                    ERROR(Text003, FunctionQB.ReturnDimReest);

            //Actualizo los presupuestos en los proyectos
            Job.RESET;
            Job.SETRANGE("Card Type", Job."Card Type"::"Proyecto operativo");
            Job.SETFILTER("Jobs Budget Code", '<>%1', rec."Budget for Jobs");
            if Job.FINDSET(TRUE) then begin
                repeat
                    Job."Jobs Budget Code" := rec."Budget for Jobs";
                    Job."Job Analysis View Code" := rec."Analysis View for Job";
                    Job.MODIFY(TRUE);
                until Job.NEXT = 0;
            end;
        end;
    end;

    LOCAL procedure OnValidateQuotesBudget();
    var
        GLBudgetName: Record 95;
        GLBudgetEntry: Record 96;
        Text000: TextConst ENU = 'You can not change the name of the Jobs  Budget parameter', ESP = 'No se puede modificar el nombre del par metro Presupuesto para Estudios';
        Text001: TextConst ENU = 'You want to change the name of the Jobs  Budget parameter', ESP = 'Desea modificar el nombre del par metro Presupuesto para Estudios';
        FunctionQB: Codeunit 7207272;
        Text002: TextConst ENU = 'Dimension 1 of the Budget Name Accounting table must contain a dimension setting parameter %1', ESP = 'La dimensi¢n 1 de la tabla Nombre Presupuesto Contabilidad debe contener un par metro de configuraci¢n de dimensi¢n %1';
        Text003: TextConst ENU = 'Dimension 2 of the Budget Name Accounting table must contain a dimension setting parameter %1', ESP = 'La dimensi¢n 2 de la tabla Nombre Presupuesto Contabilidad debe contener un par metro de configuraci¢n de dimensi¢n %1';
        Job: Record 167;
    begin
        // Si se intenta modificar el par metro se comprueba que no est� bloqueado, se pide confirmaci�n, se verifica y se modifica en todos los estudios
        if FunctionQB.AccessToQuobuilding then begin
            if (rec."Budget for Quotes" <> xRec."Budget for Quotes") and (xRec."Budget for Quotes" <> '') then begin
                GLBudgetName.GET(rec."Budget for Quotes");

                GLBudgetEntry.RESET;
                GLBudgetEntry.SETCURRENTKEY(GLBudgetEntry."Entry No.");
                if GLBudgetEntry.FINDFIRST then begin
                    if not GLBudgetName.Blocked then
                        ERROR(Text000);
                end ELSE begin
                    if (not CONFIRM(Text001, FALSE)) then
                        ERROR('');
                end;
            end;

            GLBudgetName.GET(rec."Budget for Quotes");
            if GLBudgetName."Budget Dimension 1 Code" <> FunctionQB.ReturnDimQuote then
                ERROR(Text002, FunctionQB.ReturnDimQuote);
            if GLBudgetName."Budget Dimension 2 Code" <> FunctionQB.ReturnDimReest then
                ERROR(Text003, FunctionQB.ReturnDimReest);

            //Actualizo los presupuestos en los proyectos
            Job.RESET;
            Job.SETRANGE("Card Type", Job."Card Type"::Estudio);
            Job.SETFILTER("Jobs Budget Code", '<>%1', rec."Budget for Quotes");
            if Job.FINDSET(TRUE) then begin
                repeat
                    Job."Jobs Budget Code" := rec."Budget for Quotes";
                    Job.MODIFY(TRUE);
                until Job.NEXT = 0;
            end;
        end;
    end;

    LOCAL procedure OnValidateJobAnalytiViewCode();
    var
        FunctionQB: Codeunit 7207272;
        AnalysisViewEntry: Record 365;
        AnalysisView: Record 363;
    begin
        // Si hay mov. an lisis vista no se puede cambiar
        if FunctionQB.AccessToQuobuilding then begin
            if (rec."Analysis View for Job" <> xRec."Analysis View for Job") then begin
                AnalysisViewEntry.RESET;
                AnalysisViewEntry.SETRANGE(AnalysisViewEntry."Analysis View Code", rec."Analysis View for Job");
            end;
            AnalysisView.GET(rec."Analysis View for Job");
        end;
    end;

    LOCAL procedure UpdateVersion();
    var
        // QBDataVersionChange: Report 7207530;
        QBVersionChanges: Record 7206921;
    begin
        COMMIT;
        // CLEAR(QBDataVersionChange);
        // QBDataVersionChange.RUN;

        QBVersionChanges.AddAll;        //Refrescar la tabla de cambios
        rQBVersionChanges.UpdateConf;   //Actualizar las versiones de los m�dulos
    end;

    // begin
    /*{
      QMD 18/08/10: - Q3254 Sacar nuevo campo rec."Use Responsibility Center"
      JAV 03/04/19: - Nuevo par�metro con la pantallas se ver�n por defecto en la page de costes directos
      JAV 19/01/19: - QBA-01 Se a�ade el campo "Dimensi�n Cliente" para Andrasa
      JAV 03/05/19: - Mejoras en la configuraci�n general para las particularidades de los clientes
      JAV 13/05/19: - Nuevo par�metro para hacer obligatorio el vendedor asociado al cliente 50080 "Salesperson mandatory"
      JAV 25/07/19: - Se a�aden los campos de configuraciones opcionales y se reestructura la pantalla
      JAV 10/08/19: - Se a�ade el campo 50088 rec."Close month process" que indica si al cerrar el mes se debe copiar o reestimar
      JAV 23/08/19: - Se a�ade los campos de dimensi�on por defecto para estudio y proyecto, editables seg�n sea "deparatamento igual a proyecto"
      JAV 22/09/19: - Se a�ade el campo "Guarantee Piecework Unit Prov." para las provisiones de gastos de las garant�as
      JAV 03/10/19: - Se eliminan los campos de reports pues se puede se reemplaza por el selector de informes
      JAV 09/10/19: - Se a�ade el campo rec."Quote Budget Code"
      JAV 12/10/19: - Se a�ade el campo rec."Initial Budget" que indica que presupuesto ser� el inicial el de Estudio o el Master
      PGM 24/09/20: - QB 1.06.15 Se saca el campo rec."Auxiliary Location Code"
      JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
      DGG 21/06/21: - Q13152 Se a�ade campo "Usar Agrupaciones en U.O Venta" para gestion de certificaciones de obras.
      Q13643 MMS 12/07/21 Se a�aden campos 140 �Control Negative Target�, de tipo bool, 141 �Block Reestimations�, de tipo bool
      Q13643 MMS 13/07/21 Se a�aden campos 142 a 153 �Allow in January� hasta �Allow in December�, booleanos con caption �Permitir en Enero� hasta �Permitir en Diciembre�
      Q13643 MMS 14/07/21 Mejoras en la ficha de objetivos del proyecto.
      JAV 15/09/21: - QB 1.09.17 Se a�ade el Web  Service para la Query "QBI_UnidadesObra"
      DGG 08/10/11: - QB 1.09.21 Se a�ade grupo "Almac�n Central"
      DGG 23/11/21: - QRE 1.00.00 15647 Se muestra campo rec."QB Requires vendor approval"
      JAV 04/04/22: - QB 1.10.31 Se eliminan campos de aprobaciones que van a la nueva tabla de configuraci�n de aprobaciones
      JAV 10/04/22: - QB 1.10.33 Se elimina el campo 50084 "Location Negative", en su lugar se usar� el campo del est�ndar de conf. almac�n
      JAV 11/04/22: - QB 1.10.35 Se a�ade el campo 5 "Serie for Activables Expenses" para los gastos activables.
                                 Se eliminan lo campos para anticipos, se pasan a la p�gina propia
      QBU17147 CSM 11/05/22 - New Field "C.Anal�t.=Acopio en Reg.Stock"  Si est� marcado en el proceso de Regularizaci�n stock informar�
                              la columna "Concepto Analitico" con el valor configurado en el Almac�n de acopio del proyecto.
      JAV 16/06/22: - QB 1.10.50 Se a�ade la columna rec."Fiter Same Job Type" Si se activa este check, por defecto se filtran que al buscar un proyecto en  compras sean del mismo tipo del actual (QB/RE/CECO)
      CPA 06/06/22: - Q17138 Funcionalidd de productos prestados: A�adidos los campos "Job revaluation Jnl. Template" y "Job revaluation Jnl. Batch" dentro del apartado traspasos
                             JAV Trasladados a la parte de Almac�n Central que tiene mas sentido
      JAV 04/10/22: - QB 1.12.00 Se eliminan campos de gastos activables, se pasan a RE y QRE setup
    }*///end
}







