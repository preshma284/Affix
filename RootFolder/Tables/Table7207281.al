table 7207281 "Purchase Journal Line"
{


    CaptionML = ENU = 'Purchase Journal Line', ESP = 'Lin. diario necesidades compra';
    LookupPageID = "Purchasing Needs Lines";
    DrillDownPageID = "Purchasing Needs Lines";

    fields
    {
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(3; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Job Type" = FILTER(<> "Deviations"),
                                                                            "Blocked" = CONST(" "));


            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';

            trigger OnValidate();
            BEGIN
                IF "Job No." = '' THEN
                    EXIT;
                Job.GET("Job No.");
                "Location Code" := Job."Job Location";
            END;


        }
        field(4; "Date Update"; Date)
        {
            CaptionML = ENU = 'Date Update', ESP = 'Fecha actualizaci�n';


        }
        field(5; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item" ELSE IF ("Type" = CONST("Resource")) "Resource";


            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            BEGIN
                TESTFIELD("No.");

                VALIDATE("Stock Location (Base)"); //JAV 31/05/21: - QB 1.05.46 Esto recalcula el campo, quito el c�digo que lo hac�ia luego que ya no tiene sentido

                IF Type = Type::Item THEN BEGIN
                    Item.GET("No.");
                    Decription := Item.Description;
                    "Activity Code" := Item."QB Activity Code";
                    VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                    "Vendor No." := Item."Vendor No.";
                    "Vendor Item No." := Item."Vendor Item No.";
                    VALIDATE("Vendor No.", Item."Vendor No.");
                    CreateDim(DATABASE::Job, "Job No.", DATABASE::Item, "No.");
                END;

                IF Type = Type::Resource THEN BEGIN
                    Resource.GET("No.");
                    Decription := Resource.Name;
                    "Activity Code" := Resource."Activity Code";
                    CreateDim(DATABASE::Job, "Job No.", DATABASE::Resource, "No.");
                    VALIDATE("Unit of Measure Code", Resource."Base Unit of Measure");
                END;
            END;


        }
        field(6; "Decription"; Text[50])
        {
            CaptionML = ENU = 'Decription', ESP = 'Descripción';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
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
            END;


        }
        field(10; "Journal Batch Name"; Code[20])
        {
            TableRelation = "Purchase Journal Batch";
            CaptionML = ENU = 'Journal Batch Name', ESP = 'Nombre secci�n diario';


        }
        field(16; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";


            CaptionML = ENU = 'Activity Code', ESP = 'C�d. actividad';

            trigger OnValidate();
            BEGIN
                IF ("Activity Code" <> '') THEN BEGIN
                    DataCostByPiecework.RESET;
                    DataCostByPiecework.SETRANGE("Job No.", "Job No.");
                    DataCostByPiecework.SETRANGE("Piecework Code", "Job Unit");
                    DataCostByPiecework.SETRANGE("No.", "No.");
                    DataCostByPiecework.SETRANGE("Activity Code", xRec."Activity Code");
                    DataCostByPiecework.MODIFYALL("Activity Code", "Activity Code");
                    Generate := TRUE;
                END ELSE
                    Generate := FALSE;
            END;


        }
        field(17; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            BEGIN
                //GEN003-05
                //Quantity := Quantity - "Stock Location (Base)";  //JAV 31/05/21: - QB 1.05.46 No podemos restar una cantidad que ha puesto manualmente los usuarios
                IF (Quantity < 0) THEN
                    Quantity := 0;

                UpdateCost;
            END;


        }
        field(18; "Stock Location (Base)"; Decimal)
        {


            CaptionML = ENU = 'Stock Location (Base)', ESP = 'Existencias Almac�n (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 31/05/21: - QB 1.05.46 En el validate calculamos el importe del stock asociado al producto
                "Stock Location (Base)" := 0;

                IF (Type = Type::Item) AND (Item.GET("No.")) THEN BEGIN
                    Item.SETRANGE("Location Filter", "Location Code");
                    Item.CALCFIELDS(Inventory);
                    "Stock Location (Base)" := Item.Inventory;
                END;
            END;


        }
        field(19; "Stock Contracts Items (Base)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Quantity (Base)" WHERE("Document Type" = FILTER('Order' | 'Blanket Order'),
                                                                                                            "Type" = CONST("Item"),
                                                                                                            "No." = FIELD("No."),
                                                                                                            "Job No." = FIELD("Job No."),
                                                                                                            "Blanket Order No." = CONST()));
            CaptionML = ENU = 'Stock Contracts Items (Base)', ESP = 'Exist. contratos productos (Base)';
            Editable = false;


        }
        field(20; "Stock Contracts Resource (B)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Quantity (Base)" WHERE("Document Type" = FILTER('Order' | 'Blanket Order'),
                                                                                                            "Job No." = FIELD("Job No."),
                                                                                                            "Type" = CONST("Resource"),
                                                                                                            "No." = FIELD("No."),
                                                                                                            "Blanket Order No." = CONST(),
                                                                                                            "Piecework No." = FIELD("Job Unit")));
            CaptionML = ENU = 'Stock Contracts Resource (B)', ESP = 'Exist. contratos recursos (Base)';
            Editable = false;


        }
        field(21; "Estimated Price"; Decimal)
        {


            CaptionML = ENU = 'Estimated Price', ESP = 'Precio previsto';
            Description = 'GEN003-05: Cambiado name y Caption (quitado DL)';
            Editable = false;
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(22; "Estimated Amount"; Decimal)
        {
            CaptionML = ENU = 'Estimated Amount', ESP = 'Importe previsto';
            Description = 'GEN003-05: Cambiado name y Caption (quitado DL)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(23; "Target Amount"; Decimal)
        {
            CaptionML = ENU = 'Target Amount', ESP = 'Importe objetivo';
            AutoFormatType = 1;


        }
        field(24; "Date Needed"; Date)
        {


            CaptionML = ENU = 'Date Needed', ESP = 'Fecha necesidad';

            trigger OnValidate();
            VAR
                //                                                                 RItem@1100286000 :
                RItem: Record 27;
            BEGIN
                //GEN006-01
                UpdatePurchDeadlineDate;
            END;


        }
        field(25; "Type"; Enum "Purchase Line Type")
        {
            // OptionMembers = "Item","Resource";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            //OptionCaptionML = ENU = 'Item,Resource', ESP = 'Producto,Recurso';



        }
        field(26; "Location Code"; Code[20])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Location Code', ESP = 'C�d. Almac�n';


        }
        field(27; "Target Price"; Decimal)
        {


            CaptionML = ENU = 'Target Price', ESP = 'Precio objetivo';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(28; "Job Unit"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = CONST(true));


            CaptionML = ENU = 'Job Unit', ESP = 'Unidad de obra';

            trigger OnValidate();
            BEGIN
                IF DataPieceworkForProduction.GET("Job No.", "Job Unit") THEN BEGIN
                    "Description 2" := DataPieceworkForProduction.Description;
                    IF "Unit of Measure Code" = '' THEN
                        "Unit of Measure Code" := DataPieceworkForProduction."Unit Of Measure";
                END;
            END;


        }
        field(29; "Unit of Measure Code"; Code[10])
        {
            TableRelation = IF ("Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No.")) ELSE IF ("Type" = CONST("Resource")) "Resource Unit of Measure"."Code" WHERE("Resource No." = FIELD("No."));


            CaptionML = ENU = 'Unit of Measure Code', ESP = 'C�d. unidad de medida';

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                CASE Type OF
                    Type::Item:
                        BEGIN
                            IF NOT ItemUnitofMeasure.GET("No.", "Unit of Measure Code") THEN
                                "Qty. Unit Measure base" := 1
                            ELSE
                                "Qty. Unit Measure base" := ItemUnitofMeasure."Qty. per Unit of Measure";
                            IF CurrFieldNo <> 0 THEN BEGIN
                                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                                    "Estimated Price" := ROUND(("Estimated Price" / xRec."Qty. Unit Measure base") * "Qty. Unit Measure base",
                                                               Currency."Unit-Amount Rounding Precision");
                                    "Target Price" := ROUND(("Target Price" / xRec."Qty. Unit Measure base") * "Qty. Unit Measure base",
                                                               Currency."Unit-Amount Rounding Precision");
                                    VALIDATE("Estimated Price");
                                    VALIDATE("Target Price");
                                END;
                            END;
                        END;
                    Type::Resource:
                        BEGIN
                            IF NOT ResourceUnitofMeasure.GET("No.", "Unit of Measure Code") THEN
                                "Qty. Unit Measure base" := 1
                            ELSE
                                "Qty. Unit Measure base" := ResourceUnitofMeasure."Qty. per Unit of Measure";
                            IF CurrFieldNo <> 0 THEN BEGIN
                                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                                    "Estimated Price" := ROUND(("Estimated Price" / xRec."Qty. Unit Measure base") * "Qty. Unit Measure base",
                                                               Currency."Unit-Amount Rounding Precision");
                                    "Target Price" := ROUND(("Target Price" / xRec."Qty. Unit Measure base") * "Qty. Unit Measure base",
                                                               Currency."Unit-Amount Rounding Precision");
                                    VALIDATE("Estimated Price");
                                    VALIDATE("Target Price");
                                END;
                            END;
                        END;
                END;
            END;


        }
        field(30; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(31; "Original Quantity"; Decimal)
        {
            CaptionML = ENU = 'Original Quantity', ESP = 'Cantidad original';
            DecimalPlaces = 0 : 5;


        }
        field(32; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'Vendor No.', ESP = 'N� proveedor';

            trigger OnValidate();
            VAR
                //                                                                 locTempDimSetEntry@1000 :
                locTempDimSetEntry: Record 480 TEMPORARY;
            BEGIN
                IF "Vendor No." <> '' THEN
                    IF Vendor.GET("Vendor No.") THEN BEGIN
                        IF Vendor.Blocked = Vendor.Blocked::All THEN
                            Vendor.VendBlockedErrorMessage(Vendor, FALSE);
                        IF Type = Type::Item THEN
                            UpdateDescription;
                        VALIDATE(Quantity);
                    END ELSE
                        IF CurrFieldNo <> 0 THEN
                            ERROR(txtQB001, FIELDCAPTION("Vendor No."), "Vendor No.")
                        ELSE
                            "Vendor No." := '';

                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    IF ItemVendor.GET("Vendor No.", "No.") THEN
                        "Vendor Item No." := ItemVendor."Vendor Item No.";
                    DimMgt.GetDimensionSet(locTempDimSetEntry, "Dimension Set ID");
                    locTempDimSetEntry.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                    IF locTempDimSetEntry.FINDFIRST THEN
                        CA := locTempDimSetEntry."Dimension Value Code";
                    CreateDim(DATABASE::Job, "Job No.", DATABASE::Item, "No.");
                    FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, CA, "Dimension Set ID");
                    DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                END;

                CALCFIELDS("Vendor Name");
            END;

            trigger OnLookup();
            BEGIN
                IF LookupVendor(Vendor) THEN
                    VALIDATE("Vendor No.", Vendor."No.");
            END;


        }
        field(33; "Vendor Item No."; Text[20])
        {
            CaptionML = ENU = 'Vendor Item No.', ESP = 'C�d. producto proveedor';


        }
        field(36; "Qty. Unit Measure base"; Decimal)
        {
            CaptionML = ENU = 'Qty. Unit Measure base', ESP = 'Cdad. Unidad Medida base';
            Editable = false;


        }
        field(37; "Job Task"; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task', ESP = 'N� Tarea';


        }
        field(38; "Quantity in Comparatives"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad en Comprativos';
            Description = 'JAV 30/10/19: - Cantidad que ya est� en los comprativos de ofertas';
            Editable = false;


        }
        field(39; "Quantity in Contracts"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad en contratos';
            Description = 'JAV 30/10/19: - Cantidad que ya est� en contratos generados';
            Editable = false;


        }
        field(40; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor No.")));
            CaptionML = ESP = 'Nombre Proveedor';
            Editable = false;


        }
        field(41; "Generate"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Generar';
            Description = 'JAV 04/05/20: - Si se desea generar los comprativos de esta l�nea';

            trigger OnValidate();
            BEGIN
                IF (Generate) AND ("Activity Code" = '') THEN
                    ERROR(txtQB000);
            END;


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = '3685';


        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';


        }
        field(1000; "Direct Unit Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Coste Unitario';
            Description = 'NO VOLVER A BORRAR DE LA TABLA SIN CAMBIAR LA FUNCIONALIDAD ASOCIADA. PEDRO 20.04.19';

            trigger OnValidate();
            BEGIN
                //GEN003-05
                "Estimated Price" := "Direct Unit Cost";
                "Target Price" := "Direct Unit Cost";
                UpdateCost;
            END;


        }
        field(1003; "Direct Unit Cost (JC)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unit Cost (JC)', ESP = 'Coste Unitario (DP)';
            Description = 'GEN003-05: Cambiado name y Caption';

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(1004; "Amount (JC)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (JC)', ESP = 'Importe (DP)';
            Description = 'GEN003-05: Cambiado name y Caption';

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(1005; "Target Price (JC)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Target Price (JC)', ESP = 'Precio Objetivo (DP)';
            Description = 'JMMA Objetivo en divisa del proyecto';

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(1006; "Target Amount (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Target Amount (JC)', ESP = 'Importe Objetivo (DP)';
            Description = 'Importe objetivo divsa proyecto';


        }
        field(1023; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(1024; "Currency Date"; Date)
        {


            AccessByPermission = TableData 4 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Value Date', ESP = 'Fecha valor divisa';
            Description = 'GEN003-05: Cambidado Caption';

            trigger OnValidate();
            BEGIN
                //GEN003-05
                UpdateCost;
            END;


        }
        field(1025; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(1100; "Purchase Deadline Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Purchase Deadline Date', ESP = 'Fecha l�mite compra';
            Description = 'GEN006';


        }
        field(1101; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (TC)', ESP = 'Importe (DT)';
            Description = 'Importe en divsa de la transacci�n DT';


        }
    }
    keys
    {
        key(key1; "Job No.", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
        key(key2; "Job No.", "Journal Batch Name", "Activity Code", "Type", "No.")
        {
            ;
        }
        key(key3; "Job No.", "Journal Batch Name", "Type", "No.", "Date Needed")
        {
            ;
        }
        key(key4; "Job No.", "Journal Batch Name", "Vendor No.")
        {
            ;
        }
        key(key5; "Job No.", "Journal Batch Name", "Target Amount")
        {
            SumIndexFields = "Estimated Amount", "Target Amount";
        }
    }
    fieldgroups
    {
    }

    var
        //       PurchaseJournalLine@7001115 :
        PurchaseJournalLine: Record 7207281;
        //       Job@7001103 :
        Job: Record 167;
        //       Item@7001104 :
        Item: Record 27;
        //       Resource@7001105 :
        Resource: Record 156;
        //       DataPieceworkForProduction@7001106 :
        DataPieceworkForProduction: Record 7207386;
        //       Currency@7001107 :
        Currency: Record 4;
        //       ItemUnitofMeasure@7001108 :
        ItemUnitofMeasure: Record 5404;
        //       ResourceUnitofMeasure@7001109 :
        ResourceUnitofMeasure: Record 205;
        //       Vendor@7001110 :
        Vendor: Record 23;
        //       ItemVendor@7001112 :
        ItemVendor: Record 99;
        //       DimMgt@7001102 :
        DimMgt: Codeunit "DimensionManagement";
        //       txtQB000@1100286005 :
        txtQB000: TextConst ESP = 'No puede generar l�neas sin actividad.';
        //       txtQB001@7001111 :
        txtQB001: TextConst ENU = '%1 %2 does not exist.', ESP = 'No existe %1 %2.';
        //       FunctionQB@7001113 :
        FunctionQB: Codeunit 7207272;
        //       CA@7001114 :
        CA: Code[20];
        //       CurrencyDate@1100286001 :
        CurrencyDate: Date;
        //       CurrExchRate@1100286000 :
        CurrExchRate: Record 330;
        //       GeneralLedgerSetup@1100286002 :
        GeneralLedgerSetup: Record 98;
        //       DataCostByPiecework@1100286003 :
        DataCostByPiecework: Record 7207387;
        //       QBText@1100286004 :
        QBText: Record 7206918;



    trigger OnInsert();
    begin
        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");

        //GEN006-01
        UpdatePurchDeadlineDate;
    end;

    trigger OnDelete();
    begin
        if QBText.GET(QBText.Table::Diario, "Job No.", FORMAT("Line No."), '') then
            QBText.DELETE;
    end;



    // procedure SetUpNewLine (Last_PurchaseJournalLine@7001100 :
    procedure SetUpNewLine(Last_PurchaseJournalLine: Record 7207281)
    begin
        PurchaseJournalLine.SETRANGE("Job No.", "Job No.");
        if PurchaseJournalLine.FINDFIRST then begin
            "Date Update" := Last_PurchaseJournalLine."Date Update";
        end else begin
            "Date Update" := WORKDATE;
        end;
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       TableID@1010 :
        TableID: ARRAY[10] OF Integer;
        //       No@1011 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        "Dimension Set ID" := DimMgt.GetDefaultDimID(DefaultDimSource, '', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    procedure CalculateAmounts()
    begin
        //"Estimated Amount" := Quantity * "Estimated Price";

        Amount := Quantity * "Direct Unit Cost";
        "Target Amount" := Quantity * "Target Price";

        //GEN003-05
        "Amount (JC)" := Quantity * "Direct Unit Cost (JC)";
        "Target Amount (JC)" := Quantity * "Target Price (JC)";
    end;

    LOCAL procedure UpdateDescription()
    var
        //       ItemTranslation@1100251000 :
        ItemTranslation: Record 30;
    begin
        if (Type <> Type::Item) or ("No." = '') then
            exit;
        Item.GET("No.");
        Decription := Item.Description;
        "Description 2" := Item."Description 2";
        if "Vendor No." <> '' then begin
            Vendor.GET("Vendor No.");
            if Vendor."Language Code" <> '' then
                if ItemTranslation.GET("No.", '', Vendor."Language Code") then begin
                    Decription := ItemTranslation.Description;
                    "Description 2" := ItemTranslation."Description 2";
                end;
        end;
    end;

    //     procedure LookupVendor (var Vendor@1000 :
    procedure LookupVendor(var Vendor: Record 23): Boolean;
    begin
        if (Type = Type::Item) and ItemVendor.READPERMISSION then begin
            ItemVendor.INIT;
            ItemVendor.SETRANGE("Item No.", "No.");
            ItemVendor.SETRANGE("Vendor No.", "Vendor No.");
            if not ItemVendor.FINDLAST then begin
                ItemVendor."Item No." := "No.";
                ItemVendor."Vendor No." := "Vendor No.";
            end;
            ItemVendor.SETRANGE("Vendor No.");
            if PAGE.RUNMODAL(0, ItemVendor) = ACTION::LookupOK then begin
                Vendor.GET(ItemVendor."Vendor No.");
                exit(TRUE);
            end;
            exit(FALSE);
        end else begin
            Vendor."No." := "Vendor No.";
            exit(PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK);
        end;
    end;

    procedure UpdateCost()
    var
        //       JobCurrencyExchangeFunction@1100286000 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       AssignedAmount@1100286001 :
        AssignedAmount: Decimal;
        //       CurrencyFactor@1100286002 :
        CurrencyFactor: Decimal;
    begin
        //GEN003-05: Esta funci�n reemplaza las anteriores

        Job.GET(Rec."Job No.");
        if (Job."Currency Code" <> '') then begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", "Direct Unit Cost", "Currency Code", Job."Currency Code", "Currency Date", 0, AssignedAmount, CurrencyFactor);
            "Direct Unit Cost (JC)" := AssignedAmount;
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", "Target Price", "Currency Code", Job."Currency Code", "Currency Date", 0, AssignedAmount, CurrencyFactor);
            "Target Price (JC)" := AssignedAmount;
            "Currency Factor" := CurrencyFactor;
        end;

        CalculateAmounts;
    end;

    LOCAL procedure UpdatePurchDeadlineDate()
    var
        //       RItem@1100286000 :
        RItem: Record 27;
        //       DTFormula@1100286001 :
        DTFormula: DateFormula;
    begin
        //GEN006-01 Calculo de la fecha limite de compra en base al plazo de entrega del producto.
        if (Type = Type::Item) and RItem.GET("No.") and ("Date Needed" <> 0D) then begin
            if FORMAT(RItem."Lead Time Calculation") <> '' then begin
                EVALUATE(DTFormula, '-' + FORMAT(RItem."Lead Time Calculation"));
                "Purchase Deadline Date" := CALCDATE(DTFormula, "Date Needed");
            end;
        end;
    end;

    /*begin
    //{
//      PEL 08/04/19: - GEN003-05 Campos nuevos, y cambios en funciones
//      PER 20/04/19: - GEN006    Nuevo campo fecha limite de compras. Para calculo de previsi�n de compra.
//      PER 22/04/19: - GEN006-01 C�lculo de la fecha limite de compra en base al plazo de entrega del producto.
//      JAV 31/05/21: - QB 1.05.46 Cambio en el validate de Quantity, no podemos restarle la cantidad en stock si han indicado la cantidad manualmente
//    }
    end.
  */
}







