table 7207280 "Activity QB"
{

    DataCaptionFields = "Activity Code", "Description";
    CaptionML = ENU = 'Activity HP', ESP = 'Actividades QB';
    LookupPageID = "Quobulding Activity List";
    DrillDownPageID = "Quobulding Activity List";

    fields
    {
        field(1; "Activity Code"; Code[20])
        {
            CaptionML = ENU = 'Cod. Activity', ESP = 'Cod. actividad';


        }
        field(2; "Description"; Text[30])
        {
            CaptionML = ENU = 'Description', ESP = 'Description';


        }
        field(3; "Posting Group Product"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            CaptionML = ENU = 'Posting Group Product', ESP = 'Grupo contable producto';


        }
        field(4; "Posting Group Stock"; Code[20])
        {
            TableRelation = "Inventory Posting Group";
            CaptionML = ENU = 'Posting Group Stock', ESP = 'Grupo contable existencia';


        }
        field(5; "Cod. Resource Subcontracting"; Code[20])
        {
            TableRelation = Resource."No." WHERE("Type" = CONST("Resource Type"::"Subcontracting"));
            CaptionML = ENU = 'Cod. Resource Subcontracting', ESP = 'Cod. recurso subcontrataci�n';


        }
        field(6; "Job Filter"; Code[20])
        {
            FieldClass = FlowFilter;

            TableRelation = "Job";
            CaptionML = ENU = 'Job Filter', ESP = 'Filtro proyecto';


        }
        field(7; "Budget Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Budget Filter', ESP = 'Filtro presupuesto';


        }
        field(8; "Evaluation Type"; Option)
        {
            OptionMembers = "Services","Items","Others";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo de evaluaci�n';
            OptionCaptionML = ENU = 'Services,Items,Others', ESP = 'Servicios,Productos,Otros';

            Description = 'JAV 21/09/19: - Uso para poder evaluar que sean servicios, productos u otros';


        }
    }
    keys
    {
        key(key1; "Activity Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       txtQB000@1100286000 :
        txtQB000: TextConst ESP = 'No puede renombrar la actividad sin c�digo, eliminela y cree una nueva.';



    trigger OnRename();
    begin
        //JAV 13/03/19: - Limitar que no se renombre una actividad sin c�digo
        if (xRec."Activity Code" = '') then
            ERROR(txtQB000);
    end;



    /*begin
        {
          JAV 13/03/19: - Limitar que no se renombre una actividad sin c�digo
          JAV 21/09/19: - Se a�ade el campo 8 "Evaluation Type", que indica si se usar� para poder evaluar que sean servicios, productos u otros
        }
        end.
      */
}







