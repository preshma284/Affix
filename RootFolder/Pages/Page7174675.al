page 7174675 "Employee List DragDrop Example"
{
    Editable = false;
    CaptionML = ENU = 'Employee List Drag&Drop Example', ESP = 'Lista empleados ejemplo Drag&Drop';
    SourceTable = 5200;
    PageType = List;
    CardPageID = "Employee Card DragDrop Example";

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies a number for the employee.', ESP = 'Especifica el n�mero del empleado.';
                    ApplicationArea = BasicHR;
                }
                field("FullName"; rec."FullName")
                {

                    CaptionML = ENU = 'Full Name', ESP = 'Nombre completo';
                    ToolTipML = ENU = 'Specifies the full name of the employee.', ESP = 'Especifica el nombre completo del empleado.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("Name"; rec."Name")
                {

                    ToolTipML = ENU = 'Specifies the employees first name.', ESP = 'Especifica el nombre del empleado.';
                    ApplicationArea = BasicHR;
                    NotBlank = true;
                }
                field("Second Family Name"; rec."Second Family Name")
                {

                    ToolTipML = ENU = 'Specifies the employees middle name.', ESP = 'Especifica el segundo nombre del empleado.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("First Family Name"; rec."First Family Name")
                {

                    ToolTipML = ENU = 'Specifies the employees last name.', ESP = 'Especifica el apellido del empleado.';
                    ApplicationArea = BasicHR;
                    NotBlank = true;
                }
                field("Initials"; rec."Initials")
                {

                    ToolTipML = ENU = 'Specifies the employees initials.', ESP = 'Especifica las iniciales del empleado.';
                    ApplicationArea = Advanced;
                    Visible = FALSE;
                }
                field("Job Title"; rec."Job Title")
                {

                    ToolTipML = ENU = 'Specifies the employees job title.', ESP = 'Especifica el cargo del empleado.';
                    ApplicationArea = BasicHR;
                }
                field("Post Code"; rec."Post Code")
                {

                    ToolTipML = ENU = 'Specifies the postal code of the address.', ESP = 'Especifica el c�digo postal de la direcci�n.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {

                    ToolTipML = ENU = 'Specifies the country/region code.', ESP = 'Especifica el c�digo de pa�s o regi�n.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("Phone No."; rec."Phone No.")
                {

                    CaptionML = ENU = 'Company Phone No.', ESP = 'N.� telf. de la empresa';
                    ToolTipML = ENU = 'Specifies the employees telephone number.', ESP = 'Especifica el n�mero de tel�fono del empleado.';
                    ApplicationArea = BasicHR;
                }
                field("Extension"; rec."Extension")
                {

                    ToolTipML = ENU = 'Specifies the employees telephone extension.', ESP = 'Especifica la extensi�n de tel�fono del empleado.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {

                    CaptionML = ENU = 'Private Phone No.', ESP = 'N.� tel�fono privado';
                    ToolTipML = ENU = 'Specifies the employees private telephone number.', ESP = 'Especifica el n�mero de tel�fono privado del empleado.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("E-Mail"; rec."E-Mail")
                {

                    CaptionML = ENU = 'Private Email', ESP = 'Correo electr�nico privado';
                    ToolTipML = ENU = 'Specifies the employees private email address.', ESP = 'Especifica la direcci�n de correo electr�nico privada del empleado.';
                    ApplicationArea = BasicHR;
                    Visible = FALSE;
                }
                field("Statistics Group Code"; rec."Statistics Group Code")
                {

                    ToolTipML = ENU = 'Specifies a statistics group code to assign to the employee for statistical purposes.', ESP = 'Especifica el c�digo de grupo estad�stico que se asignar� al empleado con fines estad�sticos.';
                    ApplicationArea = Advanced;
                    Visible = FALSE;
                }
                field("Resource No."; rec."Resource No.")
                {

                    ToolTipML = ENU = 'Specifies a resource number for the employee.', ESP = 'Especifica un n�mero de recurso para el empleado.';
                    ApplicationArea = Jobs;
                    Visible = FALSE;
                }
                field("Search Name"; rec."Search Name")
                {

                    ToolTipML = ENU = 'Specifies a search name for the employee.', ESP = 'Especifica un nombre de b�squeda para el empleado.';
                    ApplicationArea = Advanced;
                }
                field("Comment"; rec."Comment")
                {

                    ToolTipML = ENU = 'Specifies if a comment has been entered for this entry.', ESP = 'Especifica si se indic� un comentario para este movimiento.';
                    ApplicationArea = Advanced;
                }

            }

        }
        area(FactBoxes)
        {
            part("DropArea"; 7174655)
            {
                ;
            }
            part("FilesSP"; 7174656)
            {
                ;
            }
            systempart(Links; Links)
            {

                ApplicationArea = BasicHR;
                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {

                ApplicationArea = BasicHR;
                Visible = TRUE;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'E&mployee', ESP = 'E&mpleado';
                Image = Employee;
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    ToolTipML = ENU = 'View or add comments for the record.', ESP = 'Permite ver o agregar comentarios para el registro.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST("Employee"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                group("group4")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action2")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-Individual';
                        ToolTipML = ENU = 'View or edit the single set of dimensions that are set up for the selected record.', ESP = 'Permite ver o editar el grupo �nico de dimensiones configuradas para el registro seleccionado.';
                        ApplicationArea = BasicHR;
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(5200), "No." = FIELD("No.");
                        Image = Dimensions;
                    }
                    action("action3")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&M�ltiple';
                        ToolTipML = ENU = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.', ESP = 'Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar c�digos de dimensi�n a transacciones para distribuir los costes y analizar la informaci�n hist�rica.';
                        ApplicationArea = BasicHR;
                        Image = DimensionSets;

                        trigger OnAction()
                        VAR
                            Employee: Record 5200;
                            DefaultDimMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RUNMODAL;
                        END;


                    }

                }
                action("action4")
                {
                    CaptionML = ENU = '&Picture', ESP = 'Ima&gen';
                    ToolTipML = ENU = 'View or add a picture of the employee or, for example, the companys logo.', ESP = 'Permite ver o agregar una imagen del empleado o, por ejemplo, el logotipo de la empresa.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5202;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Picture;
                }
                action("AlternativeAddresses")
                {

                    CaptionML = ENU = '&Alternate Addresses', ESP = 'Direcs. &alternativas';
                    ToolTipML = ENU = 'Open the list of addresses that are registered for the employee.', ESP = 'Abre la lista de direcciones registradas para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5204;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Addresses;
                }
                action("action6")
                {
                    CaptionML = ENU = '&Relatives', ESP = 'Fami&liares';
                    ToolTipML = ENU = 'Open the list of relatives that are registered for the employee.', ESP = 'Abre la lista de familiares registrados para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5209;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Relatives;
                }
                action("action7")
                {
                    CaptionML = ENU = 'Mi&sc. Article Information', ESP = 'Rec&s. diversos info.';
                    ToolTipML = ENU = 'Open the list of miscellaneous articles that are registered for the employee.', ESP = 'Abre la lista de recursos diversos registrados para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5219;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Filed;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Co&nfidential Information', ESP = 'Info. &confidencial';
                    ToolTipML = ENU = 'Open the list of any confidential information that is registered for the employee.', ESP = 'Abre la lista de informaci�n confidencial registrada para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5221;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Lock;
                }
                action("action9")
                {
                    CaptionML = ENU = 'Q&ualifications', ESP = 'C&ualificaciones';
                    ToolTipML = ENU = 'Open the list of qualifications that are registered for the employee.', ESP = 'Abre la lista de aptitudes registradas para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5206;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Certificate;
                }
                action("action10")
                {
                    CaptionML = ENU = 'A&bsences', ESP = '&Ausencias';
                    ToolTipML = ENU = 'View absence information for the employee.', ESP = 'Permite ver informaci�n de ausencias del empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5211;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Absence;
                }
                separator("separator11")
                {

                }
                action("action12")
                {
                    CaptionML = ENU = 'Absences by Ca&tegories', ESP = 'Ausencias por ca&tegor�as';
                    ToolTipML = ENU = 'View categorized absence information for the employee.', ESP = 'Permite ver informaci�n de ausencias por categor�as del empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5226;
                    RunPageLink = "No." = FIELD("No."), "Employee No. Filter" = FIELD("No.");
                    Image = AbsenceCategory;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Misc. Articles &Overview', ESP = '&Panorama recs. diversos';
                    ToolTipML = ENU = 'View miscellaneous articles that are registered for the employee.', ESP = 'Permite ver la lista de recursos diversos registrados para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5228;
                    Image = FiledOverview;
                }
                action("action14")
                {
                    CaptionML = ENU = 'Con&fidential Info. Overview', ESP = 'Pa&nor�mica info. confidencial';
                    ToolTipML = ENU = 'View confidential information that is registered for the employee.', ESP = 'Permite ver la lista de informaci�n confidencial registrada para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5229;
                    Image = ConfidentialOverview;
                }

            }

        }
        area(Processing)
        {

            action("action15")
            {
                CaptionML = ENU = 'Absence Registration', ESP = 'Registro ausencias';
                ToolTipML = ENU = 'Register absence for the employee.', ESP = 'Registrar ausencia para el empleado.';
                ApplicationArea = BasicHR;
                RunObject = Page 5212;
                Image = Absence;
            }
            action("action16")
            {
                ShortCutKey = 'Ctrl+F7';
                CaptionML = ENU = 'Ledger E&ntries', ESP = 'Movimie&ntos';
                ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                ApplicationArea = BasicHR;
                RunObject = Page 5237;
                RunPageView = SORTING("Employee No.")
                                  ORDER(Descending);
                RunPageLink = "Employee No." = FIELD("No.");
                Image = VendorLedger;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action15_Promoted; action15)
                {
                }
                actionref(action16_Promoted; action16)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        //QUONEXT 11.05.18 - SP - JPP - DRAG&DROP. Actualizaci�n de los ficheros.
        CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::Employee);
        ///FIN QUONEXT 11.05.18
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //QUONEXT 11.05.18 - SP - JPP - DRAG&DROP Set de registros
        CurrPage.DropArea.PAGE.SetFilter(Rec);
        CurrPage.FilesSP.PAGE.SetFilter(Rec);
        ///FIN QUONEXT 11.05.18
    END;


    /*

        begin
        {
          QUONEXT 11.05.18 SP - JPP - DRAG&DROP. Ejemplo del procedimiento para integrar complemento Drag&Drop en Empleados.
                           Dos nuevos factbox en la p�gina "Drop Area" y "FilesSP"
                           Dos nuevas llamadas a esos factbox en el m�todo OnAfterGetCurrRecord
        }
        end.*/


}








