page 7207438 "Element Contract Subform."
{
    CaptionML = ENU = 'Element Contract Subform.', ESP = 'Subform. contrato elemento';
    MultipleNewLines = true;
    SourceTable = 7207354;
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

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Rent Price"; rec."Rent Price")
                {

                }
                field("Planned Delivery Quantity"; rec."Planned Delivery Quantity")
                {

                }
                field("Unit of Measure"; rec."Unit of Measure")
                {

                    Editable = False;
                }
                field("Quantity to Send"; rec."Quantity to Send")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Send Date"; rec."Send Date")
                {

                }
                field("Retreat Quantity"; rec."Retreat Quantity")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Retreat Date"; rec."Retreat Date")
                {

                }
                field("Delivered Quantity"; rec."Delivered Quantity")
                {

                }
                field("Return Quantity"; rec."Return Quantity")
                {

                }
                field("Variant Code"; rec."Variant Code")
                {

                }
                field("Location Code"; rec."Location Code")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    Visible = false

  ;
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

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin//end
}







