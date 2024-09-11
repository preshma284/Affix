Codeunit 51365 "Transfer Line-Reserve 1"
{
  
  
    Permissions=TableData 337=rimd,
                TableData 99000850=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='Codeunit is not initialized correctly.',ESP='Codeunit no iniciada correctamente.';
      Text001 : TextConst ENU='Reserved quantity cannot be greater than %1',ESP='La cantidad reservada no puede ser mayor que %1';
      Text002 : TextConst ENU='must be filled in when a quantity is reserved',ESP='se debe rellenar cuando se ha reservado una cantidad';
      Text003 : TextConst ENU='must not be changed when a quantity is reserved',ESP='no se debe modificar cuando se ha reservado una cantidad';
      ReservMgt : Codeunit 99000845;
      ReservMgt1 : Codeunit 51372;
      CreateReservEntry : Codeunit 99000830;
        CreateReservEntry1: Codeunit 51359;
      ReservEngineMgt : Codeunit 99000831;
      Blocked : Boolean;
      SetFromType : Option " ","Sales","Requisition Line","Purchase","Item Journal","BOM Journal","Item Ledger Entry","Service","Job";
      SetFromSubtype : Integer;
      SetFromID : Code[20];
      SetFromBatchName : Code[10];
      SetFromProdOrderLine : Integer;
      SetFromRefNo : Integer;
      SetFromVariantCode : Code[10];
      SetFromLocationCode : Code[10];
      SetFromSerialNo : Code[50];
      SetFromLotNo : Code[50];
      SetFromQtyPerUOM : Decimal;
      DeleteItemTracking : Boolean;

    //[External]
    PROCEDURE CreateReservation(VAR TransLine : Record 5741;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50];Direction : Option "Outbound","Inbound");
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text000);

      TransLine.TESTFIELD("Item No.");
      TransLine.TESTFIELD("Variant Code",SetFromVariantCode);

      CASE Direction OF
        Direction::Outbound:
          BEGIN
            TransLine.TESTFIELD("Shipment Date");
            TransLine.TESTFIELD("Transfer-from Code",SetFromLocationCode);
            TransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
            IF ABS(TransLine."Outstanding Qty. (Base)") <
               ABS(TransLine."Reserved Qty. Outbnd. (Base)") + QuantityBase
            THEN
              ERROR(
                Text001,
                ABS(TransLine."Outstanding Qty. (Base)") - ABS(TransLine."Reserved Qty. Outbnd. (Base)"));
            ShipmentDate := TransLine."Shipment Date";
          END;
        Direction::Inbound:
          BEGIN
            TransLine.TESTFIELD("Receipt Date");
            TransLine.TESTFIELD("Transfer-to Code",SetFromLocationCode);
            TransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
            IF ABS(TransLine."Outstanding Qty. (Base)") <
               ABS(TransLine."Reserved Qty. Inbnd. (Base)") + QuantityBase
            THEN
              ERROR(
                Text001,
                ABS(TransLine."Outstanding Qty. (Base)") - ABS(TransLine."Reserved Qty. Inbnd. (Base)"));
            ExpectedReceiptDate := TransLine."Receipt Date";
            ShipmentDate := GetInboundReservEntryShipmentDate;
          END;
      END;
      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Transfer Line",
        Direction,TransLine."Document No.",'',
        TransLine."Derived From Line No.",TransLine."Line No.",TransLine."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        TransLine."Item No.",TransLine."Variant Code",SetFromLocationCode,
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    //[External]
    PROCEDURE CreateReservationSetFrom(TrackingSpecificationFrom : Record 336);
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
    PROCEDURE FilterReservFor(VAR FilterReservEntry : Record 337;TransLine : Record 5741;Direction : Option "Outbound","Inbound");
    BEGIN
      FilterReservEntry.SetSourceFilter(DATABASE::"Transfer Line",Direction,TransLine."Document No.",TransLine."Line No.",FALSE);
      FilterReservEntry.SetSourceFilter('',TransLine."Derived From Line No.");
    END;

    //[External]
    PROCEDURE Caption(TransLine : Record 5741) CaptionText : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO(
          '%1 %2 %3',TransLine."Document No.",TransLine."Line No.",
          TransLine."Item No.");
    END;

    //[External]
    PROCEDURE FindReservEntry(TransLine : Record 5741;VAR ReservEntry : Record 337;Direction : Option "Outbound","Inbound") : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,TransLine,Direction);
      EXIT(ReservEntry.FINDLAST);
    END;

    //[External]
    // PROCEDURE FindInboundReservEntry(TransLine : Record 5741;VAR ReservEntry : Record 337) : Boolean;
    // VAR
    //   DerivedTransferLine : Record 5741;
    //   Direction : Option "Outbound","Inbound";
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);

    //   DerivedTransferLine.SETRANGE("Document No.",TransLine."Document No.");
    //   DerivedTransferLine.SETRANGE("Derived From Line No.",TransLine."Line No.");
    //   IF NOT DerivedTransferLine.ISEMPTY THEN BEGIN
    //     ReservEntry.SetSourceFilter(DATABASE::"Transfer Line",Direction::Inbound,TransLine."Document No.",-1,FALSE);
    //     ReservEntry.SetSourceFilter('',TransLine."Line No.");
    //   END ELSE
    //     FilterReservFor(ReservEntry,TransLine,Direction::Inbound);
    //   EXIT(ReservEntry.FINDLAST);
    // END;

    LOCAL PROCEDURE ReservEntryExist(TransLine : Record 5741) : Boolean;
    VAR
      ReservEntry : Record 337;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,TransLine,0);
      ReservEntry.SETRANGE("Source Subtype"); // Ignore direction
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE VerifyChange(VAR NewTransLine : Record 5741;VAR OldTransLine : Record 5741);
    VAR
      TransLine : Record 5741;
      TempReservEntry : Record 337;
      ShowErrorInbnd : Boolean;
      ShowErrorOutbnd : Boolean;
      HasErrorInbnd : Boolean;
      HasErrorOutbnd : Boolean;
    BEGIN
      IF Blocked THEN
        EXIT;
      IF NewTransLine."Line No." = 0 THEN
        IF NOT TransLine.GET(NewTransLine."Document No.",NewTransLine."Line No.") THEN
          EXIT;

      NewTransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
      NewTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");

      ShowErrorInbnd := (NewTransLine."Reserved Qty. Inbnd. (Base)" <> 0);
      ShowErrorOutbnd := (NewTransLine."Reserved Qty. Outbnd. (Base)" <> 0);

      IF NewTransLine."Shipment Date" = 0D THEN
        IF ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Shipment Date",Text002)
        ELSE
          HasErrorOutbnd := TRUE;

      IF NewTransLine."Receipt Date" = 0D THEN
        IF ShowErrorInbnd THEN
          NewTransLine.FIELDERROR("Receipt Date",Text002)
        ELSE
          HasErrorInbnd := TRUE;

      IF NewTransLine."Item No." <> OldTransLine."Item No." THEN
        IF ShowErrorInbnd OR ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Item No.",Text003)
        ELSE BEGIN
          HasErrorInbnd := TRUE;
          HasErrorOutbnd := TRUE;
        END;

      IF NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code" THEN
        IF ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Transfer-from Code",Text003)
        ELSE
          HasErrorOutbnd := TRUE;

      IF NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code" THEN
        IF ShowErrorInbnd THEN
          NewTransLine.FIELDERROR("Transfer-to Code",Text003)
        ELSE
          HasErrorInbnd := TRUE;

      IF (NewTransLine."Transfer-from Bin Code" <> OldTransLine."Transfer-from Bin Code") AND
         (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
            NewTransLine."Item No.",NewTransLine."Transfer-from Bin Code",
            NewTransLine."Transfer-from Code",NewTransLine."Variant Code",
            DATABASE::"Transfer Line",0,
            NewTransLine."Document No.",'',NewTransLine."Derived From Line No.",
            NewTransLine."Line No."))
      THEN BEGIN
        IF ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Transfer-from Bin Code",Text003);
        HasErrorOutbnd := TRUE;
      END;

      IF (NewTransLine."Transfer-To Bin Code" <> OldTransLine."Transfer-To Bin Code") AND
         (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
            NewTransLine."Item No.",NewTransLine."Transfer-To Bin Code",
            NewTransLine."Transfer-to Code",NewTransLine."Variant Code",
            DATABASE::"Transfer Line",1,
            NewTransLine."Document No.",'',NewTransLine."Derived From Line No.",
            NewTransLine."Line No."))
      THEN BEGIN
        IF ShowErrorInbnd THEN
          NewTransLine.FIELDERROR("Transfer-To Bin Code",Text003);
        HasErrorInbnd := TRUE;
      END;

      IF NewTransLine."Variant Code" <> OldTransLine."Variant Code" THEN
        IF ShowErrorInbnd OR ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Variant Code",Text003)
        ELSE BEGIN
          HasErrorInbnd := TRUE;
          HasErrorOutbnd := TRUE;
        END;

      IF NewTransLine."Line No." <> OldTransLine."Line No." THEN BEGIN
        HasErrorInbnd := TRUE;
        HasErrorOutbnd := TRUE;
      END;

      OnVerifyChangeOnBeforeHasError(NewTransLine,OldTransLine,HasErrorInbnd,HasErrorOutbnd,ShowErrorInbnd,ShowErrorOutbnd);

      IF HasErrorOutbnd THEN BEGIN
        AutoTracking(OldTransLine,NewTransLine,TempReservEntry,0);
        AssignForPlanning(NewTransLine,0);
        IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
           (NewTransLine."Variant Code" <> OldTransLine."Variant Code") OR
           (NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code")
        THEN
          AssignForPlanning(OldTransLine,0);
      END;

      IF HasErrorInbnd THEN BEGIN
        AutoTracking(OldTransLine,NewTransLine,TempReservEntry,1);
        AssignForPlanning(NewTransLine,1);
        IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
           (NewTransLine."Variant Code" <> OldTransLine."Variant Code") OR
           (NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code")
        THEN
          AssignForPlanning(OldTransLine,1);
      END;
    END;

    //[External]
    // PROCEDURE VerifyQuantity(VAR NewTransLine : Record 5741;VAR OldTransLine : Record 5741);
    // VAR
    //   TransLine : Record 5741;
    //   Direction : Option "Outbound","Inbound";
    // BEGIN
    //   OnBeforeVerifyReserved(NewTransLine,OldTransLine);

    //   IF Blocked THEN
    //     EXIT;

    //   WITH NewTransLine DO BEGIN
    //     IF "Line No." = OldTransLine."Line No." THEN
    //       IF "Quantity (Base)" = OldTransLine."Quantity (Base)" THEN
    //         EXIT;
    //     IF "Line No." = 0 THEN
    //       IF NOT TransLine.GET("Document No.","Line No.") THEN
    //         EXIT;
    //     FOR Direction := Direction::Outbound TO Direction::Inbound DO BEGIN
    //       ReservMgt.SetTransferLine(NewTransLine,Direction);
    //       IF "Qty. per Unit of Measure" <> OldTransLine."Qty. per Unit of Measure" THEN
    //         ReservMgt.ModifyUnitOfMeasure;
    //       ReservMgt.DeleteReservEntries(FALSE,"Outstanding Qty. (Base)");
    //       ReservMgt.ClearSurplus;
    //       ReservMgt.AutoTrack("Outstanding Qty. (Base)");
    //       AssignForPlanning(NewTransLine,Direction);
    //     END;
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdatePlanningFlexibility(VAR TransLine : Record 5741);
    // VAR
    //   ReservEntry : Record 337;
    // BEGIN
    //   IF FindReservEntry(TransLine,ReservEntry,0) THEN
    //     ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
    //   IF FindReservEntry(TransLine,ReservEntry,1) THEN
    //     ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
    // END;

    //[External]
    PROCEDURE TransferTransferToItemJnlLine(VAR TransLine : Record 5741;VAR ItemJnlLine : Record 83;TransferQty : Decimal;Direction : Option "Outbound","Inbound");
    VAR
      OldReservEntry : Record 337;
      TransferLocation : Code[10];
    BEGIN
      IF NOT FindReservEntry(TransLine,OldReservEntry,Direction) THEN
        EXIT;

      OldReservEntry.Lock;

      CASE Direction OF
        Direction::Outbound:
          BEGIN
            TransferLocation := TransLine."Transfer-from Code";
            ItemJnlLine.TESTFIELD("Location Code",TransferLocation);
          END;
        Direction::Inbound:
          BEGIN
            TransferLocation := TransLine."Transfer-to Code";
            ItemJnlLine.TESTFIELD("New Location Code",TransferLocation);
          END;
      END;

      ItemJnlLine.TESTFIELD("Item No.",TransLine."Item No.");
      ItemJnlLine.TESTFIELD("Variant Code",TransLine."Variant Code");

      IF TransferQty = 0 THEN
        EXIT;
      IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
        REPEAT
          OldReservEntry.TestItemFields(TransLine."Item No.",TransLine."Variant Code",TransferLocation);
          OldReservEntry."New Serial No." := OldReservEntry."Serial No.";
          OldReservEntry."New Lot No." := OldReservEntry."Lot No.";

          OnTransferTransferToItemJnlLineTransferFields(OldReservEntry,TransLine,ItemJnlLine,TransferQty,Direction);

          TransferQty :=
            CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
              ItemJnlLine."Entry Type".AsInteger(),ItemJnlLine."Journal Template Name",
              ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
              ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

        UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    END;

    //[External]
    // PROCEDURE TransferWhseShipmentToItemJnlLine(VAR TransLine : Record 5741;VAR ItemJnlLine : Record 83;VAR WhseShptHeader : Record 7320;TransferQty : Decimal);
    // VAR
    //   OldReservEntry : Record 337;
    //   WhseShptLine : Record 7321;
    //   WarehouseEntry : Record 7312;
    //   ItemTrackingMgt : Codeunit 6500;
    //   WhseSNRequired : Boolean;
    //   WhseLNRequired : Boolean;
    //   QtyToHandleBase : Decimal;
    // BEGIN
    //   IF TransferQty = 0 THEN
    //     EXIT;
    //   IF NOT FindReservEntry(TransLine,OldReservEntry,0) THEN
    //     EXIT;

    //   ItemJnlLine.TESTFIELD("Location Code",TransLine."Transfer-from Code");
    //   ItemJnlLine.TESTFIELD("Item No.",TransLine."Item No.");
    //   ItemJnlLine.TESTFIELD("Variant Code",TransLine."Variant Code");

    //   WhseShptLine.GetWhseShptLine(
    //     WhseShptHeader."No.",DATABASE::"Transfer Line",0,TransLine."Document No.",TransLine."Line No.");

    //   OldReservEntry.Lock;
    //   IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
    //     REPEAT
    //       OldReservEntry.TestItemFields(TransLine."Item No.",TransLine."Variant Code",TransLine."Transfer-from Code");
    //       ItemTrackingMgt.CheckWhseItemTrkgSetup(TransLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);

    //       WarehouseEntry.SetSourceFilter(
    //         OldReservEntry."Source Type",OldReservEntry."Source Subtype",
    //         OldReservEntry."Source ID",OldReservEntry."Source Ref. No.",FALSE);
    //       WarehouseEntry.SETRANGE("Whse. Document Type",WarehouseEntry."Whse. Document Type"::Shipment);
    //       WarehouseEntry.SETRANGE("Whse. Document No.",WhseShptLine."No.");
    //       WarehouseEntry.SETRANGE("Whse. Document Line No.",WhseShptLine."Line No.");
    //       WarehouseEntry.SETRANGE("Bin Code",WhseShptHeader."Bin Code");
    //       IF WhseSNRequired THEN
    //         WarehouseEntry.SETRANGE("Serial No.",OldReservEntry."Serial No.");
    //       IF WhseLNRequired THEN
    //         WarehouseEntry.SETRANGE("Lot No.",OldReservEntry."Lot No.");
    //       WarehouseEntry.CALCSUMS("Qty. (Base)");
    //       QtyToHandleBase := -WarehouseEntry."Qty. (Base)";
    //       IF ABS(QtyToHandleBase) > ABS(OldReservEntry."Qty. to Handle (Base)") THEN
    //         QtyToHandleBase := OldReservEntry."Qty. to Handle (Base)";

    //       IF QtyToHandleBase < 0 THEN BEGIN
    //         OldReservEntry."New Serial No." := OldReservEntry."Serial No.";
    //         OldReservEntry."New Lot No." := OldReservEntry."Lot No.";
    //         OldReservEntry."Qty. to Handle (Base)" := QtyToHandleBase;
    //         OldReservEntry."Qty. to Invoice (Base)" := QtyToHandleBase;

    //         TransferQty :=
    //           CreateReservEntry.TransferReservEntry(
    //             DATABASE::"Item Journal Line",
    //             ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",
    //             ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
    //             ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);
    //       END;
    //     UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    // END;

    //[External]
    // PROCEDURE TransferTransferToTransfer(VAR OldTransLine : Record 5741;VAR NewTransLine : Record 5741;TransferQty : Decimal;Direction : Option "Outbound","Inbound";VAR TrackingSpecification : Record 336);
    // VAR
    //   OldReservEntry : Record 337;
    //   Status : Option "Reservation","Tracking","Surplus","Prospect";
    //   TransferLocation : Code[10];
    // BEGIN
    //   // Used when derived Transfer Lines are created during posting of shipment.
    //   IF NOT FindReservEntry(OldTransLine,OldReservEntry,Direction) THEN
    //     EXIT;

    //   OldReservEntry.SetTrackingFilterFromSpec(TrackingSpecification);
    //   IF OldReservEntry.ISEMPTY THEN
    //     EXIT;

    //   OldReservEntry.Lock;

    //   CASE Direction OF
    //     Direction::Outbound:
    //       BEGIN
    //         TransferLocation := OldTransLine."Transfer-from Code";
    //         NewTransLine.TESTFIELD("Transfer-from Code",TransferLocation);
    //       END;
    //     Direction::Inbound:
    //       BEGIN
    //         TransferLocation := OldTransLine."Transfer-to Code";
    //         NewTransLine.TESTFIELD("Transfer-to Code",TransferLocation);
    //       END;
    //   END;

    //   NewTransLine.TESTFIELD("Item No.",OldTransLine."Item No.");
    //   NewTransLine.TESTFIELD("Variant Code",OldTransLine."Variant Code");

    //   FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
    //     IF TransferQty = 0 THEN
    //       EXIT;
    //     OldReservEntry.SETRANGE("Reservation Status",Status);
    //     IF OldReservEntry.FINDSET THEN
    //       REPEAT
    //         OldReservEntry.TestItemFields(OldTransLine."Item No.",OldTransLine."Variant Code",TransferLocation);

    //         TransferQty :=
    //           CreateReservEntry.TransferReservEntry(DATABASE::"Transfer Line",
    //             Direction,NewTransLine."Document No.",'',NewTransLine."Derived From Line No.",
    //             NewTransLine."Line No.",NewTransLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

    //       UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
    //   END;
    // END;

    //[External]
    // PROCEDURE DeleteLineConfirm(VAR TransLine : Record 5741) : Boolean;
    // BEGIN
    //   WITH TransLine DO BEGIN
    //     IF NOT ReservEntryExist(TransLine) THEN
    //       EXIT(TRUE);

    //     ReservMgt.SetTransferLine(TransLine,0);
    //     IF ReservMgt.DeleteItemTrackingConfirm THEN
    //       DeleteItemTracking := TRUE;
    //   END;

    //   EXIT(DeleteItemTracking);
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR TransLine : Record 5741);
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH TransLine DO BEGIN
    //     ReservMgt.SetTransferLine(TransLine,0);
    //     IF DeleteItemTracking THEN
    //       ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     CALCFIELDS("Reserved Qty. Outbnd. (Base)");

    //     ReservMgt.SetTransferLine(TransLine,1);
    //     IF DeleteItemTracking THEN
    //       ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     CALCFIELDS("Reserved Qty. Inbnd. (Base)");
    //   END;
    // END;

    LOCAL PROCEDURE AssignForPlanning(VAR TransLine : Record 5741;Direction : Option "Outbound","Inbound");
    VAR
      PlanningAssignment : Record 99000850;
    BEGIN
      IF TransLine."Item No." <> '' THEN
        WITH TransLine DO
          CASE Direction OF
            Direction::Outbound:
              PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Transfer-to Code","Shipment Date");
            Direction::Inbound:
              PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Transfer-from Code","Receipt Date");
          END;
    END;

    //[External]
    // PROCEDURE Block(SetBlocked : Boolean);
    // BEGIN
    //   Blocked := SetBlocked;
    // END;

    //[External]
    // PROCEDURE CallItemTracking(VAR TransLine : Record 5741;Direction : Option "Outbound","Inbound");
    // VAR
    //   TrackingSpecification : Record 336;
    //   ItemTrackingLines : Page 6510;
    //   AvalabilityDate : Date;
    // BEGIN
    //   TrackingSpecification.InitFromTransLine(TransLine,AvalabilityDate,Direction);
    //   ItemTrackingLines.SetSourceSpec(TrackingSpecification,AvalabilityDate);
    //   ItemTrackingLines.SetInbound(TransLine.IsInbound);
    //   ItemTrackingLines.RUNMODAL;
    //   OnAfterCallItemTracking(TransLine);
    // END;

    //[External]
    PROCEDURE CallItemTracking2(VAR TransLine : Record 5741;Direction : Enum "Transfer Direction";SecondSourceQuantityArray : ARRAY [3] OF Decimal);
    VAR
      TrackingSpecification : Record 336;
      ItemTrackingLines : Page 6510;
      AvailabilityDate : Date;
    BEGIN
      TrackingSpecification.InitFromTransLine(TransLine,AvailabilityDate,Direction);
      ItemTrackingLines.SetSourceSpec(TrackingSpecification,AvailabilityDate);
      ItemTrackingLines.SetSecondSourceQuantity(SecondSourceQuantityArray);
      ItemTrackingLines.RUNMODAL;
      OnAfterCallItemTracking(TransLine);
    END;

    //[External]
    // PROCEDURE UpdateItemTrackingAfterPosting(TransHeader : Record 5740;Direction : Option "Outbound","Inbound");
    // VAR
    //   ReservEntry : Record 337;
    //   ReservEntry2 : Record 337;
    //   CreateReservEntry : Codeunit 99000830;
    // BEGIN
    //   // Used for updating Quantity to Handle after posting;
    //   ReservEntry.SetSourceFilter(DATABASE::"Transfer Line",Direction,TransHeader."No.",-1,TRUE);
    //   ReservEntry.SETRANGE("Source Batch Name",'');
    //   IF Direction = Direction::Outbound THEN
    //     ReservEntry.SETRANGE("Source Prod. Order Line",0)
    //   ELSE
    //     ReservEntry.SETFILTER("Source Prod. Order Line",'<>%1',0);
    //   CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    //   IF Direction = Direction::Outbound THEN BEGIN
    //     ReservEntry2.COPY(ReservEntry);
    //     ReservEntry2.SETRANGE("Source Subtype",Direction::Inbound);
    //     ReservEntry2.SetTrackingFilterFromReservEntry(ReservEntry);
    //     CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry2);
    //   END;
    // END;

    //[External]
    // PROCEDURE RegisterBinContentItemTracking(VAR TransferLine : Record 5741;VAR TempTrackingSpecification : Record 336 TEMPORARY);
    // VAR
    //   SourceTrackingSpecification : Record 336;
    //   ItemTrackingLines : Page 6510;
    //   FormRunMode : Option " ","Reclass","Combined Ship/Rcpt","Drop Shipment","Transfer";
    //   Direction : Option "Outbound","Inbound";
    // BEGIN
    //   IF NOT TempTrackingSpecification.FINDSET THEN
    //     EXIT;
    //   SourceTrackingSpecification.InitFromTransLine(TransferLine,TransferLine."Shipment Date",Direction::Outbound);

    //   CLEAR(ItemTrackingLines);
    //   ItemTrackingLines.SetFormRunMode(FormRunMode::Transfer);
    //   ItemTrackingLines.SetSourceSpec(SourceTrackingSpecification,TransferLine."Shipment Date");
    //   ItemTrackingLines.RegisterItemTrackingLines(
    //     SourceTrackingSpecification,TransferLine."Shipment Date",TempTrackingSpecification);
    // END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDate() InboundReservEntryShipmentDate : Date;
    BEGIN
      CASE SetFromType OF
        DATABASE::"Sales Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateBySalesLine;
        DATABASE::"Purchase Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByPurchaseLine;
        DATABASE::"Transfer Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByTransferLine;
        DATABASE::"Service Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByServiceLine;
        DATABASE::"Job Planning Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByJobPlanningLine;
        DATABASE::"Prod. Order Component":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByProdOrderComponent;
      END;
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByProdOrderComponent() : Date;
    VAR
      ProdOrderComponent : Record 5407;
    BEGIN
      ProdOrderComponent.GET(SetFromSubtype,SetFromID,SetFromProdOrderLine,SetFromRefNo);
      EXIT(ProdOrderComponent."Due Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateBySalesLine() : Date;
    VAR
      SalesLine : Record 37;
    BEGIN
      SalesLine.GET(SetFromSubtype,SetFromID,SetFromRefNo);
      EXIT(SalesLine."Shipment Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByPurchaseLine() : Date;
    VAR
      PurchaseLine : Record 39;
    BEGIN
      PurchaseLine.GET(SetFromSubtype,SetFromID,SetFromRefNo);
      EXIT(PurchaseLine."Expected Receipt Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByTransferLine() : Date;
    VAR
      TransferLine : Record 5741;
    BEGIN
      TransferLine.GET(SetFromID,SetFromRefNo);
      EXIT(TransferLine."Shipment Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByServiceLine() : Date;
    VAR
      ServiceLine : Record 5902;
    BEGIN
      ServiceLine.GET(SetFromSubtype,SetFromID,SetFromRefNo);
      EXIT(ServiceLine."Needed by Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByJobPlanningLine() : Date;
    VAR
      JobPlanningLine : Record 1003;
    BEGIN
      JobPlanningLine.SETRANGE(Status,SetFromSubtype);
      JobPlanningLine.SETRANGE("Job No.",SetFromID);
      JobPlanningLine.SETRANGE("Job Contract Entry No.",SetFromRefNo);
      JobPlanningLine.FINDFIRST;
      EXIT(JobPlanningLine."Planning Date");
    END;

    LOCAL PROCEDURE AutoTracking(OldTransLine : Record 5741;NewTransLine : Record 5741;VAR TempReservEntry : Record 337 TEMPORARY;Direction : Option);
    BEGIN
      IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR FindReservEntry(NewTransLine,TempReservEntry,0) THEN BEGIN
        IF NewTransLine."Item No." <> OldTransLine."Item No." THEN BEGIN
          ReservMgt1.SetTransferLine(OldTransLine,Direction);
          ReservMgt.DeleteReservEntries(TRUE,0);
          ReservMgt1.SetTransferLine(NewTransLine,Direction);
        END ELSE BEGIN
          ReservMgt1.SetTransferLine(NewTransLine,Direction);
          ReservMgt.DeleteReservEntries(TRUE,0);
        END;
        ReservMgt.AutoTrack(NewTransLine."Outstanding Qty. (Base)");
      END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterCallItemTracking(VAR TransferLine : Record 5741);
    BEGIN
    END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnBeforeVerifyReserved(VAR NewTransferLine : Record 5741;OldfTransferLine : Record 5741);
    // BEGIN
    // END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnTransferTransferToItemJnlLineTransferFields(VAR ReservationEntry : Record 337;VAR TransferLine : Record 5741;VAR ItemJournalLine : Record 83;TransferQty : Decimal;Direction : Option "Outbound","Inbound");
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewTransLine : Record 5741;OldTransLine : Record 5741;VAR HasErrorInbnd : Boolean;VAR HasErrorOutbnd : Boolean;VAR ShowErrorInbnd : Boolean;VAR ShowErrorOutbnd : Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







