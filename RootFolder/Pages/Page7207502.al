page 7207502 "Job State - Certification FB"
{
    Editable = false;
    CaptionML = ENU = 'Job State - Certification FB', ESP = 'Estad. Proy. Certif.';
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
                StyleExpr = StyleText;
            }
            field("Amounts[1]_"; Amounts[1])
            {

                CaptionML = ENU = 'Measure Amount', ESP = 'Importe medici�n';
            }
            field("Amounts[2]_"; Amounts[2])
            {

                CaptionML = ENU = 'Certification Amount', ESP = 'Importe certificaci�n';
            }
            field("Amounts[3]_"; Amounts[3])
            {

                CaptionML = ENU = 'Inviced Certification', ESP = 'Certificaciones facturadas';
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
        seeGruped: Boolean;
        QBCurrencyCalcsFunctions: Codeunit 7207358;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
        StyleText: Text;
        ExchangeAmount: Decimal;
        ExchangeType: Decimal;

    LOCAL procedure "--------------------------------- Establecer los parámetros de entrada"();
    begin
    end;

    procedure SetViewData(pCurrency: Integer; pGroup: Boolean);
    begin
        SeeCurrency := pCurrency;
        seeGruped := pGroup;   //Q13639+
    end;

    LOCAL procedure "--------------------------------- Navegación"();
    begin
    end;

    LOCAL procedure "--------------------------------- Cálculos"();
    begin
    end;

    LOCAL procedure CalculateAmouts();
    var
        PJob: Record 167;
    begin
        CLEAR(Amounts);
        txtCurrency := '';
        //Divisas
        //Q13639 +
        //Q13639 MMS 07/07/21 Si seeGruped es false se debe seguir calculando como lo hace actualmente en funci�n de la divisa seleccionada
        AddCurrencyData(SeeCurrency, Rec, FALSE);
        if seeGruped then begin
            PJob.SETRANGE("Matrix Job it Belongs", Rec."No.");
            if PJob.FINDFIRST then begin
                repeat
                    //Q13639 MMS 07/07/21 volvera hacer esto pero sumando en lugar del rec la tabla job que recorra
                    AddCurrencyData(SeeCurrency, PJob, TRUE);
                until PJob.NEXT = 0;
            end;
        end;

        if seeGruped then begin
            txtCurrency := txtCurrency + ' AGR';
            StyleText := 'Favorable';
        end ELSE begin
            StyleText := 'Strong';
        end;
        //Q13639 -
    end;

    LOCAL procedure AddCurrencyData(PCurrency: Integer; PJob: Record 167; PCalcAgrupExchange: Boolean);
    var
        lAmount: ARRAY[10] OF Decimal;
    begin
        //Q13639+
        Rec.CALCFIELDS("Measure Amount", "Certification Amount", "Invoiced Certification");

        lAmount[1] := rec."Measure Amount";
        lAmount[2] := rec."Certification Amount";
        lAmount[3] := rec."Invoiced Certification";

        //Divisas
        CASE SeeCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    FromCurrency := rec."Currency Code";
                    ToCurrency := '';
                end;
            1:
                begin
                    txtCurrency := rec."Currency Code" + ' (DP)';
                    FromCurrency := '';
                    ToCurrency := '';
                end;
            2:
                begin
                    txtCurrency := rec."Aditional Currency" + ' (DR)';
                    FromCurrency := rec."Currency Code";
                    ToCurrency := rec."Aditional Currency";
                end;
        end;

        FOR i := 1 TO 3 DO begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(rec."No.", lAmount[i], FromCurrency, ToCurrency, rec."Currency Value Date", 1, Amount, Factor);
            Amounts[i] += CalcExchange(Amount, PJob."Currency Code", 1);
        end;
        //Q13639-
    end;

    LOCAL procedure CalcExchange(pAmount: Decimal; pCurreny: Code[10]; pType: Integer): Decimal;
    begin
        if seeGruped then begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(Rec."No.", pAmount, pCurreny, Rec."Currency Code", WORKDATE, pType, ExchangeAmount, ExchangeType);
            exit(ExchangeAmount);
        end ELSE
            exit(pAmount);
    end;

    // begin
    /*{
      Q13639 MMS 07/7/2021 Visualizar importes agrupados
    }*///end
}







