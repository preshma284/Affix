Codeunit 50470 "Assembly Line-Reserve 1"
{


    Permissions = TableData 337 = rimd;
    trigger OnRun()
    BEGIN
    END;

    VAR
        CreateReservEntry: Codeunit 99000830;
        CreateReservEntry1: Codeunit 51359;
        ReservMgt: Codeunit 99000845;
        ReservMgt1: Codeunit 51372;
        ReservEngineMgt: Codeunit 99000831;
        SetFromType: Integer;
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
        Text000: TextConst ENU = 'Reserved quantity cannot be greater than %1.', ESP = 'La cantidad reservada no puede ser mayor que %1.';
        Text001: TextConst ENU = 'Codeunit is not initialized correctly.', ESP = 'Codeunit no iniciada correctamente.';
        DeleteItemTracking: Boolean;
        Text002: TextConst ENU = 'must be filled in when a quantity is reserved', ESP = 'se debe rellenar cuando se ha reservado una cantidad';
        Text003: TextConst ENU = 'must not be changed when a quantity is reserved', ESP = 'no se debe modificar cuando se ha reservado una cantidad';

    //[External]
    PROCEDURE CreateReservation(AssemblyLine: Record 901; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal; ForSerialNo: Code[50]; ForLotNo: Code[50]);
    VAR
        ShipmentDate: Date;
    BEGIN
        IF SetFromType = 0 THEN
            ERROR(Text001);

        AssemblyLine.TESTFIELD(Type, AssemblyLine.Type::Item);
        AssemblyLine.TESTFIELD("No.");
        AssemblyLine.TESTFIELD("Due Date");

        AssemblyLine.CALCFIELDS("Reserved Qty. (Base)");
        IF ABS(AssemblyLine."Remaining Quantity (Base)") < ABS(AssemblyLine."Reserved Qty. (Base)") + QuantityBase THEN
            ERROR(
              Text000,
              ABS(AssemblyLine."Remaining Quantity (Base)") - ABS(AssemblyLine."Reserved Qty. (Base)"));

        AssemblyLine.TESTFIELD("Variant Code", SetFromVariantCode);
        AssemblyLine.TESTFIELD("Location Code", SetFromLocationCode);

        IF QuantityBase * SignFactor(AssemblyLine) < 0 THEN
            ShipmentDate := AssemblyLine."Due Date"
        ELSE BEGIN
            ShipmentDate := ExpectedReceiptDate;
            ExpectedReceiptDate := AssemblyLine."Due Date";
        END;

        CreateReservEntry1.CreateReservEntryFor(
          DATABASE::"Assembly Line", AssemblyLine."Document Type".AsInteger(),
          AssemblyLine."Document No.", '', 0, AssemblyLine."Line No.", AssemblyLine."Qty. per Unit of Measure",
          Quantity, QuantityBase, ForSerialNo, ForLotNo);
        CreateReservEntry1.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromProdOrderLine, SetFromRefNo,
          SetFromQtyPerUOM, SetFromSerialNo, SetFromLotNo);
        CreateReservEntry.CreateReservEntry(
          AssemblyLine."No.", AssemblyLine."Variant Code", AssemblyLine."Location Code",
          Description, ExpectedReceiptDate, ShipmentDate);

        SetFromType := 0;
    END;

    LOCAL PROCEDURE CreateBindingReservation(AssemblyLine: Record 901; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal);
    BEGIN
        CreateReservation(AssemblyLine, Description, ExpectedReceiptDate, Quantity, QuantityBase, '', '');
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

    LOCAL PROCEDURE SignFactor(AssemblyLine: Record 901): Integer;
    BEGIN
        IF AssemblyLine."Document Type" IN [Enum::"Assembly Document Type".FromInteger(2), Enum::"Assembly Document Type".FromInteger(3), Enum::"Assembly Document Type".FromInteger(5)] THEN
            ERROR(Text001);

        EXIT(-1);
    END;


    //[External]
    PROCEDURE FilterReservFor(VAR FilterReservEntry: Record 337; AssemblyLine: Record 901);
    BEGIN
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Assembly Line");
        FilterReservEntry.SETRANGE("Source Subtype", AssemblyLine."Document Type");
        FilterReservEntry.SETRANGE("Source ID", AssemblyLine."Document No.");
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Prod. Order Line", 0);
        FilterReservEntry.SETRANGE("Source Ref. No.", AssemblyLine."Line No.");
    END;



    //[External]
    PROCEDURE ReservEntryExist(AssemblyLine: Record 901): Boolean;
    VAR
        ReservEntry: Record 337;
        ReservEngineMgt: Codeunit 99000831;
    BEGIN
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, AssemblyLine);
        EXIT(NOT ReservEntry.ISEMPTY);
    END;



    //[External]
    PROCEDURE Caption(AssemblyLine: Record 901) CaptionText: Text[80];
    BEGIN
        CaptionText :=
          STRSUBSTNO('%1 %2 %3', AssemblyLine."Document Type", AssemblyLine."Document No.", AssemblyLine."Line No.");
    END;

    //[External]
    PROCEDURE CallItemTracking(VAR AssemblyLine: Record 901);
    VAR
        TrackingSpecification: Record 336;
        ItemTrackingLines: Page 6510;
    BEGIN
        TrackingSpecification.InitFromAsmLine(AssemblyLine);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification, AssemblyLine."Due Date");
        ItemTrackingLines.SetInbound(AssemblyLine.IsInbound);
        ItemTrackingLines.RUNMODAL;
    END;



    //[External]
    PROCEDURE UpdateItemTrackingAfterPosting(AssemblyLine: Record 901);
    VAR
        ReservEntry: Record 337;
        CreateReservEntry: Codeunit 99000830;
    BEGIN
        // Used for updating Quantity to Handle and Quantity to Invoice after posting
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        ReservEntry.SETRANGE("Source Type", DATABASE::"Assembly Line");
        ReservEntry.SETRANGE("Source Subtype", AssemblyLine."Document Type");
        ReservEntry.SETRANGE("Source ID", AssemblyLine."Document No.");
        ReservEntry.SETRANGE("Source Batch Name", '');
        ReservEntry.SETRANGE("Source Prod. Order Line", 0);
        CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    END;


    /* /*BEGIN
END.*/
}







