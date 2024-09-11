page 7207461 "Hist. Head. Delivery Element L"
{
    Editable = false;
    CaptionML = ENU = 'Hist. Head. Delivery Element List', ESP = 'Lista hist. cab. entrada eleme';
    SourceTable = 7207359;
    SourceTableView = WHERE("Document Type" = CONST("Delivery"));
    PageType = List;
    CardPageID = "Hist. Head Delivery Elem";
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
                field("Pre-Assigned No. Series"; rec."Pre-Assigned No. Series")
                {

                }
                field("Series No."; rec."Series No.")
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
                CaptionML = ENU = '&Documents', ESP = '&Documento';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207461;
                    RunPageLink = "No." = FIELD("No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    RunObject = Page 7207427;
                    RunPageLink = "No." = FIELD("No.");
                    Image = Statistics;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207432;
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







