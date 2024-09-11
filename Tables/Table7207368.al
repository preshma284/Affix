table 7207368 "QBU Activation Line"
{


    CaptionML = ENU = 'Activation Line', ESP = 'L�neas activaci�n';
    PasteIsValid = false;
    LookupPageID = "Activation Line Subform";
    DrillDownPageID = "Activation Line Subform";

    fields
    {
        field(1; "Element Code"; Code[20])
        {
            TableRelation = "Rental Elements";
            CaptionML = ENU = 'Element Code', ESP = 'Cod. Elemento';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ESP = 'N� documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ESP = 'N� l�nea';


        }
        field(4; "No."; Code[20])
        {
            TableRelation = "Rental Elements";


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                ActivationLine := Rec;
                INIT;

                "No." := ActivationLine."No.";
                IF "No." = '' THEN
                    EXIT;

                GetRecelementHeader;
                ActivationHeader.TESTFIELD(ActivationHeader."Element Code");

                "No." := ActivationHeader."Element Code";
                "Currency Code" := ActivationHeader."Currency Code";
                "Shortcut Dimension 1 Code" := ActivationHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := ActivationHeader."Shortcut Dimension 2 Code";
                RentalElements.GET("No.");
                Description := RentalElements.Description;
                "Description 2" := RentalElements."Description 2";

                CreateDim(DATABASE::"Rental Elements", "No.");
            END;


        }
        field(5; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(6; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(7; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatExpression = "Currency Code";


        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(10; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';
            Editable = false;


        }
        field(11; "Activation Type"; Option)
        {
            OptionMembers = "Account","Active";
            CaptionML = ENU = 'Activation Type', ESP = 'Tipo activaci�n';
            OptionCaptionML = ENU = 'Account,Active', ESP = 'Cuenta,Activo';



        }
        field(12; "Gen. Prod. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            CaptionML = ENU = 'Gen. Prod. Posting Group', ESP = 'Grupo contable producto';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(13; "Account Type"; Option)
        {
            OptionMembers = "G/L Account","Fixed Asset";

            CaptionML = ENU = 'Account Type', ESP = 'Tipo mov.';
            OptionCaptionML = ENU = 'G/L Account,Fixed Asset', ESP = 'Cuenta G/L,Activo Fijo';


            trigger OnValidate();
            BEGIN
                VALIDATE("Account No.", '');
            END;


        }
        field(14; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";
            CaptionML = ENU = 'Account No.', ESP = 'No. cuenta';


        }
        field(15; "Bal. Account No."; Code[20])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE IF ("Bal. Account Type" = CONST("Customer")) "Customer" ELSE IF ("Bal. Account Type" = CONST("Vendor")) "Vendor" ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account" ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";
            CaptionML = ENU = 'Bal. Account No.', ESP = 'Cta. contrapartida';


        }
        field(16; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";

            CaptionML = ENU = 'Bal. Account Type', ESP = 'Tipo contrapartida';
            OptionCaptionML = ENU = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner', ESP = 'Cuenta G/L,Cliente,Proveedor,Banco,Activo Fijo,Empresa vinculada asociada';


            trigger OnValidate();
            BEGIN
                VALIDATE("Bal. Account No.", '');
            END;


        }
        field(17; "Depreciate until"; Boolean)
        {
            CaptionML = ENU = 'Depreciate until', ESP = 'Amortizar hasta';


        }
        field(18; "Location Code"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Location Code', ESP = 'Cod. almac�n';


        }
        field(19; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';


        }
        field(20; "New Location Code"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'New Location Code', ESP = 'Cod. almac�n destino';


        }
        field(21; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant"."Code" WHERE("Item No." = FIELD("Item No."));
            CaptionML = ENU = 'Variant Code', ESP = 'Cod. variante';


        }
        field(22; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("Item No."));
            CaptionML = ENU = 'Unit of Measure Code', ESP = 'Cod. unidad medida';


        }
        field(23; "Item No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Rental Elements"."Related Product");
            CaptionML = ENU = 'Item No.', ESP = 'No. producto';


        }
        field(24; "New Variant Code"; Code[10])
        {
            TableRelation = "Item Variant"."Code" WHERE("Item No." = FIELD("Item No."));
            CaptionML = ENU = 'New Variant Code', ESP = 'Cod. variante nuevo';


        }
        field(27; "Applies-to Entry"; Integer)
        {


            CaptionML = ENU = 'Applies-to Entry', ESP = 'Liq. por n� orden';

            trigger OnValidate();
            VAR
                //                                                                 ItemLedgerEntry@7001100 :
                ItemLedgerEntry: Record 32;
            BEGIN
                IF "Applies-to Entry" <> 0 THEN BEGIN
                    ItemLedgerEntry.GET("Applies-to Entry");

                    TESTFIELD(Quantity);
                    IF Signed(Quantity) > 0 THEN BEGIN
                        IF Quantity > 0 THEN
                            FIELDERROR(Quantity, Text030);
                        IF Quantity < 0 THEN
                            FIELDERROR(Quantity, Text029);
                    END;
                    ItemLedgerEntry.TESTFIELD(Open, TRUE);
                    ItemLedgerEntry.TESTFIELD(Positive, TRUE);

                    "Location Code" := ItemLedgerEntry."Location Code";
                    "Variant Code" := ItemLedgerEntry."Variant Code";
                END;
            END;

            trigger OnLookup();
            BEGIN
                SelectItemEntry(FIELDNO("Applies-to Entry"));
            END;


        }
        field(28; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensi�n';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       ActivationHeader@7001100 :
        ActivationHeader: Record 7207367;
        //       ActivationLine@7001103 :
        ActivationLine: Record 7207368;
        //       Currency@7001101 :
        Currency: Record 4;
        //       Text000@7001102 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       RentalElements@7001104 :
        RentalElements: Record 7207344;
        //       DimensionManagement@7001105 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       Text029@7001107 :
        Text029: TextConst ENU = 'must be positive', ESP = 'debe ser positivo';
        //       Text030@7001106 :
        Text030: TextConst ENU = 'must be negative', ESP = 'debe ser negativo';



    trigger OnInsert();
    begin
        LOCKTABLE;
        ActivationHeader."No." := '';

        GetRecelementHeader;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetRecelementHeader()
    begin
        TESTFIELD("Document No.");
        if "Document No." <> ActivationHeader."No." then begin
            ActivationHeader.GET("Document No.");
            "Element Code" := ActivationHeader."Element Code";
            if ActivationHeader."Currency Code" = '' then begin
            end else begin
                ActivationHeader.TESTFIELD("Currency Factor");
                Currency.GET(ActivationHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    end;

    procedure ShowDimensions()
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       SourceCodeSetup@1008 :
        SourceCodeSetup: Record 242;
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
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        GetRecelementHeader;

        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Elements Activation", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            ActivationHeader."Dimension Set ID", DATABASE::Vendor);
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Activation Line", FieldNo);
        exit(Field."Field Caption");
    end;

    //     procedure Signed (Value@1000 :
    procedure Signed(Value: Decimal): Decimal;
    begin
        exit(-Value);
    end;

    //     LOCAL procedure CalcUnitCost (ItemLedgEntryNo@1000 :
    LOCAL procedure CalcUnitCost(ItemLedgEntryNo: Integer): Decimal;
    var
        //       ValueEntry@1001 :
        ValueEntry: Record 5802;
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Expected Cost");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
        ValueEntry.SETRANGE("Expected Cost", FALSE);
        ValueEntry.CALCSUMS("Invoiced Quantity", "Cost Amount (Actual)");
        exit(ValueEntry."Cost Amount (Actual)" / ValueEntry."Invoiced Quantity");
    end;

    //     LOCAL procedure SelectItemEntry (CurrentFieldNo@1000 :
    LOCAL procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        //       ItemLedgerEntry@1001 :
        ItemLedgerEntry: Record 32;
        //       ActivationLine2@1002 :
        ActivationLine2: Record 7207368;
    begin
        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Variant Code", Open);
        ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgerEntry.SETRANGE(Correction, FALSE);

        if "Location Code" <> '' then
            ItemLedgerEntry.SETRANGE("Location Code", "Location Code");

        ItemLedgerEntry.SETRANGE(Positive, TRUE);
        ItemLedgerEntry.SETRANGE(Open, TRUE);

        if PAGE.RUNMODAL(PAGE::"Item Ledger Entries", ItemLedgerEntry) = ACTION::LookupOK then begin
            ActivationLine2 := Rec;
            ActivationLine2.VALIDATE("Applies-to Entry", ItemLedgerEntry."Entry No.");
            CheckItemAvailable(CurrentFieldNo);
            Rec := ActivationLine2;
        end;
    end;

    //     LOCAL procedure CheckItemAvailable (CalledByFieldNo@1000 :
    LOCAL procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
        if (CurrFieldNo = 0) or (CurrFieldNo <> CalledByFieldNo) then
            exit;
    end;

    /*begin
    end.
  */
}







