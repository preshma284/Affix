page 7207486 "Quotes Job Gen. FB"
{
    Editable = false;
    CaptionML = ENU = 'Status Quotes Job Gen. FB', ESP = 'Estad. ofertas proy. gen.';
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
            group("group77")
            {

                CaptionML = ENU = 'Presented Version', ESP = 'Gastos Imputados';
                field("Amounts[5]_"; Amounts[5])
                {

                    CaptionML = ENU = 'Presented Version', ESP = 'Importe';
                    Style = Standard;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    VAR
                        JobLedgerEntry: Record 169;
                        JobLedgerEntries: Page 92;
                    BEGIN
                        JobLedgerEntry.RESET;
                        JobLedgerEntry.SETCURRENTKEY("Job No.");
                        JobLedgerEntry.SETFILTER("Job No.", rec."No." + '*');
                        CLEAR(JobLedgerEntries);
                        JobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
                        JobLedgerEntries.RUNMODAL;
                    END;


                }

            }
            group("group79")
            {

                CaptionML = ENU = 'Presented Version', ESP = 'Versi�n Presentada';
                field("Presented Version"; rec."Presented Version")
                {

                    CaptionML = ENU = 'Presented Version', ESP = 'C�digo';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Amounts[1]_"; Amounts[1])
                {

                    CaptionML = ENU = 'Sale Budget Amount', ESP = 'Importe ppto. venta';
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[6]_"; Amounts[6])
                {

                    CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                    BlankZero = true;
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Amounts[10]_"; Amounts[10])
                {

                    CaptionML = ENU = '% Margin', ESP = '% Margen';
                    BlankZero = true;
                }
                field("Amounts[11]_"; Amounts[11])
                {

                    CaptionML = ENU = 'K', ESP = 'K prevista';
                }
                field("Amounts[12]_"; Amounts[12])
                {

                    CaptionML = ESP = 'K real';
                }

            }
            group("group86")
            {

                CaptionML = ENU = 'HIGHER VERSION', ESP = 'Versi�n m�s Alta';
                field("VersionHight"; VersionHight)
                {

                    CaptionML = ENU = 'Highest Version', ESP = 'C�digo';
                }
                field("Amounts[2]_"; Amounts[2])
                {

                    CaptionML = ENU = 'Sale Budget Amount', ESP = 'Importe ppto. venta';
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[7]_"; Amounts[7])
                {

                    CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                    BlankZero = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Amounts[13]_"; Amounts[13])
                {

                    CaptionML = ENU = '% Margin', ESP = '% Margen';
                    BlankZero = true;
                }
                field("Amounts[14]_"; Amounts[14])
                {

                    CaptionML = ENU = 'K', ESP = 'K prevista';
                }
                field("HighPlannedK"; Amounts[15])
                {

                    CaptionML = ENU = 'Planned K', ESP = 'K real';
                }

            }
            group("group93")
            {

                CaptionML = ENU = 'LOWER VERSION', ESP = 'Versi�n m�s Baja';
                field("VersionLow"; VersionLow)
                {

                    CaptionML = ENU = 'Lower Version', ESP = 'C�digo';
                }
                field("Amounts[3]_"; Amounts[3])
                {

                    CaptionML = ENU = 'Sale Budget Amount', ESP = 'Importe ppto. venta';
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[8]_"; Amounts[8])
                {

                    CaptionML = ENU = 'Cost Budget Amount', ESP = 'Importe ppto. coste';
                    BlankZero = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Amounts[16]_"; Amounts[16])
                {

                    CaptionML = ENU = '% Margin', ESP = '% Margen';
                    BlankZero = true;
                }
                field("Amounts[17]_"; Amounts[17])
                {

                    CaptionML = ENU = 'K', ESP = 'K prevista';
                }
                field("LowPlannedK"; Amounts[18])
                {

                    CaptionML = ENU = 'Planned K', ESP = 'K real';
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
        AccountNumberComp: Integer;
        Job: Record 167;
        VersionHight: Code[20];
        VersionLow: Code[20];
        "----------------------------------": Integer;
        FunctionQB: Codeunit 7207272;
        useCurrencies: Boolean;
        SeeCurrency: Integer;
        txtCurrency: Text;
        Amounts: ARRAY[20] OF Decimal;
        JobCurrencyExchangeFunction: Codeunit 7207332;

    LOCAL procedure SetData(pJob: Record 167; var pSales: Decimal; var pCost: Decimal; var pMargin: Decimal; var kPlanned: Decimal; var kSubmitted: Decimal);
    begin
        //Monta un grupo de variables
        pJob.CALCFIELDS("Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework", "Amou Piecework Meas./Certifi.");
        pSales := pJob."Amou Piecework Meas./Certifi.";
        pCost := pJob."Direct Cost Amount PieceWork" + pJob."Indirect Cost Amount Piecework";
        if (pSales <> 0) then
            pMargin := ROUND((pSales - pCost) / pSales, 0.01)
        ELSE
            pMargin := 0;

        kPlanned := pJob."Planned K";
        if (pCost <> 0) then
            kSubmitted := pSales / pCost
        ELSE
            kSubmitted := 0;
    end;

    procedure SetCurrency(pCurrency: Integer);
    begin
        SeeCurrency := pCurrency;
    end;

    LOCAL procedure CalculateAmouts();
    var
        JobLedgerEntry: Record 169;
        AmountSales: ARRAY[3] OF Decimal;
        AmountCost: ARRAY[3] OF Decimal;
        Margin: ARRAY[3] OF Decimal;
        ImporteGastos: Decimal;
        KSubmitted: ARRAY[3] OF Decimal;
        KPlanned: ARRAY[3] OF Decimal;
        "----------------------------------": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
    begin
        CLEAR(Amounts);

        //JAV 23/08/19: - Calculo el importe de gastos imputados
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.");
        JobLedgerEntry.SETFILTER("Job No.", rec."No." + '*');
        JobLedgerEntry.CALCSUMS("Total Cost (LCY)", "Total Price (LCY)");
        ImporteGastos := -(JobLedgerEntry."Total Cost (LCY)" + JobLedgerEntry."Total Price (LCY)");

        //JAV 05/10/19: - Se mejoran los c�lculos pues no lo hac�a correctamente si no estaba calculado el presupuesto anal�tico
        CLEAR(AmountCost);
        CLEAR(AmountSales);
        CLEAR(Margin);
        CLEAR(KPlanned);
        CLEAR(KSubmitted);
        VersionHight := '';
        VersionLow := '';

        //Versi�n presentada
        if (rec."Presented Version" <> '') then begin
            Job.GET(rec."Presented Version");
            SetData(Job, AmountSales[1], AmountCost[1], Margin[1], KPlanned[1], KSubmitted[1]);
        end;

        //Versi�n mas alta y mas baja
        Job.RESET;
        Job.SETRANGE("Original Quote Code", rec."No.");
        if Job.FINDSET(FALSE) then
            repeat
                //Solo para versiones con presupuesto de venta calculado
                Job.CALCFIELDS("Amou Piecework Meas./Certifi.");
                if (Job."Amou Piecework Meas./Certifi." <> 0) then begin
                    if (VersionHight = '') or (Job."Amou Piecework Meas./Certifi." > AmountSales[2]) then begin
                        VersionHight := Job."No.";
                        SetData(Job, AmountSales[2], AmountCost[2], Margin[2], KPlanned[2], KSubmitted[2]);
                    end;

                    if (VersionLow = '') or (Job."Amou Piecework Meas./Certifi." < AmountSales[3]) then begin
                        VersionLow := Job."No.";
                        SetData(Job, AmountSales[3], AmountCost[3], Margin[3], KPlanned[3], KSubmitted[3]);
                    end;
                end;
            until Job.NEXT = 0;

        //Montar las variables
        Amounts[1] := AmountSales[1];
        Amounts[2] := AmountSales[2];
        Amounts[3] := AmountSales[3];

        Amounts[5] := ImporteGastos;
        Amounts[6] := AmountCost[1];
        Amounts[7] := AmountCost[2];
        Amounts[8] := AmountCost[3];

        Amounts[10] := Margin[1];
        Amounts[11] := KPlanned[1];
        Amounts[12] := KSubmitted[1];
        Amounts[13] := Margin[2];
        Amounts[14] := KPlanned[2];
        Amounts[15] := KSubmitted[2];
        Amounts[16] := Margin[3];
        Amounts[17] := KPlanned[3];
        Amounts[18] := KSubmitted[3];

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
        FOR i := 5 TO 8 DO begin
            JobCurrencyExchangeFunction.CalculateCurrencyValue(rec."No.", Amounts[i], FromCurrency, ToCurrency, rec."Currency Value Date", 0, Amount, Factor);
            Amounts[i] := Amount;
        end;
    end;

    // begin
    /*{
      JAV 23/08/19: - Calculo el importe de gastos imputados
      JAV 05/10/19: - Se reforma por completo para que no use costes del presupuesto anal�tico pues no es obligatorio en estudios, y se eliminan cosas que no se usan
      PGM 22/10/19: - Q8084 Arreglado los captions
      QMD 30/10/19: - Q8165 Se arregla para que los margenes salgan como porcentajes
    }*///end
}







