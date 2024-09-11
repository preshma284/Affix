page 7207671 "QB Debit Relations Lines Bill"
{
    CaptionML = ESP = 'L�neas de Creaci�n de Efectos';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206920;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Relacion No."; rec."Relacion No.")
                {

                    Visible = false;
                }
                field("Line No."; rec."Line No.")
                {

                    Visible = false;
                }
                field("Date"; rec."Date")
                {

                    Visible = false;
                }
                field("Type"; rec."Type")
                {

                    Visible = false;
                }
                field("Document No."; rec."Document No.")
                {

                    Visible = false;
                }
                field("Bill No."; rec."Bill No.")
                {

                }
                field("Due Date"; rec."Due Date")
                {

                }
                field("No. Liquidation"; rec."No. Liquidation")
                {

                }
                field("Post"; rec."Post")
                {

                }
                field("Description"; rec."Description")
                {

                    Visible = false;
                }
                field("Amount"; rec."Amount")
                {

                    BlankZero = true;
                    Editable = FALSE;
                }
                field("Applied Amount"; rec."Applied Amount")
                {

                    Editable = FALSE;
                }
                field("Post Payment"; rec."Post Payment")
                {

                    Visible = false;
                    Editable = FALSE;
                }
                field("Received Amount"; rec."Received Amount")
                {

                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        edReceived := (rec.Type = rec.Type::Bill) AND (rec.Amount <> rec."Applied Amount");
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE();
    END;



    var
        Cabecera: Record 7206919;
        PaymentMethod: Record 289;
        edReceived: Boolean;

    /*begin
    end.
  
*/
}







