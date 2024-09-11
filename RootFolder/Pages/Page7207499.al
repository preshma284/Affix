page 7207499 "Job State - General FB"
{
    Editable = false;
    CaptionML = ENU = 'Job State -General', ESP = 'Estad.Proy. General';
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
            field("txtCalculado"; txtCalculado)
            {

                CaptionML = ESP = 'Estado';
                StyleExpr = stCalc;
            }
            group("group239")
            {

                CaptionML = ENU = 'Data By Piecework', ESP = 'Planificado';
                field("Amounts[1]_"; Amounts[1])
                {

                    CaptionML = ENU = 'Budget Sales Amount', ESP = 'Imp. venta an�litico';

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        VerAnalitico(GLBudgetEntry.Type::Revenues);
                    END;


                }
                field("Amounts[5]_"; Amounts[5])
                {

                    CaptionML = ENU = 'Budget Cost Amount', ESP = 'Imp. coste an�litico';

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        VerAnalitico(GLBudgetEntry.Type::Expenses);
                    END;


                }
                field("Amounts[10]_"; Amounts[10])
                {

                    CaptionML = ENU = 'Expected Margin', ESP = 'Margen previsto';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[11]_"; Amounts[11])
                {

                    CaptionML = ENU = '% Expected Margin', ESP = '% margen previsto';
                    DecimalPlaces = 2 : 2;
                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            group("group244")
            {

                CaptionML = ENU = 'Data By Piecework', ESP = 'Ejecutado';
                field("Amounts[2]_"; Amounts[2])
                {

                    CaptionML = ENU = 'Invoiced Price', ESP = 'Ingresos reconocidos';

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        VerFacturado;
                    END;


                }
                field("Amounts[6]_"; Amounts[6])
                {

                    CaptionML = ENU = 'Usage (Cost)', ESP = 'Consumo (p.coste)';

                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        VerCoste;
                    END;


                }
                field("Amounts[12]_"; Amounts[12])
                {

                    CaptionML = ENU = 'Performed Margin', ESP = 'Margen realizado';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Amounts[13]_"; Amounts[13])
                {

                    CaptionML = ENU = '% Performed Margin', ESP = '% margen realizado';
                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            group("group249")
            {

                CaptionML = ENU = 'Data By Piecework', ESP = 'Datos presupuesto actual';
                field("Amounts[3]_"; Amounts[3])
                {

                    CaptionML = ENU = 'Production Budget Amount', ESP = 'Importe venta';
                }
                field("Amounts[7]_"; Amounts[7])
                {

                    CaptionML = ENU = 'Direct Cost Amount PieceWork', ESP = 'Importe costes directos UO';
                    Editable = False;
                }
                field("Amounts[8]_"; Amounts[8])
                {

                    CaptionML = ENU = 'Indirect Cost Amount Piecework', ESP = 'Importe costes indirectos UO';
                    Editable = False;
                }
                field("Amounts[14]_"; Amounts[14])
                {

                    CaptionML = ENU = '% Margin Over Total Cost', ESP = '% margen sobre costes directos';
                    Editable = FALSE;
                }
                field("Amounts[15]_"; Amounts[15])
                {

                    CaptionML = ENU = '% Indirect Cost Over Total Costs', ESP = '% de coste indirecto sobre total costes';
                    Editable = False;
                }
                field("Amounts[16]_"; Amounts[16])
                {

                    CaptionML = ESP = 'K prevista';
                }
                field("Amounts[17]_"; Amounts[17])
                {

                    CaptionML = ENU = 'K', ESP = 'K real';
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 08/04/20: Si se usan las divisas en los proyectos
        JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CalculateAmouts;
    END;



    var
        QuoBuildingSetup: Record 7207278;
        JobLedgerEntry: Record 169;
        GLBudgetEntry: Record 96;
        JobBudget: Record 7207407;
        FunctionQB: Codeunit 7207272;
        JobLedgerEntries: Page 92;
        GLBudgetEntries: Page 120;
        useCurrencies: Boolean;
        SeeCurrency: Integer;
        txtCurrency: Text;
        Amounts: ARRAY[20] OF Decimal;
        txtCalculado: Text;
        stCalc: Text;
        seeGruped: Boolean;
        StyleText: Text;
        k: Decimal;
        ik: ARRAY[10] OF Decimal;
        kplanned: Decimal;
        QBCurrencyCalcsFunctions: Codeunit 7207358;
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

    LOCAL procedure VerAnalitico(pTipo: Option);
    begin
        //JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla Job y se reemplaza por FunctionQB.ReturnBudget
        // if (Rec."Jobs Budget Code" = '') then begin
        //  QuoBuildingSetup.GET;
        //  Rec."Jobs Budget Code" := QuoBuildingSetup."Budget for Jobs";
        //  Rec.MODIFY;
        //  COMMIT;
        // end;

        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudget(Rec));
        //Q13649+
        if seeGruped then
            GLBudgetEntry.SETFILTER("Budget Dimension 1 Code", Rec."No." + '*')
        ELSE
            GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", Rec."No.");
        //Q13649-
        GLBudgetEntry.SETRANGE("Budget Dimension 2 Code", Rec."Reestimation Filter");
        GLBudgetEntry.SETRANGE(Type, pTipo);
        Rec.FILTERGROUP(4);  //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas
        GLBudgetEntry.SETFILTER(Date, Rec.GETFILTER("Posting Date Filter"));
        Rec.FILTERGROUP(0);  //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas

        CLEAR(GLBudgetEntries);
        GLBudgetEntries.SETTABLEVIEW(GLBudgetEntry);
        GLBudgetEntries.RUNMODAL;
    end;

    LOCAL procedure VerFacturado();
    begin
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Sale);
        //Q13649+
        if seeGruped then
            JobLedgerEntry.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            JobLedgerEntry.SETRANGE("Job No.", rec."No.");
        //Q13649-
        Rec.FILTERGROUP(4);  //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas
        JobLedgerEntry.SETFILTER(Type, Rec.GETFILTER("Type Filter"));
        JobLedgerEntry.SETFILTER("Posting Date", Rec.GETFILTER("Posting Date Filter"));
        JobLedgerEntry.SETFILTER("Piecework No.", Rec.GETFILTER("Piecework Filter"));
        Rec.FILTERGROUP(0);  //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas

        CLEAR(JobLedgerEntries);
        JobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
        JobLedgerEntries.RUNMODAL;
    end;

    LOCAL procedure VerCoste();
    begin
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
        //Q13649+
        if seeGruped then
            JobLedgerEntry.SETFILTER("Job No.", rec."No." + '*')
        ELSE
            JobLedgerEntry.SETRANGE("Job No.", rec."No.");
        //Q13649-

        Rec.FILTERGROUP(4);  //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas
        JobLedgerEntry.SETFILTER(Type, Rec.GETFILTER("Type Filter"));
        JobLedgerEntry.SETFILTER("Posting Date", Rec.GETFILTER("Posting Date Filter"));
        JobLedgerEntry.SETFILTER("Piecework No.", Rec.GETFILTER("Piecework Filter"));
        Rec.FILTERGROUP(0);  //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas

        CLEAR(JobLedgerEntries);
        JobLedgerEntries.SETTABLEVIEW(JobLedgerEntry);
        JobLedgerEntries.RUNMODAL;
    end;

    LOCAL procedure "--------------------------------- Cálculos"();
    begin
    end;

    LOCAL procedure CalculateAmouts();
    var
        PJob: Record 167;
    begin
        txtCalculado := '';
        stCalc := '';
        if JobBudget.GET(rec."No.", rec."Current Piecework Budget") then begin
            txtCalculado := 'Calculado';
            stCalc := 'Favorable';
            if JobBudget."Pending Calculation Budget" then begin
                txtCalculado := 'Recalcular';
                stCalc := 'Unfavorable';
            end ELSE if JobBudget."Pending Calculation Analitical" then begin
                txtCalculado := 'Falta anal�tico';
                stCalc := 'Unfavorable';
            end;
        end;

        FunctionQB.ReturnBudget(Rec); //JAV 28/06/21: - QB 1.09.03 Por si ha cambiado se informa el campo del presupuesto de la tabla Job para los c�lculos posteriores

        txtCurrency := '';
        //
        //Q13639 + Calculo de los Importes en las Divisas
        CLEAR(Amounts);
        CLEAR(ik);

        AddCurrencyData(SeeCurrency, Rec, FALSE);  //Q13639 MMS 07/07/21 Si seeGruped es false se debe seguir calculando como lo hace actualmente en funci�n de la divisa seleccionada
        if seeGruped then begin
            PJob.RESET;
            PJob.SETRANGE("Matrix Job it Belongs", Rec."No."); //Q13639 MMS 07/07/21 bucle recorriendo 167 de los que sean hijos
            if PJob.FINDFIRST then begin
                repeat
                    //Q13639 MMS 07/07/21 volvera hacer esto pero sumando en lugar del rec la tabla job que recorra
                    AddCurrencyData(SeeCurrency, PJob, TRUE); //Q13639 MMS 07/07/21 sumar todos los valores de los hijos
                until PJob.NEXT = 0;
            end;
        end;

        //Datos que suman otros totales
        Amounts[10] := Amounts[1] - Amounts[5];
        Amounts[11] := 0;                        //JAV 09.12.21: - QB 1.10.07 Se cambia el c�lculo que no lo hac�a correctamente en las divisas   //CalculateMarginProvidedPercentage_DL;
        Amounts[12] := Amounts[2] - Amounts[6];
        Amounts[13] := 0;

        if Amounts[1] <> 0 then   //JAV 09.12.21: - QB 1.10.07 Se cambia el c�lculo que no lo hac�a correctamente en las divisas
            Amounts[11] := ROUND(Amounts[10] / Amounts[1] * 100, 0.01);

        if Amounts[2] <> 0 then
            Amounts[13] := ROUND(Amounts[12] / Amounts[2] * 100, 0.01);

        //Margenes
        Amounts[14] := 0;
        Amounts[15] := 0;

        PJob.CALCFIELDS("Production Budget Amount", "Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
        if (PJob."Direct Cost Amount PieceWork") <> 0 then
            Amounts[14] := ROUND((PJob."Production Budget Amount" - PJob."Direct Cost Amount PieceWork") * 100 / PJob."Direct Cost Amount PieceWork", 0.01);
        if (PJob."Direct Cost Amount PieceWork") <> 0 then
            Amounts[15] := ROUND(PJob."Indirect Cost Amount Piecework" * 100 / PJob."Direct Cost Amount PieceWork", 0.01);

        //Calculo de la K
        if (ik[2] <> 0) then
            k := ik[1] / ik[2]
        ELSE
            k := 0;

        if (ik[4] <> 0) then
            kplanned := ik[3] / ik[4]
        ELSE
            kplanned := 0;

        Amounts[16] := kplanned;
        Amounts[17] := k;

        //Q13639 +
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
        //Q13639 +
        ExchangeAmount := 0;
        if PJob."Latest Reestimation Code" <> '' then
            PJob.SETFILTER("Reestimation Filter", PJob."Latest Reestimation Code") //JMMA incluye reestimaci�n
        ELSE
            PJob.SETFILTER("Reestimation Filter", '');

        //JAV 09/12/21: - QB 1.10.07 Filtrar por fechas
        Rec.FILTERGROUP(4);
        PJob.SETFILTER("Posting Date Filter", Rec.GETFILTER("Posting Date Filter"));
        Rec.FILTERGROUP(0);

        CASE PCurrency OF
            0:
                begin
                    txtCurrency := 'Local (DL)';
                    PJob.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount", "Invoiced Price (LCY)", "Usage (Cost) (LCY)", "Production Budget Amount LCY", "Direct Cost Amount PW LCY", "Indirect Cost Amount PW LCY");

                    ik[1] += PJob."Invoiced Price (LCY)";
                    ik[2] += PJob."Usage (Cost) (LCY)";
                    ik[3] += PJob."Production Budget Amount LCY";
                    ik[4] += PJob."Direct Cost Amount PW LCY" + PJob."Indirect Cost Amount PW LCY";

                    Amounts[1] += CalcExchange(PJob."Budget Sales Amount", PJob."Currency Code", 1);
                    Amounts[5] += CalcExchange(PJob."Budget Cost Amount", PJob."Currency Code", 0);
                    Amounts[2] += CalcExchange(PJob."Invoiced Price (LCY)", PJob."Currency Code", 1);
                    Amounts[6] += CalcExchange(PJob."Usage (Cost) (LCY)", PJob."Currency Code", 0);
                    Amounts[3] += CalcExchange(PJob."Production Budget Amount LCY", PJob."Currency Code", 0);         //JAV 30/11/21: - QB 1.10.03 No se le daba valor al campo
                    Amounts[7] += CalcExchange(PJob."Direct Cost Amount PW LCY", PJob."Currency Code", 0);
                    Amounts[8] += CalcExchange(PJob."Indirect Cost Amount PW LCY", PJob."Currency Code", 0);
                end;
            1:
                begin
                    txtCurrency := rec."Currency Code" + ' (DP)';
                    PJob.CALCFIELDS("Invoiced Price (JC)", "Usage (Cost) (JC)", "Production Budget Amount (JC)", "Direct Cost Amount PW (JC)", "Indirect Cost Amount PW (JC)");

                    ik[1] += PJob."Invoiced Price (JC)";
                    ik[2] += PJob."Usage (Cost) (JC)";
                    ik[3] += PJob."Production Budget Amount (JC)";
                    ik[4] += PJob."Direct Cost Amount PW (JC)" + PJob."Indirect Cost Amount PW (JC)";

                    Amounts[1] += CalcExchange(PJob.CalcBudgetSalesAmount_PC, PJob."Currency Code", 1);
                    Amounts[5] += CalcExchange(PJob.CalcBudgetCostAmount_PC, PJob."Currency Code", 0);
                    Amounts[2] += CalcExchange(PJob."Invoiced Price (JC)", PJob."Currency Code", 1);
                    Amounts[6] += CalcExchange(PJob."Usage (Cost) (JC)", PJob."Currency Code", 0);
                    Amounts[3] += CalcExchange(PJob."Production Budget Amount (JC)", PJob."Currency Code", 0);
                    Amounts[7] += CalcExchange(PJob."Direct Cost Amount PW (JC)", PJob."Currency Code", 0);
                    Amounts[8] += CalcExchange(PJob."Indirect Cost Amount PW (JC)", PJob."Currency Code", 0);
                end;
            2:
                begin
                    txtCurrency := PJob."Aditional Currency" + ' (DR)';
                    PJob.CALCFIELDS("Invoiced Price (ACY)", "Usage (Cost) (ACY)", "Production Budget Amount (ACY)", "Direct Cost Amount PW (ACY)", "Indirect Cost Amount PW (ACY)");

                    ik[1] += PJob."Invoiced Price (ACY)";
                    ik[2] += PJob."Usage (Cost) (ACY)";
                    ik[3] += PJob."Production Budget Amount (ACY)";
                    ik[4] += PJob."Direct Cost Amount PW (ACY)" + PJob."Indirect Cost Amount PW (ACY)";

                    Amounts[1] += CalcExchange(QBCurrencyCalcsFunctions.CalcAmt_OtherCurrency(1, 1, PJob."No."), PJob."Currency Code", 1);
                    Amounts[5] += CalcExchange(QBCurrencyCalcsFunctions.CalcAmt_OtherCurrency(2, 1, PJob."No."), PJob."Currency Code", 0);
                    Amounts[2] += CalcExchange(PJob."Invoiced Price (ACY)", PJob."Currency Code", 1);
                    Amounts[6] += CalcExchange(PJob."Usage (Cost) (ACY)", PJob."Currency Code", 0);
                    Amounts[3] += CalcExchange(PJob."Production Budget Amount (ACY)", PJob."Currency Code", 0);
                    Amounts[7] += CalcExchange(PJob."Direct Cost Amount PW (ACY)", PJob."Currency Code", 0);
                    Amounts[8] += CalcExchange(PJob."Indirect Cost Amount PW (ACY)", PJob."Currency Code", 0);
                end;
        end;
        PCurrency := ExchangeType;
        //Q13639 -
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
      JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla Job y se reemplaza por FunctionQB.ReturnBudget
                                 Se informa el campo del presupuesto de la tabla Job correctamente
      Q13639 MMS 07/7/2021 Visualizar importes agrupados
    }*///end
}







