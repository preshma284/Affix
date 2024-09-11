page 7207343 "Job Chronovision"
{
    CaptionML = ENU = 'Job Chronovision', ESP = 'Cronovisi�n Proyecto';
    SourceTable = 2000000007;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                Editable = False;
                FreezeColumn = "Period Name";
                field("Period Start"; rec."Period Start")
                {

                    CaptionML = ENU = 'Period Star', ESP = 'Inicio periodo';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Period Name"; rec."Period Name")
                {

                    CaptionML = ENU = 'Period Name', ESP = 'Nombre periodo';
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job.Budget Sales Amount"; Job."Budget Sales Amount")
                {

                    DrillDown = true;
                    CaptionML = ENU = 'Income Budget', ESP = 'Presupuesto ingresos';
                    AutoFormatType = 1;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowSalesBudget;
                    END;


                }
                field("Job.Budget Cost Amount"; Job."Budget Cost Amount")
                {

                    CaptionML = ENU = 'Expenses Budget', ESP = 'Presupuesto de gastos';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowCostBudget;
                    END;


                }
                field("Job.CalculateMarginProvided_DL"; Job.CalculateMarginProvided_DL)
                {

                    CaptionML = ENU = 'Provide Margin', ESP = 'Margen previsto';
                }
                field("Job.CalculateMarginProvidedPercentage_DL"; Job.CalculateMarginProvidedPercentage_DL)
                {

                    CaptionML = ENU = '% Margin Provided', ESP = '% MArgen previsto';
                }
                field("Job.Invoiced (LCY)"; Job."Invoiced (LCY)")
                {

                    CaptionML = ENU = 'Invoiced', ESP = 'Facturado (DL)';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowInvoiced;
                    END;


                }
                field("Job.Job in Progress (LCY)"; Job."Job in Progress (LCY)")
                {

                    CaptionML = ENU = 'Job in progress', ESP = 'Obra en curso (DL)';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowJobinProgress;
                    END;


                }
                field("QB_Produccion"; Job."Actual Production Amount")
                {

                    CaptionML = ENU = 'Production', ESP = 'Producci�n';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowProduction();    //JAV 29/11/21: - QB 1.10.02 Se cambia la variable de la que se obtiene la producci�n y su DrillDown
                    END;


                }
                field("Job.Usage (Cost) (LCY)"; Job."Usage (Cost) (LCY)")
                {

                    CaptionML = ENU = 'Realized Expenses', ESP = 'Gastos realizados';

                    ; trigger OnDrillDown()
                    BEGIN
                        ShowCostReal;
                    END;


                }
                field("MarginRealized"; MarginRealized)
                {

                    CaptionML = ENU = 'Margin', ESP = 'Margen';
                }
                field("MarginRealizedPorc"; MarginRealizedPorc)
                {

                    CaptionML = ENU = '% MArgin', ESP = '% Margen';
                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        EXIT(PeriodFormManagement.FindDate(Which, Rec, JobPeriodLength));
    END;

    trigger OnNextRecord(Steps: Integer): Integer
    BEGIN
        EXIT(PeriodFormManagement.NextDate(Steps, Rec, JobPeriodLength));
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetDateFilter;
    END;



    var
        QBTableSubscriber: Codeunit 7207347;
        Job: Record 167;
        // JobPeriodLength: Option "Day","Week","Month","Quarter","Year","Period";
        JobPeriodLength: Enum "Analysis Period Type";
        AmountType: Option "Net Change","Balance at Date";
        PeriodFormManagement: Codeunit 50324;
        FunctionQB: Codeunit 7207272;
        MarginRealized: Decimal;
        MarginRealizedPorc: Decimal;

    procedure ShowSalesBudget();
    var
        GLBudgetEntry: Record 96;
    begin
        SetDateFilter;
        GLBudgetEntry.RESET;
        GLBudgetEntry.SETCURRENTKEY(GLBudgetEntry."Entry No.");
        GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Name", FunctionQB.ReturnBudget(Job)); //JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
        GLBudgetEntry.SETFILTER(GLBudgetEntry."Budget Dimension 1 Code", Job."No.");
        GLBudgetEntry.SETFILTER(GLBudgetEntry."Budget Dimension 2 Code", Job.GETFILTER("Reestimation Filter"));
        GLBudgetEntry.SETRANGE(GLBudgetEntry.Type, GLBudgetEntry.Type::Revenues);
        PAGE.RUN(0, GLBudgetEntry);
    end;

    procedure ShowCostBudget();
    var
        GLBudgetEntry: Record 96;
    begin
        SetDateFilter;
        GLBudgetEntry.RESET;
        GLBudgetEntry.SETCURRENTKEY(GLBudgetEntry."Entry No.");
        GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Name", FunctionQB.ReturnBudget(Job)); //JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
        GLBudgetEntry.SETFILTER(GLBudgetEntry."Budget Dimension 1 Code", Job."No.");
        GLBudgetEntry.SETFILTER(GLBudgetEntry."Budget Dimension 2 Code", Job.GETFILTER("Reestimation Filter"));
        GLBudgetEntry.SETRANGE(GLBudgetEntry.Type, GLBudgetEntry.Type::Expenses);
        PAGE.RUN(0, GLBudgetEntry);
    end;

    procedure ShowInvoiced();
    var
        JobLedgerEntry: Record 169;
    begin
        SetDateFilter;
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date");
        JobLedgerEntry.SETRANGE("Job No.", Job."No.");
        JobLedgerEntry.SETFILTER(Type, Job.GETFILTER("Type Filter"));
        JobLedgerEntry.SETFILTER("Posting Date", Job.GETFILTER("Posting Date Filter"));
        JobLedgerEntry.SETRANGE("Job in progress", FALSE);
        JobLedgerEntry.SETRANGE(JobLedgerEntry."Entry Type", JobLedgerEntry."Entry Type"::Sale);
        PAGE.RUN(0, JobLedgerEntry);
    end;

    procedure ShowJobinProgress();
    var
        JobLedgerEntry: Record 169;
    begin
        SetDateFilter;
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date");
        JobLedgerEntry.SETRANGE("Job No.", Job."No.");
        JobLedgerEntry.SETFILTER(Type, Job.GETFILTER("Type Filter"));
        JobLedgerEntry.SETFILTER("Posting Date", Job.GETFILTER("Posting Date Filter"));
        JobLedgerEntry.SETRANGE("Job in progress", TRUE);
        JobLedgerEntry.SETRANGE(JobLedgerEntry."Entry Type", JobLedgerEntry."Entry Type"::Sale);
        PAGE.RUN(0, JobLedgerEntry);
    end;

    procedure ShowProduction();
    var
        HistProdMeasureLines: Record 7207402;
    begin
        //JAV 29/11/21: - QB 1.10.02 Se cambia la variable de la que se obtiene la producci�n y su DrillDown
        SetDateFilter;
        HistProdMeasureLines.RESET;
        HistProdMeasureLines.SETCURRENTKEY("Job No.", "Piecework No.", "Posting Date");
        HistProdMeasureLines.SETRANGE("Job No.", Job."No.");
        HistProdMeasureLines.SETFILTER("Piecework No.", Job.GETFILTER("Piecework Filter"));
        HistProdMeasureLines.SETFILTER("Posting Date", Job.GETFILTER("Posting Date Filter"));
        PAGE.RUN(0, HistProdMeasureLines);
    end;

    procedure ShowCostReal();
    var
        JobLedgerEntry: Record 169;
    begin
        SetDateFilter;
        JobLedgerEntry.RESET;
        JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date");
        JobLedgerEntry.SETRANGE("Job No.", Job."No.");
        JobLedgerEntry.SETFILTER(Type, Job.GETFILTER("Type Filter"));
        JobLedgerEntry.SETFILTER(JobLedgerEntry."Posting Date", Job.GETFILTER("Posting Date Filter"));
        JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
        JobLedgerEntry.SETFILTER(JobLedgerEntry."Piecework No.", Job.GETFILTER("Piecework Filter"));
        PAGE.RUN(0, JobLedgerEntry);
    end;

    LOCAL procedure SetDateFilter();
    begin
        if AmountType = AmountType::"Net Change" then
            Job.SETRANGE("Posting Date Filter", rec."Period Start", rec."Period end")
        ELSE
            Job.SETRANGE("Posting Date Filter", 0D, rec."Period end");
    end;

    procedure Set(var NewJob: Record 167; NewJobPeriodLength: Integer; NewAmountType: Option "Net Change","Balance at Date");
    // procedure Set(var NewJob: Record 167; NewJobPeriodLength: Enum "Analysis Period Type"; NewAmountType: Enum "Analysis Period Type");

    begin
        Job.COPY(NewJob);
        // JobPeriodLength := NewJobPeriodLength;
        JobPeriodLength := Enum::"Analysis Period Type".FromInteger(NewJobPeriodLength);
        AmountType := NewAmountType;

        Job.CALCFIELDS("Invoiced Price (LCY)", "Budget Sales Amount", "Budget Cost Amount", "Usage (Cost) (LCY)", "Job in Progress (LCY)", "Invoiced (LCY)");
        QBTableSubscriber.TJob_CalMarginRealized(Job, MarginRealized, MarginRealizedPorc);
    end;

    // begin
    /*{
      JAV 28/06/21: - QB 1.09.03 Se elimina el uso del campo "Jobs Budget Code" de la tabla jobs y se reemplaza por FunctionQB.ReturnBudget
      JAV 29/11/21: - QB 1.10.02 Se cambia la variable de la que se obtiene la producci�n y su DrillDown
    }*///end
}







