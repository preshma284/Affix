page 7207444 "Journal Template (Element)"
{
    CaptionML = ENU = '"Journal Template (Element) "', ESP = 'Libros del diario (elemento)';
    SourceTable = 7207349;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Name"; rec."Name")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Test Report ID"; rec."Test Report ID")
                {

                }
                field("Page ID"; rec."Page ID")
                {

                }
                field("Posting Report ID"; rec."Posting Report ID")
                {

                }
                field("Force Posting Report"; rec."Force Posting Report")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Recurring"; rec.Recurring)
                {

                }
                field("Test Report Name"; rec."Test Report Name")
                {

                }
                field("Page Name"; rec."Page Name")
                {

                }
                field("Posting Report Name"; rec."Posting Report Name")
                {

                }
                field("Series No."; rec."Series No.")
                {

                }
                field("Posting No. series"; rec."Posting No. series")
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
                CaptionML = ENU = 'Te&mplate', ESP = '&Libro';
                action("action1")
                {
                    CaptionML = ENU = 'Batches', ESP = 'Secciones';
                    RunObject = Page 7207442;
                    RunPageLink = "Journal Template Name" = FIELD("Name");
                    Image = SelectEntries;
                }

            }

        }
        area(Creation)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }


    /*begin
    end.
  
*/
}







