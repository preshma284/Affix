page 7207315 "Subfor. Output Shipment Lin"
{
    CaptionML = ENU = 'Subfor. Warehouse Shipment Lin', ESP = 'Subfor. l�neas albar�n almac�n';
    MultipleNewLines = true;
    SourceTable = 7207309;
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

                    ; trigger OnValidate()
                    VAR
                        InvtAdjmt: Codeunit 5895;
                        RecItem: Record 27;
                    BEGIN

                        RecItem.SETRANGE("No.", rec."No.");
                        InvtAdjmt.SetProperties(FALSE, FALSE);
                        InvtAdjmt.SetFilterItem(RecItem);
                        InvtAdjmt.MakeMultiLevelAdjmt;
                    END;


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
                field("Produccion Unit"; rec."Produccion Unit")
                {

                }
                field("Outbound Warehouse"; rec."Outbound Warehouse")
                {

                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {

                }
                field("Stock"; rec."Stock")
                {

                }
                field("Quantity"; rec."Quantity")
                {

                    DecimalPlaces = 0 : 5;

                    ; trigger OnValidate()
                    BEGIN
                        //JAV 09/07/19: - Se hacen UPDATES para que refresque los factbox
                        CurrPage.UPDATE;
                    END;


                }
                field("Final Stock"; rec."Final Stock")
                {

                }
                field("Unit Cost"; rec."Unit Cost")
                {

                    Editable = False;
                }
                field("Total Cost"; rec."Total Cost")
                {

                    Editable = False;
                }
                field("Sales Price"; rec."Sales Price")
                {

                }
                field("Amount"; rec."Amount")
                {

                    Editable = False;
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
                field("Job Task No."; rec."Job Task No.")
                {

                    Visible = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("No. Serie for Tracking"; rec."No. Serie for Tracking")
                {

                    Editable = False;
                }
                field("No. Lot for Tracking"; rec."No. Lot for Tracking")
                {

                    Editable = False;
                }
                field("Devolucion"; rec."Devolucion")
                {

                    Visible = false;
                }
                field("Precio Devolucion"; rec."Precio Devolucion")
                {

                    Visible = false;
                }
                field("Cancel Mov."; rec."Cancel Mov.")
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
                action("action2")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Consumption Proposal', ESP = 'Propuesta consumo';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = ExpandDepositLine;
                    PromotedCategory = Process;


                    trigger OnAction()
                    BEGIN
                        BudgetConsuptiom;
                        UpdateForm(TRUE);
                    END;


                }

            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        rec.ShowShortcutDimCode(ShortcutDimCode);
        IF rItem.GET(rec."No.") THEN BEGIN
            IF rItem."Costing Method" = rItem."Costing Method"::FIFO THEN rec.CalcItemData;
        END;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CLEAR(ShortcutDimCode);
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    BEGIN
        //JAV 09/07/19: - Se hacen UPDATES para que refresque los factbox
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        //JAV 09/07/19: - Se hacen UPDATES para que refresque los factbox
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        //JAV 09/07/19: - Se hacen UPDATES para que refresque los factbox
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //Refrescar los stock al leer el regitro por si han cambiado
        rec.CalcItemData;
    END;



    var
        PurchaseHeader: Record 38;
        // ItemCrossReference: Record 5717;
        ItemCrossReference: Record "Item Reference";
        TransferExtendedText: Codeunit 378;
        // ConsumptionProposed: Report 7207339;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        OutputShipmentLines: Record 7207309;
        rItem: Record 27;

    procedure ShowDimensions_();
    begin
        Rec.ShowDimensions;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure BudgetConsuptiom();
    var
        OutboundWarehouseHeading: Record 7207308;
        HistLinesMeasuresProd: Record 7207402;
    begin
        OutboundWarehouseHeading.GET(rec."Document No.");
        // CLEAR(ConsumptionProposed);
        // ConsumptionProposed.SetLineShipmentOutput(Rec);
        HistLinesMeasuresProd.SETRANGE("Job No.", OutboundWarehouseHeading."Job No.");
        // ConsumptionProposed.SETTABLEVIEW(HistLinesMeasuresProd);
        // ConsumptionProposed.RUNMODAL;
    end;

    // begin
    /*{
      JAV 09/07/19: - Se hacen UPDATES para que refresque los factbox
      AML 28/06/22: - Se a�aden los campos rec."Devolucion" y "Precio Devolucion"
      CPA 06/03/23: - Q19003. Se modifica la propiedad DecimalPlaces del campo Quantity a '0:5'
    }*///end
}







