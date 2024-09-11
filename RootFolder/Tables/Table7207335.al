table 7207335 "QB Relationship Setup"
{


    CaptionML = ENU = 'Relationship Setup', ESP = 'Configuraci�n Relaciones cobros y pagos';
    LookupPageID = "QuoBuilding Setup";
    DrillDownPageID = "QuoBuilding Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key', ESP = 'Clave primaria';


        }
        field(10; "RC Use Debit Relations"; Boolean)
        {
            CaptionML = ENU = 'Use Debit Relations', ESP = 'Usar Relaciones de Cobro';
            Description = 'RELACIONES DE COBROS. 03/05/19 JAV - Si se usan las relaciones de cobro';


        }
        field(11; "RC Serie Relaciones Cobros"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� serie para relaciones de cobros';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(12; "RC Gen.Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'General Journal Template Name', ESP = 'Nombre plantilla diario pagos';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';

            trigger OnValidate();
            VAR
                //                                                                 GenJournalTemplate@1000 :
                GenJournalTemplate: Record 80;
                //                                                                 xGenJournalTemplate@1001 :
                xGenJournalTemplate: Record 80;
                //                                                                 Err001@1100286000 :
                Err001: TextConst ESP = 'Diario de tipo %1, debe seleccionar un diario de tipo Ventas';
            BEGIN
                IF "RC Gen.Journal Template Name" = '' THEN
                    "RC Gen.Journal Batch Name" := ''
                ELSE BEGIN
                    GenJournalTemplate.GET("RC Gen.Journal Template Name");
                    IF (GenJournalTemplate.Type <> GenJournalTemplate.Type::Sales) THEN
                        ERROR(Err001, GenJournalTemplate.Type);
                END;
            END;


        }
        field(13; "RC Gen.Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("RC Gen.Journal Template Name"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'General Journal Batch Name', ESP = 'Nombre secci�n diario pagos';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';

            trigger OnValidate();
            VAR
                //                                                                 GenJournalBatch@1000 :
                GenJournalBatch: Record 232;
            BEGIN
                IF "RC Gen.Journal Batch Name" <> '' THEN BEGIN
                    TESTFIELD("RC Gen.Journal Template Name");
                    GenJournalBatch.GET("RC Gen.Journal Template Name", "RC Gen.Journal Batch Name");
                    GenJournalBatch.TESTFIELD(Recurring, FALSE);
                END;
            END;


        }
        field(14; "RC Codigo Origen"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ESP = 'C�digo de Origen';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(15; "RC Cuenta Cobro anticipado"; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ESP = 'Cuenta Cobro anticipado';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(16; "RC Texto para Registrar"; Text[50])
        {
            CaptionML = ESP = 'Texto para Registrar';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(17; "RC Texto para crear Efectos"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto para crear Efectos';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(18; "RC Texto para Liquidar Fac-Ab"; Text[50])
        {
            CaptionML = ESP = 'Texto para Liquidar Facturas';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(20; "RC Payment Method Code"; Code[20])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'C�d. forma pago';
            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(21; "RC Default Type"; Option)
        {
            OptionMembers = "Lineal","Certification";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Method Code', ESP = 'Tipo por defecto';
            OptionCaptionML = ENU = 'Lineal,By Certification', ESP = 'Lineal,Por Certificaci�n';

            Description = 'RELACIONES DE COBROS. 19/02/19 JAV - Para crear las relaciones de cobros';


        }
        field(58; "RP Texto para Efecto Agrupado"; Text[50])
        {
            CaptionML = ESP = 'Texto para el efecto agrupado';
            Description = 'RELACIONES DE PAGOS. JAV 08/10/20: - Para relaciones de pagos QB 1.06.19';


        }
        field(59; "RP Texto para Agrupar Fra"; Text[50])
        {
            CaptionML = ESP = 'Texto para Agrupar Factura';
            Description = 'RELACIONES DE PAGOS. JAV 08/10/20: - Para relaciones de pagos QB 1.06.19';


        }
        field(60; "RP Use Payment Relations"; Boolean)
        {
            CaptionML = ESP = 'Usar Relaciones de Pagos';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(61; "RP Texto para Factura"; Text[50])
        {
            CaptionML = ESP = 'Texto para Factura';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(62; "RP Texto para Efecto"; Text[50])
        {
            CaptionML = ESP = 'Texto para Efecto';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(63; "RP Texto para Aplicar Abono"; Text[50])
        {
            CaptionML = ESP = 'Texto para Aplicar Abono';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(64; "RP Texto para Liquidar Efecto"; Text[50])
        {
            CaptionML = ESP = 'Texto para Liquidar Efecto';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(65; "RP Texto para Cancelar Vto."; Text[50])
        {
            CaptionML = ESP = 'Texto para Cancelar Vto.';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(66; "RP Texto para Nuevo Vto."; Text[50])
        {
            CaptionML = ESP = 'Texto para Nuevo Vto.';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(67; "RP Texto para Pago Anticipado"; Text[50])
        {
            CaptionML = ESP = 'Texto para Pago Anticipado';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(68; "RP Informe Pagares"; Option)
        {
            OptionMembers = "A","B";
            CaptionML = ESP = 'Informe Pagar�s';
            OptionCaptionML = ESP = 'Especial,Con Fuente';

            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(69; "RP Serie para Pago Anticipado"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ESP = 'Serie para Pago Anticipado';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(70; "RP Cuenta para Pago anticipado"; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ESP = 'Cuenta para Pago anticipado';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(71; "RP Gen.Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";


            CaptionML = ENU = 'General Journal Template Name', ESP = 'Nombre plantilla diario pagos';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';

            trigger OnValidate();
            VAR
                //                                                                 GenJournalTemplate@1000 :
                GenJournalTemplate: Record 80;
                //                                                                 xGenJournalTemplate@1001 :
                xGenJournalTemplate: Record 80;
                //                                                                 Err001@1100286000 :
                Err001: TextConst ESP = 'Debe usar una diario de pagos';
            BEGIN
                IF "RP Gen.Journal Template Name" = '' THEN BEGIN
                    "RP Gen.Journal Template Name" := '';
                    EXIT;
                END;
                GenJournalTemplate.GET("RP Gen.Journal Template Name");
                IF (GenJournalTemplate.Type <> GenJournalTemplate.Type::Payments) THEN
                    ERROR(Err001);
                IF xRec."RP Gen.Journal Template Name" <> '' THEN
                    IF xGenJournalTemplate.GET(xRec."RP Gen.Journal Template Name") THEN;
                IF GenJournalTemplate.Type <> xGenJournalTemplate.Type THEN
                    "RP Gen.Journal Batch Name" := '';
            END;


        }
        field(72; "RP Gen.Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("RP Gen.Journal Template Name"));


            CaptionML = ENU = 'General Journal Batch Name', ESP = 'Nombre secci�n diario pagos';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';

            trigger OnValidate();
            VAR
                //                                                                 GenJournalBatch@1000 :
                GenJournalBatch: Record 232;
            BEGIN
                //IF "RP Gen.Journal Batch Name" <> '' THEN
                //  TESTFIELD("RP Gen.Journal Template Name");
                //GenJournalBatch.GET("RP Gen.Journal Template Name","RP Gen.Journal Batch Name");
                //GenJournalBatch.TESTFIELD(Recurring,FALSE);
            END;


        }
        field(73; "RP F.Pago Pagares por emitir"; Code[20])
        {
            TableRelation = "Payment Method";
            CaptionML = ESP = 'FP Pagar�s por emitir';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(74; "RP Codigo Origen"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ESP = 'C�digo de Origen';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(75; "RP Fichero de Pagos"; Text[250])
        {
            CaptionML = ESP = 'Fichero de Pagos';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(76; "RP Texto para Cancelar Pagaré"; Text[50])
        {
            CaptionML = ESP = 'Texto para Cancelar Pagaré';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(77; "RP Texto para Nueva Fra."; Text[50])
        {
            CaptionML = ESP = 'Texto para Nueva Fra.';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(78; "RP Forma Pago Anulacion"; Code[20])
        {
            TableRelation = "Payment Method";
            CaptionML = ESP = 'Forma de pago para Anuar Pagar�s';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


        }
        field(79; "RP F.Pago Tranf. por emitir"; Code[20])
        {
            TableRelation = "Payment Method";
            CaptionML = ESP = 'F.Pago Tranf. por emitir';
            Description = 'RELACIONES DE PAGOS. JAV 10/05/19: - Para relaciones de pagos';


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
      QMD 18/08/10: - Q3254 Nuevo campo "Use Responsibility Center"
      JAV 03/04/19: - Nuevo par�metro con la pantallas se ver�n por defecto en la page de costes directos
      JAV 13/05/19: - Nuevo par�metro 50080 "Use Salesperson dimension", para hacer obligatorio el vendedor asociado al cliente
      JAV 19/02/19: - Se a�aden los campos 50000..50001 para el uso obligatorio de referentes en Andrasa
      JAV 02/03/19: - Se a�aden nuevos campos 50010..50019 para controlar las relaci�n de cobros de Andrasa
      PGM 30/04/19: - QCPM_GAP18 Creado el campo "Day of the Period"
      JAV 15/05/19: - Se a�aden los campos 50030..50032 para el control de contratos
                    - Se a�ade el campo 50050 para presentar o no los factbox de Sharepoint
                    - Se a�aden los capos 50060..50075 para las relaciones de pagos y pagar�s de Perteo
                    - Se a�ade el cmapo 50080 para indicar si la dimensi�n vendedor es obligatoria
      JAV 08/07/19: - Se a�ade el campo 50052"Departamento para Labor" Departamento en que se imputan asientos de la n�mina de Labor
      JAV 24/07/19: - Se a�aden campos 50 a 55 para saber que reports sacar de rel.valorada, medici�n y certificaci�n
      JAV 11/07/19: - Campo 50085 "Job access control" que indica si se utiliza el control de acceso por usuarios de la obra
      JAV 24/07/10: - Campos 50 a 55 que indican que report se usan para relaci�n valorada, medici�n y certificaci�n registradas y sin registrar
      JAV 25/07/19: - Campo 60 "Use Job Currency" que indica si se van a usar divisas en los proyectos
      JAV 07/08/19: - Se a�ade el campo 50087 "Use DCBP Aditional Fields" para ver o no los campos adicionales en descompuestos
      JAV 10/08/19: - Se a�ade el campo 50088 "Close month process" que indica si al cerrar el mes se debe copiar o reestimar
                    - Se a�ade el campo 50089"Act.Price on Generate Contract" si al generar el contrato se deben actualizar los precios de los descompuestos
      JAV 07/09/19: - Se a�aden para la gesti�n de garant�as los campos 81 "Guarantee Analitical Concept" y 82 "Guarantee Piecework Unit"
      JAV 22/09/19: - Se a�ade el campo "Guarantee Piecework Unit Prov." para las provisiones de gastos de las garant�as
      JAV 03/10/19: - Se eliminan los campos 50 a 55 que ya no se usan con el selector de informes
      JAV 09/10/19: - Se a�ade el campo "Quote Budget Code" que indica el c�digo que usa al crear el proyecto de un estudio cuando se a�ade el presupuesto de Estudio
                      adem�s del Master, si est� en blanco no se a�ade.
      JAV 12/10/19: - Se a�ade el campo "Initial Budget" que indica que presupuesto ser� el inicial, si el de Estudio o el Master
      JAV 08/03/20: - CALIDAD-CERTIFICADOS Se a�ade el campo 50120 que indica si se usa el control de certificados vecidos
      JAV 22/09/20: - QB 1.06.15 Campos para Sincronizar empresas
      PGM 24/09/20: - QB 1.06.15 Creado el campo "Auxiliary Location Code"
    }
    end.
  */
}







