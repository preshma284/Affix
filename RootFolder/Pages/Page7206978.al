page 7206978 "QB Factoring Lines Card"
{
    SourceTable = 7206948;
    PageType = Card;
    layout
    {
        area(content)
        {
            group("Group")
            {

                field("Code"; rec."Code")
                {

                }
                field("Description"; rec."Description")
                {

                }
                group("group99")
                {

                    CaptionML = ESP = 'Importes';
                    field("Amount Limit"; rec."Amount Limit")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                        END;


                    }
                    field("Amount Disposed"; rec."Amount Disposed")
                    {

                    }
                    field("Amount Limit - Amount Disposed"; rec."Amount Limit" - rec."Amount Disposed")
                    {

                        CaptionML = ESP = 'Importe Disponible';
                    }

                }

            }
            group("group103")
            {

                part("part1"; 7206979)
                {
                    SubPageLink = "Factoring Line" = FIELD("Code");
                }
                part("part2"; 7206980)
                {
                    SubPageLink = "Factoring Line" = FIELD("Code");
                }

            }

        }
        area(FactBoxes)
        {
            part("part3"; 7206981)
            {
                SubPageLink = "Code" = FIELD("Code");
            }
            systempart(Notes; Notes)
            {
                ;
            }
            systempart(Links; Links)
            {
                ;
            }

        }
    }


    /*begin
    end.
  
*/
}








