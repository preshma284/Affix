Codeunit 51368 "Plng. Component-Reserve 1"
{


    Permissions = TableData 337 = rimd,
                TableData 99000849 = rd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Reserved quantity cannot be greater than %1.', ESP = 'La cantidad reservada no puede ser mayor que %1.';
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

    //[External]
    PROCEDURE CreateReservation(PlanningComponent : Record 99000829;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text004);

      PlanningComponent.TESTFIELD("Item No.");
      PlanningComponent.TESTFIELD("Due Date");

      IF ABS(PlanningComponent."Net Quantity (Base)") < ABS(PlanningComponent."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(PlanningComponent."Net Quantity (Base)") - ABS(PlanningComponent."Reserved Qty. (Base)"));

      PlanningComponent.TESTFIELD("Location Code",SetFromLocationCode);
      PlanningComponent.TESTFIELD("Variant Code",SetFromVariantCode);

      IF QuantityBase > 0 THEN
        ShipmentDate := PlanningComponent."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := PlanningComponent."Due Date";
      END;

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Planning Component",0,
        PlanningComponent."Worksheet Template Name",PlanningComponent."Worksheet Batch Name",
        PlanningComponent."Worksheet Line No.",PlanningComponent."Line No.",
        PlanningComponent."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        PlanningComponent."Item No.",PlanningComponent."Variant Code",PlanningComponent."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    // LOCAL PROCEDURE CreateBindingReservation(PlanningComponent : Record 99000829;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal);
    // BEGIN
    //   CreateReservation(PlanningComponent,Description,ExpectedReceiptDate,Quantity,QuantityBase,'','');
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
    PROCEDURE FilterReservFor(VAR FilterReservEntry: Record 337; PlanningComponent: Record 99000829);
    BEGIN
        FilterReservEntry.SetSourceFilter(
          DATABASE::"Planning Component", 0, PlanningComponent."Worksheet Template Name", PlanningComponent."Line No.", FALSE);
        FilterReservEntry.SetSourceFilter(PlanningComponent."Worksheet Batch Name", PlanningComponent."Worksheet Line No.");
    END;

    //[External]
    PROCEDURE Caption(PlanningComponent: Record 99000829) CaptionText: Text[80];
    VAR
        ReqLine: Record 246;
    BEGIN
        ReqLine.GET(
          PlanningComponent."Worksheet Template Name",
          PlanningComponent."Worksheet Batch Name",
          PlanningComponent."Worksheet Line No.");
        CaptionText :=
          STRSUBSTNO('%1 %2 %3 %4',
            PlanningComponent."Worksheet Template Name",
            PlanningComponent."Worksheet Batch Name",
            ReqLine.Type,
            ReqLine."No.");
    END;

    //[External]
    // PROCEDURE FindReservEntry(PlanningComponent : Record 99000829;VAR ReservEntry : Record 337) : Boolean;
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
    //   FilterReservFor(ReservEntry,PlanningComponent);
    //   EXIT(ReservEntry.FINDLAST);
    // END;

    //[External]
    // PROCEDURE VerifyChange(VAR NewPlanningComponent : Record 99000829;VAR OldPlanningComponent : Record 99000829);
    // VAR
    //   PlanningComponent : Record 99000829;
    //   TempReservEntry : Record 337;
    //   ShowError : Boolean;
    //   HasError : Boolean;
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;
    //   IF NewPlanningComponent."Line No." = 0 THEN
    //     IF NOT PlanningComponent.GET(
    //          NewPlanningComponent."Worksheet Template Name",
    //          NewPlanningComponent."Worksheet Batch Name",
    //          NewPlanningComponent."Worksheet Line No.",
    //          NewPlanningComponent."Line No.")
    //     THEN
    //       EXIT;

    //   NewPlanningComponent.CALCFIELDS("Reserved Qty. (Base)");
    //   ShowError := NewPlanningComponent."Reserved Qty. (Base)" <> 0;

    //   IF NewPlanningComponent."Due Date" = 0D THEN
    //     IF ShowError THEN
    //       NewPlanningComponent.FIELDERROR("Due Date",Text002);
    //   HasError := TRUE;
    //   IF NewPlanningComponent."Item No." <> OldPlanningComponent."Item No." THEN
    //     IF ShowError THEN
    //       NewPlanningComponent.FIELDERROR("Item No.",Text003);
    //   HasError := TRUE;
    //   IF NewPlanningComponent."Location Code" <> OldPlanningComponent."Location Code" THEN
    //     IF ShowError THEN
    //       NewPlanningComponent.FIELDERROR("Location Code",Text003);
    //   HasError := TRUE;
    //   IF (NewPlanningComponent."Bin Code" <> OldPlanningComponent."Bin Code") AND
    //      (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
    //         NewPlanningComponent."Item No.",NewPlanningComponent."Bin Code",
    //         NewPlanningComponent."Location Code",NewPlanningComponent."Variant Code",
    //         DATABASE::"Planning Component",0,
    //         NewPlanningComponent."Worksheet Template Name",
    //         NewPlanningComponent."Worksheet Batch Name",NewPlanningComponent."Worksheet Line No.",
    //         NewPlanningComponent."Line No."))
    //   THEN BEGIN
    //     IF ShowError THEN
    //       NewPlanningComponent.FIELDERROR("Bin Code",Text003);
    //     HasError := TRUE;
    //   END;
    //   IF NewPlanningComponent."Variant Code" <> OldPlanningComponent."Variant Code" THEN
    //     IF ShowError THEN
    //       NewPlanningComponent.FIELDERROR("Variant Code",Text003);
    //   HasError := TRUE;
    //   IF NewPlanningComponent."Line No." <> OldPlanningComponent."Line No." THEN
    //     HasError := TRUE;

    //   OnVerifyChangeOnBeforeHasError(NewPlanningComponent,OldPlanningComponent,HasError,ShowError);

    //   IF HasError THEN
    //     IF (NewPlanningComponent."Item No." <> OldPlanningComponent."Item No.") OR
    //        FindReservEntry(NewPlanningComponent,TempReservEntry)
    //     THEN BEGIN
    //       IF NewPlanningComponent."Item No." <> OldPlanningComponent."Item No." THEN BEGIN
    //         ReservMgt.SetPlanningComponent(OldPlanningComponent);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //         ReservMgt.SetPlanningComponent(NewPlanningComponent);
    //       END ELSE BEGIN
    //         ReservMgt.SetPlanningComponent(NewPlanningComponent);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //       END;
    //       ReservMgt.AutoTrack(NewPlanningComponent."Net Quantity (Base)");
    //     END;

    //   IF HasError OR (NewPlanningComponent."Due Date" <> OldPlanningComponent."Due Date") THEN BEGIN
    //     AssignForPlanning(NewPlanningComponent);
    //     IF (NewPlanningComponent."Item No." <> OldPlanningComponent."Item No.") OR
    //        (NewPlanningComponent."Variant Code" <> OldPlanningComponent."Variant Code") OR
    //        (NewPlanningComponent."Location Code" <> OldPlanningComponent."Location Code")
    //     THEN
    //       AssignForPlanning(OldPlanningComponent);
    //   END;
    // END;

    //[External]
    // PROCEDURE VerifyQuantity(VAR NewPlanningComponent : Record 99000829;VAR OldPlanningComponent : Record 99000829);
    // VAR
    //   PlanningComponent : Record 99000829;
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH NewPlanningComponent DO BEGIN
    //     IF "Line No." = OldPlanningComponent."Line No." THEN
    //       IF "Net Quantity (Base)" = OldPlanningComponent."Net Quantity (Base)" THEN
    //         EXIT;
    //     IF "Line No." = 0 THEN
    //       IF NOT PlanningComponent.GET(
    //            "Worksheet Template Name",
    //            "Worksheet Batch Name",
    //            "Worksheet Line No.",
    //            "Line No.")
    //       THEN
    //         EXIT;
    //     ReservMgt.SetPlanningComponent(NewPlanningComponent);
    //     IF "Qty. per Unit of Measure" <> OldPlanningComponent."Qty. per Unit of Measure" THEN
    //       ReservMgt.ModifyUnitOfMeasure;
    //     IF "Net Quantity (Base)" * OldPlanningComponent."Net Quantity (Base)" < 0 THEN
    //       ReservMgt.DeleteReservEntries(TRUE,0)
    //     ELSE
    //       ReservMgt.DeleteReservEntries(FALSE,"Net Quantity (Base)");
    //     ReservMgt.ClearSurplus;
    //     ReservMgt.AutoTrack("Net Quantity (Base)");
    //     AssignForPlanning(NewPlanningComponent);
    //   END;
    // END;

    //[External]
    // PROCEDURE TransferPlanningCompToPOComp(VAR OldPlanningComponent : Record 99000829;VAR NewProdOrderComp : Record 5407;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldPlanningComponent,OldReservEntry) THEN
    //     EXIT;

    //   NewProdOrderComp.TestItemFields(
    //     OldPlanningComponent."Item No.",OldPlanningComponent."Variant Code",OldPlanningComponent."Location Code");

    //   TransferReservations(
    //     OldPlanningComponent,OldReservEntry,TransferAll,TransferQty,NewProdOrderComp."Qty. per Unit of Measure",
    //     DATABASE::"Prod. Order Component",NewProdOrderComp.Status,NewProdOrderComp."Prod. Order No.",
    //     '',NewProdOrderComp."Prod. Order Line No.",NewProdOrderComp."Line No.");
    // END;

    //[External]
    // PROCEDURE TransferPlanningCompToAsmLine(VAR OldPlanningComponent : Record 99000829;VAR NewAsmLine : Record 901;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldPlanningComponent,OldReservEntry) THEN
    //     EXIT;

    //   NewAsmLine.TestItemFields(
    //     OldPlanningComponent."Item No.",OldPlanningComponent."Variant Code",OldPlanningComponent."Location Code");

    //   TransferReservations(
    //     OldPlanningComponent,OldReservEntry,TransferAll,TransferQty,NewAsmLine."Qty. per Unit of Measure",
    //     DATABASE::"Assembly Line",NewAsmLine."Document Type",NewAsmLine."Document No.",
    //     '',0,NewAsmLine."Line No.");
    // END;

    // LOCAL PROCEDURE TransferReservations(VAR OldPlanningComponent : Record 99000829;VAR OldReservEntry : Record 337;TransferAll : Boolean;TransferQty : Decimal;QtyPerUOM : Decimal;SrcType : Integer;SrcSubtype : Option;SrcID : Code[20];SrcBatchName : Code[10];SrcProdOrderLine : Integer;SrcRefNo : Integer);
    // VAR
    //   NewReservEntry : Record 337;
    //   Status : Option "Reservation","Tracking","Surplus","Prospect";
    // BEGIN
    //   OldReservEntry.Lock;

    //   IF TransferAll THEN BEGIN
    //     OldReservEntry.FINDSET;
    //     OldReservEntry.TESTFIELD("Qty. per Unit of Measure",QtyPerUOM);

    //     REPEAT
    //       OldReservEntry.TestItemFields(
    //         OldPlanningComponent."Item No.",OldPlanningComponent."Variant Code",OldPlanningComponent."Location Code");

    //       NewReservEntry := OldReservEntry;
    //       NewReservEntry.SetSource(SrcType,SrcSubtype,SrcID,SrcRefNo,SrcBatchName,SrcProdOrderLine);
    //       NewReservEntry.MODIFY;
    //     UNTIL OldReservEntry.NEXT = 0;
    //   END ELSE
    //     FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
    //       IF TransferQty = 0 THEN
    //         EXIT;
    //       OldReservEntry.SETRANGE("Reservation Status",Status);

    //       IF OldReservEntry.FINDSET THEN
    //         REPEAT
    //           OldReservEntry.TestItemFields(
    //             OldPlanningComponent."Item No.",OldPlanningComponent."Variant Code",OldPlanningComponent."Location Code");

    //           TransferQty :=
    //             CreateReservEntry.TransferReservEntry(
    //               SrcType,SrcSubtype,SrcID,SrcBatchName,SrcProdOrderLine,SrcRefNo,QtyPerUOM,OldReservEntry,TransferQty);
    //         UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
    //     END;
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR PlanningComponent : Record 99000829);
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH PlanningComponent DO BEGIN
    //     ReservMgt.SetPlanningComponent(PlanningComponent);
    //     ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     CALCFIELDS("Reserved Qty. (Base)");
    //     AssignForPlanning(PlanningComponent);
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdateDerivedTracking(VAR PlanningComponent : Record 99000829);
    // VAR
    //   ReservEntry : Record 337;
    //   ReservEntry2 : Record 337;
    //   ActionMessageEntry : Record 99000849;
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
    //   ActionMessageEntry.SETCURRENTKEY("Reservation Entry");

    //   WITH ReservEntry DO BEGIN
    //     SETFILTER("Shipment Date",'<>%1',PlanningComponent."Due Date");
    //     CASE PlanningComponent."Ref. Order Type" OF
    //       PlanningComponent."Ref. Order Type"::"Prod. Order":
    //         SetSourceFilter(
    //           DATABASE::"Prod. Order Component",PlanningComponent."Ref. Order Status",
    //           PlanningComponent."Ref. Order No.",PlanningComponent."Line No.",FALSE);
    //       PlanningComponent."Ref. Order Type"::Assembly:
    //         SetSourceFilter(
    //           DATABASE::"Assembly Line",PlanningComponent."Ref. Order Status",
    //           PlanningComponent."Ref. Order No.",PlanningComponent."Line No.",FALSE);
    //     END;
    //     SETRANGE("Source Prod. Order Line",PlanningComponent."Ref. Order Line No.");
    //     IF FINDSET THEN
    //       REPEAT
    //         ReservEntry2 := ReservEntry;
    //         ReservEntry2."Shipment Date" := PlanningComponent."Due Date";
    //         ReservEntry2.MODIFY;
    //         IF ReservEntry2.GET(ReservEntry2."Entry No.",NOT ReservEntry2.Positive) THEN BEGIN
    //           ReservEntry2."Shipment Date" := PlanningComponent."Due Date";
    //           ReservEntry2.MODIFY;
    //         END;
    //         ActionMessageEntry.SETRANGE("Reservation Entry","Entry No.");
    //         ActionMessageEntry.DELETEALL;
    //       UNTIL NEXT = 0;
    //   END;
    // END;

    // LOCAL PROCEDURE AssignForPlanning(VAR PlanningComponent : Record 99000829);
    // VAR
    //   PlanningAssignment : Record 99000850;
    // BEGIN
    //   WITH PlanningComponent DO
    //     IF "Item No." <> '' THEN
    //       PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code","Due Date");
    // END;

    //[External]
    // PROCEDURE Block(SetBlocked : Boolean);
    // BEGIN
    //   Blocked := SetBlocked;
    // END;

    //[External]
    // PROCEDURE CallItemTracking(VAR PlanningComponent : Record 99000829);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ItemTrackingLines : Page 6510;
    // BEGIN
    //   TrackingSpecification.InitFromProdPlanningComp(PlanningComponent);
    //   ItemTrackingLines.SetSourceSpec(TrackingSpecification,PlanningComponent."Due Date");
    //   ItemTrackingLines.RUNMODAL;
    // END;

    //[External]
    // PROCEDURE BindToRequisition(PlanningComp : Record 99000829;ReqLine : Record 246;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Requisition Line",0,
    //     ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name",0,ReqLine."Line No.",
    //     ReqLine."Variant Code",ReqLine."Location Code",ReqLine."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(PlanningComp,ReqLine.Description,ReqLine."Ending Date",ReservQty,ReservQtyBase);
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewPlanningComponent : Record 99000829;OldPlanningComponent : Record 99000829;VAR HasError : Boolean;VAR ShowError : Boolean);
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
}







