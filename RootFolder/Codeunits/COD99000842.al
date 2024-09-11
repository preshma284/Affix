Codeunit 51370 "Service Line-Reserve 1"
{


    Permissions = TableData 337 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Codeunit is not initialized correctly.', ESP = 'Codeunit no iniciada correctamente.';
        Text001: TextConst ENU = 'Reserved quantity cannot be greater than %1', ESP = 'La cantidad reservada no puede ser mayor que %1';
        Text002: TextConst ENU = 'must be filled in when a quantity is reserved', ESP = 'se debe rellenar cuando se ha reservado una cantidad';
        Text003: TextConst ENU = 'must not be changed when a quantity is reserved', ESP = 'no se debe modificar cuando se ha reservado una cantidad';
        CreateReservEntry: Codeunit 99000830;
        CreateReservEntry1: Codeunit 51359;
        ReservEngineMgt: Codeunit 99000831;
        ReservMgt: Codeunit 99000845;
        ItemTrackingMgt: Codeunit 6500;
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
        Text004: TextConst ENU = 'must not be filled in when a quantity is reserved', ESP = 'no se debe rellenar cuando se ha reservado una cantidad';

    //[External]
    PROCEDURE CreateReservation(ServiceLine : Record 5902;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text000);

      ServiceLine.TESTFIELD(Type,ServiceLine.Type::Item);
      ServiceLine.TESTFIELD("No.");
      ServiceLine.TESTFIELD("Needed by Date");
      ServiceLine.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(ServiceLine."Outstanding Qty. (Base)") < ABS(ServiceLine."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text001,
          ABS(ServiceLine."Outstanding Qty. (Base)") - ABS(ServiceLine."Reserved Qty. (Base)"));

      ServiceLine.TESTFIELD("Variant Code",SetFromVariantCode);
      ServiceLine.TESTFIELD("Location Code",SetFromLocationCode);

      IF QuantityBase > 0 THEN
        ShipmentDate := ServiceLine."Needed by Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := ServiceLine."Needed by Date";
      END;

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Service Line",ServiceLine."Document Type".AsInteger(),
        ServiceLine."Document No.",'',0,ServiceLine."Line No.",
        ServiceLine."Qty. per Unit of Measure",Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        ServiceLine."No.",ServiceLine."Variant Code",ServiceLine."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    // LOCAL PROCEDURE CreateBindingReservation(ServiceLine : Record 5902;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal);
    // BEGIN
    //   CreateReservation(ServiceLine,Description,ExpectedReceiptDate,Quantity,QuantityBase,'','');
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
    PROCEDURE FilterReservFor(VAR FilterReservEntry: Record 337; ServiceLine: Record 5902);
    BEGIN
        FilterReservEntry.SetSourceFilter(
          DATABASE::"Service Line", ServiceLine."Document Type".AsInteger(), ServiceLine."Document No.", ServiceLine."Line No.", FALSE);
        FilterReservEntry.SetSourceFilter('', 0);
    END;

    //[External]
    PROCEDURE Caption(ServiceLine: Record 5902) CaptionText: Text[80];
    BEGIN
        CaptionText :=
          STRSUBSTNO('%1 %2 %3', ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."No.");
    END;

    //[External]
    // PROCEDURE FindReservEntry(ServiceLine : Record 5902;VAR ReservEntry : Record 337) : Boolean;
    // BEGIN
    //   ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
    //   FilterReservFor(ReservEntry,ServiceLine);
    //   EXIT(ReservEntry.FINDLAST);
    // END;

    LOCAL PROCEDURE ReservEntryExist(ServLine: Record 5902): Boolean;
    VAR
        ReservEntry: Record 337;
    BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, ServLine);
        EXIT(NOT ReservEntry.ISEMPTY);
    END;

    //[External]
    // PROCEDURE ReservQuantity(ServLine : Record 5902;VAR QtyToReserve : Decimal;VAR QtyToReserveBase : Decimal);
    // BEGIN
    //   CASE ServLine."Document Type" OF
    //     ServLine."Document Type"::Quote,
    //     ServLine."Document Type"::Order,
    //     ServLine."Document Type"::Invoice:
    //       BEGIN
    //         QtyToReserve := ServLine."Outstanding Quantity";
    //         QtyToReserveBase := ServLine."Outstanding Qty. (Base)";
    //       END;
    //     ServLine."Document Type"::"Credit Memo":
    //       BEGIN
    //         QtyToReserve := -ServLine."Outstanding Quantity";
    //         QtyToReserveBase := -ServLine."Outstanding Qty. (Base)"
    //       END;
    //   END;
    // END;

    //[External]
    // PROCEDURE VerifyChange(VAR NewServiceLine : Record 5902;VAR OldServiceLine : Record 5902);
    // VAR
    //   ServiceLine : Record 5902;
    //   TempReservEntry : Record 337;
    //   ShowError : Boolean;
    //   HasError : Boolean;
    // BEGIN
    //   IF (NewServiceLine.Type <> NewServiceLine.Type::Item) AND (OldServiceLine.Type <> OldServiceLine.Type::Item) THEN
    //     EXIT;

    //   IF NewServiceLine."Line No." = 0 THEN
    //     IF NOT ServiceLine.GET(NewServiceLine."Document Type",NewServiceLine."Document No.",NewServiceLine."Line No.") THEN
    //       EXIT;

    //   NewServiceLine.CALCFIELDS("Reserved Qty. (Base)");
    //   ShowError := NewServiceLine."Reserved Qty. (Base)" <> 0;

    //   IF NewServiceLine.Type <> OldServiceLine.Type THEN
    //     IF ShowError THEN
    //       NewServiceLine.FIELDERROR(Type,Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewServiceLine."No." <> OldServiceLine."No." THEN
    //     IF ShowError THEN
    //       NewServiceLine.FIELDERROR("No.",Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF (NewServiceLine."Needed by Date" = 0D) AND (OldServiceLine."Needed by Date" <> 0D) THEN
    //     IF ShowError THEN
    //       NewServiceLine.FIELDERROR("Needed by Date",Text002)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewServiceLine."Variant Code" <> OldServiceLine."Variant Code" THEN
    //     IF ShowError THEN
    //       NewServiceLine.FIELDERROR("Variant Code",Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF NewServiceLine."Location Code" <> OldServiceLine."Location Code" THEN
    //     IF ShowError THEN
    //       NewServiceLine.FIELDERROR("Location Code",Text003)
    //     ELSE
    //       HasError := TRUE;

    //   IF (NewServiceLine.Type = NewServiceLine.Type::Item) AND (OldServiceLine.Type = OldServiceLine.Type::Item) THEN
    //     IF (NewServiceLine."Bin Code" <> OldServiceLine."Bin Code") AND
    //        (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
    //           NewServiceLine."No.",NewServiceLine."Bin Code",
    //           NewServiceLine."Location Code",NewServiceLine."Variant Code",
    //           DATABASE::"Service Line",NewServiceLine."Document Type",
    //           NewServiceLine."Document No.",'',0,NewServiceLine."Line No."))
    //     THEN BEGIN
    //       IF ShowError THEN
    //         NewServiceLine.FIELDERROR("Bin Code",Text004);
    //       HasError := TRUE;
    //     END;

    //   IF NewServiceLine."Line No." <> OldServiceLine."Line No." THEN
    //     HasError := TRUE;

    //   OnVerifyChangeOnBeforeHasError(NewServiceLine,OldServiceLine,HasError,ShowError);

    //   IF HasError THEN
    //     IF (NewServiceLine."No." <> OldServiceLine."No.") OR
    //        FindReservEntry(NewServiceLine,TempReservEntry)
    //     THEN BEGIN
    //       IF NewServiceLine."No." <> OldServiceLine."No." THEN BEGIN
    //         ReservMgt.SetServLine(OldServiceLine);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //         ReservMgt.SetServLine(NewServiceLine);
    //       END ELSE BEGIN
    //         ReservMgt.SetServLine(NewServiceLine);
    //         ReservMgt.DeleteReservEntries(TRUE,0);
    //       END;
    //       ReservMgt.AutoTrack(NewServiceLine."Outstanding Qty. (Base)");
    //     END;

    //   IF HasError OR (NewServiceLine."Needed by Date" <> OldServiceLine."Needed by Date")
    //   THEN BEGIN
    //     AssignForPlanning(NewServiceLine);
    //     IF (NewServiceLine."No." <> OldServiceLine."No.") OR
    //        (NewServiceLine."Variant Code" <> OldServiceLine."Variant Code") OR
    //        (NewServiceLine."Location Code" <> OldServiceLine."Location Code")
    //     THEN
    //       AssignForPlanning(OldServiceLine);
    //   END;
    // END;

    //[External]
    // PROCEDURE VerifyQuantity(VAR NewServiceLine : Record 5902;VAR OldServiceLine : Record 5902);
    // VAR
    //   ServiceLine : Record 5902;
    // BEGIN
    //   WITH NewServiceLine DO BEGIN
    //     IF NOT ("Document Type" IN
    //             ["Document Type"::Quote,"Document Type"::Order])
    //     THEN
    //       IF "Shipment No." = '' THEN
    //         EXIT;

    //     IF Type <> Type::Item THEN
    //       EXIT;
    //     IF "Line No." = OldServiceLine."Line No." THEN
    //       IF "Quantity (Base)" = OldServiceLine."Quantity (Base)" THEN
    //         EXIT;
    //     IF "Line No." = 0 THEN
    //       IF NOT ServiceLine.GET("Document Type","Document No.","Line No.") THEN
    //         EXIT;
    //     ReservMgt.SetServLine(NewServiceLine);
    //     IF "Qty. per Unit of Measure" <> OldServiceLine."Qty. per Unit of Measure" THEN
    //       ReservMgt.ModifyUnitOfMeasure;
    //     IF "Outstanding Qty. (Base)" * OldServiceLine."Outstanding Qty. (Base)" < 0 THEN
    //       ReservMgt.DeleteReservEntries(FALSE,0)
    //     ELSE
    //       ReservMgt.DeleteReservEntries(FALSE,"Outstanding Qty. (Base)");
    //     ReservMgt.ClearSurplus;
    //     ReservMgt.AutoTrack("Outstanding Qty. (Base)");
    //     AssignForPlanning(NewServiceLine);
    //   END;
    // END;

    // LOCAL PROCEDURE AssignForPlanning(VAR ServiceLine : Record 5902);
    // VAR
    //   PlanningAssignment : Record 99000850;
    // BEGIN
    //   WITH ServiceLine DO BEGIN
    //     IF "Document Type" <> "Document Type"::Order THEN
    //       EXIT;
    //     IF Type <> Type::Item THEN
    //       EXIT;
    //     IF "No." <> '' THEN
    //       PlanningAssignment.ChkAssignOne("No.","Variant Code","Location Code","Needed by Date");
    //   END;
    // END;

    //[External]
    // PROCEDURE DeleteLineConfirm(VAR ServLine : Record 5902) : Boolean;
    // BEGIN
    //   WITH ServLine DO BEGIN
    //     IF NOT ReservEntryExist(ServLine) THEN
    //       EXIT(TRUE);

    //     ReservMgt.SetServLine(ServLine);
    //     IF ReservMgt.DeleteItemTrackingConfirm THEN
    //       DeleteItemTracking := TRUE;
    //   END;

    //   EXIT(DeleteItemTracking);
    // END;

    //[External]
    // PROCEDURE DeleteLine(VAR ServLine : Record 5902);
    // BEGIN
    //   WITH ServLine DO BEGIN
    //     ReservMgt.SetServLine(ServLine);
    //     IF DeleteItemTracking THEN
    //       ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
    //     ReservMgt.DeleteReservEntries(TRUE,0);
    //     DeleteInvoiceSpecFromLine(ServLine);
    //     CALCFIELDS("Reserved Qty. (Base)");
    //   END;
    // END;

    //[External]
    // PROCEDURE CallItemTracking(VAR ServiceLine : Record 5902);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ItemTrackingLines : Page 6510;
    // BEGIN
    //   TrackingSpecification.InitFromServLine(ServiceLine,FALSE);
    //   IF ((ServiceLine."Document Type" = ServiceLine."Document Type"::Invoice) AND
    //       (ServiceLine."Shipment No." <> ''))
    //   THEN
    //     ItemTrackingLines.SetFormRunMode(2); // Combined shipment/receipt
    //   ItemTrackingLines.SetSourceSpec(TrackingSpecification,ServiceLine."Needed by Date");
    //   ItemTrackingLines.SetInbound(ServiceLine.IsInbound);
    //   ItemTrackingLines.RUNMODAL;
    // END;

    //[External]
    // PROCEDURE TransServLineToServLine(VAR OldServLine : Record 5902;VAR NewServLine : Record 5902;TransferQty : Decimal);
    // VAR
    //   OldReservEntry : Record 337;
    //   Status : Option "Reservation","Tracking","Surplus","Prospect";
    // BEGIN
    //   IF NOT FindReservEntry(OldServLine,OldReservEntry) THEN
    //     EXIT;

    //   OldReservEntry.Lock;

    //   NewServLine.TestItemFields(OldServLine."No.",OldServLine."Variant Code",OldServLine."Location Code");

    //   FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
    //     IF TransferQty = 0 THEN
    //       EXIT;
    //     OldReservEntry.SETRANGE("Reservation Status",Status);
    //     IF OldReservEntry.FINDSET THEN
    //       REPEAT
    //         OldReservEntry.TestItemFields(OldServLine."No.",OldServLine."Variant Code",OldServLine."Location Code");

    //         TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Service Line",
    //             NewServLine."Document Type",NewServLine."Document No.",'',0,
    //             NewServLine."Line No.",NewServLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

    //       UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
    //   END;
    // END;

    //[External]
    // PROCEDURE RetrieveInvoiceSpecification(VAR ServLine : Record 5902;VAR TempInvoicingSpecification : Record 336 TEMPORARY;Consume : Boolean) OK : Boolean;
    // VAR
    //   SourceSpecification : Record 336;
    // BEGIN
    //   CLEAR(TempInvoicingSpecification);
    //   IF ServLine.Type <> ServLine.Type::Item THEN
    //     EXIT;
    //   IF ((ServLine."Document Type" = ServLine."Document Type"::Invoice) AND
    //       (ServLine."Shipment No." <> ''))
    //   THEN
    //     OK := RetrieveInvoiceSpecification2(ServLine,TempInvoicingSpecification)
    //   ELSE BEGIN
    //     SourceSpecification.InitFromServLine(ServLine,Consume);
    //     OK := ItemTrackingMgt.RetrieveInvoiceSpecWithService(SourceSpecification,TempInvoicingSpecification,Consume);
    //   END;
    // END;

    // LOCAL PROCEDURE RetrieveInvoiceSpecification2(VAR ServLine : Record 5902;VAR TempInvoicingSpecification : Record 336 TEMPORARY) OK : Boolean;
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservEntry : Record 337;
    // BEGIN
    //   // Used for combined shipment:
    //   IF ServLine.Type <> ServLine.Type::Item THEN
    //     EXIT;
    //   IF NOT FindReservEntry(ServLine,ReservEntry) THEN
    //     EXIT;
    //   ReservEntry.FINDSET;
    //   REPEAT
    //     ReservEntry.TESTFIELD("Reservation Status",ReservEntry."Reservation Status"::Prospect);
    //     ReservEntry.TESTFIELD("Item Ledger Entry No.");
    //     TrackingSpecification.GET(ReservEntry."Item Ledger Entry No.");
    //     TempInvoicingSpecification := TrackingSpecification;
    //     TempInvoicingSpecification."Qty. to Invoice (Base)" :=
    //       ReservEntry."Qty. to Invoice (Base)";
    //     TempInvoicingSpecification."Qty. to Invoice" :=
    //       ROUND(ReservEntry."Qty. to Invoice (Base)" / ReservEntry."Qty. per Unit of Measure",0.00001);
    //     TempInvoicingSpecification."Buffer Status" := TempInvoicingSpecification."Buffer Status"::MODIFY;
    //     TempInvoicingSpecification.INSERT;
    //     ReservEntry.DELETE;
    //   UNTIL ReservEntry.NEXT = 0;

    //   OK := TempInvoicingSpecification.FINDFIRST;
    // END;

    //[External]
    // PROCEDURE DeleteInvoiceSpecFromHeader(ServHeader : Record 5900);
    // BEGIN
    //   ItemTrackingMgt.DeleteInvoiceSpecFromHeader(
    //     DATABASE::"Service Line",ServHeader."Document Type",ServHeader."No.");
    // END;

    // LOCAL PROCEDURE DeleteInvoiceSpecFromLine(ServLine : Record 5902);
    // BEGIN
    //   ItemTrackingMgt.DeleteInvoiceSpecFromLine(
    //     DATABASE::"Service Line",ServLine."Document Type",ServLine."Document No.",ServLine."Line No.");
    // END;

    //[External]
    // PROCEDURE TransServLineToItemJnlLine(VAR ServLine : Record 5902;VAR ItemJnlLine : Record 83;TransferQty : Decimal;VAR CheckApplFromItemEntry : Boolean) : Decimal;
    // VAR
    //   OldReservEntry : Record 337;
    // BEGIN
    //   IF NOT FindReservEntry(ServLine,OldReservEntry) THEN
    //     EXIT(TransferQty);

    //   OldReservEntry.Lock;

    //   ItemJnlLine.TestItemFields(ServLine."No.",ServLine."Variant Code",ServLine."Location Code");

    //   IF TransferQty = 0 THEN
    //     EXIT;

    //   IF ItemJnlLine."Invoiced Quantity" <> 0 THEN
    //     CreateReservEntry.SetUseQtyToInvoice(TRUE);

    //   IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN BEGIN
    //     REPEAT
    //       OldReservEntry.TestItemFields(ServLine."No.",ServLine."Variant Code",ServLine."Location Code");

    //       IF CheckApplFromItemEntry THEN BEGIN
    //         OldReservEntry.TESTFIELD("Appl.-from Item Entry");
    //         CreateReservEntry.SetApplyFromEntryNo(OldReservEntry."Appl.-from Item Entry");
    //       END;

    //       TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
    //           ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",
    //           ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
    //           ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

    //     UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    //     CheckApplFromItemEntry := FALSE;
    //   END;
    //   EXIT(TransferQty);
    // END;

    //[External]
    // PROCEDURE UpdateItemTrackingAfterPosting(ServHeader : Record 5900);
    // VAR
    //   ReservEntry : Record 337;
    //   CreateReservEntry : Codeunit 99000830;
    // BEGIN
    //   // Used for updating Quantity to Handle and Quantity to Invoice after posting
    //   ReservEntry.SetSourceFilter(DATABASE::"Service Line",ServHeader."Document Type",ServHeader."No.",-1,TRUE);
    //   ReservEntry.SetSourceFilter2('',0);
    //   CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    // END;

    //[External]
    // PROCEDURE BindToPurchase(ServiceLine : Record 5902;PurchLine : Record 39;ReservQty : Decimal;ReservQtyBase : Decimal);
    // VAR
    //   TrackingSpecification : Record 336;
    //   ReservationEntry : Record 337;
    // BEGIN
    //   SetBinding(ReservationEntry.Binding::"Order-to-Order");
    //   TrackingSpecification.InitTrackingSpecification2(
    //     DATABASE::"Purchase Line",
    //     PurchLine."Document Type",PurchLine."Document No.",'',0,PurchLine."Line No.",
    //     PurchLine."Variant Code",PurchLine."Location Code",PurchLine."Qty. per Unit of Measure");
    //   CreateReservationSetFrom(TrackingSpecification);
    //   CreateBindingReservation(ServiceLine,PurchLine.Description,PurchLine."Expected Receipt Date",ReservQty,ReservQtyBase);
    // END;

    //[External]
    // PROCEDURE BindToRequisition(ServiceLine : Record 5902;ReqLine : Record 246;ReservQty : Decimal;ReservQtyBase : Decimal);
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
    //   CreateBindingReservation(ServiceLine,ReqLine.Description,ReqLine."Due Date",ReservQty,ReservQtyBase);
    // END;

    //[IntegrationEvent]
    // LOCAL PROCEDURE OnVerifyChangeOnBeforeHasError(NewServiceLine : Record 5902;OldServiceLine : Record 5902;VAR HasError : Boolean;VAR ShowError : Boolean);
    // BEGIN
    // END;

    /* /*BEGIN
END.*/
}







