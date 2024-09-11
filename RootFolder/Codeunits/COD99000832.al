Codeunit 51361 "Sales Line-Reserve 1"
{


    Permissions = TableData 337 = rimd,
                TableData 99000850 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        ReservedQtyTooLargeErr: TextConst ENU = 'Reserved quantity cannot be greater than %1.', ESP = 'La cantidad reservada no puede ser mayor que %1.';
        ValueIsEmptyErr: TextConst ENU = 'must be filled in when a quantity is reserved', ESP = 'se debe rellenar cuando se ha reservado una cantidad';
        ValueNotEmptyErr: TextConst ENU = 'must not be filled in when a quantity is reserved', ESP = 'no se debe rellenar cuando se ha reservado una cantidad';
        ValueChangedErr: TextConst ENU = 'must not be changed when a quantity is reserved', ESP = 'no se debe modificar cuando se ha reservado una cantidad';
        CodeunitInitErr: TextConst ENU = 'Codeunit is not initialized correctly.', ESP = 'Codeunit no iniciada correctamente.';
        CreateReservEntry: Codeunit 99000830;
        CreateReservEntry1: Codeunit 51359;
        ReservEngineMgt: Codeunit 99000831;
        ReservMgt: Codeunit 99000845;
        ReservMgt1: Codeunit 51372;
        ItemTrackingMgt: Codeunit 6500;
        Blocked: Boolean;
        SetFromType: Option " ","Sales","Requisition Line","Purchase","Item Journal","BOM Journal","Item Ledger Entry","Service","Job";
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromProdOrderLine: Integer;
        SetFromRefNo: Integer;
        SetFromVariantCode: Code[10];
        SetFromLocationCode: Code[10];
        SetFromSerialNo: Code[50];
        SetFromLotNo: Code[50];
        SetFromQtyPerUOM: Decimal;
        ApplySpecificItemTracking: Boolean;
        OverruleItemTracking: Boolean;
        DeleteItemTracking: Boolean;
        ItemTrkgAlreadyOverruled: Boolean;

    //[External]
    PROCEDURE CreateReservation(SalesLine: Record 37; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal; ForSerialNo: Code[50]; ForLotNo: Code[50]);
    VAR
        ShipmentDate: Date;
        SignFactor: Integer;
    BEGIN
        IF SetFromType = 0 THEN
            ERROR(CodeunitInitErr);

        SalesLine.TESTFIELD(Type, SalesLine.Type::Item);
        SalesLine.TESTFIELD("No.");
        SalesLine.TESTFIELD("Shipment Date");
        SalesLine.CALCFIELDS("Reserved Qty. (Base)");
        IF ABS(SalesLine."Outstanding Qty. (Base)") < ABS(SalesLine."Reserved Qty. (Base)") + QuantityBase THEN
            ERROR(
              ReservedQtyTooLargeErr,
              ABS(SalesLine."Outstanding Qty. (Base)") - ABS(SalesLine."Reserved Qty. (Base)"));

        SalesLine.TESTFIELD("Variant Code", SetFromVariantCode);
        SalesLine.TESTFIELD("Location Code", SetFromLocationCode);

        IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
            SignFactor := 1
        ELSE
            SignFactor := -1;

        IF QuantityBase * SignFactor < 0 THEN
            ShipmentDate := SalesLine."Shipment Date"
        ELSE BEGIN
            ShipmentDate := ExpectedReceiptDate;
            ExpectedReceiptDate := SalesLine."Shipment Date";
        END;

        CreateReservEntry1.CreateReservEntryFor(
          DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(),
          SalesLine."Document No.", '', 0, SalesLine."Line No.", SalesLine."Qty. per Unit of Measure",
          Quantity, QuantityBase, ForSerialNo, ForLotNo);
        CreateReservEntry1.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromProdOrderLine, SetFromRefNo,
          SetFromQtyPerUOM, SetFromSerialNo, SetFromLotNo);
        CreateReservEntry.CreateReservEntry(
          SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code",
          Description, ExpectedReceiptDate, ShipmentDate);

        SetFromType := 0;
    END;

    // LOCAL PROCEDURE CreateBindingReservation(SalesLine: Record 37; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal);
    // BEGIN
    //     CreateReservation(SalesLine, Description, ExpectedReceiptDate, Quantity, QuantityBase, '', '');
    // END;

    //[External]
    PROCEDURE CreateReservationSetFrom(TrackingSpecificationFrom: Record 336);
    BEGIN
        WITH TrackingSpecificationFrom DO BEGIN
            SetFromType := "Source Type";
            SetFromSubtype := "Source Subtype";
            SetFromID := "Source ID";
            SetFromBatchName := "Source Batch Name";
            SetFromProdOrderLine := "Source Prod. Order Line";
            SetFromRefNo := "Source Ref. No.";
            SetFromVariantCode := "Variant Code";
            SetFromLocationCode := "Location Code";
            SetFromSerialNo := "Serial No.";
            SetFromLotNo := "Lot No.";
            SetFromQtyPerUOM := "Qty. per Unit of Measure";
        END;
    END;

    //[External]
    // PROCEDURE SetBinding(Binding: Option " ","Order-to-Order");
    // BEGIN
    //     CreateReservEntry.SetBinding(Binding);
    // END;

    //[External]
    // PROCEDURE SetDisallowCancellation(DisallowCancellation: Boolean);
    // BEGIN
    //     CreateReservEntry.SetDisallowCancellation(DisallowCancellation);
    // END;

    //[External]
    PROCEDURE FilterReservFor(VAR FilterReservEntry: Record 337; SalesLine: Record 37);
    BEGIN
        FilterReservEntry.SetSourceFilter(
          DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", FALSE);
        FilterReservEntry.SetSourceFilter('', 0);
    END;

    //[External]
    // PROCEDURE ReservQuantity(SalesLine: Record 37; VAR QtyToReserve: Decimal; VAR QtyToReserveBase: Decimal);
    // BEGIN
    //     CASE SalesLine."Document Type" OF
    //         SalesLine."Document Type"::Quote,
    //         SalesLine."Document Type"::Order,
    //         SalesLine."Document Type"::Invoice,
    //         SalesLine."Document Type"::"Blanket Order":
    //             BEGIN
    //                 QtyToReserve := SalesLine."Outstanding Quantity";
    //                 QtyToReserveBase := SalesLine."Outstanding Qty. (Base)";
    //             END;
    //         SalesLine."Document Type"::"Return Order",
    //         SalesLine."Document Type"::"Credit Memo":
    //             BEGIN
    //                 QtyToReserve := -SalesLine."Outstanding Quantity";
    //                 QtyToReserveBase := -SalesLine."Outstanding Qty. (Base)"
    //             END;
    //     END;

    //     OnAfterReservQuantity(SalesLine, QtyToReserve, QtyToReserveBase);
    // END;

    //[External]
    // PROCEDURE Caption(SalesLine: Record 37) CaptionText: Text[80];
    // BEGIN
    //     CaptionText :=
    //       STRSUBSTNO('%1 %2 %3', SalesLine."Document Type", SalesLine."Document No.", SalesLine."No.");
    // END;

    //[External]
    PROCEDURE FindReservEntry(SalesLine: Record 37; VAR ReservEntry: Record 337): Boolean;
    BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, SalesLine);
        EXIT(ReservEntry.FINDLAST);
    END;

    //[External]
    PROCEDURE ReservEntryExist(SalesLine: Record 37): Boolean;
    VAR
        ReservEntry: Record 337;
    BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, SalesLine);
        EXIT(NOT ReservEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE VerifyChange(VAR NewSalesLine: Record 37; VAR OldSalesLine: Record 37);
    VAR
        SalesLine: Record 37;
        ShowError: Boolean;
        HasError: Boolean;
    BEGIN
        IF (NewSalesLine.Type <> NewSalesLine.Type::Item) AND (OldSalesLine.Type <> OldSalesLine.Type::Item) THEN
            EXIT;
        IF Blocked THEN
            EXIT;
        IF NewSalesLine."Line No." = 0 THEN
            IF NOT SalesLine.GET(
                 NewSalesLine."Document Type", NewSalesLine."Document No.", NewSalesLine."Line No.")
            THEN
                EXIT;

        NewSalesLine.CALCFIELDS("Reserved Qty. (Base)");
        ShowError := NewSalesLine."Reserved Qty. (Base)" <> 0;

        HasError := TestSalesLineModification(OldSalesLine, NewSalesLine, ShowError);

        OnVerifyChangeOnBeforeHasError(NewSalesLine, OldSalesLine, HasError, ShowError);

        IF HasError THEN
            ClearReservation(OldSalesLine, NewSalesLine);

        IF HasError OR (NewSalesLine."Shipment Date" <> OldSalesLine."Shipment Date") THEN BEGIN
            AssignForPlanning(NewSalesLine);
            IF (NewSalesLine."No." <> OldSalesLine."No.") OR
               (NewSalesLine."Variant Code" <> OldSalesLine."Variant Code") OR
               (NewSalesLine."Location Code" <> OldSalesLine."Location Code")
            THEN
                AssignForPlanning(OldSalesLine);
        END;
    END;

    //[External]
    PROCEDURE VerifyQuantity(VAR NewSalesLine: Record 37; VAR OldSalesLine: Record 37);
    VAR
        SalesLine: Record 37;
    BEGIN
        IF Blocked THEN
            EXIT;

        WITH NewSalesLine DO BEGIN
            IF Type <> Type::Item THEN
                EXIT;
            IF "Document Type" = OldSalesLine."Document Type" THEN
                IF "Line No." = OldSalesLine."Line No." THEN
                    IF "Quantity (Base)" = OldSalesLine."Quantity (Base)" THEN
                        EXIT;
            IF "Line No." = 0 THEN
                IF NOT SalesLine.GET("Document Type", "Document No.", "Line No.") THEN
                    EXIT;
            ReservMgt1.SetSalesLine(NewSalesLine);
            IF "Qty. per Unit of Measure" <> OldSalesLine."Qty. per Unit of Measure" THEN
                ReservMgt.ModifyUnitOfMeasure;
            IF "Outstanding Qty. (Base)" * OldSalesLine."Outstanding Qty. (Base)" < 0 THEN
                ReservMgt.DeleteReservEntries(TRUE, 0)
            ELSE
                ReservMgt.DeleteReservEntries(FALSE, "Outstanding Qty. (Base)");
            ReservMgt.ClearSurplus;
            ReservMgt.AutoTrack("Outstanding Qty. (Base)");
            AssignForPlanning(NewSalesLine);
        END;
    END;

    //[External]
    // PROCEDURE TransferSalesLineToItemJnlLine(VAR SalesLine: Record 37; VAR ItemJnlLine: Record 83; TransferQty: Decimal; VAR CheckApplFromItemEntry: Boolean; OnlyILEReservations: Boolean): Decimal;
    // VAR
    //     OldReservEntry: Record 337;
    //     OppositeReservEntry: Record 337;
    //     NotFullyReserved: Boolean;
    // BEGIN
    //     IF NOT FindReservEntry(SalesLine, OldReservEntry) THEN
    //         EXIT(TransferQty);
    //     OldReservEntry.Lock;
    //     // Handle Item Tracking on drop shipment:
    //     CLEAR(CreateReservEntry);

    //     IF OverruleItemTracking THEN
    //         IF ItemJnlLine.TrackingExists THEN BEGIN
    //             CreateReservEntry1.SetNewSerialLotNo(ItemJnlLine."Serial No.", ItemJnlLine."Lot No.");
    //             CreateReservEntry.SetOverruleItemTracking(NOT ItemTrkgAlreadyOverruled);
    //             // Try to match against Item Tracking on the sales order line:
    //             OldReservEntry.SetTrackingFilterFromItemJnlLine(ItemJnlLine);
    //             IF OldReservEntry.ISEMPTY THEN
    //                 EXIT(TransferQty);
    //         END;

    //     ItemJnlLine.TestItemFields(SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code");

    //     IF TransferQty = 0 THEN
    //         EXIT;

    //     IF ItemJnlLine."Invoiced Quantity" <> 0 THEN
    //         CreateReservEntry.SetUseQtyToInvoice(TRUE);

    //     IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN BEGIN
    //         REPEAT
    //             OldReservEntry.TestItemFields(SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code");

    //             IF ApplySpecificItemTracking AND (ItemJnlLine."Applies-to Entry" <> 0) THEN BEGIN
    //                 CreateReservEntry.SetItemLedgEntryNo(ItemJnlLine."Applies-to Entry");
    //                 CheckApplFromItemEntry := FALSE;
    //             END;

    //             IF ItemJnlLine."Assemble to Order" THEN
    //                 OldReservEntry."Appl.-to Item Entry" :=
    //                   SalesLine.FindOpenATOEntry(OldReservEntry."Lot No.", OldReservEntry."Serial No.");

    //             IF CheckApplFromItemEntry THEN BEGIN
    //                 IF OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Reservation THEN BEGIN
    //                     OppositeReservEntry.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive);
    //                     IF OppositeReservEntry."Source Type" <> DATABASE::"Item Ledger Entry" THEN
    //                         NotFullyReserved := TRUE;
    //                 END ELSE
    //                     NotFullyReserved := TRUE;

    //                 IF OldReservEntry."Item Tracking" <> OldReservEntry."Item Tracking"::None THEN BEGIN
    //                     OldReservEntry.TESTFIELD("Appl.-from Item Entry");
    //                     CreateReservEntry.SetApplyFromEntryNo(OldReservEntry."Appl.-from Item Entry");
    //                     CheckApplFromItemEntry := FALSE;
    //                 END;
    //             END;

    //             IF NOT (ItemJnlLine."Assemble to Order" XOR OldReservEntry."Disallow Cancellation") THEN
    //                 IF NOT VerifyPickedQtyReservToInventory(OldReservEntry, SalesLine, TransferQty) THEN
    //                     IF OnlyILEReservations AND OppositeReservEntry.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive) THEN BEGIN
    //                         IF OppositeReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
    //                             TransferQty := CreateReservEntry.TransferReservEntry(
    //                                 DATABASE::"Item Journal Line", ItemJnlLine."Entry Type", ItemJnlLine."Journal Template Name",
    //                                 ItemJnlLine."Journal Batch Name", 0, ItemJnlLine."Line No.",
    //                                 ItemJnlLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);
    //                     END ELSE
    //                         TransferQty := CreateReservEntry.TransferReservEntry(
    //                             DATABASE::"Item Journal Line", ItemJnlLine."Entry Type", ItemJnlLine."Journal Template Name",
    //                             ItemJnlLine."Journal Batch Name", 0, ItemJnlLine."Line No.",
    //                             ItemJnlLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);
    //         UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    //         CheckApplFromItemEntry := CheckApplFromItemEntry AND NotFullyReserved;
    //     END;
    //     EXIT(TransferQty);
    // END;

    //[External]
    // PROCEDURE TransferSaleLineToSalesLine(VAR OldSalesLine: Record 37; VAR NewSalesLine: Record 37; TransferQty: Decimal);
    // VAR
    //     OldReservEntry: Record 337;
    //     Status: Option "Reservation","Tracking","Surplus","Prospect";
    // BEGIN
    //     // Used for sales quote and blanket order when transferred to order
    //     IF NOT FindReservEntry(OldSalesLine, OldReservEntry) THEN
    //         EXIT;

    //     OldReservEntry.Lock;

    //     NewSalesLine.TestItemFields(OldSalesLine."No.", OldSalesLine."Variant Code", OldSalesLine."Location Code");

    //     FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
    //         IF TransferQty = 0 THEN
    //             EXIT;
    //         OldReservEntry.SETRANGE("Reservation Status", Status);
    //         IF OldReservEntry.FINDSET THEN
    //             REPEAT
    //                 OldReservEntry.TestItemFields(OldSalesLine."No.", OldSalesLine."Variant Code", OldSalesLine."Location Code");
    //                 IF (OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Prospect) AND
    //                    (OldSalesLine."Document Type" IN [OldSalesLine."Document Type"::Quote,
    //                                                      OldSalesLine."Document Type"::"Blanket Order"])
    //                 THEN
    //                     OldReservEntry."Reservation Status" := OldReservEntry."Reservation Status"::Surplus;

    //                 TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Sales Line",
    //                     NewSalesLine."Document Type", NewSalesLine."Document No.", '', 0,
    //                     NewSalesLine."Line No.", NewSalesLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

    //             UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
    //     END;
    // END;

    //[External]
    // PROCEDURE DeleteLineConfirm(VAR SalesLine: Record 37): Boolean;
    // BEGIN
    //     WITH SalesLine DO BEGIN
    //         IF NOT ReservEntryExist(SalesLine) THEN
    //             EXIT(TRUE);

    //         ReservMgt1.SetSalesLine(SalesLine);
    //         IF ReservMgt.DeleteItemTrackingConfirm THEN
    //             DeleteItemTracking := TRUE;
    //     END;

    //     EXIT(DeleteItemTracking);
    // END;

    //[External]
    PROCEDURE DeleteLine(VAR SalesLine: Record 37);
    BEGIN
        WITH SalesLine DO BEGIN
            ReservMgt1.SetSalesLine(SalesLine);
            IF DeleteItemTracking THEN
                ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
            ReservMgt.DeleteReservEntries(TRUE, 0);
            DeleteInvoiceSpecFromLine(SalesLine);
            CALCFIELDS("Reserved Qty. (Base)");
            AssignForPlanning(SalesLine);
        END;
    END;

    //[External]
    PROCEDURE AssignForPlanning(VAR SalesLine: Record 37);
    VAR
        PlanningAssignment: Record 99000850;
    BEGIN
        WITH SalesLine DO BEGIN
            IF "Document Type" <> "Document Type"::Order THEN
                EXIT;
            IF Type <> Type::Item THEN
                EXIT;
            IF "No." <> '' THEN
                PlanningAssignment.ChkAssignOne("No.", "Variant Code", "Location Code", "Shipment Date");
        END;
    END;

    //[External]
    // PROCEDURE CallItemTracking(VAR SalesLine: Record 37);
    // VAR
    //     TrackingSpecification: Record 336;
    //     ItemTrackingLines: Page 6510;
    // BEGIN
    //     TrackingSpecification.InitFromSalesLine(SalesLine);
    //     IF ((SalesLine."Document Type" = SalesLine."Document Type"::Invoice) AND
    //         (SalesLine."Shipment No." <> '')) OR
    //        ((SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") AND
    //         (SalesLine."Return Receipt No." <> ''))
    //     THEN
    //         ItemTrackingLines.SetFormRunMode(2); // Combined shipment/receipt
    //     IF SalesLine."Drop Shipment" THEN BEGIN
    //         ItemTrackingLines.SetFormRunMode(3); // Drop Shipment
    //         IF SalesLine."Purchase Order No." <> '' THEN
    //             ItemTrackingLines.SetSecondSourceRowID(ItemTrackingMgt.ComposeRowID(DATABASE::"Purchase Line",
    //                 1, SalesLine."Purchase Order No.", '', 0, SalesLine."Purch. Order Line No."));
    //     END;
    //     ItemTrackingLines.SetSourceSpec(TrackingSpecification, SalesLine."Shipment Date");
    //     ItemTrackingLines.SetInbound(SalesLine.IsInbound);
    //     ItemTrackingLines.RUNMODAL;
    // END;

    //[External]
    PROCEDURE CallItemTracking2(VAR SalesLine: Record 37; SecondSourceQuantityArray: ARRAY[3] OF Decimal);
    BEGIN
        CallItemTrackingSecondSource(SalesLine, SecondSourceQuantityArray, FALSE);
    END;

    //[External]
    PROCEDURE CallItemTrackingSecondSource(VAR SalesLine: Record 37; SecondSourceQuantityArray: ARRAY[3] OF Decimal; AsmToOrder: Boolean);
    VAR
        TrackingSpecification: Record 336;
        ItemTrackingLines: Page 6510;
    BEGIN
        if SecondSourceQuantityArray[1] = Database::"Warehouse Shipment Line" then
            ItemTrackingLines.SetSecondSourceID(Database::"Warehouse Shipment Line", AsmToOrder);

        TrackingSpecification.InitFromSalesLine(SalesLine);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, SalesLine."Shipment Date");
        ItemTrackingLines.SetSecondSourceQuantity(SecondSourceQuantityArray);
        ItemTrackingLines.RUNMODAL;
    END;

    //[External]
    PROCEDURE RetrieveInvoiceSpecification(VAR SalesLine: Record 37; VAR TempInvoicingSpecification: Record 336 TEMPORARY) OK: Boolean;
    VAR
        SourceSpecification: Record 336;
    BEGIN
        CLEAR(TempInvoicingSpecification);
        IF SalesLine.Type <> SalesLine.Type::Item THEN
            EXIT;
        IF ((SalesLine."Document Type" = SalesLine."Document Type"::Invoice) AND
            (SalesLine."Shipment No." <> '')) OR
           ((SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") AND
            (SalesLine."Return Receipt No." <> ''))
        THEN
            OK := RetrieveInvoiceSpecification2(SalesLine, TempInvoicingSpecification)
        ELSE BEGIN
            SourceSpecification.InitFromSalesLine(SalesLine);
            OK := ItemTrackingMgt.RetrieveInvoiceSpecification(SourceSpecification, TempInvoicingSpecification);
        END;
    END;

    LOCAL PROCEDURE RetrieveInvoiceSpecification2(VAR SalesLine: Record 37; VAR TempInvoicingSpecification: Record 336 TEMPORARY) OK: Boolean;
    VAR
        TrackingSpecification: Record 336;
        ReservEntry: Record 337;
    BEGIN
        // Used for combined shipment/return:
        IF SalesLine.Type <> SalesLine.Type::Item THEN
            EXIT;
        IF NOT FindReservEntry(SalesLine, ReservEntry) THEN
            EXIT;
        ReservEntry.FINDSET;
        REPEAT
            ReservEntry.TESTFIELD("Reservation Status", ReservEntry."Reservation Status"::Prospect);
            ReservEntry.TESTFIELD("Item Ledger Entry No.");
            TrackingSpecification.GET(ReservEntry."Item Ledger Entry No.");
            TempInvoicingSpecification := TrackingSpecification;
            TempInvoicingSpecification."Qty. to Invoice (Base)" :=
              ReservEntry."Qty. to Invoice (Base)";
            TempInvoicingSpecification."Qty. to Invoice" :=
              ROUND(ReservEntry."Qty. to Invoice (Base)" / ReservEntry."Qty. per Unit of Measure", 0.00001);
            TempInvoicingSpecification."Buffer Status" := TempInvoicingSpecification."Buffer Status"::MODIFY;
            TempInvoicingSpecification.INSERT;
            ReservEntry.DELETE;
        UNTIL ReservEntry.NEXT = 0;

        OK := TempInvoicingSpecification.FINDFIRST;
    END;

    //[External]
    PROCEDURE DeleteInvoiceSpecFromHeader(VAR SalesHeader: Record 36);
    VAR
        TrackingSpecification: Record 336;
    BEGIN
        TrackingSpecification.SetSourceFilter(
          DATABASE::"Sales Line", SalesHeader."Document Type".AsInteger(), SalesHeader."No.", -1, FALSE);
        TrackingSpecification.SetSourceFilter('', 0);
        TrackingSpecification.DELETEALL;
    END;

    LOCAL PROCEDURE DeleteInvoiceSpecFromLine(SalesLine: Record 37);
    VAR
        TrackingSpecification: Record 336;
    BEGIN
        TrackingSpecification.SetSourceFilter(
          DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", FALSE);
        TrackingSpecification.SetSourceFilter('', 0);
        TrackingSpecification.DELETEALL;
    END;

    //[External]
    // PROCEDURE UpdateItemTrackingAfterPosting(SalesHeader: Record 36);
    // VAR
    //     ReservEntry: Record 337;
    //     CreateReservEntry: Codeunit 99000830;
    // BEGIN
    //     // Used for updating Quantity to Handle and Quantity to Invoice after posting
    //     ReservEntry.RESET;
    //     ReservEntry.SetSourceFilter(DATABASE::"Sales Line", SalesHeader."Document Type", SalesHeader."No.", -1, TRUE);
    //     ReservEntry.SetSourceFilter2('', 0);
    //     CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    // END;

    //[External]
    // PROCEDURE SetApplySpecificItemTracking(ApplySpecific: Boolean);
    // BEGIN
    //     ApplySpecificItemTracking := ApplySpecific;
    // END;

    //[External]
    // PROCEDURE SetOverruleItemTracking(Overrule: Boolean);
    // BEGIN
    //     OverruleItemTracking := Overrule;
    // END;

    //[External]
    // PROCEDURE Block(SetBlocked: Boolean);
    // BEGIN
    //     Blocked := SetBlocked;
    // END;

    //[External]
    // PROCEDURE SetItemTrkgAlreadyOverruled(HasBeenOverruled: Boolean);
    // BEGIN
    //     ItemTrkgAlreadyOverruled := HasBeenOverruled;
    // END;

    // LOCAL PROCEDURE VerifyPickedQtyReservToInventory(OldReservEntry: Record 337; SalesLine: Record 37; TransferQty: Decimal): Boolean;
    // VAR
    //     WhseShptLine: Record 7321;
    //     NewReservEntry: Record 337;
    // BEGIN
    //     WITH WhseShptLine DO BEGIN
    //         IF NOT READPERMISSION THEN
    //             EXIT(FALSE);

    //         SetSourceFilter(DATABASE::"Sales Line", SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.", FALSE);
    //         SETRANGE(Status, Status::"Partially Picked");
    //         EXIT(FINDFIRST AND NewReservEntry.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive) AND
    //           (OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Reservation) AND
    //           (NewReservEntry."Source Type" <> DATABASE::"Item Ledger Entry") AND ("Qty. Picked (Base)" >= TransferQty));
    //     END;
    // END;

    //[External]
    // PROCEDURE BindToPurchase(SalesLine: Record 37; PurchLine: Record 39; ReservQty: Decimal; ReservQtyBase: Decimal);
    // VAR
    //     TrackingSpecification: Record 336;
    //     ReservationEntry: Record 337;
    // BEGIN
    //     SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //     TrackingSpecification.InitTrackingSpecification2(
    //       DATABASE::"Purchase Line", PurchLine."Document Type", PurchLine."Document No.", '', 0, PurchLine."Line No.",
    //       PurchLine."Variant Code", PurchLine."Location Code", PurchLine."Qty. per Unit of Measure");
    //     CreateReservationSetFrom(TrackingSpecification);
    //     CreateBindingReservation(SalesLine, PurchLine.Description, PurchLine."Expected Receipt Date", ReservQty, ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToProdOrder(SalesLine: Record 37; ProdOrderLine: Record 5406; ReservQty: Decimal; ReservQtyBase: Decimal);
    // VAR
    //     TrackingSpecification: Record 336;
    //     ReservationEntry: Record 337;
    // BEGIN
    //     SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //     TrackingSpecification.InitTrackingSpecification2(
    //       DATABASE::"Prod. Order Line", ProdOrderLine.Status, ProdOrderLine."Prod. Order No.", '', ProdOrderLine."Line No.", 0,
    //       ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Qty. per Unit of Measure");
    //     CreateReservationSetFrom(TrackingSpecification);
    //     CreateBindingReservation(SalesLine, ProdOrderLine.Description, ProdOrderLine."Ending Date", ReservQty, ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToRequisition(SalesLine: Record 37; ReqLine: Record 246; ReservQty: Decimal; ReservQtyBase: Decimal);
    // VAR
    //     TrackingSpecification: Record 336;
    //     ReservationEntry: Record 337;
    // BEGIN
    //     IF SalesLine.Reserve = SalesLine.Reserve::Never THEN
    //         EXIT;
    //     SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //     TrackingSpecification.InitTrackingSpecification2(
    //       DATABASE::"Requisition Line",
    //       0, ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name", 0, ReqLine."Line No.",
    //       ReqLine."Variant Code", ReqLine."Location Code", ReqLine."Qty. per Unit of Measure");
    //     CreateReservationSetFrom(TrackingSpecification);
    //     CreateBindingReservation(SalesLine, ReqLine.Description, ReqLine."Due Date", ReservQty, ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToAssembly(SalesLine: Record 37; AsmHeader: Record 900; ReservQty: Decimal; ReservQtyBase: Decimal);
    // VAR
    //     TrackingSpecification: Record 336;
    //     ReservationEntry: Record 337;
    // BEGIN
    //     SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //     TrackingSpecification.InitTrackingSpecification2(
    //       DATABASE::"Assembly Header", AsmHeader."Document Type", AsmHeader."No.", '', 0, 0,
    //       AsmHeader."Variant Code", AsmHeader."Location Code", AsmHeader."Qty. per Unit of Measure");
    //     CreateReservationSetFrom(TrackingSpecification);
    //     CreateBindingReservation(SalesLine, AsmHeader.Description, AsmHeader."Due Date", ReservQty, ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToTransfer(SalesLine: Record 37; TransLine: Record 5741; ReservQty: Decimal; ReservQtyBase: Decimal);
    // VAR
    //     TrackingSpecification: Record 336;
    //     ReservationEntry: Record 337;
    // BEGIN
    //     SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //     TrackingSpecification.InitTrackingSpecification2(
    //       DATABASE::"Transfer Line", 1, TransLine."Document No.", '', 0, TransLine."Line No.",
    //       TransLine."Variant Code", TransLine."Transfer-to Code", TransLine."Qty. per Unit of Measure");
    //     CreateReservationSetFrom(TrackingSpecification);
    //     CreateBindingReservation(SalesLine, TransLine.Description, TransLine."Receipt Date", ReservQty, ReservQtyBase);
    // END;

    LOCAL PROCEDURE CheckItemNo(VAR SalesLine: Record 37): Boolean;
    VAR
        ReservationEntry: Record 337;
    BEGIN
        ReservationEntry.SETFILTER("Item No.", '<>%1', SalesLine."No.");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source Subtype", SalesLine."Document Type");
        ReservationEntry.SETRANGE("Source ID", SalesLine."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", SalesLine."Line No.");
        EXIT(ReservationEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE ClearReservation(OldSalesLine: Record 37; NewSalesLine: Record 37);
    VAR
        DummyReservEntry: Record 337;
    BEGIN
        IF (NewSalesLine."No." <> OldSalesLine."No.") OR FindReservEntry(NewSalesLine, DummyReservEntry) THEN BEGIN
            IF (NewSalesLine."No." <> OldSalesLine."No.") OR (NewSalesLine.Type <> OldSalesLine.Type) THEN BEGIN
                ReservMgt1.SetSalesLine(OldSalesLine);
                ReservMgt.DeleteReservEntries(TRUE, 0);
                ReservMgt1.SetSalesLine(NewSalesLine);
            END ELSE BEGIN
                ReservMgt1.SetSalesLine(NewSalesLine);
                ReservMgt.DeleteReservEntries(TRUE, 0);
            END;
            ReservMgt.AutoTrack(NewSalesLine."Outstanding Qty. (Base)");
        END;
    END;

    LOCAL PROCEDURE TestSalesLineModification(OldSalesLine: Record 37; NewSalesLine: Record 37; ThrowError: Boolean) HasError: Boolean;
    BEGIN
        IF (NewSalesLine."Shipment Date" = 0D) AND (OldSalesLine."Shipment Date" <> 0D) THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Shipment Date", ValueIsEmptyErr);
            HasError := TRUE;
        END;

        IF NewSalesLine."Job No." <> '' THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Job No.", ValueNotEmptyErr);
            HasError := TRUE;
        END;

        IF NewSalesLine."Purchase Order No." <> '' THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Purchase Order No.", ValueNotEmptyErr);
            HasError := NewSalesLine."Purchase Order No." <> OldSalesLine."Purchase Order No.";
        END;

        IF NewSalesLine."Purch. Order Line No." <> 0 THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Purch. Order Line No.", ValueNotEmptyErr);
            HasError := NewSalesLine."Purch. Order Line No." <> OldSalesLine."Purch. Order Line No.";
        END;

        IF NewSalesLine."Drop Shipment" AND NOT OldSalesLine."Drop Shipment" THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Drop Shipment", ValueNotEmptyErr);
            HasError := TRUE;
        END;

        IF NewSalesLine."Special Order" AND NOT OldSalesLine."Special Order" THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Special Order", ValueNotEmptyErr);
            HasError := TRUE;
        END;

        IF (NewSalesLine."No." <> OldSalesLine."No.") AND NOT CheckItemNo(NewSalesLine) THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("No.", ValueChangedErr);
            HasError := TRUE;
        END;

        IF NewSalesLine."Variant Code" <> OldSalesLine."Variant Code" THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Variant Code", ValueChangedErr);
            HasError := TRUE;
        END;

        IF NewSalesLine."Location Code" <> OldSalesLine."Location Code" THEN BEGIN
            IF ThrowError THEN
                NewSalesLine.FIELDERROR("Location Code", ValueChangedErr);
            HasError := TRUE;
        END;

        IF (OldSalesLine.Type = OldSalesLine.Type::Item) AND (NewSalesLine.Type = NewSalesLine.Type::Item) THEN
            IF (NewSalesLine."Bin Code" <> OldSalesLine."Bin Code") AND
               (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
                  NewSalesLine."No.", NewSalesLine."Bin Code",
                  NewSalesLine."Location Code", NewSalesLine."Variant Code",
                  DATABASE::"Sales Line", NewSalesLine."Document Type".AsInteger(),
                  NewSalesLine."Document No.", '', 0, NewSalesLine."Line No."))
            THEN BEGIN
                IF ThrowError THEN
                    NewSalesLine.FIELDERROR("Bin Code", ValueChangedErr);
                HasError := TRUE;
            END;

        IF NewSalesLine."Line No." <> OldSalesLine."Line No." THEN
            HasError := TRUE;

        IF NewSalesLine.Type <> OldSalesLine.Type THEN
            HasError := TRUE;
    END;

    //[External]
    // PROCEDURE SetDeleteItemTracking(NewDeleteItemTracking: Boolean);
    // BEGIN
    //     DeleteItemTracking := NewDeleteItemTracking
    // END;

    // PROCEDURE CopyReservEntryToTemp(VAR TempReservationEntry: Record 337 TEMPORARY; OldSalesLine: Record 37);
    // VAR
    //     ReservationEntry: Record 337;
    // BEGIN
    //     ReservationEntry.RESET;
    //     ReservationEntry.SetSourceFilter(
    //       DATABASE::"Sales Line", OldSalesLine."Document Type", OldSalesLine."Document No.", OldSalesLine."Line No.", TRUE);
    //     IF ReservationEntry.FINDSET THEN
    //         REPEAT
    //             TempReservationEntry := ReservationEntry;
    //             TempReservationEntry.INSERT;
    //         UNTIL ReservationEntry.NEXT = 0;
    //     ReservationEntry.DELETEALL;
    // END;

    // PROCEDURE CopyReservEntryFromTemp(VAR TempReservationEntry: Record 337 TEMPORARY; OldSalesLine: Record 37; NewSourceRefNo: Integer);
    // VAR
    //     ReservationEntry: Record 337;
    // BEGIN
    //     TempReservationEntry.RESET;
    //     TempReservationEntry.SetSourceFilter(
    //       DATABASE::"Sales Line", OldSalesLine."Document Type", OldSalesLine."Document No.", OldSalesLine."Line No.", TRUE);
    //     IF TempReservationEntry.FINDSET THEN
    //         REPEAT
    //             ReservationEntry := TempReservationEntry;
    //             ReservationEntry."Source Ref. No." := NewSourceRefNo;
    //             ReservationEntry.INSERT;
    //         UNTIL TempReservationEntry.NEXT = 0;
    //     TempReservationEntry.DELETEALL;
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnAfterReservQuantity(SalesLine: Record 37; VAR QtyToReserve: Decimal; VAR QtyToReserveBase: Decimal);
    // BEGIN
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewSalesLine: Record 37; OldSalesLine: Record 37; VAR HasError: Boolean; VAR ShowError: Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







