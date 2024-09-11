page 7207503 "Job State - Production FB"
{
    Editable = false;
    CaptionML = ENU = 'Job State - Production FB', ESP = 'Estad. Proy. Producci�n';
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

                CaptionML = ENU = 'Standar Invoice', ESP = 'Facturas est�ndar';

                ; trigger OnDrillDown()
                BEGIN
                    ShowInvoiced(OptTypeInvoice::Standar);
                END;


            }
            field("Amounts[2]_"; Amounts[2])
            {

                CaptionML = ENU = 'Store', ESP = 'Acopios';

                ; trigger OnDrillDown()
                BEGIN
                    ShowInvoiced(OptTypeInvoice::"Advance by Store");
                END;


            }
            field("Amounts[3]_"; Amounts[3])
            {

                CaptionML = ENU = 'Equipment', ESP = 'Maquinaria';

                ; trigger OnDrillDown()
                BEGIN
                    ShowInvoiced(OptTypeInvoice::"Eqipament Advance");
                END;


            }
            field("Amounts[4]_"; Amounts[4])
            {

                CaptionML = ENU = 'InvoicedReviewPrice', ESP = 'Revisi�n precios';

                ; trigger OnDrillDown()
                BEGIN
                    ShowInvoiced(OptTypeInvoice::"Price Review");
                END;


            }
            field("Amounts[5]_"; Amounts[5])
            {

                CaptionML = ENU = 'Invoiced', ESP = 'Facturado';
                Style = Standard;
                StyleExpr = TRUE;
            }
            field("Amounts[6]_"; Amounts[6])
            {

                CaptionML = ENU = 'Job in Progress', ESP = 'Obra en curso';
            }
            field("Amounts[7]_"; Amounts[7])
            {

                CaptionML = ENU = 'Actual Production Amount', ESP = 'Importe producci�n real';
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
        OptTypeInvoice: Option "Standar","Eqipament Advance","Advance by Store","Price Review";
        FunctionQB: Codeunit 7207272;
        useCurrencies: Boolean;
        SeeCurrency: Integer;
        txtCurrency: Text;
        Amounts: ARRAY[20] OF Decimal;
        seeGruped: Boolean;
        StyleText: Text;
        QBCurrencyCalcsFunctions: Codeunit 7207358;
        InvoicedSTD: Decimal;
        InvoicedStore: Decimal;
        InvoicedEquipament: Decimal;
        InvoicedReviewPrice: Decimal;
        "----------------------------------": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
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

    procedure ShowInvoiced(OptTypeInvoice: Option "Standar","Eqipament Advance","Advance by Store","Price Review");
    var
        JobLedgerEntry: Record 169;
    begin
        JobLedgerEntry.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", "Job in progress", "Job Sale Doc. Type");
        //Q13649+
        if seeGruped then
            JobLedgerEntry.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            JobLedgerEntry.SETRANGE("Job No.", rec."No.");
        //Q13649-
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Sale);
        Rec.COPYFILTER("Posting Date Filter", JobLedgerEntry."Posting Date");
        JobLedgerEntry.SETRANGE("Job in progress", FALSE);
        JobLedgerEntry.SETRANGE("Job Sale Doc. Type", OptTypeInvoice);
        PAGE.RUN(0, JobLedgerEntry);
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
            PJob.SETRANGE("Matrix Job it Belongs", Rec."No."); //Q13639 MMS 07/07/21 bucle recorriendo 167 de los que sean hijos
            repeat
                //Q13639 MMS 07/07/21 volvera hacer esto pero sumando en lugar del rec la tabla job que recorra
                AddCurrencyData(SeeCurrency, PJob, TRUE); //Q13639 MMS 07/07/21 sumar todos los valores de los hijos
            until PJob.NEXT = 0;
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
                    PJob.CALCFIELDS("Job in Progress (LCY)", "Actual Production Amount");

                    PJob.SETRANGE("Budget Filter", PJob."Current Piecework Budget");
                    PJob.SETRANGE("Job Sales Doc Type Filter", PJob."Job Sales Doc Type Filter"::"Advance by Store");
                    PJob.CALCFIELDS("Invoiced (LCY)");
                    InvoicedStore := PJob."Invoiced (LCY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", PJob."Job Sales Doc Type Filter"::"Eqipament Advance");
                    PJob.CALCFIELDS("Invoiced (LCY)");
                    InvoicedEquipament := PJob."Invoiced (LCY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Price Review");
                    PJob.CALCFIELDS("Invoiced (LCY)");
                    InvoicedReviewPrice := PJob."Invoiced (LCY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::Standar);
                    PJob.CALCFIELDS("Invoiced (LCY)");
                    InvoicedSTD := PJob."Invoiced (LCY)";

                    Rec.SETRANGE("Job Sales Doc Type Filter");
                    Rec.CALCFIELDS("Invoiced (LCY)");

                    Amounts[1] += CalcExchange(InvoicedSTD, PJob."Currency Code", 1);
                    Amounts[2] += CalcExchange(InvoicedStore, PJob."Currency Code", 1);
                    Amounts[3] += CalcExchange(InvoicedEquipament, PJob."Currency Code", 1);
                    Amounts[4] += CalcExchange(InvoicedReviewPrice, PJob."Currency Code", 1);
                    Amounts[5] += CalcExchange(PJob."Invoiced (LCY)", PJob."Currency Code", 1);
                    Amounts[6] += CalcExchange(PJob."Job in Progress (LCY)", PJob."Currency Code", 1);
                    Amounts[7] += CalcExchange(PJob."Actual Production Amount", PJob."Currency Code", 1);
                end;
            1:
                begin
                    txtCurrency := PJob."Currency Code" + ' (DP)';
                    PJob.CALCFIELDS("Job in Progress (JC)", "Actual Production Amount (JC)");

                    PJob.SETRANGE("Budget Filter", PJob."Current Piecework Budget");
                    PJob.SETRANGE("Job Sales Doc Type Filter", PJob."Job Sales Doc Type Filter"::"Advance by Store");
                    PJob.CALCFIELDS("Invoiced (JC)");
                    InvoicedStore := PJob."Invoiced (JC)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", PJob."Job Sales Doc Type Filter"::"Eqipament Advance");
                    PJob.CALCFIELDS("Invoiced (JC)");
                    InvoicedEquipament := PJob."Invoiced (JC)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", PJob."Job Sales Doc Type Filter"::"Price Review");
                    PJob.CALCFIELDS("Invoiced (JC)");
                    InvoicedReviewPrice := PJob."Invoiced (JC)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::Standar);
                    PJob.CALCFIELDS("Invoiced (JC)");
                    InvoicedSTD := PJob."Invoiced (JC)";

                    PJob.SETRANGE("Job Sales Doc Type Filter");
                    PJob.CALCFIELDS("Invoiced (JC)");

                    Amounts[1] += CalcExchange(InvoicedSTD, PJob."Currency Code", 1);
                    Amounts[2] += CalcExchange(InvoicedStore, PJob."Currency Code", 1);
                    Amounts[3] += CalcExchange(InvoicedEquipament, PJob."Currency Code", 1);
                    Amounts[4] += CalcExchange(InvoicedReviewPrice, PJob."Currency Code", 1);
                    Amounts[5] += CalcExchange(rec."Invoiced (JC)", PJob."Currency Code", 1);
                    Amounts[6] += CalcExchange(rec."Job in Progress (JC)", PJob."Currency Code", 1);
                    Amounts[7] += CalcExchange(rec."Actual Production Amount (JC)", PJob."Currency Code", 1);
                end;
            2:
                begin
                    txtCurrency := PJob."Aditional Currency" + ' (DR)';
                    PJob.CALCFIELDS("Job in Progress (ACY)", "Actual Production Amount (ACY)");

                    PJob.SETRANGE("Budget Filter", rec."Current Piecework Budget");
                    PJob.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Advance by Store");
                    PJob.CALCFIELDS("Invoiced (ACY)");
                    InvoicedStore := rec."Invoiced (ACY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Eqipament Advance");
                    PJob.CALCFIELDS("Invoiced (ACY)");
                    InvoicedEquipament := rec."Invoiced (ACY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", rec."Job Sales Doc Type Filter"::"Price Review");
                    PJob.CALCFIELDS("Invoiced (ACY)");
                    InvoicedReviewPrice := PJob."Invoiced (ACY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter", PJob."Job Sales Doc Type Filter"::Standar);
                    Rec.CALCFIELDS("Invoiced (ACY)");
                    InvoicedSTD := PJob."Invoiced (ACY)";

                    PJob.SETRANGE("Job Sales Doc Type Filter");
                    PJob.CALCFIELDS("Invoiced (ACY)");

                    Amounts[1] += CalcExchange(InvoicedSTD, PJob."Currency Code", 1);
                    Amounts[2] += CalcExchange(InvoicedStore, PJob."Currency Code", 1);
                    Amounts[3] += CalcExchange(InvoicedEquipament, PJob."Currency Code", 1);
                    Amounts[4] += CalcExchange(InvoicedReviewPrice, PJob."Currency Code", 1);
                    Amounts[5] += CalcExchange(PJob."Invoiced (ACY)", PJob."Currency Code", 1);
                    Amounts[6] += CalcExchange(PJob."Job in Progress (ACY)", PJob."Currency Code", 1);
                    Amounts[7] += CalcExchange(PJob."Actual Production Amount (ACY)", PJob."Currency Code", 1);
                end
              ;
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
      Q13639 MMS 08/7/2021 Visualizar importes agrupados
    }*///end
}







