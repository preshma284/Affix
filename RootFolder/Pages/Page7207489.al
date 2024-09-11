page 7207489 "Records Contracted Amount FB"
{
    CaptionML = ENU = 'Contracted Amount Job', ESP = 'Importe Contratado Proyecto';
    SourceTable = 7207386;
    SourceTableView = SORTING("Job No.", "Customer Certification Unit", "Piecework Code")
                    ORDER(Ascending)
                    WHERE("Type" = CONST("Piecework"), "Customer Certification Unit" = FILTER(true));
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
            field("Amounts[1]_"; Amounts[1])
            {

                CaptionML = ENU = 'Contract Amount', ESP = 'Importe Contratado';
                CaptionClass = Captions[1];
            }
            field("Amounts[2]_"; Amounts[2])
            {

                CaptionML = ENU = 'Quality Deduction', ESP = 'G.G.';
                CaptionClass = Captions[2];
            }
            field("Amounts[3]_"; Amounts[3])
            {

                CaptionML = ESP = 'B.I.';
                CaptionClass = Captions[3];
            }
            field("Amounts[4]_"; Amounts[4])
            {

                CaptionML = ENU = 'General Expenses', ESP = 'Baja';
                CaptionClass = Captions[4];
            }
            field("Amounts[5]_"; Amounts[5])
            {

                CaptionML = ENU = 'Industrial Benefit', ESP = 'Indirectos';
                CaptionClass = Captions[5];
            }
            field("Amounts[6]_"; Amounts[6])
            {

                CaptionML = ENU = 'Industrial Benefit', ESP = 'Total';
                CaptionClass = Captions[6]

  ;
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
        Captions: ARRAY[10] OF Text;
        JobCurrencyExchangeFunction: Codeunit 7207332;

    procedure SetCurrency(pCurrency: Integer);
    begin
        SeeCurrency := pCurrency;
    end;

    LOCAL procedure CalculateAmouts();
    var
        Job: Record 167;
        Importe: Decimal;
        CoefInd: Decimal;
        TotCoef: Decimal;
        GastosGen: Decimal;
        BIndustrial: Decimal;
        Total: Decimal;
        "----------------------------------": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
    begin
        CLEAR(Amounts);
        if (not Job.GET(rec."Job No.")) then
            CLEAR(Job);

        Captions[1] := rec.FIELDCAPTION("Amount Sale Contract");
        Captions[2] := Job.FIELDCAPTION("General Expenses / Other") + ' (' + FORMAT(Job."General Expenses / Other") + '%)';
        Captions[3] := Job.FIELDCAPTION("Industrial Benefit") + ' (' + FORMAT(Job."Industrial Benefit") + '%)';
        Captions[4] := Job.FIELDCAPTION("Low Coefficient") + ' (' + FORMAT(Job."Low Coefficient") + '%)';
        Captions[5] := Job.FIELDCAPTION("Quality Deduction") + ' (' + FORMAT(Job."Quality Deduction") + '%)';
        Captions[6] := Job.FIELDCAPTION("Assigned Amount");

        Job.CALCFIELDS("Contract Amount", "Indirect Cost Amount Piecework");
        CoefInd := Job."Contract Amount" * Job."Quality Deduction" / 100;
        TotCoef := Job."Contract Amount" + CoefInd;
        GastosGen := (TotCoef * Job."General Expenses / Other") / 100;
        BIndustrial := (TotCoef * Job."Industrial Benefit") / 100;
        Total := TotCoef + GastosGen + BIndustrial;

        Amounts[1] := Job."Contract Amount";
        Amounts[2] := ROUND(Amounts[1] * Job."General Expenses / Other" / 100, 0.01);
        Amounts[3] := ROUND(Amounts[1] * Job."Industrial Benefit" / 100, 0.01);
        Amounts[4] := -ROUND((Amounts[1] + Amounts[2] + Amounts[3]) * Job."Low Coefficient" / 100, 0.01);
        Amounts[5] := ROUND((Amounts[1] + Amounts[2] + Amounts[3] + Amounts[4]) * Job."Quality Deduction" / 100, 0.01);
        Amounts[6] := Amounts[1] + Amounts[2] + Amounts[3] + Amounts[4] + Amounts[5];

        //Divisas
        CASE SeeCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    FromCurrency := Job."Currency Code";
                    ToCurrency := '';
                end;
            1:
                begin
                    txtCurrency := Job."Currency Code" + ' (DP)';
                    FromCurrency := '';
                    ToCurrency := '';
                end;
            2:
                begin
                    txtCurrency := Job."Aditional Currency" + ' (DR)';
                    FromCurrency := Job."Currency Code";
                    ToCurrency := Job."Aditional Currency";
                end;
        end;

        FOR i := 1 TO 6 DO begin
            if (Amounts[i] <> 0) then begin
                JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", Amounts[i], FromCurrency, ToCurrency, Job."Currency Value Date", 0, Amount, Factor);
                Amounts[i] := Amount;
            end;
        end;
    end;

    // begin//end
}







