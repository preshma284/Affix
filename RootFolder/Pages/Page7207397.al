page 7207397 "Statistics Expense Notes"
{
    CaptionML = ENU = 'Statistics Expense Notes', ESP = 'Estadistica notas gastos';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207320;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("VAT Amount"; rec."VAT Amount")
                {

                }
                field("PIT Withholding"; rec."PIT Withholding")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {

                }

            }
            part("SubForm"; 7207399)
            {

                SubPageView = SORTING("Document No.", "Line No");
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("group27")
            {

                CaptionML = ENU = 'Vendor', ESP = 'Proveedor';
                field("Vendor.Balance (LCY)"; Vendor."Balance (LCY)")
                {

                    CaptionML = ENU = 'Balance (LCY)', ESP = 'Saldo DL';
                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF Vendor.GET(rec.Employee) THEN
            Vendor.CALCFIELDS("Balance (LCY)")
        ELSE
            CLEAR(Vendor);

        Rec.CALCFIELDS(Amount, "VAT Amount");
        rec."Amount Including VAT" := rec.Amount + rec."VAT Amount";
    END;



    var
        Vendor: Record 23;
        ExpenseNotesLines: Record 7207321;

    /*begin
    end.
  
*/
}







