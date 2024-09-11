page 7207569 "Evaluations for activity"
{
    Editable = false;
    CaptionML = ENU = 'Evaluations for activity', ESP = 'Evaluaciones por actividad';
    SourceTable = 7207425;
    PageType = List;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Activity Code"; rec."Activity Code")
                {

                    Style = Strong;
                    StyleExpr = bValidated;

                    ; trigger OnValidate()
                    BEGIN
                        VendorEvaluationHeader.GET(rec."Evaluation No.");
                        Rec.VALIDATE("Vendor No.", VendorEvaluationHeader."Vendor No.");
                    END;


                }
                field("Activity Description"; rec."Activity Description")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Vendor No."; rec."Vendor No.")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("QualityManagement.GetCertificates(rec.Vendor No.,rec.Activity Code,VendorEvaluationHeader.rec.Evaluation Date, FALSE)"; QualityManagement.GetCertificates(rec."Vendor No.", rec."Activity Code", VendorEvaluationHeader."Evaluation Date", FALSE))
                {

                    CaptionML = ESP = 'N� Certificados';
                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Evaluation Score"; rec."Evaluation Score")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Evaluation Observations"; rec."Evaluation Observations")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Evaluations Average Rating"; rec."Evaluations Average Rating")
                {

                    Style = Strong;
                    StyleExpr = bValidated;
                }
                field("Date of Last Evaluation"; rec."Date of Last Evaluation")
                {

                    Style = Strong;
                    StyleExpr = bValidated

  ;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Lilne', ESP = '&L�nea';
                action("action1")
                {
                    CaptionML = ENU = 'See Evaluation', ESP = 'Ver evaluaci�n';
                    RunObject = Page 7207562;
                    RunPageView = SORTING("No.");
                    RunPageLink = "No." = FIELD("Evaluation No.");
                    Image = View
    ;
                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        bValidated := rec.Validated;
    END;



    var
        VendorEvaluationHeader: Record 7207424;
        bValidated: Boolean;
        QualityManagement: Codeunit 7207293;/*

    begin
    {
      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
      JAV 26/11/19: - Se cambia el uso del campo "Posting Date" por "Evaluation Date"
    }
    end.*/


}







