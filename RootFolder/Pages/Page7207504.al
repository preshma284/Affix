page 7207504 "QB Worksheet Statistics H. FB"
{
    Editable = false;
    CaptionML = ENU = 'Posted Worksheet Statistic', ESP = 'Estad�stica parte registrado';
    SourceTable = 7207292;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field("Amount"; rec.Amount)
            {

            }
            field("No. Hours"; rec."No. Hours")
            {

            }
            field("Allocation Term"; rec."Allocation Term")
            {

                CaptionML = ENU = 'Allocation Term', ESP = 'Periodo de imputaci�n';
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







