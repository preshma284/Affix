Codeunit 51364 "Item Jnl. Line-Reserve 1"
{
  
  
    Permissions=TableData 337=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='Reserved quantity cannot be greater than %1',ESP='La cantidad reservada no puede ser mayor que %1';
      Text002 : TextConst ENU='must be filled in when a quantity is reserved',ESP='se debe rellenar cuando se ha reservado una cantidad';
      Text003 : TextConst ENU='must not be filled in when a quantity is reserved',ESP='no se debe rellenar cuando se ha reservado una cantidad';
      Text004 : TextConst ENU='must not be changed when a quantity is reserved',ESP='no se debe modificar cuando se ha reservado una cantidad';
      Text005 : TextConst ENU='Codeunit is not initialized correctly.',ESP='Codeunit no iniciada correctamente.';
      ReservMgt : Codeunit 99000845;
      ReservMgt1 : Codeunit 51372;
      CreateReservEntry : Codeunit 99000830;
      CreateReservEntry1 : Codeunit 51359;
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
      Text006 : TextConst ENU='You cannot define item tracking on %1 %2',ESP='No puede definir seguimiento pdto. en %1 %2';
      DeleteItemTracking : Boolean;

    //[External]
    PROCEDURE CreateReservation(VAR ItemJnlLine : Record 83;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text005);

      ItemJnlLine.TESTFIELD("Item No.");
      ItemJnlLine.TESTFIELD("Posting Date");
      ItemJnlLine.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(ItemJnlLine."Quantity (Base)") <
         ABS(ItemJnlLine."Reserved Qty. (Base)") + QuantityBase
      THEN
        ERROR(
          Text000,
          ABS(ItemJnlLine."Quantity (Base)") - ABS(ItemJnlLine."Reserved Qty. (Base)"));

      ItemJnlLine.TESTFIELD("Location Code",SetFromLocationCode);
      ItemJnlLine.TESTFIELD("Variant Code",SetFromVariantCode);

      IF QuantityBase > 0 THEN
        ShipmentDate := ItemJnlLine."Posting Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := ItemJnlLine."Posting Date";
      END;

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Item Journal Line",
        ItemJnlLine."Entry Type".AsInteger(),ItemJnlLine."Journal Template Name",
        ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",ItemJnlLine."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        ItemJnlLine."Item No.",ItemJnlLine."Variant Code",ItemJnlLine."Location Code",
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
    PROCEDURE FilterReservFor(VAR FilterReservEntry : Record 337;ItemJnlLine : Record 83);
    BEGIN
      FilterReservEntry.SetSourceFilter(
        DATABASE::"Item Journal Line",ItemJnlLine."Entry Type".AsInteger(),ItemJnlLine."Journal Template Name",ItemJnlLine."Line No.",FALSE);
      FilterReservEntry.SetSourceFilter(ItemJnlLine."Journal Batch Name",0);
      FilterReservEntry.SetTrackingFilterFromItemJnlLine(ItemJnlLine);
    END;

    //[External]
    PROCEDURE Caption(ItemJnlLine : Record 83) CaptionText : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO(
          '%1 %2 %3',ItemJnlLine."Journal Template Name",ItemJnlLine."Journal Batch Name",
          ItemJnlLine."Item No.");
    END;

    //[External]
    PROCEDURE FindReservEntry(ItemJnlLine : Record 83;VAR ReservEntry : Record 337) : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,ItemJnlLine);

      EXIT(ReservEntry.FINDLAST);
    END;

    //[External]
    PROCEDURE ReservEntryExist(ItemJnlLine : Record 83) : Boolean;
    VAR
      ReservEntry : Record 337;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,ItemJnlLine);
      ReservEntry.ClearTrackingFilter;
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE VerifyChange(VAR NewItemJnlLine : Record 83;VAR OldItemJnlLine : Record 83);
    VAR
      ItemJnlLine : Record 83;
      TempReservEntry : Record 337;
      ItemTrackManagement : Codeunit 6500;
      ItemTrackManagement1 : Codeunit 51151;
      ShowError : Boolean;
      HasError : Boolean;
      SNRequired : Boolean;
      LNRequired : Boolean;
      PointerChanged : Boolean;
    BEGIN
      IF Blocked THEN
        EXIT;
      IF NewItemJnlLine."Line No." = 0 THEN
        IF NOT ItemJnlLine.GET(
             NewItemJnlLine."Journal Template Name",
             NewItemJnlLine."Journal Batch Name",
             NewItemJnlLine."Line No.")
        THEN
          EXIT;

      NewItemJnlLine.CALCFIELDS("Reserved Qty. (Base)");
      ShowError := NewItemJnlLine."Reserved Qty. (Base)" <> 0;

      IF NewItemJnlLine."Posting Date" = 0D THEN
        IF ShowError THEN
          NewItemJnlLine.FIELDERROR("Posting Date",Text002)
        ELSE
          HasError := TRUE;

      IF NewItemJnlLine."Drop Shipment" THEN
        IF ShowError THEN
          NewItemJnlLine.FIELDERROR("Drop Shipment",Text003)
        ELSE
          HasError := TRUE;

      IF NewItemJnlLine."Item No." <> OldItemJnlLine."Item No." THEN
        IF ShowError THEN
          NewItemJnlLine.FIELDERROR("Item No.",Text004)
        ELSE
          HasError := TRUE;

      IF NewItemJnlLine."Entry Type" <> OldItemJnlLine."Entry Type" THEN
        IF ShowError THEN
          NewItemJnlLine.FIELDERROR("Entry Type",Text004)
        ELSE
          HasError := TRUE;

      IF (NewItemJnlLine."Entry Type" = NewItemJnlLine."Entry Type"::Transfer) AND
         (NewItemJnlLine."Quantity (Base)" < 0)
      THEN BEGIN
        IF NewItemJnlLine."New Location Code" <> OldItemJnlLine."Location Code" THEN
          IF ShowError THEN
            NewItemJnlLine.FIELDERROR("New Location Code",Text004)
          ELSE
            HasError := TRUE;
        IF NewItemJnlLine."New Bin Code" <> OldItemJnlLine."Bin Code" THEN BEGIN
          ItemTrackManagement1.CheckWhseItemTrkgSetup(NewItemJnlLine."Item No.",SNRequired,LNRequired,FALSE);
          IF SNRequired OR LNRequired THEN
            IF ShowError THEN
              NewItemJnlLine.FIELDERROR("New Bin Code",Text004)
            ELSE
              HasError := TRUE;
        END
      END ELSE BEGIN
        IF NewItemJnlLine."Location Code" <> OldItemJnlLine."Location Code" THEN
          IF ShowError THEN
            NewItemJnlLine.FIELDERROR("Location Code",Text004)
          ELSE
            HasError := TRUE;
        IF (NewItemJnlLine."Bin Code" <> OldItemJnlLine."Bin Code") AND
           (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
              NewItemJnlLine."Item No.",NewItemJnlLine."Bin Code",
              NewItemJnlLine."Location Code",NewItemJnlLine."Variant Code",
              DATABASE::"Item Journal Line",NewItemJnlLine."Entry Type".AsInteger(),
              NewItemJnlLine."Journal Template Name",NewItemJnlLine."Journal Batch Name",
              0,NewItemJnlLine."Line No."))
        THEN BEGIN
          IF ShowError THEN
            NewItemJnlLine.FIELDERROR("Bin Code",Text004);
          HasError := TRUE;
        END;
      END;
      IF NewItemJnlLine."Variant Code" <> OldItemJnlLine."Variant Code" THEN
        IF ShowError THEN
          NewItemJnlLine.FIELDERROR("Variant Code",Text004)
        ELSE
          HasError := TRUE;
      IF NewItemJnlLine."Line No." <> OldItemJnlLine."Line No." THEN
        HasError := TRUE;

      OnVerifyChangeOnBeforeHasError(NewItemJnlLine,OldItemJnlLine,HasError,ShowError);

      IF HasError THEN BEGIN
        FindReservEntry(NewItemJnlLine,TempReservEntry);
        TempReservEntry.ClearTrackingFilter;

        PointerChanged := (NewItemJnlLine."Item No." <> OldItemJnlLine."Item No.") OR
          (NewItemJnlLine."Entry Type" <> OldItemJnlLine."Entry Type");

        IF PointerChanged OR
           (NOT TempReservEntry.ISEMPTY)
        THEN BEGIN
          IF PointerChanged THEN BEGIN
            ReservMgt1.SetItemJnlLine(OldItemJnlLine);
            ReservMgt1.DeleteReservEntries(TRUE,0);
            ReservMgt1.SetItemJnlLine(NewItemJnlLine);
          END ELSE BEGIN
            ReservMgt1.SetItemJnlLine(NewItemJnlLine);
            ReservMgt.DeleteReservEntries(TRUE,0);
          END;
          ReservMgt.AutoTrack(NewItemJnlLine."Quantity (Base)");
        END;
      END;
    END;

    //[External]
    PROCEDURE VerifyQuantity(VAR NewItemJnlLine : Record 83;VAR OldItemJnlLine : Record 83);
    VAR
      ItemJnlLine : Record 83;
    BEGIN
      OnBeforeVerifyQuantity(NewItemJnlLine,OldItemJnlLine);

      IF Blocked THEN
        EXIT;

      WITH NewItemJnlLine DO BEGIN
        IF "Line No." = OldItemJnlLine."Line No." THEN
          IF "Quantity (Base)" = OldItemJnlLine."Quantity (Base)" THEN
            EXIT;
        IF "Line No." = 0 THEN
          IF NOT ItemJnlLine.GET("Journal Template Name","Journal Batch Name","Line No.") THEN
            EXIT;
        ReservMgt1.SetItemJnlLine(NewItemJnlLine);
        IF "Qty. per Unit of Measure" <> OldItemJnlLine."Qty. per Unit of Measure" THEN
          ReservMgt.ModifyUnitOfMeasure;
        IF "Quantity (Base)" * OldItemJnlLine."Quantity (Base)" < 0 THEN
          ReservMgt.DeleteReservEntries(TRUE,0)
        ELSE
          ReservMgt.DeleteReservEntries(FALSE,"Quantity (Base)");
      END;
    END;

    //[External]
    // PROCEDURE TransferItemJnlToItemLedgEntry(VAR ItemJnlLine : Record 83;VAR ItemLedgEntry : Record 32;TransferQty : Decimal;SkipInventory : Boolean) : Boolean;
    // VAR
    //   OldReservEntry : Record 337;
    //   OldReservEntry2 : Record 337;
    //   Status : Option "Reservation","Tracking","Surplus","Prospect";
    //   SkipThisRecord : Boolean;
    // BEGIN
    //   IF NOT FindReservEntry(ItemJnlLine,OldReservEntry) THEN
    //     EXIT(FALSE);

    //   OldReservEntry.Lock;

    //   ItemLedgEntry.TESTFIELD("Item No.",ItemJnlLine."Item No.");
    //   ItemLedgEntry.TESTFIELD("Variant Code",ItemJnlLine."Variant Code");
    //   IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer THEN BEGIN
    //     ItemLedgEntry.TESTFIELD("Location Code",ItemJnlLine."New Location Code");
    //   END ELSE
    //     ItemLedgEntry.TESTFIELD("Location Code",ItemJnlLine."Location Code");

    //   FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
    //     IF TransferQty = 0 THEN
    //       EXIT(TRUE);
    //     OldReservEntry.SETRANGE("Reservation Status",Status);

    //     IF OldReservEntry.FINDSET THEN
    //       REPEAT
    //         OldReservEntry.TESTFIELD("Item No.",ItemJnlLine."Item No.");
    //         OldReservEntry.TESTFIELD("Variant Code",ItemJnlLine."Variant Code");

    //         IF SkipInventory THEN
    //           IF Status < Status::Surplus THEN BEGIN
    //             OldReservEntry2.GET(OldReservEntry."Entry No.",NOT OldReservEntry.Positive);
    //             SkipThisRecord := OldReservEntry2."Source Type" = DATABASE::"Item Ledger Entry";
    //           END ELSE
    //             SkipThisRecord := FALSE;

    //         IF NOT SkipThisRecord THEN BEGIN
    //           IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer THEN BEGIN
    //             IF ItemLedgEntry.Quantity < 0 THEN
    //               OldReservEntry.TESTFIELD("Location Code",ItemJnlLine."Location Code");
    //             CreateReservEntry.SetInbound(TRUE);
    //           END ELSE
    //             OldReservEntry.TESTFIELD("Location Code",ItemJnlLine."Location Code");

    //           TransferQty :=
    //             CreateReservEntry.TransferReservEntry(
    //               DATABASE::"Item Ledger Entry",0,'','',0,
    //               ItemLedgEntry."Entry No.",ItemLedgEntry."Qty. per Unit of Measure",
    //               OldReservEntry,TransferQty);
    //         END ELSE
    //           IF Status = Status::Tracking THEN BEGIN
    //             OldReservEntry2.DELETE;
    //             OldReservEntry.DELETE;
    //             ReservMgt.ModifyActionMessage(OldReservEntry."Entry No.",0,TRUE);
    //           END;
    //       UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
    //   END; // DO

    //   EXIT(TRUE);
    // END;

    //[External]
    // PROCEDURE RenameLine(VAR NewItemJnlLine : Record 83;VAR OldItemJnlLine : Record 83);
    // BEGIN
    //   ReservEngineMgt.RenamePointer(DATABASE::"Item Journal Line",
    //     OldItemJnlLine."Entry Type",
    //     OldItemJnlLine."Journal Template Name",
    //     OldItemJnlLine."Journal Batch Name",
    //     0,
    //     OldItemJnlLine."Line No.",
    //     NewItemJnlLine."Entry Type",
    //     NewItemJnlLine."Journal Template Name",
    //     NewItemJnlLine."Journal Batch Name",
    //     0,
    //     NewItemJnlLine."Line No.");
    // END;

    //[External]
    // PROCEDURE DeleteLineConfirm(VAR ItemJnlLine : Record 83) : Boolean;
    // BEGIN
    //   WITH ItemJnlLine DO BEGIN
    //     IF NOT ReservEntryExist(ItemJnlLine) THEN
    //       EXIT(TRUE);

    //     ReservMgt.SetItemJnlLine(ItemJnlLine);
    //     IF ReservMgt.DeleteItemTrackingConfirm THEN
    //       DeleteItemTracking := TRUE;
    //   END;

    //   EXIT(DeleteItemTracking);
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR ItemJnlLine : Record 83);
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH ItemJnlLine DO BEGIN
    //     ReservMgt.SetItemJnlLine(ItemJnlLine);
    //     IF DeleteItemTracking THEN
    //       ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     CALCFIELDS("Reserved Qty. (Base)");
    //   END;
    // END;

    //[External]
    // PROCEDURE AssignForPlanning(VAR ItemJnlLine : Record 83);
    // VAR
    //   PlanningAssignment : Record 99000850;
    // BEGIN
    //   IF ItemJnlLine."Item No." <> '' THEN
    //     WITH ItemJnlLine DO BEGIN
    //       PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code","Posting Date");
    //       IF "Entry Type" = "Entry Type"::Transfer THEN
    //         PlanningAssignment.ChkAssignOne("Item No.","Variant Code","New Location Code","Posting Date");
    //     END;
    // END;

    //[External]
    // PROCEDURE Block(SetBlocked : Boolean);
    // BEGIN
    //   Blocked := SetBlocked;
    // END;

    //[External]
    PROCEDURE CallItemTracking(VAR ItemJnlLine : Record 83;IsReclass : Boolean);
    VAR
      TrackingSpecification : Record 336;
      ReservEntry : Record 337;
      ItemTrackingLines : Page 6510;
    BEGIN
      ItemJnlLine.TESTFIELD("Item No.");
      IF NOT ItemJnlLine.ItemPosting THEN BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
        FilterReservFor(ReservEntry,ItemJnlLine);
        ReservEntry.ClearTrackingFilter;
        IF ReservEntry.ISEMPTY THEN
          ERROR(Text006,ItemJnlLine.FIELDCAPTION("Operation No."),ItemJnlLine."Operation No.");
      END;
      TrackingSpecification.InitFromItemJnlLine(ItemJnlLine);
      // IF IsReclass THEN
      //   ItemTrackingLines.SetFormRunMode(1);
      ItemTrackingLines.SetSourceSpec(TrackingSpecification,ItemJnlLine."Posting Date");
      ItemTrackingLines.SetInbound(ItemJnlLine.IsInbound);
      ItemTrackingLines.RUNMODAL;
    END;

    //[External]
    PROCEDURE RegisterBinContentItemTracking(VAR ItemJournalLine : Record 83;VAR TempTrackingSpecification : Record 336 TEMPORARY);
    VAR
      SourceTrackingSpecification : Record 336;
      ItemTrackingLines : Page 6510;
      FormRunMode : Option " ","Reclass","Combined Ship/Rcpt","Drop Shipment","Transfer";
    BEGIN
      IF NOT TempTrackingSpecification.FINDSET THEN
        EXIT;
      SourceTrackingSpecification.InitFromItemJnlLine(ItemJournalLine);

      CLEAR(ItemTrackingLines);
      // ItemTrackingLines.SetFormRunMode(FormRunMode::Reclass);
      ItemTrackingLines.RegisterItemTrackingLines(
        SourceTrackingSpecification,ItemJournalLine."Posting Date",TempTrackingSpecification);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeVerifyQuantity(VAR NewItemJournalLine : Record 83;OldItemJournalLine : Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewItemJnlLine : Record 83;OldItemJnlLine : Record 83;VAR HasError : Boolean;VAR ShowError : Boolean);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







