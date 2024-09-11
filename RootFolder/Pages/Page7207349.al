page 7207349 "Budget Forecast Mov. CA"
{
    CaptionML = ENU = 'Budget Forecast Mov. CA', ESP = 'Mov. previsi�n ppto. CA';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207319;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Document No."; rec."Document No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Reestimation code"; rec."Reestimation code")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Entry No."; rec."Entry No.")
                {

                }
                field("Forecast Date"; rec."Forecast Date")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Outstanding Temporary Forecast"; rec."Outstanding Temporary Forecast")
                {

                }

            }

        }
    }


    /*begin
    end.
  
*/
}







