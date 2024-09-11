page 7207667 "QB Job Currency Exchanges"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Job Currency Exchanges', ESP = 'Cambios divisas por proyectos';
    SourceTable = 7206917;
    DelayedInsert = true;
    PageType = List;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Job No."; rec."Job No.")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Future Currency"; rec."Future Currency")
                {

                }
                field("Date"; rec."Date")
                {

                }
                field("Cost Amount"; rec."Cost Amount")
                {

                    CaptionML = ENU = 'Cost Amount', ESP = 'Tipo de cambio coste';
                }
                field("Sales Amount"; rec."Sales Amount")
                {

                    CaptionML = ENU = 'Sales Amount', ESP = 'Tipo de cambio ventas';
                }

            }

        }
    }
    actions
    {
        area(Creation)
        {
            //Name=Actions;
            action("GetJobCurrencies")
            {

                CaptionML = ENU = 'Get Job Currencies', ESP = 'Traer divisas del proyecto';
                Image = Currency;


                trigger OnAction()
                BEGIN
                    //Divisa del proyecto
                    Job.GET(rec."Job No.");

                    JobCurrencyExchange.RESET;
                    JobCurrencyExchange.SETRANGE("Job No.", Job."No.");
                    JobCurrencyExchange.SETRANGE("Currency Code", Job."Currency Code");
                    IF NOT JobCurrencyExchange.FINDFIRST THEN BEGIN

                        JobCurrencyExchange.INIT;
                        JobCurrencyExchange.VALIDATE("Job No.", Job."No.");
                        JobCurrencyExchange.VALIDATE("Currency Code", Job."Currency Code");
                        JobCurrencyExchange.VALIDATE(Date, WORKDATE);

                        CurrencyAmount.RESET;
                        CurrencyAmount.SETRANGE("Currency Code", Job."Currency Code");
                        IF CurrencyAmount.FINDLAST THEN
                            JobCurrencyExchange.VALIDATE("Cost Amount", CurrencyAmount.Amount);

                        JobCurrencyExchange.INSERT(FALSE);
                    END;

                    //Divisa adicional del proyecto
                    JobCurrencyExchange.RESET;
                    JobCurrencyExchange.SETRANGE("Job No.", Job."No.");
                    JobCurrencyExchange.SETRANGE("Currency Code", Job."Aditional Currency");
                    IF NOT JobCurrencyExchange.FINDFIRST THEN BEGIN

                        JobCurrencyExchange.INIT;
                        JobCurrencyExchange.VALIDATE("Job No.", Job."No.");
                        JobCurrencyExchange.VALIDATE("Currency Code", Job."Aditional Currency");
                        JobCurrencyExchange.VALIDATE(Date, WORKDATE);

                        CurrencyAmount.RESET;
                        CurrencyAmount.SETRANGE("Currency Code", Job."Aditional Currency");
                        IF CurrencyAmount.FINDLAST THEN
                            JobCurrencyExchange.VALIDATE("Cost Amount", CurrencyAmount.Amount);

                        JobCurrencyExchange.INSERT(FALSE);
                    END;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(GetJobCurrencies_Promoted; GetJobCurrencies)
                {
                }
            }
        }
    }

    var
        Job: Record 167;
        Currency: Record 4;
        JobCurrencyExchange: Record 7206917;
        CurrencyAmount: Record 264;

    /*begin
    end.
  
*/
}








