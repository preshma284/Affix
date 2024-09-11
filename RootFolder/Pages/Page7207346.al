page 7207346 "Hist. Reestimation hdr. List"
{
    Editable = false;
    CaptionML = ENU = 'Hist. Reestimation hdr. List', ESP = 'Lista hist. cab. reestimaci�n';
    SourceTable = 7207317;
    PageType = List;
    CardPageID = "Post. Reestimation header";

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Style = StandardAccent;
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
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Posting Description"; rec."Posting Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }
                field("Comment"; rec."Comment")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Pre-Assigned No. Series"; rec."Pre-Assigned No. Series")
                {

                }
                field("No. Series"; rec."No. Series")
                {

                }
                field("Reestimation code"; rec."Reestimation code")
                {

                }
                field("Reestimation date"; rec."Reestimation date")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207492)
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
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Document', ESP = '&Documento';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207348;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action3")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;


                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
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







