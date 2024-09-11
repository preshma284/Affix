page 7207659 "Job Changes Log"
{
    CaptionML = ENU = 'Job Changes Log', ESP = 'Registro de cambios del proyecto';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207445;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                CaptionML = ESP = 'Presupuesto';
                field("Reg No."; rec."Reg No.")
                {

                    Visible = False;
                }
                field("Job"; rec."Job")
                {

                }
                field("Version"; rec."Version")
                {

                }
                field("Date"; rec."Date")
                {

                }
                field("User"; rec."User")
                {

                }
                field("Operation Code"; rec."Operation Code")
                {

                    Visible = False;
                }
                field("Description"; rec."Description")
                {

                }
                field("Parameter 1"; rec."Parameter 1")
                {

                    Visible = False;
                }
                field("Parameter 2"; rec."Parameter 2")
                {

                    Visible = False;
                }
                field("Parameter 3"; rec."Parameter 3")
                {

                    Visible = False;
                }
                field("Parameter 4"; rec."Parameter 4")
                {

                    Visible = False;
                }
                field("Parameter 5"; rec."Parameter 5")
                {

                    Visible = False

  ;
                }

            }

        }
    }


    /*begin
    end.
  
*/
}







