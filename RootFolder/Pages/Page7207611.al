page 7207611 "Job Receptions List"
{
    CaptionML = ENU = 'Job Receptions List', ESP = 'Lista recepciones proyecto';
    SourceTable = 7207410;
    SourceTableView = SORTING("Job No.", "Posted")
                    WHERE("Posted" = FILTER(false));
    PageType = List;
    CardPageID = "Job Reception Header";
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                Editable = False;
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
                field("Vendor No."; rec."Vendor No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Vendor Shipment No."; rec."Vendor Shipment No.")
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
                        IF NOT rec.Posted THEN
                            PAGE.RUN(PAGE::"Job Reception Header", Rec)
                        ELSE
                            PAGE.RUN(PAGE::"Posted Header Recep. Job", Rec);
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







