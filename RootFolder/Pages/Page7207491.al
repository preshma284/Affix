page 7207491 "Expense Notes Statistics FB"
{
    Editable = false;
    CaptionML = ENU = 'Expense Notes Statistics', ESP = 'Estad�sticas notas de gasto';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207320;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("group160")
            {

                CaptionML = ESP = 'General';
                field("VAT Amount"; rec."VAT Amount")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {

                }
                field("PIT Withholding"; rec."PIT Withholding")
                {

                }
                group("group165")
                {

                    field("Vend.Balance (LCY)"; Vend."Balance (LCY)")
                    {

                        CaptionML = ENU = 'Balance (LCY)', ESP = 'Balance DL';
                    }

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF Vend.GET(rec.Employee) THEN
            Vend.CALCFIELDS("Balance (LCY)")
        ELSE
            CLEAR(Vend);

        rec."Amount Including VAT" := rec."Amount Including VAT" + rec.Amount;
    END;



    var
        Vend: Record 23;

    /*begin
    end.
  
*/
}







