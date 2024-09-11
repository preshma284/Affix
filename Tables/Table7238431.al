table 7238431 "QBU Purch. & Pay. Setup Ext."
{


    ;
    fields
    {
        field(1; "Record ID"; RecordID)
        {
            DataClassification = ToBeClassified;


        }
        field(7207302; "QB_Comision - Tipo Individual"; Option)
        {
            OptionMembers = "Desglosada","SinDesglose";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Opc. Asiento Individual';
            OptionCaptionML = ESP = 'Desglosada,Sin Desglosar';

            Description = 'QRE';


        }
        field(7207303; "QB_Create Vendor from Contact"; Option)
        {
            OptionMembers = "With Serial","With VAT Reg. No.";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Crear Proveedor desde Contacto';
            OptionCaptionML = ESP = 'Con Serie,Con CIF/NIF';

            Description = 'QRE 1.00.00 16099';


        }
        field(7238180; "QB_Comp. no. docext. mismo año"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Committed same year external doc. no.', ESP = 'Comp. n� doc. ext. mismo a�o';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238181; "QB_Expense Payment Method Code"; Code[10])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expense Payment Method Code', ESP = 'C�d. forma pago defecto interfaz gasto';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 PaymentMethodL@1100254000 :
                PaymentMethodL: Record 289;
                //                                                                 PaymentMethod2L@1100254001 :
                PaymentMethod2L: Record 289;
            BEGIN

                // TestAllowModifyInterfaceData;
                //
                //
                // IF ("QB_Expense Payment Method Code" <> '') THEN BEGIN 
                //  PaymentMethodL.RESET;
                //  PaymentMethodL.GET("QB_Expense Payment Method Code");
                //  PaymentMethodL.TESTFIELD("Invoices to Cartera",FALSE);
                //  PaymentMethodL.TESTFIELD("QB_Payment process",FALSE);
                //  PaymentMethodL.TESTFIELD("Create Bills",FALSE);
                //  IF (PaymentMethodL.QB_Type = PaymentMethodL.QB_Type::Ventas) THEN BEGIN 
                //    PaymentMethod2L.FIELDERROR(QB_Type);
                //  END;
                // END;
            END;


        }
        field(7238182; "QB_Expense Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expense Payment Terms Code', ESP = 'C�d. t�rminos pago defecto interfaz gasto';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238183; "Tipo retencion garantia ADEA"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Retention security type ADEA', ESP = 'Tipo retenci�n garant�a ADEA';
            Description = 'QRE 1.00.00 15452  --- OJO Esto entra en conflicto con nuestro m�dulo de retenciones, se debe eliminar';


        }
        field(7238184; "Tipo retencion prof. ADEA"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Professionals retention rate ADEA', ESP = 'Tipo retenci�n profesionales ADEA';
            Description = 'QRE 1.00.00 15452  --- OJO Esto entra en conflicto con nuestro m�dulo de retenciones, se debe eliminar';


        }
        field(7238185; "Conf. ruta entrada"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238186; "Conf. ruta salida"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238187; "Conf. ruta errores"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238188; "email notificacion"; Text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238189; "Conf. ruta entrada IBI"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238190; "Conf. ruta salida IBI"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238191; "Conf. ruta vinculos IBI"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238192; "Grupo registro IVA prod."; Code[10])
        {
            TableRelation = "VAT Product Posting Group"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro IVA prod.';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238193; "Grupo registro IVA negocio"; Code[10])
        {
            TableRelation = "VAT Business Posting Group"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Bus. Posting Group', ESP = 'Grupo registro IVA negocio';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238194; "Grupo contable negocio"; Code[10])
        {
            TableRelation = "Gen. Business Posting Group"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Gen. Business Posting Group', ESP = 'Grupo contable negocio';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238195; "Tipo documento identif."; Option)
        {
            OptionMembers = "CIF/NIF/NIE","Pasaporte","Tarjeta de residencia","Nº IVA Intracomunitario","Nº Identificación";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo documento identif.';
            OptionCaptionML = ESP = 'CIF/NIF/NIE,Pasaporte,Tarjeta de residencia,N� IVA Intracomunitario,N� Identificaci�n';

            Description = 'QRE 1.00.00 15452';


        }
        field(7238196; "Cod. forma pago IBI"; Code[10])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238197; "Dir. Email notificaciones"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Dir. Email notificaciones';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238198; "Remitente envio notif."; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Remitente env�o notificaciones';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238199; "Recibir copia notificaciones"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibir copia notificaciones';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238200; "Email recep. copia notific."; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Email recepci�n copia notificaciones';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238201; "Perfil envio factura"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238202; "Perfil envio factura anulada"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238203; "Perfil envio pago factura"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238204; "Perfil envio pago fact. anul"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238205; "Cod. plant. pago agrup. fact."; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cod. plant. pago agrup. fact. doc cartera';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238206; "Perfil envio pago agrup. fact."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238207; "Cod. plant. pago agrup. fact.2"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cod. plant. pago agrup. fact. doc. cartera reg.';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238208; "Ruta ficheros pagos agrupados"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238209; "Dir. Email envio notif. ADEA"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Dir. Email notificaciones';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238210; "Remitente envio notif. ADEA"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Remitente env�o notificaciones';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238211; "Path reinvoice lease expenses"; Text[200])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Conf. path re-invoicing expenses leasing', ESP = 'Conf. ruta refacturaci�n gastos arrendamiento';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238212; "Cod. clasif1 ob. fact/abo cprs"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Classification code 1 building work invoice/credit cprs', ESP = 'C�d. clasif1 ob. fact/abo cprs';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238213; "Devengo IVA dif. retenciones"; Option)
        {
            OptionMembers = "No aplicar en devolución","Aplicar en devolución";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT accrual deferred retentions', ESP = 'Devengo IVA dif. retenciones';
            OptionCaptionML = ENU = 'Do not apply in return,Apply in return', ESP = 'No aplicar en devoluci�n,Aplicar en devoluci�n';

            Description = 'QRE 1.00.00 15452';


        }
        field(7238216; "Tipo Gestion IVA Obligatorio"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo Gesti�n IVA Obligatorio';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238217; "No. serie anticipos"; Code[10])
        {
            TableRelation = "No. Series"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie anticipos';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238218; "No. serie dev. anticipos"; Code[10])
        {
            TableRelation = "No. Series"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie dev. anticipos';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238219; "No. serie registro anticipos"; Code[10])
        {
            TableRelation = "No. Series"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie registro anticipos';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238220; "No. serie reg. dev. anticipos"; Code[10])
        {
            TableRelation = "No. Series"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie registro devoluci�n anticipos';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238221; "SHE_Withholding Dim. Source"; Option)
        {
            OptionMembers = "Document Lines","Document Header";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Withholding Dimension Source', ESP = 'Origen dimensiones retenciones';
            OptionCaptionML = ENU = 'Document Lines,Document Header', ESP = 'L�neas documento,Cabecera documento';

            Description = 'QRE 1.00.00 15452';


        }
        field(7238222; "No. serie liq. Previsiones"; Code[10])
        {
            TableRelation = "No. Series"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie liq. Previsiones';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238223; "Texto registro gen. cartera"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Register text portfolio generation', ESP = 'Texto registro gen. cartera';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238224; "Comp. no. doc. ext. mismo año"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Committed same year external doc. no.', ESP = 'Comp. n� doc. ext. mismo a�o';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238225; "Comp. No. doc. ext. x fecha"; Option)
        {
            OptionMembers = "FechaRegistro","FechaEmision";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comp. N� doc. ext. por fecha';
            OptionCaptionML = ESP = 'Fecha Registro,Fecha Emision Documento';

            Description = 'QRE 1.00.00 15452';


        }
        field(7238229; "Liq Multiples Ant x Fact"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Liq. Multiples Anticipos por Factura';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238230; "SHE_Invoice without Order"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Required Invoice Order No.', ESP = 'N� pedido en facturas obligatorio';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238231; "Comprobar Fact. Gtos corriente"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comprobar Fact. Gtos corriente';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238232; "Permite Compra y pago dist"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Permite Compra y pago dist';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238233; "Controles Facturas recibidas"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238234; "Mensaje error liq. anticipos"; Option)
        {
            OptionMembers = "Post","Select Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Advance Payment Applying Error Message', ESP = 'Mensaje error liq. anticipos';
            OptionCaptionML = ENU = 'Post,Select Vendor', ESP = 'Al registrar,Al seleccionar proveedor';

            Description = 'QRE 1.00.00 15452';


        }
        field(7238235; "Comision - Tipo Individual"; Option)
        {
            OptionMembers = "Desglosada","SinDesglose";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Opc. Asiento Individual';
            OptionCaptionML = ESP = 'Desglosada,Sin Desglosar';

            Description = 'QRE 1.00.00 15454';


        }
        field(7238236; "Permitir factura abono a cero"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Permite registrar facturas/abonos con importe cero';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238237; "No. serie factura IVA Dif"; Code[10])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie factura IVA Dif';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238238; "No. serie Factura IVA Caja"; Code[10])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie Factura IVA Caja';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238239; "Aviso pago proveedor - cliente"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Supplier - customer payment notice', ESP = 'Aviso pago proveedor - cliente';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238240; "Auto Accum. Canc. Posting"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Auto Accumumulation Cancellation Posting', ESP = 'Registro autom�tico diario cancelaci�n periodificaci�n';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 GenJnlBatchL@1100254000 :
                GenJnlBatchL: Record 232;
            BEGIN

                // TestAllowModifyInterfaceData;
                // IF ("Acc. Canc. Default Descr." <> '') THEN BEGIN 
                //  GenJnlBatchL.RESET;
                //  IF (GenJnlBatchL.GET("Accum. Canc. Template Name","Accum. Canc. Batch Name")) THEN BEGIN 
                //    GenJnlBatchL.TESTFIELD("QB_Accumul Cancellation Temp",TRUE);
                //  END;
                // END;
            END;


        }
        field(7238241; "Acc. Canc. Default Descr."; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Accumulation Cancellation Default Description', ESP = 'Descripci�n asiento cancelaci�n periodificaci�n';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238242; "Accum. Canc. Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Accumulation Cancellation Template Name', ESP = 'Nombre libro diario defecto cancelaci�n periodificaci�n';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238243; "Accum. Canc. Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Corporate ERP Template Name"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Accumulation Cancellation Batch Name', ESP = 'Nombre secci�n diario defecto cancelaci�n periodificaci�n';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 GenJnlBatchL@1100254000 :
                GenJnlBatchL: Record 232;
            BEGIN

                // TestAllowModifyInterfaceData;
                // IF ("Acc. Canc. Default Descr." <> '') THEN BEGIN 
                //  GenJnlBatchL.RESET;
                //  IF (GenJnlBatchL.GET("Accum. Canc. Template Name","Accum. Canc. Batch Name")) THEN BEGIN 
                //    GenJnlBatchL.TESTFIELD("QB_Accumul Cancellation Temp",TRUE);
                //  END;
                // END;
            END;


        }
        field(7238244; "Corporate ERP Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Corporate ERP Template Name', ESP = 'Nombre libro diario defecto ERP corporativo';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238245; "Corporate ERP Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Corporate ERP Template Name"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Corporate ERP Batch Name', ESP = 'Nombre secci�n diario defecto ERP corporativo';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 GenJnlBatchL@1100254000 :
                GenJnlBatchL: Record 232;
            BEGIN
                //
                // TestAllowModifyInterfaceData;
                // IF ("Corporate ERP Batch Name" <> '') THEN BEGIN 
                //  GenJnlBatchL.RESET;
                //  IF (GenJnlBatchL.GET("Corporate ERP Template Name","Corporate ERP Batch Name")) THEN BEGIN 
                //    GenJnlBatchL.TESTFIELD("QB_Accumul Cancellation Temp",FALSE);
                //    GenJnlBatchL.TESTFIELD("QB_Active Income Integration",FALSE);
                //  END;
                // END;
            END;


        }
        field(7238250; "Corporate ERP Webservice TO"; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Corporate ERP Webservice TO (ms)', ESP = 'Timeout webservice ERP corporativo (ms)';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238251; "Job Dimension Code"; Code[20])
        {
            TableRelation = "Dimension";
            AccessByPermission = TableData 350 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Dimension Code', ESP = 'C�d. dimensi�n proyecto (POE)';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238252; "Job Task Dimension Code"; Code[20])
        {
            TableRelation = "Dimension";
            AccessByPermission = TableData 350 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Task Dimension Code', ESP = 'C�d. dimensi�n tarea proyecto (POE)';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238253; "Journal Purch. Docs. URL"; Text[100])
        {


            ExtendedDatatype = URL;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Journal Purch. Docs. URL', ESP = 'URL webservice diario general interfaz gastos';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238254; "Journal Notify Docs. URL"; Text[100])
        {


            ExtendedDatatype = URL;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Journal Notify Docs. URL', ESP = 'URL webservice notificaci�n procesado diario general interfaz gastos';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238255; "REGE URL"; Text[100])
        {


            ExtendedDatatype = URL;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'REGE URL', ESP = 'URL webservice REGE';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238256; "REGE Notify URL"; Text[100])
        {


            ExtendedDatatype = URL;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'REGE Notify URL', ESP = 'URL webservice notificaci�n REGE';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN

                TestAllowModifyInterfaceData;
            END;


        }
        field(7238258; "Texto registro facturas"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Invoices register text', ESP = 'Texto registro facturas';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238259; "Texto registro abonos"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Credit register text', ESP = 'Texto registro abonos';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238260; "Comision - Cta. Comision"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cta. Comisi�n';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238261; "Comision - Texto Registro"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto Registro';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238262; "Comision - Cod. Proyecto"; Code[5])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Proyecto';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238263; "Comision - Cod. Partida"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Partida';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238264; "Comision - Tipo Asiento"; Option)
        {
            OptionMembers = "Agrupada","Individual";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo Asiento';
            OptionCaptionML = ESP = 'Agrupada,Individual';

            Description = 'QRE 1.00.00 16223';


        }
    }
    keys
    {
        key(key1; "Record ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       recFormaPago@1100286001 :
        recFormaPago: Record 289;
        //       recConfProv@1100286000 :
        recConfProv: Record 312;
        //       QBPurchPaySetupExt@1100286003 :
        QBPurchPaySetupExt: Record 7238431;
        //       Text001@1100286005 :
        Text001: TextConst ENU = 'You have no permissions to modify that data.', ESP = 'No tiene permiso para modificar los datos del interfaz.';

    //     procedure Read (PurchasesPayablesSetup@1100286000 :
    procedure Read(PurchasesPayablesSetup: Record 312): Boolean;
    begin
        //Busca un registro, si no existe lo inicializa, retorna encontrado o no
        Rec.RESET;
        Rec.SETRANGE("Record ID", PurchasesPayablesSetup.RECORDID);
        if not Rec.FINDFIRST then begin
            Rec.INIT;
            Rec."Record ID" := PurchasesPayablesSetup.RECORDID;
            exit(FALSE);
        end;
        exit(TRUE)
    end;

    procedure Save()
    begin
        //Guarda el registro
        if not Rec.MODIFY then
            Rec.INSERT(TRUE);
    end;

    LOCAL procedure "----------------------------------------QRE"()
    begin
    end;

    LOCAL procedure TestAllowModifyInterfaceData()
    var
        //       UserSetupL@1100254000 :
        UserSetupL: Record 91;
        //       AuxL@1100254002 :
        AuxL: Boolean;
    begin
        AuxL := FALSE;
        // if UserSetupL.GET(USERID) then
        //  AuxL := UserSetupL."QB_Allow Editing Interface Dat";
        //
        // if (not AuxL) then
        //  ERROR(Text001);
    end;

    /*begin
    //{
//      QRE15717-LCG-091221- A�adir campo "Invest. Opport. Account No." y "QB_Invest. Opport. CustTemplNo"
//    }
    end.
  */
}







