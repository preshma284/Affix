table 7207357 "QBU Line Delivery/Return Element"
{


    CaptionML = ENU = 'Line Delivery/Return Element', ESP = 'Lin. entrega/devol elemen';
    PasteIsValid = false;
    LookupPageID = "Subform. Elements Delivery";
    DrillDownPageID = "Subform. Elements Delivery";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header"."No.";
            CaptionML = ENU = 'Contract Code', ESP = 'Cod. contrato';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';


        }
        field(4; "No."; Code[20])
        {
            TableRelation = "Rental Elements";


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                LineDeliveryReturnElement := Rec;
                INIT;
                "No." := LineDeliveryReturnElement."No.";
                IF "No." = '' THEN
                    EXIT;

                GetMasterHeader;
                HeaderDeliveryReturnElement.TESTFIELD("Contract Code");

                "Contract Code" := HeaderDeliveryReturnElement."Contract Code";
                "Currency Code" := HeaderDeliveryReturnElement."Currency Code";
                "Shortcut Dimensios 1 Code" := HeaderDeliveryReturnElement."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := HeaderDeliveryReturnElement."Shortcut Dimension 2 Code";

                "Job No." := HeaderDeliveryReturnElement."Job No.";
                RentalElements.GET("No.");
                Description := RentalElements.Description;
                "Description 2" := RentalElements."Description 2";
                "Unit of Measure" := RentalElements."Base Unit of Measure";
                "Unit Price" := RentalElements."Rent Price/Time Unit";
                "Rent Effective Date" := HeaderDeliveryReturnElement."Rent Effective Date";
                "Element Unit Weight" := RentalElements."Element Unit Weight";
                // Miro si el elemento est� en contrato

                ElementContractLines.SETRANGE(ElementContractLines."Document No.", "Contract Code");
                ElementContractLines.SETRANGE(ElementContractLines."No.", "No.");
                IF ElementContractLines.FINDFIRST THEN BEGIN
                    Description := ElementContractLines.Description;
                    "Description 2" := ElementContractLines."Description 2";
                    "Unit of Measure" := ElementContractLines."Unit of Measure";
                    VALIDATE("Location Code", ElementContractLines."Location Code");
                    VALIDATE("Unit Price", ElementContractLines."Rent Price");
                END;

                CreateDim(DATABASE::"Rental Elements", "No.");
            END;


        }
        field(5; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            CaptionML = ENU = 'Location Code', ESP = 'Cod almac�n';


        }
        field(6; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure', ESP = 'Unidad de medida';


        }
        field(7; "Variant Code"; Code[10])
        {
            TableRelation = "Rental Variant"."Code" WHERE("Rental Variant" = CONST(true));
            CaptionML = ENU = 'Variant Code', ESP = 'Cod. Variante';


        }
        field(8; "Applicated Entry No."; Integer)
        {
            TableRelation = IF ("Rectification" = CONST(false)) "Rental Elements Entries"."Entry No." WHERE("Contract No." = FIELD("Contract Code"), "Element No." = FIELD("No."), "Entry Type" = CONST("Delivery"), "Pending" = CONST(true)) ELSE IF ("Rectification" = CONST(true)) "Rental Elements Entries"."Entry No." WHERE("Contract No." = FIELD("Contract Code"), "Element No." = FIELD("No."), "Entry Type" = CONST("Delivery"));


            CaptionML = ENU = 'Applicated Entry No.', ESP = 'No. mov. liquidado';

            trigger OnValidate();
            BEGIN
                ValidateEntries;
            END;


        }
        field(9; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(10; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(11; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', ESP = 'Precio unitario';
            AutoFormatType = 2;
            AutoFormatExpression = CurrencyCode;


        }
        field(12; "Shortcut Dimensios 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimensios 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimensios 1 Code");
            END;


        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(14; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';
            Editable = false;


        }
        field(15; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';

            trigger OnValidate();
            BEGIN
                GetMasterHeader;
                IF HeaderDeliveryReturnElement."Document Type" = HeaderDeliveryReturnElement."Document Type"::Return THEN BEGIN
                    "Amount to Manipulate" := Quantity;
                    Pending(Rec);
                END ELSE BEGIN
                    CALCFIELDS("Amount Manipulated");
                    "Amount to Manipulate" := Quantity - "Amount Manipulated";
                END;
            END;


        }
        field(16; "Amount to Manipulate"; Decimal)
        {


            CaptionML = ENU = 'Amount to Manipulate', ESP = 'Cantidad a manipular';

            trigger OnValidate();
            BEGIN
                GetMasterHeader;
                IF HeaderDeliveryReturnElement."Document Type" = HeaderDeliveryReturnElement."Document Type"::Return THEN BEGIN
                    Quantity := "Amount to Manipulate";
                    Pending(Rec);
                END;

                CALCFIELDS("Amount Manipulated");
                IF "Amount to Manipulate" > (Quantity - "Amount Manipulated") THEN
                    ERROR(Text001, Quantity - "Amount Manipulated");

                "Weight to Manipulate" := "Element Unit Weight" * "Amount to Manipulate";
            END;


        }
        field(17; "Amount Manipulated"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Hist. Lin. Deliv/Return Elem."."Quantity" WHERE("Document No." = FIELD("Document No."), //Document No.
                                                                                                                   "Line No." = FIELD("Line No."),
                                                                                                                   "Contract Code" = FIELD("No.")));
            CaptionML = ENU = 'Amount Manipulated', ESP = 'Cantidad manipulada';
            Editable = false;


        }
        field(18; "Rent Effective Date"; Date)
        {
            CaptionML = ENU = 'Rent Effective Date', ESP = 'Fecha efectiva alquiler';


        }
        field(19; "Source Document Line"; Integer)
        {
            CaptionML = ENU = 'Source Document Line', ESP = 'L�nea doc. origen';
            Editable = false;


        }
        field(20; "Source Document"; Code[20])
        {
            CaptionML = ENU = 'Source Document', ESP = 'Documento origen';


        }
        field(21; "Element Unit Weight"; Decimal)
        {
            CaptionML = ENU = 'Element Unit Weight', ESP = 'Peso unitario elemento';


        }
        field(22; "Weight to Manipulate"; Decimal)
        {
            CaptionML = ENU = 'Weight to Manipulate', ESP = 'Peso a manipular';
            Editable = false;


        }
        field(23; "Rectification"; Boolean)
        {
            CaptionML = ENU = 'Rectification', ESP = 'Rectificaci�n';


        }
        field(24; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'Cod. unidad de obra';


        }
        field(25; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            Editable = false;


        }
        field(26; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';
            NotBlank = true;


        }
        field(27; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimesnion Set ID', ESP = 'Id. grupo dimensiones';
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
            SumIndexFields = "Unit Price", "Weight to Manipulate", "Quantity";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CurrencyCode@7001100 :
        CurrencyCode: Text;
        //       HeaderDeliveryReturnElement@7001101 :
        HeaderDeliveryReturnElement: Record 7207356;
        //       Text000@7001102 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       LineDeliveryReturnElement@7001103 :
        LineDeliveryReturnElement: Record 7207357;
        //       RentalElements@7001104 :
        RentalElements: Record 7207344;
        //       ElementContractLines@7001105 :
        ElementContractLines: Record 7207354;
        //       Text001@7001106 :
        Text001: TextConst ENU = 'The amount to be manipulated can not be greater than the slope to handle %1', ESP = 'La cantidad a manipular no puede ser superior a la pendiente de manipular %1';
        //       Currency@7001107 :
        Currency: Record 4;
        //       DimensionManagement@7001108 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       GLSetupRead@7001109 :
        GLSetupRead: Boolean;
        //       GeneralLedgerSetup@7001110 :
        GeneralLedgerSetup: Record 98;



    trigger OnInsert();
    begin
        LOCKTABLE;
        HeaderDeliveryReturnElement."No." := '';

        "Source Document" := "Document No.";
        "Source Document Line" := "Line No.";
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    // LOCAL procedure CreateDim (Type1@7001100 : Integer;No1@7001101 :
    LOCAL procedure CreateDim(Type1: Integer; No1: Code[20])
    begin
    end;

    LOCAL procedure GetMasterHeader()
    begin
        // Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");
        if "Document No." <> HeaderDeliveryReturnElement."No." then begin
            HeaderDeliveryReturnElement.GET("Document No.");
            if HeaderDeliveryReturnElement."Currency Code" = '' then begin
                // Acciones a realizar si no hay doble divisa
            end else begin
                HeaderDeliveryReturnElement.TESTFIELD("Currency Factor");
                Currency.GET(HeaderDeliveryReturnElement."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    end;

    procedure ValidateEntries()
    var
        //       VHeaderDeliveryReturnElement@7001100 :
        VHeaderDeliveryReturnElement: Record 7207356;
        //       VRentalElementsEntries@7001101 :
        VRentalElementsEntries: Record 7207345;
        //       Text1000@7001102 :
        Text1000: TextConst ENU = 'No movement to be settled on a delivery document', ESP = 'No se debe indicar  movimiento a liquidar en un documento de entrega';
        //       Text1001@7001103 :
        Text1001: TextConst ENU = 'Movement %1 is not a delivery type and should be.', ESP = 'El movimiento %1 no es de tipo entrega y debe serlo.';
        //       Text1002@7001104 :
        Text1002: TextConst ENU = '%1 is fully paid', ESP = 'El movimiento %1  est� totalmente liquidado';
        //       Text1003@7001105 :
        Text1003: TextConst ENU = 'The amount to be handled can not exceed the amount outstanding %1', ESP = 'La cantidad a manipular no puede ser superior a la cantidad pendiente %1';
    begin
        VHeaderDeliveryReturnElement.GET("Document No.");
        if VHeaderDeliveryReturnElement."Document Type" = VHeaderDeliveryReturnElement."Document Type"::Delivery then
            ERROR(Text1000);
        VRentalElementsEntries.GET("Applicated Entry No.");
        VRentalElementsEntries.CALCFIELDS(VRentalElementsEntries."Return Quantity");

        if VRentalElementsEntries."Entry Type" <> VRentalElementsEntries."Entry Type"::Delivery then
            ERROR(Text1001, VRentalElementsEntries."Applied Entry No.");

        if Rectification = FALSE then
            if VRentalElementsEntries."Return Quantity" >= VRentalElementsEntries.Quantity then
                ERROR(Text1002, VRentalElementsEntries."Applied Entry No.");


        VALIDATE("No.", VRentalElementsEntries."Element No.");
        VALIDATE("Unit of Measure", VRentalElementsEntries."Unit of measure");
        VALIDATE("Shortcut Dimensios 1 Code", VRentalElementsEntries."Global Dimension 1 Code");
        VALIDATE("Shortcut Dimension 2 Code", VRentalElementsEntries."Global Dimension 2 Code");
        VALIDATE("Location Code", VRentalElementsEntries."Location code");
        VALIDATE("Variant Code", VRentalElementsEntries."Variant Code");
        VALIDATE("Unit Price", VRentalElementsEntries."Unit Price");
        Rectification := LineDeliveryReturnElement.Rectification;
        if Rectification then
            VALIDATE("Amount to Manipulate", 0)
        else
            VALIDATE("Amount to Manipulate", VRentalElementsEntries.Quantity - VRentalElementsEntries."Return Quantity");


        // Repesco el n� de movimiento que estoy liquidando
        "Applicated Entry No." := LineDeliveryReturnElement."Applicated Entry No.";
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@7001100 : Integer;var ShortcutDimCode@7001101 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure Pending (PLineDeliveryReturnElement@7001100 :
    procedure Pending(PLineDeliveryReturnElement: Record 7207357)
    var
        //       VRentalElementsEntries@7001101 :
        VRentalElementsEntries: Record 7207345;
        //       Text1000@7001102 :
        Text1000: TextConst ENU = 'The amount to be handled can not exceed the amount outstanding %1', ESP = 'La cantidad a manipular no puede ser superior a la cantidad pendiente %1';
        //       Text1001@7001103 :
        Text1001: TextConst ENU = 'The amount to be rectified can not be greater than the original quantity %1', ESP = 'La cantidad a rectifiar no puede ser superior a la cantidad original %1';
        //       Text1002@7001104 :
        Text1002: TextConst ENU = 'In a rectification the amount must be negative', ESP = 'En una rectificaci�n la cantidad debe ser negativa';
    begin
        if PLineDeliveryReturnElement."Applicated Entry No." = 0 then
            exit;

        VRentalElementsEntries.GET(PLineDeliveryReturnElement."Applicated Entry No.");
        VRentalElementsEntries.CALCFIELDS(VRentalElementsEntries."Return Quantity");

        if Rectification then begin
            if PLineDeliveryReturnElement."Amount to Manipulate" > 0 then
                ERROR(Text1001);
            if (VRentalElementsEntries.Quantity + PLineDeliveryReturnElement."Amount to Manipulate") < 0 then
                ERROR(Text1000, VRentalElementsEntries.Quantity);

        end else
            if PLineDeliveryReturnElement."Amount to Manipulate" > (VRentalElementsEntries.Quantity - VRentalElementsEntries."Return Quantity") then
                ERROR(Text1002, VRentalElementsEntries.Quantity - VRentalElementsEntries."Return Quantity");
    end;

    procedure ShowDimensions()
    begin
        // Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimensios 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@7001101 : Integer;var ShortcutDimCode@7001100 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // Busca el valor de las dimensiones por defecto
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@7001100 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        // Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@7001100 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@7001101 :
        Field: Record 2000000041;
    begin
        // Funci�n para el capti�n de la tabla, es lo que mostrar� el formulario
        Field.GET(DATABASE::"Line Delivery/Return Element", FieldNo);
        exit(Field."Field Caption");
    end;

    LOCAL procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GeneralLedgerSetup.GET;
        GLSetupRead := TRUE;
    end;

    /*begin
    end.
  */
}







