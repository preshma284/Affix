Codeunit 50003 "Item Jnl.-Post Line 1"
{


    TableNo = 83;
    Permissions = TableData 27 = imd,
                TableData 32 = imd,
                TableData 46 = imd,
                TableData 281 = imd,
                TableData 339 = imd,
                TableData 5410 = rimd,
                TableData 5700 = imd,
                TableData 5802 = imd,
                TableData 5804 = rim,
                TableData 5811 = ri,
                TableData 5832 = rimd,
                TableData 5896 = rim;
    trigger OnRun()
    BEGIN
        GetGLSetup;
        RunWithCheck(Rec);
    END;

    VAR
        Text000: TextConst ENU = 'cannot be less than zero', ESP = 'no puede ser menor a cero';
        Text001: TextConst ENU = 'Item Tracking is signed wrongly.', ESP = 'Seguim. pdto. no est� bien definido.';
        Text003: TextConst ENU = 'Reserved item %1 is not on inventory.', ESP = 'Producto reservado %1 no est� en inventario.';
        Text004: TextConst ENU = 'is too low', ESP = 'no es suficiente';
        Text011: TextConst ENU = 'Tracking Specification is missing.', ESP = 'Introduzca la especif. seguimiento.';
        Text012: TextConst ENU = 'Item %1 must be reserved.', ESP = 'Prod. %1 debe ser reservado.';
        Text014: TextConst ENU = 'Serial No. %1 is already on inventory.', ESP = 'N� serie %1 est� ya en stock.';
        SerialNoRequiredErr: TextConst ENU = 'You must assign a serial number for item %1.', ESP = 'Debe asignar un n�mero de serie al producto %1.';
        LotNoRequiredErr: TextConst ENU = 'You must assign a lot number for item %1.', ESP = 'Debe asignar un n�mero de lote al producto %1.';
        LineNoTxt: TextConst ENU = '" Line No. = ''%1''."', ESP = '" N.� l�nea = ''%1''."';
        Text017: TextConst ENU = '" is before the posting date."', ESP = '" es antes la fecha registro."';
        Text018: TextConst ENU = 'Item Tracking Serial No. %1 Lot No. %2 for Item No. %3 Variant %4 cannot be fully applied.', ESP = 'N� serie seguim. prod. %1 n� lote. %2 para n� prod. %3 variante %4 no puede ser liq. totalm.';
        Text021: TextConst ENU = 'You must not define item tracking on %1 %2.', ESP = 'No debe definir seguim. pdto. en %1 %2.';
        Text022: TextConst ENU = 'You cannot apply %1 to %2 on the same item %3 on Production Order %4.', ESP = 'No puede aplicar %1 a %2 en el mismo producto %3 en la orden de producci�n %4.';
        Text100: TextConst ENU = 'Fatal error when retrieving Tracking Specification.', ESP = 'Error grave al recuperar la especificaci�n de seguimiento.';
        Text99000000: TextConst ENU = 'must not be filled out when reservations exist', ESP = 'no debe rellenarse cuando hay reservas';
        GLSetup: Record 98;
        Currency: Record 4;
        InvtSetup: Record 313;
        MfgSetup: Record 99000765;
        Location: Record 14;
        NewLocation: Record 14;
        Item: Record 27;
        GlobalItemLedgEntry: Record 32;
        OldItemLedgEntry: Record 32;
        ItemReg: Record 46;
        ItemJnlLine: Record 83;
        ItemJnlLineOrigin: Record 83;
        SourceCodeSetup: Record 242;
        GenPostingSetup: Record 252;
        ItemApplnEntry: Record 339;
        GlobalValueEntry: Record 5802;
        DirCostValueEntry: Record 5802;
        SKU: Record 5700;
        CurrExchRate: Record 330;
        ItemTrackingCode: Record 6502;
        TempSplitItemJnlLine: Record 83 TEMPORARY;
        TempTrackingSpecification: Record 336 TEMPORARY;
        TempValueEntryRelation: Record 6508 TEMPORARY;
        TempItemEntryRelation: Record 6507 TEMPORARY;
        WhseJnlLine: Record 7311;
        TouchedItemLedgerEntries: Record 32 TEMPORARY;
        TempItemApplnEntryHistory: Record 343 TEMPORARY;
        PrevAppliedItemLedgEntry: Record 32;
        WMSMgmt: Codeunit 7302;
        WhseJnlRegisterLine: Codeunit 7301;
        ItemJnlCheckLine: Codeunit 21;
        ReservEngineMgt: Codeunit 99000831;
        ReserveItemJnlLine: Codeunit 99000835;
        ReserveItemJnlLine1: Codeunit 51364;
        ReserveProdOrderComp: Codeunit 99000838;
        ReserveProdOrderLine: Codeunit 99000837;
        JobPlanningLineReserve: Codeunit 1032;
        ItemTrackingMgt: Codeunit 6500;
        ItemTrackingMgt1: Codeunit 51151;
        InvtPost: Codeunit 5802;
        CostCalcMgt: Codeunit 5836;
        ACYMgt: Codeunit 5837;
        UOMMgt: Codeunit 5402;
        ItemLedgEntryNo: Integer;
        PhysInvtEntryNo: Integer;
        CapLedgEntryNo: Integer;
        ValueEntryNo: Integer;
        ItemApplnEntryNo: Integer;
        TotalAppliedQty: Decimal;
        OverheadAmount: Decimal;
        VarianceAmount: Decimal;
        OverheadAmountACY: Decimal;
        VarianceAmountACY: Decimal;
        QtyPerUnitOfMeasure: Decimal;
        RoundingResidualAmount: Decimal;
        RoundingResidualAmountACY: Decimal;
        InvtSetupRead: Boolean;
        GLSetupRead: Boolean;
        MfgSetupRead: Boolean;
        SKUExists: Boolean;
        AverageTransfer: Boolean;
        SNRequired: Boolean;
        LotRequired: Boolean;
        PostponeReservationHandling: Boolean;
        VarianceRequired: Boolean;
        LastOperation: Boolean;
        DisableItemTracking: Boolean;
        CalledFromInvtPutawayPick: Boolean;
        CalledFromAdjustment: Boolean;
        PostToGL: Boolean;
        ProdOrderCompModified: Boolean;
        Text023: TextConst ENU = 'Entries applied to an Outbound Transfer cannot be unapplied.', ESP = 'No se pueden desliquidar los movimientos liquidados en una transferencia salida.';
        Text024: TextConst ENU = 'Entries applied to a Drop Shipment Order cannot be unapplied.', ESP = 'No se pueden desliquidar los movimientos liquidados en un pedido env�o directo.';
        Text025: TextConst ENU = 'Entries applied to a Correction entry cannot be unapplied.', ESP = 'No se pueden desliquidar los movimientos aplicados a un movimiento de correcci�n.';
        IsServUndoConsumption: Boolean;
        Text027: TextConst ENU = 'A fixed application was not unapplied and this prevented the reapplication. Use the Application Worksheet to remove the applications.', ESP = 'No se desliquid� una liquidaci�n establecida y esto impidi� la nueva liquidaci�n. Utilice la Hoja liquidaci�n para eliminar las liquidaciones.';
        Text01: TextConst ENU = 'Checking for open entries.', ESP = 'Comprobando movimientos abiertos.';
        BlockRetrieveIT: Boolean;
        Text029: TextConst ENU = '%1 %2 for %3 %4 is reserved for %5.', ESP = '%1 %2 para %3 %4 est� reservado para %5.';
        Text030: TextConst ENU = 'The quantity that you are trying to invoice is larger than the quantity in the item ledger with the entry number %1.', ESP = 'La cantidad que est� intentando facturar es m�s grande que la de los movs. productos con el n�mero de movimiento %1.';
        Text031: TextConst ENU = 'You cannot invoice the item %1 with item tracking number %2 %3 in this purchase order before the associated sales order %4 has been invoiced.', ESP = 'No puede facturar el producto %1 con el n�m. seguimiento de producto %2 %3 en este pedido de compra antes de facturar el pedido de venta %4 asociado.';
        Text032: TextConst ENU = 'You cannot invoice item %1 in this purchase order before the associated sales order %2 has been invoiced.', ESP = 'No puede facturar el producto %1 en este pedido de compra antes de facturar el pedido de venta %2 asociado.';
        Text033: TextConst ENU = 'Quantity must be -1, 0 or 1 when Serial No. is stated.', ESP = 'La cantidad debe ser -1, 0 o 1 si se indica el N� serie.';
        SkipApplicationCheck: Boolean;
        CalledFromApplicationWorksheet: Boolean;

    //[External]
    PROCEDURE RunWithCheck(VAR ItemJnlLine2: Record 83): Boolean;
    VAR
        TrackingSpecExists: Boolean;
    BEGIN
        PrepareItem(ItemJnlLine2);
        TrackingSpecExists := ItemTrackingMgt.RetrieveItemTracking(ItemJnlLine2, TempTrackingSpecification);
        EXIT(PostSplitJnlLine(ItemJnlLine2, TrackingSpecExists));
    END;


    LOCAL PROCEDURE Code();
    BEGIN
        OnBeforePostItemJnlLine(ItemJnlLine);

        WITH ItemJnlLine DO BEGIN
            IF EmptyLine AND NOT Correction AND NOT Adjustment THEN
                IF NOT IsValueEntryForDeletedItem THEN
                    EXIT;

            ItemJnlCheckLine.SetCalledFromInvtPutawayPick(CalledFromInvtPutawayPick);
            ItemJnlCheckLine.SetCalledFromAdjustment(CalledFromAdjustment);

            ItemJnlCheckLine.RunCheck(ItemJnlLine);

            IF "Document Date" = 0D THEN
                "Document Date" := "Posting Date";

            IF ItemLedgEntryNo = 0 THEN BEGIN
                GlobalItemLedgEntry.LOCKTABLE;
                IF GlobalItemLedgEntry.FINDLAST THEN
                    ItemLedgEntryNo := GlobalItemLedgEntry."Entry No.";
            END;
            InitValueEntryNo;

            GetInvtSetup;
            IF NOT CalledFromAdjustment THEN
                PostToGL := InvtSetup."Automatic Cost Posting";
            OnCheckPostingCostToGL(PostToGL);

            IF (SNRequired OR LotRequired) AND ("Quantity (Base)" <> 0) AND
               ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
               NOT DisableItemTracking AND NOT Adjustment AND
               NOT Subcontracting AND NOT IsAssemblyResourceConsumpLine
            THEN
                CheckItemTracking;

            IF Correction THEN
                UndoQuantityPosting;

            IF ("Entry Type" IN
                ["Entry Type"::Consumption, "Entry Type"::Output, "Entry Type"::"Assembly Consumption", "Entry Type"::"Assembly Output"]) AND
               NOT ("Value Entry Type" = "Value Entry Type"::Revaluation) AND
               NOT OnlyStopTime
            THEN BEGIN
                CASE "Entry Type" OF
                    "Entry Type"::"Assembly Consumption", "Entry Type"::"Assembly Output":
                        TESTFIELD("Order Type", "Order Type"::Assembly);
                    "Entry Type"::Consumption, "Entry Type"::Output:
                        TESTFIELD("Order Type", "Order Type"::Production);
                END;
                TESTFIELD("Order No.");
                IF IsAssemblyOutputLine THEN
                    TESTFIELD("Order Line No.", 0)
                ELSE
                    TESTFIELD("Order Line No.");
            END;

            IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
               ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
            THEN
                GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");

            IF "Qty. per Unit of Measure" = 0 THEN
                "Qty. per Unit of Measure" := 1;
            IF "Qty. per Cap. Unit of Measure" = 0 THEN
                "Qty. per Cap. Unit of Measure" := 1;

            Quantity := "Quantity (Base)";
            "Invoiced Quantity" := "Invoiced Qty. (Base)";
            "Setup Time" := "Setup Time (Base)";
            "Run Time" := "Run Time (Base)";
            "Stop Time" := "Stop Time (Base)";
            "Output Quantity" := "Output Quantity (Base)";
            "Scrap Quantity" := "Scrap Quantity (Base)";

            IF NOT Subcontracting AND
               (("Entry Type" = "Entry Type"::Output) OR
                IsAssemblyResourceConsumpLine)
            THEN
                QtyPerUnitOfMeasure := "Qty. per Cap. Unit of Measure"
            ELSE
                QtyPerUnitOfMeasure := "Qty. per Unit of Measure";

            RoundingResidualAmount := 0;
            RoundingResidualAmountACY := 0;
            IF "Value Entry Type" = "Value Entry Type"::Revaluation THEN
                IF Item.GET("Item No.") AND (Item."Costing Method" = Item."Costing Method"::Average) THEN BEGIN
                    RoundingResidualAmount := Quantity *
                      ("Unit Cost" - ROUND("Unit Cost" / QtyPerUnitOfMeasure, GLSetup."Unit-Amount Rounding Precision"));
                    RoundingResidualAmountACY := Quantity *
                      ("Unit Cost (ACY)" - ROUND("Unit Cost (ACY)" / QtyPerUnitOfMeasure, Currency."Unit-Amount Rounding Precision"));
                    IF ABS(RoundingResidualAmount) < GLSetup."Amount Rounding Precision" THEN
                        RoundingResidualAmount := 0;
                    IF ABS(RoundingResidualAmountACY) < Currency."Amount Rounding Precision" THEN
                        RoundingResidualAmountACY := 0;
                END;

            "Unit Amount" := ROUND(
                "Unit Amount" / QtyPerUnitOfMeasure, GLSetup."Unit-Amount Rounding Precision");
            "Unit Cost" := ROUND(
                "Unit Cost" / QtyPerUnitOfMeasure, GLSetup."Unit-Amount Rounding Precision");
            "Unit Cost (ACY)" := ROUND(
                "Unit Cost (ACY)" / QtyPerUnitOfMeasure, Currency."Unit-Amount Rounding Precision");

            OverheadAmount := 0;
            VarianceAmount := 0;
            OverheadAmountACY := 0;
            VarianceAmountACY := 0;
            VarianceRequired := FALSE;
            LastOperation := FALSE;

            CASE TRUE OF
                IsAssemblyResourceConsumpLine:
                    PostAssemblyResourceConsump;
                Adjustment,
              "Value Entry Type" IN ["Value Entry Type"::Rounding, "Value Entry Type"::Revaluation],
              "Entry Type" = "Entry Type"::"Assembly Consumption",
              "Entry Type" = "Entry Type"::"Assembly Output":
                    PostItem;
                "Entry Type" = "Entry Type"::Consumption:
                    PostConsumption;
                "Entry Type" = "Entry Type"::Output:
                    PostOutput;
                NOT Correction:
                    PostItem;
            END;

            // Entry no. is returned to shipment/receipt
            IF Subcontracting THEN
                "Item Shpt. Entry No." := CapLedgEntryNo
            ELSE
                "Item Shpt. Entry No." := GlobalItemLedgEntry."Entry No.";
        END;

        OnAfterPostItemJnlLine(ItemJnlLine, GlobalItemLedgEntry);
    END;

    LOCAL PROCEDURE PostSplitJnlLine(VAR ItemJnlLineToPost: Record 83; TrackingSpecExists: Boolean): Boolean;
    VAR
        PostItemJnlLine: Boolean;
    BEGIN
        PostItemJnlLine := SetupSplitJnlLine(ItemJnlLineToPost, TrackingSpecExists);
        IF NOT PostItemJnlLine THEN
            PostItemJnlLine := IsNotInternalWhseMovement(ItemJnlLineToPost);

        WHILE SplitJnlLine(ItemJnlLine, PostItemJnlLine) DO
            IF PostItemJnlLine THEN
                Code;
        CLEAR(PrevAppliedItemLedgEntry);
        ItemJnlLineToPost := ItemJnlLine;
        CorrectOutputValuationDate(GlobalItemLedgEntry);
        RedoApplications;

        OnAfterPostSplitJnlLine(ItemJnlLineToPost, TempTrackingSpecification);

        EXIT(PostItemJnlLine);
    END;

    LOCAL PROCEDURE PostConsumption();
    VAR
        ProdOrderComp: Record 5407;
        TempHandlingSpecification: Record 336 TEMPORARY;
        RemQtyToPost: Decimal;
        RemQtyToPostThisLine: Decimal;
        QtyToPost: Decimal;
        UseItemTrackingApplication: Boolean;
        LastLoop: Boolean;
        EndLoop: Boolean;
        NewRemainingQty: Decimal;
    BEGIN
        WITH ProdOrderComp DO BEGIN
            ItemJnlLine.TESTFIELD("Order Type", ItemJnlLine."Order Type"::Production);
            SETCURRENTKEY(Status, "Prod. Order No.", "Prod. Order Line No.", "Item No.", "Line No.");
            SETRANGE(Status, Status::Released);
            SETRANGE("Prod. Order No.", ItemJnlLine."Order No.");
            SETRANGE("Prod. Order Line No.", ItemJnlLine."Order Line No.");
            SETRANGE("Item No.", ItemJnlLine."Item No.");
            IF ItemJnlLine."Prod. Order Comp. Line No." <> 0 THEN
                SETRANGE("Line No.", ItemJnlLine."Prod. Order Comp. Line No.");
            LOCKTABLE;

            RemQtyToPost := ItemJnlLine.Quantity;

            IF FINDSET THEN BEGIN
                IF ItemJnlLine.TrackingExists AND NOT BlockRetrieveIT THEN
                    UseItemTrackingApplication :=
                      ItemTrackingMgt.RetrieveConsumpItemTracking(ItemJnlLine, TempHandlingSpecification);

                IF UseItemTrackingApplication THEN BEGIN
                    // TempHandlingSpecification.SetTrackingFilter(ItemJnlLine."Serial No.", ItemJnlLine."Lot No.");
                    LastLoop := FALSE;
                END ELSE
                    IF ReservationExists(ItemJnlLine) THEN BEGIN
                        IF SNRequired AND (ItemJnlLine."Serial No." = '') THEN
                            ERROR(SerialNoRequiredErr, ItemJnlLine."Item No.");
                        IF LotRequired AND (ItemJnlLine."Lot No." = '') THEN
                            ERROR(LotNoRequiredErr, ItemJnlLine."Item No.");
                    END;

                REPEAT
                    IF UseItemTrackingApplication THEN BEGIN
                        TempHandlingSpecification.SETRANGE("Source Ref. No.", "Line No.");
                        IF LastLoop THEN BEGIN
                            RemQtyToPostThisLine := "Remaining Qty. (Base)";
                            IF TempHandlingSpecification.FINDSET THEN
                                REPEAT
                                    CheckItemTrackingOfComp(TempHandlingSpecification, ItemJnlLine);
                                    RemQtyToPostThisLine += TempHandlingSpecification."Qty. to Handle (Base)";
                                UNTIL TempHandlingSpecification.NEXT = 0;
                            IF RemQtyToPostThisLine * RemQtyToPost < 0 THEN
                                ERROR(Text001); // Assertion: Test signing
                        END ELSE
                            IF TempHandlingSpecification.FINDFIRST THEN BEGIN
                                RemQtyToPostThisLine := -TempHandlingSpecification."Qty. to Handle (Base)";
                                TempHandlingSpecification.DELETE;
                            END ELSE BEGIN
                                TempHandlingSpecification.ClearTrackingFilter;
                                TempHandlingSpecification.FINDFIRST;
                                CheckItemTrackingOfComp(TempHandlingSpecification, ItemJnlLine);
                                RemQtyToPostThisLine := 0;
                            END;
                        IF RemQtyToPostThisLine > RemQtyToPost THEN
                            RemQtyToPostThisLine := RemQtyToPost;
                    END ELSE BEGIN
                        RemQtyToPostThisLine := RemQtyToPost;
                        LastLoop := TRUE;
                    END;

                    QtyToPost := RemQtyToPostThisLine;
                    CALCFIELDS("Act. Consumption (Qty)");
                    NewRemainingQty := "Expected Qty. (Base)" - "Act. Consumption (Qty)" - QtyToPost;
                    NewRemainingQty := ROUND(NewRemainingQty, 0.00001);
                    IF (NewRemainingQty * "Expected Qty. (Base)") <= 0 THEN BEGIN
                        QtyToPost := "Remaining Qty. (Base)";
                        "Remaining Qty. (Base)" := 0;
                    END ELSE BEGIN
                        IF ("Remaining Qty. (Base)" * "Expected Qty. (Base)") >= 0 THEN
                            QtyToPost := "Remaining Qty. (Base)" - NewRemainingQty
                        ELSE
                            QtyToPost := NewRemainingQty;
                        "Remaining Qty. (Base)" := NewRemainingQty;
                    END;

                    "Remaining Quantity" := ROUND("Remaining Qty. (Base)" / "Qty. per Unit of Measure", 0.00001);

                    IF QtyToPost <> 0 THEN BEGIN
                        RemQtyToPost := RemQtyToPost - QtyToPost;
                        MODIFY;
                        IF ProdOrderCompModified THEN
                            InsertConsumpEntry(ProdOrderComp, "Line No.", QtyToPost, FALSE)
                        ELSE
                            InsertConsumpEntry(ProdOrderComp, "Line No.", QtyToPost, TRUE);
                    END;

                    IF UseItemTrackingApplication THEN BEGIN
                        IF NEXT = 0 THEN BEGIN
                            EndLoop := LastLoop;
                            LastLoop := TRUE;
                            FINDFIRST;
                            TempHandlingSpecification.RESET;
                        END;
                    END ELSE
                        EndLoop := NEXT = 0;

                UNTIL EndLoop OR (RemQtyToPost = 0);
            END;

            IF RemQtyToPost <> 0 THEN
                InsertConsumpEntry(ProdOrderComp, ItemJnlLine."Prod. Order Comp. Line No.", RemQtyToPost, FALSE);
        END;
        ProdOrderCompModified := FALSE;
    END;

    LOCAL PROCEDURE PostOutput();
    VAR
        MfgItem: Record 27;
        MfgSKU: Record 5700;
        MachCenter: Record 99000758;
        WorkCenter: Record 99000754;
        CapLedgEntry: Record 5832;
        ProdOrder: Record 5405;
        ProdOrderLine: Record 5406;
        ProdOrderRtngLine: Record 5409;
        ItemLedgerEntry: Record 32;
        DirCostAmt: Decimal;
        IndirCostAmt: Decimal;
        ValuedQty: Decimal;
        MfgUnitCost: Decimal;
        ReTrack: Boolean;
        PostWhseJnlLine: Boolean;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF "Stop Time" <> 0 THEN BEGIN
                InsertCapLedgEntry(CapLedgEntry, "Stop Time", "Stop Time");
                IF OnlyStopTime THEN
                    EXIT;
            END;

            IF OutputValuePosting THEN BEGIN
                PostItem;
                EXIT;
            END;

            IF Subcontracting THEN
                ValuedQty := "Invoiced Quantity"
            ELSE
                ValuedQty := CalcCapQty;

            IF Item.GET("Item No.") THEN
                IF NOT CalledFromAdjustment THEN
                    Item.TESTFIELD("Inventory Value Zero", FALSE);

            IF "Item Shpt. Entry No." <> 0 THEN
                CapLedgEntry.GET("Item Shpt. Entry No.")
            ELSE BEGIN
                TESTFIELD("Order Type", "Order Type"::Production);
                ProdOrder.GET(ProdOrder.Status::Released, "Order No.");
                ProdOrder.TESTFIELD(Blocked, FALSE);
                ProdOrderLine.LOCKTABLE;
                ProdOrderLine.GET(ProdOrder.Status::Released, "Order No.", "Order Line No.");

                "Inventory Posting Group" := ProdOrderLine."Inventory Posting Group";

                ProdOrderRtngLine.SETRANGE(Status, ProdOrderRtngLine.Status::Released);
                ProdOrderRtngLine.SETRANGE("Prod. Order No.", "Order No.");
                ProdOrderRtngLine.SETRANGE("Routing Reference No.", "Routing Reference No.");
                ProdOrderRtngLine.SETRANGE("Routing No.", "Routing No.");
                IF ProdOrderRtngLine.FINDFIRST THEN BEGIN
                    TESTFIELD("Operation No.");
                    TESTFIELD("No.");

                    IF Type = Type::"Machine Center" THEN BEGIN
                        MachCenter.GET("No.");
                        MachCenter.TESTFIELD(MachCenter.Blocked, FALSE);
                    END;
                    WorkCenter.GET("Work Center No.");
                    WorkCenter.TESTFIELD(WorkCenter.Blocked, FALSE);

                    ApplyCapNeed("Setup Time (Base)", "Run Time (Base)");
                END;

                IF "Operation No." <> '' THEN BEGIN
                    ProdOrderRtngLine.GET(
                      ProdOrderRtngLine.Status::Released, "Order No.",
                      "Routing Reference No.", "Routing No.", "Operation No.");
                    IF Finished THEN
                        ProdOrderRtngLine."Routing Status" := ProdOrderRtngLine."Routing Status"::Finished
                    ELSE
                        ProdOrderRtngLine."Routing Status" := ProdOrderRtngLine."Routing Status"::"In Progress";
                    LastOperation := (NOT NextOperationExist(ProdOrderRtngLine));
                    OnPostOutputOnBeforeProdOrderRtngLineModify(ProdOrderRtngLine, ProdOrderLine);
                    ProdOrderRtngLine.MODIFY;
                END ELSE
                    LastOperation := TRUE;

                IF Subcontracting THEN
                    InsertCapLedgEntry(CapLedgEntry, Quantity, "Invoiced Quantity")
                ELSE
                    InsertCapLedgEntry(CapLedgEntry, ValuedQty, ValuedQty);

                IF "Output Quantity" >= 0 THEN
                    FlushOperation(ProdOrder, ProdOrderLine);
            END;

            CalcDirAndIndirCostAmts(DirCostAmt, IndirCostAmt, ValuedQty, "Unit Cost", "Indirect Cost %", "Overhead Rate");

            InsertCapValueEntry(CapLedgEntry, "Value Entry Type"::"Direct Cost", ValuedQty, ValuedQty, DirCostAmt);//enum to option
            InsertCapValueEntry(CapLedgEntry, "Value Entry Type"::"Indirect Cost", ValuedQty, 0, IndirCostAmt);//enum to option

            IF LastOperation AND ("Output Quantity" <> 0) THEN BEGIN
                CheckItemTracking;
                IF ("Output Quantity" < 0) AND NOT Adjustment THEN BEGIN
                    IF "Applies-to Entry" = 0 THEN
                        "Applies-to Entry" := FindOpenOutputEntryNoToApply(ItemJnlLine);
                    TESTFIELD("Applies-to Entry");
                    ItemLedgerEntry.GET("Applies-to Entry");
                    TESTFIELD("Lot No.", ItemLedgerEntry."Lot No.");
                    TESTFIELD("Serial No.", ItemLedgerEntry."Serial No.");
                END;
                MfgItem.GET(ProdOrderLine."Item No.");
                MfgItem.TESTFIELD("Gen. Prod. Posting Group");

                IF Subcontracting THEN
                    MfgUnitCost := ProdOrderLine."Unit Cost"
                ELSE
                    IF MfgSKU.GET(ProdOrderLine."Location Code", ProdOrderLine."Item No.", ProdOrderLine."Variant Code") THEN
                        MfgUnitCost := MfgSKU."Unit Cost"
                    ELSE
                        MfgUnitCost := MfgItem."Unit Cost";

                Amount := "Output Quantity" * MfgUnitCost;
                "Amount (ACY)" := ACYMgt.CalcACYAmt(Amount, "Posting Date", FALSE);
                OnPostOutputOnAfterUpdateAmounts(ItemJnlLine);

                "Gen. Bus. Posting Group" := ProdOrder."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := MfgItem."Gen. Prod. Posting Group";
                IF "Output Quantity (Base)" * ProdOrderLine."Remaining Qty. (Base)" <= 0 THEN
                    ReTrack := TRUE
                ELSE
                    IF NOT CalledFromInvtPutawayPick THEN
                        ReserveProdOrderLine.TransferPOLineToItemJnlLine(
                          ProdOrderLine, ItemJnlLine, "Output Quantity (Base)");

                PostWhseJnlLine := TRUE;
                OnPostOutputOnBeforeCreateWhseJnlLine(ItemJnlLine, PostWhseJnlLine);
                IF PostWhseJnlLine THEN BEGIN
                    GetLocation("Location Code");
                    IF Location."Bin Mandatory" AND (NOT CalledFromInvtPutawayPick) THEN BEGIN
                        WMSMgmt.CreateWhseJnlLineFromOutputJnl(ItemJnlLine, WhseJnlLine);
                        WMSMgmt.CheckWhseJnlLine(WhseJnlLine, 2, 0, FALSE);
                    END;
                END;

                Description := ProdOrderLine.Description;
                IF Subcontracting THEN BEGIN
                    "Document Type" := "Document Type"::" ";
                    "Document No." := "Order No.";
                    "Document Line No." := 0;
                    "Invoiced Quantity" := 0;
                END;
                PostItem;
                UpdateProdOrderLine(ProdOrderLine, ReTrack);
                IF Location."Bin Mandatory" AND (NOT CalledFromInvtPutawayPick) THEN
                    WhseJnlRegisterLine.RegisterWhseJnlLine(WhseJnlLine);
            END;
        END;
    END;

    LOCAL PROCEDURE PostItem();
    BEGIN
        WITH ItemJnlLine DO BEGIN
            SKUExists := SKU.GET("Location Code", "Item No.", "Variant Code");
            IF "Item Shpt. Entry No." <> 0 THEN BEGIN
                "Location Code" := '';
                "Variant Code" := '';
            END;

            IF Item.GET("Item No.") THEN BEGIN
                IF NOT CalledFromAdjustment THEN
                    DisplayErrorIfItemIsBlocked(Item);
                Item.CheckBlockedByApplWorksheet;
            END;

            IF ("Inventory Posting Group" = '') AND (Item.Type = Item.Type::Inventory) THEN BEGIN
                Item.TESTFIELD("Inventory Posting Group");
                "Inventory Posting Group" := Item."Inventory Posting Group";
            END;

            IF ("Entry Type" = "Entry Type"::Transfer) AND
               (Item."Costing Method" = Item."Costing Method"::Average) AND
               ("Applies-to Entry" = 0)
            THEN BEGIN
                AverageTransfer := TRUE;
                TotalAppliedQty := 0;
            END ELSE
                AverageTransfer := FALSE;

            IF "Job Contract Entry No." <> 0 THEN
                TransReserveFromJobPlanningLine("Job Contract Entry No.", ItemJnlLine);

            IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                "Overhead Rate" := Item."Overhead Rate";
                "Indirect Cost %" := Item."Indirect Cost %";
            END;

            IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
               ("Item Charge No." <> '')
            THEN BEGIN
                "Overhead Rate" := 0;
                "Indirect Cost %" := 0;
            END;

            IF (Quantity <> 0) AND
               ("Item Charge No." = '') AND
               NOT ("Value Entry Type" IN ["Value Entry Type"::Revaluation, "Value Entry Type"::Rounding]) AND
               NOT Adjustment
            THEN
                ItemQtyPosting
            ELSE
                IF ("Invoiced Quantity" <> 0) OR Adjustment OR
                   IsInterimRevaluation
                THEN BEGIN
                    IF "Value Entry Type" = "Value Entry Type"::"Direct Cost" THEN BEGIN
                        IF Item.Type <> Item.Type::"Non-Inventory" THEN
                            GlobalItemLedgEntry.GET("Item Shpt. Entry No.")
                        ELSE
                            IF NOT GlobalItemLedgEntry.GET("Item Shpt. Entry No.") THEN
                                EXIT;
                    END ELSE
                        GlobalItemLedgEntry.GET("Applies-to Entry");
                    CorrectOutputValuationDate(GlobalItemLedgEntry);
                    InitValueEntry(GlobalValueEntry, GlobalItemLedgEntry);
                END;
            IF ((Quantity <> 0) OR ("Invoiced Quantity" <> 0)) AND
               NOT (Adjustment AND (Amount = 0) AND ("Amount (ACY)" = 0))
            THEN
                ItemValuePosting;

            UpdateUnitCost(GlobalValueEntry);
        END;
    END;

    LOCAL PROCEDURE InsertConsumpEntry(VAR ProdOrderComp: Record 5407; ProdOrderCompLineNo: Integer; QtyBase: Decimal; ModifyProdOrderComp: Boolean);
    VAR
        PostWhseJnlLine: Boolean;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            Quantity := QtyBase;
            "Quantity (Base)" := QtyBase;
            "Invoiced Quantity" := QtyBase;
            "Invoiced Qty. (Base)" := QtyBase;
            "Prod. Order Comp. Line No." := ProdOrderCompLineNo;
            IF ModifyProdOrderComp THEN BEGIN
                IF NOT CalledFromInvtPutawayPick THEN
                    ReserveProdOrderComp.TransferPOCompToItemJnlLine(ProdOrderComp, ItemJnlLine, QtyBase);
                ProdOrderComp.MODIFY;
            END;

            IF "Value Entry Type" <> "Value Entry Type"::Revaluation THEN BEGIN
                GetLocation("Location Code");
                IF Location."Bin Mandatory" AND (NOT CalledFromInvtPutawayPick) THEN BEGIN
                    WMSMgmt.CreateWhseJnlLineFromConsumJnl(ItemJnlLine, WhseJnlLine);
                    WMSMgmt.CheckWhseJnlLine(WhseJnlLine, 3, 0, FALSE);
                    PostWhseJnlLine := TRUE;
                END;
            END;
        END;

        PostItem;
        IF PostWhseJnlLine THEN
            WhseJnlRegisterLine.RegisterWhseJnlLine(WhseJnlLine);
    END;

    LOCAL PROCEDURE CalcCapQty() CapQty: Decimal;
    BEGIN
        GetMfgSetup;

        WITH ItemJnlLine DO BEGIN
            IF "Unit Cost Calculation" = "Unit Cost Calculation"::Time THEN BEGIN
                IF MfgSetup."Cost Incl. Setup" THEN
                    CapQty := "Setup Time" + "Run Time"
                ELSE
                    CapQty := "Run Time";
            END ELSE
                CapQty := Quantity + "Scrap Quantity";
        END;
    END;

    LOCAL PROCEDURE CalcDirAndIndirCostAmts(VAR DirCostAmt: Decimal; VAR IndirCostAmt: Decimal; CapQty: Decimal; UnitCost: Decimal; IndirCostPct: Decimal; OvhdRate: Decimal);
    VAR
        CostAmt: Decimal;
    BEGIN
        CostAmt := ROUND(CapQty * UnitCost);
        DirCostAmt := ROUND((CostAmt - CapQty * OvhdRate) / (1 + IndirCostPct / 100));
        IndirCostAmt := CostAmt - DirCostAmt;
    END;

    LOCAL PROCEDURE ApplyCapNeed(PostedSetupTime: Decimal; PostedRunTime: Decimal);
    VAR
        ProdOrderCapNeed: Record 5410;
        Qty: Decimal;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            ProdOrderCapNeed.LOCKTABLE;
            ProdOrderCapNeed.RESET;
            ProdOrderCapNeed.SETCURRENTKEY(
              Status, "Prod. Order No.", "Routing Reference No.", "Operation No.", Date, "Starting Time");
            ProdOrderCapNeed.SETRANGE(Status, ProdOrderCapNeed.Status::Released);
            ProdOrderCapNeed.SETRANGE("Prod. Order No.", "Order No.");
            ProdOrderCapNeed.SETRANGE("Requested Only", FALSE);
            ProdOrderCapNeed.SETRANGE("Routing No.", "Routing No.");
            ProdOrderCapNeed.SETRANGE("Routing Reference No.", "Routing Reference No.");
            ProdOrderCapNeed.SETRANGE("Operation No.", "Operation No.");

            IF Finished THEN
                ProdOrderCapNeed.MODIFYALL("Allocated Time", 0)
            ELSE BEGIN
                IF PostedSetupTime <> 0 THEN BEGIN
                    // ProdOrderCapNeed.SETRANGE("Time Type", ProdOrderCapNeed."Time Type"::Setup);
                    IF ProdOrderCapNeed.FINDSET THEN
                        REPEAT
                            IF ProdOrderCapNeed."Allocated Time" > PostedSetupTime THEN
                                Qty := PostedSetupTime
                            ELSE
                                Qty := ProdOrderCapNeed."Allocated Time";
                            ProdOrderCapNeed."Allocated Time" :=
                              ProdOrderCapNeed."Allocated Time" - Qty;
                            ProdOrderCapNeed.MODIFY;
                            PostedSetupTime := PostedSetupTime - Qty;
                        UNTIL (ProdOrderCapNeed.NEXT = 0) OR (PostedSetupTime = 0);
                END;

                IF PostedRunTime <> 0 THEN BEGIN
                    // ProdOrderCapNeed.SETRANGE("Time Type", ProdOrderCapNeed."Time Type"::Run);
                    IF ProdOrderCapNeed.FINDSET THEN
                        REPEAT
                            IF ProdOrderCapNeed."Allocated Time" > PostedRunTime THEN
                                Qty := PostedRunTime
                            ELSE
                                Qty := ProdOrderCapNeed."Allocated Time";
                            ProdOrderCapNeed."Allocated Time" :=
                              ProdOrderCapNeed."Allocated Time" - Qty;
                            ProdOrderCapNeed.MODIFY;
                            PostedRunTime := PostedRunTime - Qty;
                        UNTIL (ProdOrderCapNeed.NEXT = 0) OR (PostedRunTime = 0);
                END;
            END;
        END;
    END;

    LOCAL PROCEDURE UpdateProdOrderLine(VAR ProdOrderLine: Record 5406; ReTrack: Boolean);
    VAR
        ReservMgt: Codeunit 99000845;
      ReservMgt1 : Codeunit 51372;
    BEGIN
        WITH ProdOrderLine DO BEGIN
            IF ItemJnlLine."Output Quantity (Base)" > "Remaining Qty. (Base)" THEN
                ReserveProdOrderLine.AssignForPlanning(ProdOrderLine);
            "Finished Qty. (Base)" := "Finished Qty. (Base)" + ItemJnlLine."Output Quantity (Base)";
            "Finished Quantity" := "Finished Qty. (Base)" / "Qty. per Unit of Measure";
            IF "Finished Qty. (Base)" < 0 THEN
                FIELDERROR("Finished Quantity", Text000);
            "Remaining Qty. (Base)" := "Quantity (Base)" - "Finished Qty. (Base)";
            IF "Remaining Qty. (Base)" < 0 THEN
                "Remaining Qty. (Base)" := 0;
            "Remaining Quantity" := "Remaining Qty. (Base)" / "Qty. per Unit of Measure";
            MODIFY;

            IF ReTrack THEN BEGIN
                ReservMgt1.SetProdOrderLine(ProdOrderLine);
                ReservMgt.ClearSurplus;
                ReservMgt.AutoTrack("Remaining Qty. (Base)");
            END;
        END;

        OnAfterUpdateProdOrderLine(ProdOrderLine, ReTrack);
    END;

    LOCAL PROCEDURE InsertCapLedgEntry(VAR CapLedgEntry: Record 5832; Qty: Decimal; InvdQty: Decimal);
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF CapLedgEntryNo = 0 THEN BEGIN
                CapLedgEntry.LOCKTABLE;
                IF CapLedgEntry.FINDLAST THEN
                    CapLedgEntryNo := CapLedgEntry."Entry No.";
            END;

            CapLedgEntryNo := CapLedgEntryNo + 1;

            CapLedgEntry.INIT;
            CapLedgEntry."Entry No." := CapLedgEntryNo;

            CapLedgEntry."Operation No." := "Operation No.";
            CapLedgEntry.Type := Type;
            CapLedgEntry."No." := "No.";
            CapLedgEntry.Description := Description;
            CapLedgEntry."Work Center No." := "Work Center No.";
            CapLedgEntry."Work Center Group Code" := "Work Center Group Code";
            CapLedgEntry.Subcontracting := Subcontracting;

            CapLedgEntry.Quantity := Qty;
            CapLedgEntry."Invoiced Quantity" := InvdQty;
            CapLedgEntry."Completely Invoiced" := CapLedgEntry."Invoiced Quantity" = CapLedgEntry.Quantity;

            CapLedgEntry."Setup Time" := "Setup Time";
            CapLedgEntry."Run Time" := "Run Time";
            CapLedgEntry."Stop Time" := "Stop Time";

            IF "Unit Cost Calculation" = "Unit Cost Calculation"::Time THEN BEGIN
                CapLedgEntry."Cap. Unit of Measure Code" := "Cap. Unit of Measure Code";
                CapLedgEntry."Qty. per Cap. Unit of Measure" := "Qty. per Cap. Unit of Measure";
            END;

            CapLedgEntry."Item No." := "Item No.";
            CapLedgEntry."Variant Code" := "Variant Code";
            CapLedgEntry."Output Quantity" := "Output Quantity";
            CapLedgEntry."Scrap Quantity" := "Scrap Quantity";
            CapLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
            CapLedgEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";

            CapLedgEntry."Order Type" := "Order Type";
            CapLedgEntry."Order No." := "Order No.";
            CapLedgEntry."Order Line No." := "Order Line No.";
            CapLedgEntry."Routing No." := "Routing No.";
            CapLedgEntry."Routing Reference No." := "Routing Reference No.";
            CapLedgEntry."Operation No." := "Operation No.";

            CapLedgEntry."Posting Date" := "Posting Date";
            CapLedgEntry."Document Date" := "Document Date";
            CapLedgEntry."Document No." := "Document No.";
            CapLedgEntry."External Document No." := "External Document No.";

            CapLedgEntry."Starting Time" := "Starting Time";
            CapLedgEntry."Ending Time" := "Ending Time";
            CapLedgEntry."Concurrent Capacity" := "Concurrent Capacity";
            CapLedgEntry."Work Shift Code" := "Work Shift Code";

            CapLedgEntry."Stop Code" := "Stop Code";
            CapLedgEntry."Scrap Code" := "Scrap Code";
            CapLedgEntry."Last Output Line" := LastOperation;

            CapLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            CapLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            CapLedgEntry."Dimension Set ID" := "Dimension Set ID";

            OnBeforeInsertCapLedgEntry(CapLedgEntry, ItemJnlLine);

            CapLedgEntry.INSERT;

            OnAfterInsertCapLedgEntry(CapLedgEntry, ItemJnlLine);

            InsertItemReg(0, 0, 0, CapLedgEntry."Entry No.");
        END;
    END;

    LOCAL PROCEDURE InsertCapValueEntry(VAR CapLedgEntry: Record 5832; ValueEntryType: Enum "Cost Entry Type"; ValuedQty: Decimal; InvdQty: Decimal; AdjdCost: Decimal);
    VAR
        ValueEntry: Record 5802;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF (InvdQty = 0) AND (AdjdCost = 0) THEN
                EXIT;

            ValueEntryNo := ValueEntryNo + 1;

            ValueEntry.INIT;
            ValueEntry."Entry No." := ValueEntryNo;
            ValueEntry."Capacity Ledger Entry No." := CapLedgEntry."Entry No.";
            ValueEntry."Entry Type" := ValueEntryType;//option to enum
            ValueEntry."Item Ledger Entry Type" := ValueEntry."Item Ledger Entry Type"::" ";

            ValueEntry.Type := Type;
            ValueEntry."No." := "No.";
            ValueEntry.Description := Description;
            ValueEntry."Order Type" := "Order Type";
            ValueEntry."Order No." := "Order No.";
            ValueEntry."Order Line No." := "Order Line No.";
            ValueEntry."Source Type" := "Source Type";
            ValueEntry."Source No." := GetSourceNo(ItemJnlLine);
            ValueEntry."Invoiced Quantity" := InvdQty;
            ValueEntry."Valued Quantity" := ValuedQty;

            ValueEntry."Cost Amount (Actual)" := AdjdCost;
            ValueEntry."Cost Amount (Actual) (ACY)" := ACYMgt.CalcACYAmt(AdjdCost, "Posting Date", FALSE);
            OnInsertCapValueEntryOnAfterUpdateCostAmounts(ValueEntry, ItemJnlLine);

            ValueEntry."Cost per Unit" :=
              CalcCostPerUnit(ValueEntry."Cost Amount (Actual)", ValueEntry."Valued Quantity", FALSE);
            ValueEntry."Cost per Unit (ACY)" :=
              CalcCostPerUnit(ValueEntry."Cost Amount (Actual) (ACY)", ValueEntry."Valued Quantity", TRUE);
            ValueEntry.Inventoriable := TRUE;

            IF Type = Type::Resource THEN
                TESTFIELD("Inventory Posting Group", '')
            ELSE
                TESTFIELD("Inventory Posting Group");
            ValueEntry."Inventory Posting Group" := "Inventory Posting Group";
            ValueEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            ValueEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";

            ValueEntry."Posting Date" := "Posting Date";
            ValueEntry."Valuation Date" := "Posting Date";
            ValueEntry."Source No." := GetSourceNo(ItemJnlLine);
            ValueEntry."Document Type" := "Document Type";
            IF ValueEntry."Expected Cost" OR ("Invoice No." = '') THEN
                ValueEntry."Document No." := "Document No."
            ELSE BEGIN
                ValueEntry."Document No." := "Invoice No.";
                IF "Document Type" IN
                   ["Document Type"::"Purchase Receipt", "Document Type"::"Purchase Return Shipment",
                    "Document Type"::"Sales Shipment", "Document Type"::"Sales Return Receipt",
                    "Document Type"::"Service Shipment"]
                THEN
                    ValueEntry."Document Type" := Enum::"Item Ledger Document Type".FromInteger("Document Type".AsInteger() + 1);
            END;
            ValueEntry."Document Line No." := "Document Line No.";
            ValueEntry."Document Date" := "Document Date";
            ValueEntry."External Document No." := "External Document No.";
            ValueEntry."User ID" := USERID;
            ValueEntry."Source Code" := "Source Code";
            ValueEntry."Reason Code" := "Reason Code";
            ValueEntry."Journal Batch Name" := "Journal Batch Name";

            ValueEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            ValueEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            ValueEntry."Dimension Set ID" := "Dimension Set ID";

            OnBeforeInsertCapValueEntry(ValueEntry, ItemJnlLine);

            InvtPost.SetRunOnlyCheck(TRUE, NOT InvtSetup."Automatic Cost Posting", FALSE);
            IF InvtPost.BufferInvtPosting(ValueEntry) THEN
                InvtPost.PostInvtPostBufPerEntry(ValueEntry);

            ValueEntry.INSERT(TRUE);
            OnAfterInsertCapValueEntry(ValueEntry, ItemJnlLine);

            UpdateAdjmtProp(ValueEntry, CapLedgEntry."Posting Date");

            InsertItemReg(0, 0, ValueEntry."Entry No.", 0);
            InsertPostValueEntryToGL(ValueEntry);
            IF Item."Item Tracking Code" <> '' THEN BEGIN
                TempValueEntryRelation.INIT;
                TempValueEntryRelation."Value Entry No." := ValueEntry."Entry No.";
                TempValueEntryRelation.INSERT;
            END;
            IF ("Item Shpt. Entry No." <> 0) AND
               (ValueEntryType = "Value Entry Type"::"Direct Cost")
            THEN BEGIN
                CapLedgEntry."Invoiced Quantity" := CapLedgEntry."Invoiced Quantity" + "Invoiced Quantity";
                IF Subcontracting THEN
                    CapLedgEntry."Completely Invoiced" := CapLedgEntry."Invoiced Quantity" = CapLedgEntry."Output Quantity"
                ELSE
                    CapLedgEntry."Completely Invoiced" := CapLedgEntry."Invoiced Quantity" = CapLedgEntry.Quantity;
                CapLedgEntry.MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE ItemQtyPosting();
    VAR
        IsReserved: Boolean;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF Quantity <> "Invoiced Quantity" THEN
                TESTFIELD("Invoiced Quantity", 0);
            TESTFIELD("Item Shpt. Entry No.", 0);

            InitItemLedgEntry(GlobalItemLedgEntry);
            InitValueEntry(GlobalValueEntry, GlobalItemLedgEntry);

            IF Item.Type = Item.Type::Inventory THEN BEGIN
                GlobalItemLedgEntry."Remaining Quantity" := GlobalItemLedgEntry.Quantity;
                GlobalItemLedgEntry.Open := GlobalItemLedgEntry."Remaining Quantity" <> 0;
            END ELSE BEGIN
                GlobalItemLedgEntry."Remaining Quantity" := 0;
                GlobalItemLedgEntry.Open := FALSE;
            END;
            GlobalItemLedgEntry.Positive := GlobalItemLedgEntry.Quantity > 0;
            IF GlobalItemLedgEntry."Entry Type" = GlobalItemLedgEntry."Entry Type"::Transfer THEN
                GlobalItemLedgEntry."Completely Invoiced" := TRUE;

            IF GlobalItemLedgEntry.Quantity > 0 THEN
                IF GlobalItemLedgEntry."Entry Type" <> GlobalItemLedgEntry."Entry Type"::Transfer THEN
                    IsReserved :=
                      ReserveItemJnlLine.TransferItemJnlToItemLedgEntry(
                        ItemJnlLine, GlobalItemLedgEntry, "Quantity (Base)", TRUE);

            ApplyItemLedgEntry(GlobalItemLedgEntry, OldItemLedgEntry, GlobalValueEntry, FALSE);
            CheckApplFromInProduction(GlobalItemLedgEntry, "Applies-from Entry");
            AutoTrack(GlobalItemLedgEntry, IsReserved);

            IF ("Entry Type" = "Entry Type"::Transfer) AND AverageTransfer THEN
                InsertTransferEntry(GlobalItemLedgEntry, OldItemLedgEntry, TotalAppliedQty);

            IF "Entry Type" IN ["Entry Type"::"Assembly Output", "Entry Type"::"Assembly Consumption"] THEN
                InsertAsmItemEntryRelation(GlobalItemLedgEntry);

            IF (NOT "Phys. Inventory") OR (Quantity <> 0) THEN BEGIN
                InsertItemLedgEntry(GlobalItemLedgEntry, FALSE);
                IF GlobalItemLedgEntry.Positive THEN
                    InsertApplEntry(
                      GlobalItemLedgEntry."Entry No.", GlobalItemLedgEntry."Entry No.",
                      "Applies-from Entry", 0, GlobalItemLedgEntry."Posting Date",
                      GlobalItemLedgEntry.Quantity, TRUE);
            END;
        END;
    END;

    LOCAL PROCEDURE ItemValuePosting();
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
               ("Item Charge No." = '') AND
               NOT Adjustment
            THEN
                IF (Quantity = 0) AND ("Invoiced Quantity" <> 0) THEN BEGIN
                    IF (GlobalValueEntry."Invoiced Quantity" < 0) AND
                       (Item."Costing Method" = Item."Costing Method"::Average)
                    THEN
                        ValuateAppliedAvgEntry(GlobalValueEntry, Item);
                END ELSE BEGIN
                    IF (GlobalValueEntry."Valued Quantity" < 0) AND ("Entry Type" <> "Entry Type"::Transfer) THEN
                        IF Item."Costing Method" = Item."Costing Method"::Average THEN
                            ValuateAppliedAvgEntry(GlobalValueEntry, Item);
                END;

            InsertValueEntry(GlobalValueEntry, GlobalItemLedgEntry, FALSE);

            IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
               ("Item Charge No." <> '')
            THEN BEGIN
                IF ("Value Entry Type" <> "Value Entry Type"::Rounding) AND (NOT Adjustment) THEN BEGIN
                    IF GlobalItemLedgEntry.Positive THEN
                        GlobalItemLedgEntry.MODIFY;
                    IF ((GlobalValueEntry."Valued Quantity" > 0) OR
                        (("Applies-to Entry" <> 0) AND ("Entry Type" IN ["Entry Type"::Purchase, "Entry Type"::"Assembly Output"]))) AND
                       (OverheadAmount <> 0)
                    THEN
                        InsertOHValueEntry(GlobalValueEntry, OverheadAmount, OverheadAmountACY);
                    IF (Item."Costing Method" = Item."Costing Method"::Standard) AND
                       ("Entry Type" = "Entry Type"::Purchase) AND
                       (GlobalValueEntry."Entry Type" <> GlobalValueEntry."Entry Type"::Revaluation)
                    THEN
                        InsertVarValueEntry(
                          GlobalValueEntry,
                          -GlobalValueEntry."Cost Amount (Actual)" + OverheadAmount,
                          -(GlobalValueEntry."Cost Amount (Actual) (ACY)" + OverheadAmountACY));
                END;
            END ELSE BEGIN
                IF IsBalanceExpectedCostFromRev(ItemJnlLine) THEN
                    InsertBalanceExpCostRevEntry(GlobalValueEntry);

                IF ((GlobalValueEntry."Valued Quantity" > 0) OR
                    (("Applies-to Entry" <> 0) AND ("Entry Type" IN ["Entry Type"::Purchase, "Entry Type"::"Assembly Output"]))) AND
                   (OverheadAmount <> 0)
                THEN
                    InsertOHValueEntry(GlobalValueEntry, OverheadAmount, OverheadAmountACY);

                IF ((GlobalValueEntry."Valued Quantity" > 0) OR ("Applies-to Entry" <> 0)) AND
                   ("Entry Type" = "Entry Type"::Purchase) AND
                   (Item."Costing Method" = Item."Costing Method"::Standard) AND
                   (ROUND(VarianceAmount, GLSetup."Amount Rounding Precision") <> 0) OR
                   VarianceRequired
                THEN
                    InsertVarValueEntry(GlobalValueEntry, VarianceAmount, VarianceAmountACY);
            END;
            IF (GlobalValueEntry."Valued Quantity" < 0) AND
               (GlobalItemLedgEntry.Quantity = GlobalItemLedgEntry."Invoiced Quantity")
            THEN
                UpdateItemApplnEntry(GlobalValueEntry."Item Ledger Entry No.", "Posting Date");
        END;

        OnAfterItemValuePosting(GlobalValueEntry, ItemJnlLine, Item);
    END;

    LOCAL PROCEDURE FlushOperation(ProdOrder: Record 5405; ProdOrderLine: Record 5406);
    VAR
        ProdOrderRtngLine: Record 5409;
        ProdOrderComp: Record 5407;
        OldItemJnlLine: Record 83;
        OldTempSplitItemJnlLine: Record 83 TEMPORARY;
        OldItemTrackingCode: Record 6502;
        OldSNRequired: Boolean;
        OldLotRequired: Boolean;
        xCalledFromInvtPutawayPick: Boolean;
    BEGIN
        IF ItemJnlLine."Operation No." = '' THEN
            EXIT;

        OldItemJnlLine := ItemJnlLine;
        OldTempSplitItemJnlLine.RESET;
        OldTempSplitItemJnlLine.DELETEALL;
        TempSplitItemJnlLine.RESET;
        IF TempSplitItemJnlLine.FINDSET THEN
            REPEAT
                OldTempSplitItemJnlLine := TempSplitItemJnlLine;
                OldTempSplitItemJnlLine.INSERT;
            UNTIL TempSplitItemJnlLine.NEXT = 0;
        OldSNRequired := SNRequired;
        OldLotRequired := LotRequired;
        OldItemTrackingCode := ItemTrackingCode;
        xCalledFromInvtPutawayPick := CalledFromInvtPutawayPick;
        CalledFromInvtPutawayPick := FALSE;

        ProdOrderRtngLine.GET(
          ProdOrderRtngLine.Status::Released,
          OldItemJnlLine."Order No.",
          OldItemJnlLine."Routing Reference No.",
          OldItemJnlLine."Routing No.",
          OldItemJnlLine."Operation No.");
        IF ProdOrderRtngLine."Routing Link Code" <> '' THEN
            WITH ProdOrderComp DO BEGIN
                SETCURRENTKEY(Status, "Prod. Order No.", "Routing Link Code", "Flushing Method");
                SETRANGE("Flushing Method", "Flushing Method"::Forward, "Flushing Method"::"Pick + Backward");
                SETRANGE("Routing Link Code", ProdOrderRtngLine."Routing Link Code");
                SETRANGE(Status, Status::Released);
                SETRANGE("Prod. Order No.", OldItemJnlLine."Order No.");
                SETRANGE("Prod. Order Line No.", OldItemJnlLine."Order Line No.");
                IF FINDSET THEN BEGIN
                    BlockRetrieveIT := TRUE;
                    REPEAT
                        PostFlushedConsump(
                          ProdOrder, ProdOrderLine, ProdOrderComp,
                          OldItemJnlLine."Output Quantity (Base)" + OldItemJnlLine."Scrap Quantity (Base)",
                          OldItemJnlLine."Posting Date", OldItemJnlLine."Document No.");
                    UNTIL NEXT = 0;
                    BlockRetrieveIT := FALSE;
                END;
            END;

        ItemJnlLine := OldItemJnlLine;
        TempSplitItemJnlLine.RESET;
        TempSplitItemJnlLine.DELETEALL;
        IF OldTempSplitItemJnlLine.FINDSET THEN
            REPEAT
                TempSplitItemJnlLine := OldTempSplitItemJnlLine;
                TempSplitItemJnlLine.INSERT;
            UNTIL OldTempSplitItemJnlLine.NEXT = 0;
        SNRequired := OldSNRequired;
        LotRequired := OldLotRequired;
        ItemTrackingCode := OldItemTrackingCode;
        CalledFromInvtPutawayPick := xCalledFromInvtPutawayPick;
    END;

    LOCAL PROCEDURE PostFlushedConsump(ProdOrder: Record 5405; ProdOrderLine: Record 5406; ProdOrderComp: Record 5407; ActOutputQtyBase: Decimal; PostingDate: Date; DocumentNo: Code[20]);
    VAR
        CompItem: Record 27;
        OldTempTrackingSpecification: Record 336 TEMPORARY;
        QtyToPost: Decimal;
        CalcBasedOn: Option "Actual Output","Expected Output";
        PostItemJnlLine: Boolean;
        DimsAreTaken: Boolean;
        TrackingSpecExists: Boolean;
    BEGIN
        CompItem.GET(ProdOrderComp."Item No.");
        CompItem.TESTFIELD("Rounding Precision");

        IF ProdOrderComp."Flushing Method" IN
           [ProdOrderComp."Flushing Method"::Backward, ProdOrderComp."Flushing Method"::"Pick + Backward"]
        THEN BEGIN
            QtyToPost :=
              CostCalcMgt.CalcActNeededQtyBase(ProdOrderLine, ProdOrderComp, ActOutputQtyBase) / ProdOrderComp."Qty. per Unit of Measure";
            IF (ProdOrderLine."Remaining Qty. (Base)" = ActOutputQtyBase) AND
               (ABS(QtyToPost - ProdOrderComp."Remaining Quantity") < CompItem."Rounding Precision")
            THEN
                QtyToPost := ProdOrderComp."Remaining Quantity";
        END ELSE
            QtyToPost := ProdOrderComp.GetNeededQty(CalcBasedOn::"Expected Output", TRUE);
        QtyToPost := UOMMgt.RoundToItemRndPrecision(QtyToPost, CompItem."Rounding Precision");

        IF QtyToPost = 0 THEN
            EXIT;

        WITH ItemJnlLine DO BEGIN
            INIT;
            "Line No." := 0;
            "Entry Type" := "Entry Type"::Consumption;
            VALIDATE("Posting Date", PostingDate);
            "Document No." := DocumentNo;
            "Source No." := ProdOrderLine."Item No.";
            "Order Type" := "Order Type"::Production;
            "Order No." := ProdOrderLine."Prod. Order No.";
            VALIDATE("Order Line No.", ProdOrderLine."Line No.");
            VALIDATE("Item No.", ProdOrderComp."Item No.");
            VALIDATE("Prod. Order Comp. Line No.", ProdOrderComp."Line No.");
            VALIDATE("Unit of Measure Code", ProdOrderComp."Unit of Measure Code");
            Description := ProdOrderComp.Description;
            VALIDATE(Quantity, QtyToPost);
            VALIDATE("Unit Cost", ProdOrderComp."Unit Cost");
            "Location Code" := ProdOrderComp."Location Code";
            "Bin Code" := ProdOrderComp."Bin Code";
            "Variant Code" := ProdOrderComp."Variant Code";
            "Source Code" := SourceCodeSetup.Flushing;
            "Gen. Bus. Posting Group" := ProdOrder."Gen. Bus. Posting Group";
            "Gen. Prod. Posting Group" := CompItem."Gen. Prod. Posting Group";

            OldTempTrackingSpecification.RESET;
            OldTempTrackingSpecification.DELETEALL;
            TempTrackingSpecification.RESET;
            IF TempTrackingSpecification.FINDSET THEN
                REPEAT
                    OldTempTrackingSpecification := TempTrackingSpecification;
                    OldTempTrackingSpecification.INSERT;
                UNTIL TempTrackingSpecification.NEXT = 0;
            ReserveProdOrderComp.TransferPOCompToItemJnlLine(
              ProdOrderComp, ItemJnlLine, ROUND(QtyToPost * ProdOrderComp."Qty. per Unit of Measure", 0.00001));

            OnBeforePostFlushedConsumpItemJnlLine(ItemJnlLine);

            PrepareItem(ItemJnlLine);
            TrackingSpecExists := ItemTrackingMgt.RetrieveItemTracking(ItemJnlLine, TempTrackingSpecification);
            PostItemJnlLine := SetupSplitJnlLine(ItemJnlLine, TrackingSpecExists);

            WHILE SplitJnlLine(ItemJnlLine, PostItemJnlLine) DO BEGIN
                IF SNRequired AND ("Serial No." = '') THEN
                    ERROR(SerialNoRequiredErr, "Item No.");
                IF LotRequired AND ("Lot No." = '') THEN
                    ERROR(LotNoRequiredErr, "Item No.");

                IF NOT DimsAreTaken THEN BEGIN
                    "Dimension Set ID" := GetCombinedDimSetID(ProdOrderLine."Dimension Set ID", ProdOrderComp."Dimension Set ID");
                    DimsAreTaken := TRUE;
                END;
                ItemJnlCheckLine.RunCheck(ItemJnlLine);
                ProdOrderCompModified := TRUE;
                Quantity := "Quantity (Base)";
                "Invoiced Quantity" := "Invoiced Qty. (Base)";
                QtyPerUnitOfMeasure := "Qty. per Unit of Measure";

                "Unit Amount" := ROUND(
                    "Unit Amount" / QtyPerUnitOfMeasure, GLSetup."Unit-Amount Rounding Precision");
                "Unit Cost" := ROUND(
                    "Unit Cost" / QtyPerUnitOfMeasure, GLSetup."Unit-Amount Rounding Precision");
                "Unit Cost (ACY)" := ROUND(
                    "Unit Cost (ACY)" / QtyPerUnitOfMeasure, Currency."Unit-Amount Rounding Precision");
                PostConsumption;
            END;

            TempTrackingSpecification.RESET;
            TempTrackingSpecification.DELETEALL;
            IF OldTempTrackingSpecification.FINDSET THEN
                REPEAT
                    TempTrackingSpecification := OldTempTrackingSpecification;
                    TempTrackingSpecification.INSERT;
                UNTIL OldTempTrackingSpecification.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateUnitCost(ValueEntry: Record 5802);
    VAR
        ItemCostMgt: Codeunit 5804;
        LastDirectCost: Decimal;
    BEGIN
        WITH ValueEntry DO
            IF ("Valued Quantity" > 0) AND NOT ("Expected Cost" OR ItemJnlLine.Adjustment) THEN BEGIN
                Item.LOCKTABLE;
                IF NOT Item.FIND THEN
                    EXIT;

                IF IsInbound AND
                   (("Cost Amount (Actual)" + "Discount Amount" > 0) OR Item.IsNonInventoriableType) AND
                   (ItemJnlLine."Value Entry Type" = ItemJnlLine."Value Entry Type"::"Direct Cost") AND
                   (ItemJnlLine."Item Charge No." = '') AND NOT Item."Inventory Value Zero"
                THEN
                    LastDirectCost :=
                      ROUND(
                        (ItemJnlLine.Amount + ItemJnlLine."Discount Amount") / "Valued Quantity",
                        GLSetup."Unit-Amount Rounding Precision");
                IF "Drop Shipment" THEN BEGIN
                    IF LastDirectCost <> 0 THEN BEGIN
                        Item."Last Direct Cost" := LastDirectCost;
                        Item.MODIFY;
                        ItemCostMgt.SetProperties(FALSE, "Invoiced Quantity");
                        ItemCostMgt.FindUpdateUnitCostSKU(Item, "Location Code", "Variant Code", TRUE, LastDirectCost);
                    END;
                END ELSE BEGIN
                    ItemCostMgt.SetProperties(FALSE, "Invoiced Quantity");
                    ItemCostMgt.UpdateUnitCost(Item, "Location Code", "Variant Code", LastDirectCost, 0, TRUE, TRUE, FALSE, 0);
                END;
            END;
    END;

    //[External]
    PROCEDURE UnApply(Application: Record 339);
    VAR
        ItemLedgEntry1: Record 32;
        ItemLedgEntry2: Record 32;
        CostItemLedgEntry: Record 32;
        InventoryPeriod: Record 5814;
        Valuationdate: Date;
    BEGIN
        IF NOT InventoryPeriod.IsValidDate(Application."Posting Date") THEN
            InventoryPeriod.ShowError(Application."Posting Date");

        // If we can't get both entries then the application is not a real application or a date compression might have been done
        ItemLedgEntry1.GET(Application."Inbound Item Entry No.");
        ItemLedgEntry2.GET(Application."Outbound Item Entry No.");

        IF Application."Item Ledger Entry No." = Application."Inbound Item Entry No." THEN
            IF ItemLedgEntry1.Correction THEN
                ERROR(Text025);
        IF Application."Item Ledger Entry No." = Application."Outbound Item Entry No." THEN
            IF ItemLedgEntry2.Correction THEN
                ERROR(Text025);

        IF ItemLedgEntry1."Drop Shipment" AND ItemLedgEntry2."Drop Shipment" THEN
            ERROR(Text024);

        IF ItemLedgEntry2."Entry Type" = ItemLedgEntry2."Entry Type"::Transfer THEN
            ERROR(Text023);

        Application.TESTFIELD("Transferred-from Entry No.", 0);

        // We won't allow deletion of applications for deleted items
        Item.GET(ItemLedgEntry1."Item No.");
        CostItemLedgEntry.GET(Application.CostReceiver); // costreceiver

        IF ItemLedgEntry1."Applies-to Entry" = ItemLedgEntry2."Entry No." THEN
            ItemLedgEntry1."Applies-to Entry" := 0;

        IF ItemLedgEntry2."Applies-to Entry" = ItemLedgEntry1."Entry No." THEN
            ItemLedgEntry2."Applies-to Entry" := 0;

        // only if real/quantity application
        IF NOT Application.CostApplication THEN BEGIN
            ItemLedgEntry1."Remaining Quantity" := ItemLedgEntry1."Remaining Quantity" - Application.Quantity;
            ItemLedgEntry1.Open := ItemLedgEntry1."Remaining Quantity" <> 0;
            ItemLedgEntry1.MODIFY;

            ItemLedgEntry2."Remaining Quantity" := ItemLedgEntry2."Remaining Quantity" + Application.Quantity;
            ItemLedgEntry2.Open := ItemLedgEntry2."Remaining Quantity" <> 0;
            ItemLedgEntry2.MODIFY;
        END ELSE BEGIN
            ItemLedgEntry2."Shipped Qty. Not Returned" := ItemLedgEntry2."Shipped Qty. Not Returned" - ABS(Application.Quantity);
            IF ABS(ItemLedgEntry2."Shipped Qty. Not Returned") > ABS(ItemLedgEntry2.Quantity) THEN
                ItemLedgEntry2.FIELDERROR("Shipped Qty. Not Returned", Text004); // Assert - should never happen
            ItemLedgEntry2.MODIFY;

            // If cost application we need to insert a 0 application instead if there is none before
            IF Application.Quantity > 0 THEN
                IF NOT ZeroApplication(Application."Item Ledger Entry No.") THEN
                    InsertApplEntry(
                      Application."Item Ledger Entry No.", Application."Inbound Item Entry No.",
                      0, 0, Application."Posting Date",
                      Application.Quantity, TRUE);
        END;

        IF Item."Costing Method" = Item."Costing Method"::Average THEN
            IF Application.Fixed THEN
                UpdateValuedByAverageCost(CostItemLedgEntry."Entry No.", TRUE);

        Application.InsertHistory;
        TouchEntry(Application."Inbound Item Entry No.");
        SaveTouchedEntry(Application."Inbound Item Entry No.", TRUE);
        IF Application."Outbound Item Entry No." <> 0 THEN BEGIN
            TouchEntry(Application."Outbound Item Entry No.");
            SaveTouchedEntry(Application."Inbound Item Entry No.", FALSE);
        END;
        Application.DELETE;

        Valuationdate := GetMaxAppliedValuationdate(CostItemLedgEntry);
        IF Valuationdate = 0D THEN
            Valuationdate := CostItemLedgEntry."Posting Date"
        ELSE
            Valuationdate := Max(CostItemLedgEntry."Posting Date", Valuationdate);

        SetValuationDateAllValueEntrie(CostItemLedgEntry."Entry No.", Valuationdate, FALSE);

        UpdateLinkedValuationUnapply(Valuationdate, CostItemLedgEntry."Entry No.", CostItemLedgEntry.Positive);
    END;

    //[External]
    PROCEDURE ReApply(ItemLedgEntry: Record 32; ApplyWith: Integer);
    VAR
        ItemLedgEntry2: Record 32;
        ValueEntry: Record 5802;
        InventoryPeriod: Record 5814;
        SNInfoRequired: Boolean;
        LotInfoRequired: Boolean;
        CostApplication: Boolean;
    BEGIN
        Item.GET(ItemLedgEntry."Item No.");

        IF NOT InventoryPeriod.IsValidDate(ItemLedgEntry."Posting Date") THEN
            InventoryPeriod.ShowError(ItemLedgEntry."Posting Date");

        ItemTrackingCode.Code := Item."Item Tracking Code";
        ItemTrackingMgt1.GetItemTrackingSettings(
          ItemTrackingCode, ItemJnlLine."Entry Type", ItemJnlLine.Signed(ItemJnlLine."Quantity (Base)") > 0,
          SNRequired, LotRequired, SNInfoRequired, LotInfoRequired);

        TotalAppliedQty := 0;
        CostApplication := FALSE;
        IF ApplyWith <> 0 THEN BEGIN
            ItemLedgEntry2.GET(ApplyWith);
            IF ItemLedgEntry2.Quantity > 0 THEN BEGIN
                // Switch around so ItemLedgEntry is positive and ItemLedgEntry2 is negative
                OldItemLedgEntry := ItemLedgEntry;
                ItemLedgEntry := ItemLedgEntry2;
                ItemLedgEntry2 := OldItemLedgEntry;
            END;
            IF NOT ((ItemLedgEntry.Quantity > 0) AND // not(Costprovider(ItemLedgEntry))
                    ((ItemLedgEntry."Entry Type" = ItemLedgEntry2."Entry Type"::Purchase) OR
                     (ItemLedgEntry."Entry Type" = ItemLedgEntry2."Entry Type"::"Positive Adjmt.") OR
                     (ItemLedgEntry."Entry Type" = ItemLedgEntry2."Entry Type"::Output) OR
                     (ItemLedgEntry."Entry Type" = ItemLedgEntry2."Entry Type"::"Assembly Output"))
                    )
            THEN
                CostApplication := TRUE;
            IF (ItemLedgEntry."Remaining Quantity" <> 0) AND (ItemLedgEntry2."Remaining Quantity" <> 0) THEN
                CostApplication := FALSE;
            IF CostApplication THEN
                CostApply(ItemLedgEntry, ItemLedgEntry2)
            ELSE BEGIN
                CreateItemJNLLinefromEntry(ItemLedgEntry2, ItemLedgEntry2."Remaining Quantity", ItemJnlLine);
                IF ApplyWith = ItemLedgEntry2."Entry No." THEN
                    ItemLedgEntry2."Applies-to Entry" := ItemLedgEntry."Entry No."
                ELSE
                    ItemLedgEntry2."Applies-to Entry" := ApplyWith;
                ItemJnlLine."Applies-to Entry" := ItemLedgEntry2."Applies-to Entry";
                GlobalItemLedgEntry := ItemLedgEntry2;
                ApplyItemLedgEntry(ItemLedgEntry2, OldItemLedgEntry, ValueEntry, FALSE);
                TouchItemEntryCost(ItemLedgEntry2, FALSE);
                ItemLedgEntry2.MODIFY;
                EnsureValueEntryLoaded(ValueEntry, ItemLedgEntry2);
                GetValuationDate(ValueEntry, ItemLedgEntry);
                UpdateLinkedValuationDate(ValueEntry."Valuation Date", GlobalItemLedgEntry."Entry No.", GlobalItemLedgEntry.Positive);
            END;

            IF ItemApplnEntry.Fixed AND (ItemApplnEntry.CostReceiver <> 0) THEN
                IF Item.GET(ItemLedgEntry."Item No.") THEN
                    IF Item."Costing Method" = Item."Costing Method"::Average THEN
                        UpdateValuedByAverageCost(ItemApplnEntry.CostReceiver, FALSE);
        END ELSE BEGIN  // ApplyWith is 0
            ItemLedgEntry."Applies-to Entry" := ApplyWith;
            CreateItemJNLLinefromEntry(ItemLedgEntry, ItemLedgEntry."Remaining Quantity", ItemJnlLine);
            ItemJnlLine."Applies-to Entry" := ItemLedgEntry."Applies-to Entry";
            GlobalItemLedgEntry := ItemLedgEntry;
            ApplyItemLedgEntry(ItemLedgEntry, OldItemLedgEntry, ValueEntry, FALSE);
            TouchItemEntryCost(ItemLedgEntry, FALSE);
            ItemLedgEntry.MODIFY;
            EnsureValueEntryLoaded(ValueEntry, ItemLedgEntry);
            GetValuationDate(ValueEntry, ItemLedgEntry);
            UpdateLinkedValuationDate(ValueEntry."Valuation Date", GlobalItemLedgEntry."Entry No.", GlobalItemLedgEntry.Positive);
        END;
    END;

    LOCAL PROCEDURE CostApply(VAR ItemLedgEntry: Record 32; ItemLedgEntry2: Record 32);
    VAR
        ApplyWithItemLedgEntry: Record 32;
        ValueEntry: Record 5802;
    BEGIN
        IF ItemLedgEntry.Quantity > 0 THEN BEGIN
            GlobalItemLedgEntry := ItemLedgEntry;
            ApplyWithItemLedgEntry := ItemLedgEntry2;
        END
        ELSE BEGIN
            GlobalItemLedgEntry := ItemLedgEntry2;
            ApplyWithItemLedgEntry := ItemLedgEntry;
        END;
        IF NOT ItemApplnEntry.CheckIsCyclicalLoop(ApplyWithItemLedgEntry, GlobalItemLedgEntry) THEN BEGIN
            CreateItemJNLLinefromEntry(GlobalItemLedgEntry, GlobalItemLedgEntry.Quantity, ItemJnlLine);
            InsertApplEntry(
              GlobalItemLedgEntry."Entry No.", GlobalItemLedgEntry."Entry No.",
              ApplyWithItemLedgEntry."Entry No.", 0, GlobalItemLedgEntry."Posting Date",
              GlobalItemLedgEntry.Quantity, TRUE);
            UpdateOutboundItemLedgEntry(ApplyWithItemLedgEntry."Entry No.");
            OldItemLedgEntry.GET(ApplyWithItemLedgEntry."Entry No.");
            EnsureValueEntryLoaded(ValueEntry, GlobalItemLedgEntry);
            ItemJnlLine."Applies-from Entry" := ApplyWithItemLedgEntry."Entry No.";
            GetAppliedFromValues(ValueEntry);
            SetValuationDateAllValueEntrie(GlobalItemLedgEntry."Entry No.", ValueEntry."Valuation Date", FALSE);
            UpdateLinkedValuationDate(ValueEntry."Valuation Date", GlobalItemLedgEntry."Entry No.", GlobalItemLedgEntry.Positive);
            TouchItemEntryCost(ItemLedgEntry2, FALSE);
        END;
    END;

    LOCAL PROCEDURE ZeroApplication(EntryNo: Integer): Boolean;
    VAR
        Application: Record 339;
    BEGIN
        Application.SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.");
        Application.SETRANGE("Item Ledger Entry No.", EntryNo);
        Application.SETRANGE("Inbound Item Entry No.", EntryNo);
        Application.SETRANGE("Outbound Item Entry No.", 0);
        EXIT(NOT Application.ISEMPTY);
    END;

    LOCAL PROCEDURE ApplyItemLedgEntry(VAR ItemLedgEntry: Record 32; VAR OldItemLedgEntry: Record 32; VAR ValueEntry: Record 5802; CausedByTransfer: Boolean);
    VAR
        ItemLedgEntry2: Record 32;
        OldValueEntry: Record 5802;
        ReservEntry: Record 337;
        ReservEntry2: Record 337;
        AppliesFromItemLedgEntry: Record 32;
        EntryFindMethod: Text[1];
        AppliedQty: Decimal;
        FirstReservation: Boolean;
        FirstApplication: Boolean;
        StartApplication: Boolean;
        UseReservationApplication: Boolean;
        Handled: Boolean;
    BEGIN
        OnBeforeApplyItemLedgEntry(ItemLedgEntry, OldItemLedgEntry, ValueEntry, CausedByTransfer, Handled);
        IF Handled THEN
            EXIT;

        IF (ItemLedgEntry."Remaining Quantity" = 0) OR
           (ItemLedgEntry."Drop Shipment" AND (ItemLedgEntry."Applies-to Entry" = 0)) OR
           ((Item."Costing Method" = Item."Costing Method"::Specific) AND ItemLedgEntry.Positive)
        THEN
            EXIT;

        CLEAR(OldItemLedgEntry);
        FirstReservation := TRUE;
        FirstApplication := TRUE;
        StartApplication := FALSE;
        REPEAT
            IF ItemJnlLine."Assemble to Order" THEN
                VerifyItemJnlLineAsembleToOrder(ItemJnlLine)
            ELSE
                VerifyItemJnlLineApplication(ItemJnlLine, ItemLedgEntry);

            IF NOT CausedByTransfer AND NOT PostponeReservationHandling THEN BEGIN
                IF Item."Costing Method" = Item."Costing Method"::Specific THEN
                    ItemJnlLine.TESTFIELD("Serial No.");

                IF FirstReservation THEN BEGIN
                    FirstReservation := FALSE;
                    ReservEntry.RESET;
                    ReservEntry.SETCURRENTKEY(
                      "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
                      "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
                    ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Reservation);
                    ReserveItemJnlLine1.FilterReservFor(ReservEntry, ItemJnlLine);
                END;

                UseReservationApplication := ReservEntry.FINDFIRST;

                IF NOT UseReservationApplication THEN BEGIN // No reservations exist
                    ReservEntry.SETRANGE(
                      "Reservation Status", ReservEntry."Reservation Status"::Tracking,
                      ReservEntry."Reservation Status"::Prospect);
                    IF ReservEntry.FINDSET THEN
                        REPEAT
                            ReservEngineMgt.CloseSurplusTrackingEntry(ReservEntry);
                        UNTIL ReservEntry.NEXT = 0;
                    StartApplication := TRUE;
                END;

                IF UseReservationApplication THEN BEGIN
                    ReservEntry2.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive);
                    IF ReservEntry2."Source Type" <> DATABASE::"Item Ledger Entry" THEN
                        IF ItemLedgEntry.Quantity < 0 THEN
                            ERROR(Text003, ReservEntry."Item No.");
                    OldItemLedgEntry.GET(ReservEntry2."Source Ref. No.");
                    IF ItemLedgEntry.Quantity < 0 THEN
                        IF OldItemLedgEntry."Remaining Quantity" < ReservEntry2."Quantity (Base)" THEN
                            ERROR(Text003, ReservEntry2."Item No.");

                    OldItemLedgEntry.TESTFIELD("Item No.", ItemJnlLine."Item No.");
                    OldItemLedgEntry.TESTFIELD("Variant Code", ItemJnlLine."Variant Code");
                    OldItemLedgEntry.TESTFIELD("Location Code", ItemJnlLine."Location Code");
                    OnApplyItemLedgEntryOnBeforeCLoseReservEntry(OldItemLedgEntry, ItemJnlLine);
                    ReservEngineMgt.CloseReservEntry(ReservEntry, FALSE, FALSE);
                    OldItemLedgEntry.CALCFIELDS("Reserved Quantity");
                    AppliedQty := -ABS(ReservEntry."Quantity (Base)");
                END;
            END ELSE
                StartApplication := TRUE;

            IF StartApplication THEN BEGIN
                ItemLedgEntry.CALCFIELDS("Reserved Quantity");
                IF ItemLedgEntry."Applies-to Entry" <> 0 THEN BEGIN
                    IF FirstApplication THEN BEGIN
                        FirstApplication := FALSE;
                        OldItemLedgEntry.GET(ItemLedgEntry."Applies-to Entry");
                        TestFirstApplyItemLedgEntry(OldItemLedgEntry, ItemLedgEntry);
                    END ELSE
                        EXIT;
                END ELSE BEGIN
                    IF FirstApplication THEN BEGIN
                        FirstApplication := FALSE;
                        ApplyItemLedgEntrySetFilters(ItemLedgEntry2, ItemLedgEntry, ItemTrackingCode);

                        IF Item."Costing Method" = Item."Costing Method"::LIFO THEN
                            EntryFindMethod := '+'
                        ELSE
                            EntryFindMethod := '-';
                        IF NOT ItemLedgEntry2.FIND(EntryFindMethod) THEN
                            EXIT;
                    END ELSE
                        CASE EntryFindMethod OF
                            '-':
                                IF ItemLedgEntry2.NEXT = 0 THEN
                                    EXIT;
                            '+':
                                IF ItemLedgEntry2.NEXT(-1) = 0 THEN
                                    EXIT;
                        END;
                    OldItemLedgEntry.COPY(ItemLedgEntry2)
                END;

                OldItemLedgEntry.CALCFIELDS("Reserved Quantity");

                IF ABS(OldItemLedgEntry."Remaining Quantity" - OldItemLedgEntry."Reserved Quantity") >
                   ABS(ItemLedgEntry."Remaining Quantity" - ItemLedgEntry."Reserved Quantity")
                THEN
                    AppliedQty := ItemLedgEntry."Remaining Quantity" - ItemLedgEntry."Reserved Quantity"
                ELSE
                    AppliedQty := -(OldItemLedgEntry."Remaining Quantity" - OldItemLedgEntry."Reserved Quantity");

                IF ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Transfer THEN
                    IF (OldItemLedgEntry."Entry No." > ItemLedgEntry."Entry No.") AND NOT ItemLedgEntry.Positive THEN
                        AppliedQty := 0;
                IF (OldItemLedgEntry."Order Type" = OldItemLedgEntry."Order Type"::Production) AND
                   (OldItemLedgEntry."Order No." <> '')
                THEN
                    IF NOT AllowProdApplication(OldItemLedgEntry, ItemLedgEntry) THEN
                        AppliedQty := 0;
                IF ItemJnlLine."Applies-from Entry" <> 0 THEN BEGIN
                    AppliesFromItemLedgEntry.GET(ItemJnlLine."Applies-from Entry");
                    IF ItemApplnEntry.CheckIsCyclicalLoop(AppliesFromItemLedgEntry, OldItemLedgEntry) THEN
                        AppliedQty := 0;
                END;
            END;

            CheckIsCyclicalLoop(ItemLedgEntry, OldItemLedgEntry, PrevAppliedItemLedgEntry, AppliedQty);

            IF AppliedQty <> 0 THEN BEGIN
                IF NOT OldItemLedgEntry.Positive AND
                   (OldItemLedgEntry."Remaining Quantity" = -AppliedQty) AND
                   (OldItemLedgEntry."Entry No." = ItemLedgEntry."Applies-to Entry")
                THEN BEGIN
                    OldValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
                    OldValueEntry.SETRANGE("Item Ledger Entry No.", OldItemLedgEntry."Entry No.");
                    IF OldValueEntry.FIND('-') THEN
                        REPEAT
                            IF OldValueEntry."Valued By Average Cost" THEN BEGIN
                                OldValueEntry."Valued By Average Cost" := FALSE;
                                OldValueEntry.MODIFY;
                            END;
                        UNTIL OldValueEntry.NEXT = 0;
                END;

                OldItemLedgEntry."Remaining Quantity" := OldItemLedgEntry."Remaining Quantity" + AppliedQty;
                OldItemLedgEntry.Open := OldItemLedgEntry."Remaining Quantity" <> 0;

                IF ItemLedgEntry.Positive THEN BEGIN
                    IF ItemLedgEntry."Posting Date" >= OldItemLedgEntry."Posting Date" THEN
                        InsertApplEntry(
                          OldItemLedgEntry."Entry No.", ItemLedgEntry."Entry No.",
                          OldItemLedgEntry."Entry No.", 0, ItemLedgEntry."Posting Date", -AppliedQty, FALSE)
                    ELSE
                        InsertApplEntry(
                          OldItemLedgEntry."Entry No.", ItemLedgEntry."Entry No.",
                          OldItemLedgEntry."Entry No.", 0, OldItemLedgEntry."Posting Date", -AppliedQty, FALSE);

                    IF ItemApplnEntry."Cost Application" THEN
                        ItemLedgEntry."Applied Entry to Adjust" := TRUE;
                END ELSE BEGIN
                    IF ItemTrackingCode."Strict Expiration Posting" AND (OldItemLedgEntry."Expiration Date" <> 0D) AND
                       NOT ItemLedgEntry.Correction AND
                       NOT (ItemLedgEntry."Document Type" IN
                            [ItemLedgEntry."Document Type"::"Purchase Return Shipment", ItemLedgEntry."Document Type"::"Purchase Credit Memo"])
                    THEN
                        IF ItemLedgEntry."Posting Date" > OldItemLedgEntry."Expiration Date" THEN
                            IF (ItemLedgEntry."Entry Type" <> ItemLedgEntry."Entry Type"::"Negative Adjmt.") AND
                               NOT ItemJnlLine.IsReclass(ItemJnlLine)
                            THEN
                                OldItemLedgEntry.FIELDERROR("Expiration Date", Text017);

                    InsertApplEntry(
                      ItemLedgEntry."Entry No.", OldItemLedgEntry."Entry No.", ItemLedgEntry."Entry No.", 0,
                      ItemLedgEntry."Posting Date", AppliedQty, TRUE);

                    IF ItemApplnEntry."Cost Application" THEN
                        OldItemLedgEntry."Applied Entry to Adjust" := TRUE;
                END;

                OldItemLedgEntry.MODIFY;
                AutoTrack(OldItemLedgEntry, TRUE);

                EnsureValueEntryLoaded(ValueEntry, ItemLedgEntry);
                GetValuationDate(ValueEntry, OldItemLedgEntry);

                IF (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Transfer) AND
                   (AppliedQty < 0) AND
                   NOT CausedByTransfer
                THEN BEGIN
                    IF ItemLedgEntry."Completely Invoiced" THEN
                        ItemLedgEntry."Completely Invoiced" := OldItemLedgEntry."Completely Invoiced";
                    IF AverageTransfer THEN
                        TotalAppliedQty := TotalAppliedQty + AppliedQty
                    ELSE
                        InsertTransferEntry(ItemLedgEntry, OldItemLedgEntry, AppliedQty);
                END;

                ItemLedgEntry."Remaining Quantity" := ItemLedgEntry."Remaining Quantity" - AppliedQty;
                ItemLedgEntry.Open := ItemLedgEntry."Remaining Quantity" <> 0;

                ItemLedgEntry.CALCFIELDS("Reserved Quantity");
                IF ItemLedgEntry."Remaining Quantity" + ItemLedgEntry."Reserved Quantity" = 0 THEN
                    EXIT;
            END;
        UNTIL FALSE;
    END;

    LOCAL PROCEDURE ApplyItemLedgEntrySetFilters(VAR ToItemLedgEntry: Record 32; FromItemLedgEntry: Record 32; ItemTrackingCode: Record 6502);
    VAR
        Location: Record 14;
    BEGIN
        WITH ToItemLedgEntry DO BEGIN
            SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
            SETRANGE("Item No.", FromItemLedgEntry."Item No.");
            SETRANGE(Open, TRUE);
            SETRANGE("Variant Code", FromItemLedgEntry."Variant Code");
            SETRANGE(Positive, NOT FromItemLedgEntry.Positive);
            SETRANGE("Location Code", FromItemLedgEntry."Location Code");
            IF FromItemLedgEntry."Job Purchase" THEN BEGIN
                SETRANGE("Job No.", FromItemLedgEntry."Job No.");
                SETRANGE("Job Task No.", FromItemLedgEntry."Job Task No.");
                SETRANGE("Document Type", FromItemLedgEntry."Document Type");
                SETRANGE("Document No.", FromItemLedgEntry."Document No.");
            END;
            IF ItemTrackingCode."SN Specific Tracking" THEN
                SETRANGE("Serial No.", FromItemLedgEntry."Serial No.");
            IF ItemTrackingCode."Lot Specific Tracking" THEN
                SETRANGE("Lot No.", FromItemLedgEntry."Lot No.");
            IF Location.GET(FromItemLedgEntry."Location Code") THEN
                IF Location."Use As In-Transit" THEN BEGIN
                    SETRANGE("Order Type", FromItemLedgEntry."Order Type"::Transfer);
                    SETRANGE("Order No.", FromItemLedgEntry."Order No.");
                END;
        END;

        OnAfterApplyItemLedgEntrySetFilters(ToItemLedgEntry, FromItemLedgEntry);
    END;

    LOCAL PROCEDURE TestFirstApplyItemLedgEntry(VAR OldItemLedgEntry: Record 32; ItemLedgEntry: Record 32);
    BEGIN
        OldItemLedgEntry.TESTFIELD("Item No.", ItemLedgEntry."Item No.");
        OldItemLedgEntry.TESTFIELD("Variant Code", ItemLedgEntry."Variant Code");
        OldItemLedgEntry.TESTFIELD(Positive, NOT ItemLedgEntry.Positive);
        OldItemLedgEntry.TESTFIELD("Location Code", ItemLedgEntry."Location Code");
        IF Location.GET(ItemLedgEntry."Location Code") THEN
            IF Location."Use As In-Transit" THEN BEGIN
                OldItemLedgEntry.TESTFIELD("Order Type", OldItemLedgEntry."Order Type"::Transfer);
                OldItemLedgEntry.TESTFIELD("Order No.", ItemLedgEntry."Order No.");
            END;

        IF ItemTrackingCode."SN Specific Tracking" THEN
            OldItemLedgEntry.TESTFIELD("Serial No.", ItemLedgEntry."Serial No.");
        IF ItemLedgEntry."Drop Shipment" AND (OldItemLedgEntry."Serial No." <> '') THEN
            OldItemLedgEntry.TESTFIELD("Serial No.", ItemLedgEntry."Serial No.");

        IF ItemTrackingCode."Lot Specific Tracking" THEN
            OldItemLedgEntry.TESTFIELD("Lot No.", ItemLedgEntry."Lot No.");
        IF ItemLedgEntry."Drop Shipment" AND (OldItemLedgEntry."Lot No." <> '') THEN
            OldItemLedgEntry.TESTFIELD("Lot No.", ItemLedgEntry."Lot No.");

        IF NOT (OldItemLedgEntry.Open AND
                (ABS(OldItemLedgEntry."Remaining Quantity" - OldItemLedgEntry."Reserved Quantity") >=
                 ABS(ItemLedgEntry."Remaining Quantity" - ItemLedgEntry."Reserved Quantity")))
        THEN
            IF (ABS(OldItemLedgEntry."Remaining Quantity" - OldItemLedgEntry."Reserved Quantity") <=
                ABS(ItemLedgEntry."Remaining Quantity" - ItemLedgEntry."Reserved Quantity"))
            THEN BEGIN
                IF NOT MoveApplication(ItemLedgEntry, OldItemLedgEntry) THEN
                    OldItemLedgEntry.FIELDERROR("Remaining Quantity", Text004);
            END ELSE
                OldItemLedgEntry.TESTFIELD(Open, TRUE);

        OnTestFirstApplyItemLedgEntryOnAfterTestFields(ItemLedgEntry, OldItemLedgEntry);

        OldItemLedgEntry.CALCFIELDS("Reserved Quantity");
        CheckApplication(ItemLedgEntry, OldItemLedgEntry);

        IF ABS(OldItemLedgEntry."Remaining Quantity") <= ABS(OldItemLedgEntry."Reserved Quantity") THEN
            ReservationPreventsApplication(ItemLedgEntry."Applies-to Entry", ItemLedgEntry."Item No.", OldItemLedgEntry);

        IF (OldItemLedgEntry."Order Type" = OldItemLedgEntry."Order Type"::Production) AND
           (OldItemLedgEntry."Order No." <> '')
        THEN
            IF NOT AllowProdApplication(OldItemLedgEntry, ItemLedgEntry) THEN
                ERROR(
                  Text022,
                  ItemLedgEntry."Entry Type", OldItemLedgEntry."Entry Type", OldItemLedgEntry."Item No.", OldItemLedgEntry."Order No.")
    END;

    LOCAL PROCEDURE EnsureValueEntryLoaded(VAR ValueEntry: Record 5802; ItemLedgEntry: Record 32);
    BEGIN
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        IF ValueEntry.FIND('-') THEN;
    END;

    LOCAL PROCEDURE AllowProdApplication(OldItemLedgEntry: Record 32; ItemLedgEntry: Record 32): Boolean;
    BEGIN
        EXIT(
          (OldItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type") OR
          (OldItemLedgEntry."Order No." <> ItemLedgEntry."Order No.") OR
          ((OldItemLedgEntry."Order No." = ItemLedgEntry."Order No.") AND
           (OldItemLedgEntry."Order Line No." <> ItemLedgEntry."Order Line No.")));
    END;

    LOCAL PROCEDURE InitValueEntryNo();
    BEGIN
        IF ValueEntryNo > 0 THEN
            EXIT;

        GlobalValueEntry.LOCKTABLE;
        IF GlobalValueEntry.FINDLAST THEN
            ValueEntryNo := GlobalValueEntry."Entry No.";
    END;

    LOCAL PROCEDURE InsertTransferEntry(VAR ItemLedgEntry: Record 32; VAR OldItemLedgEntry: Record 32; AppliedQty: Decimal);
    VAR
        NewItemLedgEntry: Record 32;
        NewValueEntry: Record 5802;
        ItemLedgEntry2: Record 32;
        IsReserved: Boolean;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            InitItemLedgEntry(NewItemLedgEntry);
            NewItemLedgEntry."Applies-to Entry" := 0;

            NewItemLedgEntry.Quantity := -AppliedQty;
            NewItemLedgEntry."Invoiced Quantity" := NewItemLedgEntry.Quantity;

            NewItemLedgEntry."Remaining Quantity" := NewItemLedgEntry.Quantity;
            NewItemLedgEntry.Open := NewItemLedgEntry."Remaining Quantity" <> 0;
            NewItemLedgEntry.Positive := NewItemLedgEntry."Remaining Quantity" > 0;

            NewItemLedgEntry."Location Code" := "New Location Code";
            NewItemLedgEntry."Country/Region Code" := "Country/Region Code";
            InsertCountryCode(NewItemLedgEntry, ItemLedgEntry);

            NewItemLedgEntry."Serial No." := "New Serial No.";
            NewItemLedgEntry."Lot No." := "New Lot No.";

            NewItemLedgEntry."Expiration Date" := "New Item Expiration Date";

            IF Item."Item Tracking Code" <> '' THEN BEGIN
                TempItemEntryRelation."Item Entry No." := NewItemLedgEntry."Entry No."; // Save Entry No. in a global variable
                TempItemEntryRelation."Serial No." := NewItemLedgEntry."Serial No.";
                TempItemEntryRelation."Lot No." := NewItemLedgEntry."Lot No.";
                TempItemEntryRelation.INSERT;
            END;
            InitTransValueEntry(NewValueEntry, NewItemLedgEntry);

            IF AverageTransfer THEN BEGIN
                InsertApplEntry(
                  NewItemLedgEntry."Entry No.", NewItemLedgEntry."Entry No.", ItemLedgEntry."Entry No.",
                  0, NewItemLedgEntry."Posting Date", NewItemLedgEntry.Quantity, TRUE);
                NewItemLedgEntry."Completely Invoiced" := ItemLedgEntry."Completely Invoiced";
            END ELSE BEGIN
                InsertApplEntry(
                  NewItemLedgEntry."Entry No.", NewItemLedgEntry."Entry No.", ItemLedgEntry."Entry No.",
                  OldItemLedgEntry."Entry No.", NewItemLedgEntry."Posting Date", NewItemLedgEntry.Quantity, TRUE);
                NewItemLedgEntry."Completely Invoiced" := OldItemLedgEntry."Completely Invoiced";
            END;

            IF NewItemLedgEntry.Quantity > 0 THEN
                IsReserved :=
                  ReserveItemJnlLine.TransferItemJnlToItemLedgEntry(
                    ItemJnlLine, NewItemLedgEntry, NewItemLedgEntry."Remaining Quantity", TRUE);

            ApplyItemLedgEntry(NewItemLedgEntry, ItemLedgEntry2, NewValueEntry, TRUE);
            AutoTrack(NewItemLedgEntry, IsReserved);

            OnBeforeInsertTransferEntry(NewItemLedgEntry, OldItemLedgEntry, ItemJnlLine);

            InsertItemLedgEntry(NewItemLedgEntry, TRUE);
            InsertValueEntry(NewValueEntry, NewItemLedgEntry, TRUE);

            UpdateUnitCost(NewValueEntry);
        END;
    END;

    LOCAL PROCEDURE InitItemLedgEntry(VAR ItemLedgEntry: Record 32);
    BEGIN
        ItemLedgEntryNo := ItemLedgEntryNo + 1;

        WITH ItemJnlLine DO BEGIN
            ItemLedgEntry.INIT;
            ItemLedgEntry."Entry No." := ItemLedgEntryNo;
            ItemLedgEntry."Item No." := "Item No.";
            ItemLedgEntry."Posting Date" := "Posting Date";
            ItemLedgEntry."Document Date" := "Document Date";
            ItemLedgEntry."Entry Type" := "Entry Type";
            ItemLedgEntry."Source No." := "Source No.";
            ItemLedgEntry."Document No." := "Document No.";
            ItemLedgEntry."Document Type" := "Document Type";
            ItemLedgEntry."Document Line No." := "Document Line No.";
            ItemLedgEntry."Order Type" := "Order Type";
            ItemLedgEntry."Order No." := "Order No.";
            ItemLedgEntry."Order Line No." := "Order Line No.";
            ItemLedgEntry."External Document No." := "External Document No.";
            ItemLedgEntry.Description := Description;
            ItemLedgEntry."Location Code" := "Location Code";
            ItemLedgEntry."Applies-to Entry" := "Applies-to Entry";
            ItemLedgEntry."Source Type" := "Source Type";
            ItemLedgEntry."Transaction Type" := "Transaction Type";
            ItemLedgEntry."Transport Method" := "Transport Method";
            ItemLedgEntry."Country/Region Code" := "Country/Region Code";
            IF ("Entry Type" = "Entry Type"::Transfer) AND ("New Location Code" <> '') THEN BEGIN
                IF NewLocation.Code <> "New Location Code" THEN
                    NewLocation.GET("New Location Code");
                ItemLedgEntry."Country/Region Code" := NewLocation."Country/Region Code";
            END;
            ItemLedgEntry."Entry/Exit Point" := "Entry/Exit Point";
            ItemLedgEntry.Area := Area;
            ItemLedgEntry."Transaction Specification" := "Transaction Specification";
            ItemLedgEntry."Drop Shipment" := "Drop Shipment";
            ItemLedgEntry."Assemble to Order" := "Assemble to Order";
            ItemLedgEntry."No. Series" := "Posting No. Series";
            GetInvtSetup;
            IF (ItemLedgEntry.Description = Item.Description) AND NOT InvtSetup."Copy Item Descr. to Entries" THEN
                ItemLedgEntry.Description := '';
            ItemLedgEntry."Prod. Order Comp. Line No." := "Prod. Order Comp. Line No.";
            ItemLedgEntry."Variant Code" := "Variant Code";
            ItemLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
            ItemLedgEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            ItemLedgEntry."Derived from Blanket Order" := "Derived from Blanket Order";

            ItemLedgEntry."Item Reference No." := "Item Reference No.";
            ItemLedgEntry."Originally Ordered No." := "Originally Ordered No.";
            ItemLedgEntry."Originally Ordered Var. Code" := "Originally Ordered Var. Code";
            ItemLedgEntry."Out-of-Stock Substitution" := "Out-of-Stock Substitution";
            ItemLedgEntry."Item Category Code" := "Item Category Code";
            ItemLedgEntry.Nonstock := Nonstock;
            ItemLedgEntry."Purchasing Code" := "Purchasing Code";
            ItemLedgEntry."Return Reason Code" := "Return Reason Code";
            ItemLedgEntry."Job No." := "Job No.";
            ItemLedgEntry."Job Task No." := "Job Task No.";
            ItemLedgEntry."Job Purchase" := "Job Purchase";
            ItemLedgEntry."Serial No." := "Serial No.";
            ItemLedgEntry."Lot No." := "Lot No.";
            ItemLedgEntry."Warranty Date" := "Warranty Date";
            ItemLedgEntry."Expiration Date" := "Item Expiration Date";
            ItemLedgEntry."Shpt. Method Code" := "Shpt. Method Code";

            ItemLedgEntry.Correction := Correction;

            IF "Entry Type" IN
               ["Entry Type"::Sale,
                "Entry Type"::"Negative Adjmt.",
                "Entry Type"::Transfer,
                "Entry Type"::Consumption,
                "Entry Type"::"Assembly Consumption"]
            THEN BEGIN
                ItemLedgEntry.Quantity := -Quantity;
                ItemLedgEntry."Invoiced Quantity" := -"Invoiced Quantity";
            END ELSE BEGIN
                ItemLedgEntry.Quantity := Quantity;
                ItemLedgEntry."Invoiced Quantity" := "Invoiced Quantity";
            END;
            IF (ItemLedgEntry.Quantity < 0) AND ("Entry Type" <> "Entry Type"::Transfer) THEN
                ItemLedgEntry."Shipped Qty. Not Returned" := ItemLedgEntry.Quantity;
        END;

        OnAfterInitItemLedgEntry(ItemLedgEntry, ItemJnlLine, ItemLedgEntryNo);
    END;

    LOCAL PROCEDURE InsertItemLedgEntry(VAR ItemLedgEntry: Record 32; TransferItem: Boolean);
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF ItemLedgEntry.Open THEN BEGIN
                ItemLedgEntry.VerifyOnInventory;
                IF NOT (("Document Type" IN ["Document Type"::"Purchase Return Shipment", "Document Type"::"Purchase Receipt"]) AND
                        ("Job No." <> ''))
                THEN
                    IF (ItemLedgEntry.Quantity < 0) AND
                       (ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking")
                    THEN
                        ERROR(Text018, "Serial No.", "Lot No.", "Item No.", "Variant Code");

                IF ItemTrackingCode."SN Specific Tracking" THEN BEGIN
                    IF ItemLedgEntry.Quantity > 0 THEN
                        CheckItemSerialNo(ItemJnlLine);

                    IF NOT (ItemLedgEntry.Quantity IN [-1, 0, 1]) THEN
                        ERROR(Text033);
                END;

                IF ("Document Type" <> "Document Type"::"Purchase Return Shipment") AND ("Job No." = '') THEN BEGIN
                    IF (Item.Reserve = Item.Reserve::Always) AND
                       (ItemLedgEntry.Quantity < 0)
                    THEN
                        ERROR(Text012, ItemLedgEntry."Item No.");
                END;
            END;

            IF IsWarehouseReclassification(ItemJnlLine) THEN BEGIN
                ItemLedgEntry."Global Dimension 1 Code" := OldItemLedgEntry."Global Dimension 1 Code";
                ItemLedgEntry."Global Dimension 2 Code" := OldItemLedgEntry."Global Dimension 2 Code";
                ItemLedgEntry."Dimension Set ID" := OldItemLedgEntry."Dimension Set ID"
            END ELSE
                IF TransferItem THEN BEGIN
                    ItemLedgEntry."Global Dimension 1 Code" := "New Shortcut Dimension 1 Code";
                    ItemLedgEntry."Global Dimension 2 Code" := "New Shortcut Dimension 2 Code";
                    ItemLedgEntry."Dimension Set ID" := "New Dimension Set ID";
                END ELSE BEGIN
                    ItemLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    ItemLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    ItemLedgEntry."Dimension Set ID" := "Dimension Set ID";
                END;

            IF NOT ("Entry Type" IN ["Entry Type"::Transfer, "Entry Type"::Output]) AND
               (ItemLedgEntry.Quantity = ItemLedgEntry."Invoiced Quantity")
            THEN
                ItemLedgEntry."Completely Invoiced" := TRUE;

            IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = '') AND
               ("Invoiced Quantity" <> 0) AND ("Posting Date" > ItemLedgEntry."Last Invoice Date")
            THEN
                ItemLedgEntry."Last Invoice Date" := "Posting Date";

            IF "Entry Type" = "Entry Type"::Consumption THEN
                ItemLedgEntry."Applied Entry to Adjust" := TRUE;

            IF "Job No." <> '' THEN BEGIN
                ItemLedgEntry."Job No." := "Job No.";
                ItemLedgEntry."Job Task No." := "Job Task No.";
            END;

            ItemLedgEntry.UpdateItemTracking;

            OnBeforeInsertItemLedgEntry(ItemLedgEntry, ItemJnlLine, TransferItem);
            ItemLedgEntry.INSERT(TRUE);
            OnAfterInsertItemLedgEntry(ItemLedgEntry, ItemJnlLine, ItemLedgEntryNo, ValueEntryNo, ItemApplnEntryNo);

            InsertItemReg(ItemLedgEntry."Entry No.", 0, 0, 0);
        END;
    END;

    LOCAL PROCEDURE InsertItemReg(ItemLedgEntryNo: Integer; PhysInvtEntryNo: Integer; ValueEntryNo: Integer; CapLedgEntryNo: Integer);
    BEGIN
        WITH ItemJnlLine DO
            IF ItemReg."No." = 0 THEN BEGIN
                ItemReg.LOCKTABLE;
                IF ItemReg.FINDLAST THEN
                    ItemReg."No." := ItemReg."No." + 1
                ELSE
                    ItemReg."No." := 1;
                ItemReg.INIT;
                ItemReg."From Entry No." := ItemLedgEntryNo;
                ItemReg."To Entry No." := ItemLedgEntryNo;
                ItemReg."From Phys. Inventory Entry No." := PhysInvtEntryNo;
                ItemReg."To Phys. Inventory Entry No." := PhysInvtEntryNo;
                ItemReg."From Value Entry No." := ValueEntryNo;
                ItemReg."To Value Entry No." := ValueEntryNo;
                ItemReg."From Capacity Entry No." := CapLedgEntryNo;
                ItemReg."To Capacity Entry No." := CapLedgEntryNo;
                ItemReg."Creation Date" := TODAY;
                ItemReg."Creation Time" := TIME;
                ItemReg."Source Code" := "Source Code";
                ItemReg."Journal Batch Name" := "Journal Batch Name";
                ItemReg."User ID" := USERID;
                ItemReg.INSERT;
            END ELSE BEGIN
                IF ((ItemLedgEntryNo < ItemReg."From Entry No.") AND (ItemLedgEntryNo <> 0)) OR
                   ((ItemReg."From Entry No." = 0) AND (ItemLedgEntryNo > 0))
                THEN
                    ItemReg."From Entry No." := ItemLedgEntryNo;
                IF ItemLedgEntryNo > ItemReg."To Entry No." THEN
                    ItemReg."To Entry No." := ItemLedgEntryNo;

                IF ((PhysInvtEntryNo < ItemReg."From Phys. Inventory Entry No.") AND (PhysInvtEntryNo <> 0)) OR
                   ((ItemReg."From Phys. Inventory Entry No." = 0) AND (PhysInvtEntryNo > 0))
                THEN
                    ItemReg."From Phys. Inventory Entry No." := PhysInvtEntryNo;
                IF PhysInvtEntryNo > ItemReg."To Phys. Inventory Entry No." THEN
                    ItemReg."To Phys. Inventory Entry No." := PhysInvtEntryNo;

                IF ((ValueEntryNo < ItemReg."From Value Entry No.") AND (ValueEntryNo <> 0)) OR
                   ((ItemReg."From Value Entry No." = 0) AND (ValueEntryNo > 0))
                THEN
                    ItemReg."From Value Entry No." := ValueEntryNo;
                IF ValueEntryNo > ItemReg."To Value Entry No." THEN
                    ItemReg."To Value Entry No." := ValueEntryNo;
                IF ((CapLedgEntryNo < ItemReg."From Capacity Entry No.") AND (CapLedgEntryNo <> 0)) OR
                   ((ItemReg."From Capacity Entry No." = 0) AND (CapLedgEntryNo > 0))
                THEN
                    ItemReg."From Capacity Entry No." := CapLedgEntryNo;
                IF CapLedgEntryNo > ItemReg."To Capacity Entry No." THEN
                    ItemReg."To Capacity Entry No." := CapLedgEntryNo;

                ItemReg.MODIFY;
            END;
    END;

    LOCAL PROCEDURE InsertPhysInventoryEntry();
    VAR
        PhysInvtLedgEntry: Record 281;
    BEGIN
        WITH ItemJnlLineOrigin DO BEGIN
            IF PhysInvtEntryNo = 0 THEN BEGIN
                PhysInvtLedgEntry.LOCKTABLE;
                IF PhysInvtLedgEntry.FINDLAST THEN
                    PhysInvtEntryNo := PhysInvtLedgEntry."Entry No.";
            END;

            PhysInvtEntryNo := PhysInvtEntryNo + 1;

            PhysInvtLedgEntry.INIT;
            PhysInvtLedgEntry."Entry No." := PhysInvtEntryNo;
            PhysInvtLedgEntry."Item No." := "Item No.";
            PhysInvtLedgEntry."Posting Date" := "Posting Date";
            PhysInvtLedgEntry."Document Date" := "Document Date";
            PhysInvtLedgEntry."Entry Type" := "Entry Type";
            PhysInvtLedgEntry."Document No." := "Document No.";
            PhysInvtLedgEntry."External Document No." := "External Document No.";
            PhysInvtLedgEntry.Description := Description;
            PhysInvtLedgEntry."Location Code" := "Location Code";
            PhysInvtLedgEntry."Inventory Posting Group" := "Inventory Posting Group";
            PhysInvtLedgEntry."Unit Cost" := "Unit Cost";
            PhysInvtLedgEntry.Amount := Amount;
            PhysInvtLedgEntry."Salespers./Purch. Code" := "Salespers./Purch. Code";
            PhysInvtLedgEntry."Source Code" := "Source Code";
            PhysInvtLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            PhysInvtLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            PhysInvtLedgEntry."Dimension Set ID" := "Dimension Set ID";
            PhysInvtLedgEntry."Journal Batch Name" := "Journal Batch Name";
            PhysInvtLedgEntry."Reason Code" := "Reason Code";
            PhysInvtLedgEntry."User ID" := USERID;
            PhysInvtLedgEntry."No. Series" := "Posting No. Series";
            GetInvtSetup;
            IF (PhysInvtLedgEntry.Description = Item.Description) AND NOT InvtSetup."Copy Item Descr. to Entries" THEN
                PhysInvtLedgEntry.Description := '';
            PhysInvtLedgEntry."Variant Code" := "Variant Code";
            PhysInvtLedgEntry."Unit of Measure Code" := "Unit of Measure Code";

            PhysInvtLedgEntry.Quantity := Quantity;
            PhysInvtLedgEntry."Unit Amount" := "Unit Amount";
            PhysInvtLedgEntry."Qty. (Calculated)" := "Qty. (Calculated)";
            PhysInvtLedgEntry."Qty. (Phys. Inventory)" := "Qty. (Phys. Inventory)";
            PhysInvtLedgEntry."Last Item Ledger Entry No." := "Last Item Ledger Entry No.";

            PhysInvtLedgEntry."Phys Invt Counting Period Code" :=
              "Phys Invt Counting Period Code";
            PhysInvtLedgEntry."Phys Invt Counting Period Type" :=
              "Phys Invt Counting Period Type";

            OnBeforeInsertPhysInvtLedgEntry(PhysInvtLedgEntry, ItemJnlLineOrigin);
            PhysInvtLedgEntry.INSERT;

            InsertItemReg(0, PhysInvtLedgEntry."Entry No.", 0, 0);
        END;
    END;

    LOCAL PROCEDURE PostInventoryToGL(VAR ValueEntry: Record 5802);
    BEGIN
        WITH ValueEntry DO BEGIN
            IF CalledFromAdjustment AND NOT PostToGL THEN
                EXIT;
            InvtPost.SetRunOnlyCheck(TRUE, NOT PostToGL, FALSE);
            IF InvtPost.BufferInvtPosting(ValueEntry) THEN
                InvtPost.PostInvtPostBufPerEntry(ValueEntry);

            IF "Expected Cost" THEN BEGIN
                IF ("Cost Amount (Expected)" = 0) AND ("Cost Amount (Expected) (ACY)" = 0) THEN
                    SetValueEntry(ValueEntry, 1, 1, FALSE)
                ELSE
                    SetValueEntry(ValueEntry, "Cost Amount (Expected)", "Cost Amount (Expected) (ACY)", FALSE);
                InvtPost.SetRunOnlyCheck(TRUE, TRUE, FALSE);
                IF InvtPost.BufferInvtPosting(ValueEntry) THEN
                    InvtPost.PostInvtPostBufPerEntry(ValueEntry);
                SetValueEntry(ValueEntry, 0, 0, TRUE);
            END ELSE
                IF ("Cost Amount (Actual)" = 0) AND ("Cost Amount (Actual) (ACY)" = 0) THEN BEGIN
                    SetValueEntry(ValueEntry, 1, 1, FALSE);
                    InvtPost.SetRunOnlyCheck(TRUE, TRUE, FALSE);
                    IF InvtPost.BufferInvtPosting(ValueEntry) THEN
                        InvtPost.PostInvtPostBufPerEntry(ValueEntry);
                    SetValueEntry(ValueEntry, 0, 0, FALSE);
                END;
        END;
    END;

    LOCAL PROCEDURE SetValueEntry(VAR ValueEntry: Record 5802; CostAmtActual: Decimal; CostAmtActACY: Decimal; ExpectedCost: Boolean);
    BEGIN
        ValueEntry."Cost Amount (Actual)" := CostAmtActual;
        ValueEntry."Cost Amount (Actual) (ACY)" := CostAmtActACY;
        ValueEntry."Expected Cost" := ExpectedCost;
    END;

    LOCAL PROCEDURE InsertApplEntry(ItemLedgEntryNo: Integer; InboundItemEntry: Integer; OutboundItemEntry: Integer; TransferedFromEntryNo: Integer; PostingDate: Date; Quantity: Decimal; CostToApply: Boolean);
    VAR
        ApplItemLedgEntry: Record 32;
        OldItemApplnEntry: Record 339;
        ItemApplHistoryEntry: Record 343;
        ItemApplnEntryExists: Boolean;
    BEGIN
        IF Item.IsNonInventoriableType THEN
            EXIT;

        IF ItemApplnEntryNo = 0 THEN BEGIN
            ItemApplnEntry.RESET;
            ItemApplnEntry.LOCKTABLE;
            IF ItemApplnEntry.FINDLAST THEN BEGIN
                ItemApplnEntryNo := ItemApplnEntry."Entry No.";
                ItemApplHistoryEntry.RESET;
                ItemApplHistoryEntry.LOCKTABLE;
                ItemApplHistoryEntry.SETCURRENTKEY("Entry No.");
                IF ItemApplHistoryEntry.FINDLAST THEN
                    IF ItemApplHistoryEntry."Entry No." > ItemApplnEntryNo THEN
                        ItemApplnEntryNo := ItemApplHistoryEntry."Entry No.";
            END
            ELSE
                ItemApplnEntryNo := 0;
        END;

        IF Quantity < 0 THEN BEGIN
            OldItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
            OldItemApplnEntry.SETRANGE("Inbound Item Entry No.", InboundItemEntry);
            OldItemApplnEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
            OldItemApplnEntry.SETRANGE("Outbound Item Entry No.", OutboundItemEntry);
            IF OldItemApplnEntry.FINDFIRST THEN BEGIN
                ItemApplnEntry := OldItemApplnEntry;
                ItemApplnEntry.Quantity := ItemApplnEntry.Quantity + Quantity;
                ItemApplnEntry."Last Modified Date" := CURRENTDATETIME;
                ItemApplnEntry."Last Modified By User" := USERID;
                ItemApplnEntry.MODIFY;
                ItemApplnEntryExists := TRUE;
            END;
        END;

        IF NOT ItemApplnEntryExists THEN BEGIN
            ItemApplnEntryNo := ItemApplnEntryNo + 1;
            ItemApplnEntry.INIT;
            ItemApplnEntry."Entry No." := ItemApplnEntryNo;
            ItemApplnEntry."Item Ledger Entry No." := ItemLedgEntryNo;
            ItemApplnEntry."Inbound Item Entry No." := InboundItemEntry;
            ItemApplnEntry."Outbound Item Entry No." := OutboundItemEntry;
            ItemApplnEntry."Transferred-from Entry No." := TransferedFromEntryNo;
            ItemApplnEntry.Quantity := Quantity;
            ItemApplnEntry."Posting Date" := PostingDate;
            ItemApplnEntry."Output Completely Invd. Date" := GetOutputComplInvcdDate(ItemApplnEntry);

            IF AverageTransfer THEN BEGIN
                IF (Quantity > 0) OR (ItemJnlLine."Document Type" = ItemJnlLine."Document Type"::"Transfer Receipt") THEN
                    ItemApplnEntry."Cost Application" := ItemApplnEntry.IsOutbndItemApplEntryCostApplication(ItemLedgEntryNo);
            END ELSE
                CASE TRUE OF
                    Item."Costing Method" <> Item."Costing Method"::Average,
                  ItemJnlLine.Correction AND (ItemJnlLine."Document Type" = ItemJnlLine."Document Type"::"Posted Assembly"):
                        ItemApplnEntry."Cost Application" := TRUE;
                    ItemJnlLine.Correction:
                        BEGIN
                            ApplItemLedgEntry.GET(ItemApplnEntry."Item Ledger Entry No.");
                            ItemApplnEntry."Cost Application" :=
                              (ApplItemLedgEntry.Quantity > 0) OR (ApplItemLedgEntry."Applies-to Entry" <> 0);
                        END;
                    ELSE
                        IF (ItemJnlLine."Applies-to Entry" <> 0) OR
                           (CostToApply AND ItemJnlLine.IsInbound)
                        THEN
                            ItemApplnEntry."Cost Application" := TRUE;
                END;

            ItemApplnEntry."Creation Date" := CURRENTDATETIME;
            ItemApplnEntry."Created By User" := USERID;
            ItemApplnEntry.INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE UpdateItemApplnEntry(ItemLedgEntryNo: Integer; PostingDate: Date);
    VAR
        ItemApplnEntry: Record 339;
    BEGIN
        WITH ItemApplnEntry DO BEGIN
            SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
            SETRANGE("Output Completely Invd. Date", 0D);
            IF NOT ISEMPTY THEN
                MODIFYALL("Output Completely Invd. Date", PostingDate);
        END;
    END;

    LOCAL PROCEDURE GetOutputComplInvcdDate(ItemApplnEntry: Record 339): Date;
    VAR
        OutbndItemLedgEntry: Record 32;
    BEGIN
        WITH ItemApplnEntry DO BEGIN
            IF Quantity > 0 THEN
                EXIT("Posting Date");
            IF OutbndItemLedgEntry.GET("Outbound Item Entry No.") THEN
                IF OutbndItemLedgEntry."Completely Invoiced" THEN
                    EXIT(OutbndItemLedgEntry."Last Invoice Date");
        END;
    END;

    LOCAL PROCEDURE InitValueEntry(VAR ValueEntry: Record 5802; ItemLedgEntry: Record 32);
    VAR
        CalcUnitCost: Boolean;
        CostAmt: Decimal;
        CostAmtACY: Decimal;
    BEGIN
        OnBeforeInitValueEntry(ValueEntry, ValueEntryNo, ItemJnlLine);

        ValueEntryNo := ValueEntryNo + 1;

        WITH ItemJnlLine DO BEGIN
            ValueEntry.INIT;
            ValueEntry."Entry No." := ValueEntryNo;
            IF "Value Entry Type" = "Value Entry Type"::Variance THEN
                ValueEntry."Variance Type" := "Variance Type";
            ValueEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
            ValueEntry."Item No." := "Item No.";
            ValueEntry."Item Charge No." := "Item Charge No.";
            ValueEntry."Order Type" := ItemLedgEntry."Order Type";
            ValueEntry."Order No." := ItemLedgEntry."Order No.";
            ValueEntry."Order Line No." := ItemLedgEntry."Order Line No.";
            ValueEntry."Item Ledger Entry Type" := "Entry Type";
            ValueEntry.Type := Type;
            ValueEntry."Posting Date" := "Posting Date";
            IF "Partial Revaluation" THEN
                ValueEntry."Partial Revaluation" := TRUE;

            IF (ItemLedgEntry.Quantity > 0) OR
               (ItemLedgEntry."Invoiced Quantity" > 0) OR
               (("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = '')) OR
               ("Entry Type" IN ["Entry Type"::Output, "Entry Type"::"Assembly Output"]) OR
               Adjustment
            THEN
                ValueEntry.Inventoriable := Item.Type = Item.Type::Inventory;

            IF ((Quantity = 0) AND ("Invoiced Quantity" <> 0)) OR
               ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
               ("Item Charge No." <> '') OR Adjustment
            THEN BEGIN
                GetLastDirectCostValEntry(ValueEntry."Item Ledger Entry No.");
                IF ValueEntry.Inventoriable AND ("Item Charge No." = '') THEN
                    ValueEntry."Valued By Average Cost" := DirCostValueEntry."Valued By Average Cost";
            END;

            CASE TRUE OF
                ((Quantity = 0) AND ("Invoiced Quantity" <> 0)) OR
              (("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." <> '')) OR
              Adjustment OR ("Value Entry Type" = "Value Entry Type"::Rounding):
                    ValueEntry."Valuation Date" := DirCostValueEntry."Valuation Date";
                ("Value Entry Type" = "Value Entry Type"::Revaluation):
                    IF "Posting Date" < DirCostValueEntry."Valuation Date" THEN
                        ValueEntry."Valuation Date" := DirCostValueEntry."Valuation Date"
                    ELSE
                        ValueEntry."Valuation Date" := "Posting Date";
                (ItemLedgEntry.Quantity > 0) AND ("Applies-from Entry" <> 0):
                    GetAppliedFromValues(ValueEntry);
                ELSE
                    ValueEntry."Valuation Date" := "Posting Date";
            END;

            GetInvtSetup;
            IF (Description = Item.Description) AND NOT InvtSetup."Copy Item Descr. to Entries" THEN
                ValueEntry.Description := ''
            ELSE
                ValueEntry.Description := Description;

            ValueEntry."Source Code" := "Source Code";
            ValueEntry."Source Type" := "Source Type";
            ValueEntry."Source No." := GetSourceNo(ItemJnlLine);
            IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = '') THEN
                ValueEntry."Inventory Posting Group" := "Inventory Posting Group"
            ELSE
                ValueEntry."Inventory Posting Group" := DirCostValueEntry."Inventory Posting Group";
            ValueEntry."Source Posting Group" := "Source Posting Group";
            ValueEntry."Salespers./Purch. Code" := "Salespers./Purch. Code";
            ValueEntry."Location Code" := ItemLedgEntry."Location Code";
            ValueEntry."Variant Code" := ItemLedgEntry."Variant Code";
            ValueEntry."Journal Batch Name" := "Journal Batch Name";
            ValueEntry."User ID" := USERID;
            ValueEntry."Drop Shipment" := "Drop Shipment";
            ValueEntry."Reason Code" := "Reason Code";
            ValueEntry."Return Reason Code" := "Return Reason Code";
            ValueEntry."External Document No." := "External Document No.";
            ValueEntry."Document Date" := "Document Date";
            ValueEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            ValueEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ValueEntry."Discount Amount" := "Discount Amount";
            ValueEntry."Entry Type" := "Value Entry Type";
            IF "Job No." <> '' THEN BEGIN
                ValueEntry."Job No." := "Job No.";
                ValueEntry."Job Task No." := "Job Task No.";
            END;
            IF "Invoiced Quantity" <> 0 THEN BEGIN
                ValueEntry."Valued Quantity" := "Invoiced Quantity";
                IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
                   ("Item Charge No." = '')
                THEN
                    IF ("Entry Type" <> "Entry Type"::Output) OR
                       (ItemLedgEntry."Invoiced Quantity" = 0)
                    THEN
                        ValueEntry."Invoiced Quantity" := "Invoiced Quantity";
                ValueEntry."Expected Cost" := FALSE;
            END ELSE BEGIN
                ValueEntry."Valued Quantity" := Quantity;
                ValueEntry."Expected Cost" := "Value Entry Type" <> "Value Entry Type"::Revaluation;
            END;

            ValueEntry."Document Type" := "Document Type";
            IF ValueEntry."Expected Cost" OR ("Invoice No." = '') THEN
                ValueEntry."Document No." := "Document No."
            ELSE BEGIN
                ValueEntry."Document No." := "Invoice No.";
                IF "Document Type" IN [
                                       "Document Type"::"Purchase Receipt", "Document Type"::"Purchase Return Shipment",
                                       "Document Type"::"Sales Shipment", "Document Type"::"Sales Return Receipt",
                                       "Document Type"::"Service Shipment"]
                THEN
                    ValueEntry."Document Type" := Enum::"Item Ledger Document Type".FromInteger("Document Type".AsInteger() + 1);
            END;
            ValueEntry."Document Line No." := "Document Line No.";

            IF Adjustment THEN BEGIN
                ValueEntry."Invoiced Quantity" := 0;
                ValueEntry."Applies-to Entry" := "Applies-to Value Entry";
                ValueEntry.Adjustment := TRUE;
            END;

            IF "Value Entry Type" <> "Value Entry Type"::Rounding THEN BEGIN
                IF ("Entry Type" = "Entry Type"::Output) AND
                   ("Value Entry Type" <> "Value Entry Type"::Revaluation)
                THEN BEGIN
                    CostAmt := Amount;
                    CostAmtACY := "Amount (ACY)";
                END ELSE BEGIN
                    ValueEntry."Cost per Unit" := RetrieveCostPerUnit;
                    IF GLSetup."Additional Reporting Currency" <> '' THEN
                        ValueEntry."Cost per Unit (ACY)" := RetrieveCostPerUnitACY(ValueEntry."Cost per Unit");

                    IF (ValueEntry."Valued Quantity" > 0) AND
                       (ValueEntry."Item Ledger Entry Type" IN [ValueEntry."Item Ledger Entry Type"::Purchase,
                                                                ValueEntry."Item Ledger Entry Type"::"Assembly Output"]) AND
                       (ValueEntry."Entry Type" = ValueEntry."Entry Type"::"Direct Cost") AND
                       NOT Adjustment
                    THEN BEGIN
                        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                            "Unit Cost" := ValueEntry."Cost per Unit";
                        CalcPosShares(
                          CostAmt, OverheadAmount, VarianceAmount, CostAmtACY, OverheadAmountACY, VarianceAmountACY,
                          CalcUnitCost, (Item."Costing Method" = Item."Costing Method"::Standard) AND
                          (NOT ValueEntry."Expected Cost"), ValueEntry."Expected Cost");
                        IF (OverheadAmount <> 0) OR
                           (ROUND(VarianceAmount, GLSetup."Amount Rounding Precision") <> 0) OR
                           CalcUnitCost OR ValueEntry."Expected Cost"
                        THEN BEGIN
                            ValueEntry."Cost per Unit" :=
                              CalcCostPerUnit(CostAmt, ValueEntry."Valued Quantity", FALSE);

                            IF GLSetup."Additional Reporting Currency" <> '' THEN
                                ValueEntry."Cost per Unit (ACY)" :=
                                  CalcCostPerUnit(CostAmtACY, ValueEntry."Valued Quantity", TRUE);
                        END;
                    END ELSE
                        IF NOT Adjustment THEN
                            CalcOutboundCostAmt(ValueEntry, CostAmt, CostAmtACY)
                        ELSE BEGIN
                            CostAmt := Amount;
                            CostAmtACY := "Amount (ACY)";
                        END;

                    IF ("Invoiced Quantity" < 0) AND ("Applies-to Entry" <> 0) AND
                       ("Entry Type" = "Entry Type"::Purchase) AND ("Item Charge No." = '') AND
                       (ValueEntry."Entry Type" = ValueEntry."Entry Type"::"Direct Cost")
                    THEN BEGIN
                        CalcPurchCorrShares(OverheadAmount, OverheadAmountACY, VarianceAmount, VarianceAmountACY);
                        OnAfterCalcPurchCorrShares(
                          ValueEntry, ItemJnlLine, OverheadAmount, OverheadAmountACY, VarianceAmount, VarianceAmountACY);
                    END;
                END
            END ELSE BEGIN
                CostAmt := "Unit Cost";
                CostAmtACY := "Unit Cost (ACY)";
            END;

            IF (ValueEntry."Entry Type" <> ValueEntry."Entry Type"::Revaluation) AND NOT Adjustment THEN
                IF (ValueEntry."Item Ledger Entry Type" IN
                    [ValueEntry."Item Ledger Entry Type"::Sale,
                     ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                     ValueEntry."Item Ledger Entry Type"::Consumption,
                     ValueEntry."Item Ledger Entry Type"::"Assembly Consumption"]) OR
                   ((ValueEntry."Item Ledger Entry Type" = ValueEntry."Item Ledger Entry Type"::Transfer) AND
                    ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = ''))
                THEN BEGIN
                    ValueEntry."Valued Quantity" := -ValueEntry."Valued Quantity";
                    ValueEntry."Invoiced Quantity" := -ValueEntry."Invoiced Quantity";
                    IF ValueEntry."Item Ledger Entry Type" = ValueEntry."Item Ledger Entry Type"::Transfer THEN
                        ValueEntry."Discount Amount" := 0
                    ELSE
                        ValueEntry."Discount Amount" := -ValueEntry."Discount Amount";

                    IF "Value Entry Type" <> "Value Entry Type"::Rounding THEN BEGIN
                        CostAmt := -CostAmt;
                        CostAmtACY := -CostAmtACY;
                    END;
                END;
            IF NOT Adjustment THEN
                IF Item."Inventory Value Zero" OR
                   (("Entry Type" = "Entry Type"::Transfer) AND
                    (ValueEntry."Valued Quantity" < 0) AND NOT AverageTransfer) OR
                   (("Entry Type" = "Entry Type"::Sale) AND
                    ("Item Charge No." <> ''))
                THEN BEGIN
                    CostAmt := 0;
                    CostAmtACY := 0;
                    ValueEntry."Cost per Unit" := 0;
                    ValueEntry."Cost per Unit (ACY)" := 0;
                END;

            CASE TRUE OF
                (NOT ValueEntry."Expected Cost") AND ValueEntry.Inventoriable AND
                IsInterimRevaluation:
                    BEGIN
                        ValueEntry."Cost Amount (Expected)" := ROUND(CostAmt * "Applied Amount" / Amount);
                        ValueEntry."Cost Amount (Expected) (ACY)" := ROUND(CostAmtACY * "Applied Amount" / Amount,
                            Currency."Amount Rounding Precision");

                        CostAmt := ROUND(CostAmt);
                        CostAmtACY := ROUND(CostAmtACY, Currency."Amount Rounding Precision");
                        ValueEntry."Cost Amount (Actual)" := CostAmt - ValueEntry."Cost Amount (Expected)";
                        ValueEntry."Cost Amount (Actual) (ACY)" := CostAmtACY - ValueEntry."Cost Amount (Expected) (ACY)";
                    END;
                (NOT ValueEntry."Expected Cost") AND ValueEntry.Inventoriable:
                    BEGIN
                        IF NOT Adjustment AND ("Value Entry Type" = "Value Entry Type"::"Direct Cost") THEN
                            CASE "Entry Type" OF
                                "Entry Type"::Sale:
                                    ValueEntry."Sales Amount (Actual)" := Amount;
                                "Entry Type"::Purchase:
                                    ValueEntry."Purchase Amount (Actual)" := Amount;
                            END;
                        ValueEntry."Cost Amount (Actual)" := CostAmt;
                        ValueEntry."Cost Amount (Actual) (ACY)" := CostAmtACY;
                    END;
                ValueEntry."Expected Cost" AND ValueEntry.Inventoriable:
                    BEGIN
                        IF NOT Adjustment THEN
                            CASE "Entry Type" OF
                                "Entry Type"::Sale:
                                    ValueEntry."Sales Amount (Expected)" := Amount;
                                "Entry Type"::Purchase:
                                    ValueEntry."Purchase Amount (Expected)" := Amount;
                            END;
                        ValueEntry."Cost Amount (Expected)" := CostAmt;
                        ValueEntry."Cost Amount (Expected) (ACY)" := CostAmtACY;
                    END;
                (NOT ValueEntry."Expected Cost") AND (NOT ValueEntry.Inventoriable):
                    IF "Entry Type" = "Entry Type"::Sale THEN BEGIN
                        ValueEntry."Sales Amount (Actual)" := Amount;
                        IF Item.IsNonInventoriableType THEN BEGIN
                            ValueEntry."Cost Amount (Non-Invtbl.)" := CostAmt;
                            ValueEntry."Cost Amount (Non-Invtbl.)(ACY)" := CostAmtACY;
                        END ELSE BEGIN
                            ValueEntry."Cost per Unit" := 0;
                            ValueEntry."Cost per Unit (ACY)" := 0;
                        END;
                    END ELSE BEGIN
                        IF "Entry Type" = "Entry Type"::Purchase THEN
                            ValueEntry."Purchase Amount (Actual)" := Amount;
                        ValueEntry."Cost Amount (Non-Invtbl.)" := CostAmt;
                        ValueEntry."Cost Amount (Non-Invtbl.)(ACY)" := CostAmtACY;
                    END;
            END;
            IF GLSetup."Payment Discount Type" = GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines" THEN
                IF (ValueEntry."Discount Amount" <> 0) AND ("Item Charge No." <> '') THEN
                    CASE "Entry Type" OF
                        "Entry Type"::Sale:
                            ValueEntry."Sales Amount (Actual)" := ValueEntry."Sales Amount (Actual)" - "Pmt. Discount Amount";
                        "Entry Type"::Purchase:
                            BEGIN
                                IF ValueEntry.Inventoriable AND NOT ValueEntry."Expected Cost" THEN
                                    ValueEntry."Cost Amount (Actual)" := CostAmt - "Pmt. Discount Amount";
                                ValueEntry."Purchase Amount (Actual)" := ValueEntry."Purchase Amount (Actual)" - "Pmt. Discount Amount";
                            END;
                    END;
            RoundAmtValueEntry(ValueEntry);

            OnAfterInitValueEntry(ValueEntry, ItemJnlLine, ValueEntryNo);
        END;
    END;

    LOCAL PROCEDURE CalcOutboundCostAmt(ValueEntry: Record 5802; VAR CostAmt: Decimal; VAR CostAmtACY: Decimal);
    BEGIN
        IF ItemJnlLine."Item Charge No." <> '' THEN BEGIN
            CostAmt := ItemJnlLine.Amount;
            IF GLSetup."Additional Reporting Currency" <> '' THEN
                CostAmtACY := ACYMgt.CalcACYAmt(CostAmt, ValueEntry."Posting Date", FALSE);
        END ELSE BEGIN
            CostAmt :=
              ValueEntry."Cost per Unit" * ValueEntry."Valued Quantity";
            CostAmtACY :=
              ValueEntry."Cost per Unit (ACY)" * ValueEntry."Valued Quantity";

            IF (ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation) AND
               (Item."Costing Method" = Item."Costing Method"::Average)
            THEN BEGIN
                CostAmt += RoundingResidualAmount;
                CostAmtACY += RoundingResidualAmountACY;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertValueEntry(VAR ValueEntry: Record 5802; VAR ItemLedgEntry: Record 32; TransferItem: Boolean);
    VAR
        InvdValueEntry: Record 5802;
        InvoicedQty: Decimal;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF IsWarehouseReclassification(ItemJnlLine) THEN BEGIN
                ValueEntry."Dimension Set ID" := OldItemLedgEntry."Dimension Set ID";
                ValueEntry."Global Dimension 1 Code" := OldItemLedgEntry."Global Dimension 1 Code";
                ValueEntry."Global Dimension 2 Code" := OldItemLedgEntry."Global Dimension 2 Code";
            END ELSE
                IF TransferItem THEN BEGIN
                    ValueEntry."Global Dimension 1 Code" := "New Shortcut Dimension 1 Code";
                    ValueEntry."Global Dimension 2 Code" := "New Shortcut Dimension 2 Code";
                    ValueEntry."Dimension Set ID" := "New Dimension Set ID";
                END ELSE
                    IF (GlobalValueEntry."Entry Type" = GlobalValueEntry."Entry Type"::"Direct Cost") AND
                       (GlobalValueEntry."Item Charge No." <> '') AND
                       (ValueEntry."Entry Type" = ValueEntry."Entry Type"::Variance)
                    THEN BEGIN
                        GetLastDirectCostValEntry(ValueEntry."Item Ledger Entry No.");
                        ValueEntry."Gen. Prod. Posting Group" := DirCostValueEntry."Gen. Prod. Posting Group";
                        MoveValEntryDimToValEntryDim(ValueEntry, DirCostValueEntry);
                    END ELSE BEGIN
                        ValueEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                        ValueEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                        ValueEntry."Dimension Set ID" := "Dimension Set ID";
                    END;
            RoundAmtValueEntry(ValueEntry);

            IF ValueEntry."Entry Type" = ValueEntry."Entry Type"::Rounding THEN BEGIN
                ValueEntry."Valued Quantity" := ItemLedgEntry.Quantity;
                ValueEntry."Invoiced Quantity" := 0;
                ValueEntry."Cost per Unit" := 0;
                ValueEntry."Sales Amount (Actual)" := 0;
                ValueEntry."Purchase Amount (Actual)" := 0;
                ValueEntry."Cost per Unit (ACY)" := 0;
                ValueEntry."Item Ledger Entry Quantity" := 0;
            END ELSE BEGIN
                IF IsFirstValueEntry(ValueEntry."Item Ledger Entry No.") THEN
                    ValueEntry."Item Ledger Entry Quantity" := ValueEntry."Valued Quantity"
                ELSE
                    ValueEntry."Item Ledger Entry Quantity" := 0;
                IF ValueEntry."Cost per Unit" = 0 THEN BEGIN
                    ValueEntry."Cost per Unit" :=
                      CalcCostPerUnit(ValueEntry."Cost Amount (Actual)", ValueEntry."Valued Quantity", FALSE);
                    ValueEntry."Cost per Unit (ACY)" :=
                      CalcCostPerUnit(ValueEntry."Cost Amount (Actual) (ACY)", ValueEntry."Valued Quantity", TRUE);
                END ELSE BEGIN
                    ValueEntry."Cost per Unit" := ROUND(
                        ValueEntry."Cost per Unit", GLSetup."Unit-Amount Rounding Precision");
                    ValueEntry."Cost per Unit (ACY)" := ROUND(
                        ValueEntry."Cost per Unit (ACY)", Currency."Unit-Amount Rounding Precision");
                    IF "Source Currency Code" = GLSetup."Additional Reporting Currency" THEN
                        IF ValueEntry."Expected Cost" THEN
                            ValueEntry."Cost per Unit" :=
                              CalcCostPerUnit(ValueEntry."Cost Amount (Expected)", ValueEntry."Valued Quantity", FALSE)
                        ELSE
                            IF ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation THEN
                                ValueEntry."Cost per Unit" :=
                                  CalcCostPerUnit(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)",
                                    ValueEntry."Valued Quantity", FALSE)
                            ELSE
                                ValueEntry."Cost per Unit" :=
                                  CalcCostPerUnit(ValueEntry."Cost Amount (Actual)", ValueEntry."Valued Quantity", FALSE);
                END;
                IF UpdateItemLedgEntry(ValueEntry, ItemLedgEntry) THEN
                    ItemLedgEntry.MODIFY;
            END;

            IF ((ValueEntry."Entry Type" = ValueEntry."Entry Type"::"Direct Cost") AND
                (ValueEntry."Item Charge No." = '')) AND
               (((Quantity = 0) AND ("Invoiced Quantity" <> 0)) OR
                (Adjustment AND NOT ValueEntry."Expected Cost")) AND
               NOT ExpectedCostPosted(ValueEntry)
            THEN BEGIN
                IF ValueEntry."Invoiced Quantity" = 0 THEN BEGIN
                    IF InvdValueEntry.GET(ValueEntry."Applies-to Entry") THEN
                        InvoicedQty := InvdValueEntry."Invoiced Quantity"
                    ELSE
                        InvoicedQty := ValueEntry."Valued Quantity";
                END ELSE
                    InvoicedQty := ValueEntry."Invoiced Quantity";
                CalcExpectedCost(
                  ValueEntry,
                  ItemLedgEntry."Entry No.",
                  InvoicedQty,
                  ItemLedgEntry.Quantity,
                  ValueEntry."Cost Amount (Expected)",
                  ValueEntry."Cost Amount (Expected) (ACY)",
                  ValueEntry."Sales Amount (Expected)",
                  ValueEntry."Purchase Amount (Expected)",
                  ItemLedgEntry.Quantity = ItemLedgEntry."Invoiced Quantity");
            END;

            OnBeforeInsertValueEntry(ValueEntry, ItemJnlLine, ItemLedgEntry, ValueEntryNo, InvtPost);

            IF ValueEntry.Inventoriable AND NOT Item."Inventory Value Zero" THEN
                PostInventoryToGL(ValueEntry);

            ValueEntry.INSERT;

            OnAfterInsertValueEntry(ValueEntry, ItemJnlLine, ItemLedgEntry, ValueEntryNo);

            ItemApplnEntry.SetOutboundsNotUpdated(ItemLedgEntry);

            UpdateAdjmtProp(ValueEntry, ItemLedgEntry."Posting Date");

            InsertItemReg(0, 0, ValueEntry."Entry No.", 0);
            InsertPostValueEntryToGL(ValueEntry);
            IF Item."Item Tracking Code" <> '' THEN BEGIN
                TempValueEntryRelation.INIT;
                TempValueEntryRelation."Value Entry No." := ValueEntry."Entry No.";
                TempValueEntryRelation.INSERT;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertOHValueEntry(ValueEntry: Record 5802; OverheadAmount: Decimal; OverheadAmountACY: Decimal);
    BEGIN
        OnBeforeInsertOHValueEntry(ValueEntry, Item, OverheadAmount, OverheadAmountACY);

        IF Item."Inventory Value Zero" OR NOT ValueEntry.Inventoriable THEN
            EXIT;

        ValueEntryNo := ValueEntryNo + 1;

        ValueEntry."Entry No." := ValueEntryNo;
        ValueEntry."Item Charge No." := '';
        ValueEntry."Entry Type" := ValueEntry."Entry Type"::"Indirect Cost";
        ValueEntry.Description := '';
        ValueEntry."Cost per Unit" := 0;
        ValueEntry."Cost per Unit (ACY)" := 0;
        ValueEntry."Cost Posted to G/L" := 0;
        ValueEntry."Cost Posted to G/L (ACY)" := 0;
        ValueEntry."Invoiced Quantity" := 0;
        ValueEntry."Sales Amount (Actual)" := 0;
        ValueEntry."Sales Amount (Expected)" := 0;
        ValueEntry."Purchase Amount (Actual)" := 0;
        ValueEntry."Purchase Amount (Expected)" := 0;
        ValueEntry."Discount Amount" := 0;
        ValueEntry."Cost Amount (Actual)" := OverheadAmount;
        ValueEntry."Cost Amount (Expected)" := 0;
        ValueEntry."Cost Amount (Expected) (ACY)" := 0;

        IF GLSetup."Additional Reporting Currency" <> '' THEN
            ValueEntry."Cost Amount (Actual) (ACY)" :=
              ROUND(OverheadAmountACY, Currency."Amount Rounding Precision");

        InsertValueEntry(ValueEntry, GlobalItemLedgEntry, FALSE);

        OnAfterInsertOHValueEntry(ValueEntry, Item, OverheadAmount, OverheadAmountACY);
    END;

    LOCAL PROCEDURE InsertVarValueEntry(ValueEntry: Record 5802; VarianceAmount: Decimal; VarianceAmountACY: Decimal);
    BEGIN
        OnBeforeInsertVarValueEntry(ValueEntry, Item, VarianceAmount, VarianceAmountACY);

        IF (NOT ValueEntry.Inventoriable) OR Item."Inventory Value Zero" THEN
            EXIT;
        IF (VarianceAmount = 0) AND (VarianceAmountACY = 0) THEN
            EXIT;

        ValueEntryNo := ValueEntryNo + 1;

        ValueEntry."Entry No." := ValueEntryNo;
        ValueEntry."Item Charge No." := '';
        ValueEntry."Entry Type" := ValueEntry."Entry Type"::Variance;
        ValueEntry.Description := '';
        ValueEntry."Cost Posted to G/L" := 0;
        ValueEntry."Cost Posted to G/L (ACY)" := 0;
        ValueEntry."Invoiced Quantity" := 0;
        ValueEntry."Sales Amount (Actual)" := 0;
        ValueEntry."Sales Amount (Expected)" := 0;
        ValueEntry."Purchase Amount (Actual)" := 0;
        ValueEntry."Purchase Amount (Expected)" := 0;
        ValueEntry."Discount Amount" := 0;
        ValueEntry."Cost Amount (Actual)" := VarianceAmount;
        ValueEntry."Cost Amount (Expected)" := 0;
        ValueEntry."Cost Amount (Expected) (ACY)" := 0;
        ValueEntry."Variance Type" := ValueEntry."Variance Type"::Purchase;

        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            IF ROUND(VarianceAmount, GLSetup."Amount Rounding Precision") =
               ROUND(-GlobalValueEntry."Cost Amount (Actual)", GLSetup."Amount Rounding Precision")
            THEN
                ValueEntry."Cost Amount (Actual) (ACY)" := -GlobalValueEntry."Cost Amount (Actual) (ACY)"
            ELSE
                ValueEntry."Cost Amount (Actual) (ACY)" :=
                  ROUND(VarianceAmountACY, Currency."Amount Rounding Precision");
        END;

        ValueEntry."Cost per Unit" :=
          CalcCostPerUnit(ValueEntry."Cost Amount (Actual)", ValueEntry."Valued Quantity", FALSE);
        ValueEntry."Cost per Unit (ACY)" :=
          CalcCostPerUnit(ValueEntry."Cost Amount (Actual) (ACY)", ValueEntry."Valued Quantity", TRUE);

        InsertValueEntry(ValueEntry, GlobalItemLedgEntry, FALSE);
    END;

    LOCAL PROCEDURE UpdateItemLedgEntry(ValueEntry: Record 5802; VAR ItemLedgEntry: Record 32) ModifyEntry: Boolean;
    BEGIN
        WITH ItemLedgEntry DO
            IF NOT (ValueEntry."Entry Type" IN
                    [ValueEntry."Entry Type"::Variance,
                     ValueEntry."Entry Type"::"Indirect Cost",
                     ValueEntry."Entry Type"::Rounding])
            THEN BEGIN
                IF ValueEntry.Inventoriable AND (NOT ItemJnlLine.Adjustment OR ("Entry Type" = "Entry Type"::"Assembly Output")) THEN
                    UpdateAvgCostAdjmtEntryPoint(ItemLedgEntry, ValueEntry."Valuation Date");

                IF (Positive OR "Job Purchase") AND
                   (Quantity <> "Remaining Quantity") AND NOT "Applied Entry to Adjust" AND
                   (Item.Type = Item.Type::Inventory) AND
                   (NOT CalledFromAdjustment OR AppliedEntriesToReadjust(ItemLedgEntry))
                THEN BEGIN
                    "Applied Entry to Adjust" := TRUE;
                    ModifyEntry := TRUE;
                END;

                IF (ValueEntry."Entry Type" = ValueEntry."Entry Type"::"Direct Cost") AND
                   (ItemJnlLine."Item Charge No." = '') AND
                   (ItemJnlLine.Quantity = 0) AND (ValueEntry."Invoiced Quantity" <> 0)
                THEN BEGIN
                    IF ValueEntry."Invoiced Quantity" <> 0 THEN BEGIN
                        "Invoiced Quantity" := "Invoiced Quantity" + ValueEntry."Invoiced Quantity";
                        IF ABS("Invoiced Quantity") > ABS(Quantity) THEN
                            ERROR(Text030, "Entry No.");
                        VerifyInvoicedQty(ItemLedgEntry);
                        ModifyEntry := TRUE;
                    END;

                    IF ("Entry Type" <> "Entry Type"::Output) AND
                       ("Invoiced Quantity" = Quantity) AND
                       NOT "Completely Invoiced"
                    THEN BEGIN
                        "Completely Invoiced" := TRUE;
                        ModifyEntry := TRUE;
                    END;

                    IF "Last Invoice Date" < ValueEntry."Posting Date" THEN BEGIN
                        "Last Invoice Date" := ValueEntry."Posting Date";
                        ModifyEntry := TRUE;
                    END;
                END;
                IF ItemJnlLine."Applies-from Entry" <> 0 THEN
                    UpdateOutboundItemLedgEntry(ItemJnlLine."Applies-from Entry");
            END;

        EXIT(ModifyEntry);
    END;

    LOCAL PROCEDURE UpdateAvgCostAdjmtEntryPoint(OldItemLedgEntry: Record 32; ValuationDate: Date);
    VAR
        AvgCostAdjmtEntryPoint: Record 5804;
        ValueEntry: Record 5802;
    BEGIN
        WITH AvgCostAdjmtEntryPoint DO BEGIN
            ValueEntry.INIT;
            ValueEntry."Item No." := OldItemLedgEntry."Item No.";
            ValueEntry."Valuation Date" := ValuationDate;
            ValueEntry."Location Code" := OldItemLedgEntry."Location Code";
            ValueEntry."Variant Code" := OldItemLedgEntry."Variant Code";

            LOCKTABLE;
            UpdateValuationDate(ValueEntry);
        END;
    END;

    LOCAL PROCEDURE UpdateOutboundItemLedgEntry(OutboundItemEntryNo: Integer);
    VAR
        OutboundItemLedgEntry: Record 32;
    BEGIN
        WITH OutboundItemLedgEntry DO BEGIN
            GET(OutboundItemEntryNo);
            IF Quantity > 0 THEN
                FIELDERROR(Quantity);
            IF GlobalItemLedgEntry.Quantity < 0 THEN
                GlobalItemLedgEntry.FIELDERROR(Quantity);

            "Shipped Qty. Not Returned" := "Shipped Qty. Not Returned" + ABS(ItemJnlLine.Quantity);
            IF "Shipped Qty. Not Returned" > 0 THEN
                FIELDERROR("Shipped Qty. Not Returned", Text004);
            "Applied Entry to Adjust" := TRUE;
            MODIFY;
        END;
    END;

    LOCAL PROCEDURE InitTransValueEntry(VAR ValueEntry: Record 5802; ItemLedgEntry: Record 32);
    VAR
        AdjCostInvoicedLCY: Decimal;
        AdjCostInvoicedACY: Decimal;
        DiscountAmount: Decimal;
    BEGIN
        WITH GlobalValueEntry DO BEGIN
            InitValueEntry(ValueEntry, ItemLedgEntry);
            ValueEntry."Valued Quantity" := ItemLedgEntry.Quantity;
            ValueEntry."Invoiced Quantity" := ValueEntry."Valued Quantity";
            ValueEntry."Location Code" := ItemLedgEntry."Location Code";
            ValueEntry."Valuation Date" := "Valuation Date";
            IF AverageTransfer THEN BEGIN
                ValuateAppliedAvgEntry(GlobalValueEntry, Item);
                ValueEntry."Cost Amount (Actual)" := -"Cost Amount (Actual)";
                ValueEntry."Cost Amount (Actual) (ACY)" := -"Cost Amount (Actual) (ACY)";
                ValueEntry."Cost per Unit" := 0;
                ValueEntry."Cost per Unit (ACY)" := 0;
                ValueEntry."Valued By Average Cost" :=
                  NOT (ItemLedgEntry.Positive OR
                       (ValueEntry."Document Type" = ValueEntry."Document Type"::"Transfer Receipt"));
            END ELSE BEGIN
                CalcAdjustedCost(
                  OldItemLedgEntry, ValueEntry."Valued Quantity",
                  AdjCostInvoicedLCY, AdjCostInvoicedACY, DiscountAmount);
                ValueEntry."Cost Amount (Actual)" := AdjCostInvoicedLCY;
                ValueEntry."Cost Amount (Actual) (ACY)" := AdjCostInvoicedACY;
                ValueEntry."Cost per Unit" := 0;
                ValueEntry."Cost per Unit (ACY)" := 0;

                "Cost Amount (Actual)" := "Cost Amount (Actual)" - ValueEntry."Cost Amount (Actual)";
                IF GLSetup."Additional Reporting Currency" <> '' THEN
                    "Cost Amount (Actual) (ACY)" :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        ValueEntry."Posting Date", GLSetup."Additional Reporting Currency",
                        ROUND("Cost Amount (Actual)", GLSetup."Amount Rounding Precision"),
                        CurrExchRate.ExchangeRate(
                          ValueEntry."Posting Date", GLSetup."Additional Reporting Currency"));
            END;

            "Discount Amount" := 0;
            ValueEntry."Discount Amount" := 0;
            "Cost per Unit" := 0;
            "Cost per Unit (ACY)" := 0;
        END;
    END;

    LOCAL PROCEDURE ValuateAppliedAvgEntry(VAR ValueEntry: Record 5802; Item: Record 27);
    BEGIN
        WITH ValueEntry DO
            IF (ItemJnlLine."Applies-to Entry" = 0) AND
               ("Item Ledger Entry Type" <> "Item Ledger Entry Type"::Output)
            THEN BEGIN
                IF (ItemJnlLine.Quantity = 0) AND (ItemJnlLine."Invoiced Quantity" <> 0) THEN BEGIN
                    GetLastDirectCostValEntry("Item Ledger Entry No.");
                    "Valued By Average Cost" := DirCostValueEntry."Valued By Average Cost";
                END ELSE
                    "Valued By Average Cost" := NOT ("Document Type" = "Document Type"::"Transfer Receipt");

                IF Item."Inventory Value Zero" THEN BEGIN
                    "Cost per Unit" := 0;
                    "Cost per Unit (ACY)" := 0;
                END ELSE BEGIN
                    IF "Item Ledger Entry Type" = "Item Ledger Entry Type"::Transfer THEN BEGIN
                        IF SKUExists AND (InvtSetup."Average Cost Calc. Type" <> InvtSetup."Average Cost Calc. Type"::Item) THEN
                            "Cost per Unit" := SKU."Unit Cost"
                        ELSE
                            "Cost per Unit" := Item."Unit Cost";
                    END ELSE
                        "Cost per Unit" := ItemJnlLine."Unit Cost";

                    IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                        IF (ItemJnlLine."Source Currency Code" = GLSetup."Additional Reporting Currency") AND
                           ("Item Ledger Entry Type" <> "Item Ledger Entry Type"::Transfer)
                        THEN
                            "Cost per Unit (ACY)" := ItemJnlLine."Unit Cost (ACY)"
                        ELSE
                            "Cost per Unit (ACY)" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtLCYToFCY(
                                  "Posting Date", GLSetup."Additional Reporting Currency", "Cost per Unit",
                                  CurrExchRate.ExchangeRate(
                                    "Posting Date", GLSetup."Additional Reporting Currency")),
                                Currency."Unit-Amount Rounding Precision");
                    END;
                END;

                OnValuateAppliedAvgEntryOnAfterUpdateCostAmounts(ValueEntry, ItemJnlLine);

                IF "Expected Cost" THEN BEGIN
                    "Cost Amount (Expected)" := "Valued Quantity" * "Cost per Unit";
                    "Cost Amount (Expected) (ACY)" := "Valued Quantity" * "Cost per Unit (ACY)";
                END ELSE BEGIN
                    "Cost Amount (Actual)" := "Valued Quantity" * "Cost per Unit";
                    "Cost Amount (Actual) (ACY)" := "Valued Quantity" * "Cost per Unit (ACY)";
                END;
            END;
    END;

    LOCAL PROCEDURE CalcAdjustedCost(PosItemLedgEntry: Record 32; AppliedQty: Decimal; VAR AdjustedCostLCY: Decimal; VAR AdjustedCostACY: Decimal; VAR DiscountAmount: Decimal);
    VAR
        PosValueEntry: Record 5802;
    BEGIN
        AdjustedCostLCY := 0;
        AdjustedCostACY := 0;
        DiscountAmount := 0;
        WITH PosValueEntry DO BEGIN
            SETCURRENTKEY("Item Ledger Entry No.");
            SETRANGE("Item Ledger Entry No.", PosItemLedgEntry."Entry No.");
            FINDSET;
            REPEAT
                IF "Partial Revaluation" THEN BEGIN
                    AdjustedCostLCY := AdjustedCostLCY +
                      "Cost Amount (Actual)" / "Valued Quantity" * PosItemLedgEntry.Quantity;
                    AdjustedCostACY := AdjustedCostACY +
                      "Cost Amount (Actual) (ACY)" / "Valued Quantity" * PosItemLedgEntry.Quantity;
                END ELSE BEGIN
                    AdjustedCostLCY := AdjustedCostLCY + "Cost Amount (Actual)" + "Cost Amount (Expected)";
                    AdjustedCostACY := AdjustedCostACY + "Cost Amount (Actual) (ACY)" + "Cost Amount (Expected) (ACY)";
                    DiscountAmount := DiscountAmount - "Discount Amount";
                END;
            UNTIL NEXT = 0;

            AdjustedCostLCY := AdjustedCostLCY * AppliedQty / PosItemLedgEntry.Quantity;
            AdjustedCostACY := AdjustedCostACY * AppliedQty / PosItemLedgEntry.Quantity;
            DiscountAmount := DiscountAmount * AppliedQty / PosItemLedgEntry.Quantity;
        END;
    END;

    LOCAL PROCEDURE GetMaxValuationDate(ItemLedgerEntry: Record 32): Date;
    VAR
        ValueEntry: Record 5802;
    BEGIN
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        ValueEntry.SETRANGE("Entry Type", ValueEntry."Entry Type"::Revaluation);
        IF NOT ValueEntry.FINDLAST THEN BEGIN
            ValueEntry.SETRANGE("Entry Type");
            ValueEntry.FINDLAST;
        END;
        EXIT(ValueEntry."Valuation Date");
    END;

    LOCAL PROCEDURE GetValuationDate(VAR ValueEntry: Record 5802; OldItemLedgEntry: Record 32);
    VAR
        OldValueEntry: Record 5802;
        IsHandled: Boolean;
    BEGIN
        WITH OldItemLedgEntry DO BEGIN
            OldValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            OldValueEntry.SETRANGE("Item Ledger Entry No.", "Entry No.");
            OldValueEntry.SETRANGE("Entry Type", OldValueEntry."Entry Type"::Revaluation);
            IF NOT OldValueEntry.FINDLAST THEN BEGIN
                OldValueEntry.SETRANGE("Entry Type");
                IsHandled := FALSE;
                OnGetValuationDateOnBeforeFindOldValueEntry(OldValueEntry, IsHandled);
                IF IsHandled THEN
                    EXIT;
                OldValueEntry.FINDLAST;
            END;
            IF Positive THEN BEGIN
                IF (ValueEntry."Posting Date" < OldValueEntry."Valuation Date") OR
                   (ItemJnlLine."Applies-to Entry" <> 0)
                THEN BEGIN
                    ValueEntry."Valuation Date" := OldValueEntry."Valuation Date";
                    SetValuationDateAllValueEntrie(
                      ValueEntry."Item Ledger Entry No.",
                      OldValueEntry."Valuation Date",
                      ItemJnlLine."Applies-to Entry" <> 0)
                END ELSE
                    IF ValueEntry."Valuation Date" <= ValueEntry."Posting Date" THEN BEGIN
                        ValueEntry."Valuation Date" := ValueEntry."Posting Date";
                        SetValuationDateAllValueEntrie(
                          ValueEntry."Item Ledger Entry No.",
                          ValueEntry."Posting Date",
                          ItemJnlLine."Applies-to Entry" <> 0)
                    END
            END ELSE
                IF OldValueEntry."Valuation Date" < ValueEntry."Valuation Date" THEN BEGIN
                    UpdateAvgCostAdjmtEntryPoint(OldItemLedgEntry, OldValueEntry."Valuation Date");
                    OldValueEntry.MODIFYALL("Valuation Date", ValueEntry."Valuation Date");
                    UpdateLinkedValuationDate(ValueEntry."Valuation Date", "Entry No.", Positive);
                END;
        END;
    END;

    LOCAL PROCEDURE UpdateLinkedValuationDate(FromValuationDate: Date; FromItemledgEntryNo: Integer; FromInbound: Boolean);
    VAR
        ToItemApplnEntry: Record 339;
    BEGIN
        WITH ToItemApplnEntry DO BEGIN
            IF FromInbound THEN BEGIN
                SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
                SETRANGE("Inbound Item Entry No.", FromItemledgEntryNo);
                SETFILTER("Outbound Item Entry No.", '<>%1', 0);
            END ELSE BEGIN
                SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.");
                SETRANGE("Outbound Item Entry No.", FromItemledgEntryNo);
            END;
            SETFILTER("Item Ledger Entry No.", '<>%1', FromItemledgEntryNo);
            IF FINDSET THEN
                REPEAT
                    IF FromInbound OR ("Inbound Item Entry No." <> 0) THEN BEGIN
                        GetLastDirectCostValEntry("Inbound Item Entry No.");
                        IF DirCostValueEntry."Valuation Date" < FromValuationDate THEN BEGIN
                            UpdateValuationDate(FromValuationDate, "Item Ledger Entry No.", FromInbound);
                            UpdateLinkedValuationDate(FromValuationDate, "Item Ledger Entry No.", NOT FromInbound);
                        END;
                    END;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateLinkedValuationUnapply(FromValuationDate: Date; FromItemLedgEntryNo: Integer; FromInbound: Boolean);
    VAR
        ToItemApplnEntry: Record 339;
        ItemLedgerEntry: Record 32;
    BEGIN
        WITH ToItemApplnEntry DO BEGIN
            IF FromInbound THEN BEGIN
                SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
                SETRANGE("Inbound Item Entry No.", FromItemLedgEntryNo);
                SETFILTER("Outbound Item Entry No.", '<>%1', 0);
            END ELSE BEGIN
                SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.");
                SETRANGE("Outbound Item Entry No.", FromItemLedgEntryNo);
            END;
            SETFILTER("Item Ledger Entry No.", '<>%1', FromItemLedgEntryNo);
            IF FIND('-') THEN
                REPEAT
                    IF FromInbound OR ("Inbound Item Entry No." <> 0) THEN BEGIN
                        GetLastDirectCostValEntry("Inbound Item Entry No.");
                        IF DirCostValueEntry."Valuation Date" < FromValuationDate THEN BEGIN
                            UpdateValuationDate(FromValuationDate, "Item Ledger Entry No.", FromInbound);
                            UpdateLinkedValuationUnapply(FromValuationDate, "Item Ledger Entry No.", NOT FromInbound);
                        END
                        ELSE BEGIN
                            ItemLedgerEntry.GET("Inbound Item Entry No.");
                            FromValuationDate := GetMaxAppliedValuationdate(ItemLedgerEntry);
                            IF FromValuationDate < DirCostValueEntry."Valuation Date" THEN BEGIN
                                UpdateValuationDate(FromValuationDate, ItemLedgerEntry."Entry No.", FromInbound);
                                UpdateLinkedValuationUnapply(FromValuationDate, ItemLedgerEntry."Entry No.", NOT FromInbound);
                            END;
                        END;
                    END;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateValuationDate(FromValuationDate: Date; FromItemLedgEntryNo: Integer; FromInbound: Boolean);
    VAR
        ToValueEntry2: Record 5802;
    BEGIN
        ToValueEntry2.SETCURRENTKEY("Item Ledger Entry No.");
        ToValueEntry2.SETRANGE("Item Ledger Entry No.", FromItemLedgEntryNo);
        ToValueEntry2.FIND('-');
        IF FromInbound THEN BEGIN
            IF ToValueEntry2."Valuation Date" < FromValuationDate THEN
                ToValueEntry2.MODIFYALL("Valuation Date", FromValuationDate);
        END ELSE
            REPEAT
                IF ToValueEntry2."Entry Type" = ToValueEntry2."Entry Type"::Revaluation THEN BEGIN
                    IF ToValueEntry2."Valuation Date" < FromValuationDate THEN BEGIN
                        ToValueEntry2."Valuation Date" := FromValuationDate;
                        ToValueEntry2.MODIFY;
                    END;
                END ELSE BEGIN
                    ToValueEntry2."Valuation Date" := FromValuationDate;
                    ToValueEntry2.MODIFY;
                END;
            UNTIL ToValueEntry2.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateItemJNLLinefromEntry(ItemLedgEntry: Record 32; NewQuantity: Decimal; VAR ItemJnlLine: Record 83);
    BEGIN
        CLEAR(ItemJnlLine);
        WITH ItemJnlLine DO BEGIN
            "Entry Type" := ItemLedgEntry."Entry Type"; // no mapping needed
            Quantity := Signed(NewQuantity);
            "Item No." := ItemLedgEntry."Item No.";
            "Serial No." := ItemLedgEntry."Serial No.";
            "Lot No." := ItemLedgEntry."Lot No.";
        END;
    END;

    LOCAL PROCEDURE GetAppliedFromValues(VAR ValueEntry: Record 5802);
    VAR
        NegValueEntry: Record 5802;
    BEGIN
        WITH NegValueEntry DO BEGIN
            SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            SETRANGE("Item Ledger Entry No.", ItemJnlLine."Applies-from Entry");
            SETRANGE("Entry Type", "Entry Type"::Revaluation);
            IF NOT FINDLAST THEN BEGIN
                SETRANGE("Entry Type");
                FINDLAST;
            END;

            IF "Valuation Date" > ValueEntry."Posting Date" THEN
                ValueEntry."Valuation Date" := "Valuation Date"
            ELSE
                ValueEntry."Valuation Date" := ItemJnlLine."Posting Date";
        END;
    END;

    LOCAL PROCEDURE RoundAmtValueEntry(VAR ValueEntry: Record 5802);
    BEGIN
        WITH ValueEntry DO BEGIN
            "Sales Amount (Actual)" := ROUND("Sales Amount (Actual)");
            "Sales Amount (Expected)" := ROUND("Sales Amount (Expected)");
            "Purchase Amount (Actual)" := ROUND("Purchase Amount (Actual)");
            "Purchase Amount (Expected)" := ROUND("Purchase Amount (Expected)");
            "Discount Amount" := ROUND("Discount Amount");
            "Cost Amount (Actual)" := ROUND("Cost Amount (Actual)");
            "Cost Amount (Expected)" := ROUND("Cost Amount (Expected)");
            "Cost Amount (Non-Invtbl.)" := ROUND("Cost Amount (Non-Invtbl.)");
            "Cost Amount (Actual) (ACY)" := ROUND("Cost Amount (Actual) (ACY)", Currency."Amount Rounding Precision");
            "Cost Amount (Expected) (ACY)" := ROUND("Cost Amount (Expected) (ACY)", Currency."Amount Rounding Precision");
            "Cost Amount (Non-Invtbl.)(ACY)" := ROUND("Cost Amount (Non-Invtbl.)(ACY)", Currency."Amount Rounding Precision");
        END;
    END;

    LOCAL PROCEDURE RetrieveCostPerUnit(): Decimal;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF (Item."Costing Method" = Item."Costing Method"::Standard) AND
               ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
               ("Item Charge No." = '') AND
               ("Applies-from Entry" = 0) AND
               NOT Adjustment
            THEN BEGIN
                IF SKUExists THEN
                    EXIT(SKU."Unit Cost");
                EXIT(Item."Unit Cost");
            END;
            EXIT("Unit Cost");
        END;
    END;

    LOCAL PROCEDURE RetrieveCostPerUnitACY(CostPerUnit: Decimal): Decimal;
    VAR
        ItemLedgerEntry: Record 32;
        PostingDate: Date;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF Adjustment OR ("Source Currency Code" = GLSetup."Additional Reporting Currency") AND
               ((Item."Costing Method" <> Item."Costing Method"::Standard) OR
                (("Discount Amount" = 0) AND ("Indirect Cost %" = 0) AND ("Overhead Rate" = 0)))
            THEN
                EXIT("Unit Cost (ACY)");
            IF ("Value Entry Type" = "Value Entry Type"::Revaluation) AND ItemLedgerEntry.GET("Applies-to Entry") THEN
                PostingDate := ItemLedgerEntry."Posting Date"
            ELSE
                PostingDate := "Posting Date";
            EXIT(ROUND(CurrExchRate.ExchangeAmtLCYToFCY(
                  PostingDate, GLSetup."Additional Reporting Currency",
                  CostPerUnit, CurrExchRate.ExchangeRate(
                    PostingDate, GLSetup."Additional Reporting Currency")),
                Currency."Unit-Amount Rounding Precision"));
        END;
    END;

    LOCAL PROCEDURE CalcCostPerUnit(Cost: Decimal; Quantity: Decimal; IsACY: Boolean): Decimal;
    VAR
        RndgPrec: Decimal;
    BEGIN
        GetGLSetup;

        IF IsACY THEN
            RndgPrec := Currency."Unit-Amount Rounding Precision"
        ELSE
            RndgPrec := GLSetup."Unit-Amount Rounding Precision";

        IF Quantity <> 0 THEN
            EXIT(ROUND(Cost / Quantity, RndgPrec));
        EXIT(0);
    END;

    LOCAL PROCEDURE CalcPosShares(VAR DirCost: Decimal; VAR OvhdCost: Decimal; VAR PurchVar: Decimal; VAR DirCostACY: Decimal; VAR OvhdCostACY: Decimal; VAR PurchVarACY: Decimal; VAR CalcUnitCost: Boolean; CalcPurchVar: Boolean; Expected: Boolean);
    VAR
        CostCalcMgt: Codeunit 5836;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF Expected THEN BEGIN
                DirCost := "Unit Cost" * Quantity;
                PurchVar := 0;
                PurchVarACY := 0;
                OvhdCost := 0;
                OvhdCostACY := 0;
            END ELSE BEGIN
                OvhdCost :=
                  ROUND(
                    CostCalcMgt.CalcOvhdCost(
                      Amount, "Indirect Cost %", "Overhead Rate", "Invoiced Quantity"),
                    GLSetup."Amount Rounding Precision");
                DirCost := Amount;
                IF CalcPurchVar THEN
                    PurchVar := "Unit Cost" * "Invoiced Quantity" - DirCost - OvhdCost
                ELSE BEGIN
                    PurchVar := 0;
                    PurchVarACY := 0;
                END;
            END;

            IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                DirCostACY := ACYMgt.CalcACYAmt(DirCost, "Posting Date", FALSE);
                OvhdCostACY := ACYMgt.CalcACYAmt(OvhdCost, "Posting Date", FALSE);
                "Unit Cost (ACY)" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Posting Date", GLSetup."Additional Reporting Currency", "Unit Cost",
                      CurrExchRate.ExchangeRate(
                        "Posting Date", GLSetup."Additional Reporting Currency")),
                    Currency."Unit-Amount Rounding Precision");
                PurchVarACY := "Unit Cost (ACY)" * "Invoiced Quantity" - DirCostACY - OvhdCostACY;
            END;
            CalcUnitCost := (DirCost <> 0) AND ("Unit Cost" = 0);
        END;

        OnAfterCalcPosShares(
          ItemJnlLine, DirCost, OvhdCost, PurchVar, DirCostACY, OvhdCostACY, PurchVarACY, CalcUnitCost, CalcPurchVar, Expected);
    END;

    LOCAL PROCEDURE CalcPurchCorrShares(VAR OverheadAmount: Decimal; VAR OverheadAmountACY: Decimal; VAR VarianceAmount: Decimal; VAR VarianceAmountACY: Decimal);
    VAR
        OldItemLedgEntry: Record 32;
        OldValueEntry: Record 5802;
        CostAmt: Decimal;
        CostAmtACY: Decimal;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            OldValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            OldValueEntry.SETRANGE("Item Ledger Entry No.", "Applies-to Entry");
            OldValueEntry.SETRANGE("Entry Type", OldValueEntry."Entry Type"::"Indirect Cost");
            IF OldValueEntry.FINDSET THEN
                REPEAT
                    IF NOT OldValueEntry."Partial Revaluation" THEN BEGIN
                        CostAmt := CostAmt + OldValueEntry."Cost Amount (Actual)";
                        CostAmtACY := CostAmtACY + OldValueEntry."Cost Amount (Actual) (ACY)";
                    END;
                UNTIL OldValueEntry.NEXT = 0;
            IF (CostAmt <> 0) OR (CostAmtACY <> 0) THEN BEGIN
                OldItemLedgEntry.GET("Applies-to Entry");
                OverheadAmount := ROUND(
                    CostAmt / OldItemLedgEntry."Invoiced Quantity" * "Invoiced Quantity",
                    GLSetup."Amount Rounding Precision");
                OverheadAmountACY := ROUND(
                    CostAmtACY / OldItemLedgEntry."Invoiced Quantity" * "Invoiced Quantity",
                    Currency."Unit-Amount Rounding Precision");
                IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                    VarianceAmount := -OverheadAmount;
                    VarianceAmountACY := -OverheadAmountACY;
                END ELSE BEGIN
                    VarianceAmount := 0;
                    VarianceAmountACY := 0;
                END;
            END ELSE
                IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                    OldValueEntry.SETRANGE("Entry Type", OldValueEntry."Entry Type"::Variance);
                    VarianceRequired := OldValueEntry.FINDFIRST;
                END;
        END;
    END;

    LOCAL PROCEDURE GetLastDirectCostValEntry(ItemLedgEntryNo: Decimal);
    VAR
        Found: Boolean;
    BEGIN
        IF ItemLedgEntryNo = DirCostValueEntry."Item Ledger Entry No." THEN
            EXIT;
        DirCostValueEntry.RESET;
        DirCostValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
        DirCostValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
        DirCostValueEntry.SETRANGE("Entry Type", DirCostValueEntry."Entry Type"::"Direct Cost");
        DirCostValueEntry.SETFILTER("Item Charge No.", '%1', '');
        Found := DirCostValueEntry.FINDLAST;
        DirCostValueEntry.SETRANGE("Item Charge No.");
        IF NOT Found THEN
            DirCostValueEntry.FINDLAST;
    END;

    LOCAL PROCEDURE IsFirstValueEntry(ItemLedgEntryNo: Integer): Boolean;
    VAR
        ValueEntry: Record 5802;
    BEGIN
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
        EXIT(ValueEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE CalcExpectedCost(VAR InvdValueEntry: Record 5802; ItemLedgEntryNo: Integer; InvoicedQty: Decimal; Quantity: Decimal; VAR ExpectedCost: Decimal; VAR ExpectedCostACY: Decimal; VAR ExpectedSalesAmt: Decimal; VAR ExpectedPurchAmt: Decimal; CalcReminder: Boolean);
    VAR
        ValueEntry: Record 5802;
    BEGIN
        ExpectedCost := 0;
        ExpectedCostACY := 0;
        ExpectedSalesAmt := 0;
        ExpectedPurchAmt := 0;

        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
            SETFILTER("Entry Type", '<>%1', "Entry Type"::Revaluation);
            IF FINDSET AND "Expected Cost" THEN
                IF CalcReminder THEN BEGIN
                    CALCSUMS(
                      "Cost Amount (Expected)", "Cost Amount (Expected) (ACY)",
                      "Sales Amount (Expected)", "Purchase Amount (Expected)");
                    ExpectedCost := -"Cost Amount (Expected)";
                    ExpectedCostACY := -"Cost Amount (Expected) (ACY)";
                    IF NOT CalledFromAdjustment THEN BEGIN
                        ExpectedSalesAmt := -"Sales Amount (Expected)";
                        ExpectedPurchAmt := -"Purchase Amount (Expected)";
                    END
                END ELSE
                    IF InvdValueEntry.Adjustment AND
                       (InvdValueEntry."Entry Type" = InvdValueEntry."Entry Type"::"Direct Cost")
                    THEN BEGIN
                        ExpectedCost := -InvdValueEntry."Cost Amount (Actual)";
                        ExpectedCostACY := -InvdValueEntry."Cost Amount (Actual) (ACY)";
                        IF NOT CalledFromAdjustment THEN BEGIN
                            ExpectedSalesAmt := -InvdValueEntry."Sales Amount (Actual)";
                            ExpectedPurchAmt := -InvdValueEntry."Purchase Amount (Actual)";
                        END
                    END ELSE BEGIN
                        REPEAT
                            IF "Expected Cost" AND NOT Adjustment THEN BEGIN
                                ExpectedCost := ExpectedCost + "Cost Amount (Expected)";
                                ExpectedCostACY := ExpectedCostACY + "Cost Amount (Expected) (ACY)";
                                IF NOT CalledFromAdjustment THEN BEGIN
                                    ExpectedSalesAmt := ExpectedSalesAmt + "Sales Amount (Expected)";
                                    ExpectedPurchAmt := ExpectedPurchAmt + "Purchase Amount (Expected)";
                                END;
                            END;
                        UNTIL NEXT = 0;
                        ExpectedCost :=
                          CalcExpCostToBalance(ExpectedCost, InvoicedQty, Quantity, GLSetup."Amount Rounding Precision");
                        ExpectedCostACY :=
                          CalcExpCostToBalance(ExpectedCostACY, InvoicedQty, Quantity, Currency."Amount Rounding Precision");
                        IF NOT CalledFromAdjustment THEN BEGIN
                            ExpectedSalesAmt :=
                              CalcExpCostToBalance(ExpectedSalesAmt, InvoicedQty, Quantity, GLSetup."Amount Rounding Precision");
                            ExpectedPurchAmt :=
                              CalcExpCostToBalance(ExpectedPurchAmt, InvoicedQty, Quantity, GLSetup."Amount Rounding Precision");
                        END;
                    END;
        END;
    END;

    LOCAL PROCEDURE CalcExpCostToBalance(ExpectedCost: Decimal; InvoicedQty: Decimal; Quantity: Decimal; RoundPrecision: Decimal): Decimal;
    BEGIN
        EXIT(-ROUND(InvoicedQty / Quantity * ExpectedCost, RoundPrecision));
    END;

    LOCAL PROCEDURE MoveValEntryDimToValEntryDim(VAR ToValueEntry: Record 5802; FromValueEntry: Record 5802);
    BEGIN
        ToValueEntry."Global Dimension 1 Code" := FromValueEntry."Global Dimension 1 Code";
        ToValueEntry."Global Dimension 2 Code" := FromValueEntry."Global Dimension 2 Code";
        ToValueEntry."Dimension Set ID" := FromValueEntry."Dimension Set ID";
    END;

    LOCAL PROCEDURE AutoTrack(VAR ItemLedgEntryRec: Record 32; IsReserved: Boolean);
    VAR
        ReservMgt: Codeunit 99000845;
        ReservMgt1: Codeunit 51372;
    BEGIN
        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN BEGIN
            IF NOT IsReserved THEN
                EXIT;

            // Ensure that Item Tracking is not left on the item ledger entry:
            ReservMgt1.SetItemLedgEntry(ItemLedgEntryRec);
            ReservMgt.SetItemTrackingHandling(1);
            ReservMgt.ClearSurplus;
            EXIT;
        END;

        ReservMgt1.SetItemLedgEntry(ItemLedgEntryRec);
        ReservMgt.SetItemTrackingHandling(1);
        ReservMgt.DeleteReservEntries(FALSE, ItemLedgEntryRec."Remaining Quantity");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack(ItemLedgEntryRec."Remaining Quantity");
    END;



    LOCAL PROCEDURE SetupSplitJnlLine(VAR ItemJnlLine2: Record 83; TrackingSpecExists: Boolean): Boolean;
    VAR
        LateBindingMgt: Codeunit 6502;
        UOMMgt: Codeunit 5402;
        NonDistrQuantity: Decimal;
        NonDistrAmount: Decimal;
        NonDistrAmountACY: Decimal;
        NonDistrDiscountAmount: Decimal;
        SignFactor: Integer;
        CalcWarrantyDate: Date;
        CalcExpirationDate: Date;
        Invoice: Boolean;
        SNInfoRequired: Boolean;
        LotInfoRequired: Boolean;
        ExpirationDateChecked: Boolean;
        PostItemJnlLine: Boolean;
    BEGIN
        ItemJnlLineOrigin := ItemJnlLine2;
        TempSplitItemJnlLine.RESET;
        TempSplitItemJnlLine.DELETEALL;

        DisableItemTracking := NOT ItemJnlLine2.ItemPosting;
        Invoice := ItemJnlLine2."Invoiced Qty. (Base)" <> 0;

        IF (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer) AND
           PostponeReservationHandling
        THEN
            SignFactor := 1
        ELSE
            SignFactor := ItemJnlLine2.Signed(1);

        ItemTrackingCode.Code := Item."Item Tracking Code";
        ItemTrackingMgt1.GetItemTrackingSettings(
          ItemTrackingCode, ItemJnlLine."Entry Type", ItemJnlLine.Signed(ItemJnlLine."Quantity (Base)") > 0,
          SNRequired, LotRequired, SNInfoRequired, LotInfoRequired);

        IF Item."Costing Method" = Item."Costing Method"::Specific THEN BEGIN
            Item.TESTFIELD("Item Tracking Code");
            ItemTrackingCode.TESTFIELD("SN Specific Tracking", TRUE);
        END;

        OnBeforeSetupSplitJnlLine(ItemJnlLine2, TrackingSpecExists);

        IF NOT ItemJnlLine2.Correction AND (ItemJnlLine2."Quantity (Base)" <> 0) AND TrackingSpecExists THEN BEGIN
            IF DisableItemTracking THEN BEGIN
                IF NOT TempTrackingSpecification.ISEMPTY THEN
                    ERROR(Text021, ItemJnlLine2.FIELDCAPTION("Operation No."), ItemJnlLine2."Operation No.");
            END ELSE BEGIN
                IF TempTrackingSpecification.ISEMPTY THEN
                    ERROR(Text100);

                ItemJnlLine2.TESTFIELD("Serial No.", '');
                ItemJnlLine2.TESTFIELD("Lot No.", '');
                ItemJnlLine2.TESTFIELD("New Serial No.", '');
                ItemJnlLine2.TESTFIELD("New Lot No.", '');

                IF FORMAT(ItemTrackingCode."Warranty Date Formula") <> '' THEN
                    CalcWarrantyDate := CALCDATE(ItemTrackingCode."Warranty Date Formula", ItemJnlLine2."Document Date");
                IF FORMAT(Item."Expiration Calculation") <> '' THEN
                    CalcExpirationDate := CALCDATE(Item."Expiration Calculation", ItemJnlLine2."Document Date");

                IF SignFactor * ItemJnlLine2.Quantity < 0 THEN // Demand
                    IF ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking" THEN
                        LateBindingMgt.ReallocateTrkgSpecification(TempTrackingSpecification);

                TempTrackingSpecification.CALCSUMS(
                  "Qty. to Handle (Base)", "Qty. to Invoice (Base)", "Qty. to Handle", "Qty. to Invoice");
                TempTrackingSpecification.TestFieldError(TempTrackingSpecification.FIELDCAPTION("Qty. to Handle (Base)"),
                  TempTrackingSpecification."Qty. to Handle (Base)", SignFactor * ItemJnlLine2."Quantity (Base)");

                IF Invoice THEN
                    TempTrackingSpecification.TestFieldError(TempTrackingSpecification.FIELDCAPTION("Qty. to Invoice (Base)"),
                      TempTrackingSpecification."Qty. to Invoice (Base)", SignFactor * ItemJnlLine2."Invoiced Qty. (Base)");

                NonDistrQuantity :=
                  UOMMgt.CalcQtyFromBase(
                    UOMMgt.RoundQty(
                      UOMMgt.CalcBaseQty(ItemJnlLine2.Quantity, ItemJnlLine2."Qty. per Unit of Measure")),
                    ItemJnlLine2."Qty. per Unit of Measure");
                NonDistrAmount := ItemJnlLine2.Amount;
                NonDistrAmountACY := ItemJnlLine2."Amount (ACY)";
                NonDistrDiscountAmount := ItemJnlLine2."Discount Amount";

                OnSetupSplitJnlLineOnBeforeSplitTempLines(TempSplitItemJnlLine, TempTrackingSpecification);

                TempTrackingSpecification.FINDSET;
                REPEAT
                    IF ItemTrackingCode."Man. Warranty Date Entry Reqd." THEN
                        TempTrackingSpecification.TESTFIELD("Warranty Date");

                    CheckExpirationDate(ItemJnlLine2, SignFactor, CalcExpirationDate, ExpirationDateChecked);
                    CheckItemTrackingInfo(ItemJnlLine2, TempTrackingSpecification, SNInfoRequired, LotInfoRequired);

                    IF TempTrackingSpecification."Warranty Date" = 0D THEN
                        TempTrackingSpecification."Warranty Date" := CalcWarrantyDate;

                    TempTrackingSpecification.MODIFY;
                    TempSplitItemJnlLine := ItemJnlLine2;
                    PostItemJnlLine :=
                      PostItemJnlLine OR
                      SetupTempSplitItemJnlLine(
                        ItemJnlLine2, SignFactor, NonDistrQuantity, NonDistrAmount,
                        NonDistrAmountACY, NonDistrDiscountAmount, Invoice);
                UNTIL TempTrackingSpecification.NEXT = 0;
            END;
        END ELSE BEGIN
            TempSplitItemJnlLine := ItemJnlLine2;
            TempSplitItemJnlLine.INSERT;
        END;

        EXIT(PostItemJnlLine);
    END;

    LOCAL PROCEDURE SplitJnlLine(VAR ItemJnlLine2: Record 83; PostItemJnlLine: Boolean): Boolean;
    VAR
        FreeEntryNo: Integer;
        JnlLineNo: Integer;
        SignFactor: Integer;
    BEGIN
        IF (ItemJnlLine2."Quantity (Base)" <> 0) AND ItemJnlLine2.TrackingExists THEN BEGIN
            IF (ItemJnlLine2."Entry Type" IN
                [ItemJnlLine2."Entry Type"::Sale,
                 ItemJnlLine2."Entry Type"::"Negative Adjmt.",
                 ItemJnlLine2."Entry Type"::Consumption,
                 ItemJnlLine2."Entry Type"::"Assembly Consumption"]) OR
               ((ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer) AND
                NOT PostponeReservationHandling)
            THEN
                SignFactor := -1
            ELSE
                SignFactor := 1;

            TempTrackingSpecification.SETRANGE("Serial No.", ItemJnlLine2."Serial No.");
            TempTrackingSpecification.SETRANGE("Lot No.", ItemJnlLine2."Lot No.");
            IF TempTrackingSpecification.FINDFIRST THEN BEGIN
                FreeEntryNo := TempTrackingSpecification."Entry No.";
                TempTrackingSpecification.DELETE;
                ItemJnlLine2.TESTFIELD("Serial No.", TempTrackingSpecification."Serial No.");
                ItemJnlLine2.TESTFIELD("Lot No.", TempTrackingSpecification."Lot No.");
                TempTrackingSpecification."Quantity (Base)" := SignFactor * ItemJnlLine2."Quantity (Base)";
                TempTrackingSpecification."Quantity Handled (Base)" := SignFactor * ItemJnlLine2."Quantity (Base)";
                TempTrackingSpecification."Quantity actual Handled (Base)" := SignFactor * ItemJnlLine2."Quantity (Base)";
                TempTrackingSpecification."Quantity Invoiced (Base)" := SignFactor * ItemJnlLine2."Invoiced Qty. (Base)";
                TempTrackingSpecification."Qty. to Invoice (Base)" :=
                  SignFactor * (ItemJnlLine2."Quantity (Base)" - ItemJnlLine2."Invoiced Qty. (Base)");
                TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                TempTrackingSpecification."Qty. to Handle" := 0;
                TempTrackingSpecification."Qty. to Invoice" :=
                  SignFactor * (ItemJnlLine2.Quantity - ItemJnlLine2."Invoiced Quantity");
                TempTrackingSpecification."Item Ledger Entry No." := GlobalItemLedgEntry."Entry No.";
                TempTrackingSpecification."Transfer Item Entry No." := TempItemEntryRelation."Item Entry No.";
                IF PostItemJnlLine THEN
                    TempTrackingSpecification."Entry No." := TempTrackingSpecification."Item Ledger Entry No.";
                InsertTempTrkgSpecification(FreeEntryNo);
            END ELSE
                IF (ItemJnlLine2."Item Charge No." = '') AND (ItemJnlLine2."Job No." = '') THEN
                    IF NOT ItemJnlLine2.Correction THEN // Undo quantity posting.
                        ERROR(Text011);
        END;

        IF TempSplitItemJnlLine.FINDFIRST THEN BEGIN
            JnlLineNo := ItemJnlLine2."Line No.";
            ItemJnlLine2 := TempSplitItemJnlLine;
            ItemJnlLine2."Line No." := JnlLineNo;
            TempSplitItemJnlLine.DELETE;
            EXIT(TRUE);
        END;
        IF ItemJnlLine."Phys. Inventory" THEN
            InsertPhysInventoryEntry;
        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE CollectTrackingSpecification(VAR TargetTrackingSpecification: Record 336 TEMPORARY): Boolean;
    BEGIN
        TempTrackingSpecification.RESET;
        TargetTrackingSpecification.RESET;
        TargetTrackingSpecification.DELETEALL;

        IF TempTrackingSpecification.FINDSET THEN
            REPEAT
                TargetTrackingSpecification := TempTrackingSpecification;
                TargetTrackingSpecification.INSERT;
            UNTIL TempTrackingSpecification.NEXT = 0
        ELSE
            EXIT(FALSE);

        TempTrackingSpecification.DELETEALL;

        EXIT(TRUE);
    END;


    LOCAL PROCEDURE CheckExpirationDate(VAR ItemJnlLine2: Record 83; SignFactor: Integer; CalcExpirationDate: Date; VAR ExpirationDateChecked: Boolean);
    VAR
        ExistingExpirationDate: Date;
        EntriesExist: Boolean;
        SumOfEntries: Decimal;
        SumLot: Decimal;
    BEGIN
        // ExistingExpirationDate :=
        //   ItemTrackingMgt.ExistingExpirationDate(
        //     TempTrackingSpecification."Item No.",
        //     TempTrackingSpecification."Variant Code",
        //     TempTrackingSpecification."Lot No.",
        //     TempTrackingSpecification."Serial No.",
        //     TRUE,
        //     EntriesExist);

        ExistingExpirationDate :=
         ItemTrackingMgt.ExistingExpirationDate(TempTrackingSpecification, true, EntriesExist);

        IF NOT (EntriesExist OR ExpirationDateChecked) THEN BEGIN
            ItemTrackingMgt.TestExpDateOnTrackingSpec(TempTrackingSpecification);
            ExpirationDateChecked := TRUE;
        END;
        IF ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer THEN
            IF TempTrackingSpecification."Expiration Date" = 0D THEN
                TempTrackingSpecification."Expiration Date" := ExistingExpirationDate;

        // Supply
        IF SignFactor * ItemJnlLine2.Quantity > 0 THEN BEGIN        // Only expiration dates on supply.
            IF NOT (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer) THEN
                IF ItemTrackingCode."Man. Expir. Date Entry Reqd." THEN
                    IF NOT TempTrackingSpecification.Correction THEN
                        TempTrackingSpecification.TESTFIELD("Expiration Date");

            IF CalcExpirationDate <> 0D THEN
                IF ExistingExpirationDate <> 0D THEN
                    CalcExpirationDate := ExistingExpirationDate;

            IF ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer THEN
                IF TempTrackingSpecification."New Expiration Date" = 0D THEN
                    TempTrackingSpecification."New Expiration Date" := ExistingExpirationDate;

            IF TempTrackingSpecification."Expiration Date" = 0D THEN
                TempTrackingSpecification."Expiration Date" := CalcExpirationDate;

            IF EntriesExist THEN
                TempTrackingSpecification.TESTFIELD("Expiration Date", ExistingExpirationDate);
        END ELSE   // Demand
            IF ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer THEN BEGIN
                ExistingExpirationDate :=
                  ItemTrackingMgt1.ExistingExpirationDateAndQty(
                    TempTrackingSpecification."Item No.",
                    TempTrackingSpecification."Variant Code",
                    TempTrackingSpecification."New Lot No.",
                    TempTrackingSpecification."New Serial No.",
                    SumOfEntries);

                IF (ItemJnlLine2."Order Type" = ItemJnlLine2."Order Type"::Transfer) AND
                   (ItemJnlLine2."Order No." <> '')
                THEN
                    IF TempTrackingSpecification."New Expiration Date" = 0D THEN
                        TempTrackingSpecification."New Expiration Date" := ExistingExpirationDate;

                IF (TempTrackingSpecification."New Lot No." <> '') AND
                   ((ItemJnlLine2."Order Type" <> ItemJnlLine2."Order Type"::Transfer) OR
                    (ItemJnlLine2."Order No." = ''))
                THEN BEGIN
                    IF TempTrackingSpecification."New Serial No." <> '' THEN
                        SumLot := SignFactor * ItemTrackingMgt.SumNewLotOnTrackingSpec(TempTrackingSpecification)
                    ELSE
                        SumLot := SignFactor * TempTrackingSpecification."Quantity (Base)";
                    IF (SumOfEntries > 0) AND
                       ((SumOfEntries <> SumLot) OR (TempTrackingSpecification."New Lot No." <> TempTrackingSpecification."Lot No."))
                    THEN
                        TempTrackingSpecification.TESTFIELD("New Expiration Date", ExistingExpirationDate);
                    ItemTrackingMgt.TestExpDateOnTrackingSpecNew(TempTrackingSpecification);
                END;
            END;

        IF (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer) AND
           ((ItemJnlLine2."Order Type" <> ItemJnlLine2."Order Type"::Transfer) OR
            (ItemJnlLine2."Order No." = ''))
        THEN
            IF ItemTrackingCode."Man. Expir. Date Entry Reqd." THEN
                TempTrackingSpecification.TESTFIELD("New Expiration Date");
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                Currency.GET(GLSetup."Additional Reporting Currency");
                Currency.TESTFIELD("Unit-Amount Rounding Precision");
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
        END;
        GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetMfgSetup();
    BEGIN
        IF NOT MfgSetupRead THEN
            MfgSetup.GET;
        MfgSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetInvtSetup();
    BEGIN
        IF NOT InvtSetupRead THEN BEGIN
            InvtSetup.GET;
            SourceCodeSetup.GET;
        END;
        InvtSetupRead := TRUE;
    END;

    LOCAL PROCEDURE UndoQuantityPosting();
    VAR
        OldItemLedgEntry: Record 32;
        OldItemLedgEntry2: Record 32;
        NewItemLedgEntry: Record 32;
        OldValueEntry: Record 5802;
        NewValueEntry: Record 5802;
        AvgCostAdjmtEntryPoint: Record 5804;
        IsReserved: Boolean;
    BEGIN
        IF ItemJnlLine."Entry Type" IN [ItemJnlLine."Entry Type"::"Assembly Consumption",
                                        ItemJnlLine."Entry Type"::"Assembly Output"]
        THEN
            EXIT;

        IF ItemJnlLine."Applies-to Entry" <> 0 THEN BEGIN
            OldItemLedgEntry.GET(ItemJnlLine."Applies-to Entry");
            IF NOT OldItemLedgEntry.Positive THEN
                ItemJnlLine."Applies-from Entry" := ItemJnlLine."Applies-to Entry";
        END ELSE
            OldItemLedgEntry.GET(ItemJnlLine."Applies-from Entry");

        IF Item.GET(OldItemLedgEntry."Item No.") THEN BEGIN
            Item.TESTFIELD(Blocked, FALSE);
            Item.CheckBlockedByApplWorksheet;
        END;

        ItemJnlLine."Item No." := OldItemLedgEntry."Item No.";

        InitCorrItemLedgEntry(OldItemLedgEntry, NewItemLedgEntry);

        IF Item.IsNonInventoriableType THEN BEGIN
            NewItemLedgEntry."Remaining Quantity" := 0;
            NewItemLedgEntry.Open := FALSE;
        END;

        InsertItemReg(NewItemLedgEntry."Entry No.", 0, 0, 0);
        GlobalItemLedgEntry := NewItemLedgEntry;

        CalcILEExpectedAmount(OldValueEntry, OldItemLedgEntry."Entry No.");
        IF OldValueEntry.Inventoriable THEN
            AvgCostAdjmtEntryPoint.UpdateValuationDate(OldValueEntry);
        IF OldItemLedgEntry."Invoiced Quantity" = 0 THEN BEGIN
            InsertCorrValueEntry(
              OldValueEntry, NewValueEntry, OldItemLedgEntry, OldValueEntry."Document Line No.", 1,
              0, OldItemLedgEntry.Quantity);
            InsertCorrValueEntry(
              OldValueEntry, NewValueEntry, NewItemLedgEntry, ItemJnlLine."Document Line No.", -1,
              NewItemLedgEntry.Quantity, 0);
            InsertCorrValueEntry(
              OldValueEntry, NewValueEntry, NewItemLedgEntry, ItemJnlLine."Document Line No.", -1,
              0, NewItemLedgEntry.Quantity);
        END ELSE
            InsertCorrValueEntry(
              OldValueEntry, NewValueEntry, NewItemLedgEntry, ItemJnlLine."Document Line No.", -1,
              NewItemLedgEntry.Quantity, NewItemLedgEntry.Quantity);

        UpdateOldItemLedgEntry(OldItemLedgEntry, NewItemLedgEntry."Posting Date");
        UpdateItemApplnEntry(OldItemLedgEntry."Entry No.", NewItemLedgEntry."Posting Date");

        IF GlobalItemLedgEntry.Quantity > 0 THEN
            IsReserved :=
              ReserveItemJnlLine.TransferItemJnlToItemLedgEntry(
                ItemJnlLine, GlobalItemLedgEntry, ItemJnlLine."Quantity (Base)", TRUE);

        IF NOT ItemJnlLine.IsATOCorrection THEN BEGIN
            ApplyItemLedgEntry(NewItemLedgEntry, OldItemLedgEntry2, NewValueEntry, FALSE);
            AutoTrack(NewItemLedgEntry, IsReserved);
        END;

        NewItemLedgEntry.MODIFY;
        UpdateAdjmtProp(NewValueEntry, NewItemLedgEntry."Posting Date");

        IF NewItemLedgEntry.Positive THEN BEGIN
            UpdateOrigAppliedFromEntry(OldItemLedgEntry."Entry No.");
            InsertApplEntry(
              NewItemLedgEntry."Entry No.", NewItemLedgEntry."Entry No.",
              OldItemLedgEntry."Entry No.", 0, NewItemLedgEntry."Posting Date",
              -OldItemLedgEntry.Quantity, FALSE);
        END;
    END;


    LOCAL PROCEDURE InitCorrItemLedgEntry(VAR OldItemLedgEntry: Record 32; VAR NewItemLedgEntry: Record 32);
    VAR
        EntriesExist: Boolean;
    BEGIN
        IF ItemLedgEntryNo = 0 THEN
            ItemLedgEntryNo := GlobalItemLedgEntry."Entry No.";

        ItemLedgEntryNo := ItemLedgEntryNo + 1;
        NewItemLedgEntry := OldItemLedgEntry;
        ItemTrackingMgt.RetrieveAppliedExpirationDate(NewItemLedgEntry);
        NewItemLedgEntry."Entry No." := ItemLedgEntryNo;
        NewItemLedgEntry.Quantity := -OldItemLedgEntry.Quantity;
        NewItemLedgEntry."Remaining Quantity" := -OldItemLedgEntry.Quantity;
        IF NewItemLedgEntry.Quantity > 0 THEN
            NewItemLedgEntry."Shipped Qty. Not Returned" := 0
        ELSE
            NewItemLedgEntry."Shipped Qty. Not Returned" := NewItemLedgEntry.Quantity;
        NewItemLedgEntry."Invoiced Quantity" := NewItemLedgEntry.Quantity;
        NewItemLedgEntry.Positive := NewItemLedgEntry."Remaining Quantity" > 0;
        NewItemLedgEntry.Open := NewItemLedgEntry."Remaining Quantity" <> 0;
        NewItemLedgEntry."Completely Invoiced" := TRUE;
        NewItemLedgEntry."Last Invoice Date" := NewItemLedgEntry."Posting Date";
        NewItemLedgEntry.Correction := TRUE;
        NewItemLedgEntry."Document Line No." := ItemJnlLine."Document Line No.";
        IF OldItemLedgEntry.Positive THEN
            NewItemLedgEntry."Applies-to Entry" := OldItemLedgEntry."Entry No."
        ELSE
            NewItemLedgEntry."Applies-to Entry" := 0;

        OnBeforeInsertCorrItemLedgEntry(NewItemLedgEntry, OldItemLedgEntry, ItemJnlLine);
        NewItemLedgEntry.INSERT;
        OnAfterInsertCorrItemLedgEntry(NewItemLedgEntry, ItemJnlLine, OldItemLedgEntry);

        IF NewItemLedgEntry."Item Tracking" <> NewItemLedgEntry."Item Tracking"::None THEN
            // ItemTrackingMgt.ExistingExpirationDate(
            //   NewItemLedgEntry."Item No.",
            //   NewItemLedgEntry."Variant Code",
            //   NewItemLedgEntry."Lot No.",
            //   NewItemLedgEntry."Serial No.",
            //   TRUE,
            //   EntriesExist);

            ItemTrackingMgt.ExistingExpirationDate(NewItemLedgEntry, true, EntriesExist);
    END;

    LOCAL PROCEDURE UpdateOldItemLedgEntry(VAR OldItemLedgEntry: Record 32; LastInvoiceDate: Date);
    BEGIN
        OldItemLedgEntry."Completely Invoiced" := TRUE;
        OldItemLedgEntry."Last Invoice Date" := LastInvoiceDate;
        OldItemLedgEntry."Invoiced Quantity" := OldItemLedgEntry.Quantity;
        OldItemLedgEntry."Shipped Qty. Not Returned" := 0;
        OldItemLedgEntry.MODIFY;
    END;

    LOCAL PROCEDURE InsertCorrValueEntry(OldValueEntry: Record 5802; VAR NewValueEntry: Record 5802; ItemLedgEntry: Record 32; DocumentLineNo: Integer; Sign: Integer; QtyToShip: Decimal; QtyToInvoice: Decimal);
    BEGIN
        ValueEntryNo := ValueEntryNo + 1;

        NewValueEntry := OldValueEntry;
        NewValueEntry."Entry No." := ValueEntryNo;
        NewValueEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        NewValueEntry."User ID" := USERID;
        NewValueEntry."Valued Quantity" := Sign * OldValueEntry."Valued Quantity";
        NewValueEntry."Document Line No." := DocumentLineNo;
        NewValueEntry."Item Ledger Entry Quantity" := QtyToShip;
        NewValueEntry."Invoiced Quantity" := QtyToInvoice;
        NewValueEntry."Expected Cost" := QtyToInvoice = 0;
        IF NOT NewValueEntry."Expected Cost" THEN BEGIN
            NewValueEntry."Cost Amount (Expected)" := -Sign * OldValueEntry."Cost Amount (Expected)";
            NewValueEntry."Cost Amount (Expected) (ACY)" := -Sign * OldValueEntry."Cost Amount (Expected) (ACY)";
            IF QtyToShip = 0 THEN BEGIN
                NewValueEntry."Cost Amount (Actual)" := Sign * OldValueEntry."Cost Amount (Expected)";
                NewValueEntry."Cost Amount (Actual) (ACY)" := Sign * OldValueEntry."Cost Amount (Expected) (ACY)";
            END ELSE BEGIN
                NewValueEntry."Cost Amount (Actual)" := -NewValueEntry."Cost Amount (Actual)";
                NewValueEntry."Cost Amount (Actual) (ACY)" := -NewValueEntry."Cost Amount (Actual) (ACY)";
            END;
            NewValueEntry."Purchase Amount (Expected)" := -Sign * OldValueEntry."Purchase Amount (Expected)";
            NewValueEntry."Sales Amount (Expected)" := -Sign * OldValueEntry."Sales Amount (Expected)";
        END ELSE BEGIN
            NewValueEntry."Cost Amount (Expected)" := -OldValueEntry."Cost Amount (Expected)";
            NewValueEntry."Cost Amount (Expected) (ACY)" := -OldValueEntry."Cost Amount (Expected) (ACY)";
            NewValueEntry."Cost Amount (Actual)" := 0;
            NewValueEntry."Cost Amount (Actual) (ACY)" := 0;
            NewValueEntry."Sales Amount (Expected)" := -OldValueEntry."Sales Amount (Expected)";
            NewValueEntry."Purchase Amount (Expected)" := -OldValueEntry."Purchase Amount (Expected)";
        END;

        NewValueEntry."Purchase Amount (Actual)" := 0;
        NewValueEntry."Sales Amount (Actual)" := 0;
        NewValueEntry."Cost Amount (Non-Invtbl.)" := Sign * OldValueEntry."Cost Amount (Non-Invtbl.)";
        NewValueEntry."Cost Amount (Non-Invtbl.)(ACY)" := Sign * OldValueEntry."Cost Amount (Non-Invtbl.)(ACY)";
        NewValueEntry."Cost Posted to G/L" := 0;
        NewValueEntry."Cost Posted to G/L (ACY)" := 0;
        NewValueEntry."Expected Cost Posted to G/L" := 0;
        NewValueEntry."Exp. Cost Posted to G/L (ACY)" := 0;

        OnBeforeInsertCorrValueEntry(NewValueEntry, OldValueEntry, ItemJnlLine);

        IF NewValueEntry.Inventoriable AND NOT Item."Inventory Value Zero" THEN
            PostInventoryToGL(NewValueEntry);

        NewValueEntry.INSERT;

        OnAfterInsertCorrValueEntry(NewValueEntry, ItemJnlLine);

        ItemApplnEntry.SetOutboundsNotUpdated(ItemLedgEntry);

        UpdateAdjmtProp(NewValueEntry, ItemLedgEntry."Posting Date");

        InsertItemReg(0, 0, NewValueEntry."Entry No.", 0);
        InsertPostValueEntryToGL(NewValueEntry);
    END;

    LOCAL PROCEDURE UpdateOrigAppliedFromEntry(OldItemLedgEntryNo: Integer);
    VAR
        ItemApplEntry: Record 339;
        ItemLedgEntry: Record 32;
    BEGIN
        ItemApplEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.");
        ItemApplEntry.SETRANGE("Outbound Item Entry No.", OldItemLedgEntryNo);
        ItemApplEntry.SETFILTER("Item Ledger Entry No.", '<>%1', OldItemLedgEntryNo);
        IF ItemApplEntry.FINDSET THEN
            REPEAT
                IF ItemLedgEntry.GET(ItemApplEntry."Inbound Item Entry No.") AND
                   NOT ItemLedgEntry."Applied Entry to Adjust"
                THEN BEGIN
                    ItemLedgEntry."Applied Entry to Adjust" := TRUE;
                    ItemLedgEntry.MODIFY;
                END;
            UNTIL ItemApplEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE GetLocation(LocationCode: Code[10]);
    BEGIN
        IF LocationCode = '' THEN
            CLEAR(Location)
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE CheckItem(ItemNo: Code[20]);
    BEGIN
        IF Item.GET(ItemNo) THEN BEGIN
            IF NOT CalledFromAdjustment THEN
                Item.TESTFIELD(Blocked, FALSE);
        END ELSE
            Item.INIT;
    END;

    //[External]
    PROCEDURE CheckItemTracking();
    BEGIN
        IF SNRequired AND (ItemJnlLine."Serial No." = '') THEN
            ERROR(GetTextStringWithLineNo(SerialNoRequiredErr, ItemJnlLine."Item No.", ItemJnlLine."Line No."));
        IF LotRequired AND (ItemJnlLine."Lot No." = '') THEN
            ERROR(GetTextStringWithLineNo(LotNoRequiredErr, ItemJnlLine."Item No.", ItemJnlLine."Line No."));
        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer THEN BEGIN
            IF SNRequired THEN
                ItemJnlLine.TESTFIELD("New Serial No.");
            IF LotRequired THEN
                ItemJnlLine.TESTFIELD("New Lot No.");
        END;

        OnAfterCheckItemTracking(ItemJnlLine);
    END;

    LOCAL PROCEDURE CheckItemTrackingInfo(VAR ItemJnlLine2: Record 83; VAR TrackingSpecification: Record 336; SNInfoRequired: Boolean; LotInfoRequired: Boolean);
    VAR
        SerialNoInfo: Record 6504;
        LotNoInfo: Record 6505;
    BEGIN
        OnBeforeCheckItemTrackingInfo(ItemJnlLine2, TrackingSpecification, SNInfoRequired, LotInfoRequired);

        IF SNInfoRequired THEN BEGIN
            SerialNoInfo.GET(
              ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Serial No.");
            SerialNoInfo.TESTFIELD(Blocked, FALSE);
            IF TrackingSpecification."New Serial No." <> '' THEN BEGIN
                SerialNoInfo.GET(
                  ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Serial No.");
                SerialNoInfo.TESTFIELD(Blocked, FALSE);
            END;
        END ELSE BEGIN
            IF SerialNoInfo.GET(
                 ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Serial No.")
            THEN
                SerialNoInfo.TESTFIELD(Blocked, FALSE);
            IF TrackingSpecification."New Serial No." <> '' THEN BEGIN
                IF SerialNoInfo.GET(
                     ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Serial No.")
                THEN
                    SerialNoInfo.TESTFIELD(Blocked, FALSE);
            END;
        END;

        IF LotInfoRequired THEN BEGIN
            LotNoInfo.GET(
              ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.");
            LotNoInfo.TESTFIELD(Blocked, FALSE);
            IF TrackingSpecification."New Lot No." <> '' THEN BEGIN
                LotNoInfo.GET(
                  ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.");
                LotNoInfo.TESTFIELD(Blocked, FALSE);
            END;
        END ELSE BEGIN
            IF LotNoInfo.GET(
                 ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.")
            THEN
                LotNoInfo.TESTFIELD(Blocked, FALSE);
            IF TrackingSpecification."New Lot No." <> '' THEN BEGIN
                IF LotNoInfo.GET(
                     ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.")
                THEN
                    LotNoInfo.TESTFIELD(Blocked, FALSE);
            END;
        END;

        OnAfterCheckItemTrackingInfo(ItemJnlLine2, TrackingSpecification, SNInfoRequired, LotInfoRequired);
    END;

    LOCAL PROCEDURE CheckItemSerialNo(ItemJnlLine: Record 83);
    VAR
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeCheckSerialNo(ItemJnlLine, IsHandled);
        IF IsHandled THEN
            EXIT;

        WITH ItemJnlLine DO
            IF "Entry Type" = "Entry Type"::Transfer THEN BEGIN
                IF ItemTrackingMgt.FindInInventory("Item No.", "Variant Code", "New Serial No.") THEN
                    ERROR(Text014, "New Serial No.")
            END ELSE
                IF ItemTrackingMgt.FindInInventory("Item No.", "Variant Code", "Serial No.") THEN
                    ERROR(Text014, "Serial No.");
    END;

    LOCAL PROCEDURE InsertTempTrkgSpecification(FreeEntryNo: Integer);
    VAR
        TempTrackingSpecification2: Record 336 TEMPORARY;
    BEGIN
        IF NOT TempTrackingSpecification.INSERT THEN BEGIN
            TempTrackingSpecification2 := TempTrackingSpecification;
            TempTrackingSpecification.GET(TempTrackingSpecification2."Item Ledger Entry No.");
            TempTrackingSpecification.DELETE;
            TempTrackingSpecification."Entry No." := FreeEntryNo;
            TempTrackingSpecification.INSERT;
            TempTrackingSpecification := TempTrackingSpecification2;
            TempTrackingSpecification.INSERT;
        END;
    END;

    LOCAL PROCEDURE IsNotInternalWhseMovement(ItemJnlLine: Record 83): Boolean;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            IF ("Entry Type" = "Entry Type"::Transfer) AND
               ("Location Code" = "New Location Code") AND
               ("Dimension Set ID" = "New Dimension Set ID") AND
               ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND
               NOT Adjustment
            THEN
                EXIT(FALSE);
            EXIT(TRUE)
        END;
    END;


    //[External]
    PROCEDURE SetCalledFromAdjustment(NewCalledFromAdjustment: Boolean; NewPostToGL: Boolean);
    BEGIN
        CalledFromAdjustment := NewCalledFromAdjustment;
        PostToGL := NewPostToGL;
    END;

    //[External]
    PROCEDURE NextOperationExist(ProdOrderRtngLine: Record 5409): Boolean;
    BEGIN
        EXIT(ProdOrderRtngLine."Next Operation No." <> '');
    END;

    LOCAL PROCEDURE UpdateAdjmtProp(ValueEntry: Record 5802; OriginalPostingDate: Date);
    BEGIN
        WITH ValueEntry DO
            SetAdjmtProp("Item No.", "Item Ledger Entry Type", Adjustment, //enum to option
              "Order Type", "Order No.", "Order Line No.", OriginalPostingDate, "Valuation Date");//enum to option
    END;

    LOCAL PROCEDURE SetAdjmtProp(ItemNo: Code[20]; ItemLedgEntryType: Enum "Item Ledger Entry Type"; Adjustment: Boolean; OrderType: Enum "Inventory Order Type"; OrderNo: Code[20]; OrderLineNo: Integer; OriginalPostingDate: Date; ValuationDate: Date);
    BEGIN
        SetItemAdjmtProp(ItemNo, ItemLedgEntryType, Adjustment, OriginalPostingDate, ValuationDate);
        SetOrderAdjmtProp(ItemLedgEntryType, OrderType, OrderNo, OrderLineNo, OriginalPostingDate, ValuationDate);
    END;

    LOCAL PROCEDURE SetItemAdjmtProp(ItemNo: Code[20]; ItemLedgEntryType: Enum "Item Ledger Entry Type"; Adjustment: Boolean; OriginalPostingDate: Date; ValuationDate: Date);
    VAR
        Item: Record 27;
        ValueEntry: Record 5802;
        ModifyItem: Boolean;
    BEGIN
        IF ItemLedgEntryType = ValueEntry."Item Ledger Entry Type"::" " THEN
            EXIT;
        IF Adjustment THEN
            IF NOT (ItemLedgEntryType IN [ValueEntry."Item Ledger Entry Type"::Output, //enum to option
                                          ValueEntry."Item Ledger Entry Type"::"Assembly Output"])//enum to option
            THEN
                EXIT;

        WITH Item DO
            IF GET(ItemNo) AND ("Allow Online Adjustment" OR "Cost is Adjusted") AND (Type = Type::Inventory) THEN BEGIN
                LOCKTABLE;
                IF "Cost is Adjusted" THEN BEGIN
                    "Cost is Adjusted" := FALSE;
                    ModifyItem := TRUE;
                END;
                IF "Allow Online Adjustment" THEN BEGIN
                    IF "Costing Method" = "Costing Method"::Average THEN
                        "Allow Online Adjustment" := AllowAdjmtOnPosting(ValuationDate)
                    ELSE
                        "Allow Online Adjustment" := AllowAdjmtOnPosting(OriginalPostingDate);
                    ModifyItem := ModifyItem OR NOT "Allow Online Adjustment";
                END;
                IF ModifyItem THEN
                    MODIFY;
            END;
    END;

    LOCAL PROCEDURE SetOrderAdjmtProp(ItemLedgEntryType: Enum "Item Ledger Entry Type"; OrderType: Enum "Inventory Order Type"; OrderNo: Code[20]; OrderLineNo: Integer; OriginalPostingDate: Date; ValuationDate: Date);
    VAR
        ValueEntry: Record 5802;
        InvtAdjmtEntryOrder: Record 5896;
        ProdOrderLine: Record 5406;
        AssemblyHeader: Record 900;
        ModifyOrderAdjmt: Boolean;
    BEGIN
        IF NOT (OrderType IN [ValueEntry."Order Type"::Production, //enum to option
                              ValueEntry."Order Type"::Assembly])//enum to option
        THEN
            EXIT;

        IF ItemLedgEntryType IN [ValueEntry."Item Ledger Entry Type"::Output, //enum to option
                                 ValueEntry."Item Ledger Entry Type"::"Assembly Output"]//enum to option
        THEN
            EXIT;

        WITH InvtAdjmtEntryOrder DO
            IF GET(OrderType, OrderNo, OrderLineNo) THEN BEGIN
                IF "Allow Online Adjustment" OR "Cost is Adjusted" THEN BEGIN
                    LOCKTABLE;
                    IF "Cost is Adjusted" THEN BEGIN
                        "Cost is Adjusted" := FALSE;
                        ModifyOrderAdjmt := TRUE;
                    END;
                    IF "Allow Online Adjustment" THEN BEGIN
                        "Allow Online Adjustment" := AllowAdjmtOnPosting(OriginalPostingDate);
                        ModifyOrderAdjmt := ModifyOrderAdjmt OR NOT "Allow Online Adjustment";
                    END;
                    IF ModifyOrderAdjmt THEN
                        MODIFY;
                END;
            END ELSE
                CASE OrderType OF
                    "Order Type"::Production: //enum to option
                        BEGIN
                            ProdOrderLine.GET(ProdOrderLine.Status::Released, OrderNo, OrderLineNo);
                            SetProdOrderLine(ProdOrderLine);
                            SetOrderAdjmtProp(ItemLedgEntryType, OrderType, OrderNo, OrderLineNo, OriginalPostingDate, ValuationDate);
                        END;
                    "Order Type"::Assembly: //enum to option
                        BEGIN
                            IF OrderLineNo = 0 THEN BEGIN
                                AssemblyHeader.GET(AssemblyHeader."Document Type"::Order, OrderNo);
                                SetAsmOrder(AssemblyHeader);
                            END;
                            SetOrderAdjmtProp(ItemLedgEntryType, OrderType, OrderNo, 0, OriginalPostingDate, ValuationDate);
                        END;
                END;
    END;

    LOCAL PROCEDURE AllowAdjmtOnPosting(TheDate: Date): Boolean;
    BEGIN
        GetInvtSetup;

        WITH InvtSetup DO
            CASE "Automatic Cost Adjustment" OF
                "Automatic Cost Adjustment"::Never:
                    EXIT(FALSE);
                "Automatic Cost Adjustment"::Day:
                    EXIT(TheDate >= CALCDATE('<-1D>', WORKDATE));
                "Automatic Cost Adjustment"::Week:
                    EXIT(TheDate >= CALCDATE('<-1W>', WORKDATE));
                "Automatic Cost Adjustment"::Month:
                    EXIT(TheDate >= CALCDATE('<-1M>', WORKDATE));
                "Automatic Cost Adjustment"::Quarter:
                    EXIT(TheDate >= CALCDATE('<-1Q>', WORKDATE));
                "Automatic Cost Adjustment"::Year:
                    EXIT(TheDate >= CALCDATE('<-1Y>', WORKDATE));
                ELSE
                    EXIT(TRUE);
            END;
    END;

    LOCAL PROCEDURE InsertBalanceExpCostRevEntry(ValueEntry: Record 5802);
    VAR
        ValueEntry2: Record 5802;
        ValueEntry3: Record 5802;
        RevExpCostToBalance: Decimal;
        RevExpCostToBalanceACY: Decimal;
    BEGIN
        IF GlobalItemLedgEntry.Quantity - (GlobalItemLedgEntry."Invoiced Quantity" - ValueEntry."Invoiced Quantity") = 0 THEN
            EXIT;
        WITH ValueEntry2 DO BEGIN
            SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            SETRANGE("Item Ledger Entry No.", ValueEntry."Item Ledger Entry No.");
            SETRANGE("Entry Type", "Entry Type"::Revaluation);
            SETRANGE("Applies-to Entry", 0);
            IF FINDSET THEN
                REPEAT
                    CalcRevExpCostToBalance(ValueEntry2, ValueEntry."Invoiced Quantity", RevExpCostToBalance, RevExpCostToBalanceACY);
                    IF (RevExpCostToBalance <> 0) OR (RevExpCostToBalanceACY <> 0) THEN BEGIN
                        ValueEntryNo := ValueEntryNo + 1;
                        ValueEntry3 := ValueEntry;
                        ValueEntry3."Entry No." := ValueEntryNo;
                        ValueEntry3."Item Charge No." := '';
                        ValueEntry3."Entry Type" := ValueEntry."Entry Type"::Revaluation;
                        ValueEntry3."Valuation Date" := "Valuation Date";
                        ValueEntry3.Description := '';
                        ValueEntry3."Applies-to Entry" := "Entry No.";
                        ValueEntry3."Cost Amount (Expected)" := RevExpCostToBalance;
                        ValueEntry3."Cost Amount (Expected) (ACY)" := RevExpCostToBalanceACY;
                        ValueEntry3."Valued Quantity" := "Valued Quantity";
                        ValueEntry3."Cost per Unit" := CalcCostPerUnit(RevExpCostToBalance, ValueEntry."Valued Quantity", FALSE);
                        ValueEntry3."Cost per Unit (ACY)" := CalcCostPerUnit(RevExpCostToBalanceACY, ValueEntry."Valued Quantity", TRUE);
                        ValueEntry3."Cost Posted to G/L" := 0;
                        ValueEntry3."Cost Posted to G/L (ACY)" := 0;
                        ValueEntry3."Expected Cost Posted to G/L" := 0;
                        ValueEntry3."Exp. Cost Posted to G/L (ACY)" := 0;
                        ValueEntry3."Invoiced Quantity" := 0;
                        ValueEntry3."Sales Amount (Actual)" := 0;
                        ValueEntry3."Purchase Amount (Actual)" := 0;
                        ValueEntry3."Discount Amount" := 0;
                        ValueEntry3."Cost Amount (Actual)" := 0;
                        ValueEntry3."Cost Amount (Actual) (ACY)" := 0;
                        ValueEntry3."Sales Amount (Expected)" := 0;
                        ValueEntry3."Purchase Amount (Expected)" := 0;
                        InsertValueEntry(ValueEntry3, GlobalItemLedgEntry, FALSE);
                    END;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE IsBalanceExpectedCostFromRev(ItemJnlLine2: Record 83): Boolean;
    BEGIN
        WITH ItemJnlLine2 DO
            EXIT((Item."Costing Method" = Item."Costing Method"::Standard) AND
              (((Quantity = 0) AND ("Invoiced Quantity" <> 0)) OR
               (Adjustment AND NOT GlobalValueEntry."Expected Cost")));
    END;

    LOCAL PROCEDURE CalcRevExpCostToBalance(ValueEntry: Record 5802; InvdQty: Decimal; VAR RevExpCostToBalance: Decimal; VAR RevExpCostToBalanceACY: Decimal);
    VAR
        ValueEntry2: Record 5802;
        OldExpectedQty: Decimal;
    BEGIN
        WITH ValueEntry2 DO BEGIN
            RevExpCostToBalance := -ValueEntry."Cost Amount (Expected)";
            RevExpCostToBalanceACY := -ValueEntry."Cost Amount (Expected) (ACY)";
            OldExpectedQty := GlobalItemLedgEntry.Quantity;
            SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            SETRANGE("Item Ledger Entry No.", ValueEntry."Item Ledger Entry No.");
            IF GlobalItemLedgEntry.Quantity <> GlobalItemLedgEntry."Invoiced Quantity" THEN BEGIN
                SETRANGE("Entry Type", "Entry Type"::"Direct Cost");
                SETFILTER("Entry No.", '<%1', ValueEntry."Entry No.");
                SETRANGE("Item Charge No.", '');
                IF FINDSET THEN
                    REPEAT
                        OldExpectedQty := OldExpectedQty - "Invoiced Quantity";
                    UNTIL NEXT = 0;

                RevExpCostToBalance := ROUND(RevExpCostToBalance * InvdQty / OldExpectedQty, GLSetup."Amount Rounding Precision");
                RevExpCostToBalanceACY := ROUND(RevExpCostToBalanceACY * InvdQty / OldExpectedQty, Currency."Amount Rounding Precision");
            END ELSE BEGIN
                SETRANGE("Entry Type", "Entry Type"::Revaluation);
                SETRANGE("Applies-to Entry", ValueEntry."Entry No.");
                IF FINDSET THEN
                    REPEAT
                        RevExpCostToBalance := RevExpCostToBalance - "Cost Amount (Expected)";
                        RevExpCostToBalanceACY := RevExpCostToBalanceACY - "Cost Amount (Expected) (ACY)";
                    UNTIL NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE IsInterimRevaluation(): Boolean;
    BEGIN
        WITH ItemJnlLine DO
            EXIT(("Value Entry Type" = "Value Entry Type"::Revaluation) AND (Quantity <> 0));
    END;

    LOCAL PROCEDURE InsertPostValueEntryToGL(ValueEntry: Record 5802);
    VAR
        PostValueEntryToGL: Record 5811;
    BEGIN
        IF IsPostToGL(ValueEntry) THEN BEGIN
            PostValueEntryToGL.INIT;
            PostValueEntryToGL."Value Entry No." := ValueEntry."Entry No.";
            PostValueEntryToGL."Item No." := ValueEntry."Item No.";
            PostValueEntryToGL."Posting Date" := ValueEntry."Posting Date";
            PostValueEntryToGL.INSERT;
        END;
    END;

    LOCAL PROCEDURE IsPostToGL(ValueEntry: Record 5802): Boolean;
    BEGIN
        GetInvtSetup;
        WITH ValueEntry DO
            EXIT(
              Inventoriable AND NOT PostToGL AND
              (((NOT "Expected Cost") AND (("Cost Amount (Actual)" <> 0) OR ("Cost Amount (Actual) (ACY)" <> 0))) OR
               (InvtSetup."Expected Cost Posting to G/L" AND (("Cost Amount (Expected)" <> 0) OR ("Cost Amount (Expected) (ACY)" <> 0)))));
    END;

    LOCAL PROCEDURE IsWarehouseReclassification(ItemJournalLine: Record 83): Boolean;
    BEGIN
        EXIT(ItemJournalLine."Warehouse Adjustment" AND (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer));
    END;

    LOCAL PROCEDURE MoveApplication(VAR ItemLedgEntry: Record 32; VAR OldItemLedgEntry: Record 32): Boolean;
    VAR
        Application: Record 339;
        Enough: Boolean;
        FixedApplication: Boolean;
    BEGIN
        WITH ItemLedgEntry DO BEGIN
            FixedApplication := FALSE;
            OldItemLedgEntry.TESTFIELD(Positive, TRUE);

            IF (OldItemLedgEntry."Remaining Quantity" < ABS(Quantity)) AND
               (OldItemLedgEntry."Remaining Quantity" < OldItemLedgEntry.Quantity)
            THEN BEGIN
                Enough := FALSE;
                Application.RESET;
                Application.SETCURRENTKEY("Inbound Item Entry No.");
                Application.SETRANGE("Inbound Item Entry No.", "Applies-to Entry");
                Application.SETFILTER("Outbound Item Entry No.", '<>0');

                IF Application.FINDSET THEN BEGIN
                    REPEAT
                        IF NOT Application.Fixed THEN BEGIN
                            UnApply(Application);
                            OldItemLedgEntry.GET(OldItemLedgEntry."Entry No.");
                            OldItemLedgEntry.CALCFIELDS("Reserved Quantity");
                            Enough :=
                              ABS(OldItemLedgEntry."Remaining Quantity" - OldItemLedgEntry."Reserved Quantity") >=
                              ABS("Remaining Quantity");
                        END ELSE
                            FixedApplication := TRUE;
                    UNTIL (Application.NEXT = 0) OR Enough;
                END ELSE
                    EXIT(FALSE); // no applications found that could be undone
                IF NOT Enough AND FixedApplication THEN
                    ERROR(Text027);
                EXIT(Enough);
            END;
            EXIT(TRUE);
        END;
    END;

    LOCAL PROCEDURE CheckApplication(ItemLedgEntry: Record 32; OldItemLedgEntry: Record 32);
    BEGIN
        IF SkipApplicationCheck THEN BEGIN
            SkipApplicationCheck := FALSE;
            EXIT;
        END;

        IF ABS(OldItemLedgEntry."Remaining Quantity" - OldItemLedgEntry."Reserved Quantity") <
           ABS(ItemLedgEntry."Remaining Quantity" - ItemLedgEntry."Reserved Quantity")
        THEN
            OldItemLedgEntry.FIELDERROR("Remaining Quantity", Text004)
    END;

    LOCAL PROCEDURE CheckApplFromInProduction(VAR GlobalItemLedgerEntry: Record 32; AppliesFRomEntryNo: Integer);
    VAR
        OldItemLedgerEntry: Record 32;
    BEGIN
        IF AppliesFRomEntryNo = 0 THEN
            EXIT;

        WITH GlobalItemLedgerEntry DO
            IF ("Order Type" = "Order Type"::Production) AND ("Order No." <> '') THEN BEGIN
                OldItemLedgerEntry.GET(AppliesFRomEntryNo);
                IF NOT AllowProdApplication(OldItemLedgerEntry, GlobalItemLedgEntry) THEN
                    ERROR(
                      Text022,
                      OldItemLedgerEntry."Entry Type",
                      "Entry Type",
                      "Item No.",
                      "Order No.");

                IF ItemApplnEntry.CheckIsCyclicalLoop(GlobalItemLedgerEntry, OldItemLedgerEntry) THEN
                    ERROR(
                      Text022,
                      OldItemLedgerEntry."Entry Type",
                      "Entry Type",
                      "Item No.",
                      "Order No.");
            END;
    END;

    //[External]
    PROCEDURE RedoApplications();
    VAR
        TouchedItemLedgEntry: Record 32;
        DialogWindow: Dialog;
        Count: Integer;
        t: Integer;
    BEGIN
        TouchedItemLedgerEntries.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        IF TouchedItemLedgerEntries.FIND('-') THEN BEGIN
            DialogWindow.OPEN(Text01 +
              '@@@@@@@@@@@@@@@@@@@@@@@');
            Count := TouchedItemLedgerEntries.COUNT;
            t := 0;

            REPEAT
                t := t + 1;
                DialogWindow.UPDATE(1, ROUND(t * 10000 / Count, 1));
                TouchedItemLedgEntry.GET(TouchedItemLedgerEntries."Entry No.");
                IF TouchedItemLedgEntry."Remaining Quantity" <> 0 THEN BEGIN
                    ReApply(TouchedItemLedgEntry, 0);
                    TouchedItemLedgEntry.GET(TouchedItemLedgerEntries."Entry No.");
                END;
            UNTIL TouchedItemLedgerEntries.NEXT = 0;
            IF AnyTouchedEntries THEN
                VerifyTouchedOnInventory;
            TouchedItemLedgerEntries.DELETEALL;
            DeleteTouchedEntries;
            DialogWindow.CLOSE;
        END;
    END;

    LOCAL PROCEDURE UpdateValuedByAverageCost(CostItemLedgEntryNo: Integer; ValuedByAverage: Boolean);
    VAR
        ValueEntry: Record 5802;
    BEGIN
        IF CostItemLedgEntryNo = 0 THEN
            EXIT;

        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ValueEntry.SETRANGE("Item Ledger Entry No.", CostItemLedgEntryNo);
        ValueEntry.SETRANGE("Valued By Average Cost", NOT ValuedByAverage);
        ValueEntry.MODIFYALL("Valued By Average Cost", ValuedByAverage);
    END;

    //[External]
    PROCEDURE CostAdjust();
    VAR
        InvtSetup: Record 313;
        InventoryPeriod: Record 5814;
        InvtAdjmt: Codeunit 5895;
        Opendate: Date;
    BEGIN
        InvtSetup.GET;
        InventoryPeriod.IsValidDate(Opendate);
        IF InvtSetup."Automatic Cost Adjustment" <>
           InvtSetup."Automatic Cost Adjustment"::Never
        THEN BEGIN
            IF Opendate <> 0D THEN
                Opendate := CALCDATE('<+1D>', Opendate);
            InvtAdjmt.SetProperties(TRUE, InvtSetup."Automatic Cost Posting");
            InvtAdjmt.MakeMultiLevelAdjmt;
        END;
    END;

    LOCAL PROCEDURE TouchEntry(EntryNo: Integer);
    VAR
        TouchedItemLedgEntry: Record 32;
    BEGIN
        TouchedItemLedgEntry.GET(EntryNo);
        TouchedItemLedgerEntries := TouchedItemLedgEntry;
        IF NOT TouchedItemLedgerEntries.INSERT THEN;
    END;

    LOCAL PROCEDURE TouchItemEntryCost(VAR ItemLedgerEntry: Record 32; IsAdjustment: Boolean);
    VAR
        ValueEntry: Record 5802;
        AvgCostAdjmtEntryPoint: Record 5804;
    BEGIN
        ItemLedgerEntry."Applied Entry to Adjust" := TRUE;
        WITH ItemLedgerEntry DO
            SetAdjmtProp("Item No.", "Entry Type", IsAdjustment, //enum to option
              "Order Type", "Order No.", "Order Line No.", //enum to option
              "Posting Date", "Posting Date");

        IF NOT IsAdjustment THEN BEGIN
            EnsureValueEntryLoaded(ValueEntry, ItemLedgerEntry);
            AvgCostAdjmtEntryPoint.UpdateValuationDate(ValueEntry);
        END;
    END;

    //[External]
    PROCEDURE AnyTouchedEntries(): Boolean;
    BEGIN
        EXIT(TouchedItemLedgerEntries.FIND('-'))
    END;

    LOCAL PROCEDURE GetMaxAppliedValuationdate(ItemLedgerEntry: Record 32): Date;
    VAR
        ToItemApplnEntry: Record 339;
        FromItemledgEntryNo: Integer;
        FromInbound: Boolean;
        MaxDate: Date;
        NewDate: Date;
    BEGIN
        FromInbound := ItemLedgerEntry.Positive;
        FromItemledgEntryNo := ItemLedgerEntry."Entry No.";
        WITH ToItemApplnEntry DO BEGIN
            IF FromInbound THEN BEGIN
                SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
                SETRANGE("Inbound Item Entry No.", FromItemledgEntryNo);
                SETFILTER("Outbound Item Entry No.", '<>%1', 0);
                SETFILTER(Quantity, '>%1', 0);
            END ELSE BEGIN
                SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.");
                SETRANGE("Outbound Item Entry No.", FromItemledgEntryNo);
                SETFILTER(Quantity, '<%1', 0);
            END;
            IF FINDSET THEN BEGIN
                MaxDate := 0D;
                REPEAT
                    IF FromInbound THEN
                        ItemLedgerEntry.GET("Outbound Item Entry No.")
                    ELSE
                        ItemLedgerEntry.GET("Inbound Item Entry No.");
                    NewDate := GetMaxValuationDate(ItemLedgerEntry);
                    MaxDate := Max(NewDate, MaxDate);
                UNTIL NEXT = 0
            END;
        END;
        EXIT(MaxDate);
    END;

    LOCAL PROCEDURE Max(Date1: Date; Date2: Date): Date;
    BEGIN
        IF Date1 > Date2 THEN
            EXIT(Date1);
        EXIT(Date2);
    END;

    //[External]
    PROCEDURE SetValuationDateAllValueEntrie(ItemLedgerEntryNo: Integer; ValuationDate: Date; FixedApplication: Boolean);
    VAR
        ValueEntry: Record 5802;
    BEGIN
        WITH ValueEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Item Ledger Entry No.");
            SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
            IF FINDSET THEN
                REPEAT
                    IF ("Valuation Date" <> "Posting Date") OR
                       ("Valuation Date" < ValuationDate) OR
                       (("Valuation Date" > ValuationDate) AND FixedApplication)
                    THEN BEGIN
                        "Valuation Date" := ValuationDate;
                        MODIFY;
                    END;
                UNTIL NEXT = 0;
        END;
    END;


    LOCAL PROCEDURE InsertCountryCode(VAR NewItemLedgEntry: Record 32; ItemLedgEntry: Record 32);
    BEGIN
        IF ItemLedgEntry."Location Code" = '' THEN
            EXIT;
        IF NewItemLedgEntry."Location Code" = '' THEN BEGIN
            Location.GET(ItemLedgEntry."Location Code");
            NewItemLedgEntry."Country/Region Code" := Location."Country/Region Code";
        END ELSE BEGIN
            Location.GET(NewItemLedgEntry."Location Code");
            IF NOT Location."Use As In-Transit" THEN BEGIN
                Location.GET(ItemLedgEntry."Location Code");
                IF NOT Location."Use As In-Transit" THEN
                    NewItemLedgEntry."Country/Region Code" := Location."Country/Region Code";
            END;
        END;
    END;

    LOCAL PROCEDURE ReservationPreventsApplication(ApplicationEntry: Integer; ItemNo: Code[20]; ReservationsEntry: Record 32);
    VAR
        ReservationEntries: Record 337;
        ReservEngineMgt: Codeunit 99000831;
        ReserveItemLedgEntry: Codeunit 99000841;
    BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservationEntries, TRUE);
        ReserveItemLedgEntry.FilterReservFor(ReservationEntries, ReservationsEntry);
        IF ReservationEntries.FINDFIRST THEN;
        ERROR(
          Text029,
          ReservationsEntry.FIELDCAPTION("Applies-to Entry"),
          ApplicationEntry,
          Item.FIELDCAPTION("No."),
          ItemNo,
          ReservEngineMgt.CreateForText(ReservationEntries));
    END;

    LOCAL PROCEDURE CheckItemTrackingOfComp(TempHandlingSpecification: Record 336; ItemJnlLine: Record 83);
    BEGIN
        IF SNRequired THEN
            ItemJnlLine.TESTFIELD("Serial No.", TempHandlingSpecification."Serial No.");
        IF LotRequired THEN
            ItemJnlLine.TESTFIELD("Lot No.", TempHandlingSpecification."Lot No.");
    END;

    LOCAL PROCEDURE MaxConsumptionValuationDate(ItemLedgerEntry: Record 32): Date;
    VAR
        ValueEntry: Record 5802;
        ValuationDate: Date;
    BEGIN
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Order Type", "Order No.");
            SETRANGE("Order Type", "Order Type"::Production);
            SETRANGE("Order No.", ItemLedgerEntry."Order No.");
            SETRANGE("Order Line No.", ItemLedgerEntry."Order Line No.");
            SETRANGE("Item Ledger Entry Type", "Item Ledger Entry Type"::Consumption);
            IF FINDSET THEN
                REPEAT
                    IF ("Valuation Date" > ValuationDate) AND
                       ("Entry Type" <> "Entry Type"::Revaluation)
                    THEN
                        ValuationDate := "Valuation Date";
                UNTIL NEXT = 0;
            EXIT(ValuationDate);
        END;
    END;

    LOCAL PROCEDURE CorrectOutputValuationDate(ItemLedgerEntry: Record 32);
    VAR
        ValueEntry: Record 5802;
        TempValueEntry: Record 5802 TEMPORARY;
        ProductionOrder: Record 5405;
        ValuationDate: Date;
    BEGIN
        IF NOT (ItemLedgerEntry."Entry Type" IN [ItemLedgerEntry."Entry Type"::Consumption, ItemLedgerEntry."Entry Type"::Output]) THEN
            EXIT;

        IF NOT ProductionOrder.GET(ProductionOrder.Status::Released, ItemLedgerEntry."Order No.") THEN
            EXIT;

        ValuationDate := MaxConsumptionValuationDate(ItemLedgerEntry);

        ValueEntry.SETCURRENTKEY("Order Type", "Order No.");
        ValueEntry.SETFILTER("Valuation Date", '<%1', ValuationDate);
        ValueEntry.SETRANGE("Order No.", ItemLedgerEntry."Order No.");
        ValueEntry.SETRANGE("Order Line No.", ItemLedgerEntry."Order Line No.");
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Output);
        IF ValueEntry.FINDSET THEN
            REPEAT
                TempValueEntry := ValueEntry;
                TempValueEntry.INSERT;
            UNTIL ValueEntry.NEXT = 0;

        UpdateOutputEntryAndChain(TempValueEntry, ValuationDate);
    END;

    LOCAL PROCEDURE UpdateOutputEntryAndChain(VAR TempValueEntry: Record 5802 TEMPORARY; ValuationDate: Date);
    VAR
        ValueEntry: Record 5802;
        ItemLedgerEntryNo: Integer;
    BEGIN
        TempValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
        IF TempValueEntry.FIND('-') THEN
            REPEAT
                ValueEntry.GET(TempValueEntry."Entry No.");
                IF ValueEntry."Valuation Date" < ValuationDate THEN BEGIN
                    IF ItemLedgerEntryNo <> TempValueEntry."Item Ledger Entry No." THEN BEGIN
                        ItemLedgerEntryNo := TempValueEntry."Item Ledger Entry No.";
                        UpdateLinkedValuationDate(ValuationDate, ItemLedgerEntryNo, TRUE);
                    END;

                    ValueEntry."Valuation Date" := ValuationDate;
                    ValueEntry.MODIFY;
                    IF ValueEntry."Entry No." = DirCostValueEntry."Entry No." THEN
                        DirCostValueEntry := ValueEntry;
                END;
            UNTIL TempValueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE GetSourceNo(ItemJnlLine: Record 83): Code[20];
    BEGIN
        IF ItemJnlLine."Invoice-to Source No." <> '' THEN
            EXIT(ItemJnlLine."Invoice-to Source No.");
        EXIT(ItemJnlLine."Source No.");
    END;

    LOCAL PROCEDURE PostAssemblyResourceConsump();
    VAR
        CapLedgEntry: Record 5832;
        DirCostAmt: Decimal;
        IndirCostAmt: Decimal;
    BEGIN
        WITH ItemJnlLine DO BEGIN
            InsertCapLedgEntry(CapLedgEntry, Quantity, Quantity);
            CalcDirAndIndirCostAmts(DirCostAmt, IndirCostAmt, Quantity, "Unit Cost", "Indirect Cost %", "Overhead Rate");

            InsertCapValueEntry(CapLedgEntry, "Value Entry Type"::"Direct Cost", Quantity, Quantity, DirCostAmt); //enum to option
            InsertCapValueEntry(CapLedgEntry, "Value Entry Type"::"Indirect Cost", Quantity, 0, IndirCostAmt); //enum to option
        END;
    END;

    LOCAL PROCEDURE InsertAsmItemEntryRelation(ItemLedgerEntry: Record 32);
    BEGIN
        Item.GET(ItemLedgerEntry."Item No.");
        IF Item."Item Tracking Code" <> '' THEN BEGIN
            TempItemEntryRelation."Item Entry No." := ItemLedgerEntry."Entry No.";
            TempItemEntryRelation."Serial No." := ItemLedgerEntry."Serial No.";
            TempItemEntryRelation."Lot No." := ItemLedgerEntry."Lot No.";
            TempItemEntryRelation.INSERT;
        END;
    END;

    LOCAL PROCEDURE VerifyInvoicedQty(ItemLedgerEntry: Record 32);
    VAR
        ItemLedgEntry2: Record 32;
        ItemApplnEntry: Record 339;
        SalesShipmentHeader: Record 110;
        TotalInvoicedQty: Decimal;
    BEGIN
        IF NOT (ItemLedgerEntry."Drop Shipment" AND (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Purchase)) THEN
            EXIT;

        ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.");
        ItemApplnEntry.SETRANGE("Inbound Item Entry No.", ItemLedgerEntry."Entry No.");
        ItemApplnEntry.SETFILTER("Item Ledger Entry No.", '<>%1', ItemLedgerEntry."Entry No.");
        IF ItemApplnEntry.FINDSET THEN BEGIN
            REPEAT
                ItemLedgEntry2.GET(ItemApplnEntry."Item Ledger Entry No.");
                TotalInvoicedQty += ItemLedgEntry2."Invoiced Quantity";
            UNTIL ItemApplnEntry.NEXT = 0;
            IF ItemLedgerEntry."Invoiced Quantity" > ABS(TotalInvoicedQty) THEN BEGIN
                SalesShipmentHeader.GET(ItemLedgEntry2."Document No.");
                IF ItemLedgerEntry."Item Tracking" = ItemLedgerEntry."Item Tracking"::None THEN
                    ERROR(Text032, ItemLedgerEntry."Item No.", SalesShipmentHeader."Order No.");
                ERROR(
                  Text031, ItemLedgerEntry."Item No.", ItemLedgerEntry."Lot No.", ItemLedgerEntry."Serial No.", SalesShipmentHeader."Order No.")
            END;
        END;
    END;

    LOCAL PROCEDURE TransReserveFromJobPlanningLine(FromJobContractEntryNo: Integer; ToItemJnlLine: Record 83);
    VAR
        JobPlanningLine: Record 1003;
    BEGIN
        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        JobPlanningLine.SETRANGE("Job Contract Entry No.", FromJobContractEntryNo);
        JobPlanningLine.FINDFIRST;

        IF JobPlanningLine."Remaining Qty. (Base)" >= ToItemJnlLine."Quantity (Base)" THEN
            JobPlanningLine."Remaining Qty. (Base)" := JobPlanningLine."Remaining Qty. (Base)" - ToItemJnlLine."Quantity (Base)"
        ELSE
            JobPlanningLine."Remaining Qty. (Base)" := 0;
        JobPlanningLineReserve.TransferJobLineToItemJnlLine(JobPlanningLine, ToItemJnlLine, ToItemJnlLine."Quantity (Base)");
    END;

    //[External]
    PROCEDURE SetupTempSplitItemJnlLine(ItemJnlLine2: Record 83; SignFactor: Integer; VAR NonDistrQuantity: Decimal; VAR NonDistrAmount: Decimal; VAR NonDistrAmountACY: Decimal; VAR NonDistrDiscountAmount: Decimal; Invoice: Boolean): Boolean;
    VAR
        FloatingFactor: Decimal;
        PostItemJnlLine: Boolean;
    BEGIN
        WITH TempSplitItemJnlLine DO BEGIN
            "Quantity (Base)" := SignFactor * TempTrackingSpecification."Qty. to Handle (Base)";
            Quantity := SignFactor * TempTrackingSpecification."Qty. to Handle";
            IF Invoice THEN BEGIN
                "Invoiced Quantity" := SignFactor * TempTrackingSpecification."Qty. to Invoice";
                "Invoiced Qty. (Base)" := SignFactor * TempTrackingSpecification."Qty. to Invoice (Base)";
            END;

            IF ItemJnlLine2."Output Quantity" <> 0 THEN BEGIN
                "Output Quantity (Base)" := "Quantity (Base)";
                "Output Quantity" := Quantity;
            END;

            IF ItemJnlLine2."Phys. Inventory" THEN
                "Qty. (Phys. Inventory)" := "Qty. (Calculated)" + SignFactor * "Quantity (Base)";

            OnAfterSetupTempSplitItemJnlLineSetQty(TempSplitItemJnlLine, ItemJnlLine2, SignFactor);

            FloatingFactor := Quantity / NonDistrQuantity;
            IF FloatingFactor < 1 THEN BEGIN
                Amount := ROUND(NonDistrAmount * FloatingFactor, GLSetup."Amount Rounding Precision");
                "Amount (ACY)" := ROUND(NonDistrAmountACY * FloatingFactor, Currency."Amount Rounding Precision");
                "Discount Amount" := ROUND(NonDistrDiscountAmount * FloatingFactor, GLSetup."Amount Rounding Precision");
                NonDistrAmount := NonDistrAmount - Amount;
                NonDistrAmountACY := NonDistrAmountACY - "Amount (ACY)";
                NonDistrDiscountAmount := NonDistrDiscountAmount - "Discount Amount";
                NonDistrQuantity := NonDistrQuantity - Quantity;
                "Setup Time" := 0;
                "Run Time" := 0;
                "Stop Time" := 0;
                "Setup Time (Base)" := 0;
                "Run Time (Base)" := 0;
                "Stop Time (Base)" := 0;
                "Starting Time" := 0T;
                "Ending Time" := 0T;
                "Scrap Quantity" := 0;
                "Scrap Quantity (Base)" := 0;
                "Concurrent Capacity" := 0;
            END ELSE BEGIN // the last record
                Amount := NonDistrAmount;
                "Amount (ACY)" := NonDistrAmountACY;
                "Discount Amount" := NonDistrDiscountAmount;
            END;

            IF ROUND("Unit Amount" * Quantity, GLSetup."Amount Rounding Precision") <> Amount THEN
                IF ("Unit Amount" = "Unit Cost") AND ("Unit Cost" <> 0) THEN BEGIN
                    "Unit Amount" := ROUND(Amount / Quantity, 0.00001);
                    "Unit Cost" := ROUND(Amount / Quantity, 0.00001);
                    "Unit Cost (ACY)" := ROUND("Amount (ACY)" / Quantity, 0.00001);
                END ELSE
                    "Unit Amount" := ROUND(Amount / Quantity, 0.00001);

            "Serial No." := TempTrackingSpecification."Serial No.";
            "Lot No." := TempTrackingSpecification."Lot No.";
            "New Serial No." := TempTrackingSpecification."New Serial No.";
            "New Lot No." := TempTrackingSpecification."New Lot No.";
            "Item Expiration Date" := TempTrackingSpecification."Expiration Date";
            "New Item Expiration Date" := TempTrackingSpecification."New Expiration Date";

            PostItemJnlLine :=
              ("Serial No." <> "New Serial No.") OR
              ("Lot No." <> "New Lot No.") OR
              ("Item Expiration Date" <> "New Item Expiration Date");

            "Warranty Date" := TempTrackingSpecification."Warranty Date";

            "Line No." := TempTrackingSpecification."Entry No.";

            IF TempTrackingSpecification.Correction OR "Drop Shipment" OR IsServUndoConsumption THEN
                "Applies-to Entry" := TempTrackingSpecification."Item Ledger Entry No."
            ELSE
                "Applies-to Entry" := TempTrackingSpecification."Appl.-to Item Entry";
            "Applies-from Entry" := TempTrackingSpecification."Appl.-from Item Entry";

            OnBeforeInsertSetupTempSplitItemJnlLine(TempTrackingSpecification, TempSplitItemJnlLine, PostItemJnlLine);

            INSERT;
        END;

        EXIT(PostItemJnlLine);
    END;

    LOCAL PROCEDURE ReservationExists(ItemJnlLine: Record 83): Boolean;
    VAR
        ReservEntry: Record 337;
        ProductionOrder: Record 5405;
    BEGIN
        WITH ReservEntry DO BEGIN
            SETRANGE("Source ID", ItemJnlLine."Order No.");
            IF ItemJnlLine."Prod. Order Comp. Line No." <> 0 THEN
                SETRANGE("Source Ref. No.", ItemJnlLine."Prod. Order Comp. Line No.");
            SETRANGE("Source Type", DATABASE::"Prod. Order Component");
            SETRANGE("Source Subtype", ProductionOrder.Status::Released);
            SETRANGE("Source Batch Name", '');
            SETRANGE("Source Prod. Order Line", ItemJnlLine."Order Line No.");
            SETFILTER("Qty. to Handle (Base)", '<>0');
            EXIT(NOT ISEMPTY);
        END;
    END;

    LOCAL PROCEDURE VerifyTouchedOnInventory();
    VAR
        ItemLedgEntryApplied: Record 32;
    BEGIN
        WITH TouchedItemLedgerEntries DO BEGIN
            FINDSET;
            REPEAT
                ItemLedgEntryApplied.GET("Entry No.");
                ItemLedgEntryApplied.VerifyOnInventory;
            UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CheckIsCyclicalLoop(ItemLedgEntry: Record 32; OldItemLedgEntry: Record 32; VAR PrevAppliedItemLedgEntry: Record 32; VAR AppliedQty: Decimal);
    VAR
        PrevProcessedProdOrder: Boolean;
    BEGIN
        PrevProcessedProdOrder :=
          (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Consumption) AND
          (OldItemLedgEntry."Entry Type" = OldItemLedgEntry."Entry Type"::Output) AND
          (ItemLedgEntry."Order Type" = ItemLedgEntry."Order Type"::Production) AND
          EntriesInTheSameOrder(OldItemLedgEntry, PrevAppliedItemLedgEntry);

        IF NOT PrevProcessedProdOrder THEN
            IF AppliedQty <> 0 THEN
                IF ItemLedgEntry.Positive THEN BEGIN
                    IF ItemApplnEntry.CheckIsCyclicalLoop(ItemLedgEntry, OldItemLedgEntry) THEN
                        AppliedQty := 0;
                END ELSE
                    IF ItemApplnEntry.CheckIsCyclicalLoop(OldItemLedgEntry, ItemLedgEntry) THEN
                        AppliedQty := 0;

        IF AppliedQty <> 0 THEN
            PrevAppliedItemLedgEntry := OldItemLedgEntry;
    END;

    LOCAL PROCEDURE EntriesInTheSameOrder(OldItemLedgEntry: Record 32; PrevAppliedItemLedgEntry: Record 32): Boolean;
    BEGIN
        EXIT(
          (PrevAppliedItemLedgEntry."Order Type" = PrevAppliedItemLedgEntry."Order Type"::Production) AND
          (OldItemLedgEntry."Order Type" = OldItemLedgEntry."Order Type"::Production) AND
          (OldItemLedgEntry."Order No." = PrevAppliedItemLedgEntry."Order No.") AND
          (OldItemLedgEntry."Order Line No." = PrevAppliedItemLedgEntry."Order Line No."));
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeApplyItemLedgEntry(VAR ItemLedgEntry: Record 32; VAR OldItemLedgEntry: Record 32; VAR ValueEntry: Record 5802; CausedByTransfer: Boolean; VAR Handled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckItemTrackingInfo(VAR ItemJnlLine2: Record 83; VAR TrackingSpecification: Record 336; VAR SNInfoRequired: Boolean; VAR LotInfoRequired: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckItemTracking(ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckItemTrackingInfo(VAR ItemJnlLine2: Record 83; VAR TrackingSpecification: Record 336; SNInfoRequired: Boolean; LotInfoRequired: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertTransferEntry(VAR NewItemLedgerEntry: Record 32; VAR OldItemLedgerEntry: Record 32; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertPhysInvtLedgEntry(VAR PhysInventoryLedgerEntry: Record 281; ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitItemLedgEntry(VAR NewItemLedgEntry: Record 32; ItemJournalLine: Record 83; VAR ItemLedgEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertItemLedgEntry(VAR ItemLedgerEntry: Record 32; ItemJournalLine: Record 83; VAR ItemLedgEntryNo: Integer; VAR ValueEntryNo: Integer; VAR ItemApplnEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertItemLedgEntry(VAR ItemLedgerEntry: Record 32; ItemJournalLine: Record 83; TransferItem: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertValueEntry(VAR ValueEntry: Record 5802; ItemJournalLine: Record 83; VAR ItemLedgerEntry: Record 32; VAR ValueEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertValueEntry(VAR ValueEntry: Record 5802; ItemJournalLine: Record 83; VAR ItemLedgerEntry: Record 32; VAR ValueEntryNo: Integer; VAR InventoryPostingToGL: Codeunit 5802);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitValueEntry(VAR ValueEntry: Record 5802; ItemJournalLine: Record 83; VAR ValueEntryNo: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertCapLedgEntry(VAR CapLedgEntry: Record 5832; ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertCapLedgEntry(VAR CapLedgEntry: Record 5832; ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertCapValueEntry(VAR ValueEntry: Record 5802; ItemJnlLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertCapValueEntry(VAR ValueEntry: Record 5802; ItemJnlLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertCorrItemLedgEntry(VAR NewItemLedgerEntry: Record 32; VAR OldItemLedgerEntry: Record 32; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertCorrItemLedgEntry(VAR NewItemLedgerEntry: Record 32; VAR ItemJournalLine: Record 83; VAR OldItemLedgerEntry: Record 32);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertCorrValueEntry(VAR NewValueEntry: Record 5802; OldValueEntry: Record 5802; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertCorrValueEntry(VAR NewValueEntry: Record 5802; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostItemJnlLine(VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostItemJnlLine(VAR ItemJournalLine: Record 83; ItemLedgerEntry: Record 32);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostOutputOnBeforeProdOrderRtngLineModify(VAR ProdOrderRoutingLine: Record 5409; VAR ProdOrderLine: Record 5406);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCheckPostingCostToGL(VAR PostCostToGL: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertSetupTempSplitItemJnlLine(VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR TempItemJournalLine: Record 83 TEMPORARY; VAR PostItemJnlLine: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforePostFlushedConsumpItemJnlLine(VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterItemValuePosting(VAR ValueEntry: Record 5802; VAR ItemJournalLine: Record 83; VAR Item: Record 27);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnSetupSplitJnlLineOnBeforeSplitTempLines(VAR TempSplitItemJournalLine: Record 83 TEMPORARY; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcPurchCorrShares(VAR ValueEntry: Record 5802; VAR ItemJournalLine: Record 83; VAR OverheadAmount: Decimal; VAR OverheadAmountACY: Decimal; VAR VarianceAmount: Decimal; VAR VarianceAmountACY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCalcPosShares(VAR ItemJournalLine: Record 83; VAR DirCost: Decimal; VAR OvhdCost: Decimal; VAR PurchVar: Decimal; VAR DirCostACY: Decimal; VAR OvhdCostACY: Decimal; VAR PurchVarACY: Decimal; VAR CalcUnitCost: Boolean; CalcPurchVar: Boolean; Expected: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertOHValueEntry(VAR ValueEntry: Record 5802; VAR Item: Record 27; VAR OverheadAmount: Decimal; VAR OverheadAmountACY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSetupTempSplitItemJnlLineSetQty(VAR TempSplitItemJnlLine: Record 83 TEMPORARY; ItemJournalLine: Record 83; SignFactor: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckSerialNo(ItemJournalLine: Record 83; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInitValueEntry(VAR ValueEntry: Record 5802; VAR ValueEntryNo: Integer; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertOHValueEntry(VAR ValueEntry: Record 5802; VAR Item: Record 27; VAR OverheadAmount: Decimal; VAR OverheadAmountACY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertVarValueEntry(VAR ValueEntry: Record 5802; VAR Item: Record 27; VAR VarianceAmount: Decimal; VAR VarianceAmountACY: Decimal);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeSetupSplitJnlLine(VAR ItemJnlLine2: Record 83; TrackingSpecExists: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnApplyItemLedgEntryOnBeforeCLoseReservEntry(VAR OldItemLedgEntry: Record 32; ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterApplyItemLedgEntrySetFilters(VAR ItemLedgerEntry2: Record 32; ItemLedgerEntry: Record 32);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPostSplitJnlLine(VAR ItemJournalLine: Record 83; VAR TempTrackingSpecification: Record 336 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterPrepareItem(VAR ItemJnlLineToPost: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterUpdateProdOrderLine(VAR ProdOrderLine: Record 5406; ReTrack: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnGetValuationDateOnBeforeFindOldValueEntry(VAR OldValueEntry: Record 5802; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnInsertCapValueEntryOnAfterUpdateCostAmounts(VAR ValueEntry: Record 5802; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnValuateAppliedAvgEntryOnAfterUpdateCostAmounts(VAR ValueEntry: Record 5802; VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostOutputOnAfterUpdateAmounts(VAR ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnPostOutputOnBeforeCreateWhseJnlLine(VAR ItemJournalLine: Record 83; VAR PostWhseJnlLine: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnTestFirstApplyItemLedgEntryOnAfterTestFields(ItemLedgerEntry: Record 32; OldItemLedgerEntry: Record 32);
    BEGIN
    END;

    LOCAL PROCEDURE PrepareItem(ItemJnlLineToPost: Record 83);
    BEGIN
        ItemJnlLine.COPY(ItemJnlLineToPost);

        GetGLSetup;
        GetInvtSetup;
        CheckItem(ItemJnlLineToPost."Item No.");

        OnAfterPrepareItem(ItemJnlLineToPost);
    END;

    //[External]
    PROCEDURE SetSkipApplicationCheck(NewValue: Boolean);
    BEGIN
        SkipApplicationCheck := NewValue;
    END;



    LOCAL PROCEDURE AddToApplicationLog(ItemApplnEntry: Record 339; IsApplication: Boolean);
    BEGIN
        WITH TempItemApplnEntryHistory DO BEGIN
            IF FINDLAST THEN;
            "Primary Entry No." += 1;

            "Item Ledger Entry No." := ItemApplnEntry."Item Ledger Entry No.";
            "Inbound Item Entry No." := ItemApplnEntry."Inbound Item Entry No.";
            "Outbound Item Entry No." := ItemApplnEntry."Outbound Item Entry No.";

            "Cost Application" := IsApplication;
            INSERT;
        END;
    END;

    //[External]
    PROCEDURE ClearApplicationLog();
    BEGIN
        TempItemApplnEntryHistory.DELETEALL;
    END;


    LOCAL PROCEDURE AppliedEntriesToReadjust(ItemLedgEntry: Record 32): Boolean;
    BEGIN
        WITH ItemLedgEntry DO
            EXIT("Entry Type" IN ["Entry Type"::Output, "Entry Type"::"Assembly Output"]);
    END;

    LOCAL PROCEDURE GetTextStringWithLineNo(BasicTextString: Text; ItemNo: Code[20]; LineNo: Integer): Text;
    BEGIN
        IF LineNo = 0 THEN
            EXIT(STRSUBSTNO(BasicTextString, ItemNo));
        EXIT(STRSUBSTNO(BasicTextString, ItemNo) + STRSUBSTNO(LineNoTxt, LineNo));
    END;

    LOCAL PROCEDURE SaveTouchedEntry(ItemLedgerEntryNo: Integer; IsInbound: Boolean);
    VAR
        ItemApplicationEntryHistory: Record 343;
        NextEntryNo: Integer;
    BEGIN
        IF NOT CalledFromApplicationWorksheet THEN
            EXIT;

        WITH ItemApplicationEntryHistory DO BEGIN
            IF FINDLAST THEN
                NextEntryNo := "Primary Entry No." + 1
            ELSE
                NextEntryNo := 1;

            INIT;
            "Primary Entry No." := NextEntryNo;
            "Entry No." := 0;
            "Item Ledger Entry No." := ItemLedgerEntryNo;
            IF IsInbound THEN
                "Inbound Item Entry No." := ItemLedgerEntryNo
            ELSE
                "Outbound Item Entry No." := ItemLedgerEntryNo;
            "Creation Date" := CURRENTDATETIME;
            "Created By User" := USERID;
            INSERT;
        END;
    END;

    LOCAL PROCEDURE DeleteTouchedEntries();
    VAR
        ItemApplicationEntryHistory: Record 343;
    BEGIN
        IF NOT CalledFromApplicationWorksheet THEN
            EXIT;

        WITH ItemApplicationEntryHistory DO BEGIN
            SETRANGE("Entry No.", 0);
            SETRANGE("Created By User", UPPERCASE(USERID));
            DELETEALL;
        END;
    END;

    LOCAL PROCEDURE VerifyItemJnlLineAsembleToOrder(VAR ItemJournalLine: Record 83);
    BEGIN
        ItemJournalLine.TESTFIELD("Applies-to Entry");

        ItemJournalLine.CALCFIELDS("Reserved Qty. (Base)");
        ItemJournalLine.TESTFIELD("Reserved Qty. (Base)");
    END;

    LOCAL PROCEDURE VerifyItemJnlLineApplication(VAR ItemJournalLine: Record 83; ItemLedgerEntry: Record 32);
    BEGIN
        IF ItemJournalLine."Applies-to Entry" = 0 THEN
            EXIT;

        ItemJournalLine.CALCFIELDS("Reserved Qty. (Base)");
        IF ItemJournalLine."Reserved Qty. (Base)" <> 0 THEN
            ItemLedgerEntry.FIELDERROR("Applies-to Entry", Text99000000);
    END;

    LOCAL PROCEDURE GetCombinedDimSetID(DimSetID1: Integer; DimSetID2: Integer): Integer;
    VAR
        DimMgt: Codeunit 408;
        DummyGlobalDimCode: ARRAY[2] OF Code[20];
        DimID: ARRAY[10] OF Integer;
    BEGIN
        DimID[1] := DimSetID1;
        DimID[2] := DimSetID2;
        EXIT(DimMgt.GetCombinedDimensionSetID(DimID, DummyGlobalDimCode[1], DummyGlobalDimCode[2]));
    END;

    LOCAL PROCEDURE CalcILEExpectedAmount(VAR OldValueEntry: Record 5802; ItemLedgerEntryNo: Integer);
    VAR
        OldValueEntry2: Record 5802;
    BEGIN
        OldValueEntry.FindFirstValueEntryByItemLedgerEntryNo(ItemLedgerEntryNo);
        OldValueEntry2.COPY(OldValueEntry);
        OldValueEntry2.SETFILTER("Entry No.", '<>%1', OldValueEntry."Entry No.");
        OldValueEntry2.CALCSUMS("Cost Amount (Expected)", "Cost Amount (Expected) (ACY)");
        OldValueEntry."Cost Amount (Expected)" += OldValueEntry2."Cost Amount (Expected)";
        OldValueEntry."Cost Amount (Expected) (ACY)" += OldValueEntry2."Cost Amount (Expected) (ACY)";
    END;

    LOCAL PROCEDURE FindOpenOutputEntryNoToApply(ItemJournalLine: Record 83): Integer;
    VAR
        ItemLedgerEntry: Record 32;
    BEGIN
        IF (ItemJournalLine."Lot No." = '') AND (ItemJournalLine."Serial No." = '') THEN
            EXIT(0);

        WITH ItemLedgerEntry DO BEGIN
            SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            SETRANGE("Order Type", "Order Type"::Production);
            SETRANGE("Order No.", ItemJournalLine."Order No.");
            SETRANGE("Order Line No.", ItemJournalLine."Order Line No.");
            SETRANGE("Entry Type", "Entry Type"::Output);
            SETRANGE("Prod. Order Comp. Line No.", 0);
            SETRANGE("Item No.", ItemJournalLine."Item No.");
            SETRANGE("Location Code", ItemJournalLine."Location Code");
            SETRANGE("Lot No.", ItemJournalLine."Lot No.");
            SETRANGE("Serial No.", ItemJournalLine."Serial No.");
            SETRANGE(Positive, TRUE);
            SETRANGE(Open, TRUE);
            SETFILTER("Remaining Quantity", '>=%1', -ItemJournalLine."Output Quantity (Base)");
            IF NOT ISEMPTY THEN
                IF COUNT = 1 THEN BEGIN
                    FINDFIRST;
                    EXIT("Entry No.");
                END;
        END;

        EXIT(0);
    END;

    LOCAL PROCEDURE ExpectedCostPosted(ValueEntry: Record 5802): Boolean;
    VAR
        PostedExpCostValueEntry: Record 5802;
    BEGIN
        WITH ValueEntry DO BEGIN
            IF NOT Adjustment OR ("Applies-to Entry" = 0) THEN
                EXIT(FALSE);
            PostedExpCostValueEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry No.");
            PostedExpCostValueEntry.SETRANGE("Applies-to Entry", "Applies-to Entry");
            PostedExpCostValueEntry.SETRANGE("Expected Cost", TRUE);
            EXIT(NOT PostedExpCostValueEntry.ISEMPTY);
        END;
    END;


    

    /* /*BEGIN
END.*/
}










