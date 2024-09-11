page 7207490 "Job Offers Statis. FB"
{
    Editable = false;
    CaptionML = ENU = 'Job Offers Statistics', ESP = 'Estad�sticas ofertas proy';
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
            group("group142")
            {

                CaptionML = ENU = 'Details of Costs Budget', ESP = 'Presupuesto Anal�tico';
                field("Amounts[1]_"; Amounts[1])
                {

                    CaptionML = ENU = 'Budget Sales Amount', ESP = 'Imp. venta ppto.';
                }
                field("Amounts[4]_"; Amounts[4])
                {

                    CaptionML = ENU = 'Budget Cost Amount', ESP = 'Imp. coste ppto.';
                }
                field("Amounts[10]_"; Amounts[10])
                {

                    CaptionML = ENU = 'Expected Margin', ESP = 'Margen previsto';
                }
                field("Amounts[11]_"; Amounts[11])
                {

                    ExtendedDatatype = Ratio;
                    CaptionML = ESP = '% Margen';
                    Visible = seeMarginGR;
                }
                field("Amounts[12]_"; Amounts[12])
                {

                    CaptionML = ESP = '% Margen';
                    Visible = seeMarginNR;
                }
                field("Amounts[16]_"; Amounts[16])
                {

                    CaptionML = ESP = 'K Prevista';
                }
                field("Amounts[17]_"; Amounts[17])
                {

                    CaptionML = ENU = 'K', ESP = 'K Real';
                }

            }
            group("group150")
            {

                CaptionML = ENU = 'Details of Costs Budget', ESP = 'Presupuesto de coste';
                field("Amounts[6]_"; Amounts[6])
                {

                    CaptionML = ENU = 'Direct Cost Amount PieceWork', ESP = 'Costes directos';
                    Editable = FALSE;
                }
                field("Amounts[7]_"; Amounts[7])
                {

                    CaptionML = ENU = 'Indirect Cost Amount Piecework', ESP = 'Costes indirectos';
                }
                field("Costs Total"; Amounts[8])
                {

                    CaptionML = ENU = 'Costs Total', ESP = 'Total costes';
                }
                field("Amounts[13]_"; Amounts[13])
                {

                    CaptionML = ENU = 'Indirect cost % about total costs', ESP = '% Indirectos S/Total';
                    Enabled = TRUE;
                    Editable = FALSE;
                }

            }
            group("group155")
            {

                CaptionML = ENU = 'Details of Costs Budget', ESP = 'Presupuesto de venta';
                field("Budget Total Sales Amount"; Amounts[2])
                {

                    CaptionML = ENU = 'Budget Total Sales Amount', ESP = 'Importe venta';
                }
                field("Amounts[14]_"; Amounts[14])
                {

                    CaptionML = ENU = '% Expected Margin Without Sales', ESP = 'Margen S/venta';
                }
                field("Amounts[15]_"; Amounts[15])
                {

                    CaptionML = ENU = 'Margin % about total costs', ESP = 'Margen S/Directos';
                    Editable = FALSE

  ;
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
        seeMarginGR: Boolean;
        seeMarginNR: Boolean;
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
        TotalCost: Decimal;
        MarginSales: Decimal;
        ExpectedMargin: Decimal;
        MarginDirect: Decimal;
        Margin: Decimal;
        k: Decimal;
        "----------------------------------": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
    begin
        Rec.CALCFIELDS("Amou Piecework Meas./Certifi.", "Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework", "Budget Sales Amount", "Budget Cost Amount");
        TotalCost := rec."Indirect Cost Amount Piecework" + rec."Direct Cost Amount PieceWork";

        if rec."Amou Piecework Meas./Certifi." <> 0 then begin
            MarginSales := ((rec."Amou Piecework Meas./Certifi." - TotalCost) / rec."Amou Piecework Meas./Certifi.") * 100;
            MarginDirect := ((rec."Amou Piecework Meas./Certifi." - rec."Direct Cost Amount PW LCY") / rec."Amou Piecework Meas./Certifi.") * 100;
        end;

        ExpectedMargin := rec.CalculateMarginProvided_DL;
        if (rec."Budget Sales Amount" <> 0) then
            Margin := ROUND(ExpectedMargin * 100 / rec."Budget Sales Amount", 0.01)
        ELSE
            Margin := 0;

        seeMarginGR := (Margin >= 0);
        seeMarginNR := (not seeMarginGR);

        if rec."Budget Cost Amount" <> 0 then
            k := rec."Budget Sales Amount" / rec."Budget Cost Amount"
        ELSE
            k := 0;

        Amounts[10] := ExpectedMargin;
        Amounts[11] := Margin * 100;
        Amounts[12] := Margin;
        Amounts[13] := rec.CalcPercentageCostIndirect_PC;
        Amounts[14] := MarginSales;
        Amounts[15] := MarginDirect;
        Amounts[16] := rec."Planned K";
        Amounts[17] := k;

        Amounts[1] := rec."Budget Sales Amount";
        Amounts[2] := rec."Amou Piecework Meas./Certifi.";
        Amounts[4] := rec."Budget Cost Amount";

        //Divisas
        CASE SeeCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    FromCurrency := '';
                    ToCurrency := '';
                    Rec.CALCFIELDS("Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework", "Amou Piecework Meas./Certifi.", "Budget Sales Amount");

                    Amounts[6] := rec."Direct Cost Amount PieceWork";
                    Amounts[7] := rec."Indirect Cost Amount Piecework";
                    Amounts[8] := rec."Indirect Cost Amount Piecework" + rec."Direct Cost Amount PieceWork";
                end;
            1:
                begin
                    txtCurrency := rec."Currency Code" + ' (DP)';
                    FromCurrency := '';
                    ToCurrency := rec."Currency Code";

                    Rec.CALCFIELDS("Direct Cost Amount PW LCY", "Indirect Cost Amount PW LCY", "Amou Piecework Meas./Certifi.", "Budget Sales Amount");

                    Amounts[6] := rec."Direct Cost Amount PW LCY";
                    Amounts[7] := rec."Indirect Cost Amount PW LCY";
                    Amounts[8] := rec."Indirect Cost Amount PW LCY" + rec."Direct Cost Amount PW LCY";
                end;
            2:
                begin
                    txtCurrency := rec."Aditional Currency" + ' (DR)';
                    FromCurrency := '';
                    ToCurrency := rec."Aditional Currency";
                    Rec.CALCFIELDS("Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework", "Amou Piecework Meas./Certifi.", "Budget Sales Amount");

                    Amounts[6] := rec."Direct Cost Amount PieceWork";
                    Amounts[7] := rec."Indirect Cost Amount Piecework";
                    Amounts[8] := rec."Indirect Cost Amount Piecework" + rec."Direct Cost Amount PieceWork";
                    FOR i := 6 TO 8 DO begin
                        JobCurrencyExchangeFunction.CalculateCurrencyValue(rec."No.", Amounts[i], FromCurrency, ToCurrency, rec."Currency Value Date", 1, Amount, Factor);
                        Amounts[i] := Amount;
                    end;
                end;
        end;

        FOR i := 1 TO 2 DO begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(rec."No.", Amounts[i], FromCurrency, ToCurrency,rec."Currency Value Date", 1, Amount, Factor);
            Amounts[i] := Amount;
        end;
        FOR i := 4 TO 4 DO begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(rec."No.", Amounts[i], FromCurrency, ToCurrency, rec."Currency Value Date", 0, Amount, Factor);
            Amounts[i] := Amount;
        end;
    end;

    // begin
    /*{
      PGM 23/01/19: - Q5231 A�adido el campo "Amou Piecework Meas./Certifi."
      JAV 05/12/19: - Se cambia el campo margen para que salga el valor pues puede ser negativo
    }*///end
}







