page 7207485 "Quotes Bidding FB"
{
    Editable = false;
    CaptionML = ENU = 'Status Bidding FB', ESP = 'Estad. licitaciones';
    SourceTable = 167;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field("txtCurrency"; txtCurrency)
            {

                CaptionML = ESP = 'Divisa';
                Visible = useCurrencies;
                Editable = FALSE;
            }
            group("group59")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Amounts[1]_"; Amounts[1])
                {

                    CaptionML = ENU = 'Bidding Bases Budget', ESP = 'Ppto. base licitaci�n';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[2]_"; Amounts[2])
                {

                    CaptionML = ENU = 'Submitted Quote Amount', ESP = 'Importe oferta presentada';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Amounts[11]_"; Amounts[11])
                {

                    CaptionML = ENU = 'Low Supply', ESP = 'Baja ofertada';
                }

            }
            group("group63")
            {

                CaptionML = ENU = 'General', ESP = 'Competencia';
                field("Amounts[3]_"; Amounts[3])
                {

                    CaptionML = ENU = 'Average Quoted Amount', ESP = 'Importe ofertado medio';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[12]_"; Amounts[12])
                {

                    CaptionML = ENU = 'Low Average Competition', ESP = 'Media baja competencia';
                }
                field("Amounts[13]_"; Amounts[13])
                {

                    CaptionML = ENU = 'Low Competition Higher', ESP = 'Baja mayor de la competencia';
                }
                field("Amounts[14]_"; Amounts[14])
                {

                    CaptionML = ENU = 'Low Competition Less', ESP = 'Baja menor de la competencia';
                }

            }
            group("group68")
            {

                CaptionML = ENU = 'Score', ESP = 'Puntuaci�n';
                field("Amounts[15]_"; Amounts[15])
                {

                    CaptionML = ENU = 'Archieved Score', ESP = 'Puntuaci�n obtenida';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[16]_"; Amounts[16])
                {

                    CaptionML = ENU = 'Average Score', ESP = 'Puntuaci�n media';
                    Style = Standard;
                    StyleExpr = TRUE;
                }

            }
            group("group71")
            {

                CaptionML = ENU = 'Awardomg', ESP = 'Adjudicaciones';
                field("Bidder Company"; rec."Bidder Company")
                {

                }
                field("Amounts[17]_"; Amounts[17])
                {

                    CaptionML = ENU = 'Adjudicated Low', ESP = 'Baja adjudicada';
                }
                field("Amounts[18]_"; Amounts[18])
                {

                    CaptionML = ENU = 'Adjudicated Score', ESP = 'Puntuaci�n adjudicada';
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 08/04/20: - Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CalculateAmouts;
    END;



    var
        FunctionQB: Codeunit 7207272;
        useCurrencies: Boolean;
        SeeCurrency: Integer;
        txtCurrency: Text;
        Amounts: ARRAY[20] OF Decimal;
        JobCurrencyExchangeFunction: Codeunit 7207332;

    procedure SetCurrency(pCurrency: Integer);
    begin
        SeeCurrency := pCurrency;
    end;

    LOCAL procedure CalculateAmouts();
    var
        Job: Record 167;
        CompetitionQuote: Record 7207307;
        Number: Integer;
        SumScore: Decimal;
        AverageScore: Decimal;
        Number2: Integer;
        SumLow: Decimal;
        AverageLow: Decimal;
        AmountSaleSubmitted: Decimal;
        LowCoefficient: Decimal;
        "----------------------------------": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
    begin
        CLEAR(Amounts);

        //Importe presentado
        AmountSaleSubmitted := 0;
        LowCoefficient := 0;
        if (rec."Presented Version" <> '') then begin
            Job.GET(rec."Presented Version");
            Job.CALCFIELDS("Budget Sales Amount", "Average Quoted Amount");
            AmountSaleSubmitted := Job."Budget Sales Amount";
            LowCoefficient := Job."Low Coefficient";
        end;

        //Calculo de la puntuaci�n media
        Number := 0;
        SumScore := 0;
        Number2 := 0;
        SumLow := 0;
        CompetitionQuote.SETRANGE("Quote Code", rec."No.");
        if CompetitionQuote.FINDFIRST then
            repeat
                CompetitionQuote.CALCFIELDS("Score High");
                if (CompetitionQuote."Score High" <> 0) then begin
                    SumScore += CompetitionQuote."Score High";
                    Number += 1;
                end;
                if (CompetitionQuote."% of Low" <> 0) then begin
                    SumLow += CompetitionQuote."% of Low";
                    Number2 += 1;
                end;
            until CompetitionQuote.NEXT = 0;

        if (Number <> 0) then
            AverageScore := SumScore / Number
        ELSE
            AverageScore := 0;

        if (Number2 <> 0) then
            AverageLow := SumLow / Number2
        ELSE
            AverageLow := rec."Low Average Competition";

        Rec.CALCFIELDS("Low Competition Higher", "Low Competition Less", "Archieved Score", "Adjudicated Low", "Adjudicated Score");

        Amounts[1] := rec."Bidding Bases Budget";
        Amounts[2] := AmountSaleSubmitted;
        Amounts[3] := rec."Average Quoted Amount";
        Amounts[11] := LowCoefficient;
        Amounts[12] := AverageLow;
        Amounts[13] := rec."Low Competition Higher";
        Amounts[14] := rec."Low Competition Less";
        Amounts[15] := rec."Archieved Score";
        Amounts[16] := AverageScore;
        Amounts[17] := rec."Adjudicated Low";
        Amounts[18] := rec."Adjudicated Score";

        //Divisas
        CASE SeeCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    FromCurrency := '';
                    ToCurrency := '';
                end;
            1:
                begin
                    txtCurrency := Rec."Currency Code" + ' (DP)';
                    FromCurrency := '';
                    ToCurrency := rec."Currency Code";
                end;
            2:
                begin
                    txtCurrency := Rec."Aditional Currency" + ' (DR)';
                    FromCurrency := '';
                    ToCurrency := rec."Aditional Currency";
                end;
        end;

        FOR i := 1 TO 3 DO begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(rec."No.", Amounts[i], FromCurrency, ToCurrency, rec."Currency Value Date", 1, Amount, Factor);
            Amounts[i] := Amount;
        end;
    end;

    // begin//end
}







