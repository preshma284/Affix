table 7207371 "QBU Activation Line Hist."
{


    CaptionML = ENU = 'Activation Line Hist.', ESP = 'Hist. L�neas activaci�n';
    DrillDownPageID = "Activation Lines Hist. Subform";

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


        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


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
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       DimensionManagement@7001100 :
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

    procedure ShowDimensions()
    begin
        TESTFIELD("No.");
        TESTFIELD("Line No.");
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Activation Line Hist.", FieldNo);
        exit(Field."Field Caption");
    end;

    /*begin
    end.
  */
}







