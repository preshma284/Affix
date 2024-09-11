page 7207494 "Post. Certifications Stat. FB"
{
    CaptionML = ENU = 'Post. Certifications Statistics', ESP = 'Estad�stica hist. certificacion';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207341;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group180")
            {

                CaptionML = ESP = 'Medici�n';
                field("Amount Origin"; rec."Amount Origin")
                {

                    CaptionClass = Captions[1];
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amount Previous"; rec."Amount Previous")
                {

                    CaptionClass = Captions[2];
                }
                field("Amount Term"; rec."Amount Term")
                {

                    CaptionClass = Captions[3];
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amount GG"; rec."Amount GG")
                {

                    CaptionClass = Captions[4];
                }
                field("Amount BI"; rec."Amount BI")
                {

                    CaptionClass = Captions[5];
                }
                field("Amount Low"; rec."Amount Low")
                {

                    CaptionClass = Captions[6];
                }
                field("Amount Document"; rec."Amount Document")
                {

                    CaptionClass = Captions[7];
                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            group("group188")
            {

                CaptionML = ENU = 'Job', ESP = 'Proyecto';
                field("Measured Amount"; rec."Measured Amount")
                {

                    CaptionML = ENU = 'Measured Amount', ESP = 'Total medido';
                }
                field("CalcNotCertifMeasureAmount"; rec."CalcNotCertifMeasureAmount")
                {

                    CaptionML = ENU = 'Measured Amount Not Certified', ESP = 'false certificado';
                }
                field("Certified Amount"; rec."Certified Amount")
                {

                    CaptionML = ENU = 'Certified Amount', ESP = 'Total certificado';
                }
                field("CalcCertifiedAmountNotInvoiced"; rec."CalcCertifiedAmountNotInvoiced")
                {

                    CaptionML = ENU = 'Certified Amount Not Invoiced', ESP = 'false facturado';
                }
                field("Invoiced Amount"; rec."Invoiced Amount")
                {

                    CaptionML = ENU = 'Invoiced Amount', ESP = 'Total facturado';
                }

            }

        }
    }


    trigger OnAfterGetCurrRecord()
    BEGIN
        //JAV 20/02/21: - Calculo del total del documento
        rec.SetCaptions(Captions);
    END;



    var
        Captions: ARRAY[10] OF Text;

    /*begin
    end.
  
*/
}







