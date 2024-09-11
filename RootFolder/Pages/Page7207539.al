page 7207539 "Costsheet Lines Subform."
{
    CaptionML = ENU = 'Costsheet Lines Subform.', ESP = 'Subform. lineas Partes coste';
    MultipleNewLines = true;
    SourceTable = 7207434;
    DelayedInsert = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Unit Cost No."; rec."Unit Cost No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE(TRUE);
                        rec.CalcAmount;
                    END;


                }
                field("Invoicing Job"; rec."Invoicing Job")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Amount"; rec."Amount")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;  //JAV 01/06/22: - QB 1.10.46 Para que actualice el importe de la cabecera
                    END;


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

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE;  //JAV 01/06/22: - QB 1.10.46 Para que actualice el importe de la cabecera
    END;



    var
        PurchaseHeader: Record 38;
        // ItemCrossReference: Record 5717;
        ItemCrossReference: Record "Item Reference";
        CUTransferExtendedText: Codeunit 378;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        CostsheetHeader: Record 7207433;
        CostsheetLines: Record 7207434;

    procedure _ShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    // begin
    /*{
      JAV 01/06/22: - QB 1.10.46 Se a�aden updates para que actualice el importe de la cabecera
    }*///end
}







