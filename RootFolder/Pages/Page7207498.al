page 7207498 "Measurement Statistics FB"
{
    CaptionML = ENU = 'Statistics', ESP = 'Estad�siticas';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207336;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group222")
            {

                CaptionML = ESP = 'Del documento';
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
            group("group230")
            {

                CaptionML = ENU = 'Job', ESP = 'Del proyecto';
                field("Measured Amount"; rec."Measured Amount")
                {

                    CaptionML = ENU = 'Measured', ESP = 'Total Medido';
                }
                field("Importe medido no certif."; rec."CalcAmountMeasureNoCertif")
                {

                    CaptionML = ENU = 'Not Cert. Measured', ESP = 'false certificado';
                }
                field("Certified Amount"; rec."Certified Amount")
                {

                    CaptionML = ENU = 'Certified', ESP = 'Total Certificado';
                }
                field("CalcAmountCertifNoInvoiced"; rec."CalcAmountCertifNoInvoiced")
                {

                    CaptionML = ENU = 'Not Invoiced Cert.', ESP = 'false facturado';
                }
                field("Invoiced Amount"; rec."Invoiced Amount")
                {

                    CaptionML = ENU = 'Invoiced', ESP = 'Total Facturado';
                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        //JAV 20/02/21: - Calculo del total del documento
        rec.CalculateTotals;
        rec.SetCaptions(Captions);
    END;



    var
        Job: Record 167;
        Currency: Record 4;
        Captions: ARRAY[10] OF Text;
        SumTot: Decimal;
        SumGGBI: Decimal;/*

    begin
    {
      JAV 05/04/19: - Se reduce la descripci�n de los captions para que se lean mejor en la pantalla
    }
    end.*/


}







