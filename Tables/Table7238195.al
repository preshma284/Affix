table 7238195 "QBU Proyectos inmobiliarios"
{


    Permissions = TableData 349 = rimd; //,
                                        //Table doesn't exist in database
                                        // TableData 7238196=rm,
                                        // TableData 7238215=rm;
    DataCaptionFields = "No.", "Nombre";
    // LookupPageID = Page7219740;
    // DrillDownPageID = Page7219740;

    fields
    {
        field(1; "No."; Code[20])
        {
            TableRelation = IF ("Tipo" = FILTER("Zonas")) "Proyectos inmobiliarios"."No." WHERE("Tipo" = FILTER("Zonas")) ELSE IF ("Tipo" = FILTER("Centros de coste")) "Proyectos inmobiliarios"."No." WHERE("Tipo" = FILTER("Centros de coste")) ELSE IF ("Tipo" = FILTER("Obras-Promociones")) "Proyectos inmobiliarios"."No." WHERE("Tipo" = FILTER("Obras-Promociones")) ELSE IF ("Tipo" = FILTER("Fases de venta")) "Proyectos inmobiliarios"."No." WHERE("Tipo" = FILTER("Fases de venta")) ELSE IF ("Tipo" = FILTER("Sectores")) "Proyectos inmobiliarios"."No." WHERE("Tipo" = FILTER("Sectores"));
            ValidateTableRelation = false;
            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'QRE-LCG Estaba en 5 y lo he pasado a 20';


        }
        field(2; "Nombre"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';


        }
        field(53; "Tipo"; Option)
        {
            OptionMembers = "Centros de coste","Obras-Promociones","Fases de venta","Zonas","Sectores","Estudio","Enajenacion","Ingreso";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Cost centres,Building work-Developments,Sales stages,Areas, Sectors,,,,,Study', ESP = 'Centros de coste,Obras-Promociones,Fases de venta,Zonas,Sectores,,,,,Estudio,,Enajenacion,Ingreso';



        }
    }
    keys
    {
        key(key1; "Tipo", "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Tipo", "No.", "Nombre")
        {

        }
    }


    /*begin
    {
      RE15721-LCG-16122021 - A�adir campo "QB_Investment Opportunity No." para ver trazabilidad.
      RE16902 DGG 300322: Se a�ade el campo QB_Plot Area Superficie Parcela.
      RE17055 DGG 280422: Se a�ade la opci�n "VPO Concertado"  al campo 30 "Tipo / Regimen".
    }
    end.
  */
}







