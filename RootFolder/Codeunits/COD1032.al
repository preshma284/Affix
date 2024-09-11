Codeunit 50488 "Job Planning Line-Reserve 1"
{


    Permissions = TableData 337 = rimd,
                TableData 99000850 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        Text000: TextConst ENU = 'Reserved quantity cannot be greater than %1.', ESP = 'La cantidad reservada no puede ser mayor que %1.';
        Text002: TextConst ENU = 'must be filled in when a quantity is reserved', ESP = 'se debe rellenar cuando se ha reservado una cantidad';
        Text004: TextConst ENU = 'must not be changed when a quantity is reserved', ESP = 'no se debe modificar cuando se ha reservado una cantidad';
        Text005: TextConst ENU = 'Codeunit is not initialized correctly.', ESP = 'Codeunit no iniciada correctamente.';
        CreateReservEntry: Codeunit 99000830;
        CreateReservEntry1: Codeunit 51359;
        ReservEngineMgt: Codeunit 99000831;
        ReservEngineMgt1: Codeunit 51360;
        ReservMgt: Codeunit 99000845;
        ReservMgt1: Codeunit 51372;
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
    PROCEDURE CreateReservation(JobPlanningLine: Record 1003; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal; ForSerialNo: Code[50]; ForLotNo: Code[50]);
    VAR
        PlanningDate: Date;
        SignFactor: Integer;
    BEGIN
        IF SetFromType = 0 THEN
            ERROR(Text005);
        JobPlanningLine.TESTFIELD(Type, JobPlanningLine.Type::Item);
        JobPlanningLine.TESTFIELD("No.");
        JobPlanningLine.TESTFIELD("Planning Date");

        JobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
        IF ABS(JobPlanningLine."Remaining Qty. (Base)") < ABS(JobPlanningLine."Reserved Qty. (Base)") + QuantityBase THEN
            ERROR(
              Text000,
              ABS(JobPlanningLine."Remaining Qty. (Base)") - ABS(JobPlanningLine."Reserved Qty. (Base)"));

        JobPlanningLine.TESTFIELD("Variant Code", SetFromVariantCode);
        JobPlanningLine.TESTFIELD("Location Code", SetFromLocationCode);

        SignFactor := -1;

        IF QuantityBase * SignFactor < 0 THEN
            PlanningDate := JobPlanningLine."Planning Date"
        ELSE BEGIN
            PlanningDate := ExpectedReceiptDate;
            ExpectedReceiptDate := JobPlanningLine."Planning Date";
        END;

        CreateReservEntry1.CreateReservEntryFor(
          DATABASE::"Job Planning Line", JobPlanningLine.Status.AsInteger(),
          JobPlanningLine."Job No.", '', 0, JobPlanningLine."Job Contract Entry No.", JobPlanningLine."Qty. per Unit of Measure",
          Quantity, QuantityBase, ForSerialNo, ForLotNo);
        CreateReservEntry1.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromProdOrderLine, SetFromRefNo,
          SetFromQtyPerUOM, SetFromSerialNo, SetFromLotNo);
        CreateReservEntry.CreateReservEntry(
          JobPlanningLine."No.", JobPlanningLine."Variant Code", JobPlanningLine."Location Code",
          Description, ExpectedReceiptDate, PlanningDate);

        SetFromType := 0;
    END;

    LOCAL PROCEDURE CreateBindingReservation(JobPlanningLine: Record 1003; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal);
    BEGIN
        CreateReservation(JobPlanningLine, Description, ExpectedReceiptDate, Quantity, QuantityBase, '', '');
    END;

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
    PROCEDURE FilterReservFor(VAR FilterReservEntry: Record 337; JobPlanningLine: Record 1003);
    BEGIN
        FilterReservEntry.SetSourceFilter(
          DATABASE::"Job Planning Line", JobPlanningLine.Status.AsInteger(), JobPlanningLine."Job No.", JobPlanningLine."Job Contract Entry No.", FALSE);
        // FilterReservEntry.SetSourceFilter2('', 0);
    END;


    //[External]
    PROCEDURE Caption(JobPlanningLine: Record 1003) CaptionText: Text[80];
    BEGIN
        CaptionText :=
          STRSUBSTNO('%1 %2 %3', JobPlanningLine.Status, JobPlanningLine."Job No.", JobPlanningLine."No.");
    END;

    //[External]
    PROCEDURE FindReservEntry(JobPlanningLine: Record 1003; VAR ReservEntry: Record 337): Boolean;
    BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, JobPlanningLine);
        EXIT(ReservEntry.FINDLAST);
    END;

    //[External]
    PROCEDURE VerifyChange(VAR NewJobPlanningLine: Record 1003; VAR OldJobPlanningLine: Record 1003);
    VAR
        JobPlanningLine: Record 1003;
        ReservEntry: Record 337;
        ShowError: Boolean;
        HasError: Boolean;
    BEGIN
        IF (NewJobPlanningLine.Type <> NewJobPlanningLine.Type::Item) AND (OldJobPlanningLine.Type <> OldJobPlanningLine.Type::Item) THEN
            EXIT;
        IF NewJobPlanningLine."Job Contract Entry No." = 0 THEN
            IF NOT JobPlanningLine.GET(
                 NewJobPlanningLine."Job No.",
                 NewJobPlanningLine."Job Task No.",
                 NewJobPlanningLine."Line No.")
            THEN
                EXIT;

        NewJobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
        ShowError := NewJobPlanningLine."Reserved Qty. (Base)" <> 0;

        IF NewJobPlanningLine."Usage Link" <> OldJobPlanningLine."Usage Link" THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR("Usage Link", Text004);
            HasError := TRUE;
        END;

        IF (NewJobPlanningLine."Planning Date" = 0D) AND (OldJobPlanningLine."Planning Date" <> 0D) THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR("Planning Date", Text002);
            HasError := TRUE;
        END;

        IF NewJobPlanningLine."No." <> OldJobPlanningLine."No." THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR("No.", Text004);
            HasError := TRUE;
        END;

        IF NewJobPlanningLine."Variant Code" <> OldJobPlanningLine."Variant Code" THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR("Variant Code", Text004);
            HasError := TRUE;
        END;

        IF NewJobPlanningLine."Location Code" <> OldJobPlanningLine."Location Code" THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR("Location Code", Text004);
            HasError := TRUE;
        END;

        IF NewJobPlanningLine."Bin Code" <> OldJobPlanningLine."Bin Code" THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR("Bin Code", Text004);
            HasError := TRUE;
        END;

        IF NewJobPlanningLine."Line No." <> OldJobPlanningLine."Line No." THEN
            HasError := TRUE;

        IF NewJobPlanningLine.Type <> OldJobPlanningLine.Type THEN BEGIN
            IF ShowError THEN
                NewJobPlanningLine.FIELDERROR(Type, Text004);
            HasError := TRUE;
        END;

        IF HasError THEN
            IF (NewJobPlanningLine."No." <> OldJobPlanningLine."No.") OR
               FindReservEntry(NewJobPlanningLine, ReservEntry)
            THEN BEGIN
                IF (NewJobPlanningLine."No." <> OldJobPlanningLine."No.") OR (NewJobPlanningLine.Type <> OldJobPlanningLine.Type) THEN BEGIN
                    ReservMgt1.SetJobPlanningLine(OldJobPlanningLine);
                    ReservMgt1.DeleteReservEntries(TRUE, 0);
                    ReservMgt1.SetJobPlanningLine(NewJobPlanningLine);
                END ELSE BEGIN
                    ReservMgt1.SetJobPlanningLine(NewJobPlanningLine);
                    ReservMgt.DeleteReservEntries(TRUE, 0);
                END;
                ReservMgt.AutoTrack(NewJobPlanningLine."Remaining Qty. (Base)");
            END;

        IF HasError OR (NewJobPlanningLine."Planning Date" <> OldJobPlanningLine."Planning Date")
        THEN BEGIN
            AssignForPlanning(NewJobPlanningLine);
            IF (NewJobPlanningLine."No." <> OldJobPlanningLine."No.") OR
               (NewJobPlanningLine."Variant Code" <> OldJobPlanningLine."Variant Code") OR
               (NewJobPlanningLine."Location Code" <> OldJobPlanningLine."Location Code")
            THEN
                AssignForPlanning(OldJobPlanningLine);
        END;
    END;

    //[External]
    PROCEDURE VerifyQuantity(VAR NewJobPlanningLine: Record 1003; VAR OldJobPlanningLine: Record 1003);
    VAR
        JobPlanningLine: Record 1003;
    BEGIN
        WITH NewJobPlanningLine DO BEGIN
            IF Type <> Type::Item THEN
                EXIT;
            IF Status = OldJobPlanningLine.Status THEN
                IF "Line No." = OldJobPlanningLine."Line No." THEN
                    IF "Quantity (Base)" = OldJobPlanningLine."Quantity (Base)" THEN
                        EXIT;
            IF "Line No." = 0 THEN
                IF NOT JobPlanningLine.GET("Job No.", "Job Task No.", "Line No.") THEN
                    EXIT;
            ReservMgt1.SetJobPlanningLine(NewJobPlanningLine);
            IF "Qty. per Unit of Measure" <> OldJobPlanningLine."Qty. per Unit of Measure" THEN
                ReservMgt.ModifyUnitOfMeasure;
            IF "Remaining Qty. (Base)" * OldJobPlanningLine."Remaining Qty. (Base)" < 0 THEN
                ReservMgt.DeleteReservEntries(TRUE, 0)
            ELSE
                ReservMgt.DeleteReservEntries(FALSE, "Remaining Qty. (Base)");
            ReservMgt.ClearSurplus;
            ReservMgt.AutoTrack("Remaining Qty. (Base)");
            AssignForPlanning(NewJobPlanningLine);
        END;
    END;

    //[External]
    PROCEDURE TransferJobLineToItemJnlLine(VAR JobPlanningLine: Record 1003; VAR NewItemJnlLine: Record 83; TransferQty: Decimal): Decimal;
    VAR
        OldReservEntry: Record 337;
        ItemTrackingFilterIsSet: Boolean;
        EndLoop: Boolean;
        TrackedQty: Decimal;
        UnTrackedQty: Decimal;
        xTransferQty: Decimal;
    BEGIN
        IF NOT FindReservEntry(JobPlanningLine, OldReservEntry) THEN
            EXIT(TransferQty);

        // Store initial values
        OldReservEntry.CALCSUMS("Quantity (Base)");
        TrackedQty := -OldReservEntry."Quantity (Base)";
        xTransferQty := TransferQty;

        OldReservEntry.Lock;

        // Handle Item Tracking on job planning line:
        CLEAR(CreateReservEntry);
        IF NewItemJnlLine."Entry Type" = NewItemJnlLine."Entry Type"::"Negative Adjmt." THEN
            IF NewItemJnlLine.TrackingExists THEN BEGIN
                CreateReservEntry1.SetNewSerialLotNo(NewItemJnlLine."Serial No.", NewItemJnlLine."Lot No.");
                // Try to match against Item Tracking on the job planning line:
                OldReservEntry.SetTrackingFilterFromItemJnlLine(NewItemJnlLine);
                IF OldReservEntry.ISEMPTY THEN
                    OldReservEntry.ClearTrackingFilter
                ELSE
                    ItemTrackingFilterIsSet := TRUE;
            END;

        NewItemJnlLine.TestItemFields(JobPlanningLine."No.", JobPlanningLine."Variant Code", JobPlanningLine."Location Code");

        IF TransferQty = 0 THEN
            EXIT;

        IF ReservEngineMgt1.InitRecordSet2(OldReservEntry, NewItemJnlLine."Serial No.", NewItemJnlLine."Lot No.") THEN
            REPEAT
                OldReservEntry.TestItemFields(JobPlanningLine."No.", JobPlanningLine."Variant Code", JobPlanningLine."Location Code");

                TransferQty :=
                  CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
                    NewItemJnlLine."Entry Type".AsInteger(), NewItemJnlLine."Journal Template Name", NewItemJnlLine."Journal Batch Name", 0,
                    NewItemJnlLine."Line No.", NewItemJnlLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

                IF ReservEngineMgt.NEXTRecord(OldReservEntry) = 0 THEN
                    IF ItemTrackingFilterIsSet THEN BEGIN
                        OldReservEntry.ClearTrackingFilter;
                        ItemTrackingFilterIsSet := FALSE;
                        EndLoop := NOT ReservEngineMgt.InitRecordSet(OldReservEntry);
                    END ELSE
                        EndLoop := TRUE;
            UNTIL EndLoop OR (TransferQty = 0);

        // Handle remaining transfer quantity
        IF TransferQty <> 0 THEN BEGIN
            TrackedQty -= (xTransferQty - TransferQty);
            UnTrackedQty := JobPlanningLine."Remaining Qty. (Base)" - TrackedQty;
            IF TransferQty > UnTrackedQty THEN BEGIN
                ReservMgt1.SetJobPlanningLine(JobPlanningLine);
                ReservMgt.DeleteReservEntries(FALSE, JobPlanningLine."Remaining Qty. (Base)");
            END;
        END;
        EXIT(TransferQty);
    END;

    //[External]
    PROCEDURE DeleteLine(VAR JobPlanningLine: Record 1003);
    BEGIN
        WITH JobPlanningLine DO BEGIN
            ReservMgt1.SetJobPlanningLine(JobPlanningLine);
            ReservMgt.DeleteReservEntries(TRUE, 0);
            CALCFIELDS("Reserved Qty. (Base)");
            AssignForPlanning(JobPlanningLine);
        END;
    END;

    LOCAL PROCEDURE AssignForPlanning(VAR JobPlanningLine: Record 1003);
    VAR
        PlanningAssignment: Record 99000850;
    BEGIN
        WITH JobPlanningLine DO BEGIN
            IF Status <> Status::Order THEN
                EXIT;
            IF Type <> Type::Item THEN
                EXIT;
            IF "No." <> '' THEN
                PlanningAssignment.ChkAssignOne("No.", "Variant Code", "Location Code", "Planning Date");
        END;
    END;



    /* /*BEGIN
END.*/
}







