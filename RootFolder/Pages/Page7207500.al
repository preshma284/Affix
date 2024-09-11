page 7207500 "Job State - Purchase FB"
{
    Editable = false;
    CaptionML = ENU = 'Job State - Purchase FB', ESP = 'Estad. Proy. Compras';
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
            field("Pedidos"; Amounts[1])
            {

                CaptionML = ESP = 'Imp. Comp.Aprobados';

                ; trigger OnDrillDown()
                BEGIN
                    ShowComparatives;
                END;


            }
            field("PedidosPtes"; Amounts[2])
            {

                CaptionML = ENU = 'Receive Pend. Order Amount', ESP = 'Imp. pedidos pdtes. recibir';
            }
            field("AlbPtes"; Amounts[3])
            {

                CaptionML = ENU = 'Receive Pend. Shipment Aount', ESP = 'Imp. albaranes pdtes. facturar';

                ; trigger OnDrillDown()
                BEGIN
                    ShowShipPendingPurchaseNormal;
                END;


            }
            field("FRIptes"; Amounts[4])
            {

                CaptionML = ENU = 'FRIS shipment Amount', ESP = 'Imp. albaranes FRIS';

                ; trigger OnDrillDown()
                BEGIN
                    ShowShipPendingPurchaseFRIS;
                END;


            }
            field("TotalbPtes"; Amounts[5])
            {

                CaptionML = ENU = 'Pending Shipment Total', ESP = 'Total albaranes pdtes.';



                ; trigger OnDrillDown()
                BEGIN
                    ShowShipPendingPurchase;
                END;


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
        ComparativeQuoteHeader: Record 7207412;
        pgListaContratos: Page 7207548;
        FunctionQB: Codeunit 7207272;
        useCurrencies: Boolean;
        SeeCurrency: Integer;
        txtCurrency: Text;
        Amounts: ARRAY[20] OF Decimal;
        seeGruped: Boolean;
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

    LOCAL procedure ShowComparatives();
    begin
        ComparativeQuoteHeader.RESET;
        if (seeGruped) then
            ComparativeQuoteHeader.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            ComparativeQuoteHeader.SETRANGE("Job No.", rec."No.");
        ComparativeQuoteHeader.SETFILTER("Generated Contract Doc No.", '<>%1', '');

        CLEAR(pgListaContratos);
        pgListaContratos.SETTABLEVIEW(ComparativeQuoteHeader);
        pgListaContratos.RUNMODAL;
    end;

    procedure ShowShipPendingPurchaseNormal();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETCURRENTKEY("Job No.", "Document No.");
        if (seeGruped) then
            PurchRcptLine.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            PurchRcptLine.SETRANGE("Job No.", rec."No.");
        PurchRcptLine.SETRANGE("Received on FRI", FALSE);
        PAGE.RUN(0, PurchRcptLine);
    end;

    procedure ShowShipPendingPurchaseFRIS();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETCURRENTKEY("Job No.", "Document No.");
        if (seeGruped) then
            PurchRcptLine.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            PurchRcptLine.SETRANGE("Job No.", rec."No.");
        PurchRcptLine.SETRANGE("Received on FRI", TRUE);
        PAGE.RUN(0, PurchRcptLine);
    end;

    procedure ShowShipPendingPurchase();
    var
        PurchRcptLine: Record 121;
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETCURRENTKEY("Job No.", "Document No.");
        if (seeGruped) then
            PurchRcptLine.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            PurchRcptLine.SETRANGE("Job No.", rec."No.");
        PAGE.RUN(0, PurchRcptLine);
    end;

    LOCAL procedure "--------------------------------- Cálculos"();
    begin
    end;

    LOCAL procedure CalContratos(pDivisa: Integer; PJob: Record 167): Decimal;
    var
        impTotal: Decimal;
        impContrato: Decimal;
        "----------------------------------": Integer;
        JobCurrencyExchangeFunction: Codeunit 7207332;
        FromCurrency: Code[20];
        ToCurrency: Code[20];
        i: Integer;
        Amount: Decimal;
        Factor: Decimal;
    begin
        //JAV 12/03/19: - Calcular contratos
        //JAV 06/10/20: - QB 1.06.18 Mejora de velocidad
        ComparativeQuoteHeader.RESET;
        ComparativeQuoteHeader.SETRANGE("Job No.", PJob."No.");
        ComparativeQuoteHeader.SETFILTER("Generated Contract Doc No.", '<>%1', '');
        ComparativeQuoteHeader.CALCSUMS("Amount Purchase");
        impContrato := ComparativeQuoteHeader."Amount Purchase";
        CASE pDivisa OF
            0:
                JobCurrencyExchangeFunction.CalculateCurrencyValue(PJob."No.", impContrato, ComparativeQuoteHeader."Currency Code", '', ComparativeQuoteHeader."Comparative Date", 0, Amount, Factor);
            1:
                JobCurrencyExchangeFunction.CalculateCurrencyValue(PJob."No.", impContrato, ComparativeQuoteHeader."Currency Code", rec."Currency Code", ComparativeQuoteHeader."Comparative Date", 0, Amount, Factor);
            2:
                JobCurrencyExchangeFunction.CalculateCurrencyValue(PJob."No.", impContrato, ComparativeQuoteHeader."Currency Code", rec."Aditional Currency", ComparativeQuoteHeader."Comparative Date", 0, Amount, Factor);
        end;
        exit(Amount);
    end;

    LOCAL procedure CalculateAmouts();
    var
        PJob: Record 167;
    begin
        CLEAR(Amounts);
        txtCurrency := '';
        //Q13639 +
        /*{
        Q13639 MMS 08/07/21
          Si seeGruped es true, se debe recorrer todos los proyectos hijos del proyecto actual para informar de los importes,
          la forma de calcular los importes es ir sumando los de cada proyecto hijo, si es necesairo se hace la conversi�n de divisa, y sumarlas,
          para dar los datos tambi�n en la divisa seleccionada.
        }*/
        //Q13639 MMS 07/07/21 Si seeGruped es false se debe seguir calculando como lo hace actualmente en funci�n de la divisa seleccionada
        AddCurrencyData(SeeCurrency, Rec, FALSE);  //Divisas
        if seeGruped then begin
            //Q13639 MMS 08/07/21 bucle recorriendo 167 de los que sean hijos en campo "Matrix Job it Belongs"
            PJob.SETRANGE("Matrix Job it Belongs", Rec."No.");
            if PJob.FINDFIRST then begin
                repeat
                    AddCurrencyData(SeeCurrency, PJob, TRUE);//Q13639 MMS 08/07/21 sumar todos los valores de los hijos en lugar del rec se pasa la tabla Pjob
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
        ExchangeAmount := 0;
        CASE PCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    PJob.CALCFIELDS("Receive Pend. Order Amt (LCY)", "Shipment Pend. Amt (LCY)", "Shipment FRI Pend. Amt (LCY)");

                    Amounts[1] += CalcExchange(CalContratos(0, PJob), PJob."Currency Code", 0);
                    Amounts[2] += PJob."Receive Pend. Order Amt (LCY)";
                    Amounts[3] += PJob."Shipment Pend. Amt (LCY)" - +PJob."Shipment FRI Pend. Amt (LCY)";
                    Amounts[4] += PJob."Shipment FRI Pend. Amt (LCY)";
                    Amounts[5] += PJob."Shipment Pend. Amt (LCY)";
                end;
            1:
                begin
                    txtCurrency += PJob."Currency Code" + ' (DP)';
                    PJob.CALCFIELDS("Receive Pend. Order Amt (JC)", "Shipment Pend. Amt (JC)", "Shipment FRI Pend. Amt (JC)");

                    Amounts[1] += CalcExchange(CalContratos(1, PJob), PJob."Currency Code", 0);
                    Amounts[2] += PJob."Receive Pend. Order Amt (JC)";
                    Amounts[3] += PJob."Shipment Pend. Amt (JC)" - PJob."Shipment FRI Pend. Amt (JC)";
                    Amounts[4] += PJob."Shipment FRI Pend. Amt (JC)";
                    Amounts[5] += PJob."Shipment Pend. Amt (JC)";
                end;
            2:
                begin
                    txtCurrency += PJob."Aditional Currency" + ' (DR)';
                    PJob.CALCFIELDS("Receive Pend. Order Amt (ACY)", "Shipment Pend. Amt (ACY)", "Shipment FRI Pend. Amt (ACY)");

                    Amounts[1] += CalcExchange(CalContratos(2, PJob), PJob."Currency Code", 0);
                    Amounts[2] += PJob."Receive Pend. Order Amt (ACY)";
                    Amounts[3] += PJob."Shipment Pend. Amt (ACY)" - PJob."Shipment FRI Pend. Amt (ACY)";
                    Amounts[4] += PJob."Shipment FRI Pend. Amt (ACY)";
                    Amounts[5] += PJob."Shipment Pend. Amt (ACY)";
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
      JAV 12/03/19: - Se reajusta todo el formulario y los campos que saca, se elimina lo duplicado y todo lo que sobra
      Q13639 MMS 07/07/2021 Visualizar importes agrupados
    }*///end
}







