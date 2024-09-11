Codeunit 51359 "Create Reserv. Entry 1"
{


    Permissions = TableData 337 = rim;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'You cannot reserve this entry because it is not a true demand or supply.', ESP = 'No puede invertir este movimiento porque no es una demanda o suministro verdaderos.';
        InsertReservEntry: Record 337;
        InsertReservEntry2: Record 337;
        LastReservEntry: Record 337;
        TempTrkgSpec1: Record 336 TEMPORARY;
        TempTrkgSpec2: Record 336 TEMPORARY;
        Text001: TextConst ENU = 'Cannot match item tracking.', ESP = 'No coincide seguimiento producto.';
        OverruleItemTracking: Boolean;
        Inbound: Boolean;
        UseQtyToInvoice: Boolean;
        QtyToHandleAndInvoiceIsSet: Boolean;
        LastProcessedSourceID: Text;

    //[External]
    // PROCEDURE CreateEntry(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; Description: Text[50]; ExpectedReceiptDate: Date; ShipmentDate: Date; TransferredFromEntryNo: Integer; Status: Option "Reservation","Tracking","Surplus","Prospect");
    // VAR
    //     ReservEntry: Record 337;
    //     ReservEntry2: Record 337;
    //     ReservMgt: Codeunit 99000845;
    //     TrackingSpecificationExists: Boolean;
    //     FirstSplit: Boolean;
    // BEGIN
    //     TempTrkgSpec1.RESET;
    //     TempTrkgSpec2.RESET;
    //     TempTrkgSpec1.DELETEALL;
    //     TempTrkgSpec2.DELETEALL;

    //     // Status Surplus gets special treatment.

    //     IF Status < Status::Surplus THEN
    //         IF InsertReservEntry."Quantity (Base)" = 0 THEN
    //             EXIT;

    //     InsertReservEntry.TESTFIELD("Source Type");

    //     ReservEntry := InsertReservEntry;
    //     ReservEntry."Reservation Status" := Enum::"Reservation Status".FromInteger(Status);
    //     ReservEntry."Item No." := ItemNo;
    //     ReservEntry."Variant Code" := VariantCode;
    //     ReservEntry."Location Code" := LocationCode;
    //     ReservEntry.Description := Description;
    //     ReservEntry."Creation Date" := WORKDATE;
    //     ReservEntry."Created By" := USERID;
    //     ReservEntry."Expected Receipt Date" := ExpectedReceiptDate;
    //     ReservEntry."Shipment Date" := ShipmentDate;
    //     ReservEntry."Transferred from Entry No." := TransferredFromEntryNo;
    //     ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
    //     IF (ReservEntry."Quantity (Base)" <> 0) AND
    //        ((ReservEntry.Quantity = 0) OR (ReservEntry."Qty. per Unit of Measure" <> InsertReservEntry2."Qty. per Unit of Measure"))
    //     THEN
    //         ReservEntry.Quantity := ROUND(ReservEntry."Quantity (Base)" / ReservEntry."Qty. per Unit of Measure", 0.00001);
    //     IF NOT QtyToHandleAndInvoiceIsSet THEN BEGIN
    //         ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
    //         ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
    //     END;
    //     ReservEntry."Untracked Surplus" := InsertReservEntry."Untracked Surplus" AND NOT ReservEntry.Positive;

    //     OnCreateEntryOnBeforeSurplusCondition(ReservEntry);

    //     IF Status < Status::Surplus THEN BEGIN
    //         InsertReservEntry2.TESTFIELD("Source Type");

    //         ReservEntry2 := ReservEntry;
    //         ReservEntry2."Quantity (Base)" := -ReservEntry."Quantity (Base)";
    //         ReservEntry2.Quantity := ROUND(ReservEntry2."Quantity (Base)" / InsertReservEntry2."Qty. per Unit of Measure", 0.00001);
    //         ReservEntry2."Qty. to Handle (Base)" := -ReservEntry."Qty. to Handle (Base)";
    //         ReservEntry2."Qty. to Invoice (Base)" := -ReservEntry."Qty. to Invoice (Base)";
    //         ReservEntry2.Positive := (ReservEntry2."Quantity (Base)" > 0);
    //         ReservEntry2."Source Type" := InsertReservEntry2."Source Type";
    //         ReservEntry2."Source Subtype" := InsertReservEntry2."Source Subtype";
    //         ReservEntry2."Source ID" := InsertReservEntry2."Source ID";
    //         ReservEntry2."Source Batch Name" := InsertReservEntry2."Source Batch Name";
    //         ReservEntry2."Source Prod. Order Line" := InsertReservEntry2."Source Prod. Order Line";
    //         ReservEntry2."Source Ref. No." := InsertReservEntry2."Source Ref. No.";
    //         ReservEntry2."Serial No." := InsertReservEntry2."Serial No.";
    //         ReservEntry2."Lot No." := InsertReservEntry2."Lot No.";
    //         ReservEntry2."Qty. per Unit of Measure" := InsertReservEntry2."Qty. per Unit of Measure";
    //         ReservEntry2."Untracked Surplus" := InsertReservEntry2."Untracked Surplus" AND NOT ReservEntry2.Positive;

    //         OnAfterCopyFromInsertReservEntry(InsertReservEntry2, ReservEntry2);

    //         IF NOT QtyToHandleAndInvoiceIsSet THEN BEGIN
    //             ReservEntry2."Qty. to Handle (Base)" := ReservEntry2."Quantity (Base)";
    //             ReservEntry2."Qty. to Invoice (Base)" := ReservEntry2."Quantity (Base)";
    //         END;

    //         ReservEntry2.ClearApplFromToItemEntry;

    //         IF Status = Status::Reservation THEN
    //             IF TransferredFromEntryNo = 0 THEN BEGIN
    //                 ReservMgt.MakeRoomForReservation(ReservEntry2);
    //                 TrackingSpecificationExists :=
    //                   ReservMgt.CollectTrackingSpecification(TempTrkgSpec2);
    //             END;
    //         CheckValidity(ReservEntry2);
    //         AdjustDateIfItemLedgerEntry(ReservEntry2);
    //     END;

    //     ReservEntry.ClearApplFromToItemEntry;

    //     CheckValidity(ReservEntry);
    //     AdjustDateIfItemLedgerEntry(ReservEntry);
    //     IF Status = Status::Reservation THEN
    //         IF TransferredFromEntryNo = 0 THEN BEGIN
    //             ReservMgt.MakeRoomForReservation(ReservEntry);
    //             TrackingSpecificationExists := TrackingSpecificationExists OR
    //               ReservMgt.CollectTrackingSpecification(TempTrkgSpec1);
    //         END;

    //     IF TrackingSpecificationExists THEN
    //         SetupSplitReservEntry(ReservEntry, ReservEntry2);

    //     FirstSplit := TRUE;
    //     WHILE SplitReservEntry(ReservEntry, ReservEntry2, TrackingSpecificationExists, FirstSplit) DO BEGIN
    //         ReservEntry."Entry No." := 0;
    //         ReservEntry.UpdateItemTracking;
    //         OnBeforeReservEntryInsert(ReservEntry);
    //         ReservEntry.INSERT;
    //         IF Status < Status::Surplus THEN BEGIN
    //             ReservEntry2."Entry No." := ReservEntry."Entry No.";
    //             ReservEntry2.UpdateItemTracking;
    //             OnBeforeReservEntryInsertNonSurplus(ReservEntry2);
    //             ReservEntry2.INSERT;
    //         END;
    //     END;

    //     LastReservEntry := ReservEntry;

    //     CLEAR(InsertReservEntry);
    //     CLEAR(InsertReservEntry2);
    //     CLEAR(QtyToHandleAndInvoiceIsSet);
    // END;

    //[External]
    // PROCEDURE CreateReservEntry(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; Description: Text[50]; ExpectedReceiptDate: Date; ShipmentDate: Date);
    // BEGIN
    //     CreateEntry(ItemNo, VariantCode, LocationCode, Description,
    //       ExpectedReceiptDate, ShipmentDate, 0, 0);
    // END;

    //[External]
    PROCEDURE CreateReservEntryFor(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForQtyPerUOM: Decimal; Quantity: Decimal; QuantityBase: Decimal; ForSerialNo: Code[50]; ForLotNo: Code[50]);
    VAR
        Sign: Integer;
    BEGIN
        InsertReservEntry.SetSource(ForType, ForSubtype, ForID, ForRefNo, ForBatchName, ForProdOrderLine);
        Sign := SignFactor(InsertReservEntry);
        InsertReservEntry.Quantity := Sign * Quantity;
        InsertReservEntry."Quantity (Base)" := Sign * QuantityBase;
        InsertReservEntry."Qty. per Unit of Measure" := ForQtyPerUOM;
        InsertReservEntry."Serial No." := ForSerialNo;
        InsertReservEntry."Lot No." := ForLotNo;

        InsertReservEntry.TESTFIELD("Qty. per Unit of Measure");
    END;

    //[External]
    PROCEDURE CreateReservEntryFrom(FromType: Option; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromProdOrderLine: Integer; FromRefNo: Integer; FromQtyPerUOM: Decimal; FromSerialNo: Code[50]; FromLotNo: Code[50]);
    BEGIN
        InsertReservEntry2.INIT;
        InsertReservEntry2.SetSource(FromType, FromSubtype, FromID, FromRefNo, FromBatchName, FromProdOrderLine);
        InsertReservEntry2."Qty. per Unit of Measure" := FromQtyPerUOM;
        InsertReservEntry2."Serial No." := FromSerialNo;
        InsertReservEntry2."Lot No." := FromLotNo;

        InsertReservEntry2.TESTFIELD("Qty. per Unit of Measure");
    END;

    //[External]
    PROCEDURE SetBinding(Binding: Option " ","Order-to-Order");
    BEGIN
        InsertReservEntry.Binding := Enum::"Reservation Binding".FromInteger(Binding);
        InsertReservEntry2.Binding := Enum::"Reservation Binding".FromInteger(Binding);
    END;

    //[External]
    // PROCEDURE SetPlanningFlexibility(Flexibility: Option "Unlimited","None");
    // BEGIN
    //     InsertReservEntry."Planning Flexibility" := Enum::"Reservation Planning Flexibility".FromInteger(Flexibility);
    //     InsertReservEntry2."Planning Flexibility" := Enum::"Reservation Planning Flexibility".FromInteger(Flexibility);
    // END;

    //[External]
    // PROCEDURE SetDates(WarrantyDate: Date; ExpirationDate: Date);
    // BEGIN
    //     InsertReservEntry."Warranty Date" := WarrantyDate;
    //     InsertReservEntry."Expiration Date" := ExpirationDate;
    // END;

    //[External]
    // PROCEDURE SetQtyToHandleAndInvoice(QtyToHandleBase: Decimal; QtyToInvoiceBase: Decimal);
    // BEGIN
    //     InsertReservEntry."Qty. to Handle (Base)" := QtyToHandleBase;
    //     InsertReservEntry."Qty. to Invoice (Base)" := QtyToInvoiceBase;
    //     QtyToHandleAndInvoiceIsSet := TRUE;
    // END;

    //[External]
    PROCEDURE SetNewSerialLotNo(NewSerialNo: Code[50]; NewLotNo: Code[50]);
    BEGIN
        InsertReservEntry."New Serial No." := NewSerialNo;
        InsertReservEntry."New Lot No." := NewLotNo;
    END;

    //[External]
    // PROCEDURE SetNewExpirationDate(NewExpirationDate: Date);
    // BEGIN
    //     InsertReservEntry."New Expiration Date" := NewExpirationDate;
    // END;

    //[External]
    // PROCEDURE SetDisallowCancellation(NewDisallowCancellation: Boolean);
    // BEGIN
    //     InsertReservEntry."Disallow Cancellation" := NewDisallowCancellation;
    // END;

    //[External]
    // PROCEDURE CreateRemainingReservEntry(VAR OldReservEntry: Record 337; RemainingQuantity: Decimal; RemainingQuantityBase: Decimal);
    // VAR
    //     OldReservEntry2: Record 337;
    // BEGIN
    //     CreateReservEntryFor(
    //       OldReservEntry."Source Type", OldReservEntry."Source Subtype",
    //       OldReservEntry."Source ID", OldReservEntry."Source Batch Name",
    //       OldReservEntry."Source Prod. Order Line", OldReservEntry."Source Ref. No.",
    //       OldReservEntry."Qty. per Unit of Measure", RemainingQuantity, RemainingQuantityBase,
    //       OldReservEntry."Serial No.", OldReservEntry."Lot No.");
    //     InsertReservEntry."Warranty Date" := OldReservEntry."Warranty Date";
    //     InsertReservEntry."Expiration Date" := OldReservEntry."Expiration Date";
    //     OnBeforeCreateRemainingReservEntry(InsertReservEntry, OldReservEntry);

    //     IF OldReservEntry."Reservation Status".AsInteger() < OldReservEntry."Reservation Status"::Surplus.AsInteger() THEN
    //         IF OldReservEntry2.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive) THEN BEGIN // Get the related entry
    //             CreateReservEntryFrom(
    //               OldReservEntry2."Source Type", OldReservEntry2."Source Subtype",
    //               OldReservEntry2."Source ID", OldReservEntry2."Source Batch Name",
    //               OldReservEntry2."Source Prod. Order Line", OldReservEntry2."Source Ref. No.", OldReservEntry2."Qty. per Unit of Measure",
    //               OldReservEntry2."Serial No.", OldReservEntry2."Lot No.");
    //             InsertReservEntry2."Warranty Date" := OldReservEntry2."Warranty Date";
    //             InsertReservEntry2."Expiration Date" := OldReservEntry2."Expiration Date";
    //             OnBeforeCreateRemainingNonSurplusReservEntry(InsertReservEntry2, OldReservEntry2);
    //         END;

    //     CreateEntry(
    //       OldReservEntry."Item No.", OldReservEntry."Variant Code",
    //       OldReservEntry."Location Code", OldReservEntry.Description,
    //       OldReservEntry."Expected Receipt Date", OldReservEntry."Shipment Date",
    //       OldReservEntry."Entry No.", ConvertDocumentTypeToOptionReservationStatus(OldReservEntry."Reservation Status"));
    // END;

    //[External]
    // PROCEDURE TransferReservEntry(NewType: Option; NewSubtype: Integer; NewID: Code[20]; NewBatchName: Code[10]; NewProdOrderLine: Integer; NewRefNo: Integer; QtyPerUOM: Decimal; OldReservEntry: Record 337; TransferQty: Decimal): Decimal;
    // VAR
    //     NewReservEntry: Record 337;
    //     ReservEntry: Record 337;
    //     Location: Record 14;
    //     ItemTrkgMgt: Codeunit 51151;
    //     CurrSignFactor: Integer;
    //     xTransferQty: Decimal;
    //     QtyToHandleThisLine: Decimal;
    //     QtyToInvoiceThisLine: Decimal;
    //     QtyInvoiced: Decimal;
    //     CarriedSerialNo: Code[50];
    //     CarriedLotNo: Code[50];
    //     UseQtyToHandle: Boolean;
    //     SNRequired: Boolean;
    //     LNRequired: Boolean;
    // BEGIN
    //     IF TransferQty = 0 THEN
    //         EXIT;

    //     UseQtyToHandle := OldReservEntry.TrackingExists AND NOT OverruleItemTracking;

    //     CurrSignFactor := SignFactor(OldReservEntry);
    //     TransferQty := TransferQty * CurrSignFactor;
    //     xTransferQty := TransferQty;

    //     IF UseQtyToHandle THEN BEGIN // Used when handling Item Tracking
    //         QtyToHandleThisLine := OldReservEntry."Qty. to Handle (Base)";
    //         QtyToInvoiceThisLine := OldReservEntry."Qty. to Invoice (Base)";
    //         IF ABS(TransferQty) > ABS(QtyToHandleThisLine) THEN
    //             TransferQty := QtyToHandleThisLine;
    //         IF UseQtyToInvoice THEN BEGIN // Used when posting sales and purchase
    //             IF ABS(TransferQty) > ABS(QtyToInvoiceThisLine) THEN
    //                 TransferQty := QtyToInvoiceThisLine;
    //         END;
    //     END ELSE
    //         QtyToHandleThisLine := OldReservEntry."Quantity (Base)";

    //     IF QtyToHandleThisLine = 0 THEN
    //         EXIT(xTransferQty * CurrSignFactor);

    //     NewReservEntry.TRANSFERFIELDS(OldReservEntry, FALSE);

    //     NewReservEntry."Entry No." := OldReservEntry."Entry No.";
    //     NewReservEntry.Positive := OldReservEntry.Positive;
    //     NewReservEntry.SetSource(NewType, NewSubtype, NewID, NewRefNo, NewBatchName, NewProdOrderLine);
    //     NewReservEntry."Qty. per Unit of Measure" := QtyPerUOM;

    //     // Item Tracking on consumption, output and drop shipment:
    //     IF (NewType = DATABASE::"Item Journal Line") AND (NewSubtype IN [3, 5, 6]) OR OverruleItemTracking THEN
    //         IF (InsertReservEntry."New Serial No." <> '') OR (InsertReservEntry."New Lot No." <> '') THEN BEGIN
    //             NewReservEntry."Serial No." := InsertReservEntry."New Serial No.";
    //             NewReservEntry."Lot No." := InsertReservEntry."New Lot No.";
    //             IF NewReservEntry."Qty. to Handle (Base)" = 0 THEN
    //                 NewReservEntry."Qty. to Handle (Base)" := NewReservEntry."Quantity (Base)";
    //             InsertReservEntry."New Serial No." := '';
    //             InsertReservEntry."New Lot No." := '';

    //             // If an order-to-order supply is being posted, item tracking must be carried to the related demand:
    //             IF (TransferQty >= 0) AND (NewReservEntry.Binding = NewReservEntry.Binding::"Order-to-Order") THEN BEGIN
    //                 CarriedSerialNo := NewReservEntry."Serial No.";
    //                 CarriedLotNo := NewReservEntry."Lot No.";
    //                 IF NOT UseQtyToHandle THEN
    //                     // the IT is set only in Consumption/Output Journal and we need to update all fields properly
    //                     QtyToInvoiceThisLine := NewReservEntry."Quantity (Base)";
    //             END;
    //         END;

    //     IF InsertReservEntry."Item Ledger Entry No." <> 0 THEN BEGIN
    //         NewReservEntry."Item Ledger Entry No." := InsertReservEntry."Item Ledger Entry No.";
    //         InsertReservEntry."Item Ledger Entry No." := 0;
    //     END;

    //     IF NewReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
    //         IF NewReservEntry."Quantity (Base)" > 0 THEN
    //             NewReservEntry."Expected Receipt Date" := 0D
    //         ELSE
    //             NewReservEntry."Shipment Date" := DMY2DATE(31, 12, 9999);

    //     NewReservEntry.UpdateItemTracking;

    //     IF (TransferQty >= 0) <> OldReservEntry.Positive THEN BEGIN // If sign has swapped due to negative posting
    //                                                                 // Create a new but unchanged version of the original reserventry:
    //         SetQtyToHandleAndInvoice(QtyToHandleThisLine, QtyToInvoiceThisLine);
    //         CreateRemainingReservEntry(OldReservEntry,
    //           OldReservEntry.Quantity * CurrSignFactor,
    //           OldReservEntry."Quantity (Base)" * CurrSignFactor);
    //         NewReservEntry.VALIDATE("Quantity (Base)", TransferQty);
    //         // Correct primary key - swap "Positive":
    //         NewReservEntry.Positive := NOT NewReservEntry.Positive;

    //         IF NOT ReservEntry.GET(NewReservEntry."Entry No.", NewReservEntry.Positive) THEN BEGIN
    //             // Means that only one record exists = surplus or prospect
    //             NewReservEntry.INSERT;
    //             // Delete the original record:
    //             NewReservEntry.Positive := NOT NewReservEntry.Positive;
    //             NewReservEntry.DELETE;
    //         END ELSE BEGIN // A set of records exist = reservation or tracking
    //             NewReservEntry.MODIFY;
    //             // Get the original record and modify quantity:
    //             NewReservEntry.GET(NewReservEntry."Entry No.", NOT NewReservEntry.Positive); // Get partner-record
    //             NewReservEntry.VALIDATE("Quantity (Base)", -TransferQty);
    //             NewReservEntry.MODIFY;
    //         END;
    //     END ELSE
    //         IF ABS(TransferQty) < ABS(OldReservEntry."Quantity (Base)") THEN BEGIN
    //             OnBeforeUseOldReservEntry(OldReservEntry, InsertReservEntry);
    //             IF OldReservEntry.Binding = OldReservEntry.Binding::"Order-to-Order" THEN
    //                 SetBinding(ConvertDocumentTypeToOptionReservationStatus(OldReservEntry.Binding::"Order-to-Order"));
    //             IF OldReservEntry."Disallow Cancellation" THEN
    //                 SetDisallowCancellation(OldReservEntry."Disallow Cancellation");
    //             IF ABS(QtyToInvoiceThisLine) > ABS(TransferQty) THEN
    //                 QtyInvoiced := TransferQty
    //             ELSE
    //                 QtyInvoiced := QtyToInvoiceThisLine;
    //             SetQtyToHandleAndInvoice(QtyToHandleThisLine - TransferQty, QtyToInvoiceThisLine - QtyInvoiced);
    //             CreateRemainingReservEntry(OldReservEntry,
    //               0, (OldReservEntry."Quantity (Base)" - TransferQty) * CurrSignFactor);
    //             NewReservEntry.VALIDATE("Quantity (Base)", TransferQty);
    //             NewReservEntry.MODIFY;
    //             IF NewReservEntry.GET(NewReservEntry."Entry No.", NOT NewReservEntry.Positive) THEN BEGIN // Get partner-record
    //                 NewReservEntry.VALIDATE("Quantity (Base)", -TransferQty);
    //                 NewReservEntry.MODIFY;
    //             END;
    //         END ELSE BEGIN
    //             NewReservEntry.MODIFY;
    //             TransferQty := NewReservEntry."Quantity (Base)";
    //             IF NewReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN BEGIN
    //                 IF NewReservEntry.GET(NewReservEntry."Entry No.", NOT NewReservEntry.Positive) THEN BEGIN // Get partner-record
    //                     IF NewReservEntry."Quantity (Base)" < 0 THEN
    //                         NewReservEntry."Expected Receipt Date" := 0D
    //                     ELSE
    //                         NewReservEntry."Shipment Date" := DMY2DATE(31, 12, 9999);
    //                     NewReservEntry.MODIFY;
    //                 END;

    //                 // If necessary create Whse. Item Tracking Lines
    //                 IF (NewReservEntry."Source Type" = DATABASE::"Sales Line") AND
    //                    (OldReservEntry."Source Type" = DATABASE::"Item Journal Line") AND
    //                    (OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Reservation)
    //                 THEN BEGIN
    //                     ItemTrkgMgt.CheckWhseItemTrkgSetup(OldReservEntry."Item No.", SNRequired, LNRequired, FALSE);
    //                     IF (SNRequired OR LNRequired) AND
    //                        Location.RequireShipment(OldReservEntry."Location Code")
    //                     THEN
    //                         CreateWhseItemTrkgLines(NewReservEntry);
    //                 END;
    //             END ELSE
    //                 IF (CarriedSerialNo + CarriedLotNo) <> '' THEN
    //                     IF NewReservEntry.GET(NewReservEntry."Entry No.", NOT NewReservEntry.Positive) THEN; // Get partner-record
    //         END;

    //     IF (CarriedSerialNo + CarriedLotNo) <> '' THEN BEGIN
    //         IF NewReservEntry."Qty. to Handle (Base)" = 0 THEN
    //             NewReservEntry.VALIDATE("Quantity (Base)");
    //         NewReservEntry."Serial No." := CarriedSerialNo;
    //         NewReservEntry."Lot No." := CarriedLotNo;
    //         NewReservEntry.UpdateItemTracking;
    //         IF NewReservEntry.MODIFY THEN;
    //     END;

    //     SynchronizeTransferOutboundToInboundItemTracking(NewReservEntry."Entry No.");

    //     xTransferQty -= TransferQty;
    //     EXIT(xTransferQty * CurrSignFactor);
    // END;

    //[External]
    PROCEDURE SignFactor(VAR ReservEntry: Record 337): Integer;
    VAR
        Sign: Integer;
    BEGIN
        // Demand is regarded as negative, supply is regarded as positive.
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                IF ReservEntry."Source Subtype" IN [3, 5] THEN // Credit memo, Return Order = supply
                    EXIT(1)
                ELSE
                    EXIT(-1);
            DATABASE::"Requisition Line":
                IF ReservEntry."Source Subtype" = 1 THEN
                    EXIT(-1)
                ELSE
                    EXIT(1);
            DATABASE::"Purchase Line":
                IF ReservEntry."Source Subtype" IN [3, 5] THEN // Credit memo, Return Order = demand
                    EXIT(-1)
                ELSE
                    EXIT(1);
            DATABASE::"Item Journal Line":
                IF (ReservEntry."Source Subtype" = 4) AND Inbound THEN
                    EXIT(1)
                ELSE
                    IF ReservEntry."Source Subtype" IN [1, 3, 4, 5] THEN // Sale, Negative Adjmt., Transfer, Consumption
                        EXIT(-1)
                    ELSE
                        EXIT(1);
            DATABASE::"Job Journal Line":
                EXIT(-1);
            DATABASE::"Item Ledger Entry":
                EXIT(1);
            DATABASE::"Prod. Order Line":
                EXIT(1);
            DATABASE::"Prod. Order Component":
                EXIT(-1);
            DATABASE::"Assembly Header":
                EXIT(1);
            DATABASE::"Assembly Line":
                EXIT(-1);
            DATABASE::"Planning Component":
                EXIT(-1);
            DATABASE::"Transfer Line":
                IF ReservEntry."Source Subtype" = 0 THEN // Outbound
                    EXIT(-1)
                ELSE
                    EXIT(1);
            DATABASE::"Service Line":
                IF ReservEntry."Source Subtype" IN [3] THEN // Credit memo
                    EXIT(1)
                ELSE
                    EXIT(-1);
            DATABASE::"Job Planning Line":
                EXIT(-1);
        END;

        OnAfterSignFactor(ReservEntry, Sign);
        EXIT(Sign);
    END;

    LOCAL PROCEDURE CheckValidity(VAR ReservEntry: Record 337);
    VAR
        IsError: Boolean;
    BEGIN
        IF ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Reservation THEN
            EXIT;

        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                IsError := NOT (ReservEntry."Source Subtype" IN [1, 5]);
            DATABASE::"Purchase Line":
                IsError := NOT (ReservEntry."Source Subtype" IN [1, 5]);
            DATABASE::"Prod. Order Line",
          DATABASE::"Prod. Order Component":
                IsError := (ReservEntry."Source Subtype" = 4) OR
                  ((ReservEntry."Source Subtype" = 1) AND (ReservEntry.Binding = ReservEntry.Binding::" "));
            DATABASE::"Assembly Header",
          DATABASE::"Assembly Line":
                IsError := NOT (ReservEntry."Source Subtype" = 1); // Only Assembly Order supported
            DATABASE::"Requisition Line",
          DATABASE::"Planning Component":
                IsError := ReservEntry.Binding = ReservEntry.Binding::" ";
            DATABASE::"Item Journal Line":
                // Item Journal Lines with Entry Type Transfer can carry reservations during posting:
                IsError := (ReservEntry."Source Subtype" <> 4) AND
                  (ReservEntry."Source Ref. No." <> 0);
            DATABASE::"Job Journal Line":
                IsError := ReservEntry.Binding = ReservEntry.Binding::"Order-to-Order";
            DATABASE::"Job Planning Line":
                IsError := ReservEntry."Source Subtype" <> 2;
            ELSE
                OnAfterCheckValidity(ReservEntry, IsError);
        END;

        IF IsError THEN
            ERROR(Text000);
    END;

    //[External]
    // PROCEDURE GetLastEntry(VAR ReservEntry: Record 337);
    // BEGIN
    //     ReservEntry := LastReservEntry;
    // END;

    // LOCAL PROCEDURE AdjustDateIfItemLedgerEntry(VAR ReservEntry: Record 337);
    // BEGIN
    //     IF ReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
    //         IF ReservEntry."Quantity (Base)" > 0 THEN
    //             ReservEntry."Expected Receipt Date" := 0D
    //         ELSE
    //             ReservEntry."Shipment Date" := DMY2DATE(31, 12, 9999);
    // END;

    LOCAL PROCEDURE SetupSplitReservEntry(VAR ReservEntry: Record 337; VAR ReservEntry2: Record 337);
    VAR
        NonReleasedQty: Decimal;
    BEGIN
        // Preparing the looping through Item Tracking.

        // Ensure that the full quantity is represented in the list of Tracking Specifications:
        NonReleasedQty := ReservEntry."Quantity (Base)";
        IF TempTrkgSpec1.FINDSET THEN
            REPEAT
                NonReleasedQty -= TempTrkgSpec1."Quantity (Base)";
            UNTIL TempTrkgSpec1.NEXT = 0;

        IF NonReleasedQty <> 0 THEN BEGIN
            TempTrkgSpec1.INIT;
            TempTrkgSpec1.TRANSFERFIELDS(ReservEntry);
            TempTrkgSpec1.VALIDATE("Quantity (Base)", NonReleasedQty);
            IF (TempTrkgSpec1."Source Type" <> DATABASE::"Item Ledger Entry") AND
               (ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Reservation)
            THEN
                TempTrkgSpec1.ClearTracking;
            TempTrkgSpec1.INSERT;
        END;

        IF NOT (ReservEntry."Reservation Status".AsInteger() < ReservEntry."Reservation Status"::Surplus.AsInteger()) THEN
            EXIT;

        NonReleasedQty := ReservEntry2."Quantity (Base)";
        IF TempTrkgSpec2.FINDSET THEN
            REPEAT
                NonReleasedQty -= TempTrkgSpec2."Quantity (Base)";
            UNTIL TempTrkgSpec2.NEXT = 0;

        IF NonReleasedQty <> 0 THEN BEGIN
            TempTrkgSpec2.INIT;
            TempTrkgSpec2.TRANSFERFIELDS(ReservEntry2);
            TempTrkgSpec2.VALIDATE("Quantity (Base)", NonReleasedQty);
            IF (TempTrkgSpec2."Source Type" <> DATABASE::"Item Ledger Entry") AND
               (ReservEntry2."Reservation Status" <> ReservEntry2."Reservation Status"::Reservation)
            THEN
                TempTrkgSpec2.ClearTracking;
            TempTrkgSpec2.INSERT;
        END;

        BalanceLists;
    END;

    LOCAL PROCEDURE BalanceLists();
    VAR
        TempTrkgSpec3: Record 336 TEMPORARY;
        TempTrkgSpec4: Record 336 TEMPORARY;
        LastEntryNo: Integer;
        NextState: Option "SetFilter1","SetFilter2","LoosenFilter1","LoosenFilter2","Split","Error","Finish";
    BEGIN
        TempTrkgSpec1.RESET;
        TempTrkgSpec2.RESET;
        TempTrkgSpec1.SETCURRENTKEY("Lot No.", "Serial No.");
        TempTrkgSpec2.SETCURRENTKEY("Lot No.", "Serial No.");

        IF NOT TempTrkgSpec1.FINDLAST THEN
            EXIT;

        REPEAT
            CASE NextState OF
                NextState::SetFilter1:
                    BEGIN
                        TempTrkgSpec1.SetTrackingFilterFromSpec(TempTrkgSpec2);
                        IF TempTrkgSpec1.FINDLAST THEN
                            NextState := NextState::Split
                        ELSE
                            NextState := NextState::LoosenFilter1;
                    END;
                NextState::LoosenFilter1:
                    BEGIN
                        IF TempTrkgSpec2."Quantity (Base)" > 0 THEN
                            TempTrkgSpec1.SetTrackingFilterBlank
                        ELSE BEGIN
                            IF TempTrkgSpec2."Serial No." = '' THEN
                                TempTrkgSpec1.SETRANGE("Serial No.");
                            IF TempTrkgSpec2."Lot No." = '' THEN
                                TempTrkgSpec1.SETRANGE("Lot No.");
                        END;
                        IF TempTrkgSpec1.FINDLAST THEN
                            NextState := NextState::Split
                        ELSE
                            NextState := NextState::Error;
                    END;
                NextState::SetFilter2:
                    BEGIN
                        TempTrkgSpec2.SetTrackingFilterFromSpec(TempTrkgSpec1);
                        IF TempTrkgSpec2.FINDLAST THEN
                            NextState := NextState::Split
                        ELSE
                            NextState := NextState::LoosenFilter2;
                    END;
                NextState::LoosenFilter2:
                    BEGIN
                        IF TempTrkgSpec1."Quantity (Base)" > 0 THEN
                            TempTrkgSpec2.SetTrackingFilterBlank
                        ELSE BEGIN
                            IF TempTrkgSpec1."Serial No." = '' THEN
                                TempTrkgSpec2.SETRANGE("Serial No.");
                            IF TempTrkgSpec1."Lot No." = '' THEN
                                TempTrkgSpec2.SETRANGE("Lot No.");
                        END;
                        IF TempTrkgSpec2.FINDLAST THEN
                            NextState := NextState::Split
                        ELSE
                            NextState := NextState::Error;
                    END;
                NextState::Split:
                    BEGIN
                        TempTrkgSpec3 := TempTrkgSpec1;
                        TempTrkgSpec4 := TempTrkgSpec2;
                        IF ABS(TempTrkgSpec1."Quantity (Base)") = ABS(TempTrkgSpec2."Quantity (Base)") THEN BEGIN
                            TempTrkgSpec1.DELETE;
                            TempTrkgSpec2.DELETE;
                            TempTrkgSpec1.ClearTrackingFilter;
                            IF TempTrkgSpec1.FINDLAST THEN
                                NextState := NextState::SetFilter2
                            ELSE BEGIN
                                TempTrkgSpec2.RESET;
                                IF TempTrkgSpec2.FINDLAST THEN
                                    NextState := NextState::Error
                                ELSE
                                    NextState := NextState::Finish;
                            END;
                        END ELSE
                            IF ABS(TempTrkgSpec1."Quantity (Base)") < ABS(TempTrkgSpec2."Quantity (Base)") THEN BEGIN
                                TempTrkgSpec2.VALIDATE("Quantity (Base)", TempTrkgSpec2."Quantity (Base)" +
                                  TempTrkgSpec1."Quantity (Base)");
                                TempTrkgSpec4.VALIDATE("Quantity (Base)", -TempTrkgSpec1."Quantity (Base)");
                                TempTrkgSpec1.DELETE;
                                TempTrkgSpec2.MODIFY;
                                NextState := NextState::SetFilter1;
                            END ELSE BEGIN
                                TempTrkgSpec1.VALIDATE("Quantity (Base)", TempTrkgSpec1."Quantity (Base)" +
                                  TempTrkgSpec2."Quantity (Base)");
                                TempTrkgSpec3.VALIDATE("Quantity (Base)", -TempTrkgSpec2."Quantity (Base)");
                                TempTrkgSpec2.DELETE;
                                TempTrkgSpec1.MODIFY;
                                NextState := NextState::SetFilter2;
                            END;
                        TempTrkgSpec3."Entry No." := LastEntryNo + 1;
                        TempTrkgSpec4."Entry No." := LastEntryNo + 1;
                        TempTrkgSpec3.INSERT;
                        TempTrkgSpec4.INSERT;
                        LastEntryNo := TempTrkgSpec3."Entry No.";
                    END;
                NextState::Error:
                    ERROR(Text001);
            END;
        UNTIL NextState = NextState::Finish;

        TempTrkgSpec1.RESET;
        TempTrkgSpec2.RESET;
        TempTrkgSpec3.RESET;
        TempTrkgSpec4.RESET;

        IF TempTrkgSpec3.FINDSET THEN
            REPEAT
                TempTrkgSpec1 := TempTrkgSpec3;
                TempTrkgSpec1.INSERT;
            UNTIL TempTrkgSpec3.NEXT = 0;

        IF TempTrkgSpec4.FINDSET THEN
            REPEAT
                TempTrkgSpec2 := TempTrkgSpec4;
                TempTrkgSpec2.INSERT;
            UNTIL TempTrkgSpec4.NEXT = 0;
    END;

    // LOCAL PROCEDURE SplitReservEntry(VAR ReservEntry: Record 337; VAR ReservEntry2: Record 337; TrackingSpecificationExists: Boolean; VAR FirstSplit: Boolean): Boolean;
    // VAR
    //     SalesSetup: Record 311;
    //     OldReservEntryQty: Decimal;
    // BEGIN
    //     IF NOT TrackingSpecificationExists THEN
    //         IF NOT FirstSplit THEN
    //             EXIT(FALSE)
    //         ELSE BEGIN
    //             FirstSplit := FALSE;
    //             EXIT(TRUE);
    //         END;

    //     SalesSetup.GET;
    //     TempTrkgSpec1.RESET;
    //     IF NOT TempTrkgSpec1.FINDFIRST THEN
    //         EXIT(FALSE);

    //     OnBeforeSplitReservEntry(TempTrkgSpec1, ReservEntry);

    //     ReservEntry.CopyTrackingFromSpec(TempTrkgSpec1);
    //     OldReservEntryQty := ReservEntry.Quantity;
    //     ReservEntry.VALIDATE("Quantity (Base)", TempTrkgSpec1."Quantity (Base)");
    //     IF ABS(ReservEntry.Quantity - OldReservEntryQty) <= 0.00001 THEN
    //         ReservEntry.Quantity := OldReservEntryQty;
    //     TempTrkgSpec1.DELETE;

    //     IF ReservEntry."Reservation Status".AsInteger() < ReservEntry."Reservation Status"::Surplus.AsInteger() THEN BEGIN
    //         TempTrkgSpec2.GET(TempTrkgSpec1."Entry No.");
    //         OnBeforeSplitNonSurplusReservEntry(TempTrkgSpec2, ReservEntry);

    //         ReservEntry2.CopyTrackingFromSpec(TempTrkgSpec2);
    //         OldReservEntryQty := ReservEntry2.Quantity;
    //         ReservEntry2.VALIDATE("Quantity (Base)", TempTrkgSpec2."Quantity (Base)");
    //         IF ABS(ReservEntry2.Quantity - OldReservEntryQty) <= 0.00001 THEN
    //             ReservEntry2.Quantity := OldReservEntryQty;
    //         IF ReservEntry2.Positive AND SalesSetup."Exact Cost Reversing Mandatory" THEN
    //             ReservEntry2."Appl.-from Item Entry" := TempTrkgSpec2."Appl.-from Item Entry";
    //         TempTrkgSpec2.DELETE;
    //     END;

    //     EXIT(TRUE);
    // END;

    LOCAL PROCEDURE CreateWhseItemTrkgLines(ReservEntry: Record 337);
    VAR
        WhseShipmentLine: Record 7321;
        WhseWkshLine: Record 7326;
        ItemTrkgMgt: Codeunit 51151;
    BEGIN
        WITH WhseShipmentLine DO BEGIN
            SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");
            SETRANGE("Source Type", ReservEntry."Source Type");
            SETRANGE("Source Subtype", ReservEntry."Source Subtype");
            SETRANGE("Source No.", ReservEntry."Source ID");
            SETRANGE("Source Line No.", ReservEntry."Source Ref. No.");
            IF FINDFIRST THEN
                IF NOT ItemTrkgMgt.WhseItemTrkgLineExists("No.", DATABASE::"Warehouse Shipment Line", 0, '', 0,
                     "Source Line No.", "Location Code", ReservEntry."Serial No.", ReservEntry."Lot No.")
                THEN BEGIN
                    ItemTrkgMgt.InitWhseWkshLine(WhseWkshLine,
                      Enum::"Warehouse Worksheet Document Type".FromInteger(2), "No.", "Line No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.", 0);
                    ItemTrkgMgt.CreateWhseItemTrkgForResEntry(ReservEntry, WhseWkshLine);
                END;
        END;
    END;

    //[External]
    // PROCEDURE SetItemLedgEntryNo(EntryNo: Integer);
    // BEGIN
    //     InsertReservEntry."Item Ledger Entry No." := EntryNo;
    // END;

    //[External]
    // PROCEDURE SetApplyToEntryNo(EntryNo: Integer);
    // BEGIN
    //     InsertReservEntry."Appl.-to Item Entry" := EntryNo;
    // END;

    //[External]
    // PROCEDURE SetApplyFromEntryNo(EntryNo: Integer);
    // BEGIN
    //     InsertReservEntry."Appl.-from Item Entry" := EntryNo;
    // END;

    //[External]
    // PROCEDURE SetOverruleItemTracking(Overrule: Boolean);
    // BEGIN
    //     OverruleItemTracking := Overrule;
    // END;

    //[External]
    // PROCEDURE SetInbound(NewInbound: Boolean);
    // BEGIN
    //     Inbound := NewInbound;
    // END;

    //[External]
    // PROCEDURE SetUseQtyToInvoice(UseQtyToInvoice2: Boolean);
    // BEGIN
    //     UseQtyToInvoice := UseQtyToInvoice2;
    // END;

    // PROCEDURE SetUntrackedSurplus(OrderTracking: Boolean);
    // BEGIN
    //     InsertReservEntry."Untracked Surplus" := OrderTracking;
    //     InsertReservEntry2."Untracked Surplus" := OrderTracking;
    // END;

    //[External]
    // PROCEDURE UpdateItemTrackingAfterPosting(VAR ReservEntry: Record 337);
    // VAR
    //     CurrSourceRefNo: Integer;
    //     ReachedEndOfResvEntries: Boolean;
    // BEGIN
    //     IF NOT ReservEntry.FINDSET(TRUE) THEN
    //         EXIT;

    //     REPEAT
    //         CurrSourceRefNo := ReservEntry."Source Ref. No.";

    //         REPEAT
    //             ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
    //             ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
    //             ReservEntry.MODIFY;
    //             IF ReservEntry.NEXT = 0 THEN
    //                 ReachedEndOfResvEntries := TRUE;
    //         UNTIL ReachedEndOfResvEntries OR (ReservEntry."Source Ref. No." <> CurrSourceRefNo);

    //     // iterate over each set of Source Ref No.
    //     UNTIL ReservEntry."Source Ref. No." = CurrSourceRefNo;
    // END;

    // LOCAL PROCEDURE SynchronizeTransferOutboundToInboundItemTracking(ReservationEntryNo: Integer);
    // VAR
    //     FromReservationEntry: Record 337;
    //     ToReservationEntry: Record 337;
    //     ItemTrackingManagement: Codeunit 6500;
    // BEGIN
    //     IF FromReservationEntry.GET(ReservationEntryNo, FALSE) THEN
    //         IF (FromReservationEntry."Source Type" = DATABASE::"Transfer Line") AND
    //            (FromReservationEntry."Source Subtype" = 0) AND
    //            FromReservationEntry.TrackingExists AND
    //            NeedSynchronizeItemTrackingToOutboundTransfer(FromReservationEntry)
    //         THEN BEGIN
    //             ToReservationEntry := FromReservationEntry;
    //             ToReservationEntry."Source Subtype" := 1;
    //             ItemTrackingManagement.SynchronizeItemTrackingByPtrs(FromReservationEntry, ToReservationEntry);
    //         END;
    // END;

    // LOCAL PROCEDURE NeedSynchronizeItemTrackingToOutboundTransfer(ReservationEntry: Record 337): Boolean;
    // VAR
    //     ItemTrackingMgt: Codeunit 6500;
    //     CurrSourceID: Text;
    // BEGIN
    //     WITH ReservationEntry DO
    //         CurrSourceID :=
    //           ItemTrackingMgt.ComposeRowID(
    //             "Source Type", "Source Subtype", "Source ID", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

    //     IF LastProcessedSourceID = CurrSourceID THEN
    //         EXIT(FALSE);

    //     LastProcessedSourceID := CurrSourceID;
    //     EXIT(TRUE);
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCheckValidity(ReservEntry: Record 337; VAR IsError: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterCopyFromInsertReservEntry(VAR InsertReservEntry: Record 337; VAR ReservEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSignFactor(ReservationEntry: Record 337; VAR Sign: Integer);
    BEGIN
    END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeCreateRemainingReservEntry(VAR ReservationEntry: Record 337; FromReservationEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeCreateRemainingNonSurplusReservEntry(VAR ReservationEntry: Record 337; FromReservationEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeReservEntryInsert(VAR ReservationEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeReservEntryInsertNonSurplus(VAR ReservationEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeSplitNonSurplusReservEntry(VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR ReservationEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeSplitReservEntry(VAR TempTrackingSpecification: Record 336 TEMPORARY; VAR ReservationEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeUseOldReservEntry(VAR ReservEntry: Record 337; VAR InsertReservEntry: Record 337);
    // BEGIN
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnCreateEntryOnBeforeSurplusCondition(VAR ReservEntry: Record 337);
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
    procedure ConvertDocumentTypeToOptionReservationStatus(DocumentType: Enum "Reservation Status"): Option;
    var
        optionValue: Option "Reservation","Tracking","Surplus","Prospect";
    begin
        case DocumentType of
            DocumentType::"Reservation":
                optionValue := optionValue::"Reservation";
            DocumentType::"Tracking":
                optionValue := optionValue::"Tracking";
            DocumentType::"Surplus":
                optionValue := optionValue::"Surplus";
            DocumentType::"Prospect":
                optionValue := optionValue::"Prospect";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure ConvertDocumentTypeToOptionReservationBinding(DocumentType: Enum "Reservation Binding"): Option;
    var
        optionValue: Option " ","Order-to-Order";
    begin
        case DocumentType of
            DocumentType::" ":
                optionValue := optionValue::" ";
            DocumentType::"Order-to-Order":
                optionValue := optionValue::"Order-to-Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;
}







