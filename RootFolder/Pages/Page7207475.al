page 7207475 "Fixed Date Job"
{
    CaptionML = ENU = 'Fixed Date Job', ESP = 'Fechas fija proyecto';
    SourceTable = 7207381;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Since-Day"; rec."Since-Day")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Since-Month"; rec."Since-Month")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Until-Day"; rec."Until-Day")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Until-Month"; rec."Until-Month")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Payment day"; rec."Payment day")
                {

                }
                field("Payment Month"; rec."Payment Month")
                {

                }
                field("Application Method"; rec."Application Method")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE

  ;
                }

            }

        }
    }


    /*begin
    end.
  
*/
}







