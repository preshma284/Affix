// controladdin "Microsoft.Dynamics.Nav.Client.BusinessChart" {
// EVENT DataPointClicked(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
// EVENT DataPointDoubleClicked(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
// EVENT AddInReady();
// EVENT Refresh();
// }
page 7207614 "Progress Scorecard Chart"
{
    CaptionML = ENU = 'Progress Scorecard Chart', ESP = 'Avance del proyecto';
    SourceTable = 485;
    PageType = CardPart;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            usercontrol("BusinessChart"; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                // trigger DataPointClicked(point: DotNet "BusinessChartDataPoint");
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


        }

    }







    trigger OnOpenPage()
    BEGIN
        CurrPage.UPDATE();
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        UpdateChart;
    END;



    var
        XCounter: Integer;
        ForecastDataAmountPiecework: Record 7207392;
        Job: Record 167;
        JobLedgerEntry: Record 169;
        Text000: TextConst ESP = 'Avance ppto. master';
        Text001: TextConst ESP = 'Avance ppto. actual';
        Text002: TextConst ESP = 'Avance real';

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

        rec."Period Length" := rec."Period Length"::Month;
        rec.SetPeriodXAxis;
        // rec.AddMeasure(Text000, XCounter, rec."Data Type"::Decimal, rec."Chart Type"::Line);
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
        //JMMA ERROR EN CUADRO MANDO GLOBAL
        if ForecastDataAmountPiecework."Expected Date" = 0D then
            FromDate := Job."Starting Date";

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

    procedure SetJob(pJob: Code[10]);
    begin
        Job.GET(pJob);
    end;

    // begin//end
}






