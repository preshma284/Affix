table 7207413 "Comparative Quote Lines"
{


    CaptionML = ENU = 'Comparative Quote Lines', ESP = 'Lineas comparativo oferta';
    PasteIsValid = false;
    LookupPageID = "Comparative Quote Lin. Subform";
    DrillDownPageID = "Comparative Quote Lin. Subform";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';

            trigger OnValidate();
            BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, "Job No.", "Dimension Set ID");

                //JAV 16/06/22: - 1.10.50 Si cambia el proyecto y la unidad de obra no existe en el nuevo o si el proyecto est� vac�o, se elimina la U.O. de la l�nea, si no se valida
                IF (Rec."Job No." = '') THEN
                    Rec."Piecework No." := ''
                ELSE IF (Rec."Piecework No." <> '') THEN BEGIN
                    IF (NOT DataPieceworkForProduction.GET(Rec."Job No.", Rec."Piecework No.")) THEN
                        Rec."Piecework No." := ''
                    ELSE
                        Rec.VALIDATE("Piecework No.");
                END;
            END;

            trigger OnLookup();
            VAR
                //                                                               JobNo@1100286000 :
                JobNo: Code[20];
            BEGIN
                //JAV 16/06/22: - 1.10.50 Filtrar por los proyectos a los que tiene acceso el usuario
                JobNo := Rec."Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funci�n
                IF (FunctionQB.LookupUserJobs(JobNo)) THEN
                    VALIDATE("Job No.", JobNo);
            END;


        }
        field(2; "Quote No."; Code[20])
        {
            CaptionML = ENU = 'Quote No.', ESP = 'N� Oferta';
            Description = 'Key 1';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';
            Description = 'Key 2';


        }
        field(4; "Type"; Enum "Purchase Line Type")
        {
            // OptionMembers = "Item","Resource";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            // OptionCaptionML = ENU = 'Item,Resource', ESP = 'Producto,Recurso';


            trigger OnValidate();
            BEGIN
                tmpComparativeQuoteLines := Rec;
                INIT;
                Type := tmpComparativeQuoteLines.Type;
                InitRegisterFromTemp;
                CreateDim(DATABASE::Job, "Job No.", DATABASE::Item, "No.");
            END;


        }
        field(5; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item" ELSE IF ("Type" = CONST("Resource")) "Resource";


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                tmpComparativeQuoteLines := Rec;
                INIT;
                Type := tmpComparativeQuoteLines.Type;
                "No." := tmpComparativeQuoteLines."No.";
                InitRegisterFromTemp;

                IF "No." = '' THEN
                    EXIT;

                GetHeader;

                CASE Type OF
                    Type::Item:
                        BEGIN
                            Item.GET("No.");
                            Description := Item.Description;
                            "Unit of measurement Code" := Item."Base Unit of Measure";
                            "Estimated Price" := Item."Last Direct Cost";
                            "Activity Code" := Item."QB Activity Code";
                            CreateDim(DATABASE::Job, "Job No.", DATABASE::Item, "No.");
                        END;
                    Type::Resource:
                        BEGIN
                            Resource.GET("No.");
                            Description := Resource.Name;
                            "Unit of measurement Code" := Resource."Base Unit of Measure";
                            "Estimated Price" := Resource."Direct Unit Cost";
                            "Activity Code" := Resource."Activity Code";
                            CreateDim(DATABASE::Job, "Job No.", DATABASE::Resource, "No.");
                        END;
                END;

                IF ComparativeQuoteHeader."Comparative To" = ComparativeQuoteHeader."Comparative To"::Location THEN
                    "Location Code" := ComparativeQuoteHeader."Location Code";

                IF (("Location Code" = '') AND (Job.GET("Job No."))) THEN
                    IF Job."Job Location" <> '' THEN
                        "Location Code" := Job."Job Location";

                VALIDATE("Unit of measurement Code");
                IF Type = Type::Item THEN
                    GetBillOfItemData("Job No.", "Piecework No.", 3, "No.", Rec);
                IF Type = Type::Resource THEN
                    GetBillOfItemData("Job No.", "Piecework No.", 1, "No.", Rec);

                getTexts;

                GetValuesFromDimension;
            END;


        }
        field(6; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n Producto/Recurso';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                GetValuesFromDimension;
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                GetValuesFromDimension;
            END;


        }
        field(9; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";
            CaptionML = ENU = 'Activity Code', ESP = 'C�d. Actividad';


        }
        field(10; "Location Code"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Location Code', ESP = 'C�d. Almac�n';


        }
        field(11; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            BEGIN
                "Qty to segregate" := "Initial Estimated Quantity" - Quantity;
                IF ("Qty to segregate" < 0) THEN
                    "Qty to segregate" := 0;

                CalculateAmounts;
            END;


        }
        field(12; "Estimated Price"; Decimal)
        {


            CaptionML = ENU = 'Estimated Price', ESP = 'Precio previsto';
            Editable = false;
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CalculateAmounts;
            END;


        }
        field(13; "Estimated Amount"; Decimal)
        {
            CaptionML = ENU = 'Estimated Amount', ESP = 'Importe previsto';
            Editable = false;
            AutoFormatType = 1;


        }
        field(14; "Target Amount"; Decimal)
        {
            CaptionML = ENU = 'Target Amount', ESP = 'Importe objetivo';
            Description = 'JAV 14/10/19: - Se hace no editable el importe objetivo';
            Editable = false;
            AutoFormatType = 1;


        }
        field(15; "Lowest Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Min("Data Prices Vendor"."Vendor Price" WHERE("Quote Code" = FIELD("Quote No."),
                                                                                                              "Type" = FIELD("Type"),
                                                                                                              "No." = FIELD("No."),
                                                                                                              "Line No." = FIELD("Line No."),
                                                                                                              "Vendor Price" = FILTER(<> 0)));
            CaptionML = ENU = 'Target Price', ESP = 'Precio m�s bajo';
            Editable = false;
            AutoFormatType = 2;


        }
        field(16; "Target Price"; Decimal)
        {


            CaptionML = ENU = 'Target Price', ESP = 'Precio objetivo';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CalculateAmounts;
            END;


        }
        field(17; "Lowert Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Min("Data Prices Vendor"."Purchase Amount" WHERE("Quote Code" = FIELD("Quote No."),
                                                                                                                 "Type" = FIELD("Type"),
                                                                                                                 "No." = FIELD("No."),
                                                                                                                 "Line No." = FIELD("Line No."),
                                                                                                                 "Vendor Price" = FILTER(<> 0)));
            CaptionML = ENU = 'Lowert Amount', ESP = 'Importe m�s bajo';
            Editable = false;
            AutoFormatType = 1;


        }
        field(18; "Piecework No."; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));


            CaptionML = ENU = 'Piecework No./Budget Unit', ESP = 'N� Unidad de obra/Partida presupuestaria';

            trigger OnValidate();
            BEGIN
                IF DataPieceworkForProduction.GET("Job No.", "Piecework No.") THEN BEGIN
                    "Description 2" := DataPieceworkForProduction.Description;
                    IF "Unit of measurement Code" = '' THEN
                        "Unit of measurement Code" := DataPieceworkForProduction."Unit Of Measure";
                END;

                IF Type = Type::Item THEN
                    GetBillOfItemData("Job No.", "Piecework No.", 3, "No.", Rec);
                IF Type = Type::Resource THEN
                    GetBillOfItemData("Job No.", "Piecework No.", 1, "No.", Rec);
                "Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO";

                getTexts;

                IF (FunctionQB.AccessToBudgets OR FunctionQB.AccessToRealEstate) AND (FunctionQB.Job_IsBudget(Rec."Job No.")) THEN BEGIN
                    IF DataPieceworkForProduction.GET("Job No.", "Piecework No.") THEN BEGIN
                        CASE DataPieceworkForProduction."QPR Type" OF
                            DataPieceworkForProduction."QPR Type"::Resource:
                                BEGIN
                                    IF Resource.GET(DataPieceworkForProduction."QPR No.") THEN BEGIN
                                        Rec.Type := Rec.Type::Resource;
                                        Rec.VALIDATE("No.", DataPieceworkForProduction."QPR No.");
                                        "Piecework No." := DataPieceworkForProduction."Piecework Code";
                                    END;
                                END;
                            DataPieceworkForProduction."QPR Type"::Item:
                                BEGIN
                                    IF Item.GET(DataPieceworkForProduction."QPR No.") THEN BEGIN
                                        Rec.Type := Rec.Type::Item;
                                        Rec.VALIDATE("No.", DataPieceworkForProduction."QPR No.");
                                        "Piecework No." := DataPieceworkForProduction."Piecework Code";
                                    END;
                                END;
                        END;
                        IF (DimensionValue.GET(FunctionQB.ReturnDimCA(), DataPieceworkForProduction."QPR AC")) THEN
                            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA(), DataPieceworkForProduction."QPR AC", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID");
                    END;
                END;
            END;


        }
        field(19; "Manual"; Boolean)
        {
            CaptionML = ENU = 'Manual', ESP = 'Manual';


        }
        field(20; "Updated Budget"; Boolean)
        {
            CaptionML = ENU = 'Updated Budget', ESP = 'Presupuesto actualizado';


        }
        field(21; "OLD_Contract Line"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Contract Line', ESP = 'L�nea contrato';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(22; "Unit of measurement Code"; Code[10])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No.")) ELSE IF ("Type" = CONST("Resource")) "Resource Unit of Measure"."Code" WHERE("Resource No." = FIELD("No."));


            CaptionML = ENU = 'Unit of measurement Code', ESP = 'C�d. unidad de medida';

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                CASE Type OF
                    Type::Item:
                        BEGIN
                            IF NOT ItemUnitofMeasure.GET("No.", "Unit of measurement Code") THEN
                                "Base Measurement Unit Qty." := 1
                            ELSE
                                "Base Measurement Unit Qty." := ItemUnitofMeasure."Qty. per Unit of Measure";
                            IF CurrFieldNo <> 0 THEN BEGIN
                                IF "Unit of measurement Code" <> xRec."Unit of measurement Code" THEN BEGIN
                                    IF xRec."Base Measurement Unit Qty." = 0 THEN
                                        xRec."Base Measurement Unit Qty." := 1;
                                    "Estimated Price" := ROUND(("Estimated Price" / xRec."Base Measurement Unit Qty.") * "Base Measurement Unit Qty.",
                                                               Currency."Unit-Amount Rounding Precision");
                                    "Target Price" := ROUND(("Target Price" / xRec."Base Measurement Unit Qty.") * "Base Measurement Unit Qty.",
                                                               Currency."Unit-Amount Rounding Precision");
                                    VALIDATE("Estimated Price");
                                    VALIDATE("Target Price");
                                END;
                            END;
                        END;
                    Type::Resource:
                        BEGIN
                            IF NOT ResourceUnitofMeasure.GET("No.", "Unit of measurement Code") THEN
                                "Base Measurement Unit Qty." := 1
                            ELSE
                                "Base Measurement Unit Qty." := ResourceUnitofMeasure."Qty. per Unit of Measure";
                            IF CurrFieldNo <> 0 THEN BEGIN
                                IF "Unit of measurement Code" <> xRec."Unit of measurement Code" THEN BEGIN
                                    IF xRec."Base Measurement Unit Qty." = 0 THEN
                                        xRec."Base Measurement Unit Qty." := 1;

                                    "Estimated Price" := ROUND(("Estimated Price" / xRec."Base Measurement Unit Qty.") * "Base Measurement Unit Qty.",
                                                               Currency."Unit-Amount Rounding Precision");
                                    "Target Price" := ROUND(("Target Price" / xRec."Base Measurement Unit Qty.") * "Base Measurement Unit Qty.",
                                                               Currency."Unit-Amount Rounding Precision");
                                    VALIDATE("Estimated Price");
                                    VALIDATE("Target Price");
                                END;
                            END;
                        END;
                END;
            END;


        }
        field(23; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n U.O.';


        }
        field(24; "Initial Estimated Quantity"; Decimal)
        {
            CaptionML = ENU = 'Initial Estimated Quantity', ESP = 'Cantidad prevista inicial';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(25; "Initial Estimated Amount"; Decimal)
        {
            CaptionML = ENU = 'Initial Estimated Amount', ESP = 'Importe previsto inicial';
            Editable = false;
            AutoFormatType = 1;


        }
        field(26; "Base Measurement Unit Qty."; Decimal)
        {
            CaptionML = ENU = 'Base Measurement Unit Qty.', ESP = 'Cdad. unidad medida base';


        }
        field(27; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'N� Tarea';


        }
        field(28; "OLD_Increase Performance"; Boolean)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Increase Performance', ESP = 'Aumentar Rendimiento';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(29; "OLD_Comparative Date"; Date)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Comparative Date', ESP = 'Fecha comparativo';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(30; "OLD_Contract Date"; Date)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Contract Date', ESP = 'Fecha contrato';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(31; "OLD_Approval Date"; Date)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Approval Date', ESP = 'Fecha aprovaci�n';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(32; "OLD_Initial Quantity"; Decimal)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Initial Quantity', ESP = 'Cantidad inicial';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(33; "OLD_Vendor Name"; Text[50])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Ya no se usa';
            CaptionML = ENU = 'Vendor Name', ESP = 'Nombre proveedor';
            Description = '### ELIMINAR ### ya no se usa';


        }
        field(35; "Selected Vendor"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Comparative Quote Header"."Selected Vendor" WHERE("No." = FIELD("Quote No.")));

            TableRelation = "Vendor";
            CaptionML = ENU = 'Selected Vendor', ESP = 'Proveedor seleccionado';
            Editable = false;


        }
        field(36; "Purchase Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Prices Vendor"."Vendor Price" WHERE("Quote Code" = FIELD("Quote No."),
                                                                                                                 "Vendor No." = FIELD("Selected Vendor"),
                                                                                                                 "Version No." = FIELD("Selected Version No."),
                                                                                                                 "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Vendor Amount', ESP = 'Precio Compra';
            Description = 'QB 1.09.02 JAV 14/10/19: - Estaba mal el Name y Caption, pon�a Amount y era Price, se cambia vendor por puirchase que es mas identificativo JAV 28/06/21 Se a�ade el filtro de versi�n';
            Editable = false;


        }
        field(37; "Purchase Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Prices Vendor"."Purchase Amount" WHERE("Quote Code" = FIELD("Quote No."),
                                                                                                                    "Vendor No." = FIELD("Selected Vendor"),
                                                                                                                    "Version No." = FIELD("Selected Version No."),
                                                                                                                    "Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Vendor Amount', ESP = 'Importe Compra';
            Description = 'QB 1.09.02 JAV 14/10/19: - Se a�ade este campo con el importe del proveedor seleccionado  JAV 28/06/21 Se a�ade el filtro de versi�n';
            Editable = false;


        }
        field(38; "OLD_Vendor Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Prices Vendor"."Vendor Price" WHERE("Quote Code" = FIELD("Quote No."),
                                                                                                                 "Vendor No." = FIELD("Selected Vendor"),
                                                                                                                 "Version No." = FIELD("Selected Version No."),
                                                                                                                 "Line No." = FIELD("Line No.")));
            ObsoleteState = Removed;
            ObsoleteReason = 'Es lo mismo que el campo 36';
            CaptionML = ENU = 'Selected Vendor Amount', ESP = 'Precio que nos da el Proveedor Seleccionado';
            Description = '### ELIMINAR ### ya no se usa QB 1.09.02';
            Editable = false;


        }
        field(39; "Qty to segregate"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad a segregar';
            DecimalPlaces = 0 : 5;
            Description = 'JAV 04/05/20: - Cantidad a segregar en otro comparativo';

            trigger OnValidate();
            BEGIN
                IF ("Qty to segregate" < 0) OR ("Qty to segregate" > Quantity) THEN
                    ERROR('No puede segregar menos de 0 ni mas de la cantidad de la l�nea');
            END;


        }

        /*To be tested*/
        //-- converted to enum from type option.
        field(40; "Contract Document Type"; Enum "Purchase Document Type")
        {
            //OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Contrato. Tipo de documento';
            //OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';

            //OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';



        }
        field(41; "Contract Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Contrato. N� Documento';
            Description = 'QB 1.08.08: - JAV 07/02/21 Contrato: N� Documento generado';
            Editable = false;


        }
        field(42; "Contract Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract Line', ESP = 'Contrato. N� L�nea';
            Description = 'QB 1.08.08: - JAV 07/02/21 Contrato: l�nea que se ha generado';


        }
        field(43; "Qty. in Contract"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad inicial contrato';
            Description = 'QB 1.08.08: - JAV 07/02/21 Cantidad que ha pasado al contrato';
            Editable = false;


        }
        field(44; "Qty. in Purchase"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Quantity" WHERE("Document Type" = FIELD("Contract Document Type"),
                                                                                                      "Document No." = FIELD("Contract Document No."),
                                                                                                      "Line No." = FIELD("Contract Line No.")));
            CaptionML = ESP = 'Cantidad actual compra';
            Description = 'QB 1.08.08: - JAV 07/02/21 Cantidad actual en el contrato';
            Editable = false;


        }
        field(50; "Selected Version No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Comparative Quote Header"."Selected Version No." WHERE("No." = FIELD("Quote No."),
                                                                                                                               "Selected Vendor" = FIELD("Selected Vendor")));
            CaptionML = ENU = 'Selected Version', ESP = 'Versi�n seleccionada';
            Description = 'Q13150';


        }
        field(51; "Requirements date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Requirements date', ESP = 'Fecha de necesidad';
            Description = 'QB 1.10.08  JAV 15/12/21 - [TT] Indica si se generar�n tantas l�neas en el pedido en tantos meses como cantidad se indique aqu�';

            trigger OnValidate();
            BEGIN
                IF (Rec."Requirements date" <> 0D) THEN BEGIN
                    IF ComparativeQuoteHeader.GET(Rec."Quote No.") THEN BEGIN
                        IF (ComparativeQuoteHeader."Requirements date" = 0D) OR (ComparativeQuoteHeader."Requirements date" > Rec."Requirements date") THEN BEGIN
                            ComparativeQuoteHeader."Requirements date" := Rec."Requirements date";
                            ComparativeQuoteHeader.MODIFY;
                        END;
                    END;
                END;
            END;


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB3685';


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(1012; "Estimated Price (JC)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Estimated Price', ESP = 'Precio previsto (DP)';
            Editable = false;
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CalculateAmounts;
            END;


        }
        field(1013; "Estimated Amount (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Estimated Amount', ESP = 'Importe previsto (DP)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(50002; "Preselected Vendor"; Code[20])
        {
            TableRelation = "Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor', ESP = 'Proveedor Preseleccionado';
            Description = 'QCPM_GAP06';


        }
        field(7207348; "QB CA Code"; Code[20])
        {
            TableRelation = "Dimension";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto Anal�tico Dim.';
            Description = 'QB 1.10.42 JAV 21/05/22: - Campo de uso interno que Contiene el c�digo de la dimensi�n para Concepto anal�tico, se usa para filtrar el siguiente campo';

            trigger OnValidate();
            BEGIN
                "QB CA Code" := FunctionQB.ReturnDimCA;
            END;


        }
        field(7207349; "QB CA Value"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Dimension Code" = FIELD("QB CA Code"),
                                                                                               "Dimension Value Type" = CONST("Standard"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto Anal�tico';
            Description = 'QB 1.10.42 JAV 21/05/22: - Contiene el Concepto anal�tico que se va a asociar a la l�nea. Se utiliza en lugar de la dimensi�n para independizarnos de su n�mero';

            trigger OnValidate();
            BEGIN
                VALIDATE("QB CA Code");
                FunctionQB.SetDimensionIDWithGlobals("QB CA Code", "QB CA Value", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID");
            END;


        }
    }
    keys
    {
        key(key1; "Quote No.", "Line No.")
        {
            SumIndexFields = "Estimated Amount", "Target Amount", "Initial Estimated Amount";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@1100286006 :
        QuoBuildingSetup: Record 7207278;
        //       Currency@7001100 :
        Currency: Record 4;
        //       ComparativeQuoteHeader@7001101 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@1100286004 :
        ComparativeQuoteLines: Record 7207413;
        //       tmpComparativeQuoteLines@1100286003 :
        tmpComparativeQuoteLines: Record 7207413 TEMPORARY;
        //       Item@7001103 :
        Item: Record 27;
        //       Resource@7001104 :
        Resource: Record 156;
        //       Job@7001105 :
        Job: Record 167;
        //       DataPieceworkForProduction@7001106 :
        DataPieceworkForProduction: Record 7207386;
        //       ItemUnitofMeasure@7001107 :
        ItemUnitofMeasure: Record 5404;
        //       ResourceUnitofMeasure@7001108 :
        ResourceUnitofMeasure: Record 205;
        //       QBText@1100286000 :
        QBText: Record 7206918;
        //       ContractCreatedErr@1100286001 :
        ContractCreatedErr: TextConst ENU = 'The comparative %1 has a contract already. Lines cannot be inserted, modified or deleted.', ESP = 'El comparativo %1 ya tiene un contrato creado. No se pueden insertar, modificar o eliminar l�neas';
        //       DimensionValue@1100286007 :
        DimensionValue: Record 349;
        //       FunctionQB@1100286002 :
        FunctionQB: Codeunit 7207272;
        //       Value@1100286005 :
        Value: Code[20];
        //       InInit@1100286008 :
        InInit: Boolean;
        //       Cantidad@1100286009 :
        Cantidad: Decimal;



    trigger OnInsert();
    begin
        TestStatusOpen;
        //Q13150 -
        if ContractCreated then
            ERROR(ContractCreatedErr, "Quote No.");

        LOCKTABLE;
        ComparativeQuoteHeader."No." := '';
        InsertPricesByVendor;

        SetHeaderType(Rec, FALSE);
    end;

    trigger OnModify();
    begin
        //JAV 30/04/21 los campos ya no son editables, por tanto el �nico que se puede cambiar es la cantidad a segregar, por tanto no hay que controlar ya esto
        // TestStatusOpen;
        //
        // //Q13150 -
        // if ContractCreated then
        //  ERROR(ContractCreatedErr, "Quote No.");

        ModifyPricesByVendor;
        SetHeaderType(Rec, FALSE);
    end;

    trigger OnDelete();
    begin
        TestStatusOpen;
        //Q13150 -
        if ContractCreated then
            ERROR(ContractCreatedErr, "Quote No.");

        DeletePricesByVendor;
        if (QBText.GET(QBText.Table::Comparativo, "Quote No.", FORMAT("Line No."), '')) then
            QBText.DELETE;
        SetHeaderType(Rec, TRUE);
    end;



    LOCAL procedure InitRegisterFromTemp()
    begin
        "Job No." := tmpComparativeQuoteLines."Job No.";
        "Piecework No." := tmpComparativeQuoteLines."Piecework No.";
        "QB CA Value" := tmpComparativeQuoteLines."QB CA Value";
        "Shortcut Dimension 1 Code" := tmpComparativeQuoteLines."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := tmpComparativeQuoteLines."Shortcut Dimension 2 Code";
        Manual := tmpComparativeQuoteLines.Manual;
    end;

    procedure InsertPricesByVendor()
    var
        //       VendorConditionsData@7001100 :
        VendorConditionsData: Record 7207414;
        //       DataPricesVendor@7001101 :
        DataPricesVendor: Record 7207415;
    begin
        VendorConditionsData.RESET;
        VendorConditionsData.SETRANGE("Quote Code", "Quote No.");
        if VendorConditionsData.FINDSET then
            repeat
                DataPricesVendor.INIT;
                DataPricesVendor."Quote Code" := "Quote No.";
                DataPricesVendor."Vendor No." := VendorConditionsData."Vendor No.";
                DataPricesVendor."Contact No." := VendorConditionsData."Contact No.";
                DataPricesVendor."Line No." := "Line No.";
                DataPricesVendor.Type := Type;
                DataPricesVendor."No." := "No.";
                DataPricesVendor.Quantity := Quantity;
                DataPricesVendor."Job No." := "Job No.";
                DataPricesVendor."Location Code" := "Location Code";
                //JAV 08/03/19: - A�adir la U.O. en la linea
                DataPricesVendor."Piecework No." := "Piecework No.";
                //JAV --
                if DataPricesVendor.INSERT(TRUE) then;
            until VendorConditionsData.NEXT = 0;
    end;

    procedure ModifyPricesByVendor()
    var
        //       VendorConditionsData@7001101 :
        VendorConditionsData: Record 7207414;
        //       DataPricesVendor@7001100 :
        DataPricesVendor: Record 7207415;
    begin
        VendorConditionsData.RESET;
        VendorConditionsData.SETRANGE("Quote Code", "Quote No.");
        if VendorConditionsData.FINDSET then
            repeat
                if DataPricesVendor.GET("Quote No.", VendorConditionsData."Vendor No.", VendorConditionsData."Contact No.", "Line No.") then begin
                    DataPricesVendor.Type := Type;
                    DataPricesVendor."No." := "No.";
                    DataPricesVendor.Quantity := Quantity;
                    DataPricesVendor."Job No." := "Job No.";
                    DataPricesVendor."Location Code" := "Location Code";
                    CLEAR(Currency);
                    Currency.InitRoundingPrecision;
                    if xRec."Base Measurement Unit Qty." = 0 then
                        xRec."Base Measurement Unit Qty." := 1;
                    DataPricesVendor."Vendor Price" := ROUND((DataPricesVendor."Vendor Price" /
                                                      xRec."Base Measurement Unit Qty.") * "Base Measurement Unit Qty.",
                                                      Currency."Unit-Amount Rounding Precision");
                    DataPricesVendor.VALIDATE("Vendor Price");
                    //JAV 08/03/19: - A�adir la U.O. en la linea
                    DataPricesVendor."Piecework No." := "Piecework No.";
                    //JAV --
                    DataPricesVendor.MODIFY(TRUE);
                end;
            until VendorConditionsData.NEXT = 0;
    end;

    procedure DeletePricesByVendor()
    var
        //       DataPricesVendor@7001100 :
        DataPricesVendor: Record 7207415;
    begin
        DataPricesVendor.RESET;
        DataPricesVendor.SETRANGE("Quote Code", "Quote No.");
        DataPricesVendor.SETRANGE("Line No.", "Line No.");
        DataPricesVendor.DELETEALL(TRUE);
    end;

    LOCAL procedure TestStatusOpen()
    begin
        GetHeader;
        ComparativeQuoteHeader.TESTFIELD("Approval Status", ComparativeQuoteHeader."Approval Status"::Open);
    end;

    LOCAL procedure GetHeader()
    begin
        if "Quote No." <> '' then begin
            TESTFIELD("Quote No.");
            if "Quote No." <> ComparativeQuoteHeader."No." then
                ComparativeQuoteHeader.GET("Quote No.");
        end;
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1100251000 : Integer;No2@1100251001 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       SourceCodeSetup@1008 :
        SourceCodeSetup: Record 242;
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
        //       TableID@1009 :
        TableID: ARRAY[10] OF Integer;
        //       No@1010 :
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
        GetHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Comparative Quote", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            ComparativeQuoteHeader."Dimension Set ID", DATABASE::Vendor);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimJobs, Rec."Job No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID");

        Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, "Dimension Set ID");
        if (Value <> '') then
            "QB CA Value" := Value;

        VALIDATE("QB CA Code");
        VALIDATE("QB CA Value");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        //TESTFIELD("Job No.");
        //TESTFIELD("No.");
        "Dimension Set ID" := DimMgt.EditDimensionSet(Rec."Dimension Set ID", STRSUBSTNO('%1 %2 %3', Rec.TABLECAPTION, Rec."Quote No.", Rec."Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     procedure GetBillOfItemData (JobCodePass@1100251000 : Code[20];UOCodPass@1100251001 : Code[20];OpTypePass@1100251002 : 'Cuenta,Recurso,Familia,Producto';CodePass@1100251003 : Code[20];var ComparativeQuoteLinesPass@7001100 :
    procedure GetBillOfItemData(JobCodePass: Code[20]; UOCodPass: Code[20]; OpTypePass: Option "Cuenta","Recurso","Familia","Producto"; CodePass: Code[20]; var ComparativeQuoteLinesPass: Record 7207413)
    var
        //       Job@1100251004 :
        Job: Record 167;
        //       DataCostByPiecework@7001101 :
        DataCostByPiecework: Record 7207387;
        //       DataPieceworkForProduction@7001102 :
        DataPieceworkForProduction: Record 7207386;
    begin
        if not Job.GET(JobCodePass) then
            exit;

        if not DataPieceworkForProduction.GET(JobCodePass, UOCodPass) then
            exit;

        //JAV 08/04/19: - Filtar la cantidad a usar por el �ltimo presupuesto, si no toma la suma de todos los presupuesto
        DataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
        //JAV 08/04/19 fin

        DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Budget Measure", DataPieceworkForProduction."Total Measurement Production");

        DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.", JobCodePass);
        DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code", UOCodPass);
        DataCostByPiecework.SETRANGE(DataCostByPiecework."Cod. Budget", Job."Current Piecework Budget");
        if OpTypePass = OpTypePass::Producto then
            DataCostByPiecework.SETRANGE(DataCostByPiecework."Cost Type", DataCostByPiecework."Cost Type"::Item);
        if OpTypePass = OpTypePass::Recurso then
            DataCostByPiecework.SETRANGE(DataCostByPiecework."Cost Type", DataCostByPiecework."Cost Type"::Resource);

        DataCostByPiecework.SETRANGE(DataCostByPiecework."No.", CodePass);
        //-Q18285,Q18970 Solo sumaremos las cantidades (Si vienen de un Preciario) Presuponemos precio y UM iguales.
        Cantidad := 0;
        if DataCostByPiecework.FINDFIRST then begin
            //-Q18285,Q18970 Ponemos el repeat
            repeat
                //+Q18285,Q18970
                Cantidad += (DataPieceworkForProduction."Budget Measure" - DataPieceworkForProduction."Total Measurement Production") *
                                                   DataCostByPiecework."Performance By Piecework";
                ComparativeQuoteLinesPass.VALIDATE(Quantity, (DataPieceworkForProduction."Budget Measure" - DataPieceworkForProduction."Total Measurement Production") *
                                                   DataCostByPiecework."Performance By Piecework");
                ComparativeQuoteLinesPass.VALIDATE("Estimated Price", DataCostByPiecework."Direc Unit Cost");
                ComparativeQuoteLinesPass.VALIDATE("Estimated Price (JC)", DataCostByPiecework."Direct Unitary Cost (JC)");

                //JAV 24/07/19: - Al poner c�digo y U.O. rellena cantidad inicial, precio inicial, CA y C�digo Actividad
                ComparativeQuoteLinesPass.VALIDATE("Initial Estimated Quantity", ComparativeQuoteLinesPass.Quantity);
                ComparativeQuoteLinesPass.VALIDATE("Initial Estimated Amount", ComparativeQuoteLinesPass."Estimated Amount");
                ComparativeQuoteLinesPass.VALIDATE("Shortcut Dimension 2 Code", DataCostByPiecework."Analytical Concept Direct Cost");
                ComparativeQuoteLinesPass.VALIDATE("Activity Code", DataPieceworkForProduction."Activity Code");
                //JAV 10/08/19: - Poner vendedor preseleccionado en la l�nea al introducir la U.O.
                ComparativeQuoteLinesPass."Preselected Vendor" := DataCostByPiecework.Vendor;
                // JAV 04/05/20: - A�adir la actividad
                if (DataCostByPiecework."Activity Code" <> '') then
                    ComparativeQuoteLinesPass."Activity Code" := DataCostByPiecework."Activity Code";
                ComparativeQuoteLinesPass.MODIFY;
            until DataCostByPiecework.NEXT = 0;
        end;
        //-Q18285,Q18970 Ahora aplicamos la cantidad sumada.
        ComparativeQuoteLinesPass.VALIDATE(Quantity, Cantidad);
        ComparativeQuoteLinesPass.VALIDATE("Initial Estimated Quantity", ComparativeQuoteLinesPass.Quantity);
        ComparativeQuoteLinesPass.VALIDATE("Initial Estimated Amount", ComparativeQuoteLinesPass."Estimated Amount");
        ComparativeQuoteLinesPass.MODIFY;
        //+Q18285,Q18970

    end;

    procedure CalculateAmounts()
    begin
        "Estimated Amount" := Quantity * "Estimated Price";
        "Target Amount" := Quantity * "Target Price";
        "Estimated Amount (JC)" := Quantity * "Estimated Price (JC)";
    end;

    //     procedure CalcTotalPurchAmounts (ComparativeQuoteHeader@7001101 :
    procedure CalcTotalPurchAmounts(ComparativeQuoteHeader: Record 7207412): Decimal;
    var
        //       ComparativeQuoteLines@7001102 :
        ComparativeQuoteLines: Record 7207413;
        //       DataPricesVendor@7001100 :
        DataPricesVendor: Record 7207415;
        //       TotalPurchAmounts@7001103 :
        TotalPurchAmounts: Decimal;
    begin
        /*To be Tested*/
        // WITH ComparativeQuoteLines DO begin
        ComparativeQuoteLines.SETRANGE("Quote No.", ComparativeQuoteHeader."No.");
        if FINDSET then
            repeat
                if ComparativeQuoteHeader."Contact Selectd No." <> '' then
                    DataPricesVendor.GET(ComparativeQuoteHeader."No.", '', ComparativeQuoteHeader."Contact Selectd No.", "Line No.")
                else
                    DataPricesVendor.GET(ComparativeQuoteHeader."No.", ComparativeQuoteHeader."Selected Vendor", ComparativeQuoteHeader."Contact Selectd No.", "Line No.");
                TotalPurchAmounts += Quantity * DataPricesVendor."Vendor Price";
            until NEXT = 0;
        //end;
        exit(TotalPurchAmounts);
    end;

    //     procedure CalcTotalAmounts (ComparativeQuoteHeader@7001101 :
    procedure CalcTotalAmounts(ComparativeQuoteHeader: Record 7207412): Decimal;
    var
        //       ComparativeQuoteLines@7001102 :
        ComparativeQuoteLines: Record 7207413;
        //       DataPricesVendor@7001100 :
        DataPricesVendor: Record 7207415;
        //       TotalPurchAmounts@7001103 :
        TotalPurchAmounts: Decimal;
    begin
        /*To be Tested*/
        //WITH ComparativeQuoteLines DO begin
        ComparativeQuoteLines.SETRANGE("Quote No.", ComparativeQuoteHeader."No.");
        if FINDSET then
            repeat
                TotalPurchAmounts += "Estimated Amount";
            until NEXT = 0;
        //end;
        exit(TotalPurchAmounts);
    end;

    LOCAL procedure getTexts()
    begin
        QBText.CopyTo(QBText.Table::Job, "Job No.", "Piecework No.", "No.",
                      QBText.Table::Comparativo, "Quote No.", FORMAT("Line No."), '');
    end;

    procedure ContractCreated(): Boolean;
    var
        //       ComparativeQteHdr@1100286001 :
        ComparativeQteHdr: Record 7207412;
    begin
        //Q13150 -
        //JAV 27/04/21: - No retornaba valor siempre, se cambia para que lo haga
        ComparativeQteHdr.GET("Quote No.");
        exit(ComparativeQteHdr."Generated Contract Doc No." <> '');
        //Q13150 +
    end;

    //     procedure SetHeaderType (ActualLine@1100286000 : Record 7207413;isDelete@1100286001 :
    procedure SetHeaderType(ActualLine: Record 7207413; isDelete: Boolean)
    var
        //       ComparativeQuoteLines@1100286002 :
        ComparativeQuoteLines: Record 7207413;
        //       lR@1100286003 :
        lR: Boolean;
        //       lP@1100286004 :
        lP: Boolean;
        //       NewType@1100286005 :
        NewType: Option;
    begin
        GetHeader;
        if (not isDelete) then begin
            lP := (ActualLine.Type = ActualLine.Type::Item);
            lR := (ActualLine.Type = ActualLine.Type::Resource);
        end else begin
            lR := FALSE;
            lP := FALSE;
        end;

        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", ActualLine."Quote No.");
        ComparativeQuoteLines.SETFILTER("Line No.", '<>%1', ActualLine."Line No.");
        if (ComparativeQuoteLines.FINDSET(FALSE)) then
            repeat
                CASE ComparativeQuoteLines.Type OF
                    ComparativeQuoteLines.Type::Item:
                        lP := TRUE;
                    ComparativeQuoteLines.Type::Resource:
                        lR := TRUE;
                end;
            until (ComparativeQuoteLines.NEXT = 0);

        CASE TRUE OF
            lP and (not lR):
                NewType := ComparativeQuoteHeader."Comparative Type"::Item;
            (not lP) and lR:
                NewType := ComparativeQuoteHeader."Comparative Type"::Resource;
            else
                NewType := ComparativeQuoteHeader."Comparative Type"::Mixed;
        end;

        if (NewType <> ComparativeQuoteHeader."Comparative Type") then begin
            ComparativeQuoteHeader."Comparative Type" := NewType;
            ComparativeQuoteHeader.MODIFY;
        end;
    end;

    LOCAL procedure GetValuesFromDimension()
    begin
        Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimJobs, "Dimension Set ID");
        if (Value <> '') then
            "Job No." := Value;
        Value := FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimCA, "Dimension Set ID");
        if (Value <> '') then
            "QB CA Value" := Value;
    end;

    /*begin
    //{
//      JAV 08/03/19: - A�adir la U.O. en la linea
//      JAV 25/03/19: - Se cambia el flowfield del campo "Lowert Amount" porque no era correcto
//      JAV 26/03/19: - Se hacen no editables los campos "Estimated Amount", "Target Amount", "Vendor Amount"
//      JAV 08/04/16: - Filtar la cantidad a usar por el �ltimo presupuesto, si no toma la suma de todos los presupuesto
//      JAV 10/08/19: - Poner vendedor preseleccionado en la l�nea al introducir la U.O.
//      JAV 14/10/19: - Se hace no editable el importe objetivo
//                    - El campo 36 estaba mal el Name y Caption ya que contiene el Precio del proveedor seleccionado, y se a�ade el campo 37 con el importe.
//      JDC 05/04/21: - Q13150 Added field 50 "Selected Version No.". Added function "ContractNotCreated"
//      LCG 02/02/22: - QRE16204 Cambiar caption a campo 18 (N� Unidad Obra a Partida presupuestaria)
//      EPV 13/04/22: - Error no existe partida presupuestaria (se pierde el valor de Job No.)
//      JAV 30/05/22: - QB 1.10.45 Mejoras en los validates y manejo de las dimensiones
//      JAV 16/06/22: - QB 1.10.50 Si cambia el proyecto y la unidad de obra no existe en el nuevo o si el proyecto est� vac�o, se elimina la U.O. de la l�nea, si no se valida
//                                 Filtrar por los proyectos a los que tiene acceso el usuario
//      AML 02/06/23  - ;
//    }
    end.
  */
}







