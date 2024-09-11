table 7207277 "Piecework"
{



    CaptionML = ENU = 'Piecework', ESP = 'Unidades de Obra';
    LookupPageID = "Piecework List";
    DrillDownPageID = "Piecework List";

    fields
    {
        field(1; "No."; Text[20])
        {
            CaptionML = ENU = 'No.', ESP = 'No.';
            NotBlank = true;
            Description = '[ Key 2]';


        }
        field(2; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripci�n';

            trigger OnValidate();
            BEGIN
                IF (Alias = UPPERCASE(xRec.Description)) OR (Alias = '') THEN
                    Alias := Description;
            END;


        }
        field(3; "Alias"; Code[50])
        {
            CaptionML = ENU = 'Alias', ESP = 'Alias';


        }
        field(4; "Description 2"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripci�n 2';

            trigger OnValidate();
            BEGIN
                // Ejemplo de validate de campo que esta en funci�n de otro y se ejecuta desde el formulario, ver plantilla.
                // Maestra con borrador
                IF Description = '' THEN
                    ERROR(Text001);
            END;


        }
        field(5; "Unit Type"; Option)
        {
            OptionMembers = "Piecework","Cost Units","Investment Units";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Piecework,Cost Units,Investment Units', ESP = 'Unidad de obra,Unidades de coste,Unidades de inversi�n';



        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Global Dimesion 1 Code', ESP = 'Dimensi�n global 1 c�digo';
            CaptionClass = '1,1,1';

            trigger OnValidate();
            BEGIN
                ValidateShotcutDimCode(1, "Global Dimension 1 Code");
                MODIFY;
            END;


        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Global Dimesion 2 Code', ESP = 'Dimesi�n global 2 c�digo';
            CaptionClass = '1,1,2';

            trigger OnValidate();
            BEGIN
                ValidateShotcutDimCode(2, "Global Dimension 2 Code");
                MODIFY;
            END;


        }
        field(8; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Process"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(9; "Blocked"; Boolean)
        {
            CaptionML = ENU = 'Locked', ESP = 'Bloqueado';
            Editable = true;


        }
        field(10; "Date Last Modified"; Date)
        {
            CaptionML = ENU = 'Date Last Updated', ESP = 'Fecha �ltima modificaci�n';
            Description = 'QB 1.10.35 JAV 12/04/22 Se cambia el caption del campo "FEcha �ltima modificaci�n" para homogeneizar y mejorar la sincronizaci�n';
            Editable = false;


        }
        field(11; "Tree Order Cost"; Text[30])
        {
            CaptionML = ENU = 'Tree Order Cost', ESP = 'Posici�n en el arbol para Coste';
            Description = 'QB 1.12.24 - JAV 14/12/22: - Guardar el orden en el arbol para coste para poder buscar las mediciones';


        }
        field(12; "Tree Order Sales"; Text[30])
        {
            CaptionML = ENU = 'Tree Order Cost', ESP = 'Posici�n en el arbol para Venta';
            Description = 'QB 1.12.24 - JAV 14/12/22: - Guardar el orden en el arbol para coste para poder buscar las mediciones';


        }
        field(14; "Base Price Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Precio Base de Coste';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 04/12/22: Precio base de coste sin el coeficiente de CI';
            AutoFormatType = 2;

            trigger OnValidate();
            VAR
                //                                                                 decAux@1100286000 :
                decAux: Decimal;
            BEGIN
                //JAV 04/12/22: - QB 1.12.24 Calculamos el precio de coste en funci�n del precio base m�s CI y actualizamos los datos

                CostDatabase.GET(Rec."Cost Database Default");

                IF (CostDatabase."CI Cost" = 0) THEN
                    decAux := Rec."Base Price Cost"
                ELSE
                    decAux := ROUND(Rec."Base Price Cost" * (CostDatabase."CI Cost" + 100) / 100, CostDatabase.GetPrecision(1));

                IF (Rec."Price Cost" <> decAux) THEN BEGIN
                    Rec."Price Cost" := decAux;
                    CalcTotalAmounts;

                    //JAV 24/11/22: - QB 1.12.24 Calcular las unidades por encima de la actual
                    MODIFY(FALSE);                                                                          //Guardar el cambio
                    IF (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) THEN                 //Actualziar el padre
                        Piecework.CalculateLine();
                END;
            END;


        }
        field(15; "Base Price Sales"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Precio Base de Venta';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 04/12/22: Precio base de venta sin el coeficiente de CI';
            AutoFormatType = 2;

            trigger OnValidate();
            VAR
                //                                                                 decAux@1100286000 :
                decAux: Decimal;
            BEGIN
                //JAV 04/12/22: - QB 1.12.24 Calculamos el precio de venta en funci�n del precio base m�s CI y actualizamos los datos

                CostDatabase.GET(Rec."Cost Database Default");

                IF (CostDatabase."CI Sales" = 0) THEN
                    decAux := Rec."Base Price Sales"
                ELSE
                    decAux := ROUND(Rec."Base Price Sales" * (CostDatabase."CI Sales" + 100) / 100, CostDatabase.GetPrecision(1));

                IF (Rec."Proposed Sale Price" <> decAux) THEN BEGIN
                    Rec."Proposed Sale Price" := decAux;
                    CalcTotalAmounts;

                    //JAV 24/11/22: - QB 1.12.24 Calcular las unidades por encima de la actual
                    MODIFY(FALSE);                                                                          //Guardar el cambio
                    IF (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) THEN                 //Actualziar el padre
                        Piecework.CalculateLine();
                END;
            END;


        }
        field(16; "Units of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Units of Measure', ESP = 'Unidad de medida';


        }
        field(17; "Cost Database Default"; Code[20])
        {
            CaptionML = ENU = 'Cost Database Default', ESP = 'C�digo de Preciario';
            NotBlank = true;
            Description = 'Key 1';


        }
        field(18; "Price Cost"; Decimal)
        {


            CaptionML = ENU = 'Price Cost', ESP = 'Precio coste';
            DecimalPlaces = 2 : 6;

            trigger OnValidate();
            BEGIN
                //JAV 24/11/22: - QB 1.12.24 Se cambia la forma de obtener la precisi�n de los redondeos
                //CLEAR(Currency);
                //Currency.InitRoundingPrecision;
                CostDatabase.GET(Rec."Cost Database Default");
                "Price Cost" := ROUND("Price Cost", CostDatabase.GetPrecision(1));  //JAV 05/02/21: - QB 1.08.08 Redondear el precio correctamente

                //JAV 04/12/22: - QB 1.12.24 Calculamos el precio base en funci�n del precio de coste directo
                IF (CostDatabase."CI Cost" = 0) THEN
                    Rec."Base Price Cost" := Rec."Price Cost"
                ELSE
                    Rec."Base Price Cost" := ROUND((Rec."Price Cost" * 100) / (CostDatabase."CI Cost" + 100), CostDatabase.GetPrecision(4));

                CalcTotalAmounts;

                //JAV 24/11/22: - QB 1.12.24 Calcular las unidades por encima de la actual
                MODIFY(FALSE);                                                                          //Guardar el cambio
                IF (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) THEN                 //Actualziar el padre
                    Piecework.CalculateLine();
            END;


        }
        field(19; "Proposed Sale Price"; Decimal)
        {


            CaptionML = ENU = 'Proposed Sale Price', ESP = 'Precio venta propuesto';
            DecimalPlaces = 2 : 6;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                //JAV 24/11/22: - QB 1.12.24 Se cambia la forma de obtener la precisi�n de los redondeos
                //CLEAR(Currency);
                //Currency.InitRoundingPrecision;
                CostDatabase.GET(Rec."Cost Database Default");
                "Proposed Sale Price" := ROUND("Proposed Sale Price", CostDatabase.GetPrecision(1));  //JAV 05/02/21: - QB 1.08.08 Redondear el precio correctamente

                //JAV 04/12/22: - QB 1.12.24 Calculamos el precio base en funci�n del precio de coste directo
                IF (CostDatabase."CI Sales" = 0) THEN
                    Rec."Base Price Sales" := Rec."Proposed Sale Price"
                ELSE
                    Rec."Base Price Sales" := ROUND((Rec."Proposed Sale Price" * 100) / (CostDatabase."CI Sales" + 100), CostDatabase.GetPrecision(4));

                CalcTotalAmounts;

                //JAV 24/11/22: - QB 1.12.24 Calcular las unidades de nivel superior
                MODIFY(FALSE);                                                                          //Guardar el cambio
                IF (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) THEN                 //Actualizar el padre
                    Piecework.CalculateLine();
            END;


        }
        field(20; "% Margin"; Decimal)
        {


            CaptionML = ENU = '% Margin', ESP = '% Margen';
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate();
            BEGIN
                //JAV 24/11/22: - QB 1.12.24 Se cambia la forma de obtener la precisi�n de los redondeos
                //CLEAR(Currency);
                //Currency.InitRoundingPrecision;
                CostDatabase.GET(Rec."Cost Database Default");

                IF ("Unit Type" = "Unit Type"::Piecework) AND ("% Margin" <> 0) THEN
                    "Proposed Sale Price" := ROUND("Price Cost" * (1 + ("% Margin" / 100)), CostDatabase.GetPrecision(1));

                //-->Q2032
                CalcTotalAmounts;
                //<--Q2032
            END;


        }
        field(21; "Gross Profit Percentage"; Decimal)
        {
            CaptionML = ENU = 'Gross Profit Percentage', ESP = 'Porcentaje B. bruto';
            Editable = false;


        }
        field(22; "Type Cost Unit"; Option)
        {
            OptionMembers = "Internal","Outside";

            CaptionML = ENU = 'Type Cost Unit', ESP = 'Tipo unidad de coste';
            OptionCaptionML = ENU = 'Internal, Outside', ESP = 'Interno, Externo';


            trigger OnValidate();
            BEGIN
                CostTypeContol;
            END;


        }
        field(23; "Periodic Cost"; Boolean)
        {
            CaptionML = ENU = 'Periodic Cost', ESP = 'Periodificable';


        }
        field(24; "Posting Group Unit Cost"; Code[20])
        {
            TableRelation = "Units Posting Group";


            CaptionML = ENU = 'Posting Group Unit Cost', ESP = 'Grupo contable unidad coste';

            trigger OnValidate();
            BEGIN
                CreateLineBillofItem;
            END;


        }
        field(25; "Jobs Structured Billing"; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Jobs Structured Billing', ESP = 'Proy. estructura facturaci�n';

            trigger OnValidate();
            BEGIN
                JobsControl("Jobs Structured Billing");
            END;


        }
        field(26; "Allocation Terms"; Option)
        {
            OptionMembers = "Fixed amount","% about production","% about direct cost";
            CaptionML = ENU = 'Allocation Terms', ESP = 'Modo de imputaci�n';
            OptionCaptionML = ENU = 'Fixed amount,% about production,% about direct cost', ESP = 'Importe fijo,% sobre producci�n,% sobre coste directos';



        }
        field(27; "Automatic Additional Text"; Boolean)
        {
            CaptionML = ENU = 'Automatic Additional Text', ESP = 'Texto adicional autom�tico';


        }
        field(28; "PRESTO Code Cost"; Code[20])
        {
            CaptionML = ENU = 'PRESTO Code', ESP = 'Cod. PRESTO Coste';
            Description = 'QB 1.12.24 JAV 05/12/22: - Puede ser diferente en coste y en venta, se cambia el nombre';


        }
        field(29; "PRESTO Code Sales"; Code[40])
        {
            CaptionML = ENU = 'Cost Database PRESTO Code', ESP = 'Cod. PRESTO Venta';
            Description = 'QB 1.12.24 JAV 05/12/22: - Puede ser diferente en coste y en venta, nuevo campo';


        }
        field(30; "Measurement Cost"; Decimal)
        {


            CaptionML = ENU = 'Measurement Default', ESP = 'Medici�n para coste';
            DecimalPlaces = 2 : 4;
            Description = 'QB 1.06.09 - JAV 08/08/20: - Esta ser� la medici�n de coste, se cambia name y caption';

            trigger OnValidate();
            BEGIN
                CalcTotalAmounts;

                //JAV 24/11/22: - QB 1.12.24 Calcular las unidades por encima
                MODIFY(FALSE);                                                       //Guardar el cambio
                IF (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) THEN                 //Actualziar el padre
                    Piecework.CalculateLine();
            END;


        }
        field(31; "Resource Subcontracting Code"; Code[20])
        {
            TableRelation = "Resource";


            CaptionML = ENU = 'Resource Subcontracting Code', ESP = 'Cod. recurso subcontrataci�n';

            trigger OnValidate();
            BEGIN
                IF Resource.GET("Resource Subcontracting Code") THEN BEGIN
                    "Cod. Activity" := Resource."Jobs Deviation";
                END;
            END;


        }
        field(32; "Concept Analitycal Subcon Code"; Code[20])
        {


            CaptionML = ENU = 'Concept Analitycal Subcon Code', ESP = 'Cod. concepto anal�tico subcon.';

            trigger OnValidate();
            BEGIN
                IF FunctionQB.AccessToQuobuilding THEN BEGIN
                    FunctionQB.ValidateCA("Concept Analitycal Subcon Code");
                    IF DimensionValue.GET(FunctionQB.ReturnDimCA, "Concept Analitycal Subcon Code") THEN
                        IF DimensionValue.Type <> DimensionValue.Type::Expenses THEN BEGIN
                            "Concept Analitycal Subcon Code" := xRec."Concept Analitycal Subcon Code";
                            ERROR(Text000);
                        END;
                END;
            END;

            trigger OnLookup();
            BEGIN
                IF FunctionQB.LookUpCA("Concept Analitycal Subcon Code", FALSE) THEN
                    VALIDATE("Concept Analitycal Subcon Code");
            END;


        }
        field(33; "Account Type"; Option)
        {
            OptionMembers = "Unit","Heading";

            CaptionML = ENU = 'Account Type', ESP = 'Tipo cuenta';
            OptionCaptionML = ENU = 'Unit,Heading', ESP = 'Unidad,Mayor';


            trigger OnValidate();
            BEGIN
                Totaling := '';

                //JAV 04/10/19: - Poner el sumatorio al validar el tipo de unidad
                VALIDATE(Totaling);
            END;


        }
        field(34; "Identation"; Integer)
        {
            CaptionML = ENU = 'Identation', ESP = 'Indentar';
            MinValue = 0;


        }
        field(35; "Totaling"; Text[250])
        {
            TableRelation = "Piecework";


            ValidateTableRelation = false;
            CaptionML = ENU = 'Totaling', ESP = 'Sumatorio';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 04/10/19: - Poner el sumatorio al validar el tipo de unidad
                IF ("Account Type" = "Account Type"::Heading) THEN
                    Totaling := "No." + '..' + PADSTR("No.", 20, '9')
                ELSE
                    Totaling := '';
            END;


        }
        field(36; "Unique Code"; Code[30])
        {
            CaptionML = ENU = 'Unique Code', ESP = 'C�digo �nico';
            Description = 'QB- Ampliado para importar m�s niveles en BC3';


        }
        field(37; "Production Unit"; Boolean)
        {


            CaptionML = ENU = 'Form', ESP = 'Unidad de Producci�n';
            Description = 'QB 1.12.24 - JAV 13/12/22: - Indica si la unidad es de producci�n (coste)';

            trigger OnValidate();
            BEGIN
                Rec."Production Unit" := (Rec."PRESTO Code Cost" <> '');
                Rec."Certification Unit" := (Rec."PRESTO Code Sales" <> '');
            END;


        }
        field(39; "Cod. Activity"; Code[20])
        {
            TableRelation = "Activity QB";
            CaptionML = ENU = 'Cod. Activity', ESP = 'Cod. actividad';


        }
        field(40; "Subtype Cost"; Option)
        {
            OptionMembers = " ","Deprec. Anticipated","Current Expenses","Deprec. Inmovilized","Deprec. Deferred","Financial Charges","Others";
            CaptionML = ENU = 'Subtype Cost', ESP = 'Subtipo coste';
            OptionCaptionML = ENU = '" ,Deprec. Anticipated,Current Expenses,Deprec. Inmovilized,Deprec. Deferred,Financial Charges,Others"', ESP = '" ,Amort. Anticipados,Gastos Corrientes,Amort. Inmovilizado,Amort. Diferidos,Cargas financieras,Otros"';



        }
        field(41; "Certification Unit"; Boolean)
        {
            CaptionML = ENU = 'Certification Unit', ESP = 'Unidad de certificaci�n';
            Description = 'PER 20.03.19 Se indica no editable';


        }
        field(42; "Piecework Filter"; Code[20])
        {
            CaptionML = ESP = 'Filtro Unidades de obra';


        }
        field(43; "Total Amount Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Amount Cost', ESP = 'Importe total coste';
            DecimalPlaces = 2 : 6;
            Description = 'Q2032';
            Editable = false;


        }
        field(44; "Total Amount Sales"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Amount Sales', ESP = 'Importe total venta';
            DecimalPlaces = 2 : 6;
            Description = 'Q2032';
            Editable = false;


        }
        field(45; "Measurement Sale"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measurement Default', ESP = 'Medici�n para venta';
            DecimalPlaces = 2 : 4;
            Description = 'QB 1.06.09 - JAV 08/08/20: - Esta ser� la medici�n de coste, o la de coste y venta si no se indica otra cosa';

            trigger OnValidate();
            BEGIN
                CalcTotalAmounts;

                //JAV 24/11/22: - QB 1.12.24 Calcular las unidades por encima
                MODIFY(FALSE);                                                       //Guardar el cambio
                IF (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) THEN                 //Actualziar el padre
                    Piecework.CalculateLine();
            END;


        }
        field(59; "Title"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Title', ESP = 'T�tulo';
            Description = 'QB 1.06.07 - JAV 05/10/19: - Se a�ade el campo "Title" para compatibilizar con Data Piecework for Production';


        }
        field(60; "Father Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo del Padre';
            Description = 'QB 1.12.24 - JAV 24/11/22: - Cual es el c�digo del padre de esta Unidad';


        }
        field(61; "Bill Of Items Cost"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Bill of Item Data" WHERE("Cod. Cost database" = FIELD("Cost Database Default"),
                                                                                                "Cod. Piecework" = FIELD("No."),
                                                                                                "Use" = CONST("Cost")));
            CaptionML = ESP = 'Tiene Descompuestos de Coste';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene descompuestos de Coste';


        }
        field(62; "Bill Of Items Sales"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Bill of Item Data" WHERE("Cod. Cost database" = FIELD("Cost Database Default"),
                                                                                                "Cod. Piecework" = FIELD("No."),
                                                                                                "Use" = CONST("Sales")));
            CaptionML = ESP = 'Tiene Descompuestos de Venta';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene descompuestos de Venta';


        }
        field(63; "Meditions Cost"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Measure Line Piecework PRESTO" WHERE("Cost Database Code" = FIELD("Cost Database Default"),
                                                                                                            "Cod. Jobs Unit" = FIELD("No."),
                                                                                                            "Use" = CONST("Cost")));
            CaptionML = ESP = 'Tiene Mediciones de Coste';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene mediciones de Coste';


        }
        field(64; "Meditions Sale"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Measure Line Piecework PRESTO" WHERE("Cost Database Code" = FIELD("Cost Database Default"),
                                                                                                            "Cod. Jobs Unit" = FIELD("No."),
                                                                                                            "Use" = CONST("Sales")));
            CaptionML = ESP = 'Tiene Mediciones de Venta';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene mediciones de Venta';


        }
        field(65; "Have Sons"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(Piecework WHERE("Cost Database Default" = FIELD("Cost Database Default"),
                                                                                      "Father Code" = FIELD("No.")));
            CaptionML = ESP = 'Tiene unidades hijas';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene Tiene unidades hijas';


        }
        field(66; "Received Cost Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. Precio de Coste';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 25/11/22: Precio de coste que hemos recibido en el BC3';


        }
        field(67; "Received Sales Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. Precio de Venta';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 25/11/22: Precio de venta que hemos recibido en el BC3';


        }
        field(68; "Received Cost Medition"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. Medici�n de Coste';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 28/11/22: Medici�n de coste que hemos recibido en el BC3';


        }
        field(69; "Received Sales Medition"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. Medici�n de Venta';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 28/11/22: Medici�n de venta que hemos recibido en el BC3';


        }
        field(70; "Received % Amount Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. % eliminado Coste';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene porcentuales de coste eliminados, su importe para reducir del total recibido';


        }
        field(71; "Received % Amount Sales"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. % eliminado Venta';
            Description = 'QB 1.12.24 - JAV 25/11/22: - Si tiene porcentuales de venta eliminados, su importe para reducir del total recibido';


        }
        field(124; "No. DP Cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Bill of Item Data" WHERE("Cod. Cost database" = FIELD("Cost Database Default"),
                                                                                                "Cod. Piecework" = FIELD("No."),
                                                                                                "Use" = CONST("Cost")));
            CaptionML = ESP = 'N� Descompuestos coste';
            Description = 'QB 1.06.07 - JAV 24/04/20: - Cuantas l�neas de descompuestos de coste tiene';
            Editable = false;


        }
        field(125; "No. DP Sale"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Bill of Item Data" WHERE("Cod. Cost database" = FIELD("Cost Database Default"),
                                                                                                "Cod. Piecework" = FIELD("No."),
                                                                                                "Use" = CONST("Sales")));
            CaptionML = ESP = 'N� Descompuestos venta';
            Description = 'QB 1.06.07 - JAV 24/04/20: - Cuantas l�neas de descompuestos de venta tiene';
            Editable = false;


        }
        field(126; "No. Medition detail Cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measure Line Piecework PRESTO" WHERE("Cost Database Code" = FIELD("Cost Database Default"),
                                                                                                            "Cod. Jobs Unit" = FIELD("No."),
                                                                                                            "Use" = CONST("Cost")));
            CaptionML = ENU = 'No. Medition detail lines', ESP = 'N� lineas Medici�n Coste';
            Description = 'QB 1.06.07 - JAV 11/03/19 Cantidad de l�neas de medici�n que tiene';
            Editable = false;


        }
        field(127; "No. Medition detail Sales"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Measure Line Piecework PRESTO" WHERE("Cost Database Code" = FIELD("Cost Database Default"),
                                                                                                            "Cod. Jobs Unit" = FIELD("No."),
                                                                                                            "Use" = CONST("Sales")));
            CaptionML = ENU = 'No. Medition detail lines', ESP = 'N� lineas Medici�n Venta';
            Description = 'QB 1.06.07 - JAV 11/03/19 Cantidad de l�neas de medici�n que tiene';
            Editable = false;


        }
        field(128; "Aditional Text"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Text" WHERE("Table" = CONST("Preciario"),
                                                                                      "Key1" = FIELD("Cost Database Default"),
                                                                                      "Key2" = FIELD("No.")));
            CaptionML = ENU = 'No. Piecework with Aditional Text', ESP = 'Texto adicional';
            Description = 'QB 1.06.07 - JAV 11/03/19 Si posee textos adicionales';
            Editable = false;


        }
        field(500; "Diferencia"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Q18285 AML 24/03/22';


        }
        field(501; "Diferencia Descompuesto"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Bill of Item Data" WHERE("Cod. Cost database" = FIELD("Cost Database Default"),
                                                                                                "Cod. Piecework" = FIELD("No."),
                                                                                                "Diferencia" = CONST(true)));
            Description = 'Q18285 AML 24/03/22';


        }
        field(502; "Received Cost Price Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. Precio de Coste';
            DecimalPlaces = 2 : 6;
            Description = 'Q18285 AML 24/03/22';


        }
        field(503; "Received Sales Price Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido. Precio de Venta';
            DecimalPlaces = 2 : 6;
            Description = 'Q18285 AML 24/03/22';


        }
        field(504; "Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Q18285 AML 24/03/22';


        }
        field(505; "Sin Descompuesto"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Q18285 AML 24/03/22';


        }
    }
    keys
    {
        key(key1; "Cost Database Default", "No.")
        {
            Clustered = true;
        }
        key(key2; "Alias")
        {
            ;
        }
        key(key3; "Jobs Structured Billing")
        {
            ;
        }
        key(key4; "Cost Database Default", "PRESTO Code Cost")
        {
            ;
        }
        key(key5; "Cost Database Default", "PRESTO Code Sales")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       CostDatabase@1100286000 :
        CostDatabase: Record 7207271;
        //       Piecework@1100286001 :
        Piecework: Record 7207277;
        //       ConfJobsUnits@60000 :
        ConfJobsUnits: Record 7207279;
        //       CommentLine@60002 :
        CommentLine: Record 97;
        //       NoSeriesManagement@60003 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       DimensionManagement@60004 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       Job@60006 :
        Job: Record 167;
        //       BillofItemData@60007 :
        BillofItemData: Record 7207384;
        //       QBText@60008 :
        QBText: Record 7206918;
        //       MeasureLineJUPRESTO@60009 :
        MeasureLineJUPRESTO: Record 7207285;
        //       DefaultDimension@60010 :
        DefaultDimension: Record 352;
        //       PriceCostDatabasePRESTO@60011 :
        PriceCostDatabasePRESTO: Record 7207284;
        //       FunctionQB@60012 :
        FunctionQB: Codeunit 7207272;
        //       DimensionValue@60013 :
        DimensionValue: Record 349;
        //       Resource@60014 :
        Resource: Record 156;
        //       Currency@60015 :
        Currency: Record 4;
        //       Text001@60016 :
        Text001: TextConst ENU = 'You must first fill in the description1 to can fill in the 2', ESP = 'Debe rellenar primero la descripci�n1 para poder rellenar la 2';
        //       Text002@60017 :
        Text002: TextConst ENU = 'the jobs is blocked', ESP = 'El proyecto esta bloqueado';
        //       Text003@60018 :
        Text003: TextConst ENU = 'The jobs must be the structure', ESP = 'El proyecto debe ser de estructura';
        //       Text005@60019 :
        Text005: TextConst ENU = 'Do you want to change the type?', ESP = '�Desea cambia el tipo?';
        //       Text004@60020 :
        Text004: TextConst ENU = 'There are lines of separate, if you change the type will be deleted', ESP = 'Existen l�neas de descompuesto, si cambia el tipo se borrar�n';
        //       Text000@60021 :
        Text000: TextConst ENU = 'The anality concept of subcontracting must be of type expenses', ESP = 'El concepto analitico de subcontrataci�n deber�a ser de tipo gasto';
        //       CodeCavta@60022 :
        CodeCavta: Code[20];



    trigger OnInsert();
    begin
        //JAV 15/10/20: - QB 1.06.20 La dimensi�n apuntaba a otra tabla
        //DimensionManagement.UpdateDefaultDim(DATABASE::"Approval Entry Q","No.","Global Dimension 1 Code","Global Dimension 2 Code");
        DimensionManagement.UpdateDefaultDim(DATABASE::Piecework, "No.", "Global Dimension 1 Code", "Global Dimension 2 Code");

        "Unique Code" := "Cost Database Default" + COPYSTR("No.", 1, 10);

        if "Measurement Cost" = 0 then
            "Measurement Cost" := 1;

        //JAV 04/10/19: - Poner el sumatorio al validar el tipo de unidad y hacerlo no editable pues ahora cambiar� solo
        VALIDATE("Account Type");
        VALIDATE("Production Unit");
    end;

    trigger OnModify();
    begin
        "Date Last Modified" := TODAY;
        DefOblig;

        //JAV 04/10/19: - Poner el sumatorio al validar el tipo de unidad y hacerlo no editable pues ahora cambiar� solo
        VALIDATE("Account Type");
        VALIDATE("Production Unit");
    end;

    trigger OnDelete();
    begin
        // {
        //         CommentLine.RESET;
        //         CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"IC Partner");
        //         CommentLine.SETRANGE("No.", "Unique Code");
        //         CommentLine.DELETEALL;
        // }
        // Eliminar textos adicionales
        QBText.RESET;
        QBText.SETRANGE(Table, QBText.Table::Preciario);
        QBText.SETRANGE(Key1, "Cost Database Default");
        QBText.SETRANGE(Key2, "No.");
        QBText.DELETEALL(TRUE);

        // Eliminar Datos de descompuesto
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", "Cost Database Default");
        BillofItemData.SETRANGE("Cod. Piecework", "No.");
        BillofItemData.DELETEALL;

        // Eliminar las l�neas de medici�n
        MeasureLineJUPRESTO.SETRANGE("Cost Database Code", "Cost Database Default");
        MeasureLineJUPRESTO.SETRANGE("Cod. Jobs Unit", "No.");
        MeasureLineJUPRESTO.DELETEALL(TRUE);

        // {
        //         // Eliminar las dimensiones por defecto
        //         DefaultDimension.SETRANGE("Table ID", DATABASE::"Approval Entry Q");
        //         DefaultDimension.SETRANGE("No.", "Unique Code");
        //         DefaultDimension.DELETEALL;

        // }
        // Precios de presto
        PriceCostDatabasePRESTO.SETRANGE("Cod. Cost Database", "Cost Database Default");
        PriceCostDatabasePRESTO.SETRANGE(Piecework, "No.");
        PriceCostDatabasePRESTO.DELETEALL;
    end;

    trigger OnRename();
    begin
        "Date Last Modified" := TODAY;
    end;



    // procedure ValidateShotcutDimCode (FielNo@60000 : Integer;var ShortcutDimCode@60001 :
    procedure ValidateShotcutDimCode(FielNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateDimValueCode(FielNo, ShortcutDimCode);
        DimensionManagement.SaveDefaultDim(DATABASE::Piecework, "Unique Code", FielNo, ShortcutDimCode);
        MODIFY;
    end;

    procedure InsertPosting()
    begin
        // Solo para maestras con creaci�n por borrador
        // Metemos todos los controles que queremos meter antes de la inserci�n del registro en la tabla.

        VALIDATE(Description);
        VALIDATE(Description);

        // Se inserta el registro
        INSERT(TRUE);

        // Se hacen validates de los campos que quiere que el registro este insertado.
        VALIDATE("Global Dimension 1 Code");
        VALIDATE("Global Dimension 2 Code");
    end;

    procedure DefOblig()
    begin
        TESTFIELD(Description);
    end;

    procedure CreateLineBillofItem()
    var
        //       BillofItemData@60000 :
        BillofItemData: Record 7207384;
        //       UnitsPostingGroup@60001 :
        UnitsPostingGroup: Record 7207431;
    begin
        if "Type Cost Unit" = "Type Cost Unit"::Outside then begin
            BillofItemData.SETRANGE("Cod. Cost database", "Cost Database Default");
            BillofItemData.SETRANGE("Cod. Piecework", "No.");
            if BillofItemData.FINDFIRST then
                BillofItemData.DELETEALL;

            BillofItemData.RESET;
            BillofItemData.INIT;
            if UnitsPostingGroup.GET("Posting Group Unit Cost") then;
            BillofItemData.VALIDATE("Cod. Cost database", "Cost Database Default");
            BillofItemData.VALIDATE("Cod. Piecework", "No.");
            BillofItemData.VALIDATE(Type, BillofItemData.Type::Account);
            BillofItemData.VALIDATE("No.", UnitsPostingGroup."Cost Account");
            BillofItemData.VALIDATE("Concep. Analytical Direct Cost", UnitsPostingGroup."Cost Analytic Concept");
            BillofItemData.VALIDATE("Quantity By", 1);
            BillofItemData."Units of Measure" := "Units of Measure";
            BillofItemData.VALIDATE("Direct Unit Cost", 1);
            if not BillofItemData.INSERT then
                BillofItemData.MODIFY;
        end;

        CalculateUnit;
    end;

    //     procedure JobsControl (JobsCode@60000 :
    procedure JobsControl(JobsCode: Code[20])
    begin
        //JAV 23/11/20: - QB 1.07.06 Si no nos pasan un proyecto no hacemos nada
        if (JobsCode = '') then
            exit;

        Job.GET(JobsCode);

        if Job.Blocked <> Job.Blocked::" " then
            ERROR(Text002);

        if Job."Job Type" <> Job."Job Type"::Structure then
            ERROR(Text003);
    end;

    //     procedure DeleteBillofItem (BillofItemData@60000 :
    procedure DeleteBillofItem(BillofItemData: Record 7207384)
    begin
        BillofItemData.DELETEALL;
        CreateLineBillofItem;
    end;

    procedure CostTypeContol()
    begin
        if ("Type Cost Unit" <> xRec."Type Cost Unit")
            and ("Type Cost Unit" = "Type Cost Unit"::Outside) and ("Posting Group Unit Cost" <> '') then begin
            BillofItemData.SETRANGE("Cod. Piecework", "No.");
            if BillofItemData.FINDFIRST then
                if CONFIRM(Text004 + Text005, FALSE) then
                    DeleteBillofItem(BillofItemData)
                else
                    "Type Cost Unit" := "Type Cost Unit"::Internal;
        end else
            CreateLineBillofItem;
    end;

    procedure CalcTotalAmounts()
    begin
        //JAV 24/11/22: - QB 1.12.24 Se cambia la forma de obtener la precisi�n de los redondeos
        //CLEAR(Currency);
        //Currency.InitRoundingPrecision;
        CostDatabase.GET(Rec."Cost Database Default");
        //
        VALIDATE("Total Amount Cost", ROUND("Measurement Cost" * "Price Cost", CostDatabase.GetPrecision(2)));
        VALIDATE("Total Amount Sales", ROUND("Measurement Sale" * "Proposed Sale Price", CostDatabase.GetPrecision(2)));

        //JAV 04/12/22: - QB 1.12.24 Se traslada este c�lculo para no repetir c�digo
        if ("Unit Type" = "Unit Type"::Piecework) then begin
            if "Total Amount Cost" <> 0 then
                "% Margin" := ROUND((("Total Amount Sales" - "Total Amount Cost") * 100 / "Total Amount Cost"), 0.01)
            else
                "% Margin" := 0;

            if "Total Amount Sales" <> 0 then
                "Gross Profit Percentage" := ROUND((("Total Amount Sales" - "Total Amount Cost") * 100 / "Total Amount Sales"), 0.01)
            else
                "Gross Profit Percentage" := 0;
        end else begin
            "% Margin" := 0;
            "Gross Profit Percentage" := 0;
            "Proposed Sale Price" := 0;
        end;
    end;

    procedure CalculateLine()
    begin
        //Lanzar el c�lculo seg�n sea cap�tulo o partida
        if (Rec."Account Type" = Rec."Account Type"::Unit) then
            CalculateUnit()
        else
            CalculateHeading();
    end;

    procedure CalculateUnit()
    var
        //       BillofItemData@60000 :
        BillofItemData: Record 7207384;
        //       TBaseCost@60001 :
        TBaseCost: Decimal;
        //       TCost@1100286004 :
        TCost: Decimal;
        //       TBaseSale@1100286003 :
        TBaseSale: Decimal;
        //       TSale@1100286000 :
        TSale: Decimal;
        //       ExistCost@1100286001 :
        ExistCost: Boolean;
        //       ExistSale@1100286002 :
        ExistSale: Boolean;
    begin
        // Esta funci�n calcula el precio de coste y el de venta de las partidas sumando los importes de los descompuestos si los tienen, si no tienen no los toca

        //Este c�lculo no es para los cap�tulos, solo las partidas
        if (Rec."Account Type" <> Rec."Account Type"::Unit) then
            exit;

        CostDatabase.GET(Rec."Cost Database Default");
        if (CostDatabase.Version = 0) then begin
            PW_SetFatherCodeForAll(Rec."Cost Database Default");                 //Por si no lo tiene establecido
            Rec.GET(Rec."Cost Database Default", Rec."No.");  //Volvemos a leer el registro actual por si ha cambiado
        end;

        //JAV 24/11/22: - QB 1.12.24 Se cambia la forma de obtener la precisi�n de los redondeos
        //CLEAR(Currency);
        //Currency.InitRoundingPrecision;

        TBaseCost := 0;
        TCost := 0;
        TBaseSale := 0;
        TSale := 0;
        ExistCost := FALSE;
        ExistSale := FALSE;
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", "Cost Database Default");
        BillofItemData.SETRANGE("Cod. Piecework", "No.");
        BillofItemData.SETFILTER("Father Code", '=%1', '');   //JAV 22/11/22: - QB 1.12.24 Solo calculamos con las unidades de nivel superior
                                                              //used without Updatekey Parameter to avoid warning - may become error in future release
                                                              /*To be Tested*/
                                                              //if BillofItemData.FINDSET(FALSE,FALSE) then
        if BillofItemData.FINDSET(FALSE) then
            repeat
                if (BillofItemData.Use = BillofItemData.Use::Cost) then begin
                    TBaseCost += ROUND((BillofItemData."Base Unit Cost" * BillofItemData."Quantity By" * BillofItemData."Bill of Item Units") +
                                       (BillofItemData."Unit Cost Indirect" * BillofItemData."Quantity By" * BillofItemData."Bill of Item Units"),
                                        CostDatabase.GetPrecision(5));
                    TCost += BillofItemData."Piecework Cost";
                    ExistCost := TRUE;
                end;
                if (BillofItemData.Use = BillofItemData.Use::Sales) then begin
                    TBaseSale += ROUND((BillofItemData."Base Unit Cost" * BillofItemData."Quantity By" * BillofItemData."Bill of Item Units") +
                                       (BillofItemData."Unit Cost Indirect" * BillofItemData."Quantity By" * BillofItemData."Bill of Item Units"),
                                        CostDatabase.GetPrecision(5));
                    TSale += BillofItemData."Piecework Cost";
                    ExistSale := TRUE;
                end;
            until BillofItemData.NEXT = 0;

        if (ExistCost) then begin
            Rec."Base Price Cost" := ROUND(TBaseCost, CostDatabase.GetPrecision(1));
            Rec."Price Cost" := ROUND(TCost, CostDatabase.GetPrecision(1));
            if ("% Margin" <> 0) then
                Rec."Proposed Sale Price" := ROUND(TCost * (1 + (Rec."% Margin" / 100)), CostDatabase.GetPrecision(1));
        end else
            Rec.VALIDATE("Base Price Cost");

        if (ExistSale) then begin
            Rec."Base Price Sales" := ROUND(TBaseSale, CostDatabase.GetPrecision(1));
            Rec."Proposed Sale Price" := ROUND(TSale, CostDatabase.GetPrecision(1));
        end else
            Rec.VALIDATE("Base Price Sales");

        Rec."Total Amount Cost" := ROUND(Rec."Price Cost" * Rec."Measurement Cost", CostDatabase.GetPrecision(2));
        Rec."Total Amount Sales" := ROUND(Rec."Proposed Sale Price" * Rec."Measurement Sale", CostDatabase.GetPrecision(2));
        Rec.MODIFY(FALSE); //Guardar el importe de la l�nea
    end;

    procedure CalculateHeading()
    var
        //       Piecework@1100286007 :
        Piecework: Record 7207277;
        //       Piecework2@1100286004 :
        Piecework2: Record 7207277;
        //       i@1100286002 :
        i: Integer;
        //       NewBaseCost@1100286006 :
        NewBaseCost: Decimal;
        //       NewCost@1100286001 :
        NewCost: Decimal;
        //       NewBaseSale@1100286000 :
        NewBaseSale: Decimal;
        //       NewSale@1100286005 :
        NewSale: Decimal;
        //       cnt@1100286003 :
        cnt: Integer;
        //       find@1100286009 :
        find: Boolean;
        //       lastLevel@1100286010 :
        lastLevel: Boolean;
    begin
        // Esta funci�n calcula el precio de coste y el de venta de los cap�tulos sumando los importes de las unidades que hay por debajo

        //Este c�lculo no es para las partidas, solo las de mayor
        if (Rec."Account Type" <> Rec."Account Type"::Heading) then
            exit;

        CostDatabase.GET(Rec."Cost Database Default");
        if (CostDatabase.Version = 0) then begin
            PW_SetFatherCodeForAll(Rec."Cost Database Default");                 //Por si no lo tiene establecido
            Rec.GET(Rec."Cost Database Default", Rec."No.");  //Volvemos a leer el registro actual por si ha cambiado
        end;

        //Calcular la unidad sumando lo que est� por debajo directamente
        NewBaseCost := 0;
        NewCost := 0;
        NewBaseSale := 0;
        NewSale := 0;
        cnt := 0;
        Piecework2.RESET;
        Piecework2.SETRANGE("Cost Database Default", Rec."Cost Database Default");
        Piecework2.SETFILTER("No.", Rec.Totaling);
        Piecework2.SETRANGE("Father Code", Rec."No.");
        if (Piecework2.FINDSET(FALSE)) then begin
            repeat
                if (Piecework2."No." <> Rec."No.") then begin
                    NewBaseCost += ROUND(Piecework2."Base Price Cost" * Piecework2."Measurement Cost", CostDatabase.GetPrecision(2));
                    NewCost += Piecework2."Total Amount Cost";
                    NewBaseSale += ROUND(Piecework2."Base Price Sales" * Piecework2."Measurement Sale", CostDatabase.GetPrecision(2));
                    NewSale += Piecework2."Total Amount Sales";
                    cnt += 1;
                end;
            until Piecework2.NEXT = 0;

            if (cnt <> 0) then begin
                Rec."Base Price Cost" := ROUND(NewBaseCost, CostDatabase.GetPrecision(1));             //JAV 05/02/21: - QB 1.08.08 Redondear los precios correctamente
                Rec."Price Cost" := ROUND(NewCost, CostDatabase.GetPrecision(1));
                Rec."Base Price Sales" := ROUND(NewBaseSale, CostDatabase.GetPrecision(1));
                Rec."Proposed Sale Price" := ROUND(NewSale, CostDatabase.GetPrecision(1));
                Rec.CalcTotalAmounts();
                Rec.MODIFY;
            end;
        end;

        //Calcular la que est� por encima
        if (Rec."Father Code" <> '') then
            if (Piecework.GET(Rec."Cost Database Default", Rec."Father Code")) then
                Piecework.CalculateHeading();
    end;

    //     procedure PW_SetFatherCodeForAll (pCD@1100286004 :
    procedure PW_SetFatherCodeForAll(pCD: Code[20])
    var
        //       Piecework@1100286000 :
        Piecework: Record 7207277;
        //       Piecework2@1100286001 :
        Piecework2: Record 7207277;
        //       i@1100286003 :
        i: Integer;
        //       find@1100286002 :
        find: Boolean;
    begin
        //Buscamos el c�digo de su padre si no lo tiene informado, para todas las unidades del preciario
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCD);
        Piecework.SETRANGE("Father Code", '');
        if (Piecework.FINDSET(TRUE)) then
            repeat
                Piecework.PW_SetFatherCode();
            until (Piecework.NEXT = 0);
    end;

    procedure PW_SetFatherCode()
    var
        //       Piecework2@1100286004 :
        Piecework2: Record 7207277;
        //       i@1100286003 :
        i: Integer;
        //       find@1100286002 :
        find: Boolean;
    begin
        i := STRLEN(Rec."No.");
        find := FALSE;
        repeat
            i -= 1;
            find := Piecework2.GET(Rec."Cost Database Default", COPYSTR(Rec."No.", 1, i));
        until (i = 1) or (find);

        if (find) and (Rec."Father Code" <> Piecework2."No.") then begin
            Rec."Father Code" := Piecework2."No.";
            Rec.MODIFY(FALSE);
        end;
    end;

    /*begin
    //{
//      Q2032 FR 04/06/2018 A�adida llamada a funci�n CalcTotalAmounts
//      JAV 11/03/19: - Se a�aden los campos 45 "Aditional Text" y 46 "Medition detail" con el n�mero de cada uno
//      JAV 04/10/19: - Poner el sumatorio al validar el tipo de unidad y hacerlo no editable pues ahora cambiar� solo
//      JAV 05/10/19: - Se a�ade el campo "Title" para compatibilizar con Data Piecework for Production
//      JAV 15/10/20: - QB 1.06.20 La dimensi�n apuntaba a otra tabla
//      JAV 12/04/22: - QB 1.10.35 Se cambia el caption del campo "Fecha �ltima modificaci�n" para homogeneizar y mejorar la sincronizaci�n
//      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3.
//                                 Se a�aden los campos 60 a 69
//                                 Se eliminan campos que no se usan
//                                 Se a�aden los campos 14 y 15 para el c�lculo del CI
//    }
    end.
  */
}







