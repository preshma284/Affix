table 7207336 "QBU Measurement Header"
{


    CaptionML = ENU = 'Measurement Header', ESP = 'Cabecera Medici�n';
    LookupPageID = "Measurement List";

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
        field(2; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(3; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(4; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                //-Q19892
                IF "Document Type" = "Document Type"::Certification THEN BEGIN
                    IF "Cert Measurement Date" <> 0D THEN
                        IF "Posting Date" < "Cert Measurement Date" THEN ERROR('La fecha no puede ser anterior a %1', "Cert Measurement Date");
                END;
                IF "Document Type" = "Document Type"::Measuring THEN BEGIN
                    IF "Posting Date" < "Measurement Date" THEN "Measurement Date" := "Posting Date";
                END;
                //+Q19892
            END;


        }
        field(5; "Send Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha entrega';


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
        field(11; "OLD_Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Measurement Lines"."Med. Term PEC Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe a PEC';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(12; "OLD_Amount To Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term PEC Amount" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Amount To Source', ESP = 'Importe a origen';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�d. auditor�a';


        }
        field(14; "OLD_Certification Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Measurement Lines"."Med. Term PEC Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Certification Amount', ESP = 'Importe certificaci�n';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(15; "OLD_Certif. Amount to Source"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term PEC Amount" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Certif. Amount to Source', ESP = 'Importe a origen certif.';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(16; "Measurement Date"; Date)
        {


            CaptionML = ENU = 'Measurement Date', ESP = 'Fecha medici�n';

            trigger OnValidate();
            BEGIN
                //-Q19892
                "Certification Date" := "Measurement Date";
                IF "Document Type" = "Document Type"::Measuring THEN BEGIN
                    IF "Posting Date" < "Measurement Date" THEN "Posting Date" := "Measurement Date";
                    IF "Certification Date" < "Measurement Date" THEN "Certification Date" := "Measurement Date";
                END;
                //+Q19892
            END;


        }
        field(17; "No. Measure"; Code[10])
        {


            CaptionML = ENU = 'No. Measure', ESP = 'N� de medici�n';

            trigger OnValidate();
            BEGIN
                //JAV 26/03/19: - Mejora en los textos de certificaci�n
                //"Text Measure" := Text52 + "No. Measure"
                IF ("Document Type" = "Document Type"::Measuring) THEN
                    "Text Measure" := Text100 + ' ' + "No. Measure"
                ELSE
                    "Text Measure" := Text101 + ' ' + "No. Measure";
            END;


        }
        field(18; "Last Measure"; Boolean)
        {
            CaptionML = ENU = 'Last Measure', ESP = 'Ultima medici�n';


        }
        field(19; "Text Measure"; Text[30])
        {
            CaptionML = ENU = 'Text Measure', ESP = 'Texto medici�n';


        }
        field(20; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Proyecto operativo"),
                                                                            "Job Type" = CONST("Operative"));


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                IF ("Job No." <> xRec."Job No.") THEN BEGIN
                    //Si existen l�neas y hemos cambiado el proyecto, hay que eliminarlas
                    MeasurementLines.RESET;
                    MeasurementLines.SETRANGE("Document No.", "No.");
                    IF NOT (MeasurementLines.ISEMPTY) THEN BEGIN
                        IF (CONFIRM(Text004, FALSE)) THEN
                            MeasurementLines.DELETEALL
                        ELSE
                            ERROR('');
                    END;


                    Job.GET("Job No.");
                    Job.TESTFIELD(Job."Bill-to Customer No.");
                    Job.TESTFIELD(Blocked, Job.Blocked::" ");
                    IF ("Document Type" = "Document Type"::Measuring) THEN
                        IF (Job."Card Type" <> Job."Card Type"::"Proyecto operativo") OR (Job."Job Type" <> Job."Job Type"::Operative) THEN
                            ERROR(Text001);
                    Description := Job.Description;

                    IF ("Cancel No." = '') THEN BEGIN //Si no estamos cancelando valido el cliente
                                                      //Si el proyecto es Multi-cliente no se establece en este momento, si no toma el principal
                        IF (Job."Multi-Client Job" = Job."Multi-Client Job"::ByCustomers) THEN
                            VALIDATE("Customer No.", '')
                        ELSE
                            VALIDATE("Customer No.", Job."Bill-to Customer No.");

                        Records.RESET;
                        Records.SETRANGE("Job No.", "Job No.");
                        IF (Records.COUNT = 1) THEN BEGIN
                            Records.FINDFIRST;
                            "Expedient No." := Records."No.";
                        END;
                    END;

                    //Si es una medici�n y existe, a�ado las l�neas anteriores
                    IF ("Document Type" = "Document Type"::Measuring) THEN
                        IF MODIFY THEN
                            AddLines;

                    //Como hemos cambiado el proyecto busco el nro de medici�n correcto
                    SetNoMeasure;
                END;
            END;


        }
        field(21; "Customer No."; Code[20])
        {
            TableRelation = "Customer";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';

            trigger OnValidate();
            BEGIN
                IF ("Customer No." <> '') AND ("Customer No." <> xRec."Customer No.") THEN
                    IF NOT QBTableSubscriber.ValidateCustomerFromJob("Job No.", "Customer No.") THEN
                        ERROR(Text002);

                GetDataCustomer;
                IF "Job No." <> '' THEN
                    CreateDim(DATABASE::Job, "Job No.", DATABASE::Customer, "Customer No.");
            END;

            trigger OnLookup();
            VAR
                //                                                               cust@1100286000 :
                cust: Code[20];
            BEGIN
                //Solo saca los clientes del proyecto
                IF QBTableSubscriber.LookupCustomerFromJob("Job No.", "Customer No.", cust) THEN
                    VALIDATE("Customer No.", cust);
            END;


        }
        field(22; "OLD_Measure Type"; Option)
        {
            OptionMembers = "Source","Term";

            CaptionML = ENU = 'Measure Type', ESP = 'Tipo medici�n';
            OptionCaptionML = ENU = 'Source,Term', ESP = 'Origen,Periodo';

            Description = '### ELIMINAR ### ya no se usa';

            trigger OnValidate();
            BEGIN
                IF ExistLines THEN
                    ERROR(Text006, "No.");
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
        field(32; "Measured Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measurements"."Amount Document" WHERE("Job No." = FIELD("Job No."),
                                                                                                                 "Cancel No." = CONST(''),
                                                                                                                 "Cancel By" = CONST('')));
            CaptionML = ENU = 'Measured Amount', ESP = 'Importe medido';
            Description = '[ Estad�sticas: sumatorio Importe total del Hist. medici�n para el proyecto]';
            Editable = false;


        }
        field(33; "Certified Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Post. Certifications"."Amount Document" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Cancel No." = CONST(''),
                                                                                                                   "Cancel By" = CONST('')));
            CaptionML = ENU = 'Certified Amount', ESP = 'Importe certificado';
            Description = '[ Estad�sticas: sumatorio Importe total del Hist. certificaci�n para el proyecto]';
            Editable = false;


        }
        field(34; "Invoiced Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Post. Certifications"."Amount Invoiced" WHERE("Job No." = FIELD("Job No."),
                                                                                                                   "Cancel No." = CONST(''),
                                                                                                                   "Cancel By" = CONST(''),
                                                                                                                   "Invoiced Certification" = CONST(true)));
            CaptionML = ENU = 'Invoiced Amount', ESP = 'Importe facturado';
            Description = '[ Estad�sticas: sumatorio Importe total del Hist. certificaci�n facturadas para el proyecto]';
            Editable = false;


        }
        field(35; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            BEGIN
                IF NOT UserMgt.CheckRespCenter(3, "Responsibility Center") THEN
                    ERROR(Text007, Respcenter.TABLECAPTION, FunctionQB.GetUserJobResponsibilityCenter());
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
        field(41; "Certification Type"; Option)
        {
            OptionMembers = "Normal","Price adjustment";
            CaptionML = ENU = 'Certification Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Normal,Price adjustment', ESP = 'Normal,Ajuste precios';

            Description = 'QB 1.08.30 JAV 29/03/21 El tipo tambi�n se usa para mediciones';


        }
        field(42; "Redetermination Code"; Code[20])
        {
            TableRelation = "Job Redetermination"."Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                   "Validated" = CONST(true),
                                                                                                   "Adjusted" = CONST(false));


            CaptionML = ENU = 'Redetermination Code', ESP = 'C�digo redeterminaci�n';

            trigger OnValidate();
            BEGIN
                FunWriteSettings;
            END;


        }
        field(43; "Document Type"; Enum "Sales Line Type")
        {
            //OptionMembers = "Measuring","Certification";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            //OptionCaptionML = ENU = 'Measuring,Certification', ESP = 'Medici�n,Certificaci�n';

            Description = 'Medici�n o Certificaci�n';


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
                /*To be Tested*/
                // WITH MeasurementHeader DO BEGIN
                MeasurementHeader := Rec;
                TestNoSeries;
                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := MeasurementHeader;
                // END;
            END;


        }
        field(46; "OLD_Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';
            Description = '### ELIMINAR ### no se usa';


        }
        field(48; "Certification Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de Certificaci�n';

            trigger OnValidate();
            BEGIN
                //-Q19892
                IF "Document Type" = "Document Type"::Certification THEN BEGIN
                    IF "Cert Measurement Date" <> 0D THEN
                        IF "Certification Date" < "Cert Measurement Date" THEN ERROR('La fecha no puede ser anterior a %1', "Cert Measurement Date");
                END;
                IF "Document Type" = "Document Type"::Measuring THEN BEGIN
                    IF "Certification Date" < "Measurement Date" THEN ERROR('La fecha no puede ser anterior a %1', "Measurement Date");
                END;
                //+Q19892
            END;


        }
        field(49; "OLD_Total Amount Certification"; Decimal)
        {
            CaptionML = ENU = 'Total Amount Certification', ESP = 'Importe total certificaci�n';
            Description = '### ELIMINAR ### no se usa';


        }
        field(50; "OLD_Invoiced Quantity"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Quantity', ESP = 'Cantidad facturada';
            Description = '### ELIMINAR ### no se usa';


        }
        field(51; "Bill-to No. Customer"; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Bill-to No. Customer', ESP = 'Factura a N� cliente';


        }
        field(52; "OLD_Cod. Payment Terms"; Code[10])
        {
            TableRelation = "Payment Terms";
            CaptionML = ENU = 'Cod. terminos pago', ESP = 'C�d. t�rminos pago';
            Description = '### ELIMINAR ### no se usa';


        }
        field(53; "OLD_Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';
            Description = '### ELIMINAR ### no se usa';


        }
        field(54; "OLD_% Payment Discount"; Decimal)
        {
            CaptionML = ENU = '% Payment Discount', ESP = '% Dto. P.P.';
            Description = '### ELIMINAR ### no se usa';


        }
        field(55; "OLD_Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            CaptionML = ENU = 'Cod. forma pago', ESP = 'C�d. forma pago';
            Description = '### ELIMINAR ### no se usa';


        }
        field(56; "OLD_Payment In-Code"; Code[20])
        {
            CaptionML = ENU = 'Payment In-Code', ESP = 'Pago en-C�digo';
            Description = '### ELIMINAR ### no se usa';


        }
        field(57; "OLD_Customer Bank Code"; Code[20])
        {
            TableRelation = "Customer Bank Account"."Code" WHERE("Customer No." = FIELD("Bill-to No. Customer"));
            CaptionML = ENU = 'Customer Bank Code', ESP = 'C�d. banco cliente';
            Description = '### ELIMINAR ### no se usa';


        }
        field(59; "OLD_Phase Code"; Code[10])
        {
            CaptionML = ENU = 'Phase Code', ESP = 'C�d. fase';
            Description = '### ELIMINAR ### no se usa';


        }
        field(60; "OLD_Appraisal Company"; Code[10])
        {
            CaptionML = ENU = 'Entidad tasadora', ESP = 'Entidad tasadora';
            Description = '### ELIMINAR ### no se usa';


        }
        field(61; "OLD_Promotion Job"; Boolean)
        {
            CaptionML = ENU = 'Promotion Job', ESP = 'Proyecto promoci�n';
            Description = '### ELIMINAR ### no se usa';


        }
        field(62; "% Measure Proposed"; Decimal)
        {


            CaptionML = ENU = '% Measure Proposed', ESP = '% Propuesto de Medici�n';

            trigger OnValidate();
            BEGIN
                MeasurementLines.RESET;
                MeasurementLines.SETRANGE("Document No.", "No.");
                IF MeasurementLines.FINDFIRST THEN
                    REPEAT
                        MeasurementLines.VALIDATE("Med. % Measure", "% Measure Proposed");
                        MeasurementLines.MODIFY;
                    UNTIL MeasurementLines.NEXT = 0;
            END;


        }
        field(70; "Cancel No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancela la medici�n';
            Description = 'JAV 31/07/19: - Indica la que se ha cancelado con este registro';
            Editable = false;


        }
        field(71; "Cancel By"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cancelada por';
            Description = 'JAV 31/07/19: - Indica la medici�n que cancela la actual';
            Editable = false;


        }
        field(81; "Sum Ant Med"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term Amount" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Measured Amount', ESP = 'Suma Anterior Mediciones';
            Description = 'Suma anterior a PEM de las mediciones registradas';
            Editable = false;


        }
        field(82; "Sum Ant Cert"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Cert Term PEM amount" WHERE("Job No." = FIELD("Job No.")));
            CaptionML = ENU = 'Measured Amount', ESP = 'Suma Anterior Certificaciones';
            Description = 'Suma anterior a PEM de las certificaciones registradas';
            Editable = false;


        }
        field(83; "Sum Term Med"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Measurement Lines"."Med. Term PEM Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Suma Periodo Mediciones';
            Description = 'Suma a PEM de las l�neas de mediciones del periodo';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(84; "Sum Term Cert"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Measurement Lines"."Cert Term PEM amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Suma Periodo Certificaciones';
            Description = 'Suma a PEM de las l�neas de certificaciones del periodo';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(90; "Amount Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'A origen';


        }
        field(91; "Amount Previous"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Anterior';


        }
        field(92; "Amount Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Periodo';


        }
        field(93; "Amount GG"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'GG';
            Editable = false;


        }
        field(94; "Amount BI"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'BI';
            Editable = false;


        }
        field(95; "Amount Low"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Baja';
            Editable = false;


        }
        field(96; "Amount Document"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe';
            Editable = false;


        }
        field(120; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.00 - JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(121; "OLD_Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(122; "OLD_Approval Coment"; Text[80])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(123; "OLD_Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '### ELIMINAR ### no se usa';


        }
        field(500; "Cert Measurement Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Fecha Medicion de Certificacion';
            Description = 'Q19892 Esta fecha vendr� de la certificacion para no poner fechas anteriores de certificacion ni registro en certificacion';


        }
        field(50000; "Expedient No."; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));


            DataClassification = CustomerContent;
            CaptionML = ENU = 'Expedient No.', ESP = 'N� Expediente';
            Description = 'GAP029';

            trigger OnValidate();
            VAR
                //                                                                 Expedient@100000000 :
                Expedient: Record 7207393;
            BEGIN
                //GAP029 -
                IF ("Expedient No." <> '') THEN BEGIN
                    Job.GET("Job No.");
                    Expedient.GET("Job No.", "Expedient No.");
                    "Customer No." := Expedient."Customer No.";
                    CreateDim(DATABASE::Job, "Job No.", DATABASE::Customer, "Customer No.");
                    VALIDATE("Customer No.");
                END;
                //GAP029 +
            END;


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("Certification"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       PieceworkSetup@7001100 :
        PieceworkSetup: Record 7207279;
        //       MeasurementLines@7001104 :
        MeasurementLines: Record 7207337;
        //       MeasurementHeader@7001109 :
        MeasurementHeader: Record 7207336;
        //       QBCommentLine@7001103 :
        QBCommentLine: Record 7207270;
        //       MeasureLinesBillofItem@7001102 :
        MeasureLinesBillofItem: Record 7207395;
        //       Text001@1100286012 :
        Text001: TextConst ENU = 'Selected Job is not in Order Status', ESP = 'El proyecto seleccionado no es un proyecto operativo';
        //       Text002@1100286011 :
        Text002: TextConst ESP = 'El cliente no est� en el proyecto.';
        //       Text003@1100286013 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text004@1100286009 :
        Text004: TextConst ESP = 'El documento tiene l�neas, si cambia el proyecto se eliminar�n, �contin�a?';
        //       Text005@7001108 :
        Text005: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Has cambiado una dimension.\\Quiere actualizar las lineas?';
        //       Job@7001111 :
        Job: Record 167;
        //       Currency@1100286010 :
        Currency: Record 4;
        //       recCustomer@7001113 :
        recCustomer: Record 18;
        //       Text006@7001114 :
        Text006: TextConst ENU = 'Measure Type cannot be changed because lines exist for measurment %1', ESP = 'No puede cambiar el tipo de medici�n porque existen l�neas para la medici�n %1';
        //       Text007@7001115 :
        Text007: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Respcenter@7001117 :
        Respcenter: Record 5714;
        //       Text100@1100286001 :
        Text100: TextConst ENU = 'Measure No.: ', ESP = 'Medici�n N�';
        //       Text101@1100286000 :
        Text101: TextConst ENU = 'Measure No.: ', ESP = 'Certificaci�n N�';
        //       Records@1100286008 :
        Records: Record 7207393;
        //       NoSeriesMgt@1100286007 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       DimMgt@1100286005 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       UserMgt@1100286004 :
        UserMgt: Codeunit 5700;
        //       FunctionQB@1100286003 :
        FunctionQB: Codeunit 7207272;
        //       QBTableSubscriber@1100286002 :
        QBTableSubscriber: Codeunit 7207347;
        //       OldDimSetID@1100286006 :
        OldDimSetID: Integer;



    trigger OnInsert();
    var
        //                JobFilter@1100286000 :
        JobFilter: Text;
    begin
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;
        InitRecord;
    end;

    trigger OnDelete();
    begin
        MeasurementLines.LOCKTABLE;

        MeasurementLines.SETRANGE("Document No.", "No.");
        MeasurementLines.DELETEALL;

        if "Document Type" = "Document Type"::Measuring then begin
            QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::Measure);
            QBCommentLine.SETRANGE("No.", "No.");
            QBCommentLine.DELETEALL;
        end;

        if "Document Type" = "Document Type"::Certification then begin
            QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::Certification);
            QBCommentLine.SETRANGE("No.", "No.");
            QBCommentLine.DELETEALL;
        end;

        MeasureLinesBillofItem.SETRANGE("Document Type", "Document Type");
        MeasureLinesBillofItem.SETRANGE("Document No.", "No.");
        MeasureLinesBillofItem.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        PieceworkSetup.GET;
        CASE "Document Type" OF
            "Document Type"::Measuring:
                PieceworkSetup.TESTFIELD("Series Measure No.");
            "Document Type"::Certification:
                PieceworkSetup.TESTFIELD("Series Certification No.");
        end;
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        //-Q13152
        PieceworkSetup.GET;
        CASE "Document Type" OF
            "Document Type"::Measuring:
                exit(PieceworkSetup."Series Measure No.");
            "Document Type"::Certification:
                exit(PieceworkSetup."Series Certification No.");
        end;
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin

        //exit(PieceworkSetup."Posted Invoice Nos.");
    end;

    procedure InitRecord()
    begin
        PieceworkSetup.GET;
        CASE "Document Type" OF
            "Document Type"::Measuring:
                if ("No. Series" <> '')
                   then
                    "Posting No. Series" := "No. Series"
                else
                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", PieceworkSetup."Series Measure No.");
            "Document Type"::Certification:
                if ("No. Series" <> '')
                  then
                    "Posting No. Series" := "No. Series"
                else
                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", PieceworkSetup."Series Certification No.");
        end;

        //JAV 15/10/19: - Por defecto la fecha de certificaci�n es la de medici�n, JAV 18/10/21: - QB 1.09.22 Solo se cambian las fechas en este punto
        if ("Posting Date" = 0D) then begin
            VALIDATE("Posting Date", WORKDATE);
            "Certification Date" := "Posting Date";
            "Measurement Date" := "Posting Date";
            "Send Date" := "Posting Date";
        end;

        //JAV 15/10/19: - Se pasa a una funci�n la b�queda del "No. Measure" para que se pueda llamar desde mas lugares
        SetNoMeasure;
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
        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", "No.");
        exit(not MeasurementLines.ISEMPTY);
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text005) then
            exit;

        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", "No.");
        MeasurementLines.LOCKTABLE;
        if MeasurementLines.FINDSET then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(MeasurementLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if MeasurementLines."Dimension Set ID" <> NewDimSetID then begin
                    MeasurementLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      MeasurementLines."Dimension Set ID", MeasurementLines."Shortcut Dimension 1 Code", MeasurementLines."Shortcut Dimension 2 Code");
                    MeasurementLines.MODIFY;
                end;
            until MeasurementLines.NEXT = 0;
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
        //Adding the argument as needed for GetDefaultDimID method
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
        if recCustomer.GET("Customer No.") then begin
            Name := recCustomer.Name;
            "Name 2" := recCustomer."Name 2";
            Address := recCustomer.Address;
            "Address 2" := recCustomer."Address 2";
            City := recCustomer.City;
            Contact := recCustomer.Contact;
            County := recCustomer.County;
            "Post Code" := recCustomer."Post Code";
            "Bill-to No. Customer" := recCustomer."Bill-to Customer No.";
        end else begin
            Name := '';
            "Name 2" := '';
            Address := '';
            "Address 2" := '';
            City := '';
            Contact := '';
            County := '';
            "Post Code" := '';
            "Bill-to No. Customer" := '';
        end;
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLines then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure FunWriteSettings()
    var
        //       locrecCertRedetermination@1100240000 :
        locrecCertRedetermination: Record 7207438;
        //       locrecMeasurementLines@1100240001 :
        locrecMeasurementLines: Record 7207337;
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
        locrecCertRedetermination.SETRANGE("Job No.", "Job No.");
        locrecCertRedetermination.SETRANGE("Redetermination Code", "Redetermination Code");
        locrecCertRedetermination.SETFILTER("Certified Quantity to Adjust", '<>0');
        if locrecCertRedetermination.FINDSET then
            repeat
                CLEAR(locrecMeasurementLines);
                locrecMeasurementLines.VALIDATE("Document type", "Document Type");
                locrecMeasurementLines.VALIDATE("Document No.", "No.");
                locIntLastLine := locIntLastLine + 10000;
                locrecMeasurementLines.VALIDATE("Line No.", locIntLastLine);
                locrecMeasurementLines.INSERT(TRUE);
                locrecMeasurementLines."Job No." := "Job No.";
                locrecMeasurementLines.VALIDATE("Piecework No.", locrecCertRedetermination."Piecework Code");
                locrecMeasurementLines."Measurement Adjustment" := locrecCertRedetermination."Certified Quantity to Adjust";
                locrecMeasurementLines."Previous Redetermined Price" := locrecCertRedetermination."Previous Unit Price";
                locrecMeasurementLines."Last Price Redetermined" := locrecCertRedetermination."Unit Price Redetermined";
                locrecMeasurementLines."Adjustment Redeterm. Prices" := locrecCertRedetermination."Unit Price Redetermined" -
                                                                locrecCertRedetermination."Previous Unit Price";
                locrecMeasurementLines."Med. Term PEC Amount" := ROUND(locrecMeasurementLines."Measurement Adjustment" * locrecMeasurementLines."Adjustment Redeterm. Prices",
                                        locrecCurrency."Amount Rounding Precision");
                locrecMeasurementLines.MODIFY;
            until locrecCertRedetermination.NEXT = 0;
    end;

    procedure AssistEdit(): Boolean;
    begin
        TestNoSeries;
        if NoSeriesMgt.SelectSeries(GetNoSeriesCode, "No. Series", "No. Series") then begin
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure CalcAmountMeasureNoCertif(): Decimal;
    begin
        CALCFIELDS("Measured Amount", "Certified Amount");
        exit("Measured Amount" - "Certified Amount");
    end;

    procedure CalcAmountCertifNoInvoiced(): Decimal;
    begin
        CALCFIELDS("Certified Amount", "Invoiced Amount");
        exit("Certified Amount" - "Invoiced Amount");
    end;

    //     procedure FunFilterResponsibility (var MeasureToFilter@1000000000 :
    procedure FunFilterResponsibility(var MeasureToFilter: Record 7207336)
    begin

        if FunctionQB.GetUserJobResponsibilityCenter <> '' then begin
            MeasureToFilter.FILTERGROUP(2);
            MeasureToFilter.SETRANGE("Responsibility Center", FunctionQB.GetUserJobResponsibilityCenter);
            MeasureToFilter.FILTERGROUP(0);
        end;
    end;

    procedure SetNoMeasure()
    var
        //       HistMeasurements@1100286001 :
        HistMeasurements: Record 7207338;
        //       PostCertifications@1100286000 :
        PostCertifications: Record 7207341;
    begin
        //JAV 02/04/19: - Buscamos la �ltima referencia de medicion y le asignamos la siguiente
        //JAV 22/09/19: - No consideramos ni las canceladas ni las que cancelan en la b�squeda del n�mero de la medici�n
        //JAV 15/10/19: - Se pasa a una funci�n la b�queda del "No. Measure" para que se pueda llamar desde mas lugares

        if ("Job No." <> '') then begin
            "No. Measure" := '0';

            MeasurementHeader.RESET;
            MeasurementHeader.SETRANGE("Document Type", Rec."Document Type");
            MeasurementHeader.SETRANGE("Job No.", "Job No.");
            MeasurementHeader.SETFILTER("Cancel No.", '=%1', '');
            MeasurementHeader.SETFILTER("Cancel By", '=%1', '');
            if (MeasurementHeader.FINDSET(FALSE)) then
                repeat
                    if (MeasurementHeader."No." <> "No.") and ("No. Measure" < MeasurementHeader."No. Measure") then
                        "No. Measure" := MeasurementHeader."No. Measure";
                until MeasurementHeader.NEXT = 0;

            if ("Document Type" = "Document Type"::Measuring) then begin
                HistMeasurements.RESET;
                HistMeasurements.SETRANGE("Job No.", "Job No.");
                HistMeasurements.SETFILTER("Cancel No.", '=%1', '');
                HistMeasurements.SETFILTER("Cancel By", '=%1', '');
                if (HistMeasurements.FINDSET(FALSE)) then
                    repeat
                        if ("No. Measure" < HistMeasurements."No. Measure") then
                            "No. Measure" := HistMeasurements."No. Measure";
                    until HistMeasurements.NEXT = 0;
            end else begin
                PostCertifications.RESET;
                PostCertifications.SETRANGE("Job No.", "Job No.");
                PostCertifications.SETFILTER("Cancel No.", '=%1', '');
                PostCertifications.SETFILTER("Cancel By", '=%1', '');
                if (PostCertifications.FINDSET(FALSE)) then
                    repeat
                        if ("No. Measure" < PostCertifications."No. Measure") then
                            "No. Measure" := PostCertifications."No. Measure";
                    until PostCertifications.NEXT = 0;
            end;
            VALIDATE("No. Measure", INCSTR("No. Measure"));
        end;
        //JAV 02/04/19 fin
    end;

    procedure CalculateTotals()
    begin
        //JAV 20/02/21: - Calculo del total del documento
        if not Job.GET("Job No.") then
            Job.INIT;

        Currency.InitRoundingPrecision;

        CASE "Document Type" OF
            "Document Type"::Measuring:
                begin
                    CALCFIELDS("Sum Ant Med", "Sum Term Med");
                    "Amount Previous" := "Sum Ant Med";
                    "Amount Origin" := "Sum Ant Med" + "Sum Term Med";
                    "Amount Term" := "Amount Origin" - "Amount Previous";

                end;
            "Document Type"::Certification:
                begin
                    CALCFIELDS("Sum Ant Cert", "Sum Term Cert");
                    "Amount Previous" := "Sum Ant Cert";
                    "Amount Origin" := "Sum Ant Cert" + "Sum Term Cert";
                    ;    //"Sum Ant Cert" + "Sum Term Cert";
                    "Amount Term" := "Sum Term Cert";   //"Amount Origin" - "Amount Previous";
                end;
        end;
        "Amount GG" := ROUND("Amount Term" * Job."General Expenses / Other" / 100, Currency."Amount Rounding Precision");
        "Amount BI" := ROUND("Amount Term" * Job."Industrial Benefit" / 100, Currency."Amount Rounding Precision");
        "Amount Low" := ROUND(("Amount Term" + "Amount GG" + "Amount BI") * Job."Low Coefficient" / 100, Currency."Amount Rounding Precision");
        "Amount Document" := ROUND("Amount Term" + "Amount GG" + "Amount BI" - "Amount Low", Currency."Amount Rounding Precision");
    end;

    //     procedure SetCaptions (var Captions@1100286000 :
    procedure SetCaptions(var Captions: ARRAY[10] OF Text)
    begin
        if not Job.GET("Job No.") then
            Job.INIT;

        Captions[1] := FIELDCAPTION("Amount Origin");
        Captions[2] := FIELDCAPTION("Amount Previous");
        Captions[3] := FIELDCAPTION("Amount Term");
        Captions[4] := FIELDCAPTION("Amount GG") + ' (' + FORMAT(Job."General Expenses / Other") + '%)';
        Captions[5] := FIELDCAPTION("Amount BI") + ' (' + FORMAT(Job."Industrial Benefit") + '%)';
        Captions[6] := FIELDCAPTION("Amount Low") + ' (' + FORMAT(Job."Low Coefficient") + '%)';
        Captions[7] := FIELDCAPTION("Amount Document");
    end;

    procedure AddLines()
    var
        //       MeasurementLines@1100286002 :
        MeasurementLines: Record 7207337;
        //       HistMeasureLines@1100286003 :
        HistMeasureLines: Record 7207339;
        //       LineNo@1100286001 :
        LineNo: Integer;
    begin
        if (not MeasurementHeader.GET("No.")) then //Si todav�a no existe la cabecera salgo
            exit;
        if ("Job No." = '') then    //Si no tiene proyecto salgo
            exit;

        MeasurementLines.RESET;
        MeasurementLines.SETRANGE("Document No.", Rec."No.");
        if (MeasurementLines.FINDLAST) then
            LineNo := MeasurementLines."Line No."
        else
            LineNo := 0;

        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Job No.", "Job No.");
        //HistMeasureLines.SETFILTER("Document No.", '<%1', Rec."No.");  //JAV 27/07/21: - QB 1.09.14 Esto no hace nada realmente, no tiene sentido usarlo
        if HistMeasureLines.FINDSET then
            repeat
                MeasurementLines.RESET;
                MeasurementLines.SETRANGE("Document No.", Rec."No.");
                MeasurementLines.SETRANGE("Piecework No.", HistMeasureLines."Piecework No.");
                if (MeasurementLines.ISEMPTY) then begin
                    MeasurementLines.TRANSFERFIELDS(HistMeasureLines);

                    LineNo += 10000;
                    MeasurementLines."Document No." := Rec."No.";
                    MeasurementLines."Line No." := LineNo;
                    MeasurementLines."Document type" := Rec."Document Type";
                    MeasurementLines.VALIDATE("Piecework No.");
                    MeasurementLines.VALIDATE("Med. Term Measure", 0);
                    MeasurementLines.INSERT;
                end;
            until HistMeasureLines.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 26/03/19: - Mejora en los textos de certificaci�n
//      JAV 02/04/19: - Buscamos la �ltima referencia de medicion y le asignamos la siguiente en el alta
//      JAV 09/07/19: - Se cambia el campo status por el "Card type" y se mira que sea un proyecto operativo, se cambia el texto del error relacionado
//      JAV 22/09/19: - No consideramos ni las canceladas ni las que cancelan en la b�squeda del n�mero de la medici�n
//      JAV 15/10/19: - Se pasa a una funci�n la b�queda del "No. Measure" para que se pueda llamar desde mas lugares
//                    - Se eliminan los campos 47 "Certification No." y 58 "Certification Text", se usa en su lugar el 17 y 19
//                    - Se elimina el campo 5 "Posting Description" que no se usa
//                    - Se eliminan los campos 14 "Measure Date" y 32 "Certification Date" de las l�neas de medici�n que no se usan
//                    - Por defecto la fecha de certificaci�n es la de medici�n
//      JDC 30/07/19: - KALAM GAP029 Added field 50000 "Expedient No."
//      JAV 25/05/21: - QB 1.08.45 Se quitan los filtros del OnInsert que deben estar en la page y se pasa el nro de medicion al InitRecord
//      DGG 26/06/21: - Q13152 Se amplia a 20 el tama�o de parametro devuelto por la funci�n GetNoSeriesCode
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de la funci�n GetPostingNoSeriesCode de 10 a 20
//      AML 14/07/23: - Q19892 Se iguala la fecha de certificaci�n a la fecha de medici�n.
//    }
    end.
  */
}







