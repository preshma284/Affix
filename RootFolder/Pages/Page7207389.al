page 7207389 "Standard/Competition"
{
    CaptionML = ENU = 'Standard/Competition', ESP = 'Criterios/Competencia';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207306;
    SourceTableView = SORTING("Quote Code", "Competitor Code", "Standard Code");
    DataCaptionFields = "Quote Code", "Competitor Code";
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Standard Code"; rec."Standard Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Max. Score"; rec."Max. Score")
                {

                }
                field("Score"; rec."Score")
                {




                    ; trigger OnValidate()
                    BEGIN
                        //JAV 13/08/19: - Se propaga el valor hacia la cabecera con update
                        CurrPage.UPDATE;
                    END;


                }

            }

        }
    }




    /*begin
        end.

    */
}







