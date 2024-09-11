page 7207631 "Job redetermination List"
{
    CaptionML = ENU = 'Job Redetermination List', ESP = 'Lista redeterminacion obra';
    SourceTable = 7207437;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("FORMAT(JobDescription)"; FORMAT(JobDescription))
            {

                CaptionClass = FORMAT(JobDescription);
                Editable = False;
                Style = Standard;
                StyleExpr = TRUE;
            }
            repeater("table")
            {

                field("Code"; rec."Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Aplication Date"; rec."Aplication Date")
                {

                }
                field("Default redetermination factor"; rec."Default redetermination factor")
                {

                }
                field("Adjusted"; rec."Adjusted")
                {

                }
                field("Validated"; rec."Validated")
                {

                }

            }
            part("Operations"; 7207632)
            {

                SubPageView = SORTING("Job No.", "Redetermination Code", "Piecework Code");
                SubPageLink = "Job No." = FIELD("Job No."), "Redetermination Code" = FIELD("Code");
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Planning', ESP = 'Redeterminanciones';
                action("Initialize")
                {

                    CaptionML = ENU = 'Initialize', ESP = 'Inicializar';
                    Image = CopyLedgerToBudget;

                    trigger OnAction()
                    VAR
                        Initializeredetermination: Codeunit 7207340;
                    BEGIN
                        Initializeredetermination.RUN(Rec);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Validate', ESP = 'Validar';
                    Image = CopyToTask;


                    trigger OnAction()
                    VAR
                        ValidateRedetermination: Codeunit 7207341;
                    BEGIN
                        ValidateRedetermination.RUN(Rec);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Initialize_Promoted; Initialize)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        JobDescription := '';
        IF Rec.GETFILTER("Job No.") <> '' THEN
            JobDescription := FunctionQB.ShowDescriptionJob(Rec.GETFILTER("Job No."))
    END;



    var
        FunctionQB: Codeunit 7207272;
        JobDescription: Text;

    /*begin
    end.
  
*/
}







