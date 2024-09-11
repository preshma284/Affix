// controladdin "Microsoft.Dynamics.Nav.Client.BusinessChart"
// {
//     EVENT DataPointClicked(point: DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
//     EVENT DataPointDoubleClicked(point: DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
//     EVENT AddInReady();
//     EVENT Refresh();
// }
page 7207544 "Seguimiento de proyectos chart"
{
    CaptionML = ENU = 'Project control', ESP = 'Seguimiento de proyectos';
    SourceTable = 485;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field("StatusText"; StatusText)
            {

                CaptionML = ENU = 'Status Text', ESP = 'Texto de estado';
                ShowCaption = false;
            }
            usercontrol("BusinessChart"; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                // trigger DataPointClicked(point: DotNet BusinessChartDataPoint);
                // BEGIN
                //     rec.SetDrillDownIndexes(point);
                //     RecJob.FINDSET;
                //     RecJob.NEXT(rec."Drill-Down X Index");
                //     PAGE.RUN(PAGE::"Operative Jobs Card", RecJob);
                // END;

                // trigger DataPointDoubleClicked(point: DotNet "BusinessChartDataPoint");
                // BEGIN
                // END;

                trigger AddInReady();
                BEGIN
                    ChartIsReady := TRUE;
                    UpdateChart();
                END;

                trigger Refresh();
                BEGIN
                    IF ChartIsReady THEN
                        UpdateChart();
                END;

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {

                CaptionML = ESP = 'Mostrar';
                action("action1")
                {
                    CaptionML = ENU = 'Open', ESP = 'Columnas';

                    trigger OnAction()
                    BEGIN
                        //OpenJobCard;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Stacked columns', ESP = 'Columnas apiladas';


                    trigger OnAction()
                    BEGIN
                        //dafdasfasf
                    END;


                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        StatusText := Text000;
    END;



    var
        RecJob: Record 167;
        MyJobs: Record 9154;
        StatusText: Text[250];
        ChartIsReady: Boolean;
        XCounter: Integer;
        Text000: TextConst ESP = 'Seguimiento de Mis proyectos';
        Text001: TextConst ESP = 'Mis Proyectos';
        Text002: TextConst ESP = 'Imp. coste ppto.';
        Text003: TextConst ESP = 'Consumo realizado';

    LOCAL procedure UpdateChart();
    begin
        if not ChartIsReady then
            exit;

        rec.Initialize;

        rec.SetXAxis(Text001, rec."Data Type"::String);
        rec.AddMeasure(Text002, 1, rec."Data Type"::Decimal, rec."Chart Type"::Column.AsInteger());
        rec.AddMeasure(Text003, 2, rec."Data Type"::Decimal, rec."Chart Type"::Column.AsInteger());

        XCounter := 0;
        MyJobs.RESET;
        MyJobs.SETRANGE("User ID", USERID);
        if MyJobs.FINDSET(FALSE) then
            repeat
                RecJob.GET(MyJobs."Job No.");
                RecJob.SETRANGE("Reestimation Filter", RecJob."Latest Reestimation Code");
                RecJob.CALCFIELDS("Budget Cost Amount", "Usage (Cost) (LCY)");

                rec.AddColumn(MyJobs."Job No.");
                rec.SetValue(Text002, XCounter, RecJob."Budget Cost Amount");
                rec.SetValue(Text003, XCounter, RecJob."Usage (Cost) (LCY)");
                XCounter += 1;
            until MyJobs.NEXT = 0;

        rec.Update(CurrPage.BusinessChart);
    end;

    // begin//end
}







