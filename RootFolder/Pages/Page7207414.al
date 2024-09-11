page 7207414 "Job Situation Statistics"
{
    Editable = false;
    CaptionML = ENU = 'Job Situation Statistics', ESP = 'Estad�sticas situaci�n proyecto';
    SourceTable = 167;
    PageType = Card;
    layout
    {
        area(content)
        {
            group("General")
            {

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
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {

                }
                field("Delivered Quantity"; rec."Delivered Quantity")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Returned Quantity"; rec."Returned Quantity")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Balance Amount"; rec."Balance Amount")
                {

                }

            }

        }
    }


    /*begin
    end.
  
*/
}







