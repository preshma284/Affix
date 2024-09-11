table 7207363 "QBU Usage Line"
{


    CaptionML = ENU = 'Usage Line', ESP = 'L�neas utilizaci�n';
    PasteIsValid = false;
    LookupPageID = "Usage Line Subform.";
    DrillDownPageID = "Usage Line Subform.";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Contract Code', ESP = 'C�d. Contrato';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(4; "No."; Code[20])
        {
            TableRelation = "Rental Elements";


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'N� por tipo (identifica la l�nea de forma �nica)';
            Editable = false;

            trigger OnValidate();
            BEGIN
                UsageLine := Rec;
                INIT;
                "No." := UsageLine."No.";
                IF "No." = '' THEN
                    EXIT;

                GetMasterHeader;
                UsageHeader.TESTFIELD("Contract Code");

                "Contract Code" := UsageHeader."Contract Code";
                "Currency Code" := UsageHeader."Currency Code";
                "Shortcut Dimension 1 Code" := UsageHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := UsageHeader."Shortcut Dimension 2 Code";

                "Job No." := UsageHeader."Job No.";
                RentalElements.GET("No.");
                Description := RentalElements.Description;
                "Description 2" := RentalElements."Description 2";

                CreateDim(DATABASE::"Rental Elements", "No.");
            END;


        }
        field(5; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';


        }
        field(6; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', ESP = 'Precio Unitario';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(7; "Delivery Document"; Code[20])
        {
            CaptionML = ENU = 'Delivery Document', ESP = 'Documento de entrega';
            Editable = false;


        }
        field(8; "Usage Days"; Decimal)
        {
            CaptionML = ENU = 'Usage Days', ESP = 'D�as de utilizaci�n';
            Editable = false;


        }
        field(9; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(10; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(11; "Return Document"; Code[20])
        {
            CaptionML = ENU = 'Return Document', ESP = 'Documento de devoluci�n';
            Editable = false;


        }
        field(12; "Initial Date Calculation"; Date)
        {
            CaptionML = ENU = 'Initial Date Calculation', ESP = 'Fecha c�lculo inicial';
            Editable = false;


        }
        field(13; "Return Date"; Date)
        {
            CaptionML = ENU = 'Return Date', ESP = 'Fecha devoluci�n';
            Editable = false;


        }
        field(14; "Application Date"; Date)
        {
            CaptionML = ENU = 'Application Date', ESP = 'Fecha liquidaci�n';
            Editable = false;


        }
        field(15; "Delivery Mov. No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            CaptionML = ENU = 'Delivery Mov. No.', ESP = 'N� mov. entrega';
            Editable = false;


        }
        field(16; "Return Mov. No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            CaptionML = ENU = 'Return Mov. No.', ESP = 'N� mov. devoluci�n';
            Editable = false;


        }
        field(17; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(20; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(21; "Line Type"; Option)
        {
            OptionMembers = "Refund","Balance on Job";
            CaptionML = ENU = 'Line Type', ESP = 'Tipo de L�nea';
            OptionCaptionML = ENU = 'Refund,Balance on Job', ESP = 'Devoluci�n,Saldo en obra';



        }
        field(22; "Invoiced Quantity"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Quantity', ESP = 'Cantidad facturada';
            Editable = false;


        }
        field(23; "Pending Quantity"; Decimal)
        {
            CaptionML = ENU = 'Pending Quantity', ESP = 'Cantidad pendiente';
            Editable = false;


        }
        field(24; "Customer/Vendor No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'N� Cliente/proveedor';
            Editable = false;


        }
        field(25; "Quantity to invoice"; Decimal)
        {
            CaptionML = ENU = 'Quantity to invoice', ESP = 'Cantidad a facturar';
            Editable = false;


        }
        field(26; "Variant Code"; Code[10])
        {
            CaptionML = ENU = 'Variant Code', ESP = 'C�d. Variante';


        }
        field(27; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo Contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(28; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';


        }
        field(29; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Editable = false;


        }
        field(30; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'Job Task No.', ESP = 'N� tarea proyecto';
            NotBlank = true;

            trigger OnValidate();
            VAR
                //                                                                 Job@1000 :
                Job: Record 167;
                //                                                                 Cust@1001 :
                Cust: Record 18;
            BEGIN
            END;


        }
        field(31; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
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
        //       UsageHeader@7001108 :
        UsageHeader: Record 7207362;
        //       UsageLine2@7001107 :
        UsageLine2: Record 7207363;
        //       UsageLine@7001106 :
        UsageLine: Record 7207363;
        //       Currency@7001105 :
        Currency: Record 4;
        //       StandardText@7001104 :
        StandardText: Record 7;
        //       GeneralLedgerSetup@7001103 :
        GeneralLedgerSetup: Record 98;
        //       CUDimensionManagement@7001102 :
        CUDimensionManagement: Codeunit "DimensionManagement";
        //       GLSetupRead@7001101 :
        GLSetupRead: Boolean;
        //       RentalElements@7001100 :
        RentalElements: Record 7207344;
        //       Text000@7001109 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';



    trigger OnInsert();
    begin
        LOCKTABLE;
        UsageHeader."No." := '';
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetMasterHeader()
    begin
        //Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");
        if "Document No." <> UsageHeader."No." then begin
            UsageHeader.GET("Document No.");
            if UsageHeader."Currency Code" = '' then begin
                //Acciones a realizar si no hay doble divisa
            end else begin
                UsageHeader.TESTFIELD("Currency Factor");
                Currency.GET(UsageHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    end;

    procedure ShowDimensions()
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          CUDimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        CUDimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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
        CUDimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        GetMasterHeader;
        "Dimension Set ID" :=
          CUDimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Usage Document", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            UsageHeader."Dimension Set ID", DATABASE::"Rental Elements");
        CUDimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        CUDimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Busca el valor de las dimensiones por defecto
        CUDimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        CUDimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        //Funci�n para el capti�n de la tabla, es lo que mostrar� el formulario
        Field.GET(DATABASE::"Usage Line", FieldNo);
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







