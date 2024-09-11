page 7207381 "Bring reestimation to date CA"
{
    CaptionML = ENU = 'Bring reestimation to date CA', ESP = 'Llevar reestimacion a fecha CA';
    SourceTable = 7207316;
    layout
    {
        area(content)
        {
            group("group4")
            {

                field("control1"; '')
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Reestimation Code"; rec."Reestimation Code")
                {

                }
                field("Analytical concept"; rec."Analytical concept")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("decNuevaProduccionpendiente"; "decNuevaProduccionpendiente")
                {

                }
                field("dateFecha"; "dateFecha")
                {

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
                CaptionML = ENU = 'Confirm', ESP = 'Confirmar';
                Image = Approve;


                trigger OnAction()
                BEGIN
                    IF dateFecha = 0D THEN
                        ERROR(Text001);
                    MovBudgetForecast.SETCURRENTKEY("Job No.", "Document No.", "Line No.", "Anality Concept Code",
                                                 "Reestimation code", "Forecast Date");
                    MovBudgetForecast.SETRANGE("Document No.", rec."Document No.");
                    MovBudgetForecast.SETRANGE("Job No.", rec."Job No.");
                    MovBudgetForecast.SETRANGE("Reestimation code", rec."Reestimation Code");
                    MovBudgetForecast.SETRANGE("Line No.", rec."Line No.");
                    MovBudgetForecast.SETRANGE("Anality Concept Code", rec."Analytical concept");
                    IF MovBudgetForecast.FINDSET THEN
                        MovBudgetForecast.DELETEALL;

                    MovBudgetForecast.RESET;
                    IF MovBudgetForecast.FINDLAST THEN
                        LastMov := MovBudgetForecast."Entry No."
                    ELSE
                        LastMov := 0;

                    CLEAR(MovBudgetForecast);
                    LastMov := LastMov + 1;
                    MovBudgetForecast."Entry No." := LastMov;
                    MovBudgetForecast."Document No." := rec."Document No.";
                    MovBudgetForecast."Reestimation code" := rec."Reestimation Code";
                    MovBudgetForecast."Job No." := rec."Job No.";
                    MovBudgetForecast."Line No." := rec."Line No.";
                    MovBudgetForecast."Forecast Date" := dateFecha;
                    MovBudgetForecast.VALIDATE("Anality Concept Code", rec."Analytical concept");
                    MovBudgetForecast.VALIDATE("Outstanding Temporary Forecast", decNuevaProduccionpendiente);
                    MovBudgetForecast."User ID" := USERID;
                    MovBudgetForecast.INSERT(TRUE);

                    CurrPage.CLOSE;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }

    var
        dateFecha: Date;
        decNuevaProduccionpendiente: Decimal;
        Text001: TextConst ENU = 'You must select the date to which the pending production is to be carried', ESP = 'Debe seleccionar la fecha a la que va a llevar la producci�n pendiente';
        MovBudgetForecast: Record 7207319;
        LastMov: Integer;

    /*begin
    end.
  
*/
}







