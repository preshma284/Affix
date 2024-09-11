page 7207660 "QB Report Selection"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Report Selection  for QuoBuilding', ESP = 'Selecci�n informes para QuoBuilding';
    SaveValues = true;
    SourceTable = 7206901;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("ReportUsage"; QBReportSelections.Usage)
            {

                CaptionML = ENU = 'Usage', ESP = 'Uso';
                ToolTipML = ENU = 'Specifies which type of document the report is used for.', ESP = 'Especifica para qu� tipo de documento usa el informe.';
                ApplicationArea = Basic, Suite;

                ; trigger OnValidate()
                BEGIN
                    SetUsageFilter(TRUE);
                END;


            }
            repeater("table")
            {

                FreezeColumn = "Report Caption";
                field("Sequence"; rec."Sequence")
                {

                }
                field("Report ID"; rec."Report ID")
                {

                    BlankZero = true;
                    Enabled = edReport;
                }
                field("Report Caption"; rec."Report Caption")
                {

                }
                field("Caption"; rec."Caption")
                {

                }
                field("Minimal Amount"; rec."Minimal Amount")
                {

                    Enabled = edReport;
                }
                field("Selection"; rec."Selection")
                {

                }
                field("SW Description"; rec."SW Description")
                {

                    Enabled = edWS;
                }
                field("SW Parameter"; rec."SW Parameter")
                {

                    Enabled = edWS;
                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {

                Visible = FALSE;
            }
            systempart(Notes; Notes)
            {

                Visible = FALSE;
            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        rec.AddDefaultsReports;
        SetUsageFilter(FALSE);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        edWS := (rec.IsWebService);
        edReport := (NOT rec.IsWebService);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.NewRecord;
    END;



    var
        ReportUsage2: Option "Estudio: Oferta","Proyecto: Oferta";
        QBReportSelections: Record 7206901;
        edReport: Boolean;
        edWS: Boolean;

    LOCAL procedure SetUsageFilter(ModifyRec: Boolean);
    begin
        if ModifyRec then
            if Rec.MODIFY then;

        Rec.FILTERGROUP(2);
        Rec.SETRANGE(Usage, QBReportSelections.Usage);
        Rec.FILTERGROUP(0);
        CurrPage.UPDATE;
    end;

    // begin
    /*{
      JAV 10/01/22: - QB 1.10.09 Se incluye el campo rec."Caption"
    }*///end
}








