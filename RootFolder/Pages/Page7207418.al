page 7207418 "Usage Line Subform."
{
    CaptionML = ENU = 'Usage Line Subform.', ESP = 'Subform. Lineas utilizacion';
    MultipleNewLines = true;
    InsertAllowed = false;
    SourceTable = 7207363;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("No."; rec."No.")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Application Date"; rec."Application Date")
                {

                }
                field("Line Type"; rec."Line Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                }
                field("Usage Days"; rec."Usage Days")
                {

                }
                field("Delivery Mov. No."; rec."Delivery Mov. No.")
                {

                }
                field("Delivery Document"; rec."Delivery Document")
                {

                }
                field("Initial Date Calculation"; rec."Initial Date Calculation")
                {

                }
                field("Return Document"; rec."Return Document")
                {

                }
                field("Return Date"; rec."Return Date")
                {

                }
                field("Return Mov. No."; rec."Return Mov. No.")
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
                CaptionML = ENU = 'Line', ESP = 'L�nea';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
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
        CUTransferExtendedText: Codeunit 378;
        ShortcutDimCode: ARRAY[8] OF Code[20];

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    // procedure ShowDimensions();
    // begin
    //     Rec.ShowDimensions;
    // end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin//end
}







