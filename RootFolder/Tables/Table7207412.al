table 7207412 "Comparative Quote Header"
{


    CaptionML = ENU = 'Comparative Quote Header', ESP = 'Cabecera comparativo oferta';
    LookupPageID = "Comparative Quote";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';

            trigger OnValidate();
            BEGIN
                //Verfica que pueda usar el proyecto
                IF NOT FunctionQB.CanUserAccessJob("Job No.") THEN
                    ERROR(Text000, "Job No.");


                //JAV 05/06/22: - Para permitir multiproyecto, no controlar esto
                // //JAV 26/03/19: - No dejar cambiar el proyecto si ya hay l�neas
                // IF (xRec."Job No." <> '') AND (xRec."Job No." <> "Job No.") THEN BEGIN 
                //  ComparativeQuoteLines.RESET;
                //  ComparativeQuoteLines.SETRANGE("Quote No.","No.");
                //  IF (NOT ComparativeQuoteLines.ISEMPTY) THEN
                //    ERROR(Text009);
                // END;
                // //JAV fin

                GetJob("Job No.");
                Description := Job.Description;
                "Location Code" := Job."Job Location";

                //JAV 05/06/22: - QB 1.10.47 No cambiar el proyecto en las l�neas
                NoChangeLines := TRUE;

                CreateDim();

                //JAV 30/05/22: - QB 1.10.45 Cambios en validates para mejorar el manejo del registro. Esto no tiene sentido aqu�
                //RE16204-LCG-280122-INI
                //CrearNewComparativeLine();
                //RE16204-LCG-280122-FIN
            END;

            trigger OnLookup();
            VAR
                //                                                               JobNo@1100286000 :
                JobNo: Code[20];
            BEGIN
                JobNo := Rec."Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funci�n
                IF (FunctionQB.LookupUserJobs(JobNo)) THEN
                    VALIDATE("Job No.", JobNo);
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                //JAV 30/05/22: - QB 1.10.45 Cambios en validates para mejorar el manejo del registro. Esto no tiene sentido
                // IF "No." <> xRec."No." THEN BEGIN 
                //  ERROR(Text002);
                // END;
            END;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Description = 'Descripci�n oferta';


        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            END;


        }
        field(5; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            END;


        }
        field(6; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Reestimation"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(7; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(8; "OLD_Posting No. Series"; Code[10])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';
            Description = '### ELIMINAR ### no se usa';


        }
        field(9; "OLD_Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';
            Description = '### ELIMINAR ### no se usa';


        }
        field(10; "Comparative Type"; Option)
        {
            OptionMembers = "Item","Resource","Mixed";
            InitValue = "Mixed";


            CaptionML = ENU = 'Comparative Type', ESP = 'Tipo comparativo';
            OptionCaptionML = ENU = 'Item,Resource,Mixed', ESP = 'Producto,Recurso,Mixto';


            trigger OnValidate();
            BEGIN
                //JAV 30/05/22: - QB 1.10.45 Cambios en validates para mejorar el manejo del registro. Se a�ade el tipo mixto
                IF ExistLinesDocument THEN
                    ERROR(Text001);
            END;


        }
        field(12; "Area Activity"; Option)
        {
            OptionMembers = "Local","Autonomous","National";
            CaptionML = ENU = 'Area Activity', ESP = 'Ambito actividad';
            OptionCaptionML = ENU = 'Local,Autonomous,National', ESP = 'Local,Auton�mico,Nacional';



        }
        field(13; "Comparative Date"; Date)
        {
            CaptionML = ENU = 'Comparative Date', ESP = 'Fecha comparativo';


        }
        field(14; "Selected Vendor"; Code[20])
        {
            TableRelation = "Vendor";


            CaptionML = ENU = 'Selected Vendor', ESP = 'Proveedor seleccionado';
            Editable = false;

            trigger OnValidate();
            BEGIN
                CreateDim();
            END;


        }
        field(15; "OLD_Contract No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER('Quote' | 'Order'));
            CaptionML = ENU = 'Contract No.', ESP = 'N� contrato';
            Description = '### ELIMINAR ### no se usa';


        }
        field(16; "OLD_Contract Date"; Date)
        {
            CaptionML = ENU = 'Contract Date', ESP = 'Fecha contrato';
            Description = '### ELIMINAR ### no se usa';


        }
        field(17; "Location Code"; Code[20])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Location Code', ESP = 'C�d. Almac�n';


        }
        field(18; "Activity Filter"; Code[250])
        {
            TableRelation = "Activity QB";
            ValidateTableRelation = false;
            CaptionML = ENU = 'Activity Filter', ESP = 'Filtro actividad';


        }
        field(19; "Amount Purchase"; Decimal)
        {
            CaptionML = ENU = 'Import Purchase', ESP = 'Importe compra';
            Description = 'QB 1.08.08: JAV 09/02/21 Importe del comparativo con vendedor seleccionado';
            Editable = false;


        }
        field(20; "Comparative To"; Option)
        {
            OptionMembers = "Job","Location";
            CaptionML = ENU = 'Comparative To', ESP = 'Comparativo contra';
            OptionCaptionML = ENU = 'Job,Location', ESP = 'Proyecto,Almac�n';



        }
        field(22; "Purchaser Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";


            CaptionML = ENU = 'Purchaser Code', ESP = 'C�d. comprador';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';

            trigger OnValidate();
            VAR
                //                                                                 ApprovalEntry@1001 :
                ApprovalEntry: Record 454;
            BEGIN
                ApprovalEntry.SETRANGE("Table ID", DATABASE::"Comparative Quote Header");
                ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Quote);
                ApprovalEntry.SETRANGE("Document No.", "No.");
                ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected);
                IF NOT ApprovalEntry.ISEMPTY THEN
                    ERROR(Text008, FIELDCAPTION("Purchaser Code"));
            END;


        }
        field(25; "Contact Selectd No."; Code[20])
        {
            TableRelation = "Contact";
            CaptionML = ENU = 'Contact Selectd No.', ESP = 'N� contacto seleccionado';
            Editable = false;


        }
        field(26; "Selection Made"; Boolean)
        {
            CaptionML = ENU = 'Selection Made', ESP = 'Selecci�n realizada';
            Editable = false;


        }
        field(30; "Payment Terms Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Conditions Data"."Payment Terms Code" WHERE("Quote Code" = FIELD("No."),
                                                                                                                           "Vendor No." = FIELD("Selected Vendor")));

            TableRelation = "Payment Terms";
            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';
            Description = 'JAV 11/09/19: - T�rminos de pago seleccionados';
            Editable = false;


        }
        field(31; "Payment Method Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Conditions Data"."Payment Method Code" WHERE("Quote Code" = FIELD("No."),
                                                                                                                            "Vendor No." = FIELD("Selected Vendor")));

            TableRelation = "Payment Method";
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';
            Description = 'JAV 11/09/19: - Forma de pago seleccionada';
            Editable = false;


        }
        field(32; "Payment Phases"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Conditions Data"."Payment Phases" WHERE("Quote Code" = FIELD("No."),
                                                                                                                       "Vendor No." = FIELD("Selected Vendor")));

            TableRelation = "QB Payments Phases";


            CaptionML = ESP = 'Fases de Pago';
            Description = 'QB 1.06 - JAV 06/07/20: - Si el pago se hacer por fases de pago';
            Editable = false;

            trigger OnValidate();
            BEGIN
                IF ("Payment Phases" <> '') THEN BEGIN
                    "Payment Method Code" := '';
                    "Payment Terms Code" := '';
                END ELSE BEGIN
                    IF Vendor.GET("Selected Vendor") THEN BEGIN
                        IF ("Payment Method Code" = '') THEN
                            "Payment Method Code" := Vendor."Payment Method Code";
                        IF ("Payment Terms Code" = '') THEN
                            "Payment Terms Code" := Vendor."Payment Terms Code";
                    END;
                END;
            END;


        }
        field(40; "Generate Type"; Option)
        {
            OptionMembers = "Contract","Extension";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo a generar';
            OptionCaptionML = ENU = 'Contract, Extension', ESP = 'Contrato,Ampliaci�n';

            Description = 'QB 1.08.08: JAV 08/02/21 Tipo (contrato o ampliaci�n)';


        }
        field(41; "Main Contract Doc Type"; Option)
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Contrato. Tipo de documento';
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';

            Description = 'QB 1.08.08: - JAV 07/02/21 Contrato: Tipo de Documento a ampliar';
            Editable = false;


        }
        field(42; "Main Contract Doc No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER('Order' | 'Blanket Order'),
                                                                                              "Buy-from Vendor No." = FIELD("Selected Vendor"),
                                                                                              "QB Job No." = FIELD("Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Main contract', ESP = 'Contrato principal';
            Description = 'QB 1.08.08: - JAV 07/02/21 Contrato: N� del Documento a ampliar';

            trigger OnValidate();
            BEGIN
                IF ("Main Contract Doc No." <> '') THEN BEGIN
                    IF (PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, "Main Contract Doc No.")) THEN
                        /*To be tested*/
                        //"Main Contract Doc Type" := PurchaseHeader."Document Type"
                        "Main Contract Doc Type" := ConvertDocumentTypeToOption(PurchaseHeader."Document Type")
                    ELSE IF (PurchaseHeader.GET(PurchaseHeader."Document Type"::"Blanket Order", "Main Contract Doc No.")) THEN
                        //"Main Contract Doc Type" := PurchaseHeader."Document Type"
                        "Main Contract Doc Type" := ConvertDocumentTypeToOption(PurchaseHeader."Document Type")
                    ELSE
                        ERROR('Documento no encontrado');
                END;
            END;

            trigger OnLookup();
            BEGIN
                PurchaseHeader.RESET;
                PurchaseHeader.SETFILTER("Document Type", '%1|%2', PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Blanket Order");
                PurchaseHeader.SETRANGE("Buy-from Vendor No.", "Selected Vendor");
                PurchaseHeader.SETRANGE("QB Job No.", "Job No.");

                CLEAR(PurchaseList);
                PurchaseList.SETTABLEVIEW(PurchaseHeader);
                PurchaseList.LOOKUPMODE(TRUE);
                IF (PurchaseList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                    PurchaseList.GETRECORD(PurchaseHeader);
                    /*To be Tested*/
                    //"Main Contract Doc Type" := PurchaseHeader."Document Type"
                    "Main Contract Doc Type" := ConvertDocumentTypeToOption(PurchaseHeader."Document Type");
                    "Main Contract Doc No." := PurchaseHeader."No.";
                END;
            END;


        }
        field(43; "Generated Contract Doc Type"; Enum "Purchase Document Type")
        {
            //OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Contrato. Tipo de documento';
            //OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';

            Description = 'QB 1.08.08: - JAV 07/02/21 Contrato: Tipo de Documento generado';
            Editable = false;


        }
        field(44; "Generated Contract Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Contrato Generado. Nro.';
            Description = 'QB 1.08.08: JAV 08/02/21 Nro del documento de compra generado';
            Editable = false;


        }
        field(45; "Generated Contract Ext No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Extensi�n';
            Description = 'QB 1.08.08: JAV 08/02/21 Nro de la ampliaci�n del contrato';
            Editable = false;


        }
        field(46; "Generated Contract Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Order Date" WHERE("Document Type" = FIELD("Generated Contract Doc Type"),
                                                                                                            "No." = FIELD("Generated Contract Doc No.")));
            CaptionML = ENU = 'Contract Date', ESP = 'Fecha contrato';
            Editable = false;


        }
        field(50; "Selected Version No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Selected Version No.', ESP = 'N� versi�n seleccionada';
            BlankZero = true;
            Description = 'Q13150';
            Editable = false;


        }
        field(51; "Requirements date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Requirements date', ESP = 'Fecha de necesidad';
            Description = 'QB 1.10.08  JAV 15/12/21 - [TT] Fecha de necesidad, cuando pase al pedido ser� la fecha de recepci�n esperada';

            trigger OnValidate();
            BEGIN
                IF (Rec."Requirements date" <> 0D) AND (Rec."Requirements date" <> xRec."Requirements date") THEN BEGIN
                    ComparativeQuoteLines.RESET;
                    ComparativeQuoteLines.SETRANGE("Quote No.", Rec."No.");
                    ComparativeQuoteLines.SETFILTER("Requirements date", '<>%1', Rec."Requirements date");
                    IF (NOT ComparativeQuoteLines.ISEMPTY) THEN
                        IF CONFIRM('�Desea cambiar la fecha de necesidad en todas las l�neas?', TRUE) THEN
                            ComparativeQuoteLines.MODIFYALL("Requirements date", Rec."Requirements date");
                END;
            END;


        }
        field(52; "Generate for months"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Generar por meses';
            MinValue = 0;
            Description = 'QB 1.10.08  JAV 15/12/21 - [TT] Si se generar� una l�nea del pedido en tantos meses como cantidad se indique aqu�';


        }
        field(55; "Total Generated Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount" WHERE("Document No." = FIELD("Generated Contract Doc No.")));
            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe Generado';
            Description = 'QB 1.00 - JAV 14/10/19 Importe del documento generado';
            Editable = false;


        }
        field(60; "Comparative Status"; Option)
        {
            OptionMembers = "InProcess","Selected","Approved","Generated","Closed";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado';
            OptionCaptionML = ENU = 'In process,Vendor Selected,Approved,Generated,Closed', ESP = 'En proceso,Proveedor Seleccionado,Aprobado,Generado,Cerrado';

            Editable = false;


        }
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00- JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(121; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '### ELIMINAR ### no se usa, pero de momento se queda por Obralia';
            Editable = false;


        }
        field(122; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '### ELIMINAR ### no se usa, pero de momento se queda por Obralia';
            Editable = false;


        }
        field(123; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '### ELIMINAR ### no se usa, pero de momento se queda por Obralia';


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(500; "K sobre"; Option)
        {
            OptionMembers = " ","Venta","Coste";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = '" ,Sales price,Cost Price"', ESP = '" ,Precio de Venta,Precio de Coste"';

            Description = 'JAV 26/03/19: - Guardarse sobre que precios se ha calculado la K';
            Editable = false;


        }
        field(1002; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. Divisa';
            Description = 'DIVISAS';


        }
        field(1003; "Currency Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Date', ESP = 'Fecha Divisa';
            Description = 'DIVISAS';


        }
        field(1004; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor Divisa';
            Description = 'DIVISAS';


        }
        field(50000; "Contrac Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Contrato" WHERE("Contrato" = FIELD("Generated Contract Doc No."),
                                                                                                                 "Origen" = CONST("Contrato")));


            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe Contrato';
            Description = 'QBA 09/05/19 JAV Importe del contrato mas sus ampliaciones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                VerControlContrato;
            END;


        }
        field(50001; "Contrac Amount Max"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Maximo" WHERE("Contrato" = FIELD("Generated Contract Doc No."),
                                                                                                               "Origen" = CONST("Contrato")));


            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe M�ximo';
            Description = 'QBA 09/05/19 JAV Importe m�ximo del contrato mas sus ampliaciones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                VerControlContrato;
            END;


        }
        field(50002; "Contrac Amount in al"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Albaran" WHERE("Contrato" = FIELD("Generated Contract Doc No."),
                                                                                                                "Origen" = CONST("Contrato")));


            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe en Albaranes';
            Description = 'QBA 09/05/19 JAV Importe en albaranes registrados pendientes de liquidar';
            Editable = false;

            trigger OnLookup();
            BEGIN
                VerControlContrato;
            END;


        }
        field(50003; "Contrac Amount in fac"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Factura/abono" WHERE("Contrato" = FIELD("Generated Contract Doc No."),
                                                                                                                      "Origen" = CONST("Contrato")));


            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe en Facturas';
            Description = 'QBA 09/05/19 JAV Importe en facturas registradas';
            Editable = false;

            trigger OnLookup();
            BEGIN
                VerControlContrato;
            END;


        }
        field(50004; "Contrac Amount in extensions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Ampliaciones" WHERE("Contrato" = FIELD("Generated Contract Doc No."),
                                                                                                                     "Origen" = CONST("Contrato")));


            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe Ampliaciones';
            Description = 'QBA 09/05/19 JAV Importe en ampliaciones de factura';
            Editable = false;

            trigger OnLookup();
            BEGIN
                VerControlContrato;
            END;


        }
        field(50005; "Contrac Amount available"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Pendiente" WHERE("Contrato" = FIELD("Generated Contract Doc No."),
                                                                                                                  "Origen" = CONST("Contrato")));


            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe Disponible';
            Description = 'QBA 09/05/19 JAV Importe disponible del contrato';
            Editable = false;

            trigger OnLookup();
            BEGIN
                VerControlContrato;
            END;


        }
        field(7207299; "Obralia Entry"; Integer)
        {
            TableRelation = "Obralia Log Entry";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Obralia User ID', ESP = 'Obralia';
            Description = 'QB 1.05.06 - JAV 23/07/20 : - Entrada en el registro de Obralia';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 ObraliaLogEntry@1100286000 :
                ObraliaLogEntry: Record 7206904;
                //                                                                 PurchasesPayablesSetup@1100286001 :
                PurchasesPayablesSetup: Record 312;
            BEGIN
                ObraliaLogEntry.GET("Obralia Entry");
                PurchasesPayablesSetup.GET;

                IF (ObraliaLogEntry.IsSemaphorGreen) AND ("OLD_Approval Coment" = Text004) THEN BEGIN
                    VALIDATE("OLD_Approval Situation", Rec."OLD_Approval Situation"::Pending);
                    "OLD_Approval Coment" := '';
                END;

                IF (ObraliaLogEntry.IsSemaphorRed) THEN BEGIN
                    VALIDATE("OLD_Approval Situation", Rec."OLD_Approval Situation"::Rejected);
                    "OLD_Approval Coment" := Text004;
                END;

                MODIFY;
            END;


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("Comparative"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(7207600; "K"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'K', ESP = 'K';
            Description = 'QB5988';
            Editable = false;


        }
        field(7238210; "QB Budget item"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QRE15411';

            trigger OnValidate();
            BEGIN
                //JAV 30/05/22: - QB 1.10.45 Cambios en validates para mejorar el manejo del registro. Primero se guarda
                //                           Luego se crea la l�nea desde la CU en lugar de poner c�digo aqu�.
                //                           Y se recupera el registro que ha cambiado desde otro proceso

                MODIFY;

                //RE16204-LCG-280122-INI
                QPRPageSubscriber.CrearNewComparativeLine(Rec);
                //RE16204-LCG-280122-FIN

                Rec.GET(Rec."No.");
            END;


        }
        field(7238211; "QB Comp Value Qty.  Purc. Line"; Option)
        {
            OptionMembers = "Quantity","Amount";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Value Qty. to  Purc. Line', ESP = 'Cant Valor a Lin. Ped.';
            OptionCaptionML = ENU = 'Quantity,Amount', ESP = 'Cantidad,Importe';

            Description = 'QRE 16539 07/03/22: Valor a llevar al campo Cantidad desde el comparativo al pedido';


        }
        field(7238212; "QB User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';
            Description = 'QRE 17046';
            Editable = false;

            trigger OnLookup();
            VAR
                //                                                               UserMgt@1000 :
                UserMgt: Codeunit "User Management 1";
            BEGIN
                UserMgt.LookupUserID("QB User ID");
            END;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            ;
        }
        key(key2; "Job No.", "Generated Contract Doc No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Job@7001100 :
        Job: Record 167;
        //       Text000@1100286003 :
        Text000: TextConst ESP = 'No tiene permisos para acceder al proyecto %1';
        //       Text001@7001104 :
        Text001: TextConst ENU = 'You can not change the type if there are lines', ESP = '"No puede modificar el tipo si existen l�neas "';
        //       Text002@7001101 :
        Text002: TextConst ENU = 'Can not assign an Quote number manually', ESP = 'No se puede asignar un N� de oferta de forma manual';
        //       PurchSetup@7001102 :
        PurchSetup: Record 312;
        //       ComparativeQuoteHeader@1100286013 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@1100286012 :
        ComparativeQuoteLines: Record 7207413;
        //       QBCommentLine@7001108 :
        QBCommentLine: Record 7207270;
        //       PurchaseHeader@1100286005 :
        PurchaseHeader: Record 38;
        //       PurchaseLine@1100286007 :
        PurchaseLine: Record 39;
        //       Vendor@1100286001 :
        Vendor: Record 23;
        //       VendorConditionsData@7001110 :
        VendorConditionsData: Record 7207414;
        //       DataPricesVendor@7001109 :
        DataPricesVendor: Record 7207415;
        //       OtherVendorConditions@7001111 :
        OtherVendorConditions: Record 7207416;
        //       DataCostByPiecework@1100286014 :
        DataCostByPiecework: Record 7207387;
        //       NoSeriesMgt@7001103 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       Text003@7001113 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text004@1100286004 :
        Text004: TextConst ESP = 'Rechazado por Obralia';
        //       ApprovalsMgmt@7001112 :
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //       FunctionQB@1100286002 :
        FunctionQB: Codeunit 7207272;
        //       Text005@1100286009 :
        Text005: TextConst ESP = 'El documento no se puede eliminar porque tiene l�neas con cantidad recibida.';
        //       ControlContratos@1100286010 :
        ControlContratos: Codeunit 7206907;
        //       QPRPageSubscriber@1100286015 :
        QPRPageSubscriber: Codeunit 7238190;
        //       PurchaseList@1100286006 :
        PurchaseList: Page 53;
        //       Text007@1100286011 :
        Text007: TextConst ENU = 'You can not change the Activity Code if there are lines', ESP = '"No puede modificar el C�d.Actividad si existen l�neas "';
        //       Text008@1100286008 :
        Text008: TextConst ENU = 'You must cancel the approval process if you wish to change the %1.', ESP = 'Debe cancelar el proceso de aprobaci�n si desea cambiar el %1.';
        //       Text009@1100286000 :
        Text009: TextConst ESP = 'No puede cambiar el proyecto mientras tenga l�neas.';
        //       NoChangeLines@1100286016 :
        NoChangeLines: Boolean;



    trigger OnInsert();
    var
        //                JobNo@1100286000 :
        JobNo: Text;
    begin
        PurchSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Comparative Date", "No.", "No. Series");
        end;

        "Comparative Date" := WORKDATE;
        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                VALIDATE("Job No.", GETRANGEMIN("Job No."));

        //Si entro en la tabla desde proyecto, heredo de forma autom�tica el proyecto desde el que vengo.
        //JAV 15/12/21: - QB 1.07.11 Solo lo fijamos si el filtro es �nico
        FILTERGROUP(2);
        JobNo := GETFILTER("Job No.");
        if (HASFILTER and (JobNo <> '')) then
            if (STRLEN(JobNo) <= MAXSTRLEN(Job."No.")) then
                if (Job.GET(JobNo)) then
                    VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);

        //-16539
        "QB Comp Value Qty.  Purc. Line" := PurchSetup."QB Comp Value Qty.  Purc. Line";
        //+16539

        //-17046
        "QB User ID" := USERID;
        //+17046
    end;

    trigger OnModify();
    begin
        //TESTFIELD("Activity Filter");
    end;

    trigger OnDelete();
    begin
        ComparativeQuoteLines.LOCKTABLE;
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", "No.");
        ComparativeQuoteLines.DELETEALL;

        QBCommentLine.RESET;
        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;

        VendorConditionsData.SETRANGE(VendorConditionsData."Quote Code", "No.");
        VendorConditionsData.DELETEALL;

        DataPricesVendor.SETRANGE(DataPricesVendor."Quote Code", "No.");
        DataPricesVendor.DELETEALL;

        OtherVendorConditions.SETRANGE(OtherVendorConditions."Quote Code", "No.");
        OtherVendorConditions.DELETEALL;

        ApprovalsMgmt.DeleteApprovalEntries(Rec.RECORDID);
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
        TESTFIELD("Activity Filter");
    end;


    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Purchase Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;


    // LOCAL procedure GetJob (JobNo@1000 :
    LOCAL procedure GetJob(JobNo: Code[20])
    begin
        if JobNo <> Job."No." then
            Job.GET(JobNo);
    end;

    procedure CreateDim()
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       DimMgt@7001101 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       OldDimSetID@7001100 :
        OldDimSetID: Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        TableID[1] := DATABASE::Job;
        No[1] := Rec."Job No.";
        TableID[2] := DATABASE::Vendor;
        No[2] := Rec."Selected Vendor";
        TableID[3] := DATABASE::"Salesperson/Purchaser";
        No[3] := Rec."Purchaser Code";

        SourceCodeSetup.GET;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[3], No[3]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Comparative Quote", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistLinesDocument then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    LOCAL procedure TestNoSeries(): Boolean;
    begin
        PurchSetup.TESTFIELD(PurchSetup."Comparative Quotes No. Series");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        exit(PurchSetup."Comparative Quotes No. Series");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        //       DimMgt@7001101 :
        DimMgt: Codeunit "DimensionManagement";
        //       OldDimSetID@7001100 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLinesDocument then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ExistLinesDocument(): Boolean;
    begin
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", "No.");
        if ComparativeQuoteLines.ISEMPTY then
            exit(FALSE);
        exit(TRUE);
    end;

    procedure ShowDocDim()
    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLinesDocument then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       DimMgt@7001102 :
        DimMgt: Codeunit "DimensionManagement";
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
        //       Text001@7001100 :
        Text001: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \\ �Desea actualizar las l�neas?';
        //       OldJob@1100286000 :
        OldJob: Code[20];
    begin
        //JAV 05/06/22: - QB 1.10.47 No cambiar el proyecto en las l�neas
        if (NoChangeLines) then begin
            NoChangeLines := FALSE;
            exit;
        end;


        if NewParentDimSetID = OldParentDimSetID then
            exit;

        if not CONFIRM(Text001) then
            exit;

        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", "No.");
        ComparativeQuoteLines.LOCKTABLE;
        if ComparativeQuoteLines.FINDSET then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ComparativeQuoteLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ComparativeQuoteLines."Dimension Set ID" <> NewDimSetID then begin
                    //JAV 05/06/22: - QB 1.10.47 No cambiar el proyecto en las l�neas
                    OldJob := ComparativeQuoteLines."Job No.";

                    ComparativeQuoteLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ComparativeQuoteLines."Dimension Set ID", ComparativeQuoteLines."Shortcut Dimension 1 Code", ComparativeQuoteLines."Shortcut Dimension 2 Code");

                    //JAV 05/06/22: - QB 1.10.47 No cambiar el proyecto en las l�neas
                    FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, OldJob, ComparativeQuoteLines."Shortcut Dimension 1 Code", ComparativeQuoteLines."Shortcut Dimension 2 Code",
                                                         ComparativeQuoteLines."Dimension Set ID");

                    ComparativeQuoteLines.MODIFY;
                end;
            until ComparativeQuoteLines.NEXT = 0;
    end;

    procedure GetDescriptionActivity(): Text;
    var
        //       ActivityQB@7001100 :
        ActivityQB: Record 7207280;
        //       txt@100000000 :
        txt: Text;
    begin
        txt := '';
        if ("Activity Filter" <> '') then begin
            ActivityQB.RESET;
            ActivityQB.SETFILTER("Activity Code", "Activity Filter");
            if (ActivityQB.FINDSET(FALSE)) then
                repeat
                    if (txt <> '') then
                        txt += ', ';
                    txt += ActivityQB.Description;
                until ActivityQB.NEXT = 0;
        end;

        //Q17391-
        if (STRLEN(txt) >= 250) then
            txt := COPYSTR(txt, 1, 250);
        //Q17391+

        exit(txt);
    end;

    //     procedure AssistEdit (ComparativeQuoteHeaderPass@7001100 :
    procedure AssistEdit(ComparativeQuoteHeaderPass: Record 7207412): Boolean;
    begin
        PurchSetup.GET;
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, ComparativeQuoteHeaderPass."No. Series", "No. Series") then begin
            PurchSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure ComparativeLinesExist(): Boolean;
    begin
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", "No.");
        exit(ComparativeQuoteLines.FINDFIRST);
    end;

    LOCAL procedure VerControlContrato()
    var
        //       pgControlContratos@1100286001 :
        pgControlContratos: Page 7206922;
        //       ControlContratos@1100286000 :
        ControlContratos: Record 7206912;
    begin
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Contrato, "Generated Contract Doc No.");
        CLEAR(pgControlContratos);
        pgControlContratos.SETTABLEVIEW(ControlContratos);
        pgControlContratos.LOOKUPMODE := TRUE;
        pgControlContratos.RUNMODAL;
    end;

    //     procedure EliminarContrato (pEliminar@1100286000 :
    procedure EliminarContrato(pEliminar: Boolean)
    begin
        //JAV 10/02/21 - QB 1.08.08 Esta funci�n permite eliminar el contrato generado desde un comparativo

        //Miro que se pueda eliminar el documento por no tener cantidades recibidas
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", "Generated Contract Doc Type");
        PurchaseLine.SETRANGE("Document No.", "Generated Contract Doc No.");
        PurchaseLine.SETRANGE("QB Contract Extension No.", "Generated Contract Ext No.");
        if (PurchaseLine.ISEMPTY) then
            exit;

        PurchaseLine.SETFILTER("Quantity Received", '<>%1', 0);
        if (not PurchaseLine.ISEMPTY) then
            ERROR(Text005);

        //Lo saco del control de contratos
        ControlContratos.AsociarContrato(Rec, TRUE);

        //Elimino las l�neas del compra
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", "Generated Contract Doc Type");
        PurchaseLine.SETRANGE("Document No.", "Generated Contract Doc No.");
        PurchaseLine.SETRANGE("QB Contract Extension No.", "Generated Contract Ext No.");
        PurchaseLine.DELETEALL;

        //Si no quedan l�neas que no sean de comentarios elimino el pedido por completo
        if (pEliminar) then begin
            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document Type", "Generated Contract Doc Type");
            PurchaseLine.SETRANGE("Document No.", "Generated Contract Doc No.");
            PurchaseLine.SETFILTER(Type, '<>%1', PurchaseLine.Type::" ");
            if (PurchaseLine.ISEMPTY) then begin
                PurchaseHeader.GET("Generated Contract Doc Type", "Generated Contract Doc No.");
                PurchaseHeader.DELETE(TRUE);
            end;
        end;

        //Quito de las l�neas del comparativo el contrato
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", Rec."No.");
        if (ComparativeQuoteLines.FINDSET(TRUE)) then
            repeat
                //Q13151 -
                GetJob(ComparativeQuoteLines."Job No.");
                CASE ComparativeQuoteLines.Type OF
                    ComparativeQuoteLines.Type::Item:
                        DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Item;
                    ComparativeQuoteLines.Type::Resource:
                        DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Resource;
                end;
                //Q18970.1 Adapatacion de la clave de Data Cost By Piecework
                //if DataCostByPiecework.GET(ComparativeQuoteLines."Job No.", ComparativeQuoteLines."Piecework No.", Job."Current Piecework Budget",
                //                           DataCostByPiecework."Cost Type", ComparativeQuoteLines."No.") then begin
                DataCostByPiecework.SETRANGE("Job No.", ComparativeQuoteLines."Job No.");
                DataCostByPiecework.SETRANGE("Piecework Code", ComparativeQuoteLines."Piecework No.");
                DataCostByPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type");
                DataCostByPiecework.SETRANGE("No.", ComparativeQuoteLines."Job No.");
                if DataCostByPiecework.FINDSET then
                    repeat
                        DataCostByPiecework.VALIDATE("In Quote", FALSE);
                        DataCostByPiecework.VALIDATE("In Quote Price", 0);
                        DataCostByPiecework.VALIDATE(Vendor, '');
                        DataCostByPiecework.MODIFY(TRUE);
                    until DataCostByPiecework.NEXT = 0;
                //Q13151 +

                CLEAR(ComparativeQuoteLines."Contract Document Type");
                ComparativeQuoteLines."Contract Document No." := '';
                ComparativeQuoteLines."Contract Line No." := 0;
                ComparativeQuoteLines.MODIFY;
            until (ComparativeQuoteLines.NEXT = 0);

        //Quito el contrato del comparativo
        CLEAR("Generated Contract Doc Type");
        "Generated Contract Doc No." := '';
        "Generated Contract Ext No." := 0;

        //JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o eliminarlo, o al desechar el comparativo, cambiar el estado del comparativo
        Rec."Comparative Status" := Rec."Comparative Status"::Approved;
        Rec.MODIFY(TRUE);

        MODIFY;
    end;

    /*begin
    //{
//      QB5988 PGM 25/01/2019 - A�adido el campo "K"
//      JAV 11/03/19: - Se a�ade el filtro para que los contratos solo sean pedidos de compra, si no saca hasta facturas
//      JAV 26/03/19: - No dejar cambiar el proyecto si ya hay l�neas
//                    - Nuevo campo "K sobre" para saber sobre que precio se calculo la K
//      JAV 04/02/20: - Se a�aden los campos para Obralia
//      JDC 31/03/21: - Q13150 Added field 50 "Selected Version No."
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de la funci�n GetNoSeriesCode de 10 a 20
//
//      LCG 18/11/21: - QRE15411 A�adir campo PieceWork No.
//      LCG 28/01/22: - RE16204 Crear funci�n para crear l�nea en el caso de que se informe proyecto y partida.
//      DGG 07/03/22: - QRE16539 Se a�ade campo 7238211, para indicar el valor con el que debe informar el campo cantidad en las lineas del pedido al convertir a pedido el comparativo
//      DGG 26/04/22: - QRE17046 Se a�ade campo "QB User ID"
//      JAV 30/05/22: - QB 1.10.45 Cambios en validates para mejorar el manejo del registro
//      JAV 02/06/22: - QB 1.10.47 Al seleccionar o quitar el proveedor, al generar contrato o eliminarlo, o al desechar el comparativo, cambiar el estado del comparativo
//      QMD 31/05/22: - QB 1.10.48 (Q17391) Limitar el tama�o de la descripci�n de las actividades a 250 para evitar desbordamientos
//      AML 12/06/23  - Q18970.1 Adaptacion hecha para que se puedan repetir los descompuestos que vienen de un preciario. Para ello, evitarmos los GET.
//    }
    end.
  */
}







