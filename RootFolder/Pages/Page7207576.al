page 7207576 "Query Job Location"
{
    Editable = false;
    CaptionML = ENU = 'Query Job Location', ESP = 'Consulta almac�n obra';
    SourceTable = 27;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
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
                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Net Change"; rec."Net Change")
                {

                }
                field("AverageCostLCY"; "AverageCostLCY")
                {

                    CaptionML = ESP = 'Coste Promedio';

                    ; trigger OnDrillDown()
                    BEGIN
                        CODEUNIT.RUN(CODEUNIT::"Show Avg. Calc. - Item", Rec);
                    END;


                }
                field("QB Activity Code"; rec."QB Activity Code")
                {

                }

            }

        }
    }


    trigger OnAfterGetRecord()
    BEGIN
        ItemCostManagement.CalculateAverageCost(Rec, AverageCostLCY, AverageCostACY);
    END;



    var
        AverageCostLCY: Decimal;
        ItemCostManagement: Codeunit 5804;
        AverageCostACY: Decimal;

    /*begin
    end.
  
*/
}







