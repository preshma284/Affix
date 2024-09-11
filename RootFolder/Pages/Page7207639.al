page 7207639 "Vendor by Activitys List"
{
    Editable = false;
    CaptionML = ENU = 'Vendor Data List', ESP = 'Lista datos proveedor';
    InsertAllowed = false;
    SourceTable = 7207418;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("GetNameVendor(rec.Vendor No.)"; rec.GetNameVendor(rec."Vendor No."))
                {

                    CaptionML = ENU = 'Name', ESP = 'Nombre';
                }
                field("GetCityVendor(rec.Vendor No.)"; rec.GetCityVendor(rec."Vendor No."))
                {

                    CaptionML = ENU = 'City', ESP = 'Poblaci�n';
                }
                field("GetPhoneVendor(rec.Vendor No.)"; rec.GetPhoneVendor(rec."Vendor No."))
                {

                    CaptionML = ENU = 'Phone No.', ESP = 'Tel�fono';
                }
                field("Activity Code"; rec."Activity Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ActivityQB.GET(rec."Activity Code");
                        ActivityDescription := ActivityQB.Description;
                    END;


                }
                field("GetDescriptionActivityHP(rec.Activity Code)"; rec.GetDescriptionActivityHP(rec."Activity Code"))
                {

                    CaptionML = ENU = 'Description', ESP = 'Descripci�n';
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Vendor', ESP = 'Proveedor';
                action("Page Vendor Card")
                {

                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Vendor Card', ESP = 'Ficha proveedor';
                    RunObject = Page 26;
                    RunPageLink = "No." = FIELD("Vendor No.");
                    Image = Vendor;
                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref("Page Vendor Card_Promoted"; "Page Vendor Card")
                {
                }
            }
        }
    }

    var
        ActivityQB: Record 7207280;
        ActivityDescription: Text[30];

    /*begin
    end.
  
*/
}







