page 7207563 "Evaluation Line Subform"
{
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    SourceTable = 7207425;
    PageType = ListPart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Activity Code"; rec."Activity Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        VendorEvaluationHeader.GET(rec."Evaluation No.");
                        Rec.VALIDATE("Vendor No.", VendorEvaluationHeader."Vendor No.");
                        Rec.VALIDATE("Date of Last Evaluation", VendorEvaluationHeader."Evaluation Date");
                    END;


                }
                field("Activity Description"; rec."Activity Description")
                {

                }
                field("Evaluation Type"; rec."Evaluation Type")
                {

                }
                field("Evaluation Score"; rec."Evaluation Score")
                {

                }
                field("Clasification"; rec."Clasification")
                {

                }
                field("Evaluation Observations"; rec."Evaluation Observations")
                {

                }
                field("Evaluations Average Rating"; rec."Evaluations Average Rating")
                {

                }
                field("Average Clasification"; rec."Average Clasification")
                {

                }
                field("Date of Last Evaluation"; rec."Date of Last Evaluation")
                {

                }
                field("QualityManagement.GetCertificates(rec.Vendor No.,rec.Activity Code,VendorEvaluationHeader.rec.Evaluation Date, FALSE)"; QualityManagement.GetCertificates(rec."Vendor No.", rec."Activity Code", VendorEvaluationHeader."Evaluation Date", FALSE))
                {

                    CaptionML = ESP = 'N� Cetificados de Calidad';
                }
                field("Vendor No."; rec."Vendor No.")
                {

                    Visible = false;
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    Visible = false

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = '&Evaluate', ESP = '&Evaluar';
                Promoted = true;
                PromotedIsBig = true;
                Image = Calculate;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    ShowEvaluate;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = '&Conditions', ESP = '&Condiciones';
                Image = BinContent;

                trigger OnAction()
                BEGIN
                    //JAV 26/11/19: - Se cambia el uso del campo de la cabecera "Posting Date" por "Evaluation Date"
                    VendorEvaluationHeader.GET(rec."Evaluation No.");
                    QualityManagement.GetConditions(rec."Vendor No.", VendorEvaluationHeader."Job No.", rec."Activity Code", VendorEvaluationHeader."Evaluation Date");
                END;


            }
            action("action3")
            {
                CaptionML = ENU = '&Certifications', ESP = '&Certificaciones';
                Image = CheckLedger;


                trigger OnAction()
                BEGIN
                    //JAV 26/11/19: - Se cambia el uso del campo de la cabecera "Posting Date" por "Evaluation Date"
                    VendorEvaluationHeader.GET(rec."Evaluation No.");
                    QualityManagement.GetCertificates(rec."Vendor No.", rec."Activity Code", VendorEvaluationHeader."Evaluation Date", TRUE);
                END;


            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        IF VendorEvaluationHeader.GET(rec."Evaluation No.") THEN BEGIN
            rec."Vendor No." := VendorEvaluationHeader."Vendor No.";
            rec."Job No." := VendorEvaluationHeader."Job No.";
        END;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        xRec := Rec;
        CurrPage.EDITABLE(NOT rec.Validated);
    END;



    var
        VendorEvaluationHeader: Record 7207424;
        Err001: TextConst ESP = 'Debe definir una actividad para poder evaluarla.';
        QualityCertificates: Integer;
        QualityManagement: Codeunit 7207293;

    procedure ShowEvaluate();
    var
        DataVendorEvaluation: Record 7207423;
        VendorEvaluationsList: Page 7207574;
    begin
        if (rec."Activity Code" = '') then
            MESSAGE(Err001)
        ELSE begin
            rec.AddLines(rec."Activity Code");
            COMMIT;     // El RunModal necesita que est� todo guardado

            DataVendorEvaluation.RESET;
            DataVendorEvaluation.SETRANGE("Evaluation No.", rec."Evaluation No.");
            DataVendorEvaluation.SETRANGE("Activity Code", rec."Activity Code");

            CLEAR(VendorEvaluationsList);
            VendorEvaluationsList.EDITABLE := (not rec.Validated);
            VendorEvaluationsList.SETTABLEVIEW(DataVendorEvaluation);
            VendorEvaluationsList.RUNMODAL;

            VendorEvaluationHeader.GET(rec."Evaluation No.");
            VendorEvaluationHeader.SetEvaluationScore;

            rec.SetAverageReviewScore;
        end;
    end;

    procedure PrintEvaluation();
    var
        VendorEvalHeader: Record 7207424;
        VendorEvalLine: Record 7207425;
        // VendorSubcontractorCard: Report 7207362;
    begin
        VendorEvaluationHeader.RESET;
        VendorEvaluationHeader.SETRANGE("No.", rec."Evaluation No.");
        VendorEvaluationHeader.SETRANGE("Vendor No.", rec."Vendor No.");
        VendorEvaluationHeader.SETRANGE(Validated, TRUE);
        VendorEvalLine.RESET;
        VendorEvalLine.SETRANGE("Activity Code", rec."Activity Code");
        // VendorSubcontractorCard.SETTABLEVIEW(VendorEvaluationHeader);
        // VendorSubcontractorCard.SETTABLEVIEW(VendorEvalLine);
        // VendorSubcontractorCard.RUNMODAL;
        // CLEAR(VendorSubcontractorCard);
    end;

    // begin
    /*{
      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
      JAV 21/09/19: - Se a�ade la columna rec."Evaluation Type" para distinguir entre evaluar servicios, productos u otros
      JAV 26/11/19: - Se cambia el uso del campo de la cabecera "Posting Date" por "Evaluation Date"
    }*///end
}







