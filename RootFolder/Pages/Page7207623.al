page 7207623 "Seg. Piecework Budget Cur. FB"
{
    CaptionML = ENU = 'Seg. Piecework Budget Cur. FB', ESP = 'Presupuesto Actual';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Production Unit" = CONST(true), "Type" = FILTER("Piecework" | "Cost Unit"));
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group49")
            {

                CaptionML = ENU = 'Budget Actual', ESP = 'Presupuesto actual';
                field("AmountCostRealized"; "AmountCostRealized")
                {

                    CaptionML = ENU = 'Cost Theoretical Production Realized', ESP = 'Coste te�rico producc. realizado';
                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amount Production Performed-AmountCostRealized"; rec."Amount Production Performed" - "AmountCostRealized")
                {

                    CaptionML = ENU = 'Theoretical Margin', ESP = 'Margen te�rico';
                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("PercentageMarginBudgetActual"; "PercentageMarginBudgetActual")
                {

                    CaptionML = ENU = '% Margin Provided', ESP = '% Margen previsto';
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
        JobinProgress := Rec.GETFILTER("Job No.");
        BudgetinProgress := Rec.GETFILTER("Budget Filter");
        Rec.FILTERGROUP(4);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget", "Budget Measure", "Total Measurement Production",
        "Amount Production Performed", "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");

        Job.GET(rec."Job No.");

        AmountCostRealized := rec.AmountCostTheoreticalProduction(Job."Current Piecework Budget", Rec);

        MarginBudgetActual := rec."Amount Production Performed" - AmountCostRealized;
        IF rec."Amount Production Performed" <> 0 THEN
            PercentageMarginBudgetActual := ROUND(MarginBudgetActual * 100 / rec."Amount Production Performed", 0.01);
    END;



    var
        JobinProgress: Code[10];
        BudgetinProgress: Code[20];
        Job: Record 167;
        AmountCostRealized: Decimal;
        MarginBudgetActual: Decimal;
        PercentageMarginBudgetActual: Decimal;

    /*begin
    end.
  
*/
}







