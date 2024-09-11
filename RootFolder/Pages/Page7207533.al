page 7207533 "List Unit Production"
{
    CaptionML = ENU = 'List Unit Production', ESP = 'Lista unid. producci�n';
    SourceTable = 7207386;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Budget Measure"; rec."Budget Measure")
                {

                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                }
                field("Record Type"; rec."Record Type")
                {

                }
                field("% Processed Production"; rec."% Processed Production")
                {

                }

            }

        }
    }


    /*begin
    end.
  
*/
}







