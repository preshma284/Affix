table 7207354 "Element Contract Lines"
{


    CaptionML = ENU = 'Element Contract Lines', ESP = 'L�neas contrato elemento';
    PasteIsValid = false;

    fields
    {
        field(1; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";
            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'No. Cliente/vendedor';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. linea';


        }
        field(4; "No."; Code[20])
        {
            TableRelation = "Rental Elements";


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                IF (xRec."No." <> '') AND (xRec."No." <> "No.") THEN BEGIN
                    CheckStatus;
                    xRec.CALCFIELDS("Delivered Quantity", "Return Quantity");
                    IF xRec."Delivered Quantity" <> 0 THEN
                        ERROR(Text003);
                END;
                ControlLineDuplicate;

                ElementContractLines := Rec;
                INIT;
                "No." := ElementContractLines."No.";
                "Piecework Code" := ElementContractLines."Piecework Code";
                "Job No." := ElementContractLines."Job No.";
                "Location Code" := ElementContractLines."Location Code";
                IF "No." = '' THEN
                    EXIT;

                MasterHeader;
                ElementContractHeader.TESTFIELD("Customer/Vendor No.");

                "Customer/Vendor No." := ElementContractHeader."Customer/Vendor No.";
                "Currency Code" := ElementContractHeader."Currency Code";
                VALIDATE("Shortcut Dimension 1 Code", ElementContractHeader."Shortcut Dimension 1 Code");
                VALIDATE("Shortcut Dimension 2 Code", ElementContractHeader."Shortcut Dimension 2 Code");
                RentalElements.GET("No.");
                Description := RentalElements.Description;
                "Rent Price" := RentalElements."Rent Price/Time Unit";
                "Unit of Measure" := RentalElements."Base Unit of Measure";
                "Job No." := ElementContractHeader."Job No.";

                IF Job.GET("Job No.") THEN BEGIN
                    IF Job."Job Location" <> '' THEN
                        "Location Code" := Job."Job Location";
                END;
                "Contract Type" := ElementContractHeader."Contract Type";
                "Contract Code" := ElementContractHeader."No.";
                CreateDim(DATABASE::"Rental Elements", "No.");
                RentalElementsSetup.GET();
                "Variant Code" := RentalElementsSetup."Variant Code for Rental";
            END;


        }
        field(5; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));


            CaptionML = ENU = 'Location Code', ESP = 'Code localizaci�n';

            trigger OnValidate();
            BEGIN
                ControlLineDuplicate;
                CheckStatus;
                xRec.CALCFIELDS("Delivered Quantity", "Return Quantity");
                IF xRec."Delivered Quantity" <> 0 THEN
                    ERROR(Text003);
            END;


        }
        field(6; "Quantity to Send"; Decimal)
        {
            CaptionML = ENU = 'Quantity to Send', ESP = 'Cantidad a enviar';


        }
        field(7; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripci�n';

            trigger OnValidate();
            BEGIN
                // No se permite dejar la descripci�n vacia
                TESTFIELD(Description);
            END;


        }
        field(8; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Desctipci�n 2';


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Vendor")) "Job" ELSE IF ("Contract Type" = CONST("Customer")) "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. Job';
            Editable = false;


        }
        field(10; "Rent Price"; Decimal)
        {


            CaptionML = ENU = 'Rent Price', ESP = 'Precio alquiler';
            AutoFormatType = 1;
            AutoFormatExpression = CurrencyCode;

            trigger OnValidate();
            BEGIN
                CheckStatus;
            END;


        }
        field(11; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";


            CaptionML = ENU = 'Unit of Measure', ESP = 'Unidad de medida';

            trigger OnValidate();
            BEGIN
                CheckStatus;
            END;


        }
        field(12; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceo dir. 2';
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
        field(15; "Planned Delivery Quantity"; Decimal)
        {


            CaptionML = ENU = 'Planned Delivery Quantity', ESP = 'Cantidad prevista envio';

            trigger OnValidate();
            BEGIN
                "Quantity to Send" := "Planned Delivery Quantity";
            END;


        }
        field(16; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Piecework Code', ESP = 'Cod. unidad de obra';

            trigger OnValidate();
            BEGIN
                ControlLineDuplicate;
                CheckStatus;
                xRec.CALCFIELDS("Delivered Quantity", "Return Quantity");
                IF xRec."Delivered Quantity" <> 0 THEN
                    ERROR(Text003);
            END;


        }
        field(17; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(18; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header"."No.";
            CaptionML = ENU = 'Contract Code', ESP = 'Cod. contrato';


        }
        field(19; "Return Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Rental Elements Entries"."Quantity" WHERE("Entry Type" = CONST("Return"),
                                                                                                              "Contract No." = FIELD("Contract Code"),
                                                                                                              "Job No." = FIELD("Job No."),
                                                                                                              "Element No." = FIELD("No."),
                                                                                                              "Location code" = FIELD("Location code"),
                                                                                                              "Variant Code" = FIELD("Variant Code"),
                                                                                                              "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'Return Quantity', ESP = 'Cantidad devuelta';
            Editable = false;


        }
        field(20; "Send Date"; Date)
        {
            CaptionML = ENU = 'Send Date', ESP = 'Fecha de envio';


        }
        field(21; "Retreat Date"; Date)
        {
            CaptionML = ENU = 'Retreat Date', ESP = 'Fecha de retirada';


        }
        field(22; "Retreat Quantity"; Decimal)
        {


            CaptionML = ENU = 'Retreat Quantity', ESP = 'Cantidad a retirar';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Delivered Quantity", "Return Quantity");
                IF "Retreat Quantity" > ("Delivered Quantity" - "Return Quantity") THEN
                    ERROR(Text002, FORMAT("Delivered Quantity" - "Return Quantity"));
            END;


        }
        field(23; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';
            NotBlank = true;


        }
        field(24; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(25; "Variant Code"; Code[10])
        {
            TableRelation = "Rental Variant" WHERE("Rental Variant" = CONST(true));
            CaptionML = ENU = 'Variant Code', ESP = 'Cod. variante';


        }
        field(26; "Delivered Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Elements Entries"."Quantity" WHERE("Entry Type" = CONST("Delivery"),
                                                                                                             "Contract No." = FIELD("Contract Code"),
                                                                                                             "Job No." = FIELD("Job No."),
                                                                                                             "Element No." = FIELD("No."),
                                                                                                             "Location code" = FIELD("Location code"),
                                                                                                             "Variant Code" = FIELD("Variant Code"),
                                                                                                             "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'Delivered Quantity', ESP = 'Cantidad entregada';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CurrencyCode@7001100 :
        CurrencyCode: Text;
        //       ElementContractHeader@7001101 :
        ElementContractHeader: Record 7207353;
        //       ElementContractLines@7001102 :
        ElementContractLines: Record 7207354;
        //       Text000@7001103 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text001@7001104 :
        Text001: TextConst ENU = 'There is already a line for this element of rent, job and piecework in the contract. Locate and modify the amount', ESP = 'Ya existe una linea para este elemento de alquiler, proyecto y unidad de obra en el contrato. Localicela y modifique la cantidad';
        //       Text002@7001105 :
        Text002: TextConst ENU = 'The amount to be returned can not be greater than the slope %1', ESP = 'La cantidad a devolver no puede ser mayor que la pendiente %1';
        //       Text003@7001106 :
        Text003: TextConst ENU = 'You can not delete or modify a line that has quantity delivered', ESP = 'No se puede borrar ni modificar una l�nea que tiene cantidad entregada';
        //       RentalElements@7001107 :
        RentalElements: Record 7207344;
        //       Job@7001108 :
        Job: Record 167;
        //       RentalElementsSetup@7001109 :
        RentalElementsSetup: Record 7207346;
        //       DimensionManagement@7001110 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       Currency@7001111 :
        Currency: Record 4;
        //       GLSetupRead@7001112 :
        GLSetupRead: Boolean;
        //       GLBudgetEntry@7001113 :
        GLBudgetEntry: Record 96;



    trigger OnInsert();
    begin
        LOCKTABLE;
        ElementContractHeader."No." := '';
    end;

    trigger OnDelete();
    begin
        CheckStatus;
        CALCFIELDS("Delivered Quantity", "Return Quantity");
        if "Delivered Quantity" <> 0 then
            ERROR(Text003);
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure LOCKTABLE()
    begin
    end;

    LOCAL procedure CheckStatus()
    begin
    end;

    LOCAL procedure MasterHeader()
    begin
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
        GetMasterHeader;
        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Rent Contract", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            ElementContractHeader."Dimension Set ID", DATABASE::"Rental Elements");
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    LOCAL procedure GetMasterHeader()
    begin
        //Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");
        if "Document No." <> ElementContractHeader."No." then begin
            ElementContractHeader.GET("Document No.");
            if ElementContractHeader."Currency Code" = '' then begin
                //Acciones a realizar si divisa vacia
            end else begin
                ElementContractHeader.TESTFIELD("Currency Factor");
                Currency.GET(ElementContractHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    end;

    procedure ControlLineDuplicate()
    begin
        if "No." <> '' then begin
            ElementContractLines.SETRANGE("Document No.", "Document No.");
            ElementContractLines.SETRANGE("No.", "No.");
            ElementContractLines.SETRANGE("Job No.", "Job No.");
            ElementContractLines.SETRANGE("Piecework Code", "Piecework Code");
            ElementContractLines.SETFILTER("Line No.", '<>%1', "Line No.");
            if ElementContractLines.FINDFIRST then
                ERROR(Text001);
        end;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // Valida que la dimensi�n introducida es coherente, es decirt existe dicho valor de dimensi�n.
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    begin
        // Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // Busca el valor de las dimensiones por defecto
        DimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        DimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    LOCAL procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLBudgetEntry.GET;
        GLSetupRead := TRUE;
    end;

    /*begin
    end.
  */
}







