tableextension 50145 "MyExtension50145" extends "Job"
{

    DataCaptionFields = "No.", "Description";
    CaptionML = ENU = 'Job', ESP = 'Proyecto';
    LookupPageID = "Job List";
    DrillDownPageID = "Job List";

    fields
    {
        field(50000; "Old Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Old Job No.', ESP = 'C�d. Proyecto Antiguo';
            Description = 'ROIG CyS - Su c�digo anterior';


        }
        field(50001; "OLD_Done"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Done',
                                                              ESP = 'Hecho';
            Description = '### ELIMINAR ### no se usa';
        }
        field(50002; "Oficina/Identif"; Code[20])
        {
            TableRelation = "Ship-to Address"."Code" WHERE("Customer No." = FIELD("Bill-to Customer No."));


            DataClassification = ToBeClassified;
            Description = 'ROIG CYS - Campo sistema antiguo direcci�n de obra';

            trigger OnValidate();
            VAR
                //                                                                 "Ship-to_Address"@1100286000 :
                "Ship-to_Address": Record 222;
            BEGIN

                IF "Ship-to_Address".GET("Bill-to Customer No.", "Oficina/Identif") THEN BEGIN
                    "Job Address 1" := "Ship-to_Address".Address;
                    "Job Adress 2" := "Ship-to_Address"."Address 2";
                    "Job City" := "Ship-to_Address".City;
                    "Job Telephone" := "Ship-to_Address"."Phone No.";
                END;
            END;


        }
        field(50006; "OLD_Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';
            Description = '### ELIMINAR ### no se usa';

            trigger OnLookup();
            VAR
                //                                                               SalesSetup@1100286000 :
                SalesSetup: Record 311;
            BEGIN
            END;


        }
        field(50007; "Presupuesto autorizado"; Boolean)
        {


            DataClassification = ToBeClassified;
            Description = 'BS::20430';

            trigger OnValidate();
            VAR
                //                                                                 UserSetup@1100286000 :
                UserSetup: Record 91;
            BEGIN
                IF "Job Type" = "Job Type"::Operative THEN BEGIN
                    UserSetup.GET(USERID);
                    IF NOT UserSetup."Aut. Presupuestos" THEN ERROR('No atorizado a modificar este campo');
                END;
            END;


        }
        field(50008; "Importe seguro TRC"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'BS::20016';


        }
        field(7207271; "Job Type"; Option)
        {
            OptionMembers = "Operative","Deviations","Structure";

            CaptionML = ENU = 'Job Type', ESP = 'Tipo de Proyecto';
            OptionCaptionML = ENU = 'Operative,Deviations,Structure', ESP = 'Operativo,Desviaciones,Estructura';

            Description = 'QB 1.00- QB2413';

            trigger OnValidate();
            VAR
                //                                                                 QBTableSubscriber@1100286000 :
                QBTableSubscriber: Codeunit 7207347;
            BEGIN
                //JAV 23/08/19: - Si cambia el tipo de proyecto, se revisa la dimensi�n por defecto
                QBTableSubscriber.CreateJobDefaultDim(Rec);
            END;


        }
        field(7207272; "Separation Job Unit/Cert. Unit"; Boolean)
        {


            CaptionML = ENU = 'Separation Work Package Unit/Cert. Unit', ESP = 'Separaci�n und. obra/ und. cert';
            Description = 'QB 1.00- QB2413';

            trigger OnValidate();
            VAR
                //                                                                 QBRelCertificationProduct@1100286000 :
                QBRelCertificationProduct: Codeunit 7207343;
            BEGIN
                //JAV 01/12/20: - QB 1.07.08 Permitir cambiar el check si no hay unidades relacionadas
                IF ("Separation Job Unit/Cert. Unit") AND (NOT xRec."Separation Job Unit/Cert. Unit") THEN    //Ahora separamos y antes no separabamos
                    IF (NOT CONFIRM(txtQB000, FALSE)) THEN
                        ERROR('')
                    ELSE BEGIN
                        MODIFY;
                        IF (NOT QBRelCertificationProduct.Separate("No.")) THEN
                            ERROR('');
                    END;

                IF (NOT "Separation Job Unit/Cert. Unit") AND (xRec."Separation Job Unit/Cert. Unit") THEN    //Ahora no separamos y antes si
                    IF (QBRelCertificationProduct.ExistSeparation("No.")) THEN
                        ERROR(txtQB001);
            END;


        }
        field(7207273; "Initial Budget Piecework"; Code[20])
        {
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("No."));
            CaptionML = ENU = 'Initial Budget', ESP = 'Presupuesto inicial';
            Description = 'QB 1.00- QB2413';
            Editable = false;


        }
        field(7207274; "Budget Status"; Option)
        {
            OptionMembers = "Open","Blocked";

            CaptionML = ENU = 'Budget Status', ESP = 'Estado Presupuesto';
            OptionCaptionML = ENU = 'Open,Blocked', ESP = 'Abierto,Bloqueado';

            Description = 'QB 1.00- QB2413';

            trigger OnValidate();
            BEGIN
                //JAV 06/08/19: - Se a�ade el campo 7207288 "Blocked By" que indica quien ha bloqueado el proyecto
                IF "Budget Status" = "Budget Status"::Blocked THEN
                    "Blocked By" := USERID
                ELSE
                    "Blocked By" := '';
            END;


        }
        field(7207275; "% Margin"; Decimal)
        {
            CaptionML = ENU = '% Margin', ESP = '% Margen';
            DecimalPlaces = 0 : 7;
            Description = 'QB 1.00- QB2413';


        }
        field(7207276; "Budget Cost Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry"."Amount" WHERE("Budget Name" = FIELD("Jobs Budget Code"),
                                                                                                    "Budget Dimension 1 Code" = FIELD("No."),
                                                                                                    "Budget Dimension 2 Code" = FIELD("Reestimation Filter"),
                                                                                                    "Type" = CONST("Expenses"),
                                                                                                    "Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Budget Cost Amount', ESP = 'Imp. coste ppto.';
            Description = 'QB 1.00- QB2413';


        }
        field(7207277; "Production Budget Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Filter"),
                                                                                                                  "Expected Date" = FIELD("Posting Date Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Estimated Value Budget Amount', ESP = 'Importe producci�n ppto.';
            Description = 'QB 1.00- QB2413';


        }
        field(7207278; "Jobs Budget Code"; Code[20])
        {
            TableRelation = "G/L Budget Name";
            CaptionML = ENU = 'Jobs Budget Code', ESP = 'C�d. ppto proyectos';
            Description = 'QB 1.00- QB2413';


        }
        field(7207279; "Piecework Filter"; Text[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("No."));
            CaptionML = ENU = 'Work Package Filter', ESP = 'Filtro unidad de obra';
            Description = 'QB 1.00- QB2413';


        }
        field(7207280; "Budget Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("No."));
            CaptionML = ENU = 'Budget Filter', ESP = 'Filtro presupuesto';
            Description = 'QB 1.00- QB2413';


        }
        field(7207281; "Current Piecework Budget"; Code[20])
        {
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("No."));
            CaptionML = ENU = 'Current Budget', ESP = 'Presupuesto Actual';
            Description = 'QB 1.00- QB2413';
            Editable = false;


        }
        field(7207282; "Reestimation Filter"; Code[20])
        {
            FieldClass = FlowFilter;


            CaptionML = ENU = 'Reestimation Filter', ESP = 'Filtro reestimaci�n';
            Description = 'QB 1.00- QB2413';

            trigger OnLookup();
            BEGIN
                QBTableSubscriber.TJob_OnLookupReestimationFilter(Rec);
            END;


        }
        field(7207283; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro responsabilidad';
            Description = 'QB 1.00- QB2413';


        }
        field(7207284; "Management By Production Unit"; Boolean)
        {
            CaptionML = ENU = 'Management By Work Package', ESP = 'Gesti�n por unid. producci�n';
            Description = 'QB 1.00- QB2414';


        }
        field(7207285; "Production Calculate Mode"; Option)
        {
            OptionMembers = "Lump Sums","Production by Piecework","Administration","Production=Invoicing","Free","Without Production";
            CaptionML = ENU = 'Earned Value Calculate Mode', ESP = 'Modo c�lculo producci�n';
            OptionCaptionML = ENU = '"Lump Sums,Production by Work Package,Administration,Earned Value Invoicing,Free,Without Production"', ESP = '"Tanto alzado,Producci�n por UO,Administraci�n,Producci�n Facturaci�n,Libre,Sin Producci�n"';

            Description = 'QB 1.00- QB2414';


        }
        field(7207286; "Job Matrix - Work"; Option)
        {
            OptionMembers = "Matrix Job","Work";
            CaptionML = ENU = 'Job Matrix - Work', ESP = 'Proyecto matriz-trabajo';
            OptionCaptionML = ENU = 'Matrix Job,Work', ESP = 'Proyecto matriz,Trabajo';

            Description = 'QB 1.00- QB2411';


        }
        field(7207287; "Budget Sales Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("G/L Budget Entry"."Amount" WHERE("Budget Name" = FIELD("Jobs Budget Code"),
                                                                                                     "Budget Dimension 1 Code" = FIELD("No."),
                                                                                                     "Budget Dimension 2 Code" = FIELD("Reestimation Filter"),
                                                                                                     "Type" = CONST("Revenues"),
                                                                                                     "Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Budget Sales Amount', ESP = 'Imp. venta ppto.';
            Description = 'QB 1.00- QB2411';


        }
        field(7207288; "Archived"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Archivado';
            Description = 'QB 1.05';


        }
        field(7207289; "Type Filter"; Option)
        {
            OptionMembers = "Resource","Item","G/L Account","Group (Resource)";
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Type Filter', ESP = 'Filtro tipo';
            OptionCaptionML = ENU = 'Resource,Item,G/L Account,Group (Resource)', ESP = 'Recurso,Producto,Cuenta,Grupo (Recurso)';

            Description = 'QB 1.00- QB2411';


        }
        field(7207290; "Usage (Price) (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Price (LCY)" WHERE("Entry Type" = CONST("Usage"),
                                                                                                                 "Job No." = FIELD("No."),
                                                                                                                 "Type" = FIELD("Type Filter"),
                                                                                                                 "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Usage (Price)', ESP = 'Imp. consumido a p. venta (DL)';
            Description = 'QB 1.00- QB2411';
            Editable = false;


        }
        field(7207291; "Direct Cost Amount PieceWork"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                  "Unit Type" = CONST("Job Unit"),
                                                                                                                  "Entry Type" = CONST("Expenses"),
                                                                                                                  "Performed" = FIELD("Performed Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Direct Cost Amount by Work Package', ESP = 'Importe Costes directos UO';
            Description = 'QB 1.00- QB2411';


        }
        field(7207292; "Latest Reestimation Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Latest Reestimation Code', ESP = 'C�digo ultima reestimaci�n';
            Description = 'QB 1.00- QB2414';
            Editable = true;

            trigger OnLookup();
            BEGIN
                QBTableSubscriber.TJob_OnLookupLastestReestimationCode(Rec);
            END;


        }
        field(7207293; "Job Location"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Job Location', ESP = 'Almac�n proyecto';
            Description = 'QB 1.00- QB2411';


        }
        field(7207294; "Original Quote Code"; Code[20])
        {
            TableRelation = Job WHERE("Card Type" = CONST("Estudio"));
            CaptionML = ENU = 'Original Quote Code', ESP = 'C�d. oferta original';
            Description = 'QB 1.00- QB2414';


        }
        field(7207295; "Branch Manager Name"; Text[80])
        {
            CaptionML = ENU = 'Branch Manager Name', ESP = 'Nombre Dir. sucursal';
            Description = 'QB 1.00- QB2411';


        }
        field(7207296; "Job Telephone"; Text[30])
        {
            CaptionML = ENU = 'Job Telephone', ESP = 'Tel�fono obra';
            Description = 'QB 1.00- QB2411';


        }
        field(7207297; "Job Fax"; Text[30])
        {
            CaptionML = ENU = 'Job Fax', ESP = 'Fax obra';
            Description = 'QB 1.00- QB2411';


        }
        field(7207298; "Insurance Company"; Text[30])
        {
            CaptionML = ENU = 'Insurance Company', ESP = 'Compa��a seguro';
            Description = 'QB 1.00- QB2411';


        }
        field(7207299; "Policy No."; Text[30])
        {
            CaptionML = ENU = 'Policy No.', ESP = 'No. P�liza';
            Description = 'QB 1.00- QB2411';


        }
        field(7207300; "Policy Starting Date"; Date)
        {
            CaptionML = ENU = 'Policy Starting Date', ESP = 'Fecha inicio p�liza TRC';
            Description = 'QB 1.00- QB2411';


        }
        field(7207301; "Policy Ending Date"; Date)
        {
            CaptionML = ENU = 'Policy Ending Date', ESP = 'Fecha fin p�liza TRC';
            Description = 'QB 1.00- QB2411';


        }
        field(7207302; "Architect Code"; Code[20])
        {
            TableRelation = "Vendor";
            CaptionML = ENU = 'Architect Code', ESP = 'Cod. Arquitecto';
            Description = 'QB 1.00- QB2411';


        }
        field(7207303; "Multi-Client Job"; Option)
        {
            OptionMembers = "No","ByCustomers","ByPercentages";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Multi-Client Job', ESP = 'Proyecto Multicliente';
            OptionCaptionML = ENU = 'No, By Customers, By Percentages', ESP = 'No,Por clientes,Por Porcentajes';

            Description = 'QB 1.06';

            trigger OnValidate();
            VAR
                //                                                                 Records@1100286001 :
                Records: Record 7207393;
                //                                                                 QB_MultiCust@1100286000 :
                QB_MultiCust: TextConst ESP = 'No puede cambiar multi-cliente, hay varios cliente diferentes al principal en los Expedientes de venta.';
            BEGIN
                //JAV 26/02/20: - Si cambiamos el tipo de multi-cliente, se verifica si hay varios clientes para dejar o no cambiar el valor
                IF ("Multi-Client Job" <> xRec."Multi-Client Job") AND (xRec."Multi-Client Job" = xRec."Multi-Client Job"::ByCustomers) THEN BEGIN
                    Records.RESET;
                    Records.SETRANGE("Job No.", "No.");
                    IF (Records.FINDSET(FALSE)) THEN
                        REPEAT
                            IF (Records."Customer No." <> '') AND (Records."Customer No." <> "Bill-to Customer No.") THEN
                                ERROR(QB_MultiCust);
                        UNTIL Records.NEXT = 0;
                END;

                //JAV 26/02/20: - Se llama al evento OnAfterUpdateBillToCust
                QB_OnAfterUpdateBillToCust(Rec, xRec);
            END;


        }
        field(7207304; "Sent Date"; Date)
        {
            CaptionML = ENU = 'Customer Sent Date', ESP = 'Fecha de env�o al cliente';
            Description = 'QB 1.00- QB2411';


        }
        field(7207305; "Assigned Amount"; Decimal)
        {
            CaptionML = ENU = 'Assigned Amount', ESP = 'Importe adjudicado';
            Description = 'QB 1.00- QB2411';
            CaptionClass = '7206910,167,7207305';


        }
        field(7207306; "Reception Date"; Date)
        {
            CaptionML = ENU = 'Reception Date', ESP = 'Fecha Acta Recepci�n';
            Description = 'QB 1.06';


        }
        field(7207307; "QB Activable"; Option)
        {
            OptionMembers = " ","activatable","disabled";
            CaptionML = ENU = 'Expenses Activation', ESP = 'Gastos Activables';
            OptionCaptionML = ENU = '" ,Activatable,Disabled"', ESP = '" ,Activable,Desactivado"';

            Description = 'QB 1.12.00 JAV 06/04/22 [TT] Indica si para este proyecto se pueden generar los movimientos de activaci�n de los gastos  10/11/22 Se cambia de boolean a option';


        }
        field(7207308; "QB Activable Status"; Option)
        {
            OptionMembers = " ","Management","Commercialization";
            FieldClass = FlowField;
            CalcFormula = Lookup("TAux Jobs Status"."Activation" WHERE("Usage" = FIELD("Card Type"),
                                                                                                           "Code" = FIELD("Internal Status")));
            CaptionML = ENU = 'Expenses Activation Status', ESP = 'Estado Activaci�n';
            OptionCaptionML = ENU = '" ,Management,Commercialization"', ESP = '" ,Gesti�n,Comercializaci�n"';

            Description = 'QB 1.12.00 JAV 06/04/22 [TT] Informa del estado actual de las activaciones, seg�n el estado actual del proyecto';
            Editable = false;


        }
        field(7207309; "QB Activable Date"; Date)
        {
            CaptionML = ENU = 'Activation Initial Date', ESP = 'Fecha inicio Activaci�n';
            Description = 'QB 1.12.00 JAV 06/04/22 [TT] Indica a partir de que fecha se empiezan a activar los gastos, los de fechas anteriores si los hubiera se deben haber activado manualmente.';


        }
        field(7207310; "Allocation Item by Unfold"; Boolean)
        {
            CaptionML = ENU = 'Allocation Item by Unfold', ESP = 'Imputaci�n por desglose';
            Description = 'QB 1.00- QB2411';


        }
        field(7207311; "Purcharse Shipment Provision"; Boolean)
        {
            CaptionML = ENU = 'Purcharse Shipment Provision', ESP = 'Provisionar albaranes compra';
            Description = 'QB 1.00- QB2411    QB 1.11.02 Se cambia el caption en ingl�s';


        }
        field(7207312; "Clasification"; Code[10])
        {
            TableRelation = "Job Classification";
            CaptionML = ENU = 'Clasification', ESP = 'Clasificaci�n';
            Description = 'QB 1.00- QB2411    QB 1.11.02 Caption Configurable';
            CaptionClass = '7206910,167,7207312';


        }
        field(7207313; "Warehouse Cost Unit"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("No."),
                                                                                                                         "Type" = CONST("Cost Unit"),
                                                                                                                         "Account Type" = CONST("Unit"));
            CaptionML = ENU = 'Warehouse Cost Unit', ESP = 'Unidad coste almacen';
            Description = 'QB 1.00- QB2411';


        }
        field(7207314; "Matrix Job it Belongs"; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Matrix Job it Belongs', ESP = 'Proy. matriz al que pertenece';
            Description = 'QB 1.00- QB2411';


        }
        field(7207315; "Initial Reestimation Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Initial Reestimation Code', ESP = 'C�digo reestimaci�n inicial';
            Description = 'QB 1.00- QB2411  QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';

            trigger OnLookup();
            BEGIN
                QBTableSubscriber.TJob_OnLookupInitialReestimationCode(Rec);
            END;


        }
        field(7207316; "Invoicing Type"; Option)
        {
            OptionMembers = "Administration","Landmark","Mixed";

            CaptionML = ENU = 'Invoicing Type', ESP = 'Tipo de facturaci�n';
            OptionCaptionML = ENU = 'Certification,Milestone,Mixed', ESP = 'Certificaci�n,Hitos,Mixto';

            Description = 'QB 1.00- QB2411';

            trigger OnValidate();
            VAR
                //                                                                 InvoiceMilestone@1100286000 :
                InvoiceMilestone: Record 7207331;
            BEGIN
                IF (xRec."Invoicing Type" IN [xRec."Invoicing Type"::Landmark, xRec."Invoicing Type"::Mixed]) AND ("Invoicing Type" = "Invoicing Type"::Administration) THEN BEGIN
                    InvoiceMilestone.RESET;
                    InvoiceMilestone.SETRANGE("Job No.", "No.");
                    IF (NOT InvoiceMilestone.ISEMPTY) THEN
                        ERROR(txtQB002);
                END;
            END;


        }
        field(7207317; "Management by tasks"; Boolean)
        {
            CaptionML = ENU = 'Management by tasks', ESP = 'Gesti�n por tareas';
            Description = 'QB 1.00- QB2411';


        }
        field(7207318; "Last Redetermination"; Code[20])
        {
            TableRelation = "Job Redetermination"."Code" WHERE("Job No." = FIELD("No."));
            CaptionML = ENU = 'Last Redetermination', ESP = '�ltima redeterminaci�n';
            Description = 'QB 1.00- QB2411';


        }
        field(7207320; "General Expenses / Other"; Decimal)
        {
            CaptionML = ENU = 'General Expenses / Other', ESP = 'Gastos generales / Otros';
            Description = 'QB 1.00- QB2411';
            CaptionClass = '7206910,167,7207320';


        }
        field(7207321; "Industrial Benefit"; Decimal)
        {
            CaptionML = ENU = 'Industrial Benefit', ESP = 'Beneficio industrial';
            Description = 'QB 1.00- QB2411';
            CaptionClass = '7206910,167,7207321';


        }
        field(7207322; "Low Coefficient"; Decimal)
        {
            CaptionML = ENU = 'Reduction Coefficient', ESP = 'Coeficiente baja';
            DecimalPlaces = 2 : 8;
            Description = 'QB 1.00- QB2411    JAV 24/09/19: - Se cambian los decimales del coeficiente de baja a 2:6  // 16/04/21 a 2:8';
            CaptionClass = '7206910,167,7207322';


        }
        field(7207323; "Quality Deduction"; Decimal)
        {
            CaptionML = ENU = 'Quality Deduction', ESP = 'Coeficiente indirectos';
            Description = 'QB 1.00- QB2411';


        }
        field(7207324; "Reestimation Last Date"; Date)
        {
            CaptionML = ESP = 'Fecha ultima reestimaci�n';
            Description = 'QB 1.00- QB2411';
            Editable = false;


        }
        field(7207325; "Init Real Date Construction"; Date)
        {
            CaptionML = ENU = 'Started Construction Real Date', ESP = 'Fecha real inicio construcci�n';
            Description = 'QB 1.00- QB2411';


        }
        field(7207326; "End Prov. Date Construction"; Date)
        {
            CaptionML = ENU = 'Prov. Construction End Date', ESP = 'Fecha prev. fin construcci�n';
            Description = 'QB 1.00- QB2411';


        }
        field(7207327; "Mandatory Allocation Term By"; Option)
        {
            OptionMembers = "Not necessary","AT Any Level","Only Per Piecework";
            CaptionML = ENU = 'Mandatory Allocation Term By', ESP = 'Imp. Obligatoria por';
            OptionCaptionML = ENU = 'Not necessary,AT Any Level,Only Per Work Package', ESP = 'No necesario,A cualquier nivel,Solo por U.O.';

            Description = 'QB 1.00- QB2411';


        }
        field(7207328; "% JV Share"; Decimal)
        {
            CaptionML = ENU = '% JV Share', ESP = '% Participaci�n UTE';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207329; "% Total Share JV(O+V)"; Decimal)
        {
            CaptionML = ENU = '% Total Share JV(O+V)', ESP = '% Participaci�n tot. UTE(O+V)';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207330; "Dimensions JV Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Dimensions JV Code', ESP = 'Cod. dimension UTE';
            Description = 'QB 1.00- QB2411 UTE';
            CaptionClass = '1,2,5';

            trigger OnLookup();
            BEGIN
                QBTableSubscriber.TJob_OnLookupDimensionsJVCode(Rec);
            END;


        }
        field(7207331; "Worksheet Type"; Option)
        {
            OptionMembers = "Source","Period";
            CaptionML = ENU = 'Worksheet Type', ESP = 'Tipo Hoja';
            OptionCaptionML = ENU = 'Source,Period', ESP = 'Origen,Periodo';

            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207332; "Rate Repercussion Job Code"; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Rate Repercussion Job Code', ESP = 'Cod. proyecto repercusi�n tasa';
            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207333; "Rate Repercussion Cost Unit"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Rate Repercussion Job Code"));
            CaptionML = ENU = 'Rate Repercussion Cost Unit', ESP = 'U. Coste repercusi�n tasas';
            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207334; "Month Closing JV"; Integer)
        {
            InitValue = 12;
            CaptionML = ENU = 'Month Closing JV', ESP = 'Mes de cierre de la UTE';
            MinValue = 0;
            MaxValue = 12;
            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207335; "Partner JV"; Text[30])
        {
            CaptionML = ENU = 'Partner JV', ESP = 'Socio UTE';
            Description = 'QB 1.00- QB2411 UTE';


        }
        field(7207336; "Piecework of CD integrat. JV"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("No."),
                                                                                                                         "Type" = FILTER("Piecework"),
                                                                                                                         "Production Unit" = CONST(true));
            CaptionML = ENU = 'Work Package of CD integrat. JV', ESP = 'U.O. de CD de integraci�n UTE';
            Description = 'QB 1.00- QB2411';


        }
        field(7207337; "Piecework of CI intergrat. JV"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("No."),
                                                                                                                         "Type" = FILTER("Cost Unit"));
            CaptionML = ENU = 'Work Package of CI intergrat. JV', ESP = 'U.O. de CI de integraci�n UTE';
            Description = 'QB 1.00- QB2411';


        }
        field(7207338; "Construction Manager"; Text[30])
        {
            TableRelation = Resource WHERE("Type" = CONST("Person"));
            CaptionML = ENU = 'Construction Manager', ESP = 'Director de obra';
            Description = 'QB 1.11.02 JAV 06/09/22 Caption Configurable y Table Relation';
            CaptionClass = '7206910,167,7207338';


        }
        field(7207339; "Job Address 1"; Text[50])
        {
            CaptionML = ENU = 'Job Address 1', ESP = 'Direcci�n 1 de la obra';
            Description = 'QB 1.00- QB2411';


        }
        field(7207340; "Job Adress 2"; Text[50])
        {
            CaptionML = ENU = '" Job Adress 2"', ESP = 'Direcci�n 2 de la obra';
            Description = 'QB 1.00- QB2411';


        }
        field(7207341; "Job City"; Text[50])
        {
            CaptionML = ENU = 'Job City', ESP = 'Poblaci�n de la obra';
            Description = 'QB 1.00- QB2411';


        }
        field(7207342; "Job P.C."; Code[10])
        {
            TableRelation = "Post Code";


            CaptionML = ENU = 'Job P.C.', ESP = 'C.P. de la obra';
            Description = 'QB 1.00- QB2411';

            trigger OnValidate();
            VAR
                //                                                                 JobPais@1100286000 :
                JobPais: Code[20];
            BEGIN
                //JAV 26/07/19: - Al validar el C.Potal de la obra poner provincia y ciudad
                PostCode.ValidatePostCode(
                  "Job City", "Job P.C.", "Job Province", JobPais, (CurrFieldNo <> 0) AND GUIALLOWED);
            END;


        }
        field(7207343; "Job Province"; Text[50])
        {
            CaptionML = ENU = 'Job Province', ESP = 'Provincia de la obra';
            Description = 'QB 1.00- QB2411';


        }
        field(7207344; "Architect"; Text[30])
        {
            CaptionML = ENU = 'Architect', ESP = 'Arquitecto';
            Description = 'QB 1.00- QB2411';


        }
        field(7207345; "License Status"; Text[50])
        {
            CaptionML = ENU = 'License Status', ESP = 'Estado de la licencia';
            Description = 'QB 1.10.42 JAV 17/05/22 Se elimina el table relation que era err�neo';


        }
        field(7207346; "Job License Date"; Date)
        {
            CaptionML = ENU = 'Job License Date', ESP = 'Fecha licencia obra';
            Description = 'QB 1.00 - QB2411';


        }
        field(7207347; "License Dossier No."; Text[30])
        {
            CaptionML = ENU = 'License Dossier No.', ESP = 'No. expediente licencia';
            Description = 'QB 1.00- QB2411';


        }
        field(7207348; "Invoiced Price (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Entry Type" = CONST("Sale"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Type" = FIELD("Type Filter"),
                                                                                                                  "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Invoiced Price (LCY)', ESP = 'Importe ingresos (DL)';
            Description = 'QB 1.00- QB2411 JAV 02/08/19: - Se pone el importe facturado en positivo. JMMA 160920: Se cambia el nombre a ingresos porque se incluyen todos los mov. tipo SALE incluida la "obra en curso" JMMA 161120 se cambia total price LCY por total price';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207349; "Usage (Cost) (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Entry Type" = CONST("Usage"),
                                                                                                                "Job No." = FIELD("No."),
                                                                                                                "Type" = FIELD("Type Filter"),
                                                                                                                "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                                "Piecework No." = FIELD("Piecework Filter")));
            CaptionML = ENU = 'Usage (Cost) (LCY)', ESP = 'Consumo (p.coste) DL';
            Description = 'QB 1.00- QB2411';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207350; "Job Analysis View Code"; Code[20])
        {
            TableRelation = "Analysis View";
            CaptionML = ENU = 'Job Analysis View Code', ESP = 'Cod. vista an�lisis proyectos';
            Description = 'QB 1.00- QB2411';


        }
        field(7207351; "Indirect Cost Amount Piecework"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                  "Unit Type" = CONST("Cost Unit"),
                                                                                                                  "Entry Type" = CONST("Expenses"),
                                                                                                                  "Performed" = FIELD("Performed Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Indirect Cost Amount Work Package', ESP = 'Importe Costes Indirectos UO';
            Description = 'QB 1.00- QB2411';


        }
        field(7207352; "Performed Filter"; Boolean)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Performed Filter', ESP = 'Filtro realizado';
            Description = 'QB 1.00- QB2411';


        }
        field(7207353; "Analytic Concept Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Analytic Concept Filter', ESP = 'Filtro concepto anal�tico';
            Description = 'QB 1.00- QB2411';


        }
        field(7207354; "Job Sales Doc Type Filter"; Option)
        {
            OptionMembers = "Standar","Eqipament Advance","Advance by Store","Price Review";
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Job Sales Doc Type Filter', ESP = 'Filtro tipo doc venta proyecto';
            OptionCaptionML = ENU = 'Standar,Equipment Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinar�a,Anticipo por acopios,Revisi�n precios';

            Description = 'QB 1.00- QB2411';


        }
        field(7207355; "Invoiced (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Entry Type" = CONST("Sale"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Type" = FIELD("Type Filter"),
                                                                                                                  "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                                  "Job in progress" = CONST(false),
                                                                                                                  "Job Sale Doc. Type" = FIELD("Job Sales Doc Type Filter")));
            CaptionML = ENU = 'Invoiced', ESP = 'Facturado (DL)';
            Description = 'QB 1.07.08 - QB  JAV 26/11/20: - Se cambia el nombre y el caption a�adiendo DL';


        }
        field(7207356; "Job in Progress (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Entry Type" = CONST("Sale"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Type" = FIELD("Type Filter"),
                                                                                                                  "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                                  "Job in progress" = CONST(true)));
            CaptionML = ENU = 'Work in Progress', ESP = 'Obra en curso (DL)';
            Description = 'QB 1.07.08 - QB  JAV 26/11/20: - Se cambia el nombre y el caption a�adiendo DL';


        }
        field(7207357; "Receive Pend. Order Amt (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = FILTER('Order' | 'Return Order'),
                                                                                                                     "Job No." = FIELD("No."),
                                                                                                                     "Order Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Receive Order Pending Amount', ESP = 'Imp. pedidos pdtes. recibir';
            Description = 'QB 1.00- QB2411';


        }
        field(7207358; "Pending Orders Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = FILTER('Order' | 'Blanket Order' | 'Return Order'),
                                                                                                                     "Location Code" = FIELD("Job Location"),
                                                                                                                     "Order Date" = FIELD("Posting Date Filter"),
                                                                                                                     "Job No." = CONST()));
            CaptionML = ENU = 'Pending Orders Amount', ESP = 'Imp. pedidos pendientes';
            Description = 'QB 1.00- QB2411';


        }
        field(7207359; "Warehouse Availability Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD("Job Location"),
                                                                                                               "Expected Cost" = CONST(false),
                                                                                                               "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Warehouse Availability Amount', ESP = 'Importe existencia almac�n';
            Description = 'QB 1.08.48  JAV 14/06/21: - Se arregla el caption por el acento';


        }
        field(7207360; "Measure Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term PEC Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                       "Piecework No." = FIELD("Piecework Filter"),
                                                                                                                       "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Measurement Amount', ESP = 'Importe Mediciones';
            Description = 'QB 1.08.48  JAV 14/06/21: - Se cambia el campo de fecha de medici�n por el de fecha de registro';


        }
        field(7207361; "Certification Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Term Contract Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                             "Piecework No." = FIELD("Piecework Filter"),
                                                                                                                             "Certification Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Certification Amount', ESP = 'Importe certificaciones';
            Description = 'QB 1.00- QB2411';


        }
        field(7207362; "Invoiced Certification"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Term Contract Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                             "Piecework No." = FIELD("Piecework Filter"),
                                                                                                                             "Certification Date" = FIELD("Posting Date Filter"),
                                                                                                                             "Invoiced Certif." = CONST(true)));
            CaptionML = ENU = 'Inviced Certification', ESP = 'Certificaciones facturadas';
            Description = 'QB 1.00- QB2411';


        }
        field(7207363; "Actual Production Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Term" WHERE("Job No." = FIELD("No."),
                                                                                                                         "Piecework No." = FIELD("Piecework Filter"),
                                                                                                                         "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Actual Earned Value Amount', ESP = 'Importe producci�n real';
            Description = 'QB 1.08.48 -------------------------------- Cambiado JAV 04/06/21';


        }
        field(7207364; "Amou Piecework Meas./Certifi."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Piecework For Production"."Sale Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                        "Customer Certification Unit" = CONST(true),
                                                                                                                        "Account Type" = CONST("Unit")));
            CaptionML = ENU = 'Amount Work Package Meas./Certifi.', ESP = 'Importe Ud. obra medic/certif';
            Description = 'QB 1.00- QB2416';


        }
        field(7207365; "Contract Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Piecework For Production"."Amount Sale Contract" WHERE("Job No." = FIELD("No."),
                                                                                                                                 "Customer Certification Unit" = CONST(true),
                                                                                                                                 "Account Type" = CONST("Unit")));
            CaptionML = ENU = 'Contract Amount', ESP = 'Importe Contrato';
            Description = 'QB 1.00- QB2413';
            CaptionClass = '7206910,167,7207365';


        }
        field(7207366; "Use Unit Price Ratio"; Boolean)
        {
            CaptionML = ENU = 'Use Unit Price Ratio', ESP = 'Usar relaci�n de precios unit.';
            Description = 'QB 1.00- QB2414';


        }
        field(7207367; "Budgeted Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Budget Entry"."Amount" WHERE("Budget Name" = FIELD("Jobs Budget Code"),
                                                                                                    "Budget Dimension 1 Code" = FIELD("No."),
                                                                                                    "Budget Dimension 2 Code" = FIELD("Reestimation Filter"),
                                                                                                    "Global Dimension 2 Code" = FIELD("Analytic Concept Filter"),
                                                                                                    "Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Budgeted Amount', ESP = 'Importe presupuestado';
            Description = 'QB 1.00- QB2413';


        }
        field(7207369; "Offert Price"; Option)
        {
            OptionMembers = "Normal","To the Bottom";
            CaptionML = ENU = 'Offered Price', ESP = 'Precio oferta';
            OptionCaptionML = ENU = 'Normal,Coefficent discount', ESP = 'Normal,A la baja';

            Description = 'QB 1.00- QB2414';


        }
        field(7207370; "Quote Status"; Option)
        {
            OptionMembers = "Pending","Accepted","Rejected";
            CaptionML = ENU = 'Quote Status', ESP = 'Estado oferta';
            OptionCaptionML = ENU = 'Pending,Accepted,Rejected', ESP = 'Pendiente,Aceptada,Rechazada';

            Description = 'QB 1.00- QB2413';


        }
        field(7207371; "Generated Job"; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Generated Job', ESP = 'Proyecto generado';
            Description = 'QB 1.00- QB2413';


        }
        field(7207372; "Delivered Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Elements Entries"."Quantity" WHERE("Element No." = FIELD("Element Filter"),
                                                                                                             "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                             "Job No." = FIELD("No."),
                                                                                                             "Entry Type" = CONST("Delivery")));
            CaptionML = ENU = 'Delivered Quantity', ESP = 'Cantidad entregada';
            Description = 'QB 1.00- QB2413';


        }
        field(7207373; "Returned Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Rental Elements Entries"."Quantity" WHERE("Element No." = FIELD("Element Filter"),
                                                                                                              "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                              "Job No." = FIELD("No."),
                                                                                                              "Entry Type" = CONST("Return")));
            CaptionML = ENU = 'Returned Quantity', ESP = 'Cantidad devuelta';
            Description = 'QB 1.00- QB2413';


        }
        field(7207374; "Balance Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Elements Entries"."Quantity" WHERE("Element No." = FIELD("Element Filter"),
                                                                                                             "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                             "Job No." = FIELD("No.")));
            CaptionML = ENU = 'Balance Amount', ESP = 'Saldo cantidad';
            Description = 'QB 1.00- QB2413';


        }
        field(7207375; "Element Filter"; Code[20])
        {
            FieldClass = FlowFilter;

            TableRelation = "Job";
            CaptionML = ENU = 'Element Filter', ESP = 'Filtro elemento';
            Description = 'QB 1.00- QB2413';


        }
        field(7207376; "Rigger"; Text[30])
        {
            CaptionML = ENU = 'Rigger', ESP = 'Aparejador';
            Description = 'QB 1.00- QB2411';


        }
        field(7207377; "Builder"; Text[30])
        {
            CaptionML = ENU = 'Builder', ESP = 'Constructor';
            Description = 'QB 1.00- QB2411';


        }
        field(7207379; "Location Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("No."));
            CaptionML = ENU = 'Location Task No.', ESP = 'N� tarea almac�n';
            Description = 'QB 1.00- QB2414';


        }
        field(7207380; "% Residual Value"; Decimal)
        {
            CaptionML = ENU = '% Residual Value', ESP = '% Valor residual';
            MinValue = 1;
            MaxValue = 100;
            Description = 'QB 1.00- QB2414';


        }
        field(7207381; "% Repairs and Spare Parts"; Decimal)
        {
            CaptionML = ENU = '% Repairs and Spare Parts', ESP = '% Reparaciones y respuestos';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.00- QB2414';


        }
        field(7207382; "% Grease"; Decimal)
        {
            CaptionML = ENU = '% Grease', ESP = '% Lubricante';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.00- QB2414';


        }
        field(7207383; "Unitary Cost Naphta"; Decimal)
        {
            CaptionML = ENU = 'Unitary Cost Naphta', ESP = 'Coste unitario Nafta';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.00- QB2414';
            AutoFormatType = 2;


        }
        field(7207384; "Unitary Cost Diesel"; Decimal)
        {
            CaptionML = ENU = 'Unitary Cost Diesel', ESP = 'Coste unitario Gasoil';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.00- QB2414';
            AutoFormatType = 2;


        }
        field(7207385; "Realized Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry"."Amount" WHERE("G/L Account No." = FIELD("Account Filter"),
                                                                                             "Global Dimension 2 Code" = FIELD("Analytic Concept Filter"),
                                                                                             "Job No." = FIELD("No."),
                                                                                             "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Realized Amount', ESP = 'Importe Realizado';
            Description = 'QB 1.00- QB2414';


        }
        field(7207386; "Account Filter"; Text[20])
        {
            FieldClass = FlowFilter;

            TableRelation = "G/L Account";
            CaptionML = ENU = 'Account Filter', ESP = 'Filtro cuenta';
            Description = 'QB 1.00- QB2414';


        }
        field(7207387; "End Real Construction Date"; Date)
        {
            CaptionML = ENU = 'Real Construction End Date', ESP = 'Fecha real fin construccion';
            Description = 'QB 1.00- QB 1.00';


        }
        field(7207388; "Real Init Date"; Date)
        {
            CaptionML = ENU = 'Real Started Date', ESP = 'Fecha inicio real';
            Description = 'QB 1.00- QB 1.00';


        }
        field(7207389; "Observations"; Text[60])
        {
            CaptionML = ENU = 'Observations', ESP = 'Observaciones';
            Description = 'QB 1.00- QB24115';


        }
        field(7207390; "Quote Type"; Code[20])
        {
            TableRelation = "Quote Type";
            CaptionML = ENU = 'Quote Type', ESP = 'Tipo oferta';
            Description = 'QB 1.00- QB24115    QB 1.11.02 Caption Configurable';
            CaptionClass = '7206910,167,7207390';


        }
        field(7207391; "Income Statement Responsible"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            CaptionML = ENU = 'Income Statement Responsible', ESP = 'Responsable comercial';
            Description = 'QB 1.00- QB24115    QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';
            CaptionClass = '7206910,167,7207391';


        }
        field(7207392; "Versions No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Original Quote Code" = FIELD("No."),
                                                                                "Card Type" = FILTER("Estudio")));
            CaptionML = ENU = 'Versions No.', ESP = 'No. versiones';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207394; "Rejection Reason"; Code[20])
        {
            TableRelation = "Reason for Rejection";
            CaptionML = ENU = 'Rejection Reason', ESP = 'Motivo rechazo';
            Description = 'QB 1.00- QB24115';


        }
        field(7207395; "Approved/Refused By"; Code[50])
        {
            CaptionML = ENU = 'Approved/Refused By', ESP = 'Aprovada/Denegada por';
            Description = 'QB 1.00- QB24115';


        }
        field(7207396; "Opportunity Code"; Code[20])
        {
            TableRelation = "Opportunity"."No.";
            CaptionML = ENU = 'Opportunity Code', ESP = 'C�digo oportunidad';
            Description = 'QB 1.00- QB24115     QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(7207397; "Presented Version"; Code[20])
        {
            TableRelation = Job."No." WHERE("Original Quote Code" = FIELD("No."));


            CaptionML = ENU = 'Presented Version', ESP = 'Versi�n presentada';
            Description = 'QB 1.00- QB24115';

            trigger OnValidate();
            BEGIN
                //JAV 26/08/19: - Al cambiar al versi�n presentada se valida el campo de % garant�a definitiva para que se recalcule
                VALIDATE("Guarantee Definitive %");
            END;


        }
        field(7207398; "Accepted Version No."; Code[20])
        {


            CaptionML = ENU = 'Accepted Version No.', ESP = 'No. version aceptada';
            Description = 'QB 1.00- QB24115';

            trigger OnValidate();
            BEGIN
                //JAV 07/09/19: - Al cambiar al versi�n aceptada se valida el campo de % garant�a definitiva para que se recalcule
                VALIDATE("Guarantee Definitive %");
            END;

            trigger OnLookup();
            BEGIN
                QBTableSubscriber.TJob_OnLookupAcceptedVersionNo(Rec);
            END;


        }
        field(7207399; "Bidding Bases Budget"; Decimal)
        {


            CaptionML = ENU = 'Bidding Bases Budget', ESP = 'Ppto. base licitaci�n';
            Description = 'QB 1.00- QB24115';

            trigger OnValidate();
            BEGIN
                //JAV 26/08/19: - Gesti�n  de garant�as
                VALIDATE("Guarantee Provisional %");
                VALIDATE("Guarantee Definitive %");
            END;


        }
        field(7207400; "Allocation Process"; Text[50])
        {
            CaptionML = ENU = 'Allocation Process', ESP = 'Procedimiento adjudicaci�n';
            Description = 'QB 1.00- QB24115';


        }
        field(7207401; "Implementation Period"; Text[50])
        {
            CaptionML = ENU = 'Implementation Period', ESP = 'Plazo de ejecuci�n';
            Description = 'QB 1.00- QB24115';


        }
        field(7207402; "Guarantee Provisional %"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Provisional Deposit Guarantee (%)', ESP = '% Garant�a provisional';
            Description = 'QB 1.00- QB24115, JAV 26/08/19: - Se cambia el caption y el validate';

            trigger OnValidate();
            BEGIN
                //JAV 26/08/19: - Gesti�n  de garant�as
                IF ("Bidding Bases Budget" <> 0) THEN
                    "Guarantee Provisional" := ROUND("Bidding Bases Budget" * "Guarantee Provisional %" / 100, 0.01);
            END;


        }
        field(7207403; "Guarantee Definitive %"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Definitive Deposit Guarantee (%)', ESP = '% Garant�a definitiva';
            Description = 'QB 1.00- QB24115, JAV 26/08/19: - Se cambia el caption y el validate';

            trigger OnValidate();
            BEGIN
                //JAV 26/08/19: - Gesti�n  de garant�as
                IF ("Bidding Bases Budget" <> 0) THEN
                    "Guarantee Definitive" := ROUND("Bidding Bases Budget" * "Guarantee Definitive %" / 100, 0.01);
                IF (Job.GET("Presented Version")) THEN BEGIN
                    Job.CALCFIELDS("Amou Piecework Meas./Certifi.");
                    IF (Job."Amou Piecework Meas./Certifi." <> 0) THEN
                        "Guarantee Definitive" := ROUND(Job."Amou Piecework Meas./Certifi." * "Guarantee Definitive %" / 100, 0.01);
                END;
            END;


        }
        field(7207404; "Poster Charge"; Boolean)
        {
            CaptionML = ENU = 'Poster Charge', ESP = 'Cargo por cartel';
            Description = 'QB 1.00- QB24115';


        }
        field(7207405; "Advertising Charge"; Boolean)
        {
            CaptionML = ENU = 'Advertising Charge', ESP = 'Cargo por publicidad';
            Description = 'QB 1.00- QB24115';


        }
        field(7207406; "Price Revision"; Boolean)
        {
            CaptionML = ENU = 'Price Revision', ESP = 'Revisi�n de precios';
            Description = 'QB 1.00- QB24115';


        }
        field(7207407; "Payment Method"; Text[50])
        {
            CaptionML = ENU = 'Payment Method', ESP = 'Forma de pago';
            Description = 'QB 1.00- QB24115';


        }
        field(7207408; "Subcontracting Limit %"; Decimal)
        {
            CaptionML = ENU = 'Subcontracting Limit %', ESP = 'Limite de subcontrataci�n %';
            Description = 'QB 1.00- QB24115';


        }
        field(7207409; "Guarantee Period"; Text[50])
        {
            CaptionML = ENU = 'Guarantee Period', ESP = 'Plazo de garant�a';
            Description = 'QB 1.00- QB24115';


        }
        field(7207410; "Quotes Opening Date"; Date)
        {
            CaptionML = ENU = 'Quotes Opening Date', ESP = 'Fecha apertura ofertas';
            Description = 'QB 1.00- QB24115';


        }
        field(7207411; "Provisional Allocation Date"; Date)
        {
            CaptionML = ENU = 'Provisional Allocation Date', ESP = 'Fecha adjudicaci�n provisional';
            Description = 'QB 1.00- QB24115';


        }
        field(7207412; "Final Allocation Period"; DateFormula)
        {
            CaptionML = ENU = 'Final Allocation Period', ESP = 'Plazo adjudicaci�n definitiva';
            Description = 'QB 1.00- QB24115 JAV 20/02/20: - Se cambia de date a dateformula';


        }
        field(7207413; "% Dangerously Low Bids"; Decimal)
        {
            CaptionML = ENU = '% Dangerously Low Bids', ESP = '% Baja temerar�a';
            Description = 'QB 1.00- QB24115';


        }
        field(7207414; "Bidder Company"; Code[20])
        {
            TableRelation = "Competition/Quote"."Competitor Code" WHERE("Quote Code" = FIELD("No."));
            CaptionML = ENU = 'Bidder Company', ESP = 'Empresa adjudicada';
            Description = 'QB 1.00- QB24115    QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(7207415; "Final Allocation Date"; Date)
        {
            CaptionML = ENU = 'Final Allocation Date', ESP = 'Fecha adjudicaci�n definitiva';
            Description = 'QB 1.00- QB24115';


        }
        field(7207416; "Low from Competitors"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Low from competitors', ESP = 'Baja desde Competencia';
            Description = 'QB 1.06 - ORTIZ OBGAP005';


        }
        field(7207417; "Low Average Competition"; Decimal)
        {
            CaptionML = ENU = 'Low Average Competitors', ESP = '% Baja Media Competencia';
            Description = 'QB 1.06 - ORTIZ OBGAP005';


        }
        field(7207418; "Average Quoted Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Average("Competition/Quote"."Contratista Amount" WHERE("Quote Code" = FIELD("No.")));
            CaptionML = ENU = 'Average Quoted Amount', ESP = 'Importe ofertado medio';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207419; "Low Competition Higher"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Max("Competition/Quote"."% of Low" WHERE("Quote Code" = FIELD("No."),
                                                                                                       "Competitor Code" = FILTER(<> '')));
            CaptionML = ENU = 'Low Competitors Higher', ESP = 'Baja mayor de la competencia';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207420; "Low Competition Less"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Min("Competition/Quote"."% of Low" WHERE("Quote Code" = FIELD("No."),
                                                                                                       "Competitor Code" = FILTER(<> '')));
            CaptionML = ENU = 'Low Competitors Less', ESP = 'Baja menor de la competencia';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207421; "Archieved Score"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Standard/Competition"."Score" WHERE("Quote Code" = FIELD("No."),
                                                                                                     "Competitor Code" = CONST('')));
            CaptionML = ENU = 'Achieved Score', ESP = 'Puntuaci�n obtenida';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207422; "Adjudicated Low"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Competition/Quote"."% of Low" WHERE("Quote Code" = FIELD("No."),
                                                                                                          "Competitor Code" = FIELD("Bidder Company")));
            CaptionML = ENU = 'Adjudicated Low', ESP = 'Baja adjudicada';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207423; "Adjudicated Score"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Standard/Competition"."Score" WHERE("Quote Code" = FIELD("No."),
                                                                                                     "Competitor Code" = FIELD("Bidder Company")));
            CaptionML = ENU = 'Adjudicated Score', ESP = 'Puntuaci�n adjudicada';
            Description = 'QB 1.00- QB24115';
            Editable = false;


        }
        field(7207424; "Canceled"; Boolean)
        {
            CaptionML = ENU = 'Canceled', ESP = 'Anulada';
            Description = 'QB 1.00- QB24115';


        }
        field(7207425; "Validate Quote"; Date)
        {
            CaptionML = ENU = 'Validate Quote', ESP = 'Validez oferta';
            Description = 'QB 1.00- QB24115';


        }
        field(7207426; "% Interests"; Decimal)
        {
            CaptionML = ENU = '% Interests', ESP = '% Intereses';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.00- QB24115';


        }
        field(7207427; "% Unforeseen"; Decimal)
        {
            CaptionML = ENU = '% Unforeseen', ESP = '% Imprevisto';
            Description = 'QB 1.00- QB24115';


        }
        field(7207428; "% Finance Expenses"; Decimal)
        {
            CaptionML = ENU = '% Finance Expenses', ESP = '% Gastos financieros';
            Description = 'QB 1.00- QB24115';


        }
        field(7207429; "% Material Benefits"; Decimal)
        {
            CaptionML = ENU = '% Material Benefits', ESP = '% Beneficios materiales';
            Description = 'QB 1.00- QB24115';


        }
        field(7207430; "% Workforce Benefits"; Decimal)
        {
            CaptionML = ENU = '% Labor benefits', ESP = '% Beneficios mano de obra';
            Description = 'QB 1.00- QB24115';


        }
        field(7207431; "% Equipament Benefits"; Decimal)
        {
            CaptionML = ENU = '% Equipment Benefits', ESP = '% Beneficios equipos';
            Description = 'QB 1.00- QB24115';


        }
        field(7207432; "% Subcontrating Benefits"; Decimal)
        {
            CaptionML = ESP = '% Beneficios subcontrataci�n';
            Description = 'QB 1.00- QB24115';


        }
        field(7207433; "% Other Benefits"; Decimal)
        {
            CaptionML = ENU = '% Other Benefits', ESP = '% Beneficios otros';
            Description = 'QB 1.00- QB24115';


        }
        field(7207434; "VAT Prod. PostingGroup"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            CaptionML = ENU = 'VAT Prod. PostingGroup', ESP = 'Grupo registro IVA prod.';
            Description = 'QB 1.00- QB24115   QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(7207435; "Card Type"; Option)
        {
            OptionMembers = " ","Estudio","Proyecto operativo","Promocion","Presupuesto","Suelo";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Card Type', ESP = 'Tipo ficha';

            Description = 'QB 1.09.05 - QB4973 Campo para poder hacer distinci�n entre estudios y proyectos operativos. JAV 14/07/21 QPR 1.00.00 Se a�ade tipo presupuesto JAV 05/05/22 QRE 1.00.12 Se a�ade tipo suelo';


        }
        field(7207436; "Calculate WIP by periods"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Calculate WIP by Periods', ESP = 'Calcular Obra en Curso por per�odos';
            Description = 'QB 1.07.08 - JAV 25/11/20: - [TT] Indica el modo de c�lculo de la Obra en Curso, si est� marcado ser� por periodos, si no ser� a origen';


        }
        field(7207437; "Obralia Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Obralia Code', ESP = 'C�digo Obralia';
            Description = 'QB 1.00- OBR';


        }
        field(7207438; "Pending Calculation Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JAV 30/01/19: - Para Versiones de los Estudios, si el presupuesto est� pendiente de calculo';


        }
        field(7207439; "Pending Calculation Analitical"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JAV 30/01/19: - Para Versiones de los Estudios, si el presupuesto anal�tico est� pendiente de calculo';


        }
        field(7207440; "Internal Status"; Code[20])
        {
            TableRelation = "TAux Jobs Status"."Code" WHERE("Usage" = FIELD("Card Type"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Internal Status', ESP = 'Estado interno';
            Description = 'QB 1.00- QBA5412,QCPM_GAP05';

            trigger OnValidate();
            VAR
                //                                                                 InternalStatus@1100286001 :
                InternalStatus: Record 7207440;
                //                                                                 xInternalStatus@1100286000 :
                xInternalStatus: Record 7207440;
                //                                                                 QBJobStatusChanges@1100286002 :
                QBJobStatusChanges: Record 7206996;
            BEGIN
                //JAV 02/06/19: - Establecer las fechas seg�n el estado
                IF ("Internal Status" <> xRec."Internal Status") THEN BEGIN
                    IF InternalStatus.GET(Rec."Card Type", "Internal Status") THEN BEGIN
                        CASE InternalStatus."Change Date" OF
                            InternalStatus."Change Date"::"1":
                                "Date 1" := TODAY;
                            InternalStatus."Change Date"::"2":
                                "Date 2" := TODAY;
                            InternalStatus."Change Date"::"3":
                                "Date 3" := TODAY;
                            InternalStatus."Change Date"::"4":
                                "Date 4" := TODAY;
                            InternalStatus."Change Date"::"5":
                                "Date 5" := TODAY;   //JAV 05/10/22: - QB 1.12.00 Estaba mal este campo, apuntaba al 4 en lugar del 5
                            InternalStatus."Change Date"::envio:
                                "Sent Date" := TODAY;
                        END;
                    END;
                END;

                //JAV 05/10/22: - QB 1.12.00 Mensaje seg�n el estado para activaci�n. Se a�ade la variable local xInternalStatus
                IF (Rec."Internal Status" <> xRec."Internal Status") THEN BEGIN
                    CALCFIELDS("QB Activable Status");
                    IF (NOT xInternalStatus.GET(Rec."Card Type", xRec."Internal Status")) THEN
                        xInternalStatus.INIT;
                    IF (NOT InternalStatus.GET(Rec."Card Type", Rec."Internal Status")) THEN
                        InternalStatus.INIT;
                    IF (xInternalStatus.Activation <> InternalStatus.Activation) THEN
                        MESSAGE('ATENCION: Ha cambiado el estado de las activaciones del proyecto');
                END;

                //JAV 24/10/22: - QB 1.12.00 Guardar los cambios de estado en la tabla de cambios para las activaciones
                QBJobStatusChanges.INIT;
                QBJobStatusChanges.Job := Rec."No.";
                QBJobStatusChanges."Job Status Type" := InternalStatus.Usage;
                QBJobStatusChanges."Job Status Code" := InternalStatus.Code;
                QBJobStatusChanges.INSERT(TRUE);
            END;


        }
        field(7207441; "Date 1"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date 1', ESP = 'Fecha 1';
            Description = 'QB 1.00- QBA5412';


        }
        field(7207442; "Date 2"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date 2', ESP = 'Fecha 2';
            Description = 'QB 1.00- QBA5412';


        }
        field(7207443; "Date 3"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date 3', ESP = 'Fecha 3';
            Description = 'QB 1.00- QBA5412';


        }
        field(7207444; "Date 4"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date 4', ESP = 'Fecha 4';
            Description = 'QB 1.00- QBA5412';


        }
        field(7207446; "Date 5"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Date 5', ESP = 'Fecha 5';
            Description = 'QB 1.00- QBA5414';


        }
        field(7207447; "Copy of Version"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Copy of Version', ESP = 'Copiado de versi�n';
            Description = 'QB 1.00- QBA5412';
            Editable = false;


        }
        field(7207449; "Old Internal Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Anterior Estado Interno';
            Description = 'JAV 19/09/19: - Guardar el estado antes de aceptar o rechazar la oferta';


        }
        field(7207450; "Sales Medition Type"; Option)
        {
            OptionMembers = "closed","open";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sales Measure Type', ESP = 'Tipo de Medici�n de Venta';
            OptionCaptionML = ENU = 'closed,open', ESP = 'Llave en mano,Medici�n Abierta';

            Description = 'QB 1.00- JAV 27/01/19: - El tipo de medici�n en venta, indica si es llave en mano o medici�n abierta';


        }
        field(7207451; "No. of Matrix Job it Belongs"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Matrix Job it Belongs" = FIELD("No.")));
            CaptionML = ENU = 'Number of sub-work', ESP = 'N� Proyectos hijos';
            Description = 'QB 1.00- JAV 27/01/19: - Cuantos hijos tiene este proyecto';
            Editable = false;


        }
        field(7207452; "Job Guarrantee Date Init"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Work Guarantee Start Date', ESP = 'Fecha Inicio Garant�a Obra';
            Description = 'QB 1.00- JAV 20/02/20: - Fecha de inicio de la garant�a en la Obra';

            trigger OnValidate();
            BEGIN
                VALIDATE("Job Guarrantee Period");
            END;


        }
        field(7207453; "Job Guarrantee Period"; DateFormula)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Work guarantee Period', ESP = 'Plazo de garantia de la Obra';
            Description = 'QB 1.00- JAV 20/02/20: - Plazo de validez de la garant�a en la Obra';

            trigger OnValidate();
            BEGIN
                IF ("Job Guarrantee Date Init" <> 0D) AND (FORMAT("Job Guarrantee Period") <> '') THEN
                    "Job Guarrantee Date End" := CALCDATE("Job Guarrantee Period", "Job Guarrantee Date Init");
            END;


        }
        field(7207454; "Job Guarrantee Date End"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'End Work Guarantee Date', ESP = 'Fecha Fin Garant�a Obra';
            Description = 'QB 1.00- JAV 20/02/20: - Fecha de fin de la garant�a en la Obra';

            trigger OnValidate();
            VAR
                //                                                                 days@1100286000 :
                days: Integer;
                //                                                                 years@1100286001 :
                years: Integer;
                //                                                                 cadena@1100286002 :
                cadena: Text;
                //                                                                 WithholdingMovements@1100286003 :
                WithholdingMovements: Record 7207329;
            BEGIN
                IF ("Job Guarrantee Date End" <> 0D) AND ("Job Guarrantee Date Init" <> 0D) THEN BEGIN
                    days := "Job Guarrantee Date End" - "Job Guarrantee Date Init";
                    years := 0;
                    REPEAT
                        IF (days >= 365) THEN BEGIN
                            years += 1;
                            days -= 365;
                        END;
                    UNTIL (days < 365);
                    IF (years <> 0) AND (days <> 0) THEN
                        cadena := FORMAT(years) + 'a+' + FORMAT(days) + 'd'
                    ELSE IF (years <> 0) THEN
                        cadena := FORMAT(years) + 'a'
                    ELSE
                        cadena := FORMAT(days) + 'd';

                    IF EVALUATE("Job Guarrantee Period", cadena) THEN;
                END;
            END;


        }
        field(7207455; "Quantity available contracts"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Pendiente" WHERE("Proyecto" = FIELD("No."),
                                                                                                                  "Linea de Totales" = CONST(false)));
            CaptionML = ENU = 'Quantity available in contracts', ESP = 'Importe Disponible en Contratos';
            Description = 'QB 1.00- QBA 09/05/19 JAV Cantidad en contratos del proveedor';
            Editable = false;


        }
        field(7207456; "No controlar en contratos"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No controlar en contratos';
            Description = 'QB 1.00- JAV 30/06/19: No incluir en el control de contratos';


        }
        field(7207457; "Blocked By"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Bloqueado por';
            Description = 'QB 1.00- JAV 06/08/19: Quien ha bloqueado el proyecto para edici�n';
            Editable = false;


        }
        field(7207458; "Import Cost Database Direct"; Code[20])
        {
            TableRelation = "Cost Database";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Imported Cost Database Direct', ESP = 'Preciario Directos Cargado';
            Description = 'QB 1.00- JAV 02/10/19: - Que preciario de costes directos se ha cargado';
            Editable = false;


        }
        field(7207459; "Import Cost Database Dir. Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Imported Cost Database Dir. Date', ESP = 'Preciario Directos Cargado Fecha';
            Description = 'QB 1.00- JAV 02/10/19: - En que fecha se ha cargado el preciario de costes directos';
            Editable = false;


        }
        field(7207460; "Import Cost Database Indirect"; Code[20])
        {
            TableRelation = "Cost Database";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Imported Cost Database Ind. Code', ESP = 'Preciario Indirectos Cargado';
            Description = 'QB 1.00- JAV 02/10/19: - Que preciario de costes indirectos se ha cargado';
            Editable = false;


        }
        field(7207461; "Import Cost Database Ind. Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Import Date', ESP = 'Preciario Indirectos Cargado Fecha';
            Description = 'QB 1.00- JAV 02/10/19: - En que fecha se ha cargado el preciario de costes indirectos';
            Editable = false;


        }
        field(7207462; "Target Coeficient"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Target Coefficient', ESP = 'Coeficiente objetivo';
            Description = 'QB 1.00';


        }
        field(7207463; "Serie Registro Fras Vta."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Description = 'QB 1.00- JAV 21/06/19: - Serie de numeraci�n para facturas de venta por cada proyecto';


        }
        field(7207464; "Serie Registro Abonos Vta."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Description = 'QB 1.00- JAV 21/06/19: - Serie de numeraci�n para abonos de venta por cada proyecto';


        }
        field(7207465; "Serie Registro FRI"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            Description = 'QB 1.00- JAV 01/07/10: - Serie de numeraci�n para FRI por cada proyecto';


        }
        field(7207466; "Serie Registro Salida Almacen"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Serie Registro Salida Almac�n';
            Description = 'QB 1.00- JAV 09/07/10: - Serie de numeraci�n para salidas de almac�n por cada proyecto';


        }
        field(7207467; "Present. Quote Required Time"; Time)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Present. Quote Required Time', ESP = 'Hora m�xima presentacion oferta';
            Description = 'QB 1.00- JAV 22/09/19: - Se a�ade la hora de presentaci�n de las ofertas';


        }
        field(7207468; "Present. Quote Real Time"; Time)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Present. Quote Real Time', ESP = 'Hora presentaci�n oferta';
            Description = 'QB 1.00- JAV 22/09/19: - Se a�ade la hora de presentaci�n de las ofertas';


        }
        field(7207469; "Present. Quote Required Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Present. Quote Required Date', ESP = 'Fecha requerida presentacion oferta';
            Description = 'QB 1.00- QCPM_GAP02';


        }
        field(7207470; "Present. Quote Real Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Present. Quote Real Date', ESP = 'Fecha real presentaci�n oferta';
            Description = 'QB 1.00- QCPM_GAP02';


        }
        field(7207471; "Improvements"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Improvements', ESP = 'Mejoras';
            Description = 'QB 1.00- QCPM_GAP02';


        }
        field(7207472; "Bidding Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Bidding Date', ESP = 'Fecha licitaci�n';
            Description = 'QB 1.00- QCPM_GAP08';


        }
        field(7207473; "Contract Sign Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract Sign Date', ESP = 'Fecha firma contrato';
            Description = 'QB 1.00- QCPM_GAP08';


        }
        field(7207474; "Doc. Verifying Readiness Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Doc. Verifying Readiness Date', ESP = 'Fecha acta replanteo';
            Description = 'QB 1.00- QCPM_GAP08';


        }
        field(7207475; "Execution Official Term"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Execution Official Term', ESP = 'Plazo oficial de ejecuci�n';
            Description = 'QB 1.00- QCPM_GAP08';


        }
        field(7207476; "Warranty Term"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Warranty Term', ESP = 'Plazo garantia';
            Description = 'QB 1.00- QCPM_GAP08';


        }
        field(7207477; "Guarantee Provisional"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Provisional Deposit Guarantee', ESP = 'Garantia provisional';
            Description = 'QB 1.00- GARANTIAS. JAV 26/08/19: - Importe de la garant�a provisional';


        }
        field(7207478; "Guarantee Definitive"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Final Deposit Guarantee', ESP = 'Garant�a definitiva';
            Description = 'QB 1.00- GARANTIAS. JAV 26/08/19: - Importe de la garant�a definitiva';


        }
        field(7207479; "Guarantee Provisional Quote"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Guarantee"."Provisional Status Text" WHERE("Quote No." = FIELD("No.")));
            CaptionML = ENU = 'Provisional Government Deposit Guarantee', ESP = 'Garantia provisional Estado';
            Description = 'QB 1.00- GARANTIAS. JAV 07/07/19: - Estado de la garant�a provisional depositada para el estudio';
            Editable = false;


        }
        field(7207480; "Guarantee Definitive Quote"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Guarantee"."Definitive Status Text" WHERE("Quote No." = FIELD("No.")));
            CaptionML = ENU = 'Final Government Deposit Guarantee', ESP = 'Garant�a definitiva Estado';
            Description = 'QB 1.00- GARANTIAS. JAV 07/07/19: - Estado de la garant�a definitiva depositada para el estudio';
            Editable = false;


        }
        field(7207481; "Guarantee Definitive Job"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Guarantee"."Definitive Status Text" WHERE("Job No." = FIELD("No.")));
            CaptionML = ENU = 'Final Deposit Guarantee', ESP = 'Garant�a definitiva Estado';
            Description = 'QB 1.00- GARANTIAS. JAV 07/07/19: - Estado de la garant�a definitiva depositada para el proyecto';
            Editable = false;


        }
        field(7207482; "Blocked Quote Version"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blocked Quote Version', ESP = 'Versi�n estudio bloqueado';
            Description = 'QB 1.00- QCPM_GAP04';


        }
        field(7207483; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha publicaci�n';
            Description = 'QB 1.00';


        }
        field(7207484; "Job Author"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Author', ESP = 'Autor del proyecto';
            Description = 'QB 1.00- FGZ Campos para complementar los Estudios';


        }
        field(7207485; "E-mail (author)"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'E-mail (author)', ESP = 'E-mail (autor)';
            Description = 'QB 1.00- FGZ Campos para complementar los Estudios';


        }
        field(7207486; "Phone No. (author)"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Phone No. (author)', ESP = 'Tel�fono (autor)';
            Description = 'QB 1.00- FGZ Campos para complementar los Estudios';


        }
        field(7207488; "Category Code"; Code[10])
        {
            TableRelation = "TAUX Budget Category";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Category Code', ESP = 'C�digo Categor�a';
            Description = 'QB 1.00- KALAM GAP010';


        }
        field(7207489; "Category Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("TAUX Budget Category"."Description" WHERE("Code" = FIELD("Category Code")));
            CaptionML = ENU = 'Category Description', ESP = 'Descripci�n Categor�a';
            Description = 'QB 1.00- KALAM GAP010';
            Editable = false;


        }
        field(7207490; "Situation Code"; Code[20])
        {
            TableRelation = "Standard Text";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Situation Code', ESP = 'C�digo Situaci�n';
            Description = 'QB 1.00- KALAM GAP010';


        }
        field(7207491; "Situation Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Standard Text"."Description" WHERE("Code" = FIELD("Situation Code")));
            CaptionML = ENU = 'Situation Description', ESP = 'Descripci�n Situaci�n';
            Description = 'QB 1.00- KALAM GAP010';
            Editable = false;


        }
        field(7207492; "Job Phases"; Code[10])
        {
            TableRelation = "TAux Job Phases";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Phases', ESP = 'Fase del proyecto';
            Description = 'QB 1.00- KALAM GAP012    QB 1.11.02 Caption Configurable';
            CaptionClass = '7206910,167,7207492';


        }
        field(7207493; "Customer Type"; Code[20])
        {
            TableRelation = "TAux General Categories"."Code" WHERE("Use In" = FILTER('All' | 'Customers'));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Customer Type', ESP = 'Tipo de cliente';
            Description = 'QB 1.00- KALAM GAP011    QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(7207494; "Project Management"; Code[20])
        {
            TableRelation = "Contact"."No.";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Technical Management', ESP = 'Direcci�n facultativa';
            Description = 'QB 1.00- KALAM GAP015    QB 1.11.02 Caption Configurable';
            CaptionClass = '7206910,167,7207494';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Project Management Descr.");
            END;


        }
        field(7207495; "Project Management Descr."; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact"."Name" WHERE("No." = FIELD("Project Management")));
            CaptionML = ENU = 'Technical Management Descr.', ESP = 'Descripci�n Direcci�n facultativa';
            Description = 'QB 1.00- KALAM GAP015';


        }
        field(7207496; "Data Missed"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Data Missed';
            Description = 'QB 1.00- ELECNOR GEN001-02';
            Editable = false;


        }
        field(7207497; "Data Missed Message"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Data Missed Message', ESP = 'Datos Obligatorios que faltan';
            Description = 'QB 1.00- ELECNOR GEN001-02';
            Editable = false;


        }
        field(7207498; "Data Missed Old Blocked"; Option)
        {
            OptionMembers = " ","Ship","Invoice","All";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Blocked', ESP = '�ltimo bloqueo';
            OptionCaptionML = ENU = '" ,Ship,Invoice,All"', ESP = '" ,Env�ar,Facturar,Todos"';

            Description = 'QB 1.00- ELECNOR GEN001-02';

            trigger OnValidate();
            VAR
                //                                                                 CustLedgerEntry@1001 :
                CustLedgerEntry: Record 21;
                //                                                                 AccountingPeriod@1002 :
                AccountingPeriod: Record 50;
                //                                                                 IdentityManagement@1000 :
                IdentityManagement: Codeunit 9801;
            BEGIN
            END;


        }
        field(7207499; "Job Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Country/Region Code', ESP = 'C�d. pa�s/regi�n proyecto';
            Description = 'QB 1.00- ELECNOR GEN001-04';


        }
        field(7207500; "General Currencies"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'General Currencies', ESP = 'Cambios de Divisas generales';
            Description = 'QB 1.00- ELECNOR GEN003-02';


        }
        field(7207501; "Aditional Currency"; Code[10])
        {
            TableRelation = "Currency";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency', ESP = 'Divisa adicional';
            Description = 'QB 1.00- ELECNOR GEN003-02';

            trigger OnValidate();
            VAR
                //                                                                 GeneralLedgerSetup@1100286000 :
                GeneralLedgerSetup: Record 98;
                //                                                                 DiffetentReportingCurrErr@100000000 :
                DiffetentReportingCurrErr: TextConst ENU = '%1 must be different to %2 %3: %4.', ESP = '%1 debe ser diferente a %2 %3: %4.';
            BEGIN
                //GEN003-02
                IF "Aditional Currency" <> '' THEN BEGIN
                    //JMMA 080920 IF "Aditional Currency" = "Currency Code" THEN
                    //JMMA 080920   ERROR(DiffetentReportingCurrErr, FIELDCAPTION("Aditional Currency"), TABLECAPTION, FIELDCAPTION("Currency Code"), "Currency Code");

                    GeneralLedgerSetup.GET;
                    IF "Aditional Currency" = GeneralLedgerSetup."LCY Code" THEN
                        ERROR(DiffetentReportingCurrErr, FIELDCAPTION("Aditional Currency"), GeneralLedgerSetup.TABLECAPTION, GeneralLedgerSetup.FIELDCAPTION(GeneralLedgerSetup."LCY Code"), GeneralLedgerSetup."LCY Code");
                END;
            END;


        }
        field(7207502; "Currency Value Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Value Date', ESP = 'Fecha valor divisa';
            Description = 'QB 1.00- ELECNOR GEN003-02';


        }
        field(7207503; "Currency Factor (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor (LCY)', ESP = 'Factor divisa (DL)';
            Description = 'QB 1.00- ELECNOR GEN003-02';


        }
        field(7207504; "Currency Factor (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor (ACY)', ESP = 'Factor divisa (DR)';
            Description = 'QB 1.00- ELECNOR GEN003-02';


        }
        field(7207505; "Assigned Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Assigned Amount (LCY)', ESP = 'Importe adjudicado (DL)';
            Description = 'QB 1.00- ELECNOR GEN003-02';
            CaptionClass = '7206910,167,7207505';


        }
        field(7207506; "Assigned Amount (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Assigned Amount (ACY)', ESP = 'Importe adjudicado (DR)';
            Description = 'QB 1.00- ELECNOR GEN003-02';


        }
        field(7207507; "Invoiced Price (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount" WHERE("Entry Type" = CONST("Sale"),
                                                                                                            "Job No." = FIELD("No."),
                                                                                                            "Type" = FIELD("Type Filter"),
                                                                                                            "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Invoiced Price (JC)', ESP = 'Importe facturado (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207508; "Usage (Cost) (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost" WHERE("Entry Type" = CONST("Usage"),
                                                                                                          "Job No." = FIELD("No."),
                                                                                                          "Type" = FIELD("Type Filter"),
                                                                                                          "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                          "Piecework No." = FIELD("Piecework Filter")));
            CaptionML = ENU = 'Usage (Cost) (JC)', ESP = 'Consumo (p.coste) (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207509; "Production Budget Amount (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Filter"),
                                                                                                                  "Expected Date" = FIELD("Posting Date Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Production Budget Amount (JC)', ESP = 'Importe producci�n ppto. (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207510; "Direct Cost Amount PW (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                  "Unit Type" = CONST("Job Unit"),
                                                                                                                  "Entry Type" = CONST("Expenses"),
                                                                                                                  "Performed" = FIELD("Performed Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Direct Cost Amount WP (JC)', ESP = 'Importe Costes directos UO (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207511; "Indirect Cost Amount PW (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Job No." = FIELD("No."),
                                                                                                                  "Unit Type" = CONST("Cost Unit"),
                                                                                                                  "Entry Type" = CONST("Expenses"),
                                                                                                                  "Performed" = FIELD("Performed Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                  "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Indirect Cost Amount WP (JC)', ESP = 'Importe Costes Indirectos UO (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207512; "Invoiced (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount" WHERE("Entry Type" = CONST("Sale"),
                                                                                                            "Job No." = FIELD("No."),
                                                                                                            "Type" = FIELD("Type Filter"),
                                                                                                            "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                            "Job in progress" = CONST(false),
                                                                                                            "Job Sale Doc. Type" = FIELD("Job Sales Doc Type Filter")));
            CaptionML = ENU = 'Invoiced (JC)', ESP = 'Facturado (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207513; "Job in Progress (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount" WHERE("Entry Type" = CONST("Sale"),
                                                                                                            "Job No." = FIELD("No."),
                                                                                                            "Type" = FIELD("Type Filter"),
                                                                                                            "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                            "Job in progress" = CONST(true)));
            CaptionML = ENU = 'Work in Progress (JC)', ESP = 'Obra en curso (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207514; "Receive Pend. Order Amt (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."QB Outstanding Amount (JC)" WHERE("Document Type" = FILTER('Order' | 'Return Order'),
                                                                                                                       "Job No." = FIELD("No."),
                                                                                                                       "Order Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Receive Pend. Order Amount (JC)', ESP = 'Imp. pedidos pdtes. recibir (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207515; "Warehouse Availability Amt(JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."QB Outstanding Amount (JC)" WHERE("Location Code" = FIELD("Job Location"),
                                                                                                                     "Expected Cost" = CONST(false),
                                                                                                                     "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Warehouse Availability Amount (JC)', ESP = 'Importe existencia almacen (DC)';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207516; "Actual Production Amount (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Term" WHERE("Job No." = FIELD("No."),
                                                                                                                         "Piecework No." = FIELD("Piecework Filter"),
                                                                                                                         "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Actual Earned Value (JC)', ESP = 'Importe  producci�n real (DC)';
            Description = 'QB 1.08.48 -------------------------------- Cambiado JAV 04/06/21';
            Editable = false;


        }
        field(7207517; "Production Budget Amount LCY"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (LCY)" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                          "Job No." = FIELD("No."),
                                                                                                                          "Piecework Code" = FIELD("Piecework Filter"),
                                                                                                                          "Expected Date" = FIELD("Posting Date Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Production Budget Amount LCY', ESP = 'Importe ppto. producci�n DL';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207518; "Direct Cost Amount PW LCY"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (LCY)" WHERE("Job No." = FIELD("No."),
                                                                                                                          "Unit Type" = CONST("Job Unit"),
                                                                                                                          "Entry Type" = CONST("Expenses"),
                                                                                                                          "Performed" = FIELD("Performed Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                          "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Direct Cost Amount PW LCY', ESP = 'Importe Coste directo DL';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207519; "Indirect Cost Amount PW LCY"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (LCY)" WHERE("Job No." = FIELD("No."),
                                                                                                                          "Unit Type" = CONST("Cost Unit"),
                                                                                                                          "Entry Type" = CONST("Expenses"),
                                                                                                                          "Performed" = FIELD("Performed Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                          "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Indirect Cost Amount PW LCY', ESP = 'Importe Coste Indirecto DL';
            Description = 'QB 1.00- ELECNOR GEN005-03';
            Editable = false;


        }
        field(7207520; "Direct Cost Amount PW (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (ACY)" WHERE("Job No." = FIELD("No."),
                                                                                                                          "Unit Type" = CONST("Job Unit"),
                                                                                                                          "Entry Type" = CONST("Expenses"),
                                                                                                                          "Performed" = FIELD("Performed Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                          "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Direct Cost Amount WP (RC)', ESP = 'Importe Costes directos UO (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207521; "Indirect Cost Amount PW (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (ACY)" WHERE("Job No." = FIELD("No."),
                                                                                                                          "Unit Type" = CONST("Cost Unit"),
                                                                                                                          "Entry Type" = CONST("Expenses"),
                                                                                                                          "Performed" = FIELD("Performed Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                          "Analytical Concept" = FIELD("Analytic Concept Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Indirect Cost Amount WP (RC)', ESP = 'Importe Costes Indirectos UO (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207522; "Production Budget Amount (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (ACY)" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                          "Job No." = FIELD("No."),
                                                                                                                          "Piecework Code" = FIELD("Piecework Filter"),
                                                                                                                          "Expected Date" = FIELD("Posting Date Filter"),
                                                                                                                          "Cod. Budget" = FIELD("Current Piecework Budget")));
            CaptionML = ENU = 'Production Budget Amount (RC)', ESP = 'Importe producci�n ppto. (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207523; "Invoiced Price (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (ACY)" WHERE("Entry Type" = CONST("Sale"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Type" = FIELD("Type Filter"),
                                                                                                                  "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Invoiced Price (RC)', ESP = 'Importe facturado (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207524; "Usage (Cost) (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Price (ACY)" WHERE("Entry Type" = CONST("Usage"),
                                                                                                                 "Job No." = FIELD("No."),
                                                                                                                 "Type" = FIELD("Type Filter"),
                                                                                                                 "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                                 "Piecework No." = FIELD("Piecework Filter")));
            CaptionML = ENU = 'Usage (Cost) (RC)', ESP = 'Consumo (p.coste) (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207525; "Invoiced (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (ACY)" WHERE("Entry Type" = CONST("Sale"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Type" = FIELD("Type Filter"),
                                                                                                                  "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                                  "Job in progress" = CONST(false),
                                                                                                                  "Job Sale Doc. Type" = FIELD("Job Sales Doc Type Filter")));
            CaptionML = ENU = 'Invoiced (RC)', ESP = 'Facturado (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207526; "Job in Progress (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Total Price (ACY)" WHERE("Entry Type" = CONST("Sale"),
                                                                                                                  "Job No." = FIELD("No."),
                                                                                                                  "Type" = FIELD("Type Filter"),
                                                                                                                  "Posting Date" = FIELD("Posting Date Filter"),
                                                                                                                  "Job in progress" = CONST(true)));
            CaptionML = ENU = 'Work in Progress (RC)', ESP = 'Obra en curso (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207527; "Actual Production Amount (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."Amount (ACY)" WHERE("Job No." = FIELD("No."),
                                                                                                                     "Piecework No." = FIELD("Piecework Filter"),
                                                                                                                     "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Actual Production Measure (RC)', ESP = 'Importe producci�n real (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207528; "Receive Pend. Order Amt (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."QB Outstanding Amount (ACY)" WHERE("Document Type" = FILTER('Order' | 'Return Order'),
                                                                                                                        "Job No." = FIELD("No."),
                                                                                                                        "Order Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Receive Pend. Order Amount (RC)', ESP = 'Imp. pedidos pdtes. recibir (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207529; "Whse. Availability Amt (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."QB Outstanding Amount (ACY)" WHERE("Location Code" = FIELD("Job Location"),
                                                                                                                      "Expected Cost" = CONST(false),
                                                                                                                      "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Warehouse Availability Amount (RC)', ESP = 'Importe existencia almacen (DR)';
            Description = 'QB 1.00- ELECNOR Q7635';
            Editable = false;


        }
        field(7207530; "Planned K"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Planned K', ESP = 'K prevista';
            Description = 'QB 1.00- ELECNOR';


        }
        field(7207531; "Approval Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Estado Aprobaci�n';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente';

            Description = 'QB 1.03- JAV 10/03/20: - Estado de aprobaci�n';
            Editable = false;


        }
        field(7207535; "Cust. Prepayment Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Job No." = FIELD("No."),
                                                                                                 "Account Type" = CONST("Customer")));
            CaptionML = ENU = 'Amount', ESP = 'Importe Anticipos Cli. Pendientes';
            Description = 'QB 1.06 - ORTIZ OBGAP012';
            Editable = false;


        }
        field(7207536; "Cust. Prepayment Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount (LCY)" WHERE("Job No." = FIELD("No."),
                                                                                                         "Account Type" = CONST("Customer")));
            CaptionML = ENU = 'Cust. Prepayment Amount (LCY)', ESP = 'Importe Anticipos Cli. Pendientes (DL)';
            Description = 'QB 1.06 - ORTIZ OBGAP012';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207537; "Vend. Prepayment Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Job No." = FIELD("No."),
                                                                                                 "Account Type" = CONST("Vendor")));
            CaptionML = ENU = 'Vend. Prepayment Amount', ESP = 'Importe Anticipos Prov. Pendientes';
            Description = 'QB 1.06 - ORTIZ OBGAP012';
            Editable = false;


        }
        field(7207538; "Vend. Prepayment Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount (LCY)" WHERE("Job No." = FIELD("No."),
                                                                                                         "Account Type" = CONST("Vendor")));
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe Anticipos Prov. Pendientes (DL)';
            Description = 'QB 1.06 - ORTIZ OBGAP012';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207539; "Cust. Total (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("QB Job No." = FIELD("No."),
                                                                                                                      "Entry Type" = FILTER('Initial Entry' | 'Expenses'),
                                                                                                                      "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Cust. Total Amount (LCY)', ESP = 'Importe Total Cliente (DL)';
            Description = 'QB 1.06 - ORTIZ C�lculo de importe total cliente';


        }
        field(7207540; "Cust. Net Balance (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("QB Job No." = FIELD("No."),
                                                                                                                      "Excluded from calculation" = CONST(false),
                                                                                                                      "Posting Date" = FIELD("Posting Date Filter")));
            CaptionML = ENU = 'Cust. Net Balance (LCY)', ESP = 'Saldo pendiente Cliente (DL)';
            Description = 'QB 1.06 - ORTIZ C�lculo de importe saldo cliente';


        }
        field(7207541; "Actual Direct Cost (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Entry Type" = FILTER("Usage"),
                                                                                                                "Piecework Type" = FILTER("Piecework")));
            CaptionML = ENU = 'Actual Direct Cost (LCY)', ESP = 'Importe coste directo DL';
            Description = 'JMMA 160920 Importe coste directo incurrido';


        }
        field(7207542; "Actual Indirect Cost (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Entry Type" = FILTER("Usage"),
                                                                                                                "Piecework Type" = FILTER("Cost Unit")));
            CaptionML = ENU = 'Actual Indirect Cost (LCY)', ESP = 'Importe coste indirecto DL';
            Description = 'JMMA 160920 Importe coste directo incurrido';


        }
        field(7207543; "Adjust Exchange Rate Piecework"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Adjust Exchange Rate Cost Unit', ESP = 'U.O. Para diferencias cambio';
            Description = 'DIVISAS. QB 1.06.20 - JAV 12/10/20: - A que U.O. se imputan las diferencias de cambio de divisas';


        }
        field(7207544; "Adjust Exchange Rate A.C."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Adjust Exchange Rate A.C.', ESP = 'C.A. Para diferencias cambio';
            Description = 'DIVISAS. QB 1.06.20 - JAV 12/10/20: - A que Concepto Anal�tico se imputan las diferencias de cambio de divisas';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Adjust Exchange Rate A.C.");
            END;

            trigger OnLookup();
            BEGIN
                FunctionQB.LookUpCA("Adjust Exchange Rate A.C.", FALSE);
            END;


        }
        field(7207545; "Company UTE"; Text[30])
        {
            TableRelation = "Company";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'JV Company', ESP = 'Empresa UTE';
            Description = 'PRODUTE';

            trigger OnValidate();
            BEGIN
                IF ("Company UTE" <> xRec."Company UTE") THEN
                    "Job UTE" := '';
            END;


        }
        field(7207546; "Job UTE"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'JV Job', ESP = 'Proyecto en la empresa UTE';
            Description = 'PRODUTE';

            trigger OnValidate();
            VAR
                //                                                                 lJob@1100286000 :
                lJob: Record 167;
            BEGIN
                IF ("Company UTE" = '') THEN
                    ERROR(txtQB003);

                lJob.RESET;
                lJob.CHANGECOMPANY("Company UTE");
                IF (NOT lJob.GET("Job UTE")) THEN
                    ERROR(txtQB004);

                IF (lJob."Card Type" <> lJob."Card Type"::"Proyecto operativo") THEN
                    ERROR(txtQB005);
            END;

            trigger OnLookup();
            VAR
                //                                                               lJob@1100286002 :
                lJob: Record 167;
                //                                                               JobList@1100286001 :
                JobList: Page 7207608;
            BEGIN
                //Lookup de los proyectos de la empresa de la UTE
                IF ("Company UTE" = '') THEN
                    ERROR(txtQB003);

                CLEAR(JobList);
                JobList.LOOKUPMODE(TRUE);

                lJob.RESET;
                lJob.CHANGECOMPANY(Rec."Company UTE");
                lJob.SETRANGE("Card Type", lJob."Card Type"::"Proyecto operativo");
                lJob.SETRANGE("Job Type", lJob."Job Type"::Operative);
                IF (lJob.FINDSET(FALSE)) THEN
                    REPEAT
                        JobList.AddRec := lJob;
                    UNTIL (lJob.NEXT = 0);

                IF (JobList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                    JobList.GETRECORD(lJob);
                    "Job UTE" := lJob."No.";
                END;
            END;


        }
        field(7207547; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = "QB Approval Circuit Header" WHERE("Document Type" = CONST("JobBudget"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(7207550; "QB Allow Ceded"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow Ceded', ESP = 'Permite cedidos';
            Description = 'QB 1.09.21';


        }
        field(7207551; "QB Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract No.', ESP = 'N� contrato';
            Description = 'QB 1.09.21';


        }
        field(7207552; "QB Allow Service Order"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow Ceded', ESP = 'Permite Pedidos de Servicio';
            Description = 'QB 1.09.27';


        }
        field(7207560; "Shipment Pend. Amt (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (JC)" WHERE("Job No." = FIELD("No.")));
            CaptionML = ENU = 'Receive Pend. Order Amount (JC)', ESP = 'Imp. Albaranes pdtes. facturar (DC)';
            Description = 'QB 1.09.25 - JAV 28/10/21: - Importe en albaranes pendientes de facturar en divisa del proyecto';
            Editable = false;


        }
        field(7207561; "Shipment Pend. Amt (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (LCY)" WHERE("Job No." = FIELD("No.")));
            CaptionML = ENU = 'Receive Pend. Order Amount (LCY)', ESP = 'Imp. Albaranes pdtes. facturar (DL)';
            Description = 'QB 1.09.25 - JAV 28/10/21: - Importe en albaranes pendientes de facturar en divisa local';
            Editable = false;


        }
        field(7207562; "Shipment Pend. Amt (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (ACY)" WHERE("Job No." = FIELD("No.")));
            CaptionML = ENU = 'Receive Pend. Order Amount (ACY)', ESP = 'Imp. Albaranes pdtes. facturar (DA)';
            Description = 'QB 1.09.25 - JAV 28/10/21: - Importe en albaranes pendientes de facturar en divisa adicional';
            Editable = false;


        }
        field(7207563; "Shipment FRI Pend. Amt (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (JC)" WHERE("Job No." = FIELD("No."),
                                                                                                                            "Received on FRI" = CONST(true)));
            CaptionML = ENU = 'Receive Pend. Order Amount (JC)', ESP = 'Imp. FRI pdtes. facturar (DC)';
            Description = 'QB 1.09.25 - JAV 28/10/21: - Importe en albaranes pendientes de facturar en divisa del proyecto';
            Editable = false;


        }
        field(7207564; "Shipment FRI Pend. Amt (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (LCY)" WHERE("Job No." = FIELD("No."),
                                                                                                                             "Received on FRI" = CONST(true)));
            CaptionML = ESP = 'Imp. FRI pdtes. facturar (DL)';
            Description = 'QB 1.09.25 - JAV 28/10/21: - Importe en albaranes pendientes de facturar en divisa local';


        }
        field(7207565; "Shipment FRI Pend. Amt (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (ACY)" WHERE("Job No." = FIELD("No."),
                                                                                                                             "Received on FRI" = CONST(true)));
            CaptionML = ESP = 'Imp. FRI pdtes. facturar (DA)';
            Description = 'QB 1.09.25 - JAV 28/10/21: - Importe en albaranes pendientes de facturar en divisa adicional';


        }
        field(7238203; "QB_Last Closing Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Closing Date', ESP = '�ltima fecha cierre';
            Description = 'QRE 1.00.00 15419';


        }
        field(7238400; "QB_Budget control"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Control presupuestario';
            Description = 'QRE 1.00.00 15469';


        }
        field(7238401; "Percentage rate in Breakdown"; Option)
        {
            OptionMembers = "General ledger setup","Price list";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo redondeo en descompuesto', ENG = 'Percentage rate in Breakdown';
            OptionCaptionML = ESP = 'Conf contabilidad,Preciario', ENG = 'General ledger setup,Price list';

            Description = 'QBAML';


        }
        field(7238402; "Percentage price list"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Redondeo preciario', ENG = 'Percentage price list';
            Description = 'QBAML';


        }
    }
    keys
    {
        // key(key1;"No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Search Description")
        //  {
        /* ;
  */
        // }
        // key(key3;"Bill-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Description")
        //  {
        /* ;
  */
        // }
        // key(key5;"Status")
        //  {
        /* ;
  */
        // }
        key(Extkey6; "Job Matrix - Work", "Matrix Job it Belongs")
        {
            ;
        }
        key(Extkey7; "Global Dimension 1 Code", "No.")
        {
            ;
        }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"No.","Description","Bill-to Customer No.","Starting Date","Status")
        // {
        // 
        // }
        // fieldgroup(Brick;"No.","Description","Bill-to Customer No.","Starting Date","Status","Image")
        // {
        // 
        // }
    }

    var
        //       AssociatedEntriesExistErr@1000 :
        AssociatedEntriesExistErr:
// "%1 = Name of field used in the error; %2 = The name of the Job table"
TextConst ENU = 'You cannot change %1 because one or more entries are associated with this %2.', ESP = 'No puede cambiar el %1 porque hay uno o m�s movimientos asociados con este %2.';
        //       JobsSetup@1004 :
        JobsSetup: Record 315;
        //       PostCode@1015 :
        PostCode: Record 225;
        //       Job@1014 :
        Job: Record 167;
        //       Cust@1006 :
        Cust: Record 18;
        //       Cont@1005 :
        Cont: Record 5050;
        //       ContBusinessRelation@1001 :
        ContBusinessRelation: Record 5054;
        //       NoSeriesMgt@1010 :
        NoSeriesMgt: Codeunit 396;
        //       DimMgt@1012 :
        DimMgt: Codeunit 408;
        //       StatusChangeQst@1017 :
        StatusChangeQst: TextConst ENU = 'This will delete any unposted WIP entries for this job and allow you to reverse the completion postings for this job.\\Do you wish to continue?', ESP = 'De esta manera eliminar� cualquier movimiento WIP no registrado para este proyecto y podr� revertir los registros completados para este proyecto.\\�Desea continuar?';
        //       ContactBusRelDiffCompErr@1019 :
        ContactBusRelDiffCompErr:
// "%1 = The contact number; %2 = The contact''s name; %3 = The Bill-To Customer Number associated with this job"
TextConst ENU = 'Contact %1 %2 is related to a different company than customer %3.', ESP = 'Contacto %1 %2 est� relacionado con una empresa diferente al cliente %3.';
        //       ContactBusRelErr@1018 :
        ContactBusRelErr:
// "%1 = The contact number; %2 = The contact''s name; %3 = The Bill-To Customer Number associated with this job"
TextConst ENU = 'Contact %1 %2 is not related to customer %3.', ESP = 'Contacto %1 %2 no est� relacionado con el cliente %3.';
        //       ContactBusRelMissingErr@1009 :
        ContactBusRelMissingErr:
// "%1 = The contact number; %2 = The contact''s name"
TextConst ENU = 'Contact %1 %2 is not related to a customer.', ESP = 'Contacto %1 %2 no est� relacionado con un cliente.';
        //       TestBlockedErr@1002 :
        TestBlockedErr:
// "%1 = The Job table name; %2 = The Job number; %3 = The value of the Blocked field"
TextConst ENU = '%1 %2 must not be blocked with type %3.', ESP = 'El %1 %2 no debe estar bloqueado con el tipo %3.';
        //       ReverseCompletionEntriesMsg@1008 :
        ReverseCompletionEntriesMsg:
// "%1 = The name of the Job Post WIP to G/L report"
TextConst ENU = 'You must run the %1 function to reverse the completion entries that have already been posted for this job.', ESP = 'Debe ejecutar la funci�n %1 para revertir los movimientos completados registrados para este proyecto.';
        //       MoveEntries@1003 :
        MoveEntries: Codeunit 361;
        //       OnlineMapMsg@1007 :
        OnlineMapMsg: TextConst ENU = 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.', ESP = 'Para poder usar Online Map, primero debe rellenar la ventana Configuraci�n Online Map.\Consulte Configuraci�n de Online Map en la Ayuda.';
        //       CheckDateErr@1023 :
        CheckDateErr:
// "%1 = The job''s starting date; %2 = The job''s ending date"
TextConst ENU = '%1 must be equal to or earlier than %2.', ESP = '%1 debe ser igual o anterior a %2.';
        //       BlockedCustErr@1011 :
        BlockedCustErr:
// "%1 = The Bill-to Customer No. field name; %2 = The job''s Bill-to Customer No. value; %3 = The Customer table name; %4 = The Blocked field name; %5 = The job''s customer''s Blocked value"
TextConst ENU = 'You cannot set %1 to %2, as this %3 has set %4 to %5.', ESP = 'No puede establecer %1 en %2, puesto que este %3 ha establecido %4 en %5.';
        //       ApplyUsageLinkErr@1013 :
        ApplyUsageLinkErr:
// "%1 = The name of the Job table"
TextConst ENU = 'A usage link cannot be enabled for the entire %1 because usage without the usage link already has been posted.', ESP = 'No se puede activar un v�nculo de uso para el %1 completo porque ya se ha registrado el uso sin v�nculo de uso.';
        //       WIPMethodQst@1016 :
        WIPMethodQst:
// "%1 = The WIP Method field name; %2 = The name of the Job Task table; %3 = The current job task''s WIP Total type"
TextConst ENU = 'Do you want to set the %1 on every %2 of type %3?', ESP = '�Desea establecer el %1 en cada %2 de tipo %3?';
        //       WIPAlreadyPostedErr@1020 :
        WIPAlreadyPostedErr:
// "%1 = The name of the WIP Posting Method field; %2 = The previous WIP Posting Method value of this job"
TextConst ENU = '%1 must be %2 because job WIP general ledger entries already were posted with this setting.', ESP = '%1 debe ser %2 porque los Movs. contabilidad WIP proyecto ya se registraron con esta configuraci�n.';
        //       WIPAlreadyAssociatedErr@1021 :
        WIPAlreadyAssociatedErr:
// "%1 = The name of the WIP Posting Method field"
TextConst ENU = '%1 cannot be modified because the job has associated job WIP entries.', ESP = '%1 no se puede modificar porque el proyecto se ha asociado a Movs. WIP proyecto.';
        //       WIPPostMethodErr@1024 :
        WIPPostMethodErr:
// "%1 = The name of the WIP Posting Method field; %2 = The name of the WIP Method field; %3 = The field caption represented by the value of this job''s WIP method"
TextConst ENU = 'The selected %1 requires the %2 to have %3 enabled.', ESP = 'El %1 seleccionado requiere que %2 tenga %3 activado.';
        //       EndingDateChangedMsg@1025 :
        EndingDateChangedMsg:
// "%1 = The name of the Ending Date field; %2 = This job''s Ending Date value"
TextConst ENU = '%1 is set to %2.', ESP = '%1 se establece en %2.';
        //       UpdateJobTaskDimQst@1026 :
        UpdateJobTaskDimQst: TextConst ENU = 'You have changed a dimension.\\Do you want to update the lines?', ESP = 'Ha cambiado una dimensi�n.\\�Desea actualizar las l�neas?';
        //       DocTxt@1027 :
        DocTxt: TextConst ENU = 'Job Quote', ESP = 'Oferta de trabajo';
        //       RunWIPFunctionsQst@1028 :
        RunWIPFunctionsQst:
// "%1 = The name of the Job Calculate WIP report"
TextConst ENU = 'You must run the %1 function to create completion entries for this job. \Do you want to run this function now?', ESP = 'Debe ejecutar la funci�n %1 para crear los movimientos de finalizaci�n de este proyecto. \�Desea ejecutar esta funci�n ahora?';
        //       DifferentCurrenciesErr@1022 :
        DifferentCurrenciesErr: TextConst ENU = 'You cannot plan and invoice a job in different currencies.', ESP = 'No puede planificar y facturar un trabajo en distintas divisas.';
        //       "---------------------------- QB"@100000001 :
        "---------------------------- QB": Integer;
        //       FunctionQB@7207272 :
        FunctionQB: Codeunit 7207272;
        //       DimensionValue@7001101 :
        DimensionValue: Record 349;
        //       QBTableSubscriber@1100286000 :
        QBTableSubscriber: Codeunit 7207347;
        //       OperativeJobsCard@7001105 :
        OperativeJobsCard: Page 7207478;
        //       "--------------------------- QB"@1100286002 :
        "--------------------------- QB": TextConst;
        //       txtQB000@1100286003 :
        txtQB000: TextConst ESP = 'ATENCION: Este proceso es irreversible, confirme que realmente desea separa coste y venta';
        //       txtQB001@1100286004 :
        txtQB001: TextConst ESP = 'No puede volver atr�s la separaci�n coste/venta';
        //       txtQB002@1100286005 :
        txtQB002: TextConst ESP = 'No puede cambiar el tipo de facturaci�n, ya ha definido Hitos';
        //       txtQB003@1100286006 :
        txtQB003: TextConst ESP = 'Debe seleccionar la empresa UTE';
        //       txtQB004@1100286007 :
        txtQB004: TextConst ESP = 'No existe el proyecto en la empresa UTE';
        //       txtQB005@1100286008 :
        txtQB005: TextConst ESP = 'El proyecto debe ser operativo.';





    /*
    trigger OnInsert();    begin
                   JobsSetup.GET;

                   if "No." = '' then begin
                     JobsSetup.TESTFIELD("Job Nos.");
                     NoSeriesMgt.InitSeries(JobsSetup."Job Nos.",xRec."No. Series",0D,"No.","No. Series");
                   end;

                   if GETFILTER("Bill-to Customer No.") <> '' then
                     if GETRANGEMIN("Bill-to Customer No.") = GETRANGEMAX("Bill-to Customer No.") then
                       VALIDATE("Bill-to Customer No.",GETRANGEMIN("Bill-to Customer No."));

                   if not "Apply Usage Link" then
                     VALIDATE("Apply Usage Link",JobsSetup."Apply Usage Link by Default");
                   if not "Allow Schedule/Contract Lines" then
                     VALIDATE("Allow Schedule/Contract Lines",JobsSetup."Allow Sched/Contract Lines Def");
                   if "WIP Method" = '' then
                     VALIDATE("WIP Method",JobsSetup."Default WIP Method");
                   if "Job Posting Group" = '' then
                     VALIDATE("Job Posting Group",JobsSetup."Default Job Posting Group");
                   VALIDATE("WIP Posting Method",JobsSetup."Default WIP Posting Method");

                   DimMgt.UpdateDefaultDim(
                     DATABASE::Job,"No.",
                     "Global Dimension 1 Code","Global Dimension 2 Code");
                   InitWIPFields;

                   "Creation Date" := TODAY;
                   "Last Date Modified" := "Creation Date";

                   if ("Project Manager" <> '') and (Status = Status::Open) then
                     AddToMyJobs("Project Manager");
                 end;


    */

    /*
    trigger OnModify();    begin
                   "Last Date Modified" := TODAY;

                   if (("Project Manager" <> xRec."Project Manager") and (xRec."Project Manager" <> '')) or (Status <> Status::Open) then
                     RemoveFromMyJobs;

                   if ("Project Manager" <> '') and (xRec."Project Manager" <> "Project Manager") then
                     if Status = Status::Open then
                       AddToMyJobs("Project Manager");
                 end;


    */

    /*
    trigger OnDelete();    var
    //                CommentLine@1004 :
                   CommentLine: Record 97;
    //                JobTask@1000 :
                   JobTask: Record 1001;
    //                JobResPrice@1001 :
                   JobResPrice: Record 1012;
    //                JobItemPrice@1002 :
                   JobItemPrice: Record 1013;
    //                JobGLAccPrice@1003 :
                   JobGLAccPrice: Record 1014;
                 begin
                   MoveEntries.MoveJobEntries(Rec);

                   JobTask.SETCURRENTKEY("Job No.");
                   JobTask.SETRANGE("Job No.","No.");
                   JobTask.DELETEALL(TRUE);

                   JobResPrice.SETRANGE("Job No.","No.");
                   JobResPrice.DELETEALL;

                   JobItemPrice.SETRANGE("Job No.","No.");
                   JobItemPrice.DELETEALL;

                   JobGLAccPrice.SETRANGE("Job No.","No.");
                   JobGLAccPrice.DELETEALL;

                   CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Job);
                   CommentLine.SETRANGE("No.","No.");
                   CommentLine.DELETEALL;

                   DimMgt.DeleteDefaultDim(DATABASE::Job,"No.");

                   if "Project Manager" <> '' then
                     RemoveFromMyJobs;
                 end;


    */

    /*
    trigger OnRename();    begin
                   UpdateJobNoInReservationEntries;
                   DimMgt.RenameDefaultDim(DATABASE::Job,xRec."No.","No.");
                   "Last Date Modified" := TODAY;
                 end;

    */



    // procedure AssistEdit (OldJob@1000 :

    /*
    procedure AssistEdit (OldJob: Record 167) : Boolean;
        begin
          WITH Job DO begin
            Job := Rec;
            JobsSetup.GET;
            JobsSetup.TESTFIELD("Job Nos.");
            if NoSeriesMgt.SelectSeries(JobsSetup."Job Nos.",OldJob."No. Series","No. Series") then begin
              NoSeriesMgt.SetSeries("No.");
              Rec := Job;
              exit(TRUE);
            end;
          end;
        end;
    */



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Job, "No.", FieldNumber, ShortcutDimCode);
        if not FunctionQB.AccessToQuobuilding then  //QB
            UpdateJobTaskDimension(FieldNumber, ShortcutDimCode);
        MODIFY;
    end;

    //     LOCAL procedure UpdateBillToCont (CustomerNo@1000 :


    LOCAL procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        //       ContBusRel@1003 :
        ContBusRel: Record 5054;
        //       Cust@1001 :
        Cust: Record 18;
    begin
        if Cust.GET(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
                "Bill-to Contact No." := Cust."Primary Contact No."
            else begin
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "Bill-to Customer No.");
                if ContBusRel.FINDFIRST then
                    "Bill-to Contact No." := ContBusRel."Contact No.";
            end;
            "Bill-to Contact" := Cust.Contact;
        end;
    end;




    /*
    LOCAL procedure JobLedgEntryExist () : Boolean;
        var
    //       JobLedgEntry@1000 :
          JobLedgEntry: Record 169;
        begin
          CLEAR(JobLedgEntry);
          JobLedgEntry.SETCURRENTKEY("Job No.");
          JobLedgEntry.SETRANGE("Job No.","No.");
          exit(JobLedgEntry.FINDFIRST);
        end;
    */



    /*
    LOCAL procedure JobPlanningLineExist () : Boolean;
        var
    //       JobPlanningLine@1000 :
          JobPlanningLine: Record 1003;
        begin
          JobPlanningLine.INIT;
          JobPlanningLine.SETRANGE("Job No.","No.");
          exit(JobPlanningLine.FINDFIRST);
        end;
    */


    //     LOCAL procedure UpdateBillToCust (ContactNo@1000 :

    /*
    LOCAL procedure UpdateBillToCust (ContactNo: Code[20])
        var
    //       ContBusinessRelation@1005 :
          ContBusinessRelation: Record 5054;
    //       Cust@1004 :
          Cust: Record 18;
    //       Cont@1003 :
          Cont: Record 5050;
        begin
          if Cont.GET(ContactNo) then begin
            "Bill-to Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
              "Bill-to Contact" := Cont.Name
            else
              if Cust.GET("Bill-to Customer No.") then
                "Bill-to Contact" := Cust.Contact
              else
                "Bill-to Contact" := '';
          end else begin
            "Bill-to Contact" := '';
            exit;
          end;

          if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") then begin
            if "Bill-to Customer No." = '' then
              VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.")
            else
              if "Bill-to Customer No." <> ContBusinessRelation."No." then
                ERROR(ContactBusRelErr,Cont."No.",Cont.Name,"Bill-to Customer No.");
          end else
            ERROR(ContactBusRelMissingErr,Cont."No.",Cont.Name);
        end;
    */


    LOCAL procedure UpdateCust()
    var
        //       Comercial@1100286000 :
        Comercial: Code[20];
        //       xCust@100000000 :
        xCust: Record 18;
    begin
        if "Bill-to Customer No." <> '' then begin
            Cust.GET("Bill-to Customer No.");
            Cust.TESTFIELD("Customer Posting Group");
            Cust.TESTFIELD("Bill-to Customer No.", '');
            if Cust."Privacy Blocked" then
                ERROR(Cust.GetPrivacyBlockedGenericErrorText(Cust));
            if Cust.Blocked = Cust.Blocked::All then
                ERROR(
                  BlockedCustErr,
                  FIELDCAPTION("Bill-to Customer No."),
                  "Bill-to Customer No.",
                  Cust.TABLECAPTION,
                  FIELDCAPTION(Blocked),
                  Cust.Blocked);
            "Bill-to Name" := Cust.Name;
            "Bill-to Name 2" := Cust."Name 2";
            "Bill-to Address" := Cust.Address;
            "Bill-to Address 2" := Cust."Address 2";
            "Bill-to City" := Cust.City;
            "Bill-to Post Code" := Cust."Post Code";
            "Bill-to Country/Region Code" := Cust."Country/Region Code";
            "Invoice Currency Code" := Cust."Currency Code";
            if "Invoice Currency Code" <> '' then
                VALIDATE("Currency Code", '');
            "Customer Disc. Group" := Cust."Customer Disc. Group";
            "Customer Price Group" := Cust."Customer Price Group";
            "Language Code" := Cust."Language Code";
            "Bill-to County" := Cust.County;
            Reserve := Cust.Reserve;
            UpdateBillToCont("Bill-to Customer No.");
            //QB No podemos llamar a esto: CopyDefaultDimensionsFromCustomer;
        end else begin
            "Bill-to Name" := '';
            "Bill-to Name 2" := '';
            "Bill-to Address" := '';
            "Bill-to Address 2" := '';
            "Bill-to City" := '';
            "Bill-to Post Code" := '';
            "Bill-to Country/Region Code" := '';
            "Invoice Currency Code" := '';
            "Customer Disc. Group" := '';
            "Customer Price Group" := '';
            "Language Code" := '';
            "Bill-to County" := '';
            VALIDATE("Bill-to Contact No.", '');
        end;

        OnAfterUpdateBillToCust(Rec);
    end;



    /*
    procedure InitWIPFields ()
        begin
          "WIP Posting Date" := 0D;
          "WIP G/L Posting Date" := 0D;
        end;
    */




    /*
    procedure TestBlocked ()
        begin
          if Blocked = Blocked::" " then
            exit;
          ERROR(TestBlockedErr,TABLECAPTION,"No.",Blocked);
        end;
    */




    /*
    procedure CurrencyUpdatePlanningLines ()
        var
    //       JobPlanningLine@1000 :
          JobPlanningLine: Record 1003;
        begin
          JobPlanningLine.SETRANGE("Job No.","No.");
          JobPlanningLine.SETAUTOCALCFIELDS("Qty. Transferred to Invoice");
          JobPlanningLine.LOCKTABLE;
          if JobPlanningLine.FIND('-') then
            repeat
              if JobPlanningLine."Qty. Transferred to Invoice" <> 0 then
                ERROR(AssociatedEntriesExistErr,FIELDCAPTION("Currency Code"),TABLECAPTION);
              JobPlanningLine.VALIDATE("Currency Code","Currency Code");
              JobPlanningLine.VALIDATE("Currency Date");
              JobPlanningLine.MODIFY;
            until JobPlanningLine.NEXT = 0;
        end;
    */



    /*
    LOCAL procedure CurrencyUpdatePurchLines ()
        var
    //       PurchLine@1000 :
          PurchLine: Record 39;
        begin
          MODIFY;
          PurchLine.SETRANGE("Job No.","No.");
          if PurchLine.FINDSET then
            repeat
              PurchLine.VALIDATE("Job Currency Code","Currency Code");
              PurchLine.VALIDATE("Job Task No.");
              PurchLine.MODIFY;
            until PurchLine.NEXT = 0;
        end;
    */



    /*
    LOCAL procedure ChangeJobCompletionStatus ()
        var
    //       JobCalcWIP@1001 :
          JobCalcWIP: Codeunit 1000;
        begin
          if Complete then begin
            VALIDATE("Ending Date",CalcEndingDate);
            MESSAGE(EndingDateChangedMsg,FIELDCAPTION("Ending Date"),"Ending Date");
          end else begin
            JobCalcWIP.ReOpenJob("No.");
            "WIP Posting Date" := 0D;
            MESSAGE(ReverseCompletionEntriesMsg,GetReportCaption(REPORT::"Job Post WIP to G/L"));
          end;

          OnAfterChangeJobCompletionStatus(Rec,xRec)
        end;
    */




    /*
    procedure DisplayMap ()
        var
    //       OnlineMapSetup@1001 :
          OnlineMapSetup: Record 800;
    //       OnlineMapManagement@1000 :
          OnlineMapManagement: Codeunit 802;
        begin
          if OnlineMapSetup.FINDFIRST then
            OnlineMapManagement.MakeSelection(DATABASE::Job,GETPOSITION)
          else
            MESSAGE(OnlineMapMsg);
        end;
    */



    //     procedure GetQuantityAvailable (ItemNo@1000 : Code[20];LocationCode@1001 : Code[10];VariantCode@1002 : Code[10];InEntryType@1004 : 'Usage,Sale,Both';Direction@1005 :

    /*
    procedure GetQuantityAvailable (ItemNo: Code[20];LocationCode: Code[10];VariantCode: Code[10];InEntryType: Option "Usage","Sale","Both";Direction: Option "Positive","Negative","Bot") : Decimal;
        var
    //       JobLedgEntry@1003 :
          JobLedgEntry: Record 169;
        begin
          CLEAR(JobLedgEntry);
          JobLedgEntry.SETCURRENTKEY("Job No.","Entry Type",Type,"No.");
          JobLedgEntry.SETRANGE("Job No.","No.");
          if not (InEntryType = InEntryType::Both) then
            JobLedgEntry.SETRANGE("Entry Type",InEntryType);
          JobLedgEntry.SETRANGE(Type,JobLedgEntry.Type::Item);
          JobLedgEntry.SETRANGE("No.",ItemNo);
          CASE Direction OF
            Direction::Both:
              begin
                JobLedgEntry.SETRANGE("Location Code",LocationCode);
                JobLedgEntry.SETRANGE("Variant Code",VariantCode);
              end;
            Direction::Positive:
              JobLedgEntry.SETFILTER("Quantity (Base)",'>0');
            Direction::Negative:
              JobLedgEntry.SETFILTER("Quantity (Base)",'<0');
          end;
          JobLedgEntry.CALCSUMS("Quantity (Base)");
          exit(JobLedgEntry."Quantity (Base)");
        end;
    */



    /*
    LOCAL procedure CheckDate ()
        begin
          if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
            ERROR(CheckDateErr,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
        end;
    */




    /*
    procedure CalcAccWIPCostsAmount () : Decimal;
        begin
          exit("Total WIP Cost Amount" + "Applied Costs G/L Amount");
        end;
    */




    /*
    procedure CalcAccWIPSalesAmount () : Decimal;
        begin
          exit("Total WIP Sales Amount" - "Applied Sales G/L Amount");
        end;
    */




    /*
    procedure CalcRecognizedProfitAmount () : Decimal;
        begin
          exit("Calc. Recog. Sales Amount" - "Calc. Recog. Costs Amount");
        end;
    */




    /*
    procedure CalcRecognizedProfitPercentage () : Decimal;
        begin
          if "Calc. Recog. Sales Amount" <> 0 then
            exit((CalcRecognizedProfitAmount / "Calc. Recog. Sales Amount") * 100);
          exit(0);
        end;
    */




    /*
    procedure CalcRecognizedProfitGLAmount () : Decimal;
        begin
          exit("Calc. Recog. Sales G/L Amount" - "Calc. Recog. Costs G/L Amount");
        end;
    */




    /*
    procedure CalcRecognProfitGLPercentage () : Decimal;
        begin
          if "Calc. Recog. Sales G/L Amount" <> 0 then
            exit((CalcRecognizedProfitGLAmount / "Calc. Recog. Sales G/L Amount") * 100);
          exit(0);
        end;
    */




    /*
    procedure CopyDefaultDimensionsFromCustomer ()
        var
    //       CustDefaultDimension@1001 :
          CustDefaultDimension: Record 352;
    //       JobDefaultDimension@1002 :
          JobDefaultDimension: Record 352;
        begin
          JobDefaultDimension.SETRANGE("Table ID",DATABASE::Job);
          JobDefaultDimension.SETRANGE("No.","No.");
          if JobDefaultDimension.FINDSET then
            repeat
              DimMgt.DefaultDimOnDelete(JobDefaultDimension);
              JobDefaultDimension.DELETE;
            until JobDefaultDimension.NEXT = 0;

          CustDefaultDimension.SETRANGE("Table ID",DATABASE::Customer);
          CustDefaultDimension.SETRANGE("No.","Bill-to Customer No.");
          if CustDefaultDimension.FINDSET then
            repeat
              JobDefaultDimension.INIT;
              JobDefaultDimension.TRANSFERFIELDS(CustDefaultDimension);
              JobDefaultDimension."Table ID" := DATABASE::Job;
              JobDefaultDimension."No." := "No.";
              JobDefaultDimension.INSERT;
              DimMgt.DefaultDimOnInsert(JobDefaultDimension);
            until CustDefaultDimension.NEXT = 0;

          DimMgt.UpdateDefaultDim(DATABASE::Job,"No.","Global Dimension 1 Code","Global Dimension 2 Code");
        end;
    */




    /*
    procedure CurrencyCheck ()
        begin
          if ("Invoice Currency Code" <> "Currency Code") and ("Invoice Currency Code" <> '') and ("Currency Code" <> '') then
            ERROR(DifferentCurrenciesErr);
        end;
    */




    /*
    procedure PercentCompleted () : Decimal;
        var
    //       JobCalcStatistics@1000 :
          JobCalcStatistics: Codeunit 1008;
    //       CL@1001 :
          CL: ARRAY [16] OF Decimal;
        begin
          JobCalcStatistics.JobCalculateCommonFilters(Rec);
          JobCalcStatistics.CalculateAmounts;
          JobCalcStatistics.GetLCYCostAmounts(CL);
          if CL[4] <> 0 then
            exit((CL[8] / CL[4]) * 100);
          exit(0);
        end;
    */




    /*
    procedure PercentInvoiced () : Decimal;
        var
    //       JobCalcStatistics@1000 :
          JobCalcStatistics: Codeunit 1008;
    //       PL@1002 :
          PL: ARRAY [16] OF Decimal;
        begin
          JobCalcStatistics.JobCalculateCommonFilters(Rec);
          JobCalcStatistics.CalculateAmounts;
          JobCalcStatistics.GetLCYPriceAmounts(PL);
          if PL[12] <> 0 then
            exit((PL[16] / PL[12]) * 100);
          exit(0);
        end;
    */




    /*
    procedure PercentOverdue () : Decimal;
        var
    //       JobPlanningLine@1000 :
          JobPlanningLine: Record 1003;
    //       QtyOverdue@1001 :
          QtyOverdue: Decimal;
    //       QtyTotal@1003 :
          QtyTotal: Decimal;
        begin
          JobPlanningLine.SETRANGE("Job No.","No.");
          QtyTotal := JobPlanningLine.COUNT;
          if QtyTotal = 0 then
            exit(0);
          JobPlanningLine.SETFILTER("Planning Date",'<%1',WORKDATE);
          JobPlanningLine.SETFILTER("Remaining Qty.",'>%1',0);
          QtyOverdue := JobPlanningLine.COUNT;
          exit((QtyOverdue / QtyTotal) * 100);
        end;
    */



    /*
    LOCAL procedure UpdateJobNoInReservationEntries ()
        var
    //       ReservEntry@1001 :
          ReservEntry: Record 337;
        begin
          ReservEntry.SETFILTER("Source Type",'%1|%2',DATABASE::"Job Planning Line",DATABASE::"Job Journal Line");
          ReservEntry.SETRANGE("Source ID",xRec."No.");
          ReservEntry.MODIFYALL("Source ID","No.",TRUE);
        end;
    */


    //     LOCAL procedure UpdateJobTaskDimension (FieldNumber@1001 : Integer;ShortcutDimCode@1000 :


    LOCAL procedure UpdateJobTaskDimension(FieldNumber: Integer; ShortcutDimCode: Code[20])
    var
        //       JobTask@1002 :
        JobTask: Record 1001;
    begin
        if GUIALLOWED then
            if not CONFIRM(UpdateJobTaskDimQst, FALSE) then
                exit;

        JobTask.SETRANGE("Job No.", "No.");
        if JobTask.FINDSET(TRUE) then
            repeat
                CASE FieldNumber OF
                    1:
                        JobTask.VALIDATE("Global Dimension 1 Code", ShortcutDimCode);
                    2:
                        JobTask.VALIDATE("Global Dimension 2 Code", ShortcutDimCode);
                end;
                JobTask.MODIFY;
            until JobTask.NEXT = 0;
    end;




    //     procedure UpdateOverBudgetValue (JobNo@1002 : Code[20];Usage@1001 : Boolean;Cost@1007 :

    /*
    procedure UpdateOverBudgetValue (JobNo: Code[20];Usage: Boolean;Cost: Decimal)
        var
    //       JobLedgerEntry@1003 :
          JobLedgerEntry: Record 169;
    //       JobPlanningLine@1004 :
          JobPlanningLine: Record 1003;
    //       UsageCost@1005 :
          UsageCost: Decimal;
    //       ScheduleCost@1006 :
          ScheduleCost: Decimal;
    //       NewOverBudget@1000 :
          NewOverBudget: Boolean;
        begin
          if "No." <> JobNo then
            if not GET(JobNo) then
              exit;

          JobLedgerEntry.SETRANGE("Job No.",JobNo);
          JobLedgerEntry.CALCSUMS("Total Cost (LCY)");
          if JobLedgerEntry."Total Cost (LCY)" = 0 then
            exit;

          UsageCost := JobLedgerEntry."Total Cost (LCY)";

          JobPlanningLine.SETRANGE("Job No.",JobNo);
          JobPlanningLine.SETRANGE("Schedule Line",TRUE);
          JobPlanningLine.CALCSUMS("Total Cost (LCY)");
          ScheduleCost := JobPlanningLine."Total Cost (LCY)";

          if Usage then
            UsageCost += Cost
          else
            ScheduleCost += Cost;
          NewOverBudget := UsageCost > ScheduleCost;
          if NewOverBudget <> "Over Budget" then begin
            "Over Budget" := NewOverBudget;
            MODIFY;
          end;
        end;
    */




    /*
    procedure IsJobSimplificationAvailable () : Boolean;
        begin
          exit(TRUE);
        end;
    */


    //     LOCAL procedure AddToMyJobs (ProjectManager@1000 :

    /*
    LOCAL procedure AddToMyJobs (ProjectManager: Code[50])
        var
    //       MyJob@1001 :
          MyJob: Record 9154;
        begin
          if Status = Status::Open then begin
            MyJob.INIT;
            MyJob."User ID" := ProjectManager;
            MyJob."Job No." := "No.";
            MyJob.Description := Description;
            MyJob.Status := Status;
            MyJob."Bill-to Name" := "Bill-to Name";
            MyJob."Percent Completed" := PercentCompleted;
            MyJob."Percent Invoiced" := PercentInvoiced;
            MyJob."Exclude from Business Chart" := FALSE;
            MyJob.INSERT;
          end;
        end;
    */



    /*
    LOCAL procedure RemoveFromMyJobs ()
        var
    //       MyJob@1001 :
          MyJob: Record 9154;
        begin
          MyJob.SETFILTER("Job No.",'=%1',"No.");
          if MyJob.FINDSET then
            repeat
              MyJob.DELETE;
            until MyJob.NEXT = 0;
        end;
    */




    /*
    procedure SendRecords ()
        var
    //       DocumentSendingProfile@1001 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1000 :
          DummyReportSelections: Record 77;
        begin
          DocumentSendingProfile.SendCustomerRecords(
            DummyReportSelections.Usage::JQ,Rec,DocTxt,"Bill-to Customer No.","No.",
            FIELDNO("Bill-to Customer No."),FIELDNO("No."));
        end;
    */



    //     procedure SendProfile (var DocumentSendingProfile@1000 :

    /*
    procedure SendProfile (var DocumentSendingProfile: Record 60)
        var
    //       ReportSelections@1003 :
          ReportSelections: Record 77;
        begin
          DocumentSendingProfile.Send(
            ReportSelections.Usage::JQ,Rec,"No.","Bill-to Customer No.",
            DocTxt,FIELDNO("Bill-to Customer No."),FIELDNO("No."));
        end;
    */



    //     procedure PrintRecords (ShowRequestForm@1000 :

    /*
    procedure PrintRecords (ShowRequestForm: Boolean)
        var
    //       DocumentSendingProfile@1002 :
          DocumentSendingProfile: Record 60;
    //       ReportSelections@1001 :
          ReportSelections: Record 77;
        begin
          DocumentSendingProfile.TrySendToPrinter(
            ReportSelections.Usage::JQ,Rec,FIELDNO("Bill-to Customer No."),ShowRequestForm);
        end;
    */



    //     procedure EmailRecords (ShowDialog@1000 :

    /*
    procedure EmailRecords (ShowDialog: Boolean)
        var
    //       DocumentSendingProfile@1003 :
          DocumentSendingProfile: Record 60;
    //       ReportSelections@1001 :
          ReportSelections: Record 77;
        begin
          DocumentSendingProfile.TrySendToEMail(
            ReportSelections.Usage::JQ,Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
        end;
    */




    /*
    procedure RecalculateJobWIP ()
        var
    //       Job@1000 :
          Job: Record 167;
    //       Confirmed@1001 :
          Confirmed: Boolean;
    //       WIPQst@1002 :
          WIPQst: Text;
        begin
          Job.GET("No.");
          if Job."WIP Method" = '' then
            exit;

          Job.SETRECFILTER;
          WIPQst := STRSUBSTNO(RunWIPFunctionsQst,GetReportCaption(REPORT::"Job Calculate WIP"));
          Confirmed := CONFIRM(WIPQst);
          COMMIT;
          REPORT.RUNMODAL(REPORT::"Job Calculate WIP",not Confirmed,FALSE,Job);
        end;
    */


    //     LOCAL procedure GetReportCaption (ReportID@1000 :

    /*
    LOCAL procedure GetReportCaption (ReportID: Integer) : Text;
        var
    //       AllObjWithCaption@1001 :
          AllObjWithCaption: Record 2000000058;
        begin
          AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Report,ReportID);
          exit(AllObjWithCaption."Object Caption");
        end;
    */



    /*
    LOCAL procedure CalcEndingDate () EndingDate : Date;
        var
    //       JobLedgerEntry@1001 :
          JobLedgerEntry: Record 169;
        begin
          if "Ending Date" = 0D then
            EndingDate := WORKDATE
          else
            EndingDate := "Ending Date";

          JobLedgerEntry.SETRANGE("Job No.","No.");
          JobLedgerEntry.SETCURRENTKEY("Job No.","Posting Date");
          if JobLedgerEntry.FINDLAST then
            if JobLedgerEntry."Posting Date" > EndingDate then
              EndingDate := JobLedgerEntry."Posting Date";

          if "Ending Date" >= EndingDate then
            EndingDate := "Ending Date";
        end;
    */



    //     LOCAL procedure OnAfterUpdateBillToCust (var Rec@1000 :
    LOCAL procedure OnAfterUpdateBillToCust(var Rec: Record 167)
    begin
        //JAV 25/02/20: - Se pasan como par�metros Rec y xRec al evento OnAfterUpdateBillToCust
    end;


    //     LOCAL procedure OnAfterChangeJobCompletionStatus (var Job@1000 : Record 167;var xJob@1001 :

    /*
    LOCAL procedure OnAfterChangeJobCompletionStatus (var Job: Record 167;var xJob: Record 167)
        begin
        end;
    */


    LOCAL procedure "------------------------------------------------------------------ QB"()
    begin
    end;

    //     LOCAL procedure UpdateBillToCustStudy (ContactNo@1000 :
    LOCAL procedure UpdateBillToCustStudy(ContactNo: Code[20])
    var
        //       ContBusinessRelation@1005 :
        ContBusinessRelation: Record 5054;
        //       Cust@1004 :
        Cust: Record 18;
        //       Cont@1003 :
        Cont: Record 5050;
    begin
        //QX7105 >>
        if Cont.GET(ContactNo) then begin
            "Bill-to Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then begin
                "Bill-to Contact" := Cont.Name;
                "Bill-to Name" := Cont.Name;
                "Bill-to Name 2" := Cont."Name 2";
                "Bill-to Address" := Cont.Address;
                "Bill-to Address 2" := Cont."Address 2";
                "Bill-to City" := Cont.City;
                "Bill-to Post Code" := Cont."Post Code";
                "Bill-to Country/Region Code" := Cont."Country/Region Code";
                "Bill-to County" := Cust.County;
            end else begin
                "Bill-to Contact" := '';
                "Bill-to Name" := '';
                "Bill-to Name 2" := '';
                "Bill-to Address" := '';
                "Bill-to Address 2" := '';
                "Bill-to City" := '';
                "Bill-to Post Code" := '';
                "Bill-to Country/Region Code" := '';
                "Bill-to County" := '';
            end;
        end else begin
            "Bill-to Contact" := '';
        end;
        //QX7105 <<
    end;

    //     procedure JobStatus (jobCode@7207771 :


    procedure JobStatus(jobCode: Code[20])
    var
        //       JobL@7207772 :
        JobL: Record 167;
    begin
        if JobL.GET(jobCode) then begin
            JobL.TESTFIELD("Budget Status", JobL."Budget Status"::Open);
        end;
    end;



    //     procedure FilterResponsability (var Job@7001100 :


    procedure FilterResponsability(var Job: Record 167)
    begin
        FunctionQB.SetUserJobsFilter(Job);
    end;



    //     procedure ControlJob (Job@7001100 :


    procedure ControlJob(Job: Record 167)
    begin
        QBTableSubscriber.TJob_ControlRespCenter(Job);
    end;





    procedure ProductionTheoricalProcess(): Decimal;
    begin
        exit(QBTableSubscriber.TJob_ProductionTheoricalProcess(Rec));
    end;





    procedure ProductionBudgetWithoutProcess(): Decimal;
    begin
        exit(QBTableSubscriber.TJob_ProductionBudgetWithoutProcess(Rec));
    end;



    //     procedure AssignedCertification (pBudget@1100286002 :


    procedure AssignedCertification(pBudget: Code[20])
    var
        //       CertificationAssigned@1100286000 :
        CertificationAssigned: Page 7207591;
        //       DataPieceworkForProduction@1100286001 :
        DataPieceworkForProduction: Record 7207386;
    begin
        //JAV 31/10/20: - QB 1.07.03 Se traslada la funci�n para mostrar las agrupaciones a la tabla

        if (pBudget = '') then                       //Si no pasamos un presupuesto, usaremos el actual
            pBudget := "Current Piecework Budget";

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.FILTERGROUP(2);
        DataPieceworkForProduction.SETRANGE("Job No.", "No.");
        DataPieceworkForProduction.SETRANGE("Budget Filter", pBudget);
        DataPieceworkForProduction.FILTERGROUP(0);

        CLEAR(CertificationAssigned);
        CertificationAssigned.SETTABLEVIEW(DataPieceworkForProduction);
        CertificationAssigned.ReceivesJob("No.");
        if DataPieceworkForProduction.FINDFIRST then
            CertificationAssigned.SETRECORD(DataPieceworkForProduction);

        CertificationAssigned.RUNMODAL;
    end;



    LOCAL procedure "---------------------------------------------- Calculos en Divisa Local"()
    begin
    end;



    procedure CalculateMarginProvided_DL(): Decimal;
    var
        //       MarginBudget@7001101 :
        MarginBudget: Decimal;
    begin
        CALCFIELDS("Budget Sales Amount", "Budget Cost Amount");
        exit("Budget Sales Amount" - "Budget Cost Amount");
    end;





    procedure CalculateMarginProvidedPercentage_DL(): Decimal;
    var
        //       MarginBudgetPercentage@7001100 :
        MarginBudgetPercentage: Decimal;
    begin
        CALCFIELDS("Budget Sales Amount", "Budget Cost Amount");
        if Rec."Budget Sales Amount" = 0 then
            exit(0)
        else
            exit(((Rec."Budget Sales Amount" - Rec."Budget Cost Amount") / Rec."Budget Sales Amount") * 100);
    end;





    procedure CalculateMarginInvoiced_DL(): Decimal;
    var
        //       MarginInvoiced@7001100 :
        MarginInvoiced: Decimal;
    begin
        CALCFIELDS("Invoiced Price (LCY)", "Usage (Cost) (LCY)");
        exit("Invoiced Price (LCY)" - "Usage (Cost) (LCY)");
    end;





    procedure CalculateMarginInvoicedPercentage_DL(): Decimal;
    var
        //       MarginInvoicedPercentage@7001100 :
        MarginInvoicedPercentage: Decimal;
    begin
        CALCFIELDS("Invoiced Price (LCY)", "Usage (Cost) (LCY)");
        if "Invoiced Price (LCY)" = 0 then
            exit(0)
        else
            exit((("Invoiced Price (LCY)" - "Usage (Cost) (LCY)") / "Invoiced Price (LCY)") * 100);
    end;





    procedure CalcContractAmount_DL(): Decimal;
    var
        //       JobCurrencyExchangeFunction@1100286000 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       Amount@1100286001 :
        Amount: Decimal;
        //       Factor@1100286002 :
        Factor: Decimal;
        //       GeneralLedgerSetup@1100286003 :
        GeneralLedgerSetup: Record 98;
    begin
        //GEN005-03
        CALCFIELDS("Contract Amount");
        exit("Contract Amount");
    end;





    procedure CalcPercentageCostIndirect_DL(): Decimal;
    var
        //       VDelPercentageCostIndirect@7001100 :
        VDelPercentageCostIndirect: Decimal;
    begin
        // Funci�n que devuelve el % de indirectos sobre el total de costes
        CALCFIELDS("Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
        if ("Direct Cost Amount PieceWork" + "Indirect Cost Amount Piecework" = 0) then
            exit(0)
        else
            exit(ROUND("Indirect Cost Amount Piecework" * 100 / ("Direct Cost Amount PieceWork" + "Indirect Cost Amount Piecework"), 0.01));
    end;





    procedure CalcMarginPricePercentage_DL(): Decimal;
    var
        //       VCalMarginPricePercentage@7001100 :
        VCalMarginPricePercentage: Decimal;
    begin
        Job.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount"); //JMMA
        if ("Budget Sales Amount" = 0) then
            exit(0)
        else
            exit(ROUND(("Budget Sales Amount" - "Budget Cost Amount") * 100 / ("Budget Sales Amount"), 0.01));
    end;





    procedure CalcMarginDirect_DL(): Decimal;
    var
        //       VDelMarginDirect@7001100 :
        VDelMarginDirect: Decimal;
    begin
        // Funci�n que devuelve el margen directo presupuestad de un producto por unidad de obra
        CALCFIELDS("Production Budget Amount", "Direct Cost Amount PieceWork");
        if ("Direct Cost Amount PieceWork" = 0) then
            exit(0)
        else
            exit(ROUND((("Production Budget Amount") - ("Direct Cost Amount PieceWork")) * 100 / ("Direct Cost Amount PieceWork"), 0.01));
    end;



    LOCAL procedure "---------------------------------------------- Calculos en Divisa Proyecto"()
    begin
    end;



    procedure CalcBudgetSalesAmount_PC(): Decimal;
    var
        //       JobCurrencyExchangeFunction@1100286000 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       Amount@1100286001 :
        Amount: Decimal;
        //       Factor@1100286002 :
        Factor: Decimal;
        //       GeneralLedgerSetup@1100286003 :
        GeneralLedgerSetup: Record 98;
    begin
        //GEN005-03
        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("LCY Code");
        CALCFIELDS("Budget Sales Amount");
        JobCurrencyExchangeFunction.CalculateCurrencyValue("No.", "Budget Sales Amount", GeneralLedgerSetup."LCY Code", "Currency Code", "Currency Value Date", 1, Amount, Factor);
        exit(Amount);
    end;





    procedure CalcBudgetCostAmount_PC(): Decimal;
    var
        //       JobCurrencyExchangeFunction@1100286003 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       Amount@1100286002 :
        Amount: Decimal;
        //       Factor@1100286001 :
        Factor: Decimal;
        //       GeneralLedgerSetup@1100286000 :
        GeneralLedgerSetup: Record 98;
    begin
        //GEN005-03
        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("LCY Code");
        CALCFIELDS("Budget Cost Amount");
        JobCurrencyExchangeFunction.CalculateCurrencyValue("No.", "Budget Cost Amount", GeneralLedgerSetup."LCY Code", "Currency Code", "Currency Value Date", 0, Amount, Factor);
        exit(Amount);
    end;




    /*
    procedure CalculateMarginProvided_PC () : Decimal;
        var
    //       MarginBudget@7001101 :
          MarginBudget: Decimal;
        begin
          //GEN005-03
          exit(CalcBudgetSalesAmount_PC - CalcBudgetCostAmount_PC);
        end;
    */



    /*
    procedure CalculateMarginInvoiced_PC () : Decimal;
        var
    //       MarginInvoiced@7001100 :
          MarginInvoiced: Decimal;
        begin
          //GEN005-03
          CALCFIELDS("Invoiced Price (JC)", "Usage (Cost) (JC)");
          exit("Invoiced (JC)" - "Usage (Cost) (JC)");
        end;
    */



    /*
    procedure CalcContractAmount_PC () : Decimal;
        var
    //       JobCurrencyExchangeFunction@1100286000 :
          JobCurrencyExchangeFunction: Codeunit 7207332;
    //       Amount@1100286001 :
          Amount: Decimal;
    //       Factor@1100286002 :
          Factor: Decimal;
    //       GeneralLedgerSetup@1100286003 :
          GeneralLedgerSetup: Record 98;
        begin
          //GEN005-03
          GeneralLedgerSetup.GET;
          GeneralLedgerSetup.TESTFIELD("LCY Code");
          CALCFIELDS("Contract Amount");

          //Q7635 -
          if "Contract Amount" <> 0 then
            JobCurrencyExchangeFunction.CalculateCurrencyValue("No.","Contract Amount",GeneralLedgerSetup."LCY Code","Currency Code","Currency Value Date",1,Amount,Factor);
          exit(Amount);
        end;
    */




    procedure CalcPercentageCostIndirect_PC(): Decimal;
    var
        //       VDelPercentageCostIndirect@7001100 :
        VDelPercentageCostIndirect: Decimal;
    begin
        // Funci�n que devuelve el % de indirectos sobre el total de costes
        CALCFIELDS("Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
        if ("Direct Cost Amount PW (JC)" + "Indirect Cost Amount PW (JC)" = 0) then
            exit(0)
        else
            exit(ROUND("Indirect Cost Amount PW (JC)" * 100 / ("Direct Cost Amount PW (JC)" + "Indirect Cost Amount PW (JC)"), 0.01));
    end;





    procedure CalcMarginPricePercentage_PC(): Decimal;
    var
        //       GeneralLedgerSetup@100000000 :
        GeneralLedgerSetup: Record 98;
        //       JobCurrencyExchangeFunction@100000003 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       Amount@100000002 :
        Amount: Decimal;
        //       Factor@100000001 :
        Factor: Decimal;
        //       BCA@100000004 :
        BCA: Decimal;
        //       BSA@100000005 :
        BSA: Decimal;
    begin
        //GEN005-03
        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("LCY Code");
        Job.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount");

        //Q7635 -
        JobCurrencyExchangeFunction.CalculateCurrencyValue("No.", "Budget Sales Amount", GeneralLedgerSetup."LCY Code", "Currency Code", "Currency Value Date", 1, Amount, Factor);
        BSA := Amount;
        JobCurrencyExchangeFunction.CalculateCurrencyValue("No.", "Budget Cost Amount", GeneralLedgerSetup."LCY Code", "Currency Code", "Currency Value Date", 1, Amount, Factor);
        BCA := Amount;

        if (BSA = 0) then
            exit(0)
        else
            exit(ROUND((BSA - BCA) * 100 / BSA, 0.01));
    end;




    /*
    procedure CalcMarginDirect_PC () : Decimal;
        var
    //       VDelMarginDirect@7001100 :
          VDelMarginDirect: Decimal;
        begin
          // Funci�n que devuelve el margen directo presupuestad de un producto por unidad de obra
          CALCFIELDS("Production Budget Amount (JC)", "Direct Cost Amount PW (JC)");
          if ("Direct Cost Amount PW (JC)" = 0) then
            exit(0)
          else
            exit(ROUND(("Production Budget Amount (JC)" - "Direct Cost Amount PW (JC)") * 100 / "Direct Cost Amount PW (JC)" ,0.01));
        end;
    */


    LOCAL procedure "---------------------------------------------- Calculos generales"()
    begin
    end;


    //     LOCAL procedure QB_OnAfterUpdateBillToCust (var Rec@1000 : Record 167;xRec@1100286000 :


    LOCAL procedure QB_OnAfterUpdateBillToCust(var Rec: Record 167; xRec: Record 167)
    begin
        //JAV 25/02/20: - Se pasan como par�metros Rec y xRec al evento OnAfterUpdateBillToCust
    end;





    procedure IsMatrixJob(): Boolean;
    begin
        //Q13639 +
        exit(("Job Matrix - Work" = "Job Matrix - Work"::"Matrix Job") and ("No. of Matrix Job it Belongs" <> 0));
        //Q13639 -
    end;



    LOCAL procedure "-------------------------------------- C�lculos UTE"()
    begin
    end;



    procedure ProdAmountUTE(): Decimal;
    var
        //       rJob@1000000002 :
        rJob: Record 167;
        //       ProductionAmount@1000000003 :
        ProductionAmount: Decimal;
    begin
        //JMMA 0311220 PRODUTE
        ProductionAmount := ProdAmountUTE_Base(0) * (Rec."% JV Share" / 100);
        exit(ProductionAmount);
    end;





    procedure ActualProdAmountUTE(): Decimal;
    var
        //       rJob@1000000001 :
        rJob: Record 167;
        //       ActualProductionAmount@1000000000 :
        ActualProductionAmount: Decimal;
    begin
        //JMMA 0311220 PRODUTE
        ActualProductionAmount := ProdAmountUTE_Base(1) * (Rec."% JV Share" / 100);
        exit(ActualProductionAmount);
    end;



    //     procedure ProdAmountUTE_Base (pType@1100286000 :


    procedure ProdAmountUTE_Base(pType: Option "Initial","Actual"): Decimal;
    var
        //       rJob@1100286002 :
        rJob: Record 167;
        //       Amount@1100286001 :
        Amount: Decimal;
    begin
        Amount := 0;

        if (Rec."Job UTE" <> '') then begin
            rJob.RESET;
            rJob.CHANGECOMPANY("Company UTE");
            if rJob.GET("Job UTE") then begin
                rJob.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
                CASE pType OF
                    pType::Initial:
                        begin
                            rJob.CALCFIELDS("Production Budget Amount (JC)");
                            Amount := rJob."Production Budget Amount (JC)";
                        end;
                    pType::Actual:
                        begin
                            if GETFILTER("Posting Date Filter") <> '' then
                                rJob.SETFILTER("Posting Date Filter", GETFILTER("Posting Date Filter"));
                            rJob.CALCFIELDS("Actual Production Amount (JC)");
                            Amount := rJob."Actual Production Amount (JC)";
                        end;
                end;
            end;
        end;

        exit(Amount);
    end;

    /*begin
    //{
//      PGM 02/02/18: - QBV1104 A�adida una condici�n para que se ejecute la funci�n o se llame al evento segun el valor del campo Quobuilding de la Informaci�n de empresa.
//      PGM 26/12/18: - QBA A�adidos campos nuevos para los estudios (ofertas)
//      JAV 18/03/19: - Para QB el estado debe ser Pendiente
//                    - Se cambia el TableRelation del campo "Original Quote Code" de "Job WHERE (Status=CONST(Planning))" a "Job WHERE (Card Type=CONST(Estudio))"
//                    - Se cambia el CalcFormula del campo "No. versiones" de "Count(Job WHERE (Original Quote Code=FIELD(No.),Status=FILTER(Planning)))" a "Count(Job WHERE (Original Quote Code=FIELD(No.),Card Type=FILTER(Estudio)))"
//                    - Se a�aden los campos 7174413-14 para guardar preciario cargado
//      PEL 19/03/19: - OBR Creados campos de Obralia
//      JAV 09/05/19: - Se elimina el campo duplicado 7207393 "Invoiced Type" y se cambia el captionML del campo 7207316 "Invoicing Type"
//      PGM 26/04/19: - QCPM_GAP02 Creado los campos "Present. Quote Required Date", "Present. Quote Real Date" y "Improvements"
//      PEL 29/04/19: - QCPM_GAP05 Creado campo "internal Status" y rellenarlo al insertar.
//      RSH 29/04/19: - QX7105 A�adir Bill-to contact No. y Bill-to contact para permitir usar contactos de un cliente gen�rico.
//      RSH 02/05/19: - QX7105 A�adir funci�n ChangeBillToGeneric.
//      JAV 02/06/19: - Se elimina el campo Establecer las fechas seg�n el estado
//      JAV 02/06/19: - Se renumeran los campos de QBA5412 para que coincidan en Bussines Central, se a�ade la funcionalidad de esos campos
//      JAV 04/06/19: - A�adido campo 7207448 "Allow Over Measure" que indica si se permite en todas las U.O., al cambiarlo pregunta si desea hacerlo en todas
//      JAV 12/06/19: - Cambio para las 5 fechas auxiliares m�s la de env�o al cliente
//                    - Se cambia el nombre y caption del campo "Actual Production Measure", ya que no es medici�n sino importe
//      JAV 20/06/19: - Se a�aden los campos del N�mero de serie de registro de facturas y abonos por proyecto
//      JAV 30/06/19: - Se a�aden los campos 50001 y 50002 para el control de contrato del proyecto
//      JDC 23/07/19: - GAP029 KALAM Added field 50003 "Multi-Client Job"
//      JAV 26/07/19: - Se modifica el validate del campo 7207342 "Job P.C." para que monte provincia y poblaci�n
//      QCPM_GAP05
//      JAV 02/08/19: - Se pone el importe facturado en positivo
//      JAV 06/08/19: - Se a�ade el campo 7207288 "Blocked By" que indica quien ha bloqueado el proyecto y se cambia el caption del campo "Budget Status"
//      JDC 12/08/19: - GAP010 KALAM Added fields 50044 "Category Code", 50045 "Category Description", 50046 "Situation Code" and 50047 "Situation Description"
//      JAV 23/08/19: - Si el proyecto viene de un estudio, lo quitamos como el que se ha generado en el mismo
//                    - Si cambia el tipo de proyecto, se revisa la dimensi�n por defecto
//      JAV 26/08/19: - Para la gesti�n de garant�as:
//                      - Se a�aden los campos "Guarantee Provisional", "Guarantee Definitive", "Guarantee Provisional Dep." y "Guarantee Definitive Dep."
//                      - Se modifica el caption de los campos "Guarantee Provisional %" y camption y nombre de "Guarantee Definitive (%)"
//                      - Se modifica el validate de "Bidding Bases Budget", "Guarantee Provisional %" y "Guarantee Definitive (%)"
//      JAV 29/08/19: - Si el proyecto tiene un responsable comercial asociado, no cambiarlo si cambio de cliente gen�rico
//      PGM 05/09/19: - Si es un estudio debe estar en estado abierto. JAV 07/09/19: - Si es de QB, debe estar en estado Abierto siempre
//      JAV 07/09/19: - Al cambiar la versi�n presentada o la aceptada se valida el campo de % garant�a definitiva para que se recalcule
//                    - Si se cambia el c�digo del proyecto, hay que cambiar las dimensiones por defecto
//      PGM 19/09/19: - GAP012 KALAM A�adido el campo 50048 "Job Phases"
//      PGM 20/09/19: - GAP011 KALAM A�adido el campo 50050 "Customer Type"
//      JAV 22/09/19: - Se a�aden los campos 50018 y 50019 con la hora de presentaci�n de las ofertas
//      JAV 24/09/19: - Se cambian los decimales del coeficiente de baja a 2:6
//      JAV 02/10/19: - Se a�aden los campos para conocer que preciario se ha cargado para directos y para indirectos 50004 "Import Cost Database Direct",
//                      50005 "Import Cost Database Dir. Date", 50006 "Import Cost Database Indirect", 50007 "Import Cost Database Ind. Date"
//                    - Esto hace obsoletos los campos 7174413 "Import Cost Database Code" y 7174414 "Import Date" que se eliminan
//      PGM 08/10/19: - GAP015 KALAM A�adidos los campos 50051 "Project Management" y 50052 "Project Management Descr."
//      PGM 14/10/19: - Q8029 Comentado el codigo del GAP029.
//      PGM 04/11/19: - Q8192 Se modifica el CalcFormula del campo 7207416 "Low Supply":
//                            de "Lookup(Job."Low Coefficient" WHERE (No.=FIELD(Presented Version)))"
//                             a "Lookup(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.),Competitor Code=CONST('')))
//                    - Q8192 Se modifica el CalcFormula del campo 7207417 "Low Average Competition"
//                            de "Average(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.)))"
//                             a "Average(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.),Competitor Code=FILTER(<>'')))"
//                    - JAV   Se modifica el CalcFormula del campo 7207419 "Low Competition Higher"
//                            de "Max(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.)))"
//                             a "Max(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.),Competitor Code=FILTER(<>'')))"
//                    - Q8192 Se modifica el CalcFormula del campo 7207420 "Low Competition Less"
//                            de "Min(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.)))"
//                             a "Min(Competition/Quote."% of Low" WHERE (Quote Code=FIELD(No.),Competitor Code=FILTER(<>'')))"
//      JAV 20/02/20: - Se a�aden las fechas y plazo de garant�a
//      JAV 25/02/20: - Se pasan como par�metros Rec y xRec al evento OnAfterUpdateBillToCust
//      JAV 26/02/20: - Se llama al evento OnAfterUpdateBillToCust si se cambia el check de multi-cliente
//      JAV 10/03/20: - Se elimina la funci�n CreateStartingBudget que no se utiliza
//      MMS 15/07/21: - Q13647 Modificado validate del campo �Ending Date� en evento de campo en la codeunit 7207306
//      MMS 06/07/21: - Q13639 Visualizar importes agrupados, se crea funci�n IsMatrixJob
//      JAV 01/09/21: - QPR 1.00.00 Se a�aden nuevos tipos de ficha para presupuestos
//      DGG 08/10/21: - QB 1.09.21 Se a�aden nuevos campos: 7207550Allow Ceded, 7207551Contract No.
//      LCG 27/10/21: - QRE15454 Extender tabla 7238195 - Proyectos Inmobilarios.
//      JAV 29/10/21: - QB 1.09.29 Se eliminan funciones para calcular cantidades en albaranes y almac�n que ya no son necesarias
//      JAV 30/10/21: - QB 1.09.29 Se eliminan funciones que no se usan o quie solo llaman a un evento, que llaman a una funci�n que retorna el valor, se pasan directamente a funciones
//                                 en "QB - Table - Publisher" y se llaman directamente desde donde se utilizan realmente, as� evitamos tantas llamada in�tiles
//      JAV 03/12/21: - QB 1.10.06 Se cambian los campos "Execution Official Term" y "Warranty Term" a TEXT en lugar de Duration, que es como estaban en anteriores versiones
//      JAV 23/02/22: - QB 1.10.22 Se cambian longitudes para evitar error de desbordamiento,
//                                 se cambian dos campos datetime a texto que son mas operativos
//                                 se eliminan campos de aprobaci�n y se a�ade uno nuevo para el circuito
//      JAV 08/04/22: - QB 1.10.33 Se a�ade el campo 7207308 "QB Activable" para los gastos activables
//      JAV 17/05/22: - QB 1.10.42 Se compatibilizan campos entre QuoBuilding y Real Estate
//      JAV 14/09/22: - QB 1.11.02 Se a�aden captions configurales a campos de responsables y a tablas auxiliares informativas
//      JAV 04/10/22: - QB 1.12.00 Se a�ade el campo 7207308 "QB Activable" y 7207309 "QB Activable Date" para los gastos activables. Se modifica el validate del campo Internal Status
//      AML 13/11/23: - BS::20430 Autorizacion presupuestos.
//      BS::20016 CSM 30/11/23 � VAR013 control documentaci�n obra.  New Field.
//      QBAML AML 20/05/24 Creados campos 7238401 Percentage rate in Breakdown 7238402 Percentage price list
//    }
    end.
  */
}




