page 7207342 "Other Vendor Conditions List"
{
    CaptionML = ENU = 'Other Vendor Conditions List', ESP = 'Otras condiciones del proveedor';
    SourceTable = 7207421;
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Code"; rec."Code")
                {

                }
                field("Description"; rec.Description)
                {

                }
                field("Amount"; rec."Amount")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }

            }
            group("group32")
            {

                field("Sum"; rec."Sum")
                {

                }

            }

        }
    }


    /*begin
    end.
  
*/
}







