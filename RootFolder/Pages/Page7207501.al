page 7207501 "Job State - Warehouse FB"
{
    Editable = false;
    CaptionML = ENU = 'Job State - Warehouse FB', ESP = 'Estad. Proyectos - Almac�n FB';
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

                CaptionML = ENU = 'Pending Orders Amount', ESP = 'Imp. pedidos pendientes';
            }
            field("Amounts[2]_"; Amounts[2])
            {

                CaptionML = ENU = 'Pending Warehouse Amount', ESP = 'Imp. albaranes pendientes';

                ; trigger OnDrillDown()
                BEGIN
                    ShowShipPendingWarehousse;
                END;


            }
            field("Amounts[3]_"; Amounts[3])
            {

                CaptionML = ENU = 'Warehouse Availability Amount', ESP = 'Importe existencias almac�n';
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

    procedure ShowShipPendingWarehousse();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        if (seeGruped) then begin
            PurchRcptLine.SETFILTER("Job No.", rec."No." + '*');
            PurchRcptLine.SETRANGE("Location Code", rec."Job Location" + '*');
        end ELSE begin
            PurchRcptLine.SETRANGE("Job No.", rec."No.");
            PurchRcptLine.SETRANGE("Location Code", rec."Job Location");
        end;
        PAGE.RUN(0, PurchRcptLine);
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
        //Q13639 MMS 06/07/21 Si seeGruped es false se debe seguir calculando como lo hace actualmente en funci�n de la divisa seleccionada
        AddCurrencyData(SeeCurrency, Rec, FALSE);
        //Q13639 +
        if seeGruped then begin
            PJob.SETRANGE("Matrix Job it Belongs", Rec."No.");
            if PJob.FINDFIRST then begin
                repeat
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
    begin
        //Q13639+
        CASE PCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    PJob.CALCFIELDS("Pending Orders Amount (LCY)", "Shipment Pend. Amt (LCY)", "Warehouse Availability Amount");
                    Amounts[1] += CalcExchange(PJob."Pending Orders Amount (LCY)", PJob."Currency Code", 0);
                    Amounts[2] += PJob."Shipment Pend. Amt (LCY)";
                    Amounts[3] += CalcExchange(PJob."Warehouse Availability Amount", PJob."Currency Code", 0);
                end;
            1:
                begin
                    txtCurrency += PJob."Currency Code" + ' (DP)';
                    PJob.CALCFIELDS("Pending Orders Amount (LCY)", "Shipment Pend. Amt (JC)", "Warehouse Availability Amt(JC)");
                    Amounts[1] += CalcExchange(PJob."Pending Orders Amount (LCY)", PJob."Currency Code", 0);
                    Amounts[2] += PJob."Shipment Pend. Amt (JC)";
                    Amounts[3] += CalcExchange(PJob."Warehouse Availability Amt(JC)", PJob."Currency Code", 0);
                end;
            2:
                begin
                    txtCurrency += PJob."Aditional Currency" + ' (DR)';
                    PJob.CALCFIELDS("Pending Orders Amount (LCY)", "Shipment Pend. Amt (ACY)", "Whse. Availability Amt (ACY)");

                    Amounts[1] += CalcExchange(PJob."Pending Orders Amount (LCY)", PJob."Currency Code", 0);
                    Amounts[2] += PJob."Shipment Pend. Amt (ACY)";
                    Amounts[3] += CalcExchange(PJob."Whse. Availability Amt (ACY)", PJob."Currency Code", 0);
                end;
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
      Q13639 MMS 07/07/2021 Visualizar importes agrupados
    }*///end
}







