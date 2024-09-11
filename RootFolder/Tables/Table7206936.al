table 7206936 "QB External Worksheet Lines Po"
{


    CaptionML = ENU = 'Posted Externals Worksheet Lines', ESP = 'Hist. l�neas parte de trabajo de externos';
    LookupPageID = "QB External Worksheet Lin. Pos";
    DrillDownPageID = "QB External Worksheet Lin. Pos";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(10; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor No.', ESP = 'Proveedor subcontrata';
            Editable = false;


        }
        field(11; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Editable = false;


        }
        field(12; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'N� unidad de obra';
            Editable = false;


        }
        field(13; "Resource No."; Code[20])
        {
            TableRelation = Resource WHERE("Type" = CONST("ExternalWorker"));
            CaptionML = ENU = 'Resource No.', ESP = 'N� recurso';
            Editable = false;


        }
        field(14; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Editable = false;


        }
        field(15; "Work Type Code"; Code[10])
        {
            TableRelation = "Resource Cost"."Work Type Code" WHERE("Type" = CONST("Resource"),
                                                                                                         "Code" = FIELD("Resource No."));


            CaptionML = ENU = 'Work Type Code', ESP = 'C�d. tipo de trabajo';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 recWorkType@1000000000 :
                recWorkType: Record 200;
            BEGIN
            END;


        }
        field(20; "Work Day Date"; Date)
        {
            CaptionML = ENU = 'Work Day Date', ESP = 'Fecha d�a de trabajo';
            Editable = false;


        }
        field(21; "Quantity"; Decimal)
        {


            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE("Quantity Pending");
            END;


        }
        field(22; "Cost Price"; Decimal)
        {
            CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
            Editable = false;
            AutoFormatType = 2;


        }
        field(23; "Total Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            Editable = false;
            AutoFormatType = 2;


        }
        field(31; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            Editable = false;
            CaptionClass = '1,2,1';


        }
        field(32; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            Editable = false;
            CaptionClass = '1,2,2';


        }
        field(40; "Invoice"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Facturar';

            trigger OnValidate();
            BEGIN
                IF (Invoice) THEN
                    VALIDATE("Quantity To Invoice", "Quantity Pending")
                ELSE
                    VALIDATE("Quantity To Invoice", 0);
            END;


        }
        field(41; "Quantity To Invoice"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad a Facturar';

            trigger OnValidate();
            BEGIN
                IF ("Quantity To Invoice" > "Quantity Pending") THEN
                    ERROR(txtQB000);
                "Amount to Invoice" := ROUND("Quantity To Invoice" * "Cost Price", 0.01);

                Invoice := ("Quantity To Invoice" <> 0);
            END;


        }
        field(42; "Quantity Invoiced"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad Facturada';
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE("Quantity Pending");
            END;


        }
        field(43; "Quantity Pending"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad Pendiente';
            Editable = false;

            trigger OnValidate();
            BEGIN
                "Quantity Pending" := Quantity - "Quantity Invoiced";
            END;


        }
        field(44; "Amount to Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe a Facturar';
            Editable = false;


        }

        /*To be tested*/
        //-- converted to enum from type option.
        field(45; "Apply to Document Type"; Enum "Purchase Document Type")
        {
            //OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            //OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';

            Editable = false;


        }
        field(46; "Apply to Document No"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimensions Set ID', ESP = 'Id. grupo dimensiones';
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
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";
        //       txtQB000@1100286000 :
        txtQB000: TextConst ESP = 'No puede facturar mas de lo pendiente.';

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
        Field.GET(DATABASE::"Worksheet Lines Hist.", FieldNo);
        exit(Field."Field Caption");
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    /*begin
    end.
  */
}







