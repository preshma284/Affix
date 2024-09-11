page 7207437 "Rough COPY Contract Elemen Lis"
{
    Editable = false;
    CaptionML = ENU = 'Rough COPY Contract Elemen List', ESP = 'Lista borrador contrato elemen';
    SourceTable = 7207353;
    DataCaptionFields = "Document Status";
    PageType = List;
    CardPageID = "Element Contract Header";
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Customer/Vendor No."; rec."Customer/Vendor No.")
                {

                    Style = StandardAccent;
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
                field("Document Status"; rec."Document Status")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Description 2"; rec."Description 2")
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
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    Image = EditLines;

                    trigger OnAction()
                    BEGIN
                        PAGE.RUN(PAGE::"Element Contract Header", Rec);
                    END;


                }

            }

        }
        area(Processing)
        {


        }
    }


    /*begin
    end.
  
*/
}







