Codeunit 50017 "Calc. Item Availability 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        TempInvtEventBuf: Record 5530 TEMPORARY;
        EntryNo: Integer;
        Text0000: TextConst ENU = 'Table %1 is not supported by the ShowDocument function.', ESP = 'La tabla %1 no es compatible con la funci�n ShowDocument.';
        "----------------------------- QB": Integer;
        QBCodeunitPublisher: Codeunit 7207352;
        CalcItemAvailability: Codeunit 5530;






    LOCAL PROCEDURE GetAnticipatedDemand(VAR InvtEventBuf: Record 5530; VAR Item: Record 27; ForecastName: Code[10]; ExcludeForecastBefore: Date; IncludeBlanketOrders: Boolean);
    BEGIN
        IF ForecastName <> '' THEN
            GetRemainingForecast(InvtEventBuf, Item, ForecastName, ExcludeForecastBefore);
        IF IncludeBlanketOrders THEN
            GetBlanketSalesOrders(InvtEventBuf, Item);
    END;

    LOCAL PROCEDURE TryGetQtyOnInventory(VAR InvtEventBuf: Record 5530; VAR Item: Record 27): Boolean;
    VAR
        ItemLedgEntry: Record 32;
        FilterItemLedgEntry: Record 32;
        IncludeLocation: Boolean;
    BEGIN
        IF NOT ItemLedgEntry.READPERMISSION THEN
            EXIT(FALSE);

        IF ItemLedgEntry.FindLinesWithItemToPlan(Item, FALSE) THEN BEGIN
            FilterItemLedgEntry.COPY(ItemLedgEntry);
            REPEAT
                IF ItemLedgEntry."Location Code" = '' THEN
                    IncludeLocation := TRUE
                ELSE
                    IncludeLocation := NOT IsInTransitLocation(ItemLedgEntry."Location Code");

                ItemLedgEntry.SETRANGE("Variant Code", ItemLedgEntry."Variant Code");
                ItemLedgEntry.SETRANGE("Location Code", ItemLedgEntry."Location Code");

                IF IncludeLocation THEN BEGIN
                    ItemLedgEntry.CALCSUMS("Remaining Quantity");
                    IF ItemLedgEntry."Remaining Quantity" <> 0 THEN BEGIN
                        InvtEventBuf.TransferInventoryQty(ItemLedgEntry);
                        InsertEntry(InvtEventBuf);
                    END;
                END;

                ItemLedgEntry.FIND('+');
                ItemLedgEntry.COPYFILTERS(FilterItemLedgEntry);
            UNTIL ItemLedgEntry.NEXT = 0;
        END;

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE TryGetPurchOrderSupplyEntries(VAR InvtEventBuf: Record 5530; VAR Item: Record 27): Boolean;
    VAR
        PurchLine: Record 39;
    BEGIN
        IF NOT PurchLine.READPERMISSION THEN
            EXIT(FALSE);

        IF PurchLine.FindLinesWithItemToPlan(Item, PurchLine."Document Type"::Order) THEN
            REPEAT
                InvtEventBuf.TransferFromPurchase(PurchLine);
                InsertEntry(InvtEventBuf);
            UNTIL PurchLine.NEXT = 0;

        EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetRemainingForecast(VAR InvtEventBuf: Record 5530; VAR Item: Record 27; ForecastName: Code[10]; ExcludeForecastBefore: Date);
    VAR
        ItemLedgEntry: Record 32;
        MfgSetup: Record 99000765;
        ProdForecastEntry: Record 99000852;
        ProdForecastEntry2: Record 99000852;
        CopyOfInvtEventBuf: Record 5530;
        FromDate: Date;
        ToDate: Date;
        ForecastPeriodEndDate: Date;
        RemainingForecastQty: Decimal;
        ModuleLoop: Integer;
        ReplenishmentLocation: Code[10];
        LocationMandatory: Boolean;
        Module: Boolean;
    BEGIN
        // Include Forecast consumption
        CopyOfInvtEventBuf.COPY(InvtEventBuf);
        IF FORMAT(Item."Date Filter") <> '' THEN BEGIN
            FromDate := Item.GETRANGEMIN("Date Filter");
            ToDate := Item.GETRANGEMAX("Date Filter");
        END;
        IF FromDate = 0D THEN
            FromDate := WORKDATE;
        IF ToDate = 0D THEN
            ToDate := DMY2DATE(30, 12, 9999);

        MfgSetup.GET;
        IF NOT MfgSetup."Use Forecast on Locations" THEN BEGIN
            IF NOT FindReplishmentLocation(ReplenishmentLocation, Item, LocationMandatory) THEN
                ReplenishmentLocation := MfgSetup."Components at Location";
            IF LocationMandatory AND
               (ReplenishmentLocation = '')
            THEN
                EXIT;

            ProdForecastEntry.SETCURRENTKEY(
              ProdForecastEntry."Production Forecast Name", ProdForecastEntry."Item No.", ProdForecastEntry."Component Forecast", ProdForecastEntry."Forecast Date", ProdForecastEntry."Location Code");
        END ELSE
            ProdForecastEntry.SETCURRENTKEY(
              ProdForecastEntry."Production Forecast Name", ProdForecastEntry."Item No.", ProdForecastEntry."Location Code", ProdForecastEntry."Forecast Date", ProdForecastEntry."Component Forecast");

        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code");

        ProdForecastEntry.SETRANGE(ProdForecastEntry."Production Forecast Name", ForecastName);
        ProdForecastEntry.SETRANGE(ProdForecastEntry."Forecast Date", ExcludeForecastBefore, ToDate);
        ProdForecastEntry.SETRANGE(ProdForecastEntry."Item No.", Item."No.");

        ProdForecastEntry2.COPY(ProdForecastEntry);
        Item.COPYFILTER("Location Filter", ProdForecastEntry2."Location Code");

        FOR ModuleLoop := 1 TO 2 DO BEGIN
            Module := ModuleLoop = 2;
            ProdForecastEntry.SETRANGE(ProdForecastEntry."Component Forecast", Module);
            ProdForecastEntry2.SETRANGE(ProdForecastEntry2."Component Forecast", Module);
            IF ProdForecastEntry2.FINDSET THEN
                REPEAT
                    IF MfgSetup."Use Forecast on Locations" THEN BEGIN
                        ProdForecastEntry2.SETRANGE(ProdForecastEntry2."Location Code", ProdForecastEntry2."Location Code");
                        ItemLedgEntry.SETRANGE("Location Code", ProdForecastEntry2."Location Code");
                        InvtEventBuf.SETRANGE("Location Code", ProdForecastEntry2."Location Code");
                    END ELSE BEGIN
                        Item.COPYFILTER("Location Filter", ProdForecastEntry2."Location Code");
                        Item.COPYFILTER("Location Filter", ItemLedgEntry."Location Code");
                        Item.COPYFILTER("Location Filter", InvtEventBuf."Location Code");
                    END;
                    ProdForecastEntry2.FINDLAST;
                    ProdForecastEntry2.COPYFILTER(ProdForecastEntry2."Location Code", ProdForecastEntry."Location Code");
                    Item.COPYFILTER("Location Filter", ProdForecastEntry2."Location Code");

                    IF ForecastExist(ProdForecastEntry, ExcludeForecastBefore, FromDate, ToDate) THEN
                        REPEAT
                            ProdForecastEntry.SETRANGE(ProdForecastEntry."Forecast Date", ProdForecastEntry."Forecast Date");
                            ProdForecastEntry.FIND('+');
                            ProdForecastEntry.CALCSUMS(ProdForecastEntry."Forecast Quantity (Base)");
                            RemainingForecastQty := ProdForecastEntry."Forecast Quantity (Base)";
                            ForecastPeriodEndDate := FindForecastPeriodEndDate(ProdForecastEntry, ToDate);

                            ItemLedgEntry.SETRANGE("Item No.", Item."No.");
                            ItemLedgEntry.SETRANGE(Positive, FALSE);
                            ItemLedgEntry.SETRANGE(Open);
                            ItemLedgEntry.SETRANGE(
                              "Posting Date", ProdForecastEntry."Forecast Date", ForecastPeriodEndDate);
                            Item.COPYFILTER("Variant Filter", ItemLedgEntry."Variant Code");
                            IF Module THEN BEGIN
                                ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                                IF ItemLedgEntry.FINDSET THEN
                                    REPEAT
                                        RemainingForecastQty += ItemLedgEntry.Quantity;
                                    UNTIL ItemLedgEntry.NEXT = 0;
                            END ELSE BEGIN
                                ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                                IF ItemLedgEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        IF NOT ItemLedgEntry."Derived from Blanket Order" THEN
                                            RemainingForecastQty += ItemLedgEntry.Quantity;
                                    UNTIL ItemLedgEntry.NEXT = 0;
                                    // Undo shipment shall neutralize consumption from sales
                                    RemainingForecastQty += AjustForUndoneShipments(ItemLedgEntry);
                                END;
                            END;

                            InvtEventBuf.SETRANGE("Item No.", ProdForecastEntry."Item No.");
                            InvtEventBuf.SETRANGE(
                              "Availability Date", ProdForecastEntry."Forecast Date", ForecastPeriodEndDate);
                            IF Module THEN
                                InvtEventBuf.SETFILTER(Type, '%1|%2', InvtEventBuf.Type::Component, InvtEventBuf.Type::"Assembly Component")
                            ELSE
                                InvtEventBuf.SETFILTER(Type, '%1|%2', InvtEventBuf.Type::Sale, InvtEventBuf.Type::Service);
                            IF InvtEventBuf.FIND('-') THEN
                                REPEAT
                                    IF NOT (InvtEventBuf.Positive OR InvtEventBuf."Derived from Blanket Order")
                                    THEN
                                        RemainingForecastQty += InvtEventBuf."Remaining Quantity (Base)";
                                UNTIL (InvtEventBuf.NEXT = 0) OR (RemainingForecastQty < 0);

                            IF RemainingForecastQty < 0 THEN
                                RemainingForecastQty := 0;

                            InvtEventBuf.TransferFromForecast(ProdForecastEntry, RemainingForecastQty, MfgSetup."Use Forecast on Locations");
                            InsertEntry(InvtEventBuf);

                            ProdForecastEntry.SETRANGE(ProdForecastEntry."Forecast Date", ExcludeForecastBefore, ToDate);
                        UNTIL ProdForecastEntry.NEXT = 0;
                UNTIL ProdForecastEntry2.NEXT = 0;
        END;
        InvtEventBuf.COPY(CopyOfInvtEventBuf);
    END;

    LOCAL PROCEDURE GetBlanketSalesOrders(VAR InvtEventBuf: Record 5530; VAR Item: Record 27);
    VAR
        BlanketSalesLine: Record 37;
        CopyOfInvtEventBuf: Record 5530;
        QtyReleased: Decimal;
    BEGIN
        CopyOfInvtEventBuf.COPY(InvtEventBuf);

        WITH BlanketSalesLine DO BEGIN
            IF FindLinesWithItemToPlan(Item, "Document Type"::"Blanket Order") THEN
                REPEAT
                    InvtEventBuf.SETRANGE(Type, InvtEventBuf.Type::Sale);
                    InvtEventBuf.SETRANGE("Derived from Blanket Order", TRUE);
                    InvtEventBuf.SETRANGE("Ref. Order No.", "Document No.");
                    InvtEventBuf.SETRANGE("Ref. Order Line No.", "Line No.");
                    IF InvtEventBuf.FIND('-') THEN
                        REPEAT
                            QtyReleased -= InvtEventBuf."Remaining Quantity (Base)";
                        UNTIL InvtEventBuf.NEXT = 0;
                    SETRANGE("Document No.", "Document No.");
                    SETRANGE("Line No.", "Line No.");
                    REPEAT
                        IF "Outstanding Qty. (Base)" > QtyReleased THEN BEGIN
                            InvtEventBuf.TransferFromSalesBlanketOrder(
                              BlanketSalesLine, "Outstanding Qty. (Base)" - QtyReleased);
                            InsertEntry(InvtEventBuf);
                            QtyReleased := 0;
                        END ELSE
                            QtyReleased -= "Outstanding Qty. (Base)";
                    UNTIL NEXT = 0;
                    SETRANGE("Document No.");
                    SETRANGE("Line No.");
                UNTIL NEXT = 0;
        END;

        InvtEventBuf.COPY(CopyOfInvtEventBuf);
    END;

    LOCAL PROCEDURE GetPlanningLines(VAR InvtEventBuf: Record 5530; VAR Item: Record 27);
    VAR
        ReqLine: Record 246;
        RecRef: RecordRef;
    BEGIN
        // Planning suggestions
        WITH ReqLine DO BEGIN
            SETRANGE(Type, Type::Item);
            SETRANGE("No.", Item."No.");
            SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
            SETFILTER("Variant Code", Item.GETFILTER("Variant Filter"));
            IF FINDSET THEN
                REPEAT
                    RecRef.GETTABLE(ReqLine);
                    CASE "Action Message" OF
                        "Action Message"::New:
                            BEGIN
                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Due Date", "Quantity (Base)", RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);
                            END;
                        "Action Message"::"Change Qty.":
                            BEGIN
                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Due Date", -GetOriginalQtyBase, RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);

                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Due Date", "Quantity (Base)", RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);
                            END;
                        "Action Message"::Reschedule:
                            BEGIN
                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Original Due Date", -"Quantity (Base)", RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);

                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Due Date", "Quantity (Base)", RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);
                            END;
                        "Action Message"::"Resched. & Chg. Qty.":
                            BEGIN
                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Original Due Date", -GetOriginalQtyBase, RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);

                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Due Date", "Quantity (Base)", RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);
                            END;
                        "Action Message"::Cancel:
                            BEGIN
                                InvtEventBuf.TransferFromReqLine(ReqLine, "Location Code", "Due Date", -GetOriginalQtyBase, RecRef.RECORDID);
                                InsertEntry(InvtEventBuf);
                            END;
                    END;
                UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE InsertEntry(VAR NewInvtEventBuffer: Record 5530);
    BEGIN
        NewInvtEventBuffer."Entry No." := NextEntryNo;
        NewInvtEventBuffer.INSERT;
    END;

    LOCAL PROCEDURE NextEntryNo() : Integer;
    BEGIN
      EntryNo += 1;
      EXIT(EntryNo);
    END;

    LOCAL PROCEDURE FindForecastPeriodEndDate(VAR ProdForecastEntry : Record 99000852;ToDate : Date) : Date;
    VAR
      NextProdForecastEntry : Record 99000852;
      NextForecastExist : Boolean;
    BEGIN
      NextProdForecastEntry.COPY(ProdForecastEntry);
      NextProdForecastEntry.SETRANGE("Forecast Date",ProdForecastEntry."Forecast Date" + 1,ToDate);
      IF NextProdForecastEntry.FINDFIRST THEN
        REPEAT
          NextProdForecastEntry.SETRANGE("Forecast Date",NextProdForecastEntry."Forecast Date");
          NextProdForecastEntry.CALCSUMS("Forecast Quantity (Base)");
          IF NextProdForecastEntry."Forecast Quantity (Base)" = 0 THEN BEGIN
            NextProdForecastEntry.SETRANGE("Forecast Date",NextProdForecastEntry."Forecast Date" + 1,ToDate);
            IF NOT NextProdForecastEntry.FINDLAST THEN
              NextProdForecastEntry."Forecast Date" := ToDate + 1;
          END ELSE
            NextForecastExist := TRUE;
        UNTIL (NextProdForecastEntry."Forecast Date" = ToDate + 1) OR NextForecastExist
      ELSE
        NextProdForecastEntry."Forecast Date" := ToDate + 1;
      EXIT(NextProdForecastEntry."Forecast Date" - 1);
    END;

    LOCAL PROCEDURE AjustForUndoneShipments(VAR ItemLedgEntry : Record 32) AdjustQty : Decimal;
    VAR
      CorItemLedgEntry : Record 32;
    BEGIN
      CorItemLedgEntry.COPY(ItemLedgEntry);
      CorItemLedgEntry.SETRANGE(Positive,TRUE);
      CorItemLedgEntry.SETRANGE(Correction,TRUE);
      IF CorItemLedgEntry.FINDSET THEN
        REPEAT
          IF NOT CorItemLedgEntry."Derived from Blanket Order" THEN
            AdjustQty += CorItemLedgEntry.Quantity;
        UNTIL CorItemLedgEntry.NEXT = 0;
      ItemLedgEntry.SETRANGE(Correction);
    END;

    //[External]
    PROCEDURE GetSourceReferences(FromRecordID: RecordID; TransferDirection: Option "Outbound","Inbound"; VAR SourceType: Integer; VAR SourceSubtype: Integer; VAR SourceID: Code[20]; VAR SourceBatchName: Code[10]; VAR SourceProdOrderLine: Integer; VAR SourceRefNo: Integer): Boolean;
    VAR
        ItemLedgEntry: Record 32;
        SalesLine: Record 37;
        PurchLine: Record 39;
        TransLine: Record 5741;
        ProdOrderLine: Record 5406;
        ProdOrderComp: Record 5407;
        PlngComp: Record 99000829;
        ProdForecastEntry: Record 99000852;
        ReqLine: Record 246;
        ServiceLine: Record 5902;
        JobPlngLine: Record 1003;
        AssemblyHeader: Record 900;
        AssemblyLine: Record 901;
        RecRef: RecordRef;
    BEGIN
        SourceType := 0;
        SourceSubtype := 0;
        SourceID := '';
        SourceBatchName := '';
        SourceProdOrderLine := 0;
        SourceRefNo := 0;

        RecRef := FromRecordID.GETRECORD;

        CASE FromRecordID.TABLENO OF
            DATABASE::"Item Ledger Entry":
                BEGIN
                    RecRef.SETTABLE(ItemLedgEntry);
                    SourceType := DATABASE::"Item Ledger Entry";
                    SourceRefNo := ItemLedgEntry."Entry No.";
                END;
            DATABASE::"Sales Line":
                BEGIN
                    RecRef.SETTABLE(SalesLine);
                    SourceType := DATABASE::"Sales Line";
                    SourceSubtype := SalesLine."Document Type".AsInteger();
                    SourceID := SalesLine."Document No.";
                    SourceRefNo := SalesLine."Line No.";
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    RecRef.SETTABLE(PurchLine);
                    SourceType := DATABASE::"Purchase Line";
                    SourceSubtype := PurchLine."Document Type".AsInteger();
                    SourceID := PurchLine."Document No.";
                    SourceRefNo := PurchLine."Line No.";
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    RecRef.SETTABLE(TransLine);
                    SourceType := DATABASE::"Transfer Line";
                    SourceSubtype := TransferDirection;
                    TransLine.GET(TransLine."Document No.", TransLine."Line No.");
                    SourceID := TransLine."Document No.";
                    SourceProdOrderLine := TransLine."Derived From Line No.";
                    SourceRefNo := TransLine."Line No.";
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    RecRef.SETTABLE(ProdOrderLine);
                    SourceType := DATABASE::"Prod. Order Line";
                    SourceSubtype := ProdOrderLine.Status.AsInteger();
                    SourceID := ProdOrderLine."Prod. Order No.";
                    SourceProdOrderLine := ProdOrderLine."Line No.";
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    RecRef.SETTABLE(ProdOrderComp);
                    SourceType := DATABASE::"Prod. Order Component";
                    SourceSubtype := ProdOrderComp.Status.AsInteger();
                    SourceID := ProdOrderComp."Prod. Order No.";
                    SourceProdOrderLine := ProdOrderComp."Prod. Order Line No.";
                    SourceRefNo := ProdOrderComp."Line No.";
                END;
            DATABASE::"Planning Component":
                BEGIN
                    RecRef.SETTABLE(PlngComp);
                    SourceType := DATABASE::"Planning Component";
                    SourceID := PlngComp."Worksheet Template Name";
                    SourceBatchName := PlngComp."Worksheet Batch Name";
                    SourceProdOrderLine := PlngComp."Worksheet Line No.";
                    SourceRefNo := PlngComp."Line No.";
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    RecRef.SETTABLE(ReqLine);
                    SourceType := DATABASE::"Requisition Line";
                    SourceSubtype := TransferDirection;
                    SourceID := ReqLine."Worksheet Template Name";
                    SourceBatchName := ReqLine."Journal Batch Name";
                    SourceRefNo := ReqLine."Line No.";
                END;
            DATABASE::"Service Line":
                BEGIN
                    RecRef.SETTABLE(ServiceLine);
                    SourceType := DATABASE::"Service Line";
                    SourceSubtype := ServiceLine."Document Type".AsInteger();
                    SourceID := ServiceLine."Document No.";
                    SourceRefNo := ServiceLine."Line No.";
                END;
            DATABASE::"Job Planning Line":
                BEGIN
                    RecRef.SETTABLE(JobPlngLine);
                    SourceType := DATABASE::"Job Planning Line";
                    JobPlngLine.GET(JobPlngLine."Job No.", JobPlngLine."Job Task No.", JobPlngLine."Line No.");
                    SourceSubtype := JobPlngLine.Status.AsInteger();
                    SourceID := JobPlngLine."Job No.";
                    SourceRefNo := JobPlngLine."Job Contract Entry No.";
                END;
            DATABASE::"Production Forecast Entry":
                BEGIN
                    RecRef.SETTABLE(ProdForecastEntry);
                    SourceType := DATABASE::"Production Forecast Entry";
                    SourceRefNo := ProdForecastEntry."Entry No.";
                END;
            DATABASE::"Assembly Header":
                BEGIN
                    RecRef.SETTABLE(AssemblyHeader);
                    SourceType := DATABASE::"Assembly Header";
                    SourceSubtype := AssemblyHeader."Document Type".AsInteger();
                    SourceID := AssemblyHeader."No.";
                END;
            DATABASE::"Assembly Line":
                BEGIN
                    RecRef.SETTABLE(AssemblyLine);
                    SourceType := DATABASE::"Assembly Line";
                    SourceSubtype := AssemblyLine."Document Type".AsInteger();
                    SourceID := AssemblyLine."Document No.";
                    SourceRefNo := AssemblyLine."Line No.";
                END;
            // QB.begin
            DATABASE::"Purchase Journal Line":
                QBCodeunitPublisher.GetSourceReferencesCUCalcItemAvailabiity(SourceType, SourceID, SourceBatchName, SourceRefNo);
            // QB.end
            ELSE
                EXIT(FALSE);
        END;
        EXIT(TRUE);
    END;

    //[External]
    PROCEDURE ShowDocument(RecordID: RecordID);
    VAR
        ItemLedgEntry: Record 32;
        SalesHeader: Record 36;
        SalesShptHeader: Record 110;
        SalesInvHeader: Record 112;
        SalesCrMemoHeader: Record 114;
        ServShptHeader: Record 5990;
        ServInvHeader: Record 5992;
        ServCrMemoHeader: Record 5994;
        PurchHeader: Record 38;
        PurchRcptHeader: Record 120;
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
        ReturnShptHeader: Record 6650;
        ReturnRcptHeader: Record 6660;
        TransferHeader: Record 5740;
        TransShptHeader: Record 5744;
        TransRcptHeader: Record 5746;
        ProductionOrder: Record 5405;
        ProdForecastName: Record 99000851;
        RequisitionLine: Record 246;
        PlanningComponent: Record 99000829;
        AssemblyHeader: Record 900;
        AssemblyLine: Record 901;
        ReqWkshTemplate: Record 244;
        // DemandForecast: Page 99000919;
        PlanningWorksheet: Page 99000852;

        RecRef: RecordRef;
    BEGIN
        IF FORMAT(RecordID) = '' THEN
            EXIT;

        RecRef := RecordID.GETRECORD;

        CASE RecordID.TABLENO OF
            DATABASE::"Item Ledger Entry":
                BEGIN
                    RecRef.SETTABLE(ItemLedgEntry);
                    ItemLedgEntry.GET(ItemLedgEntry."Entry No.");
                    ItemLedgEntry.SETRANGE("Item No.", ItemLedgEntry."Item No.");
                    IF ItemLedgEntry."Location Code" <> '' THEN
                        ItemLedgEntry.SETRANGE("Location Code", ItemLedgEntry."Location Code");
                    IF ItemLedgEntry."Variant Code" <> '' THEN
                        ItemLedgEntry.SETRANGE("Variant Code", ItemLedgEntry."Variant Code");
                    PAGE.RUNMODAL(PAGE::"Item Ledger Entries", ItemLedgEntry);
                END;
            DATABASE::"Sales Header":
                BEGIN
                    RecRef.SETTABLE(SalesHeader);
                    CASE SalesHeader."Document Type" OF
                        SalesHeader."Document Type"::Order:
                            PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader);
                        SalesHeader."Document Type"::Invoice:
                            PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader);
                        SalesHeader."Document Type"::"Credit Memo":
                            PAGE.RUNMODAL(PAGE::"Sales Credit Memo", SalesHeader);
                        SalesHeader."Document Type"::"Blanket Order":
                            PAGE.RUNMODAL(PAGE::"Blanket Sales Orders", SalesHeader);
                        SalesHeader."Document Type"::"Return Order":
                            PAGE.RUNMODAL(PAGE::"Sales Return Order", SalesHeader);
                    END;
                END;
            DATABASE::"Sales Shipment Header":
                BEGIN
                    RecRef.SETTABLE(SalesShptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Sales Shipment", SalesShptHeader);
                END;
            DATABASE::"Sales Invoice Header":
                BEGIN
                    RecRef.SETTABLE(SalesInvHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvHeader);
                END;
            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    RecRef.SETTABLE(SalesCrMemoHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
                END;
            DATABASE::"Service Shipment Header":
                BEGIN
                    RecRef.SETTABLE(ServShptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Service Shipment", ServShptHeader);
                END;
            DATABASE::"Service Invoice Header":
                BEGIN
                    RecRef.SETTABLE(ServInvHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Service Invoice", ServInvHeader);
                END;
            DATABASE::"Service Cr.Memo Header":
                BEGIN
                    RecRef.SETTABLE(ServCrMemoHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Service Credit Memo", ServCrMemoHeader);
                END;
            DATABASE::"Purchase Header":
                BEGIN
                    RecRef.SETTABLE(PurchHeader);
                    CASE PurchHeader."Document Type" OF
                        PurchHeader."Document Type"::Order:
                            PAGE.RUNMODAL(PAGE::"Purchase Order", PurchHeader);
                        PurchHeader."Document Type"::Invoice:
                            PAGE.RUNMODAL(PAGE::"Purchase Invoice", PurchHeader);
                        PurchHeader."Document Type"::"Credit Memo":
                            PAGE.RUNMODAL(PAGE::"Purchase Credit Memo", PurchHeader);
                        PurchHeader."Document Type"::"Blanket Order":
                            PAGE.RUNMODAL(PAGE::"Blanket Purchase Order", PurchHeader);
                        PurchHeader."Document Type"::"Return Order":
                            PAGE.RUNMODAL(PAGE::"Purchase Return Order", PurchHeader);
                    END;
                END;
            DATABASE::"Purch. Rcpt. Header":
                BEGIN
                    RecRef.SETTABLE(PurchRcptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Purchase Receipt", PurchRcptHeader);
                END;
            DATABASE::"Purch. Inv. Header":
                BEGIN
                    RecRef.SETTABLE(PurchInvHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice", PurchInvHeader);
                END;
            DATABASE::"Purch. Cr. Memo Hdr.":
                BEGIN
                    RecRef.SETTABLE(PurchCrMemoHdr);
                    PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHdr);
                END;
            DATABASE::"Return Shipment Header":
                BEGIN
                    RecRef.SETTABLE(ReturnShptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Return Shipment", ReturnShptHeader);
                END;
            DATABASE::"Return Receipt Header":
                BEGIN
                    RecRef.SETTABLE(ReturnRcptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Return Receipt", ReturnRcptHeader);
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    RecRef.SETTABLE(TransferHeader);
                    PAGE.RUNMODAL(PAGE::"Transfer Order", TransferHeader);
                END;
            DATABASE::"Transfer Shipment Header":
                BEGIN
                    RecRef.SETTABLE(TransShptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Transfer Shipment", TransShptHeader);
                END;
            DATABASE::"Transfer Receipt Header":
                BEGIN
                    RecRef.SETTABLE(TransRcptHeader);
                    PAGE.RUNMODAL(PAGE::"Posted Transfer Receipt", TransRcptHeader);
                END;
            DATABASE::"Production Order":
                BEGIN
                    RecRef.SETTABLE(ProductionOrder);
                    CASE ProductionOrder.Status OF
                        ProductionOrder.Status::Planned:
                            PAGE.RUNMODAL(PAGE::"Planned Production Order", ProductionOrder);
                        ProductionOrder.Status::"Firm Planned":
                            PAGE.RUNMODAL(PAGE::"Firm Planned Prod. Order", ProductionOrder);
                        ProductionOrder.Status::Released:
                            PAGE.RUNMODAL(PAGE::"Released Production Order", ProductionOrder);
                        ProductionOrder.Status::Finished:
                            PAGE.RUNMODAL(PAGE::"Finished Production Order", ProductionOrder);
                    END;
                END;
            DATABASE::"Production Forecast Name":
                BEGIN
                    RecRef.SETTABLE(ProdForecastName);
                    // DemandForecast.SetProductionForecastName(ProdForecastName.Name);
                    // DemandForecast.RUNMODAL;
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    RecRef.SETTABLE(RequisitionLine);
                    ReqWkshTemplate.GET(RequisitionLine."Worksheet Template Name");
                    ReqWkshTemplate.TESTFIELD("Page ID");
                    PAGE.RUNMODAL(ReqWkshTemplate."Page ID", RequisitionLine);
                END;
            DATABASE::"Planning Component":
                BEGIN
                    RecRef.SETTABLE(PlanningComponent);

                    RequisitionLine.GET(
                      PlanningComponent."Worksheet Template Name", PlanningComponent."Worksheet Batch Name",
                      PlanningComponent."Worksheet Line No.");
                    PlanningWorksheet.SETTABLEVIEW(RequisitionLine);
                    PlanningWorksheet.SETRECORD(RequisitionLine);
                    PlanningWorksheet.RUN;

                    PlanningWorksheet.OpenPlanningComponent(PlanningComponent);
                END;
            DATABASE::"Assembly Header":
                BEGIN
                    RecRef.SETTABLE(AssemblyHeader);
                    PAGE.RUNMODAL(PAGE::"Assembly Order", AssemblyHeader);
                END;
            DATABASE::"Assembly Line":
                BEGIN
                    RecRef.SETTABLE(AssemblyLine);
                    AssemblyHeader.GET(AssemblyLine."Document Type", AssemblyLine."Document No.");
                    PAGE.RUNMODAL(PAGE::"Assembly Order", AssemblyHeader);
                END;
            // QB.begin
            DATABASE::"Purchase Journal Line":
                QBCodeunitPublisher.ShowDocumentCUCacItemAvailability(CalcItemAvailability);
            // QB.end
            ELSE
                ERROR(Text0000, RecordID.TABLENO);
        END;
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterGetDocumentEntries(VAR InvtEventBuf: Record 5530; VAR Item: Record 27; VAR CurrEntryNo: Integer);
    BEGIN
    END;

    LOCAL PROCEDURE "------------------------------------ QB"();
    BEGIN
    END;

    PROCEDURE QB_InsertEntry(VAR NewInvtEventBuffer: Record 5530);
    BEGIN
        InsertEntry(NewInvtEventBuffer);
    END;

    LOCAL PROCEDURE FindReplishmentLocation(VAR ReplenishmentLocation : Code[10];VAR Item : Record 27;VAR LocationMandatory : Boolean) : Boolean;
    VAR
      SKU : Record 5700;
      InvtSetup : Record 313;
    BEGIN
      InvtSetup.GET;
      LocationMandatory := InvtSetup."Location Mandatory";

      ReplenishmentLocation := '';
      SKU.SETCURRENTKEY("Item No.","Location Code","Variant Code");
      SKU.SETRANGE("Item No.",Item."No.");
      Item.COPYFILTER("Location Filter",SKU."Location Code");
      Item.COPYFILTER("Variant Filter",SKU."Variant Code");
      SKU.SETRANGE("Replenishment System",Item."Replenishment System"::Purchase,Item."Replenishment System"::"Prod. Order");
      SKU.SETFILTER("Reordering Policy",'<>%1',SKU."Reordering Policy"::" ");
      IF SKU.FIND('-') THEN
        IF SKU.NEXT = 0 THEN
          ReplenishmentLocation := SKU."Location Code";
      EXIT(ReplenishmentLocation <> '');
    END;

    LOCAL PROCEDURE IsInTransitLocation(LocationCode: Code[10]): Boolean;
    VAR
        Location: Record 14;
    BEGIN
        IF Location.GET(LocationCode) THEN
            EXIT(Location."Use As In-Transit");
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE ForecastExist(VAR ProdForecastEntry : Record 99000852;ExcludeForecastBefore : Date;FromDate : Date;ToDate : Date) : Boolean;
    VAR
      ForecastExist : Boolean;
    BEGIN
      WITH ProdForecastEntry DO BEGIN
        SETRANGE("Forecast Date",ExcludeForecastBefore,FromDate);
        IF FIND('+') THEN
          REPEAT
            SETRANGE("Forecast Date","Forecast Date");
            CALCSUMS("Forecast Quantity (Base)");
            IF "Forecast Quantity (Base)" <> 0 THEN
              ForecastExist := TRUE
            ELSE
              SETRANGE("Forecast Date",ExcludeForecastBefore,"Forecast Date" - 1);
          UNTIL (NOT FIND('+')) OR ForecastExist;

        IF NOT ForecastExist THEN BEGIN
          IF ExcludeForecastBefore > FromDate THEN
            SETRANGE("Forecast Date",ExcludeForecastBefore,ToDate)
          ELSE
            SETRANGE("Forecast Date",FromDate + 1,ToDate);
          IF FIND('-') THEN
            REPEAT
              SETRANGE("Forecast Date","Forecast Date");
              CALCSUMS("Forecast Quantity (Base)");
              IF "Forecast Quantity (Base)" <> 0 THEN
                ForecastExist := TRUE
              ELSE
                SETRANGE("Forecast Date","Forecast Date" + 1,ToDate);
            UNTIL (NOT FIND('-')) OR ForecastExist
        END;
      END;
      EXIT(ForecastExist);
    END;
    /* /*BEGIN
END.*/
}









