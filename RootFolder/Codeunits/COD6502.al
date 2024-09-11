Codeunit 51153 "Late Binding Management 1"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      TempCurrSupplyReservEntry : Record 337 TEMPORARY;
      TempCurrDemandReservEntry : Record 337 TEMPORARY;
      TempSupplyReservEntry : Record 337 TEMPORARY;
      TempReservEntryDelete : Record 337 TEMPORARY;
      TempReservEntryModify : Record 337 TEMPORARY;
      TempReservEntryInsert : Record 337 TEMPORARY;
      ReservMgt : Codeunit 99000845;
      LastEntryNo : Integer;
      Text001 : TextConst ENU='Not enough free supply available for reallocation.',ESP='No hay suficiente suministro disponible para la reasignaci�n.';

    LOCAL PROCEDURE CleanUpVariables();
    BEGIN
      CLEARALL;
      TempReservEntryDelete.RESET;
      TempReservEntryDelete.DELETEALL;
      TempReservEntryModify.RESET;
      TempReservEntryModify.DELETEALL;
      TempReservEntryInsert.RESET;
      TempReservEntryInsert.DELETEALL;
      TempCurrSupplyReservEntry.RESET;
      TempCurrSupplyReservEntry.DELETEALL;
      TempCurrDemandReservEntry.RESET;
      TempCurrDemandReservEntry.DELETEALL;
      TempSupplyReservEntry.RESET;
      TempSupplyReservEntry.DELETEALL;
    END;

    //[External]
    // PROCEDURE ReallocateTrkgSpecification(VAR TempTrackingSpecification : Record 336 TEMPORARY);
    // BEGIN
    //   // Go through the tracking specification and calculate what is available/reserved/can be reallocated
    //   // The buffer fields on TempTrackingSpecification are used as follows:
    //   // "Buffer Value1" : Non-allocated item tracking
    //   // "Buffer Value2" : Total inventory
    //   // "Buffer Value3" : Total reserved inventory
    //   // "Buffer Value4" : Qty for reallocation (negative = need for reallocation)
    //   // "Buffer Value5" : Total non-specific reserved inventory (can be un-reserved through reallocation)

    //   CleanUpVariables;

    //   TempTrackingSpecification.CALCSUMS("Buffer Value1"); // Non-allocated item tracking

    //   IF TempTrackingSpecification."Buffer Value1" = 0 THEN
    //     EXIT; // Item tracking is fully allocated => no basis for reallocation

    //   IF NOT CalcInventory(TempTrackingSpecification) THEN
    //     EXIT; // No reservations exist => no basis for reallocation

    //   TempTrackingSpecification.SETFILTER("Buffer Value4",'< %1',0);
    //   IF TempTrackingSpecification.ISEMPTY THEN BEGIN
    //     TempTrackingSpecification.RESET;
    //     EXIT; // Supply is available - no need for reallocation
    //   END;

    //   TempTrackingSpecification.RESET;

    //   // Try to free sufficient supply by reallocation within the tracking specification
    //   CalcAllocations(TempTrackingSpecification);

    //   TempTrackingSpecification.RESET;
    //   TempTrackingSpecification.CALCSUMS("Buffer Value4");

    //   IF TempTrackingSpecification."Buffer Value4" < 0 THEN
    //     IF NOT PrepareTempDataSet(TempTrackingSpecification,ABS(TempTrackingSpecification."Buffer Value4")) THEN
    //       EXIT; // There is not sufficient free supply to cover reallocation

    //   TempTrackingSpecification.RESET;
    //   Reallocate(TempTrackingSpecification);

    //   // Write to database in the end
    //   WriteToDatabase;
    // END;

    LOCAL PROCEDURE Reallocate(VAR TempTrackingSpecification : Record 336 TEMPORARY) AllocationsChanged : Boolean;
    VAR
      TempTrackingSpecification2 : Record 336 TEMPORARY;
      QtyToReallocate : Decimal;
    BEGIN
      TempTrackingSpecification.RESET;
      TempTrackingSpecification.SETFILTER("Buffer Value4",'< %1',0);
      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          TempTrackingSpecification2 := TempTrackingSpecification;
          TempTrackingSpecification2.INSERT;
        UNTIL TempTrackingSpecification.NEXT = 0;
      TempTrackingSpecification.RESET;

      TempCurrSupplyReservEntry.RESET;
      IF TempTrackingSpecification2.FINDSET THEN
        REPEAT
          // TempCurrSupplyReservEntry.SetTrackingFilter(
          //   TempTrackingSpecification2."Serial No.",TempTrackingSpecification2."Lot No.");
          QtyToReallocate := ABS(TempTrackingSpecification2."Buffer Value4");
          IF TempCurrSupplyReservEntry.FINDSET THEN
            REPEAT
              QtyToReallocate := ReshuffleReservEntry(TempCurrSupplyReservEntry,QtyToReallocate,TempTrackingSpecification);
            UNTIL (TempCurrSupplyReservEntry.NEXT = 0) OR (QtyToReallocate = 0);
          AllocationsChanged := AllocationsChanged OR (QtyToReallocate <> ABS(TempTrackingSpecification2."Buffer Value4"));
        UNTIL TempTrackingSpecification2.NEXT = 0;
    END;

    LOCAL PROCEDURE PrepareTempDataSet(VAR TempTrackingSpecification : Record 336 TEMPORARY;QtyToPrepare : Decimal) : Boolean;
    VAR
      ItemLedgEntry : Record 32;
      ReservEntry2 : Record 337;
    BEGIN
      IF QtyToPrepare <= 0 THEN
        EXIT(TRUE);

      TempTrackingSpecification.RESET;

      ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
      ItemLedgEntry.SETRANGE("Item No.",TempTrackingSpecification."Item No.");
      ItemLedgEntry.SETRANGE("Variant Code",TempTrackingSpecification."Variant Code");
      ItemLedgEntry.SETRANGE("Location Code",TempTrackingSpecification."Location Code");
      ItemLedgEntry.SETRANGE(Positive,TRUE);
      ItemLedgEntry.SETRANGE(Open,TRUE);

      ReservEntry2.SetSourceFilter(DATABASE::"Item Ledger Entry",0,'',-1,TRUE);
      ReservEntry2.SETRANGE("Untracked Surplus",FALSE);
      IF ItemLedgEntry.FINDSET THEN
        REPEAT
          // TempTrackingSpecification.SetTrackingFilter(ItemLedgEntry."Serial No.",ItemLedgEntry."Lot No.");
          IF TempTrackingSpecification.ISEMPTY THEN BEGIN
            InsertTempSupplyReservEntry(ItemLedgEntry);
            // GET record
            QtyToPrepare -= ItemLedgEntry."Remaining Quantity";
            TempSupplyReservEntry.GET(-ItemLedgEntry."Entry No.",TRUE);
            ReservEntry2.SETRANGE("Source Ref. No.",ItemLedgEntry."Entry No.");
            IF ReservEntry2.FINDSET THEN
              REPEAT
                TempSupplyReservEntry."Quantity (Base)" -= ReservEntry2."Quantity (Base)";
                TempSupplyReservEntry.MODIFY;

                IF ReservEntry2."Reservation Status" = ReservEntry2."Reservation Status"::Surplus THEN BEGIN
                  TempSupplyReservEntry := ReservEntry2;
                  TempSupplyReservEntry.INSERT;
                END ELSE
                  QtyToPrepare += ReservEntry2."Quantity (Base)";
              UNTIL ReservEntry2.NEXT = 0;
            IF TempSupplyReservEntry."Quantity (Base)" = 0 THEN
              TempSupplyReservEntry.DELETE
          END;
        UNTIL (ItemLedgEntry.NEXT = 0) OR (QtyToPrepare <= 0);

      TempTrackingSpecification.RESET;
      EXIT(QtyToPrepare <= 0);
    END;

    LOCAL PROCEDURE ReshuffleReservEntry(SupplyReservEntry : Record 337;QtyToReshuffle : Decimal;VAR TempTrackingSpecification : Record 336 TEMPORARY) RemainingQty : Decimal;
    VAR
      TotalAvailable : Decimal;
      QtyToReshuffleThisLine : Decimal;
      xQtyToReshuffleThisLine : Decimal;
      AdjustmentQty : Decimal;
      NewQty : Decimal;
      xQty : Decimal;
    BEGIN
      IF SupplyReservEntry."Reservation Status".AsInteger() > SupplyReservEntry."Reservation Status"::Tracking.AsInteger() THEN
        EXIT; // The entry is neither reservation nor tracking and cannot be reshuffled

      IF NOT SupplyReservEntry.Positive THEN
        EXIT; // The entry is not supply and cannot be reshuffled

      TempCurrDemandReservEntry.GET(SupplyReservEntry."Entry No.",NOT SupplyReservEntry.Positive); // Demand

      IF TempCurrDemandReservEntry.TrackingExists THEN // The reservation is not open
        EXIT; // The entry is a specific allocation and cannot be reshuffled

      IF QtyToReshuffle <= 0 THEN
        EXIT;

      TempSupplyReservEntry.CALCSUMS("Quantity (Base)");
      TotalAvailable := TempSupplyReservEntry."Quantity (Base)";

      IF TotalAvailable < QtyToReshuffle THEN
        ERROR(Text001);

      IF SupplyReservEntry."Quantity (Base)" > QtyToReshuffle THEN
        QtyToReshuffleThisLine := QtyToReshuffle
      ELSE
        QtyToReshuffleThisLine := SupplyReservEntry."Quantity (Base)";

      xQtyToReshuffleThisLine := QtyToReshuffleThisLine;

      TempSupplyReservEntry.SETRANGE("Reservation Status",TempSupplyReservEntry."Reservation Status"::Surplus);
      IF TempSupplyReservEntry.FINDSET THEN
        REPEAT
          // TempTrackingSpecification.SetTrackingFilter(TempSupplyReservEntry."Serial No.",TempSupplyReservEntry."Lot No.");
          IF TempTrackingSpecification.FINDFIRST THEN BEGIN
            IF TempTrackingSpecification."Buffer Value4" > 0 THEN BEGIN
              IF TempTrackingSpecification."Buffer Value4" < QtyToReshuffleThisLine THEN BEGIN
                AdjustmentQty := QtyToReshuffleThisLine - TempTrackingSpecification."Buffer Value4";
                QtyToReshuffleThisLine := TempTrackingSpecification."Buffer Value4";
              END ELSE
                AdjustmentQty := 0;

              xQty := QtyToReshuffleThisLine;
              QtyToReshuffleThisLine := MakeConnection(TempSupplyReservEntry,TempCurrDemandReservEntry,QtyToReshuffleThisLine);
              TempTrackingSpecification."Buffer Value4" -= (xQty - QtyToReshuffleThisLine);
              TempTrackingSpecification.MODIFY;
              QtyToReshuffleThisLine += AdjustmentQty;
            END;
          END ELSE
            QtyToReshuffleThisLine := MakeConnection(TempSupplyReservEntry,TempCurrDemandReservEntry,QtyToReshuffleThisLine);

        UNTIL (TempSupplyReservEntry.NEXT = 0) OR (QtyToReshuffleThisLine = 0);

      RemainingQty := QtyToReshuffle - xQtyToReshuffleThisLine + QtyToReshuffleThisLine;

      // Modify the original demand/supply entries

      NewQty := SupplyReservEntry."Quantity (Base)" - xQtyToReshuffleThisLine + QtyToReshuffleThisLine;
      IF NewQty = 0 THEN BEGIN
        TempReservEntryDelete := SupplyReservEntry;
        TempReservEntryDelete.INSERT;
        TempReservEntryDelete := TempCurrDemandReservEntry;
        TempReservEntryDelete.INSERT;
      END ELSE BEGIN
        TempReservEntryModify := SupplyReservEntry;
        TempReservEntryModify."Quantity (Base)" := NewQty;
        TempReservEntryModify.INSERT;
        TempReservEntryModify := TempCurrDemandReservEntry;
        TempReservEntryModify."Quantity (Base)" := -NewQty;
        TempReservEntryModify.INSERT;
      END;

      TempTrackingSpecification.RESET;
    END;

    LOCAL PROCEDURE MakeConnection(VAR SupplySurplusEntry : Record 337;VAR DemandReservEntry : Record 337;QtyToReshuffle : Decimal) RemainingQty : Decimal;
    VAR
      NewEntryNo : Integer;
    BEGIN
      IF SupplySurplusEntry."Quantity (Base)" = 0 THEN
        EXIT(QtyToReshuffle);

      IF SupplySurplusEntry."Quantity (Base)" <= QtyToReshuffle THEN BEGIN
        // Convert supply surplus fully
        IF SupplySurplusEntry."Entry No." < 0 THEN BEGIN // Item Ledger Entry temporary record
          LastEntryNo := LastEntryNo + 1;
          NewEntryNo := -LastEntryNo;
        END ELSE
          NewEntryNo := SupplySurplusEntry."Entry No.";

        TempReservEntryInsert := DemandReservEntry;
        TempReservEntryInsert."Entry No." := NewEntryNo;
        TempReservEntryInsert."Expected Receipt Date" := SupplySurplusEntry."Expected Receipt Date";
        TempReservEntryInsert."Quantity (Base)" := -SupplySurplusEntry."Quantity (Base)";
        TempReservEntryInsert.INSERT;

        TempReservEntryModify := SupplySurplusEntry;
        TempReservEntryModify."Entry No." := NewEntryNo;
        TempReservEntryModify."Reservation Status" := DemandReservEntry."Reservation Status";
        TempReservEntryModify."Shipment Date" := DemandReservEntry."Shipment Date";

        IF SupplySurplusEntry."Entry No." < 0 THEN BEGIN // Entry does not really exist
          TempReservEntryInsert := TempReservEntryModify;
          TempReservEntryInsert.INSERT;
        END ELSE
          TempReservEntryModify.INSERT;

        RemainingQty := QtyToReshuffle - SupplySurplusEntry."Quantity (Base)";
        SupplySurplusEntry."Quantity (Base)" := 0;
        SupplySurplusEntry.MODIFY;
      END ELSE BEGIN
        IF SupplySurplusEntry."Entry No." > 0 THEN BEGIN
          TempReservEntryModify := SupplySurplusEntry;
          TempReservEntryModify."Quantity (Base)" -= QtyToReshuffle;
          TempReservEntryModify.INSERT;
        END;

        LastEntryNo := LastEntryNo + 1;
        NewEntryNo := -LastEntryNo;
        TempReservEntryInsert := SupplySurplusEntry;
        TempReservEntryInsert."Entry No." := NewEntryNo;
        TempReservEntryInsert."Reservation Status" := DemandReservEntry."Reservation Status";
        TempReservEntryInsert.VALIDATE("Quantity (Base)",QtyToReshuffle);
        TempReservEntryInsert."Shipment Date" := DemandReservEntry."Shipment Date";
        TempReservEntryInsert.INSERT;

        TempReservEntryInsert := DemandReservEntry;
        TempReservEntryInsert."Entry No." := NewEntryNo;
        TempReservEntryInsert."Expected Receipt Date" := SupplySurplusEntry."Expected Receipt Date";
        TempReservEntryInsert.VALIDATE("Quantity (Base)",-QtyToReshuffle);
        TempReservEntryInsert.INSERT;

        SupplySurplusEntry."Quantity (Base)" -= QtyToReshuffle;
        SupplySurplusEntry.MODIFY;
        RemainingQty := 0;
      END;
    END;

    LOCAL PROCEDURE WriteToDatabase();
    VAR
      ReservEntry : Record 337;
      PrevNegEntryNo : Integer;
      LastInsertedEntryNo : Integer;
    BEGIN
      TempReservEntryDelete.RESET;
      TempReservEntryModify.RESET;
      TempReservEntryInsert.RESET;

      IF TempReservEntryDelete.FINDSET THEN
        REPEAT
          ReservEntry := TempReservEntryDelete;
          ReservEntry.DELETE;
        UNTIL TempReservEntryDelete.NEXT = 0;

      IF TempReservEntryModify.FINDSET THEN
        REPEAT
          ReservEntry := TempReservEntryModify;
          ReservEntry.VALIDATE("Quantity (Base)");
          ReservEntry.MODIFY;
        UNTIL TempReservEntryModify.NEXT = 0;

      IF TempReservEntryInsert.FINDSET THEN
        REPEAT
          ReservEntry := TempReservEntryInsert;
          IF ReservEntry."Entry No." < 0 THEN
            IF ReservEntry."Entry No." = PrevNegEntryNo THEN
              ReservEntry."Entry No." := LastInsertedEntryNo
            ELSE BEGIN
              PrevNegEntryNo := ReservEntry."Entry No.";
              ReservEntry."Entry No." := 0;
            END;
          ReservEntry.VALIDATE("Quantity (Base)");
          ReservEntry.UpdateItemTracking;
          ReservEntry.INSERT;
          LastInsertedEntryNo := ReservEntry."Entry No.";
        UNTIL TempReservEntryInsert.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcInventory(VAR TempTrackingSpecification : Record 336 TEMPORARY) : Boolean;
    VAR
      ItemLedgEntry : Record 32;
      ReservEntry : Record 337;
      TotalReservedQty : Decimal;
    BEGIN
      ReservEntry.LOCKTABLE;
      ReservEntry.SETCURRENTKEY("Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code");
      ReservEntry.SETRANGE("Item No.",TempTrackingSpecification."Item No.");
      ReservEntry.SETRANGE("Variant Code",TempTrackingSpecification."Variant Code");
      ReservEntry.SETRANGE("Location Code",TempTrackingSpecification."Location Code");
      ReservEntry.SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
      ReservEntry.SETRANGE("Source Subtype",0);
      ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
      ReservEntry.SETFILTER("Item Tracking",'<> %1',ReservEntry."Item Tracking"::None);

      IF ReservEntry.ISEMPTY THEN  // No reservations with Item Tracking exist against inventory - no basis for reallocation.
        EXIT(FALSE);

      ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
      ItemLedgEntry.SETRANGE("Item No.",TempTrackingSpecification."Item No.");
      ItemLedgEntry.SETRANGE("Variant Code",TempTrackingSpecification."Variant Code");
      ItemLedgEntry.SETRANGE("Location Code",TempTrackingSpecification."Location Code");
      ItemLedgEntry.SETRANGE(Positive,TRUE);
      ItemLedgEntry.SETRANGE(Open,TRUE);

      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          ItemLedgEntry.SETRANGE("Serial No.",TempTrackingSpecification."Serial No.");
          ItemLedgEntry.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.");

          IF ItemLedgEntry.FINDSET THEN
            REPEAT
              TempTrackingSpecification."Buffer Value2" += ItemLedgEntry."Remaining Quantity";
              ItemLedgEntry.CALCFIELDS("Reserved Quantity");
              TempTrackingSpecification."Buffer Value3" += ItemLedgEntry."Reserved Quantity";
              InsertTempSupplyReservEntry(ItemLedgEntry);
            UNTIL ItemLedgEntry.NEXT = 0;

          TempTrackingSpecification."Buffer Value4" :=
            TempTrackingSpecification."Buffer Value2" - // Total Inventory
            TempTrackingSpecification."Buffer Value3" + // Reserved Inventory
            TempTrackingSpecification."Buffer Value1";  // Non-allocated lot/sn demand (signed negatively)
          TempTrackingSpecification.MODIFY;
          TotalReservedQty += TempTrackingSpecification."Buffer Value3";
        UNTIL TempTrackingSpecification.NEXT = 0;

      IF TotalReservedQty = 0 THEN
        EXIT(FALSE); // No need to consider reallocation if no reservations exist.

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CalcAllocations(VAR TempTrackingSpecification : Record 336 TEMPORARY) : Boolean;
    VAR
      ReservEntry : Record 337;
      ReservEntry2 : Record 337;
      QtyNeededForReallocation : Decimal;
    BEGIN
      ReservEntry.SETCURRENTKEY("Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code");
      ReservEntry.SETRANGE("Item No.",TempTrackingSpecification."Item No.");
      ReservEntry.SETRANGE("Variant Code",TempTrackingSpecification."Variant Code");
      ReservEntry.SETRANGE("Location Code",TempTrackingSpecification."Location Code");
      ReservEntry.SETRANGE("Source Type",DATABASE::"Item Ledger Entry"); // (ILE)
      ReservEntry.SETRANGE("Source Subtype",0);
      ReservEntry.SETRANGE(Positive,TRUE);
      ReservEntry.SETRANGE("Reservation Status",
        ReservEntry."Reservation Status"::Reservation,ReservEntry."Reservation Status"::Tracking);

      TempTrackingSpecification.SETFILTER("Buffer Value4",'< %1',0);

      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          IF TempTrackingSpecification."Serial No." <> '' THEN
            ReservEntry.SETRANGE("Serial No.",TempTrackingSpecification."Serial No.")
          ELSE
            ReservEntry.SETRANGE("Serial No.");
          IF TempTrackingSpecification."Lot No." <> '' THEN
            ReservEntry.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.")
          ELSE
            ReservEntry.SETRANGE("Lot No.");
          IF ReservEntry.FINDSET(TRUE) THEN
            REPEAT
              ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive); // Get demand
              IF NOT ReservEntry2.TrackingExists THEN BEGIN
                TempCurrSupplyReservEntry := ReservEntry;
                TempCurrSupplyReservEntry.INSERT;
                TempTrackingSpecification."Buffer Value5" += ReservEntry."Quantity (Base)";
                TempCurrDemandReservEntry := ReservEntry2;
                TempCurrDemandReservEntry.INSERT;
              END;
            UNTIL (ReservEntry.NEXT = 0) OR
                  (TempTrackingSpecification."Buffer Value4" + TempTrackingSpecification."Buffer Value5" >= 0);
          IF TempTrackingSpecification."Buffer Value4" + TempTrackingSpecification."Buffer Value5" < 0 THEN // Not sufficient qty
            EXIT(FALSE);
          TempTrackingSpecification.MODIFY;
          QtyNeededForReallocation += ABS(TempTrackingSpecification."Buffer Value4");
        UNTIL TempTrackingSpecification.NEXT = 0;

      TempTrackingSpecification.SETFILTER("Buffer Value4",'>= %1',0);
      ReservEntry.SETRANGE("Reservation Status");

      // The quantity temporary records representing Item Ledger Entries are adjusted according to the
      // reservation entries actually existing in the database pointing at those entries. Otherwise these
      // would be counted twice.
      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          IF TempTrackingSpecification."Serial No." <> '' THEN
            ReservEntry.SETRANGE("Serial No.",TempTrackingSpecification."Serial No.")
          ELSE
            ReservEntry.SETRANGE("Serial No.");
          IF TempTrackingSpecification."Lot No." <> '' THEN
            ReservEntry.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.")
          ELSE
            ReservEntry.SETRANGE("Lot No.");

          IF ReservEntry.FINDSET THEN
            REPEAT
              TempSupplyReservEntry.GET(-ReservEntry."Source Ref. No.",TRUE);
              TempSupplyReservEntry."Quantity (Base)" -= ReservEntry."Quantity (Base)";
              IF TempSupplyReservEntry."Quantity (Base)" = 0 THEN
                TempSupplyReservEntry.DELETE
              ELSE
                TempSupplyReservEntry.MODIFY;

              IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Surplus THEN BEGIN
                TempSupplyReservEntry := ReservEntry;
                TempSupplyReservEntry.INSERT;
              END;
            UNTIL (ReservEntry.NEXT = 0);
          QtyNeededForReallocation -= TempTrackingSpecification."Buffer Value4";
        UNTIL (TempTrackingSpecification.NEXT = 0);
      EXIT(QtyNeededForReallocation <= 0);
    END;

    LOCAL PROCEDURE InsertTempSupplyReservEntry(ItemLedgEntry : Record 32);
    BEGIN
      TempSupplyReservEntry.INIT;
      TempSupplyReservEntry."Entry No." := -ItemLedgEntry."Entry No.";
      TempSupplyReservEntry.Positive := TRUE;

      TempSupplyReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
      TempSupplyReservEntry."Source Ref. No." := ItemLedgEntry."Entry No.";

      TempSupplyReservEntry."Item No." := ItemLedgEntry."Item No.";
      TempSupplyReservEntry."Variant Code" := ItemLedgEntry."Variant Code";
      TempSupplyReservEntry."Location Code" := ItemLedgEntry."Location Code";
      TempSupplyReservEntry."Qty. per Unit of Measure" := ItemLedgEntry."Qty. per Unit of Measure";
      TempSupplyReservEntry.Description := ItemLedgEntry.Description;
      TempSupplyReservEntry."Serial No." := ItemLedgEntry."Serial No.";
      TempSupplyReservEntry."Lot No." := ItemLedgEntry."Lot No.";
      TempSupplyReservEntry."Quantity (Base)" := ItemLedgEntry."Remaining Quantity";
      TempSupplyReservEntry."Reservation Status" := TempSupplyReservEntry."Reservation Status"::Surplus;
      TempSupplyReservEntry."Expected Receipt Date" := 0D;
      TempSupplyReservEntry."Shipment Date" := 0D;
      TempSupplyReservEntry.INSERT;
    END;

    //[External]
    // PROCEDURE NonspecificReservedQty(VAR ItemLedgEntry : Record 32) UnspecificQty : Decimal;
    // VAR
    //   ReservEntry : Record 337;
    //   ReservEntry2 : Record 337;
    // BEGIN
    //   IF NOT ItemLedgEntry.FINDSET THEN
    //     EXIT;

    //   ReservEntry.SETCURRENTKEY("Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code");
    //   ReservEntry.SETRANGE("Item No.",ItemLedgEntry."Item No.");
    //   ReservEntry.SETRANGE("Variant Code",ItemLedgEntry."Variant Code");
    //   ReservEntry.SETRANGE("Location Code",ItemLedgEntry."Location Code");
    //   ReservEntry.SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
    //   ReservEntry.SETRANGE("Source Subtype",0);
    //   ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
    //   ReservEntry.SETRANGE(Positive,TRUE);
    //   ItemLedgEntry.COPYFILTER("Serial No.",ReservEntry."Serial No.");
    //   ItemLedgEntry.COPYFILTER("Lot No.",ReservEntry."Lot No.");

    //   IF NOT ReservEntry.FINDSET THEN
    //     EXIT;

    //   REPEAT
    //     ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive);  // Get demand
    //     IF NOT ReservEntry2.TrackingExists THEN
    //       UnspecificQty -= ReservEntry2."Quantity (Base)"; // Sum up negative entries to a positive value
    //   UNTIL ReservEntry.NEXT = 0;
    // END;

    //[External]
    PROCEDURE ReleaseForReservation(ItemNo : Code[20];VariantCode : Code[10];LocationCode : Code[10];SerialNo : Code[50];LotNo : Code[50];QtyToRelease : Decimal) AllocationsChanged : Boolean;
    VAR
      TempTrackingSpecification : Record 336 TEMPORARY;
    BEGIN
      // Local procedure used when doing item tracking specific reservations
      // "Buffer Value4" : Qty for reallocation (negative = need for reallocation)

      CleanUpVariables;
      TempTrackingSpecification."Item No." := ItemNo;
      TempTrackingSpecification."Variant Code" := VariantCode;
      TempTrackingSpecification."Location Code" := LocationCode;
      TempTrackingSpecification."Serial No." := SerialNo;
      TempTrackingSpecification."Lot No." := LotNo;
      TempTrackingSpecification."Quantity (Base)" := QtyToRelease;
      TempTrackingSpecification."Buffer Value4" := -QtyToRelease;
      TempTrackingSpecification.INSERT;

      PrepareTempDataSet(TempTrackingSpecification,QtyToRelease);
      CalcAllocations(TempTrackingSpecification);
      AllocationsChanged := Reallocate(TempTrackingSpecification);
      WriteToDatabase;
    END;

    //[External]
    PROCEDURE ReleaseForReservation3(VAR CalcItemLedgEntry : Record 32;CalcReservEntry : Record 337;RemainingQtyToReserve : Decimal) AllocationsChanged : Boolean;
    VAR
      AvailableToReserve : Decimal;
    BEGIN
      // Used when doing item tracking specific reservations on reservation form.
      // "Buffer Value4" : Qty for reallocation (negative = need for reallocation)

      IF CalcItemLedgEntry.FINDSET THEN
        REPEAT
          CalcItemLedgEntry.CALCFIELDS("Reserved Quantity");
          AvailableToReserve +=
            CalcItemLedgEntry."Remaining Quantity" - CalcItemLedgEntry."Reserved Quantity";
        UNTIL (CalcItemLedgEntry.NEXT = 0) OR (AvailableToReserve >= RemainingQtyToReserve);

      IF AvailableToReserve < RemainingQtyToReserve THEN
        AllocationsChanged := ReleaseForReservation(
            CalcReservEntry."Item No.",CalcReservEntry."Variant Code",CalcReservEntry."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",RemainingQtyToReserve - AvailableToReserve);
    END;

    //[External]
    // PROCEDURE ReserveItemTrackingLine(TrackingSpecification : Record 336);
    // VAR
    //   ReservEntry : Record 337;
    //   QtyToReserveBase : Decimal;
    //   QtyToReserve : Decimal;
    //   UnreservedQty : Decimal;
    //   AvailabilityDate : Date;
    // BEGIN
    //   // Used when fully reserving an item tracking line
    //   QtyToReserveBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Handled (Base)";

    //   IF QtyToReserveBase <= 0 THEN
    //     EXIT;

    //   ReservMgt.SetCalcReservEntry(TrackingSpecification,ReservEntry);

    //   IF ReservEntry."Quantity (Base)" < 0 THEN
    //     AvailabilityDate := ReservEntry."Shipment Date"
    //   ELSE
    //     AvailabilityDate := ReservEntry."Expected Receipt Date";

    //   UnreservedQty :=
    //     TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Handled (Base)";

    //   ReservEntry.SETCURRENTKEY(
    //     "Source ID","Source Ref. No.","Source Type","Source Subtype",
    //     "Source Batch Name","Source Prod. Order Line","Reservation Status");
    //   ReservEntry.SetPointerFilter;
    //   ReservEntry.SetTrackingFilter(ReservEntry."Serial No.",ReservEntry."Lot No.");
    //   ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
    //   IF ReservEntry.FINDSET THEN
    //     REPEAT
    //       UnreservedQty -= ABS(ReservEntry."Quantity (Base)");
    //     UNTIL ReservEntry.NEXT = 0;

    //   IF QtyToReserveBase > UnreservedQty THEN
    //     QtyToReserveBase := UnreservedQty;

    //   ReservMgt.AutoReserveOneLine(1,QtyToReserve,QtyToReserveBase,'',AvailabilityDate);
    // END;

    //[External]
    PROCEDURE ReserveItemTrackingLine2(TrackingSpecification : Record 336;QtyToReserve : Decimal;QtyToReserveBase : Decimal);
    VAR
      ReservEntry : Record 337;
      AvailabilityDate : Date;
    BEGIN
      // Used when reserving a specific quantity on an item tracking line
      IF QtyToReserveBase <= 0 THEN
        EXIT;

      ReservMgt.SetCalcReservEntry(TrackingSpecification,ReservEntry);

      IF ReservEntry."Quantity (Base)" < 0 THEN
        AvailabilityDate := ReservEntry."Shipment Date"
      ELSE
        AvailabilityDate := ReservEntry."Expected Receipt Date";

      ReservMgt.AutoReserveOneLine(1,QtyToReserve,QtyToReserveBase,'',AvailabilityDate);
    END;

    /* /*BEGIN
END.*/
}







