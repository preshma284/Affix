table 7207289 "Tran. Between Jobs Post Lines"
{


    CaptionML = ENU = 'Posted Lin. Tra. Cost-Invoice', ESP = 'Hist. lin. tra. costes-factura';
    PasteIsValid = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Documento No.', ESP = 'No. documento';


        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line No.', ESP = 'No. Line';


        }
        field(10; "Document Type"; Option)
        {
            OptionMembers = "Costs","Invoiced";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Cost,Invoiced', ESP = 'Costes,Facturaci�n';



        }
        field(11; "Allocation Account of Transfe"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Allocation Account of Transfe', ESP = 'Cta. de imputaci�n de traspaso';


        }
        field(12; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(14; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transfer an Amount', ESP = 'Importe a traspasar';


        }
        field(20; "Origin Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Status" = FILTER("Open"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Job No.', ESP = 'No. proyecto origen';


        }
        field(21; "Origin Departament"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Departament', ESP = 'Dpto. Origen';


        }
        field(22; "Origin C.A."; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'C.A. Origin', ESP = 'C.A origen';


        }
        field(23; "Origin Piecework"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Origin Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Piecework', ESP = 'Unidad de obra origen';


        }
        field(24; "Origin Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Origin Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Task No.', ESP = 'No. tarea origen';


        }
        field(25; "Origin Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones Origen';
            Editable = false;


        }
        field(30; "Destination Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Status" = FILTER("Open"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Job No.', ESP = 'No. proyecto destino';


        }
        field(31; "Destination Departament"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Departament', ESP = 'Dpto. destino';


        }
        field(32; "Destination C.A."; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'C.A. Destination', ESP = 'C.A. destino';


        }
        field(33; "Destination Piecework"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Destination Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Piecework', ESP = 'Unidad de obra destino';


        }
        field(34; "Destination Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Destination Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Destination Task No.', ESP = 'No. tarea destino';


        }
        field(35; "Destination Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID 2', ESP = 'Id. grupo dimensiones Destino';
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
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";

    procedure ShowDimensionsOrigin()
    begin
        DimensionManagement.ShowDimensionSet("Origin Dimension Set ID", STRSUBSTNO('%1 %2', "Document No.", "Line No."));
    end;

    procedure ShowDimensionsDestination()
    begin
        DimensionManagement.ShowDimensionSet("Destination Dimension Set ID", STRSUBSTNO('%1 %2', "Document No.", "Line No."));
    end;

    /*begin
    //{
//      JAV 28/10/19: - Se cambia el name y caption de la tabla para que sea mas significativo del contenido
//                    - Se elimina el campo "Document Type" de las l�neas y su parte de la clave
//    }
    end.
  */
}







