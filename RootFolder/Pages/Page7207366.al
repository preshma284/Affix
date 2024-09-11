page 7207366 "Job View"
{
    CaptionML = ENU = 'Job View', ESP = 'Anal�tica proyecto';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 349;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                Editable = FALSE;
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
                field("Job.Budgeted Amount"; Job."Budgeted Amount")
                {

                    DrillDown = true;
                    CaptionML = ENU = 'Amount Budget', ESP = 'Importe presupuesto';
                    AutoFormatType = 1;
                    Editable = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountBusget;
                    END;


                }
                field("Job.Realized Amount"; Job."Realized Amount")
                {

                    CaptionML = ENU = 'Amount Realized', ESP = 'Importe realizado';
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowAmountRealized;
                    END;


                }
                field("AmountCostCA_"; AmountCostCA)
                {

                    CaptionML = ENU = 'Cost Theoretical Production Realized', ESP = 'Importe te�rico seg�n producci�n';
                }
                field("CalcDesviation_"; CalcDesviation)
                {

                    CaptionML = ENU = 'Desviation', ESP = 'Desviaci�n';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("CalcPercentageDesviation_"; CalcPercentageDesviation)
                {

                    CaptionML = ENU = '% Desviation', ESP = '% Desviaci�n';
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
        Rec.FILTERGROUP(2);
        Rec.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
        Rec.FILTERGROUP(0);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        NameIndent := 0;
        SetDimCAFilter;
        Job.SETRANGE("Posting Date Filter", PeriodStart, PeriodEnd);
        Job.CALCFIELDS("Budgeted Amount", "Realized Amount");
        CodeOnFormat;
        NameOnFormat;
    END;



    var
        Job: Record 167;
        FunctionQB: Codeunit 7207272;
        NameIndent: Integer;
        PeriodStart: Date;
        PeriodEnd: Date;
        CodeEmphasize: Boolean;
        NameEmphasize: Boolean;
        // JobPeriodLength: Option "Day","Week","Month","Quarter","Year","Period";
        JobPeriodLength: Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";

    procedure AmountCostCA(): Decimal;
    var
        LCurrency: Record 4;
        LAmountCost: Decimal;
    begin
        if Job."Current Piecework Budget" <> '' then
            Job.SETRANGE("Budget Filter", Job."Current Piecework Budget")
        ELSE
            Job.SETRANGE("Budget Filter", Job."Initial Budget Piecework");

        CLEAR(LCurrency);
        LCurrency.InitRoundingPrecision;
        Job.CALCFIELDS("Actual Production Amount", "Production Budget Amount", "Budgeted Amount");
        if Job."Production Budget Amount" <> 0 then
            LAmountCost := ROUND(Job."Budgeted Amount" * (Job."Actual Production Amount" /
                                     Job."Production Budget Amount"), LCurrency."Amount Rounding Precision")
        ELSE
            LAmountCost := 0;

        exit(LAmountCost);
    end;

    procedure CalcDesviation(): Decimal;
    begin
        exit(AmountCostCA - Job."Realized Amount")
    end;

    procedure CalcPercentageDesviation(): Decimal;
    begin
        if (AmountCostCA = 0) then
            if Job."Realized Amount" = 0 then
                exit(0)
            ELSE
                exit(999)
        ELSE
            exit((AmountCostCA - Job."Realized Amount") / (AmountCostCA) * 100);
    end;

    LOCAL procedure SetDimCAFilter();
    begin
        if rec.Totaling <> '' then
            Job.SETFILTER("Analytic Concept Filter", rec.Totaling)
        ELSE
            Job.SETFILTER("Analytic Concept Filter",rec.Code);
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

    procedure ShowAmountBusget();
    var
        GLBudgetEntry: Record 96;
    begin
        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudget(Job)); //JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla Job y se reemplaza por FunctionQB.ReturnBudget
        GLBudgetEntry.SETRANGE("Budget Dimension 1 Code", Job."No.");
        GLBudgetEntry.SETFILTER("Budget Dimension 2 Code", Job.GETFILTER("Reestimation Filter"));
        GLBudgetEntry.SETFILTER("Global Dimension 2 Code", Job.GETFILTER("Analytic Concept Filter"));
        GLBudgetEntry.SETFILTER(Date, Job.GETFILTER("Posting Date Filter"));
        PAGE.RUN(0, GLBudgetEntry);
    end;

    procedure ShowAmountRealized();
    var
        AnalysisViewEntry: Record 365;
    begin
        AnalysisViewEntry.RESET;
        AnalysisViewEntry.SETRANGE("Analysis View Code", Job."Job Analysis View Code");
        AnalysisViewEntry.SETFILTER("Account No.", Job.GETFILTER("Account Filter"));
        AnalysisViewEntry.SETFILTER("Dimension 2 Value Code", Job.GETFILTER("Analytic Concept Filter"));
        AnalysisViewEntry.SETRANGE("Dimension 3 Value Code", Job."No.");
        AnalysisViewEntry.SETFILTER("Posting Date", Job.GETFILTER("Posting Date Filter"));
        PAGE.RUN(558, AnalysisViewEntry);
    end;

    procedure Set(var NewJob: Record 167; NewJobPeriodLength: Enum "Analysis Period Type"; NewAmountType: Option "Net Change","Balance at Date");
    begin
        Job.COPY(NewJob);
        PeriodStart := Job.GETRANGEMIN("Posting Date Filter");
        PeriodEnd := Job.GETRANGEMAX("Posting Date Filter");
        JobPeriodLength := NewJobPeriodLength;
        AmountType := NewAmountType;
        CurrPage.UPDATE(FALSE);
    end;

    // begin
    /*{
      JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla Job y se reemplaza por FunctionQB.ReturnBudget
    }*///end
}







