page 7207590 "Propose Product. Measurement"
{
    CaptionML = ENU = 'Propose Product. Measurement', ESP = 'Proponer medicion produccion';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 39;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Piecework No."; rec."Piecework No.")
                {

                    Editable = FALSE;
                }
                field("DataPieceworkForProduction.Description"; DataPieceworkForProduction.Description)
                {

                    CaptionML = ESP = 'Unidad de obra';
                }
                field("Measured Last Date"; rec."Measured Last Date")
                {

                }
                field("Type"; rec."Type")
                {

                    Editable = FALSE;
                }
                field("No."; rec."No.")
                {

                    Editable = FALSE;
                }
                field("Description"; rec."Description")
                {

                    Editable = FALSE;
                }
                field("Quantity"; rec."Quantity")
                {

                    Editable = FALSE;
                }
                field("Measured Qty."; rec."Measured Qty.")
                {

                }
                field("Measured Proposed"; rec."Measured Proposed")
                {

                    DecimalPlaces = 2 : 5;
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
                CaptionML = ENU = '&Line', ESP = '&L�nea';

            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        IF NOT DataPieceworkForProduction.GET(rec."Job No.", rec."Piecework No.") THEN
            DataPieceworkForProduction.INIT;
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        PurchaseHeader: Record 38;
        BudgetInProgress: Code[20];

    procedure setPurchaseOrder(PurchaseHeaderPar: Record 38);
    begin
        PurchaseHeader := PurchaseHeaderPar;
    end;

    // begin
    /*{
      AML 25/09/23 Q20081 Aumentados los decimales visibles en rec."Measured Proposed"
    }*///end
}







