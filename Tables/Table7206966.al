table 7206966 "QBU Service Order Header"
{


    CaptionML = ENU = 'Service Order Header', ESP = 'Cabecera Pedido Servicio';
    LookupPageID = "QB Service Order List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "Job Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción del Proyecto';
            Editable = false;


        }
        field(3; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(4; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                VALIDATE("Service Date", "Posting Date");
            END;


        }
        field(5; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
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
        field(7; "Shortcut Dimension 2 Code"; Code[20])
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
        field(8; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = true;


        }
        field(9; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(10; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Measure"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(16; "Service Date"; Date)
        {
            CaptionML = ENU = 'Service Date', ESP = 'Fecha del Servicio';
            Description = 'Q16212';


        }
        field(17; "Ext order service"; Code[10])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ext order service', ESP = 'N� de pedido de servicio externo';
            Description = 'Q16212';

            trigger OnValidate();
            BEGIN
                //Q16212 - 01/02/22 (MRV) Pone el texto del pedido de servicio
                "Text Ext order service" := COPYSTR(Text53 + "Ext order service", 1, 30);
                // FIN Q16212 - 01/02/22 (MRV)
            END;


        }
        field(19; "Text Ext order service"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Text Ext order service', ESP = 'Texto pedido de servicio externo';
            Description = 'Q16212';


        }
        field(20; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Status" = CONST("Open"),
                                                                            "Job Type" = CONST("Operative"));


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN

                IF Job.GET("Job No.") THEN BEGIN
                    IF Job.Status <> Job.Status::Open THEN
                        ERROR(Text001);

                    Job.TESTFIELD(Job."Bill-to Customer No.");
                    Job.TESTFIELD(Blocked, Job.Blocked::" ");

                    "Customer No." := Job."Bill-to Customer No.";
                    "Job Description" := Job.Description;
                    "Contract No." := Job."QB Contract No.";
                    CreateDim(DATABASE::Job, "Job No.", DATABASE::Customer, "Customer No.");
                    VALIDATE("Customer No.");
                END;

                // Q16212 - 02/02/22 (EPV) - Error al crear pedidos de servicio desde dentro del proyecto
                // No es necesario validar este dato cuando se crea un nuevo pedido de servicio.
                // Inicio.
                //{
                //                                                                //. Si cambiamos de proyecto quitamos la marca de revisi�n de precios para evitar incoherencias en la informacion
                //                                                                IF "Job No." <> xRec."Job No." THEN
                //                                                                  VALIDATE("Price review", FALSE);
                //                                                                }

                IF ("Job No." <> xRec."Job No.") AND (xRec."Job No." <> '') THEN
                    VALIDATE("Price review", FALSE);

                // Q16212 - 02/02/22 (EPV) - Fin
            END;


        }
        field(21; "Customer No."; Code[20])
        {
            TableRelation = "Customer";


            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';

            trigger OnValidate();
            BEGIN
                GetDataCustomer;
            END;


        }
        field(23; "Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Editable = false;


        }
        field(24; "Address"; Text[50])
        {
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';
            Editable = false;


        }
        field(25; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';
            Editable = false;


        }
        field(26; "City"; Text[50])
        {
            CaptionML = ENU = 'City', ESP = 'Poblaci�n';
            Editable = false;


        }
        field(27; "Contact"; Text[50])
        {
            CaptionML = ENU = 'Contact', ESP = 'Contacto';
            Editable = false;


        }
        field(28; "County"; Text[50])
        {
            CaptionML = ENU = 'County', ESP = 'Provincia';
            Editable = false;


        }
        field(29; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code', ESP = 'C.P.';
            Editable = false;


        }
        field(30; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Country Code', ESP = 'C�d. Pa�s';
            Editable = false;


        }
        field(31; "Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2', ESP = 'Nombre 2';
            Editable = false;


        }
        field(35; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            begin
                //{SE COMENTA.FALTARIA CREAR LA FUNCION GetJobFilter() EN LA CODEUNIT
                //                                                                IF NOT UserMgt.CheckRespCenter(3,"Responsibility Center") THEN
                //                                                                  ERROR (
                //                                                                    Text027,
                //                                                                     Respcenter.TABLECAPTION,SetupManagement.GetJobFilter());
                //
                //                                                                     }
            END;


        }
        field(39; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(44; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(45; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    TestNoSeries;
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                QBServiceOrderHeader := Rec;
                TestNoSeries;
                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := QBServiceOrderHeader;
            END;


        }
        field(46; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(48; "Invoicing Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Invoicing Date', ESP = 'Fecha facturacion';
            Description = 'Q16212';

            trigger OnValidate();
            BEGIN
                // IF "Document Type" = "Document Type"::Certification THEN BEGIN 
                //  MeasurementLines.SETRANGE("Document type","Document Type");
                //  MeasurementLines.SETRANGE("Document No.","No.");
                //  IF MeasurementLines.FINDSET(TRUE,FALSE) THEN
                //    MeasurementLines.MODIFYALL(MeasurementLines."Certification Date","Certification Date");
                // END;
            END;


        }
        field(51; "Bill-to No. Customer"; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Bill-to No. Customer', ESP = 'Factura a N� cliente';


        }
        field(52; "Cod. Payment Terms"; Code[10])
        {
            TableRelation = "Payment Terms";
            CaptionML = ENU = 'Cod. terminos pago', ESP = 'C�d. t�rminos pago';


        }
        field(53; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';


        }
        field(54; "% Payment Discount"; Decimal)
        {
            CaptionML = ENU = '% Payment Discount', ESP = '% Dto. P.P.';


        }
        field(55; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Cod. forma pago', ESP = 'C�d. forma pago';


        }
        field(56; "Payment In-Code"; Code[20])
        {
            CaptionML = ENU = 'Payment In-Code', ESP = 'Pago en-C�digo';


        }
        field(57; "Customer Bank Code"; Code[20])
        {
            TableRelation = "Customer Bank Account"."Code" WHERE("Customer No." = FIELD("Bill-to No. Customer"));
            CaptionML = ENU = 'Customer Bank Code', ESP = 'C�d. banco cliente';


        }
        field(50000; "Expenses/Investment"; Option)
        {
            OptionMembers = "Expenses","Investment","Emergencies";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expenses/Investment', ESP = 'Gastos/Inversi�n';
            OptionCaptionML = ENU = 'Expenses,Investment,Emergencies', ESP = 'Gastos,Inversi�n,Urgencia';

            Description = 'Q5609';

            trigger OnValidate();
            BEGIN
                UpdateLines;
            END;


        }
        field(50001; "Service Order Type"; Code[10])
        {
            TableRelation = "QB Serv. Order Type";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Service Order Type', ESP = 'Tipo pedido servicio';
            Description = 'Q5767';

            trigger OnValidate();
            BEGIN
                UpdateLines;
            END;


        }
        field(50002; "Total Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Service Order Lines"."Cost Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            Description = 'Q5769';


        }
        field(50003; "Total Sale"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Service Order Lines"."Sale Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Base', ESP = 'Venta Total';
            Description = 'Q5769';


        }
        field(50004; "Status"; Option)
        {
            OptionMembers = "Pending","In Process","Finished","On Hold","Invoiced";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'Pending,In Process,Finished,On Hold,Invoiced', ESP = 'Pendiente,En proceso,Terminado,En espera,Facturado';

            Description = 'Q5870';

            trigger OnValidate();
            begin
                //{SE COMENTA. PREGUNTAR
                //                                                                //Q5870
                //                                                                ServiceOrdersLog.CreateLog("Job No.","No.",Status);
                //                                                                //FIN Q5870
                //                                                                }
            END;


        }
        field(50006; "Initial Order Type"; Code[10])
        {
            TableRelation = "Service Order Type";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Initial Order Type', ESP = 'Tipo pedido inicial';
            Description = 'Q5768';
            Editable = false;


        }
        field(50007; "Final Order Type"; Code[10])
        {
            TableRelation = "Service Order Type";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Final Order Type', ESP = 'Tipo pedido final';
            Description = 'Q5768';
            Editable = false;


        }
        field(50008; "Grouping Criteria"; Code[20])
        {
            TableRelation = "QB Grouping Criteria";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Grouping Criteria', ESP = 'Criterios de agrupaci�n';
            Description = 'Q5611';

            trigger OnValidate();
            VAR
                //                                                                 MeasurementLines@1100286000 :
                MeasurementLines: Record 7206967;
            BEGIN
            END;


        }
        field(50010; "Failure Caused By"; Text[200])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Failure Caused By', ESP = 'Aver�a causada por';
            Description = 'Q5614';


        }
        field(50011; "Failiure Company"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company', ESP = 'Empresa';
            Description = 'Q5614';


        }
        field(50012; "Failiure Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Phone No.', ESP = 'Tel�fono';
            Description = 'Q5614';


        }
        field(50013; "Failiure Address"; Text[75])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Address', ESP = 'Domicilio';
            Description = 'Q5614';


        }
        field(50014; "Company Failure Maker"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company Failure Maker', ESP = 'Empresa que produjo la rotura';
            Description = 'Q5614';


        }
        field(50015; "Working Company"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Working Company', ESP = 'Empresa para la que trabaja';
            Description = 'Q5614';


        }
        field(50016; "Instaled Service"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Instaled Service', ESP = 'Servicio instalado';
            Description = 'Q5614';


        }
        field(50017; "Failiure Cause"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Failiure Cause', ESP = 'Causa de la rotura';
            Description = 'Q5614';


        }
        field(50019; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract No.', ESP = 'N� contrato';
            Description = 'QIN';


        }
        field(50020; "Operation Result"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Operation Result', ESP = 'Resultado operaci�n';


        }
        field(50050; "Preinvoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Preinvoice', ESP = 'Prefactura';


        }
        field(50100; "Ship-to Code"; Code[10])
        {
            TableRelation = "Ship-to Address"."Code" WHERE("Customer No." = FIELD("Customer No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Code', ESP = 'C�d. direcci�n env�o cliente';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 ShipToAddr@1000 :
                ShipToAddr: Record 222;
                //                                                                 Cust@1100286000 :
                Cust: Record 18;
            BEGIN

                IF "Ship-to Code" <> '' THEN BEGIN
                    IF xRec."Ship-to Code" <> '' THEN BEGIN
                        Cust.GET("Customer No.");
                        IF Cust."Location Code" <> '' THEN
                            "Location Code" := Cust."Location Code";
                        //"Tax Area Code" := Cust."Tax Area Code";
                    END;
                    ShipToAddr.GET("Customer No.", "Ship-to Code");
                    SetShipToAddress(
                      ShipToAddr.Name, ShipToAddr."Name 2", ShipToAddr.Address, ShipToAddr."Address 2",
                      ShipToAddr.City, ShipToAddr."Post Code", ShipToAddr.County, ShipToAddr."Country/Region Code");
                    "Ship-to Contact" := ShipToAddr.Contact;
                    "Ship-to Phone" := ShipToAddr."Phone No.";
                    IF ShipToAddr."Location Code" <> '' THEN
                        "Location Code" := ShipToAddr."Location Code";
                    "Ship-to Fax No." := ShipToAddr."Fax No.";
                    "Ship-to E-Mail" := ShipToAddr."E-Mail";
                    //  IF ShipToAddr."Tax Area Code" <> '' THEN
                    //    "Tax Area Code" := ShipToAddr."Tax Area Code";
                    //  "Tax Liable" := ShipToAddr."Tax Liable";
                END ELSE
                    IF "Customer No." <> '' THEN BEGIN
                        Cust.GET("Customer No.");
                        SetShipToAddress(
                          Cust.Name, Cust."Name 2", Cust.Address, Cust."Address 2",
                          Cust.City, Cust."Post Code", Cust.County, Cust."Country/Region Code");
                        "Ship-to Contact" := Cust.Contact;
                        "Ship-to Phone" := Cust."Phone No.";
                        //"Tax Area Code" := Cust."Tax Area Code";
                        //"Tax Liable" := Cust."Tax Liable";
                        IF Cust."Location Code" <> '' THEN
                            "Location Code" := Cust."Location Code";
                        "Ship-to Fax No." := Cust."Fax No.";
                        "Ship-to E-Mail" := Cust."E-Mail";
                    END;
            END;


        }
        field(50101; "Ship-to Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Name', ESP = 'Nombre direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50102; "Ship-to Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Name 2', ESP = 'Nombre direcci�n de env�o 2';
            Description = 'Q5767';


        }
        field(50103; "Ship-to Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Address', ESP = 'Direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50104; "Ship-to Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Address 2', ESP = 'Direcci�n de env�o 2';
            Description = 'Q5767';


        }
        field(50105; "Ship-to City"; Text[30])
        {
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code".City ELSE IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code"."City" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to City', ESP = 'Poblaci�n direcci�n de env�o';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1100286000 :
                PostCode: Record 225;
            BEGIN
                PostCode.ValidateCity(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            END;


        }
        field(50106; "Ship-to Contact"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Contact', ESP = 'Contacto de direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50107; "Location Code"; Code[10])
        {
            TableRelation = "Location";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Location Code', ESP = 'C�d. almac�n';
            Description = 'Q5767';


        }
        field(50108; "Ship-to Post Code"; Code[20])
        {
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code" ELSE IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Post Code', ESP = 'C.P. direcci�n de env�o';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1100286000 :
                PostCode: Record 225;
            BEGIN
                PostCode.ValidatePostCode(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            END;


        }
        field(50109; "Ship-to County"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to County', ESP = 'Provincia direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50110; "Ship-to Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Country/Region Code', ESP = 'C�d. pa�s/regi�n direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50111; "Shipping Agent Code"; Code[10])
        {
            TableRelation = "Shipping Agent";


            AccessByPermission = TableData 5790 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Agent Code', ESP = 'C�d. transportista';
            Description = 'Q5767';

            trigger OnValidate();
            BEGIN

                IF xRec."Shipping Agent Code" = "Shipping Agent Code" THEN
                    EXIT;

                "Shipping Agent Service Code" := '';
                GetShippingTime(FIELDNO("Shipping Agent Code"));
                //UpdateServLines(FIELDCAPTION("Shipping Agent Code"),CurrFieldNo <> 0);
            END;


        }
        field(50112; "Shipping Advice"; Option)
        {
            OptionMembers = "Partial","Complete";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Advice', ESP = 'Aviso env�o';
            OptionCaptionML = ENU = 'Partial,Complete', ESP = 'Parcial,Completo';

            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 WhseValidateSourceHeader@1000 :
                WhseValidateSourceHeader: Codeunit 5781;
            BEGIN
                // TESTFIELD("Release Status","Release Status"::Open);
                // IF InventoryPickConflict("Document Type","No.","Shipping Advice") THEN
                //  ERROR(Text064,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice"),TABLECAPTION);
                // IF WhseShpmntConflict("Document Type","No.","Shipping Advice") THEN
                //  ERROR(STRSUBSTNO(Text065,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice"),TABLECAPTION));
                // WhseValidateSourceHeader.ServiceHeaderVerifyChange(Rec,xRec);
            END;


        }
        field(50113; "Shipping Time"; DateFormula)
        {


            AccessByPermission = TableData 5790 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Time', ESP = 'Tiempo env�o';
            Description = 'Q5767';

            trigger OnValidate();
            BEGIN
                //TESTFIELD("Release Status","Release Status"::Open);
                //IF "Shipping Time" <> xRec."Shipping Time" THEN
                // UpdateServLines(FIELDCAPTION("Shipping Time"),CurrFieldNo <> 0);
            END;


        }
        field(50114; "Shipping Agent Service Code"; Code[10])
        {
            TableRelation = "Shipping Agent Services"."Code" WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Agent Service Code', ESP = 'C�d. servicio transportista';
            Description = 'Q5767';

            trigger OnValidate();
            BEGIN
                //TESTFIELD("Release Status","Release Status"::Open);
                GetShippingTime(FIELDNO("Shipping Agent Service Code"));
                //UpdateServLines(FIELDCAPTION("Shipping Agent Service Code"),CurrFieldNo <> 0);
            END;


        }
        field(50115; "Ship-to Fax No."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Fax No.', ESP = 'N� fax direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50116; "Ship-to E-Mail"; Text[80])
        {


            ExtendedDatatype = EMail;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Email', ESP = 'Correo electr�nico direcci�n de env�o';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 MailManagement@1000 :
                MailManagement: Codeunit 9520;
            BEGIN
                MailManagement.ValidateEmailAddressField("Ship-to E-Mail");
            END;


        }
        field(50117; "Ship-to Phone"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Phone', ESP = 'Tel�fono de direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50118; "Ship-to Phone 2"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Phone 2', ESP = 'Tel�fono 2 direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50119; "Shipment Method Code"; Code[10])
        {
            TableRelation = "Shipment Method";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipment Method Code', ESP = 'C�d. condiciones env�o';
            Description = 'Q5767';


        }
        field(50120; "Price review"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review', ESP = 'Revision precios';
            Description = 'Q12733, Marcamos si esta medici�n esta sujeta de revisi�n de precios';

            trigger OnValidate();
            VAR
                //                                                                 lrPriceReview@100000000 :
                lrPriceReview: Record 7206965;
                //                                                                 errNoPriceReview@100000001 :
                errNoPriceReview: TextConst ENU = 'There is no price review for the job %1.', ESP = 'No hay ninguna revisi�n de precios para el proyecto %1.';
                //                                                                 lPriceReviewList@100000002 :
                lPriceReviewList: Page 7207053;
                //                                                                 errSelectCode@100000003 :
                errSelectCode: TextConst ENU = 'You must select a price review code.', ESP = 'Debe seleccionar un codigo de revisi�n de precios.';
            BEGIN
                //. Si el proyecto no tiene ning�n c�digo de revisi�n, no dejamos marcar este campo
                IF "Price review" THEN BEGIN
                    lrPriceReview.FILTERGROUP(2);
                    lrPriceReview.SETRANGE("Job No.", "Job No.");
                    lrPriceReview.FILTERGROUP(0);
                    IF NOT lrPriceReview.FINDFIRST THEN
                        ERROR(errNoPriceReview, "Job No.");

                    IF lrPriceReview.COUNT <> 1 THEN BEGIN
                        //. Si existen revisiones hacemos que el usuario escoja una
                        CLEAR(lPriceReviewList);
                        lPriceReviewList.SETTABLEVIEW(lrPriceReview);
                        lPriceReviewList.LOOKUPMODE(TRUE);
                        lPriceReviewList.EDITABLE(FALSE);
                        IF lPriceReviewList.RUNMODAL <> ACTION::LookupOK THEN
                            ERROR(errSelectCode);

                        //. Guardamos los valores en la medici�n para su uso posterior en la facturacion
                        lPriceReviewList.GETRECORD(lrPriceReview);
                    END;

                    VALIDATE("Price review code", lrPriceReview."Review code");
                    VALIDATE("Price review percentage", lrPriceReview.Percentage);
                END
                ELSE BEGIN
                    VALIDATE("Price review code", '');
                    VALIDATE("Price review percentage", 0);
                END;
            END;


        }
        field(50121; "Price review code"; Code[10])
        {
            TableRelation = "QB Price x job review"."Review code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review code', ESP = 'Cod. Revision precios';
            Description = 'Q12733, Especifica el c�digo que aplica a este medici�n';


        }
        field(50122; "Price review percentage"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review percentage', ESP = 'Porcentaje revision precios';
            Description = 'Q12733, Traemos el porcentaje del c�digo de revision';

            trigger OnValidate();
            BEGIN


                //Pasarlo a las l�neas
                MODIFY; //Si no la l�nea no lo ver�
                QBServiceOrderLines.RESET;
                QBServiceOrderLines.SETRANGE("Document No.", "No.");
                IF QBServiceOrderLines.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        QBServiceOrderLines.CalcAmounts;
                        QBServiceOrderLines.MODIFY(TRUE);
                    UNTIL QBServiceOrderLines.NEXT = 0;
                END;
            END;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
        key(key2; "Customer No.")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@1100286002 :
        QuoBuildingSetup: Record 7207278;
        //       QBServiceOrderLines@7001104 :
        QBServiceOrderLines: Record 7206967;
        //       QBServiceOrderHeader@7001109 :
        QBServiceOrderHeader: Record 7206966;
        //       QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
        //       Text003@7001105 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text051@7001108 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Has cambiado una dimension.\\Quiere actualizar las lineas?';
        //       Text52@7001110 :
        Text52: TextConst ENU = 'Measure No.: ', ESP = 'Medici�n N�: ';
        //       Text53@1100286001 :
        Text53: TextConst ENU = 'Service Order No.: ', ESP = 'Ped. serv externo No.:';
        //       Text001@7001112 :
        Text001: TextConst ENU = 'Selected Job is not in Order Status', ESP = 'El proyecto seleccionado no est� en estado pedido', ESN = 'El proyecto seleccionado no est� en estado pedido';
        //       Job@1100286005 :
        Job: Record 167;
        //       Customer@7001113 :
        Customer: Record 18;
        //       Text006@7001114 :
        Text006: TextConst ENU = 'Measure Type cannot be changed because lines exist for measurment %1', ESP = 'No puede cambiar el tipo de medici�n porque existen l�neas para la medici�n %1';
        //       Text027@7001115 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       NoSeriesMgt@1100286003 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       DimMgt@1100286000 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       OldDimSetID@1100286004 :
        OldDimSetID: Integer;



    trigger OnInsert();
    begin
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;
        InitRecord;

        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                VALIDATE("Job No.", GETRANGEMIN("Job No."));

        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Job No.") <> '')) then
            VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);
    end;

    trigger OnDelete();
    begin
        QBServiceOrderLines.LOCKTABLE;

        QBServiceOrderLines.SETRANGE("Document No.", "No.");
        QBServiceOrderLines.DELETEALL;

        QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::ServiceOrder);
        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        QuoBuildingSetup.GET();
        QuoBuildingSetup.TESTFIELD("Serie for Service Order");
        QuoBuildingSetup.TESTFIELD("Serie for Service Order Post");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET();
        exit(QuoBuildingSetup."Serie for Service Order");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET();
        exit(QuoBuildingSetup."Serie for Service Order Post");
    end;

    procedure InitRecord()
    begin
        "Posting Date" := WORKDATE;
        "Service Date" := TODAY;
        "Service Date" := TODAY;
        "Posting Description" := '';
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ExistLines(): Boolean;
    begin
        QBServiceOrderLines.RESET;
        QBServiceOrderLines.SETRANGE("Document No.", "No.");
        exit(not QBServiceOrderLines.ISEMPTY);
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        QBServiceOrderLines.RESET;
        QBServiceOrderLines.SETRANGE("Document No.", "No.");
        QBServiceOrderLines.LOCKTABLE;
        if QBServiceOrderLines.FINDSET then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(QBServiceOrderLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if QBServiceOrderLines."Dimension Set ID" <> NewDimSetID then begin
                    QBServiceOrderLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      QBServiceOrderLines."Dimension Set ID", QBServiceOrderLines."Shortcut Dimension 1 Code", QBServiceOrderLines."Shortcut Dimension 2 Code");
                    QBServiceOrderLines.MODIFY;
                end;
            until QBServiceOrderLines.NEXT = 0;
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1003 : Integer;No2@1002 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //       Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Measurements and Certif.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistLines then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure GetDataCustomer()
    begin
        if not Customer.GET("Customer No.") then
            Customer.INIT;

        Name := Customer.Name;
        "Name 2" := Customer."Name 2";
        Address := Customer.Address;
        "Address 2" := Customer."Address 2";
        City := Customer.City;
        Contact := Customer.Contact;
        County := Customer.County;
        "Post Code" := Customer."Post Code";
        "Name 2" := Customer."Name 2";
        "Bill-to No. Customer" := Customer."Bill-to Customer No.";
        Customer.TESTFIELD("Payment Terms Code");
        "Cod. Payment Terms" := Customer."Payment Terms Code";
        "Payment Method Code" := Customer."Payment Method Code";
        "Customer Bank Code" := Customer."Preferred Bank Account Code";
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt1.EditDimensionSet2("Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure FunWriteSettings()
    var
        //       locrecMeasurementLines@1100240001 :
        locrecMeasurementLines: Record 7206967;
        //       locIntLastLine@1100240002 :
        locIntLastLine: Integer;
        //       locrecCurrency@1100240003 :
        locrecCurrency: Record 4;
    begin

        CLEAR(locrecCurrency);
        if "Currency Code" <> '' then
            locrecCurrency.GET("Currency Code");
        locrecCurrency.InitRoundingPrecision;
        locIntLastLine := 0;
    end;

    //     procedure AssistEdit (recOldHeader@1000 :
    procedure AssistEdit(recOldHeader: Record 7206966): Boolean;
    begin
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, recOldHeader."No. Series", "No. Series") then begin
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    //     procedure FunFilterResponsibility (var MeasureToFilter@1000000000 :
    procedure FunFilterResponsibility(var MeasureToFilter: Record 7206966)
    begin
        //{SE COMENTA. PREGUNTAR
        //      if SetupManagement.GetJobFilter <> '' then begin
        //        MeasureToFilter.FILTERGROUP(2);
        //        MeasureToFilter.SETRANGE("Responsibility Center",SetupManagement.GetJobFilter);
        //        MeasureToFilter.FILTERGROUP(0);
        //      end;
        //      }
    end;


    //     procedure SetShipToAddress (ShipToName@1000 : Text[50];ShipToName2@1001 : Text[50];ShipToAddress@1002 : Text[50];ShipToAddress2@1003 : Text[50];ShipToCity@1004 : Text[30];ShipToPostCode@1005 : Code[20];ShipToCounty@1006 : Text[30];ShipToCountryRegionCode@1007 :
    procedure SetShipToAddress(ShipToName: Text[50]; ShipToName2: Text[50]; ShipToAddress: Text[50]; ShipToAddress2: Text[50]; ShipToCity: Text[30]; ShipToPostCode: Code[20]; ShipToCounty: Text[30]; ShipToCountryRegionCode: Code[10])
    begin
        "Ship-to Name" := ShipToName;
        "Ship-to Name 2" := ShipToName2;
        "Ship-to Address" := ShipToAddress;
        "Ship-to Address 2" := ShipToAddress2;
        "Ship-to City" := ShipToCity;
        "Ship-to Post Code" := ShipToPostCode;
        "Ship-to County" := ShipToCounty;
        VALIDATE("Ship-to Country/Region Code", ShipToCountryRegionCode);
    end;

    //     LOCAL procedure GetShippingTime (CalledByFieldNo@1000 :
    LOCAL procedure GetShippingTime(CalledByFieldNo: Integer)
    var
        //       ShippingAgentServices@1001 :
        ShippingAgentServices: Record 5790;
        //       Cust@1100286000 :
        Cust: Record 18;
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        if ShippingAgentServices.GET("Shipping Agent Code", "Shipping Agent Service Code") then
            "Shipping Time" := ShippingAgentServices."Shipping Time"
        else begin
            Cust.GET("Customer No.");
            "Shipping Time" := Cust."Shipping Time"
        end;
        if not (CalledByFieldNo IN [FIELDNO("Shipping Agent Code"), FIELDNO("Shipping Agent Service Code")]) then
            VALIDATE("Shipping Time");
    end;

    LOCAL procedure UpdateLines()
    begin
        Rec."Final Order Type" := Rec."Service Order Type";
        if Rec."Initial Order Type" = '' then
            Rec."Initial Order Type" := Rec."Service Order Type";
    end;


    //     procedure SetOperationResult (NewWorkDescription@1000 :
    procedure SetOperationResult(NewWorkDescription: Text)
    var
        //       TempBlob@1001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        CLEAR("Operation Result");
        if NewWorkDescription = '' then
            exit;
        // TempBlob.Blob := "Operation Result";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Operation Result");
        // TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::Windows);
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(NewWorkDescription);
        // "Operation Result" := TempBlob.Blob;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("Operation Result");
        MODIFY;
    end;


    procedure GetOperationResult(): Text;
    var
        //       TempBlob@1000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       CR@1004 :
        CR: Text[1];
    begin
        CALCFIELDS("Operation Result");
        if not "Operation Result".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "Operation Result";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Operation Result");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;

    /*begin
    //{
//      2101 AJS 19.03.21 - Q12733, Nuevos campos "Price review", "Price review code" y "Price review percentage" para gestionar las revisiones de precio
//      Q16212 - 01/02/22 (MRV) - Se concatena la descripcion del campo Text Ext order service y se a�aden 3 campos
//      Q16212 - 02/02/22 (EPV) - Error al crear pedidos de servicio desde dentro del proyecto
//      Q16212 - 01/02/22 (MRV) - Pone el texto del pedido de servicio
//    }
    end.
  */
}







