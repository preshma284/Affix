page 7207672 "QB Debit Relations Lines Movs"
{
    CaptionML = ESP = 'L�neas de Creaci�n de Efectos';
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7206920;
    PageType = ListPart;
    AutoSplitKey = true;

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

                }
                field("Date"; rec."Date")
                {

                }
                field("Type"; rec."Type")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("Post"; rec."Post")
                {

                }
                field("Due Date"; rec."Due Date")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Amount"; rec."Amount")
                {

                    BlankZero = true;
                    Editable = FALSE

  ;
                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        setCampos;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE();
    END;



    var
        Cabecera: Record 7206919;
        PaymentMethod: Record 289;
        QBDebitRelations: Codeunit 7207288;
        edReceived: Boolean;

    LOCAL procedure setCampos();
    begin
        edReceived := (rec.Type = rec.Type::Bill) and (rec.Amount <> rec."Applied Amount");
    end;

    // begin//end
}







