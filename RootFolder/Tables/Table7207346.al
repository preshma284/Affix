table 7207346 "Rental Elements Setup"
{


    CaptionML = ENU = 'Rental Elements Setup', ESP = 'Conf. elementos de alquiler';
    LookupPageID = "Rental Elements Setup";
    DrillDownPageID = "Rental Elements Setup";

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            CaptionML = ENU = 'Primary Key', ESP = 'Clave primaria';


        }
        field(2; "Element No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Element No. Series', ESP = 'N� serie Elemento';


        }
        field(3; "Create Job Desviataion"; Boolean)
        {
            CaptionML = ENU = 'Create Job Desviaation', ESP = 'Crear proyecto desviaci�n';
            Description = 'Se crea proyecto desviai�n por elemento';


        }
        field(4; "No. Serie Contract"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Contract', ESP = 'N� Serie Contratos';


        }
        field(5; "No. Serie Rental Contract"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Contratos alquiler', ESP = 'N� Serie Contratos alquiler';


        }
        field(6; "No. Serie Post. Delivery"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Post. Delivery', ESP = 'N� Serie Entregas regis.';


        }
        field(7; "Nº Serie Delivery"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'N� Serie Delivery', ESP = 'N� Serie Entregas';


        }
        field(8; "Rental Elements Location"; Code[10])
        {
            TableRelation = "Location";
            CaptionML = ENU = 'Rental Elements Location', ESP = 'Almac�n Elementos alquilados';


        }
        field(9; "No. Serie Post. Return"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Post. Return', ESP = 'N� Serie Devol. regis.';


        }
        field(10; "No. Serie Returns"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Returns', ESP = 'N� Serie Devoluciones';


        }
        field(11; "No. Serie Usage"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie utilizacion', ESP = 'N� Serie utilizaci�n';


        }
        field(12; "No. Serie Post. Usage"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Post. Usage', ESP = 'N� Serie utilizaci�n regis.';


        }
        field(13; "No. Serie Activation"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie Post. Usage', ESP = 'N� Serie activaci�n';


        }
        field(14; "No. Serie Post. Activation"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Serie activacion regis.', ESP = 'N� Serie activaci�n regis.';


        }
        field(15; "Calendar Day Time Avg. Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Calendar Day Time Avg. Unit', ESP = 'Udad. Media tiempo d�a natural';


        }
        field(16; "Weekday Time Average Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Weekday Time Average Unit', ESP = 'Udad. Media tiempo d�a laboral';


        }
        field(17; "Month Time Average Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Month Time Average Unit', ESP = 'Udad. Media tiempo mes';


        }
        field(18; "Variant Code for Rental"; Code[10])
        {
            TableRelation = "Rental Variant";
            CaptionML = ENU = 'Variant Code for Rental', ESP = 'C�d.variante para alquiler def';
            ;


        }
    }
    keys
    {
        key(key1; "Primary Key")
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







