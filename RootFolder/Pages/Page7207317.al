page 7207317 "Posted Subfor. Output Shpt Lin"
{
    Editable = false;
    CaptionML = ENU = 'Posted Subfor. Warehouse Shpt Lin', ESP = 'Hist. Subfor. l�neas albar�n Almac�n';
    SourceTable = 7207311;
    PageType = ListPart;
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("No."; rec."No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Variant Code"; rec."Variant Code")
                {

                    Visible = False;
                }
                field("Job Task No."; rec."Job Task No.")
                {

                    Visible = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Produccion Unit"; rec."Produccion Unit")
                {

                }
                field("Outbound Warehouse"; rec."Outbound Warehouse")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("No. Serie for Tracking"; rec."No. Serie for Tracking")
                {

                    Editable = False;
                }
                field("No. Lot for Tracking"; rec."No. Lot for Tracking")
                {

                    Editable = False;
                }
                field("Unit Cost"; rec."Unit Cost")
                {

                    Editable = False;
                }
                field("Total Cost"; rec."Total Cost")
                {

                    Editable = False;
                }
                field("Coste Ajustado"; rec."Coste Ajustado")
                {

                    Editable = false;
                }
                field("Coste Anterior"; rec."Coste Anterior")
                {

                    Editable = false;
                }
                field("Sales Price"; rec."Sales Price")
                {

                }
                field("Amount"; rec."Amount")
                {

                    Editable = False;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }
                field("Billable"; rec."Billable")
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
                        ShowDimensions_;
                    END;


                }

            }

        }
    }

    var
        PurchaseHeader: Record 38;
        ItemCrossReference: Record "Item Reference";
        TransferExtendedText: Codeunit 378;
        // ConsumptionProposed: Report 7207339;
        ShortcutDimCode: ARRAY[8] OF Code[20];

    procedure ShowDimensions_();
    begin
        Rec.ShowDimensions;
    end;

    // begin
    /*{
      AML 25/03/22 QB_ST01 A�adidos campos Ajustado y Coste anterior.
    }*///end
}







