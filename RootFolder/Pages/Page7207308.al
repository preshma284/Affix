page 7207308 "Measure Post List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Measure Post List', ESP = 'Lista hist. mediciones';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7207338;
    PageType = List;
    CardPageID = "Post. Measurement";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Measurement Date"; rec."Measurement Date")
                {

                }
                field("Amount Origin"; rec."Amount Origin")
                {

                }
                field("Amount Previous"; rec."Amount Previous")
                {

                }
                field("Amount Term"; rec."Amount Term")
                {

                }
                field("Amount Document"; rec."Amount Document")
                {

                }
                field("Certification Completed"; rec."Certification Completed")
                {

                }
                field("No. Measure"; rec."No. Measure")
                {

                }
                field("Text Measure"; rec."Text Measure")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Currency Factor"; rec."Currency Factor")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                }
                field("Pre-Assigned No. Series"; rec."Pre-Assigned No. Series")
                {

                    Visible = false;
                }
                field("No. Series"; rec."No. Series")
                {

                    Visible = false;
                }
                field("Last Measure"; rec."Last Measure")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Comment"; rec."Comment")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207497)
            {

                CaptionML = ESP = 'Totales de la medici�n';
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Links; Links)
            {
                ;
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
                CaptionML = ENU = '&Documents', ESP = '&Medici�n';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207305;
                    RunPageLink = "No." = FIELD("No.");
                    Visible = isNotModal;
                    Image = ViewComments;
                }

            }

        }
        area(Processing)
        {

            action("action2")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Visible = isNotModal;
                Image = Navigate;

                trigger OnAction()
                BEGIN
                    rec.Navigate;
                END;


            }
            action("action3")
            {
                Ellipsis = true;
                CaptionML = ENU = '&Print', ESP = 'Imprimir';
                Visible = isNotModal;
                Image = Print;

                trigger OnAction()
                VAR
                    QBReportSelections: Record 7206901;
                BEGIN
                    HistMeasurements.RESET;
                    HistMeasurements.SETRANGE("No.", rec."No.");
                    HistMeasurements.SETRANGE("Job No.", rec."Job No.");

                    //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                    //CLEAR(RepMedi);
                    //RepMedi.SETTABLEVIEW(HistMeasurements);
                    //RepMedi.RUNMODAL;
                    QBReportSelections.Print(QBReportSelections.Usage::J5, HistMeasurements);
                END;


            }
            action("Cancel Measurement")
            {

                CaptionML = ENU = 'Cancel Measurement', ESP = 'Cancelar medici�n';
                Visible = isNotModal;
                Image = Cancel;


                trigger OnAction()
                VAR
                    QBMeasurements: Codeunit 7207274;
                BEGIN
                    //JAV 22/03/19: - Nueva acci�n para cancelar una medici�n registrada
                    QBMeasurements.HistMeasurementsCancel(Rec);
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
                actionref(action2_Promoted; action2)
                {
                }
                actionref("Cancel Measurement_Promoted"; "Cancel Measurement")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);
        FunctionQB.SetUserJobHistMeasurementsFilter(Rec);

        isNotModal := (NOT CurrPage.LOOKUPMODE);
    END;



    var
        FunctionQB: Codeunit 7207272;
        // RepMedi: Report 7207423;
        HistMeasurements: Record 7207338;
        isNotModal: Boolean;/*

    begin
    {
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
      JAV 15/10/19: - Se a�aden, eliminan y reordenan columnas
    }
    end.*/


}








