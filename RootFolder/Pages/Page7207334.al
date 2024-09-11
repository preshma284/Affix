page 7207334 "Reestimation List"
{
    CaptionML = ENU = 'Reestimation Lines', ESP = 'Lista reestimaci�n';
    SourceTable = 7207315;
    DataCaptionFields = "Job No.";
    PageType = List;
    CardPageID = "Reestimation Header";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("table")
            {

                Editable = FALSE;
                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Reestimation Code"; rec."Reestimation Code")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Reestimation Date"; rec."Reestimation Date")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("Reestimation statistic FB"; 7207493)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.ResponsibilityFilters(Rec);
    END;




    /*begin
    end.
  
*/
}







