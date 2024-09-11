table 7207278 "QuoBuilding Setup"
{


    CaptionML = ENU = 'QuoBuilding Setup', ESP = 'Configuraci�n QuoBuilding';
    LookupPageID = "QuoBuilding Setup";
    DrillDownPageID = "QuoBuilding Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key', ESP = 'Clave primaria';


        }
        field(2; "Serie for Cost Database"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Cost Database No.', ESP = 'N� serie preciario';


        }
        field(3; "Serie for Reestimate"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Reestimate No.', ESP = 'N� serie reestimaci�n';


        }
        field(4; "Serie for Reestimate Post"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Reestimate Rec. No.', ESP = 'N� serie reestimaci�n reg.';


        }
        field(6; "Expense Notes Book"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            CaptionML = ENU = 'Expense Notes Book', ESP = 'Libro registro notas gasto';


        }
        field(7; "Expense Notes Batch Book"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Expense Notes Book"));
            CaptionML = ENU = 'Batch Expense Notes Book', ESP = 'Secci�n registro notas gasto';


        }
        field(8; "Budget for Quotes"; Code[10])
        {
            TableRelation = "G/L Budget Name";
            CaptionML = ENU = 'Budget Offer Code', ESP = 'Presupuesto para Estudios';


        }
        field(9; "Dimension for Quotes"; Code[20])
        {
            TableRelation = "Dimension";
            CaptionML = ENU = 'Dimension Offer Code', ESP = 'C�d. dimensi�n Estudio';


        }
        field(10; "Analysis View for Quotes"; Code[20])
        {
            TableRelation = "Analysis View";
            CaptionML = ENU = 'Analysis Offers Code', ESP = 'C�d. Vista An�lisis para Estudios';


        }
        field(11; "Serie for Measurement"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Measurement Prod. No.', ESP = 'N� serie Relaci�n Valorada';


        }
        field(12; "Serie for Measurement Post"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Hist. Measur. Prod. No.', ESP = 'N� serie Relaci�n Valorada Reg.';


        }
        field(13; "Periodic Expense Book"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            CaptionML = ENU = 'Posting Expense Periodif. Book', ESP = 'Libro registro periodif. gasto';


        }
        field(14; "Periodic Expense Batch Book"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Periodic Expense Book"));
            CaptionML = ENU = 'Batch Posting Period. Expense', ESP = 'Secci�n registro period. gasto';


        }
        field(15; "Serie for Indirect Part"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Part Cost Indirect No.', ESP = 'N� serie parte coste indirecto';


        }
        field(16; "Serie for Indirect Part Post"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Hist. Part Cost Ind No.', ESP = 'N� serie parte coste indirecto Reg.';


        }
        field(17; "Skip Required Project"; Boolean)
        {
            CaptionML = ENU = 'Skip Required Project', ESP = 'Saltar proyecto obligatorio';
            Description = 'Salta proyecto desviaci�n';


        }
        field(18; "MSP Export Template"; Text[250])
        {
            CaptionML = ENU = 'MSP Export Template', ESP = 'Plantilla de exportaci�n MSP';


        }
        field(19; "Serie for Record"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Record', ESP = 'N� serie expedientes';


        }
        field(20; "Delivery Note Book"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            CaptionML = ENU = 'Post. Delivery Note Pro Book', ESP = 'Libro registro alb. salida pro';


        }
        field(21; "Delivery Note Batch Book"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Delivery Note Book"));
            CaptionML = ENU = 'Batch Posting Delivery Note P', ESP = 'Secci�n registro alb. salida p';


        }
        field(22; "Department Equal To Project"; Boolean)
        {
            CaptionML = ENU = 'Department Equal To Project', ESP = 'Departamento igual a proyecto';


        }
        field(23; "% Generic Margin Sale Piecewor"; Decimal)
        {
            CaptionML = ENU = '% Generic Margin Sale Piecewor', ESP = '% margen gen�rico venta UO';
            MinValue = 0;
            MaxValue = 100;


        }
        field(24; "Create Location Equal To Proj."; Boolean)
        {
            CaptionML = ENU = 'Create Location Equal To Proj.', ESP = 'Crear almac�n igual a proyecto';
            Description = 'ALMACEN';


        }
        field(25; "Mant. Contract Prices In Fact."; Boolean)
        {
            CaptionML = ENU = 'Mant. Contract Prices In Fact.', ESP = 'Mant. precios contrato en fact';
            Description = 'GENERAL Si no se puede cambiar en las facturas los precios cuando viene de un albar�n';


        }
        field(26; "Default Job Posting Group"; Code[20])
        {
            TableRelation = "Job Posting Group"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Default Job Posting Group', ESP = 'Grupo registro proyecto pred.';


        }
        field(27; "When Calculating Analitical"; Option)
        {
            OptionMembers = "AnView","Analitical";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Al calcular presupuesto Anal�tico';
            OptionCaptionML = ENU = 'Budget and An. View,Only Budget', ESP = 'Presupuesto Anal�tico y Vista de An�lisis,Solo el Presupuesto Anal�tico';

            Description = 'GENERAL. JAV 13/04/20: [TT] Cuando calculamos el presupuesto si deseamos solo el presupuesto o tambi�n se calcula el anal�tico';


        }
        field(28; "Initial Record Code"; Code[20])
        {
            CaptionML = ENU = 'Initial Record Code', ESP = 'C�digo exp. inicial';


        }
        field(29; "Initial Budget Code"; Code[20])
        {
            CaptionML = ENU = 'Initial Budget Code', ESP = 'C�digo ppto. inicial';


        }
        field(30; "Serie Integration Doc JV No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Integration Doc JV No.', ESP = 'N� serie doc integraci�n UTE';


        }
        field(31; "Posting Book Integration JV"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            CaptionML = ENU = 'Posting Book Integration JV', ESP = 'Libro registro integraci�n UTE';


        }
        field(32; "Batch Rec. integration JV"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Posting Book Integration JV"));
            CaptionML = ENU = 'Batch Rec. Integration JV', ESP = 'Secci�n reg. integraci�n UTE';


        }
        field(33; "Bal. Account Regul. JV"; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENU = 'Bal. Account Regul. JV', ESP = 'Cta contrap. regul. UTE';


        }
        field(34; "Close Account JV"; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENU = 'Close Account JV', ESP = 'Cta. cierre UTE';


        }
        field(35; "Close Bal. Account JV"; Code[20])
        {
            TableRelation = "G/L Account";
            CaptionML = ENU = 'Close Bal. Account JV', ESP = 'Cta. contrap. cierre UTE';


        }
        field(36; "Close Batch Rec. JV"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Posting Book Integration JV"));
            CaptionML = ENU = 'Close Batch Rec. JV', ESP = 'Secci�n reg. cierre UTE';


        }
        field(37; "Analytic Cost Concept"; Code[20])
        {


            CaptionML = ENU = 'Analytic Cost Concept', ESP = 'Concepto anal�tico coste';
            Description = 'GENERAL.';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Analytic Cost Concept");
            END;

            trigger OnLookup();
            BEGIN
                FunctionQB.LookUpCA("Analytic Cost Concept", FALSE);
            END;


        }
        field(38; "Use Responsibility Center"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Utilizar centro de responsabilidad';
            Description = 'GENERAL. Q3254';


        }
        field(39; "When Calculating Budget"; Option)
        {
            OptionMembers = "Budget","Analitical";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Al calcular presupuesto';
            OptionCaptionML = ENU = 'Only Budget,Budget and Analytical,Budget and Analytical and An.View', ESP = 'Solo el Presupuesto,Presupuesto y Anal�tico,Presupuesto m�s Anal�tico m�s Vista de An�lisis';

            Description = 'GENERAL. JAV 13/04/20: [TT] Cuando calculamos el presupuesto si deseamos solo el presupuesto o tambi�n se calcula el anal�tico';


        }
        field(40; "Ver en Costes Directos"; Option)
        {
            OptionMembers = "dt","dm","d","mt";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ver en Costes Directos';
            OptionCaptionML = ESP = 'Descompuestos+Textos,Descompuestos+Mediciones,Descompuestos,Mediciones+Textos';

            Description = 'GENERAL. JAV 03/04/19: [TT] Que pantallas se ver�n por defecto en la page de costes directos';


        }
        field(41; "Quote Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo ppto. Estudio';
            Description = 'GENERAL. JAV 09/10/19: [TT] Si al crear el proyecto de un estudio se a�ade el presupuesto de Estudio adem�s del Master';


        }
        field(42; "Initial Budget"; Option)
        {
            OptionMembers = "Job","Quote";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Presupuesto inicial';
            OptionCaptionML = ENU = 'Job,Quote', ESP = 'Proyecto,Estudio';

            Description = 'GENERAL. JAV 12/10/19: [TT] Indica que presupuesto ser� el inicial el de Estudio o el Master';


        }
        field(43; "Location Proyect"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto estructura almac�n';
            Description = 'ALMACEN JAV 10/06/20: [TT] Indica el proyecto de estructuira de contrapartida donde se llevan las entradas y salidas de almac�n';


        }
        field(44; "Days Warning Withholding"; DateFormula)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'D�as para aviso retenciones';
            Description = 'GENERAL. JAV 06/05/20: [TT] Cuanrtos d�as de aviso se desean antes del vencimiento de las retenciones de garant�a';


        }
        field(47; "Prepayment Posting Group 1"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Grupo Producto para Anticipos con Efecto';
            Description = 'ANTICIPOS JAV 27/06/20: [TT] Que "Grupo contable de producto" se usar� para obtener la cuenta de anticipo para clientes o proveedores cuando es con efecto';


        }
        field(48; "Use Customer Prepayment"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar Anticipos de clientes';
            Description = 'ANTICIPOS 1.06 JAV 27/06/20: [TT] Si se van a usar los anticipos de clientes en los proyectos';


        }
        field(49; "Use Vendor Prepayment"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar Anticipos de proveedores';
            Description = 'ANTICIPOS 1.06 JAV 27/06/20: [TT] Si se van a usar los anticipos de proveedores en los proyectos';


        }
        field(53; "Use Payment Phases"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar fases de pago en compras';
            Description = 'FASES PAGO. QB 1.06 JAV 06/07/20: [TT] Si se desea disponer de Fases de Pago en los documentos de compra (comparativos, pedidos, albaranes, facturas)';


        }
        field(60; "Use Currency in Jobs"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency', ESP = 'Usar Divisas en proyectos';
            Description = 'DIVISAS. JAV 25/07/19: - Si se van a usar divisas en los proyectos';


        }
        field(61; "Adjust Exchange Rate Piecework"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.O. Para diferencias cambio';
            Description = 'DIVISAS. QB 1.06.20 - JAV 12/10/20: - A que U.O. se imputan las diferencias de cambio de divisas';


        }
        field(62; "Adjust Exchange Rate A.C."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C.A. Para diferencias cambio';
            Description = 'DIVISAS. QB 1.06.20 - JAV 14/10/20: - A que Concepto Anal�tico se imputan las diferencias de cambio de divisas';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Adjust Exchange Rate A.C.");
            END;

            trigger OnLookup();
            BEGIN
                FunctionQB.LookUpCA("Adjust Exchange Rate A.C.", FALSE);
            END;


        }
        field(63; "Serie For Prepayment Bills"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Serie para anticipos con Efecto';
            Description = 'ANTICIPOS QB 1.08.49 - JAV 17/06/21: - [TT] Indica la serie con la que se van a generar los documentos de tipo efecto para anticipos de Proyectos de clientes y proveedores';


        }
        field(64; "Prepayment Payment Method"; Code[20])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'F.Pago para Anticipos';
            Description = 'ANTICIPOS QB 1.09.02 - JAV 27/06/21: - [TT] Indica la forma de pago con la que se van a generar los anticipos de Proyectos de clientes y proveedores';


        }
        field(65; "Hours control"; Option)
        {
            OptionMembers = "No","Yes","IncludeExternal";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar control de horas';
            OptionCaptionML = ENU = 'No,Yes,Include external', ESP = 'No,Si,Incluir externos';

            Description = 'GENERAL. QB 1.06.10 - JAV 21/08/20: - Si se emplea el control de horas de las partidas';


        }
        field(66; "Use Aditional Code"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar c�digo adicional';
            Description = 'GENERAL. QB 1.06.10 - JAV 21/08/20: - Si se emplea el c�digo adicional para las undiades de obra';


        }
        field(67; "Use External Wookshet"; Option)
        {
            OptionMembers = "No","Yes","Job","GL";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar partes de externos';
            OptionCaptionML = ENU = 'No,Yes,In Job,Job + G/L', ESP = 'No,Si,Iputando al proyecto,Proyecto+Asiento';

            Description = 'GENERAL. QB 1.06.10 - JAV 22/08/20: - Como se usan los partes de externos';


        }
        field(68; "Use Old Initial Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Sistema antiguo de datos iniciales';
            Description = 'GENERAL. QB 1.06.11 - JAV 26/08/20: - [TT] Si no est� marcado se usa el dato del presupuesto inicial (opci�n preferente), si est� marcado se usan campos adicionales para ello (menos recomendado)';


        }
        field(69; "Use Shipment type in Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar tipo Albar�n en Proveedores';
            Description = 'GENERAL. QB 1.06.20 - JAV 08/10/20: - [TT] Si se activa el movimiento de provisi�n/desprovisi�n del albar�n se efectua contra proveedor en lugar de contra cuenta';


        }
        field(70; "Jobs Book"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expense Notes Book', ESP = 'Libro registro Proyectos';
            Description = 'DIARIOS. JAV 24/08/19: - Que libro se usa para registrar proyectos';


        }
        field(71; "Jobs Batch Book"; Code[10])
        {
            TableRelation = "Gen. Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Jobs Book"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Batch Expense Notes Book', ESP = 'Secci�n registro proyectos';
            Description = 'DIARIOS. JAV 24/08/19: - Que secci�n se usa para registrar proyectos';


        }
        field(73; "Is Test Company"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Is Test Company', ESP = 'Empresa de pruebas';
            Description = 'GENERAL. QB 1.10.26 JAV 18/03/22 [TT: Si es una empresa de pruebas, desactivar� los env�os al SII]';

            trigger OnValidate();
            BEGIN
                SetTestCompany;
            END;


        }
        field(74; "Use WS for Reports"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar WebServices para informes';
            Description = 'GENERAL. QB 1.08.34 - JAV 06/04/21 Si se usan los informes en WebService';


        }
        field(77; "Use Grouping"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Use Grouping for Sales Piecework', ESP = 'Usar agrupaciones en U.O Venta';
            Description = 'GENERAL. Q13152 [TT] Si se desea usar agrupaciones de costes en las facturas de las certificaciones';


        }
        field(78; "Prepayment Document Type"; Option)
        {
            OptionMembers = "Invoice","Bill","ForceInvoice","ForceBill";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Documento a Generar';
            OptionCaptionML = ENU = 'Invoice,Bill,Force Invoice,Force Bill', ESP = 'Factura,Efecto,Siempre Factura,Siempre Efecto';

            Description = 'ANTICIPOS QB 1.10.35 - JAV 11/04/22: - [TT] Indica el documento por defecto que se desea generar para registrar los anticipos, si tiene establecido SIEMPRE no podr� cambiarse, si no lo tiene establecido se podr� cambiar en cada anticipo.';


        }
        field(79; "Prepayment Payment Terms"; Code[20])
        {
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prepayment Payment Terms', ESP = 'T�rminos de pago para Anticipos';
            Description = 'ANTICIPOS QB 1.10.36 - JAV 20/04/22: - [TT] Indica que T�rminos de pago se usar�n por defecto para los anticipos';


        }
        field(80; "Guarantee Serial No."; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Serie Garant�as';
            Description = 'GARANTIAS. JAV 26/08/19: - Serie para crear avales y fianzas';


        }
        field(81; "Guarantee Analitical Concept"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Guarantor', ESP = 'Concepto Anal�tico para Garant�as';
            Description = 'GARANTIAS. JAV 07/09/19: - Unidad de Obra de indirectos en la que imputar los asientos de las garant�as';


        }
        field(82; "Guarantee Piecework Unit"; Code[20])
        {
            CaptionML = ESP = 'U.O. gastos de Garant�as';
            Description = 'GARANTIAS. JAV 07/09/19: - Que U.O. se usa para registrar los gastos de las garant�as';


        }
        field(83; "Guarantee Piecework Unit Prov."; Code[20])
        {
            CaptionML = ESP = 'U.O. provis�n gastos de Garant�as';
            Description = 'GARANTIAS. JAV 22/09/19: - Que U.O. se usa para las provisiones de costes de las garant�as';


        }
        field(84; "Fiter Same Job Type"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Filtrar proyectos del mismo tipo';
            Description = 'GENERAL      JAV 16/06/22: - QB 1.10.50 [TT] Si se activa este check, por defecto se filtran que al buscar un proyecto en  compras sean del mismo tipo del actual (QB/RE/CECO)';


        }
        field(85; "Use Confirming Lines"; Boolean)
        {
            CaptionML = ENU = 'Serie Cost Database No.', ESP = 'Usar L�neas de confirming';
            Description = 'QB 1.06.15 - JAV 23/09/20: - [TT] Si se van a usar los contratos de confirming globales';


        }
        field(86; "Use Factoring Lines"; Boolean)
        {
            CaptionML = ENU = 'Serie Cost Database No.', ESP = 'Usar L�neas de factoring';
            Description = 'QB 1.06.15 - JAV 23/09/20: - [TT] Si se van a usar los contratos de factoring globales';


        }
        field(90; "Blanket Purchase Multy-company"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Contratos Marco Muti-empresa';
            Description = 'QB 1.06.12 - JAV 30/08/20: - [TT] Si se marca, indica que los contratos marco son multi-empresa, si no se marcan son individuales de cada empresa';


        }
        field(92; "Blanket Purchase Serie"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie Cost Database No.', ESP = 'N� serie Contratos marco';
            Description = 'QB 1.06.12 - JAV 30/08/20: - [TT] Que contador se usar� para numerar los contratos marco (para contratos marco por empresa)';


        }
        field(95; "Prepayment Posting Group 2"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Grupo Producto para Anticipos con Factura';
            Description = 'ANTICIPOS JAV 27/06/20: [TT] Que "Grupo contable de producto" se usar� para obtener la cuenta de anticipo para clientes o proveedores con Factura';


        }
        field(98; "Use Customer in WIP"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar Cliente en Obra en Curso';
            Description = 'WIP. QB 1.07.10 - JAV 03/12/20: - [TT] Si se usar� el cliente en el movimienot de la obra en curso';


        }
        field(99; "Calculate WIP by periods"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Calcular Obra en Curso por per�odos';
            Description = 'WIP. QB 1.07.08 - JAV 25/11/20: - [TT] Indica el valor por defecto para el c�lculo del WIP, si est� marcado ser� por periodos, si no ser� a origen';


        }
        field(100; "Calc Due Date"; Option)
        {
            OptionMembers = "Standar","Document","Reception","Approval";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Calculo Vencimientos';
            OptionCaptionML = ENU = 'Standar,Document,Reception,Approval', ESP = 'Estandar,Fecha del Documento,Fecha de Recepci�n,Fecha de Aprobaci�n';

            Description = 'COMPRAS QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';


        }
        field(101; "No. Days Calc Due Date"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� d�as tras Recepci�n';
            Description = 'COMPRAS QB 1.06 - JAV 12/07/20: - d�as adicionales para el c�lculo del vto de las fras de compra,ORTIZ';


        }
        field(102; "Max. Dif. Amount Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Diferencia M�xima Facturas';
            Description = 'COMPRAS QB 1.06.05 - JAV 04/02/20: - GAP12 ROIG CyS importe m�ximo de diferencia entre lo indicado en la factura del proveedor y el importe registrado';


        }
        field(103; "Dif. Amount On"; Option)
        {
            OptionMembers = "Base","Total","Payment";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Diferencia Facturas Sobre';
            OptionCaptionML = ENU = 'Base,Total,Payment', ESP = 'Base Imponible,Total,Pago';

            Description = 'COMPRAS QB 1.06.05 - JAV 04/02/20: - GAP12 ROIG CyS Sobre que importe se verifica la factura';


        }
        field(104; "See Posting No"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ver Nro registro';
            Description = 'COMPRAS QB 1.06.21 - JAV 16/10/20: - Ver en la fra de compra el campo "Posting No."';


        }
        field(105; "Vendor Amount Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Proveedor Obligatorio Compra';
            Description = 'COMPRAS QB 1.07.10 - JAV 02/12/20: - Uso del campo Importe del proveedor Obligatorio en las facturas de compra';


        }
        field(106; "Due Certificate Action"; Option)
        {
            OptionMembers = "No","Shipment","Invoice";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Acci�n para certificado caducado';
            OptionCaptionML = ESP = 'No registrar,Solo Albaranes/FRI,Permitir Albaranes/FRI y Facturas';

            Description = 'COMPRAS QB 1.08.13 - JAV 18/02/21: - [TT] Que acci�n se ejecuta al intentar registrar documentos de compra de proveedores con certificado caducado';


        }
        field(107; "Comparatives by months"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comparativos por meses';
            Description = 'COMPRAS QB 1.10.08 - JAV 16/12/21: - [TT] Si se permite desglosar por meses las l�neas de los comparativos al generar los contratos';


        }
        field(130; "Dimension for CA Code"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimensions for CA Code', ESP = 'Cod. Dimensi�n para C.A.';
            Description = 'FINANCIERO';


        }
        field(131; "Dimension for Jobs Code"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Jobs Code', ESP = 'Cod. Dimensi�n proyectos';
            Description = 'FINANCIERO';


        }
        field(132; "Dimension for Dpto Code"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimensions Dptos Code', ESP = 'Cod. Dimensi�n Dptos.';
            Description = 'FINANCIERO';


        }
        field(133; "Dimension for JV Code"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension JV Code', ESP = 'Cod. Dimension UTE';
            Description = 'FINANCIERO';


        }
        field(134; "Dimension for Reestim. Code"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Reestimation Code', ESP = 'Cod. Dimensi�n reestimaci�n';
            Description = 'FINANCIERO';


        }
        field(135; "Analysis View for Job"; Code[10])
        {
            TableRelation = "Analysis View";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Vista An�lisis para proyecto';
            Description = 'FINANCIERO';


        }
        field(136; "Acc. Sched. Name for Job"; Code[10])
        {
            TableRelation = "Acc. Schedule Name";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Nombre cta. esq. para proyecto';
            Description = 'FINANCIERO';


        }
        field(137; "Payment Bank Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Banco de cobro/pago Obligatorio';
            Description = 'FINANCIERO  QB 1.10.01 JAV 24/11/21';


        }
        field(138; "Budget for Jobs"; Code[10])
        {
            TableRelation = "G/L Budget Name";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Jobs Budget', ESP = 'Presupuesto para proyectos';
            Description = 'FINANCIERO';


        }
        field(140; "Control Negative Target"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Control Negative Target', ESP = 'Controlar Objetivo Negativo';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(141; "Block Reestimations"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Block Reestimations', ESP = 'Bloquear reestimaciones';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(142; "Allow in January"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in January', ESP = 'Permitir en Enero';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(143; "Allow in February"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in February', ESP = 'Permitir en Febrero';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(144; "Allow in March"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in March', ESP = 'Permitir en Marzo';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(145; "Allow in April"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in April', ESP = 'Permitir en Abril';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(146; "Allow in May"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in May', ESP = 'Permitir en Mayo';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(147; "Allow in June"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in June', ESP = 'Permitir en Junio';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(148; "Allow in July"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in July', ESP = 'Permitir en Julio';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(149; "Allow in August"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in August', ESP = 'Permitir en Agosto';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(150; "Allow in September"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in September', ESP = 'Permitir en Septiembre';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(151; "Allow in October"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in October', ESP = 'Permitir en Octubre';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(152; "Allow in November"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in November', ESP = 'Permitir en Noviembre';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(153; "Allow in December"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow in December', ESP = 'Permitir en Diciembre';
            Description = 'Q13643 Mejoras en la ficha de objetivos del proyecto y Para bloqueos de meses de cierre';


        }
        field(155; "Use Date Budget Control"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar control de fechas de presupuestos';
            Description = 'GENERAL. JAV 07/07/21: - Q13715 [TT] Si se desea usar el control de las fechas de registro para los presupestos de proyectos';


        }
        field(160; "Internal Shippind Sales Inv."; Option)
        {
            OptionMembers = "No","Manual","Automatic";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Automatic invoice sending', ESP = 'Mail interno de facturas venta';
            OptionCaptionML = ENU = 'No,Manual,Automatic', ESP = 'No enviar,Env�o Manual,Env�o Autom�tico';

            Description = 'Q16494 QB 1.10.41 - APC/JAV 15/05/22 15/05/22: - [TT] Este campo indica si se desea enviar un mail interno cuando se registre una factura de venta, si se realizar� el env�o de forma manual o autom�tica.';

            trigger OnValidate();
            BEGIN
                //JAV 16/05/22: - QB 1.10.41 Env�o interno de mail de confignaci�n, si ha canbiado el tipo y antes no estaba en NO, se ponen valores por defecto
                IF ("Internal Shippind Sales Inv." <> xRec."Internal Shippind Sales Inv.") AND
                   (xRec."Internal Shippind Sales Inv." = xRec."Internal Shippind Sales Inv."::No) THEN BEGIN

                    "Internal Shippind Don't Show" := TRUE;
                    "Internal Shipping Text 1" := 'Se ha registrado %1 %2 del cliente %3 %4';
                    "Internal Shipping Text 2" := 'Por el usuario %5';
                    "Internal Shipping Text 3" := 'En la empresa %6';
                END;
            END;


        }
        field(161; "Internal Shippind to Mail"; Text[250])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Mail invoice sending', ESP = 'Direccio�n de Email del env�o';
            Description = 'Q16494 QB 1.10.41 - APC 15/05/22 15/05/22: - [TT] Este campo indica si se desea enviar un mail interno cuando se registre una factura de venta, las direcciones de correo a donde se remiten (siempre se a�ade el usuario que registr� la factura)';


        }
        field(162; "Internal Shippind Inv. Layout"; Code[20])
        {
            TableRelation = "Custom Report Layout"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Email Body Layout Code', ESP = 'C�digo de dise�o del cuerpo para Facturas';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Este campo indica si se desea enviar un mail interno cuando se registre una factura de venta, el dise�o del cuerpo del correo electr�nico que se emplear';


        }
        field(163; "Internal Shippind Cr.M. Layout"; Code[20])
        {
            TableRelation = "Custom Report Layout"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Email Body Layout Code', ESP = 'C�digo de dise�o del cuerpo para Abonos';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Este campo indica si se desea enviar un mail interno cuando se registre un abono de venta, el dise�o del cuerpo del correo electr�nico que se emplear';


        }
        field(164; "Internal Shipping Text 1"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto en el cuerpo. Linea 1';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Si no se emplea el dise�o del cuerpo, esta ser� la primera l�nea a mostar. Se puede usar %1 para el tipo de documento, %2 para el n�mero del documento, %3 para el nombre del cliente, %4 para el usuario que ha registrado el documento, %5 para la empresa en que se ha registrado';


        }
        field(165; "Internal Shipping Text 2"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto en el cuerpo. Linea 2';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Si no se emplea el dise�o del cuerpo, esta ser� la segunda l�nea a mostar. Se puede usar %1 para el tipo de documento, %2 para el n�mero del documento, %3 para el nombre del cliente, %4 para el usuario que ha registrado el documento, %5 para la empresa en que se ha registrado';


        }
        field(166; "Internal Shipping Text 3"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto en el cuerpo. Linea 3';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Si no se emplea el dise�o del cuerpo, esta ser� la tercera l�nea a mostar. Se puede usar %1 para el tipo de documento, %2 para el n�mero del documento, %3 para el nombre del cliente, %4 para el usuario que ha registrado el documento, %5 para la empresa en que se ha registrado';


        }
        field(167; "Internal Shippind Don't Show"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Email Body Layout Code', ESP = 'No mostrar el correo electr�nico antes del env�o';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Este campo indica si no se desea mostrar el mensaje antes de proceder al env�o del mismo (si se muestra podr� modificarlo)';


        }
        field(168; "Internal Shippind Don't Conf."; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Email Body Layout Code', ESP = 'No confirmar el env�o';
            Description = 'Q16494 QB 1.10.41 - JAV 15/05/22: - [TT] Este campo indica si no se desea mostrar un mensaje de confirmaci�n tras proceder al env�o del mismo.';


        }
        field(200; "Serie for Offers"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Serie Offers No.', ESP = 'N� serie Estudios';
            Description = 'PROYECTOS. QB 1.00 - JAV 25/03/20: - Serie para numerar Estudios';


        }
        field(201; "Serie for Jobs"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Nos.', ESP = 'N� serie Obras';
            Description = 'PROYECTOS. QB 1.00 - JAV 25/03/20: - Serie para numerar Obras';


        }
        field(210; "Serie for Transfers Post"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Serie Posting Car/Des', ESP = 'No. serie Traspasos Registrados';
            Description = 'PROYECTOS. QB 1.08.06 - JAV 27/01/21 Se cambia el caption';


        }
        field(211; "Serie for Transfers"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Serie car/des', ESP = 'No. serie Traspasos';
            Description = 'PROYECTOS. QB 1.08.06 - JAV 27/01/21 Se cambia el caption';


        }
        field(212; "Transfers Account Expense"; Code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allocation Account Car/Des Def', ESP = 'Cta. traspaso Gasto por defecto';
            Description = 'PROYECTOS. QB 1.08.06 - JAV 27/01/21 Se cambia el caption';


        }
        field(213; "Transfers Account Sales"; Code[20])
        {
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transfer Account Invoice Defau', ESP = 'Cta. traspaso Venta por defecto';
            Description = 'PROYECTOS. QB 1.08.06 - JAV 27/01/21 Se cambia el caption';


        }
        field(220; "Serie for Output Shipmen"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Output Ship. Posting Serie No.', ESP = 'N� serie registro alb. salida';
            Description = 'ALMACEN. QB 1.08.10';


        }
        field(221; "Serie for Stock Regularization"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Stock Regularization Serie No.', ESP = 'N� serie regularizaci�n stock';
            Description = 'ALMACEN. QB 1.08.10';


        }
        field(222; "Receipt Management Journal"; Code[10])
        {
            TableRelation = "Item Journal Template"."Name";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receipt Management Journal', ESP = 'Diario gesti�n recepci�n';
            Description = 'ALMACEN. QB 1.09.21';


        }
        field(223; "Receipt Management Section"; Code[10])
        {
            TableRelation = "Item Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Receipt Management Journal"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receipt Management Section', ESP = 'Secci�n gesti�n recepci�n';
            Description = 'ALMACEN. QB 1.09.21';


        }
        field(224; "Serie for Receipt/Transfer"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Receipt/Transfer Nos.', ESP = 'N� serie Recepci�n/Traspaso';
            Description = 'ALMACEN. QB 1.09.21';


        }
        field(225; "Serie for Receipt/Transfer Pos"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posted Receipt/Transfer Nos.', ESP = 'N� serie Recepci�n/Traspaso registrado';
            Description = 'ALMACEN. QB 1.09.21';


        }
        field(226; "Ceded Control"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ceded Control', ESP = 'Funcionalidad productos prestados';
            Description = 'ALMACEN. QB 1.09.21';


        }
        field(230; "Default Calendar"; Code[10])
        {
            TableRelation = "Type Calendar";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Default Calendar', ESP = 'Calendario por defecto';
            Description = 'RECURSOS';


        }
        field(231; "Serie for Work Sheet"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Serie Sheet', ESP = 'N� serie parte trabajo';
            Description = 'RECURSOS';


        }
        field(232; "Serie for Work Sheet Post"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Serie Sheet Post.', ESP = 'N� serie parte trabajo registrado';
            Description = 'RECURSOS';


        }
        field(235; "Serie for Service Order"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Serie for Service Order', ESP = 'N� serie Pedido de Servicio';
            Description = 'PEDIDOSERVICIO - QB 1.09.21';


        }
        field(236; "Serie for Service Order Post"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Serie for Service Order Post', ESP = 'N� serie Pedido de Servicio Registrado';
            Description = 'PEDIDOSERVICIO - QB 1.09.21';


        }
        field(237; "Use Service Order"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Service Order', ESP = 'Pedidos de Servicio';
            Description = 'PEDIDOSERVICIO - QB 1.09.21';


        }
        field(240; "Quobuilding"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Quobuilding', ESP = 'QuoBuilding';
            Description = 'GENERAL';


        }
        field(241; "Reestimates"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Reestimates', ESP = 'Reestimaciones';
            Description = 'GENERAL';


        }
        field(242; "QW Withholding"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Withholding', ESP = 'Retenciones';
            Description = 'GENERAL';


        }
        field(243; "Rental Management"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Rental Management', ESP = 'Gestion de Alquileres';
            Description = 'GENERAL';


        }
        field(250; "Commercial Register"; Text[150])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Commercial Register', ESP = 'Registro mercantil';
            Description = 'GENERAL QB 1.06.07 - Se amplia a 150';


        }
        field(251; "Company Representative"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company Representative', ESP = 'Representante de la empresa';
            Description = 'GENERAL';


        }
        field(252; "VAT Registration No. Represen."; Text[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Registration No. Represen.', ESP = 'DNI/CIF representante';
            Description = 'GENERAL';


        }
        field(253; "Notary"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Notario';
            Description = 'GENERAL';


        }
        field(254; "Notarial Protocol"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Notarial Protocol', ESP = 'Protocolo notarial';
            Description = 'GENERAL';


        }
        field(255; "Establishment Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Fecha de constitucion', ESP = 'Fecha de constituci�n';
            Description = 'GENERAL QB 1.07.11';


        }
        field(256; "Notary City"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Notary City', ESP = 'Ciudad del Notario';
            Description = 'GENERAL QB 1.09.12';


        }
        field(257; "Company Code"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo de Empresa';
            Description = 'GENERAL QB 1.06.08 - JAV 17/08/20: C�digo de la empresa en Ortiz';


        }
        field(258; "Commercial Register Sheet"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sheet', ESP = 'Hoja del Registro Mercantil';
            Description = 'Q12932';


        }
        field(259; "Representative Adress"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Direcci�n del representaqnte';
            Description = 'GENERAL QB 1.09.12 - JAV 21/07/21: Direcci�n del representante legal de la empresa';


        }
        field(260; "QB Text 1"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto en Factura 1';
            Description = 'GENERAL QB 1.06.07 - Nuevo campo para informaci�n general';


        }
        field(265; "Logo1"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Picture', ESP = 'Logo 1';
            Description = 'GENERAL QBA-00 15/03/19 JAV - Logotipos variados';
            SubType = Bitmap;


        }
        field(500; "QPR Budgets"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Rental Management', ESP = 'Presupuestos';
            Description = 'PRESUPUESTOS. QPR 00.00.01 JAV 14/07/21: - Si se emplean los presupuestos';


        }
        field(502; "QPR Dimension for Budget"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Offer Code', ESP = 'C�d. dimensi�n Presupuestos';
            Description = 'PRESUPUESTOS. QPR 00.00.01 JAV 14/07/21: - Dimensi�n a usar para presupuestos';


        }
        field(503; "QPR Serie for Budgets"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Nos.', ESP = 'N� serie Presupuestos';
            Description = 'PRESUPUESTOS. QPR 00.00.01 JAV 14/07/21: - Serie para numerar PresupuestosObras';


        }
        field(504; "QPR Value dimension for Budget"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento para Presupuestos';
            Description = 'PRESUPUESTOS. QPR 00.00.01 JAV 14/07/21: - Que valor de dimensi�n Departamento se usa por defecto en los Presupuestos';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                ValidateValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for quote");
            END;

            trigger OnLookup();
            BEGIN
                GeneralLedgerSetup.GET();
                OnLookUpValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for quote");
            END;


        }
        field(505; "QPR Analysis View for Budget"; Code[20])
        {
            TableRelation = "Analysis View";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Analysis Offers Code', ESP = 'C�d. Vista An�lisis para Presupuestos';
            Description = 'PRESUPUESTOS. QPR 00.00.01 JAV 14/07/21: - Que vista de an�lisis se usa para presupuestos (opcional)';


        }
        field(506; "QB_QPR Create Auto"; Option)
        {
            OptionMembers = "None","Resource","Item";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Crear autom�ticamente';
            OptionCaptionML = ENU = '" ,Resource,Item"', ESP = '" ,Recurso,Producto"';

            Description = 'PRESUPUESTOS. QPR 00.00.02';

            trigger OnValidate();
            BEGIN
                IF ("QB_QPR Create Auto" <> "QB_QPR Create Auto"::None) THEN
                    "QB_QPR Create Post. Group" := TRUE;
            END;


        }
        field(507; "QB_QPR Base UOM"; Code[10])
        {
            TableRelation = "Unit of Measure"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Unidad de medida Base';
            Description = 'PRESUPUESTOS. QPR 00.00.02';


        }
        field(508; "QB_QPR Create Dim.Value"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '"Crear valor de dimensi�n   Partida"';
            Description = 'PRESUPUESTOS. QPR 00.00.02';


        }
        field(509; "QB_QPR Create Post. Group"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '"Crear Grupo Registro   Partida"';
            Description = 'PRESUPUESTOS. QPR 00.00.02';


        }
        field(510; "QB_QPR Gen. Business Post. Gr."; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Grupo registro Negocio Por defecto';
            Description = 'PRESUPUESTOS. QPR 00.00.04';


        }
        field(511; "QB_QPR VAT Product Post. Gr."; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Grupo de IVA por defecto';
            Description = 'PRESUPUESTOS. QPR 00.00.04';


        }
        field(512; "QPR Use Currency in Budgets"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency', ESP = 'Usar Divisas en Presupuestos';
            Description = 'PRESUPUESTOS. QPR 00.00.06 DIVISAS. JAV 25/07/19: - Si se van a usar divisas en los proyectos';


        }
        field(600; "RE Real Estate"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Rental Management', ESP = 'Real Estate';
            Description = 'REAL_ESTATE 00.00.01 JAV 17/11/21: - Si se emplea Real Estate';


        }
        field(602; "RE Dimension for RE Proyect"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Offer Code', ESP = 'C�d. dimensi�n Real Estate';
            Description = 'REAL_ESTATE 00.00.01 JAV 17/11/21: - Dimensi�n a usar para presupuestos';


        }
        field(603; "RE Serie for RE Proyect"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Nos.', ESP = 'N� serie Proyecto Inmobiliario';
            Description = 'REAL_ESTATE 00.00.01 JAV 17/11/21: - Serie para numerar Proyectos Inmobiliarios';


        }
        field(612; "RE Use Currency in RE"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency', ESP = 'Usar Divisas en Real Estate';
            Description = 'REAL_ESTATE 00.00.06 DIVISAS. JAV 25/07/19: - Si se van a usar divisas en los proyectos';


        }
        field(50000; "Use Referents"; Boolean)
        {
            CaptionML = ENU = 'Use Referents', ESP = 'Usar Referentes';
            Description = 'REFERENTES. 03/05/19 JAV - Si se usan los referentes de clientes';


        }
        field(50001; "Referents Dimension"; Code[20])
        {
            TableRelation = "Dimension";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Referents Dimension', ESP = 'Dimensi�n para Referentes';
            Description = 'REFERENTES. 18/02/19 JAV -  Dimensi�n asociada con referente del cliente (Administrador, arquitecto, Varios)';


        }
        field(50030; "Use Contract Control"; Boolean)
        {
            CaptionML = ENU = 'Use Contract Control', ESP = 'Usar control de contrato';
            Description = 'CONTROL DE CONTRATOS. 08/95/19 JAV - Si se usa el control de importes de contratos';


        }
        field(50031; "k"; Decimal)
        {
            CaptionML = ESP = 'Porcentaje';
            Description = 'CONTROL DE CONTRATOS. 08/95/19 JAV - Si hay un contrato, porcentaje de sobrepaso';


        }
        field(50032; "Contratos Importe"; Decimal)
        {
            CaptionML = ESP = 'Importe';
            Description = 'CONTROL DE CONTRATOS. 08/95/19 JAV - Si hay un contrato, importe de sobrepaso';


        }
        field(50033; "Sin Contrato Importe"; Decimal)
        {
            Description = 'CONTROL DE CONTRATOS. 08/95/19 JAV - Si  no hay un contrato, importe m�ximo posible';


        }
        field(50040; "Value dimension for quote"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento para Estudios';
            Description = 'DIMENSIONES. JAV 23/08/19: - que valor de dimensi�n Departamento se usa por defecto en los estudios';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                ValidateValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for quote");
            END;

            trigger OnLookup();
            BEGIN
                GeneralLedgerSetup.GET();
                OnLookUpValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for quote");
            END;


        }
        field(50041; "Value dimension for job"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento para Proyectos';
            Description = 'DIMENSIONES. JAV 23/08/19: - que valor de dimensi�n Departamento se usa por defecto en los proyectos operativos';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                ValidateValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for job");
            END;

            trigger OnLookup();
            BEGIN
                GeneralLedgerSetup.GET();
                OnLookUpValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for job");
            END;


        }
        field(50042; "Value dimension for structure"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento para Pr.Estructura';
            Description = 'DIMENSIONES. JAV 23/08/19: - que valor de dimensi�n Departamento se usa por defecto para el almac�n';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                ValidateValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for structure");
            END;

            trigger OnLookup();
            BEGIN
                GeneralLedgerSetup.GET();
                OnLookUpValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for structure");
            END;


        }
        field(50043; "Value dimension for location"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Departamento para Almac�n';
            Description = 'DIMENSIONES. JAV 23/08/19: - que valor de dimensi�n Departamento se usa por defecto en los proyectos de estructura';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                ValidateValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for location");
            END;

            trigger OnLookup();
            BEGIN
                GeneralLedgerSetup.GET();
                OnLookUpValueDimension(FunctionQB.ReturnDimDpto, "Value dimension for location");
            END;


        }
        field(50045; "Dim. Default Value for Quote"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Dimension Default Value', ESP = 'Valor dimensi�n estudio por defecto';
            Description = 'DIMENSIONES. JAV 23/08/19: - que valor de dimensi�n Estudio se usa por defecto en los mismos';

            trigger OnValidate();
            BEGIN
                ValidateValueDimension("Dimension for Quotes", "Dim. Default Value for Quote");
            END;

            trigger OnLookup();
            BEGIN
                OnLookUpValueDimension("Dimension for Quotes", "Dim. Default Value for Quote");
            END;


        }
        field(50046; "Dim. Default Value for Job"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Dimension Default Value', ESP = 'Valor dimensi�n proyecto por defecto';
            Description = 'DIMENSIONES. JAV 23/08/19: - que valor de dimensi�n Proyecto se usa por defecto en los proyectos operativos';

            trigger OnValidate();
            BEGIN
                GeneralLedgerSetup.GET();
                ValidateValueDimension(FunctionQB.ReturnDimJobs, "Dim. Default Value for Job");
            END;

            trigger OnLookup();
            BEGIN
                GeneralLedgerSetup.GET();
                OnLookUpValueDimension(FunctionQB.ReturnDimJobs, "Dim. Default Value for Job");
            END;


        }
        field(50047; "Not  AC obligatory in jobs"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Dimension C.A. no obligatorio en proyectos';
            Description = 'DIMENSIONES. JAV 10/02/21: - QB 1.08.08 [TT] Indica si por defecto no se a�ade como obligatoria la dimensi�n C.A. al crear un proyecto';


        }
        field(50051; "Purch. Document Regiter Text"; Text[50])
        {
            CaptionML = ENU = 'Job Imputation', ESP = 'Texto de registro para compras';
            Description = 'GENERAL. JAV 03/07/19: - Texto de registro de los documentos para compras';


        }
        field(50052; "Sales Document Regiter Text"; Text[50])
        {
            CaptionML = ENU = 'Job Imputation', ESP = 'Texto de registro para ventas';
            Description = 'GENERAL. JAV 03/07/19: - Texto de registro de los documentos para ventas';


        }
        field(50080; "Use Salesperson dimension"; Boolean)
        {
            CaptionML = ENU = 'Use Salesperson dimension', ESP = 'Usar Dimensi�n Vendedor';
            Description = 'DIMENSIONES. JAV 13/05/19 si usa la dim. vendedor y es obligatorio informar del vendedor en el proyecto';


        }
        field(50083; "Series for Job"; Boolean)
        {
            CaptionML = ESP = 'Serie de documentos por proyecto';
            Description = 'GENERAL. JAV 21/06/19: - Si se emplea un contador diferente por cada proyecto';


        }
        field(50084; "OLD_Location negative"; Boolean)
        {
            CaptionML = ESP = 'Permitir almac�n negativo';
            Description = '### ELIMINAR ### No se usa, en su lugar se debe usar el campo est�ndar 40 de la tabla 313';


        }
        field(50085; "Job access control"; Boolean)
        {
            CaptionML = ESP = 'Control acceso usuarios';
            Description = 'APROBACIONES. JAV 11/07/19: - Si se utiliza el control de acceso por usuarios de la obra';


        }
        field(50086; "Day of the Period"; Integer)
        {
            CaptionML = ENU = 'Days of the SII upload Period', ESP = 'Dias de plazo para subir al SII';
            Description = 'GENERAL. QCPM_GAP18';


        }
        field(50087; "Use DCBP Aditional Fields"; Boolean)
        {
            CaptionML = ESP = 'Campos adic. descompuestos';
            Description = 'GENERAL. JAV 07/08/19: - Si se ven los campos adicionales en los descompuestos';


        }
        field(50088; "Close month process"; Option)
        {
            OptionMembers = "Copy","Reestimate";
            CaptionML = ESP = 'Proceso al cerrar el mes';
            OptionCaptionML = ENU = 'Copy,Reestimate', ESP = 'Copiar,Reestimar';

            Description = 'GENERAL. JAV 10/08/19: - Si al cerrar el mes se debe copiar o reestimar';


        }
        field(50089; "Act.Price on Generate Contract"; Boolean)
        {
            CaptionML = ESP = 'Act. precios al generar contrato';
            Description = 'GENERAL. JAV 10/08/19: - Si al generar el contrato se deben actualizar los precios de los descompuestos';


        }
        field(50090; "Quote to Job Expenses"; Boolean)
        {
            CaptionML = ESP = 'Traspasar gastos de estudio a proyecto';
            Description = 'PASAR GASTOS. JAV 23/08/19: - Si se traspasan autom�ticamente  los gastos de los estudios a los proyectos al crearlos';


        }
        field(50091; "Quote to Job Piecework"; Code[20])
        {
            CaptionML = ESP = 'U.O. gastos estudio a proyecto';
            Description = 'PASAR GASTOS. JAV 23/08/19: - Que U.O. se usa para pasar los gastos del estudio a la obra';


        }
        field(50092; "Use Sales Series"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar series en Ventas';
            Description = 'GENERAL. QB 1.06.08 JAV 14/08/20: - Si se usan varias series en facturas y abonos de venta';


        }
        field(50093; "CA in Stock Regularization"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'CA in Stock Regularization', ESP = '"C.Anal�tico Acopio en Reg.Stock"';
            Description = 'QBU17147 CSM 11/05/22';


        }
        field(50100; "Evaluation Value"; Integer)
        {
            CaptionML = ESP = 'Valor m�ximo evaluaci�n';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Sobre que valor se establece la puntuaci�n m�xima a los proveedores';


        }
        field(50101; "Evaluation score 1"; Decimal)
        {
            CaptionML = ESP = 'M�nima puntuaci�n 1';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Puntos para obtener la clasificaci�n del nivel 1';


        }
        field(50102; "Evaluation rating 1"; Text[30])
        {
            CaptionML = ESP = 'Clasificaci�n 1';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Texto de la clasificaci�n del nivel 1';


        }
        field(50103; "Evaluation score 2"; Decimal)
        {
            CaptionML = ESP = 'M�nima puntuaci�n 2';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Puntos para obtener la clasificaci�n del nivel 2';


        }
        field(50104; "Evaluation rating 2"; Text[30])
        {
            CaptionML = ESP = 'Clasificaci�n 2';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Texto de la clasificaci�n del nivel 2';


        }
        field(50105; "Evaluation score 3"; Decimal)
        {
            CaptionML = ESP = 'M�nima puntuaci�n 3';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Puntos para obtener la clasificaci�n del nivel 3';


        }
        field(50106; "Evaluation rating 3"; Text[30])
        {
            CaptionML = ESP = 'Clasificaci�n 3';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Texto de la clasificaci�n del nivel 3';


        }
        field(50107; "Evaluation score 4"; Decimal)
        {
            CaptionML = ESP = 'M�nima puntuaci�n 4';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Puntos para obtener la clasificaci�n del nivel 4';


        }
        field(50108; "Evaluation rating 4"; Text[30])
        {
            CaptionML = ESP = 'Clasificaci�n 4';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Texto de la clasificaci�n del nivel 4';


        }
        field(50109; "Evaluation score 5"; Decimal)
        {
            CaptionML = ESP = 'M�nima puntuaci�n 5';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Puntos para obtener la clasificaci�n del nivel 5';


        }
        field(50110; "Evaluation rating 5"; Text[30])
        {
            CaptionML = ESP = 'Clasificaci�n 5';
            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - Texto de la clasificaci�n del nivel 5';


        }
        field(50111; "Evaluation method"; Option)
        {
            OptionMembers = "Date","Reviews","AddReviews";
            CaptionML = ESP = 'Sistema de Evaluaci�n';
            OptionCaptionML = ENU = 'Date,Revision,Add Reviews', ESP = 'Fecha,Revisi�n,Sumar Revisi�n';

            Description = 'CALIDAD-EVALUACIONES. JAV 17/08/19: - M�todo de c�lculo de la evaluaci�n';


        }
        field(50120; "Use certificate control"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar control de certificados';
            Description = 'CALIDAD-CERTIFICADOS JAV 08/03/20: - Si se usa el control de certificados vecidos';


        }
        field(50121; "Auxiliary Location Code"; Code[20])
        {
            TableRelation = "Location";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Auxiliary Location Code', ESP = 'C�d. Almac�n auxiliar';
            Description = 'QB 1.06.15';


        }
        field(50122; "Job revaluation Jnl. Template"; Code[10])
        {
            TableRelation = "Job Journal Template"."Name" WHERE("Recurring" = FILTER(false));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job revaluation Jnl. Template', ESP = 'Nombre plantilla diario de proyectos de revalorizaciones';
            Description = 'Q17138. CPA 06-06-22. Productos prestados';


        }
        field(50123; "Job revaluation Jnl. Batch"; Code[10])
        {
            TableRelation = "Job Journal Batch"."Name" WHERE("Journal Template Name" = FIELD("Job revaluation Jnl. Template"),
                                                                                                 "Recurring" = FILTER(false));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job revaluation Jnl. Batch', ESP = 'Nombre secci�n diario de poryectos revalorizaciones';
            Description = 'Q17138. CPA 06-06-22. Productos prestados';


        }
        field(50124; "Coste prod. prestados recibido"; Option)
        {
            OptionMembers = "Coste almacen principal","Ultimo coste directo","Coste medio compra";
            DataClassification = ToBeClassified;
            OptionCaptionML = ESP = 'Coste almac�n principal,�ltimo coste directo,Coste medio compra';

            Description = 'Q17138. CPA 10-06-22. Productos prestados';


        }
        field(50125; "Periodo Calc. Precio Compra"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Description = 'Q17138. EPV 15-06-22. Productos prestados';


        }
        field(7238177; "QB Requires vendor approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Requires vendor approval', ESP = 'Requiere Homologaci�n de proveedores';
            Description = 'QRE 1.00.00 15647';


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

    var
        //       QuoBuildingSetup@1100286004 :
        QuoBuildingSetup: Record 7207278;
        //       Company@1100286005 :
        Company: Record 2000000006;
        //       GeneralLedgerSetup@1100286000 :
        GeneralLedgerSetup: Record 98;
        //       DimensionValue@1100286002 :
        DimensionValue: Record 349;
        //       pgDimensionValues@1100286001 :
        pgDimensionValues: Page "Dimension Values";
        //       FunctionQB@7001101 :
        FunctionQB: Codeunit 7207272;
        //       CA@7001102 :
        CA: Code[20];
        //       Err001@1100286003 :
        Err001: TextConst ESP = 'No existe el valor de dimensi�n %1 en %2';

    //     LOCAL procedure ValidateValueDimension (Dimension@1100286001 : Code[20];Value@1100286000 :
    LOCAL procedure ValidateValueDimension(Dimension: Code[20]; Value: Code[20])
    begin
        if (Value <> '') then
            if (not DimensionValue.GET(Dimension, Value)) then
                ERROR(Err001, Value, Dimension);
    end;

    //     LOCAL procedure OnLookUpValueDimension (Dimension@1100286000 : Code[20];var Value@1100286001 :
    LOCAL procedure OnLookUpValueDimension(Dimension: Code[20]; var Value: Code[20])
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", Dimension);
        CLEAR(pgDimensionValues);
        pgDimensionValues.SETTABLEVIEW(DimensionValue);
        if (DimensionValue.GET(Dimension, Value)) then
            pgDimensionValues.SETRECORD(DimensionValue);
        pgDimensionValues.LOOKUPMODE(TRUE);
        if pgDimensionValues.RUNMODAL = ACTION::LookupOK then begin
            pgDimensionValues.GETRECORD(DimensionValue);
            Value := DimensionValue.Code;
        end;
    end;

    LOCAL procedure PropagateFields()
    var
        //       QBRelatedCompanies@1100286000 :
        QBRelatedCompanies: Record 7206927;
    begin
        // // //Propagar la configuraci�n de los campos comunes al resto de empresas
        // // Company.RESET;
        // // Company.SETFILTER(Name, '<>%1', COMPANYNAME);
        // // if (Company.FINDSET(FALSE)) then
        // //  repeat
        // //    QuoBuildingSetup.RESET;
        // //    QuoBuildingSetup.CHANGECOMPANY(Company.Name);
        // //    if QuoBuildingSetup.GET then begin
        // //      //Master Data
        // //      QuoBuildingSetup."Synchronize between companies" := "Synchronize between companies";
        // //      QuoBuildingSetup."Master Data Company" := "Master Data Company";
        // //
        // //      QuoBuildingSetup.MODIFY;
        // //    end;
        // //  until Company.NEXT = 0;
        // //
        // // QBRelatedCompanies.RESET;
        // // QBRelatedCompanies.SETFILTER(Company, '<>%1', "Master Data Company");
        // // QBRelatedCompanies.SETRANGE("Master Data", TRUE);
        // // QBRelatedCompanies.MODIFYALL("Master Data", FALSE);
        // //
        // // if ("Master Data Company" <> '') then begin
        // //  if (QBRelatedCompanies.GET("Master Data Company")) then begin
        // //    if (not QBRelatedCompanies."Master Data") then begin
        // //      QBRelatedCompanies."Master Data" := TRUE;
        // //      QBRelatedCompanies.MODIFY;
        // //    end;
        // //  end else begin
        // //    QBRelatedCompanies.INIT;
        // //    QBRelatedCompanies.Company := "Master Data Company";
        // //    QBRelatedCompanies."Master Data" := TRUE;
        // //    QBRelatedCompanies.INSERT;
        // //  end;
        // // end;
    end;

    LOCAL procedure SetTestCompany()
    var
        //       SIISetup@1100286000 :
        SIISetup: Record 10751;
        //       JobQueueEntry@1100286001 :
        JobQueueEntry: Record 472;
        //       SIIConfiguration@1100286002 :
        SIIConfiguration: Page 7174340;
    begin
        //JAV 18/03/22: - QB 1.10.26 Si es una empresa de pruebas desactivamos el SII est�ndar y el QuoSII
        if "Is Test Company" then begin
            // SIISetup.GET;
            // SIISetup.Enabled := FALSE;
            // SIISetup.MODIFY;

            // SIIConfiguration.ActivateQueue(TRUE);
        end else begin
            MESSAGE('Ha desactivado la empresa como de pruebas, recuerde volver a activar el env�o al SII si es necesario');
        end;
    end;

    LOCAL procedure "----------------------------------------"()
    begin
    end;

    procedure QB_GetText1(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        //       TempBlob@100000001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        CALCFIELDS("QB Text 1");
        if not "QB Text 1".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "QB Text 1";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("QB Text 1");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;

    //     procedure QB_SetText1 (pTxt@100000001 :
    procedure QB_SetText1(pTxt: Text)
    var
        //       TempBlob@100000000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        // TempBlob.WriteAsText(pTxt, TEXTENCODING::Windows);
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(pTxt);
        // "QB Text 1" := TempBlob.Blob;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("QB Text 1");
        if not MODIFY then
            INSERT;
    end;

    /*begin
    //{
//      QMD 18/08/10: - Q3254 Nuevo campo "Use Responsibility Center"
//      JAV 03/04/19: - Nuevo par�metro con la pantallas se ver�n por defecto en la page de costes directos
//      JAV 13/05/19: - Nuevo par�metro 50080 "Use Salesperson dimension", para hacer obligatorio el vendedor asociado al cliente
//      JAV 19/02/19: - Se a�aden los campos 50000..50001 para el uso obligatorio de referentes en Andrasa
//      JAV 02/03/19: - Se a�aden nuevos campos 50010..50019 para controlar las relaci�n de cobros de Andrasa
//      PGM 30/04/19: - QCPM_GAP18 Creado el campo "Day of the Period"
//      JAV 15/05/19: - Se a�aden los campos 50030..50032 para el control de contratos
//                    - Se a�ade el campo 50050 para presentar o no los factbox de Sharepoint
//                    - Se a�aden los capos 50060..50075 para las relaciones de pagos y pagar�s de Perteo
//                    - Se a�ade el cmapo 50080 para indicar si la dimensi�n vendedor es obligatoria
//      JAV 08/07/19: - Se a�ade el campo 50052"Departamento para Labor" Departamento en que se imputan asientos de la n�mina de Labor
//      JAV 24/07/19: - Se a�aden campos 50 a 55 para saber que reports sacar de rel.valorada, medici�n y certificaci�n
//      JAV 11/07/19: - Campo 50085 "Job access control" que indica si se utiliza el control de acceso por usuarios de la obra
//      JAV 24/07/10: - Campos 50 a 55 que indican que report se usan para relaci�n valorada, medici�n y certificaci�n registradas y sin registrar
//      JAV 25/07/19: - Campo 60 "Use Job Currency" que indica si se van a usar divisas en los proyectos
//      JAV 07/08/19: - Se a�ade el campo 50087 "Use DCBP Aditional Fields" para ver o no los campos adicionales en descompuestos
//      JAV 10/08/19: - Se a�ade el campo 50088 "Close month process" que indica si al cerrar el mes se debe copiar o reestimar
//                    - Se a�ade el campo 50089"Act.Price on Generate Contract" si al generar el contrato se deben actualizar los precios de los descompuestos
//      JAV 07/09/19: - Se a�aden para la gesti�n de garant�as los campos 81 "Guarantee Analitical Concept" y 82 "Guarantee Piecework Unit"
//      JAV 22/09/19: - Se a�ade el campo "Guarantee Piecework Unit Prov." para las provisiones de gastos de las garant�as
//      JAV 03/10/19: - Se eliminan los campos 50 a 55 que ya no se usan con el selector de informes
//      JAV 09/10/19: - Se a�ade el campo "Quote Budget Code" que indica el c�digo que usa al crear el proyecto de un estudio cuando se a�ade el presupuesto de Estudio
//                      adem�s del Master, si est� en blanco no se a�ade.
//      JAV 12/10/19: - Se a�ade el campo "Initial Budget" que indica que presupuesto ser� el inicial, si el de Estudio o el Master
//      JAV 08/03/20: - CALIDAD-CERTIFICADOS Se a�ade el campo 50120 que indica si se usa el control de certificados vecidos
//      JAV 22/09/20: - QB 1.06.15 Campos para Sincronizar empresas
//      PGM 24/09/20: - QB 1.06.15 Creado el campo "Auxiliary Location Code"
//      DGG 21/06/21: - Q13152 Se a�ade campo "Usar Agrupaciones en U.O Venta" para gestion de certificaciones de obras.
//      PGM 12/07/21: - Q13619 Creado el campo "Notary City"
//      MMS 12/07/21: - Q13643 Se a�aden campos 140 �Control Negative Target�, de tipo bool, 141 �Block Reestimations�, de tipo bool
//      MMS 13/07/21: - Q13643 Se a�aden campos 142 a 153 �Allow in January� hasta �Allow in December�, booleanos con caption �Permitir en Enero� hasta �Permitir en Diciembre�
//      MCM 06/10/21: - QPR Q15432 Se a�ade el campo QB_QPR Create Resources
//      DGG 08/10/21: - QB 1.09.21  Se a�aden  campos:222Receipt Management Journal,223Receipt Management Section, 224Serie for Receipt/Transfer, 225Serie for Receipt/Transfer Pos, 226Ceded Control, 235Serie for Service Order, 236Serie for Service
//      MCM 14/10/21: - QPR Q15432 Se a�ade el campo QB_QPR Resource UOM
//      DGG 23/11/21: - QRE 1.00.00 15647 Se a�ade campo "QB Requires vendor approval"
//      JAV 04/04/22: - QB 1.10.31 Se cambian campos de aprobacines a la nueva tabla de configuraci�n de aprobaciones
//      JAV 08/04/22: - QB 1.10.33 Se a�aden campos 88 y 89 para los gastos activables
//      JAV 10/04/22: - QB 1.10.33 Se elimina el campo 50084 "Location Negative", en su lugar se usar� el campo del est�ndar de conf. almac�n
//      JAV 11/04/22: - QB 1.10.35 Se a�ade el campo 5 "Serie for Activables Expenses" para los gastos activables.
//                                 Se a�ade el campo 78 "Prepayment Document Type" para anticipos.
//      CSM 11/05/22: - QB 1.10.42 (QBU17147) New Field "C.Anal�t.=Acopio en Reg.Stock"  Si est� marcado en el proceso de Regularizaci�n stock informar�
//                                            la columna "Concepto Analitico" con el valor configurado en el Almac�n de acopio del proyecto.
//      JAV 16/06/22: - QB 1.10.50 Se a�ade el campo 84 "Fiter Same Job Type" que indica si por defecto se filtran que al buscar un proyecto en  compras sean del mismo tipo del actual (QB/RE/CECO)
//      CPA 06/06/22: - Q17138 Productos prestados. Nuevos campos "Job revaluation Journal Template" y "Job revaluation Journal Batch" para la revalorizaci�n de movimientos de proyectos
//      EPV 15/06/22: - Q17138 Productos prestados. Nuevos campos "Coste prod. prestados recibido" y "Periodo Calc. Precio Compra".
//      JAV 27/06/22: - QB 1.10.55 Se a�ade el campo 95 "Prepayment Posting Group 2" y se cambia el 47 a "Prepayment Posting Group 1"
//      JAV 04/10/22: - QB 1.12.00 Se eliminan los campos 87, 88 y 89. Se usar�n en su lugar los 120 a 123 para activaciones
//    }
    end.
  */
}







