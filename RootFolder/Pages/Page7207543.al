// controladdin "Microsoft.Dynamics.Nav.Client.BusinessChart" {
// EVENT DataPointClicked(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
// EVENT DataPointDoubleClicked(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
// EVENT AddInReady();
// EVENT Refresh();
// }
page 7207543 "Job Advance Chart"
{
    CaptionML = ENU = 'Job Advance Chart', ESP = 'Avance del proyecto';
    SourceTable = 485;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            usercontrol("BusinessChart"; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                // trigger DataPointClicked(point: DotNet BusinessChartDataPoint);
                // BEGIN
                // END;

                // trigger DataPointDoubleClicked(point: DotNet "BusinessChartDataPoint");
                // BEGIN
                // END;

                trigger AddInReady();
                BEGIN
                END;

                trigger Refresh();
                BEGIN
                END;

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = 'Job Evolution', ESP = 'Evoluci�n de obra';
                Image = Forecast;

                trigger OnAction()
                BEGIN
                    ChartType := ChartType::"Job Evolution";
                    UpdateChart();
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Unit Evolution', ESP = 'Evoluci�n por unidad';
                Image = Forecast;

                trigger OnAction()
                BEGIN
                    ChartType := ChartType::"Unit Evolution";
                    UpdateChart();
                END;


            }
            action("action3")
            {
                CaptionML = ENU = 'Job Advance', ESP = 'Avance de obra';
                Image = BarChart;

                trigger OnAction()
                BEGIN
                    ChartType := ChartType::"Job Advance";
                    UpdateChart();
                END;


            }
            action("action4")
            {
                CaptionML = ENU = 'Stacked columns', ESP = 'Avance por unidad';
                Image = BarChart;


                trigger OnAction()
                BEGIN
                    ChartType := ChartType::"Unit Advance";
                    UpdateChart();
                END;


            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        ChartType := ChartType::"Job Advance";

        CurrPage.UPDATE();
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        UpdateChart;
    END;



    var
        ChartType: Option "Job Advance","Unit Advance","Job Evolution","Unit Evolution";
        XCounter: Integer;
        ForecastDataAmountPiecework: Record 7207392;
        JobLedgerEntry: Record 169;
        Text000: TextConst ENU = 'Master budget advance', ESP = 'Avance ppto. master';
        Text001: TextConst ENU = 'Actual budget advance', ESP = 'Avance ppto. actual';
        Text002: TextConst ENU = 'Real advance', ESP = 'Avance real';
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        Text003: TextConst ENU = 'Piecework', ESP = 'Unidad de obra';
        Text004: TextConst ENU = 'Advance', ESP = 'Avance';
        Text005: TextConst ENU = 'Desviation', ESP = 'Desviaci�n';

    procedure UpdateChart();
    begin
        UpdateData;
        rec.Update(CurrPage.BusinessChart);
    end;

    procedure UpdateData();
    var
        ChartToStatusMap: ARRAY[4] OF Integer;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        ToDate: Date;
        FromDate: Date;
        LJob: Record 167;
        LDataPieceworkForProduction: Record 7207386;
        AmountCostRealized: Decimal;
        Desviation: Decimal;
        LDataPieceworkForProduction2: Record 7207386;
    begin
        rec.Initialize;

        if ChartType = ChartType::"Job Evolution" then begin
            rec."Period Length" := rec."Period Length"::Month;
            rec.SetPeriodXAxis;

            rec.AddMeasure(Text000, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line.AsInteger());
            rec.AddMeasure(Text001, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line.AsInteger());
            rec.AddMeasure(Text002, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line.AsInteger());

            ForecastDataAmountPiecework.RESET;
            ForecastDataAmountPiecework.SETCURRENTKEY("Job No.", "Cod. Budget", "Expected Date", "Entry Type");
            ForecastDataAmountPiecework.SETRANGE("Job No.", Job."No.");
            ForecastDataAmountPiecework.SETFILTER("Cod. Budget", '=%1|%2', Job."Initial Budget Piecework", Job."Current Piecework Budget");
            ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);

            if ForecastDataAmountPiecework.FINDFIRST then
                FromDate := ForecastDataAmountPiecework."Expected Date";

            if ForecastDataAmountPiecework.FINDLAST then
                ToDate := ForecastDataAmountPiecework."Expected Date";

            JobLedgerEntry.RESET;
            JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date");
            JobLedgerEntry.SETRANGE("Job No.", Job."No.");

            if (JobLedgerEntry.FINDFIRST) and (JobLedgerEntry."Posting Date" < FromDate) then
                FromDate := JobLedgerEntry."Posting Date";

            if (JobLedgerEntry.FINDLAST) and (JobLedgerEntry."Posting Date" > ToDate) then
                ToDate := JobLedgerEntry."Posting Date";

            rec.AddPeriods(FromDate, ToDate);
            FOR XCounter := 0 TO rec.CalcNumberOfPeriods(FromDate, ToDate) - 1 DO begin

                ForecastDataAmountPiecework.RESET;
                ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                ForecastDataAmountPiecework.SETRANGE("Job No.", Job."No.");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", Job."Initial Budget Piecework");
                ForecastDataAmountPiecework.SETFILTER("Expected Date", '..%1', rec.GetXValueAsDate(XCounter));
                ForecastDataAmountPiecework.CALCSUMS(Amount);
                rec.SetValue(Text000, XCounter, ForecastDataAmountPiecework.Amount);

                ForecastDataAmountPiecework.RESET;
                ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                ForecastDataAmountPiecework.SETRANGE("Job No.", Job."No.");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                ForecastDataAmountPiecework.SETFILTER("Expected Date", '..%1', rec.GetXValueAsDate(XCounter));
                ForecastDataAmountPiecework.CALCSUMS(Amount);
                rec.SetValue(Text001, XCounter, ForecastDataAmountPiecework.Amount);

                LJob.GET(Job."No.");
                LJob.SETFILTER("Posting Date Filter", '..%1', rec.GetXValueAsDate(XCounter));
                LJob.CALCFIELDS("Usage (Cost) (LCY)");
                rec.SetValue(Text002, XCounter, LJob."Usage (Cost) (LCY)");
            end;
        end;

        if ChartType = ChartType::"Unit Evolution" then begin
            rec."Period Length" := rec."Period Length"::Month;
            rec.SetPeriodXAxis;

            rec.AddMeasure(Text000, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line.AsInteger());
            rec.AddMeasure(Text001, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line.AsInteger());
            rec.AddMeasure(Text002, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line.AsInteger());

            ForecastDataAmountPiecework.RESET;
            ForecastDataAmountPiecework.SETCURRENTKEY("Job No.", "Cod. Budget", "Expected Date", "Entry Type");
            ForecastDataAmountPiecework.SETRANGE("Job No.", Job."No.");
            ForecastDataAmountPiecework.SETFILTER("Cod. Budget", '=%1|%2', Job."Initial Budget Piecework", Job."Current Piecework Budget");
            ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);

            if ForecastDataAmountPiecework.FINDFIRST then
                FromDate := ForecastDataAmountPiecework."Expected Date";

            if ForecastDataAmountPiecework.FINDLAST then
                ToDate := ForecastDataAmountPiecework."Expected Date";

            JobLedgerEntry.RESET;
            JobLedgerEntry.SETCURRENTKEY("Job No.", "Posting Date");
            JobLedgerEntry.SETRANGE("Job No.", Job."No.");

            if (JobLedgerEntry.FINDFIRST) and (JobLedgerEntry."Posting Date" < FromDate) then
                FromDate := JobLedgerEntry."Posting Date";

            if (JobLedgerEntry.FINDLAST) and (JobLedgerEntry."Posting Date" > FromDate) then
                ToDate := JobLedgerEntry."Posting Date";

            rec.AddPeriods(FromDate, ToDate);
            FOR XCounter := 0 TO rec.CalcNumberOfPeriods(FromDate, ToDate) - 1 DO begin

                ForecastDataAmountPiecework.RESET;
                ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                ForecastDataAmountPiecework.SETRANGE("Job No.", Job."No.");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", Job."Initial Budget Piecework");
                ForecastDataAmountPiecework.SETFILTER("Expected Date", '..%1', rec.GetXValueAsDate(XCounter));
                if DataPieceworkForProduction."Piecework Code" <> '' then begin
                    if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then begin
                        ForecastDataAmountPiecework.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling);
                    end ELSE
                        ForecastDataAmountPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                end;

                ForecastDataAmountPiecework.CALCSUMS(Amount);
                rec.SetValue(Text000, XCounter, ForecastDataAmountPiecework.Amount);

                ForecastDataAmountPiecework.RESET;
                ForecastDataAmountPiecework.SETRANGE("Entry Type", ForecastDataAmountPiecework."Entry Type"::Expenses);
                ForecastDataAmountPiecework.SETRANGE("Job No.", Job."No.");
                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
                ForecastDataAmountPiecework.SETFILTER("Expected Date", '..%1', rec.GetXValueAsDate(XCounter));

                if DataPieceworkForProduction."Piecework Code" <> '' then begin
                    if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then begin
                        ForecastDataAmountPiecework.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling);
                    end ELSE
                        ForecastDataAmountPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                end;

                ForecastDataAmountPiecework.CALCSUMS(Amount);
                rec.SetValue(Text001, XCounter, ForecastDataAmountPiecework.Amount);

                LJob.GET(Job."No.");
                LJob.SETFILTER("Posting Date Filter", '..%1', rec.GetXValueAsDate(XCounter));

                if DataPieceworkForProduction."Piecework Code" <> '' then begin
                    if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then begin
                        LJob.SETFILTER("Piecework Filter", DataPieceworkForProduction.Totaling);
                    end ELSE
                        LJob.SETFILTER("Piecework Filter", DataPieceworkForProduction."Piecework Code");
                end;

                LJob.CALCFIELDS("Usage (Cost) (LCY)");
                rec.SetValue(Text002, XCounter, LJob."Usage (Cost) (LCY)");
            end;
        end;


        if ChartType = ChartType::"Unit Advance" then begin
            rec.SetXAxis(Text003, rec."Data Type"::String);
            rec.AddMeasure(Text004, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Column.AsInteger());
            rec.AddMeasure(Text005, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Column.AsInteger());

            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
            if DataPieceworkForProduction."Piecework Code" = '' then
                LDataPieceworkForProduction.SETRANGE(Indentation, 0)
            ELSE begin
                if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then begin
                    LDataPieceworkForProduction.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling);
                    LDataPieceworkForProduction.SETRANGE("Account Type", LDataPieceworkForProduction."Account Type"::Unit);
                end ELSE
                    LDataPieceworkForProduction.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
            end;
            LDataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
            LDataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
            if LDataPieceworkForProduction.FINDFIRST then begin
                XCounter := 0;
                repeat
                    rec.AddColumn(LDataPieceworkForProduction."Piecework Code");

                    LDataPieceworkForProduction2.GET(LDataPieceworkForProduction."Job No.", LDataPieceworkForProduction."Piecework Code");
                    LDataPieceworkForProduction2.CALCFIELDS("Amount Cost Performed (JC)");
                    AmountCostRealized := LDataPieceworkForProduction.AmountCostTheoreticalProduction(Job."Current Piecework Budget", LDataPieceworkForProduction2);
                    Desviation := LDataPieceworkForProduction2.CalculateDesviationPercentage(AmountCostRealized, LDataPieceworkForProduction2."Amount Cost Performed (JC)");

                    rec.SetValue(Text004, XCounter, LDataPieceworkForProduction.AdvanceProductionPercentage);
                    rec.SetValue(Text005, XCounter, Desviation);
                    XCounter += 1;
                until LDataPieceworkForProduction.NEXT = 0;
            end;
        end;

        if ChartType = ChartType::"Job Advance" then begin
           rec.SetXAxis(Text003, rec."Data Type"::String);
            rec.AddMeasure(Text004, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Column.AsInteger());
            rec.AddMeasure(Text005, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Column.AsInteger());

            LDataPieceworkForProduction.RESET;
            LDataPieceworkForProduction.SETRANGE("Job No.", Job."No.");
            LDataPieceworkForProduction.SETRANGE(Indentation, 0);
            LDataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
            LDataPieceworkForProduction.SETFILTER("Budget Filter", Job."Current Piecework Budget");
            if LDataPieceworkForProduction.FINDFIRST then begin
                XCounter := 0;
                repeat
                    rec.AddColumn(LDataPieceworkForProduction."Piecework Code");

                    LDataPieceworkForProduction2.GET(LDataPieceworkForProduction."Job No.", LDataPieceworkForProduction."Piecework Code");
                    LDataPieceworkForProduction2.CALCFIELDS("Amount Cost Performed (JC)");
                    AmountCostRealized := LDataPieceworkForProduction.AmountCostTheoreticalProduction(Job."Current Piecework Budget", LDataPieceworkForProduction2);
                    Desviation := LDataPieceworkForProduction2.CalculateDesviationPercentage(AmountCostRealized, LDataPieceworkForProduction2."Amount Cost Performed (JC)");

                    rec.SetValue(Text004, XCounter, LDataPieceworkForProduction.AdvanceProductionPercentage);
                    rec.SetValue(Text005, XCounter, Desviation);
                    XCounter += 1;
                until LDataPieceworkForProduction.NEXT = 0;
            end;
        end;
    end;

    procedure SetPiecework(pJob: Code[10]; pUO: Code[10]);
    begin
        Job.GET(pJob);
        if pUO <> '' then
            DataPieceworkForProduction.GET(pJob, pUO)
        ELSE
            CLEAR(DataPieceworkForProduction);
    end;

    // begin//end
}







