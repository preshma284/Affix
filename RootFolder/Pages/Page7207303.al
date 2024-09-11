page 7207303 "Measurement List"
{
  ApplicationArea=All;

    CaptionML = ENU = '"Measurement" List', ESP = 'Lista Mediciones';
    SourceTable = 7207336;
    SourceTableView = WHERE("Document Type" = CONST("Measuring"));
    PageType = List;
    CardPageID = "Measurement";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Certification Type"; rec."Certification Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Text Measure"; rec."Text Measure")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Measurement Date"; rec."Measurement Date")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207498)
            {

                CaptionML = ENU = 'Measurement Statistics', ESP = 'Totales de la medici�n';
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("action1")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Print', ESP = '&Imprimir';
                    Image = Print;

                    trigger OnAction()
                    VAR
                        MeasurementHeader: Record 7207336;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                        MeasurementHeader.RESET;
                        MeasurementHeader.SETRANGE("No.", rec."No.");
                        QBReportSelections.Print(QBReportSelections.Usage::J4, MeasurementHeader);
                    END;


                }
                action("action2")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Print', ESP = 'Imprimir WS';
                    Visible = seePrintWS;
                    Image = PrintInstallment;


                    trigger OnAction()
                    VAR
                        MeasurementHeader: Record 7207336;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        QBMeasurements.PrintWS(Rec."No.");
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    VAR
        AuxJob: Text;
    BEGIN
        Rec.FILTERGROUP(2);
        AuxJob := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);

        IF (AuxJob = '') THEN BEGIN
            rec.FunFilterResponsibility(Rec);
            FunctionQB.SetUserJobMeasurementHeaderFilter(Rec);
        END;

        optType := optType::Certification;
        IF Rec.GETFILTER("Document Type") = FORMAT(optType, 0, 0) THEN
            booVisible := TRUE
        ELSE
            booVisible := FALSE;

        seePrintWS := FunctionQB.AccessToWSReports;
    END;



    var
        DimMgt: Codeunit 408;
        FunctionQB: Codeunit 7207272;
        booVisible: Boolean;
        optType: Option "Measuring","Certification";
        seePrintWS: Boolean;
        QBMeasurements: Codeunit 7207274;/*

    begin
    {
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
    }
    end.*/


}








