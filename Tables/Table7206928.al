table 7206928 "QBU Prepayment"
{

    DataCaptionFields = "Entry No.", "Document No.";
    CaptionML = ENU = 'Prepayment', ESP = 'Anticipos';
    LookupPageID = "QB Prepayment Edit SubForm";
    DrillDownPageID = "QB Prepayment Edit SubForm";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'N� mov.';


        }
        field(3; "OLD_No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '### ELIMINAR ### No se usa';


        }
        field(5; "Order"; Code[60])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Orden';
            Description = 'Sirve para ordenar los registros en la pantalla, se establece en el alta o la modificaci�n del registro';

            trigger OnValidate();
            BEGIN
                Order := StrPad("Job No.", 20, '_') + COPYSTR(FORMAT("Account Type"), 1, 1);

                IF ("Account No." <> '') THEN
                    Order += StrPad("Account No.", 20, '_')
                ELSE
                    Order += StrPad('', 20, 'z');

                CASE "Entry Type" OF
                    "Entry Type"::TAccount:
                        Order += 'B';
                    "Entry Type"::TJob:
                        Order += 'C';
                    ELSE
                        Order += 'A';
                END;

                IF ("Apply to Entry No." = 0) THEN
                    Order += NumPad("Entry No.", 10)
                ELSE
                    Order += NumPad("Apply to Entry No.", 10);
            END;


        }
        field(9; "OLD_Status"; Option)
        {
            OptionMembers = " ","Open","ApprovalPending","Close";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado';
            OptionCaptionML = ENU = '" ,Open,ApprovalPending,Close"', ESP = '" ,Abierto,Aprobaci�n Pendiente,Cerrado"';

            Description = '### ELIMINAR ### No se usa';


        }
        field(10; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = FILTER(<> Estudio & <> ' '));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto';

            trigger OnValidate();
            BEGIN
                //JAV 04/04/22: - QB 1.10.31 Mirar que el proyecto est� asignado al usuario
                IF ("Job No." <> '') THEN BEGIN
                    IF NOT FunctionQB.CanUserAccessJob("Job No.") THEN
                        ERROR(Text02, "Job No.");
                END;

                IF (NOT Job.GET("Job No.")) THEN
                    Job.INIT;

                "Job Descripcion" := Job.Description;

                IF (Rec."Account Type" = Rec."Account Type"::Customer) THEN BEGIN
                    Job.CALCFIELDS("Production Budget Amount LCY");
                    "Base Amount" := Job."Production Budget Amount LCY";
                    IF (Job."Bill-to Customer No." <> '') THEN BEGIN
                        "Account No." := Job."Bill-to Customer No.";
                        VALIDATE("Account Description");
                    END;
                END;

                "Currency Code" := Job."Currency Code";
                MountDescription;
            END;

            trigger OnLookup();
            VAR
                //                                                               JobNo@1100286000 :
                JobNo: Code[20];
            BEGIN
                //JAV 04/04/22: - QB 1.10.31 Al sacar la lista de proyectos, filtrar por los que se pueden ver por el usuario
                JobNo := Rec."Job No.";
                IF FunctionQB.LookupUserJobs(JobNo) THEN
                    VALIDATE("Job No.", JobNo);
            END;


        }
        field(11; "Account Type"; Option)
        {
            OptionMembers = "Vendor","Customer";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Vendor,Customer', ESP = 'Proveedor,Cliente';


            trigger OnValidate();
            BEGIN
                IF ("Account Type" <> xRec."Account Type") THEN BEGIN
                    "Base Amount" := 0;
                    "Account No." := '';
                    VALIDATE("Account Description");
                END;

                VALIDATE("Job No.");
                VALIDATE("Document Date");
                VALIDATE("Prepayment Type");
            END;


        }
        field(12; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("Vendor")) "Vendor" ELSE IF ("Account Type" = CONST("Customer")) "Customer";


            CaptionML = ENU = 'No.', ESP = 'Cuenta';

            trigger OnValidate();
            BEGIN
                VALIDATE("Job No.");
                VALIDATE("Account Description");

                QuoBuildingSetup.GET();
                "Payment Terms Code" := QuoBuildingSetup."Prepayment Payment Terms";
                "Payment Method Code" := QuoBuildingSetup."Prepayment Payment Method";

                CASE Rec."Account Type" OF
                    Rec."Account Type"::Vendor:
                        BEGIN
                            Vendor.GET(Rec."Account No.");
                            IF (QuoBuildingSetup."Prepayment Payment Terms" = '') THEN
                                "Payment Terms Code" := Vendor."Payment Terms Code";

                            IF (QuoBuildingSetup."Prepayment Payment Method" = '') THEN
                                "Payment Method Code" := Vendor."Payment Method Code";
                        END;
                    Rec."Account Type"::Customer:
                        BEGIN
                            Customer.GET(Rec."Account No.");
                            IF (QuoBuildingSetup."Prepayment Payment Terms" = '') THEN
                                "Payment Terms Code" := Customer."Payment Terms Code";

                            IF (QuoBuildingSetup."Prepayment Payment Method" = '') THEN
                                "Payment Method Code" := Customer."Payment Method Code";
                        END;
                END;

                VALIDATE("Payment Terms Code");
                VALIDATE("Payment Method Code");
            END;


        }
        field(15; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Generated Document No.', ESP = 'N� documento Generado';
            Editable = false;


        }
        field(16; "Description"; Text[100])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(17; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                "Document Date" := "Posting Date";
            END;


        }
        field(18; "Document Date"; Date)
        {


            CaptionML = ENU = 'Document Date', ESP = 'Fecha emisi�n documento';

            trigger OnValidate();
            BEGIN
                IF ("Account Type" = "Account Type"::Customer) THEN
                    "Document Date" := "Posting Date";

                IF ("Document Date" > "Posting Date") THEN
                    ERROR(Txt014);

                VALIDATE("Payment Terms Code");
            END;


        }
        field(19; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'N� documento externo';


        }
        field(20; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(23; "Entry Type"; Option)
        {
            OptionMembers = "Invoice","Bill","Application","Cancelation","TAccount","TJob";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo de entrada';
            OptionCaptionML = ENU = 'Invoice,Bill,Application,,,Cancelation,,,,Total Account,Total Job', ESP = 'Factura,Efecto,Aplicaci�n,,,Cancelaci�n,,,,Total Cuenta,Total Proyecto';

            Description = 'QB 1.10.49 JAV 09/06/22 Se amplian los estados con el de cancelado y se distribuyen de otra forma para poder a�adir mas';


        }
        field(24; "TJ"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Para ordenar';


        }
        field(25; "TC"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Para ordenar';


        }
        field(26; "See in Pending"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.10.36 JAV 11/04/22: - Campo que indica que se ver� en la page de anticipos sin registrar';


        }
        field(27; "See in Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.10.36 JAV 11/04/22: - Campo que indica que se ver� en la page de anticipos registrados';


        }
        field(29; "Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Observaciones';
            Description = 'QB 1.10.36 - JAV 11/04/22 [TT] Notas que desee informar en el anticipo';


        }
        field(30; "Amount"; Decimal)
        {


            CaptionML = ENU = 'Amount', ESP = 'Importe';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                IF ("Currency Code" = '') OR ("Currency Code" = GeneralLedgerSetup."LCY Code") THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", Amount, "Currency Code", '', "Posting Date", 1, Amt, Factor);
                    "Amount (LCY)" := Amt;
                END;
            END;


        }
        field(31; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe (DL)';
            AutoFormatType = 1;


        }
        field(34; "Sum Account Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                 "Account Type" = FIELD("Account Type"),
                                                                                                 "Account No." = FIELD("Account No.")));
            CaptionML = ENU = 'Amount', ESP = 'Suma de Importes por cuenta';


        }
        field(35; "Sum Account Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                         "Account Type" = FIELD("Account Type"),
                                                                                                         "Account No." = FIELD("Account No.")));
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Suma de Importes por cuenta (DL)';
            AutoFormatType = 1;


        }
        field(36; "Sum Job Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                 "Account Type" = FIELD("Account Type")));
            CaptionML = ENU = 'Amount', ESP = 'Suma de Importes por proyecto';


        }
        field(37; "Sum Job Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                         "Account Type" = FIELD("Account Type")));
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Suma de Importes por proyecto (DL)';
            AutoFormatType = 1;


        }
        field(40; "Base Amount"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Base';

            trigger OnValidate();
            BEGIN
                IF ("Base Amount" <> 0) AND (Percentage <> 0) THEN
                    VALIDATE("Not Approved Amount", ROUND("Base Amount" * Percentage / 100, 0.01))
                ELSE IF ("Base Amount" <> 0) AND ("Not Approved Amount" <> 0) THEN
                    Percentage := ROUND("Not Approved Amount" * 100 / "Base Amount", 0.0001);

                MountDescription;
            END;


        }
        field(41; "Percentage"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Porcentaje';
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate();
            BEGIN
                IF ("Base Amount" <> 0) AND (Percentage <> 0) THEN
                    VALIDATE("Not Approved Amount", ROUND("Base Amount" * Percentage / 100, 0.01))
                ELSE IF (Percentage <> 0) AND ("Not Approved Amount" <> 0) THEN
                    "Base Amount" := ROUND("Not Approved Amount" * 100 / Percentage, 0.01);

                MountDescription;
            END;


        }
        field(42; "Not Approved Amount"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe No Aprobado';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';

            trigger OnValidate();
            BEGIN
                IF ("Not Approved Amount" <> 0) AND ("Base Amount" <> 0) THEN
                    Percentage := ROUND("Not Approved Amount" * 100 / "Base Amount", 0.0001)
                ELSE IF ("Not Approved Amount" <> 0) AND (Percentage <> 0) THEN
                    "Base Amount" := ROUND("Not Approved Amount" * 100 / Percentage, 0.01);

                GeneralLedgerSetup.GET();
                IF ("Currency Code" = '') OR ("Currency Code" = GeneralLedgerSetup."LCY Code") THEN
                    "Not Approved Amount (LCY)" := "Not Approved Amount"
                ELSE BEGIN
                    JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", "Not Approved Amount", "Currency Code", '', "Posting Date", 1, Amt, Factor);
                    "Not Approved Amount (LCY)" := Amt;
                END;

                MountDescription;
            END;


        }
        field(43; "Not Approved Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe No Aprobado (DL)';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';


        }
        field(44; "Sum Account Not App. Amt."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Not Approved Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Account Type" = FIELD("Account Type"),
                                                                                                                "Account No." = FIELD("Account No.")));
            CaptionML = ENU = 'Amount', ESP = 'Suma de Importes No Aprobado por cuenta';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';


        }
        field(45; "Sum Account Not App.Amt. (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Not Approved Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                      "Account Type" = FIELD("Account Type"),
                                                                                                                      "Account No." = FIELD("Account No.")));
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Suma de Importes No Aprobado por cuenta (DL)';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';
            AutoFormatType = 1;


        }
        field(46; "Sum Job Not App. Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Not Approved Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Account Type" = FIELD("Account Type")));
            CaptionML = ENU = 'Amount', ESP = 'Suma de Importes No Aprobado por proyecto';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';


        }
        field(47; "Sum Job Not App. Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Not Approved Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                      "Account Type" = FIELD("Account Type")));
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Suma de Importes No Aprobado por proyecto (DL)';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';
            AutoFormatType = 1;


        }
        field(48; "Exist Account Not App. Reg."; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Prepayment" WHERE("Job No." = FIELD("Job No."),
                                                                                            "Account Type" = FIELD("Account Type"),
                                                                                            "Account No." = FIELD("Account No."),
                                                                                            "Amount" = CONST(0),
                                                                                            "TJ" = CONST(false),
                                                                                            "TC" = CONST(false)));
            CaptionML = ENU = 'Amount', ESP = 'Existen registros No Aprobado por cuenta';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';


        }
        field(49; "Exist Job Not App. Reg."; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Prepayment" WHERE("Job No." = FIELD("Job No."),
                                                                                            "Account Type" = FIELD("Account Type"),
                                                                                            "Amount" = CONST(0),
                                                                                            "TJ" = CONST(false),
                                                                                            "TC" = CONST(false)));
            CaptionML = ENU = 'Amount', ESP = 'Existen registros No Aprobado por Proyecto';
            Description = 'QB 1.10.29 - JAV 29/03/22 Importe del anticipo sin aprobar';


        }
        field(50; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00- JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(51; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("Prepayment"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'TO-DO Debe pasar el dato de la aprobaci�n como referencia';


        }
        field(52; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'TO-DO Debe pasar el dato de la aprobaci�n como referencia';


        }
        field(60; "Job Descripcion"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Descripcion', ESP = 'Descricpi�n del proyecto';
            Editable = false;


        }
        field(61; "Account Description"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Account Description" := '';
                IF ("Account No." <> '') THEN BEGIN
                    CASE "Account Type" OF
                        "Account Type"::Customer:
                            BEGIN
                                Customer.GET("Account No.");
                                "Account Description" := Customer.Name;
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vendor.GET("Account No.");
                                "Account Description" := Vendor.Name;
                            END;
                    END;
                END;
            END;


        }
        field(62; "Generate Document"; Option)
        {
            OptionMembers = "Invoice","Bill";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Generate Document Type', ESP = 'Documento a Generar';
            OptionCaptionML = ENU = 'Invoice,Bill', ESP = 'Factura,Efecto';


            trigger OnValidate();
            BEGIN
                CASE "Generate Document" OF
                    "Generate Document"::Invoice:
                        "Entry Type" := "Entry Type"::Invoice;
                    "Generate Document"::Bill:
                        "Entry Type" := "Entry Type"::Bill;
                END;

                MountDescription;
            END;


        }
        field(63; "Prepayment Type"; Code[10])
        {
            TableRelation = "QB Prepayment Types";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prepayment Type', ESP = 'Tipo de Anticipo';
            Description = 'QB 1.10.29 - JAV 29/03/22 Nueva tabla de tipos de anticipo';

            trigger OnValidate();
            BEGIN
                "For Document Type" := "For Document Type"::None;
                IF (QBPrepaymentType.GET("Prepayment Type")) THEN BEGIN
                    CASE TRUE OF
                        ("Account Type" = "Account Type"::Vendor) AND (QBPrepaymentType."Document Type" = QBPrepaymentType."Document Type"::Order):
                            "For Document Type" := "For Document Type"::PurchaseOrder;
                        ("Account Type" = "Account Type"::Vendor) AND (QBPrepaymentType."Document Type" = QBPrepaymentType."Document Type"::Invoice):
                            "For Document Type" := "For Document Type"::PurchaseInvoice;
                        ("Account Type" = "Account Type"::Customer) AND (QBPrepaymentType."Document Type" = QBPrepaymentType."Document Type"::Order):
                            "For Document Type" := "For Document Type"::SalesOrder;
                        ("Account Type" = "Account Type"::Customer) AND (QBPrepaymentType."Document Type" = QBPrepaymentType."Document Type"::Invoice):
                            "For Document Type" := "For Document Type"::SalesInvoice;
                    END;

                    IF NOT QuoBuildingSetup.GET THEN
                        QuoBuildingSetup.INIT;

                    CASE QuoBuildingSetup."Prepayment Document Type" OF
                        QuoBuildingSetup."Prepayment Document Type"::ForceInvoice:
                            "Generate Document" := "Generate Document"::Invoice;
                        QuoBuildingSetup."Prepayment Document Type"::ForceBill:
                            "Generate Document" := "Generate Document"::Bill;
                        ELSE BEGIN
                            CASE QBPrepaymentType."Document to Generate" OF
                                QBPrepaymentType."Document to Generate"::Invoice:
                                    "Generate Document" := "Generate Document"::Invoice;
                                QBPrepaymentType."Document to Generate"::Bill:
                                    "Generate Document" := "Generate Document"::Bill;
                            END;
                        END;
                    END;
                END;

                MountDescription;
            END;


        }
        field(64; "For Document No."; Code[20])
        {
            TableRelation = IF ("For Document Type" = CONST("PurchaseOrder")) "Purchase Header"."No." WHERE("Document Type" = CONST("Order"), "Buy-from Vendor No." = FIELD("Account No."), "QB Job No." = FIELD("Job No."), "Status" = CONST("Released")) ELSE IF ("For Document Type" = CONST("PurchaseInvoice")) "Purchase Header"."No." WHERE("Document Type" = CONST("Invoice"), "Buy-from Vendor No." = FIELD("Account No."), "QB Job No." = FIELD("Job No."), "Status" = CONST("Released")) ELSE IF ("For Document Type" = CONST("SalesOrder")) "Sales Header"."No." WHERE("Document Type" = CONST("Order"), "Sell-to Customer No." = FIELD("Account No."), "QB Job No." = FIELD("Job No."), "Status" = CONST("Released")) ELSE IF ("For Document Type" = CONST("SalesInvoice")) "Sales Header"."No." WHERE("Document Type" = CONST("Invoice"), "Sell-to Customer No." = FIELD("Account No."), "QB Job No." = FIELD("Job No."), "Status" = CONST("Released"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'For Document No.', ESP = 'Para el Documento N�';
            Description = 'QB 1.10.29 - JAV 29/03/22 Documento relacionado con el anticipo';

            trigger OnValidate();
            BEGIN
                MountDescription;
            END;


        }
        field(65; "Description Line 1"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description Line 1', ESP = 'Descripci�n L�nea 1';
            Description = 'QB 1.10.29 - JAV 29/03/22 Descripci�n a usar en facturas y en efectos';

            trigger OnValidate();
            BEGIN
                Description := COPYSTR("Description Line 1" + ' ' + "Description Line 2", 1, MAXSTRLEN(Description));
            END;


        }
        field(66; "Description Line 2"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description Line 2', ESP = 'Descripci�n L�nea 2';
            Description = 'QB 1.10.29 - JAV 29/03/22 Descripci�n a usar en la segunda l�nea de las factura';

            trigger OnValidate();
            BEGIN
                Description := COPYSTR("Description Line 1" + ' ' + "Description Line 2", 1, MAXSTRLEN(Description));
            END;


        }
        field(67; "Budget Item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Item', ESP = 'Partida Presupuestaria/U.O.';
            Description = 'QB 1.10.29 - JAV 29/03/22 [TT] Partida presupuestaria en la que imputar el anticipo';


        }
        field(68; "For Document Type"; Option)
        {
            OptionMembers = "None","PurchaseOrder","PurchaseInvoice","SalesOrder","SalesInvoice";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Para que Tipo de Documento';
            OptionCaptionML = ESP = '" ,N/Pedido,N/Factura,Pedido,Factura"';

            Description = 'QB 1.10.33 - JAV 08/04/22 Campo interno que indica el tipo de documento sobre el que se solicita el anticipo, para poder filtrar el campo 64';


        }
        field(80; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';
            Description = 'QB 1.10.36 - JAV 20/04/22: - [TT] Indica la forma de pago con la que se van a generar el documento de anticipo';

            trigger OnValidate();
            BEGIN
                PaymentMethod.INIT;
                IF "Payment Method Code" <> '' THEN
                    PaymentMethod.GET("Payment Method Code");
            END;


        }
        field(81; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Terms Code', ESP = 'C�d. t�rminos pago';
            Description = 'QB 1.10.36 - JAV 20/04/22: - [TT] Indica que T�rminos de pago se usar� al generar el documento de anticipo';

            trigger OnValidate();
            BEGIN
                PaymentTerms.INIT;
                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Document Date");
                    //Q19090-
                    IF Rec."Account Type" = Rec."Account Type"::Customer THEN
                        DueDateAdjust.SalesAdjustDueDate("Due Date", "Document Date", PaymentTerms.CalculateMaxDueDate("Document Date"), Rec."Account No.")
                    ELSE
                        //PSM Q19090+
                        DueDateAdjust.PurchAdjustDueDate("Due Date", "Document Date", PaymentTerms.CalculateMaxDueDate("Document Date"), Rec."Account No.");
                END ELSE BEGIN
                    VALIDATE("Due Date", "Document Date");
                END;
            END;


        }
        field(82; "Due Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';

            trigger OnValidate();
            BEGIN
                IF PaymentTerms.GET("Payment Terms Code") THEN
                    PaymentTerms.VerifyMaxNoDaysTillDueDate("Due Date", "Document Date", FIELDCAPTION("Due Date"));
            END;


        }
        field(83; "Apply to Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Aplicado al anticipo';
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica sobre que l�nea de anticipo se ha aplicado una entrada, si no est� indicada se hizo sobre el total de anticipos y no sobre uno particular';


        }
        field(84; "Applied Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Apply to Entry No." = FIELD("Entry No.")));
            CaptionML = ESP = 'Importe Aplicado';
            Description = 'QB 1.10.49 - JAV 10/06/22: - [TT] Indica el importe aplicado al documento, sumando las aplicaciones y cancelaciones';


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Job No.", "Account Type", "TJ", "Account No.", "TC")
        {
            ;
        }
        key(key3; "Document No.", "Posting Date")
        {
            ;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.")
        {

        }
        fieldgroup(Brick; "Entry No.")
        {

        }
    }

    var
        //       QuoBuildingSetup@1100286020 :
        QuoBuildingSetup: Record 7207278;
        //       QBPrepaymentType@1100286001 :
        QBPrepaymentType: Record 7206993;
        //       Job@1100286003 :
        Job: Record 167;
        //       Customer@1100286004 :
        Customer: Record 18;
        //       Vendor@1100286005 :
        Vendor: Record 23;
        //       GeneralLedgerSetup@1100286002 :
        GeneralLedgerSetup: Record 98;
        //       PaymentMethod@1100286022 :
        PaymentMethod: Record 289;
        //       PaymentTerms@1100286023 :
        PaymentTerms: Record 3;
        //       FunctionQB@1100286009 :
        FunctionQB: Codeunit 7207272;
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
        //       JobCurrencyExchangeFunction@1100286008 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       QBPrepaymentManagement@1100286021 :
        QBPrepaymentManagement: Codeunit 7207300;
        //       DueDateAdjust@1100286024 :
        DueDateAdjust: Codeunit 10700;
        //       Amt@1100286007 :
        Amt: Decimal;
        //       Factor@1100286006 :
        Factor: Decimal;
        //       Txt000@1100286019 :
        Txt000: TextConst ESP = '   Total %1 %2 del Proyecto %3';
        //       Txt001@1100286018 :
        Txt001: TextConst ESP = '      Total %1 del Proyecto %2';
        //       Text02@1100286000 :
        Text02: TextConst ESP = 'No tiene acceso al proyecto %1';
        //       Txt010@1100286011 :
        Txt010: TextConst ESP = 'No ha definido el proyecto';
        //       Txt011c@1100286015 :
        Txt011c: TextConst ESP = 'Debe indicar un cliente v�lido';
        //       Txt011p@1100286014 :
        Txt011p: TextConst ESP = 'Debe indicar un proveedor v�lido';
        //       Txt012@1100286010 :
        Txt012: TextConst ESP = 'El importe debe ser mayor de cero';
        //       Txt013@1100286013 :
        Txt013: TextConst ESP = 'Debe indicar una fecha v�lida de documento y de registro';
        //       Txt014@1100286012 :
        Txt014: TextConst ESP = 'La fecha de documento no puede ser mayor a la de registro';
        //       Txt015@1100286016 :
        Txt015: TextConst ESP = 'Debe indicar el n� de documento del proveedor';
        //       Txt016@1100286017 :
        Txt016: TextConst ESP = 'Debe indicar el n�mero de documento del que solicita el anticipo';
        //       Txt020@1100286028 :
        Txt020: TextConst ESP = 'Liq.Parcial anticipo anticipo %1, pte. %2';
        //       Txt021@1100286027 :
        Txt021: TextConst ESP = 'Liquidaci�n del anticipo %1';
        //       Txt030@1100286026 :
        Txt030: TextConst ESP = 'Canc.Parcial anticipo %1, pte. %2';
        //       Txt031@1100286025 :
        Txt031: TextConst ESP = 'Cancelaci�n del anticipo %1';



    trigger OnInsert();
    begin
        "Entry No." := QBPrepaymentManagement.CalcEntryNo(Rec) + 1;
        if (not TC) and (not TJ) then begin
            "See in Pending" := (Amount = 0);
            "See in Posting" := (Amount <> 0);
        end;
        VALIDATE(Order);
    end;

    trigger OnModify();
    begin
        if (not TC) and (not TJ) then begin
            "See in Pending" := (Amount = 0);
            "See in Posting" := (Amount <> 0);
        end;
        VALIDATE(Order);
    end;

    trigger OnDelete();
    begin
        if (Rec.Amount <> 0) or (Rec."Approval Status" <> Rec."Approval Status"::Open) then
            ERROR('Solo puede eliminar anticipos abiertos.');

        if (Rec.TC) or (Rec.TJ) then
            ERROR('No puede eliminar l�neas de totales.');
    end;



    LOCAL procedure MountDescription()
    var
        //       txtAmount@1100286006 :
        txtAmount: Text;
        //       txt@1100286002 :
        txt: Text;
        //       Txt011@1100286005 :
        Txt011: TextConst ESP = '%1% sobre %2';
        //       Txt012@1100286004 :
        Txt012: TextConst ESP = 'Sobre %1';
        //       Txt013@1100286003 :
        Txt013: TextConst ESP = 'del %1%';
        //       i@1100286001 :
        i: Integer;
    begin
        if not QBPrepaymentType.GET("Prepayment Type") then begin
            QBPrepaymentType."Description for Invoices" := 'A cuenta %2 para el proyecto %3';
            QBPrepaymentType."Description for Bills" := 'A cuenta para el proyecto %3';
        end;

        if ("Base Amount" <> 0) and (Percentage <> 0) then
            txtAmount := STRSUBSTNO(Txt011, Percentage, "Base Amount")
        else if ("Base Amount" <> 0) then
            txtAmount := STRSUBSTNO(Txt012, "Base Amount")
        else if (Percentage <> 0) then
            txtAmount := STRSUBSTNO(Txt013, Percentage)
        else
            txtAmount := '';

        if ("Generate Document" = "Generate Document"::Invoice) then begin
            txt := STRSUBSTNO(QBPrepaymentType."Description for Invoices", FORMAT("For Document Type") + "For Document No.", txtAmount, "Job Descripcion", "Account Description");
            txt := DELCHR(txt, '<>', ' ');

            i := STRPOS(txt, '\');
            if (i < 1) or (i > MAXSTRLEN("Description Line 1")) then begin
                txt := DELCHR(txt, '=', '\');

                if (STRLEN(txt) <= MAXSTRLEN("Description Line 1")) then
                    i := STRLEN(txt) + 1
                else begin
                    i := MAXSTRLEN("Description Line 1") + 1;
                    repeat
                        i -= 1;
                    until (i = 1) or (COPYSTR(txt, i, 1) = ' ');
                end;
            end;

            "Description Line 1" := DELCHR(COPYSTR(txt, 1, i - 1), '<>', ' ');
            "Description Line 2" := DELCHR(COPYSTR(txt, i + 1, MAXSTRLEN("Description Line 2")), '<>', ' ');
        end else begin
            txt := STRSUBSTNO(QBPrepaymentType."Description for Bills", FORMAT("For Document Type") + "For Document No.", txtAmount, "Job Descripcion", "Account Description");
            txt := DELCHR(txt, '<>', ' ');

            "Description Line 1" := DELCHR(COPYSTR(txt, 1, MAXSTRLEN("Description Line 1")), '<>', ' ');
            "Description Line 2" := '';
        end;
        VALIDATE("Description Line 1");
    end;

    procedure CheckData()
    begin
        if (Rec."Job No." = '') then
            ERROR(Txt010);

        CASE "Account Type" OF
            "Account Type"::Customer:
                begin
                    if (not Customer.GET("Account No.")) then
                        ERROR(Txt011c);
                end;
            "Account Type"::Vendor:
                begin
                    if (not Vendor.GET("Account No.")) then
                        ERROR(Txt011p);
                    if ("External Document No." = '') then
                        ERROR(Txt015);
                end;
        end;

        if ("not Approved Amount" <= 0) then
            ERROR(Txt012);

        if ("Document Date" = 0D) or ("Posting Date" = 0D) then
            ERROR(Txt013);

        VALIDATE("Document Date");

        //JAV 08/04/22: - QB 1.10.33 Verificar documento obligatorio
        if (QBPrepaymentType.GET("Prepayment Type")) then begin
            if (QBPrepaymentType."Document Mandatory") and ("For Document No." = '') then
                ERROR(Txt016);
        end;
        VALIDATE("For Document No.");
    end;

    //     LOCAL procedure StrPad (pText@1100286000 : Text;pLen@1100286001 : Integer;pCar@1100286002 :
    LOCAL procedure StrPad(pText: Text; pLen: Integer; pCar: Text): Text;
    begin
        exit(PADSTR(pText, pLen, pCar));
    end;

    //     LOCAL procedure NumPad (pInteger@1100286000 : Integer;pLen@1100286001 :
    LOCAL procedure NumPad(pInteger: Integer; pLen: Integer): Text;
    var
        //       txt@1100286002 :
        txt: Text;
    begin
        txt := PADSTR('', pLen, '0') + FORMAT(pInteger);
        exit(COPYSTR(txt, STRLEN(txt) - pLen));
    end;

    /*begin
    //{
//      PSM 19/04/22: - QB 1.10.36 A�adir en el table relation del campo 64 que los documentos deben estar lanzados para poder solicitar un anticipo sobre estos, de esta manera
//                                 si hay circuito de aprobaci�n esto obligar� a que est�n aprobados, y si no lo hay al menos sigue el est�ndar de Navision del uso de documentos lanzados.
//      JAV 09/06/22: - QB 1.10.49 Se cambia el nombre del campo 23 a "Entry Type" para poder localizarlo mejor y cambiarlo para ampliar los estados con el de cancelado
//                                 Los estados distribuyen de otra forma para poder a�adir mas sin problemas ni alterar lo que ya est� desarrollado
//      JAV 10/06/22: - QB 1.10.49 Se a�ade el campo 83 "Apply to Entry No" que indica sobre que anticipo se ha aplicado una entrada, si no est� indicada se hizo sobre el total de anticipos
//                                 Se a�ade el campo Order para mantener ordenados los registros en la pantalla
//                                 Se cambia Pendiente por No Aprobado que es mas informativo y se a�aden campos para importes pendientes del documento original
//      PSM 28/02/23: - Q19090 Llamar a la funci�n SalesAdjustDueDate cuando sea un anticipo de cliente
//
//      OJO: Esta tabla est� relacionada con la tabla 7206998 "QB Prepayment Data", si se introducen campos hay que verificar la otra por el transferfiels
//    }
    end.
  */
}







