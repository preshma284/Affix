Codeunit 50469 "Assembly Header-Reserve 1"
{
  
  
    Permissions=TableData 337=rimd;
    trigger OnRun()
BEGIN
          END;
    VAR
      CreateReservEntry : Codeunit 99000830;
      CreateReservEntry1 : Codeunit 51359;
      ReservMgt : Codeunit 99000845;
      ReservMgt1 : Codeunit 51372;
      ReservEngineMgt : Codeunit 99000831;
      SetFromType : Integer;
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
      Text000 : TextConst ENU='Reserved quantity cannot be greater than %1.',ESP='La cantidad reservada no puede ser mayor que %1.';
      Text001 : TextConst ENU='Codeunit is not initialized correctly.',ESP='Codeunit no iniciada correctamente.';
      DeleteItemTracking : Boolean;
      Text002 : TextConst ENU='must be filled in when a quantity is reserved',ESP='se debe rellenar cuando se ha reservado una cantidad';
      Text003 : TextConst ENU='must not be changed when a quantity is reserved',ESP='no se debe modificar cuando se ha reservado una cantidad';

    //[External]
    PROCEDURE CreateReservation(VAR AssemblyHeader : Record 900;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal;ForSerialNo : Code[50];ForLotNo : Code[50]);
    VAR
      ShipmentDate : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text001);

      AssemblyHeader.TESTFIELD("Item No.");
      AssemblyHeader.TESTFIELD("Due Date");

      AssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(AssemblyHeader."Remaining Quantity (Base)") < ABS(AssemblyHeader."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(AssemblyHeader."Remaining Quantity (Base)") - ABS(AssemblyHeader."Reserved Qty. (Base)"));

      AssemblyHeader.TESTFIELD("Variant Code",SetFromVariantCode);
      AssemblyHeader.TESTFIELD("Location Code",SetFromLocationCode);

      IF QuantityBase * SignFactor(AssemblyHeader) < 0 THEN
        ShipmentDate := AssemblyHeader."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := AssemblyHeader."Due Date";
      END;

      IF AssemblyHeader."Planning Flexibility" <> AssemblyHeader."Planning Flexibility"::Unlimited THEN
        CreateReservEntry.SetPlanningFlexibility(AssemblyHeader."Planning Flexibility");

      CreateReservEntry1.CreateReservEntryFor(
        DATABASE::"Assembly Header",AssemblyHeader."Document Type".AsInteger(),
        AssemblyHeader."No.",'',0,0,AssemblyHeader."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry1.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        AssemblyHeader."Item No.",AssemblyHeader."Variant Code",AssemblyHeader."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    //[External]
    PROCEDURE CreateReservation2(VAR AssemblyHeader : Record 900;Description : Text[50];ExpectedReceiptDate : Date;Quantity : Decimal;QuantityBase : Decimal);
    BEGIN
      CreateReservation(AssemblyHeader,Description,ExpectedReceiptDate,Quantity,QuantityBase,'','');
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

    LOCAL PROCEDURE SignFactor(AssemblyHeader : Record 900) : Integer;
    BEGIN
      IF AssemblyHeader."Document Type" IN [Enum::"Assembly Document Type".FromInteger(2),Enum::"Assembly Document Type".FromInteger(3),Enum::"Assembly Document Type".FromInteger(5)] THEN
        ERROR(Text001);

      EXIT(1);
    END;

   
    //[External]
    PROCEDURE FilterReservFor(VAR FilterReservEntry : Record 337;AssemblyHeader : Record 900);
    BEGIN
      FilterReservEntry.SetSourceFilter(DATABASE::"Assembly Header",AssemblyHeader."Document Type".AsInteger(),AssemblyHeader."No.",0,FALSE);
      // FilterReservEntry.SetSourceFilter2('',0);
    END;

    //[External]
    PROCEDURE FindReservEntry(AssemblyHeader : Record 900;VAR ReservEntry : Record 337) : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,AssemblyHeader);
      EXIT(ReservEntry.FINDLAST);
    END;

    LOCAL PROCEDURE AssignForPlanning(VAR AssemblyHeader : Record 900);
    VAR
      PlanningAssignment : Record 99000850;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        IF "Document Type" <> "Document Type"::Order THEN
          EXIT;

        IF "Item No." <> '' THEN
          PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code",WORKDATE);
      END;
    END;

    
    //[External]
    PROCEDURE ReservEntryExist(AssemblyHeader : Record 900) : Boolean;
    VAR
      ReservEntry : Record 337;
      ReservEngineMgt : Codeunit 99000831;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,AssemblyHeader);
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    //[External]
    PROCEDURE DeleteLine(VAR AssemblyHeader : Record 900);
    BEGIN
      WITH AssemblyHeader DO BEGIN
        ReservMgt1.SetAssemblyHeader(AssemblyHeader);
        IF DeleteItemTracking THEN
          ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE,0);
        ReservMgt.ClearActionMessageReferences;
        CALCFIELDS("Reserved Qty. (Base)");
        AssignForPlanning(AssemblyHeader);
      END;
    END;

   
    //[External]
    PROCEDURE Caption(AssemblyHeader : Record 900) CaptionText : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO('%1 %2',AssemblyHeader."Document Type",AssemblyHeader."No.");
    END;

    //[External]
    PROCEDURE CallItemTracking(VAR AssemblyHeader : Record 900);
    VAR
      TrackingSpecification : Record 336;
      ItemTrackingLines : Page 6510;
    BEGIN
      TrackingSpecification.InitFromAsmHeader(AssemblyHeader);
      ItemTrackingLines.SetSourceSpec(TrackingSpecification,AssemblyHeader."Due Date");
      ItemTrackingLines.SetInbound(AssemblyHeader.IsInbound);
      ItemTrackingLines.RUNMODAL;
    END;

    
    //[External]
    PROCEDURE UpdateItemTrackingAfterPosting(AssemblyHeader : Record 900);
    VAR
      ReservEntry : Record 337;
      CreateReservEntry : Codeunit 99000830;
    BEGIN
      // Used for updating Quantity to Handle and Quantity to Invoice after posting
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      ReservEntry.SetSourceFilter(
        DATABASE::"Assembly Header",AssemblyHeader."Document Type".AsInteger(),AssemblyHeader."No.",-1,FALSE);
      // ReservEntry.SetSourceFilter2('',0);
      CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    END;

    

    /* /*BEGIN
END.*/
}







