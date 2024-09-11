table 7206916 "QB Cue"
{


    CaptionML = ENU = 'QuoBuilding Cue', ESP = 'Pila QuoBuilding';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key', ESP = 'Clave primaria';


        }
        field(10; "JobFilter"; Code[250])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'JobFilter', ESP = 'Filtro proyecto';
            Description = 'QB3651';
            Editable = false;


        }
        field(11; "TipoOfertaFilter"; Code[250])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'TipoOfertaFilter', ESP = 'Filtro tipo oferta';
            Description = 'QB3651';


        }
        field(12; "ResponsComercialFilter"; Code[250])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'ResponsComercialFilter', ESP = 'ResponsComercialFilter';
            Description = 'QB3651';


        }
        field(13; "MyActivityFilter"; Code[250])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'MyActivityFilter', ESP = 'MyActivityFilter';
            Description = 'QB3651';
            Editable = false;


        }
        field(20; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';
            Editable = false;


        }
        field(21; "Date Filter2"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter2', ESP = 'Filtro fecha2';
            Editable = false;


        }
        field(22; "User ID Filter"; Code[50])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'User ID Filter', ESP = 'Filtro de id. de usuario';


        }
        field(23; "Pending Tasks"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("User Task" WHERE("Assigned To User Name" = FIELD("User ID Filter"),
                                                                                        "Percent Complete" = FILTER(<> 100)));
            CaptionML = ENU = 'Pending Tasks', ESP = 'Tareas pendientes';


        }
        field(24; "Due Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Due Date Filter', ESP = 'Filtro fecha vto.';
            Editable = false;


        }
        field(25; "Overdue Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Overdue Date Filter', ESP = 'Filtro fechas vencidas';


        }
        field(30; "Hitos facturacion vencidos"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Invoice Milestone" WHERE("Estimated Date" = FIELD("Date Filter2"),
                                                                                                "Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Hitos facturacion vencidos', ESP = 'Hitos facturaci�n vencidos';
            Description = 'QB3651';
            Editable = false;


        }
        field(36; "Mediciones"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measurement Header" WHERE("Document Type" = CONST("Measuring"),
                                                                                                 "Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Mediciones', ESP = 'Mediciones';
            Description = 'QB3651';
            Editable = false;


        }
        field(37; "Pedidos de Compra"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Order"),
                                                                                              "QB Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Pedidos de Compra', ESP = 'Pedidos de Compra';
            Description = 'QB3651';


        }
        field(38; "Facturas de Compra"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Invoice"),
                                                                                              "QB Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Facturas de Compra', ESP = 'Facturas de Compra';
            Description = 'QB3651';


        }
        field(39; "Albaranes Salida"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Output Shipment Header" WHERE("Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Albaranes Salida', ESP = 'Albaranes Salida';
            Description = 'QB3651';


        }
        field(40; "Partes de trabajo"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Worksheet Header qb" WHERE("No. Resource /Job" = FIELD("JobFilter"),
                                                                                                  "Sheet Type" = CONST("By Job")));
            CaptionML = ENU = 'Partes de trabajo', ESP = 'Partes de trabajo';
            Description = 'QB3651';


        }
        field(42; "Comparativos Ofertas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Comparative Quote Header" WHERE("Job No." = FIELD("JobFilter"),
                                                                                                       "Activity Filter" = FIELD(FILTER("MyActivityFilter"))));
            CaptionML = ENU = 'Comparativos Ofertas', ESP = 'Comparativos Ofertas';
            Description = 'QB3651';
            Editable = false;


        }
        field(43; "Necesidades"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Purchase Journal Line" WHERE("Job No." = FIELD("JobFilter"),
                                                                                                    "Activity Code" = FIELD("MyActivityFilter")));
            CaptionML = ENU = 'Necesidades', ESP = 'Necesidades';
            Description = 'QB3651';


        }
        field(44; "Relaciones Valoradas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Prod. Measure Header" WHERE("Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Relaciones Valoradas', ESP = 'Relaciones Valoradas';
            Description = 'QB3651';


        }
        field(45; "Recepciones"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Header Job Reception" WHERE("Job No." = FIELD("JobFilter"),
                                                                                                   "Posted" = CONST(false)));
            CaptionML = ENU = 'Recepciones', ESP = 'Recepciones';
            Description = 'QB3651';


        }
        field(46; "Retenciones BE vencidas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Withholding Movements" WHERE("Withholding Type" = CONST("G.E"),
                                                                                                    "Posting Date" = FIELD("Date Filter2"),
                                                                                                    "Type" = CONST("Vendor"),
                                                                                                    "Open" = CONST(true)));
            CaptionML = ENU = 'Retenciones BE vencidas', ESP = 'Retenciones BE vencidas';
            Description = 'QB3651';


        }
        field(47; "Imputacion Costes Indirectos"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Costsheet Header" WHERE("Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Imputacion Costes Indirectos', ESP = 'Imputaci�n Costes Indirectos';
            Description = 'QB3651';


        }
        field(48; "Regularizac. Almacenes a Proy."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Withholding Movements" WHERE("Open" = CONST(true),
                                                                                                    "Due Date" = FIELD("Date Filter2")));
            CaptionML = ENU = 'Regularizac. Almacenes a Proy.', ESP = 'Regularizac. Almacenes a Proy.';
            Description = 'QB3651';


        }
        field(49; "Mis Ofertas Pendientes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio"),
                                                                                "Rejection Reason" = CONST(''),
                                                                                "Quote Status" = CONST("Pending"),
                                                                                "Quote Type" = FIELD("TipoOfertaFilter"),
                                                                                "Income Statement Responsible" = FIELD("ResponsComercialFilter")));
            CaptionML = ENU = 'Mis Ofertas Pendientes', ESP = 'Mis Ofertas Pendientes';
            Description = 'QB3651';


        }
        field(50; "Otras Ofertas Pendientes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio"),
                                                                                "Rejection Reason" = CONST(''),
                                                                                "Quote Status" = CONST("Pending")));
            Description = 'QB3651';


        }
        field(51; "Versiones Oferta vivas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio"),
                                                                                "Rejection Reason" = FILTER(<> ''),
                                                                                "Quote Status" = CONST("Pending"),
                                                                                "Quote Type" = FIELD("TipoOfertaFilter"),
                                                                                "Presented Version" = CONST('NO')));
            CaptionML = ENU = 'Versiones Oferta vivas', ESP = 'Versiones Oferta vivas';
            Description = 'QB3651';


        }
        field(52; "Proyectos ptes. de crear"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio"),
                                                                                "Quote Status" = CONST("Accepted"),
                                                                                "Generated Job" = FILTER(= '')));
            CaptionML = ENU = 'Proyectos ptes. de crear', ESP = 'Proyectos ptes. de crear';
            Description = 'QB3651';


        }
        field(53; "Mis Oportunidades Abiertas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Opportunity WHERE("Status" = CONST("In Progress"),
                                                                                        "Salesperson Code" = FIELD("ResponsComercialFilter")));
            CaptionML = ENU = 'Mis Oportunidades Abiertas', ESP = 'Mis Oportunidades Abiertas';
            Description = 'QB3651';


        }
        field(54; "Mis tareas Pendientes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("To-do" WHERE("Status" = FILTER('In Progress' | 'Waiting'),
                                                                                  "Salesperson Code" = FIELD("ResponsComercialFilter")));
            CaptionML = ENU = 'Mis tareas Pendientes', ESP = 'Mis tareas Pendientes';
            Description = 'QB3651';


        }
        field(55; "Mis tareas No iniciadas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("To-do" WHERE("Status" = FILTER("Not Started"),
                                                                                  "Salesperson Code" = FIELD("ResponsComercialFilter")));
            CaptionML = ENU = 'Mis tareas No iniciadas', ESP = 'Mis tareas No iniciadas';
            Description = 'QB3651';


        }
        field(56; "Pedidos abiertos"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Order"),
                                                                                              "Status" = CONST("Open"),
                                                                                              "QB Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Pedidos abiertos', ESP = 'Pedidos abiertos';
            Description = 'QB3651';


        }
        field(57; "Payments Due Today"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Vendor Ledger Entry" WHERE("Document Type" = FILTER('Invoice' | 'Credit Memo'),
                                                                                                  "Due Date" = FIELD("Date Filter2"),
                                                                                                  "Open" = CONST(true)));
            CaptionML = ENU = 'Payments Due Today', ESP = 'Pagos vencidos';
            Description = 'QB3651';


        }
        field(58; "Vendors - Payment on Hold"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Vendor WHERE("Blocked" = FILTER("Payment")));
            CaptionML = ENU = 'Vendors - Payment on Hold', ESP = 'Proveedores - Pago suspendido';
            Description = 'QB3651';


        }
        field(59; "Payable Documents"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Cartera Doc." WHERE("Type" = CONST("Payable"),
                                                                                           "Bill Gr./Pmt. Order No." = CONST()));
            CaptionML = ENU = 'Payable Documents', ESP = 'Pagos de compras pendientes';
            Description = 'QB3651';


        }
        field(60; "Datos Evaluación proveedor"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Withholding Movements" WHERE("Open" = CONST(true),
                                                                                                    "Due Date" = FIELD("Date Filter2")));
            CaptionML = ENU = 'Datos Evaluación proveedor', ESP = 'Datos Evaluación proveedor';
            Description = 'QB3651';


        }
        field(100; "My Quotes in Process"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio"),
                                                                                "Presented Version" = CONST('')));
            CaptionML = ENU = 'My Quotes in Process', ESP = 'Mis Estudios en Curso';
            Editable = false;


        }
        field(101; "My Quotes Presented"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio"),
                                                                                "Presented Version" = FILTER(<> '')));
            CaptionML = ESP = 'Mis Estudios Presentados';
            Editable = false;


        }
        field(102; "My Quotes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Card Type" = CONST("Estudio")));
            CaptionML = ESP = 'Mis Estudios';
            Editable = false;


        }
        field(120; "My pending approvals"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Approver ID" = FIELD(FILTER("User ID Filter")),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'My pending approvals', ESP = 'Mis aprobaciones pendientes';
            Description = 'APROBACIONES JAV 12/03/20: - Movimientos de aprobaci�n pendientes del usuario';
            Editable = false;


        }
        field(121; "Movements pending approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Sender ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'Movements pending approval', ESP = 'Approv. en proceso';
            Description = 'APROBACIONES QB 1.0 JAV 12/03/20: - Movimientos de aprobaci�n de registros lanzados por el usuario pendientes';
            Editable = false;


        }
        field(122; "ApPen Contracts and Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(38),
                                                                                             "Document Type" = CONST("Order"),
                                                                                             "Approver ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'Contracts and Orders', ESP = 'Contratos y Pedidos';
            Description = 'APROBACIONES';
            Editable = false;


        }
        field(123; "ApPen Partes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(7207290),
                                                                                             "QB Document Type" = CONST("Worksheet"),
                                                                                             "Approver ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'Partes', ESP = 'Partes';
            Description = 'APROBACIONES';
            Editable = false;


        }
        field(124; "ApPen Facturas Venta"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(36),
                                                                                             "Document Type" = CONST("Invoice"),
                                                                                             "Approver ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'Facturas Venta', ESP = 'Facturas Venta';
            Description = 'APROBACIONES';
            Editable = false;


        }
        field(125; "ApPen Facturas Compra"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(38),
                                                                                             "Document Type" = CONST("Invoice"),
                                                                                             "Approver ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'Facturas Compra', ESP = 'Facturas Compra';
            Description = 'APROBACIONES';
            Editable = false;


        }
        field(127; "ApPen Comparativos"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(7207412),
                                                                                             "Approver ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open"),
                                                                                             "QB Document Type" = CONST("Comparative")));
            CaptionML = ENU = 'Comparativos', ESP = 'Comparativos';
            Description = 'QB3651';
            Editable = false;


        }
        field(128; "ApPen Cartera"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(7000002),
                                                                                             "Approver ID" = FIELD("User ID Filter"),
                                                                                             "Status" = CONST("Open")));
            CaptionML = ENU = 'Approvals Pending Cartera', ESP = 'Aprobaciones Pendientes Cartera';
            Description = 'Q12266';
            Editable = false;


        }
        field(129; "Comparativos Ptes Gen."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Comparative Quote Header" WHERE("OLD_Approval Situation" = CONST("Approved"),
                                                                                                       "Generated Contract Doc No." = FILTER('')));
            CaptionML = ENU = 'Contratos Ptes. Generar', ESP = 'Contratos Ptes. Generar';
            Description = 'QB3651';
            Editable = false;


        }
        field(140; "Facturas Venta"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST("Invoice"),
                                                                                           "QB Job No." = FIELD("JobFilter")));
            CaptionML = ENU = 'Facturas pdtes', ESP = 'Facturas Vta. pdtes';
            Description = 'APROBACIONES';
            Editable = false;


        }
        field(10700; "Missing SII Entries"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Missing SII Entries', ESP = 'Movs. SII que faltan';


        }
        field(10701; "Days Since Last SII Check"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Days Since Last SII Check', ESP = 'D�as desde la �ltima comprobaci�n de SII';


        }
        field(50001; "Pagares por emitir"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Cartera Doc." WHERE("Type" = CONST("Payable"),
                                                                                           "Bill Gr./Pmt. Order No." = CONST(),
                                                                                           "Payment Method Code" = FIELD("FP Pagares por emitir")));
            CaptionML = ENU = 'Payable Documents', ESP = 'Pagar�s por emitir';
            Description = 'PERTEO';


        }
        field(50002; "Transferencias ptes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Cartera Doc." WHERE("Type" = CONST("Payable"),
                                                                                           "Bill Gr./Pmt. Order No." = CONST(),
                                                                                           "Payment Method Code" = FIELD("FP Transferencias ptes")));
            Description = 'PERTEO';


        }
        field(50003; "Pagares Anulados"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Cartera Doc." WHERE("Type" = CONST("Payable"),
                                                                                           "Bill Gr./Pmt. Order No." = CONST(),
                                                                                           "Payment Method Code" = FIELD("FP Pagares Anulados")));
            CaptionML = ESP = 'Pagar�s Anulados';
            Description = 'PERTEO';


        }
        field(50011; "FP Pagares por emitir"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'PERTEO';


        }
        field(50012; "FP Transferencias ptes"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'PERTEO';


        }
        field(50013; "FP Pagares Anulados"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'PERTEO';


        }
    }
    keys
    {
        key(key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    /*begin
    {
      JAV 19/03/19: - Se revisan los campos de Quobuilding para que funcionen correctamente
      JAV 01/06/19: - Se revisan los campos de ofertas y se a�aden dos nuevos
      JAV 12/03/20: - Se elimina el campo "UserIDFilter" y se a�ade el campo "Approvals Pending"
    }
    end.
  */
}







