page 7207564 "Vendor Certificates Hist. List"
{
    CaptionML = ENU = 'Vendor Certificates Hist. List', ESP = 'Hist�rico de Certificados del proveedor';
    SourceTable = 7207426;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Vendor No."; rec."Vendor No.")
                {

                    Visible = FALSE;
                }
                field("Certificate Line No."; rec."Certificate Line No.")
                {

                    Visible = false;
                }
                field("Line No."; rec."Line No.")
                {

                    Visible = false;
                }
                field("Reception date"; rec."Reception date")
                {

                }
                field("Start Date"; rec."Start Date")
                {

                }
                field("Validity Period"; rec."Validity Period")
                {

                }
                field("End Date"; rec."End Date")
                {

                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }


    /*begin
    end.
  
*/
}







