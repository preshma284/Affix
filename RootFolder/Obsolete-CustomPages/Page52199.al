page 52199 "Customer Template List"
{
    Editable = false;
    CaptionML = ENU = 'Customer Templates', ESP = 'Plantillas de cliente';
    ApplicationArea = RelationshipMgmt;
    SourceTable = 1381;
    PageType = List;
    UsageCategory = Administration;
    CardPageID = "Customer Template Card";
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Code"; rec."Code")
                {

                    ToolTipML = ENU = 'Specifies the code for the customer template. You can set up as many codes as you want. The code must be unique. You cannot have the same code twice in one table.', ESP = 'Especifica el c�digo de la plantilla de cliente. Puede configurar tantos c�digos como desee. El c�digo debe ser exclusivo y recuerde que no puede tener el mismo c�digo dos veces en la misma tabla.';
                    ApplicationArea = All;
                }
                field("Description"; rec."Description")
                {

                    ToolTipML = ENU = 'Specifies the description of the customer template.', ESP = 'Especifica la descripci�n del grupo de plantillas de cliente.';
                    ApplicationArea = All;
                }
                field("Contact Type"; rec."Contact Type")
                {

                    ToolTipML = ENU = 'Specifies the contact type of the customer template.', ESP = 'Especifica el tipo de contacto de la plantilla del cliente.';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {

                    ToolTipML = ENU = 'Specifies the country/region of the address.', ESP = 'Especifica el pa�s o la regi�n de la direcci�n.';
                    ApplicationArea = RelationshipMgmt;
                }
                field("Territory Code"; rec."Territory Code")
                {

                    ToolTipML = ENU = 'Specifies the territory code for the customer template.', ESP = 'Especifica el c�digo de territorio de la plantilla de cliente.';
                    ApplicationArea = RelationshipMgmt;
                }
                field("Currency Code"; rec."Currency Code")
                {

                    ToolTipML = ENU = 'Specifies the currency code for the customer template.', ESP = 'Especifica el c�digo de divisa de la plantilla de cliente.';
                    ApplicationArea = Suite;
                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {

                Visible = FALSE;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Customer Template', ESP = '&Plantilla cliente';
                Image = Template;
                group("group3")
                {
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;
                    action("action1")
                    {
                        ShortCutKey = 'Shift+Ctrl+D';
                        CaptionML = ENU = 'Dimensions-Single', ESP = 'Dimensiones-Individual';
                        ToolTipML = ENU = 'View or edit the single set of dimensions that are set up for the selected record.', ESP = 'Permite ver o editar el grupo �nico de dimensiones configuradas para el registro seleccionado.';
                        ApplicationArea = Dimensions;
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(5105), "No." = FIELD("Code");
                        Image = Dimensions;
                    }
                    action("action2")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple', ESP = 'Dimensiones-&M�ltiple';
                        ToolTipML = ENU = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.', ESP = 'Permite ver o editar dimensiones para un grupo de registros. Se pueden asignar c�digos de dimensi�n a transacciones para distribuir los costes y analizar la informaci�n hist�rica.';
                        ApplicationArea = Dimensions;
                        Image = DimensionSets;


                        trigger OnAction()
                        VAR
                            // CustTemplate: Record 1381;
                            CustTemplate: Record "Customer Templ.";
                            DefaultDimMultiple: Page 542;
                        BEGIN
                            CurrPage.SETSELECTIONFILTER(CustTemplate);
                            DefaultDimMultiple.SetMultiCustTemplate(CustTemplate);
                            DefaultDimMultiple.RUNMODAL;
                        END;


                    }

                }

            }

        }
    }


    /*begin
    end.
  
*/
}







