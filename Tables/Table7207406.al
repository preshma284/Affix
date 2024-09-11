table 7207406 "QBU Grouping Criteria"
{

    DataCaptionFields = "Code", "Name";
    CaptionML = ENU = 'Grouping Criteria', ESP = 'Criterio agrupaci�n';
    LookupPageID = "QB Gropuing Criteria List";

    fields
    {
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code', ESP = 'C�digo';


        }
        field(4; "Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            ;


        }
    }
    keys
    {
        key(key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Name")//Delete
        {

        }
    }


    /*begin
    end.
  */
}







