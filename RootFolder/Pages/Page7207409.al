page 7207409 "Activation Header Hist. List"
{
    Editable = false;
    CaptionML = ENU = 'Activation Header Hist. List', ESP = 'Lista hist. Cab. activaci�n';
    SourceTable = 7207370;
    PageType = List;
    //Missing in QUO Db
    // CardPageID = 7000258;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Element Code"; rec."Element Code")
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
                field("Pre-Assigned Serial No."; rec."Pre-Assigned Serial No.")
                {

                }
                field("Serial No."; rec."Serial No.")
                {

                }
                field("Date Filter"; rec."Date Filter")
                {

                }
                field("Variant"; rec."Variant")
                {

                }
                field("Item"; rec."Item")
                {

                }
                field("Dimension Set ID"; rec."Dimension Set ID")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Source Code"; rec."Source Code")
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
                    RunObject = Page 7207409;
                    RunPageLink = "No." = FIELD("No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207411;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207407;
                    RunPageLink = "No." = FIELD("No.");
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action4")
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







