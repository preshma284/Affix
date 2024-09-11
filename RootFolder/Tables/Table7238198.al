table 7238198 "Clasificación Clasif 2"
{


    // LookupPageID = Page7220348;

    fields
    {
        field(1; "Código"; Code[20])
        {
            CaptionML = ENU = 'Code', ESP = 'C�digo';
            Description = 'SHE.RGT.159/18 10->20';


        }
        field(2; "Descripción"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';
            Description = 'SHE.RGT.159/18 30->50';


        }
        field(3; "Department type"; Option)
        {
            OptionMembers = "General","Inmobiliario";
            CaptionML = ESP = 'Tipo departamento';
            OptionCaptionML = ENU = 'General,Real estate', ESP = 'General,Inmobiliario';



        }
    }
    keys
    {
        key(key1; "Código")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }


    /*begin
    {
      SHE.RPP.9/17 - Shebel, Raul Prada, 19/01/2017
      --------------------------------------------------
         Actualizaci�n del campo C�d Clasif 2 para tratarlo como una "dimensi�n global" de igual forma
         que hacemos con el C�d Clasif 1
         Peticion:

      SHE.RGT.159/18 - Shebel, Ricardo Gil, 06/06/2018
      --------------------------------------------------
         Error sobrepasamiento al modificar un dato en la tabla valor dimensi�n.
         Incidencia: 198.038


      SHE.AMT.106/19 - Shebel, Alberto Maestre, 25/04/2019
      --------------------------------------------------
         Eliminar la creaci�n multiempresa para el C�d. Clasif. 2
         Incidencia :   215.665
    }
    end.
  */
}







