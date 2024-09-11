page 7207561 "Piecework Analytic"
{
    CaptionML = ENU = 'Piecework Analytic', ESP = 'Anal�tica proyecto';
    SourceTable = 349;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                Editable = False;
                IndentationColumn = rec.Indentation;
                IndentationControls = Code, Name;
                ShowAsTree = true;
                FreezeColumn = "Name";
                field("Code"; rec."Code")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Name"; rec."Name")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("DataPieceworkForProduction.Amount Cost Budget (JC)"; DataPieceworkForProduction."Amount Cost Budget (JC)")
                {

                    CaptionML = ENU = 'Amount Cost Budget', ESP = 'Importe coste ppto.';
                    Editable = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountBudget;
                    END;


                }
                field("AmountCostTheoricalAdvance"; AmountCostTheoricalAdvance)
                {

                    CaptionML = ENU = 'Advance Theorical Cost', ESP = 'Coste te�rico avance';
                }
                field("CalculateDesviation_"; CalculateDesviation)
                {

                    CaptionML = ENU = 'Desviation', ESP = 'Desviaci�n';
                    Editable = False;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("CalculatePercentageDesviation_"; CalculatePercentageDesviation)
                {

                    CaptionML = ENU = '% Desviation', ESP = '% Desviaci�n';
                    Editable = False

  ;
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
        Rec.SETRANGE(Type, rec.Type::Expenses);
        Rec.FILTERGROUP(0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        AmountCostTheoricalAdvance := 0;
        NameIndent := 0;
        SetDimCAFilter;
        DataPieceworkForProduction.SETRANGE("Filter Date", PeriodStart, PeriodEnd);
        DataPieceworkForProduction.CALCFIELDS("Amount Cost Performed (JC)", "Amount Cost Budget (JC)");
        AmountCostTheoricalAdvance := DataPieceworkForProduction."Amount Cost Budget (JC)" * PercentageAdvance / 100;
        //AmountCostTheoricalAdvance := DataPieceworkForProduction."Amount Cost Performed" * PercentageAdvance / 100;
        CodeOnFormat;
        NameOnFormat;
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        AmountCostTheoricalAdvance: Decimal;
        PeriodStart: Date;
        PeriodEnd: Date;
        // JobPeriodLength: Option "Day","Week","Month","Quarter","Year","Period";
        JobPeriodLength: Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";
        PercentageAdvance: Decimal;
        CodeEmphasize: Boolean;
        NameEmphasize: Boolean;
        NameIndent: Integer;
        FunctionQB: Codeunit 7207272;
        SummaryPieceworkAnalytical: Page 7207560;

    procedure CalculateDesviation(): Decimal;
    begin
        exit(DataPieceworkForProduction."Amount Cost Budget (JC)" - AmountCostTheoricalAdvance)
    end;

    procedure CalculatePercentageDesviation(): Decimal;
    begin
        if AmountCostTheoricalAdvance = 0
          then
            exit(0)
        ELSE
            exit((DataPieceworkForProduction."Amount Cost Budget (JC)" - AmountCostTheoricalAdvance) /
                 (AmountCostTheoricalAdvance) * 100);
    end;
    // procedure Set(var NewDataPieceworkForProduction: Record 7207386; NewJobPeriodLength: Integer; NewAmountType: Option "Net Change","Balance at Date"; PAdvance: Decimal);

    procedure Set(var NewDataPieceworkForProduction: Record 7207386; NewJobPeriodLength: Enum "Analysis Period Type"; NewAmountType: Option "Net Change","Balance at Date"; PAdvance: Decimal);
    begin
        DataPieceworkForProduction.COPY(NewDataPieceworkForProduction);
        PeriodStart := DataPieceworkForProduction.GETRANGEMIN("Filter Date");
        PeriodEnd := DataPieceworkForProduction.GETRANGEMAX("Filter Date");
        JobPeriodLength := NewJobPeriodLength;
        AmountType := NewAmountType;
        PercentageAdvance := PAdvance;

        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure SetDimCAFilter();
    begin
        if rec.Totaling <> '' then
            DataPieceworkForProduction.SETFILTER("Filter Analytical Concept", rec.Totaling)
        ELSE
            DataPieceworkForProduction.SETFILTER("Filter Analytical Concept", rec.Code);
    end;

    procedure ShowAmountBudget();
    var
        ForecastDataAmountPiecework: Record 7207392;
    begin
        ForecastDataAmountPiecework.RESET;
        ForecastDataAmountPiecework.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        if DataPieceworkForProduction.Totaling <> '' then
            ForecastDataAmountPiecework.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling)
        ELSE
            ForecastDataAmountPiecework.SETFILTER("Piecework Code", DataPieceworkForProduction."Piecework Code");

        if rec.Totaling <> '' then
            ForecastDataAmountPiecework.SETFILTER("Analytical Concept", rec.Totaling)
        ELSE
            ForecastDataAmountPiecework.SETFILTER("Analytical Concept", rec.Code);
        ForecastDataAmountPiecework.SETFILTER("Expected Date", DataPieceworkForProduction.GETFILTER("Filter Date"));

        //JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
        ForecastDataAmountPiecework.SETFILTER("Unit Type", '%1|%2', ForecastDataAmountPiecework."Entry Type"::Expenses, ForecastDataAmountPiecework."Entry Type"::Incomes);

        PAGE.RUN(0, ForecastDataAmountPiecework);
    end;

    procedure ShowAmountRealized();
    var
        JobLedgerEntry: Record 169;
    begin
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
        if DataPieceworkForProduction.Totaling <> '' then
            JobLedgerEntry.SETFILTER("Piecework No.", DataPieceworkForProduction.Totaling)
        ELSE
            JobLedgerEntry.SETFILTER("Piecework No.", DataPieceworkForProduction."Piecework Code");

        if rec.Totaling <> '' then
            JobLedgerEntry.SETFILTER("Global Dimension 2 Code", rec.Totaling)
        ELSE
            JobLedgerEntry.SETFILTER("Global Dimension 2 Code", rec.Code);

        JobLedgerEntry.SETFILTER("Posting Date", DataPieceworkForProduction.GETFILTER("Filter Date"));
        PAGE.RUN(0, JobLedgerEntry);
    end;

    LOCAL procedure CodeOnFormat();
    begin
        CodeEmphasize := rec."Dimension Value Type" <> rec."Dimension Value Type"::Standard;
    end;

    LOCAL procedure NameOnFormat();
    begin
        NameEmphasize := rec."Dimension Value Type" <> rec."Dimension Value Type"::Standard;
        NameIndent := rec.Indentation;
    end;

    // begin
    /*{
      JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
    }*///end
}







