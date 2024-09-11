page 7207406 "Activation Line Subform"
{
    CaptionML = ENU = 'Activation Line Subform', ESP = 'Subform. L�neas activaci�n';
    MultipleNewLines = true;
    SourceTable = 7207368;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Activation Type"; rec."Activation Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Account Type"; rec."Account Type")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Account No."; rec."Account No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Bal. Account Type"; rec."Bal. Account Type")
                {

                }
                field("Bal. Account No."; rec."Bal. Account No.")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Applies-to Entry"; rec."Applies-to Entry")
                {

                }
                field("Item No."; rec."Item No.")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Variant Code"; rec."Variant Code")
                {

                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("New Location Code"; rec."New Location Code")
                {

                }
                field("New Variant Code"; rec."New Variant Code")
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
                        _ShowDimensions;
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
        PurchaseHeader: Record 38;
        // ItemCrossReference: Record 5717;
        ItemCrossReference: Record "Item Reference";
        TransferExtendedText: Codeunit 378;
        ShortcutDimCode: ARRAY[8] OF Code[20];

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure ShowDimensions_();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin//end
}







