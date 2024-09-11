table 7207347 "QBU Rent Element LM"
{


    CaptionML = ENU = 'Rent Element LM', ESP = 'LM elemento alquiler';
    LookupPageID = "Rental Elements List";
    DrillDownPageID = "Rental Elements List";

    fields
    {
        field(1; "Rent Elements Code"; Code[20])
        {
            TableRelation = "Rental Elements";
            CaptionML = ENU = 'Rent Elements Code', ESP = 'C�digo elemento alquiler';


        }
        field(2; "No."; Code[20])
        {
            TableRelation = "Rental Elements";
            CaptionML = ENU = 'No.', ESP = 'No.';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. l�nea';


        }
        field(4; "Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Rental Elements"."Description" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(5; "Quantity by"; Decimal)
        {
            CaptionML = ENU = 'Quantity by', ESP = 'Cantidad por';


        }
        field(6; "Status"; Option)
        {
            OptionMembers = "New","Used","Seen";
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'New,Used,Seen', ESP = 'Nuevo,Usado,Visto';



        }
        field(7; "Item No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Rental Elements"."Related Product" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Item No.', ESP = 'No. producto';
            Editable = false;


        }
        field(8; "Variant Code"; Code[10])
        {
            TableRelation = "Rental Variant";
            CaptionML = ENU = 'Variant Code', ESP = 'Cod. variante';


        }
        field(9; "Weighing"; Decimal)
        {
            CaptionML = ENU = 'Weighing', ESP = 'Ponderaci�n';


        }
        field(10; "Base Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Base Unit of Measure', ESP = 'Unidad de medida base';


        }
        field(11; "Rent Price/Time Unit"; Decimal)
        {
            CaptionML = ENU = 'Rent Price/Time Unit', ESP = 'Precio alquiler/unid. tiempo';
            MinValue = 0;
            AutoFormatType = 2;


        }
        field(12; "Time Medium Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Time Medium Unit', ESP = 'Unidad media tiempo';
            ;


        }
    }
    keys
    {
        key(key1; "Rent Elements Code", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Text000@7001100 :
        Text000: TextConst ENU = 'A type element can not be part of your bill of materials.', ESP = 'Un elemento tipo lista de materiales  no puede formar parte de su lista de materiales.';



    trigger OnInsert();
    begin
        if "Rent Elements Code" = "No." then
            ERROR(Text000);
    end;



    /*begin
        end.
      */
}







