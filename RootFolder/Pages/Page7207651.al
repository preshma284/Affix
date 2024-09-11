page 7207651 "Tracking by Piecework"
{
    CaptionML = ENU = 'Tracking by Piecework', ESP = 'Seguimiento por unidad de obra';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    SourceTableView = WHERE("Production Unit" = CONST(true), "Type" = FILTER("Piecework" | "Cost Unit"));
    PageType = List;

    layout
    {
        area(content)
        {
            group("Group")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("FORMAT(TextJobDescription)"; FORMAT(TextJobDescription))
                {

                    CaptionClass = FORMAT(TextJobDescription);
                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("TextBudget"; TextBudget)
                {

                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }

            }
            group("group12")
            {

                CaptionML = ENU = 'Options', ESP = 'Opciones';
                field("PeriodType"; PeriodType)
                {

                    CaptionML = ENU = 'See For', ESP = 'Ver por';
                    ToolTipML = ENU = 'Day', ESP = 'D�a';
                    OptionCaptionML = ENU = 'See For', ESP = 'Ver por';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF PeriodType = PeriodType::"Accounting Period" THEN
                            AccountingPerioPeriodTypeOnVal;
                        IF PeriodType = PeriodType::Year THEN
                            YearPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Quarter THEN
                            QuarterPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Month THEN
                            MonthPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Week THEN
                            WeekPeriodTypeOnValidate;
                        IF PeriodType = PeriodType::Day THEN
                            DayPeriodTypeOnValidate;
                        CurrPage.UPDATE;
                    END;


                }
                field("AmountType"; AmountType)
                {

                    CaptionML = ENU = 'See How', ESP = 'Ver como';
                    ToolTipML = ENU = 'Net Change', ESP = 'Saldo periodo';
                    OptionCaptionML = ENU = 'See How', ESP = 'Ver como';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        IF AmountType = AmountType::"Balance at Date" THEN
                            BalanceatDateAmountTypeOnValid;
                        IF AmountType = AmountType::"Net Change" THEN
                            NetChangeAmountTypeOnValidate;
                        CurrPage.UPDATE;
                    END;


                }

            }
            repeater("table")
            {

                IndentationColumn = rec.Indentation;
                IndentationControls = "Piecework Code", Description;
                ShowAsTree = true;
                FreezeColumn = "Description";
                field("Piecework Code"; rec."Piecework Code")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Editable = False;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Production Price"; rec."ProductionPrice")
                {

                    CaptionML = ENU = 'Production Price', ESP = 'Precio producci�n';
                    DecimalPlaces = 2 : 4;
                    Visible = False;
                }
                field("Measure Budget"; rec."Measure Budg. Piecework Sol")
                {

                    Editable = False;
                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Budget Cost Price"; rec."Aver. Cost Price Pend. Budget")
                {

                    CaptionML = ENU = 'Budget Cost Price', ESP = 'Precio coste presupuesto';
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Margin Provided"; rec."CalculateMarginBudgetPerc")
                {

                    CaptionML = ENU = '% MArgin Provided', ESP = '% MArgen previsto';
                    Visible = False;
                }
                field("Total Measurement Production"; rec."Total Measurement Production")
                {

                }
                field("Realized Production Amount"; rec."Amount Production Performed")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Advance"; rec."AdvanceProductionPercentage")
                {

                    CaptionML = ENU = '% Advance', ESP = '% Avance';
                    Visible = False;
                }
                field("RuleAdvance"; rec."AdvanceProductionPercentage")
                {

                    CaptionML = ENU = 'Advance', ESP = 'Avance';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("AmountReal"; AmountCostRealized)
                {

                    CaptionML = ENU = 'Realized Production Average Theoretical Cost', ESP = 'Coste medio producci�n realizada';
                    Editable = False;
                }
                field("Total Measurement Production * Aver. Cost Price Pend. Budget"; rec."Total Measurement Production" * rec."Aver. Cost Price Pend. Budget")
                {

                    CaptionML = ENU = 'Realized Production Theoretical Cost', ESP = 'Coste teorico producci�n realizada';
                    Editable = False;
                }
                field("Amount Cost Performed (JC)"; rec."Amount Cost Performed (JC)")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("DesviationCost"; rec."Amount Cost Performed (JC)")
                {

                    Visible = false;
                }
                field("DesviationCosts"; Desviation)
                {

                    CaptionML = ENU = '% Costs Desviation', ESP = '% Desviaci�n Costes';
                }
                field("MArginReal"; rec."CalculateMarginRealPercentage")
                {

                    CaptionML = ENU = '%Margin Real', ESP = '%Margen real';
                    Visible = False;
                }
                field("QuantityMeasureSubcontract"; rec."CaculateQuantityMeasureSubcontrating")
                {

                    CaptionML = ENU = 'Quantity Measure Subcontracting', ESP = 'Cdad. medida subcontrataciones';
                    Visible = False;
                }
                field("AmountMeasureSubcontracting"; rec."CalculateAmountMeasureSubcontrating")
                {

                    CaptionML = ENU = 'Measured Amount of Subcontracting', ESP = 'Importe medido de subcontrataci�n';
                    Visible = False;
                }
                field("QuantityInvoiced"; rec.CalculateQuantityInvoicedSubcontrating)
                {

                    CaptionML = ENU = 'Subcontracting Invoiced Quantity', ESP = 'Cdad. facturada subcontrataci�n';
                    Visible = False;
                }
                field("AmountInvoiced"; rec."CalculateAmountInvoicedSubcontrating")
                {

                    CaptionML = ENU = 'Subcontracting Invoiced Amount', ESP = 'Importe facutrado subcontrataci�n';
                    Visible = False;
                }
                field("QuantityCredited"; rec."CalculateQuantityCreditMemoSubcontrating")
                {

                    CaptionML = ENU = 'Subcontracting Credited Quantity', ESP = 'Cdad. abonada subcontrataci�n';
                    Visible = False;
                }
                field("SubscriberAmount"; rec."CalculateAmountCreditAmountSubcontrating")
                {

                    CaptionML = ENU = 'Subcontracting Credited Amount', ESP = 'Importe abonado subcontrataci�n';
                    Visible = False;
                }

            }
            group("group40")
            {

                CaptionML = ENU = 'Sales', ESP = 'Totales';
                group("group41")
                {

                    group("group42")
                    {

                        CaptionML = ENU = 'Budget', ESP = 'Presupuesto';
                        field("AmountTotal_"; AmountTotal)
                        {

                            CaptionML = ENU = 'Production Amount', ESP = 'Importe de producci�n';
                            Style = Strong;
                            StyleExpr = TRUE;
                        }
                        field("CostTotal_"; CostTotal)
                        {

                            CaptionML = ENU = 'Cost Amount', ESP = 'Importe coste';
                            Style = Standard;
                            StyleExpr = TRUE;
                        }
                        field("Difference_"; Difference)
                        {

                            CaptionML = ENU = 'Difference', ESP = 'Diferencia';
                            Style = StrongAccent;
                            StyleExpr = TRUE;
                        }

                    }
                    group("group46")
                    {

                        CaptionML = ENU = 'Realized', ESP = 'Realizado';
                        field("AmountProductionReal_"; AmountProductionReal)
                        {

                            CaptionML = ENU = 'Production Amount', ESP = 'Importe de producci�n';
                            Style = Strong;
                            StyleExpr = TRUE;
                        }
                        field("AmountCostReal_"; AmountCostReal)
                        {

                            CaptionML = ENU = 'Realizes Cost Amount', ESP = 'Importe coste realizado';
                            Style = Standard;
                            StyleExpr = TRUE;
                        }
                        field("DifferenceReal_"; DifferenceReal)
                        {

                            CaptionML = ENU = 'Difference made', ESP = 'Diferencia realizada';
                            Style = StrongAccent;
                            StyleExpr = TRUE;
                        }

                    }

                }

            }
            // part("Job Evolution"; 7207543)
            // {
            //     ;
            // }

            part("Job Evolution"; 7207543)
            {
                ;
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207622)
            {
                SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Budget Filter" = FIELD("Budget Filter"), "Filter Date" = FIELD("Filter Date");
            }
            part("part3"; 7207623)
            {
                SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Budget Filter" = FIELD("Budget Filter"), "Filter Date" = FIELD("Filter Date");
            }
            part("part4"; 7207621)
            {

                CaptionML = ESP = 'Presupuesto inicial';
                SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Budget Filter" = FIELD("Budget Filter"), "Filter Date" = FIELD("Filter Date");
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Piecework', ESP = '&Unidad Obra';
                action("action1")
                {
                    ShortCutKey = 'Ctrl+F7';
                    CaptionML = ENU = 'Ledger E&ntries', ESP = '&Movimientos';
                    RunObject = Page 92;
                    RunPageView = SORTING("Job No.", "Posting Date", "Type", "No.", "Entry Type", "Piecework No.");
                    RunPageLink = "Job No." = FIELD("Job No."), "Piecework No." = FIELD("Piecework Code");
                    Image = JobLedger;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Piecework A&nalytics', ESP = 'A&nal�tica Unidad de obra';
                    RunObject = Page 7207560;
                    RunPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Filter Date" = FIELD("Filter Date"), "Budget Filter" = FIELD("Budget Filter");
                    Image = InsertStartingFee;
                }

            }

        }
        area(Processing)
        {

            action("action3")
            {
                CaptionML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                ToolTipML = ENU = 'Previous Period', ESP = 'Periodo anterior';
                Image = PreviousRecord;

                trigger OnAction()
                BEGIN
                    FindPeriod('<=');
                END;


            }
            action("action4")
            {
                CaptionML = ENU = 'Nesxt Period', ESP = 'Periodo siguiente';
                ToolTipML = ENU = 'Nesxt Period', ESP = 'Periodo siguiente';
                Image = NextRecord;


                trigger OnAction()
                BEGIN
                    FindPeriod('>=');
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 07/10/20: - QB 1.06.18 Ver por mes por defecto
        PeriodType := PeriodType::Month;

        AmountType := AmountType::"Balance at Date";
        FindPeriod('');

        TextJobDescription := '';

        IF JobinProgress <> '' THEN
            TextJobDescription := FunctionQB.ShowDescriptionJob(JobinProgress);

        IF JobBudget.GET(rec."Job No.", rec.GETFILTER("Budget Filter")) THEN
            Budget := JobBudget."Budget Name";
        IF rJOb.GET(rec."Job No.") THEN BEGIN

        END;
    END;

    trigger OnAfterGetRecord()
    VAR
        PJob: Record 167;
    BEGIN
        DescripcionIndent := 0;
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget", "Budget Measure", "Total Measurement Production", "Measure Budg. Piecework Sol",
        rec."Amount Production Performed", "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget", "Amount Cost Performed (JC)");

        JobinProgress := Rec.GETFILTER("Budget Filter");
        BudgetinProgress := rec.GETFILTER("Budget Filter");
        AmountCostRealized := rec.AmountCostTheoreticalProduction(BudgetinProgress, Rec);
        Desviation := rec.CalculateDesviationPercentage(AmountCostRealized, rec."Amount Cost Performed (JC)");
        MarginBudgetActual := rec."Amount Production Performed" - AmountCostRealized;
        IF rec."Amount Production Performed" <> 0 THEN
            PercentageMarginBudgetActual := ROUND(MarginBudgetActual * 100 / rec."Amount Production Performed", 0.01);

        DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework Code");
        DataPieceworkForProduction.COPYFILTERS(Rec);
        PJob.GET(rec."Job No.");
        DataPieceworkForProduction.SETFILTER("Budget Filter", PJob."Initial Budget Piecework");

        CostBudgetInitial := rec.AmountCostTheoreticalProduction(PJob."Initial Budget Piecework", DataPieceworkForProduction);
        IF rec."Amount Production Performed" <> 0 THEN
            PercentageMarginBudgetInitial := ROUND((rec."Amount Production Performed" - CostBudgetInitial) * 100 / rec."Amount Production Performed", 0.01);

        PieceworkCodeOnFormat;
        DescriptionOnFormat;
        PriceProductionOnFormat;
        MeasureBudgetOnFormat;
        AmountProductionBudgetOnForma;
        PRiceCostOnFormat;
        AmountCostBudgetOnFormat;
        CalculateMarginBudget;
        MeasureProductionTotalOnF;
        AmountProductionPermormed;
        AdvanceProductionOnFo;
        AmountCostPermormed;
        AmountCostPErmormed02510;
        AmountCostPerformedAmount;
        DesviationOnFormat;
        CalculateMarginRealOn;
        CalculteQuantiyMEasureSubcontratingOnF;
        rec.CalculateAmountMeasureSubcontrating;
        CalculateQuantityInvoicedSubcontrating;
        CalculateAmountInvoicedSubcontratingO;
        rec.CalculateAmountCreditAmountSubcontrating;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //JMMA CurrPage."Job Evolution".PAGE.SetPiecework("Job No.",rec."Piecework Code");

        //JMMACurrPage."Job Evolution".PAGE.UpdateChart;
    END;



    var
        AmountType: Option "Net Change","Balance at Date";
        TextJobDescription: Text[250];
        // PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        PeriodType: Enum "Analysis Period Type";
        JobinProgress: Code[20];
        BudgetinProgress: Code[20];
        FunctionQB: Codeunit 7207272;
        JobBudget: Record 7207407;
        Budget: Text[50];
        DescripcionIndent: Integer;
        AmountCostRealized: Decimal;
        Desviation: Decimal;
        MarginBudgetActual: Decimal;
        PercentageMarginBudgetActual: Decimal;
        DataPieceworkForProduction: Record 7207386;
        CostBudgetInitial: Decimal;
        PercentageMarginBudgetInitial: Decimal;
        TextBudget: Text[50];
        PieceworkCodeEmphasize: Boolean;
        DescriptionEmphasize: Boolean;
        DescriptionIndent: Integer;
        PriceProductionEmphasize: Boolean;
        MeasureBudgetEmphasize: Boolean;
        AmountProductionBudgetEmphasize: Boolean;
        PriceCostBudgetEmphasize: Boolean;
        AmountCostBudegetEmphasize: Boolean;
        MarginProvidedEmphasize: Boolean;
        MeasureProductionTotalEmphasi: Boolean;
        AmountProductionPerformedEmph: Boolean;
        AdvanceEmphasize: Boolean;
        AmountRealEmphasize: Boolean;
        AmountCostPermormedEmphasize: Boolean;
        DesviationCostEmphasize: Boolean;
        DesviationsCostsEmphasize: Boolean;
        MarginRealEmphasize: Boolean;
        QuntityMEasureSubcontratingEmphasize: Boolean;
        AMountMeasureSubcontratingE: Boolean;
        QuantityInvoicedEmphasize: Boolean;
        AmountInvoicedEmphasize: Boolean;
        AmountSubscriberEmphasize: Boolean;
        rJOb: Record 167;

    LOCAL procedure FindPeriod(SearchText: Code[10]);
    var
        Calendar: Record 2000000007;
        AccountingPeriod: Record 50;
        PeriodFormMgt: Codeunit 50324;
    begin
        if Rec.GETFILTER("Filter Date") <> '' then begin
            Calendar.SETFILTER("Period Start", rec.GETFILTER("Filter Date"));
            if not PeriodFormMgt.FindDate('+', Calendar, PeriodType) then
                PeriodFormMgt.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SETRANGE("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText, Calendar, PeriodType);
        if AmountType = AmountType::"Net Change" then
            if Calendar."Period Start" = Calendar."Period end" then
                Rec.SETRANGE("Filter Date", Calendar."Period Start")
            ELSE
                Rec.SETRANGE("Filter Date", Calendar."Period Start", Calendar."Period end")
        ELSE
            Rec.SETRANGE("Filter Date", 0D, Calendar."Period end");
    end;

    procedure AmountTotal(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        Amount: Decimal;
        Job: Record 167;
    begin
        /*{
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.","Job No.");
        DataPieceworkForProduction.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Filter Date",GETFILTER("Filter Date"));
        DataPieceworkForProduction.SETFILTER("Budget Filter",GETFILTER("Budget Filter"));
        if DataPieceworkForProduction.FINDSET then begin
          repeat
            DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Amount Production Budget");
            Amount += DataPieceworkForProduction."Amount Production Budget";
          until DataPieceworkForProduction.NEXT=0;
        end;
        exit(Amount);
        }*/
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Production Budget Amount");
        exit(Job."Production Budget Amount");
    end;

    procedure CostTotal(): Decimal;
    var
        Cost: Decimal;
        DataPieceworkForProduction: Record 7207386;
        Job: Record 167;
    begin
        /*{
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.","Job No.");
        DataPieceworkForProduction.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETFILTER(DataPieceworkForProduction."Filter Date",GETFILTER("Filter Date"));
        DataPieceworkForProduction.SETFILTER("Budget Filter",GETFILTER("Budget Filter"));
        if DataPieceworkForProduction.FINDSET then begin
          repeat
            DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
            Cost += DataPieceworkForProduction.rec."Amount Cost Budget (JC)";
          until DataPieceworkForProduction.NEXT=0;
        end;
        exit(Cost);
        }*/
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Budget Cost Amount");
        exit(Job."Budget Cost Amount");
    end;

    procedure Difference(): Decimal;
    var
        varImp: Decimal;
        varCost: Decimal;
    begin
        exit(AmountTotal - CostTotal);
    end;

    procedure AmountProductionReal(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        varImp: Decimal;
        Job: Record 167;
    begin
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Actual Production Amount");
        exit(Job."Actual Production Amount");
    end;

    procedure AmountCostReal(): Decimal;
    var
        DataPieceworkForProduction: Record 7207386;
        varImp: Decimal;
        Job: Record 167;
    begin
        Job.GET(rec."Job No.");
        Job.SETFILTER("Posting Date Filter", rec.GETFILTER("Filter Date"));
        Job.CALCFIELDS("Usage (Cost) (LCY)");
        exit(Job."Usage (Cost) (LCY)");
    end;

    procedure DifferenceReal(): Decimal;
    var
        varImp: Decimal;
        varCost: Decimal;
    begin
        exit(AmountProductionReal - AmountCostReal);
    end;

    procedure ReceivesJob(PJob: Code[20]; PBudget: Code[20]);
    begin
        JobinProgress := PJob;
        BudgetinProgress := PBudget;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure AccountingPerioPeriodTypOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure YearPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure QuarterPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure MonthPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure WeekPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure DayPeriodTypeOnPush();
    begin
        FindPeriod('');
    end;

    LOCAL procedure DayPeriodTypeOnValidate();
    begin
        DayPeriodTypeOnPush;
    end;

    LOCAL procedure WeekPeriodTypeOnValidate();
    begin
        WeekPeriodTypeOnPush;
    end;

    LOCAL procedure MonthPeriodTypeOnValidate();
    begin
        MonthPeriodTypeOnPush;
    end;

    LOCAL procedure QuarterPeriodTypeOnValidate();
    begin
        QuarterPeriodTypeOnPush;
    end;

    LOCAL procedure YearPeriodTypeOnValidate();
    begin
        YearPeriodTypeOnPush;
    end;

    LOCAL procedure AccountingPerioPeriodTypeOnVal();
    begin
        AccountingPerioPeriodTypOnPush;
    end;

    LOCAL procedure NetChangeAmountTypeOnValidate();
    begin
        NetChangeAmountTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnValid();
    begin
        BalanceatDateAmountTypeOnPush;
    end;

    LOCAL procedure PieceworkCodeOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            PieceworkCodeEmphasize := TRUE;
        end;
    end;

    LOCAL procedure DescriptionOnFormat();
    begin
        DescripcionIndent := rec.Indentation;
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DescriptionEmphasize := TRUE;
        end;
    end;

    LOCAL procedure PriceProductionOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            PriceProductionEmphasize := TRUE;
        end;
    end;

    LOCAL procedure MeasureBudgetOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            MeasureBudgetEmphasize := TRUE;
        end;
    end;

    LOCAL procedure AmountProductionBudgetOnForma();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountProductionBudgetEmphasize := TRUE;
        end;
    end;

    LOCAL procedure PRiceCostOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            PriceCostBudgetEmphasize := TRUE;
        end;
    end;

    LOCAL procedure AmountCostBudgetOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountCostBudegetEmphasize := TRUE;
        end;
    end;

    LOCAL procedure CalculateMarginBudget();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            MarginProvidedEmphasize := TRUE;
        end;
    end;

    LOCAL procedure MeasureProductionTotalOnF();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            MeasureProductionTotalEmphasi := TRUE;
        end;
    end;

    LOCAL procedure AmountProductionPermormed();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountProductionPerformedEmph := TRUE;
        end;
    end;

    LOCAL procedure AdvanceProductionOnFo();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AdvanceEmphasize := TRUE;
        end;
    end;

    LOCAL procedure AmountCostPermormed();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountRealEmphasize := TRUE;
        end;
    end;

    LOCAL procedure AmountCostPErmormed02510();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountCostPermormedEmphasize := TRUE;
        end;
    end;

    LOCAL procedure AmountCostPerformedAmount();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DesviationCostEmphasize := TRUE;
        end;
    end;

    LOCAL procedure DesviationOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            DesviationsCostsEmphasize := TRUE;
        end;

        if Desviation >= 0 then;
    end;

    LOCAL procedure CalculateMarginRealOn();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            MarginRealEmphasize := TRUE;
        end;
    end;

    LOCAL procedure CalculteQuantiyMEasureSubcontratingOnF();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            QuntityMEasureSubcontratingEmphasize := TRUE;
        end;
    end;

    LOCAL procedure CalculateAmountMeasuresubcontratingOnF();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AMountMeasureSubcontratingE := TRUE;
        end;
    end;

    LOCAL procedure CalculateQuantityInvoicedSubcontrating();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            QuantityInvoicedEmphasize := TRUE;
        end;
    end;

    LOCAL procedure CalculateAmountInvoicedSubcontratingO();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountInvoicedEmphasize := TRUE;
        end;
    end;

    LOCAL procedure CalculateAmountSubscriberSubcontratingOnF();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountSubscriberEmphasize := TRUE;
        end;
    end;

    procedure ShowMeasureSubcontrating();
    var
        LPurchRcptLine: Record 121;
        LDataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Unit then begin
            LPurchRcptLine.RESET;
            LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");
            LPurchRcptLine.SETRANGE("Job No.", rec."Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº", rec."Piecework Code");
            LPurchRcptLine.SETRANGE(Type, LPurchRcptLine.Type::Resource);
            LPurchRcptLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", LPurchRcptLine."Order Date");
            PAGE.RUNMODAL(0, LPurchRcptLine);
        end ELSE begin
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LPurchRcptLine.RESET;
                    LPurchRcptLine.SETCURRENTKEY("Job No.", "Piecework NÂº", Type, "No.", "Order Date");
                    LPurchRcptLine.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                    LPurchRcptLine.SETRANGE("Piecework NÂº", LDataPieceworkForProduction."Piecework Code");
                    LPurchRcptLine.SETRANGE(Type, LPurchRcptLine.Type::Resource);
                    LPurchRcptLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", LPurchRcptLine."Order Date");
                    if LPurchRcptLine.FINDSET then begin
                        repeat
                            LPurchRcptLine.MARK(TRUE);
                        until LPurchRcptLine.NEXT = 0;
                    end;

                until LDataPieceworkForProduction.NEXT = 0;
            LPurchRcptLine.SETRANGE("Job No.");
            LPurchRcptLine.SETRANGE("Piecework NÂº");
            LPurchRcptLine.SETRANGE(Type);
            LPurchRcptLine.SETRANGE("No.");
            LPurchRcptLine.SETRANGE("Order Date");
            LPurchRcptLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, LPurchRcptLine);
        end;
    end;

    procedure ShowInvoicedSubcontrating();
    var
        LPurchInvLine: Record 123;
        LDataPieceworkForProduction: Record 7207386;
    begin
        if rec."Account Type" = rec."Account Type"::Unit then begin
            LPurchInvLine.RESET;
            LPurchInvLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
            LPurchInvLine.SETRANGE("Job No.", rec."Job No.");
            LPurchInvLine.SETRANGE("Piecework No.", rec."Piecework Code");
            LPurchInvLine.SETRANGE(Type, LPurchInvLine.Type::Resource);
            LPurchInvLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", LPurchInvLine."Expected Receipt Date");
            PAGE.RUNMODAL(0, LPurchInvLine);
        end ELSE begin
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LPurchInvLine.RESET;
                    LPurchInvLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
                    LPurchInvLine.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                    LPurchInvLine.SETRANGE("Piecework No.", LDataPieceworkForProduction."Piecework Code");
                    LPurchInvLine.SETRANGE(Type, LPurchInvLine.Type::Resource);
                    LPurchInvLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", LPurchInvLine."Expected Receipt Date");
                    if LPurchInvLine.FINDSET then begin
                        repeat
                            LPurchInvLine.MARK(TRUE);
                        until LPurchInvLine.NEXT = 0;
                    end;

                until LDataPieceworkForProduction.NEXT = 0;
            LPurchInvLine.SETRANGE("Job No.");
            LPurchInvLine.SETRANGE("Piecework No.");
            LPurchInvLine.SETRANGE(Type);
            LPurchInvLine.SETRANGE("No.");
            LPurchInvLine.SETRANGE("Expected Receipt Date");
            LPurchInvLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, LPurchInvLine);
        end;
    end;

    procedure ShowSubscriberSubcontrating();
    var
        LPurchCrMemoLine: Record 125;
        LDataPieceworkForProduction: Record 7207386;
    begin

        if rec."Account Type" = rec."Account Type"::Unit then begin
            LPurchCrMemoLine.RESET;
            LPurchCrMemoLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
            LPurchCrMemoLine.SETRANGE("Job No.", rec."Job No.");
            LPurchCrMemoLine.SETRANGE("Piecework No.", rec."Piecework Code");
            LPurchCrMemoLine.SETRANGE(Type, LPurchCrMemoLine.Type::Resource);
            LPurchCrMemoLine.SETRANGE("No.", rec."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date", LPurchCrMemoLine."Expected Receipt Date");
            PAGE.RUNMODAL(0, LPurchCrMemoLine);
        end ELSE begin
            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            LDataPieceworkForProduction.SETFILTER("Piecework Code", rec.Totaling);
            if LDataPieceworkForProduction.FINDSET then
                repeat
                    LPurchCrMemoLine.RESET;
                    LPurchCrMemoLine.SETCURRENTKEY("Job No.", "Piecework No.", Type, "No.", "Expected Receipt Date");
                    LPurchCrMemoLine.SETRANGE("Job No.", LDataPieceworkForProduction."Job No.");
                    LPurchCrMemoLine.SETRANGE("Piecework No.", LDataPieceworkForProduction."Piecework Code");
                    LPurchCrMemoLine.SETRANGE(Type, LPurchCrMemoLine.Type::Resource);
                    LPurchCrMemoLine.SETRANGE("No.", LDataPieceworkForProduction."No. Subcontracting Resource");
                    Rec.COPYFILTER("Filter Date", LPurchCrMemoLine."Expected Receipt Date");
                    if LPurchCrMemoLine.FINDSET then begin
                        repeat
                            LPurchCrMemoLine.MARK(TRUE);
                        until LPurchCrMemoLine.NEXT = 0;
                    end;

                until LDataPieceworkForProduction.NEXT = 0;
            LPurchCrMemoLine.SETRANGE("Job No.");
            LPurchCrMemoLine.SETRANGE("Piecework No.");
            LPurchCrMemoLine.SETRANGE(Type);
            LPurchCrMemoLine.SETRANGE("No.");
            LPurchCrMemoLine.SETRANGE("Expected Receipt Date");
            LPurchCrMemoLine.MARKEDONLY(TRUE);
            PAGE.RUNMODAL(0, LPurchCrMemoLine);
        end;
    end;

    // begin
    /*{
      JAV 13/05/19: - Se amplia a 20 las variables globales JobinProgress y BudgetinProgress
    }*///end
}







