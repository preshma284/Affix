table 7207386 "Data Piecework For Production"
{



    CaptionML = ENU = 'Data Job Unit For Production', ESP = 'Datos unid. obra para produc.';
    LookupPageID = "Data Piecework List";
    DrillDownPageID = "List Unit Production";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'C¢d. proyecto';


        }
        field(2; "Piecework Code"; Text[20])
        {


            CaptionML = ENU = 'Piecework Code', ESP = 'C¢d. unidad de obra';
            NotBlank = true;
            CaptionClass = '7206910,7207386,2';

            trigger OnValidate();
            BEGIN
                //JAV 06/10/20: - QB 1.06.18 Traspaso el c lculo de si la unidad es planificable a su validate y se llama desde mas lugares
                VALIDATE(Plannable);

                //JAV 05/10/19: - Se elimina la funci¢n "GenerateUniqueCode" y se pasa al validate del campo "Unique code"
                VALIDATE("Unique Code");
            END;


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci¢n 2';


        }
        field(5; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("Job Cost Piecework"),
                                                                                           "No." = FIELD("Unique Code")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(6; "Amount Production Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD(FILTER("Budget Filter")),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date"))));
            CaptionML = ENU = 'Amount Production Budget', ESP = 'Importe producci¢n ppto.';
            Description = 'Venta';
            Editable = false;
            AutoFormatType = 1;
            CaptionClass = '7206910,7207386,6';


        }
        field(7; "Aver. Cost Price Pend. Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Cost By Piecework"."Budget Cost" WHERE("Job No." = FIELD("Job No."),
                                                                                                                 "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                 "Analytical Concept Direct Cost" = FIELD("Filter Analytical Concept"),
                                                                                                                 "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                 "Assistant U. Code" = FIELD("Code U. Posting")));


            CaptionML = ENU = 'Aver. Cost Price Pend. Budget', ESP = 'Precio coste med. ppto. pend.';
            Description = 'Coste';
            Editable = false;
            AutoFormatType = 2;
            CaptionClass = '7206910,7207386,7';

            trigger OnValidate();
            BEGIN
                CheckClosed;

                //JAV 27/02/21: - QB 1.08.19 Calcular la K correctamente
                VALIDATE("Calculated K");
            END;


        }
        field(8; "Budget Measure"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter"),
                                                                                                                               "U. Posting Code" = FIELD("Code U. Posting")));
            CaptionML = ENU = 'Budget Measurement', ESP = 'Medici¢n ppto.';
            CaptionClass = '7206910,7207386,8';


        }
        field(9; "Type"; Option)
        {
            OptionMembers = "Piecework","Cost Unit","Investment Unit","Assistant Unit";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Piecework,Cost Unit,Investment Unit,Assistant Unit', ESP = 'Unidad de obra,Unidad de coste,Unidad de inversi¢n,Unidad Auxiliar';



        }
        field(10; "Total Measurement Production"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."Measure Term" WHERE("Job No." = FIELD("Job No."),
                                                                                                                     "Piecework No." = FIELD("Piecework Code"),
                                                                                                                     "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Total Measurement Production', ESP = 'Medici¢n producci¢n ejecutada';
            Description = 'QB 1.060.8 - JAV 02/08/20: - Se cambia el caption para que sea mas adecuado';
            Editable = false;
            CaptionClass = '7206910,7207386,10';


        }
        field(11; "Filter Date"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Filter Date', ESP = 'Filtro fecha';


        }
        field(12; "Type Unit Cost"; Option)
        {
            OptionMembers = "Internal","External";

            CaptionML = ENU = 'Type Unit Cost', ESP = 'Tipo unidad de coste';
            OptionCaptionML = ENU = 'Internal,External', ESP = 'Interno,Externo';

            Description = 'JMMA 031220 PRODUTE';
            Editable = true;

            trigger OnValidate();
            BEGIN
                CheckClosed;

                IF "Type Unit Cost" = "Type Unit Cost"::External THEN
                    "Subtype Cost" := "Subtype Cost"::" ";

                //JAV 06/10/20: - QB 1.06.18 Traspaso el c lculo de si la unidad es planificable a su validate y se llama desde mas lugares
                VALIDATE(Plannable);
            END;


        }
        field(13; "Planned Expense"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Periodification Unit Cost"."Period Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                      "Unit Cost" = FIELD("Piecework Code"),
                                                                                                                      "Date" = FIELD("Filter Date"),
                                                                                                                      "Cod. Budget" = FIELD("Budget Filter")));


            CaptionML = ENU = 'Planned Expense', ESP = 'Gasto planificado';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(14; "% Expense Cost"; Decimal)
        {


            CaptionML = ENU = '% Expense Cost', ESP = '% Coste de gasto';
            DecimalPlaces = 0 : 15;

            trigger OnValidate();
            BEGIN
                //JAV 18/05/22: - QB 1.10.43 Solo se procesa si ha cambiado el procentaje.
                IF (Rec."% Expense Cost" <> xRec."% Expense Cost") THEN BEGIN
                    CheckClosed;  //Se cambia el orden de la verificaci�n, primero se mira si puede hacerlo y luego el rec�lculo
                    IF Type = Type::"Cost Unit" THEN BEGIN
                        UpdateMeasurementByPercentage;
                        //JAV 18/05/22: - Recalculamos la U.O. porque han cambiado el porcentaje
                        CalculatePiecework;
                    END;
                END;
            END;


        }
        field(15; "Plannable"; Boolean)
        {


            CaptionML = ENU = 'Plannable', ESP = 'Planificable';

            trigger OnValidate();
            BEGIN
                //JAV 06/10/20: - QB 1.06.18 Traspaso el c lculo de si la unidad es planificable a su validate y se llama desde mas lugares
                IF (Type = Type::"Cost Unit") THEN
                    Plannable := (("Type Unit Cost" IN ["Type Unit Cost"::Internal, "Type Unit Cost"::External]) AND ("Allocation Terms" = "Allocation Terms"::"Fixed Amount"))
                ELSE
                    Plannable := TRUE;
            END;


        }
        field(16; "Budget Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Budget Filter', ESP = 'Filtro presupuesto';


        }
        field(17; "Amount Production Performed"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Prod. Measure Lines"."PROD Amount Term" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Piecework No." = FIELD("Piecework Code"),
                                                                                                                         "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                                         "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Amount Production Performed', ESP = 'Importe producci¢n realizada';
            Description = 'Coste   QB 1.08.48 -------------------------------- Cambiado JAV 04/06/21';
            Editable = false;
            AutoFormatType = 1;
            CaptionClass = '7206910,7207386,17';


        }
        field(18; "Amount Sale Performed (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Total Price" WHERE("Entry Type" = CONST("Sale"),
                                                                                                            "Job No." = FIELD("Job No."),
                                                                                                            "Piecework No." = FIELD("Piecework Code"),
                                                                                                            "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                            "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Amount Sale Performed (JC)', ESP = 'Importe venta realizado (DP)';
            Description = 'Venta';
            Editable = false;
            AutoFormatType = 1;


        }
        field(19; "Amount Cost Performed (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost" WHERE("Job No." = FIELD("Job No."),
                                                                                                          "Piecework No." = FIELD("Piecework Code"),
                                                                                                          "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                          "Entry Type" = CONST("Usage"),
                                                                                                          "Posting Date" = FIELD("Filter Date"),
                                                                                                          "Global Dimension 2 Code" = FIELD("Filter Analytical Concept")));
            CaptionML = ENU = 'Amount Cost Performed (JC)', ESP = 'Importe coste realizado (DP)';
            Description = 'JAV 10/04/20: - Estos campos son el la divisa del proyecto, no lo local';
            Editable = false;
            AutoFormatType = 1;


        }
        field(20; "Amount Cost Budget (JC)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD(FILTER("Budget Filter")),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date"))));


            CaptionML = ENU = 'Amount Cost Budget (JC)', ESP = 'Importe coste ppto. (DP)';
            Description = 'JAV 10/04/20: - Estos campos son el la divisa del proyecto, no lo local';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(21; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci¢n';


        }
        field(22; "% Expense Cost Amount Base"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe base c�clulo %';
            Description = 'JAV 17/05/22 QB 1.10.42 - [TT] Sobre que importe base se ha calculado el % de coste';
            Editable = false;


        }
        field(23; "Construction Cost"; Boolean)
        {
            CaptionML = ENU = 'Construction Cost', ESP = 'Coste construcci¢n';
            CaptionClass = '7206910,7207386,23';


        }
        field(24; "Measurement Budget MSP"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("TMP Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                   "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                                   "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                                   "Expected Date" = FIELD("Filter Date"),
                                                                                                                                   "Budget Code" = FIELD("Budget Filter")));
            CaptionML = ENU = 'Measurement Budget MSP', ESP = 'Medici¢n ppto. MSP';
            Editable = false;
            CaptionClass = '7206910,7207386,24';


        }
        field(25; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Global Dimension 1 Code', ESP = 'C¢d. dimensi¢n global 1';
            CaptionClass = '1,1,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                MODIFY;
            END;


        }
        field(26; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Global Dimension 2 Code', ESP = 'C¢d. dimensi¢n global 2';
            CaptionClass = '1,1,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
                MODIFY;
            END;


        }
        field(27; "Unit Of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit Of Measure', ESP = 'Unidad de medida';


        }
        field(28; "Blocked"; Boolean)
        {
            CaptionML = ENU = 'Blocked', ESP = 'Bloqueado';


        }
        field(29; "Last Modified Date"; Date)
        {
            CaptionML = ENU = 'Last Modified Date', ESP = 'Fecha £lt. modificaci¢n';
            Editable = false;


        }
        field(30; "Posting Group Unit Cost"; Code[20])
        {
            TableRelation = "Units Posting Group";
            CaptionML = ENU = 'Posting Group Unit Cost', ESP = 'Grupo contable unidad coste';


        }
        field(31; "Allocation Terms"; Option)
        {
            OptionMembers = "Fixed Amount","% on Production","% on Direct Costs";

            CaptionML = ENU = 'Allocation Terms', ESP = 'Modo de imputaci¢n';
            OptionCaptionML = ENU = 'Fixed Amount,% on Production,% on Direct Costs', ESP = 'Importe fijo,% sobre producci¢n,% sobre coste directos';


            trigger OnValidate();
            BEGIN
                CheckClosed;

                //JAV 06/10/20: - QB 1.06.18 Traspaso el c lculo de si la unidad es planificable a su validate y se llama desde mas lugares
                VALIDATE(Plannable);
            END;


        }
        field(32; "Additional Auto Text"; Boolean)
        {
            CaptionML = ENU = 'Additional Auto Text', ESP = 'Texto adicional autom tico';


        }
        field(34; "Initial Produc. Price"; Decimal)
        {


            CaptionML = ENU = 'Initial Produc. Price', ESP = 'Precio produc. inicial';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                // QUEREMOS QUE FACTOR SOBRE COSTE SE COMPORTE COMO UN % ADICIONAL AL PRECIO DE COSTE
                IF Type = Type::Piecework THEN BEGIN
                    CALCFIELDS("Aver. Cost Price Pend. Budget");
                END;
            END;


        }
        field(35; "% Of Margin"; Decimal)
        {


            CaptionML = ENU = '% Of Margin', ESP = '% Sobrecoste';
            Description = 'JAV 05/03/19 Cambio caption por otro mas adecuado';

            trigger OnValidate();
            BEGIN
                // QUEREMOS QUE FACTOR SOBRE COSTE SE COMPORTE COMO UN % ADICIONAL AL PRECIO DE COSTE
                GetCurrency;

                IF Type = Type::Piecework THEN BEGIN
                    CALCFIELDS("Aver. Cost Price Pend. Budget");
                    IF "% Of Margin" <> 0 THEN
                        "Initial Produc. Price" := ROUND("Aver. Cost Price Pend. Budget" * (1 + "% Of Margin" / 100),
                                                    Currency."Unit-Amount Rounding Precision")
                    ELSE BEGIN
                        "Initial Produc. Price" := "Aver. Cost Price Pend. Budget";
                    END;

                    IF "Initial Produc. Price" <> 0 THEN
                        "Gross Profit Percentage" :=
                             ROUND((("Initial Produc. Price" - "Aver. Cost Price Pend. Budget") / "Initial Produc. Price") * 100, 0.01)
                    ELSE
                        "Gross Profit Percentage" := 0;
                END ELSE BEGIN
                    "% Of Margin" := 0;
                    "Initial Produc. Price" := 0;
                END;
            END;


        }
        field(36; "Gross Profit Percentage"; Decimal)
        {
            CaptionML = ENU = 'Gross Profit Percentage', ESP = 'Porcentaje B. bruto';
            Editable = false;


        }
        field(37; "Periodic Cost"; Boolean)
        {
            CaptionML = ENU = 'Periodic Cost', ESP = 'Periodificable';


        }
        field(38; "Job Billing Structure"; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job Billing Structure', ESP = 'Proy. estructura facturaci¢n';

            trigger OnValidate();
            BEGIN
                IF "Job Billing Structure" <> '' THEN
                    ControlJob("Job Billing Structure");
            END;


        }
        field(39; "Analytical Concept Subcon Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Analytical Concept Subcon Code', ESP = 'C¢d. concepto anal¡tico subcon';
            CaptionClass = '1,1,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
                MODIFY;
            END;


        }
        field(40; "Record Type"; Option)
        {
            OptionMembers = " ","Contract","Reformed","Complementary","Settlement","Otr. Customers","Others","Contradictory Prices";

            CaptionML = ENU = 'Record Type', ESP = 'Tipo de expediente';
            OptionCaptionML = ENU = '" ,Contract,Reformed,Complementary,Settlement,Otr. Customers,Others,Contradictory Prices"', ESP = '" ,Contrato,Reformado,Complementario,Liquidaci¢n,Otr. clientes,Otros,Precios Contradictorios"';

            CaptionClass = '7206910,7207386,40';

            trigger OnValidate();
            BEGIN
                IF "Record Type" = "Record Type"::" " THEN
                    "% Processed Production" := 100;
            END;


        }
        field(41; "Record Status"; Option)
        {
            OptionMembers = "Management","Technical Approval","Approved";
            CaptionML = ENU = 'Record Status', ESP = 'Estado expediente';
            OptionCaptionML = ENU = 'Management,Technical Approval,Approved', ESP = 'Gesti¢n,Aprobaci¢n t‚cnica,Aprobado';

            CaptionClass = '7206910,7207386,41';


        }
        field(42; "% Processed Production"; Decimal)
        {
            InitValue = 100;
            CaptionML = ENU = '% Processed Production', ESP = '% producci¢n tramitada';
            MinValue = 0;
            MaxValue = 100;
            CaptionClass = '7206910,7207386,42';


        }
        field(43; "Desc. Piecework"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Piecework"."Description" WHERE("Cost Database Default" = FIELD("Code Cost Database"),
                                                                                                   "No." = FIELD("Piecework Code")));
            CaptionML = ENU = 'Desc. Piecework', ESP = 'Desc. unidad de obra';
            CaptionClass = '7206910,7207386,43';


        }
        field(44; "Code Cost Database"; Code[20])
        {
            TableRelation = "Cost Database";
            CaptionML = ENU = 'Code Cost Database', ESP = 'C¢d. preciario';


        }
        field(45; "Unique Code"; Code[30])
        {


            CaptionML = ENU = 'Unique Code', ESP = 'C¢digo £nico';
            Description = 'QB- Ampliado para importar m s niveles en BC3';

            trigger OnValidate();
            BEGIN
                //JAV 05/10/19: - En el validate del campo "Unique code" se monta el campo, as¡ es mas sencillo llamarlo desde otras partes

                //Al insertar una nueva U.O cargo el valor del c¢digo £nico para el enlace con los textos adicionales
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETCURRENTKEY("Job No.", "Unique Code");
                DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                DataPieceworkForProduction.SETFILTER("Unique Code", '%1..', COPYSTR("Job No.", 1, 16));
                IF DataPieceworkForProduction.FINDLAST THEN
                    "Unique Code" := INCSTR(DataPieceworkForProduction."Unique Code")
                ELSE
                    "Unique Code" := PADSTR(COPYSTR("Job No.", 1, 16), 20, '0');
            END;


        }
        field(46; "Account Type"; Option)
        {
            OptionMembers = "Unit","Heading";

            CaptionML = ENU = 'Account Type', ESP = 'Tipo mov.';
            OptionCaptionML = ENU = 'Unit,Heading', ESP = 'Unidad,Mayor';


            trigger OnValidate();
            BEGIN
                //JAV 05/10/19: Al establecer el tipo de cuenta se establece siempre el sumatorio
                VALIDATE(Totaling);

                //JAV 02/08/21: - Las unidades de mayor no tienen tipo asociado
                IF ("Account Type" = "Account Type"::Heading) THEN BEGIN
                    "QPR Type" := "QPR Type"::" ";
                    "QPR No." := '';
                    "QPR Name" := '';
                END;
            END;


        }
        field(47; "Indentation"; Integer)
        {
            CaptionML = ENU = 'Indentation', ESP = 'Indentar';
            MinValue = 0;
            Editable = true;


        }
        field(48; "Totaling"; Text[250])
        {


            CaptionML = ENU = 'Totaling', ESP = 'Sumatorio';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 05/03/19: - Por si no esta establecido y lo necesita, lo relleno
                //JAV 05/10/19: - Se establece simpre el valor adecuado
                IF ("Account Type" = "Account Type"::Heading) THEN
                    Totaling := "Piecework Code" + '..' + PADSTR("Piecework Code", 20, '9')
                ELSE
                    Totaling := '';
                //JAV
            END;


        }
        field(49; "Measure Budg. Piecework Sol"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter")));
            CaptionML = ENU = 'Measure Budg. Piecework', ESP = 'Medici¢n ppto. unidad obra';
            CaptionClass = '7206910,7207386,49';


        }
        field(50; "No. Subcontracting Resource"; Code[20])
        {
            TableRelation = "Resource";


            CaptionML = ENU = 'No. Subcontracting Resource', ESP = 'N§ recurso subcontrataci¢n';

            trigger OnValidate();
            BEGIN
                IF Resource.GET("No. Subcontracting Resource") THEN BEGIN
                    VALIDATE("Activity Code", Resource."Activity Code");
                    VALIDATE("Analytical Concept Subcon Code", Resource."Global Dimension 2 Code");
                    IF CostPrice <> 0 THEN
                        "Price Subcontracting Cost" := CostPrice;
                END;
            END;


        }
        field(51; "Measured Qty Subc. Piecework"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                       "Piecework NÂº" = FIELD("Piecework Code"),
                                                                                                       "Type" = CONST("Resource"),
                                                                                                       "No." = FIELD("No. Subcontracting Resource"),
                                                                                                       "Order Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Measured Qty Subc. Piecework', ESP = 'Cdad medida subcon U.O.';
            Editable = false;


        }
        field(52; "Certified Qty Subc. Piecework"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                      "Piecework No." = FIELD("Piecework Code"),
                                                                                                      "Type" = CONST("Resource"),
                                                                                                      "No." = FIELD("No. Subcontracting Resource"),
                                                                                                      "Expected Receipt Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Certified Qty Subc. Piecework', ESP = 'Cdad. certificada subcon U.O.';
            Editable = false;


        }
        field(53; "Certified Amt. Subc. Piecework"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                    "Piecework No." = FIELD("Piecework Code"),
                                                                                                    "Type" = CONST("Resource"),
                                                                                                    "No." = FIELD("No. Subcontracting Resource"),
                                                                                                    "Expected Receipt Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Certified Amt. Subc. PieceworkU', ESP = 'Importe certificado subcon U.O';
            Editable = false;
            AutoFormatType = 1;


        }
        field(54; "Quantity Paid Subcon Piecework"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Cr. Memo Line"."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                          "Piecework No." = FIELD("Piecework Code"),
                                                                                                          "Type" = CONST("Resource"),
                                                                                                          "No." = FIELD("No. Subcontracting Resource"),
                                                                                                          "Expected Receipt Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Quantity Paid Subcon Piecework', ESP = 'Cdad. abonada subcon U.O.';
            Editable = false;


        }
        field(55; "Amount Paid Subcon Piecework"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Cr. Memo Line"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                        "Piecework No." = FIELD("Piecework Code"),
                                                                                                        "Type" = CONST("Resource"),
                                                                                                        "No." = FIELD("No. Subcontracting Resource"),
                                                                                                        "Expected Receipt Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Amount Paid Subcon Piecework', ESP = 'Importe abonado subcon U.O.';
            Editable = false;
            AutoFormatType = 1;


        }
        field(56; "Reassuring"; Boolean)
        {
            CaptionML = ENU = 'Reassuring', ESP = 'Reestimable';


        }
        field(58; "Filter Analytical Concept"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Filter Analytical Concept', ESP = 'Filtro concepto anal¡tico';


        }
        field(59; "Title"; Code[20])
        {
            CaptionML = ENU = 'Title', ESP = 'T¡tulo';
            Description = 'De una partida informa de su U.O. de mayor relacioanda, de una U.O. de mayor es ella misma';


        }
        field(60; "No. Record"; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'No. Record', ESP = 'N§ expediente';
            CaptionClass = '7206910,7207386,60';

            trigger OnValidate();
            BEGIN
                IF "No. Record" <> '' THEN BEGIN
                    Records.GET("Job No.", "No. Record");
                    Records.TESTFIELD(Blocked, FALSE);
                    "Record Type" := Records."Record Type";
                    "Record Status" := Records."Record Status";
                    PieceworkSetup.GET();
                    CASE Records."Record Status" OF
                        Records."Record Status"::Management:
                            BEGIN
                                "% Processed Production" := PieceworkSetup."% Management Application";
                            END;
                        Records."Record Status"::"Technical Approval":
                            BEGIN
                                "% Processed Production" := PieceworkSetup."% Appl. Tecnique Approval";
                            END;
                        Records."Record Status"::Approved:
                            BEGIN
                                "% Processed Production" := 100;
                            END;
                    END;
                END;
            END;


        }
        field(61; "Price Subcontracting Cost"; Decimal)
        {
            CaptionML = ENU = 'Price Subcontracting Cost', ESP = 'Precio coste subcontrataci¢n';
            AutoFormatType = 2;


        }
        field(62; "Production Unit"; Boolean)
        {


            CaptionML = ENU = 'Production Unit', ESP = 'Unidad producci¢n';

            trigger OnValidate();
            BEGIN
                IF (NOT "Customer Certification Unit") AND
                   (NOT "Production Unit") THEN
                    ERROR(Text009);

                IF (xRec."Production Unit") AND (NOT "Production Unit") THEN
                    DeleteData(FALSE, TRUE);

                IF (NOT xRec."Production Unit") AND ("Production Unit") THEN BEGIN
                    VALIDATE("Budget Measure", "Sale Quantity (base)");
                    "Initial Produc. Price" := "Unit Price Sale (base)";
                END;

                IF Job.GET("Job No.") THEN;

                IF Type = Type::Piecework THEN
                    IF Job."Separation Job Unit/Cert. Unit" THEN
                        "Customer Certification Unit" := NOT "Production Unit"
                    ELSE
                        "Customer Certification Unit" := "Production Unit";
            END;


        }
        field(63; "Customer Certification Unit"; Boolean)
        {


            CaptionML = ENU = 'Customer Certification Unit', ESP = 'Unidad certificacion cliente';

            trigger OnValidate();
            BEGIN
                IF (NOT "Customer Certification Unit") AND
                   (NOT "Production Unit") THEN
                    ERROR(Text009);

                IF (NOT xRec."Customer Certification Unit") AND ("Customer Certification Unit") THEN
                    SpreadDataCertification;

                IF (xRec."Customer Certification Unit") AND (NOT "Customer Certification Unit") THEN
                    DeleteData(TRUE, FALSE);

                IF Job.GET("Job No.") THEN BEGIN
                    IF Type = Type::Piecework THEN
                        IF Job."Separation Job Unit/Cert. Unit" THEN
                            "Production Unit" := NOT "Customer Certification Unit"
                        ELSE
                            "Production Unit" := "Customer Certification Unit";
                END;
            END;


        }
        field(64; "Measure Performed Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter"),
                                                                                                                               "Performed" = CONST(true)));
            CaptionML = ENU = 'Measure Performed Budget', ESP = 'Medici¢n ppto. realizada';
            CaptionClass = '7206910,7207386,64';


        }
        field(65; "Amount Budget Cost Performed"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date")),
                                                                                                                  "Performed" = CONST(true)));
            CaptionML = ENU = 'Amount Budget Cost Performed', ESP = 'Importe ppto. coste realidado';
            Editable = false;
            AutoFormatType = 1;


        }
        field(66; "Amount Budget Cost Pending"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date")),
                                                                                                                  "Performed" = CONST(false)));
            CaptionML = ENU = 'Amount Budget Cost Pending', ESP = 'Importe ppto. coste pendiente';
            Editable = false;
            AutoFormatType = 1;


        }
        field(67; "Measure Pending Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter"),
                                                                                                                               "Performed" = CONST(false)));


            CaptionML = ENU = 'Measure Pending Budget', ESP = 'Medici¢n ppto. pendiente';

            trigger OnValidate();
            BEGIN
                CheckClosed;
                IF "Account Type" = "Account Type"::Heading THEN
                    "Measure Pending Budget" := 1;
            END;


        }
        field(68; "Amount Budg. Prod. Performed"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date")),
                                                                                                                  "Performed" = CONST(true)));
            CaptionML = ENU = 'Amount Budg. Prod. Performed', ESP = 'Importe ppto. prod. realizado';
            Editable = false;
            AutoFormatType = 1;


        }
        field(69; "Amount Budg. Prod. Pending"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Incomes"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date")),
                                                                                                                  "Performed" = CONST(false)));
            CaptionML = ENU = 'Amount Budg. Prod. Pending', ESP = 'Importe ppto. prod. pendiente';
            Editable = false;
            AutoFormatType = 1;


        }
        field(70; "Sale Quantity (base)"; Decimal)
        {


            CaptionML = ENU = 'Sale Quantity (base)', ESP = 'Cantidad de venta (base)';

            trigger OnValidate();
            VAR
                //                                                                 HistMeasureLines@1100286000 :
                HistMeasureLines: Record 7207339;
            BEGIN
                //JAV 14/01/22: - QB 1.10.10 Solo si tiene alguna medici�n se controla que no se cambie el dato por otro inferior a lo ejecutado
                HistMeasureLines.RESET;
                HistMeasureLines.SETCURRENTKEY("Job No.", "Piecework No.");
                HistMeasureLines.SETRANGE("Job No.", Rec."Job No.");
                HistMeasureLines.SETRANGE("Piecework No.", Rec."Piecework Code");
                IF (NOT HistMeasureLines.ISEMPTY) THEN BEGIN
                    //JAV 30/09/21: - QB 1.09.20 Verificar que la medici�n de venta no pueda ser menor de lo ya ejecutado
                    CALCFIELDS("Quantity in Measurements");
                    IF ("Sale Quantity (base)" < "Quantity in Measurements") THEN
                        ERROR('No puede reducir la cantidad en menos de la existente en mediciones registradas: %1', "Quantity in Measurements");
                END;
                //JAV fin

                CalculateAmount;

                UpdateRedet;
                UpdateBudgetCost(FIELDNO("Sales Amount (Base)"));
            END;


        }
        field(71; "Unit Price Sale (base)"; Decimal)
        {


            CaptionML = ENU = 'Unit Price Sale (base)', ESP = 'Precio unitario venta (base)';
            Description = 'JAV 29/01/20: Caption con el campo 31 de QB';
            Editable = false;
            AutoFormatType = 2;
            CaptionClass = '7206910,7207386,71';

            trigger OnValidate();
            BEGIN
                IF "Account Type" = "Account Type"::Heading THEN
                    "Unit Price Sale (base)" := 0;

                "Last Unit Price Redetermined" := "Unit Price Sale (base)";
                CalculateAmount;
                UpdateRedet;
                UpdateBudgetCost(FIELDNO("Unit Price Sale (base)"));
            END;


        }
        field(72; "Sale Amount"; Decimal)
        {
            CaptionML = ENU = 'Sale Amount', ESP = 'Importe venta';
            Editable = false;
            AutoFormatType = 1;


        }
        field(73; "Code Cost Database Certif."; Code[20])
        {
            CaptionML = ENU = 'Code Cost Database Certif.', ESP = 'C¢d. preciario certificaci¢n';
            Editable = false;


        }
        field(74; "Quantity in Measurements"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Measure Lines"."Med. Term Measure" WHERE("Job No." = FIELD("Job No."),
                                                                                                                    "Piecework No." = FIELD("Piecework Code"),
                                                                                                                    "Piecework No." = FIELD(FILTER("Totaling"))));
            CaptionML = ENU = 'Qty. in Measurements', ESP = 'Cantidad en mediciones';
            Editable = false;


        }
        field(75; "Certified Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Cert Quantity to Term" WHERE("Job No." = FIELD("Job No."),
                                                                                                                              "Piecework No." = FIELD("Piecework Code"),
                                                                                                                              "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                                              "Certification Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Certified Quantity', ESP = 'Cantidad certificada';
            Description = 'QB 1.11.02 JAV 15/09/22: - Se cambia el caption err�neo';
            Editable = false;


        }
        field(76; "Invoiced Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Invoiced Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                                          "Piecework No." = FIELD("Piecework Code"),
                                                                                                                          "Piecework No." = FIELD(FILTER("Totaling"))));
            CaptionML = ENU = 'Invoiced Amount', ESP = 'Cantidad facturada';
            Description = 'QB 1.11.02 JAV 15/09/22: - Se cambia Name que era err�neo';
            Editable = false;


        }
        field(77; "Cumulative Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Piecework For Production"."Sales Amount (Base)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'Cumulative Amount', ESP = 'Cantidad acumulada';
            Editable = false;


        }
        field(78; "Accumulated Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Piecework For Production"."Sale Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                        "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                        "Piecework Code" = FIELD(FILTER("Totaling"))));


            CaptionML = ENU = 'Accumulated Amount', ESP = 'Importe acumulado';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                VALIDATE("Sales Amount (Base)", "Accumulated Amount");
            END;


        }
        field(79; "Additional Text Code"; Code[20])
        {
            CaptionML = ENU = 'Additional Text Code', ESP = 'C¢d. U.O. Adicional';
            Description = 'QB 1.06.04 JAV 21/07/20: - Se cambia el caption del campo, este campo es de libre uso en la empresa, no se debe tratar.';


        }
        field(80; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";


            CaptionML = ENU = 'Activity Code', ESP = 'C¢d. actividad';

            trigger OnValidate();
            BEGIN
                //JAV 03/02/19: - Si ponemos actividad en una l¡nea de mayor, la ponemos en todo lo que cuelga de este
                IF ("Account Type" = "Account Type"::Heading) THEN BEGIN
                    VALIDATE(Totaling);  //JAV Si no tiene bien el filtro de totales marco todos los registros
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                    DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
                    IF (DataPieceworkForProduction.FINDSET) THEN
                        REPEAT
                            IF (DataPieceworkForProduction."Piecework Code" <> "Piecework Code") AND (DataPieceworkForProduction."Activity Code" <> "Activity Code") THEN BEGIN
                                DataPieceworkForProduction."Activity Code" := "Activity Code";
                                DataPieceworkForProduction.MODIFY(FALSE);

                                DataCostByPiecework.RESET;
                                DataCostByPiecework.SETRANGE("Job No.", "Job No.");
                                DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                                DataCostByPiecework.SETRANGE("Cod. Budget", GETFILTER(Rec."Budget Filter"));
                                IF (DataCostByPiecework.FINDSET) THEN
                                    REPEAT
                                        DataCostByPiecework.VALIDATE("Activity Code", "Activity Code");
                                        DataCostByPiecework.MODIFY(FALSE);
                                    UNTIL (DataCostByPiecework.NEXT = 0);
                            END;
                        UNTIL (DataPieceworkForProduction.NEXT = 0);
                END ELSE BEGIN
                    DataCostByPiecework.RESET;
                    DataCostByPiecework.SETRANGE("Job No.", "Job No.");
                    DataCostByPiecework.SETRANGE("Piecework Code", "Piecework Code");
                    DataCostByPiecework.SETRANGE("Cod. Budget", GETFILTER(Rec."Budget Filter"));
                    IF (DataCostByPiecework.FINDSET) THEN
                        REPEAT
                            DataCostByPiecework.VALIDATE("Activity Code", "Activity Code");
                            DataCostByPiecework.MODIFY(FALSE);
                        UNTIL (DataCostByPiecework.NEXT = 0);
                END;
            END;


        }
        field(81; "Rental Unit"; Boolean)
        {
            CaptionML = ENU = 'Rental Unit', ESP = 'Unidad de alquiler';


        }
        field(82; "Element Of Rent"; Code[20])
        {
            TableRelation = "Rental Elements"."No.";
            CaptionML = ENU = 'Element Of Rent', ESP = 'Elemento de alquiler';


        }
        field(83; "Analytical Concept Rent"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Analytical Concept Rent', ESP = 'Concepto anal¡tico alquiler';

            trigger OnValidate();
            BEGIN
                // ver concepto analit.
                IF FunctionQB.AccessToQuobuilding THEN
                    FunctionQB.ValidateCA("Analytical Concept Rent");
            END;

            trigger OnLookup();
            BEGIN
                //ver concepto analit.
                FunctionQB.LookUpCA("Analytical Concept Rent", FALSE);
            END;


        }
        field(84; "Unit Cost Element/Time"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost Element/Time', ESP = 'Coste Unitario elemento/tiempo';
            DecimalPlaces = 2 : 4;
            AutoFormatType = 2;


        }
        field(85; "Number of Element"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Planning Information"."Number Of Items" WHERE("Job No." = FIELD("Job No."),
                                                                                                                          "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                          "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                          "Expected Date" = FIELD("Filter Date"),
                                                                                                                          "Budget Code" = FIELD("Budget Filter")));
            CaptionML = ENU = 'Number of Element', ESP = 'Cantidad elementos';


        }
        field(86; "Total Number Of Items"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Planning Information"."Number Of Items" WHERE("Job No." = FIELD("Job No."),
                                                                                                                          "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                          "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                          "Budget Code" = FIELD("Budget Filter")));
            CaptionML = ENU = 'Total Number Of Items', ESP = 'Total cantidad elementos';


        }
        field(87; "Rental Variant"; Code[10])
        {
            TableRelation = "Rental Variant";
            CaptionML = ENU = 'Rental Variant', ESP = 'Variante alquiler';


        }
        field(88; "Contract/Order Qty."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                   "Piecework No." = FIELD("Piecework Code"),
                                                                                                   "No." = FIELD("No. Subcontracting Resource")));
            CaptionML = ENU = 'Contract/Order Qty.', ESP = 'Cant. en contrato/pedido';
            Editable = false;


        }
        field(89; "Contract/Order Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                 "Piecework No." = FIELD("Piecework Code"),
                                                                                                 "No." = FIELD("No. Subcontracting Resource")));
            CaptionML = ENU = 'Contract/Order Amount', ESP = 'Importe contratado/pedido';
            Editable = false;
            AutoFormatType = 1;


        }
        field(90; "Contract Price"; Decimal)
        {


            CaptionML = ENU = 'Contract Price', ESP = 'Precio contrato';
            Description = 'JAV 29/01/20: Caption con el campo 30 de QB';
            CaptionClass = '7206910,7207386,90';

            trigger OnValidate();
            VAR
                //                                                                 LCertUnitRedetermination@7001100 :
                LCertUnitRedetermination: Record 7207438;
            BEGIN
                IF "Contract Price" <> xRec."Contract Price" THEN BEGIN
                    LCertUnitRedetermination.SETRANGE("Job No.", "Job No.");
                    LCertUnitRedetermination.SETRANGE(Validated, TRUE);
                    LCertUnitRedetermination.SETRANGE("Piecework Code", "Piecework Code");
                    IF LCertUnitRedetermination.FINDFIRST THEN
                        ERROR(Text022);
                END;


                GetCurrency;
                Job.GET("Job No.");
                IF "Account Type" = "Account Type"::Unit THEN
                    "Unit Price Sale (base)" := ROUND(("Contract Price" * (1 + (Job."General Expenses / Other" / 100) + (Job."Industrial Benefit" / 100)) *
                                                                        (1 - (Job."Low Coefficient" / 100)) *
                                                                        (1 + (Job."Quality Deduction" / 100)))
                                                                        , Currency."Unit-Amount Rounding Precision");//JMMA SE CAMBIA EL SIGNO DE QUALITY DEDUCTION

                VALIDATE("Unit Price Sale (base)");

                IF "Account Type" = "Account Type"::Heading THEN
                    "Contract Price" := 0;

                //JAV 27/02/21: - QB 1.08.19 Calcular la K correctamente
                VALIDATE("Calculated K");
            END;


        }
        field(91; "% Assigned To Sale"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rel. Certification/Product."."Assignment Cost Percentage" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                     "Production Unit Code" = FIELD("Piecework Code")));
            CaptionML = ENU = '% Assigned To Production', ESP = '% Asignado a venta';
            DecimalPlaces = 0 : 6;
            Description = 'JAV 30/10/20: QB 1.07.03 Porcentaje de venta asociado a la producci¢n';
            Editable = false;


        }
        field(93; "Certified Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Cert Term PEC amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                             "Piecework No." = FIELD("Piecework Code"),
                                                                                                                             "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                                             "Certification Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Certified Amount', ESP = 'Importe certificado';
            Description = 'CSM 11/07/23  PAT 02/05/23 Q19256 "Importe certificado" erroneo en An�lisis Certificaci�n';
            Editable = false;


        }
        field(94; "% Assigned To Production"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rel. Certification/Product."."Percentage Of Assignment" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                   "Certification Unit Code" = FIELD("Piecework Code")));
            CaptionML = ENU = '% Assigned To Production', ESP = '% Asignado a producci¢n';
            DecimalPlaces = 0 : 6;
            Editable = false;
            CaptionClass = '7206910,7207386,94';


        }
        field(95; "% Cost Asign.Sale"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rel. Certification/Product."."Assignment Cost Percentage" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                     "Production Unit Code" = FIELD("Piecework Code")));
            CaptionML = ENU = '% Cost Asign. Sale', ESP = '% Coste asign. venta';
            DecimalPlaces = 0 : 6;
            Editable = false;


        }
        field(96; "Subtype Cost"; Option)
        {
            OptionMembers = " ","Deprec. Anticipated","Current Expenses","Deprec. Inmovilized","Deprec. Deferred","Financial Charges","Others";
            CaptionML = ENU = 'Subtype Cost', ESP = 'Subtipo coste';
            OptionCaptionML = ENU = '" ,Deprec. Anticipated,Current Expenses,Deprec. Inmovilized,Deprec. Deferred,Financial Charges,Others"', ESP = '" ,Amort. Anticipados,Gastos Corrientes,Amort. Inmovilizado,Amort. Diferidos,Cargas financieras,Otros"';



        }
        field(97; "Amount Cost Incurred W/C (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                                "Entry Type" = CONST("Usage"),
                                                                                                                "Posting Date" = FIELD("Filter Date"),
                                                                                                                "Global Dimension 2 Code" = FIELD("Filter Analytical Concept"),
                                                                                                                "Movement of Closing of Job" = CONST(false)));
            CaptionML = ENU = 'Amount Cost Incurred W/o Clos.', ESP = 'Imp coste realizado sin cierre (DL)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(98; "Amount Invest. Performed"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Posting Date" = FIELD("Filter Date"),
                                                                                                                "Plant Depreciation Sheet" = CONST(false)));
            CaptionML = ENU = 'Amount Invest. Performed', ESP = 'Importe invers. realizada';


        }
        field(99; "Amount Invest. Depreciated"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Posting Date" = FIELD("Filter Date"),
                                                                                                                "Plant Depreciation Sheet" = CONST(true)));
            CaptionML = ENU = 'Amount Invest. Depreciated', ESP = 'Importe invers. amortizada';


        }
        field(100; "OLD_Budget Planned Measure"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("TMP Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                   "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                                   "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                                   "Expected Date" = FIELD("Filter Date"),
                                                                                                                                   "Budget Code" = FIELD("Budget Filter")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Budget Planned Measure', ESP = 'Medici¢n ppto. planificada';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(101; "OLD_Amount Cost Planned Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("TMP Expected Time Unit Data"."Expected Cost Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Amount Cost Planned Budget', ESP = 'Importe coste ppto planificada';
            Description = '### ELIMINAR ### no se usa';


        }
        field(102; "OLD_Am.Product. Planned Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("TMP Expected Time Unit Data"."Expected Production Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                     "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                                     "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                                     "Expected Date" = FIELD("Filter Date"),
                                                                                                                                     "Budget Code" = FIELD("Budget Filter")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Amount Produc. Planned Budget', ESP = 'Importe produc. ppto planifica';
            Description = '### ELIMINAR ### no se usa';


        }
        field(103; "Amount Sale Contract"; Decimal)
        {
            CaptionML = ENU = 'Amount Sale Contract', ESP = 'Importe venta contrato';
            Description = 'QB 1.07.12 - JAV 15/12/20: - Se a¤ade entre los captions variables';
            Editable = false;
            CaptionClass = '7206910,7207386,103';


        }
        field(104; "Accumulated Amount Contract"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Piecework For Production"."Amount Sale Contract" WHERE("Job No." = FIELD("Job No."),
                                                                                                                                 "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                                 "Piecework Code" = FIELD(FILTER("Totaling"))));
            CaptionML = ENU = 'Accumulated Amount Contract', ESP = 'Importe acumulado Contrato';
            Editable = false;
            AutoFormatType = 1;


        }
        field(105; "OLD_Percentage Planned Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("TMP Expected Time Unit Data"."Expected Percentage" WHERE("Job No." = FIELD("Job No."),
                                                                                                                              "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                              "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                              "Expected Date" = FIELD("Filter Date"),
                                                                                                                              "Budget Code" = FIELD("Budget Filter")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Percentage Planned Budget', ESP = 'Porcentaje ppto planifica';
            Description = '### ELIMINAR ### no se usa';


        }
        field(106; "Relationship Valued By Income"; Boolean)
        {
            CaptionML = ENU = 'Relationship Valued By Income', ESP = 'Relacion valorada por ingresos';


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C¢d. U.O PRESTO';
            CaptionClass = '7206910,7207386,107';


        }
        field(108; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro IVA prod.';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(109; "Code U. Posting"; Code[20])
        {


            CaptionML = ENU = 'Code U. Posting', ESP = 'Cod. U. auxiliar';

            trigger OnValidate();
            BEGIN

                IF (Type <> Type::"Assistant Unit") AND ("Code U. Posting" <> '') THEN
                    ERROR(Text021, FIELDCAPTION("Code U. Posting"), FIELDCAPTION(Type), Text019);
            END;


        }
        field(110; "OLD_Code Piecework level 0"; Text[20])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya nose usa';
            CaptionML = ENU = 'Code Piecework level 0', ESP = 'Cod. ud obra nivel 0';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(111; "OLD_Code Piecework level 1"; Text[20])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Code Piecework level 1', ESP = 'Cod. ud obra nivel 1';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(112; "OLD_Code Piecework level 2"; Text[20])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Code Piecework level 2', ESP = 'Cod. ud obra nivel 2';
            Description = '### ELIMINAR ### no se usa';
            Editable = false;


        }
        field(113; "Amount Cost Budget Planning"; Decimal)
        {
            CaptionML = ENU = 'Amount Cost Budget Planning', ESP = 'Importe coste ppto. ordenaci¢n';


        }
        field(114; "Increased Amount Of Redeterm."; Decimal)
        {
            CaptionML = ENU = 'Increased Amount Of Redeterm.', ESP = 'Importe increm. redeterminaciones';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(115; "Sales Amount (Base)"; Decimal)
        {


            CaptionML = ENU = 'Sales Amount (Base)', ESP = 'Importe Medici¢n venta';
            Description = 'QB 1.07.12 - JAV 15/12/20: - Se a¤ade entre los captions variables';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;
            CaptionClass = '7206910,7207386,115';

            trigger OnValidate();
            BEGIN
                IF "Account Type" = "Account Type"::Heading THEN
                    "Sales Amount (Base)" := 0;
            END;


        }
        field(116; "Last Unit Price Redetermined"; Decimal)
        {
            CaptionML = ENU = 'Last Unit Price Redetermined', ESP = 'Ultimo precio venta redeterminado';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrency;


        }
        field(117; "Certification Amount (Base)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Certification Lines"."Cert Term PEC amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                             "Piecework No." = FIELD("Piecework Code"),
                                                                                                                             "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                                             "Certification Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Certification Amount (Base)', ESP = 'Importe certificaci¢n (base)';
            Description = 'Venta  QB 1.08.48 -------------------------------- Cambiado JAV 04/06/21';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(118; "OLD_Item Type"; Option)
        {
            OptionMembers = " ","General","Low";
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Item Type', ESP = 'Tipo de partida';
            OptionCaptionML = ENU = '"  ,General,Low"', ESP = '" ,General,Baja"';

            Description = '### ELIMINAR ### No se usa';


        }
        field(119; "OLD_% On Executing"; Decimal)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = '% On Executing', ESP = '% Sobre ejecuci¢n';
            DecimalPlaces = 2 : 6;
            Description = '### ELIMINAR ### No se usa';


        }
        field(120; "Measure Pending Budget New"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter")));
            CaptionML = ENU = 'Measure Pending Budget New', ESP = 'Medici¢n ppto. pendiente nuevo';
            CaptionClass = '7206910,7207386,120';


        }
        field(121; "Budget Measure New"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Expected Date" = FIELD("Filter Date"),
                                                                                                                               "Budget Code" = FIELD("Budget Filter")));
            CaptionML = ENU = 'Budget Measure New', ESP = 'Medici¢n ppto. nueva';
            CaptionClass = '7206910,7207386,121';


        }
        field(122; "Amount Cost Budget New"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Cod. Budget" = FIELD("Budget Filter"),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date"))));
            CaptionML = ENU = 'Amount Cost Budget New', ESP = 'Importe coste presupuesto nuevo';
            Editable = false;


        }
        field(124; "No. DP Cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Data Cost By Piecework" WHERE("Job No." = FIELD("Job No."),
                                                                                                     "Piecework Code" = FIELD("Piecework Code"),
                                                                                                     "Use" = CONST("Cost"),
                                                                                                     "Cod. Budget" = FIELD("Budget Filter")));
            CaptionML = ESP = 'N§ Descompuestos coste';
            Description = 'QB 1.06.07 - JAV 24/04/20: - Cuantas l¡neas de descompuestos de coste tiene';


        }
        field(125; "No. DP Sale"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Data Cost By Piecework Cert." WHERE("Job No." = FIELD("Job No."),
                                                                                                           "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ESP = 'N§ Descompuestos venta';
            Description = 'QB 1.06.07 - JAV 24/04/20: - Cuantas l¡neas de descompuestos de venta tiene';


        }
        field(126; "No. Medition detail Cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measurement Lin. Piecew. Prod." WHERE("Job No." = FIELD("Job No."),
                                                                                                             "Piecework Code" = FIELD("Piecework Code"),
                                                                                                             "Code Budget" = FIELD("Budget Filter")));
            CaptionML = ENU = 'No. Medition detail lines', ESP = 'N§ lineas Medici¢n Coste';
            Description = 'QB 1.06.07 - JAV 11/03/19 Cantidad de l¡neas de medici¢n que tiene';
            Editable = false;
            CaptionClass = '7206910,7207386,126';


        }
        field(127; "No. Medition detail Sales"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measure Line Piecework Certif." WHERE("Job No." = FIELD("Job No."),
                                                                                                             "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'No. Medition detail lines', ESP = 'N§ lineas Medici¢n Venta';
            Description = 'QB 1.06.07 - JAV 11/03/19 Cantidad de l¡neas de medici¢n que tiene';
            Editable = false;
            CaptionClass = '7206910,7207386,127';


        }
        field(128; "Aditional Text"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Text");
            CaptionML = ENU = 'No. Piecework with Aditional Text', ESP = 'Texto adicional';
            Description = 'QB 1.06.07 - JAV 11/03/19 Si posee textos adicionales';
            Editable = false;


        }
        field(130; "Initial Measure"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici¢n inicial';
            Description = 'QB 1.06.08 JAV 07/08/20: - Para guardar la medici¢n inicial de la U.O. antes de aumentarlo ----------------------- OJO este campo debe desaparecer cuando se ajuste en los clientes el uso correcto de los presupuestos';
            Editable = false;

            trigger OnValidate();
            BEGIN
                IF ("Initial Measure" = 0) THEN BEGIN
                    CALCFIELDS("Measure Budg. Piecework Sol");
                    "Initial Measure" := "Measure Budg. Piecework Sol";
                    IF ("Production Unit") AND (NOT "Customer Certification Unit") THEN
                        "Initial Price" := ProductionPrice
                    ELSE
                        "Initial Price" := "Contract Price";
                    "Initial Amount" := ROUND("Initial Measure" * "Initial Price", 0.01);
                END;
            END;


        }
        field(131; "Initial Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Inicial';
            Description = 'QB 1.06.08 JAV 07/08/20: - Para guardar la el precio inicial de la U.O. antes de aumentar la medici¢n ------------ OJO este campo debe desaparecer cuando se ajuste en los clientes el uso correcto de los presupuestos';
            Editable = false;


        }
        field(132; "Initial Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Prod. Inicial';
            Description = 'QB 1.06.08 JAV 07/08/20: - Para guardar cantidad por precio inicial de la U.O. antes de aumentar la medici¢n --- OJO este campo debe desaparecer cuando se ajuste en los clientes el uso correcto de los presupuestos';
            Editable = false;


        }
        field(133; "Initial Budget Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Budget Filter', ESP = 'Filtro presupuesto Inicial';
            Description = 'QB 1.06.11 JAV 26/08/20: - Para filtrar por el presupuesto inicial de la U.O.';


        }
        field(134; "Initial Budget Measure"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Expected Time Unit Data"."Expected Measured Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                                               "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                               "Expected Date" = FIELD(FILTER("Filter Date")),
                                                                                                                               "Budget Code" = FIELD(FILTER("Initial Budget Filter"))));


            CaptionML = ESP = 'Medici¢n Presupuesto inicial';
            Description = 'QB 1.06.11 JAV 26/08/20: - Presenta la medici¢n del presupuesto inicial de la U.O.';
            Editable = false;
            CaptionClass = '7206910,7207386,134';

            trigger OnValidate();
            BEGIN
                IF ("Initial Measure" = 0) THEN BEGIN
                    CALCFIELDS("Measure Budg. Piecework Sol");
                    "Initial Measure" := "Measure Budg. Piecework Sol";
                    IF ("Production Unit") AND (NOT "Customer Certification Unit") THEN
                        "Initial Price" := ProductionPrice
                    ELSE
                        "Initial Price" := "Contract Price";
                    "Initial Amount" := ROUND("Initial Measure" * "Initial Price", 0.01);
                END;
            END;


        }
        field(135; "Initial Budget Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Data Cost By Piecework"."Budget Cost" WHERE("Job No." = FIELD("Job No."),
                                                                                                                 "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                 "Analytical Concept Direct Cost" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                 "Cod. Budget" = FIELD(FILTER("Initial Budget Filter")),
                                                                                                                 "Assistant U. Code" = FIELD("Code U. Posting")));
            CaptionML = ESP = 'Precio Presupuesto Inicial';
            Description = 'QB 1.06.11 JAV 26/08/20: - Presentar el precio del presupuesto inicial de la U.O.';
            Editable = false;


        }
        field(140; "Grouping Code"; Code[20])
        {
            TableRelation = "QB Grouping Code"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Grouping Code', ESP = 'C¢d. Agrupaci¢n';
            Description = 'Q13152';


        }
        field(197; "Amount Cost Performed (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Piecework No." = FIELD(FILTER("Totaling")),
                                                                                                                "Entry Type" = CONST("Usage"),
                                                                                                                "Posting Date" = FIELD("Filter Date"),
                                                                                                                "Global Dimension 2 Code" = FIELD("Filter Analytical Concept")));
            CaptionML = ENU = 'Amount Cost Performed (LCY)', ESP = 'Importe coste realizado (DL)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(198; "Amount Cost Budget (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (LCY)" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                          "Job No." = FIELD("Job No."),
                                                                                                                          "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                          "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                          "Cod. Budget" = FIELD(FILTER("Budget Filter")),
                                                                                                                          "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                          "Expected Date" = FIELD(FILTER("Filter Date"))));


            CaptionML = ENU = 'Amount Cost Budget (LCY)', ESP = 'Importe coste ppto. (DL)';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                CheckClosed;
                //Q8163 >>
                VALIDATE("Calculated K");
                //Q8163 <<
            END;


        }
        field(199; "Amount Cost Budget (ACY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount (ACY)" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                          "Job No." = FIELD("Job No."),
                                                                                                                          "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                          "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                          "Cod. Budget" = FIELD(FILTER("Budget Filter")),
                                                                                                                          "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                          "Expected Date" = FIELD(FILTER("Filter Date"))));


            CaptionML = ENU = 'Amount Cost Budget (ACY)', ESP = 'Importe coste ppto. (DA)';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(200; "Unit Price Sale (base) (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Price Sale (base) (LCY)', ESP = 'Precio unitario venta (base) (DL)';
            Description = 'Q7664';
            Editable = false;
            AutoFormatType = 2;


        }
        field(201; "Sale Amount (LCY)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sale Amount (LCY)', ESP = 'Importe venta (DL)';
            Description = 'Q7664';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                //Q8163 >>
                VALIDATE("Calculated K");
                //Q8163 <<
            END;


        }
        field(202; "Contract Price (LCY)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract Price (LCY)', ESP = 'Precio contrato (DL)';
            Description = 'Q7664';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 LCertUnitRedetermination@7001100 :
                LCertUnitRedetermination: Record 7207438;
            BEGIN
            END;


        }
        field(203; "Unit Price Sale (base) (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Unit Price Sale (base) (ACY)', ESP = 'Precio unitario venta (base) (DR)';
            Description = 'Q7664';
            Editable = false;
            AutoFormatType = 2;


        }
        field(204; "Sale Amount (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sale Amount (ACY)', ESP = 'Importe venta (DR)';
            Description = 'Q7664';
            Editable = false;
            AutoFormatType = 1;


        }
        field(205; "Contract Price (ACY)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract Price (ACY)', ESP = 'Precio contrato (DR)';
            Description = 'Q7664';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 LCertUnitRedetermination@7001100 :
                LCertUnitRedetermination: Record 7207438;
            BEGIN
            END;


        }
        field(206; "Contract Price (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Contract Price', ESP = 'Precio contrato (DP)';
            Description = 'Q7664 MOD02';


        }
        field(209; "Actual Cost (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Entry Type" = CONST("Usage"),
                                                                                                                "Posting Date" = FIELD("Filter Date"),
                                                                                                                "Global Dimension 2 Code" = FIELD("Filter Analytical Concept")));
            CaptionML = ENU = 'Actual Cost LCY', ESP = 'Total Coste (DL)';
            Editable = false;


        }
        field(500; "Amount Cost Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Piecework Code" = FIELD("Piecework Code"),
                                                                                                                  "Piecework Code" = FIELD(FILTER("Totaling")),
                                                                                                                  "Cod. Budget" = FIELD(FILTER("Budget Filter")),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date"))));
            CaptionML = ENU = 'Amount Cost Budget', ESP = 'Importe coste ppto.';
            Description = 'EST003 - REVISAR!';
            Editable = false;
            AutoFormatType = 1;


        }
        field(510; "Over JV Production"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Over JV Production', ESP = 'Sobre prod. UTE';
            Description = 'JMMA 031220 PRODUTE';


        }
        field(600; "QPR Type"; Option)
        {
            OptionMembers = " ","Account","Resource","Item","Budget","BCompany";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cost Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,Account,Resource,Item,Budget,Budget in other Company"', ESP = '" ,Cuenta,Recurso,Producto,Presupuesto,Presupuesto de otra Empresa"';


            trigger OnValidate();
            VAR
                //                                                                 QPRAmounts@1100286000 :
                QPRAmounts: Record 7207383;
            BEGIN
                CheckClosed;
                //Si cambia el tipo, no podemos mantener estos datos
                IF ("QPR Type" <> xRec."QPR Type") THEN BEGIN
                    "QPR No." := '';
                    "QPR Company" := '';
                    "QPR Name" := '';
                END;
                //Para este tipo no podemos tener company
                IF ("QPR Type" <> "QPR Type"::BCompany) THEN
                    "QPR Company" := '';
            END;


        }
        field(601; "QPR Company"; Text[30])
        {
            TableRelation = "Company";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company', ESP = 'Empresa';

            trigger OnValidate();
            VAR
                //                                                                 Company@1100286005 :
                Company: Record 2000000006;
            BEGIN
                CheckClosed;
                IF ("QPR Type" <> "QPR Type"::BCompany) THEN
                    "QPR Company" := ''
                ELSE BEGIN
                    IF ("QPR Company" = COMPANYNAME) THEN
                        ERROR('No puede usar al empresa actual');
                    IF ("QPR Company" = '') THEN
                        ERROR('Debe seleccionar una empresa.');
                    IF (NOT Company.GET("QPR Company")) THEN
                        ERROR('Debe seleccionar una empresa existente.');
                END;
            END;


        }
        field(602; "QPR No."; Code[20])
        {
            TableRelation = IF ("QPR Type" = CONST("Account")) "G/L Account" ELSE IF ("QPR Type" = CONST("Resource")) Resource ELSE IF ("QPR Type" = CONST("Item")) Item ELSE IF ("QPR Type" = CONST("Budget")) Job WHERE("Card Type" = CONST("Presupuesto"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N§';

            trigger OnValidate();
            VAR
                //                                                                 GLAccount@1100286000 :
                GLAccount: Record 15;
                //                                                                 Item@1100286001 :
                Item: Record 27;
                //                                                                 Resource@1100286002 :
                Resource: Record 156;
                //                                                                 lJob@1100286003 :
                lJob: Record 167;
                //                                                                 lJobBudget@1100286004 :
                lJobBudget: Record 7207407;
                //                                                                 QPRAmounts@1100286005 :
                QPRAmounts: Record 7207383;
                //                                                                 QPRBudgetsProcesing@1100286008 :
                QPRBudgetsProcesing: Codeunit 7206930;
                //                                                                 sCos@1100286006 :
                sCos: Decimal;
                //                                                                 sIng@1100286007 :
                sIng: Decimal;
            BEGIN
                CheckClosed;

                "QPR Name" := '';
                CASE "QPR Type" OF
                    "QPR Type"::Account:
                        BEGIN
                            GLAccount.GET("QPR No.");
                            "QPR Name" := GLAccount.Name;
                        END;

                    "QPR Type"::Resource:
                        BEGIN
                            Resource.GET("QPR No.");
                            IF (Resource.Type IN [Resource.Type::Person, Resource.Type::ExternalWorker]) THEN
                                ERROR(Text606);
                            "QPR Name" := Resource.Name;
                        END;

                    "QPR Type"::Item:
                        BEGIN
                            Item.GET("QPR No.");
                            "QPR Name" := Item.Description;
                        END;

                    "QPR Type"::Budget:
                        BEGIN
                            IF ("QPR No." = "Job No.") THEN
                                ERROR('No puede usar su mismo presupuesto');

                            QPRBudgetsProcesing.SetAmounts(COMPANYNAME, "QPR No.", QPRGetBudget, COMPANYNAME, Rec);
                        END;

                    "QPR Type"::BCompany:
                        BEGIN
                            VALIDATE("QPR Company");

                            QPRBudgetsProcesing.SetAmounts("QPR Company", "QPR No.", QPRGetBudget, COMPANYNAME, Rec);
                        END;
                END;
            END;


        }
        field(603; "QPR Name"; Text[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'Nombre';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 GLAccount@1100286000 :
                GLAccount: Record 15;
            BEGIN
            END;


        }
        field(604; "QPR Last Date Updated"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Date Updated', ESP = '�ltima Fecha Actualizaci¢n';
            Description = '�ltima fecha en que se ha actualziado el importe del presupuesto';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 GLAccount@1100286000 :
                GLAccount: Record 15;
            BEGIN
            END;


        }
        field(605; "QPR Use"; Option)
        {
            OptionMembers = " ","Gasto","Ingreso";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Uso';
            OptionCaptionML = ENU = '" ,Cost,Sale"', ESP = '" ,Gasto,Ingreso"';



        }
        field(606; "QPR AC"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto anal�tico';


        }
        field(607; "QPR Gen Prod. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro de prod.';


        }
        field(608; "QPR Gen Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro general';


        }
        field(609; "QPR VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro IVA prod.';


        }
        field(610; "QPR Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Cuenta';
            Editable = false;


        }
        field(611; "QPR Activable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Activable';
            Description = 'QB 1.12.00 - JAV 04/10/22 - [TT] Si se marca indica que se pueden generar gastos activables de esta partida presupuestaria (se generan siempre que el proyecto y el estado del mismo lo permitan)';


        }
        field(612; "QPR Financial Unit"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Part. Presup. Financiera';
            Description = 'QB 1.12.00 - JAV 04/10/22 - [TT] Este campo indica que la partida presupuestaria es actibable por la parte financiera �nicamente';


        }
        field(620; "QPR Cost Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QPR Amounts"."Cost Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                      "Piecework code" = FIELD("Piecework code"),
                                                                                                      "Piecework code" = FIELD(FILTER("Totaling")),
                                                                                                      "Budget Code" = FIELD("Budget Filter"),
                                                                                                      "Type" = CONST("Cost")));
            CaptionML = ESP = 'Importe Presup. Gastos';
            Description = 'Importe del gasto presupuestado';


        }
        field(621; "QPR Cost Comprometido"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Amt. Ex. VAT (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                           "Piecework No." = FIELD("Piecework Code")));
            CaptionML = ESP = 'Gastos Comprometidos (DL)';
            Description = 'Importe del gasto en pedidos';
            Editable = false;


        }
        field(622; "QPR Cost Performed"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Rcpt. Line"."QB Amount Not Invoiced (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                             "Piecework NÂº" = FIELD("Piecework Code"),
                                                                                                                             "Cancelled" = CONST(false)));
            CaptionML = ESP = 'Gastos Realizados (DL)';
            Description = 'Importe del gasto en Albaranes (DL)';
            Editable = false;


        }
        field(623; "QPR Cost Invoiced"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                    "Piecework No." = FIELD("Piecework Code")));
            CaptionML = ESP = 'Gastos Facturados';
            Description = 'Importe del gasto en Facturas';
            Editable = false;


        }
        field(625; "QPR Sale Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QPR Amounts"."Sale Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                      "Piecework code" = FIELD("Piecework code"),
                                                                                                      "Piecework code" = FIELD(FILTER("Totaling")),
                                                                                                      "Budget Code" = FIELD("Budget Filter"),
                                                                                                      "Type" = CONST("Sales")));
            CaptionML = ESP = 'Importe Presup. Ingresos';
            Description = 'Importe de ingresos presupuestado';


        }
        field(626; "QPR Sale Comprometido"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ingresos Comprometidos';
            Description = 'Importe de ingresos en pedidos';
            Editable = false;


        }
        field(627; "QPR Sale Performed"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ingresos Realizados';
            Description = 'Importe de ingresos en albaranes';
            Editable = false;


        }
        field(628; "QPR Sale Invoiced"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                                      "QB_Piecework No." = FIELD("Piecework Code")));
            CaptionML = ESP = 'Ingresos Facturados';
            Description = 'Importe de ingresos en facturas';
            Editable = false;


        }
        field(630; "QPR Budget Amount"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Presup.';
            Description = 'Importe total del presupuesto (Ingresos - Gastos)';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("QPR Cost Amount", "QPR Sale Amount");
                "QPR Budget Amount" := "QPR Sale Amount" - "QPR Cost Amount";
            END;


        }
        field(640; "QPR Cost Amount Tot"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QPR Amounts"."Cost Amount" WHERE("Job No." = FIELD("QPR No."),
                                                                                                      "Budget Code" = FIELD("Budget Filter"),
                                                                                                      "Type" = CONST("Cost")));
            CaptionML = ESP = 'Importe Presup. Gastos';
            Description = 'Estos son para calcular los totales del presupuesto de gastos';


        }
        field(641; "QPR Sale Amount Tot"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QPR Amounts"."Sale Amount" WHERE("Job No." = FIELD("QPR No."),
                                                                                                      "Budget Code" = FIELD("Budget Filter"),
                                                                                                      "Type" = CONST("Sales")));
            CaptionML = ESP = 'Importe Presup. Ingresos';
            Description = 'Estos son para calcular los totales del presupuesto de ingresos';


        }
        field(642; "Cost Amount Base"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Coste base c�lculo';
            Description = 'AML Q18150';

            trigger OnValidate();
            BEGIN
                //-Q8150 AML Este campo no se debe usar para costes directos.
                IF Type = Type::"Cost Unit" THEN BEGIN //Solo para indirectos.
                    "% Expense Cost" := 0; //Si lo ponemos a mano. Lo dejamos a 0.
                    "% Expense Cost Amount Base" := 0;
                    IF ("Allocation Terms" = "Allocation Terms"::"% on Direct Costs") OR ("Allocation Terms" = "Allocation Terms"::"% on Production") THEN BEGIN
                        CalcBase(Rec, "Allocation Terms", 1);
                    END;
                END;
                //OJO tambien hay c�digo en el campo en la page 7207535.
                //+Q18150
            END;


        }
        field(50000; "Initial Sale Measurement"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici¢n venta inicial';
            Description = 'QMD 16/12/19: - GAP08 ROIG CyS. Crear campo para Medici¢n inicial en el presupuesto de venta';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 Question@1100286000 :
                Question: TextConst ENU = 'You will modify the Initial Sale Measurement field, are you sure?', ESP = 'Va a modificar campo Medici¢n Venta Inicial, ¨est  seguro?';
            BEGIN
                IF ("Initial Sale Measurement" <> 0) THEN
                    IF NOT CONFIRM(Question, FALSE) THEN
                        "Initial Sale Measurement" := xRec."Initial Sale Measurement";
            END;


        }
        field(50002; "Outsourcing Code"; Code[20])
        {
            TableRelation = "Vendor";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Outsourcing Code', ESP = 'C¢digo Subcontrataci¢n';
            Description = 'JDC 23/07/19: - GAP020 KALAM. Se a¤aden los campos 50002 "Outsourcing Code" y 50003 "Outsourcing Name"';

            trigger OnValidate();
            VAR
                //                                                                 Vendor@100000000 :
                Vendor: Record 23;
            BEGIN
                IF "Outsourcing Code" <> '' THEN BEGIN
                    Vendor.GET("Outsourcing Code");
                    "Outsourcing Name" := Vendor.Name;
                END ELSE
                    "Outsourcing Name" := '';
            END;


        }
        field(50003; "Outsourcing Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Outsourcing Name', ESP = 'Nombre Subcontrataci¢n';
            Description = 'JDC 23/07/19: - GAP020 KALAM. Se a¤aden los campos 50002 "Outsourcing Code" y 50003 "Outsourcing Name"';


        }
        field(50005; "Not Recalculate Sale"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No recalcular Venta';
            Description = 'JAV 03/02/19: - GAP05 ROIG. U.O. que no entran en los rec lculos de ventas';

            trigger OnValidate();
            BEGIN
                //JAV 03/02/19: - Nuevo campo para que no entre en los c lculos de K. Si no recalculamos ventas en una l¡nea de mayor, la ponemos en todo lo que cuelga de esta
                IF ("Account Type" = "Account Type"::Heading) THEN BEGIN
                    VALIDATE(Totaling);  //JAV Si no tiene bien el filtro de totales marco todos los registros
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                    DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
                    IF (DataPieceworkForProduction.FINDSET) THEN
                        REPEAT
                            IF (DataPieceworkForProduction."Piecework Code" <> "Piecework Code") THEN BEGIN
                                DataPieceworkForProduction."Not Recalculate Sale" := "Not Recalculate Sale";
                                DataPieceworkForProduction.MODIFY;
                            END;
                        UNTIL (DataPieceworkForProduction.NEXT = 0);
                END;
            END;


        }
        field(50006; "Not Recalculate Cost"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No recalcular Coste';
            Description = 'JAV 03/02/19: - GAP05 ROIG. U.O. que no entran en los rec lculos de costes';

            trigger OnValidate();
            BEGIN
                //JAV 03/02/19: - Nuevo campo para que no entre en los c lculos de K. Si no recalculamos ventas en una l¡nea de mayor, la ponemos en todo lo que cuelga de esta
                IF ("Account Type" = "Account Type"::Heading) THEN BEGIN
                    VALIDATE(Totaling);  //JAV Si no tiene bien el filtro de totales marco todos los registros
                    DataPieceworkForProduction.RESET;
                    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
                    DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
                    IF (DataPieceworkForProduction.FINDSET) THEN
                        REPEAT
                            IF (DataPieceworkForProduction."Piecework Code" <> "Piecework Code") THEN BEGIN
                                DataPieceworkForProduction."Not Recalculate Sale" := "Not Recalculate Sale";
                                DataPieceworkForProduction.MODIFY;
                            END;
                        UNTIL (DataPieceworkForProduction.NEXT = 0);
                END;
            END;


        }
        field(50010; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C¢d. divisa';
            Description = 'Q7664';

            trigger OnValidate();
            VAR
                //                                                                 Job2@1100286000 :
                Job2: Record 167;
            BEGIN
                VALIDATE("Contract Price (JC)"); //Q7664 MOD02 -+
            END;


        }
        field(50011; "Expected Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expected Hours', ESP = 'Horas previstas';
            Description = 'KALAM - GAP014';


        }
        field(50012; "Registered Hours"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Worksheet Lines Hist."."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                           "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'Executed Hours', ESP = 'Horas registradas';
            Description = 'KALAM - GAP014';
            Editable = false;


        }
        field(50013; "Registered Work Part"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Worksheet Lines Hist." WHERE("Job No." = FIELD("Job No."),
                                                                                                    "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'Executed Parties', ESP = 'Partes registrados';
            Description = 'KALAM - GAP014';
            Editable = false;


        }
        field(50014; "Manual Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Horas manuales';
            Description = 'KALAM - GAP014';


        }
        field(50018; "Calculated K"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Calculated K', ESP = 'K calculada';
            Description = 'Q8163';
            Editable = false;

            trigger OnValidate();
            BEGIN
                // //Q8163 >>
                // CALCFIELDS("Amount Cost Budget (LCY)");
                // IF "Amount Cost Budget (LCY)" <> 0 THEN
                //  "Calculated K" := "Sale Amount (LCY)"/"Amount Cost Budget (LCY)"
                // ELSE
                //  "Calculated K" := 0;
                // //Q8163 <<

                //JAV 27/02/21: - QB 1.08.19 Calcular la K correctamente
                CALCFIELDS("Aver. Cost Price Pend. Budget");
                IF ("Aver. Cost Price Pend. Budget" <> 0) THEN
                    "Calculated K" := "Contract Price" / "Aver. Cost Price Pend. Budget"
                ELSE
                    "Calculated K" := 0;
                //Q8163 <<
            END;


        }
        field(50019; "Planned K"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Job"."Planned K" WHERE("No." = FIELD("Job No.")));


            CaptionML = ENU = 'Planned K', ESP = 'K planificada';
            Description = 'Q8163';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 27/02/21: - QB 1.08.19 Calcular la K correctamente, ahora es un campo calculado que sale del proyecto, pues siempre es fijo
            END;


        }
        field(50020; "Passing K"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'K Passing', ESP = 'K de paso';
            Description = 'QMD 18/09/19: - GAP018 KALAM. VSTS 7528. Se a¤ade campo para el coeficiente de paso';

            trigger OnValidate();
            BEGIN
                // //+GAP018
                // IF ("Passing K" <> 0) THEN BEGIN 
                //  VALIDATE("Contract Price", "Aver. Cost Price Pend. Budget" * "Passing K");
                // END;
                // //-GAP018

                //JAV 27/02/21: - QB 1.08.19 Calcular la K correctamente
                CALCFIELDS("Planned K", "Aver. Cost Price Pend. Budget");
                IF ("Passing K" <> 0) THEN
                    VALIDATE("Contract Price", "Aver. Cost Price Pend. Budget" * "Passing K")
                ELSE IF ("Planned K" <> 0) THEN
                    VALIDATE("Contract Price", "Aver. Cost Price Pend. Budget" * "Planned K");

                VALIDATE("Calculated K");
            END;


        }
        field(7000000; "Studied"; Boolean)
        {


            CaptionML = ENU = 'Studied', ESP = 'Estudiado';
            Description = 'QBV102';

            trigger OnValidate();
            VAR
                //                                                                 DataPieceworkForProduction2@1100286003 :
                DataPieceworkForProduction2: Record 7207386;
                //                                                                 DataPieceworkForProduction3@1100286002 :
                DataPieceworkForProduction3: Record 7207386;
                //                                                                 i@1100286001 :
                i: Integer;
                //                                                                 exist@1100286000 :
                exist: Boolean;
            BEGIN
                //QB4932
                MarkStudied(Studied);

                //JAV 20/03/19: - Si desmarcamos una UO, desmarcamos el padre como estudiado completo si lo estuviera
                IF (NOT Studied) AND ("Account Type" = "Account Type"::Unit) THEN BEGIN
                    i := STRLEN("Piecework Code");
                    REPEAT
                        i -= 1;
                        DataPieceworkForProduction2.RESET;
                        DataPieceworkForProduction2.SETRANGE("Job No.", Rec."Job No.");
                        DataPieceworkForProduction2.SETFILTER("Piecework Code", COPYSTR("Piecework Code", 1, i));
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", GETFILTER(Rec."Budget Filter"));
                        IF DataPieceworkForProduction2.FINDFIRST THEN BEGIN
                            IF (DataPieceworkForProduction2.Studied) THEN BEGIN
                                DataPieceworkForProduction2.Studied := FALSE;
                                DataPieceworkForProduction2.MODIFY;
                            END;
                        END;
                    UNTIL (i <= 1)
                END;
                //JAV 20/03/19 fin

                //JAV 20/03/19: - Si todos los hijos est n marcados, marcar el padre tambi‚n si no lo estuviera
                IF (Studied) THEN BEGIN
                    i := STRLEN("Piecework Code");
                    exist := FALSE;
                    REPEAT
                        i -= 1;
                        DataPieceworkForProduction2.RESET;
                        DataPieceworkForProduction2.SETRANGE("Job No.", Rec."Job No.");
                        DataPieceworkForProduction2.SETFILTER("Piecework Code", COPYSTR("Piecework Code", 1, i));
                        DataPieceworkForProduction2.SETRANGE("Budget Filter", GETFILTER(Rec."Budget Filter"));
                        IF DataPieceworkForProduction2.FINDFIRST THEN BEGIN
                            IF (NOT DataPieceworkForProduction2.Studied) THEN BEGIN
                                DataPieceworkForProduction2.VALIDATE(Totaling);
                                DataPieceworkForProduction3.RESET;
                                DataPieceworkForProduction3.SETRANGE("Job No.", Rec."Job No.");
                                DataPieceworkForProduction3.SETFILTER("Piecework Code", DataPieceworkForProduction2.Totaling);
                                DataPieceworkForProduction3.SETRANGE("Budget Filter", GETFILTER(Rec."Budget Filter"));
                                DataPieceworkForProduction3.SETRANGE(Studied, FALSE);
                                IF (DataPieceworkForProduction3.FINDSET) THEN
                                    REPEAT
                                        exist := (DataPieceworkForProduction3."Piecework Code" <> DataPieceworkForProduction2."Piecework Code") AND (DataPieceworkForProduction3."Piecework Code" <> "Piecework Code");
                                    UNTIL (DataPieceworkForProduction3.NEXT = 0) OR (exist);
                                IF NOT exist THEN BEGIN
                                    DataPieceworkForProduction2.Studied := TRUE;
                                    DataPieceworkForProduction2.MODIFY;
                                END;
                            END;
                        END;
                    UNTIL (i <= 1) OR (exist);
                END;
                //JAV 20/03/19 fin
            END;


        }
        field(7000002; "Total Amount Cost Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Forecast Data Amount Piecework"."Amount" WHERE("Entry Type" = CONST("Expenses"),
                                                                                                                  "Job No." = FIELD("Job No."),
                                                                                                                  "Cod. Budget" = FIELD(FILTER("Budget Filter")),
                                                                                                                  "Analytical Concept" = FIELD(FILTER("Filter Analytical Concept")),
                                                                                                                  "Expected Date" = FIELD(FILTER("Filter Date"))));
            CaptionML = ENU = 'Total Amount Cost Budget', ESP = 'Importe coste ppto.';
            Editable = false;


        }
        field(7000003; "Allow Over Measure"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allow Over Measure', ESP = 'Permitir exceso medici¢n';
            CaptionClass = '7206910,7207386,7000003';


        }
        field(7000004; "Actual Cost DP"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Entry Type" = CONST("Usage"),
                                                                                                                "Posting Date" = FIELD("Filter Date"),
                                                                                                                "Global Dimension 2 Code" = FIELD("Filter Analytical Concept")));
            CaptionML = ENU = 'Actual Cost LCY', ESP = 'Total Coste DP';
            Description = 'JAV 10/04/20: - Estos campos son el la divisa del proyecto, no lo local';
            Editable = false;


        }
        field(7000005; "Date init"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de inicio';
            Description = 'JAV 17/12/2018';

            trigger OnValidate();
            VAR
                //                                                                 err01@1100286000 :
                err01: TextConst ESP = 'La fecha de inicio no puede ser mayor a la de fin';
                //                                                                 err02@1100286001 :
                err02: TextConst ESP = 'La fecha de inicio no puede ser menor que la fecha de inicio del proyecto (%1)';
            BEGIN
                //JAV 17/12/18: - Se a¤aden los capos 7000005 "Date init", 7000005 "Date end" y 7000005 "Distributed"
                IF ("Date init" <> xRec."Date init") THEN
                    Distributed := FALSE;

                //JAV 11/03/19: - Controlar fechas en rango correcto
                IF ("Date end" <> 0D) AND ("Date init" > "Date end") THEN
                    ERROR(err01);

                //JAV 03/08/20: - Control de la fecha con la de incio del proyecto
                IF (NOT SkipCheckDates) THEN BEGIN
                    Job.GET("Job No.");
                    IF ("Date init" < Job."Starting Date") THEN
                        ERROR(err02, Job."Starting Date");
                END;
                SkipCheckDates := FALSE;

                //Subo la fecha a las unidades de mayor
                SetHeadingDates;
            END;


        }
        field(7000006; "Date end"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de final';
            Description = 'JAV 17/12/2018';

            trigger OnValidate();
            VAR
                //                                                                 err01@1100286000 :
                err01: TextConst ESP = 'La fecha de fin no puede ser menor a la de inicio';
                //                                                                 err02@1100286001 :
                err02: TextConst ESP = 'La fecha de fin no puede ser mayor que la fecha de fin del proyecto (%1)';
            BEGIN
                //JAV 17/12/18: - Se a¤aden los capos 7000005 "Date init", 7000005 "Date end" y 7000005 "Distributed"
                IF ("Date end" <> xRec."Date end") THEN
                    Distributed := FALSE;

                //JAV 11/03/19: - Controlar fechas en rango correcto
                IF ("Date init" <> 0D) AND ("Date end" < "Date init") THEN
                    ERROR(err01);

                //JAV 03/08/20: - Control de la fecha con la de fin del proyecto
                IF (NOT SkipCheckDates) THEN BEGIN
                    Job.GET("Job No.");
                    IF ("Date end" > Job."Ending Date") THEN  //JMMA 19/08/20
                        ERROR(err02, Job."Ending Date");
                END;
                SkipCheckDates := FALSE;

                //Subo la fecha a las unidades de mayor
                SetHeadingDates;
            END;


        }
        field(7000007; "Distributed"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Repartido';
            Description = 'JAV 17/12/2018';
            Editable = false;


        }
        field(7238177; "QB_PieceWork Blocked"; Option)
        {
            OptionMembers = " ","Posting","All";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida bloqueada';
            OptionCaptionML = ESP = '" ,Registro,Todo"';

            Description = 'QRE 1.00.00 15469';


        }
    }
    keys
    {
        key(key1; "Job No.", "Piecework Code")
        {
            SumIndexFields = "Sale Amount", "Sale Quantity (base)", "Amount Sale Contract";
            Clustered = true;
        }
        key(key2; "Type")
        {
            ;
        }
        key(key3; "Job No.", "Unique Code")
        {
            ;
        }
        key(key4; "Job No.", "No. Record")
        {
            ;
        }
        key(key5; "Job No.", "Title", "Piecework Code")
        {
            ;
        }
        key(key6; "Job No.", "No. Subcontracting Resource")
        {
            ;
        }
        key(key7; "Job No.", "Activity Code")
        {
            ;
        }
        key(key8; "Job No.", "Customer Certification Unit", "Piecework Code")
        {
            ;
        }
        key(key9; "Job No.", "Subtype Cost", "Piecework Code")
        {
            //KeyGroups =CO;
        }
        key(key10; "Date init")
        {
            ;
        }
        key(key11; "Date end")
        {
            ;
        }
        key(key12; "Job No.", "Account Type", "Production Unit", "Piecework Code")
        {
            ;
        }
        key(key13; "Job No.", "Account Type", "Type", "Allocation Terms", "Piecework Code")
        {
            ;
        }
        key(key14; "Job No.", "Account Type", "Type", "Type Unit Cost", "Periodic Cost", "Piecework Code")
        {
            ;
        }
        key(key15; "Job No.", "Account Type", "Customer Certification Unit", "Piecework Code")
        {
            ;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Job No.", "Piecework Code", "Description")
        {

        }
    }

    var
        //       Text001@7207795 :
        Text001: TextConst ENU = 'For measurement validation it must exists a title for the job unit', ESP = 'Para validar la medici¢n debe existir un t¡tulo para la unidad de obra';
        //       Text002@7207794 :
        Text002: TextConst ENU = 'When erasing the piecework, the lines of existing piecework will be erased in costs and forecast.', ESP = 'Al borrar la unidad de obra se borraran las l¡neas de las unidades de obra existentes en costes y previsi¢n.';
        //       Text003@7207793 :
        Text003: TextConst ENU = 'The piecework must be associated with at least one title', ESP = 'La unidad de obra debe de estar asociada al menos a un t¡tulo';
        //       Text004@7207792 :
        Text004: TextConst ENU = 'When there are allocations for the piecework %1, the record can not be deleted', ESP = 'Al existir imputaciones para la unidad de obra %1 no se puede eliminar el registro';
        //       Text005@7207791 :
        Text005: TextConst ENU = 'The cost unit type must be external', ESP = 'El tipo de unidad de coste debe ser externo';
        //       Text006@7207790 :
        Text006: TextConst ENU = 'The job is locked', ESP = 'El proyecto est  bloqueado';
        //       Text007@7207789 :
        Text007: TextConst ENU = 'The job must be structured', ESP = 'El proyecto debe ser de estructura';
        //       Text008@7207788 :
        Text008: TextConst ENU = 'The record type must have some value', ESP = 'El tipo expediente debe tener alg£n valor';
        //       Text009@7207787 :
        Text009: TextConst ENU = 'The unit must have at least one production or certification value', ESP = 'La unidad tiene que tener al menos un valor de producci¢n o certificaci¢n';
        //       Text010@7207786 :
        Text010: TextConst ENU = 'There are regsitradas measurements for the piecework %1 job %2', ESP = 'Existen mediciones regsitradas para la unidad de obra %1 proyecto %2';
        //       Text011@7207785 :
        Text011: TextConst ENU = 'The unit has to be for rent', ESP = 'La unidad tiene que ser de alquiler';
        //       Text013@7207783 :
        Text013: TextConst ENU = 'Must indicate a subcontracting price', ESP = 'Debe indicar un precio de subcontratacion';
        //       Text014@7207782 :
        Text014: TextConst ENU = 'You are trying to erase a piecework of heagin and this will erase all the units of work that depend on it. Do you wish to continue?', ESP = 'Esta intentado borrar una unidad de obra de mayor y esto borrar  %1 unidades de obra que depende de ella. ¨Desea Continuar?';
        //       Text015@7207781 :
        Text015: TextConst ENU = 'Process canceled by user', ESP = 'Proceso cancelado por el usuario';
        //       Text016@7207780 :
        Text016: TextConst ENU = 'This job does not allow sharing of certification and production units', ESP = 'Este proyecto no admite compartir unidades de certificaci¢n y de producci¢n';
        //       Text017@7207779 :
        Text017: TextConst ESP = 'Este proyecto no admite separar unidades de certificaci¢n y de producci¢n';
        //       Text018@7207778 :
        Text018: TextConst ENU = '""', ESP = '''''';
        //       Text019@1100286018 :
        Text019: TextConst ENU = 'Assistant Unit', ESP = 'Unidad auxiliar';
        //       Text020@1100286008 :
        Text020: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
        //       Text021@7207777 :
        Text021: TextConst ENU = 'Field %1 must be empty when %2 <> %3.', ESP = 'El campo %1 debes ser vacio cuando %2<> %3.';
        //       Text022@7207774 :
        Text022: TextConst ENU = 'The job piecework has validated redeterminations and it is not possible to change the coefficients', ESP = 'La unidad de obra del proyecto tiene redeterminaciones validadas y no es posible cambiar los coeficientes';
        //       Job@7207771 :
        Job: Record 167;
        //       Currency@1100286012 :
        Currency: Record 4;
        //       DataPieceworkForProduction@7207773 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProductionP@1100286013 :
        DataPieceworkForProductionP: Record 7207386;
        //       DataPieceworkForProductionFather@1100286017 :
        DataPieceworkForProductionFather: Record 7207386;
        //       ExpectedTimeUnitDataEntry@7001100 :
        ExpectedTimeUnitDataEntry: Record 7207388;
        //       ExpectedTimeUnitData2@7001103 :
        ExpectedTimeUnitData2: Record 7207388;
        //       ExpectedTimeUnitData2Uptake@7001104 :
        ExpectedTimeUnitData2Uptake: Record 7207388;
        //       ForecastDataAmountPieceworkAmount@7001106 :
        ForecastDataAmountPieceworkAmount: Record 7207392;
        //       ForecastDataAmountPiecework@1100286014 :
        ForecastDataAmountPiecework: Record 7207392;
        //       RelCertificationproduct@1100286016 :
        RelCertificationproduct: Record 7207397;
        //       ExpectedTimeUnitData@1100286015 :
        ExpectedTimeUnitData: Record 7207388;
        //       Resource@7001107 :
        Resource: Record 156;
        //       Records@7001108 :
        Records: Record 7207393;
        //       PieceworkSetup@7001109 :
        PieceworkSetup: Record 7207279;
        //       Piecework@7001115 :
        Piecework: Record 7207277;
        //       JobBudget@7001116 :
        JobBudget: Record 7207407;
        //       DataCostByPiecework@1100286011 :
        DataCostByPiecework: Record 7207387;
        //       DimensionManagement@1100286003 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;
        //       CostPieceworkJobIdent@1100286000 :
        CostPieceworkJobIdent: Codeunit 7207296;
        //       NoEntry@1100286010 :
        NoEntry: Integer;
        //       RunUpdate@1100286009 :
        RunUpdate: Boolean;
        //       AmountSaleContract@1100286007 :
        AmountSaleContract: Decimal;
        //       CJob@1100286006 :
        CJob: Code[20];
        //       difference@1100286005 :
        difference: Decimal;
        //       difference2@1100286004 :
        difference2: Decimal;
        //       SkipCheckDates@1100286002 :
        SkipCheckDates: Boolean;
        //       Text023@1100286019 :
        Text023: TextConst ESP = 'Guardar solo los que est‚n a cero,guardar todos,salir';
        //       Text024@1100286020 :
        Text024: TextConst ESP = 'Ya hay unidades con medici¢n incial, seleccione el proceso a realizar:';
        //       Text025@1100286021 :
        Text025: TextConst ESP = 'Proceso finalizado';
        //       Text606@1100286022 :
        Text606: TextConst ESP = 'No se pueden usar trabajadores en los presupuestos';
        //       Text027@1100286023 :
        Text027: TextConst ESP = 'No ha indicado fecha de inicio en el presupuesto, no puedo recalcular la unidad';



    trigger OnInsert();
    begin
        //Si entro en la tabla desde proyecto, heredo de forma autom tica el proyecto desde el que vengo.
        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Job No.") <> '')) then
            VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);

        CLEAR(Job);
        Job.JobStatus("Job No.");

        GetMargin;

        DimensionManagement.UpdateDefaultDim(
          DATABASE::"Data Piecework For Production", "Unique Code",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

        //JAV 06/10/20: - QB 1.06.18 Traspaso el c lculo de si la unidad es planificable a su validate y se llama desde mas lugares
        VALIDATE(Plannable);

        //JAV 03/09/21: - QB 1.09.99 Si es otro presupuesto o de una empresa externa, lo guardo en la tabla de la empresa de destino
        if ("QPR Type" IN ["QPR Type"::Budget, "QPR Type"::BCompany]) then
            QPRSetExternalCompany("QPR Company", "QPR No.", TRUE);
    end;

    trigger OnModify();
    begin
        CLEAR(Job);
        Job.JobStatus("Job No.");

        CheckClosed;

        //JAV 06/10/20: - QB 1.06.18 Traspaso el c lculo de si la unidad es planificable a su validate y se llama desde mas lugares
        VALIDATE(Plannable);

        //JAV 03/09/21: - QB 1.09.99 Si es otro presupuesto o de una empresa externa, elimino el anterior y guardo el modificado en la tabla de la empresa de destino
        if (xRec."QPR Type" IN ["QPR Type"::Budget, "QPR Type"::BCompany]) then
            QPRSetExternalCompany(xRec."QPR Company", xRec."QPR No.", FALSE);
        if ("QPR Type" IN ["QPR Type"::Budget, "QPR Type"::BCompany]) then
            QPRSetExternalCompany("QPR Company", "QPR No.", TRUE);
    end;

    trigger OnDelete();
    var
        //                QPRAmounts@1100286000 :
        QPRAmounts: Record 7207383;
        //                QBJobResponsible@1100286001 :
        QBJobResponsible: Record 7206992;
    begin
        //JAV 12/03/19: - Se revisa el proceso de eliminaci¢n porque no estaba muy bien
        CheckClosed;  //JAV Estaba al final tras un posible commit
        Job.JobStatus("Job No.");

        //DGG 20/05/22: - QB 1.10.45 (17304) Se modifica c�digo en OnDelete para que no muestre el aviso al borrar una linea de mayor.

        if "Account Type" = "Account Type"::Heading then begin
            VALIDATE(Totaling, '');    //JAV Si no tiene bien el filtro de totales al borrar eliminaba todos los registros

            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            if (DataPieceworkForProduction.COUNT > 1) then begin //Si hay registros por debajo hay que eliminarlos
                if not CONFIRM(Text014, FALSE, DataPieceworkForProduction.COUNT - 1) then //JAV Se a¤ade el contador del nro de UO a eliminar
                    ERROR('');

                DataPieceworkForProduction.FINDSET;
                repeat
                    if (DataPieceworkForProduction."Piecework Code" <> "Piecework Code") then begin //No me debo borrar a mi mismo
                        DataPieceworkForProduction.DeleteData(TRUE, TRUE);
                        DataPieceworkForProduction.DELETE(FALSE);
                    end;
                until DataPieceworkForProduction.NEXT = 0;
            end;
        end;
        //+17304

        //Borrar los datos relacionados con la U.O.
        DeleteData(TRUE, TRUE);
        //JAV fin

        //JAV 03/09/21: - QB 1.09.99 Elimino los registros de importes
        QPRAmounts.RESET;
        QPRAmounts.SETRANGE("Job No.", "Job No.");
        QPRAmounts.SETRANGE("Piecework code", "Piecework Code");
        QPRAmounts.DELETEALL;

        //JAV 03/09/21: - QB 1.09.99 Si es otro presupuesto o de una empresa externa, lo elimino de la tabla de la empresa de destino
        if ("QPR Type" IN ["QPR Type"::Budget, "QPR Type"::BCompany]) then
            QPRSetExternalCompany("QPR Company", "QPR No.", FALSE);

        //JAV 16/05/22: - QRE 1.00.15 Se eliminan los responsables de la unidad de obra al eliminar esta
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Piecework);
        QBJobResponsible.SETRANGE("Table Code", Rec."Job No.");
        QBJobResponsible.SETRANGE("Piecework No.", Rec."Piecework Code");
        QBJobResponsible.DELETEALL;
    end;

    trigger OnRename();
    begin
        //JAV 03/09/21: - QB 1.09.99 Si es otro presupuesto o de una empresa externa, elimino el anterior y guardo el nuevo c¢digo en la tabla de la empresa de destino
        if (xRec."QPR Type" IN ["QPR Type"::Budget, "QPR Type"::BCompany]) then
            QPRSetExternalCompany(xRec."QPR Company", xRec."QPR No.", FALSE);
        if ("QPR Type" IN ["QPR Type"::Budget, "QPR Type"::BCompany]) then
            QPRSetExternalCompany("QPR Company", "QPR No.", TRUE);
    end;



    procedure GetMargin()
    var
        //       recJob@1100251000 :
        recJob: Record 167;
    begin
        if Type = Type::Piecework then begin
            if Job.GET("Job No.") then begin
                if Job."% Margin" <> 0 then
                    VALIDATE("% Of Margin", Job."% Margin");
            end;
        end else
            VALIDATE("% Of Margin", 0);
    end;

    //     procedure DeleteData (DeleteCertification@1100251000 : Boolean;DeleteProduction@1100251001 :
    procedure DeleteData(DeleteCertification: Boolean; DeleteProduction: Boolean)
    var
        //       HistMeasurementsLines@7207771 :
        HistMeasurementsLines: Record 7207339;
        //       MeasureLineJUCertification@7207772 :
        MeasureLineJUCertification: Record 7207343;
        //       QBText@7207773 :
        QBText: Record 7206918;
        //       HistLinesMeasuresProd@7207775 :
        HistLinesMeasuresProd: Record 7207402;
        //       JobLedgerEntry@7207776 :
        JobLedgerEntry: Record 169;
        //       MeasurementLinesJUProd@7207777 :
        MeasurementLinesJUProd: Record 7207390;
        //       DataCostByJU@7207778 :
        DataCostByJU: Record 7207387;
        //       ForecastDataAmountsJU@7207779 :
        ForecastDataAmountsJU: Record 7207392;
        //       PeriodificationUnitCost@7207780 :
        PeriodificationUnitCost: Record 7207432;
        //       CommentLine@7207781 :
        CommentLine: Record 97;
        //       DefaultDimension@7207782 :
        DefaultDimension: Record 352;
        //       DataCostByPieceworkCert@1100286000 :
        DataCostByPieceworkCert: Record 7207340;
    begin
        if DeleteCertification then begin
            HistMeasurementsLines.RESET;
            HistMeasurementsLines.SETCURRENTKEY("Job No.", "Piecework No.");
            HistMeasurementsLines.SETRANGE("Job No.", "Job No.");
            HistMeasurementsLines.SETRANGE("Piecework No.", "Piecework Code");
            if HistMeasurementsLines.FINDFIRST then
                ERROR(Text010, "Piecework Code", "Job No.");

            MeasureLineJUCertification.RESET;
            MeasureLineJUCertification.SETCURRENTKEY("Job No.", "Piecework Code", "Line No.");
            MeasureLineJUCertification.SETRANGE("Job No.", "Job No.");
            MeasureLineJUCertification.SETRANGE("Piecework Code", "Piecework Code");
            if MeasureLineJUCertification.FINDFIRST then
                MeasureLineJUCertification.DELETEALL;

            //Borramos los descompuestos de venta
            DataCostByPieceworkCert.RESET;
            DataCostByPieceworkCert.SETCURRENTKEY("Job No.", "Piecework Code");
            DataCostByPieceworkCert.SETRANGE("Job No.", "Job No.");
            DataCostByPieceworkCert.SETRANGE("Piecework Code", "Piecework Code");
            DataCostByPieceworkCert.DELETEALL;

            QBText.RESET;
            QBText.SETRANGE(Table, QBText.Table::Job);
            QBText.SETRANGE(Key1, "Job No.");
            QBText.SETRANGE(Key2, "Piecework Code");
            QBText.DELETEALL(TRUE);

            //borramos las relaciones
            RelCertificationproduct.SETRANGE("Job No.", "Job No.");
            if "Production Unit" then
                RelCertificationproduct.SETRANGE("Production Unit Code", "Piecework Code");
            if "Customer Certification Unit" then
                RelCertificationproduct.SETRANGE("Certification Unit Code", "Piecework Code");
            RelCertificationproduct.DELETEALL;

            //JAV 20/10/21: - QB 1.09.22 Borramos previsi�n de certificaci�n
            ForecastDataAmountsJU.SETCURRENTKEY("Job No.");
            ForecastDataAmountsJU.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountsJU.SETRANGE("Unit Type", ForecastDataAmountsJU."Entry Type"::Certification);
            ForecastDataAmountsJU.DELETEALL;

        end;

        if DeleteProduction then begin
            HistLinesMeasuresProd.RESET;
            HistLinesMeasuresProd.SETCURRENTKEY("Job No.", "Piecework No.", "Posting Date");
            HistLinesMeasuresProd.SETRANGE(HistLinesMeasuresProd."Piecework No.", "Piecework Code");
            HistLinesMeasuresProd.SETRANGE(HistLinesMeasuresProd."Job No.", "Job No.");
            if HistLinesMeasuresProd.FINDFIRST then
                ERROR(Text004, "Job No.");

            JobLedgerEntry.RESET;
            JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date", Type, "No.", "Entry Type", "Piecework No.");
            JobLedgerEntry.SETRANGE(JobLedgerEntry."Job No.", "Job No.");
            JobLedgerEntry.SETRANGE(JobLedgerEntry."Piecework No.", "Piecework Code");
            if JobLedgerEntry.FINDFIRST then
                ERROR(Text004, "Job No.");

            MeasurementLinesJUProd.RESET;
            MeasurementLinesJUProd.SETCURRENTKEY("Job No.", "Piecework Code");
            MeasurementLinesJUProd.SETRANGE("Job No.", "Job No.");
            MeasurementLinesJUProd.SETRANGE("Piecework Code", "Piecework Code");
            if MeasurementLinesJUProd.FINDFIRST then
                MeasurementLinesJUProd.DELETEALL(FALSE);

            QBText.RESET;
            QBText.SETRANGE(Table, QBText.Table::Job);
            QBText.SETRANGE(Key1, "Job No.");
            QBText.SETRANGE(Key2, "Piecework Code");
            QBText.DELETEALL(TRUE);

            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
            ExpectedTimeUnitData.DELETEALL(TRUE);

            DataCostByJU.RESET;
            DataCostByJU.SETCURRENTKEY("Job No.", "Piecework Code");
            DataCostByJU.SETRANGE("Job No.", "Job No.");
            DataCostByJU.SETRANGE("Piecework Code", "Piecework Code");
            DataCostByJU.DELETEALL(FALSE);

            ForecastDataAmountsJU.SETCURRENTKEY("Job No.");
            ForecastDataAmountsJU.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountsJU.SETRANGE("Piecework Code", "Piecework Code");
            //JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
            ForecastDataAmountsJU.SETFILTER("Unit Type", '%1|%2', ForecastDataAmountsJU."Entry Type"::Expenses, ForecastDataAmountsJU."Entry Type"::Incomes);
            ForecastDataAmountsJU.DELETEALL;

            //si borran borramos las periodificaciones de la Unit de coste
            PeriodificationUnitCost.RESET;
            PeriodificationUnitCost.SETCURRENTKEY("Job No.", "Unit Cost", Date);
            PeriodificationUnitCost.SETRANGE("Job No.", "Job No.");
            PeriodificationUnitCost.SETRANGE("Unit Cost", "Piecework Code");
            PeriodificationUnitCost.DELETEALL(TRUE);

            //Borramos los comentarios asociados.
            CommentLine.RESET;
            CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"Job Cost Piecework");
            CommentLine.SETRANGE("No.", "Unique Code");
            CommentLine.DELETEALL(TRUE);


            //Borramos las dimensiones.
            DefaultDimension.RESET;
            DefaultDimension.SETRANGE("Table ID", DATABASE::"Data Piecework For Production");
            DefaultDimension.SETRANGE("No.", "Unique Code");
            DefaultDimension.DELETEALL(TRUE);

            //ponemos datos en blanco
            "% Expense Cost" := 0;
            "Initial Produc. Price" := 0;

            //borramos las relaciones
            RelCertificationproduct.SETRANGE("Job No.", "Job No.");
            if "Production Unit" then
                RelCertificationproduct.SETRANGE("Production Unit Code", "Piecework Code");
            if "Customer Certification Unit" then
                RelCertificationproduct.SETRANGE("Certification Unit Code", "Piecework Code");
            RelCertificationproduct.DELETEALL;

        end;
    end;

    procedure amountProductionInProgress(): Decimal;
    begin
        CALCFIELDS("Amount Production Performed");
        exit("Amount Production Performed" * (1 - "% Processed Production" / 100));
    end;

    procedure AmountProductionAccepted(): Decimal;
    begin
        CALCFIELDS("Amount Production Performed");
        if "Record Type" = "Record Type"::" " then
            exit("Amount Production Performed")
        else begin
            exit("Amount Production Performed" * ("% Processed Production" / 100));
        end;
    end;

    procedure CostPrice(): Decimal;
    var
        //       RelCertificationProduct@7207270 :
        RelCertificationProduct: Record 7207397;
    begin
        CALCFIELDS("Budget Measure", "Amount Cost Budget (LCY)");
        if ("Account Type" = "Account Type"::Unit) and ("Budget Measure" <> 0) then
            exit("Amount Cost Budget (LCY)" / "Budget Measure")
        else
            exit(0);
    end;

    procedure ProductionPrice(): Decimal;
    var
        //       AssignedSaleAmount@7207271 :
        AssignedSaleAmount: Decimal;
        //       LJob@7001100 :
        LJob: Record 167;
        //       LRelCertificationProduct@7001101 :
        LRelCertificationProduct: Record 7207397;
        //       LDataPieceworkForProduction@7001102 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        //Calcular el precio de producci¢n de las unidades
        CLEAR(Currency);
        GetCurrency;
        Currency.InitRoundingPrecision;
        LJob.GET("Job No.");
        if "Account Type" = "Account Type"::Unit then begin
            if Type = Type::"Cost Unit" then
                exit(0);

            CALCFIELDS("Budget Measure");

            //SI COINCIDE COSTE=VENTA, HAY QUE RESPETAR EL IMPORTE VENTA=IMPORTE PRODUCCIàN PPTO.
            if (not LJob."Separation Job Unit/Cert. Unit") and ("Customer Certification Unit") then begin
                if "Budget Measure" <> 0 then
                    exit("Sale Amount" / "Budget Measure")
                else
                    exit(0);
            end;

            //Si no coincide coste=venta, se busca la relaci¢n de Unidades de producci¢n asignadas
            LRelCertificationProduct.SETRANGE("Job No.", "Job No.");
            LRelCertificationProduct.SETRANGE("Production Unit Code", "Piecework Code");
            if LRelCertificationProduct.FINDFIRST then
                repeat
                    //JAV 30/10/20: - QB 1.07.03 Si no existe la unidad no hace nada
                    if (LDataPieceworkForProduction.GET(LRelCertificationProduct."Job No.", LRelCertificationProduct."Certification Unit Code")) then
                        if LRelCertificationProduct."Percentage Of Assignment" <> 0 then
                            AssignedSaleAmount += LDataPieceworkForProduction."Sale Amount" * LRelCertificationProduct."Percentage Of Assignment" / 100;
                until (LRelCertificationProduct.NEXT = 0);

            if ("Budget Measure" <> 0) then
                exit(ROUND(AssignedSaleAmount / "Budget Measure", Currency."Unit-Amount Rounding Precision"))
            else
                exit(0);
        end else
            exit(0);
    end;

    procedure GetCurrency(): Code[10];
    begin
        CLEAR(Currency);
        if Job.GET("Job No.") then
            if Job."Currency Code" <> '' then
                Currency.GET(Job."Currency Code");
        Currency.InitRoundingPrecision;
        exit(Currency.Code);
    end;

    procedure SaleAmountBase(): Decimal;
    var
        //       AmountSaleTotal@1100281001 :
        AmountSaleTotal: Decimal;
    begin
        if "Account Type" = "Account Type"::Unit then
            exit("Sales Amount (Base)")
        else begin
            AmountSaleTotal := 0;
            DataPieceworkForProductionP.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProductionP.SETFILTER("Piecework Code", Totaling);
            DataPieceworkForProductionP.SETRANGE("Account Type", DataPieceworkForProductionP."Account Type"::Unit);
            DataPieceworkForProductionP.SETRANGE("Customer Certification Unit", TRUE);
            if DataPieceworkForProductionP.FINDSET then
                repeat
                    AmountSaleTotal := AmountSaleTotal + DataPieceworkForProductionP."Sales Amount (Base)";
                until DataPieceworkForProductionP.NEXT = 0;
            exit(AmountSaleTotal);
        end;
    end;

    procedure AmountIncrease(): Decimal;
    var
        //       DataJobUnitForProductionP@1100281000 :
        DataJobUnitForProductionP: Record 7207386;
        //       AmountSalesTotal@1100281001 :
        AmountSalesTotal: Decimal;
    begin
        if "Account Type" = "Account Type"::Unit then
            exit("Increased Amount Of Redeterm.")
        else begin
            AmountSalesTotal := 0;
            DataPieceworkForProductionP.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProductionP.SETFILTER("Piecework Code", Totaling);
            DataPieceworkForProductionP.SETRANGE("Account Type", DataPieceworkForProductionP."Account Type"::Unit);
            DataPieceworkForProductionP.SETRANGE("Customer Certification Unit", TRUE);
            if DataPieceworkForProductionP.FINDSET then
                repeat
                    AmountSalesTotal := AmountSalesTotal + DataPieceworkForProductionP."Increased Amount Of Redeterm.";
                until DataPieceworkForProductionP.NEXT = 0;
            exit(AmountSalesTotal);
        end;
    end;

    procedure SaleAmount(): Decimal;
    var
        //       DataJobUnitForProductionP@1100281000 :
        DataJobUnitForProductionP: Record 7207386;
        //       AmountSalesTotal@1100281001 :
        AmountSalesTotal: Decimal;
    begin
        if "Account Type" = "Account Type"::Unit then begin
            exit("Sale Amount")
        end else begin
            AmountSalesTotal := 0;
            DataPieceworkForProductionP.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProductionP.SETFILTER("Piecework Code", Totaling);
            DataPieceworkForProductionP.SETRANGE("Account Type", DataPieceworkForProductionP."Account Type"::Unit);
            DataPieceworkForProductionP.SETRANGE("Customer Certification Unit", TRUE);
            if DataPieceworkForProductionP.FINDSET then
                repeat
                    AmountSalesTotal := AmountSalesTotal + DataPieceworkForProductionP."Sale Amount";
                until DataPieceworkForProductionP.NEXT = 0;
            exit(AmountSalesTotal);
        end;
    end;

    //     procedure AssigBillOfItemUnitSubcontracting (SubcontractingType@1100251002 :
    procedure AssigBillOfItemUnitSubcontracting(SubcontractingType: Option "All","Resources")
    var
        //       Job@7207270 :
        Job: Record 167;
        //       DataCostByPiecework@7207271 :
        DataCostByPiecework: Record 7207387;
        //       Text0012@7207272 :
        Text0012: TextConst ENU = 'Must indicate analytical concept of subcontracting', ESP = 'Debe indicar concepto analitico de subcontratci¢n';
        //       DataCostByPieceworkSaved@1100286000 :
        DataCostByPieceworkSaved: Record 7207273;
        //       QBTextSaved@1100286001 :
        QBTextSaved: Record 7207274;
        //       QBText@1100286002 :
        QBText: Record 7206918;
        //       QBText2@1100286003 :
        QBText2: Record 7206918;
    begin
        //JAV 02/05/20: - Se reforma la funci¢n por completo
        if "Analytical Concept Subcon Code" = '' then
            ERROR(Text0012);

        Job.GET("Job No.");

        if "Price Subcontracting Cost" = 0 then begin
            CASE SubcontractingType OF
                SubcontractingType::All:
                    begin
                        CALCFIELDS("Aver. Cost Price Pend. Budget");
                        "Price Subcontracting Cost" := "Aver. Cost Price Pend. Budget";
                    end;
                SubcontractingType::Resources:
                    begin
                        DataCostByPiecework.RESET;
                        DataCostByPiecework.SETRANGE("Job No.", "Job No.");
                        DataCostByPiecework.SETRANGE("Piecework Code", "Piecework Code");
                        DataCostByPiecework.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
                        DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
                        DataCostByPiecework.CALCSUMS("Budget Cost");
                        "Price Subcontracting Cost" := DataCostByPiecework."Budget Cost";
                    end;
            end;
            MODIFY;
        end;

        //Combinar los Textos adicionales antes de eliminarlos
        QBText2.CombineText(2, QBText.Table::Job, "Job No.", "Piecework Code", '',
                               QBText.Table::Job, "Job No.", "Piecework Code", "No. Subcontracting Resource");

        //Eliminar los Descompuestos y textos asociados
        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", "Job No.");
        DataCostByPiecework.SETRANGE("Piecework Code", "Piecework Code");
        DataCostByPiecework.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
        if (SubcontractingType = SubcontractingType::Resources) then
            DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
        if DataCostByPiecework.FINDSET then
            repeat
                DataCostByPieceworkSaved.TRANSFERFIELDS(DataCostByPiecework);
                DataCostByPieceworkSaved.INSERT;
                DataCostByPiecework.DELETE;
                if QBText.GET(QBText.Table::Job, DataCostByPiecework."Job No.", DataCostByPiecework."Piecework Code", DataCostByPiecework."No.") then begin
                    QBText.CALCFIELDS("Cost Text", "Sales Text");
                    QBTextSaved.TRANSFERFIELDS(QBText);
                    QBTextSaved.INSERT;
                    QBText.DELETE;
                end;
            until DataCostByPiecework.NEXT = 0;

        //Insertar el nuevo Descompuesto o modificar el existente (esto no se puede dar en teor¡a, lo dejo por si acaso)
        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", "Job No.");
        DataCostByPiecework.SETRANGE("Piecework Code", "Piecework Code");
        DataCostByPiecework.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
        if (SubcontractingType = SubcontractingType::Resources) then begin
            DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
            DataCostByPiecework.SETRANGE("No.", "No. Subcontracting Resource");
        end;
        if not DataCostByPiecework.FINDFIRST then begin
            DataCostByPiecework.INIT;
            DataCostByPiecework."Job No." := "Job No.";
            DataCostByPiecework."Piecework Code" := "Piecework Code";
            DataCostByPiecework."Cod. Budget" := GETFILTER("Budget Filter");
            DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Resource;
            DataCostByPiecework."No." := "No. Subcontracting Resource";
            DataCostByPiecework.VALIDATE("Analytical Concept Direct Cost", "Analytical Concept Subcon Code");
            DataCostByPiecework."Performance By Piecework" := 1;
            DataCostByPiecework."Cod. Measure Unit" := "Unit Of Measure";
            DataCostByPiecework.VALIDATE("Direc Unit Cost", "Price Subcontracting Cost");
            DataCostByPiecework.VALIDATE("Budget Cost", "Price Subcontracting Cost");
            DataCostByPiecework.Description := Description;
            DataCostByPiecework.Subcontrating := TRUE;
            DataCostByPiecework."Activity Code" := "Activity Code";//JMMA 220920
            DataCostByPiecework.INSERT;
        end else begin
            DataCostByPiecework.VALIDATE("Direc Unit Cost", "Price Subcontracting Cost");
            DataCostByPiecework.Subcontrating := TRUE;
            DataCostByPiecework.MODIFY;
        end;
    end;

    procedure ShowBudgetCost(): Decimal;
    var
        //       Job@7207270 :
        Job: Record 167;
        //       DataPieceworkForProduction@7207272 :
        DataPieceworkForProduction: Record 7207386;
        //       CostAmount@1100231000 :
        CostAmount: Decimal;
    begin
        if "Account Type" = "Account Type"::Heading then begin
            CostAmount := 0;
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
            Job.GET("Job No.");
            if GETFILTER("Budget Filter") = '' then begin
                if Job."Current Piecework Budget" <> '' then
                    DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Current Piecework Budget")
                else
                    DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Initial Budget Piecework");
            end else begin
                COPYFILTER("Budget Filter", DataPieceworkForProduction."Budget Filter")
            end;

            if DataPieceworkForProduction.FINDSET then begin
                repeat
                    COPYFILTER("Filter Date", DataPieceworkForProduction."Filter Date");
                    DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Budget Measure", DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                    CostAmount := CostAmount + DataPieceworkForProduction."Budget Measure" * DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                until DataPieceworkForProduction.NEXT = 0;
            end;
            exit(CostAmount);
        end else begin
            if GETFILTER("Budget Filter") = '' then begin
                if Job."Current Piecework Budget" <> '' then
                    SETRANGE("Budget Filter", Job."Current Piecework Budget")
                else
                    SETRANGE("Budget Filter", Job."Initial Budget Piecework");
                CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget");
                SETRANGE("Budget Filter");
            end else begin
                CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget");
            end;
            exit("Budget Measure" * "Aver. Cost Price Pend. Budget");
        end;
    end;

    procedure AmountPlan()
    var
        //       VLJob@7001100 :
        VLJob: Record 167;
        //       VLTherearelines@7001101 :
        VLTherearelines: Boolean;
        //       DataCostByPieceworkInversion@7001102 :
        DataCostByPieceworkInversion: Record 7207387;
        //       DataCostByPieceworkDirect@7001103 :
        DataCostByPieceworkDirect: Record 7207387;
        //       VLRealized@7001104 :
        VLRealized: Decimal;
        //       VDataPieceworkForProduction@7001105 :
        VDataPieceworkForProduction: Record 7207386;
        //       VLMeasureTotal@7001106 :
        VLMeasureTotal: Decimal;
        //       VLCurrentBudget@7001107 :
        VLCurrentBudget: Code[20];
        //       JobBudget@7001108 :
        JobBudget: Record 7207407;
    begin

        // Gestion de costes indirectos periodificables y los de inversion
        VLCurrentBudget := GETFILTER("Budget Filter");
        if not JobBudget.GET("Job No.", VLCurrentBudget) then
            CLEAR(JobBudget);
        if (Type = Type::"Cost Unit") then begin
            if ("Type Unit Cost" = "Type Unit Cost"::Internal) and
               ("Allocation Terms" = "Allocation Terms"::"Fixed Amount") then begin
                VLJob.GET("Job No.");
                VLJob.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));
                VLJob.CALCFIELDS("Production Budget Amount");
                CALCFIELDS("Budget Measure");
                VLMeasureTotal := "Budget Measure";
                ExpectedTimeUnitData.SETCURRENTKEY("Job No.");
                ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
                ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
                ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                ExpectedTimeUnitData.DELETEALL;
                ExpectedTimeUnitData.SETRANGE(Performed, TRUE);
                VLRealized := 0;
                if ExpectedTimeUnitData.FINDSET then
                    repeat
                        VLRealized := VLRealized + ExpectedTimeUnitData."Expected Measured Amount";
                    until ExpectedTimeUnitData.NEXT = 0;
                VLMeasureTotal := "Budget Measure" - VLRealized;
                ForecastDataAmountPiecework.RESET;
                ForecastDataAmountPiecework.SETCURRENTKEY("Job No.");
                ForecastDataAmountPiecework.SETRANGE("Job No.", "Job No.");
                ForecastDataAmountPiecework.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
                ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Incomes);
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
                ExpectedTimeUnitDataEntry.RESET;
                VLTherearelines := FALSE;
                if ExpectedTimeUnitDataEntry.FINDLAST then
                    NoEntry := ExpectedTimeUnitDataEntry."Entry No." + 1
                else
                    NoEntry := 1;
                if ForecastDataAmountPiecework.FINDSET then begin
                    repeat
                        ExpectedTimeUnitData2.INIT;
                        ExpectedTimeUnitData2."Entry No." := NoEntry;
                        ExpectedTimeUnitData2.VALIDATE("Job No.", ForecastDataAmountPiecework."Job No.");
                        if ForecastDataAmountPiecework."Expected Date" < JobBudget."Budget Date" then
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", JobBudget."Budget Date")
                        else
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", ForecastDataAmountPiecework."Expected Date");
                        ExpectedTimeUnitData2.VALIDATE("Budget Code", ForecastDataAmountPiecework."Cod. Budget");
                        ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                        ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Cost Unit";
                        if VLJob."Production Budget Amount" <> 0 then
                            ExpectedTimeUnitData2."Expected Measured Amount" := ((ForecastDataAmountPiecework.Amount / VLJob."Production Budget Amount")
                                                                     * ("Budget Measure" - VLRealized))
                        else
                            ExpectedTimeUnitData2."Expected Measured Amount" := 0;
                        ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                        ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                        if ExpectedTimeUnitData2."Expected Measured Amount" <> 0 then begin
                            ExpectedTimeUnitData2.INSERT(TRUE);
                            VLTherearelines := TRUE;
                        end;
                        NoEntry += 1;
                    until ForecastDataAmountPiecework.NEXT = 0;
                    if not VLTherearelines then begin
                        ExpectedTimeUnitData2.INIT;
                        ExpectedTimeUnitData2."Entry No." := NoEntry;
                        ExpectedTimeUnitData2.VALIDATE("Job No.", ForecastDataAmountPiecework."Job No.");
                        if ForecastDataAmountPiecework."Expected Date" < JobBudget."Budget Date" then
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", JobBudget."Budget Date")
                        else
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", ForecastDataAmountPiecework."Expected Date");
                        ExpectedTimeUnitData2.VALIDATE("Budget Code", ForecastDataAmountPiecework."Cod. Budget");
                        ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                        ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Cost Unit";
                        ExpectedTimeUnitData2."Expected Measured Amount" := "Budget Measure" - VLRealized;
                        ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                        ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                        if ExpectedTimeUnitData2."Expected Measured Amount" <> 0 then
                            ExpectedTimeUnitData2.INSERT(TRUE);
                    end;
                end;
            end;
        end;

        if (Type = Type::"Investment Unit") then begin
            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData2.RESET;
            DataCostByPieceworkInversion.RESET;
            DataCostByPieceworkInversion.RESET;
            VLJob.GET("Job No.");
            VLJob.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));
            CALCFIELDS("Budget Measure");
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.");
            ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
            ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
            ExpectedTimeUnitData.DELETEALL;
            ExpectedTimeUnitData.SETRANGE(Performed, TRUE);
            VLRealized := 0;
            if ExpectedTimeUnitData.FINDSET then
                repeat
                    VLRealized := VLRealized + ExpectedTimeUnitData."Expected Measured Amount";
                until ExpectedTimeUnitData.NEXT = 0;

            DataCostByPieceworkInversion.SETRANGE("Job No.", "Job No.");
            DataCostByPieceworkInversion.SETRANGE("Piecework Code", "Piecework Code");
            DataCostByPieceworkInversion.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            DataCostByPieceworkInversion.SETRANGE("Cost Type", DataCostByPieceworkInversion."Cost Type"::Resource);
            if DataCostByPieceworkInversion.FINDSET then
                repeat
                    if DataCostByPieceworkInversion."No." <> '' then begin
                        DataCostByPieceworkDirect.SETRANGE("Job No.", "Job No.");
                        DataCostByPieceworkDirect.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
                        DataCostByPieceworkDirect.SETRANGE("Cost Type", DataCostByPieceworkDirect."Cost Type"::Resource);
                        DataCostByPieceworkDirect.SETRANGE("No.", DataCostByPieceworkInversion."No.");
                        if DataCostByPieceworkDirect.FINDSET then
                            repeat
                                if DataCostByPieceworkDirect."Piecework Code" <> DataCostByPieceworkInversion."Piecework Code" then begin
                                    DataPieceworkForProduction.GET(DataCostByPieceworkInversion."Job No.", DataCostByPieceworkInversion."Piecework Code");

                                    ExpectedTimeUnitData2Uptake.RESET;
                                    ExpectedTimeUnitData2Uptake.SETCURRENTKEY("Job No.");
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Job No.", "Job No.");
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Piecework Code", DataCostByPieceworkDirect."Piecework Code");
                                    ExpectedTimeUnitData2Uptake.SETRANGE(Performed, FALSE);
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
                                    ExpectedTimeUnitDataEntry.RESET;
                                    VLTherearelines := FALSE;
                                    if ExpectedTimeUnitDataEntry.FINDLAST then
                                        NoEntry := ExpectedTimeUnitDataEntry."Entry No." + 1
                                    else
                                        NoEntry := 1;
                                    if ExpectedTimeUnitData2Uptake.FINDSET then begin
                                        repeat
                                            ExpectedTimeUnitData2.INIT;
                                            ExpectedTimeUnitData2."Entry No." := NoEntry;
                                            ExpectedTimeUnitData2.VALIDATE("Job No.", ExpectedTimeUnitData2Uptake."Job No.");
                                            ExpectedTimeUnitData2.VALIDATE("Expected Date", ExpectedTimeUnitData2Uptake."Expected Date");
                                            ExpectedTimeUnitData2.VALIDATE("Budget Code", ExpectedTimeUnitData2Uptake."Budget Code");
                                            ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                                            ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Investment Unit";
                                            ExpectedTimeUnitData2."Expected Measured Amount" := (ExpectedTimeUnitData2Uptake."Expected Measured Amount" *
                                                                                      DataCostByPieceworkDirect."Performance By Piecework" *
                                                                                      ("Budget Measure" - VLRealized));
                                            ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                                            ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                                            if ExpectedTimeUnitData2."Expected Measured Amount" <> 0 then begin
                                                ExpectedTimeUnitData2.INSERT(TRUE);
                                                VLTherearelines := TRUE;
                                            end;
                                            NoEntry += 1;
                                        until ExpectedTimeUnitData2Uptake.NEXT = 0;
                                    end;
                                end;
                            until DataCostByPieceworkDirect.NEXT = 0;
                    end;
                until DataCostByPieceworkInversion.NEXT = 0;
        end;
    end;

    procedure AmountCostBudget(): Decimal;
    var
        //       AmountCost@1100231000 :
        AmountCost: Decimal;
        //       VJob@1100240000 :
        VJob: Record 167;
    begin
        if "Account Type" = "Account Type"::Heading then begin
            AmountCost := 0;
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
            VJob.GET("Job No.");
            if GETFILTER("Budget Filter") = '' then begin
                if VJob."Current Piecework Budget" <> '' then
                    DataPieceworkForProduction.SETRANGE("Budget Filter", VJob."Current Piecework Budget")
                else
                    DataPieceworkForProduction.SETRANGE("Budget Filter", VJob."Initial Budget Piecework");
            end else begin
                COPYFILTER("Budget Filter", DataPieceworkForProduction."Budget Filter")
            end;
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            // if DataPieceworkForProduction.FINDSET(FALSE, FALSE) then begin
            if DataPieceworkForProduction.FINDSET(FALSE) then begin
                repeat
                    DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Budget Measure", DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                    AmountCost := AmountCost + DataPieceworkForProduction."Budget Measure" * DataPieceworkForProduction."Aver. Cost Price Pend. Budget";
                until DataPieceworkForProduction.NEXT = 0;
            end;
            "Amount Cost Budget (LCY)" := AmountCost;
            exit(AmountCost);
        end else begin
            VJob.GET("Job No.");
            if GETFILTER("Budget Filter") = '' then begin
                if VJob."Current Piecework Budget" <> '' then
                    SETRANGE("Budget Filter", VJob."Current Piecework Budget")
                else
                    SETRANGE("Budget Filter", VJob."Initial Budget Piecework");
                CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget");
                SETRANGE("Budget Filter");
            end else begin
                CALCFIELDS("Budget Measure", "Aver. Cost Price Pend. Budget");
            end;
            "Amount Cost Budget (LCY)" := "Budget Measure" * "Aver. Cost Price Pend. Budget";
            exit("Budget Measure" * "Aver. Cost Price Pend. Budget");
        end;
    end;

    procedure PendingProductionPrice(): Decimal;
    var
        //       LocRecJob@1100251000 :
        LocRecJob: Record 167;
        //       DecNotAssigAmountSales@1100251001 :
        DecNotAssigAmountSales: Decimal;
        //       RecDataCost@1100251002 :
        RecDataCost: Record 7207392;
        //       DecBudgetCost@1100251003 :
        DecBudgetCost: Decimal;
        //       DecPredUnitPte@1100251004 :
        DecPredUnitPte: Decimal;
        //       locDataPieceworkForProduction@1100251005 :
        locDataPieceworkForProduction: Record 7207386;
        //       locRelCertificationProduct@1100251007 :
        locRelCertificationProduct: Record 7207397;
        //       DecAssigAmountSale@1100251006 :
        DecAssigAmountSale: Decimal;
        //       decAux@1100286000 :
        decAux: Decimal;
    begin
        // Retorna el precio de producci�n pendiente, si no hay pendiente retorna cero
        //JAV 25/03/22: - QB 1.10.27 Si la producci�n est� al 100%, retorna el precio total no cero

        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        if Type = Type::"Cost Unit" then
            exit(0);


        CALCFIELDS("Total Measurement Production", "Amount Production Performed");
        SETRANGE("Filter Date");
        CALCFIELDS("Budget Measure");

        if "Customer Certification Unit" then begin
            if ("Budget Measure" - "Total Measurement Production") <> 0 then
                exit(("Sale Amount" - "Amount Production Performed") / ("Budget Measure" - "Total Measurement Production"))
            else
                exit(0);
        end;

        locRelCertificationProduct.SETRANGE("Job No.", "Job No.");
        locRelCertificationProduct.SETRANGE("Production Unit Code", "Piecework Code");
        //JAV 13/11/20: - QB 1.07.05 Para evitar error en el c lculo si U.O. est  en blanco
        locRelCertificationProduct.SETFILTER("Certification Unit Code", '<>%1', '');
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if locRelCertificationProduct.FINDSET(FALSE, FALSE) then
        if locRelCertificationProduct.FINDSET(FALSE) then
            repeat
                //JAV 07/06/21: - QB 1.08.48 Se a¤ade un if por si hay una unidad en blanco o eliminada
                if locDataPieceworkForProduction.GET(locRelCertificationProduct."Job No.", locRelCertificationProduct."Certification Unit Code") then begin
                    if locRelCertificationProduct."Percentage Of Assignment" <> 0 then begin
                        DecAssigAmountSale := DecAssigAmountSale +
                                             //ROUND(locDataPieceworkForProduction."Sale Amount" * locRelCertificationProduct."Percentage Of Assignment"/100,0.01);
                                             (locDataPieceworkForProduction."Sale Amount" * locRelCertificationProduct."Percentage Of Assignment" / 100);
                        //JMMA NUEVA FUNCIàN locRelCertificationProduct.CalcTotalSaleAmount("Job No.","Piecework Code");
                    end;
                end;
            until locRelCertificationProduct.NEXT = 0;

        //JAV 08/06/21: QB 1.08.48 Si la diferencia entre ambos es muy peque¤a, al usarla para dividir da un valor muy grande, redondeamos para evitarlo
        decAux := ROUND("Budget Measure" - "Total Measurement Production", Currency."Unit-Amount Rounding Precision");
        if (decAux <> 0) then begin
            DecPredUnitPte := (DecAssigAmountSale - "Amount Production Performed") / decAux;
            exit(ROUND(DecPredUnitPte, Currency."Unit-Amount Rounding Precision"));
        end else if ("Total Measurement Production" <> 0) then  //JAV 25/03/22: - QB 1.10.27 Si la producci�n est� al 100%, retorna el precio total no cero
                exit("Amount Production Performed" / "Total Measurement Production");

        exit(0);
    end;

    procedure PendingPrice(): Decimal;
    var
        //       LocRecJob@1100251000 :
        LocRecJob: Record 167;
        //       DecNotAssigAmountSales@1100251001 :
        DecNotAssigAmountSales: Decimal;
        //       RecDataCost@1100251002 :
        RecDataCost: Record 7207392;
        //       DecBudgetCost@1100251003 :
        DecBudgetCost: Decimal;
        //       DecPredUnitPte@1100251004 :
        DecPredUnitPte: Decimal;
        //       locDataPieceworkForProduction@1100251005 :
        locDataPieceworkForProduction: Record 7207386;
        //       locRelCertificationProduct@1100251007 :
        locRelCertificationProduct: Record 7207397;
        //       DecAssigAmountSale@1100251006 :
        DecAssigAmountSale: Decimal;
        //       decAux@1100286000 :
        decAux: Decimal;
    begin
        //Q18150 Q18527 Funcion copiada de PendingProductionPrice Calculo del precio pendiente sin tener en cuenta la producci�n.
        // Retorna el precio de producci�n pendiente, si no hay pendiente retorna cero
        //JAV 25/03/22: - QB 1.10.27 Si la producci�n est� al 100%, retorna el precio total no cero

        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        if Type = Type::"Cost Unit" then
            exit(0);


        CALCFIELDS("Total Measurement Production", "Amount Production Performed");
        SETRANGE("Filter Date");
        CALCFIELDS("Budget Measure");

        //Q18527 Cambiado el calculo.
        if "Customer Certification Unit" then begin
            if ("Budget Measure") <> 0 then
                exit(("Sale Amount") / ("Budget Measure"))
            else
                exit(0);
        end;

        locRelCertificationProduct.SETRANGE("Job No.", "Job No.");
        locRelCertificationProduct.SETRANGE("Production Unit Code", "Piecework Code");
        //JAV 13/11/20: - QB 1.07.05 Para evitar error en el c lculo si U.O. est  en blanco
        locRelCertificationProduct.SETFILTER("Certification Unit Code", '<>%1', '');
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if locRelCertificationProduct.FINDSET(FALSE, FALSE) then
        if locRelCertificationProduct.FINDSET(FALSE) then
            repeat
                //JAV 07/06/21: - QB 1.08.48 Se a¤ade un if por si hay una unidad en blanco o eliminada
                if locDataPieceworkForProduction.GET(locRelCertificationProduct."Job No.", locRelCertificationProduct."Certification Unit Code") then begin
                    if locRelCertificationProduct."Percentage Of Assignment" <> 0 then begin
                        DecAssigAmountSale := DecAssigAmountSale +
                                             //ROUND(locDataPieceworkForProduction."Sale Amount" * locRelCertificationProduct."Percentage Of Assignment"/100,0.01);
                                             (locDataPieceworkForProduction."Sale Amount" * locRelCertificationProduct."Percentage Of Assignment" / 100);
                        //JMMA NUEVA FUNCIàN locRelCertificationProduct.CalcTotalSaleAmount("Job No.","Piecework Code");
                    end;
                end;
            until locRelCertificationProduct.NEXT = 0;

        //Q18527 Cambiado el calculo.
        //JAV 08/06/21: QB 1.08.48 Si la diferencia entre ambos es muy peque¤a, al usarla para dividir da un valor muy grande, redondeamos para evitarlo
        decAux := ROUND("Budget Measure", Currency."Unit-Amount Rounding Precision");
        if (decAux <> 0) then begin
            DecPredUnitPte := (DecAssigAmountSale) / decAux;
            exit(ROUND(DecPredUnitPte, Currency."Unit-Amount Rounding Precision"));
        end else if ("Total Measurement Production" <> 0) then  //JAV 25/03/22: - QB 1.10.27 Si la producci�n est� al 100%, retorna el precio total no cero
                exit("Amount Production Performed" / "Total Measurement Production");

        exit(0);
    end;

    //     procedure AmountCostTheoreticalProduction (PBudgetinProgress@1100251000 : Code[20];var PDataPieceworkForProduction@1100251001 :
    procedure AmountCostTheoreticalProduction(PBudgetinProgress: Code[20]; var PDataPieceworkForProduction: Record 7207386): Decimal;
    var
        //       LDataPieceworkForProduction@1100281000 :
        LDataPieceworkForProduction: Record 7207386;
        //       LDataPieceworkForProduction2@1100251002 :
        LDataPieceworkForProduction2: Record 7207386;
        //       ForecastDataAmountPiecework@1100251003 :
        ForecastDataAmountPiecework: Record 7207392;
        //       ExpectedTimeUnitData@1100251004 :
        ExpectedTimeUnitData: Record 7207388;
        //       JobBudget@1100251005 :
        JobBudget: Record 7207407;
        //       LAmountCost@1100251006 :
        LAmountCost: Decimal;
    begin

        if PDataPieceworkForProduction."Account Type" = PDataPieceworkForProduction."Account Type"::Heading then begin
            LAmountCost := 0;
            LDataPieceworkForProduction.COPYFILTERS(PDataPieceworkForProduction);
            LDataPieceworkForProduction.SETRANGE("Job No.", PDataPieceworkForProduction."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", PDataPieceworkForProduction.Totaling);
            LDataPieceworkForProduction.SETRANGE("Budget Filter", PBudgetinProgress);
            LDataPieceworkForProduction.SETRANGE("Account Type", PDataPieceworkForProduction."Account Type"::Unit);
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            // if LDataPieceworkForProduction.FINDSET(FALSE, FALSE) then begin
            if LDataPieceworkForProduction.FINDSET(FALSE) then begin
                repeat
                    LAmountCost := LAmountCost + LDataPieceworkForProduction.AmountCostTheoreticalProduction(PBudgetinProgress, LDataPieceworkForProduction);
                until LDataPieceworkForProduction.NEXT = 0;
            end;
            exit(LAmountCost);
        end;

        if PDataPieceworkForProduction."Account Type" = PDataPieceworkForProduction."Account Type"::Unit then begin
            LAmountCost := 0;
            LDataPieceworkForProduction.SETRANGE("Job No.", PDataPieceworkForProduction."Job No.");
            LDataPieceworkForProduction.SETRANGE("Piecework Code", PDataPieceworkForProduction."Piecework Code");
            if LDataPieceworkForProduction.FINDSET then begin
                LDataPieceworkForProduction.SETRANGE("Budget Filter", PBudgetinProgress);
                LDataPieceworkForProduction.SETFILTER("Filter Date", PDataPieceworkForProduction.GETFILTER("Filter Date"));
                LDataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget", "Total Measurement Production");
                // buscamos el presupuesto hasta fecha reestimaci¢n
                ForecastDataAmountPiecework.SETCURRENTKEY("Entry Type", "Job No.", "Piecework Code", "Cod. Budget",
                                                  "Analytical Concept", "Expected Date", "Unit Type", Performed);

                ForecastDataAmountPiecework.SETRANGE("Job No.", PDataPieceworkForProduction."Job No.");
                ForecastDataAmountPiecework.SETFILTER("Expected Date", PDataPieceworkForProduction.GETFILTER("Filter Date"));
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", PBudgetinProgress);
                ForecastDataAmountPiecework.SETRANGE("Piecework Code", PDataPieceworkForProduction."Piecework Code");
                ForecastDataAmountPiecework.SETRANGE(Performed, TRUE);
                ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                ForecastDataAmountPiecework.CALCSUMS(ForecastDataAmountPiecework.Amount);
                LAmountCost := ForecastDataAmountPiecework.Amount;

                // buscamos las cantidades hasta la fecha de reestimaci¢n
                ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code", "Expected Date", Performed);
                ExpectedTimeUnitData.SETRANGE("Job No.", PDataPieceworkForProduction."Job No.");
                ExpectedTimeUnitData.SETFILTER("Expected Date", PDataPieceworkForProduction.GETFILTER("Filter Date"));
                ExpectedTimeUnitData.SETRANGE("Budget Code", PBudgetinProgress);
                ExpectedTimeUnitData.SETRANGE("Piecework Code", PDataPieceworkForProduction."Piecework Code");
                ExpectedTimeUnitData.SETRANGE(Performed, TRUE);
                ExpectedTimeUnitData.CALCSUMS("Expected Measured Amount");
                if LDataPieceworkForProduction."Total Measurement Production" > ExpectedTimeUnitData."Expected Measured Amount" then begin
                    LAmountCost := LAmountCost +
                                               ((LDataPieceworkForProduction."Total Measurement Production" - ExpectedTimeUnitData."Expected Measured Amount")
                                                     * LDataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                end;
            end;
            exit(LAmountCost);
        end;
    end;

    //     procedure CalculateDesviationPercentage (PCostTheorical@1100281000 : Decimal;PCostReal@1100281001 :
    procedure CalculateDesviationPercentage(PCostTheorical: Decimal; PCostReal: Decimal): Decimal;
    var
        //       RelCertificationProduct@1100003 :
        RelCertificationProduct: Record 7207397;
        //       DataPieceworkForProduction@1100002 :
        DataPieceworkForProduction: Record 7207386;
        //       AmountCostProduction@1100001 :
        AmountCostProduction: Decimal;
    begin
        if "Production Unit" then begin
            if PCostTheorical <> 0 then
                exit(ROUND(((PCostReal - PCostTheorical) * 100 / PCostTheorical), 0.01))
            else
                exit(0);
        end else
            exit(0);
    end;

    procedure CalculateMarginRealPercentage(): Decimal;
    var
        //       RelCertificationProduct@1100003 :
        RelCertificationProduct: Record 7207397;
        //       DataPieceworkForProduction@1100002 :
        DataPieceworkForProduction: Record 7207386;
        //       AmountCostProduction@1100001 :
        AmountCostProduction: Decimal;
    begin
        if "Production Unit" then begin
            CALCFIELDS("Amount Production Performed", "Amount Cost Performed (LCY)");
            if "Amount Production Performed" <> 0 then
                exit(ROUND((("Amount Production Performed" - "Amount Cost Performed (LCY)") * 100 / "Amount Production Performed"), 0.01))
            else
                exit(0);
        end else
            exit(0);
    end;

    procedure AdvanceProductionPercentage(): Decimal;
    var
        //       RelCertificationProduct@1100003 :
        RelCertificationProduct: Record 7207397;
        //       DataPieceworkForProduction@1100002 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProductionCertification@1100251001 :
        DataPieceworkForProductionCertification: Record 7207386;
        //       AmountBudget@1100001 :
        AmountBudget: Decimal;
        //       AmountRealized@1100251000 :
        AmountRealized: Decimal;
        //       Job@1100251002 :
        Job: Record 167;
    begin
        if "Production Unit" then begin
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProductionCertification."Account Type"::Unit);
            DataPieceworkForProduction.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));
            DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
            if "Account Type" = "Account Type"::Unit then
                DataPieceworkForProduction.SETRANGE("Piecework Code", "Piecework Code")
            else
                DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            if DataPieceworkForProduction.FINDFIRST then
                repeat
                    DataPieceworkForProduction.SETRANGE("Filter Date");
                    DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                    AmountBudget := AmountBudget + DataPieceworkForProduction."Amount Production Budget";

                    DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
                    DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                    AmountRealized := AmountRealized + DataPieceworkForProduction."Amount Production Performed";
                until DataPieceworkForProduction.NEXT = 0;
            if AmountBudget <> 0 then
                exit(ROUND(((AmountRealized) * 100 / AmountBudget), 0.01))
            else
                exit(0);
        end else begin
            Job.GET("Job No.");
            DataPieceworkForProductionCertification.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProductionCertification.SETRANGE("Account Type", DataPieceworkForProductionCertification."Account Type"::Unit);
            if "Account Type" = "Account Type"::Unit then
                DataPieceworkForProductionCertification.SETRANGE("Piecework Code", "Piecework Code")
            else
                DataPieceworkForProductionCertification.SETFILTER("Piecework Code", Totaling);
            if DataPieceworkForProductionCertification.FINDFIRST then
                repeat
                    RelCertificationProduct.SETRANGE("Job No.", "Job No.");
                    RelCertificationProduct.SETRANGE("Certification Unit Code", DataPieceworkForProductionCertification."Piecework Code");
                    if RelCertificationProduct.FINDFIRST then
                        repeat
                            //JAV 07/06/21: - QB 1.08.48 Se a¤ade un if por si hay una unidad en blanco o eliminada
                            if DataPieceworkForProduction.GET(RelCertificationProduct."Job No.", RelCertificationProduct."Production Unit Code") then begin
                                DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                                DataPieceworkForProduction.SETRANGE("Filter Date");
                                DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                                if DataPieceworkForProduction."Amount Production Budget" <> 0 then begin
                                    AmountBudget := AmountBudget + DataPieceworkForProduction."Amount Production Budget" *
                                          (DataPieceworkForProductionCertification."Sale Amount" *
                                          (RelCertificationProduct."Percentage Of Assignment" / 100) / DataPieceworkForProduction."Amount Production Budget");

                                    DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
                                    DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                                    AmountRealized := AmountRealized + DataPieceworkForProduction."Amount Production Performed" *
                                             (DataPieceworkForProductionCertification."Sale Amount" *
                                             (RelCertificationProduct."Percentage Of Assignment" / 100) / DataPieceworkForProduction."Amount Production Budget");
                                end;
                            end;
                        until RelCertificationProduct.NEXT = 0;
                until DataPieceworkForProductionCertification.NEXT = 0;
            if AmountBudget <> 0 then
                exit(ROUND(((AmountRealized) * 100 / AmountBudget), 0.01))
            else
                exit(0);
        end;
    end;

    procedure CalculateAmountMeasureSubcontrating(): Decimal;
    var
        //       LPurchRcptLine@1000000000 :
        LPurchRcptLine: Record 121;
        //       AmountShipmentPurchase@1000000001 :
        AmountShipmentPurchase: Decimal;
        //       LDataPieceworkForProduction@1100231000 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        //con esta funci¢n nos recorremos el hist. alb compra y por cada registro calculamos la funci¢n que tendr  en cuenta el valor de la
        //funci¢n del hist¢rico pero este dato SE VA A TENER EN CUENTA PARA LA PESTA¥A DE COMPRAS
        LPurchRcptLine.RESET;
        LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");       //-- TO-DO: Esta key no existe

        if "Account Type" = "Account Type"::Unit then begin
            AmountShipmentPurchase := 0;
            LPurchRcptLine.SETRANGE(LPurchRcptLine."Job No.", "Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº", "Piecework Code");
            LPurchRcptLine.SETRANGE(Type, 6);
            LPurchRcptLine.SETRANGE("No.", "No. Subcontracting Resource");
            COPYFILTER("Filter Date", LPurchRcptLine."Order Date");
            if LPurchRcptLine.FINDSET then begin
                repeat
                    AmountShipmentPurchase += LPurchRcptLine."QB Amount not Invoiced (LCY)";
                until LPurchRcptLine.NEXT = 0;
            end;
            exit(AmountShipmentPurchase);
        end else begin
            AmountShipmentPurchase := 0;
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LPurchRcptLine.SETRANGE(LPurchRcptLine."Job No.", "Job No.");
                    LPurchRcptLine.SETRANGE("Piecework NÂº", LDataPieceworkForProduction."Piecework Code");
                    //To be Tested
                    LPurchRcptLine.SETRANGE(Type, 6);
                    LPurchRcptLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    COPYFILTER("Filter Date", LPurchRcptLine."Order Date");
                    if LPurchRcptLine.FINDSET then begin
                        repeat
                            AmountShipmentPurchase := LPurchRcptLine."QB Amount not Invoiced (LCY)";
                        until LPurchRcptLine.NEXT = 0;
                    end;
                until LDataPieceworkForProduction.NEXT = 0;
            exit(AmountShipmentPurchase);
        end;
    end;

    procedure CaculateQuantityMeasureSubcontrating(): Decimal;
    var
        //       QuantityChapter@1100231000 :
        QuantityChapter: Decimal;
        //       LDataPieceworkForProduction@1100231001 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        // Con esta funci¢n nos recorremos el hist. alb compra y por cada registro calculamos la funci¢n que tendr  en cuenta el valor de la
        // funci¢n del hist¢rico pero este dato SE VA A TENER EN CUENTA PARA LA PESTA¥A DE COMPRAS
        if "Account Type" = "Account Type"::Unit then begin
            CALCFIELDS("Measured Qty Subc. Piecework");
            QuantityChapter := "Measured Qty Subc. Piecework";
            exit(QuantityChapter);
        end else begin
            QuantityChapter := 0;
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LDataPieceworkForProduction.CALCFIELDS("Measured Qty Subc. Piecework");
                    QuantityChapter := QuantityChapter + LDataPieceworkForProduction."Measured Qty Subc. Piecework";
                until LDataPieceworkForProduction.NEXT = 0;
            exit(QuantityChapter);
        end;
    end;

    procedure CalculateQuantityInvoicedSubcontrating(): Decimal;
    var
        //       QuantityChapter@1100231000 :
        QuantityChapter: Decimal;
        //       LDataPieceworkForProduction@1100231001 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        // con esta funci¢n nos recorremos el hist. alb compra y por cada registro calculamos la funci¢n que tendr  en cuenta el valor de la
        // funci¢n del hist¢rico pero este dato SE VA A TENER EN CUENTA PARA LA PESTA¥A DE COMPRAS
        if "Account Type" = "Account Type"::Unit then begin
            CALCFIELDS("Certified Qty Subc. Piecework");
            QuantityChapter := "Certified Qty Subc. Piecework";
            exit(QuantityChapter);
        end else begin
            QuantityChapter := 0;
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            // if LDataPieceworkForProduction.FINDSET(FALSE, FALSE) then
            if LDataPieceworkForProduction.FINDSET(FALSE) then
                repeat
                    LDataPieceworkForProduction.CALCFIELDS("Certified Qty Subc. Piecework");
                    QuantityChapter := QuantityChapter + LDataPieceworkForProduction."Certified Qty Subc. Piecework";
                until LDataPieceworkForProduction.NEXT = 0;
            exit(QuantityChapter);
        end;
    end;

    procedure CalculateQuantityCreditMemoSubcontrating(): Decimal;
    var
        //       QuantityChapter@1100231000 :
        QuantityChapter: Decimal;
        //       LDataPieceworkForProduction@1100231001 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        //con esta funci¢n nos recorremos el hist. alb compra y por cada registro calculamos la funci¢n que tendr  en cuenta el valor de la
        //funci¢n del hist¢rico pero este dato SE VA A TENER EN CUENTA PARA LA PESTA¥A DE COMPRAS
        if "Account Type" = "Account Type"::Unit then begin
            CALCFIELDS("Quantity Paid Subcon Piecework");
            QuantityChapter := "Quantity Paid Subcon Piecework";
            exit(QuantityChapter);
        end else begin
            QuantityChapter := 0;
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            //if LDataPieceworkForProduction.FINDSET(FALSE, FALSE) then
            if LDataPieceworkForProduction.FINDSET(FALSE) then
                repeat
                    LDataPieceworkForProduction.CALCFIELDS("Quantity Paid Subcon Piecework");
                    QuantityChapter := QuantityChapter + LDataPieceworkForProduction."Quantity Paid Subcon Piecework";
                until LDataPieceworkForProduction.NEXT = 0;
            exit(QuantityChapter);
        end;
    end;

    procedure CalculateAmountInvoicedSubcontrating(): Decimal;
    var
        //       QuantityChapter@1100231000 :
        QuantityChapter: Decimal;
        //       LDataPieceworkForProduction@1100231001 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        // con esta funci¢n nos recorremos el hist. alb compra y por cada registro calculamos la funci¢n que tendr  en cuenta el valor de la
        // funci¢n del hist¢rico pero este dato SE VA A TENER EN CUENTA PARA LA PESTA¥A DE COMPRAS
        if "Account Type" = "Account Type"::Unit then begin
            CALCFIELDS("Certified Amt. Subc. Piecework");
            QuantityChapter := "Certified Amt. Subc. Piecework";
            exit(QuantityChapter);
        end else begin
            QuantityChapter := 0;
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            // if LDataPieceworkForProduction.FINDSET(FALSE, FALSE) then
            if LDataPieceworkForProduction.FINDSET(FALSE) then
                repeat
                    LDataPieceworkForProduction.CALCFIELDS("Certified Amt. Subc. Piecework");
                    QuantityChapter := QuantityChapter + LDataPieceworkForProduction."Certified Amt. Subc. Piecework";
                until LDataPieceworkForProduction.NEXT = 0;
            exit(QuantityChapter);
        end;
    end;

    procedure CalculateAmountCreditAmountSubcontrating(): Decimal;
    var
        //       QuantityChapter@1100231000 :
        QuantityChapter: Decimal;
        //       LDataPieceworkForProduction@1100231001 :
        LDataPieceworkForProduction: Record 7207386;
    begin
        // con esta funci¢n nos recorremos el hist. alb compra y por cada registro calculamos la funci¢n que tendr  en cuenta el valor de la
        // funci¢n del hist¢rico pero este dato SE VA A TENER EN CUENTA PARA LA PESTA¥A DE COMPRAS
        if "Account Type" = "Account Type"::Unit then begin
            CALCFIELDS("Amount Paid Subcon Piecework");
            QuantityChapter := "Amount Paid Subcon Piecework";
            exit(QuantityChapter);
        end else begin
            QuantityChapter := 0;
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            // if LDataPieceworkForProduction.FINDSET(FALSE, FALSE) then
            if LDataPieceworkForProduction.FINDSET(FALSE) then
                repeat
                    LDataPieceworkForProduction.CALCFIELDS("Amount Paid Subcon Piecework");
                    QuantityChapter := QuantityChapter + LDataPieceworkForProduction."Amount Paid Subcon Piecework";
                until LDataPieceworkForProduction.NEXT = 0;
            exit(QuantityChapter);
        end;
    end;

    procedure PlanQuantity()
    var
        //       LJob@1100251000 :
        LJob: Record 167;
        //       ThereareLine@1100000 :
        ThereareLine: Boolean;
        //       DataCostByPieceworkInvestment@1100002 :
        DataCostByPieceworkInvestment: Record 7207387;
        //       DataCostByPieceworkDirect@1100001 :
        DataCostByPieceworkDirect: Record 7207387;
        //       LPerformed@1100003 :
        LPerformed: Decimal;
        //       LDataPieceworkForProduction@1100004 :
        LDataPieceworkForProduction: Record 7207386;
        //       LMeasureTotal@1100251001 :
        LMeasureTotal: Decimal;
        //       LJobBudget@1100251002 :
        LJobBudget: Record 7207407;
        //       LBudgetinProgress@1100251003 :
        LBudgetinProgress: Code[20];
    begin
        // Gestion de costes indirectos periodificables y los de inversion
        LBudgetinProgress := GETFILTER("Budget Filter");
        if not LJobBudget.GET("Job No.", LBudgetinProgress) then
            CLEAR(LJobBudget);
        if (Type = Type::"Cost Unit") then begin
            if ("Type Unit Cost" = "Type Unit Cost"::Internal) and
               ("Allocation Terms" = "Allocation Terms"::"Fixed Amount") then begin
                LJob.GET("Job No.");
                LJob.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));
                LJob.CALCFIELDS("Production Budget Amount");
                CALCFIELDS("Budget Measure");
                LMeasureTotal := "Budget Measure";
                ExpectedTimeUnitData.SETCURRENTKEY("Job No.");
                ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
                ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
                ExpectedTimeUnitData.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
                ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                ExpectedTimeUnitData.DELETEALL;
                ExpectedTimeUnitData.SETRANGE(Performed, TRUE);
                LPerformed := 0;
                if ExpectedTimeUnitData.FINDSET then
                    repeat
                        LPerformed := LPerformed + ExpectedTimeUnitData."Expected Measured Amount";
                    until ExpectedTimeUnitData.NEXT = 0;
                LMeasureTotal := "Budget Measure" - LPerformed;
                ForecastDataAmountPieceworkAmount.RESET;
                ForecastDataAmountPieceworkAmount.SETCURRENTKEY("Job No.");
                ForecastDataAmountPieceworkAmount.SETRANGE("Job No.", "Job No.");
                ForecastDataAmountPieceworkAmount.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
                ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
                ForecastDataAmountPieceworkAmount.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
                ExpectedTimeUnitDataEntry.RESET;
                ThereareLine := FALSE;
                if ExpectedTimeUnitDataEntry.FINDLAST then
                    NoEntry := ExpectedTimeUnitDataEntry."Entry No." + 1
                else
                    NoEntry := 1;
                if ForecastDataAmountPieceworkAmount.FINDSET then begin
                    repeat
                        ExpectedTimeUnitData2.INIT;
                        ExpectedTimeUnitData2."Entry No." := NoEntry;
                        ExpectedTimeUnitData2.VALIDATE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                        if ForecastDataAmountPieceworkAmount."Expected Date" < LJobBudget."Budget Date" then
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", LJobBudget."Budget Date")
                        else
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", ForecastDataAmountPieceworkAmount."Expected Date");
                        ExpectedTimeUnitData2.VALIDATE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                        ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                        ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Cost Unit";
                        if LJob."Production Budget Amount" <> 0 then
                            ExpectedTimeUnitData2."Expected Measured Amount" := ((ForecastDataAmountPieceworkAmount.Amount / LJob."Production Budget Amount")
                                                                     * ("Budget Measure" - LPerformed))
                        else
                            ExpectedTimeUnitData2."Expected Measured Amount" := 0;
                        ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                        ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                        if ExpectedTimeUnitData2."Expected Measured Amount" <> 0 then begin
                            ExpectedTimeUnitData2.INSERT(TRUE);
                            ThereareLine := TRUE;
                        end;
                        NoEntry += 1;
                    until ForecastDataAmountPieceworkAmount.NEXT = 0;
                    if not ThereareLine then begin
                        ExpectedTimeUnitData2.INIT;
                        ExpectedTimeUnitData2."Entry No." := NoEntry;
                        ExpectedTimeUnitData2.VALIDATE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                        if ForecastDataAmountPieceworkAmount."Expected Date" < LJobBudget."Budget Date" then
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", LJobBudget."Budget Date")
                        else
                            ExpectedTimeUnitData2.VALIDATE("Expected Date", ForecastDataAmountPieceworkAmount."Expected Date");
                        ExpectedTimeUnitData2.VALIDATE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                        ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                        ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Cost Unit";
                        ExpectedTimeUnitData2."Expected Measured Amount" := "Budget Measure" - LPerformed;
                        ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                        ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                        if ExpectedTimeUnitData2."Expected Measured Amount" <> 0 then
                            ExpectedTimeUnitData2.INSERT(TRUE);
                    end;
                end;
            end;
        end;

        if (Type = Type::"Investment Unit") then begin
            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData2.RESET;
            DataCostByPieceworkDirect.RESET;
            DataCostByPieceworkInvestment.RESET;
            LJob.GET("Job No.");
            LJob.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));
            CALCFIELDS("Budget Measure");
            ExpectedTimeUnitData.SETCURRENTKEY("Job No.");
            ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
            ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
            ExpectedTimeUnitData.DELETEALL;
            ExpectedTimeUnitData.SETRANGE(Performed, TRUE);
            LPerformed := 0;
            if ExpectedTimeUnitData.FINDSET then
                repeat
                    LPerformed := LPerformed + ExpectedTimeUnitData."Expected Measured Amount";
                until ExpectedTimeUnitData.NEXT = 0;

            DataCostByPieceworkInvestment.SETRANGE("Job No.", "Job No.");
            DataCostByPieceworkInvestment.SETRANGE("Piecework Code", "Piecework Code");
            DataCostByPieceworkInvestment.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            DataCostByPieceworkInvestment.SETRANGE("Cost Type", DataCostByPieceworkInvestment."Cost Type"::Resource);
            if DataCostByPieceworkInvestment.FINDSET then
                repeat
                    if DataCostByPieceworkInvestment."No." <> '' then begin
                        DataCostByPieceworkDirect.SETRANGE("Job No.", "Job No.");
                        DataCostByPieceworkDirect.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
                        DataCostByPieceworkDirect.SETRANGE("Cost Type", DataCostByPieceworkDirect."Cost Type"::Resource);
                        DataCostByPieceworkDirect.SETRANGE("No.", DataCostByPieceworkInvestment."No.");
                        if DataCostByPieceworkDirect.FINDSET then
                            repeat
                                if DataCostByPieceworkDirect."Piecework Code" <> DataCostByPieceworkInvestment."Piecework Code" then begin
                                    LDataPieceworkForProduction.GET(DataCostByPieceworkInvestment."Job No.", DataCostByPieceworkInvestment."Piecework Code");

                                    ExpectedTimeUnitData2Uptake.RESET;
                                    ExpectedTimeUnitData2Uptake.SETCURRENTKEY("Job No.");
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Job No.", "Job No.");
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Piecework Code", DataCostByPieceworkDirect."Piecework Code");
                                    ExpectedTimeUnitData2Uptake.SETRANGE(Performed, FALSE);
                                    ExpectedTimeUnitData2Uptake.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
                                    ExpectedTimeUnitDataEntry.RESET;
                                    ThereareLine := FALSE;
                                    if ExpectedTimeUnitDataEntry.FINDLAST then
                                        NoEntry := ExpectedTimeUnitDataEntry."Entry No." + 1
                                    else
                                        NoEntry := 1;
                                    if ExpectedTimeUnitData2Uptake.FINDSET then begin
                                        repeat
                                            ExpectedTimeUnitData2.INIT;
                                            ExpectedTimeUnitData2."Entry No." := NoEntry;
                                            ExpectedTimeUnitData2.VALIDATE("Job No.", ExpectedTimeUnitData2Uptake."Job No.");
                                            ExpectedTimeUnitData2.VALIDATE("Expected Date", ExpectedTimeUnitData2Uptake."Expected Date");
                                            ExpectedTimeUnitData2.VALIDATE("Budget Code", ExpectedTimeUnitData2Uptake."Budget Code");
                                            ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                                            ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Investment Unit";
                                            ExpectedTimeUnitData2."Expected Measured Amount" := (ExpectedTimeUnitData2Uptake."Expected Measured Amount" *
                                                                                      DataCostByPieceworkDirect."Performance By Piecework" *
                                                                                      ("Budget Measure" - LPerformed));
                                            ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                                            ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                                            if ExpectedTimeUnitData2."Expected Measured Amount" <> 0 then begin
                                                ExpectedTimeUnitData2.INSERT(TRUE);
                                                ThereareLine := TRUE;
                                            end;
                                            NoEntry += 1;
                                        until ExpectedTimeUnitData2Uptake.NEXT = 0;
                                    end;
                                end;
                            until DataCostByPieceworkDirect.NEXT = 0;
                    end;
                until DataCostByPieceworkInvestment.NEXT = 0;
        end;
    end;

    procedure UpdateMeasurementByPercentage()
    var
        //       CoefJV@1000000000 :
        CoefJV: Decimal;
        //       JobBudget@1000000001 :
        JobBudget: Record 7207407;
        //       CalcPercentage@1100286000 :
        CalcPercentage: Decimal;
        //       GeneralLedgerSetup@1100286001 :
        GeneralLedgerSetup: Record 98;
        //       Differences@1100286002 :
        Differences: Decimal;
        //       Suma@1100286003 :
        Suma: Decimal;
    begin
        // Precondici¢n.
        //-Q18150 Funcion retocada para que reparta de todos los porcentuales la producci�n o los costes. Lo que corresponda.

        if ("Allocation Terms" IN ["Allocation Terms"::"% on Production", "Allocation Terms"::"% on Direct Costs"]) then begin
            GeneralLedgerSetup.GET;
            //if (Rec."% Expense Cost" = 0) then    //Si el procentaje es cero no hay que recalcular nada
            //  exit;
            if ("% Expense Cost" <> 0) then begin
                CalcBase(Rec, "Allocation Terms", 1);
                CalcPercentage := "% Expense Cost" / 100;
                "Cost Amount Base" := 0;
                "Cost Amount Base" := "% Expense Cost Amount Base" * CalcPercentage;
            end
            else begin
                CalcBase(Rec, "Allocation Terms", 1);
                CALCFIELDS("Amount Cost Budget", "Amount Production Budget", "Measure Pending Budget");

                if "% Expense Cost Amount Base" <> 0 then CalcPercentage := "Cost Amount Base" / "% Expense Cost Amount Base";
                if "Cost Amount Base" = 0 then "Cost Amount Base" := "% Expense Cost Amount Base" * CalcPercentage;
            end;
            //JAV 18/05/22: - Qb 1.10.42 Como recalculamos la medici�n,el importe ya no sirve y se borra tambi�n
            ForecastDataAmountPiecework.RESET;
            ForecastDataAmountPiecework.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountPiecework.SETRANGE("Piecework Code", "Piecework Code");
            ForecastDataAmountPiecework.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
            ForecastDataAmountPiecework.SETRANGE(Performed, FALSE); //AML 26/6/23 No borramos los producidos.
            ForecastDataAmountPiecework.DELETEALL;

            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
            ExpectedTimeUnitData.SETRANGE(Performed, FALSE); //AML 26/6/23 Solo los no producidos
            ExpectedTimeUnitData.DELETEALL;

            //JMMA 03/12/20 Calcular porcentaje de la UTE
            CoefJV := 1;
            Job.RESET;//JMMA 130121 Corregir incidencia cuando hay m s de dos unidades externas.
            if Job.GET(Rec."Job No.") then
                if "Over JV Production" then begin
                    Job.TESTFIELD("Job UTE");
                    if JobBudget.GET(Job."No.", GETFILTER("Budget Filter")) then begin
                        Job.CALCFIELDS("Production Budget Amount (JC)");
                        Job.SETRANGE("Posting Date Filter", 0D, JobBudget."Budget Date");
                        Job.CALCFIELDS("Actual Production Amount (JC)");
                        CoefJV := 1;
                        if Job."Production Budget Amount (JC)" <> 0 then
                            CoefJV := (Job.ProdAmountUTE - Job.ActualProdAmountUTE) / (Job."Production Budget Amount (JC)" - Job."Actual Production Amount (JC)");
                    end;
                end;

            //JAV 17/05/22: - QB 1.10.42 Inicializar datos. Se reubica el buscar el �ltimo registro de la tabla para que est� mas claro el c�digo
            Rec."% Expense Cost Amount Base" := 0;

            ExpectedTimeUnitDataEntry.RESET;
            if ExpectedTimeUnitDataEntry.FINDLAST then
                NoEntry := ExpectedTimeUnitDataEntry."Entry No." + 1
            else
                NoEntry := 1;

            //Recorrer los registros de ingresos creando los importes
            ForecastDataAmountPieceworkAmount.RESET;
            ForecastDataAmountPieceworkAmount.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountPieceworkAmount.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
            ForecastDataAmountPieceworkAmount.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            if not "Periodic Cost" then ForecastDataAmountPieceworkAmount.SETRANGE(Performed, FALSE);  //AML 20/06/23 Vuelto a poner para que solo tenga en cuenta el pendiente para los periodificables.
            CASE "Allocation Terms" OF
                "Allocation Terms"::"% on Production":
                    ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Incomes);
                "Allocation Terms"::"% on Direct Costs":
                    ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
            end;
            ForecastDataAmountPieceworkAmount.CALCSUMS(Amount);
            Rec."% Expense Cost Amount Base" := ForecastDataAmountPieceworkAmount.Amount;

            ForecastDataAmountPieceworkAmount.RESET;
            ForecastDataAmountPieceworkAmount.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountPieceworkAmount.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
            ForecastDataAmountPieceworkAmount.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            ForecastDataAmountPieceworkAmount.SETRANGE(Performed, FALSE);  //AML 20/06/23 Vuelto a poner para que solo tenga en cuenta el pendiente.
            CASE "Allocation Terms" OF
                "Allocation Terms"::"% on Production":
                    ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Incomes);
                "Allocation Terms"::"% on Direct Costs":
                    ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
            end;

            if ForecastDataAmountPieceworkAmount.FINDSET then
                repeat
                    //JAV 17/05/22: - QB 1.10.43 Sumar el importe base para el c�lculo del %
                    //Rec."% Expense Cost Amount Base" += ForecastDataAmountPieceworkAmount.Amount;


                    //JAV 16/05/22: - QB 1.10.43 Sumar en un solo registro por fecha, si no produce demasiados registros que no se puede seguir
                    ExpectedTimeUnitData2.RESET;
                    ExpectedTimeUnitData2.SETRANGE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                    ExpectedTimeUnitData2.SETRANGE("Expected Date", Job."Starting Date"); // ForecastDataAmountPieceworkAmount."Expected Date");
                    ExpectedTimeUnitData2.SETRANGE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                    ExpectedTimeUnitData2.SETRANGE("Piecework Code", "Piecework Code");
                    if (ExpectedTimeUnitData2.FINDFIRST) then begin
                        //ExpectedTimeUnitData2."Expected Measured Amount" += (CoefJV*ForecastDataAmountPieceworkAmount.Amount * ("% Expense Cost" / 100));
                        ExpectedTimeUnitData2."Expected Measured Amount" += ROUND(CoefJV * ForecastDataAmountPieceworkAmount.Amount * CalcPercentage, GeneralLedgerSetup."Amount Rounding Precision");
                        ExpectedTimeUnitData2.MODIFY(TRUE);
                    end else begin
                        ExpectedTimeUnitData2.INIT;
                        ExpectedTimeUnitData2."Entry No." := NoEntry;
                        ExpectedTimeUnitData2.VALIDATE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                        ExpectedTimeUnitData2.VALIDATE("Expected Date", Job."Starting Date"); // ForecastDataAmountPieceworkAmount."Expected Date");
                        ExpectedTimeUnitData2.VALIDATE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                        ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                        ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Cost Unit";
                        //JMMA 031220 PRODUTE ExpectedTimeUnitData2."Expected Measured Amount" := (ForecastDataAmountPieceworkAmount.Amount * ("% Expense Cost" / 100));
                        //ExpectedTimeUnitData2."Expected Measured Amount" := (CoefJV*ForecastDataAmountPieceworkAmount.Amount * ("% Expense Cost" / 100));
                        ExpectedTimeUnitData2."Expected Measured Amount" := ROUND(CoefJV * ForecastDataAmountPieceworkAmount.Amount * CalcPercentage, GeneralLedgerSetup."Amount Rounding Precision");
                        ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                        ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                        ExpectedTimeUnitData2.Performed := FALSE;
                        ExpectedTimeUnitData2.INSERT(TRUE);
                        NoEntry += 1;
                    end;
                until ForecastDataAmountPieceworkAmount.NEXT = 0;
            if "Periodic Cost" then begin  //Solo para internos.
                ExpectedTimeUnitData2.RESET;
                ExpectedTimeUnitData2.SETRANGE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                ExpectedTimeUnitData2.SETRANGE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                ExpectedTimeUnitData2.SETRANGE("Piecework Code", "Piecework Code");
                ExpectedTimeUnitData2.CALCSUMS("Expected Measured Amount");
                if "Cost Amount Base" <> ExpectedTimeUnitData2."Expected Measured Amount" then begin
                    Differences := "Cost Amount Base" - ExpectedTimeUnitData2."Expected Measured Amount";
                    if ExpectedTimeUnitData2.FINDLAST then begin
                        ExpectedTimeUnitData2."Expected Measured Amount" += Differences;
                        ExpectedTimeUnitData2.MODIFY;
                    end;
                end;
            end;
            //if "% Expense Cost" <> 0 then "Cost Amount Base" := ROUND(Rec."% Expense Cost Amount Base" * ("% Expense Cost" / 100),GeneralLedgerSetup."Amount Rounding Precision");
        end;

        //JAV 17/05/22: - QB 1.10.43 Guardar el importe base para el c�lculo del %. Como se ha recalculado ya no hay distribuci�n temporal, y en los porcentuales no tiene sentido, quito las fechas
        Rec."Date init" := 0D;
        Rec."Date end" := 0D;
        Rec.MODIFY(FALSE);
    end;

    procedure UpdateMeasurementByPercentageBAK()
    var
        //       CoefJV@1000000000 :
        CoefJV: Decimal;
        //       JobBudget@1000000001 :
        JobBudget: Record 7207407;
    begin
        // Precondici¢n.
        //Q18150 Original. No reparte la producci�n si no la medicion de los porcentuales si tienen Porcentaje.

        if ("Allocation Terms" IN ["Allocation Terms"::"% on Production", "Allocation Terms"::"% on Direct Costs"]) then begin
            if (Rec."% Expense Cost" = 0) then    //Si el procentaje es cero no hay que recalcular nada
                exit;

            //JAV 18/05/22: - Qb 1.10.42 Como recalculamos la medici�n,el importe ya no sirve y se borra tambi�n
            ForecastDataAmountPiecework.RESET;
            ForecastDataAmountPiecework.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountPiecework.SETRANGE("Piecework Code", "Piecework Code");
            ForecastDataAmountPiecework.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
            ForecastDataAmountPiecework.DELETEALL;

            ExpectedTimeUnitData.RESET;
            ExpectedTimeUnitData.SETRANGE("Job No.", "Job No.");
            ExpectedTimeUnitData.SETRANGE("Piecework Code", "Piecework Code");
            ExpectedTimeUnitData.SETRANGE("Budget Code", GETFILTER("Budget Filter"));
            //++ExpectedTimeUnitData.SETRANGE("Unit Type",ExpectedTimeUnitData."Unit Type"::"Cost Unit");  //No estaban marcado bien algunos registros, y como este control es superfluo se quita
            //++ExpectedTimeUnitData.SETRANGE(Performed,FALSE);  //En los porcentuales el c�lculo debe ser siempre sobre el total, no importa que est� ejecutado
            ExpectedTimeUnitData.DELETEALL;

            //JMMA 03/12/20 Calcular porcentaje de la UTE
            CoefJV := 1;
            Job.RESET;//JMMA 130121 Corregir incidencia cuando hay m s de dos unidades externas.
            if Job.GET(Rec."Job No.") then
                if "Over JV Production" then begin
                    Job.TESTFIELD("Job UTE");
                    if JobBudget.GET(Job."No.", GETFILTER("Budget Filter")) then begin
                        Job.CALCFIELDS("Production Budget Amount (JC)");
                        Job.SETRANGE("Posting Date Filter", 0D, JobBudget."Budget Date");
                        Job.CALCFIELDS("Actual Production Amount (JC)");
                        CoefJV := 1;
                        if Job."Production Budget Amount (JC)" <> 0 then
                            CoefJV := (Job.ProdAmountUTE - Job.ActualProdAmountUTE) / (Job."Production Budget Amount (JC)" - Job."Actual Production Amount (JC)");
                    end;
                    //VALIDATE("Measure Budg. Piecework Sol",Job.ProdAmountUTE*Rec."% Expense Cost"/100);
                end;

            //JAV 17/05/22: - QB 1.10.42 Inicializar datos. Se reubica el buscar el �ltimo registro de la tabla para que est� mas claro el c�digo
            Rec."% Expense Cost Amount Base" := 0;

            ExpectedTimeUnitDataEntry.RESET;
            if ExpectedTimeUnitDataEntry.FINDLAST then
                NoEntry := ExpectedTimeUnitDataEntry."Entry No." + 1
            else
                NoEntry := 1;

            //Recorrer los registros de ingresos creando los importes
            ForecastDataAmountPieceworkAmount.RESET;
            ForecastDataAmountPieceworkAmount.SETRANGE("Job No.", "Job No.");
            ForecastDataAmountPieceworkAmount.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
            ForecastDataAmountPieceworkAmount.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
            //++ForecastDataAmountPieceworkAmount.SETRANGE(Performed,FALSE);
            CASE "Allocation Terms" OF
                "Allocation Terms"::"% on Production":
                    ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Incomes);
                "Allocation Terms"::"% on Direct Costs":
                    ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
            end;

            if ForecastDataAmountPieceworkAmount.FINDSET then
                repeat
                    //JAV 17/05/22: - QB 1.10.43 Sumar el importe base para el c�lculo del %
                    Rec."% Expense Cost Amount Base" += ForecastDataAmountPieceworkAmount.Amount;


                    //////// Eliminar, solo para pruebas
                    if ForecastDataAmountPieceworkAmount."Expected Date" = 20220411D then
                        Rec."% Expense Cost Amount Base" := Rec."% Expense Cost Amount Base";
                    ////////


                    //JAV 16/05/22: - QB 1.10.43 Sumar en un solo registro por fecha, si no produce demasiados registros que no se puede seguir
                    ExpectedTimeUnitData2.RESET;
                    ExpectedTimeUnitData2.SETRANGE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                    ExpectedTimeUnitData2.SETRANGE("Expected Date", Job."Starting Date"); // ForecastDataAmountPieceworkAmount."Expected Date");
                    ExpectedTimeUnitData2.SETRANGE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                    ExpectedTimeUnitData2.SETRANGE("Piecework Code", "Piecework Code");
                    if (ExpectedTimeUnitData2.FINDFIRST) then begin
                        ExpectedTimeUnitData2."Expected Measured Amount" += (CoefJV * ForecastDataAmountPieceworkAmount.Amount * ("% Expense Cost" / 100));
                        ExpectedTimeUnitData2.MODIFY(TRUE);
                    end else begin
                        ExpectedTimeUnitData2.INIT;
                        ExpectedTimeUnitData2."Entry No." := NoEntry;
                        ExpectedTimeUnitData2.VALIDATE("Job No.", ForecastDataAmountPieceworkAmount."Job No.");
                        ExpectedTimeUnitData2.VALIDATE("Expected Date", Job."Starting Date"); // ForecastDataAmountPieceworkAmount."Expected Date");
                        ExpectedTimeUnitData2.VALIDATE("Budget Code", ForecastDataAmountPieceworkAmount."Cod. Budget");
                        ExpectedTimeUnitData2.VALIDATE("Piecework Code", "Piecework Code");
                        ExpectedTimeUnitData2."Unit Type" := ExpectedTimeUnitData2."Unit Type"::"Cost Unit";
                        //JMMA 031220 PRODUTE ExpectedTimeUnitData2."Expected Measured Amount" := (ForecastDataAmountPieceworkAmount.Amount * ("% Expense Cost" / 100));
                        ExpectedTimeUnitData2."Expected Measured Amount" := (CoefJV * ForecastDataAmountPieceworkAmount.Amount * ("% Expense Cost" / 100));
                        ExpectedTimeUnitData2."Cost Database Code" := "Code Cost Database";
                        ExpectedTimeUnitData2."Unique Code" := "Unique Code";
                        ExpectedTimeUnitData2.Performed := FALSE;
                        ExpectedTimeUnitData2.INSERT(TRUE);
                        NoEntry += 1;
                    end;
                until ForecastDataAmountPieceworkAmount.NEXT = 0;
        end;

        //JAV 17/05/22: - QB 1.10.43 Guardar el importe base para el c�lculo del %. Como se ha recalculado ya no hay distribuci�n temporal, y en los porcentuales no tiene sentido, quito las fechas
        Rec."Date init" := 0D;
        Rec."Date end" := 0D;
        Rec.MODIFY(FALSE);
    end;

    //     LOCAL procedure CalcBase (var DataPieceworkForProduction@1100286001 : Record 7207386;TypeCalc@1100286000 : Integer;PerForm@1100286002 :
    LOCAL procedure CalcBase(var DataPieceworkForProduction: Record 7207386; TypeCalc: Integer; PerForm: Integer)
    begin
        ForecastDataAmountPieceworkAmount.RESET;
        ForecastDataAmountPieceworkAmount.SETRANGE("Job No.", "Job No.");
        ForecastDataAmountPieceworkAmount.SETRANGE("Unit Type", ExpectedTimeUnitData."Unit Type"::Piecework);
        ForecastDataAmountPieceworkAmount.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
        CASE PerForm OF
            0:
                ForecastDataAmountPieceworkAmount.SETRANGE(Performed, FALSE);  //AML 20/06/23 Vuelto a poner para que solo tenga en cuenta el pendiente.
            1:
                ForecastDataAmountPieceworkAmount.SETRANGE(Performed);
            2:
                ForecastDataAmountPieceworkAmount.SETRANGE(Performed, TRUE);
        end;
        CASE TypeCalc OF
            1:
                ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Incomes);
            0:
                ForecastDataAmountPieceworkAmount.SETRANGE("Entry Type", ForecastDataAmountPieceworkAmount."Entry Type"::Expenses);
        end;

        ForecastDataAmountPieceworkAmount.CALCSUMS(ForecastDataAmountPieceworkAmount.Amount);
        DataPieceworkForProduction."% Expense Cost Amount Base" := ForecastDataAmountPieceworkAmount.Amount;
    end;

    //     procedure ValidateShortcutDimCode (FieldNo@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateDimValueCode(FieldNo, ShortcutDimCode);
        DimensionManagement.SaveDefaultDim(DATABASE::"Data Piecework For Production", "Unique Code", FieldNo, ShortcutDimCode);
        MODIFY;
    end;

    //     procedure ControlJob (CJob@1000000000 :
    procedure ControlJob(CJob: Code[20])
    begin
        Job.GET(CJob);
        if Job.Blocked <> Job.Blocked::" " then
            ERROR(Text006);
        if Job."Job Type" <> Job."Job Type"::Structure then
            ERROR(Text007);
    end;

    procedure SpreadDataCertification()
    var
        //       ManagementLineofMeasure@1100251004 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       LJob@1100000 :
        LJob: Record 167;
    begin
        if GETFILTER("Budget Filter") <> '' then
            ManagementLineofMeasure.CopyProduction_To_Certification("Job No.", "Piecework Code", GETFILTER("Budget Filter"))
        else begin
            if "Job No." <> '' then begin
                LJob.GET("Job No.");
                ManagementLineofMeasure.CopyProduction_To_Certification("Job No.", "Piecework Code", LJob."Current Piecework Budget");
            end;
        end;

        CALCFIELDS("Budget Measure");
        if "Account Type" = "Account Type"::Heading then
            VALIDATE("Sales Amount (Base)", 0)
        else
            VALIDATE("Sales Amount (Base)", "Budget Measure");

        VALIDATE("Unit Price Sale (base)", PriceSales);
    end;

    procedure PriceSales(): Decimal;
    begin
        CALCFIELDS("Budget Measure", "Amount Production Budget");
        if "Budget Measure" <> 0 then
            exit("Amount Production Budget" / "Budget Measure")
        else
            exit(0);
    end;

    procedure CalculateAmount()
    var
        //       DataPieceworkForProductionFather@7001100 :
        DataPieceworkForProductionFather: Record 7207386;
    begin
        GetCurrency;
        if "Account Type" = "Account Type"::Unit then
            "Sales Amount (Base)" := ROUND("Sale Quantity (base)" * "Unit Price Sale (base)",
                                    Currency."Amount Rounding Precision");

        AmountSalesRedet;

        if "Account Type" = "Account Type"::Unit then begin
            "Amount Sale Contract" := ROUND("Sale Quantity (base)" * "Contract Price", Currency."Amount Rounding Precision");
            //{
            //      //jmma desde aqu¡ comentar
            //        //+Q2844
            //        if Indentation > 1 then begin
            //          DataPieceworkForProductionFather.RESET;
            //          DataPieceworkForProductionFather.SETRANGE("Job No.","Job No.");
            //          DataPieceworkForProductionFather.SETRANGE("Piecework Code",ReturnFatherMultiple(Rec));
            //          if DataPieceworkForProductionFather.FINDFIRST then begin
            //            difference := "Amount Sale Contract" - xRec."Amount Sale Contract";
            //            DataPieceworkForProductionFather."Amount Sale Contract" += difference;
            //            DataPieceworkForProductionFather.MODIFY;
            //          end;
            //        end;
            //        //-Q2844
            //        DataPieceworkForProductionFather.RESET;
            //        DataPieceworkForProductionFather.SETRANGE("Job No.","Job No.");
            //        DataPieceworkForProductionFather.SETRANGE("Piecework Code",ReturnFather(Rec));
            //        if DataPieceworkForProductionFather.FINDFIRST then begin
            //          difference := "Amount Sale Contract" - xRec."Amount Sale Contract";
            //          DataPieceworkForProductionFather."Amount Sale Contract" += difference;
            //          DataPieceworkForProductionFather.MODIFY;
            //        end;
            //      //jmma hasta aqu¡
            //      }
        end;
    end;

    procedure AmountSalesRedet()
    begin
        //JAV 23/08/19: - Si se acaba de borrar da un error, me lo salto
        //Job.GET("Job No.");
        if (not Job.GET("Job No.")) then
            exit;
        //JAV fin

        if Job."Last Redetermination" = '' then
            if "Account Type" = "Account Type"::Unit then begin
                "Sale Amount" := "Sales Amount (Base)";

                //jmma comentado por lentitud en calculos de coeficientes
                //{----------------------------------------------------------------------------------------------------------
                //          //+Q2844
                //          if Indentation > 1 then begin
                //            DataPieceworkForProductionFather.RESET;
                //            DataPieceworkForProductionFather.SETRANGE("Job No.","Job No.");
                //            DataPieceworkForProductionFather.SETRANGE("Piecework Code",ReturnFatherMultiple(Rec));
                //            if DataPieceworkForProductionFather.FINDFIRST then begin
                //              difference2 := "Sale Amount" - xRec."Sale Amount";
                //              DataPieceworkForProductionFather."Sale Amount" += difference2;
                //              DataPieceworkForProductionFather.MODIFY;
                //            end;
                //          end;
                //          //-Q2844
                //          DataPieceworkForProductionFather.RESET;
                //          DataPieceworkForProductionFather.SETRANGE("Job No.","Job No.");
                //          DataPieceworkForProductionFather.SETRANGE("Piecework Code",ReturnFather(Rec));
                //          if DataPieceworkForProductionFather.FINDFIRST then begin
                //            difference2 := "Sale Amount" - xRec."Sale Amount";
                //            DataPieceworkForProductionFather."Sale Amount" += difference2;
                //            DataPieceworkForProductionFather.MODIFY;
                //          end;
                //        end else begin
                //          if "Account Type" = "Account Type"::Unit then begin
                //            "Sale Amount" := "Sales Amount (Base)" + "Increased Amount Of Redeterm.";
                //            //+Q2844
                //            if Indentation > 1 then begin
                //                DataPieceworkForProductionFather.RESET;
                //                DataPieceworkForProductionFather.SETRANGE("Job No.","Job No.");
                //                DataPieceworkForProductionFather.SETRANGE("Piecework Code",ReturnFatherMultiple(Rec));
                //                if DataPieceworkForProductionFather.FINDFIRST then begin
                //                  difference2 := "Sale Amount" - xRec."Sale Amount";
                //                  DataPieceworkForProductionFather."Sale Amount" += difference2;
                //                  DataPieceworkForProductionFather.MODIFY;
                //                end;
                //            end;
                //            //-Q2844
                //            DataPieceworkForProductionFather.RESET;
                //            DataPieceworkForProductionFather.SETRANGE("Job No.","Job No.");
                //            DataPieceworkForProductionFather.SETRANGE("Piecework Code",ReturnFather(Rec));
                //              if DataPieceworkForProductionFather.FINDFIRST then begin
                //                difference2 := "Sale Amount" - xRec."Sale Amount";
                //                DataPieceworkForProductionFather."Sale Amount" += difference2;
                //                DataPieceworkForProductionFather.MODIFY;
                //              end;
                //          end;
                //        -----------------------------------------------------------------------------}
            end;
    end;

    procedure UpdateRedet()
    var
        //       Initializeredetermination@1100240000 :
        Initializeredetermination: Codeunit 7207340;
    begin
        CLEAR(Initializeredetermination);
        Initializeredetermination.ActRedeterminations(Rec);
    end;

    //     procedure UpdateBudgetCost (callbyfieldno@1100229002 :
    procedure UpdateBudgetCost(callbyfieldno: Integer)
    var
        //       LDataPieceworkForProduction@1100229000 :
        LDataPieceworkForProduction: Record 7207386;
        //       LCopyJob@1100229001 :
        LCopyJob: Integer;
    begin
        if (callbyfieldno = CurrFieldNo) or (RunUpdate) then begin
            if "Production Unit" then begin
                CALCFIELDS("Budget Measure");
                if "Budget Measure" = 0 then
                    VALIDATE("Initial Produc. Price", "Unit Price Sale (base)")
                else
                    VALIDATE("Initial Produc. Price", ROUND("Sale Amount" / "Budget Measure", 0.00001));
            end;
        end;
    end;

    procedure AmountProductionAssigned(): Decimal;
    var
        //       LJob@1100251000 :
        LJob: Record 167;
        //       AmountNoAssignedSales@1100251001 :
        AmountNoAssignedSales: Decimal;
        //       ForecastDataAmountPiecework@1100251002 :
        ForecastDataAmountPiecework: Record 7207392;
        //       CostBudget@1100251003 :
        CostBudget: Decimal;
        //       LDataPieceworkForProduction@1100251004 :
        LDataPieceworkForProduction: Record 7207386;
        //       LelCertificationProduct@1100251005 :
        LelCertificationProduct: Record 7207397;
        //       AmountSalesAssigned@1100251006 :
        AmountSalesAssigned: Decimal;
    begin
        //SI COINCIDE HAY QUE RESPETAR EL IMPORTE VENTA=IMPORTE PRODUCCIàN PPTO.
        LJob.GET("Job No.");
        CLEAR(Currency);
        GetCurrency;
        Currency.InitRoundingPrecision;
        if Type = Type::"Cost Unit" then
            exit(0);
        if "Customer Certification Unit" then begin
            exit("Sale Amount")
        end;

        //se no coinciden se busca la relaci¢n de unidades asignadas
        //
        LelCertificationProduct.SETRANGE("Job No.", "Job No.");
        LelCertificationProduct.SETRANGE("Production Unit Code", "Piecework Code");
        if LelCertificationProduct.FINDFIRST then
            repeat
                LDataPieceworkForProduction.GET(LelCertificationProduct."Job No.", LelCertificationProduct."Certification Unit Code");
                if LelCertificationProduct."Percentage Of Assignment" <> 0 then begin
                    AmountSalesAssigned := AmountSalesAssigned +
                                         (LDataPieceworkForProduction."Sale Amount" * LelCertificationProduct."Percentage Of Assignment" / 100)
                end;
            until LelCertificationProduct.NEXT = 0;

        exit(ROUND(AmountSalesAssigned, Currency."Unit-Amount Rounding Precision"));
    end;

    procedure DescUO(): Text[50];
    begin
        if Rec."Code Cost Database" <> '' then begin
            if Piecework.GET("Code Cost Database", "Piecework Code") then
                exit(Piecework.Description)
            else
                exit(Description);
        end else begin
            if Piecework.GET("Code Cost Database Certif.", "Piecework Code") then
                exit(Piecework.Description)
            else
                exit(Description);
        end;
    end;

    procedure funUnitsOfMeasure(): Code[12];
    begin
        if Piecework.GET("Piecework Code") then
            exit(COPYSTR(Piecework."Units of Measure", 1, 10));
    end;

    procedure AdvanceCertificationsPercentage(): Decimal;
    var
        //       RelCertificationProduct@1100003 :
        RelCertificationProduct: Record 7207397;
        //       DataPieceworkForProduction@1100002 :
        DataPieceworkForProduction: Record 7207386;
        //       BudgetAmount@1100001 :
        BudgetAmount: Decimal;
        //       RealizedAmount@1100251000 :
        RealizedAmount: Decimal;
    begin
        if "Customer Certification Unit" then begin
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
            DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
            if "Account Type" = "Account Type"::Unit then
                DataPieceworkForProduction.SETRANGE("Piecework Code", "Piecework Code")
            else
                DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            if DataPieceworkForProduction.FINDFIRST then
                repeat
                    DataPieceworkForProduction.CALCFIELDS("Certified Amount");
                    BudgetAmount := BudgetAmount + DataPieceworkForProduction."Sale Amount";
                    RealizedAmount += DataPieceworkForProduction."Certified Amount";
                until DataPieceworkForProduction.NEXT = 0;
            if BudgetAmount <> 0 then
                exit(ROUND(((RealizedAmount) * 100 / BudgetAmount), 0.01))
            else
                exit(0);
        end else
            exit(0);
    end;

    procedure RealizedProduction(): Decimal;
    var
        //       Job@1100251000 :
        Job: Record 167;
        //       NoAssigSalesAmount@1100251001 :
        NoAssigSalesAmount: Decimal;
        //       ForecastDataAmountPiecework@1100251002 :
        ForecastDataAmountPiecework: Record 7207392;
        //       BudgetCost@1100251003 :
        BudgetCost: Decimal;
        //       DataPieceworkForProduction@1100251004 :
        DataPieceworkForProduction: Record 7207386;
        //       RelCertificationProduct@1100251005 :
        RelCertificationProduct: Record 7207397;
        //       AssigSalesAmount@1100251006 :
        AssigSalesAmount: Decimal;
        //       DataPieceworkForProduction2@1100251008 :
        DataPieceworkForProduction2: Record 7207386;
        //       DataPieceworkForProduction3@1100251007 :
        DataPieceworkForProduction3: Record 7207386;
    begin
        //Calculo de la producci¢n de una unidad de cliente
        if "Account Type" = "Account Type"::Unit then begin
            ;
            Job.GET("Job No.");
            CLEAR(Currency);
            GetCurrency;
            Currency.InitRoundingPrecision;
            if Type = Type::"Cost Unit" then
                exit(0);

            if "Production Unit" then begin
                CALCFIELDS("Amount Production Performed");
                exit("Amount Production Performed")
            end;

            //se no coinciden se busca la relaci¢n de unidades asignadas
            //
            RelCertificationProduct.SETRANGE("Job No.", "Job No.");
            RelCertificationProduct.SETRANGE(RelCertificationProduct."Certification Unit Code", "Piecework Code");
            //used without Updatekey Parameter to avoid warning - may become error in future release
            /*To be Tested*/
            //if RelCertificationProduct.FINDSET(FALSE, FALSE) then
            if RelCertificationProduct.FINDSET(FALSE) then
                repeat
                    //JAV 07/06/21: - QB 1.08.48 Se a¤ade un if por si hay una unidad en blanco o eliminada
                    if DataPieceworkForProduction.GET(RelCertificationProduct."Job No.", RelCertificationProduct."Production Unit Code") then begin
                        if RelCertificationProduct."Percentage Of Assignment" <> 0 then begin
                            DataPieceworkForProduction.COPYFILTERS(Rec);
                            DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                            //calculamos la producci¢n total para ponderar con el importe de venta
                            DataPieceworkForProduction3 := DataPieceworkForProduction;
                            DataPieceworkForProduction.COPYFILTER(DataPieceworkForProduction."Budget Filter", DataPieceworkForProduction3."Budget Filter");
                            DataPieceworkForProduction3.CALCFIELDS("Amount Production Budget");
                            if DataPieceworkForProduction3."Amount Production Budget" <> 0 then
                                AssigSalesAmount := AssigSalesAmount +
                                                  ((DataPieceworkForProduction."Amount Production Budget" * RelCertificationProduct."Percentage Of Assignment" / 100) *
                                                   "Sale Amount" / DataPieceworkForProduction3."Amount Production Budget");

                        end;
                    end;
                until RelCertificationProduct.NEXT = 0;
            exit(AssigSalesAmount);
        end else begin
            //es mayor
            AssigSalesAmount := 0;
            DataPieceworkForProduction2.INIT;
            DataPieceworkForProduction2.COPYFILTERS(Rec);
            DataPieceworkForProduction2.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction2.SETFILTER("Piecework Code", Totaling);
            DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
            if DataPieceworkForProduction2.FINDFIRST then
                repeat
                    AssigSalesAmount := AssigSalesAmount + DataPieceworkForProduction2.RealizedProduction;
                until DataPieceworkForProduction2.NEXT = 0;
            exit(AssigSalesAmount);
        end;
    end;

    procedure ProductionAdvancePercentage(): Decimal;
    var
        //       RelCertificationProduct@1100003 :
        RelCertificationProduct: Record 7207397;
        //       DataPieceworkForProduction@1100002 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProduction2@1100251001 :
        DataPieceworkForProduction2: Record 7207386;
        //       BudgetAmount@1100001 :
        BudgetAmount: Decimal;
        //       RealizedAmount@1100251000 :
        RealizedAmount: Decimal;
        //       Job@1100251002 :
        Job: Record 167;
    begin
        if "Production Unit" then begin
            DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
            DataPieceworkForProduction.SETRANGE("Budget Filter", GETFILTER("Budget Filter"));
            DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
            if "Account Type" = "Account Type"::Unit then
                DataPieceworkForProduction.SETRANGE("Piecework Code", "Piecework Code")
            else
                DataPieceworkForProduction.SETFILTER("Piecework Code", Totaling);
            if DataPieceworkForProduction.FINDFIRST then
                repeat
                    DataPieceworkForProduction.SETRANGE("Filter Date");
                    DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                    BudgetAmount := BudgetAmount + DataPieceworkForProduction."Amount Production Budget";

                    DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
                    DataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                    RealizedAmount := RealizedAmount + DataPieceworkForProduction."Amount Production Performed";
                until DataPieceworkForProduction.NEXT = 0;
            if BudgetAmount <> 0 then
                exit(ROUND(((RealizedAmount) * 100 / BudgetAmount), 0.01))
            else
                exit(0);
        end else begin
            Job.GET("Job No.");
            DataPieceworkForProduction2.SETRANGE("Job No.", "Job No.");
            DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Unit);
            if "Account Type" = "Account Type"::Unit then
                DataPieceworkForProduction2.SETRANGE("Piecework Code", "Piecework Code")
            else
                DataPieceworkForProduction2.SETFILTER("Piecework Code", Totaling);
            if DataPieceworkForProduction2.FINDFIRST then
                repeat
                    RelCertificationProduct.SETRANGE("Job No.", "Job No.");
                    RelCertificationProduct.SETRANGE("Certification Unit Code", DataPieceworkForProduction2."Piecework Code");
                    if RelCertificationProduct.FINDFIRST then
                        repeat
                            //JAV 07/06/21: - QB 1.08.48 Se a¤ade un if por si hay una unidad en blanco o eliminada
                            if DataPieceworkForProduction.GET(RelCertificationProduct."Job No.", RelCertificationProduct."Production Unit Code") then begin
                                DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Initial Budget Piecework");
                                DataPieceworkForProduction.SETRANGE("Filter Date");
                                DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                                if DataPieceworkForProduction."Amount Production Budget" <> 0 then begin
                                    BudgetAmount := BudgetAmount + DataPieceworkForProduction."Amount Production Budget" *
                                          (DataPieceworkForProduction2."Sale Amount" *
                                          (RelCertificationProduct."Percentage Of Assignment" / 100) / DataPieceworkForProduction."Amount Production Budget");

                                    DataPieceworkForProduction.SETFILTER("Filter Date", GETFILTER("Filter Date"));
                                    DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
                                    RealizedAmount := RealizedAmount + DataPieceworkForProduction."Amount Production Performed" *
                                             (DataPieceworkForProduction2."Sale Amount" *
                                             (RelCertificationProduct."Percentage Of Assignment" / 100) / DataPieceworkForProduction."Amount Production Budget");
                                end;
                            end;
                        until RelCertificationProduct.NEXT = 0;
                until DataPieceworkForProduction2.NEXT = 0;
            if BudgetAmount <> 0 then
                exit(ROUND(((RealizedAmount) * 100 / BudgetAmount), 0.01))
            else
                exit(0);
        end;
    end;

    procedure CalculatePricesOfBillItems()
    var
        //       DataCostByPiecework@1100240000 :
        DataCostByPiecework: Record 7207387;
        //       Job@1100240001 :
        Job: Record 167;
        //       ContractPrice@1100240002 :
        ContractPrice: Decimal;
        //       PriceLasRedetermination@1100240003 :
        PriceLasRedetermination: Decimal;
        //       JobRedetermination@1100240004 :
        JobRedetermination: Record 7207437;
    begin
        GetCurrency;
        ContractPrice := 0;
        Job.GET("Job No.");
        DataCostByPiecework.SETRANGE("Job No.", "Job No.");
        DataCostByPiecework.SETRANGE("Piecework Code", "Piecework Code");
        DataCostByPiecework.SETRANGE("Cod. Budget", Job."Initial Budget Piecework");
        if DataCostByPiecework.FINDSET then begin
            repeat
                ContractPrice := ContractPrice +
                                        ROUND(DataCostByPiecework."Contract Price" * DataCostByPiecework."Performance By Piecework",
                                        Currency."Unit-Amount Rounding Precision");
                PriceLasRedetermination := PriceLasRedetermination +
                                        ROUND(DataCostByPiecework."Sale Price Redetermined" * DataCostByPiecework."Performance By Piecework",
                                        Currency."Unit-Amount Rounding Precision");
            until DataCostByPiecework.NEXT = 0;
            JobRedetermination.SETRANGE("Job No.", "Job No.");
            JobRedetermination.SETRANGE(Validated, TRUE);
            if not JobRedetermination.FINDFIRST then
                VALIDATE("Contract Price", ContractPrice);

            VALIDATE("Last Unit Price Redetermined", PriceLasRedetermination);
            MODIFY;
        end;
    end;

    //     procedure ReturnFather (DataPieceworkForProduction1@1100227000 :
    procedure ReturnFather(DataPieceworkForProduction1: Record 7207386): Code[20];
    var
        //       FatherAux@1100227001 :
        FatherAux: Code[20];
        //       Father@1100227003 :
        Father: Code[20];
        //       DataPieceworkForProduction2@1100227002 :
        DataPieceworkForProduction2: Record 7207386;
        //       DataPieceworkForProduction3@1100227004 :
        DataPieceworkForProduction3: Record 7207386;
        //       DataPieceworkForProduction4@7001100 :
        DataPieceworkForProduction4: Record 7207386;
    begin
        if DataPieceworkForProduction1.Indentation > 0 then begin
            FatherAux := '';
            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETRANGE("Job No.", DataPieceworkForProduction1."Job No.");
            DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Heading);
            if DataPieceworkForProduction2.FINDSET then begin
                repeat
                    DataPieceworkForProduction3.RESET;
                    DataPieceworkForProduction3.SETRANGE("Job No.", DataPieceworkForProduction2."Job No.");
                    DataPieceworkForProduction3.SETFILTER("Piecework Code", DataPieceworkForProduction2.Totaling);
                    if DataPieceworkForProduction3.FINDSET then begin
                        repeat
                            if (DataPieceworkForProduction3."Piecework Code" = DataPieceworkForProduction1."Piecework Code")
                              and (DataPieceworkForProduction2.Indentation = (DataPieceworkForProduction1.Indentation - 1)) then
                                FatherAux := DataPieceworkForProduction2."Piecework Code";
                        until (DataPieceworkForProduction3.NEXT = 0) or (FatherAux <> '');
                    end;
                    DataPieceworkForProduction4.RESET;
                    DataPieceworkForProduction4.SETRANGE("Job No.", DataPieceworkForProduction2."Job No.");
                    DataPieceworkForProduction4.SETFILTER("Piecework Code", DataPieceworkForProduction2.Totaling);
                    if DataPieceworkForProduction4.FINDSET then begin
                        repeat
                            if (DataPieceworkForProduction4."Piecework Code" = DataPieceworkForProduction1."Piecework Code")
                              and (DataPieceworkForProduction2.Indentation = (DataPieceworkForProduction1.Indentation - 2)) then
                                FatherAux := DataPieceworkForProduction2."Piecework Code";
                        until (DataPieceworkForProduction4.NEXT = 0) or (FatherAux <> '');
                    end;
                until (DataPieceworkForProduction2.NEXT = 0) or (FatherAux <> '');
            end;
            Father := FatherAux;
            FatherAux := '';
        end else
            Father := '';

        exit(Father);
    end;

    //     procedure ReturnFatherMultiple (DataPieceworkForProduction1@1100227000 :
    procedure ReturnFatherMultiple(DataPieceworkForProduction1: Record 7207386): Code[20];
    var
        //       FatherAux@1100227001 :
        FatherAux: Code[20];
        //       Father@1100227003 :
        Father: Code[20];
        //       DataPieceworkForProduction2@1100227002 :
        DataPieceworkForProduction2: Record 7207386;
        //       DataPieceworkForProduction3@1100227004 :
        DataPieceworkForProduction3: Record 7207386;
        //       DataPieceworkForProduction4@7001100 :
        DataPieceworkForProduction4: Record 7207386;
    begin
        //Q2844
        if DataPieceworkForProduction1.Indentation > 1 then begin
            FatherAux := '';
            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETRANGE("Job No.", DataPieceworkForProduction1."Job No.");
            DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction2."Account Type"::Heading);
            DataPieceworkForProduction2.SETFILTER(Indentation, '%1', DataPieceworkForProduction1.Indentation - 1);
            if DataPieceworkForProduction2.FINDSET then begin
                repeat
                    DataPieceworkForProduction3.RESET;
                    DataPieceworkForProduction3.SETRANGE("Job No.", DataPieceworkForProduction2."Job No.");
                    DataPieceworkForProduction3.SETFILTER("Piecework Code", DataPieceworkForProduction2.Totaling);
                    if DataPieceworkForProduction3.FINDSET then begin
                        repeat
                            if (DataPieceworkForProduction3."Piecework Code" = DataPieceworkForProduction1."Piecework Code")
                              and (DataPieceworkForProduction2.Indentation = (DataPieceworkForProduction1.Indentation - 1)) then
                                FatherAux := DataPieceworkForProduction2."Piecework Code";
                        until (DataPieceworkForProduction3.NEXT = 0) or (FatherAux <> '');
                    end;
                until (DataPieceworkForProduction2.NEXT = 0) or (FatherAux <> '');
            end;
            Father := FatherAux;
            FatherAux := '';
        end else
            Father := '';

        exit(Father);
    end;

    //     procedure UpdateSaleQuantityBase (var JobCode@7001102 : Code[20];var PieceowrkCode@7001103 : Code[20];var NewMeasurementTotal@7001104 :
    procedure UpdateSaleQuantityBase(var JobCode: Code[20]; var PieceowrkCode: Code[20]; var NewMeasurementTotal: Decimal)
    begin
        //JAV 13/03/19: - En la funci¢n UpdateSaleQuantityBase hab¡a variables locales que no usaba y se elimina una l¡nea no necesaria
        if DataPieceworkForProduction.GET(JobCode, PieceowrkCode) then begin
            DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", NewMeasurementTotal);
            DataPieceworkForProduction.MODIFY(TRUE);
        end;
    end;

    procedure CheckClosed()
    var
        //       Text020@7001100 :
        Text020: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
    begin
        JobBudget.RESET;
        JobBudget.SETRANGE("Job No.", "Job No.");
        JobBudget.SETRANGE("Cod. Budget", GETFILTER("Budget Filter"));
        if JobBudget.FINDFIRST then
            if JobBudget.Status = JobBudget.Status::Close then
                ERROR(Text020);
    end;

    //     LOCAL procedure MarkStudied (IsStudied@7001102 :
    LOCAL procedure MarkStudied(IsStudied: Boolean)
    var
        //       DataPieceworkForProduction2@1100286002 :
        DataPieceworkForProduction2: Record 7207386;
        //       DataPieceworkForProduction3@1100286001 :
        DataPieceworkForProduction3: Record 7207386;
        //       PieceworkFilter@1100286000 :
        PieceworkFilter: Text;
    begin
        //QB4932
        if Rec."Account Type" = Rec."Account Type"::Heading then begin
            //JAV ++ 05/03/19: - Para que no de error si no tiene sumatorio establecido, lo relleno
            if (Totaling = '') then
                VALIDATE(Totaling);

            PieceworkFilter := '&<>' + "Piecework Code";
            PieceworkFilter := COPYSTR(Totaling, 1, 20 - STRLEN(PieceworkFilter)) + PieceworkFilter;

            //Marcamos hijos como estudiados
            DataPieceworkForProduction2.RESET;
            DataPieceworkForProduction2.SETCURRENTKEY("Account Type", "Piecework Code");
            DataPieceworkForProduction2.SETRANGE("Job No.", Rec."Job No.");
            DataPieceworkForProduction2.SETFILTER("Piecework Code", PieceworkFilter);
            DataPieceworkForProduction2.SETRANGE("Budget Filter", GETFILTER(Rec."Budget Filter"));
            DataPieceworkForProduction2.SETRANGE(Studied, not IsStudied);
            if DataPieceworkForProduction2.FINDSET then begin
                repeat
                    DataPieceworkForProduction2.Studied := IsStudied;
                    DataPieceworkForProduction2.MODIFY(TRUE);
                until DataPieceworkForProduction2.NEXT = 0;
            end;
        end;
    end;

    //     procedure SetInitialSaleMeasure (pJob@1100286000 : Code[20];pDialog@1100286001 :
    procedure SetInitialSaleMeasure(pJob: Code[20]; pDialog: Boolean)
    var
        //       opc@1100286002 :
        opc: Integer;
    begin
        opc := 1;
        if (pDialog) then begin
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", pJob);
            DataPieceworkForProduction.SETFILTER("Initial Sale Measurement", '<>0');
            if (DataPieceworkForProduction.FINDSET) then begin
                opc := STRMENU(Text023, 1, Text024);
                if (opc = 3) then
                    exit;
            end;
        end;

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", pJob);
        if (opc = 1) then
            DataPieceworkForProduction.SETFILTER("Initial Sale Measurement", '=0');
        if (DataPieceworkForProduction.FINDSET(TRUE)) then
            repeat
                DataPieceworkForProduction."Initial Sale Measurement" := DataPieceworkForProduction."Sale Quantity (base)";
                DataPieceworkForProduction.MODIFY;
            until (DataPieceworkForProduction.NEXT = 0);

        MESSAGE(Text025);
    end;

    //     procedure GetStyle (pActualStyle@1100286000 :
    procedure GetStyle(pActualStyle: Text): Text;
    begin
        if (pActualStyle = '') then
            pActualStyle := 'Standard';

        if ("Account Type" = "Account Type"::Heading) then
            exit('Strong')
        else
            exit(pActualStyle);
    end;

    LOCAL procedure SetHeadingDates()
    var
        //       CodeAux@1100286000 :
        CodeAux: Code[20];
    begin
        //Subo la fecha a las unidades de mayor
        if ("Account Type" = "Account Type"::Heading) or (STRLEN("Piecework Code") < 2) then
            exit;

        MODIFY; //Para que guarde el importe actual

        CodeAux := "Piecework Code";
        repeat
            CodeAux := COPYSTR(CodeAux, 1, STRLEN(CodeAux) - 1);
            if DataPieceworkForProductionFather.GET("Job No.", CodeAux) then begin
                if (DataPieceworkForProductionFather."Account Type" = DataPieceworkForProductionFather."Account Type"::Heading) then begin
                    //JAV 18/10/21: - QB 1.09.22 Mejoramos el calculo de fechas en los padres
                    DataPieceworkForProductionP.RESET;
                    DataPieceworkForProductionP.SETCURRENTKEY("Date init");
                    DataPieceworkForProductionP.SETRANGE("Job No.", DataPieceworkForProductionFather."Job No.");
                    DataPieceworkForProductionP.SETRANGE("Account Type", DataPieceworkForProductionP."Account Type"::Unit);
                    DataPieceworkForProductionP.SETFILTER("Piecework Code", DataPieceworkForProductionFather.Totaling);
                    DataPieceworkForProductionP.SETFILTER("Date init", '<>%1', 0D);
                    if (DataPieceworkForProductionP.FINDFIRST) then
                        if (DataPieceworkForProductionFather."Date init" <> DataPieceworkForProductionP."Date init") then begin
                            DataPieceworkForProductionFather."Date init" := DataPieceworkForProductionP."Date init";
                            DataPieceworkForProductionFather.MODIFY;
                        end;
                    DataPieceworkForProductionP.RESET;
                    DataPieceworkForProductionP.SETCURRENTKEY("Date end");
                    DataPieceworkForProductionP.SETRANGE("Job No.", DataPieceworkForProductionFather."Job No.");
                    DataPieceworkForProductionP.SETRANGE("Account Type", DataPieceworkForProductionP."Account Type"::Unit);
                    DataPieceworkForProductionP.SETFILTER("Piecework Code", DataPieceworkForProductionFather.Totaling);
                    DataPieceworkForProductionP.SETFILTER("Date end", '<>%1', 0D);
                    if (DataPieceworkForProductionP.FINDLAST) then
                        if (DataPieceworkForProductionFather."Date end" <> DataPieceworkForProductionP."Date end") then begin
                            DataPieceworkForProductionFather."Date end" := DataPieceworkForProductionP."Date end";
                            DataPieceworkForProductionFather.MODIFY;
                        end;
                end;
            end;
        until STRLEN(CodeAux) = 1
    end;

    //     procedure SetSkipCheckDates (pCheck@1100286000 :
    procedure SetSkipCheckDates(pCheck: Boolean)
    begin
        SkipCheckDates := pCheck;
    end;

    procedure CalculateMarginBudget(): Decimal;
    var
        //       LAmountCostBudget@7001100 :
        LAmountCostBudget: Decimal;
        //       Amount@1100286000 :
        Amount: Decimal;
    begin
        //JMMA 281020 ERROR EN DIVISAS, cambiamos (LCY) por (JC)
        //JAV 16/12/20: - QB 1.07.12 Se retorna el importe redondeado

        if ("Production Unit") then begin
            CALCFIELDS("Amount Production Budget", "Amount Cost Budget (JC)");
            Amount := "Amount Production Budget" - "Amount Cost Budget (JC)";
        end else begin
            LAmountCostBudget := 0;
            Job.GET("Job No.");
            RelCertificationproduct.SETRANGE("Job No.", "Job No.");
            RelCertificationproduct.SETRANGE("Certification Unit Code", "Piecework Code");
            if RelCertificationproduct.FINDFIRST then
                repeat
                    if DataPieceworkForProduction.GET(RelCertificationproduct."Job No.", RelCertificationproduct."Production Unit Code") then begin
                        DataPieceworkForProduction.SETRANGE("Budget Filter", Job."Current Piecework Budget");
                        DataPieceworkForProduction.CALCFIELDS("Amount Production Budget", "Amount Cost Budget (JC)");
                        if (DataPieceworkForProduction."Amount Production Budget" <> 0) then
                            LAmountCostBudget := LAmountCostBudget + (DataPieceworkForProduction."Amount Cost Budget (JC)" *
                                                  ("Sale Amount" * (RelCertificationproduct."Percentage Of Assignment" / 100) / DataPieceworkForProduction."Amount Production Budget"));
                    end;
                until RelCertificationproduct.NEXT = 0;
            Amount := "Sale Amount" - LAmountCostBudget;
        end;

        Currency.InitRoundingPrecision;
        exit(ROUND(Amount, Currency."Amount Rounding Precision"));
    end;

    procedure CalculateMarginBudgetPerc(): Decimal;
    var
        //       Amount@1100286000 :
        Amount: Decimal;
    begin
        //JAV 16/12/20: - QB 1.07.12 Se usa la funci¢n anterior para obtener el importe en lugar de volverlo a calcular
        Amount := 0;
        if ("Production Unit") then begin
            DataPieceworkForProduction.CALCFIELDS("Amount Production Budget");
            if ("Amount Production Budget" <> 0) then
                Amount := CalculateMarginBudget / "Amount Production Budget";
        end else begin
            if ("Sale Amount" <> 0) then
                Amount := CalculateMarginBudget / "Sale Amount";
        end;

        exit(ROUND(Amount * 100, 0.01));
    end;

    procedure CalculatePiecework()
    var
        //       RateBudgetsbyPiecework@1100286000 :
        RateBudgetsbyPiecework: Codeunit 7207329;
    begin
        //------------------------------------------------------------------------------------------------------
        //JAV 18/05/22: - QB 1.10.42 Recalcular el importe de la unidad de obra actual
        //------------------------------------------------------------------------------------------------------
        Job.GET("Job No.");
        JobBudget.GET(Rec."Job No.", GETFILTER("Budget Filter"));
        if (JobBudget."Budget Date" = 0D) then
            ERROR(Text027);

        CLEAR(RateBudgetsbyPiecework);
        RateBudgetsbyPiecework.SetDataPiecework(Rec."Piecework Code", FALSE, TRUE);
        RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget)
    end;

    procedure ActualizaPresupuesto()
    var
        //       DataPieceworkForProduction@1100286002 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProduction2@1100286001 :
        DataPieceworkForProduction2: Record 7207386;
        //       i@1100286000 :
        i: Integer;
        //       suma@1100286004 :
        suma: Decimal;
    begin
        //Actualizar los importes de los presupuestos padres al cambiar el importe de uno hijo
        // Job.GET("Job No.");
        // if (Job."Card Type" = Job."Card Type"::Presupuesto) then begin
        //  FOR i:=1 TO STRLEN("Piecework Code") - 1 DO begin
        //    DataPieceworkForProduction.RESET;
        //    DataPieceworkForProduction.SETRANGE("Job No.", "Job No.");
        //    DataPieceworkForProduction.SETRANGE("Piecework Code", COPYSTR("Piecework Code", 1, i));
        //    DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Heading);
        //    if (DataPieceworkForProduction.FINDSET(TRUE)) then
        //      repeat
        //        suma := 0;
        //        DataPieceworkForProduction2.RESET;
        //        DataPieceworkForProduction2.SETRANGE("Job No.", "Job No.");
        //        DataPieceworkForProduction2.SETFILTER("Piecework Code", COPYSTR("Piecework Code", 1, i) + '*');
        //        DataPieceworkForProduction2.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        //        if (DataPieceworkForProduction2.FINDSET(TRUE)) then
        //          repeat
        //            if (DataPieceworkForProduction2."Piecework Code" = "Piecework Code") then
        //              suma += pAmount
        //            else
        //              suma += DataPieceworkForProduction2."QPR Amount";
        //          until (DataPieceworkForProduction2.NEXT = 0);
        //          DataPieceworkForProduction."QPR Amount" := suma;
        //          DataPieceworkForProduction.MODIFY;
        //      until (DataPieceworkForProduction.NEXT = 0);
        //  end;
        // end;
    end;

    //     LOCAL procedure QPRSetExternalCompany (pCompany@1100286000 : Text;pJobNo@1100286001 : Code[20];pAlta@1100286003 :
    LOCAL procedure QPRSetExternalCompany(pCompany: Text; pJobNo: Code[20]; pAlta: Boolean)
    var
        //       QFRCopmpanyBudgetUse@1100286004 :
        QFRCopmpanyBudgetUse: Record 7207394;
    begin
        //JAV 29/09/21: - QB 1.09.99 Tratamiento del registro en la tabla de usos de presupuestos en empresas externas
        if (pJobNo <> '') then begin
            if (pCompany = '') then
                pCompany := COMPANYNAME;

            //Elimino el registro existente
            if QFRCopmpanyBudgetUse.GET(pCompany, pJobNo, CURRENTCOMPANY, "Job No.", "Piecework Code") then
                QFRCopmpanyBudgetUse.DELETE;

            //Si hay que crear el registro lo hago ahora
            if (pAlta) then begin
                QFRCopmpanyBudgetUse."QPR Origin Company" := pCompany;
                QFRCopmpanyBudgetUse."QPR Origin Job" := pJobNo;
                QFRCopmpanyBudgetUse."QPR Destination Company" := CURRENTCOMPANY;
                QFRCopmpanyBudgetUse."QPR Destination Job" := "Job No.";
                QFRCopmpanyBudgetUse."QPR Destination Piecework code" := "Piecework Code";
                QFRCopmpanyBudgetUse.INSERT;
            end;
        end;
    end;

    LOCAL procedure QPRGetBudget(): Code[20];
    var
        //       Budget@1100286000 :
        Budget: Code[20];
    begin
        FILTERGROUP(4);
        Budget := GETFILTER("Budget Filter");
        FILTERGROUP(0);
        exit(Budget);
    end;

    /*begin
    //{
//      El caption del campo "% producci¢n tramitada" pone "% en tramite". Se cambia a "% producci¢n tramitada"
//       Comentarios: Modificacion del calculo de la partida de baja de ppto de certificacion
//                        Inclusion del campo subtipo de coste
//
//      FML         : - PV0907. Calculamos la producci¢n total para ponderar con el importe de venta
//      NZG 16/01/18: - QBV102 A¤adidos los campos "Studied" y "Amoun Studied Budget"
//                              Cuando se valida el campo "Studied", se actualiza en la tabla "Forecast Data Amount Piecework"
//      QMD 18/08/10: - Q2844 Se a¤ade la funci¢n ReturnFatherMultiple para que calcule correctamente cuando tiene subcap¡tulos
//      JAV 17/12/18: - Se a¤aden los capos 7000003 "Date init", 7000004 "Date end" y 7000005 "Distributed"
//      JAV 05/03/19: - Para que no de error si no tiene sumatorio establecido, lo relleno en el validate y lo llamo cuando es necesario
//                    - Se cambia el caption del campo 35 "% Margen" a "% Sobrecoste" que tiene mas sentido
//      JAV 11/03/19: - Controlar fechas de inicio y fin en rango correcto
//      JAV 12/03/19: - Se revisa el proceso de borrado pues estaba mal definido
//                    - Los textos globales Text014 y Text015 ten¡an mal asociado el idioma espa¤ol
//      JAV 13/03/19: - Mal en el validate del Item Type
//                    - En la funci¢n UpdateSaleQuantityBase hab¡a variables locales que no usaba y se elimina una l¡nea no necesaria
//      JAV 20/03/19: - Si desmarcamos una UO, desmarcamos el padre como estudiado completo, y si la marcamos mira si el padre puede marcarse y lo hace
//                    - Se cambia el c¢digo de ValidateTotalsIfIsHeading, hac¡a un validate que se llamaba a s¡ mismo y cambiaba el registro varias veces
//      JDC 23/07/19: - GAP020 KALAM. Se a¤aden los campos 50002 "Outsourcing Code" y 50003 "Outsourcing Name"
//      JAV 23/08/19: - Si se acaba de borrar da un error, me lo salto
//      JAV 05/10/19: - Al establecer el tipo se valida el sumatorio siempre, y se hace el campo no editable pues ser  autom tico ahora
//                    - Se elimina la funci¢n "GenerateUniqueCode" y se pasa al validate del campo "Unique code"
//      QMD 16/12/19: - GAP08 ROIG CyS. Crear campo para Medici¢n inicial en el presupuesto de venta
//      JAV 03/02/19: - Si ponemos actividad en una l¡nea de mayor, la ponemos en todo lo que cuelga de esta
//                    - Nuevo campo para que no entre en los c lculos de K. Si cambiamnos el campo en una l¡nea de mayor, la ponemos en todo lo que cuelga de esta
//      DGG 21/06/21: - Q13152 Se a¤ade campo "Grouping Code" para agrupaci¢n de certificaci¢n
//      JAV 30/09/21: - QB 1.09.20 Verificar que la medici�n de venta no pueda ser menor de lo ya ejecutado
//      JAV 20/10/21: - QB 1.09.22 Borramos previsi�n de certificaci�n y Considerar �nicamente ingresos y gastos, no certificaciones
//      JAV 08/04/22: - Se a�ade el campo 611 "QPR Activable" para los Gastos Activables
//      JAV 12/04/22: - QB 1.10.35 Se eliminan los campos DataPieceworkForProduction.Activable y JobLedgEntry.Activate porque no se usan para nada
//      JAV 16/05/22: - QRE 1.00.15 Se eliminan los responsables de la unidad de obra al eliminar esta
//      JAV 18/05/22: - QB 1.10.42 Se renombra UpdateQuantity por UpdateMeasurementByPercentage que es mas apropiado
//                                  Se a�ade el campo 22 "% Expense Cost Amount Calc." para saber sobre que base se ha calculado el % de coste
//                                  Se modifica el proceso de c�lculo de porcentuales para que lo haga correcto y que no genere tantas l�neas, solo una por fecha
//      JAV 25/05/22: - QB 1.10.44 Se a�aden varias key para aumentar velocidad de consultas
//                                  Job No.,Account Type,Production Unit,Piecework Code
//                                  Job No.,Account Type,Type,Allocation Terms,Piecework Code
//                                  Job No.,Account Type,Type,Type Unit Cost,Periodic Cost,Piecework Code
//                                  Job No.,Account Type,Customer Certification Unit,Piecework Code
//                                  Job No.,Account Type,Rental Unit,Piecework Code
//      DGG 20/05/22: - QB 1.10.45 (17304) Se modifica c�digo en OnDelete para que no muestre el aviso al borrar una linea de mayor.
//      JAV 15/06/22: - QB 1.11.02 Se cambia el caption err�neo del campo 75 "Certified Quantity", el name err�neo del campo 76 "Invoiced Quantity", se elimina el campo 123 "Certified Quantity New" que no se usa
//      JAV 04/10/22: - QB 1.12.00 Se a�ade para la activaci�n de gastos los campos 611 QPR Activable y 612 QPR Financial Unit
//      PAT 02/05/23: - Q19256 - "Importe certificado" erroneo en An�lisis Certificaci�n.
//      AML 05/06/23: - Q18150 Se aumenta el n�mero de decimales del campo 14 % Expense Cost a 15 decimales
//      AML 12/05/23: - Q19521 Se elimina el total del campo 67 para que no calcule las unidades de mayor.
//      AML 26/06/23: - Q18527 Funcion copiada de PendingProductionPrice a PendingPrice Calculo del precio pendiente sin tener en cuenta la producci�n.
//      AML 23/06/23: - Q18150 Funcion UpdateMeasurementByPercentage retocada para que reparta de todos los porcentuales la producci�n o los costes. Lo que corresponda.
//      AML 23/06/23: - Q18150 Creado campo 642 Cost Amount Base Que servir� como base de los c�lculos.
//      AML 23/06/23: - //Q18150 Q18527 Funcion copiada de PendingProductionPrice Calculo del precio pendiente sin tener en cuenta la producci�n.
//      CSM 11/07/23: - Q19256 se modifica el campo 93 para que sume "Cert Term PEC amount", en vez de "Cert Source PEC amount".
//    }
    end.
  */
}







