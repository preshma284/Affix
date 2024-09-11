page 7207608 "QB Job List Temp"
{
    Editable = false;
    CaptionML = ENU = 'Jobs', ESP = 'Proyectos';
    SourceTable = 167;
    PageType = List;
    SourceTableTemporary = true;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the involved entry or record, according to the specified number series.', ESP = 'Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                    ApplicationArea = Jobs;
                }
                field("Description"; rec."Description")
                {

                    ToolTipML = ENU = 'Specifies a short description of the job.', ESP = 'Especifica una descripci�n breve del proyecto.';
                    ApplicationArea = Jobs;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    ToolTipML = ENU = 'Specifies the number of the customer who pays for the job.', ESP = 'Especifica el n�mero del cliente que paga el proyecto.';
                    ApplicationArea = Jobs;
                }
                field("Person Responsible"; rec."Person Responsible")
                {

                    ToolTipML = ENU = 'Specifies the name of the person responsible for the job. You can select a name from the list of resources available in the Resource List window. The name is copied from the No. field in the Resource table. You can choose the field to see a list of resources.', ESP = 'Especifica el nombre de la persona responsable del proyecto. Se puede seleccionar un nombre de la lista de recursos disponibles en la ventana Lista de recursos. El nombre se copia del campo N.� correspondiente a la tabla Recurso. Se puede elegir el campo para ver una lista de recursos.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                }
                field("Project Manager"; rec."Project Manager")
                {

                    ToolTipML = ENU = 'Specifies the person assigned as the manager for this job.', ESP = 'Especifica la persona asignada como administrador para este proyecto.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                }
                field("Job Posting Group"; rec."Job Posting Group")
                {

                    ToolTipML = ENU = 'Specifies a job posting group code for a job. To see the available codes, choose the field.', ESP = 'Especifica un c�digo de grupo de registro de proyecto para un proyecto. Para ver los c�digos disponibles, elija el campo.';
                    ApplicationArea = Jobs;
                    Visible = FALSE

  ;
                }

            }

        }
    }


    procedure AddRec(pJob: Record 167);
    begin
        Rec := pJob;
        Rec.INSERT;
    end;

    // begin//end
}







