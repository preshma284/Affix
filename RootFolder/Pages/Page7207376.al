page 7207376 "Statistics Quotes Job 2"
{
    Editable = false;
    CaptionML = ENU = 'Statistics Quotes Job 2', ESP = 'Estad�sticas ofertas proy. 2';
    SourceTable = 167;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                group("group49")
                {

                    CaptionML = ENU = 'SUBMITTED VERSION', ESP = 'VERSI�N PRESENTADA';
                    field("Presented Version"; rec."Presented Version")
                    {

                        CaptionML = ENU = 'SUBMITTED VERSION', ESP = 'VERSI�N PRESENTADA';
                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("AmountSaleSubmitted"; "AmountSaleSubmitted")
                    {

                        CaptionML = ENU = 'Sales Budget Amount', ESP = 'Importe ppto. venta';
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("AmountCostSubmitted"; "AmountCostSubmitted")
                    {

                        CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field("PercentageMarginSubmitted"; "PercentageMarginSubmitted")
                    {

                        CaptionML = ENU = '% Margin', ESP = '% Margen';
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                    }

                }
                group("group54")
                {

                    CaptionML = ENU = 'HIGHER VERSION', ESP = 'VERSI�N M�S ALTA';
                    field("VersionHight"; "VersionHight")
                    {

                        CaptionML = ENU = 'Higher Version', ESP = 'Versi�n m�s alta';
                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("AmountSaleHight"; "AmountSaleHight")
                    {

                        CaptionML = ENU = 'Sale Budget Amount', ESP = 'Importe ppto. venta';
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("AmountCostHight"; "AmountCostHight")
                    {

                        CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field("PercentageMarginHight"; "PercentageMarginHight")
                    {

                        CaptionML = ENU = '% Margin', ESP = '% Margen';
                    }

                }
                group("group59")
                {

                    CaptionML = ENU = 'LOWER VERSION', ESP = 'VERSI�N M�S BAJA';
                    field("VersionLow"; "VersionLow")
                    {

                        CaptionML = ENU = 'Lower Version', ESP = 'Versi�n m�s baja';
                        Style = Standard;
                        StyleExpr = TRUE;
                    }
                    field("AmountSaleLow"; "AmountSaleLow")
                    {

                        CaptionML = ENU = 'Sale Budget Amount', ESP = 'Importe ppto. venta';
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("AmountCostLow"; "AmountCostLow")
                    {

                        CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field("PercentageMarginLow"; "PercentageMarginLow")
                    {

                        CaptionML = ENU = '% Margin', ESP = '% Margen';
                    }

                }
                group("group64")
                {

                    CaptionML = ENU = 'Bidding', ESP = 'Licitaci�n';
                    field("Bidding Bases Budget"; rec."Bidding Bases Budget")
                    {

                    }
                    field("Low Coefficient"; rec."Low Coefficient")
                    {

                    }
                    field("AmountQuote"; "AmountSaleSubmitted")
                    {

                        CaptionML = ENU = 'Submitted Quote Amount', ESP = 'Importe oferta presentada';
                    }
                    field("AverageLow"; "AverageLow")
                    {

                        CaptionML = ENU = 'Low Average Competition', ESP = '% Baja Media Competencia';
                    }
                    field("Average Quoted Amount"; rec."Average Quoted Amount")
                    {

                    }
                    field("Low Competition Higher"; rec."Low Competition Higher")
                    {

                    }
                    field("Low Competition Less"; rec."Low Competition Less")
                    {

                    }
                    field("Archieved Score"; rec."Archieved Score")
                    {

                    }
                    field("AverageScore"; "AverageScore")
                    {

                        CaptionML = ENU = 'Average Score', ESP = 'Puntuaci�n media';
                    }
                    field("Bidder Company"; rec."Bidder Company")
                    {

                    }
                    field("Adjudicated Low"; rec."Adjudicated Low")
                    {

                    }
                    field("Adjudicated Score"; rec."Adjudicated Score")
                    {

                    }

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        PercentageMarginSubmitted := 0;
        PercentageMarginHight := 0;
        PercentageMarginLow := 0;
        AmountSaleSubmitted := 0;
        AmountCostSubmitted := 0;
        AmountSaleHight := 0;
        AmountSaleLow := 0;
        AmountCostHight := 0;
        AmountCostLow := 0;

        IF rec."Presented Version" <> '' THEN BEGIN
            Job.GET(rec."Presented Version");
            Job.CALCFIELDS("Budget Cost Amount", Job."Budget Sales Amount");
            AmountSaleSubmitted := Job."Budget Sales Amount";
            AmountCostSubmitted := Job."Budget Cost Amount";
            PercentageMarginSubmitted := Job.CalcMarginPricePercentage_DL;
        END ELSE BEGIN
            AmountCostSubmitted := 0;
            AmountSaleSubmitted := 0;
        END;

        Job.RESET;
        Job.SETRANGE("Original Quote Code", rec."No.");
        IF Job.FINDFIRST THEN BEGIN
            AmountSaleHight := Job."Budget Sales Amount";
            AmountSaleLow := Job."Budget Sales Amount";
            AmountCostHight := Job."Budget Cost Amount";
            AmountCostLow := Job."Budget Cost Amount";
            REPEAT
                Job.CALCFIELDS("Budget Cost Amount", Job."Budget Sales Amount");

                IF Job."Budget Sales Amount" > AmountSaleHight THEN BEGIN
                    AmountSaleHight := Job."Budget Sales Amount";
                    AmountCostHight := Job."Budget Cost Amount";
                    VersionHight := Job."No.";
                    PercentageMarginHight := Job.CalcMarginPricePercentage_DL;
                END;

                IF Job."Budget Sales Amount" < AmountSaleLow THEN BEGIN
                    AmountSaleLow := Job."Budget Sales Amount";
                    AmountCostLow := Job."Budget Cost Amount";
                    VersionLow := Job."No.";
                    PercentageMarginLow := Job.CalcMarginPricePercentage_DL;
                END;
            UNTIL Job.NEXT = 0;
        END;

        AverageScore := 0;
        AccountNumberComp := 0;
        AverageLow := 0;
        AccountNumberLow := 0;
        CompetitionQuote.SETRANGE("Quote Code", rec."No.");
        IF CompetitionQuote.FINDFIRST THEN
            REPEAT
                CompetitionQuote.CALCFIELDS("Score High");
                IF (CompetitionQuote."Score High" <> 0) THEN BEGIN
                    AverageScore += CompetitionQuote."Score High";
                    AccountNumberComp += 1;
                END;
                IF (CompetitionQuote."% of Low" <> 0) THEN BEGIN
                    AverageLow += CompetitionQuote."% of Low";
                    AccountNumberLow += 1;
                END;
            UNTIL CompetitionQuote.NEXT = 0;

        IF AccountNumberComp <> 0 THEN
            AverageScore := AverageScore / AccountNumberComp;
    END;



    var
        AverageLow: Decimal;
        AccountNumberLow: Integer;
        AverageScore: Decimal;
        AccountNumberComp: Integer;
        AmountSaleSubmitted: Decimal;
        AmountCostSubmitted: Decimal;
        PercentageMarginSubmitted: Decimal;
        PercentageMarginHight: Decimal;
        PercentageMarginLow: Decimal;
        AmountSaleHight: Decimal;
        AmountSaleLow: Decimal;
        AmountCostHight: Decimal;
        AmountCostLow: Decimal;
        VersionHight: Code[20];
        VersionLow: Code[20];
        CompetitionQuote: Record 7207307;
        Job: Record 167;

    /*begin
    end.
  
*/
}







