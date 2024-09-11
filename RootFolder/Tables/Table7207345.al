table 7207345 "Rental Elements Entries"
{


    CaptionML = ENU = 'Rental Elements Entries', ESP = 'Registros de elementos de alquiler';
    LookupPageID = "Rental Elements Entries List";
    DrillDownPageID = "Rental Elements Entries List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'No. movimiento';


        }
        field(2; "Entry Type"; Option)
        {
            OptionMembers = "Delivery","Return";
            CaptionML = ENU = 'Entry Type', ESP = 'Tipo movimiento';
            OptionCaptionML = ENU = 'Delivery,Return', ESP = 'Entrega,Devoluci�n';



        }
        field(3; "Element No."; Code[20])
        {
            TableRelation = "Rental Elements";
            CaptionML = ENU = 'Element No.', ESP = 'No. elementos';


        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(5; "Unit of measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Unit of measure', ESP = 'Unidad de medida';


        }
        field(6; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(7; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(8; "Location code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            CaptionML = ENU = 'Location code', ESP = 'Cod. almacen';


        }
        field(9; "Variant Code"; Code[10])
        {
            TableRelation = "Rental Variant";
            CaptionML = ENU = 'Variant Code', ESP = 'Cod. variante';


        }
        field(10; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'No. cliente';


        }
        field(11; "Job No."; Code[20])
        {
            TableRelation = Job WHERE("Bill-to Customer No." = FIELD("Customer No."));
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(12; "Contract No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Contract No.', ESP = 'No. contrato';


        }
        field(13; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', ESP = 'Precio unitario';
            AutoFormatType = 2;


        }
        field(14; "Rent effective Date"; Date)
        {
            CaptionML = ENU = 'Rent effective Date', ESP = 'Fecha efectiva alquiler';
            Editable = false;


        }
        field(15; "Applied Entry No."; Integer)
        {
            TableRelation = "Rental Elements Entries";
            CaptionML = ENU = 'Applied Entry No.', ESP = 'No. mov. liquidado';
            Editable = false;


        }
        field(16; "Return Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Rental Elements Entries"."Quantity" WHERE("Applied Entry No." = FIELD("Entry No."),
                                                                                                              "Rent effective Date" = FIELD("Date Filter")));
            CaptionML = ENU = 'Return Quantity', ESP = 'Cantidad Devuelta';
            Editable = false;


        }
        field(17; "Return Last Date"; Date)
        {
            CaptionML = ENU = 'Return Last Date', ESP = 'Fecha �ltima devoluci�n';
            Editable = false;


        }
        field(18; "Applied Last Date"; Date)
        {
            CaptionML = ENU = 'Applied Last Date', ESP = 'Fecha �ltima liquidaci�n';
            Editable = false;


        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Global Dimension 1 Code', ESP = 'Cod. dimensi�n global 1';
            CaptionClass = '1,1,1';


        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Global Dimension 2 Code', ESP = 'Cod. dimensi�n global 2';
            CaptionClass = '1,1,2';


        }
        field(21; "User ID"; Code[50])
        {
            TableRelation = User."User Name";


            ValidateTableRelation = false;
            //TestTableRelation=false;
            CaptionML = ENU = 'User ID', ESP = 'Id. usuario';

            trigger OnLookup();
            BEGIN
                UserManagement.LookupUserID("User ID")
            END;


        }
        field(22; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
            CaptionML = ENU = 'Source Code', ESP = 'Cod.';


        }
        field(23; "System_Created Entry"; Boolean)
        {
            CaptionML = ENU = 'System_Created Entry', ESP = 'Aiento autom�tico';


        }
        field(24; "Quantity"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Cantidad';
            Editable = false;


        }
        field(25; "Business Unit Code"; Code[20])
        {
            TableRelation = "Business Unit";
            CaptionML = ENU = 'Business Unit Code', ESP = 'Cod. empresa';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(26; "Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name', ESP = 'Nombre secci�n diario';


        }
        field(27; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod.';


        }
        field(28; "Transaction No."; Integer)
        {
            CaptionML = ENU = 'Transaction No.', ESP = 'No.';


        }
        field(29; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ESP = 'Fecha documento';


        }
        field(30; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', ESP = 'No. documento externo';


        }
        field(31; "Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie No.', ESP = 'No. serie';


        }
        field(32; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(33; "Pending"; Boolean)
        {
            InitValue = true;
            CaptionML = ENU = 'Pending', ESP = 'Pendiente';


        }
        field(34; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'Cod. unidad de obra';


        }
        field(35; "Applied First Pending Entry"; Boolean)
        {
            CaptionML = ENU = 'Applied First Pending Entry', ESP = 'Mov. pdte primera liquidaci�n';


        }
        field(36; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Job Task No.', ESP = 'No. tarea proyecto';
            NotBlank = true;


        }
        field(37; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'ID. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Document No.", "Element No.")
        {
            ;
        }
        key(key3; "Element No.", "Posting Date", "Entry Type")
        {
            SumIndexFields = "Unit Price", "Quantity";
        }
        key(key4; "Transaction No.")
        {
            ;
        }
        key(key5; "Element No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Entry Type", "Customer No.", "Job No.", "Contract No.", "Piecework Code")
        {
            SumIndexFields = "Quantity";
        }
        key(key6; "Document No.", "Posting Date")
        {
            ;
        }
        key(key7; "Applied Entry No.", "Rent effective Date")
        {
            SumIndexFields = "Quantity";
        }
        key(key8; "Contract No.", "Entry Type", "Element No.", "Job No.", "Variant Code", "Location code", "Piecework Code")
        {
            SumIndexFields = "Quantity";
        }
        key(key9; "Customer No.", "Job No.", "Contract No.", "Posting Date", "Pending")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       UserManagement@7001100 :
        UserManagement: Codeunit "User Management 1";

    procedure ShowDimensions()
    var
        //       DimensionManagement@1000 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Entry No."));
    end;

    /*begin
    //{
//      Pongo en esta clave N� Contrato,Tipo Movimiento un campo calculado de cantidad y un campo en la clave que es el n� de elemento.
//    }
    end.
  */
}







