page 7207393 "Expense Notes Lines Subform"
{
    CaptionML = ENU = 'Expense Notes Lines Subform.', ESP = 'Subform. Lineas notas de gasto';
    MultipleNewLines = true;
    SourceTable = 7207321;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Job No."; rec."Job No.")
                {

                }
                field("Job Task No."; rec."Job Task No.")
                {

                    Visible = FALSE;
                }
                field("No. Job Unit"; rec."No. Job Unit")
                {

                }
                field("Expense Concept"; rec."Expense Concept")
                {

                }
                field("Expense Date"; rec."Expense Date")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("No Document Vendor"; rec."No Document Vendor")
                {

                }
                field("VAT Business Posting Group"; rec."VAT Business Posting Group")
                {

                }
                field("VAT Product Posting Group"; rec."VAT Product Posting Group")
                {

                }
                field("Percentage VAT"; rec."Percentage VAT")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                    Editable = False;
                }
                field("Expense Account"; rec."Expense Account")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Price Cost"; rec."Price Cost")
                {

                }
                field("Total Amount"; rec."Total Amount")
                {

                }
                field("Total Amount (DL)"; rec."Total Amount (DL)")
                {

                }
                field("VAT Amount"; rec."VAT Amount")
                {

                }
                field("VAT Amount (DL)"; rec."VAT Amount (DL)")
                {

                }
                field("Justifying"; rec."Justifying")
                {

                }
                field("Payment Charge Enterprise"; rec."Payment Charge Enterprise")
                {

                }
                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("Vendor Name"; rec."Vendor Name")
                {

                }
                field("Bal. Account Type"; rec."Bal. Account Type")
                {

                }
                field("Bal. Account Payment"; rec."Bal. Account Payment")
                {

                }
                field("PIT Percentage"; rec."PIT Percentage")
                {

                }
                field("Withholding Amount"; rec."Withholding Amount")
                {

                }
                field("Withholding Amount (DL)"; rec."Withholding Amount (DL)")
                {

                }
                field("Billable"; rec."Billable")
                {

                }
                field("Sales Amount"; rec."Sales Amount")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Line', ESP = '&L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'D&imensiones';
                    Image = Dimensions;


                    trigger OnAction()
                    BEGIN

                        ShowDimensions_;
                    END;


                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(ShortcutDimCode);
    END;



    var
        PurchHeader: Record 38;
        // ItemCrossReference: Record 5717;
        ItemCrossReference : Record "Item Reference";
        TransferExtendedText: Codeunit 378;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        ExpenseNotesLines: Record 7207321;
        ExpenseNotesHeader: Record 7207320;
        Text006: TextConst ENU = 'You can not take either chapters or subcapitules, you can only take matches.', ESP = 'No se puede coger ni capitulos ni subcapitulos, solo se puede coger partidas.';
        DataPieceworkForProduction: Record 7207386;

    procedure ShowDimensions_();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateFormxxx(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin
    /*{
      JAV 30/05/19: - Se cambian de orden las columnas y se hace no visible la columna "Job Task No."
    }*///end
}







