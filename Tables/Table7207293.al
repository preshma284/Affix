table 7207293 "QBU Worksheet Lines Hist."
{


    CaptionML = ENU = 'Worksheet Lines Hist.', ESP = 'Hist. parte de trabajo l�nea';

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
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(7; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(8; "Resource No."; Code[20])
        {
            TableRelation = "Resource";
            CaptionML = ENU = 'Resource No.', ESP = 'N� recurso';


        }
        field(9; "Work Day Date"; Date)
        {
            CaptionML = ENU = 'Work Day Date', ESP = 'Fecha d�a de trabajo';


        }
        field(10; "Work Type Code"; Code[10])
        {
            TableRelation = "Resource Cost"."Work Type Code" WHERE("Type" = CONST("Resource"),
                                                                                                         "Code" = FIELD("Resource No."));


            CaptionML = ENU = 'Work Type Code', ESP = 'C�d. tipo de trabajo';
            NotBlank = true;

            trigger OnValidate();
            VAR
                //                                                                 recWorkType@1000000000 :
                recWorkType: Record 200;
            BEGIN
            END;


        }
        field(11; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';


        }
        field(12; "Direct Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Direct Cost Price', ESP = 'Precio coste directo';
            AutoFormatType = 2;


        }
        field(13; "Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Cost Price', ESP = 'Precio coste';
            AutoFormatType = 2;


        }
        field(14; "Total Cost"; Decimal)
        {
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            AutoFormatType = 2;


        }
        field(15; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Sale Price', ESP = 'Precio venta';
            AutoFormatType = 2;


        }
        field(16; "Sale Amount"; Decimal)
        {
            CaptionML = ENU = 'Sale Amount', ESP = 'Importe venta';
            AutoFormatType = 1;


        }
        field(17; "Billable"; Boolean)
        {
            CaptionML = ENU = 'Billable', ESP = 'Facturable';


        }
        field(19; "Piecework Code"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'N� unidad de obra';


        }
        field(20; "Compute In Hours"; Boolean)
        {
            CaptionML = ENU = 'Compute In Hours', ESP = 'Computa en horas';
            Editable = false;


        }
        field(22; "Type"; Option)
        {
            OptionMembers = " ","Type1","Type2","Type3";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,Type1,Type2,Type3"', ESP = '" ,Tipo1,Tipo2,Tipo3"';



        }
        field(23; "No."; Code[20])
        {
            CaptionML = ENU = 'No', ESP = 'N�';


        }
        field(24; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrencyCode;


        }
        field(100; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'N� tarea proyecto';
            NotBlank = true;


        }
        field(480; "Dimensions Set ID"; Integer)
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
        key(key2; "Compute In Hours", "Document No.")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@7001100 :
        DimMgt: Codeunit "DimensionManagement";

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
        DimMgt.ShowDimensionSet("Dimensions Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    /*begin
    end.
  */
}







