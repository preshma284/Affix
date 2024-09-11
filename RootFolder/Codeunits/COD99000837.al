Codeunit 51366 "Prod. Order Line-Reserve 1"
{
  
  
    Permissions=TableData 337=rimd,
                TableData 99000849=rm;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='Reserved quantity cannot be greater than %1',ESP='La cantidad reservada no puede ser mayor que %1';
      Text002 : TextConst ENU='must be filled in when a quantity is reserved',ESP='se debe rellenar cuando se ha reservado una cantidad';
      Text003 : TextConst ENU='must not be changed when a quantity is reserved',ESP='no se debe modificar cuando se ha reservado una cantidad';
      Text004 : TextConst ENU='Codeunit is not initialized correctly.',ESP='Codeunit no iniciada correctamente.';
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
      Text006 : TextConst ENU='The %1 %2 %3 has item tracking. Do you want to delete it anyway?',ESP='%1 %2 %3 tiene seguimiento de productos. �Desea eliminarlo de todas maneras?';
      Text007 : TextConst ENU='The %1 %2 %3 has components with item tracking. Do you want to delete it anyway?',ESP='%1 %2 %3 tiene componentes con seguimiento de productos. �Desea eliminarlo de todas maneras?';
      Text008 : TextConst ENU='The %1 %2 %3 and its components have item tracking. Do you want to delete them anyway?',ESP='%1 %2 %3 y sus componentes tienen seguimiento de productos. �Desea eliminarlos de todas maneras?';

    //[External]
    PROCEDURE CreateReservation(VAR ProdOrderLine : Record 5406;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text004);

      ProdOrderLine.TESTFIELD("Item No.");
      ProdOrderLine.TESTFIELD("Due Date");

      ProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(ProdOrderLine."Remaining Qty. (Base)") < ABS(ProdOrderLine."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(ProdOrderLine."Remaining Qty. (Base)") - ABS(ProdOrderLine."Reserved Qty. (Base)"));

      ProdOrderLine.TESTFIELD("Location Code",SetFromLocationCode);
      ProdOrderLine.TESTFIELD("Variant Code",SetFromVariantCode);

      IF QuantityBase < 0 THEN
        ShipmentDate := ProdOrderLine."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := ProdOrderLine."Due Date";
      END;

      IF ProdOrderLine."Planning Flexibility" <> ProdOrderLine."Planning Flexibility"::Unlimited THEN
        CreateReservEntry.SetPlanningFlexibility(ProdOrderLine."Planning Flexibility");

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Prod. Order Line",ProdOrderLine.Status.AsInteger(),
        ProdOrderLine."Prod. Order No.",'',ProdOrderLine."Line No.",0,
        ProdOrderLine."Qty. per Unit of Measure",Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        ProdOrderLine."Item No.",ProdOrderLine."Variant Code",ProdOrderLine."Location Code",
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
    PROCEDURE FilterReservFor(VAR FilterReservEntry : Record 337;ProdOrderLine : Record 5406);
    BEGIN
      FilterReservEntry.SetSourceFilter(DATABASE::"Prod. Order Line",ProdOrderLine.Status.AsInteger(),ProdOrderLine."Prod. Order No.",0,FALSE);
      FilterReservEntry.SetSourceFilter('',ProdOrderLine."Line No.");
    END;

    //[External]
    PROCEDURE Caption(ProdOrderLine : Record 5406) CaptionText : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO('%1 %2 %3 %4',
          ProdOrderLine.Status,ProdOrderLine.TABLECAPTION,ProdOrderLine."Prod. Order No.",ProdOrderLine."Item No.");
    END;

    //[External]
    // PROCEDURE FindReservEntry(ProdOrderLine : Record 5406;VAR ReservEntry : Record 337) : Boolean;
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
    //   FilterReservFor(ReservEntry,ProdOrderLine);
    //   EXIT(ReservEntry.FINDLAST);
    // END;

    //[External]
    // PROCEDURE VerifyChange(VAR NewProdOrderLine : Record 5406;VAR OldProdOrderLine : Record 5406);
    // VAR
    //   ProdOrderLine : Record 5406;
    //   TempReservEntry : Record 337;
    //   ShowError : Boolean;
    //   HasError : Boolean;
    // BEGIN
    //   IF NewProdOrderLine.Status = NewProdOrderLine.Status::Finished THEN
    //     EXIT;
    //   IF Blocked THEN
    //     EXIT;
    //   IF NewProdOrderLine."Line No." = 0 THEN
    //     IF NOT ProdOrderLine.GET(
    //          NewProdOrderLine.Status,
    //          NewProdOrderLine."Prod. Order No.",
    //          NewProdOrderLine."Line No.")
    //     THEN
    //       EXIT;

    //   NewProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
    //   ShowError := NewProdOrderLine."Reserved Qty. (Base)" <> 0;

    //   IF NewProdOrderLine."Due Date" = 0D THEN
    //     IF ShowError THEN
    //       NewProdOrderLine.FIELDERROR("Due Date",Text002)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewProdOrderLine."Item No." <> OldProdOrderLine."Item No." THEN
    //     IF ShowError THEN
    //       NewProdOrderLine.FIELDERROR("Item No.",Text003)
    //     ELSE
    //       HasError := TRUE;
    //   IF NewProdOrderLine."Location Code" <> OldProdOrderLine."Location Code" THEN
    //     IF ShowError THEN
    //       NewProdOrderLine.FIELDERROR("Location Code",Text003)
    //     ELSE
    //       HasError := TRUE;
    //   IF NewProdOrderLine."Variant Code" <> OldProdOrderLine."Variant Code" THEN
    //     IF ShowError THEN
    //       NewProdOrderLine.FIELDERROR("Variant Code",Text003)
    //     ELSE
    //       HasError := TRUE;
    //   IF NewProdOrderLine."Line No." <> OldProdOrderLine."Line No." THEN
    //     HasError := TRUE;

    //   OnVerifyChangeOnBeforeHasError(NewProdOrderLine,OldProdOrderLine,HasError,ShowError);

    //   IF HasError THEN
    //     IF (NewProdOrderLine."Item No." <> OldProdOrderLine."Item No.") OR
    //        FindReservEntry(NewProdOrderLine,TempReservEntry)
    //     THEN BEGIN
    //       IF NewProdOrderLine."Item No." <> OldProdOrderLine."Item No." THEN BEGIN
    //         ReservMgt.SetProdOrderLine(OldProdOrderLine);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //         ReservMgt.SetProdOrderLine(NewProdOrderLine);
    //       END ELSE BEGIN
    //         ReservMgt.SetProdOrderLine(NewProdOrderLine);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //       END;
    //       ReservMgt.AutoTrack(NewProdOrderLine."Remaining Qty. (Base)");
    //     END;

    //   IF HasError OR (NewProdOrderLine."Due Date" <> OldProdOrderLine."Due Date")
    //   THEN BEGIN
    //     AssignForPlanning(NewProdOrderLine);
    //     IF (NewProdOrderLine."Item No." <> OldProdOrderLine."Item No.") OR
    //        (NewProdOrderLine."Variant Code" <> OldProdOrderLine."Variant Code") OR
    //        (NewProdOrderLine."Location Code" <> OldProdOrderLine."Location Code")
    //     THEN
    //       AssignForPlanning(OldProdOrderLine);
    //   END;
    // END;

    //[External]
    // PROCEDURE VerifyQuantity(VAR NewProdOrderLine : Record 5406;VAR OldProdOrderLine : Record 5406);
    // VAR
    //   ProdOrderLine : Record 5406;
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH NewProdOrderLine DO BEGIN
    //     IF Status = Status::Finished THEN
    //       EXIT;
    //     IF "Line No." = OldProdOrderLine."Line No." THEN
    //       IF "Quantity (Base)" = OldProdOrderLine."Quantity (Base)" THEN
    //         EXIT;
    //     IF "Line No." = 0 THEN
    //       IF NOT ProdOrderLine.GET(Status,"Prod. Order No.","Line No.") THEN
    //         EXIT;
    //     ReservMgt.SetProdOrderLine(NewProdOrderLine);
    //     IF "Qty. per Unit of Measure" <> OldProdOrderLine."Qty. per Unit of Measure" THEN
    //       ReservMgt.ModifyUnitOfMeasure;
    //     ReservMgt.DeleteReservEntries(FALSE,"Remaining Qty. (Base)");
    //     ReservMgt.ClearSurplus;
    //     ReservMgt.AutoTrack("Remaining Qty. (Base)");
    //     AssignForPlanning(NewProdOrderLine);
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdatePlanningFlexibility(VAR ProdOrderLine : Record 5406);
    // VAR
    //   ReservEntry : Record 337;
    // BEGIN
    //   IF FindReservEntry(ProdOrderLine,ReservEntry) THEN
    //     ReservEntry.MODIFYALL("Planning Flexibility",ProdOrderLine."Planning Flexibility");
    // END;

    //[External]
    // PROCEDURE TransferPOLineToPOLine(VAR OldProdOrderLine : Record 5406;VAR NewProdOrderLine : Record 5406;TransferQty : Decimal;TransferAll : Boolean);
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(OldProdOrderLine,OldReservEntry) THEN
    //     EXIT;

    //   OldReservEntry.Lock;

    //   NewProdOrderLine.TestItemFields(OldProdOrderLine."Item No.",OldProdOrderLine."Variant Code",OldProdOrderLine."Location Code");

    //   OldReservEntry.TransferReservations(
    //     OldReservEntry,OldProdOrderLine."Item No.",OldProdOrderLine."Variant Code",OldProdOrderLine."Location Code",
    //     TransferAll,TransferQty,NewProdOrderLine."Qty. per Unit of Measure",
    //     DATABASE::"Prod. Order Line",NewProdOrderLine.Status,NewProdOrderLine."Prod. Order No.",'',NewProdOrderLine."Line No.",0);
    // END;

    //[External]
    // PROCEDURE TransferPOLineToItemJnlLine(VAR OldProdOrderLine : Record 5406;VAR NewItemJnlLine : Record 83;TransferQty : Decimal);
    // VAR
    //   OldReservEntry : Record 337;
    //   ItemTrackingFilterIsSet : Boolean;
    //   EndLoop : Boolean;
    // BEGIN
    //   IF NOT FindReservEntry(OldProdOrderLine,OldReservEntry) THEN
    //     EXIT;

    //   OldReservEntry.Lock;

    //   // Handle Item Tracking on output:
    //   CLEAR(CreateReservEntry);
    //   IF NewItemJnlLine."Entry Type" = NewItemJnlLine."Entry Type"::Output THEN
    //     IF NewItemJnlLine.TrackingExists THEN BEGIN
    //       // Try to match against Item Tracking on the prod. order line:
    //       OldReservEntry.SetTrackingFilterFromItemJnlLine(NewItemJnlLine);
    //       IF OldReservEntry.ISEMPTY THEN
    //         OldReservEntry.ClearTrackingFilter
    //       ELSE
    //         ItemTrackingFilterIsSet := TRUE;
    //     END;

    //   NewItemJnlLine.TestItemFields(OldProdOrderLine."Item No.",OldProdOrderLine."Variant Code",OldProdOrderLine."Location Code");

    //   IF TransferQty = 0 THEN
    //     EXIT;

    //   IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
    //     REPEAT
    //       IF NewItemJnlLine.TrackingExists THEN
    //         CreateReservEntry.SetNewSerialLotNo(NewItemJnlLine."Serial No.",NewItemJnlLine."Lot No.");
    //       OldReservEntry.TestItemFields(OldProdOrderLine."Item No.",OldProdOrderLine."Variant Code",OldProdOrderLine."Location Code");

    //       TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
    //           NewItemJnlLine."Entry Type",NewItemJnlLine."Journal Template Name",NewItemJnlLine."Journal Batch Name",0,
    //           NewItemJnlLine."Line No.",NewItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

    //       IF ReservEngineMgt.NEXTRecord(OldReservEntry) = 0 THEN
    //         IF ItemTrackingFilterIsSet THEN BEGIN
    //           OldReservEntry.ClearTrackingFilter;
    //           ItemTrackingFilterIsSet := FALSE;
    //           EndLoop := NOT ReservEngineMgt.InitRecordSet(OldReservEntry);
    //         END ELSE
    //           EndLoop := TRUE;

    //     UNTIL EndLoop OR (TransferQty = 0);
    // END;

    //[External]
    // PROCEDURE DeleteLineConfirm(VAR ProdOrderLine : Record 5406) : Boolean;
    // VAR
    //   ReservEntry : Record 337;
    //   ReservEntry2 : Record 337;
    //   ConfirmMessage : Text[250];
    //   HasItemTracking : Option "None","Line","Components","Line and Components";
    // BEGIN
    //   WITH ReservEntry DO BEGIN
    //     FilterReservFor(ReservEntry,ProdOrderLine);
    //     SETFILTER("Item Tracking",'<> %1',"Item Tracking"::None);
    //     IF NOT ISEMPTY THEN
    //       HasItemTracking := HasItemTracking::Line;

    //     SETRANGE("Source Type",DATABASE::"Prod. Order Component");
    //     SETFILTER("Source Ref. No.",' > %1',0);
    //     IF NOT ISEMPTY THEN
    //       IF HasItemTracking = HasItemTracking::Line THEN
    //         HasItemTracking := HasItemTracking::"Line and Components"
    //       ELSE
    //         HasItemTracking := HasItemTracking::Components;

    //     IF HasItemTracking = HasItemTracking::None THEN
    //       EXIT(TRUE);

    //     CASE HasItemTracking OF
    //       HasItemTracking::Line:
    //         ConfirmMessage := Text006;
    //       HasItemTracking::Components:
    //         ConfirmMessage := Text007;
    //       HasItemTracking::"Line and Components":
    //         ConfirmMessage := Text008;
    //     END;

    //     IF NOT CONFIRM(ConfirmMessage,FALSE,ProdOrderLine.Status,ProdOrderLine.TABLECAPTION,ProdOrderLine."Line No.") THEN
    //       EXIT(FALSE);

    //     SETFILTER("Source Type",'%1|%2',DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component");
    //     SETRANGE("Source Ref. No.");
    //     IF FINDSET THEN
    //       REPEAT
    //         ReservEntry2 := ReservEntry;
    //         ReservEntry2.ClearItemTrackingFields;
    //         ReservEntry2.MODIFY;
    //       UNTIL NEXT = 0;
    //   END;

    //   EXIT(TRUE);
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR ProdOrderLine : Record 5406);
    // BEGIN
    //   IF Blocked THEN
    //     EXIT;

    //   WITH ProdOrderLine DO BEGIN
    //     ReservMgt.SetProdOrderLine(ProdOrderLine);
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     ReservMgt.ClearActionMessageReferences;
    //     CALCFIELDS("Reserved Qty. (Base)");
    //     AssignForPlanning(ProdOrderLine);
    //   END;
    // END;

    //[External]
    // PROCEDURE AssignForPlanning(VAR ProdOrderLine : Record 5406);
    // VAR
    //   PlanningAssignment : Record 99000850;
    // BEGIN
    //   WITH ProdOrderLine DO BEGIN
    //     IF Status = Status::Simulated THEN
    //       EXIT;
    //     IF "Item No." <> '' THEN
    //       PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code",WORKDATE);
    //   END;
    // END;

    //[External]
    // PROCEDURE Block(SetBlocked : Boolean);
    // BEGIN
    //   Blocked := SetBlocked;
    // END;

    //[External]
    // PROCEDURE CallItemTracking(VAR ProdOrderLine : Record 5406);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ItemTrackingDocMgt : Codeunit 6503;
    //   ItemTrackingLines : Page 6510;
    // BEGIN
    //   IF ProdOrderLine.Status = ProdOrderLine.Status::Finished THEN
    //     ItemTrackingDocMgt.ShowItemTrackingForProdOrderComp(DATABASE::"Prod. Order Line",
    //       ProdOrderLine."Prod. Order No.",ProdOrderLine."Line No.",0)
    //   ELSE BEGIN
    //     ProdOrderLine.TESTFIELD("Item No.");
    //     TrackingSpecification.InitFromProdOrderLine(ProdOrderLine);
    //     ItemTrackingLines.SetSourceSpec(TrackingSpecification,ProdOrderLine."Due Date");
    //     ItemTrackingLines.SetInbound(ProdOrderLine.IsInbound);
    //     ItemTrackingLines.RUNMODAL;
    //   END;
    // END;

    //[External]
    // PROCEDURE UpdateItemTrackingAfterPosting(ProdOrderLine : Record 5406);
    // VAR
    //   ReservEntry : Record 337;
    //   CreateReservEntry : Codeunit 99000830;
    // BEGIN
    //   // Used for updating Quantity to Handle after posting;
    //   ReservEntry.SetSourceFilter(DATABASE::"Prod. Order Line",ProdOrderLine.Status,ProdOrderLine."Prod. Order No.",-1,TRUE);
    //   ReservEntry.SetSourceFilter2('',ProdOrderLine."Line No.");
    //   CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewProdOrderLine : Record 5406;OldProdOrderLine : Record 5406;VAR HasError : Boolean;VAR ShowError : Boolean);
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
}







