page 7207612 "Posted Header Recep. Job"
{
    CaptionML = ENU = 'Posted Header Recep. Job', ESP = 'Hist. cab. recepci�n proyecto';
    SourceTable = 7207410;
    PopulateAllFields = true;
    PageType = Document;
    RefreshOnActivate = true;
    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


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
                field("Vendor Shipment No."; rec."Vendor Shipment No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }

            }
            part("part1"; 7207613)
            {

                SubPageView = SORTING("Recept. Document No.", "Line No.");
                SubPageLink = "Recept. Document No." = FIELD("No.");
            }

        }
    }


    /*begin
    end.
  
*/
}







