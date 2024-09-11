Codeunit 51151 "Item Tracking Management 1"
{


    Permissions = TableData 6507 = rd,
                TableData 6508 = rd,
                TableData 6550 = rimd;
    trigger OnRun()
    VAR
        ItemTrackingLines: Page 6510;
    BEGIN
        SourceSpecification.TESTFIELD("Source Type");
        ItemTrackingLines.RegisterItemTrackingLines(
          SourceSpecification, DueDate, TempTrackingSpecification)
    END;

    VAR
        Text003: TextConst ENU = 'No information exists for %1 %2.', ESP = 'No existe informaci�n para %1 %2.';
        Text005: TextConst ENU = 'Warehouse item tracking is not enabled for %1 %2.', ESP = 'No est� habilitado el seguimiento pdto. almac�n para %1 %2.';
        SourceSpecification: Record 336 TEMPORARY;
        TempTrackingSpecification: Record 336 TEMPORARY;
        TempGlobalWhseItemTrkgLine: Record 6550 TEMPORARY;
        DueDate: Date;
        Text006: TextConst ENU = 'Synchronization cancelled.', ESP = 'Sincronizaci�n cancelada.';
        Registering: Boolean;
        Text007: TextConst ENU = 'There are multiple expiration dates registered for lot %1.', ESP = 'Existen varias fechas de caducidad registradas para el lote %1.';
        text008: TextConst ENU = '%1 already exists for %2 %3. Do you want to overwrite the existing information?', ESP = '%1 ya existe para %2 %3. �Desea sobrescribir la informaci�n existente?';
        IsConsume: Boolean;
        Text011: TextConst ENU = '%1 must not be %2.', ESP = '%1 no debe ser %2.';
        Text012: TextConst ENU = 'Only one expiration date is allowed per lot number.\%1 currently has two different expiration dates: %2 and %3.', ESP = 'S�lo se permite una fecha de caducidad por n�mero de lote.\%1 tiene dos fechas de caducidad diferentes: %2 y %3.';
        IsPick: Boolean;
        DeleteReservationEntries: Boolean;
        CannotMatchItemTrackingErr: TextConst ENU = 'Cannot match item tracking.', ESP = 'No coincide seguimiento producto.';
        QtyToInvoiceDoesNotMatchItemTrackingErr: TextConst ENU = 'The quantity to invoice does not match the quantity defined in item tracking.', ESP = 'La cantidad que hay que facturar no coincide con la cantidad definida en el seguimiento del producto.';



    //[External]
    PROCEDURE LookupLotSerialNoInfo(ItemNo: Code[20]; Variant: Code[20]; LookupType: Option "Serial No.","Lot No."; LookupNo: Code[50]);
    VAR
        LotNoInfo: Record 6505;
        SerialNoInfo: Record 6504;
    BEGIN
        CASE LookupType OF
            LookupType::"Serial No.":
                BEGIN
                    IF NOT SerialNoInfo.GET(ItemNo, Variant, LookupNo) THEN
                        ERROR(Text003, SerialNoInfo.FIELDCAPTION("Serial No."), LookupNo);
                    PAGE.RUNMODAL(0, SerialNoInfo);
                END;
            LookupType::"Lot No.":
                BEGIN
                    IF NOT LotNoInfo.GET(ItemNo, Variant, LookupNo) THEN
                        ERROR(Text003, LotNoInfo.FIELDCAPTION("Lot No."), LookupNo);
                    PAGE.RUNMODAL(0, LotNoInfo);
                END;
        END;
    END;



    //[External]
    PROCEDURE GetItemTrackingSettings(VAR ItemTrackingCode: Record 6502; EntryType: Enum "Item Ledger Entry Type"; Inbound: Boolean; VAR SNRequired: Boolean; VAR LotRequired: Boolean; VAR SNInfoRequired: Boolean; VAR LotInfoRequired: Boolean);
    BEGIN
        SNRequired := FALSE;
        LotRequired := FALSE;
        SNInfoRequired := FALSE;
        LotInfoRequired := FALSE;

        IF ItemTrackingCode.Code = '' THEN BEGIN
            CLEAR(ItemTrackingCode);
            EXIT;
        END;
        ItemTrackingCode.GET(ItemTrackingCode.Code);

        IF EntryType = EntryType::Transfer THEN BEGIN
            LotInfoRequired := ItemTrackingCode."Lot Info. Outbound Must Exist" OR ItemTrackingCode."Lot Info. Inbound Must Exist";
            SNInfoRequired := ItemTrackingCode."SN Info. Outbound Must Exist" OR ItemTrackingCode."SN Info. Inbound Must Exist";
        END ELSE BEGIN
            SNInfoRequired := (Inbound AND ItemTrackingCode."SN Info. Inbound Must Exist") OR
              (NOT Inbound AND ItemTrackingCode."SN Info. Outbound Must Exist");

            LotInfoRequired := (Inbound AND ItemTrackingCode."Lot Info. Inbound Must Exist") OR
              (NOT Inbound AND ItemTrackingCode."Lot Info. Outbound Must Exist");
        END;

        IF ItemTrackingCode."SN Specific Tracking" THEN BEGIN
            SNRequired := TRUE;
        END ELSE
            CASE EntryType OF
                EntryType::Purchase:
                    IF Inbound THEN
                        SNRequired := ItemTrackingCode."SN Purchase Inbound Tracking"
                    ELSE
                        SNRequired := ItemTrackingCode."SN Purchase Outbound Tracking";
                EntryType::Sale:
                    IF Inbound THEN
                        SNRequired := ItemTrackingCode."SN Sales Inbound Tracking"
                    ELSE
                        SNRequired := ItemTrackingCode."SN Sales Outbound Tracking";
                EntryType::"Positive Adjmt.":
                    IF Inbound THEN
                        SNRequired := ItemTrackingCode."SN Pos. Adjmt. Inb. Tracking"
                    ELSE
                        SNRequired := ItemTrackingCode."SN Pos. Adjmt. Outb. Tracking";
                EntryType::"Negative Adjmt.":
                    IF Inbound THEN
                        SNRequired := ItemTrackingCode."SN Neg. Adjmt. Inb. Tracking"
                    ELSE
                        SNRequired := ItemTrackingCode."SN Neg. Adjmt. Outb. Tracking";
                EntryType::Transfer:
                    SNRequired := ItemTrackingCode."SN Transfer Tracking";
                EntryType::Consumption, EntryType::Output:
                    IF Inbound THEN
                        SNRequired := ItemTrackingCode."SN Manuf. Inbound Tracking"
                    ELSE
                        SNRequired := ItemTrackingCode."SN Manuf. Outbound Tracking";
                EntryType::"Assembly Consumption", EntryType::"Assembly Output":
                    IF Inbound THEN
                        SNRequired := ItemTrackingCode."SN Assembly Inbound Tracking"
                    ELSE
                        SNRequired := ItemTrackingCode."SN Assembly Outbound Tracking";
            END;

        IF ItemTrackingCode."Lot Specific Tracking" THEN BEGIN
            LotRequired := TRUE;
        END ELSE
            CASE EntryType OF
                EntryType::Purchase:
                    IF Inbound THEN
                        LotRequired := ItemTrackingCode."Lot Purchase Inbound Tracking"
                    ELSE
                        LotRequired := ItemTrackingCode."Lot Purchase Outbound Tracking";
                EntryType::Sale:
                    IF Inbound THEN
                        LotRequired := ItemTrackingCode."Lot Sales Inbound Tracking"
                    ELSE
                        LotRequired := ItemTrackingCode."Lot Sales Outbound Tracking";
                EntryType::"Positive Adjmt.":
                    IF Inbound THEN
                        LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Inb. Tracking"
                    ELSE
                        LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Outb. Tracking";
                EntryType::"Negative Adjmt.":
                    IF Inbound THEN
                        LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Inb. Tracking"
                    ELSE
                        LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Outb. Tracking";
                EntryType::Transfer:
                    LotRequired := ItemTrackingCode."Lot Transfer Tracking";
                EntryType::Consumption, EntryType::Output:
                    IF Inbound THEN
                        LotRequired := ItemTrackingCode."Lot Manuf. Inbound Tracking"
                    ELSE
                        LotRequired := ItemTrackingCode."Lot Manuf. Outbound Tracking";
                EntryType::"Assembly Consumption", EntryType::"Assembly Output":
                    IF Inbound THEN
                        LotRequired := ItemTrackingCode."Lot Assembly Inbound Tracking"
                    ELSE
                        LotRequired := ItemTrackingCode."Lot Assembly Outbound Tracking";
            END;
    END;

    //[External]
    PROCEDURE RetrieveInvoiceSpecification(SourceSpecification: Record 336; VAR TempInvoicingSpecification: Record 336 TEMPORARY) OK: Boolean;
    VAR
        TrackingSpecification: Record 336;
        ReservEntry: Record 337;
        TempTrackingSpecSummedUp: Record 336 TEMPORARY;
    BEGIN
        OK := FALSE;
        TempInvoicingSpecification.RESET;
        TempInvoicingSpecification.DELETEALL;

        ReservEntry.SetSourceFilter(
          SourceSpecification."Source Type", SourceSpecification."Source Subtype", SourceSpecification."Source ID",
          SourceSpecification."Source Ref. No.", TRUE);
        ReservEntry.SetSourceFilter(SourceSpecification."Source Batch Name", SourceSpecification."Source Prod. Order Line");
        ReservEntry.SETFILTER("Reservation Status", '<>%1', ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SETFILTER("Item Tracking", '<>%1', ReservEntry."Item Tracking"::None);
        SumUpItemTracking(ReservEntry, TempTrackingSpecSummedUp, FALSE, TRUE);

        // TrackingSpecification contains information about lines that should be invoiced:
        TrackingSpecification.SetSourceFilter(
          SourceSpecification."Source Type", SourceSpecification."Source Subtype", SourceSpecification."Source ID",
          SourceSpecification."Source Ref. No.", TRUE);
        TrackingSpecification.SetSourceFilter(
          SourceSpecification."Source Batch Name", SourceSpecification."Source Prod. Order Line");
        IF TrackingSpecification.FINDSET THEN
            REPEAT
                TrackingSpecification.TESTFIELD("Qty. to Handle (Base)", 0);
                TrackingSpecification.TESTFIELD("Qty. to Handle", 0);
                IF NOT TrackingSpecification.Correction THEN BEGIN
                    TempInvoicingSpecification := TrackingSpecification;
                    TempInvoicingSpecification."Qty. to Invoice" :=
                      ROUND(TempInvoicingSpecification."Qty. to Invoice (Base)" /
                        SourceSpecification."Qty. per Unit of Measure", 0.00001);
                    TempInvoicingSpecification.INSERT;
                    OK := TRUE;

                    // TempTrackingSpecSummedUp.SetTrackingFilter(
                    //   TempInvoicingSpecification."Serial No.", TempInvoicingSpecification."Lot No.");
                    IF TempTrackingSpecSummedUp.FINDFIRST THEN BEGIN
                        TempTrackingSpecSummedUp."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
                        TempTrackingSpecSummedUp.MODIFY;
                    END ELSE BEGIN
                        TempTrackingSpecSummedUp := TempInvoicingSpecification;
                        TempTrackingSpecSummedUp.INSERT;
                    END;
                END;
            UNTIL TrackingSpecification.NEXT = 0;

        IF NOT IsConsume AND (SourceSpecification."Qty. to Invoice (Base)" <> 0) THEN
            CheckQtyToInvoiceMatchItemTracking(
              TempTrackingSpecSummedUp, TempInvoicingSpecification,
              SourceSpecification."Qty. to Invoice (Base)", SourceSpecification."Qty. per Unit of Measure");

        TempInvoicingSpecification.SETFILTER("Qty. to Invoice (Base)", '<>0');
        IF NOT TempInvoicingSpecification.FINDFIRST THEN
            TempInvoicingSpecification.INIT;
    END;



    //[External]
    PROCEDURE RetrieveItemTrackingFromReservEntry(ItemJnlLine: Record 83; VAR ReservEntry: Record 337; VAR TempTrackingSpec: Record 336 TEMPORARY): Boolean;
    BEGIN
        IF ItemJnlLine.Subcontracting THEN
            EXIT(RetrieveSubcontrItemTracking(ItemJnlLine, TempTrackingSpec));

        ReservEntry.SetSourceFilter(
          DATABASE::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name", ItemJnlLine."Line No.", TRUE);
        ReservEntry.SetSourceFilter(ItemJnlLine."Journal Batch Name", 0);
        OnAfterReserveEntryFilter(ItemJnlLine, ReservEntry);
        ReservEntry.SETFILTER("Qty. to Handle (Base)", '<>0');
        OnRetrieveItemTrackingFromReservEntryFilter(ReservEntry, ItemJnlLine);
        IF SumUpItemTracking(ReservEntry, TempTrackingSpec, FALSE, TRUE) THEN BEGIN
            ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Prospect);
            IF NOT ReservEntry.ISEMPTY THEN
                ReservEntry.DELETEALL;
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE RetrieveSubcontrItemTracking(ItemJnlLine: Record 83; VAR TempHandlingSpecification: Record 336 TEMPORARY): Boolean;
    VAR
        ReservEntry: Record 337;
        ProdOrderRtngLine: Record 5409;
    BEGIN
        IF NOT ItemJnlLine.Subcontracting THEN
            EXIT(FALSE);

        IF ItemJnlLine."Operation No." = '' THEN
            EXIT(FALSE);

        ItemJnlLine.TESTFIELD("Routing No.");
        ItemJnlLine.TESTFIELD("Order Type", ItemJnlLine."Order Type"::Production);
        IF NOT ProdOrderRtngLine.GET(
             ProdOrderRtngLine.Status::Released, ItemJnlLine."Order No.",
             ItemJnlLine."Routing Reference No.", ItemJnlLine."Routing No.", ItemJnlLine."Operation No.")
        THEN
            EXIT(FALSE);
        IF NOT (ProdOrderRtngLine."Next Operation No." = '') THEN
            EXIT(FALSE);

        ReservEntry.SetSourceFilter(DATABASE::"Prod. Order Line", 3, ItemJnlLine."Order No.", 0, TRUE);
        ReservEntry.SetSourceFilter('', ItemJnlLine."Order Line No.");
        ReservEntry.SETFILTER("Qty. to Handle (Base)", '<>0');
        IF SumUpItemTracking(ReservEntry, TempHandlingSpecification, FALSE, TRUE) THEN BEGIN
            ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Prospect);
            IF NOT ReservEntry.ISEMPTY THEN
                ReservEntry.DELETEALL;
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    END;



    //[External]
    PROCEDURE SumUpItemTracking(VAR ReservEntry: Record 337; VAR TempHandlingSpecification: Record 336 TEMPORARY; SumPerLine: Boolean; SumPerLotSN: Boolean): Boolean;
    VAR
        NextEntryNo: Integer;
        ExpDate: Date;
        EntriesExist: Boolean;
    BEGIN
        // Sum up Item Tracking in a temporary table (to defragment the ReservEntry records)
        TempHandlingSpecification.RESET;
        TempHandlingSpecification.DELETEALL;
        IF SumPerLotSN THEN
            TempHandlingSpecification.SETCURRENTKEY("Lot No.", "Serial No.");

        IF ReservEntry.FINDSET THEN
            REPEAT
                IF ReservEntry.TrackingExists THEN BEGIN
                    IF SumPerLine THEN
                        TempHandlingSpecification.SETRANGE("Source Ref. No.", ReservEntry."Source Ref. No."); // Sum up line per line
                    IF SumPerLotSN THEN BEGIN
                        TempHandlingSpecification.SetTrackingFilterFromReservEntry(ReservEntry);
                        IF ReservEntry."New Serial No." <> '' THEN
                            TempHandlingSpecification.SETRANGE("New Serial No.", ReservEntry."New Serial No.");
                        IF ReservEntry."New Lot No." <> '' THEN
                            TempHandlingSpecification.SETRANGE("New Lot No.", ReservEntry."New Lot No.");
                    END;
                    OnBeforeFindTempHandlingSpecification(TempHandlingSpecification, ReservEntry);
                    IF TempHandlingSpecification.FINDFIRST THEN BEGIN
                        TempHandlingSpecification."Quantity (Base)" += ReservEntry."Quantity (Base)";
                        TempHandlingSpecification."Qty. to Handle (Base)" += ReservEntry."Qty. to Handle (Base)";
                        TempHandlingSpecification."Qty. to Invoice (Base)" += ReservEntry."Qty. to Invoice (Base)";
                        TempHandlingSpecification."Quantity Invoiced (Base)" += ReservEntry."Quantity Invoiced (Base)";
                        TempHandlingSpecification."Qty. to Handle" :=
                          TempHandlingSpecification."Qty. to Handle (Base)" /
                          ReservEntry."Qty. per Unit of Measure";
                        TempHandlingSpecification."Qty. to Invoice" :=
                          TempHandlingSpecification."Qty. to Invoice (Base)" /
                          ReservEntry."Qty. per Unit of Measure";
                        IF ReservEntry."Reservation Status".AsInteger() > ReservEntry."Reservation Status"::Tracking.AsInteger() THEN
                            TempHandlingSpecification."Buffer Value1" += // Late Binding
                              TempHandlingSpecification."Qty. to Handle (Base)";
                        TempHandlingSpecification.MODIFY;
                    END ELSE BEGIN
                        TempHandlingSpecification.INIT;
                        TempHandlingSpecification.TRANSFERFIELDS(ReservEntry);
                        NextEntryNo += 1;
                        TempHandlingSpecification."Entry No." := NextEntryNo;
                        TempHandlingSpecification."Qty. to Handle" :=
                          TempHandlingSpecification."Qty. to Handle (Base)" /
                          ReservEntry."Qty. per Unit of Measure";
                        TempHandlingSpecification."Qty. to Invoice" :=
                          TempHandlingSpecification."Qty. to Invoice (Base)" /
                          ReservEntry."Qty. per Unit of Measure";
                        IF ReservEntry."Reservation Status".AsInteger() > ReservEntry."Reservation Status"::Tracking.AsInteger() THEN
                            TempHandlingSpecification."Buffer Value1" += // Late Binding
                              TempHandlingSpecification."Qty. to Handle (Base)";
                        ExpDate :=
                          ExistingExpirationDate(
                            ReservEntry."Item No.", ReservEntry."Variant Code", ReservEntry."Lot No.", ReservEntry."Serial No.", FALSE, EntriesExist);
                        IF EntriesExist THEN
                            TempHandlingSpecification."Expiration Date" := ExpDate;
                        TempHandlingSpecification.INSERT;
                    END;
                END;
            UNTIL ReservEntry.NEXT = 0;

        TempHandlingSpecification.RESET;
        EXIT(TempHandlingSpecification.FINDFIRST);
    END;

    //[External]
    PROCEDURE SumUpItemTrackingOnlyInventoryOrATO(VAR ReservationEntry: Record 337; VAR TrackingSpecification: Record 336; SumPerLine: Boolean; SumPerLotSN: Boolean): Boolean;
    VAR
        TempReservationEntry: Record 337 TEMPORARY;
    BEGIN
        IF ReservationEntry.FINDSET THEN
            REPEAT
                IF (ReservationEntry."Reservation Status" <> ReservationEntry."Reservation Status"::Reservation) OR
                   IsResEntryReservedAgainstInventory(ReservationEntry)
                THEN BEGIN
                    TempReservationEntry := ReservationEntry;
                    TempReservationEntry.INSERT;
                END;
            UNTIL ReservationEntry.NEXT = 0;

        EXIT(SumUpItemTracking(TempReservationEntry, TrackingSpecification, SumPerLine, SumPerLotSN));
    END;

    LOCAL PROCEDURE IsResEntryReservedAgainstInventory(ReservationEntry: Record 337): Boolean;
    VAR
        ReservationEntry2: Record 337;
    BEGIN
        IF (ReservationEntry."Reservation Status" <> ReservationEntry."Reservation Status"::Reservation) OR
           ReservationEntry.Positive
        THEN
            EXIT(FALSE);

        ReservationEntry2.GET(ReservationEntry."Entry No.", NOT ReservationEntry.Positive);
        IF ReservationEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN
            EXIT(TRUE);

        EXIT(IsResEntryReservedAgainstATO(ReservationEntry));
    END;

    LOCAL PROCEDURE IsResEntryReservedAgainstATO(ReservationEntry: Record 337): Boolean;
    VAR
        ReservationEntry2: Record 337;
        SalesLine: Record 37;
        AssembleToOrderLink: Record 904;
    BEGIN
        IF (ReservationEntry."Source Type" <> DATABASE::"Sales Line") OR
           (ReservationEntry."Source Subtype" <> SalesLine."Document Type"::Order.AsInteger()) OR
           (NOT SalesLine.GET(ReservationEntry."Source Subtype", ReservationEntry."Source ID", ReservationEntry."Source Ref. No.")) OR
           (NOT AssembleToOrderLink.AsmExistsForSalesLine(SalesLine))
        THEN
            EXIT(FALSE);

        ReservationEntry2.GET(ReservationEntry."Entry No.", NOT ReservationEntry.Positive);
        IF (ReservationEntry2."Source Type" <> DATABASE::"Assembly Header") OR
           (ReservationEntry2."Source Subtype" <> AssembleToOrderLink."Assembly Document Type".AsInteger()) OR
           (ReservationEntry2."Source ID" <> AssembleToOrderLink."Assembly Document No.")
        THEN
            EXIT(FALSE);

        EXIT(TRUE);
    END;


    //[External]
    PROCEDURE ComposeRowID(Type: Integer; Subtype: Integer; ID: Code[20]; BatchName: Code[10]; ProdOrderLine: Integer; RefNo: Integer): Text[250];
    VAR
        StrArray: ARRAY[2] OF Text[100];
        Pos: Integer;
        Len: Integer;
        T: Integer;
    BEGIN
        StrArray[1] := ID;
        StrArray[2] := BatchName;
        FOR T := 1 TO 2 DO
            IF STRPOS(StrArray[T], '"') > 0 THEN BEGIN
                Len := STRLEN(StrArray[T]);
                Pos := 1;
                REPEAT
                    IF COPYSTR(StrArray[T], Pos, 1) = '"' THEN BEGIN
                        StrArray[T] := INSSTR(StrArray[T], '"', Pos + 1);
                        Len += 1;
                        Pos += 1;
                    END;
                    Pos += 1;
                UNTIL Pos > Len;
            END;
        EXIT(STRSUBSTNO('"%1";"%2";"%3";"%4";"%5";"%6"', Type, Subtype, StrArray[1], StrArray[2], ProdOrderLine, RefNo));
    END;

    //[External]
    PROCEDURE CopyItemTracking(FromRowID: Text[250]; ToRowID: Text[250]; SwapSign: Boolean);
    BEGIN
        CopyItemTracking2(FromRowID, ToRowID, SwapSign, FALSE);
    END;

    //[External]
    PROCEDURE CopyItemTracking2(FromRowID: Text[250]; ToRowID: Text[250]; SwapSign: Boolean; SkipReservation: Boolean);
    VAR
        ReservEntry: Record 337;
    BEGIN
        ReservEntry.SetPointer(FromRowID);
        ReservEntry.SetPointerFilter;
        CopyItemTracking3(ReservEntry, ToRowID, SwapSign, SkipReservation);
    END;

    LOCAL PROCEDURE CopyItemTracking3(VAR ReservEntry: Record 337; ToRowID: Text[250]; SwapSign: Boolean; SkipReservation: Boolean);
    VAR
        ReservEntry1: Record 337;
        TempReservEntry: Record 337 TEMPORARY;
    BEGIN
        IF SkipReservation THEN
            ReservEntry.SETFILTER("Reservation Status", '<>%1', ReservEntry."Reservation Status"::Reservation);
        IF ReservEntry.FINDSET THEN BEGIN
            REPEAT
                IF ReservEntry.TrackingExists THEN BEGIN
                    TempReservEntry := ReservEntry;
                    TempReservEntry."Reservation Status" := TempReservEntry."Reservation Status"::Prospect;
                    TempReservEntry.SetPointer(ToRowID);
                    IF SwapSign THEN BEGIN
                        TempReservEntry."Quantity (Base)" := -TempReservEntry."Quantity (Base)";
                        TempReservEntry.Quantity := -TempReservEntry.Quantity;
                        TempReservEntry."Qty. to Handle (Base)" := -TempReservEntry."Qty. to Handle (Base)";
                        TempReservEntry."Qty. to Invoice (Base)" := -TempReservEntry."Qty. to Invoice (Base)";
                        TempReservEntry."Quantity Invoiced (Base)" := -TempReservEntry."Quantity Invoiced (Base)";
                        TempReservEntry.Positive := TempReservEntry."Quantity (Base)" > 0;
                        TempReservEntry.ClearApplFromToItemEntry;
                    END;
                    TempReservEntry.INSERT;
                END;
            UNTIL ReservEntry.NEXT = 0;

            ModifyTemp337SetIfTransfer(TempReservEntry);

            IF TempReservEntry.FINDSET THEN BEGIN
                ReservEntry1.RESET;
                REPEAT
                    ReservEntry1 := TempReservEntry;
                    ReservEntry1."Entry No." := 0;
                    ReservEntry1.INSERT;
                UNTIL TempReservEntry.NEXT = 0;
            END;
        END;
    END;

    //[External]
    PROCEDURE CopyHandledItemTrkgToInvLine(FromSalesLine: Record 37; ToSalesInvLine: Record 37);
    VAR
        ItemEntryRelation: Record 6507;
    BEGIN
        // Used for combined shipment/returns:
        IF FromSalesLine.Type <> FromSalesLine.Type::Item THEN
            EXIT;

        CASE ToSalesInvLine."Document Type" OF
            ToSalesInvLine."Document Type"::Invoice:
                BEGIN
                    ItemEntryRelation.SetSourceFilter(
                      DATABASE::"Sales Shipment Line", 0, ToSalesInvLine."Shipment No.", ToSalesInvLine."Shipment Line No.", TRUE);
                    ItemEntryRelation.SetSourceFilter2('', 0);
                END;
            ToSalesInvLine."Document Type"::"Credit Memo":
                BEGIN
                    ItemEntryRelation.SetSourceFilter(
                      DATABASE::"Return Receipt Line", 0, ToSalesInvLine."Return Receipt No.", ToSalesInvLine."Return Receipt Line No.", TRUE);
                    ItemEntryRelation.SetSourceFilter2('', 0);
                END;
            ELSE
                ToSalesInvLine.FIELDERROR("Document Type", FORMAT(ToSalesInvLine."Document Type"));
        END;

        InsertProspectReservEntryFromItemEntryRelationAndSourceData(
          ItemEntryRelation, ToSalesInvLine."Document Type", ToSalesInvLine."Document No.", ToSalesInvLine."Line No.");
    END;

    //[External]
    PROCEDURE CopyHandledItemTrkgToInvLine2(FromPurchLine: Record 39; ToPurchLine: Record 39);
    BEGIN
        CopyHandledItemTrkgToPurchLine(FromPurchLine, ToPurchLine, FALSE);
    END;



    LOCAL PROCEDURE CopyHandledItemTrkgToPurchLine(FromPurchLine: Record 39; ToPurchLine: Record 39; CheckLineQty: Boolean);
    VAR
        ItemEntryRelation: Record 6507;
        TrackingSpecification: Record 336;
        QtyBase: Decimal;
    BEGIN
        // Used for combined receipts/returns:
        IF FromPurchLine.Type <> FromPurchLine.Type::Item THEN
            EXIT;

        CASE ToPurchLine."Document Type" OF
            ToPurchLine."Document Type"::Invoice:
                BEGIN
                    ItemEntryRelation.SetSourceFilter(
                      DATABASE::"Purch. Rcpt. Line", 0, ToPurchLine."Receipt No.", ToPurchLine."Receipt Line No.", TRUE);
                    ItemEntryRelation.SetSourceFilter2('', 0);
                END;
            ToPurchLine."Document Type"::"Credit Memo":
                BEGIN
                    ItemEntryRelation.SetSourceFilter(
                      DATABASE::"Return Shipment Line", 0, ToPurchLine."Return Shipment No.", ToPurchLine."Return Shipment Line No.", TRUE);
                    ItemEntryRelation.SetSourceFilter2('', 0);
                END;
            ELSE
                ToPurchLine.FIELDERROR("Document Type", FORMAT(ToPurchLine."Document Type"));
        END;

        IF NOT ItemEntryRelation.FINDSET THEN
            EXIT;

        REPEAT
            TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
            QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
            IF CheckLineQty AND (QtyBase > ToPurchLine.Quantity) THEN
                QtyBase := ToPurchLine.Quantity;
            InsertReservEntryFromTrackingSpec(
              TrackingSpecification, ToPurchLine."Document Type", ToPurchLine."Document No.", ToPurchLine."Line No.", QtyBase);
        UNTIL ItemEntryRelation.NEXT = 0;
    END;



    //[External]
    PROCEDURE CollectItemEntryRelation(VAR TempItemLedgEntry: Record 32 TEMPORARY; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer; TotalQty: Decimal): Boolean;
    VAR
        ItemLedgEntry: Record 32;
        ItemEntryRelation: Record 6507;
        Quantity: Decimal;
    BEGIN
        Quantity := 0;
        TempItemLedgEntry.RESET;
        TempItemLedgEntry.DELETEALL;
        ItemEntryRelation.SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, TRUE);
        ItemEntryRelation.SetSourceFilter2(SourceBatchName, SourceProdOrderLine);
        IF ItemEntryRelation.FINDSET THEN
            REPEAT
                ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.INSERT;
                Quantity := Quantity + ItemLedgEntry.Quantity;
            UNTIL ItemEntryRelation.NEXT = 0;
        EXIT(Quantity = TotalQty);
    END;



    //[External]
    PROCEDURE SplitWhseJnlLine(TempWhseJnlLine: Record 7311 TEMPORARY; VAR TempWhseJnlLine2: Record 7311 TEMPORARY; VAR TempWhseSplitSpecification: Record 7311 TEMPORARY; ToTransfer: Boolean);
    VAR
        NonDistrQtyBase: Decimal;
        NonDistrCubage: Decimal;
        NonDistrWeight: Decimal;
        SplitFactor: Decimal;
        LineNo: Integer;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    BEGIN
        TempWhseJnlLine2.DELETEALL;

        CheckWhseItemTrkgSetup(TempWhseJnlLine."Item No.", WhseSNRequired, WhseLNRequired, FALSE);
        IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
            TempWhseJnlLine2 := TempWhseJnlLine;
            TempWhseJnlLine2.INSERT;
            OnAfterSplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2);
            EXIT;
        END;

        LineNo := TempWhseJnlLine."Line No.";
        WITH TempWhseSplitSpecification DO BEGIN
            RESET;
            // CASE TempWhseJnlLine."Source Type" OF
            //     DATABASE::"Item Journal Line",
            //   DATABASE::"Job Journal Line":
                    // TempWhseJnlLine.SetSourceFilter(
                    //   TempWhseJnlLine."Source Type", -1, TempWhseJnlLine."Journal Template Name", TempWhseJnlLine."Source Line No.", TRUE);
                // 0: // Whse. journal line
                    // TempWhseJnlLine.SetSourceFilter(
                    //   DATABASE::"Warehouse Journal Line", -1, TempWhseJnlLine."Journal Batch Name", TempWhseJnlLine."Line No.", TRUE);
                // ELSE
                    // TempWhseJnlLine.SetSourceFilter(
                    //   TempWhseJnlLine."Source Type", -1, TempWhseJnlLine."Source No.", TempWhseJnlLine."Source Line No.", TRUE);
            // END;
            // SETFILTER("Quantity actual Handled (Base)", '<>%1', 0);
            NonDistrQtyBase := TempWhseJnlLine."Qty. (Absolute, Base)";
            NonDistrCubage := TempWhseJnlLine.Cubage;
            NonDistrWeight := TempWhseJnlLine.Weight;
            IF FINDSET THEN
                REPEAT
                    LineNo += 10000;
                    TempWhseJnlLine2 := TempWhseJnlLine;
                    TempWhseJnlLine2."Line No." := LineNo;

                    // IF "Serial No." <> '' THEN
                    //     IF ABS("Quantity (Base)") <> 1 THEN
                    //         FIELDERROR("Quantity (Base)");

                    IF ToTransfer THEN BEGIN
                        SetWhseSerialLotNo(TempWhseJnlLine2."Serial No.", "New Serial No.", WhseSNRequired);
                        SetWhseSerialLotNo(TempWhseJnlLine2."Lot No.", "New Lot No.", WhseLNRequired);
                        IF "New Expiration Date" <> 0D THEN
                            TempWhseJnlLine2."Expiration Date" := "New Expiration Date"
                    END ELSE BEGIN
                        SetWhseSerialLotNo(TempWhseJnlLine2."Serial No.", "Serial No.", WhseSNRequired);
                        SetWhseSerialLotNo(TempWhseJnlLine2."Lot No.", "Lot No.", WhseLNRequired);
                        TempWhseJnlLine2."Expiration Date" := "Expiration Date";
                    END;
                    SetWhseSerialLotNo(TempWhseJnlLine2."New Serial No.", "New Serial No.", WhseSNRequired);
                    SetWhseSerialLotNo(TempWhseJnlLine2."New Lot No.", "New Lot No.", WhseLNRequired);
                    TempWhseJnlLine2."New Expiration Date" := "New Expiration Date";
                    TempWhseJnlLine2."Warranty Date" := "Warranty Date";
                    // TempWhseJnlLine2."Qty. (Absolute, Base)" := ABS("Quantity (Base)");
                    TempWhseJnlLine2."Qty. (Absolute)" :=
                      ROUND(TempWhseJnlLine2."Qty. (Absolute, Base)" / TempWhseJnlLine."Qty. per Unit of Measure", 0.00001);
                    IF TempWhseJnlLine.Quantity > 0 THEN BEGIN
                        TempWhseJnlLine2."Qty. (Base)" := TempWhseJnlLine2."Qty. (Absolute, Base)";
                        TempWhseJnlLine2.Quantity := TempWhseJnlLine2."Qty. (Absolute)";
                    END ELSE BEGIN
                        TempWhseJnlLine2."Qty. (Base)" := -TempWhseJnlLine2."Qty. (Absolute, Base)";
                        TempWhseJnlLine2.Quantity := -TempWhseJnlLine2."Qty. (Absolute)";
                    END;
                    // SplitFactor := "Quantity (Base)" / NonDistrQtyBase;
                    IF SplitFactor < 1 THEN BEGIN
                        TempWhseJnlLine2.Cubage := ROUND(NonDistrCubage * SplitFactor, 0.00001);
                        TempWhseJnlLine2.Weight := ROUND(NonDistrWeight * SplitFactor, 0.00001);
                        // NonDistrQtyBase -= "Quantity (Base)";
                        NonDistrCubage -= TempWhseJnlLine2.Cubage;
                        NonDistrWeight -= TempWhseJnlLine2.Weight;
                    END ELSE BEGIN // the last record
                        TempWhseJnlLine2.Cubage := NonDistrCubage;
                        TempWhseJnlLine2.Weight := NonDistrWeight;
                    END;
                    OnBeforeTempWhseJnlLine2Insert(TempWhseJnlLine2, TempWhseJnlLine, TempWhseSplitSpecification, ToTransfer);
                    TempWhseJnlLine2.INSERT;
                UNTIL NEXT = 0
            ELSE BEGIN
                TempWhseJnlLine2 := TempWhseJnlLine;
                OnBeforeTempWhseJnlLine2Insert(TempWhseJnlLine2, TempWhseJnlLine, TempWhseSplitSpecification, ToTransfer);
                TempWhseJnlLine2.INSERT;
            END;
        END;

        OnAfterSplitWhseJnlLine(TempWhseJnlLine, TempWhseJnlLine2);
    END;

    //[External]
    PROCEDURE SplitPostedWhseRcptLine(PostedWhseRcptLine: Record 7319; VAR TempPostedWhseRcptLine: Record 7319 TEMPORARY);
    VAR
        WhseItemEntryRelation: Record 6509;
        ItemLedgEntry: Record 32;
        LineNo: Integer;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
        CrossDockQty: Decimal;
        CrossDockQtyBase: Decimal;
    BEGIN
        TempPostedWhseRcptLine.RESET;
        TempPostedWhseRcptLine.DELETEALL;

        CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.", WhseSNRequired, WhseLNRequired, FALSE);
        IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
            TempPostedWhseRcptLine := PostedWhseRcptLine;
            TempPostedWhseRcptLine.INSERT;
            OnAfterSplitPostedWhseReceiptLine(PostedWhseRcptLine, TempPostedWhseRcptLine);
            EXIT;
        END;

        WhseItemEntryRelation.RESET;
        WhseItemEntryRelation.SetSourceFilter(
          DATABASE::"Posted Whse. Receipt Line", 0, PostedWhseRcptLine."No.", PostedWhseRcptLine."Line No.", TRUE);
        IF WhseItemEntryRelation.FINDSET THEN BEGIN
            REPEAT
                ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
                TempPostedWhseRcptLine.SETRANGE("Serial No.", ItemLedgEntry."Serial No.");
                TempPostedWhseRcptLine.SETRANGE("Lot No.", ItemLedgEntry."Lot No.");
                TempPostedWhseRcptLine.SETRANGE("Warranty Date", ItemLedgEntry."Warranty Date");
                TempPostedWhseRcptLine.SETRANGE("Expiration Date", ItemLedgEntry."Expiration Date");
                OnTempPostedWhseRcptLineSetFilters(TempPostedWhseRcptLine, ItemLedgEntry, WhseItemEntryRelation);
                IF TempPostedWhseRcptLine.FINDFIRST THEN BEGIN
                    TempPostedWhseRcptLine."Qty. (Base)" += ItemLedgEntry.Quantity;
                    TempPostedWhseRcptLine.Quantity :=
                      ROUND(TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure", 0.00001);
                    TempPostedWhseRcptLine.MODIFY;

                    CrossDockQty := CrossDockQty - TempPostedWhseRcptLine."Qty. Cross-Docked";
                    CrossDockQtyBase := CrossDockQtyBase - TempPostedWhseRcptLine."Qty. Cross-Docked (Base)";
                END ELSE BEGIN
                    LineNo += 10000;
                    TempPostedWhseRcptLine.RESET;
                    TempPostedWhseRcptLine := PostedWhseRcptLine;
                    TempPostedWhseRcptLine."Line No." := LineNo;
                    // TempPostedWhseRcptLine.SetTracking(
                    //   WhseItemEntryRelation."Serial No.", WhseItemEntryRelation."Lot No.",
                    //   ItemLedgEntry."Warranty Date", ItemLedgEntry."Expiration Date");
                    TempPostedWhseRcptLine."Qty. (Base)" := ItemLedgEntry.Quantity;
                    TempPostedWhseRcptLine.Quantity :=
                      ROUND(TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure", 0.00001);
                    OnBeforeInsertSplitPostedWhseRcptLine(TempPostedWhseRcptLine, PostedWhseRcptLine, WhseItemEntryRelation);
                    TempPostedWhseRcptLine.INSERT;
                END;

                IF WhseSNRequired THEN BEGIN
                    IF CrossDockQty < PostedWhseRcptLine."Qty. Cross-Docked" THEN BEGIN
                        TempPostedWhseRcptLine."Qty. Cross-Docked" := TempPostedWhseRcptLine.Quantity;
                        TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptLine."Qty. (Base)";
                    END ELSE BEGIN
                        TempPostedWhseRcptLine."Qty. Cross-Docked" := 0;
                        TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
                    END;
                    CrossDockQty := CrossDockQty + TempPostedWhseRcptLine.Quantity;
                END ELSE
                    IF PostedWhseRcptLine."Qty. Cross-Docked" > 0 THEN BEGIN
                        IF TempPostedWhseRcptLine.Quantity <=
                           PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty
                        THEN BEGIN
                            TempPostedWhseRcptLine."Qty. Cross-Docked" := TempPostedWhseRcptLine.Quantity;
                            TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptLine."Qty. (Base)";
                        END ELSE BEGIN
                            TempPostedWhseRcptLine."Qty. Cross-Docked" := PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty;
                            TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" :=
                              PostedWhseRcptLine."Qty. Cross-Docked (Base)" - CrossDockQtyBase;
                        END;
                        CrossDockQty := CrossDockQty + TempPostedWhseRcptLine."Qty. Cross-Docked";
                        CrossDockQtyBase := CrossDockQtyBase + TempPostedWhseRcptLine."Qty. Cross-Docked (Base)";
                        IF CrossDockQty >= PostedWhseRcptLine."Qty. Cross-Docked" THEN BEGIN
                            PostedWhseRcptLine."Qty. Cross-Docked" := 0;
                            PostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
                        END;
                    END;
                TempPostedWhseRcptLine.MODIFY;
            UNTIL WhseItemEntryRelation.NEXT = 0;
        END ELSE BEGIN
            TempPostedWhseRcptLine := PostedWhseRcptLine;
            TempPostedWhseRcptLine.INSERT;
        END;

        OnAfterSplitPostedWhseReceiptLine(PostedWhseRcptLine, TempPostedWhseRcptLine);
    END;

    //[External]
    PROCEDURE SplitInternalPutAwayLine(PostedWhseRcptLine: Record 7319; VAR TempPostedWhseRcptLine: Record 7319 TEMPORARY);
    VAR
        WhseItemTrackingLine: Record 6550;
        LineNo: Integer;
        WhseSNRequired: Boolean;
        WhseLNRequired: Boolean;
    BEGIN
        TempPostedWhseRcptLine.DELETEALL;

        CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.", WhseSNRequired, WhseLNRequired, FALSE);
        IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
            TempPostedWhseRcptLine := PostedWhseRcptLine;
            TempPostedWhseRcptLine.INSERT;
            EXIT;
        END;

        WhseItemTrackingLine.RESET;
        WhseItemTrackingLine.SetSourceFilter(
          DATABASE::"Whse. Internal Put-away Line", 0, PostedWhseRcptLine."No.", PostedWhseRcptLine."Line No.", TRUE);
        WhseItemTrackingLine.SetSourceFilter('', 0);
        WhseItemTrackingLine.SETFILTER("Qty. to Handle (Base)", '<>0');
        IF WhseItemTrackingLine.FINDSET THEN
            REPEAT
                LineNo += 10000;
                TempPostedWhseRcptLine := PostedWhseRcptLine;
                TempPostedWhseRcptLine."Line No." := LineNo;
                // TempPostedWhseRcptLine.SetTracking(
                //   WhseItemTrackingLine."Serial No.", WhseItemTrackingLine."Lot No.",
                //   WhseItemTrackingLine."Warranty Date", WhseItemTrackingLine."Expiration Date");
                TempPostedWhseRcptLine."Qty. (Base)" := WhseItemTrackingLine."Qty. to Handle (Base)";
                TempPostedWhseRcptLine.Quantity :=
                  ROUND(TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure", 0.00001);
                OnBeforeInsertSplitInternalPutAwayLine(TempPostedWhseRcptLine, PostedWhseRcptLine, WhseItemTrackingLine);
                TempPostedWhseRcptLine.INSERT;
            UNTIL WhseItemTrackingLine.NEXT = 0
        ELSE BEGIN
            TempPostedWhseRcptLine := PostedWhseRcptLine;
            TempPostedWhseRcptLine.INSERT;
        END
    END;



    LOCAL PROCEDURE RemoveItemTrkgFromReservEntry(WhseItemTrackingLine: Record 6550);
    VAR
        ReservEntry: Record 337;
        WarehouseShipmentLine: Record 7321;
    BEGIN
        WarehouseShipmentLine.SETRANGE("No.", WhseItemTrackingLine."Source ID");
        WarehouseShipmentLine.SETRANGE("Line No.", WhseItemTrackingLine."Source Ref. No.");
        IF NOT WarehouseShipmentLine.FINDFIRST THEN
            EXIT;

        ReservEntry.SetSourceFilter(
          WarehouseShipmentLine."Source Type", WarehouseShipmentLine."Source Subtype",
          WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.", TRUE);
        ReservEntry.SetTrackingFilterFromWhseSpec(WhseItemTrackingLine);
        IF ReservEntry.FINDSET THEN
            REPEAT
                CASE ReservEntry."Reservation Status" OF
                    ReservEntry."Reservation Status"::Surplus:
                        ReservEntry.DELETE(TRUE);
                    ELSE BEGIN
                        ReservEntry.ClearItemTrackingFields;
                        ReservEntry.MODIFY(TRUE);
                    END;
                END;
            UNTIL ReservEntry.NEXT = 0;
    END;



    //[External]
    PROCEDURE InitTrackingSpecification(WhseWkshLine: Record 7326);
    VAR
        WhseItemTrkgLine: Record 6550;
        PostedWhseReceiptLine: Record 7319;
        TempWhseItemTrkgLine: Record 6550 TEMPORARY;
        WhseManagement: Codeunit 5775;
        SourceType: Integer;
    BEGIN
        SourceType := WhseManagement.GetSourceType(WhseWkshLine);
        WITH WhseWkshLine DO BEGIN
            IF "Whse. Document Type" = "Whse. Document Type"::Receipt THEN BEGIN
                PostedWhseReceiptLine.SETRANGE("No.", "Whse. Document No.");
                PostedWhseReceiptLine.SETRANGE("Line No.", "Whse. Document Line No.");
                IF PostedWhseReceiptLine.FINDFIRST THEN
                    InsertWhseItemTrkgLines(PostedWhseReceiptLine, SourceType);
            END;

            IF SourceType = DATABASE::"Prod. Order Component" THEN BEGIN
                WhseItemTrkgLine.SetSourceFilter(SourceType, "Source Subtype", "Source No.", "Source Subline No.", TRUE);
                WhseItemTrkgLine.SETRANGE("Source Prod. Order Line", "Source Line No.");
            END ELSE
                WhseItemTrkgLine.SetSourceFilter(SourceType, -1, "Whse. Document No.", "Whse. Document Line No.", TRUE);

            WhseItemTrkgLine.LOCKTABLE;
            IF WhseItemTrkgLine.FINDSET THEN BEGIN
                REPEAT
                    CalcWhseItemTrkgLine(WhseItemTrkgLine);
                    WhseItemTrkgLine.MODIFY;
                    IF SourceType IN [DATABASE::"Prod. Order Component", DATABASE::"Assembly Line"] THEN BEGIN
                        TempWhseItemTrkgLine := WhseItemTrkgLine;
                        TempWhseItemTrkgLine.INSERT;
                    END;
                UNTIL WhseItemTrkgLine.NEXT = 0;
                IF NOT TempWhseItemTrkgLine.ISEMPTY THEN
                    CheckWhseItemTrkg(TempWhseItemTrkgLine, WhseWkshLine);
            END ELSE
                CASE SourceType OF
                    DATABASE::"Posted Whse. Receipt Line":
                        CreateWhseItemTrkgForReceipt(WhseWkshLine);
                    DATABASE::"Warehouse Shipment Line":
                        CreateWhseItemTrkgBatch(WhseWkshLine);
                    DATABASE::"Prod. Order Component":
                        CreateWhseItemTrkgBatch(WhseWkshLine);
                    DATABASE::"Assembly Line":
                        CreateWhseItemTrkgBatch(WhseWkshLine);
                END;
        END;
    END;

    LOCAL PROCEDURE CreateWhseItemTrkgForReceipt(WhseWkshLine: Record 7326);
    VAR
        ItemLedgEntry: Record 32;
        WhseItemEntryRelation: Record 6509;
        WhseItemTrackingLine: Record 6550;
        EntryNo: Integer;
    BEGIN
        WITH WhseWkshLine DO BEGIN
            WhseItemTrackingLine.RESET;
            IF WhseItemTrackingLine.FINDLAST THEN
                EntryNo := WhseItemTrackingLine."Entry No.";

            WhseItemEntryRelation.SetSourceFilter(
              DATABASE::"Posted Whse. Receipt Line", 0, "Whse. Document No.", "Whse. Document Line No.", TRUE);
            IF WhseItemEntryRelation.FINDSET THEN
                REPEAT
                    WhseItemTrackingLine.INIT;
                    EntryNo += 1;
                    WhseItemTrackingLine."Entry No." := EntryNo;
                    WhseItemTrackingLine."Item No." := "Item No.";
                    WhseItemTrackingLine."Variant Code" := "Variant Code";
                    WhseItemTrackingLine."Location Code" := "Location Code";
                    WhseItemTrackingLine.Description := Description;
                    WhseItemTrackingLine."Qty. per Unit of Measure" := "Qty. per From Unit of Measure";
                    WhseItemTrackingLine.SetSource(
                      DATABASE::"Posted Whse. Receipt Line", 0, "Whse. Document No.", "Whse. Document Line No.", '', 0);
                    ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
                    WhseItemTrackingLine.CopyTrackingFromItemLedgEntry(ItemLedgEntry);
                    WhseItemTrackingLine."Quantity (Base)" := ItemLedgEntry.Quantity;
                    IF "Qty. (Base)" = "Qty. to Handle (Base)" THEN
                        WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
                    WhseItemTrackingLine."Qty. to Handle" :=
                      ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure", 0.00001);
                    OnBeforeCreateWhseItemTrkgForReceipt(WhseItemTrackingLine, WhseWkshLine);
                    WhseItemTrackingLine.INSERT;
                UNTIL WhseItemEntryRelation.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CreateWhseItemTrkgBatch(WhseWkshLine: Record 7326);
    VAR
        SourceItemTrackingLine: Record 337;
        WhseManagement: Codeunit 5775;
        SourceType: Integer;
    BEGIN
        SourceType := WhseManagement.GetSourceType(WhseWkshLine);

        WITH WhseWkshLine DO BEGIN
            CASE SourceType OF
                DATABASE::"Prod. Order Component":
                    BEGIN
                        SourceItemTrackingLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Subline No.", TRUE);
                        SourceItemTrackingLine.SetSourceFilter('', "Source Line No.");
                    END;
                ELSE BEGIN
                    SourceItemTrackingLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", TRUE);
                    SourceItemTrackingLine.SetSourceFilter('', 0);
                END;
            END;
            IF SourceItemTrackingLine.FINDSET THEN
                REPEAT
                    CreateWhseItemTrkgForResEntry(SourceItemTrackingLine, WhseWkshLine);
                UNTIL SourceItemTrackingLine.NEXT = 0;
        END;
    END;

    //[External]
    PROCEDURE CreateWhseItemTrkgForResEntry(SourceReservEntry: Record 337; WhseWkshLine: Record 7326);
    VAR
        WhseItemTrackingLine: Record 6550;
        WhseManagement: Codeunit 5775;
        EntryNo: Integer;
        SourceType: Integer;
    BEGIN
        IF NOT ((SourceReservEntry."Reservation Status" <> SourceReservEntry."Reservation Status"::Reservation) OR
                IsResEntryReservedAgainstInventory(SourceReservEntry))
        THEN
            EXIT;

        IF NOT SourceReservEntry.TrackingExists THEN
            EXIT;

        SourceType := WhseManagement.GetSourceType(WhseWkshLine);

        IF WhseItemTrackingLine.FINDLAST THEN
            EntryNo := WhseItemTrackingLine."Entry No.";

        WhseItemTrackingLine.INIT;

        WITH WhseWkshLine DO
            CASE SourceType OF
                DATABASE::"Posted Whse. Receipt Line":
                    WhseItemTrackingLine.SetSource(
                      DATABASE::"Posted Whse. Receipt Line", 0, "Whse. Document No.", "Whse. Document Line No.", '', 0);
                DATABASE::"Warehouse Shipment Line":
                    WhseItemTrackingLine.SetSource(
                      DATABASE::"Warehouse Shipment Line", 0, "Whse. Document No.", "Whse. Document Line No.", '', 0);
                DATABASE::"Assembly Line":
                    WhseItemTrackingLine.SetSource(
                      DATABASE::"Assembly Line", "Source Subtype", "Whse. Document No.", "Whse. Document Line No.", '', 0);
                DATABASE::"Prod. Order Component":
                    WhseItemTrackingLine.SetSource(
                      "Source Type", "Source Subtype", "Source No.", "Source Subline No.", '', "Source Line No.");
            END;

        WhseItemTrackingLine."Entry No." := EntryNo + 1;
        WhseItemTrackingLine."Item No." := SourceReservEntry."Item No.";
        WhseItemTrackingLine."Variant Code" := SourceReservEntry."Variant Code";
        WhseItemTrackingLine."Location Code" := SourceReservEntry."Location Code";
        WhseItemTrackingLine.Description := SourceReservEntry.Description;
        WhseItemTrackingLine."Qty. per Unit of Measure" := SourceReservEntry."Qty. per Unit of Measure";
        WhseItemTrackingLine.CopyTrackingFromReservEntry(SourceReservEntry);
        WhseItemTrackingLine."Quantity (Base)" := -SourceReservEntry."Quantity (Base)";

        IF WhseWkshLine."Qty. Handled (Base)" <> 0 THEN BEGIN
            WhseItemTrackingLine."Quantity Handled (Base)" := WhseWkshLine."Qty. Handled (Base)";
            WhseItemTrackingLine."Qty. Registered (Base)" := WhseWkshLine."Qty. Handled (Base)";
        END ELSE
            IF WhseWkshLine."Qty. (Base)" = WhseWkshLine."Qty. to Handle (Base)" THEN BEGIN
                WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
                WhseItemTrackingLine."Qty. to Handle" := -SourceReservEntry.Quantity;
            END;
        OnBeforeCreateWhseItemTrkgForResEntry(WhseItemTrackingLine, SourceReservEntry, WhseWkshLine);
        WhseItemTrackingLine.INSERT;
    END;

    //[External]
    PROCEDURE CalcWhseItemTrkgLine(VAR WhseItemTrkgLine: Record 6550);
    VAR
        WhseActivQtyBase: Decimal;
    BEGIN
        CASE WhseItemTrkgLine."Source Type" OF
            DATABASE::"Posted Whse. Receipt Line":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Receipt;
            DATABASE::"Whse. Internal Put-away Line":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Internal Put-away";
            DATABASE::"Warehouse Shipment Line":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Shipment;
            DATABASE::"Whse. Internal Pick Line":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Internal Pick";
            DATABASE::"Prod. Order Component":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Production;
            DATABASE::"Assembly Line":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Assembly;
            DATABASE::"Whse. Worksheet Line":
                WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Movement Worksheet";
        END;
        WhseItemTrkgLine.CALCFIELDS("Put-away Qty. (Base)", "Pick Qty. (Base)");

        IF WhseItemTrkgLine."Put-away Qty. (Base)" > 0 THEN
            WhseActivQtyBase := WhseItemTrkgLine."Put-away Qty. (Base)";
        IF WhseItemTrkgLine."Pick Qty. (Base)" > 0 THEN
            WhseActivQtyBase := WhseItemTrkgLine."Pick Qty. (Base)";

        IF NOT Registering THEN
            WhseItemTrkgLine.VALIDATE("Quantity Handled (Base)",
              WhseActivQtyBase + WhseItemTrkgLine."Qty. Registered (Base)")
        ELSE
            WhseItemTrkgLine.VALIDATE("Quantity Handled (Base)",
              WhseItemTrkgLine."Qty. Registered (Base)");

        IF WhseItemTrkgLine."Quantity (Base)" >= WhseItemTrkgLine."Quantity Handled (Base)" THEN
            WhseItemTrkgLine.VALIDATE("Qty. to Handle (Base)",
              WhseItemTrkgLine."Quantity (Base)" - WhseItemTrkgLine."Quantity Handled (Base)");
    END;

    //[External]
    PROCEDURE InitItemTrkgForTempWkshLine(WhseDocType: Enum "Warehouse Worksheet Document Type"; WhseDocNo: Code[20]; WhseDocLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceNo: Code[20]; SourceLineNo: Integer; SourceSublineNo: Integer);
    VAR
        TempWhseWkshLine: Record 7326;
    BEGIN
        InitWhseWkshLine(TempWhseWkshLine, WhseDocType, WhseDocNo, WhseDocLineNo, SourceType, SourceSubtype, SourceNo,
          SourceLineNo, SourceSublineNo);
        InitTrackingSpecification(TempWhseWkshLine);
    END;

    //[External]
    PROCEDURE InitWhseWkshLine(VAR WhseWkshLine: Record 7326; WhseDocType: Enum "Warehouse Worksheet Document Type"; WhseDocNo: Code[20]; WhseDocLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceNo: Code[20]; SourceLineNo: Integer; SourceSublineNo: Integer);
    VAR
        ProdOrderComponent: Record 5407;
    BEGIN
        WhseWkshLine.INIT;
        WhseWkshLine."Whse. Document Type" := WhseDocType;
        WhseWkshLine."Whse. Document No." := WhseDocNo;
        WhseWkshLine."Whse. Document Line No." := WhseDocLineNo;
        WhseWkshLine."Source Type" := SourceType;
        WhseWkshLine."Source Subtype" := SourceSubtype;
        WhseWkshLine."Source No." := SourceNo;
        WhseWkshLine."Source Line No." := SourceLineNo;
        WhseWkshLine."Source Subline No." := SourceSublineNo;

        IF WhseDocType = WhseWkshLine."Whse. Document Type"::Production THEN BEGIN
            ProdOrderComponent.GET(SourceSubtype, SourceNo, SourceLineNo, SourceSublineNo);
            WhseWkshLine."Qty. Handled (Base)" := ProdOrderComponent."Qty. Picked (Base)";
        END;
    END;



    LOCAL PROCEDURE InsertWhseItemTrkgLines(PostedWhseReceiptLine: Record 7319; SourceType: Integer);
    VAR
        WhseItemTrkgLine: Record 6550;
        WhseItemEntryRelation: Record 6509;
        ItemLedgEntry: Record 32;
        EntryNo: Integer;
        QtyHandledBase: Decimal;
        RemQtyHandledBase: Decimal;
    BEGIN
        IF WhseItemTrkgLine.FINDLAST THEN
            EntryNo := WhseItemTrkgLine."Entry No." + 1
        ELSE
            EntryNo := 1;

        WITH PostedWhseReceiptLine DO BEGIN
            WhseItemEntryRelation.RESET;
            WhseItemEntryRelation.SetSourceFilter(SourceType, 0, "No.", "Line No.", TRUE);
            IF WhseItemEntryRelation.FINDSET THEN BEGIN
                WhseItemTrkgLine.SetSourceFilter(SourceType, 0, "No.", "Line No.", FALSE);
                WhseItemTrkgLine.DELETEALL;
                WhseItemTrkgLine.INIT;
                WhseItemTrkgLine.SETCURRENTKEY("Serial No.", "Lot No.");
                REPEAT
                    OnBeforeInsertWhseItemTrkgLinesLoop(PostedWhseReceiptLine, WhseItemEntryRelation, WhseItemTrkgLine);
                    WhseItemTrkgLine.SetTrackingFilterFromRelation(WhseItemEntryRelation);
                    ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
                    IF (WhseItemEntryRelation."Lot No." <> WhseItemTrkgLine."Lot No.") OR
                       (WhseItemEntryRelation."Serial No." <> WhseItemTrkgLine."Serial No.")
                    THEN
                        RemQtyHandledBase := RegisteredPutAwayQtyBase(PostedWhseReceiptLine, WhseItemEntryRelation)
                    ELSE
                        RemQtyHandledBase -= QtyHandledBase;
                    QtyHandledBase := RemQtyHandledBase;
                    IF QtyHandledBase > ItemLedgEntry.Quantity THEN
                        QtyHandledBase := ItemLedgEntry.Quantity;

                    IF NOT WhseItemTrkgLine.FINDFIRST THEN BEGIN
                        WhseItemTrkgLine.INIT;
                        WhseItemTrkgLine."Entry No." := EntryNo;
                        EntryNo := EntryNo + 1;

                        WhseItemTrkgLine."Item No." := ItemLedgEntry."Item No.";
                        WhseItemTrkgLine."Location Code" := ItemLedgEntry."Location Code";
                        WhseItemTrkgLine.Description := ItemLedgEntry.Description;
                        WhseItemTrkgLine.SetSource(
                          WhseItemEntryRelation."Source Type", WhseItemEntryRelation."Source Subtype", WhseItemEntryRelation."Source ID",
                          WhseItemEntryRelation."Source Ref. No.", WhseItemEntryRelation."Source Batch Name",
                          WhseItemEntryRelation."Source Prod. Order Line");
                        // WhseItemTrkgLine.SetTracking(
                        //   WhseItemEntryRelation."Serial No.", WhseItemEntryRelation."Lot No.",
                        //   ItemLedgEntry."Warranty Date", ItemLedgEntry."Expiration Date");
                        WhseItemTrkgLine."Qty. per Unit of Measure" := ItemLedgEntry."Qty. per Unit of Measure";
                        WhseItemTrkgLine."Quantity Handled (Base)" := QtyHandledBase;
                        WhseItemTrkgLine."Qty. Registered (Base)" := QtyHandledBase;
                        WhseItemTrkgLine.VALIDATE("Quantity (Base)", ItemLedgEntry.Quantity);
                        OnBeforeInsertWhseItemTrkgLines(WhseItemTrkgLine, PostedWhseReceiptLine, WhseItemEntryRelation);
                        WhseItemTrkgLine.INSERT;
                    END ELSE BEGIN
                        WhseItemTrkgLine."Quantity Handled (Base)" += QtyHandledBase;
                        WhseItemTrkgLine."Qty. Registered (Base)" += QtyHandledBase;
                        WhseItemTrkgLine.VALIDATE("Quantity (Base)", WhseItemTrkgLine."Quantity (Base)" + ItemLedgEntry.Quantity);
                        OnBeforeModifyWhseItemTrkgLines(WhseItemTrkgLine, PostedWhseReceiptLine, WhseItemEntryRelation);
                        WhseItemTrkgLine.MODIFY;
                    END;
                    OnAfterInsertWhseItemTrkgLinesLoop(PostedWhseReceiptLine, WhseItemEntryRelation, WhseItemTrkgLine);
                UNTIL WhseItemEntryRelation.NEXT = 0;
            END;
        END;
    END;

    LOCAL PROCEDURE RegisteredPutAwayQtyBase(PostedWhseReceiptLine: Record 7319; WhseItemEntryRelation: Record 6509): Decimal;
    VAR
        RegisteredWhseActivityLine: Record 5773;
    BEGIN
        WITH PostedWhseReceiptLine DO BEGIN
            RegisteredWhseActivityLine.RESET;
            RegisteredWhseActivityLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", -1, TRUE);
            RegisteredWhseActivityLine.SetTrackingFilterFromRelation(WhseItemEntryRelation);
            RegisteredWhseActivityLine.SETRANGE("Whse. Document No.", "No.");
            RegisteredWhseActivityLine.SETRANGE("Action Type", RegisteredWhseActivityLine."Action Type"::Take);
            RegisteredWhseActivityLine.CALCSUMS("Qty. (Base)");
        END;

        EXIT(RegisteredWhseActivityLine."Qty. (Base)");
    END;

    //[External]
    PROCEDURE ItemTrkgIsManagedByWhse(Type: Integer; Subtype: Integer; ID: Code[20]; ProdOrderLine: Integer; RefNo: Integer; LocationCode: Code[10]; ItemNo: Code[20]): Boolean;
    VAR
        WhseShipmentLine: Record 7321;
        WhseWkshLine: Record 7326;
        WhseActivLine: Record 5767;
        WhseWkshTemplate: Record 7328;
        Location: Record 14;
        SNRequired: Boolean;
        LNRequired: Boolean;
    BEGIN
        IF NOT (Type IN [DATABASE::"Sales Line",
                         DATABASE::"Purchase Line",
                         DATABASE::"Transfer Line",
                         DATABASE::"Assembly Header",
                         DATABASE::"Assembly Line",
                         DATABASE::"Prod. Order Line",
                         DATABASE::"Service Line",
                         DATABASE::"Prod. Order Component"])
        THEN
            EXIT(FALSE);

        IF NOT (Location.RequirePicking(LocationCode) OR Location.RequirePutaway(LocationCode)) THEN
            EXIT(FALSE);

        CheckWhseItemTrkgSetup(ItemNo, SNRequired, LNRequired, FALSE);
        IF NOT (SNRequired OR LNRequired) THEN
            EXIT(FALSE);

        WhseShipmentLine.SetSourceFilter(Type, Subtype, ID, RefNo, TRUE);
        IF NOT WhseShipmentLine.ISEMPTY THEN
            EXIT(TRUE);

        IF Type IN [DATABASE::"Prod. Order Component", DATABASE::"Prod. Order Line"] THEN BEGIN
            WhseWkshLine.SetSourceFilter(Type, Subtype, ID, ProdOrderLine, TRUE);
            WhseWkshLine.SETRANGE("Source Subline No.", RefNo);
        END ELSE
            WhseWkshLine.SetSourceFilter(Type, Subtype, ID, RefNo, TRUE);
        IF WhseWkshLine.FINDFIRST THEN
            IF WhseWkshTemplate.GET(WhseWkshLine."Worksheet Template Name") THEN
                IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Pick THEN
                    EXIT(TRUE);

        IF Type IN [DATABASE::"Prod. Order Component", DATABASE::"Prod. Order Line"] THEN
            WhseActivLine.SetSourceFilter(Type, Subtype, ID, ProdOrderLine, RefNo, TRUE)
        ELSE
            WhseActivLine.SetSourceFilter(Type, Subtype, ID, RefNo, 0, TRUE);
        IF WhseActivLine.FINDFIRST THEN
            IF WhseActivLine."Activity Type" IN [WhseActivLine."Activity Type"::Pick,
                                                 WhseActivLine."Activity Type"::"Invt. Put-away",
                                                 WhseActivLine."Activity Type"::"Invt. Pick"]
            THEN
                EXIT(TRUE);

        EXIT(FALSE);
    END;

    //[External]
    PROCEDURE CheckWhseItemTrkgSetup(ItemNo: Code[20]; VAR SNRequired: Boolean; VAR LNRequired: Boolean; ShowError: Boolean);
    VAR
        ItemTrackingCode: Record 6502;
        Item: Record 27;
    BEGIN
        SNRequired := FALSE;
        LNRequired := FALSE;
        IF Item."No." <> ItemNo THEN
            Item.GET(ItemNo);
        IF Item."Item Tracking Code" <> '' THEN BEGIN
            IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
                ItemTrackingCode.GET(Item."Item Tracking Code");
            SNRequired := ItemTrackingCode."SN Warehouse Tracking";
            LNRequired := ItemTrackingCode."Lot Warehouse Tracking";
        END;
        IF NOT (SNRequired OR LNRequired) AND ShowError THEN
            ERROR(Text005, Item.FIELDCAPTION("No."), ItemNo);
    END;



    LOCAL PROCEDURE ModifyTemp337SetIfTransfer(VAR TempReservEntry: Record 337 TEMPORARY);
    VAR
        TransLine: Record 5741;
    BEGIN
        IF TempReservEntry."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
            TransLine.GET(TempReservEntry."Source ID", TempReservEntry."Source Ref. No.");
            TempReservEntry.MODIFYALL("Reservation Status", TempReservEntry."Reservation Status"::Surplus);
            IF TempReservEntry."Source Subtype" = 0 THEN BEGIN
                TempReservEntry.MODIFYALL("Location Code", TransLine."Transfer-from Code");
                TempReservEntry.MODIFYALL("Expected Receipt Date", 0D);
                TempReservEntry.MODIFYALL("Shipment Date", TransLine."Shipment Date");
            END ELSE BEGIN
                TempReservEntry.MODIFYALL("Location Code", TransLine."Transfer-to Code");
                TempReservEntry.MODIFYALL("Expected Receipt Date", TransLine."Receipt Date");
                TempReservEntry.MODIFYALL("Shipment Date", 0D);
            END;
        END;
    END;


    LOCAL PROCEDURE CheckWhseItemTrkg(VAR TempWhseItemTrkgLine: Record 6550; WhseWkshLine: Record 7326);
    VAR
        SourceReservEntry: Record 337;
        WhseItemTrackingLine: Record 6550;
        EntryNo: Integer;
        Checked: Boolean;
    BEGIN
        OnBeforeCheckWhseItemTrkg(TempWhseItemTrkgLine, WhseWkshLine, Checked);
        IF Checked THEN
            EXIT;

        WITH WhseWkshLine DO BEGIN
            IF WhseItemTrackingLine.FINDLAST THEN
                EntryNo := WhseItemTrackingLine."Entry No.";

            IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
                SourceReservEntry.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Subline No.", TRUE);
                SourceReservEntry.SetSourceFilter('', "Source Line No.");
            END ELSE BEGIN
                SourceReservEntry.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", TRUE);
                SourceReservEntry.SetSourceFilter('', 0);
            END;
            IF SourceReservEntry.FINDSET THEN
                REPEAT
                    IF SourceReservEntry.TrackingExists THEN BEGIN
                        IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
                            TempWhseItemTrkgLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Subline No.", TRUE);
                            TempWhseItemTrkgLine.SETRANGE("Source Prod. Order Line", "Source Line No.");
                        END ELSE BEGIN
                            TempWhseItemTrkgLine.SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", TRUE);
                            TempWhseItemTrkgLine.SETRANGE("Source Prod. Order Line", 0);
                        END;
                        TempWhseItemTrkgLine.SetTrackingFilterFromReservEntry(SourceReservEntry);

                        IF TempWhseItemTrkgLine.FINDFIRST THEN
                            TempWhseItemTrkgLine.DELETE
                        ELSE BEGIN
                            WhseItemTrackingLine.INIT;
                            EntryNo += 1;
                            WhseItemTrackingLine."Entry No." := EntryNo;
                            WhseItemTrackingLine."Item No." := SourceReservEntry."Item No.";
                            WhseItemTrackingLine."Variant Code" := SourceReservEntry."Variant Code";
                            WhseItemTrackingLine."Location Code" := SourceReservEntry."Location Code";
                            WhseItemTrackingLine.Description := SourceReservEntry.Description;
                            WhseItemTrackingLine."Qty. per Unit of Measure" := SourceReservEntry."Qty. per Unit of Measure";
                            IF "Source Type" = DATABASE::"Prod. Order Component" THEN
                                WhseItemTrackingLine.SetSource("Source Type", "Source Subtype", "Source No.", "Source Subline No.", '', "Source Line No.")
                            ELSE
                                WhseItemTrackingLine.SetSource("Source Type", "Source Subtype", "Source No.", "Source Line No.", '', 0);
                            WhseItemTrackingLine.CopyTrackingFromReservEntry(SourceReservEntry);
                            WhseItemTrackingLine."Quantity (Base)" := -SourceReservEntry."Quantity (Base)";
                            IF "Qty. (Base)" = "Qty. to Handle (Base)" THEN
                                WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
                            WhseItemTrackingLine."Qty. to Handle" :=
                              ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure", 0.00001);
                            OnBeforeWhseItemTrackingLineInsert(WhseItemTrackingLine, SourceReservEntry);
                            WhseItemTrackingLine.INSERT;
                        END;
                    END;
                UNTIL SourceReservEntry.NEXT = 0;

            TempWhseItemTrkgLine.RESET;
            IF TempWhseItemTrkgLine.FINDSET THEN
                REPEAT
                    IF TempWhseItemTrkgLine.TrackingExists AND (TempWhseItemTrkgLine."Quantity Handled (Base)" = 0) THEN BEGIN
                        WhseItemTrackingLine.GET(TempWhseItemTrkgLine."Entry No.");
                        WhseItemTrackingLine.DELETE;
                    END;
                UNTIL TempWhseItemTrkgLine.NEXT = 0;
        END;
    END;

    //[External]
    PROCEDURE CopyLotNoInformation(LotNoInfo: Record 6505; NewLotNo: Code[50]);
    VAR
        NewLotNoInfo: Record 6505;
        CommentType: Option " ","Serial No.","Lot No.";
    BEGIN
        IF NewLotNoInfo.GET(LotNoInfo."Item No.", LotNoInfo."Variant Code", NewLotNo) THEN BEGIN
            IF NOT CONFIRM(text008, FALSE, LotNoInfo.TABLECAPTION, LotNoInfo.FIELDCAPTION("Lot No."), NewLotNo) THEN
                ERROR('');
            NewLotNoInfo.TRANSFERFIELDS(LotNoInfo, FALSE);
            NewLotNoInfo.MODIFY;
        END ELSE BEGIN
            NewLotNoInfo := LotNoInfo;
            NewLotNoInfo."Lot No." := NewLotNo;
            NewLotNoInfo.INSERT;
        END;

        CopyInfoComment(
          CommentType::"Lot No.",
          LotNoInfo."Item No.",
          LotNoInfo."Variant Code",
          LotNoInfo."Lot No.",
          NewLotNo);
    END;

    //[External]
    PROCEDURE CopySerialNoInformation(SerialNoInfo: Record 6504; NewSerialNo: Code[50]);
    VAR
        NewSerialNoInfo: Record 6504;
        CommentType: Option " ","Serial No.","Lot No.";
    BEGIN
        IF NewSerialNoInfo.GET(SerialNoInfo."Item No.", SerialNoInfo."Variant Code", NewSerialNo) THEN BEGIN
            IF NOT CONFIRM(text008, FALSE, SerialNoInfo.TABLECAPTION, SerialNoInfo.FIELDCAPTION("Serial No."), NewSerialNo) THEN
                ERROR('');
            NewSerialNoInfo.TRANSFERFIELDS(SerialNoInfo, FALSE);
            NewSerialNoInfo.MODIFY;
        END ELSE BEGIN
            NewSerialNoInfo := SerialNoInfo;
            NewSerialNoInfo."Serial No." := NewSerialNo;
            NewSerialNoInfo.INSERT;
        END;

        CopyInfoComment(
          CommentType::"Serial No.",
          SerialNoInfo."Item No.",
          SerialNoInfo."Variant Code",
          SerialNoInfo."Serial No.",
          NewSerialNo);
    END;

    LOCAL PROCEDURE CopyInfoComment(InfoType: Option " ","Serial No.","Lot No."; ItemNo: Code[20]; VariantCode: Code[10]; SerialLotNo: Code[50]; NewSerialLotNo: Code[50]);
    VAR
        ItemTrackingComment: Record 6506;
        ItemTrackingComment1: Record 6506;
    BEGIN
        IF SerialLotNo = NewSerialLotNo THEN
            EXIT;

        ItemTrackingComment1.SETRANGE(Type, InfoType);
        ItemTrackingComment1.SETRANGE("Item No.", ItemNo);
        ItemTrackingComment1.SETRANGE("Variant Code", VariantCode);
        ItemTrackingComment1.SETRANGE("Serial/Lot No.", NewSerialLotNo);

        IF NOT ItemTrackingComment1.ISEMPTY THEN
            ItemTrackingComment1.DELETEALL;

        ItemTrackingComment.SETRANGE(Type, InfoType);
        ItemTrackingComment.SETRANGE("Item No.", ItemNo);
        ItemTrackingComment.SETRANGE("Variant Code", VariantCode);
        ItemTrackingComment.SETRANGE("Serial/Lot No.", SerialLotNo);

        IF ItemTrackingComment.ISEMPTY THEN
            EXIT;

        IF ItemTrackingComment.FINDSET THEN BEGIN
            REPEAT
                ItemTrackingComment1 := ItemTrackingComment;
                ItemTrackingComment1."Serial/Lot No." := NewSerialLotNo;
                ItemTrackingComment1.INSERT;
            UNTIL ItemTrackingComment.NEXT = 0
        END;
    END;

    LOCAL PROCEDURE GetLotSNDataSet(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; VAR ItemLedgEntry: Record 32): Boolean;
    BEGIN
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.");

        ItemLedgEntry.SETRANGE("Item No.", ItemNo);
        ItemLedgEntry.SETRANGE(Open, TRUE);
        ItemLedgEntry.SETRANGE("Variant Code", Variant);
        IF LotNo <> '' THEN
            ItemLedgEntry.SETRANGE("Lot No.", LotNo)
        ELSE
            IF SerialNo <> '' THEN
                ItemLedgEntry.SETRANGE("Serial No.", SerialNo);
        ItemLedgEntry.SETRANGE(Positive, TRUE);

        IF ItemLedgEntry.FINDLAST THEN
            EXIT(TRUE);

        ItemLedgEntry.SETRANGE(Open);
        EXIT(ItemLedgEntry.FINDLAST);
    END;

    //[External]
    PROCEDURE ExistingExpirationDate(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; TestMultiple: Boolean; VAR EntriesExist: Boolean) ExpDate: Date;
    VAR
        ItemLedgEntry: Record 32;
        ItemTracingMgt: Codeunit 6520;
        ItemTracingMgt1: Codeunit 51155;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeExistingExpirationDate(ItemNo, Variant, LotNo, SerialNo, TestMultiple, EntriesExist, ExpDate, IsHandled);
        IF IsHandled THEN
            EXIT;

        IF NOT GetLotSNDataSet(ItemNo, Variant, LotNo, SerialNo, ItemLedgEntry) THEN BEGIN
            EntriesExist := FALSE;
            EXIT;
        END;

        EntriesExist := TRUE;
        ExpDate := ItemLedgEntry."Expiration Date";

        IF TestMultiple AND ItemTracingMgt1.SpecificTracking(ItemNo, SerialNo, LotNo) THEN BEGIN
            ItemLedgEntry.SETFILTER("Expiration Date", '<>%1', ItemLedgEntry."Expiration Date");
            ItemLedgEntry.SETRANGE(Open, TRUE);
            IF NOT ItemLedgEntry.ISEMPTY THEN
                ERROR(Text007, LotNo);
        END;
    END;

    //[External]
    PROCEDURE ExistingExpirationDateAndQty(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; VAR SumOfEntries: Decimal) ExpDate: Date;
    VAR
        ItemLedgEntry: Record 32;
        IsHandled: Boolean;
    BEGIN
        IsHandled := FALSE;
        OnBeforeExistingExpirationDateAndQty(ItemNo, Variant, LotNo, SerialNo, SumOfEntries, ExpDate, IsHandled);
        IF IsHandled THEN
            EXIT;

        SumOfEntries := 0;
        IF NOT GetLotSNDataSet(ItemNo, Variant, LotNo, SerialNo, ItemLedgEntry) THEN
            EXIT;

        ExpDate := ItemLedgEntry."Expiration Date";
        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                SumOfEntries += ItemLedgEntry."Remaining Quantity";
            UNTIL ItemLedgEntry.NEXT = 0;
    END;

    //[External]
    PROCEDURE ExistingWarrantyDate(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; VAR EntriesExist: Boolean) WarDate: Date;
    VAR
        ItemLedgEntry: Record 32;
    BEGIN
        IF NOT GetLotSNDataSet(ItemNo, Variant, LotNo, SerialNo, ItemLedgEntry) THEN
            EXIT;

        EntriesExist := TRUE;
        WarDate := ItemLedgEntry."Warranty Date";
    END;



    //[External]
    PROCEDURE TestExpDateOnTrackingSpec(VAR TempTrackingSpecification: Record 336 TEMPORARY);
    BEGIN
        IF (TempTrackingSpecification."Lot No." = '') OR (TempTrackingSpecification."Serial No." = '') THEN
            EXIT;
        TempTrackingSpecification.SETRANGE("Lot No.", TempTrackingSpecification."Lot No.");
        TempTrackingSpecification.SETFILTER("Expiration Date", '<>%1', TempTrackingSpecification."Expiration Date");
        IF NOT TempTrackingSpecification.ISEMPTY THEN
            ERROR(Text007, TempTrackingSpecification."Lot No.");
        TempTrackingSpecification.SETRANGE("Lot No.");
        TempTrackingSpecification.SETRANGE("Expiration Date");
    END;

    //[External]
    PROCEDURE TestExpDateOnTrackingSpecNew(VAR TempTrackingSpecification: Record 336 TEMPORARY);
    BEGIN
        IF TempTrackingSpecification."New Lot No." = '' THEN
            EXIT;
        TempTrackingSpecification.SETRANGE("New Lot No.", TempTrackingSpecification."New Lot No.");
        TempTrackingSpecification.SETFILTER("New Expiration Date", '<>%1', TempTrackingSpecification."New Expiration Date");
        IF NOT TempTrackingSpecification.ISEMPTY THEN
            ERROR(Text007, TempTrackingSpecification."New Lot No.");
        TempTrackingSpecification.SETRANGE("New Lot No.");
        TempTrackingSpecification.SETRANGE("New Expiration Date");
    END;

    //[External]
    PROCEDURE ItemTrackingOption(LotNo: Code[50]; SerialNo: Code[50]) OptionValue: Integer;
    BEGIN
        IF LotNo <> '' THEN
            OptionValue := 1;

        IF SerialNo <> '' THEN BEGIN
            IF LotNo <> '' THEN
                OptionValue := 2
            ELSE
                OptionValue := 3;
        END;
    END;



    //[External]
    PROCEDURE CopyItemLedgEntryTrkgToSalesLn(VAR TempItemLedgEntryBuf: Record 32 TEMPORARY; ToSalesLine: Record 37; FillExactCostRevLink: Boolean; VAR MissingExCostRevLink: Boolean; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean; FromShptOrRcpt: Boolean);
    VAR
        TempReservEntry: Record 337 TEMPORARY;
        ReservEntry: Record 337;
        CopyDocMgt: Codeunit 6620;
        ReservMgt: Codeunit 99000845;
        ReservMgt1: Codeunit 51372;
        ReservEngineMgt: Codeunit 99000831;
        TotalCostLCY: Decimal;
        ItemLedgEntryQty: Decimal;
        QtyBase: Decimal;
        SignFactor: Integer;
        LinkThisEntry: Boolean;
        EntriesExist: Boolean;
    BEGIN
        IF (ToSalesLine.Type <> ToSalesLine.Type::Item) OR (ToSalesLine.Quantity = 0) THEN
            EXIT;

        IF FillExactCostRevLink THEN
            FillExactCostRevLink := NOT ToSalesLine.IsShipment;

        WITH TempItemLedgEntryBuf DO
            IF FINDSET THEN BEGIN
                IF Quantity / ToSalesLine.Quantity < 0 THEN
                    SignFactor := 1
                ELSE
                    SignFactor := -1;
                IF ToSalesLine.IsCreditDocType THEN
                    SignFactor := -SignFactor;

                ReservMgt1.SetSalesLine(ToSalesLine);
                ReservMgt.DeleteReservEntries(TRUE, 0);

                REPEAT
                    LinkThisEntry := "Entry No." > 0;

                    IF FillExactCostRevLink THEN
                        QtyBase := "Shipped Qty. Not Returned" * SignFactor
                    ELSE
                        QtyBase := Quantity * SignFactor;

                    IF FillExactCostRevLink THEN
                        IF NOT LinkThisEntry THEN
                            MissingExCostRevLink := TRUE
                        ELSE
                            IF NOT MissingExCostRevLink THEN BEGIN
                                CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
                                TotalCostLCY := TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
                                ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
                            END;

                    InsertReservEntryForSalesLine(
                      ReservEntry, TempItemLedgEntryBuf, ToSalesLine, QtyBase, FillExactCostRevLink AND LinkThisEntry, EntriesExist);

                    TempReservEntry := ReservEntry;
                    TempReservEntry.INSERT;
                UNTIL NEXT = 0;
                ReservEngineMgt.UpdateOrderTracking(TempReservEntry);

                IF FillExactCostRevLink AND NOT MissingExCostRevLink THEN BEGIN
                    ToSalesLine.VALIDATE(
                      "Unit Cost (LCY)", ABS(TotalCostLCY / ItemLedgEntryQty) * ToSalesLine."Qty. per Unit of Measure");
                    IF NOT FromShptOrRcpt THEN
                        CopyDocMgt.CalculateRevSalesLineAmount(ToSalesLine, ItemLedgEntryQty, FromPricesInclVAT, ToPricesInclVAT);
                    ToSalesLine.MODIFY;
                END;
            END;
    END;

    //[External]
    PROCEDURE CopyItemLedgEntryTrkgToPurchLn(VAR ItemLedgEntryBuf: Record 32; ToPurchLine: Record 39; FillExactCostRevLink: Boolean; VAR MissingExCostRevLink: Boolean; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean; FromShptOrRcpt: Boolean);
    VAR
        ItemLedgEntry: Record 32;
        CopyDocMgt: Codeunit 6620;
        ReservMgt: Codeunit 99000845;
        ReservMgt1: Codeunit 51372;
        TotalCostLCY: Decimal;
        ItemLedgEntryQty: Decimal;
        QtyBase: Decimal;
        SignFactor: Integer;
        LinkThisEntry: Boolean;
        EntriesExist: Boolean;
    BEGIN
        IF (ToPurchLine.Type <> ToPurchLine.Type::Item) OR (ToPurchLine.Quantity = 0) THEN
            EXIT;

        IF FillExactCostRevLink THEN
            FillExactCostRevLink := ToPurchLine.Signed(ToPurchLine."Quantity (Base)") < 0;

        IF FillExactCostRevLink THEN
            IF (ToPurchLine."Document Type" IN [ToPurchLine."Document Type"::Invoice, ToPurchLine."Document Type"::"Credit Memo"]) AND
               (ToPurchLine."Job No." <> '')
            THEN
                FillExactCostRevLink := FALSE;

        WITH ItemLedgEntryBuf DO
            IF FINDSET THEN BEGIN
                IF Quantity / ToPurchLine.Quantity > 0 THEN
                    SignFactor := 1
                ELSE
                    SignFactor := -1;
                IF ToPurchLine."Document Type" IN
                   [ToPurchLine."Document Type"::"Return Order", ToPurchLine."Document Type"::"Credit Memo"]
                THEN
                    SignFactor := -SignFactor;

                IF ToPurchLine."Expected Receipt Date" = 0D THEN
                    ToPurchLine."Expected Receipt Date" := WORKDATE;
                ToPurchLine."Outstanding Qty. (Base)" := ToPurchLine."Quantity (Base)";
                ReservMgt1.SetPurchLine(ToPurchLine);
                ReservMgt.DeleteReservEntries(TRUE, 0);

                REPEAT
                    LinkThisEntry := "Entry No." > 0;

                    IF FillExactCostRevLink THEN
                        IF NOT LinkThisEntry THEN
                            MissingExCostRevLink := TRUE
                        ELSE
                            IF NOT MissingExCostRevLink THEN BEGIN
                                CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
                                TotalCostLCY := TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
                                ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
                            END;

                    IF LinkThisEntry AND ("Lot No." = '') THEN
                        // The check for Lot No = '' is to avoid changing the remaining quantity for partly sold Lots
                        // because this will cause undefined quantities in the item tracking
                        "Remaining Quantity" := Quantity;
                    IF ToPurchLine."Job No." = '' THEN
                        QtyBase := "Remaining Quantity" * SignFactor
                    ELSE BEGIN
                        ItemLedgEntry.GET("Entry No.");
                        QtyBase := ABS(ItemLedgEntry.Quantity) * SignFactor;
                    END;

                    InsertReservEntryForPurchLine(
                      ItemLedgEntryBuf, ToPurchLine, QtyBase, FillExactCostRevLink AND LinkThisEntry, EntriesExist);
                UNTIL NEXT = 0;

                IF FillExactCostRevLink AND NOT MissingExCostRevLink THEN BEGIN
                    ToPurchLine.VALIDATE(
                      "Unit Cost (LCY)",
                      ABS(TotalCostLCY / ItemLedgEntryQty) * ToPurchLine."Qty. per Unit of Measure");
                    IF NOT FromShptOrRcpt THEN
                        CopyDocMgt.CalculateRevPurchLineAmount(
                          ToPurchLine, ItemLedgEntryQty, FromPricesInclVAT, ToPricesInclVAT);

                    ToPurchLine.MODIFY;
                END;
            END;
    END;

    //[External]
    PROCEDURE SynchronizeWhseActivItemTrkg(WhseActivLine: Record 5767);
    VAR
        TempTrackingSpec: Record 336 TEMPORARY;
        TempReservEntry: Record 337 TEMPORARY;
        ReservEntry: Record 337;
        ReservEntryBindingCheck: Record 337;
        ATOSalesLine: Record 37;
        AsmHeader: Record 900;
        ItemTrackingMgt: Codeunit 6500;
        SignFactor: Integer;
        ToRowID: Text[250];
        IsTransferReceipt: Boolean;
        IsATOPosting: Boolean;
        IsBindingOrderToOrder: Boolean;
    BEGIN
        // Used for carrying the item tracking from the invt. pick/put-away to the parent line.
        WITH WhseActivLine DO BEGIN
            RESET;
            SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.", TRUE);
            SETRANGE("Assemble to Order", "Assemble to Order");
            IF FINDSET THEN BEGIN
                // Transfer receipt needs special treatment:
                IsTransferReceipt := ("Source Type" = DATABASE::"Transfer Line") AND ("Source Subtype" = 1);
                IsATOPosting := ("Source Type" = DATABASE::"Sales Line") AND "Assemble to Order";
                IF ("Source Type" IN [DATABASE::"Prod. Order Line", DATABASE::"Prod. Order Component"]) OR IsTransferReceipt THEN
                    ToRowID :=
                      ItemTrackingMgt.ComposeRowID(
                        "Source Type", "Source Subtype", "Source No.", '', "Source Line No.", "Source Subline No.")
                ELSE BEGIN
                    IF IsATOPosting THEN BEGIN
                        ATOSalesLine.GET("Source Subtype", "Source No.", "Source Line No.");
                        ATOSalesLine.AsmToOrderExists(AsmHeader);
                        ToRowID :=
                          ItemTrackingMgt.ComposeRowID(
                            DATABASE::"Assembly Header", AsmHeader."Document Type".AsInteger(), AsmHeader."No.", '', 0, 0);
                    END ELSE
                        ToRowID :=
                          ItemTrackingMgt.ComposeRowID(
                            "Source Type", "Source Subtype", "Source No.", '', "Source Subline No.", "Source Line No.");
                END;
                TempReservEntry.SetPointer(ToRowID);
                SignFactor := WhseActivitySignFactor(WhseActivLine);
                ReservEntryBindingCheck.SetPointer(ToRowID);
                ReservEntryBindingCheck.SetPointerFilter;
                REPEAT
                    IF TrackingExists THEN BEGIN
                        TempReservEntry."Entry No." += 1;
                        TempReservEntry.Positive := SignFactor > 0;
                        TempReservEntry."Item No." := "Item No.";
                        TempReservEntry."Location Code" := "Location Code";
                        TempReservEntry.Description := Description;
                        TempReservEntry."Variant Code" := "Variant Code";
                        TempReservEntry."Quantity (Base)" := "Qty. Outstanding (Base)" * SignFactor;
                        TempReservEntry.Quantity := "Qty. Outstanding" * SignFactor;
                        TempReservEntry."Qty. to Handle (Base)" := "Qty. to Handle (Base)" * SignFactor;
                        TempReservEntry."Qty. to Invoice (Base)" := "Qty. to Handle (Base)" * SignFactor;
                        TempReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                        TempReservEntry.CopyTrackingFromWhseActivLine(WhseActivLine);
                        OnSyncActivItemTrkgOnBeforeInsertTempReservEntry(TempReservEntry, WhseActivLine);
                        TempReservEntry.INSERT;

                        IF NOT IsBindingOrderToOrder THEN BEGIN
                            // ReservEntryBindingCheck.SetTrackingFilter("Serial No.", "Lot No.");
                            ReservEntryBindingCheck.SETRANGE(Binding, ReservEntryBindingCheck.Binding::"Order-to-Order");
                            IsBindingOrderToOrder := NOT ReservEntryBindingCheck.ISEMPTY;
                        END;
                    END;
                UNTIL NEXT = 0;

                IF TempReservEntry.ISEMPTY THEN
                    EXIT;
            END;
        END;

        SumUpItemTracking(TempReservEntry, TempTrackingSpec, FALSE, TRUE);

        IF TempTrackingSpec.FINDSET THEN
            REPEAT
                ReservEntry.SetSourceFilter(
                  TempTrackingSpec."Source Type", TempTrackingSpec."Source Subtype",
                  TempTrackingSpec."Source ID", TempTrackingSpec."Source Ref. No.", TRUE);
                ReservEntry.SetSourceFilter('', TempTrackingSpec."Source Prod. Order Line");
                ReservEntry.SetTrackingFilterFromSpec(TempTrackingSpec);
                IF IsTransferReceipt THEN
                    ReservEntry.SETRANGE("Source Ref. No.");
                IF ReservEntry.FINDSET THEN BEGIN
                    REPEAT
                        IF ABS(TempTrackingSpec."Qty. to Handle (Base)") > ABS(ReservEntry."Quantity (Base)") THEN
                            ReservEntry.VALIDATE("Qty. to Handle (Base)", ReservEntry."Quantity (Base)")
                        ELSE
                            ReservEntry.VALIDATE("Qty. to Handle (Base)", TempTrackingSpec."Qty. to Handle (Base)");

                        IF ABS(TempTrackingSpec."Qty. to Invoice (Base)") > ABS(ReservEntry."Quantity (Base)") THEN
                            ReservEntry.VALIDATE("Qty. to Invoice (Base)", ReservEntry."Quantity (Base)")
                        ELSE
                            ReservEntry.VALIDATE("Qty. to Invoice (Base)", TempTrackingSpec."Qty. to Invoice (Base)");

                        TempTrackingSpec."Qty. to Handle (Base)" -= ReservEntry."Qty. to Handle (Base)";
                        TempTrackingSpec."Qty. to Invoice (Base)" -= ReservEntry."Qty. to Invoice (Base)";
                        TempTrackingSpec.MODIFY;

                        WITH WhseActivLine DO BEGIN
                            RESET;
                            SetSourceFilter("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.", TRUE);
                            // SetTrackingFilter(ReservEntry."Serial No.", ReservEntry."Lot No.");
                            IF FINDFIRST THEN
                                ReservEntry."Expiration Date" := "Expiration Date";
                            OnSynchronizeWhseActivItemTrkgOnAfterSetExpirationDate(WhseActivLine, ReservEntry);
                        END;

                        ReservEntry.MODIFY;

                        IF IsReservedFromTransferShipment(ReservEntry) THEN
                            UpdateItemTrackingInTransferReceipt(ReservEntry);
                    UNTIL ReservEntry.NEXT = 0;

                    IF (TempTrackingSpec."Qty. to Handle (Base)" = 0) AND (TempTrackingSpec."Qty. to Invoice (Base)" = 0) THEN
                        TempTrackingSpec.DELETE;
                END;
            UNTIL TempTrackingSpec.NEXT = 0;

        IF TempTrackingSpec.FINDSET THEN
            REPEAT
                TempTrackingSpec."Quantity (Base)" := ABS(TempTrackingSpec."Qty. to Handle (Base)");
                TempTrackingSpec."Qty. to Handle (Base)" := ABS(TempTrackingSpec."Qty. to Handle (Base)");
                TempTrackingSpec."Qty. to Invoice (Base)" := ABS(TempTrackingSpec."Qty. to Invoice (Base)");
                TempTrackingSpec.MODIFY;
            UNTIL TempTrackingSpec.NEXT = 0;

        RegisterNewItemTrackingLines(TempTrackingSpec);
    END;

    LOCAL PROCEDURE RegisterNewItemTrackingLines(VAR TempTrackingSpec: Record 336 TEMPORARY);
    VAR
        TrackingSpec: Record 336;
        ReservEntry: Record 337;
        ReservMgt: Codeunit 99000845;
        ItemTrackingLines: Page 6510;
        QtyToHandleInItemTracking: Decimal;
        QtyToHandleOnSourceDocLine: Decimal;
        QtyToHandleToNewRegister: Decimal;
    BEGIN
        IF TempTrackingSpec.FINDSET THEN
            REPEAT
                TempTrackingSpec.SetSourceFilter(
                  TempTrackingSpec."Source Type", TempTrackingSpec."Source Subtype",
                  TempTrackingSpec."Source ID", TempTrackingSpec."Source Ref. No.", FALSE);
                TempTrackingSpec.SETRANGE("Source Prod. Order Line", TempTrackingSpec."Source Prod. Order Line");

                TrackingSpec := TempTrackingSpec;
                TempTrackingSpec.CALCSUMS("Qty. to Handle (Base)");

                QtyToHandleToNewRegister := TempTrackingSpec."Qty. to Handle (Base)";
                ReservEntry.TRANSFERFIELDS(TempTrackingSpec);
                QtyToHandleInItemTracking :=
                  ABS(CalcQtyToHandleForTrackedQtyOnDocumentLine(
                      ReservEntry."Source Type", Enum::"Sales Document Type".FromInteger(ReservEntry."Source Subtype"), ReservEntry."Source ID", ReservEntry."Source Ref. No."));
                QtyToHandleOnSourceDocLine := ReservMgt.GetSourceRecordValue(ReservEntry, FALSE, 0);

                IF QtyToHandleToNewRegister + QtyToHandleInItemTracking > QtyToHandleOnSourceDocLine THEN
                    ERROR(CannotMatchItemTrackingErr);

                TrackingSpec."Quantity (Base)" :=
                  TempTrackingSpec."Qty. to Handle (Base)" + ABS(ItemTrkgQtyPostedOnSource(TrackingSpec));

                CLEAR(ItemTrackingLines);
                ItemTrackingLines.SetCalledFromSynchWhseItemTrkg(TRUE);
                ItemTrackingLines.RegisterItemTrackingLines(TrackingSpec, TrackingSpec."Creation Date", TempTrackingSpec);
                TempTrackingSpec.ClearSourceFilter;
            UNTIL TempTrackingSpec.NEXT = 0;
    END;

    LOCAL PROCEDURE WhseActivitySignFactor(WhseActivityLine: Record 5767): Integer;
    BEGIN
        IF WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::"Invt. Pick" THEN BEGIN
            IF WhseActivityLine."Assemble to Order" THEN
                EXIT(1);
            EXIT(-1);
        END;
        IF WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::"Invt. Put-away" THEN
            EXIT(1);

        ERROR(Text011, WhseActivityLine.FIELDCAPTION("Activity Type"), WhseActivityLine."Activity Type");
    END;



    LOCAL PROCEDURE ItemTrkgQtyPostedOnSource(SourceTrackingSpec: Record 336) Qty: Decimal;
    VAR
        TrackingSpecification: Record 336;
        ReservEntry: Record 337;
        TransferLine: Record 5741;
    BEGIN
        WITH SourceTrackingSpec DO BEGIN
            TrackingSpecification.SetSourceFilter("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", TRUE);
            TrackingSpecification.SetSourceFilter("Source Batch Name", "Source Prod. Order Line");
            IF NOT TrackingSpecification.ISEMPTY THEN BEGIN
                TrackingSpecification.FINDSET;
                REPEAT
                    Qty += TrackingSpecification."Quantity (Base)";
                UNTIL TrackingSpecification.NEXT = 0;
            END;

            ReservEntry.SetSourceFilter("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", FALSE);
            ReservEntry.SetSourceFilter('', "Source Prod. Order Line");
            ReservEntry.CALCSUMS("Qty. to Handle (Base)");
            Qty += ReservEntry."Qty. to Handle (Base)";

            IF "Source Type" = DATABASE::"Transfer Line" THEN BEGIN
                TransferLine.GET("Source ID", "Source Ref. No.");
                Qty -= TransferLine."Qty. Shipped (Base)";
            END;
        END;
    END;

    LOCAL PROCEDURE UpdateItemTrackingInTransferReceipt(FromReservEntry: Record 337);
    VAR
        ToReservEntry: Record 337;
        ToRowID: Text[250];
    BEGIN
        ToRowID := ComposeRowID(
            DATABASE::"Transfer Line", 1, FromReservEntry."Source ID",
            FromReservEntry."Source Batch Name", FromReservEntry."Source Prod. Order Line", FromReservEntry."Source Ref. No.");
        ToReservEntry.SetPointer(ToRowID);
        ToReservEntry.SetPointerFilter;
        SynchronizeItemTrkgTransfer(ToReservEntry);
    END;

    LOCAL PROCEDURE SynchronizeItemTrkgTransfer(VAR ToReservEntry: Record 337);
    VAR
        FromReservEntry: Record 337;
        TempReservEntry: Record 337 TEMPORARY;
        QtyToHandleBase: Decimal;
        QtyToInvoiceBase: Decimal;
        QtyBase: Decimal;
    BEGIN
        FromReservEntry.COPY(ToReservEntry);
        FromReservEntry.SETRANGE("Source Subtype", 0);
        IF ToReservEntry.FINDSET THEN
            REPEAT
                TempReservEntry := ToReservEntry;
                TempReservEntry.INSERT;
            UNTIL ToReservEntry.NEXT = 0;

        TempReservEntry.SETCURRENTKEY(
          "Item No.", "Variant Code", "Location Code", "Item Tracking", "Reservation Status", "Lot No.", "Serial No.");
        IF TempReservEntry.FIND('-') THEN
            REPEAT
                FromReservEntry.SetTrackingFilterFromReservEntry(TempReservEntry);

                QtyToHandleBase := 0;
                QtyToInvoiceBase := 0;
                QtyBase := 0;
                IF FromReservEntry.FIND('-') THEN
                    // due to Order Tracking there can be more than 1 record
                    REPEAT
                        QtyToHandleBase += FromReservEntry."Qty. to Handle (Base)";
                        QtyToInvoiceBase += FromReservEntry."Qty. to Invoice (Base)";
                        QtyBase += FromReservEntry."Quantity (Base)";
                    UNTIL FromReservEntry.NEXT = 0;

                TempReservEntry.SetTrackingFilterFromReservEntry(TempReservEntry);
                REPEAT
                    // remove already synchronized qty (can be also more than 1 record)
                    QtyToHandleBase += TempReservEntry."Qty. to Handle (Base)";
                    QtyToInvoiceBase += TempReservEntry."Qty. to Invoice (Base)";
                    QtyBase += TempReservEntry."Quantity (Base)";
                    TempReservEntry.DELETE;
                UNTIL TempReservEntry.NEXT = 0;
                TempReservEntry.ClearTrackingFilter;

                IF QtyToHandleBase <> 0 THEN BEGIN
                    // remaining qty will be added to the last record
                    ToReservEntry := TempReservEntry;
                    IF QtyBase <> 0 THEN BEGIN
                        ToReservEntry."Qty. to Handle (Base)" := -QtyToHandleBase;
                        ToReservEntry."Qty. to Invoice (Base)" := -QtyToInvoiceBase;
                    END ELSE BEGIN
                        ToReservEntry."Qty. to Handle (Base)" -= QtyToHandleBase;
                        ToReservEntry."Qty. to Invoice (Base)" -= QtyToInvoiceBase;
                    END;
                    ToReservEntry.MODIFY;
                END;
            UNTIL TempReservEntry.NEXT = 0;
    END;



    //[External]
    PROCEDURE CheckItemTrkgInfBeforePost();
    VAR
        TempItemLotInfo: Record 6505 TEMPORARY;
        CheckExpDate: Date;
        ErrorFound: Boolean;
        EndLoop: Boolean;
        ErrMsgTxt: Text[160];
    BEGIN
        // Check for different expiration dates within one Lot no.
        IF TempGlobalWhseItemTrkgLine.FIND('-') THEN BEGIN
            TempItemLotInfo.DELETEALL;
            REPEAT
                IF TempGlobalWhseItemTrkgLine."New Lot No." <> '' THEN BEGIN
                    CLEAR(TempItemLotInfo);
                    TempItemLotInfo."Item No." := TempGlobalWhseItemTrkgLine."Item No.";
                    TempItemLotInfo."Variant Code" := TempGlobalWhseItemTrkgLine."Variant Code";
                    TempItemLotInfo."Lot No." := TempGlobalWhseItemTrkgLine."New Lot No.";
                    IF TempItemLotInfo.INSERT THEN;
                END;
            UNTIL TempGlobalWhseItemTrkgLine.NEXT = 0;

            IF TempItemLotInfo.FIND('-') THEN
                REPEAT
                    ErrorFound := FALSE;
                    EndLoop := FALSE;
                    IF TempGlobalWhseItemTrkgLine.FIND('-') THEN BEGIN
                        CheckExpDate := 0D;
                        REPEAT
                            IF (TempGlobalWhseItemTrkgLine."Item No." = TempItemLotInfo."Item No.") AND
                               (TempGlobalWhseItemTrkgLine."Variant Code" = TempItemLotInfo."Variant Code") AND
                               (TempGlobalWhseItemTrkgLine."New Lot No." = TempItemLotInfo."Lot No.")
                            THEN
                                IF CheckExpDate = 0D THEN
                                    CheckExpDate := TempGlobalWhseItemTrkgLine."New Expiration Date"
                                ELSE
                                    IF TempGlobalWhseItemTrkgLine."New Expiration Date" <> CheckExpDate THEN BEGIN
                                        ErrorFound := TRUE;
                                        ErrMsgTxt :=
                                          STRSUBSTNO(Text012,
                                            TempGlobalWhseItemTrkgLine."Lot No.",
                                            TempGlobalWhseItemTrkgLine."New Expiration Date",
                                            CheckExpDate);
                                    END;
                            IF NOT ErrorFound THEN
                                IF TempGlobalWhseItemTrkgLine.NEXT = 0 THEN
                                    EndLoop := TRUE;
                        UNTIL EndLoop OR ErrorFound;
                    END;
                UNTIL (TempItemLotInfo.NEXT = 0) OR ErrorFound;
            IF ErrorFound THEN
                ERROR(ErrMsgTxt);
        END;
    END;



    //[External]
    PROCEDURE WhseItemTrkgLineExists(SourceId: Code[20]; SourceType: Integer; SourceSubtype: Integer; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer; LocationCode: Code[10]; SerialNo: Code[50]; LotNo: Code[50]): Boolean;
    VAR
        WhseItemTrkgLine: Record 6550;
    BEGIN
        WITH WhseItemTrkgLine DO BEGIN
            SetSourceFilter(SourceType, SourceSubtype, SourceId, SourceRefNo, TRUE);
            SetSourceFilter(SourceBatchName, SourceProdOrderLine);
            SETRANGE("Location Code", LocationCode);
            IF SerialNo <> '' THEN
                SETRANGE("Serial No.", SerialNo);
            IF LotNo <> '' THEN
                SETRANGE("Lot No.", LotNo);
            EXIT(NOT ISEMPTY);
        END;
    END;

    LOCAL PROCEDURE SetWhseSerialLotNo(VAR DestNo: Code[50]; SourceNo: Code[50]; NoRequired: Boolean);
    BEGIN
        IF NoRequired THEN
            DestNo := SourceNo;
    END;

    LOCAL PROCEDURE InsertProspectReservEntryFromItemEntryRelationAndSourceData(VAR ItemEntryRelation: Record 6507; SourceSubtype: Enum "Sales Document Type"; SourceID: Code[20]; SourceRefNo: Integer);
    VAR
        TrackingSpecification: Record 336;
        QtyBase: Decimal;
    BEGIN
        IF NOT ItemEntryRelation.FINDSET THEN
            EXIT;

        REPEAT
            TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
            QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
            InsertReservEntryFromTrackingSpec(
              TrackingSpecification, SourceSubtype, SourceID, SourceRefNo, QtyBase);
        UNTIL ItemEntryRelation.NEXT = 0;
    END;


    //[External]
    PROCEDURE CalculateSums(WhseWorksheetLine: Record 7326; VAR TotalWhseItemTrackingLine: Record 6550; SourceQuantityArray: ARRAY[2] OF Decimal; VAR UndefinedQtyArray: ARRAY[2] OF Decimal; SourceType: Integer): Boolean;
    BEGIN
        WITH TotalWhseItemTrackingLine DO BEGIN
            SETRANGE("Location Code", WhseWorksheetLine."Location Code");
            CASE SourceType OF
                DATABASE::"Posted Whse. Receipt Line",
              DATABASE::"Warehouse Shipment Line",
              DATABASE::"Whse. Internal Put-away Line",
              DATABASE::"Whse. Internal Pick Line",
              DATABASE::"Assembly Line",
              DATABASE::"Internal Movement Line":
                    SetSourceFilter(
                      SourceType, -1, WhseWorksheetLine."Whse. Document No.", WhseWorksheetLine."Whse. Document Line No.", TRUE);
                DATABASE::"Prod. Order Component":
                    BEGIN
                        SetSourceFilter(
                          SourceType, WhseWorksheetLine."Source Subtype", WhseWorksheetLine."Source No.", WhseWorksheetLine."Source Subline No.",
                          TRUE);
                        SETRANGE("Source Prod. Order Line", WhseWorksheetLine."Source Line No.");
                    END;
                DATABASE::"Whse. Worksheet Line",
                DATABASE::"Warehouse Journal Line":
                    BEGIN
                        SetSourceFilter(SourceType, -1, WhseWorksheetLine.Name, WhseWorksheetLine."Line No.", TRUE);
                        SETRANGE("Source Batch Name", WhseWorksheetLine."Worksheet Template Name");
                    END;
            END;
            CALCSUMS("Quantity (Base)", "Qty. to Handle (Base)");
        END;
        EXIT(UpdateUndefinedQty(TotalWhseItemTrackingLine, SourceQuantityArray, UndefinedQtyArray));
    END;

    //[External]
    PROCEDURE UpdateUndefinedQty(TotalWhseItemTrackingLine: Record 6550; SourceQuantityArray: ARRAY[2] OF Decimal; VAR UndefinedQtyArray: ARRAY[2] OF Decimal): Boolean;
    BEGIN
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalWhseItemTrackingLine."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalWhseItemTrackingLine."Qty. to Handle (Base)";
        exit(not (Abs(SourceQuantityArray[1]) < Abs(TotalWhseItemTrackingLine."Quantity (Base)")));
    END;

    LOCAL PROCEDURE InsertReservEntryForSalesLine(VAR ReservEntry: Record 337; ItemLedgEntryBuf: Record 32; SalesLine: Record 37; QtyBase: Decimal; AppliedFromItemEntry: Boolean; VAR EntriesExist: Boolean);
    BEGIN
        IF QtyBase = 0 THEN
            EXIT;

        WITH ReservEntry DO BEGIN
            InitReservEntry(ReservEntry, ItemLedgEntryBuf, QtyBase, SalesLine."Shipment Date", EntriesExist);
            SetSource(
              DATABASE::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", SalesLine."Line No.", '', 0);
            IF SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::"Return Order"] THEN
                "Reservation Status" := "Reservation Status"::Surplus
            ELSE
                "Reservation Status" := "Reservation Status"::Prospect;
            IF AppliedFromItemEntry THEN
                "Appl.-from Item Entry" := ItemLedgEntryBuf."Entry No.";
            Description := SalesLine.Description;
            OnCopyItemLedgEntryTrkgToDocLine(ItemLedgEntryBuf, ReservEntry);
            UpdateItemTracking;
            OnBeforeInsertReservEntryForSalesLine(ReservEntry, SalesLine);
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertReservEntryForPurchLine(ItemLedgEntryBuf: Record 32; PurchaseLine: Record 39; QtyBase: Decimal; AppliedToItemEntry: Boolean; VAR EntriesExist: Boolean);
    VAR
        ReservEntry: Record 337;
    BEGIN
        IF QtyBase = 0 THEN
            EXIT;

        WITH ReservEntry DO BEGIN
            InitReservEntry(ReservEntry, ItemLedgEntryBuf, QtyBase, PurchaseLine."Expected Receipt Date", EntriesExist);
            SetSource(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.", '', 0);
            IF PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Order, PurchaseLine."Document Type"::"Return Order"] THEN
                "Reservation Status" := "Reservation Status"::Surplus
            ELSE
                "Reservation Status" := "Reservation Status"::Prospect;
            IF AppliedToItemEntry THEN
                "Appl.-to Item Entry" := ItemLedgEntryBuf."Entry No.";
            Description := PurchaseLine.Description;
            OnCopyItemLedgEntryTrkgToDocLine(ItemLedgEntryBuf, ReservEntry);
            UpdateItemTracking;
            OnBeforeInsertReservEntryForPurchLine(ReservEntry, PurchaseLine);
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InsertReservEntryFromTrackingSpec(TrackingSpecification: Record 336; SourceSubtype: Enum "Purchase Document Type"; SourceID: Code[20]; SourceRefNo: Integer; QtyBase: Decimal);
    VAR
        ReservEntry: Record 337;
    BEGIN
        IF QtyBase = 0 THEN
            EXIT;

        WITH ReservEntry DO BEGIN
            INIT;
            TRANSFERFIELDS(TrackingSpecification);
            "Source Subtype" := SourceSubtype.AsInteger();
            "Source ID" := SourceID;
            "Source Ref. No." := SourceRefNo;
            "Reservation Status" := "Reservation Status"::Prospect;
            "Quantity Invoiced (Base)" := 0;
            VALIDATE("Quantity (Base)", QtyBase);
            Positive := ("Quantity (Base)" > 0);
            "Entry No." := 0;
            "Item Tracking" := Enum::"Item Tracking Entry Type".FromInteger(ItemTrackingOption("Lot No.", "Serial No."));
            INSERT;
        END;
    END;

    LOCAL PROCEDURE InitReservEntry(VAR ReservEntry: Record 337; ItemLedgEntryBuf: Record 32; QtyBase: Decimal; Date: Date; VAR EntriesExist: Boolean);
    BEGIN
        WITH ReservEntry DO BEGIN
            INIT;
            "Item No." := ItemLedgEntryBuf."Item No.";
            "Location Code" := ItemLedgEntryBuf."Location Code";
            "Variant Code" := ItemLedgEntryBuf."Variant Code";
            "Qty. per Unit of Measure" := ItemLedgEntryBuf."Qty. per Unit of Measure";
            CopyTrackingFromItemLedgEntry(ItemLedgEntryBuf);
            "Quantity Invoiced (Base)" := 0;
            VALIDATE("Quantity (Base)", QtyBase);
            Positive := ("Quantity (Base)" > 0);
            "Entry No." := 0;
            IF Positive THEN BEGIN
                "Warranty Date" := ItemLedgEntryBuf."Warranty Date";
                "Expiration Date" :=
                  ExistingExpirationDate("Item No.", "Variant Code", "Lot No.", "Serial No.", FALSE, EntriesExist);
                "Expected Receipt Date" := Date;
            END ELSE
                "Shipment Date" := Date;
            "Creation Date" := WORKDATE;
            "Created By" := USERID;
        END;

        OnAfterInitReservEntry(ReservEntry, ItemLedgEntryBuf);
    END;



    LOCAL PROCEDURE IsReservedFromTransferShipment(ReservEntry: Record 337): Boolean;
    BEGIN
        EXIT((ReservEntry."Source Type" = DATABASE::"Transfer Line") AND (ReservEntry."Source Subtype" = 0));
    END;

    // [External]
    PROCEDURE ItemTrackingExistsOnDocumentLine(SourceType : Integer;SourceSubtype : Enum "Sales Document Type";SourceID : Code[20];SourceRefNo : Integer) : Boolean;
    VAR
      TrackingSpecification : Record 336;
      ReservEntry : Record 337;
    BEGIN
      TrackingSpecification.SetSourceFilter(SourceType,SourceSubtype.AsInteger(),SourceID,SourceRefNo,TRUE);
    //   TrackingSpecification.SetSourceFilter2('',0);
      TrackingSpecification.SETRANGE(Correction,FALSE);
      ReservEntry.SetSourceFilter(SourceType,SourceSubtype.AsInteger(),SourceID,SourceRefNo,TRUE);
    //   ReservEntry.SetSourceFilter2('',0);
      ReservEntry.SETFILTER("Item Tracking",'<>%1',ReservEntry."Item Tracking"::None);

      EXIT(NOT TrackingSpecification.ISEMPTY OR NOT ReservEntry.ISEMPTY);
    END;


// [External]
    PROCEDURE DeleteInvoiceSpecFromLine(SourceType : Integer;SourceSubtype : Enum "Purchase Document Type";SourceID : Code[20];SourceRefNo : Integer);
    VAR
      TrackingSpecification : Record 336;
    BEGIN
      TrackingSpecification.SetSourceFilter(SourceType,SourceSubtype.AsInteger(),SourceID,SourceRefNo,FALSE);
    //   TrackingSpecification.SetSourceFilter2('',0);
      TrackingSpecification.DELETEALL;
    END;


    //[External]
    PROCEDURE CalcQtyToHandleForTrackedQtyOnDocumentLine(SourceType: Integer; SourceSubtype: Enum "Sales Document Type"; SourceID: Code[20]; SourceRefNo: Integer): Decimal;
    VAR
        ReservEntry: Record 337;
    BEGIN
        ReservEntry.SetSourceFilter(SourceType, SourceSubtype.AsInteger(), SourceID, SourceRefNo, TRUE);
        ReservEntry.SetSourceFilter('', 0);
        ReservEntry.SETFILTER("Item Tracking", '<>%1', ReservEntry."Item Tracking"::None);
        ReservEntry.CALCSUMS("Qty. to Handle (Base)");
        EXIT(ReservEntry."Qty. to Handle (Base)");
    END;

    LOCAL PROCEDURE CheckQtyToInvoiceMatchItemTracking(VAR TempTrackingSpecSummedUp: Record 336 TEMPORARY; VAR TempTrackingSpecNotInvoiced: Record 336 TEMPORARY; QtyToInvoiceOnDocLine: Decimal; QtyPerUoM: Decimal);
    VAR
        NoOfLotsOrSerials: Integer;
        Sign: Integer;
        QtyToInvOnLineAndTrkgDiff: Decimal;
    BEGIN
        TempTrackingSpecSummedUp.RESET;
        TempTrackingSpecSummedUp.SETFILTER("Qty. to Invoice (Base)", '<>%1', 0);
        NoOfLotsOrSerials := TempTrackingSpecSummedUp.COUNT;
        IF NoOfLotsOrSerials = 0 THEN
            EXIT;

        TempTrackingSpecSummedUp.CALCSUMS("Qty. to Invoice (Base)");
        QtyToInvOnLineAndTrkgDiff := ABS(QtyToInvoiceOnDocLine) - ABS(TempTrackingSpecSummedUp."Qty. to Invoice (Base)");
        IF QtyToInvOnLineAndTrkgDiff = 0 THEN
            EXIT;

        IF ((NoOfLotsOrSerials > 1) AND (QtyToInvOnLineAndTrkgDiff <> 0)) OR
           ((NoOfLotsOrSerials = 1) AND (QtyToInvOnLineAndTrkgDiff > 0))
        THEN
            ERROR(QtyToInvoiceDoesNotMatchItemTrackingErr);

        IF TempTrackingSpecNotInvoiced.ISEMPTY THEN
            EXIT;

        IF NoOfLotsOrSerials = 1 THEN BEGIN
            QtyToInvoiceOnDocLine := ABS(QtyToInvoiceOnDocLine);
            TempTrackingSpecNotInvoiced.CALCSUMS("Qty. to Invoice (Base)");
            IF QtyToInvoiceOnDocLine < ABS(TempTrackingSpecNotInvoiced."Qty. to Invoice (Base)") THEN BEGIN
                TempTrackingSpecNotInvoiced.FINDSET;
                REPEAT
                    IF QtyToInvoiceOnDocLine >= ABS(TempTrackingSpecNotInvoiced."Qty. to Invoice (Base)") THEN
                        QtyToInvoiceOnDocLine -= ABS(TempTrackingSpecNotInvoiced."Qty. to Invoice (Base)")
                    ELSE BEGIN
                        Sign := 1;
                        IF TempTrackingSpecNotInvoiced."Qty. to Invoice (Base)" < 0 THEN
                            Sign := -1;

                        TempTrackingSpecNotInvoiced."Qty. to Invoice (Base)" := QtyToInvoiceOnDocLine * Sign;
                        TempTrackingSpecNotInvoiced."Qty. to Invoice" :=
                          ROUND(TempTrackingSpecNotInvoiced."Qty. to Invoice (Base)" / QtyPerUoM, 0.00001);
                        TempTrackingSpecNotInvoiced.MODIFY;

                        QtyToInvoiceOnDocLine := 0;
                    END;
                UNTIL TempTrackingSpecNotInvoiced.NEXT = 0;
            END;
        END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInsertWhseItemTrkgLinesLoop(VAR PostedWhseReceiptLine: Record 7319; VAR WhseItemEntryRelation: Record 6509; VAR WhseItemTrackingLine: Record 6550);
    BEGIN
    END;



    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCheckWhseItemTrkg(VAR TempWhseItemTrkgLine: Record 6550 TEMPORARY; WhseWkshLine: Record 7326; VAR Checked: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateWhseItemTrkgForReceipt(VAR WhseItemTrackingLine: Record 6550; WhseWkshLine: Record 7326);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeCreateWhseItemTrkgForResEntry(VAR WhseItemTrackingLine: Record 6550; SourceReservEntry: Record 337; WhseWkshLine: Record 7326);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeExistingExpirationDate(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; TestMultiple: Boolean; VAR EntriesExist: Boolean; VAR ExpDate: Date; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeExistingExpirationDateAndQty(ItemNo: Code[20]; Variant: Code[20]; LotNo: Code[50]; SerialNo: Code[50]; SumOfEntries: Decimal; VAR ExpDate: Date; VAR IsHandled: Boolean);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeFindTempHandlingSpecification(VAR TempTrackingSpecification: Record 336 TEMPORARY; ReservEntry: Record 337);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertReservEntryForPurchLine(VAR ReservEntry: Record 337; PurchLine: Record 39);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertReservEntryForSalesLine(VAR ReservEntry: Record 337; SalesLine: Record 37);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertSplitPostedWhseRcptLine(VAR TempPostedWhseRcptLine: Record 7319 TEMPORARY; PostedWhseRcptLine: Record 7319; WhseItemEntryRelation: Record 6509);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertSplitInternalPutAwayLine(VAR TempPostedWhseRcptLine: Record 7319 TEMPORARY; PostedWhseRcptLine: Record 7319; WhseItemTrackingLine: Record 6550);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeTempWhseJnlLine2Insert(VAR TempWhseJnlLineTo: Record 7311 TEMPORARY; TempWhseJnlLineFrom: Record 7311 TEMPORARY; VAR TempSplitTrackingSpec: Record 7311 TEMPORARY; TransferTo: Boolean);
    BEGIN
    END;



    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeWhseItemTrackingLineInsert(VAR WhseItemTrackingLine: Record 6550; SourceReservEntry: Record 337);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnSyncActivItemTrkgOnBeforeInsertTempReservEntry(VAR TempReservEntry: Record 337 TEMPORARY; WhseActivLine: Record 5767);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertWhseItemTrkgLines(VAR WhseItemTrkgLine: Record 6550; PostedWhseReceiptLine: Record 7319; WhseItemEntryRelation: Record 6509);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeModifyWhseItemTrkgLines(VAR WhseItemTrkgLine: Record 6550; PostedWhseReceiptLine: Record 7319; WhseItemEntryRelation: Record 6509);
    BEGIN
    END;


    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeInsertWhseItemTrkgLinesLoop(VAR PostedWhseReceiptLine: Record 7319; VAR WhseItemEntryRelation: Record 6509; VAR WhseItemTrackingLine: Record 6550);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnCopyItemLedgEntryTrkgToDocLine(VAR ItemLedgerEntry: Record 32; VAR ReservationEntry: Record 337);
    BEGIN
    END;



    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterInitReservEntry(VAR ReservEntry: Record 337; ItemLedgerEntry: Record 32);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterReserveEntryFilter(ItemJournalLine: Record 83; VAR ReservationEntry: Record 337);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnRetrieveItemTrackingFromReservEntryFilter(VAR ReservEntry: Record 337; ItemJournalLine: Record 83);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSplitWhseJnlLine(VAR TempWhseJnlLine: Record 7311 TEMPORARY; VAR TempWhseJnlLine2: Record 7311 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterSplitPostedWhseReceiptLine(PostedWhseRcptLine: Record 7319; VAR TempPostedWhseRcptLine: Record 7319 TEMPORARY);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnSynchronizeWhseActivItemTrkgOnAfterSetExpirationDate(VAR WarehouseActivityLine: Record 5767; VAR ReservationEntry: Record 337);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnTempPostedWhseRcptLineSetFilters(VAR PostedWhseReceiptLine: Record 7319; ItemLedgerEntry: Record 32; WhseItemEntryRelation: Record 6509);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







