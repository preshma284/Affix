page 7207434 "Subform. Elements Delivery"
{
    CaptionML = ENU = 'Subform. Elements Delivery', ESP = 'Subform. Entrega elemento l�neas';
    MultipleNewLines = true;
    SourceTable = 7207357;
    PopulateAllFields = true;
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
                field("Amount to Manipulate"; rec."Amount to Manipulate")
                {

                }
                field("Variant Code"; rec."Variant Code")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Unit of Measure"; rec."Unit of Measure")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Amount Manipulated"; rec."Amount Manipulated")
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                }
                field("Shortcut Dimensios 1 Code"; rec."Shortcut Dimensios 1 Code")
                {

                }
                field("Weight to Manipulate"; rec."Weight to Manipulate")
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
                    CaptionML = ENU = 'D&imensions', ESP = 'D&imensiones';
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
        ShortcutDimCode: ARRAY[8] OF Code[20];

    // procedure ShowDimensions();
    // begin
    //     Rec.ShowDimensions;
    // end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    // begin//end
}







