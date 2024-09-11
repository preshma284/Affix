page 7207348 "Hist. Reestimation Stat. Hdr."
{
    Editable = false;
    CaptionML = ENU = 'Hist. Reestimation Stat. Hdr.', ESP = 'Hist. cab. estadisticas reest.';
    SourceTable = 7207317;

    layout
    {
        area(content)
        {
            group("group38")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Outst. expenses amount est."; rec."Outst. expenses amount est.")
                {

                }
                field("Expenses amount to est. origin"; rec."Expenses amount to est. origin")
                {

                }
                field("Outst. incomes amount est."; rec."Outst. incomes amount est.")
                {

                }
                field("Incomes amount to est. origin"; rec."Incomes amount to est. origin")
                {

                }
                field("Incomes amount to est. origin-Expenses amount to est. origin"; rec."Incomes amount to est. origin" - rec."Expenses amount to est. origin")
                {

                    CaptionML = ESP = 'Margen a origen estimado';
                }

            }

        }
    }

    trigger OnAfterGetRecord()
    BEGIN
        CLEARALL;
    END;




    /*begin
    end.
  
*/
}







