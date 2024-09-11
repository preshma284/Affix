table 7207374 "QBU Hist. Element Contract Line"
{


    CaptionML = ENU = 'Hist. Element Contract Line', ESP = 'Hist. l�neas contrato elemento';
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


        }
        field(5; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            CaptionML = ENU = 'Location Code', ESP = 'Code localizaci�n';


        }
        field(6; "Quantity to Send"; Decimal)
        {
            CaptionML = ENU = 'Quantity to Send', ESP = 'Cantidad a enviar';


        }
        field(7; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


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
        field(11; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit of Measure', ESP = 'Unidad de medida';


        }
        field(12; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceo dir. 2';
            CaptionClass = '1,2,2';


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


        }
        field(16; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'Cod. unidad de obra';


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
        field(27; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', ESP = 'Precio unitario';
            Editable = false;
            AutoFormatExpression = "Currency Code";


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
        //       Text000@7001100 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       DimensionManagement@7001101 :
        DimensionManagement: Codeunit "DimensionManagement";



    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    procedure ShowDimensions()
    begin
        // Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    /*begin
    end.
  */
}







