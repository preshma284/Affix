page 7174676 "Employee Card DragDrop Example"
{
    CaptionML = ENU = 'Employee Card Drag&Drop Example', ESP = 'Ficha empleado ejemplo Drag&Drop';
    SourceTable = 5200;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group19")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    ToolTipML = ENU = 'Specifies a number for the employee.', ESP = 'Especifica el n�mero del empleado.';
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = NoFieldVisible;

                    ; trigger OnAssistEdit()
                    BEGIN
                        rec.AssistEdit;
                    END;


                }
                field("Name"; rec."Name")
                {

                    ToolTipML = ENU = 'Specifies the employees first name.', ESP = 'Especifica el nombre del empleado.';
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ShowMandatory = TRUE;
                }
                field("First Family Name"; rec."First Family Name")
                {

                    ToolTipML = ENU = 'Specifies the employees last name.', ESP = 'Especifica el apellido del empleado.';
                    ApplicationArea = BasicHR;
                    ShowMandatory = TRUE;
                }
                field("Second Family Name"; rec."Second Family Name")
                {

                    ToolTipML = ENU = 'Specifies the second part of the family name.', ESP = 'Especifica la segunda parte del nombre de familia.';
                }
                field("Initials"; rec."Initials")
                {

                    ToolTipML = ENU = 'Specifies the employees initials.', ESP = 'Especifica las iniciales del empleado.';
                }
                field("Job Title"; rec."Job Title")
                {

                    ToolTipML = ENU = 'Specifies the employees job title.', ESP = 'Especifica el cargo del empleado.';
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                }
                field("Search Name"; rec."Search Name")
                {

                    ToolTipML = ENU = 'Specifies a search name for the employee.', ESP = 'Especifica un nombre de b�squeda para el empleado.';
                    ApplicationArea = Advanced;
                }
                field("Gender"; rec."Gender")
                {

                    ToolTipML = ENU = 'Specifies the employees gender.', ESP = 'Especifica el g�nero del empleado.';
                    ApplicationArea = Advanced;
                }
                field("Phone No.2"; rec."Phone No.")
                {

                    CaptionML = ENU = 'Company Phone No.', ESP = 'N.� telf. de la empresa';
                    ToolTipML = ENU = 'Specifies the employees telephone number.', ESP = 'Especifica el n�mero de tel�fono del empleado.';
                    ApplicationArea = BasicHR;
                }
                field("Company E-Mail"; rec."Company E-Mail")
                {

                    ExtendedDatatype = EMail;
                    ToolTipML = ENU = 'Specifies the employees email address at the company.', ESP = 'Especifica la direcci�n de correo electr�nico del empleado en la empresa.';
                    ApplicationArea = BasicHR;
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {

                    ToolTipML = ENU = 'Specifies when this record was last modified.', ESP = 'Especifica cu�ndo se modific� este registro por �ltima vez.';
                    ApplicationArea = BasicHR;
                    Importance = Additional;
                }

            }
            group("group31")
            {

                CaptionML = ENU = 'Address & Contact', ESP = 'Direcci�n y contacto';
                group("group32")
                {

                    field("Address"; rec."Address")
                    {

                        ToolTipML = ENU = 'Specifies the employees address.', ESP = 'Especifica la direcci�n del empleado.';
                        ApplicationArea = BasicHR;
                    }
                    field("Address 2"; rec."Address 2")
                    {

                        ToolTipML = ENU = 'Specifies additional address information.', ESP = 'Especifica informaci�n adicional de la direcci�n.';
                        ApplicationArea = BasicHR;
                    }
                    field("Post Code"; rec."Post Code")
                    {

                        ToolTipML = ENU = 'Specifies the postal code of the address.', ESP = 'Especifica el c�digo postal de la direcci�n.';
                        ApplicationArea = BasicHR;
                    }
                    field("City"; rec."City")
                    {

                        ToolTipML = ENU = 'Specifies the city of the address.', ESP = 'Especifica la poblaci�n de la direcci�n.';
                        ApplicationArea = BasicHR;
                    }
                    field("County"; rec."County")
                    {

                        ToolTipML = ENU = 'Specifies the county of the address.', ESP = 'Especifica la provincia de la direcci�n.';
                    }
                    field("Country/Region Code"; rec."Country/Region Code")
                    {

                        ToolTipML = ENU = 'Specifies the country/region code.', ESP = 'Especifica el c�digo de pa�s o regi�n.';
                        ApplicationArea = BasicHR;
                    }
                    field("ShowMap"; ShowMapLbl)
                    {

                        ToolTipML = ENU = 'Specifies the employees address on your preferred online map.', ESP = 'Especifica la direcci�n del empleado en su mapa en l�nea favorito.';
                        ApplicationArea = BasicHR;
                        Editable = FALSE;
                        Style = StrongAccent;
                        StyleExpr = TRUE;


                        ShowCaption = false;
                        trigger OnDrillDown()
                        BEGIN
                            CurrPage.UPDATE(TRUE);
                            rec.DisplayMap;
                        END;


                    }

                }
                group("group40")
                {

                    field("Mobile Phone No."; rec."Mobile Phone No.")
                    {

                        CaptionML = ENU = 'Private Phone No.', ESP = 'N.� tel�fono privado';
                        ToolTipML = ENU = 'Specifies the employees private telephone number.', ESP = 'Especifica el n�mero de tel�fono privado del empleado.';
                        ApplicationArea = BasicHR;
                        Importance = Promoted;
                    }
                    field("Pager"; rec."Pager")
                    {

                        ToolTipML = ENU = 'Specifies the employees pager number.', ESP = 'Especifica el n�mero de buscapersonas del empleado.';
                        ApplicationArea = Advanced;
                    }
                    field("Extension"; rec."Extension")
                    {

                        ToolTipML = ENU = 'Specifies the employees telephone extension.', ESP = 'Especifica la extensi�n de tel�fono del empleado.';
                        ApplicationArea = BasicHR;
                        Importance = Promoted;
                    }
                    field("E-Mail"; rec."E-Mail")
                    {

                        CaptionML = ENU = 'Private Email', ESP = 'Correo electr�nico privado';
                        ToolTipML = ENU = 'Specifies the employees private email address.', ESP = 'Especifica la direcci�n de correo electr�nico privada del empleado.';
                        ApplicationArea = BasicHR;
                        Importance = Promoted;
                    }
                    field("Alt. Address Code"; rec."Alt. Address Code")
                    {

                        ToolTipML = ENU = 'Specifies a code for an alternate address.', ESP = 'Especifica un c�digo de una direcci�n alternativa.';
                        ApplicationArea = Advanced;
                    }
                    field("Alt. Address Start Date"; rec."Alt. Address Start Date")
                    {

                        ToolTipML = ENU = 'Specifies the starting date when the alternate address is valid.', ESP = 'Especifica la fecha de inicio a partir de la cual es v�lida la direcci�n alternativa.';
                        ApplicationArea = Advanced;
                    }
                    field("Alt. Address End Date"; rec."Alt. Address End Date")
                    {

                        ToolTipML = ENU = 'Specifies the last day when the alternate address is valid.', ESP = 'Especifica el �ltimo d�a hasta el que es v�lida la direcci�n alternativa.';
                        ApplicationArea = Advanced;
                    }

                }

            }
            group("group48")
            {

                CaptionML = ENU = 'Administration', ESP = 'Administraci�n';
                field("Employment Date"; rec."Employment Date")
                {

                    ToolTipML = ENU = 'Specifies the date when the employee began to work for the company.', ESP = 'Especifica la fecha en la que el empleado empez� a trabajar para la empresa.';
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                }
                field("Status"; rec."Status")
                {

                    ToolTipML = ENU = 'Specifies the employment status of the employee.', ESP = 'Especifica la situaci�n laboral del empleado.';
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                }
                field("Inactive Date"; rec."Inactive Date")
                {

                    ToolTipML = ENU = 'Specifies the date when the employee became inactive, due to disability or maternity leave, for example.', ESP = '"Especifica la fecha en la que el empleado qued� inactivo. por ejemplo, debido a una discapacidad o licencia por maternidad."';
                    ApplicationArea = Advanced;
                }
                field("Cause of Inactivity Code"; rec."Cause of Inactivity Code")
                {

                    ToolTipML = ENU = 'Specifies a code for the cause of inactivity by the employee.', ESP = 'Especifica un c�digo para la causa de inactividad del empleado.';
                    ApplicationArea = Advanced;
                }
                field("Termination Date"; rec."Termination Date")
                {

                    ToolTipML = ENU = 'Specifies the date when the employee was terminated, due to retirement or dismissal, for example.', ESP = '"Especifica la fecha en la que el empleado ces� su actividad. por ejemplo, por jubilaci�n o despido."';
                    ApplicationArea = BasicHR;
                }
                field("Grounds for Term. Code"; rec."Grounds for Term. Code")
                {

                    ToolTipML = ENU = 'Specifies a termination code for the employee who has been terminated.', ESP = 'Especifica un c�digo de terminaci�n para el empleado que ces� su actividad.';
                    ApplicationArea = Advanced;
                }
                field("Emplymt. Contract Code"; rec."Emplymt. Contract Code")
                {

                    ToolTipML = ENU = 'Specifies the employment contract code for the employee.', ESP = 'Especifica el c�digo del contrato laboral del empleado.';
                    ApplicationArea = Advanced;
                }
                field("Statistics Group Code"; rec."Statistics Group Code")
                {

                    ToolTipML = ENU = 'Specifies a statistics group code to assign to the employee for statistical purposes.', ESP = 'Especifica el c�digo de grupo estad�stico que se asignar� al empleado con fines estad�sticos.';
                    ApplicationArea = Advanced;
                }
                field("Resource No."; rec."Resource No.")
                {

                    ToolTipML = ENU = 'Specifies a resource number for the employee.', ESP = 'Especifica un n�mero de recurso para el empleado.';
                    ApplicationArea = BasicHR;
                }
                field("Salespers./Purch. Code"; rec."Salespers./Purch. Code")
                {

                    ToolTipML = ENU = 'Specifies a salesperson or purchaser code for the employee.', ESP = 'Especifica un c�digo de vendedor o comprador para el empleado.';
                    ApplicationArea = Advanced;
                }

            }
            group("group59")
            {

                CaptionML = ENU = 'Personal', ESP = 'Personal';
                field("Birth Date"; rec."Birth Date")
                {

                    ToolTipML = ENU = 'Specifies the employees date of birth.', ESP = 'Especifica la fecha de nacimiento del empleado.';
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                }
                field("Social Security No."; rec."Social Security No.")
                {

                    ToolTipML = ENU = 'Specifies the social security number of the employee.', ESP = 'Especifica el n�mero de seguridad social del empleado.';
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                }
                field("Union Code"; rec."Union Code")
                {

                    ToolTipML = ENU = 'Specifies the employees labor union membership code.', ESP = 'Especifica el c�digo de afiliado al sindicato del empleado.';
                    ApplicationArea = Advanced;
                }
                field("Union Membership No."; rec."Union Membership No.")
                {

                    ToolTipML = ENU = 'Specifies the employees labor union membership number.', ESP = 'Especifica el n�mero de afiliado al sindicato del empleado.';
                    ApplicationArea = Advanced;
                }

            }
            group("group64")
            {

                CaptionML = ENU = 'Payments', ESP = 'Pagos';
                field("Employee Posting Group"; rec."Employee Posting Group")
                {

                    ToolTipML = ENU = 'Specifies the employees type to link business transactions made for the employee with the appropriate account in the general ledger.', ESP = 'Especifica el tipo de empleado para vincular las transacciones empresariales realizadas para el empleado con la cuenta correspondiente en la contabilidad general.';
                    ApplicationArea = BasicHR;
                    LookupPageID = "Employee Posting Groups";
                }
                field("Application Method"; rec."Application Method")
                {

                    ToolTipML = ENU = 'Specifies how to apply payments to entries for this employee.', ESP = 'Especifica c�mo liquidar pagos en los movimientos para este empleado.';
                    ApplicationArea = BasicHR;
                }
                field("Bank Branch No."; rec."Bank Branch No.")
                {

                    ToolTipML = ENU = 'Specifies a number of the bank branch.', ESP = 'Especifica el n�mero de la sucursal del banco.';
                    ApplicationArea = BasicHR;
                }
                field("Bank Account No."; rec."Bank Account No.")
                {

                    ToolTipML = ENU = 'Specifies the number used by the bank for the bank account.', ESP = 'Especifica el n�mero que usa el banco para la cuenta bancaria.';
                    ApplicationArea = BasicHR;
                }
                field("IBAN"; rec."IBAN")
                {

                    ToolTipML = ENU = 'Specifies the bank accounts international bank account number.', ESP = 'Especifica el n�mero de cuenta internacional de la cuenta bancaria.';
                    ApplicationArea = BasicHR;
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
            part("part3"; 5202)
            {

                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {

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
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    ToolTipML = ENU = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.', ESP = 'Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(5200), "No." = FIELD("No.");
                    Image = Dimensions;
                }
                action("action3")
                {
                    CaptionML = ENU = '&Picture', ESP = '&Imagen';
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
                action("action5")
                {
                    CaptionML = ENU = '&Relatives', ESP = 'Fa&miliares';
                    ToolTipML = ENU = 'Open the list of relatives that are registered for the employee.', ESP = 'Abre la lista de familiares registrados para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5209;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Relatives;
                }
                action("action6")
                {
                    CaptionML = ENU = 'Mi&sc. Article Information', ESP = 'Rec&s. diversos info.';
                    ToolTipML = ENU = 'Open the list of miscellaneous articles that are registered for the employee.', ESP = 'Abre la lista de recursos diversos registrados para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5219;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Filed;
                }
                action("action7")
                {
                    CaptionML = ENU = '&Confidential Information', ESP = 'Informaci�n &confidencial';
                    ToolTipML = ENU = 'Open the list of any confidential information that is registered for the employee.', ESP = 'Abre la lista de informaci�n confidencial registrada para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5221;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Lock;
                }
                action("action8")
                {
                    CaptionML = ENU = 'Q&ualifications', ESP = 'C&ualificaciones';
                    ToolTipML = ENU = 'Open the list of qualifications that are registered for the employee.', ESP = 'Abre la lista de aptitudes registradas para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5206;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Certificate;
                }
                action("action9")
                {
                    CaptionML = ENU = 'A&bsences', ESP = '&Ausencias';
                    ToolTipML = ENU = 'View absence information for the employee.', ESP = 'Permite ver informaci�n de ausencias del empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5211;
                    RunPageLink = "Employee No." = FIELD("No.");
                    Image = Absence;
                }
                separator("separator10")
                {

                }
                action("action11")
                {
                    CaptionML = ENU = 'Absences by Ca&tegories', ESP = 'Ausencias por ca&tegor�as';
                    ToolTipML = ENU = 'View categorized absence information for the employee.', ESP = 'Permite ver informaci�n de ausencias por categor�as del empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5226;
                    RunPageLink = "No." = FIELD("No."), "Employee No. Filter" = FIELD("No.");
                    Image = AbsenceCategory;
                }
                action("action12")
                {
                    CaptionML = ENU = 'Misc. Articles &Overview', ESP = '&Panorama recs. diversos';
                    ToolTipML = ENU = 'View miscellaneous articles that are registered for the employee.', ESP = 'Permite ver la lista de recursos diversos registrados para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5228;
                    Image = FiledOverview;
                }
                action("action13")
                {
                    CaptionML = ENU = 'Co&nfidential Info. Overview', ESP = 'Pa&norama info. confidencial';
                    ToolTipML = ENU = 'View confidential information that is registered for the employee.', ESP = 'Permite ver la lista de informaci�n confidencial registrada para el empleado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5229;
                    Image = ConfidentialOverview;
                }
                separator("separator14")
                {

                }
                action("action15")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = 'Movimie&ntos';
                    ToolTipML = ENU = 'View the history of transactions that have been posted for the selected record.', ESP = 'Permite ver el historial de transacciones que se han registrado para el registro seleccionado.';
                    ApplicationArea = BasicHR;
                    RunObject = Page 5237;
                    RunPageView = SORTING("Employee No.")
                                  ORDER(Descending);
                    RunPageLink = "Employee No." = FIELD("No.");
                    Promoted = true;
                    Image = VendorLedger;
                    PromotedCategory = Process
    ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        SetNoFieldVisible;

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



    var
        ShowMapLbl: TextConst ENU = 'Show on Map', ESP = 'Mostrar en el mapa';
        NoFieldVisible: Boolean;

    LOCAL procedure SetNoFieldVisible();
    var
        DocumentNoVisibility: Codeunit 1400;
    begin
        NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible;
    end;

    // begin
    /*{
      QUONEXT 11.05.18 SP - JPP - DRAG&DROP. Ejemplo del procedimiento para integrar complemento Drag&Drop en Empleados.
                       Dos nuevos factbox en la p�gina "Drop Area" y "FilesSP"
                       Dos nuevas llamadas a esos factbox en el m�todo OnAfterGetCurrRecord
    }*///end
}








