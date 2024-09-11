page 7207338 "Vendor Data List"
{
  ApplicationArea=All;

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
                field("Vendor.Name"; Vendor.Name)
                {

                    CaptionML = ESP = 'Nombre';
                }
                field("Vendor.Phone No."; Vendor."Phone No.")
                {

                    CaptionML = ESP = 'Tel�fono';
                }
                field("Vendor.City"; Vendor.City)
                {

                    CaptionML = ESP = 'Poblaci�n';
                }
                field("Vendor.County"; Vendor.County)
                {

                    CaptionML = ESP = 'Provincia';
                }
                field("Main Activity"; rec."Main Activity")
                {

                }
                field("Activity Code"; rec."Activity Code")
                {

                }
                field("Activity Description"; rec."Activity Description")
                {

                }
                field("Area Activity"; rec."Area Activity")
                {

                }
                field("Comparative Blocked"; rec."Comparative Blocked")
                {

                }
                field("Comment"; rec."Comment")
                {

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
                    Image = EditLines
    ;
                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF NOT Vendor.GET(rec."Vendor No.") THEN
            Vendor.INIT;
    END;



    var
        Vendor: Record 23;/*

    begin
    {
      PGM 19/07/19: - GAP003 A�adido el campo rec."Main Activity"
      JAV 30/10/19: - Se a�aden columnas de datos del proveedor
    }
    end.*/


}








