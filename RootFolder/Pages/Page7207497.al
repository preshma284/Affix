page 7207497 "Posted Measurement Stat. FB"
{
    CaptionML = ENU = 'Posted Measurement Statistics', ESP = 'Estad. hist. mediciones';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207338;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group207")
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
            group("group215")
            {

                CaptionML = ENU = 'Job', ESP = 'Proyecto';
                field("Measured Amount"; rec."Measured Amount")
                {

                    CaptionML = ENU = 'Measured Amount', ESP = 'Total Medido';
                }
                field("CalculateAmountMeasureNoCertification"; rec."CalculateAmountMeasureNoCertification")
                {

                    CaptionML = ENU = 'Amount Measure Not Certified', ESP = 'false certificado';
                }
                field("Certified Amount"; rec."Certified Amount")
                {

                    CaptionML = ENU = 'Certified Amount', ESP = 'Total Certificado';
                }
                field("CalculateAmountCertificationNoInoviced"; rec."CalculateAmountCertificationNoInoviced")
                {

                    CaptionML = ENU = 'Amount Certified Not Invoiced', ESP = 'false facturado';
                }
                field("Invoiced Amount"; rec."Invoiced Amount")
                {

                    CaptionML = ENU = 'Invoiced Amount', ESP = 'Total Facturado';
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







