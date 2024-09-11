page 7207298 "Type Calendar List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Calendar List', ESP = 'Lista de Calendarios';
    SourceTable = 7207296;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Code"; rec."Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Allocation Term Generate")
            {

                CaptionML = ENU = 'Allocation Term Generate', ESP = 'Generar periodo de imputaci�n';
                Image = CalculateRegenerativePlan;

                trigger OnAction()
                BEGIN
                    CurrPage.SETSELECTIONFILTER(TypeCalendar);
                    // REPORT.RUNMODAL(REPORT::"Allocation Term Calend Gen.", TRUE, TRUE, TypeCalendar);
                END;


            }
            action("Allocation Term")
            {

                CaptionML = ENU = 'Allocation Term', ESP = 'Periodos de imputaci�n';
                Image = ItemTracing;
                RunPageMode = Create;


                trigger OnAction()
                BEGIN
                    Hourstoperform.RESET;
                    Hourstoperform.FILTERGROUP(2);
                    Hourstoperform.SETRANGE(Calendar, rec.Code);
                    Hourstoperform.FILTERGROUP(0);
                    PAGE.RUNMODAL(PAGE::"Hours to perform List", Hourstoperform);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Allocation Term Generate_Promoted"; "Allocation Term Generate")
                {
                }
                actionref("Allocation Term_Promoted"; "Allocation Term")
                {
                }
            }
        }
    }

    var
        TypeCalendar: Record 7207296;
        Hourstoperform: Record 7207298;

    /*begin
    end.
  
*/
}








