page 7207621 "Seg. Piecework Budget Start FB"
{
    CaptionML = ENU = 'Seg. Piecework Budget Start FB', ESP = 'Presupusto inicial';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Production Unit" = CONST(true), "Type" = FILTER("Piecework" | "Cost Unit"));
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group37")
            {

                CaptionML = ENU = 'Start Budget', ESP = 'Presupuesto Inicial';
                field("CostBudgetStart"; "CostBudgetStart")
                {

                    CaptionML = ENU = 'Cost Theoretical Production REalized', ESP = 'Coste te�rico producc. realizada';
                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amount Production Performed"; rec."Amount Production Performed")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("MarginBudgetStart"; "MarginBudgetStart")
                {

                    CaptionML = ENU = '% Margin provided', ESP = '% Margen previsto';
                    Editable = False;
                    Style = StrongAccent;
                    StyleExpr = TRUE

  ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(4);
    END;

    trigger OnAfterGetRecord()
    VAR
        Job: Record 167;
    BEGIN
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget", "Budget Measure", "Total Measurement Production",
        rec."Amount Production Performed", "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");

        Job.GET(rec."Job No.");

        CostBudgetStart := rec.AmountCostTheoreticalProduction(Job."Initial Budget Piecework", Rec);
        IF rec."Amount Production Performed" <> 0 THEN BEGIN
            MarginBudgetStart := ROUND((rec."Amount Production Performed" - CostBudgetStart) * 100 /
                                          rec."Amount Production Performed", 0.01)
        END ELSE
            MarginBudgetStart := 0;
    END;



    var
        CostBudgetStart: Decimal;
        MarginBudgetStart: Decimal;

    /*begin
    end.
  
*/
}







