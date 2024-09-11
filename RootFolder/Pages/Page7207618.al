// controladdin "Microsoft.Dynamics.Nav.Client.BusinessChart"
// {
//     EVENT DataPointClicked(point: DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
//     EVENT DataPointDoubleClicked(point: DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
//     EVENT AddInReady();
//     EVENT Refresh();
// }
page 7207618 "Job Scorecard Chart"
{
    CaptionML = ENU = 'Job Scorecard Chart', ESP = 'Cuadro de mando';
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
        BudgetSales: Decimal;
        CertificationSales: Decimal;
        BudgetCost: Decimal;
        RealCost: Decimal;
        Job: Record 167;
        JobFilter: Text[250];
        DateFilter: Text;
        Text000: TextConst ENU = 'Certification', ESP = 'Certifiaci�n';
        Text001: TextConst ENU = 'Measure', ESP = 'Medido';
        Text002: TextConst ENU = 'Budget', ESP = 'Presupuesto';
        Text003: TextConst ENU = 'Realized', ESP = 'Realizado';
        Text004: TextConst ENU = 'Production', ESP = 'Coste';
        Text005: TextConst ENU = 'Execution', ESP = 'Producci�n';
        ProdAmount: Decimal;
        RealProd: Decimal;

    procedure UpdateChart();
    begin

        UpdateData;
        rec.Update(CurrPage.BusinessChart);
    end;

    procedure UpdateData();
    var
        ChartToStatusMap: ARRAY[4] OF Integer;
        ToDate: ARRAY[5] OF Date;
        FromDate: ARRAY[5] OF Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        SalesHeaderStatus: Integer;
        MyJob2: Record 7207314;
    begin
        BudgetSales := 0;
        CertificationSales := 0;
        BudgetCost := 0;
        RealCost := 0;
        ProdAmount := 0;
        RealProd := 0;

        rec.Initialize;
        rec.SetXAxis(Text001, rec."Data Type"::String);
        rec.SetChartCondensed(TRUE);
        rec.AddMeasure(Text002, 0, rec."Data Type"::Decimal, rec."Chart Type"::Radar.Asinteger());
        rec.AddMeasure(Text003, 1, rec."Data Type"::Decimal, rec."Chart Type"::Radar.Asinteger());

        //AddMeasure(JobFilter,XCounter,"Data Type"::Decimal,"Chart Type"::Radar);

        Job.RESET;
        Job.SETFILTER("No.", JobFilter);
        if Job.FINDSET then
            repeat
                Job.SETFILTER("Reestimation Filter", Job."Latest Reestimation Code");
                Job.SETFILTER("Posting Date Filter", DateFilter);
                //JMMA
                Job.SETFILTER("Budget Filter", Job."Current Piecework Budget");
                Job.CALCFIELDS("Budget Sales Amount", "Budget Cost Amount", "Certification Amount", "Usage (Cost) (LCY)", "Actual Production Amount", "Production Budget Amount");
                BudgetSales += Job."Budget Sales Amount";
                CertificationSales += Job."Certification Amount";
                BudgetCost += Job."Budget Cost Amount";
                RealCost += Job."Usage (Cost) (LCY)";
                ProdAmount += Job."Production Budget Amount";
                RealProd += Job."Actual Production Amount";
            until Job.NEXT = 0;


        rec.AddColumn(Text000);
        rec.SetValue(Text002, 0, BudgetSales);
        rec.SetValue(Text003, 0, CertificationSales);

        rec.AddColumn(Text004);
        rec.SetValue(Text002, 1, BudgetCost);
        rec.SetValue(Text003, 1, RealCost);

        rec.AddColumn(Text005);
        rec.SetValue(Text002, 2, ProdAmount);
        rec.SetValue(Text003, 2, RealProd);
    end;

    procedure SETFILTER(pJobFilter : Text[250];pDateFilter: Text);
    begin
        JobFilter := pJobFilter;
        DateFilter := pDateFilter;
    end;

    procedure GetDateFilter() : Text[250];
    begin
      exit(DateFilter);
    end;

    procedure GetJobFilter() : Text[250];
    begin
      exit(JobFilter);
    end;

    // begin//end
}







