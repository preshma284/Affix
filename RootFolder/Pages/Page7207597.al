page 7207597 "QB Objectives Line Card Detail"
{
    CaptionML = ENU = 'Objectives Line Card Detail', ESP = 'Detalle l�nea de Objetivo';
    SourceTable = 7207405;
    PageType = Card;

    layout
    {
        area(content)
        {
            repeater("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Entry Date"; rec."Entry Date")
                {

                }
                field("Improvement"; rec."Improvement")
                {

                }
                field("Probability"; rec."Probability")
                {

                }
                field("% Probability"; rec."% Probability")
                {

                }
                field("Improvement Amount"; rec."Improvement Amount")
                {

                }
                field("txtComment"; txtComment)
                {

                    CaptionML = ESP = 'Comentario';



                    ; trigger OnValidate()
                    BEGIN
                        rec.SetComment(txtComment);
                    END;


                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        txtComment := rec.GetComment;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        txtComment := rec.GetComment;
    END;



    var
        txtComment: Text;



    /*begin
        end.

    */
}







