page 7207422 "Usage Header Hist. List"
{
    Editable = false;
    CaptionML = ENU = '"Usage Header Hist." List', ESP = 'Lista hist. Cab. utilizacion';
    SourceTable = 7207365;
    PageType = List;
    CardPageID = "Usage Header Hist.";
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Contract Code"; rec."Contract Code")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                }
                field("Job No."; rec."Job No.")
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
                field("No. Series"; rec."No. Series")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Vendor Contract Code"; rec."Vendor Contract Code")
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
                CaptionML = ENU = '&Document', ESP = '&Documento';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207422;
                    RunPageLink = "No." = FIELD("No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207424;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207419;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action4")
            {
                CaptionML = ENU = 'Navigate', ESP = 'Navegar';
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
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }


    /*begin
    end.
  
*/
}







