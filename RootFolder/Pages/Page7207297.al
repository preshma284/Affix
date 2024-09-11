page 7207297 "Allocation Term - Day List"
{
    CaptionML = ENU = 'Allocation Term - Day List', ESP = 'Lista per. imputaci�n-Dias';
    SourceTable = 7207295;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Allocation Term"; rec."Allocation Term")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Day"; rec."Day")
                {

                }
                field("WeeekDay"; "WeeekDay")
                {

                    CaptionML = ESP = 'D�a semana';
                    Editable = false;
                }
                field("Workday"; rec."Workday")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Holiday"; rec."Holiday")
                {

                }
                field("Long Weekend"; rec."Long Weekend")
                {

                }
                field("Calendar"; rec."Calendar")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Hours to work"; rec."Hours to work")
                {

                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        WeeekDay := DATE2DWY(rec.Day, 1) - 1;
    END;



    var
        WeeekDay: Option "Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo";

    /*begin
    end.
  
*/
}







