Codeunit 51367 "Prod. Order Comp.-Reserve 1"
{


    Permissions = TableData 337 = rimd,
                TableData 99000849 = rm;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Reserved quantity cannot be greater than %1', ESP = 'La cantidad reservada no puede ser mayor que %1';
        Text002: TextConst ENU = 'must be filled in when a quantity is reserved', ESP = 'se debe rellenar cuando se ha reservado una cantidad';
        Text003: TextConst ENU = 'must not be changed when a quantity is reserved', ESP = 'no se debe modificar cuando se ha reservado una cantidad';
        Text004: TextConst ENU = 'Codeunit is not initialized correctly.', ESP = 'Codeunit no iniciada correctamente.';
        CreateReservEntry: Codeunit 99000830;
        CreateReservEntry1: Codeunit 51359;
        ReservEngineMgt: Codeunit 99000831;
        ReservMgt: Codeunit 99000845;
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
        DeleteItemTracking: Boolean;

    //[External]
    PROCEDURE CreateReservation(ProdOrderComp : Record 5407;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text004);

      ProdOrderComp.TESTFIELD("Item No.");
      ProdOrderComp.TESTFIELD("Due Date");
      ProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(ProdOrderComp."Remaining Qty. (Base)") < ABS(ProdOrderComp."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(ProdOrderComp."Remaining Qty. (Base)") - ABS(ProdOrderComp."Reserved Qty. (Base)"));

      ProdOrderComp.TESTFIELD("Location Code",SetFromLocationCode);
      ProdOrderComp.TESTFIELD("Variant Code",SetFromVariantCode);
      IF QuantityBase > 0 THEN
        ShipmentDate := ProdOrderComp."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := ProdOrderComp."Due Date";
      END;

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Prod. Order Component",ProdOrderComp.Status.AsInteger(),
        ProdOrderComp."Prod. Order No.",'',ProdOrderComp."Prod. Order Line No.",
        ProdOrderComp."Line No.",ProdOrderComp."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        ProdOrderComp."Item No.",ProdOrderComp."Variant Code",ProdOrderComp."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    // LOCAL PROCEDURE CreateBindingReservation(ProdOrderComp : Record 5407;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal);
    // BEGIN
    //   CreateReservation(ProdOrderComp,Description,ExpectedReceiptDate,Quantity,QuantityBase,'','');
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
    // PROCEDURE SetBinding(Binding : Option " ","Order-to-Order");
    // BEGIN
    //   CreateReservEntry.SetBinding(Binding);
    // END;

    //[External]
    PROCEDURE FilterReservFor(VAR FilterReservEntry: Record 337; ProdOrderComp: Record 5407);
    BEGIN
        FilterReservEntry.SetSourceFilter(
          DATABASE::"Prod. Order Component", ProdOrderComp.Status.AsInteger(), ProdOrderComp."Prod. Order No.", ProdOrderComp."Line No.", FALSE);
        FilterReservEntry.SetSourceFilter('', ProdOrderComp."Prod. Order Line No.");
    END;

    //[External]
    PROCEDURE Caption(ProdOrderComp: Record 5407) CaptionText: Text[80];
    VAR
        ProdOrderLine: Record 5406;
    BEGIN
        ProdOrderLine.GET(
          ProdOrderComp.Status,
          ProdOrderComp."Prod. Order No.", ProdOrderComp."Prod. Order Line No.");
        CaptionText :=
          COPYSTR(
            STRSUBSTNO('%1 %2 %3 %4 %5',
              ProdOrderComp.Status, ProdOrderComp.TABLECAPTION,
              ProdOrderComp."Prod. Order No.", ProdOrderComp."Item No.", ProdOrderLine."Item No.")
            , 1, MAXSTRLEN(CaptionText));
    END;

    //[External]
    // PROCEDURE FindReservEntry(ProdOrderComp : Record 5407;VAR ReservEntry : Record 337) : Boolean;
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
    //   FilterReservFor(ReservEntry,ProdOrderComp);
    //   IF NOT ReservEntry.ISEMPTY THEN
    //     EXIT(ReservEntry.FINDLAST);
    // END;

    //[External]
    // PROCEDURE VerifyChange(VAR NewProdOrderComp : Record 5407;VAR OldProdOrderComp : Record 5407);
    // VAR
    //   ProdOrderComp : Record 5407;
    //   TempReservEntry : Record 337;
    //   ShowError : Boolean;
    //   HasError : Boolean;
    // BEGIN
    //   IF NewProdOrderComp.Status = NewProdOrderComp.Status::Finished THEN
    //     EXIT;
    //   IF Blocked THEN
    //     EXIT;
    //   IF NewProdOrderComp."Line No." = 0 THEN
    //     IF NOT ProdOrderComp.GET(
    //          NewProdOrderComp.Status,
    //          NewProdOrderComp."Prod. Order No.",
    //          NewProdOrderComp."Prod. Order Line No.",
    //          NewProdOrderComp."Line No.")
    //     THEN
    //       EXIT;

    //   NewProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
    //   ShowError := NewProdOrderComp."Reserved Qty. (Base)" <> 0;

    //   IF NewProdOrderComp."Due Date" = 0D THEN
    //     IF ShowError THEN
    //       NewProdOrderComp.FIELDERROR("Due Date",Text002)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewProdOrderComp."Item No." <> OldProdOrderComp."Item No." THEN
    //     IF ShowError THEN
    //       NewProdOrderComp.FIELDERROR("Item No.",Text003)
    //     ELSE
    //       HasError := TRUE;
    //   IF NewProdOrderComp."Location Code" <> OldProdOrderComp."Location Code" THEN
    //     IF ShowError THEN
    //       NewProdOrderComp.FIELDERROR("Location Code",Text003)
    //     ELSE
    //       HasError := TRUE;
    //   IF (NewProdOrderComp."Bin Code" <> OldProdOrderComp."Bin Code") AND
    //      (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
    //         NewProdOrderComp."Item No.",NewProdOrderComp."Bin Code",
    //         NewProdOrderComp."Location Code",NewProdOrderComp."Variant Code",
    //         DATABASE::"Prod. Order Component",NewProdOrderComp.Status,
    //         NewProdOrderComp."Prod. Order No.",'',NewProdOrderComp."Prod. Order Line No.",
    //         NewProdOrderComp."Line No."))
    //   THEN BEGIN
    //     IF ShowError THEN
    //       NewProdOrderComp.FIELDERROR("Bin Code",Text003);
    //     HasError := TRUE;
    //   END;
    //   IF NewProdOrderComp."Variant Code" <> OldProdOrderComp."Variant Code" THEN
    //     IF ShowError THEN
    //       NewProdOrderComp.FIELDERROR("Variant Code",Text003)
    //     ELSE
    //       HasError := TRUE;
    //   IF NewProdOrderComp."Line No." <> OldProdOrderComp."Line No." THEN
    //     HasError := TRUE;

    //   OnVerifyChangeOnBeforeHasError(NewProdOrderComp,OldProdOrderComp,HasError,ShowError);

    //   IF HasError THEN
    //     IF (NewProdOrderComp."Item No." <> OldProdOrderComp."Item No.") OR
    //        FindReservEntry(NewProdOrderComp,TempReservEntry)
    //     THEN BEGIN
    //       IF NewProdOrderComp."Item No." <> OldProdOrderComp."Item No." THEN BEGIN
    //         ReservMgt.SetProdOrderComponent(OldProdOrderComp);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //         ReservMgt.SetProdOrderComponent(NewProdOrderComp);
    //       END ELSE BEGIN
    //         ReservMgt.SetProdOrderComponent(NewProdOrderComp);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //       END;
    //       ReservMgt.AutoTrack(NewProdOrderComp."Remaining Qty. (Base)");
    //     END;

    //   IF HasError OR (NewProdOrderComp."Due Date" <> OldProdOrderComp."Due Date") THEN BEGIN
    //     AssignForPlanning(NewProdOrderComp);
    //     IF (NewProdOrderComp."Item No." <> OldProdOrderComp."Item No.") OR
    //        (NewProdOrderComp."Variant Code" <> OldProdOrderComp."Variant Code") OR
    //        (NewProdOrderComp."Location Code" <> OldProdOrderComp."Location Code")
    //     THEN
    //       AssignForPlanning(OldProdOrderComp);
    //   END;
    // END;

    //[External]
    // PROCEDURE VerifyQuantity(VAR NewProdOrderComp : Record 5407;VAR OldProdOrderComp : Record 5407);
    // VAR
    //   ProdOrderComp : Record 5407;
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH NewProdOrderComp DO BEGIN
    //     IF Status = Status::Finished THEN
    //       EXIT;
    //     IF "Line No." = OldProdOrderComp."Line No." THEN
    //       IF "Remaining Qty. (Base)" = OldProdOrderComp."Remaining Qty. (Base)" THEN
    //         EXIT;
    //     IF "Line No." = 0 THEN
    //       IF NOT ProdOrderComp.GET(Status,"Prod. Order No.","Prod. Order Line No.","Line No.") THEN
    //         EXIT;
    //     ReservMgt.SetProdOrderComponent(NewProdOrderComp);
    //     IF "Qty. per Unit of Measure" <> OldProdOrderComp."Qty. per Unit of Measure" THEN
    //       ReservMgt.ModifyUnitOfMeasure;
    //     IF "Remaining Qty. (Base)" * OldProdOrderComp."Remaining Qty. (Base)" < 0 THEN
    //       ReservMgt.DeleteReservEntries(TRUE,0)
    //     ELSE
    //       ReservMgt.DeleteReservEntries(FALSE,"Remaining Qty. (Base)");
    //     ReservMgt.ClearSurplus;
    //     ReservMgt.AutoTrack("Remaining Qty. (Base)");
    //     AssignForPlanning(NewProdOrderComp);
    //   END;
    // END;

    //[External]
    // PROCEDURE TransferPOCompToPOComp(VAR OldProdOrderComp : Record 5407;VAR NewProdOrderComp : Record 5407;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldProdOrderComp,OldReservEntry) THEN
    //     EXIT;

    //   OldReservEntry.Lock;

    //   NewProdOrderComp.TestItemFields(OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code");

    //   OldReservEntry.TransferReservations(
    //     OldReservEntry,OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code",
    //     TransferAll,TransferQty,NewProdOrderComp."Qty. per Unit of Measure",
    //     DATABASE::"Prod. Order Component",NewProdOrderComp.Status,NewProdOrderComp."Prod. Order No.",'',
    //     NewProdOrderComp."Prod. Order Line No.",NewProdOrderComp."Line No.");
    // END;

    //[External]
    // PROCEDURE TransferPOCompToItemJnlLine(VAR OldProdOrderComp : Record 5407;VAR NewItemJnlLine : Record 83;TransferQty : Decimal);
    // BEGIN
    //   TransferPOCompToItemJnlLineCheckILE(OldProdOrderComp,NewItemJnlLine,TransferQty,FALSE);
    // END;

    //[External]
    // PROCEDURE TransferPOCompToItemJnlLineCheckILE(VAR OldProdOrderComp : Record 5407;VAR NewItemJnlLine : Record 83;TransferQty : Decimal;CheckApplFromItemEntry : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    //   OppositeReservationEntry : Record 337;
    //   ItemTrackingFilterIsSet : Boolean;
    //   EndLoop : Boolean;
    //   TrackedQty : Decimal;
    //   UnTrackedQty : Decimal;
    //   xTransferQty : Decimal;
    // BEGIN
    //   IF NOT FindReservEntry(OldProdOrderComp,OldReservEntry) THEN
    //     EXIT;

    //   IF CheckApplFromItemEntry THEN
    //     IF OppositeReservationEntry.GET(OldReservEntry."Entry No.",NOT OldReservEntry.Positive) THEN
    //       IF OppositeReservationEntry."Source Type" <> DATABASE::"Item Ledger Entry" THEN
    //         EXIT;

    //   // Store initial values
    //   OldReservEntry.CALCSUMS("Quantity (Base)");
    //   TrackedQty := -OldReservEntry."Quantity (Base)";
    //   xTransferQty := TransferQty;

    //   OldReservEntry.Lock;

    //   // Handle Item Tracking on consumption:
    //   CLEAR(CreateReservEntry);
    //   IF NewItemJnlLine."Entry Type" = NewItemJnlLine."Entry Type"::Consumption THEN
    //     IF NewItemJnlLine.TrackingExists THEN BEGIN
    //       CreateReservEntry.SetNewSerialLotNo(NewItemJnlLine."Serial No.",NewItemJnlLine."Lot No.");
    //       // Try to match against Item Tracking on the prod. order line:
    //       OldReservEntry.SetTrackingFilterFromItemJnlLine(NewItemJnlLine);
    //       IF OldReservEntry.ISEMPTY THEN
    //         OldReservEntry.ClearTrackingFilter
    //       ELSE
    //         ItemTrackingFilterIsSet := TRUE;
    //     END;

    //   NewItemJnlLine.TestItemFields(OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code");

    //   IF TransferQty = 0 THEN
    //     EXIT;

    //   IF ReservEngineMgt.InitRecordSet2(OldReservEntry,NewItemJnlLine."Serial No.",NewItemJnlLine."Lot No.") THEN
    //     REPEAT
    //       OldReservEntry.TestItemFields(OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code");

    //       TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
    //           NewItemJnlLine."Entry Type",NewItemJnlLine."Journal Template Name",NewItemJnlLine."Journal Batch Name",0,
    //           NewItemJnlLine."Line No.",NewItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

    //       EndLoop := TransferQty = 0;
    //       IF NOT EndLoop THEN
    //         IF ReservEngineMgt.NEXTRecord(OldReservEntry) = 0 THEN
    //           IF ItemTrackingFilterIsSet THEN BEGIN
    //             OldReservEntry.SETRANGE("Serial No.");
    //             OldReservEntry.SETRANGE("Lot No.");
    //             ItemTrackingFilterIsSet := FALSE;
    //             EndLoop := NOT ReservEngineMgt.InitRecordSet(OldReservEntry);
    //           END ELSE
    //             EndLoop := TRUE;
    //     UNTIL EndLoop;

    //   // Handle remaining transfer quantity
    //   IF TransferQty <> 0 THEN BEGIN
    //     TrackedQty -= (xTransferQty - TransferQty);
    //     UnTrackedQty := OldProdOrderComp."Remaining Qty. (Base)" - TrackedQty;
    //     IF TransferQty > UnTrackedQty THEN BEGIN
    //       ReservMgt.SetProdOrderComponent(OldProdOrderComp);
    //       ReservMgt.DeleteReservEntries(FALSE,OldProdOrderComp."Remaining Qty. (Base)");
    //     END;
    //   END;
    // END;

    //[External]
    // PROCEDURE DeleteLineConfirm(VAR ProdOrderComp : Record 5407) : Boolean;
    // VAR
    //   ReservationEntry : Record 337;
    // BEGIN
    //   WITH ProdOrderComp DO BEGIN
    //     IF NOT FindReservEntry(ProdOrderComp,ReservationEntry) THEN
    //       EXIT(TRUE);

    //     ReservMgt.SetProdOrderComponent(ProdOrderComp);
    //     IF ReservMgt.DeleteItemTrackingConfirm THEN
    //       DeleteItemTracking := TRUE;
    //   END;

    //   EXIT(DeleteItemTracking);
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR ProdOrderComp : Record 5407);
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH ProdOrderComp DO BEGIN
    //     CLEAR(ReservMgt);
    //     ReservMgt.SetProdOrderComponent(ProdOrderComp);
    //     IF DeleteItemTracking THEN
    //       ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     CALCFIELDS("Reserved Qty. (Base)");
    //     AssignForPlanning(ProdOrderComp);
    //   END;
    // END;

    // LOCAL PROCEDURE AssignForPlanning(VAR ProdOrderComp : Record 5407);
    // VAR
    //   PlanningAssignment : Record 99000850;
    // BEGIN
    //   WITH ProdOrderComp DO BEGIN
    //     IF Status = Status::Simulated THEN
    //       EXIT;
    //     IF "Item No." <> '' THEN
    //       PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code","Due Date");
    //   END;
    // END;

    //[External]
    // PROCEDURE Block(SetBlocked : Boolean);
    // BEGIN
    //   Blocked := SetBlocked;
    // END;

    //[External]
    // PROCEDURE CallItemTracking(VAR ProdOrderComp : Record 5407);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ItemTrackingDocMgt : Codeunit 6503;
    //   ItemTrackingLines : Page 6510;
    // BEGIN
    //   IF ProdOrderComp.Status = ProdOrderComp.Status::Finished THEN
    //     ItemTrackingDocMgt.ShowItemTrackingForProdOrderComp(DATABASE::"Prod. Order Component",
    //       ProdOrderComp."Prod. Order No.",ProdOrderComp."Prod. Order Line No.",ProdOrderComp."Line No.")
    //   ELSE BEGIN
    //     ProdOrderComp.TESTFIELD("Item No.");
    //     TrackingSpecification.InitFromProdOrderComp(ProdOrderComp);
    //     ItemTrackingLines.SetSourceSpec(TrackingSpecification,ProdOrderComp."Due Date");
    //     ItemTrackingLines.SetInbound(ProdOrderComp.IsInbound);
    //     ItemTrackingLines.RUNMODAL;
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdateItemTrackingAfterPosting(ProdOrderComponent : Record 5407);
    // VAR
    //   ReservEntry : Record 337;
    //   CreateReservEntry : Codeunit 99000830;
    // BEGIN
    //   // Used for updating Quantity to Handle after posting;
    //   ReservEntry.SetSourceFilter(
    //     DATABASE::"Prod. Order Component",ProdOrderComponent.Status,ProdOrderComponent."Prod. Order No.",
    //     ProdOrderComponent."Line No.",TRUE);
    //   ReservEntry.SetSourceFilter2('',ProdOrderComponent."Prod. Order Line No.");
    //   CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    // END;

    //[External]
    // PROCEDURE BindToPurchase(ProdOrderComp : Record 5407;PurchLine : Record 39;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",'',0,PurchLine."Line No.",
    //     PurchLine."Variant Code",PurchLine."Location Code",PurchLine."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(ProdOrderComp,PurchLine.Description,PurchLine."Expected Receipt Date",ReservQty,ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToProdOrder(ProdOrderComp : Record 5407;ProdOrderLine : Record 5406;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Prod. Order Line",ProdOrderLine.Status,ProdOrderLine."Prod. Order No.",'',ProdOrderLine."Line No.",0,
    //     ProdOrderLine."Variant Code",ProdOrderLine."Location Code",ProdOrderLine."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(ProdOrderComp,ProdOrderLine.Description,ProdOrderLine."Ending Date",ReservQty,ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToRequisition(ProdOrderComp : Record 5407;ReqLine : Record 246;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Requisition Line",
    //     0,ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name",0,ReqLine."Line No.",
    //     ReqLine."Variant Code",ReqLine."Location Code",ReqLine."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(ProdOrderComp,ReqLine.Description,ReqLine."Due Date",ReservQty,ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToAssembly(ProdOrderComp : Record 5407;AsmHeader : Record 900;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Assembly Header",AsmHeader."Document Type",AsmHeader."No.",'',0,0,
    //     AsmHeader."Variant Code",AsmHeader."Location Code",AsmHeader."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(ProdOrderComp,AsmHeader.Description,AsmHeader."Due Date",ReservQty,ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToTransfer(ProdOrderComp : Record 5407;TransLine : Record 5741;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Transfer Line",1,TransLine."Document No.",'',0,TransLine."Line No.",
    //     TransLine."Variant Code",TransLine."Transfer-to Code",TransLine."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(ProdOrderComp,TransLine.Description,TransLine."Receipt Date",ReservQty,ReservQtyBase);
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewProdOrderComp : Record 5407;OldProdOrderComp : Record 5407;VAR HasError : Boolean;VAR ShowError : Boolean);
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
}







