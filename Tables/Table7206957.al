table 7206957 "QBU AUX J-B-P-D" //7206957

{


    CaptionML = ENU = 'TMP WebServices Report U.O.', ESP = 'TMP WebServices Informe U.O.';
    LookupPageID = "Data Piecework List";
    DrillDownPageID = "List Unit Production";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'C�d. proyecto';


        }
        field(2; "Budget Date"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(3; "Cod. Budget"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(4; "Piecework Code"; Text[20])
        {
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
            NotBlank = true;


        }
        // field(5; "Cost Type"; Option)
        field(5; "Cost Type"; Enum "Purchase Line Type")
        {
            // OptionMembers = "Resource","Resource Group","Item","Posting U.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cost Type', ESP = 'Tipo coste';
            // OptionCaptionML = ENU = ',Resource,Resource Group,Item,Posting U.', ESP = ',Recurso,Familia,Producto,U. Auxiliar';

        }
        field(6; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(10; "Type"; Option)
        {
            OptionMembers = "Job","Budget","Piecework","Descompuesto";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo';



        }
    }
    keys
    {
        key(key1; "Job No.", "Budget Date", "Cod. Budget", "Piecework Code", "Cost Type", "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Job No.", "Budget Date")//delete field 21
        {

        }
    }


    /*begin
    end.
  */
}







