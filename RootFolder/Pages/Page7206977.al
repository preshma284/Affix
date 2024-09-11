page 7206977 "QB Factoring Lines List"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Factoring Lines List', ESP = 'L�neas de Factoring';
    SourceTable = 7206948;
    PageType = List;
    CardPageID = "QB Factoring Lines Card";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Code"; rec."Code")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Amount Limit"; rec."Amount Limit")
                {

                }
                field("Amount Disposed"; rec."Amount Disposed")
                {

                }
                field("Amount Limit - Amount Disposed"; rec."Amount Limit" - rec."Amount Disposed")
                {

                    CaptionML = ESP = 'Importe disponible';
                }
                field("Pending"; "Pending")
                {

                    ExtendedDatatype = Ratio;
                    CaptionML = ESP = '% Disponible';
                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7206981)
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
    trigger OnOpenPage()
    BEGIN
        QBCartera.IsFactoringActiveError;

        //QB 1.06.15 JAV 23/09/20: - Verificar l�mites del Factoring
        QBCartera.CalculateFactoringAmounts();
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF (rec."Amount Limit" = 0) THEN
            Pending := 0
        ELSE
            Pending := ((rec."Amount Limit" - rec."Amount Disposed") * 100 / rec."Amount Limit") * 100;
    END;



    var
        QBCartera: Codeunit 7206905;
        Pending: Decimal;

    /*begin
    end.
  
*/
}









