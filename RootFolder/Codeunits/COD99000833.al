Codeunit 51362 "Req. Line-Reserve 1"
{
  
  
    Permissions=TableData 337=rimd,
                TableData 99000849=rmd;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='Reserved quantity cannot be greater than %1',ESP='La cantidad reservada no puede ser mayor que %1';
      Text002 : TextConst ENU='must be filled in when a quantity is reserved',ESP='se debe rellenar cuando se ha reservado una cantidad';
      Text003 : TextConst ENU='must not be filled in when a quantity is reserved',ESP='no se debe rellenar cuando se ha reservado una cantidad';
      Text004 : TextConst ENU='must not be changed when a quantity is reserved',ESP='no se debe modificar cuando se ha reservado una cantidad';
      Text005 : TextConst ENU='Codeunit is not initialized correctly.',ESP='Codeunit no iniciada correctamente.';
      CreateReservEntry : Codeunit 99000830;
      CreateReservEntry1 : Codeunit 51359;
      
      ReservEngineMgt : Codeunit 99000831;
      ReservMgt : Codeunit 99000845;
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

    //[External]
    PROCEDURE CreateReservation(VAR ReqLine : Record 246;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text005);

      ReqLine.TESTFIELD(Type,ReqLine.Type::Item);
      ReqLine.TESTFIELD("No.");
      ReqLine.TESTFIELD("Due Date");
      ReqLine.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(ReqLine."Quantity (Base)") < ABS(ReqLine."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(ReqLine."Quantity (Base)") - ABS(ReqLine."Reserved Qty. (Base)"));

      ReqLine.TESTFIELD("Variant Code",SetFromVariantCode);
      ReqLine.TESTFIELD("Location Code",SetFromLocationCode);

      IF QuantityBase < 0 THEN
        ShipmentDate := ReqLine."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := ReqLine."Due Date";
      END;

      IF ReqLine."Planning Flexibility" <> ReqLine."Planning Flexibility"::Unlimited THEN
        CreateReservEntry.SetPlanningFlexibility(ReqLine."Planning Flexibility");

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Requisition Line",0,
        ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name",0,ReqLine."Line No.",
        ReqLine."Qty. per Unit of Measure",Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        ReqLine."No.",ReqLine."Variant Code",ReqLine."Location Code",
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
    PROCEDURE FilterReservFor(VAR FilterReservEntry : Record 337;ReqLine : Record 246);
    BEGIN
      FilterReservEntry.SetSourceFilter(DATABASE::"Requisition Line",0,ReqLine."Worksheet Template Name",ReqLine."Line No.",FALSE);
      FilterReservEntry.SetSourceFilter(ReqLine."Journal Batch Name",0);
    END;

    //[External]
    // PROCEDURE Caption(ReqLine : Record 246) CaptionText : Text[80];
    // BEGIN
    //   CaptionText :=
    //     STRSUBSTNO(
    //       '%1 %2 %3',ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name",ReqLine."No.");
    // END;

    //[External]
    PROCEDURE FindReservEntry(ReqLine : Record 246;VAR ReservEntry : Record 337) : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,ReqLine);
      EXIT(ReservEntry.FINDLAST);
    END;

    //[External]
    // PROCEDURE VerifyChange(VAR NewReqLine : Record 246;VAR OldReqLine : Record 246);
    // VAR
    //   ReqLine : Record 246;
    //   TempReservEntry : Record 337;
    //   ShowError : Boolean;
    //   HasError : Boolean;
    // BEGIN
    //   IF (NewReqLine.Type <> NewReqLine.Type::Item) AND (OldReqLine.Type <> OldReqLine.Type::Item) THEN
    //     EXIT;
    //   IF Blocked THEN
    //     EXIT;
    //   IF NewReqLine."Line No." = 0 THEN
    //     IF NOT ReqLine.GET(NewReqLine."Worksheet Template Name",NewReqLine."Journal Batch Name",NewReqLine."Line No.")
    //     THEN
    //       EXIT;

    //   NewReqLine.CALCFIELDS("Reserved Qty. (Base)");
    //   ShowError := NewReqLine."Reserved Qty. (Base)" <> 0;

    //   IF NewReqLine."Due Date" = 0D THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("Due Date",Text002)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewReqLine."Sales Order No." <> '' THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("Sales Order No.",Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewReqLine."Sales Order Line No." <> 0 THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("Sales Order Line No.",Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewReqLine."Sell-to Customer No." <> '' THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("Sell-to Customer No.",Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewReqLine."Variant Code" <> OldReqLine."Variant Code" THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("Variant Code",Text004)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewReqLine."No." <> OldReqLine."No." THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("No.",Text004)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewReqLine."Location Code" <> OldReqLine."Location Code" THEN
    //     IF ShowError THEN
    //       NewReqLine.FIELDERROR("Location Code",Text004)
    //     ELSE
    //       HasError := TRUE;

    //   VerifyBinInReqLine(NewReqLine,OldReqLine,HasError);

    //   OnVerifyChangeOnBeforeHasError(NewReqLine,OldReqLine,HasError,ShowError);

    //   IF HasError THEN
    //     IF (NewReqLine."No." <> OldReqLine."No.") OR
    //        FindReservEntry(NewReqLine,TempReservEntry)
    //     THEN BEGIN
    //       IF NewReqLine."No." <> OldReqLine."No." THEN BEGIN
    //         ReservMgt.SetReqLine(OldReqLine);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //         ReservMgt.SetReqLine(NewReqLine);
    //       END ELSE BEGIN
    //         ReservMgt.SetReqLine(NewReqLine);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //       END;
    //       ReservMgt.AutoTrack(NewReqLine."Quantity (Base)");
    //     END;

    //   IF HasError OR (NewReqLine."Due Date" <> OldReqLine."Due Date") THEN BEGIN
    //     AssignForPlanning(NewReqLine);
    //     IF (NewReqLine."No." <> OldReqLine."No.") OR
    //        (NewReqLine."Variant Code" <> OldReqLine."Variant Code") OR
    //        (NewReqLine."Location Code" <> OldReqLine."Location Code")
    //     THEN
    //       AssignForPlanning(OldReqLine);
    //   END;
    // END;

    //[External]
    // PROCEDURE VerifyQuantity(VAR NewReqLine : Record 246;VAR OldReqLine : Record 246);
    // VAR
    //   ReqLine : Record 246;
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH NewReqLine DO BEGIN
    //     IF "Line No." = OldReqLine."Line No." THEN
    //       IF "Quantity (Base)" = OldReqLine."Quantity (Base)" THEN
    //         EXIT;
    //     IF "Line No." = 0 THEN
    //       IF NOT ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.") THEN
    //         EXIT;
    //     ReservMgt.SetReqLine(NewReqLine);
    //     IF "Qty. per Unit of Measure" <> OldReqLine."Qty. per Unit of Measure" THEN
    //       ReservMgt.ModifyUnitOfMeasure;
    //     IF "Quantity (Base)" * OldReqLine."Quantity (Base)" < 0 THEN
    //       ReservMgt.DeleteReservEntries(TRUE,0)
    //     ELSE
    //       ReservMgt.DeleteReservEntries(FALSE,"Quantity (Base)");
    //     ReservMgt.ClearSurplus;
    //     ReservMgt.AutoTrack("Quantity (Base)");
    //     AssignForPlanning(NewReqLine);
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdatePlanningFlexibility(VAR ReqLine : Record 246);
    // VAR
    //   ReservEntry : Record 337;
    // BEGIN
    //   IF FindReservEntry(ReqLine,ReservEntry) THEN
    //     ReservEntry.MODIFYALL("Planning Flexibility",ReqLine."Planning Flexibility");
    // END;

    //[External]
    // PROCEDURE TransferReqLineToReqLine(VAR OldReqLine : Record 246;VAR NewReqLine : Record 246;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    //   NewReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldReqLine,OldReservEntry) THEN
    //     EXIT;

    //   OldReservEntry.Lock;

    //   NewReqLine.TESTFIELD("No.",OldReqLine."No.");
    //   NewReqLine.TESTFIELD("Variant Code",OldReqLine."Variant Code");
    //   NewReqLine.TESTFIELD("Location Code",OldReqLine."Location Code");

    //   IF TransferAll THEN BEGIN
    //     OldReservEntry.SETRANGE("Source Subtype",0);
    //     OldReservEntry.TransferReservations(
    //       OldReservEntry,OldReqLine."No.",OldReqLine."Variant Code",OldReqLine."Location Code",
    //       TransferAll,TransferQty,NewReqLine."Qty. per Unit of Measure",
    //       DATABASE::"Requisition Line",0,NewReqLine."Worksheet Template Name",NewReqLine."Journal Batch Name",0,NewReqLine."Line No.");

    //     IF OldReqLine."Ref. Order Type" <> OldReqLine."Ref. Order Type"::Transfer THEN
    //       EXIT;

    //     IF NewReqLine."Order Promising ID" <> '' THEN BEGIN
    //       OldReservEntry.SetSourceFilter(
    //         DATABASE::"Sales Line",NewReqLine."Order Promising Line No.",NewReqLine."Order Promising ID",
    //         NewReqLine."Order Promising Line ID",FALSE);
    //       OldReservEntry.SETRANGE("Source Batch Name",'');
    //     END;
    //     OldReservEntry.SETRANGE("Source Subtype",1);
    //     IF OldReservEntry.FINDSET THEN BEGIN
    //       OldReservEntry.TESTFIELD("Qty. per Unit of Measure",NewReqLine."Qty. per Unit of Measure");
    //       REPEAT
    //         OldReservEntry.TESTFIELD("Item No.",OldReqLine."No.");
    //         OldReservEntry.TESTFIELD("Variant Code",OldReqLine."Variant Code");
    //         IF NewReqLine."Order Promising ID" = '' THEN
    //           OldReservEntry.TESTFIELD("Location Code",OldReqLine."Transfer-from Code");

    //         NewReservEntry := OldReservEntry;
    //         NewReservEntry."Source ID" := NewReqLine."Worksheet Template Name";
    //         NewReservEntry."Source Batch Name" := NewReqLine."Journal Batch Name";
    //         NewReservEntry."Source Prod. Order Line" := 0;
    //         NewReservEntry."Source Ref. No." := NewReqLine."Line No.";

    //         NewReservEntry.UpdateActionMessageEntries(OldReservEntry);
    //       UNTIL OldReservEntry.NEXT = 0;
    //     END;
    //   END ELSE
    //     OldReservEntry.TransferReservations(
    //       OldReservEntry,OldReqLine."No.",OldReqLine."Variant Code",OldReqLine."Location Code",
    //       TransferAll,TransferQty,NewReqLine."Qty. per Unit of Measure",
    //       DATABASE::"Requisition Line",0,NewReqLine."Worksheet Template Name",NewReqLine."Journal Batch Name",0,NewReqLine."Line No.");
    // END;

    //[External]
    // PROCEDURE TransferReqLineToPurchLine(VAR OldReqLine : Record 246;VAR PurchLine : Record 39;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldReqLine,OldReservEntry) THEN
    //     EXIT;

    //   PurchLine.TESTFIELD("No.",OldReqLine."No.");
    //   PurchLine.TESTFIELD("Variant Code",OldReqLine."Variant Code");
    //   PurchLine.TESTFIELD("Location Code",OldReqLine."Location Code");

    //   OldReservEntry.TransferReservations(
    //     OldReservEntry,OldReqLine."No.",OldReqLine."Variant Code",OldReqLine."Location Code",
    //     TransferAll,TransferQty,PurchLine."Qty. per Unit of Measure",
    //     DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",'',0,PurchLine."Line No.");
    // END;

    //[External]
    // PROCEDURE TransferPlanningLineToPOLine(VAR OldReqLine : Record 246;VAR NewProdOrderLine : Record 5406;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldReqLine,OldReservEntry) THEN
    //     EXIT;

    //   NewProdOrderLine.TESTFIELD("Item No.",OldReqLine."No.");
    //   NewProdOrderLine.TESTFIELD("Variant Code",OldReqLine."Variant Code");
    //   NewProdOrderLine.TESTFIELD("Location Code",OldReqLine."Location Code");

    //   OldReservEntry.TransferReservations(
    //     OldReservEntry,OldReqLine."No.",OldReqLine."Variant Code",OldReqLine."Location Code",
    //     TransferAll,TransferQty,NewProdOrderLine."Qty. per Unit of Measure",
    //     DATABASE::"Prod. Order Line",NewProdOrderLine.Status,NewProdOrderLine."Prod. Order No.",'',NewProdOrderLine."Line No.",0);
    // END;

    //[External]
    // PROCEDURE TransferPlanningLineToAsmHdr(VAR OldReqLine : Record 246;VAR NewAsmHeader : Record 900;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldReqLine,OldReservEntry) THEN
    //     EXIT;

    //   NewAsmHeader.TESTFIELD("Item No.",OldReqLine."No.");
    //   NewAsmHeader.TESTFIELD("Variant Code",OldReqLine."Variant Code");
    //   NewAsmHeader.TESTFIELD("Location Code",OldReqLine."Location Code");

    //   OldReservEntry.TransferReservations(
    //     OldReservEntry,OldReqLine."No.",OldReqLine."Variant Code",OldReqLine."Location Code",
    //     TransferAll,TransferQty,NewAsmHeader."Qty. per Unit of Measure",
    //     DATABASE::"Assembly Header",NewAsmHeader."Document Type",NewAsmHeader."No.",'',0,0);
    // END;

    //[External]
    PROCEDURE TransferReqLineToTransLine(VAR ReqLine : Record 246;VAR TransLine : Record 5741;TransferQty : Decimal;TransferAll : Boolean);
    VAR
      OldReservEntry : Record 337;
      NewReservEntry : Record 337;
      OrigTransferQty : Decimal;
      Status : Option "Reservation","Tracking","Surplus","Prospect";
      Direction : Option "Outbound","Inbound";
      Subtype : Option "Outbound","Inbound";
    BEGIN
      IF NOT FindReservEntry(ReqLine,OldReservEntry) THEN
        EXIT;

      OldReservEntry.Lock;

      TransLine.TESTFIELD("Item No.",ReqLine."No.");
      TransLine.TESTFIELD("Variant Code",ReqLine."Variant Code");
      TransLine.TESTFIELD("Transfer-to Code",ReqLine."Location Code");
      TransLine.TESTFIELD("Transfer-from Code",ReqLine."Transfer-from Code");

      IF TransferAll THEN BEGIN
        OldReservEntry.FINDSET;
        OldReservEntry.TESTFIELD("Qty. per Unit of Measure",TransLine."Qty. per Unit of Measure");

        REPEAT
          Direction := 1 - OldReservEntry."Source Subtype"; // Swap 0/1 (outbound/inbound)
          IF (Direction = Direction::Inbound) OR (OldReservEntry."Source Type" <> DATABASE::"Transfer Line") THEN
            OldReservEntry.TestItemFields(ReqLine."No.",ReqLine."Variant Code",ReqLine."Location Code")
          ELSE
            OldReservEntry.TestItemFields(ReqLine."No.",ReqLine."Variant Code",ReqLine."Transfer-from Code");

          NewReservEntry := OldReservEntry;
          IF Direction = Direction::Inbound THEN
            NewReservEntry.SetSource(
              DATABASE::"Transfer Line",1,TransLine."Document No.",TransLine."Line No.",'',TransLine."Derived From Line No.")
          ELSE
            NewReservEntry.SetSource(
              DATABASE::"Transfer Line",0,TransLine."Document No.",TransLine."Line No.",'',TransLine."Derived From Line No.");

          NewReservEntry.UpdateActionMessageEntries(OldReservEntry);
        UNTIL (OldReservEntry.NEXT = 0);
      END ELSE BEGIN
        OrigTransferQty := TransferQty;

        FOR Subtype := Subtype::Outbound TO Subtype::Inbound DO BEGIN
          OldReservEntry.SETRANGE("Source Subtype",Subtype);
          TransferQty := OrigTransferQty;
          IF TransferQty = 0 THEN
            EXIT;

          FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
            OldReservEntry.SETRANGE("Reservation Status",Status);

            IF OldReservEntry.FINDSET THEN
              REPEAT
                Direction := 1 - OldReservEntry."Source Subtype";  // Swap 0/1 (outbound/inbound)
                OldReservEntry.TESTFIELD("Item No.",ReqLine."No.");
                OldReservEntry.TESTFIELD("Variant Code",ReqLine."Variant Code");
                IF Direction = Direction::Inbound THEN
                  OldReservEntry.TESTFIELD("Location Code",ReqLine."Location Code")
                ELSE
                  OldReservEntry.TESTFIELD("Location Code",ReqLine."Transfer-from Code");

                TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Transfer Line",
                    Direction,TransLine."Document No.",'',TransLine."Derived From Line No.",
                    TransLine."Line No.",TransLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

              UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
          END;
        END;
      END;
    END;

    // LOCAL PROCEDURE AssignForPlanning(VAR ReqLine : Record 246);
    // VAR
    //   PlanningAssignment : Record 99000850;
    // BEGIN
    //   WITH ReqLine DO BEGIN
    //     IF Type <> Type::Item THEN
    //       EXIT;
    //     IF "No." <> '' THEN
    //       PlanningAssignment.ChkAssignOne("No.","Variant Code","Location Code",WORKDATE);
    //   END;
    // END;

    //[External]
    // PROCEDURE Block(SetBlocked : Boolean);
    // BEGIN
    //   Blocked := SetBlocked;
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR ReqLine : Record 246);
    // VAR
    //   ProdOrderComp : Record 5407;
    //   CalcReservEntry4 : Record 337;
    //   ProdOrderCompReserv : Codeunit 99000838;
    //   QtyTracked : Decimal;
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH ReqLine DO BEGIN
    //     ReservMgt.SetReqLine(ReqLine);
    //     ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     CALCFIELDS("Reserved Qty. (Base)");
    //     AssignForPlanning(ReqLine);

    //     // Retracking of components:
    //     IF ("Action Message" = "Action Message"::Cancel) AND
    //        ("Planning Line Origin" = "Planning Line Origin"::Planning) AND
    //        ("Ref. Order Type" = "Ref. Order Type"::"Prod. Order")
    //     THEN BEGIN
    //       ProdOrderComp.SETCURRENTKEY(Status,"Prod. Order No.","Prod. Order Line No.");
    //       ProdOrderComp.SETRANGE(Status,"Ref. Order Status");
    //       ProdOrderComp.SETRANGE("Prod. Order No.","Ref. Order No.");
    //       ProdOrderComp.SETRANGE("Prod. Order Line No.","Ref. Line No.");
    //       IF ProdOrderComp.FINDSET THEN
    //         REPEAT
    //           ProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
    //           QtyTracked := ProdOrderComp."Reserved Qty. (Base)";
    //           CalcReservEntry4.RESET;
    //           CalcReservEntry4.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
    //           ProdOrderCompReserv.FilterReservFor(CalcReservEntry4,ProdOrderComp);
    //           CalcReservEntry4.SETFILTER("Reservation Status",'<>%1',CalcReservEntry4."Reservation Status"::Reservation);
    //           IF CalcReservEntry4.FINDSET THEN
    //             REPEAT
    //               QtyTracked := QtyTracked - CalcReservEntry4."Quantity (Base)";
    //             UNTIL CalcReservEntry4.NEXT = 0;
    //           ReservMgt.SetProdOrderComponent(ProdOrderComp);
    //           ReservMgt.DeleteReservEntries(QtyTracked = 0,QtyTracked);
    //           ReservMgt.AutoTrack(ProdOrderComp."Remaining Qty. (Base)");
    //         UNTIL ProdOrderComp.NEXT = 0;
    //     END
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdateDerivedTracking(VAR ReqLine : Record 246);
    // VAR
    //   ReservEntry : Record 337;
    //   ReservEntry2 : Record 337;
    //   ActionMessageEntry : Record 99000849;
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
    //   ActionMessageEntry.SETCURRENTKEY("Reservation Entry");

    //   WITH ReservEntry DO BEGIN
    //     SETFILTER("Expected Receipt Date",'<>%1',ReqLine."Due Date");
    //     CASE ReqLine."Ref. Order Type" OF
    //       ReqLine."Ref. Order Type"::Purchase:
    //         SetSourceFilter(DATABASE::"Purchase Line",1,ReqLine."Ref. Order No.",ReqLine."Ref. Line No.",TRUE);
    //       ReqLine."Ref. Order Type"::"Prod. Order":
    //         BEGIN
    //           SetSourceFilter(DATABASE::"Prod. Order Line",ReqLine."Ref. Order Status",ReqLine."Ref. Order No.",-1,TRUE);
    //           SETRANGE("Source Prod. Order Line",ReqLine."Ref. Line No.");
    //         END;
    //       ReqLine."Ref. Order Type"::Transfer:
    //         SetSourceFilter(DATABASE::"Transfer Line",1,ReqLine."Ref. Order No.",ReqLine."Ref. Line No.",TRUE);
    //       ReqLine."Ref. Order Type"::Assembly:
    //         SetSourceFilter(DATABASE::"Assembly Header",1,ReqLine."Ref. Order No.",0,TRUE);
    //     END;

    //     IF FINDSET THEN
    //       REPEAT
    //         ReservEntry2 := ReservEntry;
    //         ReservEntry2."Expected Receipt Date" := ReqLine."Due Date";
    //         ReservEntry2.MODIFY;
    //         IF ReservEntry2.GET(ReservEntry2."Entry No.",NOT ReservEntry2.Positive) THEN BEGIN
    //           ReservEntry2."Expected Receipt Date" := ReqLine."Due Date";
    //           ReservEntry2.MODIFY;
    //         END;
    //         ActionMessageEntry.SETRANGE("Reservation Entry","Entry No.");
    //         ActionMessageEntry.DELETEALL;
    //       UNTIL NEXT = 0;
    //   END;
    // END;

    //[External]
    // PROCEDURE CallItemTracking(VAR ReqLine : Record 246);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ItemTrackingLines : Page 6510;
    // BEGIN
    //   TrackingSpecification.InitFromReqLine(ReqLine);
    //   ItemTrackingLines.SetSourceSpec(TrackingSpecification,ReqLine."Due Date");
    //   ItemTrackingLines.RUNMODAL;
    // END;

    // LOCAL PROCEDURE VerifyBinInReqLine(VAR NewReqLine : Record 246;VAR OldReqLine : Record 246;VAR HasError : Boolean);
    // BEGIN
    //   IF (NewReqLine.Type = NewReqLine.Type::Item) AND (OldReqLine.Type = OldReqLine.Type::Item) THEN
    //     IF (NewReqLine."Bin Code" <> OldReqLine."Bin Code") AND
    //        (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
    //           NewReqLine."No.",NewReqLine."Bin Code",
    //           NewReqLine."Location Code",NewReqLine."Variant Code",
    //           DATABASE::"Requisition Line",0,
    //           NewReqLine."Worksheet Template Name",NewReqLine."Journal Batch Name",0,
    //           NewReqLine."Line No."))
    //     THEN
    //       HasError := TRUE;

    //   IF NewReqLine."Line No." <> OldReqLine."Line No." THEN
    //     HasError := TRUE;
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewReqLine : Record 246;OldReqLine : Record 246;VAR HasError : Boolean;VAR ShowError : Boolean);
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
}







