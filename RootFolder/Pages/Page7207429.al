page 7207429 "Hist. Head. Deliv Element List"
{
    Editable = false;
    CaptionML = ENU = 'Hist. Head. Deliv Element List', ESP = 'Lista hist. cab. dev eleme';
    SourceTable = 7207359;
    SourceTableView = WHERE("Document Type" = CONST("Return"));
    PageType = List;
    CardPageID = "Hist. Head. Return Elem";
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

                    Style = Standard;
                    StyleExpr = TRUE;
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
                field("Elements Quantity"; rec."Elements Quantity")
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
                // ActionContainerType =NewDocumentItems ;
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        IF rec."Document Type" = rec."Document Type"::Delivery THEN BEGIN
                            HistHeadDeliveryElem.GETRECORD(Rec);
                            HistHeadDeliveryElem.RUNMODAL;
                            CLEAR(HistHeadDeliveryElem);
                        END ELSE BEGIN
                            HistHeadReturnElem.GETRECORD(Rec);
                            HistHeadReturnElem.RUNMODAL;
                            CLEAR(HistHeadReturnElem);
                        END;
                    END;


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
        area(Creation)
        {

            action("action4")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;
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

    var
        HistHeadDeliveryElem: Page 7207431;
        HistHeadReturnElem: Page 7207415;

    /*begin
    end.
  
*/
}







