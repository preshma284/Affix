table 7174373 "QBU QuoFacturae endpoint"
{


    CaptionML = ENU = 'QuoFacturae endpoints', ESP = '"Puntos de entrada de Quofacturae "';

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', ESP = 'C�digo';


        }
        field(2; "URL"; Text[250])
        {

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
    }


    /*begin
    end.
  */
}







