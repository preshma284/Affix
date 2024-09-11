table 7207360 "QBU Hist. Lin. Deliv/Return Elem."
{


    CaptionML = ENU = 'Hist. Lin. Deliv/Return Elem.', ESP = 'Hist. L�n.  Entrega/Devol Elem';
    LookupPageID = "Subform. Hist. Lin Delivery/Re";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header";
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
            TableRelation = "Rental Elements"."No.";
            CaptionML = ENU = 'No.', ESP = 'No.';


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
            CaptionML = ENU = 'Applicated Entry No.', ESP = 'No. mov. liquidado';


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


        }
        field(12; "Shortcut Dimensios 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimensios 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


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
            SumIndexFields = "Unit Price", "Weight to Manipulate";
            Clustered = true;
        }
        key(key2; "Source Document", "Source Document Line", "No.")
        {
            SumIndexFields = "Quantity";
        }
    }
    fieldgroups
    {
    }

    var
        //       DimensionManagement@7207771 :
        DimensionManagement: Codeunit "DimensionManagement";

    procedure GetCurrencyCode(): Code[10];
    var
        //       PurchInvHeader@1000 :
        PurchInvHeader: Record 122;
    begin
        if ("Document No." = PurchInvHeader."No.") then
            exit(PurchInvHeader."Currency Code")
        else
            if PurchInvHeader.GET("Document No.") then
                exit(PurchInvHeader."Currency Code")
            else
                exit('');
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Hist. Lin. Deliv/Return Elem.", FieldNo);
        exit(Field."Field Caption");
    end;

    procedure ShowDimensions()
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    /*begin
    end.
  */
}







