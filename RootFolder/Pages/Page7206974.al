page 7206974 "QB Confirming Lines Card"
{
    SourceTable = 7206946;
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
                group("group56")
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
            part("part1"; 7206975)
            {
                SubPageLink = "Confirming Line" = FIELD("Code");
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7206976)
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








