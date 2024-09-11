table 7206958 "QBU Tmp Data Prices Vendor"
{


    CaptionML = ENU = 'Data Prices Vendor', ESP = 'Datos precios proveedor';

    fields
    {
        field(1; "Type"; Code[2])
        {
            DataClassification = ToBeClassified;


        }
        field(2; "Vendor/Contact"; Code[20])
        {
            Editable = false;


        }
        field(3; "Version No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Version No.';
            Description = 'Q13150';


        }
        field(4; "Code"; Code[20])
        {

        }
        field(100; "D Job No."; Code[20])
        {
            TableRelation = "Job";
            Editable = false;


        }
        field(101; "D Location Code"; Code[10])
        {
            TableRelation = "Location";
            Editable = false;


        }
        field(201; "V Name"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(202; "V Contact"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(203; "V Telef"; Text[30])
        {
            DataClassification = ToBeClassified;


        }
        field(204; "V Fax"; Text[30])
        {
            DataClassification = ToBeClassified;


        }
        field(205; "V Mail"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(207; "V Seleccionado"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(208; "V NoPresentado"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(211; "L Pieceworl No"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(212; "L Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;


        }
        field(213; "L Type"; Option)
        {
            OptionMembers = "Item","Resource";
            OptionCaptionML = ENU = 'Item,Resource', ESP = 'Producto,Recurso';

            Editable = false;


        }
        field(214; "L No."; Code[20])
        {
            Editable = false;


        }
        field(215; "L Description"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(216; "L Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(217; "L UM"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(220; "L Price"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(221; "L Amount"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(222; "P Estimated Price"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(223; "P Estimated Amount"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(224; "P Target Price"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(225; "P Target Amount"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(226; "P Lowest Price"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(227; "P Lowestr Amount"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(230; "T Amount"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(231; "T Estimated"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(232; "T Target"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(233; "T Lowestr"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(272; "Q Quote Validity"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(273; "Q FP"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(274; "Q MP"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(275; "Q Witholding Code"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(276; "Q Return Withholding"; Text[30])
        {
            DataClassification = ToBeClassified;


        }
        field(277; "Q End Date"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(278; "Q Quote Date"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(279; "Q Start Date"; Date)
        {
            DataClassification = ToBeClassified;


        }
    }
    keys
    {
        key(key1; "Type", "Vendor/Contact", "Version No.", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    /*begin
    {
      JAV 04/03/19: Se a�ade el campo 18 "Piecework No." con la Unidad de obra de la l�nea de origen
      Q13150 JDC 06/04/21 - Added field 4 "Version No."
    }
    end.
  */
}







